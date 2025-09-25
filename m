Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5DCECAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 07:37:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 135D08E000D; Thu, 25 Sep 2025 03:37:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E6578E0001; Thu, 25 Sep 2025 03:37:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F176C8E000D; Thu, 25 Sep 2025 03:37:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DBEB28E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 03:37:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 88EA513A869
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 07:37:13 +0000 (UTC)
X-FDA: 83926966746.17.3B8F14E
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6686240003
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 07:37:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=QoJvREll;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758785831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6s5Wvy5/hwzZbO8lAOgPXYaIDsYJglypd8Ird6UT11Y=;
	b=gCq9rHvEiLmSy0E5EBtxPJdt0gVg2fs05YvdTK8bhQh8TOCnanvlXQ7RUr4wg1Ev83a2S0
	ZT2hbNU9Zdv+ZWrOiHBQJwtnFQLGkcjj8b/ov7KQq0YzAwittXJp5P9L3DKeMKpnL5aBG1
	KTjVXMtUl5nUBSUlRAZSh3CmD1Jq8wY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=QoJvREll;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758785831; a=rsa-sha256;
	cv=none;
	b=7h7yGDBtlPcONRcLSevtDW+oQ1qtNPFTPp1yiY/P8F69e4ZL6uUydDMs9HVtVGaK6q8ZVB
	zicsJ3s06k90OlLOqo3ywxI20De2Es3za/S7NKVuX8wfJpesnkkrhfR1WQfppO8EGODH2m
	Zuh4NMtbG5bY9o73QUSdCRSkY2U/JNY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1758785828; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=6s5Wvy5/hwzZbO8lAOgPXYaIDsYJglypd8Ird6UT11Y=;
	b=QoJvREllxmbSTLgeCZmVwwiO6sraNgOeAVouuTnQB92Utr/qS1jUJaLsAMXSBgeIGZQXflYM+26O09BtApOWdFoPtg5zWPX0JWHqPWV4EIpv3k3ZLoFyghDAHUHEWoWK8f7liCCeYYXmzvX5XSJihU7YUhAd/FrHn73w3dcBcDA=
Received: from 30.74.144.116(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WomudZB_1758785827 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 25 Sep 2025 15:37:07 +0800
Message-ID: <aa4cc8bc-9d08-42bf-9350-45a8c1950d17@linux.alibaba.com>
Date: Thu, 25 Sep 2025 15:37:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm: vmscan: simplify the logic for activating dirty
 file folios
To: akpm@linux-foundation.org, hannes@cmpxchg.org
Cc: david@redhat.com, mhocko@kernel.org, zhengqi.arch@bytedance.com,
 shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com, hughd@google.com,
 willy@infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1758785194.git.baolin.wang@linux.alibaba.com>
 <166c482b066b7da2aeaf780f0ef5ab4ae150d440.1758785194.git.baolin.wang@linux.alibaba.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <166c482b066b7da2aeaf780f0ef5ab4ae150d440.1758785194.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6686240003
X-Stat-Signature: i8d1swuumokx9ykdfh8gzjgi9q6zyba4
X-HE-Tag: 1758785830-516160
X-HE-Meta: U2FsdGVkX1+vW4JtPuXvBjWUDPPd4/Gmfb4YT2xvO7I2S6MA44+yhnSsoHs1Cv/Bt592WAz/H1I4FqAgb7/Rtz2s+eoCAqa9TzXvkYfZV8FBWcmmUbjVmfUi3Wefy3bclojawTZkx+l4wdo69Y5S8I5R+tRlpGovTZCzNVNqJ7U4dHeo9MzIKKLq3HS2+kKKMqURlM4p1G9d5lGGGCDdVCK867q14coTTG8wCGaxHwOPuiRl/ZJS1vJvEcMnj6UkhioJoEWIiEPik1jXsS7N1eLv5J269jQ0QF/Ot7cecfyApMOs8qil8iRzThOvTSX+4AFNfvTYqCSPt6j6uD0V9u/b+VBtjHUci7QSNEOW9Kc9OMnmnPObvDRLSv1AjwJrMEjMhmOSL3Ws+GihamULuC2yTuV823Bz2WNs/o/QxfSP8PV888HQ92SezWM2ZrsB1FUhth7SqkrDpEfUTijXZECImqLWYJqYdlMZubZhyz2PCMYL6Dkv3YphKH5FHyLlPa69aOr1kWGMZlpotsGXk8M9fasYRNKkWJUbR0sVNFwf2rA/c5+ITyNnJl37UQq1uzwmABNCiEQdi44b6exYPUesbiNOTtST0BUfk6QKv5T+x99TTnD7D2AZFhqizANBXJ9cYS/LWH4XaHOY+H2F98PnCCuLHSH5Vf92gaFgNpGERFaqmz8358f9N4+jq6iTgvAAsX5Fff/LJWYwf4otfpb0l06CN7XNnC2n9Ee13inysI+/zdB5U+Jge35IMVqXMIfDFLQj1NldVYFbywCXB2aBI4QwI6juQBm/wrQBvZQ/0ACjKwA/0VHqEQ6wXLjBG0DmToa4uC0bHMB5XjcM3g6Lid/5joO4xMzgeny5ZJ9jlrit6/1ZaK/V3GCLH0W4ZI2Mq2CCIxEM3USfg1FLo2pjL2JiRnM3VMbDjdqC9GjjyCyQ8s3aQGrunFNoz5lPlF93G4Gj6klzRkB72iM
 VD/92dBN
 hzH1gJF+b/DnuKC0LQRgOoH+Yf08b7mB3ChcD6Tj3MAPL3SY4jPhsPca/l1ybDsVI4gyGElJ6v8w6jSUO7d9Z3xBtqUo1Kgl4jNQ+WginvJfp5xPL1Sw4Xprjk0Zwo2ZByDq/UFYmM/FbWyq/xereZgWyagGsTn0q+9sc7Hi0vVG+H1FkCf6vaDALm5IKysKbQBG19Tm7u+SmnCnfL5i8mpolyNMx9y3KXoO4HVKHkNd4AnlkCvRw9Vnjm2nMvBjD+nVQKmuO/PWC93AaQtY+9fQjUQfPg+HwvSTBVQVm/FSy41I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/25 15:32, Baolin Wang wrote:
> After commit 6b0dfabb3555 ("fs: Remove aops->writepage"), we no longer
> attempt to write back filesystem folios through reclaim.
> 
> However, in the shrink_folio_list() function, there still remains some
> logic related to writeback control of dirty file folios. The original
> logic was that, for direct reclaim, or when folio_test_reclaim() is false,
> or the PGDAT_DIRTY flag is not set, the dirty file folios would be directly
> activated to avoid being scanned again; otherwise, it will try to writeback
> the dirty file folios. However, since we can no longer perform writeback on
> dirty folios, the dirty file folios will still be activated.
> 
> Additionally, under the original logic, if we continue to try writeback dirty
> file folios, we will also check the references flag, sc->may_writepage, and
> may_enter_fs(), which may result in dirty file folios being left in the inactive
> list. This is unreasonable. Even if these dirty folios are scanned again, we
> still cannot clean them.
> 
> Therefore, the checks on these dirty file folios appear to be redundant and can
> be removed. Dirty file folios should be directly moved to the active list to
> avoid being scanned again. Since we set the PG_reclaim flag for the dirty folios,
> once the writeback is completed, they will be moved back to the tail of the
> inactive list to be retried for quick reclaim.
> 
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>   include/linux/mmzone.h |  4 ----
>   mm/vmscan.c            | 25 +++----------------------
>   2 files changed, 3 insertions(+), 26 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 7fb7331c5725..4398e027f450 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -1060,10 +1060,6 @@ struct zone {
>   } ____cacheline_internodealigned_in_smp;
>   
>   enum pgdat_flags {
> -	PGDAT_DIRTY,			/* reclaim scanning has recently found
> -					 * many dirty file pages at the tail
> -					 * of the LRU.
> -					 */
>   	PGDAT_WRITEBACK,		/* reclaim scanning has recently found
>   					 * many pages under writeback
>   					 */
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index f347865edc70..b1f8eea67c8e 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1387,21 +1387,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>   
>   		mapping = folio_mapping(folio);
>   		if (folio_test_dirty(folio)) {
> -			/*
> -			 * Only kswapd can writeback filesystem folios
> -			 * to avoid risk of stack overflow. But avoid
> -			 * injecting inefficient single-folio I/O into
> -			 * flusher writeback as much as possible: only
> -			 * write folios when we've encountered many
> -			 * dirty folios, and when we've already scanned
> -			 * the rest of the LRU for clean folios and see
> -			 * the same dirty folios again (with the reclaim
> -			 * flag set).
> -			 */
> -			if (folio_is_file_lru(folio) &&
> -			    (!current_is_kswapd() ||
> -			     !folio_test_reclaim(folio) ||
> -			     !test_bit(PGDAT_DIRTY, &pgdat->flags))) {
> +			if (folio_is_file_lru(folio)) {
>   				/*
>   				 * Immediately reclaim when written back.
>   				 * Similar in principle to folio_deactivate()
> @@ -1410,7 +1396,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>   				 */
>   				node_stat_mod_folio(folio, NR_VMSCAN_IMMEDIATE,
>   						nr_pages);
> -				folio_set_reclaim(folio);
> +				if (folio_test_reclaim(folio))
> +					folio_set_reclaim(folio);

Sorry, I missed fixing this when creating the patchset. This should be here:

if (!folio_test_reclaim(folio))
	folio_set_reclaim(folio);

>   				goto activate_locked;
>   			}
> @@ -6105,11 +6092,6 @@ static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
>   		if (sc->nr.writeback && sc->nr.writeback == sc->nr.taken)
>   			set_bit(PGDAT_WRITEBACK, &pgdat->flags);
>   
> -		/* Allow kswapd to start writing pages during reclaim.*/
> -		if (sc->nr.unqueued_dirty &&
> -			sc->nr.unqueued_dirty == sc->nr.file_taken)
> -			set_bit(PGDAT_DIRTY, &pgdat->flags);
> -
>   		/*
>   		 * If kswapd scans pages marked for immediate
>   		 * reclaim and under writeback (nr_immediate), it
> @@ -6850,7 +6832,6 @@ static void clear_pgdat_congested(pg_data_t *pgdat)
>   
>   	clear_bit(LRUVEC_NODE_CONGESTED, &lruvec->flags);
>   	clear_bit(LRUVEC_CGROUP_CONGESTED, &lruvec->flags);
> -	clear_bit(PGDAT_DIRTY, &pgdat->flags);
>   	clear_bit(PGDAT_WRITEBACK, &pgdat->flags);
>   }
>   


