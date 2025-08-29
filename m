Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEAD6CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 12:35:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BF6B8E0010; Fri, 29 Aug 2025 08:35:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 097F18E0001; Fri, 29 Aug 2025 08:35:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F16B58E0010; Fri, 29 Aug 2025 08:35:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E1B0C8E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 08:35:22 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AF8FF855B5
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 12:35:22 +0000 (UTC)
X-FDA: 83829740484.15.C2503AC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id F25824000C
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 12:35:20 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Mxl8/qU6";
	spf=pass (imf12.hostedemail.com: domain of kbusch@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kbusch@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756470921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5zSMrOVSNClOrdiZ1EgFy9NdG3HEevOLe/lENj4ZGeg=;
	b=Y7P6xLdXadwCU2B8fVtSXIAgTMPZZgVrbjS8xXgQ3ylbFT1X8U2FuM6FUbHxrmQgq0rGaF
	JHZ1YaRIS2mkA8zCeA0dQO8syKYM1PjebVZS2GPqg9K4eOjrY72lJP7D2Pb/vmM4WS6G3J
	aCKXFrL8+Ruq3FF7MzieMa2litNckrA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Mxl8/qU6";
	spf=pass (imf12.hostedemail.com: domain of kbusch@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kbusch@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756470921; a=rsa-sha256;
	cv=none;
	b=CfUDNp6oeC2R2gU1hA7ctKINk/pVa7ew2k9QFzpvcEKzPAuecZhtPG1uGlTznZAVbkJT0U
	URaGFILf5cxKyJ/e5voW49E5Msk2uW9CecKJ4kBwgd9nTuTGnEe5+I0iuWh2e5uTnraA1S
	aK7I7WlNzku5MeSV1oCr3MZLHyRQ/6I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1499A60054;
	Fri, 29 Aug 2025 12:35:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49DF0C4CEF0;
	Fri, 29 Aug 2025 12:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756470919;
	bh=fPmX8Rp8udx+VwVXpgZe9FXorpOePyV4Ef8DrCTRpmU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Mxl8/qU6Vvz0COFBLrmB8UJZ9govt1w/+9MvHsezQkHTR5DIoYs7xgXKhzSYkVOm1
	 ZyticaiPv1YXSMvOVriZNEtfWFF/4gFAB5LRbmsuDZl1qYUJ6QJjS6y5kT84iXSP4h
	 c3O0x8clzW4t74drhw57szBCRrci0dZsz7TkMKYvpu6q9eSqR6y+QLN+NF1mWqnv0Y
	 TV+utnoubo+22XzKDO5zQdJ90tzO09TUxr04pRitKlRur46am/LMf882y9Fd21W1eK
	 Oe5n+rwQMv7g1wcRBxrA0L1C89sfgumKn452/Ld/OiWS5hXm6vNk/t7OjLj/in2qzE
	 hQrPqQ39Y1fww==
Date: Fri, 29 Aug 2025 06:35:16 -0600
From: Keith Busch <kbusch@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Danilo Krummrich <dakr@kernel.org>,
	iommu@lists.linux.dev, Jason Wang <jasowang@redhat.com>,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	Jonathan Corbet <corbet@lwn.net>, Juergen Gross <jgross@suse.com>,
	kasan-dev@googlegroups.com, linux-block@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-nvme@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, linux-trace-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>, rust-for-linux@vger.kernel.org,
	Sagi Grimberg <sagi@grimberg.me>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v4 15/16] block-dma: properly take MMIO path
Message-ID: <aLGehMVsTEXrP_R5@kbusch-mbp>
References: <cover.1755624249.git.leon@kernel.org>
 <642dbeb7aa94257eaea71ec63c06e3f939270023.1755624249.git.leon@kernel.org>
 <aLBzeMNT3WOrjprC@kbusch-mbp>
 <20250828165427.GB10073@unreal>
 <aLCOqIaoaKUEOdeh@kbusch-mbp>
 <20250828184115.GE7333@nvidia.com>
 <aLCpqI-VQ7KeB6DL@kbusch-mbp>
 <20250828191820.GH7333@nvidia.com>
 <aLDCC4rXcIKF8sRg@kbusch-mbp>
 <20250828234542.GK7333@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250828234542.GK7333@nvidia.com>
X-Rspamd-Queue-Id: F25824000C
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ekg7fd87eoqqhzrpojbab3q1r8jg3f49
X-HE-Tag: 1756470920-813631
X-HE-Meta: U2FsdGVkX19vEMyCRbxqenrG7eR3V66kPqOpc9Jp1SlSmcUvt4oNKFS0hCEtzH2EoMLXUFdia+9OPDFQjlC7Cr7OKK+jXGWuM2oas0jJUep6o0HbZTLB/LTWj/lGQyATGZSvkoMMRNjNzKg4LUggRCgm6lz9l50nqEnuixGiFOS9BHKwnkNlTbMjTM1Nn86rzgM7s1hPkCf04fHKbMI85vOJPOiwv4X5SCaC/YRWq6dawdO2MLbz8ssqaGk0oubvuJ+EjtIoFOiVerpI7M/NWHtnxmojdPbXvBBdneCcmFC/OJ+rbLGSji0tmktlPNJIUj1rLxA+I0WjOWIBfp/V1lYPevcXlpeNDlDJHAC5gnY1/wALTGzSnjUKX+lTXpQ4wfuVMV9B86lhOc8ink+eeTIhSs/yJ4WvF05BmToVrS821yB08BS3yjEHGyPoHvF7xgNdM6ETIbJ+JS61A92nP4uCXZ7QwBksBSai0fuVI1YlybSP1uYUh6A3wC4dHqxJ4voVYTQl8FMo9yHxMQyHOCL+CkVTKK6d3YWK20MoRiIq/YWzl9aF37jt5UdZARV/onfbJ6s7K78b4xJuFRY0jB1SjjWlf+UxLj1HzzVCBLBwWBXc66l5H3zizpAGsnFJD168fCiURBggXvsmdeqRf3VSj4E8czUpE4g0wxP9FBGnB4CAybyGqGqXhOp8lUQQIwyyabOsrngR87ZBWnIwyhzAuXu0XQh4ABG7GP2m8J1zi0KHqeKdD6/X5imPna98uwYoPHOi6+EJuSfJHwqxJZihzcd5dXkj4AcO92mF7kltkMStjALCUOLcEbFVpEX2QT03qavOWAho6/TbMoTEdVpkEy2M/w5OtcthfUTNHKffF0svkUxyBg7hTyXW5PG21gzblmCc3D3K+Kc6LMtmaSefTYLneppRxCCBYmnErDkmaCntYOtHl6QWDDNOYrWQZeE3md7L+YpDM9Lo+xm
 e0WnQSF6
 wN1P1d6Qvl47ui43Mm67iepqLsLk7D4XsvKBJRrHf1Ep10ngolaK15Uf+kDCViKnjZLwjuE+9+2xibj3wZ+2elmcWWMQ8J8phCNfXINVo9XgxZlrcUcMP1nPUQs0YuO+JK8qclYMU1eQNsbsI4lKXohAZCX5YqPHzz5LrMDwfQKcv4pcwHo4dUXNVBqXQASmWWkz0JP3ODAYzrQEo2bLYWUyoGEzmOe+upoV1dcMluBvlTAkP0h675OMZI7FOud+sAJH4mNvsO9AMYnRbEsGl9lRB3gqYMc6wFpP1nVwBM9+GLiX56hDGWLaQmaPpSyEIKjrH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 08:45:42PM -0300, Jason Gunthorpe wrote:
> On Thu, Aug 28, 2025 at 02:54:35PM -0600, Keith Busch wrote:
> 
> > In truth though, I hadn't tried p2p metadata before today, and it looks
> > like bio_integrity_map_user() is missing the P2P extraction flags to
> > make that work. Just added this patch below, now I can set p2p or host
> > memory independently for data and integrity payloads:
> 
> I think it is a bit more than that, you have to make sure all the meta
> data is the same, either all p2p or all cpu and then record this
> somehow so the DMA mapping knows what kind it is.

Sure, I can get all that added in for the real patch.
 
> Once that is all done then the above should still be OK, the dma unmap
> of the data can follow Leon's new flag and the dma unmap of the
> integrity can follow however integrity kept track (in the
> bio_integrity_payload perhaps?) ??

We have available bits in the bio_integrity_payload bip_flags, so that
sounds doable. I think we'll need to rearrange some things so we can
reuse the important code for data and metadata mapping/unmapping, but
doesn't look too bad. I'll get started on that.

