Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57F63606A32C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 18:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KGMD3+7C
Received: by kanga.kvack.org (Postfix)
	id 643BD6B05B6; Tue,  3 Nov 2026 13:25:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F4A76B05B7; Tue,  3 Nov 2026 13:25:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50A846B05B8; Tue,  3 Nov 2026 13:25:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3089F6B05B6
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 13:25:26 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A5F59140468
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:25:25 +0000 (UTC)
X-FDA: 85394635410.03.3EB15B7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1B20E14000B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:25:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KGMD3+7C;
	spf=pass (imf23.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793730324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ar8emD3X5W7roqEpkOTWnlmegs5JH/dC0liFSCJECJQ=;
	b=mmpqOwl9ngxeIhuupOiZ6kbPY6JKOLPHgP9t+h1CpXDBicnHP7KVeEoKIN/w82I30loNh7
	dnVeTDsjDTKTnMM8jwoeNMcx118MhrhZws8zHjkuvGLAACaoLbtAwIQQIHfM0jokHF+Z+g
	hWpIYTX6G3hljr7wTAHCz+dmJ+EMhUg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KGMD3+7C;
	spf=pass (imf23.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793730324;
	b=qGfDr8+WebuS9lnFmiCxrgGNGVcjt6PoTwx8YMEkBeeW5FAH1mFgMqDsDdRUoFuzT0oqLq
	5G2zRR/ngbGLSAR+Dh+wVOEqcFEd48NVMh4Np2ID48u1UefK802dPx3X13lLvW3qofZg3I
	0jyOCmIg18g4EueHYMMff50sOdatCAE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A452C6022B;
	Tue,  3 Nov 2026 18:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A5FC1F00919;
	Tue,  3 Nov 2026 18:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793730323;
	bh=Ar8emD3X5W7roqEpkOTWnlmegs5JH/dC0liFSCJECJQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KGMD3+7CdxX59NPHv2j6CKQynclGhHXBE4b2NPPVYth0TxFavAsf2Z1gt/FnM2TOT
	 0pN12WzFLknff4bqCy3kR9qm0laDLWVfFUFkjPyRfmILALQ7U/tZVJY6ChShw/XQYU
	 VzjXphTrdMpcoNDmFBsSQzxnB2CWabqw8wbdf+QERbN6R9ETj08HOgAbyZgsVXZyTS
	 M9U0agdaYGvkEnd0lsjjfG3Zp40yL52eJEpfOYRn2wyhrc+q8qrh/kdRxmbJebGS5x
	 uRkNwSvnoicqQzMz8W94RiItUZUbhD6IX5Lwwj369Z9Zav4KitEKENQ5stTovVj9tM
	 kXiNU6JZfFQJQ==
Date: Tue, 3 Nov 2026 13:25:22 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>, linux-nfs@vger.kernel.org,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>,
	Jonathan Flynn <jonathan.flynn@hammerspace.com>
Subject: Re: [PATCH v9 6/6] NFSD: drop a shared boundary page only once both
 WRITEs have written it
Message-ID: <auonEkQ2Td15c58L@kernel.org>
References: <20261024221152.6965-1-snitzer@kernel.org>
 <20261024221152.6965-7-snitzer@kernel.org>
 <20261103105134.GC7296@lst.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103105134.GC7296@lst.de>
X-Stat-Signature: ncfym51w4h36p1a7wriehspytbe7amde
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1B20E14000B
X-HE-Tag: 1793730323-442090
X-HE-Meta: U2FsdGVkX18LLksSW7/Hr8UATAAZxhK+J+CIgNBIdp74k4WvW/MLaJJwGropaS30I/vOvR2Skj5VAnW2XueuXDoiD7snBCwom1DLMUSuE+Mh4Q/f1olmpLbR3+JEGCzX7kNq4UsSvTZD8QNOzYNE5ec0aT5oXMfl0L9uLp6jFfoGwbQFCuRQGHiub77EgQwxAJv5hXxkoMDd0JhtEhLxQztwfxBnjAe8m0c3EymXE4A4gky1ByKnYZo6ZfwR/VmagHSlAIAYzQX0DQLicYaknKlFUhSyOjEOBbKZgdby0UBV9ExXz5wC4U2R1haipnVltPXWSJTndmCldn9OZzUSQKBiYbZAea4UYKwFU8jY+brAzw4jDlcuTYdYBEuJdQfYKEWHXWzbCW10LVVy+Sep+M/ZMMCz83AyxG394NBl0aadv4QXhcUzc7BaRoPqmNrgAPnEvxZUX5yaSbLHPUgwUzQulMJ9bnFzwQPS5tSqreHZMc9F2htDiBaI8W42dvVmqvfZ8FaIReLY7dxyroQQypU5CibXxm0gDlqkQQ/ay2TMQ/qerLnoX+0VYqhIa7ovy2juUZKZ9xyZa4rYzYMUgcI2SrQyp8nlPWGtxhzavVZg5gbvmNtRbW2RIhNavYYwWmxqR/75GKdhynmnTvTB8PT2p5YiaBjCyKFbAuCSmr55dh6vZlTGLYtehruuq+vkwEHTWhlZK7611rks432INCPi/lepSK6yWxFbslWE/Je1UZjtrRsSVBvsRWVt7rUL0oJiuUlVSvedBo40y2jRUcEArPq6Trk5nfaIgTs6nQD12R3h+qDEfBwstEpQddpb7B7igYFFdEWIVaY9wSvYKhFeAdJmX9FmM/cFnTcjrs8ntS/yVIcSj6M+pk5rtPyO74ZGETK4QFuQ3XrSRf5I68WZUe41eDCTnB89TQG4au2pT8PBA802pWNO2GN8v4bwtfeIDGdanfleN7tI481
 c0/i2ARE
 9uYtIJFs+Q2Z/0vm4satCKNhvtXt1m2Xt7PVk8EhKX2ZNKulQahjC9QXc27VjKtdwaDBAZ63yZ2cRTrSYtUXo/3U7wfv/H4HzzYzUSD/oaCtBbQ1vYDOnSSdK37Ypwt64gt/DBm045o/SEaOO++uikonN7neXyZq8kFIbJOOJt0Sh0dvUEC4cft1fClBF+S/nUblHG3j1+Gix2ZJeLk3Q39mhjjz7l5hq+zdM5QLDjXQvxpIgl8cYedusKj1Yr0/Taei253EQzmk9KRKa4Qf4ZoDnHqu5RAbumPrhH5PqIzTBmUaMyq8zIgQ4IOSAouCJTs8OhNavk+NsexQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 11:51:34AM +0100, Christoph Hellwig wrote:
> FYI, this doesn't apply to mainline.  Together with the complete
> garbage commit logs this doesn't really leave much to review
> unfortunately.

From the cover-letter:

"This series applies on cel/nfsd-testing at 6d13b7f74eec ("NFSD: Map
every NFS_ACLv2 reply status into aclstat2")" -- that SHA1 is stale
since Chuck rebased on Sunday but: baseline is cel/nfsd-testing

