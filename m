Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0708DCFD63E
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 14:39:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 582AF6B0093; Wed,  7 Jan 2026 09:39:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 530396B0095; Wed,  7 Jan 2026 09:39:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4326F6B0096; Wed,  7 Jan 2026 09:39:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2E96A6B0093
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 09:39:49 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E6B0F13AAFD
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 14:39:48 +0000 (UTC)
X-FDA: 84305426856.02.4F4EC4D
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1EBA920003
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 14:39:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf03.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767796787; a=rsa-sha256;
	cv=none;
	b=Wc43Pul6oP9J9vzH526UAADowjvgstPa5sP7v7pfL+utBFN/2ZpVja+PoDlc46APT91IB/
	MBUsqTO46FKJVtBIcRlLAKDjwTT9ImkUgT8htwZ7SHyh43Dj8MhFJeOwtt1bFrKwhlRONb
	Ky6g5F/FEI/fkhwfSm+giLmmNGMtdMo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf03.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767796787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QiA8bab2gSTtnOYPURRgtFfq07DQSxeH741s/Vj0WnU=;
	b=uAHjkIKmmEE62SHFYaIbMeezpEDXSpF8zzLo9yjl5lK/zjB7NNxcaUH/fL7TKqd5YtDEUg
	9q6YRk03P1N6Fdujqznf+CrzIt2cNrzpheA3mWTKGW7szGEst2RD+DyfBJnd3T2jq2nP+Q
	xTFC9ntT0fYLgZCNteoOap4Jw5Suj7w=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 36C0A227A87; Wed,  7 Jan 2026 15:39:42 +0100 (CET)
Date: Wed, 7 Jan 2026 15:39:42 +0100
From: Christoph Hellwig <hch@lst.de>
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Hou Tao <houtao@huaweicloud.com>, linux-kernel@vger.kernel.org,
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
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	houtao1@huawei.com
Subject: Re: [PATCH 02/13] PCI/P2PDMA: Fix the warning condition in
 p2pmem_alloc_mmap()
Message-ID: <20260107143942.GB14904@lst.de>
References: <20251220040446.274991-1-houtao@huaweicloud.com> <20251220040446.274991-3-houtao@huaweicloud.com> <4a91cfe7-75f5-49a4-89a4-fd6717e7e9d2@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a91cfe7-75f5-49a4-89a4-fd6717e7e9d2@deltatee.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Queue-Id: 1EBA920003
X-Rspamd-Server: rspam03
X-Stat-Signature: d5qi3wq3irawoebfgxfu9osmyarss3er
X-Rspam-User: 
X-HE-Tag: 1767796786-798838
X-HE-Meta: U2FsdGVkX194io4qQdCXZdGooEeM+VaonbdKcudvmD1vvpnVFAtx4lNJiG/+kbqr8QiQXulf8P460NHEoDeHs2bJbXUh+I9mjRwBb44G934NCKAhooUgRbS3nXgbjOH5EkBrttqXvgDHl/sn2q/mDAIabPj1wddACDiBX+p3wubRWKJ6EmNYm4dvBf3y67JvUpe9UZGmR++hMv6W8lC522ChODKDuzgyps43J9MtMWvpNlOY3pGK2Mmgy/JgJCnydeeuP1QI3VzQ2n2Dk1ad8dBeCcYdqvsWfI0tdvR5TD9SZLNSvOX3QLl6iYcDg8gJyGG29O/TCYTv29NmWeY6z4Me8vENAZ2cQrflRbMF3Fl35ywx3Y94M5JaI1vQpyVsPqgQlWNCv9woUCJJNdjQrdrd6HaM0mUN8sNRC+R/UQn0iYZZx6TdnkQhW/ec63iXH1gseKNvHvdQ6th7p/Oc5pksEx7J33L7nt8eOd1gVFChS4+m7djpb0Ds3Nz0AFUfk114t32wnaFIWExhzEngh2/1qLw3pDW9wWEI8tUiWn9QWBA1zxGxTHeX9eqR+CUZdZ+TxqNQYZ/H9q0lLXFMUK3Ka8oPtR7Uql26XgO8wAKHBhkgY0G9kgQaYnDuFlhpGPLsqCHS9VyQL+xmfU/ZFRn3iyOUvM/koCwCSie4WlDZksclQ0WesXp56Lxg4v4Rvo38BOHDpcb/htNS4qgvVzQ/gTy4H4pCgIjSVg3RFpAPw1I2GNwhrDha0zJpPWL/KYD6piW0c9hFc9WNnrEDcGeR9wM5yMFjxhjyVEv0GrcCJhfJaJ1NIpsGowygi203AubTCUUpUmqemE0tijCBUQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 22, 2025 at 09:50:18AM -0700, Logan Gunthorpe wrote:
> > Fixes: b7e282378773 ("mm/mm_init: move p2pdma page refcount initialisation to p2pdma")
> > Signed-off-by: Hou Tao <houtao1@huawei.com>
> 
> Thanks for the fix
> 
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

Can we get these fixes queued up ASAP while discussing the new
feature?


