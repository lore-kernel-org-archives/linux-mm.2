Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A845606D804
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WTvTLYti
Received: by kanga.kvack.org (Postfix)
	id 5F9286B05DF; Wed,  4 Nov 2026 14:27:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CFF96B05E0; Wed,  4 Nov 2026 14:27:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E70D6B05E1; Wed,  4 Nov 2026 14:27:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D3C86B05DF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:27:32 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C651C8082A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:27:31 +0000 (UTC)
X-FDA: 85398420702.05.DB8602C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id EBB624000F
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:27:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WTvTLYti;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SGZXtenDzDnzN/hAwCoJvR7nlijFBob6FQl7GJGEPCo=;
	b=veJIVgF8qO5O+Enix1XwYhZKk96r7JenyDjwX0b8IVGR1e5P+NmTgeTCoao9jmS9zvdMff
	OPSTk/VSpqgPW5yPVzeQCow6ABqup29tXdvXLtBBknCoAvabqB4/Zh1yw3CrZ/4fBQE/nV
	pTjgtyGWEGG3E+u0DfbqiUKPw0252JI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WTvTLYti;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820450;
	b=pbPkCnQiJDXHfl2wSdJF8KCvW93hDKZ6bY7Cav4PkuPukb9lc1SIHb0L221HR2ULVaNEVq
	EcFZdVPV4GUs5vTxFiODWkMCw4LtyBua99D5eMhkApI1S0wJk5WMgsmKyddlwya4BmzFrI
	DHMgIeym5yz755GjIK6UyPd3iVf00bU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3074440168;
	Wed,  4 Nov 2026 19:27:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E111F000C1;
	Wed,  4 Nov 2026 19:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820449;
	bh=SGZXtenDzDnzN/hAwCoJvR7nlijFBob6FQl7GJGEPCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WTvTLYtifxKVDAKFEwxAEpP+KqKkmbss0O3FvCVjbPGqXrJpDoCPGQ5oGFz8SBrvF
	 tD4WfYtmmvZefQl5gXXU+H6104nXZB3j0cHwCa26xKcGLASKW04PHQjju0x3TofBoF
	 S79TIjcYh1lweJqcaNbaT/pbmq+p2weA2MdCekZKRls0X/Ylguuocf58PMZMsqe6iU
	 WvCIu6r2l53iIdxnn8bil7C8dwL66KwhqW+O2kINiXOW3Ed+Ri+kkytDZR5IK/8kso
	 n+9Fdzr9qEImJtKrDVp1BycV7REVcXz7sk4DiO2Lwzvv9u/aZkCNq9czsaCkPV2+GQ
	 KdO70U2m2nATw==
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
	Chuck Lever <cel@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH RESEND v2 46/51] proc: sysctl: copy to and from userspace without holding the table
Date: Wed,  4 Nov 2026 20:27:15 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-46-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3702; i=brauner@kernel.org; h=from:subject:message-id; bh=+LAd81fwJIRlW5EjEhH8yOMnOBiQOQqVJycA7u6Pdz8=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bmJ1eDRjm+PEc3vLTC2v/lkZcX9ytWi95Scpc5nVn y74amrGd5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzEMJzhvx/PlO0lwpvb3J5V fmKL8G+eIrrAz/ZQTsb51hX150VF7Rj+abVIqjzO1EzVz7t77eLZC5a9v0xatB6dWHvCQsyFq2M 7IwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: efscxxnuwqk9nar54zyqk6p665madkop
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: EBB624000F
X-HE-Tag: 1793820449-312261
X-HE-Meta: U2FsdGVkX1+xBo2+A3Htx0Wmr065KZPxN+asezpfBWLi/Y/NT/3g+Q5zsWGagDBS+n229yFB5z+5zAbw+1J2NdN2IOzbISrXhPwrZlF3iPG+IkaN8tbTqCk7mfuhOFL5j6lC75KBSZYRAOUyMs4OKhPgDjsGkgkJdGrZ1oz/OlZMIE4XjTkl8SRvU4IBHdohKGkJ9kxzVXCF92teD1jBK347/t3mTLrCdnYO+8hiNgWeTsF6jaKBs+2Y/BkhiW9QHZLV8SaSHj+sliFrJStw1mq8e8DJR5Ah3/Yx5hmoX8ZuGeHprNmQsM6X+kAGy535uvExR9hqgXP4jLbrmmqeDjdvXYcK0hQRmyiKq01fsMnLhw3W+gUZepKFgPBKVloIbNtsMI/gjVuSW9dX1b8/TU3/p969KNgrIDl8Gn0LalpZa/gD+w9SdUDsOvwi+dCD9kH8n1cHg1oILCtzKQksS3s0EV0JjtP/nI2ANpDHtvYo4XGRTlgnNrs+rOBlbAROukOApIb9h050w91kv19lAkkZ/qaNCr3ikX+oGBtYckt5FTDLZ9lNrQigvJWdnI4kF4CSXFTI5ken48Gh7/SOme5NVbkQ+ty4lawmXR0DgqgzO2b++hSbMiI4pv/DVPrzQbw3g/EjfBrFdmqyrvwIujZBIsE1Dh90mgJfGK0My/I7Efn8XqDMQ9ImK4NkiXaL9m3JSzen1I2umVC94Pi1y90UFnRfjyNpo/ACq/RWMexKLWQbaK5ULRBN9DH222Te0MvmiEL57Y8BQuYUtxqtdG2RbhlMAkJxE1rmjSpvYnnAJvX/EdXaQLUnmi0iWbvTBR4vmuhdtPw7RmfohgjmGNnfXttJyraPMot0xC+pxbW+4tA4m2uPqdeBtid5QdTBxaWEloi2IAuq/o3M9x64mCLDY5djdTB5Xs3nx+2uUrJ7zfYWOQDKb3OQyXTy69wvyFvTRf0kZse+6H3/mkM
 AGV6SqL+
 7FZcEW0da5+ds1g+htxakzreSYGfD8ySBqAfV771muvgg0koK6qsY9GKUumwHE7LHlUZ4XHhqU+ctffvqQY+vW0P1Uzo/2LxUU/kCvicUvoh7t7/S6DwF4e8zymQZbt5mSebH41wcwMTFI5XcQ+oFSK85qNQR44PB/CuzHqn9oS9+QLsWsps4hJAgWL0IGdCZk9T57Z/EBpDxsVg+9zN56Jr4h9C3p8ooccusjNbcvM88n81EjWTLKzV4socB5HvsLbq+cC1ghE3jCOjW5qAAcSwB/3eR38FCLh2HT9len6lfc3cDfC7+z5PMHIwdFWddUccCwgZDhbDFuz6+fKE/l0J/MiLPlGSW7vESg9QJqLgg96cCP1Wpt249EETHPf1ary+Tn3U40WWRm8y5/bZtRoWl4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

proc_sys_call_handler() grabs the table, copies in what is written,
calls the handler and copies what it produced out to userspace before
it lets go of the table again. Unregistering a table waits until nobody
uses it anymore. So a reader or writer whose copy faults for as long as
it wants, with userfaultfd or a stalled FUSE mapping, keeps
unregister_sysctl_table() waiting, and its callers like to hold locks
while they do that. addrconf unregisters the ipv6 sysctls of a device
with RTNL held, so a stalled read of /proc/sys/net/ipv6/conf/<dev>/mtu
holds up every RTNL user until the reader gives up.

Copy in before grabbing the table and copy out after letting go of it,
like procfs and kernfs do for their files. The buffer is ours, nothing
needs the table for the copies.

That moves the allocation and the copy in before the permission check.
A write that can't be copied in, or a request that is too large, now
fails with -EFAULT or -ENOMEM where it used to fail with -EPERM.

Fixes: 330d57fb98a9 ("[PATCH] Fix sysctl unregistration oops (CVE-2005-2709)")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/proc_sysctl.c | 50 ++++++++++++++++++++++++++++----------------------
 1 file changed, 28 insertions(+), 22 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index ba52f13eb8f3..f5c9f04e8509 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -602,14 +602,36 @@ static ssize_t proc_sys_call_handler(struct kiocb *iocb, struct iov_iter *iter,
 		int write)
 {
 	struct inode *inode = file_inode(iocb->ki_filp);
-	struct ctl_table_header *head = grab_header(inode);
 	const struct ctl_table *table = PROC_I(inode)->sysctl_entry;
+	struct ctl_table_header *head;
 	size_t count = iov_iter_count(iter);
 	char *kbuf;
 	ssize_t error;
 
-	if (IS_ERR(head))
-		return PTR_ERR(head);
+	/* don't even try if the size is too large */
+	if (count >= KMALLOC_MAX_SIZE)
+		return -ENOMEM;
+	kbuf = kvzalloc(count + 1, GFP_KERNEL);
+	if (!kbuf)
+		return -ENOMEM;
+
+	/*
+	 * Copy in before grabbing the table and copy out after letting go of
+	 * it. Unregistering the table waits for us and a copy that faults can
+	 * take as long as userspace wants.
+	 */
+	if (write) {
+		error = -EFAULT;
+		if (!copy_from_iter_full(kbuf, count, iter))
+			goto out_free_buf;
+		kbuf[count] = '\0';
+	}
+
+	head = grab_header(inode);
+	if (IS_ERR(head)) {
+		error = PTR_ERR(head);
+		goto out_free_buf;
+	}
 
 	/*
 	 * At this point we know that the sysctl was not unregistered
@@ -624,28 +646,15 @@ static ssize_t proc_sys_call_handler(struct kiocb *iocb, struct iov_iter *iter,
 	if (!table->proc_handler)
 		goto out;
 
-	/* don't even try if the size is too large */
-	error = -ENOMEM;
-	if (count >= KMALLOC_MAX_SIZE)
-		goto out;
-	kbuf = kvzalloc(count + 1, GFP_KERNEL);
-	if (!kbuf)
-		goto out;
-
-	if (write) {
-		error = -EFAULT;
-		if (!copy_from_iter_full(kbuf, count, iter))
-			goto out_free_buf;
-		kbuf[count] = '\0';
-	}
-
 	error = BPF_CGROUP_RUN_PROG_SYSCTL(head, table, write, &kbuf, &count,
 					   &iocb->ki_pos);
 	if (error)
-		goto out_free_buf;
+		goto out;
 
 	/* careful: calling conventions are nasty here */
 	error = table->proc_handler(table, write, kbuf, &count, &iocb->ki_pos);
+out:
+	sysctl_head_finish(head);
 	if (error)
 		goto out_free_buf;
 
@@ -658,9 +667,6 @@ static ssize_t proc_sys_call_handler(struct kiocb *iocb, struct iov_iter *iter,
 	error = count;
 out_free_buf:
 	kvfree(kbuf);
-out:
-	sysctl_head_finish(head);
-
 	return error;
 }
 

-- 
2.53.0


