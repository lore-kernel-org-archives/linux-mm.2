Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BC37C87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 16:56:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B11508E009D; Thu, 24 Jul 2025 12:56:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC14C8E007C; Thu, 24 Jul 2025 12:56:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 989A18E009D; Thu, 24 Jul 2025 12:56:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 805B68E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 12:56:20 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E739313389C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 16:56:19 +0000 (UTC)
X-FDA: 83699761278.06.9A6DFFF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 89389160010
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 16:56:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="TIUt/9/U";
	spf=pass (imf08.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753376177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jYHoGtuRw7WdZoej8GrGyP1iXAhvqZMicdBMuztBHmE=;
	b=CpAxA2wqSmFSwWYT0ENofE4qxadpGEepwnHP4BsUtxNQAGV2BTqYrOGs2/WMSi3eIAdef/
	Bqp2oUuS3xIzNWv1rj1TG/h2EXLggrAvGkOvIp/UAK1KHX9rr/j52jx68oY2KWID2UTeUS
	PS90dIa+i8cQaqe1O3ad5VAGON/FRck=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753376177; a=rsa-sha256;
	cv=none;
	b=OJlceiE1Ri8Dc5Ki79CC4QA+aD2sjWOdxk6vhUdOxSva5g71H0CiwSsouPYlgHZV0ZHMk4
	ugsyKl7DQmuNDwKvMSouIHsE8ZOXwcRDGeNzRJ3OL7cyqeUMGbDWMnKaHeXxPVjeH6jF8v
	sFkMw/uObZw42lDjm76fzFYy4/LoJ98=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="TIUt/9/U";
	spf=pass (imf08.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753376176;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jYHoGtuRw7WdZoej8GrGyP1iXAhvqZMicdBMuztBHmE=;
	b=TIUt/9/UTGpmV5ZWyTdVntvnUMLYQHL1rKrRbDzVB4mkBiSfaExUDn0zw02lTm3uu3VlbT
	BzcsXUksRSJHlEtzqvfFrwZbBiFc3D5LxKUfyi9qcuvw+oxf4Az4Z486DRm8d5Eg6iTAPT
	Pvt8Uh/Ofy8tk4XpGbgawvk3JaRs4c4=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-193-zM2o6AhQMre0uS4dghYpGw-1; Thu, 24 Jul 2025 12:56:15 -0400
X-MC-Unique: zM2o6AhQMre0uS4dghYpGw-1
X-Mimecast-MFC-AGG-ID: zM2o6AhQMre0uS4dghYpGw_1753376174
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3df359a108bso2362955ab.3
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:56:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753376174; x=1753980974;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jYHoGtuRw7WdZoej8GrGyP1iXAhvqZMicdBMuztBHmE=;
        b=c6a23kZYOW0Kuz50ZJisEwpxRsIIsvBB2mU5mpcBmXcaVIrwxK9XuDbtBqka0xI2pG
         WF31Mhq40UZZ94N2RZP0b50+19sAzecdYsFYOjZ32LhnGM1PvjLCLcuzNoxxvUMTQfIM
         aFfq0irjPE/41hh8Od3iXcWL2zofFCtGjzEbZXZCYQBNz5/n4o6lDriAmvO1N8zCgMnr
         uQ272TMHB0q+1mK00Jgx0bWNPvXkUi48qTOwjG4eMqR8np19QrxXf7+U3wKfYvxyfOmq
         pdu8HYd3JDuDi0DKhyLo15R+IEtP/KP3lqql86+JqyooR4LnOkV39/dxpVetsq0aiKCV
         MfAw==
X-Forwarded-Encrypted: i=1; AJvYcCXBcpHHX9sqM+m1h6hvN4fhSwNuvCjtUcJnYJaMLJAh6H/U3d0dpXxICJE5kD/6fzLss6Fnh0GlrA==@kvack.org
X-Gm-Message-State: AOJu0YxQBJzfnRXVy0yRLLoHUl0//ByqsffCMfaS39xp+zmTJ5zYKmUS
	IXO0vnS2XlDSjSaAU6kadbta3eJqaA6ToAXqt2XQhdU4RcOTuE3tjlRh6Rm0o7zSMdPeoun8zts
	bzMiueLFuEbmh/Yq+3b3imOobKW/JxOmTMoTCz35UlPNqo5yghUoi
X-Gm-Gg: ASbGncuZgNDNOyKbthNLk6qI1jCC68on+OoZxrISikTQnJ/mffKsFHbUbb9v7tbN6ku
	SPBhRwRLw+iW+FXKldV9hrCw/BdKkn5vjxiV6M4rjGiWGO6GC+bHFdG/rpaFqPzyd7QBZTTRLPw
	wQQjItE+JAfLjeETwubSm31zw4X8UsiRbzHov2RJWdhb1weIMh5uluy74A+OwVxXfm6CWSdbbLY
	tSzHswesvuFYbCkmRQtGtxZG0vIU3dOTWjxXQ/WURwunTunFrGwCJ8zGmfw/q8bXO3upeoAHMHC
	Q5H4B9KvW1yI9FgcRe0xSFLThmJb2kWTMt96bSsHkFA=
X-Received: by 2002:a05:6e02:1b0e:b0:3dd:ce1c:f1bc with SMTP id e9e14a558f8ab-3e336270ddfmr33899285ab.7.1753376174081;
        Thu, 24 Jul 2025 09:56:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGeSdBI2UmvcdBRmfm8Po6mbiFyGezwzFECqf7+XyZFuhtgfyr90kLcOCgnM3T65hbDWKQVJw==
X-Received: by 2002:a05:6e02:1b0e:b0:3dd:ce1c:f1bc with SMTP id e9e14a558f8ab-3e336270ddfmr33899085ab.7.1753376173425;
        Thu, 24 Jul 2025 09:56:13 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-508ae900b01sm523324173.0.2025.07.24.09.56.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 09:56:12 -0700 (PDT)
Date: Thu, 24 Jul 2025 10:56:08 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: lizhe.67@bytedance.com
Cc: farman@linux.ibm.com, akpm@linux-foundation.org, david@redhat.com,
 jgg@ziepe.ca, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, peterx@redhat.com
Subject: Re: [PATCH v4 2/5] vfio/type1: optimize vfio_pin_pages_remote()
Message-ID: <20250724105608.73b05a24.alex.williamson@redhat.com>
In-Reply-To: <20250724024038.75436-1-lizhe.67@bytedance.com>
References: <f22a8b5b50a140339222bed77f4b670d9008f29b.camel@linux.ibm.com>
	<20250724024038.75436-1-lizhe.67@bytedance.com>
Organization: Red Hat
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6rS21cCSenok3M5vBn36zoHknc_CJhjapPz-VDvrkeI_1753376174
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 89389160010
X-Stat-Signature: ger1137mopf95tk3x4hf1rh4czidbo8j
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753376177-889228
X-HE-Meta: U2FsdGVkX1+SCeb52lmqnyVJg+eVjNDymeBJFV6KewCsQwYTLwBk5VQNke6sAp6tdcp5e8U4t3kNAkKklrk9l9FT1DubhnELmBxh+EkimGdC92CyxCbMA8ck/ZBMhROuH0BFqh8iaFIztrdxauRASDiWKs+FXNlMVsL4aNLYGey4kMAx1n6b60Kc1L8USesAhAg/L/rN0nBH8pgsJkvJRwQ3YfmEKMekz9mbZsXy1LsfuK2pdX0Yp5XNM7HMdYPBLSdV/MJTyikb1P5Wa6FtlVr2E7/xRMMUm2CujGUBaL1xW9CIM0buMTu9PBdr6Ko+IVVZ8SZ9uX9+AR6L2Wi/KGqeWAIPOdramiYZ8JjtTi+tBKAPyqB0U84icti5uYN33l91sSXd6G7oXFvjwCjaifRA46bmTh95iiKZwNqMgeKuPvTMQFJNKjJnCMwwE7XhtbOhaoldJMnhS0E0cKaKvcFLQYl6UyE4xVVPizlVISTZENHdiuhyNVD24XXI1hTAzJUC1dQjPKvZdQmB2LBShai7De5WW/b/fLKKFqMnlFo2yfEynPedRDgIgTPoBipb0hp9jFOBHdPJ1eu/bN6dXemGBpAalFdXZIuxUcZYmhZoqa+zN0hzHYOUib1zfJOEWB+7FUW1FlFVXS8UDEK1KSznZ9BMpVLYcDHuyhwxHqtcIy/1jQ+YtdOK9u2IEVn6OXTM2N+RxBqsQc54gI0lAte49iuPmAv7XpyvTImgNdyzlowYf7GeJtmqfruA6BJO9ww0Xbmxj1u/bgXWRLFfRs9Jgf8E9KcwLUfgiszD8nJaKnEY5ATMiHMvObfMbkNxVRQjkXsiN2zONYIwLHPahaTPs+3XyOgDGv4YIx+BJ8l9WJyS2PuUU4e/+3vgLxW7x0Ia6vFAXBUi0oXn/VFGdP7nPbusZDW9KzHhtcAbAjBmBCaVOLlHrW9ZIW0WmSr9W9U8e/5JNAaK89DxVf+
 pVWK39ng
 jogYf/nL3Uq557Gf9cLww4rnZe7n3AGP5lf5ApTUExhxM5LR+cATep9MEGRDE1z+AUYUGphMFsHzxbEA0RoRSTZQ7KwolHHJAG8A+w12jSkxxrqXMFwRu7lzH92JtZ1HQ+tycRdstUiyoJiQyBp6+sqj3c1+2dPERoK2MkeI3ctT0FyrRR6wI7Cev6RDoYG+/n+DM5gHV/xhZME3pS+SlNgolswS2UdGnuZfiV9/GjO1sh29OgNdU8QI9YSpKzNy5jccnQgqKGdKZbTk80EMZaC0SldjMm0Iz2PL8gpk1U3zYbe69Gu4OBCr/3FyLoXutbyKhCIaWnQLQ4cgMpAa/JijwOkBJ9OH+gl3VTs6qMXbmPvtRqmh+TcsrkX01FXL/6uDLMBIsnU/mahzD++P9CXFJcH7RKJLHvig0qdFkJdkxd0BbiVTuKwRPqWBIFAxLEI3h2XAUGcxt+KJ6ZLjZYoPzqns55aEZIjiDm9Lucke52ZJ36psz0+dSYo5npULF6T5Fy0oHThBuu9P2gduodXRkuFymwmq4D/8+gm43y39ZqworGq1yTSL+NKvdm200XNn+eigyDkduJsGwk37EQN4iU9suybFZj3Ov1N/GLXuf9Emb5eOqrq/fd6C5Gs2iNdslYmnwLoIKK3Ooxf/5auH/+A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 24 Jul 2025 10:40:38 +0800
lizhe.67@bytedance.com wrote:

> On Wed, 23 Jul 2025 10:41:34 -0400, farman@linux.ibm.com wrote:
>  
> > On Wed, 2025-07-23 at 15:09 +0800, lizhe.67@bytedance.com wrote:  
> > > On Tue, 22 Jul 2025 12:32:59 -0400, farman@linux.ibm.com wrote:
> > >    
> > > > On Thu, 2025-07-10 at 16:53 +0800, lizhe.67@bytedance.com wrote:  
> > > > > From: Li Zhe <lizhe.67@bytedance.com>
> > > > > 
> > > > > When vfio_pin_pages_remote() is called with a range of addresses that
> > > > > includes large folios, the function currently performs individual
> > > > > statistics counting operations for each page. This can lead to significant
> > > > > performance overheads, especially when dealing with large ranges of pages.
> > > > > Batch processing of statistical counting operations can effectively enhance
> > > > > performance.
> > > > > 
> > > > > In addition, the pages obtained through longterm GUP are neither invalid
> > > > > nor reserved. Therefore, we can reduce the overhead associated with some
> > > > > calls to function is_invalid_reserved_pfn().
> > > > > 
> > > > > The performance test results for completing the 16G VFIO IOMMU DMA mapping
> > > > > are as follows.
> > > > > 
> > > > > Base(v6.16-rc4):
> > > > > ------- AVERAGE (MADV_HUGEPAGE) --------
> > > > > VFIO MAP DMA in 0.047 s (340.2 GB/s)
> > > > > ------- AVERAGE (MAP_POPULATE) --------
> > > > > VFIO MAP DMA in 0.280 s (57.2 GB/s)
> > > > > ------- AVERAGE (HUGETLBFS) --------
> > > > > VFIO MAP DMA in 0.052 s (310.5 GB/s)
> > > > > 
> > > > > With this patch:
> > > > > ------- AVERAGE (MADV_HUGEPAGE) --------
> > > > > VFIO MAP DMA in 0.027 s (602.1 GB/s)
> > > > > ------- AVERAGE (MAP_POPULATE) --------
> > > > > VFIO MAP DMA in 0.257 s (62.4 GB/s)
> > > > > ------- AVERAGE (HUGETLBFS) --------
> > > > > VFIO MAP DMA in 0.031 s (517.4 GB/s)
> > > > > 
> > > > > For large folio, we achieve an over 40% performance improvement.
> > > > > For small folios, the performance test results indicate a
> > > > > slight improvement.
> > > > > 
> > > > > Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> > > > > Co-developed-by: Alex Williamson <alex.williamson@redhat.com>
> > > > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > > > Acked-by: David Hildenbrand <david@redhat.com>
> > > > > ---
> > > > >  drivers/vfio/vfio_iommu_type1.c | 83 ++++++++++++++++++++++++++++-----
> > > > >  1 file changed, 71 insertions(+), 12 deletions(-)  
> > > > 
> > > > Hi,
> > > > 
> > > > Our CI started flagging some crashes running vfio-ccw regressions on the -next kernel beginning with
> > > > next-20250717, and bisect points to this particular commit.
> > > > 
> > > > I can reproduce by cherry-picking this series onto 6.16-rc7, so it's not something else lurking.
> > > > Without panic_on_warn, I get a handful of warnings from vfio_remove_dma() (after starting/stopping
> > > > guests with an mdev attached), before eventually triggering a BUG() in vfio_dma_do_unmap() running a
> > > > hotplug test. I've attached an example of a WARNING before the eventual BUG below. I can help debug
> > > > this if more doc is needed, but admit I haven't looked at this patch in any detail yet.
> > > > 
> > > > Thanks,
> > > > Eric
> > > > 
> > > > [  215.671885] ------------[ cut here ]------------
> > > > [  215.671893] WARNING: CPU: 10 PID: 6210 at drivers/vfio/vfio_iommu_type1.c:1204
> > > > vfio_remove_dma+0xda/0xf0 [vfio_iommu_type1]
> > > > [  215.671902] Modules linked in: vhost_vsock vmw_vsock_virtio_transport_common vsock vhost
> > > > vhost_iotlb algif_hash af_alg kvm nft_masq nft_ct nft_reject_ipv4 nf_reject_ipv4 nft_reject act_csum
> > > > cls_u32 sch_htb nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables pkey_pckmo
> > > > s390_trng pkey_ep11 pkey_cca zcrypt_cex4 zcrypt eadm_sch rng_core vfio_ccw mdev vfio_iommu_type1
> > > > vfio drm sch_fq_codel i2c_core drm_panel_orientation_quirks dm_multipath loop nfnetlink ctcm fsm
> > > > zfcp scsi_transport_fc mlx5_ib diag288_wdt mlx5_core ghash_s390 prng aes_s390 des_s390 libdes
> > > > sha3_512_s390 sha3_256_s390 sha512_s390 sha1_s390 sha_common rpcrdma sunrpc rdma_ucm rdma_cm
> > > > configfs iw_cm ib_cm ib_uverbs ib_core scsi_dh_rdac scsi_dh_emc scsi_dh_alua pkey autofs4
> > > > [  215.671946] CPU: 10 UID: 107 PID: 6210 Comm: qemu-system-s39 Kdump: loaded Not tainted 6.16.0-
> > > > rc7-00005-g4ff8295d8d61 #79 NONE 
> > > > [  215.671950] Hardware name: IBM 3906 M05 780 (LPAR)
> > > > [  215.671951] Krnl PSW : 0704c00180000000 000002482f7ee55e (vfio_remove_dma+0xde/0xf0
> > > > [vfio_iommu_type1])
> > > > [  215.671956]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
> > > > [  215.671959] Krnl GPRS: 006d010100000000 000000009d8a4c40 000000008f3b1c80 0000000092ffad20
> > > > [  215.671961]            0000000090b57880 006e010100000000 000000008f3b1c80 000000008f3b1cc8
> > > > [  215.671963]            0000000085b3ff00 000000008f3b1cc0 000000008f3b1c80 0000000092ffad20
> > > > [  215.671964]            000003ff867acfa8 000000008f3b1ca0 000001c8b36c3be0 000001c8b36c3ba8
> > > > [  215.671972] Krnl Code: 000002482f7ee550: c0e53ff9fcc8	brasl	%r14,00000248af72dee0
> > > >            000002482f7ee556: a7f4ffcf		brc	15,000002482f7ee4f4
> > > >           #000002482f7ee55a: af000000		mc	0,0  
> > > >           >000002482f7ee55e: a7f4ffa9		brc	15,000002482f7ee4b0  
> > > >            000002482f7ee562: 0707		bcr	0,%r7
> > > >            000002482f7ee564: 0707		bcr	0,%r7
> > > >            000002482f7ee566: 0707		bcr	0,%r7
> > > >            000002482f7ee568: 0707		bcr	0,%r7
> > > > [  215.672006] Call Trace:
> > > > [  215.672008]  [<000002482f7ee55e>] vfio_remove_dma+0xde/0xf0 [vfio_iommu_type1] 
> > > > [  215.672013]  [<000002482f7f03de>] vfio_iommu_type1_detach_group+0x3de/0x5f0 [vfio_iommu_type1] 
> > > > [  215.672016]  [<000002482f7d4c4e>] vfio_group_detach_container+0x5e/0x180 [vfio] 
> > > > [  215.672023]  [<000002482f7d2ce0>] vfio_group_fops_release+0x50/0x90 [vfio] 
> > > > [  215.672027]  [<00000248af25e1ee>] __fput+0xee/0x2e0 
> > > > [  215.672031]  [<00000248aef19f18>] task_work_run+0x88/0xd0 
> > > > [  215.672036]  [<00000248aeef559a>] do_exit+0x18a/0x4e0 
> > > > [  215.672042]  [<00000248aeef5ab0>] do_group_exit+0x40/0xc0 
> > > > [  215.672045]  [<00000248aeef5b5e>] __s390x_sys_exit_group+0x2e/0x30 
> > > > [  215.672048]  [<00000248afc81e56>] __do_syscall+0x136/0x340 
> > > > [  215.672054]  [<00000248afc8da7e>] system_call+0x6e/0x90 
> > > > [  215.672058] Last Breaking-Event-Address:
> > > > [  215.672059]  [<000002482f7ee4aa>] vfio_remove_dma+0x2a/0xf0 [vfio_iommu_type1]
> > > > [  215.672062] ---[ end trace 0000000000000000 ]---
> > > > [  219.861940] ------------[ cut here ]------------
> > > > 
> > > > ...
> > > > 
> > > > [  241.164333] ------------[ cut here ]------------
> > > > [  241.164340] kernel BUG at drivers/vfio/vfio_iommu_type1.c:1480!
> > > > [  241.164358] monitor event: 0040 ilc:2 [#1]SMP 
> > > > [  241.164363] Modules linked in: vhost_vsock vmw_vsock_virtio_transport_common vsock vhost
> > > > vhost_iotlb algif_hash af_alg kvm nft_masq nft_ct nft_reject_ipv4 nf_reject_ipv4 nft_reject act_csum
> > > > cls_u32 sch_htb nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables pkey_pckmo
> > > > s390_trng pkey_ep11 pkey_cca zcrypt_cex4 zcrypt eadm_sch rng_core vfio_ccw mdev vfio_iommu_type1
> > > > vfio drm sch_fq_codel i2c_core drm_panel_orientation_quirks dm_multipath loop nfnetlink ctcm fsm
> > > > zfcp scsi_transport_fc mlx5_ib diag288_wdt mlx5_core ghash_s390 prng aes_s390 des_s390 libdes
> > > > sha3_512_s390 sha3_256_s390 sha512_s390 sha1_s390 sha_common rpcrdma sunrpc rdma_ucm rdma_cm
> > > > configfs iw_cm ib_cm ib_uverbs ib_core scsi_dh_rdac scsi_dh_emc scsi_dh_alua pkey autofs4
> > > > [  241.164399] CPU: 14 UID: 107 PID: 6581 Comm: qemu-system-s39 Kdump: loaded Tainted: G        W  
> > > > 6.16.0-rc7-00005-g4ff8295d8d61 #79 NONE 
> > > > [  241.164403] Tainted: [W]=WARN
> > > > [  241.164404] Hardware name: IBM 3906 M05 780 (LPAR)
> > > > [  241.164406] Krnl PSW : 0704e00180000000 000002482f7f132a (vfio_dma_do_unmap+0x4aa/0x4b0
> > > > [vfio_iommu_type1])
> > > > [  241.164413]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
> > > > [  241.164415] Krnl GPRS: 0000000000000000 000000000000000b 0000000040000000 000000008cfdcb40
> > > > [  241.164418]            0000000000001001 0000000000000001 0000000000000000 0000000040000000
> > > > [  241.164419]            0000000000000000 0000000000000000 00000001fbe7f140 000000008cfdcb40
> > > > [  241.164421]            000003ff97dacfa8 0000000000000000 00000000871582c0 000001c8b4177cd0
> > > > [  241.164428] Krnl Code: 000002482f7f131e: a7890000		lghi	%r8,0
> > > >            000002482f7f1322: a7f4feeb		brc	15,000002482f7f10f8
> > > >           #000002482f7f1326: af000000		mc	0,0  
> > > >           >000002482f7f132a: 0707		bcr	0,%r7  
> > > >            000002482f7f132c: 0707		bcr	0,%r7
> > > >            000002482f7f132e: 0707		bcr	0,%r7
> > > >            000002482f7f1330: c0040000803c	brcl	0,000002482f8013a8
> > > >            000002482f7f1336: eb6ff0480024	stmg	%r6,%r15,72(%r15)
> > > > [  241.164458] Call Trace:
> > > > [  241.164459]  [<000002482f7f132a>] vfio_dma_do_unmap+0x4aa/0x4b0 [vfio_iommu_type1] 
> > > > [  241.164463]  [<000002482f7f1d08>] vfio_iommu_type1_ioctl+0x1c8/0x370 [vfio_iommu_type1] 
> > > > [  241.164466]  [<00000248af27704e>] vfs_ioctl+0x2e/0x70 
> > > > [  241.164471]  [<00000248af278610>] __s390x_sys_ioctl+0xe0/0x100 
> > > > [  241.164474]  [<00000248afc81e56>] __do_syscall+0x136/0x340 
> > > > [  241.164477]  [<00000248afc8da7e>] system_call+0x6e/0x90 
> > > > [  241.164481] Last Breaking-Event-Address:
> > > > [  241.164482]  [<000002482f7f1238>] vfio_dma_do_unmap+0x3b8/0x4b0 [vfio_iommu_type1]
> > > > [  241.164486] Kernel panic - not syncing: Fatal exception: panic_on_oops  
> > > 
> > > Thanks for the report. After a review of this commit, it appears that
> > > only the changes to vfio_find_vpfn() could plausibly account for the
> > > observed issue (I cannot be absolutely certain). Could you kindly test
> > > whether the issue persists after applying the following patch?  
> > 
> > Hi Zhe,
> > 
> > Thank you for the quick patch! I applied this and ran through a few cycles of the previously-
> > problematic tests, and things are holding up great.
> > 
> > It's probably a fixup to the commit here, but FWIW:
> > 
> > Tested-by: Eric Farman <farman@linux.ibm.com>
> > 
> > Thanks,
> > Eric  
> 
> Thank you for your feedback. Also I anticipate that this fix-up patch
> will leave the optimizations introduced in the original submission
> essentially unaffected.

Hi Zhe,

Thanks for the fix.  Could you please send this as a formal follow-on
fix path with Eric's Tested-by and documenting the issue?  Thanks,

Alex

> > > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > > --- a/drivers/vfio/vfio_iommu_type1.c
> > > +++ b/drivers/vfio/vfio_iommu_type1.c
> > > @@ -344,7 +344,7 @@ static struct vfio_pfn *vfio_find_vpfn_range(struct vfio_dma *dma,
> > >  
> > >  static inline struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
> > >  {
> > > -       return vfio_find_vpfn_range(dma, iova, iova + PAGE_SIZE);
> > > +       return vfio_find_vpfn_range(dma, iova, iova + 1);
> > >  }  
> 


