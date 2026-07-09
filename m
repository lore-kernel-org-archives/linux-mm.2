Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4857C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 15:34:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA5E56B00A3; Thu,  9 Jul 2026 11:34:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7CCB6B00A4; Thu,  9 Jul 2026 11:34:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96DFE6B00A5; Thu,  9 Jul 2026 11:34:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B49B6B00A3
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:34:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 000771C0F32
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:34:14 +0000 (UTC)
X-FDA: 84969634428.25.C80C434
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	by imf31.hostedemail.com (Postfix) with ESMTP id 35B7020008
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:34:13 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="CWt94/za";
	spf=pass (imf31.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.173 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783611253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wgZAKDefd+qsWOygAjWV/OqF2VHOBPEQz/tYDmXsGXA=;
	b=FeqYRFCuXtZZRokhLWnvtF2+Z+p0QIY2GxOO4IAa6gT1Wi1+1X6GFJwkiyGEsiK4M1126j
	GrzdRGX+mmxzmZAWNvtQU4mRFvGuZi/8qj6yJ/fdCN1TDzL92pI4fUXx0pI3p20JwlpdDm
	FHhh9QOjmUcy5D4o9bOX1Hi5D+cIvbA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="CWt94/za";
	spf=pass (imf31.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.173 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783611253;
	b=Ix8n4u35K9OlAeTNBrxAToLwN4iMVd0dqAmMP6iXu3SX3lt7tX86w9IRWqMgDd7nAauGpU
	OIUnMbT6XcGorLsMjiPkHYHQxE2Nyfy/6TVH83UzPTWGbeJ+guGCVyuTTmQoHjxDCqJ4EY
	BOnDtRVpv7EQKV8r/HcGr7QxEwdJNrc=
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-499f6e0bbabso1238950b6e.0
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 08:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783611252; x=1784216052; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wgZAKDefd+qsWOygAjWV/OqF2VHOBPEQz/tYDmXsGXA=;
        b=CWt94/za9vLPH1dM1XpEC5H3PQ6U/XQ+8sVc+yfLUew8XHCYKZ8UJf8ENcBLTx2C9Q
         GgTqmcj+XwTgKNWWfZYozWSRPp+nA391Bzq2yHoxZcCaIF9frvh9eQ86d2DCm2tTajrO
         72G57011TliflA3o6RhpVs/QjHIt18Z5/jUddY2r5MoJCkAapHq7wiaYDfEwzeDx8cYc
         Wlt0eGPEYKVYz2s7R5K3adAHMTQlak0KJDMp5YLirGnTLl6mXyF5SuVxSB0yyfXevZGa
         9yYTGLns8RuCuwyjxGH8SkaWuaEGQTbNQdSjlw2WZ3S58WixDjlVx0jUCaaBVLwRpizj
         UOjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783611252; x=1784216052;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wgZAKDefd+qsWOygAjWV/OqF2VHOBPEQz/tYDmXsGXA=;
        b=Ph5f6pk8fH3eos39PE88NH5mGIF1jFJ5CZHqlEdRGJ+/uUaDipDFCv7Y6+UjjT9/T/
         ZnflxVmvShSXCvxZPX1JDVVBenAEVXNVB3wCodrNSWO2Hum4F39MwbSDDVB9hkA21MpU
         TsGLvONQohdPBCfpyRq4HMJtwlpPBL3UjEPg9vcodNqHtWKWPVeFpMggPAbSIXAfvLrf
         dy0XvvtPlNybid4Ch/QzI2E99CCQzMp2iZbB0TmHcNJfz/uVLA0882q1mVayqCowJmuO
         Mavud399Y3wSEb0WPrdX5FxC4pCLt1LE1argA67hZjhXKvOgxOuuupJSQMVBH9oNA4DT
         2ekg==
X-Forwarded-Encrypted: i=1; AFNElJ8D54dAoY9YUYosBcFlECdrViPEWY/VlzEgm9OKQLLix+cka5B3KPfvMJwUj8wa3w+mca1Xsc2ftQ==@kvack.org
X-Gm-Message-State: AOJu0YytookgVCmbkZiAve3yvbXDmUni/5w7LTXGpICzMhpYnYyOCjmP
	IyGvhfC6lvryYSZyNfAUlxSNDzWiRSBBIFY+srDSIwSCf+VH3H86vlXB
X-Gm-Gg: AfdE7cn4FNMF6Clek3+MZo54hj98T/f7r6tZcfQbGTz8P+YuuJFARhln6OkcohuF0bd
	Yzh98Pb96q9b6PDqcdFu1u7wS/BOtBSf1oQPiiPUyYbyU0EFKkeUc2U0cbaOkIipsK/+29ruYaN
	T/SDPXq1Uk5T6jKfJ/QPeFNyWStPNwPG19GU5PnEK1qbL1YIgjPHkb0zwgvTkGfgyQOmkbqLArl
	hhPYEShOFOSi+B1d8NZJwYlm1opIVZRUvev2Kev32qJXik2IOS0UiIi9fWnAP/vvb9Sbo4pS5Jl
	ynvkBfDuv58OkGqP6VX2A4NsGbwYzC81xoWXpiw3rJu28HziYew5eNmnMY+nAiDrWf1wYXVaUC4
	DbzahjS4ciMg3gwxc6+5wTUxdZfDNL6mvpWkK5F4yrx8H+3ey8oTYbOZehjSK2b/88WSCt8isWs
	I6nTfe5uMDTrfM9hgvNo5AbqQ+OYI3uqkopm169vS+48U=
X-Received: by 2002:a05:6808:f88:b0:496:7ba:89b9 with SMTP id 5614622812f47-4a204ffb038mr5628776b6e.32.1783611251981;
        Thu, 09 Jul 2026 08:34:11 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:10::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4a1acc83099sm3948634b6e.2.2026.07.09.08.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 08:34:11 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Xu <peterx@redhat.com>,
	Wupeng Ma <mawupeng1@huawei.com>,
	fvdl@google.com,
	rientjes@google.com,
	jthoughton@google.com,
	vannapurve@google.com,
	erdemaktas@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ackerley Tng <ackerleytng@google.com>,
	stable@vger.kernel.org,
	David Carlier <devnexen@gmail.com>,
	Zhao Li <enderaoelyther@gmail.com>
Subject: Re: [PATCH v2 2/5] mm: hugetlb: Fix subpool usage leak on allocation failure
Date: Thu,  9 Jul 2026 08:34:09 -0700
Message-ID: <20260709153409.2091070-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260708-hugetlb-alloc-failure-fixes-v2-2-c7f27cbb462b@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fkh3uctdwza54b9xsq77sxpdpyrzijtk
X-Rspamd-Queue-Id: 35B7020008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783611253-798494
X-HE-Meta: U2FsdGVkX18nk2MdfXIEv9H6JEtccpcl2DerfZEzfin88QYRhJzAtZLW3eoulcofayLRKW9Hup0JfZLnED/QN5MwXHHWnP7LUfuqQADOkQp2WW0p8sm8Q8LD1opGxawF2VNUrZkUweGM4jM1JWp95JFVz2VLqweKVsh7lzWvVqHgisO7mBnXrmjnjGV308xy1+JzZM7dtB0GE1gPCqwi6tMbyOXSVvfMC4YrFKWiv8K+E960P9kYvmS1F0U1jzaIXR4VZHhzgC2zQulboXbghVz4NlKIh679z1daq4TyXfD+6jtVYjywMSt6NzmmLy/3On24vRoiYuZcIfpNnyJUFz3jVe7NmdcA3ACTFNNJTMOZck8SlFcE937CQrYYgxgdXTYisuj1RAnJetY+mfNyahZ4e4qVdcy6dfcdyXQzPn4q4S2IfuKr4MXGxjS4RuRLBZmCLDsiTRKHnJCXBpXHw7vZvN6fpn61F/oHZ11m9tDDixYfnAUI/+pR3OIRhpG8mILYPC5CFJKIAhSVSUqcEdu5EAvTxwXOvsjlLlSvfSNQ8rukX53jhbjPUHUJalAt63bbkDLex2ymPOsJzyCvkEGkDskqPjC3/5XBO0yMA1ESe1q3yeKdoNkxUbM6hWBSKtdN3XO1FpXsNhr2FH90QYn5HzLVxR7Q8s7W1nx7zqw4ubtrWFJJFATVAOWucYY4HLexI0J7+EKNW2Xn0mW1cHEgcFZB2ngNOuXAdfFveP0LDi1DL1BNO81TUO6dX2CDwn6MlXRjrT2eKffbrWGWYfXYsJvLE8pqeRUeRsYGQpIfK0xPtoAb3+jzRoZgwO781vRLFlpxwGHJPON2hh6cOGxPqZXsqpDsdc+7okD1yft9Qd3/rhX3C9x6vpUHUEin+bZNrsciIBKAWfqJPdNUzMyJS/xKvO2V04MIOJ3rssbF0IUfhQ2cUkYYczZ2V5VoU/REeWgbp/KCWn5P8y6
 DFvp3LYI
 cGacMRNjGHGQ4lXtsM3ryV3xJun/2DWJxuQ8Y9Qjc6DxdJGy/ckLn9Cxx4f6e1VmLGuCJu8p6UAaAmVzK/VgF5iuzFN6IU2Eb1A9k4OxMCnSjgzEGv8/CQ2XLV1fixvrxtiN2p0lzI7z20JsONhwo0rAElLa4ZbUg2xmTfQb+X1Hz9m5mB2jeotczxMeR5Vu6WODPMLmEqmLjnNX1AZXpzMVg6xKYFqKoGB7iaCwkR5ENSxYMyxvUeUSo3qakwhRCX0xquoOkcw2SOZOlGYMLd+hEVqMvGGhQ8YI5oty9/vcHJEfgR0T5AjN1Fq4rs+8Jz1L/UQXKJH4tNvgM8MPkuSmLM/q6HY6RDagw6KpdNg1L6f0osGGIKTF9+T2u9pwRqLWwibHq+Rdj0GiUMeHkyL3GyojKhrSEQjmQA332gkDBj5z/uAq4gNs5fPziC0sErJOoShusSMK2a0gc8uhnWXJi64BxvkN4whIIDMDw6FveRt8H5XABfQ8/OAiEDjqNZ4uIDRzx/dM82Q2YvizACGAxRtZHgbqhIoJMSAIhcfEl3xJ8KdUCryQ6zkT0mW6M9vHa6YTkWbXoBGUXd3RWOTsxFUa0lxZl7+nx36vfOQHJHK4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ackerley,

Thank you for this series. I really wanted to work on hugeTLB accounting
fixes but never got the time to get to it. I'm very grateful that you
are taking a look!!

> From: Ackerley Tng <ackerleytng@google.com>
> 
> When alloc_hugetlb_folio() fails early (e.g. buddy allocation failure or
> hugetlb cgroup charging failure) and gbl_chg == 1 (meaning a reservation
> was not used, but a global page was allocated instead), the subpool page
> acquired via hugepage_subpool_get_pages() must still be returned.
> 
> Currently, the error path out_subpool_put: only calls
> hugepage_subpool_put_pages() if !gbl_chg is true. If gbl_chg is 1, it
> skips it, permanently leaking the subpool's used_hpages counter.
> 
> With the earlier patch to always track used_hpages in the subpool, always
> call hugepage_subpool_put_pages() if map_chg is true to consistently
> restore the page to the subpool. Only call hugetlb_acct_memory() to adjust
> global reservations if gbl_chg == 0 since gbl_chg == 0 indicates a
> subpool (and global) reservation was used.

So I think that I've seen that this part of the accounting specifically
is a bit suspicious. There have been two attempts in the past to fix
this area [1] [2]. I think functionally they are quite similar to this
fix, they just open-code the contents of the put_pages function inside
the condition. I've Cc-ed the authors of those two patches in case
they wanted to chime in.

I reference these fixes because I think they handle the minimum
subpage case a bit differently. To be honest, I recall reading those
fixes a while back and getting a bit confused on what exactly happens
when the page is absorbed to fulfill the minimum size...

It does seem like Sashiko also notes this as a possible concern.
WDYT? Does your reproducer for this issue also work when a minimum
size is set (let's say, to 1?)

Thanks again. I hope you have a great day!!!
Joshua

> Fixes: a833a693a490e ("mm: hugetlb: fix incorrect fallback for subpool")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  mm/hugetlb.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index ee5e99c1894b9..4093c1c0a4a1d 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2852,7 +2852,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
>  	struct hugepage_subpool *spool = subpool_vma(vma);
>  	struct hstate *h = hstate_vma(vma);
>  	struct folio *folio;
> -	long retval, gbl_chg, gbl_reserve;
> +	long retval, gbl_chg;
>  	map_chg_state map_chg;
>  	int ret, idx;
>  	struct hugetlb_cgroup *h_cg = NULL;
> @@ -3003,13 +3003,11 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
>  		hugetlb_cgroup_uncharge_cgroup_rsvd(idx, pages_per_huge_page(h),
>  						    h_cg_rsvd);
>  out_subpool_put:
> -	/*
> -	 * put page to subpool iff the quota of subpool's rsv_hpages is used
> -	 * during hugepage_subpool_get_pages.
> -	 */
> -	if (map_chg && !gbl_chg) {
> -		gbl_reserve = hugepage_subpool_put_pages(spool, 1);
> -		hugetlb_acct_memory(h, -gbl_reserve);
> +	if (map_chg) {
> +		long gbl_reserve = hugepage_subpool_put_pages(spool, 1);
> +
> +		if (!gbl_chg)
> +			hugetlb_acct_memory(h, -gbl_reserve);
>  	}

[1] https://lore.kernel.org/linux-mm/20260428113037.88766-2-enderaoelyther@gmail.com/
[2] https://lore.kernel.org/linux-mm/20260515202902.461539-1-devnexen@gmail.com/

