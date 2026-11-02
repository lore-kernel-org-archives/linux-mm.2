Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B827608AC61
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VdcZ4QFp
Received: by kanga.kvack.org (Postfix)
	id A0C456B05CE; Mon,  2 Nov 2026 10:33:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BC626B061D; Mon,  2 Nov 2026 10:33:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AB6D6B0638; Mon,  2 Nov 2026 10:33:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 61B0F6B05CE
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:33:58 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EAD311A017D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:33:57 +0000 (UTC)
X-FDA: 85390574514.26.C05B286
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 35B0C80002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:33:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VdcZ4QFp;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TK360Q0J9loLLBJN1fCdf93Od8lfv7JQwcxqeqOSWBU=;
	b=uno3GHFi7OvVGPczuhRGEY7UQ0bWmJ4eC4XaQoB8fClJwOjXVqmqHSdcvRaRf6OzjOsMOH
	Ry2fBf2JQCEE4k7Vqpho1DFsW04HkKaMNND0UpIXOjwiCm7VfJBtwDZIzau2J6HfH8lKqX
	VCIEoTHBK3fEQMAHH3wlnkYwAI//6ng=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VdcZ4QFp;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633636;
	b=wmnVS/SH6b+8MsstIhgniUzY+wKfdHe2oohynFmDCsllH1UerLrPKAZkJpHOo1awLU6gx9
	62kHI1Za8HEWwNXicVNxFRMNHb+SY9x2Z07gVW8B2CcjgHg/yT7crosU/3encZzDhk5Hz+
	kypBa0fJTJoFnqgEMUQ+VvqvP9e2j9g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B911060625;
	Mon,  2 Nov 2026 15:33:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C9631F00A16;
	Mon,  2 Nov 2026 15:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633635;
	bh=TK360Q0J9loLLBJN1fCdf93Od8lfv7JQwcxqeqOSWBU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VdcZ4QFphvz/aGivrbf7iePh6qXVUBStibznajyzqusVWBsrxcy0EcezsqqdXFTgw
	 Tanj+pajzFQT1IcSiQwVY9ZF32/NB815X1E8niHSCQtrMcNmSJQoGopcmRQr+jm8Dc
	 NY/X4yfjkgL9TTITZYZF8R43x6PS/zn9kAuwDXlY7N/+LREL5IIRSKVjJW+ZhgtZG+
	 WKgH663rZrJFecmgkbpS0lrCfO660Tnz1keC9/Yr7gjUpWjGAkhB373EqJvMziyRLj
	 5XaMNzWmZ65VAMr81aqdlEc9zjG/IDnaQuV+YpuDedYYCoO87rGXyvGaa3yJtqO2s6
	 RolUHV3j7QlLw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:22 +0100
Subject: [PATCH RFC 08/11] SUNRPC: let procfs copy out reads
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-net-v1-8-982104a4f592@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=8375; i=brauner@kernel.org;
 h=from:subject:message-id; bh=a9MpcCErAr+XLynuyr8Lv5es65Jw33sURzMgM9R8Toc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG4i+70iJeNx8lGhqrxO33iFhgsTlQPuhnOvMPwd3
 rh//YcNHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPxO8/I8NR7wk6vqDbZy/ku
 XlenMv+62MaQHdmwTUfhc+08KaEjxxn+lxik7rhoK8Z4eLFcQ+KD1ZsiV5WdCOGP0rh+MF5JWsW
 OEwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 35B0C80002
X-Stat-Signature: rj5d7hejjike7imtsduwe7p7rr43p63o
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793633636-18125
X-HE-Meta: U2FsdGVkX1/MigXZ4DGLtDpkDABlTlY2hOHkZ7oM7TYh2Lh5Z5scpJkWxz3Gk6cbzJSS1DWsiyxjQytt37GTgEhYaOEhc0NEolJVSzWUqGw1KDRITx/r6afxMjdecouX3NQKpZzTyL1heknr2wYmGF9eR2P07+xGcXCYNGOx3LQfb53HtIROHBbVCaytkp6qDJ9Q+fbGFoTNlApTat8SQ3KdCrQD5ekq1Ok2zHSlAYuix4dXlt28kuFeI5dtXMe3Yja4cMHbpHM7uUbxYM3xA1x0f2848j9SXE2MkzgntQmPs7arjItoOg7xHmJfKIc7Mw1rreQwWj4lq7Bx8m37graeyR3yWiNUdvS9lgnJDDeMS4+R6zTxrt3Y6gN2zxCgHuXnSnQ966/SF43KSIrHCxyCV7+odEll2SQ0vEjYEGIjp9lsAeTfgu+tN33AfiPkvf7qxe6C8FyM6skiZmBjEJclBYBhwVS9o+3MTFCjHhCZ+Jo74kDLgJ8t68ArlEDgSYAqS1K7G8PsPWFWMTEOv+ag7VxHzk9kEqeh0SxfJxKpnMKSBoIDUU/2mA7DZxiEzjWK4NL92oZfIG0LQE8UgbippUocyXm+845qEsd1w/UPVxCItx/VndMJt4M4IyS0u55o3nrO48YR0HpiO7/Zr8RVMB1YdgWxYTTI1G1g81LRw5WBHax4YSNLJQkeZEn292TzI5Zu3Lq7MEfcoLEuzeCcLjvqD4IXCd7aqICIVjB6S5e1F7oy+/+g9i1gi4W1XulkPhsKl/WaGrQ91puUGFD9JK5IyEGuj3gtankE7VZ5XDPpjd4BWE9t0dbjwGSxwbzZ0GJN7Tgodb6y9xtn7Hk9uhfY5ODIBf1tioZEXli/qsZas0Nr4wuDPBYLyTJ7WgoemD0qwO0V7sr2slVtImnXZFvUE9dCvreO5qDvmUyjqd03NQvo11dxdWls5XvpG5lKGZMIXtKay6i91Dh
 QEaG9PbF
 YOhqpdi2IElyK1fXdfjMt6XRhWUWto+ND6s3GtZGzd6theo5kRk7fhLy9E3Z+pf4mEoKqKPJDfaI+n26fEb/z6x60Q4sDNUKF9Ozq8IjsJlbdl8ZHaIT9JXNRvxw3CH6yn1sd78gZvKKFII5CgAgdOylyTPhOBjskmTi7vDZ7AS5+FHB4UeK0VhtPFiCP/9gpZZGPJnfkeRIIgNulVx86Kue4cFFK5ntt31JrZ5IrL7wgZu2+GRCjK3fCzey2pENEFFqK//s/tipZ26ReVyKSMsNrlcR8ErR2ANMm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_read_buf() for the procfs channel, flush,
use-gss-proxy and gss_krb5_enctypes files so procfs copies what is read
to userspace after it unpinned the entry.

cache_read() takes an iov_iter now. The rpc_pipefs channel file passes
one for the user buffer and behaves like before. The procfs one passes
one for procfs' buffer, and a read still hands out at most one request.
A reader of the procfs channel file whose copy out fails, a readv()
with a bad later segment included, loses what was handed out, since the
request moves on before procfs copies it out. If that was only part of
a request the next read returns the rest of it. Both flush files share
flush_time_text().

The procfs files are removed when the network namespace goes away and
that no longer waits for a reader that faults on its buffer.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 net/sunrpc/auth_gss/svcauth_gss.c | 24 ++++++-------------
 net/sunrpc/cache.c                | 50 +++++++++++++++++++++++----------------
 2 files changed, 36 insertions(+), 38 deletions(-)

diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index 8d105cd900d4..67e086a7127c 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1442,32 +1442,22 @@ static ssize_t write_gssp(struct file *file, char *buf, size_t count,
 	return count;
 }
 
-static ssize_t read_gssp(struct file *file, char __user *buf,
+static ssize_t read_gssp(struct file *file, char *buf,
 			 size_t count, loff_t *ppos)
 {
 	struct net *net = pde_data(file_inode(file));
 	struct sunrpc_net *sn = net_generic(net, sunrpc_net_id);
-	unsigned long p = *ppos;
 	char tbuf[10];
 	size_t len;
 
-	snprintf(tbuf, sizeof(tbuf), "%d\n", sn->use_gss_proxy);
-	len = strlen(tbuf);
-	if (p >= len)
-		return 0;
-	len -= p;
-	if (len > count)
-		len = count;
-	if (copy_to_user(buf, (void *)(tbuf+p), len))
-		return -EFAULT;
-	*ppos += len;
-	return len;
+	len = snprintf(tbuf, sizeof(tbuf), "%d\n", sn->use_gss_proxy);
+	return memory_read_from_buffer(buf, count, ppos, tbuf, len);
 }
 
 static const struct proc_ops use_gss_proxy_proc_ops = {
 	.proc_open	= nonseekable_open,
 	.proc_write_buf	= write_gssp,
-	.proc_read	= read_gssp,
+	.proc_read_buf	= read_gssp,
 };
 
 static int create_use_gss_proxy_proc_entry(struct net *net)
@@ -1494,7 +1484,7 @@ static void destroy_use_gss_proxy_proc_entry(struct net *net)
 	}
 }
 
-static ssize_t read_gss_krb5_enctypes(struct file *file, char __user *buf,
+static ssize_t read_gss_krb5_enctypes(struct file *file, char *buf,
 				      size_t count, loff_t *ppos)
 {
 	struct rpcsec_gss_oid oid = {
@@ -1512,7 +1502,7 @@ static ssize_t read_gss_krb5_enctypes(struct file *file, char __user *buf,
 		return 0;
 	}
 
-	ret = simple_read_from_buffer(buf, count, ppos,
+	ret = memory_read_from_buffer(buf, count, ppos,
 				      mech->gm_upcall_enctypes,
 				      strlen(mech->gm_upcall_enctypes));
 	gss_mech_put(mech);
@@ -1521,7 +1511,7 @@ static ssize_t read_gss_krb5_enctypes(struct file *file, char __user *buf,
 
 static const struct proc_ops gss_krb5_enctypes_proc_ops = {
 	.proc_open	= nonseekable_open,
-	.proc_read	= read_gss_krb5_enctypes,
+	.proc_read_buf	= read_gss_krb5_enctypes,
 };
 
 static int create_krb5_enctypes_proc_entry(struct net *net)
diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index a257598768fa..81a3f0068f36 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -28,6 +28,7 @@
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
 #include <linux/pagemap.h>
+#include <linux/uio.h>
 #include <asm/ioctls.h>
 #include <linux/sunrpc/types.h>
 #include <linux/sunrpc/cache.h>
@@ -837,9 +838,10 @@ cache_next_request(struct cache_detail *cd, u64 seqno)
 	return NULL;
 }
 
-static ssize_t cache_read(struct file *filp, char __user *buf, size_t count,
-			  loff_t *ppos, struct cache_detail *cd)
+static ssize_t cache_read(struct file *filp, struct iov_iter *to,
+			  struct cache_detail *cd)
 {
+	size_t count = iov_iter_count(to);
 	struct cache_reader *rp = filp->private_data;
 	struct cache_request *rq;
 	struct inode *inode = file_inode(filp);
@@ -878,7 +880,7 @@ static ssize_t cache_read(struct file *filp, char __user *buf, size_t count,
 		if (rp->offset + count > rq->len)
 			count = rq->len - rp->offset;
 		err = -EFAULT;
-		if (copy_to_user(buf, rq->buf + rp->offset, count))
+		if (copy_to_iter(rq->buf + rp->offset, count, to) != count)
 			goto out;
 		rp->offset += count;
 		if (rp->offset >= rq->len) {
@@ -1499,16 +1501,11 @@ static int release_flush(struct inode *inode, struct file *file,
 	return 0;
 }
 
-static ssize_t read_flush(struct file *file, char __user *buf,
-			  size_t count, loff_t *ppos,
-			  struct cache_detail *cd)
+/* what reading the flush files returns */
+static size_t flush_time_text(struct cache_detail *cd, char *tbuf, size_t size)
 {
-	char tbuf[22];
-	size_t len;
-
-	len = snprintf(tbuf, sizeof(tbuf), "%llu\n",
+	return snprintf(tbuf, size, "%llu\n",
 			convert_to_wallclock(cd->flush_time));
-	return simple_read_from_buffer(buf, count, ppos, tbuf, len);
 }
 
 /* longest number the flush files take */
@@ -1564,12 +1561,15 @@ static ssize_t write_flush(struct file *file, const char __user *buf,
 	return do_write_flush(tbuf, count, ppos, cd);
 }
 
-static ssize_t cache_read_procfs(struct file *filp, char __user *buf,
-				 size_t count, loff_t *ppos)
+static ssize_t cache_read_procfs(struct file *filp, char *buf, size_t count,
+				 loff_t *ppos)
 {
 	struct cache_detail *cd = pde_data(file_inode(filp));
+	struct kvec kvec = { .iov_base = buf, .iov_len = count };
+	struct iov_iter to;
 
-	return cache_read(filp, buf, count, ppos, cd);
+	iov_iter_kvec(&to, ITER_DEST, &kvec, 1, count);
+	return cache_read(filp, &to, cd);
 }
 
 /* procfs copied in what was written */
@@ -1620,7 +1620,7 @@ static int cache_release_procfs(struct inode *inode, struct file *filp)
 }
 
 static const struct proc_ops cache_channel_proc_ops = {
-	.proc_read	= cache_read_procfs,
+	.proc_read_buf	= cache_read_procfs,
 	.proc_write_buf	= cache_write_procfs,
 	.proc_write_size = CACHE_DOWNCALL_MAX,
 	.proc_poll	= cache_poll_procfs,
@@ -1668,12 +1668,15 @@ static int release_flush_procfs(struct inode *inode, struct file *filp)
 	return release_flush(inode, filp, cd);
 }
 
-static ssize_t read_flush_procfs(struct file *filp, char __user *buf,
-			    size_t count, loff_t *ppos)
+static ssize_t read_flush_procfs(struct file *filp, char *buf, size_t count,
+				 loff_t *ppos)
 {
 	struct cache_detail *cd = pde_data(file_inode(filp));
+	char tbuf[22];
+	size_t len;
 
-	return read_flush(filp, buf, count, ppos, cd);
+	len = flush_time_text(cd, tbuf, sizeof(tbuf));
+	return memory_read_from_buffer(buf, count, ppos, tbuf, len);
 }
 
 static ssize_t write_flush_procfs(struct file *filp, char *buf, size_t count,
@@ -1688,7 +1691,7 @@ static ssize_t write_flush_procfs(struct file *filp, char *buf, size_t count,
 
 static const struct proc_ops cache_flush_proc_ops = {
 	.proc_open	= open_flush_procfs,
-	.proc_read	= read_flush_procfs,
+	.proc_read_buf	= read_flush_procfs,
 	.proc_write_buf	= write_flush_procfs,
 	.proc_write_size = CACHE_FLUSH_MAX,
 	.proc_release	= release_flush_procfs,
@@ -1795,8 +1798,10 @@ static ssize_t cache_read_pipefs(struct file *filp, char __user *buf,
 				 size_t count, loff_t *ppos)
 {
 	struct cache_detail *cd = RPC_I(file_inode(filp))->private;
+	struct iov_iter to;
 
-	return cache_read(filp, buf, count, ppos, cd);
+	iov_iter_ubuf(&to, ITER_DEST, buf, count);
+	return cache_read(filp, &to, cd);
 }
 
 static ssize_t cache_write_pipefs(struct file *filp, const char __user *buf,
@@ -1886,8 +1891,11 @@ static ssize_t read_flush_pipefs(struct file *filp, char __user *buf,
 			    size_t count, loff_t *ppos)
 {
 	struct cache_detail *cd = RPC_I(file_inode(filp))->private;
+	char tbuf[22];
+	size_t len;
 
-	return read_flush(filp, buf, count, ppos, cd);
+	len = flush_time_text(cd, tbuf, sizeof(tbuf));
+	return simple_read_from_buffer(buf, count, ppos, tbuf, len);
 }
 
 static ssize_t write_flush_pipefs(struct file *filp,

-- 
2.53.0


