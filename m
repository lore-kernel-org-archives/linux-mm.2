Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E31AACA0FF2
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 09:39:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C5536B002B; Thu, 28 Aug 2025 05:39:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54E936B002C; Thu, 28 Aug 2025 05:39:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4164F6B002E; Thu, 28 Aug 2025 05:39:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 24A546B002B
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:39:34 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D9970139DE6
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:39:33 +0000 (UTC)
X-FDA: 83825668626.01.F86B7C1
Received: from fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com [52.28.197.132])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6B935C0015
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:39:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=eqmsxTJK;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf28.hostedemail.com: domain of "prvs=3288f7157=roypat@amazon.co.uk" designates 52.28.197.132 as permitted sender) smtp.mailfrom="prvs=3288f7157=roypat@amazon.co.uk"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756373971; a=rsa-sha256;
	cv=none;
	b=vWlxCpQANSdrX0CYVFwvQnm4csuzfBsLX0THvDaRreCGAaYUtosyFdE2HGp/ckfg5p+8d2
	vAXxBSaunMRc09XfrlSLFlRhdpDKYhGEp30nE4bgcNtZw2Q9Ci3Hptu38expbjpbfrS0+u
	GDwGfnLYIwTpr9tPwbkra/FJrrD8Qwo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=eqmsxTJK;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf28.hostedemail.com: domain of "prvs=3288f7157=roypat@amazon.co.uk" designates 52.28.197.132 as permitted sender) smtp.mailfrom="prvs=3288f7157=roypat@amazon.co.uk"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756373971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QxcRm5lfAR27jNQOt1Cv3ZD27Tadoj4JCPsxnEzoRq0=;
	b=Ndl70LiVBk+2P/nevsjaYmqBa7JV83FTSYLnrcIxO2b2uAVJsbmSqSW9VRJresjfmSHUCu
	1Lo1XNOPDc9/jBREgK5TUVeOSzVPeCDLsMDXw69crkEKVsXuHZOMt5iOM/p+KEDhQ9FMnV
	5uIfrKEQF1PXWVcdrnUfOOV86ElrzfA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1756373971; x=1787909971;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QxcRm5lfAR27jNQOt1Cv3ZD27Tadoj4JCPsxnEzoRq0=;
  b=eqmsxTJKZv6MpFCsVVCtBxtAtR3lEQQyZPC6AdzUAB1eB/JBa1LrFDZL
   /rvGwDEP97cOzUyhub306h81mqxJ9aP7VLe6TSJMaTGawLojgjkhxHXyL
   wadrqO8qkpH/5I3zX34tZh6sKflbdX31O6qATFUw2CqDpYu6k2+S/KMvo
   I8DNJxFuekzkXzpg02VZkLBgr1m+kMSdSgNejve3AGYl7a/I2UA7ENY16
   S75KU/T+ylGlUgxm0cAliACb6k5xhXlWXHPHANTRyOTgYsE6SG7syyzJY
   0F/o7RIDnglutCghf/MDOjU1npDUTZC5nrHi12Cd1ARNauShT71VCKC5B
   Q==;
X-CSE-ConnectionGUID: 7aAfSXOpQhSh0GmR202udQ==
X-CSE-MsgGUID: 784e2/YRTTud5uoKzM+cEg==
X-IronPort-AV: E=Sophos;i="6.17,290,1747699200"; 
   d="scan'208";a="1198436"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 09:39:18 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:9852]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.18.197:2525] with esmtp (Farcaster)
 id f40bcc95-ba71-4bbc-8aef-317484c6e4a7; Thu, 28 Aug 2025 09:39:18 +0000 (UTC)
X-Farcaster-Flow-ID: f40bcc95-ba71-4bbc-8aef-317484c6e4a7
Received: from EX19D015EUB002.ant.amazon.com (10.252.51.123) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:17 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB002.ant.amazon.com (10.252.51.123) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:17 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.017; Thu, 28 Aug 2025 09:39:17 +0000
From: "Roy, Patrick" <roypat@amazon.co.uk>
To: "david@redhat.com" <david@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Roy, Patrick" <roypat@amazon.co.uk>, "tabba@google.com"
	<tabba@google.com>, "ackerleytng@google.com" <ackerleytng@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"rppt@kernel.org" <rppt@kernel.org>, "will@kernel.org" <will@kernel.org>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "Cali, Marco" <xmarcalx@amazon.co.uk>,
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "Thomson, Jack"
	<jackabt@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>
Subject: [PATCH v5 02/12] arch: export set_direct_map_valid_noflush to KVM
 module
Thread-Topic: [PATCH v5 02/12] arch: export set_direct_map_valid_noflush to
 KVM module
Thread-Index: AQHcF/+fQN7WhMNbEkOkKSoqsUoNyw==
Date: Thu, 28 Aug 2025 09:39:17 +0000
Message-ID: <20250828093902.2719-3-roypat@amazon.co.uk>
References: <20250828093902.2719-1-roypat@amazon.co.uk>
In-Reply-To: <20250828093902.2719-1-roypat@amazon.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.88.180]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Queue-Id: 6B935C0015
X-Stat-Signature: tt6yzyd4xwjis5399y8qcmtqnomjmskb
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756373971-273756
X-HE-Meta: U2FsdGVkX1+2So0UT4mfv3GDdGChtS5Rap3zjPQNMzyvd+IA6E5jZjewUoJfdwAfYJzjnfNIaiNHMu42gK5x5nYY5rQChe+/QJn4CJQdnXIKhFoHZi56EA5GXTLwm039zQj75nIonhD1QF38JsGsStmKpUN+mgJaX2cOoCACb/Co2FNuTTZGN/1hyFELmiNx7VJLCWLr/pej9lZudEXNgEQRO96jR6YYvrCPrOBrBwSFZh1DUHwJ0NuZ8ISjmbaD/8Ouq3iic5YkHG38VFgyqBTtEAnhfhUIhrReNbC/zaZmPG0ln47XgKTt7/bUZBioWE6GeZLmQ3FdYKL073gf3wwDv81P3g+lXQcOeqAef4JamLKu3gku/TVynP24k8U9uhq8kobyOtAI7CTx/jPOrhwV4g876lGqBTWREHWTyuW87APbWvsZVuSJeTFeJoY6KX4rECf36qeTUcJeZDt5JHGzh/ONbOMFpv3+2/1Y+V0NIX7s2S1TmqZXFGkRr+1yuQ3yBzmclYzdBjwIma157bp1G/Ycl69+Mf4FW/Hp5SYkYR37woor+DUk1eU8nmkKUQOeMN+/QXL+w8jWrrC1igWqljph50nLoOqg4QlAKd6Uw5yTcRdk889Qf7E9xkjMKOkzocCGRnmQvpJPQsHjj+gBgzehd5CXWn7bHAzodH1nsKskbGa3p4UMPsdQbbnq0vwodbYH8kVNWAQY5ActGPpx7tQsoM5j70kX8/qkgPSRg8HKLy3kezQEqQQL3jxLZmI39kczxFnUPMNke6hPBxjVtu+eluNq8+Ur3EVxlh5Zsu8ushyDPDoUtsdfH37iWcZYSXyv12iuYX4/pJMdQ+zvx+tcTsZLLjPB9w4vuFY7aGvkbdA7VAGo3R+dQPkJCiWu/Ojy35cmhYgbWrqIFLLDose2eCfL9UJOCeV04EVqGyw1Gn8/T7++HEkxJ8p1XNObkmNsEJwmUpqrUKR
 aSLVoxOt
 9F0TAgzREh4ntT0xUnXty6jXEIiBAW8H0E9MsZAbWwSY96fjRimvyKiEGjx9Eb5rS/m8eHQQC8E1nAtcF4Nnu4Odo2RZ/p1N4ZHyZNtIebzbqfoCrxzeoJorP7vnTq787JdKLSN18FtAo47DS7X951emaTXdwgTfMLLBIIboo+8NbJ08mUAPUTxXlgjSNkvI3onAvqAQk8PWWOENBJjBr+6CVRzP8G7wYhV1grQjBYCQRmsjy/i76bMhm3dss5Ws1HEuxM7+JAXMUNyhPt39kZkn6FRjvkBiK6mW+8z7YRhMIsB5ya7XiqKyssSZOKgDsKD4rI9KGWFqSBqXE8/XUCBFZzYwYZXBLqqKtz0MngpiCTeXH8QzhxyiLM1uhdH+7mEfoDt/kZmM4lHHr+ecvb6IKV3eBh+iWaxY8OT5/CWca7zUr+LSNCrFxPPoPgsr4vvlXeFi+vVwGcz9eJeajwP73/i2z10kkkJaw1dXhI+7O1IhB8sMUFbvmuSLzWjOofYIFhsrt8wLPwHNpkzf6TyqRLn2ZP4M9mDx3Cq+ys5XZBhj7F/rjfrjrBBAXLYr2USB/1tidUouGqjjaEW9/N62wE/dkHwtffgvpR7YrRtTRSm1L3v3ni9mZwW4fgTsa6bheg9UaRAbJRPwKfktAwvUyJwH/qnucqJuCyxHHJUEzU68wQbNFGQnsfdvi8M5Gu3gZ16JYzsS/f14paE3KzJFM6RpooYi1qAU+jtFGoN399ls=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the new per-module export functionality to allow KVM (and only KVM)=0A=
access to set_direct_map_valid_noflush(). This allows guest_memfd to=0A=
remove its memory from the direct map, even if KVM is built as a module.=0A=
=0A=
Direct map removal gives guest_memfd the same protection that=0A=
memfd_secret enjoys, such as hardening against Spectre-like attacks=0A=
through in-kernel gadgets.=0A=
=0A=
Signed-off-by: Patrick Roy <roypat@amazon.co.uk>=0A=
---=0A=
 arch/arm64/mm/pageattr.c     | 1 +=0A=
 arch/loongarch/mm/pageattr.c | 1 +=0A=
 arch/riscv/mm/pageattr.c     | 1 +=0A=
 arch/s390/mm/pageattr.c      | 1 +=0A=
 arch/x86/mm/pat/set_memory.c | 1 +=0A=
 5 files changed, 5 insertions(+)=0A=
=0A=
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c=0A=
index 04d4a8f676db..4f3cddfab9b0 100644=0A=
--- a/arch/arm64/mm/pageattr.c=0A=
+++ b/arch/arm64/mm/pageattr.c=0A=
@@ -291,6 +291,7 @@ int set_direct_map_valid_noflush(struct page *page, uns=
igned nr, bool valid)=0A=
 =0A=
 	return set_memory_valid(addr, nr, valid);=0A=
 }=0A=
+EXPORT_SYMBOL_FOR_MODULES(set_direct_map_valid_noflush, "kvm");=0A=
 =0A=
 #ifdef CONFIG_DEBUG_PAGEALLOC=0A=
 /*=0A=
diff --git a/arch/loongarch/mm/pageattr.c b/arch/loongarch/mm/pageattr.c=0A=
index f5e910b68229..d076bfd3fcbf 100644=0A=
--- a/arch/loongarch/mm/pageattr.c=0A=
+++ b/arch/loongarch/mm/pageattr.c=0A=
@@ -217,6 +217,7 @@ int set_direct_map_invalid_noflush(struct page *page)=
=0A=
 =0A=
 	return __set_memory(addr, 1, __pgprot(0), __pgprot(_PAGE_PRESENT | _PAGE_=
VALID));=0A=
 }=0A=
+EXPORT_SYMBOL_FOR_MODULES(set_direct_map_valid_noflush, "kvm");=0A=
 =0A=
 int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool vali=
d)=0A=
 {=0A=
diff --git a/arch/riscv/mm/pageattr.c b/arch/riscv/mm/pageattr.c=0A=
index 3f76db3d2769..6db31040cd66 100644=0A=
--- a/arch/riscv/mm/pageattr.c=0A=
+++ b/arch/riscv/mm/pageattr.c=0A=
@@ -400,6 +400,7 @@ int set_direct_map_valid_noflush(struct page *page, uns=
igned nr, bool valid)=0A=
 =0A=
 	return __set_memory((unsigned long)page_address(page), nr, set, clear);=
=0A=
 }=0A=
+EXPORT_SYMBOL_FOR_MODULES(set_direct_map_valid_noflush, "kvm");=0A=
 =0A=
 #ifdef CONFIG_DEBUG_PAGEALLOC=0A=
 static int debug_pagealloc_set_page(pte_t *pte, unsigned long addr, void *=
data)=0A=
diff --git a/arch/s390/mm/pageattr.c b/arch/s390/mm/pageattr.c=0A=
index 348e759840e7..8ffd9ef09bc6 100644=0A=
--- a/arch/s390/mm/pageattr.c=0A=
+++ b/arch/s390/mm/pageattr.c=0A=
@@ -413,6 +413,7 @@ int set_direct_map_valid_noflush(struct page *page, uns=
igned nr, bool valid)=0A=
 =0A=
 	return __set_memory((unsigned long)page_to_virt(page), nr, flags);=0A=
 }=0A=
+EXPORT_SYMBOL_FOR_MODULES(set_direct_map_valid_noflush, "kvm");=0A=
 =0A=
 bool kernel_page_present(struct page *page)=0A=
 {=0A=
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c=0A=
index 8834c76f91c9..87e9c7d2dcdc 100644=0A=
--- a/arch/x86/mm/pat/set_memory.c=0A=
+++ b/arch/x86/mm/pat/set_memory.c=0A=
@@ -2661,6 +2661,7 @@ int set_direct_map_valid_noflush(struct page *page, u=
nsigned nr, bool valid)=0A=
 =0A=
 	return __set_pages_np(page, nr);=0A=
 }=0A=
+EXPORT_SYMBOL_FOR_MODULES(set_direct_map_valid_noflush, "kvm");=0A=
 =0A=
 #ifdef CONFIG_DEBUG_PAGEALLOC=0A=
 void __kernel_map_pages(struct page *page, int numpages, int enable)=0A=
-- =0A=
2.50.1=0A=
=0A=

