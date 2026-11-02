Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E480606A910
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wzv23e35
Received: by kanga.kvack.org (Postfix)
	id 90D976B061D; Mon,  2 Nov 2026 10:24:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E4BC6B061E; Mon,  2 Nov 2026 10:24:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FBE76B061F; Mon,  2 Nov 2026 10:24:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 590606B061D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:24:15 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D94901C1CFD
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:24:14 +0000 (UTC)
X-FDA: 85390550028.25.2F70224
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2402840014
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:24:13 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wzv23e35;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0DA6RuBvRtTkFqswtNQb2uYlEiZpU59l9tIHU1Ga2j8=;
	b=PofU2vnVH3Eykk7ob/3smyypsaM2WVxy8UUTrYODudvy0hnbVtnBYGqSI57DHNGITgPBon
	uexz38hzw7V7AJ475oIqmjS0pv64AbMNnrdYgkzUhd5stXPKFJdf6zexxLSExeuM5JZkGa
	zapIXm6V4458WqKEMW0nwyX91I9uGLc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wzv23e35;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633053;
	b=UTQpfUVYIMxxP0asCoYvWo6+q/AwdqI9+AcOxD/wj2gQZfnh05o8N8/h2b3sgHXRLcmLSH
	r32G3n/Vu4ofCdRCWcY0jeHdOpjUstb52Ig4vjaXO4SqMktXjzD8MPrxAols5XVcuBKlpv
	iZdgGBCcHKhlSSDb27IZzN1RB/ugrcA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9BF8C60629;
	Mon,  2 Nov 2026 15:24:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967341F00A16;
	Mon,  2 Nov 2026 15:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633052;
	bh=0DA6RuBvRtTkFqswtNQb2uYlEiZpU59l9tIHU1Ga2j8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Wzv23e35LlF722Cfqg73FBGVnhxt+H5uTjMVTnB7asIIrTAol+UsSWODD3A9JMAWW
	 CHeJx+/sOCjLZSq1s4VoynRxvWm7XhKnNjGUb4tFL3st5AhwGX1X8EXNyiNSob8zfe
	 hPoA0Jwnc94AejcwzAl8mS34lOo0kwPJnFcg+lOSVQtUdf4OqaeMQYnXbxeWnmbXEb
	 AX7yo9n+oT0VV5xUQw7x3ALW+dHnEd/WKJEInzk6ceYQfrGKcinK0xZJkLZt2jHfOm
	 CKZoFbsH8Uf/vBc0GUbzhEZ6RBBP6OGx93Jv1yb/leud/4X919tLDeUZ9h/mDfqa8c
	 5djzkG/VTzWXw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:23 +0100
Subject: [PATCH RFC 13/27] locking/lockdep: let procfs copy in writes to
 /proc/lock_stat
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-fs-v1-13-d09a996317b3@kernel.org>
References: <20261102-work-procfs-fs-v1-0-d09a996317b3@kernel.org>
In-Reply-To: <20261102-work-procfs-fs-v1-0-d09a996317b3@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1505; i=brauner@kernel.org;
 h=from:subject:message-id; bh=8vcSfGoyDeqLJaquRqiN2D+SQsNeRK8HAS3H3FbecE8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG6k0HtsppuIOtP74Igd108lcc3fGSuzcnJdKhtD4
 so7t2c0dZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExkkQEjQ+ONtmlOpu7yPdtO
 f6mefC2DpTVNKs/EavHuEoFe/ryYWEaGI5/jjbfc+3ttHUtbJafnBWsGE6vUrY4/vk118NKbYRj
 KAAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 2402840014
X-Rspam-User: 
X-Stat-Signature: ffw71guguhwyc7hybywmo4ase3tikgdu
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793633053-784133
X-HE-Meta: U2FsdGVkX1/n6FF17gLnZxLR2CfkuBn/7QFmD5Tduwa3gZM7zrkdy0SCq6t5vWirl3pTWHfZAV3Ac1vrOuFdr1oKfzcTYTDpEYPCaz7ydL+t4vB6QvqkI+d2KgD3kPU1DZdTuJ2QYkzRRn0jeCXGw8NAiDlPDyN77VfCqCWeSHG7pJOKvrZV6u3js0thTBhRFVWhZl2Kmtb5eBUkCoXI1La7vCw8F/AgEk7vAO79CtdLwdPWaEkd41jt2yDW+vdrDhHER2AxzKv1yPHujkvY3XnL09SH2XcgZ8yUPp0ANTVFKRsA8IrFzCAzN9Ula4UuTA5duPAEKnAv6/lB/DKj9BxZQU+9vFbmgmYjyRukR4JGinf+FObkFFnGe1K+6Kd1Luau+09uEd4rs7b6M26PhozarxRRmlo+KnGgzF9eC2WL9BkKDH/0/vORssKyWis1kMrNXeIrON2+DuFVQNhaTT7trBUtin/zROj7PIT4/HdckujvNLTC8i3uC80uVG3jRXdFdWTS1ffh8fAff2BCWHqMDvzPWQR2iIpvh0UwkNVxBTNq7e8iG/dHZPb+jVuoRt8Dx3euVsL7wQbE6C3UuVsjkng9P712Cu19Rbn7N1zg9DArdvnSxl8WSESR33A2MQx0qMeTmo3mHF6OO/D1NJJMIhF59zEz+c6Mjh2rDfEW4+Ejv6kebAhqFTBW9RVgIizCx1o3PIfzJ2n5jWDGkdBDFbVR/0TYQR8qR8VaDWhJqaZD00Csc7XBIePs3CIluxpK+FFnlN4hbBCwY6ExEDqHwqR0GGzVIIa0jT/gjxwExOp0hRaFL05I48FLl5pg3jkue87Thvab3MKW3sRzOvu0BzREeP/HPXnAa8IKgfCfNovBaX/gCuMcZ8Ewgnw2Qsht8ykK86rEh0x1ptL7ogYBaIv80CjkiJpUv0LfMJbPGQCLGL7/bwImR2yLRCVOfxUFN1lKg7IKAZzcbUG
 37v5AZDq
 9lOQxBJAcNCuxRmv7g36Y6OCocN9BaANC7XUXVlW6rZpX6MCIa1c8R38aVPsdS+jjydiTjDBOhlhz4BSWHlcib8Qc/PVdQglwYflAHd9uXlDy30XhDPEaxbP9pTPHVOfRQd2OnLTERmt37yTFWMH53xra+q35YdVWHZgyiJ/Me5QdkzSurp88Hca9yVbErGThNRUEnGKg2aOPwIN9YHMGIelqBp9tc+VfbFoQEeSwtVhUBgHcMx2QiGR1cxOTjZlgefr2Euhqz+5k7Y/3wwGc0Ej4O/V2vK3q0eva9+4ZJR/VasghULVS0s2eEPZyHjDoafoF+bfR6uzsEKs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() so procfs copies in what is written before
it pins the entry, and look at the first character of that copy. Writes
larger than PAGE_SIZE - 1 bytes fail with -EINVAL now.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/locking/lockdep_proc.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/kernel/locking/lockdep_proc.c b/kernel/locking/lockdep_proc.c
index 9b034b5b94bd..2a66ea09c2aa 100644
--- a/kernel/locking/lockdep_proc.c
+++ b/kernel/locking/lockdep_proc.c
@@ -669,18 +669,14 @@ static int lock_stat_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static ssize_t lock_stat_write(struct file *file, const char __user *buf,
-			       size_t count, loff_t *ppos)
+static ssize_t lock_stat_write(struct file *file, char *buf, size_t count,
+			       loff_t *ppos)
 {
 	struct lock_class *class;
 	unsigned long idx;
-	char c;
 
 	if (count) {
-		if (get_user(c, buf))
-			return -EFAULT;
-
-		if (c != '0')
+		if (buf[0] != '0')
 			return count;
 
 		iterate_lock_classes(idx, class) {
@@ -703,7 +699,7 @@ static int lock_stat_release(struct inode *inode, struct file *file)
 static const struct proc_ops lock_stat_proc_ops = {
 	.proc_seq_ops	= &lockstat_ops,
 	.proc_open	= lock_stat_open,
-	.proc_write	= lock_stat_write,
+	.proc_write_buf	= lock_stat_write,
 	.proc_release	= lock_stat_release,
 };
 #endif /* CONFIG_LOCK_STAT */

-- 
2.53.0


