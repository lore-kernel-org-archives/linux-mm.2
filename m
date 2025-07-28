Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 934CCC83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 21:37:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23D746B0088; Mon, 28 Jul 2025 17:37:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EDC16B0089; Mon, 28 Jul 2025 17:37:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DCDC6B008A; Mon, 28 Jul 2025 17:37:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EE2506B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 17:37:31 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6B3D3C042B
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 21:37:31 +0000 (UTC)
X-FDA: 83714985102.25.083B03B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 064F420013
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 21:37:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cS3ukugG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753738649; a=rsa-sha256;
	cv=none;
	b=Q3zNx/wLPp6FxynuSo9ijGD6txSCGR2fqkzGmcVGg3i/VqJXc5X6xFR1qcZWAorJT9jJJ5
	16ouQcKHLhfiBRmzEQaezKFYqa1Mpj9uRAnihSVaWktSjYyQQTHcRP6M0q7vH4BU56VJ9P
	8Wq8SzHIcnSKOBZ8t3NQvqC+GlaASN0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cS3ukugG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753738649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WSSUSvYO/OHvphkbSQkQlLCmeUpTcTQ6sJaW2h42KWU=;
	b=DabJqFZzkaTC8NsebGNxdG7PCyynpfsmkyiDYHMbZdQCkgVJJ/75gqS10n4OUdpTJMP4qO
	ys0kuSdaAoIpPZOwW396siTI/50XdTraR5sq54heGR+EnNYv0pLM1RTSKPywIl2gzm8fDy
	BedPKrWu7HOuFJ79VPMLseP45/9glus=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753738648;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WSSUSvYO/OHvphkbSQkQlLCmeUpTcTQ6sJaW2h42KWU=;
	b=cS3ukugG1xNSEy7pUtKYUapHVCMr+ImAWUDJgENEWDNKjIKOWKNVG6wpXo7bivWcOmRFq2
	0Dj3FVrpFmxLXp094jD7oxYdBtE97yp+71w5cisJosdbGlJSxuIJTE3k14siHAvRUt7vz6
	snwAAizVf6EBGvzNX//KXO87HWb3SwQ=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-490-iyhGwNMPMOa2HX78gYH_bA-1; Mon, 28 Jul 2025 17:37:26 -0400
X-MC-Unique: iyhGwNMPMOa2HX78gYH_bA-1
X-Mimecast-MFC-AGG-ID: iyhGwNMPMOa2HX78gYH_bA_1753738645
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3ddc47aebc2so8246285ab.0
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 14:37:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753738645; x=1754343445;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WSSUSvYO/OHvphkbSQkQlLCmeUpTcTQ6sJaW2h42KWU=;
        b=kQuOIDqvOUeBXyftIC8TeZzg1ii2yNnr5Fa2ZOqozcUHMrfuIxHa39+vtbY8bf2pjr
         g1zxrrums3Ow+wO2pfxfzYUyWCj1LemEASZk+Q7Zx1Nls1wKtyglhEQv0/ju7jyDXCd2
         K3yuS7ql+M21B93fCtJRsIL6kohq2pWx8ascDGxGMgYKkCnpeH7Y4DMG+8pcXcB6acWL
         PJ4ZGPZeuIILRRZGHqJyvVKAubCZw4Mtt/abJEIFSJWpy3DHGQkMvVAT6Mb0vxG9izdG
         gf6gHvpxkeS3/bY7+mnFw+/hi2qns8muL8qtUYH4TdfeHIhJlMxU5HnlxhMarDruEB4x
         a+pA==
X-Forwarded-Encrypted: i=1; AJvYcCWjxQOQMaKlMblcJ/x5Gbg+7w5mAORYsbI24Qf/sz7pD/2tqysV5z5bXpNm1+wnd4uFlM3KJpzKMA==@kvack.org
X-Gm-Message-State: AOJu0YyDcLr3X1X76iljw6t/aWyzwFqN0Q2VcdLhj5IpxA9jyJ3Yuvdb
	jN8m5ldzWWIN+FtVeHTVFFdQlfuVOaA6VXMDUxAJBYz9gMMCT1Bg+vHiSuGpbH/rhp+PPiCOMzA
	a4+ZscxXQJMRjw+4qa5AcQAi9BLYRd26/Z+Ub+if1Ik8VycqhF6t4
X-Gm-Gg: ASbGncv/6zklQuZpMU0z2x8a0lAoFgy2aYDeLkUtOh5JwOmvO6c5RSytra+SFTcHV+I
	1LWELbZCuuCRRKiRIN+NF00A/aH4INiul9rSB/arpdmOc5p6D2WVRfxQGzSKUAyd2SG8YsiM8Ox
	jIRjrxrK/WJo3al+/1YZdfGvbgBeqteuYydeA+nfnt7eDzKhVDDFwKcbOVY0FOsD+pSwJLmSkDS
	CmUPHdegjbJ0F46UpYnJyoUlBHXikB+6eBPGQ8m6h+KD+WiikqG5Cr1t7yepEmkcVzOg0TyBD8M
	C1yjQZZJiBl0C/7EY534XBtEcqawrXP2Pkd3M7fSXNA=
X-Received: by 2002:a05:6e02:3704:b0:3e2:94ec:e379 with SMTP id e9e14a558f8ab-3e3c5385e09mr67989275ab.7.1753738645029;
        Mon, 28 Jul 2025 14:37:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IErX+WEsrqeHKni/uNNPldbJZPrUamuSASB+1k/g600fZ+i2JnjVLimIUTw7/v6P5+PLxYaZg==
X-Received: by 2002:a05:6e02:3704:b0:3e2:94ec:e379 with SMTP id e9e14a558f8ab-3e3c5385e09mr67989095ab.7.1753738644528;
        Mon, 28 Jul 2025 14:37:24 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-508c91edeb1sm2117893173.35.2025.07.28.14.37.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 14:37:23 -0700 (PDT)
Date: Mon, 28 Jul 2025 15:37:22 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: lizhe.67@bytedance.com
Cc: farman@linux.ibm.com, akpm@linux-foundation.org, david@redhat.com,
 jgg@ziepe.ca, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, peterx@redhat.com
Subject: Re: [FIXUP] vfio/type1: correct logic of vfio_find_vpfn()
Message-ID: <20250728153722.4b4c1442.alex.williamson@redhat.com>
In-Reply-To: <20250725070054.66497-1-lizhe.67@bytedance.com>
References: <20250724105608.73b05a24.alex.williamson@redhat.com>
	<20250725070054.66497-1-lizhe.67@bytedance.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: i4kdcQhuTzUxXFuRILls6RoEM5jkMHnOsuhQb9V04NY_1753738645
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 064F420013
X-Stat-Signature: 77z1798y9e4so4c4nxrxtkobr9tw65ch
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753738648-763856
X-HE-Meta: U2FsdGVkX19VzYPiUS9PVUK6uYRzXCg9GsCCEdYYXtZK5QP0+ujkWDaEze/ftyDIZYoe3GxhWQKZQelPdPJv39/17bWj7gEAtHq2vwGrITay91QeKxtxqQM3KKVV9MkWk2PfozkTwlF3l06QM1Iis1cbbadsRu4ItfP+rTxwTa0lMliicNhzOO8Iywdb+M+LpIb1yuHv2MnQv67E5zNEL9g/g1XhuMCkO/x8AzJbbDquhAS0B8kt+LCH4rIDVD947SeTu9thusXt73AS7ssSlzPWl2SL4Fgw+9b2FME1S/A/3aPCttWze+5SINFGOAeQfEjXAoj1QPf2D/YthqtXUzwLvlQGWLpLhqA8lIDr6zh7YeBQZZUjbdDfw+JXjVIxIPfHVRjrigBFRXO1bMbrzEM4WdElS9vngKV2dmtcVv3PXdoDjBIcdNVnCfnMucXrNxUUYyPdCTOY9mbE/nwTr3pLNaLrZlWQuIsAXMQmr/2kth/A0fTfo5a7veFZz6SRR+SS/8IDJC4lVb/2rZwuhlVwq1ksp8Id1LvwgHEU2g8WsB4ErikvSFLGnk2DqRawdL97f/3L5TOLAbAWaL/MTZC5S3tnQ4vx+qIq4kf01sxR78zPN9QUb2OBAh2pFxknh3wBd2pe7/tkgQ/5JURc5MGWqMNcVr6iKuao+u6jxfl07RjjkHer6/J0/XPxiUegrAiYM2mjzVAemknqelnVuNE2jkor6/I5el/htn/uAjjo9DEs55PG5hSxZipmRHWYvlbJgHwFlUPW2uisc7rENukQpGvxHFKz6B43XKzljGG4Z8IME533lTD8QyucjAJW/9aYCqCS4TBSDkoveKH3G5MhuNtdLcfue463yUKd1/sC6nqBlujA0x2T2NfsViOyUEcNgT6o3JOH76/Cu296jKOxNBMw10VcOmHR/XW6DTs387cfazrKrAi1/SKal0pefdDAKZtmGjnhAmzoWSU
 7JHp4WTF
 Cx6TctVliuT/BmWfd0czs81hMXmfVFGYtBdvU63GZcF8XZ4ZHzLNuP0L0lY4t+6wbrjfnHksA+teNtH0fwZrqGPS0bnDWC8hY26Dq7tIXhLm6rTXnyzV4PZuYjpek8ZP+D83Zhv0psAKHT5pSg5Dz42TxqP1Fc+mTV3qfN1dvWhEBgRpnh/hNXy9WA6pNb+XudXYhAsMzbWeUi+/b52yDqgW7yomgXv50bFra8AY4F+T++W6qxdQOi5MfEkd7135Kxhidttb3RR/69b0jiEwGTPfBZIuI2To1emNFSkGjw14HZg6gqqJI8sozsUM+fbe4CWj8jRJ2zoKAK8OeohFadx+jo/h7L1lUCWdvp2z0DzmUheLVADvWe3TSLnodt5zj4UPmY9Iq6oPOsfo/f9Azy1k2Z/3p4X9ObmsLxqFgqJ2Ew8ikyxSh+AXCH5VGMgKbUwJ+cwfbDVQoe5Yq+7A67RK3+dnO468VLmdhJeXLoHNDoVBatmtlm1IcGVrWq2616o6N3d36OZcL7nOwrJRPc6BPZT0igNdvXe3+AsWw0MhDQ0nZg56CvgZdCw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 25 Jul 2025 15:00:54 +0800
lizhe.67@bytedance.com wrote:

> From: Li Zhe <lizhe.67@bytedance.com>
> 
> In commit 492d1e9f0df7 ("vfio/type1: optimize vfio_pin_pages_remote()"),
> we changes vfio_find_vpfn() from exact-iova matching to the interval
> [iova, iova + PAGE_SIZE), which may cause the following problem.
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
> 
> This patch reverts vfio_find_vpfn() to exact iova matching, thereby
> resolving the issue.
> 
> Fixes: 492d1e9f0df7 ("vfio/type1: optimize vfio_pin_pages_remote()")
> Tested-by: Eric Farman <farman@linux.ibm.com>
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to vfio next branch for v6.17.  Thanks,

Alex

> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 6909275e46c2..827e0987fab5 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -344,7 +344,7 @@ static struct vfio_pfn *vfio_find_vpfn_range(struct vfio_dma *dma,
>  
>  static inline struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
>  {
> -	return vfio_find_vpfn_range(dma, iova, iova + PAGE_SIZE);
> +	return vfio_find_vpfn_range(dma, iova, iova + 1);
>  }
>  
>  static void vfio_link_pfn(struct vfio_dma *dma,


