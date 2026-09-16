Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D2C6C982C3
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 14:52:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C0E96B0095; Wed, 16 Sep 2026 10:52:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64A926B0099; Wed, 16 Sep 2026 10:52:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 539986B009B; Wed, 16 Sep 2026 10:52:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 33DD16B0095
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:52:36 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C191A160693
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:52:35 +0000 (UTC)
X-FDA: 85219916670.06.1D4CA48
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id B247FA000A
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:52:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n5+lHe5C;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789570353;
	b=tW12AbUSA+N6pNQGvKYg1we/nGy1inxOcMsrmyyWPyi4w3jgisgQpPd0Yjd0Yl5t33mYN8
	VcUTpvlnoHGjGjtoiayRPeCs9f/B49Dht7VAYEzCY2GBHdT/8HAppEalWcAOIubH4hxRfx
	sWFXD8ImINNb/oktW1HYHbwsHYXrc9w=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n5+lHe5C;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789570353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TkGGqC3RMjVvrwfy5PwG4mz/vkltLL19QkUFctkO/vw=;
	b=B4l0/lyVoXvw/UjPTIVI42LjjEIrKz+f0uKgGMWBFkpB7YRcLLXxcxlwU6vqOFzQApku/0
	/Zrlgp9By+6V9eY2noika3fv/GqpdjzehQ77zbZptKSRWmmYrtmgAJu1PGyQTcG+9dV9/0
	V3XcwhbaYhgNZXaWBYbKauJxSUOoBjk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0E8FF40F07;
	Wed, 16 Sep 2026 14:52:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45DC81F000FF;
	Wed, 16 Sep 2026 14:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789570352;
	bh=TkGGqC3RMjVvrwfy5PwG4mz/vkltLL19QkUFctkO/vw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=n5+lHe5CWEWL2KtQmFkFB55b5iXu4N9Vek0dyGZX1/3zO3ka8nm6/J9Ov3Uj+Twdj
	 oZldKiVpGMPSt7OcgjlmFSWnMS/exKe6A2pnW9s1kh5304G4Lx0wP1JhVWJlv0A1pJ
	 iFShXHn3WBtgXYPWGZ539lIZ9fl6yZvh5/dprhSO7jjKRNI8hSfJo0uZT/O8N8rdR+
	 v8/wkxAhlUAABocYQX2cNdmIDYSMZvBLU8kbehw2VwMGkg2pCL/gj5ll41fUIPPhxA
	 YSTkOrIzqmrECES5q8nUpza3n6FL8lUJhmcUvDHJGiPm3SGSKJf5hVjqr0mGH3r07p
	 vz9mwlnt3vLDQ==
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfauth.ams.internal (Postfix) with ESMTP id 2F234198003A;
	Wed, 16 Sep 2026 10:52:25 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Wed, 16 Sep 2026 10:52:30 -0400
X-ME-Sender: <xms:KK2qaoHqtAINeNtGRzs1bE4Or1Idw98GmCNo7yvp41p8sHitUvCovg>
    <xme:KK2qajpVBmvzQkmEYsGWHVTg8yM_vmXkodksSZldIgXfwWRjUSgHH3LWiXwuoFgpv
    bcL-CF7740d_Z8JNlZts4mMMbGlmAZ0_nUO64i2DP3V5-bQ6xJ61kibPw>
X-ME-Received: <xmr:KK2qag6NZ0z5r-gHaF-grFcuWVlB11opbmTnXReLIiT7MVmlhJLugr7FVYU>
X-ME-Proxy-Cause: dmFkZTFzC/SjMeXXYY7YnWd3sVIZz68pRPeSBwlUQuzQ26K4k+iWC1VyTPjTOqnFxtjXHM
    W+YMnfQ6l3qQK5dykE8MoWFvEFfnx5MIry9NjqzHKL2Ec5pJpS9Q7SksQNlgzvfkwIKbVF
    oW082Dc2+YFWvz85JNW7R14spIgFcnNMSYHY2HFrVIrBU4VXhIPN94DOg1fkGdV/6cpPI+
    0IXahSkrs6gw44MEjwRtsMCkDTWG+VJhTHbz2pkYOSy2rISqm8afDQp+IA0s98PUVOUPPX
    eaRTiqmCx/zCy6Mw3tqLGr05WwD78p33GgJa84mbueHlZb9u5obu9GWKZTmbsmdQW8CugE
    /606BWJpaqYpYVdKXebre5PN3BaydsB1N6Nzp8zQ8MGhLHrejFhhX9dMqLWNsmRuaUqJae
    XfrmXUu/Cud+YTFoRhxcEho8ftXAl87qUivoOg1HQx/oGfqycEVMCdUSUi92hGuLnypDj7
    LhbZS1kYAxEKHQOHdzmgvUMbMZK6naSOpJHoI0kHcdXOIk6ZlynEG2hmqhAtnIHhW68lnY
    7YewUskzTjR/ngkqwNIdRuHY0eLneIWm53ya0cn73ls6UWyRp96a3bYZAu7akT0KZ0bbjC
    j67aoGD5Aj2Gy2/JB6+fG5MCjofwib3Bupn67WA9x6D0303UOFDeOxMNyLNA
X-ME-Proxy: <xmx:KK2qakQPScdB7OJALGudxXnH-3-BbzUl1YXCMJyU6EEInS2pQ2s-VQ>
    <xmx:KK2qag7TDVEdRyDMWRjoqZkl5P2gU85hqDlXjFHdJI5sA_dfeAN9jw>
    <xmx:KK2qam2D551vsUIl4CMorYd6gC2AYPELFyRQQ-TLIj5Vtyi9h_b9Xg>
    <xmx:KK2qann2JoRQaIxtNsPm0grXVthoz223TdcDfMcqvc4pvr4B0tnQpQ>
    <xmx:KK2qalkdTbUAKqx4tr0L4tfabsAqurcYNp45tH53pVGWD6p9sytvv02h>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Sep 2026 10:52:23 -0400 (EDT)
Date: Wed, 16 Sep 2026 15:52:23 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, 
	linux-mm@kvack.org, ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>, 
	willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com, 
	shakeel.butt@linux.dev, alex@ghiti.fr, baohua@kernel.org, dev.jain@arm.com, 
	baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>, 
	lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev, luizcap@redhat.com, 
	kernel-team@meta.com
Subject: Re: [RESEND v7 09/29] mm/debug_vm_pgtable: test PMD swap-exclusive
 helpers
Message-ID: <aqqtFKfRDap3ksTl@thinkstation>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
 <20260914122950.3283997-10-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914122950.3283997-10-usama.arif@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B247FA000A
X-Stat-Signature: bns7xoywy4kbh74eg3okom6j3akeusqa
X-HE-Tag: 1789570353-672712
X-HE-Meta: U2FsdGVkX18WSolPaDmjkfcI9QwPVG/R59eDWKQbB0YTPAbHR+jeunvtp7wt2KcrQY/5QwuEO2DWCVKTituzkC+0b1qpW0zxbWhRbDjFcQ9Lg5AuMgdzo8AnWmznzMkhUKkiUPnNgMKil6ZreYdS3vJNxSAL3giDUu0mSu5/GVOhCzgqyNVg0xZzG2R47R28pnGH/bmgPBJsYUEpK0uP5ioiSIi4+BTJfZBV4mPse7H+SKNAV9yQ5mQfJWYv7A0of0jTkOdTT/qTIMKagev9FcAAoWBsMIu7uX1XgUqRZC96MOwiwQq2zDwWJa2Fva9xhH+sOozRoq0/NqWdyb4QzCC34nOrw1DBj2f4qDrxHCbi4tDLsOOvlhFujPvmBvIc//9JnUr011s8AFtDgwx2J8iBOtysB9OmqIrxil4i8QRe6YJv+9xtk1+JUeLz//mbwFp7LZfkeHbGAmYUNREgUIEOUqDinM5+RrIp1hdGiVgvO8y3oqKzTeGQEsOxMoaAEZMmbWRZzdvYul00Sos4FzaVGT5XC2B+oEBXb+1H22eZgccY/lkDW4jvPcZq1d2Wbet/a6xodCJxU8wHKXv1pcOgAdjUqDK3UvqqaNAP5uubSf47LXXVDTG3lde7Jc/yNuNPMz7L8O3k/7mA0s53dR1bxd+PDjh5mjD2SlCiFBV/IrLdY/fvVz18xmjw2+9ZygWzMYikNmPnLkVXzwWJvagaFpdP78KlZOOaMyULzEV05NQEPy7dPz/i3GuY12UToDDxLVxzdG0htW53b6mniUcbZes7Ba2nEjy8edTvvrmVHd/dAlHyC8D4xFulg4xYDk/71ciZwhwURAkbDVANUVnn7kjDpezdNJAkmsNhuXP5vRVjMcz6Li9hzbX+Zyiz0kuL5liuk9B6tl6W5bwWmmI9M6P/S6P4+pNOzBBYu+n3aj204+tzs0BIlXWV4uRzgmmcU4UbHd7bRJA94+R
 bUpUcbfI
 Vdb6Xkxb62m5CLZ/RrQVhs/cBGKn314Jv2e2hDlYeK+72DhwEVw+952G7Rp9pr4El3LGlymDiSY2zfP5M3W347julsQsew/gpslDOnWRaRuLBs6Nu38JXFBdDrZgKD/qoLDwyGyKEVbKHEabe0niqmdlPiUtOiFPyXTk3rXuiw0CJ+YkLx33bp2/60hwKvmF1x2uVsIqV2tZZCqbIulhfRHPTEPDjE82t/eb4Oi/gfTNqY+8l8TLpzw1k5pZDM1Vqhr6/M0zZ0VwEE9vGzKeD84m7g7kBgniqtAX3it4rYEU2Z6TU5maeLHMEd6ory0Kz6QMAFIwcGqRh2xueY/Z3GCPqZr+S6AZ4B68U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 05:27:59AM -0700, Usama Arif wrote:
> An architecture that picked a PMD exclusive bit overlapping the swap type
> or offset field would otherwise only be caught by data corruption at
> runtime. Mirror pte_swap_exclusive_tests() at PMD level.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

