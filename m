Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42B8ACA0EC0
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 09:35:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC0D18E0027; Mon, 11 Aug 2025 05:35:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C98308E000A; Mon, 11 Aug 2025 05:35:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAE238E0027; Mon, 11 Aug 2025 05:35:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AA30E8E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:35:44 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6D25E1DD9AF
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:35:44 +0000 (UTC)
X-FDA: 83763969408.25.A7200AA
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	by imf25.hostedemail.com (Postfix) with ESMTP id 757AAA0004
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:35:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=GTk5FROV;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf25.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.161 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754904942; a=rsa-sha256;
	cv=none;
	b=dHXFqTdXvk0k/TfnT5TkzL/vluJchJevnR6Kw3n21fYhfY9hwBqbDoKBI0xuWNB2Fd7WbX
	E7t381DyoX62G/F8Gwm8h0r61NUraPQR+wpKSNHOpBRVDyqalYtCIc7P62jCx5cc5QOgVO
	AIGlw28QY+3MzABY8Yc9X5a5aS9Kle0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=GTk5FROV;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf25.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.161 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754904942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rYaSNjo652MdDtNEkrK62ubowtD18Yw4cYxTCIxPtHU=;
	b=cmhXmaicl1RgDqWRu7Nq0eH9TeV9OMXhH0B+x1wIIpdOj7bPfTw3XPvEPo6hlK4UD6zPtp
	8RtxJHOKxMPxvaCQOSdA+OZFdaFXicrrsYregG2OCLQqi8Fddowd+JxK9SNhoZ3gnqyUQw
	Il3MWwdwMepmuMErYFqy6TagG8ljie0=
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4c0qHt1TDXz9t3B;
	Mon, 11 Aug 2025 11:35:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1754904938;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rYaSNjo652MdDtNEkrK62ubowtD18Yw4cYxTCIxPtHU=;
	b=GTk5FROVMTCTxXEJppTQOFY+PCoXfXU0dO6ikOewslNIUGy1NT48uxATKWrhNK5SmFUp+J
	bdYU+VSSFeJfM3LNhz9fz2oQVmhbI9Yxr/R9k4L8fpCJeGFyB05/RXH4ljZ+uygivdVEb6
	WPyKyBkBSC2eJqSmo2xNBaUSwgfmTsvJYuJxADqsbd7JmYkDERu9VBjASWB4mxg7fL9uLp
	eKwwiCGqWgkU04QXht8/a4j2a7fh+CUrTGVIjQVhSevAfaixjy23fZhq9gUstYORo456H0
	SNAxLMr1DEWsFAD40K3IyPE+QcXwbvAxjon0uHgBmMNsaQs9gx3Cy3fBm4tUcw==
Message-ID: <d1560177-b7ec-45f0-beb2-62bd5fe7d3a6@pankajraghav.com>
Date: Mon, 11 Aug 2025 11:35:24 +0200
MIME-Version: 1.0
Subject: Re: [PATCH v3 5/5] block: use largest_zero_folio in
 __blkdev_issue_zero_pages()
To: Jens Axboe <axboe@kernel.dk>, hch@lst.de
Cc: linux-kernel@vger.kernel.org, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 David Hildenbrand <david@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Mike Rapoport <rppt@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 willy@infradead.org, Ritesh Harjani <ritesh.list@gmail.com>,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 "Darrick J . Wong" <djwong@kernel.org>, mcgrof@kernel.org,
 gost.dev@samsung.com, Pankaj Raghav <p.raghav@samsung.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>
References: <20250811084113.647267-1-kernel@pankajraghav.com>
 <20250811084113.647267-6-kernel@pankajraghav.com>
Content-Language: en-US
From: Pankaj Raghav <kernel@pankajraghav.com>
In-Reply-To: <20250811084113.647267-6-kernel@pankajraghav.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 757AAA0004
X-Stat-Signature: ojygj8fu95au883atxsr8f739fpkjzrk
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754904942-907222
X-HE-Meta: U2FsdGVkX1+aNBEUUMpK2VgnXA1SPA/c7UGtNeYC7Pset4oncYXsQrFNmpj64XGww9sX3nAcqrsObXWwrWZdR5HMueDQnu4mHWfWRePgDhIfBG6f7PZsgPnDsC93vpeLMEkRbfcu3TbHINO4+FKtcW/zYaJ+DSO2I4/EtGtV5DiiM56R/5Grp1tgNniZ26mmwH3Ivqh5TyY3FsxQGT41BkFjOp0hcYatFuFFfQKQEAIFC/PBznQjCCT6h2icjuD4w95E9gxoZixoIPyjBbj1fRZc5VVznJ+uGCPILkGogIPqgqy7EdwjgHNCxh/ncd9+OhI2Ywjih/7Q08CMvn/JwKRl8G6wpjjIppg9lVcoFqHaK+mYVeUqtLfLkLqw8qQjee2aR1Syx5P2FJpbOddIoDKD9S+ESVoE2NSxJ9EMItJH7ZqRKYY/zk+Z0VISGGB0dHX3oHVxFtakA7dqEd2/VSfgU9Sszu9N9XMlcZrBG9prBBJ4GTds7yjbPizDhPMi3gQNh3+YVSt4q/dg8XjPabrmGG5+xzcBtrVuj5Ck5uQbedVupxq3uvYZROU1HSXsuSE6CJezByK4zWxxuhROrfiA+eChPhNPM5qJUzni7PfngKAHu7As/cSwiBkPalM9PxYsKi2O0D3I9w19ykxIQYLlR+f+C84c+SQIPlD/D6m7tpVBEGGHmUGkiXTcS9ZK0Ko2qMt4OGICJejkJx1Qo0NXlnejI5+Nxb+IYa39+PNbeDsnH45IrMWuNuZT0ReTcbOrlrP4fnrKFY3g9kNCx4KADkovA3fOb1KLCZKLHHkhJgx2nO5eib7xU5uCenVggLvd3YruQ7PhhgbJ7iMtkOlJWZ2MwPm/p9KXZwVO0HSEFtZOqlSOGfO/PXvlxRO9sine1d3G4KjvISeJ6cKq7DXeTvyex8adoXSrepXsVd2dlkmIHjS2rLvFWyF0jjfypXFGEtJIYnGs7WijA/C
 ov4no5WX
 TmIJ08/EkOkdwUnLPP9bb85NblLrLqyiqk2BUPsp+o4ikBqXaVstQZhMlKUwMMDFK97YTEzVlTtq6Wy5cFg+yHJVIPoxG3h7DVHhy7wf/vLD0rVBeymOauu7BCNkEMnb2ONNzKqJoUYosnOC9LwXg4xmRF8b62EdwdUayV5GUDB3dbnFDNoRCRlIOopeiQjyryhroqyMwOt9ZeXCeXXbkt+P8UG5ENIp1BroHITxTozQnNE2WMiPiboggrpmpba736Jgy8E3dwrwD3lyPcseDmxVDQUt5h5krJIlPAohtHbVzLonkeEMnsXQMoyUGB1gzDAD1AU+gfXUCbWE597GzRE/76Jt9Y9QNnjm0zuF4P5nKyJtEPiWosE43EnHQ+MaiMtxGvS7NQHaFHZ74IKT1NNnnD1/9OC7BNWl/9EBjwF97z+U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/11/25 10:41, Pankaj Raghav (Samsung) wrote:
> From: Pankaj Raghav <p.raghav@samsung.com>
> 
> Use largest_zero_folio() in __blkdev_issue_zero_pages().
> On systems with CONFIG_PERSISTENT_HUGE_ZERO_FOLIO enabled, we will end up
> sending larger bvecs instead of multiple small ones.
> 
> Noticed a 4% increase in performance on a commercial NVMe SSD which does
> not support OP_WRITE_ZEROES. The device's MDTS was 128K. The performance
> gains might be bigger if the device supports bigger MDTS.
> 
> Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  block/blk-lib.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 

@Jens and @Christoph, is it possible to take a quick look of this patch when you have the time?

I already made the changes that Christoph mentioned before, so I think it should
be good to go.

@Christoph, I will send the follow up patches to iomap direct io code once we get these changes
merged.

> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index 4c9f20a689f7..3030a772d3aa 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -196,6 +196,8 @@ static void __blkdev_issue_zero_pages(struct block_device *bdev,
>  		sector_t sector, sector_t nr_sects, gfp_t gfp_mask,
>  		struct bio **biop, unsigned int flags)
>  {
> +	struct folio *zero_folio = largest_zero_folio();
> +
>  	while (nr_sects) {
>  		unsigned int nr_vecs = __blkdev_sectors_to_bio_pages(nr_sects);
>  		struct bio *bio;
> @@ -208,15 +210,14 @@ static void __blkdev_issue_zero_pages(struct block_device *bdev,
>  			break;
>  
>  		do {
> -			unsigned int len, added;
> +			unsigned int len;
>  
> -			len = min_t(sector_t,
> -				PAGE_SIZE, nr_sects << SECTOR_SHIFT);
> -			added = bio_add_page(bio, ZERO_PAGE(0), len, 0);
> -			if (added < len)
> +			len = min_t(sector_t, folio_size(zero_folio),
> +				    nr_sects << SECTOR_SHIFT);
> +			if (!bio_add_folio(bio, zero_folio, len, 0))
>  				break;
> -			nr_sects -= added >> SECTOR_SHIFT;
> -			sector += added >> SECTOR_SHIFT;
> +			nr_sects -= len >> SECTOR_SHIFT;
> +			sector += len >> SECTOR_SHIFT;
>  		} while (nr_sects);
>  
>  		*biop = bio_chain_and_submit(*biop, bio);


--
Pankaj

