Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39F7AC61DEB
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 19:36:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2485A6B0096; Sat, 21 Feb 2026 14:36:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0106E6B008C; Sat, 21 Feb 2026 14:36:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC2666B0096; Sat, 21 Feb 2026 14:36:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C51106B0092
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 14:36:38 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 729D314048E
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 19:36:38 +0000 (UTC)
X-FDA: 84469470876.07.D51DC37
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id E82D140004
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 19:36:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZLgrWyhw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771702596; a=rsa-sha256;
	cv=none;
	b=1MVG3ljYDhNBaLIj+Wzu3RHPsN3Xl59OT5Q2C7h39xrwQV99FoljPl1shHQyw6fbSD9qiF
	TIWHBJvhRSbEOZsjCwjJalZKOw+JsQuhNiL8iSpDQhb+ZDY1ggDXz3DuqsT2N6HJUVIdxz
	mUlzOCGybYeFmlkBmQs9cuKSvr5WKUY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZLgrWyhw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771702596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3c4YcBnFMs+nJ4KSV0TkACSCdmpLWPuJT5kyiXURMCQ=;
	b=RXBC4kk3zYQtylXBQUyJvr+3SFYS4JrABfNOMHbQlWHX+sFJEQPlXfGH25taRU5UbzyFXL
	fY3yK5XLgm57WrYOXAajTqzdm/m1VlTsSZaRyphBWAcUqT9iRz57RspHBNx9lQDQIm1EU5
	8NHBnDzAbMYBkRLJokd+w3UpIhTmXyY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7A1C060053;
	Sat, 21 Feb 2026 19:36:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E11EC19424;
	Sat, 21 Feb 2026 19:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771702596;
	bh=RXFcEvIn0MWpVnnu1oJ3V6Kn3He/nSAmwf55lWBXXZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZLgrWyhwax0cT7nz0xs/EG9v4tu/MXv7OA36zpiRe2CNexw3DJQnjeNnnVtyo4Vxm
	 4Rkn7BFF5uU6H1th8z0cFPpFFImYeswzF2ASAGdvmkiJEG7rbMYYdogAiu1IWefaXX
	 UvHXjfodd4SRfEWISn9njL7ykKKALl86yVFpDR/kXFZj+ylG7hSQLAo2NVyrxJ7Ib2
	 sxPu0GkvnKLwbdzMY01yG6zEnhaMBa2HOWq4L75Nrj7kLEfZ/UuLxbnCaPIykfSiCo
	 L2i0Q7TedqgX98EGs6WaO1aGc+xO1zGtnUkM3ovSuNg7OG7SzZmoHpjuARgz95HecE
	 89GY/aErOPc/g==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 05/10] mm/damon/core: add damon_merge_two_regions() debug_sanity check
Date: Sat, 21 Feb 2026 11:36:22 -0800
Message-ID: <20260221193629.19332-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260221193629.19332-1-sj@kernel.org>
References: <20260221193629.19332-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dmeodmo5ucjqxowpktf7gd1fh1sptk4q
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E82D140004
X-HE-Tag: 1771702596-473372
X-HE-Meta: U2FsdGVkX19PhAxTBrIrpkDgAEjCmUsLOPL5jnPgNYTE/nKBP4kltdckp3HjGNIs2zihuqAHEKrk5mJg8c1IKCCKzEduLYZs8wDnblDWEQlRK2JU3164tUCD0OvGYS9XdYgtmGyvQbr7vl0/NUujV8VjikSt5UX4tJuqw8LvjgR1Mj6N5G0q5iWCm7o1k+FEAkXyiw5Hmv3TQItRD0svzEqev/iF1PZAmPZ1y9K1tBZQqpm/KowtF5WrF7W8rshpDGt+px/qi1mCxHlzjwEcKG0esaRS8E5Wr2h98nwe/T5S6x+qlgf1b581Q6t9JZ3KEjQh1tJWPH7PZtPliLjyksbRuikC53VEJRMK1117WUfl0UoXMIS4TKXBxOC4cbm+BR69hrsbj0cvC0ZtI7v3D6h/bfwa6ZJ77VLHkWPJjk+n/Ei9vB0qoLojPx0VGGm27YlkfHfGYIPjHRZ4sLkYOSpmWJe2OhMO/pWDymTAXn1DgQks1bga2NySBYAb15RMFc46ufG7G16XkoUNLKx3KtS8bWIMHYvK78nx40Dm5ZNrnHsbK1I9rRFGsGtWUXc3yn4YdGdMR25Dz9JsDUMV1++b1CRONLonw5M2q1FhuOrMlojXcrtcUfcg1DFS5E5SXuBtHwc22h6Kauc5ZQo2bhvUUtdtt2wxF5ix2ey0y2ikIa7PPl3EwNQfyImpFdHkAX3SnATixiptduls/BJKApo4FKGHi8hnUhpKIVQYA72qJNxkK4bT8oVYyJ58lLGu/d9vBqjTg6V3OcyjM17g5lXBmkUCga/fENdFfi/ALtj6j6JHWmUIzmemPELMT9YJmcQxgwFS84yFycf47gehztW3zeWx1o9+ORyw+2jwBvq/n60h2sHJ5CuPalMsbeemi0d/TsphZ22f6KuWhgYaqly+bKuuGJ7JcH8/d80HZL8X00a4TOYS5nvSPiSyvnGXeznSJcVBkedbQTnax1H
 21JYtWwi
 1acl4Vnp4JT1lhqCb8JKFLf5cq84IkpGEpMNEBkt52lwvwcUO2hLRTu+nYnyMYmYqunykDkeElf0wUjI69Xb/UlPoDcea0B0ThGHCOF+yI/3LcdEJ6a7SzIjEEarXquwjlY/9phDzb4Y0vxAXibTN9qrgMHCmpKjvB8z3BsM0MqgkrFofGP/TmkmirO4xEyqzznF7lg51cxpqf7lvxgQb88AUd837rv5DXtCf0Lg0LQu1uN6IgiyWeAes8ZcmxjkjIH5+dmory1Zb0G2Y2tIXqfC5DQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A data corruption could cause damon_merge_two_regions() creating zero
length DAMON regions.  Add a sanity check for that under
CONFIG_DAMON_DEBUG_SANITY.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index ede76e0789be3..291a847a8c9bb 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2507,6 +2507,25 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
 	mutex_unlock(&c->walk_control_lock);
 }
 
+#ifdef CONFIG_DAMON_DEBUG_SANITY
+static void damon_verify_merge_two_regions(
+		struct damon_region *l, struct damon_region *r)
+{
+	if (l->ar.start < l->ar.end)
+		return;
+
+	pr_err("damn_merge_two_regions() created incorrect left region\n");
+	pr_err("l: %lu-%lu, r: %lu-%lu\n",
+			l->ar.start, l->ar.end, r->ar.start, r->ar.end);
+	WARN_ONCE();
+}
+#else
+static void damon_verify_merge_two_regions(
+		struct damon_region *l, struct damon_region *r)
+{
+}
+#endif
+
 /*
  * Merge two adjacent regions into one region
  */
@@ -2520,6 +2539,9 @@ static void damon_merge_two_regions(struct damon_target *t,
 	l->nr_accesses_bp = l->nr_accesses * 10000;
 	l->age = (l->age * sz_l + r->age * sz_r) / (sz_l + sz_r);
 	l->ar.end = r->ar.end;
+
+	damon_verify_merge_two_regions(l, r);
+
 	damon_destroy_region(r, t);
 }
 
-- 
2.47.3

