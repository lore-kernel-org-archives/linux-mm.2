Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B06F96072659
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 21:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gICWh0N0
Received: by kanga.kvack.org (Postfix)
	id 95F696B05BB; Wed,  4 Nov 2026 16:14:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 935BC6B05BC; Wed,  4 Nov 2026 16:14:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84D196B05BD; Wed,  4 Nov 2026 16:14:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 525DA6B05BB
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:14:23 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B3178120716
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:14:22 +0000 (UTC)
X-FDA: 85398689964.25.FAEC64F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id E2EB140010
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:14:20 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gICWh0N0;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793826860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ulWAa08tPZnJZAAMojZfgqs4wxYXZkHD77FK42yiGkc=;
	b=npVJvYTjsyFlQlQNqr40//2jvGg/59TSvvX/iuCz+A4NraFybJNCWCNRbE84gJl+kvYaax
	r9dGPPDX34Hk4kek5e2fiEirmjklzgGtvf+lp0uZj63Af1/2ZiJYcgQIcSBmIpPn/0lEBB
	RQ5wAPCzSWlwl6ORWytJOoH0QTCY9Gk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gICWh0N0;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793826860;
	b=DjbC0HKLQyCCTgwoa86UVxvazscPqjBqqeJfUKUC858AYfmHwd0FhYz4XALEBISJD4lpsk
	cYUNAs22BImM2GCgtcLQ9dK9tJ7xpQ7yilKLan9mtZF9cOBdQ9i2znTIBV9RWaP/FfT83E
	rTJhcNIbUaRV9kmC05n/icWLlc5p4Zo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7B94A63CC2;
	Wed,  4 Nov 2026 21:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A466B1F00919;
	Wed,  4 Nov 2026 21:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793826860;
	bh=ulWAa08tPZnJZAAMojZfgqs4wxYXZkHD77FK42yiGkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gICWh0N0cBEP36qoPjK07EDc0Aojrv63Cx+pq3ht7lC1Swqoe5+i3NPMXMP1HLqAh
	 aYFDImUWgb2oQZfvZy0Eomed2z9bppjTMLZJqaCJ+P/lVF/sMbBDXyuQTYMAX6jaEG
	 PZ2WLVcqSv9VuBvnWcTH3x8qTM6W0XC/ec65sI7vf6cdAdfTZxwUHxtQYl9brUxiQ+
	 dMCuHf59LCoq+BPf/+eWD45uHwN16HzFpn4iF3C3dDC4Tki7Nt0/cDmwKsfuapAQM6
	 WJY+xD/1Nj4i6s+oj2j1TqT1hys8Qp60ucvc7zwo51H/qzcJ2edAoUx8uzmvP8dUPB
	 VqHIpYrdBBhDw==
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
Subject: [PATCH RESEND v2 12/13] samples/kfifo: let procfs copy out reads
Date: Wed,  4 Nov 2026 22:14:06 +0100
Message-ID: <20261104-work-procfs-net-v2-12-221e2437fed1@kernel.org>
In-Reply-To: <20261104-work-procfs-net-v2-0-221e2437fed1@kernel.org>
References: <20261104-work-procfs-net-v2-0-221e2437fed1@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3702; i=brauner@kernel.org; h=from:subject:message-id; bh=20rJkgesQhfyVvX+iP+2cn2t9uRQnDiG02PYUBwi/V4=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97jPsktFdvOpVs6nmzzyvU+U6ZXtuXBM8rzljz9wMw 1nV1yaYdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExkmR4jw4orl8X8M5o+3ma9 GfZdRD43+XLkoesF4WpvMhbuurvzRQEjw6V1dx4JZH/R15uYuWfHNB9+M1aVOLPGyMglXg065jc nMgIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: du7ew9n1aj3uctm6wxw6j3o3wuf335hh
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: E2EB140010
X-HE-Tag: 1793826860-9299
X-HE-Meta: U2FsdGVkX18yF39r+GLLDL+IFMpnFDtGLAT2lVcl+0c+uMtxkTt3lXIku3oI++YSYBfPtTkh6RlLtu1Zg+QtDOoJoIU0AEfYXprJNum5WGM3AVFFhYFHlY0ASf1lZ8E6LrKfqHaNtIIcH0Dnl8OhRHLWKCphPtnvb1TD1FRfqSAzvCs6E6xjQQNVQBf09MLpKNvX4GxqtbaL29BnfIMcjJYaJtB2ut5ho6hpQSwev+D2YsqzZXYia3P3sdp3urEQNrq+dR7ELssx5uwUzTgzr7wnI14+XB2Z1xmB6o4SwqS/NEF+eKNjyIrJnd/vPkb/ve+LpPqxHfONsthw2ozMstJGI9+XmYGo0kZOkLRvBDzN/zcYA6VlkZPk15LaOAxCGUfjuXk1MDyE2AoibYPpXxnMRk09x0Pgdq44U4wT/PJUGXkxmk7qSdn9o8VqG6Y74Z9w1CxJZ2/dHNgIzVusSSv2UyUtssAdG3Z//DP9snLY7pYjIdVAvqLwgCesk3UZ32x5FXOddqiAbbZuMSnTUJHp461izCpPPYdqQmTVWq59sBpQPGEO3cBUFuUJUJBwqT/kcX4s1Jp12n2uQhYlyYzsdhxbJB1yJOxc22SexvTyVzgo5A5XL1GQ/IHt9C7FJ8r42zOiICsEb2UpKs6vHfRA7G3eYaFPsMod2vq5dPv9wy2yOFCgvZnbs+9Id1Lph+MlrP0wfFoE9repI9FJ6qOj8EQyRVkmRMybqz7o2GFMZo1yR/DeBsuQWnjOjVtl8ZSYs5gdxVR3aKfY9qe8c/DFMmYSV5QXR6YE5mQXqeze0+ImL5iWsQ/5kTTyYI97yhceCYt7+ZBzGeRED3vTouWiHg6NqpgaOM3yRF2ajClYZnsH0WNU3G0n1Xd5F1uo0RzaSby/JP7w0U22UEi3k3uEXOvcEl6Xtda3VcrKN/jZPys1WY7FZC4erOQDF1ytJQGkgMjvTJcbKg8NrR9
 u4X3iBW8
 3cDRPCwQNccuBvTkGEpzmNPxW7DQRzant8F/+LYcHe3TNjSMfhfhIWEV0lfTiBo56BTXmkEb1lX+3wh5juiWNcLxVM2JfyHNQNwAaswF9tTxUSAdDGPijp6nEBEOnujCFfeGgB9EmzEfsOdWColGvSqoOY8Dt4O4SGu9JCSi3K3KIPNBggmz86XzKNzRzo7J3cKe4d4K+BWUrAcZmkFLm1OTy9dhO7VVBLt74PLmSyIPoCkWntNjuYXPi/io9SX7mRI/HzRWmT3YrO9Ny0GSyRoqmak0YPY7gEyy6iWhE0+Tx6V72YOkNPPYuejjRZjckr8+U5P4oVfW2T0wIVWgOn5qbCRA0WJP3Ypmoow2piTd8+8ZlJ4TsVZIbfziA7DAr6QqwtKJD0YmMwypVTEo6Wn0K7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_read_buf() so procfs copies what is read to userspace
after it unpinned the entry, and take the data out of the fifo with
kfifo_out() instead of kfifo_to_user(). A reader that passes a bad
buffer loses what was taken out for it now, kfifo_to_user() left that in
the fifo. The samples can be spliced now too, and a sendfile() from them
into a target that fails or takes less than was read drops what was
taken out in between, like for the rtas error log.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 samples/kfifo/bytestream-example.c |  9 +++------
 samples/kfifo/inttype-example.c    | 10 ++++------
 samples/kfifo/record-example.c     |  9 +++------
 3 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/samples/kfifo/bytestream-example.c b/samples/kfifo/bytestream-example.c
index 8c58fb46a2bf..214e46a64cc1 100644
--- a/samples/kfifo/bytestream-example.c
+++ b/samples/kfifo/bytestream-example.c
@@ -125,26 +125,23 @@ static ssize_t fifo_write(struct file *file, char *buf,
 	return copied;
 }
 
-static ssize_t fifo_read(struct file *file, char __user *buf,
+static ssize_t fifo_read(struct file *file, char *buf,
 						size_t count, loff_t *ppos)
 {
-	int ret;
 	unsigned int copied;
 
 	if (mutex_lock_interruptible(&read_access))
 		return -ERESTARTSYS;
 
-	ret = kfifo_to_user(&test, buf, count, &copied);
+	copied = kfifo_out(&test, buf, count);
 
 	mutex_unlock(&read_access);
-	if (ret)
-		return ret;
 
 	return copied;
 }
 
 static const struct proc_ops fifo_proc_ops = {
-	.proc_read	= fifo_read,
+	.proc_read_buf	= fifo_read,
 	.proc_write_buf	= fifo_write,
 	.proc_lseek	= noop_llseek,
 };
diff --git a/samples/kfifo/inttype-example.c b/samples/kfifo/inttype-example.c
index c5d16b815e73..8384d7f8de6c 100644
--- a/samples/kfifo/inttype-example.c
+++ b/samples/kfifo/inttype-example.c
@@ -119,26 +119,24 @@ static ssize_t fifo_write(struct file *file, char *buf,
 	return copied;
 }
 
-static ssize_t fifo_read(struct file *file, char __user *buf,
+static ssize_t fifo_read(struct file *file, char *buf,
 						size_t count, loff_t *ppos)
 {
-	int ret;
 	unsigned int copied;
 
 	if (mutex_lock_interruptible(&read_access))
 		return -ERESTARTSYS;
 
-	ret = kfifo_to_user(&test, buf, count, &copied);
+	copied = kfifo_out(&test, (int *)buf, count / sizeof(int)) *
+		 sizeof(int);
 
 	mutex_unlock(&read_access);
-	if (ret)
-		return ret;
 
 	return copied;
 }
 
 static const struct proc_ops fifo_proc_ops = {
-	.proc_read	= fifo_read,
+	.proc_read_buf	= fifo_read,
 	.proc_write_buf	= fifo_write,
 	.proc_lseek	= noop_llseek,
 };
diff --git a/samples/kfifo/record-example.c b/samples/kfifo/record-example.c
index dcc749247c64..29d08e90a63d 100644
--- a/samples/kfifo/record-example.c
+++ b/samples/kfifo/record-example.c
@@ -132,26 +132,23 @@ static ssize_t fifo_write(struct file *file, char *buf,
 	return copied;
 }
 
-static ssize_t fifo_read(struct file *file, char __user *buf,
+static ssize_t fifo_read(struct file *file, char *buf,
 						size_t count, loff_t *ppos)
 {
-	int ret;
 	unsigned int copied;
 
 	if (mutex_lock_interruptible(&read_access))
 		return -ERESTARTSYS;
 
-	ret = kfifo_to_user(&test, buf, count, &copied);
+	copied = kfifo_out(&test, buf, count);
 
 	mutex_unlock(&read_access);
-	if (ret)
-		return ret;
 
 	return copied;
 }
 
 static const struct proc_ops fifo_proc_ops = {
-	.proc_read	= fifo_read,
+	.proc_read_buf	= fifo_read,
 	.proc_write_buf	= fifo_write,
 	.proc_lseek	= noop_llseek,
 	/* kfifo_from_user() cut a record to what its length byte holds */

-- 
2.53.0


