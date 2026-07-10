Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABC10C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 09:34:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94DBC6B00AC; Fri, 10 Jul 2026 05:33:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 888A56B00AE; Fri, 10 Jul 2026 05:33:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C1BF6B00AC; Fri, 10 Jul 2026 05:33:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 504956B00AC
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:33:54 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E49681A039C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:33:53 +0000 (UTC)
X-FDA: 84972355146.23.A669E50
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 421171C0002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:33:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h9nN4dNQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783676032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SqI8OZlG/qEkd3Fp4TCWyuDAupA8ZhfkeksJ+xznU7w=;
	b=NTuSJCR04kt2y8PyHMpcNlgLgm/G69UXY1+bgd9lFYgZF+msPVNW6xLe/qdffUSy72ETb0
	bga5MN6yHUw88mR0sqt/DRqd9i4IcnkBlr/fMZpyNFHXuFNini06JHSZ0U/jPAFUCth1nQ
	eCpyTOFgVJKVrzRu6TX8SFgf18UNPaw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h9nN4dNQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783676032;
	b=rBSC97uWG1YXYECSnBURha26rQZ4DW7Hi5R/hm5GajdQEEOeYKG7tqNsR/nIzW9ciZVvMU
	mUrHtxnPyGoPYSr5/jO65XtYae1VWny0IgtNExXpxgZwF70JcBhC0Z4BQZMOqo7e4v4af+
	0phY7wehCYJF69secanCKUyJEiyrjeI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DBA7E6136D;
	Fri, 10 Jul 2026 09:33:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378181F000E9;
	Fri, 10 Jul 2026 09:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783676031;
	bh=SqI8OZlG/qEkd3Fp4TCWyuDAupA8ZhfkeksJ+xznU7w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=h9nN4dNQ0jab3F6gAxhlgpU6YDtlEjQVaYxnX75CJu2KkNGkwQU7L5PxDHesGc0TA
	 V1TL78BDSnCukRUitvkiBoBo+Md1wyOie/cM51dPOBPi0hOu2lxtYijx2GHdHNrVIX
	 htJ2VisZ3xc7oJLR6MyX+M1UGgywLmJ+ucAVwBuxPAtrnQjfoWi2jo+tkAJ63VFHqW
	 JyGvde/xGJzp36TQ0Qzeo6CKTnWVwoC7bqxMUTQjBI2XETAD3JZxrKCDIKcUSxZCHE
	 zRXcbgVgYwhqG8M3nGw3sT/ITVjUFGZvrecZwm6p3MN8QPpGglk6CAppQOhpv6Fb2M
	 PFACZZhtzmKvA==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 11:33:17 +0200
Subject: [PATCH v3 16/24] binfmt_misc: give the parse_command() results
 names
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v3-16-a162f7cb58d6@kernel.org>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=2934; i=brauner@kernel.org;
 h=from:subject:message-id; bh=6BMjUc9w/nIbssqAzSSWbt7UQK+RLsJW5lTvcPcsYMI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQF7Ilvd9T7G8T+xvhU6nbbT/vkC05Oay89af3l7LIlV
 8N3RrZ7dZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzE6iAjw561qlnHxAReHHTg
 XMhyK/ntvJ8vJ92o9djoy7+p71mxawnD/5rj2y/E3d65s6SS92zeriNbn4kWy8pVr2O9flz0yN5
 TPmwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: h7dzh7d8xiywo4rh1teckdnthzbbz8u3
X-Rspamd-Queue-Id: 421171C0002
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783676032-142695
X-HE-Meta: U2FsdGVkX18X9LlTToGW8U0JGlW0rfpqBvo7GUa6xkXXQQSGpyRtoA4cqxr4/zpJOVO7wuTaVwdt4RIi53mrzmi3HltrPGWbAeK08+un12Kul+F+rSFDYfZHFnI/1/VHyB1Nm5k9gF5MC/6+T2yQcjEvOMdPySDGkW6JB+WYK/afV9df45zZlAwgLBped6M1KzVsCBhZnbfzBFPUY/DqBA600RqwK0+p9nzDtFzF+hVCxXG5yOXxjUTOEKZbXNENaSVeiASmGiR9NaD87vgsMTDQAiYmUCqyOz3mtQHzZ8JudtC0fgTkx1udCxGMTXhyX/OGv2/N8tjTUVPJat8kuHkUEi1ofyoYuzFxcjlWVgesc8ytkzNhd+L35ughbT2emFR8oH/LKWbppzPk3QfiG3X1P/2Xk0g97cWDLox67FG8FGs911XNUE6LFK6Zwmjglpd8d8kbXNDQ8lyHoRsp2tuPlwqnFta7DMJBhTf4CFKyVsOJ3U2p4qD5LRkWc2TGnrdqKihidc8jPrwbc2UiTrsnujF3Y+YYW5vWhw2CkKmYBT4E51+ktuTyEKLrpLuGBKQqawmB4HUXvawJxo7SMH9uyInaEEXUMf0biVDP5+DijorN75R/RRrZYIJi0j8qw1/MRof2Ty4CouYLG6iCFOV6r3Usd68FBRQYroFM5EyT6lmtznMVys6mkyw/czjtrECm5nTlRl3M9T5Xuqms4gGPPagY72m5AvKZWmiXwEar7IZTtAyL3+eBRVfsNhJeir/jylaLaRuJy/kUsu0AFASQW5BFgQIxt+vi54zyk9IuFHdq01RYm5br/wzyfukUjdYph3gJ7u4K3MECMP2EZLj2BBWO1Zmm1e94WdTHAkEbkT+hO3WYumqIx0srnii8lKFVPK3Y1Cy7cnv0wscKoE3XmksjFp11abwV1LywX6VVqCsSvQpQh6Mq70qBTJEcQgucMIv2DrQ078BRpyW
 deErcy5d
 q69UabAoEd1iPwW9BJBC7H66D7uFNJxZLxgsjJFwPYZfDg1W127vlifRasamp7aC2ru2DTvPzdgxoJ1af1C8XdqdsytfisIeqPJudA2/cdLTrfxIeQJabctp3qOFVFhO2ujY6VRxH1DbYFiYEpfGqd5lZiiHMb6zaT32zRniGJ27oAA7I0LgeDmJF8zerF7eJKuwziDJ+SBqO0sbmKe1XCP6gDTqopGnFsrB0AGn4VACmUyTlvTmXKic5zuudQUYuIs6Xr3sRiZ4U+pnJTrGraEUmJHiN+4nQOH3UQACvxTNjK98ZWGHI1WdT2anVCCQHdVtiAOO56n9j9JhyVZwEvx2W1pCxbMSlUw97PHUDjyNkq7g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

parse_command() maps "0" to 1, "1" to 2 and "-1" to 3 and the write
handlers switch on those bare numbers, leaving every reader to redo
the mapping in their head. Name the commands and drop the per-case
comments that only existed to translate the numbers back.

No functional change.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 06f4849cf1ad..1f2b1d136819 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -543,9 +543,17 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
 	return ERR_PTR(-EINVAL);
 }
 
+/* Commands accepted by the /status and /<entry> files. */
+enum bm_command {
+	BM_CMD_IGNORE,	/* empty write */
+	BM_CMD_DISABLE,	/* "0" */
+	BM_CMD_ENABLE,	/* "1" */
+	BM_CMD_REMOVE,	/* "-1" */
+};
+
 /*
- * Set status of entry/binfmt_misc:
- * '1' enables, '0' disables and '-1' clears entry/binfmt_misc
+ * Parse what userspace wrote to /status or an entry file: '1' enables,
+ * '0' disables and '-1' removes the entry or all entries.
  */
 static int parse_command(const char __user *buffer, size_t count)
 {
@@ -556,15 +564,15 @@ static int parse_command(const char __user *buffer, size_t count)
 	if (copy_from_user(s, buffer, count))
 		return -EFAULT;
 	if (!count)
-		return 0;
+		return BM_CMD_IGNORE;
 	if (s[count - 1] == '\n')
 		count--;
 	if (count == 1 && s[0] == '0')
-		return 1;
+		return BM_CMD_DISABLE;
 	if (count == 1 && s[0] == '1')
-		return 2;
+		return BM_CMD_ENABLE;
 	if (count == 2 && s[0] == '-' && s[1] == '1')
-		return 3;
+		return BM_CMD_REMOVE;
 	return -EINVAL;
 }
 
@@ -717,16 +725,13 @@ static ssize_t bm_entry_write(struct file *file, const char __user *buffer,
 	int res = parse_command(buffer, count);
 
 	switch (res) {
-	case 1:
-		/* Disable this handler. */
+	case BM_CMD_DISABLE:
 		clear_bit(MISC_FMT_ENABLED_BIT, &e->flags);
 		break;
-	case 2:
-		/* Enable this handler. */
+	case BM_CMD_ENABLE:
 		set_bit(MISC_FMT_ENABLED_BIT, &e->flags);
 		break;
-	case 3:
-		/* Delete this handler. */
+	case BM_CMD_REMOVE:
 		inode = d_inode(inode->i_sb->s_root);
 		inode_lock_nested(inode, I_MUTEX_PARENT);
 
@@ -866,16 +871,13 @@ static ssize_t bm_status_write(struct file *file, const char __user *buffer,
 
 	misc = i_binfmt_misc(file_inode(file));
 	switch (res) {
-	case 1:
-		/* Disable all handlers. */
+	case BM_CMD_DISABLE:
 		WRITE_ONCE(misc->enabled, false);
 		break;
-	case 2:
-		/* Enable all handlers. */
+	case BM_CMD_ENABLE:
 		WRITE_ONCE(misc->enabled, true);
 		break;
-	case 3:
-		/* Delete all handlers. */
+	case BM_CMD_REMOVE:
 		inode = d_inode(file_inode(file)->i_sb->s_root);
 		inode_lock_nested(inode, I_MUTEX_PARENT);
 

-- 
2.53.0


