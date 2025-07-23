Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35C34C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:47:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36E536B0108; Wed, 23 Jul 2025 10:47:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31DA36B0109; Wed, 23 Jul 2025 10:47:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BF0F6B010A; Wed, 23 Jul 2025 10:47:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 069996B0108
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C36ED133A62
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:19 +0000 (UTC)
X-FDA: 83695807398.19.F9371C4
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	by imf15.hostedemail.com (Postfix) with ESMTP id CBECEA0007
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=VTriLw8z;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753282037; a=rsa-sha256;
	cv=none;
	b=3WW48Tp0K/Dt8gHSTxC4FGPN/tDVv5wkPXsG5//L7ELID4I/wpOQXahn6Kfxm4Zv5Xlwo0
	PZX2urk4mEiNRr2WOYK1TxeXhvmEj1kDn5hbatQQwDpux47AcFB90mHrrTIIUfTJTmOg3Y
	MyVB7fPkZUQlGHKiEksEQxb2dGBBbu0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=VTriLw8z;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753282037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4F1QX9qtkry2jc2ztpFtzfSo3tcuBncamP+UfSK+M08=;
	b=2WawU2II/8gtsGFzIqCC+O8jAeMECM+MsFM3gRXoO8Yvwx4eG3ZxEzZyH9kMu+Fx70qR74
	J8caEljLkRKXKffMHoxkHzl0W1WUqoZDWABUfSjOW6+KXrxEGcQ/LAkvedATAUzSyX07+J
	xiuuDxQo7zNLuaiFLtyLCqR6Hf0cfvI=
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-71840959355so19547b3.1
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1753282037; x=1753886837; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4F1QX9qtkry2jc2ztpFtzfSo3tcuBncamP+UfSK+M08=;
        b=VTriLw8zxQ0dSoH8a/OaqB9WrSAfIePliYWS6hh/8E5ijyregXAYeF2jtUERBSKm5+
         uM9TSN/c6ExBMt5MxZB5cEXEXQnKvnjHmN7BWyZ6ROmkMXtZwtU5ggrWKuLSlKO26foD
         PhOw9TwbYsvUTjWTTHhQZ+IcBzSptJ31qOVeFb80LIiLygSDnguKOo6DwMyr6NvirwGZ
         r7BDQf3D0NKvvlYPDtKsYI6FxE2pXx0Synjut8WFG6xiO9E0/F7iRMZz8A7Fc8fwWYlM
         l3c+ViQUyvGwVJXCG4GmqBk5squTfolj1KXG73bxybJcZ/MjENcCtc5r3NTkQZVow0XE
         Ngdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753282037; x=1753886837;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4F1QX9qtkry2jc2ztpFtzfSo3tcuBncamP+UfSK+M08=;
        b=R5My9yujRRnMJtteoPLgu8Rhyq6GYnFyb9fBTRgA/l5ESN8JVtXR2HVfPO5ZTzwRQ0
         kGAGkVKr1rvb5iyEEEwgXPQj31SwgduK5lnl9yPdmKJR8RTWmkCqlCbrfev6fWrRfNPq
         iDgGUXD+UWXKmR+KVlI4/Q8K68ZeBosSAfOjEEhRXBSHSbPg2Y3I8248XIwHZO4BTIfr
         m1PrG0908oTWwc3MrzRvR8xuBqL1rUphvSBZR1EJd7h94jgkXB3/doNKjSxi1t1S2bOp
         mU1blqQEjQp3V1FKUK38WRBjs3PuSa3Cce5Woxj7rzxGI5Z3tyaHuPmGUKhbGhvuJEcO
         QZnw==
X-Forwarded-Encrypted: i=1; AJvYcCV0ZisgLCFudTYVUUA+kGbBDBaqO6MZYAfAd1oxvkuW8DqkAsU0Op29hDf9oCf5I9VgnnnFGZul7A==@kvack.org
X-Gm-Message-State: AOJu0Yy8szQaL6DmaWaFna1bCXXFIT6ar7Et45wxVnuqA1OwzwEgsyfd
	jVdJDW6Ih1P9ox7orITvp+jH/l9hyR6ke2ZTBtq8L4SzI9mIa06NjTCuHFwGQRqzPBE=
X-Gm-Gg: ASbGncvGp1fZ/c0rcsodjVOHypoNZe/plrso9upwEXbfeTsKN7lAOgZQRU7K3mEBeAp
	dMCjkBZFIz2J9TfZTvUX945Pv4UeOef0M0MZhAY2nwSuUn+V8wzQ4Wqxd9yEywm2sUWYI/F4wHR
	fOVPM/+VJTbWwEuwuNnU/JvQRd+Oor5KsSIoC1f4p8zmvlu3JpS8S4JqCp9pQtXXeJM1/uhteNP
	+P9MxO8OznM2RsszmLXh4Ivu8IZyE9GY5jJlLmrG9IkITrlFdFIQhxNeXrKtS8SFVKZ35Rf14qF
	fWQ1ha6uSlZUIT6nRvTjpKo9hAiXAwU+MNGVZN1Q5TZn+lxYkfAFfbsdpm/L3HRhwaOkqkb0ImJ
	hDMzVHCqclWnFZbdiJXduxQN5P2hsh16Uzf93UFzvTkJylH+ksCG6tKma+Ij8a9qymKlzvDsr9N
	ZG0f0Ekww6eO/0xA==
X-Google-Smtp-Source: AGHT+IGIKplQvsQ6oyU5xYVnnj9HKRC7xjC99zYFucpfaGhtR6VBuuTxNds+2TPsqRP8M9w0Avf/qg==
X-Received: by 2002:a05:690c:60c7:b0:712:cc11:b02 with SMTP id 00721157ae682-719a0a12ea1mr108397577b3.4.1753282036550;
        Wed, 23 Jul 2025 07:47:16 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-719532c7e4fsm30482117b3.72.2025.07.23.07.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 07:47:16 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	changyuanl@google.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	dmatlack@google.com,
	rientjes@google.com,
	corbet@lwn.net,
	rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com,
	ojeda@kernel.org,
	aliceryhl@google.com,
	masahiroy@kernel.org,
	akpm@linux-foundation.org,
	tj@kernel.org,
	yoann.congal@smile.fr,
	mmaurer@google.com,
	roman.gushchin@linux.dev,
	chenridong@huawei.com,
	axboe@kernel.dk,
	mark.rutland@arm.com,
	jannh@google.com,
	vincent.guittot@linaro.org,
	hannes@cmpxchg.org,
	dan.j.williams@intel.com,
	david@redhat.com,
	joel.granados@kernel.org,
	rostedt@goodmis.org,
	anna.schumaker@oracle.com,
	song@kernel.org,
	zhangguopeng@kylinos.cn,
	linux@weissschuh.net,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	gregkh@linuxfoundation.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rafael@kernel.org,
	dakr@kernel.org,
	bartosz.golaszewski@linaro.org,
	cw00.choi@samsung.com,
	myungjoo.ham@samsung.com,
	yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com,
	quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com,
	ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com,
	leon@kernel.org,
	lukas@wunner.de,
	bhelgaas@google.com,
	wagi@kernel.org,
	djeffery@redhat.com,
	stuart.w.hayes@gmail.com,
	ptyadav@amazon.de,
	lennart@poettering.net,
	brauner@kernel.org,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	saeedm@nvidia.com,
	ajayachandra@nvidia.com,
	jgg@nvidia.com,
	parav@nvidia.com,
	leonro@nvidia.com,
	witu@nvidia.com
Subject: [PATCH v2 11/32] liveupdate: luo_core: integrate with KHO
Date: Wed, 23 Jul 2025 14:46:24 +0000
Message-ID: <20250723144649.1696299-12-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CBECEA0007
X-Stat-Signature: 95wpryg9xyo9xh6diupz5881h7ogtpxz
X-HE-Tag: 1753282037-588225
X-HE-Meta: U2FsdGVkX1+UwLDiZLXY/UpgzgIOgYkkcoLwQsnKOr9CniMYxDeQMWeyyyPUzrYZEqDBFuvZ8aEb71GnAXUn6PHxUk6tnSrXDPyISs/eblix5ldBqwLpiYnSlCjvbKh2cF+LYWNAg/Ide7/hfl+32wmPQqFBZ6VRn5mj089TNefzNLqARhBt2BN2oVqcZByJAiNzCz0Hep+HuWc/CDC7/zsmqk+VX+NbW28BEt6Yn4QOMDN4yvDgZTYoWCeCHL5nZYcQuEVvNOMoFq+9wDaKJrGrb9mwa6WrKJnB/DynnYYZBAueNtjcjV8d13+yDrN/wJuDGRV6LbkMYJhO3S/kZtfqgtGEJlP/1w07RI10aD+2g7KXH49uxcdSeHIL+jxlAmfPftc+mp7E2cLx85Z0WYBMdE8WlwBE6dsaKbSsTLfoGM5xbrhg0K4qONVSXHiodkEL3bx3HPwuM0r2f0yPFcFTjIYr41Oa6vwffZsQilga9tU6MmleSMdhAT7ZDILz0q5pjkoXXPupG2thzSnks63wXosaeVN8wn7+DkIjZ2wv7M2GiJIfsmAuXNykPhrfYfee9qKTKwVdLK0lOUp3VVEL/eza3AR9TI/PiWQTyAKC594taUDegQOnPaKcHDdT1RBfgYcQHYr3xEmBKRm4qCEW5GBU238Z15Paki9itSx3GzaHBKoOO1/K6JcRJQQlFWdfpLWGUcQS6hi5pW9zfWZMGcY20quH538newGnA7OTL6dPoh0Zl3PHokswckJSQT/hXXqyARwk2sbB+lcq4V74rod2x/WBrLOWgQ5MemC2eNxn7gTFen5t70rTcxpDs/tOSkcsB51pIJHjSMFDA1lOe0x6uUNrsPHe5APQ9RDos11RFjm9wA79pAB8o4ydXB2N9olVAncrn5yXWRJN9QNync1sAD+/DxXdsvTcMKNHMqxuwV8W2qpItzKGzKg8lNVeXKreQGk8PB51u2E
 Tw1oQW1c
 4FjQ6txid2R1RMr1bqil+gqOwHMKsOvtTthP4HPDrlj7udrx8o2mJ9oZ37kDu+DhrSasNFC8aYrLsD1FsJsCmrjXNipmNDxMsxoWQkkULu0cqrLTqsBRyM/D6uKZN4W1DPjbJ2tGghTOuTe7++AJ4wLnxQG5yIzWbACub7McpX7e4n+j+exDVvlT3288YK5OqYQQIceowotO12semzqlnvuMVGvhg6m9B2PsGwJXmizxT0LuX9AZyc9x9DsZw1w5pevNlrZYUrsgOBK2eF/EKjkQ6xTp2RpAPEMO8o2ciDzaRVUXQZ6McrR8kR6EKdPWTg25K62prMuMRgtQwPD/zZqJ1aeIeLldyGFjvjWZAsTEVf6Rkkqn3HTZSGoNAdtjQLZ0/1lfSokNxmEOLA8suTSyD/mO/NKzz5b5OQcXSD6mAXpx/qc6UdkZ385HvDYMEFN7+D5XjgkVYKPAtQObzitgmm44LL7rlgGJqVAB3+6JGwialW8Z4EkGGbDjp8nZpLG8JL5skYdUDDnrH0VuKOqO6aGdFtBlTwLliihtGuk2CKNU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Integrate the LUO with the KHO framework to enable passing LUO state
across a kexec reboot.

When LUO is transitioned to a "prepared" state, it tells KHO to
finalize, so all memory segments that were added to KHO preservation
list are getting preserved. After "Prepared" state no new segments
can be preserved. If LUO is canceled, it also tells KHO to cancel the
serialization, and therefore, later LUO can go back into the prepared
state.

This patch introduces the following changes:
- During the KHO finalization phase allocate FDT blob.
- Populate this FDT with a LUO compatibility string ("luo-v1").
- Implement a KHO notifier

LUO now depends on `CONFIG_KEXEC_HANDOVER`. The core state transition
logic (`luo_do_*_calls`) remains unimplemented in this patch.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_core.c | 214 ++++++++++++++++++++++++++++++++++-
 1 file changed, 211 insertions(+), 3 deletions(-)

diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index 8cee093807ff..c80a1f188359 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -47,9 +47,12 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/err.h>
+#include <linux/kexec_handover.h>
 #include <linux/kobject.h>
+#include <linux/libfdt.h>
 #include <linux/liveupdate.h>
 #include <linux/rwsem.h>
+#include <linux/sizes.h>
 #include <linux/string.h>
 #include "luo_internal.h"
 
@@ -67,6 +70,21 @@ static const char *const luo_state_str[] = {
 
 static bool luo_enabled;
 
+static void *luo_fdt_out;
+static void *luo_fdt_in;
+
+/*
+ * The LUO FDT size depends on the number of participating subsystems,
+ *
+ * The current fixed size (4K) is large enough to handle reasonable number of
+ * preserved entities. If this size ever becomes insufficient, it can either be
+ * increased, or a dynamic size calculation mechanism could be implemented in
+ * the future.
+ */
+#define LUO_FDT_SIZE		PAGE_SIZE
+#define LUO_KHO_ENTRY_NAME	"LUO"
+#define LUO_COMPATIBLE		"luo-v1"
+
 static int __init early_liveupdate_param(char *buf)
 {
 	return kstrtobool(buf, &luo_enabled);
@@ -91,6 +109,60 @@ static inline void luo_set_state(enum liveupdate_state state)
 	__luo_set_state(state);
 }
 
+/* Called during the prepare phase, to create LUO fdt tree */
+static int luo_fdt_setup(void)
+{
+	void *fdt_out;
+	int ret;
+
+	fdt_out = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+					   get_order(LUO_FDT_SIZE));
+	if (!fdt_out) {
+		pr_err("failed to allocate FDT memory\n");
+		return -ENOMEM;
+	}
+
+	ret = fdt_create_empty_tree(fdt_out, LUO_FDT_SIZE);
+	if (ret)
+		goto exit_free;
+
+	ret = fdt_setprop_string(fdt_out, 0, "compatible", LUO_COMPATIBLE);
+	if (ret)
+		goto exit_free;
+
+	ret = kho_preserve_phys(__pa(fdt_out), LUO_FDT_SIZE);
+	if (ret)
+		goto exit_free;
+
+	ret = kho_add_subtree(LUO_KHO_ENTRY_NAME, fdt_out);
+	if (ret)
+		goto exit_unpreserve;
+	luo_fdt_out = fdt_out;
+
+	return 0;
+
+exit_unpreserve:
+	WARN_ON_ONCE(kho_unpreserve_phys(__pa(fdt_out), LUO_FDT_SIZE));
+exit_free:
+	free_pages((unsigned long)fdt_out, get_order(LUO_FDT_SIZE));
+	pr_err("failed to prepare LUO FDT: %d\n", ret);
+
+	return ret;
+}
+
+static void luo_fdt_destroy(void)
+{
+	WARN_ON_ONCE(kho_unpreserve_phys(__pa(luo_fdt_out), LUO_FDT_SIZE));
+	kho_remove_subtree(luo_fdt_out);
+	free_pages((unsigned long)luo_fdt_out, get_order(LUO_FDT_SIZE));
+	luo_fdt_out = NULL;
+}
+
+static int luo_do_prepare_calls(void)
+{
+	return 0;
+}
+
 static int luo_do_freeze_calls(void)
 {
 	return 0;
@@ -100,6 +172,71 @@ static void luo_do_finish_calls(void)
 {
 }
 
+static void luo_do_cancel_calls(void)
+{
+}
+
+static int __luo_prepare(void)
+{
+	int ret;
+
+	if (down_write_killable(&luo_state_rwsem)) {
+		pr_warn("[prepare] event canceled by user\n");
+		return -EAGAIN;
+	}
+
+	if (!is_current_luo_state(LIVEUPDATE_STATE_NORMAL)) {
+		pr_warn("Can't switch to [%s] from [%s] state\n",
+			luo_state_str[LIVEUPDATE_STATE_PREPARED],
+			luo_current_state_str());
+		ret = -EINVAL;
+		goto exit_unlock;
+	}
+
+	ret = luo_fdt_setup();
+	if (ret)
+		goto exit_unlock;
+
+	ret = luo_do_prepare_calls();
+	if (ret) {
+		luo_fdt_destroy();
+		goto exit_unlock;
+	}
+
+	luo_set_state(LIVEUPDATE_STATE_PREPARED);
+
+exit_unlock:
+	up_write(&luo_state_rwsem);
+
+	return ret;
+}
+
+static int __luo_cancel(void)
+{
+	if (down_write_killable(&luo_state_rwsem)) {
+		pr_warn("[cancel] event canceled by user\n");
+		return -EAGAIN;
+	}
+
+	if (!is_current_luo_state(LIVEUPDATE_STATE_PREPARED) &&
+	    !is_current_luo_state(LIVEUPDATE_STATE_FROZEN)) {
+		pr_warn("Can't switch to [%s] from [%s] state\n",
+			luo_state_str[LIVEUPDATE_STATE_NORMAL],
+			luo_current_state_str());
+		up_write(&luo_state_rwsem);
+
+		return -EINVAL;
+	}
+
+	luo_do_cancel_calls();
+	luo_fdt_destroy();
+	luo_set_state(LIVEUPDATE_STATE_NORMAL);
+
+	up_write(&luo_state_rwsem);
+
+	return 0;
+}
+
 /* Get the current state as a string */
 const char *luo_current_state_str(void)
 {
@@ -111,9 +248,28 @@ enum liveupdate_state liveupdate_get_state(void)
 	return READ_ONCE(luo_state);
 }
 
+/**
+ * luo_prepare - Initiate the live update preparation phase.
+ *
+ * This function is called to begin the live update process. It attempts to
+ * transition the luo to the ``LIVEUPDATE_STATE_PREPARED`` state.
+ *
+ * If the calls complete successfully, the orchestrator state is set
+ * to ``LIVEUPDATE_STATE_PREPARED``. If any  call fails a
+ * ``LIVEUPDATE_CANCEL`` is sent to roll back any actions.
+ *
+ * @return 0 on success, ``-EAGAIN`` if the state change was cancelled by the
+ * user while waiting for the lock, ``-EINVAL`` if the orchestrator is not in
+ * the normal state, or a negative error code returned by the calls.
+ */
 int luo_prepare(void)
 {
-	return 0;
+	int err = __luo_prepare();
+
+	if (err)
+		return err;
+
+	return kho_finalize();
 }
 
 /**
@@ -193,9 +349,28 @@ int luo_finish(void)
 	return 0;
 }
 
+/**
+ * luo_cancel - Cancel the ongoing live update from prepared or frozen states.
+ *
+ * This function is called to abort a live update that is currently in the
+ * ``LIVEUPDATE_STATE_PREPARED`` state.
+ *
+ * If the state is correct, it triggers the ``LIVEUPDATE_CANCEL`` notifier chain
+ * to allow subsystems to undo any actions performed during the prepare or
+ * freeze events. Finally, the orchestrator state is transitioned back to
+ * ``LIVEUPDATE_STATE_NORMAL``.
+ *
+ * @return 0 on success, or ``-EAGAIN`` if the state change was cancelled by the
+ * user while waiting for the lock.
+ */
 int luo_cancel(void)
 {
-	return 0;
+	int err =  kho_abort();
+
+	if (err)
+		return err;
+
+	return __luo_cancel();
 }
 
 void luo_state_read_enter(void)
@@ -210,7 +385,40 @@ void luo_state_read_exit(void)
 
 static int __init luo_startup(void)
 {
-	__luo_set_state(LIVEUPDATE_STATE_NORMAL);
+	phys_addr_t fdt_phys;
+	int ret;
+
+	if (!kho_is_enabled()) {
+		if (luo_enabled)
+			pr_warn("Disabling liveupdate because KHO is disabled\n");
+		luo_enabled = false;
+		return 0;
+	}
+
+	/*
+	 * Retrieve LUO subtree, and verify its format.  Panic in case of
+	 * exceptions, since machine devices and memory is in unpredictable
+	 * state.
+	 */
+	ret = kho_retrieve_subtree(LUO_KHO_ENTRY_NAME, &fdt_phys);
+	if (ret) {
+		if (ret != -ENOENT) {
+			panic("failed to retrieve FDT '%s' from KHO: %d\n",
+			      LUO_KHO_ENTRY_NAME, ret);
+		}
+		__luo_set_state(LIVEUPDATE_STATE_NORMAL);
+
+		return 0;
+	}
+
+	luo_fdt_in = __va(fdt_phys);
+	ret = fdt_node_check_compatible(luo_fdt_in, 0, LUO_COMPATIBLE);
+	if (ret) {
+		panic("FDT '%s' is incompatible with '%s' [%d]\n",
+		      LUO_KHO_ENTRY_NAME, LUO_COMPATIBLE, ret);
+	}
+
+	__luo_set_state(LIVEUPDATE_STATE_UPDATED);
 
 	return 0;
 }
-- 
2.50.0.727.gbf7dc18ff4-goog


