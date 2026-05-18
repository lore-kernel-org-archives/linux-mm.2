Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47D03CD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:41:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12CF46B00A7; Mon, 18 May 2026 19:41:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 093D66B00AD; Mon, 18 May 2026 19:41:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8AEA6B00A7; Mon, 18 May 2026 19:41:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A46946B00AB
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:41:28 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7136E1C20CC
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:28 +0000 (UTC)
X-FDA: 84782164656.05.87B532A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9E6921C000A
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S0aaBZ+u;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GTt+0Gkd3cau84KWIs7o9z/eIgdaQZIRBLKQlqUVKkk=;
	b=LqDKWLD4/BKDwuC0oXQakDOoUgh6tsIpBRsTH7y0S0zuYiwaxAm3q2/vsq8y3c8OkiIbKB
	zerL9Qgi1BR+gdwe+fWkehOPDVuV8SGvtrmogGbbQhk1dGAKXiq2k0J5/G58BBGMT9+PuV
	NdbR+DvwVQBybjCdwlQ+VA8qXVH9vZg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779147686; a=rsa-sha256;
	cv=none;
	b=fRZoMsVI7LlPQoBRaals1iEVMfIqGATDZJWokOCUfUTfLU9MYIFDLC18hNCywKmkiQUGlD
	idEhRcHFo1D0Q//ppN+vNX5O7HXfdvu9fZeKgKVnUxDyaqYSOEByfyvxsL9jhhseONcQHn
	tRXDSKUx192bBD7i/nnB9R9YdMtbrlU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S0aaBZ+u;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BE22C44508;
	Mon, 18 May 2026 23:41:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75EEAC2BCC7;
	Mon, 18 May 2026 23:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779147685;
	bh=IlAa+oqmEJU7Ymj9l5zZPzJiXY56Jh7uaI0GPCOUdHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S0aaBZ+unVDLD6djSWl/RinRsUhT4XjzyZT+8HeKoPgKZFTIU3hPnRzNfN0tRHS5e
	 XM1/wiof5kJ4tPvwnaEKHbPjWBgIM0s/kVvxT0wwiLkePbg1ZAfloJ6vWZ2zWr5vwH
	 TVRU7dgoR43P6zQvZzYlLU19c/8Jt70XTejnr3o28qQvbwVALZvvHWGBPGQo7gfyD9
	 EOgavJelUGc2RYXHMFbmcZBPDiG12ZxETMmqARfJ8k6eYE9idwqiF38DFWsPsvH79e
	 EHfhcVcDfp4mFU8SSihbsBUU/rk/zDpiGxvFsoqZ80Cdr6WZpFESqm3s5GkpCvPdYO
	 wkes1E00GUpVA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 05/28] mm/damon/core: introduce damon_region->probe_hits
Date: Mon, 18 May 2026 16:40:53 -0700
Message-ID: <20260518234119.97569-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260518234119.97569-1-sj@kernel.org>
References: <20260518234119.97569-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9E6921C000A
X-Stat-Signature: odq7p4wod3igdgtzth4zhdon816mc16e
X-Rspam-User: 
X-HE-Tag: 1779147686-298513
X-HE-Meta: U2FsdGVkX19nyei+Q0lO5j+RycbBRsn5HDzPpOrmeeqn3ObRr4WrRNsaiShFAZ4QR0dAIgc11ZlNhkkVUA7vmqDrTB10K8rnjJkYjOtnkRHLh+FLn8bTycqtEmBaKVqZeNJ45+/9wXvJcLvSzWpx6A56kw3LfuKKjsU1wDq486rUBx4pwMyiGWFFa4KydJVe8CzFZwDGWSV187b8X7kM0iVvTFTdf+EL6rBPoMATkR7n0y3IhSM+LSrQJBJHTGP+Hupzx5A8L6/1A6B+jaTssv4L2jnMgNqMncojPBIlE+tvnsVFE/kQeDyjymc7m1sHXUY+WTPCoxRk+cZwyR06aA0NLG17HSdU9E7NqaPN1trmyz//j+xkniCHbBniy9NfAZYuAc+X4esmx1A6sIxGOyDK3b4zSRI4DPP8njokcJOjMu8veodmr0l69/XokM2GiW6Dgtrhxu9oz/k2kAkZu6CrjJA9msbNTI75oaYPaOBEh3xzqWquOtq5IKeuV2w9ifsXtRyCvgH4puOrH7WP2hqq+gFm2enK1LcDx67/kd8lAolcV3p3MEP+70GjYiIt3diu5+Dq9uGld4JN7XrAbJxDlFrLJDPEpbhdYec48LhDaJsPVnknmXvpZVBbF7dppjcXZhwSW9kfgLHTRO9CUKRqQc7sEztkbtXNjK0LXmn0rCGiFt/nszyAc2PZCGpiNngyd7gLwXLEqIo5GwJ+JI80a7p1DuQ3+jseIo5+TN5pzqXAQEeeHJR/o96Cq7tCjKdq1dW9j53HudwBYcnI7Oc//tAsS7315QaaFBREO3AFglDkZvg+twpsop9daEDlFjaVIbUXIehSeA+T9l4vts3mqRpcf4jpgk7Of0vmeptsBVHju94yLEvmKJinA2oAGUEqvz5xe3xnqvH4Abaoo2ifApA/7VA7dNKO0OD5Wpcc5pU269rJExasXya70HNLudcL2DtcxsmQroj7bpf
 R2vySmgU
 fY3kBuiRtkBYs7yW4jQo3ov5G2uua++IRnQIL9zFLflFkztrSaaN+Z0NZGf3VWRUquWNxOHGhzPtLDtgWtBi+cKIvbxD4FZpa2xpp3JDzo53yM9PT4vM0CIh3hzeJeqoVkG1UazpXCswMcZ2w+A8JKc/yZ60WmT7+rZ7PRaR7qtY7DFX5+wVDnCowD/PNfQsky5rkh6LR2Rx86l75bRrls/BwHfZ5Us/jF7ldIj192sTIGVD/eAIx93YEyoxd91FmMQfCAYXLyL19uSBRsHUurTYFgV2htJ3IzeedtQoysP7OC50ZPo2c00ONWvsk6rCn6k9a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an array for the per-region per-probe positive samples count.  For
simple and efficient implementation, add a limit to the number of data
probes and set the array to support only the limited number of counters.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h |  4 ++++
 mm/damon/core.c       | 10 ++++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index f8b679dd944d9..3a30af119ac6e 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -17,6 +17,8 @@
 
 /* Minimal region size.  Every damon_region is aligned by this. */
 #define DAMON_MIN_REGION_SZ	PAGE_SIZE
+/* Maximum number of monitoring probes. */
+#define DAMON_MAX_PROBES	(4)
 /* Max priority score for DAMON-based operation schemes */
 #define DAMOS_MAX_SCORE		(99)
 
@@ -47,6 +49,7 @@ struct damon_size_range {
  * @nr_accesses:	Access frequency of this region.
  * @nr_accesses_bp:	@nr_accesses in basis point (0.01%) that updated for
  *			each sampling interval.
+ * @probe_hits:		Number of probe-positive region samples.
  * @list:		List head for siblings.
  * @age:		Age of this region.
  *
@@ -75,6 +78,7 @@ struct damon_region {
 	unsigned long sampling_addr;
 	unsigned int nr_accesses;
 	unsigned int nr_accesses_bp;
+	unsigned char probe_hits[DAMON_MAX_PROBES];
 	struct list_head list;
 
 	unsigned int age;
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 075d60a4749a3..6dd1bce81ec2a 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -229,6 +229,7 @@ static void damon_verify_new_region(unsigned long start, unsigned long end)
 struct damon_region *damon_new_region(unsigned long start, unsigned long end)
 {
 	struct damon_region *region;
+	int i;
 
 	damon_verify_new_region(start, end);
 	region = kmem_cache_alloc(damon_region_cache, GFP_KERNEL);
@@ -239,6 +240,8 @@ struct damon_region *damon_new_region(unsigned long start, unsigned long end)
 	region->ar.end = end;
 	region->nr_accesses = 0;
 	region->nr_accesses_bp = 0;
+	for (i = 0; i < DAMON_MAX_PROBES; i++)
+		region->probe_hits[i] = 0;
 	INIT_LIST_HEAD(&region->list);
 
 	region->age = 0;
@@ -2983,12 +2986,17 @@ static void damon_merge_two_regions(struct damon_target *t,
 		struct damon_region *l, struct damon_region *r)
 {
 	unsigned long sz_l = damon_sz_region(l), sz_r = damon_sz_region(r);
+	int i;
 
 	l->nr_accesses = (l->nr_accesses * sz_l + r->nr_accesses * sz_r) /
 			(sz_l + sz_r);
 	l->nr_accesses_bp = l->nr_accesses * 10000;
 	l->age = (l->age * sz_l + r->age * sz_r) / (sz_l + sz_r);
 	l->ar.end = r->ar.end;
+	/* todo: do this for only installed probes */
+	for (i = 0; i < DAMON_MAX_PROBES; i++)
+		l->probe_hits[i] = (l->probe_hits[i] * sz_l + r->probe_hits[i]
+				* sz_r) / (sz_l + sz_r);
 	damon_verify_merge_two_regions(l, r);
 	damon_destroy_region(r, t);
 }
@@ -3111,6 +3119,8 @@ static void damon_split_region_at(struct damon_target *t,
 	new->last_nr_accesses = r->last_nr_accesses;
 	new->nr_accesses_bp = r->nr_accesses_bp;
 	new->nr_accesses = r->nr_accesses;
+	/* todo: do this for only installed probes */
+	memcpy(new->probe_hits, r->probe_hits, sizeof(r->probe_hits));
 
 	damon_insert_region(new, r, damon_next_region(r), t);
 }
-- 
2.47.3

