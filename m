Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6CDDC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 09:34:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE3CD6B00A4; Fri, 10 Jul 2026 05:33:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B94DE6B00A5; Fri, 10 Jul 2026 05:33:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD2366B00A6; Fri, 10 Jul 2026 05:33:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8ED826B00A4
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:33:45 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 271DE403C9
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:33:45 +0000 (UTC)
X-FDA: 84972354810.21.52E1000
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 50A82C0002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:33:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KwnQ+sHz;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783676023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZzgT+NAn5jg3W3R0UKNJyOYlRco2bIMUb8glGg/yjWM=;
	b=AxGYIPehIgHsd9GtqaPMzkUl/Gq8XimgK89bmBh4Ly01lo6ryvN7iameg4caP/MZXLvggN
	W+VjpXklGGpJLr4g3eydNDq3wVrw+iJzuSg+unNslYQrI4IE1TpGCAJ+LR6KovX+yTsvvI
	CCxkVBj42VXH/QNZvBru50hLGT37JdI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783676023;
	b=hcv9ZZqRhmb+jmY7wQOFFNdvXQn4R515zeWKeGL/M3/9dr0bl0vrxCoHSH/MJ9MA/OGTm/
	IqRakLDfKD2XyTDmT1ovw6GSbwSwv/87FsWStYwoiVnizEy5ro6d8i+ZUyq5Gl999ZIQBf
	B02RFGtgbsgYY0bvLDyL55nhTT66wJA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KwnQ+sHz;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 95D8B43D83;
	Fri, 10 Jul 2026 09:33:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D99ED1F00A3E;
	Fri, 10 Jul 2026 09:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783676022;
	bh=ZzgT+NAn5jg3W3R0UKNJyOYlRco2bIMUb8glGg/yjWM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KwnQ+sHzG6+1jWd/4tnB6t8x1UofEX+ReHrYe5lDYLHCElLACmJYl5V8U3BoW7Tsj
	 4i8hAXcWqUx9fjNNapMTwGUm2tygYj3A46eYVgsH5GQ6a5cjd/L/pMbw+K+suFsfsn
	 26+0mTqnb5AZtaHMMI933hp/JcgiqNudQ6gWw38MNYP5LUYVMwnqXJdIEpd/XswJgZ
	 yLOqUPkix1hoKepvTqPYbkd+BGrGOTpmYayeTqez6CQgr9smeGDxUSUt1npVIDXIWc
	 QZtX7AjqnlJ9rQcrsoa6511mppnbnKdQufv1fJCIDdffCCpLMgY+u4Dbwz+unN9vlJ
	 EST0z2xzW80SQ==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 11:33:12 +0200
Subject: [PATCH v3 11/24] binfmt_misc: use print_hex_dump_debug() for the
 register debug output
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v3-11-a162f7cb58d6@kernel.org>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=3444; i=brauner@kernel.org;
 h=from:subject:message-id; bh=oOA9u8v9W3WVNuPiNiYwV6QBxJ629SxKoIUve4uHjjM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQF7Ilr92rfvCTxyMR7ZzNlV8S+7t2svf+Cc/rJ00dZ4
 nxORFYWdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEwkSIGR4Z1a/xHZJE7nI4vv
 HLLWCTihPVdLeKL0pgtvbK56Gm648IKRofex6Y3KFi2BjhPHjbM+6//yWsz3M1lT4ekc3ZMtXpy
 yLAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 50A82C0002
X-Stat-Signature: aqgsocd6feqzzesri3kq3w6jjc3npgw1
X-HE-Tag: 1783676023-789893
X-HE-Meta: U2FsdGVkX1+uiJJQbC28Gbfdvc3NykESA/a2HR1i81m5EB8E+kb+aur47NNNH7k4bae9ymg4wUryw2EEq5vU5XOX+mgdqT8GslFMJqeq1RanGA0YlC6qMtc/9H3Js4KI01JFIxwYQo/w3MZpi01l6nGDHBpZ/RBH/WLirmBzuaOdhAL/NSpzzAZjdSGEVbblbUIDF5JJLqV51pWYdf/1ml4KzoDkACXMjTgtG2Qjh5BVViXKuTMRfvaHfJ8ZETbrtjgIBHBjDx06sBs4p04tqj/ScdsZOblwiY5PS4BbEnZP/o3PQomxm69ZT5xufRggk7A0Mqk3EF79fnvIuhD5IL7+2oVH4WxRBMD990t+FaBGqchY9HQk6e9l17tkhjc69aATISzLhw6Zap5hfLD/5GZuWWb+xKLW47UsJHMjd9Mcmu+Aj8vhyyrfmiMO2X7RGecW18Wdu2JxqD59+EEx7c/RM4VnLOrXWA3TFbm+s3LlFRx+vx677cGOTKdedtoNZizkUJ0n7/9tHItqlBokxQMkNFot7l1fiIbEIz3lqPxrXV3bdXBmnOpHvodZhyNG2HuRu1VKzf6p161/3fCEJa0CXR83ylmAuWedtMFSD8tsTmy09wgm6Gv1l5ffXky6+brLrHZ21WD4Mb4Q5iFb+ZH6Kg0JpGoqTEhjOdwvB7kO4zZgMNqzZHkIXzwLdgvucz379ERttOrnx//bzI8PXA1nBTcS3AoGRFKnrTu5PSNvTy9R/ot+a0d4ZoA1PYa0/N7/0gcgA8JFWEL8R/golQfRMRSq0XLpSU6cUPeSZ8fwIXTiDDfHZmTWmwlyxNl4EEBaMFsznbVURdGSnVwTfyuY/Jn3UJb2U8z0Y3NORxwvmESeKsifNX/AtbQvNIiAHtTBdwqMPadYTkwN2TEMX1y4ZlsAgaxa4z7uPEm5QxVXSoKpW0pO+JcJKaZqfSPvTY5zYGmPlyp8Wr14Irr
 Tdnh/V3Q
 LiQdLC+SeZPMMUeOWDzmyPgnGy2k4E2+owg4BJtxVQnc7pjL2sm8Cv+HhLnVObMHrupyXVZID6kYpELwfC7lSAiWdTFwE8YFp+Slz4cLHA2IxEP6MqgAWEnifJz5rTXtIKnEZJc35XXNzc2hEDV08DxZKZWRycWvTmENm4HzYlJzcRd8I7OplrJIudwc999G+ueY7v9YJvGJAlqNFcWhbL9v7qgKEiS+KoNTG+nOq3eL+lGsIHwFd6ldNRMkeUwo6bHsxbKYcT7pLxIbaVOJvNprQYgr9GIOkF6IikDHsNjH5+VxFgNZWi07mUzP3+J10D7n5FWrvDtGLIY7ajSqN86MH1Wgbr4FCG6ZvpDtPKhaPqm0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The hex dumps in create_entry() are compiled out unless someone edits
the file to define DEBUG while the pr_debug() calls right next to
them are dynamic-debug aware. Switch the dumps to
print_hex_dump_debug() which follows the same rules as pr_debug() so
the register parsing debug output is uniformly controlled through
dynamic debug, and remove the USE_DEBUG machinery.

Drop the magic[masked] dump instead of converting it: it printed the
bitwise AND of two buffers dumped right above it and required a
temporary allocation on every registration just to recompute what
the reader can derive from the magic and mask dumps directly.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 52 +++++++++++++++-------------------------------------
 1 file changed, 15 insertions(+), 37 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 96f9ac752511..252e1f2a8347 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -32,12 +32,6 @@
 
 #include "internal.h"
 
-#ifdef DEBUG
-# define USE_DEBUG 1
-#else
-# define USE_DEBUG 0
-#endif
-
 /* Entry status and match type bit numbers. */
 enum binfmt_misc_entry_bits {
 	MISC_FMT_ENABLED_BIT	= 0,
@@ -460,10 +454,9 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
 			goto einval;
 		if (!e->magic[0])
 			goto einval;
-		if (USE_DEBUG)
-			print_hex_dump_bytes(
-				KBUILD_MODNAME ": register: magic[raw]: ",
-				DUMP_PREFIX_NONE, e->magic, p - e->magic);
+		print_hex_dump_debug(
+			KBUILD_MODNAME ": register: magic[raw]: ",
+			DUMP_PREFIX_NONE, 16, 1, e->magic, p - e->magic, true);
 
 		/* Parse the 'mask' field. */
 		e->mask = p;
@@ -473,10 +466,12 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
 		if (!e->mask[0]) {
 			e->mask = NULL;
 			pr_debug("register:  mask[raw]: none\n");
-		} else if (USE_DEBUG)
-			print_hex_dump_bytes(
+		} else {
+			print_hex_dump_debug(
 				KBUILD_MODNAME ": register:  mask[raw]: ",
-				DUMP_PREFIX_NONE, e->mask, p - e->mask);
+				DUMP_PREFIX_NONE, 16, 1, e->mask, p - e->mask,
+				true);
+		}
 
 		/*
 		 * Decode the magic & mask fields.
@@ -492,30 +487,13 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
 		    BINPRM_BUF_SIZE - e->size < e->offset)
 			goto einval;
 		pr_debug("register: magic/mask length: %i\n", e->size);
-		if (USE_DEBUG) {
-			print_hex_dump_bytes(
-				KBUILD_MODNAME ": register: magic[decoded]: ",
-				DUMP_PREFIX_NONE, e->magic, e->size);
-
-			if (e->mask) {
-				int i;
-				char *masked = kmalloc(e->size, GFP_KERNEL_ACCOUNT);
-
-				print_hex_dump_bytes(
-					KBUILD_MODNAME ": register:  mask[decoded]: ",
-					DUMP_PREFIX_NONE, e->mask, e->size);
-
-				if (masked) {
-					for (i = 0; i < e->size; ++i)
-						masked[i] = e->magic[i] & e->mask[i];
-					print_hex_dump_bytes(
-						KBUILD_MODNAME ": register:  magic[masked]: ",
-						DUMP_PREFIX_NONE, masked, e->size);
-
-					kfree(masked);
-				}
-			}
-		}
+		print_hex_dump_debug(
+			KBUILD_MODNAME ": register: magic[decoded]: ",
+			DUMP_PREFIX_NONE, 16, 1, e->magic, e->size, true);
+		if (e->mask)
+			print_hex_dump_debug(
+				KBUILD_MODNAME ": register:  mask[decoded]: ",
+				DUMP_PREFIX_NONE, 16, 1, e->mask, e->size, true);
 	} else {
 		/* Handle the 'E' (extension) format. */
 

-- 
2.53.0


