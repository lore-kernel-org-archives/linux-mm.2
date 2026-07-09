Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71570C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 22:30:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA1056B00A0; Thu,  9 Jul 2026 18:30:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A51626B00A1; Thu,  9 Jul 2026 18:30:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91AC66B00A2; Thu,  9 Jul 2026 18:30:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B4A36B00A0
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:30:39 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D96C7401A9
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:38 +0000 (UTC)
X-FDA: 84970683756.11.B2D9D3B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3A7EA8000C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TlLvCASp;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783636237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qWpetlqy02guy981iF+sx2R5W7hc1Y+3cQLz8oP2Az0=;
	b=ELU64LWaA1hLuivqTFz+A06KIoxJPxS2wzm+9c8/DUmdL32SwjMIRLGHNdALHX6M0EVUyf
	Hd7Bf361r/anQw0InyQyzqrSnMXCUk4m/62mGMTi05c7WMsVru/MgqhMlEMtnqW+MzmZYf
	Bctknbvtv/owrINWtjDgktCyfMS7OjI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TlLvCASp;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783636237;
	b=wQWsMIhtp81jyRdJ+KmSD1Pk5Icrsm8sjuH/r2imCUw9LPjyMhHfosGZYpZaJ2yGHI8lPY
	ncMXGk3MS5T7Jlv8ffYoAC3uC4jtleXkrYYZzNPKEUDGukGr1bcKhCJQhEKjhUFi5siSAU
	q5nAXIU+s6lrzCg+NyW/r79xFk8IdQM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D3C576138A;
	Thu,  9 Jul 2026 22:30:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252B51F00A3A;
	Thu,  9 Jul 2026 22:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783636236;
	bh=qWpetlqy02guy981iF+sx2R5W7hc1Y+3cQLz8oP2Az0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=TlLvCASp7aGXhq9FmTH92OZi2sGKbpiyHWiMOiByQymFxcb5xSQ1GFgq689LU9l40
	 7mQs0xW4xRuULr7rxqiyNVEPe6uSKPcumSm1h5hdp5APl5Ul5WdWQEIsFmZdKyAD+Z
	 wPdIcQ3jK3k4c7oLgnwTLV5WAhJ4rcZ9Zhali3bo9uvzExyx5yI80ptGe4MGRj6UJJ
	 ha28U7Us+FN1BEq2foEm9vM7RylOsxOIJjV6+NoaW0dHT/YHrMOTz+hmLNRFk6gSum
	 I4BbWPuV9C7pv4QE2TekdpkEj8F0Xsx2y2qheYe4SL83ubrOnZ/NZrBtZLg+ch6lo+
	 HsArRQg/rfYmg==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 00:30:05 +0200
Subject: [PATCH v2 10/23] binfmt_misc: use print_hex_dump_debug() for the
 register debug output
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v2-10-2a1c3d4126a7@kernel.org>
References: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=3444; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Hnx9I6YXPdW4DfS6oMHkO6Onu8cYJIsXRERI4Hns+l4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQFKHxtu5O02Ev4Xuz17Gq7WR1e06OXuhnkCLmzJxZlX
 V0ikrmko5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCKT6xj+J9z8O+OaY2qnmNyd
 zwIm7zv3FEf8ZLtfeJZrazO3d+2Zmwz/1L8wVZjN3lBRYdPaoPTvafF3yej2VcusJIU0v02OWB3
 PAAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3A7EA8000C
X-Stat-Signature: 6mbdi96xpfcdrwht9bbka8mpe8qn33e6
X-HE-Tag: 1783636237-533994
X-HE-Meta: U2FsdGVkX19EaGzelY87ROJ2H3vuJlI139GBEKWm9yaz+7UxSXXi+wtyztrhqjQLukMdY2yLKSQa0GB6nDZOg7CXpKT+6b0P66EP1TrQAeHh51TjmnKXkMGkcPk9rKn7WFzeRcAcLxfbOGHy43uFIU1KGZPtn9Ktv8Lmc9XkdLKuUFk0oqk9ldA9J6jBExk0mGW2DXm4EqSDfP3bXdrxWj2ZifyiNdS0sI5oIB0N6Vh2lEbhIZLNPnXz8Zm58heWtCcwEaAKxfK9zwNGxYDb8gAiRf3PfabIcXo0jIZqFC+Xe/v+Cz5047V9hvUBDjyF5XjhZFnWm+Q6p2pFDEyyBtnNaJUGcY/hOF3KCVskLTMN/OYEtBEIg9NN1k/jaG2yYeDooF+KErjE+ZAJNnJrj4uu0tDJyuYVaIaUloO8/d3W1Z+oN0NJwBQX+2tsyn62MzSyM2p1cFf5ynGG7TgVXJ5dCFehw1KX7dwlDfzhROvIjhQC9vNk75WRm6WHr1+uTmToKKWTraOM8IRMzhbjTSIJC75muUNfHhU3IRJmwW6in9JCJ6LQnH0n9/zrX/Yx3GC0tAxDPXmVj7wYfqI3yKZgZvuydRCfbsC1ek/WlguZ0LGtwZ1+qsf1ZxZ6SfRUHgtJrqjMH4lIoiAvWGpawmMakKsK0c2hfN9apI/Zt5UUBVrYqNkpVwFyrvCtRUODP/yTlApMlnLWeX+yzI27X0eI2mC+OamLyarj8gvvh0DJzIxsraziLs+MXqu03XGWfUD6I5IoW0yfjFYBhgry92ccFSM6lwxsfbk87H4rxpNi3b2wRNijOT5vjQGHY+pU9ux3R4N3Z0nOJpu8wVsj/12XK7Pb9YcfLTNwbcrO8uopgXHy40i5hq+PgmVTdPrB9aD2przBWrb+Xl2/BmEBm5y/JqlAssYD22jJU/6QcSayjVweFqG0hOArtWWG3C8XZZmnoS405jvy9+DM+hZ
 gpxTOlGZ
 0rkf43VaFBBiUc85gfopIW1lD9t2/cqG+kO3xy8DEzaAYQOfVxO+WYd+80rvM14PlvkYFmS5PxnGJDXZB5mcYYm+hqXf8Bz7pcbNemKxJFL0pnqdSmY9XjAcqcoS3JtbAj8+h3ngrqhejqQirL7pKdBFQHURW45uABXyU/3zl5xE9fJVAeDOszmAwzqjYEXCh8AqucvdWhJGDnMVrhhLqPuG8b6c19lsMe6xHw0GDMYXM+7s49LWFezpVv0gqoUbUGpBXud2EK/KJWngjt13rxlPJ1iJTZ9AE3MvKqTDFbrK01Nojb7CtzMODIvJvcQuMa8Kk7+lStft06o2M4Yvem9u4QpR9niXOiDjBBC2Y5ryxh55uFx/BySLlSQ==
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
index 947ef6dfd55b..2ac82925b8ed 100644
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
@@ -456,10 +450,9 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
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
@@ -469,10 +462,12 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
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
@@ -488,30 +483,13 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
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


