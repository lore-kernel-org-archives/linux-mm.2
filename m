Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9E17606EE9C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=omYmnILU
Received: by kanga.kvack.org (Postfix)
	id 066296B05E9; Wed,  4 Nov 2026 14:58:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 016B26B05EA; Wed,  4 Nov 2026 14:58:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E22226B05EB; Wed,  4 Nov 2026 14:58:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC5766B05E9
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:58:11 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 60C281A0866
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:58:11 +0000 (UTC)
X-FDA: 85398497982.24.8747316
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7FA4F4000A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:58:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=omYmnILU;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793822289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8JYviDqoWsEGN3uNb5Mh66eaw6snQ2TUUnHcmJoMJ80=;
	b=5FaObvPhe1+ZZPogSOyI5I7IZNvFF8+wMPtATnQ3l4mIyj1GaNmjv476e2h9E3gqCrey6e
	v34j2eUjEYkuy//VCzT226Rug4BACOrLlU9OkTXdteyTTE0EDNBQJzYlMK1GtPkniT9zBR
	sCByz2yX0VJQhdIc8QLpjyaDtMRQKrM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793822289;
	b=xQMcK4BLaimuFNiJNsNsdus9z4F9MqGIpRl7nFTCPB3cpi/cGwL7jy1o679t+2YHEPECeu
	NT/UZCCFdze+LQzDwk02dLNoy43TStrWrOevM/mXnuY5LJf9uAKVWZdtV4Ri9WBPbtUyAf
	hwqN6STWzLT/RTFhkJhvw+z4VAEQQWg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=omYmnILU;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC4BF41AE2;
	Wed,  4 Nov 2026 19:58:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB771F00A1A;
	Wed,  4 Nov 2026 19:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793822288;
	bh=8JYviDqoWsEGN3uNb5Mh66eaw6snQ2TUUnHcmJoMJ80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=omYmnILU6n/a/8ypDuatFcm5Yn1YdJM3CRKKuli7fcBySnvTgN50xiis4mVllM49v
	 PV+Quk0y9VPAUT7onGY2p/nLF2xkGIDIWXqi4tkrhVP7JJganO4BAn8bDHMRztyoBl
	 kDuAQDvNJ8Uuc3JHKiaYHNXgDWLaFbsRCKaJ0zpPBvI9qjf+zzVVphC8QUnWa1gAS9
	 TqNqVumOE5u8pqbbZNrZhXFAdBkCmBN9rMMWYN4XW4rPv+P/EOoobKcvq4QxkXRKVJ
	 s5UQbq8xS22dtefS2Q7ckkJlMa6rIUtShtzwuWqlg+ImTJMyCWJ++E2LN9ezNnICps
	 7WSbKOm7NJ/JQ==
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
Subject: [PATCH RESEND v2 01/13] atm: let procfs copy out reads of the device files
Date: Wed,  4 Nov 2026 20:57:54 +0100
Message-ID: <20261104-work-procfs-net-v2-1-221e2437fed1@kernel.org>
In-Reply-To: <20261104-work-procfs-net-v2-0-221e2437fed1@kernel.org>
References: <20261104-work-procfs-net-v2-0-221e2437fed1@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1517; i=brauner@kernel.org; h=from:subject:message-id; bh=gPjf1XFsI8l/uiq7gtBYaOS5PIZm1WCyT/xvmcgXYrk=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97lO2Xbpnsl62nNauWplf/xdYPBNLEnswIafyCd/XX xHhEwqnd5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEwkTZuR4eHSqRGfps/7dvOV 691dX8+Wbls1oSJgtmlB5Vsb0VvvEssY/hllnXhlJifSrl2270GVY8Ldju5SgRBVQfPATZXl+2b r8AIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 91n6i14fqscf9yk8jeeaxsdsojufptr7
X-Rspamd-Queue-Id: 7FA4F4000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793822289-562716
X-HE-Meta: U2FsdGVkX1+hBhDPm7oJDKkWCY8lGkDBtSkzuAXf+Rgef+3i693oVrqx+0RwWf5d6354nwqwU7TRT/QR/icDIfjL8P+2GmCpsINMy6eL3UEld2jYMtPjt9SCqBgxwsFBK3BLOmKJIOtQmShwcujod5LGV8b1wOWzvam/6n6gEjq13RSCVbyrS4+GeOfEpygDOSHjMcrHsTXSMNOcAnUAfgylOAK0bzZhMsj/DqYNXINtk8DlVELk/hWeEAQOyaZa1Y9FDk5U9GTL5KiHDGwjFxcLCz857P6Wgf56EX8kO0Ttlowcjvov9mkkrQclBxtOHh6yOYuoozp6g9BWJALSIroL6xKozIAwauSSOJpEOr8WCSo7Mdm1/H7YQKXpGtOzfQF4accKfyXNmmA3/J2x25lnDRY5WzmbLrU8bWmErTAdYgYPMVk8p72r2kjH2L4Q57GkTjcZjDBwOvmPk3XvTVwc9g6iEEAEwxsrStcYWUNlXZZpO1ey53fPs+/dYc38Zx9TnWb2JR3nh5ruNkbqEj0xL/hgOqxBSWt26XtXTyycfCDbfQJYsvLu0LFrPQut92Cb50Hl29KOb/utPIScJPlND9uW5Ja0RJXZ46G7yKGN00ogN8NVuUDr8xbeubwlN0+Zahu/kTAbtfF1Pdo5a6uNeWaz8l3byA8ic32bDIFIR1QOMEtjnd8XcYCxke26c4jaES+9V/XJMRPENV+SRunJfe9S6FoB1A4uciDJOWMglLM7mm0vnv7/1FcaukRRT8vQYypjvbutV3YI33dQxdPnCU7K38w76gE22XjgEdczAsiAd01EiEillR3t+sILNq1RPvAn38bDdNc7TZhTK5eJWhGVeyEmTl1YmQiUl2IyPNUoOtnEbMMk26yImic1WympXDQcx3yazL+IB8idlFhM+3PFBEqcaFJCfQo8SXOClEJzAZ0YbmKyhWcUejNtgx4qGPHt6vIWXArnJ1F
 m7FMxMw2
 C2zcVjqzYBafuIWzG1V5x68bxiDQQHemG62MX1rWrZ860wpchmzDjTLqevfISUdXMr/LiFrlwIrfFyODHnLil1lOoNxli8DshjrBlWdVZfBXekMFw4DkbqHYgkAl0GDbf0jLOH/FmhLJC5PNITGRJR9HN+aWHpBsyuZKmaVh+oe7QJn7wu4icOBCWKFlevaej8EqBHPwUr7IAOolAOQAwTKKlVoPXEcrEGY7M08YAS+cBrp2xdtMdVnCwbobPma1iR9G6pO2B72kFMnPddkn4zcsYHmS0kn+BFCKktYUT00d/7+rdSDMv/0+0RJ123vMzB5r040lh8RXRMCE4vAkIN2JRXE7hGxduDunaAcrGu6uIMKmMS/Zcs/8mWH+ZUzgbbMS6GGRrPBo2weadXuQrvmEhiQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_read_buf() so procfs copies what is read from
/proc/net/atm/<dev> to userspace after it unpinned the entry. The
drivers' ->proc_read() keep filling their page.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 net/atm/proc.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/atm/proc.c b/net/atm/proc.c
index ca0fc6b90998..cea930b4b840 100644
--- a/net/atm/proc.c
+++ b/net/atm/proc.c
@@ -30,11 +30,11 @@
 #include "resources.h"
 #include "common.h" /* atm_proc_init prototype */
 
-static ssize_t proc_dev_atm_read(struct file *file, char __user *buf,
+static ssize_t proc_dev_atm_read(struct file *file, char *buf,
 				 size_t count, loff_t *pos);
 
 static const struct proc_ops atm_dev_proc_ops = {
-	.proc_read	= proc_dev_atm_read,
+	.proc_read_buf	= proc_dev_atm_read,
 	.proc_lseek	= noop_llseek,
 };
 
@@ -246,7 +246,7 @@ static const struct seq_operations vcc_seq_ops = {
 	.show	= vcc_seq_show,
 };
 
-static ssize_t proc_dev_atm_read(struct file *file, char __user *buf,
+static ssize_t proc_dev_atm_read(struct file *file, char *buf,
 				 size_t count, loff_t *pos)
 {
 	struct atm_dev *dev;
@@ -267,8 +267,7 @@ static ssize_t proc_dev_atm_read(struct file *file, char __user *buf,
 			length = -EINVAL;
 	}
 	if (length >= 0) {
-		if (copy_to_user(buf, (char *)page, length))
-			length = -EFAULT;
+		memcpy(buf, (char *)page, length);
 		(*pos)++;
 	}
 	free_page(page);

-- 
2.53.0


