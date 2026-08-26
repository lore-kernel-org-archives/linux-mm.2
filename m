Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 460DEC61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:34:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48C1B6B0088; Wed, 26 Aug 2026 05:34:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 462436B008A; Wed, 26 Aug 2026 05:34:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39FE06B0092; Wed, 26 Aug 2026 05:34:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1B65C6B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:34:26 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 675861602EF
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:34:25 +0000 (UTC)
X-FDA: 85142910090.12.4DD555B
Received: from mta0.migadu.com (out-24.mta0.migadu.com [91.218.175.24])
	by imf06.hostedemail.com (Postfix) with ESMTP id 48FB6180006
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:34:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gHtASECo;
	spf=pass (imf06.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.24 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787736863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ISySEFiNFsBIOPquMQ5ZFa0eR2cJq4SvpWF38Q2Q9XU=;
	b=Kq7lDYj6F1Sj9X7WUNSBDAfdJrnFCbK77r4OPPUCKOLWcf5KHwFwkEJss9K/ozqFgbReG/
	GbSduy/3EU797CdHn94xtWT0k5uKprJRu6v2/CDnnrXJxnJEZj64qbuTImd52LVrOcQ9FI
	WUXJwNjlG3S8LZ/bGPVp8wkcs2ov79Y=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gHtASECo;
	spf=pass (imf06.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.24 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787736863;
	b=7xC7vfKi1Ae8dAl/6/CZMvKmRxjjI2zTKm4L4roZned8zLQOVC1Yig1BoFrIfH0N4twxhQ
	stwucBKEZPTZoiNfH/mQFrWoawnuY9sM+KniN/z1eVEp7XMy6qQBTcsBWDLByeOx/cdnht
	UNpnzlATc3VknoqvAQjZTEwEk8pkPig=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=RH8kD9SovqtyuZbKMI9LVB6g/2XlQNy9bg+wJMXI7ns=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787736861; v=1; x=1788341661;
 b=gHtASECoxhslOdWkd5LwGLymZWQM+iSIiw2KEKccOnT5z9qDGH7oHAydBGdQ2BDVMCRxf+kb
 TN7t0oetII+eqjn7TToyEASC+IcsnGiNlrHTv//2AdpJvuBg+qkjZI5407tUUmG1WH8BmHt9hD2
 G5g3vHREW1z6YUeAUmx5jB98=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (223.70.160.239)
	by mta11.migadu.com with ESMTPS id 0c766ee9554d6e2c;
	Wed, 26 Aug 2026 09:34:21 +0000
X-Mizu-Trace-ID: 0c766ee9554d6e2c
X-Migadu-Flow: FLOW_OUT
Date: Wed, 26 Aug 2026 17:34:13 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com, chenridong@xiaomi.com,
	david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com,
	lianux.mm@gmail.com, linux-kernel@vger.kernel.org, ljs@kernel.org,
	lyugaofei@xiaomi.com, mhocko@kernel.org, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, stevensd@chromium.org,
	wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com,
	zhangbo56@xiaomi.com
Subject: Re: [PATCH 6/6] mm/mglru: batch move folios to the second-oldest
 gen's LRU
Message-ID: <ao6zFSzx6mOl874A@fedora>
References: <20260821102538.22642-1-baohua@kernel.org>
 <20260821102538.22642-7-baohua@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821102538.22642-7-baohua@kernel.org>
X-Stat-Signature: mtpa8oaww3ia3eystxb6ga8gjjh1u45c
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 48FB6180006
X-Rspam-User: 
X-HE-Tag: 1787736863-817036
X-HE-Meta: U2FsdGVkX1945hrkhixkZNm8DGZitEvL+Ze3Jq2aHKOg/fGggyRDLpxF8zIGc5IceAm68qlBRaZaYE9VNCDZ3eCa4zLPc1ggH9dlI4KwR9rNYVLpEN/8dkw8YHE54ZgYpnI/OlLQc89GUe8ZDpqQ9YawnIlAl4cvB5gWrH/kh1YCpUsssxonJF7Dt9nu976Z5uai8q/eW3UuFXmvYsCigPQmEF/A51eSpMpyIHs+t80k378LM3OCyRrNYaGsUXexYucLKyInlGMLhDI2eRtMrcJU52qfLSkksb41xoo/+m5AAxLts9zhs/ZBqZaCGrfqACVH7JQQ9CafO/AWOZjjov2WWtbyz1SjbWG8TAyS82pAq56QBt918GgN2UitlprbwiEnBHGtmfKRsFLeYOwyW9xtTfTDs+1hWJtE5D6C9feiMGGhfuAUO3LYiV7TgdyKEpWB/QdCHWQ8rmslzywVeiGalsmjVOrVDcO78ralcAUz+RyfRMlYuLPoggQKZrCdy8NpUONlX4KxwvzIN3qMqHzPzaQwiiIZg92Xb6BfUvR2VsVO52f2ZS2eBCoJqi3udqhCgf7+zua7ofY7A6KW5prYGxdWP18OA+VweQzA3LS3C7kkNKggs3rSH1PONT4EmGNIKfYCJQnj1lj6IDean4N+c9hHDu1sR2Mi0LU2aQZXpYml9hfzfgppqNV4j85IyKuNwzttJP/vDhHJWInCkq2iEPBXlAf/q8FqBhpAT9yHkBsMbkFrmazbz0lmsjwgM4QuqyZguQx+M0bay3QtmelK/+tKxaDTrLK+nKJUA3OMrbdI0iKAKOQvGAFkWxlrcR6utomhnmvoSdEPvszD+2X4OQD6I0IiY4s5d21y7PJnROR2vvOO8HclTngtYk+CyxdAKZfK61c41movMMjZIPFyG8cBNlSrzXTgGs80xozkGvsam8w58U3Kzg/7Mu/gaNxVQFAWNj2cLG7dxn3
 UNgTi1gC
 OmPOD38K9TpV6Oaya6sI2gLdlC0JkUF3ifMemU1RmnCXlaLFPd5ztqnXebV1doykRjVFXysbQc5bsZdBKsV06vkT1RMPEYwYD7L6Ez5SxHClNOUwY6QwFFxvjmb9+CJOzxVbXDmtq05gP01nqCADL7bm9J7nhTSzopRtJ56xCjrW61wpflYhMPdT2KEy4Gkw2P1jCoHHzAV69L3aqAZvYM9gZOW5P4mrkl4m/loo8UAfYRtRkNwxQhxnrCiNiPL21eq/bgXKOHE1G6ywNAEIdd1MM5W8XYf6IiShNk+Of+LYslxc+mH/M7jK9eVS97YYk+eiw468AoN61OmKUeKG9Mzx0yXRoV8Kqub948mR46ANje4/+ovyBLpa2R29geEUo+vhx4/DnEMb3rO+24DgOB0CdL1+eIrQwkyM5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/21/26 at 06:25pm, Barry Song (Xiaomi) wrote:
> Detect folios that need to move from the oldest generation to
> the second-oldest generation, and batch-move them together.
> This can significantly reduce the sys time of inc_min_seq(),
> especially when the other type is significantly behind the
> preferred type.
> 
> Assisted-by: gemini:gemini-3.6-flash
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/vmscan.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 2fd82b2ca4d1..996b48344ed0 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3923,6 +3923,19 @@ static void clear_mm_walk(void)
>  		kfree(walk);
>  }
>  
> +static inline void flush_lru_batch(struct list_head *head, struct list_head **batch_end,
> +				   struct list_head *dst)
> +{
> +	LIST_HEAD(movable);
> +
> +	if (!*batch_end)
> +		return;
> +
> +	list_cut_position(&movable, head, *batch_end);
> +	list_splice_tail_init(&movable, dst);
> +	*batch_end = NULL;
> +}
> +
>  static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
>  {
>  	int zone;
> @@ -3942,9 +3955,11 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
>  
>  	/* prevent cold/hot inversion if the type is evictable */
>  	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
> +		struct list_head *target_list = &lrugen->folios[target_gen][type][zone];
>  		struct list_head *head = &lrugen->folios[old_gen][type][zone];
>  		unsigned long protected[MAX_NR_TIERS] = {}, delta = 0;
>  		struct list_head *pos = head->next;
> +		struct list_head *batch_end = NULL;
>  
>  		while (pos != head) {
>  			struct folio *folio = list_entry(pos, struct folio, lru);
> @@ -3963,7 +3978,8 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
>  			new_gen = __folio_inc_gen(folio, old_gen, &gen_increased);
>  			if (gen_increased) {
>  				delta += nr_pages;
> -				list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
> +				batch_end = &folio->lru;
> +
>  				/* don't count the workingset being lazily promoted */
>  				if (refs + workingset != BIT(LRU_REFS_WIDTH) + 1) {
>  					int tier = lru_tier_from_refs(refs, workingset);
> @@ -3971,11 +3987,14 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
>  					protected[tier] += nr_pages;
>  				}
>  			} else {
> +				flush_lru_batch(head, &batch_end, target_list);

How about this? then you only have "struct list_head *batch_end" in 2nd
parameter. And explicit resetting batch_end makes code more readable?

				flush_lru_batch(head, batch_end, target_list);
				batch_end = NULL;

Anyway, personal preference, not strong opinion.

Other than the nit,

Reviewed-by: Baoquan He <baoquan.he@linux.dev> 

>  				list_move(&folio->lru, &lrugen->folios[new_gen][type][zone]);
>  			}
>  			if (!--remaining)
>  				break;
>  		}
> +		flush_lru_batch(head, &batch_end, target_list);
> +
>  		WRITE_ONCE(lrugen->nr_pages[old_gen][type][zone],
>  			   lrugen->nr_pages[old_gen][type][zone] - delta);
>  		WRITE_ONCE(lrugen->nr_pages[target_gen][type][zone],
> -- 
> 2.34.1
> 

