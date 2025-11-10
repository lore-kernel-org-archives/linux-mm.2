Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F7E9CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 20:05:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEFB28E0003; Mon, 10 Nov 2025 15:05:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC7EB8E0002; Mon, 10 Nov 2025 15:05:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DD248E0003; Mon, 10 Nov 2025 15:05:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 899A58E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:05:37 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 41C114B67A
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 20:05:37 +0000 (UTC)
X-FDA: 84095777514.08.E2BE432
Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2B76A40005
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 20:05:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm2 header.b=VTtNveK1;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="e hVjo0k";
	dmarc=pass (policy=none) header.from=shazbot.org;
	spf=pass (imf07.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.150 as permitted sender) smtp.mailfrom=alex@shazbot.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762805135; a=rsa-sha256;
	cv=none;
	b=yEJc+m+/b+8uPV8cG5IcImG7RvATy+j+f9qMsk7PUgVljEx0rt4D7nb4JvljAao+TrFmcD
	UOwaBXqmHLuGA6rbOTrOQu2eSGMM5TOCnMwj8AwsCPkHX7JQzi/ysBZp9J/5uPJQcV6P1N
	wPCNxqJLHHtE9yao5IcchvwXslJoVRE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm2 header.b=VTtNveK1;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="e hVjo0k";
	dmarc=pass (policy=none) header.from=shazbot.org;
	spf=pass (imf07.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.150 as permitted sender) smtp.mailfrom=alex@shazbot.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762805135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LRTbnDgOZdkcWyYb0TrSsTJyowo8VQnXM0W6ONAWUts=;
	b=jQlGwfX36zHAAGlbzDXRFzD3IvkLYbg4FwlAjfV099JNI3dCwS8tzuN34yidSEof0lC8K9
	jGFUDGc+037Hn2Edlw6dGDvL1a9NXnZqld3DVAB/5PikSkqrs9ypJByC3h0V5JzP4fHygj
	PjoKXnYRXMdDzVJ0hPLRHBMHaVw+vHE=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 6D7811D00147;
	Mon, 10 Nov 2025 15:05:33 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Mon, 10 Nov 2025 15:05:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1762805133;
	 x=1762891533; bh=LRTbnDgOZdkcWyYb0TrSsTJyowo8VQnXM0W6ONAWUts=; b=
	VTtNveK1sP3RdPO0iA1mluhOTIezB/pxiWEOpTMtRrXpqSxqoom2HwDYk67QuWkW
	sPYOFU9wblpXDKzCcGaz76SsbUIjzORvB2iixAZGqW2fpsMJzqP5XDSLJZuUeose
	gUs7geKqCEZxyILKTVR1G6bjEdT1IDPI9lORfC7uU7VXjawAWvGl2cthKxtM67hg
	2LGDVSp2fb5+OY7d95VBUt3xXcg4zmyZNGQJvu4WmoOyjyktai2rEvD59ntUSPrz
	noD0hx+3MnVDFBYoEm291EVo6ioNy0I4iVxIt4URSUSibY5VQFYlMAenBohjrrqE
	5M+jBIsmcKEZFKzLT7cG6Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1762805133; x=
	1762891533; bh=LRTbnDgOZdkcWyYb0TrSsTJyowo8VQnXM0W6ONAWUts=; b=e
	hVjo0kNkpXpEnjyGLa3/HioTTAA5OcK4yDT+dT+kSj8VoCNpXQicmGnR1r8kl3i4
	n/q1SGSEgGz8mmhYlrkKrESCZwS6ZmjcXz2B3B9WVYhcun1l7NR44AgVENlnLqvu
	a1zJZ2CuMWjHrlkgrKrx6rKTVBu03wGm/PEyRLxXjeJPUmeJkA1RNRcTv4vkR077
	UeYkeuPv7KXX5jjN3Q3Admhq/wVV39C97HYyXRwatVk2JzsEizOnKtCy3nYrgUV0
	f16CdLzVqw7okI7dfupJaRHAfGhXWIUe34rM5F+7RmgptMF8UZmdovDBQ67FlOmL
	bbZtZ4jSrTcVOKqnpDH4g==
X-ME-Sender: <xms:i0USacfcdiFukOkHlGoqV_M4dCc620hY4NSllrMdUQNN1jhyNXA0dA>
    <xme:i0USaebmv-CqTmGTtMURt40eSNK-Wx58zPcA6lUAMFk6_sJ7kTrwfXO5-hJI7QP35
    WOjketLVpgzAmupEQaOyA0CSU46lUmN1quCAYwRJCTFcTgJGFD4>
X-ME-Received: <xmr:i0USaQJZE78F87doANetcSybuW5K51r7sW1QPQxDU2rb0XeXgAf-OVXV>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduleelvdefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfgggtgfesthejredttddtvdenucfhrhhomheptehlvgigucgh
    ihhllhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrth
    htvghrnhepteetudelgeekieegudegleeuvdffgeehleeivddtfeektdekkeehffehudet
    hffhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hlvgigsehshhgriigsohhtrdhorhhgpdhnsggprhgtphhtthhopeeffedpmhhouggvpehs
    mhhtphhouhhtpdhrtghpthhtoheplhgvohhnsehkvghrnhgvlhdrohhrghdprhgtphhtth
    hopegshhgvlhhgrggrshesghhoohhglhgvrdgtohhmpdhrtghpthhtoheplhhoghgrnhhg
    seguvghlthgrthgvvgdrtghomhdprhgtphhtthhopegrgigsohgvsehkvghrnhgvlhdrug
    hkpdhrtghpthhtoheprhhosghinhdrmhhurhhphhihsegrrhhmrdgtohhmpdhrtghpthht
    ohepjhhorhhoseeksgihthgvshdrohhrghdprhgtphhtthhopeifihhllheskhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepmhdrshiihihprhhofihskhhisehsrghmshhunhhgrdgt
    ohhmpdhrtghpthhtohepjhhgghesiihivghpvgdrtggr
X-ME-Proxy: <xmx:i0USadiojN3-M4EVjjaRRugj8V8QuJnr5MsQlLluVx8g5hN9fuNwjw>
    <xmx:i0USacvol4BakuBUda4qcSsYifPCPIwHmQFFbRa4tQipabSTTp737w>
    <xmx:i0USaREDw4I87L0odND3wJ85uUDm4QaLw4uwBFQIJ-AXU7QEY82_xw>
    <xmx:i0USaS_gEbCoj0gRiNt7PSMpEk5gV19bFOSSEZSZfZgUVR07IZj5bA>
    <xmx:jUUSaRJMGClENgI7ttLAOXLiOuPL8ZATIaHOyPe6Y_F7QjCcID7VjG5j>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 10 Nov 2025 15:05:29 -0500 (EST)
Date: Mon, 10 Nov 2025 13:05:25 -0700
From: Alex Williamson <alex@shazbot.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
 Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
 Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>, Sumit Semwal <sumit.semwal@linaro.org>,
 Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>,
 Kees Cook <kees@kernel.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <skolothumtho@nvidia.com>,
 Kevin Tian <kevin.tian@intel.com>, Krishnakant Jaju <kjaju@nvidia.com>,
 Matt Ochs <mochs@nvidia.com>, linux-pci@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 iommu@lists.linux.dev, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
 linux-hardening@vger.kernel.org,
 Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: Re: [PATCH v7 10/11] vfio/pci: Add dma-buf export support for MMIO
 regions
Message-ID: <20251110130525.6712552b.alex@shazbot.org>
In-Reply-To: <20251106-dmabuf-vfio-v7-10-2503bf390699@nvidia.com>
References: <20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.com>
	<20251106-dmabuf-vfio-v7-10-2503bf390699@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2B76A40005
X-Stat-Signature: yg6ajco9ji3crruq89yywsd3ag3fy6mo
X-HE-Tag: 1762805134-205229
X-HE-Meta: U2FsdGVkX1/QC88RauDCVh9U4pEdrUQzI1NHVPeQFCYTQPfvty5xOYxCGdsOwONyZ+1E1WDZJcIBWC45IvENGTGS9rcry8uHzJ3fwlr18JRBoRUMXfpN63+Bl8BAWPnrOITbUOwF+ltJLgLoSPQH8RQGd3Pp9eHrCkS5hK1vD4eTlxGUUNIXFRMA8UDcFATKVyNijZ3bD63+ZQhInRkk+WDDKb5C6fjnbAXaOtXTdyhK6X9ZJddiWf0WgsG4WfWi23nncDuZvQvu0tuL+Z7x4/i9/C1+PhhFS9lm6btQOojtxaVVq2weKj8InRQFO1O/YfaTibBajX6g5pBz9FFABTwGULjtnVCc2XsmNA4rNemMAejC8CKvkzUFs8bXjapmbdEBwXHJeHp8/jziQjT8EWht9+Jp+F+hZ/ySs9ZwszjPpWsQ20vMZW8v3ehtt+sU8TAoyuKbqDd7psxH6iQQ+aAYrWiM8erXSJqYR4iyhB30Gdv6u9jPYRU1WJgDjlPQvRLCk2EiLak1KTOSomb55fcrJs94+CQWjrlWDiz+/kaCXOdONnUQzbGNml09SUcb5y5zW1dQfFxQPCPcQVwF/WZp5uHG8suv8yFJ/NWsh4IzZN6UsS4+w35sD/gXjKWk1ChfuTjifbiucdQGL2mNZIKqnrVGh5PWlZStfcDFfx6CoIGXrnzRvt9kb2iQOGrQIeT5VzSrqyNtGgsjKDRpqGyA38IWHpUGflokOgwmRRxPkldzEAnVC8Hxbp0pJFUAPICv3dg3xDVghz1yj0NJvJ9/RV6yqLSt0sest0So+u8l2/0qreXCv3IDD5M1PSKleD+IZQXTgDCicpEvwTdP2DmedkxeDcD1nXBVVmq8p0012hVY3qX22qD49ZgJZX8wuaf3dfB/QkGEaRqHxItpBub1ZoSjb5ZFP5BxeMtLmg1lbuR4XaHC7L7Fg0Ez1hWkF/SEd9zrgxR/+kfezjJ
 WTHF+yee
 K3AsuwgJAONczYpn+cOXLzE3B3U5eoWaI1XdO47vgLUSSCTGi6A4JHKcsQVswLAlw6CpWwlofdzC1dQQWBBlFO1iKOM/V8XOblDmy2vhAjm71KJuCuHd01SW8N2aJ51iAEN0Hqv9/UXW7k+7oByg7jzsnMFZyV8QLhYbux8DVWzZvhSWG03iJnXXjrKvlhEUEzJ9unGhm6ONRDm9rnN/VH1homU6+Or/LvZjDURKk/pURUNoVbJRK0XCBgvhFL7MElNmp1zfWzUt+5F5olEnHlJGTglT4fm9L0opaxYtnMl7U+MGRoAMe4rMhBL1Kn/p+9M0cIBaIj9TA/KfpO8OHzzcIwKsvQFC0RWfGShX19+r8FU7mdtu+u9AYSnTyiKzwCAK2hxpNdwPpV35QY9lQEQIaTPJiEhHAdHqRqOZcbpsMj9Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  6 Nov 2025 16:16:55 +0200
Leon Romanovsky <leon@kernel.org> wrote:
> diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
> new file mode 100644
> index 000000000000..cbf502b14e3c
> --- /dev/null
> +++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
...
> +
> +int vfio_pci_core_feature_dma_buf(struct vfio_pci_core_device *vdev, u32 flags,
> +				  struct vfio_device_feature_dma_buf __user *arg,
> +				  size_t argsz)
> +{
> +	struct vfio_device_feature_dma_buf get_dma_buf = {};
> +	struct vfio_region_dma_range *dma_ranges;
> +	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
> +	struct vfio_pci_dma_buf *priv;
> +	size_t length;
> +	int ret;
> +
> +	if (!vdev->pci_ops->get_dmabuf_phys)


vdev->pci_ops can be NULL.

Thanks,
Alex

