Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7C6DCD4F25
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 16:25:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A67036B009E; Fri, 15 May 2026 12:25:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F11D6B009F; Fri, 15 May 2026 12:25:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92E106B00A0; Fri, 15 May 2026 12:25:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8513F6B009E
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:25:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5170D1C04DF
	for <linux-mm@kvack.org>; Fri, 15 May 2026 16:25:03 +0000 (UTC)
X-FDA: 84770178486.11.1A10771
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 982EA4000E
	for <linux-mm@kvack.org>; Fri, 15 May 2026 16:25:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ovGCot7F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778862301; a=rsa-sha256;
	cv=none;
	b=D4aJPBcQTL0f1Jt6mozLlusCE7S1lvr8veGaC3x6bh2lDKwxIpFhvj4T5miR7qBS9TkOV5
	TXLdjQxLlWixGZHnE/sORG2Mu1ggSOh9Ju3nxFsYFUr+Jln83nkCdOVNDfr6HUe6Ox1/Tw
	Ps3CzlUKQuwhO0cg0/Nw5F4tcxigWY8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ovGCot7F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778862301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AiFrDqGsAB5FCaKYKIjmRFn6etEE9x4R7F6uFuMhIN0=;
	b=HLC7cJpkwXJPUxF6+0LjVSjins+fg84nXsStiYV3buF7nWIi1lp0SsNcRz4PUKQbMaOUaz
	uf1CvbCAH8KFwK1fgkmnO3slBu7GRonzndPXgAXXeaDGvshUF8JfCX9YBAwivQ4yB+Zf4D
	e3FjdiVk/DS/TvEGUZX2j1DG34jcRfo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BA8164150E;
	Fri, 15 May 2026 16:25:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7B1C2BCB3;
	Fri, 15 May 2026 16:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778862300;
	bh=dvyaAGwaAEmKdhHRQ6Trfstm6Ieb9ZAn2zLUlooC8QE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ovGCot7Fct19IIkkgts4PSq3Hkjx4cZBUTmShXiE2+2xLMJTahWSp3ehfRUgXBkIo
	 A51/OcvpuibLhpf2opV/nbf9sBldvUTY2TOoZ/0Wc/PXW+FPa/r3TrKBNmYshH2E56
	 YlCMq1kAjRUwTVlCzQtRwMwwv5GmErW3PXrFpUPsBQLCBVcMWPX5n9tpKqA+Kkngix
	 6driDpZcyRd/6uLimC5IunBP7dMk2WLNcACyRlUuYhhjTqERzFC1bCQhlqJkXF/3oV
	 SlevGnQWcx21aAdwCiNKasLfDBwyfJTWwsno3MrOQvWQ7xnr/JiZdvj55mlGb+LHRk
	 cs2np44xkpaSg==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Sat, 16 May 2026 01:24:32 +0900
Subject: [PATCH RFC 8/8] mm/slab: allow changing max_{full,empty}_sheaves
 at runtime
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260516-sheaves-tuning-v1-8-221aa3e1d829@kernel.org>
References: <20260516-sheaves-tuning-v1-0-221aa3e1d829@kernel.org>
In-Reply-To: <20260516-sheaves-tuning-v1-0-221aa3e1d829@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <liam@infradead.org>
X-Mailer: b4 0.16-dev
X-Stat-Signature: yenjs1jhah8y14c518r8pu7nx7adi4rc
X-Rspam-User: 
X-Rspamd-Queue-Id: 982EA4000E
X-Rspamd-Server: rspam07
X-HE-Tag: 1778862301-75218
X-HE-Meta: U2FsdGVkX1/gQg/Vsyis+iZhfD6gNbDjjN5ETW5IbT0fI/ZtznSjzguflIa4k4azTd0HD+LSf03TOcnXfzP+lvQDgi1XqW/UqcYp8iuO5bJEPJaaQg09xxlG6TATan+ov8qg/5qq41h39BGiq55ARN4EPtACcKC02dh0RVeYUVZIF4gXJxR4zV6n0ouFgcDzhwoTY5pLZuTeDqttO/ooaKLheE83JpFLuTARyJyhL3vg8TeWml5Fm0lKe/pA3jxZbO9ZvSBLZo9gjBwxpKnOoIHjjRHlAOfZpBnJ3RIWcIdNPiARh/2h8KePx4InxHV+g3VcoCjIYafqCMiGqWHhqp9s8bVKrtUXCQKIcfWbdFE+l4LgoOGM4y6HSTOFdnKtSlOAK0Sdgzz/jhvbs5CAkBsfAViIQLhAQflQPLZ164232AWZbjIWNUinXt3wv7/C6v9jqy8qM7rg1KgrkVy2k+VnNLvv5NuUWRcrgdqpmJsMQqUtgCaB4D98vzUoQsok5/xMHFayPFJW8AKMUQw2uS7rOafbTD7E3JUmFAWREcSHHtgwtsRri6XgZGAbPYBFTEe/JVmnKO6zau9C2b9Mj+aoP89Qcrf+pkgbPtA10eqwjQYH0wqYGN/o2PzZp5ZF+aY7EsPR8vNfzzEDYDDjuBi36SnjdDx8tA6/W0EYpJ+1b+b3LN0rynDnCuVbSraKIqCz95k5O2E8fEZpn/tGGJQmggK+Huh/HAkET7hsR0tnmmF7Ey5WED9gkW9YTErY4Ff43N9EoSjdX7a1rarfF+Y20B1hnseZjPZ8LGsTfX8qHCyhCzZUKutjqLS00C9FXNdXA0ojN5SSyJtKh0tobHwxNru/mVaeuM1w82KmwqGoXpDLenohxBBWs2D3v4L8zyb8JxyYhc8RWK6PDJewA9dD0mVA8+qs3EEp97blBJX6g8i46d/Cz1XvKw2+TQgN5e+thlDJ75xMEMp02cN
 jYkTNuFk
 R3nc4/r6PXbp7jKFWwFDpf+cvm1RnEUCi8Ybe+yMfT2phmg5y8PJrE8QQAMNL6DL4L5sawCtU5S3+xo0mjkuDSzP8oxW0QecBOW4FVrz80OXYCogMCcd3N9LVx0dZVr4cDFu2t90/3vtR5+E3QbZFJLjR7vO3As10bL3KwurDl9QOOQOizd+knUOZUO3eEMSgLq7CuEmBt65WFnhYT7WTft705D4voiFr1iEdZlIjkdgcNGr1HvAAGs5g+7SWZjZ0KwUj46eJCqrMr9kSoTI9MC5kuSE3tsbcpSH4cbztafFQeDtmz+7Kjn+jSx+r4DR8+SmzQXZUPxQ6oDA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace MAX_FULL_SHEAVES and MAX_EMPTY_SHEAVES with per-cache tunables,
and expose them via sysfs attributes as max_{full,empty}_sheaves.
Keep the default value 10 to preserve the existing behavior.

Let us measure the impact of this parameter and discuss whether
it is actually needed before landing this in mainline.

Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 mm/slab.h |  2 ++
 mm/slub.c | 55 ++++++++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 50 insertions(+), 7 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 907a8207809c..22df364a2ef7 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -205,6 +205,8 @@ struct kmem_cache {
 	struct reciprocal_value reciprocal_size;
 	unsigned int offset;		/* Free pointer offset */
 	unsigned short sheaf_capacity;
+	unsigned short max_full_sheaves;
+	unsigned short max_empty_sheaves;
 	struct kmem_cache_order_objects oo;
 
 	/* Allocation and freeing of slabs */
diff --git a/mm/slub.c b/mm/slub.c
index 856639d3d3f0..e9b33567d98c 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -396,9 +396,6 @@ void stat_add(const struct kmem_cache *s, enum stat_item si, int v)
 #endif
 }
 
-#define MAX_FULL_SHEAVES	10
-#define MAX_EMPTY_SHEAVES	10
-
 struct node_barn {
 	spinlock_t lock;
 	struct list_head sheaves_full;
@@ -3287,7 +3284,7 @@ barn_replace_full_sheaf(struct kmem_cache *s, struct node_barn *barn,
 	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
 	/* we don't repeat this check under barn->lock as it's not critical */
-	if (data_race(barn->nr_full) >= MAX_FULL_SHEAVES)
+	if (data_race(barn->nr_full) >= s->max_full_sheaves)
 		return ERR_PTR(-E2BIG);
 	if (!data_race(barn->nr_empty))
 		return ERR_PTR(-ENOMEM);
@@ -5251,7 +5248,7 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
 	 * If the barn has too many full sheaves or we fail to refill the sheaf,
 	 * simply flush and free it.
 	 */
-	if (!barn || data_race(barn->nr_full) >= MAX_FULL_SHEAVES) {
+	if (!barn || data_race(barn->nr_full) >= s->max_full_sheaves) {
 		local_unlock(&s->cpu_sheaves->lock);
 		goto free_sheaf;
 	}
@@ -6072,7 +6069,7 @@ static void rcu_free_sheaf(struct rcu_head *head)
 	 * limit but that should be rare and harmless.
 	 */
 
-	if (data_race(barn->nr_full) < MAX_FULL_SHEAVES) {
+	if (data_race(barn->nr_full) < s->max_full_sheaves) {
 		stat(s, BARN_PUT);
 		barn_put_full_sheaf(s, barn, sheaf);
 		local_unlock(&s->cpu_sheaves->lock);
@@ -6083,7 +6080,7 @@ static void rcu_free_sheaf(struct rcu_head *head)
 	sheaf_flush_unused(s, sheaf);
 
 empty:
-	if (barn && data_race(barn->nr_empty) < MAX_EMPTY_SHEAVES) {
+	if (barn && data_race(barn->nr_empty) < s->max_empty_sheaves) {
 		barn_put_empty_sheaf(s, barn, sheaf);
 		local_unlock(&s->cpu_sheaves->lock);
 		return;
@@ -8843,6 +8840,8 @@ int do_kmem_cache_create(struct kmem_cache *s, const char *name,
 #endif
 	s->align = args->align;
 	s->ctor = args->ctor;
+	s->max_full_sheaves = 10;
+	s->max_empty_sheaves = 10;
 #ifdef CONFIG_HARDENED_USERCOPY
 	s->useroffset = args->useroffset;
 	s->usersize = args->usersize;
@@ -9359,6 +9358,46 @@ static ssize_t sheaf_capacity_store(struct kmem_cache *s,
 }
 SLAB_ATTR(sheaf_capacity);
 
+static ssize_t max_full_sheaves_show(struct kmem_cache *s, char *buf)
+{
+	return sysfs_emit(buf, "%hu\n", s->max_full_sheaves);
+}
+
+static ssize_t max_full_sheaves_store(struct kmem_cache *s, const char *buf,
+				      size_t length)
+{
+	unsigned short max_full_sheaves;
+	int err;
+
+	err = kstrtou16(buf, 10, &max_full_sheaves);
+	if (err)
+		return err;
+
+	s->max_full_sheaves = max_full_sheaves;
+	return length;
+}
+SLAB_ATTR(max_full_sheaves);
+
+static ssize_t max_empty_sheaves_show(struct kmem_cache *s, char *buf)
+{
+	return sysfs_emit(buf, "%hu\n", s->max_empty_sheaves);
+}
+
+static ssize_t max_empty_sheaves_store(struct kmem_cache *s, const char *buf,
+				       size_t length)
+{
+	unsigned short max_empty_sheaves;
+	int err;
+
+	err = kstrtou16(buf, 10, &max_empty_sheaves);
+	if (err)
+		return err;
+
+	s->max_empty_sheaves = max_empty_sheaves;
+	return length;
+}
+SLAB_ATTR(max_empty_sheaves);
+
 static ssize_t min_partial_show(struct kmem_cache *s, char *buf)
 {
 	return sysfs_emit(buf, "%lu\n", s->min_partial);
@@ -9721,6 +9760,8 @@ static const struct attribute *const slab_attrs[] = {
 	&objs_per_slab_attr.attr,
 	&order_attr.attr,
 	&sheaf_capacity_attr.attr,
+	&max_full_sheaves_attr.attr,
+	&max_empty_sheaves_attr.attr,
 	&min_partial_attr.attr,
 	&cpu_partial_attr.attr,
 	&objects_partial_attr.attr,

-- 
2.43.0


