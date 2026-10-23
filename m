Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19DDF606A322
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 19:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=XpAYvsaP
Received: by kanga.kvack.org (Postfix)
	id 2A29B6B0BD9; Fri, 23 Oct 2026 15:33:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27A196B0BDA; Fri, 23 Oct 2026 15:33:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18FB86B0BDB; Fri, 23 Oct 2026 15:33:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED94F6B0BD9
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 15:33:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7704A1C25E4
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:33:08 +0000 (UTC)
X-FDA: 85354889256.27.9E72450
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6C24020002
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:33:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=XpAYvsaP;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792783986;
	b=Wu23HLbFBN+SrPFjdxVwqzrIC/xQNTNVcJ9xn32YZTEUaSXvR9vo1dsDo2SNcaF8SOyUBi
	FizCO+ACIXXk2QSwj/mOVt5EVPx2Mf5ifLFN7FTi2+lfHBMImIKh2+IfBV99gcTlx2RvYU
	qKoDgF5h3t9VxjXEhScotJowejwhNbI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=XpAYvsaP;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792783986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ra4PwUN4j1XDh0rJxY9+VVsmhyDYrSXY972fJf+hOU=;
	b=LnEl0a/7w2t+gLEvm0okHsSfkbENpy/NTWSMXb6FTgF8ACs5bArYKBKAao4Fb0oshMksrN
	FizDxobrFq7fTS+BQsNYuKjDHETDMzmy954fa+u924xuZoETdugNsDY5BJJ1aQBKWhzqt3
	SYtnxMiM+DGb7QCFPYAARvta2oQo3EU=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-533797e72e8so8144281cf.2
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 12:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792783985; x=1793388785; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=0ra4PwUN4j1XDh0rJxY9+VVsmhyDYrSXY972fJf+hOU=;
        b=XpAYvsaPhYr1tAlVH7yXx4wWtu6w2wMrr1QO2km1Y+lqgDDQlNEVIp2FwYAXFcRJ/S
         4enbkR1VCYQjQJbEEpTsdVnrQhKdn1zfgbhttSxDit5BmSNiMk7kneU9MsjM1mRKpNSL
         LlUP4KMLjZPS7gweTSmd3HUUDcwtYWuyN5pYsx4Ua+G4t2EFe0rpXY9DqRYw90hYdMS4
         ke53BEQ4B5Mw32VBNHtQC3byI6N0uqJxCLlWlYQp4g78jurtnMREV/wMWTXQveXsGMlL
         ZuS8OuwjZzxBc7jHPi1hhnoLOdKwVzZLm9NMgcSPYaxHnkskaJlWF2O5pB0lEoSF9Qez
         orCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792783985; x=1793388785;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0ra4PwUN4j1XDh0rJxY9+VVsmhyDYrSXY972fJf+hOU=;
        b=tMl98wIzoOzRkxDZyxc8DvujEQrsN6vkM9Q9hl0sdKLsOIevJqNi39UPcuj9/jld3k
         /a9x+NYpmnpHxuBz1wqh/vOeBBPbiPgMBA4G+Zxv+bQ0spkGyNF4x9GRFldltr8VSwu3
         ar/Iw+A93KQcQbXoLauYqPyJjYHkhZUpzwzB6xGR9r+q7D0SU65Dv1jxGL35j098JdKf
         uavkyB7SrPyMa8I5ZCFHHsqBFgZ5N8GQgkuDN9ByIQamqbffDRdpBjcr5sSHiZxSqYVG
         l2jM7RUYcHcG5bxIYyeH0yUVlpHA2yoLNh/4GstCOL+beEOx82ALkIj2I+BlGTNJJMf7
         WDTg==
X-Forwarded-Encrypted: i=1; AKwUvByn2XJja03xDaxGufwSewfQ7T7EUWe/Cr6a6M0/kBy+FyqCAS+vYdECB2nfeipcmA5midIaAqncLg==@kvack.org
X-Gm-Message-State: AFq9FYIfcbrVO1YwhPVVvK1/EcRwdLhQdG7L2YwGo9cfLYOJB+q5RA95
	2QRCA8XEPJrnLhkyGyXWGkjsLgcJPvdyJbtRDxCwTN7AiCxBnnPRcphluoIYkxfHCB8=
X-Gm-Gg: AYBFou0WTybD7MraIUXf/bHOyw+QKOwyHwQf22Y+z163Tyc5Ftzmalk9Zofdtnge7KQ
	MhSy6+3qzutlFliCtPtI4uMNaHZJS0oalr57l3wXkVjFmdo/EQE+aj1QvGjxGQgPPkgHGy43m8M
	GmkXnL0HUKxnl2BNhfKM+VbEBqbr0RReEoYqSgSvtlIQMccWaPrI3FOZ2RvfFoH0gNWetNwcxLt
	9pl5xee9C93NcYwedRmjhGn2LlD3emBgkfhq2gHxXVLm7HzmfJyHqkBeR2P95M2m6Ne1x+uA4iq
	XXAtDVVbwK/BhvFg8HdRFk1nczz4+g7em+RK8yVxsHv6Z/YDisu76g/AoV2pUGUiedmYuyCIIXP
	qATw48ew80Xn3jDnledMGPWUry8Au4PfzNFwckQ3shi0WqzytsqGFs5O0sI3ApSwKqdhsybh/Q7
	gZVa9nOCu39LndRXSZJb2ulKP96nCKod8KKzFoz9+MBzHwtEiUZ86kehwHjERkZbBO2VeHdAoMe
	pavojwqgIChwQ4U5t9nSQynzaSRtsVh0HuXoQFkwtUbBkPDhHpXrlqNcLokdwSdmph1Y8nnkpb9
	NSbJny0Mmaae4x4yhuZ1mHhaJP4=
X-Received: by 2002:a05:622a:5b97:b0:532:f0a2:ef4 with SMTP id d75a77b69052e-536c25f7a86mr44477151cf.26.1792783985368;
        Fri, 23 Oct 2026 12:33:05 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-538394c38easm1748051cf.7.2026.10.23.12.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 12:33:04 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mm/mempolicy: remove unused mpol_is_preferred_many()
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Gregory Price <gourry@gourry.net>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>
In-Reply-To: <20261023161003.59086-1-ekffu200098@gmail.com>
References: <20261023161003.59086-1-ekffu200098@gmail.com>
Date: Fri, 23 Oct 2026 15:33:03 -0400
Message-Id: <179278398385.3414657.5670535479884226120.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Queue-Id: 6C24020002
X-Stat-Signature: wioe8mfyq3wdi7j8jzj9q1ppjf7h6gd8
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792783986-151755
X-HE-Meta: U2FsdGVkX1/zAACtWP28krPvS49K5YCa6fubn1w5AUh3MO/oHFiR0pS3BCFJtCKFYqyZi3MA3MRekk123M6ZpN9Su7m1dM+xQ9sfyn6I7Yz1E//PPxl/phUw4pvi0Y84emjKOmwvPPaGh1cvAQcKUcKd5pxcYaPdFvkA9cLKMCw0zOM3zIhaUuDSBss6bcvPQTzIZbE7ixKtcIrwAGDiV2jPEwlgkbTZmnNt+RSMT0kZAMAr98hVfLKGgKGG5FQ0zyrzY3drXf927Zcicu9MnWXO+H59BYGqa6SumO4JJAYcLQzOFxmQBfH5K45qJy70bPZvIuACOkBSTaznqMtmCBaAAAP7XzzKpPey9TneT9j0DUwaej6jYmGTSIcF4XBd4o2sVGsoIszRQo6CWDoP2cq3igvEpTHDNEPden875airg+K5012GTOXC3mCwg+8BGpBPU5AxDkFs8yKT4mTrVEVIcDaoAQdo3MT8QcH48NOtfHwA7WnvyyoyHoKORFegQyzh9VoF1s3ANsnT7v1EC2phz7sxkr3n8KQJj56EBnu7D30+4MqHfKaTV7k9kxrW6w6aJdneuFiahT2aO4pif6yoQlFVSCjz5VFxB+Npi9IWa6G4vdLrcERQbQf4cFQjq9EzPQ5irgeNIcKyiwYpIpCkcGxMIrKgaIFp2TMQuigEkDe7vRMooPu7rjq0WCVXXCbssZTgx1kgxvOEU2wxRFZaxirq+SkxUdT+Loks4LUzu+zUJEpe2+4Ihl5jNEToCA/9CBxTzN0A3ghbkJJCMlabD+cP4kyTS+HxegUamgFO2IzDagMnHsvs+wAQaCc3iIwXXw4m896ARBhmdfGssPK1+UoSkDMj8qjGSCRj6a1PdZ07XDYNcAGLrGgabdn9DalxjY12FHHFIlxHtJ5cMGG2Vr8SSy84G2QHPK+oT+8DpBGxPqECfDTJJuxomQP3Dx0V61lpCK6mYcc4s1i
 dWDpl/b2
 mm0Ml0WdSBy1B5chpwCRhwN/j4bpsRZcYTscDAPG7F5w7sIAkPSKpyaTET0s5up6vnv8Qn2UMXcfBGamax88pqVwA4udC5/lk1veLOU2E7gs+r6llaNi6SyUu54rNLJMx8/5pLV+92R/yzFiaCiu2Ht3Lp9eWfnqOuBOgSwI78zNrlDbzyXMX8NRTC/htO2FQ2wRnrCUkPG4uCUqloo2g/Xecrj+x3b8ukcG8mKSjcRuGmFeFMPjCibbg6p7jB//VEdSixYqTkKjwp2rAzd8v0CchUXUl3HwiT3uj551OA/IJQrVyyeE4IQndWbJHEGwktfDQ3S+hVfWQ9XCol+qzl2mDGILucpvOuia76IesrEWLB9p1wq84J/QQsRRQhDvFMJs/41BuMI3rOvJPKYI2y+xGpmda1f0HCMyesH9nTgrX+//a/QI3Z+ESSEGtXPhcE/kCtnFEr2/6jRc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-24 01:10 +0900, Sang-Heon Jeon wrote:
> Since commit a492abe28bec ("mm: hugetlb: move mpol interpretation out of
> dequeue_hugetlb_folio_vma()"), mpol_is_preferred_many() has no callers.
> 
> So remove it.
> 
> No functional change.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

looks good to me

Acked-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


