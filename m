Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D8BB606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 17:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HC6izpFB
Received: by kanga.kvack.org (Postfix)
	id BA2EA6B0620; Thu, 29 Oct 2026 13:30:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B532E6B0621; Thu, 29 Oct 2026 13:30:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A69706B0622; Thu, 29 Oct 2026 13:30:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 82F456B0620
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:30:51 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0A748804D6
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:30:51 +0000 (UTC)
X-FDA: 85376353902.02.25C3AE1
Received: from mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf03.hostedemail.com (Postfix) with ESMTP id A5E9020012
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:30:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HC6izpFB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793295049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rBVVW3tHabgwrKT2QwycDYkPKCsMYjmGYVvwfvGvrhE=;
	b=LyqYb7BSpCEk+XNW6VSfmviKQriKcxBTcGkq173zroa+/gZvfLt0a9TtFYxsdIKWwpZt3S
	bP5fFa9l6+Xkp6HckrHUzLY1V6AOfkJWhno0WQ8VNCirsWBxcuqA0rZH5vcfLfauHmHyHo
	qSizgQTYqr5HoM1Cz5oIHC6XSZS5q8A=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HC6izpFB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793295049;
	b=mhwszucCFz90q6eEITZZlq1GtDJwjaHIDLla3Q6lfCUWvRGLBKFnug5Xv7qjuEWSNeThVQ
	6CZ1r5Tz4ZWtSmzg5nVts2PccZFhKOX6cJQiC2gBcxvsjpOeDH+sQbnZp0EiAGGnvpZeWG
	E8VUhJkUHQyjW+k5NGbltVa2HQAdaYw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=7EdBEd5XL5wRdZvYlylGxvVrrhD/K6K3u333eKYP51c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793295047; v=1; x=1793899847;
 b=HC6izpFBgx9Os0a9ApbmT2Glk501euie4yvJGNNb7zQBjlxydSGvilwWczTel/QZIX6ywO4n
 MTUMT5QvMBh0ouFgHp4Nv4X3nrI2oItKbxYRkNG+LllR7xNIV3QSufQWwP14HJ5/bGcN9HFVUX0
 L2/ocLWMVGp1/+3XWj/tMaXk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 155dc8602c7bb9c2;
	Thu, 29 Oct 2026 17:30:46 +0000
X-Mizu-Trace-ID: 155dc8602c7bb9c2
X-Migadu-Flow: FLOW_OUT
From: George Guo <dongtai.guo@linux.dev>
To: rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	chenhuacai@kernel.org,
	ardb@kernel.org,
	shuah@kernel.org
Cc: ilias.apalodimas@linaro.org,
	akpm@linux-foundation.org,
	baoquan.he@linux.dev,
	ruirui.yang@linux.dev,
	guodongtai@kylinos.cn,
	kernel@xen0n.name,
	graf@amazon.com,
	liukexin@kylinos.cn,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: [PATCH v6 4/8] kho: Add kho_disable()
Date: Fri, 30 Oct 2026 02:29:51 +0900
Message-ID: <20261029172956.20791-5-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261029172956.20791-1-dongtai.guo@linux.dev>
References: <20261029172956.20791-1-dongtai.guo@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A5E9020012
X-Stat-Signature: wo6h7wohbauszxetgr3mpxoaxhzsjuwp
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793295048-813033
X-HE-Meta: U2FsdGVkX18XxfLDfTw7Q9HPg73QzwcFnp0g9IGI6wDmngJ8RT/MiEicahfe6Rqnyi9vTolNcsIVPEszT/QgGZG8pa7jnc0h1sL1YkTfgW4CyC1HHk9Dy6uglDjQyw5c4auXJr2LvRc+frmfee+mDzZ2WV3JKJBRsfddRorgyFpZjEwkSQ3NjAP1N+27QYG6zIUorP7eCpTkgfBIamfuvRpgA0z4B66PXJlEtQd0DuG9M0VHRwLF4Hofxq817NvwfMkGgL6Sx9hufhShdjpSixY71Cc7hVwHivoohvo7zyLd5101T1ugBwhiP2VaTv0UI/nSnh7aGqq+Sc7bT2/zdx2U97KRAsSWICZfXIdU/AKKK2eB1ZnLQRBgucxZVLehB/WnMvZ5m+1BvOaqrBOpCaxvkGPTkJugZCevok8Yf/GkEBaoXOZB8MtD2Dk8kAH3VPDKoDCRbcS6Ddrfgp6+YiD3didrqhthHjmo3scAZ6VVZ3NDT1lKnBA/I4TsUlcEyqt17xArNqJcjodBw1hs/KKlJjxZLKaELGMUGAnwGCXYSi+JDYHRmwbnuWuMHGHaB7a3K9uJyHpIfpXAr+L2Mpq2LQ3uRCyXBka0e+inz2bj5z5XW3t7JUUoOrFNZLux/f1R0CBs0eU6UY6A/fX2k/ogWfTlrn/XxlvlBn+HG8tcTZ+yD9GOPYDCOQt78hHaglTMFJJftmScNT15c+BR7l/URqd8/kGb57f/JGqbLvyvBWyKriuFL4zPF+E3ym9X/dyg8VbjH5ahvMcXMhGVlWktDNgKdnLMEIstfv3o7usWxP7Fo4BcXaU3WEE3yrm6zstcUyAriPQ7CPUSt0Svgkxnx+MBAlUBWqa6uVjJJnheDTxr8hnS4ZLEuTEKc0J3ceHBEjsYqaCpmtntYr2dk3a+E+9aCOhh/edGQyQmjW5BTrKOGqwmmOAHMmngRHkhIUwVSSeOo1JDBh1m++V
 aQ3Fv1w6
 kn6jjjTMxkVtzc96tkAmG/wCn9RyIy47239Rl3nnpACVCL77GN65dHwHFlFXNA4IUZqMOQNsnB+1YjKyrk+flfLKEXL/oJ8bNowtqtjTgsbm2Yiny+RlE/J2olk4x6GbsOoUiEfJjhan/wdMca6OH56UB3mp7dUxFMFn/BhBO0096IpAl+Ly1GxCiHNFwTh6yHZMNLn0emAUIQePeVSjBGlTu0EQmPcrnx8HAe9yojnaph8gadP2hyBlSUFPiTuclxbnXhnNE21WYHqNupJLNxSwW9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: George Guo <guodongtai@kylinos.cn>

On LoongArch, KHO state is passed to the next kernel only through an EFI
configuration table. Only the EFI stub installs this table, during a cold
boot.

A kernel entered through kexec does not run the EFI stub, so it cannot
create the table if the previous kernel did not provide one. Without
the table, it cannot pass KHO state to the next kernel on a subsequent
kexec.

Add kho_disable() so architecture code can turn KHO off when the EFI
configuration table is missing.

Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 include/linux/kexec_handover.h     | 3 +++
 kernel/liveupdate/kexec_handover.c | 9 +++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index ef2b188c8ed0..6f80e1b0ccd4 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -15,6 +15,7 @@ struct page;
 
 #ifdef CONFIG_KEXEC_HANDOVER
 bool kho_is_enabled(void);
+void kho_disable(void);
 bool is_kho_boot(void);
 
 int kho_preserve_folio(struct folio *folio);
@@ -54,6 +55,8 @@ static inline bool kho_is_enabled(void)
 	return false;
 }
 
+static inline void kho_disable(void) { }
+
 static inline bool is_kho_boot(void)
 {
 	return false;
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 74c4633f5afc..3280533eaebe 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -82,6 +82,15 @@ static int __init kho_parse_enable(char *p)
 }
 early_param("kho", kho_parse_enable);
 
+/*
+ * For architecture code that finds, after the early parameters are parsed,
+ * that it cannot pass the KHO state to the next kernel.
+ */
+void __init kho_disable(void)
+{
+	kho_enable = false;
+}
+
 struct kho_out {
 	void *fdt;
 	struct mutex lock; /* protects KHO FDT */
-- 
2.53.0


