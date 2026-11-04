Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73B316071AE9
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kq+FKfxG
Received: by kanga.kvack.org (Postfix)
	id 749FD6B05B6; Wed,  4 Nov 2026 14:40:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 721526B05CA; Wed,  4 Nov 2026 14:40:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 610316B05EE; Wed,  4 Nov 2026 14:40:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3B6AD6B05B6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:40:36 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CDCDDA07FF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:40:35 +0000 (UTC)
X-FDA: 85398453630.10.8B95557
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0D12314000C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:40:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kq+FKfxG;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821234;
	b=XabADa/Qin9wXYS94b8xGzK4Mpm7Yk5nUXeB8cnusG5xvBDI+w4/aXZ32aFWVi1PWWZoBT
	eFWsbEio68AyQtYpf/Y6zkb8FJB+dkWDGM+6Uf7PBzy+4+pJ5UJEVnb/B0oCNc8SM4LZmL
	kNLGgKLeKJBd1Sl/9UnniRgX+spEsjk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kq+FKfxG;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lzi0v2Iw6r5Nf2GLOsMSQBwdPNX93e2TzGzGfD3oQvk=;
	b=rIkSa5QEUvICsTDLk7cWrXQccqY4bHWYgaXqMFNti3l91d19S6myORmoWAE9x8OZ9uP338
	fhiD+OCmwTRIbVS1657MUwxV+8MMo/zlXufvl3gYWZ4JsgDlAlkEIicN2fPcqFSdUYFDdY
	DTjUV1H1UQN23PRDzTFXHas7W+Oi75g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2FF5A40946;
	Wed,  4 Nov 2026 19:40:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0DEB1F0093A;
	Wed,  4 Nov 2026 19:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821233;
	bh=lzi0v2Iw6r5Nf2GLOsMSQBwdPNX93e2TzGzGfD3oQvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kq+FKfxGol1yZkTvQK7XOf4MJYg3n2wT++qWRo+QnGi9jvJMQIfuuwXxBQd6HrxO9
	 DzaQAB8BU2qMveOWYqXQf8uiF3jI1+TMalzy94+Rcd9plW4bEe5kD06s2YR2pJWce9
	 B6hFJWwiorAIE62RUnEWt3yo5nQlNa9h0jz+aofQy/98+6YVivsZ0C7K1SwAby0aHP
	 7T5oXbKe+XnQQnQPrW8rV5dPeOZRh0+N4R8p2Y7AHvXwgCCSGo3lTHp1Qs3mmTBfkR
	 oBUp+SJ51x7+DV6W8OrsLZe3q3dTzc8ph41dFrQv8E2WNRYsf3TxqVqdtFkK0eHuLm
	 os2hfJBqXQfoA==
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
Subject: [PATCH RESEND v2 19/23] macintosh/via-pmu: let procfs copy in writes to the options file
Date: Wed,  4 Nov 2026 20:40:18 +0100
Message-ID: <20261104-work-procfs-arch-v2-19-2aeb952c9597@kernel.org>
In-Reply-To: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
References: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1397; i=brauner@kernel.org; h=from:subject:message-id; bh=agoZq1LJSKBxY7yRmppNE5tnXNWd/ezen+xLPyCzOnY=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97mReIrzh9cx53/g23f7T5yBxj/3Wz2cX8wsWTF3AP 1t597qLVR2lLAxiXAyyYoosDu0m4XLLeSo2G2VqwMxhZQIZwsDFKQAT2cTOyNC6JvPZMlEVDrlF 196Vxjt56Gn83yn6YN/2thy+Tlspl+0M/+xtty1ZFrFn7v65W/6uCr1fY7JaSuT8qnn7/y2e7Ma Rt5IfAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: m87dqnkyhoaiy31rpbno9fk66h9rn5my
X-Rspamd-Queue-Id: 0D12314000C
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793821233-624662
X-HE-Meta: U2FsdGVkX1/JOMKPyWDWnr2JnLRUb1X7QGye4Snjg9dhg1AQY/4IxWKlMwRwlDzDmOhIOgHlpv6iSKMJkWQD1+yhUdKsPIgaTOwHh4eeurp/1TRzSStzDj0fAYrbXQp/Jd+nhhgTLNrez5QQwHlmYU9OZUN0+LvE773vvYVRP2zZn5AEV9yxGxdfsCbaXtVxYSZTVOnHhYvMfQpvgibYcIZCQfHQhF5bhB1wd3wl5pzCRJ5vXSdfDVIwiOHAzjifvrAAjutOwjvUlKAnOukR+2keuiGJi4iiY7lj9v4FupRZhCrMgA0ULsweFy8K1ZmfqoUT7pIkWwKWG9xSYS7X7ikJ61NwgK65+jMRtGDIFUFBUy5HlXb6b3zfpSISgMRsd/SpcMZQDF40bMB/XVm6yjUxqVo0eArLIaoPXpWpB6Y1RpG81KylhDfY9BOj9DxhSUK5SP9geV6Ubg35OuTKZlesn0dx0Me+0JrCmOnBsBQkuTcjUd7P6e8Y7io/sapMAg8aksI+OZSeahBqkVLTZELVfQZfdDra5jb6kkMIQ3MtXzlLkXF+Ffeb1R2WqEcREzoT7BsM1EDuR++pm1XX3ckZTrbzUoVifabuAILyc2VJ7diXE9xW4y5Xzc7MTCY090BuMKesD+14TxqRJm6q3Bb3xAKjTs/RpNUpZMRZ56W7SmFMioGbROb0WXkrW5PEKTLhMPdMK9VT/rRzEKSkxkt/T9aJ0BA6dgFqrn+0FuBhCToJx+4Dr7BDE5i2d6JS6j/7fOvTwIsgIO34PH1r5/iTV2k3Lfo2soc0nPKCRfwv3gttQVZHochpXZIVq9uRrJZJZ5M3RSm+7wGPnLsm2XIi8wm4LCpEv7EsKlF4LoiNT+Ml0EsrMhlrmSmuNxnejecJ0KUkZxs800mvXUmm3N3XnGHDx6d3GShVyqqIAss1mmRWPLHOtLIJPBrPmXG4G6req49iqf2TBPmHvPl
 FNvIgfiw
 EqPm70BQjuk2bHG8O/V8rUwZ3Qifit9PHN8bhj6Giu/UleE6wUIRwfjDi+cKKWQ/tjYTDvm3LOGkZpaD8LJiRvCp8mcOx9IFPS5k6B+ijAo99hnxh9NRhs2gFYKeLdsDoqqcnRqBAuaI/Auj4Ccg1XtYFamiXVJVmQaTn/a2K7f6BaVxfQZJxyuC6er9fcHbY/CElL+NyKbWFFuBP3/GYgSm3vJNaNG8NtkQRHj1owb9CfJR03abh2oH+el1nz+gji3ZboNiVv+EeIjFw1r8EbQFaiidu5J9LVX5VCpClmZRh9Hm6Haweaw1ecVgMDoslR5RG+lGtFa28WE9zjJRQs3kavTTErrSyEp2O4fiRSKu8mkair8CMa7LWo0W+Gwj5Snh5aMQ0QnA0jY8kC4K4EcyYiQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() so procfs copies in what is written before
it pins the entry, and parse the option from that copy. Writes larger
than PAGE_SIZE - 1 bytes fail with -EINVAL now.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/macintosh/via-pmu.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/macintosh/via-pmu.c b/drivers/macintosh/via-pmu.c
index 49f929ae10e4..079c085be5d2 100644
--- a/drivers/macintosh/via-pmu.c
+++ b/drivers/macintosh/via-pmu.c
@@ -913,7 +913,7 @@ static int pmu_options_proc_show(struct seq_file *m, void *v)
 }
 
 static ssize_t pmu_options_proc_write(struct file *file,
-		const char __user *buffer, size_t count, loff_t *pos)
+		char *buffer, size_t count, loff_t *pos)
 {
 	char tmp[33];
 	char *label, *val;
@@ -923,8 +923,7 @@ static ssize_t pmu_options_proc_write(struct file *file,
 		return -EINVAL;
 	if (count > 32)
 		count = 32;
-	if (copy_from_user(tmp, buffer, count))
-		return -EFAULT;
+	memcpy(tmp, buffer, count);
 	tmp[count] = 0;
 
 	label = tmp;
@@ -958,7 +957,7 @@ static ssize_t pmu_options_proc_write(struct file *file,
 
 static const struct proc_ops pmu_options_proc_ops = {
 	.proc_show	= pmu_options_proc_show,
-	.proc_write	= pmu_options_proc_write,
+	.proc_write_buf	= pmu_options_proc_write,
 };
 #endif
 

-- 
2.53.0


