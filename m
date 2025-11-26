Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5442BD1036D
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 00:18:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 237D16B000C; Tue, 25 Nov 2025 19:18:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20FB16B000E; Tue, 25 Nov 2025 19:18:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 125816B0010; Tue, 25 Nov 2025 19:18:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 00CAC6B000C
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 19:18:42 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A41848B4D3
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 00:18:42 +0000 (UTC)
X-FDA: 84150847284.13.71C50F5
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6957EC0007
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 00:18:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=fb.com header.s=s2048-2025-q2 header.b=W+AKvPIc;
	spf=pass (imf22.hostedemail.com: domain of "prvs=74256e3cee=amastro@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=74256e3cee=amastro@meta.com";
	dmarc=pass (policy=reject) header.from=fb.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764116320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qGBFfom64ubwAcHLmi0kGY4idgptPgMMsGDiFpmxSnI=;
	b=ieURu5Z+ZQ7vqe+AbjYNya0SOyNgJGXszD4yn+gMlSajNeyDsjN215DVUCLYF7Ph+UYx7v
	Cjy7Oj7jG+cHDwYEsrd0/KP/zvScPSnrFItDLAnr8+ft577kkt+mbevsgzoxEaTfukotSZ
	i5vMDA8cbQLWw0CWuf4NBDour8WnVGs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764116320; a=rsa-sha256;
	cv=none;
	b=qGZ6BM+CGm1dzMvtccVsYV6ivBINZ8qEGdDOfkg0XmwAAvkCoSlx8wdR/c92X8tV8Pzt8v
	OfVvRkow1G0ds8UTT2iUqwRzhSUnim+dFVpQOD+cUrk7Eg391L780F3cOsXEViV8WTcbG2
	EtWPjXe9bxFGaMOV6y8ncnYF+hxU82A=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=fb.com header.s=s2048-2025-q2 header.b=W+AKvPIc;
	spf=pass (imf22.hostedemail.com: domain of "prvs=74256e3cee=amastro@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=74256e3cee=amastro@meta.com";
	dmarc=pass (policy=reject) header.from=fb.com
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5APKA97n1087396;
	Tue, 25 Nov 2025 16:18:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=qGBFfom64ubwAcHLmi0kGY4idgptPgMMsGDiFpmxSnI=; b=W+AKvPIcq+Gs
	i3tYYc6MNSXntK0NmrX6mDMiJh2f1He+waI1tJUFw9eep8toqFOiXcXgv1d9N8HG
	PGdbn6/fGl6qS46R20vtpCyrMHLj0wH4JK9pXWvIXkrNgijhiczlYtlomrwOthSj
	zml1ieuFYLYIUzuWZ91PR3D7DWCyaUSc0LCurvPCQxAzzat402xRMP4oyeWdz0ty
	1EYyma4UMfnDB7SWN7UNyv49rng7qo94JM/vlLrbdULgh6NjCeHD1lakMZtk49rg
	EGdIyMsuzoL8EN2ERVeIEmaZ0+aXHHcjPKQINfA5NEORkyA0TfReyUgtpSsOkjBL
	M3cSvkYsxQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4ank8qsk46-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 25 Nov 2025 16:18:10 -0800 (PST)
Received: from devgpu015.cco6.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.29; Wed, 26 Nov 2025 00:18:08 +0000
Date: Tue, 25 Nov 2025 16:18:03 -0800
From: Alex Mastro <amastro@fb.com>
To: Leon Romanovsky <leon@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        Logan Gunthorpe
	<logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
        Robin Murphy
	<robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Will Deacon
	<will@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Jason
 Gunthorpe <jgg@ziepe.ca>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan
 Corbet <corbet@lwn.net>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Christian
 =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Kees Cook
	<kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Ankit
 Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
        Shameer
 Kolothum <skolothumtho@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>, Alex
 Williamson <alex@shazbot.org>,
        Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs
	<mochs@nvidia.com>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <iommu@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-doc@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <linaro-mm-sig@lists.linaro.org>, <kvm@vger.kernel.org>,
        <linux-hardening@vger.kernel.org>, Nicolin Chen <nicolinc@nvidia.com>,
        Jason
 Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v9 06/11] dma-buf: provide phys_vec to scatter-gather
 mapping routine
Message-ID: <aSZHO6otK0Heh+Qj@devgpu015.cco6.facebook.com>
References: <20251120-dmabuf-vfio-v9-0-d7f71607f371@nvidia.com>
 <20251120-dmabuf-vfio-v9-6-d7f71607f371@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251120-dmabuf-vfio-v9-6-d7f71607f371@nvidia.com>
X-Originating-IP: [2620:10d:c085:108::4]
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI2MDAwMCBTYWx0ZWRfX4aU+4yoxvGRI
 fn5uIgo4phoyJLcsXRpkIiEbPHjmDvXjee+0hL5hZTnMf7KiIbVFpuPgNNxmzJnPoXlqYrYFVCb
 EPyFD9HoNuq9bFWOWGD9jm+tH6jYX1bWvVVFfP7wmtxUCfM6nyWp9RhEW4F3WyT2gvOl06d0Lit
 II5EZrklZ4kZ6ZccZ6uI5fnA2fhf1sXF7BU/xkJ1DrQkkrbuth2BkU2ET85sZ92FJE5mmeSgTwT
 8QOBncjhE4/DUMlusLJDyljY4I1YOkD69BDnY6LZhPAqbK1Ws3OXJ/OhGSqPOvK63g6mktQG9A/
 4TjZvhvYG6pYNypXlNsc0JrFDrM/97nZlDYVEtn7wlUXLxFDOXnHdS+vQBslO6M76Dlb+/Whxi6
 97TQYdVHP7oL0xprhG3cL4XfcOc0nA==
X-Proofpoint-ORIG-GUID: 5DCeEKEPh0Lq0c0QeLIVINEpDK6-Nmfl
X-Proofpoint-GUID: 5DCeEKEPh0Lq0c0QeLIVINEpDK6-Nmfl
X-Authority-Analysis: v=2.4 cv=VfT6/Vp9 c=1 sm=1 tr=0 ts=69264742 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=3j4BkbkPAAAA:8 a=qThf3vN7FU90BnacfoAA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-25_01,2025-10-01_01
X-Rspamd-Queue-Id: 6957EC0007
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: ihjyp47fxqjhgpdd4umsc84md47fhm5h
X-HE-Tag: 1764116320-519433
X-HE-Meta: U2FsdGVkX18zdDE3siyfdM6en6O6wLVRgawIZ6b3T0GkGaAtbLEUl9oTokOjNGsRjwbAnrRMEX+upvGAekj+yZhdMss/5fs2KOIIgtGl1wJCDgEykeCNaYkMFAFfCpjVYC8cByTqbHaH2dJZjifugvWaJzBfGW+8Iq/yVZS67G9NkziLdAsv1zZw+o2TE4IKzcZ2mqp0MJyPKu0e8JWJDzTuqV60IT6ocvyhzG7FZDqIZTxldsAb+5ebKFSKaCtoGysfOaYRA1hu0L3aHikzYFYfUkqI2C6jtguZzhPCWoi+ASWuSilh640bdJ3/qUFPTFtv7M8YVz3CEzuq1oVP+EtmxDASXD1BK7YEKOq1UiCyPLtceWpF9EGOBzP84z6LoQhZQWaD87NWVsvr6NjJd47PJ1YtH/peTzNGcKamMVqANhPei0W0ycRRAmw8CeJsJemZtPkb57+CAmIR2HUCyL+Lt+kj4O5htr2voZc486g/p7wvVShAHzbVO98vPEZrcNWmVMtaUocuc4JZsSF7xejjPEkb2eKxwZDmnlnxWEltUCdyEUYQHgCvundfjpZK9lDixY+O3Fk5TxpQGJ8ZmUxpWqJQqM2bPDXWO9t/43u/rlXLsQ6/AfYcVlkrix1HXZHZvs3XhuzDxVO0dea4QI54QvUx8MprKHBewMm+hX24jsE4wPV2a1KxXMRgRYKIsO8U7ofq8Z87mRscysCf4xipqGAW4rZqX2h9EgjC5sSeib/IcHN2t7Gg6SO0w+FN3IGf2SPAX6PMd49Mp9+gzQhgC1Yo3A0jQYV56dY1/B/HMOeoQ8GQC+VbRcxIfkw/R+ZAphrFOO3XhDCS1dZ9sdINCjq6rx3nV8DRjSAWVhBx8obEgf99BJ5QBrmqUtDjTlvRct6DPWJ6GspIfovPSdqyKx+mf8sOQwAoqk6TdD8QM2tU3+/IobDFn1hpoLgn3fwxkU34DzhMdH7RuAG
 PDmSRiK6
 mEmMOTJcuPYKg64YQvQXA0AN/GG6HlpJpdVnH47eb/PEAscIqUwXpuAujup9VY/KYUnW6cdD+be/I7vrTkRXFR6bCEFRIF0uiVtJHp48P2uh2RFeuL+6yL53mLjdo9T5CSMfk1o3ceLj9lZwg9Pk8NsftTRPKLxIn22mNbAqljQsp4hDDQAy58yWvLA1TMQ+/n3cIJc+drYQ4RbG5LyPKAf/r8yLBSx0WtLNHyVAsauNTSMylCuNDG3wZuStfQ0Ru2cZvDWWWKOtxGyiZ1+K/ByeMRf+lsMHay58GAcRIV4741mKzvrb2sG+qB6+xM7U9XiY86wetQMVWQkPEjbo29Bk9Yw3VDeEtDOFHu0K7fwWbZHOlnjHRJsSxh93HT2UmfOuL0rtNu9z8p6czLmaABhumjxb7jk+lSmSWMrcqu4ojpsrjhogW/OD4sYhcxK+UdGWPtlDt3ZEFu+WjON2tFZ7CPl5Ex89gb7wi40WWhSRGC9DDc8IVF56G/u2u9nPZahKHQM4bv8EJRAA2vzAXOTg2ZSxp+a0+cO1fyNdaV/bNZlY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 11:28:25AM +0200, Leon Romanovsky wrote:
> +static struct scatterlist *fill_sg_entry(struct scatterlist *sgl, size_t length,
> +					 dma_addr_t addr)
> +{
> +	unsigned int len, nents;
> +	int i;
> +
> +	nents = DIV_ROUND_UP(length, UINT_MAX);
> +	for (i = 0; i < nents; i++) {
> +		len = min_t(size_t, length, UINT_MAX);
> +		length -= len;
> +		/*
> +		 * DMABUF abuses scatterlist to create a scatterlist
> +		 * that does not have any CPU list, only the DMA list.
> +		 * Always set the page related values to NULL to ensure
> +		 * importers can't use it. The phys_addr based DMA API
> +		 * does not require the CPU list for mapping or unmapping.
> +		 */
> +		sg_set_page(sgl, NULL, 0, 0);
> +		sg_dma_address(sgl) = addr + i * UINT_MAX;

(i * UINT_MAX) happens in 32-bit before being promoted to dma_addr_t for
addition with addr. Overflows for i >=2 when length >= 8 GiB. Needs a cast:

		sg_dma_address(sgl) = addr + (dma_addr_t)i * UINT_MAX;

Discovered this while debugging why dma-buf import was failing for
an 8 GiB dma-buf using my earlier toy program [1]. It was surfaced by
ib_umem_find_best_pgsz() returning 0 due to malformed scatterlist, which bubbles
up as an EINVAL.

$ ./test_dmabuf 0000:05:00.0 3 4 0 0x200000000
opening 0000:05:00.0 via /dev/vfio/56
allocating dma_buf bar_idx=4, bar_offset=0x0, size=0x200000000
allocated dma_buf fd=6
discovered 4 ibv devices: mlx5_0 mlx5_1 mlx5_2 mlx5_3
opened ibv device 3: mlx5_3
test_dmabuf.c:154 Condition failed: 'mr' (errno=22: Invalid argument)

$ sudo retsnoop -e mlx5_ib_reg_user_mr_dmabuf -a 'mlx5*' -a 'ib_umem*' -a '*umr*' -a 'vfio_pci*' -a 'dma_buf_*' -x EINVAL -T
Receiving data...
13:56:22.257907 -> 13:56:22.258275 TID/PID 948895/948895 (test_dmabuf/test_dmabuf):
FUNCTION CALLS                                 RESULT                 DURATION
--------------------------------------------   --------------------  ---------
→ mlx5_ib_reg_user_mr_dmabuf
    ↔ mlx5r_umr_resource_init                  [0]                     2.224us
    → ib_umem_dmabuf_get
        → ib_umem_dmabuf_get_with_dma_device
            ↔ dma_buf_get                      [0xff11012a6a098c00]    0.972us
            → dma_buf_dynamic_attach
                ↔ vfio_pci_dma_buf_attach      [0]                     2.003us
            ← dma_buf_dynamic_attach           [0xff1100012793e400]   10.566us
        ← ib_umem_dmabuf_get_with_dma_device   [0xff110127a6c74480]   15.794us
    ← ib_umem_dmabuf_get                       [0xff110127a6c74480]   25.258us
    → mlx5_ib_init_dmabuf_mr
        → ib_umem_dmabuf_map_pages
            → dma_buf_map_attachment
                → vfio_pci_dma_buf_map
                    ↔ dma_buf_map              [0xff1100012977f700]    4.918us
                ← vfio_pci_dma_buf_map         [0xff1100012977f700]    8.362us
            ← dma_buf_map_attachment           [0xff1100012977f700]   10.956us
        ← ib_umem_dmabuf_map_pages             [0]                    17.336us
        ↔ ib_umem_find_best_pgsz               [0]                     6.280us
        → ib_umem_dmabuf_unmap_pages
            → dma_buf_unmap_attachment
                → vfio_pci_dma_buf_unmap
                    ↔ dma_buf_unmap            [void]                  2.023us
                ← vfio_pci_dma_buf_unmap       [void]                  6.700us
            ← dma_buf_unmap_attachment         [void]                  8.142us
        ← ib_umem_dmabuf_unmap_pages           [void]                 14.953us
    ← mlx5_ib_init_dmabuf_mr                   [-EINVAL]              67.272us
    → mlx5r_umr_revoke_mr
        → mlx5r_umr_post_send_wait
            → mlx5r_umr_post_send
                ↔ mlx5r_begin_wqe              [0]                     1.703us
                ↔ mlx5r_finish_wqe             [void]                  1.633us
                ↔ mlx5r_ring_db                [void]                  1.312us
            ← mlx5r_umr_post_send              [0]                    27.451us
        ← mlx5r_umr_post_send_wait             [0]                   126.541us
    ← mlx5r_umr_revoke_mr                      [0]                   141.925us
    → ib_umem_release
        → ib_umem_dmabuf_release
            ↔ ib_umem_dmabuf_revoke            [void]                  1.582us
            ↔ dma_buf_detach                   [void]                  3.765us
            ↔ dma_buf_put                      [void]                  0.531us
        ← ib_umem_dmabuf_release               [void]                 23.315us
    ← ib_umem_release                          [void]                 40.301us
← mlx5_ib_reg_user_mr_dmabuf                   [-EINVAL]             363.280us

[1] https://lore.kernel.org/all/aQkLcAxEn4qmF3c4@devgpu015.cco6.facebook.com/

Alex

