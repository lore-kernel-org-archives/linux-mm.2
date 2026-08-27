Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1C63C5DF9D
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 08:24:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD8946B0095; Thu, 27 Aug 2026 04:24:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D88016B0096; Thu, 27 Aug 2026 04:24:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C50286B009B; Thu, 27 Aug 2026 04:24:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9D64D6B0095
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:24:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 21B0AA034E
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:24:21 +0000 (UTC)
X-FDA: 85146362322.17.31AFBD9
Received: from mta0.migadu.com (out-77.mta0.migadu.com [91.218.175.77])
	by imf18.hostedemail.com (Postfix) with ESMTP id D9F211C0003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:24:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bd8ktOay;
	spf=pass (imf18.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.77 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787819059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z4QLV4iaYQJMdB+3K/czkePUUfGgWm40yPo0meYuds8=;
	b=vdmO9AJO+hKGM5K4hFqxCLHDArRWQvfUATojpmZarx5scI3icCfSUkyPG2CYGD48Sa69ED
	vipIyMJ8JhBSLANlWJH5J1VKtjXN5SnfRyl0xlWnznw5T4LZtY97qs/F13dVcHnnI18XV7
	dH5lNP/s7SOOzNJh3NRRdojiLLfM278=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bd8ktOay;
	spf=pass (imf18.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.77 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787819059;
	b=XntnpvolpxEfP9paqsnuWtigsicca8p53dkRuRDN1iEywHsLcnR6PDsscrhLWWmTeUVIbD
	mO9D+/RSUEXVbrkal7Ig7qaJg2OutupJExnB6utK1Tlm9lMQIL94hOnH3kfq4j+1TvSA3t
	fQdDKKxg5TaffVW0r+wyD2GJFUizzuE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Q1xRWIuT1UcJakuU+d2NvgTz2PfPhyXqy+ZlPVDLRi4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787819057; v=1; x=1788423857;
 b=bd8ktOayRThHB9Dmv3mP0vteSINEXbfzeg880B9yL4lvfWMbjmo5CpH3RbIXnQtRCMOnt0nG
 cnl9qcSah8/Amn0GwWBOS0kh7mGV9iA0GUeaA4GqU4ZoIBGmxWQ+VVsucaeU28cWj/+xvdqmpGz
 32Y8uMYj8VNNzt9T/M5WWCNM=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 277c755c97f5e739;
	Thu, 27 Aug 2026 08:24:17 +0000
X-Mizu-Trace-ID: 277c755c97f5e739
X-Migadu-Flow: FLOW_OUT
Date: Thu, 27 Aug 2026 16:24:13 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Yue Haibing <yuehaibing@huawei.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baohua@kernel.org,
	youngjun.park@lge.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] mm/swap: Remove unused declaration
 swapcache_clear()
Message-ID: <ao_0Ld8lISiaVAEf@MiWiFi-R3L-srv>
References: <20260827082722.1809702-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827082722.1809702-1-yuehaibing@huawei.com>
X-Stat-Signature: 1pzmudj9qw5riusoeqajmmrnebn9crqu
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D9F211C0003
X-Rspam-User: 
X-HE-Tag: 1787819058-712028
X-HE-Meta: U2FsdGVkX19JhkQLZgsfdysSfPNL+zxWeL+pDjSZpqB7pkX59pvAIp3WNx+VXImVRB6Kz7BfsZP0Ng030RBeOjs2dYWbbLbhRI8PRBLYBDV50aTKk2ab+iVZKkIhXfiv6lFYNf16C8dcE7oD0Rg3h+9tsw8P+CBDk6tgsXAnbLMpP9g0TK4Qken43fOTc8gJOYoEXzip0Nr4LmgpmTH6nDYmDsJ5ZNYKn95US2je5G2r2QOHO/+E2mp6/MEHcCqzmCRfL2zW/OWI2T+mIMoXoRfVv51ICwPVrjh3F5ekUHU3onezIF1ZC8Dxd6EiczFOFcvgn9wGBmMCTXMp2vaesPMPWHac7Y8CBXREVgvpgUihMBJTcHWu+Cs9fl+Zkmlop/SB+ZCC5a2lmUY0J10eD5CvkFjV9HcRi2X2SmOej3J/wSxsviyMQasoyOpiTv+qCzJJaMPvWzG74CZEc7XLiMJZ0Ju39AuSYsdcoMTLcDnGez+tRORaADrz89EwD5+nlVVV1U/xqkCDK9P4Mx6nGYUFCzhoJinvxTa5yjXRwXQ+j3t70nBHPF6NvG19wnk3UGTawNriTZ95MUqojFMcx3lPPESlXM47lrZbAHGbG6mE2SXuO8ccj0ueUWJ2Ew4yqjYdQAoHhy7xjbwQq9WYLy4hSPj/ICkCgzut8vDBw/hciv/P/sEIYa/mqiwtKtlIeAI+SqzqzcKuARraa749HTzDmwrhz/AfQFqTmn/IdgeP1u2saC4kv2nnaNiXVcZ4kz93orZMDDFcPjijvKRrFNDHwcObSuk1ppvI1WAStyp434zmcJGzaq7iSPIuJSnxq498V0SU+uIj+4xrVqKWOK4xW9fLrEfBa0cOSlnrp/cus0ElWhmxRNrKl+hogpkPoBrBvonBO0aSC0/bvcfBLJwaiKlbPpnQMX1X0a3fw7tJWpDMMT21sbrOYxfgJ16O5DiDftIKAwJSPluFAAr
 km0xD4g/
 mq/lC4BKtHuz9gVN8+TafyQmPiAuAd4eIn+a3LRP3qrpbOuu5Ylnk/HW0EaKmqHCLVXHn6BIHwt2N/JRBagpHlUe/LIEOFO4RO3G4ucDWqSIdubuCwhDLNktEL0htpnk0t8ycqLsqXlUd8X6USMljpWLxjUYgEaIl+090SWtOBuqwRgQ5m93BooZqK7xEjTe8YWzWwjPQrC4/A3Up/Ax4MTeJ1WMmVlyW8V9m1EhWQhVDt/iDpE1y5gjgLKHeJUqtES2BbP86xYRlHWfEzvso5HB0mvva8PZdnm7P7/wT6w697flm1VHr9lnyNdpO/OFHvowJuFuy6/bxT9eOMk3Fr0R4gqmPZrRd8psWyWJlf6WATbok7Be81ZSoRXq03thl6ImX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/27/26 at 04:27pm, Yue Haibing wrote:
> Commit c246d236b18b ("mm/shmem: never bypass the swap cache for
> SWP_SYNCHRONOUS_IO") removed the implementations but leave this.
> 
> Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
> ---
>  mm/swap.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/mm/swap.h b/mm/swap.h
> index d077e5893a42..29060a305443 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -344,7 +344,6 @@ void __swap_cache_replace_folio(struct swap_cluster_info *ci,
>  				struct folio *old, struct folio *new);
>  
>  void show_swap_cache_info(void);
> -void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr);
>  struct folio *read_swap_cache_async(struct swap_io_ctx *ctx, swp_entry_t entry,
>  		gfp_t gfp_mask, struct vm_area_struct *vma, unsigned long addr);
>  struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t flag,

Reviewed-by: Baoquan He <baoquan.he@linux.dev>

> -- 
> 2.34.1
> 

