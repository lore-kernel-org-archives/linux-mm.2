Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9ACBD116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 21:24:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07A756B002D; Mon,  1 Dec 2025 16:24:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02ADF6B002F; Mon,  1 Dec 2025 16:24:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E82E06B0089; Mon,  1 Dec 2025 16:24:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D7ED26B002D
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 16:24:48 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0F29213202E
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 21:24:46 +0000 (UTC)
X-FDA: 84172181772.21.1A31B09
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7050814000A
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 21:24:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WCmis196;
	spf=pass (imf09.hostedemail.com: domain of jaegeuk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764624284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G/C5feLyQAWHnHqc78p55PKOT9HaqND2VHQRb+DoaN4=;
	b=XNNQXnvGcNhPShyElVIKS/RqR9UDtPldr86+L5uw6oUU2walDntjuGCLNylZIQ+XDQ5V5e
	x0nZUJ/KtwgmiOrSJ25K/cZb1M0hAP2LnP0pS1R6Ri3TFpM4xZyWHtRd4ZErH0pjPoCCb4
	lbZPj3Vj63weJ6D/5dfMHoNLrjW7olc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WCmis196;
	spf=pass (imf09.hostedemail.com: domain of jaegeuk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764624284; a=rsa-sha256;
	cv=none;
	b=QDfYCANEpeNLUADLEUpastU6oRTLLdC4+MQBw4hBMs2iKuS1lPoBiHgmGQu+W4/htZGgZj
	zmp3qxjd2voo5FMA7NLfCVVBoyj60A8ARORdpPBnEaLgVQmTV96mFwKRr9ZnTAAfockXRW
	igT5jokDCPwmMdrah/9yeL0HNThpfHo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C60266014A;
	Mon,  1 Dec 2025 21:24:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 529D1C4CEF1;
	Mon,  1 Dec 2025 21:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764624283;
	bh=Diz0+bACmjM2TLHSfLwYpuxzqSwiJwi5SM5gyk06rTM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WCmis196wqbZY9mJ/hMHAC4BslWXP9ZhUHtY0YTPcr5qTh+qDb6vUY9v0d1Sb8kAB
	 e1FhyuslxKKlhO8Viqa1Og+MxmReifTKIDv55qcujT8JG00VqvpT04AdvDixdSpjL5
	 WuXiHuHcb+vBwZ+ocU5qEjY+aWKOrn4+VVYUFHOHdiNKYnfPC5vCuGfK3Tv178olIt
	 G3pS7SBEv8ZPYP42vp7mTmS05jfNtc2pqQMPy6+hTdU6MDsR6Aty8eLcWL+xDhd13S
	 TM3bDnHbU8eYl2JaYFKJTQe+v0eKY6Ckgz+ILR34MbBtaUL7jJZvmmYTObWOhHNKh6
	 sHan9gM8tPErQ==
Date: Mon, 1 Dec 2025 21:24:41 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-mm@kvack.org
Subject: Re: [PATCH 3/4] mm/readahead: add a_ops->ra_folio_order to get a
 desired folio order
Message-ID: <aS4HmeRgsStngE5v@google.com>
References: <20251201210152.909339-1-jaegeuk@kernel.org>
 <20251201210152.909339-4-jaegeuk@kernel.org>
 <aS4GgfzfuYRHJdg_@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aS4GgfzfuYRHJdg_@casper.infradead.org>
X-Stat-Signature: 9okm81yst96de5e6q5m8ef6cim87bp61
X-Rspam-User: 
X-Rspamd-Queue-Id: 7050814000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1764624284-922184
X-HE-Meta: U2FsdGVkX1984jMfpK2PB7aCLVHJ/zi856rSb4ntVJF28yvSf7Kj21aFDT6DstVmyPCrCasVbE4PWw11v7u2e1tPKv3BJ66jvvhoAkZez0tHvwICNQzOvhUXEQd2eotgSsdLpRQk854jSxl8qHZ5HLCssbkeSPazuRC0rJkhVPXobRrlZbIHtjWppTQlzMXCuvbCGR/oB8rboVBZSmozRg+1javj34IP31oMyWSGZDXhGKTNFDm8PQhRFtLBUcpT/bz6VHQ1KM53HfmOBjtiMn1LRS91tfrQo9qooFp8Ixmglusi6eEZitNTRee2AiWVOJcPHLtYcbKjpWvoo6eepqDYIlZ10DMDdkn5rybimCLmvhB36SFv0sELi/CpdqE7hjfGmWAWIIO0cp4wvzkmmseaKhp2ilA8ZXmC4B3t6EyM/TUpMBm+QIEK0YyAUhhBfDZmrJvyprPwEwnZmo0Bk1iKJLVYsp0wy/qsRV/R6wpwjfWXp1xfKTNxnGXM/6mHUHo5NC+ch3noyKwCi9YVfbCOfiZkHCbpdCtX4ebHh+LMBxrSZHzBdTGfJSQZoGGeH3dhgX9u7+R9Qms3snKspqzm2oXur7G5GQ7/XBvG4xC0dg2X9LDeuAFs9BZsg8ErTMwgc5Y2mfLhNJHsIrgjIqjjDeFJgUclwhUmkUxwCSXD6/KH2ieR8c4MUyYMuQ8n3x7gK9hJA9ZgMYboqIVSuZf6IzdnzsJkDF5dWCxo0NQLR9M75r9ri3ETGqa98nnIAp2YNyIlCFn2deVg7wnwedbUsagQ/WlryNGztoTa9mA03okIbieoU+kQkjl7y8Lf+bVlJxLeZMZvzMFqEheGZdM+KhzA73uPc5dZOoE3OogcN+hQbj/0yX2HOwzBdE04SpPssK+HJH+IZ3zqZ3Tt82mAdA2ZgydjM0I5be725JYHj2ash5xteQ+hXq5lIq2yzQ5IL68/iQOeMeH3xcZ
 j90GsHd3
 WNgRwFUdashEiWfEus5ekAhZnwwBPK/A0klVq/bwJ81eUrQy+dVo0CLhH9YC/7AHlL/dusObQxWmsryPqqcB3QFV2wus/3qxyMYDtcBxKm4M8Ou95fdadb17eGHuy4TySDMh79e/3j+80aegzMAnvHzbeow1NCNVHXtmvMNWPmQvlNbgMI0Ath7MzP2qm7NQOgAccmEvv5iGVYwRZdJmbK7Liurk8JPQeKPPjq2/y9gj4TajMVCnT7W2jlAri9G/fpuiMKQfBpb2blKoYjOIEFkq6oZ6+m5YGFQpDiCwZiAw31SVvDzGnIjoJw0IAQiXNBpM9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/01, Matthew Wilcox wrote:
> On Mon, Dec 01, 2025 at 09:01:26PM +0000, Jaegeuk Kim wrote:
> > This patch introduces a new address operation, a_ops->ra_folio_order(), which
> > proposes a new folio order based on the adjusted order for page_cache_sync_ra.
> > 
> > Hence, each filesystem can set the desired minimum order of folio allocation
> > when requesting fadvise(POSIX_FADV_WILLNEED).
> 
> Again, you've said what but not why.  Does the mm code not ramp up the
> folio order sufficiently quickly?  What are you trying to accomplish?

That's why I posted a series of the patches to provide more details. Could you
please check the last patch in the series to show fadvise() does not increase
the folio order?

https://lore.kernel.org/linux-f2fs-devel/20251201210152.909339-5-jaegeuk@kernel.org/T/#u

