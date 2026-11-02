Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C606608557C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GwaRh4oG
Received: by kanga.kvack.org (Postfix)
	id 2F5A46B05CC; Mon,  2 Nov 2026 10:05:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CCC66B05CD; Mon,  2 Nov 2026 10:05:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20B3E6B05CE; Mon,  2 Nov 2026 10:05:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00F2F6B05CC
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:05:17 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 841D780176
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:05:17 +0000 (UTC)
X-FDA: 85390502274.11.034E92B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id D57CEC0009
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:05:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GwaRh4oG;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793631915;
	b=USFUM+Jm7ZjqtSIm+NH1AQJKvQoIFMB00Y2X8QXKdGAH97kEu06GcqSyPazhfBU+ABxLdM
	MVQlGpvRl/ts8xlRb3a1CLfDZvX9qgHUPqWUUEwjhp10u84gNxcEgfbg1sm8R1dNmFJco9
	CjjsfOVDLQhkwInkVWJbbJ/YnTZL4yA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GwaRh4oG;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793631915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/usm8OdHJAbA2hfj2koEwGvMkvG3A+8dTBDDaCx7vxs=;
	b=Bf24LKXdVMlTbE7w/StlM2OWz6T6vmobU+NzyNHYdSqT2JLzrqZ5xIS7JDskKWygDLs0ZU
	+axLxDIsZ4F17UaZivHn9QztUGOGt8glU+J1IeAQcjoIJ7y4x9iUpv627XJQE+DAZvdei0
	06NetHK4+qBhjlWw9ZnB0RGb/xYmaSw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6C414605C8;
	Mon,  2 Nov 2026 15:05:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1171F00A1B;
	Mon,  2 Nov 2026 15:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793631915;
	bh=/usm8OdHJAbA2hfj2koEwGvMkvG3A+8dTBDDaCx7vxs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GwaRh4oGylUX6g6CEqPXd69Ibpr3KQmakI0Nld+n+JLGApofu8ygx4WwNRI60EvYf
	 DSOWIV++3VospwIjrvRsrg0mfaY7gRgUeihp43Au6D6HgV7Xv8KolBhRU7xFnfQdC1
	 T7WNrsjJHzUGFZHB3CY8jnJ95TWdIrLVspjluFdHIKRvTNa2WFPvdVn+u5eXib/14W
	 9Mf7AL8v6CpiYBfwScgPVzymR7ApEayesBtx54t9q1NbuhjbVtR1b4mKqnuDg4Wxmn
	 KCXgiDmRsG7or4q0U1UicO9HEaUHCZVEQAI8u1qAq9b4HgJ4PMYdAOqXF8iMKD4/CK
	 FsxoDOM8JDDag==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:01:38 +0100
Subject: [PATCH RFC 11/22] um: let procfs copy in writes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-arch-v1-11-c9492ab08480@kernel.org>
References: <20261102-work-procfs-arch-v1-0-c9492ab08480@kernel.org>
In-Reply-To: <20261102-work-procfs-arch-v1-0-c9492ab08480@kernel.org>
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
X-Stat-Signature: ttznmku4hcqt1kuthnoqycbka5rged4b
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D57CEC0009
X-Rspam-User: 
X-HE-Tag: 1793631915-261110
X-HE-Meta: U2FsdGVkX18U4HYEGQfq1qp7+8fbgzIQEcdti9QL5voijJpj61pxNLedcLbeds7CvWmrO+owWLnzv5EY7FwF2XRcKXpxHXqRUxOtP50y+Niu73hFUlZtnFqy3qKnLxEAFd2HCAilDokzw2kpHEebmJSMH5EnKzqHeW4mH7eypLIQ853Ro0U8Fw1emFc91C5LpiUI+ye+Etr2sKfbOzJrsmFsOcF294MKGT4/oX1edPNZ9VQtgoiNQqr4Gr8SU4mhLKwA71Q/GU8dDgdvSmMoaqJig3h1zGaGvm4qUaORI4nHuXILVHVg8yp3sESPjZTSEbvtQuNE2HA5u+iavSLnUA09pSxTaISvFR7dDQDjAdC3UuehqdPPf6kjbWXKkizZYlPKQvrOu21fDAsjc0fKHhzFZR/VifWL812s5dbb3RcOOAkJQXEnwYA03VcnWep4SwhDiaWnffqNVhQ0Ekh8HCPmSXPfnrf0v9it9MkO/y6wngtvBn9oBrcypfKWY+wuBKTOWpF0GTSHivyBHjom1ZaGW3auWK9MXy6R/YvWCxKkMezzdaV0CXrdEo6WhEueWr0LjbeeXAhRSOLmh6nwC9VCW/75cq7prUmrnZKkR8qwOEpA3CSmf3jGOQ7jXt4M/4XhzKv4VRlLS4jlROsXfdz9NkzP92Qoi6H3mMwsremawzaaG1NxRrF2hIZxPITVnVmpJuxl1HgL7qs0vGYdeWUf6AM6Qw8D0C9uThoSBdfzkAUy+RbDMl3cT7IgJFzcOXriNGc0lBnbihnuYH/o8Pa4wL2ju82HVkvvPfh0TNS1uRxdhXuU92KbywHq8RH/fKkMPGxKIoun0OM0e+ctBNtZJZWUwmO7rFsFOriorYu48yUhqErFHFsSZ7ml8zjL5XoJ7dIwQOzuiaHqPkpuoTtIQBwgLOzQ4+NKVbqkBKgpmuCfl0Q/2eXt5pyAXSlgkbY45CMgtMBb83g3+Xe
 kX1JPLmu
 US11IuOOq7+OlG95moP+IXqvcP6f8ABr9lMSs6mzZzt80MLqNbQErjGq96kmXkjYEKGdR+PBSqs20hE9Jbk4UWU8aNt+hC/4+HsJxxDnaFgBbKZtlipo52DuWEaf4u3usJuc+sOEM5psQom8a/aBX/flys6HLxEDD8+TKrsT9KdHgz6m87SieS77hhp4qO6UV2VVMmPMTeU6iCQrv0fDkGXvRq7YJWFJs+3bU07VXKGoIgtYWoNI7EqfjVZKKb6lKyn2FboygJv/mwWSPlUvIx6K0qA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() for the mconsole and exitcode files so
procfs copies in what is written before it pins the entry. Writes larger
than PAGE_SIZE - 1 bytes fail with -EINVAL now.

exitcode parses procfs' copy as is, so it no longer stops at the first
six bytes of what is written.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/um/drivers/mconsole_kern.c | 11 ++---------
 arch/um/kernel/exitcode.c       | 14 ++++----------
 2 files changed, 6 insertions(+), 19 deletions(-)

diff --git a/arch/um/drivers/mconsole_kern.c b/arch/um/drivers/mconsole_kern.c
index f01b7d8a07bc..a4370470286f 100644
--- a/arch/um/drivers/mconsole_kern.c
+++ b/arch/um/drivers/mconsole_kern.c
@@ -769,21 +769,14 @@ static int __init mconsole_init(void)
 __initcall(mconsole_init);
 
 static ssize_t mconsole_proc_write(struct file *file,
-		const char __user *buffer, size_t count, loff_t *pos)
+		char *buf, size_t count, loff_t *pos)
 {
-	char *buf;
-
-	buf = memdup_user_nul(buffer, count);
-	if (IS_ERR(buf))
-		return PTR_ERR(buf);
-
 	mconsole_notify(notify_socket, MCONSOLE_USER_NOTIFY, buf, count);
-	kfree(buf);
 	return count;
 }
 
 static const struct proc_ops mconsole_proc_ops = {
-	.proc_write	= mconsole_proc_write,
+	.proc_write_buf	= mconsole_proc_write,
 	.proc_lseek	= noop_llseek,
 };
 
diff --git a/arch/um/kernel/exitcode.c b/arch/um/kernel/exitcode.c
index c71657df38f5..8f76e3b20c18 100644
--- a/arch/um/kernel/exitcode.c
+++ b/arch/um/kernel/exitcode.c
@@ -32,18 +32,12 @@ static int exitcode_proc_show(struct seq_file *m, void *v)
 }
 
 static ssize_t exitcode_proc_write(struct file *file,
-		const char __user *buffer, size_t count, loff_t *pos)
+		char *buffer, size_t count, loff_t *pos)
 {
-	char *end, buf[sizeof("nnnnn\0")];
-	size_t size;
+	char *end;
 	int tmp;
 
-	size = min(count, sizeof(buf) - 1);
-	if (copy_from_user(buf, buffer, size))
-		return -EFAULT;
-	buf[size] = '\0';
-
-	tmp = simple_strtol(buf, &end, 0);
+	tmp = simple_strtol(buffer, &end, 0);
 	if ((*end != '\0') && !isspace(*end))
 		return -EINVAL;
 
@@ -53,7 +47,7 @@ static ssize_t exitcode_proc_write(struct file *file,
 
 static const struct proc_ops exitcode_proc_ops = {
 	.proc_show	= exitcode_proc_show,
-	.proc_write	= exitcode_proc_write,
+	.proc_write_buf	= exitcode_proc_write,
 };
 
 static int make_proc_exitcode(void)

-- 
2.53.0


