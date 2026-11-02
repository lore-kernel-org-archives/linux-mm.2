Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6A29606AB94
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hg5z4oUZ
Received: by kanga.kvack.org (Postfix)
	id C1C1A6B05B3; Mon,  2 Nov 2026 10:04:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF39D6B05B6; Mon,  2 Nov 2026 10:04:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B09D96B05BA; Mon,  2 Nov 2026 10:04:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 96DCF6B05B3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:04:26 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3E60880172
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:04:26 +0000 (UTC)
X-FDA: 85390500132.29.A745531
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 717E42000E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:04:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hg5z4oUZ;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793631864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K/nPdp0KTrkO/JWfX0DeaffmMq6r1stKUZ+oHzzOxP0=;
	b=WqLqUq9jsk3VEmuazbPWW/Sgf4r7LkOSvFbJPdxSZ7se6ZthNohH/Pp6OsMkrZ6MnGQ4T4
	WITvE7ZASkDLkzbd8MeI3EC+aAVA5DIwqiMp5MaJVfLiD+73RpNp9kZEsP+g9sVP9boj9c
	sqQdBahFHmpHQVOX6S4s03xK+fpLl0g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793631864;
	b=waJqyZslk6uQ1a2K+azuvY/8986eeMKNuXmky6xS6ox1AfwraZSRacbR4kh5SqyHufMOi3
	AVBaK3tiRxvmZ2sVhQuze7Co026RlPm6Pb0MEJJhm98/VhZhxzRPdJbx0T5C8XH1v3P10s
	yod4xMVoD3Id1AAeeDGazYNsDJwdbXk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hg5z4oUZ;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BC5AE43C16;
	Mon,  2 Nov 2026 15:04:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50CD51F00A18;
	Mon,  2 Nov 2026 15:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793631863;
	bh=K/nPdp0KTrkO/JWfX0DeaffmMq6r1stKUZ+oHzzOxP0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hg5z4oUZuRz8N20Z5C+Q8yL18Y5yCw7qLkDhvSa3q8JNmsjPQwjzQ+mMuPQCiWUbZ
	 Y7Lf4C3jcwYkPZM9FYjlQwVMt+IVrZBJileSjZkYaIPS9b5zUXk14WIw+JVn7EsOU4
	 X4PnMaia2Uw5JRPK0Y/IeoZ5Ktq3pARrGiaVdYugzvHIRDhsmeS/p/quiqvdz+vWfE
	 AUGhD3c15oSYVACYkUFkJnNm0xAkDzUFjRuKB9ZEAXO17dJeJqcdRtoI5OGF1GhbZ7
	 YQIqxbvutG2Qq9CRYrtQhXVKgITYMloJ1QVm1bR6wQ8dUbiyrra8iSth/icVuFpZ8E
	 UfEtn5MBXe+5g==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:01:35 +0100
Subject: [PATCH RFC 08/22] powerpc/procfs: let procfs copy out reads of
 /proc/powerpc/systemcfg
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-arch-v1-8-c9492ab08480@kernel.org>
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 717E42000E
X-Stat-Signature: tzeq4tjf731gqd9j81iawapzqstxtamt
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793631864-627776
X-HE-Meta: U2FsdGVkX1/34gl6xiLmAljx6DZjvzBgn8wJ5IdpyDaZZ6pW3+gr42XDea6v/FTvetgX2DAF8O2vCI25yARWXliXay6PKCRfw/07oSbuI0WRyZcSOx0Fl4HP8MgW7XcC000BVeTYof5uBv6b9hvdxjl+8j+9RnTRQ5imfd72PQr02m5ZO8vWrMHnRSfRRgLxVRptQr2vMEa3KQWfPUaE9eirw97e+juOXqF0WJuX3j0hC5O7YzXXrNd2g3lyqp0q3SChkq/bnbxKgBYKtrWasat8PPOzOqAZrEGuokBpKH9ifpuZfVNqkD4/MtkSjNKlMs68Ki05ut2pW87lQbcwti3RXOLVHxlUUSdAGzfK1g/NfhkVf6HEv+hvWMQanpp46r659X7Ku04422iRVV+iSv7n5UTNFI9+XJms/t2g4gi9uYQYs5NAMVNQT1mrWPR9rvh+TOJ2bjxWBJqWnpUFktuhvQDwRpvRfiBmgpbjrMlOZQN0mgjLuO3NPOqZd4/2RmQ5S4Q5IYkTiUq/PpE0gQsfzELnSaWNzmHDd+KSsl2DQwYaicczK2zbkYjejZPl2WAP+/+NRR6dHQj6/yf5KnqfR9uhHLH4ze8VwPpshHVWtS1vNIPpzlBXu8irw0nfmV5G/6q216faYkVuNKyTijTEZiJhRqx77C9Ky7ywHELpVw7xeGJWdW/n7RXZzwqHWcrYZverpghxPL5bxbSiM53y3spE2taRZgkHz0S1CPw4g4Djm7f1vrzmMxbm+pLeV9H7F5G0CtH+AIWhHeXQ++fYZa11+d01Xi/C0vd1ZRgHVR7VS8RvgabHpC0Wg9YygYHHF5UNLM9ojkP3OLAyeMHDKs2z+mhtGJdjCediCM6QjWCv986nOvotgnXSxW7MYUtBgS5BLJPTb+AKSrIM1g/eNf+SDu13fqceQWzJlVmd2d6ml5K59NCjCSHcATS4bUbSrrbkivdtzmAE1od
 IWTAp+rU
 Bu+t14gEWvI5If56Z8t5oAIyaRJPPA5fL2Vpi1csfm4Q6rKCa91vIbg4QBAc+sSoH8OvEfjL7Fgx2JkZfjaHm2hbqjd0mO1eJp9I+RcYweSvTu2Mo67CSQL9r5Jhu3cEMWrkyBdOrAwlhCFGiTA+BS5krxOf+2T6bxXTETeElkKphwKi12Pa91fD/7v8lndyvuagozlVXvY4188znaA5dhmnbQOYymS6QiZV5pTupptiWN/F8GpMiKG+RvGh1JOHE7F5xgtViFMI+eaesgQZLkW/mCcKpoPEaEui6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_read_buf() so procfs copies what is read to userspace
after it unpinned the entry.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/powerpc/kernel/proc_powerpc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/proc_powerpc.c b/arch/powerpc/kernel/proc_powerpc.c
index d083b4517065..46bc914d74b9 100644
--- a/arch/powerpc/kernel/proc_powerpc.c
+++ b/arch/powerpc/kernel/proc_powerpc.c
@@ -24,10 +24,10 @@ static loff_t page_map_seek(struct file *file, loff_t off, int whence)
 	return fixed_size_llseek(file, off, whence, PAGE_SIZE);
 }
 
-static ssize_t page_map_read( struct file *file, char __user *buf, size_t nbytes,
+static ssize_t page_map_read( struct file *file, char *buf, size_t nbytes,
 			      loff_t *ppos)
 {
-	return simple_read_from_buffer(buf, nbytes, ppos,
+	return memory_read_from_buffer(buf, nbytes, ppos,
 			pde_data(file_inode(file)), PAGE_SIZE);
 }
 
@@ -43,7 +43,7 @@ static int page_map_mmap( struct file *file, struct vm_area_struct *vma )
 
 static const struct proc_ops page_map_proc_ops = {
 	.proc_lseek	= page_map_seek,
-	.proc_read	= page_map_read,
+	.proc_read_buf	= page_map_read,
 	.proc_mmap	= page_map_mmap,
 };
 

-- 
2.53.0


