Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 249BBC5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 18:22:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB2786B00A4; Tue, 11 Aug 2026 14:22:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8A626B00A5; Tue, 11 Aug 2026 14:22:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA0E56B00A6; Tue, 11 Aug 2026 14:22:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9EC5E6B00A4
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:22:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 75FC01201BA
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 18:22:03 +0000 (UTC)
X-FDA: 85089807726.01.47F505C
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7107C14000F
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 18:22:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=o4R0lqgN;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786472521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h1IAHc+ImDLE5s/30NfO2LKxy5ibfAwUYXAwFYdGURU=;
	b=gRO2fz6/oSyLUAyvHCIxFsoKaddfMdlcxbnykTDyb775gmw+3/UXuaX5G3TksIrjSjRP3m
	vaPFx7k0fRghXJTlrzGi2aKsll1jCtE97Glv0aPhjqe9+4w7v6+HSz3Ujhm1ob0JQ/d73V
	tKUbcZhITzE1Z/9PBgS3On9UYaOjNc0=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=o4R0lqgN;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786472521;
	b=Z9LH9YoIfuEUB7c9SqfKqwLY99QP1G8psocpXd3tSHuTWkItVN4ZVR9vDPjbMXhDUe8so+
	PxudeDPid/G0JuZ9l+XXWqAaVvzrsh7l6RlsMA9m6o4407rmdepMeBwPmdKDfmjROJXlog
	1zWw5k35wwsQxGPODZUEs42Rp8VMezc=
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-664ae043b7fso24371d50.2
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:22:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786472520; cv=none;
        d=google.com; s=arc-20260327;
        b=oTqtagL40IGjCvniRroiSn2Cr22Swl7gKJphwTC04/fXSS1eA+lD83StIsfI/6lBYC
         iG82aC/pW08bMKxQZskKdcoUxasFosH5szuQrjg+JtDxv/vfia8CtrBuZz3kH/l2Z+YF
         fSZ8QkrGE/HEGjrUSqbuqBpZHtk44SGjMP+pHTNAffRfNAA0t6nP4+BUwNKDtrkFjFLi
         fmQzHl+6j5T7Wh4MFuK9ip1AKLlsUExPuVs5J9gry9TFL2OkuzKFOAJbDvaQTOAgTH/n
         m8W+WTOpoB28XG2EeeZAlcUIhmYmyrYyM+gPu/il82A7MWVIpG9dT4NI4xxrh9k/f1+F
         yY8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=h1IAHc+ImDLE5s/30NfO2LKxy5ibfAwUYXAwFYdGURU=;
        fh=aU0wRiOtil005adofNewoDgaaerQEqGRcl4hTjLFsa4=;
        b=YaVScuGEptnTehCq9UzKfjcAIx5ZwUOrRuTGLGtyRlo2hqyLlaELgNDh7XsyDUR54G
         rJ0XUNQmflCOAspQmXMVUeslQCrkiPF7kmAq1UlqfUm6Fc+6Lu3XQMAxgeHjH6UyHFxa
         yD0i2MXlnY+qkTsVuWnvjKc+24Ga8jxIfuT0Ee7Lh/H+HOlkG3pg0U5aOYy6SjrgisAq
         zx6dhIAvbXVt0TPfJAl4vfzQWRxpJjabWtQT/R4IHAzgVzyXt6o25TzcLgP8+rF8uHv3
         4KaZGdZChjAAUBJwgDpbAcJiIEkmcwASFxaMlVVefklCzq0a0VW7Mklz5SCZFzxfEHNf
         fXCQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786472520; x=1787077320; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h1IAHc+ImDLE5s/30NfO2LKxy5ibfAwUYXAwFYdGURU=;
        b=o4R0lqgNbp2fKpSCXlO4VkYRf3rI+rbZ5rVQJq1QmHL7kF/P0SF5Q6w0JwSCDRPnRA
         0bVAVlorCbdaKf6NQL3HiL8Md/CFzGQIwfsBvKqWBgQhaL+4GYL3g6tVLwuB/FlEoEnl
         5KpXEwmEIVnyKOxNov/sHltNZVrSXfUtMG6BDILnx3kqdCy6+0P830QWLglojAqLxFeX
         DLJpgik09xfSYUq9slmnDsMonzd5bmgYOcDLUD45kEzxyCScF17JzBuXK/gYqBpyZ0e3
         wNwD+SX6HSagPp397fLONJ44g7zIeaVZP2H/8g9PEGu5K+QEPlU6EweNsazk2JGwOuFc
         1wHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786472520; x=1787077320;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=h1IAHc+ImDLE5s/30NfO2LKxy5ibfAwUYXAwFYdGURU=;
        b=DTxtpM+N+wqGKTGioBc1aFEvLeLiuIpR5VpI2jGfSAQ/MtWb9baMI7/VvJMQA6j3WM
         ec4uDoydurlwIkUQq4dll34L5ETLWACvxIkg/XlqQ5NpuRrQD8u6vi/5oxywKf03wSmu
         4P8qwDKqkmGOvUv5IxGos6AOSD48jCxILURsetzNbfAdAhdQa0ei6WTIhxFNLzreY/jm
         HHnv7MaREWXEqnzQPZ9MbT3UYThg9Qe8zwBYMgiXnEAb8CEAPWk6GILBALNuOLN9ebcf
         dhQ/BG5tcLS59RUd6f7STb0PDr8bOftfkYkhQYdTfj2+kk1wpLymg19uWCLTvnwdsQbj
         hrlQ==
X-Forwarded-Encrypted: i=1; AHgh+RrbrCc26FLUCjTx++8Yw58IsAz4lgb/DL3ls+hg/jYP6xje4tbWMBjkzrG2KLqOF4TIYUQkVjWF3A==@kvack.org
X-Gm-Message-State: AOJu0YxS2/GgBDzJfOlGFZFVShDMhFIOJt2MPwMlBX6G/gRdCSEZ6zWZ
	e1xaJn2WkluT1fAy6x1xj0amcnaQmZumx1Rk9myID0t6diqo2T8T0q8E0GL59ltutMtyCCZCEYg
	2iYZlWbBcQhY0WlBppRJY12EiPN6XzcUg1g==
X-Gm-Gg: AR+sD12NAeYgP1LWhmDxgB2cqoq407bVvpp2kB76VyPLlvJEV/0ePHpeE/9ExwYUQBd
	i8h1HdEKA2v070RSi41KzRW/MggdgG+5jcXtlyH006aPcncMKK1C3Ozho6q4f9M94vsEHFdSQeS
	rNPCZFQ4qg0FzZZCq0f9lf8DylgiNcQgfrEyzOScO5fabyd7Kh2z6r4O7JsjKN1HCxjBJKeA0NX
	xeLkLebBg+VAfAzxnZZpw7YESO0rDm1syMs7QYddtYBtHsQvzYIpFOZf9j4oAewGmjqttpXw1/D
	8rNEWdXZGgtQyiZ+KwI8f2Kfmirm6tSOaejqR4AFbUoMOHI=
X-Received: by 2002:a05:690e:454b:10b0:668:687c:9481 with SMTP id
 956f58d0204a3-66b22c9113bmr2438588d50.1.1786472520357; Tue, 11 Aug 2026
 11:22:00 -0700 (PDT)
Received: from 95991385052 named unknown by gmailapi.google.com with HTTPREST;
 Tue, 11 Aug 2026 11:21:57 -0700
Received: from 95991385052 named unknown by gmailapi.google.com with HTTPREST;
 Tue, 11 Aug 2026 11:21:57 -0700
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <20260808191230.3345930-2-sh_def@163.com>
References: <20260808191230.3345930-2-sh_def@163.com>
MIME-Version: 1.0
Date: Tue, 11 Aug 2026 11:21:57 -0700
X-Gm-Features: AUfX_mzdyudspR2qnxw93U01qmHDghDXKx-kMHufO3qLoTeCvzr1GfrADzbbwqs
Message-ID: <CAPAsAGxE_RRtk=H6LAsZ2=bz3XU7BZ1+3deutAtX++_kTYTYKg@mail.gmail.com>
Subject: Re: [PATCH] kasan: avoid unnecessary quarantine lock cycling
To: Hui Su <sh_def@163.com>, akpm@linux-foundation.org, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org
Cc: glider@google.com, andreyknvl@gmail.com, dvyukov@google.com, 
	vincenzo.frascino@arm.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7107C14000F
X-Stat-Signature: gz96sgfi6sw3r4j6hjmxkmygabuukwey
X-Rspam-User: 
X-HE-Tag: 1786472521-343396
X-HE-Meta: U2FsdGVkX1+r/VZn7+DWFFTkHtFxVlFwD8kyCredA+TxIjea5aWan3775iGLZFO+juSNjFmX9F+xmcfLXvLMk6QYN1XivtcT0RQu0Q5eEIyfkBpjgjBAaYI2uln1esNhbXeo9SCk0Ct7PXeXwGW0zqnIea5e0aVymNd1X658t5yDqGgyfMLhk30hGJoPxqw4cN2c5e1U1bxPH8YMPsAUIeHM0eABrSH2ktlH8PokA/Of9fuLrj2Jf7ZgtEtuauy1k1MpxLlcXzyfXN0FYBJQR5JxVAXVndIOjrZTdTkRZcsz5hfTzk8LpVAEMDBIWpxdju/4ZTwr6aHydbHIU4ySJZDRhyoxpXvCkSkTHj0XHd+K5myp4HmLg1PqvzVnvJZ2cQS5j8vqM9VdG7YWTYgmW1EIHA22FdCdhrqZ7iP+4/rruXHUPVUT6/sGFzG/OQ1Y7dnG9dtbu69BwaYUYj6SQix1WF6Wr0RQdjoIKVI2YCcFN25TkfJroBfGYXyNn8XU4fv5xHv5seldPIw+P0Ji/11ImdLlCxCDcUqoejRPtJLuI0zXKRXTxSamFePk+lh2INhuaDPyoG/mvh71Jmlwm/9GqUWSULm5eZ9CTN+3A77BWo0x/uYyFenSE9Csg10jzc8rNwEa5niaYhmDszvmMAjI1t2/bqOIVHcKt+Dp/wW+l9BIrmd4nOngNGMk3PfTCMwAfO5iK5HomgolcZkMOYWF9a/u4YxfI37QuX6f1JmU3mVA+nxy1vZ3dJQ6KK7HZ9jLZ8h97pS0QQ1t7XbIQxyH/V9EVhl4Zku8WjatjA/w4S8qen/HGE53FSmrXHRdX39gsj2D111Gq3YPxpjmbuS4Asnk0tDh2kEHSn7n3WZfs8atko2VOxG9lOkx/dCHntSI8pf/a+JuU3E1rNcSZEYnpu6so2BC20fQXJxTHg4nWOISY4AzNmB/QJbNgnMmxGCU/Pcw9Smca+ti49h
 djDfVhQX
 F/2bEd6K1VnQtZE+qRel4CSfsjHWgNh+y5D4fAWiQPhplgzYUG4D5gFFZnD5TeQJ8EeeMyCKD0MX0xClYjxLpvrLXNWgWhCyjrqYc54wBvTq5pmHSyuTk0/9w89Ds2BWnu8Hb49++k/Xsxi+jsjpV/Oz8+vMA+VWypoH9tXOgjPDr/wvER5kDvGwpOjxZby0A1O9dlM4+eHp772bAExm4gc60XgkCc+ZVZOr6Z63BYfnHA0LilprQ/zWPi6NqLBPzMhxrbcztlVqtr2WWohHQYg4+soS9gH35rjObT4VcH+w1PPWyP5TSPeULniG90HC6GIE+16aldGoahXRYp64pThDfI0WuuNVRK3swP6kChIA5i9A63uWGdFfQdilz2T+6fW/rHN+/7oDHwARcd8GT44hKuQN+329dzp0ZZiTH6vw89fyi/77bJ37FsBQnHnzVy0KnI4JgLNDoWnnymWE0wngUX0SJOQ/mCl5W8NLU5GjWv4OVPXqGmp7kylNWCwHehggF1GcALpJcOUpbcv6k8DedmZgDDKHYYwusHpSKTaHrOW6pWNkWt/FNCzWLfprWZo5UHJt+e24jE25bDON6KVsBcS6L6CpN7GOJzSoW/cWsC80kVokFhtrxEo88CNFeXE0C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hui Su <sh_def@163.com> writes:

> kasan_quarantine_remove_cache() drops quarantine_lock and restores
> interrupts after scanning each non-empty quarantine batch so that
> cond_resched() can schedule during a long scan.
>
> When no reschedule is pending, the unlock/IRQ restore and subsequent
> IRQ save/relock cycle is unnecessary.
>
> Check need_resched() before cycling quarantine_lock to avoid this
> overhead when rescheduling is not needed.
>
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Hui Su <sh_def@163.com>
> ---
>  mm/kasan/quarantine.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/mm/kasan/quarantine.c b/mm/kasan/quarantine.c
> index 6958aa713c67..db7170f6f1b2 100644
> --- a/mm/kasan/quarantine.c
> +++ b/mm/kasan/quarantine.c
> @@ -368,10 +368,12 @@ void kasan_quarantine_remove_cache(struct kmem_cache *cache)
>  		if (qlist_empty(&global_quarantine[i]))
>  			continue;
>  		qlist_move_cache(&global_quarantine[i], &to_free, cache);
> -		/* Scanning whole quarantine can take a while. */
> -		raw_spin_unlock_irqrestore(&quarantine_lock, flags);
> -		cond_resched();
> -		raw_spin_lock_irqsave(&quarantine_lock, flags);
> +		if (need_resched()) {

I'm not sure about this one and inclined to agree with sashiko here.
See https://sashiko.dev/#/patchset/20260808191230.3345930-2-sh_def%40163.com

With local IRQs disabled, the local timer tick cannot run, so it cannot
set TIF_NEED_RESCHED due to time-slice expiration. Perhaps another CPU may set
the flag remotely, but AFAIU nothing guarantees that this will happen.

If need_resched() is initially false, it may remain false for the entire scan.
IRQs would then remain disabled throughout, potentially long enough to trigger
a HARDLOCKUP.

Current code should be fine, the bulk of the work is done by qlist_move_cache(),
and the unlock/reschedule/relock sequence occurs only after each
non-empty batch,
at most QUARANTINE_BATCHES times.

> +			/* Scanning whole quarantine can take a while. */
> +			raw_spin_unlock_irqrestore(&quarantine_lock, flags);
> +			cond_resched();
> +			raw_spin_lock_irqsave(&quarantine_lock, flags);
> +		}
>  	}
>  	raw_spin_unlock_irqrestore(&quarantine_lock, flags);
>
> --
> 2.43.0

