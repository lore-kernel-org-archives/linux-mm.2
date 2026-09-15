Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D0EEC88E7F
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:37:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1A1A6B00D3; Tue, 15 Sep 2026 07:37:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F1F86B00D4; Tue, 15 Sep 2026 07:37:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 908F96B00D5; Tue, 15 Sep 2026 07:37:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6AC646B00D3
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:37:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EC6AF1A0345
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:37:27 +0000 (UTC)
X-FDA: 85215796134.19.0FC88A6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3A4DA140007
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:37:26 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fNFTQOJL;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789472246;
	b=KNrCmhW5ral5NSSGzUaD6H09XsxvBk2xlwwxR6YO0IvVm41ioYWqoVFcsyURJbZUZ/0tcN
	LXCidozR7znsxaWskZFkvi6Ay1ljXlMGRNUiDM9m793SrgzH/VixNw/WgZKDKOkmmzpB1K
	IoNVmqvbnTruk2JuwyuIL4Pw3axYlvU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fNFTQOJL;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789472246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mjqLYqkFC5yCbrRzMMvOpmvK8b+wb1Az5sELRN6Iqmw=;
	b=TVEz+j2BxtDETiNpiGKkOfEiKcNysDQzRs/65ZqwDXXr+ERYFJPCd0i0bpPR3V40pwxjJH
	91t6YtMzhbU+ehGX27ye78fIjQ6biaD6sxoYGywXVKz5dQRG3UL4G903iUjR9Bjuj9pBxw
	Yg8daBUezv0tbJVNf4KqwX6fI26+Ts4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B699B602C5;
	Tue, 15 Sep 2026 11:37:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE621F00893;
	Tue, 15 Sep 2026 11:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472245;
	bh=mjqLYqkFC5yCbrRzMMvOpmvK8b+wb1Az5sELRN6Iqmw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=fNFTQOJL+iGGO+zzzm7cDe+/taoDcFY7fewDCdDuBMLNk844/5YTOXExel7EKsF9S
	 oLRnzjguOrHBG/PK7ZC549dR4lB6cSOioaIssgENRRB/BPi7+UG74t/yS8GmkCNH9C
	 SYkWW/2u8YiYHbyNYlVSLFpnBvaUvCIp4Mwu/abM5lLuo8GHPpD/0L9dCr6/bh0kxz
	 Ano4WmSOQb609KJxhLhb4QylzFqFY4npF26OT03shrB8BqGetnHALS1L68dHSQxDHf
	 lkgeVcI6ujFF+0WS99WYyuepbVTQzAmtrQq19Z8PUhZtIGApiugszVbmJFY6aacriE
	 TeUsi9M9eNUTQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:31:33 +0200
Subject: [PATCH RFC POC 47/50] iio: buffer: install the buffer descriptor
 when the ioctl returns
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-47-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, 
 Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Oleg Nesterov <oleg@redhat.com>, linux-alpha@vger.kernel.org, 
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
 linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, 
 linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, 
 linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-um@lists.infradead.org, Jens Axboe <axboe@kernel.dk>, 
 io-uring@vger.kernel.org, netdev@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-gpio@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 bpf@vger.kernel.org, David Airlie <airlied@redhat.com>, 
 virtualization@lists.linux.dev, kvm@vger.kernel.org, 
 kexec@lists.infradead.org, linux-hyperv@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=1959; i=brauner@kernel.org;
 h=from:subject:message-id; bh=RM8/Ryi0JBjisB2tI5DXR2rE8sCF/AliS5Zp4F8Qhf4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1KkPFJZ6IZfMtyJ0UsaFFiuPoGWsPxtn3v1o+e3z3
 stfX0943lHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCR6LMM/yNudM+8naelq7Sn
 g+X00Zpv+usvL13mfINZZtGLrdYV3KkMfzjPLfxTceTH7fV1ATe3FQTfd1Vd7vTqOWPz3spdkTu
 WLmIFAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3A4DA140007
X-Stat-Signature: hzah533qp1n3t5d9nix8cz5q5f58sky1
X-HE-Tag: 1789472246-336150
X-HE-Meta: U2FsdGVkX1+Mx81gu4FAQ5bCWJJJGGau2+dPfoWUwZcbl/2FI32D/1BpDGBiOBPUlA//unfI7QD9B8t7H+sjl09ADMpAI6EbzYqmsIS5ZMBtNXU7AVWpGosQdoqQPVBFY0wUVmZ+gCgFNokkB4ZfjhPNbshDtnhiXNg37DhA85nktG9hqQqN0tEo+3+CyDHpKZ2Od1V88Ac9dbQh8pWHTQ5MXnJEg2axVuy2vzxCZZ4q5f8SrSBDNz/Nq7ckSqtVRM496z5W9EwPui+wXaBL6hnQYtlEws6cG118wEwrKaKQMa5hfQGcIJCfiuxcLvL9jNkwmQPOYvwLl6Eqw7h1AWDR3JNumw2JbSysz8BD++wl+P5+DRl+aK2Xsfwbk0v4QMZ/yC/stR9iD+5F2setVTo4UucbwGlFUnoOHPsO/egKeoSe1N5ZkwPd6TZk+nIH4YFY88eoffsu7hArPcsR0uCHgCAK2COaZXF87KWLSs2HazdoTiw9GEAMf+xjW75WgAWAHt1fCwgu+W0ibnbBmvAx/ewA8PO+vI99ZMVbv9Ola6bcBBYWRJ3LyWGzBUzCd7bInNrt5vWG4d+39BiuYs6ds1OLEP5IoeGSAUUr580okI+5JVa7mWGqgPgtCyK9auQ7EuPMOYqa2VxA7P6XE0RvuuT6uB3zjLvRUlPlq9qd/1J9i6NrsxJaIITKzobB4rVV11is713JW8SDNXENI9XcieiqtXJ9SyKhH4CUz657QNK/dN/IT1HT1CosRtL6Cx4Qg2B488IHdijPQIxeKTjdRPstP4D4TSwMoWvay0E0AEG2gK3STMkcarEl756beAsFcF4FmMypub1q0a0mBDt+kbVKt/bgthhK1qI3469llsBJAt5998l/RMkjCihHFby/68CgUEMELSqHfpfouddrAHpcSf5x6B9XDV0kUQIW0GoiiFipiyv3vbyDRGRnHF9C2IkA/MvfTiNLJHr
 F2quGBXU
 ZDvM7BsWFN4TXNWfqcttsu8pVM+TPy+yE4xpQ7vpWbGrwozWqQFOFEGg4HWXc0aXWJjOunQBz7iB17NsydOXvrg4U5pwkVpNe8ISrKgRkJH6IM7PgCjMswyY2jRe6KJn3XOSs2ZxJuZxqFs1PUGtLCoX4VavaSMm3YdXRZrAf/3N8DePk0jMICXhlGc0yb344P2CCmElgmb1V9d53v1IxqVp3kTZH5WMHMzK7EDkxgLMYCYgIbKRyH3aaJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rely on the fd exit path machinery.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/iio/industrialio-buffer.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
index 2c9ec93dff47..9fb15bf82d0a 100644
--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -2041,7 +2041,7 @@ static long iio_device_buffer_getfd(struct iio_dev *indio_dev, unsigned long arg
 	int __user *ival = (int __user *)arg;
 	struct iio_dev_buffer_pair *ib;
 	struct iio_buffer *buffer;
-	int fd, idx, ret;
+	int idx, ret, fdno;
 
 	if (copy_from_user(&idx, ival, sizeof(idx)))
 		return -EFAULT;
@@ -2067,26 +2067,18 @@ static long iio_device_buffer_getfd(struct iio_dev *indio_dev, unsigned long arg
 	ib->indio_dev = indio_dev;
 	ib->buffer = buffer;
 
-	fd = anon_inode_getfd("iio:buffer", &iio_buffer_chrdev_fileops,
-			      ib, O_RDWR | O_CLOEXEC);
-	if (fd < 0) {
-		ret = fd;
+	FD_PREPARE(fdf, O_RDWR | O_CLOEXEC,
+		   anon_inode_getfile("iio:buffer", &iio_buffer_chrdev_fileops,
+				      ib, O_RDWR | O_CLOEXEC));
+	if (IS_ERR(fdf)) {
+		ret = PTR_ERR(fdf);
 		goto error_free_ib;
 	}
 
-	if (copy_to_user(ival, &fd, sizeof(fd))) {
-		/*
-		 * "Leak" the fd, as there's not much we can do about this
-		 * anyway. 'fd' might have been closed already, as
-		 * anon_inode_getfd() called fd_install() on it, which made
-		 * it reachable by userland.
-		 *
-		 * Instead of allowing a malicious user to play tricks with
-		 * us, rely on the process exit path to do any necessary
-		 * cleanup, as in releasing the file, if still needed.
-		 */
+	fdno = fd_prepare_fd(fdf);
+	/* The staged file is dropped with its descriptor if this faults. */
+	if (copy_to_user(ival, &fdno, sizeof(fdno)))
 		return -EFAULT;
-	}
 
 	return 0;
 

-- 
2.53.0


