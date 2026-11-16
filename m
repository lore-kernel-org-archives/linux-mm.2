Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 534C1606A884
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 07:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=kS4RN9rx;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=kcKJjymV
Received: by kanga.kvack.org (Postfix)
	id 552AE6B05B0; Mon, 16 Nov 2026 02:41:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 529766B05B1; Mon, 16 Nov 2026 02:41:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41B3C6B05B2; Mon, 16 Nov 2026 02:41:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E5946B05B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 02:41:35 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9C32214060A
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:41:34 +0000 (UTC)
X-FDA: 85440187308.03.7EC1815
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0271420008
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:41:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=kS4RN9rx;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=kcKJjymV;
	spf=pass (imf03.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794814893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MN2Q31ZBwTxSB7BpF4qizypCnzz2jwe96k4GDB7Z73E=;
	b=GIhifRSwZrCEHa/E7nl2VYbb0krCXjhcNHv9Er0bp9+Gb9dhfKsgYk+XYMjS0o5+QIaL9z
	Dbkzw3Jvfgy9+HkhErpNKFtMxhE0DXIt4GflfsakL2eHtRM+WcjMkxBYFhARmEY9mXJFNl
	R1zWooXwfwIBqjBU0tXNWYK1l+iF3lk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794814893;
	b=4/aVNG4h3t1pEe1xIxHslpYz4i1eQXHipLrJ/3gN0+PE8dXKVn/K6i69AhSUzba0CVXhw0
	0bO3OvjJMSXFg1wJKLDZK/Sc7Y1fW0cGahAZyfsmo/bKAOXLcciiFI7lphp9Isg74ANhNH
	lRML8F+0KhYzrcAATjIv5RMzBYF9NE0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=kS4RN9rx;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=kcKJjymV;
	spf=pass (imf03.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
Date: Mon, 16 Nov 2026 08:41:27 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1794814889;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MN2Q31ZBwTxSB7BpF4qizypCnzz2jwe96k4GDB7Z73E=;
	b=kS4RN9rxPU1n/+1+WYs3PmL7nb2luyx0bowGdZidk0jDvrwPGU9Fbq6sSJmURyKd7AXhgl
	4OMIMNdBQeYOYugHShQeeyHeNIWH8+EhAD+n5qfWLJxbTAKoNGA9hx9ZC45ZW+AkGqwnUb
	Z+qz3oLMyv9U6HBDY1NO7gV6rqa73f9U5ozrsCJF9R9vEX0zH1l6nBgW6FrwTQ+cCmd7gr
	cQQ841xNaxiLKkvvfFzdw2Qc6MqqZNwRECD5lQumWDhuJV6P73ays/9O5Di0laWcyn+YDe
	p19I7UhOSwn8wWGNStkJ3kETzi5ejZKaODskvXhiGawMMykM5V+k6QmtMhgF+Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1794814889;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MN2Q31ZBwTxSB7BpF4qizypCnzz2jwe96k4GDB7Z73E=;
	b=kcKJjymVOTjCBVCTSqcHyrzaE9NKNAMZpRzmwj/98K3Rti1Z/0+ogVk6PbKUE6yyvFiT5p
	Nbxc51YOwsHHNuCw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiebin Sun <jiebin.sun@intel.com>, dennis@kernel.org, tj@kernel.org,
	cl@gentwo.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	clrkwllms@kernel.org, rostedt@goodmis.org,
	linux-rt-devel@lists.linux.dev, tim.c.chen@linux.intel.com,
	tianyou.li@intel.com, wangyang.guo@intel.com
Subject: Re: [PATCH] lib/percpu_counter: allow concurrent sums with an rwlock
Message-ID: <20261116074127.XigdFZzW@linutronix.de>
References: <20261116015655.2744577-1-jiebin.sun@intel.com>
 <20261115191636.f18859e4dd5f58b9a33e7814@linux-foundation.org>
 <20261115194404.a8d751a7c17904c756b16b61@linux-foundation.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261115194404.a8d751a7c17904c756b16b61@linux-foundation.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: 1gxcp4zcwhepujpkrp4fqerwfephszwa
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0271420008
X-Rspam-User: 
X-HE-Tag: 1794814892-349609
X-HE-Meta: U2FsdGVkX1/NvFG+qLikoknL/zMknT4DLIIAIzCtzYhQMJe/ChGicd8kTcoqIDCdsjpKbDpciX17uzoQtHoxdThtU/p6xVXQd3OmAKr0ARpPESRw9e+oi8DuVRWVBoSLcV4cRXH1o8Qw6Utx+6BxwXF/okrs7S5aBsLMpJPkn/5+2J5JqxHmder7HvXfrtK+qVaKVTm3L1CDQMYXoqQLKy1jFFfaDJJ31jFtWNHvCabjldvjhpQ3cyNzR7nGtc98jsmxq3j6nXhLjaSpkJr8uCZIPMFbWMEemzF9PiQ9vgMjgpS2umXpml0vvg9+jZh5+892e59XrT5AyHbyuWpvAMzL9tSBSXRqyq8xhI1F34cqKLAODfibo4MRuHG6SuZiev3Al0WE8DnZJaWYTCktHu/f3Q1kaeaCQIGr5lHogtAu/jC3xvRUogMd9CvUkMhwDdbbsszcboZ+OCKfIDBPYsDlllgovp/cQHVinAXzdtjowPckxS3GqyK0Xscnrb/EOqf7qVHFp6t9bRtfpXskwNWE77R6VH3JSLJNbhZD875jH9KaVHI9uKtJVBSa32z4tgdkGfI5oVYf3SEj56YDcrvEr0S474tMB/HoWVugWt3Y4JNHw6/M6lZlPhNC9mZUjew/Zsus8EpUeVCeqHQGE2x7dE+DGJnjYa4jqP9tKF8QzUEytmzNXFWMNaDbAsKJo4gngztxsD0TW9oMBNrRoRWdmdMRlRC9zmENZyafzZd2ud/juMEg2dKzv4DXapgV3xvlohke2bKoG7a9gMJfyvOoOP85S5K+MBxVc6UASnD7PwWfEjJBPqKawv8BdRZqWqHBNN23zSqlcuPPvtqPk2h9U3ovnjgIoY/Kxv1sRxQZlz6Slht6V6bfnZ5/kUQ7crg63fy7SnZiXytcf+N/nqgqxTyxUpp436Oaac6xPmc5twyqC6EhpcDmfgUV9SJRP82VWslR5uQXWe0KBcW
 sCJtcWyb
 dhcz5k/wqWeC2T8GyKq2lYng9a2UPJuJaOb8ZNcjKKH0k7e3HFB1b+Ycoy6rJaV2pYt4xHZZ+LW/wOY+Qq83PG2AfkbCccZHnmaOCUO5r6jPl9QPXDjU3syGEVlhu/5ajKLfGTKyRoHUAMVelLWj8+juYoCJ6H89WHVyinPWzqimzKwJu8dWrvH0qFV3R0MgC3jcN0ENFV6jBQg7KSoJjsUN4JIw8/GDFoUJQN/Kc+VbmirEOEk/9oQ/Uog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-15 19:44:04 [-0800], Andrew Morton wrote:
> Modern rwlock_t does implement queuing, so the writer will get in
> there eventually.

On the queued-rwlock implementation, if a writer blocks on the lock then
the readers will wait until the writer is done unless the reader is from
interrupt.

There is also seqcount_t where the reader would be fine as long as there
has been no writer during the read and plenty of readers don't block
each other. It might take a while if the writer performs multiple
updates and the reader can't query all CPUs in time.
So it is not easy.

>                    But nothing is simple any more - there are
> complications with rwlocks on PREEMPT_RT and with interrupt-time reads
> (do we even do that?).

There are a few users from preempt/irq disabled section on PREEMPT_RT
which mandate something like raw_spinlock_t. The rwlock_t will break.

Sebastian

