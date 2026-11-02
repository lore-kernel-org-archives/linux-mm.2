Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A33E60932B8
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SkwsCH5N
Received: by kanga.kvack.org (Postfix)
	id 76F7B6B05F9; Mon,  2 Nov 2026 10:12:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71FBF6B05FA; Mon,  2 Nov 2026 10:12:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60F116B05FB; Mon,  2 Nov 2026 10:12:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3A8096B05F9
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:12:08 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C69921C17EC
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:12:07 +0000 (UTC)
X-FDA: 85390519494.12.2D5B738
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id E9A2EA0016
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:12:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SkwsCH5N;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ymYBzOXC+1qnPq3+H1dG+MOV1EJ0vnAFrYigKbllIFM=;
	b=HBbmfJHA5hhkYaPpDqbHT2ck/LAUCxAT3GV4QrR7MZj3EObxobDAAH+KF++3RT9waC4SYH
	55KReApPFAbifWJBfhPjB93NoMDImthreGTxDiaqFc9dhpNDQF0U6aImplNU3CJyoR/Y3v
	jL+aXmqgqFCAtAAReAvXcEeNxNHV7dc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SkwsCH5N;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632326;
	b=MAGE1gEQ5pCkHhbGXI1hZVVPd5GcB5x68khuXENarodKBg9HUegvMFI9BRaSCwbKL+ZNiS
	tW/Dm6XsDAvIWmSF8anN6WEUbmJyx3P1ekYSjZp5M9XCmiQ0Fe+AMJ7/9ubo8fx11tkv6z
	F/NIDww0QlgDt8OlsWV895EqUR0R2hY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 489F743DCB;
	Mon,  2 Nov 2026 15:12:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA7A31F00A1A;
	Mon,  2 Nov 2026 15:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632325;
	bh=ymYBzOXC+1qnPq3+H1dG+MOV1EJ0vnAFrYigKbllIFM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SkwsCH5NX6Vwuc8YrkplsbXUYGZlDfQ9CBIwHzcNKyVojyOkIh1miTD756wE+V94K
	 qbWnPBCFoEsk5Vnl3IISVP4GtRJh7t/+O5UXryDxT4dLTsrhtBDQtWOzMD+XlPQhS1
	 5THCVq9/EcREtyMc1/N5VSwvG3Q1CrUodeGrQPLGHFNfVpmv58FNgX24+XU26JY7OW
	 sUsvQbz2VbjL7MwP3kVNJQ4yIC+/SktiBLhGC+6TRx0O6yviVfRR7mxZOD/Hx4nWfU
	 5GaDkAcE0fW19SSj+Gk/9Y8llQ2bd+zIEgssZ8CrEgkZbej1DhvNKvROVGhxK2nbP0
	 DIw+cl37jf3tQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:13 +0100
Subject: [PATCH RFC 06/23] md: let procfs own the seq_file of /proc/mdstat
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-drivers-v1-6-a994bd4d3b1a@kernel.org>
References: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
In-Reply-To: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1303; i=brauner@kernel.org;
 h=from:subject:message-id; bh=98AwGD4IED7vI5/KgxxfmkGNQYsM7jyTpJ1BeJQdwqI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG5wa9eb9mvKGcqFdjwLmF1n7FyoUu4/zTbeKoP9V
 5jBq1ePOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACbyaQLD//zX1pfyeqN/TEhI
 Ob3+1Rm/J2p79l/hyunq2m7Kda/Ix4uRoXfzjTPHbDmCeqqTG/in+s5mk9vmK2YguPrLjge1T+z
 2swMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E9A2EA0016
X-Stat-Signature: 4h3dfnkyrcjy3b79m1dsiw8aebq7ch8e
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793632325-628431
X-HE-Meta: U2FsdGVkX1/8LrEaHMVEsPEcLRdPVDw4t1Zc751nJR7heYWX6rtpwcs677tvvDTGcienii2IeXgom9/uPBh0Fsrqq1ID9Bhq5DXRDsKI67lZcKyHV+IPjAJ4kgy27vfMlkTZ4rwjCgye7YvN93s7A0n6d1zYlJIsiBu2r1uZSAYqIBELQ8L0to6znqtji5TWkSwNJCWQ1qVsXvRTgWybmJ6SsNEi2c8e3aGCRhHjGAjOkCvAR5SOzptnYah1jHqLCGv4MR/FyH965nM7N0kzkk/FHQUMIfCvsWnKRD38RLWWlse+NjQqTyUM7NeLbxo/TrV31KJs2RrKun1+hdXbI3vj+dOkBgGfERVGfE+E2Ba0YeOdloIR5NMOe57Okuc1rEjPgXHIvaCXVO4PChfUNaNQzeBadIsibCoeI8CkEBFPUn1RBwipofN9P/rqKhdONjDeAjjbSdVvkPdvfm7aLK6Qeza1gVeX+gJH8kN5ZwrcmTuPz2H/vMw5+dTgWQk0kYYAvlCkK/+1ltSzoJ5Phqb2spQcMMHhFdRX6JD5B7vzD898WgFJ16nT4lDtVl1TboPYa7AfoC+dAb2OOVgIMXBKo5KjbvEfRMiUNNgExpIfVcgzm3M2TrfHT33m5si0AQ4FelsNS7zIO8hQrqKXWMiAp+XxHll+Wl+2xCQJ9Byv1L2mFqsqAqJqFLXEkyT+iuA4zClUwn8cNX8yRb28DDs+TSJBC2tVeUuLGY7VnwQamMW1HZAg9IyM6pjqyyAULJ5KUwPbJ34JRCA9JLIEc1OtqylpMSpI1El4kRWwFBF15PGo/gkeKGRLo2ZJIyvzjcnJbh9x744ivzlmk0VCJHkdGDAUIjaBp40zazknqxMxawolU6O3AVWJdBVmjZLzcmpX/SYChSCjAAHZaJjXDMcFgTCbetpcv+m/1kCllMc327WqgoAbn1Ad1tub0DvOcFfpziEhV/JAHWkRga/
 aVPITbZY
 e7ncXCeMr6Z3EB6aS4gk6xOQossNXSlw0WQEm+f5HsWTbtUGuwfhSuDHFbXAq/YKfBn8GZ6jj5+JB6UXqdizKhQlDY8lfo2xC6e0II2hnJmBb1fjIpRy0qOqLOgcf6PcrL1KDt7KK/ZjntBuBO+4oMWhja/9otYDsUTJIZOK4RG7fC3p36b8dGDrLrqB82piykwMztpc7M6XfywCFY7kXjDnZZSnjKDrxSwsVfIzV62K7F+34QmzYhnSv+QZpJdK5M2OoX7sLmb2wjs9PTvEuLLuBagv7uqSuTXynCIjGAFNOG8KbabgAH3yiH7UppmqdCOiImqHgBMBOg1Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Declare the seq_operations and let procfs open and free the seq_file.
->proc_open() only records the event count for ->proc_poll() now.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/md/md.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 680b34a63cb3..e642b763ebc2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9141,18 +9141,13 @@ static const struct seq_operations md_seq_ops = {
 	.show   = md_seq_show,
 };
 
+/* procfs opens the seq_file */
 static int md_seq_open(struct inode *inode, struct file *file)
 {
-	struct seq_file *seq;
-	int error;
-
-	error = seq_open(file, &md_seq_ops);
-	if (error)
-		return error;
+	struct seq_file *seq = file->private_data;
 
-	seq = file->private_data;
 	seq->poll_event = atomic_read(&md_event_count);
-	return error;
+	return 0;
 }
 
 static int md_unloading;
@@ -9174,10 +9169,8 @@ static __poll_t mdstat_poll(struct file *filp, poll_table *wait)
 }
 
 static const struct proc_ops mdstat_proc_ops = {
+	.proc_seq_ops	= &md_seq_ops,
 	.proc_open	= md_seq_open,
-	.proc_read	= seq_read,
-	.proc_lseek	= seq_lseek,
-	.proc_release	= seq_release,
 	.proc_poll	= mdstat_poll,
 };
 

-- 
2.53.0


