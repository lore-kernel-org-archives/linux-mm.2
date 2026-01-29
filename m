Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3A62D73E83
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 20:07:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 275E06B0088; Thu, 29 Jan 2026 15:07:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 257C76B0089; Thu, 29 Jan 2026 15:07:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 159FE6B008A; Thu, 29 Jan 2026 15:07:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0322F6B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 15:07:00 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 69CB058455
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 20:06:59 +0000 (UTC)
X-FDA: 84386084958.04.880FF25
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf19.hostedemail.com (Postfix) with ESMTP id 592891A0005
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 20:06:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=YaYoX3Wb;
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf19.hostedemail.com: domain of "prvs=0489ea8c51=clm@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=0489ea8c51=clm@meta.com"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769717217; a=rsa-sha256;
	cv=none;
	b=vmp+uuYfkSmtijCdhfRmfk2jxpV6whSDuzO1G1J+H37Hi/RFLVeqrL9QGkfGk7uWMrDm7G
	SCGpPXQtCW+OIFzMiu8WwKKnyzH6FUoU5okzMD/lrNmb5LnYdXnDItuvs4v1Rt0bDDv7wm
	juQF6zRTHiqvSjPIBvDaWT8/wKDpZq4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=YaYoX3Wb;
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf19.hostedemail.com: domain of "prvs=0489ea8c51=clm@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=0489ea8c51=clm@meta.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769717217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Aad3o3c56ZGNBsvIx1Qn7v3KSrkQFci5VYsYK+dTnw=;
	b=wWS2lxD5NGvU5kRW6WA9Q/AuJXmxFGioTp+vVRhN4oW+e8mS+yZ1wCzzqOgwSbDlu/eJMt
	efYIHUt0pNuTI1LlAjj7V50cpGqLg1FVWt0pE2UK9G8kjewEwy7htB927o3gB1wQ7dcsb9
	DFgmQjrnqYF7/UJH62O2Q0RBKd/qKg8=
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 60TIMR4T1917544;
	Thu, 29 Jan 2026 12:06:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=4Aad3o3c56ZGNBsvIx1Qn7v3KSrkQFci5VYsYK+dTnw=; b=YaYoX3WbHz5W
	rfKoQNZXHk29PaTJhJWgIwOmB90tXCZBpbfnGWegAH/Niu7cyKyHvtZ5gx2bApy7
	OCCxCuMwCXEd7oW3vj6RWNY1XGCbiOoi7cFNK7pcDeuACNuX+QVF7ImLczkccx9G
	6SuAvBdsC6OLbEcDik6Bl8E5iDgWKE9JGEs+Rv3Ql5b7RJje8luPmX2BFvVAnM+H
	fzTlat9+VVxBf0VvlyoOsls76cfMoKD+jI+rKRHU7AIevdQk/rNQFU1VwkrxAWrj
	TL19Peg07pxMOqrdJeoR6TtJU8Q5pef/4w9eHMqF8QUdNsVjXwvq3DsgEtN/Ivje
	HEMZdD7zAA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 4c08fv4mng-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Thu, 29 Jan 2026 12:06:26 -0800 (PST)
Received: from devbig003.atn7.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Thu, 29 Jan 2026 20:06:24 +0000
From: Chris Mason <clm@meta.com>
To: Kairui Song <ryncsn@gmail.com>
CC: <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>,
        Baoquan
 He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
        Chris Li
	<chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
        Yosry Ahmed
	<yosry.ahmed@linux.dev>,
        David Hildenbrand <david@kernel.org>,
        Johannes
 Weiner <hannes@cmpxchg.org>,
        Youngjun Park <youngjun.park@lge.com>,
        Hugh
 Dickins <hughd@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Ying
 Huang <ying.huang@linux.alibaba.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Matthew Wilcox (Oracle)"
	<willy@infradead.org>,
        <linux-kernel@vger.kernel.org>, Kairui Song
	<kasong@tencent.com>,
        <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki (Intel)"
	<rafael@kernel.org>
Subject: Re: [PATCH v5 14/19] mm, swap: cleanup swap entry management workflow
Date: Thu, 29 Jan 2026 11:32:38 -0800
Message-ID: <20260129200604.2518109-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251220-swap-table-p2-v5-14-8862a265a033@tencent.com>
References: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com> <20251220-swap-table-p2-v5-14-8862a265a033@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c085:108::4]
X-Proofpoint-GUID: xF3qSoIDUEYo5SoFh-hYPuqEGaxNgAIv
X-Proofpoint-ORIG-GUID: xF3qSoIDUEYo5SoFh-hYPuqEGaxNgAIv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI5MDE0NCBTYWx0ZWRfX/jxPxco3ghaj
 CyMdkkqj2tKEUBAmFy8D7iicZr2M0Vhpp2OVVukhEHHhmh58CEL672Ds+hZbvPDNt6h7ZL+amDB
 lLyNARogeomdtORE/XTf5mKyDNskPRf67Lvs3hyzCT/KPHC/uiNvvYkvau8QloluYaZeH/rQjQw
 tJEj6Nbswcz2FGYesLWarRkhFju7g61LaYdIcJhC3/YY44E/NjAbWCdCRJvSoCAfLMk5C3tf4W3
 fYiOMTi4eIbsOxiv3w/7YuuqMLdpsQNCVmSh0Sbcb6MxRebRmqekwKdfrITnewO2eYaIqy+dvtS
 O2tjyIQrN8HoeSKIaDa1d7Jd6ad7H48YUKu797UXRDS0+FUdHsEr4KXMrJcLC20PJF4UrgFy8vz
 4/sXOINoqOMwS/hhyuPp3p2/HGYSbJQDLHSbYO5CwQR86Lf+dpYhbOW3vQk7MyPFvuSOclhty3D
 7LbT/O4WylZGAqG/42A==
X-Authority-Analysis: v=2.4 cv=U72fzOru c=1 sm=1 tr=0 ts=697bbdc2 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=pGLkceISAAAA:8 a=GvQkQWPkAAAA:8
 a=PyCarBDI3Nz51ks_hl0A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-29_03,2026-01-29_01,2025-10-01_01
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 592891A0005
X-Stat-Signature: sahkb7iykguqc7bfh81rnkq55msdjwu3
X-HE-Tag: 1769717217-156183
X-HE-Meta: U2FsdGVkX18HCQdP8vfTFbWrt0R/gs+jVqBbeXLhIyZ9rRq5bph4GeWfo9kD+/cjFdrxW/0RBqoEgHwBixgzrQvGG880U/RfNZh8bjvLzGDXf3Yq75FOHxqYSf1XBIp3NCEvD8Izqugf46L7QWq6QmQbES5L+USB0StFkpOh7O7d0cMg2Bg8Yh5D/qwqBdyGjdajEDlC/fJYIckTkWMrjmG2hktuDyIoBqcT51Kos1Ghr9xDep6CgABAhJGVJR97NS47nUsHIIW2ntQC6DwS3mhpkad/JwBii+c5w33dbYEAGXrEhyQUU27QXFkKHmhmUce1Jjqby2Hyr9ssysKCm1dgmlYMzKdVnC6OG0T76fVwm/eh/cmMde6nKkBITdG8DGaXMn+Muh20nNExM9FIcIX5q7n8kTmtAMCxeEGc/jVFXCD4itJDa4vtSH/fzfF0oNGxN0CqSm1rgHmiqynjTx6QIbh4cvgCfNIy9Mr0qDmzy8gGGxvxmOA0aftXVYY/EXbviIoxMsmJ8fjixXD5ZwndJN2wq0STUoAcOIzvjPkUjQManyIJM8Os/4DaQmYVOFsqFARlwSk+Ka6Kw4wjAclx/QVWobuhZmQDSNaA+vqzyEhX6eefxJ9mrCQsbHeFDNdaIyYXchGXcTN47ZaxSY2Ns5rHsaNOpoh/TpmkG0m1mGBQP8q6oW568Xd4BXDLfISWcpOFvPY1+LcnqQnLjJq76o9p4VXtDll+PEc/aIZD0IzW/kSurPHVuhsZvnqWmT6kW+cJH3XNrdx3pFWfYeavcoK4svVy9cUTsBDXXrfYMwMJJ3S++y8ZkeELdCWQJ6nl80/0KbJiel3O/nBIIXp47kdyFMuGBjqAnrZ8OEH5Eyfc9AZGOzTa4P/zpiop+pkStigmgNnYJ7aZMuOMvtmTuIcLxtsrF1SXbC0QxdfbYOSzGeLGkiSzR7YPXAz4FM0TZ3n+LnHwSSsiBn1
 Wi8V48Gj
 djtekU5/ddZH5phXLld6Wk2g98nlWSVXuotyGjjY7onHEM6PzSARuXlHcKbzvcazup3N+MGgPAPm9t0uSyi50xu9zbaBBDVi6drwjr+D5YuBDf+AxDka2HpaWOxF/GJyiIadcTWgxjjQ3bLlnlTJlefNTtreRABmvJuPUoG8DybyRlG4vvz6pMojHvbOUgeJasT+UChVrdgswM11xKWN/rvNS48+3zylTqFzE+njvAic4nBHXt9/f2opfEwUVFrDCTT6eVwdSoD61tD/9L4gx/NgyjF+eSe8+WNlJr83aRgEhHM+HxtnvTmdbiCXMPSYwmqVAIriO1UCVM1Av30lzMxyhxxKtJLToUDnqPxAkVLUMWuGrLcVf09PlZJ7Kb677Jmyy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kairui Song <ryncsn@gmail.com> wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The current swap entry allocation/freeing workflow has never had a clear
> definition. This makes it hard to debug or add new optimizations.
> 
> This commit introduces a proper definition of how swap entries would be
> allocated and freed. Now, most operations are folio based, so they will
> never exceed one swap cluster, and we now have a cleaner border between
> swap and the rest of mm, making it much easier to follow and debug,
> especially with new added sanity checks. Also making more optimization
> possible.
> 
> Swap entry will be mostly allocated and free with a folio bound.
> The folio lock will be useful for resolving many swap ralated races.
> 
> Now swap allocation (except hibernation) always starts with a folio in
> the swap cache, and gets duped/freed protected by the folio lock:

[ ... ]

Hi everyone,

Apologies for looping back around on this one, but I've got some prompt
changes that break down larger commits into sections and run them
independently through review.  I reran it on mm-new, and it found something
new:

> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 64970ee11fcf7..85bf4f7d9ae7b 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c

[ ... ]

> @@ -2195,7 +2265,7 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
>  	/*
>  	 * Some architectures may have to restore extra metadata to the page
>  	 * when reading from swap. This metadata may be indexed by swap entry
> -	 * so this must be called before swap_free().
> +	 * so this must be called before folio_put_swap().
>  	 */
>  	arch_swap_restore(folio_swap(entry, folio), folio);
>
> @@ -2236,7 +2306,7 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
>  		new_pte = pte_mkuffd_wp(new_pte);
>  setpte:
>  	set_pte_at(vma->vm_mm, addr, pte, new_pte);
> -	swap_free(entry);
> +	folio_put_swap(folio, page);

Does this corrupt the swap map when ksm_might_need_to_copy() returns a
new folio? In that case, folio != swapcache, and the new folio is NOT in
the swap cache with folio->swap = 0. This would trigger
VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio) and call
swap_entries_put_map() with entry.val = 0.

Compare with do_swap_page() which correctly uses folio_put_swap(swapcache,
NULL) when folio != swapcache. Should this use the original entry parameter
or the swapcache folio instead?


