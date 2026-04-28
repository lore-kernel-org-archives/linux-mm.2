Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AEE5FF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 16:59:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E1986B0005; Tue, 28 Apr 2026 12:59:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 592796B008A; Tue, 28 Apr 2026 12:59:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 481586B008C; Tue, 28 Apr 2026 12:59:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 377C56B0005
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 12:59:18 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 85385160351
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:59:17 +0000 (UTC)
X-FDA: 84708575154.10.38AD72E
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf08.hostedemail.com (Postfix) with ESMTP id 715F916000C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:59:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rQe1j6bs;
	spf=pass (imf08.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777395555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VK5ahICXkL0MctIkCl6eavo2XIzw7vhC4fPYDrQjJ7M=;
	b=uAN17bAw+5dAr/d2aTfpDGf2VR9J+ZfJbuCyXz6vdFUU8qmu893KQGKzaE0GMhVt84TUf7
	TMttBkAGWiNVdtG6waFJ3yNgj/HA5ykw7alWL2xgBbNMN8KrqqsS2wXwtp2Z1/nwzkpjhE
	d1KAeETYL3Ow32LcfY7n07edQdXKl3I=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rQe1j6bs;
	spf=pass (imf08.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777395555; a=rsa-sha256;
	cv=pass;
	b=SWZoxotNeyhekgu0gSUx4bpvc9CD+DUbPoZWFudE8FU2J0xHm4gNR+bsexrE7QZXxz+/4j
	4biOmOfFqNzNGpJBCwuDt8V8AXkcwwOIyPaDSdPHo5iEcg6U6MhPaj1LxeoToFoOTET1HE
	4yufCVh/9WH5XHx8Zgiu3PmD5FbcaHk=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-43d76dd4ee8so10348936f8f.2
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:59:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777395554; cv=none;
        d=google.com; s=arc-20240605;
        b=UzeTiwi81xJWAlNt3n7XYAMF7leiKWwjuBxBJIzW5AmlUMKDzkDw85/iWP3tHQOMiI
         a7a+iaJt96zrnld4M6h6ZoAZCYgo3fGrJtvCdIT7BK9NNB9XDFqRbN3oA0N/YY+E8oVX
         zq6D0ziXq7pYx+NVeoJpXiAadt5kejbEtDOlji/0VQOz7BauL7dGkXylD6RL2GDu05fG
         FOFUyI7LtHWn3chpGpGe3oEIOkdeHbknmWMphElwdcc1IKvm/G003ojQeDa9bQjPJhIA
         cIh7SDZbs8rMlkhRwyBTc/u9hm+npDSqzlIQoWimV3+6XKiP0A+3mCPsnrj2KqVgRYUO
         yJHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VK5ahICXkL0MctIkCl6eavo2XIzw7vhC4fPYDrQjJ7M=;
        fh=bb8CA4JLwXJraXWuByhSkJ7mO2d6CX/Kc2gLiHJoWvA=;
        b=Q60IZCfKdb+E8tAmMbAlyO/xPdhxnFDsLMCm2YKOk6EWDeU0LCa5sHluubPbMW9Dvg
         gsxfYMWkQ7ANFeeJyQyI8m67wV+3mr+N9md69vnulaKrMV/eDZn84hGXs844bloESIgz
         WselTd/A1zHZKSc/oEr8LeXaOK/20EemGQ6H5RrYSIX0FhcQzvpxtjRqRz48D3x6K83o
         43ruTBR8+AIPGgH2/M/3llTiXSVOSHQrKTZSgc9TLL7WC+K76r+hxJh0GMMLXO6dnKuP
         vcqXeVZjiD9rNcRQ2L/+R5VJ+jg/op2r/9QLWQ95rswmHfZ1ynaJGPlWvH0jHi4Q7OVv
         8LDw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777395554; x=1778000354; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VK5ahICXkL0MctIkCl6eavo2XIzw7vhC4fPYDrQjJ7M=;
        b=rQe1j6bsoHiEa0FxGBJ44olu8rNoP18uTiAolwiupax2P0kVip4Yi4wYS7KEMeYisD
         90rdRm1aIHiObTFzMOMj7b1E7T+cSMDk4PIlICA+U1SeGthQBvPZ9rgXn9OEmk+irqrE
         DRYvxgSH0XM1ZyA6fCCRMU+SzHhziv1lnJkc572gMoo+L8ZCCI8pTtHmlQyuvE/09eqf
         sbGm1XOa9+wEvoMG5sLtopxiNhFh/SUsk8T7PU5MYe2Q/LzXYF4JLozLhMWTFe0ArluF
         WLXZBeExEeGfThLQEBbIWtcxK/o4KO5M+ZM5pn69kU3st4GgJG09BpULYw7wERbKoVxX
         oPRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777395554; x=1778000354;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VK5ahICXkL0MctIkCl6eavo2XIzw7vhC4fPYDrQjJ7M=;
        b=h3I5nB6dJQvN3RSbzWIiiNilc1oJ0ohBopsFKOxtCK8WupKrGu7FGybuAJ6N48MprW
         /j2ojgM4vrDFsoqE5CnK9STzsMCmrYwVZkxI1IOBvOvOQkYdFVkSTGc9rEyFQsCYbC33
         cnc+xqk6Z/hS+Q9NGxzp36fUd6cbfcuA/NgjhB5rwwCk3fTmpNRBwM0XFWCryVDJUnVv
         QSAgL/Fx4DoyfxNOus9pzyALG499iURMAy/cENtYvgkgNz+DAc0cSFJHqKtk5yJskm2t
         cBw8KZlDK70N7XXryHzfkb59CdyvbO9YaSTE+TMP/lXiE6YHRIMiG+JfrH9SRngA9hP3
         DY5w==
X-Forwarded-Encrypted: i=1; AFNElJ/UgJqQ+SSz1pUwPmh6qIWM08OPEaXygJghOgYRnMoTpLWgUd2Ey3u3ZQHVHzH1zuQeldA0H/ykWg==@kvack.org
X-Gm-Message-State: AOJu0Yx/e/KO8/s4fSxqfTxEnsE5zDVCaGB7MbKJ2MCZULT05oODX6pc
	g7//ownRrPW3Sr9a4dtjMfhKSz2lQ1CY7DUAaPjjh0WcByNFgwtMOpvqtcIZ21tXdGiQfMAPTL5
	h+Qn98sQSRAZfBk1jZ+kQ/pblT4eAIGU=
X-Gm-Gg: AeBDietW8nmUboURbtcTWnK16eQzjq84ULD3UMRKnu4p6qBVdhhg2RYipuGmyJjXtXJ
	HHHdyhnmjaxznuJZh1eVtYFKoC8jhdbKnY4FBuxJ3SrHNf1gta5X+vXr3KKil436Fbh+pNMiBLl
	m9EFtgT+2SE1IR3kqZ+Fo3ILB+yLeVGv8afk5skVvBYREYgOiBJ1LKKEIRvL6f+fzRY5Jihn346
	b1G2cKaQGAgmWSCx+WKTduJdvKY6V4gfHwmsfmaOD4Cx/d6icO1EnwxQfP8Iik0KDDw6QgZXSwu
	WbaVUG8HdAJXOoyWyMx00dRV1ZlwHlXVbaMsuWH0Eu21ms2TVyxhh0bqgFOO4uEZitjKGHU0YqG
	IgFSlSU4UII37/0Rftkg=
X-Received: by 2002:a05:6000:40e0:b0:43d:7b23:bc99 with SMTP id
 ffacd0b85a97d-446489636b5mr6955778f8f.15.1777395553547; Tue, 28 Apr 2026
 09:59:13 -0700 (PDT)
MIME-Version: 1.0
References: <20260427-page_mapped-v1-0-e89c3592c74c@kernel.org>
 <20260427-page_mapped-v1-2-e89c3592c74c@kernel.org> <20260427051758.e1b714a4b567917971920eaa@linux-foundation.org>
 <CAADnVQJ9JXrtAnFgE8UFK=W1GDeT6T6Wi5zB7g0AfRjU8M4=bQ@mail.gmail.com> <2b2eecf0-72f9-4959-9663-c80e3cd0c517@kernel.org>
In-Reply-To: <2b2eecf0-72f9-4959-9663-c80e3cd0c517@kernel.org>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 28 Apr 2026 17:58:59 +0100
X-Gm-Features: AVHnY4I0TqqC4RFs8UKqyAoce0ZbMMM6zkhJo0hxpAv6LX8MTNNEkUpX04aH9bk
Message-ID: <CAADnVQJp30BhhB6N3-GxtYmMpaMTaYvGcK9R5=8PxWD6qEXJhA@mail.gmail.com>
Subject: Re: [PATCH 2/3] bpf: arena: use page_ref_count() instead of
 page_mapped() in arena_free_pages()
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Yoshinori Sato <ysato@users.sourceforge.jp>, 
	Rich Felker <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
	Matthew Wilcox <willy@infradead.org>, "Liam R. Howlett" <liam@infradead.org>, linux-sh@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 715F916000C
X-Rspamd-Server: rspam06
X-Stat-Signature: p547xwum1ycnnnsktxkzmdt4ympxagfm
X-HE-Tag: 1777395555-599708
X-HE-Meta: U2FsdGVkX1/kOydGhRf/Rxl3ou7StNvEsv11NXI7b82beWWaXAtq4xpbOQV72Ei4g54xMCZOVzSyKgQVNGXVIk+ooSXQxepCr53TQjHUlTbIR5601KZJRdeHyUPAFmdHgl5JpDDkrSOScgKm7cCTg66zgnY1JZsHLscAZUVrxeZYB+3YvtGbRzo3CCmrg9wmLon/0T5LfOGLX4GuggJ2C5S3uTLCQp8ylhb1uw1iHh0L7Rhw5X1jLns/xIPFA18XgvRayurNpwP7EFbkLk0dU7AUzwlFh4WiXj/fXftcfnJAQKZq1S+Hzo6NPxp78osyLZn8xFa/u3lD9SdOEJ1sqKkMA3NcOY3MMDBTqWPNWNpME1mNFWgF75AfSNJw4NP15xc3itT8Lmo34zA3sXnv8TwXHZHFSDukNYZG0qw5USQ8xRY3MjXGx/dAlotqSjFAzSlbWUIuTUWGQGgA25hLLkw3hWdQPogJsm8G1ifn62+WpTYNPypiMThy/m75n2gxmykurFBIVI4GNsnBCGGNBHLgQO47+VhXbuJg6zuSy/SEaD5b4dnWrpGLx7qe9CpUcpCnvOAXvgFNTxaMqR7WcD9SruywL/PmX4cY1zkaBKAWMFQv2C8YmMuq8+6hb9UnlTtxwdrukCglVLFNoeeRMzJGJnXqTRiP08cJBcwT/FgeCjIWI29MOuLnaFeJoEk5cA31iio4aZLPe03yAlLcyHOhAzAdQavlGNOvy44VYgB9p2TgTNs/yttq0+dLfsdXoU1rFkn5mGeqxWOAROcyef5Cw976pprYM7BPDBcJd4zHlNzOEVuxIvH9xJ+wqLlYCJem6LlyJhpkVAsP/xcVkuHLqBxYnKqFtmGnc+YSDzuY1pYuE+l5ohpG3BHLHjlftjRBKvfXGKla3m7NqyEbz7ZGvgxdfmj3IiiIEhOzQA32htZyp07I86ChzxbSJsY/TaSwPtLkOO0wFfPFJie
 iYWcGdTJ
 ApwDH8hV8nLO92FG+fMs46eKLithB8UYpIGPHKWSfy/Yi4lb5kgyS0WjxDT5nDVWZLF4U2fIwsivBHehhZCT4KGpWVoYU2R2YPk7TgPpUkI43xmvhskeCv1c7sZqJBLu+6yn3137FIPFVO0T8qgkagjsxmCMHLlUw+kEAWqxJ0coPdVCE3nFnZ73oTbYr3SrKVSDJRobtIOtgQOD9EZsEyGVgRcGZ8AR4x5dEnV2F+X6GZIhIcN9O1Suixr8JNnk9Qg1dzrfNZY47H3tzMU4FASr2EbTF5eJI7MW0MxVLucqM4IinCgEpLkrpJ6kD0VamkfNxaMkR51GzFS/VMBII2rtx27rAo4EM5oyrOQ+lFZ5qLDpZBL35y/KNCsqKDAPL1XPBSJ5/UUV1UOY8tmwrDUce/+ayboAGDPhVjoQRcRmgFrNMF9nxMUPG+MbSJv6NA7vtolibo0xz3nEDX+PACebQbzFyv8xORIUqEOI/ewLkdnmiW12MXe8HpteDe4hTjSRZHeVCyLKRgjgR9QbQNMF0VKeOkrLUfOX/4j4o9nRJYrPxPo5RoIeBew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 9:16=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> >>>
> >>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> >>> ---
> >>>  kernel/bpf/arena.c | 2 +-
> >>
> >> BPF maintainers will probably want to carry this in the BPF tree.
> >> That's fine - please go ahead and add it.  I'll carry a duplicate in
> >> mm.git so it compiles.
> >
> > We cannot carry the same patch in 2 trees.
> > Sooner or later it will create problems for linux-next
> > and issues during merge window if more changes
> > are done in the same area.
> > The only way to share a patch between trees is to
> > create a stable branch and pull it into 2 trees
> > then sha will be the same,
>
> As lack of stable trees was raised a couple of times in the past, once we=
're
> done with a transition to a fully git-based mm-next workflow [1], we shou=
ld be
> able to provide stable trees.
>
> [1]
> https://lore.kernel.org/r/20260421094216.8dfe14a8c62f2420fa5aace1@linux-f=
oundation.org

Ohh. Thanks for the link. Full git sounds great to me.
Reading the thread it sounds like you guys want to explore
your own way of managing the tree.
If there is interest we can share during lsfmm
how net and bpf trees are maintained from git pov.

