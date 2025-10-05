Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EC78CAC5BB
	for <linux-mm@archiver.kernel.org>; Sun,  5 Oct 2025 21:12:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82C9D8E0005; Sun,  5 Oct 2025 17:12:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DD7D8E0002; Sun,  5 Oct 2025 17:12:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F3028E0005; Sun,  5 Oct 2025 17:12:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5D5308E0002
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 17:12:50 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D8184139C4E
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 21:12:49 +0000 (UTC)
X-FDA: 83965310058.03.CE0F56D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id CE24EA0008
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 21:12:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=jWfA0YLf
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759698767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f5fInq7i/nyNioLFzjHE98L6f06svbweNidQJNV3B60=;
	b=5kaDrR66PV3l7mALMU4nQ0qHHMdPJWf9GgQ0B3DVtA6SF/rTGes7e8M/DyICwv6DGSIIGM
	1uHNzTSu4URK6rMM+vMhpP6YUm00Stih/7VTqBJgjDL+HS6zLRUmWHh21po/wA0CnNoiq6
	05iNBLpg7X15WDkl775A4c0/ppliiHk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=jWfA0YLf;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759698767; a=rsa-sha256;
	cv=none;
	b=H9UYtwCPWRVLO8WqcQ/NlBYR4LuoiHE9it99VrvqL9/aL6e1d8Cxq3g3+u7sPbWSjDWGAw
	BNTCKBHdPkfLx56zS+QJV7pCp9Ukr8XttFRtE3WGXJzLF5B0PgstI52vWmmpGJvXlT0mQ+
	MeIfkpzBkkTiIpIWTvWk8cMWyWriclI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=f5fInq7i/nyNioLFzjHE98L6f06svbweNidQJNV3B60=; b=jWfA0YLfpAp0oO6VrDm70DEDj+
	oYwXh90lhU+Q/x5K3EMCmGeYLfQPPuoT2GsmYJ5alL6yRUNoDa+GjgsUGl7JzqilVlWpyeMhY5pN1
	k0QTFsbezIqfsZJnYvt9civrinMQiJWbNO24Qa5TB7T3J5HtQPj5loDdOhHmjy3Ozvb0Ohi+WX7rc
	/roTVt50HpOLeyOjnzvK5a3ykNsyFiaGABHDsTiKT5Jdx334tpNsArlccgsxuBD/P2jbhm8E6WtRU
	UETA/CcQluUJKvE7io2P9Mvm7Nu/QuDXlaxet0sK9HPsazD3tn1h+HhVlvlbNw4pyl6uvuAFXTNWs
	R/Ul7KSw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v5W1q-0000000Fzvc-0pDl;
	Sun, 05 Oct 2025 21:12:26 +0000
Date: Sun, 5 Oct 2025 22:12:25 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Fushuai Wang <wangfushuai@baidu.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@redhat.com,
	mhocko@kernel.org, zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: Remove redundant __GFP_NOWARN
Message-ID: <aOLfOUgoEskd8jyE@casper.infradead.org>
References: <20251005124329.28708-1-wangfushuai@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251005124329.28708-1-wangfushuai@baidu.com>
X-Stat-Signature: 9ayfogs9mbu3jxkgyq1mhg6godfnhsyh
X-Rspam-User: 
X-Rspamd-Queue-Id: CE24EA0008
X-Rspamd-Server: rspam04
X-HE-Tag: 1759698766-272250
X-HE-Meta: U2FsdGVkX19GsZPinEJ25tIZWExWZC3r5tqhFUIhRQw1DRiQ6LSsAzTVBsepM/6OW6v5LNE23ivkKnqI1Vo56hkYhj1jIVX5gCDeBXN8E6Q9EEEa3eQdkgwV8zEvbXijyLqPjv81BKZuG8a4HvRygBoCaG/MYWD2VcQ0/Pf24kPcQ2LrtY1Lr/Xr+fPwTXaYyDyAsV+hFvclerM+gp8LymIWkvt9F4vPXDNj79ctPzYrW4Ywlv9Q3XEJuETfRzjU5AIJWk0fNWcaYPkc16cwnOq3NDFxSApTqI8Y+n52TfHbx5+ohDn77Vpl0yUsyzZOvtYZag8Fk7N+skxWrSm2FElIb8HVGzeRMbXJ2dfexJ3MX3MI8HxUq8Kl4J1eYw8UOjlcvQn3dB1EmszO8yjXgbAWBTgGALoduG4gnaZ4wcFBcsBWh1g4gTcyqSUySragKenVjRDADcikGIHptd+r/A7Skjn9YQD31RzOaIPWfwxCvScBPTQZmdXGK45NLZggWTaH0ojee5G9MxHf/hP546tYHwu7mZDyIVFa8+67bEvIQ1Dmtjr5D2UQzQuDPYyZu/J1CuYFvSd2hc5xOO8ND2AAaHwKuMAwHLHwNU+gA6qpUuRzEsqB2xLQmOD3FdfQ3FIJV9DN1vmcvSpJsPc4yuszNJbegdWKjrRCNjIcBMnjKqbcOWm/JDGLnGfO/+lgGpgw0FPykWXdIFhFrYU9eNrbFlBIIVFSXmy/SEpznAnI1JE6FdwZ/iVNhtRYYh5V8SqNCVBONZtF6FVQs6c6YYVMqCCtWY0Zh5TKSPNcI+oR+cPUMe7MLv+EVFFV9EStaAW+OfHjayDk6bPt4fQhoPUi2TAYfE9mQXzEnQSzlL8DCvp91+cwryKqj2m9zJ59lW0ccISjrhd5DR3yTh59asCZdeDEPW3ughy4KV1p8uy+R2L2JclSoTEc4yQAUtPlNhkFOE6FGqpa/b1pgjp
 LzBgVh8C
 Kjz/MRGup1bwrvggom37vN3rooJLa05cyBH0fkcs8uTX93JWY2HTB1NerWjJFj8pTBjoRI2VTIK0/jHjCmT3p9xR9YMzsM5ue4FrlL34GJ58jMbtyupkgpN5Lu4A07pvSEIJ1CTh0A5rGAiLd61BHsR1UGlcbLpkfmOplqFQVBSAGcUPDs8wZK4THONDXXW7REUlhewObyPMFM6mvNAomDibF7JhlSlmlT6Kg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 05, 2025 at 08:43:29PM +0800, Fushuai Wang wrote:
> -		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) | __GFP_NOWARN |
> -			__GFP_NOMEMALLOC | GFP_NOWAIT,
> +		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) | __GFP_NOMEMALLOC |
> +			GFP_NOWAIT,

Please just remove the NOWARN.  There's no need to reflow the other
flags and break the 80 column limit.

