Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF6BECD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:37:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD85E6B0098; Tue, 12 May 2026 10:37:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C921D6B0096; Tue, 12 May 2026 10:37:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86A266B0099; Tue, 12 May 2026 10:37:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 693376B0098
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:37:02 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2F9641404C5
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:02 +0000 (UTC)
X-FDA: 84759019884.18.1F6B625
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9CD9B180009
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gChnE+XI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778596620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S5U1TdNeh8aWoLpKX+5mI2lMGYR9gNPa9LKhgEIcu2s=;
	b=lhpfFXFPI/iw1sCnG2yct6xyMxQSLglTn3EfnY/aWY/SM8n9/d8CSqQPkminU5CCuOY/nS
	PgR8xPqWFm/iGBpSCahwBUfHc55cNqbZ7qbsUeHoYWrv+8dQXhE16O0p4LoKxVnIJ7e9mo
	n3cs61gTfGWdqKHixQvOtg/3jvqv5SM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778596620; a=rsa-sha256;
	cv=none;
	b=t5uy97tITkdXDWLg+bw/0pio23TZwOfiSZ1agesGd6F38lyAsqzoZWOPhxgmoCjdMFFfpr
	axKTC4zhk/tPiopytWLNVOyTEBzmg6wPjFDBBkeHVZevxxhrQc6Wp/bkUA2VHgB91S4pIy
	WqEnOt7udgfwhJVRFoSawVqeYga+WJo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gChnE+XI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 326C562D48
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD50FC2BCF7;
	Tue, 12 May 2026 14:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778596619;
	bh=T23N/ChU1TyBSEMb1nXX6ZXwE6Ou5N0n+X87B8zILMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gChnE+XIXVjHYSTSrJzhzIrChrpMfeVc28ptzi1qVaYtsdly1g0MvYt9NX8MY/SE4
	 EO5ozSd5Ddxi/+iuZAhDTPC1AhW/aYGjPNmy3pGG0JbrI/s9VnHPWryKQ/oVzEuXXn
	 +uAQ9g54Qcg2TfbrLvHqr7o35pki/UWCjqYz9s13XxTxKAYJKULE1PVtQm+06fpupq
	 b+594UHL4Tx6rh+Vc6sLVqyZOqu338vNaLH18d2uwRlIs5vvpEQ16ZKy/qzQ/y3Pzb
	 yEmcCOi8fsiL2/18Mo86a1yZDrRi6KR1wiP8UBDzDAGpOZiq3zf2kIeYuGw5HPX31o
	 Ci6a2CeYyLHvw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 06/28] mm/damon/core: introduce damon_ops->apply_probes
Date: Tue, 12 May 2026 07:36:21 -0700
Message-ID: <20260512143645.113201-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260512143645.113201-1-sj@kernel.org>
References: <20260512143645.113201-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9CD9B180009
X-Stat-Signature: o997xep3paxeufg1qk1a5xpinhmhc5e3
X-Rspam-User: 
X-HE-Tag: 1778596620-560545
X-HE-Meta: U2FsdGVkX1/hS/ENAN1Ugab6pTPyl9FP9bX48gy05o2bpBVyzdQGebcU9mnfh9h92dvjBWb8/ci8/lpZz0TWZH8LUE715N53VAU15v02pTFxcjyNEXxm0UMblWYRlUn8H18aiKVsFv7gA+276ekibICM0dm5Vlv8Eq3a0IYNZ3cyvQvx3N4+Uf9TQqNi3q6Y4FDnNd3j2p2WYeSLrxrZKjPJ+haKV/NOf9Gvz4Yrw90bGGsMnr8QqTGaMx5z/28fbp2a0EdsJfDa8l6PCbv8/Ek7gstw7mt3Ho83VuzhulPU1+KtOMWnCOZSeDHVjT7gUnCPAXwtPi5IZ9w34oXjMVTtGikIViKjWoOwTV56IrOVb1a6FawoutOGcK9dofsoerTF9z0ed42wcRu/t9yUVVpV0MN8m7RrMyo7xnNhRvNDT3hCLCD9iMApwYf14gFEHKssgpYBuGHIUFT7uDeWjo2rxqXiWbyTdX8ZaaVK21Vngewfuo1251me3dEUjolwb9qSehCDcWlGvdqYWXkpLABm9b6BzBl+kqI933WrTdSZaVyAGV+HNx3XoeHTZPlSdXG8EvIJ8LuN3KbTnmQiAkdvd0z+yuG8Ez4oPaDRnmjaoAm9lZ+dmgle6I6yw6IPn67Hse6SC1FF5huDMcKXtY2y8F0pQrD0Fklzipiz+muIypEIyDDbRpBJ2v54cv+4TJl6Gtn0ocd0OnNr0N8WSjG8pzJ1jefE3kFRPBwmNW/o5JnjQOf7CLBcQqpt7QVR9j/gET58qGYpETdPaqXYGp17hM12vSoSTmmHQ8CocgOD6woQmDsZS1l+LcELTw71WBHsyLJfkGjxWB9AhtFlf0FGo9JBNoBsXSWNwKrjlD4wS+7YU61yNl3ZqO9jFtsgqEfIzLI7K1/kHDzUtA3c+EEEJirEXNIqX4uFpjY2fQ7HUf0ts+x2kYPxZQ2qV1XXp1VvaPktvDRAmhg+F4M
 LwrNqsie
 RR+2HmZC77dxnN/JcgqQqpvbOQdocy7FNPJzPC5QDIUPbb9efpJfrzbKnwCf6rOY6QFcVC8aIh13fsxQt4kfiBc4oi4ef5folq/BqZu1ymDhvvyTdf9RitYr7w70PeQ0ngAdOq8DW6ZhWlcTrM/f9Tnn7YQ7KkrynxF30w992yBqXFa2QQmuMHnGZ96x81Niudy8LePUOcAZlPndpgLmBajucDX5ksKw8UodVl32RAg40N118gn62KuxOU4Mn/I0aSx6ey/SE3kShqCU7URTArg/+MsJhpVJ+eYt5XYnF0VJt4oUXNeceY+aGBqLfcaZcuHbVvvIef4WRFV07E660/U+MXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend damon_operations struct with a new callback, namely apply_probe.
The callback will be invoked for data attributes monitoring.  More
specifically, the callback will apply damon_probe objects to each region
and update the per-region per-probe counters for the number of
encountered probe-positive samples.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 19b780bfab051..e9ca40cdd9102 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -630,6 +630,7 @@ enum damon_ops_id {
  * @update:			Update operations-related data structures.
  * @prepare_access_checks:	Prepare next access check of target regions.
  * @check_accesses:		Check the accesses to target regions.
+ * @apply_probes:		Apply probes for each region.
  * @get_scheme_score:		Get the score of a region for a scheme.
  * @apply_scheme:		Apply a DAMON-based operation scheme.
  * @target_valid:		Determine if the target is valid.
@@ -673,6 +674,7 @@ struct damon_operations {
 	void (*update)(struct damon_ctx *context);
 	void (*prepare_access_checks)(struct damon_ctx *context);
 	unsigned int (*check_accesses)(struct damon_ctx *context);
+	void (*apply_probes)(struct damon_ctx *context);
 	int (*get_scheme_score)(struct damon_ctx *context,
 			struct damon_region *r, struct damos *scheme);
 	unsigned long (*apply_scheme)(struct damon_ctx *context,
-- 
2.47.3

