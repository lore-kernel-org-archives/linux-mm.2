Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B4676071A10
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iWisENYU
Received: by kanga.kvack.org (Postfix)
	id 859F76B05E4; Wed,  4 Nov 2026 14:40:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80BB26B05E9; Wed,  4 Nov 2026 14:40:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D3F36B05EC; Wed,  4 Nov 2026 14:40:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 447756B05E4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:40:06 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DBED340848
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:40:05 +0000 (UTC)
X-FDA: 85398452370.13.3997138
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1F927A000C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:40:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iWisENYU;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821204;
	b=Bg+3CUOCWA/kHn/NjlN4+AYvvztWmIw3OG9nQKnX4DeYT6CEQNGB34MrRldXWhux2JcZvt
	yA+SZ4idsiWXRO38PwGwKZtnMtMXN8ESsQiMGGdaqx+t/A2VnvO7cnT5C6KbwZ57vfjgpl
	bOlWzHWDLnvIJM7o8lEsIONlqcuLsqo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iWisENYU;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I1miZOwU+uS7OyZJ+vljGqgplXbL3g+w9Z/kHpw+0Ic=;
	b=XOWJVqcMUimASYgyQqQRcMo2CMmxzUT0ws5kghx0qSvx9n/GIPndjUws7kT/gu7B3RSlte
	8BUwPpJTODo25F2UO9iWFdkEKG3ZcOV+k6Wu3G+VGCW+V99wo0x2mH2ESyPYfJ5e1Trr9J
	s7eBOJdT0Zdo/IPQ2vF09dq5pbAzNIg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BC3D160F17;
	Wed,  4 Nov 2026 19:40:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 400AF1F000C1;
	Wed,  4 Nov 2026 19:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821203;
	bh=I1miZOwU+uS7OyZJ+vljGqgplXbL3g+w9Z/kHpw+0Ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iWisENYUjAJsAzBSE3lGImGvChgp+BG03nV/9zJNmEmVEQqMUuspDJmWqJOL8vdCY
	 oHV2GpTw7nzhZ8YSayGsDUlJzGRv0ThytArIl/pXnKxEHGqUREbYMyptK2QRO4tWb+
	 0MJ2nNe6OsnVhX9kRXAgGrur5t53VezJ+BwOWZY1lK1M/S2AcooFeGbuJTcHh6MMK5
	 Q0olsGHFDarOPT5Tg5XxJr8bNViO7g5QRvPbnb/bbKcsghMepoAlwc9fQuisDpBdNj
	 xEFmyHVac3X4qFr6hW2l+JvJkyvtiVxI0WdyYW/zK53nj9PA2sh6Z3KYMrD0GYvMbO
	 MorJYVNGc2nSQ==
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
Subject: [PATCH RESEND v2 17/23] xtensa: simdisk: let procfs copy out reads
Date: Wed,  4 Nov 2026 20:39:48 +0100
Message-ID: <20261104-work-procfs-arch-v2-17-2aeb952c9597@kernel.org>
In-Reply-To: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
References: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1498; i=brauner@kernel.org; h=from:subject:message-id; bh=lmVHOivhxd1ieO/qCxQCbfFgZys6nsQ8zrRpqRkdZ/o=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97mTUYCmvn7tj1bZ3nRPePsj/znEsO+Ut/5eb7fKhN Rlbli062VHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjAR3UKG/45fU9K/nja5HyLM 7nljky3/puSce6cM0zZzlOzMKnx6ch0jQ/vS7+rz7ONa9NtY1Yu1H+1jtI6Tci9wC2pP5fa2eZP IAwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1F927A000C
X-Stat-Signature: iynjsjru4nuntsfwueasrtx8rewwsyqn
X-Rspam-User: 
X-HE-Tag: 1793821203-802710
X-HE-Meta: U2FsdGVkX1+hdy1N+Gcq0L2m08yvq6OZ2+Z+Q3jlPoh9L0FUQbMhY4B+6dkTvM0OEZI3uXHcz/ap4aP2hQiCbyLphqrSrAfI3xThkPkx3gBsDQ1wF18sVzig+8iJTsGfZkQsXg7FMrGQpfsxacau1JQYg63fCJ6aQWWXE0zqJxYD+0ZU6TUJK1+NjNNQR/GKLafZcZFrtCelyDB0PJl3MH00GugHOw/qgrIZPjlppXfLe76Pi3vkwX9xJJ/BE8BNns8pACMhhQsX/cPdmOMxLj0Rx4U/XlJCb/OukTQ18cirwZkR7cjAIH/47TzwbydVz9f68pK1pPGiOZZKtpxcUMCkeqqEyfUoNwldTi9bqTwvKNuRnM81XhIqRgpIdYkPIpaHlAcWFaVKMGRVzYU0e6RTWWMVFUHLjG43G+vua8VGPgWUjmz0JKmmA8LOTsMbkdoJ18Z9XspWCQ7pnW+f6qa7u0nKUlGtB/LMGDfoe/Qs1YJpq+bX/CusjYNAHMQ6F83tWPjOxSikyMdXsXqwGnE9teUBSaPeNyNIgT/E+4oDuixCx5CcEsfgkFLwaxG2jYzkmizB6v+ROCNA0JWOnZs0Et3+KWJwXykxKctNpC+aM1A/qufjk00TGmPHbVQ54mUoNIoOy2BfPiiO1NXagifLTkuzFMY1B2dGN+4b7WPREz9mR9pOgprOFc9FMJ82SJI0PaMS3KaIi2AGnhxBiT/CQqFahbC0ArhAUYHefadeP4Q93MQNiHHbqmdCJRiJ29srPRKGAVbPKqDy7RoHywz94RMHLPoYCU+CXmqQ60w40mRehhFiEUc9wb/tfWbJnymSrTj/yQpqQBFeQxyBO1hwz+l8zzSne9TUTxyoiiAGTDbfekBMz2lSe5bZ5+dmovETAzRcvbWpyojDmR7MeUO/oorAhA7cKQ8yQGU9eJApbCldr2FBH32GGyXyVoscy1SUB0uj1/qpkIQpnqk
 ZHaHWqpR
 yKs2Z/t/Pe6c736nCeZV7VhMR4ggfrQpqpRj25ACnlEK1k692yzGARkT6zX9oOOAHj4mev0hWFj9tQzH15i/n2fKc8utWkdsem7OWH1Cb1n/7S04BZ6wGYt9A20LZATayKqaP3CLyiaC/lJQ69ciYmIqpbruf9vsn+irFWM46NgGFfRkP1Z06F3Jkog7ayGbejpEpJF53181l4qzg9XJJyBxopIkdMZF4mPFHPjAKPKienYA9FEkg5Lm+NSURPI7pB6qYEeuOB/SwzNRkVaBTCuf86IXjzn8op7fh2OPzwaZ9sY1JSXWFDRiAPw671gWsbjvn3YP7PUwE5JYVR4oga+L/hmzLQ6oV6wD2rNCK1vPxhvqPNVqcUrQA8hN/WUJa2EaKhca4ODEwiuq2dsVb0VQ9dFrNNftVxLuA5u1W9VhGTf1B6oC5saRyabR/I5CjHzRC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_read_buf() so procfs copies what is read to userspace
after it unpinned the entry.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/xtensa/platforms/iss/simdisk.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/xtensa/platforms/iss/simdisk.c b/arch/xtensa/platforms/iss/simdisk.c
index 26c2fa39a66e..cfddfcd06be7 100644
--- a/arch/xtensa/platforms/iss/simdisk.c
+++ b/arch/xtensa/platforms/iss/simdisk.c
@@ -234,7 +234,7 @@ static int simdisk_detach(struct simdisk *dev)
 	return err;
 }
 
-static ssize_t proc_read_simdisk(struct file *file, char __user *buf,
+static ssize_t proc_read_simdisk(struct file *file, char *buf,
 			size_t size, loff_t *ppos)
 {
 	struct simdisk *dev = pde_data(file_inode(file));
@@ -250,7 +250,7 @@ static ssize_t proc_read_simdisk(struct file *file, char __user *buf,
 	len = scnprintf(temp, PAGE_SIZE + 2, "%s\n", dev->filename ?: "");
 	spin_unlock(&dev->lock);
 
-	len = simple_read_from_buffer(buf, size, ppos, temp, len);
+	len = memory_read_from_buffer(buf, size, ppos, temp, len);
 	kfree(temp);
 	return len;
 }
@@ -280,7 +280,7 @@ static ssize_t proc_write_simdisk(struct file *file, char *buf,
 }
 
 static const struct proc_ops simdisk_proc_ops = {
-	.proc_read	= proc_read_simdisk,
+	.proc_read_buf	= proc_read_simdisk,
 	.proc_write_buf	= proc_write_simdisk,
 	.proc_write_size = PAGE_SIZE,
 	.proc_lseek	= default_llseek,

-- 
2.53.0


