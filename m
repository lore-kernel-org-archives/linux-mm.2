Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3AAE60C15BC
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BN1DryDe
Received: by kanga.kvack.org (Postfix)
	id 229636B05ED; Mon,  2 Nov 2026 10:20:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B2456B0616; Mon,  2 Nov 2026 10:20:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A1E46B0617; Mon,  2 Nov 2026 10:20:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E30606B05ED
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:20:32 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 76E4614018D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:20:32 +0000 (UTC)
X-FDA: 85390540704.24.8E93122
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8247A140009
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:20:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BN1DryDe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yfb68sR2lkv/WstwrNi2kV1cVJpZCk5/QcENUoLv//k=;
	b=1HuIiXB7DsIUqvyxZacxvKfiO5lPpQbqK+0qxBWa3BJLqRQUehlknPaiMHwLtVaPNKGlHw
	JucWejRKomiIh//VjSPxvPXMOqabg5x6F2ocdTFTxmxDEBINiu8NoH/MO9TKLiV/iL393N
	U+SYvBWl+A7CWgnjqZJIQyj8cXXNk5w=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BN1DryDe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632830;
	b=U5BqmwfQaRvQ1gWS+EmWGsnW6Q49saoPy7FBpF3jsMeP95PcFY1Bv+LHRx50zw68xru/38
	5rfiLUVlpn3i/2q53R0uprpqc25P8xVKYlOqPEJL7b+57EoRt4+fngId1DeW6bNRWc+MNN
	x0y+TRNAodWEzsxCkPwPwsqNV4LbPBU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B99B842462;
	Mon,  2 Nov 2026 15:20:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D70991F00A18;
	Mon,  2 Nov 2026 15:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632829;
	bh=yfb68sR2lkv/WstwrNi2kV1cVJpZCk5/QcENUoLv//k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BN1DryDe3qV+C4aWHJuIRcQk7/grenL2yY2/u1V9RuZ76eccMjBgLsEcUTNnhaGbx
	 eXhhwX7Vgu+zR+JmG/2wvin1dOiYZvsWSYg6kfl1F4CTtJJewyZhllNVl1QPSHankI
	 Y/8n3DCOX6o11uevej4+0kaVGNpGzwrrLFwkHxO8Xf20op7zpFONM4MND0dOsyrGS9
	 lt+VjVHm27V5kG1yhzDMUWKDR0YRqKdDimg5wHtncjttH7DdkNFA88vxAFcS8nd5HC
	 WE2enuopE0QMfUuIQi9FBTnJNj/5vBq/jOfhCbxPWlMeXV21MywGi2MtjhSPk+gxJF
	 /V1HSYuIItaBw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:13 +0100
Subject: [PATCH RFC 03/27] lockd: let procfs copy in writes to
 nlm_end_grace
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-fs-v1-3-d09a996317b3@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1756; i=brauner@kernel.org;
 h=from:subject:message-id; bh=yoBjzpwXPCFL2mmsMcO6fDyZh19yBZX5M0Ko6zu/SW0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG4otvP03RvTPvA6+q/2CHm77dh8jlWRxmva3p208
 Ze+9//u4Y5SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJzFzD8JNRYNGmuUuv5fXJ
 SixnOtLlrT9xxidJDp7+ycnCGRxRXQ8Z/qlce21cuoK5yfPMxbQIy6ar6sn9zobuoRNUY3eHqBs
 eYwQA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8247A140009
X-Stat-Signature: casq1z39hhuyc8yho9uyi5u4s9oinb64
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793632830-970199
X-HE-Meta: U2FsdGVkX1/qoKR0rGwLz4d9R6n3ETKmAjlvdkdIfFUa6eafDMM+Q4oaQ0PCcheQ+iRhAawIvjVem+AMv5+MhhzqKG0lCxTlKRzKLAFYobZ0+J3nw1UOjG0QqvOo6YO91QvwTXvKNelowdW+aeZoFXbRWJ7fSk9r+IVeknOhN9F5TZ/MWvPtKXS7RS3G9lVgFhh2y1igdiMMeJuFNB+bvsB4MmPnyt+WUZuDuM6Ac+eFU4M9zpxO1G6Vu/6lkjf0ps8TLGDdyvnccWFAibdJRHb56KqehnEbZHgXMl5E3Y2gE6xo423Cj7AllB3jvkuUL4avoryh0yumAR5+uwHNSVJgrHtHMWhsUXma2OllykXKs8Dvvgp19rRPCRykZBRRw6nACio4zE0cqruManuQIYvczfof5Ee08Z9eiNICzdjzorGykOZ8Rlq45LzqrIgFQaJdhApLTYNmoiWn64PrLcMJNPpl/wGfqdVjG1L9tbI6UAT2fSZjLzGKDIhyiuQJoFrF/wPP37ltmTaMmCQmsc37oJSd9VL2p5EAYwrSrxBYlY021qFWSU/SUzGW7D0i6cB0rIV3yqrw4MkFW9HEQ/GWARTpC2uduFpCJQI7WJ309YDOxUuBKV24CwnojOzvY8MAiUIipvuWtmsNoEn5mRBHQjJLeJ5zvkH05HdhaVxoXbwRs+j/bE9G568ZY7oxNKY/jiBX4SwKbSZdL6Qi0hCOMsxyxfwAc8m1XtYo2YrLCpE+AOyYzp6XXTuccdtVrIsFEElkFNIekuqN/zOnMHZqwV8cCTx9t4vUXSNnQhebyQnmE2MKuVNnNZ3iShk6WvgEZoLfgUWjZFXo7vzc+rMYcxncz8s3fjH2JWoriOU/EXpw0WKz1gQ2J3OKxie85XxH9qLX8Oz4yFNyAQNXwQIWyMGiRfEdapTClcuHPV2zAIASQkMZ/J4lMC9fyav0Q7eSE5rUin7X0zun1S2
 higT+BVd
 wuEG38BfNBpv1IvP3NuEbyYpKjh7S2W4Qt19tfKeKIEM0BUnfic1VOX9VDG1LXT29qsgSiKxt0FxfQvcfztwNQo3xBW+F9WFai6VNnXX6NTEmI+ekJXV+qwJOJLHwleR5MHr4xe4KMBEwOpOq9jTJ3Ps5gHbbFt5Jj5o8tKgCbZK+Bog56j/WzIWgUaxdW0kWFAmGALYy5KYhOZZWFoUuYPvmJH+X748VuTBu/AvXOYZ5rY8xGHq6RUNJyy3nWMEJ9xDQGhNLGsCW+aBQswOJohy6pvowBKs7FoImVe9U6w1XTI4jB1PBTPbKMt73di1MW51K/29d0jE8tpA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() so procfs copies in what is written before
it pins the entry. simple_transaction_get() was only used to get a copy
of what was written, so look at procfs' copy instead and drop the
transaction. A second write to the same file doesn't fail with -EBUSY
anymore. Writes larger than PAGE_SIZE - 1 bytes fail with -EINVAL from
procfs instead of -EFBIG from simple_transaction_get(), which refused a
few bytes less.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/lockd/procfs.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/fs/lockd/procfs.c b/fs/lockd/procfs.c
index a01f08c8c2f3..47949bec7a09 100644
--- a/fs/lockd/procfs.c
+++ b/fs/lockd/procfs.c
@@ -18,21 +18,15 @@
  * We only allow strings that start with 'Y', 'y', or '1'.
  */
 static ssize_t
-nlm_end_grace_write(struct file *file, const char __user *buf, size_t size,
-		    loff_t *pos)
+nlm_end_grace_write(struct file *file, char *buf, size_t size, loff_t *pos)
 {
-	char *data;
 	struct lockd_net *ln = net_generic(current->nsproxy->net_ns,
 					   lockd_net_id);
 
 	if (size < 1)
 		return -EINVAL;
 
-	data = simple_transaction_get(file, buf, size);
-	if (IS_ERR(data))
-		return PTR_ERR(data);
-
-	switch(data[0]) {
+	switch(buf[0]) {
 	case 'Y':
 	case 'y':
 	case '1':
@@ -61,10 +55,9 @@ nlm_end_grace_read(struct file *file, char __user *buf, size_t size,
 }
 
 static const struct proc_ops lockd_end_grace_proc_ops = {
-	.proc_write	= nlm_end_grace_write,
+	.proc_write_buf	= nlm_end_grace_write,
 	.proc_read	= nlm_end_grace_read,
 	.proc_lseek	= default_llseek,
-	.proc_release	= simple_transaction_release,
 };
 
 int __init

-- 
2.53.0


