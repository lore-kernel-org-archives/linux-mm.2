Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF377CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 00:20:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B74E66B0088; Wed, 24 Jun 2026 20:20:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4BD16B0093; Wed, 24 Jun 2026 20:20:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A62026B0095; Wed, 24 Jun 2026 20:20:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8393F6B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 20:20:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0D5EB40517
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:20:29 +0000 (UTC)
X-FDA: 84916528578.09.3468C23
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4B0F310000E
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:20:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="JkzVG/Si";
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782346827;
	b=RMmReRrk5Nf5OP73FbfVyEQ5ORWAzEIKxHo+Ya31BAkIb2ShuBBbrI5rQBxEXeyh/bouX8
	lzJ+oHpofHukbtWbwF4Q/+KvoNapE/UgikEvQsaKBjpMCF5iYndb3dW2N6ZOsRP36xp+lC
	RR6Hhr77qvbIM0NF/fMurOJuiRC1dUM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782346827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ec86U2KYfVPXD0aDv/YEnMaPQl4HFcBkPI8cCMgcWNw=;
	b=POZ0/MTFhGq36jpH6+GYbc4fg/bweqsyyKLaAVpzc6rA8fOc8XaOpUPCiN4ufGIBNEDAiZ
	AOi7ZzBa4/J0elgpeJB7/PRLUFmsstSDFDh9cKEVNaNHIWPHrkfegp8KKYSqZZn8NRTW+I
	TWIJhgM2hFJWllIF+77wjc5O3Pmh8dE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="JkzVG/Si";
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C3DD60018;
	Thu, 25 Jun 2026 00:20:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DD61F000E9;
	Thu, 25 Jun 2026 00:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782346826;
	bh=ec86U2KYfVPXD0aDv/YEnMaPQl4HFcBkPI8cCMgcWNw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=JkzVG/SiTfTwQpcZ3j5jeMPHGHyISjbX7lUpSd3X37ddUBqdEb8nrkSgAlBhtHFFP
	 Jp31Is2+MkNtnbxtjf/KQmAsO/PtbLKFFJoKcllAPb+vXCjYkKj5u2lOeIO1B+4jOC
	 xurncsVybWurH6HY/R7vzp7Goc7ywjUHnpXx7QsU=
Date: Wed, 24 Jun 2026 17:20:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] mm/page_owner: extract skip_buddy_pages() helper to
 unify buddy page skipping
Message-Id: <20260624172025.3087e8d574285bfa8d6772e3@linux-foundation.org>
In-Reply-To: <20260623065234.31866-2-ye.liu@linux.dev>
References: <20260623065234.31866-1-ye.liu@linux.dev>
	<20260623065234.31866-2-ye.liu@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4B0F310000E
X-Stat-Signature: cbpnkf1ykcoi5qbfkqy6e9wqfa6y16q1
X-HE-Tag: 1782346827-600534
X-HE-Meta: U2FsdGVkX19oP/QcrvmEgAle4gMTnSEHtdJO7rHzTVeGH8hQ+1MbTz7BhDTRzTWAdK9RBTnpixcxu8ivpYZydmUYy6mjEmRr2d7tu22P0W1I294Xb7P56V7zUxVql8YnfVyySAm4L0R+jQf8NcDx0EvVBy6CcqsAUGCSn0PFf0VrTHdEJ5AzLRE91CvtwvHCuJwAooHfOHLbEv3ZEw8oYM2i6VxpiPYbLFIax27gcQJNCle39EGe/G9HmFky6jtULcwDcs4B4Gbqk011HE7BZXBn0tDRsx/sDvHsimauFxm29tKDbWHFl92OqKU5wuXKHRty3H5c8ea4MoTbY8Htx3gZTgJ6jYnMt6vkEMegm4tVrPnq85radg7vSuL+tLCGEPBu86KRuvob2TBZnIuRsAvJTLcsYyIXnv84/HC8eo0wRs0hyhCn+3j7ip1T6PrEUbN4FFb/FixbEkoDYIMfdi6ngSqJQOlPasPMJU76SL4/vqXcWLxn17PZjzTIXBRRkJYz+wPSSv9MDVXo6AkC3kM1DiOoTmE/ALDJIbc/YaPcmVF47ecS1PhBSkDuVq9dAnSJp9FAwr4eDI+42+6y4yitiscpgsDC40+gzcjsXCUUIw5CazT6bIsdTH+pr9W00XrpJ8Gl90qs02xiZ6lx7OOQsP1EurF/hXUdn0FV77aFTD6Pe/ywp+Ri1Aews8tQVQoxuOpRWM5D4J7c/JU1YdLYKUKi8wWZr9A6/+/XkCifLI1B7257nB+uxUcxPvqyBQnMJMzqaPwx9fNnGANJOi/vRRAy8m1oHDgVxXAkwjGp7b4RrJKD8QV2hYBAKhxwtpkwArPLMl44yjKOZaRYLXQygQxOCTr9cLbCMbIVnFn6rsfWtw4aHxMYP+O9XKCBs9nlKiqCE1KhdhPvcWaxmHk1dSwV5o9MBXiDR+TBzhVICJM7jPObMkdnO1vzUVYBKhJJc4cekyV7skvoKvx
 PbAs9jSj
 CfWQWwEBSGtskKA0XMKfdMqG85HMjDaHtykAajI1dTVcESIHOJOvcAYAvzp67GAyiV9ZqI28iSCEXbV9W5/YSgNrwljrRee68cLGGflNI3/16liBVatI75YT7SHRIFhn4nP4WPPYhD8j5DDeSnYJqgsxFMb1e52FJHn2gkoxCH6e0GxRwjBIG3eQ8bxz5f4i2YJz3F0gEmRrqLPRZd0KXhcvEc+BPDqxYTxdypbk9Phwm/T6BnbCVbgKyVym98U5JdvqWD21nFYHj4GaqiI0b427qy7z3k7IXWOkVLr6UQyQZx1MEpyL7xTX2EcOyk5ztWr3S06H2+nm48ZuljUbACwXkzOYgAtNCegtY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Jun 2026 14:52:26 +0800 Ye Liu <ye.liu@linux.dev> wrote:

> Three places in page_owner.c duplicate the same pattern: check if a
> page is PageBuddy, read its order via buddy_order_unsafe(), advance
> the pfn past the buddy block if the order is valid, and continue.
> 
> Consolidate them into a single inline helper skip_buddy_pages().
> The function returns true (skip) for any buddy page and advances
> @pfn past the block when the order is valid; returns false if the
> page is not a buddy page and should be processed normally.
> 
> The old init_pages_in_zone() variant used "order > 0" as an extra
> guard before advancing pfn, but the continue was unconditional and
> (1UL << 0) - 1 == 0, so the behaviour is identical.  The comment
> about zone->lock is preserved in the helper's kernel-doc.

All looks nice, thanks.

A [0/N] cover letter is nice to have.

AI review identified a few possible pre-existing issues, if you're
interested:
	https://sashiko.dev/#/patchset/20260623065234.31866-2-ye.liu@linux.dev


