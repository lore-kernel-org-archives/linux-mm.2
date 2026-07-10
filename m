Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19E7FC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 09:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E3A36B00A7; Fri, 10 Jul 2026 05:33:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 294096B00AA; Fri, 10 Jul 2026 05:33:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1835C6B00AB; Fri, 10 Jul 2026 05:33:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E7C496B00A7
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:33:48 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 780C31A03A0
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:33:48 +0000 (UTC)
X-FDA: 84972354936.07.E53A3DB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id CFCFFC0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:33:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="J6ta/uOD";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783676026;
	b=nKbplxfkL8L35xOoT3FsAfMY+o0Foptm/ruhk8fAT9xAjOqSEYtboakqJiKoGi42iyMFbZ
	Am6TU7HDY3cHHw0NHXDInqDQEfj7ZLsKVfLbTLn/SO1pr7pO2zlxQxBkF7XzahGGJ0F96B
	qFVvNxjlGGq77qMIiP7lGo7H6YYf1k4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="J6ta/uOD";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783676026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CzdK5DKU6+BMRq52S8bVlI48gl9R/8/1tCY8E7Nw34A=;
	b=N1D1S9erH04y5GO/ZUYw0WjsNSYakSxOurmhtuRXtC86ZKWghTWYxYpuuVwxvsePaaES/s
	qbGFE0ZeL9jrEH97KPdqv90Pli7VOcMKi1LrCqizIJlIyLAO0dYeXODiYaKebU0XCXKVc2
	0ccf4fZe6nstIpcf2uo5+eTUHeaplXQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 688C261375;
	Fri, 10 Jul 2026 09:33:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB5741F00A3D;
	Fri, 10 Jul 2026 09:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783676026;
	bh=CzdK5DKU6+BMRq52S8bVlI48gl9R/8/1tCY8E7Nw34A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=J6ta/uODDijWPnjCfZTHjGhlpURPdKwlSyhurPZRKs8AJqzI6CX8MKCflYZYUiCtQ
	 EWg0uqC2uUfEfkXJxRrMj83u1rDOpeI+kApEXh8DaL4rOGx1cd/Ko5eiGXTFDQVj87
	 j2sKFAhxrT4q3KspBdHfkfa39Tzdnm/U9mPh6kcOujxURzrkjpmCJbZR3RR4On75Rd
	 R+toGr1GvxrM84BAeiGitOa13QEPgd2xzoAKFI8LOqgVBD0gB+24vFm5a4TrjLjwRN
	 JN9tdQxl5+beYSAcn38gegKaiIIWntSg22rPN/qn1jNn0K0h/5zkbGf/BDFZxQb4z6
	 Coiq/VsZSnGBQ==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 11:33:14 +0200
Subject: [PATCH v3 13/24] binfmt_misc: factor out the entry matching
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v3-13-a162f7cb58d6@kernel.org>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=2880; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ZJseZyXlJQP1+LLvZEEAv5492/nOY49aeOFV4Zt+Z7o=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQF7InbbOdkoVX25Nuav40TJtx0ef1Kd4/MOXbmayuTz
 htz688V7ihlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiI4wSG/64SIWu7O1df1Gxg
 17VlMJxz42igQ5KZx7rJXYFHlorOUWb4Z3xVfQendlNTwHSOZ5o1GwVvhqh8vOjpIKNmsiJAYdN
 lHgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: CFCFFC0005
X-Rspam-User: 
X-Stat-Signature: oo3f3rgt9e6968sgjei7zbd3wiuay44m
X-Rspamd-Server: rspam03
X-HE-Tag: 1783676026-841964
X-HE-Meta: U2FsdGVkX19gH84IaycX1wvjPappfT8Ciel42hhyB/+5HtSva3n7e+3r4BzNX7hzoOx5wFg/nZu1bM31aa1BMjVbf3Z3NLPjt4czmVst85Fou3rdCqDn6Pj3tkByUsHSNQMhU6kUxUFxpHSlhAEbHhXf7fjoxHgPS8D8MJmtvqpBquNE+3nczeSPDYcf5hD7QXdoZP8REPPcjUuNkpZaoKXuM4XwoH6gvRF+q+nJh3FYkMIL9hKGmqG078T1DQNrdPYdsdhIBr2Ukja7ibeBCmeKiiL17EJIG3tdJaxkye/8zRrRcf022Q/nbpX6762M8gtK1rQ5JY6o44vaoW9wWGAj89ArWenr1ZCuuhAI5S614JQl3kDzOVig52x/49wIVSXsMuAnKM22icZ5L7dTkXGu1LYs0c8mjbp2ZkV1SJV8SG9cIKzUjM7FZCcj1ELhcn+LSwCLnN5VwYvPyCm8q4FGDwi7OlwWxX3zOTApZADk4R3Q0/FKMYpz6QXAKY3NxEpeY1ggxhrLRHWezRmW4x9+F2Ji8AuK+qDjHCmfG0merrmpNjiFAqrC6ZACkHeRTQrL8vBPHSIchh5fo3uhIMUm0zQHVXy8ir/BaDbMaJphBDid8SK3jL8u7Arz1HX9ZZBOdj+L84mp3Mk7to96hFYz3Npcba7EkbyN7sYW/DvGmjD2bN/gHzNVE3SgfjljVV0qpaY2sKPhcbG2mtq7FJqHEnvohovMQDsPuorXKKEPU3NHhqL7FJtyy4jFa3Ci4FPPn2uwuixSo2fEh/pj9mpqWka+KeD15OqUDDmt1OWBygPD7mrPdqE7m/0n1IrnFBIGAPeyStNdwkL5yinl1q0X1UncYv6Jx+bCWku9A0piTZ+ITgnGGTqIRbl6zMt1EhL/aVUNmQ2QEVyPZTL4bUu6RKjQ3KV/tpP2yUYQz6gtA3GXZ2LXU21VodjeOqyb2evEJRCWnBCZTcmDqJs
 x6TqMehA
 6JvcOdwYiHs3U2ToeUNVWZFv0Psu9zBCGQm4z4HDXZAXSWAQ8hWWiV2wUqJCBPZy7DMvAO/kNnrqxm+/3PvwMue+sDPX7Jk4gvznigbORk62zcKQbCaxhSOsJgKCz9lPTGuqKMjn+A15CcNjcKx/ZymtfqUmoBnUb2tQCm4XFUF6bkOc3X/JceyKbM9z32Cw/60GKbmHNd+1tUfXdneGY3FYvwetEoa0PpVKJdHtLGa8kLIZzZSz3TEilRGzleJF1Uq0IPG7tDrSO0sZ7mswRjkLjSkgCMbPx6s8M+V3DCAPgkrVSfVi8+TjzKvO3sjaQgmCwnXQt+ZH2/jOjhlljQEqSCSUxEhwlFb0vyg95Li+hc+Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

search_binfmt_handler() open-codes both match types in one loop body
with the maskless magic comparison spelled as a manual xor loop that
is just memcmp() in disguise. Move the extension and magic checks
into helpers so the walk reads as policy - skip disabled entries,
match by entry type - and the maskless case actually uses memcmp().

No functional change.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 50 +++++++++++++++++++++++++++++---------------------
 1 file changed, 29 insertions(+), 21 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 23a2020d9266..6a56f40f23ae 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -78,6 +78,29 @@ static struct file_system_type bm_fs_type;
  */
 #define MAX_REGISTER_LENGTH 1920
 
+/* Check if @e's magic matches @bprm's buffer, applying the mask if set. */
+static bool entry_matches_magic(const struct binfmt_misc_entry *e,
+				const struct linux_binprm *bprm)
+{
+	const char *s = bprm->buf + e->offset;
+	int i;
+
+	if (!e->mask)
+		return !memcmp(s, e->magic, e->size);
+
+	for (i = 0; i < e->size; i++)
+		if ((s[i] ^ e->magic[i]) & e->mask[i])
+			return false;
+	return true;
+}
+
+/* Check if @e's registered extension matches @ext, NULL if there is none. */
+static bool entry_matches_extension(const struct binfmt_misc_entry *e,
+				    const char *ext)
+{
+	return ext && !strcmp(e->magic, ext);
+}
+
 /**
  * search_binfmt_handler - search for a binary handler for @bprm
  * @misc: handle to binfmt_misc instance
@@ -93,38 +116,23 @@ static struct file_system_type bm_fs_type;
 static struct binfmt_misc_entry *
 search_binfmt_handler(struct binfmt_misc *misc, struct linux_binprm *bprm)
 {
-	char *p = strrchr(bprm->interp, '.');
+	char *dot = strrchr(bprm->interp, '.');
+	const char *ext = dot ? dot + 1 : NULL;
 	struct binfmt_misc_entry *e;
 
 	/* Walk all the registered handlers. */
 	hlist_for_each_entry_rcu(e, &misc->entries, node) {
-		char *s;
-		int j;
-
 		/* Make sure this one is currently enabled. */
 		if (!test_bit(MISC_FMT_ENABLED_BIT, &e->flags))
 			continue;
 
-		/* Do matching based on extension if applicable. */
-		if (!test_bit(MISC_FMT_MAGIC_BIT, &e->flags)) {
-			if (p && !strcmp(e->magic, p + 1))
+		if (test_bit(MISC_FMT_MAGIC_BIT, &e->flags)) {
+			if (entry_matches_magic(e, bprm))
 				return e;
-			continue;
-		}
-
-		/* Do matching based on magic & mask. */
-		s = bprm->buf + e->offset;
-		if (e->mask) {
-			for (j = 0; j < e->size; j++)
-				if ((*s++ ^ e->magic[j]) & e->mask[j])
-					break;
 		} else {
-			for (j = 0; j < e->size; j++)
-				if ((*s++ ^ e->magic[j]))
-					break;
+			if (entry_matches_extension(e, ext))
+				return e;
 		}
-		if (j == e->size)
-			return e;
 	}
 
 	return NULL;

-- 
2.53.0


