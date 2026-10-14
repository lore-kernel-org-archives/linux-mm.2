Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B58B9CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 16:35:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B148D6B0095; Wed, 14 Oct 2026 12:35:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC4DB6B0096; Wed, 14 Oct 2026 12:35:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B62C6B0098; Wed, 14 Oct 2026 12:35:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 784266B0095
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 12:35:35 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0049112062F
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 16:35:34 +0000 (UTC)
X-FDA: 85321782588.18.738693C
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2312F100003
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 16:35:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="fDlZsm/Z";
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791995733;
	b=xuGue5a5U0JVpl5yfVhr28jPrAnTQ4otAOZDhm4B7TlvP0btraTYoH6U6UjIBb/eyhE/Qs
	rUuaxTZjTx1LzS3ALgfo2HDnl2dkDHTGLtVAAvvgtX+9xhF595buhk2JFWQ5ljdXs0LIXR
	mssAwH7F6cAhV1YbXn4QVpNJXvSqwTI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="fDlZsm/Z";
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791995733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3LCiZCX1tQyW/7JZu4KAyjpWEpR2mOgBTcl8BdXvK6Q=;
	b=eNn07cJQKkgRnQLTcndQr0VbBBphHicDao38gMFM9Rtec6rwwc7JFuxDAuL0PA2CRWKFbs
	RtLgSrEiav+dtH4+Jx5lEVmFgyH2HIJjUCYGKIXZDkkDlGV6f1AYiIKHT09+0zER/a7f8M
	+a4qPeCNh4qJMHRSqfWB/rBGvA7rxU4=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-535d60d850cso11988151cf.0
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1791995732; x=1792600532; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3LCiZCX1tQyW/7JZu4KAyjpWEpR2mOgBTcl8BdXvK6Q=;
        b=fDlZsm/ZfKYjJkroDC+PcCWqqytBajSFnWUghsfQxj0GVEW7Llwa3eZxle2bApEvw7
         VS2KQhakC8L1p558DomJH6awqqff77t6FcU7qBc2KkBaNSOQ2b/0urbAOtLlLOWrZUS/
         2L+ggEEd+6U59JLm9Q2TMDLT1g+Ny4+dn52Wnkq6aJH59jJ7jeeDvxCqmxsl156XYJaO
         DPoYntDyH4tbE4/Jrasah5W/Ne9CTZPtyws7qHH4FuA2+kcQP871qbwBpw3M02y22LIe
         6XVo43/SdFXHZBNExhBhC19NP3hA7DODdaTQfSRHUxkg76ga9cJNW1pencGXlsty+kKs
         MwXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791995732; x=1792600532;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3LCiZCX1tQyW/7JZu4KAyjpWEpR2mOgBTcl8BdXvK6Q=;
        b=CTi72q/7B68XUPz+/U58+uQlWIRGnJML1ub+NqQdNN1ype6Ny5AaFlcizqpk330o18
         kzkR76MU4n2Cqp1d9Gkh1I4zxQBydGPs2iNEowNFly4xA3xiTFxLKfFlgRHOb3V8FX02
         bFdn6BVMgRQpUvyyFYevam+nlP/OPOtK95riWPgMzdOYEYcHuTlWEjGQT2hVgkdRShnt
         AktmYUbN1K0b7zAzTK6E9eF7azkI+CRL8X6+Cw2OxHFWbHmJAiThVbvdfQ+A3D39fUpR
         icb7n+L+s81hGbsxKNbDTTgFbIvB+ZiBKkHL1O/H47RgmtQql82eFVHiBASQhUbJmdrA
         TSZA==
X-Forwarded-Encrypted: i=1; AKwUvBxVyXDfc86A+gdsFwR/t98C0xtKLYnGaoxtk9jnG8WdkwONvzT11JuEiUVbsbYR6CzX+knO3ieoUg==@kvack.org
X-Gm-Message-State: AFq9FYLEvaziQuxQmLjUVmA6u7AS+fj8lLV2mq2sqt+XBCZ2tY6eWt/m
	K/UbSGUFslvUxFQ6az6qnrLZ0jIvJH1Fl1vps74E0Pr/xl8OqJ+BwpbaPxhQQASVKjU=
X-Gm-Gg: AYBFou0WYx4q1MxqGUO0YiNy23XdLwibOYb/opl/UMkCQDZkB41uCNY0+Q0Pfae8C8a
	1Tcc5DzL9mpM0XREh+zJpKqovbgE9gJssP4eHjop6BmWxGJS91tbbTMz/mkpKjxn54u6nTI8qc+
	JzITydVJ+teuOSe/7NbODoBshvCwY/yN1ZKRZNzX/yvSSZGjT96gpCwVfckYiibHBevC5wDD/sP
	+hrMML1zVprPLJYwIK4EbX3PhTMEE4p/UhLNJRz0pujLOWQzchTOVqU2kLQ62RYeBmQZwTrr7Vn
	hJUUAq9pXjBZehcNXFNRWx8s+y3lM40HKeXiXL4K7sNrLVQ7ppa7Lr07AeNa0kl7VqnzJcaQB3e
	kghj9b0qSGmNxuhdRZUhK20rcC4kJi4uKOCku22RvNa9//pCAuwwY/OC1+8Im5N0vqrZo7SJrhr
	b8K4GumlWluI/l2TVhbKlZnccSCP/pVgR/vD8i9M7d6UrDoo4bjKSqPozBBoPyFf1eBd3RRXzgM
	lRa+RFHhIA91nJMKc0l+wEv31jr+pD92uXnUU6+cKKCGh3v+jlRclg=
X-Received: by 2002:a05:622a:258a:b0:535:22c2:f161 with SMTP id d75a77b69052e-535a618a2camr237942081cf.21.1791995732352;
        Wed, 14 Oct 2026 09:35:32 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-536128418b2sm1108391cf.30.2026.10.14.09.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 09:35:31 -0700 (PDT)
Date: Wed, 14 Oct 2026 12:35:30 -0400
From: Gregory Price <gourry@gourry.net>
To: Pedro Falcato <pfalcato@suse.de>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Minchan Kim <minchan@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, stable@vger.kernel.org, 
	Samarth Narang <samarth.colleges@gmail.com>
Subject: Re: [PATCH] mm/madvise: atomically clear the young bit on THP
 MADV_COLD
Message-ID: <as-uTYp6--OM1CYr@gourry-fedora-PF4VCD3F>
References: <20261013191719.95502-1-pfalcato@suse.de>
 <as-dr-S6c3FALwQb@gremlin>
 <as-iHm9Y4wxRTG5d@pedro-suse.tail5790ac.ts.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <as-iHm9Y4wxRTG5d@pedro-suse.tail5790ac.ts.net>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2312F100003
X-Rspam-User: 
X-Stat-Signature: h5zfdy8fckspzuat55ygqkwkdrbqci5g
X-HE-Tag: 1791995733-198333
X-HE-Meta: U2FsdGVkX19oYJfPvzahwtu1VMD9j+sRjVO7clkt07iNfENHAcyrsAeMWtk7gfFUq0tRxU3x7VCi5Cb8NafyYPm0pDHpFeM30CMT1msNcySbOYP0SO1YPqK7FiQ1PS3lcUpw+ZzUcwTWsItFlTR/Vu5JthImUi+TlHFy2bPeOUkAZOrESLEphKl6QriVi93G8rDxRQ2Y8SaFFT2RHj4P7BI2KIHLEndrFkAgOZ1Xu7ZRv5TjxYAd1e7yXT/SzR9cJ9+f8DWPDgM/rBe41vSsawWv1HLeCfAUQpF2vCEVwOJzejOk3kVcUohtCvtm688Klb881zDdhkceJGEiO58R6FpJecF9UEmokHcrJK5QjI60KEYQVv2+u/lkLQjaxBZ+aah+on7MyM8V4LoYYcjf4wJXZlFul0xAQt1fePQXvQyAsh8obj/FPKjm7Bi00u/RRTrCnOdUpy3oNYgLxF0t9SDV7GZuLUIDJ+Jsh0mCZ9mf/wqb7F7xWJpTGCbC0SMyaXIilkffZFmh0E1iPfb3w2VQ5iFqAxM38ko4cOIdcWrrkYKUceBdeXCbkTyRFZi8NTxm+VfLJR9aF5OPhs7e9mKLDyGiVLTuFeqkDMAs+Bd5ImWw68DTeoTjZLl6IDCFsrETtmMfi2H3mtWklyXa6/kKY495c2sLsoMhFW62CswBTPbvmKHOhwBDo4oYu6UhDT1jU1jwez53i9q/l4onNYkIvaBlRlTNPCqcmFxpDav4RfFnETDArU2W1P/suE3t3ws3dyPxv/z/RaFoY3gG55WACZZuuFzBh3Mhr4SwdPj9RzhsAxO0CShyT0fWbb+LCIBgdD0MWnnX8K+gBsN0RzOkRbLQBtlPMfk6T3LaXxXG52uJEyv/DHKXUsLiMrS9A/6jPPtQf7poX9n3dUwMNF6je98Pj7a9vd3jN5wr9GNumYjAxsDnkyN6CZNk2yjjewK1fTsRvvlFPXQ0KGw
 EFVqb4tp
 tXGr7idkeGYbqQWQbk4wbaSLHM1AHDK1W8QKqvd11goyoexiBc2kFuLb/AXtEOUn5eU1S7mf+T35i60SEkbMF2eUgaiFPxS84rVqvwdEwd/2vuZ8/qfYZ1jlii1ceo8xsjkmgT10KRJPjrKE/ANB2dUNWTyfQYUy0IEeTXd1p4zRp/5f4Piv0CpGXe1CFHgh0rjALMW8ImPT7g77Ar8ytN7gU9oZOak8iTT2vZM4MZorZ+lE4eA3onEM1ISjZy0CVzXeAAPBf+P7jsTBZ/lMXR0nLTEWrS13ItkZk1bsqYdAaEDuKFSMQM4i23vwk/qIR2+O8cvW2arRWtiJbhS606UcszsGxr0MkQwKYeDKiNBJ/SIPSe5bVftn6r2KtidzZjYn/ehkL9X+MqlyNJ/HsjpwF41q/q3gCEMsYEqRCdH5SalZgC57YsiksGeSUcKyZiOIJz2LOvN5JsR4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 04:52:59PM +0100, Pedro Falcato wrote:
> On Wed, Oct 14, 2026 at 04:37:59PM +0100, Lorenzo Stoakes (ARM) wrote:
> > +cc Gregory
> > 
> > On Tue, Oct 13, 2026 at 08:17:19PM +0100, Pedro Falcato wrote:
> > > As-is, madvise_cold_or_pageout_pte_range() discards the hardware young
> > 
> > The function from hell... Gregory - PLEASE FIX THIS SOON :))
> 
> :))
>

Sending up selftests and reworks shortly.

