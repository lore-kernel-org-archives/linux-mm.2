Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14B8A60703B4
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RW+vtAzi
Received: by kanga.kvack.org (Postfix)
	id 23ED86B05EB; Mon,  2 Nov 2026 09:30:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EF446B05EC; Mon,  2 Nov 2026 09:30:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DE896B05ED; Mon,  2 Nov 2026 09:30:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D95356B05EB
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:30:00 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6FC0D1C085F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:30:00 +0000 (UTC)
X-FDA: 85390413360.26.645005F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id A983B140007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:29:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RW+vtAzi;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793629798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SA3lGiy6S79OdVacoNeeNA0LWGoA0p1Ppo9PoyQO2Ks=;
	b=PwokY3Kncr3FBWuSLiLLJPF9gZi+xvGzm+J7tEZkPOjRvEwIPmHmsORHbAAVy3K4CSo1H9
	3I26Bwhls3UHH0Mp7riUAo43CwdQkiblv9tMhBtV/6sXQ/DntYVy2j6+iGzDEE9mLdb1o5
	nt4iNEkR+wKoiX5qNFt2immEoS7JXj8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RW+vtAzi;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793629798;
	b=u0djOUNWNo4fHNiy1VqY2r7HvUtstzfYVHZml8mEC6Q1MkbyC79noeRvc5lTLMy/PBeCvN
	Pnuzj4BVxXJ8yRymi+H12mxUfOqXfE2IrJhOEJPeAXrVNWh1/u+ZjtEEnLJ4LuFxHpLuEE
	9FWPJWjM5D1Nubkh9S2mbnmC0gIgvOU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4C06F60618;
	Mon,  2 Nov 2026 14:29:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3171F00A17;
	Mon,  2 Nov 2026 14:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793629798;
	bh=SA3lGiy6S79OdVacoNeeNA0LWGoA0p1Ppo9PoyQO2Ks=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RW+vtAzixHFdftAw+FFf7X1DqyjNjrm5rXJzLqMgENvUyh6lxSop0zLX2+vQS8q3U
	 qRZVYZNACtSOXvDQAbomlArmJKHhYUFIBB2YrfNds0mv1wfARpxrZIlRmEwlYwFopc
	 5VdZGPqAWRIGCJ/WjNt4zJr1epJ29nqoWmRFqTaIbIhCMRcObitFsIcVlAgJcZod0r
	 ACWF7EpwiUSzD42RWAztKJAwpw5HeZTLOr4cdHEhkz65HDjFGe1NQmquxEr2sddSYL
	 RwpzOOV7W3I2TVeiKdqC8qxeUtM4wH2oSQalOWqHC31war9q1hlS5ta/ceFelklXjl
	 B3xNbX+COlrjQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:21:49 +0100
Subject: [PATCH RFC 34/38] proc: sysctl: look at the table under
 sysctl_lock when creating an inode
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-bugfixes-v1-34-59422ed3e465@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2783; i=brauner@kernel.org;
 h=from:subject:message-id; bh=C8EYtx2R+lYWtFHGeY0iXNf5hNAMg0s7P8pl3m1iKgk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9mJOj8UzGeLUCc9+ZM2pvbvxebnnhmpE+g+SSXWobN
 Dosy223dJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzk5QVGhrYU5dR7fIy37FMe
 6+iy+10qiYvReZc66/8Z5ztf76fa+DEynFt/fqvi+l16ifbTVh5Z/+J12e1rnoUitwqfWIbW8FV
 OYgQA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A983B140007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: jsqrtqwgk8hqfxo98u4yxq31br3pp3ij
X-HE-Tag: 1793629798-761809
X-HE-Meta: U2FsdGVkX1+4gRtHR6DaCIiDHruJrdE/SAnT/tZDaPXIY3Qk65v5d7cF3vhD8+i9idZDUjMDEiz2J2mwSLRWULqaEq6xAAv1NrLHG/gzw/QKtdy2C5mpdZndYc9yqSguIP1PdyPNz/xvZNaEi5qxhOo1p/vb3WMJVnY7GdEU01XzyvI6m7gx7pGg208y/5zbOBeGRPLyAR/qafGTg8HX4u7cwd5cBigobvAWI3eSvudyBB+X/yim83bA6pZm+kGNWv0PK5rYIR8f3q1WSSIUwzdIo5mD+hEkiKVj70Cxn2PDIeHMc9m2iQBpW8w62MDPDWfBPNR/tBt3wl7jg1xdhcgnaQsivxGuHAH8CJ+7S65IAvE3efAPeEi8KHOf5qJ9hxM2VbK+AjEdQkXHnMb8yYJPZtU5SQvkFRqfOf3kbA5yc8CaMURf7FjP0Myza+Ryh+BCCIlc1RRMgm6CwAzBqrPJQPshP9EkBIUHWtEVBXOHlmC6ERP2RvMfof02CX51fQobpv+qgIKIx1HOLRu8gAe3lpforvMrUxBt31Prnql3OwC1AfCEmlPGDT/IJ75qTqfEAHrkO3cts16lqjf87PPmos6gldz/GfQqeeWBMA4o9rHKQkFSec+Jprl0o4lSt1GMqn9c6krSoH3ArBp3DH9KZeB1fOHI4GdKtgViAaFwh0rQ5go4vHC/dL8qV+PiBUBrZJ/NrWu3yWtw6aQwg5ew+32zWBuUXDe4MryeCRp25+5Zc2g08y4FZjE3173N6oGgPJIWcp1zPhXgpcuB7sw+WofGhumjFiI/3BnvkElpXlJjMn/lyZJGX24dm+jaTk9jtNQCdFaikLD5aNMKIp4ue/iZp8AMdWKobmC+uWJu1OkWJWREI6AzyiKVpaqINTGRVG5hC4alhGR96CnG4tHcKSw/UrZGYbyIkx90NUbQDigC11CKjYtxEKK6tEv3Zvht1zmB/A3yN32RG5Q
 jp0yGyqf
 l6BEq9WH9wrUKSwRwY35JclUgJHxCz6plMjnBZalFtVmAaf+Bx6bX0v30cFlo0P8Ka38qo/3I50laepcep8w42Lk0EXFXyOSTUuQ57lNQnjO58LVe93QiGpvRd9mgE/vjfjStZ90FXMeF08gkjMxzH8C7h7VH3E2n6AT0Zi6ijcw6cRMM9eLa2QwOrH29PKb/bUourI15U7STNpVoAtFLL3DaYHryKVF4CsCwtsPsb1FfKjmvlK+8nMDA9JsBl9ausiSoaSX3g1ew/fwXhk08HgvrnM0E3sMYiBo6wkU0/sOvsY1E89oMs/SK7pIKsvAiCSAb7f4tm7+NQJQPapvRK6FADP4AYYPTsFzyce6mYxB8kQ0=
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
index 2150cf842919..a1242247f492 100644
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


