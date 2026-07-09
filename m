Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3607AC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 08:42:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 311F66B0088; Thu,  9 Jul 2026 04:42:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C0A06B008A; Thu,  9 Jul 2026 04:42:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B3706B008C; Thu,  9 Jul 2026 04:42:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E74946B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 04:42:52 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7E80B1690E6
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:42:52 +0000 (UTC)
X-FDA: 84968597784.22.250C951
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf06.hostedemail.com (Postfix) with ESMTP id C4F71180002
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:42:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=NeAcRb2a;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=QeEzWspH;
	spf=pass (imf06.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783586570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lDsVqicYydxGz5kLXUXwm+1P85L+HsP2ziC8koU12BY=;
	b=0sqq3IpfHnCdzYa/w3DvLs8sz5Guv8EGD3ALQ9LZHc7/69QnshbNn12xxe61E1rEQVUn7Q
	7+YQvMMJDMkGnXgFb373LheMlllnhPwVBkd3jKuawtIzVkWD7SxAql95yrepuMGT5vLaOb
	o49FBGg6CM0yBZVKyaMk0PQkCZ5afQI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=NeAcRb2a;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=QeEzWspH;
	spf=pass (imf06.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783586570;
	b=ZBgPuNtEkdd3Fno8hGEwP+kO+CwEpoW0fUGqtN2PApUAgRR3pZcIEVq6FDJUzE+e2Shk8h
	wcgexljSz4T8ZTuueo8SW8aF6SdT3hixRrhPHnZBfsZ3QLYbz1/linU0JVwznGNHOfI0Jt
	f9c6u0SaYKhgDHWvLZYLiy8r5rpBxak=
Date: Thu, 9 Jul 2026 10:42:47 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1783586569;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lDsVqicYydxGz5kLXUXwm+1P85L+HsP2ziC8koU12BY=;
	b=NeAcRb2aqfvOi9Tg2p5Ko6EuzAemMafFzO4tSWsKwx6vN8wmcinC9HQzNRvprKbxrMfO1U
	dS5HL/KEaEYvC23p1ZAS7driQxJeQPOmPrldEx1xyrDszY5KsDuC1Dl5pA7Bsu0HqaVPip
	nRFvPBaEGAyvpTsFfiexw788G7e+7CKPJwK+biLck8waiaFQ6QARrNQt1jpbBAQuA2YDKA
	V+Fc0XqrH9UIF0paXyszDeGQn1e4fd/Y2OJ8iZulvYOlAkWQ7RjiMaStCpRR1tce+AEJsD
	gZJGnVPdVUlR+IubjB9tzfJrRUTxzBaC7fTXEsRiJyfES6lQC5QvmoDqOdqhhw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1783586569;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lDsVqicYydxGz5kLXUXwm+1P85L+HsP2ziC8koU12BY=;
	b=QeEzWspHT3ZNdkKlORK27/vaa4kXhq00DjL8vtQY+ZIFmJGbtl3HzNUT0/8WsQg0fOINyo
	+cjNjy3cB2KsyiAQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Wandun Chen <chenwandun1@gmail.com>, vbabka@kernel.org,
	david@kernel.org, rostedt@goodmis.org, mhiramat@kernel.org,
	Alexander.Krabler@kuka.com, hughd@google.com, fvdl@google.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	akpm@linux-foundation.org, surenb@google.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	riel@surriel.com, liam@infradead.org, harry@kernel.org,
	jannh@google.com, lance.yang@linux.dev,
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	pfalcato@suse.de
Subject: Re: [PATCH v2 2/4] mm/mlock: wait for migration to finish when
 mlocking a folio
Message-ID: <20260709084247.HJNrqVk8@linutronix.de>
References: <20260707125925.3725177-1-chenwandun1@gmail.com>
 <20260707125925.3725177-3-chenwandun1@gmail.com>
 <ak0C-DP_1ZrTVSLj@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ak0C-DP_1ZrTVSLj@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C4F71180002
X-Stat-Signature: nhbdcbj9y5h48diygimdo6wehethwhsx
X-HE-Tag: 1783586570-250931
X-HE-Meta: U2FsdGVkX1/nBawegPl1yVTpwzCxR+zcXfys2tbxFSBNYrQWblzKLYWMep8FJGaxy2GR+rb2ODg1a/iRXbW9NChp3eUAZo7QfH7yFkWsCWvDY0WuoZfxvsuuRaBPM1m1FfB0Zf+gjtuufXOrMAn9FwQGazxe8ys3BZqHSbnOPMB2WBW2/WoEoyVjZBYMN9hMrwCBzwFrR4vgKLf1saMbLkEh23ylO8R/dIjYQkDFf+bTg7B8C/r9p7JYQaWtiZ5BcZw092KeFdU6kIaApVDwJApqT63wmEtfKD/9Qd7RGsIvKuAPL5akxZeEjgd3YULhp2GsRdf03P73UBguME7C7FHP1K6KqY9xEfdECjenakxmMLCp3thQsIqIphg+ujnF+2gtPoLRQV0/reyDIz0DiCY9mJyeTf/Ks63EFcKmmANrEp3P+7eP6mytTdG+C4ZIaU/fTYrM/bE5XPKNavwgqUyy9zAv0DEtQ5Df0RieCfTXBCjjTq93WPdqUwRqpf463rYoklqW4NiK/Tnl9usHdBjh9t/aEafSjwm2Rt+mqWvMbxxt/dHzKIOQ7iL6pbBoZhaO6HS+UGhUVzS0DHQGIhz/UuTZlgtIcWIQrmT41rRTQmZtag+CvyHgY7tguZAA+gXdft7OEKjnMFuhEiwAq3MSyGfWxZmJR83Ju9UyOXEaBo3x2PznWrXR3n3v3n/GrQ0fPoYylI6vYhRMEEzS9yCWEqhOWx7+4u71Gqfula2D+6d0gpIw5km8vnRnXVGS9ZtTIJsF6/YMkZSBviXpl9y3eE2l40QUoC8eFy3RvKPgxhHfvq7ai9YQO416tO//W6pi9e2geiHKV0SevbiM51W7RO1hHcIpToA5HxqcnjSOg7B+pfU6hhvLosHkylEGjZJZSAm/M5xRM8Ev2ow2+YkxfHT5AFZw80CVguohR65MZm/zzyNJw8caoaXAki/q6xwfbuMf12+AyvBnNQi
 AGHuqO4m
 MRi/yHkcXYjpb5Egtkk04r74IoAWZCW/3VeD5EDMCOhut84m/7SwnW+lFX9jsUIMxLz9FYaO4713DLKQaiqezCiQ5GokRGHScJLZAuowSzRl/yiEIrW3FKOn3PO+BkSUJhbUNsd/JM9XzoM8J55UZWuuvPA4znRK64Qc96MgZ5J/LLpE5SSCdMtw8leG2Ai4hB861yjh6qcVWvg0G9jIUjqSMwCz4BtCCZ8heINmMbYyQ+erjCjVeveWhSAiUlk5b2ezY6eoyJzRa1zOcLtZiJ0UQ9rmAlrqnG7fLGJpuKEuIODulL6LK0PDgpq0K4dlyq5F0dBsdeejSE/w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-07 15:33:32 [+0100], Lorenzo Stoakes wrote:
> On Tue, Jul 07, 2026 at 08:59:23PM +0800, Wandun Chen wrote:
> > From: Wandun Chen <chenwandun@lixiang.com>
> >
> > In RT kernels, sysctl_compact_unevictable_allowed is false by default,
> > when the mlock/mlockall system call try to lock all the present page,
> > the mlock_pte_range function skips non-present entries. If these
> > non-present entries are migration entries, and the migration is not
> > guaranteed to have completed before the mlock/mlockall, it may result
> > in a page fault on subsequent access, which then waits for the
> > migration to finish, causing spike latency in RT kernels.
> 
> Is this really noticable and measurable?

You want to avoid page faults like this which is why you do mlock in the
first place.
If the thread has a RT priority and it blocks here then other RT threads
will be scheduled and your migration thread, which will resolve this, is
SCHED_OTHER and the last one in the line. Assuming that thread has a 1ms
cycle/ deadline then it will likely miss it.

> I suppose not too many ranges should be mock

Sebastian

