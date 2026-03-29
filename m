Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A7C0F3D5F5
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 07:51:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 120236B008C; Sun, 29 Mar 2026 03:51:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D1CC6B0095; Sun, 29 Mar 2026 03:51:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F29B46B0096; Sun, 29 Mar 2026 03:51:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E370A6B008C
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 03:51:12 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2B1C2160402
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 07:51:12 +0000 (UTC)
X-FDA: 84598329984.24.7E0E016
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6B3E514000A
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 07:51:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=n51kNbZj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774770670; a=rsa-sha256;
	cv=none;
	b=Ipw0sk3FMxpfYd8GVxJCdk9Dvr5WqQku6na7GrSat9FeBzcAQoOTEg4vWnNFaWikFwR8SI
	VBpWhpeeW/5qvGACHvDhvOKcyeEruZenAfIiYmPqdWx24C7EL3em2axycwx/nhfkyEE9Tx
	Hk/5birqFD84eXGDs8EiYao+CtGMh6Q=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=n51kNbZj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774770670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q/zNXWiIl+tZEAjY7M4NR9oxOyQa+xvxVl9yEshVfzs=;
	b=AZJNaRo8Sj0Tg9QciUlXFgT1tosJ5Hvy39syiJSzgbh8/ZjfEEVUDKoETzM3wGkt08Efwc
	MAyNvVBGCVkPTe2QO8F+gG+1hhpHcYY/RJcKrHMMqkvcj79BUReAPJnkFX8Wu+I3oO+m81
	pZKt4ctvxdIx3vF+rKqRMalDnz3tCus=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2b0ba3bfe16so27811975ad.1
        for <linux-mm@kvack.org>; Sun, 29 Mar 2026 00:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774770669; x=1775375469; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q/zNXWiIl+tZEAjY7M4NR9oxOyQa+xvxVl9yEshVfzs=;
        b=n51kNbZjXb3cBZK+Y+5oOZU58tW+J0Uzi1mK4Lj7Q8Bc3319rZGub193D/OU2HoXEk
         Pzu7csHWpzpy69d2pSxr7sPnVefFSm5/AExViZ0YleaHO+XPSQNFWDrSTRIArZ0hCpeS
         G3JcxrhrcLK8g1+z5zMHqDBp2O8Yi0OfMGL/UIvvCpegR/itLAcyjQxhfbI5za1L7Tk/
         tvEcP90XMge7Wmfa4EYFcvpQ163V7XfdfZf2loLhdrLKFWg/hgPv3HyXN7I8Z5yecP78
         g4SLWN6dPDkPbo9O0/9AZrZsE5UOXVynPZNsUs3ELHMmCBDVlOFZvpR0LgbJle+PPpMB
         vWVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774770669; x=1775375469;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q/zNXWiIl+tZEAjY7M4NR9oxOyQa+xvxVl9yEshVfzs=;
        b=FL+n+00nLlS9SbibKxsM4hI+243wCYbYlEem4//dFZAf3MjYTUWNn8t7IsM8st/qZr
         Saw4nW3iB02PmI1nDBdeD/SWlwgARGzQTNLXkP6TRa0ITjduW3OQyO6oQebhMXwQ0EVs
         o0VJad1EbweMdjlom6mAVoUQalV2K3/PF/F9yH3WAZ6AyW1rDoTGVGeHjnBo4qT/SqNo
         aJG/Om0PdIww1I/cag5sgzFciPowEUXSGTBMHCuTv+G8/+K43awKunBV/9AD1w/rx3fW
         UfdzAbjLLmjq2DDXrWlC9y1rx2TNExiJeBst3sLvVGpmJUfbP0FfJnUyxLeybm1mdcWy
         wmPg==
X-Forwarded-Encrypted: i=1; AJvYcCWkuUC8w09oWRHNvohBnAndIIR5lDPIiKCTGMvORpdVz2RYtiQ1CeHodovQ5Il3hQw3+ojdBoFvMA==@kvack.org
X-Gm-Message-State: AOJu0YyoXYo7d95V8mdGjxQeOml4TQ04Ln6OjlMHPcQvze40pbn17ymD
	V57xeWRh2vVtjHJtcOA1vbRkCNmPgRg8iDHivreZC/CN8qInWZody/sq
X-Gm-Gg: ATEYQzxlCLZ78WVAjk9LyAAb8LMgb+yadjBkMjPUBxrBaqalErmucAVGDS1WaW6rOxU
	WylOPpHJu/Dg9lkpkfsElL3o+G/CxJHWNYBZHEOdHv+H1QRWsMzB1GOA+sBNqEgalknv60KH90N
	2hNCuhXE+EdrNJogunCBoW4wV2pb1A8Kw3mvPAOT4yJp+qTGCGvQMobHw/JJYGocwYh27ZDW4wQ
	FZReavQNBBrQAoJQvJjv/Y4J7yDjh/bQ91Bnb3j8BmjhUHzD2WoGsATgREdt7DppJgX5GjkKse5
	ZQDCZ2+Uef+/EpV17TRKPBveie7nI8xRTfUD0LNG9ewXkb8PEPiRQgcTd53C84YDva3bmeSddtR
	5Zt9Dn8AXPZZ+/pLMLdK8EPuyk7ZeLABl0ONoq0m6j4h8tm+SwxlyROgUmwp2Pf1zaq8647G3H3
	gzGzVjNDSXnSir3E75Jz2rmt5TjggJLwkZplzaLX9KNvZ1HEW4kY4=
X-Received: by 2002:a17:902:f64e:b0:2b0:c2d9:2714 with SMTP id d9443c01a7336-2b0c481429emr111709335ad.4.1774770669117;
        Sun, 29 Mar 2026 00:51:09 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b242765bf4sm50821305ad.42.2026.03.29.00.51.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2026 00:51:08 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon: validate addr_unit to be power of 2
Date: Sun, 29 Mar 2026 15:51:07 +0800
Message-ID: <20260329075107.36402-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260329032054.2443-1-sj@kernel.org>
References: <20260329032054.2443-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6B3E514000A
X-Stat-Signature: d3n4acdz8394c58a65gujkhhffnrmgjx
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774770670-728696
X-HE-Meta: U2FsdGVkX1+iRs01OmwxLPoxjbK8lmuw8MbvlcZWOn7mCi9jcxbJWYZA8THGe0ZUEPFxawRiGZAO6xMlGGpZGmBpqRXfQUzdfWX6Enb34pcbnJk49leP69MpxjuelELPUoP8ahYB9mVzvm0Kd85k21y/jLysiaoTamd+47+3MWn6J/ZdtVfKPqWHsxrAHz3v7nY2+Y3kTIPj1gwqGo84Ffv9EJTn67GzRgWZBwoeIgQfpgvidJpRA+NFvMwoyFfTGuYbjf8QMi0VKM53J52h0kQxjzxi/5DKKa9myDT9/n/ZTXBMuxY7UglSG/u6lXw8TM2e+qpH/SddVVzO1F2cq3lOKgK1kGhZ7s4pBELMUIiGaVJB5YIculkgLzwiY2ITjS2R8sRM8807PC+yfzAP9O3f2irb/ArnBeExB5ZKdxEbyR3hp6PwgmOyOPzXtsmuokie34T6rmIwW1Bd5AOJt7Vtw08yz9xmIFWM+8NgLba1UA0EIHFT/K/NSKe8c0Ev21UtZgOvHHrJO7cuTLNUvO/N1BWEz/IuCvRgVfKuJu/5mnOsIF7WquPALlZr6B1/3PqZ6glUi7wxlmaC3pmHcPkmzNcxNyc19XgbIMalhkCIhrQ7t24MT33P1FWVsnMVnB4KzyIO2XvU46FE7gJyU7jBDbG3SsOGpfB5yvV0Cz6JiCfmSNvAy+v8KSwLGbEl4LZVobBVsEb1cM3U8Whf2DR17GWbYnTcUuGjxhYilXU3ALCvs9t7/s1z97H47+UQQbVuitR/QvSMKaPgiaB8e6AxEvtcXK6DJjruQgK9vHN2Ly1TXJ8dDdXAN6hhKP4v/CgF13UNPhGavXkrJ3L1MDj2o+Jme8FAdrSt+assspxbZpdsLER3y9ndLGqkdJblug2agODq+mO7CTZcyX7dXXXcCFSGZekrlvNI7MndpTON8BsCWJu7dqHqyrYSEa/vaHqSQoplivUlwsVx3zA
 n5ZipFk0
 jM8I69kq5W61e9W2AAp5N0UIEDPLK9PfgnCBl4MlxQ0zw59QzI6+8PALfNXHZKVUWj5bRautQF7fWXx0QyFUe5RSkSAM/fHcmqXHF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae,

On Sat, 28 Mar 2026 20:20:54 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Sun, 29 Mar 2026 02:43:19 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > Apologize if my previous email was unclear. Let me directly address your
> > two suggestion.
> > 
> > 1. DAMON_SYSFS Type [1]:
> >    I fully agree with this. Centralizing the validation in
> >    damon_commit_ctx() is the right approach to avoid "whack-a-mole"
> >    problem. This is exactly what I am proposing.
> 
> Thank you for clarifying this.  Thanks to that I can show where you are coming
> from.  You are misunderstanding what I'm suggesting.  I should have explained
> it in more detail.  With this option, I'm not suggesting to update
> damon_copmmit_ctx() but the callers, in a way similar to that for DAMON_SYSFS.
> 
> > 
> > 2. Adding a simple check on existing validation logic (in callers?) [2]:
> >    While this is simpler to implement, I prefer avoiding it for the
> >    "whack-a-mole".
> 
> I suggested option 1 as a way to avoid "whack-a-mole".  I didn't suggest
> updting damon_commit_ctx() as the way.
> 
> But, the given problem is clear and local.  Validation of addr_unit in
> DAMON_RECLAIM and DAMON_LRU_SORT.  There is no problem in DAMON_SYSFS.  So I'd
> prefer simpler appraoch on local callers that having problem.
> 
> In future, we can make centuralized appraoch, in a way somewhat similar to what
> DAMON_SYSFS is doing.  But that's somewhat we can think in future.  For a given
> problem, let's fix it first.
> 
> > 
> > So, to clarify, I choose your first option (centralized check), and I
> > believe my "Option 2" is the simple way to implement it.
> > 
> > Does ths align with your expectation? If so, I will proceed with this
> > approach.
> 
> So, no, I think we were misunderstanding each other, and I think I understand
> you more now, thanks to your clarification.  Also, please don't hesitate at
> asking more questions to me if any of my suggestion is unclear.
> 
> In short, for this given specific issue, I'd prefer the option 2.  Is this
> clear?

Thank you for the clarification! I may understand your point now.

So, you prefer to keep the fix local to the modules that have the issue
(addr_unit_store()), rather than changing the CORE damon_commit_ctx()?

To confirm, are you suggesting something like the first approach [1]?

    if (input_addr_unit < PAGE_SIZE && !is_power_of_2(input_addr_unit))
        return -EINVAL;

[1] https://lore.kernel.org/20260325071709.9699-1-aethernet65535@gmail.com

Best regards,
Rui Yan

