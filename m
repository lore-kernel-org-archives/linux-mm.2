Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60E37C88E41
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 02:00:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC8186B008C; Thu, 10 Sep 2026 22:00:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C780E6B0092; Thu, 10 Sep 2026 22:00:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8DD36B0093; Thu, 10 Sep 2026 22:00:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 812896B008C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:00:27 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D3C561C2145
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 02:00:26 +0000 (UTC)
X-FDA: 85199826852.13.E2A9575
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1464BA0006
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 02:00:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eSqo0eIx;
	spf=pass (imf15.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789092025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g2mR6Y35CkB0Sm25OWNIh+4C9SYin4d4S4zqnM9oCeA=;
	b=EID6ozGcv6d+Hgy0gGbSsm/tZVFyqbaAeVJc04X2BYgPtWiyrw08zvUPcHTOIUPx9CP9Dk
	yN+qplnnNJZPsQR5o1TXWIRs7zhVTdyDVJsqxX1fEmOKfDypscSm4h1cKnFJ4yWajBTeWJ
	5HhyqN4P9zHJ0IssZ49MeB3kxPOXja0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789092025;
	b=xa9lbsG5cRG6KYSIcKCqTec2x+QoO6OTfce5JZ275AO+XSROqw9nonLWmrw6Ru3eSCeRyE
	w/8QiOZLGGNtFN9YhzOR82aYOe1YmMZX/r09S5e8l8TXkw9mcDBPCXwZVEltVuxMpMKMdo
	mG5yf7VwZYX17O7T9rnGn5c6M4Sh9RY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eSqo0eIx;
	spf=pass (imf15.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2dd05e8b98cso3331025ad.3
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789092024; x=1789696824; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=g2mR6Y35CkB0Sm25OWNIh+4C9SYin4d4S4zqnM9oCeA=;
        b=eSqo0eIxVAs9MHAtq/118ePx3azHdz8+XFdrFHP7E1c5dcGuLL9KH74UI0YXupvIuU
         9B9g1NwrX9QW61Zkz2vr5s1h/07ap8SDQ+uwoCeTO7smZngI0xV5gCeXnQ5pFw/rynAb
         zT0vFAUpyfEi7qe0lwRpOwoiuLmSTs8aXwq4vBNflcFf+UB41xETIVccGmC7GHlPs/58
         pWCstAZO0jYEfouZgiT1krGW7pgJgiexm26HqGjyAX663bYwwogzGNQYi8f13KkK9AqP
         XlqFO50zx77deVBrZOH56/v7xgQJBS5uZdQtLRJPQCad3ns4QsRzBEUzczOhDKGNBrWN
         bq2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789092024; x=1789696824;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=g2mR6Y35CkB0Sm25OWNIh+4C9SYin4d4S4zqnM9oCeA=;
        b=ZRxhmUQbRkmrkUf7U2XyLQ2o2QGWF6az5oSEL453eHdspLGR5E3vw+yaAWSOcOuvXj
         wJ/OzSznKgMH8EOJhaSdqScbvrxh66QOgGw8LGRp2jS2MDgoBNvQTtCjR0zYtM6wBfhR
         BRG7Tvtf7/itMKoN5uc3ermN0Bl5JGTeEAO9qaIUQ/vnK6hGmUqNdqd/LWNVMeGpX8c5
         9VBUK7S/oKXHXzpe4T0dZjFQdiHC5v6mXgVMhQhrgU2wx3+tY1e7RPgXUn/tP52NiMXB
         Xwy0N93P2AaOsLInsZwUFxJLs8vkS5syX3sYdHLMwyMxiOahXQFMovBrlnN4msDt5Fxn
         DosQ==
X-Forwarded-Encrypted: i=1; AKwUvBxrvTKkovSseg1Z5iahB1oYeRYezG8sP+f0WiMKbbi9nqgJgtpI1fxorMV9Nr5g9w3tjMiceLifIA==@kvack.org
X-Gm-Message-State: AFuF++mEs8wQRVqKJOihMS7E8LKa+0FotDNVPudcSfGMDiYiz6HGx138
	PlohMUYtm6I0JGhHtuls2hI4oupsGzSJUoUexN16E4P4DLknVGQT0262
X-Gm-Gg: AYBFou2P6dldXOE7BIGctykqakOGkNNA+ZyNj1L9ZkToaub5wpdPY6WN5xAxX+8CzAd
	rNM89SY9T6nFmlSi6qh+9pg5RwI3ZySZccnl9Fiyk+yWWx1WdwqGEU1zkuDExB5HMbDrVuC4FTN
	LFJUEOSWtTQT79SglX11DNQ/RYlSzlvcBSeWio3TDVDMtM6vNDbLgZOJ5rWUHBlK9jIN0VYm7q2
	kNEYlfDuTHMya7y/g0SIKJIqoWIQKoDxc6zVIrxHXbmQqGdNkTLt61DSJ6t6c2dodz4D/WCw/Vq
	8bQ60OgH8/imCHGr4wz7saDzT87woB/hy6xAhktFna6wmoP069zg2lw11cFnYG6xIL/fNdQL/H8
	a9wtEUqjgsyRDZ45oyHD4tGHFbcbpNccK3wAAt8kRylZUb+3sR6vkMdV/Jf3oWOR0eozykn7c5w
	UDFJYRpsm7NeulXiizzb9ZCZiEg2MpJS39+Z9kNUe1bipLDyIu9Xra73sWWIK8yRKynUWFgEgGj
	NDb7XYlFSkOpBwMXCjSOh3wvomyzOT4ybDD/erX
X-Received: by 2002:a17:90b:384d:b0:398:c315:fa6f with SMTP id 98e67ed59e1d1-39d9c1db3c9mr2574336a91.14.1789092023699;
        Thu, 10 Sep 2026 19:00:23 -0700 (PDT)
Received: from localhost.localdomain (vmi2317697.contaboserver.net. [85.239.239.233])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d94bb0119sm2263927a91.2.2026.09.10.19.00.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 10 Sep 2026 19:00:23 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH REPOST 2/5] mm/damon/paddr: move probe filter handling to ops-common
Date: Fri, 11 Sep 2026 10:00:01 +0800
Message-ID: <20260911020009.37475-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909140408.104699-3-sj@kernel.org>
References: <20260909140408.104699-1-sj@kernel.org> <20260909140408.104699-3-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1464BA0006
X-Stat-Signature: i868id73r6o8xkz5wjqm6r5gscr1uc97
X-Rspam-User: 
X-HE-Tag: 1789092024-939722
X-HE-Meta: U2FsdGVkX1/+DKWTzi/+Ro5uvsg68fX74SAyGRlvChNeWpemEe25Op5g8g8hZmmHg4RDRIf9Eq22WZmHMKDgrEwPO4Aen9VV//IVtyGd/3E2XXi4/5QcC2tHXmNswtNlRzYGDWrQ1TYiRU6R7/MTgMvTvvyG0WHEzDvTSYBeNmgpNI4oLeUtNE9XaF3zX7gSWtWdrDLOhpp8yF/R+DR/AJvSkz7hfN4ABLr6HKj5DEk/vq78GeINjyvXcjozDFK4Ta+HwSOp3lyNCcUBTH5t6hIkw01d+DOsW8SWQgL4Le8H2aVOQbjYM4jPyXdRfEM7Nqs+f/GrFCxvM0fB7J5xm1YZdKBGIJzeym4yJ+I0yslD/ke+PbkGx6vZcl9OCYOg3oQbhYTbE+8fCJ6lgIyJuTINWluICmPPJ3zbhzyrxtRPDn3nJx+pa3R9sKyNueADRj4PM3460eq/1VkcXIZdGdtutnp3Rk/l/26y+547h+iCW7JB9ssQUV66v+kgp/08WG4BX34yVIIKUcLe5D7/GbhD1fCHV1+Lf3DHflm454g+oAhaHVsdi0jUyZrWXo53N0mOqJHq7lToTt6JZk/0KnS7gHPXfaVGD6CpCzDhft9xRFDRVpdUHi+/ujHOqpioHafc2qSsf599m5EKfY0uRts9U1gC4aDXnL65fdKF5VGPRYVFaplzUV7OPuMdgTvrZwl8B4djbxLNV3KwASh7tES/QncqZYIFkYs03hjmD7YlL5z9KBYCjZgxbpEZ9dwa3Ez/Qd5llEjGn48VPfimRThsuQZie/yTy8gHN/Gvcj1B+i0ozHCRDxzS65koKZmSbomh0hgjfPEdtVvHTQnOysXsdgpGbjNaPqfk0hlJzdt0+/XVBdlnZaHgRQMRtiLLnh0xj2sSG+BsL4Qfx+/lUQrQekBhZRmbQ0EShNldYhK/Weh77dFgFQkQfTr9dx0bY4xsNos/6aNrKttrQOr
 Z98egjhL
 hNcYSU3j6DWLNkZ7TNFaDSpI7qp7LqW4bgdMmnf2mqMofexPjszmfKMkuXO7jxQ4JFm3bgt4TGoG2Ob2iact4MPOymVP6X4/8QlXqMip47vDz9LLba/ASpXmoZlybfYqGWohSdD73m/4ZiJbt+JyatIbpwiHSl2MsbtZ9L2OQX7cyChUZlj4OChVZGkOS2KQ1eajzXsDelibV2iNF8y6gYRqzEuMPnIMW4bO2CEvdohADQm08kFT/DwrWlyJeDy6n//G35AizACYbr+02rjteDhM9uqHPcxYL1NyaukD6VEYRp116yZ1IcvJ70a6oF9RlSopgSimbdM9tCVdZXCu51uW+73sLLLEm/gQ+JSOLOLiumwesk3tRoyb7Emsg9bOctky++RYvouU9zQmtXXpcgklPbAUSKyHC66leoJo99YBAKRJ+FmcvrVHuh71pwqoOyhuS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 9 Sep 2026 07:04:04 -0700, SJ Park wrote:
> Probe filter matching logic for anon and memcg type filters in DAMON's
> physical address space operation set (paddr) can be reused by virtual
> address space operation set (vaddr) in future.  Prepare the future by
> moving the code to ops-common.c

Nice cleanup.  Moving the common anon and memcg matching to ops-common
preserves the existing paddr behavior and makes the logic reusable by
vaddr.

Reviewed-by: Lian Wang <lianux.mm@gmail.com>

Thanks,
Lian

