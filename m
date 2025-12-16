Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50496D637D6
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 21:47:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E7506B0093; Tue, 16 Dec 2025 16:47:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99B796B008C; Tue, 16 Dec 2025 16:47:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 894FB6B0093; Tue, 16 Dec 2025 16:47:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 747156B0088
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 16:47:09 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 39C7113BB20
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:47:09 +0000 (UTC)
X-FDA: 84226670178.04.E067E1D
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	by imf03.hostedemail.com (Postfix) with ESMTP id 224762000A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:47:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="YVF/0agl";
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of groeck7@gmail.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=groeck7@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765921627; a=rsa-sha256;
	cv=none;
	b=XlB2ti9kImLdW0UzcG6C8nxauRHSkJKIZLq1rp+OvPJ85apBWBRPFvU6iN1//wA2dMExiK
	Hhqi7GlPTR35TVMmYptOd3EfL2jgbIxyMR2+LQ2S5rFQ/YwQ+8FBVPzXDnFp813QRDeV1A
	8lACOcqira4vU4TquycC75iOSN3Vqsc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="YVF/0agl";
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of groeck7@gmail.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=groeck7@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765921627;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tIy3H/bKd2uTpJQCAIuCXiDJGQW8etiIRlL1vysNfVk=;
	b=ca71say11TQwM3tcR7aJZ3t+3lAhlZ/D/OUuLu0rNy32bFRGRPNsfWsQHizC0iXgbj+IGg
	9+DAcqWSifpcnycuEpoHO8HdkS8+63SgCdkgorvKTDitR0cX3NanwG0EEZjXgCM9Z4hnwQ
	FaAnhrAsY5/UHe3JOHQUSWP1tFZ4Xg4=
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-11b6bc976d6so7030448c88.0
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 13:47:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765921626; x=1766526426; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tIy3H/bKd2uTpJQCAIuCXiDJGQW8etiIRlL1vysNfVk=;
        b=YVF/0aglsFBD60S/4S13eRXFasH4mkQC+o1BG0uhe8gCTH+zIaaY1O4YAJV9+tiMnX
         IjqbOe0u2NB/cxbzCAYzrS9LUyEeJXE595Bmi0FvIEY5tGkiu3yrDiolpVO5B2i8JAVK
         krKu6A2FK5a+7wuzqzr5JjZm5LUopiFQgJJnMk8imNVYzpZ1w5cTzIRJgc2FjuTk1Y88
         Zwdki4A1eCeG/HSyjGU9tjyN8hN+UZj3DXpShCxe0FsXSrw1tSJo5e6mr9vcku52t5PV
         f9hNj0YfWyPQZpDMZURFEVnSCvGGK9izN8KOe9dU+OpdZKCnJHqBCAA4LxnzOhC1ndY9
         lpFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765921626; x=1766526426;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tIy3H/bKd2uTpJQCAIuCXiDJGQW8etiIRlL1vysNfVk=;
        b=wkU2OifQvEfHxhTUTZyooIYHS/dINCxfvvOGcEoEdF7ibktmUsNCr8Vu5aXGJxDS4X
         LxXe5Xz15y9JGNA4FwEJpVxMypuwrlSZMT7zWXaIlsEtF0q1IxhGADC4I/LraDivAygR
         b/l0c1CzfJPD1Qd001m/25zp2+iIlHX7pRVPhWgtPspRZSTOw8u8/Dcg5qORjqw+uEqs
         UGUL9IQKIgEHx0jdkIr5sPbfOgSxgQ0aZ35AXG3eXoO9QfEVGREqpMq2z1loc3zat5lM
         LdOtNp3sadxuPRXVPvjMTvBFv2pQtEdvDtTf3eLVHUZGbLxSnVcmqC1rhyYXO032sr1m
         ngPA==
X-Forwarded-Encrypted: i=1; AJvYcCVFF1YnCkTJOULdPz9S8Ggw/enrJrIu2Lx7xzxg2blwnv6ld18jbFoT0r3H66tqOX15mD+ZNXyiow==@kvack.org
X-Gm-Message-State: AOJu0YxntMBSDtJv9ngANu09y0W3in/v8mhkMuUw+UomDszEAw8JOREe
	q+mfVSDsvnbjRIkCWLYvKvW5UiDeStt3+PAvryC3B5mezRqi3pAzEbTx
X-Gm-Gg: AY/fxX48xKU9KGeKZxS2eokTdYrkB6/OAu7Q3Dc99yPUC/GYn4O7rd85UppADC9n8uR
	Y5+T7RSeYcXrmXFm1IDlLBI+8Y5fPlHQCYgCeQ2UkGdvDyRnN5PYHStm5rzS3GCUWDw8TSVlFZH
	sRqhGtraSEnbt8F3KwNQ7fyAwD5m5xiZfjJN5+EWukH+BjgYXSGT3J5c7mPgBSJ+mH9hCdACfXN
	yEMF1VwAA64K+QNuObipTcLIEbaKnlVT7Cd8reKAipGQMM+enZDYYEj3TB/Q1uW/Csc+EvJE1JC
	mimoDe3wDxfnjQH62I5Ezw6JKTPwVdKPjCvum+CKuRG5TExpFE0sqSfyb9A0pG/UjraRXvONF+8
	JBQTNynJ4cH531/AXujYYCeLGrpfhRoYp/08D/pSeKVrEpqNUQpYN3Zmhpz5kxee4501Mhr2wJO
	67zdnmgECaULgDgl74pH7HsruX
X-Google-Smtp-Source: AGHT+IGhrsRdYnMb20yhHbM5gR2xO5miIHn0uD7KPTf40H+xoJIbXbWWBoGAJMYWVKRHpvd03NKEiQ==
X-Received: by 2002:a05:7022:ea48:10b0:11e:4fc:9b33 with SMTP id a92af1059eb24-11f2ebc751bmr10584670c88.1.1765921625694;
        Tue, 16 Dec 2025 13:47:05 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11f43ced319sm24433456c88.9.2025.12.16.13.47.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 13:47:05 -0800 (PST)
Date: Tue, 16 Dec 2025 13:47:03 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Dave Hansen <dave.hansen@intel.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kernel-team@meta.com, Geert Uytterhoeven <geert@linux-m68k.org>,
	linux-m68k@lists.linux-m68k.org
Subject: Re: [PATCH v2 2/2] mm/page_alloc: Prevent reporting pcp->batch = 0
 [mcf5208evb boot failure]
Message-ID: <42143500-c380-41fe-815c-696c17241506@roeck-us.net>
References: <20251009192933.3756712-1-joshua.hahnjy@gmail.com>
 <20251009192933.3756712-3-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251009192933.3756712-3-joshua.hahnjy@gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 224762000A
X-Stat-Signature: dsut1k3mi6ncqcdwt9x5h384h6q1f753
X-Rspam-User: 
X-HE-Tag: 1765921626-780368
X-HE-Meta: U2FsdGVkX1+HI8EpWMJSWlmPgRxf0LINLuU8xiMc/Sy8N9k3Jyp3tjjhD0KkD60bWgTn0tg6aDtTHeIQlae5ODXn9ANr33DyhhbKG8lyKeXtd8NQ7M4056zIvBs6GaZ1/TGaiCgE+CcuWoP/UcuRBfB2tm1snqu3hzdXH+C5UoNSHEzZdx0JR5T7VK6wL0XUIxrwHS6ChTwLEOQVinRooCTdJleed0zTk15qpSZY2T9B0vjL1CdwoFMx7Svz+hWVHDb2YbGULqczhFazhfQdU0Yw1xJmul2Yj3hHkQcq2ohB28RMGprNYLBfzdEvygynyxl20n62rb6SqPL7eWZ/12EiWgMMCmtm/Cub+aNBfn7ywIa1eqGRKCiSGrbE9l3MpSNi/70hK29o1A4ruWCC0BJxv3VshSYij4FEpVMJmY4HowAxOkgYpsvtI2uZRmONr0joNbPywF2OHSqxxjYx9/mWuCuuOpBT1W+XfFv0OWRNwGDs/r/GuJqG5+u+ZMsROoKpdLGtaj5fP388VnyJDcDbppmJfUiCui7nZpy+2FAtRKRVA8RU2tEkz8YQHDoworvzmitBXbiiSrrMD9tGh86SsawVhDg/q1TrUTW9LkCzIiKgPJa3/3uVOAJZ2wZbMVMfTiCU9WN0e/QJlGh0cPN+qgWJj6bD0w1gCK55/F+76uovYFztq1AfSA3uUiHA8/5LNK4Vvbci9YHbuhX/Vma2E7D1/8bufHY8RuMJTdX7mIYOLMcn2s/7SrgLzDAT1ovMuPGCElAgrYMHpwiID9Tl/C3PI/1SIHOHKu8SgIcFulVDwgYtFt3+CPZ0CW9UTpCDAbizlKMjOXVtaw1IRB501mF6990qsduGKubIh6Xd/EaaIdMQsV9qBp7bqU8Dn94wpLVXzXd8/I8zJLQ4d8Jih4b1+49y8PwHosAiIr8WYc4TNGtb1Ma9EmgtK08p9yt4TWwrf0muFW3CkZg
 IH/cOj1p
 1qdYbpKkQ7PzhP3aIHh1zAm9F7DLGvhp5Hyj+JO5dAmM0UABzq3ByGhHRj/j1vbkBsUorLei5x0Y6ihX7m7NJp8xT/BxK/MSzejILuIdY0OfENlUuFysZ83ppA/ERuZR0Dzk1vA0/RR7K/5teVLch0JR3K/371lcveP1En8uF8qEfSqysil8C9bEfWBsJZ1Wx8ooqasUNRIpXRWXZ9RpEopSa953TtJHgLZr9AaPCHk6/c/uNWjcMDssSuaf+QwXQTqbL0K+AQLymTYV2UCaO9k/3gNAtLLEGPq1s/uwsFQUSrfw5ArmLK0keT3/csS9063V7C0N11rm2a8IEELQKA67Qhfv+NTaBNoNZrcwkJPiv7hf5w/dZMnAC1AwUPkUovGm0WcGE8LXtIh+L0cbn6ZOsq2OumX4ppjFcPYpNEd40R44KpOPoV3LzQNmHpDvInL9kiemBoy71EPnTm1984aR624zlC/lLdwXcXZfpPukDh+n/QCSqORKee931KWduM2tqZqNDPUPWu6YpI5n79AjdrIK9xDZcp9iALv9EkPtiTrft22AllHZfGPcxPWq9FWd0QNosMLe+yfcnPPxZULws1ln6wHVutNoHZJHnzi7vGM2UrHFxEAPAhGjNBDPydNll7PqffBWrCt8yZRRc3CxRcfkDUYFVASjEEKnvO4d0FdsW0bTMA/0Uso2FJM06btp5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Thu, Oct 09, 2025 at 12:29:31PM -0700, Joshua Hahn wrote:
> zone_batchsize returns the appropriate value that should be used for
> pcp->batch. If it finds a zone with less than 4096 pages or PAGE_SIZE >
> 1M, however, it leads to some incorrect math.
> 
> In the above case, we will get an intermediary value of 1, which is then
> rounded down to the nearest power of two, and 1 is subtracted from it.
> Since 1 is already a power of two, we will get batch = 1-1 = 0:
> 
> 	batch = rounddown_pow_of_two(batch + batch/2) - 1;
> 
> A pcp->batch value of 0 is nonsensical. If this were actually set, then
> functions like drain_zone_pages would become no-ops, since they could
> only free 0 pages at a time.
> 
> Of the two callers of zone_batchsize, the one that is actually used to
> set pcp->batch works around this by setting pcp->batch to the maximum
> of 1 and zone_batchsize. However, the other caller, zone_pcp_init,
> incorrectly prints out the batch size of the zone to be 0.
> 
> This is probably rare in a typical zone, but the DMA zone can often have
> less than 4096 pages, which means it will print out "LIFO batch:0".
> 
> Before: [    0.001216]   DMA zone: 3998 pages, LIFO batch:0
> After:  [    0.001210]   DMA zone: 3998 pages, LIFO batch:1
> 
> Instead of dealing with the error handling and the mismatch between the
> reported and actual zone batchsize, just return 1 if the zone_batchsize
> is 1 page or less before the rounding.
> 
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

With this patch in the tree, the qemu 'mcf5208evb' machine fails to boot
with memory errors such as

S01syslogd: page allocation failure: order:7, mode:0xcc0(GFP_KERNEL), nodemask=(null)
CPU: 0 UID: 0 PID: 34 Comm: S01syslogd Not tainted 6.19.0-rc1 #1 NONE
Stack from 407d7ce0:
        407d7ce0 403df960 403df960 00000000 00000001 00000007 40027c60 403df960
        400c06be 00000cc0 00000001 407d7d7e 400bf614 407d7d34 403df3ba 407d7d14
        407d7db8 400c0e5c 00000cc0 00000000 403df3ba 00000007 00000007 00000cc0
        000d8000 00000018 0000006c 00000001 00000000 40fe6640 00000000 40fe81e4
        403ffa40 4085eff4 00000000 00000400 00000000 001008c0 00000000 40854041
        f4fe0000 00004041 f4fe0000 00000000 00010000 403ffa40 4085ed00 4085e800
Call Trace: [<40027c60>] dump_stack+0xc/0x10
 [<400c06be>] warn_alloc+0xdc/0x1bc
 [<400bf614>] get_page_from_freelist+0x0/0xfa6
 [<400c0e5c>] __alloc_frozen_pages_noprof+0x6be/0x8be
 [<400c1358>] get_free_pages_noprof+0x16/0x3e

Reverting this patch fixes the problem.

Bisect log is attached for reference.

Guenter

---
# bad: [416f99c3b16f582a3fc6d64a1f77f39d94b76de5] Merge tag 'driver-core-6.19-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/driver-core/driver-core
# good: [559e608c46553c107dbba19dae0854af7b219400] Merge tag 'ntfs3_for_6.19' of https://github.com/Paragon-Software-Group/linux-ntfs3
git bisect start '416f99c3b16f' '559e608c4655'
# good: [fa5ef105618ae9b5aaa51b3f09e41d88d4514207] Merge tag 'spi-v6.19' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi
git bisect good fa5ef105618ae9b5aaa51b3f09e41d88d4514207
# bad: [399ead3a6d76cbdd29a716660db5c84a314dab70] Merge tag 'uml-for-linux-6.19-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/uml/linux
git bisect bad 399ead3a6d76cbdd29a716660db5c84a314dab70
# good: [a3ebb59eee2e558e8f8f27fc3f75cd367f17cd8e] Merge tag 'vfio-v6.19-rc1' of https://github.com/awilliam/linux-vfio
git bisect good a3ebb59eee2e558e8f8f27fc3f75cd367f17cd8e
# bad: [faf3c923523e5c8fc3baaa413d62e913774ae52f] mm: fix vma_start_write_killable() signal handling
git bisect bad faf3c923523e5c8fc3baaa413d62e913774ae52f
# bad: [915a2453d824a9b6bf724e3f970d86ae1d092a61] mm/damon/tests/core-kunit: handle alloc failure on damon_test_set_attrs()
git bisect bad 915a2453d824a9b6bf724e3f970d86ae1d092a61
# bad: [c707a68f9468e4ef4a3546b636a9dd088fe7b7f1] mm: abstract io_remap_pfn_range() based on PFN
git bisect bad c707a68f9468e4ef4a3546b636a9dd088fe7b7f1
# bad: [ca30ac479e6cf7a210dcad32fa2ee99ca0357e91] mm/page_owner: simplify zone iteration logic in init_early_allocated_pages()
git bisect bad ca30ac479e6cf7a210dcad32fa2ee99ca0357e91
# good: [138336d674d2e51f1e5699d2a30af1e9aa1352b4] mm/zswap: remove unnecessary dlen writes for incompressible pages
git bisect good 138336d674d2e51f1e5699d2a30af1e9aa1352b4
# good: [0de9a442eeba4a6435af74120822b10b12ab8449] mm/page_owner: update Documentation with 'show_handles' and 'show_stacks_handles'
git bisect good 0de9a442eeba4a6435af74120822b10b12ab8449
# bad: [95b34d66480bbc9bc31e78c26b1d5be47358ffc0] mm: always call rmap_walk() on locked folios
git bisect bad 95b34d66480bbc9bc31e78c26b1d5be47358ffc0
# bad: [2783088ef24e32df9d70eb2a24f70de28b476a05] mm/page_alloc: prevent reporting pcp->batch = 0
git bisect bad 2783088ef24e32df9d70eb2a24f70de28b476a05
# good: [4dcf65bf5be22e32d389628b0e655731f97f525e] mm/page_alloc: clarify batch tuning in zone_batchsize
git bisect good 4dcf65bf5be22e32d389628b0e655731f97f525e
# first bad commit: [2783088ef24e32df9d70eb2a24f70de28b476a05] mm/page_alloc: prevent reporting pcp->batch = 0

