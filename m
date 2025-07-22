Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66C24C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 19:39:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 030F88E0002; Tue, 22 Jul 2025 15:39:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 008AE8E0001; Tue, 22 Jul 2025 15:39:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E62038E0002; Tue, 22 Jul 2025 15:39:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D5CE58E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:39:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 50F7C1403F9
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 19:39:46 +0000 (UTC)
X-FDA: 83692915572.04.768CD44
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4A05920008
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 19:39:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DT6Grg7B;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753213184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oWwanWZIN6VJqRUWaw2x8mt5qLkeBEti+V7m7T7sRfo=;
	b=skVjwpqKJLAvHeVCJ5sSXD2RN2adkMfgnTMlXu4MwmfswP6J5csDX950ELzCakY5fxJ8It
	p0eidmBLrxJb7Ni0fFwK3dKk4deT8Hl+1R/8dXzs6S+raUGr5lu7QlZT0DSkqSYKxRgWNG
	Q0XHN+leDjW8/IIW/p6eBy7gMojnILo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753213184; a=rsa-sha256;
	cv=none;
	b=s5jIWIxMwdsMBBQJi4icNF/jtJ6nJKUxHxiCDNA9u7a+LrMhhf7gvkx8AzVAP9ezZoJf3H
	PtNAEmQOpMzD7s5DNMPFrrjF38as1gY24BRAinRm1Zom5wOrjIc0pg3kMDtfIVFPLutKnK
	MvBYjCNXRFmM01zpCXpXbOdB667/S+Q=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DT6Grg7B;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=urezki@gmail.com
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-55622414cf4so5145469e87.3
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 12:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753213182; x=1753817982; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oWwanWZIN6VJqRUWaw2x8mt5qLkeBEti+V7m7T7sRfo=;
        b=DT6Grg7B2yxNuKGHhAk0kO2o95vVq5m4LECT6ysKsVWwhJdxhQFxJOVhQ6qXJyBy4i
         DbMnO568E34Gu8+V9RJDiRWDdtu3AQ75yOv/cw/teHbfyOJO3O3oZj8hub+e1zO0ePRP
         WqAVhk/JMR1yabaM0wVUF3giP851Xn3uq/RhP+3RPeSEqQ4oUYNvIclKZ77MaxS1aweA
         JEgMGuCHmIOyD1zuc3Ow/nvBVVPuNf/dbr+fcpdqogE5cs6yjeplMqSQMlhBfjpgP0qe
         dlZSrDNt9zst7cUg5nFGaVi1YHqMpksYuONYM9X0SPjTbkSx+ymEPfoj7qLCKdWY/mrC
         dpIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753213182; x=1753817982;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oWwanWZIN6VJqRUWaw2x8mt5qLkeBEti+V7m7T7sRfo=;
        b=TTuaGhbkvUmt/z2rlZp3vg3jyRuflgLvnHVC0nOnyl5aR9BNAMRQBgutKyWi6QtiG9
         SqrGZUXrixEhCtS/pf5pkDXNE5+pNAHH0KQ2OC2EBbFDxzNZ1zflvEwBejMgcc2oWawC
         jHZdVilMl88WJN6ofTFyQIQLwrTnC5Ugqm6Js0i0qj53x0o+UnJl7vCmgjjCv68DVXLI
         mxrQFhH4Xacqy2MRmtpc4HPw6s2Vuo9gsK37CcMAu0Yj8GvEoaQAftTS2OhSuMb21jv5
         x2tauYbetrJ9NSuMwp/7p9Fvdwq5tjgzuIjc42wXusaK/tIiN/YFTyRyVAFLLftZQx69
         4ZsQ==
X-Forwarded-Encrypted: i=1; AJvYcCURoK84/vbocUOO1BPwB8potz5Ugw+xm3+J+Vnxq0rLYYPiE/SFYKWpzGZZeJEH3dFsoibI5yS8IQ==@kvack.org
X-Gm-Message-State: AOJu0YyLFooTjhJ0zIU0wxYg7rZ/nvn0VS4uz6FHbolEWMGLMknHRIRh
	IwYnLKLZdupEgde9CjlDFEhYzeS9IRdfANzWjpjzc3r0UUFEgn9BqezK
X-Gm-Gg: ASbGncsSB02vRm4DJkZav0ShcZ3xr91DOwzew9EK8RMlGJM8pE3AeLOqlFA0WbSAcjw
	cETZOMfCjMeCR6HACujhVi/X4l8Fqvx3t9aJD4OQcKE29ZuFz93ogd8Q7MaqOwlIi1GS76VNrU4
	sXe3fMjdrl5c2km2ur8UcMs9FGkJSBs1pkpQsF4hWAdNhtXWEV7SBW4o4rLX1qRaVS3t8gv72po
	Xfjvh2ExQ6jSNmSJjuFq7R0wf/DWgDfudqI0Wehcqo6D8XMGY3tZvX1rC18Y8z2bKaImLxs7no0
	5kfEnkhFpbhyIVuHRUJpWdzfTzqyUgr65lm9gq6avvnFFLPhN8ZHrouHcucD59Yg
X-Google-Smtp-Source: AGHT+IFbHt2xpyOsVVT8UPF6x/qDC9IiOeFqzRPNDED4QfUqrtireW40AQuhtFawGjwFKenKZbGixg==
X-Received: by 2002:a05:6512:3daa:b0:553:2f50:5dff with SMTP id 2adb3069b0e04-55a5136aab3mr87983e87.17.1753213182060;
        Tue, 22 Jul 2025 12:39:42 -0700 (PDT)
Received: from pc636 ([2001:9b1:d5a0:a500::800])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55a4eb36cf9sm139815e87.222.2025.07.22.12.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jul 2025 12:39:41 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Tue, 22 Jul 2025 21:39:39 +0200
To: Jia He <justin.he@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Peter Xu <peterx@redhat.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm: vmalloc: use VMALLOC_EARLY_START boundary for early
 vmap area
Message-ID: <aH_o-85T-EexGWrg@pc636>
References: <20250722040850.2017769-1-justin.he@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250722040850.2017769-1-justin.he@arm.com>
X-Stat-Signature: q7mi6y5fsrabpk5q85nk87idcy1znsj4
X-Rspamd-Queue-Id: 4A05920008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753213184-602077
X-HE-Meta: U2FsdGVkX19AMSCZKwXKrnBy4C/1L8mBtswzMu6pP5m/Mx9qJ/tBac5Oi7AXESrgDwWnzLaSLHsbEYzNEsWwK28kcTdLEl8xiuCY3hbhxcF+PhdKDLzNA+AsIY7Su5TGUWt8lcKK68NbJQkBMufJZJSIe+foz48hYNY2Nocx139GTgN3zlVYJGRftkrKgBdVZ9Vd4wMxkgWizPg34ZulLZXtzhT5RFF8sl5GqMPSj6qkLP1lZZQ43tzGs01SfpIoKQYOqsED34NaarWhSQefMvjm+aHpSp+0ODjTKvJ1Ag6EY+ZqjphWZWdMHIDBiSnlVqQLPEltux0YvEhAi4BuP1jyXSlm5Kp+NQNtysraC/PB00JAe4dmmu/Rgax7oRxQs+88qGn+ILVZaRORU+5VwallAYU60J+MYGZtTmjTn7XH3T9YoWXmxUIBPUWbfjN7aGszTxChOPsg9ypSwZgPwsyJKK7qluQmTh1Y2z38HyvHyG+1QMR8OJ4VgMwXRdB+t8Hd+h1pSh1KzE+nGm8JW8VWkT+vo2p8T/EIKc3ui31rQnxyJSZh2qxJF2z3xDhlo/BSAPGuocI3WSbCtL97O4ES9Y23Z/QDnbN1CVGVy/2Nf6Zdx9B5J11Df5DhWbe5zJz7KEMh2gnHojmitzyDTw1lOZty+/WS4J4SrtmzYWzqrRyB3z1rCfm8zD4WVC8hUyqDWuiyzrZzXip2M5iwaTGnJA4h0rd3S1JuLJj3EdV7TWu//KE4v9QWjA85UOK4EqWOlPM/BxD7UbfKzaWHCH389DnnXTVD6lVjwk15QyqgHxa+KKVe59YL00YeAYs64r8PGFPOEerG3UOpSqyT9siUmnJp3L3IcIxYz71yL08HsGsw8b5+LsNxMId92DQ7q0V8LzuH6Pd4j0xcJp3sFBoOVzZWaF6yoj6m7Dz49+KTfk4xgESo66XN8SLgptFrvdkXlUSLLYQ6HYnKo28
 RcYe08Gf
 J7Gkl6om6VkRLBWJE/GQPaCkew9Dr/ePv+9mUj6MBe8XlwxsQVZ09A2XjzWm9PhTRN7u3W+H1jONvpKiwdwp7/6JGjg95P3Z3EWKacpiJ284uCG+/C4KC2Ydrdr69rh/KOv+WFnlKoeNAxKCAmxbd+/Gf0QdGg1Zxr54bgr56F3gAqCTMbM5QPwWTbU+VB75fYrLSWrzi+ma0Ola4T5uZVPbwlS0emb+erCQVjs/pWn7EnuWsNuXMeVt80evgvooLK+mJ1WfHLsU3JRA5WNxNeWQHVWkiJMCZmcK8i2fHaV0O1le3803a568P0CDafxtf/dWp3DJa8jbFv1+nirdZpvi2ok4mtbQfl1tvo6VIttgBs+VLvwRj/PoxHm1Rk/MjnhTPeJQbPjZaxVuAPYB5+hitjqE9QuRXpaKtY+TDTea5SGwf1b0Akz0PGW68w+xUtQm3pWCYCfGnY2U8GM3V23CF4Qhk2DnxVhHjwanVvf/suAps2Mh9cyyA119KQycsoI/UR9mfF+CqWXQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 04:08:50AM +0000, Jia He wrote:
> When VMALLOC_START is redefined to a new boundary, most subsystems
> continue to function correctly. However, vm_area_register_early()
> assumes the use of the global _vmlist_ structure before vmalloc_init()
> is invoked. This assumption can lead to issues during early boot.
> 
But we just should not redefine the macro. If there are such places
those are should be fixed, IMO.

--
Uladzislau Rezki

