Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE75FC83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 07:52:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F75D8E004D; Thu, 24 Jul 2025 03:52:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CFB98E004A; Thu, 24 Jul 2025 03:52:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60CD58E004D; Thu, 24 Jul 2025 03:52:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 506F18E004A
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 03:52:44 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EA3381402B4
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 07:52:43 +0000 (UTC)
X-FDA: 83698391406.14.1A77C8D
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3CF9AC0004
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 07:52:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf10.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753343562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RZRDMmJMqQ4gKrg78EVz1ivfdKD9ZKm0/a1Lm8u5Hw0=;
	b=QPVm0mEZ4bwDNMo8tfZ4dZEaghFJAcE4F7sK8FPKgrX/TFG48OscqdHf3gl5+5HpYHkEad
	By8Xgt6GGx3ntZ82W5s+Bs9flKkUFFOVGwemW7558b1BjxWS9ZSs9FuXWVSIMeLUSMweZ9
	Zo46Quz6PiCttHU+Iq3DSbkMFsn90zw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753343562; a=rsa-sha256;
	cv=none;
	b=2Y4i1ewMV8V0wSNnNUkgyRYzcaV70uR7aVgFNCPYVyvNHU1RtILc7l4/Ju/6/pXrrszPKd
	Se8DNilzTqrSqDKK/g9LALVOfXadv+kWI5Z5QOoKumYCLl5/YFI6YOblTQ8fqjTfOVNevN
	dEvniIZ+DCZ0bZrWc69SXg1xLMCBtK8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf10.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 376B168BFE; Thu, 24 Jul 2025 09:52:38 +0200 (CEST)
Date: Thu, 24 Jul 2025 09:52:38 +0200
From: Christoph Hellwig <hch@lst.de>
To: Leon Romanovsky <leon@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Leon Romanovsky <leonro@nvidia.com>, Christoph Hellwig <hch@lst.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 03/10] PCI/P2PDMA: Simplify bus address mapping API
Message-ID: <20250724075238.GC30590@lst.de>
References: <cover.1753274085.git.leonro@nvidia.com> <30640b5e4ec975f928e685b92aaaf3e2e5e08f72.1753274085.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30640b5e4ec975f928e685b92aaaf3e2e5e08f72.1753274085.git.leonro@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: amemi5bshmjswqqb4ch16jarwzgc64bt
X-Rspamd-Queue-Id: 3CF9AC0004
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753343561-934631
X-HE-Meta: U2FsdGVkX1+bwJcXcX8nUO1UrTSi0siqY2283gtfIJZ3B6aW3j2hji5F6uJ/vsE2jMNMBaiNeBf+cpDLK27lQj9aapzc4tjQSRWiQth9x5k1mU95sgjaluP2ftFpYzDOX26wz5q6+G0ADkG4DjEx+Lx6ScL58hMPqNMl+y5qkAkRk+EHJ65ddbqtbAqNOc65Rjn5vKUIbJo6d5e45K6utpSi2VOIQdV4V1w7f6KwM0VTTO3WCHjdNHFat3gmTQ5lZN52/S9rofWfQlSORYGYY26jQwYXQRQDBNXmBh5GKHoTcPNzd2uVHyy1HImqefnIxGgTdumvwgH85cQ1EwGdTrqTQct4voRI4XBwf/H1UgoGRKGAhvwjuxCrB7s/O2vVh9n4vY55YVAVNp9BNOaQEeAnT+ec0U6wWH9TnjBSQ5k90GHTv7mdCo2ooTjOVtimlh/7//RqqJIKp42lo1ejVLcgYAYYmW1pQbO0CxCGin+HuNgd6WAVO62/iBN+OpgLiha42BuW+00HNiU64XMadaSI9XfnjlNqXrQ7D+Lg0mnNPNyTaM+cAXzzxDGS8IUH7dVBr/8ss67f3E7hwhbL21rnHo99829IbgNJQtlSlshz47uobEu4uxR08pdgsDlgvaPVMF9khsFgkLQpE9xM35cBHhfYBH2M0z1+kNgd2T1QipshqcOJMEhe7RtooTHsFFWXhAz3BFJ6LMGWoneY2JJGTzq7OvTVJUmhNZXeeAC/WDxP8RuGj0CqtmNu41pOJ6wZPnjklCNuUVkUA30IiRGv8zAWeEU9bHq0dbKinJGeOaUFzuyBfgyq63hkyowlfTI5Ou0m39wqOspLqn/Nz388dFodM9mWMU4nPz2ms18FvlCF1kLV06QC544tSAs6W17V9CL2AnRAhwkShqzh3V7rpD3DJGeAdX1y5P2LjuSTvE2+TmvgXMLtd9BMgGRY2/ES3iuarPcoq+3DiQd
 tZWI2yqb
 yAboKqU17Tcnnck021J/tyCGkT4KbQVS83T2OpdoyIhWWSJ4aCRIUGStowp5SwRT2Xw0r0FYJfUSDpSfa45juE3aDcwFbk2bwNxhAN5sWKOUpNT5sCj4iXqR2nA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 04:00:04PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Update the pci_p2pdma_bus_addr_map() function to take a direct pointer
> to the p2pdma_provider structure instead of the pci_p2pdma_map_state.
> This simplifies the API by removing the need for callers to extract
> the provider from the state structure.
> 
> The change updates all callers across the kernel (block layer, IOMMU,
> DMA direct, and HMM) to pass the provider pointer directly, making
> the code more explicit and reducing unnecessary indirection. This
> also removes the runtime warning check since callers now have direct
> control over which provider they use.

Again I don't actually see any simplification here.  But maybe I'm
missing the ultimate goal here.


