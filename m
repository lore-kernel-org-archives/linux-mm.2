Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 945116084423
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QnL5jL1t
Received: by kanga.kvack.org (Postfix)
	id 19D606B0624; Mon,  2 Nov 2026 10:29:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17A796B0625; Mon,  2 Nov 2026 10:29:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08B826B0626; Mon,  2 Nov 2026 10:29:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF92A6B0624
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:29:05 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 71F82A65A9
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:29:05 +0000 (UTC)
X-FDA: 85390562250.02.FD0932A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 97E80C0002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:29:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QnL5jL1t;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633343;
	b=b9+wRAuTe6y+T2CtxEJXRW8i3Yydr7olRvDInPrTKptXJdp0dJ84yNNc1FuXFCBfQKkgIX
	WDW/5ftm7/+FI8joDaJ749XrZRacWeulI+LqCP3nN5x5GVLduCWoUOAx8OIR9uaynxDPPe
	2ggcvKQCLFrfZM+T5x3uVfirKwVrxuI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QnL5jL1t;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LBl2/qBMA7OV4BMTYua5kVHXByvRuxQ8RJbkH2xlEeQ=;
	b=GUh/OSpCrNmdYiZ99OHu6Kf3acY2Gx4nTp3HSXGz8lQ7UZhS0t/meQggfTdbf0DVq3ig+0
	NGpMg9A/96W2wOvbIL5/hqBlr3ucqyBQUD/Zo9kwB6t3iHJGyXjQjZ+DBdFcXgdykW1Ch7
	1IjEvNqUpUwxvLfIChvmNFyWMhp8l4g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E4F21434D7;
	Mon,  2 Nov 2026 15:29:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66DFA1F00A28;
	Mon,  2 Nov 2026 15:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633342;
	bh=LBl2/qBMA7OV4BMTYua5kVHXByvRuxQ8RJbkH2xlEeQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QnL5jL1tEy9t9hIsQkt3LByuIJ882KPXST1Vc1LfQVpUOFVJmtPqDPl7tY8JHPxCJ
	 gmd8xNU3nOvuFGws/A+3+9aTACcobIp3siitSrYhwwkjrT4inswqca73nB5LOWSMIa
	 gGXXKRCwtKQRlvorIFYPQ52q/KY/Id1kGa70Dc9UqY5W8w1sw/+9eA4OWn0UomElkO
	 ts/p1SA4HIAxSUAqUU8NGTXimFKD4VawrMb8XauLcbSF/WPIlGbMbJJmy2bdk94vgL
	 YTHmGiUOat2O0htpE7WGC5E8Rhw7yB2cZi5Bs9hAVElqV814vjKTN39YLPMJBp43E8
	 SCJm5GLHZ5dEg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:35 +0100
Subject: [PATCH RFC 25/27] mm/swapfile: let procfs own the seq_file of
 /proc/swaps
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-fs-v1-25-d09a996317b3@kernel.org>
References: <20261102-work-procfs-fs-v1-0-d09a996317b3@kernel.org>
In-Reply-To: <20261102-work-procfs-fs-v1-0-d09a996317b3@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1169; i=brauner@kernel.org;
 h=from:subject:message-id; bh=xP8svTINdkdtOq03sFDyUkKM00LKGtRsGg97ENBLGtM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG786nVF9oWW1sqzD1ne711zwHqjwVq2PUfPRB8uE
 5qxxSg9q6OUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAi+2UYGU6ky8syZD9PsFvn
 wnogRfvDRWvVD16nimIPrPc107fJVmb4Kyb0Ma+ob8K8bRaH71p9WLH8S/zVPwIl0tHx/G6vHyj
 psgIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: 4ychqnzapao1khk4s3c7ebj8ooswsi5g
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 97E80C0002
X-Rspam-User: 
X-HE-Tag: 1793633343-51902
X-HE-Meta: U2FsdGVkX1/O8d2SbG+wYVlkMHlscHXZHwBickWQwPzSRbrdl3/myVoloEZascvGR+wRAWF1LNsLfj8Fg4dOBloe3KCyIdpCCCqIrVaKQWzB7g3mK+olj/e2mNOPgkC22/5c/07PPeykwONC/KBLlATKW6cSq2EmHvJK9rkc4wQ/pWKojUXc7Cl1tA6QimW5ByWrBpsRL27Y0LhJstX4ihNd9O3ragrkqKd7hod44Hd0V96CLUcnTrijE/zbH/B+Ox3ZwlPHtZceJH0nMrX5gX9RizYHZwVR3zFv/wrZPKiEJC0vqYvVfVB7tAzC728mAYwbQzw8nntWSwyyn0Ccqxyax3OFDR8XIxz3ryCjy9q/d7tI4HAJz27NK9WlOeIihQ+nswCmL2him9FVLZYtQr4UrtjQ0JQ3YFcUJQ5RaD8o+qHJvowiumQDFqNqC8RMlFrJrOo5d6lzQKGVJTstOCk50/dTqLuIUZm3kAFq+zpii2BXtxHQJBKmVmH5O7o/7ZCSyu3hhRsL0Jt2ynhfUbbiHXEFPl3lFftIm3YSsJaqQUx92Oay/qVn3lfKaUPIUQmTG3BLAuBNhd0QsRqHI2tdD661baMCTyYQ6dPEq05ZcYAqb6NBIFV1D30DQdiqWDc+ixOPpWZHDSShRrS7ov5ZKNCLhQU8SuzPCufysgJ9YGt0DjbwKXk29KjlGZnDWAyNTQxLunxRBIAakx9B96lbwotThyX1lev0vVFYX8bxONuMqJRpP5PoJSLebtc8PWaYRN9UtEqD5D8vxAkkZlz4Z/S1pckF/FgtSgi4cZQmlOjwqJUNz3ir+JI9eAXHE0l8Hg5oPAeszjbOIUCl0zcTMoNPJAvtqzfvfZdGUk/v2ac8IrBFQWIdxiWzu0i+GUUYG5PLqs01hpoE8lXaSgLJdzVvnc93w0VzhSL95Q6mXNYLI2X4u0+pefRkhkyVP+HaeudQcyupzEfD9oJ
 VSyT2z9c
 9l7Pjr2c33b7HJdzhqctoMxmsGVjzn+V2bzVqcKvXq1PPV4vcDTljywSELSSvrUFW/Nb93aJICRYbprsAanOiSLQqdf0oyIDyzmfVO2O+yQPJaB+nR0vzsyzf72yFk+lvfgqWyRXqqoOuQBVhGDyOA9sChNTWqLa5F9t3sCc187lJ7xuBhKsTs6HL3k/jHuntmWmXw0ceOAr0PXY91/up6XTvthzp2u2JuOCkL7VGV7iNczd1f9qT6WI0SYwKP/ePXq0sihCvh+bXoiKyeSlC6ZLS0ch9//MbymZ047IpYZAvjWrAvI6NxTax2QYEwp+FxhCDI3qKtDZfKto=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Declare the seq_operations and let procfs open and free the seq_file.
->proc_open() only records the event count for ->proc_poll() now.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 mm/swapfile.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 254ce86fa923..ee4868ecc3a7 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3410,26 +3410,19 @@ static const struct seq_operations swaps_op = {
 	.show =		swap_show
 };
 
+/* procfs opens the seq_file */
 static int swaps_open(struct inode *inode, struct file *file)
 {
-	struct seq_file *seq;
-	int ret;
-
-	ret = seq_open(file, &swaps_op);
-	if (ret)
-		return ret;
+	struct seq_file *seq = file->private_data;
 
-	seq = file->private_data;
 	seq->poll_event = atomic_read(&proc_poll_event);
 	return 0;
 }
 
 static const struct proc_ops swaps_proc_ops = {
 	.proc_flags	= PROC_ENTRY_PERMANENT,
+	.proc_seq_ops	= &swaps_op,
 	.proc_open	= swaps_open,
-	.proc_read	= seq_read,
-	.proc_lseek	= seq_lseek,
-	.proc_release	= seq_release,
 	.proc_poll	= swaps_poll,
 };
 

-- 
2.53.0


