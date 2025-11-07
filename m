Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BA4DCCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 20:27:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 075458E0005; Fri,  7 Nov 2025 15:27:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04DC68E0002; Fri,  7 Nov 2025 15:27:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECC058E0005; Fri,  7 Nov 2025 15:27:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DD1FB8E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 15:27:27 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7B54B12CB47
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 20:27:27 +0000 (UTC)
X-FDA: 84084946134.29.8A0486F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id D5533C0011
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 20:27:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GnHfPvK9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762547246; a=rsa-sha256;
	cv=none;
	b=CWlAOkAu2/ib2afGJQKp0pWYiS7MdlcFd/w0jXWY3g11vkz13xhSLnY5bBwVKODkcwzPbC
	QarqN8me/2FuuBCvvtRaEWpbFk74NlWL94qKHa0mjTMrvGf3VumXqQ3BhHzto3Xcfowu9y
	H+/nBY4kIp0VjQZQBjg/Qs6JgU9zJmU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GnHfPvK9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762547246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EmOH7ZusMIqrO3Ozdjw3u4CD+pelx4g0YYdLOJ9umvE=;
	b=KWG/QcOUy86Up6w8AvKxzWIMQZi6CX15YQtfBwR2tJWfxTHquRxXezAMEoAaBfzcmWHS9f
	yIhpzaCkNWCAdxaREaj2QxLx111mk/6o+u1PYnSYa7evMoeJ+gOEVQ9oNzbL3R8qXVrhuz
	LM7WOd1flNpmO5nNMgv5/SHIBHx+I/w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 77AA241B35;
	Fri,  7 Nov 2025 20:27:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836D6C4CEF5;
	Fri,  7 Nov 2025 20:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762547244;
	bh=VAySUlKP+gpY13ehfWvqZiKxHmLFx9bZKqh1eqOc7BU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GnHfPvK9RlbGueuO2dIzOFloCGUIJO+4STJ9acaeZ4mwoNgCLVysGF3G1CD2dslTO
	 J8xEeZg2TWQROLBRgu9cIRspJbvL0T9YEBkcbbcqYSRUqcnzE6UpSuE7s17MqR38od
	 k1auiNEzsLsrcn/e5bmLAUXdt14ph1onYr5+m4OBZiUnSghRHlS5cz0wreim7qkvti
	 AitNvNVxIXHxoXVVQZB1fuCmNeB+VUFl+qA0fr1ukYsVMffsErSLFPHEZkD3QhPl33
	 mZVBp/M5pmVMtLNk4jfzBFQR0vtiXMXgOHw2XwWQXqRS2kcJr3JwuXFYWK3abcXYgE
	 W34/n88w3YbCg==
Date: Fri, 7 Nov 2025 22:27:18 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, iommu@lists.linux.dev,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v7 05/11] PCI/P2PDMA: Document DMABUF model
Message-ID: <20251107202718.GE15456@unreal>
References: <20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.com>
 <20251106-dmabuf-vfio-v7-5-2503bf390699@nvidia.com>
 <135df7eb-9291-428b-9c86-d58c2e19e052@infradead.org>
 <20251107160120.GD15456@unreal>
 <0c265a9b-fdc5-40d7-845f-30910f1ac6ea@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c265a9b-fdc5-40d7-845f-30910f1ac6ea@infradead.org>
X-Rspamd-Queue-Id: D5533C0011
X-Rspamd-Server: rspam07
X-Stat-Signature: 4j94655ue94k8f1iy9y8uxn5sox1oi4c
X-Rspam-User: 
X-HE-Tag: 1762547245-803133
X-HE-Meta: U2FsdGVkX1/is0tshAIBnbt/+TyVkTa/wrDVJ6FzbXWDVVrvjO5xFLXJuNoJ8sEGpm73IPqWj5iFGtBqdrzejY00hPBzN59NDXkmWyOmx8n240fWMcTIrodpN+7VK76POe6f5xLzctCN89ynWJS1CZkXY9mp8Y6rDq79MhEJ7KC5/TlxvbAL/ZdTMwiBKfFiB8kLBxCrlGg16wo8LRLqRGvW54ex0/baTaJwehoaaFlJWgylGOEf3y6bzY5wd519n/c6MUgO1AtnOHGPTeJiLjIXNE4dBYzV6HWgE887IQLRvETQDKbjmmtQUR+BR1WufLbSLdxGVSO1dgqPNTk1RdmFHK0Q1PO0dND+FOTVhNikY7qr+L2g4DJZSoOkPDuxUzaU3VMxhs6MdUD8ekOIbSzcKoWGds0yHg0MJv+jKj4wdTi06nu6k5/2nWv+6ZVOzQGUrh43sAC2WcYZf6A+hDDzcbL3qcg1G0naLE9N5W5v8ADGtWk2VsVXNiFFfRB0QZkW0g0Vgr3cHMOv3owsG7RVbTsZGr/rxa7LEr1vpZrKuaE9bAorqm0LQNH5KQG7EwRZavvSuQjUyqJixwc48sZuMXupHrBJOFpAbWwgbP4gjNbvZMt1AMBSAHwc4aYz+S/+qvaPdFH7h+Idzork1p3fdsxDHw7hv90ILlkPXA2Hs/XmvjwmfzOheH7pz20yu25+V6jRKUpNN+atTC1O2v5+/OXbQPmRIrM1rUVUJRw/uXkJnCvnPR6AIi09pupFLHQR38NLh66okJmR90drN6FrQHimDai3O095vnHXS9oKFyZ6tTcrWRLVpbx9PYmtNvU7qXTfqduNrnXS2sAAjYQTXGHDAsgUJ3C74JOSAXdlwSBf5C/LpMrzMKWrKWc+CmEHmgUaBug71fN4pf9LHJ6vwH6l+4ZrNlq+M6Ci8hhqpPwsu3MKJOhclAa/d+GhzPzfPbbuQ6ffJViAX0h
 LB4UeDXR
 XMiygeJKfIGT2v3pLgZgBxitYgNOQzmNEU5NWY4amW52P/ZmbQ1/NRbVRuANTU5POtCql3FMARfebDxofn8zauIrLDr6lCGdnb9XtLIdYAvRnePLJtfDvMv+qjT/Ni7O+GdX+Qf3GH+erxCrorR0wlKkR75Ku7paMLs7IwikC3j7UN3VbrgsA6oBdRNn8vsHxlU5varaXCB1A3rGOHxs79zDnQN/U78/TnPYJzkNuknwyOVHRDkKXPGf8oKY6d5fgVazmsKubYBvXMTqDS51NpLPwrQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 07, 2025 at 10:58:27AM -0800, Randy Dunlap wrote:
> 	
> 
> On 11/7/25 8:01 AM, Leon Romanovsky wrote:
> > On Thu, Nov 06, 2025 at 10:15:07PM -0800, Randy Dunlap wrote:
> >>
> >>
> >> On 11/6/25 6:16 AM, Leon Romanovsky wrote:
> >>> From: Jason Gunthorpe <jgg@nvidia.com>
> >>>
> >>> Reflect latest changes in p2p implementation to support DMABUF lifecycle.
> >>>
> >>> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> >>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> >>> ---
> >>>  Documentation/driver-api/pci/p2pdma.rst | 95 +++++++++++++++++++++++++--------
> >>>  1 file changed, 72 insertions(+), 23 deletions(-)

<...>

> >>> -The second issue is that to make use of existing interfaces in Linux,
> >>> -memory that is used for P2P transactions needs to be backed by struct
> >>> -pages. However, PCI BARs are not typically cache coherent so there are
> >>> -a few corner case gotchas with these pages so developers need to
> >>> -be careful about what they do with them.
> >>> +For PCIe the routing of TLPs is well defined up until they reach a host bridge
> >>
> >> Define what TLP means?
> > 
> > In PCIe "world", TLP is very well-known and well-defined acronym, which
> > means Transaction Layer Packet.
> 
> It's your choice (or Bjorn's). I'm just reviewing...

Thanks a lot.

