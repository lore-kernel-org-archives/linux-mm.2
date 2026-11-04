Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CDAE606D4C8
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cG3jfP4l
Received: by kanga.kvack.org (Postfix)
	id 4AE8B6B05F3; Wed,  4 Nov 2026 14:59:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45EA06B05F4; Wed,  4 Nov 2026 14:59:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34E1C6B05F5; Wed,  4 Nov 2026 14:59:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 10EBA6B05F3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:59:24 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A83F54082A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:59:23 +0000 (UTC)
X-FDA: 85398501006.22.075EE65
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id F26774000C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:59:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cG3jfP4l;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793822362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fxIBhh7BKiMVxtDmu4/U+E0RVHzkWKjhatO8Mz/jm1g=;
	b=mg1ySUV1Fr+Z9y2dnH7JAE65Bc3mS1nblvqlsWd22YpZBuW5MFVqu3IEb9HbUJM3UbkTWh
	0wC7XcOQnMspid7dlj0j183sT4xBDT+Sh1m9Y/nqYMz9DIqgx9UbZdUAtW80lbf/iD+oQX
	jWW4IYma6KQPJPqxub5Acq6fDr2ApJU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793822362;
	b=0ARa+DJmb60qoEglaQRC+Bplv5Fd7I22sGI5RHasCI4Jk22GZeWGedjGtXrbaysJX2UAnJ
	apAm/Zxho90YeTztPaTcDopvrzSg7jtXSrVWdCtqoRcIyeQceMPXH2SpnuKOCvFUw3LuiE
	Byr1Hfe2MZdvFVM1/PrBAZCK226iKxI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cG3jfP4l;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 979586154C;
	Wed,  4 Nov 2026 19:59:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF811F000C1;
	Wed,  4 Nov 2026 19:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793822361;
	bh=fxIBhh7BKiMVxtDmu4/U+E0RVHzkWKjhatO8Mz/jm1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cG3jfP4ltLZ0emEodeqGyV0F81UQdOK9veUjoQYm4vphxyhicVcIAruAa+hQZp+vv
	 LuOy8c/zGjrkusiVcA2VvKJPewsxQtOI7YmD/bcmyRhjnxtsLluEEVPgV3DQNWk47/
	 mSdpjmiWy5tp6Q3PNAMQqcpNrwMMBVMexQqgPaJs3Iy/UBHTYwpQM+Lc5KFKqelFF1
	 ody93CB96hEImqNd69y/UCjV7GfX81amWcZ+7LnqODBl023Evc/9fAIcSNlwwSooaK
	 2T20X1BwYkngzdsHGxYvyb9SWZRkV/ciSqqkihKqF4dLUBJm1YcXlGUFPGXCxWvkvY
	 4eJobVyd6CS9A==
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
Subject: [PATCH RESEND v2 06/13] SUNRPC: let procfs own the seq_file of the cache content file
Date: Wed,  4 Nov 2026 20:59:07 +0100
Message-ID: <20261104-work-procfs-net-v2-6-221e2437fed1@kernel.org>
In-Reply-To: <20261104-work-procfs-net-v2-0-221e2437fed1@kernel.org>
References: <20261104-work-procfs-net-v2-0-221e2437fed1@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1629; i=brauner@kernel.org; h=from:subject:message-id; bh=psvvZ7JIZLE0CRNp8kUfwlc9JvUIb4uUwK5YCFxYJEI=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97tM6n7F9Us5PDZO+pQGKZ6Zs1PCcwb/5cVO9pcRsm 2mK1t//dpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEwkZiUjw8UVnRyhZ297By25 0hTRu+CuzNW6RbKizFpOAUYq+3ujLRkZjva/ZpdLVCpwYrJbpltzfc1blUefGwUv7OU14v60a1o EOwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F26774000C
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: mtiysuontq9oexs7t9jhr33q5y6wci68
X-Rspam-User: 
X-HE-Tag: 1793822361-434483
X-HE-Meta: U2FsdGVkX19M9ISExCzGy0csYC967Sw+c+rOO8wrjjSUadS4tt0stGNmLnWOHU+WhkvecRhJ8kPEkgihjIo8cKiWp3BdW6rtKkUKdwMXzcQerIG4urEUnCjZx0nChQ6T19+EDby3Hv4RNlJmY9mqkc1Z0op1RHKkgz7Tv8Xjz6hCyCJh5BS8yMBE3E+uJLpPSIO87hNEpqK/pwtgeKWOQSIuJ5lko7+KnSeWIUV5GJuXw9nmcGvUMjhswP0HJ6ARfdK5f9YZOebYJ92WJmJV4yYFeds6facLK1H6KW7TY2JEoso5aVb9igEbc2kOtDloLhdRLtcZQedL4bxVWaV6r0iaX5I6DKYiArAK+vwNCL0vnQmtw2r4fEqv8x3nqtp0XXWptBErjd4NI4htu1aGuC8R2EGUPwtdwyX2Ta+yBEEvcbsI4E9bDPWVvXHnUWXbbviqxmvkDU2oHsX/S7XOK/FzFrAHEuN2BH7xKLqGmybeTFPRnxXnTR89m3adY9oJ8XP8krCiDj63DArV6ctUXCX0BtsCVy/CenBDXdDHGUO6Uasky7qX3/MpEwwsbSE5rV0vTroJljdfzIM+9J+MB+3XDy6ZIQvQxDCauTB/OhChfLXSjIMNnsH7xnEFQn+XRwhvXa+skkuabKM38WIaSequr2kUF5guV8/zDDWG6xjMW+ncoRFDiVoyg8OEgI49AArikLJ7710cfjoHaeaGq8jZA+YCrw6MkQFx8ELXy7s6SG9JjrUuiF71N4HM+qeg+k5BOss904JKCYCpzgm70FtPP9KuYMQgjAmUKZUkkcVOI/28Fe/8Stj9HUZoyJIru4qDfNnRzXeXk6EtBMK5KRUje1/iQca0ciQdhgO0CzhLb/l3/lGv8M5kixeeyQvojG+rwPfX2zZxcJmwF8+T2OdjFp5pyyJksIN1NNuoxJfiGXp66A4iCfk8zA6OOR1qSgo2tKtSC5UpHCnBNo1
 L3AHe08v
 R4ej4qFsKNtyvWtIekmuTCmK5qahK0+R+++NmOFkye115LpWCBFDdRs1ZIS5rOQ/k+ux7VsqvphWNOZnEBICbYILBMyvWBzGcZlYECWK0nA9a+RKUF60rrQOj4vTPepdlvmT3hNPtNbmOCvldy4mLcGPUmfbYpZJVPkeqkOkZ4IvVLyq3FGpki2DZUmyDRwtIEdDFSzzXhJN6lfEVdQNinBBET6o7kepPM31YUVPkbhd8ZmrSFpc6+hqSEZlumoA0Wo6n/GjzmFcXB489sH26ZEPBx9rdJFGz5RwuLGZcxTBPUmJAexkG3be9TE9p5sOdzNjgBUzmwdBZ/yo8cd+nInIacgDyH9pcRoTsN0DKyXuSrHFP1pNmcKzcXc3QG/cBN8VZMOB2as6wuZkhzqO5qztjXGIn34/uoqgZljr40EcN+tcRTIvsHBvK7coWGIMy+6oA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Declare the seq_operations and let procfs open and free the seq_file of
/proc/net/rpc/<cache>/content. ->proc_open() and ->proc_release() only
take and drop the module reference and set up ->private now. The
rpc_pipefs file is unchanged. Reading the procfs file then no longer
holds up its removal when the network namespace goes away.

Acked-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 net/sunrpc/cache.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index 1ceaea7e01b9..007521e8a57f 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -1606,24 +1606,28 @@ static const struct proc_ops cache_channel_proc_ops = {
 	.proc_release	= cache_release_procfs,
 };
 
+/* procfs opens the seq_file */
 static int content_open_procfs(struct inode *inode, struct file *filp)
 {
 	struct cache_detail *cd = pde_data(inode);
 
-	return content_open(inode, filp, cd);
+	if (!cd || !try_module_get(cd->owner))
+		return -EACCES;
+	((struct seq_file *)filp->private_data)->private = cd;
+	return 0;
 }
 
 static int content_release_procfs(struct inode *inode, struct file *filp)
 {
 	struct cache_detail *cd = pde_data(inode);
 
-	return content_release(inode, filp, cd);
+	module_put(cd->owner);
+	return 0;
 }
 
 static const struct proc_ops content_proc_ops = {
+	.proc_seq_ops	= &cache_content_op,
 	.proc_open	= content_open_procfs,
-	.proc_read	= seq_read,
-	.proc_lseek	= seq_lseek,
 	.proc_release	= content_release_procfs,
 };
 

-- 
2.53.0


