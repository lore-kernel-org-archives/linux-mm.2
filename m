Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00484109C05D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 20:14:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B5F36B0088; Wed, 25 Mar 2026 16:14:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 266CA6B0089; Wed, 25 Mar 2026 16:14:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 155D16B008A; Wed, 25 Mar 2026 16:14:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0102D6B0088
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:14:56 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9ABF4BC32E
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 20:14:56 +0000 (UTC)
X-FDA: 84585688992.10.3AAAA87
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7E7EA140003
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 20:14:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b="ZtDC1s/L";
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of axboe@kernel.dk designates 209.85.160.43 as permitted sender) smtp.mailfrom=axboe@kernel.dk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774469694; a=rsa-sha256;
	cv=none;
	b=Rmh4pZleuN/FieaXvimGaZIY3XB7fTyRLtFuV+OM3iEGYAOkVfTph5amfD8fo9RK81MQD9
	08iRmrZsbSgf42vPnQSJz5GIqU03aellbBhyRAz8zYDl1RHbru48TEOPSXo0EBc4KB8Y0R
	BZpB0XDw7MvjdYArg+KS9UZMQujkUHc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b="ZtDC1s/L";
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of axboe@kernel.dk designates 209.85.160.43 as permitted sender) smtp.mailfrom=axboe@kernel.dk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774469694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6PlzBqe1IIMZnSLJe3Nt9W0mLjdauDVoWC1E+bHzQXs=;
	b=43Zo8p/YuOlfQzIfGGTYDh/DQTyk/9ATdsHvnWVKnq0pFnGJ6xPrxdye5/AbCQcDS2rtGe
	NhCUOppiCBnW7Zt8YBPd5Q9o8RZq1L46yRNKflytTXWuXcYjx63cP1HSKj05E+FePP2tLY
	6cIn9U+Qb+/JTEXUR58AMI2kmrOHxug=
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-41c420d1460so130772fac.3
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 13:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1774469693; x=1775074493; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6PlzBqe1IIMZnSLJe3Nt9W0mLjdauDVoWC1E+bHzQXs=;
        b=ZtDC1s/LC9N6IkUcMgyq4IvwlXfyCnhAZX9CbXCHf3+fcBaJqCH/v7KqBj2Msj9R6x
         FLBdn4+4L5PQimqnlEvpeX75zvSI0ULp7QI2/9PuUsar3EXBaI14iDRL9rmpF0pafofy
         LpuKkbqQNecrsBPMDqqA6MLwAHbq2GcBUToo0ZZRAd6ZKoUR/lmTcCD5RKKasDMKD9oi
         6N63vm3i2UI24lS0yFYaIsy1DyIR+OvCpX+s/UlNF81ztIVN6J06HDm+cyxYwcJadVJt
         SFPaiL4uHdPJDqHXyKH5Hi3cWSg/rcROkQWXgQxhKEOKEBPIpvwy/8cKl7E3PXdQgvjS
         DQLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774469693; x=1775074493;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6PlzBqe1IIMZnSLJe3Nt9W0mLjdauDVoWC1E+bHzQXs=;
        b=EPnHmZhNW2y0jQ+0799SB22oK5ilH8PWvI7GQbygKMwPqtlsRJLzVi0qadCmEFYElU
         /D6BgeCx0qAFBACDUhEo0UggNMUDA2yjGSZQFZ9gGNAFEiUPcFsV6F4shz2KPGmXIMHp
         bJtgjnWY696gzI6DUcevpxINE+IzEEQfCVsyAGSrlAgFGG9lk0zHmrUWs8anr8GmbiND
         IBNwh7EZSWA/5alEebYo4ihHuhJwiEDxIKZwMN+NjsjRLAUxjbliQGjODCNud2StHV7M
         zrpOKr/l+i0qd+tdWDiy5dKsT1x3YAn2hVGDnC2AXuak90u10e0+W//cWIcsVxGIzWnl
         u4WA==
X-Forwarded-Encrypted: i=1; AJvYcCV5GymFN6C0Rg0uSQOUjSTvb2zMd+ZtyALGJ2eRPNtViT9/MB137UTlYQaTJcpucYLGvXIfumV9uw==@kvack.org
X-Gm-Message-State: AOJu0YyUTNHGjVB4MmSpifYYp4MITx+0bDelBxfJhmu9bjNkvTAp0m5Z
	IwtzdRprF036cIZZhi0l/VSfRXCYF5ZpiQpoG5TeU/uizjr3aIC4yj8re6OCA1GUc9w=
X-Gm-Gg: ATEYQzzFoEpsmS/U3eoUXxoqJdNmxzKBY0Z71bJ1te4jsNs/jm08tRXQgEnrXX8powq
	pI0EjDy/KzskTUm0BQypR487vVdhfWfVCLQKHwDGwAHUkEYCEn+5ur9j5eafpyrNHv1uxVlmOGf
	3CsVgwgiVTDnr7StOJBHlFxfhRhSK+/xd3yBoaS+Wip8d/zmkTrLsVxMY7/CAivrLuQgJKlvS0O
	NViDL8VP3il8dv0R6c8rHDCsrdP9eJ/DlHbmybxlZunb846OLD6uSo4Ypgq2/qn+zDT6kUQ2ZiI
	GsmO0QZqj/J7HIO85Mf+C8OQPBokJ7ESXcTsH2jLJmk7YcjHWCg5u8HaWugDLxibEKZg2mp1xiO
	TWrRRPiCScdKexBnVl8sRx0RrRUDmcTrdVvVlO/WAJAsp/uogWdJgR8xVZ1+1uw13NFFB5okcX0
	ji9UsqDIjw0h9sVLaMS9GocGFJVJbjz99adCS4hclo18dj0htHdfVNi2glUF/Xm7G11soqsxnFO
	APqRz5T
X-Received: by 2002:a4a:edcd:0:b0:67b:be84:e085 with SMTP id 006d021491bc7-67dff50ad22mr2303872eaf.27.1774469693263;
        Wed, 25 Mar 2026 13:14:53 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67e0ab1b9e3sm535628eaf.12.2026.03.25.13.14.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2026 13:14:52 -0700 (PDT)
Message-ID: <c4453f4e-c1a2-4f5a-b278-76b63d5dc4a3@kernel.dk>
Date: Wed, 25 Mar 2026 14:14:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 1/3] block: add BIO_COMPLETE_IN_TASK for
 task-context completion
To: Tal Zussman <tz2294@columbia.edu>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Christian Brauner <brauner@kernel.org>, "Darrick J. Wong"
 <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
 <20260325-blk-dontcache-v4-1-c4b56db43f64@columbia.edu>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260325-blk-dontcache-v4-1-c4b56db43f64@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7E7EA140003
X-Stat-Signature: 8a87wu1g5rdef77nnp3jipqawko3jzyn
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774469694-575587
X-HE-Meta: U2FsdGVkX1/56ymqjYutoZb0cQ4ECfkpOZn/n319JBhwfS/RSi6UfRkM4isRadJLcD7bVn+JoajnTeF5ldtFtGwbBjsyA+xkXsd8jMnfZs3PZd1oH0bN0QoVDCwAPrmxBDJrGfsdBu6qtJuZuyDD2FjrZfMXMZ8xRlh602Ip0cuKxPq0hkP1Np3Is/lSDls48tTdYh9Ek4GIce7Nz/BGBbQfRoGp3PhXxysqfY3uYyX+Rh+CNh0cVn6xn3QLUWHtdOQtVAxttGgj8V1+00OOLH4nk/MuRzJKp3l07s33wqiPZ0tTPZzAJklJITUB0XQi+FhjI1ABvINwoiXnLpNZfi4jQF19ycjna+9nT7xBxQ12y75L6eqPv77QD1uXFDfDAxMg9FiVqgAKCF9oKfuMvEPtMpSnwaVvR5BK0JVLE0AC5oeFpVxW+u4FtOWzmFpQDtZhe/TnJs3ns1yiDG6EJlcqbRSEKjcuc34HRAtR/v0N5KRCFKUk6L2gZ7InO2rPvs1X7lfX87hv2dLK0FBuyb5I5wSOAhKcuUo/c8PCId6A8xToOIPq+kLXXOVOcyU5DBnxNSbkDnWjyGSo31BRE9zt05N4tnZUj3K49eu0FC4rlwTWnm/nU815+gKl1dONWPXL3EMMKSvYMkpluYiEKbFPGw9+2yZpa+NA8z4HwcUrIEw66D1ylaRsGrriCCC8x5e1eUu33dgeohm5XO3Jj1ikYV/nz1ny1PcG4p6WdbEI8TRjYxmmxa3sUZQraLyIeEAD+SIDeD/3VH//Hl9cbEH5miF+GWd4hJVvHXe+jWbUSDZqdnTWwtJPRDH6ilOQw+bD2TBkC2k1d9S87w6FcdxiQ8/7zKzT+ETq0yEJkGGGu+eLv/e/Ay86Y0fASim0/fv4oTLX/o3lVY42COZKWg8PhAPKME3ykvQpq+wrKwmKegPR3nWylmr14dOLHFSUdjtntk5TX8vgH4XFTOQ
 rrzqViC7
 jzAXD1LTZ/2A+X1XxDylG525YBQQ4pHrVoJHUt+rmzhYbiOu0cjrnEykKTSLRQ/Kkcd1q0vhfsoTHpoc0oqRs1FOdUFbLZ0pHV5Ny2pkDKnieOV6XmMLx0lgwV1Gp3H1VEP+A/t4Ysnp0gvLmULMDiNIwtX4QZTDjxV7bxOFBzMzTNsdmJ8qfoCwpVXBsOBd+6LpZxwNoCrRcky/HfXmH1ErzG+HlbA6jBWozX1mnjsUaZh4/20ojIz9Hzk96wXEQUfJgJjsg1vGNw1xt063PRwFirHRl3u98fJ0AcYG1Zgi0QtPdEYcDL/YV1AlJeJ2uzuXyBj8TNwxr20fEbZ1p8efXxIxNSQ5SekGV6n9TFmlW/6Bk09GKwErPexzFpNza+l8KZLCTXBdcjuPYYRdiHvBdNRymGkRnPJrbfiyeFmMT1xHZ/KYPf8iAQrV4Rqq1gIXyRSSXl4BKWgGbCG22eb/MKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/25/26 12:43 PM, Tal Zussman wrote:
> diff --git a/block/bio.c b/block/bio.c
> index 8203bb7455a9..69ee0d93041f 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -18,6 +18,7 @@
>  #include <linux/highmem.h>
>  #include <linux/blk-crypto.h>
>  #include <linux/xarray.h>
> +#include <linux/local_lock.h>
>  
>  #include <trace/events/block.h>
>  #include "blk.h"
> @@ -1714,6 +1715,60 @@ void bio_check_pages_dirty(struct bio *bio)
>  }
>  EXPORT_SYMBOL_GPL(bio_check_pages_dirty);
>  
> +struct bio_complete_batch {
> +	local_lock_t lock;
> +	struct bio_list list;
> +	struct work_struct work;
> +};
> +
> +static DEFINE_PER_CPU(struct bio_complete_batch, bio_complete_batch) = {
> +	.lock = INIT_LOCAL_LOCK(lock),
> +};
> +
> +static void bio_complete_work_fn(struct work_struct *w)
> +{
> +	struct bio_complete_batch *batch;
> +	struct bio_list list;
> +
> +again:
> +	local_lock_irq(&bio_complete_batch.lock);
> +	batch = this_cpu_ptr(&bio_complete_batch);
> +	list = batch->list;
> +	bio_list_init(&batch->list);
> +	local_unlock_irq(&bio_complete_batch.lock);
> +
> +	while (!bio_list_empty(&list)) {
> +		struct bio *bio = bio_list_pop(&list);
> +		bio->bi_end_io(bio);
> +	}
> +
> +	local_lock_irq(&bio_complete_batch.lock);
> +	batch = this_cpu_ptr(&bio_complete_batch);
> +	if (!bio_list_empty(&batch->list)) {
> +		local_unlock_irq(&bio_complete_batch.lock);
> +
> +		if (!need_resched())
> +			goto again;
> +
> +		schedule_work_on(smp_processor_id(), &batch->work);
> +		return;
> +	}
> +	local_unlock_irq(&bio_complete_batch.lock);
> +}

bool looped = false;

do {
	if (looped && need_resched()) {
    		schedule_work_on(smp_processor_id(), &batch->work);
		break;
	}

	local_lock_irq(&bio_complete_batch.lock);
	batch = this_cpu_ptr(&bio_complete_batch);
	list = batch->list;
	bio_list_init(&batch->list);
	local_unlock_irq(&bio_complete_batch.lock);

	if (bio_list_empty(&list))
		break;

	do {
		struct bio *bio = bio_list_pop(&list);
		bio->bi_end_io(bio);
	} while (!bio_list_empty(&list));
	looped = true;
} while (1);

would be a lot easier to read, and avoid needing the list manipulation
included twice.

> +static void bio_queue_completion(struct bio *bio)
> +{
> +	struct bio_complete_batch *batch;
> +	unsigned long flags;
> +
> +	local_lock_irqsave(&bio_complete_batch.lock, flags);
> +	batch = this_cpu_ptr(&bio_complete_batch);
> +	bio_list_add(&batch->list, bio);
> +	local_unlock_irqrestore(&bio_complete_batch.lock, flags);
> +
> +	schedule_work_on(smp_processor_id(), &batch->work);
> +}

Maybe do something ala:

static void bio_queue_completion(struct bio *bio)
{
	struct bio_complete_batch *batch;
	unsigned long flags;
	bool was_empty;

	local_lock_irqsave(&bio_complete_batch.lock, flags);
	batch = this_cpu_ptr(&bio_complete_batch);
	was_empty = bio_list_empty(&batch->list);
	bio_list_add(&batch->list, bio);
	local_unlock_irqrestore(&bio_complete_batch.lock, flags);

	if (was_empty)
		schedule_work_on(smp_processor_id(), &batch->work);
}

Outside of these mostly nits, I like this approach. It avoids my main
worry with this, which was contention on the list locks. And on the
io_uring side, we'll never hit the !in_task() path anyway, as the
completions are run from the task always. The bio flag makes sense for
this.

-- 
Jens Axboe

