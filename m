Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E3AFC43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 12:47:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D1CD6B0005; Sun, 12 Jul 2026 08:47:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A93D6B0088; Sun, 12 Jul 2026 08:47:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C2026B008A; Sun, 12 Jul 2026 08:47:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4F26E6B0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 08:47:12 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DCC55A0801
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 12:47:11 +0000 (UTC)
X-FDA: 84980099862.20.8E33608
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id 193A81C0002
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 12:47:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rb4AEdr9;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783860430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pm9nW7teOFNiy7UMYUIullioRRBzDlnrKfEE2/bnUaY=;
	b=xp8n2zC66+UKXTdXJHAjmrRjEZmzLVBwwvfOIrYsoSnPykWsWQb9nrUKtb26RzjGVLj64o
	wcX0NTYNOFI/0SJK2BNtsuCktYvrFCOws9WzV2i6FqJwECwNpzLKopjnCkR/b7FqNpdsRO
	8KYrG++h1GOzW6eoqMB/sEghRtRf11A=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rb4AEdr9;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783860430;
	b=UgcH6zD9RRD3dhaYUgPffJVxxejpCz379cbn6gB+3yQSjfvCr2A1yriFfT0N1ymf9AQ86G
	YYjwbORal6R6ZmCmTeV4cukNC7Vn8d++VR4+jQKKwjulUjuj87Q8KRvadK3/F4RSxhgCJi
	TEZvm3yS1O0c6/VLsirsylwS1axhoFk=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-92eafc94c9cso133474685a.0
        for <linux-mm@kvack.org>; Sun, 12 Jul 2026 05:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783860429; x=1784465229; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pm9nW7teOFNiy7UMYUIullioRRBzDlnrKfEE2/bnUaY=;
        b=rb4AEdr9PamP+CwhsrbH9YGe9oMd+fm/wyIb9CoP1oaY/WoPsrB0YBmqQ6777kS/3r
         YjAwOdKHF3uvlHz902NXR6kNIWH2Jj+YyID8EXMlVFF8GkAhHiM2J0U0pOMaMkTnqBD8
         icxv09q5HNpUVSuXW7NwXGfF/NZjYRSr0I08ffmMY4V2aJZY1xE9d6BiiVrv3zHrBDJG
         w0WFkJw/ezcOwflachZ0TwLFkWx04QPqmWRBobdFASIR+4d40bCGsLcY8HxGpgsu5PNP
         grV5QZRO08HQJMg65TVRA7CLYIhMLYai9r4zOwpIsMM9I0EAz+t8oIroGcrBIgcOxvyr
         n9iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783860429; x=1784465229;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pm9nW7teOFNiy7UMYUIullioRRBzDlnrKfEE2/bnUaY=;
        b=JgIi6JFvoyifSLiq63DLMYzvYseLs//mktBI0kAMuWq0mgSn5kun6mlNgNvJG/fmCZ
         JrcB27Y05IBeRpEngCKbcOw10zHhOo2sbL3r73toElvkMeFiHrlL1r2AlAUSqKLzJoGr
         IOYi0MTgAWRkxqtoVKD2lhiD2l0qGfKeyGTz3/6lWVGVNdeNMNDQ8/tbE4VS1LeLOWvq
         p/ESPCP+7ATf5nLXh/TrY13oazjsyJ5b16lxIhyUpm9gI5QdVN27M2QQB2wzsV5KnpRD
         y/L1WH5IXk92fqXIEzBYvjRHF3jfArLmoC+EY2jjSE/c0eLIQXIO+omTVDQnrxyYkbYT
         JNXQ==
X-Forwarded-Encrypted: i=1; AHgh+RoR3tqwl6Fe1qaiuH75pNsoQxvarr9ABCsiY8qp7SF3avhVWSYuma4qJSPgdFjLJ1Dpyk3vMO0BVQ==@kvack.org
X-Gm-Message-State: AOJu0YyzD/eLZvkEhkjnKkLfiPa00m4vSUF4/7cnQ5GipdOZbQe2v+kc
	Ef/LCUwXlB5SqnHocnPjaKsJzgSYcMFg/TbAcLUriJKGVkxdiWHYOYvPvd8MBAa93uw=
X-Gm-Gg: AfdE7ckEGa+jG+VL0R2Vp59tAQ0uoCKoN15CUFZkyk2wTQlt2y16jN6gNzwBctYt0Xf
	nRm2oAV2d+Z5u6L5cKj9SawjgsPhy6vB67UL/tZ/BECNVpQTpgYYi80C3pvAQqdqVLdW6kVUr+G
	TsRm2wTkZFW0iXApbW5Sri1+2K/3B6USSWKJ9JogEZyorLXUVwa4zxGblBLTO8OuCXBG44I5oM2
	0sPQ8RHE7UC48HV95JdPOJ8+gK5MkJ3DUOZRQEMD/aXTyeDYUhJfwUGLufpG40jQ21QOuhtXird
	bYVqgC4FYi7I7HhEFfVuyaNMYdKi8KR/AP+Hg+VyX06lfTAa01136g38jl5PeIP5lP42hv9V2/Y
	HzZ2dlTMFRO0y3n+0k5Myv5ggFY9YIxT07kjSCKQO4WzKhHrXW90LvWOc/+KUmgPBNIKxC++2TW
	RPi8S2jh1ORHW+HLapiErZDLVGYuSi3Ppo5XeUkLQHMv5Dao4Rso7jhxV6RDzXW7PHaGFRDto6C
	xSNIXY=
X-Received: by 2002:a05:620a:318f:b0:92e:c117:5edf with SMTP id af79cd13be357-92ef2c40a92mr592338785a.75.1783860428981;
        Sun, 12 Jul 2026 05:47:08 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5cf9d9bsm833767185a.28.2026.07.12.05.47.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 05:47:08 -0700 (PDT)
Date: Sun, 12 Jul 2026 08:47:03 -0400
From: Gregory Price <gourry@gourry.net>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com,
	balbirs@nvidia.com, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, byungchul@sk.com, david@kernel.org,
	dev.jain@arm.com, jannh@google.com, joshua.hahnjy@gmail.com,
	lance.yang@linux.dev, liam@infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
	matthew.brost@intel.com, npache@redhat.com, rakie.kim@sk.com,
	ryan.roberts@arm.com, vbabka@kernel.org,
	ying.huang@linux.alibaba.com, ziy@nvidia.com,
	shakeel.butt@linux.dev, hannes@cmpxchg.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 3/3] mm/huge_memory: skip device-private PMDs in
 madvise_free_huge_pmd
Message-ID: <alOMx1NkL1jeabg3@gourry-fedora-PF4VCD3F>
References: <20260710105557.1987433-1-usama.arif@linux.dev>
 <20260710105557.1987433-4-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710105557.1987433-4-usama.arif@linux.dev>
X-Stat-Signature: zz87h3jtmyih7ghzi9ayente76pbi8xd
X-Rspamd-Queue-Id: 193A81C0002
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783860429-801483
X-HE-Meta: U2FsdGVkX1/NF0Se9YAQD9kpN0kA0fTWJqHSSd4NHU6wnD4COpY/NUPhq1IHiqO0qgC5uauVwHZaPRLNbe+9uQilwbSAI/w/BjTLnbyyx6/ZID6sBCXmsHLvy/1q5Cty5tmlRI7uxAmPK7tulUAEJcOdJx0cO0Rc4gmzc77KfgPkmwvDNwakxj+sgJ4zfC0NOePuRMkhAvvpeYupbKsw0uYstLpKuhh/PL2oeUq4KCgVaFIc9A9m0WcJlpoZjTLb1CrWkfOqOj8CuxMtipP3/qnQocl4wWDq78JF5ERj/KSpicmdX3348tyWzsfYyqmtpKXXh1GV/WU+opDivs9eHhMGUBtR5n81Tn+aRmpqWLOuvS4pPv3u7rvXp2JtOyA+y2UqiBWZCJws/w8LC2b4VaSlYxEWz2rWrP1alAR7iwthZiG1v1IyLm4zF4BKcJxMnWQhWngfP6BdNtApSeN3iGcWNBhmgNiT0uDYeFthl+xYfS5Nr7mJOxEI69iGR93KjPSqdxv0fqaWSG2zxjTvDkK02oZqN9i+mYeU7L4cjR1O1dSpHGCGUzPtCqWfgPzw1Yybcs1NPrRzCR+gDr7yXKn+HPGouCilwsBv14oktcpxOVOOUMJX/kLbCMCrQ9JDSyuXirhIYLdb38BlMhWxIH7fH5aCvCITdjDnUnr2IuP0k/ydkaQ3tdthhLd1+OH5nKB1iV9KsY4c8oIUGaeWRiTc3Nx71aLwI6cXATvJRDiBRQNbWwYIX32qDRBqTyemBukslJLnu9BfNCe58Fnx+kzLaMjQPb+DiUT38cTOHC9f1k1/uWVzVrX33yKQ4crKhpBkGQcZHLpgW3weabsDTi1toAGpkTni1hU7i6xuBdag0inyrx4ByNYi94vshhvrXbvzmL7MxXLrhyWoNTUPb+qcbfsb6k3ri5/AwE5ktit8Q6c7T5bWrfGJ/rnWJg8oW5bYlIbFSSjQohf9Yyy
 vldvgC3e
 ocCytmN3a4zOEx1pR2knQ91/ZdPzCre44FAmj2CagT9M1P1t01gQFEzWQWevcqwf3DDj/90GlXcpzYZsE1bPq28QA6cAH3zelseIoVvvTQAGrQ7NNuLcdDsNnPpmD6D/I4X5nVvTPcXWgqHMkxk2oBqu+OzEcQHrDW2UxC7rHtlLuOOge8KmJPpxK4UyKk972Srm0RQxuHALapUyhoNOjNt+Z1HyMVeix4hVjszXCCOcIhc9lD0ELlzjPCXPiUIYQA2KB1r/l0xxB6p1IBoAGUO0vWT4zre4UD7WvKv5RHWhMEGZn/UJzFb51XKfcExMc6YHzlJTaKuIJwQ2yYbwGLsN712ltChnLaimC3coSKL+uP2Jjj/lEnnOB0mqp/SGUlsMFacJjbGICd+iwIROBNDmoqpG5qqv/SJKGZcPMAYPXQ4YlNW5+Y0NTNXMr96bd7EK38Um2EA5zzf+Cb09mCajXnOG49flyuG+xRKFOSxl41RlYY6Cf7W7ax5JupSWn46i3SQBap9xkoucp65iyvy/yuXya6GOb7wETc0BwFfRVFCNYHxVW9R3DxgghY4AraCJAZs0RI7Zi+KxL++OmQD0WxR0XC8iG+oAb2X+mhrC9WESRs8TsJH2mZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 03:55:23AM -0700, Usama Arif wrote:
> 
> Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
> Cc: <stable@vger.kernel.org>
> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Balbir Singh <balbirs@nvidia.com>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Reviewed-by: Gregory Price <gourry@gourry.net>

> ---
>  mm/huge_memory.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index c0892cc533a9..7ae21b006b68 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2297,8 +2297,8 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  		goto out;
>  
>  	if (unlikely(!pmd_present(orig_pmd))) {
> -		VM_BUG_ON(thp_migration_supported() &&
> -				  !pmd_is_migration_entry(orig_pmd));
> +		VM_WARN_ON_ONCE(!pmd_is_migration_entry(orig_pmd) &&
> +				!pmd_is_device_private_entry(orig_pmd));

I just realized, are there softleaf entries we wouldn't want to WARN on?
If not, should all three of these patches just be something like
pmd_is_softleaf()?

x_is_softleaf() does not exist, just curious if it should, and not
worth holding up the patch.

~Gregory

