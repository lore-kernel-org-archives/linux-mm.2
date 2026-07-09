Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85129C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 22:30:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AD0B6B0095; Thu,  9 Jul 2026 18:30:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 486616B0096; Thu,  9 Jul 2026 18:30:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39BB46B0099; Thu,  9 Jul 2026 18:30:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0AB2D6B0095
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:30:28 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8384B402F5
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:28 +0000 (UTC)
X-FDA: 84970683336.22.6DF4275
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id A25AC80011
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b+H4hHnI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783636226;
	b=zeA3kJd8TubQ1QfPuo+SwkxERNHQtnG1XOwSVOsOmyo3HUN8PTmwp0sIYsxnsUDv4iSOeA
	AeotJt+c+fjRcXaB56sKBJjW+LKqK4AL59veY3QOINr1n70zRKJzPeNjvQ2twZktkygpRl
	CrVZWoqdT0NirbQ2TWyox7+E63oOALY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b+H4hHnI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783636226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XLoO7MX1yFKSW7aJED8m27wZw29SVMwCrGQcExHp8qY=;
	b=dirlb/cZLbaQ5QAjvndv3Jqc4YKST5SinDb06m5HJj/cF9oDGa8Jq2ccTHil3FJUWIr4dq
	GDZwoSbRlwTS8MHxegXKnXfIh8j05O7wzF9oIi9483d/I3EzaBcXewJUBOelOe5t4kxLuF
	w6RKeI2TUwnvkoEBV6HsDXbgh59VoKg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 07DFD43D25;
	Thu,  9 Jul 2026 22:30:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E371F000E9;
	Thu,  9 Jul 2026 22:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783636225;
	bh=XLoO7MX1yFKSW7aJED8m27wZw29SVMwCrGQcExHp8qY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=b+H4hHnI4xtz08MVofnEkRhHMMYDnFBmQmwpOz0nNBD1eDiSK1ojgfewVQQXyo42s
	 CkUabdZhwTPJiDAOFuJlZY9XjVJrpJkuqXuu/STniV38S6ztfqCKVf7RTvxQRfYnDX
	 9WLXKSYSERg9tFvQurjS0n3PTsbbbRwUnD7uh9kd4JTTiy8PIEsUn3T5W5Nod5phSG
	 odTVzlt2gqh33Ks8d12h+CChdYWXSinDiqsCTbnkjVB/0LS8Y53HmTwxkTdUqCFOLH
	 kLyjRZROofXvOE3S5QtTi8f+c+UlrLzpWU8Sqwlm4nN71/YaztjIuaBx/f/+y5uFAq
	 Q+sP9Jx2YHmfA==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 00:30:00 +0200
Subject: [PATCH v2 05/23] binfmt_misc: annotate racy accesses to ->enabled
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v2-5-2a1c3d4126a7@kernel.org>
References: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=1991; i=brauner@kernel.org;
 h=from:subject:message-id; bh=jJ5DMaBJqUtVcsxnphyndFBcDC55vNmWPHxqKdhZYxk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQFKHwtVPP6Fj/RVEhix7d9V5+ZLD3MXLkk66dlZK5Qy
 OEfn9Kud5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEwkPZCR4fGTQJnS15ETIx5U
 Xjfmu6Pk89wu+5jL47C3i2Z2mGtcsmT4wx2Yb6v3QCG45wrvgzc7SqMXLtCfLv72q8fCByqZPcb
 vGAE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: A25AC80011
X-Rspam-User: 
X-Stat-Signature: ehdfpi6pjb3j74oyssumaa8p755p7rcw
X-Rspamd-Server: rspam03
X-HE-Tag: 1783636226-234218
X-HE-Meta: U2FsdGVkX18m5TJUesjr3xT0FbjvAPbfnt8Gm+Q5xzz7V9tM73u1/0qtaOiK/wm5uevrcxwGptKppXQsfhe/gvD1aj1OAFFCutHy/cGx1Y18w2gDMidfOVSeu/Z28Z351cBsOYXYQqzdY8ljSBTRsPpz2zF/Yc1TfuKvRx+axSx9GHjUbgbhHeGm5RDrpU9cTMxpzY8vOr5RWcLgy256oR9H/LjDv1CHEae3ZX88lbYsQ8rZ1dLAISuCyT5YB3d6eKIivyt/XqrEmtMbIG4On8W+gIfG5u6k1DwdtIG0+tkJEVWSg4mypnb7YNBLsgSpICD72jr9MPU5NVf4BLf3SF4d3seuC1BpgRIIEONojT6f3OqzvSh/g9asOqnDrbP8isNW610TtIy+zLpOnF60ae9xJnrlke2YQNk1v0AwRM1Z/EA88Wao+ccGbNJzbB9knPZDdAl9tP/U1bFI0k/gFxTJf3uQloe+yjaDoZXjIhBdfbB3cWZMLFxS7F9he6NaFEWudcGFMOJmnTHj4H8Ce/Ye/rJP5cav/efBmMXaso+7cSMZP6+ujf9rVqDnxcqeg+uM4+ImxNd0P771q58qL6cGgZVXZVofKbrgRr0mYi3ZwoSOodtwi2bBYYda3GqIQRhDv657o6bbEGOUW6aeBuOzNhLEJakjViY6TxqFe3GqBUp3MJjan7Xg0D6qthwNLnhwkEOzOhl+FpHb8AsV4hFSKOFXxNL/+7E+Muwucfnd6QaTmddyjCfPGCLQ/V8NQOYPuq9Wcdo1NYkY8pBMoyEWmTvYR1rSKhch/4XsEt0FF3jh6M6ML36qwSV1PJ/6tPwpWyr/lrg0sRBn1Z6Ygdnm2hNuL3isEKeo7IYEdQvWj7SH4QdMg4YnJQavwu/Pd85gV8J6L2lxjHf8vSw/GOD4/8Gp4HeBXy9UVig0ateqkq47SQkdkb7pFs41ra9drDrscsC2b6eZvYyMP/z
 7TEKTaPt
 BFgomFhYJJm8Z3t0PtaLB86W8s3kNSWjnzJ40f4yepUk9/YH9OVEw63u/4ypACS+NTXph35c5Q7459YJgEy3+vPZVELYRK1EJBJNHQwJYDX2dhlYf3e9bDaREvR5hRinM6wvxpFAPGiiXHpJlTGPwhDeODUjBHSXWcNU4xmn5lOQrsZGLaaspnMhecxWoq3TFEt93bYcAybLi/yaYiXcVtBLma++MlPRUTeII5KP13/UYVFLytpqF5VdHmfzL1wyOeQ0Ia7CuIwH0XpckYgDxX8d4LDyz1Jvn5moGkPBpQGlMsQVg09XBQcDkQifvYJyFdmbGujABmQRaMRnfPYGV2s3GamswXBjGzwQBpUPKz5MvZzw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

->enabled has always been read and written locklessly: every exec
reads it in load_misc_binary() while bm_status_write() or a concurrent
remount via bm_fill_super() may flip it. That is fine as it is an
independent boolean toggle but the accesses should be marked
accordingly for KCSAN. Annotate them with READ_ONCE()/WRITE_ONCE().

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 08fd7991d4c8..2a9025627f6b 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -217,7 +217,7 @@ static int load_misc_binary(struct linux_binprm *bprm)
 	struct binfmt_misc *misc;
 
 	misc = load_binfmt_misc();
-	if (!misc->enabled)
+	if (!READ_ONCE(misc->enabled))
 		return retval;
 
 	fmt = get_binfmt_handler(misc, bprm);
@@ -871,7 +871,7 @@ bm_status_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 	char *s;
 
 	misc = i_binfmt_misc(file_inode(file));
-	s = misc->enabled ? "enabled\n" : "disabled\n";
+	s = READ_ONCE(misc->enabled) ? "enabled\n" : "disabled\n";
 	return simple_read_from_buffer(buf, nbytes, ppos, s, strlen(s));
 }
 
@@ -888,11 +888,11 @@ static ssize_t bm_status_write(struct file *file, const char __user *buffer,
 	switch (res) {
 	case 1:
 		/* Disable all handlers. */
-		misc->enabled = false;
+		WRITE_ONCE(misc->enabled, false);
 		break;
 	case 2:
 		/* Enable all handlers. */
-		misc->enabled = true;
+		WRITE_ONCE(misc->enabled, true);
 		break;
 	case 3:
 		/* Delete all handlers. */
@@ -1003,7 +1003,7 @@ static int bm_fill_super(struct super_block *sb, struct fs_context *fc)
 	 * someone mounts binfmt_misc for the first time or again we simply
 	 * reset ->enabled to true.
 	 */
-	misc->enabled = true;
+	WRITE_ONCE(misc->enabled, true);
 
 	err = simple_fill_super(sb, BINFMTFS_MAGIC, bm_files);
 	if (!err)

-- 
2.53.0


