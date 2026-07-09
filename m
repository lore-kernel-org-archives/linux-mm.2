Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B23FC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 09:13:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BA686B008A; Thu,  9 Jul 2026 05:13:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 292226B008C; Thu,  9 Jul 2026 05:13:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1826D6B0092; Thu,  9 Jul 2026 05:13:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E9E9A6B008A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 05:13:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5F811C2894
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:13:21 +0000 (UTC)
X-FDA: 84968674602.17.31E5B0B
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf21.hostedemail.com (Postfix) with ESMTP id BC5711C0002
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:13:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=guIrbCG2;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=1FqZ4Glp;
	spf=pass (imf21.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783588399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oFkhovupFuB+0rzcV3/Rh8Yfa4/ndsw3Kaki+DTqEk0=;
	b=CN8jHwyg00zGWNjqHwO+LqdnzwSp2adzFgQgBuPUnnR9vH1uMdpL2F3CgfCeehTAd9Uw7j
	ZqclJDUa0nl0FOAs+pztx9Pnv+vA6vnR1LgcT10jq4rV92B9c3HTV4+SAhqVGs3urLmE2+
	lm+7r7nnvOJzjxS1H/AsSu0oeJXGgO4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=guIrbCG2;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=1FqZ4Glp;
	spf=pass (imf21.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783588399;
	b=gVz449O23S4kkdWbsxFbkh9Nk6CPVmi/pr/nVapwplZiw2tSADggWLXSoY151GBYpj6jrK
	DzOTibD11ceuIxW8N+FLk7SByAuqyxvs69c+VMkLPI4DMIR2Lb7zCslk/UNHfYwJRt/XWr
	1QX8R4iatGkTQDzNQszp5/gSFF/2nzY=
Date: Thu, 9 Jul 2026 11:13:16 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1783588398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oFkhovupFuB+0rzcV3/Rh8Yfa4/ndsw3Kaki+DTqEk0=;
	b=guIrbCG2tFjNemmIWTWaeYkEEVw96TgbMZ/9sp+L9Zu4pxOJuXjszNyLZk5UCalt1MZeFk
	J4EUN+jbwE7bJEVdDFjrpygx7YtwM8CDq7w1Z3deoFVIUMCbWioPu8pBqB792z8DmyzX+8
	eZBeGE80HL4zj+f8UIcazq9FS3G70IvCkWxkoY37YrTX9yl33P0e01MqoGjfcZaoekXiC4
	4kIGWf9nlf8H5YCgNR66/sUxWEa/c0K2Rp77uYnpMPk71hEcBe3XJVXLPEezX4hSlCHwwA
	dBJSbO/YG4q/vIKPNsT1gWZFNwqeZD5VfwqUTZtzxi1fTUDVXrrSMTh9v8pRrA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1783588398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oFkhovupFuB+0rzcV3/Rh8Yfa4/ndsw3Kaki+DTqEk0=;
	b=1FqZ4GlpMtrrBtqzEJlHdoI4seB5yz2jzvAcIEnwg8F9aO5ZT07ZTCZyXqq5nTBv7j96/e
	bB4kfk2g2ag5sACw==
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
Subject: Re: [PATCH v2 4/4] mm/mlock: migrate folios out of CMA when mlocking
 a range
Message-ID: <20260709091316.TFgtBZlE@linutronix.de>
References: <20260707125925.3725177-1-chenwandun1@gmail.com>
 <20260707125925.3725177-5-chenwandun1@gmail.com>
 <ak0OZKzapUefmA3v@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ak0OZKzapUefmA3v@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BC5711C0002
X-Stat-Signature: cjst5dcwbtgin74fhbym16zn61odos1r
X-HE-Tag: 1783588399-841957
X-HE-Meta: U2FsdGVkX1+5xmmqWEnwgH/JO1Cq28aJdSvZtXUjIUnGWiemHoRQE9E6xRcMQ2g3s4rvRPfQODBk+QQmwy/vLZbD0SAQ5zxEt9F3QzC5DUdvPq5es50SWKuvF6fXWsrARMkvRiUd+KidD6rCW9MXGbuqlIvNZ9aqyjRWUeDNKrO+IF7CjddPJuBMRAA8jp63zwEE6Z9l5h52YaqPJWWvIvWCKuqNGpRYBHne9ewqFjZ72hzIN7LjUE7H3DTWUYnIQP46/H84piBFXuW/8UUoWnxpgbPQjrx/pQeWNtnIToyVR2qy4V4stM+/2K57LlCa6Sv8gN2MAfnLImrVCtSwTRnxNY0UhjyrLJQ8JTI31binxOHwM30BnHcNRm4jLLGZ2ANFsdqd0J0aV7wU0MnbqPZ/MLJ6WX666XsLdXKUMiksszBGm2T6nO1teiRNi2w6JzGwn5mhd4UuB9/JL+zMRQXp+vM+tuvRr3ca/11bscF85kTltrytCdTVJCiK+qGkmp4WEf2/8lMEqyP+J++TG5oJzJJRjZbbM9AETN1TNIN8cpqlQJu7Ynizp9BxWxsWvKQ+qiGXF04U4e6iNZrn6O5X2Jb5gvA/cbpLo3ypr5nyjlOn+5xxAfz8cVtnKOCM2rp3SQtURU3g2XUYT2RlDnQCCgo+jgxK6nTdNONs9pIr1pNqQfNVyDKJLj5XPHegG/5EEIJDDRzGy90rn2IvWzZdsxxTWfh0Y07jANSMeg3xa9NVPjK/4EwL5rtehRKdwKOqw1P5iBo43MbzLDxGRLVlUjrAiIitEFQblHx0qD6T4IHDXDGfgbIC4yP3NMZsaw5BHiRSS5+pmsid1WsaQ0CPfHk3aCBroLCdvBiLjCsIlz4J8VmwsDN+vm62H3ieMBwIu+W5+ybg1QsKYfb9oPEtlIUeSwwmONWddfIfs8ci5blgwY9YQABWN5e4Z3JUPlDMv/mMtNFB3tg6doi
 LIJWZXlz
 mmNmDjdpgHGuFd+k3kSMCW8X7uwedZrc9s21nzGXcFHMnCYTqDfwLCVPsuXjQtewjp/HajCvpgRZvymKtuwB/uouXgiUgQWm0UMFeDuz+YdoYjo7f70Bh+CgXM7ZLSjs3NwJQ8b2qPVcHYPDC1b1+C9TAEUJqD9Q5d+qwwvvXW8FYKI2SICnCi4sXeCIugTUJn1wqAO4xrZlCvygyGuQYLCY91lk7vfc1M/Lo41XrkbTwPVzkymbF9sW04LSeGfqWnmzyPoHOXLemgvcwC3pAc4s34pD1Zv49pNFXyOYy/NuFaG6XqiBNu9hU5TZA/QdtlVDdGtSMOogYyTs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-07 15:54:57 [+0100], Lorenzo Stoakes wrote:
> On Tue, Jul 07, 2026 at 08:59:25PM +0800, Wandun Chen wrote:
> > From: Wandun Chen <chenwandun@lixiang.com>
> >
> > The region covered by mlock[all] may contain CMA pages. cma_alloc installs
> > migration entries in the page table, if a memory access occurs at this
> > point, it must wait for the migration to complete, which may cause
> > latency spikes on the RT kernels.
> >
> > Try to move the migration cost into the mlock[all] caller, which is
> > typically a setup path. So reduce the chance of latency spikes on RT
> > kernels by migrating the currently mapped CMA pages out of CMA region.
> 
> 'reduce the chances of latency' so do you have any data to back this invasive
> change or not?

The application gets pages assigned which belong a CMA area. If the
pages are in need by the CMA then those pages are replaced with other
pages during a migration phase. Since there is no guarantee how long
this will take and is also subject to general scheduling in the system
it will be measurable and painful once hit.

> And for RT, but nothing in here at all checks for RT? You're using this
> compaction sysctl as an RT check somehow? That's gross.

The man-page for mlock says that it guarantees to stay in RAM and/ or
preventing to be moved to swap area. I would however argue that
replacing physical pages in the background should fall under this since
the application can't access them and is blocked while trying. The notes
section (in the man-page) lists "real-time applications" and
"deterministic timing".  Therefore I think it makes sense to do this
unconditionally for mlock areas regardless of the sysctl knob.
Security related application probably only care that their memory does
not hit the swap area and probably wouldn't mind 10ms delay.

> This doesn't feel like the right solution.

Sebastian

