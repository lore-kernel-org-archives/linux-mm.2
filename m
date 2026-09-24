Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CC54C98326
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 19:57:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4BCD6B0088; Thu, 24 Sep 2026 15:57:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFCE16B008C; Thu, 24 Sep 2026 15:57:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEBEA6B0092; Thu, 24 Sep 2026 15:57:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 97D926B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:57:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2EE31A68A4
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 19:57:40 +0000 (UTC)
X-FDA: 85249715880.06.EBBEAB0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 668781C0008
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 19:57:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kq9a9Rkn;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790279858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nLpeLpLGjwOfKcTCnCQSU5EO1VPuu9jb7mm6xziMJmI=;
	b=ba7uLpvpbTwF9adzcwyjV41ZgtXWyELcGXjbMEp20gDomap5dFGdBbqkEazYR7sDgYmRhP
	qC466gtmvZoTR+0Nx0qkyrKPelrvcUbE1seKhU7PIaCDiEpsY11+KdrtwKl9IauVuclxXi
	rGzYQkbIK/ri+iqF4g78tHYN8jnb5xw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790279858;
	b=wQytt63rukMUMdA6nhn+mypE908EhgpP2CimeoJ7qsI/NhyxZQfu6Ifglc/WvNkeuSvPKv
	r5CrCIGdDRU6SABWbef3ceU9BjSk25nFNbcQ6DdFLNFCCHLXSOHLfdeVjPaJ8aAtkw+UpS
	DLyl2YyVfGaRhUABochImCf2unkaQaQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kq9a9Rkn;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8384B602BA;
	Thu, 24 Sep 2026 19:57:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A4A41F00893;
	Thu, 24 Sep 2026 19:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790279857;
	bh=nLpeLpLGjwOfKcTCnCQSU5EO1VPuu9jb7mm6xziMJmI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Kq9a9RknlpZlo4b0eupTsElXigFXrIUanPBhI2KXLjqTN/OC5vQIWmqhocXZcLk7j
	 ghadO3hpttkfqq9lCf9lAvvUc3oTnfF1y4bCLNvFwNpR2gjUhz+LxaK37+wB5et3hd
	 FE/alFY4UU3uy98KmcCzzeHqKUv/VhYvKBgs+VI+QEX5kqxM8vj7JtZUkC93vh6VVT
	 AkP76/uLIhqaKfSay37MHOV5bQ4DSDQn+NQ/AkmAQIsCtj/gug7rmK4l6FAy1sfgaR
	 UC4sdM78ApgRJWW2sd4E9ocFMi0IOuFlUwWwnJ82CAk1BIaVA+Hj2CRPMZ8JuOnN9V
	 ZGa7SaSgPlnmQ==
Message-ID: <8fd983e9-286a-45bf-a4f0-62dbe64772ff@kernel.org>
Date: Thu, 24 Sep 2026 21:57:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND v7 11/29] mm: split PMD swap entries into PTE swap
 entries
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev,
 luizcap@redhat.com, kernel-team@meta.com
References: <20260914122950.3283997-1-usama.arif@linux.dev>
 <20260914122950.3283997-12-usama.arif@linux.dev>
 <7f6eb404-8139-4208-88eb-03ea8a4bf3a9@kernel.org>
 <326b26d5-481e-4524-8b9d-c4d54924626e@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <326b26d5-481e-4524-8b9d-c4d54924626e@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 668781C0008
X-Stat-Signature: hrotsh49imhscx4eaxj8ikt3nr3gthss
X-Rspam-User: 
X-HE-Tag: 1790279858-443931
X-HE-Meta: U2FsdGVkX1/iAnUg/FXPfe48Kq3sv0E/y7ukEkkEnq+2+zLwPDUHSSWlyfggnI0OCMPDneij9yplqEqL4Oz0r3siFhl00YtmJINm1ilAcchmk6T9zalLROM08eFpItB/8aZgMBUG+nR3rMgoHFX4Ebmhd2m57nV17Krn/NAd7aPPmEOI2reKnwM7DJBmKibmfOzQ0x3K8NeaEScLnvJlq9+vzM78gDDs4jvf7swMYntEJZpC34SbCsOZMadd14+l6O40BR7jdVJextnhRBQPg1zjfCvvrEwRULp+sp0fnHxy0tE/GCQwJvmoP5NIhG9acTNid+O/hyGjvVI/jhzw6k83wjJj/9skD/EnZWULld0ZG1MaCeviKVdNuYFwrz+qyoIjIP4HPid2XaajHLgltQS3LdlF0LOjgizAc2Bsu/PaYBGgaEas3DQg8+oUU062targioC9trRj/buWAEH2sCI2RcBgwohAIL5kWg6mXNn1j5RezZouWcMPyYrn0cuGJfsO6ZdlVklFVM5l74q4O+gcJfG6P7Y74zeExITLMdzr0mGOE4VTAIfIuVM+UYO8r67NAcbBcRhHkuAtaEKaO89c3Vzm6+mGzTlfb0LouERKraFhQzwfAGba2V8G3DwyM8dcrYGnJ2fBsDBAS5NdWrOnIz3vhFJcE7xucDuEGhnWiAtviyYEtvUtQGOyYYbC9vXHaMmmDZo2HiCnEdxBSVidT+1jIjIlxYGPqkOB2iD/BkpCThIviWenX+xwr6rBFZqTp4whNIyPJoqb3cWshrHaTCRyoeabdSSlrH7ewkFErvQypBXRX7u0uI+yy6aOyiWu3eUg9QeYH9lygrAvxgLeK82W55bxpoyBy1fWzXZFVSCzlzlfWBL/6ZTf/g+56K+CQt3GhkFHlDwO2mNcryg0ixV3EfvDMOYJeADR3Vk/PwD5TtBh3MYXRbHn2pA9I1IY4X0gv2n90TPPYPP
 KzIDrM/f
 JtWxtbRYv9XjCXSIeg+LL93PoDGvZN9QELYhA0bnO/BolaZ2pbzXdyUO4PhRSMYY27lIyPSyehw2XLpJ1RiuYr2b2tCCiSbd59VQACuhWSGkWZK4rVHLHi2csBque4Ahtky8PnYgXVyeEueZT/jWFV15/lyeqCtmiooSlyblbipdeCk6QD+9N4iMGP0fkBpFXU1I9nzWa+vqb3A6tpfeawJT9Va+n6wbiRKtBYOAwLT9dHL9I7KuF5+lFwk97IXCklNxb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> 
> Done, it reads better than I expected, because the three bit tests
> hoist out of the loop rather than running HPAGE_PMD_NR times:
> 
>   } else if (pmd_is_swap_entry(old_pmd)) {
>           pte_t entry = softleaf_to_pte(softleaf_from_pmd(old_pmd));
> 
>           if (soft_dirty)
>                   entry = pte_swp_mksoft_dirty(entry);
>           if (uffd_wp)
>                   entry = pte_swp_mkuffd(entry);
>           if (anon_exclusive)
>                   entry = pte_swp_mkexclusive(entry);
> 
>           for (i = 0, addr = haddr; i < HPAGE_PMD_NR;
>                i++, addr += PAGE_SIZE) {
>                   VM_WARN_ON(!pte_none(ptep_get(pte + i)));
>                   set_pte_at(mm, addr, pte + i, entry);
>                   entry = pte_next_swp_offset(entry);
>           }
> 

pte_next_swp_offset() does something similar internally. I suspect there could
be ways to optimize that out ... anyhow, good enough for now :)

-- 
Cheers,

David

