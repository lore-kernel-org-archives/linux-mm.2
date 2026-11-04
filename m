Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3B0E606E4E1
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nrCpHMqJ
Received: by kanga.kvack.org (Postfix)
	id 107736B05F5; Wed,  4 Nov 2026 14:59:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B5E66B05F6; Wed,  4 Nov 2026 14:59:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC0C46B05F7; Wed,  4 Nov 2026 14:59:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C5CF16B05F5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:59:38 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5D87CC0864
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:59:38 +0000 (UTC)
X-FDA: 85398501636.10.2F7F13B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id A20ED1C0006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:59:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nrCpHMqJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793822376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I87aXd9DKn5INMWxVGI3L3LJev8psccpA6qjKtl7++0=;
	b=Lh4iyCNEeVbHt/fSP58c5dtEzn/lXCxM8noN/APzbmn5zcCUEldDePkPocYLOEtFz9j/Rt
	/3xHv08VZfgMuMGXU/FDwggKE1ZUPkjc2kitrFiTcfdBbey4ZeV0zhIxcrIR4pZXdWktyl
	GO5EsKV4gqO8btEq/xBOAH//o+XyTIE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nrCpHMqJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793822376;
	b=SseF1JuLu8kOofA5fmwfCub5kL5kU4d04sc3nHWCZtWfsIC16ASTf85KCxIS4A+Pr79vqN
	5K6/++I7b0XGmvnU3QKp67+NJcwyF8BdPRXaSI1zVexAsqQsPte6K4ciW0DvIv6LparHcs
	C374k6XEzWAIfZnM+D4LKJd1S5ppsvI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C1DD62CC5;
	Wed,  4 Nov 2026 19:59:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7AA61F000C1;
	Wed,  4 Nov 2026 19:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793822375;
	bh=I87aXd9DKn5INMWxVGI3L3LJev8psccpA6qjKtl7++0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nrCpHMqJnM4/sQC5S1S2Zw8qcgNXDwp5M5frmMQ1a2YEm8KSyesVzABoG/prl1gEu
	 b5yCZfTlj58jdNYknyrsSDRlMPnZ62hJzFY5ukIBsBbvKsCqbtZo+OaClqA5mnNTQ5
	 RmlrEeWrqd82SvvID1akhJpJQXRL5M7HPpkzdM1ufcSEta6wA7KmOMAw3dbQTERPJI
	 0DxtZkknuOjdAfUWP9ABo/4xVm5B4KshKmNCD8wCMG5k2yG5matPNPgJ5is1ZqqyUY
	 LZiBF+HJWBtLc1ohmQHqNmi/qIfEBdTaicmB6L7NVy57kU83OXBM14TugcOlp7BOeD
	 dtfxCwiwXkmew==
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
Subject: [PATCH RESEND v2 07/13] SUNRPC: let procfs copy in writes
Date: Wed,  4 Nov 2026 20:59:21 +0100
Message-ID: <20261104-work-procfs-net-v2-7-221e2437fed1@kernel.org>
In-Reply-To: <20261104-work-procfs-net-v2-0-221e2437fed1@kernel.org>
References: <20261104-work-procfs-net-v2-0-221e2437fed1@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=6349; i=brauner@kernel.org; h=from:subject:message-id; bh=qIHvvtDF4hd5tLnMryapPJOuLcFfYH/7YZBGB4Dja6Y=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97tPWDijvvLiq30G1PaKN/bXgyT9/A9gNXwfur8jS2 ez9bFpARykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwER4yxkZmg16dliqcnIvnt1y 7Jn1H/Gg45ULRBh9pY6k3ViRsu6+KyPDyT3Wor+sjocbG95uZVu58W2UZHPhy4/GH210twVIfBL kBwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A20ED1C0006
X-Stat-Signature: 85enf5d63gwez44xk5d8o7jbwnuq5hbo
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793822376-107163
X-HE-Meta: U2FsdGVkX19AMyO823MI+z2UUfX916kpEK2hpYj4aXIqCMGln8Wx/9LqeN9hvNZCEQPxvKWDnTVOyQFGvvcw/oUxIb/5FSfDWfPLJBA1XsStxzRDBwSEmDq6Lb6s4d8JtVBpy7oEqx1rlljTGtKFs8ize2xnKUrLFFHsc4nEox+oI56Xdrq7b6rFDZ+6YbJXakI0B1nQMhzPXaYGMdMRzFW1rSmJnXvltFOjYB4ir7v8Usl3wlwsgGv08v8zLYPtfxZioTVTXLUesdKgWrtoarPA+MHVESoMFYMct9MiK5R9tGUl1aGuw4ZpDcu2ZlUxPGQuxknyzXjPexocZYwt56/FTE4iS/u2eW54GHjoMwgsUkHEijfS9e1/zDaxUB4sERUC/8MMDJiZcwS+CByOsEt8ENDD0veq+CsuOxU72aQ02YPkzw1XxqLaJMVLCmBq8IVq5bqP3l9Ke0Bu4A7B32Ykg8Dv5UJOcBr/KLVaA28pdI5z52uwX0vfcA8eofDgCwlnM4NDk8/yh1lvWYGaeHrouE3DW8KUhjeHPI1TSC03Yupa6IlWgbF1NqLED9PkCNQNelkfCNZ0PRfYXkIiqis1Yt+UfFUUMUB/MQFOVYKP3n9ZeJDekCOTqjFpWlR/iGkgO9C64rtXOh5of2+g6+Eh8lzizWiJs8uhTVsVCV6JCt3z9NbSWnuEApIM+oGyW1t9yP4PYy6j5Wp9UNIoJ9htxEwZG8FWAFWLfMuQ1RI1L0sbjh7dDPsmqBv/0MztK8fNiRkAMQB3BT1zcU2TSfu9CKdA65sghKRK3QcMryPp2y1g9lxGi82H+TjjOR2Zvly80nZvAk5LgCJYF+jXAT+24jf1ootG1aG36AENsX/Q6OfXwZbueKtIKZMJFx8THnZWRMEyTE993XgYdcZfhUuLDjmgJ5xrMb9ed4W7KOMTtLx13Qs46dX4Z4i83fDa5e5VKRxc2rS69/43kOC
 Ld456mhV
 krIzmtMXLZaYQVvcbiHQXgRLEWKwM9hk3b71sOe9Q19PPwYZBZ4o26om9uZuaLuHaR+teqKA+1SRM45t/q4SDWnW5qX/pkpmvNVUtafXXYrua+XvLdhxtQPGX3GOYm/vev196IBANRdnMnSyqfJSNfnWMu0c6dTDLpoXpjjgsmcFK1CSxLbs7BE6/lUtTufKL3IvMpAXAM3i94JHglAOnRXrJkUHje9Q1YcRcF4Zxeln6yKTrGH43gD1z0BQ/hEJITS/VtCTvcOUEK1FKHh8o4tbog8b1raXYGC2FSYNX0lSzVcysa6KlxnmGBDDTKLO2kAEaAyJUOI2mT+JfdjA6MJ/hQrbkoxrFhcCtmFFlJ86qGTDmD/edYyYad18Do+8X4yu+KHYgd7eLOruHIrijG6+nuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() for the procfs channel, flush and
use-gss-proxy files so procfs copies in what is written before it pins
the entry. The channel file parses the downcall from that copy and the
flush files share the parsing with rpc_pipefs in do_write_flush(). The
rpc_pipefs files keep copying in themselves.

CACHE_DOWNCALL_MAX and CACHE_FLUSH_MAX name the limits both sides
enforce, procfs through ->proc_write_size. The procfs files are removed
when the network namespace goes away and that no longer waits for a
writer that faults on its buffer.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 net/sunrpc/auth_gss/svcauth_gss.c | 10 +++----
 net/sunrpc/cache.c                | 63 +++++++++++++++++++++++++++------------
 2 files changed, 48 insertions(+), 25 deletions(-)

diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index 43839e805531..8d105cd900d4 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1408,8 +1408,8 @@ svcauth_gss_proc_init(struct svc_rqst *rqstp, struct rpc_gss_wire_cred *gc)
 
 #ifdef CONFIG_PROC_FS
 
-static ssize_t write_gssp(struct file *file, const char __user *buf,
-			 size_t count, loff_t *ppos)
+static ssize_t write_gssp(struct file *file, char *buf, size_t count,
+			  loff_t *ppos)
 {
 	struct net *net = pde_data(file_inode(file));
 	char tbuf[20];
@@ -1418,9 +1418,7 @@ static ssize_t write_gssp(struct file *file, const char __user *buf,
 
 	if (*ppos || count > sizeof(tbuf)-1)
 		return -EINVAL;
-	if (copy_from_user(tbuf, buf, count))
-		return -EFAULT;
-
+	memcpy(tbuf, buf, count);
 	tbuf[count] = 0;
 	res = kstrtoul(tbuf, 0, &i);
 	if (res)
@@ -1468,7 +1466,7 @@ static ssize_t read_gssp(struct file *file, char __user *buf,
 
 static const struct proc_ops use_gss_proxy_proc_ops = {
 	.proc_open	= nonseekable_open,
-	.proc_write	= write_gssp,
+	.proc_write_buf	= write_gssp,
 	.proc_read	= read_gssp,
 };
 
diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index 007521e8a57f..a257598768fa 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -924,6 +924,9 @@ static ssize_t cache_do_downcall(char *kaddr, const char __user *buf,
 	return ret;
 }
 
+/* 32k is max userland buffer, lets check anyway */
+#define CACHE_DOWNCALL_MAX	(32768 - 1)
+
 static ssize_t cache_downcall(struct address_space *mapping,
 			      const char __user *buf,
 			      size_t count, struct cache_detail *cd)
@@ -931,7 +934,7 @@ static ssize_t cache_downcall(struct address_space *mapping,
 	char *write_buf;
 	ssize_t ret = -ENOMEM;
 
-	if (count >= 32768) { /* 32k is max userland buffer, lets check anyway */
+	if (count > CACHE_DOWNCALL_MAX) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -1508,19 +1511,15 @@ static ssize_t read_flush(struct file *file, char __user *buf,
 	return simple_read_from_buffer(buf, count, ppos, tbuf, len);
 }
 
-static ssize_t write_flush(struct file *file, const char __user *buf,
-			   size_t count, loff_t *ppos,
-			   struct cache_detail *cd)
+/* longest number the flush files take */
+#define CACHE_FLUSH_MAX		19
+
+static ssize_t do_write_flush(char *tbuf, size_t count, loff_t *ppos,
+			      struct cache_detail *cd)
 {
-	char tbuf[20];
 	char *ep;
 	time64_t now;
 
-	if (*ppos || count > sizeof(tbuf)-1)
-		return -EINVAL;
-	if (copy_from_user(tbuf, buf, count))
-		return -EFAULT;
-	tbuf[count] = 0;
 	simple_strtoul(tbuf, &ep, 0);
 	if (*ep && *ep != '\n')
 		return -EINVAL;
@@ -1551,6 +1550,20 @@ static ssize_t write_flush(struct file *file, const char __user *buf,
 	return count;
 }
 
+static ssize_t write_flush(struct file *file, const char __user *buf,
+			   size_t count, loff_t *ppos,
+			   struct cache_detail *cd)
+{
+	char tbuf[CACHE_FLUSH_MAX + 1];
+
+	if (*ppos || count > CACHE_FLUSH_MAX)
+		return -EINVAL;
+	if (copy_from_user(tbuf, buf, count))
+		return -EFAULT;
+	tbuf[count] = 0;
+	return do_write_flush(tbuf, count, ppos, cd);
+}
+
 static ssize_t cache_read_procfs(struct file *filp, char __user *buf,
 				 size_t count, loff_t *ppos)
 {
@@ -1559,12 +1572,21 @@ static ssize_t cache_read_procfs(struct file *filp, char __user *buf,
 	return cache_read(filp, buf, count, ppos, cd);
 }
 
-static ssize_t cache_write_procfs(struct file *filp, const char __user *buf,
-				  size_t count, loff_t *ppos)
+/* procfs copied in what was written */
+static ssize_t cache_write_procfs(struct file *filp, char *buf, size_t count,
+				  loff_t *ppos)
 {
 	struct cache_detail *cd = pde_data(file_inode(filp));
+	struct inode *inode = file_inode(filp);
+	ssize_t ret;
 
-	return cache_write(filp, buf, count, ppos, cd);
+	if (!cd->cache_parse || !count)
+		return -EINVAL;
+
+	inode_lock(inode);
+	ret = cd->cache_parse(cd, buf, count);
+	inode_unlock(inode);
+	return ret ? ret : count;
 }
 
 static __poll_t cache_poll_procfs(struct file *filp, poll_table *wait)
@@ -1599,7 +1621,8 @@ static int cache_release_procfs(struct inode *inode, struct file *filp)
 
 static const struct proc_ops cache_channel_proc_ops = {
 	.proc_read	= cache_read_procfs,
-	.proc_write	= cache_write_procfs,
+	.proc_write_buf	= cache_write_procfs,
+	.proc_write_size = CACHE_DOWNCALL_MAX,
 	.proc_poll	= cache_poll_procfs,
 	.proc_ioctl	= cache_ioctl_procfs, /* for FIONREAD */
 	.proc_open	= cache_open_procfs,
@@ -1653,19 +1676,21 @@ static ssize_t read_flush_procfs(struct file *filp, char __user *buf,
 	return read_flush(filp, buf, count, ppos, cd);
 }
 
-static ssize_t write_flush_procfs(struct file *filp,
-				  const char __user *buf,
-				  size_t count, loff_t *ppos)
+static ssize_t write_flush_procfs(struct file *filp, char *buf, size_t count,
+				  loff_t *ppos)
 {
 	struct cache_detail *cd = pde_data(file_inode(filp));
 
-	return write_flush(filp, buf, count, ppos, cd);
+	if (*ppos)
+		return -EINVAL;
+	return do_write_flush(buf, count, ppos, cd);
 }
 
 static const struct proc_ops cache_flush_proc_ops = {
 	.proc_open	= open_flush_procfs,
 	.proc_read	= read_flush_procfs,
-	.proc_write	= write_flush_procfs,
+	.proc_write_buf	= write_flush_procfs,
+	.proc_write_size = CACHE_FLUSH_MAX,
 	.proc_release	= release_flush_procfs,
 };
 

-- 
2.53.0


