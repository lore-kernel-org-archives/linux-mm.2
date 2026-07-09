Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F313C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 22:31:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FFFD6B00A9; Thu,  9 Jul 2026 18:30:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D8526B00AA; Thu,  9 Jul 2026 18:30:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 214FE6B00AB; Thu,  9 Jul 2026 18:30:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F0CF76B00A9
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:30:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 817FBA02F6
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:52 +0000 (UTC)
X-FDA: 84970684344.24.4178F91
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id C7D4720011
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:50 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cqF042L7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783636250;
	b=iJb7HYrb3zflPiLJ1HI2tSBsbNLLfRYjQa+uPDWEdV1eYGBCiDO9qTrA0xfmSYK6wNg23x
	Tfr+6PfAmSbEOTeMp7FFp4r4j64yqbrGh9inKZLTNEJn5/vLN+zskkilRdmUvL2B4rRwxC
	B3y1Q5BjcQpsoJUfOkxKUlkfl5qt+dY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cqF042L7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783636250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tj/MAvnir9DeW5WYFzT8Cvq+bgAVa01TFneC7nh31P0=;
	b=roe7zN9J/qLVLWtFAlxDGjtnyr+uFpMDAnp/j5lgMdXuvhQEhbNn9LAeul6PWJoFew+kax
	mAIxM1NqnDJ3xplXmdd+86G5qGAneZ+eOaGLWL8KTXfWvwR+vHM01CkhXRvVsGATbs7F8E
	c/n/iOxz9D6/cEodn88UsKKERl16tIY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 70E6661833;
	Thu,  9 Jul 2026 22:30:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06A41F000E9;
	Thu,  9 Jul 2026 22:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783636250;
	bh=Tj/MAvnir9DeW5WYFzT8Cvq+bgAVa01TFneC7nh31P0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=cqF042L7BqakCLlYwb9cXOQ2dCQjhAM1UWP4msLDijM/GmT1AWdQws+P4X1qa9+JP
	 KlBy2uBdLp039jZ+CwJ+c65qgmJn2OZdOwKami5I7u2SnZGuNszWyTyfefxrcycMMQ
	 8UxxjWjIP/Ez/199K3Mb3CdcG9BS4X96A3lOIH1A74muHU1t1U5UD9+rtTpIBKet4/
	 CBKkdIXPuudvdkzT0JhturKae3ZZvCT/LLe8J3uEZ+QNe0Q9gkllt6Ce7JNfA+yblW
	 iqulgfeXcDMPTJVzh5YWVeVyXqFQX69DEhQ9UMMhHj/5mhqDVhWmj8ZXjMLjo5CWuD
	 rMyLQxMt7lOvw==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 00:30:12 +0200
Subject: [PATCH v2 17/23] binfmt_misc: simplify check_special_flags()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v2-17-2a1c3d4126a7@kernel.org>
References: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=1679; i=brauner@kernel.org;
 h=from:subject:message-id; bh=OfGZ7AUeiJPcjTa/NY6QLIM4LTPZbuaFgV6FGA1KtY4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQFKHy7nhRstWOBmoNyDLPSOeWe2wZL+PQP6C1bX/l8+
 z3BCe8+dZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExE4DgjQ3fQ/8W7Ao9sLBAo
 nlttdiQi2j/lTzXv/4s6fBLfxKocwhkZLqev/3bJy+l4w5LNl3OqD3oel7/wv8xlmU+HSNT9rDd
 mzAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: C7D4720011
X-Rspam-User: 
X-Stat-Signature: uhb3rqhqromz7bx4os7ozea7b7os3igf
X-Rspamd-Server: rspam03
X-HE-Tag: 1783636250-889078
X-HE-Meta: U2FsdGVkX1+8P1XQQX3v/2iuUazaZ2kJahcKVP0UQTD9cuWuI/D0WBe9akGlAH1KjsgWk/kbYEaUlxvr1fZ732NoOHETXaYWxapCPuGxMzme3dyxrWh/LBhlSq6k2LlLJFDlhmhmn3YduUT8R2u2INt1rsR4vg97rWii5jVBMsmC3k4snA7YKwfmD+HX8Kt5yoUCm23JLrC9SM8dwsZtWjplJtPt1JOe/yuKmVU2wkKgGhuDJdC144QKCa+G+tx2V7B3OD0B546baryZZJDwEk+dvQXwW57TSnQrmIC3Zm8LiOXW+wX0/j6dRoD5S1nBFLa2kahWdR5nk/1Vso9VL6DnrwHlgzX5g+MbM/nFCNgy24JLfZl9lg55kVYSdUJ3a7RbU5ShPdzk2MHBhzX3WbMBznsJFvTbmWXo+LhZl7gAIpTEy3DEWLoB4STjd+crtTz5C43iG3loqrRCgQEu5i6TQ80M6OS3PVwxiWSz78s7gME4zLsAUl8r97jo0nHDn89KD1Ptl4Tnfu/+etF5/dM1zrz/FfMsxrd7T0rTOMe8/f74q1bf9z4BVFwqzI408rBXN2KRLBPHyV5Ehmm6fwGjKkgNVC2OLKEo5usjkUPm4KyPQ9yikBRIKcVj5pG8d9w99dFU+jcelI7Er9tfUkqMI0gKPe1RQqe3nf57FlQ3CaQJ6RZ7XIEOXzh/wNPBdOah9+KVMUxEsPRCZ+BbQC1/i0rKWeoMD4gPKppcFhVZoZyemTCnvWJnS3RaNVmP/XJZmjerV4smngsbHVJfwMHlohsXbV9xAGzeu7mYRiAztGE4PBZCuEcxqi/5sWFuAcg01GaeUXBBHv+2egmLJqu8v5Fgf84KJDrqdLMMIfgkMGNbRP+ZPw4EIreaZcXvxkkWXD0QiiY9TsP8qd+2CzTV8uNBhenVJLknyeO/hN0UQ3DgvlgWx71bVYh+XtZPvJXXdVj28Saps1x7h3l
 zToqn6PH
 R6iue5GyeAKEt7YQfu9O4/nWNk/tePUwUiQKCqimE/VYlareDXgbfdOnJlm31NhuScPcOrkceo+izK9AM3asmXJLpr+qxgUzk8SQFyUtaJGRwWkWGDrhoV1JYvZXLX2ZakHs04w5ZcmygxWQ8c7jgMlH7U4G/ey7kbxbS+QKRxXWlgkBQms/iq49/QsHffbdoOnYnK0Z3or1f/sp7JNR9MsVeVw2hZnV8Ld8J0N7AjYzLMM7OVzwOhXiUYT2w284DZlKEp3Tc9b6pmwEwXr6j6ow2B31x4a6mMpWR8Dcr0k5dIey1qUvBAH/oKZ/VynZoZKxOZsNcqHsenwqZolB+nRy2u1vpItRzT1Lr1xhko0N9BIc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the cont flag and the pointer increment repeated in every
case with a for loop that returns from the default case, and shrink
the multi-line 'C implies O' remark to one line.

No functional change.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 4267f66128c4..1536e398aa67 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -309,43 +309,31 @@ static char *scanarg(char *s, char del)
 	return s;
 }
 
-static char *check_special_flags(char *sfs, struct binfmt_misc_entry *e)
+static char *check_special_flags(char *p, struct binfmt_misc_entry *e)
 {
-	char *p = sfs;
-	int cont = 1;
-
-	/* special flags */
-	while (cont) {
+	for (;; p++) {
 		switch (*p) {
 		case 'P':
 			pr_debug("register: flag: P (preserve argv0)\n");
-			p++;
 			e->flags |= MISC_FMT_PRESERVE_ARGV0;
 			break;
 		case 'O':
 			pr_debug("register: flag: O (open binary)\n");
-			p++;
 			e->flags |= MISC_FMT_OPEN_BINARY;
 			break;
 		case 'C':
 			pr_debug("register: flag: C (preserve creds)\n");
-			p++;
-			/* this flags also implies the
-			   open-binary flag */
-			e->flags |= (MISC_FMT_CREDENTIALS |
-					MISC_FMT_OPEN_BINARY);
+			/* C implies O */
+			e->flags |= MISC_FMT_CREDENTIALS | MISC_FMT_OPEN_BINARY;
 			break;
 		case 'F':
 			pr_debug("register: flag: F: open interpreter file now\n");
-			p++;
 			e->flags |= MISC_FMT_OPEN_FILE;
 			break;
 		default:
-			cont = 0;
+			return p;
 		}
 	}
-
-	return p;
 }
 
 /*

-- 
2.53.0


