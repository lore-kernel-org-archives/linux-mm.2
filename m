Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8D1F606A332
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K+qv0mwQ
Received: by kanga.kvack.org (Postfix)
	id AB50E6B05D5; Wed,  4 Nov 2026 14:27:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8B896B05E0; Wed,  4 Nov 2026 14:27:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A29D6B05E1; Wed,  4 Nov 2026 14:27:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6D07E6B05D5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:27:46 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E12BAC07C4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:27:45 +0000 (UTC)
X-FDA: 85398421290.24.B111C4B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 26EBB80002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:27:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K+qv0mwQ;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8vwIQDZABfbDXUA4Rhtj/FFiRIzet50vFXOLtBzgPyU=;
	b=V6O7ZPuaqmRwUEpORkqbWpD8kWAp1wcKlYyIKLFYZkGywq8OOBm5V0mcQNdilb+f5hv3LP
	onvLDwmAHduuoxbxHozXtyCorr4uhN1cwjZw13slFEtIwx3ukP6l60VnM0FRpJsjhmhjrp
	UjRe1W/UstDo4gn631KHkoSoihzkvIU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K+qv0mwQ;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820464;
	b=qC4HJwUNN4tdu0s6oyC8KlWbf8sZZO8KG48B6mLbVwg25+35vdI8h7ennmvkvkoCr88je0
	LW/rCUwlQREve4DZeA9vDzNMce0mwRZE5qIVVAKtV95htrNYBMl/LYfz6+Rup/fggHJAuU
	OkUvXwk/MDnQFGCjBm5Lm5sK0LivTi8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6865940510;
	Wed,  4 Nov 2026 19:27:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA621F000C1;
	Wed,  4 Nov 2026 19:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820463;
	bh=8vwIQDZABfbDXUA4Rhtj/FFiRIzet50vFXOLtBzgPyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K+qv0mwQcjtL/qGdS6zLTIdv/G0RXM8xsdMjUnhgG0fNfAYk4b2pJX930sQZnPQep
	 +LPdNInthRhEsKuQKDBplBRNncD5RXDkf1MmvrNYXt/kezR7Og4AukJlDkC+uqQdvQ
	 3UcyZsZ5M2SCBuJu/oEitA7gekht06is34RQC+0SGBCyvPBf2/f+wRq4YKjtHH607t
	 u2wONuJ6/ShFerskIef6UB1DalfazMx1QVWxa/FYtYmDpi1QxRXXlAEaJ1aaOkdQFG
	 kAOIkXKB/WNg0BuIpmEdndNkSZIlkssgbriZFcnsRM4VXunhgfFvWP2W8uGj5+pKbF
	 w0V3MGDPqlrPQ==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jann Horn <jannh@google.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Chris Mason <mason@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Eric Dumazet <edumazet@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jonathan Corbet <corbet@lwn.net>,
	Christoph Hellwig <hch@lst.de>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Joel Granados <joel.granados@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jan Kara <jack@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	netdev@vger.kernel.org,
	ntfs3@lists.linux.dev,
	platform-driver-x86@vger.kernel.org,
	coreteam@netfilter.org,
	kexec@lists.infradead.org,
	linux-pci@vger.kernel.org,
	linux-sound@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	ibm-acpi-devel@lists.sourceforge.net,
	jfs-discussion@lists.sourceforge.net,
	linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	linux-hwmon@vger.kernel.org,
	linux-mm@kvack.org,
	linux-sh@vger.kernel.org,
	linux-usb@vger.kernel.org,
	samba-technical@lists.samba.org,
	sparclinux@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-doc@vger.kernel.org,
	linux-serial@vger.kernel.org,
	linux-atm-general@lists.sourceforge.net,
	Takashi Iwai <tiwai@suse.de>,
	linux-input@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-modules@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH RESEND v2 47/51] proc: sysctl: look at the table under sysctl_lock when creating an inode
Date: Wed,  4 Nov 2026 20:27:29 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-47-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2783; i=brauner@kernel.org; h=from:subject:message-id; bh=qNc6cmXDzjiIgH+LQmxRb8DpjTAU1o7z7wzEsOSW+y4=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bmJza0sIPDqr+OtjFeG4XR03HmoLr7n57Jt/hcxie 69L4b9dO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACbi187wv2hWT/9l9+XPdiy4 Mvm7x6F5LA4Csrv4Z0ak9SrWM8XotDD8M7ASkA469SZgqbzuxov6f2ekegdpRrKw1vJ3ZETYaKT yAAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dzcmfgb4xmxxmmy8rh86ti84nzwixbgg
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 26EBB80002
X-HE-Tag: 1793820464-228564
X-HE-Meta: U2FsdGVkX190wWueqChbcWYPtI2mDRKgI5m/Z5QHk74HfZjSAhO1ze0iF272eNROGj3tkipv6lnqxZ4ouDD/TKWQm6aT7hR1nnZOMkc0ZUmchUyz8gkuPKNvpqKrhGCXAR4CM9blZV1nTxY7YFHZXqjfExAHEzPkwx/rxB9G9L0K6Sn5kWpHsp+DzkglBVuw54Fsv+SzHJ5G5r8j6UzW/wsb8lDk+zgIzFsr3zFeug65wgdnnSkXMq/3mS9rpRpIth3it5BbYW+qCynIkYbUZtHWMbw4A/DIW4L2jPAq1LoCte5WyNrjmVjLIVK1/o1XcgkwjosUJQHKTehZW97jL2V+H9cakKnOVWeZ83lOKQqUaaKXIfmIOdGiT5LtjtG5xFT81zX6AqZF9WdxF1UBUPYbYzszunbMtt/07yiqdttso75k4CGpDlHP8Eojd2uRo1fh/TFWzqXH+ylwJK8rkjxs66VNNKYFQDvruwvzo3X0EEG9xLr8FtKwVtdM2gP5d6d5ZE3kDURU3IfWjyW9LblPcLerysSpRHONFL54uvahtR1rKb1viGKzEhTz1/+3xQtqfebeqynyxhgc4hYib0Nn0jmbyJwBj9dC+LIU2gkvBQQ3r19t+OgW+jkOGrDmGWAl8r0dMscUfEq+CHCqMujFdLKhJlK0kkBxtbKiN8sPT7111VD83dwzsCOcsfcCQ3DAZAfCEYpuC44Ay9jUP909sRcg+FiBs/EFbyLFfP24nE/NjEilwc3HojM2JiDR8sP9wOWNs1rgttAhxvd9dccmzdgnnm65I0nTj2b2QBQE4oDgHLWzZrz0v/qQt4jYN72BwfPbs4dXMAzx24oLvY4Rb2twauH8LIXJVTAPt/GClSihOlXAbUuLpOoz07/0SHGq2HlpqPIC5jiUaU3p9KTtDegYoerrd/cCShvHnxsEGKmy/XOue3KRyz6fnwoGhA64A0yqO/fMB3+xRzK
 I3QElfCi
 Fad9+sNNupXVZy2BhyDIzoStzc/wiSjDKEwHP8tBbbmbkVm/+lzPD9Y1sOsT4JDkpy6TcPLX+SqHlwATqxosYN5dfBtQfJ0Er1kPPhF0LXO7gsznrP802YlSznyvc9rCM0qDts7vfXuJDyMQH4Crby5aoBcD2bVgwl/ep/2etxoklJOL/uRQY8Gac7w/oHp+puFVUCxIDs3KshW9tyOns4zPmjQV/XX391+EZjDOK++lH+5Hw35/OxgFblEoGrguBapjS3zlzNTViQT6SWowZkmSbAWlGonsH4NPv9n//qNFQFampbvhy2Eqs4fgLpqVP/MzXd1YK891yFWiuqOyCyVvLpuu2ugbAF70vGeC+iN6VVYOB5RIsQOIlmrILcSsjrjZEcBe7wkTCTZ7H6UXtLqxvgSbIts1T1bWPW9SUZAp+eb/066Zn/Fku2DBmG4EHWtDaSh0FP3JiqNKo7DCECK0O9k0BFf7WHYrg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

proc_sys_make_inode() checks under sysctl_lock that @head isn't being
unregistered, lets go of the lock, and then reads the mode of @table
and calls ->set_ownership() with @head. That's fine as long as the
caller holds @head in use, which keeps unregistering from getting past
that check. The next patch has a caller that only pins the memory of
@head. For that one the table, and whatever the owner of the header
keeps behind it, is only there for as long as nobody unregisters the
header, which happens under sysctl_lock. So read the mode and set the
ownership before letting go of the lock. The ->set_ownership()
callbacks only look up ids in a user namespace.

No functional changes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/proc_sysctl.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index f5c9f04e8509..82024f1ea756 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -500,6 +500,7 @@ static struct inode *proc_sys_make_inode(struct super_block *sb,
 	struct ctl_table_root *root = head->root;
 	struct inode *inode;
 	struct proc_inode *ei;
+	umode_t mode;
 
 	inode = new_inode(sb);
 	if (!inode)
@@ -509,12 +510,22 @@ static struct inode *proc_sys_make_inode(struct super_block *sb,
 
 	ei = PROC_I(inode);
 
+	inode->i_uid = GLOBAL_ROOT_UID;
+	inode->i_gid = GLOBAL_ROOT_GID;
 	spin_lock(&sysctl_lock);
 	if (unlikely(head->unregistering)) {
 		spin_unlock(&sysctl_lock);
 		iput(inode);
 		return ERR_PTR(-ENOENT);
 	}
+	/*
+	 * The table, and whatever the owner of the header keeps behind it,
+	 * is only there for as long as nobody unregisters the header, which
+	 * happens under sysctl_lock. So look at them before letting go of it.
+	 */
+	mode = table->mode;
+	if (root->set_ownership)
+		root->set_ownership(head, &inode->i_uid, &inode->i_gid);
 	ei->sysctl = head;
 	ei->sysctl_entry = table;
 	hlist_add_head_rcu(&ei->sibling_inodes, &head->inodes);
@@ -522,8 +533,8 @@ static struct inode *proc_sys_make_inode(struct super_block *sb,
 	spin_unlock(&sysctl_lock);
 
 	simple_inode_init_ts(inode);
-	inode->i_mode = table->mode;
-	if (!S_ISDIR(table->mode)) {
+	inode->i_mode = mode;
+	if (!S_ISDIR(mode)) {
 		inode->i_mode |= S_IFREG;
 		inode->i_op = &proc_sys_inode_operations;
 		inode->i_fop = &proc_sys_file_operations;
@@ -535,11 +546,6 @@ static struct inode *proc_sys_make_inode(struct super_block *sb,
 			make_empty_dir_inode(inode);
 	}
 
-	inode->i_uid = GLOBAL_ROOT_UID;
-	inode->i_gid = GLOBAL_ROOT_GID;
-	if (root->set_ownership)
-		root->set_ownership(head, &inode->i_uid, &inode->i_gid);
-
 	return inode;
 }
 

-- 
2.53.0


