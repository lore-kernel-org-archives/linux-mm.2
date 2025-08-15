Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DDB4CA0EE6
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 09:01:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF1C290022D; Fri, 15 Aug 2025 05:01:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA1788E0002; Fri, 15 Aug 2025 05:01:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C90BE90022D; Fri, 15 Aug 2025 05:01:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B7E188E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:01:53 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6EA021DE0AA
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:01:53 +0000 (UTC)
X-FDA: 83778399306.05.A83C150
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by imf25.hostedemail.com (Postfix) with ESMTP id B17E9A000E
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:01:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of chenhuacai@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=chenhuacai@loongson.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248511; a=rsa-sha256;
	cv=none;
	b=Bzn5AEEy16Rm1/ly7H6ZaWGQzd3flt5w76ZL+a5vU1bXi1VjKgQ3G3YyFs3Ay8I2EoFYgF
	AfcrSP1uu7Ee3GSRWwsvkLeM+AddZ3tNLf6LoQmEuuMmw2Ki1mx/0FxQpQVJ4rMHOtkLEM
	NGyeojcRIkhsjheRgK4X2GKD+kzxfFY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of chenhuacai@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=chenhuacai@loongson.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=MjpYtTmmKoOk2iXk8aK3zoztk7yCls4XUavGSYNOd3s=;
	b=rD+tCY83jXawg0qWbwDO4dlOyWCwmnZS/tPzPoBW5NBpnDJ8aR7Qffr11MqtKoIhOrMKEy
	KuqBBm7dL1uAfXmIuZ530wNOEnPK2ZhMPjynYF5v6laypil/FBXH7PGAhw6fmtmN7gi9oR
	olBXZSGlnue5B76sfd8Cd+rVq+oFMiY=
Received: from loongson.cn (unknown [223.64.69.45])
	by gateway (Coremail) with SMTP id _____8Cx_eJ5955oAzpAAQ--.16116S3;
	Fri, 15 Aug 2025 17:01:46 +0800 (CST)
Received: from localhost.localdomain (unknown [223.64.69.45])
	by front1 (Coremail) with SMTP id qMiowJBxD8Jx955oUrVNAA--.32978S2;
	Fri, 15 Aug 2025 17:01:44 +0800 (CST)
From: Huacai Chen <chenhuacai@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-kernel@vger.kernel.org,
	Huacai Chen <chenhuacai@loongson.cn>,
	stable@vger.kernel.org
Subject: [PATCH V4] init: Handle bootloader identifier in kernel parameters
Date: Fri, 15 Aug 2025 17:01:20 +0800
Message-ID: <20250815090120.1569947-1-chenhuacai@loongson.cn>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxD8Jx955oUrVNAA--.32978S2
X-CM-SenderInfo: hfkh0x5xdftxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoW7tw4fCr1rCFW3GF1xXr17XFc_yoW8Kw1xpF
	Z7tr9xWaykGws8Cw48Wr4vga4Sywn3Aa17JanrWanxXFn0qFy0v3yftF1agas3trWfKF42
	gF1DZF10k3W7CFXCm3ZEXasCq-sJn29KB7ZKAUJUUUUx529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUBjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1ln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2
	x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1D
	McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr4
	1lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_
	Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67
	AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8I
	cVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI
	8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v2
	6r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07j5o7tUUUUU=
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B17E9A000E
X-Stat-Signature: fp9p46qahk1s7qjwzj59kh5er9f3pb4d
X-Rspam-User: 
X-HE-Tag: 1755248510-765150
X-HE-Meta: U2FsdGVkX19adoHpvr+9Tzal5ppS0RIM4bAwN6PkDUr5AVtk+o5BlNlGQtRREz0tMH4SuVuoOwEd02+sRk9X2i/EmDZd/0AkUFeIDrndVq4PsfD4nYeP+lNL4OhFpZPLjvn1WubPXF+MyT0822Vm7R3uX37qhDDWgmn3/Ex/bUdyXp6y6JUHy5XXCJqRxv0LNg+Vk9bPAfjJIPumV7K164jyqbuVvvy+K3QhhD4b4/sc+hI2xQm/9W0nBAB/BTI1qR/ZFYHjzr16SfFAvKyd4tOq31g1/B3NnJGxEqfUoLJIIrpBZWFxqTKhvk406Pi4hHOIYkK4tg6r9VscGesbVlCGVSllkGIqvp8PXdU0kJnKlFUUkd6dvS4lh47Na7QBAfzICMdkHwUSeBb8zaZV1KOKQGQitCIv2vdMlveiWlR2sqORljnJNYpnnT18Ltp58EQMhxuJpvTYOJrYZCap7D9Rn1rug1k7v2fsHQ6e/XKTJRot6NTRq+J7CfAkJ4NhpnTW182aDPUQ8RXZzVUXZ6tGCgUZU9qUaeHnCFzV/eK4tVP25V0JtEHxzxekyxSou/jn+catu99MBEoUCWRH0fSsE7LGbHUh5yUDp1K9JWk6f5ZZ0R+vpUcmDSEuNI3bkXeiCGGeGw2NHRnhFPnzN+v0/ZXvvd/1pOB1/2yurqtMFD/xZpv//5RQ6qayr8DbSkxpxD6d1zx0kY1UG33hq+KBD+7xOp1aMV96Z6st2BaBtCrFDXy95vkeQzgBsCAumK3xExmtqUb9lVAHN/mHpahMM5VzkFojAsktPcTOi0g/nzCAF7zkPW83QPID/yrVMptduu4mrXRAiujtlKNsYuWbGnmPXxmWU3Icy0UBVRJwU2GD29tC0Vh4ONCmp3+y3+6c1k9CQwUNlzm+dbrCbo2YSEzdCgefu0aIn+MEjybPzBgbWKGcmmRcAwghm6L2Slx/hXSsEuaLZZ1LylJ
 QF5Gqyf4
 54SjHAcrGpPGptxuD6U1KqHQfNYzDx/Vm8KiJzfhjVvKN/b8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

BootLoader (Grub, LILO, etc) may pass an identifier such as "BOOT_IMAGE=
/boot/vmlinuz-x.y.z" to kernel parameters. But these identifiers are not
recognized by the kernel itself so will be passed to user space. However
user space init program also doesn't recognized it.

KEXEC/KDUMP (kexec-tools) may also pass an identifier such as "kexec" on
some architectures.

We cannot change BootLoader's behavior, because this behavior exists for
many years, and there are already user space programs search BOOT_IMAGE=
in /proc/cmdline to obtain the kernel image locations:

https://github.com/linuxdeepin/deepin-ab-recovery/blob/master/util.go
(search getBootOptions)
https://github.com/linuxdeepin/deepin-ab-recovery/blob/master/main.go
(search getKernelReleaseWithBootOption)

So the the best way is handle (ignore) it by the kernel itself, which
can avoid such boot warnings (if we use something like init=/bin/bash,
bootloader identifier can even cause a crash):

Kernel command line: BOOT_IMAGE=(hd0,1)/vmlinuz-6.x root=/dev/sda3 ro console=tty
Unknown kernel command line parameters "BOOT_IMAGE=(hd0,1)/vmlinuz-6.x", will be passed to user space.

Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
---
V2: Update comments and commit messages.
V3: Document bootloader identifiers.
V4: Use strstarts() instead of strncmp().

 init/main.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/init/main.c b/init/main.c
index 0ee0ee7b7c2c..9b5150166bcf 100644
--- a/init/main.c
+++ b/init/main.c
@@ -544,6 +544,12 @@ static int __init unknown_bootoption(char *param, char *val,
 				     const char *unused, void *arg)
 {
 	size_t len = strlen(param);
+	/*
+	 * Well-known bootloader identifiers:
+	 * 1. LILO/Grub pass "BOOT_IMAGE=...";
+	 * 2. kexec/kdump (kexec-tools) pass "kexec".
+	 */
+	const char *bootloader[] = { "BOOT_IMAGE=", "kexec", NULL };
 
 	/* Handle params aliased to sysctls */
 	if (sysctl_is_alias(param))
@@ -551,6 +557,12 @@ static int __init unknown_bootoption(char *param, char *val,
 
 	repair_env_string(param, val);
 
+	/* Handle bootloader identifier */
+	for (int i = 0; bootloader[i]; i++) {
+		if (strstarts(param, bootloader[i]))
+			return 0;
+	}
+
 	/* Handle obsolete-style parameters */
 	if (obsolete_checksetup(param))
 		return 0;
-- 
2.47.3


