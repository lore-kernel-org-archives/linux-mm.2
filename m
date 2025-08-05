Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F8CFC87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 16:02:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D28D58E0009; Tue,  5 Aug 2025 12:02:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD96E8E0001; Tue,  5 Aug 2025 12:02:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C16588E0009; Tue,  5 Aug 2025 12:02:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B277F8E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:02:07 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3F3AEB6575
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 16:02:07 +0000 (UTC)
X-FDA: 83743170294.06.929096C
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf23.hostedemail.com (Postfix) with ESMTP id 52853140013
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 16:02:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=rGISkHgu;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=7wVexZJM;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf23.hostedemail.com: domain of tglx@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=tglx@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754409725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OjUpl3D+nV7PnfJSMgtaqQwj/p3x9pkClHwfr8sk4TI=;
	b=rdZTf/bHlmSY5/Ho1LS45rHX5C+35W6/PYds+uNLj6/n0h1hlDs/zkECkEmXfM04nWYRZ6
	O+bOqqYmSEb7Ob0jbIhUvZwhXOrroHAbc3chcaJjSjZBl1w0hdqGGA3rzgDiMxK0uQLBLC
	yurX4ckU7FQUMe8vS5XBnXojl2egQqk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754409725; a=rsa-sha256;
	cv=none;
	b=xK9YPJnlz+8WPEWOOFi6Tt1/iByPKSU+csh/kfEu9QwnWq5dmZGj/CMRJw/OB73C4sOrYD
	MTi0U9//+b7Iaut//bUJ1blxjoy7xR6OX1UCcivuhkf0D2KiCbslde+DZEj/Zh6twrNU60
	TWMm/OsLvRyYmxqEs+sZfr6067qq30Q=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=rGISkHgu;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=7wVexZJM;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf23.hostedemail.com: domain of tglx@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=tglx@linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1754409722;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OjUpl3D+nV7PnfJSMgtaqQwj/p3x9pkClHwfr8sk4TI=;
	b=rGISkHgu9s++NgzmXFuwoVK9/yzAMoWkubWqGh4I/o80rTL5gp7OFUG18QYJAB2dBo1X7L
	qUYm8Obuocud+J3g+6NOGyxo3dmoXOD2ww/A6MumR795OZrdc9eM6vO5HO1xjAY+aS2LGR
	mhxy3JR8VhHGbCAV0hHEPc2rcrJxSotNduQitYqEn9d/Oh9lN8iHm8ht/HUaTBi2jL8cPX
	44ygeDLVgXpC7jCIjKrghPAJv/ysRyveG1AG5W95kIDleZgS0pYAz+7ARpRR7ITnejELao
	EPRuWoBk0RXFYvy0jNoIKcSJTxh+TOtihB9+7zjEpRzREDWKxsP1sTNPgCQZeQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1754409722;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OjUpl3D+nV7PnfJSMgtaqQwj/p3x9pkClHwfr8sk4TI=;
	b=7wVexZJMBGwPmQNmpAnViqc/PI7DbPGle0gCKHBGNJ3zSqF5izB880PMhpVz5PUqZ7WCoJ
	Xpra8Wc9+yBGw8Bg==
To: zhongjinji@honor.com, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, mhocko@suse.com, rientjes@google.com,
 shakeel.butt@linux.dev, npache@redhat.com, linux-kernel@vger.kernel.org,
 mingo@redhat.com, peterz@infradead.org, dvhart@infradead.org,
 dave@stgolabs.net, andrealmeid@igalia.com, liulu.liu@honor.com,
 feng.han@honor.com
Subject: Re: [[PATCH v2] 1/2] futex: Add check_robust_futex to verify
 process usage of robust_futex
In-Reply-To: <20250801153649.23244-1-zhongjinji@honor.com>
References: <20250801153649.23244-1-zhongjinji@honor.com>
Date: Tue, 05 Aug 2025 18:02:01 +0200
Message-ID: <87cy99g3k6.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 52853140013
X-Stat-Signature: gih8ycz4h1x9ggy1h1ww6gbccoknc9xc
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754409725-186624
X-HE-Meta: U2FsdGVkX18IUuYAXcx2AVvfHZvshDg/Xir6KSsGdct0pdPWZcUpq2rW6i5LGuLou79d0Z+RKBf93Dg80lyfxEjxgjs+ZMLXz7DDvaS1uzxyqFrP6taaItumlvKGXgtTuIhSVznQL2s2RwIRzipmUfhRKqWzEDyC0RzNNNPpbV1BgSOIO0JucuUjdrnqPD4hxX/oJ3jJlqyd1t/wAAeWBWEubERWhPktKMT+vyY+Lapz4PqfDwESZxZV42tBP+3GvLHDrYWIbCMj8kyGogrZcNmdyDJfo249zAtdaqigbUt1X9XN7sFYlfbtN1LZCHccC9B3jpEzcxfEbvTjpGGayWzHLLOLK/VOfjPBr/BiSO0g1v4Xzn+4rIWB0Z9lHFe8pJ/KrEX71SIWu2GukJxpdj7xfy/PEdTwhjypwPxiOlvB5/Q6fUu6eRZi0M3vCI6gt5crNnty6HJYVwRRqzgsKuUFE6aFGHFTJogHrBZMqerRF+YtNQV9cM8KIz32mwzrXZuIS9VPaBSu+Ul95H8SF04wtvwGaCX2SOlElhtdY6z2kKTiF/jojuYdFELw5syIcX08zhTYlDjxbOtbsNX4SF1r1r4ZZ6KklCiJJgFaeR4jy/6XxplrKS/yqIOTELDAv5RyojPXLxctwobV9qgX1xf/3Msq1I9GZdn6iZSY5V3RYLRxmpm0cIqLECMFTUSQgyTCEa9DjlFcrUxccNONwfevn/XZzj0gpSeOm3LQglE0YsBsvEGLz8pNMuM7tNsXIl7icVz8XrfTcdjNEz176v7roNMFxz4B/6E4m6w36reg7p/t/4oTNRPyAPdRkgAZx1CHPYEJu74eJjJZLTOiQJ+pnnBsBwKoWCuUc82kV1X/l1tmx4VrG1Sw6sMoTes6GQLJHOul8fe5g7lT97LcNaozlIjFxY2ofQGXRfAJGTK4m6xSK0brbevrKwNrlMKGsOHEXWBHYWRRXBK9VML
 nDd/5Q2u
 m5wMVS9UfEi0jl9AW3g8C/UfoOz/rrXUKy5XUGmpG2fudcNXDM2M5byPl0hUKrIKAuFwHP4CoyNG+6ODxphWbElXrVml1aqPxQKcYa5+R3uNxqy7NijFME0bF9KhNiGVFnX+3XO0WxnHUvDT9+pi9iMnZERSKR22oSdJrrHRoDPhYk4ES6qbelAUkoE3sZ4i3mvfUoBuPHGqS9PREXrLqeWVAMtNSg8L1J2xyVA7p3GS4FyvbF4/8cSbVzjjNgTg3Nabyv/FWz8/GxMn4sMa15hAgONHaqPgwQM8zGBMXn2JLeGNPf1tT1sxSCnkmwKn8XSrsiPxK+Bb2bSQeGpUOhgQ+8yDj/FpaXbIvxw7Gg4oRzwmgdDtZbG8tqCELiz0JuuWisbDkc5MU8d8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 01 2025 at 23:36, zhongjinji@honor.com wrote:

Please use foo() notation for functions in subject and change log.

> The check_robust_futex function is added to detect whether a process uses
> robust_futex.

Explain the problem first and do not start with what the patch is doing.

> According to the patch discussion
> (https://lore.kernel.org/all/20220414144042.677008-1-npache@redhat.com/T/#u),

Can you properly describe what you are trying to solve as part of the
change log? A link can be provided for further information, but not
instead of a proper explanation.

> executing the OOM reaper too early on processes using robust_futex may cause
> the lock holder to wait indefinitely.
>
> Therefore, this patch introduces check_robust_futex to identify such

# git grep 'This patch' Documentation/process/

See also:

https://www.kernel.org/doc/html/latest/process/maintainer-tip.html

> +bool __check_robust_futex(struct task_struct *p)
> +{
> +	struct task_struct *t;
> +
> +	for_each_thread(p, t) {
> +		if (unlikely(t->robust_list))

This is a racy access as the thread might concurrently write to it. So
it has to be annotated with data_race().

> +			return true;
> +#ifdef CONFIG_COMPAT
> +		if (unlikely(t->compat_robust_list))
> +			return true;
> +#endif
> +	}
> +	return false;
> +}
> +
> +bool check_robust_futex(struct task_struct *p)

The name sucks. Public futex functions are prefixed with
futex.

But this is about checking a process, no? So something like
process_has_robust_futex() makes it clear what this is about.

> +{
> +	bool has_robust;
> +
> +	rcu_read_lock();
> +	has_robust = __check_robust_futex(p);
> +	rcu_read_unlock();
> +	return has_robust;
> +}

Why do you need two functions here?

If the OOM killer is invoked, then saving a rcu_read_lock()/unlock() is
just a pointless optimization with zero value. rcu_read_lock() nests
nicely.

But I'm not convinced yet, that this is actually a sane approach.

Thanks,

        tglx


