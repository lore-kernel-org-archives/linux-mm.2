Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D919F608B7FA
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JpmBPtZO
Received: by kanga.kvack.org (Postfix)
	id 100E06B05B9; Mon,  2 Nov 2026 10:09:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D90C6B05ED; Mon,  2 Nov 2026 10:09:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 015606B05EE; Mon,  2 Nov 2026 10:09:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D9BBB6B05B9
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:09:04 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7BA671A0155
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:09:04 +0000 (UTC)
X-FDA: 85390511808.21.21D5037
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id B533940003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:09:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JpmBPtZO;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632142;
	b=DrU0jO7tZ9mohUBU3ohm3jTiS7KA0LQ8sP50Y9qUlh3c7mDHhUYn3Jj+405lOUKCtqDlrG
	1I+puFaePuQm3M8pshoc7Owc3EZqrPguGHYrnS/ok9WjZMLQ1WFsX1E9aYlY8YIcGHUgmp
	jd1wZDTa7EquSQauM/AE3+mbO15zghs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JpmBPtZO;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YGofg29spfHBU5j0sEupYlWEu86pUC9IfXeVVL8qINU=;
	b=VZpm+cUWyVJeRorTwSlAfuMVCX4v1Vv8j1eyLcDNYvNlxbO3YxlfhUg3Xbq0LybYmUhntk
	TR6ZMgwmQTXIqGkRJSbPWwD6VZ7DZDZzbiLL233lRJeyVf1L7hiApO8jYtUdxq3M6liIRA
	QZsOHEPemFZGcYKT+wArig0Zgau2zdo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 056B14197D;
	Mon,  2 Nov 2026 15:09:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB991F00A18;
	Mon,  2 Nov 2026 15:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632141;
	bh=YGofg29spfHBU5j0sEupYlWEu86pUC9IfXeVVL8qINU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JpmBPtZO6G/UqVUziPY4iWq6sxFWqxjtkt4mByDfSmQn4JPupogU0bEEb3whcdZpv
	 bxJjhl9riucbcDZJP757/It4YGJC5UnRtX978pao8OmQBnQl2aSFvJGabRNROHyvpQ
	 bZzdyysVF3U57cA3Ja1OK9TBd8Tsli7X4hjtxAFP6BIZk3DMCdCyX58cnbypS2jX2/
	 rkwz1SxlnDr9giKtJvEtvZB1xm8ozK/+QHDHx5w/XweZen0aQhQjbqjSvObAObvY2I
	 HxCcEBImWMheaGFA39+r4mxQ3C4umA03aHVfQBgmMCsinQB7bWR44TPgh7+0yTz50I
	 jxnkq4gmT3FLQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:01:49 +0100
Subject: [PATCH RFC 22/22] PNP: isapnp: let procfs copy out reads
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-arch-v1-22-c9492ab08480@kernel.org>
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
X-Stat-Signature: jp4g7hbzuuampohzuqzons71mq8h9jg7
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B533940003
X-Rspam-User: 
X-HE-Tag: 1793632142-23059
X-HE-Meta: U2FsdGVkX1/zKeOtG/O1DNZYy61BD8FGI4A95vIlqP4AA6dUXQGKsvqDJ07FRp0H8XvZA+3EjhpHMwJma18jv8EghJuUgo9y60O1X7fApJmfzKX3vb87uPl1aDSdo4vHnyQiv12wAfl4vbsypLfTeB27PUUbYGvnTxP1THyZYSFpmZAC73cWFUV4DIryYInjprRU3joomBcwJlZOriRxmC8oI8xjI2V9JBuGVUvMjxGVlJw4b3V+KPHyWW6QKfdqZ18fqJ4rgbOZmJvLV4TMXbm0kNVd9NFK3k88s1t/Hyu6YqasiQ6TJ+0c1i/isOKfiRzXX38Q8nlIJtadj3qE4IIk19Pw97n+ZvYco2xcafAMu7F2VMDat7D/tDIkIV/Ipjh9Xa0f4JRdk0i6zx/MPOZvdV1ekslALYy0F+QFz6tIzTDy1sYFkyLGO7bYNwa4ynrUGpNVVgjIc8z799uYhiGBRyEgbPfBoapPeJAV4PCOvvZUiV2ORJ9S0Ggjg50o7bBWD5MoEIMhLAGRTE+zSoF1zV5HaR9pRn7xuKUoZBMbmUakGj0PjqhZxJ3WBHWDYcAfsOcU37Uvpul0TaPZvWZNU44Z7UznF+umJBZ2HOC+i79JINYKq9sFXe6ie7M2E0nrfZhTaDR6uiDobM47cjXE4tM7XYg3C1hGijgGWLlKluXPBacqY9GrbJzxmbJZberLFsvdVrEpjhSo8cX3zKp7vENL/1xDTV7WA/W32F2MhxLfZbnwm5vZ5Lx5IJ0vHcKhd4vZa/tOTFxX0lDQu38sCruAvziSD1lUhaDgHmv0EVP/ocgk1cdhXPLKxLbY9EMxzzTMuTAYtURcERv1tIMbv43MYSJEkJRgX1nDSPPWEPrb1jjxNEB4ZluMMQJ3nrK2Wzg3AoHV4RfXekZTltPYo+HlLL1Ms/HV8IZtkhzMx9w6IQJYYfnrp6tLL8eF+Y43xZRtTZIggeQAntV
 FvgUC3Sc
 psm5KoMve5AjuLBm6EeSstYeXAcwWrM7tOEQyDFMv7V6ab2Ku6Sq4TldbqqZrL0INnY5bKcsMafpa/qdSe8FQzYIzK0Pj2Uy3a0ttF82nMnZV+ZMOYuPjOs2v2yv9LXIrIIzchpFlnIyFiS1WzitVWGeiaIbEoTYvHcGpksbkO8/YHdwoHYMvwdXC6eMVq/nmzx2SxQcvonkCgzCfpfXK5lJPCsdg7C/pXT7V0e89tTOdY5bYsxcZLVPgiEy1EhMi7d4JsT9Mr/NFhXTPB9qHPMthR0dIWEjsUcNx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_read_buf() so procfs copies what is read from
/proc/bus/isapnp/<card>/<dev> to userspace after it unpinned the entry.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/pnp/isapnp/proc.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/pnp/isapnp/proc.c b/drivers/pnp/isapnp/proc.c
index 8197c7f29743..152fd5bfbc06 100644
--- a/drivers/pnp/isapnp/proc.c
+++ b/drivers/pnp/isapnp/proc.c
@@ -19,37 +19,31 @@ static loff_t isapnp_proc_bus_lseek(struct file *file, loff_t off, int whence)
 	return fixed_size_llseek(file, off, whence, 256);
 }
 
-static ssize_t isapnp_proc_bus_read(struct file *file, char __user * buf,
+static ssize_t isapnp_proc_bus_read(struct file *file, char *buf,
 				    size_t nbytes, loff_t * ppos)
 {
 	struct pnp_dev *dev = pde_data(file_inode(file));
 	loff_t pos = *ppos;
-	int cnt, size = 256;
+	int size = 256;
+	size_t cnt;
 
 	if (pos >= size)
 		return 0;
 	if (nbytes > size - pos)
 		nbytes = size - pos;
-	cnt = nbytes;
-
-	if (!access_ok(buf, cnt))
-		return -EINVAL;
 
 	isapnp_cfg_begin(dev->card->number, dev->number);
-	for (; pos < 256 && cnt > 0; pos++, buf++, cnt--) {
-		unsigned char val;
-		val = isapnp_read_byte(pos);
-		put_user(val, buf);
-	}
+	for (cnt = 0; cnt < nbytes; cnt++)
+		buf[cnt] = isapnp_read_byte(pos + cnt);
 	isapnp_cfg_end();
 
-	*ppos = pos;
+	*ppos = pos + nbytes;
 	return nbytes;
 }
 
 static const struct proc_ops isapnp_proc_bus_proc_ops = {
 	.proc_lseek	= isapnp_proc_bus_lseek,
-	.proc_read	= isapnp_proc_bus_read,
+	.proc_read_buf	= isapnp_proc_bus_read,
 };
 
 static int isapnp_proc_attach_device(struct pnp_dev *dev)

-- 
2.53.0


