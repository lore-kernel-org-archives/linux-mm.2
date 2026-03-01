Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87318FD0070
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 17:43:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 668486B00A1; Sun,  1 Mar 2026 12:43:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5309A6B009F; Sun,  1 Mar 2026 12:43:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BCE16B00A2; Sun,  1 Mar 2026 12:43:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 252E36B00A1
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 12:43:35 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E5EEC1A0727
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 17:43:34 +0000 (UTC)
X-FDA: 84498216348.15.55ABD47
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5360D40006
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 17:43:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pa/1Hh26";
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772387013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hT3wkQ+yDZgUkiEO2oUROt9UUUJDhDzzxTnyoV1IZrI=;
	b=Dp9sb6UCMFr8uULchYxuwtLoIlQSxlBkwuWx2zUoUKQKMRupgd9KDrQw8a4oUZpqEmlI5b
	+Cq6f6fieYThvf6QN86n0qp1uE7G+ZwnhGQVCMUvFv0cUcOp1x7MP39LyqyQGG3842TJeV
	llrRaxTYdA4D0zRwMZkzumSsrOB4Nn4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pa/1Hh26";
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772387013; a=rsa-sha256;
	cv=none;
	b=AxZNNTSlaPoJvrHhwxiau1QFIevuPwx9souFjCvWPx5SSMhzklgUdp05kbN/WA9IhnZGja
	rRX6ZleF9Av6CjRxFMlDfHTT+MiTrBEI9T9O8RNsALG1EYRWwIeiiOrht7EZdkNz8V0KXo
	bXe/IivVng7yeK+0RdTG4IwafU5vLvI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BC30A600AD;
	Sun,  1 Mar 2026 17:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B92C2BCAF;
	Sun,  1 Mar 2026 17:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772387012;
	bh=nkxfWGkCfA0dtqbKfL4Ap5CeLN1/sVBbqbCyhGOAcDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pa/1Hh267VDif0fGECk4ZBsQQZXzXfS8+im3ufGhSbXqQAUw5hsIrfOzfy1h442s/
	 leZWhqr9a1qEaoiqvnQ+flJSjdWw3+l2hcccGnCWBNysvlfgxgesGRG0eztr2m27Z5
	 WFbIAE6/2kpFTBY+s9f0zz7IHcv67IRQ5eSBBJW+hAdlcNtb92GOzS1cyCPk0FzBbx
	 1TUeRYgSDmgNq8F7wegrNC4MyLjIRII4Bx2xUSOylKEm99RqJ8jyEtUx4zLNhjvq2r
	 vD749FkEGato7zuc9wkEF98Wvaxk35fOtkn+VyN1KBJth4VY00iiizRnFXsNI5bvQu
	 bppMvpKICqtyg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 05/10] mm/damon/core: add damon_merge_two_regions() debug_sanity check
Date: Sun,  1 Mar 2026 09:43:20 -0800
Message-ID: <20260301174327.76849-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260301174327.76849-1-sj@kernel.org>
References: <20260301174327.76849-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i8t5khym7sikd7owgn4axy783imrq1bf
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 5360D40006
X-HE-Tag: 1772387013-931630
X-HE-Meta: U2FsdGVkX1/3r9fvEEqeqUvdOMwvfSAged9281D9IIFco+WsKrt2NBJZNgfEbDZdPQqrXmUNiy06mJO4lPFnWYrdcKCuMwejkDI6ir6QhOw9BwdBGPFQpUnEn+7PjMK+GYd1WJzzOpIHT2SuvHl82XCoTsIOChtUUlKsu0fo9Ry6urGVaBFTwxw4lIX1nUC2+AOf0xmU6+WFqFFNq15WwfGEOTpXfHMr5XRV3Kd/Uur8VXnR0Q2T6jsRnFyjKpVNdfOsxd1/PeZOgiTs9qBvjnEfkA5/vskGWShJ7EDf42an9+ScYSiwxh/130CHLThHIWpDvmh5YXrB4AZCjllV67e0RXmrsJy2D4Qel4RRtDyjxm3q1I7W9Pwj0aUNg+CNO0DnkKc5oRj/60IbLDHs3t9HlL881+mNJiJEHq5FAM044MuQX0v7g5pCoxcnCJa+DZLvWdA/Ljc4v+jy+ady9lNJ8VnyUY0LVkxwH9xP5tHMWfOs6JZczlnbTQRPAr5EZFnrNyB03hKEcWAHLVLzxQQdvi7jD+xXfT+hYVp2HRNIRwwI8hpen2ONuUih+OhtWy7Y1XKaBHkui+K0eiyI3nemR7yoxTCTpGexE5rYqPwhDWOrz1/wEYx8OIEACHhRsb8Y5r26mSCjev4YubHe2YSRxfBGv770yCBZV8bBeqqpdzRgOJNc+d4N9kNn3TULxwJCTzRape4IfWOuJI/JRXZ2vp/d53AA4Fs4H65uV7iW/for8XmFOz+9HVsrNkcUXmvmlqVaRy6AoMsyMvuMLsmv2UBdZ5QUnNfNXiZgNgoeWN6OH4tYAhTxrfbesMr+1/Ynb/VVphYY9X+n59lvRC618QWSwKpSwu7dQrs6IlHXwajCvinB2YI3R9vAhcda2NyvDh8frW8qOGrF8LFYgPk9RAXsONPklCf1TIVEUYQN/zhwzI+gOAqQ0X3E9d/CLO4GjjZSA8aBOJWnabF
 vKVhd+vA
 PIsTC3eWHoINInmJadl/wCaheXVfISr0ZRULr32gryTxnBL5bbdB2RmNLFOyFDMdN0k+QOkH+9obu4ytY8Ul4Ax+NPYJTCtVpDysoeDIEAPOI1EHQT4JYmGE4nkgc/VkuY+Rwoju3hXJb+FHxavEFVxJA8SPqvuozorpM3UYu7nLyqF1V3WqcLoTbyiGG5pVLilmdKEAWhgJWMx81hj5doyouV3YxMt5zgvBvGsq6WZjTgrsp94tSjIYh7MaUtGsQcwucOWdkYtfnbqu/wXgeojnB5Q==
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
 mm/damon/core.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 2b5aed89d449d..8a3738a17cdd9 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2473,6 +2473,21 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
 	mutex_unlock(&c->walk_control_lock);
 }
 
+#ifdef CONFIG_DAMON_DEBUG_SANITY
+static void damon_verify_merge_two_regions(
+		struct damon_region *l, struct damon_region *r)
+{
+	/* damon_merge_two_regions() may created incorrect left region */
+	WARN_ONCE(l->ar.start >= l->ar.end, "l: %lu-%lu, r: %lu-%lu\n",
+			l->ar.start, l->ar.end, r->ar.start, r->ar.end);
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
@@ -2486,6 +2501,7 @@ static void damon_merge_two_regions(struct damon_target *t,
 	l->nr_accesses_bp = l->nr_accesses * 10000;
 	l->age = (l->age * sz_l + r->age * sz_r) / (sz_l + sz_r);
 	l->ar.end = r->ar.end;
+	damon_verify_merge_two_regions(l, r);
 	damon_destroy_region(r, t);
 }
 
-- 
2.47.3

