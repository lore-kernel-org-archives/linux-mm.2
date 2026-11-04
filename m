Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C095160A03E3
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W+i8aZei
Received: by kanga.kvack.org (Postfix)
	id A21026B05D3; Wed,  4 Nov 2026 14:32:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D32C6B05DA; Wed,  4 Nov 2026 14:32:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E8576B05DF; Wed,  4 Nov 2026 14:32:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 739C36B05D3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:32:41 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1BB4D1A0859
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:32:41 +0000 (UTC)
X-FDA: 85398433722.13.237420C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5493B180009
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:32:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W+i8aZei;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820759;
	b=OGBnZ90GHVQCt4ydIHFya2ezMs7cBFvNc/RAbdPUYDUh4R3GthPHUAOvHYUhJOMkzRF81s
	8+XXj0ED7dvwj3ceYQ39l0eF7t2y5nv9adh3xEr0MiO2eFDX6H87w3rKuAXh7u68d0Ew9o
	mKBSOJOgtm9lzbK1ZuTmdct0uzWBPvo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W+i8aZei;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z15Uq40RTWsSdyyx7OaN0bxQRP62XbWMWxAG8tgRqsc=;
	b=2UBgxKZ81m3YOXmW6GPVRa3ydnQzUfcmgF1dxBlgau89vdw6p1ebt1l8ng1Q/ou0UfTlEO
	3TXE+FRiglxVujv/+5hXvaALuY+DBMCY/8L93Yy11z0n2iGKN4PnOW87YIrwnA6BEftdyf
	/onvnzoj5IE3iquPjL9o+a2ZGn698eU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 93D3843E49;
	Wed,  4 Nov 2026 19:32:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB97E1F000C1;
	Wed,  4 Nov 2026 19:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820758;
	bh=z15Uq40RTWsSdyyx7OaN0bxQRP62XbWMWxAG8tgRqsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W+i8aZeilfkPThwp9sk+IDIrcNh/6E37rCi1GakLs5JMOFkVQhVKQXkXobs0GsnmC
	 X2w5aY+fCUKPZgFiwl4dmxwEoCZielH7nKgovpr50c7pO3XfdcFrRdLPMYF2xlbAAt
	 3UVMhfNaYBzloJyCglOGvkLp5sCBawqPIDZAtKLm0WKyQE4f6l0yJYPeQY/+q8lTkM
	 ipCjS3tQRCG9VrAfpWvyxyu8TaSRCmQX1N+d54QbhsbTYJppG6u0WLdqkpyWUbQBdD
	 EiU0Hqho5zULw8Z0FWgM9tiZsyw3bd5Ek++cBXgLUuSj9WX3ZVj0Iu1pCDoiiFv0xG
	 RmpMBy6S0lbGg==
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
Subject: [PATCH RESEND v2 13/23] proc: let procfs own the seq_file of /proc/stat
Date: Wed,  4 Nov 2026 20:32:24 +0100
Message-ID: <20261104-work-procfs-core-v2-13-76ace653a773@kernel.org>
In-Reply-To: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1008; i=brauner@kernel.org; h=from:subject:message-id; bh=OV3IfsSeb+nM09t9wfnVIL5mmMQS24c4QneBQIUHStE=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bm/Yo/Iod11QkuzuqU/SJ8a+PuXR6Rpmd3y9hLIR4 8bV+aILOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACbiX8Lwh1uSjYHhJmd0rWVU E3PmDt25Vz5sTr9TsyfTrMdnXtVlWYa/4uuOXOpitsm4b1jxZ7NayJqeC7x8cvdK/pfvPcEslFf KDwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 936y7sqd9gs5fx8f9estq1cyk3s6k77d
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5493B180009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793820759-486567
X-HE-Meta: U2FsdGVkX19M9uIWUwUrIYSDmWmAvGvZ1i4KGSKMLucbAcscnj+qoad93W5LonJWEId77wlRyA/+ZEroT6XzXn2M4TNCG1EEwTf6zG11U3nbCX/N4w2wZsv3thCn8oGqj0I6ZXXlpcTOT7ta8f3r89/6sdR47DG9Z+owH7tTBBlNdyD2bS4pdVRb++Z8caMMaT0/W5fBd5gnc0qgvlTLkVhBr0jwPnOIQYJX+UIQaAh58TgBGgVYdQL0hkm6W/CaKQalUHkqAtKCA0vRrnuFzreZgr2N62YBQhqwKmzyn6/zEfvNHDm/0nZfb95Q2V9uKN5j7Ni8+ic1cngIT0byJzuP9bINt6EWUJGvNyo9pYxr0OcbBXsSh0OIl53m2PffrzgZ6EmoIUMAmwpQwYGsJMag4dOxv2x+ZGXMj6MM0FCYXbfSYXb5cXdT0/6wOaX7sual0tLCJNZu0dMIVNuJKbEu6T81uBMmFAkebQO/2FCwN6WdQXelp0vBRVnFvI1IiIx5MQHh2nxRxKpAI8ZaCBFrexkZDQ8EaOCqjc7v0GBcsYkaXjdXY/5U2JnBBPV9iW7VE5SK0xuP44K11s3MpvNLbIzBPrzTtAor0s6G3+iY8w+HYAyOE/d/3kKCNVBKVtzOhWIgan/IyEmjcONicMahMk72sOdmwJrjzI73CqCVzmJSI3vBvuXxmv0V46oXtF7w2dU/8+Ifg1BAaiZt4NHZwOV3IaziadTVz7lizztSlxKJpNrubsp2K2dvhDCCX3TAeWoVSsC8xnctiG4dcbO2siQWJpFaL3HRpyGVJ1vkz/JwWTZUCQ/BDcW/NxM0lfbR7ZlVCWwcDmX3I6UUq/YsGfgNUJmjZ1/naQukd8l2+I34Jho+CK8SxUCIgmFAxcJINsBo7cPd+CQiLzrSgSCY7D/sQrcr9OwLAjz3N7Ch3XFojgcpeGB161pW0N7GunoZoTloQvZ/Wjjqx23
 Vh3oL/dr
 E2DstJitgIdZd25tchJqVnL8G2hNL0XoC74eM/CiCzPU/Uuf4u+XYH8XBAEAWgjT/LUU7q+5mgeL/KpyU6Id/MLM+m/PpIsaFSQMV4nccCfITD/cMpV3/1jCavnz8nSfvJS0IOVUlfCBGowq/Uwjm6FdksC1h60QYuIGZujylb+Of2frwsE/pBidAyW5falIUZifUYnsVmpTHkWehCVk83iNg6yT3QvlFooYHJygmAnNjUJ4xL5ksSH5ROcAUHSQl8aNaXJZ6C/ge22WpTUtaaON8OuRB7HaaypnDOb7dsqT2eMBQieBFLIzMe+ZW/ZUB11bke8LWFIcSLQrVT+T9MYqCztxT9FpvxMAbLg73qDYyKch2MliZl6TBfttml9aone/8ZRXN48SPB0YqZ6Qle0tOtUDagqlHYTZu/fJz8ON8tdxFyHKTrv+4PPcJT7cxrpDn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Declare the show function and let procfs open and free the seq_file.
->proc_open() only preallocates the buffer now.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/stat.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 79b42f2bfd00..3bfb79edc0f6 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -161,15 +161,13 @@ static int stat_open(struct inode *inode, struct file *file)
 
 	/* minimum size to display an interrupt count : 2 bytes */
 	size += 2 * irq_get_nr_irqs();
-	return single_open_size(file, show_stat, NULL, size);
+	return seq_preallocate(file->private_data, size);
 }
 
 static const struct proc_ops stat_proc_ops = {
 	.proc_flags	= PROC_ENTRY_PERMANENT,
+	.proc_show	= show_stat,
 	.proc_open	= stat_open,
-	.proc_read_iter	= seq_read_iter,
-	.proc_lseek	= seq_lseek,
-	.proc_release	= single_release,
 };
 
 static int __init proc_stat_init(void)

-- 
2.53.0


