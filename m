Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CC67CA5FA1
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 21:32:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DF3B6B008A; Mon, 28 Sep 2026 17:32:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 968666B008C; Mon, 28 Sep 2026 17:32:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 806F06B0092; Mon, 28 Sep 2026 17:32:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5A4DC6B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:32:17 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D68021202EC
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:32:16 +0000 (UTC)
X-FDA: 85264469472.11.2FD9772
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf03.hostedemail.com (Postfix) with ESMTP id E82CC20010
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:32:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf03.hostedemail.com: domain of krisman@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=krisman@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790631135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=023JtND56G52KwWgz4ZHDtm1V5b6mP+xh+PH9M7VJKs=;
	b=K1tdwHlqIuNsPByYyMKFQOcGsJUgMfRLZISTnlTibJ9Goys7rPP1A2x4ad4UKhgZylppjV
	Z8a0sLvJeolF4ChFxJiLKnHly348D6+EtNjGx9AI301p4z1tuCWo3xdKgZFAVZEoO7z3q1
	9F2zZKGzPSHC4y5Fthaqspo+posL+pA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf03.hostedemail.com: domain of krisman@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=krisman@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790631135;
	b=6gGGoc8r2R/sjs23wquL1Qw+0afkaVBdMTBwsIj3igzUFn3inXkefBrThDldDtf0U7OXE3
	2dX664aBtbmxcobwRy+ElbzSWQXj6g6fFJI78nf8UWFeUX+qCnd89d2xgPUN40jDw0K6sJ
	Xbo63RQFA7UDryXIKd6n2h6GTYt0Ihg=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9C60621CA6;
	Mon, 28 Sep 2026 21:32:13 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 25D1C1340F;
	Mon, 28 Sep 2026 21:32:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tIQMN9zcumqcMwAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 28 Sep 2026 21:32:13 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Gabriel Krisman Bertazi <krisman@suse.de>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Hugh Dickins <hughd@google.com>,
	Daniel Tang <danielzgtg.opensource@gmail.com>,
	linux-ext4@vger.kernel.org,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-unionfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/4] ext4: Expose the filesystem encoding through sysfs
Date: Mon, 28 Sep 2026 17:31:53 -0400
Message-ID: <20260928213155.2612039-3-krisman@suse.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928213155.2612039-1-krisman@suse.de>
References: <20260928213155.2612039-1-krisman@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Stat-Signature: 3h1j3uc9um16nxzwe6w3emgm9hkpzmyp
X-Rspamd-Queue-Id: E82CC20010
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790631134-328776
X-HE-Meta: U2FsdGVkX19qOhW/azplaVVKDROvC6JcZaN/qXMBrGFrwCqBGr6xn/HWwA8ZpH6AgpRZ5bW4Tg2fw+rO4u3ULyUu+tb8ZwHgfS6ga7B3S8i3/xT2BTUB5tW3YoMBvIw2VRLMilTXiba1vX3hHYDV4YVUKUnaxAYZEL8ktRBMRmOfFuJY+tMU/G74GMhStop7DN0UxxITIRhKxfw2Z4ElfuXtb25MDAK17W1vnZb7K1F8uCa1ZlcEvL23KK4a8UmQ6I/q4Q7jHzX51whqGxyPgDhymX0l3nKq0m88j/RtTipCsgjCyi3guINb4grBdL+mjmYCu/Xak3m8FzAabYL6NMOf/pLr/tLajgDl+VHux9btpZP1wgCPpnGIPpVCnQIqm+6Ra0eeVS+W4+rsv+mdB+unkD9S22KYDLFbwXgaBi5JBGgchrN1Xf/ILve5H8P/X9rckT+b6E0CMLDN7JgoMHikusM5tr9SpMphxmgbzAF/uYElL8ADHyu8eRx4WB9vG/NSfqRU/V9auzZTCTsY2T7A87/9sUSu7AftW5GoQWHfZm1vZ+cDNgZEFI1MlmjR/FYYCgXixAqdY6AKofm6HN3lxZhRvw0xvgKwEspyNksiYxYCV/ipzAFUyW3xeTH1UdV5dw1bIKbgf5Ne3Fp4uzxAW5ua+/Kmt2eAzreg1FWvP4/tmQ8IdTlbnSFr9dg3X6KvMLTJxkMgXe3Hg+TqO0i4p0xVHo1GO7X+L348EbV40iUgsEFtEyKx0lIYVONqsXhMznqM3fprimCD4j0Q74BZa2nOC//QlDRzP7tUGJq/pIz/FZWGWWNv7mxlwWF08BZJyN+BzCKAW2+1d+tGPnhr/sH4rSVJ1MTl7iBMcqoKUjLAkAu5AzdlzlJ0CYkVNMh9UGWb3PRetkCuFnviRFpWcuPO7vjTc0OkSWXWPDclg0eyjZpikKyp/K+ynzIapJDXsu4MJojbKg4Wp2t
 e7GG2F0p
 fkg/9IigTFgdpSRoSocJjdzTrnrBGAwrVZsHWaRfxBtUCQ5nXtEI9Y3xiZ0zoQ0utNuqXBReHhjMB4wDPhQwIkx2k3KnSgYVxyLNhAs10mwXbjLeBYNKf9Hz422oB1gCHC4jEBdlyr32K+TR5IQ1rmVVnEd70Dw4PWoVkxa0OJG2xgHFqUatYhTxn2hDfTR8FCHIXD/jRaQFMels=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Daniel Tang pointed out that shmem doesn't list casefold as a mount
option, even when it is mounted casefolded.  While fixing it, I noticed
f2fs actually already provides that information via sysfs, but ext4
doesn't.  This patch reproduces the same interface in ext4 to have
feature parity, so users don't need to rely on parsing dmesg or trying +F
on a temporary directory just to check for support.

Assisted-by: LLM
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 Documentation/ABI/testing/sysfs-fs-ext4 | 21 ++++++++++++++++++
 fs/ext4/sysfs.c                         | 29 +++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-fs-ext4 b/Documentation/ABI/testing/sysfs-fs-ext4
index 2edd0a6672d3..8abc5706f459 100644
--- a/Documentation/ABI/testing/sysfs-fs-ext4
+++ b/Documentation/ABI/testing/sysfs-fs-ext4
@@ -116,3 +116,24 @@ Contact:	"Theodore Ts'o" <tytso@mit.edu>
 Description:
 		This file is read-only and shows the pid of journal thread in
 		current pid-namespace or 0 if task is unreachable.
+
+What:		/sys/fs/ext4/<disk>/encoding
+Date:		September 2026
+Contact:	"Gabriel Krisman Bertazi" <krisman@suse.de>
+Description:
+		Displays name and version of the encoding set for the
+		filesystem.  If no encoding is set, displays (none)
+
+What:		/sys/fs/ext4/<disk>/encoding_flags
+Date:		September 2026
+Contact:	"Gabriel Krisman Bertazi" <krisman@suse.de>
+Description:
+		This is a read-only entry to show the value of
+		sb.s_encoding_flags, the value is hexadecimal.
+
+		============================     ==========
+		Flag_Name                        Flag_Value
+		============================     ==========
+		SB_ENC_STRICT_MODE_FL            0x00000001
+		SB_ENC_NO_COMPAT_FALLBACK_FL     0x00000002
+		============================     ==========
diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index 923b375e017f..bc1c59d67eed 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -32,6 +32,8 @@ typedef enum {
 	attr_clusters_in_group,
 	attr_mb_order,
 	attr_feature,
+	attr_encoding,
+	attr_encoding_flags,
 	attr_pointer_pi,
 	attr_pointer_ui,
 	attr_pointer_ul,
@@ -161,6 +163,25 @@ static ssize_t err_report_sec_store(struct ext4_sb_info *sbi,
 	return count;
 }
 
+static ssize_t encoding_show(struct ext4_sb_info *sbi, char *buf)
+{
+#if IS_ENABLED(CONFIG_UNICODE)
+	struct super_block *sb = sbi->s_sb;
+
+	if (ext4_has_feature_casefold(sb))
+		return sysfs_emit(buf, "UTF-8 (%d.%d.%d)\n",
+				  unicode_major(sb->s_encoding->version),
+				  unicode_minor(sb->s_encoding->version),
+				  unicode_rev(sb->s_encoding->version));
+#endif
+	return sysfs_emit(buf, "(none)\n");
+}
+
+static ssize_t encoding_flags_show(struct ext4_sb_info *sbi, char *buf)
+{
+	return sysfs_emit(buf, "%x\n", le16_to_cpu(sbi->s_es->s_encoding_flags));
+}
+
 static ssize_t journal_task_show(struct ext4_sb_info *sbi, char *buf)
 {
 	if (!sbi->s_journal)
@@ -283,6 +304,8 @@ EXT4_RO_ATTR_ES_STRING(last_error_func, s_last_error_func, 32);
 EXT4_ATTR(first_error_time, 0444, first_error_time);
 EXT4_ATTR(last_error_time, 0444, last_error_time);
 EXT4_ATTR(journal_task, 0444, journal_task);
+EXT4_ATTR_FUNC(encoding, 0444);
+EXT4_ATTR_FUNC(encoding_flags, 0444);
 EXT4_RW_ATTR_SBI_UI(mb_prefetch, s_mb_prefetch);
 EXT4_RW_ATTR_SBI_UI(mb_prefetch_limit, s_mb_prefetch_limit);
 EXT4_RW_ATTR_SBI_UL(last_trim_minblks, s_last_trim_minblks);
@@ -333,6 +356,8 @@ static struct attribute *ext4_attrs[] = {
 	ATTR_LIST(first_error_time),
 	ATTR_LIST(last_error_time),
 	ATTR_LIST(journal_task),
+	ATTR_LIST(encoding),
+	ATTR_LIST(encoding_flags),
 #ifdef CONFIG_EXT4_DEBUG
 	ATTR_LIST(simulate_fail),
 #endif
@@ -483,6 +508,10 @@ static ssize_t ext4_attr_show(struct kobject *kobj,
 		return print_tstamp(buf, sbi->s_es, s_last_error_time);
 	case attr_journal_task:
 		return journal_task_show(sbi, buf);
+	case attr_encoding:
+		return encoding_show(sbi, buf);
+	case attr_encoding_flags:
+		return encoding_flags_show(sbi, buf);
 	default:
 		return ext4_generic_attr_show(a, sbi, buf);
 	}
-- 
2.55.0


