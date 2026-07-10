Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 370EEC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 09:34:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F9DD6B00AB; Fri, 10 Jul 2026 05:33:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D16F6B00AC; Fri, 10 Jul 2026 05:33:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C0896B00AD; Fri, 10 Jul 2026 05:33:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D71F36B00AB
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:33:52 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 52F651C8987
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:33:52 +0000 (UTC)
X-FDA: 84972355104.06.92A003D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8F1F220004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:33:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DD3T941K;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783676030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bY/IkBdMAIEfddN2BADd+7Pjk9lYCu7pWA7slAVG+oM=;
	b=ikRga0q7+kwcU2ntTAIJKyXiY/qF3Tgi9C4Ais5V8XLo74oKhMl7toRaNtbH6l+SYrYvmy
	8aTLypw5gJaR8bTTGOG31Zg3dOPt9slsm47uoGSTXLZUIHSaxA4A+nJdyOI02iON1yzyFZ
	3JqwOc1jsnGjYymI7p1OI6myULnnWsQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DD3T941K;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783676030;
	b=XnLoNHxWod3bRyQvbtLWnqnaNris2kdSLd3yQd4kBoru/dMUEpLCQPBPcBXBuT81oEYTxH
	pJElkUtR84REaN0Ma8rkjlJzbxcOO/PWHsTXNGOXkhoUwVB9UkGRI2MYtp5RKb1TD/Z2nF
	4ICe56Ct0vbTmeNl15lewv3Y+R8y1kg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DB512435C0;
	Fri, 10 Jul 2026 09:33:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 628021F00A3A;
	Fri, 10 Jul 2026 09:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783676029;
	bh=bY/IkBdMAIEfddN2BADd+7Pjk9lYCu7pWA7slAVG+oM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=DD3T941KgTOkCLLvij8xkEatOd1D+ZXdtRwvQNX4m1oTUB8mTjGFggS1W8l5p7XdE
	 MURrHv2tXfEoZSszFNFNVUvBXed/3Y104bogmRI9Mw0Asntgnb79pwIx73ex2RJ8Ae
	 2VA5a3nRwj3563jKSLhLLQeJCgTqJx5qXziYAT3+NVSBpdl22o/bPFdAKCT8oUiU2f
	 59f6hTebI5W9+IkLCcKqdYbYtOkKvFS6v7JLRqyt8mlSle6mrak+4V1nj/2Iy0pmQl
	 +rzVECsTvpfYMyT2cuuJXrgaicIp07r/OxClF3pu3zcK8qk+UXwv1HBo/W8+f7QpqG
	 FI8fqpQga7kxg==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 11:33:16 +0200
Subject: [PATCH v3 15/24] binfmt_misc: return errors directly in
 load_misc_binary()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v3-15-a162f7cb58d6@kernel.org>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=3789; i=brauner@kernel.org;
 h=from:subject:message-id; bh=qqm2eAOnpJr7SnNA4N7fHD6KqzuTB+1Y/9elatuqZGg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQF7IljXblw5YddikvnVCQ9cn1/cvGBjTy7XxTMfuaSO
 HVxjwlXaUcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEun8zMnQ/VNM4+t56zYep
 +9knNCrc3GV2K7zZZveTKT7Hy+VnCjQyMrRH5h7Zv0UvgT9RbLF4sPr5LSq9G23Cpf5UHpfbanV
 zCysA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: qokmbxbdqoxx1mxfw8zibu5b57iwtzna
X-Rspamd-Queue-Id: 8F1F220004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783676030-138805
X-HE-Meta: U2FsdGVkX1/KKIy6x8cAY7yZQPbeR8nL4WyfT0kC6w4fxsCfkEVPnksO5pDqDPku32POAnxUOFkw3ka1MyQk+sah8YASZaNeHX2KtQuakmN6WzsWJtReErIFIRcYFaSRpE+nCQEf7xvSTKWVeI48q8DVfBuw/xV2TSGFM6nLKsYXKH89FcVfC6G4RSNe3YqvUP513y9cj0umCYtNOCYT2npAvyQK1xyBo8uuBsgfpow+X3zpp/oi9hDB0e9JkCVv9ijXDTkI3OrkTrRmbP3vg/1QbZI4qF1uHauHvqTfzaML3D/w/140zBn9F+w14A4QfatbBBVHqpC7Ozpq/Q21XhT8wBGPeewhWHYR9KV5F61foWWOmBsOsFPwhZaHOnpbpak8UkUUI7IZ1LCtl+Qu5lcCh2f3YomFdq3pIKJ88BqZrkdjCXBMorJU0wKcW2+Tb9BGYS8cX3q1MqvNU+WnpBG5BtmmaBkhwTRypXeSTLV3gVnufo9N88szFnaKNhfoOMtQulqXeLzz6ChUwbomHNXYFed0kn+F2kl2j/qu2mcYvxkEM5HlutZbuX55icQVxQXqhVtgRh57dxd5FsQ7rivG3zrG0uAPu5cRCwN2V5ga8eceXbqU5CMai4QHUsYpcU/QB1oqr58E2UTg9AHD72en6vN+0Ti/9Fdchyvhlj26tiKE3M8js+qWxx1aFbupyHLjlta2oGrcy6fCqpsR4V2cJRgGeN/1cblfKky33y4yKQ987oPD6K9TuVr4wohdxKIkH5jlMA7hJYZfrjogE/QIUHOilYTG/paxGUreJ9VG1Ls9NvSiU3xqAAHJvu9fnT1bSNevgTByQalznD+KWsq398ID1bzCv8f29ePSAl9tF1qJBOBdL26o3jKWD/GHQYSDLdb36Hw04zDMRniSDBOzRUyhf6Sr5rOz+OQ9nqyLuiD5B9SvbGwosZeRhY29sNJpIsc1FzjZ37wMQbO
 48rOz0uG
 huAurnLqNG2U6E8GUMXHFVbhMV0jTMg9TLmW0VW+pieZYdzPthM9JbEwlPUN+7migBwtd1HHrb3phr0stx+tlpRw3+0EByHpnG5tSjJZ2hLUlHWRlK/3ggGk/whS9KDiRC1WN+B/9HXxq6bBVPLRDZzmyd/UTCyHSwbEIPqKLeRBm/m6tykH9SQqVST9nTr7crhZK+yBbLNHaNUTwrd9oebmr4u1FDb+Rh0KbNZS6/BcY4i2OZTpLaDNOIH4cHZ52fmQdp7aFXhJbIZ7D44V4bU8rnG+6OTjVWWvG5Mxy/fQs3YdsSzZGUa2s7Db7K3AQkuXjRwcu0dFECxMO0Nj/Zvx7PCXuR7b+AettGPDG1UuVCZ+SdccQJqMhTzJbAySSez84AA6f+tsTfd71Hgb3V06sg6S/UGfGFFfAvUgaKUG6y8o=
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
index cd5dbf61771e..06f4849cf1ad 100644
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


