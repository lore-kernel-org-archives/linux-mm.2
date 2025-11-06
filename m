Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3410CCFA13
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 20:34:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E1588E0005; Thu,  6 Nov 2025 15:34:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B9298E0002; Thu,  6 Nov 2025 15:34:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F38988E0005; Thu,  6 Nov 2025 15:34:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E173F8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 15:34:49 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9CF7EC027E
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 20:34:49 +0000 (UTC)
X-FDA: 84081335898.16.20078B8
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0FD4280003
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 20:34:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZnFL1KjJ;
	spf=none (imf02.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762461288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kv/GCmE9L06Yr2uSD42hdF0K+X2ykPMAExIp6WiWYQs=;
	b=RStA3CkqaaB1DZp287XeRqltII3BUOUSsqXQR17Fsf12dPPzRGhmFKKksPhfmow4vPSeZG
	pk1yCMj7uxgJRBRJve8KphUUfRUzbz4/RA7azdMF3QftTxTLNqzGTjFbZRT6ExuJihDqQQ
	tdKSsEoVIrs4xhDAwvNDbJknDfFhHRg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762461288; a=rsa-sha256;
	cv=none;
	b=gpukWGuUTnmyk8cklnQCPCSBQjCafaeFNGGRYRA34xScXzICzoRKkdonY3vS2jtAQVoTO2
	5I3KTJPimT/tn9kdPYxOnLIwvRJUUtkF9wVI71n0mnySJ4eKbpf5VQr7E5XhTo2Z4rNO8Q
	VYkGlWnRYuswJUHG6O5mUeDa2pxCfpU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZnFL1KjJ;
	spf=none (imf02.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Kv/GCmE9L06Yr2uSD42hdF0K+X2ykPMAExIp6WiWYQs=; b=ZnFL1KjJp5tAAgcRQ66DEIt8aA
	wVwd6A+C6wouiOI80vPlq9VICgHua44tG/nqCUx2GaKRVwhWsw5wSI58eqHqsD2Rd/8A0TSk365yZ
	+PJSHPJ/AnwZ9uF6RwDrPPd5CVzEAPdNTyLWiwAs/wXq9E7RR9TdwONVQ8Njg4Tisuq1H/XOMmoAU
	XFE418lv40MigkxRVU2hUF9cISZ6GFB6/nvHxk6IYMnNW0BvvS9Xji2aruAj/Ny5pqwkuQTeAi7D5
	TpaASoy1pRI3w0BVp9SbaNjQdrectrkkhrAs1IBuXK+cjaFqv9hCkvikMWT0CZGwsHOHSuhvEVLbl
	yyWHccHg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vH6gt-00000009vSr-1MIP;
	Thu, 06 Nov 2025 20:34:46 +0000
Date: Thu, 6 Nov 2025 20:34:43 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
Subject: Re: [PATCH] mm: Constify __dump_folio() arguments
Message-ID: <aQ0GY-hjg9l5ghJC@casper.infradead.org>
References: <20251106203341.2362005-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251106203341.2362005-1-willy@infradead.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0FD4280003
X-Stat-Signature: y9bkifbires94ncs8kjdpd5ok4yyn4uc
X-Rspam-User: 
X-HE-Tag: 1762461287-532232
X-HE-Meta: U2FsdGVkX192tVkZ30OO/tnndfzmt7z4h44NY7RBG1DehKPaP4wgsa9x7/hehgLwbx2oJjBiIDctXXARP6f3kF1YPqTm43yr9XqGuXKJu5JucFZ5088z4Zxl9qjqMvLF9s4tvskCUICBpSoeEe+lnTcxC4IfNasS455+KOULW3F1jXCtoZnBVfIUTe5cJXz8kNFjfYZR2wyi+wgjaq8rosXHnJ5vKos93lIQGiqEI/spmi6XPgJzA5xRSAG7xniJ4qtGoCV6NDbmzP0mPKzj19ye4oPForl9jEQBQUJFwlRHSCeiLH2spi4yvA6w+RPqB4wRop5XTHWROOU8GEhuRPNkp54FfMeXRmi0SWII9vnXW9RZQ6FsCcZW1P3xl76gT7cZqNy8sSG6Sv1uVmqOCRUvk1QKxvl8huuWG25UQr1p/uZU6Vf05QdNC9WZLqX2PZchwpAMuL3JGsQN29gnLVdhg2AWUPzWdreTI+hu56vbWpy+CHUyfOpMokWi3WxMgl5zHXTUgOyCLN8FfSjtvXJf5OSWAEmkShBk+7RrcrrXvX79AgjlByZlx8IT3Z+R61JlCtVCWyw7nQQfo0up0cgKXTeP1k4CzlKIlQvJPpuF3KD4wGJaCtMYTw9h0b+frRwHG+A20bzaGwP7AYIAuq+DLOsxSfVf4nsxcRBTg2HBjZuy+iEZRL7se6JpfEgF3rfBXRJ6pwqSjuyppfeTMuiO/bR7Xhz53ZZeytXOR+gcouY1HDk0c+XbjKC/lEZmuGMGqooP3win57cMpNAzxCoWhW2NZMDVOLrg6dmi86eWBe2QRWH8bvPJb0LxGH34EnPS+0Y0dMce3eZq2WGmBM3cCzPlU9KdLWUFrrzzO4zaFzHKzlyx66qQroiGQsKFdbH6PS6KW8Snf13eZ/qfqQ47vV3Z9DJ6FJbKktj5SVSBND8RzKh8iVBEkVny1PR3w5DH6fTtsh57V66m9Uj
 1xl/batb
 Aj0wetDlF6OY62QZfh2bVXQBJ9pBb0ieQHogvhLTfB6rrSarKSzRX0lA4BaWW70he9Fs1OnkIy03sBCh12EbSsxD+0FCEYjuZodEPGeIJZHdoHweiVWDHd8RQKn/gCAMyf6Wdq+2gDQ5yTl4Zx/6pMmVtMUvDtzu5m/54a0f6LepOZssRvIG9zPqfeWJ1v8+vyIqr51pJNHVh4AzUXZCfF+xApO0oQAwqCwjegtxBP7k9R8ifQCM8QIs4L5G7Af1pcoJJqHGV1S2l0PXoeCE+Ij39k8pcRM4f0t2fVfsRl7SCJkY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 06, 2025 at 08:33:39PM +0000, Matthew Wilcox (Oracle) wrote:
> These arguments aren't modified by the function; mark them as const to
> help the compiler.

Oops, wrong version.

