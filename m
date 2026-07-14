Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6C9BC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 04:35:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE55B6B0096; Tue, 14 Jul 2026 00:34:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF88A6B009B; Tue, 14 Jul 2026 00:34:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 971E26B0099; Tue, 14 Jul 2026 00:34:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 607396B0096
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 00:34:48 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D1EC2C0242
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:34:47 +0000 (UTC)
X-FDA: 84986116614.26.42A2E92
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4890B140009
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:34:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LkEe8e3U;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784003686;
	b=XSCbA+caMMJ86TSbHzn+KiEBHxJMuKkxHHoNuDNVNfWpMR0tHN3QBS60aBuv7IOwJZVT+k
	zalDaC5LXBQpmHxIJIwJ49b4H/d6S5jo26hD98eAO9zaE8jcy4tZEVexKcnNzyCYEvH/nn
	NPqmLOYJ77OFv3f6QxeQwH/NmCuGHNE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LkEe8e3U;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784003686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nx5e31jEsyo+C5Jzh5WXWtwiWc9v5lBvS+tYDZCZe5U=;
	b=T4MHOFxZC30JseTCorchHR65K9eOqQRyMeilrf6OKbQbt8hU6HwoRuhZBKzQvhRuUKm7HT
	U61ghd/96oqQpKnzFJOWL/pebSj4ujcrWUTZyskd+dcHdr5kBFZ0hFXvf3oShsgDp25QPf
	GOyxugU/+Jz20KOc//6qvLfSZ4LNmuc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D4A35601EC
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:34:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A87B1F00A3F;
	Tue, 14 Jul 2026 04:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784003685;
	bh=Nx5e31jEsyo+C5Jzh5WXWtwiWc9v5lBvS+tYDZCZe5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LkEe8e3UTZtu/dCxbCA9jUo0qcEklu5uKbpCJX1k35d8t0paquV8tRgmoEkqPO1Ma
	 FQCWvJ0ChNjq+V2aoC86L3SFkFxnHaY7gfcFgB+9f/Udy2WkSldao2xE60CSM6bAgh
	 v+sot+OTbqguCtNuaYDQG9EOtx4+Kj4sGmvBDt3l9PvxoC6JKKMPoufbcOPpJY1MAX
	 +8SIikf9AhD2zYpEJPINKqaAARyOD6aapQwUz64A9QQ69MHX/PKhnmEQEV/OwtniN6
	 XxQKChVCZgdHzw8yTdJIxUVs0jSu5s9NY9V0FfDZj+L0L/0TjTitxX2YXkABMDuBZo
	 uSZnYBORIrBKA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 10/10] mm/damon/core: hide core-private damon_ctx fields
Date: Mon, 13 Jul 2026 21:34:36 -0700
Message-ID: <20260714043437.95811-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714043437.95811-1-sj@kernel.org>
References: <20260714043437.95811-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4890B140009
X-Stat-Signature: 5ze9p5b4ca5a7inbgitkpxb19kgu4oxs
X-HE-Tag: 1784003686-992688
X-HE-Meta: U2FsdGVkX18m00/ZcFBKQDhhjtPJakXFZbQ9CaDDIRKTXMXAXlht6gl9/TYcT6gT7FiAtiJrOS1r97CKfjAd7m+NGHIan4cvKTi/+BmRXkVdlceS48LcG25iA4f9jdsU+5zaq/UCTXMW5SA1bEYvK6aFBA/0MNst2GCbQfhinPVdxJVIoeqcGTgjCqDSDvBELFopt3LtllhnIRlubBf/KnsozgT0bkmWOBlfXMbfCWvtNPsW++x6vsCPt4cuKaWPfcLXu4UHFha0SFCJiDtA4AV0IYnj+nor7chGbsFbYBotPEecu2kPMIpNA+afSAP8AqEz5F3tEf2UTRSazimoh3WckYDCxnedRPmsPKtwa2kGcw0yRrJlJkUufHuTCMrEJlqD1AqEGEYtL6yKAn5RjO+BqNStPJDisCahnd7hlqKwiARnp+8YEOIgjsM75dGVu4Cq3Hf2KGlfLNwhzYKqPz2jw4EPKv0sOjgd8Pe/Z0G3be02h5CZYj0xfH85iL0zQxNI5erZGzgBYzwKeo/5aKvCSsRAcSJDKlmVr9ogHbnqM0YaB4+ITaTbH5vHIsdn2emf3fg05pm+y3hc66aofUEPgDE0Vxm39erLOCZARu83fd66cKRPB1+Lhn3OtNEh5SktiACfslgRrc3WIl5gCwG6qGNz/ufFkBQa3SMicE+ODzCtNx29hzsQVFS5NvkiN3M9uDX5TN9Dk78ldARqcdWPElJN08wi3mVfr3AdZjsF3/i3MvMI16z3emw5ck8DRJ8qxdohoV/ayOJGCbbCVHg155Sn7oT+9ut1A3XmWXW7QaEcH1ZDoatmaHVOplT6wfoSJFzYJ0GpawqOvkeyaj8Ku+ylcon8CvS6oME1R8WjUlQKHAmzp0xyCHSQPc24npfY+w4CflFQIBGXDnhk09OHe1ICzs+XFxottSicuIcpomK/t4ZBd0NbQftYu54+DYQ+b2bRy3P8SFY4oCh
 trAWqqd+
 P4Vh61Deq7YExgfir8dkeHTLLhNT8oRsgAHEhZvvwgKh3Y66+YuUa4/cdxwCIMhOBJyW+3rGJkn+Rz+icio4Fkk88kK004/QM/Ncq8xhb/KkRwodnsmDXsBJrPm1ACsVnTSmgsm5GxfhjOsjaA3mievz5LCXmf38vgej4BRAMtIfMovmHfwVeSS5MO6Y9cZm/VUXDbY8LO92mgf/8JyHGlGBT1KYcT/VO3nsfBTYWyjW74s3gVNw9xUxmIkymsT1iDe1cU13Oj93SweFEhEo8S0CP7COZ7w4iEODpzx2nqytxGlM33KXJl5PMFPbN/ee5gSkr0wwt1bTTC8iYwKVSE0uNCTmylktqVdHl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

'ops', 'probes', 'adaptive_targets', 'schemes', and 'rnd_state' fields
of damon_ctx are intended to be used by only the DAMON core layer.
However, those are mistakenly not marked as private.  Mark as private.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 537e59bfd7072..327f534696aa8 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -848,14 +848,9 @@ struct damon_attrs {
  * thread other than the kdamond should be made using safe DAMON APIs,
  * including damon_call() and damos_walk().
  *
- * @ops:	Set of monitoring operations for given use cases.
- * @probes:	Head of probes (&damon_probe) list.
  * @addr_unit:	Scale factor for core to ops address conversion.
  * @min_region_sz:	Minimum region size.
  * @pause:	Pause kdamond main loop.
- * @adaptive_targets:	Head of monitoring targets (&damon_target) list.
- * @schemes:		Head of schemes (&damos) list.
- * @rnd_state:	Per-ctx PRNG state for damon_rand().
  */
 struct damon_ctx {
 	struct damon_attrs attrs;
@@ -904,15 +899,21 @@ struct damon_ctx {
 	struct mutex kdamond_lock;
 
 /* public: */
-	struct damon_operations ops;
-	struct list_head probes;
 	unsigned long addr_unit;
 	unsigned long min_region_sz;
 	bool pause;
 
+/* private: */
+	/* Set of monitoring operations for given use cases. */
+	struct damon_operations ops;
+	/* Head of monitoring targets (&damon_target) list. */
 	struct list_head adaptive_targets;
+	/* Head of probes (&damon_probe) list. */
+	struct list_head probes;
+	/* Head of schemes (&damos) list. */
 	struct list_head schemes;
 
+	/* @rnd_state:	Per-ctx PRNG state for damon_rand(). */
 	struct rnd_state rnd_state;
 };
 
-- 
2.47.3

