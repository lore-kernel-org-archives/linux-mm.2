Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BE05CCF9E9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 21:19:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B3FF8E0187; Sun, 26 Oct 2025 17:19:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88B028E0184; Sun, 26 Oct 2025 17:19:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A07F8E0187; Sun, 26 Oct 2025 17:19:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 687388E0184
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 17:19:39 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C799E48509
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 21:19:38 +0000 (UTC)
X-FDA: 84041532036.16.C1368AB
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3AE50100008
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 21:19:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=U2p641UF;
	spf=none (imf05.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761513577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vbgQSpwLiN23ZFyAT4xgeAAvMjoXTalRrJzies8wmYU=;
	b=WOszHnILqyHzec6h5F55FHmlrdI3X7XBIBPVuzQtXv/KroT4xa0QITeO5rfMmxJg20OeKO
	b0kN/Ja2GIT9ZPMc6P3bw/cvJpVMZuslvqAhur4beTj+lxN3zkfqAXjxlPzb9k6x+zWNQ5
	g7jMDANK7PBdXFvhY0CQygQfYXFDwLM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=U2p641UF;
	spf=none (imf05.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761513577; a=rsa-sha256;
	cv=none;
	b=6oW7Xnai7MloRv5XCONVmzuyie1aUgZ95Sfi/PAYcNXgMc1L42AHdizh58xT7WOFOg9lA0
	LdH93XUB5rMpQRmYz1WHXBo6KM5MKtqUCSOzCF8ngTUs8C1+QakiWCtUAEHfxRAyvsQZc7
	2dmg/El0QH+F94A2zRegMnPByU9gTIY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vbgQSpwLiN23ZFyAT4xgeAAvMjoXTalRrJzies8wmYU=; b=U2p641UFAqafJssWfbrxUlfsV9
	+ALoEky47nqLTJU069Bgi1LHB3KG/HkbGEDId1PBFct5nNGL9Pw1sOF/Unh9a25ymrz6266A9SZwb
	J1fSGMzgQc+yITlbtS3HLEx5R3YSy3uzlBlt36zL5ErBS3CA6749Vg9UjEEgOaemqkl/fYsF0CLBy
	d6lAVuVFxRaKluOzCxUZ5yBZI053JPPxhMUKGn5ChwCbxp6H33PU6rV3c1dxbTMKXic90iGrWHG3O
	3lAxmdI+G+IElxmJVdxQmwWWE4hqfNOrmOFLgD31AxJ1uoiP+NSYmqsoIh+nmXFEZePzLAtzj8Qe6
	cSCkb7HQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vD89A-0000000HQQ6-0aNJ;
	Sun, 26 Oct 2025 21:19:28 +0000
Date: Sun, 26 Oct 2025 21:19:27 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] slab, block: generalize bvec_alloc_gfp
Message-ID: <aP6QX_gNpY9UDtub@casper.infradead.org>
References: <20251023080919.9209-1-hch@lst.de>
 <20251023080919.9209-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251023080919.9209-2-hch@lst.de>
X-Stat-Signature: f8tu5t5anubk3fkra5jaxgg8fsbj4dg7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3AE50100008
X-HE-Tag: 1761513576-79514
X-HE-Meta: U2FsdGVkX19+wkj8DC6X92Q/EMDa4HEUBKqsNTPap2SiA1vXGiyeqFkZKwslUmy46FYdLT6hXqBYRT8bDDP+n58o/B6jJzaRf69MuOegx3lTYjQfUxSRBIgv/f0X5E0D00hfUn8hvMOAd23ZTHvUdy/vyep8oTxs9x/k8tuVhvyx47gFU4jmVptfwGnQVluUGk4qAk0Bc2SCZXbFklOSqnw+6ALnKjz1L/AzUHsFpsmON0fTBQwfECbE4nmzriu4xSmmxBm1rLDd94uYPucr6fsvS7sek0Z02JeWQ+qAiUxa2cNi0tiSLU0GorzwKVA8+VwRXT56KSUgO1lK7T9vHZMNOa/upAAMCI1/a3iJ4rZeh26CwDMgaB4kjXsXIeK4WgzPBlpcZaYqloRyG1OoqC7W8/Z4CjeQiuJSsRguRldSo9XQwZN3rRppsqgGMXM2HNemj+V6znSjtlilXd9xOV408kOI4CVY8/E+7Qfol0hOiQqzmyEPtnqPgcbBjhpXBmsuWy4N6KagWxYl4bfUjD9xdukZYXMLjVQkGRIfb2aCWEVLu62ToYAgCOK/iHAh1PYjwCAVx1BNdSbVa5c+Zce6n8MqwPzH5+3+pYYSj5T6zOLn4YlL/+tYNc1N5AS9ppS5mV7w5VR/0aweD0ubcmTjJCaSk4jL8v4pV5V7qIajy2KNRO4JeCjE4N4yB7YZUDUo2T3Yev33PeKsDb6LpB6ReTvSoPIdlwbkQJFzI9VHXuncULWB5x+I4/iiZQbGTny/J9KSertCaCUlHpOT/eQJ1O9ctN+5O8s2OX8n3NagA+W6n6hk9ENrFeB56p0kkx6+qtSeK0ksuPEKcc458MsdcWE8j4H4DEQYP37hvXaKjTkd1S34Z0cH2pXRrVoeir8Ew5LlxEnnNlBi45deYZyE2XCfeJZzydODmAfJ3JskAMAkDSTS/KjEeyC056LEtbQPNTIxs+WY0yS5YbD
 cweCBDAe
 4GbjZlVih+7rMuvt+kN4EwaDqnuRu2v8/JTSE1EtpicswCE8Hee5/ovq1Zmrp0t6KiUgij1vrhrGUcWdUD6s37nPyxh85EvRNPNIq5cQLfwDhfNRAiX4YOUEgrdpvdV9Up52x06obIpIJTFT/zgEFJgULlAySKrOQtQVOHi5LjM70ycljWsfmC9gbOI3MtwtKCYpqeD8MyvIAA5HFVwrs5KP1YxeVb+TJow30vkbaetwK/LWyvWldgay3Zw+8DoyorI5kIziL0ZxOcN+a73LD4uzg3Rx3m1WGKA9nh2L+UyJJfiU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 10:08:54AM +0200, Christoph Hellwig wrote:
> +/*
> + * Make the first allocation restricted and don't dump info on allocation
> + * failures, for callers that will fall back to a mempool in case of failure.
> + */
> +static inline gfp_t try_alloc_gfp(gfp_t gfp)
> +{
> +	return (gfp & ~__GFP_DIRECT_RECLAIM) |
> +		__GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN;
> +}

Comparing to the kvmalloc code:

        flags |= __GFP_NOWARN;

        if (!(flags & __GFP_RETRY_MAYFAIL))
                flags &= ~__GFP_DIRECT_RECLAIM;

        /* nofail semantic is implemented by the vmalloc fallback */
        flags &= ~__GFP_NOFAIL;

it's quite different.  I am by no stretch of the imagination a GFP
flags expert, but it seems to me that we should make the two the same
since they're both "try to allocate and we have a fallback if
necessary".  I suspect kvmalloc() is called with a wider range of
GFP flags than bvec allocation is, so it's probably better tested.

Is there a reason _not_ to use the kvmalloc code for bvec allocations?

