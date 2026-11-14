Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A358606C54B
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CSnJIGlX
Received: by kanga.kvack.org (Postfix)
	id 5E2976B05DB; Sat, 14 Nov 2026 08:08:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BA166B05DC; Sat, 14 Nov 2026 08:08:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D0086B05DD; Sat, 14 Nov 2026 08:08:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C9646B05DB
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:08:43 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C0A581603CA
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:08:42 +0000 (UTC)
X-FDA: 85433754084.25.3998C8E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1332FA000B
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:08:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CSnJIGlX;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IrVRaUgylyW7dx1wUoEgP8enLWWhiisOApdkF3tckhc=;
	b=MNC1t7XXA3wwz3nnrJzLuZZE5r4W8N3FpkCSQemy9TQ2CGm8p0qJlMZ35Co0vB12gGQwdb
	zW9belAncMM5CB55FJIu88N8nx+NnOZPAxMmT+uvC2M6qEkRjbceM3OCOGrK89+7Vbd+1o
	o/74AjUtahd8zCtOcYdn/mAPhsY5Gow=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661721;
	b=sgGxABo3zn2k5YZDMVnc1kbOIHWWGmoE3Zq5qRwYgWFfBsfVx6hDn53t1XOLlELMkjxvAX
	O0qwBlyzZwNpqyMtwHM87tmKgUIVwbd8joprytfoQebi8HB1XTcAWlAHpdmASXewWsbLQ9
	4IuFkCsyyIBnQ5v6Uy4n/jzfWlGbJ6E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CSnJIGlX;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 60A7140D83;
	Sat, 14 Nov 2026 13:08:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB201F000C4;
	Sat, 14 Nov 2026 13:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661720;
	bh=IrVRaUgylyW7dx1wUoEgP8enLWWhiisOApdkF3tckhc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CSnJIGlXVCwPfZYGjaLB6IqanwTkuYMOqLjiIV98WyWx8/XlfQskQ4Ncrgj5RhMZR
	 wSZWZkZtit+aDjyLJmmgvMVuloaMpGHPl4V5iV3BBa563e5JY9xO+gJBwtTb9q7Q8C
	 mdg4xQ1+bqoQpc+gIpw5ks/W1KsdFYl1y8ZZRTzVOQ9kvuq4mogGtVJ4dS/PfMNIH3
	 q1Qk3HwuKj12Ep3f9iEkAbgFiSF6DWteKE3HQuNBK6n0301E9uMdY5e48cCjb0q9en
	 cBz3CDPb58li7HRkb67AF/RctpON8mZ6M2WcpSfLnE1Hp/QuclXpoedwNIpfQtb034
	 yVf37SRkLjV4w==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:02:07 +0100
Subject: [PATCH RFC v2 26/42] xenfs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-26-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
In-Reply-To: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-mm@kvack.org, bpf@vger.kernel.org, 
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, 
 netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
 linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, 
 ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
 Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, 
 linux-kselftest@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1019; i=brauner@kernel.org;
 h=from:subject:message-id; bh=FUjiFAJ818KMfzd+kfIYJM0T6xlI1Tybz/61rTbofEc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iGk2ymq59kHLQ6h8olLRV6eCMAf3indWE33bRHYYG
 yoaf7zdUcrCIMbFICumyOLQbhIut5ynYrNRpgbMHFYmkCEMXJwCMJEOK4bfbPpa60rvXBGfN9V1
 euu+TdOP9GV/muPCcL7yp0X8f6GmCIb/wbNO6i6ubdGYUd+54ZleikWZyucDWjzxvCyT2fm7JCz
 ZAQ==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: c61ikpgn9fmom3r51n1w5g78asjj1snw
X-Rspamd-Queue-Id: 1332FA000B
X-Rspam-User: 
X-HE-Tag: 1794661720-452584
X-HE-Meta: U2FsdGVkX1+7IJx7+1LRjTRvW4srPHxq38uOtTjQmb2LfXdGlaeJzASbqK84Juoh98Bo2gUMsXXJ6DFWPrUQRjZsx66fj/xZcizokqAG7dYsy1IlNQCe1Daeuo8Osn6kTMS7s48zGY0u+NcIXkpYErqAKqDQKCnxdlMKegrlOGmJQ6M7aIOG74hOwxLs6jgk0GHxgaYaSsnhHn+FUg4xFzSzPo9dW9uF2smEgRK2GicZvV+pKHyIfPlWZWxXdyEfb+xil90BBdAfu6N2G4P4xE9VRcjJzc+tjcMb9oEn+rlhi2bUn8AdU1ZZGXvnm+Rb7Bus4tiz3IYhxOHEjiqegSVyH/2Y/H+V6RnBIE9J8EWUNujJORg7EdYOKGRjZOJZiZzRuc0Sgv1uiaJfi/yevwDHX7yu8AsMFnW5ZqFcd0V/kaCaQo5hhDoE2GWOGT74EJyS3/vvegJzn41drAshZG/Ykbbf5cYatVW/XLxJlAu7A1svcy6thtHwHucCsskCub07pundvzMatIcwUmqBFcV6yJ2WANzTb913Q8xu38ffByMCukiYZCTyoPPHx1zZzrJb1jsmmkiNa78ud88sRZRMNGplxOz/7q3KoWCa29h1Liz6pC3akcKdr5CK5OU39/kr7vQdui2HBHxUCT2thfmwxTFmdG4RuoDpkqGAIQBxekcGZvHoHJURUfPx/nJlzV/Ywlx7tg3KZKS7iFir8MXPVxG7NzI6SRqAXo9W03/gf1jVG8HaW5vNlmyh7b1N+YW+0pSybDgR2UsmDqsjnjPBQt108pOtY4FktPBseDVbq8iA/SmrfE09N/EDecT1m/RNDpl9Gak0IpLo9YTn6WXeqO92groKtbRPGd46/pI5vgrn30bpdFvVByvAjgwDhH6uqp7HlB2k1ZgbC5TlTYob+c9rJUr3IHkDz7aEsyeTB9vBfk+B9cSJebUYhcV9dejMU0DkPbOLOYSS0dg
 yfs2AiHk
 ZwqKPEGTph2P0HJKMTmqPlipIbYQnSC+FEbDN/q0MTfgCND02oEcm3zhSQaqqEWO6JOCsri0OmM2iLHBtmJ6yVNrpMCqcJzycN+aQ2YFUTyyIhNJkiTvHJ0ehsr4/NS60DCyDa5rnspHyODox7YDP1Eg5LBX90eubufKesasrwN5LOrn3yGsVu16BzYBmvgpQNZAQdivV5/mAHfS9uwvFJwZQBH1U1rv8PR9KeX9uzArJndAtrvUvkH90OnEnWAaNuIMf71UujG7suEcAWv4nwkdzcVk3Otaco7lCrrcNGpGvi6+AxZjCmbXhFnf0QRy7mwqiuURmsPM26ubz1pAOalO5xCsIojsBficVZQ9pyDVqviSlE8/UZbxlINpNz21i7NOleUWcSK4gNRUBZCAJpCnybnEJtScEZ9OBjwqbqYZ3/kYjGZjBaqtHBrK2mxeE73yb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize xenfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. xenfs never holds executables or
device nodes.

SB_I_NOEXEC also refuses PROT_EXEC mappings. xenfs maps the xenstore
page and guest memory through privcmd, both data.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/xen/xenfs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/xen/xenfs/super.c b/drivers/xen/xenfs/super.c
index 37ea7c5c03469..aba7d038ed735 100644
--- a/drivers/xen/xenfs/super.c
+++ b/drivers/xen/xenfs/super.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/magic.h>
 
 #include <xen/xen.h>
@@ -80,6 +81,7 @@ static const struct fs_context_operations xenfs_context_ops = {
 
 static int xenfs_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &xenfs_context_ops;
 	return 0;
 }

-- 
2.53.0


