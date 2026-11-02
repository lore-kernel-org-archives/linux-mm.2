Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5BDD606A918
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eItiv4ZS
Received: by kanga.kvack.org (Postfix)
	id 14B0A6B05C6; Mon,  2 Nov 2026 09:24:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 122856B05C7; Mon,  2 Nov 2026 09:24:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05FA46B05C8; Mon,  2 Nov 2026 09:24:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DE7016B05C6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:24:51 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 72E98120123
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:24:51 +0000 (UTC)
X-FDA: 85390400382.22.96179E6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9CCA34000C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:24:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eItiv4ZS;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793629489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S8IXtzTL1USde6aV/lVKsFPWulIUW0ciUvC5Tm4lMm4=;
	b=XPoC3EMHkxKfLjEbLs9FhpVL+VLIzt1hQjS3YAuMNF2Kr+mNLPpb4DMXVYp/2y2WMx6Cir
	Pm5kvfQ9xhpkph2CH3UAeD4Tull91fdF1MuPRS0jELfSiluU8Bv3Yspx3eJw9V5LXwNm0A
	q3n0bJZwFp84/8mQ8mij70pMGYN3GQ0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793629489;
	b=E/tcasZzFPl3Qa0HhBjNuEQaEshCipD9DrOn8x9pyAd4r1z7WFwsGwC1WR+PFn4rmy8ZpZ
	FnPl3PjU21UuDiMG2G7eyFiBpWqjzZsUh/heUIF08otOGtGKLzZ3j65lyNDAQB6o9//0bZ
	S1Fm5MqKWPnhdlZvlGbGExh6InvkHN8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eItiv4ZS;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E588843CEF;
	Mon,  2 Nov 2026 14:24:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A91FA1F00A17;
	Mon,  2 Nov 2026 14:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793629488;
	bh=S8IXtzTL1USde6aV/lVKsFPWulIUW0ciUvC5Tm4lMm4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eItiv4ZSsA0o29cJddRhknzQ/bhOslnikosU7shAbLsc6vTsBfmDsItQHBMrbvVWd
	 iPZbUolyR+DqkWlaAa0X2CnLcF2jyDfURGxamilT7KyJvcn1fKmbflZQF9mZNYHiZO
	 V0ITbrToBCzB7hRC4b/UItl9wr2159FfzOymbnfHnOF2rwSD+IUlNRm9Mg0cMAS2zm
	 5gwJPTLnvktaVBDt4cpf/GZOkyIf5vc3Gnqu0sv5l4CtGAi/V20ChSZvsil7rMsNnM
	 0OhXFaQi0hOR9dRoU2RCfw23JXyWpcHF2yT6L1CDbIcvCpMbQZH6dQmQwY5xG0/KbE
	 t+ML1xiLi3rHQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:21:28 +0100
Subject: [PATCH RFC 13/38] scsi: core: NUL-terminate what is written to the
 host proc files
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-bugfixes-v1-13-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
In-Reply-To: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
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
 Chuck Lever <cel@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1011; i=brauner@kernel.org;
 h=from:subject:message-id; bh=jBwXVCCRpDjmnAajxR/zAvEvmAtZKAE0jCj6+Cnx3v0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9mJOt8KzyxT3HqTxz47pOZlhlreHadWzKU9ECZ1HJM
 /eTjxsd7ShlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjInBpGhnblJ+n8i6QvucrH
 3L3hMeP2tqzHWnkyxe8aQsOergg+85jhr/wPVbOd51/rtnu/jeqzYHXMzjH9s/7NWaZa++nPtf+
 38wEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9CCA34000C
X-Stat-Signature: zp94kfe1iqby4tqtyfoq53t3fsbyeytc
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793629489-300022
X-HE-Meta: U2FsdGVkX19uv+jvdgXlf/XKAby+yxolQu3kiXAlEYDtaokokgSoWCMq8CCBm6QpRaYlo+DXf6FaplwGAYVBNydMB1y5QB7W+MS9ZC2FjtB0p733Lmo3CSuCiz9HJCaMqkiTd5ekGaAyejA5reSNrqtl7EhPqvU9FeisoHy/sevfeSMhGlngOKg6CYYHCmVI/MB0gdvMWvLzz9748BotNauSlviy3IgLSDLBVkFIGjHSIgKLpG593HvOEpzd+yRKJHFOvhvEpcvMG884naJu3qoT+ftsLUwuUomuufRPyF/8/QEZ4bBY5exb8T79Dpk5xSYkngfnu3gya3Osfk8zMauXwGw3Pxh1t9CyQNwRYdA8ivsUJNTA/KTFqAyME3gViey0cxNfYmAJhVe+YNmqtL5BDBPYnIESqgvauiBYiOshz1g3+W0jRjrLstq9s4uTQNUR4Ffl8ofOuZo1obJ7JyOkbMBlhv0oRxfUA6NnVqYOdR6mj45+jPC8saz1FHwEyD+X2MBT9DunFH0E7k+d6Kk5MrD8uUWdvidU+WBRITcv4ZC/cETs/TP5fsgjjD7BKMTHbz5xgMGpwqJyDMdx1gSTM/o1t9cjxcBsg475Bvs11MWrOf4XF0quDriOM5FeLr0+OkNrWItWMZUBqWoVN1OeW9IganCvtFYiKBqO+kscKmc0rsz0ffmAmpZXN5DWfyhiM1k/G6ElrbYv712oBKIW7tA6Mqe8u/JZRkYAs5mDb3/mgWPl8lzJH06OcKd3xMaTcPKcJfNWeI2CmzaCQVWTwLRt1Rim5eS+wsdiDDdrGJVHigViAa0v0mhzO+aKlvp8DJyR3KCRmT477xTdEXcqhgFo1G/4qy1u0XMYPrO8L/ymC00l9hDXrR/Mdee8jz2u2qJOmB6lXsgze1zbZNWOhLh1yto18iEnyIkxBbDW3dWC3NHgIPMV1HB/n4h+YBuQdBEvX0g98Eek+GO
 33hjRlDC
 Q+4W9+vWwdyNwThNAeAR8MuUEKYL1PEbQCbo8YlTWlLUB/9V9/1IBGeoTQDTJtY/DMdl5+CIQQ1UiT3q6l1V5rRj4cqA6H0nw4aR8X0z8xDlq6FrGPd1kfbtkkAQifeIy/fDHdgZoYUAqbBW+N1PCA10jJbUnreO0SX9Eun4imyVTKO3llRNdxQKnHbvpuXZYfw98frQaResapZGjSe4WsXC0C3nUOjcB22JeWA/89q47KouLsVQWlNuLsI3HgfMGZMrjRM6BAVnfbtT9ybrRx4H4xaiiW5hx2Trs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

proc_scsi_host_write() copies what is written into a page and hands it
to ->write_info() without terminating it. ppa and imm parse it with
strncmp() and simple_strtoul(), which read on past what was written into
whatever the page held before. Terminate the copy. A write is at most
PROC_BLOCK_SIZE bytes, so the page always has room for that.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/scsi/scsi_proc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
index fdc355d783da..dbd03360b5a4 100644
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -80,6 +80,7 @@ static ssize_t proc_scsi_host_write(struct file *file, const char __user *buf,
 		ret = -EFAULT;
 		if (copy_from_user(page, buf, count))
 			goto out;
+		page[count] = '\0';
 		ret = shost->hostt->write_info(shost, page, count);
 	}
 out:

-- 
2.53.0


