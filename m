Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70772C83F25
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 07:09:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E192B6B0089; Wed, 23 Jul 2025 03:09:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC9136B008A; Wed, 23 Jul 2025 03:09:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB8986B0093; Wed, 23 Jul 2025 03:09:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B6D036B0089
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:09:29 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0405C1405EF
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:09:28 +0000 (UTC)
X-FDA: 83694653658.11.4A0BB81
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf01.hostedemail.com (Postfix) with ESMTP id 917D94000D
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:09:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=FZxoxk6z;
	spf=pass (imf01.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753254567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3xySD9i0zBLuoTU9OsQHvoeq1mQLETgpejNnwDrr/Ak=;
	b=gevJxedA3iC6bnIcTiMU85eInTWIhuYQ8Yyuyq05A8q3zCofwEKlHBVv7m2G6uGaP00O5p
	LKXBhibJOYuZiiwVGA/tTlMgQ0IurTXLWEXAZwvRexCQOfXZK0cbXV3bF6BaGuP7VSqT1y
	fJdjQjn9x1xk+6QeNvRoml8zMbyonN0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753254567; a=rsa-sha256;
	cv=none;
	b=bszHIfo2Fn36kaUXvVAZNVoQepTbztuz0999Zc8FO8UnLvkIaT8EFNYgbdUBJyJrQp5wAM
	9EMXSaYCCQTEUjhAJjT0cyiEhO8pat0XSseatTN8fUiqKn+B36MU0xLhsOOWFzUf2y3/bV
	tYqhR66sdAIAuq7t+L2EC8LVB33wcUw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=FZxoxk6z;
	spf=pass (imf01.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b391ca6146eso5643267a12.3
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 00:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1753254565; x=1753859365; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3xySD9i0zBLuoTU9OsQHvoeq1mQLETgpejNnwDrr/Ak=;
        b=FZxoxk6z3nw9ix/MIHU16ujT6UPYA3uXndhpMRIHctQi8ZhdUmn91jYU1SVp8d8p0r
         VFu9ulROKSQfVDQtF/YpsaL/8lVaQBgYecFoJ4+Q9eKuIEGSNfDYBDhQeuCMCUMA4gdA
         CkKnlbP6uxwJBMLANivzvN/njqPZv6OhNpIZsz2NH/ufVgoVUs7QzjfxSPlCA53FSDFb
         AmJEIIWYNaVn2XZbsXvD/isJGsbFV01JyezpNNEJSvTWuI6QHfIJN6PwZvQkIGu7XpYU
         Z0zfnkPv77c/2YWthkSiRChvJnq39ezTedx9ZNPdo3P8f21b231C/+eamIRgyg8e1kzB
         45Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753254565; x=1753859365;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3xySD9i0zBLuoTU9OsQHvoeq1mQLETgpejNnwDrr/Ak=;
        b=D0IqC7+qH0W0YEbjvILZyEGBjYXlBdoNLJ3KYpw+qfkKN5m/pWaV2PVv17hfFiFHmm
         hH5MrzLQvTEBZtmqs+mBvr5RnuCJbl4hF5mzqSO8bDz4DwUyhkI6CtYHNHWlrhhTpCSG
         GRSQfT1Oc87swwM/UXhnVFUx+UVB+MbCeWF8YWj+iKyZkxzPmGRXVlCeuIaUxQCj35JY
         De9NEsMteAVRQmx/A+6wEBLkJywm+c1uZqq+peXXb+qpkVLgsci6yE4Czeeq8X0IjinM
         BlEZDnO2BqI13zTQNXcNY0ijfaJBJAvZp+2WhRypWUgaZ3SkTtMVHeMAqzU6Nn+xwXGt
         n+Tw==
X-Forwarded-Encrypted: i=1; AJvYcCWhu63IXF920QQupN5dfHDJy1eAWfDZTMkZ/3PFy2BvoTVZ2GsocGxJXNAoBc7O4zE3UfR5mSIH3g==@kvack.org
X-Gm-Message-State: AOJu0YzCwqVpH730KgwuFehh9LDoFzS8vK3V9eZPDi9lgNpDSwM47Xeq
	jWn841kFb5Ctu9E2PbKx9+4zK1phQPhWhdcrymruDiMIhbkvFiTHhvilntSfbbevTPs=
X-Gm-Gg: ASbGncubtaHA61aE+Dy5XxsSmHh8QAiI+/W5nttuN7VxJm2ZFDWDtVkWl2LveUAB79O
	RDrG2WVa/tgnJ0yT6a12aASaMEorHdIeKgG3hg21H1aKWfFmWeBv/EI8/Rszk1EgqgSUerGR220
	LetiowM1PR2Jgl0zxKWL5arK+9pZSvYHxqdNXTkduajKU9alCcRP9Fzgj+NkgiGVw4a5IcCEHfJ
	HpNI5QdTq7ZxHbohCN5Zo6Cv/KVTDE+FKrQ/mdC0iSCWqUY6nsFmyI23t5FFQF7MixDt9DyCQuH
	cbWXsLujfcpGpU8rfcVfRAFczhQPvlNSpTRplNMkdG8OhdP0pst9qq4BnBh8NB1tbHkFL8s1Pmv
	tyTijcWrN9jnWCBzzfLfefsMlpXFO2Dhh7gOYZepYq1zSjBb5QA==
X-Google-Smtp-Source: AGHT+IHL72T+VBVk7DX9rybYzc3VQsWLM+dttqmKHB3AfYHJ8PTIIAzerLdGDE0eCtPQQd7V723y3g==
X-Received: by 2002:a05:6a20:cd91:b0:21f:5598:4c2c with SMTP id adf61e73a8af0-23d49032907mr3134107637.13.1753254564948;
        Wed, 23 Jul 2025 00:09:24 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.14])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b3f2ff99ef4sm8307165a12.61.2025.07.23.00.09.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 23 Jul 2025 00:09:24 -0700 (PDT)
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
Date: Wed, 23 Jul 2025 15:09:17 +0800
Message-ID: <20250723070917.87657-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <1bd50178755535ee0a3b0b2164acf9319079a3d5.camel@linux.ibm.com>
References: <1bd50178755535ee0a3b0b2164acf9319079a3d5.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 917D94000D
X-Stat-Signature: doqruu5gwdcbxw9frmy7nh78qhfeqcb4
X-Rspam-User: 
X-HE-Tag: 1753254566-309307
X-HE-Meta: U2FsdGVkX181/LFC0Kp5rqHtxjntTN0I8dQibD6oh0M3NQyTXRklf0t1ze2XJ2flW44VWcgqJVn2aVgUm/PTH0XoTatGiVtGLAKOwHlqH8wFJIo64EiY9RH8xBL/akUZaPk8B0SvvXWD48BOeJWHZUGsX0yWcdY0/TQ6Q30IHL8/XW4rCXf3H9m/+ed6nzdcAMFkYEtqWBENWt2VrPOkyDQ1z3SYkOjPucX/bDJ7kkKMMvXs1Z1pvdNv36whQ9GQDKf/WwcbKhpVwOjIxHo7kraxEJeasqISRAfSgEAzyOtuCjaJtWCVc5wCueY/K/2ait4CKG33kq1PDyriUdvv5SWOfvhLtwnGSDmAV62QFmu29W5ZbEMomYsWzf8fgju5kWoRCVX0ny+HxhixWAANWCPvQnS3gKss9Fvnnm3HdWm/f0cuPVGmh3KkEj6rxaMRdD2UfH/N/4Z7CPXzNQsYSs0CYDCceHlkU6fNFSlobXsGaOwKk7fd6N7BuDAP87JtT3gvc+hP84UGNBy8gbuBhL70y4lODJPtnWwyasc8SowMA3J7y8B/DMlLHakbA/hzfKAUnex58fziHEhnkxqOvOwDMTE6q+p5pELyFO/ZovzfSgEXhW4Ey9DTUYzbiS9/Gjw0h62WQPvuz0BOVEIgl9ujOaENkDxVZYBC3WBmFeWne84+/GQOv4gVG3anZq4w7yOR88/zDkISmoA5Z5pI+tXfmZheGewUP6lqc0LvT/JhOE4gIuxyy6I14piDMiSmEiJD+zFcotEYexFglYeECizZFkLkWgBfW05qgLrsdlwT9fbtolG7b203pj4kx1sVsZzb84OdPCUF3U4WQQWXaKw7mUKc9Lb0p64SCPXhvdTM3jOEPz4ARvSUhr9XeadXXCBGA6uPVZrVEFZGzbRS26nwNhY8ZljeKKroa0d/ZOZEzkD08ICn3JszLSe6AwURlocstzpyM/K93R3w0hh
 PChN4NCI
 +bCEnQWG75XJ06DB9Gq1/9wifl0upbeUFEThitX+wG81RFETA3GmLfPTtbYJV0iaHDClEB46Y35/ONdAvyhgWjB8PLmU94UzB8e5ALQUYmUhehWlXDPNDnJwtQSmEJm7xHgIJ2MZWLcrZGOe4dwYqs5Xe2WsQIyHTJPjvUjrEoKF/k5pCdRwPBSb7QXlrKH0VydtjEl25+psSFz8WJTikxfSEAb870lX3h/2RNsRTi9SqsCRC+9qlD9agvJtRagPbFtlktweD3vxge0jOTqKGo/fZ9a7gO1fZJ04huGmKxm/DOBw3Rc+WWBg6MRuhF/oHJapenIp1apq+slzZa2YcsO2b7Vsu72HrWul0Edyxr1TSdutZpBdMT7o+VobFju31v3CBMFTSrPqzhqnw8XDTV63btw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 22 Jul 2025 12:32:59 -0400, farman@linux.ibm.com wrote:
 
> On Thu, 2025-07-10 at 16:53 +0800, lizhe.67@bytedance.com wrote:
> > From: Li Zhe <lizhe.67@bytedance.com>
> > 
> > When vfio_pin_pages_remote() is called with a range of addresses that
> > includes large folios, the function currently performs individual
> > statistics counting operations for each page. This can lead to significant
> > performance overheads, especially when dealing with large ranges of pages.
> > Batch processing of statistical counting operations can effectively enhance
> > performance.
> > 
> > In addition, the pages obtained through longterm GUP are neither invalid
> > nor reserved. Therefore, we can reduce the overhead associated with some
> > calls to function is_invalid_reserved_pfn().
> > 
> > The performance test results for completing the 16G VFIO IOMMU DMA mapping
> > are as follows.
> > 
> > Base(v6.16-rc4):
> > ------- AVERAGE (MADV_HUGEPAGE) --------
> > VFIO MAP DMA in 0.047 s (340.2 GB/s)
> > ------- AVERAGE (MAP_POPULATE) --------
> > VFIO MAP DMA in 0.280 s (57.2 GB/s)
> > ------- AVERAGE (HUGETLBFS) --------
> > VFIO MAP DMA in 0.052 s (310.5 GB/s)
> > 
> > With this patch:
> > ------- AVERAGE (MADV_HUGEPAGE) --------
> > VFIO MAP DMA in 0.027 s (602.1 GB/s)
> > ------- AVERAGE (MAP_POPULATE) --------
> > VFIO MAP DMA in 0.257 s (62.4 GB/s)
> > ------- AVERAGE (HUGETLBFS) --------
> > VFIO MAP DMA in 0.031 s (517.4 GB/s)
> > 
> > For large folio, we achieve an over 40% performance improvement.
> > For small folios, the performance test results indicate a
> > slight improvement.
> > 
> > Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> > Co-developed-by: Alex Williamson <alex.williamson@redhat.com>
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > Acked-by: David Hildenbrand <david@redhat.com>
> > ---
> >  drivers/vfio/vfio_iommu_type1.c | 83 ++++++++++++++++++++++++++++-----
> >  1 file changed, 71 insertions(+), 12 deletions(-)
> 
> Hi,
> 
> Our CI started flagging some crashes running vfio-ccw regressions on the -next kernel beginning with
> next-20250717, and bisect points to this particular commit.
> 
> I can reproduce by cherry-picking this series onto 6.16-rc7, so it's not something else lurking.
> Without panic_on_warn, I get a handful of warnings from vfio_remove_dma() (after starting/stopping
> guests with an mdev attached), before eventually triggering a BUG() in vfio_dma_do_unmap() running a
> hotplug test. I've attached an example of a WARNING before the eventual BUG below. I can help debug
> this if more doc is needed, but admit I haven't looked at this patch in any detail yet.
> 
> Thanks,
> Eric
> 
> [  215.671885] ------------[ cut here ]------------
> [  215.671893] WARNING: CPU: 10 PID: 6210 at drivers/vfio/vfio_iommu_type1.c:1204
> vfio_remove_dma+0xda/0xf0 [vfio_iommu_type1]
> [  215.671902] Modules linked in: vhost_vsock vmw_vsock_virtio_transport_common vsock vhost
> vhost_iotlb algif_hash af_alg kvm nft_masq nft_ct nft_reject_ipv4 nf_reject_ipv4 nft_reject act_csum
> cls_u32 sch_htb nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables pkey_pckmo
> s390_trng pkey_ep11 pkey_cca zcrypt_cex4 zcrypt eadm_sch rng_core vfio_ccw mdev vfio_iommu_type1
> vfio drm sch_fq_codel i2c_core drm_panel_orientation_quirks dm_multipath loop nfnetlink ctcm fsm
> zfcp scsi_transport_fc mlx5_ib diag288_wdt mlx5_core ghash_s390 prng aes_s390 des_s390 libdes
> sha3_512_s390 sha3_256_s390 sha512_s390 sha1_s390 sha_common rpcrdma sunrpc rdma_ucm rdma_cm
> configfs iw_cm ib_cm ib_uverbs ib_core scsi_dh_rdac scsi_dh_emc scsi_dh_alua pkey autofs4
> [  215.671946] CPU: 10 UID: 107 PID: 6210 Comm: qemu-system-s39 Kdump: loaded Not tainted 6.16.0-
> rc7-00005-g4ff8295d8d61 #79 NONE 
> [  215.671950] Hardware name: IBM 3906 M05 780 (LPAR)
> [  215.671951] Krnl PSW : 0704c00180000000 000002482f7ee55e (vfio_remove_dma+0xde/0xf0
> [vfio_iommu_type1])
> [  215.671956]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
> [  215.671959] Krnl GPRS: 006d010100000000 000000009d8a4c40 000000008f3b1c80 0000000092ffad20
> [  215.671961]            0000000090b57880 006e010100000000 000000008f3b1c80 000000008f3b1cc8
> [  215.671963]            0000000085b3ff00 000000008f3b1cc0 000000008f3b1c80 0000000092ffad20
> [  215.671964]            000003ff867acfa8 000000008f3b1ca0 000001c8b36c3be0 000001c8b36c3ba8
> [  215.671972] Krnl Code: 000002482f7ee550: c0e53ff9fcc8	brasl	%r14,00000248af72dee0
>            000002482f7ee556: a7f4ffcf		brc	15,000002482f7ee4f4
>           #000002482f7ee55a: af000000		mc	0,0
>           >000002482f7ee55e: a7f4ffa9		brc	15,000002482f7ee4b0
>            000002482f7ee562: 0707		bcr	0,%r7
>            000002482f7ee564: 0707		bcr	0,%r7
>            000002482f7ee566: 0707		bcr	0,%r7
>            000002482f7ee568: 0707		bcr	0,%r7
> [  215.672006] Call Trace:
> [  215.672008]  [<000002482f7ee55e>] vfio_remove_dma+0xde/0xf0 [vfio_iommu_type1] 
> [  215.672013]  [<000002482f7f03de>] vfio_iommu_type1_detach_group+0x3de/0x5f0 [vfio_iommu_type1] 
> [  215.672016]  [<000002482f7d4c4e>] vfio_group_detach_container+0x5e/0x180 [vfio] 
> [  215.672023]  [<000002482f7d2ce0>] vfio_group_fops_release+0x50/0x90 [vfio] 
> [  215.672027]  [<00000248af25e1ee>] __fput+0xee/0x2e0 
> [  215.672031]  [<00000248aef19f18>] task_work_run+0x88/0xd0 
> [  215.672036]  [<00000248aeef559a>] do_exit+0x18a/0x4e0 
> [  215.672042]  [<00000248aeef5ab0>] do_group_exit+0x40/0xc0 
> [  215.672045]  [<00000248aeef5b5e>] __s390x_sys_exit_group+0x2e/0x30 
> [  215.672048]  [<00000248afc81e56>] __do_syscall+0x136/0x340 
> [  215.672054]  [<00000248afc8da7e>] system_call+0x6e/0x90 
> [  215.672058] Last Breaking-Event-Address:
> [  215.672059]  [<000002482f7ee4aa>] vfio_remove_dma+0x2a/0xf0 [vfio_iommu_type1]
> [  215.672062] ---[ end trace 0000000000000000 ]---
> [  219.861940] ------------[ cut here ]------------
> 
> ...
> 
> [  241.164333] ------------[ cut here ]------------
> [  241.164340] kernel BUG at drivers/vfio/vfio_iommu_type1.c:1480!
> [  241.164358] monitor event: 0040 ilc:2 [#1]SMP 
> [  241.164363] Modules linked in: vhost_vsock vmw_vsock_virtio_transport_common vsock vhost
> vhost_iotlb algif_hash af_alg kvm nft_masq nft_ct nft_reject_ipv4 nf_reject_ipv4 nft_reject act_csum
> cls_u32 sch_htb nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables pkey_pckmo
> s390_trng pkey_ep11 pkey_cca zcrypt_cex4 zcrypt eadm_sch rng_core vfio_ccw mdev vfio_iommu_type1
> vfio drm sch_fq_codel i2c_core drm_panel_orientation_quirks dm_multipath loop nfnetlink ctcm fsm
> zfcp scsi_transport_fc mlx5_ib diag288_wdt mlx5_core ghash_s390 prng aes_s390 des_s390 libdes
> sha3_512_s390 sha3_256_s390 sha512_s390 sha1_s390 sha_common rpcrdma sunrpc rdma_ucm rdma_cm
> configfs iw_cm ib_cm ib_uverbs ib_core scsi_dh_rdac scsi_dh_emc scsi_dh_alua pkey autofs4
> [  241.164399] CPU: 14 UID: 107 PID: 6581 Comm: qemu-system-s39 Kdump: loaded Tainted: G        W  
> 6.16.0-rc7-00005-g4ff8295d8d61 #79 NONE 
> [  241.164403] Tainted: [W]=WARN
> [  241.164404] Hardware name: IBM 3906 M05 780 (LPAR)
> [  241.164406] Krnl PSW : 0704e00180000000 000002482f7f132a (vfio_dma_do_unmap+0x4aa/0x4b0
> [vfio_iommu_type1])
> [  241.164413]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
> [  241.164415] Krnl GPRS: 0000000000000000 000000000000000b 0000000040000000 000000008cfdcb40
> [  241.164418]            0000000000001001 0000000000000001 0000000000000000 0000000040000000
> [  241.164419]            0000000000000000 0000000000000000 00000001fbe7f140 000000008cfdcb40
> [  241.164421]            000003ff97dacfa8 0000000000000000 00000000871582c0 000001c8b4177cd0
> [  241.164428] Krnl Code: 000002482f7f131e: a7890000		lghi	%r8,0
>            000002482f7f1322: a7f4feeb		brc	15,000002482f7f10f8
>           #000002482f7f1326: af000000		mc	0,0
>           >000002482f7f132a: 0707		bcr	0,%r7
>            000002482f7f132c: 0707		bcr	0,%r7
>            000002482f7f132e: 0707		bcr	0,%r7
>            000002482f7f1330: c0040000803c	brcl	0,000002482f8013a8
>            000002482f7f1336: eb6ff0480024	stmg	%r6,%r15,72(%r15)
> [  241.164458] Call Trace:
> [  241.164459]  [<000002482f7f132a>] vfio_dma_do_unmap+0x4aa/0x4b0 [vfio_iommu_type1] 
> [  241.164463]  [<000002482f7f1d08>] vfio_iommu_type1_ioctl+0x1c8/0x370 [vfio_iommu_type1] 
> [  241.164466]  [<00000248af27704e>] vfs_ioctl+0x2e/0x70 
> [  241.164471]  [<00000248af278610>] __s390x_sys_ioctl+0xe0/0x100 
> [  241.164474]  [<00000248afc81e56>] __do_syscall+0x136/0x340 
> [  241.164477]  [<00000248afc8da7e>] system_call+0x6e/0x90 
> [  241.164481] Last Breaking-Event-Address:
> [  241.164482]  [<000002482f7f1238>] vfio_dma_do_unmap+0x3b8/0x4b0 [vfio_iommu_type1]
> [  241.164486] Kernel panic - not syncing: Fatal exception: panic_on_oops

Thanks for the report. After a review of this commit, it appears that
only the changes to vfio_find_vpfn() could plausibly account for the
observed issue (I cannot be absolutely certain). Could you kindly test
whether the issue persists after applying the following patch?

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -344,7 +344,7 @@ static struct vfio_pfn *vfio_find_vpfn_range(struct vfio_dma *dma,
 
 static inline struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
 {
-       return vfio_find_vpfn_range(dma, iova, iova + PAGE_SIZE);
+       return vfio_find_vpfn_range(dma, iova, iova + 1);
 }

Thanks,
Zhe

