Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8CECCD5BD5
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 06:28:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32B156B00A1; Wed, 27 May 2026 02:28:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 308326B00A2; Wed, 27 May 2026 02:28:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 240076B00A3; Wed, 27 May 2026 02:28:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 14FA46B00A1
	for <linux-mm@kvack.org>; Wed, 27 May 2026 02:28:35 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AE7A5A0543
	for <linux-mm@kvack.org>; Wed, 27 May 2026 06:28:34 +0000 (UTC)
X-FDA: 84812220948.15.E9810E6
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1B2D440012
	for <linux-mm@kvack.org>; Wed, 27 May 2026 06:28:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=nS7j8vx2;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf01.hostedemail.com: domain of BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779863313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ka/9L3mGRr/AbgLqT0X1N/LKODg56XkQXKLxkU0UHzU=;
	b=x7X6up3brqE8GzzGjKDS3kmBQsC+aKrAY5T8D/yW7t7k7pSt8rK84S2cg65QeJGZMU7+Ca
	o6iePvV47HPDq0JkLurfkgjnkCSjshlT+/gFCjbWrTnHD+99bZzXz7yduuzzaduEp/Bchs
	qDcDLYMOE3uB8QLmmUrcqWsfJRnmXeQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=nS7j8vx2;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf01.hostedemail.com: domain of BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779863313; a=rsa-sha256;
	cv=none;
	b=Ed/3PUZw4iRCGuvVn5evZ4bzoS/QV7WWSgCellahmuhOYRRdEGi0o91OhYz8MLNw81sPX2
	OLOUJ+UWLk6+Bfav877q1SJLKcO48p5XyCYzAnPsGad7J0Wdhl95uMF0jb9zc0lbPyQGSE
	ZomlfvzKDk6t82TcVnGQRbeeAWQ8z7I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Ka/9L3mGRr/AbgLqT0X1N/LKODg56XkQXKLxkU0UHzU=; b=nS7j8vx2eymE0ZSZoDXuT2yyfB
	/S4PFwuANnKUoJp7Giy3+PPZL2gSAx1o/0tYaYdwpEB5m5NxnKmi0la7rA+Kdjp8Tg0DTzC3wbrdb
	p0SdCWxYoxDL4R+uCloO+ntIkscwqjOUheJxRyg6k3URoBMbJg02NwWXHUDRHOhOsoUcznSjqCr7R
	nzTIsYlAv+FvrDCQTadRi0C0ba3pnNgQPJvhBxUeWgi03KEwJcO3vfxYgKtesqiYn6VhwjAlat7Im
	ccYCea5H39rArdAXYTH8KgLSGMAdaGm9wmifOC0WrWvLVA7yRspaKDM4ho8hHu1TqWsRqsxOjMKHA
	XhyVjWPw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wS7ki-00000003Ozf-3Lht;
	Wed, 27 May 2026 06:28:28 +0000
Date: Tue, 26 May 2026 23:28:28 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Theodore Tso <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	linux-f2fs-devel@lists.sourceforge.net,
	Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Akilesh Kailash <akailash@google.com>,
	Christian Brauner <christian@brauner.io>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
Message-ID: <ahaPDHiXcJoVShPv@infradead.org>
References: <ad_HwhzlNPUEKQi6@casper.infradead.org>
 <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan>
 <ag_OVwPF49LSZ7rz@google.com>
 <20260522141115.GA8258@macsyma-wired.lan>
 <ahCNmWbcd_2lAJyk@google.com>
 <20260522224108.GA18663@macsyma-wired.lan>
 <ahTzHyHBL8t0iNBR@google.com>
 <ybmbjekuvzmaw4hmlxd7nxs546dqtwmxqxwyali74d6m3u7tat@b4q3japqnhrl>
 <f4e521ac-2381-49ca-8dcc-3cb3cf3ffaea@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4e521ac-2381-49ca-8dcc-3cb3cf3ffaea@acm.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1B2D440012
X-Stat-Signature: 3mj9c4dutzyac9xf55aqz1kjuk6pi4bw
X-Rspam-User: 
X-HE-Tag: 1779863312-330868
X-HE-Meta: U2FsdGVkX1+KTi3QREholQCpFuuJCAGC6vK5EQNZ13yjVPZjuGVL8UfvurBdi8VgBtCl956hpvwYVOpLJ6eKUifQ98cQksKjL9ghn3jv5V8R8NcjG3E6S1sMmHf5BaUrGwhfJAcbA340yZ8EHs5B8nmmDN9Rto8qpPrDGdyrFiyfz+jyqB5h12paBWj+Cxjc4pWrGRuuKw7Ufd2M+SxtzTZ8QsYg301V7UZRh1QnI8nF8TM0g8YeL8cHvE4oiN2NmoTRJkrwGKcffdnk+ZvbL24ptle1tYxdetVn6m4tssxVcHGHyyOSMUS+6xL0UY9gj/KzyU949V0WJSI2jaSHDMF3djq6p6QsaNDo2bM64A/7c3M+Qgy5/df2Y8heixQwK8MLOa+19bLbWnmbyKzsJsBzoW81i3e7gcEJZvcv7gLU45qIlPmbAa+NotN6bSZOb1UOpj4v7K1aPr14o6/cSvmKSe3oH0HE58si2AJmdMQiUqJNgdTdJT1lTFXPsL+DZPTZF0MMGgiNbgNunxLtJExBJejHDbXJhhl4bElG8/3CIU1IaXozn4vyNp8w+LUdQDtmluZ4X0TEhFj4lqnzJbx4FG/THpO6On5/3A9yU8hYjTXY0ebCqHHutxZ8VM54ZeC3ai2NiFY77Ek3vktnemNkqgwl2mNY93moJ5ssI3mS4HMAxGN0H/2ajVRwrp0qXdPiMHtjvcQYeu7ChNuYlwe3Y//tZWoLslvuTdKsAWIUZk59jPgvRb9sBHado39UYjcnJlJhJ5q8ASQwpix+F4oZuZFNxAIXJMjTGK7RXGy6vJcgof5nV0T4tWUAT1rC5Z6miXwybRgAWh7es120p4vQX4Bqv7t0dfARg+H3PEoriQqYmtzLulpSuyO5+qXpYRXYcGzFzTvXstiyCxAJXAe7qg0kJ+VsFlRhr29I3jW/xLtjgoceAOVSUAL2CDCACn3RbMeMRfrF+EjKE/B
 yFiuBtjr
 iUiVtkDXW04aY3vqKvoSysYkGfDPerX0cHDvUXNV2Zagb0s8SrZSVtpR4xJnfe6lZcXbpVDCdtNuCEPCMFMQb4qaTYRv8h7PnH0IV7wVfNGauRzpF8fWUkzFcyyaQrXrk+01vVg/dh29ADB+iCwnal0MdklQlQx/2jbGPSQ9ndGnZo4QYkZcVmUWRsM5Hoyhpv+/uhG1HaiaIclMwwbqgeoJXuZKmtZJqxvn2+TWNRFYq/LfyGdhTsxsHXv0mMonaAfcH9tfs/eGiV/hhGEeD0ci5dHOMRTpcbmuJYB9lUaL2jABkEqNFq2SGBm0KNUjsFdPIg5ursFHckwF8kYQQvKlxxtV5iVJPW/6qvBuil+2KflkcMGb0ZDfOuD5fFYpUj3qdXbWTpl0Q1x7KovQRZqv8boLpGjo6ycBtwdPvJaGj0oX0i2ywuHwNlronDnwFKV0P5U7gnq62zPRP6TZHwkVP5hi+AHjIiO29zPoz2239e/rQ6h5wxZu9rQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 09:14:52AM -0700, Bart Van Assche wrote:
> On 5/26/26 6:42 AM, Theodore Tso wrote:
> > It seems... surprising that the additional I/O operations are actually
> > throttloing UFS device bandwidth by 2x (4GB/s vs 2GB/s).  Have you dug
> > into why this is happening, and whether there is anything that can be
> > optimized below the file system?
> The layers below the filesystem (block, SCSI, UFS) is what I'm
> responsible for in the Pixel team and I can assure you that these are
> highly optimized.
> 
> Since the transfer size used in Jaegeuk's tests is much larger than 4
> KiB, how many CPU cycles are used per IO by the layers below the
> filesystem is not limiting the transfer bandwidth.

I'm honestly not sure what discussion we have here.  Larger I/O is
pretty much always more efficient.  If you submit smaller I/O you
need more merging to build it back up larger, and more I/Os.

Which is exaxtly why we need large folio support everywhere, as it
makes a huge difference in I/O performance.


