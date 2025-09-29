Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E74E6CAC5BC
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 01:03:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49B968E0008; Sun, 28 Sep 2025 21:03:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 338138E0001; Sun, 28 Sep 2025 21:03:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13F5C8E0008; Sun, 28 Sep 2025 21:03:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 00E368E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 21:03:35 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A3C6116020F
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:03:35 +0000 (UTC)
X-FDA: 83940489990.08.CA1427E
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf20.hostedemail.com (Postfix) with ESMTP id D66841C0004
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:03:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Za3Ljxiz;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759107813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RU4szgNN13WysJ6xhtBfiTDK+ejkMnCmbQOqkk33H88=;
	b=xaacTPcniQRHhRvZyrlRYvS8j5XYmPN+4tFzZiBoTP0JJWpuYcCuczS+Tg0pESymdouSGg
	ZOIuYN8EOoZJ/zRPYkh6liCGteVNzuwPG3n14IUapUcG29KXfWfOEE+hFYvzghNHQliLrn
	tXd+C7wq7nDqM7Nur6Qn44XdGiR6ij4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Za3Ljxiz;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759107813; a=rsa-sha256;
	cv=none;
	b=136RCYdN0uRM7V+5WbS+GxIpvBe2avWEUKdCD5++D21tVEVA5FL8gdfvBPZ6sFON1vNka8
	P3d7P2vs8X800IDK7HgpdouO5fMwimVCLjM2SXkkqslFaGv0v4KsPLsgX66tE0Ugnbsasl
	sjZX0ni2J1ph9uFT1iEYX1eKMHD0BMI=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-85cee530df9so435773685a.3
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 18:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759107813; x=1759712613; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RU4szgNN13WysJ6xhtBfiTDK+ejkMnCmbQOqkk33H88=;
        b=Za3LjxizDjPfi/qyANQzizMnQ704tUMtrw2rCRMd+QwX62zvpTGOcsR55qXO9khm7R
         n+P0MXH3q0sq5ve/mDqdT3GQ6E1QHgZhHGUDiAAr/UV1JWBMS42m0Wi24NFApevc2eZQ
         ExwKLv2V5uLUSlWYiSIkG+wQdOq2ztdSkAff+XeTPxGv8cFt1ycFB5R1hfraDOujRRfJ
         ucnYXxjrpA4nRo4KqccuYojHFr8QFRdX89SN4SsMCav0+zoKGYp60T7hRFkRV817q2Q9
         2F6nm8l1srml5zVK4Kd92KfOeWkJWu90W1o1hUCsduNFEFGzBF8pFr2/2Awy2FUSXL8g
         a6Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759107813; x=1759712613;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RU4szgNN13WysJ6xhtBfiTDK+ejkMnCmbQOqkk33H88=;
        b=lCWIPy/dDrHFTw9DnVn+bt8OVVbhTToFBdiaPxTjWbN3kaae1tXMgi9xIieeVgGt+P
         yXYkWKlE8nsM1kSnfeq7ViQzPKxW5bVbv6oU7I6VmJ0/Pr5FGkRPg/7mmuDB1q5dpEy9
         wghKFNvBlyNg0KJ5J7FGQKDpuROgNuq0T0V+0O2HiycXhn2MtMvf5lr6wIP60cGaQlvH
         beNVZ882YYSAxgBjMvqRYQ62HgoMLlqpt+8+kQl6gjXbO/GoTEiXaABfHjnMTXpnIHaj
         YPLBt4LGh1aSw6WjrLdpdMZ/7MefEZdGZgQiYq9wLNzfHzCj7ffhbRN7/HEt9Q3UZ8bu
         MGcw==
X-Forwarded-Encrypted: i=1; AJvYcCVZXAm86uQ98/0EcJygxaed2wrZzXum8MUAB4PepmeRdhA6ML7lLfNcKzy8g6cm1hA/WL5CzBOWMA==@kvack.org
X-Gm-Message-State: AOJu0Yxh+Owi5GMwMXbBIj5LPybraFocAn4qGGfeyJ6cbWhq5e9OWiFc
	Qa11KZ1oQueqfN7HgexY0dW2kgC2lgbQTeTmFc5ZZ8NQihYHSClvu6kfas3z0X4hKHo=
X-Gm-Gg: ASbGncvrzX6SqQ5CNqRvpQDAtTdJ3QPz+BsRLENt8w4zaCYiAQX1mQGYPP1iwwVbfFK
	72XQ319F8ddZRmwyQt0WR2R+EdkSXoXomcrnv35NP0wo2/3FYldCqBzHmcU8F0+BcSHuRuCDSmB
	Meb2LvoaLwdJeXhREwiKgFZZRggC5nqnU910tcVbNJyKfDto9x/TGkCGwvIlv3ySH3Q1URKT9se
	QlkO1SOoEpozqtqfeXnS0E723oh6LZbU+UgQvv8fezYgnir9Oo2oP3yXK+s9poUGXM1KPBDPD7a
	EN4gl+stBgZpsFMpKVGigYx6vFUg/YDvLQKr7651W8+DyVn5uYJMIfVl1maajvHHW8VBPPpDnre
	fNk7rvVLLf8wRt0qSmdp9F/OBg8i7gvegWQoZUFfcFSWIxLXIYIkbkYKUlbgdYT8/xfsUom5om5
	XbfzD0F6qNB5Y60EhDUQ==
X-Google-Smtp-Source: AGHT+IEzNLDCIUEBf9S5DRDPsrWxtgBORWz8LvfpibpwyTvuEl9/0gmUqA9ZfzRNolrGZ8uq0mC63A==
X-Received: by 2002:a05:620a:1a90:b0:84f:110c:b6e7 with SMTP id af79cd13be357-85adf7bb783mr2147257785a.6.1759107812795;
        Sun, 28 Sep 2025 18:03:32 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4db0c0fbe63sm64561521cf.23.2025.09.28.18.03.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Sep 2025 18:03:32 -0700 (PDT)
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
Subject: [PATCH v4 01/30] kho: allow to drive kho from within kernel
Date: Mon, 29 Sep 2025 01:02:52 +0000
Message-ID: <20250929010321.3462457-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
In-Reply-To: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D66841C0004
X-Stat-Signature: mzrsg4qgpkd8phsnspzb7aa5gzmizx5m
X-HE-Tag: 1759107813-269415
X-HE-Meta: U2FsdGVkX183GJxB74aAT9hruITfoaWOeZZRPrluIgRv+z96yu95WUWz5jVvWk6RqN54pkm0nEpohUgVwEFfQDnIrz6qvSaaw4lqbU6rLK3/kceW8xpSTEsm17TqhjFPyV6KUz0y147wspGnW68PdKxJLIKEcowwdYrQoBd5p4lDBuYq2EFAxync3THfE7UqudVPc+MMX1PdI19661OPBpBPFOvovP4fTNvDNDUC+zdKCV49JUlx1pPQNnhoQQo3M9NUeZHOVivowHqapskQngbDmcbJHqmrdS/KasRWJ1kKjtFuKJUoqXfYRkmN/9iBsMukmLO7C20JrYghHZHtm9UXTEksun6V2x4OHeXDICqvTOk1C4WTTt84HO0xMejY1yiI0l9bf8qlllgS0pnDwjuudIfpzHd0/kDBPKCVwu6Kf49GtIWG5D3YhvfOnnckpu3TutskCc4y4qONWUf4Q9Pml0X/E9sZMqWP+KpTxfImDuBxh6OFYuhTtOJodMfbLQoJfMPBzV/YSyvyCcrYbtQXmrw9VL4I4NqH0xi65OnRYyr8PltuMywTiwoxtnVq4v6uFY8eBPHUkTgbo66GZMCFru/QBK8bfW8umu0thos8eN4aQ3Xvrf4Lbj+Re63L2zpFkE/TYY4qjMm/hXHNHPAZIVuMJSuXhnDxda3BX2HEwU28VDzsQDINg9OS6rzfejjIw5aTCeFaQOoKfK8tPENHMdGGaznWIH71JyUiYPgmFCUcCJyshqdLx1FlbL1Om+KazhBTficEtZww7TecCmPaKREfgbGDbPbD+8eArpJon6aNeXa46QAWrJhwMVIY5CBkNHZybI7oLSlACXPpBrjl+WERuzYKhlQfFfJ1KaSSHrDdK9j7NOUx90SOBZfCsd5oqqq+Xps9QNL2Bxi8QwRy6ifTHshnpX5U6xa3fxia7fERg5MJjp01D5/7x9myL9kNDyhG7AgRHbtbXS3
 C4sKIqjI
 lugHjoW2dQF65s5o9GcNkUKT3hejLvaeZ4oW9/UW1IJD6v01gOb9sYzQCBJG9RBWqoQyJtZYnATlScsSa0781WU0QUnCV0xXEBajg6r07LmKj/N+kn44E6gKeYT1iLVvHc82MnFtVcAvNzoz6/blCbvzLIGC17mu2WvnWz/Zsj0+NSF4R9b6pdLtlTEksjUOlGuWpuOLpG1VbTMfNA9nuSCw+5aoNyscH2v5EapzPKyB1R3/ZSmJImrRrbBlSS9vjXY88fHKZtEvlAq9FsdwNN8eVvZwd0pveWZsOnV8MjtYrNqM3DCccLnQFMsN9rtRPtZ+XbFhvd7O9JWu5D4K/ToWbG+KTWAB43Mi8NkzkkDxb9OI/jHHDL5vb9LkBwRs7fJpO19kOwRoci83mafMoY19a7I+WXP7YQhPuTyPJB9Hi88vjxpahYp5quw==
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
index 25042c1d8d54..04d0108db98e 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -67,6 +67,10 @@ void kho_memory_init(void);
 
 void kho_populate(phys_addr_t fdt_phys, u64 fdt_len, phys_addr_t scratch_phys,
 		  u64 scratch_len);
+
+int kho_finalize(void);
+int kho_abort(void);
+
 #else
 static inline bool kho_is_enabled(void)
 {
@@ -139,6 +143,17 @@ static inline void kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
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
index 76f0940fb485..0ba5a2dbae28 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -1067,7 +1067,7 @@ static int kho_out_update_debugfs_fdt(void)
 	return err;
 }
 
-static int kho_abort(void)
+static int __kho_abort(void)
 {
 	int err;
 	unsigned long order;
@@ -1100,7 +1100,33 @@ static int kho_abort(void)
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
@@ -1149,6 +1175,32 @@ static int kho_finalize(void)
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
2.51.0.536.g15c5d4f767-goog


