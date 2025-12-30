Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C2AAE94121
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 14:13:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF3D66B0005; Tue, 30 Dec 2025 09:13:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA0EC6B0089; Tue, 30 Dec 2025 09:13:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D82F56B008A; Tue, 30 Dec 2025 09:13:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C34486B0005
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 09:13:43 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 24C3514015B
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 14:13:43 +0000 (UTC)
X-FDA: 84276330726.26.706C80B
Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	by imf08.hostedemail.com (Postfix) with ESMTP id 19139160009
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 14:13:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.161.44 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767104021; a=rsa-sha256;
	cv=none;
	b=atRmdyXYsAcQvqW7q2AL90cQ2hNoU1RdYoaE4LFqVHr5Vy+h+LT1L5TPHdQ6Cdu69zwZgM
	UegyFQ78OvydVVpyyA+W9XvSPGlFmgJBGJrCky8QxlKijBRMtB7qUy79/276yz2L/HhUlF
	VxhvZ0jOairRXThXoZRNIdCtfsB5NeA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.161.44 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767104021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=mLK1D9aqGISPxdXLsfOEkDLEGBqoig1fU8f2AHbKcKI=;
	b=Zux/SKMykrA2QeFGnBIHaPgk0iI/2t1le+H2VNNCDBeygrnCamPCprL/Dbsap/QVT2UfuL
	m69fdbBJaqflXAE5YqMbz5xmglgfoQHu9bXjKmHC8SBv1JWzgE2HDp7N5H6X/w6UToR08I
	Y/a3ToR18kBtKv56Nn1LrdqcWYYUtwY=
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-65e943048afso1617642eaf.0
        for <linux-mm@kvack.org>; Tue, 30 Dec 2025 06:13:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767104020; x=1767708820;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mLK1D9aqGISPxdXLsfOEkDLEGBqoig1fU8f2AHbKcKI=;
        b=e1zzJcoElItAjaiFZExNP4I3lQAZlEuC4e8HVUowVvoChuama1znQ6/NExs+W/lGrA
         zuQOiQX4YSCobdvqgqAAoYoHvhXLWYvefz+V7Rf4LMPu9Xwk75FfaB/qGthnbK7j/EJJ
         QkVqpB6LYErg5TMJcI8/cCCJlZDWFBcIc0XSrHc148wH2gpcXZ3RXc54n8ONuaZL9vvR
         Wvcwz8yX6g2dvckwmC0siL+u89LWE/B36mnm1tiVsB4HDll4hFlju4mCiZj/sbohQ77K
         zMc4Juhw2uWCAQwf6lMGfrfYYWR7nvQSrnmxOK+sawTZcBsMZwEXCmd6yF5ZbkZoxWXm
         ncGA==
X-Forwarded-Encrypted: i=1; AJvYcCUVUt1ZOThpZGlnHxrzm6uydN8TZZqClXLnko3pnkuCffMg4LdZYOMWJMC/dsvmZs4zwOBZnzK9rg==@kvack.org
X-Gm-Message-State: AOJu0YzoXyyR6m95ba3dyfGSqYqBx4JG3esklCy309WrhBXe2nPBL03+
	3F0OIGCCLThKcuPZULOKXlzUVuKuq8hd9aNbKVC+aUn5xN3EF1JIOOhL
X-Gm-Gg: AY/fxX6Q8VpxnjxPqVM8h3W62AUuRkKidlULVrpa9cbDAPkm6GKVUx2YUnFfcp2m1FW
	1Ptbw1YFFMxxQhUz/klDMB6TdhfPA2t5mgPMCgc5H/g/DrjXyxqL3dhza6fb8/JuQuiIE9U2ujW
	kv8IK0fimXE8piM/o2jmmuHAW02ZIoWBubleB6ol9AuCt6noQ2Sn9Mhc6MDTshLkTIeuNMqgmuI
	H2lkiBiSmf2x8rj60LiRj9LZZhaDoPfrviZyNxSZouizgrtESMEmj55CJ30zG4Fr0QnshyD+G69
	lrOq1WI1oGZLgd0QNFVpXb7UW23C3VslFQHVITFsP8oky1Y6fluWiAAsW+aaO4ZQcPpsiHLoS/+
	t5YriAFoRE/O7BZfHAhp2RXjnK9WF4l929AkkvqVeWhF0o72ZPqS4yc3EaKEEYNHCc5m7bcrqP6
	/LQDBlZ9CQyzvMbA==
X-Google-Smtp-Source: AGHT+IGv4hgA4RK+/hAqnWuIzxUEbkxk7UI7cZze7GMuRgrBPu7eHE9ZgTQA0cPeHSPZAv5YDbYeLg==
X-Received: by 2002:a05:6820:267:b0:65c:fc36:4a6d with SMTP id 006d021491bc7-65d0ea4be60mr10400519eaf.28.1767104020021;
        Tue, 30 Dec 2025 06:13:40 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:4a::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-65d0f4b7c42sm19071790eaf.6.2025.12.30.06.13.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 06:13:39 -0800 (PST)
From: Breno Leitao <leitao@debian.org>
Date: Tue, 30 Dec 2025 06:13:23 -0800
Subject: [PATCH RFC] kexec: add option to print previous kernel release
 after kexec
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251230-kho-v1-1-4d795a24da9e@debian.org>
X-B4-Tracking: v=1; b=H4sIAAPeU2kC/6tWKk4tykwtVrJSqFYqSi3LLM7Mz1OyUjDUUVBKz
 kjMS0/VzUxRslJQMjIwMjU0MjbQzc7I1zU3NzBPtUg0Sk0zTFXSUVAqKEpNy6wAmxKtFOTmrBQ
 LESwuTcpKTS4B6VeqrQUALnl+n2wAAAA=
X-Change-ID: 20251230-kho-7707e8a2ef1e
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-mm@kvack.org, usamaarif642@gmail.com, rmikey@meta.com, clm@fb.com, 
 riel@surriel.com, kernel-team@meta.com, Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=5289; i=leitao@debian.org;
 h=from:subject:message-id; bh=gK8KJEjlEAfBqObb/slM/LZJZuItTQI6xDseBucP/Xg=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpU94SxD28tleBbvF+TLi4wjE43Uo4k3nzDqek3
 Fv/zPpwjAGJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaVPeEgAKCRA1o5Of/Hh3
 ba4YD/wI9BraF2/4xSe6rqirbLk4zVpwJGQ2RcsjWPrxVDHiKcj3e0uyeGj5kdNnx+FFsXA3pqa
 SUnhvSCMrm7vR3FqxrTyeb77jRLtWRSxQiohSjMyu8pqQAGCGL4Wv9dztVb5y/IcWcBtR0J1o+m
 pt1uzfl4le4JR0LZRllCDBexg+A57AByhm5wXOCT+xxHoMMCzBxWkBBDvM9fy42pgQwdaYsJzTh
 20B/OVWtDJ/QQrTfBBPIE9DF9Q+ipIsaAhR99jDObV3L9h/rGnqFb05IIqCdoivDdA0V0smIi6c
 7xfpCZSIRAboZdxhscYDxScngYQhSt0kaN2Oeo8/fXJRFo+homluJE2VUrFbC4tayop3th9C9fq
 aIT9fWMUHse6s9HTsBJuaXuhrgc1m7Cyo1TaHWlOaX/cYjzi8I4yxNNAlSu4zMqwqcIimljF3io
 DYXtHfaEskHUMd3G5nlxiyRDR1AiOV2434HQIrTf/bfaK7TEKTvaBlt+voftPyhQENAkurkrRiB
 /Vg7vzd72AUkGAwssxxjSqQOLoTs+1DCUlqQ5lYQIPlR3u++sKPlVAzwLbZAEzacQ/jZAPG4KcL
 Q2f691EiEYQmosm42BofSABJctYq8o18hGfdgvBGa7JLsV/cwdmNdxyRZgcwmej9VCxdkHOD2GF
 yH5pXsXX4QlW+Bw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Rspamd-Queue-Id: 19139160009
X-Rspamd-Server: rspam03
X-Stat-Signature: t75dpdbd1ng8kysxisnjhwifwow5ewdy
X-Rspam-User: 
X-HE-Tag: 1767104020-965414
X-HE-Meta: U2FsdGVkX18kB3yyTW2iQ8f36q0S0EC8zZLyfHcbGfBPmjP3CZnwa4hSjn5UsVYy01E39HAqAf8wehPbiXrrwUx0BVqy+X0OpOARJ2M0Ygy/vCb6yTFyamdL2ZF9+miXP6zwItkPe5zKl+jejtEqLGi9nUGfcKa8g+0RzB6S6oogf0od1piZ0F0KWqonOiQnqvr0EdAHHBFQJfGX6Nz+Bd9esAh8eaFldm3QbpGj4AkhgwIPLoUrpI9AQJSilRih2uyGXhBM2qRHdvvgdoDSH278fK1Q64bCZBFaXQTWHChQhrKGYMmnTDV6Ko9Mjn5C1ynFWzwm87fK5Lj/bCKkrbhTs+K9SNM7SK2qGsczRmlbR5o63g0/heV2vfIgPTgaLhLVb30aRpvbQnL+6LlGwEyjV/B9QQqyIRIdEORYkMOiYV0DtJsPlolrJaB5ahDmHJ30pRDdVx++qQRGhR+YwExFSNa17y0kLk4HPCYiF4fkKGmosWVIEC4SEBzVKI2h9f6IzLwnfRQXWnd0DmbyoUdT5NSLT+l/rA7CE5KRUWCniCN3CEdl2GbJoQzxD32dvVl/ES/z6MGZZ2BoYRfCvFbNJSmAuvpdbCDnXSjopcJ4npXv6KFDhPvZ3qLsg0NUIjzFu8SmU6ps2Tl/xPHh6lkQ6KXC6tAklQhbM5zA41zFImlBK2VQz+BoaOIiCz6nHn7dJ7DfysNayovyGWqngxT/WnZVEaKgQHSluFBw2CLrGNezb9Fi0ZDZNQ/NAuCYKT8vIM0eK/kCu4w1IdvXqSsvMzubZVTSv1dEnwtXJHu+Rm2Yabk86EqZzaBCICjEh77Kqz1BEQVgFRQKpIOOFIFV5J+9v9oG8Uxg0lpacUH64NcVq+XicvnIzG+UR677c01QHZvDyNt3oaHQoyLZPmJ7qRoZi7SHKPyhW7iGXoR9aMZcnzi1azymkHy0XrealruqhcJM5OTfyX/ZfWJ
 YgNbMlrI
 3dijDQWlZv+zYFotQSGM8Cbboyo6hVQUP55bAAGfcmh/Bhv8II8/Wi83GoOVhO386gYnITpgvOt19EYLilgffVjpht6FfQPAjh08hBKqgLGueDvPxg7t6OXNdo46peTHX9wmWEUZK+sU3gtKud36X4LSkAj3Lks7xbINaxQC3OGIgvW7RGlyml+8rY6079XiXfHssZxayq0zuxs+v1Tgpgz6JfmlxtPFoaqxRebX91Hl9BNjLH7s41mUVOFiRpHErfg10vfItC8YnGxRvQlg8X0ZyhN+WndL0MxOtS20/xGig6IHQUzfKFnvILfQLbgjXnS2mGemfipc29RFzbuy1rBga7kjBBnGqzBToQbXsZkjDnJ3/TdSn7b64BWSdH4veZchcXsPF2VjxZM5t3EIFo124JwMTPAZBfTD4YdZAwjXrUAljGntN+eeHtLgF5QDdTjMSV7KxxcC5eywWuhjEJYo602dIbfMXVZO2nekCB5ITlpEQ/MVJ8a7JLi1rGlBqmwEN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new Kconfig option, CONFIG_KEXEC_SHOW_PREVIOUS_RELEASE,
which enables the storage and display of the previous kernel's release
version across kexec boots when using Kexec Handover (KHO).

Motivation
==========

Kernel bugs that depend on the version of the previously running kernel
are not uncommon, especially in scenarios where a buggy kernel kexecs
into a new one and the issue only manifests in the subsequent kernel.

Recent examples include:

 * eb2266312507 ("x86/boot: Fix page table access in 5-level to 4-level paging transition")
 * 77d48d39e991 ("efistub/tpm: Use ACPI reclaim memory for event log to avoid corruption")
 * 64b45dd46e15 ("x86/efi: skip memattr table on kexec boot")

As kexec-based reboots become more widespread among Linux users, these
issues are becoming increasingly prominent.

When such crashes occur, correlating them to the previous kernel version
is challenging, especially at scale, where the problem may only appear in
specific cases and it is hard to correlate.

With the introduction of Kexec Handover (KHO), we now have a reliable
mechanism to pass information between kernels. This presents an
opportunity to address the problem by carrying the previous kernel's
release version to the next kernel and printing it at boot time.

Implementation Details
======================

The feature is controlled by a new Kconfig option,
CONFIG_KEXEC_SHOW_PREVIOUS_RELEASE.

When enabled, the previous kernel's release version is stored and
printed during boot after a kexec. The option is disabled by default to
avoid unnecessary overhead for users who do not require this
information.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 kernel/Kconfig.kexec               | 13 +++++++++++++
 kernel/liveupdate/kexec_handover.c | 30 ++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
index 15632358bcf7..9f2a669e13aa 100644
--- a/kernel/Kconfig.kexec
+++ b/kernel/Kconfig.kexec
@@ -94,6 +94,19 @@ config KEXEC_JUMP
 	  Jump between original kernel and kexeced kernel and invoke
 	  code in physical address mode via KEXEC
 
+config KEXEC_SHOW_PREVIOUS_RELEASE
+	bool "Print previous kernel version on kexec boot"
+	depends on KEXEC_HANDOVER
+	help
+	  When enabled, the kernel will store its release version in the
+	  KHO FDT before kexec, and the newly booted kernel will read and
+	  print this information during early boot.
+
+	  This is useful for debugging and auditing to know which kernel
+	  version performed the kexec that booted the current kernel.
+
+	  If unsure, say N.
+
 config CRASH_DUMP
 	bool "kernel crash dumps"
 	default ARCH_DEFAULT_CRASH_DUMP
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 73da00aeaa99..9e90c8445864 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -21,6 +21,7 @@
 #include <linux/page-isolation.h>
 #include <linux/unaligned.h>
 #include <linux/vmalloc.h>
+#include <linux/utsname.h>
 
 #include <asm/early_ioremap.h>
 
@@ -36,6 +37,7 @@
 #define KHO_FDT_COMPATIBLE "kho-v1"
 #define PROP_PRESERVED_MEMORY_MAP "preserved-memory-map"
 #define PROP_SUB_FDT "fdt"
+#define PROP_PREVIOUS_RELEASE "previous-release"
 
 #define KHO_PAGE_MAGIC 0x4b484f50U /* ASCII for 'KHOP' */
 
@@ -1253,6 +1255,9 @@ bool kho_finalized(void)
 struct kho_in {
 	phys_addr_t fdt_phys;
 	phys_addr_t scratch_phys;
+#ifdef CONFIG_KEXEC_SHOW_PREVIOUS_RELEASE
+	char previous_release[__NEW_UTS_LEN + 1];
+#endif
 	struct kho_debugfs dbg;
 };
 
@@ -1332,6 +1337,10 @@ static __init int kho_out_fdt_setup(void)
 	err |= fdt_property_string(root, "compatible", KHO_FDT_COMPATIBLE);
 	err |= fdt_property(root, PROP_PRESERVED_MEMORY_MAP, &empty_mem_map,
 			    sizeof(empty_mem_map));
+#ifdef CONFIG_KEXEC_SHOW_PREVIOUS_RELEASE
+	err |= fdt_property_string(root, PROP_PREVIOUS_RELEASE,
+				   init_uts_ns.name.release);
+#endif
 	err |= fdt_end_node(root);
 	err |= fdt_finish(root);
 
@@ -1455,6 +1464,25 @@ void __init kho_memory_init(void)
 	}
 }
 
+#ifdef CONFIG_KEXEC_SHOW_PREVIOUS_RELEASE
+static void __init kho_print_previous_kernel(const void *fdt)
+{
+	const char *prev_release;
+	int len;
+
+	prev_release = fdt_getprop(fdt, 0, PROP_PREVIOUS_RELEASE, &len);
+	if (!prev_release || len <= 0)
+		return;
+
+	strscpy(kho_in.previous_release, prev_release,
+		sizeof(kho_in.previous_release));
+	pr_info("This kernel was kexec'ed from kernel release: %s\n",
+		kho_in.previous_release);
+}
+#else
+static void __init kho_print_previous_kernel(const void *fdt) { }
+#endif
+
 void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 			 phys_addr_t scratch_phys, u64 scratch_len)
 {
@@ -1526,6 +1554,8 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 	kho_in.fdt_phys = fdt_phys;
 	kho_in.scratch_phys = scratch_phys;
 	kho_scratch_cnt = scratch_cnt;
+
+	kho_print_previous_kernel(fdt);
 	pr_info("found kexec handover data.\n");
 
 out:

---
base-commit: 7620f9ccfabbdaf07620381264d8b8d91412542f
change-id: 20251230-kho-7707e8a2ef1e

Best regards,
--  
Breno Leitao <leitao@debian.org>


