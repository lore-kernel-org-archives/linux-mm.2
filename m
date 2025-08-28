Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 041B2C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 13:18:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34C168E0011; Thu, 28 Aug 2025 09:18:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FCFB8E0006; Thu, 28 Aug 2025 09:18:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EB6C8E0011; Thu, 28 Aug 2025 09:18:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 08D828E0006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:18:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8076F8375E
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:18:27 +0000 (UTC)
X-FDA: 83826220254.12.C416819
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id 349C140015
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:18:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=AA6aZicn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756387105; a=rsa-sha256;
	cv=none;
	b=bntpuPKCXfWvYz/D009CbCxQ9auFM3MZPKGoMdTqAvD7ngisF/ivMDYg1jHxzoB0yLp0xE
	FcPYABblJU4gO8UM9ddo7cKownwbSAM1sZj2RzWoQxEPxX9maXYlFls0A3lBm6XTYOFlLj
	dDKXiPO8h4IaCcZ/etBlqyLNr0gnpXk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=AA6aZicn;
	dmarc=none;
	spf=none (imf27.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756387105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+vvOf6v/zjtRXt8HqZtrkk44ara5iQUCVMYQ1W1HNYo=;
	b=GmJ4WloAPGMOkD4YSVNZa8h/tOEaJs7euSNxNvdUrJ1VrJKZ096ueB26fB0P3kFgcQFocv
	ea3GX5Q/M9Ei2cJbTtSackTJvZK1g6VwSbKYK759LmjrzpqlJu0zPKTSlmIuzVJdggvPKh
	DwJS1+umZPaN6MpAddhU/79MK2502Kk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+vvOf6v/zjtRXt8HqZtrkk44ara5iQUCVMYQ1W1HNYo=; b=AA6aZicn3N6vtpboZCKputB0E1
	l7qoAXL3SPlXrTrudVNcijrTEh24g4k8lSNmeoJPxzC2OB/DuGI+tFtTWAyN4b5EblAGJE+hVhWOq
	cG53g4C1D6Rh2mkDIf63sKTnmyuR8IHsCUevTJ6ZWVk6ib7Z6rCJ8UQOnaI8Dco+xfqg2nd0RkJeM
	QG9dFdM8LfvG96nE+d2vrE6ZBLVLWmZoaL6Fb4snY/lwjPJRZQCzY8Aid8lgazvWFmQ6NO2dVXXXw
	VK5Bqqz6wWB+w+/KTW9UftbIQ3Cmw1JONy+6OUvVWb/zH1n0Y17hgeXqL/JdrH1LjJVSWH2F4wVIp
	yPVXwBaw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1urcWD-00000009ubJ-3fJg;
	Thu, 28 Aug 2025 13:18:21 +0000
Date: Thu, 28 Aug 2025 14:18:21 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] pagevec.h: add `const` to pointer parameters of
 getter functions
Message-ID: <aLBXHUSRAfdl9_HZ@casper.infradead.org>
References: <20250828130311.772993-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250828130311.772993-1-max.kellermann@ionos.com>
X-Rspamd-Queue-Id: 349C140015
X-Stat-Signature: e7w4dh9strbf9ax3sgxjj745deoocfpr
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756387104-267897
X-HE-Meta: U2FsdGVkX1+0dEBOfPlSKY+gF8tglYUqCXPC2KY2rxVxb7fsZbRYzBkHOMfBbsoP8cdsBU8ebQBFRbmfooTTEti04Xl98MpwAlirzHPbV9DpSUtE0U99W4J/hyFqujQNBV6iAQVCme7dnoPeCBTKPKqoGdgSgHiTfjqEyOggyV29XEudcwMM00X2cOMvoSDkE7v0Vekd5/OHcdhk9MGYSjZvlcqmo0+rHo/UmaWqirLYMs4j5gHKHHsbEbImFdAmjOHcZkOtSpj7DUTacADwaPDDI1vLssucIsMBMJwqLt/WLxZ6B/HmlvAGGKGdWfSrfBo8VnrTVIRVW2YllW1QPeguokZNPsIlt5Z4+CQ3Q8NmkbohfORTFbDMZIWD+jNA3SZ89HlbtP7WY9/1M+e6xk7zT+eU2aEoVAAShkspO552YwnO1iNi09nUkmNmVPJppyrd6Acmg2Q/YKqwqHmDoVsWH2qWkPpo+owYYKG0dx/9a1fAePsCQUA7LK+RD+E5npzn1x+FrZtaQM1pmronz+gKZ8sKQbUwGWGeTJNI3DcZyIR1YZx+P3IsA4Eb7nzSzsiJjODdywTDetfA7yjFClyRRrzdJ3Te54LBB0zaQcXmKFD/FaSTwYst42HOI9Xy3iQjONGUzcBMA/FWQunbf/fyM7n8yNc1b4gJidcWYyNY6ToQcLhhuh/rCdy4Xptbaau5YYnmdPuAl1ULr+Stn45VBxfIfd+up1fN1d8BlUKbmu9AHVY1DEAysPTwfANNykE633t+8yAPcS1nn0oemLHvIIxMyTTyt7+ss9vquuX0moPPLquTmB4QfKgicr7nO3Z48xm1b0I1JzhE5PU4a5neTlPxh66S+/qyOSlN0iv9duy2NDxsPAzD0Tbvg9ceLW1tqA1A9MKRairwAEZIDtdZ+NodhTXnAokH3wiKi7bT6oIDm8cy96gfQPP61KIds4Pm8JneDy/vpCjU/Jo
 SQhffXnh
 mAoYW5ZvlW9fL8QQWV5cB6xgA/RAFlOnLdwLMo1G+ml+egX8QB/eox6qdF3M9Cyn4gw1ZulGl94jBdbSlL1POS95WZdqhp166Es9Iy5tO1zlVkV2BQ9SELkEsarAqwYs/OsDG/N3ECbYwlGqsePeLA6P6kMpCzf/QHgsNR+ovyfexmvejq93WiLZ4/48RqDFYHlAc+yqyRqBwebTc6n01GRtvDGPs0AuI306lKw19z6ksjZqfz2njajRejv4eiEjznsMox8CqKq8+xl1FvXaz9S3n2w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 03:03:11PM +0200, Max Kellermann wrote:
> For improved const-correctness.
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

I have a pending patch which constifies compound_order() and page_size()
so you needn't bother with those.

