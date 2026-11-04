Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27B186070337
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DJwoJhhA
Received: by kanga.kvack.org (Postfix)
	id 460A56B05B2; Wed,  4 Nov 2026 14:18:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4112E6B05BA; Wed,  4 Nov 2026 14:18:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D9D16B05BB; Wed,  4 Nov 2026 14:18:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0BB0D6B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:18:15 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A1B2040843
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:18:14 +0000 (UTC)
X-FDA: 85398397308.29.76ADF5B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id BF056C000E
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:18:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DJwoJhhA;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793819892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gnzz2fT926tAung/y7Xzshf60AQanFXIqjFC5KSqJW4=;
	b=xOWd+NHFoC8Mec0WcWntfmyusLCEaeAaLN7jfEs3pStCPGZq80+J/+0CbnrIhwg5hkflSP
	dR2nzA+B7kI0Fdtr3T9V0Op2b8+RsDHthKloEiSzWYzMqNYdbJO5+2RWLOS2t+DJ93cFph
	SY5oagrwswoEw/FhDNAt7UwJVRZ6J1U=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DJwoJhhA;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793819892;
	b=ibaHeitTetRliJ6tNhWMwjMausmYwSk5EVuS2gtmPf16Srm6/PQCCb911ZxxJ4HTTpyQ5T
	0ybJWsbZH/nfE3TfjwCu+c0Lyp9K+6La+qS6Sk8NfAv2QLwR0kd8EDPFGurAmJ9lCLGzse
	FdVm8A4WNWgWEc/bpa1qS7eX3HRRzH0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0FA1B43827;
	Wed,  4 Nov 2026 19:18:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A991F000C1;
	Wed,  4 Nov 2026 19:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793819891;
	bh=gnzz2fT926tAung/y7Xzshf60AQanFXIqjFC5KSqJW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DJwoJhhATgLL5xfXdN6OGI5pF+zFeQ4+WjDNEmYUvZTHMkMM3eFBxWoobM0WXpN6L
	 UN1K0xLPqC6xno0sP505XFwThWfbay58UK+kSTD2vpnLdKzWFKNzP1giv5JOftlPAN
	 Lav0lUTUsfF4QNMQKGO/ATVDWFOPORj+D8twGViNFcODYJUEtFOTbyZUtap9bjA0h2
	 /y/zNq9k0GXM/Wcge/kDBQjMR/uKEl2vV60dRTJ8k+gOCXzwPxktA7vZC0dRvivZpp
	 96DepXBnx1as6j7eZVnuCHwHxCErTDabWI65gJh4HFpjHVsXeCp7TMdzgalcYj5T8Y
	 Hbm2eKKFQu5Bw==
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
Subject: [PATCH RESEND v2 08/51] powerpc/pseries/lparcfg: don't drop the last byte of a write
Date: Wed,  4 Nov 2026 20:17:57 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-8-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1293; i=brauner@kernel.org; h=from:subject:message-id; bh=N2rHHHUzfsZsGLUBvdMxa3o2qGAAPzh8wsvUFn8S2uA=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9brzSemUj37ZpfEJdHNavdhRd85506nnq/+C3P7Y+8 TFiT9g3uaOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiUnIM/0u5vFweH/p6+fPx 1Xd527Vmp+13uFo968XVnftb9sQmFZYxMkz6tCVlybzJutuORSfufHxkyiSRYzOO7z4d/HTf5nt 15WbMAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: etdfzafge3eoq4c9a6rafiotip8et7ai
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: BF056C000E
X-HE-Tag: 1793819892-817160
X-HE-Meta: U2FsdGVkX1/MXVVQLKxtVxSH69q3RCLve6/C2UtYMM4X9tk0ZhavfdBLNzfknX6x+Ggsp2jq+PEH7Nirrbn5eQeqzuMsOc6Us+GLu82tZT3LmKo4Lo3hN4BsOjKp4PDTJ0i8WtR11Hhihr3ytUeMzEIXW06i2Gfh4Cv3d+se3mliYIAyAihHRj/xHPezRL8BpxQdxmL7sVpW1LfbYWRvhP82FTbRXO2E155mM4JerZ/VpvFuGxd06jiIim6GlNx7/D0T8oFGIoXoC8/sMOJxPcIVC+jjcEEYbo4SmCYq9q2RdyrsFQxhM0W+s1zZZb3cvVzilYcBWKjzl5IzRRnKgQCjR5wjjEBkbl+nJ0jqoiF0OIjoXDJbngjYuXaah89Xm+femRDCM9pteSwm16aa8ps513L4Ab5rTs1DbtP8su1GjwdufNWoXZsb3nCzWBxPzYtRCjvEyyvxHewQOveUYtVHnMiVqw1DFY/Y2k3HMznVe3fICp8U0LNYnKNw7k94wOV1FYBrD8jpxmCRB6lwhNRhFMyAEc632lhtKzZ7PPeAzHTgtAt+TBMIGJjIafWy1VdiIyA3FA5Uk34s5bdlWWRUZ7I3IJ9bFwi1BVsABzqjAS7NgpsD9Ju4x3L5PQJWOa1lojDIneB6InUxwn46K5ATzVlYpXsr4eSvbEtxKwC6VAGbo/rI8us37PLEhr0Fz1PNL8Fk4t/5RUV3H6fd/9d+9pQhUyfK/fQqsqy2E6zubAVt9Fpg6CzwCgBJcPIa/cjXImSvNtcIW3Cv+GFW4QCLyCpTvP+JK+lT4y8fNmEPlk682pH8TobhUKpag1ItG3/6M6bGMVpR8rswdAu91CxcEgvpljqc7hILT+TmBcUu6DskQNbho+4rXGGjIDcxZ0GvXnkhF8E0pa/N9E2yqvta+UGv9p3VwZxk1v5XVw3cpDFWGe3qq90sFsEMQTmfnu0fxiT2GFyMes9MZnY
 t18iCSbI
 ywrLhhT+E3LfIJOBL2pH313zjlmmkLlvgXXkdLDMo7f95us6hBf/urLHVURYrPRI1WJd2kiVHjXURh4HeBzh8mGqS8o2ZoDFqey1IclSuqmG2t1lnAdYjljH+0FREYTDYIbbBLJPXeFFXwmCuGKlP4IqXKHCD62HZiVlfVlR2vfF6wV53Ro4PdmiCJWnFyT92L6qH7mgfL2oV98td1WUBty9ifCIDzuvE3rg+KMDvQqMo52DSy7KFU5lPvzgtcX5F9nGQGpLIpxxtceJPyzHt4nqIIXybmKjV3oGXMMYnHsTUytUKAFh1PHL0lt56Jc+DqW5gC52EZtjF51vB67ltrk28ydfvWWIuKee/Q5tRys9bbek0GLYdn4jQJjCf1EetKHhX6VJ/S40BMMJs10OjndUAfODt0Ni3z22V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

lparcfg_write() terminates its copy of the write by overwriting the
last byte, so a write without a trailing newline loses its last
character: "partition_entitled_capacity=5" is parsed as an empty value
and fails with -EINVAL. Terminate behind the copy instead, and refuse a
write that fills the whole buffer, which can't be terminated.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/powerpc/platforms/pseries/lparcfg.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/lparcfg.c b/arch/powerpc/platforms/pseries/lparcfg.c
index 3280b7968cab..9882f98c0efb 100644
--- a/arch/powerpc/platforms/pseries/lparcfg.c
+++ b/arch/powerpc/platforms/pseries/lparcfg.c
@@ -699,13 +699,12 @@ static ssize_t lparcfg_write(struct file *file, const char __user * buf,
 	if (!firmware_has_feature(FW_FEATURE_SPLPAR))
 		return -EINVAL;
 
-	if (count == 0 || count > sizeof(kbuf))
+	if (count == 0 || count >= sizeof(kbuf))
 		return -EINVAL;
 
 	if (copy_from_user(kbuf, buf, count))
 		return -EFAULT;
-
-	kbuf[count - 1] = '\0';
+	kbuf[count] = '\0';
 	tmp = strchr(kbuf, '=');
 	if (!tmp)
 		return -EINVAL;

-- 
2.53.0


