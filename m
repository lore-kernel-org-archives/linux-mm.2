Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C037CA0FED
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 19:00:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6016F6B02D0; Tue, 26 Aug 2025 15:00:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D9786B02D2; Tue, 26 Aug 2025 15:00:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EF066B02D3; Tue, 26 Aug 2025 15:00:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 39E136B02D0
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:00:18 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0397F1A02B5
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:00:17 +0000 (UTC)
X-FDA: 83819824116.11.9C5CAE1
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf29.hostedemail.com (Postfix) with ESMTP id 826FC120021
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:00:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=TKuqsMOw
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756234816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V4kacEIEMCQjuCS3jRmYUFJOyZV+6C7MDRucR5sR/j8=;
	b=pe2cGhP3R9EYyBroOWUp2ZJNs2VT4K8MH0rdVPMEKaWU62AqeffS0WZ5Ib9pJtvLhbJcF+
	9uNcWU6f6uybjw/GlK+K8BZwfPExC+Tzfa6uqvBhY/c+IM0A27WwRpfDgIEHhNmmUfp6TZ
	pC44/hLdRasQ2+RHYuHsByrELkzx4cQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=TKuqsMOw;
	spf=none (imf29.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756234816; a=rsa-sha256;
	cv=none;
	b=OvS7WUUglSUrYsqAexs/sK708hJoGRg70Pz97Y+UKkV7TYKZLMyyEWUKOwBx6VJumSsVpI
	+Hu5CHJT/xKE5UbIy18odNSDCBrwWmtfyFPImRVqtamYvQnV6qVezMsHsm9YtBZohfdwpX
	99QNQvy2BlNyx5tYKtKbLjLXEMxMEWY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=V4kacEIEMCQjuCS3jRmYUFJOyZV+6C7MDRucR5sR/j8=; b=TKuqsMOwUwQf72PpA1+edS48be
	qKs1l3dX14NgEit+mzoeIRSIasxhWwhqNNnITeLGwj0xRY9KZK0KV6hCW2yoVpwYEy3xrgs2QySsC
	e1H3zmJv4bMMpD1hrFULM+OvP/w30bUTW5IU4sCCwEs7/CZqkfVgZKB+Ypc7gWaywcKNRVCdtnEUd
	J/sne89uQLzv9RadQxz3uUltMlyYPNBHAqXS6iBnpdUPrFi+rAV8GizpK+w2sGtR7+XHN4XtYAnXi
	AwCCMGDDhHYFH4+HnJV735qIB44rLCnetP0NN8hi6JHz59ZGsO+r4kLIi/6IoXEyitP4mu27+k/D8
	uQjNmmzQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uqytt-000000080i7-1BLX;
	Tue, 26 Aug 2025 19:00:09 +0000
Date: Tue, 26 Aug 2025 20:00:09 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Aristeu Rozanski <aris@ruivo.org>
Cc: linux-mm@kvack.org, David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>
Subject: Re: [PATCH] mm: make folio page count functions return unsigned
Message-ID: <aK4EOf-EE43pi-xq@casper.infradead.org>
References: <20250826153721.GA23292@cathedrallabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250826153721.GA23292@cathedrallabs.org>
X-Stat-Signature: eeud3yfjk7bwus6ffkc1hwr6sr53ideh
X-Rspam-User: 
X-Rspamd-Queue-Id: 826FC120021
X-Rspamd-Server: rspam01
X-HE-Tag: 1756234815-823378
X-HE-Meta: U2FsdGVkX18AQYRh6w5UXfOZbI2kyL9wvQEAKj+vdrjmMJviPQeDSp4DVRpm1Vgrjdgfh3QO4y97fHIHXDG25PC5gi3DaxT6WVkc2ycbFpsd/FkLv1xtmjCiFoNgqbxLzdUdzptO1qO56+2JF/Cxg6NI64IyedJp9avHrJCYDrlfyD3kU5H4sIL4XyDZvlVe5VbOfflOcZIocdkfMBqpNxtt2qTltbq3t6zfrC01gXludyAdNsF06xLQeE0Vx97po43iwPRnptTwX+RDxbum+sZs0WUIKlwnsfRVmWge+Lm2oVBhug0AB4ki9sAgQnD9MDGVTX0K3kcA9J+lsFaHuCe5rHys9M1d0O4IooCD72WhhZkq62WBnuHxE+cBjQ+KEh5bLUrnwv8zTlFeyyTGNucF4GXLnvWiMRsAvjVMxQRpBf6XyyB8w2A5dK1ZNwDC+DFeueIWeqRGo5qeKXmH3cXGLoICD8F7huak14fWr8hLLTyxcRJTQ7OCUcM/jjMZIdVi1qygjaM3opLGAdSNco2yiVKu/HY3A4aD9GG0a7gAeYcegyUmaB2uN78wzTylMFHx1Eh4LdRYaif/mqNCy250c7hVca2D79eLmfOkSQJU82iF3ISZ3WiY/SN8GoyBjkK0m5X16tny7F6SNVtx8+c6wXKXDW/R8dAY/nkNHNpkLhC8bxSnfR+fM5cZOqdfTxpm2VMQM/wRK280n0Wga47fqS25ehTcu6CpCrPd0A178ii2LWT5z3U6FuXcto+QD0Cd87fhKtM3sIAgu2D7Ti/f9RsyRrHPnVWTRlPyMxiJGfpRawWzbluORjCWm4kEeYp/Z1VaYUkAxCAjIk0NuHC50u0T1MnabJ1cG5RVC6LlXM2Qnmcve6y7a9lEZe4AkAfL6s4vLDsu7wgayRWj3sC/TsUYPgqQoi/Q/Dv910s7R3J3uEum3/8EO/g19NNmHx5w2DyAaPrrctj2dwe
 ZXBmPjua
 ZJ4gIejo5rCh34NWc6sqNwc3hF4E+hZcG7v7tCcP8qOBYiZvajscZYzlUIyRgcJYu/k9jPdfIsrIYY7OPVor0BIa70yKHEDU3kDSOvR05WZESz7kUPQJprMhylSHRaKjLmSTlO6zAVvxFSbZOHdSuel2efsvjGJ47hWK0ibxzSL34L/Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 11:37:21AM -0400, Aristeu Rozanski wrote:
> As raised by Andrew [1], a folio/compound page never spans a negative number
> of pages. Consequently, let's use "unsigned long" instead of "long"
> consistently for folio_nr_pages(), folio_large_nr_pages() and compound_nr().
> 
> Using "unsigned long" as return value is fine, because even
> "(long)-folio_nr_pages()" will keep on working as expected. Using "unsigned
> int" instead would actually break these use cases.

I wish I'd written down what this broke, but it did.

Sometimes we pass -folio_nr_pages() to functions.  If it has an unsigned
long type, things can go wrong.

Please don't do this.

