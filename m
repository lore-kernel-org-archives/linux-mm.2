Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B975FF8850
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 21:35:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 814B36B0005; Fri, 24 Apr 2026 17:35:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C5106B008A; Fri, 24 Apr 2026 17:35:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DAC06B008C; Fri, 24 Apr 2026 17:35:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E0326B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:35:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 01E581A012E
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 21:35:24 +0000 (UTC)
X-FDA: 84694755810.28.6FB0527
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf07.hostedemail.com (Postfix) with ESMTP id 31FB840005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 21:35:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=bzdlVBed;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777066523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rt3o1IfEBdIRMaZ2FTQd3jDL/mv0HSAF/yDpkwc3728=;
	b=L5gljdSR/5IJ5NT3rFNr0RrYIFPpGPl+W1ZYyuJ9ptNqb4n1RELbRV1xgsbTJ1e7fWDvpr
	nLw/lkV5DUG6b6/rc0loWtE3NIw9AheTddxwoGRHK9uFFmyE6vSVwB1GK2RdtkqGEDFCCo
	p9s5rzEcud1/U+85Z10N8Xk8kxH6GX0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=bzdlVBed;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777066523; a=rsa-sha256;
	cv=none;
	b=jx8SBRaREciZS02F6gHZe2Y0rEf7YwwTPKih3Ovools1RsjxvDMwARfOcQ3oAQtGIkxYGH
	I77ea8oh82beXiJP+BmX+ea3N7P+s3QCI9MVFQ8r8+MnrIafeXS0Jamx5t8BavEJo2NQKn
	vB/Gdr+0OuErJ5PWHrPu/SGdmTishM0=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8a58057d7baso98439396d6.1
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1777066522; x=1777671322; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Rt3o1IfEBdIRMaZ2FTQd3jDL/mv0HSAF/yDpkwc3728=;
        b=bzdlVBedqJ2k2Lrza3aUwcsRFme9t+dQmfd24V0Bk45cplzZGnazeWU6P2QhA9OgW6
         Cv+3l4DeBaI+LK1+RLHsp6xcvlf8g9sGsSmIGlzbptFC7ROwG+1A3w7JzPFU1pAtnDcj
         475wFgmcmAbRrp7VF5A0kR2hDDkHgbp0ih5lky5o9M7fm1KlsoYr+lHz7DDBaz5ZmhFf
         mLVvrSgCZjAQ0b+SSbRyFD5Q665nTXPs24AAd+06gb8fRwD8ou7q+DdORp5v9MGpaYAt
         O1PqfgnR1cWvzegAb+9JaXU3VTvPZ9WuzI5v4cL7wq4I8uCrx+gyTDett+VVzOu2ucQP
         wMJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777066522; x=1777671322;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rt3o1IfEBdIRMaZ2FTQd3jDL/mv0HSAF/yDpkwc3728=;
        b=qmbmDkv6sQrF+WnunH/p6ZmTSJHcvmKu3WVxpPnewHQx/xZnS53y/RfpXkaIliGAwg
         CeBXOSQd2duKpKyeAjb05hoUhx47U+gIR2nT0zbKYuV3TdhLMHjnjPne0MzX51dlMpuO
         Mhjr9Y0faugS/WYAkQL9P3P6kdBMIZOJ3Opt0323wZscqr/MWt6BM3DDBxfGd7NHjMmg
         t8/dsW+v+2nJt22oSiqt5jr7an5c6JovjeH2CnnErVvWsIxghsYo/tvFmzGcgTlqmiBy
         pcb7HJBUpRi1P0nd5eTJXwFRZRyJof7FYVzAI2xw0JMZt3efS9Qn5HsdWxJBcrtk9Nr8
         EGLA==
X-Forwarded-Encrypted: i=1; AFNElJ/7d221rnfnd4xA715nTpsbx2oDNEp+wGD0ma/w75v+YI8+LSwVRi2HNMG+TE5IhS18jt10r/jx/A==@kvack.org
X-Gm-Message-State: AOJu0YyQuC7cn9/TubQDanCezUo+j8Bz7hqlF2x4krPzGCQQuxsdIErP
	kwIAHMqn4zz5cALoM8jGaXm2MPhivcizx5/tJN4BO/W+ofvZqnsstT9UfbN5KUVwR7w=
X-Gm-Gg: AeBDievE+DEr8jN/3tbyV/k0ReavsxOWywN8/7G2s0GhoHXroDrVLDPMJpXr0RuAlJO
	mfCaFez7hauLp9SjlqBOgQsfX2djrqG2WCvXd0pHxjAkchmbs/EqcPle56rpJs017RahtxJwUY6
	6Q9L5+THA4f5qih1FhEk8f6WNlItiV1KP+0uSxwN9k34zG9W29jklZOREbxnjIFq4jFqSLt4LSw
	2nTSDKMlYY1mUgXlxiwEgpyCtRVifwp53RUTpbFdlfaAC2mo2+p6LgCghpMj8Tjp/p1HnZ9f07S
	ifDzRRWi1pNRNAB0iYy8x3Z4LJKMhx5KaeEnJVwJY1wZsCLXzEjdOMmvvqyuUUzBo0y6C5Btmq2
	AolYkcfDkyBVsveDyjC/PkpymqSNoluhmCzKRA+AZLleUgQqevhFkGv1s0jwt4bLnUK5H5BgTvA
	hzFfACGsDLCsGoI/QLBwDENvsaObrt9YPx2Zxf51a0ubAp0ySHktbb5mUe4Icr3w==
X-Received: by 2002:a05:6214:1d08:b0:8ac:74f5:fbaf with SMTP id 6a1803df08f44-8b028177e9fmr535664396d6.51.1777066522192;
        Fri, 24 Apr 2026 14:35:22 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b02ac72915sm199191356d6.15.2026.04.24.14.35.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 14:35:21 -0700 (PDT)
Date: Fri, 24 Apr 2026 21:35:20 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: David Stevens <stevensd@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Linus Walleij <linus.walleij@linaro.org>, 
	Will Deacon <willdeacon@google.com>, Quentin Perret <qperret@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
Message-ID: <aevhw9xqz1pWA2Ow@plex>
References: <20260424191456.2679717-1-stevensd@google.com>
 <da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com>
X-Stat-Signature: t6g7cc9yyihp888bcemksxmwy3aoxr9j
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 31FB840005
X-Rspam-User: 
X-HE-Tag: 1777066523-153230
X-HE-Meta: U2FsdGVkX1/wyNOzM1rbu6gbrOcFXT92fctDdeH9+aLBSBSRt5Q1Yr5rx1Wb4Ms82E9FW4HLI8lYNRkATILgTkVyNEpfixFxuu0ehVHxcsMCjOSCx1VLMp7862xjfWsbh8mwDf+gNnZ+ew651JPTf7Y+aX1Gh5r513t10PMjVZpm/ewacTTNE/qJMc+BLRtFtgMDFw/AtVpt1m/8g3qMseP4BlvfJ9W80HOEVfDxiMz7PBBPzBLFg/m60U0pbJTCv2e58pTtgkCLyS1t3eVZ8I4LyWK9bzww+EpwVvaC4oAIPPNHdnKqR6A5ssSmKuo+HHuQWspdhCSQJqmIK67MyvVfmK0mgDgpl0mp5AfuyDBdF+PFRWTN+KqXcVXI65pYZQCEVRDrH3mP0o75QAweXrlN0pvy/b7kcWg1L6YEESU/Fjm8APuEF7FhL8dRM96BgTWoFCGLUtDZ1155unjFlbb1NMWb1cLEmf9lR8VsuCFn55YHAa1crqnF/b3xQoslP8bCqA9vGMGTUwVx/WO6t7gcGWa2nolaZ5peDnw9nRKesSPhNF+nScxQQtumVpK2c6ofQTZMTHQYu3ueohl8rFF5DXmFSFq/yIrB+/1aTDUGVhtm4jEi7UzplHeahpDdpq9cN8L/c8v9fcvITTrlLuMPC9J8H8UdSXR4XCgLLVHeX8jvqODmgaLvfRu1ERDCVgSp/ZO5asHG9dQw9tjj2Po+BwsVL5nTsVVQIOt/lIKHOvTBBo4NVJYvIP/JCOX9oLtoRisPTXHd0m+wfbyDAT4lERzPUQPOxmmQ6NEiaslefr+gcnn5tfKqfGvA0u8wbwUoujiGOmIxCk/UDWNya0GxyZk+TF6FxMH3rMoRZfUJUEVvKiawjMiJ7ZWTVRyaT6TPDb9Y7z7A9rnLScb3+D/YP1SFVjGdXPyXTJSmvoTgG7rVY8nBhN0DZzLX36+CI4/hmVvLYlRGx1Kihpl
 6yNsRlDO
 mGKVpdr0lrUkd/HBIXgp+v260db5P2V/N/I5P4SskCyGNQqMRsBtx1dFGq/qoODVIMdZKRZnDIUbF7IbGOHnanSLxHyGLqMD7sdi9E5GE5Xq0EJ24mNnZuqiRcuMa5sO6jpaJSfTlHnNu8wyK8u3MRFLOcIWq8ZLvbIu5xLkCsqU44ynzGSZEYPdi4dm+ylfzOUqWrJYgfWYvTaAWAfxjgl+ChUWgulues+IaQQgQbUmrKPdjgpawH5tYFis0MV4siHpPkStYfGD6M2Lvrksj9nIMV/wCBYF7lv6ovyOf4bHp6AO0o6PrKY7CnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-24 12:41, Dave Hansen wrote:
> On 4/24/26 12:14, David Stevens wrote:
> > The question is then: is this approach something that is fundamentally
> > untenable in the kernel
> 
> Yes. Fundamentally untenable.
> 
> Not allowing stack faults has been a wonderful simplification. It's one
> of those things that just plain makes the kernel easier to maintain.
> Saving low single digits of system memory is not exactly making me eager
> to go back to the harder-to-maintain days.
> 
> I seriously doubt that this 1% is the lowest hanging fruit for memory
> bloat on these systems. ;)

This true until, in a fleet of millions of machines, you encounter a 
one-in-a-billion chance of a stack overflow. You are then forced to 
double the statically allocated kernel stacks on every machine, paying a 
memory tax even though 99.999..% of threads never exceed 4K. This 
overhead accumulates to petabytes of wasted capacity.

Pasha

