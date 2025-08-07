Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 975B3C87FCB
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 01:45:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59C456B0098; Wed,  6 Aug 2025 21:44:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5239A6B0099; Wed,  6 Aug 2025 21:44:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 412506B009A; Wed,  6 Aug 2025 21:44:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 32D136B0098
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:44:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F2EA4136282
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:44:55 +0000 (UTC)
X-FDA: 83748267750.30.6DE4CDD
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf26.hostedemail.com (Postfix) with ESMTP id 20CB1140006
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:44:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=hvZ3FnWj;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754531094; a=rsa-sha256;
	cv=none;
	b=BU6IbUrpP2jl9lhpkHtSe4mBMuGic5/Pbu/eeSsF65FgHuzdZHGe3GJqQGO59dWYgT6dwb
	I9JfTKSZ/XozbSz58d2I4jsg7nz4AawcAfnes/aSieljf++0a3Oz0yOtT/ozGkLiuTRzQO
	Un21h7Qjbo67AyFwpJJAosxCQ52rtkU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=hvZ3FnWj;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754531094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FY0apzV4/jiYpNtz4zaEBU41SIXIqP4k9Hjv/Z6KQLI=;
	b=i6XPU2YOwWTpICkUL8wOa7hoS3PcZTFmDn3yCklIUlLvryJZOg1plvAcj2Sxh/YAiI6lC2
	MUaAe6xvRCDL+I8tibumm3e342U1rRwk2JWkZyzdeJJTxmiPQIJoBwfJyMgyOW/8MomugD
	5jAk1j1arQPSZ7lcToPGS+ogNlf/Epo=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4b0739c6557so7724701cf.3
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 18:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754531093; x=1755135893; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FY0apzV4/jiYpNtz4zaEBU41SIXIqP4k9Hjv/Z6KQLI=;
        b=hvZ3FnWjSeK8YC8bNUw7XObeCE1RWVp6pT9/Smsd0hJ73MTKRYGboRf53+yB1UEg6R
         0yiwjGXWYWCPwByYZX/gzUUw9d8ta6fszN8r0Meh14wi76xdpRISWhHKRHD6Fy89V847
         iUSaVkLB/qFyElLBC8yOSUokLQSx47Zpp4xxhpsNttUQ10JbK92OmZ73+mG4iafpyTC8
         8kUdf0MHi5OVUfakqPs85qTtAs68ZM5ID4nxsjTR1cZmPMhmEOuMOYUtCGDKssNNk9f4
         jWuod0baVwmKo5rkHcsTPLwNX/sfPmm9hBXHlng0TdokM0suts01f7MNwrYmsDxRRhhg
         5tPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754531093; x=1755135893;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FY0apzV4/jiYpNtz4zaEBU41SIXIqP4k9Hjv/Z6KQLI=;
        b=HSvf89mHekDgvdfx+EdoB6qevs+AQWpDVBWj4u8UXxUQaj/G+UaA0PCXHTQ/RyACVl
         1muOFjgKm5iGphAsGSMyyFY2CJeV89Zl3dVCBMLF1bYUHZA9kTh+u8lMWpPGelgznX77
         5r833VR8Lu2eXgW9iCxju7ZyNXcmLvIhGA/sIDQ+FInVYzNC1cWqMYMsQvUJGybxqGov
         WSPCJ6Fy+4ctMVj9Khf9zSYkfqMFebedn4+++Ubmh76KsBCSnOThQZISRAYdLtt+hZY0
         PxrRh7zAGDNwV96vJKQamQkMGKu9GeZwYJ7Pilgo9tPe72S5Xa4FhRKsYgTmAZJWrjEL
         JK0Q==
X-Forwarded-Encrypted: i=1; AJvYcCV3pOIaIOzjSWYu+DR6evYrDPZznxkokqAVtyjcIuo3uogiLW6n/024hdV1if/ZjntzdK/W1gHIog==@kvack.org
X-Gm-Message-State: AOJu0YzseccD9OKtxsj9bR0nEAUT1RoXewY0aTLVEAukobyB/aEQmj0M
	LWI4LGBP/KF2cOO1rwTh40OPgV2ibJa4bW/a1mx8ZTq7aXizum+b2ZX26dDo1jVg97Q=
X-Gm-Gg: ASbGncvGtqfWERP+ZmwMRp3jcZpV36jjEUhVrM3+kNF4iCXCOYaYl5Qmr9dO3fUCs9D
	iVsge7pfBVy7ZcImi85tE85tsADbvnIVdF7gQzMMlmnh4zNnD4yJHVnDQ1lA4qCzdZFsU8149L6
	PY2gCCIMacM3KgAHhMRhiYSwVxPk99yGpJGZGkNQV3vGxkvBFqlOtpa66ajON1h8qptKs+bIN5y
	EYdor3kOz+6eRDWNwJRBDclRS9+r/EHrVxN8ZBoJF7q313JIO+2MSdy8gVOyHlVKxEr6gVg6LnD
	YRojGBiBhUPBKNHRtFvPeTXqRwU2SdprPI3HotRs4v/H/4H+6EfMTRregDHyfjhO+Gq7GT+68r4
	K49OcPup35tVzOztb2okWFIiEpMmfPR6DDc4/L0C+4SGFBW5bMFtoxgmctIPJpvq3qN+m0eWSVd
	avu/SPAy/LjBN2
X-Google-Smtp-Source: AGHT+IFVnZ5D1Am418Avb76/eeCwz3uLxwOs//KfNDCrFp0xraechqxEC3xc41ENAONdARaIHNn8kA==
X-Received: by 2002:a05:622a:1494:b0:4ae:cc4b:11bb with SMTP id d75a77b69052e-4b09163a4cbmr65118341cf.57.1754531093076;
        Wed, 06 Aug 2025 18:44:53 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077cde5a01sm92969046d6.70.2025.08.06.18.44.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 18:44:52 -0700 (PDT)
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
Subject: [PATCH v3 04/30] kho: allow to drive kho from within kernel
Date: Thu,  7 Aug 2025 01:44:10 +0000
Message-ID: <20250807014442.3829950-5-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
In-Reply-To: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 20CB1140006
X-Stat-Signature: 4fuyzxz6e5xkcjeg36gn5awhjdmjw7b1
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754531093-733558
X-HE-Meta: U2FsdGVkX18yqITb1TXh5Q9Bzq/X/6lPcAEKbsCO+PzHj1I+fUne3n1ObspQlL1Nzl6SVOBuYzGq0iYYLa//cT6OyuIkRuNgTxoQ/SfkdXw0gwrkUCng8xysjZvotJDiNMUWLC2MjyrFwjdt2iI04rvtgBIEeQ11vBfrfUE5yfUSORaNX2WefAppfWiuRGerc1APADuZO0l/kTogqdKhvKRcNr/M5juad1C/s6N4wXmmS+4HgNRGy31kjCEytgPJccTH1NYBgEtXLRyIbZaRsajOQ3Uez2ACs8cnw8+Y5eCk0m8Mup+ZC6bKnkDQL0SKFKBip/FX1v0CAL7/WvLe0dpoDGlTK45l4Ph9RUvEZwmWP94Tw83FFmuZl7NZkTXNlYfB5DE+FQyLEcjv3mKS/niqCL8ftzfW5yMsXdP7OYQkuCZno6MxWSBylHLL3pyFA+dUW+Xh90Kl7aglNB5mKzEeLNZ/U9SxBmHKsVYmkCtNwTneecIp3qJESMK05lgReDJwUxu5xUcgxo0oFHQbvdwo3iWsBMazpTV4IW/eE1IXRZqgcTzh0uf1TinuA7et5yoUO1KMD9oRXDv4kdRrlVW2qjkfNNaAyamLWX4+QZ5yeLtOwe85F6bWd4qDOlWRpnEBXNtLKFCjJzdPOIYpMOgHRnFyTs75U7fTfSlOddGyYmKaXvWl2EM31p+hpf1tKVMdRuNNC3svSC6CqxZaqPg5sGmd7u7CEdcl0hbB7anKPx5zDCuHFkKN2n8PaobHewg/pXJeSlQgox7SxjdeAZUh+/22TiyWikbNORz/3Hu08dG4mSVRZXIxlPF84ZauMF4Lbc0OykTbVmgs20ptzCiUIA1W7kSPGvgWvqUgvU2bbj5LSDqSKSuQt94T54WbEtcdrPSfykBdBJsAULB20mUx4uWMogMMb9URXMYNyc+IYwre3J9MEiGWNyRyH+WHuUaltCBfmxWPgBUW8pN
 iPv3splZ
 KpOmjgI+9mExgK8Nan8BjHLaU6/tSlFVk/3cFlLi29rymTCJCv501XNxWAhI0TWSZQ6llvbM7RFiRIdn5eVyjwhYHkFLqEvjR0zAzDoLt+wtPVxXdVmYHlQFj4NGlvU6MvEQwjBN9h6e5O1fuaiWseO+B4YlpvwEPZ0cJShOQjTMYJC2eTIM0HQKxYNNDuMUb/rnoOV/HCEfbvJxWlDIAQxTe+CCgA5qX5rEXz1nADfz93YU9Ghkbz0VwNPcs09ADUNtHFpwxZK8lCZN0MnLaJmH/jhyddBRoMVcZrdWcOXDtfgaQiwBiv5k4rNg1w7Kt2h5WMUZ8lhgqRGrKhnJuahkzdJyb9iJNojESTtWQqIPCpGQlZOO2UYzxuM9obGDiPRjcgctreiw8x12VhYeIIrtxUZESAEIVaeIuf5JNcEz4onD0SuG2gFVErQ==
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
 kernel/kexec_handover.c        | 56 ++++++++++++++++++++++++++++++++--
 2 files changed, 69 insertions(+), 2 deletions(-)

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
index c2b7e8b86db0..2c22a9f3b278 100644
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
@@ -790,7 +790,33 @@ static int kho_abort(void)
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
+
+static int __kho_finalize(void)
 {
 	int err = 0;
 	u64 *preserved_mem_map;
@@ -839,6 +865,32 @@ static int kho_finalize(void)
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
+
 static int kho_out_finalize_get(void *data, u64 *val)
 {
 	mutex_lock(&kho_out.lock);
-- 
2.50.1.565.gc32cd1483b-goog


