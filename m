Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56209CD13DD
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 15:58:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B83B88E0021; Wed, 12 Nov 2025 10:58:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5B958E0002; Wed, 12 Nov 2025 10:58:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABF7F8E0021; Wed, 12 Nov 2025 10:58:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 99C6E8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:58:26 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4267C59945
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:58:26 +0000 (UTC)
X-FDA: 84102412212.22.3722F1D
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf26.hostedemail.com (Postfix) with ESMTP id 72C3214000A
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:58:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf26.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762963104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ho5hNfj63MAid7pDu8WP093tyXXvmsTsmoZKI5R64nA=;
	b=Fb/t//+knIg/Y13ov1lTTYnQfar64+efRg/lWjayDMxM9DcbPijcNriQRy8l98/ezkClLF
	C1KZATqt27HVnF6dMGBD40RrolzThywOiMyLIwhZ7AioHmB9o9R4CvEA8ZbdyyKpXALHUW
	SPzVVxHzLW9sTxdCdC38CIMz+3beQMk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf26.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762963104; a=rsa-sha256;
	cv=none;
	b=eDJOrvs5sC8cMBH+I1Y8GDNgcJvdH4UI53isAwz8SoYbQdeRI2UO3tAlv9mUnyuCF+Or8N
	3ja3SttKRvUMc9aKOAvC43B7mOGXIKNGI6raRW9pZ5FpsFtMRwEfdOlnCA796gnLMBXtr+
	F1bTN3/zdqsoltlnFlwgVoTPz8BJueY=
Received: by verein.lst.de (Postfix, from userid 2407)
	id D0ED96732A; Wed, 12 Nov 2025 16:58:18 +0100 (CET)
Date: Wed, 12 Nov 2025 16:58:18 +0100
From: Christoph Hellwig <hch@lst.de>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Eric Biggers <ebiggers@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] mempool: add mempool_{alloc,free}_bulk
Message-ID: <20251112155818.GA9179@lst.de>
References: <20251111135300.752962-1-hch@lst.de> <20251111135300.752962-8-hch@lst.de> <c691c9c1-a513-4db3-95f6-3d24111680b7@suse.cz> <20251112154754.GB7209@lst.de> <4b72bcad-5174-49c7-ad90-63a9c312df0b@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b72bcad-5174-49c7-ad90-63a9c312df0b@suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 72C3214000A
X-Stat-Signature: pobbze1h1tkg9rf6aixpp4qkfsgdtduk
X-Rspam-User: 
X-HE-Tag: 1762963104-25327
X-HE-Meta: U2FsdGVkX1/6lRx3fgZ1cTJX0dJ/axo/+iOWx3SBlH1EmtmKra0jSze7/jcUeBsXtnYX90UQf3Fq8NH0IyECS3LfR/ihzN6iesAX1iS+oW8B/XDDCS/TWUFc/Jw15/xA4M19CcUI4/DBka1ebHboO6qO7ic+0JfoiIYEXNZ7I1KRyXgZYIQTiW9f2r4O1C/DKdTEs44Dl/WRU3nkTUPi0K54Te0rcI69xqOzT95zz7jMLEcLgbBZYE13ZXQZzscL9xZtO4BmbNux5vIPL/tOkEzOvLMIbEzPgcNWalD6R91yMXHdSS2phTGj83UYDAC+yuzm99RSLYEEFhceWSkswmfvisbonmBRO9rhQ27s8hRRVqRkN6KtZh5CRb+dsrfbriaSCk484/wvntpsVhBpLhoEt38b2UllnrfARpPzdL1d221HeplFaNculeVV88DpCDwxvL8HE9HNq/l5iTn4cfr3nQT9511FAvKgQNvBAh2UJz/Eva7lfGYfI8mMfj9vLSMgcQOCL5jCbcRIrNtWtlVPWVeVC1IqJj9F4IFGy6skL7BwwYwfLfNuHaL6H4nZxcb+NDRXMEU2y+6i2y+r4WwAXFjdgX6cwlHuNT7eFKAE1GxK13s87bIVXtAu6FJVJeZM2fVUnQxuGVvEbF1UNTW9cozuHP9ZjnLgtGksveZjv75e9vIYQadpLieeYbQOHYEXc6cLQDzzBw2eQKkDVwFbSEu2rDvhgAnZDm79baZtyJGpafnUZvv1eZG9dNsBlvHfk8xnRiHJ5Pkl52MwelhCoeaYIpOm464eQ4+MgHovRSTtwTvNPvWol/Qc1vvMMjHpFn53luksk5OVVXkPRgoFSaKQ+j43Q74DGg1mC8MhcaDHTp5qslUn/BXroJslkG+/xhQcywMcv4CERyY4mYvqD2ThsDam1mAq5iJU9GjR1UkyCfAjwVWXjDIV3s7Qw6PWt7UizfMptuB8jNO
 4Cz4CSRn
 HRr1t4kDGcQnx4bsn8WXCrtSzZPh+pmQhxjUxmUAEnRcsg3l6L9Y1mxRmjgnMPTSbWpSWTFvS60c3rNkCAF5hsI4rK5PQwOrWOwB12C5j7Ht6Hi9zQI6z/yoAouOVAijXZL3onnzfTBjI6fI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 04:56:19PM +0100, Vlastimil Babka wrote:
> > and doesn't leave random holes?  That's what a quick look at the code
> > suggest, unfortunately the documentation for it totally sucks.
> 
> Yeah I think it's fine with alloc_pages_bulk. It would only be a concern is
> the bulk alloc+mempool user used up part of the allocated array, NULLing
> some earlier pointers but leaving later ones alone, and then attempted to
> refill it.

We could have a sanity check for that.  The cache line is hot anyway,
so another few NULL checks aren't going to cost us much.


