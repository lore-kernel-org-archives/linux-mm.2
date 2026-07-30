Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58FDBC55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 12:05:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F69D6B0088; Thu, 30 Jul 2026 08:05:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CEFF6B008A; Thu, 30 Jul 2026 08:05:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E4BF6B008C; Thu, 30 Jul 2026 08:05:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 04F196B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:05:28 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 98CF114012D
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:05:28 +0000 (UTC)
X-FDA: 85045313136.11.950E84A
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf07.hostedemail.com (Postfix) with ESMTP id C7C274000E
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:05:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Vpq10jQR;
	spf=pass (imf07.hostedemail.com: domain of praan@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785413126;
	b=I1qhWcamA0CAguI0xQwbnrmTLG4J0re2sXNLpXfRWv/aK2oNeCSkPIZiS8TyH07feKLhhx
	8pD5lL4Ufpu4+g5Zqfz1JL9XFosjIqhvudqGCR1MkE+ZLyt+pUkNnouNQwWZwv0jhZJfeR
	K43Q/FKhIZa3BxJ1OMrXP3+0H0jHiFA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Vpq10jQR;
	spf=pass (imf07.hostedemail.com: domain of praan@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785413126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jtRpHwnpz9cpARPetnCI9M1YK2PZpdz9An3dyVypqLg=;
	b=RuFkQbc9Pjr2PgKJYGhFSe5g6Uuf522KHrsShaFCVP/es9sUeNy+80DfaBu98q0/VF6EIP
	Pt28oZiWbz2XMy9NaCRBE/tpM8t5mZQDzivk1D3qcsUCk2fCHA/pdXTuHb3cQqdY0oCjU3
	7vtQhoQqFriODI1QbCKSohU+WxR8y8U=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2cab97c86bdso90015ad.1
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 05:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785413126; x=1786017926; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jtRpHwnpz9cpARPetnCI9M1YK2PZpdz9An3dyVypqLg=;
        b=Vpq10jQR/S0TUIHiRsvtk66lEtvBcGBf3RdsGxShF9pa6oSOa2UTj4uS7BJctOVlOA
         liqxIKGC4EVxgQkPFYsFg7z4Tk7trzmedndicqGE3I8OM9Ls/IBCNlmac2TsIZFFPJjg
         STfH07BW2e/I8+PQJPXiKZqHS/LDHLIMy8hIBPy6lsZ57mVe2QE2/aJ5Vc58Vra+xI19
         LpYp3fIOEHL+CP/0s7+/lJc01SoskiX4g9I+QP0gD1a0/VgkclKBtuXar11slsfadRVT
         AH7ZGiC4uma0FQogBRAzaFk5iQGglPRVmQ6DW9xFKCsBVMnrf7W8fSoXJ4gOH4BTKUyO
         hvug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785413126; x=1786017926;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jtRpHwnpz9cpARPetnCI9M1YK2PZpdz9An3dyVypqLg=;
        b=M0L2HpdQv6BS7LPqzczom3KiIdxMXOJZcGHimSeNzR+unnahXTChxRM+4JjLENPjPZ
         c4O9s18ilS6CG98nbvXDvCgjexVR1TJJ4tVj3maJ0owlBsEjmrTzaJZsa+7w6SEISAtP
         2pU6fgNnIf1QFSclBG4/mynv8NnqBvHZYsvUgDTC61gpzAFaDqFlQRgrbNh0ZNz9k4yT
         DMoX+otHdeg7TvpYCvEKKOpEJwTOUy6tpMaX7YvyupcwaEKe7Lo4ykRWVOwiY+2P6ioH
         6elk81B7puAZNb3T7+Bjtp6gKp0+di8hgV+yqsGsll88MeYrJ9QlE9tm6ylSrGnChkRB
         zxvA==
X-Forwarded-Encrypted: i=1; AHgh+RrXNJFrEel761ChQ+zyZPb3Gz9hyKpYvRxl0xNFXdSlGo2AX63LtWROZGkFxgwVrI+hzGTH3fse6A==@kvack.org
X-Gm-Message-State: AOJu0YxWFUjDiZ8aR1xu6wuSOYJOCTK7SdSKaXlj5toYZC344ZR5xRrq
	f0R2BC+ykIHTYBaS8WSeEFHcXXLpL2TxvpH0VebRoFyPWhnPVzRPbmn+GCFL+tNq6A==
X-Gm-Gg: AR+sD11PQ5Tk0SYGzAgP66xlPRufcDKBuBTbYVo/MsDgyDVPV6UuoQfBKdoIk8+hLPT
	d6/gznPW5+8LAUOUbSMdsb92vwHVAlogjxdjs9tOSJIqoYmxaIbytwKX17LtkTQL7N8+eooZfBp
	G4LKvIHgG5YYdk2wHyOj1Y8w0HUbBJH2SYYghGmtJKAbzHy9i2qiNVeNpXa/H1YbHKB0K8/ayc1
	bwbuAVmSOiKktgFOCJV+rw1GZ5Yn86dUifOmkOlze7ktkH2M/UhORlKlLuq8GN+Ez83wd27kl5+
	7JbCtsbDDOYLB7gPusZ8+LuDm0qFbbv+0oPNL2SkSShY0xotXpW71cRZF2a8L1doyYVfXMM2ufx
	kPu0tE9ZTdS/zSlH/npHjNuEL0p0VF1QLrclvAsspmGEmjXzaJnx5fumuqHGgmz3jkvlV3eYDjz
	ecQAwhw8ALH8bOW89FMSqdpjvcaxJIfGYfZLC2XSfjyZY1bR9mT6Nz4pFL19EUsvOYfHkKJnvhz
	eksBt9uhU48JqE4UboTFN0=
X-Received: by 2002:a17:902:f2d1:b0:2bd:3bfd:74f1 with SMTP id d9443c01a7336-2d03e47005bmr23875ad.2.1785413125046;
        Thu, 30 Jul 2026 05:05:25 -0700 (PDT)
Received: from google.com (21.168.124.34.bc.googleusercontent.com. [34.124.168.21])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022bc6d70sm26178725ad.39.2026.07.30.05.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 05:05:24 -0700 (PDT)
Date: Thu, 30 Jul 2026 12:05:18 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	David Matlack <dmatlack@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] kho: Introduce preserve/restore APIs for
 high-order pages
Message-ID: <ams9_pf-URoEYdWg@google.com>
References: <20260723204203.2997395-1-praan@google.com>
 <20260723204203.2997395-3-praan@google.com>
 <178539640188.2151126.10266644348178621151.b4-review@b4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178539640188.2151126.10266644348178621151.b4-review@b4>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C7C274000E
X-Stat-Signature: f17noyzarx66dzdmtzax65a5xti9hrpy
X-Rspam-User: 
X-HE-Tag: 1785413126-792567
X-HE-Meta: U2FsdGVkX19sJ8Kdg06wXOBunfmdg5EdCCzK18lJFixFs3zZ0cJ8YBVgG5fVJeWkkQAt9Towr5afLM25UJCYB4cJyjUaoZbeZ/ygSCBn2jeqgJjtSpWSgI5Us1b24PlnCDnwUFHX8Xpf/wHtgeUBpTWUN22BlbWpKgxrpVyrdNbX2Yza/VG7s4d0glWyevOTfeSqFfRnB2PgJePyxLWxvXdWIuUAUx/OXo1eqY8R4Im/w3bF7GY3pnq8jJMpaSYj1Q6OjHAJ1r9QCOd5b5IiLzrbTYHGv4Al+9irAhniF+W8St+Duk3dBJ6c7g836/ZEQz+PhB/IupJLgr3jxXKtJJ1fxnWg1PHTN35PqpnHO/M0i2/reCK5+YJ8HSFlkicpOHb2qfZtIHYN2+J45x9uHjlhPVE+66EYbtKyN13mV7Zx2hAqplQLX1uco+DVU/pVFU8dyPir57V+RpqDyP9TeTSyXbqButoNYiZesFH7zCrsi+5Ftd7hPNaRkM59iSvMv6uheXGQUamIFL3ydSfASD7pLDV3ebWMpu5k6ZcUovAReaMwh+S2loV786rD3BvoNX/HudKDNkiw4mrbuhjJaUqeVfUgQwUa5DaqbiaZzOBKcmaVGsSTUTmUwsDow8PsyXoburq+ZHhPEXYM4fIUpngUdedbKMjnv50mQ2m5RQmGDLupfbTbw2bHvJ8bsLAhuFiJwJrIrlmXq3JbtcD/u7ltvlcbIVWP9M9SEy0V9wsCuucgvcja+uzVpSpTxgW2xv+jaH/U43QbHjS8CuWK3UCXNeJhHbVBv0+96YyyhHbuNf3av/pNy+m8xwL6AnEKadAezpfpObj+EOtepOwjZmtjOmoMpefyxKo1Kf9bJLPoMvv6j7jFaA1EDCVUGojTJcHKeP7H1YNKqa9YnzL/i6wSJzwGVR51zfV1hOBJehAO55vENyAQ0amvq80SIWnleQEy3Y1vXdZVvZYhtwd
 UrIfiy7P
 lCwRVyhamKNTwYqi7H6oeZFIM2jBr6oG40vAtLxW8Uvcc2BFtPpufpkbQ8+bJBvUysfPhqtyfzSctdOXGfhHG481e5pqHxjMJVzdGI1OTslwg5cScRbuOki6ATJg9czp9N55SQdQagTWEqHJyeCHd90H1UQb/jJzZaGxupFSjmoF4Ce/dYvQfnGaLDXS/qLsepNTdy8LlsEvIzmDFfobzAzCkWr8ZtSRaoxb2Ik4aqtvv7V2cwvEYRZxhV5cuOe9OVgo6EPdfd+Hc0bgU5JItZDSRY22As1q8yXse5BMGhZpL3lEldu0lnaurS7/QYzKW7Er3Ia8FwvaOWFgcP1JYUWjtcNjPsgn3EhCb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 10:26:41AM +0300, Mike Rapoport wrote:
> Hi Pranjal,
> 
> > The current KHO page preservation APIs (e.g. kho_preserve_pages) assume
> > that multi-page blocks are split into independent 4KB pages during
> > restoration. This is incompatible with high-order non-compound pages,
> > such as DMA buffers, which must be restored with tail pages having a
> > zero reference count.
> > 
> > Introduce explicit preserve and restore APIs for high-order pages,
> > which preserve and restore a high-order page block as a single unit,
> > applying a refcount of 1 to the head page while leaving tail pages at 0.
> > Rename the existing internal helper to __kho_restore_page() and
> > consolidate the common restoration code into it.
> > 
> > Signed-off-by: Pranjal Shrivastava <praan@google.com>
> >
> > @@ -457,10 +482,14 @@ struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages)
> >  	while (pfn < end_pfn) {
> >  		const unsigned int order =
> >  			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
> > -		struct page *page = kho_restore_page(PFN_PHYS(pfn), false);
> > +		unsigned int info_order;
> > +		struct page *page = __kho_restore_page(PFN_PHYS(pfn), &info_order);
> >  
> >  		if (!page)
> >  			return NULL;
> > +
> > +		kho_init_pages(page, 1UL << info_order);
> > +		adjust_managed_page_count(page, 1UL << info_order);
> 
> Seeing 
> 
> +		adjust_managed_page_count(page, 1UL << info_order);
> 
> for the third time hinted that something is off ;-)
> 

Ack. I'll fold it into the __kho_restore_page() helper 

Thanks,
Praan

