Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0BF5606AB9D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fbfunu5l
Received: by kanga.kvack.org (Postfix)
	id 20F746B05C8; Mon,  2 Nov 2026 10:27:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E7936B0605; Mon,  2 Nov 2026 10:27:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FD686B060A; Mon,  2 Nov 2026 10:27:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E5B6E6B05C8
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:27:40 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8E48EC014B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:27:40 +0000 (UTC)
X-FDA: 85390558680.24.080B1C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 91A59A0007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:27:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fbfunu5l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fVQTaeb1oaPXPKdbaoAayfOvKvQGNQ+1mlgyJVhAprY=;
	b=sKiMJdhrFlKVNAjVofy19UGPuVlHhZjX1vFZFTdJBweponhAsSB9cYDDlWYMS2GO+drxSP
	Ak7eFPXZwKD65aQ5NKArQo54ywznVpWA9dr6DmQWe7t0Dr9wt5bc6rorhf9XNEskIojcrL
	v0iWh2CJPQJzzrbVJiq/dZlLnkLC6zA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fbfunu5l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633258;
	b=QBui2VFun5rsPwTTcCUhTctiUVqEQ5P/dnubIT4R/NCR5m40ML0m9y0lzZWRrrnXoE1nUA
	Hg0IfpSnpbDMoAWtbuLZTtNvNqzGIiEzo3JDnbu+d9K2WrM0r3tI11dHRvLWB/jnPh0qFR
	lxZU1BnL77aGnFq+AlouxUoVEk2+9V0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 356336060B;
	Mon,  2 Nov 2026 15:27:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 970571F00A18;
	Mon,  2 Nov 2026 15:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633257;
	bh=fVQTaeb1oaPXPKdbaoAayfOvKvQGNQ+1mlgyJVhAprY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Fbfunu5lnfSJErLeOUCsE8vip2ARFZN807qf74412UenKoepZwcVGYe+g3+TBcESM
	 D1QwhFq6yCQFcA4O6bdiGxqgbUre+0RZ1J5auCotD4DKJJgxUPjFUcOalq5vmaPOF7
	 r6K6N8o4y3fh9RsWfWA0H81XfT5u78die7geNeFBQSxWRGm/v2Zmi9RgIIPxgQXR+A
	 0P2Coe1ocgqK6nbiBmEOjXtV6u2GvDvXXJrRu43HenABBgQi8+GrUdDlctWVDUHIoA
	 N+wBbyncTDkFadiWb6329xq83Ar8JXpLh9NYV7HpnGSZ+ZP8CPs2xOKlBHbLeO+TYL
	 LjxldllqCyblg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:32 +0100
Subject: [PATCH RFC 22/27] ipc: let procfs own the seq_file of the sysvipc
 files
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-fs-v1-22-d09a996317b3@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1686; i=brauner@kernel.org;
 h=from:subject:message-id; bh=X6b7xxVI9/mXpsMyNcc27ZCzqI3OxIvLBKPC0zeU++I=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG6spcaqk/ik+Gn7rm/T2r/bxt6IFtUv/OG2907HJ
 IYrlm67OkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACaisIPhr4w9w7Ls1452xknl
 lgnt1kyG/EnKSVzp91b3nmSOzwjxZ/hfOCP6r1dRmdzzU13p7xgu/7jmd2iNKp+nYxzP4e9P69R
 5AA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 91A59A0007
X-Stat-Signature: 9jeys3f1dm1pcszmxh7aomef3ymdzpxq
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793633258-596670
X-HE-Meta: U2FsdGVkX1+kO3P7ax79eLECvqyOlEc+C7HeWOhbX4NL+OiePvMX9InE1+Vpn81kcGQCkeoaG+tQGdGmlozwAWzf1Hre+zisZBMeNR33PzSW8utY07zItSdoMHp0JR8IjjXeaCjOdWeKi+412eLpk9yg7UYIwjYTdYiUCwzjLfDdb5Gdr8hD7BWroiBzmk9f0Uc4fZ4WqWxt3mkfdQcDlSgmK9BZCIkbdk0N5Nq8AtojDtD4mYQzSr0/lmNLHiOKgaZqMpLd/ORTYB7Rd7dmA6QHjjY05TzFl2GxeMrl2GdEnIFTiPw0+SUHi/ZAj8OfP6WhaDWoKCv2NC+p2qwi9D4C7U72ZLdDhXiqpcTy4/vckPBgVMb7eOX5Ezwfr246T7MTCYr7R+LP+66vz7I/L52twoN5zSsMftQM9MJ2wGJfWdFEft1m+axAkMPF/Ahvrlp5I7eT417jk93g378pHgrztZQ98zJlbRhDg/ajWFLPXAxVPuLLA10hlB6oVgKarigd27C92hEJWXo/2JOvqJzkU5/u1KVzT5xoIgO2vUT28zr8pNXoqP0n2FP681/aZeBtEEVjmGGWSn0iXTZxptO/ykwW14E6c9y3H+wPoJHotPD3XVlCSeKb4fEoAiRO7cBS1NLCFyhEYpooe/7XpGpeFn8TxylvCc8kVfXlyEffGHwNZbnHmoeektElgW0DlBT88JxhTjiFOImHf5rkXkcdc3lJO/6ibA/vteZY3gLiyUcXc3tdHR3rrA1IY42c9OqTvouPRq1OHkuoOYTAvptU5w/DzmVjVZo+Ug2q7huNCjpjC/TTZciHxlQNUCvLar2B6/bCrpikAoEZuG4vUuhRnexId1wVtsHjFMdE7WMAdL1wsFg3zMfFkATzcqvy189F81i1M0D1DJXAQ2779kvsAGv+9+E9Ei/dDEY/OPXvCnBH3Sgrcr5y/dDqGWIck5BQ3wd/klpqLMqAl+K
 PrLCyXrA
 IhcFwTN/k4TeADKFjWUN1aqLS9DJaWOPJkIKTocFQkcuF7jzvhcP0E6k3JCqxncIaZTKmcQExKfP8PAS0NpB44m80P6A2YTgu4z3ujBTf9+7VcSA35VIGvnkjnTq8sdASuX6M9/H5NDXgqTv6WkTPtWcBZvH47xVfv/aG5SROHv/6q56xd1r05nUOYBY3hdMJ40GVtkYoMM8NvGZoBeqyuY+D62a49qWjrdvSY8IOrG32rp87PtDEPgSUEPR9yRinrDjm8JwTZMjT7BXPFd8mXqckR4DpUTaEmHD6aKUY+tDft76ScwDgWFC+jxrEU9+W5c2j1SVRz9T2/Tk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Declare the seq_operations and the size of the iterator and let procfs
open and free the seq_file of /proc/sysvipc/*. ->proc_open() only fills
in the iterator now and ->proc_release() drops the references it holds.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 ipc/util.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/ipc/util.c b/ipc/util.c
index 1737d776bc08..8ec3bc328657 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -894,13 +894,11 @@ static const struct seq_operations sysvipc_proc_seqops = {
 	.show  = sysvipc_proc_show,
 };
 
+/* procfs opened the seq_file and allocated @iter */
 static int sysvipc_proc_open(struct inode *inode, struct file *file)
 {
-	struct ipc_proc_iter *iter;
-
-	iter = __seq_open_private(file, &sysvipc_proc_seqops, sizeof(*iter));
-	if (!iter)
-		return -ENOMEM;
+	struct seq_file *m = file->private_data;
+	struct ipc_proc_iter *iter = m->private;
 
 	iter->iface = pde_data(inode);
 	iter->ns    = get_ipc_ns(current->nsproxy->ipc_ns);
@@ -915,14 +913,14 @@ static int sysvipc_proc_release(struct inode *inode, struct file *file)
 	struct ipc_proc_iter *iter = seq->private;
 	put_ipc_ns(iter->ns);
 	put_pid_ns(iter->pid_ns);
-	return seq_release_private(inode, file);
+	return 0;
 }
 
 static const struct proc_ops sysvipc_proc_ops = {
 	.proc_flags	= PROC_ENTRY_PERMANENT,
+	.proc_seq_ops	= &sysvipc_proc_seqops,
+	.proc_state_size = sizeof(struct ipc_proc_iter),
 	.proc_open	= sysvipc_proc_open,
-	.proc_read	= seq_read,
-	.proc_lseek	= seq_lseek,
 	.proc_release	= sysvipc_proc_release,
 };
 #endif /* CONFIG_PROC_FS */

-- 
2.53.0


