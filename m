Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DE71C79F9E
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 21:05:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1C686B008A; Sun,  6 Sep 2026 17:05:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF48A6B008C; Sun,  6 Sep 2026 17:05:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1FE76B0092; Sun,  6 Sep 2026 17:05:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 96C006B0088
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 17:05:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1685B805CF
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 21:05:25 +0000 (UTC)
X-FDA: 85184568210.21.90C9688
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 70B6F10000B
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 21:05:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hev5VWS0;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788728723;
	b=CwV06cq55+8lN2qlWIsokRqwM6zQ/6/BhDax1itbTh7G6S8Y3LLRYnA0Gi7z0sCS2leRjf
	lOncUEa7PESNJnCrEtWCNXFSvcs+zopPx/kkKKi9JJM2kKdK2Njqu+TC+nRfMJImr4OYBL
	sNLd2GNW+OMuFD0RM60BNeBMKpBzETE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hev5VWS0;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788728723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=enJ6Ikb+xyWqp47h1SJ/IEbgrZU8ueGVdQgMTNLWdsg=;
	b=JDLrb2PjPTeVt0BZ8O9/SfOJrlylW4pOYWpj4nBvrmdgl3DlB1ICHoAu7i7FyyiQ+vh0oH
	qR6zOuGsan+ovBELSk9nT2b/4tQyb3ap/Ex+LboGrYkIdmj3sWGjx65EqimxI/gikyht3S
	/3qh1VeR5LfkfANCxtwzaCe5VxKlP+k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6AF4060A7A
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 21:05:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0091E1F00A3E;
	Sun,  6 Sep 2026 21:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788728722;
	bh=enJ6Ikb+xyWqp47h1SJ/IEbgrZU8ueGVdQgMTNLWdsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hev5VWS0XGTr1CiIZQoRlNatCSnZKU1ZWGfV/gemtU6nYfmgwkNgdevPYhOdvcIft
	 H7WX182R8g6uqDQqJ2JNNIIDkqUmr5H8zR5GXjpbQfbeubTqJgfgo075kzWjAk5m54
	 jwwTumD/XDhtMuG4+OZpfRdWycm/Klu5RgNX1TNe0PAuibTmtbM1ahTEgPkseH+2Nt
	 psK496Zlj8G8fu4R54TzMKogl2xswfhdYZX9ejbf+KOnkXKDoG1lo76zoG+Qs+eN8K
	 tPLTvXxJB8TBgdfuzBAX6dyppUx0YiORIyz31qzZaZgKIjx7rzzMNvxqq6ao8nf07s
	 aO6mZyYOVDKpA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/6] mm/damon/api: introduce DAMOS_FILTER_TYPE_PROBE_HITS_WSUM
Date: Sun,  6 Sep 2026 14:05:07 -0700
Message-ID: <20260906210513.106895-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260906210513.106895-1-sj@kernel.org>
References: <20260906210513.106895-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 70B6F10000B
X-Stat-Signature: ymgcctgccmdtif3mttudxapya4ar7asr
X-Rspam-User: 
X-HE-Tag: 1788728723-842877
X-HE-Meta: U2FsdGVkX1+0SlXD6ZhDXg2nh47bbW23VT8cS8Qw1gIIRFBYtwjR2Y3XNMZxKRkPn8g36cKq3As+nryhKl4ea/0Bm9eZMGDeRDqbtY3D6DgucozrNJM/r1F2U8tHCIjcxeUNYBvDot0Svf6EK1l1MVqV9khLPldUhMeE1w6SO3i035+nGj85oixcHpd1e1bXDy50+PRAxNbkC2CP/t5CQ7lEIOIG08zOr1NJUSf6W83eDhVAJztlvl83lIOAF+tNY5uw7SVMMQw/KDDZ4/42ncoNw39BJ6aKgq0Rkbk93UWlBVyIjn/BRHRFxmzsvP9geNS9mGbrHnr0dcI28Yv3z9t4SKXKafB9ehAyQlZ6tBuOhUYFpmMpi+OF6TsMORMw4oPGN5mkCyjgleVWbg9YrhEr0dSlWDSS9azluFU2AA2YtiCJghE6kmw935RyDZ0yf2FHAS7hOmLYJO1zLCl4GcR9K7GwTczvFJ3bkP7DXKN7+rSx5NFHJa4oFPldyeMG0Be4WWCjeGd/YrmYAy8kzv36MQSivj+j029ZXUmPm/Z2PRZx9PrHjurFfABlg1h0s6ptaMXEC6/HpWw+g6fJ5lHrXFMNqTbaGCnLrDerO/jHfpkqF8jbPRD4RdtMqxAU89XAG5VrnBMIH207TeQw88Ah8lolqP3ikPq6xCrAeSown9YjK6yPOluMqQa2s0xu9SMfP0eUZ4/16g6CYFpa6xHsMafnjs9TCng+ENCjjgBD4ZVdtBdWNZ4I/bJGE5bNvTdUuaf3Lo4V80oxmQtvW2xNKThKDGGBV3mPg8rymsFKpf2LyVCmrZBwIZ5qXurUbFutlFiBZYu3kf8pQ1XWNzliA+5UBD9kXZt02/q0lTzO5X3/pA/yE0bEIFb1iOqhw5g4nxEfx98w82Lphm+gd+8aVN7A+tv/wpilPfehS21R/t5Z6JYk5g/XxgSkEMZgQ0i4am2fSoMuzQq8dDs
 QMIlmBQq
 MAMhpOD/qSKKthJaDnQqmBBHlefNfmV71mVmjHcf/ZtUyKFW0p6J7UAK5o3fBc4cukFoCJFonXRKCv6qO7iLAFX5p5Kh0lnmWeW3rhsbjiPajRD+TJJkz9y7ObxYJvk/4bfBQdfKvHb3IABQwwAwxt7BsVSWT96rw28DuuaKu6IVOvsowGF2NYe7zxhDVqjrIrXJEuD0bg/aUft8O1CYZq2xHE8dRghGQallSrcPL0POdKCXDWP6KOb7a0APleYO1sNn+MalAij68+qwx3dDORpxox+e5/hTtGqrgVO08vkV1wOlhQwsBQxCjq4tv2fG0Q1Ail+pL6GlzaHfZZWY/oZ7vzs4XIDeEgz3S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON kernel API to introduce new DAMOS core filter type,
PROBE_HITS_WSUM.  It will allow API callers to describe the DAMOS action
target regions based on their probe_hits weighted sum.  For describing
the filtering target weighted sum range, add two type-dependent union
fields to damos_filter.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 871d26adf6ae5..59d57131d8327 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -399,6 +399,7 @@ struct damos_stat {
  * @DAMOS_FILTER_TYPE_UNMAPPED:	Unmapped pages.
  * @DAMOS_FILTER_TYPE_ADDR:	Address range.
  * @DAMOS_FILTER_TYPE_TARGET:	Data Access Monitoring target.
+ * @DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:	probe_hits weighted sum range.
  * @NR_DAMOS_FILTER_TYPES:	Number of filter types.
  *
  * All types except &DAMOS_FILTER_TYPE_ADDR and &DAMOS_FILTER_TYPE_TARGET
@@ -420,6 +421,7 @@ enum damos_filter_type {
 	DAMOS_FILTER_TYPE_UNMAPPED,
 	DAMOS_FILTER_TYPE_ADDR,
 	DAMOS_FILTER_TYPE_TARGET,
+	DAMOS_FILTER_TYPE_PROBE_HITS_WSUM,
 	NR_DAMOS_FILTER_TYPES,
 };
 
@@ -434,6 +436,8 @@ enum damos_filter_type {
  *		&damon_ctx->adaptive_targets if @type is
  *		DAMOS_FILTER_TYPE_TARGET.
  * @sz_range:	Size range if @type is DAMOS_FILTER_TYPE_HUGEPAGE_SIZE.
+ * @range_min:	Minimum value of range arguments.
+ * @range_mx:	Maximum value of range arguments.
  *
  * Before applying the &damos->action to a memory region, DAMOS checks if each
  * byte of the region matches to this given condition and avoid applying the
@@ -450,6 +454,10 @@ struct damos_filter {
 		struct damon_addr_range addr_range;
 		int target_idx;
 		struct damon_size_range sz_range;
+		struct {
+			unsigned long range_min;
+			unsigned long range_max;
+		};
 	};
 /* private: */
 	/* List head for siblings. */
-- 
2.47.3

