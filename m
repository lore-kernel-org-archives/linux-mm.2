Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFFF0CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 19:26:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 108FD8E0007; Tue,  4 Nov 2025 14:26:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B9308E0002; Tue,  4 Nov 2025 14:26:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEC0D8E0007; Tue,  4 Nov 2025 14:26:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DE3C98E0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 14:26:20 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 97B115A1E0
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 19:26:20 +0000 (UTC)
X-FDA: 84073905720.04.AB91C2D
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf07.hostedemail.com (Postfix) with ESMTP id A946B40008
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 19:26:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=KWQctEuj;
	spf=pass (imf07.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.182 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762284378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b3vZ52GkNsJGLOkvon3L18RWVKcEn1c510aPuA199YI=;
	b=j5tST0PiQ9HAKVLQw3Zoa+WifE86cFIuw1jV5MKv7Q6h6gv11+6yvjkNovwH90CiJmOhcm
	ejsvG0YkSm/787TjAWiIUQslSg+OTNUpWheUNPFNG1s8hhqWFiTxCad5d/4IfN2hUhZOhO
	Tiz+tXyVkGlETQ72DJFMcDr9m6hB/XI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=KWQctEuj;
	spf=pass (imf07.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.182 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762284378; a=rsa-sha256;
	cv=none;
	b=jpw2eTxZQccCD/t22Dfkk61s+W4SAqTMbSN6z+EwrZTJFiU0NsC9UcpvM3YRpC9y9CSue3
	NYul9+D4DQRPZCT/jpcwr94VwlAX5P+sFbTljgi/Q0oj4AI26HKBE4AaZvdCvohn/dHjGg
	6/Fjz2qCdnuff4VuZAtrKcXheqSF5u0=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-88f2aebce7fso648613485a.3
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 11:26:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1762284378; x=1762889178; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=b3vZ52GkNsJGLOkvon3L18RWVKcEn1c510aPuA199YI=;
        b=KWQctEuj7zjyn5FUz4BdVMrVolLhP4Vi3pn/ffECLjKEX9X/59/eftPS9edb+iOzfy
         GOgEyrEuaS8ACNNTIILWL+JHbNClcrD5xrzJfhEhx6ryEe2e9Pc5DAeWr51SWeSlN/TT
         VUSbtLE26I9O2lESsI9Eq0/ynBDrDTyoa/wh4zVF3cm/hmNbBP6lDtoDb0ghZs6anVf/
         d2sj99Djqkj9Bmmy4zTDOjWKcoC7cxtR7XlxVCP8hylLeSdb4Ghc2EtGHy64E0Glfz+y
         ZnW11r8tee6T/xH4ZWy/bgRY5gHd7lzFMmgS7agO0UeWo4bkReRrddSDamwLcWyY7RF9
         zYyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762284378; x=1762889178;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b3vZ52GkNsJGLOkvon3L18RWVKcEn1c510aPuA199YI=;
        b=e1lsJEjfSoentnGyYKF5NjW9QBS9sGE2awg7mCCEG3l8ZR6bUyRUkArLf4G/nPKxtb
         +zgZ8lku7hx6oVUYcAo8YgEc9iYYW2Tv5yKVAn3mP7hWbxF5yWhLIJmoyMb9EABQGXft
         WaDNOSXbt9RMEfgSi9+AtvpKV0voo4cEUEuxEcxDPpt9HLR4u81I5MFoKCFF5fD1NRB8
         zz7q1x2c3JddfcJYkn7aRPOjJnFVqXhDxu1bmH9hUevVdYg+jkOs7cdx82IUP1PthiMg
         TaaSCt19Animk2dUX2rgrtYNqhN1/7Gy21T6bN24DkVfFJ7F4w8IJUT7oBQHWhrEtj0P
         IwZA==
X-Forwarded-Encrypted: i=1; AJvYcCWj15kEib7BahqfhtKyyq0iPrSQJuUL3tyf+ibBlRWGaYP7BaGvc4RSAwzXqdDsdrzRadS6QsczaA==@kvack.org
X-Gm-Message-State: AOJu0YzSqPNlmD1S+mgmi5xkMLbIhc83BkcMg8OP4PgBU9DFYW+lT5kr
	/m4DZQIwytsGhQfCcojXelNbwsiM3GFXVKP9lmHuLLmfym501W//2dqSDamPIZl44vQ=
X-Gm-Gg: ASbGncvcwZYwl4mKSvU/HdxkN3LAExPaxx2Zbj3cImufpxBAmPWIQ34IbdFJ5OIY4fb
	jQTOFzNv5/jqPAnf/2t6a1Wrbw5Myi6CBm/KjPQUxudUfo1Bcgm8KEjejQcPgPGmwzmZd0IF0Gf
	DQiNQgJJsF7rSX48ktYXX3fCwKg1o8Zj94uWf2PAlxyqmtKto7/Vg2cmCAna8Kc4ukaGVeMCr7Q
	LFJ4aSCln2bOHEk73eR4PTbRZQGvfFl29aLGbx/SWMa4EXiKHOxyQPehgGXu53u1GSmb+8xqJSH
	zzR0aZEiJIrQ/8Qf4zdOdoqF2H4wikj63UcUVT0YF+YaBrjVR/9otiiUqGi60n7U7IpB3Sxc3Z/
	TwJ8kti8tdlog+vVtfTv/ArkHMU0NMcLPaqsClW3Q7TLfwgkyOuLEjLTxrztIo+5RMwD31WMFHW
	MhdkbGpVIBd9B36QbwEjLqdh0AhfUZo8ea3KEUeeUdL/96Nw==
X-Google-Smtp-Source: AGHT+IFUVGYM+r9VlnujjXwSiyntNScv3JSZn85Gft/uvY+ZvhCxVbalAnSefdp5Rhr2H4+z2gOTFg==
X-Received: by 2002:a05:620a:2a06:b0:86f:aee8:fcbc with SMTP id af79cd13be357-8b220b9ef27mr103417385a.79.1762284377655;
        Tue, 04 Nov 2025 11:26:17 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b0f7bb3e33sm250495385a.39.2025.11.04.11.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 11:26:16 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vGMfY-000000073Bk-1Ldv;
	Tue, 04 Nov 2025 15:26:16 -0400
Date: Tue, 4 Nov 2025 15:26:16 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, iommu@lists.linux.dev,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: Re: [PATCH v6 00/11] vfio/pci: Allow MMIO regions to be exported
 through dma-buf
Message-ID: <20251104192616.GJ1204670@ziepe.ca>
References: <20251102-dmabuf-vfio-v6-0-d773cff0db9f@nvidia.com>
 <aQpRz74RurfhZK15@Asurada-Nvidia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQpRz74RurfhZK15@Asurada-Nvidia>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A946B40008
X-Stat-Signature: nbhu33knw93z6u5jj1tsncbuoh5aeujq
X-Rspam-User: 
X-HE-Tag: 1762284378-804485
X-HE-Meta: U2FsdGVkX18EsA21AjiM2bps9FxnI6HME3zb5k+uSQeaSg77E9k+USwm34y2xUHgWElVfPUMzGvx4aqFTqA38hT49hpGN9cvxkK3Y1Bt4Q0vwKFIih5X6UQ9mw5M9hag5sQgCT7OIUwuJ2are5UODySe2u21j6VePmEg7MLjA2waqWeF3Rgu0ITmj/4dX1x7zRNTIiirz09PIqmJ8sOXA4ZpLXbuBK9fTluKRm4duhBB7PRMY0cpdgG35fcN/DRHJ/2dmRl/PdKJ//spdW4ptpZY0BuYzdXdkvAJ60TkOiy3QhuVfqMpshr7Rgn14THSlzf/1pTwcq7byHcK7T3tYo4o+FVYySrFzhEkzyCJzpw4vA0W99t5Xqmi9KTSPpsaNfWhzLja+tkgJjN4+t80htMmW3dL0rhUw1yGcj+3lM1q1GvUxMQ/JHORmKn0xlLkfOX4AyrfaZG0R0GxMmpNWMFIsugzSm/Bx0blFK05TYVC2nfjFbNx/3AVQv62AAFFfPIvjQsku0K1Q37hJE7GQYaaW9MQu3IdClS4gI+9vPE7brTd2Gg8CpSBtDxZi34BsW16CQRacc+M05Y9vwG4Bg/fCqxtyTwq44FPnbIbDbeJruHNgpCkl2NeOylkGwVxUl6jfsJMDznWrin6NYDWKL9diHFLUngJrs6OV5x44lwQ6/p3o0nsOf4lHdmi23WcupO9zV0NRn6UlEVRT/De9q6gA7WRe2mtRGnMrkiqEQkRVXZzpb8uZsLnfZjOAGgMSPmxo+7lCX0kUxH9Y/ocAGR7agpIFriosnpBMj1C5KCACoY5C4mZN+4USefL5z73dSPPoi2PX2FVLyXT1P3zuFHRPRVrBly2dCKnhccyIGvp0z5CgF5xgQVuU/cqerEFAaN1Tdhqmnf/4A6lwh61jaZD1B92xRUZFj6IFnd3PdrMMkvl0ZiKTfvbv6pR9FOw+i24OvJy710eiLfc5M3
 ZpaeqmuJ
 THmPqlH0xKmKCswDCGSzfHZROEwfTBal/4qNBcc9WbgwKpgS2CWfOkCLkiIXa0JTJ7rqLgbOzo/gvWlHGk1vkspJYVxjDnTrxnVg3bA0OXoSC1RsfhITWcAMu8xLJQ8LIjplwx3P1MENE4EnB8XWlAmOmM5TWNlw485DziPrkAZhXTeiUz34k6fgQRtIvrIypml4PILnUk5zTR8maMtZMG6TUWJ7PEkxii6Nv3OzhKP7LhLNB0nyVcCupWSXV3VUZXfiFAVz4vFeUXTskr91rx8ZZ3Z+zP0iVNplJfKU406bX2yz5oxuUC9C89g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 04, 2025 at 11:19:43AM -0800, Nicolin Chen wrote:
> On Sun, Nov 02, 2025 at 10:00:48AM +0200, Leon Romanovsky wrote:
> > Changelog:
> > v6:
> >  * Fixed wrong error check from pcim_p2pdma_init().
> >  * Documented pcim_p2pdma_provider() function.
> >  * Improved commit messages.
> >  * Added VFIO DMA-BUF selftest.
> >  * Added __counted_by(nr_ranges) annotation to struct vfio_device_feature_dma_buf.
> >  * Fixed error unwind when dma_buf_fd() fails.
> >  * Document latest changes to p2pmem.
> >  * Removed EXPORT_SYMBOL_GPL from pci_p2pdma_map_type.
> >  * Moved DMA mapping logic to DMA-BUF.
> >  * Removed types patch to avoid dependencies between subsystems.
> >  * Moved vfio_pci_dma_buf_move() in err_undo block.
> >  * Added nvgrace patch.
> 
> I have verified this v6 using Jason's iommufd dmabuf branch:
> https://github.com/jgunthorpe/linux/commits/iommufd_dmabuf/
> 
> by drafting a QEMU patch on top of Shameer's vSMMU v5 series:
> https://github.com/nicolinc/qemu/commits/wip/iommufd_dmabuf/
> 
> with that, I see GPU BAR memory be correctly fetched in the QEMU:
> vfio_region_dmabuf Device 0009:01:00.0, region "0009:01:00.0 BAR 0", offset: 0x0, size: 0x1000000
> vfio_region_dmabuf Device 0009:01:00.0, region "0009:01:00.0 BAR 2", offset: 0x0, size: 0x44f00000
> vfio_region_dmabuf Device 0009:01:00.0, region "0009:01:00.0 BAR 4", offset: 0x0, size: 0x17a0000000

Great thanks! This means we finally have a solution to that follow_pfn
lifetime problem in type 1! What a long journey :)

For those following along this same flow will be used with KVM to
allow it to map VFIO as well. Confidential Compute will require this
because some arches can't put confidential MMIO (or RAM) into a VMA.

Jason

