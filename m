Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92D6EC87FD3
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 01:45:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC9E06B00A2; Wed,  6 Aug 2025 21:45:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7BD06B00A3; Wed,  6 Aug 2025 21:45:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91C106B00A4; Wed,  6 Aug 2025 21:45:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7D9606B00A2
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:45:06 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4BA941DD466
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:06 +0000 (UTC)
X-FDA: 83748268212.07.0DE6913
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7E7D3140002
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=lSSv0h7G;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754531104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KQpmpulpEMbleZBgXGFUqWXbMNM3g038MqdeBg/kxjU=;
	b=5pz14l1mvt/WbVKTUSBJfALMNDakpbwpRl+ZbrYdyHXCFR9PUxajXxiXfbS27muVElFBAN
	3i0BOCMEIXMrArKtzgCdN7v6NMDjw+Y+LitRRpnSiDex2cU5h17NDlq011WVKikPItA2Gv
	Dk/XW1M6yrRXuDLyY2J6LWbXSAwHu8g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754531104; a=rsa-sha256;
	cv=none;
	b=zoujqN9cL8MMC5WVcyddPuWzJ493fdfClJLuw3Xs1tlxSenoxaSDz/FOURwBpsfwgPwg9b
	jQ7TSy28LZiXs2YvTnkaLcK9beShh2jzt7dKfTPHHVf2at4aGGb2BKRgTTlWr3ISmqja8Y
	EbaViK9E4Xg1QH6XVbV9CItAEgh+5II=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=lSSv0h7G;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-7074a74248dso5528116d6.3
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 18:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754531103; x=1755135903; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KQpmpulpEMbleZBgXGFUqWXbMNM3g038MqdeBg/kxjU=;
        b=lSSv0h7GMBtSN1uDZccc5XUQbALKASJHXMrxfMYhTEmN5/Pzh7Q8J/diJSaqr2BHNF
         zh9sSXhVSp9hXgN/FiuNPI4XLRuyhVhp8+s34HfGxW2m4A80MlmlKaPIzkjTrDF9GH+g
         sihjmN008I96VwdyHNxu1Ih35CIIik1zn96FW8I4K46RPQojccJvNszzGmvjVooE7WBw
         DTghFaib5p30KDFzU8rHOYpk6DbUSxQ8ekSCGR4X0L8DNAqr+FceuhwWfQYOG1MtukCY
         4MTieTBNqa461UcrvFo4NCb73qAq9tHK+4war+XglXEnzX6ZIqSRfVfVYm6jo4uQsEN1
         dQzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754531104; x=1755135904;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KQpmpulpEMbleZBgXGFUqWXbMNM3g038MqdeBg/kxjU=;
        b=HpI4Zxow1GKrZb23rla5fFeUieYAt62KM1iRnT63gDlkY+o3HuTPushgm2xqUfX7YV
         ypHxrT/TkTeUfLhFfi12Fhjbd38KbQKY9griSk/YI9zfnh6BPWNqH9aaNP5zNklc0GdN
         PFJCcOFA6SDcdI5LdfaN/vXCa8UncyfHPB+vdqFq2JALBFSdAwcyXK0aDCCnbnQNugUn
         +8BzD98hFzy1mxBwUMUvUlaaRk8t/HNOMpgFNxVMI8mW9y/HEkgBgVzIxXNtANAacsDj
         emSfygHwEdRXzXIzbKRvujsDJiKCqU+9f1jgRq1oJu+qQNxtGeW6jSnSqfc4V/pSKR3Z
         xo7w==
X-Forwarded-Encrypted: i=1; AJvYcCXBZbUU06uHpeSgTQPKHzM4WvJ9jvN92gq9R0guDCkA1CQYsb33dWKUZoc+VSkUNpRfyfgvPOft4Q==@kvack.org
X-Gm-Message-State: AOJu0YxmDegODeGEgluP3S2ob2wZsYBQylX13U6WTgiYcUxHDBBJpFch
	CkymOG+fQI0k3UEPf3GUI18EmvU/es+o65F0x/6BC/9+uJ6BF3TxI6LpqfYD6Vp31ro=
X-Gm-Gg: ASbGnctQZRrWPBNg5+nKjglTP16n7ZjjEm4AVSsluOqef0MF4I/mvE8ORHO033UgQBe
	gS5nvwt3QRFMPQA/HrGkilD+05IgYLnEX9no0QmzJ0jkxXBS9nP/a7fMIkEYQEoPY//l5u+1pa2
	P6J3U9ddkn4C2OXZdpBY3nSDnL192J9tHJq3+jUm5SGUgXSXg0YEnfu3NGmQj76HkP3gmDIIMwE
	XkhGYf0zAZGWN29qULl9nip8Dl35KLNfuzitEm2rQbXyyzsEPfH+qq/BUoj8TPfBqN+eTJgcK88
	Y6ZcFAsvJ+yEas+M3RJ26ZuHiARPn4QwTIC+sVTzorn+uSxSzYgR959pjaaEr9+B2nM23Ym46sW
	T2RUmhD+uKXEGh2LjmRxF66PHRHRiWgihSvzeJmJFo4m5N2ItbickM6mCGwonQYGa6qArQbiSOG
	ZHejhKjkDU/YMODDh/7X7jc3E=
X-Google-Smtp-Source: AGHT+IG4qF76mfK0ckCdhvAOyM6dk3CxZ2iK62x6AwDVufRrHJI4s1ZiTk8d/a3ypIjxis075X7CBg==
X-Received: by 2002:a05:6214:6005:b0:709:8672:dd84 with SMTP id 6a1803df08f44-7098672df63mr40806146d6.21.1754531103493;
        Wed, 06 Aug 2025 18:45:03 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077cde5a01sm92969046d6.70.2025.08.06.18.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 18:45:03 -0700 (PDT)
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
Subject: [PATCH v3 11/30] liveupdate: luo_core: integrate with KHO
Date: Thu,  7 Aug 2025 01:44:17 +0000
Message-ID: <20250807014442.3829950-12-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
In-Reply-To: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7E7D3140002
X-Stat-Signature: fs9z1d96aeeyft1sdcxmigs7khm8jm6e
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754531104-700646
X-HE-Meta: U2FsdGVkX18s0SCMXpirJmorfJ52YL2KXWtdhe0QqPyuIMMelM9Bn4OCpx84FE6JhsDPZ7Bwa+nw69Jnff8NQBl1s7EUxldbJRFnh6tHNrmgRcTPB2cs61SWAaqS3NmE9SvU4Gu+Bvq8qEcoPECcbKy9bcDeraBFdNRNXzRmzazZDYCqfFrFY22OGHeHbnjmxKKidwoJDT5upV0D2AaUuVHkPheYz63yIH16YwUR4IeM4+VjG8qW+dRc7+cHXS6xFbFgo/s8kTpiL+RGkK4qw8FbC3AB3MZ1wd+F8tDQKY9ryC7aQv09EdF832plhwcfWXOIKTu7Hfhwt1+4eS1skTo9hbp0+dIjuxFKP2pXQ9pIFGHiGmQApPZKYC0BTmQ3MRa/FxrL5TEj4Stqvt6BPZsJz+uKMcSQWu1uvRK/NhVSeIQt216AfZTwECxao70DM1GjpWG+cGntOszyRQAxt+/ink0P9MIkWJmMADDAgJrTck42eOrXB9ydBl1lCGNsTpFxeTc/EsRt8Hu9oYzG+Ts6fIyrRxxqr8wMOrEoOO/Oavtku72CY+Nu4fswZb+Tnrd9V6grUSTZgBpxQ5hbkZBOWOF/PeongjXv3auqKvGLtiR9lvPS0hwv10kHKB4siGGB3dzUhManwBlPgc9UJfsNjx1Sk3pLC6NWrQcp9BBT58iNNPVGPtyBMKO+P8QMajRbT+LbUzBA7pYh6uDALFqf0cewxYCk0w9JcOhlAfphq0OUi3Mx68e95S3KsyvWy5GJ5WbWb6Z/nj6kVIts8ewGtUCqOc+kzpll/TYffmgcDeFRWh/nxr9iyAY78amz9CuHYnbzzM58YOgvfhsIKS/0pgGdqELM3+OMIZky7yUX5LmvieiY70dSK3gsbLqo47kLjEAJ+QXlpgg75TwVcGFTzGS6B/a3m9yoBSQz6EVxseb7j6XOTe9PvijuuSI1bL86igIKWTCS/Y8+z4W
 BMwrxpSm
 bbgH7RoVJTAVXfA+/96r+lNSuWYCgMXaccMRYrnFqbTa9AczK26QazQk+6la7Yqfr+jIcE9QiIXFtmTFtvypjD/aOOqeApxv979w4MGv2jauPVmN2pE1WTWcSVaptIyaxCnC/KJwXV1EvSSps5gdvnrJqY0EY+ooJ9YFSntUr0LBaGcpWbt+GIXOatjpi0KEx4vO5tT9WCpEaQwxkXGwAgND7wqDJReNDrTGy1QKcnruj7y+0fVp08RkC47YxwgSZkgJcO7U05ihiKzvrhVavnP7ZSnGBHlXCyMfbhc18A2yG3DG4eDjvwSae63irkAfLd1OSgrUX6I2XTBvOTxB+QR05OjbsSYn9vsQEz6GPfW+m5XFnxQx0oxB4wke9i14rccj9MSPKaldJxnrgBYt6G+F1IdQQB89bu7LesfbV5w+CHczEQfoZEN7Xf9wGsMGVyfbF
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
 kernel/liveupdate/luo_core.c     | 210 ++++++++++++++++++++++++++++++-
 kernel/liveupdate/luo_internal.h |   9 ++
 2 files changed, 216 insertions(+), 3 deletions(-)

diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index c77e540e26f8..951422e51dd3 100644
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
@@ -210,7 +385,36 @@ void luo_state_read_exit(void)
 
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
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 3d10f3eb20a7..b61c17b78830 100644
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
-- 
2.50.1.565.gc32cd1483b-goog


