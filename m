Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86D79606ECE8
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CCicy7rM
Received: by kanga.kvack.org (Postfix)
	id 8EE536B05C9; Wed,  4 Nov 2026 12:30:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89F196B05CA; Wed,  4 Nov 2026 12:30:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7679C6B05CB; Wed,  4 Nov 2026 12:30:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4BBBA6B05C9
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:30:59 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C94551207A7
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:30:58 +0000 (UTC)
X-FDA: 85398126996.04.667A034
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0CB3C40002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:30:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CCicy7rM;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793813457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Di83VHF6QbwHOpQhBimI2/C2To6SvYozNijzJKB62VA=;
	b=sT/TxjfFFx8dwlK96B5cEcnJz4Cg7W5no77mM5lxMsioUfb9D8HCLwPRzG9VUeD3W28f20
	aEUeFCl/Uo3b7lnNbX2cp1Eu3E6+hsakbKokJZAROcSjyxfoqh5urC325PPeg9Es4szyJ0
	xEqaVNsOrQaB1XVo5LHVQ+liAPOSbdE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793813457;
	b=eiDFLBxWpX5uHz9Gl9+wNGMeJcCVegqp/z95JN2NLx0RBJ5iIFBuBWEH1QnaWyjjD7RrKb
	5U5VOmGb/cKJATtQm55rhbM/U9Kg3SY6mKaKcAbQhzv/UcJKL6Sgr4/71AAkGFH8o2TRT0
	ZBTu1SFJmjvVYNO9PXpHVrhlAY+ocAA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CCicy7rM;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 54FFC4344D;
	Wed,  4 Nov 2026 17:30:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9536D1F000C1;
	Wed,  4 Nov 2026 17:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793813456;
	bh=Di83VHF6QbwHOpQhBimI2/C2To6SvYozNijzJKB62VA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CCicy7rMCCS60ygYj4tSP1y7JHeKnyohxK7RJ1MNcpLuKgx7RMIE9WBSxZSdLDPR5
	 klWdssG6lHnFI4UhtcT2/bxBTP5iwXEnSAAoqSD6pDT2Pane2TS1v3grlrW47TjH1j
	 9xxJKmZvczv/N+A7HlZXgnRiFRlRTmumn3d1q8qc4XOVhwR6AjNsL5hraO3EYgRzFf
	 j2hv3F++yHVgsp3epyVbuoy6NgYxM3knX51OJ5qkY/LQry+yFicpcW82pUIGh7VqAJ
	 QwR2l4cPAGUmHdYKORImPlXf6iJl3BbEIOeaBIzBx0aUmCCMa+g/IRmrE4JNBKD2k8
	 TlAkQuo0eyxfA==
From: Christian Brauner <brauner@kernel.org>
Date: Wed, 04 Nov 2026 18:27:27 +0100
Subject: [PATCH v2 10/51] zorro: size the proc files like what they serve
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261104-work-procfs-bugfixes-v2-10-bbf7d5546809@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=796; i=brauner@kernel.org;
 h=from:subject:message-id; bh=l/jVDuzMOjj8ie0SJoZ9zbu/qnGtbORxwaULd7yJNic=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9zmadUZ5+11/xl3DfvxqhE4ceqNydu+rxl9BGo/OLK
 ie/iz11t6OUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiot6MDIu1ajiC3xxb9fnR
 +WcXFsd8u73oyPr694eefAy0U8iPmSHM8L+uTlSf4U3pBv/GqQV1N16tt3wgHZrdlySg93/xMSf
 ZKjYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: 6rzjqa7gysg99qsux7yotpo4wh9c471b
X-Rspamd-Queue-Id: 0CB3C40002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793813456-239806
X-HE-Meta: U2FsdGVkX1+QjAgkTkXwdvIlJzzJc2M/FxWkTTDLdUzA6idkdXH9VQ76pV7kiyvdp/Ifu0Dsie1Zxc1x0mqP/JnEI0GCq1Ah8nxUiDqkGLztNEABG3HtK8pNaTACdpm9hXXjYUOECVxNXzD6oUW1xR1PUOroPpHnq7FFoXiraZ9HuhED6AGBxWeHeGIBKohEdc3qVmpmK0QbVjXn064LD5C7ASZm4TKxinEqvA8HQVXbYtaEhU1Zw34FXuSFuLsK/rX8MARdy3M1NhJszYWZEF/HekQgwoPih9rUnU3FdKLyzbjGSu7gPwFEOcS56KO1bY16+aSeEa43i1gavWU1eZDkIgM+u69Hd5cfkoaoYs8W6p2is56QmQn82JuDYBRyNwl+9xCC/A7OeQxnlFq7up6hPI3VPPxjwU+MrDNX9cv8K/OUbOQa9W1DeEhCMiykg4PrkbVNqAsfhM+oD5aY+t8GJNRobWmDIQR2sFhFImgk3YTjCHm0VrzFWJm+xC9JwZVH7w7Q2X0s4sM7lvJpGPfyiN2hkrPWtgoiYaaXkYFBbiSZtylb7LdvwLAW5ycDIlZad7JEDmBEiE80QeyPSx+oqYSyNhM3wE/dieNaGNJ6EXZQl994Vb/6kCOfgWpUdw6nDj6P7buMmt42pWPFiS84kb2A9nug52vqv7dmJ9Nrae0LjXqHJWBhfOJzWFjzdT1suMCgCouKLwvbNCPx07kIgdmiur/FVRZ+hpCBU/yc+CarZONy6+OAHse0VdAInS6RZah6/Sz54suL7CJDJmP5kV+6TSq6A1nOJdd+yPUZVw2qmCdi6bXAwEboqP439wFqDT9fmtx1++kz5kOUE1aRs7aRIg8iqg8d3to3ingV4AxHl99qAkQZ6ewo7tH3GRV2oxHNnfFKKYfqEIF6t6rElUXpSWCevfIWZVWUJPkJfH0854nfbUm3aFjdWH2ksOGWfv1rqojvQJKoFRp
 r4FN27QB
 1blp+GjJOyqcf5wRt2nwko4+oeEIhogdCqucViRiXaMROBiKM1Hhli6r2b6TshPlTliiGNouDWejMf9g8m0k3lnk0H5LHEGLdfr2KMU31smLgEfloBaEEsatQOzTLHBYbzCciBQuMQffoSwWbcRgHLvvc0x0Cgr8sRNrpjA5UO3ZUpFn5602ShODRQG6yQ3pF7ybkpMOnZQGLMEJ49wpGxsGUbpeZpiGG3jBLJFXlhvNemNnMrlbp4QjvgszSYst8arJ7HNpJLppIV7kjMgBRNJEGD90WPMEJMjXh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The files under /proc/bus/zorro hand out a struct ConfigDev and seek
within that, but their size says sizeof(struct zorro_dev). Say
sizeof(struct ConfigDev).

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/zorro/proc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/zorro/proc.c b/drivers/zorro/proc.c
index f916bf60b312..4c6f8f1c4d71 100644
--- a/drivers/zorro/proc.c
+++ b/drivers/zorro/proc.c
@@ -108,7 +108,7 @@ static int __init zorro_proc_attach_device(unsigned int slot)
 				 &zorro_autocon[slot]);
 	if (!entry)
 		return -ENOMEM;
-	proc_set_size(entry, sizeof(struct zorro_dev));
+	proc_set_size(entry, sizeof(struct ConfigDev));
 	return 0;
 }
 

-- 
2.53.0


