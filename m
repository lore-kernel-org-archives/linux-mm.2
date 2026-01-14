Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88592D29FF8
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 12:17:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC9FA6B00B2; Wed, 14 Jan 2026 07:17:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E835B6B00B6; Wed, 14 Jan 2026 07:17:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA4146B00B8; Wed, 14 Jan 2026 07:17:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C94E36B00B2
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:17:36 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6DE3A1BC5F
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:17:36 +0000 (UTC)
X-FDA: 84330470112.27.D4CFE79
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5A2701A000B
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:17:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=qDp8hvbT;
	spf=pass (imf19.hostedemail.com: domain of "prvs=94744532ae=clm@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=94744532ae=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768393054; a=rsa-sha256;
	cv=none;
	b=oBqL8dZNLttH6z+YvwC+MDdch8XTRXZwPTz4Ke/bv/j3exOFtRaYHdaNQW9E7mcGGJOXh/
	P2QAzHsR/hv4PNmACPRPoJ6d8JfGz7RD7YOZEKmzEwJxxnBXM8iTW2c2kAHes/zuUBe8bZ
	CokshLV4iD4XESM2qNnURlc+8ePU8cM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=qDp8hvbT;
	spf=pass (imf19.hostedemail.com: domain of "prvs=94744532ae=clm@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=94744532ae=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768393054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bLiraS6G0ujGAs1161707SLd84yAjvJ0ILuh8g4ymAE=;
	b=6kbRNTIE+wuHK5LU1ZfxzFTUl+jyvdp4yKxKecycU11VjDzxp9IMmAfCkoRTm6HXgnHhsJ
	RAugmOdFhQCQDZW+eVlwUDr/4WGjH9ojqV4oj8qz5aXlngj/v4htc9yA68jAp00mcRwtRp
	ahZoVFHmNN7vpy2qJQMg/vfu3wDXfcQ=
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 60E0vSXu1638917;
	Wed, 14 Jan 2026 04:17:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=bLiraS6G0ujGAs1161707SLd84yAjvJ0ILuh8g4ymAE=; b=qDp8hvbT4oRq
	Ic71j+P5Cud2KF6pNniv1HyFR96hb0pEw7VOA0c8zN1E5ofYBMYWi31HRe2pqvZN
	j0MYAdgQUiLcwfimaYzYwrawpYjMzZ6oJgNSTEDijXQsKti65ZByWNQdD+HRaKJi
	Ozkji8xc62BOfE/HwuKwUE0UhcROeI+Yvr2Db14CPFUMHquyha9zViaCRm7zVuCJ
	MUbGAhZiu7fYNgJLIpDj1xbbwiNwYgL4ja2H+LyNUrgd+8Vbey0DAMkAB/oJyjua
	kfs5MNkmtMu0uXxcg+dBqx9zrDWxyz+ruQc27tkyDOLk3XLJBIrL75FGgePhmwMt
	AqsV9t4Ibg==
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0089730.ppops.net (PPS) with ESMTPS id 4bp12aby1k-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 14 Jan 2026 04:17:14 -0800 (PST)
Received: from devbig003.atn7.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.29; Wed, 14 Jan 2026 12:17:09 +0000
From: Chris Mason <clm@meta.com>
To: Kairui Song <ryncsn@gmail.com>
CC: Chris Mason <clm@meta.com>, <linux-mm@kvack.org>,
        Andrew Morton
	<akpm@linux-foundation.org>,
        Baoquan He <bhe@redhat.com>, Barry Song
	<baohua@kernel.org>,
        Chris Li <chrisl@kernel.org>, Nhat Pham
	<nphamcs@gmail.com>,
        Yosry Ahmed <yosry.ahmed@linux.dev>,
        David Hildenbrand
	<david@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Youngjun Park
	<youngjun.park@lge.com>,
        Hugh Dickins <hughd@google.com>,
        Baolin Wang
	<baolin.wang@linux.alibaba.com>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>,
        "Matthew Wilcox (Oracle)"
	<willy@infradead.org>,
        <linux-kernel@vger.kernel.org>, Kairui Song
	<kasong@tencent.com>,
        <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki (Intel)"
	<rafael@kernel.org>
Subject: Re: [PATCH v5 14/19] mm, swap: cleanup swap entry management workflow
Date: Wed, 14 Jan 2026 04:16:51 -0800
Message-ID: <20260114121654.1029110-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251220-swap-table-p2-v5-14-8862a265a033@tencent.com>
References:
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c085:208::f]
X-Proofpoint-ORIG-GUID: l86fYLqm09mw1sGmgoYqJKS0iX9e17pd
X-Proofpoint-GUID: l86fYLqm09mw1sGmgoYqJKS0iX9e17pd
X-Authority-Analysis: v=2.4 cv=KcjfcAYD c=1 sm=1 tr=0 ts=6967894a cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=pGLkceISAAAA:8
 a=k3sPG3Yi4uvsF8qPn4kA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDEwMSBTYWx0ZWRfX34SFKLUZwSHE
 W9V8eNoSED2L+ABXQvnl5NpeaAXYgFEd7nV0yGcqmbi4auytq2DtwmnoI0Ab5TqMwtGNeW6XPFS
 nvn1mMxajdTescl8CIvvYKNF1n9nSk12ZtzN2ZhT8sFNBc94RA5WcxRL39JTmpfq7dXeolnYyq6
 OO8kml4XEoOgtDQ0YjccbPYnI8eZHSws+zmsFUul8pprrB6N66dS6g/lmU8cigXCec+SVE/GI7G
 SMgfYdUsKA5GY3rBeKcUAVhxvh2E5gSIoucAWVRlTo6fO9O/0QsHwDirDyEe7oK7vMywHm4GFGm
 ZW+6ceotx74UbpWCW/4uhPGIs8rrdVRjazXEvuEWIOzP+8oGLRy4AyYFoUPUoA2CsTQB+nGBgtH
 RDegsldmSEli9f9jNQROapMGcM9DntF/WVIn3+bnChRDSqioIoyjprLK0L0g2vhXoTjjRygLIpL
 q/2le8npXcgkO/m3A4Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-14_03,2026-01-09_02,2025-10-01_01
X-Stat-Signature: 47sngwku1ww3xn9nshmpu5n5ppjgd1og
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5A2701A000B
X-Rspam-User: 
X-HE-Tag: 1768393054-953394
X-HE-Meta: U2FsdGVkX19Yj78/suEdyjQJL0daNVHNlSgpuTRQnZ5Dfx0k59eKuP/YF6vE9YGdPkHLb/4JilE8KoBi6fds1mcPw8E0mSc1rjvFWYbPqHBCleNMr8do7ny2Zw9ox25PJxfeUG4lAERCSWS1Nrb3pK70dgwEKCD6bgtoj8XEolLJ4idnH7lQFfoiTgKdAUmveOhaXolOksA+RpkCug/+AMRL4VVqaHt5RHJv2Ks7PdAS6G2PlDkQOlk8wjunyj0VpDu4/hwHsYg2MfS5zXJf5nMV8lDrrHHmAMAD3j1GVrU/l3Wzv7D/WoKxcXZyeaL3xn8k8yH9k/riZnEdtrgtNvjsYzlBu5pOFGe40u21qAsp/xrnmEdxSGsLw1kDiYXNPWLEBEYr8koOj/I2Udy3CxUqH0w3QPgISpFA0+XmKn5ZgWr1hIuFB5qLTbrT2NE06oo1UVpZe/maNAZpBUwfcJMFQsXAkECRTN5sxe80f/S4oL8y7Dked9m63sBxV5C+vLJGGaIMyOPiFdelx1VR7Z4dhGQCRjAW+Stz/2p/s2iQyJCJs6qRQi1+auXkcyvOn7hhxWniInzVG4e1oSu76EUR9eqdBeiJE0o38WBUBiTqejx0yJwG798qcQkWi2/B29yjV0897H3G4CD1KTe4Q2/op70B5OwDf13cYSryiq1LM4XmA/xZ3LrzrJEQAxMr9BJJOKT+72Y7NzBQDSZ2fD9gMZR1EZCjqsWcyFoaHTVTjtErNYPpHkZYOxu+Gu7IBXNWNGEhUuK16d+gaG4cniIAlmcglEMgdZ0ED1Lj7iOiRcAWDeMFdUdopgzG/GZNEQR/82DsGMof/M68OM3H6+JnFN2shS64A6ii992D2oz0C3Wd0F82FOeIe4Cjj4V8S1zRsVnmN9bArZghVqD3e/jkzdlng6h1gkbLz/tAj/6eMB8MPerhZr2eiHERgyvRncGLp9BbC0im/E5PZAD
 QncWQVJK
 oJCvuidDjqVXw6sVFKSEl31xYpLNq7T642A4xiSd2kdktbiTMEKCMcK4eV4NYmQjyICM/XuKnDMkJRzOo3XtOq7XzG/4tMFwmP0J9Z//Qd0d/oWn02eIksgf3ZzFGB2ubH4td4r79jLKaeKjnxJ0ftRJkeg1gVdQ/cI2OVifYv1qLqXmT1NkLnjUrDyT9qYhaSPqlqHz+LLEb/coKePq8nbhYK0UMrofEYeFEV38GOD+cmVRs2MRLfrXwf/TMn7zr4UJ/wh0Gj5OZpOBM8bIbEbz860Cy1eVlGHM/d+1U2FHqBzVTdMCmgQ8SgQsCt8ueMt1f+LtinDW0knjIYoq5KKCe03y3LLqrfr23TdlyDLFXD8I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 20 Dec 2025 03:43:43 +0800 Kairui Song <ryncsn@gmail.com> wrote:

Hi everyone,

I ran mm-new through the AI review prompts, and this one was flagged:

> diff --git a/kernel/power/swap.c b/kernel/power/swap.c
> index 8050e51828351..036489d3b01a9 100644
> --- a/kernel/power/swap.c
> +++ b/kernel/power/swap.c

[ ... ]

> @@ -186,6 +186,7 @@ sector_t alloc_swapdev_block(int swap)
>
>  void free_all_swap_pages(int swap)
>  {
> +	unsigned long offset;
>  	struct rb_node *node;
>
>  	/*
> @@ -197,8 +198,9 @@ void free_all_swap_pages(int swap)
>
>  		ext = rb_entry(node, struct swsusp_extent, node);
>  		rb_erase(node, &swsusp_extents);
> -		swap_free_nr(swp_entry(swap, ext->start),
> -			     ext->end - ext->start + 1);
> +
> +		for (offset = ext->start; offset < ext->end; offset++)
> +			swap_free_hibernation_slot(swp_entry(swap, offset));
                                           ^^^^^^^^^^^

Is this loop missing the final slot at ext->end?

The old code freed (ext->end - ext->start + 1) entries, which is the
inclusive range [ext->start, ext->end]. Looking at swsusp_extents_insert(),
when a single slot is inserted it sets ext->start = ext->end = offset, and
merging extends the range by incrementing ext->end or decrementing
ext->start. This means ext->end is inclusive.

The new loop uses "offset < ext->end" which iterates [ext->start, ext->end),
missing the slot at ext->end. Should this be "offset <= ext->end" instead?



