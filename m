Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8C3AC79F9E
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 18:37:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EAFF6B0088; Sun,  6 Sep 2026 14:37:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89B866B008A; Sun,  6 Sep 2026 14:37:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B3FC6B008C; Sun,  6 Sep 2026 14:37:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4F1166B0088
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 14:37:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C9099A0578
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 18:37:04 +0000 (UTC)
X-FDA: 85184194368.18.680F9C5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4DAC620002
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 18:37:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EPvD/Ofu";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788719823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zhQNwRYEIS4kE/CvLbGr7B/xSZlKygyBMw9AdWBN80M=;
	b=UwrpHMF4WefvPpcejOr2Az3BoYFcnnLeRdn2HrYvOujElkMTN6XQQTX/uD8U5PrylGaCt2
	X4Ygm5aa1vZrqX1IC2Njnb5q+cOXzaFXIX6FTL07aQ9qdg6lBgmebDc4VLdwa2xQ7uo4tI
	W4Xwxa6PVbcr4JvFyNRR+OpJUHIuFpo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EPvD/Ofu";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788719823;
	b=P9A8roYTraJflJv+4cIl+cn8NXHLMYBYNsX/1uou7jjyi96/a3Qyfzcnj0V0WLxVyLT20X
	7+CpEIrwAax6gnIAxK3ynJ0LN10BU1C3Bpp4Ex3XeBcanSY+FqbCuUccViwIME2pie4d31
	MbHMnQUq/KY0f+8eigtGY5czmg8u1Gg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B7EDB601F9;
	Sun,  6 Sep 2026 18:37:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 227151F00A3A;
	Sun,  6 Sep 2026 18:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788719822;
	bh=zhQNwRYEIS4kE/CvLbGr7B/xSZlKygyBMw9AdWBN80M=;
	h=From:To:Cc:Subject:Date;
	b=EPvD/OfuoevHCK7mt42e9YBPXAB3eu7jlX3A97CwVt8yRfNwcGk3HJCwmSQRSyOLK
	 SvOFyw6XWSkRC18AOBekLM87MOBgeeuumRQ8hJCkmMBkd7acmqF7pELC1JDOSMGrVj
	 7z1CSAJB1I1HIxPB4aEfnbvcUzC8xs8Nf0xAxS+q6ukTqWV43di8ky6JdzzvkJAA1v
	 VlDtK8dqgrPmy/CCZB6yNRJ6EX7ysEYaWLrQN+hp4bfgOEZWQ4om9GAOmWeeNqqJY+
	 F4kwS7ls29EmxQPR3ED/ga/0padmKWz476l2+nUacd5/wmExJSSnHX9pbQimXlOz4N
	 VW+BVPNNU6lGQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Enze Li <lienze@kylinos.cn>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH] mm/damon/core: reset invalid quota->charge_target_from
Date: Sun,  6 Sep 2026 11:36:53 -0700
Message-ID: <20260906183654.95634-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4DAC620002
X-Stat-Signature: u8nzsz8zw8w3q7hy17p4ro1edqzemdey
X-Rspam-User: 
X-HE-Tag: 1788719823-514420
X-HE-Meta: U2FsdGVkX1/Kecdbs7i5wQ+drOeqaUXSd15J5KMEY4DD2mOToqP7RK/GJVSGnYoxEQkSVZihePIU4PIwzKrA9kZ4N63Uny6st5Y9gqlEdZCQEu8M28kmzRWACZJsIRCrfkmgVpteHoTCFJLZ7qJn5oIU5SFdBttfndwgIZAm9kxHQePURWFaXrIwy0sE8YZ2B70jTe5CDXYhDBA4AdWUVc0EfzPb+S6+XnYXuXZt6NhTeRPi4ZAVRrb23ld5d7NwdYBshfpHoIp11LIhjjzH2zs0iYvBZNIs7qpjih8tP5qITHZ7TU70Ix/cNMIm+9OBDTQCRxvtUIhrCKi27qWq6oU4ct2qnrfxBJVqlvNytI+KLS1Hl1Gltn/HV5f3IuFa/DgGqfXKVmbJpE3QgIenbkl8xOaqa1LAv2VmSuynon7Nm4LDvWkLbQDER+8SgbuTpXQ+B3dFzPjMyKKAVXVKjesfUWNaQrXJJjA2IhFY5kxTVGt/upoi9FZ1v0vDdGPxAPyJcwSQAHqzxZnJWt824FEQ9mSM9dRUZlTr5M4wLMDzKAqP48WXCAS8+3HntpH1SvbfBV69kEYul5IY0pAYUcvpXCKk/nPNVLFZEPLEVwto6MlzWEpa6DLikLEQFcz0MLBchsZ6K5nKAD9X8gPZcKgdboq2cvLE09dv3rAnQgEUYAXOfksRrKMMY3XoOqkFetwOx3exTQ38EqO1fhyAD4Xy94eljukLpmuo8QSc6hUTz0yZOk+RC+kmsWJJfK27rX7RMg+QGuhwCtTF6gVbDbVza+BFdhLNqyaBvB+1fFaL6JeTY6FVGdC6txUBbToohND845bNzp30SqXwx4tsTqUqri+lIiYccP1lMgUemWmk35y6tF4a8oG+Vkw2T6/m3srVALln5xdTRFAkrlNIDqxpK4AdZGNnQ7Q8h8itc2Kbf+ES0K28MKfdgtGuYp5x0E4WNPk/qPpYvWhSs9u
 wy7Ygxow
 v/+VxNUfP+kmJIEqAAU9n3B+p0jiezjD6qP8W7w2VzCrJaA1V8i1NNn3HzDDKJc2+GhUz71NM56A3ryzdAWT6QyDWsA43AT7oCkYsWIh71a4KhyTH24Y7jmLVHSgWR/HvWQUigfKg10kQvih5v8D3SsyKUGgcSWvSdnRpioSkLPF/J4MljBwTbR6gzS1iTagBmdjdKj+iUTQa/ywKLLZrr4M7Wl6D1vNezJMWMqpDRLyOtz0zL7m95BwAoesf/10fNSCYDVkv5uVe/VdnDrbr0iStxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMOS can suddenly stop working if a target process that quota just
fully charged in it is terminated.  Fix by catching and processing the
corner case.

When DAMOS quota is fully charged, the target and the region to continue
applying the action in the next round is saved in
damos_quota->charge_{target,addr}_from.  In the next round, DAMOS
iterates targets and regions from the beginning.  It skips applying the
action to the regions until it visits and skips the saved target/region.

Virtual address space targets become invalid if the process is
terminated.  Trying to apply the scheme to invalid target is just a
waste of time.  Hence commit 6e4930e33329 ("mm/damon/core: fix wasteful
CPU calls by skipping non-existent targets") made the logic to skip
invalid targets.  However, it does skip before the charged target/region
skipping/updating.

Let's suppose the user runs DAMOS for multiple virtual address spaces
with a quota.  The quota exceeded in the middle of a virtual address
space.  And the process of the address space is terminated.  Then the
charge_target_from points to the invalid target.  The pointer update
logic is skipped for the invalid target, so the charge_target_from is
never updated.  DAMOS action to every target/region is skipped.  From
the user's perspective, it would look like suddenly DAMOS has stopped
working.

No critical leak or crash can happen.  The user could reinstall the
scheme.  But this makes use of DAMOS under certain setups quite
unreliable.

Catch the corner case and reset the pointer in damos_adjust_quota(),
which is called for adjustment of the quota for every round.

This issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260830064708.40CA61F000E9@smtp.kernel.org

Fixes: 6e4930e33329 ("mm/damon/core: fix wasteful CPU calls by skipping non-existent targets")
Cc: <stable@vger.kernel.org> # 7.0.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index ce8c6f99106ed..2c58be9edbde4 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3283,6 +3283,22 @@ static void damos_trace_esz(struct damon_ctx *c, struct damos *s,
 	trace_damos_esz(cidx, sidx, quota->esz);
 }
 
+static void damos_reset_invalid_charge_target_from(struct damos_quota *quota,
+		struct damon_ctx *c)
+{
+	struct damon_target *t;
+
+	t = quota->charge_target_from;
+	if (!t)
+		return;
+	if (!c->ops.target_valid)
+		return;
+	if (c->ops.target_valid(t))
+		return;
+	quota->charge_target_from = NULL;
+	quota->charge_addr_from = 0;
+}
+
 static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 {
 	struct damos_quota *quota = &s->quota;
@@ -3318,6 +3334,8 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 			damos_trace_esz(c, s, quota);
 	}
 
+	damos_reset_invalid_charge_target_from(quota, c);
+
 	if (!c->ops.get_scheme_score)
 		return;
 

base-commit: 98a7a286b6060dce5e93b37e28f2e0be80304027
-- 
2.47.3

