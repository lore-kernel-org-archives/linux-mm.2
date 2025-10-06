Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1376CCA470
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 23:21:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D0BC8E000F; Mon,  6 Oct 2025 19:21:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A8788E0002; Mon,  6 Oct 2025 19:21:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E5318E000F; Mon,  6 Oct 2025 19:21:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D41E8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 19:21:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A85F4BAF38
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 23:21:41 +0000 (UTC)
X-FDA: 83969263602.26.7C51D01
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf05.hostedemail.com (Postfix) with ESMTP id 01827100006
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 23:21:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ImO3W1Sk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759792900; a=rsa-sha256;
	cv=none;
	b=q7DwL+LpP+rC9wCSipufuwo+2XEqLEQOO/jCpF6ijhfKQiXBiAmpFHLpPTJZXY5owxIG2a
	eRhDz4jsA0lflVKxGNYv2YtfMD+cc2r/Q9NfEH7jk3XZc3VxYlN/d38gHZYuTf3hOr/j58
	wldLsO+5xvBtBHnc9YTDgLP8NbiUYR4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ImO3W1Sk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759792900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BlF8MRmuAY5ZGP/hSG05FFgxKgRsiLUZrKxnhJp/7YA=;
	b=tDkeZQb4LYtlOXV+u1MkjwONcnBpy+eGJE6h9fKNeMw0MtklNPtetcEQzSwyUwTQlOvtGe
	XyJrEmi97oSMhA9DyNQ/xvbBNGmZR6U5bOFLOn975jSARPcsoBgr6LfqEU6h1AAQK1baSR
	+SeC0oqVS/234mp7TUV5/IM2DZZZTPs=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7841da939deso5079955b3a.2
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 16:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759792899; x=1760397699; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BlF8MRmuAY5ZGP/hSG05FFgxKgRsiLUZrKxnhJp/7YA=;
        b=ImO3W1SkdOh+XFViIzM5fsZdomrqBTLzT2rmYsJjQ8gRcyugU87gE+GNnUENVE+hbR
         WSEH+WvzQzUJ61/723Nbh9T2lhoxH6jztJrntDXwwAJnA0knVjAGcMaWnsS7TfFtL0ZN
         hDoKjm3cZVPJ439XBsCRpqtmeeZocD55Yshw39HlPwX+cCo9L4PUe8oWHOy0SD4ZA3iA
         6+u3m6Mk9LOfbsxzEU552DBfkxqOKNSDH9ugjTcOckQLf2fycHws2KTX5cHOQ2vt2t35
         q5GWaM+9yjPIJH7N/7T9d1NoMv05QN/9tmAhnppw38/yXmEZmVItJdGgtG3wvOhLONKf
         gqjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759792899; x=1760397699;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BlF8MRmuAY5ZGP/hSG05FFgxKgRsiLUZrKxnhJp/7YA=;
        b=V/aMIoz0P3jQuwZlwmeVpolh1Gd4OxE1aJ72+RqaE6Eawn0nOk6uaAW9+okwhmq+jK
         p6iCT80sj+RdL5pCfoe7Z1vsWn5bPjnGZAu7eOKN93y0tu2xpuM5YKl25g+2O5VwOKtx
         RUae8s9sYZlpVxKv7Iey7dRsKqygn/W0OWJ6Vd8UEF5Bk/OIOByd/FRSKbpbE0X8s57D
         +IKulgydHkGefVPHIkXkInGAKXdsGlvyXlZUZGQIKVLKIQ4zEqvrEqeolNiDCkcPqjtC
         HCtjDYmXs/F9ZOvyadLGyMhzoJDkwRaoH22hsT8JTfgQiC8qfqPi89DpHv7XkklkKkvh
         IfCQ==
X-Forwarded-Encrypted: i=1; AJvYcCU5a4OzXQAdD/TmCuUgoUv1gaCIFcTiTJBxqoAEKq2FilLIgNGnl1M0kMAuPXXy6u9ESOVpLprRlg==@kvack.org
X-Gm-Message-State: AOJu0YwuJMvZns6v6YUp4nIfuEm60kxtxR4FIUHeG9dxH0MI//7AQEvv
	t0tzk493a/TeoIVuZrqHSXRAUt0YKO7k4qQwl7ak/wakzbmKiL76vZz7Sk/RiDom18/co131BcT
	00LDyWl9spxPppwQj9NRoYy7+m4f24J0=
X-Gm-Gg: ASbGncu2xncbSgVFO/WF8xj+022rkPaSzCDlTvGwOBa9PCzaUYORe+h2wyd3G0mEvuD
	OVZihns5WuShx38caarqIx8Pj+3Ou+42UfOUqRwQ4CyZX1fOEsclNePI8XbIfsLtCetTgTzGwEG
	kaKVYIKIGXUX0cXwqKxHcoqmHEUP+Ij4SK8ROk+Xb2G5V7GjqcTP1Z8h2R41ekKvKj5BeP+DbNY
	UUt6GsE4NhKz1dagWr+ugv/ZRJmemiveqjDrJntYP5fsNk=
X-Google-Smtp-Source: AGHT+IFbiIZLWXUzbg0MpPNz8jI3+5uhR1e00vTKI1xy/5u7Pb90M6pGakUvtknMmHcQXhggccYvP9be6Tx3vlFcycs=
X-Received: by 2002:a17:903:b83:b0:26e:62c9:1cc4 with SMTP id
 d9443c01a7336-28e9a54ef95mr136288395ad.4.1759792898721; Mon, 06 Oct 2025
 16:21:38 -0700 (PDT)
MIME-Version: 1.0
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
 <20250818170136.209169-2-roman.gushchin@linux.dev> <CAP01T76AUkN_v425s5DjCyOg_xxFGQ=P1jGBDv6XkbL5wwetHA@mail.gmail.com>
 <87ms7tldwo.fsf@linux.dev> <1f2711b1-d809-4063-804b-7b2a3c8d933e@linux.dev>
 <87wm6rwd4d.fsf@linux.dev> <ef890e96-5c2a-4023-bcb2-7ffd799155be@linux.dev>
 <CAADnVQ+LGbXXHHTbBB9b-RjAXO4B6=3Z=G0=7ToZVuH61OONWA@mail.gmail.com>
 <87iki0n4lm.fsf@linux.dev> <a76ad1e9-07d5-4ba1-83e4-22fe36a32df0@linux.dev> <877bxb77eh.fsf@linux.dev>
In-Reply-To: <877bxb77eh.fsf@linux.dev>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Mon, 6 Oct 2025 16:21:24 -0700
X-Gm-Features: AS18NWDafFk0nrI4dX1WXSkb90Zju3Gm0uidZQfWzJfIM8rRKysrrjNo3H_c-hs
Message-ID: <CAEf4BzafXv-PstSAP6krers=S74ri1+zTB4Y2oT6f+33yznqsA@mail.gmail.com>
Subject: Re: [PATCH v1 01/14] mm: introduce bpf struct ops for OOM handling
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Martin KaFai Lau <martin.lau@linux.dev>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, linux-mm <linux-mm@kvack.org>, bpf <bpf@vger.kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Matt Bobrowski <mattbobrowski@google.com>, 
	Song Liu <song@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 01827100006
X-Stat-Signature: 8qr5cmq6uoxiwj9kqgxoheij68ckhmbp
X-HE-Tag: 1759792899-291022
X-HE-Meta: U2FsdGVkX18C0Ol78147uC0axgnMZV4g5MbMN+ymOvgCIoNJac6x1bybiivmgS0m5eRGEap3GcmuzHIsW7dBg1Ghl8D+2miqI8M7ZL1z4xLQmEK88PiUXHJvpwqP3qkrij7Ez1DstVcvZgpkvvzZheC3Vcx7LA+RDp/2GKkl5BUbspINep5F1XjqlPblJx9En66vuIpSKxHMBKc4pBB6OKvEo7iONYSh/hCp6N0mEu06Dd1Ec8rgW9BqIurMEayppV4w3lBMdRVlO7xjPPliHJ7cT+NZWcWUUyYVIFkfYSzBc+E0BSVeHie+Ou0b7tQT3b4ZXzNbLgTTa3dJ81uPj83hDS7SYskF8C9b2cxCXJtfbGxbepuKBGjXwnngnlDeyD4sYgNYOg7e4ERzTFXVsSb/YaKjdIv/KiJOK32CEWqit2Px1AQBWxp8OM2LHQqcB/mTDZ8dn5aouIDl3T43pZO+n/T0FDwLx0V6cUpQ5nPgFXgZNkjkxw0Bp/3u/yCOvXl8/M/cxTNnGM5sibV5A0wyUy+JbbCW/+RsmXzGygfGmJkDRnf8SbxHegOf/JV6OhZO+tcotPG3+9Cwu11NwvdqXnQ4wBeDuzmhb4Tqo0lRlR3N95a0IbVDOvuEYAQ+HkQdAobsfzpqMvOHvcXupnjbtSi1VOt+DrkME8WjyQMbFC40CCBcW1YahR47wI45vnyPrWxWsoEpC9e2JP7iPm447mUGvOm++RxfSWvKgTzFXsDngzMIi1DaYncstJaVK67VEeZfiPmT262841MmWgE9FzvQNi945qj52XpxoToKs0ulE8/0JzmhvjhOYcMMGuq9bi701i7SXEQF95ZZFXI6c87ApP7bjj2B4XN4AKMWkXY2kQxeNYWlAqB8ShgnnGMoumdZrZWZOSDn3VRUFtyMnOwEW7R2CbaGBQdAGwd1QW6GMiunxQe12Bz/zUO+j2Oitg948QaZWHcW2kz
 qiiqCZTg
 yHD7Jq68H/rXqieD65lDhRWJFrke1xkqDw9Pf087f60wdL+EQmrddtkDOY/oJWXwcwvERulrWj/1rugsqvr8JXa/3XMw5vHqksD+4Bu7WS2HPSjPfImswEG4iEA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 3, 2025 at 7:01=E2=80=AFPM Roman Gushchin <roman.gushchin@linux=
.dev> wrote:
>
> Martin KaFai Lau <martin.lau@linux.dev> writes:
>
> > On 9/2/25 10:31 AM, Roman Gushchin wrote:
> >> Btw, what's the right way to attach struct ops to a cgroup, if there i=
s
> >> one? Add a cgroup_id field to the struct and use it in the .reg()
> >
> > Adding a cgroup id/fd field to the struct bpf_oom_ops will be hard to
> > attach the same bpf_oom_ops to multiple cgroups.
> >
> >> callback? Or there is something better?
> >
> > There is a link_create.target_fd in the "union bpf_attr". The
> > cgroup_bpf_link_attach() is using it as cgroup fd. May be it can be
> > used here also. This will limit it to link attach only. Meaning the
> > SEC(".struct_ops.link") is supported but not the older
> > SEC(".struct_ops"). I think this should be fine.
>
> I thought a bit more about it (sorry for the delay):
> if we want to be able to attach a single struct ops to multiple cgroups
> (and potentially other objects, e.g. sockets), we can't really
> use the existing struct ops's bpf_link.
>
> So I guess we need to add a new .attach() function beside .reg()
> which will take the existing link and struct bpf_attr as arguments and
> return a new bpf_link. And in libbpf we need a corresponding new
> bpf_link__attach_cgroup().
>
> Does it sound right?
>

Not really, but I also might be missing some details (I haven't read
the entire thread).

But conceptually, what you describe is not how things work w.r.t. BPF
links and attachment.

You don't attach a link to some hook (e.g., cgroup). You attach either
BPF program or (as in this case) BPF struct_ops map to a hook (i.e.,
cgroup), and get back the BPF link. That BPF link describes that one
attachment of prog/struct_ops to that hook. Each attachment gets its
own BPF link FD.

So, there cannot be bpf_link__attach_cgroup(), but there can be (at
least conceptually) bpf_map__attach_cgroup(), where map is struct_ops
map.

Having said that, we do have bpf_map__attach_struct_ops() already
(it's using BPF_LINK_CREATE command under the hood), and so perhaps
the right way is to have bpf_map__attach_struct_ops_opts() API, which
will accept optional extra attachment parameters which will be passed
into bpf_attr.link_create.struct_ops section of UAPI. That thing can
have target FD, where FD is cgroup/task/whatever we need to specify
attachment target. Just like we do that for BPF program's
BPF_LINK_CREATE, really.

