Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C6BBC624D3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 14:50:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F55D6B026B; Tue,  1 Sep 2026 10:50:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A6686B026C; Tue,  1 Sep 2026 10:50:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BAD16B026D; Tue,  1 Sep 2026 10:50:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 158DE6B026B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:50:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B02B5140458
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:50:45 +0000 (UTC)
X-FDA: 85165480050.16.86BAD80
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 390BA120006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:50:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kp6Id2ek;
	spf=pass (imf29.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788274244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=48z4Zn3y11CKh0cUVxT7sUV2cA21GxR/DgLrBaE8Xmo=;
	b=4LN2vRe+HKgvaEVZT9Fipw3LRz+DzMnzVMjxnWUOtnvnrqyjo/D7S74Y44rcm2TP8N6gYa
	nEMYZyhjd4ICvqf0K65ohBdPlVSy7pJjsCokm2hGhfFW46WhsgjmEHLk+asJe/5Ve0mbgY
	Jx/BM/+8kMqBSbJVMjoIKBoJIaS/o0g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788274244;
	b=1SUmwQ1TkvrGBHZD0cxASwQzgSV4dCKij0QdB6x6Pk3kmm3yFd0B441mzPpq++ySdujLJB
	84UVtQyHpzHfLodWJ8F4MeAQLyQXVdKWUJx5Js4+72Ivs2it94EuE2Npt4/zr9sR0DG39V
	ERQXXRk4pk3Bmbk5XT9LPS72JY0JP6k=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kp6Id2ek;
	spf=pass (imf29.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AB3526013A;
	Tue,  1 Sep 2026 14:50:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 969561F000E9;
	Tue,  1 Sep 2026 14:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788274243;
	bh=48z4Zn3y11CKh0cUVxT7sUV2cA21GxR/DgLrBaE8Xmo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=Kp6Id2eknGGRo+fq2I807tlODOLi9jfsO59dHQkrSCV4evO2917O7y4ZtJyqm0YAN
	 /w8I/T8xL/hnwjHgN6BPSB4LSBzhlUyjwCG0kotNPkpBtXRW3cKnZ6m0UxLDax31iU
	 dpsen3FAtZ5ctvL6uzFJdZz0768+aE7JfN9rpjBJP/vOVSiklvT5DH3R0hBbq71KfD
	 nXwbibGmAueMoKPa6qkT86WCTurIGcR5LOmdhDOZyNB4HYLvM1BVMbm4bwNjOCRedv
	 OH5Wv8DWDKE6/TDZe0knRC5/KL2W0QukFMgcfFVipy2A+81M1/ae4I8XoPT9IQ2BC5
	 WZxfVUZHgNXyQ==
From: Thomas Gleixner <tglx@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Hyunwoo Kim <imv4bel@gmail.com>, Frederic Weisbecker
 <frederic@kernel.org>, Anna-Maria Behnsen <anna-maria@linutronix.de>, Kees
 Cook <kees@kernel.org>, Christian Brauner <brauner@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, John Stultz <jstultz@google.com>, Ingo
 Molnar <mingo@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan
 Kara <jack@suse.cz>, "Eric W. Biederman" <ebiederm@xmission.com>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v2] posix-cpu-timers: Dequeue per-thread timers before
 exchange_tids()
In-Reply-To: <apXGzcA9BmrbrQZv@redhat.com>
References: <ao7Q8miiuLAPVnWv@v4bel> <ao7iQ_wOLghOvTsq@redhat.com>
 <875x0qclcx.ffs@fw13> <apXGzcA9BmrbrQZv@redhat.com>
Date: Tue, 01 Sep 2026 16:50:39 +0200
Message-ID: <87qzjdauv4.ffs@fw13>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 390BA120006
X-Stat-Signature: kitr7bx1kxsabyekkgoqedp8toxjwcfd
X-HE-Tag: 1788274244-117425
X-HE-Meta: U2FsdGVkX19QEZkxZUxrZ5ciUyPQ5bwId5TGBOEaICcauTOfWMMBa9WuiUd4cq1apL780wFVhvr/dSMwrAAboUSyCEYuO03ravLjnK95hKjd3CWI7f2YcBCQAxpZX6uqY3CW+WQyX22QFHOks/icxGFDxbMekWNxlR+lK3FPPW3akADzVsR5Mc0aaS9pjfTiMndUhQWvrWsISgJO4LzklsdIdoMtYkaoEgWDhbdISUx5cUt2n+q4tqLhUZAskGZtVLe1OESUEZThtIbZJs9M2LoMJIxmmbosCrj+T0y0mMziVeOAfu5/u6PHkI0d0jRMSZLVV+i8QHWbo6ZYLbZzcvx5oUUX4RmAO0MZCWoTd9rIzVg3hOZNq3Ptcb7qjS58kQgQa/WeQkrlmHQHxRLHvNoY27BJlVn90xUCbC2N9cQhgNT23H14EW2xtJzKr3wl2gxTb0PbXcFugqRHJvX24plH8Qd59fSKDMEkAusEYhwgLar38vs25cMthQZin+xoAfm3zyTgxb76J/v37YE4Ix0UYpVlV7H24mn5oOiWnvEurJnXMTy+j7a1xXiQonxLFdUAl0Q3NdwGBvIh8x3NxnPJhX7YHEGvSYeSvPlE031qTOru/2rWo4bgUjw7swx1Ic5K+6jQAouLFy5AZDXb8h1o0IyFGAFsP9Qd5QToUO0K1ZQwpK9foAa1UdOpZMNrsfuzciHoefrkKblHPKCIEuw/jjl0Trl/R2+/A9ePsXD7ibCuG3lfkFbLpdnArX3VMGUUo9oflC3zOwaaskF9ZSFs/OnyWcrdJOToIQjhCdiRJjQTl4x8K1s541Y02pPnw8yqJ4pLL86IJj1hOeLA497fWpFZaLrAbxxi+HCKYGmOtvCE+SxVoGfOaXQXLfSa/7/lFNeBtxo52T7j4tJ8n08YFG8jQZKBMehhT5NMOMfM9S1mt3sLl9kMnJ4yYCKGbV6Xtu+UrzXIkGFa+xQ
 zKDT4m8m
 8vPaBjl27o9OVsISf+1bgaRdvjIiiBSWQArQ+eRMoCl+hplWLhE3ebCvRG9F9ne9VCrAY6uhLgrpcDKN+YiXSbQFax67o3rIWhRmHizovYdSNKf3BmU8UP/wFUxRP3bCK0zW4n/6Vc+DNJZcjdaIUaHqmtaYYtpMvR8NzwS5Uw9FILo4OK1gBSu4SIgaQvCB0MjkfdT41GLDW7QyjejzmtgYNIpe9H1EoBBfAV1/5tynzhIauZUD+u7u99UZaFspFZU+oiTYaLmFH1crlK6tPrIOqNBMIbu32mXp3C0YYcRn+fMMtNF8EJRFFnruC2B5LlemJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31 2026 at 20:24, Oleg Nesterov wrote:
> On 08/31, Thomas Gleixner wrote:
>>
>> On Wed, Aug 26 2026 at 14:55, Oleg Nesterov wrote:
>> > Can we move posix_cpu_timers_exit() or the whole CONFIG_POSIX_TIMERS
>> > sequence in begin_new_exec() up, right after de_thread() before the
>> > "if (retval)" check?
>>
>> Yes, but that does not buy us anything.
>
> I didn't mean this makes sense, I just tried to understand the Hyunwoo's
> fix, in particular the placement of additional posix_cpu_timers_exit().

Fair enough. But as I was staring at it some more, I thought more about
it. Yes, we can do:

     ret = de_thread()
     if (ret)
     	goto out;

     mop_up_posix_timers();

de_thread() only returns failure _before_ the TID swap, so that's safe
and spares sprinkling this extra invocation into de_thread().

What a mess.


