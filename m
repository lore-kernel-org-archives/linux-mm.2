Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5279DCD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:41:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 743586B00A5; Mon, 18 May 2026 19:41:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65EEF6B00A7; Mon, 18 May 2026 19:41:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B3CA6B00A9; Mon, 18 May 2026 19:41:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 287F76B00A7
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:41:28 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EEA7D1C09CF
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:27 +0000 (UTC)
X-FDA: 84782164614.22.6B8F8A1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3777A1C0004
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=os0gBHJH;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l/wvKR67Nz7TiVD+GughwYCSmKfyidJd8H4mh1qrZQ0=;
	b=AMIlgDfmOuSX+jJutSNcFNPg54N//QB6F2GwBHhve7+GDbjiqGpH0JgMjXEVoi3BIidtIe
	2G+LLCuOvYDscttdRkFmVfGVcCICAgMtA1Yek4to8TmB9U4Hz0YY/WOLd3Z8RYTAdHgo8L
	0KU8LN3OeQQnMdeRa2hpsMNzdzgoyVg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=os0gBHJH;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779147686; a=rsa-sha256;
	cv=none;
	b=PhHTC6O2f8FlXuUA+eRkvAjgKGZnds4awQIT6GFObs1OmDrAR5WTHZ0DW9MhBAI3D/nWgL
	Ec7B5UJTsBfnOKhB5/DeuEIbQpba14aatg0Z7JUUE0PiZ9hrDDE8ms7rUqtCUBGsSjotXn
	1v0hXrC029cGLiQtxE2euNJTeaBe2rc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6A15C44559;
	Mon, 18 May 2026 23:41:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2918BC2BCB7;
	Mon, 18 May 2026 23:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779147685;
	bh=mIzkcH/5A3M6QuaehEH7P+cR7kb6K2TS5t1AbB4gd5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=os0gBHJHahHk/HMbnOsr8aOC6mf9fC0x+yISiRhTktEn1nluY6OaB82kZ2Y2HcTsp
	 VoXK6LvyKbN5P4ymo+BdJUI/FKpJGfrTXeX7jRTcpl5FGLN1AWEqsMjSMi7LoYjlmX
	 KaQRtevWPo0QgZPlK54LurK29YOMDPuSBxeqbH5iXLULy7CPK4Uh5W1wfca+16X1KP
	 Hu86EpXtFQNWk/WCNLLRopq25OIHTeRlDpldzP7hVtTdcsqJRk/CHbetIBO0ecRSmK
	 Cs32aLTLxmysA9hG+xbkX3/YCsYrBCd6Bejgyd6JAlLrgsgrFuvu3NVz1eDVMYQfPp
	 6s6S/rhp4LPhw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 04/28] mm/damon/core: commit probes
Date: Mon, 18 May 2026 16:40:52 -0700
Message-ID: <20260518234119.97569-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260518234119.97569-1-sj@kernel.org>
References: <20260518234119.97569-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3777A1C0004
X-Stat-Signature: joi5y3di983yu6tniyjsmnhynnnqujsn
X-HE-Tag: 1779147686-442933
X-HE-Meta: U2FsdGVkX18WGQEACZa1gv5weVC+/b14eXPVc3HeReiTE6ZwOMs46iX3XGvLEOelt02c+CR+Q5834j2F/91f6V3sipoI5kUhcBv3abQUTka453akkZUCyjXiowAUVjBgBkQVDKz+DDVP0fS2B4OMyFEW/h0Kn+9OpdCafoIYdHdEYYwjH1ABRJkK2HRfX8Zva3JkygLsZC59f5ZZ7GftVbAjn9Hcl7ygRq2xhlx6Fs9Yl+2q+Bfb0PjdW2jbePxC/7wpMmhc+0AyH+6znu+c5vG8kuwy+UprspDx3sDEnvxePJsBpG8rn9IvhuYpm608ZvCcsGWhOWTsHVdAxMeQLcS9tr/jeEp+Cmt+RsOIO0nPip2p5hvOy8ceMkpjnNl+TP/aQQ8+3V2N9OB9WicioVW0a6dgTqmuDOOjbPrKCS8DAAf93phxdPiYjrP3Qd4kMYF8M32KLRbCDasodNl3k+smVuN23Z0Pdk+hQC4xXz3yO8ksPQFjfCjK3HTCHxC+tKwgDMfv7QF4t3UpbIAA7HNcnBpeplw3rXzcyhzYu4PCs5Tv0ME0dRYfkfHXGz3mEcI24aptXgcO4aYkxTg4eYEhJtWO3LY3Xpzvcm5GUfE07LNcpVh6hKjoNTg9p0ge3UUPKI319T5SNEjxfTlMLeQQffKlkKB+LFAaDTwe/bEIR6xINWq8UH00b3oMPtFxd2k/68wPUFfujOCj7mLibmrsoTJArVhhG3q92EHjar3SBMzYMI8/BIfpqnWZ03tVRmDNtw0bR/ruYQ4jSGyntfglb9PZrtoMo6Y2mWOj0G2l+oPPGFLjSIbu/4iKq8V0CHYIUWp296rJJj7mMoclky9DINkqui9xGd7LNYHKwEs9cq5vypbYn0zYN1J5ntCcDCKYMkzJ3RS6qYE9JyRoowOr1p4YD6kGdTADPdXXb/nnfMwagdxLGV6Tk7oOd+WV5geoygq3ZGYI//KMGIn
 ZJLV5x6f
 7ezVA7RK798bnXspfhpvUkYKmN1QUtpHAza5g2Q4p29wFwcTlQYcJ6AIpipbqu+fFyGWg8VtU5tdTuHc1bWFR2AKjgKDdx2q6eENuv7jTRTEHd+ssThdcTPCOPIjyqEeiBZ6U7xx47CHJmd86qFSotb005/bz8TZkprNBKIf5v5UiOrItFmCImk2D5dP2jS+JwDcgmayFYXHCXhKd6x3vVZceM0eG2ne/n7AfF851syHWU7g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update damon_commit_ctx() to commit installed data probes, too.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 104 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 104 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 516368fbf1de3..075d60a4749a3 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -133,11 +133,34 @@ void damon_add_filter(struct damon_probe *p, struct damon_filter *f)
 	list_add_tail(&f->list, &p->filters);
 }
 
+static void damon_del_filter(struct damon_filter *f)
+{
+	list_del(&f->list);
+}
+
 static void damon_free_filter(struct damon_filter *f)
 {
 	kfree(f);
 }
 
+static void damon_destroy_filter(struct damon_filter *f)
+{
+	damon_del_filter(f);
+	damon_free_filter(f);
+}
+
+static struct damon_filter *damon_nth_filter(int n, struct damon_probe *p)
+{
+	struct damon_filter *f;
+	int i = 0;
+
+	damon_for_each_filter(f, p) {
+		if (i++ == n)
+			return f;
+	}
+	return NULL;
+}
+
 struct damon_probe *damon_new_probe(void)
 {
 	struct damon_probe *p;
@@ -175,6 +198,18 @@ static void damon_destroy_probe(struct damon_probe *p)
 	damon_free_probe(p);
 }
 
+static struct damon_probe *damon_nth_probe(int n, struct damon_ctx *ctx)
+{
+	struct damon_probe *p;
+	int i = 0;
+
+	damon_for_each_probe(p, ctx) {
+		if (i++ == n)
+			return p;
+	}
+	return NULL;
+}
+
 #ifdef CONFIG_DAMON_DEBUG_SANITY
 static void damon_verify_new_region(unsigned long start, unsigned long end)
 {
@@ -1389,6 +1424,72 @@ static int damon_commit_targets(
 	return 0;
 }
 
+static void damon_commit_filter(struct damon_filter *dst,
+		struct damon_filter *src)
+{
+	dst->type = src->type;
+	dst->matching = src->matching;
+	dst->allow = src->allow;
+}
+
+static int damon_commit_filters(struct damon_probe *dst,
+		struct damon_probe *src)
+{
+	struct damon_filter *dst_filter, *next, *src_filter, *new_filter;
+	int i = 0, j = 0;
+
+	damon_for_each_filter_safe(dst_filter, next, dst) {
+		src_filter = damon_nth_filter(i++, src);
+		if (src_filter)
+			damon_commit_filter(dst_filter, src_filter);
+		else
+			damon_destroy_filter(dst_filter);
+	}
+
+	damon_for_each_filter_safe(src_filter, next, src) {
+		if (j++ < i)
+			continue;
+
+		new_filter = damon_new_filter(src_filter->type,
+				src_filter->matching, src_filter->allow);
+		if (!new_filter)
+			return -ENOMEM;
+		damon_add_filter(dst, new_filter);
+	}
+	return 0;
+}
+
+static int damon_commit_probes(struct damon_ctx *dst, struct damon_ctx *src)
+{
+	struct damon_probe *dst_probe, *next, *src_probe, *new_probe;
+	int i = 0, j = 0, err;
+
+	damon_for_each_probe_safe(dst_probe, next, dst) {
+		src_probe = damon_nth_probe(i++, src);
+		if (src_probe) {
+			err = damon_commit_filters(dst_probe, src_probe);
+			if (err)
+				return err;
+		} else {
+			damon_destroy_probe(dst_probe);
+		}
+	}
+
+	damon_for_each_probe_safe(src_probe, next, src) {
+		if (j++ < i)
+			continue;
+
+		new_probe = damon_new_probe();
+		if (!new_probe)
+			return -ENOMEM;
+		damon_add_probe(dst, new_probe);
+		err = damon_commit_filters(new_probe, src_probe);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
 /**
  * damon_commit_ctx() - Commit parameters of a DAMON context to another.
  * @dst:	The commit destination DAMON context.
@@ -1445,6 +1546,9 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 	}
 	dst->pause = src->pause;
 	dst->ops = src->ops;
+	err = damon_commit_probes(dst, src);
+	if (err)
+		return err;
 	dst->addr_unit = src->addr_unit;
 	dst->min_region_sz = src->min_region_sz;
 
-- 
2.47.3

