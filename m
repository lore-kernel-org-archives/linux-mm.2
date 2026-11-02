Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6E88606CED3
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IJsS4rxO
Received: by kanga.kvack.org (Postfix)
	id 173E16B05DA; Mon,  2 Nov 2026 10:08:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14C256B05DE; Mon,  2 Nov 2026 10:08:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F07086B05DA; Mon,  2 Nov 2026 10:08:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CF1736B05DB
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:08:09 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 756CA120160
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:08:09 +0000 (UTC)
X-FDA: 85390509498.11.A23ED21
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id BD8BB40012
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:08:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IJsS4rxO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6VXp+nvPq44Iibfd7M3dnZqyMxw2lTQeTkLffGnpGI8=;
	b=jiSS70SvH8T49q6FAAApgWW03EevlY8hccMhOI1b20dpkeor96oDKMsZB8bfyssodPFha/
	Yb1rmuWjb7q6+ps/5iyPIbhh9JKu07cmG3tk0cbqRCHQojx+YUtaZr0nOevQ5jH8/tPcEC
	nyV3zE7TWNVWNDs/WOAWdAI913foqZo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IJsS4rxO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632087;
	b=n7hzgShuk6B80Azb9KOVF8bUev2xZ5r8OfSS0Jrewqs5Webfez6eTR2mJXNz5Y7yasth2r
	Ui2/AO52a0ClrCHaA6KBAhuPJ+YJeXdnlz745m7QeHF2nCVLx3JKK+kHVb5UNdaiYe6G34
	uq2ZD8VK7Q47ySPPFpmglSLUuzuwIEk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 18A8C43267;
	Mon,  2 Nov 2026 15:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E8D31F00A1B;
	Mon,  2 Nov 2026 15:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632087;
	bh=6VXp+nvPq44Iibfd7M3dnZqyMxw2lTQeTkLffGnpGI8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IJsS4rxOrw0evPnx89c/k4QBxYWHpvmf5bC5nkZvS9heIkdiPMQ9+UGLYAqwXCeRo
	 01xMhphWRq3Aq5SpmzQFwBYXFYqXKEaXV7aEPiCoGMFOQNxw7pWWisGb5yaQPmI5Sh
	 tp1LULK9tthAvY5/hntPoT0wfDOVWswz1/lwzqVDgSpYEcKIVZ8JMYeE0wU54k61kO
	 ToCwYStQ9aor3WEDfPrJ5VAU7p1igwmg/9f/J70vTmuPCQCbfb4H8bgp2jfpfxr9Bw
	 Lja5YKZ94jQYHKXWFN6sFWb+EV8QZMwi+q9qWB4+h7zvBC2rh/ZxyN51W+VcpcOFR+
	 oDn8HTPgDHHnA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:01:46 +0100
Subject: [PATCH RFC 19/22] platform/x86: thinkpad_acpi: let procfs copy in
 writes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-arch-v1-19-c9492ab08480@kernel.org>
References: <20261102-work-procfs-arch-v1-0-c9492ab08480@kernel.org>
In-Reply-To: <20261102-work-procfs-arch-v1-0-c9492ab08480@kernel.org>
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
X-Rspamd-Queue-Id: BD8BB40012
X-Stat-Signature: fi94rbwtuukqt4gkwbxh4t7yjesksej6
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793632087-319093
X-HE-Meta: U2FsdGVkX1+qVDJ6uPEHFHpwtWEK7nKhxW4GC33noCMRfDoTX67opXIgUUnGXqQ27HSyM2zwT/hVjkl7hNa7gCCY1oXPf6VxOMMiGGFO0BOv06Hyl7cUqzyY8eDZlAzMQQJarU3iTyG4nJj8ilXZe/9szuwI7l4Pn/1ZkSrQjzqdONFuG708sDirM4bFBqSHdyLS6j0QvFgZlXp7lbAwjoDjcVhHgwLOFRLyHwMj9OVo9nOTO55FzuEc6T12VERIs9VExgPcrGs6oxsii1ZDqebBQF5S1fKYCLYpqLmEqQbhz+hV0HwnWeiNyK6lyIQoPebJGGke7xCo4Um8VRz8YzTUIpdKiAmB5Lv+74uAu0lIbjgxh6xxE74L41IplqPrW5bBuCrNH+39rTTZElx5Qz2s0FuaNlaBoe2n7ONXbHZqE/mLtt2OMAfGgDwQXRd78eCvEV/OBLXTAtQKdK1boA0mVNm9Ff/87iEceXxsgzkChBQw/ADtmasiZOS9EaEHvs31IOiuhl+5jE5k16bcRNgrKdsB3sIHDFQMbdW9+kuDanOvv7SPTadI3VRdTolJ1kxeWgJYudD5ohVdJNgRIDMMR9PY4wBZdOX2ZpMiWm34XjT06EWpOiNambXeYCExcCBRCC8OuQGJlwK9fLupSqazLlmtTXzg7Tn1KEsC95uEHXz6c0/qXb6odY2p0zk9Sv+LhFlcvEsnv08PhkufsDc6bq7ELtrEJL8oq1HqF1LHqCELnAMMbDY4akaQr0azgIKcQhrxxoBzSdhU91fiH9fSdzCx8O7BkOi4DdMppnrBIz63H6mR6/j1f5h/+pu6wMcWLs3yN0sK5t3B/OsPMYMlFbXKsj/rwZezUd5wLvoAazHToq0pWyMeudvpjOTb6qTnIdFddgnhmSK0ksmnwOpG8cFskj095TOG6Kh5IXe7sjYB+PVXTbhPopPsTx4HWv8vtcgS3+9BQbBli5m
 Rqf0uGHp
 8SWOiC5AZ+sDDPrgzxT5FSDD2SmJbILOJEEKovBIfODRgR/9EyTHZFj0XHeu6HHZxFdm+EJdYTxJOoDasEEvaumcwrLxszRC0RrR4cWt/UIMDqWzm753g5LcxCplpdCZxoX+DJ0klqCCD8hLzr4ZjAT6AZNkjX3SmS7HY8Ercy7zG9SvW6Cu8IaShUIRE6eir2+KUm/mC0jU9CakqF4d22rUZ4K5ODwqqQm07odmptrjHuYLWaPxPh1VGfe3PQawrgbnI4jAvuq+83t9INQTlS1qTW1hn1mJnwfaDlPLnZ7KFMpS+fDW9kc/Yh/lzFw6k9z5+3QsGs/oCtIk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() so procfs copies in what is written to
/proc/acpi/ibm/* before it pins the entry, and hand that copy to
->write(). procfs already rejects writes larger than PAGE_SIZE - 1
bytes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/platform/x86/lenovo/thinkpad_acpi.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/platform/x86/lenovo/thinkpad_acpi.c b/drivers/platform/x86/lenovo/thinkpad_acpi.c
index 01e4c980fad6..b4f253da9536 100644
--- a/drivers/platform/x86/lenovo/thinkpad_acpi.c
+++ b/drivers/platform/x86/lenovo/thinkpad_acpi.c
@@ -881,33 +881,25 @@ static int dispatch_proc_show(struct seq_file *m, void *v)
 }
 
 static ssize_t dispatch_proc_write(struct file *file,
-			const char __user *userbuf,
+			char *buf,
 			size_t count, loff_t *pos)
 {
 	struct ibm_struct *ibm = pde_data(file_inode(file));
-	char *kernbuf;
 	int ret;
 
 	if (!ibm || !ibm->write)
 		return -EINVAL;
-	if (count > PAGE_SIZE - 1)
-		return -EINVAL;
 
-	kernbuf = memdup_user_nul(userbuf, count);
-	if (IS_ERR(kernbuf))
-		return PTR_ERR(kernbuf);
-	ret = ibm->write(kernbuf);
+	ret = ibm->write(buf);
 	if (ret == 0)
 		ret = count;
 
-	kfree(kernbuf);
-
 	return ret;
 }
 
 static const struct proc_ops dispatch_proc_ops = {
 	.proc_show	= dispatch_proc_show,
-	.proc_write	= dispatch_proc_write,
+	.proc_write_buf	= dispatch_proc_write,
 };
 
 /****************************************************************************

-- 
2.53.0


