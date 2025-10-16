Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A97A2CCD199
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 21:47:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F25DA8E0025; Thu, 16 Oct 2025 17:47:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFD3B8E0002; Thu, 16 Oct 2025 17:47:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D770C8E0002; Thu, 16 Oct 2025 17:47:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF14A8E0025
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 17:47:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 83F9684FCA
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 21:47:45 +0000 (UTC)
X-FDA: 84005314890.26.FC41311
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id CA3322000D
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 21:47:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j5RZ9Zd9;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760651264; a=rsa-sha256;
	cv=none;
	b=RIielb2V8LtsY14M4jZYx0QoyJujU4Q78vRIv8ZvsaaNjS/Qki0w5zhg7l9Dt421KPIi7I
	jm9mvzE3mFkEKX84jqTjmaIGsX2maIKDu9TZLzEErSLNCUjzKJIiirm39hKhmtBkttosTf
	zP+aIGkDqG7vq5cQpbjXQFnnY0YbknE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j5RZ9Zd9;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760651264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y1V069m/iH0AeL73QYJmi6pP1OpeSFhNDiOXkPncn/c=;
	b=vR2gRm5EFhmMbzBSD5BQk7ZZsm6mcPMxSARmB+szieSEb7qeuSxWDNWx7Frx2PydCc0WD8
	pWw0DTWWOWZEm5809ItilNT6I/RNIc5cWAhfxncnyY0DH9FHhw8Z1+ZAJ7CpjmicwMS7B1
	HTgliTtT3MJVGprQ6zvgdD97geVXntE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8452649D65;
	Thu, 16 Oct 2025 21:47:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DFE6C116B1;
	Thu, 16 Oct 2025 21:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760651262;
	bh=UUnCkanvoPf80rfrjE5y8KYyMoRR90dpdf30uhflryc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j5RZ9Zd9vlngL+iwpjUimBM6yuyRDpeqGgN3hWpLniLlmPJVypAaKX3AROSCCMpck
	 5u0FhXhO86Zusk/grZihXHecJ71vNGlsWNfjT/8D9v9J5KLJ3vHEPLe4ap0EQYIK4q
	 Pdw7KMbhrudeHwlhdg+1QbWa+aC09cQiX/ywv2bwUrkvrizFGsv6cD2tN0NxLOFYTD
	 R2IrJLDlG/wZrjhLPfLc4w9fsQby8mPBLMhMQgGuLJTbjWdeO1yPJHzWKhW/T0PLLL
	 TMgVXl3kSACRYTA8y8z3i5Cr8csflXLxQqHHELklyOAZMvSn5SucfA+dANi4ghXXiY
	 7JC3CFvPFrnDg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	bijan311@gmail.com,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/5] mm/damon/core: add damon_target->obsolete for pin-point removal
Date: Thu, 16 Oct 2025 14:47:28 -0700
Message-ID: <20251016214736.84286-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251016214736.84286-1-sj@kernel.org>
References: <20251016214736.84286-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ru4wgctezdidxx67tyzdmbcirobnfucx
X-Rspamd-Queue-Id: CA3322000D
X-Rspamd-Server: rspam09
X-HE-Tag: 1760651263-397203
X-HE-Meta: U2FsdGVkX19qQ578Uz3PMiTJytZ6YcCmIk7DOHbP4sF0sU5f4PerPO35Oga2miZ+q6BNHOyrENx4lzkD50FHwWbrahl/fjx3AK76/mRlh/tsvvjfmjXqPNvGIfUxS8o6zwNojZsSeHhOECPf5c4Uvd+sgEVjtkAtbRWHsi5CUQhayJiMf5H8JuQAqKP+GsGBUwyhjQayFxVfKaXY58GEY6UOLOQiomFMY22np3NviwiNFmcu26EKxoUvshbNkWKI2c6sHKe0LC1+0z5OmmHbWiU5z59Wx8bxg9pctjGo3K6q1CHuP+tFxPbQkQvFnP7MAFCk2erZXTLuiYAtO9lU8ch3CBs9m/nBCNtnoN0n+HR+MmSJzP3g2oSuI76NIGsoqMM78tYTWx41oerctdLW/m74iM9gTr4/+mg/civGmhXp2M37wskahw3DzZWlTt5h9RU/4egpqhi9XA+BJvbim7u1OvUvB3qvLBcyTZbkffel0n3IQaLduwxXN4fVcOTnmAePjT/AroyU9cWVzdl3VvsAzlts3AScAfXutoDkMsotmv/uQWsZW3vOc81n0BYcMmIdGlfPoKUEHcqqju9/6ThpChTqYpomYfvwwoodvhuYSkr5qpKzXST2P5f5MkKQcd+5Yf+lOLtnjwi0aLnPC2kbDhKERiY+oPb2JudKACST7l6PGm5mY4HF0GHsKPT0mgqG1X8JpcxoA1JToB4LryrNxduQO199aV7ffDuZ3M265xld7jbZYIHab8M8g8oLZmTrsgZmzhCPlIfE9TztCv/nY8zq96qt9HH3pzdJAwjEKKt1YIBeFJnjxBfgg+WDQSWnlIDX8ilEnNpsUJvhvrADl9+tbbOP5CLDEvm+5aqYFfW52vfePqIXJlJBm21UQSQQvUNaTBfJrSgMY80TLIaIEqATYQgjN4wwRaw8T3W4zqo+4yx/uVOGol4CWShrctK99SD4m/qRUkv2lej
 CzfxyNL2
 qda1AxKm0UVf/plXk4mkelXu8WwMTK24lDUaDzwD8ZZDRS7gP4xICrzGCULS3kcLgv01JUfJ2zbiY8HaoN3IaTFUUmmjhUwV7n+7uq18btedHM+AGfNtoR/jZBPB0GHhopoRD4CLrF9WRxymoR88/6GmwPVW0OZo1Ro1csqKubInZuU9sy3jRv496V3/ztVHKU4l8PbI71+Nh3Yt7Ui20xzCJhDchgMNEIYjRVIBg+eK/0+uKbiuCnfWZWgtrFap9USa8ecgybfX0QZ7BiPMi1mi9tAwrRpV0Pr/ZQBAQgkqRu/bGcNNN94Vo4g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON's monitoring targets parameters update function,
damon_commit_targets(), is not providing a way to remove a target in the
middle of existing targets list.  Extend the API by adding a field to
struct damon_target.  If the field of a damon_commit_targets() source
target is set, it indicates the matcing target on the existing targets
list is obsolete.  damon_commit_targets() understands that and remove
those from the list, while respecting the index based matching for other
non-obsolete targets.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h |  6 ++++++
 mm/damon/core.c       | 10 +++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 524dea87cac7..8a7b45b9e40d 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -92,17 +92,23 @@ struct damon_region {
  * @nr_regions:		Number of monitoring target regions of this target.
  * @regions_list:	Head of the monitoring target regions of this target.
  * @list:		List head for siblings.
+ * @obsolete:		Whether the commit destination target is obsolete.
  *
  * Each monitoring context could have multiple targets.  For example, a context
  * for virtual memory address spaces could have multiple target processes.  The
  * @pid should be set for appropriate &struct damon_operations including the
  * virtual address spaces monitoring operations.
+ *
+ * @obsolte is used only for damon_commit_targets() source targets, to specify
+ * the matching destination targets are obsolte.  Read damon_commit_targets()
+ * to see how it is handled.
  */
 struct damon_target {
 	struct pid *pid;
 	unsigned int nr_regions;
 	struct list_head regions_list;
 	struct list_head list;
+	bool obsolete;
 };
 
 /**
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 70e66562a1b3..3242a9573db0 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -492,6 +492,7 @@ struct damon_target *damon_new_target(void)
 	t->nr_regions = 0;
 	INIT_LIST_HEAD(&t->regions_list);
 	INIT_LIST_HEAD(&t->list);
+	t->obsolete = false;
 
 	return t;
 }
@@ -1213,7 +1214,11 @@ static int damon_commit_targets(
 
 	damon_for_each_target_safe(dst_target, next, dst) {
 		src_target = damon_nth_target(i++, src);
-		if (src_target) {
+		/*
+		 * If src target is obsolete, do not commit the parameters to
+		 * the dst target, and further remove the dst target.
+		 */
+		if (src_target && !src_target->obsolete) {
 			err = damon_commit_target(
 					dst_target, damon_target_has_pid(dst),
 					src_target, damon_target_has_pid(src),
@@ -1236,6 +1241,9 @@ static int damon_commit_targets(
 	damon_for_each_target_safe(src_target, next, src) {
 		if (j++ < i)
 			continue;
+		/* target to remove has no matching dst */
+		if (src_target->obsolete)
+			return -EINVAL;
 		new_target = damon_new_target();
 		if (!new_target)
 			return -ENOMEM;
-- 
2.47.3

