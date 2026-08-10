Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0BE5C5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 03:22:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89F886B007B; Sun,  9 Aug 2026 23:22:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 850216B008A; Sun,  9 Aug 2026 23:22:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 766356B008C; Sun,  9 Aug 2026 23:22:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4CB096B007B
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 23:22:05 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CABDA1A065B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 03:22:04 +0000 (UTC)
X-FDA: 85083910968.21.E2D1CCF
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4DFD51C0007
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 03:22:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=XMg7xexI;
	spf=pass (imf21.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786332121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8TjGFoXlF/ytQT8rm9ADFZepaiWE5JQy8cHAE80+I10=;
	b=d7I8KyCPQlHFT7TmAWba6We60gsNgo5wUUDk6ZrWw3RrSPcIvGxL4ckMxDoCL9xXU86ptU
	F9gOGMwaRZm3wvOuyVDwMrKAfFS8gtHdeYyBOPyTpBrxUkHNoyqERACK7BVpx8Aor8cXnD
	dcqjnqh4NQjFIWeA74xRyRjeLRqWB3k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786332121;
	b=8IMqohqOA4v2bVIWAzb02+UA9JnBLdcg6n+ZnvucrIT0bgy2Q8e1zQqxLnIVU3SE8YgYkp
	NhsdlIgiJUK4cxg5uxwe5DKGA7k/oQdHeHuwiYpy//VDQF+h9xy7kBUDGASt6mFbZcmLcF
	B5Fmc1inJtqzpa4yFtBvJFhF87U9zeQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=XMg7xexI;
	spf=pass (imf21.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8TjGFoXlF/ytQT8rm9ADFZepaiWE5JQy8cHAE80+I10=; b=XMg7xexIOJkI5TFBsySMXeHs0f
	uSLNSaM0LZLiWWkWqV6GKiEQL5m+UaP7o8gMkF5n+o7h31jMIisallq5RdyACr5B/njvuP57uLb9O
	+TN0+aPkCwnF4SA3+OiNwRlAzE95i1b59KYuGdtDfvs198uc468Ss4YKCRVGwzfx/JClozTepM6zG
	/14nwnkjB3IxUpRuOXg9dY0tPH3qyQlmAY0d1WZNSEg5eSMspoqIPH2HF7wayf+XQ0AUAQTefXRDu
	zGPXqS+Ct99EuxOADe4+2LG5w0YUV0VSkDEE1ex49ZQmVLgBWP5RUSEjbUyyP2bslaGG8Y5DM41C1
	pc/2YTow==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtGaH-0000000ABz8-0sTb;
	Mon, 10 Aug 2026 03:21:53 +0000
Date: Mon, 10 Aug 2026 04:21:53 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Longlong Xia <xialonglong2025@163.com>, Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Longlong Xia <xialonglong@kylinos.cn>
Subject: Re: [PATCH 1/1] mm/mm_init: compute hash mask with unsigned
 arithmetic
Message-ID: <anlD0ZX0BZb_MVNw@casper.infradead.org>
References: <20260809123119.3811851-1-xialonglong2025@163.com>
 <aniIuZa53OBqCMbB@kernel.org>
 <d12a05ac-037b-470a-a91e-722d15ed712f@163.com>
 <20260809181400.148e68eff30394f6b029f4d1@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260809181400.148e68eff30394f6b029f4d1@linux-foundation.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4DFD51C0007
X-Rspam-User: 
X-Stat-Signature: eyhw8oufpsmos3kky9pyfb95hw9nnxck
X-HE-Tag: 1786332120-291239
X-HE-Meta: U2FsdGVkX1+LobbLMidELEWO4yXkaWQwbCWiUL2ptG7E3l6hsZbb9QwAYrvhfEvs0hb4p9wAm2THgqDFEeEwQM/mRNBApQ2KEO/doTn6dwFlUfxX2sk8dodud9TnhMKY+aOG5HvV59JzJbPoLpAonEOZanNi9Z7kT/zruC2GnQghIKSW1480GbbqNpVKKlRsBvon4vCRDEcR0I3WU4ARuVqj2Kp1gWJSu6dvKlo9Rk5qG95xudz2AW27u7ZDjPEXE2gMiRPdxoaOBCS6hAEoVuVp8QqoHek0eRwKz3mkujHLoQ69362xPHT93pK6g33P8x3G02O+Y0B69kxJGsXXCIN2KpvAThNiiyM4x2grsqoQk+8Gf7/SL4Qg0kQcAsg2mXlQ34QH0id5QH/zFoU/27hUUMuhrHgz27yRc7kNH8WEDYYl621NNJ7Udobxtkoo4lmMIpi6IFPRzSGh6aHjAkRtlZtl3uS4jDT8+vw3YjZLVXYY8l5ECl2FJQiZncCd7EzsXUNkAbE0/5THsTUIMq28F3JDecbwcAh0HH+oB1y9i34VyauHXQKUEbaeGfA2qQjmUkXfP+GTI9aTgrThopjPaD0zXLdq1Dz6A624gBmIZYugX4Utv0ALzzUIpm1jHSfVMu8vyzbywKCKE8WgXnTpdkGPknr67C1VkYaQdyCg2UCdIsAgi6wt7nfBT6+SkQgmaa1auqFt8PSVbqPlGP3r7qx7zmKj2Kqh63gEMvLUDc7PW0KKGDY29AAP8x9UjKSNH2oAIasnhjfAxB3cozSE8iiuTL2rTBDNF6Szbs7Og4GJn3vXMMjJPulV5LjJG9Q6CcrwwhE/RLwU6MWD6QOxfUA7O9/0BZ6U1vfr98ePVDfqkY3afn8xuIpD2/NlCzKN1ZhirwVqA8ZfRbK/otWBI0TOEnFqGi8YZSsgVcaVUs80+fFw4ZadMvVl6YVxJQFWzlFa7v+COzknqXH
 3QJkvWia
 gba8jWGp0evGyCIqBG424YdSpnoorkGLNSiiM6ZSjgbf8U6ETvZdjaapfIDHc+vCNKwsRe4c7l0S1n6UUCWIlYgNUcTvw4RDQayIRqvdPAa2x7T9cL1G4dAdoZP04YuwXFNf/wvD6y/fnRe/+C1rhyI8XzSeUl3I7mECGVTh5OagmMJMg4jAaZvmA7FSYhjsoFfHS/bLQEaDfvY1q+Wjn5odVW69+l6JV/W2VQ0n/FcN7fFKHbsp9kXwqU8cZ8UBrxKSkcEVv5SLEjQUijtrpnDbh1MLuovk3E3zr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 09, 2026 at 06:14:00PM -0700, Andrew Morton wrote:
> > >> Use an unsigned literal so the mask is computed with unsigned
> > >> arithmetic. Supported compiler settings already produce the same
> > >> result, so this is a source-level cleanup with no functional change.
> > > If complier already takes care of this then why do we want this patch?
> >   
> > Fair point. Since supported compilers already produce the intended 
> > result and this patch has no functional impact, the benefit is only 
> > making the unsigned arithmetic explicit. So please disregard this patch.
> 
> It's a very small thing, but I believe the patch improves the code.
> 
> I mean, we erroneously compute a large negative number then subtract 1
> from it then copy that larger negative number into a signed scalar.

That is an erroneous description of this code.

1 << 31 is the largest-magnitude negative number, ie it's INT_MIN.
We then subtract one from it, so it wraps back around to INT_MAX.
So the number assigned to *_hash_mask is always positive.

> The copied bit pattern happens to be what we'd have got if the code had
> been correct, but the code isn't correct!

The code is correct as long as we compile with -fwrapv or whatever that
got renamed to.  And I don't see that changing.

