Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92768606B1CB
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kEGAtuEw
Received: by kanga.kvack.org (Postfix)
	id BFC6F6B05E8; Mon,  2 Nov 2026 10:08:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B86676B05E9; Mon,  2 Nov 2026 10:08:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC2EF6B05EA; Mon,  2 Nov 2026 10:08:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8A0016B05E8
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:08:47 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 205D3A013A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:08:47 +0000 (UTC)
X-FDA: 85390511094.04.043E41F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 781E3A0007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:08:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kEGAtuEw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zr7obOUiLNzJ4M2rJicyi/Ze6HCzMDPfBdGpZnrgFfM=;
	b=IlMJF48QMtOG7GTUcURGbPkUXD3hHpAXMHw4AZu+kaQhnIX6bTQ2MSel/xmjgMqE4N9e9P
	p74MT5qdRXPZ1P6RsMLfo8Yd8NXdnpkw9TWi/+yHUZfN2XP14JRhD6tlH7D5Vre1j9rxuE
	JvrCT8npT9j2oRI7++ezjmpFG593PAg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kEGAtuEw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632125;
	b=3wW2s4v7tTX2xIyZFLV6ISdeqMBeNeXkyfCNddlgbsHL7QOZMrEFsEJ2zZ+UHzwMCadkTB
	B0wWoMrocPRVn/2Snmm5ZZR+/bv06A0m3iEX8EI2FG0ZLww1y9QzNxxrBGpZz7MIFwOZqW
	iynxIjmqTjuG9hfvhPca6MUsfPXR7Fk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 28A32600DB;
	Mon,  2 Nov 2026 15:08:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B133F1F00A1A;
	Mon,  2 Nov 2026 15:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632124;
	bh=zr7obOUiLNzJ4M2rJicyi/Ze6HCzMDPfBdGpZnrgFfM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kEGAtuEwvTMgDuPbyzJeFLVaUSWvZkCX/wUBabr5CM+BjM76qvrrMDRwKN+aUpp0M
	 LwULw5zP7H3bcIRxCu2+BVsEU4zGp6OX1M94GYtTzJYZ1Sv0pAvkktXo+Zb0As3XcC
	 7Tm5eTy1em1aicRexVm3TwZLua7XOaqJGZGjekvzyZG3iJISitPVfI4Rb1C6HoqO15
	 zds1p1eADnGHiS7upjctx8NMqWH7A7NsO/n5J+MjqWiNif9k5AGi+lAXG6mfYJREeh
	 /tq8fM2qbOInntFHxnk7n1aXVsuVbuc+aacS++TfSOw8xPUMY5Re+hh0DhYh68pv/r
	 SxGHP8KpJ8aAQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:01:48 +0100
Subject: [PATCH RFC 21/22] PNP: pnpbios: let procfs copy in writes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-arch-v1-21-c9492ab08480@kernel.org>
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 781E3A0007
X-Stat-Signature: 8o5yoanwbu6s9j4f7xfdondfxqjmy3sh
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793632125-323764
X-HE-Meta: U2FsdGVkX19+qEtJwSdVpdhXDC9/iyIboD5GorEpOpELl6MA04De9QpLnit2OruycEApZf6xHvRARRHhiN7h68h6Z5Ba31qzSq//8SYE0BnBUqhNbg6CKXiS0lSHcx6Kn3K8+fY/u0Mjxg7fewZfHz3dhnPDHcOzPPOLZjeGuzkHDQsr1xsNG+ZFc4kKtQqeqpuRcxdG9zPdKpbSVraD02bRFp+z3uJo0IQYZ4/xVc1uOBuZ3Tgy11aseIvXdVFACkvTxASOxcRrmklT9XXNN70RzKpNXnwqkW5eJg1Bqjr0Wba0MJNIOw1FY1c0fC6x9mLRwsNH/S4OV5OfqNIjojwKnM+1ihVGpQtHkM8kcLBLJTetuvJWCxjfakXbRiJM+uWlVQqF4v3Ns2OSDMBGChg0uyQDkq7c2yprHNbOyLwx027zEJTO46BOfcJzsY58PCUVXjeiGGoIKABQDstzlB0G9UJkK+6zxbkLY6PM5/fc4PSxScxAprkCOODs/YyS6hJtedoe35oLa9qLdrysissutshCTj9JUx91VVAufhz48N85PJ6Q9PtzzhLJrX1feZr2ST3KkN8Fa8qfIS8tlx4hE1jIz524aKD+8Ue987g1d0QmKKflnvdDWqR1BJ7uIyN3KkmRbkYOCNHH8Llodu4x+sxM2VCxqvnmkL46HGuQp+KlW6td9wYXcn5tQH3O+q21N5tjIjxmuWgD1xdvqykVyczMx5B4lx47ReNJf96aatXI9ufPkB1pfni9z7KnLmemSAATimkzXiVKRi/RZTP+pY2q1NILOk0gRZVvAPKmwKhj3RiFypCPvL+gj0fUFCX8HglrCglTNzf9A5jIU/2JVllagFQFTERJe+ectHKTR2200IoqzUji3kP+SxFvfFCB3vNoCBDkSQPtOffLFEFmOkYyPktC2hbP3wM0XZjdJw6Sz6lwbR9ltpR+0HTPoLtgtStNPxc9Wsn+FHl
 jKwLwnUT
 jGMOaUZ+y03CyyfJWPo6P3cTcMDdnVhRl7hQEVy7CmYxm9eG8TLbZwVGgJPg75tU0KE7KHBdnzEvEM4oj93TpJcg1OfOuOJIUdYRdscKMEUkWxLcbCtPEucyotbH39AkR4r61d9x6suHF/s/9YTaompYDDEd2KXhZyaWLqEiXi/5ox66/2BV4Z1HcykgKNJkTBl0lLQ+06fEyaYzR3fm96n7aftO3MB2V05HPZ8oazhIrJTN7PiQSsGFeNOAGzqcQ/6j2OamD80mhj1BZbNMdCfVVqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() so procfs copies in what is written to
/proc/bus/pnp/<node> before it pins the entry, and take the node data
from that copy. A node with more than PAGE_SIZE - 1 bytes of data can't
be written anymore. I don't think there are any.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/pnp/pnpbios/proc.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/pnp/pnpbios/proc.c b/drivers/pnp/pnpbios/proc.c
index 14632a8d0da0..00163aedd738 100644
--- a/drivers/pnp/pnpbios/proc.c
+++ b/drivers/pnp/pnpbios/proc.c
@@ -171,7 +171,7 @@ static int pnpbios_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static ssize_t pnpbios_proc_write(struct file *file, const char __user *buf,
+static ssize_t pnpbios_proc_write(struct file *file, char *buf,
 				  size_t count, loff_t *pos)
 {
 	void *data = pde_data(file_inode(file));
@@ -191,10 +191,7 @@ static ssize_t pnpbios_proc_write(struct file *file, const char __user *buf,
 		ret = -EINVAL;
 		goto out;
 	}
-	if (copy_from_user(node->data, buf, count)) {
-		ret = -EFAULT;
-		goto out;
-	}
+	memcpy(node->data, buf, count);
 	if (pnp_bios_set_dev_node(node->handle, boot, node) != 0) {
 		ret = -EINVAL;
 		goto out;
@@ -207,7 +204,7 @@ out:
 
 static const struct proc_ops pnpbios_proc_ops = {
 	.proc_show	= pnpbios_proc_show,
-	.proc_write	= pnpbios_proc_write,
+	.proc_write_buf	= pnpbios_proc_write,
 };
 
 int pnpbios_interface_attach_device(struct pnp_bios_node *node)

-- 
2.53.0


