Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C36D1E7DEF2
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 15:37:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFE8E6B0005; Mon,  2 Feb 2026 10:37:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BABD86B00AD; Mon,  2 Feb 2026 10:37:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB7B26B00AE; Mon,  2 Feb 2026 10:37:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9819B6B0005
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 10:37:26 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4AF321A01E4
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:37:26 +0000 (UTC)
X-FDA: 84399920892.09.A9AF885
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0CD45C0011
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:37:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dlhrecD4;
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770046644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/uCp/exN6DEwJx592/tCWD5cY1kAqIER2LuZdB5bgd8=;
	b=BCsVTO7CBTe8RLjfzCwITsnvyHdhyMpEK+KGvwl6JWbGxdLwizhrn1KGLjigxyjTgXkF63
	3yh6aQmajK+puXhSkROtKB71kGtd39MUXQ25yuP79pEBoMHj0sRPGKnYf/G+1LoRqdebhk
	aM+8TAdUREviEsmDxlLuyodkEaRth8M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770046644; a=rsa-sha256;
	cv=none;
	b=uufJHwJQhCFMGCUOcg3qQtQB2LZZL0R/a5hORbj2j9XZ280kM/KGQY+G9Bw8PhhPaVsNCP
	jJQgTCqFIivqfSpO8akViUuJslBARClTlcwGRij9bIBNofyrEJNfnQEeshzVfPQyDGtAUz
	sAOvopXyTCffFjY3hvOcJl83XMBC34Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dlhrecD4;
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/uCp/exN6DEwJx592/tCWD5cY1kAqIER2LuZdB5bgd8=; b=dlhrecD45cAVB6rv373oYwzxRf
	JaXqPrlI7Tn8x5CXZ4T8cAGCZakAqeEiKHuHLG87y6/9+bFzS3r6EOKc1cSgRQp7scMfb3893LjwF
	XGlZ4KaJHcPmmQMh2EPHZfO/D80+asZRff7oxvineJajgkJUURZ4/DEls12IQXfAq7dxwK5DuUT/l
	vm0GwCMCrFyE4DOrEe2YV3qia3LIsCdSVfSdNkmdBvITwohDajZgTbxo41e/rH14floYhrwnw/ves
	g0U8Ggna1Yv2FRDOepi/yLSamOTyChxWBuKHpkhMobcgFE+Rmc2eJzXfAojHK8lMketCxwKNcP4FI
	RisxKQBw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vmvzN-0000000Gh2E-0LXV;
	Mon, 02 Feb 2026 15:37:21 +0000
Date: Mon, 2 Feb 2026 15:37:20 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Ingyu Jang <ingyujang25@korea.ac.kr>, linux-mm@kvack.org,
	akpm@linux-foundation.org, david@kernel.org
Subject: Re: [Question] Dead code in copy_pud_range() for copy_huge_pud()
 error check?
Message-ID: <aYDEsAWxcdU4PcvM@casper.infradead.org>
References: <20260131172854.3370590-1-ingyujang25@korea.ac.kr>
 <20260202152839.221116-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202152839.221116-1-joshua.hahnjy@gmail.com>
X-Rspamd-Queue-Id: 0CD45C0011
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: xgji3p5jaika64eta7rq1gadhc48ahp4
X-HE-Tag: 1770046643-440223
X-HE-Meta: U2FsdGVkX19TEOTZEJxtr+4BM0veT8hV4xfLdna9nTUgSdxryd0zCxgo48rZo6R+5tSko3L9X/k8vfawY40/uuEmqddOLg9bZ20oARDWAmsoNQYE3zZQM9RxysJY1/HqjDCzADRYE/OrR+OY8RmxUO83ud9OhKhDzAsKrT4sdIoYFUzHTtO1FWkgHElf0/GTI3ZfZpZQMMThpa33pE4xB3UJxZQCyImg1gz75tM9MALTOfm8BJvif2i2ma5eSqmtXD9D4NO9up0yzerCKj3YUtguemwEmJalAuNnGGRd3ISztQOIgUXWt8wB5FGamEn5sPcqrlugWyiTjU9ZGZjquHgdnkRh4ZVlVx5wQrm8B+Q5cVmh25tDyYnpzmip1RCH56QVY6kephbfsqMtpP5EieQVPtZSnLwgtxKuq24arTeloQlLFsOIeis6yDoSARWJgAXB5ji3QlP0WQQk7BsEIS9YPNT6ubcIpaH2PuUmoIOy+4/uHUaYRLC18vpVXbxBgWv6iOlkTqz9XFQ3ai/h1Cp9jsMWdKerYgGnlqp8CHVT/LHH+w4wGPt0yrI+J5iZs4DZnJUV8AUeLXsVJuYhSsTA8n+sqO9WQFpwVXx5JXwMw9cQFavc/cyevSqg3vQbgznRSfv/LAtBGEB5EOZ/iox8muxJOPpwOFhPECkypHVMU3YhJeofJBNtYpDr5vb7nXoy5oUTss1iUFL9ZZUDcmux0rYuwrZjF0J0nRXiVOA5tileWXABH+39rL85iqfED6ZGYbBtRClzcle6uu/vw7VMcucUnWZjbeGMhPrrqUq4D7OTxJPdGhaL330WAA0erRkZoI2v0kbZ0D7RInJhWFleHBie95Lip5Z72Nt+Hqjmg3nF/MYF2tyAjy4quQ2AcwXVNCtr46CzFhaeALKbwbXYYil5MkoGptLfl9LynwEvxzs9GSqK8ZVaohrMnOdq3Mp1FTNaaZ5mDQikOfU
 wN8LVTGz
 3u7cLXneNKt3dkIsmQ/entmAaW2ptuDJpzrAGpxQOnJn2Vy4KIbVoz/xVUr6fwinscEowp4NxoYsN5onNhmKjJ46r+SvihtbyGtcHPd+1BJp9tT1AHPDjgJrMX82y4ebmL4QVDvgJ3tOHazAz+kohZn68BPRn0SHnRrmloHe3xMrR9CIO3nhqPvRxRojS0G6ia44OiyyKA7fnsTHMPAT8EHdhPJMRfglWBmgnQpnrXqEMy7XhaZoWvyu6mnAD3/Sv6MlRaEPbYO7o+Us4Rxdnuw/e7lty6pul411y0nS9a9YeIUZZ2fskpoqtYHf+9BTjVUrfv+Nh29FMNFKg+XT/uBfuFTC4VMxxDloM0798Y+YcWdAOsoVji6JjMdUxSEESLfpitDq1GiTL9uU8c/qPTZQo+Md0pgtS5WHc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 02, 2026 at 07:28:38AM -0800, Joshua Hahn wrote:
> My guess is that copy_pud_range tried to imitate copy_pmd_range and added
> the -ENOMEM check. copy_huge_pmd can return -ENOMEM though, so it seems
> like this is what was missed when copying the function over.
> 
> If you have other changes in this area, this might be a good candidate
> for a small fix-up to be included in the series? : -) The whole if
> block inside pud_trans_huge(...) can be simplified quite a bit:

Please don't encourage people to make changes to mm code when you aren't
the maintainer.  The last thing we need is more tweaky little changes
that need to be carefully reviewed in case they have a subtle bug.

