Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E8B8CDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 14:34:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DE196B0088; Tue, 23 Jun 2026 10:34:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B49C6B008A; Tue, 23 Jun 2026 10:34:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CB6E6B008C; Tue, 23 Jun 2026 10:34:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 074D26B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:34:35 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8DCE4167169
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 14:34:35 +0000 (UTC)
X-FDA: 84911423310.27.FFF6A7F
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1F2671C0025
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 14:34:25 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782225266;
	b=PafXJpfoTwVvss3dCccvU5fB46TbR/omBQa22uhkYnrPtM1QTo/VEmw0S5aDCJ9FEDm3TP
	0UefIjl6oLLhoC9bH5Khm044/YgRsqoGna+bl0SyUvcHo6oXHOdmGJBBTB3u+00oVkUdf2
	zZk3+DJvPxeo7hSjp5z2yBpEDUQ7m4E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782225266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b4TpjoGtEsAKOxZuWsrXL/4UtSyP7izycMtLWBYnEZo=;
	b=YMoXM9Pw/BdDqdg/YxRJ8Ux/Uyx6tOKrZOTMVkTWKuNc8qjmDssK6j2fxPnkzd6KF5ccTc
	COpvciuE8YzoXmOGmK1RutrpXoTaPMhvP9C0/lXKYXO/6utLGsbPrcPLLs2Ofz8xtDkQtf
	b8WqX6fv5X8xK0DNu89DYjJZnGesbDY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RtfBwYtV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782225263;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b4TpjoGtEsAKOxZuWsrXL/4UtSyP7izycMtLWBYnEZo=;
	b=RtfBwYtVStDXM11fmxTFnH83StfyYH3mPT7ItDfEo0tJLUPKqAHpaHguGN1Lj3uU3I+++1
	k0W8Ez4b7F/Ej+ENgHZPefDC2WKnZCfwRwJPyt7TwC2siDE9GCMQQanlf310jn+6fjm1jh
	D9Y1lKo9XhzJHFkVQ/2Ss6QwooBMQVU=
From: Lance Yang <lance.yang@linux.dev>
To: dev.jain@arm.com
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	liam@infradead.org,
	ljs@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	david@kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH 2/2] mm/mprotect: drop 'sub' from batching context
Date: Tue, 23 Jun 2026 22:34:00 +0800
Message-Id: <20260623143400.67238-1-lance.yang@linux.dev>
In-Reply-To: <20260623125723.2503832-3-dev.jain@arm.com>
References: <20260623125723.2503832-3-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-HE-Tag: 1782225265-245970
X-HE-Meta: U2FsdGVkX19j8Y7h1uDtCiGyoXRD+0U4cnb1ZpY56sLibyTS7EwRIcPZhqG+IZXfF/p2EgjY/gZ57dxiuNOEPCkYflB2hc4KXCxPYKPwwlN+i4rg1/UotSx83dNRGU1frckFoOOiK7mOFqkqNrtENf+UZrHfXDXZuT1YNCdZYNKzdobmLRWdm9p/Nh2flzvDa8ZB7C2MisS/zV3bDaW3Q59Jda4Xp7kEzRvkNxJff9apUu3Aa1OLlkIc5PnnJnCyd6N6A79+vNDsRMKOuc/NRMxWnm1UaJyDFKPmrZyNiCpgTK7ARz5tmy4uT0fmYnB3EiDwFxatvL+8JvTJ6q6unN+FhE+NINrElAV3wS4+WuP7dbSL+JnpgDbRRVj2s/z0fpJPiWT5bvVvUSr6FvwGe/F6mnbUG2TapHfemeQM8CTYnMzT3G0cp03pxr2zy4P0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Jun 23, 2026 at 12:57:22PM +0000, Dev Jain wrote:
>Shorten the name of page_anon_exclusive_sub_batch by dropping the
>"sub-batch" context - the function itself doesn't need this context.
>Similarly, drop "sub" from sub_batch_idx, it is unnecessary and the
>usage is clear enough.
>
>Signed-off-by: Dev Jain <dev.jain@arm.com>
>---

Rename-only cleanup. Nothing jumped out, feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

