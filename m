Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06F37CEE351
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 20:18:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 691666B0098; Tue, 18 Nov 2025 15:18:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 668ED6B00A9; Tue, 18 Nov 2025 15:18:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 557E26B00AA; Tue, 18 Nov 2025 15:18:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 41D0F6B0098
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 15:18:56 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EFB9E1A015B
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 20:18:55 +0000 (UTC)
X-FDA: 84124841430.03.39D4BE1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 72F991C0014
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 20:18:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jQfDsn61;
	spf=pass (imf18.hostedemail.com: domain of kbusch@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kbusch@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763497134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=45iaqGzeloD/PkIxgTPLmEveJVPtdH+50bsoXaS0q4A=;
	b=JWd9OfCrTOgtkyfxFyaolW7euv/UUE6V/sxOWgzLkXVrdG7uiPCDvvwwEpd9VEhamocKTj
	kiDXTvLI3a+ax9gsR0qQtKB0JSpW9twtDaOLAXp+2lUZM6R8Hko+eMd6uziAvUvBJu7WCR
	/6snXNRcIXNRZnxSGbpLe1kN60kECog=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jQfDsn61;
	spf=pass (imf18.hostedemail.com: domain of kbusch@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kbusch@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763497134; a=rsa-sha256;
	cv=none;
	b=iNTRQboCX8i0XoDThZlazFjA9mGy3DxN5julmdMRFOuBKbCRXrTWK6PDTeIdpYLI8+1IP6
	rD6EcYq2iOE3VJMUtlN8wNqFXtvumj2pOtX6S2GmlsWGEV8zkkOYR3L2yt9+wLp239v3tG
	px76xNA1z0Zi1NWkVOU/xtI/fl0mg/4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 63768438BB;
	Tue, 18 Nov 2025 20:18:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6C3C19423;
	Tue, 18 Nov 2025 20:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763497133;
	bh=1gK/eOl0lFoJx/Qsgws6pSF6IokRCQEg1Ra5CF1IxTY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jQfDsn61vufo6YOfQo79y+Ndb5/49pM+Kzub8NVaHCny22FBzQnFTrSLg2XdPo1s4
	 q4Q7m4B585DTvH5HVWQ0DO/E2wa7u3fFCYB85WskqwPYKBTtnUrrPrWPRE5C2Ymwu9
	 XI6NikQcB+qyFCqrr5w+MjHt0GyCFcaWHiNnpAZuQe+VtouSDZ9qJ1I29igbCkZOyV
	 6JDMlf1DxIGJwl0KrKoWkLUy0geHXeEkVLKutwvuAT1n5/hnFBjFl+IVPa8640+D5j
	 uK0n9LGxWeIjzuFUFMy16vZC128qAY115S6xdY8r0buoE9dRHyEPS8qfYYbszF8xDd
	 vw0kkKc8fqFoQ==
Date: Tue, 18 Nov 2025 13:18:46 -0700
From: Keith Busch <kbusch@kernel.org>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
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
	Alex Williamson <alex@shazbot.org>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
	Alex Mastro <amastro@fb.com>, Nicolin Chen <nicolinc@nvidia.com>
Subject: Re: [PATCH v8 09/11] vfio/pci: Enable peer-to-peer DMA transactions
 by default
Message-ID: <aRzUpmUkDy-qN5c1@kbusch-mbp>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-9-fd9aa5df478f@nvidia.com>
 <BN9PR11MB52767F78317AF3AB94A5B7D38CD6A@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52767F78317AF3AB94A5B7D38CD6A@BN9PR11MB5276.namprd11.prod.outlook.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 72F991C0014
X-Stat-Signature: 6mrshcoz5y31d3k1ejmj6qm1nnhitw7i
X-Rspam-User: 
X-HE-Tag: 1763497134-45764
X-HE-Meta: U2FsdGVkX1/3VgNor1n2lDYI5GIgKrjwkBTM6qDONSdXAQmpmdpDyI7DtDNvy9qVHUGwSIbtl+HY1Cqx3oMFba/iP9lNEOocUlyR8Tyu9HiG2itPtkUhx26p6oAiq+IQjeo8vgFbNs9H3+/tkuZoW5u/NeDXGbuyrgxxFBNxPaP0Rnp9el3tdn9RK6JG76GApoEc6LBsLidzWaR6/TE2D95jBpSo8epBtZ3CPz0dZD9BcEMZdES6N7MlbeIqXo27WyS64QnZQC0Z3FQORWxjYqM1k/JaBNtuZS/U3Q5LsPRwo9AU5C3HQvBOBxNUA/5OVwZvpcSOJHSGqVrMAE6QL7ViNbqajr+LXotCotQr6SSElIdKMQLCE8JGkaPZPbJ7fUv+DA7admDuTDkd+pwg1UzTTjCA342IQlL4tl+UHDQOiCpmDaKi6aYWpfXJ2feVBLRlB4tzNPs4V99xnpNt+M8gBxJZl7QUzXCImzZF+vRmQUZKVJKogXd+qS26a39g23hl3i3XYe+AKihZekTmpKjG0T1y6/OU9F5uGez2Y/01WFuay91njayWtFSo8IQ+C4OEY5nTBRUsOLyx4Bht4fkr5drQdaTIFRoneJpkBbnKHc8SuMja4HPCBJROO4m3uVbOleWl9tVCPHaLW8/SLj0MqSUeSnRef5UXtv1KKIVBWhY2S29+aTUrb/Ge/UNA87TDS7U795ftYYwV8PvSiYq6vNLHPYjigiF4wvkg/7sVYFr9M4v+uQGt94wccY0b5Pf9fRGHUtjvOpxuAiuLVQwIYMhpFbeXxeMLBKs4QiArDhMGcmhMd5TPDMELJnD7ZDLAHbOVZR93kpr8GQt7ZCrUM08yyPbtz1ecmvwEdy3bYQp89ngYiKNi5nE9y/Oj5kiDIo6xc9Snl6RKkh7xvdB+bCVrE5yr3dRdBDH09U1hn4S9HBhZesYpIR2HlCLZLbAKcMH3SkBO/kW59Xl
 KKA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 07:18:36AM +0000, Tian, Kevin wrote:
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Tuesday, November 11, 2025 5:58 PM
> > 
> > From: Leon Romanovsky <leonro@nvidia.com>
> 
> not required with only your own s-o-b

That's automatically appended when the sender and signer don't match.
It's not uncommon for developers to send from a kernel.org email but
sign off with a corporate account, or the other way around.

