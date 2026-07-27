Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C8DCC531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:35:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FACA6B00A6; Mon, 27 Jul 2026 10:35:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AB3C6B00AB; Mon, 27 Jul 2026 10:35:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 773226B00AC; Mon, 27 Jul 2026 10:35:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 35EAB6B00A6
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:35:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BA35EA07B6
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:35:35 +0000 (UTC)
X-FDA: 85034805030.01.ADA1157
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0A4B41C0009
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:35:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XSpvSVbm;
	spf=pass (imf21.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785162934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5hdCu1wf2k5fVGlVM7jRlnxeinlriHXvmsiXxLfmcKs=;
	b=utfVmQ/wtZM2OQowrQ9P0s6kvX07ajKrYfftQ0UMadwT6bkCajCSvZcR5kmADAUqVn8oFl
	zju9Fnl3A/SG0YWxSYzOF0YvYAaVoIQ5ky97I3BY8M6npqAOdBm0vPYo9P2QChKwX8Zk/M
	2FyR98tRGjb1gHzcu7qKIALTbiV3/f8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785162934;
	b=gp/Mwkt4KLaTR7XrdSjKDbcTrIAWsCea7lvc5wljdjUXsRWeEILeAx/bhE90qG7VzNH/wC
	VUBn+Y5Fj9QhNZgJZXqZy3mmyquzhBPhZ6fPphqpYu7eGwqZyf5ALBuRURwJLJdUKmQvmN
	KoILkjgIqpgnAB5XpASn4L8NqCnZydk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XSpvSVbm;
	spf=pass (imf21.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-ca957338f14so376960a12.1
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 07:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785162933; x=1785767733; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5hdCu1wf2k5fVGlVM7jRlnxeinlriHXvmsiXxLfmcKs=;
        b=XSpvSVbm9AcWr9TtNu/xutma8KUKU/9W3ToOl7KBtD5owINU3gE4WBjLWZ5k69Z6f6
         Z4hfQyf+hZl0+bCMroPvH+1HkB16MFT/sCVI2/enaKhZNXHc9W3Kfl5t9XvP5rNJohTC
         Yu2DnFa2YMTOZZ9MGiyIlMjkmTL2zC+S2LwKFK83KvTuk1/aor3KKrYjDkEfJBTuysBH
         GrhHjKB7rzhaI1z7o7Xuu3i2s7xGs6SluNppVBji2xiZ4Po0DPq2Nu7ayNWGZW40ywC3
         iNqAsyWSpN3YNqDh3cdR1f8FW5+wQsUbPMDKtw5sGb2XB/bDs8LMLubtMSGEA2+XO3FD
         h4yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785162933; x=1785767733;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5hdCu1wf2k5fVGlVM7jRlnxeinlriHXvmsiXxLfmcKs=;
        b=AD8LOiUJ8pzxprVBGW1R8ZJE6g+rNppzTZefZwMQRrebCmELZ5XRs5wFUWHg7ibJDF
         3QqAwHR08RbbtpP9R0DrvNRe/5I4s6oICy/zVh7zBqn2Sx+N5zsq0Mj/jUOYVfql/fGS
         qnp//aVT/7dua1piFUA5O7XFX6togpbebMPwOg8SNnF0cRBVbB4nPuILqcQlDMx1yzDI
         HAW+YgXp6e4nVoyn3W/JPsZd2MIJMm65NG8WX3psuRC5ojh5sGFrhcbbhZnnqchKwYHu
         jkzmmjXoc4hiG46gcFC/x7hKrjoWPiDsYTxqyR4JDG+TPEpNUf2jRcroxr4usvIHs8+x
         LQ1A==
X-Gm-Message-State: AOJu0Yy58+XSdcTXdba1Ylkh3NSS4ZtoaLCnZ3YucEEbYwvUJ5uouNM7
	Zzuw+Jnks4NQTwhN7AEpyDJTcVGuLhczBXbyMb6BG61U5QjXZW0XWo1KR+2PmrwP9TrFK5Pr
X-Gm-Gg: AR+sD10XYItJaEumfJ3aVrwoA7tSMVKSrgq3xUDkkITkJcv//Bc+oj9brGFti+2N+7+
	yUj6/f2zB3k4LEZKewQ/viXXPBwU8XJD87u3jaqcdc/k0KfyeEvMyzfUI5c1/gMQuivpkmsmW+4
	NwSsJ4MgcPaWUhMyFlLoAb4KcU8PclqYv9k61aoedCZqDezXLaN00lovOGTsMlJkWNpmRiDTmsV
	S6YAuMqdQubidGnBC26SPjN5MQkfPSPBqoTS9JEnwcyAa2tQqZEChJ0MW7tUDNQe+kCs9ABCmFR
	ag3v21IMAsHQOh9re9jOZMOt5/l0skHC6VMtzIEwgTKC8ksFrJHsBI8l5ssQJ5NiBmcNOD0MgA6
	tsPGOh8UMOAyr1pp1lKS9Ci68EuTC3bTMD+7QSQi+wymAUnroYpz4GOxmUVHoZgsFlhbduYqfzS
	FZkcdfGLPULYhA/wQgs1d56qrSGiBs2+mQ/gHfmxd84CINdsaTdhnwkdws3PPZUdhZ
X-Received: by 2002:a17:903:1aee:b0:2cf:7dfa:7f56 with SMTP id d9443c01a7336-2d00b485487mr3911605ad.2.1785162932832;
        Mon, 27 Jul 2026 07:35:32 -0700 (PDT)
Received: from debian.lan ([141.11.42.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde7d5297sm36877485ad.56.2026.07.27.07.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 07:35:32 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	luto@kernel.org,
	peterz@infradead.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	jannh@google.com,
	yang@os.amperecomputing.com,
	rppt@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org
Subject: [PATCH v5 3/3] x86/mm: add set_direct_map_ro_noflush()
Date: Mon, 27 Jul 2026 22:34:26 +0800
Message-ID: <20260727143426.1077133-4-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727143426.1077133-1-xueyuan.chen21@gmail.com>
References: <20260727143426.1077133-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0A4B41C0009
X-Stat-Signature: rpqm6j6uktpmsufwgcmsizhjhs9tkdk7
X-HE-Tag: 1785162933-160935
X-HE-Meta: U2FsdGVkX1+oltRk2wyvWJFLzSvhjqy9024MK4zSYmoHMbeeD58R+k0iMuPYwPItwAv3NpSis8G7r3EylceD0oYraaS+L8rYtl1wCEhBmQmTnl/CRY3u88f6WRC7xGxz3qrl9cH210ymhISgAbDNZZ/xYsGEO5evxdOXj7a0KZ0F8DyEe//bX/ciiEFR3j82nz4jk3fF+fhkK0yuSVQIupUbtZ81QB0zLb/HeKUGypDgqJ0gQ9/e4TPnRh8aeMr4sHP/U6izn/fIa4jKZ4qAHzaggO/cR8svFsrxYnvj99wARUhevMLNdpa91jwprIcKw5kyV6/seHAQJTkbzJVrFqnz8ep8BoZPPk1GiPgk/bQXJaCg8ZeEMM4jLM2VhifONLfAdibLETEXgDsEURcDtizCDPETbRXvvYIO4oGEbUpYVDrupuTCU12u6xvJFtAFoZUgOIeBiKBDj1PFxstaJL2Yw8CIIteIaFQQsKFv2dQf/OsnavIArJ3QiM5du9UJioxoUubQTbIP06c9O/4XMH+K6GU27s6qcB8GDRjbFbd3uKBaM4QGsx0zMmCcG0pjlsq3rEMugg59ZDCsv1fppaHwcKz45cIgC49NP2t46gsCJ5aoLOlVP8c6BME+XboUnenqieTKaDekwTrlWOQMLBYjgteRWjwGd1FXLdR+Rilu7aUQyicHHX5SJiA5iBKI32Y8iyG1508pPQHpyKM0KRNWrFY+iCcXlPbnxAY+I0swG8SOLh+vHK0ezoA7ISicimVjlAvE0oman17pZGGw/kU4FVHvnsc32XLwdFeOSMbxcauWAaefsI01UMw70HYo3e9uxSZpu+2bBfhJKNyg1KDFwwUcjI/QkeSQNbESYGQKv6Fi4nC6DkYCaG2s5DltQUcxniSJppzyFjZ/IzfXu+Q4DYbdFA8p9unVowiCuhZfqlSiKt+YaVGSzTzFQNA8vjq3wk5ynf7dwsHdJaa
 isTvDSwo
 RaA/Uxv5a7ptXeGD7lKhf54Se9IOyFkpyL3EhU+w/4T3w5EGFEkfDT2z5PNUTIUHGzyuIYoy0SqtGSW7QjMRXiFAWEIJUtiiuFffPNC8q5D2fTcO5JUhosJxLGxFx+Pv59WtaQR0/tNASDfmj1nZOCGNN9R1f/F5G9swUHWuOLO/U8GDWyo0JsWpWAe9lF0UNjyBoIa9Mky5PRABmURKPZMGqihwk5kRfGFIBx2zcj04vrwpT7rEOCTpTLfdgd4HuxewtMMhANdzNdu/vO5yS4+AFOAbR9OvltZVxxJ+PJk6sn6NJztFy/bOgChmA55aTulAO6uxOtm9/ErtzRfmdmd/C1BdFnq58llSq7FY8B+oa8tRaM6Bv3Eylx5AebCdyaBy6URswW5z+3fuPe9u4sFd+AKOaFvQ9M7GnjRT3NUbmve0DdxH1Mimot7mvEoE/E4Yo6t/rCUsNwuqyAaE2vQMeh/Sv0tPxRThKnUfh4KSoyqqXWizPKsmz+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement set_direct_map_ro_noflush() for x86 using CPA directly on the
passed direct-map address. Clear _PAGE_RW and _PAGE_DIRTY, keep alias
checks disabled like the existing direct-map _noflush helpers, and leave
TLB invalidation to the caller.

Co-developed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 arch/x86/include/asm/set_memory.h |  2 ++
 arch/x86/mm/pat/set_memory.c      | 15 +++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
index 4362c26aa992..bd3817e06052 100644
--- a/arch/x86/include/asm/set_memory.h
+++ b/arch/x86/include/asm/set_memory.h
@@ -89,6 +89,8 @@ int set_pages_rw(struct page *page, int numpages);
 int set_direct_map_invalid_noflush(struct page *page);
 int set_direct_map_default_noflush(struct page *page);
 int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
+int set_direct_map_ro_noflush(const void *addr, unsigned long nr_pages);
+#define set_direct_map_ro_noflush set_direct_map_ro_noflush
 bool kernel_page_present(struct page *page);
 
 extern int kernel_set_to_readonly;
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index d023a40a1e03..5987f4c84f6f 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -2662,6 +2662,21 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
 	return __set_pages_np(page, nr);
 }
 
+int set_direct_map_ro_noflush(const void *addr, unsigned long nr_pages)
+{
+	unsigned long tempaddr = (unsigned long)addr;
+	struct cpa_data cpa = {
+		.vaddr = &tempaddr,
+		.pgd = NULL,
+		.numpages = nr_pages,
+		.mask_set = __pgprot(0),
+		.mask_clr = __pgprot(_PAGE_RW | _PAGE_DIRTY),
+		.flags = CPA_NO_CHECK_ALIAS,
+	};
+
+	return __change_page_attr_set_clr(&cpa, 1);
+}
+
 #ifdef CONFIG_DEBUG_PAGEALLOC
 void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
-- 
2.47.3


