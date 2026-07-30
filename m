Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91A7EC55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 07:26:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 777C46B008A; Thu, 30 Jul 2026 03:26:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 728636B0092; Thu, 30 Jul 2026 03:26:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 668846B0096; Thu, 30 Jul 2026 03:26:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3F33F6B008A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 03:26:51 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BBDB7A08C8
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:26:50 +0000 (UTC)
X-FDA: 85044610980.05.94A59B0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2A1A8100007
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:26:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RxfkodDJ;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785396409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q8ZEcwCwLQetxV1WFtJMYHvZdqoS2LqCfUtFy76iNIQ=;
	b=0lFoMgb0yWU4sKOIiuY1K1mOrBA8bGZdRH61T0aUEU6BkSiE+P9FWMcZoO7+/CWhlH9Tfl
	SiTvHm1Y0Q8y0TdL/Wf9uOeXVwFP5BF7+eCsJYppI3EjzmOPxy4cuNpVEdwy4YN1sT6D4S
	diRK2EI/D//jRmY/HNCRIX6Zh9m8kkc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RxfkodDJ;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785396409;
	b=oFXGuG9URIwraD8gHgXWZsVi/qrR239CvqLDpOlMcgKwHwyEwTk8n4qpVbf0jZczcr2Pbj
	Mt9oY5VzowVkDbTswu8fXb/HqSE6IA4txqIY1M5BNQao0yd2z2Ym4Bw2Q/AbUL+WYB5ka9
	Bhe+3NVAVrdZGWjW+icURbWVffbJ/6M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B151F600AA;
	Thu, 30 Jul 2026 07:26:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098F51F00A3A;
	Thu, 30 Jul 2026 07:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785396408;
	bh=Q8ZEcwCwLQetxV1WFtJMYHvZdqoS2LqCfUtFy76iNIQ=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=RxfkodDJSo/HC0OF23G424dtbX5R0k/p/rIVXMGavtHl3+W7XKRuYoP6HD++eIW/E
	 Cd5LgJuI5/SmIbyn+zS+zhKdDtEw5puQbim/Z0grP4kIqj94kWP0NdmVWdfbByZEhb
	 +1RKyVeqOn02xB+tqh4Rpw/q84dmC7v5VLh5gSzr1fo9ZXD8aruKXhgo9T65K/n2MD
	 wr9/CaA82x9z0bQbI51bJe4HZG2u5U6ZFIr5KQK/Mokas7qcjVHU80tOP/8DZDdm5B
	 HTldpABea/BuPoj+0C1DqtvVXsOKBdD67TN0S7P9rXDIaonqncHi7QCfaD2wZL99ED
	 sezDkWd4N6prw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 2/2] kho: Introduce preserve/restore APIs for
 high-order pages
From: Mike Rapoport <rppt@kernel.org>
To: Pranjal Shrivastava <praan@google.com>
Cc: Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 David Matlack <dmatlack@google.com>, kexec@lists.infradead.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260723204203.2997395-3-praan@google.com>
References: <20260723204203.2997395-1-praan@google.com>
 <20260723204203.2997395-3-praan@google.com>
Date: Thu, 30 Jul 2026 10:26:41 +0300
Message-Id: <178539640188.2151126.10266644348178621151.b4-review@b4>
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Queue-Id: 2A1A8100007
X-Rspamd-Server: rspam01
X-Stat-Signature: w33cnmazpdmjm9fdjwijdjoxeruccp7n
X-HE-Tag: 1785396408-486694
X-HE-Meta: U2FsdGVkX1/65X6YRl+6hxeStRe5Vn/L72cYBXq3vCBX7W0MMYXiUv90aPR2lwZINEBW+Tlpd//ZFD3VCLaqj2xyfXT7sdRtKlxQnQhY2tTgGiGWcZs414S9SwPE3Fgb4+rSlrOHtWApcmo4NpHSNRI0FxjS28YtWhKccy6/34mLq2qRYpK6mOUF8gIXrgDqNysUU6obPyDMMvTc4DoUrQBUnWA+cJy0CaTPFjlPhvidF2yzN1pX13NgDzl16aR5EUp7ajgSaStdYFJMeKWFtbJ3bJpKeOywdwbhBorL23uyts+yLS2Kdyix5gmU6jiQuDk7VcAUsF/mJF1UC2WoWPidxgIYiePRkncOByJz/QMwvzz4BEXlBp5VWeF02ksfb0oYu0uuzMN97eid7W16DtLvN7m3pHVMS/Okr6Br5W+Kj1LCKmfOqdAM9kxa6vdSLgwrIpc0XxlDcu86xWhagw1PlgPRzpkbU3M6j7zz81PZjbje3cfDc9MLzchfMXcbBujUk3OBwq8F8AYtMBW/gniu/wSfufrrZlqVAz8bXzNtMu9GXSjYX4c8d+liZHMS1K+H2SgaH9Ps3gvOmlq/J1Yo+WYD2NNwS1Ke/2/TpfOpjOExKMElsqIo+E7Vytlx81MJxw7OCZ9pL/e8IMFVTiEA7Si5sVaep4IoJ2SkEukdtAS7F4TmgsmVPsfSDTZhXppSvShOYuHt/9PPjLjsohWCxG45lDA5zxYPvZP1Hw4fI4ITH1jrttcBI1ear64Vl3lOPbUe8sv0vk7+08X/bLJi+OrpidjdSQ19NWb8jKalanzqrv/lm5s/NkxpZGp19s4lnBVo+FyzKHrr7+rywTHqGVvxaRvasXzQ6ORbO9sXzTf72xOeZnMMnrPBGXO4zHsnw1Q59RFl9rwBvAWaq1pQdymNhcWTM+SXgbENqoSHN2rlooqEeVJKk5dKzdDGsf069RAdqindU/e8Pa5
 nZed/01s
 xt0iwxv535dcEOAH+WhHpmiH2c6I+rc3lrDAPLFd5FBB/giNsth89zIAnW56/62JI/pohPB2hPzbEX2WxD3SyhPhZl7slYVkP5lhy7h/j49EvKcE3y3XAiGbdAVkMCAv3ZysePYLtuXkiqktiNl87z38UyxR7wSsoWqxbvb6sRZQwbrlP8Q/MywIt25m0PW3WObDmznMxK73aAxYUS+auhcqqq4D5aQxYS7zR5heypvDSUP8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pranjal,

> The current KHO page preservation APIs (e.g. kho_preserve_pages) assume
> that multi-page blocks are split into independent 4KB pages during
> restoration. This is incompatible with high-order non-compound pages,
> such as DMA buffers, which must be restored with tail pages having a
> zero reference count.
> 
> Introduce explicit preserve and restore APIs for high-order pages,
> which preserve and restore a high-order page block as a single unit,
> applying a refcount of 1 to the head page while leaving tail pages at 0.
> Rename the existing internal helper to __kho_restore_page() and
> consolidate the common restoration code into it.
> 
> Signed-off-by: Pranjal Shrivastava <praan@google.com>
>
> @@ -457,10 +482,14 @@ struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages)
>  	while (pfn < end_pfn) {
>  		const unsigned int order =
>  			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
> -		struct page *page = kho_restore_page(PFN_PHYS(pfn), false);
> +		unsigned int info_order;
> +		struct page *page = __kho_restore_page(PFN_PHYS(pfn), &info_order);
>  
>  		if (!page)
>  			return NULL;
> +
> +		kho_init_pages(page, 1UL << info_order);
> +		adjust_managed_page_count(page, 1UL << info_order);

Seeing 

+		adjust_managed_page_count(page, 1UL << info_order);

for the third time hinted that something is off ;-)

-- 
Sincerely yours,
Mike.


