Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39A48C98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 01:39:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49AF16B0088; Tue, 22 Sep 2026 21:39:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44B746B0093; Tue, 22 Sep 2026 21:39:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3881B6B0095; Tue, 22 Sep 2026 21:39:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 159846B0088
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 21:39:25 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 98A77140685
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 01:39:24 +0000 (UTC)
X-FDA: 85243319448.02.A3E9E57
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id E708C80004
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 01:39:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kjHUXCdi;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790127563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pp4k4+H93MLyr0eA7iqH0KHLuo3rFJiZClzmXOfDGWU=;
	b=6E4pkLT6kiVsdHtbAg2JdwFrWioM+vDxctvdXmsk4PklTYIlGtwMf8EWqKZNokHCHxACVC
	QIY6f28PQ9uof1jBTLgBwqokhp5HDp0nffkM8lKxD5nnjv/UY+oITwTjCNt+I6ba3Bw4pa
	XgeI+KBWm1TmPLyUNUL59vVDr5VkYFQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790127563;
	b=X3boikY2HenlGnKnMf9c2xNWwz0PNpH22P/We+4uFj9rhpL7v8GPnGikZM7jLHds6qyjSy
	8sIQ4EoW8MGHWHiVKs6jTdRwmnxgVTGQdtrEu7P9RSNOXF10n8xKD70HMAun009Oym0boU
	4EiCUP5HJI4xwaTF1b4E5wop71DPtew=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kjHUXCdi;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 70A3A6021A;
	Wed, 23 Sep 2026 01:39:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0072B1F000FF;
	Wed, 23 Sep 2026 01:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790127562;
	bh=Pp4k4+H93MLyr0eA7iqH0KHLuo3rFJiZClzmXOfDGWU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=kjHUXCdimWNssHiG84hgXyOpxr4RDdpWMi+6H9URWbaXrRuJAML2fXUQ4z8D/OP0E
	 SCdk36sajdWZ3RdYiT1zKeGEZ0E8P4saW1sMHZheKdonIo4YJdEGC9FoiZjFg84i5e
	 B9jPLtZonTsACdUCJlHgqfgfY+XpkU1Nxb9mg1/c=
Date: Tue, 22 Sep 2026 18:39:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Breno Leitao <leitao@debian.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 2/2] mm: kmemleak: scan the struct page array in
 MAX_SCAN_SIZE batches
Message-Id: <20260922183921.b30bc1c3ba9443e021910851@linux-foundation.org>
In-Reply-To: <arJPsqUSHGiitXQR@arm.com>
References: <20260921-b4-kmemleak-page-scan-v1-0-fb97d4801b3a@debian.org>
	<20260921-b4-kmemleak-page-scan-v1-2-fb97d4801b3a@debian.org>
	<arJPsqUSHGiitXQR@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E708C80004
X-Stat-Signature: 1xcpuunhinsb6qdwe5hofoy93yx46cif
X-HE-Tag: 1790127562-539364
X-HE-Meta: U2FsdGVkX1+RBc057i6FfUyv0xOoSMQouh9PJ4sc6S9lD0OPWrnjE8teyxqu5NDQ5JkFLrs87Yoq99j1G7I80b1haBSlOjSYqsd2StY5e+nQu348mAHwvL7Nuy+UINQIBf02ufxNIeAhU4Ws+AMEjVh7R2RCmKhSRR2ypvNVQowl4Mu2DCootfkefGW0Srsi8yjhdkmRBb+IqSX0TbBLqBuV8H+6Im5odZvufJwy8kDF1AUyMUTzpV02hsaB+tCQHBKSHXkpcraFAOYYSrX7QE0wzL3ZFiFG2tmU0bxmDyXUlOSLCMAt1NYYNhctIdFRM6ld+mWKdvpZbZoovQeb+mO6jJ/4lqktZbu1ZZ5j4EJiEqxn53AU84PdBgmrak7hKtXhKSCTNg/7OxEIE9iZKHAhmwcIfib9LhcKjJ3TNASc4hv+P3KaXpOSo6wzs8vi33cvZZDau2jT2/3THUrL+NkwSBuqx1UFR4ZoXrAFQ5F0GbJdgwSH0TcZRFA28bvv6WCxraDYEXxsF9L5OdLV11adVoefWL/65DHOl8uRT07kVU/fBBoltM/+l0xj/1PD5S1fj3q4hbxF931GH3JhsYfSWEnRwiBPjALVEAbsnqB43p6RTckIkwzkvYMlaEokR1R+GIQGJY9lMTENRW0IiKnckxsslAPyVrcZF5Pw3h2mftF/yA2k4NECmRRH7YCR1dMwAki3RLDoFz5Nuita0LFxc6pR9BoBnmaALxxHEyU9LykVwatVM1p8om2C5tMXFvqMfTy2e5o1wminesTVIMVLn3cRFFciCqKHb2YS3U9SMO1ieZjHg0NrUYgwAG9EYtt2aTjldirvyZ11IG+qD5WdSRDnA0jafk8rGhQa7V2w0XsjmQ991atvJD3V0fwOcznfuKN6kQmEEDL9jcBJAYNSdho1OgdgF/+QvrKqZy90+oHOTNe+0kzJO+gkTziTnSQP5hgJ5vQ/pkBXH7o
 xhjNWc90
 Pti3QmuTLE8FzZmdjsW49QGdf3iSkq5O2LL6JmQeK5fF0H1K1oyfMQXaRmJ48fxjWC1NRk9b2f4Bbt90cnATCq4Zhn8g9vHSMQLkD+RsDA3o78FEuMlgM7MtCQyQArCH2/3RJ6LkBYIy6MKYzqfQmiIPeILr48IvIgba+zkfpjP0luV/F87c2xtyX0x1/hpTbu5FbPKbzsB/PL0XyzrZdJ4h6eGW2ODJ08jSAmjLdrVhdAle6ktBXE86zAVz54N6+sHOQgWFl5qBwbYE1rmRb5hPIVt8JufAo49cSQ8KbKG7UkmVU/Cw/VtcE4zDbbd+GCKwne7+1G7OLPHEAUjfz6H5GWRqLG1AAI9NV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 22 Sep 2026 10:51:46 +0100 Catalin Marinas <catalin.marinas@arm.com> wrote:

> On Mon, Sep 21, 2026 at 05:30:27AM -0700, Breno Leitao wrote:
> > scan_zone_pages() scans the struct page array one page per scan_block()
> > call:
> > 
> > 	if (scan_block(page, page + 1, NULL))
> > 
> > scan_block() takes kmemleak_lock with interrupts disabled for the
> > duration of the call, so this acquires the lock once per online PFN to
> > scan a single struct page.
> > 
> > Gather runs of adjacent eligible struct pages and pass each run to
> > scan_block() in one call, capped at MAX_SCAN_SIZE.
> > 
> > The longest kmemleak_lock is now held is MAX_SCAN_SIZE worth of words,
> 
> Remove an 'is'.

That was actually correct, but it doesn't read well.

> Also, MAX_SCAN_SIZE worth of bytes rather than words.

edited, thanks.

How's this?

: The longest kmemleak_lock hold duration is now MAX_SCAN_SIZE worth of
: bytes.  The same bound scan_large_block() already applies to the data
: sections and the per-CPU areas.


