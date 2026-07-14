Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C886AC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 05:38:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B89E86B0095; Tue, 14 Jul 2026 01:38:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3B326B0096; Tue, 14 Jul 2026 01:38:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2C326B0098; Tue, 14 Jul 2026 01:38:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 79B876B0095
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:38:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C7EBE402D2
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:38:22 +0000 (UTC)
X-FDA: 84986276844.01.3A3BC32
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4AF2D1C0004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:38:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=dBZA3v7+;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf21.hostedemail.com: domain of caixiangfeng@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=caixiangfeng@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784007501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wsgxB8d0Z97OA5/TGi1FFx1r8lmXJ//VHZT91Rx6Ync=;
	b=xoHRhojjeUu4MKn6Ll/8hfKmlPvBbk8YUBdlDY8IecWR1TbWqRLYKhyUnnVLGMItTOrsGJ
	qQ2aVAt7SQaZ9jqvXqFtyfTAdIwDiczGcsJNCSy7j91KXRiljEw2W2KrfQF06Hep02N2dj
	jpleygX3UZLvjpSFgWPkAF/8+8zpqF0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=dBZA3v7+;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf21.hostedemail.com: domain of caixiangfeng@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=caixiangfeng@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784007501;
	b=WoXf4taMIQ4unKQ5H5KvgzA5x+YrYJ37Ch5792GIV5HH0MZsYwEU3jmMrd1MaAoBwKUI1W
	ny8pgUYT+GzXQhYDcmU2ebqXtgzdT6rZfKEfEoM4o3I6HAENSwOmKUvbaTY64L+LoKs7qC
	DZH6M7Zna9/u0DLwcgdBmFWq2Rt0SAg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1784007495; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=wsgxB8d0Z97OA5/TGi1FFx1r8lmXJ//VHZT91Rx6Ync=;
 b=dBZA3v7+aGsuoB3duAzisIi3dANAf7WGtd2Z/pLrvkz6tcEVgpLZWpVCPxpx/bBFdOTw0X
 ZaAfV/65CZRIIbRfSgndbycKbL5nGEfIKIa91/ucBFhDXkHco/fCWBf6ZUao2Hrm0Cus3r
 a1O0u4aB0ZFhvaZ3qZhdIHLxcvXtQEvDXLc+FKaVANg3JIBEGq+zfCP7ZYRkD18TksX06/
 re3cvehicW9LOuDmawyor2pWUFAK6aW5HvC6x6nRphrWgEz09K12U//e2qmdAsra3eahXR
 c7wa5sEyOXSLTSbgrALT2d1KXF/6Fg8ox7xXioqxFFeUEHSwANPBMCdj4idAbw==
To: "Muchun Song" <muchun.song@linux.dev>
Subject: Re: [PATCH 2/2] selftests/mm: add hugetlb_region_cache_race regression test
X-Lms-Return-Path: <lba+16a55cb45+09e4bd+kvack.org+caixiangfeng@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Mime-Version: 1.0
References: <20260713171456.300518-1-caixiangfeng@bytedance.com> <20260713171456.300518-3-caixiangfeng@bytedance.com>
	<1C8560A1-1F70-488E-BB62-2407B115F7B5@linux.dev>
In-Reply-To: <1C8560A1-1F70-488E-BB62-2407B115F7B5@linux.dev>
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 13:38:12 +0800
Message-Id: <bedeaa5bba0bd040e3b7612739f2bb2229e881de.c970df5e.7173.4d68.84c0.4372a6c03178@bytedance.com>
Cc: <akpm@linux-foundation.org>, <osalvador@suse.de>, <david@kernel.org>, 
	<richard.weiyang@linux.alibaba.com>, <baoquan.he@linux.dev>, 
	<shuah@kernel.org>, <linux-mm@kvack.org>, 
	<linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<stable@vger.kernel.org>
From: =?utf-8?q?=E8=94=A1=E7=BF=94=E5=B3=B0?= <caixiangfeng@bytedance.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4AF2D1C0004
X-Stat-Signature: wbrp1b67ymm5mwnbf9zmdychmxm8wg1i
X-Rspam-User: 
X-HE-Tag: 1784007500-716518
X-HE-Meta: U2FsdGVkX18uTbAzMW/ramdV5ZcgwSDa7yfF6jnNs2y7woNglKUhaN0a38yVcVxxfrig2Y5HXMG5RjcbHby4FRoh9P1jlkxT4oN1pF1YvgfRKgE4dOAWSo/Xw43oq1x8k6f9Rgzcat1wmAGi5BsItd2DHBNjLfE58T9bvJAKQ73Auh1L0Koa4mjDnIKhlMdhZA4y4iM7G47WZ0hXYWYm42cXYp12FSgdZuGJJEGZgjMGSXGKCor0sxv59RroCwTJqqDkNzJidxCo7QJz5/JqLOJ7Ha6rCWG5AXF/J6+0f1xAPaOBxWyWxqv4AOfWCSLspjZDlaiLAUx3EDw0uoaIKFuJ+REIn/C+X7PXUoelkp7iGV/N0g3ebPayR5MqW40aHO/eBLdSVAGz399MNxMBq/DYbj/sEoxq3g64vgpBhckvOtujbTrkv/KZ32cjGM1GUdnoHDZyqcPRJ5DNdn5PGyduHz6SmbgcZaLr3ZcDZhtdLwx5KzXE8bLu/ldWFaNuQS/SipDkPSJX/nCPhNA7MyTvSi8OEW3S8xWr2aULBX9Z1wXLmyaQz9UUk/bzBhufruAKY8qgl9ytfcjGmeSSfeHQZywTwHdj56vXAOhLpiHUZ774ZLAzDjQEA93p5PeQLy+djIgrJ/FryhoJt2y6yy/QrU4PcHhRx6Nj3229D4fXem05zD9fTz6D+pTPOBeP1a5xLiOnwcFBHn2wn/hog7ghgquz92w8sLvg7O3aZkemt04rsSqPbcvuB9HeouU6ewA4ZdYCBuVDTG5pdaB4iEiHb/wTnsde0Ud1IqfigjBTOs132Ld6QyFiw4zOjZBPHMqhhUxLssRut89JPsjP5Z3DSBE2rmz6Y+3RG1ELf+NJpBNaviiFt90EUkp0uZ86JAEyeA5ocHM/l/pVIeJFg9nrRFkdbBI4MOFvRXCh/YczQyRbrAK/piBB3pqmMrFvxPqJC6s2gxcuDmtDqvW
 4GheC1zF
 9DQtESueNFzxiuBk1XCD67Zpm1JdSf2cI4oLUKE1g4nfPGj2Werkyl06EfLn/C0oImLPvvusPUamW4DV9+VtdMd/DUNflwJryfvRmRQqbi7s3DjwZBTrhpHBBWqz2P5szJ+3GSzNVYkLc3Pj7mJmCo7vLiwvBO/QlOIDhCYmzCsZbuIROylH0XrhQiNl7xIkMJu+0MdGxKB5I6Ge6RtXDO9PAZqa82bgghadtrkfH4o0lVOx7XQUzI5yYw49StEsQYK3kLBAgtekz7ybjkkqod0zxg+rQRoMOldMCVCnAiPJcPf/9k6n0UT+YbFYEZGFxvWBWyG9UDnaOw6DYRyxpA5XD2yzMrIkIqCXmwRdjGnXAytM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > On Jul 14, 2026, at 01:14, Xiangfeng Cai <caixiangfeng@bytedance.com> w=
rote:
> >=C2=A0
> > Add a regression test for the list corruption in
> > allocate_file_region_entries() fixed by the previous patch
> > ("mm/hugetlb: fix list corruption in allocate_file_region_entries()").
> >=C2=A0
> > Triggering the bug requires a concurrent reservation operation to drain
> > resv->region_cache while allocate_file_region_entries() has dropped
> > resv->lock for its GFP_KERNEL allocation, forcing its retry loop to run
> > again. =C2=A0As the mmap() and fallocate(PUNCH_HOLE) paths serialise on
> > inode_lock, the cache has to be drained by faults from a separate addre=
ss
> > space. =C2=A0The test forks several processes sharing one hugetlb inode=
 via
> > memfd_create(MFD_HUGETLB); each mmap()s and faults ranges and punches h=
oles
> > to keep the shared resv_map fragmented.
> >=C2=A0
> > Two modes are provided:
> >=C2=A0
> > - default: a safe single-process functional check that exercises the bu=
ggy
> > =C2=A0 line without forcing a second loop iteration; safe on any kernel=
.
> >=C2=A0
> > - --trigger: the concurrent reproducer, which panics a vulnerable
> > =C2=A0 CONFIG_DEBUG_LIST=3Dy kernel and is therefore opt-in. =C2=A0It f=
aults pages in,
> > =C2=A0 so it needs as many free huge pages as the file is large.
> >=C2=A0
> > Assisted-by: Claude:claude-opus-4-8
> > Signed-off-by: Xiangfeng Cai <caixiangfeng@bytedance.com>
>=C2=A0
> It looks like this is a regression test case for a very specific instance=
 of
> list corruption.
>=C2=A0
> In my opinion, selftests should focus more on functional testing with cle=
ar
> expected behaviors and results to users. I don't think it's worth maintai=
ning
> a test case for a minor issue like this, especially since code changes ha=
ppen
> so quickly. Once the code evolves, this specific list corruption might ne=
ver
> occur again, and the function itself could even be deleted during a refac=
tor.
>=C2=A0
> Therefore, I wouldn't recommend adding this as a selftest.

That makes sense to me.=C2=A0 This test is quite specific to the previous i=
nternal
list corruption, so I agree it is probably not a good fit for selftests.
I'll drop it.

Thanks for the review.

Xiangfeng

