Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18E77606A32C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DVG35mDd
Received: by kanga.kvack.org (Postfix)
	id 0A9DA6B05B2; Wed,  4 Nov 2026 12:48:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05E346B05B3; Wed,  4 Nov 2026 12:48:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E654B6B05B4; Wed,  4 Nov 2026 12:48:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC0326B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:48:10 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 291C9A8538
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:48:10 +0000 (UTC)
X-FDA: 85398170340.20.1900626
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6E7CA1C0004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:48:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DVG35mDd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793814488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+QMuJvtMuQ+CXnn6xLeWoxU7H9VJY0mzKEyTXi76/+M=;
	b=R6WxaDF9a1OYcVliS9XuCtLGU3k29gepqKWJAtWvNbJhINwX+wWcbIsc0EGbyUPHs7n7AM
	Gg8HXhNUZZFNZRIcbUSFP5W5JlEQV57v9dNSp8E8NUdPRHix4xHCQyHx5bhGHrClNlo6VX
	lEC5eoPJ07gupSo2g09yTSrXqnLLcs8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DVG35mDd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793814488;
	b=5mM9rJyQGvqsH5rW1ggJu+CDRFK2Dz5dTGreUQv7y/qDgrs2+vTkJDrKYb4oXNRqX4QMBi
	JMwqKih1pwjC+cmYWV0ui5w93VTT/xZTdOOb1ESU0Y8dVqnz3SywdK0845LGrBZeBhpKFs
	CvDCnl6OyjJRY0sK0LTIsNuF/yzkxvA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F1D886021D;
	Wed,  4 Nov 2026 17:48:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9FB1F00919;
	Wed,  4 Nov 2026 17:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793814487;
	bh=+QMuJvtMuQ+CXnn6xLeWoxU7H9VJY0mzKEyTXi76/+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DVG35mDdrJ+w70lYp9CqgpxTuoGTpj4temyLsY3vuBl9elVVBnmHrviotaVGY/ppP
	 UdOgypZXpDWtJ7enRd3iIIX4vWx3xyqPaHPzOZWq/P4JUJrwgIpI4MwtSTSz/6po8R
	 Yvz02Y/vDREj2xNfVXWxFSvrw7Bvuiwjqz0knxKP5rsjzaWDW5qaKyJ9F3yEnh+EWh
	 A3TtW5nyoi8NpYae3YAaKFmJ3QPX5Rij2cVvQ/1JMiWehFHBZSo4em6YfVuXhfiqDi
	 JqHLo3hhdvujnwykhoFrIyHzHBnGpPwJgUwVLui5mJv4lfTVDRPXKF7pOVu2XHYste
	 DuNdex110TFZw==
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
Subject: [PATCH v2 13/51] sched/psi: don't drop the last byte of a trigger write
Date: Wed,  4 Nov 2026 18:46:59 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-13-bbf7d5546809@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1310; i=brauner@kernel.org; h=from:subject:message-id; bh=/5ST8groFWC3ZYrB9+5K2L5OtN8hrslkTr6MpvXzbng=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9zjv/59LFdb+4Nqzr+cU3P2cS7+L2yauySvlfWb8/9 eufsCjT0o5SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJmJkw/FM9sG/u0ochUvwi r25NnfqcY/Wv3m+1Rk6yc5TfvmHn3j+V4X8gx3Wx2Wp7OP7b/lW+zLTMQ+Qde1X2zk2aTqESmTX LCxkA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6E7CA1C0004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: optoj714ukc5dzmynpsefpbs8j4q8kd6
X-HE-Tag: 1793814488-494335
X-HE-Meta: U2FsdGVkX1//KX1c+41ileKYCChXdvgVqvHoC0sOr39Pfu9Q3SZ1clW0ulVPIiAzb8oMk+M/9CzdvZKl9byTnkRSP5m0HQLvzCujekvAiF3HOvK1Ise35JVlLRJM4f4T8EKvHS5cxMaf4paK/vGTG9RdHfl46n/k6h21R6EBYCW46zFq4zhs5RHc+UbLVjnjY6h/BmdRMDf0+nKSniztslLvoMUl+hgQ8Z/yDbYT3+4IEvRSitGtUM9Ho2+LM9v5c2PblYVfMvqgCZkiXLc9wBF5ZU9G57zMiCeO3IZxsboaosDaezOY1SwaoYKeEN9DICmshK/hxXgWM0xHQ4IAmm/VKCwaNQqAJ6/Qqdcj8aBo5YJa6Aidc/5r+RhApsatKVOiEQ5UezXJYgttxa+TcYjJy70UmiEWapmJYvlLG2293o4Mqj+TPn55+B1CA57wfG1cUpv4o/fkQ1cXao63yswNyDgkgqDTprgx/tIq8lz38lpM2/jIvPUFanSMmvlJFqkCpoLAy9kyKnMk8y+XnrtELxVnUkvnmqlCoGFl3fk6cTRgVOHNHoFuGc1UkmJ47RXkRRRdZtjtFnHd4OOOprq+1D+ECN2ZmNHiieYMKJfWbMlkZBj2MwEUgkCUYMh/+eseetM50aVOIKM+HEArTSG/Z5w82enReXwWTrza4Kb3dZ/1Fm1/CYDcrr8ZCVHumqCL+rJfc/w6XkA8FNG33TgCZmC0p6QXOl/BIM0jQnJ803vby5TAalSm2dfNYM21JMn06GrtRn5nct9xOMdh6+9D6L3zBFrBoYcuyQX0pPGRvdB0zfMx+9teZbc8Tyy950L55elqxbAMzz+z8oWP7nuBeDP80qNWJLcnd5IrNSn3ydPexpmFtSoYhM7eFB2BF21Ftrufx+Xqsw7xk0UbMhGvZtcUz+UeEEHUEDTsEnr+DO7DoC27MRJ1p5j6MuX5f4Gr63RG+vtzyVVnMd5
 vZmw8p7O
 L6Towvd9ZK7/8QXCpZTVpK+Qy98B0/8VKrciczVhw4RZgaRgi7AbgUQjyA4dPJchQo2ZQ3J/OQOuFYoZktJoq1OehModE8Tx0y6sQCgSeqlHKSdMdSiCrJZgRi1lsOskHAQa2R1lXzb+tQGZ+nC9tu02xtCoRa7zGK29cSDWgrBLA+M0/dK35FfeO6UDM4+H4tH1sud5q1iYPZquDY9BEA69ZuoMGPuHZRLBSuM3Ncek3qN0FgfZgqkGVrv02/RUM7JMQnH3JEjwgwmPv/YxiAUnjnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

psi_write() copies at most 32 bytes of the write into its buffer and
terminates the buffer by overwriting its last byte. For a write shorter
than 32 bytes that is the last byte the writer sent. A trigger written
without a trailing newline loses its last digit then, "some 150000
1000000" turns into "some 150000 100000", and a shorter one like
"some 150 10000" fails with -EINVAL because the window doesn't fit
anymore. Only writes that end in a newline parse as intended.

Copy at most 31 bytes and terminate behind them.

Fixes: 0e94682b73bf ("psi: introduce psi monitor")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/sched/psi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 7c5381423334..8b59635e95d4 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -1566,11 +1566,11 @@ static ssize_t psi_write(struct file *file, const char __user *user_buf,
 	if (!nbytes)
 		return -EINVAL;
 
-	buf_size = min(nbytes, sizeof(buf));
+	buf_size = min(nbytes, sizeof(buf) - 1);
 	if (copy_from_user(buf, user_buf, buf_size))
 		return -EFAULT;
 
-	buf[buf_size - 1] = '\0';
+	buf[buf_size] = '\0';
 
 	seq = file->private_data;
 

-- 
2.53.0


