Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6609B606A337
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Df3TZq60
Received: by kanga.kvack.org (Postfix)
	id 90E2E6B05B6; Mon,  2 Nov 2026 09:22:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E5EA6B05B7; Mon,  2 Nov 2026 09:22:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FCE46B05B8; Mon,  2 Nov 2026 09:22:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5D70A6B05B6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:22:20 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F05BAA0011
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:22:19 +0000 (UTC)
X-FDA: 85390393998.30.007226D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2610B100009
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:22:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Df3TZq60;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793629338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pGKkc9crGkZecPr8vk7TgMVLcv4DpuQHsFCpp4FMbY8=;
	b=XMQno2WRy9bYV3Vk0X1Kh/DIFz/n+11qkehSJzM3eAlSWqR/FRG6YzbaBX1oh7cllzvFIF
	Hv/0aniNs7Tco6g4S5jpFpi8MElKYK5N0O3Q91tGLgT1Ra5D/Tk2mOh9cKl+yVo79GE72u
	G3/s12F4TXCuGmHW8q1F4caoe+/EPJQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Df3TZq60;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793629338;
	b=FIJUsRmdUIjeXydq9r+wM4se/FdaUDdYrGemi7F4H9vIErU74xcf1N85oRL33nxQe8AHqW
	sTsSJwwMo9X5VLw7kBQ3/mWV8BPOn+B3CHL/+r5G1suWdaezw/gs9YkMflP4G5q/Kc9cu0
	xBC/VIlq173ut4PKsuPZ0A4M/+5GHr0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 798CA439C9;
	Mon,  2 Nov 2026 14:22:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B385C1F00A1A;
	Mon,  2 Nov 2026 14:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793629337;
	bh=pGKkc9crGkZecPr8vk7TgMVLcv4DpuQHsFCpp4FMbY8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Df3TZq60vzd3Ud6sHKXoJyOdQDpB0y91AXsdElaLXcBNikKzPy/szHHI0/CwhfdRn
	 WsM9i5bSUctcGEqYeXI7QRDxIUmUu6UVak83Uv46oMzFfbpgzCr7WVMlJ4BZ9J3HMW
	 AjiG1/VEQjOOGRPDINpgdmcZyMZLtyj1mgE1Unq9dkmYqFAk/CpLvDVWQcV09cYgAf
	 ujO/67H0xCQCJ6g61xa0UOqeiUbiLYXf42d70VBXVhX79yB82XPCpH4/p7mnlrDBHD
	 DpkuL3OCzDyMvDM0Y7nF2tWK4aAoLW1EUN7+2jUNhTpoMsfy3rJmuVaCfP3vQoVnEw
	 qrmaSSpx2GTbg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:21:17 +0100
Subject: [PATCH RFC 02/38] PNP: isapnp: don't read past the end of the
 buffer on a large pread()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-bugfixes-v1-2-59422ed3e465@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1282; i=brauner@kernel.org;
 h=from:subject:message-id; bh=r49sdX7Qo0uBjLpgxxQ+IVLBreEaXwT40T2nEujvZRA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9mJN1Oevk86ly4dxr5u5ckPH96NsbLxgkniTHLPuY0
 Ppb4oDwx45SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJ5CsyMpyUnxT0MYT7za6w
 DL3kKeLy+fudHgfx3zRQWh2/9tvz59EM/2MUrjVNN51Y9MLwwibHKsNwxzdPq+cE1u3LTEhIn7J
 PhRUA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2610B100009
X-Stat-Signature: d4syhhprzzomu5u34e8z9uxtzq4ufs7u
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793629338-115021
X-HE-Meta: U2FsdGVkX19qkK6jVU+35T3s3AGzTSlyapXi72grERU/RvgKTDWZEbzZCOMPXQbXNi7K51KyVUQ2guvry9A2uaKChd7ki96pPjAvqUCnXNDh93OqpJ0bp8QEtnJekEuWCn7PVH40voZ5v3TJsjpQJrWidJEXRpjKNsfXTdqC/+ECDHnN7xMxciWp3N1xSHvxR0MgUiTisZuQD2EwXP4fMlFi0M4/3Nu5SEq2j6/FViONikHor4laPvpE4Hm+DDTQ5ViiXxD2SCfmb/QN9GW1haoOF8GDA0U4o9cbSG4h5Bm60PWVBHxXA6RONdxiFPdqpi6VHQg0oZ9OdIeAhCpp6QPE6oSxzRNByYNgX/1/ZVToZFv1TwseRO3Qwi1xeE4RwytrWoDfq8aAi0+CP9lhewQkbqdJQKoLCrLC4TOLAd+AeEPGgNBdRU9U4sC92Pf3oARsg8WLuoIOtVEyl/Na8DxnfMjuGYz+uamKe2Lr7cmiFVS7CG0mf2vhuak0ngmorGkpQkCN1ioio2CVwgRa76U6XZzoFcjRcje2URGgKTnALvJh4pULYNzpO3pEK6ILp9n6MuuFoNgUN0AqMG9j6KPucvkzutXBh9HYFaVAKzp3x2zTumN0I5IRtE/mzAerXcSACw9gyv4mEi0RSCdJ2kC0IhIDWZzgn7RnHWhdRSTbs4sfYsHM7V0ZV8BwL+tPq2F10fWr43Nuxt+m1/XuKxlPDK5hATbaun7PI9deoTfHxTTWYKD5UacppT2CLKnFgP2+/kpMG7DDHcy4LtLHOhZUL59tvrlhwOnTB/IQiNamzVH0XudB8MnVb0cB9bbkpfnLMCuefa/hipgZQy1ZOOzEV5+72b5YQEuVjinlTzGTZd95NcFAR8qkOyRmw0mkrVWKt2Bq14pQV7+I5/W4gJPBHIcI2TZNtd2OSKOeH9OOtOB6r/oaVAspXbNulY/Th94IYZoArimhvBxsr90
 cB8eWFNt
 mKbNrtcWM1Ts3I22+axqhxwJpofzCDhb37lLXfUrTj+7u31LEp5ZUtf6j2ZCl0QoCZ8Q/R2do04dLetYC+1BJRcIlwx9UZ1EZQ7tx20hvW4/tzDUEtBCNdCVpsh7qr0wTsYx5mD5FL9F47a16yujVFQL15diK4jE/SBV5B4M7RjnFCrY+gBwejw+QQ6GUrIVKrkpDhxVPy7amMutGeWXrl0fVwvzObeD57+HMofTd3chGXjezMsd9/KTIApNVK6W33Gzyeo/DgRRjU8QfXvJ9C1h6b7x2sRpiCweBFYlKwsysgCLdtp5ONAJIxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

isapnp_proc_bus_read() truncates the position to an int. A pread() at
an offset like 0xfffffc00 turns it negative, the check against the size
of the configuration space passes, and the loop then puts everything
from that position up to byte 256 into the reader's buffer, no matter
how few bytes were asked for.

Keep the position as a loff_t and clamp the count against what is left
of the configuration space.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/pnp/isapnp/proc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/pnp/isapnp/proc.c b/drivers/pnp/isapnp/proc.c
index c1f6e6bd0eb2..8197c7f29743 100644
--- a/drivers/pnp/isapnp/proc.c
+++ b/drivers/pnp/isapnp/proc.c
@@ -23,14 +23,12 @@ static ssize_t isapnp_proc_bus_read(struct file *file, char __user * buf,
 				    size_t nbytes, loff_t * ppos)
 {
 	struct pnp_dev *dev = pde_data(file_inode(file));
-	int pos = *ppos;
+	loff_t pos = *ppos;
 	int cnt, size = 256;
 
 	if (pos >= size)
 		return 0;
-	if (nbytes >= size)
-		nbytes = size;
-	if (pos + nbytes > size)
+	if (nbytes > size - pos)
 		nbytes = size - pos;
 	cnt = nbytes;
 

-- 
2.53.0


