Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C07AC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 04:03:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F54D6B008C; Thu, 10 Sep 2026 00:03:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67F3B6B009D; Thu, 10 Sep 2026 00:03:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 525366B008C; Thu, 10 Sep 2026 00:03:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2ED516B0098
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 00:03:32 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6A552A49DD
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:03:31 +0000 (UTC)
X-FDA: 85196508222.19.ADF6520
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id CEF9CA0004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:03:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oeQNpx3v;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789013009;
	b=CCZq5dXZJqEQOd0D5QABoqp4Pb6+GfGvKBp4rWhMrIdOqklIiXM+sR07crm+ZDRNDMWaW7
	V0uqqq+IBaUPx/dENhy1XD5IEqTwW+8h4elvIGB+1ZlMMQmz/plGELOjLymM2zuO68c+SQ
	iqj1V56eFfb1MhHFNLZXOX/hSeeJiNc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oeQNpx3v;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789013009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0OvKCQwVrbdq884qmAo02GJLGvlhIZi43wP/kzZVb6A=;
	b=5D4Yv8OdELHtjLcvnsAYfMijQdGRUcTf6CfggDDRsBNEZTPWivbQzbRt02ArunplxWKj+V
	RX9V3OHHQcTAfsww2W/QUpZcLrgp95mUYHzx3TjzWheyhG6bXlaP7bYIjcKIj1z2v3gHra
	+E/oTrPA6c0xgZhCxpIBYXAMEdmlso4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 700BE601F0;
	Thu, 10 Sep 2026 04:03:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F37B61F00893;
	Thu, 10 Sep 2026 04:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789013008;
	bh=0OvKCQwVrbdq884qmAo02GJLGvlhIZi43wP/kzZVb6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oeQNpx3v1F0Di5qlSqfbke+lKAvzSgjoKl+XISZq8xqDNY9BSHyQujqVytKdb7y3f
	 yuBjSf4naKO/i5XZ1oF1567g75vpL3sJNWHKWMt1q1ut9bPN9crTgxlsjrAfzP6YrG
	 npb7VB3P7Mam9P+ywOW2TI/3wTDC4ymwPZIi8lsFBQDQPLTSCRzI7hZfwfrPdNMsGq
	 VAabLh5KaIiu+dcNI0OZ1z1bEwHQejCeABCU+HqlUhGa34gJxDqQ+Pw668Oou5TK4x
	 yfbEZyCxEiMofyOKpyNFt0X04YBhXUCUslG5wBX6Z8c9Gzqv/GwG5FFP3v89dMo2PA
	 1AbjE3ZACLOYA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 2/7] mm/damon/core: extend probe_hits_wsum() for moving sum based calculation
Date: Wed,  9 Sep 2026 21:03:13 -0700
Message-ID: <20260910040319.147037-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260910040319.147037-1-sj@kernel.org>
References: <20260910040319.147037-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CEF9CA0004
X-Stat-Signature: hdkxjumjj17gtkm7kusy67dnn9nmox3m
X-HE-Tag: 1789013009-638787
X-HE-Meta: U2FsdGVkX1/+pR+4mYdp+WVQ16oVHQjrCpK5oylkrheZbkdMheuLQ5NjILWsORwJ2M416M9pSi/RgMQ/EgukNLa1KU9KUAVhC9weVnd+GfY7TF2quMnZdofUF3FwSh2X5wKpQBQWAsuSgnhwlYadb8eanTopvX9mNSMgZgMseobBg/UDOvymEM89jOFb/942b5zz/2/x5zd1hl0yVs0nEEjNzLxkowOnfNBdYQ3iW7L3QOp2mI1JZsjCBR7kVfQ2SOoOnet8tiTNo+nC6vAWS2QKXEUc5EN1WAI5hKlZh5WGWOdgDTl3aI0gnJdApwgUra/WjX+RlKd9JWwpzQqy9B1FOC3sQTSlPmn781It6nxYdFZeoSvNpro2b1FzEM/ZBj50tjEA1twIqAypYnFVVg/JU6haXR53d++HnW7jsLUP6X/Bx5CEmwjeTjF1sMpUWrDrdvqMJPR8r53xIK9U8By1YE+WB/krVtBrIi0cA7XWJLKGD7sqUbnJU/4+eQa6cIhsJTuIMm0qsZ2VGmre55gNDr6KWqJAPos6cEes7ySu9pxt1ZH1BLt4ICny9AOlDmYC1v5m4f2Qp3EVwSvN6D8ZdFhzlqo83BpkjPAcF4FZKue8hOkQPnOnQtV1xF1MPEtFd+PTNJ60Mfp9G/vG9vffO/ncwHbn/P3C5OgAGZgo4+b5Q+78QP+lHc5ELvIA/3OH7VO/1cj3w5eM0Ao2qElsMtIXs1pm+x4aoazZDv+7EOtmTiNVAb5ComA0KQL5HcCczWkc/VCNNgtH1a0il4V2XnFpfj4eu4LC2nrpTrpx4JbhxQI3WzEN4Le10krwKxgMlDvDoT/Ov9XHBlYsjcuFdRspgs46G5XMCV7ZlK6qYgKBpHRNZKIG5qFHbrCC0IbDMyBDakuzuRceKGon0bBqO+n6MGqB0aQ7yjkMu+I7eYcnPuIN/YdjxRJrEYAfHjKZOrfZAZk/xxhQ+mb
 uc7hEJGr
 rN032J23h+cHFLmsv+N9aJfm1jiVOK4qWf831qdCiUPkjuh2BnD525w22HXqzm42ylwxUvZFIPF7Wurl7g6ZPD0Id/OX/1ZX3de4LHLM2knslxzllqjBeIj3GFZaEmpmjmh2aNwqXWOqiTQuK8cuSPAo6a9KE9pJ36tiGlsgfyV45PYOxsGfmn03MSLJmwHhbooHFh8puq0vwXQW9nlHY58NGP6ygLsq3nXaDLx4CEKeDpbZI6R1RzbIzAy9bPe1YUb1dJzPJjhihFyeGA1z3Xwlf2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_probe_hits_wsum() is being called only in aggregation time.  In
future, it could also be used by DAMOS.  In this case, since DAMOS uses
its own apply_interval, it could be called in sampling time.  Then using
the not yet fully aggregated probe_hits could result in suboptimum
outcomes.  Extend damon_probe_hits_wsum() to get the weighted sum based
on moving sum to prepare the DAMOS usage.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 2 +-
 mm/damon/core.c       | 8 ++++++--
 mm/damon/paddr.c      | 2 +-
 mm/damon/vaddr.c      | 2 +-
 4 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 1deda16bb70b5..9fa99f92a2e94 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1073,7 +1073,7 @@ unsigned int damon_nr_accesses_mvsum(struct damon_region *r,
 		struct damon_ctx *ctx);
 unsigned char damon_probe_hits_mvsum(int probe_idx, struct damon_region *r,
 		struct damon_ctx *ctx);
-unsigned int damon_probe_hits_wsum(struct damon_region *r, bool last,
+unsigned int damon_probe_hits_wsum(struct damon_region *r, bool last, bool mv,
 		struct damon_ctx *ctx);
 
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 06cf2ab7e97d7..50e0f9407db2b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -469,11 +469,12 @@ static bool damon_is_last_region(struct damon_region *r,
  * damon_probe_hits_wsum() - Returns probe hits weighted sum of a region.
  * @r:		region to get the weighted sum of.
  * @last:	if the request is for last-window aggregated probe hits.
+ * @mv:		use moving sum.
  * @ctx:	context of &r.
  *
  * Return: the weighted sum of probe hits of the region.
  */
-unsigned int damon_probe_hits_wsum(struct damon_region *r, bool last,
+unsigned int damon_probe_hits_wsum(struct damon_region *r, bool last, bool mv,
 		struct damon_ctx *ctx)
 {
 	struct damon_probe *probe;
@@ -483,6 +484,9 @@ unsigned int damon_probe_hits_wsum(struct damon_region *r, bool last,
 	damon_for_each_probe(probe, ctx) {
 		if (last)
 			sum += r->last_probe_hits[i++] * probe->weight;
+		else if (mv)
+			sum += damon_probe_hits_mvsum(i++, r, ctx) *
+				probe->weight;
 		else
 			sum += r->probe_hits[i++] * probe->weight;
 	}
@@ -3456,7 +3460,7 @@ static unsigned int damon_merge_score(struct damon_region *r, bool last,
 		struct damon_ctx *ctx, bool use_probe_hits)
 {
 	if (use_probe_hits)
-		return damon_probe_hits_wsum(r, last, ctx);
+		return damon_probe_hits_wsum(r, last, false, ctx);
 	if (last)
 		return r->last_nr_accesses;
 	return r->nr_accesses;
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index d7c81829445ba..b8f4d28165dd7 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -202,7 +202,7 @@ static unsigned int damon_pa_apply_probes(struct damon_ctx *ctx,
 				folio_put(folio);
 			if (return_max_wsum)
 				max_wsum = max(damon_probe_hits_wsum(r, false,
-							ctx), max_wsum);
+							false, ctx), max_wsum);
 		}
 	}
 	return max_wsum;
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 9a38dc89a156e..4aecf34e39be2 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -704,7 +704,7 @@ static unsigned int damon_va_apply_probes(struct damon_ctx *ctx,
 			__damon_va_apply_probes(ctx, mm, r);
 			if (return_max_wsum)
 				max_wsum = max(damon_probe_hits_wsum(r, false,
-							ctx), max_wsum);
+							false, ctx), max_wsum);
 		}
 		if (mm)
 			mmput(mm);
-- 
2.47.3

