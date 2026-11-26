Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E565606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k3kFIR10
Received: by kanga.kvack.org (Postfix)
	id 00D686B05BD; Thu, 26 Nov 2026 06:15:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFFD46B05BE; Thu, 26 Nov 2026 06:15:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E15396B05BF; Thu, 26 Nov 2026 06:15:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 715AA6B05BD
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:15:25 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CCA31403C6
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:15:24 +0000 (UTC)
X-FDA: 85477014168.02.4AE806B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1EF5414000E
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:15:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k3kFIR10;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795691723;
	b=4AMOGTmGJLyCLvRV0nW5j4QP3KGiublA5yTzfuFDhplU76CS52qYC3jXmS1ug5bSUYK75v
	ABZML4y/NvRmVapDnu2745uIO5usqFhUzG+qeUR56/kFMMt+a2saWx7qkJldi4m+GvozNx
	9QbumjP/p4wtVdRPUUYCSN8MlAxF2BU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795691723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zImSfvTk7Ce9C0Ntm689zz11A7MeuyzdnAnXV7c96Hs=;
	b=3DqYpQWoe9rm18SNoWtqPMq+ZbOaQ3h5Exa5mMxvYLjPeJ7MKPXURRz4wwAzclvYln513k
	hmVBoGwLpzY2oE/hN9aW03OUodpxim3cWJPei/oCQt99w8mW/2XmhlnjBCDOfB3/sFkgHO
	k2/KoUl6cCNzduDHKS9DIjJE2JRBTas=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k3kFIR10;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D98643224;
	Thu, 26 Nov 2026 11:15:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FCDB1F00AE3;
	Thu, 26 Nov 2026 11:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795691722;
	bh=zImSfvTk7Ce9C0Ntm689zz11A7MeuyzdnAnXV7c96Hs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=k3kFIR107EfL7OCOXCU8Gw8+wFHgYeB6pwLpvAtrtxNruSbP+IxmvekCmPdAtQpU6
	 UY9gwt+R1jj/XLJxRSkgFV/NN1dqYd2vaEiNbba2VGjRRqrndAy3W3NDIYMGpwGJdL
	 5I5xoLA6NN9oPGIT+cll+4qCT2QAsDrYc+8BocCiyQFLGSboxGfTEYTroUEdlDxo+c
	 GWTUcL/DyD6jX5uwq92MnSCE+qN75XIupuUympUcKEE9nsukylR8tAJqmagsFaNpi4
	 wqNpEf6O3v9v4sAEU0M1bRVvAdcO5ESPqGmgBJIygD3v50tp7Tk1xNsDGMbHsOcixL
	 hxaqNlHeGhMdg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:18 +0200
Subject: [PATCH RFC v2 05/54] s390/boot: treat dashes and underscores alike
 in parameter names
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-5-723f1e33c3d8@kernel.org>
References: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
In-Reply-To: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
To: linux-mm@kvack.org
Cc: =?utf-8?q?Adrian_Barna=C5=9B?= <abarnas@google.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Borislav Petkov <bp@alien8.de>, Brendan Jackman <brendan.jackman@linux.dev>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Paul Walmsley <pjw@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Russell King <linux@armlinux.org.uk>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vasily Gorbik <gor@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, linux-arch@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, x86@kernel.org
X-Mailer: b4 0.16.1-dev
X-Stat-Signature: 3iio8eksnj95bqt5kr87iuesorsijqq9
X-Rspamd-Queue-Id: 1EF5414000E
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795691722-631401
X-HE-Meta: U2FsdGVkX19Jwd4CCmmphfhmUDjXAHAF7smqomaJbfUj0Rih9qEGPqHjcTL6Mu9vP3KQocMnCMjO1+BIE3cEF8lTh1j4fFgFQqg4BATRzczZtNuCle5awpwWrxzQd+2y0kdGjGKquBGyOviD+PCWSRT4dAhv7guIuxTfB+VF4RAKNIPtjU5eIpaLrkuQv57eX3gsiQAz8Avirhf3XTm8mYPXUXjLj0zqYe19fCJxUKP8mN4CH2QjZCLDRPoQkFP2YCeHmuL8GTy7QNq0aj5sMtX6injMBX9rqz2rt3a5mIix0aUJXJ6tyCOcuh9MYwsQZlufONjlsmwCNpR9nUkA8x4f8eZn+Ktetzyr4ef3J2nVaZbtwfgD7R7bxAnNnZNc8uPNRQXfuqvQQ0BvhXwAk2m24uXqzoRJ4XblFloel0D9tmFEtYt/YEbAhHYzb8UXx+Lw7uSx+WS6HtXmjnjt8RjKArFdFH0G6YBRuhkcEdeotYPvacZdPN60iKh+NT73PVRa5+zK1eQdnnXWrKiUTMsF/YDwTLuj49AWHY8SCXt5OGPZ3D6UMJQWSCTdl1VxfVnpUmr8k9aWzaK6zIgdmvECMFSrkQYNLYHcfc2JsqMUB/4mcpu432eQ6ZNbHI92Gj7UZPcTEhnTngWb337pdwWh9kJZw3oXzSByTIgpq7AkYSppjXF8McIhvL7VuhZOHl4K2LsVcv7E6vBuJj2v6jXlNIR3fSPIxHBwRHUSkEIJHjxpxIHT2fbysuJzGD27afRqJw5yDQWC4g6NgAvjKubSjLuxYjCIj2SwIjSrVoyg039NGdvgOe98KXmwcxacYmaMRW9p1VaqRKDTWxlkvoYapNSjnyDbACWzFE5OIvGDIbcSrd7iy/Ws/ARBcaR7bLlKCAvnWllmHl2NKW62nu7R8VHjZTQ7Xveuo+4Sk3GJ3+YmaXDR8MzREPieJ9ynyxdDzjBQlXlUCWVzZbf
 MR76tQ1i
 er0dJisEDNP+1xIiIi8On6ByvB401Rxr3KLewDxG6XPQ6AH0fb7sjsYa450QDZK0TKR0L402EH9ijByP31YFiEjncacLAbHkpkFyLSjv36APnSA3piNn7P0WDInjD7mo8l3K8EXurv7cZIO4FLFuZqI6wJ/yXfgdvXAoy9S82xW7MZvAVmduv6IO4Uz3PLHYwAN2XoSnI30uzEeT1xrnwuTXcQzMblBNydxeQK+OPhnHH5Q7s7nkdLVOuCk4CHQds3v43qOmuU3mAJV4T3geO4PEkHrtwczCr1jdhoGixNcyQnhLZ7MmISMHwqZfd2MLXElpOAo9wfx0nf8mQpGFAfWi2J9HrR5Jo40+SKJaiSwrE/+ySxHX2kcBKfC6kvAbqrxOBc//2Z5ZcplJf2AJUi8dHJa7m8M7jaFqHK/9D2FjV/Uf4kgWEgn/zGHM6WdKAzAVveT4MNT69crmuAvarU4SEhyon9BU5lEEA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Dashes and underscores are equivalent in the names of kernel parameters,
and the kernel compares the names with parameq(). The decompressor uses
strcmp(), so it ignores "relocate-lowcore" or "prot-virt=1".

Compare the names like parameq() does.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/s390/boot/ipl_parm.c | 51 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 35 insertions(+), 16 deletions(-)

diff --git a/arch/s390/boot/ipl_parm.c b/arch/s390/boot/ipl_parm.c
index ed28ea2fc1d1..ac4cf1ced71d 100644
--- a/arch/s390/boot/ipl_parm.c
+++ b/arch/s390/boot/ipl_parm.c
@@ -255,6 +255,25 @@ static void modify_fac_list(char *str)
 	check_cleared_facilities();
 }
 
+static char dash2underscore(char c)
+{
+	if (c == '-')
+		return '_';
+	return c;
+}
+
+/* Dashes and underscores are equivalent in parameter names */
+static bool parameq(const char *a, const char *b)
+{
+	size_t i, n = strlen(a) + 1;
+
+	for (i = 0; i < n; i++) {
+		if (dash2underscore(a[i]) != dash2underscore(b[i]))
+			return false;
+	}
+	return true;
+}
+
 void parse_boot_command_line(void)
 {
 	char *param, *val;
@@ -272,15 +291,15 @@ void parse_boot_command_line(void)
 		if (!val && !strcmp(param, "--"))
 			break;
 
-		if (!strcmp(param, "mem") && val)
+		if (parameq(param, "mem") && val)
 			memory_limit = round_down(memparse(val, NULL), PAGE_SIZE);
 
-		if (!strcmp(param, "vmalloc") && val) {
+		if (parameq(param, "vmalloc") && val) {
 			vmalloc_size = round_up(memparse(val, NULL), _SEGMENT_SIZE);
 			vmalloc_size_set = 1;
 		}
 
-		if (!strcmp(param, "dfltcc") && val) {
+		if (parameq(param, "dfltcc") && val) {
 			if (!strcmp(val, "off"))
 				zlib_dfltcc_support = ZLIB_DFLTCC_DISABLED;
 			else if (!strcmp(val, "on"))
@@ -293,49 +312,49 @@ void parse_boot_command_line(void)
 				zlib_dfltcc_support = ZLIB_DFLTCC_FULL_DEBUG;
 		}
 
-		if (!strcmp(param, "facilities") && val)
+		if (parameq(param, "facilities") && val)
 			modify_fac_list(val);
 
-		if (!strcmp(param, "debug-alternative"))
+		if (parameq(param, "debug-alternative"))
 			alt_debug_setup(val);
 
-		if (!strcmp(param, "nokaslr"))
+		if (parameq(param, "nokaslr"))
 			__kaslr_enabled = 0;
 
-		if (!strcmp(param, "cmma")) {
+		if (parameq(param, "cmma")) {
 			rc = kstrtobool(val, &enabled);
 			if (!rc && !enabled)
 				cmma_flag = 0;
 		}
 
 #ifdef CONFIG_STACKPROTECTOR
-		if (!strcmp(param, "debug_stackprotector"))
+		if (parameq(param, "debug_stackprotector"))
 			stack_protector_debug = 1;
 #endif
 
 #if IS_ENABLED(CONFIG_KVM)
-		if (!strcmp(param, "prot_virt")) {
+		if (parameq(param, "prot_virt")) {
 			rc = kstrtobool(val, &enabled);
 			if (!rc && enabled)
 				prot_virt_host = 1;
 		}
 #endif
-		if (!strcmp(param, "relocate_lowcore") && test_facility(193))
+		if (parameq(param, "relocate_lowcore") && test_facility(193))
 			set_machine_feature(MFEATURE_LOWCORE);
-		if (!strcmp(param, "earlyprintk"))
+		if (parameq(param, "earlyprintk"))
 			boot_earlyprintk = true;
-		if (!strcmp(param, "debug"))
+		if (parameq(param, "debug"))
 			boot_console_loglevel = CONSOLE_LOGLEVEL_DEBUG;
-		if (!strcmp(param, "bootdebug")) {
+		if (parameq(param, "bootdebug")) {
 			bootdebug = true;
 			if (val)
 				strscpy(bootdebug_filter, val);
 		}
-		if (!strcmp(param, "quiet"))
+		if (parameq(param, "quiet"))
 			boot_console_loglevel = CONSOLE_LOGLEVEL_QUIET;
-		if (!strcmp(param, "ignore_loglevel"))
+		if (parameq(param, "ignore_loglevel"))
 			boot_ignore_loglevel = true;
-		if (!strcmp(param, "loglevel")) {
+		if (parameq(param, "loglevel")) {
 			boot_console_loglevel = simple_strtoull(val, NULL, 10);
 			if (boot_console_loglevel < CONSOLE_LOGLEVEL_MIN)
 				boot_console_loglevel = CONSOLE_LOGLEVEL_MIN;

-- 
2.53.0


