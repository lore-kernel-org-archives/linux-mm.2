Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26C3DD65C7B
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 17:30:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A9126B0005; Wed, 17 Dec 2025 12:30:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 356546B0089; Wed, 17 Dec 2025 12:30:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 259186B008A; Wed, 17 Dec 2025 12:30:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 10AAD6B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 12:30:41 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A9CBC8B9AE
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 17:30:40 +0000 (UTC)
X-FDA: 84229652640.07.FB6C4F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id D3E1D4000A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 17:30:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0045SR3T;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765992639; a=rsa-sha256;
	cv=none;
	b=Sl1NI01taCYOdWWXdqQOwX0qoJvs2tYR4GG+t0KkdmdRFpae3Z/JlB1gcLghh2AXthz91Y
	sLTg8cAUmK8S4e8sVhvHW/ItfG+72hm1xyMmDrzaFEFkQvcQkLIS4sGvJr7unSEvmAJbjj
	n5ipDILdoKb3Qa/fSzB+YiD4hJiA8Nk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0045SR3T;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765992639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2k7DFOseIPvyFXGWmA8GBbBvtGWKDIFFzcuqZETGrmo=;
	b=6h9VIDY4zXDFC2b5QM0SkTekogNDpHE+Gu+VJAD01fD4HKKRZxHiaD1w6pnzKcW+KqGCNE
	1Td3UZ11C7FpUhuDaEroFJxiposFzZH5NuDcClY5hygvxOF5U8ML+xw+muPcOiYITh0Jqq
	QfWYM+Wfz8HQydTFQfDSNLDw+gxVNPg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9CF9B4050A;
	Wed, 17 Dec 2025 17:30:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50630C4CEF5;
	Wed, 17 Dec 2025 17:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765992637;
	bh=YlRNNGNVHNq6DOUluWj1hnA+ZZEyhiWGq/CaxMEk610=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=0045SR3TksK3qNPi3s4Txo8Pzjte7WhkqVKUOZJwoc5dZWvT4qDHJLGxPsCTNH5j+
	 jhdk54E4FEzexSvU5618ltLvktkEzjZb2s2foMZXHDV7twyuatgyfxmihhrcTwP9Wp
	 Afu1qYGo0zz4sKF1Npa6Bc3f8rGN7S8Yzelj61HE=
Date: Wed, 17 Dec 2025 09:30:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, linux-kernel@vger.kernel.org,
 Ryan Roberts <ryan.roberts@arm.com>, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] powerpc/mm: export symbols for lazy_mmu_mode KUnit
 tests
Message-Id: <20251217093036.3231f9613ac8f9cf3943357f@linux-foundation.org>
In-Reply-To: <878qf1kqg3.ritesh.list@gmail.com>
References: <20251216201403.4647a4f9861d3122ee9e90d7@linux-foundation.org>
	<20251217163812.2633648-1-kevin.brodsky@arm.com>
	<878qf1kqg3.ritesh.list@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D3E1D4000A
X-Rspamd-Server: rspam04
X-Stat-Signature: nr437c665uqtxnd17wpw1rm8u911xywe
X-HE-Tag: 1765992638-407266
X-HE-Meta: U2FsdGVkX1/1MuNQJkIUP6ExxjqVId2l7mid6ulHsM/d2fW7GAV1KSQ1vj6l8SEyKc+8Bu25WThj78SH9oEl0n79LDY8WEXDiE5g+COK2S7PbmCSxhqh8knPMF+MeKFkh27RAi4Gctg2hIDk47/ELbYsDS1iYV0yzYF2GONQA9J0BEVpVYaTan4Uz17g2xttCa3vr2mkJWIvHqZ00YUIZM+uw6kZs7PBK+WMIY4VoOZiwbDGWHNepTAzr8JbGfH1lFfNqPAugSiF2dTqpuDAwW4WZoy5HPI4DCgeaS3kPCOV3SqahaVlIysMF1YI5p53waQ88vNhTc19lKv4qI2Za/ZCMKCrVHFatNEjObCVM3MZgt3zTIHe2SO4y7Mer3nYLGu1QXu57WxAwWBL4BHAZO8Sr2OFH5q4JF9mzF3FTIaGhdwk+VqQi+8QN4ii+9+Znp1LEFV4+raL8E0ALdD9wGH9MLOj8Y6Z3vHaxgiyPUyhARCQFwdeXWDQnm1J5y8J3ZrIjIHHCSkVlSDCl75vz3k8Nh5NJ7FrWnIc11tWzsGayItrbuibaKTKFIH2Bby65EGcig49arDvHRYL52LRR0xXIE12bn/4OgAEN0DPsL2wGEvDQlc1gtL698bzLi4oI0TMbTwx0fZEDDZEpXR5RK9w6gBJQGjV1B4Pk3cehA3k5gOPRCVh1ysvbFSAiaXp/g1nnnFKrGomMhLAytOz5O0pwY/YekHZ59RuLKHLvUEX/si5W9fQZxEbWCraJkGbrrsEJjvevGe66OOfoaky8bkyLKG516/IEe+cXMH636bTdAPffsL6KA0++f3hNG/GzAWQlAgmsBBUrzTSRj1rXtCvDgxzWZ9nvluH4KETLV4nY2T96SYFJzlSixz+cznC2pCdfWcUAd+TJxPl0lrsUzS7CqXlpwoEUeFzAmcP2fOgk10sVhMKbgGCjykFI4Uud3PxUyXbQtYTf2zjd25
 CMVofy/E
 b2133E+1X/80ET58B+fldcxQ4Igz4VyJR9WX5hS1EjVexEwCUbRedL7wChVU/ocPD8ZPHXTtC4jZEBxPylQJPbKuaqVG47pBt2+eBaRSLOwSL15d7qDbwu7tgpDZzQGvR+nnPeKV8ZJ7mKeiDwZLK9WIImRNcnU/zycuI2cArzfwcRgpqSGDJRhS65eB5qwkj5J8YDyPldU2gJlnXSjFxNZJoOskMrJoZPOoKr4VsO+2ganqby4GEy1sjHqr+Rh55wj7qTcCcvWEAijFaD4n12fwSJ3NxbQIfVQ4EXrRc5Q1DfbAoz7JsKtKZYNUZrIoW7I8tK/FXO/t+bJQaz12q+XdVuB4mo1wNksZuRZoDilsrO/bvKS7/O68Gwi1ZgChzNHGK3uq/kFfJHNCnJXA5Ub71bfFjvyR++fk9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 17 Dec 2025 22:15:16 +0530 Ritesh Harjani (IBM) <ritesh.list@gmail.com> wrote:

> ../arch/powerpc/mm/book3s64/hash_tlb.c:158:1: error: type defaults to ‘int’ in declaration of ‘EXPORT_SYMBOL_IF_KUNIT’ [-Werror=implicit-int]
> ../arch/powerpc/mm/book3s64/hash_tlb.c:158:1: error: parameter names (without types) in function declaration [-Werror]
>   AR      init/built-in.a
> cc1: all warnings being treated as errors
> make[6]: *** [../scripts/Makefile.build:287: arch/powerpc/mm/book3s64/hash_tlb.o] Error 1
> make[5]: *** [../scripts/Makefile.build:556: arch/powerpc/mm/book3s64] Error 2
> 
> 
> IMO, we will need the following header in hash_tlb.c
> 
> +#include <kunit/visibility.h>

Yeah, I already added Ritesh's patch which had this include, so I
think we're all good now.


