Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9767DC44501
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 04:59:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C28C6B0005; Sat, 11 Jul 2026 00:58:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4737B6B0088; Sat, 11 Jul 2026 00:58:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 389756B008A; Sat, 11 Jul 2026 00:58:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 187846B0005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 00:58:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9FD981A068D
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 04:58:58 +0000 (UTC)
X-FDA: 84975291156.30.B2A86AE
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id AED19140008
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 04:58:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=csQ5feE9;
	spf=pass (imf26.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783745936;
	b=qUtum9L0x0RTTJKmsW/EiZTE/2NdmOeijlk4CTk14Axx6+VMmJAHF9XNLyBwpNY4p62Lk+
	OZfGBgkKK4O6hQ++AglkHnzZYyPOtdyT8JlyWGtHXsEiSiSnQVsynjtfLM7Cw2RXWuc+UB
	9eb3BKzs7eqHItKLw7TQpwMFdfdxv+o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=csQ5feE9;
	spf=pass (imf26.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783745936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+4+vNjUxm5wderkTgEuvaV2ZxJIaq1Arr6o6iYoYYz0=;
	b=qyUv29dpWUg3L7EYDS4Z1GKWMM8OaLp0kkZfBGK5sNFpdzPjfApjj4nsfSv0Xw79/T6ijp
	EDPbGMqzXjdlnyqm7jcUwb00uEfhuQN/Qr2Po7/59UE59mUTj/XfDz+oDRvJoA9DZGJnMB
	2PK3a/KsZZ90HZAPsOmX88nTldd+oTo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+4+vNjUxm5wderkTgEuvaV2ZxJIaq1Arr6o6iYoYYz0=; b=csQ5feE9RFWxNiMeQbZcqO0B6U
	bZd45U1tNqrONNlLgEsD4fzd2Llw/aIJKucaTJsQBRdZNA6MtImJQ4fP43fKaPplWlfxJvKqsaGsr
	4n8IenS+MqeTyPql35rucAlhV4nwNgnEyyaPApinHU6x5wEGL4KxgkMVTUgPxu16zKA/4YX4L+TK/
	C1R4cv7CJ+/PhmKIZ2bVOFptStyJ3wRRujpK/d1IbA4kaKivNYiaMq9yqJVb4g56wBOM+mVcrtWo5
	+DIX7eTSW69MbXDhjNuvpuRFoBhnJ5EI5wRokizHtLJWadiIbewpRNUJW1b2nGeytaGN6CBIntXVL
	Q1OdSWnQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wiPnh-00000008gYt-1GlW;
	Sat, 11 Jul 2026 04:58:53 +0000
Date: Sat, 11 Jul 2026 05:58:53 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org, andriy.shevchenko@linux.intel.com,
	usama.arif@linux.dev, hughd@google.com, ryan.roberts@arm.com,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] mm: Standardize printing for pgtable entries
Message-ID: <alHNjbiWFYXSPZtY@casper.infradead.org>
References: <20260709044334.1741263-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260709044334.1741263-1-anshuman.khandual@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AED19140008
X-Stat-Signature: 1en614of655cuoafrjd1kh8yci5t9zip
X-HE-Tag: 1783745936-455660
X-HE-Meta: U2FsdGVkX18Xm4bY5rJ8DJ3sxImJwuCe1PD7OzRPuUPh5QK99NWly7nvsyTa36znTq1oSRBg4FZxBlH5QwCEMjeplGFTh+NyvHO2CLtLwu84NRrXamuzcyLzDrhGDyTdyVSV9xbFQB2Y705zAe2QWb+09Yzlo/P4EpJCD1YtXyxggvk+uoRstv8ZWGZwUM38dBB8cZ9lrIPoPEycwhdG0cF0d/benmm5JLKRycIMyYl4WG9zhGxgab+PNDhJPCsAhcloVMZdHuGdK8EQBpCrNAICei5As41qjDV/P2b+jUoA7uwKPFoO7eAQRAmd0ImeJyJKJqHULeQNu/TvnY8FV7CTsgIX7jSAMrLleYUeWUqJg0b0rrocyX/ix7gX9Hz9Hwo4pCeMPZ/hYNOnhNYHZJTwrdgOqpDIxn9HutEbAzvTUy+dGFbH+4RoSEQugxy/YR6pWngj78ct2EoFO9me/j3ynfpZMID/e38S7zhI9V4ZxthRaQXd05ftY5qmUbFpbtKAWTt4hKNciA7UrpXGvBXHnXQQzaS0g2sGBxg726tK6CBu1S2mQ0i0bXFBxH5qKZOGy24EI/xDUFpd3BESpYoiwklVvvCABlanGx2QG1bD5Z52xsb1Zc48ZuE7chMqOXyT3YT0aVYXtYnaI0yKEPxGqw+ST4ihk05ftg6nmEtuQ6HUD2yrKunRdAu2eOiry63ArCoIOERGdrD8GcyRAzXQyYiOjMEQ4/tvV2HT3ViBt/gC52jPjjU8n4ADnzv4YHBE03/y7c2iOX/0Zf9ZVaPzGQc99x9cJrRUcLAcmo/EvtKZA1icr/Z3X1XLCS20sWrht4NVdpgI+uSAwYF/rM3qEGxdy8vwsSossThQn4qRctp4/bKX6Awwf4cV6BSaf/YaQCnp4j1VXjVl5VJ/B8IDgLLGHoWNU0KBj9Vvvl3CBMxwecyEVStUfd27tlTKh1egCp4jjXqbylnejBT
 krfvRscs
 xNhSttkZpuSUlTrzGmUCbKYheGdRwNSpzoIylhN+U/BnL/vxb8tEpOEB2GxEyUd/JKxwxAxyDXV4XJdPA5tGE4pzuwEMPLJY+oI0q8fYYc1gx81NXNNpoJC+wrV+6z+Jbq1c4Z676mM5D/MtdVYVssWpo0BhZfwac+GRwsINFRH+6T4HfSmD7q/eHA1X1ABrSfNqMG3tU2eM49yXOtq6zmY5kZr1IaKPPjTsKmJwqJPdSGOCyaBSsSqWehg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 10:13:34AM +0530, Anshuman Khandual wrote:
> @@ -532,34 +575,34 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
>  	 * see locking requirements for print_bad_page_map().
>  	 */
>  	pgdp = pgd_offset(mm, addr);
> -	pgdv = pgd_val(*pgdp);
> +	ptval_to_str(pgd_str, pgd_val(*pgdp));
>  
>  	if (!pgd_present(*pgdp) || pgd_leaf(*pgdp)) {
> -		pr_alert("pgd:%08llx\n", pgdv);
> +		pr_alert("pgd:%s\n", pgd_str);

Why can't we do this as:

		pr_alert("pgd:%*phN\n", sizeof(pgdv), &pgdv);

It'd save us all this stack space.


