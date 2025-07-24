Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91171C83F17
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 02:40:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 176416B019F; Wed, 23 Jul 2025 22:40:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 127618E0002; Wed, 23 Jul 2025 22:40:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03E0B6B01A1; Wed, 23 Jul 2025 22:40:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF4256B019F
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 22:40:50 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 654341A024D
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 02:40:50 +0000 (UTC)
X-FDA: 83697605460.26.22C7AEB
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf01.hostedemail.com (Postfix) with ESMTP id AC56040002
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 02:40:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=JvVsm6Dz;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf01.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753324848; a=rsa-sha256;
	cv=none;
	b=0SMDPECQsGoUyRvjDXNauCnFINDz7+Po38pvqcIFw+JOlXJbU6Aj+KwgEM7RJgGzQoUJP1
	R3l0IOSoEy3nnWMDFR45VOfEoqGci2/uLWzDNMPxCEa3EaoHmbTBVelSKKyk3dQQ5M2wzB
	wBMFkJW0YI/a0zZUNaU8gSgATVGKoxI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=JvVsm6Dz;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf01.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753324848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XMDqjQQCjg3m1Fdvyg+HpLMuE8v9dmDLtXOuYMQG03A=;
	b=bUjXi7L4Y3rNMZ3wLoUcRV2Ba0dSftVHO9ofUHMWk0T5DavzgERhBA6+x2JAQOJw6DGp0v
	E12wxjT5rRBnOU+o9BStXgM5VgvHMLV2Lme1x481B3wRhS6SdN5NRdQPIhQSjkJb3uUXms
	TEYKa9VwzTuQTyHjzsAhFjxesZzlkwM=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-23f8d27eeeaso4059115ad.2
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 19:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1753324846; x=1753929646; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XMDqjQQCjg3m1Fdvyg+HpLMuE8v9dmDLtXOuYMQG03A=;
        b=JvVsm6DzcKZNHKMFXkHbM2C8MDGqud06/P9v1KRopz1l5kf9j2JMOsNJ7jiSqceTKH
         tHdfyZe8ChtRlAkgIwngDt9UHjDc1BFu0Z6quuDigpQ53QCWGQjya90NOKcv2HQfw16Z
         BOlp93afMAT/m1mPffYOk/OTrc8WdYaKa93UWA/ApD1Bp7QOhHPqIGAqf2uFamas202e
         kk6xV9xJPRPSh14tG3/RU5hO4tIcf1KoADRgC0/Ir6JuQ3pC2rbQCpxzdU9ieqp9HtMk
         AIuN6FrM1Xl0Jz8/y2qKjyBhvm2v1mcR5ua5nOfQAoMbZ6NULEulqjYZKH2Z4Ie8YeYF
         qoWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753324846; x=1753929646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XMDqjQQCjg3m1Fdvyg+HpLMuE8v9dmDLtXOuYMQG03A=;
        b=IlBCdWTJwBY0KgdRYXNE7Yf6EbPy/0EO8wkz1UwC/7cpXyN+ncwW2DAIWYDciRUPwP
         yM8Iumds2zI7cccykIHBqaC7ODNMV6bKt9hi41wzzMecC0bOzfPsEphHxC4pqXNnWi7D
         eM/vf7bE0q3K0y8Md3wxtRv2SRgl4hGEXyYbxsDSWG6pLQD2dkqCTh3sn5JNjaYCzV9+
         BM6spkvZ/SpL56hfy5U4hHctu4ZtG7DjGziAVx3oeymIDvAxuuny1tOz2ZgrzMOdPHmU
         MyCN0GY83SAUqgm/QYdMyX+jZak9Pd2DW1GZFZYqIUxaW7PSBKTNMnB4YgzRkx9g06Ad
         UASg==
X-Forwarded-Encrypted: i=1; AJvYcCXTqoTpBgYenE+xGub6A5Ax7k6i2v5GTtDl1wkLkKWoUeM7vVJf98jA8uAkOmALIY7/gHvYFPoVHw==@kvack.org
X-Gm-Message-State: AOJu0Yxnkl9MVKHC7CezaR2+eSjPllvfoSKjfFZd1H9DpCtJNQ9IeeR3
	DZncaM0192VSmY6GpP3Ve3PapwhLcAWnu9KSZ9V6xn64NOiiM29Tuxp8kgRRiBsx31I=
X-Gm-Gg: ASbGncsm+WEflV+6mf3DBrYxGCoWVa5ZVq7tty5bEUlgPzvSo0zhQwNPoTZOBvI7eP7
	4/OVcN395wy77LiyWQHoadmF2NjhIbp+Vsf+zv6MjcKdsn/ksmIuFhw8KxQbFk2BNDg+9e+lvkL
	5GepCR8ELyA7TYqazNloBUHjZy47fpyWRYloN2HwjR+ieeg4fHLnGThuMHC6HIeajdzZk75Qbgl
	JWrsELAfxfbmR3Pr4D2xDiEE3segfpZmxRtegLwoamKeC/Qxjh0yKmj/rWaTrjR1jZ3CF83/lJk
	+XCk35srFEPvgp4rtX0rjil/sRzknyM9NnljcBu60UZ9+YrMMa4ncH+rCnQWWQ4afHTkM0ITsIW
	H07abhi1bd1g97/v7rT7sriKj98OrAVgsy2E7OyKlh5IC8FKZ2g==
X-Google-Smtp-Source: AGHT+IEBkFOJwOonnV0vdCxfjovFfviZCegG5ZM8HrGSCts+SkehAeNf110hY1sWS/eW0Y0itTjfPQ==
X-Received: by 2002:a17:903:1ac8:b0:234:b123:b4ff with SMTP id d9443c01a7336-23f9814759dmr90270625ad.21.1753324846233;
        Wed, 23 Jul 2025 19:40:46 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.11])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23fa48fa164sm3321195ad.172.2025.07.23.19.40.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 23 Jul 2025 19:40:45 -0700 (PDT)
From: lizhe.67@bytedance.com
To: farman@linux.ibm.com
Cc: akpm@linux-foundation.org,
	alex.williamson@redhat.com,
	david@redhat.com,
	jgg@ziepe.ca,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lizhe.67@bytedance.com,
	peterx@redhat.com
Subject: Re: [PATCH v4 2/5] vfio/type1: optimize vfio_pin_pages_remote()
Date: Thu, 24 Jul 2025 10:40:38 +0800
Message-ID: <20250724024038.75436-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <f22a8b5b50a140339222bed77f4b670d9008f29b.camel@linux.ibm.com>
References: <f22a8b5b50a140339222bed77f4b670d9008f29b.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AC56040002
X-Stat-Signature: 1ozahx6h15zpsrdwqy37x5pjxrru4h3k
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753324847-251679
X-HE-Meta: U2FsdGVkX18UNIMz0Ct8qvKV3M3vA1lpmq50Rw6BFVMxGsle5GEpfGItXMmeMma4GrvcbLNc5ZS5ELG40Pjs4VgKUa9+ZKmm+dz5NhNxGSR46Lwx22xtWiZ/L6c92qVpvrYy7VDJHf1JhsSfx2ts9DVtshc4JgTCZDsXFwqeR9oJR1ouOsMUHdS/qn+9Nw3kO1AsKC0nUiAuMuN1Nf1G5PMEfAI56ZU+vJJm5febEh5lLBQKxSVz5J+bzcPR3ht5ezyhQOUx3KQd13bWUpYyaGxTvmFd21AdnGkPeaYVSxlJAJR26k1+bBJE5GVqi90C+hrhOHInuxPWPlccphXKCbnCIqYlaJa0ijdrtfw5p/Oi6pLd4eaNPcGNEnuRywFJzbTyc8HoJaItIsiTApi8vJ+gRZAQse4GxRjTGBH6fNcfPWexCWhi3yOGAqOtqKN7zst50XRKs1uhlGWn3ammb7u6Uvmg79TibUbQHFYLqNTPiFtQcvB4I2Q1VGQSNpP91Bqe/3iCN4+bypZ4REZnj7eAHYcsvJMkByZOy9444uC9OAKRAqZHwgzeeN59vSG0y5Ev061Xlfh0qUbkedKJVBLCnqKsbkx8KYe+jGhHsVKGmVnNJsmlbmmLrBz/waqAsFYyBjK/efWR9RG5sFfG9oa2nmGAD8Fz9MdqN/w09NGQujQFlPt+iug8co5eAE6Jf4FzxJgbJq+7OMWfGlJ/uPYdNMV2vCwOP+VLlTKWxXNYpCXEDrdXXPN4aWSwRcgVja1WTbWr8cg8jsHsV3HASr8M1nMrC2YcjcinL/aFQ3quMzXcdTzUnrd/xRmm5u5GGgwvuWgaaKT4qPXiQyLMSyLnoErSJkJwN4S2Jgsb6P3DKYH/coi/V5taqR2LsjiWVXOUjwXuEF5ALQ4w2JednBYvX8KebU4oeMLx8BtZJ+/P+6gqh03uu7v5LAzjrYqbKk11RVqNqESEP+z1glm
 6ldk/1P5
 g5zLpniGaQLG/2aNHjC2h667H0ixaW5LtwZRF46YmobHLzRqw5heKwSXTDP7yKeb8pNoYFJznSenZ3mxTe+/CTKxpZT19iTIYwNqDMBw4/iZpb1Gi6SG4SqDx2RTNYrlUhR14WHrA9uuZ5v4vQQCOq/r8POCD2n1B6ZgarjRM25tn4eNx9AodQgBqZOkWQGZGczMgvKYnKOXXtb9d7/lBGABSohZ/zKZE2iuUFZ1haQhJDgpB/U8Lzzzl873dMrD6URutlB0ECPYCDleBSL/Yevw0DFvml8qvRqEOGPYWfDOnEWKgPLYJkT10qenXs8lUqdLZyqqHq3JKYoDejO+1JS2HZWL891cisAkXdswMyZl3fiq5cVUim7x1izH5fRysqGdTMiafzKYvRga3WKtD9AL92g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 23 Jul 2025 10:41:34 -0400, farman@linux.ibm.com wrote:
 
> On Wed, 2025-07-23 at 15:09 +0800, lizhe.67@bytedance.com wrote:
> > On Tue, 22 Jul 2025 12:32:59 -0400, farman@linux.ibm.com wrote:
> >  
> > > On Thu, 2025-07-10 at 16:53 +0800, lizhe.67@bytedance.com wrote:
> > > > From: Li Zhe <lizhe.67@bytedance.com>
> > > > 
> > > > When vfio_pin_pages_remote() is called with a range of addresses that
> > > > includes large folios, the function currently performs individual
> > > > statistics counting operations for each page. This can lead to significant
> > > > performance overheads, especially when dealing with large ranges of pages.
> > > > Batch processing of statistical counting operations can effectively enhance
> > > > performance.
> > > > 
> > > > In addition, the pages obtained through longterm GUP are neither invalid
> > > > nor reserved. Therefore, we can reduce the overhead associated with some
> > > > calls to function is_invalid_reserved_pfn().
> > > > 
> > > > The performance test results for completing the 16G VFIO IOMMU DMA mapping
> > > > are as follows.
> > > > 
> > > > Base(v6.16-rc4):
> > > > ------- AVERAGE (MADV_HUGEPAGE) --------
> > > > VFIO MAP DMA in 0.047 s (340.2 GB/s)
> > > > ------- AVERAGE (MAP_POPULATE) --------
> > > > VFIO MAP DMA in 0.280 s (57.2 GB/s)
> > > > ------- AVERAGE (HUGETLBFS) --------
> > > > VFIO MAP DMA in 0.052 s (310.5 GB/s)
> > > > 
> > > > With this patch:
> > > > ------- AVERAGE (MADV_HUGEPAGE) --------
> > > > VFIO MAP DMA in 0.027 s (602.1 GB/s)
> > > > ------- AVERAGE (MAP_POPULATE) --------
> > > > VFIO MAP DMA in 0.257 s (62.4 GB/s)
> > > > ------- AVERAGE (HUGETLBFS) --------
> > > > VFIO MAP DMA in 0.031 s (517.4 GB/s)
> > > > 
> > > > For large folio, we achieve an over 40% performance improvement.
> > > > For small folios, the performance test results indicate a
> > > > slight improvement.
> > > > 
> > > > Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> > > > Co-developed-by: Alex Williamson <alex.williamson@redhat.com>
> > > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > > Acked-by: David Hildenbrand <david@redhat.com>
> > > > ---
> > > >  drivers/vfio/vfio_iommu_type1.c | 83 ++++++++++++++++++++++++++++-----
> > > >  1 file changed, 71 insertions(+), 12 deletions(-)
> > > 
> > > Hi,
> > > 
> > > Our CI started flagging some crashes running vfio-ccw regressions on the -next kernel beginning with
> > > next-20250717, and bisect points to this particular commit.
> > > 
> > > I can reproduce by cherry-picking this series onto 6.16-rc7, so it's not something else lurking.
> > > Without panic_on_warn, I get a handful of warnings from vfio_remove_dma() (after starting/stopping
> > > guests with an mdev attached), before eventually triggering a BUG() in vfio_dma_do_unmap() running a
> > > hotplug test. I've attached an example of a WARNING before the eventual BUG below. I can help debug
> > > this if more doc is needed, but admit I haven't looked at this patch in any detail yet.
> > > 
> > > Thanks,
> > > Eric
> > > 
> > > [  215.671885] ------------[ cut here ]------------
> > > [  215.671893] WARNING: CPU: 10 PID: 6210 at drivers/vfio/vfio_iommu_type1.c:1204
> > > vfio_remove_dma+0xda/0xf0 [vfio_iommu_type1]
> > > [  215.671902] Modules linked in: vhost_vsock vmw_vsock_virtio_transport_common vsock vhost
> > > vhost_iotlb algif_hash af_alg kvm nft_masq nft_ct nft_reject_ipv4 nf_reject_ipv4 nft_reject act_csum
> > > cls_u32 sch_htb nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables pkey_pckmo
> > > s390_trng pkey_ep11 pkey_cca zcrypt_cex4 zcrypt eadm_sch rng_core vfio_ccw mdev vfio_iommu_type1
> > > vfio drm sch_fq_codel i2c_core drm_panel_orientation_quirks dm_multipath loop nfnetlink ctcm fsm
> > > zfcp scsi_transport_fc mlx5_ib diag288_wdt mlx5_core ghash_s390 prng aes_s390 des_s390 libdes
> > > sha3_512_s390 sha3_256_s390 sha512_s390 sha1_s390 sha_common rpcrdma sunrpc rdma_ucm rdma_cm
> > > configfs iw_cm ib_cm ib_uverbs ib_core scsi_dh_rdac scsi_dh_emc scsi_dh_alua pkey autofs4
> > > [  215.671946] CPU: 10 UID: 107 PID: 6210 Comm: qemu-system-s39 Kdump: loaded Not tainted 6.16.0-
> > > rc7-00005-g4ff8295d8d61 #79 NONE 
> > > [  215.671950] Hardware name: IBM 3906 M05 780 (LPAR)
> > > [  215.671951] Krnl PSW : 0704c00180000000 000002482f7ee55e (vfio_remove_dma+0xde/0xf0
> > > [vfio_iommu_type1])
> > > [  215.671956]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
> > > [  215.671959] Krnl GPRS: 006d010100000000 000000009d8a4c40 000000008f3b1c80 0000000092ffad20
> > > [  215.671961]            0000000090b57880 006e010100000000 000000008f3b1c80 000000008f3b1cc8
> > > [  215.671963]            0000000085b3ff00 000000008f3b1cc0 000000008f3b1c80 0000000092ffad20
> > > [  215.671964]            000003ff867acfa8 000000008f3b1ca0 000001c8b36c3be0 000001c8b36c3ba8
> > > [  215.671972] Krnl Code: 000002482f7ee550: c0e53ff9fcc8	brasl	%r14,00000248af72dee0
> > >            000002482f7ee556: a7f4ffcf		brc	15,000002482f7ee4f4
> > >           #000002482f7ee55a: af000000		mc	0,0
> > >           >000002482f7ee55e: a7f4ffa9		brc	15,000002482f7ee4b0
> > >            000002482f7ee562: 0707		bcr	0,%r7
> > >            000002482f7ee564: 0707		bcr	0,%r7
> > >            000002482f7ee566: 0707		bcr	0,%r7
> > >            000002482f7ee568: 0707		bcr	0,%r7
> > > [  215.672006] Call Trace:
> > > [  215.672008]  [<000002482f7ee55e>] vfio_remove_dma+0xde/0xf0 [vfio_iommu_type1] 
> > > [  215.672013]  [<000002482f7f03de>] vfio_iommu_type1_detach_group+0x3de/0x5f0 [vfio_iommu_type1] 
> > > [  215.672016]  [<000002482f7d4c4e>] vfio_group_detach_container+0x5e/0x180 [vfio] 
> > > [  215.672023]  [<000002482f7d2ce0>] vfio_group_fops_release+0x50/0x90 [vfio] 
> > > [  215.672027]  [<00000248af25e1ee>] __fput+0xee/0x2e0 
> > > [  215.672031]  [<00000248aef19f18>] task_work_run+0x88/0xd0 
> > > [  215.672036]  [<00000248aeef559a>] do_exit+0x18a/0x4e0 
> > > [  215.672042]  [<00000248aeef5ab0>] do_group_exit+0x40/0xc0 
> > > [  215.672045]  [<00000248aeef5b5e>] __s390x_sys_exit_group+0x2e/0x30 
> > > [  215.672048]  [<00000248afc81e56>] __do_syscall+0x136/0x340 
> > > [  215.672054]  [<00000248afc8da7e>] system_call+0x6e/0x90 
> > > [  215.672058] Last Breaking-Event-Address:
> > > [  215.672059]  [<000002482f7ee4aa>] vfio_remove_dma+0x2a/0xf0 [vfio_iommu_type1]
> > > [  215.672062] ---[ end trace 0000000000000000 ]---
> > > [  219.861940] ------------[ cut here ]------------
> > > 
> > > ...
> > > 
> > > [  241.164333] ------------[ cut here ]------------
> > > [  241.164340] kernel BUG at drivers/vfio/vfio_iommu_type1.c:1480!
> > > [  241.164358] monitor event: 0040 ilc:2 [#1]SMP 
> > > [  241.164363] Modules linked in: vhost_vsock vmw_vsock_virtio_transport_common vsock vhost
> > > vhost_iotlb algif_hash af_alg kvm nft_masq nft_ct nft_reject_ipv4 nf_reject_ipv4 nft_reject act_csum
> > > cls_u32 sch_htb nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables pkey_pckmo
> > > s390_trng pkey_ep11 pkey_cca zcrypt_cex4 zcrypt eadm_sch rng_core vfio_ccw mdev vfio_iommu_type1
> > > vfio drm sch_fq_codel i2c_core drm_panel_orientation_quirks dm_multipath loop nfnetlink ctcm fsm
> > > zfcp scsi_transport_fc mlx5_ib diag288_wdt mlx5_core ghash_s390 prng aes_s390 des_s390 libdes
> > > sha3_512_s390 sha3_256_s390 sha512_s390 sha1_s390 sha_common rpcrdma sunrpc rdma_ucm rdma_cm
> > > configfs iw_cm ib_cm ib_uverbs ib_core scsi_dh_rdac scsi_dh_emc scsi_dh_alua pkey autofs4
> > > [  241.164399] CPU: 14 UID: 107 PID: 6581 Comm: qemu-system-s39 Kdump: loaded Tainted: G        W  
> > > 6.16.0-rc7-00005-g4ff8295d8d61 #79 NONE 
> > > [  241.164403] Tainted: [W]=WARN
> > > [  241.164404] Hardware name: IBM 3906 M05 780 (LPAR)
> > > [  241.164406] Krnl PSW : 0704e00180000000 000002482f7f132a (vfio_dma_do_unmap+0x4aa/0x4b0
> > > [vfio_iommu_type1])
> > > [  241.164413]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
> > > [  241.164415] Krnl GPRS: 0000000000000000 000000000000000b 0000000040000000 000000008cfdcb40
> > > [  241.164418]            0000000000001001 0000000000000001 0000000000000000 0000000040000000
> > > [  241.164419]            0000000000000000 0000000000000000 00000001fbe7f140 000000008cfdcb40
> > > [  241.164421]            000003ff97dacfa8 0000000000000000 00000000871582c0 000001c8b4177cd0
> > > [  241.164428] Krnl Code: 000002482f7f131e: a7890000		lghi	%r8,0
> > >            000002482f7f1322: a7f4feeb		brc	15,000002482f7f10f8
> > >           #000002482f7f1326: af000000		mc	0,0
> > >           >000002482f7f132a: 0707		bcr	0,%r7
> > >            000002482f7f132c: 0707		bcr	0,%r7
> > >            000002482f7f132e: 0707		bcr	0,%r7
> > >            000002482f7f1330: c0040000803c	brcl	0,000002482f8013a8
> > >            000002482f7f1336: eb6ff0480024	stmg	%r6,%r15,72(%r15)
> > > [  241.164458] Call Trace:
> > > [  241.164459]  [<000002482f7f132a>] vfio_dma_do_unmap+0x4aa/0x4b0 [vfio_iommu_type1] 
> > > [  241.164463]  [<000002482f7f1d08>] vfio_iommu_type1_ioctl+0x1c8/0x370 [vfio_iommu_type1] 
> > > [  241.164466]  [<00000248af27704e>] vfs_ioctl+0x2e/0x70 
> > > [  241.164471]  [<00000248af278610>] __s390x_sys_ioctl+0xe0/0x100 
> > > [  241.164474]  [<00000248afc81e56>] __do_syscall+0x136/0x340 
> > > [  241.164477]  [<00000248afc8da7e>] system_call+0x6e/0x90 
> > > [  241.164481] Last Breaking-Event-Address:
> > > [  241.164482]  [<000002482f7f1238>] vfio_dma_do_unmap+0x3b8/0x4b0 [vfio_iommu_type1]
> > > [  241.164486] Kernel panic - not syncing: Fatal exception: panic_on_oops
> > 
> > Thanks for the report. After a review of this commit, it appears that
> > only the changes to vfio_find_vpfn() could plausibly account for the
> > observed issue (I cannot be absolutely certain). Could you kindly test
> > whether the issue persists after applying the following patch?
> 
> Hi Zhe,
> 
> Thank you for the quick patch! I applied this and ran through a few cycles of the previously-
> problematic tests, and things are holding up great.
> 
> It's probably a fixup to the commit here, but FWIW:
> 
> Tested-by: Eric Farman <farman@linux.ibm.com>
> 
> Thanks,
> Eric

Thank you for your feedback. Also I anticipate that this fix-up patch
will leave the optimizations introduced in the original submission
essentially unaffected.

Thanks,
Zhe

> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -344,7 +344,7 @@ static struct vfio_pfn *vfio_find_vpfn_range(struct vfio_dma *dma,
> >  
> >  static inline struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
> >  {
> > -       return vfio_find_vpfn_range(dma, iova, iova + PAGE_SIZE);
> > +       return vfio_find_vpfn_range(dma, iova, iova + 1);
> >  }

