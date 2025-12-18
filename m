Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81DADD711BE
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 20:52:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B69966B0088; Thu, 18 Dec 2025 15:52:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AED496B0089; Thu, 18 Dec 2025 15:52:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EF966B008A; Thu, 18 Dec 2025 15:52:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B8186B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:52:54 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 36E99B81B8
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 20:52:54 +0000 (UTC)
X-FDA: 84233791068.02.E8EB0AF
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id 778F3180002
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 20:52:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=NC3NkNKE;
	spf=none (imf16.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766091172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UMqge3Wm+VgxLTio4FdN8OAle0L311HBGFZuKMtmTVI=;
	b=PiWpA4UkfpaUchS97/zIJKj5s4QIVUdLi7nDn9iPdKYeq2bCUGdgwYdeVObB5ZNzWzbGaS
	OMzTPVfLRSNqdvUcpLOI11MoFX70Dtehfjf0vvxbyUcaEwOYevRhkKipylj+qP4SfVV4gc
	TpVFFoIlCn3A6zISH6KrxMiIbyc9+0A=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=NC3NkNKE;
	spf=none (imf16.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766091172; a=rsa-sha256;
	cv=none;
	b=5gRIXaBx8KmFUsS+1wPk0qj8Lz21mYJvZaQShLnCkr4wTt4FH3GPBaUCSaR2UBcbLY51jo
	cDuG2CBIfLX+cIHJVrQ2Br+pTVRo2Tm1yKpEPepuUWul/SYnjYzXA4y97fuFlj/mfb6kDY
	NtW+WsYinwQ6a3P9zFUm/47p5VX7Rn0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UMqge3Wm+VgxLTio4FdN8OAle0L311HBGFZuKMtmTVI=; b=NC3NkNKEqvSl+1+wnRQ3dT1Ccy
	yLv0g9PFBKHZJIJs/ccOu/TtJ+ODpZdnt8Y5O3S3yC0ud6D268K9zbO7S+aHRxni5yrR7mZDShYlH
	Jc8YqUbuyMTN3Pyu5qSTolnIMyROB6C+0rNAsbroio4UnZrKp4mUi0kpCkLHOsNhFkTZwrsGV7KIX
	5XRnmMd3cwDRp0iU21ny5Pvzo8aq1pkpljdKrmFbdz7VKjAzwVufKY7PANl42kChD5ZTA7df2yzas
	GyHiUgdNMGBNxkURETEH0Sf4nX1WRcpeC8djYxgwv1q73bUzviHxWb12n1wjg3Lrug0hY5MlsyR+V
	U7NEpsBw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vWKzQ-00000006cUq-2uRN;
	Thu, 18 Dec 2025 20:52:48 +0000
Date: Thu, 18 Dec 2025 20:52:48 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mm_init: Replace simple_strtoul with kstrtobool in
 set_hashdist
Message-ID: <aURpoO27Yys40ph7@casper.infradead.org>
References: <20251217110214.50807-1-thorsten.blum@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251217110214.50807-1-thorsten.blum@linux.dev>
X-Stat-Signature: 1npquecu6uc5cpt8eunrrdentqyk7awp
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 778F3180002
X-HE-Tag: 1766091171-544802
X-HE-Meta: U2FsdGVkX19UqVPzo8W78otrutHT7WoHcQQIvPHKkeo1WgOEOo+VWR3eRcOPvq0RufflhHq4Z6BgNMVspTEKeMsgMZmI//bFbx89pdBx648AY8twRXMG2b60LR0GbC36k7choAM7U5mmqoFyKpm5GmMPR2fhnQ23iGUxuGCh6D+sPXheNQSsvK7l1vrFX9u/bQelxUrssor6x3B6xtih+0Ki9lJEVS/RxaGRba1sG5IIQXNf1z19y29/OqpjYfnA15yIdg6E4kD2SICKnkLJTXKVQmMoFFQaouhzVYDIvDxEsrt0p99TITMbiy61Da8BNRjNNDAd0TdrJYswrVkhtXQ+ru4IQdjOa2zwkVRUBOFySA0yseWZqvqhnmkqYQtNlQXK4JSr8yMWgo0rgPLxeocSzH+WBO7iEVx3dCNJuxn57pBXIr+3P4/ggZEAEYq9YoA9AMY2fQwL8ERCPsKpsLKGhUCdVj/mZK1su9oXCMgW3F1cHgt452UMW3TZo62naD+fb1+8fW7XB510o5cJLueqTkOS60+6S/qJ6Y1R4w5Y3wTuGQpbuUuCuXYnnc0k4Osl6bucEJAwJk3A+qM3chOby9dMMEJTw5iuxQ1tvjQwqicBT7E9FdDZucG083BMzoBzkN9xSQzwrxf1VIlxVEwkKAnAmSoyzE8aAfuZBXGmvmSeUa5OXqU+IEJTJUVnC4L/vDDfM5muKADRVrxSKxGTsrPKwwdFpA0kqGxSyZlS5IdR+76HO3ng40LtJJsePVNo3Ai0fCSAdQAEv8l5azSbJQVRI8tRk1Bho1Fk2FjakLBA47TvJh0i+dlfEwyMo5nETEJnMCO0SMfFwLF5e7NEdiiqRZ2hMFL2MgJsT3mZbWXi6+ibpAkGfhXBRRamcN23oIV5/6cess97yche8GaOAvAZEmGU+JrlozxbQLJA6Nu4GxZHFV/141EXMt5t7n2CT1PuDXNWo4upsur
 HcOjklzP
 Xvs2c7NUpEvmfPq2DPTmgbVlTW+whO7voU9C/IM6rjnZWAPTgTIOgyI/BwpuqaIvj+YVERXoDH88OKGo0nMTLqu8nwr+goB9GzVpGmxt4AyhQoFPMKknsgoZ1zoGLaOPgSNoEwpCzayHr1wGqm0cOQQbkW9WINzYXtys+OFLyVtgX2MB5ls8J4r3eS0X2cGaAXn5ZwDxRs78yQy0483x5mYjnzmXMd57/ZW4Dzej0B502WTnGGZIoYyJ9bG86uAywTbKapOK7NydCHmzeZBruOGlExIJQnqsFKRgBYwfUgevFSltyykazOb0wPk/HF7GHMtG9as3xAktEq3fapoHbSGtf32kUKQhFrvfZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 12:02:13PM +0100, Thorsten Blum wrote:
> Use bool for 'hashdist' and replace simple_strtoul() with kstrtobool()
> for parsing the 'hashdist=' boot parameter. Unlike simple_strtoul(),
> which returns an unsigned long, kstrtobool() converts the string
> directly to bool and avoids implicit casting.
> 
> Check the return value of kstrtobool() and reject invalid values. This
> adds error handling while preserving behavior for existing values, and
> removes use of the deprecated simple_strtoul() helper. The current code
> silently sets 'hashdist = 0' if parsing fails, instead of leaving the
> default value (HASHDIST_DEFAULT) unchanged.
> 
> Additionally, kstrtobool() accepts common boolean strings such as "on"
> and "off".
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

