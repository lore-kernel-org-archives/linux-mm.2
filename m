Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE130606A324
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 20:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=kNHzWUKh
Received: by kanga.kvack.org (Postfix)
	id AF4776B07B0; Wed, 21 Oct 2026 16:48:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACC706B07B2; Wed, 21 Oct 2026 16:48:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0A666B07B3; Wed, 21 Oct 2026 16:48:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7E8606B07B0
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:48:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 603AAA06C1
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:48:27 +0000 (UTC)
X-FDA: 85347821454.12.4470C67
Received: from mta0.migadu.com (out-160.mta0.migadu.com [91.218.175.160])
	by imf28.hostedemail.com (Postfix) with ESMTP id 49297C0006
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:48:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kNHzWUKh;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.160 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792615705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6rUMDLFXufXDaESzYj+9ZndTGVI79zhxIDwrHIe4u+k=;
	b=LdoqgzxkMhRz454+1H2TymZB+yW1gooag8DPiJa2XUYjAXGkS3LuV9UAoLCnD40j58LT9w
	4CLrTSwBFc72IL7PMdAx3hdETLSDCE4fq/NUOw53TW3RVleb3ukCUvWNph6vf6R57cGAQw
	M98rNZxIFXUB8TdyOXA+QdD4JvWwEL8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kNHzWUKh;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.160 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792615705;
	b=6mLaGyGkwIUHx3VYhu3FEp++YGHwocUlHAmfnY2lTjQJTC+53VyPCNf0v2j85H5VHqXftO
	dMofLBWIFcZCXKzKuYQlcb37UMX3eOCz3uso7P3QDrokB1IkM90T3fwo6hm2iwBoVj1e8d
	A0XLi07SQHJp7D+biumhPFsKFOVz76w=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=+AiOmE1TdqOARmJDv1cMb8HWamB96s35l1LjYS9KVD8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792615704; v=1; x=1793220504;
 b=kNHzWUKhUT6nfr8AUMoVmehPg7pSMDXUvzGPCSWVkfW8+8hj3iBIwTl5vLKnjA4HooFqZjGN
 o27gI6gi9HqO6BHsWSGUz/6EJ33QNGdawWOPFRDKLQYCV6LTVbtujHTuvam0Vr89bh+DCQKT8UI
 w/4Ntz3+6lziqgcxX8gYUTsU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 16fb233232d2ba21;
	Wed, 21 Oct 2026 20:48:23 +0000
X-Mizu-Trace-ID: 16fb233232d2ba21
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Chris Down <chris@chrisdown.name>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH] mm/page_counter: use WRITE_ONCE() for emin/elow when parent is the root
Date: Wed, 21 Oct 2026 13:48:18 -0700
Message-ID: <20261021204818.3431099-1-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 49297C0006
X-Stat-Signature: bujaohz31u75gn5i5frjn3k4s99b9wx7
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792615705-189527
X-HE-Meta: U2FsdGVkX19eBwrJkyOxHnaU2b+8I/0URJXEF7IbU8HNDx+uMHt5DhyXC6auhB4LIkok0E0qGIX2W/ZUNzLeExQU92I6vK+GoNh79wN9w3ExE+uCDepdTNNbBCer5MT7eSvJlG6AvKF96ffvB7NUojqjP0tJ4jlGDsZvb8uYPcg4SkZJB8tMakmQT/+hf61UsVYYYpeRakAEsi+cmqRascT4LRZN1LQcN6tDbltv6+joHpPEfbUfOosLT9vvS7Gkq9ddB+lvE3CcO74ORjRoox5IqLT2O9qw40O370E/9XVTCWEzIuWCgqqrinBCoKY7YFFkiumfy9uKofwDuSdL/g/uYr6mf2uRvf8KxqhjZH8lLgIoOYP35skVNS9BlauwtlvCi9YRyIuUJ6UeLY6m6lPyJr6KWPp+BLQIBbbAsAjqnUBW1UYU5TpdWCjuXO2wmaAmYpJbvBR4kjeQOM/FEJ/vzRnc8N7YpGbmqCKYZqwgQexMezkvHEV4atUUUZWokYnDjMjEfAeHa9z9rMrfgzceEXcaeDwprOpksTFJKihcS+3nRkXq6DpBICUe7iO44IS8zlLQmT0BTqC/TtqtVZxJq07LFxW+zT95VTaJQEMztU23RPfOu9ht3InV021hxTAZ2buvk4ZuFzEbZ9423RElskKMZTTtVzSCOz8DS0bNZdH/2pbM4e7d09Eil6IqOdHm/d9r1LlXTFAwuWdQYg5n5KEKHlxjHJ1Kf6mdRF/w69wRwmkfpGwoHV+B2cSkbWSiQWk8PUmlMpiCFxod/CzU6l5bCGwlfJcZYBezkOPi1zgFfrGG8oRnfPhzW23pZ+ldosi9y6FVRiOd2o9rkRWbL5tGXVR4JB3KlOWn8NBjnGhXDmGWTZ1aHZtqUIgYPNZfwnrpoFGDxT63GkOYRUzIcH/6BjbzN72+Pb7FnGt/IiK/uwtYh+0EnhqHOVz2AO/pZDpcFCA28pNxqIe
 ruWoGJHi
 wD3tsqWEr1jThDmc16ua2ukQSDkOfxxUoX01PZH8WobDECUQZeIl+BmyAVveWbfE+VhAAodMiMl8AMAv08Wezs5J4oMFKcWoG4jtZu3mHfAkEksuzDsMqYT3PedC9RzuVAmubPP2AkKOE4vtPL/d5ZjCsOOve/o6tK4UOLJl+x3ElE+d1aFubo5yx+bCuPJIEyhfKGI4AphAJJ3IDTOccQRmgcx9RgZTUjZTl+LmYJ6eYCjwgaM+ZX6ixgRliTuWgP7oXJrqsDEBTFaWzvHJzeRErTIPoKTcaPkI0uskomVyqmkE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

page_counter_calculate_protection() runs without locks. Several
reclaimers can update the same counter's emin and elow at the same
time, and readers such as mem_cgroup_below_min(), mem_cgroup_protection()
and the dmem eviction code load them with READ_ONCE().

Commit b3a7822e5e75 ("mm, memcg: prevent mem_cgroup_protected store
tearing") made the main path store emin and elow with WRITE_ONCE(), but
it missed the early return for a counter whose parent is the reclaim
root. Those two stores are the only plain accesses to emin and elow
left.

With CONFIG_KCSAN_STRICT=y, a few tasks writing to the same cgroup's
memory.reclaim trigger reports like this within seconds:

  BUG: KCSAN: data-race in page_counter_calculate_protection / shrink_node

  read (marked) to 0xff1f91b146d40e40 of 8 bytes by task 163 on cpu 4:
   shrink_node+0x57a/0x1210
   do_try_to_free_pages+0x194/0x930
   try_to_free_mem_cgroup_pages+0x204/0x3f0
   user_proactive_reclaim+0x28a/0x4d0
   memory_reclaim+0x35/0x50
   ...

  write to 0xff1f91b146d40e40 of 8 bytes by task 167 on cpu 6:
   page_counter_calculate_protection+0x1fa/0x360
   mem_cgroup_calculate_protection+0x4e/0x70
   shrink_node+0x53e/0x1210
   ...

The default KCSAN config does not report it, because it treats aligned
word-sized plain writes as atomic.

Use WRITE_ONCE() for these two stores as well.

There is no functional change. Readers already accept stale values, and
compilers emit a single word-sized store either way: with GCC 14 the
x86-64 object code is the same before and after this change.

Fixes: b3a7822e5e75 ("mm, memcg: prevent mem_cgroup_protected store tearing")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/page_counter.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_counter.c b/mm/page_counter.c
index 9167ffd1380c..5293460831f8 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -472,8 +472,8 @@ void page_counter_calculate_protection(struct page_counter *root,
 		return;
 
 	if (parent == root) {
-		counter->emin = READ_ONCE(counter->min);
-		counter->elow = READ_ONCE(counter->low);
+		WRITE_ONCE(counter->emin, READ_ONCE(counter->min));
+		WRITE_ONCE(counter->elow, READ_ONCE(counter->low));
 		return;
 	}
 
-- 
2.53.0-Meta


