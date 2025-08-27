Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1184BCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 18:58:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49AB98E0005; Wed, 27 Aug 2025 14:58:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4727D8E0001; Wed, 27 Aug 2025 14:58:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B0368E0005; Wed, 27 Aug 2025 14:58:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2ABA28E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 14:58:25 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A38ECC07EF
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:58:24 +0000 (UTC)
X-FDA: 83823448128.20.626E198
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id E72A78000E
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:58:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J9dGK90d;
	spf=pass (imf30.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756321103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N62gBUQMd0tc7qQVo3b+XHms24SJjlkFbH+zkE6ad5I=;
	b=0J0EgJ0Kn8vskFXJaoR+7zAM74RnI4eevsdgqOKtUOVl2KsRDgGKe+E9+M1UD6sDzNJ4js
	krgMooT64IAIbjZGq9CEsMvCLQjgmKThNS62O90actYWVEkYxKnEq7ucEAqBkTnsnzT6JT
	99pkZb7MpcfxrVdbnDoc5FX9zTAf87Y=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J9dGK90d;
	spf=pass (imf30.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756321103; a=rsa-sha256;
	cv=none;
	b=TYds8Qsn3bf28PdihXThi67dWDY0xv5lhYZDj87Os4S+3yHb0kxLUpMcmAFHpEZJ3IIgQV
	an7uOErYEXkjhlunPo+ghNtcG95Ku326JZ4C9ZUcbBE2QOLkzqRQKCgt42yQ84MSfPkF/N
	otig19jPX77NI+KS1AcH4PZi04kWbhE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C230844441;
	Wed, 27 Aug 2025 18:58:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821B0C4CEEB;
	Wed, 27 Aug 2025 18:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756321101;
	bh=5Gyv4X1Tqg+4AnDyOQUvhP/AeCmJe0OWG5RaUTEjY1o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J9dGK90d9raYoU61eopREmg/6Q8VwGy1GFyM3/EiASEqRn32FBngL1hxSLw3SslED
	 DYpM5Q4fCrJAuIPdeEsdXgaY2pFoRa8dmt9z9BgoMiVYul7fWta2pYVwzVQAeEfiPX
	 fYrSLbBQ6xpchUjv6ZtNUIYJzuU1ChYSlvofjkOmemD0B+uOiul+cFjXiYFLWTIkIf
	 QwI0cz3L7NPcBooRz9oV7+ko8EOmqvmdukO0xV4MlZbPLNbsS+EX2MHwEchquCeepo
	 MFevgwQQiKMZpJa+iGp2o+rU/xXkjlxrDwP0xFzyvuH8hEG64D1Lzlf4Vpyvu9cOaD
	 CLupkoqSIISOw==
Date: Wed, 27 Aug 2025 08:58:20 -1000
From: Tejun Heo <tj@kernel.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, jack@suse.cz,
	muchun.song@linux.dev
Subject: Re: [PATCH v3] memcg: Don't wait writeback completion when release
 memcg.
Message-ID: <aK9VTIQDA8I2vvNi@slm.duckdns.org>
References: <20250827181356.40971-1-sunjunchao@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827181356.40971-1-sunjunchao@bytedance.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E72A78000E
X-Stat-Signature: i9krp7cbp37ib5ft8yzkxtz1shefkyo4
X-Rspam-User: 
X-HE-Tag: 1756321102-478743
X-HE-Meta: U2FsdGVkX1/0Tz8PJxzA3Bc0uy4QHK5249h6NZBlIlsCsvCjKXPF9ftCgoBYD9FDUuUAdzshpMsUfBabWHyuNJnyoJO52VzTt+8KnGGudUNjn04OnQ2YB8A10F8GgPCRnzIk3NE3FwPII+ehCL8V7QU8pOI9h2iyTx79vqPahmRt3IYQqTxKF8L6RkI7PFGoTfUaLdnGv4+24tTR1sOCFOTGFNEfSkmqNz5h/53u19mGbJutuGmCXhFaM8EQm2Zuj8SNcin4Pm/Y6PSlLlZ5mPpykrpr2yDFicD90OpD2pRjaj4wMcHoO1HgfJo8bygp7b0ctCQO16GY1r/3TTuKo5fRKVs1UuQF5k0hcugRZhNoiO3zA/cybFMREzRihVcjcaCoa3Q3ok5Psx85pwqSWGYwrq0MK+WsIOIodKYcqqW7HO6vLNMZDpzot64latWUekmfHvUAcY+MQWlypaLeckphXmQgFiXqe/rEnysR0OsSj7cr3P2iCMlLbXkV8FxSjh+rSa0jnl6VpuHUg993t2CO/5p7rvZsXQy0Iyr8Q3YYC1mQmjBq9Ajf54vkN127quKypIjfi7ARCpXZEYTZcUpHV2fb6tTDjAJiEeUH33WAYtzqwIGKS2EX4g7X0PHMAFtiyrmnxB1xBEf9umlYAurusY84AvWXJbeIUeOLsOZKXgW2gnsSsOQquj46ODCv80LfMj5y+NTa53mC3xWQdgqb/pRyvjVbSXLKn8qSh68YfzpzPL1r7zVzRQUUzimSlmBm+drCVUh9qbM4fXVH7BHlxxdkHcAvJ9e2aLg6k0XixhffaEyLtQhc2WET3qSAtWiALZwTejF7ZJc90XlLx8WzpQ4MrHlKhirZNcolJd1IMBFekg21v2wMOoSx8TsHeOYEoWfZuh5mypMX6q/ZYBWZwLYbNENGAMcGyYFQ5kxuBFxkDjZSJLXPB0gBL55ymg2crP/XyyRz/30eXzM
 RJmvxmr9
 uyGQfePGG+cSp8ZrKBnxIgByYlOGXMjPzFGkm/7i8nZXK3k0MmdbboXEiDpedkUgeFhYmwrYrqRrA90QDpn8YEi49/KnLMP746II5Gw58Ad+CCBefrzhGF71/zEZEhXLYkVp/AF3IUALaqBrYqe8ECONlB1R58QG8OI9Atqv9EU9Xam6VkOYcoXg0/vBuhbC/PGKooazcTK68UZIii6OZyllDMUjjUVw5NB2fJIHji+d1cCdCZdiAmPsdww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Thu, Aug 28, 2025 at 02:13:56AM +0800, Julian Sun wrote:
> diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
> index 2ad261082bba..6c1ed286da6a 100644
> --- a/include/linux/backing-dev-defs.h
> +++ b/include/linux/backing-dev-defs.h
> @@ -65,6 +65,13 @@ struct wb_completion {
>  	wait_queue_head_t	*waitq;
>  };
>  
> +static inline void wb_completion_init(struct wb_completion *done,
> +									  struct wait_queue_head *waitq)

Indentation.

> +{
> +	atomic_set(&done->cnt, 1);
> +	done->waitq = waitq;
> +}
> +
>  #define __WB_COMPLETION_INIT(_waitq)	\
>  	(struct wb_completion){ .cnt = ATOMIC_INIT(1), .waitq = (_waitq) }
>  
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 785173aa0739..24e881ce4909 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -157,11 +157,17 @@ struct mem_cgroup_thresholds {
>   */
>  #define MEMCG_CGWB_FRN_CNT	4
>  
> +struct cgwb_frn_wait {
> +	struct wb_completion done;
> +	struct wait_queue_entry wq_entry;
> +};
> +
>  struct memcg_cgwb_frn {
>  	u64 bdi_id;			/* bdi->id of the foreign inode */
>  	int memcg_id;			/* memcg->css.id of foreign inode */
>  	u64 at;				/* jiffies_64 at the time of dirtying */
> -	struct wb_completion done;	/* tracks in-flight foreign writebacks */
> +	struct wb_completion *done;	/* tracks in-flight foreign writebacks */
> +	struct cgwb_frn_wait *wait;	/* used to free resources when release memcg */

Is ->done still needed? Can't it just do frn->wait.done?

> +#ifdef CONFIG_CGROUP_WRITEBACK
> +static int memcg_cgwb_waitq_callback_fn(struct wait_queue_entry *wq_entry, unsigned int mode,
> +					int flags, void *key)
> +{
> +	struct cgwb_frn_wait *frn_wait = container_of(wq_entry,
> +						      struct cgwb_frn_wait, wq_entry);
> +
> +	list_del(&wq_entry->entry);
> +	kfree(frn_wait);
> +
> +	return 0;
> +}
> +#endif

Note that the above will be called for all queued waits when any one entry
triggers. It'd need to check whether done is zero before self-deleting and
freeing.

> @@ -3912,8 +3938,18 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
>  	int __maybe_unused i;
>  
>  #ifdef CONFIG_CGROUP_WRITEBACK
> -	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
> -		wb_wait_for_completion(&memcg->cgwb_frn[i].done);
> +	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
> +		struct memcg_cgwb_frn *frn = &memcg->cgwb_frn[i];
> +
> +		if (atomic_dec_and_test(&frn->done->cnt))
> +			kfree(frn->wait);
> +		else
> +			/*
> +			 * Not necessary to wait for wb completion which might cause task hung,
> +			 * only used to free resources. See memcg_cgwb_waitq_callback_fn().
> +			 */
> +			__add_wait_queue_entry_tail(frn->done->waitq, &frn->wait->wq_entry);
> +	}

And then, this can probably be simplified to sth like:

        __add_wait_queue_entry_tail(...);
        if (atomic_dec_and_test(&frn->done->dnt);
                wake_up_all(waitq);

Thanks.

-- 
tejun

