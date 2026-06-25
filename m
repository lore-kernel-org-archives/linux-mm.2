Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C9AFCDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 03:49:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 663F86B0088; Wed, 24 Jun 2026 23:49:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 614276B008A; Wed, 24 Jun 2026 23:49:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52B6B6B0092; Wed, 24 Jun 2026 23:49:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 274C46B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 23:49:18 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A94D31C5F50
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:49:17 +0000 (UTC)
X-FDA: 84917054754.10.F1CA839
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id D7849140002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:49:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=EjYOgoZJ;
	spf=pass (imf23.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782359356;
	b=lugjW/wTh8tFrKO7K4styj/qgUL3aSfLe8JFO5xKFlyNb8JykTlhKOImdZKwTHqGkI7srv
	PjKtbAHtOHE0N26YPmSCULG6zbiTCSmICPyQMoivVmoNlMp6LdJ5FX3pKkCHOHVgaEO0KL
	9cGFGFSi6s4ooqvZRTS4lx4/AiDurss=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782359356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TB55hGeTEaEWWjKg63Nolm76nvhbpFQ166U+vfAH/sQ=;
	b=uTpbW0Z4+tY4gInHaPTh7nzFlXup2L2fltohtiP9O8qH/dmrd7BTDf5GRVh9H5/95X+iqm
	Anj2RAiMwqmy7zQy1n1T2pKReTNCjYwc6Ztzz27jyiY75/qWw82dTRGxd3o11wtLOAWg7g
	lDza6Oa21GVknT7Fk1Hi+WznY8+RCl8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=EjYOgoZJ;
	spf=pass (imf23.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TB55hGeTEaEWWjKg63Nolm76nvhbpFQ166U+vfAH/sQ=; b=EjYOgoZJF1DaphSsqHQkxzbvMm
	JxC+ITiMCsI3tZBmHFxPrIpY8zmCRURbPiPRMnfdfBJ0FCj/UFJcsYf64lXHDIbexZg/SsDptgntQ
	x8oIyGdroeUAEHsbIaw30u/Dnr0gQgWS5Zbm/wFI6RdShqQAr69+aMAHkTUMo7dCm7YrQXkoialYh
	XoVSIPL3JD2rI84PzMe7Izg+kVcAB3InQe2WCLz+0NrzJ/2ryOfVJbs3MQinHk84yILWSVd7vv+u0
	r7RlqIWSE6OL+2/Ibnfeyemx4czyPzuJetrNQxe/puP2g6CBy16inzIA0i9uDLu6DaE2ZyDpNZsNb
	WthJAepw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wcb5R-00000009DBG-42Ok;
	Thu, 25 Jun 2026 03:49:10 +0000
Date: Thu, 25 Jun 2026 04:49:09 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Yu Qin <qin.yuA@h3c.com>
Cc: sj@kernel.org, akpm@linux-foundation.org, damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon/paddr: remove folio_put from
 damon_pa_invalid_damos_folio
Message-ID: <ajylNXBqzSY0ffoI@casper.infradead.org>
References: <20260625012201.2937854-1-qin.yuA@h3c.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625012201.2937854-1-qin.yuA@h3c.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D7849140002
X-Stat-Signature: 7bdxsmsgbrufgjq8xfpc8groge1fn1zp
X-HE-Tag: 1782359354-799076
X-HE-Meta: U2FsdGVkX1+cxIv6EKtVeiqYSr73AR8jERRLikQreeEPbkWmsjmFFnFFAIA65nz1dOulpAeW5zx4YGO1GjDAEjwlF11YV21vDUyWuOv6E0Enuty5T8zkbamUZagjWz0pI8ldlKI5IFxCrdjJ5vgKWbUY6DTnN+G5xgm6hXTDEgWuMoIBzduXn06EW9VF+nzrTXw2pZNapPzqk0BlBgASO03UfB4pOE3fHFiN1jGhPou44R12XHQwrooET0tlwgu9GR/bBNsPFILtuu4JITQCv/lE4VUqpwDmwY3TBfeAo6xXRdbqxpRkNF8TOcMPhZizPaRUOJTvv/FC+n5nitM8pQ6+SQpJt6aIj9gBobAFjLY7ZlVLehyE6Azrz/Y7CY0t/gWY2lLs/pbJhZgn6U9M24ZJ5NIWlDslkiOY5o6DuVN1dLqk03hTpMfXSDiQOGHMigQ5t65QWkT6qwQn/BCD4I2O6xFpLWQYLXpvlv3EqLLNQbtJKlv2Uhv8xq/RzxgyGffbtx6xC8C71fQtY1fNij7y5mOhCGBgbXbWPWgWl6+FxBHDC/PZOsj9nHnz402QLXJ2WzfCUxF9n3MGLPKIBOgRv+rYxICmGYibPbhzamzXAl3D2tJCdtfLxNEr28t84f5BeNWKF/ztLyw9sbgJJOmNzEVX1PGl/6uObPp3wT3JJqySqa7iCtu/vTqsSJMK0RmivelLihdRZZqB+QPIIo82zVw7HN/YktcjmK/io8pnoVscBHcoilth27tWrRzRIktqOcEsSXumxvk7PHSLinziiZUgkI1iV60i8eS03MXhvKeZqfZnRRu9ZERi/VRJno+eUj6+D+mPTKgrmCudYtm70xYEamW8U0PYoL8pIxLVAz/nN/BsCTqM6HDANN2+/UgxoXrnlqVJusGu+LB4G3GJBJkHxFRKC7lyYSCkvHBPuZ2wK/PjwUY0rQi9yS0JkbYt71Y6Vtfv+aHro+3
 vUiHBv8V
 ztBHQ/JCj1eMqo5erUdTe4jHw+PsgCfinz5zdDtL8VNBsaqQiOzosEzzTLgGMjrvh0M2p1dCy6OdsvDybFeg5aYSfoMNR0Yo9CKKjLvWxz8vm+L2JxN4ZchwEeby9EAESpF6H52cxBEXAJvpD6XqoRddCorhbje3XY2D8vgGH6gPwlEMgWN0kmuqrSOTlHv1QZMttBO/m94mp1/HpYhspQTq/RmTAZ3QonAdvs3OTwsjofsonyaGQ+FC1L2TvRwQXihU/IBsT6Fle6xm42UxXPGT7VnSd219voKueo2/LyXztlXtF0q3QjY2JwLFI8BIoIkyn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 09:22:01AM +0800, Yu Qin wrote:
> This boolean function called folio_put() implicitly. Remove the put and let
> callers handle it explicitly, making the get/put pair more clear.

I don't think this is a good change.  It's perfectly fine to have a
function which always puts the ref that is passed to it.  Rust can do
it, for example.  I do wish we had an __attribute__ that could be used
to warn both the compiler and the user that this was the model being
implemented, but GCC doesn't have it yet.

