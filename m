Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FA6D606A844
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Da9qhDAh
Received: by kanga.kvack.org (Postfix)
	id 7C1DF6B05CE; Wed,  4 Nov 2026 14:21:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 799406B05CF; Wed,  4 Nov 2026 14:21:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B0E96B05D0; Wed,  4 Nov 2026 14:21:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 47CD66B05CE
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:21:23 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D4EE0A82D8
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:21:22 +0000 (UTC)
X-FDA: 85398405204.24.0FD861E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1313A4000D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:21:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Da9qhDAh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p9+kMzHwjVYuWJQ2+obB/IGMwn7xV7y09JcSQ7GHv6w=;
	b=dBA+BKegN3LLCpVlWhOnUrg2SFX+4Fy10wX9feqUeJ7XdjpcG+VxjoXHqnCjBJfz5UohXc
	MoflKr58wpuWQtgOKUWwAnReyy8bvEM+mbIwF0dR27zkYPjGIoh1m2Zs535YYoZOULLeqt
	mroFFD1q/SRMQ7VXIKrrBVezLaOsqlQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820081;
	b=T8j2ZTsEqXk3lgCbszDHXN7qGvVH148ZXuLwFd3GKWUQ+F6+/Jta/lh4okIIkMlbHJiB4v
	mXkfZU/ikVnaQaiOm5pxg97+dXDw98vJKXbNbDwpxs5566ym5zxvXBFHjNX8Bay/BxHIge
	mvbZ/vnZuvFP8GOTdMJhwfK6UVtdfQ4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Da9qhDAh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 76713404C4;
	Wed,  4 Nov 2026 19:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AB7D1F000C1;
	Wed,  4 Nov 2026 19:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820080;
	bh=p9+kMzHwjVYuWJQ2+obB/IGMwn7xV7y09JcSQ7GHv6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Da9qhDAhe1gMlC4H3sEx9s8bGAWOfqOAYoq5Ueb9q8Ynl2389Maztmcp2QYHP5RUa
	 OZi38NVuKARinV0XCKJY4csd2ZWdhTyFIQtFYAj0HTzWZSV2i1vKEm7P7/Pts5FZCn
	 QcJTzEeOU9QU1jpuc0CN9kj/jSPx/znq777Ooa0/kAzqFdLCFoQLN31MunMZ6V42ul
	 zYUXtsChACfm6Z+hTrPGrAKTMgQ5FfXYR+IE5qTYw8gsFIqpDD7UrTt1lKIhy24azZ
	 jz8zin7Ffk74C14OK7JkiGN0Jj9FrbP13tt/L09oeijZ2cBW9SHXjgz22CRX5WoLnO
	 SiIObxm9KtSIA==
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
	Chuck Lever <cel@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH RESEND v2 21/51] powerpc/rtasd: zero the error log buffer
Date: Wed,  4 Nov 2026 20:21:06 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-21-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1050; i=brauner@kernel.org; h=from:subject:message-id; bh=mkSbMC6ZDV5f4P2v+qDezcMlza9tkw/MXVPMWZSeje8=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bnx60+3VpD19ZT+7SySmfPjO+TBTt49lvc0+93eF3 4WPq6Z96ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIlBCGv0LG0fo2q8pr72Sl RxoY7Psg/0D2YuivaZvXryurm/TnzyVGhuV3JU9sXMk96YvRxJhvUz9Ozgtes07tY8uDXTNaVxx jf8kGAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 69k6p8nx54dgkppyxa1p1akpebh55odi
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1313A4000D
X-HE-Tag: 1793820080-161839
X-HE-Meta: U2FsdGVkX19rGtyjKuFw7Ycd2lF3Q4fe4iQNeOC1QAYJtall5YchJX6y41tt8thPJ/mklxd5EO+qwc9dBZLP93OGJQAchfcfepLaaLPYTgJCg3OQyLXj/+EfHQV+vSNtFi2WwgErDTiOeVGFjGExylIcKRDE3hQQUY6oeOafHItI0fEvKOVCr950LufAXwuZznls6Jm3enFuAqWsvm4RMDuuNNpgwz6mbBsG6uiSRApJonnhYR0kDN7oum6Hu4Kp6zOM3diaaCptbU7DRytfO36q1ymGUQNBT593v80QPaw+NVhkODRCOcrmcjsYL6Mwroktv+WcErjlqlsDRGZsBcZFgIauBqfITbkiEd5vsdZcbuCe/dDC3QQzzL0WkqheA+yvt1yh7jMF+UcKnGNsDEtSnlq2RtqFQsXOuxvM0ppOijo4neFHz7gw/pXbtWXHld407vIe0A8ctewp2qV0JvSLSuNvLO3wGjcffYE9o2kl4dlnSgGwWGSJFCHi9OHr3jKYvtRTsLr4VWNTmKzD9Sx0RJ4lRaPR3huHPz6l78EuN+ZT7NwozHE/VibkOA701vj4ZXv5ZkMiOuqnep6KRpZEKCmHtD5IPwajJDZZqC+rKG4YKdgzZ0jy1NRsgiSrjERqctP+E31ayjLdoqxE55SpHKhMZuAMZ4oBFoQXb6UD9/hjbHzk4NQ/sI+TwPsl332PFRp8maFWvXxqJe4EP/mrVK8iDDGSPqOa2NsBmlA9+DLVrpWk2Zji21EBnAbN5EBfHwZd5KNFCbcQxW5Rw2HSvs44pBkOq8c97xo0RqyJCaaZi+QYRG+UUsu+this73OSVL6kZCvQypiMRZfQed2I6/Sp1azjutaVxiQeNU3mQKpq7GBiionHfFo3+TpnkLCDILVgXSzkMHX5N7lWCdpa4Ys/qdIBtLejLCjnrJpiV5UqREDJUFcMhNUWnvLBDb8LY0reyidqb7+e6YU
 kY+k9gOy
 f1H+faK08PtoWYXRBtPLhANAXyckrV0z2cA4yNvkg77wBK5Omi/rX/wVqgmZ8lME2HyqCbRcYvsdLT+HH+wuOdSJj4/XMDL4QAXNCu8a7MyNkKokUBUUHj18wXWnPmSD+LA+YLaUULT9MtLyyX3X2mtVOe4iCnYzFXpKWy1m7WIsBAQYfeJ5dlBX9LeLmyyIe+4DonLmICZOIf3NT6sVI+SbzvV90Xz54ZJWA5q2NhtoAXnwJO+ctlErKqrcLXmgP6j7G8PXEJ/3bZP6A5S3oJa+FIl3OBBZplNrUstMkkRR1Ka03tKNfg690dbnYDvS1zNRXXY7j96wvhKxH4PQ7CmysvMyaWfLmcjvnthozdmreoexpRyLINbUgtnPVMIAFe7cLIQ4xuMvngt7anZfJLgc86rbnooUvVztA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

rtas_log_read() hands out a whole slot of the error log but
pSeries_log_error() only fills in the sequence number and the event,
which is usually a lot shorter. The rest of the slot is whatever
vmalloc() left there. Use vzalloc().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/powerpc/kernel/rtasd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/rtasd.c b/arch/powerpc/kernel/rtasd.c
index fd40864bdb70..dd0df5e164a3 100644
--- a/arch/powerpc/kernel/rtasd.c
+++ b/arch/powerpc/kernel/rtasd.c
@@ -523,7 +523,7 @@ static int __init rtas_event_scan_init(void)
 	rtas_error_log_max = rtas_get_error_log_max();
 	rtas_error_log_buffer_max = rtas_error_log_max + sizeof(int);
 
-	rtas_log_buf = vmalloc(array_size(LOG_NUMBER,
+	rtas_log_buf = vzalloc(array_size(LOG_NUMBER,
 					  rtas_error_log_buffer_max));
 	if (!rtas_log_buf) {
 		printk(KERN_ERR "rtasd: no memory\n");

-- 
2.53.0


