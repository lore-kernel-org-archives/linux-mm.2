Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49CE0C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 09:54:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DEBF6B00FC; Mon,  6 Jul 2026 05:54:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38A436B00FA; Mon,  6 Jul 2026 05:54:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A03A6B00F9; Mon,  6 Jul 2026 05:54:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F0DFC6B00FA
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 05:54:13 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 74E34C1A1B
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:54:13 +0000 (UTC)
X-FDA: 84957891186.01.64B3FE6
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf16.hostedemail.com (Postfix) with ESMTP id 739F3180007;
	Mon,  6 Jul 2026 09:54:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783331651;
	b=kIyqJqBGTvGPsnr6ttsUqe7MPcYzbqyOq+jemVCGHlcBzUtfhPKYwnr8+QIhOPImMZlTn0
	v+4sY7lOj0NAC8m70BWM4FtoxYOuyP3lDy4Tmn440nQh8wgMPUbptmkFRLtxZ6G6DUg5XL
	ONhY2PUmmyDvlmwZ4erZS2Q0uui7/cY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783331651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=deDOyqtk6mxhIT3Ry1osUztbcUyVtnYuIwK6cAFvJFE=;
	b=mjGcaAIIm9LT3+m0XuAzbZaIg17v1L8XRT1wCQ9lOgzfDHh85DV5rU4Hi+92tUngPIS2R2
	9J/50hLGaMKk0896g27UYfx0J+gPXL13wxrAFjO6LV3exKrelFe/U7B+Gb0O6RW+K/TCZq
	bI9skJUUCs8HzKNS4VGJ7xEH3P4MuwQ=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7114168B05; Mon,  6 Jul 2026 11:54:07 +0200 (CEST)
Date: Mon, 6 Jul 2026 11:54:07 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-aio@kvack.org, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] block: split out a new blk_plug.h helper
Message-ID: <20260706095407.GA4420@lst.de>
References: <20260706041125.642097-1-hch@lst.de> <f389a101-2af1-4b18-a74b-031e6c1899bd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f389a101-2af1-4b18-a74b-031e6c1899bd@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 739F3180007
X-Stat-Signature: prffinp1ax4nj53bocp4j79mjqqnkp39
X-HE-Tag: 1783331651-536422
X-HE-Meta: U2FsdGVkX1/FL/uXRP6WzzR1Xhy46ulWfkKBXUWq+dxxTipKId7XB4JKPy8TxIWISRiuq2wFsnVWTIitsBSHRNXuNJGUpv31sE+ZfpFtp0yX8Xmg7aealixfrEbk8e3XmavI9GwNFw4/2RjuAEF0g66+SuL9+yjFn+r4q3Yr4fjq1DHN3tS6GfiJ+lKokce6ozJO83Vd6rw2xS2C3EYLPElomJxAh6jJpah3kVj6mBlGV06zU+ZzCyJHlaAvUJaqA9j+ZBnbrPdYTc1lIIRaeT0KNBHWXoZOkCfCQUmLHFdWjiotL6yXOl/mxz3hUp+4vKa5fzXEm+4YyObfcaHAIeDBg0is6RwyXL14t26SpU2YubaaHI5C+JEjQV0mn9YHe0LFplIb1Gu+b2DmEdyd21/gDnX05n1LeRRHAZVRg8SodpjCRFL2aFoSMEUiT/p4tUcNzCHRVN6tow6MeJ/fr0jzqirZdozXC38thHw4ZwXrkVEVycovQETlUgmOwNzJKDSpM3bbQ3QHbI55S3DnoIM/YF6GrP2h2ICtAtV62zWmBWAEj8VLB+mstn3yk0hl9lIy9K6TWd9dIgPVTnFa0kAxbPM723LGtxXeAF5BWLH5TBpV+7aErA6IXHE7faxnmpGB4XEA2XVc4knwxG37fVgH3JYZneBJ9EuJN78keXkvXwYzkF6wRyThRjnMDm7jXodXsvUDLqYyjtCkWf12IPjQG5f1qP1CR2TIQU1l31iiliM3dJvZkG2RRwsyJ2Lc0iK8DU+6Iyiq9WI5Zr/Ra/3OudUlJN4A+QjhSy5lXsTXvRKYqwShprIk8RAy2mB03k/JqMA43UdRuQM4pPnVHW2UxX03dj//DdDq7Z8RqBJDYdH8SUhTgt3VFyck84cXt5hrcVA9yaRrgnpFtEQtyQ0h4KDRKjv4bhfY1N15xSMQzvUk8cePJZEs69CxJFTaLOkE81VDGS26z0bNtX5
 X9u/wS/f
 gSNq61LrDutcJwL/VT6fSZr4Wu/Qr4Qi8ow/h4njklufSoybVAVmT0BWGR8mgRa+fi3wBbrGpXAITlQTqVW+2aNIMkR6tFVvo9Ql6wREqmZaCYA14C/GVJfY7XUwkhvuWpM5DKHI8miOgeuY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 06, 2026 at 04:04:48PM +0900, Damien Le Moal wrote:
> > +#include <linux/sched.h>
> 
> struct blk_plug_cb has a list_head. So maybe also add
> 
> #include <linux/types.h>
> 
> ?

That already gets pulled in.

> > +
> > +struct blk_plug_cb;
> 
> Maybe add "struct request;" here too ?

No need for type forward declarations when the types are only used
for pointers in structs (or as pointer variables).  They are needed
only when pointers to the type are used in prototypes.


