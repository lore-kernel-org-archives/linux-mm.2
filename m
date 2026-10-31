Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9494E606A323
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 00:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=KJ2P6A/7
Received: by kanga.kvack.org (Postfix)
	id 7C0256B05BA; Fri, 30 Oct 2026 20:47:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 798556B05BB; Fri, 30 Oct 2026 20:47:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ADEF6B05BC; Fri, 30 Oct 2026 20:47:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 45B006B05BA
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 20:47:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BACCEC08E3
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 00:47:49 +0000 (UTC)
X-FDA: 85381083858.25.E841253
Received: from mta0.migadu.com (out-158.mta0.migadu.com [91.218.175.158])
	by imf22.hostedemail.com (Postfix) with ESMTP id CB288C0003
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 00:47:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="KJ2P6A/7";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.158 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793407668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6fhD2qwAKEE8buFW7sdA+FNaQmZ6JEgXK/EobNzcOWg=;
	b=Kz2EVUDmQrpNfzpnUrKI43CQWNpXY5NMDPQZC/iS4i5jNW4kc9GHSDfbCllxaWIMVjTq8K
	+csbOpkpO+OPdwEXWUPI3S6XY4b+AI68KlPNTbyipsPxvLeyg3fPV4ScGr6xSCGyyH+krs
	5IVBYaqikbrJRc0vH+2iKOos8CCB640=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="KJ2P6A/7";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.158 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793407668;
	b=ONkfs5yXo+FuQFeFbqrYk/a4KOnXckRwF9ahS4MrAJkSoFQcp0t8kXPci7C/4JQpgG+rWc
	YenLcxHRtGQgD0fl01uJT74eZKOX/TZBFxMj9hH6naSVBSp0En0F+aSQssrE2/p6EWq4a2
	c6bgw2vpFmPcKI51TOf18UrMV1hdsv4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=kevExdvvHDN/m+BeEtkCzD1iYaSMM0hTbZZ7U+mTrjc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793407666; v=1; x=1794012466;
 b=KJ2P6A/7SyWAEKeg/sUN955X1AFHrN4ldIplQ8ZR+pkcpvFMmfOse4BQcy8rsBauzU9l0oVy
 HHEXfu4WxwfQ1p9dfG5Yc2k4aRN+Iri9cGb26AnVZDdupSdtyzKzXjdG4vC9E1c0E2DY7jnRrx3
 SCex0gAHMSObJvuw2P+V8zZ4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 5b6af64fea02a9fd;
	Sat, 31 Oct 2026 00:47:46 +0000
X-Mizu-Trace-ID: 5b6af64fea02a9fd
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v2 3/5] memcg: use high_work for kernel threads
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261030205418.341214-4-shakeel.butt@linux.dev>
Date: Sat, 31 Oct 2026 08:47:30 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Tejun Heo <tj@kernel.org>,
 Harry Yoo <harry@kernel.org>,
 Meta kernel team <kernel-team@meta.com>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Michal Hocko <mhocko@suse.com>
Content-Transfer-Encoding: 7bit
Message-Id: <D333E657-EFA5-49CE-B7EE-3B89F758BB1E@linux.dev>
References: <20261030205418.341214-1-shakeel.butt@linux.dev>
 <20261030205418.341214-4-shakeel.butt@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Queue-Id: CB288C0003
X-Stat-Signature: xhs193r6kiozz3oqogcujczjjb5xfwau
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793407667-405717
X-HE-Meta: U2FsdGVkX1+kya8UNK92Q/GHbDAEPHEBUQgnSvq7WQVj2m4kW6jV9J9tne9bHEJAxu3FNmLRlImtE3izPlG+Y6tndluPBbawcsW1wXmjc1PA4Ka/A59kPSBqOPrSdgCU6MX98kGZt84g/18MVhhR3ru/rjazYR/r6z2dnR2tbqfPuzfNwE/CdV9A41c6gWlOiUNRw78hNNXdMvgvkwOJHVh78NUKz1M2omzifJYPjCQX4e1WgoXKyDRMBQ1oTswQI/alGAtF4Wdu97vKMWB9ltjblpKecqjvOYDP+yrT6vtdWGcWb3B3VbHSuUJIOQUmQ0V5i1rMu/osr52TP7oL3kx8f7qLvq8bg/PGDdFVy+EXvfzrp6kkXkfDS3woFSpVE7qARlCcVcogp0w2Z2WSeMQbSMnR9vOy515bLtWTkRPrW/viGFl5JjKeh9mtZtfm2ea97vO0/at5t5uDdA/fJ0cEjFlbeJUCIfkpkid634vRbVNVJDPv1SYVF06XLta890qe3mlfJglVINu/9whUfTsdTpGhg48BJzcU+iXcuyVtM4okSaVe0R59I8XIzRBENeH5kGZGg5tA5ahhcQtJlV3LjrRp/BNnjJs1o+BZvQ7c8wSVnJgcfghsI2Tka5F3l7ja2XxuSL9+K4C48AeleJ6ZRCJvyGILsGhrCU5eX9DUfmE3aoxDYf5cfX6VGzSiHSU1wCp17gtmqg0nFkzhfM41jPHeFxZUMY56XyDqvhGeCHd8EZzS3jqG6db+ySrq3M2o7czbfWVHLy4RCtCC0Enj1iAOvDe8L5lVn+irHfK3T3GjfMidPLilWYyhN5E0SeKX/BUHBMj7NCKAuTcGZnlxPlCHIRRTzdWuiJ8H5Y5lB3hlLL6Rl9o9wETVWqnLQTVRiWM9o7c4lz1C8uIVPrg+MKOBdtaz8Gfey691CcDoLxN/I1qBz5QgrrkdjPmwLcMjRf/4iX3HHLAmyMO
 /mOLNiW9
 HLuCKg1dIaOsn5v5MGOvsFfDB3HLt956wFuqCpV3oSA0cyNW47wbpADZI9E0E6S8HR7wtFL9S+l+HDhhbj2XAWTPcAxE89ISGCXDjSn0DPAAh6YNh+1B9Ea+Fi8fzXsfNIdm/Wqk/cH3hj9vs4wAXUMkczGAfP0/tzOONCoKMPdLiRzSkfERhCCYYCPU3Csut6nRWj1gvusP+h57l2tcdO8kQ3/90ZSpKIf562CQm8eLZKkEkcOf0PHsw12AONd6ZiYrMZMdbwR2qbLh4p/JxA55kHQ6gdTtjD2XJt3wK8bNDYjW2ggej+QhW4mpUYXmtGUbwqfRwPjaFW8+H795JLrEpzJcdmfCTgAvWbqUrjpGZdLYn4FnfHZx72P3rrU4V/88dbDAWZkk9LRc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 31, 2026, at 04:54, Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> Kernel threads never return to userspace, so deferred memory.high
> reclaim does not run. Reclaim and throttling during a charge can also
> delay work they do for other tasks.
> 
> Treat kernel threads like interrupts. Queue high_work for the first
> cgroup over memory.high and skip reclaim and throttling in the charging
> thread.
> 
> User workers created by create_io_thread() and vhost_task_create() keep
> their current behavior. Vhost kernel threads use the new path, even when
> they borrow the owner's mm.
> 
> The worker requests a fixed batch of pages each time. A fast allocator
> can keep usage well above memory.high. Kernel threads also skip
> memory.swap.high throttling and its high-event reporting. The memory.max
> and memory.swap.max checks stay the same.
> 
> Suggested-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Acked-by: Michal Hocko <mhocko@suse.com>

Acked-by: Muchun Song <muchun.song@linux.dev>

THanks.


