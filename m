Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3DFA6072C43
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZkdIoUzZ
Received: by kanga.kvack.org (Postfix)
	id 4B2946B0635; Mon,  2 Nov 2026 10:32:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 463846B0636; Mon,  2 Nov 2026 10:32:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 351B16B0637; Mon,  2 Nov 2026 10:32:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 039436B0635
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:32:55 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 859541C1AAA
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:32:55 +0000 (UTC)
X-FDA: 85390571910.15.AEA61BC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id CCB24A0007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:32:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZkdIoUzZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xwE+gN56hE51AorwZpbrVa8dzdnGmSpFpcgiuf3dvqw=;
	b=Rx+E199WvukUfsXY1AAPlkZz4rCylKn3Qc+QysZMbuQNW04LuGypohmoeaCJK+DnTfB8qQ
	F9PuQ/fSSLLzuysfVYpGB/jO0MrgoNL7iDG2jWUpQaGVZfAB3w8NywmQPA12Jlqatr0YPT
	WK0ajoauUkv9j8JdYypNpzn7+sxPJso=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZkdIoUzZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633573;
	b=MQsOT7NYZmzEU2KnQ0f5Dv5ZqlqY88QfgfPZtuZPa8pI7SAkRDmvXk4L9fbb0XaIH4UYPR
	bNOw/cjWdGABFAT34lVExkZ07J2FsuuYwi8+dpfOQwkWrhczWjxklhFunxFvP0a19XSjjC
	EKWWPdgz0X3ucK9CbbXG5mC2PbkYYG8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 59FDE605D1;
	Mon,  2 Nov 2026 15:32:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5BD51F00A16;
	Mon,  2 Nov 2026 15:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633573;
	bh=xwE+gN56hE51AorwZpbrVa8dzdnGmSpFpcgiuf3dvqw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZkdIoUzZRdQstvJJGwaGXuz34UXdVd9KnN9ZJc3nP27AG3GLe8vMenko9Tiu+l4yV
	 4/eK0kdxB9N+Iz0Yx6dr+YotVggYI8nlCZEvmDr9lO/WoWjHo18zAakL9FX2BCmjDx
	 mJmMK2I8BK4i3qt963tlhaBmXuV/d6nxajg5m4xkht+xWIGtqgCPx/5sAyRymy14bP
	 4KLL09VHA9etPNuG4Bi+X52PjSZJxfUN0TyZqVAjhyTJxpADAlMTaef79a51Inhh1f
	 KQvYYLJ04QvmjznL9iSrSnxSYVcd8eF+n1EAEbkOWhWDHBKQ0TlFa4oEqY4+mpy2bp
	 OjhbKNeE0RTjQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:20 +0100
Subject: [PATCH RFC 06/11] SUNRPC: let procfs own the seq_file of the cache
 content file
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-net-v1-6-982104a4f592@kernel.org>
References: <20261102-work-procfs-net-v1-0-982104a4f592@kernel.org>
In-Reply-To: <20261102-work-procfs-net-v1-0-982104a4f592@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1589; i=brauner@kernel.org;
 h=from:subject:message-id; bh=8vuLt15HI84MkjiR5ofNiQbYBWJycXJMPW98KiaZ28g=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG6cvyvvXN+5FNeT984x/JZU3WJc97VU21Z5x4ejN
 wVit9i4dJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzEIo6R4b/ei60fuk86FUUz
 vt99O+xLZ+VMycIfR1z13il2v/5unsbwVz5pQbOt4GZXF4e/d+SV1t2v/7fDb/rx0gLLFQ95fd/
 GcwAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: CCB24A0007
X-Stat-Signature: enc4iwmcg6oudm7fejo41p4ot4sx6fzo
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793633573-767747
X-HE-Meta: U2FsdGVkX1+xZ3blT007+iFqMaSoXlKSdhwqW40GylHlLvQMrxtrq2fX20g9+xuEnTmuVbF/ZcOThGBbxshHErL17yDnx4b9lKb4CjARQ1P57hqu5P6rqEEbqEWxI167sAzMxn1wwVF0W/V37EVPFm+1UAz8vSI8wlx3NxzVvAD33Vm46fGHtU/gNrftnyNXVEbpzR/TSMfEEwwXTglVEcjr87sXRxROnqq+5nBQrLZHDesg3JofJNBhQFgyL8gMTk1kdz26jSUOpPjXdSXW5I0xYHdUfIMsxQYkLfwwD/i2otRqFhMiMjvDi2N/pR7c8igW4wrEEYYhDnVMemLMHVTkyNxhN/4IrXCA/2x1jVu/+mMLM889iernKqzgTfHF2ahSRlKNvEMfOhTEjf/ZupQCcjI8wZULo44cIiryI7PYLingFiYz0+tAONt4DofYslqyYQ9Z3ifnh5gqDe+Upp0GdCL6N0T+3TxkfbZHZ52yXyn+xfgdsVC2iu/uTP4SLXRd84hee/4VO9Uor3wFgtV6pgKMHX6wxmqEusGqXh/3Cs0fVVHFKZtMQ0LCzhYzRb/MKOst5zlRx8A+G6NnAomk2VlkWDObajvefecMszPndv/eE2Z54xoG3ZyU3bVyu4UoTPdU11qp2YJQHdHPodrY1+zNaTrN0mw6/qBQhZ5PcwXOT63X8iyKtpxk9GB7fmRrwSmDUOILf503YFqAoIcSAGkFiBQwtdgo91ZPfeqlgThaI8YX3j56Rmdschk+Jb+lDNlW9e5bxH63TtSuBJCNDsRBnsYFZ9x0dL7874meovJTDaApvqID6WrcwdAibJ0XPC1Yl2/eNNHFXdSVDz95LDl/joc+P0YgFZK/buwu2JdVAYWVfOwiPkVM00MuUbzWcQSMZIpe3T/2yrXnQq0Mc7l7Ciow7ME3vCwhU9VjZ0d3GioRiiN7dvVvHhgxNFoUhRplhLzIyKNyY/O
 gHhbLAnY
 iCfQFRoXh/Z+Xj4SGSZHCpU7k7ec8MewBEdo6pJdg2Z7tCtv1tFq+W7IBdl2ErZXQu3PVJ/qC6wE4C7j6DaaFXxNrQINRfBB4rYUhXVo0lT3xxMvc1myN/jh7XL1sDWhf+pza99mTdt4XW81kNxguiM79TPGjqzj0KRI2c73g9u/G6ozhAX3fE0dGlEBe0bbVO24lwfxQE8H35rQB9Cc0eO3On8ayLt6bIu33DtCxHlB6rxHY1OtR1IyPlwJYH4oRnep06c6Qh7raCVrbTSkkJvEuj6zkZDTabGgrUfLId+6Ha4T3G65WyjnGjdPQHDl+QWAMCHEeLumNi9c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Declare the seq_operations and let procfs open and free the seq_file of
/proc/net/rpc/<cache>/content. ->proc_open() and ->proc_release() only
take and drop the module reference and set up ->private now. The
rpc_pipefs file is unchanged. Reading the procfs file then no longer
holds up its removal when the network namespace goes away.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 net/sunrpc/cache.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index 1ceaea7e01b9..007521e8a57f 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -1606,24 +1606,28 @@ static const struct proc_ops cache_channel_proc_ops = {
 	.proc_release	= cache_release_procfs,
 };
 
+/* procfs opens the seq_file */
 static int content_open_procfs(struct inode *inode, struct file *filp)
 {
 	struct cache_detail *cd = pde_data(inode);
 
-	return content_open(inode, filp, cd);
+	if (!cd || !try_module_get(cd->owner))
+		return -EACCES;
+	((struct seq_file *)filp->private_data)->private = cd;
+	return 0;
 }
 
 static int content_release_procfs(struct inode *inode, struct file *filp)
 {
 	struct cache_detail *cd = pde_data(inode);
 
-	return content_release(inode, filp, cd);
+	module_put(cd->owner);
+	return 0;
 }
 
 static const struct proc_ops content_proc_ops = {
+	.proc_seq_ops	= &cache_content_op,
 	.proc_open	= content_open_procfs,
-	.proc_read	= seq_read,
-	.proc_lseek	= seq_lseek,
 	.proc_release	= content_release_procfs,
 };
 

-- 
2.53.0


