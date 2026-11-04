Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0DF86078948
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fiKaQcBB
Received: by kanga.kvack.org (Postfix)
	id C58A26B05D6; Wed,  4 Nov 2026 14:22:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2FFE6B05D7; Wed,  4 Nov 2026 14:22:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B47D46B05D8; Wed,  4 Nov 2026 14:22:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9571B6B05D6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:22:52 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 269A2120801
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:22:52 +0000 (UTC)
X-FDA: 85398408984.03.0BE5B0C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 62EFDA0003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:22:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fiKaQcBB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yb3WLcVokXU6BuV8DQIS3cnoxrtkXR+HXTNSt4lhnr4=;
	b=Le7RmTVJr2s08z4m0KmXdI2Ictw3aDDDmZ57ceS5faa5x5l1otoilm8daaL+lMe0fvOXvF
	/KvCB470lFsRJycXnzmL3wPE9fbo94uoUjPHmir2oCE4SXTsNs4KyUusDFvlOBhjepjfR8
	17sHvIgKv+ZauuY7IDtbNC59oVc4WlI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fiKaQcBB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820170;
	b=SkTiKZlckgfc7jTmW8hFmvZ6Ek24pTR+n4QnORNDfCcovjwQCsbtgR/t8ayLzdsAtG0Yyf
	SxJmvh94/xdXtjdJ2CyJ9n9JVn78TWxoIus0geEunjo5J1zLU9FZvmzSw+E22obsgCGRj4
	NDRcZW6lPvb7hiY8LhtN0tKRxl2Uoqo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8F5B0405A5;
	Wed,  4 Nov 2026 19:22:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6191F000C1;
	Wed,  4 Nov 2026 19:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820169;
	bh=yb3WLcVokXU6BuV8DQIS3cnoxrtkXR+HXTNSt4lhnr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fiKaQcBBM7CHuzCBzooLkWiixzDMCPH0abyo23Y6xNfO1P1Jz4SVzzrNkC5GNYVd1
	 eMX88qY7qJaKHg6DbaROIR++BPy2Kyp3MZCpiAATbxTf70mzragx6Tg8Rf7WIdgq9F
	 QlvSWLpjHMSa80EemkwfyV8PLn1erm+qQd81e7uvwXkcoQVRlqK7BfGfTBlQz55qvz
	 meFN7EKRKDVuDV6VHApflDRbll4AH9KiX+Dq0jNOza9SvVUbP004w3f3B36tYf1wUA
	 zHPYjQLe8ECybW/Ocrpwgbj6g3PnKXz17vwPzToOlIccROS9KgsB1X55DvGTXYsTG7
	 zk4zJ6cOiROtA==
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
Subject: [PATCH RESEND v2 27/51] um: NUL-terminate what is written to /proc/exitcode
Date: Wed,  4 Nov 2026 20:22:34 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-27-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1042; i=brauner@kernel.org; h=from:subject:message-id; bh=wRElBRQ5ywf1BhvCA77KtICLks8yyr6GFoKnZLCCyMo=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bnzz3GXXJo5Hc3pmM9/KnDWNx2F7oXDNwfnzckODj HKmqDYJd5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEyEmZuRYaL+4jrlP3qft00L 2Ll6cpz0DlUZ3fvH2TYxmrnxbxUO4GBkOD79aXjC46WhNpt+sx24VfZqneBkRlWN6ZUfN7lXFve 28QMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 62EFDA0003
X-Stat-Signature: miixd73qsuaufhxqrdbhus666cg7n95i
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793820170-452369
X-HE-Meta: U2FsdGVkX18kMUFYHJJFvER9a0GDiVJmuy6OV2NdYFJsYyGx5V+cTj7JIr5aPacKPtjxjAwE2P03zff5owa5rwpJG0585kNk6mskNWV7zll2KQdvJtDyVcCglbNNC2XUL2hKOtrN5v3N2OaGVu8DOFxPAl97rLFMELKFDdkxJ97jIV0uLNQQ8/28XPxA1Vq/+MYKyQcxA/ARUCugALHXcRRgs2NBFUUQzsKuiDBE0PrxF818fxk70gkr6LupXSDY9fA3PI2cDJ4v0NZctlS3SOS0g4wtlUVzUE4BZtzBoFLt8/u+g8DnDB5aX7i2a4Jvkke9FST1NG2IdiciTb6fsK5MXWvg5TLV6qWDM9tVZt/pFdxBH5f3yR/VJYLX4WnrIKwHOgZ3wKDp/eD9/KlgPlUbJF1F3meD2DvoM2dWpW1bN2iteJ6W4c2adCYehOLSWx/eGLRI+pSJ1Dm1u9RYJ6RA1Mx0ujxjSVzVlIflazUOOfDCnE+srXECzomuatyUb/Qx79+9acOqhMK50pJ6ZG2gWlP8pjlWlC4P18uoeTfr+WR3t5gh1xL5wJrDQfKqnHnEh3a27LZGSkarl+1zwrNvoVjCCj5l6a+frB+99grMOV4DWXz5JhSq62gFMZc+mBDtZcmWDrzJ83g2Ztgn1KmEzlQWvVJVEghmCigdXK4llCFsR9GQgkar5oU/T5kTGdioK/IfPVOAvYC4ZgaUbu6eS8YX0hXcwwTwuKT97Iuo7JQmZHZKDDsIwSkucaAigs7/NJlVSXEnsDJSKN5PXY7a09gbmQVYL54eUo0cnG6ZX43Oazv3uCoWDz3+RUGtHKc+bW72ORxGHGVn2G11pgrwdHnFtSiICcxrkAnZewPKCmcGD5LQUHXgK8XKfw+X/2v3n2WBU/sAdWTWjFe5Ew8SEieA9FkQHJNc+bU4VHjZIPGE8kVQ8bCHd452Qe3iAiuTWuPVvD1KRLmlG87
 5xYaxpUQ
 DYR3hVQFWVCUuEAWZ8utSJj01AlT/ozV+g/jEM1xHAZfWWow3zoODXCgvryPSF3WARb5eCXp5noZtk/K17JZqNM/uKX+O8/zdkgOvHxGHD36/4w77N66D4+AvBsgzZvSNGItWgKVQOffhwVAZe2iG9DtMbp6Qee1N8mz83xu3YivSP/y6mH2XIyvx4wokvCT0oFmTmpSuDReIjegA5t1sRRVpJIMzPLBKEUxDB3jWImVIXVEA9NFOEiRsDnLCMmbigS3/Yqd951S/RGIW/rGNPAO3kTiDPpVm23NSi1wVRGfn5txrHtq4jF+BIuzLz1+TlfSKQ/S8xE9IxXWxH9JP9sSlEWGvYeprjWdtci9VHJT5t9hAslv2wo/IfljuIcdU1sFCE5fpGuPy3XpeMEbPO2XefJsZTrHtXGEC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

exitcode_proc_write() copies up to sizeof(buf) bytes of the write into
buf and hands it to simple_strtol() without terminating it. So
"echo -n 5" parses whatever the stack held after the '5', and a write of
seven bytes or more reads past the end of buf. Terminate the copy.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/um/kernel/exitcode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/um/kernel/exitcode.c b/arch/um/kernel/exitcode.c
index 43edc2aa57e4..0230354f4812 100644
--- a/arch/um/kernel/exitcode.c
+++ b/arch/um/kernel/exitcode.c
@@ -43,9 +43,10 @@ static ssize_t exitcode_proc_write(struct file *file,
 	size_t size;
 	int tmp;
 
-	size = min(count, sizeof(buf));
+	size = min(count, sizeof(buf) - 1);
 	if (copy_from_user(buf, buffer, size))
 		return -EFAULT;
+	buf[size] = '\0';
 
 	tmp = simple_strtol(buf, &end, 0);
 	if ((*end != '\0') && !isspace(*end))

-- 
2.53.0


