Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 471EACA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 17:59:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83F298E001B; Thu, 21 Aug 2025 13:59:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 816228E0001; Thu, 21 Aug 2025 13:59:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 753008E001B; Thu, 21 Aug 2025 13:59:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 642768E0001
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:59:54 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F1B7C160255
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:59:53 +0000 (UTC)
X-FDA: 83801527866.04.0717B2D
Received: from pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.35.192.45])
	by imf21.hostedemail.com (Postfix) with ESMTP id BF8701C000C
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:59:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=XAN7fErJ;
	spf=pass (imf21.hostedemail.com: domain of "prvs=321b76ff4=epetron@amazon.de" designates 52.35.192.45 as permitted sender) smtp.mailfrom="prvs=321b76ff4=epetron@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755799192; a=rsa-sha256;
	cv=none;
	b=5p32nj0Pm191x1DbnSdn1oMoYav46IqDTTYJKmLJNnZcZ7l+kRWhNrYDWbnyh8anTrys9K
	CAN5NrB0hCY1Rcaak13oQZiDqfNIaq7I64lojsNSDIeB5Cq/hhROlpjKoT9cuNtqE0ugKC
	le+ngZ+gjSsn2O1Dj96bmYNe9lX60FU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=XAN7fErJ;
	spf=pass (imf21.hostedemail.com: domain of "prvs=321b76ff4=epetron@amazon.de" designates 52.35.192.45 as permitted sender) smtp.mailfrom="prvs=321b76ff4=epetron@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755799192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kWqXjjUHM7c8KFNVFeI4qCz3BhL3hy0rWcMQ9gV1+Ag=;
	b=cjn+FUEOD2uIBIe3dCPwOcs7nO84j3GZrUuRtzERutOPYxzOVqwk2YAvim1uwkDoDoEprI
	E2BBb0EsYlRml73iXwFRUAtXWjJ6Vs7If6keJUPSR7kbrkF1XuBg8cFXCxIXYXFXXQfBOe
	Zs5sCp9CjcUioPuZwTC8n6Ji3TPNjpU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1755799191; x=1787335191;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kWqXjjUHM7c8KFNVFeI4qCz3BhL3hy0rWcMQ9gV1+Ag=;
  b=XAN7fErJYmle0xPECroRqKQtX/spb2FcuGzwiOO90zA9QOAzzvCUpPHP
   KqPDHtLWOxtL6ySHnSxEFJAiTdvoZ867i+Uak95jw+H5dq1JU/Qly9lg9
   Y03DeuOiTkPXfmR7B68pGKDk0nDmaTMwgnlfnUXEdmoX4DrrG8kJnYjub
   7JcTD3RreaHNZsy4DZ+tnPBem4mKU+hLsKg8yCAMqlqxgtrVWrBJcP3Zp
   M0lPbn9RlXBffkCH+twSdve/xAhHf5zUuOlriYcASVaWTbJJwz4LI5Gww
   ddPSvbFB3YfVRdam6hFLXO9477WH0uaAxoK4zbvGl2Vakwa7s8tgLvJPh
   A==;
X-CSE-ConnectionGUID: HLKZcqGhSiCPiLwCU2nt1w==
X-CSE-MsgGUID: /M1cOzOZQPSmCqzALH8bdQ==
X-IronPort-AV: E=Sophos;i="6.17,309,1747699200"; 
   d="scan'208";a="1453129"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 17:59:48 +0000
Received: from EX19MTAUWA001.ant.amazon.com [10.0.21.151:64601]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.29.152:2525] with esmtp (Farcaster)
 id df03885c-7dc0-4034-8426-e40e01b7df25; Thu, 21 Aug 2025 17:59:48 +0000 (UTC)
X-Farcaster-Flow-ID: df03885c-7dc0-4034-8426-e40e01b7df25
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 21 Aug 2025 17:59:48 +0000
Received: from dev-dsk-epetron-1c-1d4d9719.eu-west-1.amazon.com
 (10.253.109.105) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17; Thu, 21 Aug 2025
 17:59:46 +0000
From: Evangelos Petrongonas <epetron@amazon.de>
To: Ard Biesheuvel <ardb@kernel.org>, Mike Rapoport <rppt@kernel.org>
CC: Evangelos Petrongonas <epetron@amazon.de>, Alexander Graf
	<graf@amazon.com>, Changyuan Lyu <changyuanl@google.com>, Andrew Morton
	<akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>,
	<kexec@lists.infradead.org>, <linux-mm@kvack.org>,
	<linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nh-open-source@amazon.com>
Subject: [PATCH v3 1/2] kexec: introduce is_kho_boot()
Date: Thu, 21 Aug 2025 17:58:59 +0000
Message-ID: <7dc6674a76bf6e68cca0222ccff32427699cc02e.1755721529.git.epetron@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1755721529.git.epetron@amazon.de>
References: <cover.1755721529.git.epetron@amazon.de>
MIME-Version: 1.0
X-Originating-IP: [10.253.109.105]
X-ClientProxiedBy: EX19D043UWC004.ant.amazon.com (10.13.139.206) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BF8701C000C
X-Stat-Signature: 7f6ufuoyiuwbezkprs1wuzp31obfar5h
X-Rspam-User: 
X-HE-Tag: 1755799191-339988
X-HE-Meta: U2FsdGVkX1/+Q3rEdgaT9cHUyXRSGH2erfBAUKl+sNciAV3mSaezvb09jzAqf2DxItLXiAuMOGVap4do3+JkesRvhr8gZ5d2OouZXWUECbh6bijI6Mcd19RlkGO7ae3jclqaL0avQ7dx1Xur9lTDZsDcoitPMlI1HFELvxZS7ovmmTr43x9UrsNVwvyE0FKfKWO2gy+F7Znug4gq/FBCtgN57MrPj7ckLn8zCqGdy78fY1+8cWZWeNkO/Wfb6n8iH54znebRvax4KWxG2wIQOLDrU50zQRnNJRY/kZxs5/kiP8xeREZ6FR4/el3Tk6tlxSvSPURKEpwZ6EhlIKBJCDbIl53Oj2bKFvcukRIBHU0RYEKq2SpV+DrSK5AIUEZSRU1NAZvi57XjjBtnWZtDxhxFGye0JaTJJdKMvlcviVSWFPALynyCY9+IZG3wCAbpZdCCgmIfJxlvyT0kthvV4KNrhH5qO0SxBQX2IOJRv397u0/lujafdCqYuj+l2/foMVbq2PtPXTfTSIzlqEf1HXsCqwDyOnrLg1AKHA2xHfC0wkTTxDaojjGznlrwugeikuTyiS3a+ODDTLNnk29yQjb3MHWZQ8jx91kIfe311I/loQtvjqHzz0rQSPsFf5gOceIIqo9cw6/BA3VnrRPXNE5jmTtxha5EYL+TtZONby9hrS6ZEbqc3unfHYnRBqk2M7hNnhc9z7D69DrIHjumgIL+uYxVkNneZIBNMuNHzydpt8ToNW2FUX/ZfCX1iO1lROgksrZC/ZwWvSdHgPsET3lJq+874UQeVvWHubUEc7YqitlAzeso8ay9JNLd1EgxHo3kHTyBkLmDLVPd0ou+fU77KSwuqSNe8FZeF2Ub2h0tKDMFBdCg79NfK2DhmR2tKw4pfw7ahx1DUiA4v1YjpaMJ2SuQuRMJN+rRNpv+uy+v02PnjSE2K9ZEvathMOqo5gQM7Q4WeUiwKv2/D3X
 dT8RoDXr
 f1vzptTZhFXXIja4cLKMLg4P39PIKpos3rLGNQPDG/GzxgCyFdTZ0fDXCn4m6+wHeYhxXzB1TN5g9lbhxPHVaayvgpTCZMu7b2Ehcni69cbeD9+JDKtucqpR7syu6IjHef1ucU9pCsbUEK98nQXIWYSPFtAwbio9M9jH16TpJr3k8dLOmivDROirY3IaysJ88zmeOINNFmoxELd4ZzUJOnAltKanH8Yn9dToMp9gG04XHtx0Z1AEjy2Q3snLUig3Yw5jEcNVt6WovduBEOyFzWMP2gTdMFiq6YCNURJbWVxCIiiqJHY6ysJfRuFQNX+pKufPWleTjUCbEzEL7nDUZzModlr12NcGjKDcvlQ9wWk47RUz+IsK81clGmcW7ZvTADLyeGyKX+WAN5EZhD6w4ufkN4O0+0iaizsZStiOjwaWmw6NtO/HYwOzlJX8BbHu9hlZ/fHu/XzdPrz46A99lVbxeSxcFxPEhYrbwsc7wOFhRNGmVFntCo6sxKKGgMVJUOyngyXRI7bA9HzONSSDFU22XjRbp0CWophKhrxeZTif5Tn4nVgB19oVKcXMTiPaayrIMlS2ZJmc8H+o=
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

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
---
Changes in v3:
	- Condition Only on the existense of the KHO FDT and ignore the
	cmdline `kho` parameter

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
index 69b953551677..52e80e0c2238 100644
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
+ * operation with KHO enabled, by verifying that a valid KHO FDT
+ * was passed.
+ *
+ * Note: This function returns reliable results only after
+ * kho_populate() has been called during early boot. Before that,
+ * it may return false even if KHO data is present.
+ *
+ * Return: true if booted via KHO-enabled kexec, false otherwise
+ */
+bool is_kho_boot(void)
+{
+	return !!kho_get_fdt();
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


