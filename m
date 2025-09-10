Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2224CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 11:39:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 095728E0009; Wed, 10 Sep 2025 07:39:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06D888E0002; Wed, 10 Sep 2025 07:39:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F13618E0009; Wed, 10 Sep 2025 07:39:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DFE018E0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 07:39:21 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8AC10C0869
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:39:21 +0000 (UTC)
X-FDA: 83873144922.18.FEF2B23
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf24.hostedemail.com (Postfix) with ESMTP id B99CE180011
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:39:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=N81XXorq
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757504360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UvoQZuBKjRdf4ju+FuH0otwFuT1D5FOMetJX2Sg2bZs=;
	b=DASlfbSkSL054UzAoSulvzM1WEE+79YhW2A7W1AWSPJnr3c/WYxgypdiVWSPi7FF/5xs6W
	pdRPcfnwkq8d+JHc+ryUgQl8vDVNIfMMSCI5Jm7wR7c5ghnSeE3qG2JG6gXDjY8kEp3n9H
	i+8W7LpIcf2wVTf+cfBxk414qyKgwo0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757504360; a=rsa-sha256;
	cv=none;
	b=ZzElF52p4XDojaL7oSbaPOVq/wSqej4o4+M1T1CrQcBSBpd3EW1tOeiInUxJibw9ljx7mh
	sZqy/QQkRQccMzBrFx6sBN/Xl6j8Yn3yVRSRwgWpe8/9q+t0e7f4ish7/Lo8HdniepQ27C
	gCkisIYzMLBCRiESRmJB2LU6xasLRv8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=N81XXorq;
	spf=none (imf24.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UvoQZuBKjRdf4ju+FuH0otwFuT1D5FOMetJX2Sg2bZs=; b=N81XXorqjR07g+U8HX3I2YUo18
	UjWpJVdJG7KGZMMMgFyJvU1L5Hpm4YbJKIv47kRU2LD7r1AOIfuyk9foxmp4dS2oNAw0cgYSGgb4U
	OCQtRKnFdga/+4HNKJoAuWUBVHERHFOqVYZg3rzQWpngXx+q6Lh+LKP0HSX9hK+RmfuHnlSJpe2qV
	shYDB2nfRS7ZyG1a1PIreR8hL4xkcFbt3t3SnWG0a3w8ZAPZKr8q2p6iI5Q0RRN4ShjGop9mS6jtY
	F/uPy/zIvSc1nFzc3yjyCwdWQegyF5+X9GnSZH+iB2PC+E5KOcqPfsBFqwPHDigWNv71TGdM2Rguo
	FpBlOegA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwJAP-000000089ss-24a8;
	Wed, 10 Sep 2025 11:39:13 +0000
Date: Wed, 10 Sep 2025 12:39:13 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH 03/22] slab: Remove dead code in check_slab()
Message-ID: <aMFjYbaUaQq1GA4c@casper.infradead.org>
References: <20250829154728.3397606-1-willy@infradead.org>
 <20250829154728.3397606-4-willy@infradead.org>
 <aMFfLqkXcZTNv_p5@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMFfLqkXcZTNv_p5@hyeyoo>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B99CE180011
X-Stat-Signature: 3t3a968q1pszskd4wwajxwoppgw3jzxy
X-Rspam-User: 
X-HE-Tag: 1757504358-528057
X-HE-Meta: U2FsdGVkX19hXFNqehr7d/uWtS7LLl4R6x4KWwZzdPvtIHSwtKKFor08GKV7zdKfxEZeBxdQIKLkSs98zbRgNtUdOQfcbyN0/kxf9Hq/DkzAJA596NgHARCypO5YJiGIE8XonZ5ab5jOW5jHZl2mBe60uqOLyDIHZdkRenA7dX8pCzvfanROITZflPM54CK8/OJytRI6itd9K3dVDKm0ISYWzvYtTp3p2GlnpjolrxR5m5EIOsePmixZrRHedm7nlKxBM/nZ14t+00hphGSP8oWOY+2uVgq+RfTEiw2H89XtM3B1V7lB2nrjpoFeqtDaQqeos4OVem5ZtzTWzhrp8Qc92vkeNoRnollrf9F0B48F8hbkN/auwFAi2hsh0F08Dp3jJmvlBe9b6WWxrGdX7gblE/suBBFw4icvUY55QCpWK1gte4cV3buqnB+ARw75GlUEsvHNCvWt0ZOvmreEDFeCS2wj8m6n4zNBzq+r8kcY1auiSSKx9IqCyMs1EYGlIGHxCXcKQoRVCQp0X11LbBrjazTWjdDyPQE/FrK6jDxLZT38qpXqQbc67TkbiaC/ji4yfqNMxZjsviZXHl+pSuox9FJlDeMJlYJL1YY7WYvNUU22vD8J+KvAoID0bHkQNRfjDfZ/AWU6ETtOgJS6HAI4WQdWtAfQDjt6uLaLjIKorzRp6tBFajZQayGRQigFH3DdiQqTDEji6LwjvNTNOzxYU6RW3YpdGVS39CpLzhxL6Zh4Wg+1eJ1Tb3d0gkfRXT+4KyBfrxjK4Tehs4fEwNKOQ6j6zZNnQtUU2Z6Tw1/8hGn4S5VxOtOmK9dA+IeLw6oc3zQc6JmscmdV+NAa6lcn72VthRpYMZNVP6A+3brH/lv/i15GvadJMBqGplNBzMBNPnUGdbhYHV3gzCi2FPqgdgrgyQOaQF3p1bOix8kjmCuZiCNR3Z2H+FI0q65GOPKUq1Ri0LuBT8LlqZO
 aGLsH+uN
 Oz+hYqNIEcveb+b+D7kzD8WxTOE6ELJJ2YXQhWIzTUUBRqkcbpzVsaP6PuLRY0GcMeQFGUnZ2VaXQgdT9KmCuSCZfzr3xb3AJfgdhBDch4V+2HKXmUhIZ143mi8OmqVe1WhjHwe4ElRUo35snSil8Owm1kAh/d4OPKdN8yO5QqgdmdH5SgTeuDOGLHQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 08:21:18PM +0900, Harry Yoo wrote:
> Side question: if someone wants to (though I don't see much value in it)
> iterate over n->partial and check whether a slab is corrupted and no
> longer a slab, should they convert it from slab to page and then check
> PageSlab()?

I don't think so.  There are probably other objects allocated from the
corrupt slab, and they might get freed at some point.  If they are,
we'll want to handle them gracefully (after all, the caller of kfree()
probably did nothing wrong) and not print a warning suggesting that
someone's calling kfree() on a non-slab pointer.

