Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB91F606AB34
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RajwCGCh
Received: by kanga.kvack.org (Postfix)
	id 18AFA6B05DE; Wed,  4 Nov 2026 14:47:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1623E6B05E0; Wed,  4 Nov 2026 14:47:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0507F6B05E1; Wed,  4 Nov 2026 14:47:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DC1576B05DE
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:47:10 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 80025120764
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:47:10 +0000 (UTC)
X-FDA: 85398470220.28.BC9D962
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0595020002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:47:09 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RajwCGCh;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zft31zEOyoxpoaQra2tyBUnsx6CBcNbPccBHjIcKUVg=;
	b=jVyHfejSfC7QWxKPYoGHJH9LO9UePZYRdnqN67E3dWn+r1ghOy1x+iMNYB552pjbb2UbSh
	4hz+ZyO1A7BlWVMTXxKeXUgN6op24X8E655SefIlmY2FcpR7++FeCwruciQxcLDy02GQbf
	8ncDd6LmAZEazcKfdff/HP0OE4c9IcA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821628;
	b=Y9WTib9/otevyJJXQW7JoOWDZU3uGU9Hmp8NY/iQaOqwHAYFR7xpblrvQr3G4OvDBmZXBw
	OevNhNxk42E/5fhIkK5zKq07oNjZUBDE+Ua4pg0U9PHhSXkLwzDwuttIOgeQePbUWhXksr
	78ZjLoihKYtX4paSgY3LQeaz8UZ7aZ8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RajwCGCh;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5CF4D60F12;
	Wed,  4 Nov 2026 19:47:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A421F00919;
	Wed,  4 Nov 2026 19:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821628;
	bh=zft31zEOyoxpoaQra2tyBUnsx6CBcNbPccBHjIcKUVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RajwCGChuwyoqoZXwpUtB63CnfJNCXfYV3MXWhfQVc5Ev6XMozMwlvc6X98vleQyv
	 f9HzBE4v113NX/e1l78y5ttqcWo69gQcs6Ww+sQGKZ3cLiPEcmIedv9Dr8Fupfzesw
	 W2qdod9xWoMSOmx1XAyg2z9rNs/8Jv2qrPox1n/Zc4FZI6mKO77lTmc1CJ+0psYuJ3
	 GAD2h5/aLL7ToIPisurMJ320J6bxgj0LUdPq4xrjzKapKKfnTHEzSVwuWV6kBmMycE
	 p8oPLiWRZfJASR8Mhh1/kUIyHucEcqRy1EkK1gmQTe3G+tur6Iu40MBhi/iT5cSWMY
	 VmRs6TTIcG5Ww==
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
Subject: [PATCH RESEND v2 19/26] wifi: ipw2x00: let procfs copy in writes to the debug level
Date: Wed,  4 Nov 2026 20:46:53 +0100
Message-ID: <20261104-work-procfs-drivers-v2-19-245e54e87116@kernel.org>
In-Reply-To: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1605; i=brauner@kernel.org; h=from:subject:message-id; bh=SZl2laNUZYNGFN2sYGUP5fs3tBGCqMuq/D28k7CZWwo=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97up6Oev4hMLPxsZ2136FuR12SNXk+zJzkV2eLvcbC +ML1Vevd5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzkxyZGhh+zNh/MzVMol5A7 Oltna15SsRRnwKr/s7+v+ix/vNn+yDaG/x5P3yxp3xP3fKd4vL9mjb/e893xlTemrnQuFzt//Ms bC34A
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kyi6uyf5k53sigpu7nriagdn7osjm4tc
X-Rspamd-Queue-Id: 0595020002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793821629-857654
X-HE-Meta: U2FsdGVkX19ekWHeVipvgT8oaRuxX7McfLE2/Ny0/WqGISn3tjcNX/zM5o3kHflTY1DZsP+LROKWybaFf9VhE8C91ZY9qR351jKqSbGYe6hvmxw33PtTXW692MbOjZElbH24S+tTNIMKe9bGxZGe1x2PfTxKp9gDy9CXn7+4vk5rlhz/A6qDK+JQhc/X+buj7GZFZABQwrOdidZBl980ohZbp15ufumY9fliPYyN0Ry8lQC7D9Z3iEUw1X+Y89VEHGLPN4Qi0iy2EFYx4xe+V7SWVFKP/3G5+qNfnLATLRohQx9JKFqw7ZXAUxRKHAZdXxz86c00Pq7SBlKgECiCZuXJ6mdjDyjfonui/EBXoapaTmSWuVSw979+iKoEY4aJnxwA2yqivr0DKwa5OOHJvGKc6qOxG+v/Yb5s22M0py9cI/SXPfO4tomH8fmQiptceTYtd0BbPp02sIrQ3Dq0yAGYVqPxFDxaWH0TXSwt0dej8G5L5qQH96ixPUAZWVSllV6DUm5ypdPIOez6aW+hf2nafUS+o0FZLKQzep2mbFVzw2hq1NFuEgLP63uehu13pgCfpM/fA8STdMNV01ilfat/Jon0H13SQxTD3gZr2zCm+Jlf2Pps84kC3UEYP3hfw4dhuaXE/a+ncUGj89JxgMnYC/ro7uCRD1jwKzGmQZB9e5mJ0PWfWDUUzAFPPevVR/C7AtzB6e1JkW7RpCMzDHdjTe5audTC+THIhpmzDARHUQ6Z3qwAFTDZ/m4GkB+flSL1xwVELAFApSDpidzuXxMSyZ/y1GBYX6Zu+tdeGXStASzPjUbk30RzU6yjm06SUFTcGL22vMDzP877P1f6oW+RYB2b0WZqgRuKAHM08tdJJg9ZksL7P6tY8z4w6A582f3stZpSKhw/DzqFzkcpCqOoTksO+jFTaY/KIOmcD5zQJtoO69uWHLXPbhViVQ+VokvIP6NjbrVx/FQCHBX
 It0Lz1zx
 4o7qpzYhQ1cwfL9BTY5ykSL6NMdI1A3chqsbVCy6IPAU5lstSQl0X6B2rS7/VBd04cnaySRH9DhUpeisiLycQpzzd6+Ro42/n8BppA9Z1xg695iBmJsi+2RAr/ooWjzx8T5Bvt+FDdjUCkZtQR429ESuLI1FGPbSOKWulRSYaMQqF5eJLxnthBkwRb19aEfWEzHej8DbiPSGXAcHepWET4RjnB+aA6LxIZEzLdHC9pp4ZSBrpLIFw6XAF89Z9BHsPd21wzUPk8s3iMYmYVLjLIzVZ3TEBooL25rsLj1PEkwYT72rU9U6aXtaNipEiLeKB5Czbes0w7id8ygsU1RRlQtKSLhak1rndiHceXwOxyyYeRNmW+HVsYQGnHgumWOoMXZk8nmYb3pxeTUzBbAvR+DC+aw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() so procfs copies in what is written before
it pins the entry, and parse the level from that copy. Writes larger
than PAGE_SIZE - 1 bytes fail with -EINVAL now, and a buffer that can't
be read fails with -EFAULT instead of looking like it was written.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/net/wireless/intel/ipw2x00/libipw_module.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/libipw_module.c b/drivers/net/wireless/intel/ipw2x00/libipw_module.c
index 15d9a5efb581..08cc0d7f57c1 100644
--- a/drivers/net/wireless/intel/ipw2x00/libipw_module.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_module.c
@@ -216,14 +216,13 @@ static int debug_level_proc_show(struct seq_file *m, void *v)
 }
 
 static ssize_t debug_level_proc_write(struct file *file,
-		const char __user *buffer, size_t count, loff_t *pos)
+		char *buffer, size_t count, loff_t *pos)
 {
 	char buf[] = "0x00000000\n";
 	size_t len = min(sizeof(buf) - 1, count);
 	unsigned long val;
 
-	if (copy_from_user(buf, buffer, len))
-		return count;
+	memcpy(buf, buffer, len);
 	buf[len] = 0;
 	if (sscanf(buf, "%li", &val) != 1)
 		printk(KERN_INFO DRV_NAME
@@ -236,7 +235,7 @@ static ssize_t debug_level_proc_write(struct file *file,
 
 static const struct proc_ops debug_level_proc_ops = {
 	.proc_show	= debug_level_proc_show,
-	.proc_write	= debug_level_proc_write,
+	.proc_write_buf	= debug_level_proc_write,
 };
 #endif				/* CONFIG_LIBIPW_DEBUG */
 

-- 
2.53.0


