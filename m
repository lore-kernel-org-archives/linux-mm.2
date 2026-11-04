Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 534A56071ADF
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 21:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V7uflGoo
Received: by kanga.kvack.org (Postfix)
	id 761966B05B6; Wed,  4 Nov 2026 16:13:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7397D6B05B7; Wed,  4 Nov 2026 16:13:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64EB26B05B8; Wed,  4 Nov 2026 16:13:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 361776B05B6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:13:43 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9CA2AA07F4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:13:39 +0000 (UTC)
X-FDA: 85398688158.29.83EAEBB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id E8575160003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:13:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V7uflGoo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793826817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jcn7jVvcEygiBPhKNySOIoE9F539N91xJ4TgqDQUCP0=;
	b=xpBVe+RPnCPZF9n8JYf4Gv1QUdcXsUkjnzzWIMVUUNqWM/J6iDs7RFollBRFUqW+sDaLmy
	RVIMTDMD0mKCkCdNmbuG2iZ57YB25WD9Loe40gDARAvOvoAjjDdJ0j6j4oGRPb0qEZTou/
	fLZP6xgKj3RLDpLAGRd0HqZlTRH4DcU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V7uflGoo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793826817;
	b=3iXEmS6suLwGUr1QWV1m1KEYcSFgkgihIHdcxDurRQM+PQed1VGkk3ysc7BDMqxGB6CRJU
	5bk/EalG0UhWVGLLoRh9ij+NkVz0IAKyOId0vhM9oe5uHsdgMHjarvztR+6a3Ee5HeDK6I
	w6M4DFGUmOcxiXmPxsWrw95LveyBOGk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 783E2601F6;
	Wed,  4 Nov 2026 21:13:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890731F000C1;
	Wed,  4 Nov 2026 21:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793826817;
	bh=jcn7jVvcEygiBPhKNySOIoE9F539N91xJ4TgqDQUCP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V7uflGoo2J6W0Pkam2p2NQ2ygDWILS85YrEGrtDhRX9LSpjax7FTdN9yNxg/1nr/F
	 V+6mFIzh3/JJOAXY6DVlJDG4EpV1IqKbiDMaZqe2+mP/VD4uYvDHSHZdC+YPnvDk4p
	 B+fx/mBspdALJuO5S6++QQQg+yaKZfyhFe96p7DkhDOmjrSDCUkzL7D2l6jIRx9hog
	 t02UJbdl2o8LcfstRp/uZbtHAIBJlVxjfK6tVrDPho366mZ6VCIHILqfMZVkkl7EFn
	 VcPqHyjXoZJ1/HnO4R2TW6BDouO7Vr2s8cHixo92YGxXCqi5rLrqQLQrblFCpmhTUC
	 1HY2L3LLxnrag==
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
Subject: [PATCH RESEND v2 09/13] SUNRPC: drop the ioctl of the procfs channel files
Date: Wed,  4 Nov 2026 22:13:23 +0100
Message-ID: <20261104-work-procfs-net-v2-9-221e2437fed1@kernel.org>
In-Reply-To: <20261104-work-procfs-net-v2-0-221e2437fed1@kernel.org>
References: <20261104-work-procfs-net-v2-0-221e2437fed1@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1562; i=brauner@kernel.org; h=from:subject:message-id; bh=I+ev37oI2qOnQB50E4hs4C0vKquyHn0mn+uzhhuE9es=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97tO7MzO6bl7rnYiJS+98LnRI2rB8SW+2zhcm6VmdL mnzZE2COkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACaimsHIsCL/pkeQ2tMV86Sm GCnwci6xzri2a8OqYh1BgwP67+/djmP4Z6MoeGKi/4+z3/fFeyZzP/p6Min5j4995fEbyvr+l0+ ZMwEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E8575160003
X-Stat-Signature: 9chb45k7xesuwk4s5r5th4az6ejgmicq
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793826817-578446
X-HE-Meta: U2FsdGVkX1+DpIlvGya7FDlZ+dv/XMymbbhztOC+c/mcIs75k45x/2IcRorN9tlcVVxFDT06slPNtPTP8gxtyX3NRcyKJDLwhkQvS6xjhvpoOW2pXKQ32TJNlh+BmZONJoG1aOCEB4894kq5JW6OppEu4kBTX+9CpiA6OYAr1lN9hOln2BSlBg+e32bEjhvw2D0kryLx99sfHunBq3tJFAjSu4HkCak7qgvFBE/fWWjo5+8+TrwqHuvU9jnyriVuMoKg5/Hj7vVCThp0LiCv2ycNf9nu8PqFkjPtDMpHbxlG7DIYJQ2sdU2b7TU5f3GYKWVai3akFu/ndBnLJDn6BQH6T3G2AvL2sGGqetP3GtdcG+1lJLddIBtyhKxHkCnpjogzeL2u/ZD3/joM3hPYtBPKymr5vK0BDlmoYKLuDnxDepu86qAwaqmeospTRz5lJwwo5XSNsxlhCgnhqrtx27h6mI3rUTSYCmrw+Sf1l+rEiAPkULAloSZWHx81Ren+ktOIDdtwoc4YLgyS9Rfn6jaI24Gr1uiN7LO/uRlQ5ce2RSn/q1MUpgTvyXwqR3XFBYbS0TA1hPIRGail0kTKwGALpH168WiqmHybB9UirjFzWImL7eYjJCKCbdgOVNKPg7zgOlzofDixsj996257AoJQ+x9LZ4oPJCEHLfi6E9Ib7bRpQtllTXZkxMV3XKBa3zJkHs3eqC6ZbWqdE7fjJEMnRIceUlwkicRi01SfnNqwsVi5/PFzKa68oD3/4tZYZeG0kZ8Y/S6GZCfXCUcrCZ5RhINi0aw4eZMB7RCO0q7UwSy/NUKao9cHAW6jKd6Wss3DEYKs0Is6tYrJMcWZSuy/i6Y04rbu8/A+2ryO+ZuvcLtqRjtzua/dVomDpjbU2ERs0wyVvv/hSP5/bICxrfdVwFQwAT+G1B/MH9/2cCgB3Z7mDnKMg87b7AS7u0jSxaiBYW+KIiuSYBFd2hb
 +/wDu75g
 yakwTG3V7czNVSmGEcWzAan+lf5mn1bNWXBLy3gW2Wzzx9mC2PgeRflr1eCQ2VmbjiRzke0b7R3/RjkvE8TB8/yGjqYE1uDb+3doOa70WdbdUb3+kTXjIpsY9RKL6887lIcDIXd+xANSCxzOUokJ5aSgsKkTdp2sfClS/DTebS14399srlDI+snhcZMe9XyEYLxFuOhwiDQhXCmYwFXtaeSokaSyMAIGinck5pdzv2Vqad8a3UeNW0ZRK/7VzPfRzi9MTYukZMJhvCamI3E9wEey4ZAgI9oNRnvAKVUH2HhDXp9LpcsO45p3MVRIpU9NctYYUPUjAb6lHHtqSEF9G+Qv2hI/gnBlPtdWRS+8kE7iy5KdrZGDGEwiDJ2AWbXIZMHq67+NXnc0RiMzI0nF0vQYHGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

do_vfs_ioctl() answers FIONREAD for regular files with i_size - f_pos
before it gets to the file's ->unlocked_ioctl(). The channel files are
regular files, so cache_ioctl_procfs() has never seen FIONREAD and only
ever failed other commands with -EINVAL. Drop it. Other commands fail
with -ENOTTY now.

The rpc_pipefs channel files are regular files as well.

Acked-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 net/sunrpc/cache.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index 81a3f0068f36..d242b6f33cbc 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -1596,15 +1596,6 @@ static __poll_t cache_poll_procfs(struct file *filp, poll_table *wait)
 	return cache_poll(filp, wait, cd);
 }
 
-static long cache_ioctl_procfs(struct file *filp,
-			       unsigned int cmd, unsigned long arg)
-{
-	struct inode *inode = file_inode(filp);
-	struct cache_detail *cd = pde_data(inode);
-
-	return cache_ioctl(inode, filp, cmd, arg, cd);
-}
-
 static int cache_open_procfs(struct inode *inode, struct file *filp)
 {
 	struct cache_detail *cd = pde_data(inode);
@@ -1624,7 +1615,6 @@ static const struct proc_ops cache_channel_proc_ops = {
 	.proc_write_buf	= cache_write_procfs,
 	.proc_write_size = CACHE_DOWNCALL_MAX,
 	.proc_poll	= cache_poll_procfs,
-	.proc_ioctl	= cache_ioctl_procfs, /* for FIONREAD */
 	.proc_open	= cache_open_procfs,
 	.proc_release	= cache_release_procfs,
 };

-- 
2.53.0


