Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5529CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 23:24:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A2768E0005; Tue, 19 Aug 2025 19:24:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 752E88E0001; Tue, 19 Aug 2025 19:24:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61B048E0005; Tue, 19 Aug 2025 19:24:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4997A8E0001
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 19:24:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C5CD8B7E32
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 23:24:53 +0000 (UTC)
X-FDA: 83795089266.29.536CD71
Received: from pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.155.198.111])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9D89040012
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 23:24:51 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=D7PbGt0H;
	spf=pass (imf27.hostedemail.com: domain of "prvs=31909943d=epetron@amazon.de" designates 35.155.198.111 as permitted sender) smtp.mailfrom="prvs=31909943d=epetron@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755645891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tF++dyX6f56vFwu3NGpYE/r8N67nbsIdg66sRFyfopY=;
	b=LWWRkOzX/birPDfU/6qTyZIp/gQ4vPOF7ZHAwmZ0HrxrNskeDhL+fmwWPRTk4hwLenmwJl
	pqzurgTHs1kjjyq1zI/QdbuK3rNYV3HkGFOUJzvLKUAcWdrOw+m1+bE/Um2l/SV7h44uLe
	Gy9VcVaQE86V/Qy6Hx9vcWfiK7h2U0Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755645891; a=rsa-sha256;
	cv=none;
	b=Rn75Z3F0IMMtk2ipw3LArvj6tCxR7xhShkBzLSEUyqXzMM1FvNACXD1cL9KknF7UjYDKN3
	X6jplToDisvl5Yir4c5dwt2FZtdEx+KxTBm78o4A74YIForLIn549fRaZ6tXzkgkQVRHWI
	bjsDSzwWAvFvPbfOs5Ew5Zf4BeCW6ok=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=D7PbGt0H;
	spf=pass (imf27.hostedemail.com: domain of "prvs=31909943d=epetron@amazon.de" designates 35.155.198.111 as permitted sender) smtp.mailfrom="prvs=31909943d=epetron@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1755645891; x=1787181891;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tF++dyX6f56vFwu3NGpYE/r8N67nbsIdg66sRFyfopY=;
  b=D7PbGt0HtxHakCjAVtiKLt5wjmTCDuAXa4f7uotA0Ra8U4D5DJ/xCuAp
   pgw/rTrksS963rBSe+4Yf223LSLHTuFR0eotJt7H9+lL0ZHyks3vRIpWw
   3LMTU9ejAf51R/NTcqkIIurgC0lcOpDAPoKyi60E0nCIZElUogxnRboan
   hQGw8sjhNC2gAm0Sxpzq7veDLa8pIMyeDDsmbSKGo8lmpxqlYtt2H8m2m
   VDfQdCwNIUfjNVG/V3JiCjW1zW425bJw4YG/P8Xtr6EGn40IbG5+bXyGS
   Z1AIdjixh9C72tfIqfjIliurepxnZv8XCD+dS6PpCtQW+g8am00/+Awp5
   g==;
X-CSE-ConnectionGUID: HB4nEjqHQxipsnhSvM8fbw==
X-CSE-MsgGUID: 8RszvGG1R/2We4GiosIQLg==
X-IronPort-AV: E=Sophos;i="6.17,302,1747699200"; 
   d="scan'208";a="1284831"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 23:24:48 +0000
Received: from EX19MTAUWA001.ant.amazon.com [10.0.21.151:36246]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.29.152:2525] with esmtp (Farcaster)
 id 54c19edc-accf-4bc3-a6cd-bccc3df96575; Tue, 19 Aug 2025 23:24:48 +0000 (UTC)
X-Farcaster-Flow-ID: 54c19edc-accf-4bc3-a6cd-bccc3df96575
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Tue, 19 Aug 2025 23:24:48 +0000
Received: from dev-dsk-epetron-1c-1d4d9719.eu-west-1.amazon.com
 (10.253.109.105) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17; Tue, 19 Aug 2025
 23:24:46 +0000
From: Evangelos Petrongonas <epetron@amazon.de>
To: Ard Biesheuvel <ardb@kernel.org>, Mike Rapoport <rppt@kernel.org>
CC: Evangelos Petrongonas <epetron@amazon.de>, Alexander Graf
	<graf@amazon.com>, Changyuan Lyu <changyuanl@google.com>, Andrew Morton
	<akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>,
	<kexec@lists.infradead.org>, <linux-mm@kvack.org>,
	<linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nh-open-source@amazon.com>
Subject: [PATCH v2 1/2] kexec: introduce is_kho_boot()
Date: Tue, 19 Aug 2025 23:22:45 +0000
Message-ID: <7043f4da31390c58bb7721a3774c30998997df44.1755643201.git.epetron@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1755643201.git.epetron@amazon.de>
References: <cover.1755643201.git.epetron@amazon.de>
MIME-Version: 1.0
X-Originating-IP: [10.253.109.105]
X-ClientProxiedBy: EX19D038UWC003.ant.amazon.com (10.13.139.209) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9D89040012
X-Stat-Signature: 15ds5o8j4e677zcht93r54zy93rhqibm
X-HE-Tag: 1755645891-969362
X-HE-Meta: U2FsdGVkX1/fPaAMeCfcQnwGIerbroBSJ43KIdsk4OjJ96e/doBv8B+z6kaVgxs7gtUdsPXbM0lOAtszq4vcjm67mFRGnAfJOB9BXfw6727VTFaOQcSf3SFKZsDxt0zD/1Wp9uXLE5re5mEbOIiaNLo32CwXQ0g62C+W01pNskxypARAAh5LZiM5yf02FE4I84jzM3cj4KOLAi4MhNrFc3Dde47kDxCXE9k6DELgimfH/AGU0eE+1LnOSn7TattdIb9v5+V4ItxHHlEVSeqMDVYHrhO/N8/T9Fqarko7qb5UX0Gqs8g2RSs3VTZHWQ52XgsvBXPLl/zCONulEEyNJJRP/AjxBxkMHGoYMuDptpH6ecMCXTBEFLN8ZUfoBoh8Jlzz/Uzlk/DFnn+I6eGbZ0IE0vVSeTZ0MqyrlsUhA3jWENiGLpBhFW7V0dLLwXhzyG6macjg8R1CEd/Ylc9xcJ8tKCsDmMmZhaV8Zrxk56aRu/Zguzqq2o1RiObDcWGgZ2PBJvrpmWLW0bFUftqnTllcDBH+un7Y1+fD+x/HR46ORhHNNG1wmZlJh2PCLd+Ar4+67GanasVtr2HG57N1qvL1HTMXpgtQL3KR6Lp6C/fuq6lYpudxsQnmxygoJWmM1882KY37lpMIGQvHU+NdrtQVyiWh0+eQenZTCufXZXEbDThNXAA7ivIEuP//PRA0dtBu7uSlSPU8sFycSlwF+4SixeWIc2PFENDkh++JVqO7sz2TswOeM/uF7QpXkV687aW3ocWQkywcWOxi8x2VpHkpoIgtWqmEnaLOflKv4ytkBiS8a23gAbPZOox3hiltxwBSmfXtXVRqL49n2lj/lO11fh6n9GbFRyM8p6s5kdfLzji3uzDkJnNQq/I0MLq8Rs/oOO0kHov1QN3Q3/VqfTMfhWMOpao42oAmthMV4+WWT2KJNKs0OX7Sj7xeYI8XfqidGnt50k3+MK9v9C1
 Wm9qEc2t
 XxZ3CAxgMO3nuEwmT3J5strrKhaPpEdMwrg0Oc3QE63G/o6PlLFfTgtAamIiQa3ROq4yknqo0f8uQJn00GLlFRVMw3JyBMowKR32GW9Gj3lyUBKWat8e7d/bPGBhJQmx2zkkxBYS3+JHIoHLhYM4hkNJJ8a3RRDVSiT77QJmhPdqRPlDX484ZOPabKeSTjngaP8Fr9dLwmIQRSxAVKXHQo98EXSmoRjc3GtsTS3mJo23qds6WskE1acH/LESU6GOkf+t+pdzXgDEryx1bDPTLgEAf9fSo/H2gE5dmlSyabYkj2Uxg0VNWhac8E0BEGbJfZJwMV/PvhCMTPW17KFp7VRGtahkwd0P+P3DYlIwUHR6R5Vfu24Bmy7uOWxpqXyAwwcrIJnbtYGzPedXUBOVROzD+6C2xeZ3p6ClmIqFM07wARmSbHvyxmSLrmW616kt2dmL1EyP6snHjBS8Om/57QtcKoZVu4/EZ8I0skemCo+RbtKnULmC4UpedOGWlEBQzqECC3gSAheCNm/u2StKmfOHeBgDfmGYfJH3I31a5BB2anHzqqsdJ7dRIzw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During early initialisation, after a kexec, other components, like EFI
need to know if a KHO enabled kexec is performed. The `kho_is_enabled`
function is not enough as in the early stages, it only reflects
whether the cmdline has KHO enabled, not if an actual KHO FDT exists.

Extend the KHO API with `is_kho_boot()` to provide a way for components
to check if a KHO enabled kexec is performed.

Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
---
 include/linux/kexec_handover.h |  6 ++++++
 kernel/kexec_handover.c        | 20 ++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 348844cffb13..559d13a3bc44 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -40,6 +40,7 @@ struct kho_serialization;
 
 #ifdef CONFIG_KEXEC_HANDOVER
 bool kho_is_enabled(void);
+bool is_kho_boot(void);
 
 int kho_preserve_folio(struct folio *folio);
 int kho_preserve_phys(phys_addr_t phys, size_t size);
@@ -60,6 +61,11 @@ static inline bool kho_is_enabled(void)
 	return false;
 }
 
+static inline bool is_kho_boot(void)
+{
+	return false;
+}
+
 static inline int kho_preserve_folio(struct folio *folio)
 {
 	return -EOPNOTSUPP;
diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 69b953551677..a1a4e76e0ff1 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -925,6 +925,26 @@ static const void *kho_get_fdt(void)
 	return kho_in.fdt_phys ? phys_to_virt(kho_in.fdt_phys) : NULL;
 }
 
+/**
+ * is_kho_boot - check if current kernel was booted via KHO-enabled
+ * kexec
+ *
+ * This function checks if the current kernel was loaded through a kexec
+ * operation with KHO enabled, by verifying both that KHO is enabled via
+ * cmdline AND that a valid KHO FDT was passed.
+ *
+ * Note: This function returns reliable results only after
+ * kho_populate() has been called during early boot. Before that,
+ * it may return false even if KHO data is present.
+ *
+ * Return: true if booted via KHO-enabled kexec, false otherwise
+ */
+bool is_kho_boot(void)
+{
+	return !!kho_get_fdt() && kho_enable;
+}
+EXPORT_SYMBOL_GPL(is_kho_boot);
+
 /**
  * kho_retrieve_subtree - retrieve a preserved sub FDT by its name.
  * @name: the name of the sub FDT passed to kho_add_subtree().
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


