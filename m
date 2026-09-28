Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F09DCA5FA3
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 21:32:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 066876B0096; Mon, 28 Sep 2026 17:32:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F32F76B0098; Mon, 28 Sep 2026 17:32:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E20A76B0099; Mon, 28 Sep 2026 17:32:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B999F6B0096
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:32:25 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 340A71A031E
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:32:25 +0000 (UTC)
X-FDA: 85264469850.16.1B2D81E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf22.hostedemail.com (Postfix) with ESMTP id 49EF2C000A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:32:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf22.hostedemail.com: domain of krisman@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=krisman@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790631143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LDQfUveBezXfUu1Ue1jNTAr+X9gAnV+SDv73a6ZGNNA=;
	b=3mJ6B5b7Y3Qxk93Qf2wzlMd5GWl0BqDrjPVi7Ec0NZSXqzUi2IwVeDUkxVCFb5g4XfNjMV
	3IuKlAAVaTLnQldCFy62nrXnFuSjavRGyjF0F4E+WIZVbtWdA1yjsGNAYp3xqMALbq0S0H
	xknFCtthRQ9dYagM3l1Zcyr5iPaof3o=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf22.hostedemail.com: domain of krisman@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=krisman@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790631143;
	b=eeUwMKBzJp3rCnzY4JHrE0MBbnG/kAY33y8jcGs1c8Eey3g586f6zEk3S/ctw0TwBhYqDs
	mfRS5v8OxCzb/8UGXhe6XdzWiuYcx3fQddcnAlvZ70T28wSHNRrU5WwGnI7VOQPvudetqg
	bNnrHB8ddrmNORBtcTOUAVqObztWGh8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 538B01F828;
	Mon, 28 Sep 2026 21:32:22 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E09E1133F1;
	Mon, 28 Sep 2026 21:32:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pF8PG+XcumqkMwAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 28 Sep 2026 21:32:21 +0000
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
Subject: [PATCH 4/4] ovl: Expose the filesystem encoding through sysfs
Date: Mon, 28 Sep 2026 17:31:55 -0400
Message-ID: <20260928213155.2612039-5-krisman@suse.de>
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
X-Stat-Signature: 13igmuxun8ida9nh7emuw6ezbnfyf31a
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 49EF2C000A
X-HE-Tag: 1790631143-269640
X-HE-Meta: U2FsdGVkX18LoUPO5YJKDZfIO3iNdnN9sgs5AKXadjbPiSUn8SEJV+Ob5lUzlVfIK7pbSm4chV+Go9F5k78rxBs2IZTK2B9JTInU06IxB05EEWeGf+Ex152vRabkmzWof1sDvp/zMe+o0waGDycCOEPmEmpRxPV8PTfjCePDBGiGWOsKlTYJtperI1E0YtzfJz74jQL0Ok4+FDPmijO6aEzv7AHGF6KvZV15EeubtJR+32HVwRuhv6SxG2i4C40Rw2YL0551qZ+06oSVmY+27qVUoHBrgFfBitotYtLxD6TQ5vgFQMPWa9LTQ3aFroxkm7Ft3asb4JsEMseESZGwnZelydBMeLeKrkiuZEMEr0tUpZ5WCo55YthKNTELTvj+86xu2s3mCBNzSIA2PiuZxCjAGUHjpDbjC+CxGRVeVE2nzvp6v42YX+8Gv2e7Li12XFglCFnxAgKwJsA8MnncCMkBeBsqzLAXzQ99wSEGGfzflzdh8/2SR3D3L6CXkW9qNJXOss7LmL+FDOTcOnu9TlTy+indYDFwvYkEy7VNVE58m60PW9OH7hf0ro1YLan6d5Pjyqbh34WHY5Fl/oe9RLWYBmiGbmqQvTjuknmDzhqDBZsZf/KmejXvVKIeyiBfT+HZqAxAIZqdwf2QYuMrmdYOfj8TP0USGX3k3gkw/0yNAiCp/3nhbifU1TDHppU09O0ZMKTUjmph6GquXUSXibXFCJG1LNSMt1KXUUHCwh1q7ZOp4sff+cTGDCviZtNqjXdanCF/jpc5EjIoinL6FGO/RAFZeBwmPQwq9UNLYjE6+i4TvRNnzqnzbVX0+VXXlpBkVUdfzIB5Lg//IcadfyDs3VLY3s/I2NraGxFB4ULb9Q3t/ggED7dJnkVDttQqG+Uaj1FS7CPQVrdbyYpgUiRaL2mg7Ofmoc3nTLAtFHycWmOxHSSzHTQNs8rP7XP8o4Lr/7uZ/mjhU2PSkLu
 Q4hA8YqX
 bj6QCF1fP6MBmlLuGn+uUkU48l5Vz5MIDPFOhLYfikyDudLtf51lLzAxcrlQX8mLQ/KXWjjuoxFtk8GkoJmKlmZ/HN0RsuO6xOQvZaGCPHaqlz4hHuvXwqoZTcvU4QAdPux9B/AR2Q4zNWTWUkQJIEGvKFfctsIn6ro7VZtkvIk7kTUKcsUHQQ0PY2VDM0S5eEP6h/eGJrF1/pvA1QofhdQxJ+Jjz0KtI+io9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch reproduces the same interface from ext4/f2fs to have feature
parity, so users don't need to rely on parsing dmesg or trying +F on a
temporary directory just to check for support.  Note there is no
encoding_flags file, as none are supported by ovl.

Assisted-by: LLM
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 Documentation/ABI/testing/sysfs-fs-overlay |  7 +++++++
 fs/overlayfs/sysfs.c                       | 15 +++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-fs-overlay b/Documentation/ABI/testing/sysfs-fs-overlay
index 9060c39679ae..7f3c6403c4f8 100644
--- a/Documentation/ABI/testing/sysfs-fs-overlay
+++ b/Documentation/ABI/testing/sysfs-fs-overlay
@@ -4,3 +4,10 @@ Contact:	linux-unionfs@vger.kernel.org
 Description:
 		A directory is created for every mounted overlayfs instance.
 		<volume> is set to the device major:minor.
+
+What:		/sys/fs/overlay/<volume>/encoding
+Date:		September 2026
+Contact:	linux-unionfs@vger.kernel.org
+Description:
+		Displays name and version of the encoding set for the
+		overlay.  If no encoding is set, displays (none)
diff --git a/fs/overlayfs/sysfs.c b/fs/overlayfs/sysfs.c
index be83b57f637c..2144cbb418bc 100644
--- a/fs/overlayfs/sysfs.c
+++ b/fs/overlayfs/sysfs.c
@@ -22,7 +22,22 @@ struct ovl_sysfs_attr {
 		.show	= ovl_##_name##_show,				\
 	}
 
+static ssize_t ovl_encoding_show(struct ovl_fs *ofs, char *buf)
+{
+	struct unicode_map *um = sb_encoding(ofs->sb);
+
+	if (!um)
+		return sysfs_emit(buf, "(none)\n");
+
+	return sysfs_emit(buf, "UTF-8 (%d.%d.%d)\n",
+			  unicode_major(um->version),
+			  unicode_minor(um->version),
+			  unicode_rev(um->version));
+}
+OVL_SYSFS_ATTR_RO(encoding);
+
 static struct attribute *ovl_sysfs_attrs[] = {
+	&ovl_sysfs_attr_encoding.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(ovl_sysfs);
-- 
2.55.0


