Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33C8ECCA470
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 03:03:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BBAF8E004D; Wed,  8 Oct 2025 23:03:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 793808E0002; Wed,  8 Oct 2025 23:03:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D0B88E004D; Wed,  8 Oct 2025 23:03:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5D0F48E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 23:03:03 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 14F1BC0932
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 03:03:03 +0000 (UTC)
X-FDA: 83977079046.03.9FD3663
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf26.hostedemail.com (Postfix) with ESMTP id 71D33140005
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 03:03:00 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VyIJmssX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of chengming.zhou@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=chengming.zhou@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759978981; a=rsa-sha256;
	cv=none;
	b=DijU3/imhTU+BHET3GxOAVpHgWOKlYTxpdcCknxkj0/Y3Vkhp+EnqM+RLe0+VmVpTnfp1u
	Ggj67+YsgOtoa0zVjcQQy9adin2UXaID+MNOO1mMac5gtSCh/f82Bau/Yve4velSYAev84
	sAXWbDLI3dNoysxZTHC/JAkZN5DliQY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VyIJmssX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of chengming.zhou@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=chengming.zhou@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759978981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5YEIJe1l7uPPwXCLKi51on2x3YEMf9V1p1qQ0Ogt3bY=;
	b=gHpb1AwKyKvp4GKSKMN9U0umwX5IHKoW3+wXBzq4iNzoGPTfz1uhrYsxE/vzCtEwhPEa+v
	+NZq6VLEojFy5yC8pdZN6/UuUEIHI7FNXVhVCzgOTwG9k1rNCwiv24zzsTigYZkzN60maW
	SjuQqoO9S99xY2WCdAZhftZnp5mlcN0=
Message-ID: <7e3de261-0421-439e-a763-7f2895c2496f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759978978;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5YEIJe1l7uPPwXCLKi51on2x3YEMf9V1p1qQ0Ogt3bY=;
	b=VyIJmssXWpo4mfVElfR8iHujbljan6VThvQAVU7woPIpircc2b+FrP//5zchULofz5Stjn
	Vty8Ap7MH+g+82dkjpSBtZpApBVxWiDXh95a/dWrMrBWNyrHXlpzmdu6C8xKMGwiHtavco
	tNyFnoSdV0823jYmFGf9N6JSVGWtXew=
Date: Thu, 9 Oct 2025 11:02:50 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 2/4] mm/zswap: fix typos: s/zwap/zswap/
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry.ahmed@linux.dev>,
 cgroups@vger.kernel.org, kernel-team@meta.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20251003203851.43128-1-sj@kernel.org>
 <20251003203851.43128-3-sj@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Chengming Zhou <chengming.zhou@linux.dev>
In-Reply-To: <20251003203851.43128-3-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 71D33140005
X-Stat-Signature: wwhrufxjaiidxg4zyb5hnwr4du6nzhf9
X-HE-Tag: 1759978980-924502
X-HE-Meta: U2FsdGVkX18xmAavJlQyuobctqsijBBSMs7wXiU28MVoF9tD4sLKUJoDPCBZsjy2Y/xnTlpqa4QPN0oSI4IACTuAiicL6Ls6HV73PngUH1LaurgEbMauHLi49tDE2crERCkAWtrEWmynqEV6Odib4mgPeWluCDC9aiXJW6UZxlZc77FQHE/LSCVy0gnnwfsw87abggMnAiruSRVLfZUZY1LkZ9Z8PbB7ii/77vZLrOa1hjwZD6yjwvicMMYhx8LgcTCYbyDvTNgVMEFFFHRddSWyck8jJ9XwXSX+ZB8fmHZ+eYCBMYsNnl1lxFBaraGd9LqD4N0S98ScAykAVFBPFyDTYlF2esPpS+f4r/MseysyLYz14nMa7RtgATUsN8E2Jo9xr/wHdIGaBykFIYYG6qU/KtLMu8FhsmndMBo/SZn2v5zeO+0erueqSJR+mmbBpHShZCx8bChqwvhsTGBOcNEQtYYWfpIPZjttgFxRT1WyYhoc0Ilqpt1P/nDucUu+8ImH/2JVYfytQtpUdJN++48ywOd4p0Mbs4Qcg2a6jmXctXCqiBXHYevK5tMazkfUsztaHkCjxEgGtFMXTN2/XRCQVq30CLA/ZzzeukOpEBk8h7q8bP32yRxTFJQ7U5D+sckhCLwyqvq+GOJI/DIA4hvaDXQeA53g7dYpl4WBwAl7BOh1L1VzDBG8qhojZ1OHI45CoTnInl0v8Iq3AA/yZ51ZR9rjEc8SGlZZEkx/+U+GXCedEkNXacjleWcBXQPbdHexh825AgUEjLmOy7jLOYHU0PhA7sq6PTWjjr5iWVf46rf0aaMAwPkORu/RPBD1Ddgm8wiQlxbQToy03PUXvTLlE51HkHFrkiXMxTHKvJeN55DRvm2Vm/XVNRVHa98KafFizJ9zKNZk5MEcwyGMrmT+SBFWPBQpUvBSJU9BGASizObHnh8+I6aCZlLimK8kmxDnDKvlL948U/gYjaS
 OwAIKz0c
 CYTImdCyL8zEM2feWsgMstoUL5KNbZnQKWNTbEwYpab5KZUnzXxI1yyhwfT2k3j2Dafr3e2uec/kJadWytpqYCtJtfEH62e47yFcmHI5lDqoL4b8Mlce6PKLDKkUNAo83sSgpxdXyw8jnS9nIu1DT6dQFKzLmJDjOMadTsSBQqvgYduGqRvb2rryeis9PwONU+sTWIH9RiR+5+rf2mZfgD+h11wS3sq5ysHIOowjTLORY4XY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/10/4 04:38, SeongJae Park wrote:
> As the subject says.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>

Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>

> ---
>   mm/memcontrol.c | 2 +-
>   mm/zswap.c      | 4 ++--
>   2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 69c970554e85..74b1bc2252b6 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5421,7 +5421,7 @@ bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
>    * @size: size of compressed object
>    *
>    * This forces the charge after obj_cgroup_may_zswap() allowed
> - * compression and storage in zwap for this cgroup to go ahead.
> + * compression and storage in zswap for this cgroup to go ahead.
>    */
>   void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size)
>   {
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 80619c8589a7..f6b1c8832a4f 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -879,7 +879,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
>   	 * acomp instance, then get those requests done simultaneously. but in this
>   	 * case, zswap actually does store and load page by page, there is no
>   	 * existing method to send the second page before the first page is done
> -	 * in one thread doing zwap.
> +	 * in one thread doing zswap.
>   	 * but in different threads running on different cpu, we have different
>   	 * acomp instance, so multiple threads can do (de)compression in parallel.
>   	 */
> @@ -1128,7 +1128,7 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
>   	 *
>   	 * 1. We extract the swp_entry_t to the stack, allowing
>   	 *    zswap_writeback_entry() to pin the swap entry and
> -	 *    then validate the zwap entry against that swap entry's
> +	 *    then validate the zswap entry against that swap entry's
>   	 *    tree using pointer value comparison. Only when that
>   	 *    is successful can the entry be dereferenced.
>   	 *

