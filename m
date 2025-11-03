Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAE95CCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 20:07:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F02E8E00C9; Mon,  3 Nov 2025 15:07:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C7678E0058; Mon,  3 Nov 2025 15:07:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B6548E00C9; Mon,  3 Nov 2025 15:07:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0666D8E0058
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 15:07:48 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BF34C1394B8
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 20:07:47 +0000 (UTC)
X-FDA: 84070381374.25.0AF5035
Received: from relay.hostedemail.com (unirelay10 [10.200.18.73])
	by imf09.hostedemail.com (Postfix) with ESMTP id 36924140018
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 20:07:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762200465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n9Hp+W96E82ffeM9TGY/T64q12eMoTlbRaWkBHrOVhQ=;
	b=QIpG0tj+1UFukr2I76Jdo8OTzuKzNYoISS6dXYFS9b+oNCb2UNYMOSXxmA5kCiL/8chmjT
	HNck20/Po2e9hxjLT+1MphGrvskzIsodVAw8P4C4NP9hZp/RQ1ZcfEOiIhR4peIrh30EkK
	P/qFxZCdpBU4o3aMdGfoRJswCSH+CxE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762200465; a=rsa-sha256;
	cv=pass;
	b=WCSif2gXQ8G0z2iVOAQMlq1oKewNw8fzTTgkaZoMnfokpnwxIsRW3RUpzA5XYLOCKKpeov
	MntimRCYZmVvgHq3YZW/jGezytCO05EeVOFr7zaapnFarscYthdAd99TTk65YsOBKHQf8S
	lyz/g1L4TsAHA4MdvqJru0D8ijr5W88=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B3D00C028F
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 20:07:44 +0000 (UTC)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 85E5E13A70E
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 20:07:44 +0000 (UTC)
X-FDA: 84070381248.25.5E2E4BF
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf22.hostedemail.com (Postfix) with ESMTP id 288F7C0012
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 20:07:41 +0000 (UTC)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762200462; a=rsa-sha256;
	cv=none;
	b=QUviuUAkqF9LnO8BgMe8okhtzTZoEkWnGiunk7fWAFi8pbfz7FBJAl6jTF67XqukEy8H1X
	HIaPBHXWE9AnG2I+Q7vCods3LMQK3ARKJA1PBkICJ1SwpnUr5DLrGBRhxJB9T++bIfkf0x
	vd0XUnu9bBYL80hWl4WMH9gkJbjnGQw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=fb.com header.s=s2048-2025-q2 header.b=Y5TYvio2;
	dmarc=pass (policy=reject) header.from=fb.com;
	spf=pass (imf22.hostedemail.com: domain of "prvs=740262d6a4=amastro@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=740262d6a4=amastro@meta.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762200462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n9Hp+W96E82ffeM9TGY/T64q12eMoTlbRaWkBHrOVhQ=;
	b=Kz6NwwndDV43z+n8+urjKxS3Pzu7MgDCfnEaowMNyQy3CtLPJ9gHHlP/feUEKMjrko7dVL
	iN4/DPMuE68DfCSkOtTbBsCymKGXN4zn37JIhWPky82w+SK2tsqk30tW6tkzMzfqghi/hY
	OeAFKiHoF6ryWsXBQaetzr+S7fvYWjI=
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5A3HSUl13368916;
	Mon, 3 Nov 2025 12:07:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=s2048-2025-q2; bh=n9Hp+W96E82ffeM9TGY/
	T64q12eMoTlbRaWkBHrOVhQ=; b=Y5TYvio2wy42a6OuNV1jizo/aQU5rL6HohWI
	OdRswHnuwgKDGg4PRZorsSwOwSWNepxL3lv6e92F0ZZiEQOO8ZMDqwElBWya7VYx
	yHZJ1Bg/rdGSvGKN1xCect7aLk4BJP3dFq0W4bRU4thNy47l/7qf6QCLDdrJWuYT
	ttchffm5fJ8azlwk2GD5NtPH33FSvCNhfhPKLPVh0Qs6M/RaBFY1LsIhyFIHXKOv
	PPwMbL4I1eFF62/08bb33eCUiaTLoRka7NFBHCCzuXtuZDc3HhRZW8A7Jd4FsCBj
	aU36aw88WsqWA0jpB+Nf9LOBQRQOfcCvornGVmHGoYNGSzpsQw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4a6yfe2849-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 03 Nov 2025 12:07:21 -0800 (PST)
Received: from devgpu015.cco6.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Mon, 3 Nov 2025 20:07:19 +0000
Date: Mon, 3 Nov 2025 12:07:12 -0800
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
        Alex Williamson
	<alex.williamson@redhat.com>,
        Kees Cook <kees@kernel.org>,
        "Gustavo A. R.
 Silva" <gustavoars@kernel.org>,
        Ankit Agrawal <ankita@nvidia.com>, Yishai
 Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <skolothumtho@nvidia.com>,
        Kevin
 Tian <kevin.tian@intel.com>,
        Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs
	<mochs@nvidia.com>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <iommu@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-doc@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <linaro-mm-sig@lists.linaro.org>, <kvm@vger.kernel.org>,
        <linux-hardening@vger.kernel.org>,
        Vivek Kasireddy
	<vivek.kasireddy@intel.com>
Subject: Re: [PATCH v6 00/11] vfio/pci: Allow MMIO regions to be exported
 through dma-buf
Message-ID: <aQkLcAxEn4qmF3c4@devgpu015.cco6.facebook.com>
References: <20251102-dmabuf-vfio-v6-0-d773cff0db9f@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251102-dmabuf-vfio-v6-0-d773cff0db9f@nvidia.com>
X-Originating-IP: [2620:10d:c085:208::7cb7]
X-Authority-Analysis: v=2.4 cv=G9QR0tk5 c=1 sm=1 tr=0 ts=69090b79 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=FOH2dFAWAAAA:8 a=b_Saz7MSmFOFN_6dvx4A:9 a=CjuIK1q_8ugA:10
 a=DXsff8QfwkrTrK3sU8N1:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=bWyr8ysk75zN3GCy5bjg:22
X-Proofpoint-ORIG-GUID: F1nk6hmysPbKhKVQa_mqqIFKqOIt2lHM
X-Proofpoint-GUID: F1nk6hmysPbKhKVQa_mqqIFKqOIt2lHM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAzMDE3OSBTYWx0ZWRfX6SW28Xvycs0O
 YOKukhqpHcTfkYNeGRk02UVQnYAieNl0FPP5nyOoQsMjQfkPKcUonaa3EWc/tqdoAAQyhyOyp0d
 /JHwcN3QLYQ/+EZJhZ2InHvQ5+q0ThEzTdyBEGsfGK6Opxy38U0CpsznUzKLwU/5Eqh1l493VDE
 PyTsfwJm0au//MmeaXH4NXKBaJs6mnL334sMoj6rtJQYWDX5DKMNRtgxvcMAQid95nsgniy4DYE
 +umaq/vNBvV3b0K6HXe0s/cT+YOR8m2DkpctVf5zXXorytYnhbn1vV3nGRWxaQ24cLeCzQnNSqB
 UmVF2ZqiQwbE9Yb71RMC4EJcfgbsbmodipz9oljstvRLhQ7lzspcSOdC0w5Z4QcLNUWGre4urgV
 ZaziQQl4T7tsVkAKgmifB2A8A6gzCQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-03_04,2025-11-03_03,2025-10-01_01
X-HE-Meta: U2FsdGVkX1/ahO3XMG4E/jh4btL2o1XT1zkfmkFg+Khj883Ztoffx+HEcHWjjT9PxO5FYpPIQdy3b2W57eEj9ikxC8mkHxyU9qSPKoOxjy/HOvklgwqn8i7XedwlmndXpFApgpDJQFH6bGssyt548ukRlZCT21OqmVpV/crtri013om3je5M8qWqbaOQ8OqtT8aIEDxyt6UPY8p8vaACP9Jx7D2vgDZaWROzTCMxg0glfvlqw4fofD30dMRHnjUqot69m3FOtv6LyPWMTVMquIifBYPeDlGs1phguPh3UGApUNrelSzAbaBbeAIo08N3uADX7je3L+Mraf8dMjIp5ApSSDMb9P4EIQveUA4JOmNk5mOUsVxs+nd+CUyn+4rptaCcGN0+kd9au/8v7G4GwalxZmCVGBZ0yBEr1PaN+YHc9QEZyH7SP630Xy8gXeFr6LeLgk+96kjP4N4uXPLvqxIBnuqO/kxgtg4BH7WP/zpPz88XSu4NwOvEdUqcUauiFYX3C4n2Oj+IL2V/cqDxnEhUktc9wx3WnOQbBLr289VE7RJu6w+h+/7UKS1I8zpBwWvRCK2Y5tRaHf7zjbqqeu8ys6VL7+BvXIhYVs4qEmNQrfnog9OVKke6/ufAwZkQBAWgI9Q71EKdrkLWjIxjlnPIG8NpDtcNjZZ9fBUpjCQ8QCyeybCr1aQVO0DqdHUMqlveMFETmkzXjMN/45exNVSYXA7pt29qS3zt6sxZO88ovXESHi65SLf6T+Z0fAPAcrLUB7nc9fdA3Ru3CBv30e5j0wcW668O8CG7EFN02SsxHo2U9MPqy7BVrPKpawqhA2vp6FInuZxPuupmoyS45mu0SdtdCtaT7rFhPOrqPQIqh33ICZAv9YCANUl7oivSwEeROG9xLWiePuDzckS1TEZcTbZ+V0S7aXtKF+exrleYZRzydDBsNxhFjgbU5/Grhwe6ULdzqiR8W6XXYTO
 Te13Go2f
 NZ4rIFZRRYlgKwo4iaL8j0tLH27HyJTVWPxWfM23v3fKf8N1yVXz4/fVvYG9gmk/0GCVmRwd0e3ljRsdtN83HP9x/3UGHqxyapH7eDm9XR55fl0hbjnXLLaUVaSsqMkGj0p32pYNUL7z/3HzFTk0kAv9JqghzP1FIQjl+OodlEbfAcBkmTATiuKbyh6M73qjr2ouDB/Nuf4cyQYgESZ4XyRKuENg1HzJIG1+kIccwCfj3GOrgo8VnhrE9DBPMzOp2a6+oUyFfmZYAWX7g+ODGBhIk8stzywB03dM/KFAy8q/d4uVeYGr89jtuC+RMebwva2pXXQSe024+8pqB8TSNwVo3dnUt1KOcZQudfqdMVyTTlr41NXWPIIH1+5Ll1gmourmNxJFLSvOaM/py1SJR2xI1U588lRfeynEYjT83xIHSD6Smj3nBA4pVQCuqr3n8XhNj
X-Stat-Signature: 3rqcr6tc47e7rwzue6czghkic8ksazbz
X-HE-Tag-Orig: 1762200461-696451
X-Rspam-User: 
X-Rspamd-Queue-Id: 36924140018
X-Rspamd-Server: rspam01
X-HE-Tag: 1762200465-879036
X-HE-Meta: U2FsdGVkX1/1lS/AGzr0oRqdvOjq2HhxR7XI6Zs150hZ/720/TO0popzwST0iksXDqKFe476p8co9rfSVLyEd/DM68PEsaO+AIJrqFoDI7rEu32CAN/yRgrOaUw4cje1rdG54SEoIfTDZxNq/Br9UPTAaJ2C8Sc5hzBvXFGZZ8G+C2bFjXXq+RPwPUXM1droMZjQijTe+wMVe+tQbn7oILLWIKHWGo9uNF/ZEYJJXS5tu1B7aq/sMpHlkChAZBd5xf8xDXGyeeuUpRZHirjvkkNlw08PQMR1spRGROooM/Go1yNfue07m5Vb84ohB+hcsTBR8K4X2TcGQYpYhKGHh1ZHYoQaQcnh1OL/diRAV5QFuMx8Ci+NHPhjYewRYL/sli643Gx7PZdqRytnvYAAliNx1quAW/WM3TctOoouss9CjnGARHwZAeuIt/VeuxoOOU2Fwp7FkW8ZtrSoLvPRJ3tj5OPaYQRQJLWZ1ClFGX5tHLQ2UYp2tqdaj1AZopvYczju5MPyf16MvVeeyzqRDShXSi67x0+cyAkGnLxB8w42GN5u4s4MOPqhNVFzN1cYxUqgLieTqV/sbPlBNBMrz0Q9uGsy5a+0sunBGbKqb8Yp0BHj8BUhRJY5BqNbnO+4xKuuGyaQKXe/CxefEMag3BVGfybgm5WLK2jgINAqn0LUbKUoZyNb+MwTBSWEUZcGmk5fL3I4fYotkVi3eDBaeIzspZcmh3bqRC01QOjqT1CCM0kQXxiP/z4QxwaMGvAwgOVU/pBomh/P/3LScaf9xvmcr/lRZrWO54n5OZ+tT6XS1cPXjtxFyQKtfxMuCFmkz4ChofXH1GHX1uJTlz4LrJKwwYik5hPfEcR75rQb9zn1rqulSwRKmPnqr6kKWxi6cxHA6MNLG/cBpk8x8XMCWXC+bo4BJOv1x5kZWokqbDdYzmi5wd2740rz1wXhIF5lWtPayAGS1tBAcMTjpua
 /zNiJjLD
 jYN2+HdapGzULhxZ7IiYY6QQyGp/ZNz4KqmT1nqI1ZPpZy3ovEt8i4vOZHIRSh08auMlrlNW5hm8dZ9i+l8b8/0EdK+LtYkc4a7Yjb7MLiUg3CCA1h9yRqBkGF3BXrAHdqlkjU2G+P9VzR0AVo7JyT41cVJFH5ivx0N3AT18DyWE/i9S39o4jHxasm83LgEM2k97V8dXDh+9eGd5maEACQ2e/Os5erZl89E2jCmLwjSXHWKHWMkPodpdK4o3+REuSHXb2KX4rRQw5F/rmeDGzbbsATMfTs4co4uWEiMibd2ZSN8TsAfP9BS2K3mkugJXB4vdz6PapK7gVc2WnlDem8aArhAcmZSl/7QxdIPOUNHPOH+uhC0JjbhsL/PiELszP4z88ZAbDxkbFQcn2PSpKbE381A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 02, 2025 at 10:00:48AM +0200, Leon Romanovsky wrote:
> Changelog:
> v6:
>  * Fixed wrong error check from pcim_p2pdma_init().
>  * Documented pcim_p2pdma_provider() function.
>  * Improved commit messages.
>  * Added VFIO DMA-BUF selftest.
>  * Added __counted_by(nr_ranges) annotation to struct vfio_device_feature_dma_buf.
>  * Fixed error unwind when dma_buf_fd() fails.
>  * Document latest changes to p2pmem.
>  * Removed EXPORT_SYMBOL_GPL from pci_p2pdma_map_type.
>  * Moved DMA mapping logic to DMA-BUF.
>  * Removed types patch to avoid dependencies between subsystems.
>  * Moved vfio_pci_dma_buf_move() in err_undo block.
>  * Added nvgrace patch.

Thanks Leon. Attaching a toy program which sanity tests the dma-buf export UAPI
by feeding the allocated dma-buf into an dma-buf importer (libibverbs + CX-7).
 
Tested-by: Alex Mastro <amastro@fb.com>

$ cc -Og -Wall -Wextra $(pkg-config --cflags --libs libibverbs) test_dmabuf.c -o test_dmabuf
$ ./test_dmabuf 0000:05:00.0 3 4 0 0x1000
opening 0000:05:00.0 via /dev/vfio/56
allocating dma_buf bar_idx=4, bar_offset=0x0, size=0x1000
allocated dma_buf fd=6
discovered 4 ibv devices: mlx5_0 mlx5_1 mlx5_2 mlx5_3
opened ibv device 3: mlx5_3
registered dma_buf
unregistered dma_buf
closed dma_buf fd

---
#include <fcntl.h>
#include <infiniband/verbs.h>
#include <libgen.h>
#include <linux/limits.h>
#include <linux/types.h>
#include <linux/vfio.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <unistd.h>

#define ensure(cond)                                                             \
	do {                                                                     \
		if (!(cond)) {                                                   \
			fprintf(stderr,                                          \
				"%s:%d Condition failed: '%s' (errno=%d: %s)\n", \
				__FILE__, __LINE__, #cond, errno,                \
				strerror(errno));                                \
			exit(EXIT_FAILURE);                                      \
		}                                                                \
	} while (0)

#ifndef VFIO_DEVICE_FEATURE_DMA_BUF
#define VFIO_DEVICE_FEATURE_DMA_BUF 11

struct vfio_region_dma_range {
	__u64 offset;
	__u64 length;
};

struct vfio_device_feature_dma_buf {
	__u32 region_index;
	__u32 open_flags;
	__u32 flags;
	__u32 nr_ranges;
	struct vfio_region_dma_range dma_ranges[];
};
#endif

static uint32_t group_for_bdf(const char *bdf)
{
	char path[PATH_MAX];
	char link[PATH_MAX];
	int ret;

	snprintf(path, sizeof(path), "/sys/bus/pci/devices/%s/iommu_group",
		 bdf);
	ret = readlink(path, link, sizeof(link));
	ensure(ret > 0);

	const char *filename = basename(link);
	ensure(filename);

	return strtoul(filename, NULL, 0);
}

int main(int argc, char **argv)
{
	int ret;

	if (argc != 6) {
		printf("usage: %s <vfio_bdf> <ibv_device_idx> <bar_idx> <bar_offset> <size>\n",
		       argv[0]);
		printf("example: %s 0000:05:00.0 3 2 0x20000 0x1000\n",
		       argv[0]);
		return 1;
	}

	const char *bdf = argv[1];
	uint32_t ibv_idx = strtoul(argv[2], NULL, 0);
	uint32_t bar_idx = strtoul(argv[3], NULL, 0);
	uint64_t bar_offs = strtoull(argv[4], NULL, 0);
	uint64_t dmabuf_len = strtoull(argv[5], NULL, 0);

	uint32_t group_num = group_for_bdf(bdf);
	char group_path[PATH_MAX];
	snprintf(group_path, sizeof(group_path), "/dev/vfio/%u", group_num);

	int container_fd = open("/dev/vfio/vfio", O_RDWR);
	ensure(container_fd >= 0);

	printf("opening %s via %s\n", bdf, group_path);
	int group_fd = open(group_path, O_RDWR);
	ensure(group_fd >= 0);

	ret = ioctl(group_fd, VFIO_GROUP_SET_CONTAINER, &container_fd);
	ensure(!ret);

	ret = ioctl(container_fd, VFIO_SET_IOMMU, VFIO_TYPE1v2_IOMMU);
	ensure(!ret);

	int device_fd = ioctl(group_fd, VFIO_GROUP_GET_DEVICE_FD, bdf);
	ensure(device_fd >= 0);

	uint8_t buf[sizeof(struct vfio_device_feature) +
		    sizeof(struct vfio_device_feature_dma_buf) +
		    sizeof(struct vfio_region_dma_range)]
		__attribute__((aligned(32)));

	struct vfio_device_feature *ft = (struct vfio_device_feature *)buf;
	*ft = (struct vfio_device_feature){
		.argsz = sizeof(buf),
		.flags = VFIO_DEVICE_FEATURE_GET | VFIO_DEVICE_FEATURE_DMA_BUF,
	};

	struct vfio_device_feature_dma_buf *ft_dma_buf =
		(struct vfio_device_feature_dma_buf *)ft->data;
	*ft_dma_buf = (struct vfio_device_feature_dma_buf){
		.region_index = bar_idx,
		.open_flags = O_RDWR,
		.nr_ranges = 1,
	};

	ft_dma_buf->dma_ranges[0] = (struct vfio_region_dma_range){
		.length = dmabuf_len,
		.offset = bar_offs,
	};

	printf("allocating dma_buf bar_idx=%u, bar_offset=0x%lx, size=0x%lx\n",
	       bar_idx, bar_offs, dmabuf_len);
	int dmabuf_fd = ioctl(device_fd, VFIO_DEVICE_FEATURE, buf);
	ensure(dmabuf_fd >= 0);
	printf("allocated dma_buf fd=%d\n", dmabuf_fd);

	int num;
	struct ibv_device **devs = ibv_get_device_list(&num);
	ensure(devs && num > 0);
	printf("discovered %d ibv devices:", num);
	for (int i = 0; i < num; i++) {
		printf(" %s", ibv_get_device_name(devs[i]));
	}
	printf("\n");
	ensure(ibv_idx < (uint32_t)num);

	struct ibv_context *ctx = ibv_open_device(devs[ibv_idx]);
	ensure(ctx);
	printf("opened ibv device %d: %s\n", ibv_idx,
	       ibv_get_device_name(devs[ibv_idx]));

	struct ibv_pd *pd = ibv_alloc_pd(ctx);
	ensure(pd);

	uint64_t offset = 0;
	uint64_t iova = 0;
	int access = IBV_ACCESS_LOCAL_WRITE | IBV_ACCESS_REMOTE_READ |
		     IBV_ACCESS_REMOTE_WRITE;

	struct ibv_mr *mr = ibv_reg_dmabuf_mr(pd, offset, dmabuf_len, iova,
					      dmabuf_fd, access);
	ensure(mr);
	printf("registered dma_buf\n");

	ret = ibv_dereg_mr(mr);
	ensure(!ret);
	printf("unregistered dma_buf\n");

	ret = close(dmabuf_fd);
	ensure(!ret);
	printf("closed dma_buf fd\n");

	return 0;
}
---


