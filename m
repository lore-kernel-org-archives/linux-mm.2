Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AAFECF6ABF
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 10:17:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0FF46B009E; Thu,  8 Jan 2026 05:17:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC7116B009F; Thu,  8 Jan 2026 05:17:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FD596B00A0; Thu,  8 Jan 2026 05:17:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B8C26B009E
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 05:17:49 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 628D8CED12
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 10:17:49 +0000 (UTC)
X-FDA: 84308395458.09.CD109A2
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9367C40003
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 10:17:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf04.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767867467; a=rsa-sha256;
	cv=none;
	b=nanQy32FWhvjIXovuW2ZsvtUqv8E3REXmlLvOca3yo80ghsG/9Bkk/JLJWZRTve4hEcgUb
	T0QYk+zOvVoJoLTLHscvsiLI2DGOOsrsTBWWSDTYgpm5RnHumy1AAk4SqCbY7EzYdTCbK5
	NXiIr6BkXMvwPcr+PLZBmDkuBeQIktc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf04.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767867467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pdn4XVVfc7tr1FkKGsU24Lq1L6n19W850kHj7O11v7A=;
	b=MjZqH947o8ekZJ/UJufARl0gqpYQeRY6TKxmSLqeHJ31EgZke+ljhdBT1QaxLynJm/LgS3
	yF4SLdXWjz0rRsHXkPCalEIR01wfSa+vmoPa+rWuPCqt4fzKc1VPTb+0q76K7oiLU7f1+O
	fVhsX85SeEEsuxoQI9XyFu9DgBpl19I=
Received: by verein.lst.de (Postfix, from userid 2407)
	id D7E68227AAA; Thu,  8 Jan 2026 11:17:42 +0100 (CET)
Date: Thu, 8 Jan 2026 11:17:42 +0100
From: Christoph Hellwig <hch@lst.de>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Logan Gunthorpe <logang@deltatee.com>,
	Hou Tao <houtao@huaweicloud.com>, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org, linux-mm@kvack.org,
	linux-nvme@lists.infradead.org, Bjorn Helgaas <bhelgaas@google.com>,
	Alistair Popple <apopple@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Sagi Grimberg <sagi@grimberg.me>, houtao1@huawei.com
Subject: Re: [PATCH 02/13] PCI/P2PDMA: Fix the warning condition in
 p2pmem_alloc_mmap()
Message-ID: <20260108101742.GB24709@lst.de>
References: <20260107171724.GA432074@bhelgaas> <20260107203439.GA446340@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260107203439.GA446340@bhelgaas>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9367C40003
X-Stat-Signature: nxbx7jozx314jgkghuu1knbisds676pj
X-HE-Tag: 1767867467-573345
X-HE-Meta: U2FsdGVkX19wtzeovMiNiXWmbekf7wCM+SeZbvGNFEo0an9SEb9N/+CXx3/qt6n37038S1dgeIp+sGG9s4IjE0dl8RRgvd6+W4op7+nPaXNz6R6rNa9W11jxeOyvyDVUjOeiLMzIf7t9GWvRqkfAU177dziWJjWExX1Q/XG/jeRRbtYYcXuWQdMomZ4aK6pJMjFJQ46l6yjK/wobpVDJ5z8bEoYd28QXfY+ibX/4xUR5vfHK84BDMmxd/qPxHYvX6jYsBgKx7h7mYaIc05qFCrFNUftejpossadar2Yiwnf17DNIDuvDa6bdcmhfhKEgUSqms4B8lzZLIm99SeuMTy0g7KRZpuN/oiJqVnYEwGREtHzYG2GhQhzDmPS3Ly+XNaKGAfO9kEAnIVG9DSFkqW+jHhdORGvhFmMzW6ZROczk3DLyEIZS0qyovkapqofT94CJN6XALay2GU0nqEO0zEzqOGjGv5CnRzfiPOHtZSZL18UurlKerA9Li/5w2/NPbPs8NpafNwoY/Gvt0Jg46uIn8/mwQMSLduJrwTrlTX3AZ2SXnbwrNO6iVM+584nAS/ktucei3LAxLF8eaDRCoiWESw5o6FOutNHdBh0dD/rZOVU9XT1jgebUVKa0Gkv22wVz/Wp+7d0ay+mpqKBAGYi5Uz18fa1ays8CjsixJwsRciui28L9BL60j6Uu2p3+qNaaODy2oyIfqkD9Gm9ofjEy6fmXKHNBpnKFDaDMp6+2DVRe7Y7Oyq0euGsXLydqq+6eW6ka+dlOpB7NzwF9DXeQNVtPwk3IQL/xXksV4i9xAPW2uIaS1FrqlFA/YlAWfujA7tWNKxIHUMCPvOYnsNQMy+Itufp+UwKxM+Zosk8KWWglf2OW5UhIwUJKQfndgypxzm3EZwU5qiMiP8iT1G+oDVoDyQ2hllmhebDl8HBun+d+rc5GXd8AlRkwwD2Zl+gNb+pABczmKkHf8/1
 NB7kcfZd
 IC9C/4cjOlhTT000kJs0hsqDsTllhTW3Q/Dq85iT628u1ZFvHC+TL/SW/jSrGzDum8YF3LRIwl+2V4wzvVjshWXKY8G6fv+K9OeG+hlRV67m7/S3CFzD9hkJrSRMDZZ62vtEE0dFpyXZktUecOnn+trVdRg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 02:34:39PM -0600, Bjorn Helgaas wrote:
> > 
> > Given that, I would ordinarily target the v6.20 merge window, but the
> > "ASAP" suggests more urgency.  Do you want one or both for v6.19?
> 
> I put the patches above on pci/p2pdma for v6.20 until I hear
> otherwise.

Sounds good, thanks!


