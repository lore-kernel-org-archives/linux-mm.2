Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3254DC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 18:48:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03C116B0088; Thu, 27 Aug 2026 14:48:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2F246B008A; Thu, 27 Aug 2026 14:48:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1E5E6B008C; Thu, 27 Aug 2026 14:48:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C0ABF6B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:48:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 372CB160189
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 18:48:49 +0000 (UTC)
X-FDA: 85147935978.09.75FE0F8
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6C31518000A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 18:48:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=X0F94sZu;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787856527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hGoSq2TdAc7iekoqeJsQuM/rBlzw2s8Vqw8atuDxr34=;
	b=CQ00Hc8NlcY7ljIWUxVBf7WfC7JidJNiblSkzRndva5Vhr3U2zwBQs+Ylw53UCjN+5rqj0
	t3LzRANVHZJgkrYIJh2/tRworiw9WUd5j8ww7tOACOR+Hj1xmLzilWTHGVKC2KxrAzvquD
	6ddPH+HdXBBisRgk648knlXydSHc2xk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787856527;
	b=WrJ6TG7+QlD2T3mhhIDkuKKYOKBhIHOdeW9XulQNDstgfiyU4C+PIHxFjphvO2tpMyoj/r
	T+ARRSStT5KhtktR+tx+d22U1CUuRZLfBT5BJIdrX+RnsJL0k4CEev0IqX3oJfw8ako9Od
	1dmK7LOm3aK/GLtrf9Ar/WxgH3mdwdk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=X0F94sZu;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-93903d81a82so12026585a.2
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1787856526; x=1788461326; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hGoSq2TdAc7iekoqeJsQuM/rBlzw2s8Vqw8atuDxr34=;
        b=X0F94sZuy23zPPHe/ng+f7KFyoaOVV7OyBKMzlGfssGlsft8CKcRnGPppJLmpgn+eA
         LnF/yCsCVdPjR4/GZHFDRU+dWCPO9vh6IlI2NBzTLP9CP+g98A/knZhu2eky8tWOM8sP
         XpNACujWQg0TDraJTf1E9+m7fZzB6SAdtikN2jUVUxsp1FC07S9r0+zbdujOgXEQYs1e
         oL8OOL007S46LST6cTXdjHE+9Qrtm06UEn6Ua/RBMm8PuyCFTFnT71WdsISsbY8Pf3m/
         zjqzcgYR/yLupq5xpsWd31euG9QsdJTlpNYYI3Flj90qyebGdnLE+2EYUvLv0CJ0rtNU
         Ir8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787856526; x=1788461326;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hGoSq2TdAc7iekoqeJsQuM/rBlzw2s8Vqw8atuDxr34=;
        b=RzSOyqUfB1NzCK8ZJGvXcri2EQE+MYK32J/GBD5wYn973ce6TvfTXmVCQhOGA3SXAz
         EHd1l+SylEVg7J5aFtsFaiN0/eFfem1cKCC+28LD63Xs0eC029HPG1x+P/xSom4FMsnP
         PHDZ46HLM/rnFM53V1gUXrBp/ydpv5qjBEzULzeIdZTrQDWymoL+mTvaMCpApV8REfFJ
         ikMgwFts0+UZzxuhYAtAND+cA/WB51w1kmMZoqnRGtKmMeOLhOF8qUSvMqb7hi94Mx0Z
         nWPTixRddwWZZh5gbfNNkNDX3+1b4GFJ7nfLOhD4PsrycKB9wE0SFhdBKHREUNJPaahN
         VIdQ==
X-Gm-Message-State: AFuF++kHTCgAf5Q+gJn+OKuZiaemSQaENU/J+yZrSH/mdZK9s7fiYeUe
	GeNHM1lii+3Y6NimlZ4UI8jBcu6VqU3a6HamJ07zSculkY/v6qpR+EAqeZQrvlO4BkE=
X-Gm-Gg: AR+sD13P2MAbb4lyRofDWKIAuDRMR9MZFPnLBzntSZO9DJBNAXz33iNPoT9viPCCrFh
	HL+wyfn0GtsyPzhuaIrd/yQNq/2T+s3r4MucjRVNKpGdzka2aDyA9V6m2F7kjB9Sulb9YhCTndc
	24uwgGNItaIzeaq48/3q+w/u9sxeKhnImvnppuTBRqJuaVfhmePRcKd+Tf29/ko99zhm4/TnOQP
	lKTfluUgbF81vi5S+ZWlhMBiT6R6G5cyymhZauLcBXn8yXssnTv2uGEadD0PF9+rxbQjRak4l+K
	Y75oT27dEmZ8NQbNLRniSpFnvGGHu7gVzqLVqEY6h1pan3/4naHNsVUq1A9VtiZVZ2WDKeEfw7F
	BTEyOYb5xMUFeioTOhxdrtUwtG4Idc1Amoh9eKKVA1VED+r+i8B4MQ+hF42c28v+gDSiXKVzbbe
	gs02pjOlusMYOy3Z07HXJ97yNIcTNffSQHsUXYMa9XR6lHKXTo6lwUrIf7ZXivf0o1S0QkNVqmf
	04hG4j0PP1DTYH8KCZ92b5zgJEtzV+7nsHF6WywVQMQ
X-Received: by 2002:a05:620a:478a:b0:939:1459:efb2 with SMTP id af79cd13be357-9391459f1a8mr23802785a.24.1787856526365;
        Thu, 27 Aug 2026 11:48:46 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939137059f0sm26648485a.6.2026.08.27.11.48.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 11:48:45 -0700 (PDT)
Date: Thu, 27 Aug 2026 14:48:44 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, 
	jannh@google.com, ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, peterx@redhat.com, jgg@ziepe.ca, 
	sashiko-bot <sashiko-bot@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/mempolicy: use vm_normal_folio_pmd() in
 queue_folios_pmd()
Message-ID: <apCGce4hi_8gtyE2@gourry-fedora-PF4VCD3F>
References: <20260821144947.167382-1-gourry@gourry.net>
 <20260821144947.167382-2-gourry@gourry.net>
 <6d855beb-1d24-4a6e-ae62-ac9e05e358e5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d855beb-1d24-4a6e-ae62-ac9e05e358e5@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6C31518000A
X-Stat-Signature: cqribn1ce656kh8xqk3j43tqaxmrdguu
X-HE-Tag: 1787856527-510296
X-HE-Meta: U2FsdGVkX1+thGTf6MIRdMyqKOziN/3mxLDTZx/w3AZiMa/7xb4LOHY4DrhNuGY7l3II+v7BkcQI/X4pjp3j12ExQ/HX4DfbhveSIZ1dePCIp48UNQMd0M8+tJJXpqN83zWZL9EJ+Z733OPVPjs1Xne1B0nTBOfjF5xZVMb+nNL8dcSoQqcsTTFxxL/c4anVcHSMym3vx4YJCQx/BGDnO511eAgUaQ0AqIx+NNHQ9qXvEx5KoK69nl+NBkmHzkdesfU36nOV89vBPNqfnYJhs9sdmsxV+7ddd9sNf3z4q9xkiPBlFvMjVvhDVGWxK/+MTk4kquVrPZeCCybnDxDp5Iri8uWGgzw2DGN4DBICDF58LtNPTarSTJk52I+ftMgoxVwoQiToC0ZcUpB3f1nCGP53o5jYiLMUtrcksC5O65SCzuq1O3V3axGfYF8BgV94HL0NPryyETqeipM8RO2gaGnR3COZn0hUAxD3Uogh8EtS7IuzgFnp8LCOnyk68TuBeXb6B0xPSqnqgXCk/MKSJT0ZgshSmBG5nqMvxegOfadtHxZvBu+SdzY/qL3Wn1QLdI1wMz725cDHsX0nr2bakm5+2SniInKivS63EcXV2fVE7J6KBmjc95QH1LOP4kUyyHpxp0fCiVHC5COUa1C0+ha7/btUHPazxKhGtf60JgJSXdEj/Jv8vcw/QWb0M6ZsUgulrVtmElUh6fLO/hBYPY7bRbiy7AfvvPXb1ywXVVz/F67BRrD0RxlllPYdkGhl7hdzHEnyjt3eJt4rAAwVQaBeiPJzQVPKSdGFzdepHLqhmHnYf0kE1a2/S2XxgBmIpEBzHytYxwB8gek1rFttWBqZQY5RLIF88lD9/UXbQQ6JRDUvBldGlNpxJxiaXExsYWscZuJUrARs27WeOLfhtpqRJt4dRonsi6hL8ez39w2Re9o4UpTjcyA5wN9oGV8PYjHNTwTyONGvEyJtTWo
 CpzY0BAz
 fFGG/DXID0TETUy6na5kFBPtXdi1h9TiUsJvca94Q+UNJZ8erIRG/v5TnaJEQPENrGD5pXQ9ZVayxKKd5iOFm0mh5Bjz/GVjebXE19DLMgPKo8/jY0mgDIjx1tdMLrhPSKuj5BqPKsa16pz3/VB2UWLsUUjZMcQIH1fVifNz192mSwIteYgSpuMxntKwzLajH10n+tDz2vK6g5BYnpvAfWsFHD4vOPu7CQbO8rUoBBQtOEpzMAsvfGWvKMgtWNhuFVgrj06SrBkxHIdleFQT9qgbbFV5EbqwQXwHoJ4MJmCvwCMDkE8S+6LnRc1b7W7DhUxRCvyQN6LYorsvWOi838jqmiMJTA7/vXDQUZYKrzhJ1EkgXL5ZE3r+004LLciiqvRDfzTHJ8K3kAJTLrspBnjCH7MSPFdhSHNBYifa6dkQ4ydNo4D6Ehgojet8TUfgZLxQjanE264vqhWQL6TMAl/8NzSRAO3Kwcg7e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 07:05:21PM +0200, David Hildenbrand (Arm) wrote:
> >  	}
> > +	folio = vm_normal_folio_pmd(walk->vma, addr, pmdval);
> > +	if (!folio)
> > +		return
> 
> 
> I think this is best written as:
> 
> folio = vm_normal_folio_pmd(walk->vma, addr, pmdval);
> if (!folio) {
> 	if (is_huge_zero_pmd(pmdval)) {
> 		walk->action = ACTION_CONTINUE;
> 		return;
> 	}
> 	return;
> }
> That way we minimize checks on the expected path.
> 

Sure, i'll spin a v2

> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> 

Thanks!

~Gregory

