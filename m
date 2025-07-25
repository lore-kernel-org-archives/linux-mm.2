Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20791C83F26
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 07:01:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B57196B0089; Fri, 25 Jul 2025 03:01:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B078E6B008A; Fri, 25 Jul 2025 03:01:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F7056B008C; Fri, 25 Jul 2025 03:01:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8CD7C6B0089
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 03:01:22 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 732A31DA576
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 07:01:21 +0000 (UTC)
X-FDA: 83701890762.10.A4B20DB
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id 841B710000C
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 07:01:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ifLVxo5a;
	spf=pass (imf14.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753426879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uC8VgqJ1hxS3HBaKIpxr+jz/YhcoEyBsA0EuNdN/npA=;
	b=UXvBj/Qj7Y+tJFYRDO1whXpeQ8SxxSY6DLj4lXkHHgPA/z5ht13s385tVhovQ8uM61GgM9
	u7xm7+JhpWzCh/JihnL/y0JuESOPPJaIGkUC1xG4uNpRjfaaEGq+LPyeK80pQLSWGkdnnW
	FlPYpAd3qjhFvA8WUFXTPg8URVOZt2A=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ifLVxo5a;
	spf=pass (imf14.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753426879; a=rsa-sha256;
	cv=none;
	b=HCoT1+yIr+6D4jE9xjO9WudzdHvxQRumB2WVLenbrNK2exFLVSp2vCJRfZPha8q2Af4bCU
	9GrH+jXDCpTrAbKy9MN82+4nUBcHPS/HjNOXyHmVlVomwFO6tSSU2wYTm+n8IbhG2okgYl
	SvIPpj9wdyADVTs5cr+cFmpMSMuH1kU=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-235d6de331fso22656015ad.3
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 00:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1753426878; x=1754031678; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uC8VgqJ1hxS3HBaKIpxr+jz/YhcoEyBsA0EuNdN/npA=;
        b=ifLVxo5aUIuXEsG/QYxPi/6u16slozYRVxOB2FM2jVlFODc9mR5u4Vgl+BZUwSuSjh
         0JaF8dQXNNj0FiUdvuLvTLJV9zxwRlu1cMe0DAhsLzfTZX6R3VqygcusZdvN0PZ5JXD7
         4RGaAUMRQA+Wvfg8HOw8ec9cceLFkCCPFwl4ioc9nIeXXKF6DFurR291TaYvp+F/GlZg
         nbW0s5Bv/9X/onnGJgK4ZO/uuFdhoOcrCHg1fi83NKbTH24zHAR/hAqpmu0hvKPTDKT/
         Di6UU0iLaj0VkkKazNNUDK1woOKY57SodIk1++fF4/rmjn9IKRFQg4wPj6+qhvS4VKU3
         SIQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753426878; x=1754031678;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uC8VgqJ1hxS3HBaKIpxr+jz/YhcoEyBsA0EuNdN/npA=;
        b=oWwTF2tPFeO35e27ihw7+KQrvG9al8/GGA7vygJUcRrCo3sBYwfQOaIlRRCZGR+0lS
         +PuBI/XN6RqPsNj7ChnFAkxlZ+KdTt6HfeEOfJzGkOTsEnr+DjO1KEs799ArW9vDiLgp
         xNRoOOUsm09MzRKcRGyRvk3O6ASKq3OA9WDM3LRffz12W8JOz/N/9gZLefKODKEM32T7
         DSzZpRe0wA4Cl5ErgeRY1d3vuni8iX7jCx197/0garwh3/+wOzmSYAjicf+kcBVADN+J
         lTsi3EYEmb46hAiCg9MoQvkbUzBM7erXxx47wfD1aeAGUyAnC3db0G6UX7ydH0vcJWxJ
         sx9g==
X-Forwarded-Encrypted: i=1; AJvYcCVJp67GtVLnFDNXfwjVqBwHVq5ZVK8L/ZnJvCGWCttfP9ktA1a3uh1LdclWeINEmgp+NxctfJgQOg==@kvack.org
X-Gm-Message-State: AOJu0YwIVX6MWWdFgRIRfcmvnIpQfPfhxO9EbtcVvCjwxaEirexLRRfu
	lPjd29SHgnud2Fh3ECaPWjMqfqUfyVvLZKVgzkFWvhmauP8cgS0nk8sCzjDWSN3OqwBsLquwhRB
	4DdjZ
X-Gm-Gg: ASbGnctiaZYZtOExAM2aYrxmAhzw5GIOkK1gDUcEkotQ9Eq+Dm6+r9HkfQaY+yZfp9B
	pLPX9G7GCsiOpQZKM6frUsJ5gaNUcIX4SRWkXJm+hELHuk2MztG/v2XF5RuAgXENCo+FDUTW5Bu
	5HPojOjKNbBlvHjKxEX0skBT9x3pKACslCG+EhIVMservTBDH60p0IVHjSu9W39vViKRZu6878V
	WOn1sW+5Tirv+vaScTmgtbn9lTjPxlqPLXw/viY9OGoCqeG9AIC5D9OvVq7yCmevQJDinceRmpz
	rthEspA6ZGwL+uFrC86K2cJnAmez/MgCA0Fijn/1jwmSE9oOMPV1D1OMsP8ABxanC5zbk+4Rj/d
	CoWFCELZ4vl+HwrDs6pC314e0MbVfnmMxE58faCMhqvymRaiLFdE=
X-Google-Smtp-Source: AGHT+IHH6bvAYxaayBdPgxZosRavvzvKeFt758W686KNMaUVJWeBq1sUpAZ0vLh2LG58pdoikFczFQ==
X-Received: by 2002:a17:902:e801:b0:234:bef7:e227 with SMTP id d9443c01a7336-23fb302672cmr12010825ad.18.1753426878039;
        Fri, 25 Jul 2025 00:01:18 -0700 (PDT)
Received: from localhost.localdomain ([139.177.225.228])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23fa47846c7sm30252765ad.72.2025.07.25.00.01.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 25 Jul 2025 00:01:17 -0700 (PDT)
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
Subject: [FIXUP] vfio/type1: correct logic of vfio_find_vpfn()
Date: Fri, 25 Jul 2025 15:00:54 +0800
Message-ID: <20250725070054.66497-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250724105608.73b05a24.alex.williamson@redhat.com>
References: <20250724105608.73b05a24.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 841B710000C
X-Rspamd-Server: rspam06
X-Stat-Signature: 36hh9km49tmqx19wnhrjcwe4rohuuf5o
X-HE-Tag: 1753426879-20032
X-HE-Meta: U2FsdGVkX18KympIS0Ui/qdkUO2Ibd2aZAUs5uAzOLPvXEdMWlq2JcfeU9WQe5ecmpcnRK2znRFK0EfVPuureLK2hwM6t3k1oyza47XG6u4wb49ELFediqkOg7zyiQQb8zYX4Dt4kjvw+RTGS69d3D4blRUJLTLiTsFm4nVziWlQ+V8Tyc+Onmr2LoEaRcvWYa36PS7NPsa5hi+xABTutywIXu0cZSqLibE95zPCjTXQNOR9xzATkdHzp3tOqdVUDKwHT86LfwZPHzSLHe5fQ0l/1mmC4fG2LbiH0q/7KCHxOXOwItfh+QJwsDLEHoZffzASSL16oHCei/ht0wgMdo96XCNMuZoJnC2cenPMN/gQLpFEqG9R1gxu5PbRiZdYTJnT82jha7OMI+Dl6JM8CkSSMkWDlX+EzAyCVtPSxUt2obysBjUhbhg5CzM90zL82HtBw1ReP5reRDwtBKPJvIBd2vrIlUZmJbfOYXS4IxVZ2Sobp4tHgS7cQIxD2MF0HyJ/PzO4/A/FS9m9hpA3omt+yVvEDlAEMnccpRLmzEsF2ZS9fQMK04zDow/Td4qDVzBXCsUzVqLLO6KOBSdeEpAI+2i8pmDBdy2gdrOu93KVY6FeZSUAXrWIWbKLKjmQ2X6A4cJfk+ahRAuzCAYRiuBBzQNHwkbAOUIKx7tBO3r/+l0kyi7b/QRrSSRJjofimXGTx/oDxuWczHzD+tTdA9GbCXCvjWB7OMf8AawsrdJm+7d3ezRiEx8jBMEJ3Sm63vX+SP/To3yX65UxtIPxDlprvSTwx9ImicLEqhHWGxSvTyfdZoxxglCZ9YmaXySONDm+Yt1u4Wg5BOvIz3NHd8mC6c4wVIDxdAsUV0XgngV8VA/6JQ3qs3cQH8CnyE2p4xvrZ66Ckit+hyQKHskdf46cA7pyBN+YfsIGX+3Aw8usbAiPgMFO23ECj3CgwMee1P6kv67Zc45Hx5y78/c
 fzUD8PG7
 eVHe80bVcCBgMyXnUWQSnPMD091x2qUKM6qsc44RvQrmf0C5Jjffo+3B0qXnkwGvfscdyWvsdxJZHtvjqW11TmSIxnopLavy3pX2JsuS/I/aWtZrniV1LWLJvBetlNl3vdk8uqUjo8SpVK0XJHy8swZqHDESgqk8eNDzZDUD3TOj0eBtBsFuHFVH/2g6u284ugQ3w2Uon7wtPkW7rttuPkyYaeXvZ2YVOP/Rjr7dwYTZws4VicXtyI2twv+XlridNaMIq83p6lHU0BJCkoGFOtLBksjsadot84VKL8ylmwN5x4UptNwc7VNXOknnCuaYVLeg+ym/XPSwdn++BcFn+LcTgzqPAVQNmSpcJzgUyfxotZWdVODrKnMwq5WRPvjCTRFPE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Li Zhe <lizhe.67@bytedance.com>

In commit 492d1e9f0df7 ("vfio/type1: optimize vfio_pin_pages_remote()"),
we changes vfio_find_vpfn() from exact-iova matching to the interval
[iova, iova + PAGE_SIZE), which may cause the following problem.

[  215.671885] ------------[ cut here ]------------
[  215.671893] WARNING: CPU: 10 PID: 6210 at drivers/vfio/vfio_iommu_type1.c:1204
vfio_remove_dma+0xda/0xf0 [vfio_iommu_type1]
[  215.671902] Modules linked in: vhost_vsock vmw_vsock_virtio_transport_common vsock vhost
vhost_iotlb algif_hash af_alg kvm nft_masq nft_ct nft_reject_ipv4 nf_reject_ipv4 nft_reject act_csum
cls_u32 sch_htb nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables pkey_pckmo
s390_trng pkey_ep11 pkey_cca zcrypt_cex4 zcrypt eadm_sch rng_core vfio_ccw mdev vfio_iommu_type1
vfio drm sch_fq_codel i2c_core drm_panel_orientation_quirks dm_multipath loop nfnetlink ctcm fsm
zfcp scsi_transport_fc mlx5_ib diag288_wdt mlx5_core ghash_s390 prng aes_s390 des_s390 libdes
sha3_512_s390 sha3_256_s390 sha512_s390 sha1_s390 sha_common rpcrdma sunrpc rdma_ucm rdma_cm
configfs iw_cm ib_cm ib_uverbs ib_core scsi_dh_rdac scsi_dh_emc scsi_dh_alua pkey autofs4
[  215.671946] CPU: 10 UID: 107 PID: 6210 Comm: qemu-system-s39 Kdump: loaded Not tainted 6.16.0-
rc7-00005-g4ff8295d8d61 #79 NONE
[  215.671950] Hardware name: IBM 3906 M05 780 (LPAR)
[  215.671951] Krnl PSW : 0704c00180000000 000002482f7ee55e (vfio_remove_dma+0xde/0xf0
[vfio_iommu_type1])
[  215.671956]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
[  215.671959] Krnl GPRS: 006d010100000000 000000009d8a4c40 000000008f3b1c80 0000000092ffad20
[  215.671961]            0000000090b57880 006e010100000000 000000008f3b1c80 000000008f3b1cc8
[  215.671963]            0000000085b3ff00 000000008f3b1cc0 000000008f3b1c80 0000000092ffad20
[  215.671964]            000003ff867acfa8 000000008f3b1ca0 000001c8b36c3be0 000001c8b36c3ba8
[  215.671972] Krnl Code: 000002482f7ee550: c0e53ff9fcc8	brasl	%r14,00000248af72dee0
           000002482f7ee556: a7f4ffcf		brc	15,000002482f7ee4f4
          #000002482f7ee55a: af000000		mc	0,0
          >000002482f7ee55e: a7f4ffa9		brc	15,000002482f7ee4b0
           000002482f7ee562: 0707		bcr	0,%r7
           000002482f7ee564: 0707		bcr	0,%r7
           000002482f7ee566: 0707		bcr	0,%r7
           000002482f7ee568: 0707		bcr	0,%r7
[  215.672006] Call Trace:
[  215.672008]  [<000002482f7ee55e>] vfio_remove_dma+0xde/0xf0 [vfio_iommu_type1]
[  215.672013]  [<000002482f7f03de>] vfio_iommu_type1_detach_group+0x3de/0x5f0 [vfio_iommu_type1]
[  215.672016]  [<000002482f7d4c4e>] vfio_group_detach_container+0x5e/0x180 [vfio]
[  215.672023]  [<000002482f7d2ce0>] vfio_group_fops_release+0x50/0x90 [vfio]
[  215.672027]  [<00000248af25e1ee>] __fput+0xee/0x2e0
[  215.672031]  [<00000248aef19f18>] task_work_run+0x88/0xd0
[  215.672036]  [<00000248aeef559a>] do_exit+0x18a/0x4e0
[  215.672042]  [<00000248aeef5ab0>] do_group_exit+0x40/0xc0
[  215.672045]  [<00000248aeef5b5e>] __s390x_sys_exit_group+0x2e/0x30
[  215.672048]  [<00000248afc81e56>] __do_syscall+0x136/0x340
[  215.672054]  [<00000248afc8da7e>] system_call+0x6e/0x90
[  215.672058] Last Breaking-Event-Address:
[  215.672059]  [<000002482f7ee4aa>] vfio_remove_dma+0x2a/0xf0 [vfio_iommu_type1]
[  215.672062] ---[ end trace 0000000000000000 ]---
[  219.861940] ------------[ cut here ]------------

...

[  241.164333] ------------[ cut here ]------------
[  241.164340] kernel BUG at drivers/vfio/vfio_iommu_type1.c:1480!
[  241.164358] monitor event: 0040 ilc:2 [#1]SMP
[  241.164363] Modules linked in: vhost_vsock vmw_vsock_virtio_transport_common vsock vhost
vhost_iotlb algif_hash af_alg kvm nft_masq nft_ct nft_reject_ipv4 nf_reject_ipv4 nft_reject act_csum
cls_u32 sch_htb nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables pkey_pckmo
s390_trng pkey_ep11 pkey_cca zcrypt_cex4 zcrypt eadm_sch rng_core vfio_ccw mdev vfio_iommu_type1
vfio drm sch_fq_codel i2c_core drm_panel_orientation_quirks dm_multipath loop nfnetlink ctcm fsm
zfcp scsi_transport_fc mlx5_ib diag288_wdt mlx5_core ghash_s390 prng aes_s390 des_s390 libdes
sha3_512_s390 sha3_256_s390 sha512_s390 sha1_s390 sha_common rpcrdma sunrpc rdma_ucm rdma_cm
configfs iw_cm ib_cm ib_uverbs ib_core scsi_dh_rdac scsi_dh_emc scsi_dh_alua pkey autofs4
[  241.164399] CPU: 14 UID: 107 PID: 6581 Comm: qemu-system-s39 Kdump: loaded Tainted: G        W
6.16.0-rc7-00005-g4ff8295d8d61 #79 NONE
[  241.164403] Tainted: [W]=WARN
[  241.164404] Hardware name: IBM 3906 M05 780 (LPAR)
[  241.164406] Krnl PSW : 0704e00180000000 000002482f7f132a (vfio_dma_do_unmap+0x4aa/0x4b0
[vfio_iommu_type1])
[  241.164413]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
[  241.164415] Krnl GPRS: 0000000000000000 000000000000000b 0000000040000000 000000008cfdcb40
[  241.164418]            0000000000001001 0000000000000001 0000000000000000 0000000040000000
[  241.164419]            0000000000000000 0000000000000000 00000001fbe7f140 000000008cfdcb40
[  241.164421]            000003ff97dacfa8 0000000000000000 00000000871582c0 000001c8b4177cd0
[  241.164428] Krnl Code: 000002482f7f131e: a7890000		lghi	%r8,0
           000002482f7f1322: a7f4feeb		brc	15,000002482f7f10f8
          #000002482f7f1326: af000000		mc	0,0
          >000002482f7f132a: 0707		bcr	0,%r7
           000002482f7f132c: 0707		bcr	0,%r7
           000002482f7f132e: 0707		bcr	0,%r7
           000002482f7f1330: c0040000803c	brcl	0,000002482f8013a8
           000002482f7f1336: eb6ff0480024	stmg	%r6,%r15,72(%r15)
[  241.164458] Call Trace:
[  241.164459]  [<000002482f7f132a>] vfio_dma_do_unmap+0x4aa/0x4b0 [vfio_iommu_type1]
[  241.164463]  [<000002482f7f1d08>] vfio_iommu_type1_ioctl+0x1c8/0x370 [vfio_iommu_type1]
[  241.164466]  [<00000248af27704e>] vfs_ioctl+0x2e/0x70
[  241.164471]  [<00000248af278610>] __s390x_sys_ioctl+0xe0/0x100
[  241.164474]  [<00000248afc81e56>] __do_syscall+0x136/0x340
[  241.164477]  [<00000248afc8da7e>] system_call+0x6e/0x90
[  241.164481] Last Breaking-Event-Address:
[  241.164482]  [<000002482f7f1238>] vfio_dma_do_unmap+0x3b8/0x4b0 [vfio_iommu_type1]
[  241.164486] Kernel panic - not syncing: Fatal exception: panic_on_oops

This patch reverts vfio_find_vpfn() to exact iova matching, thereby
resolving the issue.

Fixes: 492d1e9f0df7 ("vfio/type1: optimize vfio_pin_pages_remote()")
Tested-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 drivers/vfio/vfio_iommu_type1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 6909275e46c2..827e0987fab5 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -344,7 +344,7 @@ static struct vfio_pfn *vfio_find_vpfn_range(struct vfio_dma *dma,
 
 static inline struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
 {
-	return vfio_find_vpfn_range(dma, iova, iova + PAGE_SIZE);
+	return vfio_find_vpfn_range(dma, iova, iova + 1);
 }
 
 static void vfio_link_pfn(struct vfio_dma *dma,
-- 
2.20.1


