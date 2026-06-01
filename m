Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDFD9CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 18:17:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 014E66B04A2; Mon,  1 Jun 2026 14:17:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F07766B04A3; Mon,  1 Jun 2026 14:17:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF67D6B04A4; Mon,  1 Jun 2026 14:17:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC3EE6B04A2
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:17:33 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7B50F9152F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 18:17:33 +0000 (UTC)
X-FDA: 84832151586.06.9BC8F79
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3C3CAA0016
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 18:17:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=UPHwRpfh;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.178 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780337851;
	b=4+2IemTx1sQsoVpWyNcARvAaS8qh9l9t8y98dF2hpFGrGHhfBlYhsYIWcYaUHuhrXInGdy
	EdNOXGQoaaEddILU6pdpByYqHLHhVeVFOxejS5b+sbY8cF391fEqY2sSXjW3oeBYhjoigr
	Y7zYrISh1jAF2E2mCPwR3nO2wORvRnQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=UPHwRpfh;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.178 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780337851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4NTSUw9VV/FBiRGz8GLXz2sTHCVhhPAhaYWRfzd8BYM=;
	b=j7aFWxWTv8sjq4qb7ZZW0Lr5aahiA7x82u+fpgL93BhCSvugaI/5s2KMtY0LQtrlP4lkUV
	p8Hqo1++Xh6NsZPIqj0o9XqJ4ncGg74ojlEEI0EDBlVjezOiv3TIYtM6pm3q3YztCqu/K8
	MzYulxAn+8t0f9zdcFbjVVqBTGNo7/w=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-9154ca1aa1dso227866285a.0
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 11:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1780337850; x=1780942650; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4NTSUw9VV/FBiRGz8GLXz2sTHCVhhPAhaYWRfzd8BYM=;
        b=UPHwRpfht7mSH+YEScwGE5TD6De4hsoMvxJS43DSInztOnDbb4f8e7hIE6GhP9oimq
         iIGV88XI1a2dbvLB0koZpNHShD8i/eBlrFI/n9d+oJez3rTnanLM3rv4uFZ+QrlYh1T7
         SmCM5ot/lG0xiZwkPTZCI8sKLYhy8Y2A+DpFfCu0jBOb4WghaOYiUtINPWnpOXGN1TRg
         FJsX2/WT5lh5q+IE1lrNic2Y6YgIANKhMorky6vdp5Yx9KvF5f9OP5XPTgNe56eczMmJ
         gGURHJLaMyCf9cNwWhqzUa+gpkT8/092GbeMEV/VnLJMEmqzDIlDeVfAvQxo/ip/7Hvi
         vong==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780337850; x=1780942650;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4NTSUw9VV/FBiRGz8GLXz2sTHCVhhPAhaYWRfzd8BYM=;
        b=EeS8mkfZ0asr6MCTX3LXH7fXWGcY/N7TuaTwnnhEmlI4+8GpxJhvrlhDv1IHkrik37
         nHRTwgqOp8i3mRt3TLomqgQRiwIz1IJKqLejyE6uMkwYuPNxX4MRFi4TZ4TMw66eola4
         XH1i27SXMOtdI+t6sezKfcm+oHqzMpsAby7SJncE869W+wN+CwM8bbMBv4VPJnpCUITt
         2GUUHIdUlos+IM5MmJE7pkIJNYq/qmzB5Wt3BTHRl8wBkYRkAK6RYoWbTIqCrXlX/si9
         4n62D31fI5Fkrr0Fe953Bv33oy5pVA9o5AV7KRoanVOI5btOfBCGIAnDRKp2ZQg34kBr
         CMdg==
X-Forwarded-Encrypted: i=1; AFNElJ9zZhgbclA1ZBzWRzNgI+msmsoN9Q/wU2sFE2BoVPLLfkP7gUiVBgh1Od9dU5gPzZf7TozTSGHz1g==@kvack.org
X-Gm-Message-State: AOJu0YxNF6ed1+vaq+T3RB3Dp0et0lbG4HFjNv1oZ7f8vvjE+jRL0few
	v8lqumbT/kwqTy6SE+NRRBqNrJ5iFQF+NDYcB325kNwpXCDLzsKqrNejzf1h9NwNy0Q=
X-Gm-Gg: Acq92OFdpFtj4UqGt/npCiRyEb3CnO21Njo641hhQzfUmwGB17Ukm41PPEFPyUhh+iN
	Ck4zPFrxyyLZbbJvEgOpkn/pyqFGVq3U03bBG45TNE1MDHLmkhphSn8a+XJQ3KdkrUxyXDZa2NX
	ZSJN/6BD4RjwvJ6baflhsv1V94X4VP024O+LHdXByVA22deK4j4O+uSxWtFSimbqh4zm8Ff/UDP
	qrwShl3daGzPOsW/ObxQp5mtV43Mx3hHIKdfI+5NGjfXgNvkQjwkcYCKp5cMdEUfL1ppRUG+Q/k
	oD+8WQxdhFdvKVDQGJemN794iQnF3EiXuosTn4v9lWYS5PpqB9vO9svQP9yNlDL67Jc8cqTMBwI
	o97H6n8dkbX5Ql2R1GMuwGIlSYpLn/Ixmav2KEAr3XZw2OuX7xwsQhgy6HTJb+FwzAGLIBj41xz
	cxE1sCIxSkSJFwX8jhLavR1LRjjgJQH5ym
X-Received: by 2002:a05:620a:444f:b0:915:4cb9:8e68 with SMTP id af79cd13be357-91577f2ec48mr98534785a.21.1780337850174;
        Mon, 01 Jun 2026 11:17:30 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9153265d20csm1068654985a.46.2026.06.01.11.17.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 11:17:29 -0700 (PDT)
Date: Mon, 1 Jun 2026 14:17:28 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: baolin.wang@linux.alibaba.com, akpm@linux-foundation.org,
	david@kernel.org, ljs@kernel.org, shakeel.butt@linux.dev,
	mhocko@kernel.org, david@fromorbit.com, roman.gushchin@linux.dev,
	muchun.song@linux.dev, qi.zheng@linux.dev, yosry.ahmed@linux.dev,
	ziy@nvidia.com, liam@infradead.org, usama.arif@linux.dev,
	kas@kernel.org, vbabka@kernel.org, ryncsn@gmail.com,
	zaslonko@linux.ibm.com, gor@linux.ibm.com, baohua@kernel.org,
	dev.jain@arm.com, npache@redhat.com, ryan.roberts@arm.com,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 9/9] mm: switch deferred split shrinker to list_lru
Message-ID: <ah3MuK3GuimKVORB@cmpxchg.org>
References: <20260527204757.2544958-10-hannes@cmpxchg.org>
 <20260601132135.14272-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601132135.14272-1-lance.yang@linux.dev>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3C3CAA0016
X-Rspam-User: 
X-Stat-Signature: k6zjjfc1nf9i83ztf4xbuei7hqnnzq91
X-HE-Tag: 1780337851-765516
X-HE-Meta: U2FsdGVkX18fbDvIyHfnZYTtw2gGawDEFXzsmqgB2X5NaLnN7cFoCeaWipQ2NW3nvOhXzkl1Q43SLzJx94ygpjBQWWlHTrFbwMlP0avDn+lYnGdJ1GrSVoI8Rhq4/DGOmSdviOXE5/NnRvbtreiowIvpagGt6TvWywciI0mnhMutx2lnPv11rWam5nmlMfj8GQKqnsi9azADYFfNqMrwE3zSAWfQ8mSVaWkT7R2z0Qcweua3YiEQzI8hC8ODrCs/uZ3xArc9UXqpU2W8Y1+yNPOJeDoAYjP/c0EKZiwFUor6gwcTZeDBX1eSbxxq6EshNCIGu1lLFxHDTKIHHSqT20spMsJqfqrCPlOoQj4BfzkLtCIip4NHoUCXZ3vvJH9HRTKPtmVffK0MBwZSvUUJtxS/48pqZMuStm/yI0YospPnQO9PfihOWV9+AaiJLbMzGZVoWOcCGTBerK84kvBgXHAe5e9KHteFgHKvfb4V1QKjE+d/eh0YEdu9EfTCaU84zUkdV/Vs+k2MCz9I4PpKjNo1AT/mDZieE+yktM5jsKBjDmqWT6Dyn1Xyc5VamvdPnB+0VEnHu3OMBLWdr1Ncc8Q9qeivTGv3i4bEjF1oX3O3XpYr+dsSRAtmnCW1ujVnLvodDlfSFjMwgxCTgsuRzrJTj0JpqbeeV9Ribe1nwcAeOM/GuDdfAL/rA2NXViuPIKruusT0LXrUhCxWTlx0INfraO19C7ZOjFpXLQ6OmakPiQuCuH5vtQ4h9i+1Bw9/kk/QWh3mGyymcGXMFVb4Y7d5mWgd5LZc/xEcDq3iJxf440imkF2bxgboXcpds08MKiDOEAwBgT/BFKQGKEfJBlaLNMPe8yArhF2dA1iuVuZGLVYu1hWPxv2vUUei4QA3S7tg0tjHtdwXddxzsuSV6EdTv9tOlww3cHpLnUXpA9C0/qmR5rb7ApMV/lrPzV+iRfWcRCBeXbYBdcAEZsh
 uPlecUdD
 EC6U4g76FllaiGJI8RVVi9ArvycipKPaJeV1hm1iBsd+EfRw+8AZx0Btsb6SX/+olwEe2mG4HLhIsPlJ4Xtse0RnZ07BrHrrWiCAZXRVq5k3fsl1MjN7j7HbNF6IijGgF0LsjsbrJeKcjrb/Jd9ikGcjepQhqCDegRSBlwjTjpW9zb+6lgY/yKjDpeV/RSlkV5bYgou3eMnpTxi0DwznJDqC8XCJ4Kvr5VrrN5H1bE3BknwCGF2TyDePe2NF4lFq7WGAOpWlI+Y5TfKGpBMbIcpoO9M908wW43P+igbNUs9WJaqgkrbVHBCNqxAc1e7Kk0HtHx0gRozBrcQHFb12dlg3id+BYBHsdsBtO6tJ2Lbe93PWJ/FoYoyVSore7BlIvEXGxwtGVBs+45wbPJ5R4xFM2nGPM8E2j8SVWlx8f5WdTbzv+cP0cb/U76qyfKzXT+CMObFitnOgm6EY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 09:21:35PM +0800, Lance Yang wrote:
> 
> On Wed, May 27, 2026 at 04:45:16PM -0400, Johannes Weiner wrote:
> [...]
> >diff --git a/mm/swap_state.c b/mm/swap_state.c
> >index 04f5ce992401..9c3a5cf99778 100644
> >--- a/mm/swap_state.c
> >+++ b/mm/swap_state.c
> >@@ -465,6 +465,16 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
> > 		return ERR_PTR(-ENOMEM);
> > 	}
> > 
> 
> Shouldn't this be limited to anon swapin?
> 
> e.g. vmf && vma_is_anonymous(vmf->vma)
> 
> >+	if (order > 1 && folio_memcg_alloc_deferred(folio)) {
> 
> __swap_cache_alloc() is also used by shmem direct swapin, so shmem can
> get here too when handling a large swap entry:
> 
> shmem_get_folio_gfp()
>   shmem_swapin_folio()
>     shmem_swap_alloc_folio()
>       swapin_sync()
>         swap_cache_alloc_folio()
>           __swap_cache_alloc()
>             folio_memcg_alloc_deferred()

Good catch, I think you're right. I shouldn't have dismissed that
branch due to "/* Direct swapin skipping swap cache & readahead */"

> @Baolin please correct me if I got it wrong :)
> 
> folio_memcg_alloc_deferred() itself doesn't filter shmem out either; it
> only allocates the memcg list_lru metadata for deferred_split_lru:
> 
> int folio_memcg_alloc_deferred(struct folio *folio)
> {
> 	if (mem_cgroup_disabled())
> 		return 0;
> 	return folio_memcg_list_lru_alloc(folio, &deferred_split_lru, GFP_KERNEL);
> }
> 
> Since deferred_split_lru only queues anon large folios, doing this for
> shmem swapin doesn't buy us anything :)

Yes, agreed. I don't think it's a big deal / show stopper in terms of
user-visible effect, but of course still worth fixing.

I'll send a follow-up patch.

