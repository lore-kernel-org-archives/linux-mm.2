Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AC87CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:13:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A6126B011D; Mon, 11 May 2026 12:13:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47DCD6B011E; Mon, 11 May 2026 12:13:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BB646B011F; Mon, 11 May 2026 12:13:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2E1F96B011D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:13:23 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C3E2AC0AED
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:13:22 +0000 (UTC)
X-FDA: 84755633844.10.B37CA21
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf26.hostedemail.com (Postfix) with ESMTP id 56B6814000E
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:13:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=IddWjTy6;
	spf=pass (imf26.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778516000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z5TaKbhZcXwFj2Ql7FYh+c5RLjoEoIOFhZpQsZFqhRs=;
	b=x0W7G3Q9OpbckQEDEBEgAG/pRD5FmQkANSKI3SHwIf6l4uHfya24OSWlPvHEz4FhcELe2c
	rwHpvqE1tC6fgtjxBy+OwTO+E2bcRO9Vv2IcYpH2eal1P+C7Zh0mqHU4UhONbvtn8defQZ
	phe9Hc/Qtqa9BZr4Ht46crMg5J6JElU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=IddWjTy6;
	spf=pass (imf26.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778516000; a=rsa-sha256;
	cv=none;
	b=2VzK8SW+nBM8SZat6/H46rYt0DN9gkTIqR5K3kysZPSOAoqhyvbKuFXcIxsiYMpoK1d6z8
	6j/bDKUWl/PIpMM5z25wBFJXGHrgxf21xIv1L6c7tF/dZNOM7MD5E8kZynPeLn0trW2UHx
	LfUtQcdrORWWDYFab9hq+hZvA/5CJf4=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64B4FLmQ2171729;
	Mon, 11 May 2026 16:13:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=Z5TaKbhZcXwFj2Ql7FYh+c5RLjoEoI
	OFhZpQsZFqhRs=; b=IddWjTy6cGUFS0XOgECTEJCgV+0+Qczpe+kceIwchVV1Zw
	uBijdUM9Gx8oUJ0yl28EG43bT0/hJo34x9QUTwPBRlAJkp4ckYDSIxg87EDXYOF9
	XYbanb2ZwTwyOON3nocx34p20lQnO7VNnzNLLyPbwQ8lrwGqRXsb0XqniAh0h+Qj
	Rmpq4bRxqnlSyXKIRnvjTjYrxGpbxJ3OhsdcO54RAREnpVg26mzxN/FK0a1eV5ML
	tbXjEfc1nt7FBRGneTezD7IaDLDWI95Bi71BaoHLKwOtOk96J7Vh4SkpbxMKM9GB
	rzFdQCOKd/PzUaVEyOw8+VcYQHTThDgX2QkjLoLg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e1ubdrn88-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 May 2026 16:13:13 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64BG9cJn006079;
	Mon, 11 May 2026 16:13:12 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e2hxy5s94-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 May 2026 16:13:12 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64BGDBJZ45351282
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 May 2026 16:13:11 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 285F52004B;
	Mon, 11 May 2026 16:13:11 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E421720043;
	Mon, 11 May 2026 16:13:10 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.52.215.75])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 11 May 2026 16:13:10 +0000 (GMT)
Date: Mon, 11 May 2026 18:13:09 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Minchan Kim <minchan@kernel.org>
Cc: akpm@linux-foundation.org, hca@linux.ibm.com, linux-s390@vger.kernel.org,
        david@kernel.org, mhocko@suse.com, brauner@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
        timmurray@google.com
Subject: Re: [PATCH v1 1/3] mm: process_mrelease: expedite clean file folio
 reclaim via mmu_gather
Message-ID: <d9644dab-120f-485c-9324-205282d89234-agordeev@linux.ibm.com>
References: <20260421230239.172582-1-minchan@kernel.org>
 <20260421230239.172582-2-minchan@kernel.org>
 <20260505145318.97692A14-agordeev@linux.ibm.com>
 <af5cEycgIu2GUicn@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af5cEycgIu2GUicn@google.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=BezoFLt2 c=1 sm=1 tr=0 ts=6a02001a cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=dO0aIYJa2u9nTzUSCSsA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: C6p3qwjde6tRgWBCVLk7qSGEZWixbkUe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTExMDE3NCBTYWx0ZWRfXy1q93jGdVJAi
 0V4l7W/pe3DUJ/WDsWqIduR7VS+sDqJX/8BY5FTNO81r2SEoTynPkS/9k5gXe4rRuIuzZE1ewwU
 0y4sdgAA9K3+enE1jPxpCpC+6k/8fVoI6AeItKMTh6ZlJXN4reNtlWZym5QfDY+Ja2SQgl2bj5a
 DtYy6ZTP/VBDo2j369UzAE3gB62AjBlcsmH1A2MpLkTwoEHYUE79tXNPWe7eXf5R44E0j4IZMtt
 2Owzwa12XDxvqqc7tZ4qxzcq2HIOtmtzOqJTBjojI2lE7L0qmsccaaKGxXlhNuO4YCFaALPV5Rb
 4P9RWI1RlVGK+0IvBwnn3P2F+2599s53tquJXE0KT4Q26Hgd+kUXfOussFw1CSgXiNNWXc9xNAs
 AXCsAMJxCCDOk6wIpq08SX/EdBlnQxYuxj3wv2LXAbkiGhxbuYgRUYdIgW+dgbcl2XtEdqh7Bl1
 r31a/8hCuUHwQr0qyIQ==
X-Proofpoint-ORIG-GUID: I8FAFUP_109BHlu__ZTcZ34HlWDrp4tK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-11_04,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0 malwarescore=0
 adultscore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605110174
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 56B6814000E
X-Stat-Signature: 9jkehaxp5ejxb7huik9j86uyptfa94jc
X-HE-Tag: 1778516000-185148
X-HE-Meta: U2FsdGVkX1/yPifDAlIwGCqXyUXTSvkfOenIGRJdzZNGBqLnXQpQu6OrLSyU5CXZttxVugPvVgDtILJHrw5oLdYJXA0rk0fER0CPyRSx+DVEjienCA8sH00APCOXOQYsqxYPfj2UR1ZyNOomNcosA6bpReBrSaRg1O31qB79hS+UCDHFvRI/sjL2bmYnUGRnAQoR9vWl9bjk2+ghPVrzSxNRndipG69aUkIjcsp3VvZM6KecRZP8tjkXEZoNs4zE3+kR+umnrkUtwAuhRvTNNKNMZ/TW+awxz+LzgU/dLjTDcJAL/Els4jk0onr6GnM/X767L60Bpzx2C+otzsC6d2dIkkOQTpFm6IvOA6DY1o1islTy6sU0Lbzg8JDLZZ6qS1HI0Da1HVWqoh/7Ad4sTu+yar4ZIoub5m7wuuM2P1e8rARJP9sVic+1trVDBtKT6bAEdSgBPD17rBagZtSBcL/iEC07oBd5nqOd19bBU4dD7q+Z3HxJ+N40PTg0TWFlzUZTGxuKxN1+IeCxRgdB9CNFUylVh/ZS/QDtYEMhOt1VIY9P0xdYA17186UZ9+pFES0VD0+19fM1+D9jPFWHTwccmA07LYkXEKKOMy35vZ9fZoxKYw6yOJ8M4C/xE5EiFjLkzgQzAvkUUszrGYYdZQIN2wulb/NY7Tmy4dQ1nTGQ3eRALzWjGfYZyx6dz4EnN2ekw/bQsfG83Z/PyIYT39Fxn1359MDIw3jdu+HZesw6WjYg5wjYifstmHlxHZNFa0QRAt7zuLjZOYpXNcD2UEUwZQkNNztrnwcdr+tXnNx39xi8fAZ4X5Yq34TftE4VpeMP09HLBKvZPb1gRDlYp7Wul1ism3olU0Ej6BZT3hsK7/frk8CqvtF/loNDRGu3JyTtQlTb5Gn9/4FMWEmPKhxQPhgplIGoCRZylCDJ3/A/XT9vu3lfALBeQua8kbxV8x+nsf4NE91sRs9GvRV
 FuQnp9Mg
 JXqeY5IiU5r+mApTd8PnPXbJACPrsNHbewmNmfYweBtFabjiKv479TtK30+S09Gv2K6m9GELAvHwgfOXVTVtCRSHhtwLYATeVquy4Vy5luIkxn2/6UXsHacGmG9JXx/QtIl7Jkf5G6GvqG1whhQiUuEEIUM2gs1lSHIw3WBd6euQyLJ/Ppd4Ycl1D4LbtEuzU3wzvnBAHQgXUve8F8I1qsifPjdu1z6d8LKQZaGgOVrUaaw+4EECZ42IN9SLNmuhzbII1pgeYzW3gSoe8UlMgg3nTiXBawml9fIrkemldqp/wgsyRxJIHB5EnxigAwq8A5aKp+TfVzbe6lzTdqxXGngJ7FeEJQiJUmCmwB47Pw2XZYf4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 02:56:35PM -0700, Minchan Kim wrote:

Hi Minchan,

> > > +void free_pages_and_caches(struct mm_struct *mm, struct encoded_page **pages, int nr)
> > > +{
> > > +	bool try_evict_file_folios = mm_flags_test(MMF_UNSTABLE, mm);
> > > +	struct folio_batch folios;
> > > +	unsigned int refs[PAGEVEC_SIZE];
> > > +
> > > +	folio_batch_init(&folios);
> > > +	for (int i = 0; i < nr; i++) {
> > > +		struct folio *folio = page_folio(encoded_page_ptr(pages[i]));
> > > +
> > > +		if (folio_test_anon(folio))
> > > +			free_swap_cache(folio);
> > > +		else if (unlikely(try_evict_file_folios))
> > > +			free_file_cache(folio);
> > 
> > This condition is absent in free_pages_and_swap_cache().
> > What would happen with non-anon and non-evict folio?
> 
> Are you asking about mlocked pages for file?
> 
> During unmapping, munlock_vma_folio() inside __folio_remove_rmap() clears
> the PG_mlocked flag and moves the folio back to the evictable LRU list.
> 
> By the time the folios reach free_pages_and_caches(), if the folio is
> exclusive, it will be successfully evicted. However, if the folio is shared,
> mapping_evict_folio() detects it via the refcount check and skips the
> eviction.
> 
> However, I realized we miss shmem folios in the swap cache due to the new
> folio_test_anon() check we introduced. I will update the check to something
> like this:
> 
> if (folio_test_swapcache(folio))
>     free_swap_cache(folio);

This condition looks redundant, since free_swap_cache() checks it too.

> else if (unlikely(try_evict_file_folios))
>     free_file_cache(folio);
> 
> Let me know if I missed something from your point.


Thanks!

> Thank you.

