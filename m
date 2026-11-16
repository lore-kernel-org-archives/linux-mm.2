Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9433606A331
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 07:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=JkCiI8ip;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=lTj5aVeu
Received: by kanga.kvack.org (Postfix)
	id DA01D6B00EF; Mon, 16 Nov 2026 02:30:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D78776B05BA; Mon, 16 Nov 2026 02:30:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8DD16B05BB; Mon, 16 Nov 2026 02:30:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ADA326B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 02:30:17 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4BC2E808F1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:30:17 +0000 (UTC)
X-FDA: 85440158874.28.0929D4A
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8AB244000F
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:30:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=JkCiI8ip;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=lTj5aVeu;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf27.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794814215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nk2Mh+zI/TT/jjegJO9qYSlN1QKbBbjeWZjZ6ygv24I=;
	b=uSXJvxm7qfZnWSOBme476yla8Xcb4dWom08IipIR6zZ8LLOzvolIscE7X3zKRUM7n3jC7r
	4BTu6lUeoRMUjakiuARXqP2ynH2EE7Rr3ysQT3sOjvzSazIk+ICyi9cYkqcoJOXPh9DysZ
	0EN1BPU+L5Ct1I5TBJgp96+QT9L7J2Q=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=JkCiI8ip;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=lTj5aVeu;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf27.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794814215;
	b=2Pqs47X9l0dJ1nn6Qx8yJGoy12Mo4/F31Cd4BCyA9MRa1bsk+UeBIKbQqvJfPJWGHXuHcT
	u023WTS4OY5GtdUW9DZ4Z7QSylQmp7Zi8W7Fy9pn+rhhBaDxDW6pgT5kUAhVrgetqkCtnv
	VFYUJFZxLxJSjSSY4JRgSgC4aVZJtCQ=
Date: Mon, 16 Nov 2026 08:30:08 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1794814210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nk2Mh+zI/TT/jjegJO9qYSlN1QKbBbjeWZjZ6ygv24I=;
	b=JkCiI8ipGs6D6X54MmmtBVhszwJGHWiTFC84HeS/VV8C/PgiPBHK5t7BPpaxFTeg3R1x0n
	9yn9xn8UMkVMDUfuAJJG8OGdcLkN/uYDRZFKLu16Z9GNr4a6/yFZrkl0tYc4K9rYgle2ex
	vsp+Gt3SARQ0UmE8nGemRa8ZQclcIHvSEbw1aQ+uqKOCP5ifFNuA3EXpW0HekIXkHQIG6H
	2YkNalcDW36KJFi54qN6UyLhXQF2tRjCw3AAqH7Ku9tc+w7U1OdXnF12LxsPKw6UEO9RHj
	g79eof3+Ej81SkfwshOZgZTVrV3aIvfehIJC41965sbXn0mP2uPi+LJ8auIaKw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1794814210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nk2Mh+zI/TT/jjegJO9qYSlN1QKbBbjeWZjZ6ygv24I=;
	b=lTj5aVeuk5Ex7GPn7C4kR6cw3R3/I5G9oHbZoa/gyGd9on3kFZgrEiNwkyco9iphji7HM0
	HxmJV3H6q6qQPYDQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Jiebin Sun <jiebin.sun@intel.com>
Cc: akpm@linux-foundation.org, dennis@kernel.org, tj@kernel.org,
	cl@gentwo.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	clrkwllms@kernel.org, rostedt@goodmis.org,
	linux-rt-devel@lists.linux.dev, tim.c.chen@linux.intel.com,
	tianyou.li@intel.com, wangyang.guo@intel.com
Subject: Re: [PATCH] lib/percpu_counter: allow concurrent sums with an rwlock
Message-ID: <20261116073008.PvlRj7Tl@linutronix.de>
References: <20261116015655.2744577-1-jiebin.sun@intel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261116015655.2744577-1-jiebin.sun@intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8AB244000F
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: u44m1b9r6hstanugdg4z5tcpj7durzxa
X-HE-Tag: 1794814215-719193
X-HE-Meta: U2FsdGVkX1+UJxkXM8NAsuxcceS6eb0tfO1+MhPbZS4jPAqIFftx0izV33+CzN5rppwZOnFfZf9Yisvof7lEfLC/RpKdRhuWfT9SW/ZUZUkRO92TS3zEVLEYdVdPvL/XpZvex0PxNzCL33j50dAjkhrG6P67N7TSXuLE5wQJnXJWxVRpqSlwyEkFGkrx6bj8lwrA6+BoDgj4irij4yJheptrUBcO3AqQbHLw6te9l0H6IZStFckfdpvCqYGxace3m+1TfuwqE75O56Tb3r/WsXZ13Yr2UKv2BszIrcYeVuhn1zVYqSZhNdhTLiXLY/N3cQ3DufiYePdX9quUh4PJl4VOW5IeeSSnQlHM9tJDssP7f/3yYyqVCmfc8B9D4Go4BBm3fkg8IMg/2NU1F6zRgG1VTSTZcWs3mdkwtDNjrNiBnhcN/TClv1pg2rqwtIbbo3tJcgqxf4ecBmAlJRMaonc6GQQgRwXikPbtxbvgEeDSJSbyzbSyX1ro+eaExH/TtgJo4LaVprUXL2p2WDIP/q4uwz/zb4qmpTyWNCZwyqdthM9yR4389VwShf8Y0KE5nkSx65X2dgbL4BfYxMJ9CvH9JJ7eirbFnSY6iE9NY0Hrw16c3jaI+o0C1LPyLRbgaVI6j9J/AE+2EYU9rT5aNr6JkVkBTeEh+Y6a4VKeoFf/O/ViCUr57tVGvrPHvYweGjIcJeOS51sj1bNSJ0DOawYjC3tDLehvGpY7K5FZlW+qTNu8iVpYEjcd1hPT+4LFl8l/yBDMrQhvGYwdxe9catRGRYvG9DbmDw/34qU4oGfGNciKVwA0iKV27WqEfx28s57BPYDA8UlpLS6fPdpfb30LKTlrwx7D0hsmmzCjTEb/T7oNFWkX08YRXnnkvNBXJe4FxQPfGF5iuleoQ8z9Kng3tuehaKxR+U/3kX7lWSfGIHWDUaYyB5uJuIkLQrDHjo6Qe3cElwM7a8iyxAU
 YIMBUCWF
 RkQQw/Of8zTkBPuCeEZOgXOgekjSkkrIPZ6Rx3QToFdIIe8n+uvJMxkH3MDBchBp/JqORf4kasC3/5VKKv3Bt9OTkTiPVBrgT7LRKPnrwV+dafzm+IWFcH4jB4eks+01fURMJQTz0AgGEIKuOynIvE+9LFJZDFNn9jQ0fmRl4K2gMXWK+pujAKAIACqeFrbuRJefXiFkywlkOG0T7NNPObAnftzUyLtYE3K4TMlcJpO4mgneteJKAsCEUt+66wldRfhWzX0IkQr5lUAIvPSGHS8WKFuzu0zxMXcMvjZFRaombkVQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-16 09:56:55 [+0800], Jiebin Sun wrote:
> __percpu_counter_sum() holds a raw spinlock while reading the global
> count and per-CPU deltas, serializing concurrent sums of the same
> counter. Since a sum changes neither the global count nor the per-CPU
> deltas, use rwlock_t on !PREEMPT_RT to allow concurrent sums with a
> read lock. Global updates take the write lock. The per-CPU fast path
> remains lockless, so sums keep their existing snapshot semantics.
> 
> stress-ng dentry reaches this path through ext4_statfs():
> 
>   statfs -> ext4_statfs -> __percpu_counter_sum
>          -> native_queued_spin_lock_slowpath
> 
> Keep the raw spinlock on PREEMPT_RT, where rwlock_t can sleep.
> Global counter updates can run in atomic context and must not sleep.
> 
> stress-ng dentry test average throughput change:
> 
>   +------------------------+------------+--------------------+
>   | Case                   | Unit       | Average change (%) |
>   +------------------------+------------+--------------------+
>   | Dentry, 64 workers     | bogo ops/s |             +47.34 |
>   +------------------------+------------+--------------------+
> 
> Dentry ran on ext4 with 64 workers pinned to physical CPUs:
> 
>   stress-ng --dentry 64 --dentries 4096 --timeout 20s
> 
> Suggested-by: Tim Chen <tim.c.chen@linux.intel.com>
> Reviewed-by: Tianyou Li <tianyou.li@intel.com>
> Reviewed-by: Wangyang Guo <wangyang.guo@intel.com>
> Signed-off-by: Jiebin Sun <jiebin.sun@intel.com>

It looks okay from RT point of view. Is this limited to this benchmark
or is there a real workload behind this?

Sebastian

