Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC554606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oOTHfPnj
Received: by kanga.kvack.org (Postfix)
	id BAF7A6B05D4; Mon,  2 Nov 2026 09:26:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B867B6B05D5; Mon,  2 Nov 2026 09:26:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9CEA6B05D6; Mon,  2 Nov 2026 09:26:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 813EA6B05D4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:26:44 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0B6E712013D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:26:44 +0000 (UTC)
X-FDA: 85390405128.03.27FB33B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2E2F2C000E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:26:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oOTHfPnj;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793629602;
	b=5z++fxQDDxuY7pT5ikxu7ng7ogce05/fpauRWNIZXdTNv+w/a6uurBQKCLrI7xAEueaj+Y
	B2KuiJQ0PVf7sXgQVyiUCjTGv66QnyTXZJS5aZ5u0RZMU6jkEuOUmtn4b6/3dwgTwLVqwd
	29Ji179gV9qMZyQxvoehZP/tkfEOl4o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793629602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XyS11ffq54Sp7hLIWVW3dn1ZYIS4v3sn4XvdfnHyHBY=;
	b=2JuVOhhB+ZjnYV5l8mm7l4hH/3kayrbW9dX3mcGUDVqufwXk/C7PGtVxjNprqHPgwPmR9J
	8sVFafKbO0dbmQEXdu3DUDaBhD76p/4V08KfK8Ld1BDVd9rgVHt0kUvtMLmaLhmRnNjdtW
	s6ce6MV5QwJ0hwS78OGCSggSqb2pFBE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oOTHfPnj;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B01043D62;
	Mon,  2 Nov 2026 14:26:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35591F00A18;
	Mon,  2 Nov 2026 14:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793629601;
	bh=XyS11ffq54Sp7hLIWVW3dn1ZYIS4v3sn4XvdfnHyHBY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oOTHfPnjZImvmmRPM2MTN/E/IIH+K1Xm8QDVrH8Oqlt/AJsi4waiHv9CftkJy/6ni
	 6EIRp0HbnhNfXHCXc4K9VojrITUlGyR3GhezVAOLc4o/UIMtBv2UXRIoUyNcRoDRfl
	 hwij2c23hqVe3wrkk0JhAPavUcN3D/QHGIgP+swQEOLquf8jyQsTyTqg2D9L7WX2yM
	 2YVUuBtbVOY3/D4t49N5Yy+FRqPEDXIaeGHoQTT7h7Tt3ELLZfedzkDX06MymVZHGo
	 gZ83lZ/ZcoL9USNS1bfrcS7dOsq69wrvT9Qy2snDigPKgQfSdgsNGiZ+ZmulPoiK7N
	 lLvjE7UUh2gCA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:21:36 +0100
Subject: [PATCH RFC 21/38] proc: let proc_remove() remove the entry it was
 given
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-bugfixes-v1-21-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
In-Reply-To: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
 Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, 
 Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
 Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
 Greg Kroah-Hartman <gregkh@suse.de>, 
 Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, 
 Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
 linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
 linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, 
 ntfs3@lists.linux.dev, platform-driver-x86@vger.kernel.org, 
 coreteam@netfilter.org, kexec@lists.infradead.org, 
 linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, 
 netfilter-devel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 ibm-acpi-devel@lists.sourceforge.net, jfs-discussion@lists.sourceforge.net, 
 linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-cifs@vger.kernel.org, linux-fbdev@vger.kernel.org, 
 linux-hwmon@vger.kernel.org, linux-mm@kvack.org, linux-sh@vger.kernel.org, 
 linux-usb@vger.kernel.org, samba-technical@lists.samba.org, 
 sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, 
 linux-doc@vger.kernel.org, linux-serial@vger.kernel.org, 
 linux-atm-general@lists.sourceforge.net, Takashi Iwai <tiwai@suse.de>, 
 linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
 linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
 linux-debuggers@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Chuck Lever <cel@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=4142; i=brauner@kernel.org;
 h=from:subject:message-id; bh=adm/sQF7056an061Kf+c19uk6i/tg5VeFqy/1HsVnNo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9mJO94Vf79rbgFkGjg/dWX74aWPnxgZ3nnePVE5vOV
 HF8N+le01HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjAR6Q+MDM3FETYHc1qe353c
 9GCX1JmypW9EjzP2Bgsk5O+InsxuNJ3hn1riCsbHBiye0iWZCQbb/19b1Pias9fFyzP/0MYJD5e
 u4AAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: umtqrnx87rfdpn7tdjpibsyyq4g8795k
X-Rspamd-Queue-Id: 2E2F2C000E
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793629602-695062
X-HE-Meta: U2FsdGVkX181vb/U3jMN2teF5qaZ/Ok11JsQptWdxMldZt6esnILZJPWOmiiF9trx5OhMxrjP0S/5elJTuNj38Z6cGxWH09GzxCVG/H3YaO2SVQTWsmwgKGHtLaiYYVSqyZBz/HvEZkck3zrVYo6fcnk/PL6RcJOmUuq++kW4a6LMN+H9bVdEsAI6GW6nZL18lbAzoKLQjo5PrQssjrvY8LhGhhIP1ULF3WAHJAJuhsQwuEFoVd4EpNg08Th/Nb3d/pyxbJ2MD37jzaSZxY8AUjotPC8bPKZHu8boTPBRJIQo4rPUZReM8VGBGZGpoR/egDk+blyYyWT4FQcH6+WKa/tyFkRfdcW5ft/BcUVmyu+9GJgXlCEINQX0FaiH1z7uxUGUcF+ILwrPUClnM4JCIwzF1Qw2PK7fdkK3zcjakcZwirF7dwaSfLXH3E5aPuVHWD6wRjvB1MqaGO06lfu0EdvFYsmqHpdxsuaCCvrq4qWwuLRGu2LdZ9mpWsgu0FN2HX5tPldY+YVSgziKH+LVWG09KH8GI7HcdMxyt/S6voOopq4ZwRnzsY2B9vtJgHEmsyMwETlVbDG/4F8PhhS8f53Bq4bXUJXL7tnebddQRKXIVGRzzb9BVkSQKED/MzOHA1SyOejspi7tFjXId7jYB/2aZembuRwLkbd08ILpHndRy1BnYVK5p64ZIYtMgTBPdAtexI2DCg+u9iW55UtYcx6QAGbjDRuOOzwSXDZj9fY+AvLp0lKx2glnZL2Ylu3lCHDx5yM7lzFqCaoB12Srhd4DUKKZz50dp9K9pk0dfMWfX4FK6Izp/YfP1S3No9ijoo3v3rT2lxThTk8F4z9SFKikLMW9KW3S/LRLDjca3Yxuehfi3+diI3AKIm04qlVb7DFtaJ/Q3gX/OO4M6xgb2eWG45Ekg6v9CvHAdU+/OHYjwS1HZRdY6uwY2B3Dw0nm+HcSv/F/ZUxzKY1z52
 o296dosc
 0Tndu7IKGdQ8n2gg0I2zWtQ/nB85fIHnKRFJMZwU2gPSUOYpdLWRWO2khUhiQbqLEJbF67N5a0b/D1ouW/LpFrByaDU09itxQUOrKwDytNfo1LO6PRSEhVP8iMNRrmQO12LlXMIjHVU11CQ5n1Ma3awnCFQTZNgzMigqZUpWMEcqEH+mtDyjvV5dNXhGdAPj8EjmshMig25Fx0qCMUp6FD4r7XYps/KwAve94hDOpevZegZftOzfqhnayA09o5n1PMz6rq6jSsBAmZCzoSL/LdIlsg7ODidRhhMUom4KKFR27DWifKlTuqj7MN2RbePdTIdfKPnigIBlRyZaECwFkB0JwQA8FMSoCL1lhSVWtWMflve9stjZufUAG0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

proc_remove() looks the entry up by its name in its parent and removes
whatever it finds there:

  remove_proc_subtree(de->name, de->parent);

If the entry was removed already, say along with its parent, that is
either nothing or a different entry that got the same name in the
meantime, and de->parent may well be gone. Two removals of the same
entry are a bug in the caller, but going by the name turns it into
removing an entry that belongs to somebody else.

Since commit 895b4c0c79b0 ("fs/proc: fix uaf in proc_readdir_de()")
an entry that was unlinked has an empty rb node. So check for that
under proc_subdir_lock and otherwise remove the entry itself, with the
loop of remove_proc_subtree() moved into a helper both of them use.
Nothing can help a caller that passes an entry that has been freed
already.

Reported-by: Chris Mason <mason@kernel.org>
Fixes: a8ca16ea7b0a ("proc: Supply a function to remove a proc entry by PDE")
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/generic.c | 78 ++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 51 insertions(+), 27 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 47830d6af255..23fc026d7bbb 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -817,33 +817,14 @@ void remove_proc_entry(const char *name, struct proc_dir_entry *parent)
 }
 EXPORT_SYMBOL(remove_proc_entry);
 
-int remove_proc_subtree(const char *name, struct proc_dir_entry *parent)
+/*
+ * Remove @root, already erased from its parent, and everything below it.
+ * Called with proc_subdir_lock held for writing, returns with it dropped.
+ */
+static int __remove_proc_subtree(struct proc_dir_entry *root)
 {
-	struct proc_dir_entry *root = NULL, *de, *next;
-	const char *fn = name;
-	unsigned int len;
-
-	write_lock(&proc_subdir_lock);
-	if (__xlate_proc_name(name, &parent, &fn) != 0) {
-		write_unlock(&proc_subdir_lock);
-		return -ENOENT;
-	}
-	len = strlen(fn);
+	struct proc_dir_entry *de = root, *next;
 
-	root = pde_subdir_find(parent, fn, len);
-	if (!root) {
-		write_unlock(&proc_subdir_lock);
-		return -ENOENT;
-	}
-	if (unlikely(pde_is_permanent(root))) {
-		write_unlock(&proc_subdir_lock);
-		WARN(1, "removing permanent /proc entry '%s/%s'",
-			root->parent->name, root->name);
-		return -EINVAL;
-	}
-	pde_erase(root, parent);
-
-	de = root;
 	while (1) {
 		next = pde_subdir_first(de);
 		if (next) {
@@ -871,6 +852,34 @@ int remove_proc_subtree(const char *name, struct proc_dir_entry *parent)
 	pde_put(root);
 	return 0;
 }
+
+int remove_proc_subtree(const char *name, struct proc_dir_entry *parent)
+{
+	struct proc_dir_entry *root = NULL;
+	const char *fn = name;
+	unsigned int len;
+
+	write_lock(&proc_subdir_lock);
+	if (__xlate_proc_name(name, &parent, &fn) != 0) {
+		write_unlock(&proc_subdir_lock);
+		return -ENOENT;
+	}
+	len = strlen(fn);
+
+	root = pde_subdir_find(parent, fn, len);
+	if (!root) {
+		write_unlock(&proc_subdir_lock);
+		return -ENOENT;
+	}
+	if (unlikely(pde_is_permanent(root))) {
+		write_unlock(&proc_subdir_lock);
+		WARN(1, "removing permanent /proc entry '%s/%s'",
+			root->parent->name, root->name);
+		return -EINVAL;
+	}
+	pde_erase(root, parent);
+	return __remove_proc_subtree(root);
+}
 EXPORT_SYMBOL(remove_proc_subtree);
 
 void *proc_get_parent_data(const struct inode *inode)
@@ -882,8 +891,23 @@ EXPORT_SYMBOL_GPL(proc_get_parent_data);
 
 void proc_remove(struct proc_dir_entry *de)
 {
-	if (de)
-		remove_proc_subtree(de->name, de->parent);
+	if (!de)
+		return;
+
+	write_lock(&proc_subdir_lock);
+	/* Removed already, maybe along with its parent. */
+	if (RB_EMPTY_NODE(&de->subdir_node)) {
+		write_unlock(&proc_subdir_lock);
+		return;
+	}
+	if (unlikely(pde_is_permanent(de))) {
+		write_unlock(&proc_subdir_lock);
+		WARN(1, "removing permanent /proc entry '%s/%s'",
+		     de->parent->name, de->name);
+		return;
+	}
+	pde_erase(de, de->parent);
+	__remove_proc_subtree(de);
 }
 EXPORT_SYMBOL(proc_remove);
 

-- 
2.53.0


