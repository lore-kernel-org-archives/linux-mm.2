Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61DE6606C3F1
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ccK9IwZ2
Received: by kanga.kvack.org (Postfix)
	id 8A6536B05E6; Mon,  2 Nov 2026 09:28:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87DB96B05E7; Mon,  2 Nov 2026 09:28:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76CC96B05E8; Mon,  2 Nov 2026 09:28:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 47CB36B05E6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:28:59 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DF70CA6285
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:28:58 +0000 (UTC)
X-FDA: 85390410756.14.77E13B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2FD89120007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:28:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ccK9IwZ2;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793629737;
	b=g/sGn5bFdL1Tl23jJsJu/k4fbTFv7kCSE0gqnWGNWyGYHpdGWRHALtZ7oFf2kWVogAi8BH
	vVDHrRasu5Z8ssSXzlXVp1hUqqotLJZo5w1de6/cLSV2tqbF72fgOdlQ60Qm4gvU+RlQVb
	NXaWejPO5OVlEL0L4LrZZSG2axBCSf8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ccK9IwZ2;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793629737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XiY4DYbDFOQzsur4dsXe00fq74GEf+50WHY2d0xcL1w=;
	b=kFnUnbFZPF5TkdQk2rYU+wjmJe6nTO4aOCPsmb6stDTLx0yXhnsuXSYjzq3CpCK4C5f0iV
	nB5VBHW3ljmZqzD4o410AwI2EI7zn46E4/RolMupTQwfTRSlmXsd7HqN7isbgtkYmUy1/q
	54+Cb5HNoFHGqKKx7OdfyzufeH7u8MA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AF324605ED;
	Mon,  2 Nov 2026 14:28:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4581F00A16;
	Mon,  2 Nov 2026 14:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793629736;
	bh=XiY4DYbDFOQzsur4dsXe00fq74GEf+50WHY2d0xcL1w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ccK9IwZ2RL3c7Hy5HZzwdHvXaNaGEP1ChdB7VM84tsCaQ/e8r1nS4+9u7d7e0yAEX
	 o5/ZDGPl9K4GuclD+kk90STbN5FxtWo+gUSw2mvruWyBftbc9DQWq4rFNfC2tz9RhT
	 ZK6VIgyDlWShu/QH9u3X2Kw1zgWsfkqIyhYGecDGydGGid39AAHco88m05Wppl8aTe
	 ccS57hTC3taUO0J/byUbxA0h7x/ybz6vqMXDyE5opv6i4PNG4GiLmyriRl5XKf0pqQ
	 vVsMOApctetsDaa7KIpt9Pkcr4GpedPJlr79XxSiDLZAUjs4BN9QKFACzOXnnO6P1j
	 F2Bry1T1wFZTQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:21:46 +0100
Subject: [PATCH RFC 31/38] proc: sysctl: resume readdir after the last name
 it returned
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-bugfixes-v1-31-59422ed3e465@kernel.org>
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
 Chuck Lever <cel@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=6760; i=brauner@kernel.org;
 h=from:subject:message-id; bh=uVHmiW/kcnqfpMjVEbqExYuffumnSnR0NdR9kllvaCA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9mJNzU5YpvSPCj1uM2UPakevStcYsHqNsvqO1Art+s
 3+bsPxaRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwETClzEynPA9d/Cr/asOT6nq
 Cy/j74k9mbZAb9YXNanby29PWFm5lp2R4WHo9q1CpdazUjk8ZXPOOG6pZeyTv+X/rVF0Auu3H/f
 +MQEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Queue-Id: 2FD89120007
X-Stat-Signature: bfnsqo65mztagncfonndmhzbq5ea8s5m
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793629737-671675
X-HE-Meta: U2FsdGVkX1/bWZsJY/oEkjgcItDrUq5wZkNdI5j3Nb5VcsyxYZrnakp+zmWM6kf7n/UHAiZADtany+RRFtdyFONE6We69udKQH3crZxohIdrsKGm5cOKcFCEAoTUKlns7dYcATR6FVm6GHnlR2bWZLxmntLslGAv8SUQ7FYR+fs3fOT5ziV8HVinL6kDCLlGZkamZlPF5FE45ddfUh2nQZV3sokZUB2wDKvz8N7xXudDalCH6zl8rhcUgFDOy2sC1i+baAWqv7pcxcH8Z7/CT3MW6T7RtKV6ybQCokbwPOd+tX7+PBvepibY0WgxdO8FkvNryrAVBHJW1RPOyhD4AsO/mRpe0zdVpagxe+mKWeoh+AVA4it7V+4q+j0Iq17NaPgdVrucrdcxBGHCMF1W4czkD8vcobRHxPSizgrpdfpxZxKrc3QBD6q/eObNOpUZaRuL51/9matzYj55TUWie3B+qmATtWFOSwPDoB7ILf0oNp83Q5Xhx9T9UCSWXfpv9lro4hzXenPm0wqhuWdr2TahYF5pQS3BXEbyqzMpdtzfky+u/MhC3VZfiGsVvOF19EWALlS9e+C5GquTVq7sP+XUm9AWJ/tS880BiJoonDjn2dTenusctFD5bymP3O9zqk6OPwbjybvApms6ZoX9fTIp6Q8yCtvimUutj7Wzqy89+0OOnP1CYcxzW/+6Y+SOWJhcj2coGA4q1Gc/R97t/+YAquOC22hgMDrJ/OXZEnYHT01jtc2o7HyInN5KNP/avwS9Tl3/eL/cnaLqru8G8HPlMt8zf9AgewYdoPuUOO3xufSuhHfZcVFTMv28Gaqns/5AOc5xX+On/HxV4d+1jL54w55zApHCUWSy17/ljwy74XKXDlEo3X7OhUPI1RThGx9qv7dMZNXKa9VzLeSsf0dlEHrdR+ex2OA/oRBkOGd734ULX19f1gQkLqnZF2TkpcLKFDN0vWUbS52DvfB
 vRZ4/bJE
 zJsn8jGaiGcNIk1oFSqMSrBjeXQg8XR2bF4N1X0SPehbhX0Bo+OQ+sJ8f471gE/Iu72/zZajqIID9URO/0Jac2HHQ/6Oc9jtDE6oZ10kMIgOHr881L8aIdGHymG9szCR33Inoz7hu6Z+hgi/OW9TPj8zYeOjGn5GGun7bTrxS9ISqVY3fZZgpNFV+4RHmGglYySFllrDat469iagTF06wl6lbERWn6oEw/x//R6aES+i1GbK0aATftqNmo5dGtX1ilKOko6yOigYd/NzSxHwnU86z0pcc1xPWmeLx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

proc_sys_readdir() counts the entries of a directory and resumes a
listing at the number getdents64() stopped at. The entries are sorted
by name, so one that is registered or unregistered in between shifts
everything behind it by one. Listing /proc/sys/net/ipv4/conf with a
buffer that holds ".", ".." and "all" and registering a device whose
name sorts before "all" makes the next call return "all" a second time.
Unregistering one that sorted before the position makes it skip an
entry instead. So a listing that takes more than one call shows a name
twice, or not at all. Even the 64k buffer of ls needs a second call to
find the end of the directory, so a device that comes up right then
repeats the last entry.

So remember the name of the last entry a call emitted in the file and
resume at the first usable entry after it, like kernfs resumes after
the node it stopped at. The entry itself can't be pinned across calls,
unregistering waits for that. If the position was moved by a seek in
between the listing counts from the start like before, seeking to an
arbitrary position has never been better than that.

That also takes one walk down the tree to resume instead of a walk over
every entry in front of the position with a round trip through
sysctl_lock for each of them.

Fixes: 77b14db502cb ("[PATCH] sysctl: reimplement the sysctl proc support")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/proc_sysctl.c | 106 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 103 insertions(+), 3 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 6c0859c66563..38b61887b59c 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -417,6 +417,54 @@ static void next_entry(struct ctl_table_header **phead, const struct ctl_table *
 	*pentry = entry;
 }
 
+/*
+ * The first usable entry of @dir after @name, or the first one at all for a
+ * NULL @name. The entries are sorted by name, so that is where a listing
+ * resumes when entries in front of it came or went in between. -ENOENT if
+ * the directory is being unregistered.
+ */
+static int entry_after(struct ctl_dir *dir, const char *name, int namelen,
+		       struct ctl_table_header **phead,
+		       const struct ctl_table **pentry)
+{
+	struct ctl_table_header *head = NULL;
+	const struct ctl_table *entry = NULL;
+	struct rb_node *node, *after = NULL;
+	struct ctl_node *ctl_node;
+
+	spin_lock(&sysctl_lock);
+	if (unlikely(dir->header.unregistering)) {
+		spin_unlock(&sysctl_lock);
+		return -ENOENT;
+	}
+	if (!name) {
+		after = rb_first(&dir->root);
+	} else for (node = dir->root.rb_node; node;) {
+		const struct ctl_table *table;
+		struct ctl_table_header *h;
+
+		ctl_node = rb_entry(node, struct ctl_node, node);
+		h = ctl_node->header;
+		table = &h->ctl_table[ctl_node - h->node];
+		if (namecmp(table->procname, strlen(table->procname),
+			    name, namelen) > 0) {
+			after = node;
+			node = node->rb_left;
+		} else {
+			node = node->rb_right;
+		}
+	}
+	ctl_node = first_usable_entry(after);
+	spin_unlock(&sysctl_lock);
+	if (ctl_node) {
+		head = ctl_node->header;
+		entry = &head->ctl_table[ctl_node - head->node];
+	}
+	*phead = head;
+	*pentry = entry;
+	return 0;
+}
+
 /*
  * sysctl_perm does NOT grant the superuser all rights automatically, because
  * some sysctl variables are readonly even to root.
@@ -675,6 +723,36 @@ static __poll_t proc_sys_poll(struct file *filp, poll_table *wait)
 	return ret;
 }
 
+/*
+ * Where the next readdir resumes. The entries are counted, so one that is
+ * registered or unregistered in front of the position would shift what
+ * the next call returns. The name of the last entry emitted doesn't move.
+ */
+struct sysctl_cursor {
+	loff_t pos;			/* the position behind the entry */
+	int len;
+	char name[NAME_MAX + 1];
+};
+
+/* If this can't remember the entry the next call counts from the start. */
+static void sysctl_cursor_set(struct file *file, const char *name, int len,
+			      loff_t pos)
+{
+	struct sysctl_cursor *cursor = file->private_data;
+
+	if (len > NAME_MAX)
+		return;
+	if (!cursor) {
+		cursor = kmalloc(sizeof(*cursor), GFP_KERNEL);
+		if (!cursor)
+			return;
+		file->private_data = cursor;
+	}
+	cursor->pos = pos;
+	cursor->len = len;
+	memcpy(cursor->name, name, len);
+}
+
 static bool proc_sys_fill_cache(struct file *file,
 				struct dir_context *ctx,
 				struct ctl_table_header *head,
@@ -753,8 +831,11 @@ static int scan(struct ctl_table_header *head, const struct ctl_table *table,
 	else
 		res = proc_sys_fill_cache(file, ctx, head, table);
 
-	if (res)
+	if (res) {
 		ctx->pos = *pos;
+		sysctl_cursor_set(file, table->procname, strlen(table->procname),
+				  ctx->pos);
+	}
 
 	return res;
 }
@@ -762,6 +843,7 @@ static int scan(struct ctl_table_header *head, const struct ctl_table *table,
 static int proc_sys_readdir(struct file *file, struct dir_context *ctx)
 {
 	struct ctl_table_header *head = grab_header(file_inode(file));
+	struct sysctl_cursor *cursor = file->private_data;
 	struct ctl_table_header *h = NULL;
 	const struct ctl_table *entry;
 	struct ctl_dir *ctl_dir;
@@ -775,9 +857,20 @@ static int proc_sys_readdir(struct file *file, struct dir_context *ctx)
 	if (!dir_emit_dots(file, ctx))
 		goto out;
 
-	pos = 2;
+	/*
+	 * Resume after the last entry the previous call emitted. Only a seek
+	 * that moved the position away from it counts from the start, like
+	 * seeking to an arbitrary position always did.
+	 */
+	if (cursor && cursor->pos == ctx->pos) {
+		entry_after(ctl_dir, cursor->name, cursor->len, &h, &entry);
+		pos = ctx->pos;
+	} else {
+		first_entry(ctl_dir, &h, &entry);
+		pos = 2;
+	}
 
-	for (first_entry(ctl_dir, &h, &entry); h; next_entry(&h, &entry)) {
+	for (; h; next_entry(&h, &entry)) {
 		if (!scan(h, entry, &pos, file, ctx)) {
 			sysctl_head_finish(h);
 			break;
@@ -788,6 +881,12 @@ static int proc_sys_readdir(struct file *file, struct dir_context *ctx)
 	return 0;
 }
 
+static int proc_sys_dir_release(struct inode *inode, struct file *file)
+{
+	kfree(file->private_data);
+	return 0;
+}
+
 static int proc_sys_permission(const struct mnt_idmap *idmap,
 			       struct inode *inode, int mask)
 {
@@ -867,6 +966,7 @@ static const struct file_operations proc_sys_dir_file_operations = {
 	.read		= generic_read_dir,
 	.iterate_shared	= proc_sys_readdir,
 	.llseek		= generic_file_llseek,
+	.release	= proc_sys_dir_release,
 };
 
 static const struct inode_operations proc_sys_inode_operations = {

-- 
2.53.0


