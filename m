Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 182B0CAC5B5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 01:03:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB6CC8E0010; Sun, 28 Sep 2025 21:03:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A67228E000F; Sun, 28 Sep 2025 21:03:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F5E78E0010; Sun, 28 Sep 2025 21:03:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 645F78E000F
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 21:03:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1837D85804
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:03:46 +0000 (UTC)
X-FDA: 83940490452.04.CBA175C
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf07.hostedemail.com (Postfix) with ESMTP id 422EC4000C
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:03:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="cqRi/zOx";
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759107824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2J5W7RP3mcD6qfnmKA/9lO7swWy58O6Kyen5gVTP9fM=;
	b=me8TH7JftGjY4wbKl52tvrHJTlrxuBpjELo1jF2X15L1OWYQpli65nS7O5O73FLmT8sZJU
	RyDN1W3XPFlHW/RHk96bWRdOVgelrMZZ3HsDMuTt1vxwYxDbtckGNlBoi2asCInvQ/CkGB
	K4CV0YgEJM2rNJXaxbetVWWlqZ6R3Aw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759107824; a=rsa-sha256;
	cv=none;
	b=Aaoca+wuTx+QwJT5x8szyeSlMpFv5toFrkOR99tJri0d2GmkCjKoRsjxu6wFasIYL6S2nS
	VSDFwOuH9pYp1CHzPDIgMxg7jeKeNaHrq+p2vylK4gQrYUivnB5W0byyPWjv0V450IEvVO
	aK4OJOGOpx1iweG7ccuSDgRxz4fOKvs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="cqRi/zOx";
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4df4d23fb59so16769641cf.1
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 18:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759107823; x=1759712623; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2J5W7RP3mcD6qfnmKA/9lO7swWy58O6Kyen5gVTP9fM=;
        b=cqRi/zOxx/yLNAkC4SF5RkewmRyuTeMLeL2ZIjW00UX61qy1JYIwNqf3Nw6uIi9Esb
         z1pcEKOsowF5rm5u0DUbODtiloAVTOVPkuhH4pyfcPkSBuJLgqkj7Rz9G4BnEU2N6n6T
         ZNiNZ46+ylXWks+draVUoM93f6bwZtkMjAEXUik9EUqj7G+5j7cTeJSlobeX+7hdxgu3
         uQMfORX2oEBMR4SV/NMGfcHZgf/whwh/pMSmh9ZoKBiBLhlKaJcvikxvRAN1EmXSrYMH
         +y5PFwlHLTRE8PaTQ4TvSWCbDGzrEM2uqfWFJTj7U9D1v/51k58UE4CM1cYLdD974fRB
         /hqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759107823; x=1759712623;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2J5W7RP3mcD6qfnmKA/9lO7swWy58O6Kyen5gVTP9fM=;
        b=RMIMtvD+oDf4hlqSUfmyWUMKPY0at9LpBtUi9vKtZut42Xsx8LAOOX02Sr6oOmY0jK
         GB/QptOmDaQRTHfMZU0HVGLNmIU06RyUDbkehyBEyY4BOTv1w0kN4IBxusRvruBuNiNP
         HKbRcz0tppE3Odp804CNpwUskfzsgGzTFVIR865JM75yfJFj1rO/6cTsDmuRKDHvvvRd
         X6gpQxsJLs6dYSCoH72tkXUPHB6g5pdgDUYmhH3Vn+MglRRbAZkyPbCSszbZxW03JKxU
         DmGqTmTNvks180yAMnX7sKp8N9M4pSOG/ExGasPeaoz7DxsC+vS9Yp2G+gfv2V6Xnt6V
         SsYg==
X-Forwarded-Encrypted: i=1; AJvYcCUeIOHagHPi/954x3qgt2qjmZ7lZyPCAqIxGjc8UpMLorhh+rPZ61AOvNQgjtFSAP/koh1WKZlNTA==@kvack.org
X-Gm-Message-State: AOJu0Yws6uRvC0/18G2TUJ3z/7P95Fj/mDB1poAcJFhmJrOM5s5MAltx
	waW35k4gaXfjlt+GdbhF56VgUPXV0LiK5N5ErIwK3XoeKuqp3yGjZquDEsAyIIV5wyU=
X-Gm-Gg: ASbGnctGk6v4NAdmo7fQVdKxb0WIiETMrYmiJSfnY3hR2Sw/0dWG3/cEzJjn8ptNK6T
	TJrdJIe16yOTF2OhpBbsj/i/DVclBS0MykVORLW2Rs9RB5p51tIgF/waByP5KWoyjBIrNV5gDeZ
	/QEgGfgvnCWN8H7X80rZfSNeOzHa2kuDvWyjgDd2GlrGqrX/zgxMYQDX9w71ZbOntRsyS96yu3n
	4U2JoD63EwhzOX9EYvp5c9/QCFAeuFNsRLlnXzh6JEWxy7BuEtrnmhuJ8iGBURM2NDXjflOYAbW
	MYIclXzwMhHy2wfBud4Fs1uBh7xtwjq8VcohdbcRGQDQ0/kSQRlRlsteR0XRd7u5o8gBP/9gMEj
	5SGYKTb0KG52Uv6yxRkLdoVjzlJzFHloR03WKMW0J8EO+46st3JyKGE3On/wr7rpzZdpfPQrpOX
	TPEwQRpdaeqc2j7XQ28g==
X-Google-Smtp-Source: AGHT+IGaV3SESLMA5+DIYYmSBm152vC0KVkg9BHG7ku4t1EPFpwQC7mmZrH2IaNVGBpmOmq3lM96pA==
X-Received: by 2002:ac8:5f84:0:b0:4b4:8e38:8f96 with SMTP id d75a77b69052e-4da4d8e3cbamr195662391cf.83.1759107822880;
        Sun, 28 Sep 2025 18:03:42 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4db0c0fbe63sm64561521cf.23.2025.09.28.18.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Sep 2025 18:03:42 -0700 (PDT)
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
	witu@nvidia.com,
	hughd@google.com,
	skhawaja@google.com,
	chrisl@kernel.org,
	steven.sistare@oracle.com
Subject: [PATCH v4 08/30] liveupdate: luo_core: integrate with KHO
Date: Mon, 29 Sep 2025 01:02:59 +0000
Message-ID: <20250929010321.3462457-9-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
In-Reply-To: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 422EC4000C
X-Stat-Signature: ir3cmgmru5q5gtn5sizu9k7dhw4km5gu
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759107824-965557
X-HE-Meta: U2FsdGVkX1/B0QyjMHbuxgCO/FuboaH1Srz3TKJx4FNSk7UkTHlhgOmyVBimmrX6hrLAzZ79Og8BkgumUnSy5ygSXZFKiuKgH3HwsWFw96n8gXFYWC1MuzfxEb1ORWIx5GsdsvkV/vnxsZSHgT+f/7gfCFiktszb1n5sprCsZsMNLGAxSbNv9b5+jIeLSyZKGuQBSJF4CEIl+xk5GYd85foz1htsSjAkaW5N6lrx2GFe2wI5wtg5c1wmN7E+4M9lEp8zQSKxYmac1SHRrlxFAqf/wiiQAj9KfHBhF+aBHRsAPI8A8mNpMvmtzvkiqyzyYmkG1QCaACpfdFkbN1j91SbvX9jGoLXPz5v28RuX+sfoy/0RfCuwoPcfAXSYKPmUDJ2dmuf8bCcPI+ft7vaPXkjqS2gK1U+H4OiLx4dZvaZW8GZUOGQvWZnWJ9LuYcIXQ4rhr7eRZ2FBLxHYc71izPUg2hdWxxrjQJvNydtaNBuKcMSPsTG5CkXuKwhGNE7ehaEBBM4LMrPW9WClP8GVjonvBFlBGilosHP5gdSmvDA/Wh4i1fPL3rH/EAVyA1EtgJjqvZos0l9yg78MHp9JrBWfki5bp1qKStQ7qaTL50QDc0D7EF0wisjNDqBPlQIkW7j7d8B74lQXIO7REYUgWy9+HunqgQgc1gnQk9J2tljGrnApHck6qPVEepxFxs3kYqAPJsYBJOVVqa6TZwSnwJG18u9OFOPVB2Rr7P9wZMf0GfuwbPrhpWabf/4+xN/uyFjlizFSeR7XdDUA9mE9VXZkUD1LYvw9oCaHb/Qp/+a2QhOGqUHyt77P2zH5w0HxNqmaELGJuqVoyNzDyHBA2Xi3d6XXwPltPVHLUncNvM+O7PxMpB0bOaMMpavjLassRTmYQy47PwHUEVz9zLNr4HgGiEPHLX5RJhxCRYEpj8qy1EpkclwF/zt83OOdtNIP+MVLIA+++SiLk4L5yQT
 9YEL59ma
 focFczwRpLvRC3a8IHxbyOKt//nFC0soIfMH3mbxTgxtiI64Wmc6q7TyAPRayCnVN1BHlfZa7eA6idSMOB3ixxNkfAUB+ZAcg1knUyaNAd0fUrH8V0GgMnLXrO41OfSbbngaLGjeiJcfVKttksWfXkc8A8HOECIbk9VUjk1hYIsoNqgOFyeFefuH86Wt4i2REvZszG1X6Is4VHQUQkU+sOfKMYLKr0B/fLX9fnhJqq/Kul9VdcrPowvMYk6ErYLuVT5R382T2xcmNDbSx+s33IuF8q996AvOCebmPt1qQJSe9B2CNwgye9X1wXvvXLWmA7oTtJ8q1cS6S2mtzqyqB9EYxg/PuzTSz1kDzHAvhzOuhE8VYnqH68KnuHJZsK0eeh+Ei/33nGH8LitgZObcq2NyztpPaWRse1nefwgGpwz3GcjuxT09WdEgeJbTuwhKBCdpsBuseFEUjl871SSuDOXRd399T2V54qO+2
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

LUO now depends on `CONFIG_KEXEC_HANDOVER`. The core state transition
logic (`luo_do_*_calls`) remains unimplemented in this patch.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_core.c     | 282 ++++++++++++++++++++++++++++++-
 kernel/liveupdate/luo_internal.h |  13 ++
 2 files changed, 292 insertions(+), 3 deletions(-)

diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index 954d533bd8c4..10796481447a 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -47,9 +47,13 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/err.h>
+#include <linux/kexec_handover.h>
 #include <linux/kobject.h>
+#include <linux/libfdt.h>
 #include <linux/liveupdate.h>
+#include <linux/mm.h>
 #include <linux/rwsem.h>
+#include <linux/sizes.h>
 #include <linux/string.h>
 #include "luo_internal.h"
 
@@ -67,6 +71,21 @@ static const char *const luo_state_str[] = {
 
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
@@ -91,6 +110,52 @@ static inline void luo_set_state(enum liveupdate_state state)
 	__luo_set_state(state);
 }
 
+/* Called during the prepare phase, to create LUO fdt tree */
+static int luo_fdt_setup(void)
+{
+	void *fdt_out;
+	int ret;
+
+	fdt_out = luo_contig_alloc_preserve(LUO_FDT_SIZE);
+	if (IS_ERR(fdt_out)) {
+		pr_err("failed to allocate/preserve FDT memory\n");
+		return PTR_ERR(fdt_out);
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
+	ret = kho_add_subtree(LUO_KHO_ENTRY_NAME, fdt_out);
+	if (ret)
+		goto exit_free;
+	luo_fdt_out = fdt_out;
+
+	return 0;
+
+exit_free:
+	luo_contig_free_unpreserve(fdt_out, LUO_FDT_SIZE);
+	pr_err("failed to prepare LUO FDT: %d\n", ret);
+
+	return ret;
+}
+
+static void luo_fdt_destroy(void)
+{
+	kho_remove_subtree(luo_fdt_out);
+	luo_contig_free_unpreserve(luo_fdt_out, LUO_FDT_SIZE);
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
@@ -100,6 +165,71 @@ static void luo_do_finish_calls(void)
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
@@ -111,9 +241,28 @@ enum liveupdate_state liveupdate_get_state(void)
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
@@ -193,9 +342,28 @@ int luo_finish(void)
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
@@ -210,7 +378,36 @@ void luo_state_read_exit(void)
 
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
+	/* Retrieve LUO subtree, and verify its format. */
+	ret = kho_retrieve_subtree(LUO_KHO_ENTRY_NAME, &fdt_phys);
+	if (ret) {
+		if (ret != -ENOENT) {
+			luo_restore_fail("failed to retrieve FDT '%s' from KHO: %d\n",
+					 LUO_KHO_ENTRY_NAME, ret);
+		}
+		__luo_set_state(LIVEUPDATE_STATE_NORMAL);
+
+		return 0;
+	}
+
+	luo_fdt_in = __va(fdt_phys);
+	ret = fdt_node_check_compatible(luo_fdt_in, 0, LUO_COMPATIBLE);
+	if (ret) {
+		luo_restore_fail("FDT '%s' is incompatible with '%s' [%d]\n",
+				 LUO_KHO_ENTRY_NAME, LUO_COMPATIBLE, ret);
+	}
+
+	__luo_set_state(LIVEUPDATE_STATE_UPDATED);
 
 	return 0;
 }
@@ -295,3 +492,82 @@ bool liveupdate_enabled(void)
 {
 	return luo_enabled;
 }
+
+/**
+ * luo_contig_alloc_preserve - Allocate, zero, and preserve contiguous memory.
+ * @size: The number of bytes to allocate.
+ *
+ * Allocates a physically contiguous block of zeroed pages that is large
+ * enough to hold @size bytes. The allocated memory is then registered with
+ * KHO for preservation across a kexec.
+ *
+ * Note: The actual allocated size will be rounded up to the nearest
+ * power-of-two page boundary.
+ *
+ * @return A virtual pointer to the allocated and preserved memory on success,
+ * or an ERR_PTR() encoded error on failure.
+ */
+void *luo_contig_alloc_preserve(size_t size)
+{
+	int order, ret;
+	void *mem;
+
+	if (!size)
+		return ERR_PTR(-EINVAL);
+
+	order = get_order(size);
+	if (order > MAX_PAGE_ORDER)
+		return ERR_PTR(-E2BIG);
+
+	mem = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, order);
+	if (!mem)
+		return ERR_PTR(-ENOMEM);
+
+	ret = kho_preserve_pages(virt_to_page(mem), 1 << order);
+	if (ret) {
+		free_pages((unsigned long)mem, order);
+		return ERR_PTR(ret);
+	}
+
+	return mem;
+}
+
+/**
+ * luo_contig_free_unpreserve - Unpreserve and free contiguous memory.
+ * @mem:  Pointer to the memory allocated by luo_contig_alloc_preserve().
+ * @size: The original size requested during allocation. This is used to
+ *        recalculate the correct order for freeing the pages.
+ *
+ * Unregisters the memory from KHO preservation and frees the underlying
+ * pages back to the system. This function should be called to clean up
+ * memory allocated with luo_contig_alloc_preserve().
+ */
+void luo_contig_free_unpreserve(void *mem, size_t size)
+{
+	unsigned int order;
+
+	if (!mem || !size)
+		return;
+
+	order = get_order(size);
+	if (WARN_ON_ONCE(order > MAX_PAGE_ORDER))
+		return;
+
+	WARN_ON_ONCE(kho_unpreserve_pages(virt_to_page(mem), 1 << order));
+	free_pages((unsigned long)mem, order);
+}
+
+void luo_contig_free_restore(void *mem, size_t size)
+{
+	unsigned int order;
+
+	if (!mem || !size)
+		return;
+
+	order = get_order(size);
+	if (WARN_ON_ONCE(order > MAX_PAGE_ORDER))
+		return;
+
+	WARN_ON_ONCE(!kho_restore_pages(__pa(mem), 1 << order));
+	free_pages((unsigned long)mem, order);
+}
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 2e0861781673..c98842caa4a0 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -8,6 +8,15 @@
 #ifndef _LINUX_LUO_INTERNAL_H
 #define _LINUX_LUO_INTERNAL_H
 
+/*
+ * Handles a deserialization failure: devices and memory is in unpredictable
+ * state.
+ *
+ * Continuing the boot process after a failure is dangerous because it could
+ * lead to leaks of private data.
+ */
+#define luo_restore_fail(__fmt, ...) panic(__fmt, ##__VA_ARGS__)
+
 int luo_cancel(void);
 int luo_prepare(void);
 int luo_freeze(void);
@@ -19,4 +28,8 @@ extern struct rw_semaphore luo_state_rwsem;
 
 const char *luo_current_state_str(void);
 
+void *luo_contig_alloc_preserve(size_t size);
+void luo_contig_free_unpreserve(void *mem, size_t size);
+void luo_contig_free_restore(void *mem, size_t size);
+
 #endif /* _LINUX_LUO_INTERNAL_H */
-- 
2.51.0.536.g15c5d4f767-goog


