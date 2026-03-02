Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2527EA4E24
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 15:51:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13C956B0005; Mon,  2 Mar 2026 10:51:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EA0B6B0089; Mon,  2 Mar 2026 10:51:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0130A6B008A; Mon,  2 Mar 2026 10:51:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E680F6B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:51:05 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ACA95B6CFE
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:51:05 +0000 (UTC)
X-FDA: 84501561690.02.C8C6F81
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf15.hostedemail.com (Postfix) with ESMTP id D27DFA001B
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:51:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=UBpIMI2M;
	spf=pass (imf15.hostedemail.com: domain of r@hev.cc designates 209.85.214.174 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772466663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZTP8GuicL4lDMlLNsmOlZZBi51EIqCGshrumwx1QleU=;
	b=P0HrKqcXPtW8r9Ful6HOdU4OvHXQZRpfZWSZdSu+G2ZF84XM17fGMGwzUUvYYzGPW53Mgi
	P3GsUzqw7yT1EGijabM/jMNrIZhLYpsbqaW9/AhYRFYNzCrcgH7S4zbMdFxpzoMmycY4i5
	yHL9RvrWDqa0qpETHhSpoGaL1UbfsEU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772466663; a=rsa-sha256;
	cv=none;
	b=04m7hWiFry0SLrwDP4zcdpq5gvYpPndQ1XJo8tn3zLSM9ramOMORbwNHrjpk0clPatzd+D
	PwdcCX8mKPEoaccFuh84hbV0plIzf1YZk/1c3ZsxfjpI7J6mTdgFJxElWDNwaN5fztZfcQ
	yRtSx1rG+06z9A47Vmx5s1KmWXZFgCc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=UBpIMI2M;
	spf=pass (imf15.hostedemail.com: domain of r@hev.cc designates 209.85.214.174 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2aaf5d53eaaso32044765ad.0
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 07:51:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20230601.gappssmtp.com; s=20230601; t=1772466662; x=1773071462; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZTP8GuicL4lDMlLNsmOlZZBi51EIqCGshrumwx1QleU=;
        b=UBpIMI2MKDrgLOtjGLwSXinoh5G0lUjj09i9kPmw4RXyPYrHUnMpK2lSedW1zcE+jp
         9pii2kza+AkrHtmEWAZ0szcRPxkJd2dbPCFnq9xrNbMtItakKhik0Mg04LF66goYne25
         5NQ+zoOr+NJwKqtyXaMkNEv/669md4WObIqiKvPRo2DvEnja29e+ePHkTVi0U4pDqZIY
         jo7Gd1Mia1m5DBbYM3PCouaI//bcz9W3S+7k742XqRftth5PNlXgRbcOZaBTtyY6PR8E
         fMgpXDOY00YFzJ1P4pS/3EuPUT7gA4Z6l3ndlUTJhvyawzVcMogEvEV3Ld0pAwgUiUsb
         NiaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772466662; x=1773071462;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZTP8GuicL4lDMlLNsmOlZZBi51EIqCGshrumwx1QleU=;
        b=EXN36gUq+Mf1Z8hoGEPcyy/123U6+44LJPHPIn/BqWI3JQj3qzTd1i1Jeraxc12eRR
         JO8mJ4IydVwaYGkTBbhZy4eajU8xYlQwZmHXy9ADWbQLimL9/5x1JKqOEoG+P3v6S6sh
         L2fBdvocjxyDWQiNHUC7RZDdmtieggTilxuWRHsxS75V2Uol7Q6TCjQ57+dxMFxCr7uz
         rJNYU1HZTH8l3wg0HoL34+y5CWUMV2/G4WkautyDpf9EkwXjlal6u567gR+iteYhFlPU
         fva6EXnYqOUaLwP4RBFeMeTObMbgWXfe2C3waOE4ZVMWEJUswadG+3OzRbzYEkD53yjl
         ueXg==
X-Forwarded-Encrypted: i=1; AJvYcCUw9d1totZ4aJWi2H/maMBJrERTilfJTDW05+Xo4zl1klha/SAC9UKvX9fibFi3FhYoiq79c41DtA==@kvack.org
X-Gm-Message-State: AOJu0YwM+fjDtVueHjA+gb/wsLDWMllXKbUSNhjkDXoKpsiu0UsJIrV/
	Goq4uJiV+6Mvuwv6Yu1jGW5Upamu17Ag2NCgPjmyNBUS75xHMOqInCRAZYV6gc+UrvatGox5FF7
	/6Nu6
X-Gm-Gg: ATEYQzzJvtVnFFgzItJyebBU50xgEBQxqxHrML4hpIcrm+nD6mpXzgEFmz1/S8cRr28
	xrQajHyqXIg7TOKnpyRn6NEoC2teArVwzRGgb8TxLWE6TxuDug8NumK5EON8pdrlt/Knd+QtirH
	KjBV+P8RTdtyvJhH4/klBQo5dT9VT5Uv3Rnr91XvkrktGcIfXr0CEFFX7KR+4GZPIPH5Qi3ogLw
	H/w0RxeGZ1mmn14RmmzKEyT9DibcKch71voxvM46KotQ2r+2zUGwt+7JvmQrXJOkZT6Js0OvpLd
	cTP9i8UaoYZavI5sMAYUki9l3UuDaKV9Hva0G8P+toI3MmMZ7amCYfNusk0+4E1B90UF6wodhHX
	YmN5JjJtxLzeK++NtM6zOQuOGtPa6cExXNHTMJxSzXcgcqwt27Ox2tYG4tcck18cb+LxUtwKhhu
	WJxGSIPfhn
X-Received: by 2002:a17:903:3c6d:b0:2a9:47ff:1020 with SMTP id d9443c01a7336-2ae2e3e3c2emr111057265ad.8.1772466662493;
        Mon, 02 Mar 2026 07:51:02 -0800 (PST)
Received: from localhost ([2400:8902:e002:de08:5754:7dac:85df:935a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb69f244sm153611115ad.59.2026.03.02.07.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 07:51:02 -0800 (PST)
From: WANG Rui <r@hev.cc>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Kees Cook <kees@kernel.org>
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	WANG Rui <r@hev.cc>
Subject: [RFC PATCH] binfmt_elf: Align eligible read-only PT_LOAD segments to PMD_SIZE for THP
Date: Mon,  2 Mar 2026 23:50:46 +0800
Message-ID: <20260302155046.286650-1-r@hev.cc>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D27DFA001B
X-Stat-Signature: pj6dke4zjay54itpcgg87j5x39y71nbb
X-Rspam-User: 
X-HE-Tag: 1772466663-495667
X-HE-Meta: U2FsdGVkX18NQYJZdZ3/utDY3jdFmgFh2dl+qcGjXa/pXuWlmM5p/MDHQ6X+M5sobAJmWgnfqCJiClMzkOm2Cw5e7uYhN6E+7zbyv3Xp3haBlefNEHqLzBlD3IMDK0untRatXkz+HJu4Q53xt72dimRSG9nhG69C1Vl5JQazzfWGc8L/2hN9C2vtf5B2rCkwhrD9Y/FkN49v5GBX1BLtCXbIbsMDdfwlHysZER9Gr8JL3EvCKbuGBkQG7DDZhB8p5nlhQQ3zdXD2ea2iRhHCGpdr19i+vT6l+r+1zsoIG+rFisJz9geA99n1DHHK5A1bjoHnueyZJ8weP+QVWi5QDgYUfVN2zKMvHQy7XtKDhlXRjKdCO1k6XavFW+xqNpvZj9sGiIFHfYi7WOqe8RyPVT4V09Fm9M2/UKglHyI+ygam6mu4ZUtE/Vlwyyyy3vX9GCVKwe45I5Tt3xU0f47zVWaNZsh0UEgutmg5i39m0RY3qo/Eb2HlhUO3biEEdJ1dhw+6u+88G7bQpIBu/7elZfeLdj8g9g8fSRn7CHo91noC9g/iODpgstOtokUlTogZiAP7/9FrJuIuMCU+8Eg8jgqCiC1kTScmbLL06QGn3WSwteeJn9hCG1UDUrEofQWZXOLujukGTjDuluBolNtnGi1ce3I08xD2lDsgTHOhgX+UPPTQn8GOaz61nmWIhrgm4PqK5CrkY2/xqXrAhMKCa+H1ZoT3lRq4v8i568K4dLwj/+kuWT5RHlBWSydGQch4Ey55+wdt+1erOude/1bJAdTfY9VMwg8mLJFuvhBZqhH74C1tB5jHozivTUP8mRIcABikac0kXXDoX57w/RUViZBDRI70+8pw1PEpMuyEWAFDccXbv+2i+/Xk4joenuQOXt/E+kXnjRay2txfcrFmdK1qSgxHV6C5RW+cuKPsDgr0L8aaA2+j0doF+7dt26/8szAhwh/UFki7o3uzudG
 VbULVxHI
 xH8mNsdWJxIU2iLVtb2ovujOg9eYiBgrrg4U/OkfXN3fu5Qr/m0ePJs5pGoIjJ/ytwjp/AIRUqjsm27QUtYaccuxLfdKo1QrvaFupacP+PpcatXoVp80Ea/kzxJELPofTkfHECDDC4Ze4Aj5v84v0/MqOaOzUd73Fyn4VjMzXRZMSwaOI6lyOsXGuUjmukV5BWtiFbMS1PLDzBcF1BGPTK83ImcTsz4JZ5A+mh7oNhEhMQ68NoAH8BvtayXk3DcAGj/dUZmQTzP6N+XBoNf6GswX2UaIrZ8VzF+I3Y/GS7nQK9CYXhOvXOPQO/4M9wooWy5qGLggnkLozlwA/Ux9Yy3yKAw4zEBHhkGjzQmemAyUdiWGstN2FNyrshY6UuESnWTJR6va+o8p1T0tgI77qYr1MqGNxnUGUVUkIs3pHrU8dXsFh0+5UQW4wcRol4RryytYD+jgiARMpCCDVIAluuI2UOuYRL9c4g7Q0Bz1PfsMFiojkuCxtnWj4AO7NXMOvvjkXoFZp4bMa1kkcBu3qxj9ChB/zoXb4/JROXYdoRw07OcV/4e4rtfMOzl+677oQ0mUs7wfe6NN8Q0lbfqWi9CQfOhVRh96X4k+xXcKmynwsLflFq8p9CKM80963W5AhaYkYE1C6Lb/uc9znggPJahzjjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When Transparent Huge Pages (THP) are enabled in "always" mode,
file-backed read-only mappings can be backed by PMD-sized huge pages
if they meet the alignment and size requirements.

For ELF executables loaded by the kernel ELF binary loader, PT_LOAD
segments are normally aligned according to p_align, which is often
only page-sized. As a result, large read-only segments that are
otherwise eligible may fail to be mapped using PMD-sized THP.

Introduce a new Kconfig option, CONFIG_ELF_RO_LOAD_THP_ALIGNMENT,
to allow bumping the maximum alignment of eligible read-only PT_LOAD
segments to PMD_SIZE.

A segment is considered eligible if:

* THP is in "always" mode,
* it is not writable,
* both p_vaddr and p_offset are PMD-aligned,
* its file size is at least PMD_SIZE, and
* its existing p_align is smaller than PMD_SIZE.

To avoid excessive address space padding on systems with very large
PMD_SIZE values, this optimization is applied only when PMD_SIZE <= 32MB.

This increases the likelihood that large text segments of ELF
executables are backed by PMD-sized THP, reducing TLB pressure and
improving performance for large binaries.

This only affects ELF executables loaded directly by the kernel
binary loader. Shared libraries loaded by user space (e.g. via the
dynamic loader) are not affected.

The behavior is guarded by CONFIG_ELF_RO_LOAD_THP_ALIGNMENT and
depends on READ_ONLY_THP_FOR_FS, so existing systems remain
unchanged unless explicitly enabled.

Signed-off-by: WANG Rui <r@hev.cc>
---
 fs/Kconfig.binfmt | 12 ++++++++++++
 fs/binfmt_elf.c   |  9 +++++++++
 2 files changed, 21 insertions(+)

diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
index 1949e25c7741..8d4271769e08 100644
--- a/fs/Kconfig.binfmt
+++ b/fs/Kconfig.binfmt
@@ -74,6 +74,18 @@ config ELFCORE
 	help
 	  This option enables kernel/elfcore.o.
 
+config ELF_RO_LOAD_THP_ALIGNMENT
+	bool "Align read-only ELF load segments for THP (EXPERIMENTAL)"
+	depends on READ_ONLY_THP_FOR_FS
+
+	help
+	  Align eligible read-only ELF PT_LOAD segments to PMD_SIZE so
+	  they can be mapped using PMD-sized Transparent Huge Pages
+	  when THP is enabled in "always" mode.
+
+	  This only affects ELF executables loaded by the kernel ELF
+	  binary loader.
+
 config CORE_DUMP_DEFAULT_ELF_HEADERS
 	bool "Write ELF core dumps with partial segments"
 	default y
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 8e89cc5b2820..2c2ccb041938 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -28,6 +28,7 @@
 #include <linux/highuid.h>
 #include <linux/compiler.h>
 #include <linux/highmem.h>
+#include <linux/huge_mm.h>
 #include <linux/hugetlb.h>
 #include <linux/pagemap.h>
 #include <linux/vmalloc.h>
@@ -500,6 +501,14 @@ static unsigned long maximum_alignment(struct elf_phdr *cmds, int nr)
 			/* skip non-power of two alignments as invalid */
 			if (!is_power_of_2(p_align))
 				continue;
+
+#if defined(CONFIG_ELF_RO_LOAD_THP_ALIGNMENT) && PMD_SIZE <= SZ_32M
+			if (hugepage_global_always() && !(cmds[i].p_flags & PF_W)
+				&& IS_ALIGNED(cmds[i].p_vaddr | cmds[i].p_offset, PMD_SIZE)
+				&& cmds[i].p_filesz >= PMD_SIZE && p_align < PMD_SIZE)
+				p_align = PMD_SIZE;
+#endif
+
 			alignment = max(alignment, p_align);
 		}
 	}
-- 
2.53.0


