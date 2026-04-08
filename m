Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D779FD5F68
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 05:03:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 757176B0088; Wed,  8 Apr 2026 01:03:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 708596B0089; Wed,  8 Apr 2026 01:03:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61DCC6B008A; Wed,  8 Apr 2026 01:03:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4D3B36B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 01:03:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E1BC1E2A03
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 05:03:43 +0000 (UTC)
X-FDA: 84634195926.11.6963E05
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf04.hostedemail.com (Postfix) with ESMTP id 29E1840002
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 05:03:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=s6ylrp4A;
	spf=none (imf04.hostedemail.com: domain of BATV+4d4f7abe5776451c4d8a+8263+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4d4f7abe5776451c4d8a+8263+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775624622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5/qEsbqxOUv5KSzyhq5DLMuZrREUg6mbeIZELe+SUww=;
	b=O6YZszJmMUqWi7QH7z7CTlzeQQmItmChWspfkHLc+3uUY8QOQu21zju0ys2kyQ9BW+tLjE
	IEJ78KDgYEpfXKZ6geXOK287+pk8jG6UjKn9NBb/6LCkTg80jBZXAPwTCrGMmefNBlRWJi
	bVGVclaqEVC9rwEh3x/23KhJjCVR+LU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=s6ylrp4A;
	spf=none (imf04.hostedemail.com: domain of BATV+4d4f7abe5776451c4d8a+8263+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4d4f7abe5776451c4d8a+8263+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775624622; a=rsa-sha256;
	cv=none;
	b=KfVfXYxnNwyBGcn+uPgbda2wusP16+rmCBOV4xvnTnJI7f2vQiOvDxBMFXv62AbZiaShpK
	NFbHq5YBgMKkbfJB1PHpUJqtYd/cKWLlgip7cPG62GWgFhBSEqh94xHHJ/wbFutdFoVOjW
	9TaSGpXo9HsKBxp4S6MtNoo7ehyD7+Q=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5/qEsbqxOUv5KSzyhq5DLMuZrREUg6mbeIZELe+SUww=; b=s6ylrp4Asy9kfLDQpYmKGUrXLC
	89uIj0BTQszIY71WxqqXaqlEOKWSwJMVa5rD8GE5gVB9/eItM5O12CYEKd/uNpxNIQTWh5mPIW6hs
	718SAvy03aXJJbOwQYSvpfTJ/9YEU+91O9N6iQ+YmtyTI3rA2675pRjeG2SBhZkFiJvVPhbsE2zSY
	Moc3JvijJkdGh5ybAJrDeOW/EKbz1c7eYqPhbSsJ1ds8RTgsznD9lzX5PIctU6ttD/vfmnaI/8hF/
	j43CoVI48GMFJeL9IXH6DrBNfI+pSythCP6Vk/Kw0TzP5f5/oRxvEWtNCbtNrmTkY7kfkK+ItQMSG
	W4EiJ7ZQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wAL4l-00000008GcG-0ubk;
	Wed, 08 Apr 2026 05:03:39 +0000
Date: Tue, 7 Apr 2026 22:03:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] f2fs: do not support mmap write for large folio
Message-ID: <adXhq-eEjJji1rcc@infradead.org>
References: <20260406154940.2407853-1-jaegeuk@kernel.org>
 <adSTUszGSlEK_IBv@infradead.org>
 <adWMAzmaHiYzSTzN@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adWMAzmaHiYzSTzN@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 29E1840002
X-Stat-Signature: a7jq7qywt8qk78sxwyutzsq5e7ucdamu
X-Rspam-User: 
X-HE-Tag: 1775624620-438126
X-HE-Meta: U2FsdGVkX1/WOMYdQt5TIMsc1PNEZNCjCjticCuzdqnURurYVpVT/yblMR7ZSWW43TNn04+t/5dsHb50HTAogub0A2cFEBq43tqgYJ9eA4ZzN0WRAFD4XdFZ3ITNqIYWlmgmrOp8FPxhMBTIhsOgH3Bwf/Tv5ZIB2PtXf5ufcyDweiViPBmJ3GQBrmBBSofLG7VbtzksJ4GAptF17wHuOZIQV1VUo4uajiAKhinyl4Ldv2JfvKCfBW6V66bwDN3wEXDEv2Ixwgmgnz+O7oHBJVPTD2c4QjvlgOMRi7/xAtdVBcbUPBW85Y6pr0mWcvJeV0lAvgkihOdelY3rbgwyqc0qSu4v5wMPpnhur30LRp06jbHb6f1sSWJySb4M/Pr7S2L6VLeRbBUxxuOplJgERke5VVsGlzX/riUsqOwyepjNKjQSe/44M3sSeAQFEbk1jKk0VW3hAWv0mri6aN3063tK/C6jPuqjreCrV6dPxuyvleHKoUtD0umX49pQou1Y+75Kz3/Z6WuPHqHM9E1rOwHZ+QbWydpJ+6e1zL1n+vZvJjrPbchN0UVUsWOiXn7I2Bu4CHOu2hWvMRnHgrpb8ltWVw30+34B9xAOQXHbqOIY2DAyWVAFu33OKoBpAdKTqoSHjWDT4n/7IEDxLyOPyiqMKGZ6flxA0Tu2zlwLPV4+4MLzO2kL4kJ8I75uzvpbxP4hwEPNzYofw1AgHGpS5FICPr2/Q5DMgPEzY6bmo5iWewjFgPWHkQUVn0eBCA2bdhV+inGsez/qZma28euiD54+kAsEQt+/YUJ+dVDyTB8F633JYBk+uVlh+M6Z8aKhv7GOeB/8YLFWtkY3wyn/mug2J1QbxpW5inQIT/92aFvXvsE25/JslAafxMwipC58zP+fTUQVipfZB1Tt+nwQHmXav62+IbKM2DmqhVsW6HzxsyYbVs876MkI7uTs7m4sEhQ1Z7vz62SLsJorDJ7
 qnbzEnRN
 UaIBYjGdYC9tR54VRgo9Zd8NfnyU9DPFvONexJouroNE/C3webmue2y+YTzDREqtM21EOitQOGYPn16x8jGXErxWdzSa2LquhbfeLJQSUuEv+jLF8doi4hD6y7xpZcgtGw8XGyMzjVE0fl4p4FSqwJgW+m2aVCBjkR4TlFIe78MvMuMfC5ihqNmdMpVqsZqnAd0I9SDWVSxT8A3EsyZqb1j1PxYa1k6vZ/+AMkpoiYRMkY+BztKwrT2SICyoQqEadxG7AFKWPsCyMII2HstcvqQU/pf+ljyvxLKQgb6RP5uVNMOqE4xToBZ5pyv66BzVywxls1aR9NN2TTSrrJeeGxS2ib2mmQUbCNLUEZqSKdu+y09Kxp9SYNBqftOpDwMHijZKJQXxGf81GiExiZozU8+wG16eJBLNWPtbb5RJ8QND2q4OKaflTbI+nnFGuNwATcGcUNzer38S4RWBNsISi5AXt/C5va8JIXIf2+7diqklegFfbwywQOMXBtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07, 2026 at 10:58:11PM +0000, Jaegeuk Kim wrote:
> On 04/06, Christoph Hellwig wrote:
> > On Mon, Apr 06, 2026 at 03:49:40PM +0000, Jaegeuk Kim wrote:
> > > Let's check mmmap writes onto the large folio.
> > 
> > Why?  And how is this not breaking applications?
> 
> Since we only support the large folio on the read case.

In general spelling such basic out in the commit log, and even comments
is really helpful.  I'm curious how this works, though - by the time
you read a large folio you don't know if it will ever be written to.


