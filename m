Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E062E606A32A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 02:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vh6p6hz+
Received: by kanga.kvack.org (Postfix)
	id A736E6B05B9; Sat, 21 Nov 2026 21:48:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4B646B05BA; Sat, 21 Nov 2026 21:48:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 960FA6B05BB; Sat, 21 Nov 2026 21:48:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FF9A6B05B9
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:48:17 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ECA83140643
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:48:16 +0000 (UTC)
X-FDA: 85461220992.12.B29A5DE
Received: from mta1.migadu.com (out-219.mta1.migadu.com [95.215.58.219])
	by imf25.hostedemail.com (Postfix) with ESMTP id 10D26A0003
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:48:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vh6p6hz+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.219 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795315695;
	b=seEW2JUzGpB2RIb6AUjLb1j/bKPR7tGINHMswdYpFE2IYnLSqsK9kdQIls9KkgYOQjyU1O
	WMgjpcIyylEPCdIMVzIIvq/9FY4ZWU7g4tOdwNN8Ec7htEHa4Lj3AnVoYYrxQ5RK/+Sc85
	y7fj8fU3hQn4t9hpXESvwnhEn/9PRf8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795315695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E9PD9aOANTvQHboEG3uZgcAavMQLIgieVrLH9GH/oL0=;
	b=dxx15+q1Rc7iTm0TpihEVvVdEpY35kYSsrCMFzALD+h3y5iahMqmVr99y82LvfrnTDk0tr
	OEOB0H6Zbg4FRQHigPci0ONjzfxno29oQH0Rwl8re/OR6hEPpfQ9GPsdPmWW6WJn0im78R
	6pZC1X3xUPnojd7vv27hWmnqoqPdCaY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vh6p6hz+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.219 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=gqIN7txgscTN3NZxToZ9cIdy5PReEg1UWTFzKR5TdBc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795315693; v=1; x=1795920493;
 b=vh6p6hz+QC7kt4cKEXLjj/gDKNipkYbr+4+Smh8XNRgxwXfkPvvgmAmYgsYyhz7R3RLxeIlk
 B20/wOUqhg7oiduHUlwUtd4lygNKMBS7yp9kJ1W+dnc3n3HQtO+zLT6doeOM2m411cPwI4y8EYI
 V8IdtCGBZ6JBhugZbTcZLmXg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 943718c149af7563;
	Sun, 22 Nov 2026 02:48:13 +0000
X-Mizu-Trace-ID: 943718c149af7563
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	Christian Brauner <brauner@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 7/7] selftests/cgroup: make test_memcg_high_sync check that throttling holds
Date: Sat, 21 Nov 2026 18:47:37 -0800
Message-ID: <20261122024737.2741569-8-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261122024737.2741569-1-shakeel.butt@linux.dev>
References: <20261122024737.2741569-1-shakeel.butt@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 10D26A0003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: u1z6fkhup8xtnn5sj77xskq87w57381z
X-HE-Tag: 1795315694-78970
X-HE-Meta: U2FsdGVkX18bb2eRrb1uANFm3O/HXPn+xM9hTnW5x/ph6WlVgVDOzFQrRezIW2ZVavjJyFI6fW+tJq/58qlfT6YykpdexZwWRFOZlSf/qWS1cbAysPweN/D7xIemnuZDJVPDD+JB042TIAuHrixmrwFUJ2Fe75T2NjTb6pKu8ZmCDAUq9z66sI9FwqsQdyNOphWQFVE9qJ3QLGVoDmXdfbiqCT4X1jDAk81JwQgSdo0w5svi7nNY6Ft8SDat2tIotjhKsbpz7p8FwzAbuFiPGp5EkLSKvsUg2OaF5ti89QXi6qN0aSGh3a2J7JKQEF10BTxW9Rdwc15+F2RYroDhPtppWww3x0s20mJ2SGJEn9hAVoOzNt3LzjwZvUbiw5l2ozmCLo/cc3PwSZw6BdHrkgzlZ1QANLFAMyUaD8h7pP0W7eEOKMg0jdiZjm0RJC7R45YBhG2EhHy9zgJM5AI+CEHV9VrZv4JXVRncW9EHLZzaiuL2IjyvL4KlMIuffe8JUg4J2+tkI3+tSqm/p8JzcZYGKUVIpMvqcTncij+B/pREaQoPn/DLaIkkjb8iEcgJhgyrkJ6XNHZCIYqMA0+62oYRpDNKh4DwlivlRSEZwyRL7UKFBXFrhLqqeJZdhGW5kSCgH/gEf64oGMTjXaeqpOR8VON3L+ou/zJXf5Mu7FDi9qw8qaKqO6Na2yE8jrPpNECzMxSAAzDZzFTfrbpcSNgH8hmuV1OzVIl1TawPykAV/eLOxC9MpWf9VH6RYgb4XLy3l3DtvQVBJaNyevbmFfakBdvCXQVHeqCbXp8yC7m0+8Ov+BA6EAbGYi2b5XwoXAeaqdC06KI9aIfqIKpXSzukuA1lp+RcHx7E745TCW8cRPV3SLI7/5hxSOL/qdRpZsP34aWtYNk0deEh/cTOyqhvF9QykfqUCMAkqIIE34IPQLBi0A7/dbCouWi2p9BWR35baestlaFGZCUMN6f
 se8U3Xzt
 ujTzTmYQLDl6p10ViJ8hqE1ioc/ZA4b8zPjjZVzFyZm0Jy/vOrgOm1Capl/8Ci0/EuS3zF8cv4tv9F9MZiwz+3srzyg/ujtlCo4JwnHuC6xwB7dRthY5kGPfHR5fjAanMUjRslysJGWY8xnTSlhG3S+SAvu8/FQrWrG6cgoOQ4V7/nbA7jnBnr7OzyIp/1KndoNkWt/qnWX/d9Uv5sz8kD7GEILG/X36ed1UfnLEv4mbN3AayxeM6MZRp62UG74UE8N+9LgBeho6libEsXubD+Du4neYYg8R90aUX910g5VX8LokwDm+C1GPrgb2kdo3dtmLmWkk4bKIsZF81YiQ5pnwkzRMaxHPsBAfctFC8EVhrnHR21cowF0fYCACdVWxXR3x47obwNoEbMrrs8ZtZEaZEVATD2KWKg+5nlJynfa2hD/sIILZ921GuJqKyuv2xWX9GPJHyLDdyF1jspl7KbscNK3jpLOYOgEBWTTc0mTsarwE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

test_memcg_high_sync mlock()s 200M with memory.high=30M and
memory.max=140M, and expects memory.high to throttle the call before it
reaches memory.max. But it checked memory.events right after the first
high event, so it passed as soon as the handler ran once, even if the
rest of the call was not throttled.

That hid a real gap: with THP=always and the default defrag=madvise,
THP charges skipped the synchronous handler, and only a few page table
charges ran it. In a VM, usage reached 85M within 115ms and memory.max
about 2s later.

After the first event, check for 5 seconds that no max event shows up
and the child is still running, then that memory.current went up.
Counting high events isn't enough: one handler call can log many while
it retries reclaim. Also kill and reap the child, which may still be
throttled.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 .../selftests/cgroup/test_memcontrol.c        | 39 +++++++++++++++----
 1 file changed, 32 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index bb673012dcf0..1af984761a02 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -771,14 +771,16 @@ static int alloc_anon_mlock(const char *cgroup, void *arg)
 
 /*
  * This test checks that memory.high is able to throttle big single shot
- * allocation i.e. large allocation within one kernel entry.
+ * allocation i.e. large allocation within one kernel entry. The name is
+ * from when this was done synchronously in the charge path.
  */
 static int test_memcg_high_sync(const char *root)
 {
-	int ret = KSFT_FAIL, pid, fd = -1;
+	int ret = KSFT_FAIL, pid = -1, fd = -1, i;
 	char *memcg;
 	long pre_high, pre_max;
-	long post_high, post_max;
+	long first_high, first_current;
+	long post_max, post_current;
 
 	memcg = cg_name(root, "memcg_test");
 	if (!memcg)
@@ -811,17 +813,40 @@ static int test_memcg_high_sync(const char *root)
 
 	cg_wait_for(fd);
 
-	post_high = cg_read_key_long(memcg, "memory.events", "high ");
-	post_max = cg_read_key_long(memcg, "memory.events", "max ");
-	if (post_high < 0 || post_max < 0)
+	/*
+	 * The first event only shows that throttling started. For 5 seconds,
+	 * check that the child is still running and doesn't reach memory.max,
+	 * then that memory.current went up, so it is throttled, not stuck.
+	 * High events don't show progress: one handler call can log many.
+	 */
+	first_high = cg_read_key_long(memcg, "memory.events", "high ");
+	first_current = cg_read_long(memcg, "memory.current");
+	if (first_high < 0 || first_high == pre_high || first_current < 0)
 		goto cleanup;
 
-	if (pre_high == post_high || pre_max != post_max)
+	for (i = 0; i < 50; i++) {
+		usleep(100000);
+		post_max = cg_read_key_long(memcg, "memory.events", "max ");
+		if (post_max < 0 || post_max != pre_max)
+			goto cleanup;
+		if (waitpid(pid, NULL, WNOHANG) == pid) {
+			pid = -1;
+			goto cleanup;
+		}
+	}
+
+	post_current = cg_read_long(memcg, "memory.current");
+	if (post_current <= first_current)
 		goto cleanup;
 
 	ret = KSFT_PASS;
 
 cleanup:
+	if (pid > 0) {
+		kill(pid, SIGKILL);
+		while (waitpid(pid, NULL, 0) < 0 && errno == EINTR)
+			;
+	}
 	if (fd >= 0)
 		close(fd);
 	cg_destroy(memcg);
-- 
2.53.1-Meta


