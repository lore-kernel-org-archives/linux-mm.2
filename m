Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8978C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 19:24:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 371166B008A; Tue, 22 Jul 2025 15:24:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3489F6B009C; Tue, 22 Jul 2025 15:24:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 237216B009E; Tue, 22 Jul 2025 15:24:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0E2416B008A
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:24:12 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5C78359270
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 19:24:11 +0000 (UTC)
X-FDA: 83692876302.25.273BC0A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id C09AC16000B
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 19:24:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YjMIKqoa;
	spf=pass (imf08.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753212249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VoPpnzfO/x9/yJX0rcftjTQw+19C2QQbHVAgxYrYBgE=;
	b=C6EioBZZrD++qmyq1d9lZmX8GCwKtUrwV0u59R4zUif1UVgoMkwdU9xKiP9MPxhfUpYHXo
	+P5thIeNtR8OkPkwmCw5VIeIUVLPxRG7yI7tBeoQ0ibuK5PfqQzHM/wg65Wi2p2wbv6SUc
	qPR4KbeqYy594jm1/0x3YWhii3EglOg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YjMIKqoa;
	spf=pass (imf08.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753212249; a=rsa-sha256;
	cv=none;
	b=SfGJNRLSengIdklo8iFZpWH8eHJu/trA77T6BPge+l+S78elLVbilQau32RtkfZuk5F9tZ
	Pk0621fmPedRstateMaPAaXUgYQwX4wOEFb/5mY2043KL5yoBFEJvBkfGqRj6cJgXeb0D0
	rj0mJErLjJDaQkhZjDiUT7rNZUWJ+ks=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753212248;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VoPpnzfO/x9/yJX0rcftjTQw+19C2QQbHVAgxYrYBgE=;
	b=YjMIKqoafp5IARdIUQs4rV93lz0VDdRPTd5SZp+O2CvKOKKZ1ceA28aE/1pPZKDJrhi72i
	lXEpdvd1Etr8miVwZNCNwhoMDW1tDNZexjNq6iLSP1gs8CUYAH8GESvythFT0ZgbVDD4JD
	PPkHwnsEV6pp4xD9WPvw9QjuknHyt2E=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-355-qoxX7cLePmGhtm4fjuCIOA-1; Tue, 22 Jul 2025 15:24:06 -0400
X-MC-Unique: qoxX7cLePmGhtm4fjuCIOA-1
X-Mimecast-MFC-AGG-ID: qoxX7cLePmGhtm4fjuCIOA_1753212246
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3e29ec275c3so9178205ab.3
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 12:24:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753212246; x=1753817046;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VoPpnzfO/x9/yJX0rcftjTQw+19C2QQbHVAgxYrYBgE=;
        b=LXBEc1ssTKqyO0uiEomfW5S6vIPZzaDMYxecltfyoMZTGG5QiZtWdGiV2waTWGoG59
         gv9LOxeU94lRKwzvC5w5nzMRFqLee4FfYZ/RXKn8XdILTOPTXaVzyQLlyssT2AZZlc43
         UY2w/v4ev3VcaRtsbP9ntXh4o9hhSnfJp0/g7gN42HeIKY8hu3I6hmE/5VYXY72cQ/vu
         CJAZM/4D66dMVd9RMwuj3oXRW52BQIuZzcOTknYEDm+cp2WOXmNKs8p0K+5o2PNe2yma
         d1SiGXZEMy98sKg0cbfn2FOejBnCAQVB0020YeRP44cnlYFp5TDKIzMlk2EOYUUDky5q
         6nig==
X-Forwarded-Encrypted: i=1; AJvYcCXCQp3WT5Q+GsiZg5Y1fJHIqf1Lwbti9sonW5iOmKyLxbMPIhxDYudb7qOYoCGJzKMNWpJALe55NQ==@kvack.org
X-Gm-Message-State: AOJu0YycEDr/9P3S84TXPcikpcCW9fIBfXNnruL5R3/Po74osxOXYqtk
	MrP+EwH2cl6mt1unIKSGcOwsGVqswgfgP35kVDtGI0usvx4Ojui6DL2pCRmDd7zf3561kAqttsf
	sWvQYl7v3x4uX4wn4X+ITTxertqXEz7l5eNs4RaxzRpS6gsRO2LJe
X-Gm-Gg: ASbGncvwQun6oSOdShAu+PzEcpTUsBS+BBH5wLjLhdGheF+LVNUabCZCDN/t9gKBIgX
	T6R9mXxfwhqSGd9hvvEqguTgdDygIl3ktivXaHbZMEyALJQWRnwlsZmEC01yy3Pbd87WiJhj+TZ
	q70c9t6VUSlxbd9ddDMmavk3M/jXdIOgwiTVuuRBtKuOjsBB2xqPivsBJ7x/tELT4a4d+E6Xgub
	JnFUqxF8f2cGq0oy+1NX9jANLcFKBZRjkImzJrmUqj1y1pziaevBtnwvSHdLfBeXhG1iCbVhJXi
	25Hx+Emn3nOySCrr8YkYZNTB3Xx0s3tfX/lhGP1lAXU=
X-Received: by 2002:a05:6e02:b4e:b0:3e2:b511:1257 with SMTP id e9e14a558f8ab-3e32fbe6d02mr1429575ab.1.1753212245305;
        Tue, 22 Jul 2025 12:24:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGtVPfNQQZe8DOqCr9vtTkI2cNKOF9UOY8F0gy0NieHMIPzKntZTVJ6/MWE3j5uJcQHKrMd+Q==
X-Received: by 2002:a05:6e02:b4e:b0:3e2:b511:1257 with SMTP id e9e14a558f8ab-3e32fbe6d02mr1429355ab.1.1753212244681;
        Tue, 22 Jul 2025 12:24:04 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5084ca61845sm2706151173.126.2025.07.22.12.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jul 2025 12:24:03 -0700 (PDT)
Date: Tue, 22 Jul 2025 13:23:58 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Eric Farman <farman@linux.ibm.com>
Cc: lizhe.67@bytedance.com, akpm@linux-foundation.org, david@redhat.com,
 jgg@ziepe.ca, peterx@redhat.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 2/5] vfio/type1: optimize vfio_pin_pages_remote()
Message-ID: <20250722132358.5ab61377.alex.williamson@redhat.com>
In-Reply-To: <1bd50178755535ee0a3b0b2164acf9319079a3d5.camel@linux.ibm.com>
References: <20250710085355.54208-1-lizhe.67@bytedance.com>
	<20250710085355.54208-3-lizhe.67@bytedance.com>
	<1bd50178755535ee0a3b0b2164acf9319079a3d5.camel@linux.ibm.com>
Organization: Red Hat
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: --OqZFpnlj6Gx2q0-ERA2iBb_fRfhPkXfuJCfr26zCI_1753212246
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C09AC16000B
X-Rspamd-Server: rspam06
X-Stat-Signature: s9ma4btuh1ndid4qsbdku7ibbmpkybjh
X-HE-Tag: 1753212248-530507
X-HE-Meta: U2FsdGVkX1+4Wm9/B8EGYghMzsplAvu+Pcyu7DVPIHA6dUC2t+Lp5hxaix05zfDp97ExsA4vvLSYx7nFXSKQAcsXac4WxjwbuRg0y7Ppu0DJDvO4NNL3LNzdBKGuHAgvTNDWQx2t6xNdaksiIepjcwvgdZrjsywTc1wdk+cf4J0KNf6/w+xMjTxzFfTdVkgh1TQ9Pn6yO5GWTtntblWBHCpXhd7FaO02LDJMZcFIHbGGN+SnzHfrZVN7Fqb8cWvU/o0XYzxxdcTEZcG+meOb0/55ekolapJEgR/rskfcZVWliaP3RfI7JFkUr/J74yB7Yg59vlAqIXtS06t+VgwStp1uiSCLltdGn6abKC478kAIXNYO8ctblQw0JZjgZyMxfugeulwV2o2HdVHkq6nwW8E2q+ENDDgUOXpeiAEsPoeo/oBj7XhHxUiJe2QVDnuXoFHJp13jR88d1eknu2rTA/efM2hcguhwkknZuLXuaNJ1HdGBy/cX97US2lzaeK77g/0+eDAj+M28AidxVR6N9ymiYy0JT0MezV5k3MK/zdrVXgtV0C0Yp3/5aasEBWqCPbqNbBuVSNTNrvatCap/84oNQGAoOPYR1kF0Em9OuGlGZpMP5uHhasUAcqg35EAAZe3+yzMul9utrD5Wok2GHJGZTcvSvmbUWqPOXYPdxMcozFfIajLGBG0vsOMgLfbycC6yt34sl7bI7k5GGRs+PaIPm6IRw15nDLeMB952XTHC+iVlsmcIC5bnLgP4M3vmvNGD13A5abWZw37F3yyfZWqZ0wbA/5C24xm5VJKZ0B54DZNnmRjF3KJgMM1Ax9IoSFe4cUdOHPp+RkHK7nkFiO0VLwOSxxGST4lt7bbvqdxv+GeHgKrvGkBjHJSPub9qj70NTnrbjRJynXj92f9oZIW5CX29oNm6+wL8wny7KHqx4RgIMs7MbibU6qAd9fdjg4zC8P0F73LROQUXw22
 +5oTYi18
 95CFOtJ5KekId6fyhbcItgQAKMUTVsja4l8j+S53QJvImnlPzuk7dCHOE3LLwYI7iSPVbqpxKGZ0Y6aUfQn+4rP1innbnz4wyNU+/cdqQDAWLOKyf9xn6dd2cQpq8GeYycZuSvY6Wh/rAgyJkDAtwELHsqDm+9Msmrrz04jbt7364DdEOLGjpdbJzns/ZQk/eZfR+Ieh5r8cKaxr5+AvMhhNBM3fGcfeMPPyxOa+BymxDQDmKz7As8ZZSQ/cLhXe//Vrlgx/i1kvR0Wr11hWJXF5XZE7/WZ0lP8iFxdcMmsI7q3bRLRJC8i0Ekn2FeuUKyZFzLpYvFoNuFIUl5YJfzniv1Z9/W+S8zfiN8I8llJ6YLJ2cPIVylLjX7M0iibBfB90qoE+TucoSu7VIRDJoeWKUPEtKaN0E4IeBo5OthEqyLoRYP4bW/WxlGSjuVOE40Y1Ms0oxPGD9jAwleM3oJ5e41nSPk9+FpcTYLji+vzytuo7HjskzNd7Ov3eYAMm68vsJ33VK31JGtqeFm9/j9vaU8Sbiwz6kR9SZDiOtg344sgCxl4F9uFPtAOeKzItXAnBbFUfgMwt9Bif4x4hfLC/cPxIiEe34hbsXpD59jsD3TF+QFYrp8DT33801/AmY2cmX1I8URllyz6ax18hrs+iFrw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 22 Jul 2025 12:32:59 -0400
Eric Farman <farman@linux.ibm.com> wrote:

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

Thanks for the report.  I'm out of the office this week, but I'll keep
an eye on how this progresses and we can drop it if we haven't come to
a resolution in the next few days.  Thanks,

Alex


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
> > 
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > index 1136d7ac6b59..6909275e46c2 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -318,7 +318,13 @@ static void vfio_dma_bitmap_free_all(struct vfio_iommu *iommu)
> >  /*
> >   * Helper Functions for host iova-pfn list
> >   */
> > -static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
> > +
> > +/*
> > + * Find the highest vfio_pfn that overlapping the range
> > + * [iova_start, iova_end) in rb tree.
> > + */
> > +static struct vfio_pfn *vfio_find_vpfn_range(struct vfio_dma *dma,
> > +		dma_addr_t iova_start, dma_addr_t iova_end)
> >  {
> >  	struct vfio_pfn *vpfn;
> >  	struct rb_node *node = dma->pfn_list.rb_node;
> > @@ -326,9 +332,9 @@ static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
> >  	while (node) {
> >  		vpfn = rb_entry(node, struct vfio_pfn, node);
> >  
> > -		if (iova < vpfn->iova)
> > +		if (iova_end <= vpfn->iova)
> >  			node = node->rb_left;
> > -		else if (iova > vpfn->iova)
> > +		else if (iova_start > vpfn->iova)
> >  			node = node->rb_right;
> >  		else
> >  			return vpfn;
> > @@ -336,6 +342,11 @@ static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
> >  	return NULL;
> >  }
> >  
> > +static inline struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
> > +{
> > +	return vfio_find_vpfn_range(dma, iova, iova + PAGE_SIZE);
> > +}
> > +
> >  static void vfio_link_pfn(struct vfio_dma *dma,
> >  			  struct vfio_pfn *new)
> >  {
> > @@ -614,6 +625,39 @@ static long vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
> >  	return ret;
> >  }
> >  
> > +
> > +static long vpfn_pages(struct vfio_dma *dma,
> > +		dma_addr_t iova_start, long nr_pages)
> > +{
> > +	dma_addr_t iova_end = iova_start + (nr_pages << PAGE_SHIFT);
> > +	struct vfio_pfn *top = vfio_find_vpfn_range(dma, iova_start, iova_end);
> > +	long ret = 1;
> > +	struct vfio_pfn *vpfn;
> > +	struct rb_node *prev;
> > +	struct rb_node *next;
> > +
> > +	if (likely(!top))
> > +		return 0;
> > +
> > +	prev = next = &top->node;
> > +
> > +	while ((prev = rb_prev(prev))) {
> > +		vpfn = rb_entry(prev, struct vfio_pfn, node);
> > +		if (vpfn->iova < iova_start)
> > +			break;
> > +		ret++;
> > +	}
> > +
> > +	while ((next = rb_next(next))) {
> > +		vpfn = rb_entry(next, struct vfio_pfn, node);
> > +		if (vpfn->iova >= iova_end)
> > +			break;
> > +		ret++;
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> >  /*
> >   * Attempt to pin pages.  We really don't want to track all the pfns and
> >   * the iommu can only map chunks of consecutive pfns anyway, so get the
> > @@ -680,32 +724,47 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
> >  		 * and rsvd here, and therefore continues to use the batch.
> >  		 */
> >  		while (true) {
> > +			long nr_pages, acct_pages = 0;
> > +
> >  			if (pfn != *pfn_base + pinned ||
> >  			    rsvd != is_invalid_reserved_pfn(pfn))
> >  				goto out;
> >  
> > +			/*
> > +			 * Using GUP with the FOLL_LONGTERM in
> > +			 * vaddr_get_pfns() will not return invalid
> > +			 * or reserved pages.
> > +			 */
> > +			nr_pages = num_pages_contiguous(
> > +					&batch->pages[batch->offset],
> > +					batch->size);
> > +			if (!rsvd) {
> > +				acct_pages = nr_pages;
> > +				acct_pages -= vpfn_pages(dma, iova, nr_pages);
> > +			}
> > +
> >  			/*
> >  			 * Reserved pages aren't counted against the user,
> >  			 * externally pinned pages are already counted against
> >  			 * the user.
> >  			 */
> > -			if (!rsvd && !vfio_find_vpfn(dma, iova)) {
> > +			if (acct_pages) {
> >  				if (!dma->lock_cap &&
> > -				    mm->locked_vm + lock_acct + 1 > limit) {
> > +				     mm->locked_vm + lock_acct + acct_pages > limit) {
> >  					pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
> >  						__func__, limit << PAGE_SHIFT);
> >  					ret = -ENOMEM;
> >  					goto unpin_out;
> >  				}
> > -				lock_acct++;
> > +				lock_acct += acct_pages;
> >  			}
> >  
> > -			pinned++;
> > -			npage--;
> > -			vaddr += PAGE_SIZE;
> > -			iova += PAGE_SIZE;
> > -			batch->offset++;
> > -			batch->size--;
> > +			pinned += nr_pages;
> > +			npage -= nr_pages;
> > +			vaddr += PAGE_SIZE * nr_pages;
> > +			iova += PAGE_SIZE * nr_pages;
> > +			batch->offset += nr_pages;
> > +			batch->size -= nr_pages;
> >  
> >  			if (!batch->size)
> >  				break;  
> 


