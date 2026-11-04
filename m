Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BB106078150
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dh4+9ecv
Received: by kanga.kvack.org (Postfix)
	id 6EA986B05CF; Wed,  4 Nov 2026 14:31:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C2326B05D6; Wed,  4 Nov 2026 14:31:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B0F16B05D7; Wed,  4 Nov 2026 14:31:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3FD206B05CF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:31:30 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DD9F21A0850
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:31:29 +0000 (UTC)
X-FDA: 85398430698.19.B7E2FA2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 170FC80005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:31:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dh4+9ecv;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bjqF3ZSgIkS8AxB/0gXg0jui/+Bk+KSQrJMcvTLEX2w=;
	b=Lr/loYIkUlzdBNjKxolqtpzRV1dHLFvQjepNBhVJzmUTfEX3Q3KH6BBIPNnSeVBu8Mp+ge
	zO+I8ho9FbkegEI3LfkJ1+IMCTPFLnTG/l6etK8Cpd6ao+vnhsc7tKfoaqlIYMMIkSAizJ
	qMRIYXSe/ZdiX9lxV0nzQrb+Kb9IPEY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820688;
	b=6V4O522a+ClhjfTMMFzsRMjO3vhM3xUd2JxLqgyeyqWkB4wFMWcMgMd2Di3tks9DvUpLo4
	tJLltu9HgT85n1rl6V/cPnUxCeLDgpY5b9boVA5/JFeIdatJURhEcGfrhm4HHrZHF+hjIj
	SwOdUbqnvZhX4+N3sUOP6VKYBbRlgvg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dh4+9ecv;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 31F3641A5A;
	Wed,  4 Nov 2026 19:31:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 687711F000C1;
	Wed,  4 Nov 2026 19:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820687;
	bh=bjqF3ZSgIkS8AxB/0gXg0jui/+Bk+KSQrJMcvTLEX2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dh4+9ecvQB/fdnQu6iIgUdLitJTdUwSJc5BAzDIq1qPmyyBsLXMabQ9foglBU5ZZk
	 D6dhOELZP9dQIpo8eFmCT1yoTqui+Hn74TN2TQ9m6gfhaLGyqgAv5ntXFWKN8wAHhQ
	 /6byjaao1BwOH4Xai+HEyQOI6e/gWLDq98aIixonysCh6etvtlDKMj3AuVvPVu3tsw
	 5yvXgeRWG97WSiJ8+rXzjm1pZlYM0bmc4ErrGRCLUJOuwj2//3rOKEvklQFEtd6dMr
	 Xkhr+NYlwLfljsfMngXmQfIsaH5htjwyjQ0VvTX4mjMAxmPzkh6surCpnkirsI8ZKl
	 6ZVK+A7zumtvw==
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
Subject: [PATCH RESEND v2 08/23] proc: let procfs own the seq_file of proc_create_seq() and friends
Date: Wed,  4 Nov 2026 20:31:13 +0100
Message-ID: <20261104-work-procfs-core-v2-8-76ace653a773@kernel.org>
In-Reply-To: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=7182; i=brauner@kernel.org; h=from:subject:message-id; bh=d/Gyh84EIwCT+5DcGz0I5uORN2AuffY7nyAO9oBimYM=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bq/aal96f3tFqaCN0pN9q9rO5ck4bXgt+OJkDedjT k3Ly9cOdpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEyEoZThD8+k4hrP6re7Hkgc jbw6N1dbZKrL1NVf5v3WTGtP3x1x+CvDH27eBy/1WC0LY1+Kxcy9e6R3dl2B6kXN8Ih/XprfWp2 ruQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8u781eguk4e46jx6n6h3cghfg8wwt1xz
X-Rspamd-Queue-Id: 170FC80005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793820687-591617
X-HE-Meta: U2FsdGVkX1/I4QsRIXPclpfqVDB9FLmI99InxPSkMtXo1lqwWUmjx7AQRIsGm+X1CNPrU3koSjHj2UAT1sw2p5NGJtyXeGvensCdKATjAVulhTjiCpd6nyKX2czkbAM9ncfb97Nc/6YsnLUDjiNk1kJr5OJO7ErEV768WczfwnLpLY1S7L8eR2NGP5f/EpAT/O4JD+Jx1dl1pM9GcmEuUSTnAgXFbA0ywGnskYlH0/zMbvlRhum/i1BSQQeRguBG1wqedf5Qbrdq76DTAqREWP6fS4OlFhYaTFrP/vNXw0RJWx8lXo4FnD7N/6xGB9wGeIV266eBzD1aNxCZCoQoY214bANwUtcc2QXbmWsU72Ovc4oDTQukjOw3EGTSlrKEj1VY3aXxu82gh7rPhhPhwnYD99UMPzJhoeD4YKbPG0OFiOM7oNyzl4QwwrJBFzkBHBNc3LmhGfntEgjJ5/vg+tr7Ny5LSAFmBAy3rGpdFlZH+MTSfZC1bVUhp4l/fyzyuMmgVklL+kaGC5wEVhd6KQ85A8JyGqDCshnHpuY1J2pEsZURh9++1wiRTEdvkF4wFewx/bkuDXNBWTbBXfamZhCVyIKCvtuaAv6+0dEfA7TiwgQDWeIOGa95sMFgL8TH4wNkZqTPzotz86cwI4bD9Rh9axX7mOaFKgeX2yOsnyNNc6aE1THFczdZD1UMg99CQt2OAY9B91I0T0w+WjTuaOQa/s15h0ldpY40leNXmQR+qUn9dOiTXGVcyJfNRhAz0nkzUVlzKRID5fme93AQmXLBBoXpPUBbZk0yMweTUGeUikeBtyLDcTInKjOyNLc9IlxPnyyib64wdnM9igiX80vJJTzT18+9cnxfQor9oqhi62sZ1Tl1fmy11sZtj7iQyqAOn8IBT0vt1FRt30MqA4/Wyq2o0K9x0sE/y02191RfZSKgxDli9/aC2cWMe0mB/sLB9/Jjeb6WsSdbt2N
 DYKK8LnE
 M2JuVP7g4l0fLTU6KVh9vooGBB7rPgL5QVRYKnQzVtfXQoVGWLoZAI175qZRIn1i5oio2vYObHtfwbtfRrkMGPUBPyVPbv+Rw8MC1qAEs6ZgsORjvqO0TWD6OcCYj4wEldj/RtzmJ5mFs9TGDpkVuu3MCgmkrRwNLYhDItgoY85nDq4abKFxc2RosvXAvceCtpQqk+skfbyiY/I6m0nX2K880IEjxTYiIFLlRAVxIgsucEVcmSTFKicJq8ETRgOe7AB05P6qVzMSSEdS9UaxREYAjPB4gzn+Vq3th+GU5jNS1kA52kOEFy05tWEVqOvlLWGQ6rFAP2Juz6o1Siq0xJ1USqBH7Q41Jirst/cEb2UHtrT28qgsjTMgNaoOMzilcoSVSgLLg1q8BWdWwZfgKNgQvR09urHAOo6MLYjQtmheZs/tqt6e5qTCbjaFkgwJxLpbyeMGWUlg1YcY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

proc_create_seq_private(), proc_create_single_data() and their network
namespace variants keep the seq_operations or the show function in the
entry already. Let procfs own the seq_file for all of them. For the
network namespace variants ->proc_open() and ->proc_release() keep
taking and dropping the reference to the network namespace.

That's most of /proc/net, among them the files of xt_hashlimit and
/proc/net/dev_snmp6/<dev>. A reader that faults on its buffer no longer
holds up their removal.

Reported-by: Chris Mason <mason@kernel.org>
Fixes: 786d7e1612f0 ("Fix rmmod/read/write races in /proc entries")
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/generic.c  | 42 ++++--------------------------------------
 fs/proc/proc_net.c | 40 +++++++++++++---------------------------
 2 files changed, 17 insertions(+), 65 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 59b89e251ba3..959bf9e33245 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -737,30 +737,9 @@ struct proc_dir_entry *proc_create(const char *name, umode_t mode,
 }
 EXPORT_SYMBOL(proc_create);
 
-static int proc_seq_open(struct inode *inode, struct file *file)
-{
-	struct proc_dir_entry *de = PDE(inode);
-
-	if (de->state_size)
-		return seq_open_private(file, de->seq_ops, de->state_size);
-	return seq_open(file, de->seq_ops);
-}
-
-static int proc_seq_release(struct inode *inode, struct file *file)
-{
-	struct proc_dir_entry *de = PDE(inode);
-
-	if (de->state_size)
-		return seq_release_private(inode, file);
-	return seq_release(inode, file);
-}
-
+/* procfs owns the seq_file of these, see pde_seq_start() */
 static const struct proc_ops proc_seq_ops = {
 	/* not permanent -- can call into arbitrary seq_operations */
-	.proc_open	= proc_seq_open,
-	.proc_read_iter	= seq_read_iter,
-	.proc_lseek	= seq_lseek,
-	.proc_release	= proc_seq_release,
 };
 
 struct proc_dir_entry *proc_create_seq_private(const char *name, umode_t mode,
@@ -775,25 +754,11 @@ struct proc_dir_entry *proc_create_seq_private(const char *name, umode_t mode,
 	p->proc_ops = &proc_seq_ops;
 	p->seq_ops = ops;
 	p->state_size = state_size;
+	p->flags |= PROC_ENTRY_proc_seq_ops;
 	return proc_register(parent, p);
 }
 EXPORT_SYMBOL(proc_create_seq_private);
 
-static int proc_single_open(struct inode *inode, struct file *file)
-{
-	struct proc_dir_entry *de = PDE(inode);
-
-	return single_open(file, de->single_show, de->data);
-}
-
-static const struct proc_ops proc_single_ops = {
-	/* not permanent -- can call into arbitrary ->single_show */
-	.proc_open	= proc_single_open,
-	.proc_read_iter = seq_read_iter,
-	.proc_lseek	= seq_lseek,
-	.proc_release	= single_release,
-};
-
 struct proc_dir_entry *proc_create_single_data(const char *name, umode_t mode,
 		struct proc_dir_entry *parent,
 		int (*show)(struct seq_file *, void *), void *data)
@@ -803,8 +768,9 @@ struct proc_dir_entry *proc_create_single_data(const char *name, umode_t mode,
 	p = proc_create_reg(name, mode, &parent, data);
 	if (!p)
 		return NULL;
-	p->proc_ops = &proc_single_ops;
+	p->proc_ops = &proc_seq_ops;
 	p->single_show = show;
+	p->flags |= PROC_ENTRY_proc_show;
 	return proc_register(parent, p);
 }
 EXPORT_SYMBOL(proc_create_single_data);
diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
index df5484813d5d..9973f846c467 100644
--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -37,13 +37,13 @@ static struct net *get_proc_net(const struct inode *inode)
 	return maybe_get_net(PDE_NET(PDE(inode)));
 }
 
+/* procfs opened the seq_file and allocated its state, see pde_seq_start() */
 static int seq_open_net(struct inode *inode, struct file *file)
 {
-	unsigned int state_size = PDE(inode)->state_size;
-	struct seq_net_private *p;
+	struct seq_net_private *p = ((struct seq_file *)file->private_data)->private;
 	struct net *net;
 
-	WARN_ON_ONCE(state_size < sizeof(*p));
+	WARN_ON_ONCE(PDE(inode)->state_size < sizeof(*p));
 
 	if (file->f_mode & FMODE_WRITE && !PDE(inode)->write)
 		return -EACCES;
@@ -51,12 +51,6 @@ static int seq_open_net(struct inode *inode, struct file *file)
 	net = get_proc_net(inode);
 	if (!net)
 		return -ENXIO;
-
-	p = __seq_open_private(file, PDE(inode)->seq_ops, state_size);
-	if (!p) {
-		put_net(net);
-		return -ENOMEM;
-	}
 #ifdef CONFIG_NET_NS
 	p->net = net;
 	netns_tracker_alloc(net, &p->ns_tracker, GFP_KERNEL);
@@ -77,18 +71,13 @@ static void seq_file_net_put_net(struct seq_file *seq)
 
 static int seq_release_net(struct inode *ino, struct file *f)
 {
-	struct seq_file *seq = f->private_data;
-
-	seq_file_net_put_net(seq);
-	seq_release_private(ino, f);
+	seq_file_net_put_net(f->private_data);
 	return 0;
 }
 
 static const struct proc_ops proc_net_seq_ops = {
 	.proc_open	= seq_open_net,
-	.proc_read	= seq_read,
 	.proc_write	= proc_simple_write,
-	.proc_lseek	= seq_lseek,
 	.proc_release	= seq_release_net,
 };
 
@@ -125,6 +114,7 @@ struct proc_dir_entry *proc_create_net_data(const char *name, umode_t mode,
 	p->proc_ops = &proc_net_seq_ops;
 	p->seq_ops = ops;
 	p->state_size = state_size;
+	p->flags |= PROC_ENTRY_proc_seq_ops;
 	return proc_register(parent, p);
 }
 EXPORT_SYMBOL_GPL(proc_create_net_data);
@@ -170,6 +160,7 @@ struct proc_dir_entry *proc_create_net_data_write(const char *name, umode_t mode
 	p->proc_ops = &proc_net_seq_ops;
 	p->seq_ops = ops;
 	p->state_size = state_size;
+	p->flags |= PROC_ENTRY_proc_seq_ops;
 	p->write = write;
 	return proc_register(parent, p);
 }
@@ -177,32 +168,25 @@ EXPORT_SYMBOL_GPL(proc_create_net_data_write);
 
 static int single_open_net(struct inode *inode, struct file *file)
 {
-	struct proc_dir_entry *de = PDE(inode);
-	struct net *net;
-	int err;
+	struct net *net = get_proc_net(inode);
 
-	net = get_proc_net(inode);
 	if (!net)
 		return -ENXIO;
-
-	err = single_open(file, de->single_show, net);
-	if (err)
-		put_net(net);
-	return err;
+	((struct seq_file *)file->private_data)->private = net;
+	return 0;
 }
 
 static int single_release_net(struct inode *ino, struct file *f)
 {
 	struct seq_file *seq = f->private_data;
+
 	put_net(seq->private);
-	return single_release(ino, f);
+	return 0;
 }
 
 static const struct proc_ops proc_net_single_ops = {
 	.proc_open	= single_open_net,
-	.proc_read	= seq_read,
 	.proc_write	= proc_simple_write,
-	.proc_lseek	= seq_lseek,
 	.proc_release	= single_release_net,
 };
 
@@ -218,6 +202,7 @@ struct proc_dir_entry *proc_create_net_single(const char *name, umode_t mode,
 	pde_force_lookup(p);
 	p->proc_ops = &proc_net_single_ops;
 	p->single_show = show;
+	p->flags |= PROC_ENTRY_proc_show;
 	return proc_register(parent, p);
 }
 EXPORT_SYMBOL_GPL(proc_create_net_single);
@@ -261,6 +246,7 @@ struct proc_dir_entry *proc_create_net_single_write(const char *name, umode_t mo
 	pde_force_lookup(p);
 	p->proc_ops = &proc_net_single_ops;
 	p->single_show = show;
+	p->flags |= PROC_ENTRY_proc_show;
 	p->write = write;
 	return proc_register(parent, p);
 }

-- 
2.53.0


