Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DC2C608E0A1
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JEtEk3Xg
Received: by kanga.kvack.org (Postfix)
	id 4D5226B05F1; Mon,  2 Nov 2026 10:11:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 485656B05F2; Mon,  2 Nov 2026 10:11:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C2AC6B05F3; Mon,  2 Nov 2026 10:11:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1A3296B05F1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:11:00 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AE9F612013D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:10:59 +0000 (UTC)
X-FDA: 85390516638.22.FFE20D4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id BF8B14000D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:10:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JEtEk3Xg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gEfU3T2fMjgdZUubap6/Nt8I8xKTHWl/++QTJaSUEcE=;
	b=CCfUwYFQI8YZGi3MH5Zyia7gt4G4tQYIqrHoGRA9t/4Z6FYi4avMteVY3Ew1Y7xjKEzbAV
	5jHOKLgE78RiD9KPtPy+j4Bubk+T5L/f4kRaJ8UIvZkDPhk8dVQ8lpDMPxtEorEWXQGLiw
	KNu9JKmizsKIt7vfrlBI+oH83GI0CCo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JEtEk3Xg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632257;
	b=l8KijqdVjUdhKC8imBJ0deRF+1WhYNOVt7qoA6wJQ4yINPHkd6Z1Z04JHauQpXcFyWjRJg
	0KEBx0CjMwnIsRash2DQVOnxIXFbs7QTU/hzXhofqNlLgYscj3P10+o3QMY5ITLKGN73YB
	3nKiW1BBqx+M7JznobNBFy2ZNWGs4fM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 600A660924;
	Mon,  2 Nov 2026 15:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAFB91F00A18;
	Mon,  2 Nov 2026 15:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632257;
	bh=gEfU3T2fMjgdZUubap6/Nt8I8xKTHWl/++QTJaSUEcE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JEtEk3XgkB7h/KCKSpjSx/GQWpU/P/7tvtCdnnzCxrDpIn594psdLHFTrmfuke6dM
	 slBqHYXHnT54x/QPrsmxH3yeqxfZQPD2y0pgY1+PEiyIIJsHQEmrStcSZUBzYnriXr
	 z1cAZ9kaI1mij4Fc3B7DH9EC4k1fIQp6BDZOK3UL5awrKforvD4qmdeHd8pveKvbcx
	 iZMvCpnYB/tvXMP/UoxQpEd6uLwjQn9oT2yIsRi+8s3j66mGWx98OAk1gVJO1c+yd/
	 xAonphmuY1qwZTlY+D0zGjvzNIJDEogTrjTuIG2qL99CLq6eIn2OG7zpSiKwd/V4oF
	 8+lGx05vpGPgQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:09 +0100
Subject: [PATCH RFC 02/23] zorro: let procfs copy out reads
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-drivers-v1-2-a994bd4d3b1a@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1540; i=brauner@kernel.org;
 h=from:subject:message-id; bh=0V4WXwhQL5pRZKlAhpvNvMMTbS/E9DKCsIQEEH9Ob/I=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG7AIbrx5h2jApOfJWsWGW9hzDP7Z1n71GbDkhKjd
 1G75+1S7ShlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjI/UaG36wcDIusu3nPOnFM
 /P+8oNKCR/ZZrpFyDV/sHU9NRa7UTIb/YfZNrhe7BR60inb8XH12tpIKe1zQvdmbziyrv3LhEYc
 VLwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BF8B14000D
X-Stat-Signature: rouc385qj3boft75w6994q7k1tpbcffd
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793632257-607472
X-HE-Meta: U2FsdGVkX192WvBq64glzFoNAI+ilcY0pP3kZxOk4wFSOsADku26zK3Agi52ipRVaZMS1HHgi7Hh31SLsq6C8Xvyk1sype0Gvtak2YQkPlQfiJQ5oak3nH1n1h8Kd21r9kWK9JaTOKro0+Bx7CbtMbK3wxoRDpBYH9IC025PMalM8BwkPiU02d04mek2r68bypMOZUpXKvGVp5kbn2Qdqxlrd0bKe8Mk0WH7TVOQqz3vtffzOWT923MAiA21bvVtvrscPQQBC1XHrbzx+ZqJoRjeZpujnkJk0+RjlrglcpzSnhxaXtCD92gSUUbvX37XkWHUTsirr9FSPudBcVCPyFrIi6Ns9m9Dswlresash7dlioSmQFwxCjgR7FACVe7x31o/IprTSCrqgE+cQ1MovhwqPoW6IqI6vf0nmajZiub/q3+zpA4TaSDiNFY98Qn2cyzTDEfGvAhjEva0jGr3KpEkI/oSq8nCoprcucFASxS+WrWkmsJz3ij1euNnhJpQGw0VHjnRJxH8ej8Q1mY18oGcSxqp9G5Zq/Jmxh1bkxvLZz5MZgY0RRX3XjfeYb7N7g24beMds7HSUfEwkFUm7+HtHaVTnfUH3uD1FBxMD1ltXBdtCxar4vkLRtJ/Ljr7b16BsV8XiB6GIapwjmP/0OIvuZhVwZUFGbLQ70TwUmWkpnu5hlfF7NGlluCWHuq2VX9TvekAn5/kAb46P+Cqe3++OnvXSiAcp+5+Fis3e5tS/6ylZ9LXbyz5vRXawUP2KV1rrlTen10BiP4Hxqn6WnJlfa9E23/REOz/kL8yCzvM4bYQIbJ6FekqyVMrOm0Bg7lySreN+yDQeNW81Zyfc0kdzxO/tWZ6bUfHr2TqqXJvaqSdq/NeEB89J+nPCbP2iz7YGoI9dlhQ7Y/cYMZfNN4g4A0BKNeAZHOGNyAEMKsUSyaRxvR043yxgUCIuXeP9XdFUu9/0QMzCTr323t
 ymQvogQj
 nFDlPYEh8ilz+AE/Bkj5/t3uwyNcs/EMf8ie+6ejp+lvFpqf3xlOqpk+FsNoS4kkaDVsAPiDzwRMDHK+aqiZLNtGYQZ8+sATI3q64+dzwI64yiS1Q9Irn6ECWGVn8zMP2gob6hQK2y6+rDvbcWz6hM1QaosNSepnf9iOuzuTJQX5re1Da3tYgR2gojP/y68J1hdUY69CgK6NRVNR+dC0AJ6nOHUNVPjM95lgTgg5BLHkJ9YYob03n2fRl5SHwWIBlF2RTtda10u6sf71BMHfUD+3Nk7+V8lKKqKNR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_read_buf() so procfs copies what is read from
/proc/bus/zorro/<slot> to userspace after it unpinned the entry.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/zorro/proc.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/zorro/proc.c b/drivers/zorro/proc.c
index f916bf60b312..4e4ba04752ea 100644
--- a/drivers/zorro/proc.c
+++ b/drivers/zorro/proc.c
@@ -28,7 +28,7 @@ proc_bus_zorro_lseek(struct file *file, loff_t off, int whence)
 }
 
 static ssize_t
-proc_bus_zorro_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
+proc_bus_zorro_read(struct file *file, char *buf, size_t nbytes, loff_t *ppos)
 {
 	struct zorro_dev *z = pde_data(file_inode(file));
 	struct ConfigDev cd;
@@ -49,8 +49,7 @@ proc_bus_zorro_read(struct file *file, char __user *buf, size_t nbytes, loff_t *
 	cd.cd_BoardAddr = cpu_to_be32(zorro_resource_start(z));
 	cd.cd_BoardSize = cpu_to_be32(zorro_resource_len(z));
 
-	if (copy_to_user(buf, (void *)&cd + pos, nbytes))
-		return -EFAULT;
+	memcpy(buf, (void *)&cd + pos, nbytes);
 	*ppos += nbytes;
 
 	return nbytes;
@@ -58,7 +57,7 @@ proc_bus_zorro_read(struct file *file, char __user *buf, size_t nbytes, loff_t *
 
 static const struct proc_ops bus_zorro_proc_ops = {
 	.proc_lseek	= proc_bus_zorro_lseek,
-	.proc_read	= proc_bus_zorro_read,
+	.proc_read_buf	= proc_bus_zorro_read,
 };
 
 static void * zorro_seq_start(struct seq_file *m, loff_t *pos)

-- 
2.53.0


