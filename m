Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0137EC982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 14:54:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF7496B00EE; Mon, 21 Sep 2026 10:54:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECECB6B00EF; Mon, 21 Sep 2026 10:54:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0C296B00F0; Mon, 21 Sep 2026 10:54:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C2D736B00EE
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:54:42 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4FBF3C01BD
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:54:42 +0000 (UTC)
X-FDA: 85238066004.02.DC60EC2
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id B996C10000F
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:54:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hZV6kriX;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf05.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790002480;
	b=SOU1aA0/YXaOaFruLSBrccKG5taGfeho5SIaH/78aECMGlOv5dldaQ46QyvHC8fRY9b1qk
	w2PiU1q3OJvHRep/cnGM6IUtGWRWloCZt2GsGvaeWzoI2mSCTQv55k1UzYz8G92f177vcf
	+O52IorSKARRuxWRy7HwJ5qnpcnec8U=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hZV6kriX;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf05.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790002480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rqlA/SOMNSxfDcyCsYYeHxoxozBGMH/JHbYHaj8T/5M=;
	b=V4BcY+tzhTcElW0+xvMJAiFmoK+oGihbcHfIVynNdYeGJSBzycieY5LwvEJd1qBsMDmUjv
	HQHXb5UK6aKRUaUZDaQ//ij28RDX8dsk6s+EbYyctTgG4wj3he/dSHXTlTM+VVA3KXZJcr
	tZYF+ewVy1x+viLwNIQzGz9scjI/5tY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rqlA/SOMNSxfDcyCsYYeHxoxozBGMH/JHbYHaj8T/5M=; b=hZV6kriX7nqpeD/vjJn13zCehc
	wy+WRvLpFUrnbR1i/8VFcEoU5fZ7P6IcO9HAiDwPU9Y3O7Vi37TYKqkOsKC8m3optDaKOtQbNv6IT
	ss2cjl+f1umh9Hz7JB32YovekERtB+qlR5Zoc9KHxly8LajlE/poezIBAxnUIUhKgljsaondbbotN
	oJ3CzqukXTdvGU21l7pvC47RYEO4i6ijn+5ATuopSr3czOxQ41MUDtEvUuozy/Q+v25aoljs6CSxD
	JfUM9ogMtmPDJSN2F7tvwgbZ7cYDp46i4HVwS7JWjigCWQETbOicNdi+7OwXZhAfCMI2FLfuHT4Sk
	chYdPHTQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8fPc-00000004Tjk-3iUT;
	Mon, 21 Sep 2026 14:54:32 +0000
Date: Mon, 21 Sep 2026 15:54:32 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Matt Fleming <matt@readmodwrite.com>,
	Salvatore Dipietro <dipiets@amazon.it>, akpm@linux-foundation.org,
	abuehaze@amazon.com, alisaidi@amazon.com, blakgeof@amazon.com,
	brauner@kernel.org, brendan.jackman@linux.dev, david@redhat.com,
	dgc@kernel.org, dipietro.salvatore@gmail.com, djwong@kernel.org,
	hch@infradead.org, hch@lst.de, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, mhocko@suse.com, ritesh.list@gmail.com,
	rvvandan@amazon.com, stable@vger.kernel.org, surenb@google.com,
	ziy@nvidia.com
Subject: Re: [PATCH 1/2] mm: page_alloc: do not give all non-blocking
 requests reserve access
Message-ID: <arFFKGrpPwtTkoCi@casper.infradead.org>
References: <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>
 <20260910114602.926944-1-dipiets@amazon.it>
 <aqQlUr-1h07G8JWM@cmpxchg.org>
 <8d6a8a63-4adc-458a-b548-a47bf5ff8eb7@kernel.org>
 <aqq8pWI0u1IZNWHT@cmpxchg.org>
 <9f415dc7-adad-4161-b20d-7c3173f50ff3@kernel.org>
 <arFBJdYaRx_iJNDA@cmpxchg.org>
 <arFBWvzXPYrKuIYi@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arFBWvzXPYrKuIYi@cmpxchg.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B996C10000F
X-Stat-Signature: gm8n7n678t5i3uwqhu4uef7qhogisyzn
X-HE-Tag: 1790002479-882267
X-HE-Meta: U2FsdGVkX19Lk6jqzkqfcfX/jDAcR9J6l9kzSuK4iI62Puv30oy28SGjoeRLUZ7bNPk1jN6/X59a+C9VW2MB2+wdTwBiFzWoK/3qJNBIcl8drLWEnN0CwxixwO+t+2K+Xy1OINMRKJI3V45gks2FOP02UE+K/14/z18lihdtEWnjrN5NwXD7XilGWwTa8QSzdr5bG6olyNCqTf2W8XV1P9sZhlquyW2mGNkraXzcctB4rA2kkHcbzOS9e/D9AE8MP2Roz5YYO9YxnsAkKdGd+3niUDEzmYchMQdve1Qh7wIT0UgqquKZP2Q3C3iwRgYNISPlqlvGdHSdEjuSy/TWe3f5+fYbUHJ0/AlvAwJBie4OX5JLnRvjDxsJyM5gH4FbudA72PNgRzxggdGLb47mHyUiWjPKLU3vg797yynFrhdFLAA4tqc1nB26l92J1R5xeM4+ghn+q2Avapnl81kDIdqdqh80dKexcZ271f9bPI1l14O5CED7OYoio4XoxkGsVeoVn/2hW2QWQhBR4f3YHwls7qvulaGH4aiBr3UGeyDaAFqe3H2lJ6QA7Oeuzdvg/tb8xdFRMJ2vDPLtqx/EHqhhWiSZT4qg/b8UhwPMyz1Keq37JkCCNjCo19yO/2iar6hbsjPFQm//tVZOBOsnUCc2J/OB9mnZxDqbsW9YhJ5iZ+O8gwDRgP5/CMnXSMQMLys4aXHKJoJz2leuTEP5NTeV/xpHwpsSLIBvBS/6wjEfFu7yqA4JFeFJPDkQjsYBqq3kQMlYtCC/oldZBxcZxpIQ4FA3AmDyD1IsqfFEPwFSd4XXHNR3CJIGHU8yuXIkf09ip5xUUi6LHqWh1aodCdTul9V0PpN5CQL1PFfHsOOXBS50dKSNFANqJBDB6lHYExDOV49l4ZuvKMUtgBHGE1Wd1UxKC/M5YIA7hF62WpHz94DsZ/96cY115uBV1Y+DknntoFd83AFBrVkA1xn
 Jd8gwGPz
 DHGqMbFuKFtjpu3axzZ9BNKzIK6Mj8+mFk8eVl81ZRiF1BWKX8BZwOoDYuVjnb0ApZ81/1RH44SpDOJtIyOEYA8y/fISpMISFkynlFTPrQ6GR2rSQckDDZfHEI8ARKDcU6Fb3Yk5P8qXVuuXG23JAWQMVZM1gCKwCmBY3LnM/RaOgAEa7FU/kxPxu9Znk0FHnevXOeYXrtqHfj+oqls8Kjn/CW9NQ3tffRlb01/aIlSx4GN5IYsCQp0wUid4Pl+bkyS8ApOPqXykktWU9cAML1LkpmKtH6WrIxLYKTqzxVulkarhJgl+OebxzbCKJn7jYacyfYRaE5mGf3eozK+T1A2tyNB34dUbgT9eXAJPVeT2+/7U0DlKALsJiQs3pJVSF2h5ACYurkdXNr58=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 10:38:18AM -0400, Johannes Weiner wrote:
> +++ b/mm/page_alloc.c
> @@ -3246,7 +3246,9 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
>  			 * reserves as failing now is worse than failing a
>  			 * high-order atomic allocation in the future.
>  			 */
> -			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
> +			if (!page &&
> +			    ((alloc_flags & ALLOC_OOM) ||
> +			     (alloc_flags & ALLOC_MASK_ATOMIC) == ALLOC_MASK_ATOMIC))
>  				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);

Would this be slightly neater?

static inline bool may_access_reserves(unsigned int alloc_flags)
{
	if (alloc_flags & ALLOC_OOM)
		return true;
	if (alloc_flags & (ALLOC_NON_BLOCK | ALLOC_MIN_RESERVE)) ==
	    (ALLOC_NON_BLOCK | ALLOC_MIN_RESERVE)
		return true;
	return false;
}

[...]

-			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
+			if (!page && may_access_reserves(alloc_flags))
 				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);


