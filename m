Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C44F760D6987
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bh5eE4AE
Received: by kanga.kvack.org (Postfix)
	id E4D046B0609; Mon,  2 Nov 2026 10:31:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E248B6B0633; Mon,  2 Nov 2026 10:31:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D13EB6B0634; Mon,  2 Nov 2026 10:31:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC8356B0609
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:31:51 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 57C251401A1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:31:51 +0000 (UTC)
X-FDA: 85390569222.10.D4439E3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 86EDEA000F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:31:49 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bh5eE4AE;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FuQ+O9AN/EhfuAINsZT/2MGBlHToxixjGEE2AnbYkS0=;
	b=J4AHGLjAmQIIWdRI6wVtXBqADoMqTDqxbNCddiOya/cvAjMBJ/J3bE+vfbemlC3nY9V/Wr
	MtWthSRllqGJY2oV+XWkmdhHgd9BvDm9LrhAS2QEBJ0UZ2Uf3fO6U9sHZRl1l4/ArW/uXt
	rEs3oRyKhxzVrByT4/AnaYXF7FsjCM8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bh5eE4AE;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633509;
	b=W2Ys97T7Xo4Yq07FQcsa1Ob7L5narDyOFpUhqguCnYELRI8HDUv5/0116hjy6CuYHphFBH
	e8O8JwlKqjDjI6BG6hv2HNKgMwGNIvNtvJtBb3PvnjXA8LIxQN6qQ/RcifJT3cjw+JVTJe
	4fF/uNL8gM85Tvw08t5pAXQ7QeE1XNM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 13EA760DC0;
	Mon,  2 Nov 2026 15:31:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0FE71F00A18;
	Mon,  2 Nov 2026 15:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633508;
	bh=FuQ+O9AN/EhfuAINsZT/2MGBlHToxixjGEE2AnbYkS0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bh5eE4AEdv5R6ygOJkEbUGOE1n7GGxtcwyWQ33v7NfmVVJDDt0XiXjDB+rP6omSNz
	 iKBo10k84HzbjZCN4GWXsllGuVh07ERfeJy/9tcbzb3qgoqzLLiQPZ7xNdVxap66Uj
	 8jvLnw/xGieyDhgIkEUygcuyWTEB9XDrMpbp1L3wguR2E/KLAy2KN+6k5k7rOwHoYs
	 FM51HGDvgZ0N3/d+ZgbBe41X+CYp3cb+bPUQAA3ZOpzhd0fTd60Txf6gKnwKWZaR+1
	 50gRcQRilT0nz1Rjpt63x3h4svbyTCED3qDQ+L8VoHOA2YXPkYg4B9oHluv9nrwvp/
	 nwCCzAl96/Oiw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:17 +0100
Subject: [PATCH RFC 03/11] net: pktgen: let procfs copy in commands
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-net-v1-3-982104a4f592@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=12253; i=brauner@kernel.org;
 h=from:subject:message-id; bh=34PmFPP0nUXBNdGZFJGgCKj9cc2ZCkqII5e47ivrIBI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG78yn+X+aTJpbffffrlPbObIUG8a2/j2b8rmS67r
 W36kBK4u6OUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiTzcz/C9RbOSLd7SvTmp3
 nH9n3jwG5lXa3z8mviuvuGig/PuyUjjDb7b+SQuOzrl18epzhQ2Hbjeu6bncfVdw9b+DatWFCdv
 MTjMDAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 86EDEA000F
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: io9n5pxwp6mefzinxu31jmeoycr7w7hf
X-HE-Tag: 1793633509-692252
X-HE-Meta: U2FsdGVkX19NO4fQckHQUAY/wNNPXtNeBP4MfJ9aDGJObG6mr6UIfc1X8etPPdvcJ6rNnNlD4MO4ocQWoMBYYJq37sVWCwf2zPAwPjoCX2Z1joHMxJUcbLmQIHcXMojMbaUDJXUZtUmMtFUKFYKUOhfF6QomTCEQfy/gRYJlkg+OCKyHKKmXnBcXBOA4Sf+Hrzy0F2JiBPvKDawhTILurFBHqKIkUjnPUWWCvFRAmbjWBeNJeq98i8dR0E0pk+UBFGgrDfO6X9KezggiAQpGfxSG0vMFegiKOaH5nMQ8+i81mWS3wot7qhUSFCxt+gSAUrqsIITz3pemZXPxRcbpNUG+YpWhq3JGjBQ/bd2FOE4zEjzeVosLY29a7F8DFJEi7n1SUp4NBKhWxMfrypQkm17vFAjx77hQ8UCyAQ6A0J6QJ92A6nTsZR+RRwKpT/frFSRnfXk9OWq3JO1GvxQyQWmgWjpst0XXBPdiKPV/51Ccunnw+FTq7zN9e4Zzau1ogr+CsJNjqdiJaLRYb9XSp5z3D8kHFz5zMrQs7VYy2FcsDCYLBuQj/+kC4Nic+8/zaRTwuTkIqAzoXHplA/mS6sfbjOgyayf87uBfnCRetOYH2TSPsQ57QMU+x6iXa+OR7MWEW5ujbyTQz23vE069L+yEtE7YYHCQWsO0ghOms/x7L5gP7m9tUJ1ia/1UwM8zY5w+T8s3F6XNhQIY4GBwDGOUf4Di1tLUesWYp+76CAEkkDmtz/gC+8ixgc5pbgTiOM41DdvwN7W0snw84+ohM5Y4sHSRpUkTdQGx2hQMV2jbIQi4UadzU9yjnGScP+WWeb8QGLHHNoboNOUQaxhEvqO5U42FZyhzITXnlLUjEZBLkuBo2JYZsTBpE0GKHNVm5p+9RREv6/Nj0GJq55/czRHNyaZPZYB+faKxwl++il07mC1ivbjxzRznsfSVhCG6KTj+LPtCcHDemAAKDR/
 YPqsQQgw
 WHhldwneVRE9GPLZF4DM3diVeKb4FaoX/3bCFooPPFNc5dys7oWccTUdCbW6dx/VsM3HSTOOC/keurSkOa9ep55QZD4FEtAeaahyBvOgVPeLfd+qOspx+YSq9JCPL1rKcynWhX8LhAJ3m2cBF5NllqIPv77Oh9HXFSutzHhHTCSJWMloffpL3jU+r9GHUYHYmW9Kczlx4YXeyPZHRT4tLRlvo1amMXrgWe8FXDLd8Ycy8nKooV7eHjnTzEXXYWEVxlIIxpbvqWoxwFBQqwNFnrKUYCw/tKSmcmqMV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() for the files in /proc/net/pktgen so
procfs copies in what is written before it pins the entry, and parse
the commands from that copy. The parse helpers read the copy instead of
fetching every character with get_user(). Commands longer than
PAGE_SIZE - 1 bytes fail with -EINVAL now.

With debug on, the dump of the command went through strndup_user() and
failed the write with -EINVAL when there was no NUL right behind the
command in the writer's buffer. The copy is NUL-terminated, so that's
gone.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 net/core/pktgen.c | 128 +++++++++++++++++++-----------------------------------
 1 file changed, 45 insertions(+), 83 deletions(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 12363a373fb8..84f4db86a5b0 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -516,11 +516,9 @@ static int pgctrl_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static ssize_t pgctrl_write(struct file *file, const char __user *buf,
-			    size_t count, loff_t *ppos)
+static ssize_t pgctrl_write(struct file *file, char *buf, size_t count,
+			    loff_t *ppos)
 {
-	char data[128];
-	size_t max;
 	struct pktgen_net *pn = net_generic(current->nsproxy->net_ns, pg_net_id);
 
 	if (!capable(CAP_NET_ADMIN))
@@ -529,20 +527,15 @@ static ssize_t pgctrl_write(struct file *file, const char __user *buf,
 	if (count < 1)
 		return -EINVAL;
 
-	max = min(count, sizeof(data) - 1);
-	if (copy_from_user(data, buf, max))
-		return -EFAULT;
+	/* strip trailing '\n' */
+	if (buf[count - 1] == '\n')
+		buf[count - 1] = 0;
 
-	if (data[max - 1] == '\n')
-		data[max - 1] = 0; /* strip trailing '\n', terminate string */
-	else
-		data[max] = 0; /* terminate string */
-
-	if (!strcmp(data, "stop"))
+	if (!strcmp(buf, "stop"))
 		pktgen_stop_all_threads(pn);
-	else if (!strcmp(data, "start"))
+	else if (!strcmp(buf, "start"))
 		pktgen_run_all_threads(pn);
-	else if (!strcmp(data, "reset"))
+	else if (!strcmp(buf, "reset"))
 		pktgen_reset_all_threads(pn);
 	else
 		return -EINVAL;
@@ -552,7 +545,7 @@ static ssize_t pgctrl_write(struct file *file, const char __user *buf,
 
 static const struct proc_ops pktgen_proc_ops = {
 	.proc_show	= pgctrl_show,
-	.proc_write	= pgctrl_write,
+	.proc_write_buf	= pgctrl_write,
 };
 
 static int pktgen_if_show(struct seq_file *seq, void *v)
@@ -741,7 +734,7 @@ static int pktgen_if_show(struct seq_file *seq, void *v)
 }
 
 
-static ssize_t hex32_arg(const char __user *user_buffer, size_t maxlen,
+static ssize_t hex32_arg(const char *user_buffer, size_t maxlen,
 			 __u32 *num)
 {
 	size_t i = 0;
@@ -752,8 +745,7 @@ static ssize_t hex32_arg(const char __user *user_buffer, size_t maxlen,
 		int value;
 		char c;
 
-		if (get_user(c, &user_buffer[i]))
-			return -EFAULT;
+		c = user_buffer[i];
 		value = hex_to_bin(c);
 		if (value >= 0) {
 			*num <<= 4;
@@ -765,15 +757,14 @@ static ssize_t hex32_arg(const char __user *user_buffer, size_t maxlen,
 	return i;
 }
 
-static ssize_t count_trail_chars(const char __user *user_buffer, size_t maxlen)
+static ssize_t count_trail_chars(const char *user_buffer, size_t maxlen)
 {
 	size_t i;
 
 	for (i = 0; i < maxlen; i++) {
 		char c;
 
-		if (get_user(c, &user_buffer[i]))
-			return -EFAULT;
+		c = user_buffer[i];
 		switch (c) {
 		case '\"':
 		case '\n':
@@ -790,7 +781,7 @@ done:
 	return i;
 }
 
-static ssize_t num_arg(const char __user *user_buffer, size_t maxlen,
+static ssize_t num_arg(const char *user_buffer, size_t maxlen,
 		       unsigned long *num)
 {
 	size_t i;
@@ -799,8 +790,7 @@ static ssize_t num_arg(const char __user *user_buffer, size_t maxlen,
 	for (i = 0; i < maxlen; i++) {
 		char c;
 
-		if (get_user(c, &user_buffer[i]))
-			return -EFAULT;
+		c = user_buffer[i];
 		if ((c >= '0') && (c <= '9')) {
 			*num *= 10;
 			*num += c - '0';
@@ -810,15 +800,14 @@ static ssize_t num_arg(const char __user *user_buffer, size_t maxlen,
 	return i;
 }
 
-static ssize_t strn_len(const char __user *user_buffer, size_t maxlen)
+static ssize_t strn_len(const char *user_buffer, size_t maxlen)
 {
 	size_t i;
 
 	for (i = 0; i < maxlen; i++) {
 		char c;
 
-		if (get_user(c, &user_buffer[i]))
-			return -EFAULT;
+		c = user_buffer[i];
 		switch (c) {
 		case '\"':
 		case '\n':
@@ -840,7 +829,7 @@ done_str:
  * where each entry consists of size and weight delimited by commas.
  * "size1,weight_1 size2,weight_2 ... size_n,weight_n" for example.
  */
-static ssize_t get_imix_entries(const char __user *buffer,
+static ssize_t get_imix_entries(const char *buffer,
 				size_t maxlen,
 				struct pktgen_dev *pkt_dev)
 {
@@ -867,8 +856,7 @@ static ssize_t get_imix_entries(const char __user *buffer,
 		i += len;
 		if (i >= maxlen)
 			return -EINVAL;
-		if (get_user(c, &buffer[i]))
-			return -EFAULT;
+		c = buffer[i];
 		/* Check for comma between size_i and weight_i */
 		if (c != ',')
 			return -EINVAL;
@@ -894,15 +882,14 @@ static ssize_t get_imix_entries(const char __user *buffer,
 
 		if (i >= maxlen)
 			break;
-		if (get_user(c, &buffer[i]))
-			return -EFAULT;
+		c = buffer[i];
 		i++;
 	} while (c == ' ');
 
 	return i;
 }
 
-static ssize_t get_labels(const char __user *buffer,
+static ssize_t get_labels(const char *buffer,
 			  size_t maxlen, struct pktgen_dev *pkt_dev)
 {
 	unsigned int n = 0;
@@ -936,8 +923,7 @@ static ssize_t get_labels(const char __user *buffer,
 		n++;
 		if (i >= maxlen)
 			break;
-		if (get_user(c, &buffer[i]))
-			return -EFAULT;
+		c = buffer[i];
 		i++;
 	} while (c == ',');
 
@@ -974,9 +960,8 @@ static __u32 pktgen_read_flag(const char *f, bool *disable)
 	return 0;
 }
 
-static ssize_t pktgen_if_write(struct file *file,
-			       const char __user *user_buffer, size_t count,
-			       loff_t *offset)
+static ssize_t pktgen_if_write(struct file *file, char *user_buffer,
+			       size_t count, loff_t *offset)
 {
 	struct seq_file *seq = file->private_data;
 	struct pktgen_dev *pkt_dev = seq->private;
@@ -1009,8 +994,7 @@ static ssize_t pktgen_if_write(struct file *file,
 		return len;
 
 	memset(name, 0, sizeof(name));
-	if (copy_from_user(name, &user_buffer[i], len))
-		return -EFAULT;
+	memcpy(name, &user_buffer[i], len);
 	i += len;
 
 	max = count - i;
@@ -1020,16 +1004,9 @@ static ssize_t pktgen_if_write(struct file *file,
 
 	i += len;
 
-	if (debug) {
-		size_t copy = min_t(size_t, count + 1, 1024);
-		char *tp = strndup_user(user_buffer, copy);
-
-		if (IS_ERR(tp))
-			return PTR_ERR(tp);
-
-		pr_debug("%s,%zu  buffer -:%s:-\n", name, count, tp);
-		kfree(tp);
-	}
+	if (debug)
+		pr_debug("%s,%zu  buffer -:%.*s:-\n", name, count,
+			 (int)min_t(size_t, count, 1023), user_buffer);
 
 	if (!strcmp(name, "min_pkt_size")) {
 		max = min(10, count - i);
@@ -1322,8 +1299,7 @@ static ssize_t pktgen_if_write(struct file *file,
 			return len;
 
 		memset(f, 0, sizeof(f));
-		if (copy_from_user(f, &user_buffer[i], len))
-			return -EFAULT;
+		memcpy(f, &user_buffer[i], len);
 
 		if (strcmp(f, "start_xmit") == 0) {
 			pkt_dev->xmit_mode = M_START_XMIT;
@@ -1362,8 +1338,7 @@ static ssize_t pktgen_if_write(struct file *file,
 			return len;
 
 		memset(f, 0, 32);
-		if (copy_from_user(f, &user_buffer[i], len))
-			return -EFAULT;
+		memcpy(f, &user_buffer[i], len);
 
 		flag = pktgen_read_flag(f, &disable);
 		if (flag) {
@@ -1410,8 +1385,7 @@ static ssize_t pktgen_if_write(struct file *file,
 		if (len < 0)
 			return len;
 
-		if (copy_from_user(buf, &user_buffer[i], len))
-			return -EFAULT;
+		memcpy(buf, &user_buffer[i], len);
 		buf[len] = 0;
 		if (strcmp(buf, pkt_dev->dst_min) != 0) {
 			strscpy_pad(pkt_dev->dst_min, buf);
@@ -1430,8 +1404,7 @@ static ssize_t pktgen_if_write(struct file *file,
 		if (len < 0)
 			return len;
 
-		if (copy_from_user(buf, &user_buffer[i], len))
-			return -EFAULT;
+		memcpy(buf, &user_buffer[i], len);
 		buf[len] = 0;
 		if (strcmp(buf, pkt_dev->dst_max) != 0) {
 			strscpy_pad(pkt_dev->dst_max, buf);
@@ -1452,8 +1425,7 @@ static ssize_t pktgen_if_write(struct file *file,
 
 		pkt_dev->flags |= F_IPV6;
 
-		if (copy_from_user(buf, &user_buffer[i], len))
-			return -EFAULT;
+		memcpy(buf, &user_buffer[i], len);
 		buf[len] = 0;
 
 		in6_pton(buf, -1, pkt_dev->in6_daddr.s6_addr, -1, NULL);
@@ -1475,8 +1447,7 @@ static ssize_t pktgen_if_write(struct file *file,
 
 		pkt_dev->flags |= F_IPV6;
 
-		if (copy_from_user(buf, &user_buffer[i], len))
-			return -EFAULT;
+		memcpy(buf, &user_buffer[i], len);
 		buf[len] = 0;
 
 		in6_pton(buf, -1, pkt_dev->min_in6_daddr.s6_addr, -1, NULL);
@@ -1497,8 +1468,7 @@ static ssize_t pktgen_if_write(struct file *file,
 
 		pkt_dev->flags |= F_IPV6;
 
-		if (copy_from_user(buf, &user_buffer[i], len))
-			return -EFAULT;
+		memcpy(buf, &user_buffer[i], len);
 		buf[len] = 0;
 
 		in6_pton(buf, -1, pkt_dev->max_in6_daddr.s6_addr, -1, NULL);
@@ -1518,8 +1488,7 @@ static ssize_t pktgen_if_write(struct file *file,
 
 		pkt_dev->flags |= F_IPV6;
 
-		if (copy_from_user(buf, &user_buffer[i], len))
-			return -EFAULT;
+		memcpy(buf, &user_buffer[i], len);
 		buf[len] = 0;
 
 		in6_pton(buf, -1, pkt_dev->in6_saddr.s6_addr, -1, NULL);
@@ -1539,8 +1508,7 @@ static ssize_t pktgen_if_write(struct file *file,
 		if (len < 0)
 			return len;
 
-		if (copy_from_user(buf, &user_buffer[i], len))
-			return -EFAULT;
+		memcpy(buf, &user_buffer[i], len);
 		buf[len] = 0;
 		if (strcmp(buf, pkt_dev->src_min) != 0) {
 			strscpy_pad(pkt_dev->src_min, buf);
@@ -1559,8 +1527,7 @@ static ssize_t pktgen_if_write(struct file *file,
 		if (len < 0)
 			return len;
 
-		if (copy_from_user(buf, &user_buffer[i], len))
-			return -EFAULT;
+		memcpy(buf, &user_buffer[i], len);
 		buf[len] = 0;
 		if (strcmp(buf, pkt_dev->src_max) != 0) {
 			strscpy_pad(pkt_dev->src_max, buf);
@@ -1580,8 +1547,7 @@ static ssize_t pktgen_if_write(struct file *file,
 			return len;
 
 		memset(valstr, 0, sizeof(valstr));
-		if (copy_from_user(valstr, &user_buffer[i], len))
-			return -EFAULT;
+		memcpy(valstr, &user_buffer[i], len);
 
 		if (!mac_pton(valstr, pkt_dev->dst_mac))
 			return -EINVAL;
@@ -1598,8 +1564,7 @@ static ssize_t pktgen_if_write(struct file *file,
 			return len;
 
 		memset(valstr, 0, sizeof(valstr));
-		if (copy_from_user(valstr, &user_buffer[i], len))
-			return -EFAULT;
+		memcpy(valstr, &user_buffer[i], len);
 
 		if (!mac_pton(valstr, pkt_dev->src_mac))
 			return -EINVAL;
@@ -1864,7 +1829,7 @@ static ssize_t pktgen_if_write(struct file *file,
 
 static const struct proc_ops pktgen_if_proc_ops = {
 	.proc_show	= pktgen_if_show,
-	.proc_write	= pktgen_if_write,
+	.proc_write_buf	= pktgen_if_write,
 };
 
 static int pktgen_thread_show(struct seq_file *seq, void *v)
@@ -1897,8 +1862,7 @@ static int pktgen_thread_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static ssize_t pktgen_thread_write(struct file *file,
-				   const char __user *user_buffer,
+static ssize_t pktgen_thread_write(struct file *file, char *user_buffer,
 				   size_t count, loff_t *offset)
 {
 	struct seq_file *seq = file->private_data;
@@ -1927,8 +1891,7 @@ static ssize_t pktgen_thread_write(struct file *file,
 		return len;
 
 	memset(name, 0, sizeof(name));
-	if (copy_from_user(name, &user_buffer[i], len))
-		return -EFAULT;
+	memcpy(name, &user_buffer[i], len);
 	i += len;
 
 	max = count - i;
@@ -1959,8 +1922,7 @@ static ssize_t pktgen_thread_write(struct file *file,
 			ret = len;
 			goto out;
 		}
-		if (copy_from_user(f, &user_buffer[i], len))
-			return -EFAULT;
+		memcpy(f, &user_buffer[i], len);
 
 		mutex_lock(&pktgen_thread_lock);
 		ret = pktgen_add_device(t, f);
@@ -1996,7 +1958,7 @@ out:
 
 static const struct proc_ops pktgen_thread_proc_ops = {
 	.proc_show	= pktgen_thread_show,
-	.proc_write	= pktgen_thread_write,
+	.proc_write_buf	= pktgen_thread_write,
 };
 
 /* Think find or remove for NN */

-- 
2.53.0


