Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2CE160716DB
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kxAPIiB8
Received: by kanga.kvack.org (Postfix)
	id 124FC6B0602; Mon,  2 Nov 2026 10:27:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FD356B0604; Mon,  2 Nov 2026 10:27:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 011D56B0605; Mon,  2 Nov 2026 10:27:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D04296B0602
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:27:17 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6A42AC014B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:27:17 +0000 (UTC)
X-FDA: 85390557714.13.8E78610
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id A84CD40009
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:27:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kxAPIiB8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XTKgYPXjwGtd+Y2GluPCJ0QXSAilsjtjyt0vuaHdwds=;
	b=maCwJiq3rjjtQgnczCM9MM27JWAcwlCQcQglshbEZrZM56KRNBQw0E/lQelxgh3Z2Dg0q5
	D/TsUSizjZkiYcz5YNB1kVwRGM3C0LHc0q/XADJg2uy9s6l7q61LyTBHaCVtLI8vYe/nco
	UOtAepiJF2kIbh4UBjmOw5yw25/VuaQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kxAPIiB8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633235;
	b=ZPqqR+3UrtUsYCzFYBPmqDWUF7x99ESY3kAaI6oo2iddKSmOOkaJwu5K9i8MphAu7vT1a7
	GwvHxPQbPFy0YcPDFiSD74AKLmA3QwNlhuBXrm4epo/oiR11ZB9l6FwYqUZhhG/M7oFKtb
	MBMN2RujkWs0z1lDZwAr5TcAXywy/tI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2DF5A605CA;
	Mon,  2 Nov 2026 15:27:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497371F00A16;
	Mon,  2 Nov 2026 15:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633234;
	bh=XTKgYPXjwGtd+Y2GluPCJ0QXSAilsjtjyt0vuaHdwds=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kxAPIiB8bZX2oCCzHcBO+Z+9M3+BVX1rvIx7nyXXRvMDmlNh8VaOR2aKmZd2R34hH
	 Gw7+HXTv7VzusgWsZ9GsA33MUpaeH7qM1+3/U0mI5dpdOtBvO7SVe8UgtTS9zRl74w
	 zVpSeL4wIOUBkjK4em3j/1wqw6UAi3uG8FIvW3rat4+P86CWAWdzAlWUQvV7vMVEpa
	 S38kzwkwiuMhgYyorFO1fD6ITanbo/Z9kHp1r8cLKvafivXAqupn5zK/psHYFqdIdf
	 /8feMEEXHbH1Vr1KKZJEdv5qVbaXwV5kRtN7tZQOORDjsgRAwj5Ih1oUQUGUkibHAd
	 /P9IyT6izArUA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:31 +0100
Subject: [PATCH RFC 21/27] dyndbg: let procfs copy in writes to
 /proc/dynamic_debug/control
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-fs-v1-21-d09a996317b3@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2226; i=brauner@kernel.org;
 h=from:subject:message-id; bh=DMKbMmltc6KGAMcxoyJUHD9hv4JrUkNBMnfQsx/+9Q8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG7ceqHmw/8zQZt7jtfybdlxWv7H8x3cq8MvN69Km
 /uTde1Zq45SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJONky/M//M+f6NIdFl39X
 +W2ZGKtX/Hnx0w8TwmWPzuNxWv/xS38Hw1/hO5kJ4eWe3065F7wIPZknI/zsrm6z8qW9zQ0q7Vs
 0K5gA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A84CD40009
X-Stat-Signature: os8z9dj5ys1fqjqete5ednfjrrsbrg85
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793633235-155473
X-HE-Meta: U2FsdGVkX183RjcqZdKnroWhHfmuBXflxO54fPMHOpu+uaiPar6uZyka4PStewQptHU7mkatkcIFaPvkSGJm2i5lt29Is1SwM/ef9R7WtV95nX244/DYokuEd1A1Jz7wslHOo+HzKDqEqd/M4TMGakHgI2bQZ+sGFwXiZcKEiJ68Qh7tqZhBfkThRsDSppjYCqq/CGD9goIROEBYMlbGHOU71yK30xCNt7aYq0afq+t8HlAqwhK9PULTJMjS6J/XYV7Qzm+A82RM1Du6jae/wz3E8g6w7NldMWIbv+FTFVOLKJJ033TBpJlKNbbHArXey9nn/U7vyfyePwWSJo3LzBhp1tfrSWn+49phcHhqzhlq/c0dQn+bpI7MlZEmAXb1kbl/b1LySFV8kl0jY8awK54AUiHtrV/M8LTGfLdMFJ7qvje3pYNZONxnturHrbzQB2PzVK+jPtgsERTcRhGVZ5ZZUj4MhrNM6UfIJSccGY9XlVojlb5XOlpX3yPnNJiIVy86RzTHqcYYycy6N7kwCrDCerIp9eelXAYNo6rbFy8uWNGHCQwNZqDRRyrjgpusxJ3rF0mS2o84hEuqi1eSXDerEFfDlDUtrZPihDvNb0nGrlQTXvCiL0ADZ+ch3eY1r7LJ1s8l3rgbXCR0Aw1TJollrT8oWSW/j+hkko9n48AhSZsfU9pJ331UAhrpXq/P+cbs9+B/ayyFaQRYYozww7W0aB/rOFI1AAAT2nN4f3Jt5MemMsof3KfZqxWpOL1ytcg8zfEg8FqS0krx//XC/gvxcLFs54VYJveiCLXmGKoK9P8K8AFr6ql9V2AbMTDpY8UkMnzlVNvWkyWzDbDUYMUpxkeAgvzkKmmfzRrXx8KS/b7IwomGOnjZIGL7Zid3whTRXI19LSuOH2SsBZRLucJ+x7U9MtKZxnIbwuhM9ZCNRjE6rdzmItPeFCfnohTv5dUSR29rHlY7+aUit+s
 BSjKyXlZ
 tizrLh5SfH5X9HmuOv2UeL58dNsabsaZgowVSa1zjrzY+87yW2dZEOW9156aFU9AfkK3BtejdbHxuLhtNlT9YLf/zfHx32zg7jad9PQ05I7pmtCVtPQlt23ZofFoACtn0wGQXAhlJz0g/Q3OL0lvfJlv6k7foteFoll0hhOJhVE2kCPeV6TgM5VWUOrWzseZCLQ0Nlk4vWK/W9eN1CplHfl/dng8iGx0nGyZXpc1BR7ggtBsZFsrC3Kk6SgKFNtcPUVq4vJiVoLWm3VfEewUVOHdNSmYCgJg+CKmCaJq6pxeKfnXb0fo/uBzQFGlYQxCrw3qU2JiWnre3WDU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Move the parsing into ddebug_proc_write_buf() and implement
->proc_write_buf() with it so procfs copies in what is written before
it pins the entry. The debugfs file keeps copying in itself. Writes
larger than USER_BUF_PAGE - 1 bytes to the procfs file now fail with
-EINVAL from procfs instead of -E2BIG.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 lib/dynamic_debug.c | 34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 64a211290872..1d6012c9eb41 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -1002,11 +1002,28 @@ __setup("dyndbg=", dyndbg_setup);
  * command text from userspace, parses and executes it.
  */
 #define USER_BUF_PAGE 4096
+
+static ssize_t ddebug_proc_write_buf(struct file *file, char *buf, size_t len,
+				     loff_t *offp)
+{
+	int ret;
+
+	if (len == 0)
+		return 0;
+	v2pr_info("read %zu bytes from userspace\n", len);
+
+	ret = ddebug_exec_queries(buf, NULL);
+	if (ret < 0)
+		return ret;
+
+	*offp += len;
+	return len;
+}
+
 static ssize_t ddebug_proc_write(struct file *file, const char __user *ubuf,
 				  size_t len, loff_t *offp)
 {
-	char *tmpbuf;
-	int ret;
+	char *tmpbuf __free(kfree) = NULL;
 
 	if (len == 0)
 		return 0;
@@ -1017,15 +1034,7 @@ static ssize_t ddebug_proc_write(struct file *file, const char __user *ubuf,
 	tmpbuf = memdup_user_nul(ubuf, len);
 	if (IS_ERR(tmpbuf))
 		return PTR_ERR(tmpbuf);
-	v2pr_info("read %zu bytes from userspace\n", len);
-
-	ret = ddebug_exec_queries(tmpbuf, NULL);
-	kfree(tmpbuf);
-	if (ret < 0)
-		return ret;
-
-	*offp += len;
-	return len;
+	return ddebug_proc_write_buf(file, tmpbuf, len, offp);
 }
 
 /*
@@ -1196,7 +1205,8 @@ static const struct file_operations ddebug_proc_fops = {
 static const struct proc_ops proc_fops = {
 	.proc_seq_ops = &ddebug_proc_seqops,
 	.proc_state_size = sizeof(struct ddebug_iter),
-	.proc_write = ddebug_proc_write
+	.proc_write_buf = ddebug_proc_write_buf,
+	.proc_write_size = USER_BUF_PAGE - 1,
 };
 
 static void ddebug_attach_module_classes(struct ddebug_table *dt,

-- 
2.53.0


