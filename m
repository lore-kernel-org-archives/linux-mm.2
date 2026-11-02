Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B538560703AA
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cpiq3IqJ
Received: by kanga.kvack.org (Postfix)
	id D89BA6B05E9; Mon,  2 Nov 2026 09:29:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3A386B05EA; Mon,  2 Nov 2026 09:29:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C293A6B05EB; Mon,  2 Nov 2026 09:29:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9FAEB6B05E9
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:29:44 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3D5E48010E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:29:44 +0000 (UTC)
X-FDA: 85390412688.22.2FFECD6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7BE0214000B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:29:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cpiq3IqJ;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793629782;
	b=V8mGVTZlMGv66ujp78r2lrdwxq7+aR3wOYDl0pQdGZABJYF7eMNMa24ejYgHX3qRElJuQd
	NQskm5iQpT6sMktaBNEK9BcJyA+bsWu8gheg72nzGbmPYJzFCC/+fatqMpDhS8vMgSGJG2
	OYlhcUOZl5mNk2wxpTtd7/Yr0pPtq4g=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cpiq3IqJ;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793629782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ic+85LCmRwOCXD9XrptIkWWgbAusIpJ/j/j/KpoPCSM=;
	b=wQI6JZaWfHtKJ/B01vIbzrKyX0+19/Zo/buGoExdfh9fX/CfInZ+cgFQuPHn2CqHdD1Z7f
	k2WLORXlrbL0X8PY7bxn+g+uLWN0YLggC/7maLm1V0KNrrTV+Dk9T1EHHMuhCFA5L2qgJs
	13iwAQs5/ly7Uii8An25mhsFlMwiWtQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E91B60EF2;
	Mon,  2 Nov 2026 14:29:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A15B1F00A16;
	Mon,  2 Nov 2026 14:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793629781;
	bh=ic+85LCmRwOCXD9XrptIkWWgbAusIpJ/j/j/KpoPCSM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=cpiq3IqJzE0jLDTsXK0hhQpT+1tSBJ0m7UHl7jwVgF1Fv4mj9x0h0BFZHMrAfCVa5
	 iewk6s7JCm0+gwRTm/kjqgkW4YiueXz1TIntYMKngDzC+ACNgbHQBWvInviI1KRtgv
	 oJz0vOiQG4c8Pbk4iFmvmDh2ZQ6QwxvGwZS6AAmLbVz1ZAlyFcC8D8rCv7m/yTSEu4
	 1vD4TCJ+dg9PvxhYYplMdQDJY8+AFuovGaLfiL4La8TbkUrkcL9SeYhMCfsPHBpZLk
	 c+TBML64gtkfFA/ZyGQfZtD060MB4GYjnWd84w2qELeu1iAHFSJ2lpD4cFIe3OBakQ
	 pRII2n9i/Aq1w==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:21:48 +0100
Subject: [PATCH RFC 33/38] proc: sysctl: copy to and from userspace without
 holding the table
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-bugfixes-v1-33-59422ed3e465@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3702; i=brauner@kernel.org;
 h=from:subject:message-id; bh=OKHYY6G5p6tdI3fThR8iqjZq4Cu2ed8jbKwsRQr4+FI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9mJOjqsfwdP26aUFGgi5C6r2yG2bHan4r+X3s7GyXV
 WxXvQoDOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACYy4TIjw7uI6fuc5flCf+Zm
 5zW+q5zWPcdB1K3g9IT5Dob+Sj9nMTD8M73HuT7LtvqMxe4/c10XFfduOPPAQlnpxaaCg3+5lgu
 KcwAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: mtsnyoc44ooshxkjxm7a44kc1ryqgzc4
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7BE0214000B
X-Rspam-User: 
X-HE-Tag: 1793629782-146906
X-HE-Meta: U2FsdGVkX18ShovrRR5qAC6R0pYYu22GTpu4Ek9iSix8VVUzve7mspE/ae6Gw0e6mWkT7WwBafmVHIKubAV+/k4sQqu4cmJoOGJzM6kmmiWhiVMEOXVgOLbqfOUzS9LGHPeTOqlCZ3S+INN8j999EiQbByAng/AP0iELsiC4rJ5nsgT31GnLfrhi62q7gT+2bzvJFWIVEDLZMcEBvikETR/Kp3xvI9JdP+koI2F2UagYmlwt8ICrl3Z7zTjJ7PPt306Ds9gsenUbFgJ+7AS5xAhFDBBzeB1rb4lkGmHOhQdrDkYygjN19fkrqFwA+MohbaBQckTvUpXRw25rTymnS1Q45DziNAOgE7lWI0UmKXkmlVDLZXEN9CnVjbm60C+YKxlbm8/2GIfqjg8TMJk/UAVkX7jeEegaYMS93iooxHQKLyB1JLUq6dgy/Isn9JZaK+Dt0KACuGlzEX4vJMbcy2pnfNAnUpNQxgQUfn9z3+0HAmNkNMPjfV1NGQ0+FXVM2xya9Rim8U2WJNuiQyqaEx1iB7rVsGjxREo7RN/WB4sGmK7qEi0XzZcsedjXm4c+34OfERnME2RiPqbGFFQtjG+6aCgIJLU5KrnHNjoEZ/cNEY0Xu9oLS7r4Q0WmUHJOlF5xYB7ctuuvqoWd1lxN9X8z/ft4FpL8idE8WbYPpieryjGLaVsslVnYlj5dofEELfxfVcKu9ejaDhUAY3qdygKsS8je615g3e2QoYqT6ivAHbppqyL5fvrLDBt1vJPevoZ80oBgUqR5OfiJ0Uuq/nBddhgOOlfpta03RYzmOQOcjvyonJn9CCdNgW1pSTF3P4tPGgLmtmrVjq+YNZKnAQyzP7nGUEhXIgwN/ceI6ZBTyYkPeALkZQnH1djaWoYJDtqXM+A7Q3PSFD77fzt3Al+acSXd7qJq1uQTiPKFU9RXf+qZWt+zvPSTu5PwQYLm3vePtpTv6Ha9rTl1wFp
 IOM8dBU/
 twNSOepJ/rPFrY/C/Rdzwa1/EYbS/2E1MOfUUZITIq/uqFHQX9+P56qQhkAOPMbr41bFxxPombUmj6Y0C3wDaYSUi4bpIklj6v+e+dJ6SMZ1OLdvZFx3HUTEOm4GfZeWwZn3+dvG8en7U+geB30TaQnGs3kClbvEKBmiQtbQaY2BdR+n77tS4c+SAeQcn/QFVj80OBKtQD2duNJ7Bxb708rpL83BRiI/RTTq2XL6oO6FhF6Hbz/sShK0qbI+qQOCByH24NqPMABAz5xHO5PSy4cmhgA==
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
index 38b61887b59c..2150cf842919 100644
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


