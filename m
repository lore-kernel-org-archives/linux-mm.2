Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25BB2CD37AC
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 18:03:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73B416B00A4; Wed, 13 May 2026 14:03:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EC036B00A5; Wed, 13 May 2026 14:03:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6016F6B00A7; Wed, 13 May 2026 14:03:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4E84E6B00A4
	for <linux-mm@kvack.org>; Wed, 13 May 2026 14:03:26 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E14871C0336
	for <linux-mm@kvack.org>; Wed, 13 May 2026 18:03:25 +0000 (UTC)
X-FDA: 84763168770.26.979851B
Received: from smtp-8faa.mail.infomaniak.ch (smtp-8faa.mail.infomaniak.ch [83.166.143.170])
	by imf02.hostedemail.com (Postfix) with ESMTP id BC58F80015
	for <linux-mm@kvack.org>; Wed, 13 May 2026 18:03:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=digikod.net header.s=20191114 header.b=ZPCUlHfb;
	spf=pass (imf02.hostedemail.com: domain of mic@digikod.net designates 83.166.143.170 as permitted sender) smtp.mailfrom=mic@digikod.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778695404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mclFFKGGnbizHqmLBIHp3Fcf5dqJ+s7rVzaIH0vByhM=;
	b=K11rBjsGmtMGyWDtewCjnIaAme8DTH9jbdqpUjxCjIvFqTxiRgxyq4efypqd3b52fKol0y
	J//44dpWrV1DitQBeF3ebllV1kV8H/bLW5dvAM2vRmRb+XgKmB5ooYKnFL3gE3izgWB0BX
	fMtaTbpEsqDy9JRLxLfDj4I4oq/mCTU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=digikod.net header.s=20191114 header.b=ZPCUlHfb;
	spf=pass (imf02.hostedemail.com: domain of mic@digikod.net designates 83.166.143.170 as permitted sender) smtp.mailfrom=mic@digikod.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778695404; a=rsa-sha256;
	cv=none;
	b=32bQ4enxzrafFcbqt+8MBnE/AYlejFoqVHkQVq9PoErJzwDocgwAkQS3WplzQxXd87aeJ1
	8VeWLY0XllCp/NR/ZDcD9wL7QKB2N6/tc1C2Ez9xLxPhN/PEmO5XtwWOYwfGots7CJG2Ks
	LFAID6nFjD6APKyhPi7HuS9M1qLh100=
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [IPv6:2001:1600:4:17::246c])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4gG1Xn6QQLzwSh;
	Wed, 13 May 2026 20:03:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1778695401;
	bh=mclFFKGGnbizHqmLBIHp3Fcf5dqJ+s7rVzaIH0vByhM=;
	h=From:To:Cc:Subject:Date:From;
	b=ZPCUlHfbpFTOxFuK6DgPBvQBCic0eprYaVFU/1KWotdo1ZD0+NkIvsqtYGi6uZg2Y
	 BzHMLrBrFxpFvt2jLYtnB5RqEAq6T3pGH1xR9+jSJSkT+L/ZByI8oem1iovUL1hgl5
	 E/TrPSHbihMIILci7XKdKwBY+a2NJQmA1tZLRA1Q=
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4gG1Xl50qZzCpy;
	Wed, 13 May 2026 20:03:19 +0200 (CEST)
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: =?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	linux-security-module@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	Paul Moore <paul@paul-moore.com>,
	stable@vger.kernel.org
Subject: [PATCH v1] landlock: Account all audit data allocations to user space
Date: Wed, 13 May 2026 20:03:08 +0200
Message-ID: <20260513180309.165840-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
X-Stat-Signature: 95mweurxqs1mrsfqg9d6dyqn5s3e9w4x
X-Rspamd-Queue-Id: BC58F80015
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778695403-675602
X-HE-Meta: U2FsdGVkX19MlSlHGbOqOY0eJIdFEn/i1vRZONDwYdyQRNOaBmMd172BFF9GxwmCEV4ktmukI1eD6WmdgBsYtVm5/RTIwShR1Iw7564e12Ts7BQLE7XxpSRXi0ADaEzsPkINcF2prvOjA1VO5t3+k1RxbGa4n+mzzwHiP5afnz8b06TR6t8HEWlYmjGTYkF4UVpr9sSK6ynv0k7aEFXTQaXvWgr2/kw/20Ltgkb/+CKWoffQQ6aV+hKHap21YiUVz2xC4/Z6craWW4vS2qubNfw4vC0bvtOxfDBNXg6bytV4tVqARJYywyMudxKdlxq9t7RlPv8eSaZH9GzrELr69RIIRKO3ulOGU42WS/llndnJ1ftrzjcIC5v+NVu8vmattJ1tUanVmPb592YtDybFy8nqvu4F8vQ7uMrmVW4eIySkg/NoX5HbL9VMDPGJqYc+ADctb9oPNmUsWeflaYkb4FSZbxvN/eCRaz9YFLM8J3AVtkQoqoP4xK/tsStm2rWnMK/hCRsoJlE14KcNUIzMVwUrCU5myElg/QjDHcZxaluYULTfepvP5sEXki/m2c3TaXxMugqCNdqCJp/jm2fNcNhr4577ft6Hw5Z5H1Ezb/qgTkhNG1I0G7VmrXyesmF83QX90x+v1YlQJzP4qiCtB5qTP2EpxDcckoS9R4FH9RUso0G4JpRy+bKPS1FDtJ/v2/Kj1xWc3+51RiCZb+b9/IaCjCIrjfqiSowB91NgxF7GY+Qo8JLQb56b42INnmH0IySObDY0GvY6dRETQClB0YK5liz7HCps42/VERkureqqGcc0YlhOqsCpIEwfVZIooVNSKdAzR26roQYBn3g/0ExgyUQj+s3ALM85tFzlS/7Tj7UbEPhm+xMbBLFZar4aSKSWs4gQKhV4eJc87bc/1qjsLoa/G/u7P27t6GTck8Xy7dZicaTGPTfZIQEA5a3k7Ucd+3WHtCnRd2BLgXC
 d2Wan1zi
 Povwa7Uk9STYmiyoZ3+reaG8tnQZV+TBiVp4VkWyIqIYyjOI2AyV6QFqmiBivmdNEd9/OIMyoMx3xSet0tfbRfG//hMcBp0D2VslloQoh6E2L82QtBkTXPJ67belopwSRndIagmpjMLhVTDcZHgBMmPW7BKfcLZN7OVsZ41+TU/NxcSI9SUImndp7qkoE1vFO1xk//Dx9YVDmMMl4YM5SpkvxZbB6yIK4agdbHfA6fOdKb74wLF4d7O9MKg7YqG+7TVgXRhdxk0p0P+eHyr+M7f11kH6quiLfU/ZYjBGM971RHCcl8fJBOEU7mT8aVc+aTWJiHFn7pl46qV2rVblokHkC7qpgldTg5adbhfP4pXTKFy3nGcNO1b8fijARkNzyMfDW7z4CMHp6urYtnF67iFs4Q8U/Pd4N4mLLrvQJpME/ewzdpILwkjCZ+Q01U0vbec8aLOuioo9bZOE8jT/KNCOlSfll9NGAuSJt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mark the kzalloc_flex() of struct landlock_details with
GFP_KERNEL_ACCOUNT so the allocation is charged to the calling task,
like the other Landlock per-domain allocations which have used
GFP_KERNEL_ACCOUNT forever.

Every property of landlock_details is caller-attributable: allocated by
landlock_restrict_self(2), owned by the caller's landlock_hierarchy,
contents are the caller's pid, uid, comm, and exe_path, lifetime bounded
by the caller's domain.  While the caller may not know nor control the
size of this allocation (i.e. exe_path), this data should still be
accounted for it.

The deciding factor is whether userspace can trigger the allocation, not
whether the size of the data is known nor controlled by the caller.
This aligns with the kmemcg accounting policy established by commit
5d097056c9a0 ("kmemcg: account certain kmem allocations to memcg").

No new failure modes: the hierarchy and ruleset are allocated before
details and are already accounted, so landlock_restrict_self(2) already
returns -ENOMEM under memcg pressure.  This change widens that existing
failure window slightly; it does not introduce a new error code.

Cc: Günther Noack <gnoack@google.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: stable@vger.kernel.org
Fixes: 1d636984e088 ("landlock: Add AUDIT_LANDLOCK_DOMAIN and log domain status")
Signed-off-by: Mickaël Salaün <mic@digikod.net>
---
 security/landlock/domain.c | 9 +++++----
 security/landlock/domain.h | 5 +----
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/security/landlock/domain.c b/security/landlock/domain.c
index 06b6bd845060..5dd06f7c2312 100644
--- a/security/landlock/domain.c
+++ b/security/landlock/domain.c
@@ -90,11 +90,12 @@ static struct landlock_details *get_current_details(void)
 		return ERR_CAST(buffer);
 
 	/*
-	 * Create the new details according to the path's length.  Do not
-	 * allocate with GFP_KERNEL_ACCOUNT because it is independent from the
-	 * caller.
+	 * Create the new details according to the path's length.  Account
+	 * to the calling task's memcg, like the other Landlock per-domain
+	 * allocations, even if it may not control the related size.
 	 */
-	details = kzalloc_flex(*details, exe_path, path_size);
+	details =
+		kzalloc_flex(*details, exe_path, path_size, GFP_KERNEL_ACCOUNT);
 	if (!details)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/security/landlock/domain.h b/security/landlock/domain.h
index a9d57db0120d..35cac8f6daee 100644
--- a/security/landlock/domain.h
+++ b/security/landlock/domain.h
@@ -33,10 +33,7 @@ enum landlock_log_status {
  * Rarely accessed, mainly when logging the first domain's denial.
  *
  * The contained pointers are initialized at the domain creation time and never
- * changed again.  Contrary to most other Landlock object types, this one is
- * not allocated with GFP_KERNEL_ACCOUNT because its size may not be under the
- * caller's control (e.g. unknown exe_path) and the data is not explicitly
- * requested nor used by tasks.
+ * changed again.
  */
 struct landlock_details {
 	/**
-- 
2.54.0


