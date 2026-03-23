Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BCB2EC01DF
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 12:14:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A34DC6B0005; Mon, 23 Mar 2026 08:14:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0CBC6B008A; Mon, 23 Mar 2026 08:14:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 922226B008C; Mon, 23 Mar 2026 08:14:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7EEE06B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 08:14:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1EC4A13C060
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:14:58 +0000 (UTC)
X-FDA: 84577221876.01.FF90BA4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8B78580010
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:14:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZSBABe9e;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774268096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=45hfn6ZA8t+v71Caqjxd+L4w3uxfJt23DFIjKJ8nbO8=;
	b=7QefX9/L96J2UOBudlxrKkWGxjE3Wz11jiTQ5uezdNqFVrKGuU1vMqvofpH4xujCn292Sx
	7j4yU2KDK1Cxhk4norRCZoOHcJMH7j+79rWLEyPhGPjAuNn77/SluUNEAIokyIlmBP6ceZ
	kE6jglp1ZDtYmiMgOIbL9c7+4VD8/w4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZSBABe9e;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774268096; a=rsa-sha256;
	cv=none;
	b=LidrXEWdY2v+2GmopkhKDM5ZgB07Q0mMIH/mU4l92xiizGbsE4IrCufHdxeesjtWzSs/5f
	xYrnA+wShTEjSfU/DA4+OuFqrYgPdLmUV18Oh73KrDXWG1VvnA29NKRLXZGXZgApHSv5v9
	UzPndqBouoEGfPRTe94/7q9Imu8CHfg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D5660600AC;
	Mon, 23 Mar 2026 12:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E72C2BC87;
	Mon, 23 Mar 2026 12:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774268095;
	bh=e1GKsmjokp568WdraGmzdBYzyhyLtslDu9R877vdg+Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZSBABe9eTd4021WyuPktTK4A94xId8FIL/lrVjgewGfo7qXAltgo24V+IBzesL2RH
	 uZH7v344b90X1c1M5csHlE/HsbeTpIc3qBSUA6asyQ5aO3AcS4aiGDST/pGkPTOcWl
	 EkMwuTzREXpn1E+jtzGN7mxFzmqA+vfnqB2Zp7OmCc2DeN9HJqBV2egNqt5GbvCpkx
	 s1oy1nVFlcOQUYBFcht8NHoQ3N2rhZcqOeXTsQzQ40Py5mcaGIpOXhf0G0pEDwFOgN
	 EzugMkKP2eRWgvwlrn33SXq3oGsQEXYyyVyMYQ3x6oEe4QsRnR89g/qn/ETrPZgyQi
	 GcyNi5aA0HxGQ==
Message-ID: <8b4092d7-bd99-4715-9a5b-471096ba29a1@kernel.org>
Date: Mon, 23 Mar 2026 13:14:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/hugetlb: fix memory offline failure due to
 hwpoisoned file hugetlb
To: Jinjiang Tu <tujinjiang@huawei.com>, akpm@linux-foundation.org,
 muchun.song@linux.dev, osalvador@suse.de, linmiaohe@huawei.com,
 nao.horiguchi@gmail.com, linux-mm@kvack.org
Cc: wangkefeng.wang@huawei.com, sunnanyong@huawei.com
References: <20260321021031.2240780-1-tujinjiang@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260321021031.2240780-1-tujinjiang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8B78580010
X-Rspamd-Server: rspam07
X-Stat-Signature: yq57mgtbfia7nqyet6g5z1gqocreb7ot
X-Rspam-User: 
X-HE-Tag: 1774268096-301171
X-HE-Meta: U2FsdGVkX18q8FyfHjUOYoecKYLhIjh7Y0qWuO+oEKPxxywJ3TZuROwLveYb55h8NhD1AWBe69uokoNYZBV8eoR3K26IPGPb4iEP1lAHu/xvSCgluF4TjiN8feU8P7HxpocllgQO7GEWqs4o4lKYpQET4sanDbKHD9Czysw2a4wB28renYxP7CYru/dYqhS68MBllsRK4NLY+5VYePKUNVA1HAmb05Z2gW1WqbXfqdAWCPAt+Q3eHnPGK7FZUTJ8T42RgR9kD9PC8T/yAue/8Xxs2xvRYxHwy12Z6W/jiRaXZS3exnr8e1fGw9AZrNnP/rb43NTrtbO0qsN07+e9LY5LkshfcujAQ0F4kV5ghVcJtLoQMJ6ageRoUU15SjIYhfNtOzZe+GMHN3fuvZpuk8u5+kvtpsMMcAlqM8piNqhrqvOW/I9M2Py1/rgAr4NSL5RcTWqZSGhLuK7blKkVCP1n3WtSMjSulw8Ggr7hh8+EQ6x25ZOWQLzkE3yf9ApVyGLQ0BRxeyOe+dCQt6SFtR8l5Pjl25dFprFVC/93+b74h1aVgx3ZkGMK7lbsvYTmmybq+coNcTGvpoiDn/n3AmqT2ms5ad3/Y/HADnE9ie0hmNxnZWmg4G/FyqidG2oo0+DAgC7TexPUh3M+gRRWA8YQVGW3sHvWK+aTEiT1NDqjxriE/ghllTktMiDbAqAXdLcnJAWLME74xgn5i0RrCHUIk+93NUobZg4aCn71p3Ecl8ON+/MigdsTaEo+gPevJAbmwMOr9CA2ViXOvWq0lbt4WTUN2mfhLNjuVRPLKIJ0Mhg5HHa3wVIxPBk9FYbc5XKFxMpGfNjcAf1gN6ImPt3iC54hqdND5roUUFW2iwgKW0mUx9XPHuej4G7836D3Idb3jsiPMog6v4xqZubLEoVBUQnfQnt83LLYVeokaoSdAuJ4IyNoSSa/UQ5FBn9NgNH7F5bSlaha07yLl1p
 mkLZVKQq
 r++psTLrJ299Mpz7Zx9t0tzMoWhc+GsxEG202
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/21/26 03:10, Jinjiang Tu wrote:
> When a file hugetlb folio triggers UCE, me_huge_page() will keep the
> hugetlb folio in pagcahe with refcount increased and PG_hwpoison set. Even
> after the hugetlb file is deleted, the hugetlb folio is still leaked.
> 
> If we want to offline the memory block that the hwpoisoned hugetlb folio
> belongs to, it fails in dissolve_free_hugetlb_folios() due to the
> hwpoisoned hugetlb folio isn't free.
> 
> I can reproduce this issue with the following steps in qemu:
>  1) echo offline >/sys/devices/system/memory/auto_online_blocks
>  2) in qemu monitor:
>        object_add memory-backend-ram,id=mem10,size=1G
>        device_add pc-dimm,id=dimm1,memdev=mem10,node=2
>  3) echo online_movable > /sys/devices/system/node/node2/memory136/state
>  4) echo 5 > /sys/devices/system/node/node2/hugepages/hugepages-2048kB/nr_hugepages
>  5) run ./hugetlb_file. This process will receive SIGBUS.
>  6) remove the hugetlbfs file.
>  7) echo offline > /sys/devices/system/node/node2/memory136/state
> 
> hugetlb_file.c:
>   fd = open("/dev/hugepages/my_hugepage_file", O_CREAT | O_RDWR, 0755);
>   fallocate(fd, 0, 0, HUGEPAGE_SIZE * 2);
>   addr = mmap(NULL, HUGEPAGE_SIZE * 2, PROT_READ | PROT_WRITE,
> 		MAP_SHARED | MAP_HUGETLB, fd, 0);
>   memset(addr, 0xaa, HUGEPAGE_SIZE * 2);
>   madvise(addr, HUGEPAGE_SIZE, MADV_HWPOISON);
> 
> To fix it, force to put ref of hwpoisoned hugetlb in memory offline, the
> hwpoisoned hugetlb will be freed and succeeds to be dissolved. We couldn't
> avoid races here, just like commit b023f46813cd ("memory-hotplug: skip
> HWPoisoned page when offlining pages"), which force to skip hwpoisoned
> page regardless of refcount.

I always considered that handling quite dubious. Just because a page has
hwpoisoned set doesn't mean that we can just offline it.

I think that mus be cleaned up at some point.

But not sure how to do this cleanly.

Why do we even care about offlining memory with hwpoisoned pages? What
is the use case for your change?

I know, it's very desirable to do it, but I much rather have it not
working then having something that is likely mostly broken and actually
might cause harm.

-- 
Cheers,

David

