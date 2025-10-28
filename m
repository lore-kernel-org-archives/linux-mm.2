Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D501CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 00:46:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54E36800C9; Mon, 27 Oct 2025 20:46:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B5D6800EE; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B168D800E1; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0E887800E1
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B9A511602E7
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:25 +0000 (UTC)
X-FDA: 84045681930.09.B65D8B1
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0E3D810000A
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=a1Ou47jU;
	spf=none (imf05.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761612384;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VD4R3gUn11tbzuOSrLlHcr6CK6toCdQdVG0PoPu8WQM=;
	b=YzFZKIVf1Z28O3g8cRYNQfvzfNPwnRcqLM9+ChxpcrD1nKuGmWOPVeXFzURXMqt5nH3Fn9
	DVrT//QL+x53z+PVrxNVhCfKTbhSZ66rzzQI5dks8KicfCWT59If3c1htyV9b7hj6hBbHf
	6xHEw23mHcAFuQlTq25sUho6pSHwa4g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761612384; a=rsa-sha256;
	cv=none;
	b=70YRhiodArrCx+uMyEqI58wljUShVFpxiz5d9PLpWEc1Ikktqp9i/JP/RazzeQYYA/vuDG
	YF/bDDTIG8z5wPV23Sf5GEPZ9Z4y4lQ3fH8kOC52utvYIfl95ZyUex1Ri4KC9JuBDtm0tq
	tG/gXZMaW7FRf8o8853seBropUpV0/4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=a1Ou47jU;
	spf=none (imf05.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=VD4R3gUn11tbzuOSrLlHcr6CK6toCdQdVG0PoPu8WQM=; b=a1Ou47jUeDFPDyFuwMzS1mCZUD
	t4KSAdCbW8S0oXxyua9xCSIy5xSnMG+YugoYQEQs86rDE8nYyKYjvCHzS+nI5LqBcYi129ADzTFCk
	8J97IQGe12RNPvNE65YFEV/sc7YmlTc8FgbW9sm4WHyGoIt4F5ohMiEVIHREZGxXXSgU656MOLje7
	/GmObfB7I2zPX0ezu6D3E1HvYj5dLt+dIGNfqk6kH2v6u1i+uhNlkjCzwPTb80l7bGeHK3tVg30dp
	yhiPLC8K4uwvPWJ/+4G67Un8B6U5D3oTqzwaV+HjVkQrNeq+zZIGY80OEG0AkUFFQLxU8HtTC/0Lh
	/JT2lAUg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqp-00000001eVu-0XWM;
	Tue, 28 Oct 2025 00:46:15 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	raven@themaw.net,
	miklos@szeredi.hu,
	neil@brown.name,
	a.hindborg@kernel.org,
	linux-mm@kvack.org,
	linux-efi@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	kees@kernel.org,
	rostedt@goodmis.org,
	gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org,
	paul@paul-moore.com,
	casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org,
	john.johansen@canonical.com,
	selinux@vger.kernel.org,
	borntraeger@linux.ibm.com,
	bpf@vger.kernel.org
Subject: [PATCH v2 05/50] introduce a flag for explicitly marking persistently pinned dentries
Date: Tue, 28 Oct 2025 00:45:24 +0000
Message-ID: <20251028004614.393374-6-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: npk1otumi8ouk5jc7sy6anaer43rmb6r
X-Rspam-User: 
X-Rspamd-Queue-Id: 0E3D810000A
X-HE-Tag: 1761612383-967247
X-HE-Meta: U2FsdGVkX1+nl6PmH3bTpN6xszifBXzvhCppzk3i0odhixY6aM0TygmbeC8/upt5etPedrFMaYpyH+HmCjfXoZkEEbBjgoFAHk7yIbdFiFQNdwljTo+Rqya0hqk7i3ZcdbPoffyNH6JIr580oZofaBw+IHStiSPQlg86XpS6oA+HXJZRkfpjxWm361AYS9XTu+0l4b2NVEwr7K/fOCvAGdsmCnRgM5hsvLQwXPYCA0/enDNpQxyqubDJahJ2fEiVSln0DdWhy0f7E3T+Tu1FPAzXRxArOcMBDBBVWWb82g5pybhi9pUz1RNmeNrrmDiiRQ0ov12PoHxFU+Abdn4VBWOjGq56Jzq+tND+Mh1Q1yCGY42fPndPlmlfxBIEC+sWX6MR2CIJZw8yNyjhjd8KPbkpE7FBXJpEoY23ckxomxz09tCNAi63qhoXwH4PmZhgat6/Df6+j7nHgZc70CztFChIZ/t/v7tmrTTVamSw8WdSFLUpGShGYD0PQGezhCCmuiAIaY9LF3HWgKt8lA3X0B/fu9Mlr89E22QlZj8gmUDMUvIPJEIbFFtN/znUo3dyyGTxLl4DtmSd1yUrGtRNSk8KhvfrDxFoyf1RCnh0j0nbresAYiEamuUK9IFoy/Eac/njOV8NqzET1hkTYiuFQe9+VAMiN+mzg2PjiEWR6cz/1Fbe+uegcMdA4/V6+RCXwNAmzfK/92rcRN0WOfopr1E24DF+bYY+SLdqem7srLsFJaFIRe4yANL6pRBkAjBDVXfN1tC6GxW19gHjZ1wyXm8k5W/Bej1sIZ2o6fnNJY8J6tZjI29qBgD3ZF4pYMAtjyogCCmtoWmuzpzWCwCvC365OG6mPNebi3TA/ShdROyshXey+zi9Saqm3EcwsZzvXvi0zydStU0g6JdYjCPZ9neNHiADolBMJYmwJ3akgCKge7NZwdtjXVNH7yr0WktNAjy63rA17Psp791shUU
 Aew/eUsj
 /t5CTpEEUm9Cl37eNZTjwNp04uY00rNmeuIyU1T6vuWdysfGjt0WOnsWfrfMpBpWSXaROBaaDt68s+DFTMwIO2lVs70Ajtb3ZaznR70bZ6NCIbnUQ0uCpfQP/kk6sZjUgA65vpuVivn5RDuFGNLYz4LPBzEyuIWvlZf0K6tW0DHEelZMk2JnLjILGTFFPnn1gSC+CqfZ8U9zDEksA/ApwrT1j8WVVFO41RJqk2/e5HKvupD2hxnJbhz5FvkH5Sjyoa4qE5h9cGGcVY5l1O2cnEpzHd7g0rgU4GXCfKODyzykB5cV04M5hvYhOyZ3dpJr9aIrrEqF8kAQEhiQnHqMt5vmJJHmEIG70x+dfq4L2Pb5DbCgT1NcTrwb7yefKPlHYKIl7Y4ws5gql4+Y7lKK76nMbs58emUCKtVUASkayNYtYetWFP21ce0vl8klFGqAptbhX5ttRl2l/Gv8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some filesystems use a kinda-sorta controlled dentry refcount leak to pin
dentries of created objects in dcache (and undo it when removing those).
Reference is grabbed and not released, but it's not actually _stored_
anywhere.  That works, but it's hard to follow and verify; among other
things, we have no way to tell _which_ of the increments is intended
to be an unpaired one.  Worse, on removal we need to decide whether
the reference had already been dropped, which can be non-trivial if
that removal is on umount and we need to figure out if this dentry is
pinned due to e.g. unlink() not done.  Usually that is handled by using
kill_litter_super() as ->kill_sb(), but there are open-coded special
cases of the same (consider e.g. /proc/self).

Things get simpler if we introduce a new dentry flag (DCACHE_PERSISTENT)
marking those "leaked" dentries.  Having it set claims responsibility
for +1 in refcount.

The end result this series is aiming for:

* get these unbalanced dget() and dput() replaced with new primitives that
  would, in addition to adjusting refcount, set and clear persistency flag.
* instead of having kill_litter_super() mess with removing the remaining
  "leaked" references (e.g. for all tmpfs files that hadn't been removed
  prior to umount), have the regular shrink_dcache_for_umount() strip
  DCACHE_PERSISTENT of all dentries, dropping the corresponding
  reference if it had been set.  After that kill_litter_super() becomes
  an equivalent of kill_anon_super().

Doing that in a single step is not feasible - it would affect too many places
in too many filesystems.  It has to be split into a series.

Here we
	* introduce the new flag
	* teach shrink_dcache_for_umount() to handle it (i.e. remove
and drop refcount on anything that survives to umount with that flag
still set)
	* teach kill_litter_super() that anything with that flag does
*not* need to be unpinned.

Next commits will add primitives for maintaing that flag and convert the
common helpers to those.  After that - a long series of per-filesystem
patches converting to those primitives.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/dcache.c            | 27 ++++++++++++++++++++++-----
 include/linux/dcache.h |  1 +
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 035cccbc9276..f2c9f4fef2a2 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1511,6 +1511,15 @@ static enum d_walk_ret select_collect(void *_data, struct dentry *dentry)
 	return ret;
 }
 
+static enum d_walk_ret select_collect_umount(void *_data, struct dentry *dentry)
+{
+	if (dentry->d_flags & DCACHE_PERSISTENT) {
+		dentry->d_flags &= ~DCACHE_PERSISTENT;
+		dentry->d_lockref.count--;
+	}
+	return select_collect(_data, dentry);
+}
+
 static enum d_walk_ret select_collect2(void *_data, struct dentry *dentry)
 {
 	struct select_data *data = _data;
@@ -1539,18 +1548,20 @@ static enum d_walk_ret select_collect2(void *_data, struct dentry *dentry)
 }
 
 /**
- * shrink_dcache_parent - prune dcache
+ * shrink_dcache_tree - prune dcache
  * @parent: parent of entries to prune
+ * @for_umount: true if we want to unpin the persistent ones
  *
  * Prune the dcache to remove unused children of the parent dentry.
  */
-void shrink_dcache_parent(struct dentry *parent)
+static void shrink_dcache_tree(struct dentry *parent, bool for_umount)
 {
 	for (;;) {
 		struct select_data data = {.start = parent};
 
 		INIT_LIST_HEAD(&data.dispose);
-		d_walk(parent, &data, select_collect);
+		d_walk(parent, &data,
+			for_umount ? select_collect_umount : select_collect);
 
 		if (!list_empty(&data.dispose)) {
 			shrink_dentry_list(&data.dispose);
@@ -1575,6 +1586,11 @@ void shrink_dcache_parent(struct dentry *parent)
 			shrink_dentry_list(&data.dispose);
 	}
 }
+
+void shrink_dcache_parent(struct dentry *parent)
+{
+	shrink_dcache_tree(parent, false);
+}
 EXPORT_SYMBOL(shrink_dcache_parent);
 
 static enum d_walk_ret umount_check(void *_data, struct dentry *dentry)
@@ -1601,7 +1617,7 @@ static enum d_walk_ret umount_check(void *_data, struct dentry *dentry)
 
 static void do_one_tree(struct dentry *dentry)
 {
-	shrink_dcache_parent(dentry);
+	shrink_dcache_tree(dentry, true);
 	d_walk(dentry, dentry, umount_check);
 	d_drop(dentry);
 	dput(dentry);
@@ -3111,7 +3127,8 @@ static enum d_walk_ret d_genocide_kill(void *data, struct dentry *dentry)
 {
 	struct dentry *root = data;
 	if (dentry != root) {
-		if (d_unhashed(dentry) || !dentry->d_inode)
+		if (d_unhashed(dentry) || !dentry->d_inode ||
+		    dentry->d_flags & DCACHE_PERSISTENT)
 			return D_WALK_SKIP;
 
 		if (!(dentry->d_flags & DCACHE_GENOCIDE)) {
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index c83e02b94389..94b58655322a 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -225,6 +225,7 @@ enum dentry_flags {
 	DCACHE_PAR_LOOKUP		= BIT(24),	/* being looked up (with parent locked shared) */
 	DCACHE_DENTRY_CURSOR		= BIT(25),
 	DCACHE_NORCU			= BIT(26),	/* No RCU delay for freeing */
+	DCACHE_PERSISTENT		= BIT(27)
 };
 
 #define DCACHE_MANAGED_DENTRY \
-- 
2.47.3


