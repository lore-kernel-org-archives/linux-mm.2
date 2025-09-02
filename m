Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E94F0CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 20:49:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 498698E000B; Tue,  2 Sep 2025 16:49:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 470498E0001; Tue,  2 Sep 2025 16:49:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 385718E000B; Tue,  2 Sep 2025 16:49:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 276F68E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:49:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B9D41B8F86
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 20:49:56 +0000 (UTC)
X-FDA: 83845501992.17.D358274
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf26.hostedemail.com (Postfix) with ESMTP id D7DCB140011
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 20:49:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=TCSDXZF2;
	spf=pass (imf26.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756846194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cns0fXIAbt1EqvizSg/wAnSv3SWVs6AXpQ/9VbxT1xc=;
	b=0THoWS/rhZ2OiSXDg7/DoZ++8XBLuoXrmPkMsqSYMjgs34bDQjO/xRee4hnH8BY0uMML1p
	rgom8Of400YsXC4VaApbBIOdc3lYfK01lU8jD4AfUcWdL3kcVJ96A7Y66EjtN2kZnRNMTr
	cUUTlxERbxD27BjXnwaknaUCijAFoi0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=TCSDXZF2;
	spf=pass (imf26.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756846194; a=rsa-sha256;
	cv=none;
	b=SAT/qsZU2H+5g2k7uKH//fqH2XBIjr73K9lwU0rnYqcR4+YgchnCvwjRtvO2d6qKcND8Vz
	9LU1PfG9lZMPv9pp3B2SXh87kKdzUeoXM93tyRAeRZSLSBvjCCmLON1301vaCy8hj4K+Ir
	ryZyejEbHooH+0BSthrNBi9EhvnU92M=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20250902204951euoutp019772216366e471dce5ab670ff270a1c3~hkk2PqBI40583005830euoutp01b;
	Tue,  2 Sep 2025 20:49:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20250902204951euoutp019772216366e471dce5ab670ff270a1c3~hkk2PqBI40583005830euoutp01b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1756846191;
	bh=cns0fXIAbt1EqvizSg/wAnSv3SWVs6AXpQ/9VbxT1xc=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=TCSDXZF2Z62YcDiWqMDDa7Dv+pRBN+EUSjgrFZ1mzkO8tak0poyAI0nhbznKNDhqf
	 D8kNvQjhwMLyfbECL2R2+e0uzHGZze/5arbNIj/FB7PwNbK4vxp5cjSUYa4Wb+jDZr
	 M4rtfp2Rgp2ma7OWloLOB4f81ua8G4Rw/nxkJvc0=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20250902204950eucas1p1185c6ab6c55958183bb0c347b0396b5b~hkk1r34Tc3157531575eucas1p1q;
	Tue,  2 Sep 2025 20:49:50 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250902204948eusmtip14b51a6d907c8deca19aa6660d162e2c8~hkkz6C6Li1369313693eusmtip1I;
	Tue,  2 Sep 2025 20:49:48 +0000 (GMT)
Message-ID: <2d8e67b2-4ab2-4c1f-9ef3-470810f99d07@samsung.com>
Date: Tue, 2 Sep 2025 22:49:48 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v4 14/16] block-dma: migrate to dma_map_phys instead of
 map_page
To: Leon Romanovsky <leon@kernel.org>
Cc: Leon Romanovsky <leonro@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>, Alexander Potapenko
	<glider@google.com>, Alex Gaynor <alex.gaynor@gmail.com>, Andrew Morton
	<akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Danilo
	Krummrich <dakr@kernel.org>, iommu@lists.linux.dev, Jason Wang
	<jasowang@redhat.com>, Jens Axboe <axboe@kernel.dk>, Joerg Roedel
	<joro@8bytes.org>, Jonathan Corbet <corbet@lwn.net>, Juergen Gross
	<jgross@suse.com>, kasan-dev@googlegroups.com, Keith Busch
	<kbusch@kernel.org>, linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-nvme@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	linux-trace-kernel@vger.kernel.org, Madhavan Srinivasan
	<maddy@linux.ibm.com>, Masami Hiramatsu <mhiramat@kernel.org>, Michael
	Ellerman <mpe@ellerman.id.au>, "Michael S. Tsirkin" <mst@redhat.com>, Miguel
	Ojeda <ojeda@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	rust-for-linux@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>, Stefano
	Stabellini <sstabellini@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
	virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
	xen-devel@lists.xenproject.org
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <22b824931bc8ba090979ab902e4c1c2ec8327b65.1755624249.git.leon@kernel.org>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20250902204950eucas1p1185c6ab6c55958183bb0c347b0396b5b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20250819173845eucas1p221cd6842839f5e7130f131cd341df566
X-EPHeader: CA
X-CMS-RootMailID: 20250819173845eucas1p221cd6842839f5e7130f131cd341df566
References: <cover.1755624249.git.leon@kernel.org>
	<CGME20250819173845eucas1p221cd6842839f5e7130f131cd341df566@eucas1p2.samsung.com>
	<22b824931bc8ba090979ab902e4c1c2ec8327b65.1755624249.git.leon@kernel.org>
X-Stat-Signature: 6xhowm68j4jkk7nqtjshsro6tkwmhjz3
X-Rspam-User: 
X-Rspamd-Queue-Id: D7DCB140011
X-Rspamd-Server: rspam01
X-HE-Tag: 1756846193-517690
X-HE-Meta: U2FsdGVkX19kWUA6tPxF+llquFsIsAsaiP5Vp1jRO1jmTm2W9nuoIDEHCFrA0cHHfRl6SPyGKj8o6jWv4DgvWNwLPU4EbumY0n5alXHQI7fcb5A5m/sfMcbU7WLbyUVdPmptcCXctAYOATpQysavaPMJMvN79uAHezUWPQCbYy6rZq6pe7ZNYu3UoakzkRiKprQRHIF+rR9BO43JjaJMwLqwnC9IwKyrWgvETBfRzZ9ag0XzwMnNEMMFPkvIQTUNFDVOQIK3nbDI///AZSciHNfpZE8HcXMBSR5JiCwOamDS9+4G0Y9K6M5JTxyiwyP+X2TtgSb32UXRlrS5Cp/Bz/fQ02mUsw6ZE/VOQcD7TsnDMFG2+gaHfAFG2ILvPcaJKGpyICLQ30GoFZXWKt4QHckZrzCzQuNBQALmJ8C2gVDOLgJ8pQohp5Ee3JfQEDIw836twFJrnR/nwtW+feKcevSMYI/nKswDCm5bTMn3kxBGknLXySOgTKo97U6kjwI2MxiT3jvKRFMe9eY/O7L0f+0tbW95Ad2v2N5nZTZLOQPLgPC85zZ5EDDiM9ZeXJG0hoxwB145SIKvoBbUHi7BjolQ79luQ+ETyp+ROL+Wvz5HyczDFgsB4ecXLWOY7n2qjI+OpqaF2DmS0A1P7YFalKlm4DWXvrt8StF9YZcxUUH/hCftbfoXLDkb+o45zlBvfCoVynFvYkfS6y4A+tWADl4uKy7FilvggCDoB/m3l/0xGp1dIkREKrndBYplxqxKLZ6H3gSFJhSX1lpfXvHHdrc8ncgvQt0eb0QJtbD9GTXBY7j7QMwElP9XzMIvR3BBX98UPk2tTEBc6YPsrIZL5zA6NU5eOp7iU1HwOEmc/GQKmb9TsWOczft/dgZhJ06n0TOKVi35AYeEZCuRzAzEjT2AF2mYaFIaYOEaKmELRSPmHmfGzELP6loE9ADcn1oy+lUZsN+HWEediT2KHIZ
 PBKYx66E
 nFSzbfuUzzqGO2st8wfzDPbZ0TGaZIJ9pZfiVg8h4te7Z/2Luy1HEQ5UJfTrYYDezAGxmXFAItVteZExTCBIDFpwn1iKyp0m1IOggsMRsqFe089ysEo2nBL/6zyjvpHlayVUvSU3yQbL9rBY8s26UmQS3oYN23WJTeoyLBlz9DYLDfkexAc/YnvezDQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19.08.2025 19:36, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
>
> After introduction of dma_map_phys(), there is no need to convert
> from physical address to struct page in order to map page. So let's
> use it directly.
>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>   block/blk-mq-dma.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/block/blk-mq-dma.c b/block/blk-mq-dma.c
> index ad283017caef..37e2142be4f7 100644
> --- a/block/blk-mq-dma.c
> +++ b/block/blk-mq-dma.c
> @@ -87,8 +87,8 @@ static bool blk_dma_map_bus(struct blk_dma_iter *iter, struct phys_vec *vec)
>   static bool blk_dma_map_direct(struct request *req, struct device *dma_dev,
>   		struct blk_dma_iter *iter, struct phys_vec *vec)
>   {
> -	iter->addr = dma_map_page(dma_dev, phys_to_page(vec->paddr),
> -			offset_in_page(vec->paddr), vec->len, rq_dma_dir(req));
> +	iter->addr = dma_map_phys(dma_dev, vec->paddr, vec->len,
> +			rq_dma_dir(req), 0);
>   	if (dma_mapping_error(dma_dev, iter->addr)) {
>   		iter->status = BLK_STS_RESOURCE;
>   		return false;

I wonder where is the corresponding dma_unmap_page() call and its change 
to dma_unmap_phys()...

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


