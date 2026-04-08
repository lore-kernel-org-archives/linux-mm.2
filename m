Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A53110F9972
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 19:51:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5EF06B0005; Wed,  8 Apr 2026 15:51:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C10196B0088; Wed,  8 Apr 2026 15:51:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B262B6B0089; Wed,  8 Apr 2026 15:51:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A3BF96B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 15:51:53 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4683DC0F47
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 19:51:53 +0000 (UTC)
X-FDA: 84636434106.22.C3AD3FB
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	by imf18.hostedemail.com (Postfix) with ESMTP id EF87C1C0013
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 19:51:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=SuVDfpk1;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of axboe@kernel.dk designates 209.85.210.50 as permitted sender) smtp.mailfrom=axboe@kernel.dk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775677911; a=rsa-sha256;
	cv=none;
	b=VrH4yGPjmz9WfP4oR2aVJsDs3Ce/toKuYrHr6GTyntW45wpJ2dqsphg3MS8PtWt2mr641M
	5maVIe3oxcj+coCqXkQZjc+xBvxqiJCdPEdNbjxMsUfhCsRLxITr/geDkw9xs9TyexGxyb
	qhj7idjYDqFW2QwAmO/XR0AQYwF7+XA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=SuVDfpk1;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of axboe@kernel.dk designates 209.85.210.50 as permitted sender) smtp.mailfrom=axboe@kernel.dk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775677911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UXmjLbQMnBqeQgGLuSxxqcM7IYKVin1hxCkiOdMcuyM=;
	b=7v04y6EzCFRGXAhVbJpzWPcBQqRMrB3MzVFWbfwhfWzkLxo5XcMp8yG4+QSc1TxKEdcMOq
	RG4KW5//f0GuAF9DDsZmZ8ie3cfI0NjnPrSmCrnBZuyPo9xDIJNUwCiScTObHGwRSm9Ofu
	YfedCz/A/k+8Ze7TKQIxXnHSZL0VY5o=
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7d9b21d1461so124976a34.1
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 12:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1775677910; x=1776282710; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UXmjLbQMnBqeQgGLuSxxqcM7IYKVin1hxCkiOdMcuyM=;
        b=SuVDfpk1qLTsugLFNnXlertpw30wd58/R40T+egbOPGpvjQP0lUK0tyaLbgqB7wbYO
         JQvCQZYwP3w/9K5yEjElp8ItZj7LprdVgKlxv8/D0Kalo63lFR+94MQeeOFmc7H19FIN
         3FAJyClHYirOt8V9pUec6VbmgToeaQlpt7LBg0L0j3lwet/+bqWJyI6SEwCjS6y9MqCF
         cAMXd6+wq2r+4aRm9j1jSZUmVHSNkhXTPZ5g/cu3dsEa6Bn3FPmeLnqfwHZB/tfK0lId
         /fpGCtLRXXlahuV0rP5mG/qFGrJDnEJ+3H8HlGIdj2uvpkaGIFzZEJ1odHs8AfNisMl/
         LgCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775677910; x=1776282710;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UXmjLbQMnBqeQgGLuSxxqcM7IYKVin1hxCkiOdMcuyM=;
        b=sWKH6mK+HfxEqXp8RGfFlK+bcZLOKjrH5nxfNxSCNncAlAvRWs2ePucyBwfjPsf3Io
         IE8/sKMq/gMdEeepuQZyMde0HSQwYXYVUP2EWJRxXzhhHW2r692GbP2bXmxK1Su6Jbw0
         kfzmSiZPiSTW5CkiSvv9osmptxHofh7F/BM/rklI8IuguxSLQW9udEnqrbRZu64P7w2u
         bfYGcCBBu8y4Oic2pzCha987p2r44mBJaxXjSF4faT2c7UVlhirKjokC2WhaDwKVJjQn
         RXhDzexYlt43O5gQpCcDx7GzaGdKCSUg4MM6B6w/u+5rv8UAoTNTwXwnYUpMIrD4/ZFB
         4fwQ==
X-Forwarded-Encrypted: i=1; AJvYcCU92Ap24gpZsJTGR56al6Z3V6BTHZMi1eL1FaRT+M+7rya7gboei39jZO3eQh92sz2bbhe7DE+4mQ==@kvack.org
X-Gm-Message-State: AOJu0YzW2S0W1zN9kZ70NXED5XD7dqhe0tlbenQXpNkpbsP+284Daolb
	08wbsVrZBct9cC6L85uqaTZyX7m0Z//1IpYt8kJTk5RhBLA8ogfRD7e5WXCThXkpF3M=
X-Gm-Gg: AeBDietxN2hsr7Itva6l1WgTqYhpY0kmP5/Zvx7ktssW47CI+xglS77itIWwYiLsYXk
	zMz2KNwsA2EISXwqF9YYz8r3lLvhYO8rcwQRgzJxLVNfZ1O/0c8yboWnoM5/AmTe9q1SGEJIkkE
	yK5f1JvFHJ55JTGtzyGDiXyUZ4G1X3tEISfqpx6pSYWDGc1ZY6BYHYniFvZhONn8Ibyzi4dYZdR
	lCRqEltgMZC9q3mtKvxRLGMxRlz/cnSrb5Kb745I+a9jwu3LBzAuwdPlfYYrHxxyGllYoMV9oFf
	7uO2yTD5Y47GB673yhFqUlYPe/bNos53RDegOXYaZvufq170Lr0YpLBRlOlscBpPqs5zTjVFn39
	t8CqCMtwoN/wky9y+etLE95RLFXtyh6PuYkrHC/jPpBKDJ01L+pNQZWHcpjNntE1i025rkghaaK
	a3AM6+21yvAskpVwePiqGZ0KGnySIxN969Z34Q6Ksy0jcErOpPsINFp53ocA7tCYcj+54D+ZYGm
	+5/wawK
X-Received: by 2002:a05:6830:4c97:b0:7db:bdd6:635a with SMTP id 46e09a7af769-7dc17728eeamr330070a34.9.1775677909639;
        Wed, 08 Apr 2026 12:51:49 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dbfc1cb79esm3395778a34.15.2026.04.08.12.51.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2026 12:51:49 -0700 (PDT)
Message-ID: <699933c1-c150-4e10-a5fc-6f128260d0c1@kernel.dk>
Date: Wed, 8 Apr 2026 13:51:48 -0600
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
 <c4453f4e-c1a2-4f5a-b278-76b63d5dc4a3@kernel.dk>
 <01e6c582-fbab-40ec-97ac-02675e6a08ed@columbia.edu>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <01e6c582-fbab-40ec-97ac-02675e6a08ed@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: o9y4xbr53kao7mu7tz8wfa91oinfrtc6
X-Rspamd-Queue-Id: EF87C1C0013
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775677910-127118
X-HE-Meta: U2FsdGVkX1+jfioZ/lT2Hvxwx/y0vxFMlbd6aPoTONWgxAM6ZGj5UVlwVgvWtJnu+mToZuESOBlXbrY46d5GVmwweKPEouUocejc4ivGU2CXtyv/zQ3Tn2JOtukD/fVpzG9GmiZh69LaW7+6QXbup19AUNVBQfMtj+EGdp/8ZmcoBQfToqZGxpDqwBgu9vdeYq5PaV1Owi7RCSKNfflwLHNQ5VO4h7p/PNZiHXyFzlveBW76pKLEnxGg+xlDyG9FY3SYSm6zb4/cL5QukQ2dgDKW+26o2NAfRUjS1xfYeT1VO0NcKA2FIi+gIconLUkmt843e7v88EX1saWaJo0xJqk3UsGvN1J8F5AgzeGSTIXhEhn6NVCobaeZ15uIOU/n7yKzllO1RCVyNyXOgglyiSOTKdp7QFI1dBAcxcyymrsd3zsYHXJKhlloPoZKh60nbh7uMRWgK820qESEJEjpHjlXH6kdC4Y5N9erZqyuzarGWuoc33ae4aYxYNKZap9KiotG04wti8OgwPPwzesQdYFb95hj+5aCAvk4M7PNvZhd8eP0hco2FFizpz+63NL3H/GYgOHaVJYEHmjU6v2EehiN6RCSEBFu1oAABNK4nePWy42OGNtMXb/VsUeDCF1crTUzRQBK5UHAW5K43OGVu57SCB1fObzdU9Me9ia5DlReMl/S+Q3KR7ZVGhvkg1Ck2SdiaTuXuA+y2qq9OyAxVHUCPzi3FlqfXJs23Wt4Ht1oS19oZtTrRZa6lTcEJFy+fBLvWKofj4SJ0fi5SEkGnvHg8+n3OqzcmKpKEge7BNVws4a/E+bqZH0p+VRsA4II22siG5ms64FOPe0LzbrxVhHe0xLsIVo6Nre0MF/YLJ+ab6B8Y4kCF5F+G2HBwSodqNXDTAVWXbZxe94WV4l61QSaPb+2eQZ9Hq5tMnpEUnDEnW7FBYqvPIC/PoWlQ11SbADC8XTNx71/3Y5A6/9
 20Wm8pM2
 8m4XpXQ7ZpOeElutjraAFDuLNFOv5XttjOhP0eabPrBpfU1YOVui8rs0oMWGl/YQRMPr2a1X/jCKfy6xQmsAKWQfX9FuInvcMtBmLJ3iOz0I9gwHK22oTxeD3tIwvDGs2uet2+eZ8I+88ILOMxl0iRbQi+Zpcc/IEQkGd4idswoWQe30ty85OAGq9aFUlufmlsdFtrtyLasD73LZjwuJxWZqWwH7mlLQObu85JHkkydBBgB+ZGwN2mxfgLAkmMm0faYKrSyBxe9aFHbvYScVgbpHbUrgv4q6Nl7qKd3L7BGlaZxWI6qkWU8gbtDYP0Idid3iRHKYdqkF3V6kCu4WcAqkzz1C5SMehzBURjHxIpYe0e9OZLn+dfh+ckWPW0MeAk1h8GmE0KB/ey9OARcMcyoUr5J7gKk8395q01J46O1uVxen0EnR396Go7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/8/26 12:48 PM, Tal Zussman wrote:
> On 3/25/26 4:14 PM, Jens Axboe wrote:
>> On 3/25/26 12:43 PM, Tal Zussman wrote:
>>> +static void bio_complete_work_fn(struct work_struct *w)
>>> +{
>>> +	struct bio_complete_batch *batch;
>>> +	struct bio_list list;
>>> +
>>> +again:
>>> +	local_lock_irq(&bio_complete_batch.lock);
>>> +	batch = this_cpu_ptr(&bio_complete_batch);
>>> +	list = batch->list;
>>> +	bio_list_init(&batch->list);
>>> +	local_unlock_irq(&bio_complete_batch.lock);
>>> +
>>> +	while (!bio_list_empty(&list)) {
>>> +		struct bio *bio = bio_list_pop(&list);
>>> +		bio->bi_end_io(bio);
>>> +	}
>>> +
>>> +	local_lock_irq(&bio_complete_batch.lock);
>>> +	batch = this_cpu_ptr(&bio_complete_batch);
>>> +	if (!bio_list_empty(&batch->list)) {
>>> +		local_unlock_irq(&bio_complete_batch.lock);
>>> +
>>> +		if (!need_resched())
>>> +			goto again;
>>> +
>>> +		schedule_work_on(smp_processor_id(), &batch->work);
>>> +		return;
>>> +	}
>>> +	local_unlock_irq(&bio_complete_batch.lock);
>>> +}
>>
>> bool looped = false;
>>
>> do {
>> 	if (looped && need_resched()) {
>>      		schedule_work_on(smp_processor_id(), &batch->work);
>> 		break;
>> 	}
>>
>> 	local_lock_irq(&bio_complete_batch.lock);
>> 	batch = this_cpu_ptr(&bio_complete_batch);
>> 	list = batch->list;
>> 	bio_list_init(&batch->list);
>> 	local_unlock_irq(&bio_complete_batch.lock);
>>
>> 	if (bio_list_empty(&list))
>> 		break;
>>
>> 	do {
>> 		struct bio *bio = bio_list_pop(&list);
>> 		bio->bi_end_io(bio);
>> 	} while (!bio_list_empty(&list));
>> 	looped = true;
>> } while (1);
>>
>> would be a lot easier to read, and avoid needing the list manipulation
>> included twice.
> 
> Yep, that looks cleaner. Although do we really need the looped variable?
> Can't we just move the need_resched() check right before the while (1)?

If you do that, then you'd also want to check if the list is empty. You
don't want to schedule_work() for a potentially empty list. Either way,
you need some check.

>>> +static void bio_queue_completion(struct bio *bio)
>>> +{
>>> +	struct bio_complete_batch *batch;
>>> +	unsigned long flags;
>>> +
>>> +	local_lock_irqsave(&bio_complete_batch.lock, flags);
>>> +	batch = this_cpu_ptr(&bio_complete_batch);
>>> +	bio_list_add(&batch->list, bio);
>>> +	local_unlock_irqrestore(&bio_complete_batch.lock, flags);
>>> +
>>> +	schedule_work_on(smp_processor_id(), &batch->work);
>>> +}
>>
>> Maybe do something ala:
>>
>> static void bio_queue_completion(struct bio *bio)
>> {
>> 	struct bio_complete_batch *batch;
>> 	unsigned long flags;
>> 	bool was_empty;
>>
>> 	local_lock_irqsave(&bio_complete_batch.lock, flags);
>> 	batch = this_cpu_ptr(&bio_complete_batch);
>> 	was_empty = bio_list_empty(&batch->list);
>> 	bio_list_add(&batch->list, bio);
>> 	local_unlock_irqrestore(&bio_complete_batch.lock, flags);
>>
>> 	if (was_empty)
>> 		schedule_work_on(smp_processor_id(), &batch->work);
>> }
> 
> Makes sense, will do!
> 
>> Outside of these mostly nits, I like this approach. It avoids my main
>> worry with this, which was contention on the list locks. And on the
>> io_uring side, we'll never hit the !in_task() path anyway, as the
>> completions are run from the task always. The bio flag makes sense for
>> this.
> 
> Thanks! I'm going to give Dave's llist suggestion a shot on top of
> this as it seems like it'll simplify this nicely. Looks like that'll
> involve turning bio::bi_next into a union with a struct llist_node.

Since these lists can get long, I'd keep an eye on llist reversal
overhead there...

-- 
Jens Axboe

