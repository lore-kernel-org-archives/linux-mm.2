Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D77CFC83F26
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 06:59:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 603A16B007B; Fri, 25 Jul 2025 02:59:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 586D76B0088; Fri, 25 Jul 2025 02:59:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44ED66B0089; Fri, 25 Jul 2025 02:59:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2CA9A6B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 02:59:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B0CC914064E
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 06:59:52 +0000 (UTC)
X-FDA: 83701887024.13.F542F8D
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf14.hostedemail.com (Postfix) with ESMTP id 59E6D100009
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 06:59:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=YGlu4xxR;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf14.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753426790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tjib0N0C/5W1FPgGnxKMNcyA430T8Vj0E1zwB3+Uks4=;
	b=6j+GT9PqfjPje1FatkHQZWc/o1kiQ0AMCm05XZw2Pxs/Y69/c1rPKOpmYNFS5Gd9ifGUmp
	9T0LguJK8hJSBAgPKei7++wGywXTMjHMbX8DHMXUb9XcDNRSmBm4SYqj9Gtff16sDi8eH6
	bvnQUFpo9Rm70l05FhGAwFgWXiFzkLQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753426790; a=rsa-sha256;
	cv=none;
	b=bMH/vdbCNcDSBuyHVeF4kudn2qTjpR0sOKnF714SfQozFwnt0v2H1Z43zZM2i8wI6Zok4Z
	7jB03Ao3ZVSwt1ee1DCIBA+octOlfK8QzOyqjHUthX5KEDUcRY5tNBTz7Us66Mwp1eImEr
	MPDlwt3IPldOvJv8koWaenL5dbbBydk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=YGlu4xxR;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf14.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-75bd436d970so1162123b3a.3
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1753426788; x=1754031588; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tjib0N0C/5W1FPgGnxKMNcyA430T8Vj0E1zwB3+Uks4=;
        b=YGlu4xxR3md/1bQHx4eMXTB0lX1T061922EQJyS+jUyTQPFTLKmnBbUhOGAX83UUU+
         38kqP34AuJgzNZIKpmIez71CFfdTanBOAv+hjWGoFva4kGjBx2WBThF6vwLxOsu+TYDo
         ZjLWe8H/Pc0FoM4RCch91em5XwYUwrx9K3UYnHxQVBbTRx51giNTgV8HxKaVgtFF4pUA
         2OrYRtMgVBwhzU83P15I+0n5P0jLDv3dvgphskipK+6ORh2A+dbXS4DLah772ED/qvff
         9Dorf9nj3xLt6vni3HQifVf/4YGo5SxMJASW4SPkPMz53F09LRxiaPcbb1Rx3Fbzb5yM
         DJ1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753426788; x=1754031588;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tjib0N0C/5W1FPgGnxKMNcyA430T8Vj0E1zwB3+Uks4=;
        b=KQkn/H4YrdZx6FJ6J6aLyopMK08cxrjB8O9/2dDv8Z2P6GXjwjvF/uVmR8IN/5S1iV
         25Mz3MVZ1hSwZ2N6a0TSaduLJtyDX2gMoBtfeLIOl4edGQOuKLRz3AsOGVGP6i6m7/MX
         S8O/Oawxepd3FZphK7fozlnpRqoRYAAOm9iDjMLa+9EhkXUdv+vqsRlW3FduRTbLfpVH
         V8WX3R7sdCr7C8WKzQyMZOPUiSTkhrK99+0gE2JBkFkBi6xUMctVzFAjKjNB5QbUc0R8
         5yS1VOJREPTTbDnf5H0jRj3Hzxidsg1/EELdOGjP72/745+V76UfIsqLNdFRHqepPWaI
         AGRg==
X-Forwarded-Encrypted: i=1; AJvYcCUEEBYjAMc5oFoRKfVK0TXH48nNoeTXV8ry1AQwJSPW4AfA9mtbrTImjBQlL0Oh3d2/3R8IsbhrTg==@kvack.org
X-Gm-Message-State: AOJu0YxhOd/cEvsYUS/hycWnAGY2LTGkh9q6peN80wqRLkIKhL5Rd47J
	IctFa+nAbBrF9PROZKcx7OqzaW6YQyUvjz/o7qLqIx8lSP5BxlxMlXwNRZSkfxlFmX4=
X-Gm-Gg: ASbGnctMWzmpfg7P6xIJM7lb1NrNDhX19HyhZZx+SmnQsMRvJlQ8cZoe5RdSyIcnWYJ
	Y6ZNT70DzYr/qkNLeDpSrEYcWzoMDxyxyC6IYdhmzQUigW/DBraAJcR00S0PAqLKPLsVANLShKC
	kEwmvNJrjpk3XbI95QalFgDmR+A9MwOZBaN0j2n/TLASjLm8/odast2C5LC4VWWBKBBOIsj2Hnr
	wRB4MuZL1TkwdNHidp27l3vr/0DZ+Kehj8jw2BkCE9/NFQYCmoFDaEU812Z3ki3pA4llmKWdgs8
	60GRHEs6DPMcb+Hnso5xo44Vq0OBwPpC4oiCjER/UOJY8W3cCYPhnvCUZyLyRcxjC4X2LcBFc/7
	/uTTrs/6ir4VdOKDZSIFoeLuj2FtmceLzo9iqtsAqV7Hr4bC0rTo=
X-Google-Smtp-Source: AGHT+IGDFWL1llphxSV+WXzXHCIbvfIXfDSzx0etwKEoCZ3cJSqZYmwVfE2aHNC7StMOBKVLL67KQQ==
X-Received: by 2002:a05:6a00:2e1c:b0:739:50c0:b3fe with SMTP id d2e1a72fcca58-763328614ebmr1758142b3a.8.1753426787734;
        Thu, 24 Jul 2025 23:59:47 -0700 (PDT)
Received: from localhost.localdomain ([139.177.225.228])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-761b06199a8sm3147099b3a.112.2025.07.24.23.59.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 24 Jul 2025 23:59:47 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com,
	farman@linux.ibm.com
Cc: akpm@linux-foundation.org,
	david@redhat.com,
	jgg@ziepe.ca,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lizhe.67@bytedance.com,
	peterx@redhat.com
Subject: Re: [PATCH v4 2/5] vfio/type1: optimize vfio_pin_pages_remote()
Date: Fri, 25 Jul 2025 14:59:37 +0800
Message-ID: <20250725065937.65848-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250724105608.73b05a24.alex.williamson@redhat.com>
References: <20250724105608.73b05a24.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 59E6D100009
X-Stat-Signature: zffzo8dx1u5hn35gqe8um8bkrrz1wmra
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753426789-2726
X-HE-Meta: U2FsdGVkX1+NTTJRqXeYbK3vlnxufQsHmWKC+IYEyhtSfEGIecYalAUwIS6h5bLywEZqqR0o6EUkxyX3cMZxiT/ywaYQNV4wx5jY53NxL4WnTIDTVUN88jr5ciR2myIClndFNQfaK9mi7v8kkExmbLXjAA16fTsEKsIUZpr4QS14RwHw0hP5edOR+OOGc+Qm6mGizLnmHLDhMZc6p5bM23ag4ODDj/VOF/rJtImIdam9ITYq/NrvKDeGxs7I9qomMrfJPhA55s4CFsQORA8c8u0GiJqO/zQVMrEoNQ4VZfMeojS7HSnkEqBCGY6HGYOZorC5Knhd9L5O1L5LXcKxU0SIp2VPJSr5MxDXCcACuJm9YWyTB4GuIpAJs1in79alF+MTYBX2Mu0hM1i24BtPb7vDNpxRo/RrHqV8zPuwf+tsimHkgoX+4J1FetYZrc9+04TjjPdc5Dc/X/hKECb1awbca7e27cEgSZv9EjADZY34Na6ZP8ugiRg+2+suv6ucI4lvrGHdFf07dOZhA7hFzmQHFBMPWg+GYe7h6nhnsNPT5seWDSeHksNSrv3ZJgVDS9wpcofHo2z6Oux+hhX4lDh536F1SpcZTc6OkNaGoUNtIBt8O5zA7nLaclsVzEHG4x2MgjkNV1eR1iDwt6jMHTR5EWhUk5xuIKw5YUls3QSKgWK7c6aN5CdE7uphzroguPjOAijr7PunLJFHjhRIhtDSCxde4cNml38SiyBN6JJ0CoAMGPp+BtDPEh5D1yXPwTtFQC8H8/PInuUbD2X3KZXgeaFzK6wuRwvx1oZjXz+HmcsMQx8cGnijwHHiO4LKIBsu0u/6/ToaWV+RG1bOwUA8hdPo/GpgOoXg9vJ3lBf18iEWUwYfW41gXTTixBaU44UY65roVXheyS81RZoxzkLw+4U5LNSoMO3M8G66BUklTKHF2Y2SDnaNPOSiIQZafeu84izXZ6igHCd0tQn
 rI6LvlkW
 nqCWBotVSbb6yFhZUCA7nSDNFcl5NJmN69GMRhBKa34ko46+6maIWMhg5G6ygulnU5nqv0zg+/LklQsagMYBAP8ZemMW/pA8qSgn4eLVQdlN7p5APaJ5yY7QpBWJZV/D635oJBcBxZ/nTcrk5PFlkEkF8DCAqmD95J7lXiFd7RY5kCk7Nbs2EL+fuUxc5vWUGWJbuWRjJh4lhKNwJp16A1aasYp7Ybz7aM254t3PW6/pJ5hlejXVptqEnWPPS0/2oo0x6iHQsBXQH6v5JSMVb8nCTIIOAWez3vU9YCyqRDGzcoQWGA1ZvgIFjTM+xIDX/rDhQPk8DEwvBw1eLT2F5tEPimmH1zBDjwtjYOZEcbh6GHtjn50i5p0MhBtBMHX12uWmcyEAsmRQBRltJVdW4BF1OYA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 24 Jul 2025 10:56:08 -0600, alex.williamson@redhat.com wrote:
 
> On Thu, 24 Jul 2025 10:40:38 +0800
> lizhe.67@bytedance.com wrote:
> 
> > On Wed, 23 Jul 2025 10:41:34 -0400, farman@linux.ibm.com wrote:
> >  
> > > On Wed, 2025-07-23 at 15:09 +0800, lizhe.67@bytedance.com wrote:  
> > > > On Tue, 22 Jul 2025 12:32:59 -0400, farman@linux.ibm.com wrote:
> > > >    
> > > > > On Thu, 2025-07-10 at 16:53 +0800, lizhe.67@bytedance.com wrote:  
> > > > > > From: Li Zhe <lizhe.67@bytedance.com>
> > > > > > 
> > > > > > When vfio_pin_pages_remote() is called with a range of addresses that
> > > > > > includes large folios, the function currently performs individual
> > > > > > statistics counting operations for each page. This can lead to significant
> > > > > > performance overheads, especially when dealing with large ranges of pages.
> > > > > > Batch processing of statistical counting operations can effectively enhance
> > > > > > performance.
> > > > > > 
> > > > > > In addition, the pages obtained through longterm GUP are neither invalid
> > > > > > nor reserved. Therefore, we can reduce the overhead associated with some
> > > > > > calls to function is_invalid_reserved_pfn().
> > > > > > 
> > > > > > The performance test results for completing the 16G VFIO IOMMU DMA mapping
> > > > > > are as follows.
> > > > > > 
> > > > > > Base(v6.16-rc4):
> > > > > > ------- AVERAGE (MADV_HUGEPAGE) --------
> > > > > > VFIO MAP DMA in 0.047 s (340.2 GB/s)
> > > > > > ------- AVERAGE (MAP_POPULATE) --------
> > > > > > VFIO MAP DMA in 0.280 s (57.2 GB/s)
> > > > > > ------- AVERAGE (HUGETLBFS) --------
> > > > > > VFIO MAP DMA in 0.052 s (310.5 GB/s)
> > > > > > 
> > > > > > With this patch:
> > > > > > ------- AVERAGE (MADV_HUGEPAGE) --------
> > > > > > VFIO MAP DMA in 0.027 s (602.1 GB/s)
> > > > > > ------- AVERAGE (MAP_POPULATE) --------
> > > > > > VFIO MAP DMA in 0.257 s (62.4 GB/s)
> > > > > > ------- AVERAGE (HUGETLBFS) --------
> > > > > > VFIO MAP DMA in 0.031 s (517.4 GB/s)
> > > > > > 
> > > > > > For large folio, we achieve an over 40% performance improvement.
> > > > > > For small folios, the performance test results indicate a
> > > > > > slight improvement.
> > > > > > 
> > > > > > Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> > > > > > Co-developed-by: Alex Williamson <alex.williamson@redhat.com>
> > > > > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > > > > Acked-by: David Hildenbrand <david@redhat.com>
> > > > > > ---
> > > > > >  drivers/vfio/vfio_iommu_type1.c | 83 ++++++++++++++++++++++++++++-----
> > > > > >  1 file changed, 71 insertions(+), 12 deletions(-)  
> > > > > 
> > > > > Hi,
> > > > > 
> > > > > Our CI started flagging some crashes running vfio-ccw regressions on the -next kernel beginning with
> > > > > next-20250717, and bisect points to this particular commit.
> > > > > 
> > > > > I can reproduce by cherry-picking this series onto 6.16-rc7, so it's not something else lurking.
> > > > > Without panic_on_warn, I get a handful of warnings from vfio_remove_dma() (after starting/stopping
> > > > > guests with an mdev attached), before eventually triggering a BUG() in vfio_dma_do_unmap() running a
> > > > > hotplug test. I've attached an example of a WARNING before the eventual BUG below. I can help debug
> > > > > this if more doc is needed, but admit I haven't looked at this patch in any detail yet.
> > > > > 
> > > > > Thanks,
> > > > > Eric
> > > > > 
> > > > > [  215.671885] ------------[ cut here ]------------
> > > > > [  215.671893] WARNING: CPU: 10 PID: 6210 at drivers/vfio/vfio_iommu_type1.c:1204
> > > > > vfio_remove_dma+0xda/0xf0 [vfio_iommu_type1]
> > > > > [  215.671902] Modules linked in: vhost_vsock vmw_vsock_virtio_transport_common vsock vhost
> > > > > vhost_iotlb algif_hash af_alg kvm nft_masq nft_ct nft_reject_ipv4 nf_reject_ipv4 nft_reject act_csum
> > > > > cls_u32 sch_htb nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables pkey_pckmo
> > > > > s390_trng pkey_ep11 pkey_cca zcrypt_cex4 zcrypt eadm_sch rng_core vfio_ccw mdev vfio_iommu_type1
> > > > > vfio drm sch_fq_codel i2c_core drm_panel_orientation_quirks dm_multipath loop nfnetlink ctcm fsm
> > > > > zfcp scsi_transport_fc mlx5_ib diag288_wdt mlx5_core ghash_s390 prng aes_s390 des_s390 libdes
> > > > > sha3_512_s390 sha3_256_s390 sha512_s390 sha1_s390 sha_common rpcrdma sunrpc rdma_ucm rdma_cm
> > > > > configfs iw_cm ib_cm ib_uverbs ib_core scsi_dh_rdac scsi_dh_emc scsi_dh_alua pkey autofs4
> > > > > [  215.671946] CPU: 10 UID: 107 PID: 6210 Comm: qemu-system-s39 Kdump: loaded Not tainted 6.16.0-
> > > > > rc7-00005-g4ff8295d8d61 #79 NONE 
> > > > > [  215.671950] Hardware name: IBM 3906 M05 780 (LPAR)
> > > > > [  215.671951] Krnl PSW : 0704c00180000000 000002482f7ee55e (vfio_remove_dma+0xde/0xf0
> > > > > [vfio_iommu_type1])
> > > > > [  215.671956]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
> > > > > [  215.671959] Krnl GPRS: 006d010100000000 000000009d8a4c40 000000008f3b1c80 0000000092ffad20
> > > > > [  215.671961]            0000000090b57880 006e010100000000 000000008f3b1c80 000000008f3b1cc8
> > > > > [  215.671963]            0000000085b3ff00 000000008f3b1cc0 000000008f3b1c80 0000000092ffad20
> > > > > [  215.671964]            000003ff867acfa8 000000008f3b1ca0 000001c8b36c3be0 000001c8b36c3ba8
> > > > > [  215.671972] Krnl Code: 000002482f7ee550: c0e53ff9fcc8	brasl	%r14,00000248af72dee0
> > > > >            000002482f7ee556: a7f4ffcf		brc	15,000002482f7ee4f4
> > > > >           #000002482f7ee55a: af000000		mc	0,0  
> > > > >           >000002482f7ee55e: a7f4ffa9		brc	15,000002482f7ee4b0  
> > > > >            000002482f7ee562: 0707		bcr	0,%r7
> > > > >            000002482f7ee564: 0707		bcr	0,%r7
> > > > >            000002482f7ee566: 0707		bcr	0,%r7
> > > > >            000002482f7ee568: 0707		bcr	0,%r7
> > > > > [  215.672006] Call Trace:
> > > > > [  215.672008]  [<000002482f7ee55e>] vfio_remove_dma+0xde/0xf0 [vfio_iommu_type1] 
> > > > > [  215.672013]  [<000002482f7f03de>] vfio_iommu_type1_detach_group+0x3de/0x5f0 [vfio_iommu_type1] 
> > > > > [  215.672016]  [<000002482f7d4c4e>] vfio_group_detach_container+0x5e/0x180 [vfio] 
> > > > > [  215.672023]  [<000002482f7d2ce0>] vfio_group_fops_release+0x50/0x90 [vfio] 
> > > > > [  215.672027]  [<00000248af25e1ee>] __fput+0xee/0x2e0 
> > > > > [  215.672031]  [<00000248aef19f18>] task_work_run+0x88/0xd0 
> > > > > [  215.672036]  [<00000248aeef559a>] do_exit+0x18a/0x4e0 
> > > > > [  215.672042]  [<00000248aeef5ab0>] do_group_exit+0x40/0xc0 
> > > > > [  215.672045]  [<00000248aeef5b5e>] __s390x_sys_exit_group+0x2e/0x30 
> > > > > [  215.672048]  [<00000248afc81e56>] __do_syscall+0x136/0x340 
> > > > > [  215.672054]  [<00000248afc8da7e>] system_call+0x6e/0x90 
> > > > > [  215.672058] Last Breaking-Event-Address:
> > > > > [  215.672059]  [<000002482f7ee4aa>] vfio_remove_dma+0x2a/0xf0 [vfio_iommu_type1]
> > > > > [  215.672062] ---[ end trace 0000000000000000 ]---
> > > > > [  219.861940] ------------[ cut here ]------------
> > > > > 
> > > > > ...
> > > > > 
> > > > > [  241.164333] ------------[ cut here ]------------
> > > > > [  241.164340] kernel BUG at drivers/vfio/vfio_iommu_type1.c:1480!
> > > > > [  241.164358] monitor event: 0040 ilc:2 [#1]SMP 
> > > > > [  241.164363] Modules linked in: vhost_vsock vmw_vsock_virtio_transport_common vsock vhost
> > > > > vhost_iotlb algif_hash af_alg kvm nft_masq nft_ct nft_reject_ipv4 nf_reject_ipv4 nft_reject act_csum
> > > > > cls_u32 sch_htb nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables pkey_pckmo
> > > > > s390_trng pkey_ep11 pkey_cca zcrypt_cex4 zcrypt eadm_sch rng_core vfio_ccw mdev vfio_iommu_type1
> > > > > vfio drm sch_fq_codel i2c_core drm_panel_orientation_quirks dm_multipath loop nfnetlink ctcm fsm
> > > > > zfcp scsi_transport_fc mlx5_ib diag288_wdt mlx5_core ghash_s390 prng aes_s390 des_s390 libdes
> > > > > sha3_512_s390 sha3_256_s390 sha512_s390 sha1_s390 sha_common rpcrdma sunrpc rdma_ucm rdma_cm
> > > > > configfs iw_cm ib_cm ib_uverbs ib_core scsi_dh_rdac scsi_dh_emc scsi_dh_alua pkey autofs4
> > > > > [  241.164399] CPU: 14 UID: 107 PID: 6581 Comm: qemu-system-s39 Kdump: loaded Tainted: G        W  
> > > > > 6.16.0-rc7-00005-g4ff8295d8d61 #79 NONE 
> > > > > [  241.164403] Tainted: [W]=WARN
> > > > > [  241.164404] Hardware name: IBM 3906 M05 780 (LPAR)
> > > > > [  241.164406] Krnl PSW : 0704e00180000000 000002482f7f132a (vfio_dma_do_unmap+0x4aa/0x4b0
> > > > > [vfio_iommu_type1])
> > > > > [  241.164413]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
> > > > > [  241.164415] Krnl GPRS: 0000000000000000 000000000000000b 0000000040000000 000000008cfdcb40
> > > > > [  241.164418]            0000000000001001 0000000000000001 0000000000000000 0000000040000000
> > > > > [  241.164419]            0000000000000000 0000000000000000 00000001fbe7f140 000000008cfdcb40
> > > > > [  241.164421]            000003ff97dacfa8 0000000000000000 00000000871582c0 000001c8b4177cd0
> > > > > [  241.164428] Krnl Code: 000002482f7f131e: a7890000		lghi	%r8,0
> > > > >            000002482f7f1322: a7f4feeb		brc	15,000002482f7f10f8
> > > > >           #000002482f7f1326: af000000		mc	0,0  
> > > > >           >000002482f7f132a: 0707		bcr	0,%r7  
> > > > >            000002482f7f132c: 0707		bcr	0,%r7
> > > > >            000002482f7f132e: 0707		bcr	0,%r7
> > > > >            000002482f7f1330: c0040000803c	brcl	0,000002482f8013a8
> > > > >            000002482f7f1336: eb6ff0480024	stmg	%r6,%r15,72(%r15)
> > > > > [  241.164458] Call Trace:
> > > > > [  241.164459]  [<000002482f7f132a>] vfio_dma_do_unmap+0x4aa/0x4b0 [vfio_iommu_type1] 
> > > > > [  241.164463]  [<000002482f7f1d08>] vfio_iommu_type1_ioctl+0x1c8/0x370 [vfio_iommu_type1] 
> > > > > [  241.164466]  [<00000248af27704e>] vfs_ioctl+0x2e/0x70 
> > > > > [  241.164471]  [<00000248af278610>] __s390x_sys_ioctl+0xe0/0x100 
> > > > > [  241.164474]  [<00000248afc81e56>] __do_syscall+0x136/0x340 
> > > > > [  241.164477]  [<00000248afc8da7e>] system_call+0x6e/0x90 
> > > > > [  241.164481] Last Breaking-Event-Address:
> > > > > [  241.164482]  [<000002482f7f1238>] vfio_dma_do_unmap+0x3b8/0x4b0 [vfio_iommu_type1]
> > > > > [  241.164486] Kernel panic - not syncing: Fatal exception: panic_on_oops  
> > > > 
> > > > Thanks for the report. After a review of this commit, it appears that
> > > > only the changes to vfio_find_vpfn() could plausibly account for the
> > > > observed issue (I cannot be absolutely certain). Could you kindly test
> > > > whether the issue persists after applying the following patch?  
> > > 
> > > Hi Zhe,
> > > 
> > > Thank you for the quick patch! I applied this and ran through a few cycles of the previously-
> > > problematic tests, and things are holding up great.
> > > 
> > > It's probably a fixup to the commit here, but FWIW:
> > > 
> > > Tested-by: Eric Farman <farman@linux.ibm.com>
> > > 
> > > Thanks,
> > > Eric  
> > 
> > Thank you for your feedback. Also I anticipate that this fix-up patch
> > will leave the optimizations introduced in the original submission
> > essentially unaffected.
> 
> Hi Zhe,
> 
> Thanks for the fix.  Could you please send this as a formal follow-on
> fix path with Eric's Tested-by and documenting the issue?  Thanks,

Hi Alex,

I will prepare and resend a fix-up patch.

In my view, the root cause is not this patchset itself; rather, it
appears that some kernel-space drivers invoke
vfio_device_container_pin_pages() with an iova that is not
PAGE_SIZE-aligned (I am not entirely certain. Hi Eric, could you please
help verify this?). Our current patchset changes vfio_find_vpfn()
from exact-iova matching to the interval [iova, iova + PAGE_SIZE).
When vfio_unpin_page_external() removes a struct vfio_pfn, it may
locate the wrong vpfn. This leaves the vpfn red-black tree non-empty,
triggering the WARN and BUG reported in the issue. How about we correct
this logic first, and then reassess whether an alignment check should
be added inside vfio_device_container_pin_pages().

Please correct me if I am wrong.

Thanks,
Zhe

> > > > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > > > --- a/drivers/vfio/vfio_iommu_type1.c
> > > > +++ b/drivers/vfio/vfio_iommu_type1.c
> > > > @@ -344,7 +344,7 @@ static struct vfio_pfn *vfio_find_vpfn_range(struct vfio_dma *dma,
> > > >  
> > > >  static inline struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
> > > >  {
> > > > -       return vfio_find_vpfn_range(dma, iova, iova + PAGE_SIZE);
> > > > +       return vfio_find_vpfn_range(dma, iova, iova + 1);
> > > >  }  
> > 

