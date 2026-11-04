Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15D30606D4CF
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jRideeBZ
Received: by kanga.kvack.org (Postfix)
	id 178CA6B05ED; Wed,  4 Nov 2026 14:58:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1296E6B05EE; Wed,  4 Nov 2026 14:58:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F332A6B05EF; Wed,  4 Nov 2026 14:58:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C2D526B05ED
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:58:40 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 555E740843
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:58:40 +0000 (UTC)
X-FDA: 85398499200.25.97FA709
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 95A841A000A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:58:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jRideeBZ;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793822318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FuQ+O9AN/EhfuAINsZT/2MGBlHToxixjGEE2AnbYkS0=;
	b=4IQ+GW+Twa28iPLzzdjfiZFQNeq8/fIOAcEKKrRrzoAXXllAfOiIgCq4YrapsJ/xhcxPdG
	7BsRT9Y4wQYvxvQdBSBWbam25PoA54ipz3pAGaef4GSLe2XN1TIkSQwKci7T1spf9AbiOt
	Ohhzj3SZ4axAis0tL1+iNxTjB6J1F2w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793822318;
	b=GMX/bii0NiJswB3WMUJ0PUJWr7Hq4sWcCgTjWRWT++BzZb7TGWxy6t7NXSqveZEapW550L
	iwlg8/3mBYkhc0KrlKE93wk4YJHm0I0p/lscewgNpWeTXjb4nwS1iArDwlpc2iYLEDw0Sd
	08FaCCIZWFJ/XeOENwc7K26hoxm/kCM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jRideeBZ;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0060860DC3;
	Wed,  4 Nov 2026 19:58:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6AF01F00919;
	Wed,  4 Nov 2026 19:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793822317;
	bh=FuQ+O9AN/EhfuAINsZT/2MGBlHToxixjGEE2AnbYkS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jRideeBZ8oxAXL6268eYmn+YEeTwdfLWgvKXD9/7wD79tZYk7c5DiZCAIV2Ed3bwb
	 YWQRgSD2jU4vVyf5pd6Fp/OwMhqpw0pEzvJNc/5CO814j/jCHWPvNFJybI+doeQwSa
	 OpQ46BOV+iwz4Cx5rb/iLqaBXNAMo8bJbHXV28HpUDKHDG7BprRhrw7b2hrCdF01bg
	 0cpbc+GFBaegbtyEuAbtmzWoxuI04Ywy6El4+84vT4YlXPl9bsTkGJq2uYE28H64ez
	 J2K0AA2qwL6I1M12hoT+BT/5TQUoZqOJ/cF7ZyMjn5hayi7nhzUJF/7Tom+ZjsTxWG
	 7ClukSDqhmK1A==
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
Subject: [PATCH RESEND v2 03/13] net: pktgen: let procfs copy in commands
Date: Wed,  4 Nov 2026 20:58:23 +0100
Message-ID: <20261104-work-procfs-net-v2-3-221e2437fed1@kernel.org>
In-Reply-To: <20261104-work-procfs-net-v2-0-221e2437fed1@kernel.org>
References: <20261104-work-procfs-net-v2-0-221e2437fed1@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=12253; i=brauner@kernel.org; h=from:subject:message-id; bh=34PmFPP0nUXBNdGZFJGgCKj9cc2ZCkqII5e47ivrIBI=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97lPT47g02frChbkrDtYrT9WdJJ3C8at+YczFU1+49 1kz+DMu7ihlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIR0mG/9V9qu0rcn6cWtse rHOy7shiV8/57U/nfTfYwXmrweB/YR3D/ww7HSP/tNTFtY0WB3rKhG32Lfl1cJrxecFOqe05zSv u8QAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: r6chffw91dmgo7gyp56mkmrrhsb7bjic
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 95A841A000A
X-Rspam-User: 
X-HE-Tag: 1793822318-897381
X-HE-Meta: U2FsdGVkX1/oWUYCPL+27R0fg7YM+yLKDB4ToC7Jdno6evex0X1MRbF6x3UIL/u9mpqWOm88abTXOVi8Fee/6kweCL6vIVlkJ0QNhJaUb8mLQo5KW0ANuWQmMLrHmpAac1O+CCbz/YDSVTF3DY73YCPaSMU2TOr1XjvJ9UMe8+qZ0Sx+KPvOcr4HChzsLAoHZt/qPdOrqbqwi5SEZ1k0qy3/jVgRiWGoIBgfxTpqmBwU4uQPmLJCmBNjJQez1P5fG2o3d16wJ8Adaj/zhlgaiuUg7f+96c14eTxEaBcanRnT57xyvwkt1eT9K8P1VFxWkN64STYZWSjKDjlnEgneplcP9GPJ2KLtTeUHkG5ksw/deY+p9EsGhUIEnMs22yNtpFAT6BxFEKIzRpgXej+/U7R3ly3dI+8xobI+8LNQZ8DMcCt/WMyeZfmS4cIAuO4suby5WaB/ofRJO4ciu1bUV1pKl0D2WIp2ZZpXkwaS/n0xsK6JV+2sRPg+oJq1CCDssKRqrplMmu4ljXCQIpc5mnLOI4yAyMXtQeWSi/sC9MdFd2bB20dT+RSa04yg1p9V83C0GZZkKFzM/80CZh8wBkMYTSxl+0GJzAxkHwcRO3aWXqo3JvwCWFZxdj8h98CXqZ4TZz0ICUm7bTdLWRteAJ788iVPVWgfU7XzOITug0wohiX5RvuVlXyMBN9Q6bcej8f+bO47+8F1dvX4u/FO9qIrFS2BNdJ5Db7J3LIGP2pDUeA6dL25ZSx2Hc/m2pNtguxG5+DYWuBH+bg4UThDQfpcRR1dkjqIXv/r8y6mBdw+zjVMn8+40I5P7KPm2bBmwOmXreZylb3LDgFpSwPdGfBuHrMV1WWWMILSlCpv4xmiskDpb8f9BrmIJStx4kCol6HZ5Bscy8cQrydbIeOleQTn0Woa3T8KAZHXa6bmmhT6+GDV6mvGCIkakYfZItlnk4ZLIFUaE16vkeywQE0
 BaT9+gYA
 EPABVQfKFyncpDrp0FdUT/co+R84FTgECKhagNVnGAYy+V5eaO21/SDcwHZjhj0E9d2ZgT0b7valdKev79OY0kBAomTVczq+EBMYYpTVNP4L0EC/xACsLOVfNGUvQpXBzvQ5dMBUzucsX9z4pADvKdG5d89nEX6F31V1IQmEVT6Z+vsz1FigLFtIIJDXvClvObmMMi8wCX+JcTx+BvFc0C9SRI2O7Ie/cTY7gG0BcqWy+NlFNYyvosKyLQASsk4TxdLdibik6BY7JHxOlSY56EhjU+WNikEuTod4isCtafplV3hzkaNR0VpGCP9JohME36YgfCoJarkdN1ItJraPGDiwdh+69vpE0314Pg0cEwTdSPh5skl7V/IUGZSUGLaXhwVxmpt0z+7LfhZtwMnMjXiSoZQ==
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


