Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 343CACA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 20:15:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D60F8E0020; Tue,  9 Sep 2025 16:15:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 839128E0019; Tue,  9 Sep 2025 16:15:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D9D18E0020; Tue,  9 Sep 2025 16:15:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5778A8E0019
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:15:49 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0C503C072D
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:15:49 +0000 (UTC)
X-FDA: 83870817618.08.6ACC3F9
Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0E2D9C0013
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:15:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=yandex-team.com header.s=default header.b=Ow3+Zk7L;
	spf=pass (imf28.hostedemail.com: domain of arbn@yandex-team.com designates 178.154.239.72 as permitted sender) smtp.mailfrom=arbn@yandex-team.com;
	dmarc=pass (policy=none) header.from=yandex-team.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757448947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SlubtQeQpBHXlVAu20qfBqsbGkV3gCqQjvicv97NAqE=;
	b=Ve1OSv4GnqTH41zrBK9uZReOaYNLytfdXWSuY4T7g9TxR8R98uEsOTCaoDe0/uaXHMXjK3
	d3v4uIoduSdw6cPIX4KvYZkk6nBPYuKqm3Oc/I+J73DuE0PL6e49vQMwHbIkdaKh3K0XAv
	p68DK6cG13vHoYVNAtLT4xpGmFLVz/c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757448947; a=rsa-sha256;
	cv=none;
	b=xM+AJo5dy7Fcqws1s+rfrVp68uQPlIY7B+d8t4eyFcCATYHikSZwKIeNwHxirtldiixPEO
	9CrZpPkTqGEuRmKfkmmBXfqq7ILGRwmUvKENi/Ah8jETMkCMYKZoywgzaqtVqPbjvcPJkO
	EbHHgBvYIeJBdq0Pflz8+quwmLfvWnk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=yandex-team.com header.s=default header.b=Ow3+Zk7L;
	spf=pass (imf28.hostedemail.com: domain of arbn@yandex-team.com designates 178.154.239.72 as permitted sender) smtp.mailfrom=arbn@yandex-team.com;
	dmarc=pass (policy=none) header.from=yandex-team.com
Received: from mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1f:3a87:0:640:845c:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id 817A1C01A8;
	Tue, 09 Sep 2025 23:15:45 +0300 (MSK)
Received: from localhost.localdomain (172.31.115.73-vpn.dhcp.yndx.net [172.31.115.73])
	by mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id IFQqlX5GteA0-fGTTr1hW;
	Tue, 09 Sep 2025 23:15:44 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com;
	s=default; t=1757448945;
	bh=SlubtQeQpBHXlVAu20qfBqsbGkV3gCqQjvicv97NAqE=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=Ow3+Zk7LzrqdqvKvZDbmFyysZMtA7DN68cVIb+B3JSmGFhVLFAPCiOp0Wj9AxagDy
	 ChCIy5Wz0HngB7CVKrHaa2WeO2/0cYVyStkQFIrSE81CIlPTYWzzUhwHU8HNNv6Ivj
	 Ib9YHJbY8VPMhFXHrGvwikRHwrHctRkIYIv49A+A=
From: Andrey Ryabinin <arbn@yandex-team.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	James Gowans <jgowans@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Baoquan He <bhe@redhat.com>,
	kexec@lists.infradead.org,
	Pratyush Yadav <ptyadav@amazon.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	David Rientjes <rientjes@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Chris Li <chrisl@kernel.org>,
	Ashish.Kalra@amd.com,
	William Tu <witu@nvidia.com>,
	David Matlack <dmatlack@google.com>,
	Andrey Ryabinin <arbn@yandex-team.com>
Subject: [PATCH v3 5/7] kstate, test: add test module for testing kstate subsystem.
Date: Tue,  9 Sep 2025 22:14:40 +0200
Message-ID: <20250909201446.13138-6-arbn@yandex-team.com>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250909201446.13138-1-arbn@yandex-team.com>
References: <20250909201446.13138-1-arbn@yandex-team.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jjh7jfn66moa7xijtwiob8a6hza8s5ns
X-Rspamd-Queue-Id: 0E2D9C0013
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757448946-53573
X-HE-Meta: U2FsdGVkX1/P63qdayk+JZIeLAnrSFvRpH999HTf99TXJDeFyf+YKWGo2V3vCykGDNJAZ27M8/wL8qky9l33Hnk4nL8b8CfQuXQE7rU9mmK4YzBu8v8z/jvOT1FyqdMs6SE9lXz1jshsrHc4oRtg5ZWrJJ7SL/7SLE8Llart4QqScb7fiyM38IDuoNqOVZLyuVYAZZYtVvUCJo5f5QgZe8/mIiyWuZZRXJw8vkskgYtlCwHrJIwdQrPG/fUypo5UP4goL61w2W7wKcof+m0tdgqTAYM3O8g0knN5qoPg8o2H2R5iwqoCqklBcZdIz3MQIHnR8vMbg3p35t1nzwh2YWAX8nL751dSo8VAQO6HLwMb7jC5LbIralj9ZzY0qN3qYHZCp4Q0UQm/vTPs3q1LuLCzcIHlo8eJUULBC0LTPurRm5dUGZhkFswzOXMyEjEz4vwJG/p5WcxGhcUyvJtGkeRdS8LJQj7U6+o8blK67ZjQYVAOyHrqkTPcIwI22HBDvV3R/Lsd+nIN+1riLLpHBRjsVA593LNJb6xrh5eaod5ceiqxvnLs1ke5/z2GFXHCZBSDVBaXnxG1ZKA4ojoxlhPZsJHQCEhmv9YgrFp+KtlNlSBcA39vRAvsWjV99UBzgLRaAdxuAkACjzDGBXamLBdcAvFbFO0IXuCmd0Y+gouUiKNytZLeoN60ErZSu0esi09WtXW6O3FPZZ/iyHlQVTnv7pWHxYjBTp00NGYwACW7Zha1w8UmD+pZhuMGUDB15/awZ4jSjiBmFUs0UHW0NyHDVg3EcF59XN82v76LKDAhho5de7XKiNTqAueKzCivyvmezTMgQsB1R902w6v+M1EHSU4o4bK4P5BYY64R1RjVHlQS3ce8S050TDL82BDLtE0un0KqPLDBWPwQ9n24GRfHSiFcjFwRdsGkLyagZzHm9yiI111xh14IqI5rMvpuxr+UA/Rpcxsx2uc+Fia
 74D57n9C
 gTf5ELaApVyI5FE2u8RDfppt3W3PKj9537TJdbY4PT2MGgbAY2IroJkj9Qqmy3Egfzvwn3FWfB0UGQxz1LlqC4XoU3TUnHbCnD3MCJRlBF8NlOCnMGETDiT8HFnOlClJnxcurNo6ZEDyvN1i0Cg4XxfqPNnRoIf6VPfJOVU/gCJ/gyXxdiAkmCl3K/h4xuCbkeE6ouWbAo+BkvQyRb11rw4FuXezBfnfZRewHCz1xaJjYebhKaJSRk+wYd8cGydhcOwyHWFLgtLsIHZw08Sw+xKj3Wy5I9BNZu7g8UjFXjUA5DvkAPDC2TuIATwWE/4bLb2tJBjmK8raAl6eNZxODkYGtKgDDjX6TGTkFByEVS708sXoa88VfuJ+gsLCZ/lM77rYX39LPWafQ+kY+Rz9YCp5nzYsEsf1gZ3mgiDB91Frmcz90G02XDiM/nldtvh8Itl1VNCGcYyRcwEomrOvBIOelB5HU1ZdIeN5gt4N0qbcdnuWQJb+heWD0pXj37uX7veAJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is simple test and playground useful kstate subsystem development.
It contains some structure with different kind of data which migrated
across kexec to the new kernel using kstate.

Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
---
 MAINTAINERS               |   1 +
 include/linux/kstate.h    |   2 +
 kernel/liveupdate/Kconfig |   8 +++
 lib/Makefile              |   2 +
 lib/test_kstate.c         | 116 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 129 insertions(+)
 create mode 100644 lib/test_kstate.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 2cd9e49abee5..e96da6d97e75 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13723,6 +13723,7 @@ M:	Andrey Ryabinin <ryabinin.a.a@gmail.com>
 S:	Maintained
 F:	include/linux/kstate.h
 F:	kernel/livupdate/kstate.c
+F:	lib/test_kstate.c
 
 KTD253 BACKLIGHT DRIVER
 M:	Linus Walleij <linus.walleij@linaro.org>
diff --git a/include/linux/kstate.h b/include/linux/kstate.h
index 5a95960e5b03..0ced0da37c8f 100644
--- a/include/linux/kstate.h
+++ b/include/linux/kstate.h
@@ -95,6 +95,8 @@ struct kstate_field {
 enum kstate_ids {
 	KSTATE_FOLIO_ID = 1,
 	KSTATE_KHO_FDT_ID,
+	KSTATE_TEST_ID,
+	KSTATE_TEST_ID_V2,
 	KSTATE_LAST_ID = -1,
 };
 
diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
index b6ea861006bf..af9a25bdcd6e 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -69,6 +69,14 @@ config KSTATE
 	  state, save it into the memory and restore the state after kexec
 	  in new kernel.
 
+config KSTATE_TEST
+	bool "KSTATE test code"
+	help
+	  Build a simple test/playground code that is useful for kstate
+	  subsystem development. It contains some structure with different
+	  kind of data which migrated across kexec to the new kernel
+	  using KSTATE.
+
 config KEXEC_HANDOVER
 	bool "kexec handover"
 	depends on ARCH_SUPPORTS_KEXEC_HANDOVER && ARCH_SUPPORTS_KEXEC_FILE
diff --git a/lib/Makefile b/lib/Makefile
index 392ff808c9b9..46616577caf3 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -316,6 +316,8 @@ obj-$(CONFIG_PARMAN) += parman.o
 
 obj-y += group_cpus.o
 
+obj-$(CONFIG_KSTATE_TEST) += test_kstate.o
+
 # GCC library routines
 obj-$(CONFIG_GENERIC_LIB_ASHLDI3) += ashldi3.o
 obj-$(CONFIG_GENERIC_LIB_ASHRDI3) += ashrdi3.o
diff --git a/lib/test_kstate.c b/lib/test_kstate.c
new file mode 100644
index 000000000000..70534e8c718f
--- /dev/null
+++ b/lib/test_kstate.c
@@ -0,0 +1,116 @@
+// SPDX-License-Identifier: GPL-2.0
+#define pr_fmt(fmt) "kstate test: " fmt
+#include <linux/io.h>
+#include <linux/kexec_handover.h>
+#include <linux/kstate.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+
+static unsigned long ulong_val;
+struct kstate_test_data {
+	int i;
+	unsigned long *p_ulong;
+	char s[10];
+	struct folio *folio;
+};
+
+#define KSTATE_TEST_DATA_ID 123
+
+struct kstate_description test_state_v2 = {
+	.name = "test_v2",
+	.version_id = 1,
+	.id = KSTATE_TEST_ID_V2,
+	.fields = (const struct kstate_field[]) {
+		KSTATE_BASE_TYPE(i, struct kstate_test_data, int),
+		KSTATE_END_OF_LIST()
+	},
+};
+
+struct kstate_description test_state = {
+	.name = "test",
+	.version_id = 2,
+	.id = KSTATE_TEST_ID,
+	.fields = (const struct kstate_field[]) {
+		KSTATE_BASE_TYPE(s, struct kstate_test_data, char [10]),
+		KSTATE_POINTER(p_ulong, struct kstate_test_data),
+		KSTATE_FOLIO(folio, struct kstate_test_data),
+		KSTATE_BASE_TYPE_DEPRECATED(k, u16, 1),
+		KSTATE_END_OF_LIST()
+	},
+	.subsections = (const struct kstate_description *[]){
+		&test_state_v2,
+		NULL
+	},
+};
+
+static struct kstate_test_data test_data;
+
+static int init_test_data(void)
+{
+	struct folio *folio;
+	int i;
+
+	test_data.i = 10;
+	ulong_val = 20;
+	memcpy(test_data.s, "abcdefghk", sizeof(test_data.s));
+	folio = folio_alloc(GFP_KERNEL, 0);
+	if (!folio)
+		return -ENOMEM;
+
+	for (i = 0; i < folio_size(folio)/sizeof(u32); i += 4)
+		*((u32 *)folio_address(folio) + i) = 0xdeadbeef;
+	test_data.folio = folio;
+	return 0;
+}
+
+static void validate_test_data(void)
+{
+	int i;
+
+	if (WARN_ON(test_data.i != 10))
+		return;
+	if (WARN_ON(*test_data.p_ulong != 20))
+		return;
+	if (WARN_ON(strcmp(test_data.s, "abcdefghk") != 0))
+		return;
+
+	for (i = 0; i < folio_size(test_data.folio)/4; i += 4) {
+		u32 val = *((u32 *)folio_address(test_data.folio) + i);
+
+		if (WARN_ON_ONCE(val != 0xdeadbeef))
+			return;
+	}
+}
+
+static int __init test_kstate_init(void)
+{
+	int ret = 0;
+
+	test_data.p_ulong = &ulong_val;
+
+	ret = kstate_register(&test_state, &test_data, KSTATE_TEST_DATA_ID);
+	if (ret) {
+		pr_err("register failed %d\n", ret);
+		goto out;
+	}
+
+	if (!is_kho_boot()) {
+		ret = init_test_data();
+		if (ret)
+			goto out;
+	} else {
+		pr_info("restoring data\n");
+		ret = kstate_restore(&test_state, &test_data, KSTATE_TEST_DATA_ID);
+		if (ret) {
+			pr_err("restore failed %d\n", ret);
+			goto out;
+		}
+
+	}
+
+	validate_test_data();
+
+out:
+	return ret;
+}
+late_initcall(test_kstate_init);
-- 
2.49.1


