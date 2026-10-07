Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4297DCA5FFC
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 17:15:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 131846B0088; Wed,  7 Oct 2026 13:15:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E3396B008C; Wed,  7 Oct 2026 13:15:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3AA76B0092; Wed,  7 Oct 2026 13:15:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA99C6B0088
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 13:15:36 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5087BA73B3
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 17:15:36 +0000 (UTC)
X-FDA: 85296481872.14.C5B21D6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2588DA000E
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 17:15:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BqcVsecx;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791393333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IKPv1AXkbOVrLzSJbysUwydgPgY8ZEOPRGlNsK+wMds=;
	b=F6JO0SfGoPlkD4869uS1sjfovTCvbkWPxFddpCkXPJpWOHPlNAa8mWlnTrRlXwGZm8vaJN
	ZSxKdSOEYRBBLqEr61yGSpPXQUmWTkJMOCWZ4iTLHGB9U/n3+Luekp9XMZpwVIdqTnvGiB
	Y/62w5SgvwJ5rPDniCPz7bKBwzhrK3g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791393333;
	b=0yRNoaWgcxlzaH0IdLOUcW4+mIstoQketyB08iicrBUdPFJ+x5Pth938EhVzM2fR5Hpvb6
	7PQZmZDy1zqgHGo1pLw0h0xNtK0u+58Pj5WYTIKB9tG28Rdq86AT2ivSqUp9pexkfYvDmZ
	9+eNGW0aVvhzNQvM97Knp41urh1ysIA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BqcVsecx;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8DF24601FF;
	Wed,  7 Oct 2026 17:15:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0EB31F000FF;
	Wed,  7 Oct 2026 17:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791393332;
	bh=IKPv1AXkbOVrLzSJbysUwydgPgY8ZEOPRGlNsK+wMds=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BqcVsecxmXNy4fg5mqGk7N0ypwHtyajS81nsbXd5i2Wu2JIBduH8S6XXVmRPLmT3g
	 HKoSujXLfVVRD73FwlUyDSd4AOVs1oJDfsy3KwTF1RdwfXDRYgxe1P0uLaXkRlJ3jE
	 lzsYtMv8NcvuHKlhWPA/VZFDRk5O4/3MfNIfxYhfUSD+9c3plZRiyFJCkjExVJYfsr
	 IpcQPdJRGzG0qB3tzsOqSxtGfjOa/QC9cwlOkWIZvd046tDwLJDuGuQg25VISH2BPO
	 g33ELEp6mj95IliGKNd/jRqTK5yLbX8wtTIqd2/p8jAe0hjq/rZ0pfdOEMZpRX8rlR
	 YMjMUcStMfhQg==
Date: Wed, 7 Oct 2026 19:15:29 +0200
From: Harry Yoo <harry@kernel.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Stevens <stevensd@google.com>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Shuah Khan <shuah@kernel.org>, Amery Hung <ameryhung@gmail.com>, 
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/3] locking, mm: Add atomic allocator trylocks on
 RT
Message-ID: <asZ8jmWNoGk5tYce@thinkpad>
References: <20261005070625.8871-1-kmehltretter@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261005070625.8871-1-kmehltretter@gmail.com>
X-Rspamd-Queue-Id: 2588DA000E
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: qjuwojubdbxaq63ntn8w7q7bpcbbsqfr
X-HE-Tag: 1791393332-625848
X-HE-Meta: U2FsdGVkX1+ZQBhsGIgoGRELaQnYBsvFJOzvz7utaz852yGVKjHKjwGj+H3pCnxxh6+F3/SZzkgQECqN4orDjaRBJ2BivOas3S1MfMVJzy7eFzaQ+vzxACxYMFeu4cD69/S0qLfDJMW1ln9X1AqOa6xl4NAnDbqsdh27/9ABZQHj8S+WPOWi6Ngfv9pHx4KeIVUAfw6U4LxvYwaOiQdiroA7xmGjiaxWOYoHM0R51E/x6HD/gC0KGrSTSmC+if4BdNr++1/Z9apb4G9tAaG1J7gLku0mfypL92Ak4SLRbF1PaL99DzFRCyYnRqLqRoT43UVFrZd+MQiQX0ik+ZV1p/glQw63fVrWrb5RJxfnL7cA8hqyXTM3y/QuKku4/C8PFfvcqSYZ17murRcIVzMeK3NrfDidTgHIsySWhB1WB+n6MuqD0wgor1RW+5EkPT0mXFPHfYtRJGknbN+Dra1rfLl1ORVxM2QRurJ0RBJf8tXnfFT7LZ9dQHQPfcyyh5Ttn6By8roKP/2yRudttSvwHTDj3uAndN82nsFGWEpyXOd4nCMsThdhytnQX3LP/CzbyMy8JYTVkjVosU7IC8bW/Ul9ac751QhyKpaPC26lnTtWgXcwibOH6So4MqXqdWDF44vG34mBsaKykAxKGVIpuW6kiLN1cjR/1lwCUxfTdABX7MFvUSGL3yyNNCoyfg1E75al6TE/8Z0pAWKEMTFiF6bFo8fD7WrvYOUIgchkeYR8O5CoZPkRc9Y2Gykmqx9bWt4aF0J4oLP5DF3zTr+aWLmtydX661kq2y2p5Wvzxlit3aof+C88A/2CctNLVZsfEk9ixldEac/yOXRsA8RWa0lIsZfNGmSncvkGb9Z3oZhEOuKVXdI8GczqFEK9Asaf/5pV5/UO3knxzlBSu5+jmWji5TfJwKpULWNx+cg9BwC637vJ7qnO6mMADpm4l7Dwu0p/90wfWHuZ4wlQao6
 gN9xm0cD
 OIBcXaSZ/DDuzdprufcXJ96VN3lw7V0L+nEy3eK0z+OA9xm78/3c2VDuXqFb3lXZiOTD3/V6p06j+1szN7+ZfxYb6ZR5zoVXtPaHjyyPtw4jPzKNNXxAKprYnGHDmfPGVV4riS+TT4LaCEvKxASVd5lNeYHhmswZdLXtB2mX/EyEtEFfSAh3RzvWvFYU+h2JBxZNd2GihHaz6qgeJcL6UQsgiyG0RAaFCHvNnvrOmdV6OQ12WGwJ8b6pfJWjvo+RTyzV2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 05, 2026 at 09:06:22AM +0200, Karl Mehltretter wrote:
> On PREEMPT_RT, a BPF task-storage program attached to sched_waking
> can deadlock when kmalloc_nolock() obtains an rtmutex-backed allocator
> spinlock while try_to_wake_up() holds p->pi_lock. Releasing the allocator
> lock can enter priority-inheritance or wakeup code and re-enter scheduler
> locking.
> 
> The first RFC [1] rejected every non-preemptible caller. That prevents the
> deadlock, but it also rejects BPF arena allocation and faults under the
> arena's ordinary raw lock.
> 
> This RFC instead adds an atomic owner state for bounded PREEMPT_RT spinlock
> trylocks. Atomic acquisition succeeds only from the completely free state.

Please don't skip discussion stage and jump into submitting a very
intrusive change across locking and mm, assisted by LLM? :/

I don't think attempts to tackle this problem will make progress without
discussing and getting buy-in from (PREEMPT_RT) locking folks.

> A regular waiter sets HAS_WAITERS before waiting, which prevents a later
> atomic owner from barging. Atomic release preserves HAS_WAITERS and does
> not enter priority inheritance or wake a task. Preemption and local
> interrupts remain disabled for the atomic-owner section.

-- 
Cheers,
Harry / Hyeonggon

