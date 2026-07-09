Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF2F9C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 22:31:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E2D56B00A4; Thu,  9 Jul 2026 18:30:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 744FF6B00A5; Thu,  9 Jul 2026 18:30:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6815F6B00A6; Thu,  9 Jul 2026 18:30:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 398A06B00A4
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:30:47 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8A913120311
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:46 +0000 (UTC)
X-FDA: 84970684092.06.F6C5BCC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id BD98340014
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MwLjnXSf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783636244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mmi4ph+oWqWXEOWD3R7tpRATe6i/+o09C72s6qL5Zwc=;
	b=pg/VYBgfbXF/PwGzoKxGmi8Hf9U1NZ9DU/dV5og6EebkhlMFyZf4u/+clory+olLBMJFJn
	HO9YieW0ByFzyTDPr+xuuhGBU8/yF+aByq7SJMzcpI4hOY7APP7B/wg54Q7ONBm3N4j3WJ
	bPrV1PCfKaMMKBwD8v9Qhku9nSli0/s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MwLjnXSf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783636244;
	b=ZZUdUXBrm5jfeGYXnPf2hQv9frBlzgE44pnGyW9BP1DhBYYBt3B4l4zpuiZlFHE5ueGDuB
	SO3wFFSq2U5qyiE/3N32MWEHh61jlcjguTgZ9+F9E3v2E2S1CWp5PLv0iDVdV5f6IOhkrC
	lZbDNU7zKBHlBd0oIqLS7DVBlAHelsw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C94B40E13;
	Thu,  9 Jul 2026 22:30:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA4A1F00A3D;
	Thu,  9 Jul 2026 22:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783636243;
	bh=mmi4ph+oWqWXEOWD3R7tpRATe6i/+o09C72s6qL5Zwc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MwLjnXSfviTLdq9jtCBRjJ7TPc9rArvu5BF3yFxT0cBqG9x+tyTogp3Lc1qhqh69z
	 uFYHFpG+VHxUsHihLc2TEeIMZaNdOTaRKyPVSaaCG2ZWqWjAG8ECUTigaHOf7wnTnf
	 RAAQ+ZzkPvmTAXk3o0B57Ycpi0EQNrzDRjbTKeRFb2Glgyi/RixYR+X/IhBEPyJjra
	 LRgi9kiXOjL1vTXk/wXBk0JScPth0gyJ+zmDjjpZI32zSvraREHR9k3aGPRouVwKIO
	 jb0cgkDx1MUX21IY4W2XWSqg9/GOSjWSkAnMoSoOA9yTPnikigu2dz0CxtaZg5e4BE
	 PD2T3jkLXTXUQ==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 00:30:09 +0200
Subject: [PATCH v2 14/23] binfmt_misc: return errors directly in
 load_misc_binary()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v2-14-2a1c3d4126a7@kernel.org>
References: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=3789; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Ll2FrYd9HjDHtPC5X13nUkIPqoyZg+Kg0S/zH98yQME=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQFKHzl8J5u+SBfcfE922cCkXozTteofjMx471atNDmk
 9WfhYeLOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZSdJLhf3C21+HtRWVMAjEt
 0dIzVh4/P+tB6Ubj4k5h1sMqB0tkWRj+mcwJaOypT58RU+zIkSes+fni8QOflnZcySh92Lbz/+/
 f3AA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BD98340014
X-Stat-Signature: 4esnwosakddfgz3eqoif7c8s17753oox
X-Rspam-User: 
X-HE-Tag: 1783636244-717475
X-HE-Meta: U2FsdGVkX1/g5dOthlEw7M0iL3wvfv3HbGNqnxJyc77RSt6JcFdbPCtDEbedPkphu7WCc6XTGzUEJj44iCqlH4gEtgvz0yixRie45VI7Eb+XJ6YwfH3s300MQ41ovSDoiemGzQd+yzSDfW7XPtukTAzX9msmZr9TsE+XRGqvfq9ZOwXQxbX7vvyczjefYRcoWE8vJdejMrl3u0lIoqB+AvkcjE4icnIAD+rZosaPdzQD2F94LtimguGeMCaGLXSJ/1gzA5tz3V6p3FljrZxFSXJeKJYGO2+HCXuaoyBgtn8fVamtCQfJfw1hE6cBpk5M6XQHbS9wwk0hx4t7FaHTjwgX/8OKWiEdJr/rzzZBXP0dKLYMK4DZDYzeYO9qqFLnqTRpIi4qZwkmoYVy1SgRHWSITRZ00rxz6BsksLaMpWqsirCjRqzdWVtOi2pLsKElaZwiKSyiRWyz6xBQ2OLGW6YBEBcPpHaRHTlqwnKa0P6JYFDRTakR4EejBEDClpZZy63CmwikKJu2ZeL+Zq94pC2Kyk/227hksK4J/gATEa0q8stMCZV6aq6ebhrU0kbGlznPyXYCedw9fdSRvE1xeCWvqIr/tSx62HOfp2/DNIravtXlFVw6vrwA/Mut5eKmMpIciwyUyM+RBcOFPtWAVujoMJ95yLqHo8Mn/7VD4nXmwyrAJLuTX/4q7taLmX6tRL8rBjhkUqch9bLzl02OTcpT5iu6DEej1d3Bs3y51Mntu1VW70vv2yTwrR2o3Qqn5me3D88qEmSeRNJLE6c2Q/47TmOo8B6bTJBOl7gibmb3SiiCxSDOISk6/i6yIyfZqRfE4HgNivfnaPaU995eiO3pGKd+mdnQyxLrxUccG/COps3B1H0b8d/ICA4YTehmdk7jWpFfXJ7uHPY336DVKs7EMcB57gEBx16f75UzwEYnJLMUIn+6gPQjDDDpZP09BBUOTivKWKueodO4BgJ
 rPIWZRNt
 Al9/p5peCSlgXFu8JcyxcSECS4n76EHcoXXQ4kdFI4XIGdRiULi1/BCEPkKdAhAS0KYFOoKiXtKcL+GzsDESnvgvYYQdcQisHNQ9BGPClbwklCDPWIxnZmWQVMMwXryCHABvTZWHMWRHKlbznaSRi9lNjlFkImSEfh7g4/Rqi2NJZKu3/wb41I5l0dq9CLGL1F0O/viEyQoRlKNWP6xxJVag6yuqLLnghB0xCYJggnYkByA/WUr8fxSG9v3Vh6mbgqQPx8nZZvx+MnU1R6R0/8TJVfLhrOlD5MuuDOojh1saPxUVxYisgWkzF6xJlFW7qfwFqw9SGJ7/4F3mMDIP9oh0h3Bqj6XdjQhQH7jMcwcmYbsrHw4xdqqJ2ch+Dkcun4OOc+54QQK81k6L7UzKor0fOLoaKOpqgfGCis3mgqx94HSg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

load_misc_binary() seeds retval with the error for checks that
happen further down, reassigns it along the way and funnels every
exit through a ret label whose only job is dropping the entry
reference, so figuring out what an early return actually returns
means replaying the assignment history. Give put_binfmt_handler() a
cleanup class and take the reference with __free() so every failure
can return its error right where the condition is checked. The
comment at the label restated what the put_binfmt_handler()
kernel-doc already explains, it goes with the label. Drop the dead
NULL initialization of interp_file which is assigned on all paths
before use.

No functional change.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 41 ++++++++++++++---------------------------
 1 file changed, 14 insertions(+), 27 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index ac2276eeff4e..4172c0937161 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -183,6 +183,8 @@ static void put_binfmt_handler(struct binfmt_misc_entry *e)
 	}
 }
 
+DEFINE_FREE(put_binfmt_handler, struct binfmt_misc_entry *, if (_T) put_binfmt_handler(_T))
+
 /**
  * current_binfmt_misc - get the binfmt_misc instance of the caller's user namespace
  *
@@ -215,30 +217,29 @@ static struct binfmt_misc *current_binfmt_misc(void)
  */
 static int load_misc_binary(struct linux_binprm *bprm)
 {
-	struct binfmt_misc_entry *fmt;
-	struct file *interp_file = NULL;
-	int retval = -ENOEXEC;
+	struct binfmt_misc_entry *fmt __free(put_binfmt_handler) = NULL;
+	struct file *interp_file;
 	struct binfmt_misc *misc;
+	int retval;
 
 	misc = current_binfmt_misc();
 	if (!READ_ONCE(misc->enabled))
-		return retval;
+		return -ENOEXEC;
 
 	fmt = get_binfmt_handler(misc, bprm);
 	if (!fmt)
-		return retval;
+		return -ENOEXEC;
 
 	/* Need to be able to load the file after exec */
-	retval = -ENOENT;
 	if (bprm->interp_flags & BINPRM_FLAGS_PATH_INACCESSIBLE)
-		goto ret;
+		return -ENOENT;
 
 	if (fmt->flags & MISC_FMT_PRESERVE_ARGV0) {
 		bprm->interp_flags |= BINPRM_FLAGS_PRESERVE_ARGV0;
 	} else {
 		retval = remove_arg_zero(bprm);
 		if (retval)
-			goto ret;
+			return retval;
 	}
 
 	if (fmt->flags & MISC_FMT_OPEN_BINARY)
@@ -247,19 +248,19 @@ static int load_misc_binary(struct linux_binprm *bprm)
 	/* make argv[1] be the path to the binary */
 	retval = copy_string_kernel(bprm->interp, bprm);
 	if (retval < 0)
-		goto ret;
+		return retval;
 	bprm->argc++;
 
 	/* add the interp as argv[0] */
 	retval = copy_string_kernel(fmt->interpreter, bprm);
 	if (retval < 0)
-		goto ret;
+		return retval;
 	bprm->argc++;
 
 	/* Update interp in case binfmt_script needs it. */
 	retval = bprm_change_interp(fmt->interpreter, bprm);
 	if (retval < 0)
-		goto ret;
+		return retval;
 
 	if (fmt->flags & MISC_FMT_OPEN_FILE) {
 		interp_file = file_clone_open(fmt->interp_file);
@@ -274,27 +275,13 @@ static int load_misc_binary(struct linux_binprm *bprm)
 	} else {
 		interp_file = open_exec(fmt->interpreter);
 	}
-	retval = PTR_ERR(interp_file);
 	if (IS_ERR(interp_file))
-		goto ret;
+		return PTR_ERR(interp_file);
 
 	bprm->interpreter = interp_file;
 	if (fmt->flags & MISC_FMT_CREDENTIALS)
 		bprm->execfd_creds = 1;
-
-	retval = 0;
-ret:
-
-	/*
-	 * If we actually put the entry here all concurrent calls to
-	 * load_misc_binary() will have finished. We also know
-	 * that for the refcount to be zero someone must have concurently
-	 * removed the binary type handler from the list and it's our job to
-	 * free it.
-	 */
-	put_binfmt_handler(fmt);
-
-	return retval;
+	return 0;
 }
 
 /* Command parsers */

-- 
2.53.0


