Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A9B5C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:47:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8786A6B00F4; Wed, 23 Jul 2025 10:47:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 826F06B00F5; Wed, 23 Jul 2025 10:47:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EE646B00F6; Wed, 23 Jul 2025 10:47:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5A2116B00F4
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 01BF78075F
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:04 +0000 (UTC)
X-FDA: 83695806810.03.DF9A8FA
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf28.hostedemail.com (Postfix) with ESMTP id 52C71C0005
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=la6csOCJ;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753282023; a=rsa-sha256;
	cv=none;
	b=Mp2kse5g0vhc9i6/dqfpCojy4T12gzA4knvVPTmiyvMVGeZ44F3RnSkmOUAx30XW7NyQwX
	iZfD5sFZaWRV/9WvBHB+hymCOzQJufTsPmyIo5X+KetG5VB0AKMbw+oA97ibQV3BTblT0P
	VuEC3sYid1Rmd6n4mg2FzxTCwwf+qis=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=la6csOCJ;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753282023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3XYi+jDPzWu41ED2O5U4L0RfTKyUhB75+lmsBNGCN0Q=;
	b=1YAfrvSyK4YMelS9B4WEiDDVVZvf5XIBL2Sg4XqaoNKRSZbxODZzO6PsT7cTy/PxLDwrP/
	SKL/3QPS2be3aDNMvWVxrYBiDyOg9UfzuCegqaUOr1pdD367chyYScN+nZeC9PM4q2aIMV
	AwOGYYmy6QiR+reEcZKGkH7dpa0zclY=
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-7183dae670dso62712237b3.2
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1753282022; x=1753886822; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3XYi+jDPzWu41ED2O5U4L0RfTKyUhB75+lmsBNGCN0Q=;
        b=la6csOCJcFAMx/D6Hst67MFUfsO1hHciPRRS/Oz1iZ6/9ydtn8wXU+4z1RxJ07paUU
         RYY/GAVeDN3PB7xeCG0Xu/GKY75eKQ+tZjg101PbyaTS3upmYGF1DF6Mcq7rxboZfBow
         /5tHuaIqqzQ75dVNNck1Tuods7gsQu7e8BX4gWG6aEwkAc4C2qEIsJnqLUJSP3jsWfRk
         TcgSR3n73x17tiRRO3m9Xm/rjr/TV7/xYNwjG7seYr9HrVtWMymLDCSc6T3a7x0qmrf/
         gKPbW6vc7LmfZWLF+uxJMu/rNPV2VYGEwBG5FTNF5IIgaO9eZHVyCUXXjSp44UtLSnvt
         2RxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753282022; x=1753886822;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3XYi+jDPzWu41ED2O5U4L0RfTKyUhB75+lmsBNGCN0Q=;
        b=TTu8NN81rDEG8wbMUj0QKV8ZexkuvOWbyTLiE8L3Z4lStq5evBdSHu0QwUsIBWyAO9
         3D3ZJSom4267dphWbvPJ81RBDwX0LxQUO1KvOceAYGHAMHcb/mQ67ABk8Vz7hSfuHskx
         hp+Cx+HsB4wDuW/dCAyaiXqG2+zzCXOJ26/SNSQrRAaNVL5aadjA4NOSEagajk53cTzr
         Z7Yce5V2DJHA4iqDGVj/7LxMtJSxzQ4N8laFnjY2z7j6W9JW5I1B8kNs48yB16p1aIL1
         mQZpceUiEWhdY0inZpa6qLUrCMKH73efCGieeipAhMQeCG+KzvltKvT54gpXAW65S6BA
         QpAA==
X-Forwarded-Encrypted: i=1; AJvYcCWSs6ht9QDQvU95Fl2GNv5Sde/rxTuKP24PwY6ysdZRia+7pit/nPH7NCNJz+TFaUP4qMDOZTVKCQ==@kvack.org
X-Gm-Message-State: AOJu0Yx8tlxuO/E3WRw9ke7ehzwlrcTEl/vpNeN1Cz8/g7pK+/czy/Zl
	4cEqP0YQmOtCWa+QA5DksE+uldaRomgfHUPIBq314ozRZ03pztB4bHFzRFjckHuTuSU=
X-Gm-Gg: ASbGncvfYLutbqND6/y7F3N4jkS353vSSf9lx2c6ziiFge5obUXFb8rHTVZ0LWjhA4H
	C+9W7YjioJXP43/5QMjECj3NTgq3+WowxRmuRvFUoDwkaiV9kUTlztmCfYhsyUbvw6DHtcUCiSg
	RyxdW6n7iW7SaUHu/0ZaEf9GpW3EvVdwTi69/BdMHj/+gjjJ+3HCXlgQM/W9v9zmgcIGa/geHOf
	VWfPWkhywOgtuH0U1ok0hFpsmfJdIUHJM3Rd7ZgKVLXkoSZyiqs6kZFnvhV5H+kDzyHTD0E8JH9
	i9iqtp/6O0bjgOQ4+kIBsztZH39BvCUh10WnpN3nYcAIJiMsa/9RrcpNXTES5oaXf91hh6GQ9ES
	FNoL1aOBP7+JgMdkbZIpBAy5aZigAhCC3jtfUAphB4kDrR+hkuNOsMjx8OBWpGnAwsoAKrI5I9k
	yY1zmxJRuUAT62wg==
X-Google-Smtp-Source: AGHT+IGIyqUWtaPvswuBOlmOuoZ6Oiu0TyqZMj4g6mxjo7nkGd2imCQgeqT6/0gbrHlbiudRcFkz0w==
X-Received: by 2002:a05:690c:4911:b0:718:38bd:5433 with SMTP id 00721157ae682-719b427d2cemr38041947b3.42.1753282022224;
        Wed, 23 Jul 2025 07:47:02 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-719532c7e4fsm30482117b3.72.2025.07.23.07.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 07:47:01 -0700 (PDT)
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
Subject: [PATCH v2 04/32] kho: allow to drive kho from within kernel
Date: Wed, 23 Jul 2025 14:46:17 +0000
Message-ID: <20250723144649.1696299-5-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 52C71C0005
X-Stat-Signature: reeosbty65e9uj3yxakc38bdmndh648c
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753282023-596759
X-HE-Meta: U2FsdGVkX19M2NfcAiaWGd4/AXqgK+vpvxpqn0rpdvkalkSO6L3DpFFe7tohFY2OVVSzaV/FkwRjU9BHhyHo034G9gNkmic1heW1WxS1+zctkgnPlxTODcVwK1fPTACY70G3GTrkGgECHMlV2/Fp4b/uugK4rKvMtX5DAAJt6ThQb9jMddzq4qahbxVz+reFgzWG2RedOREasdEORw5tcoqryLZce9QoX+uTRg2GfPfc4dLzo4ycbhiw32bmA6soEEVbAk5hLf3UwwAgymkkAapWo5OgOzLJbQJ7hwBWv7JPi9UZX8A0ZsbP5sMHr+RD0DL3Nf6HfEzN6QniRFDi/99YG8QYxn5XxI8VljAS9e1T/vIHsCbrjiIlcX1UCWZXiqmagJgdqYtrPNPhRXLY9yNkmcN0lwwalEmGHu8FlomZU0Fh8bLYIIrYGWlWRLeu3lrSdaPddoch6a6hYeXCiwLw0UQLlfAcRtYDuCP44CZmuVUDSaNcLJE4ftRAb7bUxyLxZoy/M4EWwO9pbcdiZ8q1CfAugdqANMZgJNd7NcP2STd+nLJ3JnN3Mv3jxDiYycdmjvcJwOM7CDq+027eQqYLxAOzhRVOcMJB3Jd2slSGQ1+L/AS5fMSWLwtKCQMsjUZ8W3owkyoDIqdvWnOxSHUhwzzUYns8GjSHz7bu8PED43jUOSDrxPzgiwJrUPN9XaG66ggE5jxwRwgpLyp2B7Bc7Z+7+Chlq+3veM6fG5En8e6dTWZY/ucCUt/9Bnc0pN38MAIKBrqL7vTwCBPv/Wo6oATMwF5+mWNHLD01hhxobHCdgXLWDi7PrhZdRCUphHCpkCAT93BdlJl2zreLrIJkCyKpCbEcpgHhrC8QyBl34viXN2pfxShqFn5ZKCWjLN+bBFL0PnEpA7hp+b77fnDEkzbAQ5yd3p/K/AXuOFOAzRksh1tIvEOXKBjpZslzPkSFv+9LCp/8uy5QKHQ
 zIpqHJQk
 E2jJM637uIJdqY/VQQMiSX1IyENTdigU92spIrmZ7swUP3PmG/uJ4BPDGOl3PaZ2uPScwf+LbA9LEbZ/xhJVfDW745E29s7kbEu3msLj0VnmMs0jUTfyTSuAqw3kOBbzVfvqCc+dZF5imNIk20k1z4fPWp9sioL8wCAAFBhMSsOj9Zzv/O8dHWhNae8uaSzEXHqcp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allow to do finalize and abort from kernel modules, so LUO could
drive the KHO sequence via its own state machine.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/kexec_handover.h | 15 +++++++++
 kernel/kexec_handover.c        | 58 ++++++++++++++++++++++++++++++++--
 2 files changed, 71 insertions(+), 2 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 348844cffb13..f98565def593 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -54,6 +54,10 @@ void kho_memory_init(void);
 
 void kho_populate(phys_addr_t fdt_phys, u64 fdt_len, phys_addr_t scratch_phys,
 		  u64 scratch_len);
+
+int kho_finalize(void);
+int kho_abort(void);
+
 #else
 static inline bool kho_is_enabled(void)
 {
@@ -104,6 +108,17 @@ static inline void kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 				phys_addr_t scratch_phys, u64 scratch_len)
 {
 }
+
+static inline int kho_finalize(void)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int kho_abort(void)
+{
+	return -EOPNOTSUPP;
+}
+
 #endif /* CONFIG_KEXEC_HANDOVER */
 
 #endif /* LINUX_KEXEC_HANDOVER_H */
diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 368e23db0a17..c6ccc8e0705d 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -757,7 +757,7 @@ static int kho_out_update_debugfs_fdt(void)
 	return err;
 }
 
-static int kho_abort(void)
+static int __kho_abort(void)
 {
 	int err;
 	unsigned long order;
@@ -790,7 +790,34 @@ static int kho_abort(void)
 	return err;
 }
 
-static int kho_finalize(void)
+int kho_abort(void)
+{
+	int ret = 0;
+
+	if (!kho_enable)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&kho_out.lock);
+
+	if (!kho_out.finalized) {
+		ret = -ENOENT;
+		goto unlock;
+	}
+
+	ret = __kho_abort();
+	if (ret)
+		goto unlock;
+
+	kho_out.finalized = false;
+	ret = kho_out_update_debugfs_fdt();
+
+unlock:
+	mutex_unlock(&kho_out.lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kho_abort);
+
+static int __kho_finalize(void)
 {
 	int err = 0;
 	u64 *preserved_mem_map;
@@ -839,6 +866,33 @@ static int kho_finalize(void)
 	return err;
 }
 
+int kho_finalize(void)
+{
+	int ret = 0;
+
+	if (!kho_enable)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&kho_out.lock);
+
+	if (kho_out.finalized) {
+		ret = -EEXIST;
+		goto unlock;
+	}
+
+	ret = __kho_finalize();
+	if (ret)
+		goto unlock;
+
+	kho_out.finalized = true;
+	ret = kho_out_update_debugfs_fdt();
+
+unlock:
+	mutex_unlock(&kho_out.lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kho_finalize);
+
 static int kho_out_finalize_get(void *data, u64 *val)
 {
 	mutex_lock(&kho_out.lock);
-- 
2.50.0.727.gbf7dc18ff4-goog


