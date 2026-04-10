Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA60FF36B91
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 06:20:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C4D86B0089; Fri, 10 Apr 2026 02:20:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 175746B008A; Fri, 10 Apr 2026 02:20:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08BC66B008C; Fri, 10 Apr 2026 02:20:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EDAF16B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 02:19:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 800421B7604
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 06:19:59 +0000 (UTC)
X-FDA: 84641645718.09.9A48AAD
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf10.hostedemail.com (Postfix) with ESMTP id B4A0BC0003
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 06:19:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775801997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jcRmfdtFVYFVq489UD/UDFLUbBSdKKIhdmH9YmlkD4g=;
	b=pCwYi/ekWpzzeAJ4U23ZfplslQfTqX7dHVcfMe3MuanXhxZKYhvOslO9bE5zzO8/K2FQ3e
	H+3jcN9ilq2PTMoA03RbwFzfkMLqjJycS5egdFOPe5cWjNOrIAUVfCnSIIw+zQU0HFQtdg
	3HPJmShPivZwzUIguRgz7LgAz7jEQjY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775801997; a=rsa-sha256;
	cv=none;
	b=ci5b7gyY2G8cQS6p2KQoH69V+y6eEZ7/5znVI3KC1Jv5VQcIknSNFtEkZp5ZN2AC1EXvmT
	JIRnjjlaaTtmCN+gOZuO+S9cCsGq+FFWsi7BPLSWe3k3HWy4EsRc+YI/BXqVT/EP0nDujA
	NNaUCYdFm4CSMsHJEddNVkzaCBJJKRU=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 66B1268B05; Fri, 10 Apr 2026 08:19:53 +0200 (CEST)
Date: Fri, 10 Apr 2026 08:19:53 +0200
From: Christoph Hellwig <hch@lst.de>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>, Dave Chinner <dgc@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 8/8] RFC: use a TASK_FIFO kthread for read completion
 support
Message-ID: <20260410061953.GA24795@lst.de>
References: <20260409160243.1008358-1-hch@lst.de> <20260409160243.1008358-9-hch@lst.de> <2cdaa767-c071-4e84-b9d7-1c944407f5bb@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2cdaa767-c071-4e84-b9d7-1c944407f5bb@columbia.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B4A0BC0003
X-Stat-Signature: imxukkannbxfpxdo9xbs9p737s1xrwua
X-Rspam-User: 
X-HE-Tag: 1775801997-902833
X-HE-Meta: U2FsdGVkX1+cT7kMOQb3VVdjtfqgorUwB0TSbPjpFP1U5akfdnJ0KcARBIiblELhmkGPSbj4Rgp8s9DarpeZKK9NpDqEdj4BXNaxIaVZyaezywKiRULUuzJcc7WcpLu8pHk3rLomjyUdHiFo75QP1CbXbeaUxV2k4iZXdNfxGY4+hJpGR5ydVX4flvYVHHC4zZA+HCn2vOUM1yLYuBL6bfqAVgTtef615e8vl5w1zA2tS0UTR+jGIsrQb8wpWhq5nn3TwAxXExTXV9njbBixKyoWOuYykyLaHXXtxqU8F02XXHiUJ1Gul7d98WAaKFBnc851EEnU/yQRZTMZ4hWX0qDDWYwFrNKSzZRJwpBENvjfxjv9PVQ9CJCTMBYadtF8gT55B1tlZY9Oj7zTWWfQIsBG6SeVkBDaGFalmmZuuNGfcz0sAs3NWv3JCz8ou4EsHJ64SZrhn5Jkmuq1NSVor+GC8LnRK7ObIBmdxWzkbD/SucSxs79K6TA9ZWuC6Rw4A79K+d+twxlTp+yBfjK62R063ATPCQpf+HTEDCGHGhlMc/eoDyPYhRcYfKzRZN7JVurvg9pghroYSznaMTftqeGFOj0fpoRtrh1xS3OPM9MMrO1vHikpgl7AKFUgwthiSg6WzWzvXEk5uKkZeOOwNSu21vDpUiIjjYbx8ZeNqtbr2m/RMXnP6+tI00kJifVBb9ZC6Nyzq8gRviIqRA/olN3aDjm2FWHyhgQKMZM/brTqA2jo1j5s9lyQ2VNc6RuPDOK4razyPJvy9WMtyVLtmzyVZzFdxxi88bd3GFCzD0Gd+rr9ffXlcLDzdiQpX1KqQIS8jHNpTA3komMh3Je0sWgaByA1whjzRU4lySwz3P8/u5WbkVBf+X+010lPgBKylwmFsUc/LALfq83OmE0P8LTTpeJHWGyyPB3DPQ4BVIzHGgeJWyHe+n1sGTzi0ebpheBNe1NbCruU+A62eVF
 bSwfEUFT
 U7Jd8vMr2EMMcza3Wwd2o1g/FdrrGQu/krq7A6u73V+3as8JuDdwlPvazuFdT2E1dXPGEzi6j67525XR1LlFHGXyhTqO5p2SZ3+XqaW7rgyq92ZY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 03:06:47PM -0400, Tal Zussman wrote:
> > -#include <linux/llist.h>
> > +#include <linux/freezer.h>
> 
> Why freezer.h and not kthread.h?

I needed freezer.h to try to make the thread freezable, but that didn't
work out.  kthread.h seems to be pulled in implicitly.

> >   struct bio_complete_batch {
> > -	struct llist_head list;
> 
> If we go with this approach, we should remove the newly-added bi_llist from
> struct bio too.

Yes.


