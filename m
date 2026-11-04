Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 387FC606B2DE
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mXEJh7D8
Received: by kanga.kvack.org (Postfix)
	id 57A806B05D5; Wed,  4 Nov 2026 14:22:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 551946B05D6; Wed,  4 Nov 2026 14:22:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 467FF6B05D7; Wed,  4 Nov 2026 14:22:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2769A6B05D5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:22:37 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B6B56A084F
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:22:36 +0000 (UTC)
X-FDA: 85398408312.02.6E75C98
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 12636140009
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:22:34 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mXEJh7D8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S8IXtzTL1USde6aV/lVKsFPWulIUW0ciUvC5Tm4lMm4=;
	b=OtlpU6Ab1lArY/ozKw4BdhTIjadbyOqXOuG1mDyo/LJEa4y6pTanf3VGtMPCaTuIxEJHv1
	OKfAe9swNnIpFx1aLG+P9E3qEojAUm5JT5/RdQL8yd3Xrau1/rtLeB2W7prU8A9mZ0AhaS
	8BCk1HFeO0YHsSPJBx3GYoTWxsXzbF0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mXEJh7D8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820155;
	b=cj1i7T0VQJDqy069v1EiUEy06R88XG1Lnttoykbqs7bBuROHZjAWrZNMz9cMu/Y7IwL5wx
	mq4vllUB28gZ5FyX11Wn8bw4lrq/qRc3eYdCWe3C7eHpFzcMPTWv+u/OIwn0SWhQr/qyAf
	6k9OT/J6U3TW60QPUTzAq8B6XAVrn5g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A8B406061B;
	Wed,  4 Nov 2026 19:22:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 293831F000C1;
	Wed,  4 Nov 2026 19:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820154;
	bh=S8IXtzTL1USde6aV/lVKsFPWulIUW0ciUvC5Tm4lMm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mXEJh7D86UeSEY8jNu82u3NLmId2OsI/Nv9nh3XWpLINGlBuLP5Nz+YiwtOsAqIVJ
	 oVeO2qxhNxAYSigqHIpjEKTcnXIbhPS7yHKiS4GRdJ9UYEuLBunN2o2SvnznlXI6BM
	 F5O9M7fZaaFETXY9Ej5mVQrFRkhRZM5mDYAGBCUg69fzwRq+8JjZKWRp58tNqeKTw9
	 Mus1vHfCqkTiD6xzM+KlO6h9c7TF92UrHaTiLn5L+jl6joxLiUSdcubt7/4SNRaTm5
	 vJlimOOsTIbLAxnLoArtNJAZUqCCnnAwocr+VwIzPakK1nD/ZdjgCu3EIbAcmKwTRk
	 HrfU9Pt62XfOQ==
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
Subject: [PATCH RESEND v2 26/51] scsi: core: NUL-terminate what is written to the host proc files
Date: Wed,  4 Nov 2026 20:22:19 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-26-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1011; i=brauner@kernel.org; h=from:subject:message-id; bh=jBwXVCCRpDjmnAajxR/zAvEvmAtZKAE0jCj6+Cnx3v0=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bnztk+R5Surix3hvm7CKvXpyq57/KmExl721cvVL/ tOc37nndZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzkuw7DXxHBqOn8F95zMNyd M6k2rOaLgMESqZzyjQvM9reKiH4XkGX4X/ewceXxBbldmy+3PQ+Iunxzrnshe95/o/05vCxbvk/ mZwMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 12636140009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: jwk3mfhquyn5grdayfex6kosdkmrf4en
X-HE-Tag: 1793820154-601642
X-HE-Meta: U2FsdGVkX1+wADmAoz7WZ6IQIaSuJ4AOrbUSoIthgOicL9xllmRisonYEyOjewgSLdKZCzGYPQj4ue79f7uczaimh3q0zc3ze8pIMd91paC/AOyp32IVU5G+fTVuKOKOL64x1tN5ZQTsIf2L3RqeYoafEagE/QcQlwmrkrKzfAYNhns28arrT1qwYMJbOJsnI08HWGWYVKkVPzx6tdtSKe3ozg5kt+U7mZ//v4eHExMaWZBcfikKBGeNWg20FZsku/Q2krveO0WJtPHMmMwxYQ+tu1dPLqmIsS4qZUyYBeJbYbb681kFNi62mEh/jMoZDrWrqAHg/AbAQXnxa42hxLvITCIsThivibgqJ38nhIQWg/ga1OnQFinJH+AU7unLXgftpf5jbEVXrJaOH8JTjvoZXrrZeD1btxUBS7C/HEmmJA3YmbCLFCb/Z9A5rdCIx2Fx6BT5IBbmQz/q4U/hbXobn4GjRXQZTgvPiU5C0ofihrGpl42V0uLNb6bWRg3HNC8lJy2iYymjTdy8dwbeBl2e/J0fXMJEhAMWKk0B8XV+O3GTPIfXVp6Sb3tV7lBJczOduUjlqdq08hhNGmq0QoZUTVvz5/a93hOhlLLXO0ZXgLJI0px3TdegW0GLmB+DrAiZDmyIXqGpzn2fdeZ6nTh5YZl11N9SK8OSizy+qGmq23D//DV4ftXuhZyXiI4F2B+Hbt3bbofEyw9M0y0DuFROrLHVtHj+iLpZC3TCla0r01z5mTItDHDos4DXbSfjyNZ6OIkMMbsNzZI01nBiryrnNM5CclehzTZoefGZs9ks1CLAGQNCkF/iMwZyUVzmrUzDfMlHP8sxpNAIqItVe0OC3xrSQb8h/tC/Z4ieBZNuahcUbKP0Q6el6sUInaOjZQXnQlMBlI3aGNkL1FVjWpNil7p7Iy9IMVnRnhAYmd81Kb6eF/o6+AsE38uBJSMzbepBKbYyKMer9IJdBok
 DLTm4FMi
 2RimXDg/tb3xb7fZjOTRLbcuWKGcQljY5bBGtPDnks8UgzvSK5bqoV0QLBDzj6kvKF+zFD8wjesH1KTnX/tKH7bixX3TvPbeRab+mpHxIdymq9Y3uHueb+l2ENLFr0y9gWBsA98Em1bOGRtGgUgRCnNOAdFIgThh4GMEFESRbeYk/Ighq5HciJqDBMtKYUp/mTB23kSBYiP3nG5HlYJNaXIHB7mvHOUnGuz/TSNIpRo99SWiP5YVpdZ+Sx4wq03BrhOf//euclsVzvSSU3leeZAJPoTDsrpPXdm//3vGamm43+lO9wBbycd2/tKJTjOyNS+4QqdfODZcfz9g42orv7S6I1D9PvD9PxvGgG99uqR7wcGziy6pgeZQXmY9srpsBnEsPtuQKJnBez9VKk+n50Kq5tHBFiIhYRjVm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

proc_scsi_host_write() copies what is written into a page and hands it
to ->write_info() without terminating it. ppa and imm parse it with
strncmp() and simple_strtoul(), which read on past what was written into
whatever the page held before. Terminate the copy. A write is at most
PROC_BLOCK_SIZE bytes, so the page always has room for that.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/scsi/scsi_proc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
index fdc355d783da..dbd03360b5a4 100644
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -80,6 +80,7 @@ static ssize_t proc_scsi_host_write(struct file *file, const char __user *buf,
 		ret = -EFAULT;
 		if (copy_from_user(page, buf, count))
 			goto out;
+		page[count] = '\0';
 		ret = shost->hostt->write_info(shost, page, count);
 	}
 out:

-- 
2.53.0


