Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B3DACFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 19:20:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC3146B009E; Mon, 24 Nov 2025 14:20:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9A596B00A4; Mon, 24 Nov 2025 14:20:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D7956B00AA; Mon, 24 Nov 2025 14:20:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8C2256B009E
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:20:22 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 63E90594C8
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:20:22 +0000 (UTC)
X-FDA: 84146466684.27.B2094E7
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id CC9FE20009
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:20:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=a8a9BFrp;
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764012020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fwyBdQ8S3hBpJzyG7dUQUraaJtfMXjgG926lfpSXbdg=;
	b=SZ1/S2r617GRGugorSh9vXk6TMpjKL+c5A+4hundQG6jx2TRwQpzMbr4+vdA3/meRHDoAK
	sb+xZ2lFJvDdGN0o3fKxbJqmbR/HStJNpmO6A5+Iz+iMchJEaU4/ttcI4rrq23XThl+b1B
	5KVD9K60TSELF2bppuezj/XlRhrKPbQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764012020; a=rsa-sha256;
	cv=none;
	b=nxcsJmP1nEdzyAZNQ2Xb0UWOIn/5OirwjAW0R/mVmsUjciZ/0an9a3uaFaCJQZZ4JWCuXJ
	ZHnpeOJHYagL5p1atHZIDwEBQBYvP2MUy8kWbx2SFxqAObQT9D4azcij9E8G6J8E9oYXQj
	NK7+kukxLvdRVkRzyUQdI7s+tsud38U=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=a8a9BFrp;
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fwyBdQ8S3hBpJzyG7dUQUraaJtfMXjgG926lfpSXbdg=; b=a8a9BFrpFPXFUM2WUbySkshtR1
	aecylyHZS2IK1wa9T4dHbVkA8NNbZkwFKYTJCUJO0CIpKECnlzxB/nhFwpp8dSf6Hw/UY7z3CRAtG
	LETfvdIda5jF90hgYRRXWT+6nmJDIarY5NGNt1jJtg+0cQPuPPhaFufgbeIDqQPvTdy6ocdkbwy9y
	RV+bFZNtSwCZ5mXNjAVppf9PPRcAv5+4JKKMkT/avvGRFgj2OnB1yNjw2dxSbzZmtAwwnfKjhdzKi
	1rJoUy/d6lqxiKhEyAZpzeGngd8Mw6bmNFL1QCdjnZXrguevBiW1D19SK0zx/NOmOF5yjtvZCUR6x
	G6Dpar7A==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vNc6j-00000007PuN-07JX;
	Mon, 24 Nov 2025 19:20:17 +0000
Date: Mon, 24 Nov 2025 19:20:16 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Theodore Tso <tytso@mit.edu>
Cc: linux-mm@kvack.org, Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [REGRESSION] generic/127 failure caused by "mm: Use
 folio_next_pos()"
Message-ID: <aSSv8F_5QYHdqJaT@casper.infradead.org>
References: <20251124191811.GA26781@mac.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124191811.GA26781@mac.lan>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: CC9FE20009
X-Stat-Signature: jqxpofc8tw7k1jb4m4y75br1gxpgy9ti
X-HE-Tag: 1764012019-522849
X-HE-Meta: U2FsdGVkX1/GccaJZxQpvjgqXFNmwrOr7lSwwsPan2hJinlt7/GQC0yKK27Br0NWD6EKq413YUCG7JgJEXY5XL5fnS3WGmgGc5kxwN1fTdx9HN2SRO8HE4x4zjfyfLIxbCm9ZpvZ/yT/vu2gblNOIHPTz2e9p4MjgP4L7jfV80QDw5ZWCgHeYohYoAUlV+wUjwCS1DoI8vzqXDPzGLw/aNN/YkACBzN1d214qWPnaAe1ZEy5+e/jJ2vWmnHiNq9mwku7XcY4V+kJ1SQ9PxByZguBH3SF2erdmgFlf1fP2li2zbJqblYmtpRK47we5wWklULNAuGeKXWYaiQuWLXwI+zrBCu33dU+CXK5+UqXQljpGd3d6EtP9BQuc+DJyRg7QCMiscsxxTcAAmocaXmUjrP9xV6WLJumLdBq4l4tJ+K7eU9BgXUsQEVCocrvo4Cw0VOmJVCIq+JMO6cE2jlRQ9Pnu+rHPQQt4jV2nFYG+QQjVIiIpLEoFIKy7CcLODPt2MVaIT7Eduiqcrxm+u0ZOWiIIhwO0QmuLOn0i+HINy8E7Fy+LVG4J0rZN47zIerO8c8z0M4XT0VgR8IjvPaOIu06sl8X/stSoOkc0dGP1D/aFHsj7aeyd0nULarPUnE4NiyE3n91vtjP00pMe1oOIrfLs+ZFZiv7LCdizlyOIAd+TCTT93pEqJ6PQ82VYRg/m1axyCYoc0EDcDH6UV4iCg0xtCA8sgENJYWdlfuEPE3ubosdFRmADXj8XRGzwmhS8fhTDHXDjzEunwrVh9w4m1pvzN2EQ1Ii42Eh6XtCZWr2bKZUX1CVRww8wFi2JXKE+l92qRzwmBALkMeK5VM0VxkuSTUBjAho6bXL/2ElWPvuB2hCziztqACGyEvvZUlPL5MpLUFFDoLV/yA9bNVyX5iWNs7deQOMwXVaKd7fy4j8KoHBSEXY7+lm7ygXyrnwbfrScY3uW7RLTtoPvgo
 PmtLdaAr
 OYxsb8T4zQwKmspozGB/NWD/xhRtQIRGXsT5fitTxSNNuUb9fYn2h3xOZRWLMD/6oADtbz2G+IIh+4pMbKP+y+T+1x/+Tz9cyvqm5an6DXfh3QWW+Gf7CJKtFvGWjzVEA7SYN+ubXNPZX6XRS1DcT5py1lLx9hfxHH8F7iaHbVSnvBiUNCbqLeKfFZb2hm56hWJspkhmv0118+92NdNGgLGXtvFWSeFSI0zqRwKSvPFcnOXnHzAOjWwF3SxHKxmbwRJ9urRfp77/uvjCx7cJovlRIR0X5UctW+zAoRGvpjRP+TCANzPp5uDIhQEa1pDY1D27bSxPSlPtJYvIh4ZP0Yxl/ck89EyT40sR94qfqAeCKBmsrY7jSRxpRtJNJqwpt0i4L
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 01:18:11PM -0600, Theodore Tso wrote:
> And then when I reverted commit 60a70e61430b, the test passed.  I also
> checked and found that this commit was also causing generic/127 to
> fail for xfs:
> 
> kvm-xfstests -c xfs/4k generic/127 --fail-loop-count 0 --kernel-build
> 
> And, with the commit reverted the problem went away.
> 
> The test logs for ext4 and xfs are attached.  Willy, could you take a
> look?  Many thanks!!

https://lore.kernel.org/linux-fsdevel/20251123220518.1447261-1-willy@infradead.org/

