Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB551CD4F3D
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 00:45:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D22B66B00A7; Thu, 14 May 2026 20:44:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD33D6B00AA; Thu, 14 May 2026 20:44:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9B866B00A8; Thu, 14 May 2026 20:44:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A67026B00A6
	for <linux-mm@kvack.org>; Thu, 14 May 2026 20:44:58 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 788E21C0652
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:58 +0000 (UTC)
X-FDA: 84767809476.14.C191445
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id CB3A74000A
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hC3oQj9n;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778805896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7hSyA8EV6dnChvqvaSTsFx1oRiXoiHP8X6qrzdttYAU=;
	b=QveJVQsZUG+XwkX/+XKr7bp1Q9pQ4YnOZJiZxM+9W+XZKG/oVXYqancgf08l4mdESgPQf0
	xj4/l2Go3yBlmmDw2ziAuaf6YU4isEcuTD9G38RjDq3iS5oLd6n7BjZpdO2T764rbmRuPQ
	UGNgmwq6IL670nvPka30xOry8KVHeT0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hC3oQj9n;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778805896; a=rsa-sha256;
	cv=none;
	b=Msz6LRc+tr2WQwkFQ9liL7lVTyr6B6+VyAdUohQ0YYN2ZfRgFGmPqEqMiirzwQAbJ8mmAS
	HY1Q7imYqliOz1ozLRt6TSEzVM5wKTtOz82s1vhp8qN+bXMoZwiIrg/F/Fy354BaPa+XQr
	r6/9vmwCO1ha3au+seQjVE9ppVhEsrk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 91D3C403F5;
	Fri, 15 May 2026 00:44:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48694C2BCF5;
	Fri, 15 May 2026 00:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778805896;
	bh=sbbC6q3YAKtgRh2ZitI4ryLVhWoQrxzmSYGFabzMLLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hC3oQj9nucKnuU+6YJy3FkwES2Ekotc861SToqurZQRNAQQEbK6C3g1dhrnogi2ti
	 unmbMOARtbZ6ZlrXPLu2EKdub0j5eeEYW+DsKOJMsu5s7envDrRkuArN/RLDd6joh9
	 v01FtwbwpUzCTCmyjW2Iv9JUvxmMu267nzcmwdeWszB0bZMQlOlWqPZDHcWOQKcqH5
	 6oxzv1Vl6E0TEjoms1r7mKIyargGkWYnv4RDAEQDPnNLABvnNw15DrMzrTZnPW6Rx4
	 tP0n4VmK4oiNY+tz5temFkHwYoI0pmAXjNipkBzlHb4AsShDfyQrTaiwqVOSWvK7qV
	 8pCswqSlx9a8Q==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 22/28] mm/damon/core: introduce DAMON_FILTER_TYPE_MEMCG
Date: Thu, 14 May 2026 17:44:23 -0700
Message-ID: <20260515004433.128933-23-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515004433.128933-1-sj@kernel.org>
References: <20260515004433.128933-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CB3A74000A
X-Rspam-User: 
X-Stat-Signature: c3xcax9p6iy4z4fk5gfy64ryeyg4g3bp
X-HE-Tag: 1778805896-757724
X-HE-Meta: U2FsdGVkX1+/EiOvmmBYXMUDuKsR+aiCTc5GHh2R6yuq8qDwWyGXRdpcJLRbPScnIrTI+KmdObt0NBEpfDcqil0BYoDW5iQEN22nt3TUXIhNo4PN5wW9x+E1Xp8cQbrBC6ZslHREY1bI8nNoV/0Ycc+9Y0uBQA0tXdp9OTnZrOruG1djiyRuqrt0ZtpbF5OMjzL6Q1d2VqmdPrrlrloB9LisKqEDnQDAxQ0ccjQtATUHowvnNwyjXwmzMtDXkuiqm4WaEM/IYO8bWIapQVCafgKuxL1nLg+KpIsJfJJRXn1T0dGfp0atQAqGD8WHADmO2J/8Q5AnTV9NQFa/s5p6akckoXrg9u8roZbrBqK8OVVfSQDrwAGBSo/ZMH9EdJtbz7ndsuc3OzkOjFtS3aM1z/GAHdiSYsozSI/GrAkcFLt5vXiiG1yI84CqXMs2HFQttmAGyKrXQ35P19pk0IxV4CqHOZlPnGZkjS4YiFZfQPPj1BO0OZbbImFciNa04TeCINdjW93RJSu7Bh6wfocbjIit4lNTD9ERQvf6ksoGksgz2ICIlh1j+/ix67HbuTaJZfBjp4qbuyFnOHgdjJn0lzM8wj1iS8HJNMb8LDTkXgLRPw+tUtj7nHDXrMWjewmeGVxJrlbOUoZAuZdBpkpe+Rz28HFwpTWHoPMU0HFHusIOixOx0Nj1dpdWkU+jIKeHZc9uaz4Q8RFOZq4BErdyLXC8tZ0ueh9tPyEqz5WYZLwRbLpcS0Fd/yneiBIFTtTBF+5hLBFvxPxCFLqKMMGUscNnqJqePIvCc38kTD+Z0isyK27Md+R+cfXq9jazdDcJsKC91LWBHIGVtWua/EJ5qL6qAUv9+aWVPn+1QbCKNU40x1qsah7thosKEbGaPxg+RaH7VOW+/H8ON9o7GENHbCG9THJ2xUB2xqJIpCMo2u/0kAng2MHOIS+oqDTfZxdzET5v7q1paGRSzB68nrx
 6ftXFxmY
 MmH/xLIYdQy5bKI6Ghm/0Trjwz08gwz7+qd91fH9I6TZfd09slwAunMuy/DhGd2J6n74xKv1qmgwG+bJd904g+H+mIzo1MvZ+nghuKiKdXpvNozAu+lHkvdHoeFSqlo6UNgWQmUDcbHdeaLve+wKAzAZYj9zBVTZL3RQqbV50jMDK6+nkSBXuQY8lxrpGjEhmt1u1ypkGc3Xf8uWWetykLqZ2m4x8v+4oFGRjwkIDbLw70E/ayPeGEkbgDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Belonging memory cgoup is another data attribute that can be useful to
monitor.  Introduce a new DAMON filter type, namely
DAMON_FILTER_TYPE_MEMCG, for monitoring of this attribute.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 6 ++++++
 mm/damon/core.c       | 7 +++++++
 2 files changed, 13 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 36a1162b6185a..c3ecb35da6404 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -731,9 +731,11 @@ struct damon_intervals_goal {
  * enum damon_filter_type - Type of &struct damon_filter
  *
  * @DAMON_FILTER_TYPE_ANON:	Anonymous pages.
+ * @DAMON_FILTER_TYPE_MEMCG:	Specific memcg's pages.
  */
 enum damon_filter_type {
 	DAMON_FILTER_TYPE_ANON,
+	DAMON_FILTER_TYPE_MEMCG,
 };
 
 /**
@@ -742,12 +744,16 @@ enum damon_filter_type {
  * @type:	Type of the region.
  * @matcing:	Whether this filter is for the type-matching ones.
  * @allow:	Whether the @type-@matching ones should pass this filter.
+ * @memcg_id:	Memcg id of the question if @type is DAMON_FILTER_MEMCG.
  * @list:	Siblings list.
  */
 struct damon_filter {
 	enum damon_filter_type type;
 	bool matching;
 	bool allow;
+	union {
+		u64 memcg_id;
+	};
 	struct list_head list;
 };
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index ab8ac9ec8450d..2d4a63dcc47fe 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1422,6 +1422,13 @@ static void damon_commit_filter(struct damon_filter *dst,
 	dst->type = src->type;
 	dst->matching = src->matching;
 	dst->allow = src->allow;
+	switch (dst->type) {
+	case DAMON_FILTER_TYPE_MEMCG:
+		dst->memcg_id = src->memcg_id;
+		break;
+	default:
+		break;
+	}
 }
 
 static int damon_commit_filters(struct damon_probe *dst,
-- 
2.47.3

