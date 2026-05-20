Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D2D9CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 16:27:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48A5B6B008C; Wed, 20 May 2026 12:27:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 461C96B0098; Wed, 20 May 2026 12:27:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 350A56B0099; Wed, 20 May 2026 12:27:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 267686B008C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 12:27:43 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E47AA160628
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:27:42 +0000 (UTC)
X-FDA: 84788329164.08.495EDD3
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf17.hostedemail.com (Postfix) with ESMTP id D5EB140004
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:27:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BqHYgZq2;
	spf=pass (imf17.hostedemail.com: domain of jannh@google.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779294461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2/ehmERhlYhS/RkqGUNfD9Ql0/efI1kFuk4SkaC1Rv0=;
	b=adIlXaR+VkXc5nJIrmOnDggsU1j+5ZjqKQdVENjbtGJcNYU/Urx9+onBaHGb5o3b1HnXRd
	9bZzaJLwkkRmJ8EFT6/8M4tuwfgwBkf9G2ZU8QG+MjLuZg2y5kMqOFDpSySZlSOijyo3/k
	VlnqHdpYf6eqE/JbiE26w5E4lJG/pPI=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BqHYgZq2;
	spf=pass (imf17.hostedemail.com: domain of jannh@google.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779294461; a=rsa-sha256;
	cv=pass;
	b=r3M0WBHOX/K3j1C6+MDzi1AE/z7M57dX85QEBwNrXxqFm420YNNffjJCmLxkmISNE++yUW
	+9VwKhgXm4O0upi2NaTbV1PaxUTtLwXEdzGvkC0rKRJSvt6niJ7A1YHARkwQp9RlUaYx3H
	Tslk2ewWp60+rThDYWo1Z71EY6Sf5uU=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-671588ab0cfso275a12.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 09:27:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779294459; cv=none;
        d=google.com; s=arc-20240605;
        b=T9uvTB5hDfEJqBV4ZSytjU5O1F4I+Z+z6Im3Ho0GY7loj+hpkxW5BXMsKseQDIs4sj
         9fqgs5zPeUN5JkZ4pvkFOhNUTPQMYFvXsCdy19mtXza3fIKAoU9v8YVO+onZPGvDYLa4
         Bu1uxQyvlcZiLSTUd1a+VGZtCr6MSxe7vvBQrKSMhi4A8z845OQV8/loQmT6+5hQcsZ/
         D3knENIRsOGobNUD+MSuGWnuWib62FYVtMqjI+TUtXad5KaBGXdrRW2/Zjzm6RQ4Tldt
         42cIoimLD4t9z/S2kbJXkoHjQQxLiRxx5Pg/FpARwiDnIuiSEmeeY4oItuV2Aa2ptpw2
         AHVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2/ehmERhlYhS/RkqGUNfD9Ql0/efI1kFuk4SkaC1Rv0=;
        fh=i/V/H07+bLq+YhMt8ADrcoRENodxX6/DjUjNnmTfgn4=;
        b=FwAlkh+HOGLQNZRDV+S70N7wSNAAwmlDoyWIjkQAqGTENYPM+TZaOHesp6EXHCBejQ
         Vfc0miatlbarNge9NYYjpAUb0abtRtkLmdXhzkL27/moGoLCiqmRfeK7wSl+jP51QTRx
         XKWxZOgh7BfwRY98qDkw4s2pMOWdvmCfIGl+mdYaNt7wcpqCjAKkcFNaZ9qk1nIpPB0E
         cIWxwtVYczYE/ynCOwke8DYT/TJjzGAuXeaV5Zis3OCxOmeYSOgZCElOLDRpNG2OzjME
         lagqcPg6DbA6h17yq3lfXUFcwCTeGNlgGVRLJLRzzq/X7zUrpvEbOtvjFUzZKbujmbL2
         Xrag==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779294459; x=1779899259; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2/ehmERhlYhS/RkqGUNfD9Ql0/efI1kFuk4SkaC1Rv0=;
        b=BqHYgZq2uXXlAMY1aDpMfg31+FjR7cOMgNS6H3IBFvRmg5vyRAprsxWB6LT5hN5Evy
         ROBw3zvE9WKy8RSGkGwCzLzmLc7UmC5JKEtHEYwmFgFDLFmhao2zSgx3jwAtFimvV7lW
         K+w5sRzOEguK3V6R9TijsagZsl3bvOOLvM/F59UPSzzvTtQ38pUE+uLKyk9mO6CwZFYh
         oHC83m/3niJ9ttKViCvWcGTJ5y7GLdMdMsn0HdI8P/2oalt++wPPzDkoWiVDUCMrKJ5b
         pOiN+n1fQNuG/49pfZypYZiyoySEDAI9pRQeFZgeL2xtnXaIijy/RfE3w6ru63yM5xqZ
         ZU8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779294459; x=1779899259;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2/ehmERhlYhS/RkqGUNfD9Ql0/efI1kFuk4SkaC1Rv0=;
        b=Jg1f4GBdsIPuqmONu6UwGbNEsmtzZ7n9psXARF5/GlAMjxjE1HoYsGKrp8umkQGlr2
         WHIBvBE6hg/Xss9GXxQbFlzbfsQQ8lBGf7zotxnT3n+Zi+0RxxkNJzoCaWpX+lX0suP0
         VdOBKZ3bcn+w7OoqpPBX7i2csEZiH01fbYGMeKRhmyB2oMr/H5v+CDVQcNKeN4naXzno
         KNbXQPobY9O6ilqZC9WbQqcFPlFiDYeMUF8nZHo73nyJCzKlFo2xFaIna2OKh7kmEA72
         y6fJuyoc5f754VzNlX3ifrlTEe57pOO6Cj3OvIGeIkKw3s4ZguOZUEYrftoDge8pCN2p
         soSQ==
X-Forwarded-Encrypted: i=1; AFNElJ8XBdjYP+VXmINjXqbFu/ChorBlMR9Dp7Ff2lQWO9nsBWwReNl381VmXdiUbO9XkOuKIhtYb816FQ==@kvack.org
X-Gm-Message-State: AOJu0YyZu5sEx9ppFbR9sKDHAHn47qNVq3XuTyqXePd3QZKkgoC7bogd
	v5gILzbjst1JjSNw8C9QEamS5Y90avLCRJUlSMPoigOPEFW7rFAEZwEx6OXnc4i/kTNNNkP8ePg
	R3tBD7t+jCEibtkTAG9Ud6IQlBXMf6fqN+EkvuZgEl21vsNDyE0u7RExGRg4=
X-Gm-Gg: Acq92OEaK6xw//1ykrTC66jBG5LHcXyW6ANemonUV7zbo4Z2yFYeN+2118m+PqkQqnw
	ymSYSavXvbxDSXxaBwu5+56PA1rawK+bThc2QySpPXMwz7wG2N/k0mfcSbDDDH3tL+1SUyTuoPz
	+NwWo+yiHRHnZbWX/Lx+lfzwyjg6M4cI6EBP1w6345Chp4b87vtI2qrVjXTVrDNBHBYatc0m9dU
	Yz8pOap0nsiTMdfS62CVknmknpK6xKa3GOmedFgaysW1o04Cr6bY7zJ89Qw4LzVGQQyOj+yhHE6
	S0Dt+bl+GLwDRIZ1+u8ZZ7N9idVnjdUTWWe6f8WyWs6LZDvA
X-Received: by 2002:a05:6402:3252:b0:672:117e:55d4 with SMTP id
 4fb4d7f45d1cf-68486e6d77cmr232851a12.0.1779294458623; Wed, 20 May 2026
 09:27:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260520-work-task_exec_state-v2-0-9ea88ceb09e6@kernel.org>
In-Reply-To: <20260520-work-task_exec_state-v2-0-9ea88ceb09e6@kernel.org>
From: Jann Horn <jannh@google.com>
Date: Wed, 20 May 2026 18:27:02 +0200
X-Gm-Features: AVHnY4JShk98EMJMX-2Kzlc_yRoA-_1QF7f5x4nfEcMhDGYYhc5s7FyU4CplMCc
Message-ID: <CAG48ez0kVA+Rw+pHSi5-JLf9KTh8Y9Am04W567YS=imgk+b7tA@mail.gmail.com>
Subject: Re: [PATCH RFC v2 0/5] ptrace: keep mm metadata accessible past exit_mm()
To: Christian Brauner <brauner@kernel.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, Oleg Nesterov <oleg@redhat.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Qualys Security Advisory <qsa@qualys.com>, Kees Cook <kees@kernel.org>, Minchan Kim <minchan@kernel.org>, 
	linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: xc1bpuy8iqurwjfeu3ydhwfek7ke1bdc
X-Rspamd-Queue-Id: D5EB140004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779294460-445127
X-HE-Meta: U2FsdGVkX1/zbd+aJn4QBykcWVQXilwvNElj85M4f/OzQbm+Ekazk7sIQGhP4eFz8G3MJmxXaO3cOUywYaMkXrO1DD4MdYlnJbidWG6QHyPBE5xlGhpaSO0eG2tpHpFpZboCdIBT6VPkyaph2RxzEwnVU7OwokfOo986n0IW9y4M4i54POFYa8nA7H3hAkOYTZBDxJMXjIR3W2FmsEA6k6CzuwWW/3U1lNBAJp4b65B6SMk9Hj7bbGytWhRTgRKMmuCtZNgKPgVgDfHHMMMP2SolOtvAXsW74Vg2lSA0Oz4wo7CTgNCjt6lI8lyDJJR0rOcMa2ptjdSzXVvkczrSiXkpI6spFQo0kmiJ1gMv8p7rXsKdcQPbeYV0PxD8XWRWd6ux3NJYYOz8fzcJksw8eUkdFilCSW3JEs4hbjqtTazO045bijqjSBesg3ZQq4YssbAh2lciA7ABk6iWh6HW8qzul68oWzgUgJDYOI1KTOsWPfaNB5I5E05L4coTdf/3t0rHytnCAjJu6POapcuZ9bwhIHtx50j00uoFReSWsFnSYsq5Zku6H5NbbDITSDQ07b5VPFRqJkq+6cNn1zHbFFIBreOMcgL20w1kiJRNottgob1uqA6IeqmVydHXok909nHQZ2jWRkIE+vqMjvAAZ1QUCRsND0TiucYMx8LAIT4IrBLZ87yEMx0z0sn/u3sUWMGwSSbXDp+ctVBJtifRQKeHuIopAYMTCg1L0xB9J1ntX64qeeaAzEnjdUn9D0pAe7HsV1iJjFzrPRcdtl5ABGOfT9ZXryQ7Dxmsz0DAtS7HU/JWJm5N+echEeIKkmH5DEmSuEsR57lQxtx9uHM+ERZo64rKm3KqfS06qX9otv0rgIBV+oYH6KvaHelhJdpRfS2OfMgiARs3EmVVA7Tm785Ku81fbQSlBGMNE1+WR3cIhKVvLgnmv5pDWnHP0zN3R1JYkFRLl+RGvPpofwR
 l5G6afFQ
 ise8UXg5FfBCqQEHA1yo7AZyUesIv0uLPuPP8Vuqybng6ruaEx4+fc/A6WkwBzva4DIZrE3p8PTul26BFwUY1eMrTkWTCTFNubbv/LcZvtcYkkVbZMxMFxtTBCjrtqCdyATFrbgPTLI5mUmCIPEzS8lDw9FtcK/Mmr4edRCEjfHvXQytyOmxNqYN7IJr6ELlMDy4GPsbHxQelwZ9yDoGtJO1lFMzmpmBvhDRmep0Rm2IE5eZf5T55DmfEhzp1gaH3ps/71eUJPfqXUEYQj/OKdFD7xNsyx0xNIE6ptPKjq0ooodJExgFlJjC31A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 4:43=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
> task_exec_state is the privilege domain established by an execve(), not
> a property of the address space. Following the model Linus sketched in
> [1]:
>
>   - Every clone() variant - thread, process, vfork(), io_uring
>     worker - refcount-shares the parent's exec_state.  No
>     dup-on-fork.
>   - Only execve() in the child allocates a fresh instance.
>   - Credential changes (setresuid, capset, ...) and
>     prctl(PR_SET_DUMPABLE) update dumpability on the shared
>     exec_state.
>
> The entire fork subtree of one execve shares one exec_state; a
> child enters a new privilege domain only by execve()ing into one.

Hm, thinking about this more... sorry I didn't realize this sooner...

On Android, there is a process "zygote64" from which all apps are
forked without exec, and these apps are supposed to not interfere with
each other:

frankel:/ # ps -AZ | grep zygote64
u:r:zygote:s0                  root           871     1   15352744
230812 do_sys_poll         0 S zygote64
frankel:/ # cut -d' ' -f28 < /proc/871/stat
549023406592
frankel:/ # cut -d' ' -f28 < /proc/$(pgrep calculator)/stat
549023406592
frankel:/ # cut -d' ' -f28 < /proc/$(pgrep photos)/stat
549023406592

So I think with this series applied, any app could use prctl() to
influence the dumpability of all other apps, which seems
undesirable...

Android also has code in SpecializeCommon(), which runs in a freshly
forked zygote child and selectively makes some processes dumpable (if
the corresponding app has been installed in a mode with some debugging
enabled).

I think this means that Linus' suggestion of always sharing
dumpability across all forked children won't work.

