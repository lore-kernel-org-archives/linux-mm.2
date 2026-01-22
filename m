Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25E61C44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 07:59:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 654DB6B0103; Thu, 22 Jan 2026 02:59:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 615DF6B0105; Thu, 22 Jan 2026 02:59:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EDC36B0106; Thu, 22 Jan 2026 02:59:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3A7386B0103
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 02:59:12 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EBB18D2016
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 07:59:11 +0000 (UTC)
X-FDA: 84358849302.11.EF78B0C
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3B04C8000B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 07:59:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=GCqhRVX7;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="i0lI2TW/";
	spf=pass (imf02.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769068750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fZSlgHPlUt8ZbdPEXgaq8iH3gYM6F+jgddriVVcpP9M=;
	b=qdPBKCDnQhUJLR0zXg+18+vmpZLnKpB8Ktu6JVRHcFk3CztHoYXpjYhxJOHH543FJG19U6
	VZsK0MZRoQoL71324lHnM60mMWhiNMd/04q00y3b+9IUjpHpmUQNEdiPHu2XKGv+XMso0g
	mnMR36IXyFPgg+T2SXmCa6IgdjJS3YU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=GCqhRVX7;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="i0lI2TW/";
	spf=pass (imf02.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769068750; a=rsa-sha256;
	cv=none;
	b=fYdZo3p4tAWfeBafKHobGqN3cUVY0/9UeRVGxTJKB/j9P68FjWjjlk3BpebRWH6XT78xHF
	R5QIKY/2qoS5/iNUmNUHrfCkBeNhgu+4YWcpUcCu4zLZVBgQ2Sb8MeAXv9TUr08k0f7hBq
	wzl+fi9VWqzG3+yHsKOZy3AAOhDztoA=
Date: Thu, 22 Jan 2026 08:59:07 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1769068748;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fZSlgHPlUt8ZbdPEXgaq8iH3gYM6F+jgddriVVcpP9M=;
	b=GCqhRVX75TvgW5UsGMvjVD0w730ylwgVyfHA/my4xaEmvj8j2iZK2QPru8hiGjIALmOnWP
	aSavGkWsKBiFE3ax+a1dcvaRXe5O7QN+yLGsX9ecJiEFJpKeQEvhY/7IQF2MNCu1dFLfDh
	muCtW0+1PK7t8a4fmsI8YmsdMJRi1z7zed1NFbVJyjdw1ujCWNc/yxx3jqxkiUgDHtrvCd
	W1ffkxZGaE5Ok1A0s1ephY5ZzlyWeNpIUJHeFulMLTqnbB+onVrOXLJBxIGUYndWiA91bg
	8b6fnTGBPT0tadbs8dU6QGIZt+L6+Q7jCQyFjI3ZmxJsfzGEb3VZo5+kYqL2ZQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1769068748;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fZSlgHPlUt8ZbdPEXgaq8iH3gYM6F+jgddriVVcpP9M=;
	b=i0lI2TW/S6yXuSvuYhIcgQVVnQ9xxkHns1J3rHm3oRE+uQ3NDZuuQNT/SbjfYhF8LAFZ2o
	meDoA62Jwvz9TfAg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Waiman Long <longman@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH v2] mm/mm_init: Don't call cond_resched() in
 deferred_init_memmap_chunk() if rcu_preempt_depth() set
Message-ID: <20260122075907.45LUOUoP@linutronix.de>
References: <20260122034017.505589-1-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260122034017.505589-1-longman@redhat.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: km9wdxtjt83x1tf339ehidj5t3d1r19r
X-Rspam-User: 
X-Rspamd-Queue-Id: 3B04C8000B
X-HE-Tag: 1769068750-842756
X-HE-Meta: U2FsdGVkX18anYc/3ISiJp+cpWF3hStGMNFwhUgl80MiJL/DBE8fd2oPYYTNALbU7k6Szdh+9BJFw6dS5ON7oergQW2xadD6MQu+i+X5/6l6qQ0jxq+YktDAHhyfB79tqm6u1Fm1fE5/xlgsbJaG0JXfExMIhl5DiwWXWBS36wfgbX/2l1pTIft9l9XoQmW8jUeOO4Qw2uulT2OwGqrbjY19mfxNcJaO7FYmbzICLcYhsj4pSgJZFG4dMq31kmfxtP8krzNU197ub/KAbIU6LfQzpD6T3VSBwnseAgOCHkOWvvyAt7GRUI7ygZAqUHDvTc79cUpBmHTXZY818YRRK3WtVHXiDExuDhBIzjng3Y26OTgpsUp0RCpJ1Vq8wx9GKfOrkjeHGJBIXYT+0oQevUTezpvX/IMB9hGtbVcd3TYLoHXitFlGo/lmV900NZoF3bJ6jUGV2hp37zQ69Nf8Y+ef2zGtlt0qt/+BLcgL1gEAGltAFqhjgAzkoOBDXBwnvJoMhArzvP/G7iEvYrX4k3GoTgm6Bnw7nc+YqZ4lZg6kB9CMPmo9AeIkiQLvATfVJjFU0a9dobRzAmHy6rSIB8V+9HDGms6zmXI32I/Jl9r2HUjA+PUw9kZeDvj/AENmXDX/CzFQHS96CvVj9qyd3zJKqUl5A0h3Ko4y4EKIV0Xy99uKU3/wAXvcqqHh7ytBx1J8Vp9BSy3PYXr2xqlEi2SXnogv3GD5OsGntzpZdpd1o6//8moM+5FIksi4PR2wsKJv5tGVQ3akjoeM9pt5SoVS9T3xzcpNjXDNHxkFscz7K3FUigq8t1Vm4sQTYNVfZGmO7J6/1WQZPKtLuqAhThlFGwyZ0UEWKQYQYLTIdksNVg7kisu/dpfj/hcUUAX2E0snfGzhyoCa1ufAXaTyMGdxwKb/FcPr9WbMH5hu8FZ3hARyfbCBGpL633jF8llhMBBBsQUoZGkQL6t5DVF
 Pz/JTvKa
 nEIs703S42CAcS8qlLJ98ErdIXcq3C+WUvSH8NnjYLFdA1hujItlfalBcSSuUbXuyZ1Wy4GleMNdNXycdyzjKoJOpdqj1GKxoyq/KbEBUP4kjQIdiE/P1CNOa+9RQLFa3NerM9i8ZQra+/Skr14Q3uxIclU9dlzps7jaHmQSYV0O6wl/PcHn4kVHlEXMGXQv6nnbORmY0XE8B+P3RZJsH02KR9cUmQCMTli57Nkz+a/5qY1Yq7fqecGtjtWoShQDLNhh7uF/E8UXBbjnGABdla6KXKKn5P5mfhr12YhqqP9eI+T2x+RnL3V1PZGw3l6GW+mmITbaby9wn0LgwibPoMuTqqw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-21 22:40:17 [-0500], Waiman Long wrote:
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -2085,7 +2086,12 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
>  
>  			spfn = chunk_end;
>  
> -			if (irqs_disabled())
> +			/*
> +			 * pgdat_resize_lock() only disables irqs in non-RT
> +			 * kernels but implies rcu_read_lock() in a PREEMPT_RT
> +			 * kernel.
> +			 */
> +			if (irqs_disabled() || rcu_preempt_depth())
>  				touch_nmi_watchdog();
>  			else
>  				cond_resched();

What about (as suggested in the previous mail)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index fc2a6f1e518f1..0b283fd48b282 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2059,7 +2059,7 @@ static unsigned long __init deferred_init_pages(struct zone *zone,
  */
 static unsigned long __init
 deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
-			   struct zone *zone)
+			   struct zone *zone, bool may_schedule)
 {
 	int nid = zone_to_nid(zone);
 	unsigned long nr_pages = 0;
@@ -2085,10 +2085,10 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
 
 			spfn = chunk_end;
 
-			if (irqs_disabled())
-				touch_nmi_watchdog();
-			else
+			if (may_schedule)
 				cond_resched();
+			else
+				touch_nmi_watchdog();
 		}
 	}
 
@@ -2101,7 +2101,7 @@ deferred_init_memmap_job(unsigned long start_pfn, unsigned long end_pfn,
 {
 	struct zone *zone = arg;
 
-	deferred_init_memmap_chunk(start_pfn, end_pfn, zone);
+	deferred_init_memmap_chunk(start_pfn, end_pfn, zone, true);
 }
 
 static unsigned int __init
@@ -2216,7 +2216,7 @@ bool __init deferred_grow_zone(struct zone *zone, unsigned int order)
 	for (spfn = first_deferred_pfn, epfn = SECTION_ALIGN_UP(spfn + 1);
 	     nr_pages < nr_pages_needed && spfn < zone_end_pfn(zone);
 	     spfn = epfn, epfn += PAGES_PER_SECTION) {
-		nr_pages += deferred_init_memmap_chunk(spfn, epfn, zone);
+		nr_pages += deferred_init_memmap_chunk(spfn, epfn, zone, false);
 	}
 
 	/*


Sebastian

