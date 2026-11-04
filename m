Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EAE0606BA37
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m4qlh5ad
Received: by kanga.kvack.org (Postfix)
	id 9E6C16B05D4; Wed,  4 Nov 2026 14:22:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BDFC6B05D5; Wed,  4 Nov 2026 14:22:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ADF36B05D6; Wed,  4 Nov 2026 14:22:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6648C6B05D4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:22:22 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E1F7B1207FE
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:22:21 +0000 (UTC)
X-FDA: 85398407682.27.A10F555
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 393F7A000F
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:22:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m4qlh5ad;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=frXlYovGKxKiSN/Oj3/IY9GUET6etUhHzbC1M94LuG8=;
	b=eLjoUXXW7SCTlzwjdojYsDonPKBAg1xawBrnXHEVZZPGJq8cKCHLEVQI4fhCsT+iaOaufh
	k70DUTs5htPHBkAI0UMkmlU1w8M5/B0rC8bCdbcM2mMPIMaQhGEvA4mYy2eDYhH/JVb3eb
	ZK9KbLWC6U+IKhbsrdsPqy73muA/zgA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m4qlh5ad;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820140;
	b=nXiLMJjrqD+s/+eyE7j/fXq9OHx+AnSJS53I0BNKjecqoMT1aDldOqLO+VvbhEETfeGhba
	on6OhBUEiPGM58gR1HAAKO1jVII/lynlF8fTCfN6t2QWSot6+V4gycZW6hqDybPMBg5e7M
	W/iLzw4FBe6tVRUGJfBe57bEYIYgZYI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BEC3B60A77;
	Wed,  4 Nov 2026 19:22:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A39E1F000C1;
	Wed,  4 Nov 2026 19:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820139;
	bh=frXlYovGKxKiSN/Oj3/IY9GUET6etUhHzbC1M94LuG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m4qlh5adzIihmnlMCPV3MfzvM9clEODdoNPI2uMqY4fs5tXjOCWDUSzu6mv2JPcnd
	 rIPr1zKO2U3CjW3V1MIfmNbgfh1n07E+bfpMs8tk02/3DnE87bHvJw3d0jbyRKMVJD
	 IyG1TCJ8IDfIKO9zXzTPhcHA+ABY+MPRa3JEdRoY9H5TpyzNGzOxFD39D4e/nEzri/
	 xV3khedTdJnJfO/uoKUxMN3c9AMOVj129ZcQ4wKqGT6ApGnU+0jvS+ZI/4rijimnGb
	 2/KGqEkHg6aA14vgzVafdv5HLYM59RkWvexV7pVOwnU2YNnoy7SUAi1RAXlTmBHVKt
	 aZyeLWcmGYS+Q==
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
Subject: [PATCH RESEND v2 25/51] wifi: libipw: don't return 0 from writes to debug_level
Date: Wed,  4 Nov 2026 20:22:05 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-25-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1059; i=brauner@kernel.org; h=from:subject:message-id; bh=PSZyn/5j7f+UAGnOkF9zGJ8rErtLF7uTzeHltQyv5ig=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bny1/eaz260dbT8unLZwrN5tXTy3yfvErX9TPsXMM V8nc4f3WkcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEjHoY/iffUCphqBDzD6jS 3KKZ9/nt+Yxbx7kDk6dL8t/4/j9YjZmR4beq8vlDlkeLZQ/dKD+x8ZzFnrPzDR5/5vD+ZfFD7WF 3CS8A
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jcg7o8tm67q1j3sy74bw75hqbmgs8c68
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 393F7A000F
X-HE-Tag: 1793820140-721121
X-HE-Meta: U2FsdGVkX18O4LqCre3G5UX8YXS2Tsg7woSdwZ3e00AMoIw9sz2hPF0IFB23AgvLJ2PqrNC2FVfCqT8FfyJ2xE3abdUUO9R2Rrfw4KYf1RgFco9CCXFhJeQ2w7BvMoruwByqMTYStGGS6oTgPnVKxg1HdCYUR5H8P712j+IayvbCtcaUl2ia67snpJa50kyTWgZUwqotM0EDne118+dkA8WfjuQrLiIAruGz7QWMlDv1WWI4BGkv3l5YRgR3AZoEdAW/ehxm3LyU532jKC6gDdI1mWaSGyodLE6/E2PUOD31k87o6jOaCOGiVb/7mq1rKHuEolxvTsWiCyaR9N+vSGWG41bTFcCBu5gCGL8TQL521j42CCtilE87EK8NR9utm6yC4r50UpHMdFKZrL0zkxQYdcpqj5+ue9fuPeOX8ZJ0m7qL6j7BxFE5fyKKA62e2RjAnTnIX+S92IbpZejuhJO3AQom7a5dzDCcBx428w+5iH9fYMmtx2SK7lIf685aCl3myPEypyv7z7iI4fxsI1VMEQyx9RUKPnwFfjVSGqqX2WQ/DE+9gxTDNFM0s/s7GreTRw5bdKttifn15hT53xI77Derqek/EvbDuDb9mNXHKMhCzRSmu7aK+6yWmFPTzB+U2iAONThFDKyKb8+A3ZxLaivPCrBBHfja4CBh7e2zm5bC06zeJQqw5C2uzd6PjqfQSyzjcPAxtUOxR7lQLSrejd+PDvs5DfqVk3zsER2dpfDNkA5KpqKCA0sN6xVe8jW4KdShPNQBXFkIHStU3s+5fiGCQZZZHlDcfQP+U5QNaBplcep+TeYQP40XZKX+HQ3Ov/f1s1AyWi4mSmN2VGOW1ujOwInGdGR1/an09xkL2p1hzzSUdRb7p5tapjQHL2tss5PVfv7GBkbVzuliVqDpWwph9q6TnXzJTyZXn7ek7wWMsgdrEwE8WqcDN7sJ5n0khVzlUYjwmWEKYq7
 d0VAr4NY
 zdTX8teI7lDxvTEuBkmK39jNrjKUGiWGBwCbQ5SfumJvb+Z+AXR9wTLYfnOBPRO3H2+GL8f7S4FH1lvEApIr27ZUtXfohOYK7DGgXaYor+kuYgT0AKR8jD3xRaf6ra9V8AdfUN0Bf/TMhjqhkLxo06DEbTQxgXjQuQIQMKKejwGmpaDca4ELdxA5USQWHG4iPRJfiBCahH9FbPnfGHRoydat9tWoGpAq9DVxs8CJ9uF4CGqfpBANdZGut9w4kzw1nkYa2fHvc/9AproIFp3v/K4QePArfuk3Z+VmWXWS6r2ZfVTZ5xlX+n9gjeK+Ogx1pjjo4bQIJsJ5SnAukb62X+/+BRTQJyQbg9ZGLFF71ZgBnWNdrVt0jtdB5cl5pA6CeSXb7A8mbE9QPmxloJ5hl4pBCIYToFx4n29BbuAjsHuLiSMAmyaV/e3ada/ovggBQKEmuggRWOJ6Dcn0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

debug_level_proc_write() returns the length of the string it parsed. A
write that starts with a NUL byte thus returns 0 and writers that use
stdio retry it forever. Return the number of bytes that were written
instead, which also stops writes longer than the 11 bytes it looks at
from coming up short.

Fixes: b453872c35cf ("[NET] ieee80211 subsystem")
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/net/wireless/intel/ipw2x00/libipw_module.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/libipw_module.c b/drivers/net/wireless/intel/ipw2x00/libipw_module.c
index 22358b2c2ecd..552c8ff3928b 100644
--- a/drivers/net/wireless/intel/ipw2x00/libipw_module.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_module.c
@@ -236,7 +236,7 @@ static ssize_t debug_level_proc_write(struct file *file,
 	else
 		libipw_debug_level = val;
 
-	return strnlen(buf, len);
+	return count;
 }
 
 static const struct proc_ops debug_level_proc_ops = {

-- 
2.53.0


