Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F4CE6078163
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QTUtfoyG
Received: by kanga.kvack.org (Postfix)
	id 760A16B05D4; Wed,  4 Nov 2026 14:31:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 737E96B05D6; Wed,  4 Nov 2026 14:31:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64E2F6B05D7; Wed,  4 Nov 2026 14:31:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 41D166B05D4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:31:53 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BAD351C3FCC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:31:43 +0000 (UTC)
X-FDA: 85398431286.19.8FAA287
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id F2428A0011
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:31:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QTUtfoyG;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iNga88T+PVpZfmycjurDSPkD9sK5xR0SX7kfbe+Tx54=;
	b=vL1bPkOa9qgsMANygg9gUkHxgAidsp8O1/3JMXgovO8yCOioD9TOTYtmqpnCBu0/TkUfDT
	3lre7/sVilfkU5iaREPF4CmNicBHWmaPmTT/+65MW9YoGChyYm4RYU/5bG5h/+0/hV6/fs
	G2v2BpwQY2RnRGgZVbUpauZSUhRpf+M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820702;
	b=aiAqR3b+TUVorwaYGv1j6tHoKZZkpc7IqpHaTGD9t5sSL10IClf13Apn+JwWPrRDHXcstw
	QmoG+gq4qsJ0Njjjx53oLhdJuwHq+0CBIzROx7nNHN/Yi7ijRSotZ7p7L/0NBMcN5H0CoM
	k330qsylvXfp5LHdv9C4I5jjPHdq/0A=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QTUtfoyG;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9850560D8B;
	Wed,  4 Nov 2026 19:31:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C04D1F00A15;
	Wed,  4 Nov 2026 19:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820701;
	bh=iNga88T+PVpZfmycjurDSPkD9sK5xR0SX7kfbe+Tx54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QTUtfoyG9KimBN6AkuRRVKxf3yuHufM2Wi/2H06w/quFXdhMDoJ9b0J6ZGIpIGDK5
	 z976qLZrwGZZUEOM/2QIyKDbUKj8FDXwDBDduM9rT2JEpxfbS5W9S6Mm8PwwlXubYy
	 Byfx1vCeM6TyCBhpgKK3txGGQOhUx2gc7WMApbzBGlSMkxBhA0OSCSFLxKPNEU7q0h
	 FqpNY0wnGJwPDfBnXRKv+pXROQVVMWRvXSvePhYyYWGDW0C1FBZKM6snqSFwxIPGpL
	 n/TNrzyLKLnTrYCGsUsu1BjbO8fvjf0609ggkLleGQJeqlMRkm/wkvB/Y3xMoP4jHN
	 3X4C+LMwgRt5Q==
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
Subject: [PATCH RESEND v2 09/23] proc: let procfs own the seq_file of DEFINE_PROC_SHOW_ATTRIBUTE() files
Date: Wed,  4 Nov 2026 20:31:27 +0100
Message-ID: <20261104-work-procfs-core-v2-9-76ace653a773@kernel.org>
In-Reply-To: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1051; i=brauner@kernel.org; h=from:subject:message-id; bh=asSZ4ovZjSippDtL33YbhRRNyZXb/VmTI9lzg7rupAw=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bq/5nqVqXtG267Wf70TxqQELt9YvquFOrjuo9Dzyi bzbsaDujlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIm8Wc7IMPEii96mWaJZ+q4z Be1mv1zvuTjM8YLV/BfT77Nf3z5H/zQjw1zRTpZdUeKsERs+f18mIsCt+iZRS73q0Q+xwL2+7nb POQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F2428A0011
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: jjy95amh8p9ckw4zzacxe1qo67kqroby
X-Rspam-User: 
X-HE-Tag: 1793820701-796464
X-HE-Meta: U2FsdGVkX18T78Q/dBmOOyTardgr+18t9u/C3DSrNFZF+oQZbpzEC3TDHzEgkiUaNdh0/1CB9kjIRN9QRWM3Z2Wlc99jpQD70YGJ7aJPHlgOhjrpNhoyqKmeguEuWWAnE9VNU7qvNzshZXkPqm8p8SSel8F1mTm4CzQTb3P9bto6roPPezYTLMf14yYyMOgHu+WPuWdd5JZcReA7rrDpIvR5Ri/seqzaHTHVG4c8PHs2D6SpATX46iavACGSosk9dIa48d+ypQZjpbx6IXLJTs2Qcg/dCf6o97R12MBSozmUqVHiwbo3hWvfn81cw6T5DBvgw20okI8g9XHd3apxilpvqmT4zB0iLtW1NhwCXXG3YecziunFWlRIwINp1Tq+vZZ0HWwSNYOBiaUIUu68uvr7dLptEQd7keJbYhRzd2Ub823zbNoo5jKKKkIXPo/oRPNVHAw4I59d+kCwgL1hALWPowvDr8caYVlVoZKfsDCrhs4OWp6NXViGSmvpGjJA4hqniZQcxBEeq1HwXYQWCrds6x6kXaO1+qGzIdmnsXCsij/kNfbhUdW1oQjBE81dh3TgrOhwZav6e38tJq31yaZgV5pLgJcocW5WsYGfpBW+hcF+4CQLf697jylwRcksmQhfU4nJ2e5uFmgXo/N0dG/T65Mc3gAuMAR3si3zTRhVmr427q7StJfkFFQz5ok2GrCkMhQ6eb7P6kyYYfcB+lB94/Pj8Y6eSWrEkms+gkwt1z0sj3s3gjPF2kxeP4CJqnwFArm3yhH4nDGtUPD33QcWNHWiXno+f1cLhcmIWDkIvMCWuh0izWosB2tH58jU+pvw7bAO0sXao9WHJXsZF5uOZoR/OngsTe5vXGIlJrBqLRlYLmhvECySgci5qkZGQ0/fIhpDJi9ok7HWY+IHtEcwAEYXgvkn1+4en2ns167MiIc2QSm6AURs9xAEAsRI8xnyezohUJ/8mEHMDCt
 VeVjTJcM
 AymGCIbUdxs8eDCx6SA/Fxvvrlx3XaIlZCr9124V1FvB1vampFxSg4aBqQKF1Ht9SHQCrk6NPaq9iLVLQoZkGGPd7vnS6YW9fryxrO/WykRrjd4wm+9G6MLGjQyE4ReDmZ9VrYwpdjvdjoww3GY8V1JHrSnsd+VqWArcPZBpmSRwslB14P2Aa+dgoGdIi45jR3h2u6RYayDaEBwNv2ySTB7t65DXIT5VKFT6MNqVSyS21pEn23be+FtQDpsxW40wqViGXNT30b9yizE+2TulgB9Rd0/xN+qnS3gwrWu99ia3CgJjjQSztfkEpbdBkCuRfrBJSvCkmD+0IuRqjNe6mj6oJSMN+kZw1VYUgjh4D15dQjXXkR2873q7lB51NJjJFIhtXReEcrooCZWqx7prZP2/DCO/AgZT5R+CLh7Ca6fDfnH+nJ2E5EDhBtpEsHqxF4CY0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Declare the show function and let procfs open the seq_file.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 include/linux/seq_file.h | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index dc0e8c62d9e0..b813b7e63d89 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -233,16 +233,8 @@ static const struct file_operations __name ## _fops = {			\
 }
 
 #define DEFINE_PROC_SHOW_ATTRIBUTE(__name)				\
-static int __name ## _open(struct inode *inode, struct file *file)	\
-{									\
-	return single_open(file, __name ## _show, pde_data(inode));	\
-}									\
-									\
 static const struct proc_ops __name ## _proc_ops = {			\
-	.proc_open	= __name ## _open,				\
-	.proc_read	= seq_read,					\
-	.proc_lseek	= seq_lseek,					\
-	.proc_release	= single_release,				\
+	.proc_show	= __name ## _show,				\
 }
 
 static inline struct user_namespace *seq_user_ns(struct seq_file *seq)

-- 
2.53.0


