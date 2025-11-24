Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BA9CCFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 13:53:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FBDC6B0010; Mon, 24 Nov 2025 08:53:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D3B56B0011; Mon, 24 Nov 2025 08:53:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 010A26B0012; Mon, 24 Nov 2025 08:53:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E08CE6B0010
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 08:53:37 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8FC331A0373
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 13:53:37 +0000 (UTC)
X-FDA: 84145643274.18.EAAE30E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id 036D0A0007
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 13:53:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=MGy5xitl;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf25.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763992416; a=rsa-sha256;
	cv=none;
	b=8h6ok4RcKkrh4pM/rhV5dnkqXj61LqLEJOmpg1LXH6abScMN4s5YvUdwF+E5RNhj/JfLD4
	h7hm6wvRSHdqmVkE5Q7X+YfXYlpckK4oPdqcQd8Ltlz281duGUymYdoWr9S3jyYyPT8thW
	2ELwC+uMVjNT2+V3A9Bp6UuKvRB5t78=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=MGy5xitl;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf25.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763992416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wsiXRQfBIuP1X/ymVHWC9NM13GowOoMIRmlz9r9QKOA=;
	b=0AmAzgKmrVxjobb4E+4KI27z/XHijacXQJN3ZBGHhzNo/V/KXYOSbeDBmgr27JEwfYaOn0
	IXN+KIoesRBMsOfOwB3G4+Sk5cpg55AbItOta6BdfLPDzVO8VeNi21HLXe4NMdroAIuDHw
	0jJN3EpnF7RUXEVahqpjMSx34BTuGjI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wsiXRQfBIuP1X/ymVHWC9NM13GowOoMIRmlz9r9QKOA=; b=MGy5xitlEXRgJzKX90CcI9Djmw
	FeSO6alWPJG+LQE5W2S50TW3ENcP7eei5BrW7O01CGZh1qageGDB93Y+MuqW9EvMw7iAKIeYtgdT6
	Ww4shm6OCj+ixtOET0VHfG7sTqBFlCNwPJJPg/s2mxZu8AC3CzpV70mRabqNF27hB8JxoCcmXpVFA
	KXycB0lrCWMDHmiyBCgEV2OoC/VvL728y8VD2hTaPwjp0sF0V2pm1s6ncvysqByCmOLbOtkP1MCld
	WqXj6FNrftzGqRI/WK1yjnM67l/oFzgGqZdBIUaBeHWdwqOsjtxDsSRL/r5eQ3w+lOPzSyWpaAzLN
	jt/Lk+wg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vNX0S-0000000744M-3Unf;
	Mon, 24 Nov 2025 13:53:28 +0000
Date: Mon, 24 Nov 2025 13:53:28 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH v4 08/16] slab: Remove folio references from kfree()
Message-ID: <aSRjWB5nxda44UKF@casper.infradead.org>
References: <20251113000932.1589073-1-willy@infradead.org>
 <20251113000932.1589073-9-willy@infradead.org>
 <aSPvgRQKAKgnAlih@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSPvgRQKAKgnAlih@hyeyoo>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 036D0A0007
X-Stat-Signature: ejfjuxb8ac5w5mm5wejp3zkudnmxik93
X-HE-Tag: 1763992414-73385
X-HE-Meta: U2FsdGVkX1/IDxId0I8lAx8Kh2NHNllrvRCEyVluboTwaaxLqPf0vVnviB8MeBAWqGXXrdqTKTmvYPpecv0KhB6ft3roQb9LhVkGpFKPKQJlkuLNzWMH/xF7XRdr7XYfBtqke4QqpY6wklBXmLxixipQL9j7dcXsL3Y+LnOagKG9fZ5c3pLhxtivgGDucaTQgWVwDwh08BbzUOnBinNZw18kJ6tI+/YtCKlgtvH2VyEC5IzHQG4NKF1oSOrEeDFmdasQIqjkEWht9QAzGNEw+fPKWnVRQeuiOc3lThwzK/PcQZa3kYmRg7JCWxlPBAdWIx4dcZZY1/KmDP/BxgryHEXPZtLZdDu1LCL/+YbVh7R6PYyLFHw+YgrvXpNkrdAVTEbk5iIgiVjDNUW7AgIVe9EshVAoqjIrk3GIM/xoSnj+C7BhjliVkpdJABytjg2UVvI6P3ksjPRUvPSNL+q+4Afng6B4CDgO/I28a0bbm0DHrjoLv9C2+woE+foOMXfsg0Z39vi562eE7QxJoeubVIT8M+GQD5Ghxc8sD4RR5YzCuHw2qj3tm8oOkA1wgkmk2CsHOipKPUQpcfSzEWCw4VhgHGi2IZ27V63G9BGY38mm+wIapOTQsje2rb1pJvqHLw8RtyLUWFjyxPYSJ/IsTKpGk8mrD64/XwWCFGLGo4xXW9OhdMIQvA+mHvxtnPGAUtvUXqBWzTfsnWts2f/RAHzsH7gf2unQXFdtL+BRpbxDqKvxPVCaOzL5Ro8bGCcI/U5eqa1SS4I3cf8jPMoOCP/UCCFzXXESs1jTbrUPhiL8kDfGu50VuosUsPAYVAa4c3koxOuEjO0hbezyUHNW8dAeNaH8VJA43T2Rx3ihC7VCKz2Jv1QIL0QjZVbE2wNCbxtYEq04GG5oR1iSnyuzrFgoQaVAJl2r6oIcCdSTkskQM/wyBEkCC7dFvDvSfgvaJMZWBjTEY9OsyaZ7vKq
 Zbhg4q+W
 YsUznkXjpMpb4tBagWgQ8xIGwweUPv3avbycum32IHI8jdEuOktMCFyHT3Rp3Pl2b3rWpvBfReQHNj20Y8ZqLhRZoFxYdPGoXeM3TaGf8hzwVtx8hMp3SplhRaY7k9EtGirSo8Y2FsxTt121MaSFb+pjlR33uiWTTBEv4897mWEvpczM11gWCgPDkwboi5MzX72vG0D/wAXRhKs5WjZ4rEZUXF55RBPBvPfzpB65Wdzt41y24KWHbOMbh5Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 02:39:13PM +0900, Harry Yoo wrote:
> > -	folio = virt_to_folio(object);
> > -	if (unlikely(!folio_test_slab(folio))) {
> > -		free_large_kmalloc(&folio->page, (void *)object);
> > +	page = virt_to_page(object);
> > +	slab = page_slab(page);
> > +	if (!slab) {
> 
> nit: is it intentional to remove unlikely() hint?

It is my understanding that the compiler treats NULL pointeer checks as
unlikely by default so we don't need explicit annotations.

I could have an incorrect understanding though!

