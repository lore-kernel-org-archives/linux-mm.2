Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 269B91098792
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 14:41:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F2D36B015D; Fri, 20 Mar 2026 10:41:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C9C26B015E; Fri, 20 Mar 2026 10:41:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DF476B015F; Fri, 20 Mar 2026 10:41:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6D23D6B015D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:41:42 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1B0821B719A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:41:42 +0000 (UTC)
X-FDA: 84566705244.07.7A4DF91
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 54FB7140004
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:41:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gq6vlD79;
	spf=pass (imf26.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774017700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5VKdw+yKwau3ZpdTOpfP1S0YqtMPTBn1RCFHO+88xgM=;
	b=OXCeinbjzZrFlmhNF1AkpgY46kpAMe76ItAVYvnABVd6ZW6oB/few/w9bs32cy4nmw1CfJ
	hAG9Yz65QMTWZtj6uVd051NPMCuhzv6yezpMfaPC/JMJ7Myu61+snRcOTQdLA4o/4t5a/c
	BdlTvFldjiriYh6gxwE3hhwarIfBbKw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gq6vlD79;
	spf=pass (imf26.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774017700; a=rsa-sha256;
	cv=none;
	b=8cs0s5uIXKRaAzoe7+AscAAcsMrlF3A5PA/d46DUBS8RjydsHxcqbxNaO1DRrwzeuQcUkt
	2pk/j/4Y2md3re31dyv0nYT9h4BeOzJwfLgwa+uiGe86eEh4rnb4S/JdPqwhh/CztBH/Dw
	lMmSdQS+cfhxgdI+HoA3BLc7RRwWKGk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B1C286185C;
	Fri, 20 Mar 2026 14:41:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56180C4CEF7;
	Fri, 20 Mar 2026 14:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774017699;
	bh=MleXr4rMQyGrNTxmnpL0OE9WPCRqySChIwPXxidm8Ck=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gq6vlD79vHeXVLRrDSlXpFcIaooTe1gQEOS9G+vxKvB2xy/bu2aGuVdke+R9e8cct
	 gLy//h1i4t9ddNZMYOlmc1/4aXgQ8Z7FmHVwn2mdODtHHcYUjBUDbvhC5UARRGm6Xn
	 yMZfTO8i2GcnFL2GQJCnRV8gGdhTSXK9baASFvgiZ8aNpA3QM0TiPaHnDHTdYoyJmq
	 S6qXxWNTAIn1dhkOlXGJ7q/K581rghQ5yEGMnJA/hr4jFldOVfptbcSIX4US+jjLdN
	 OBHD9BbCCiwpMZ4QFY49wHolDjfohcQxZA5uC1Ot6bF5RFRc2esOwDAcl5aOANLhFb
	 yTM9ihfiAVljQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 58B0CF4006A;
	Fri, 20 Mar 2026 10:41:37 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 20 Mar 2026 10:41:37 -0400
X-ME-Sender: <xms:oVy9aVSEswKdaaR8aGXLwLX9Mrnm1MTZr6GqsIHJQZjvsPwvM2DHSQ>
    <xme:oVy9aRC1LkmFVQAmC4-0l8Aubu1iP6kXsJbODn6SSK7JpWTvPvq51uBxVY95aeKtt
    lYrDg-DyfGiq5DDzQ8FI1sffcI6lwvAPvFYwgrIKNBh54VbK2PZfw0>
X-ME-Received: <xmr:oVy9aYfWs9mAA8ehLGvEZl9-PdQX0bTxs20Hn9jARCmhuwrlwqffoRjCwII-dA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefuddtudejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepjedvpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehushgrmhgrrdgrrhhifheslhhinhhugidruggvvhdprhgtphhtthhopegrkhhpmh
    eslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepuggrvhhiuges
    khgvrhhnvghlrdhorhhgpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdroh
    hrghdprhgtphhtthhopehrhigrnhdrrhhosggvrhhtshesrghrmhdrtghomhdprhgtphht
    thhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhopehrsehhvghvrd
    gttgdprhgtphhtthhopehjrggtkhesshhushgvrdgtiidprhgtphhtthhopegrjhgusehl
    ihhnuhigrdhisghmrdgtohhm
X-ME-Proxy: <xmx:oVy9aZ4PfLz1Ly6pHlacfHEwjHAP5YtItZ7H2jIC6jrP07jYH_qfsA>
    <xmx:oVy9afdMIA-OHh05bUUKj1s-fmi2GZwD1EfHX8oIHJ9RTxOriHAjjA>
    <xmx:oVy9aYNrQtOYagLdKvAlD3DnuEvEOtvGa2jmiWvOANLHXkLOix9QzQ>
    <xmx:oVy9abHde3Ce_3zuX6me7rTAicDjXXRpGwtLXbtdiJUGMqLuD6hcQQ>
    <xmx:oVy9abbdy3hceuMozJKr_dvhhLy8WJo_jua5CnWxzHG0f4dc8nfLQK4A>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 20 Mar 2026 10:41:34 -0400 (EDT)
Date: Fri, 20 Mar 2026 14:41:30 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	willy@infradead.org, ryan.roberts@arm.com, linux-mm@kvack.org, r@hev.cc, jack@suse.cz, 
	ajd@linux.ibm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, brauner@kernel.org, catalin.marinas@arm.com, dev.jain@arm.com, 
	kees@kernel.org, kevin.brodsky@arm.com, lance.yang@linux.dev, 
	Liam.Howlett@oracle.com, linux-arm-kernel@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	mhocko@suse.com, npache@redhat.com, pasha.tatashin@soleen.com, 
	rmclure@linux.ibm.com, rppt@kernel.org, surenb@google.com, vbabka@kernel.org, 
	Al Viro <viro@zeniv.linux.org.uk>, wilts@infradead.org, ziy@nvidia.com, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH v2 2/4] mm: replace exec_folio_order() with generic
 preferred_exec_order()
Message-ID: <ab1ZopAY7JCUOYvr@thinkstation>
References: <20260320140315.979307-1-usama.arif@linux.dev>
 <20260320140315.979307-3-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320140315.979307-3-usama.arif@linux.dev>
X-Rspamd-Queue-Id: 54FB7140004
X-Stat-Signature: der4rgumn3bn3ggt84x177qte8agnoq1
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774017700-320933
X-HE-Meta: U2FsdGVkX18otM4AIaNx1t7EUERVuI6N4OPjLAeuU1BmeLew9NnR1SKGX1ndgjP9lRFncVOdBUT8BF+o9oo2EhMUaAqxmh1NPyyuc9gUsSPnuvcQvr3Q4VZZ7vkiVLc2eAFvlGMIBmgWZl/XC/lG1qyjPSB/uKjPELVgnRrmRQUDZJip/iQ9b7cSW0D1BKZaaTD+E2u4c8quP1vqItNzZVcSQiN2j0Jfo10p148jO14hOkt9d/R3sf4ZkPMGFeRkxl1sBFTDY0EUHHUt02vWQu6ZZEc7nxVzQ0tiOFPwus8gMKZrJERHVaQVj59WjmY1S8m6vUuIVBZvDC7d66IElNmXxwwfIcbHp1RUEfdcMudL7KX2e+emN9gkIqoz82MkpKYb4HTsoElu0L8JfsTJIA3h+A+7PrWePIY/N8pFmPRfxqTQEXFNbBazFz8SiphjVWAy+wJtzm9aYReG+z9x0qJPBySlXXQAh60GvbwkGpllFHS5AHf67a1+oktqI+AwZmRbKcq5ysvGmxF2YKSMg0s+dbHA3zyq7wnInPSreomZbMAXTbOFL+FGREDsmxh82SpvYGilqxdEBcyznbuV49bIh70cuRkErxS7dLhW8wryrF/YfLjqY4VwbNG180gLp+qu2WzcQpvjKI9yEbBhUaF/5UgNIrRvu6VQfFpk5ppOnrh/TIjU1AxcXpOgk5YEVt+DH+iJaNazjoGVnDCKx2EApUsgS9qgkKrDXxzYdUIzAvXreU1MoZr4J4VQeiqWOdYNT6fIzYCVPDSzTwxsfBJSmrSTjswGRSunndHiFBxh9DUvIaCjflp8MznTXeeIuVttYdZX9Ev5nZaiVL9ADgeUM+ZOGAfMNBzbDDrkX4YNJo0+OrwW63ZCE/KWxYfTG7h+3MgBtvHXI/XyjOSDZbyxujyRbUYhPKrXAI6vyzMGT3NEfw8UhR7+v0709/pNJMVNyaIEra4wlxD81Vg
 uN5U58s3
 q2Mwe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 06:58:52AM -0700, Usama Arif wrote:
> + *   allocations when memory is tight.
> + */
> +static unsigned int preferred_exec_order(struct vm_area_struct *vma)
> +{
> +	int order;
> +	unsigned long vma_len = vma_pages(vma);
> +	struct zone *zone;
> +	gfp_t gfp;
> +
> +	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> +		return 0;
> +
> +	/* Cap at min(PMD_ORDER, 2M) */
> +	order = min(HPAGE_PMD_ORDER, ilog2(SZ_2M >> PAGE_SHIFT));
> +
> +	/* Don't request folios larger than the VMA */
> +	order = min(order, ilog2(vma_len));
> +
> +	/* Step down under memory pressure */
> +	gfp = mapping_gfp_mask(vma->vm_file->f_mapping);
> +	zone = first_zones_zonelist(node_zonelist(numa_node_id(), gfp),
> +				    gfp_zone(gfp), NULL)->zone;
> +	if (zone) {
> +		while (order > 0 &&
> +		       !zone_watermark_ok(zone, order,
> +					  high_wmark_pages(zone), 0, 0))
> +			order--;
> +	}

Eww. That's overkill and layering violation.

If we need something like this, it has to be do within page allocator:
an allocation interface that takes a range (or mask) of acceptable
order.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

