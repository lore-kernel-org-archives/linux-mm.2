Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0709C87FD3
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 01:45:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F5F56B00A7; Wed,  6 Aug 2025 21:45:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CD096B00A8; Wed,  6 Aug 2025 21:45:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 795426B00A9; Wed,  6 Aug 2025 21:45:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 63ED06B00A7
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:45:11 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2FFE01367BD
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:11 +0000 (UTC)
X-FDA: 83748268422.18.7832CF5
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4DC5C180005
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=MZxfrnRd;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754531109; a=rsa-sha256;
	cv=none;
	b=Hu/5ro8EJsaMcdPxcV5S4Oji1lhWCTsfHcowjB2kDAioovFVodSodKHUZW1yG9Qt+8reaW
	8njB2rI1KqUmi5HfXaiU9EmQ+nkGzBxKXZi852thGkynr2rIVYi2d9FfMt3ibkh57ZqqYH
	LIQH94xX+VWfsV3fUe+l71R4drDffp0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=MZxfrnRd;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754531109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mp1vmIN6774rh53/eJBOc5kRP469D2TV1rphzED5Sxg=;
	b=chyW4s/xVZ7AL6J4wb3k+TFaw/oBrO/zVKGbv8zekZUzhDCkI5X849zDHCwWKeI2toQD9i
	Kctfn3D8OUMBcOopKZMaeXu9g0Dl3z42dcAik3pFe9sgO8z7cQ9YN3EE2Bn6dyql7zBPmd
	E8blLIcdhFQggUNoPLIbwr14ZcRFYyU=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-707365f4d47so5818906d6.1
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 18:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754531108; x=1755135908; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mp1vmIN6774rh53/eJBOc5kRP469D2TV1rphzED5Sxg=;
        b=MZxfrnRdd7KtLNAenqs6/F0qdpgWHm2ubHpYxDNYNmGNVucDQZgEeKh9LVyyBpHf+a
         c265zRfZQCum6+09M/Zp+DcQmeY+Zp2zRK0xi6YPgwn5jF25jfTR3zYwADifBrWbE5zX
         gXHmjj1XXgB937GCHW859v1Re0vWsIJY6EPoHR2UAGazbBg/n07AcoiCmil/EGOtHhkI
         CIxFlDBsM1e2AfIyg6CQg+QnKHHlgn3shYSU4hrOuX8DR08DFH8emifwRKvGfFlq1jrD
         UUc6n3keVw0IFFn43UU3YOiA5ZSz3sxKYAdgnMzQHF7f1fCUacHGERxXroqyGLH07s94
         FA3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754531108; x=1755135908;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mp1vmIN6774rh53/eJBOc5kRP469D2TV1rphzED5Sxg=;
        b=MD9tZ2xReHKh57WvgwzNEcEHgr78Bl9S0UogiusLPcfGI0GwOSoE+v9kfsh+9JdbHQ
         XHs6A2eazpj90eerfjhxacKbbd+uXGrP9jbK/wN9OJMj7t3+BresSoKqv0U9JvmMmyZr
         /vz93qqVLTQKWXuBGwmbDz0xd8/36QsYyYWB12PA2D9ZNsJ4ysKnkEw8iDkYumg3N7Ex
         K1wBC+MdhrIShixTKUxeXOkRjICNWJVuE/t2pTGh+1+Fku6W7TDUNJhqnM7unBL3JFCD
         4k0s3SyaMqiWkT34jyhiVkJQhq7U8uCTErdIhGDSlnCxdq5eiqNrtopaZkG+mHWYLGAj
         1YYA==
X-Forwarded-Encrypted: i=1; AJvYcCU1RJvKWiC6vameF5ql1t8Vx3cSJaNjZ8T9Yi4RyrJbd7J0G4v9iZhWFN1/9C4luT6MEt/xK4RqPA==@kvack.org
X-Gm-Message-State: AOJu0YxxzTi6TpL4VsMfKABlUfASkiZGOcmE8tJIiAFjz5RR4E8P19nR
	01OiMdKkqEeX1keUry9JRx7YnJL2YQFLjdxqIPWWBf6irPdOLGBp3kpX1hpjpKaD5BI=
X-Gm-Gg: ASbGncv0tsEZL+i9PXpVUb2QilDGxMwSFFG9UMLevuFgL6Sot65oCHagfOsUN8vLGzV
	rWcdQVs6Zb7kqUx7BQNxtKaxwcVNtM759suWaZzdJmX/zbrD0sqCz4No3JGe4V6EOtIOj5hmT+Z
	rgHN9OHPCBkblGZKHH0UwJdT1WhvW7TGMOlUX2ONVykc23r4G/6q5OpphHoQgNbdzjXx/ob4cfF
	75AP1X91bRooIY1y61eFPtFcbIl2PKwSN/BJa4xg0ITb2PeFqssHyXTyyXn/pJSj1z/Luybr4nj
	DKqBUaWloaY1W7hg5QFH2dolrHj42MgdrNxpMNu2yrExF2yP2F/YFB0d9UOn3po23thrO5MIrpp
	KZiuCWfpuvPv6nkmwyNgYYoHFh1VGT941EEG9qc2EyJNdMMtIKvJUQ7lgu1xciT+HGDCr0FJsgu
	nJ8T+6/hEMrskLU3fDqXEQTMI=
X-Google-Smtp-Source: AGHT+IHW6xOS8icaV4fCZErUgrfoJrCJf1Yssvt+ylUZS0UycAitGY8nEQwBLa80lBpJIc7l5fKEdg==
X-Received: by 2002:a05:6214:2422:b0:707:6409:d001 with SMTP id 6a1803df08f44-7098943a0camr29339416d6.21.1754531107741;
        Wed, 06 Aug 2025 18:45:07 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077cde5a01sm92969046d6.70.2025.08.06.18.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 18:45:07 -0700 (PDT)
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
Subject: [PATCH v3 14/30] liveupdate: luo_files: add infrastructure for FDs
Date: Thu,  7 Aug 2025 01:44:20 +0000
Message-ID: <20250807014442.3829950-15-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
In-Reply-To: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4DC5C180005
X-Stat-Signature: tkny3jti61hanp6ru8617muuh6p9ijx7
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754531109-158844
X-HE-Meta: U2FsdGVkX1+EGNe8jYbPYdqkj4uj6GbSCHlEBCHMvnEms0G8HRkyJ8Y8NF9zU61Rwarv7S0KgDh59gLgs1WmS0X2nlyLBPcmUE2m3DS8+n61s/q5tuTitWNVZOkubhUAcLx4JzxtuLzGp0SPFRP9YpCQZZpey5FwOBxDLu81gwfhUBmIIfv9y4XTMcBSnfrgdr1KdR0znt1vDDTxRb15BLQqcNJfNIu5DYd5rMdUh/ZrkkQT0MnJv2KdXNgzTt0cXLYs0or0gbFFWAinpC8yMt+7TzDer6plkSe4F2aEUFzNu9t4IM3bUErpiXaYh0eRT+GSwmRuN5eiV1IxH9Yojstv4ptPdTd2cLUAs6d6O1K40/jLF3WocceP1o3lPpXE6qzW3Qro1yzBMBjj9+fqBlp1dwToxxnbAGpvwqYX+oh8Jlqrw7HOoGVI3qVY3gLQMpEH2dL8UI8aBkz+TP0Kjfer0gEAkoCe2s+Y4jOTZbtmbnY4t83XIB35f5owNBe8xigkihFRl0QJHnmq9nPcYp+aSj6bR+iXMKqqES1QX7Am8oDbjbaKOwdea5q8Dj+y+bVP7KKZZReR4/sDYiOxueTrlIUuIzLD1IJ6CjGkdlaZX4uzRg6vXPoEzNM6QE8cG8djPluYwKUKP3Lyf9lF4/MqbncFWk4n038hId2Z/eeFnLHdfCV0/7fSe+JAG0bpEZ4aECzsC6PmczTgDHv1tMSX866IMUHo+9jWOKboyOzmTKyjLWwvWT620MHIDf2XNCG60ifuUaCBjAktqelZJpFR5k2Oqudwl34ZHuUBG6zHywybyIoM9US9HiwttA3p3l8XbOASsXCb0kFL9ZMYOeoT66g32ZGMEaN4BgviKMl6nZzXBuOgMhmSxu6/ECEc8tr+QUY4BsB/nzAIKYwS+g49K112/HU2ypsLxjRKafr50Ym3siZTf0wUmXQ/dIShsMvrLeHjZ7qkey8iP4t
 J/fYuW3R
 37V8Uwq9KcYmvS3E/mr5RZAJ/797U4YH6sZG68gzCYXnGt/MzHH8nISOuTlQ1S5FZCx/jfCDFnR0lJ3wxA/QFvIb7uJL0KWRZgOXf/8PqBECgPZGlnLNbpPbjyPR56QYgT0C/by/XaTagYLhY8Gnnd019aT1mTKsg7dyNKvUbEMptHGOpjAXafdU1u2g1qAOfSt1OTHRKUazgEgrOydLdWOFXAYgN2Y7ZY7m5dY0c1+4P/IZkDO3i5Mjn7rFOMsayRn/Hd7pg25Sl3f8EQFgOQjsyU18kKJn0yYCRR6Ald5QgfmEziJKsy8QZ0SNwndvDAgvVIe0NwWls2D7oHM76+THcb213/GBVeIhZqfI96vix0YRGE6TwpvZ+IiAat4oiKBJaVlQJVWVhDKyzCcTyoeu25616aasBG+xvWgfZBUj0aHWSVz8WGyHTvqGqejYumlbE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce the framework within LUO to support preserving specific types
of file descriptors across a live update transition. This allows
stateful FDs (like memfds or vfio FDs used by VMs) to be recreated in
the new kernel.

Note: The core logic for iterating through the luo_files_list and
invoking the handler callbacks (prepare, freeze, cancel, finish)
within luo_do_files_*_calls, as well as managing the u64 data
persistence via the FDT for individual files, is currently implemented
as stubs in this patch. This patch sets up the registration, FDT layout,
and retrieval framework.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/liveupdate.h       |  73 ++++
 kernel/liveupdate/Makefile       |   1 +
 kernel/liveupdate/luo_files.c    | 677 +++++++++++++++++++++++++++++++
 kernel/liveupdate/luo_internal.h |   4 +
 4 files changed, 755 insertions(+)
 create mode 100644 kernel/liveupdate/luo_files.c

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index 4c378a986cfe..72786482ca48 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -13,6 +13,66 @@
 #include <uapi/linux/liveupdate.h>
 
 struct liveupdate_subsystem;
+struct liveupdate_file_handler;
+struct file;
+
+/**
+ * struct liveupdate_file_ops - Callbacks for live-updatable files.
+ * @prepare:       Optional. Saves state for a specific file instance @file,
+ *                 before update, potentially returning value via @data.
+ *                 Returns 0 on success, negative errno on failure.
+ * @freeze:        Optional. Performs final actions just before kernel
+ *                 transition, potentially reading/updating the handle via
+ *                 @data.
+ *                 Returns 0 on success, negative errno on failure.
+ * @cancel:        Optional. Cleans up state/resources if update is aborted
+ *                 after prepare/freeze succeeded, using the @data handle (by
+ *                 value) from the successful prepare. Returns void.
+ * @finish:        Optional. Performs final cleanup in the new kernel using the
+ *                 preserved @data handle (by value). Returns void.
+ * @retrieve:      Retrieve the preserved file. Must be called before finish.
+ * @can_preserve:  callback to determine if @file can be preserved by this
+ *                 handler.
+ *                 Return bool (true if preservable, false otherwise).
+ * @owner:         Module reference
+ */
+struct liveupdate_file_ops {
+	int (*prepare)(struct liveupdate_file_handler *handler,
+		       struct file *file, u64 *data);
+	int (*freeze)(struct liveupdate_file_handler *handler,
+		      struct file *file, u64 *data);
+	void (*cancel)(struct liveupdate_file_handler *handler,
+		       struct file *file, u64 data);
+	void (*finish)(struct liveupdate_file_handler *handler,
+		       struct file *file, u64 data, bool reclaimed);
+	int (*retrieve)(struct liveupdate_file_handler *handler,
+			u64 data, struct file **file);
+	bool (*can_preserve)(struct liveupdate_file_handler *handler,
+			     struct file *file);
+	struct module *owner;
+};
+
+/**
+ * struct liveupdate_file_handler - Represents a handler for a live-updatable
+ * file type.
+ * @ops:           Callback functions
+ * @compatible:    The compatibility string (e.g., "memfd-v1", "vfiofd-v1")
+ *                 that uniquely identifies the file type this handler supports.
+ *                 This is matched against the compatible string associated with
+ *                 individual &struct liveupdate_file instances.
+ * @list:          used for linking this handler instance into a global list of
+ *                 registered file handlers.
+ *
+ * Modules that want to support live update for specific file types should
+ * register an instance of this structure. LUO uses this registration to
+ * determine if a given file can be preserved and to find the appropriate
+ * operations to manage its state across the update.
+ */
+struct liveupdate_file_handler {
+	const struct liveupdate_file_ops *ops;
+	const char *compatible;
+	struct list_head list;
+};
 
 /**
  * struct liveupdate_subsystem_ops - LUO events callback functions
@@ -83,6 +143,9 @@ int liveupdate_register_subsystem(struct liveupdate_subsystem *h);
 int liveupdate_unregister_subsystem(struct liveupdate_subsystem *h);
 int liveupdate_get_subsystem_data(struct liveupdate_subsystem *h, u64 *data);
 
+int liveupdate_register_file_handler(struct liveupdate_file_handler *h);
+int liveupdate_unregister_file_handler(struct liveupdate_file_handler *h);
+
 #else /* CONFIG_LIVEUPDATE */
 
 static inline int liveupdate_reboot(void)
@@ -126,5 +189,15 @@ static inline int liveupdate_get_subsystem_data(struct liveupdate_subsystem *h,
 	return -ENODATA;
 }
 
+static inline int liveupdate_register_file_handler(struct liveupdate_file_handler *h)
+{
+	return 0;
+}
+
+static inline int liveupdate_unregister_file_handler(struct liveupdate_file_handler *h)
+{
+	return 0;
+}
+
 #endif /* CONFIG_LIVEUPDATE */
 #endif /* _LINUX_LIVEUPDATE_H */
diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
index 47e9ad56675b..c67fa2797796 100644
--- a/kernel/liveupdate/Makefile
+++ b/kernel/liveupdate/Makefile
@@ -5,6 +5,7 @@
 
 luo-y :=								\
 		luo_core.o						\
+		luo_files.o						\
 		luo_ioctl.o						\
 		luo_subsystems.o
 
diff --git a/kernel/liveupdate/luo_files.c b/kernel/liveupdate/luo_files.c
new file mode 100644
index 000000000000..4b7568d0f0f0
--- /dev/null
+++ b/kernel/liveupdate/luo_files.c
@@ -0,0 +1,677 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+/**
+ * DOC: LUO file descriptors
+ *
+ * LUO provides the infrastructure necessary to preserve
+ * specific types of stateful file descriptors across a kernel live
+ * update transition. The primary goal is to allow workloads, such as virtual
+ * machines using vfio, memfd, or iommufd to retain access to their essential
+ * resources without interruption after the underlying kernel is  updated.
+ *
+ * The framework operates based on handler registration and instance tracking:
+ *
+ * 1. Handler Registration: Kernel modules responsible for specific file
+ * types (e.g., memfd, vfio) register a &struct liveupdate_file_handler
+ * handler. This handler contains callbacks
+ * (&liveupdate_file_handler.ops->prepare,
+ * &liveupdate_file_handler.ops->freeze,
+ * &liveupdate_file_handler.ops->finish, etc.) and a unique 'compatible' string
+ * identifying the file type. Registration occurs via
+ * liveupdate_register_file_handler().
+ *
+ * 2. File Instance Tracking: When a potentially preservable file needs to be
+ * managed for live update, the core LUO logic (luo_register_file()) finds a
+ * compatible registered handler using its
+ * &liveupdate_file_handler.ops->can_preserve callback. If found,  an internal
+ * &struct luo_file instance is created, assigned a unique u64 'token', and
+ * added to a list.
+ *
+ * 3. State Persistence (FDT): During the LUO prepare/freeze phases, the
+ * registered handler callbacks are invoked for each tracked file instance.
+ * These callbacks can generate a u64 data payload representing the minimal
+ * state needed for restoration. This payload, along with the handler's
+ * compatible string and the unique token, is stored in a dedicated
+ * '/file-descriptors' node within the main LUO FDT blob passed via
+ * Kexec Handover (KHO).
+ *
+ * 4. Restoration: In the new kernel, the LUO framework parses the incoming
+ * FDT to reconstruct the list of &struct luo_file instances. When the
+ * original owner requests the file, luo_retrieve_file() uses the corresponding
+ * handler's &liveupdate_file_handler.ops->retrieve callback, passing the
+ * persisted u64 data, to recreate or find the appropriate &struct file object.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/atomic.h>
+#include <linux/err.h>
+#include <linux/file.h>
+#include <linux/kexec_handover.h>
+#include <linux/libfdt.h>
+#include <linux/liveupdate.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/rwsem.h>
+#include <linux/sizes.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/xarray.h>
+#include "luo_internal.h"
+
+#define LUO_FILES_NODE_NAME	"file-descriptors"
+#define LUO_FILES_COMPATIBLE	"file-descriptors-v1"
+
+static DEFINE_XARRAY(luo_files_xa_in);
+static DEFINE_XARRAY(luo_files_xa_out);
+static bool luo_files_xa_in_recreated;
+
+/* Registered files. */
+static DECLARE_RWSEM(luo_register_file_list_rwsem);
+static LIST_HEAD(luo_register_file_list);
+
+static DECLARE_RWSEM(luo_file_fdt_rwsem);
+static void *luo_file_fdt_out;
+static void *luo_file_fdt_in;
+
+static size_t luo_file_fdt_out_size;
+
+static atomic64_t luo_files_count;
+
+/**
+ * struct luo_file - Represents a file descriptor instance preserved
+ * across live update.
+ * @fh:            Pointer to the &struct liveupdate_file_handler containing
+ *                 the implementation of prepare, freeze, cancel, and finish
+ *                 operations specific to this file's type.
+ * @file:          A pointer to the kernel's &struct file object representing
+ *                 the open file descriptor that is being preserved.
+ * @private_data:  Internal storage used by the live update core framework
+ *                 between phases.
+ * @reclaimed:     Flag indicating whether this preserved file descriptor has
+ *                 been successfully 'reclaimed' (e.g., requested via an ioctl)
+ *                 by user-space or the owning kernel subsystem in the new
+ *                 kernel after the live update.
+ * @state:         The current state of file descriptor, it is allowed to
+ *                 prepare, freeze, and finish FDs before the global state
+ *                 switch.
+ * @mutex:         Lock to protect FD state, and allow independently to change
+ *                 the FD state compared to global state.
+ *
+ * This structure holds the necessary callbacks and context for managing a
+ * specific open file descriptor throughout the different phases of a live
+ * update process. Instances of this structure are typically allocated,
+ * populated with file-specific details (&file, &arg, callbacks, compatibility
+ * string, token), and linked into a central list managed by the LUO. The
+ * private_data field is used internally by the core logic to store state
+ * between phases.
+ */
+struct luo_file {
+	struct liveupdate_file_handler *fh;
+	struct file *file;
+	u64 private_data;
+	bool reclaimed;
+	enum liveupdate_state state;
+	struct mutex mutex;
+};
+
+static void luo_files_recreate_luo_files_xa_in(void)
+{
+	const char *node_name, *fdt_compat_str;
+	struct liveupdate_file_handler *fh;
+	struct luo_file *luo_file;
+	const void *data_ptr;
+	int file_node_offset;
+	int ret = 0;
+
+	guard(rwsem_read)(&luo_file_fdt_rwsem);
+	if (luo_files_xa_in_recreated || !luo_file_fdt_in)
+		return;
+
+	/* Take write in order to guarantee that we re-create list once */
+	guard(rwsem_write)(&luo_register_file_list_rwsem);
+	if (luo_files_xa_in_recreated)
+		return;
+
+	fdt_for_each_subnode(file_node_offset, luo_file_fdt_in, 0) {
+		bool handler_found = false;
+		u64 token;
+
+		node_name = fdt_get_name(luo_file_fdt_in, file_node_offset,
+					 NULL);
+		if (!node_name) {
+			luo_restore_fail("FDT subnode at offset %d: Cannot get name\n",
+					 file_node_offset);
+		}
+
+		ret = kstrtou64(node_name, 0, &token);
+		if (ret < 0) {
+			luo_restore_fail("FDT node '%s': Failed to parse token\n",
+					 node_name);
+		}
+
+		if (xa_load(&luo_files_xa_in, token)) {
+			luo_restore_fail("Duplicate token %llu found in incoming FDT for file descriptors.\n",
+					 token);
+		}
+
+		fdt_compat_str = fdt_getprop(luo_file_fdt_in, file_node_offset,
+					     "compatible", NULL);
+		if (!fdt_compat_str) {
+			luo_restore_fail("FDT node '%s': Missing 'compatible' property\n",
+					 node_name);
+		}
+
+		data_ptr = fdt_getprop(luo_file_fdt_in, file_node_offset, "data",
+				       NULL);
+		if (!data_ptr) {
+			luo_restore_fail("Can't recover property 'data' for FDT node '%s'\n",
+					 node_name);
+		}
+
+		list_for_each_entry(fh, &luo_register_file_list, list) {
+			if (!strcmp(fh->compatible, fdt_compat_str)) {
+				handler_found = true;
+				break;
+			}
+		}
+
+		if (!handler_found) {
+			luo_restore_fail("FDT node '%s': No registered handler for compatible '%s'\n",
+					 node_name, fdt_compat_str);
+		}
+
+		luo_file = kmalloc(sizeof(*luo_file),
+				   GFP_KERNEL | __GFP_NOFAIL);
+		luo_file->fh = fh;
+		luo_file->file = NULL;
+		memcpy(&luo_file->private_data, data_ptr, sizeof(u64));
+		luo_file->reclaimed = false;
+		mutex_init(&luo_file->mutex);
+		luo_file->state = LIVEUPDATE_STATE_UPDATED;
+		ret = xa_err(xa_store(&luo_files_xa_in, token, luo_file,
+				      GFP_KERNEL | __GFP_NOFAIL));
+		if (ret < 0) {
+			luo_restore_fail("Failed to store luo_file for token %llu in XArray: %d\n",
+					 token, ret);
+		}
+	}
+	luo_files_xa_in_recreated = true;
+}
+
+static size_t luo_files_fdt_size(void)
+{
+	u64 num_files = atomic64_read(&luo_files_count);
+
+	/* Estimate a 1K overhead, + 128 bytes per file entry */
+	return PAGE_SIZE << get_order(SZ_1K + (num_files * 128));
+}
+
+static void luo_files_fdt_cleanup(void)
+{
+	WARN_ON_ONCE(kho_unpreserve_phys(__pa(luo_file_fdt_out),
+					 luo_file_fdt_out_size));
+
+	free_pages((unsigned long)luo_file_fdt_out,
+		   get_order(luo_file_fdt_out_size));
+
+	luo_file_fdt_out_size = 0;
+	luo_file_fdt_out = NULL;
+}
+
+static int luo_files_to_fdt(struct xarray *files_xa_out)
+{
+	const u64 zero_data = 0;
+	unsigned long token;
+	struct luo_file *h;
+	char token_str[19];
+	int ret = 0;
+
+	xa_for_each(files_xa_out, token, h) {
+		snprintf(token_str, sizeof(token_str), "%#0llx", (u64)token);
+
+		ret = fdt_begin_node(luo_file_fdt_out, token_str);
+		if (ret < 0)
+			break;
+
+		ret = fdt_property_string(luo_file_fdt_out, "compatible",
+					  h->fh->compatible);
+		if (ret < 0) {
+			fdt_end_node(luo_file_fdt_out);
+			break;
+		}
+
+		ret = fdt_property_u64(luo_file_fdt_out, "data", zero_data);
+		if (ret < 0) {
+			fdt_end_node(luo_file_fdt_out);
+			break;
+		}
+
+		ret = fdt_end_node(luo_file_fdt_out);
+		if (ret < 0)
+			break;
+	}
+
+	return ret;
+}
+
+static int luo_files_fdt_setup(void)
+{
+	int ret;
+
+	guard(rwsem_write)(&luo_file_fdt_rwsem);
+	luo_file_fdt_out_size = luo_files_fdt_size();
+	luo_file_fdt_out = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+						    get_order(luo_file_fdt_out_size));
+	if (!luo_file_fdt_out) {
+		pr_err("Failed to allocate FDT memory (%zu bytes)\n",
+		       luo_file_fdt_out_size);
+		luo_file_fdt_out_size = 0;
+		return -ENOMEM;
+	}
+
+	ret = kho_preserve_phys(__pa(luo_file_fdt_out), luo_file_fdt_out_size);
+	if (ret) {
+		pr_err("Failed to kho preserve FDT memory (%zu bytes)\n",
+		       luo_file_fdt_out_size);
+		luo_file_fdt_out_size = 0;
+		luo_file_fdt_out = NULL;
+		return ret;
+	}
+
+	ret = fdt_create(luo_file_fdt_out, luo_file_fdt_out_size);
+	if (ret < 0)
+		goto exit_cleanup;
+
+	ret = fdt_finish_reservemap(luo_file_fdt_out);
+	if (ret < 0)
+		goto exit_finish;
+
+	ret = fdt_begin_node(luo_file_fdt_out, LUO_FILES_NODE_NAME);
+	if (ret < 0)
+		goto exit_finish;
+
+	ret = fdt_property_string(luo_file_fdt_out, "compatible",
+				  LUO_FILES_COMPATIBLE);
+	if (ret < 0)
+		goto exit_end_node;
+
+	ret = luo_files_to_fdt(&luo_files_xa_out);
+	if (ret < 0)
+		goto exit_end_node;
+
+	ret = fdt_end_node(luo_file_fdt_out);
+	if (ret < 0)
+		goto exit_finish;
+
+	ret = fdt_finish(luo_file_fdt_out);
+	if (ret < 0)
+		goto exit_cleanup;
+
+	return 0;
+
+exit_end_node:
+	fdt_end_node(luo_file_fdt_out);
+exit_finish:
+	fdt_finish(luo_file_fdt_out);
+exit_cleanup:
+	pr_err("Failed to setup FDT: %s (ret %d)\n", fdt_strerror(ret), ret);
+	luo_files_fdt_cleanup();
+
+	return ret;
+}
+
+static int luo_files_prepare(struct liveupdate_subsystem *h, u64 *data)
+{
+	int ret;
+
+	ret = luo_files_fdt_setup();
+	if (ret)
+		return ret;
+
+	scoped_guard(rwsem_read, &luo_file_fdt_rwsem)
+		*data = __pa(luo_file_fdt_out);
+
+	return ret;
+}
+
+static int luo_files_freeze(struct liveupdate_subsystem *h, u64 *data)
+{
+	return 0;
+}
+
+static void luo_files_finish(struct liveupdate_subsystem *h, u64 data)
+{
+	luo_files_recreate_luo_files_xa_in();
+}
+
+static void luo_files_cancel(struct liveupdate_subsystem *h, u64 data)
+{
+}
+
+static void luo_files_boot(struct liveupdate_subsystem *h, u64 fdt_pa)
+{
+	int ret;
+
+	ret = fdt_node_check_compatible(__va(fdt_pa), 0,
+					LUO_FILES_COMPATIBLE);
+	if (ret) {
+		luo_restore_fail("FDT '%s' is incompatible with '%s' [%d]\n",
+				 LUO_FILES_NODE_NAME, LUO_FILES_COMPATIBLE,
+				 ret);
+	}
+	scoped_guard(rwsem_write, &luo_file_fdt_rwsem)
+		luo_file_fdt_in = __va(fdt_pa);
+}
+
+static const struct liveupdate_subsystem_ops luo_file_subsys_ops = {
+	.prepare = luo_files_prepare,
+	.freeze = luo_files_freeze,
+	.cancel = luo_files_cancel,
+	.boot = luo_files_boot,
+	.finish = luo_files_finish,
+	.owner = THIS_MODULE,
+};
+
+static struct liveupdate_subsystem luo_file_subsys = {
+	.ops = &luo_file_subsys_ops,
+	.name = LUO_FILES_NODE_NAME,
+};
+
+static int __init luo_files_startup(void)
+{
+	int ret;
+
+	if (!liveupdate_enabled())
+		return 0;
+
+	ret = liveupdate_register_subsystem(&luo_file_subsys);
+	if (ret) {
+		pr_warn("Failed to register luo_file subsystem [%d]\n", ret);
+		return ret;
+	}
+
+	return ret;
+}
+late_initcall(luo_files_startup);
+
+/**
+ * luo_register_file - Register a file descriptor for live update management.
+ * @token: Token value for this file descriptor.
+ * @fd: file descriptor to be preserved.
+ *
+ * Context: Must be called when LUO is in 'normal' state.
+ *
+ * Return: 0 on success. Negative errno on failure.
+ */
+int luo_register_file(u64 token, int fd)
+{
+	struct liveupdate_file_handler *fh;
+	struct luo_file *luo_file;
+	bool found = false;
+	int ret = -ENOENT;
+	struct file *file;
+
+	file = fget(fd);
+	if (!file) {
+		pr_err("Bad file descriptor\n");
+		return -EBADF;
+	}
+
+	luo_state_read_enter();
+	if (!liveupdate_state_normal() && !liveupdate_state_updated()) {
+		pr_warn("File can be registered only in normal or updated state\n");
+		luo_state_read_exit();
+		fput(file);
+		return -EBUSY;
+	}
+
+	guard(rwsem_read)(&luo_register_file_list_rwsem);
+	list_for_each_entry(fh, &luo_register_file_list, list) {
+		if (fh->ops->can_preserve(fh, file)) {
+			found = true;
+			break;
+		}
+	}
+
+	if (!found)
+		goto exit_unlock;
+
+	luo_file = kmalloc(sizeof(*luo_file), GFP_KERNEL);
+	if (!luo_file) {
+		ret = -ENOMEM;
+		goto exit_unlock;
+	}
+
+	luo_file->private_data = 0;
+	luo_file->reclaimed = false;
+
+	luo_file->file = file;
+	luo_file->fh = fh;
+	mutex_init(&luo_file->mutex);
+	luo_file->state = LIVEUPDATE_STATE_NORMAL;
+
+	if (xa_load(&luo_files_xa_out, token)) {
+		ret = -EEXIST;
+		pr_warn("Token %llu is already taken\n", token);
+		mutex_destroy(&luo_file->mutex);
+		kfree(luo_file);
+		goto exit_unlock;
+	}
+
+	ret = xa_err(xa_store(&luo_files_xa_out, token, luo_file,
+			      GFP_KERNEL));
+	if (ret < 0) {
+		pr_warn("Failed to store file for token %llu in XArray: %d\n",
+			token, ret);
+		mutex_destroy(&luo_file->mutex);
+		kfree(luo_file);
+		goto exit_unlock;
+	}
+	atomic64_inc(&luo_files_count);
+
+exit_unlock:
+	luo_state_read_exit();
+
+	if (ret)
+		fput(file);
+
+	return ret;
+}
+
+static int __luo_unregister_file(u64 token)
+{
+	struct luo_file *luo_file;
+
+	luo_file = xa_erase(&luo_files_xa_out, token);
+	if (!luo_file)
+		return -ENOENT;
+
+	fput(luo_file->file);
+	mutex_destroy(&luo_file->mutex);
+	kfree(luo_file);
+	atomic64_dec(&luo_files_count);
+
+	return 0;
+}
+
+/**
+ * luo_unregister_file - Unregister a file instance using its token.
+ * @token: The unique token of the file instance to unregister.
+ *
+ * Finds the &struct luo_file associated with the @token in the
+ * global list and removes it. This function *only* removes the entry from the
+ * list; it does *not* free the memory allocated for the &struct luo_file
+ * itself. The caller is responsible for freeing the structure after this
+ * function returns successfully.
+ *
+ * Context: Can be called when a preserved file descriptor is closed or
+ * no longer needs live update management.
+ *
+ * Return: 0 on success. Negative errno on failure.
+ */
+int luo_unregister_file(u64 token)
+{
+	int ret = 0;
+
+	luo_state_read_enter();
+	if (!liveupdate_state_normal() && !liveupdate_state_updated()) {
+		pr_warn("File can be unregistered only in normal or updates state\n");
+		luo_state_read_exit();
+		return -EBUSY;
+	}
+
+	ret = __luo_unregister_file(token);
+	if (ret) {
+		pr_warn("Failed to unregister: token %llu not found.\n",
+			token);
+	}
+	luo_state_read_exit();
+
+	return ret;
+}
+
+/**
+ * luo_retrieve_file - Find a registered file instance by its token.
+ * @token: The unique token of the file instance to retrieve.
+ * @filep: Output parameter. On success (return value 0), this will point
+ * to the retrieved "struct file".
+ *
+ * Searches the global list for a &struct luo_file matching the @token. Uses a
+ * read lock, allowing concurrent retrievals.
+ *
+ * Return: 0 on success. Negative errno on failure.
+ */
+int luo_retrieve_file(u64 token, struct file **filep)
+{
+	struct luo_file *luo_file;
+	int ret = 0;
+
+	luo_files_recreate_luo_files_xa_in();
+	luo_state_read_enter();
+	if (!liveupdate_state_updated()) {
+		pr_warn("File can be retrieved only in updated state\n");
+		luo_state_read_exit();
+		return -EBUSY;
+	}
+
+	luo_file = xa_load(&luo_files_xa_in, token);
+	if (luo_file && !luo_file->reclaimed) {
+		scoped_guard(mutex, &luo_file->mutex) {
+			if (!luo_file->reclaimed) {
+				luo_file->reclaimed = true;
+				ret = luo_file->fh->ops->retrieve(luo_file->fh,
+								  luo_file->private_data,
+								  filep);
+				if (!ret)
+					luo_file->file = *filep;
+			}
+		}
+	} else if (luo_file && luo_file->reclaimed) {
+		pr_err("The file descriptor for token %lld has already been retrieved\n",
+		       token);
+		ret = -EINVAL;
+	} else {
+		ret = -ENOENT;
+	}
+
+	luo_state_read_exit();
+
+	return ret;
+}
+
+/**
+ * liveupdate_register_file_handler - Register a file handler with LUO.
+ * @fh: Pointer to a caller-allocated &struct liveupdate_file_handler.
+ * The caller must initialize this structure, including a unique
+ * 'compatible' string and a valid 'fh' callbacks. This function adds the
+ * handler to the global list of supported file handlers.
+ *
+ * Context: Typically called during module initialization for file types that
+ * support live update preservation.
+ *
+ * Return: 0 on success. Negative errno on failure.
+ */
+int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
+{
+	struct liveupdate_file_handler *fh_iter;
+	int ret = 0;
+
+	luo_state_read_enter();
+	if (!liveupdate_state_normal() && !liveupdate_state_updated()) {
+		luo_state_read_exit();
+		return -EBUSY;
+	}
+
+	guard(rwsem_write)(&luo_register_file_list_rwsem);
+	list_for_each_entry(fh_iter, &luo_register_file_list, list) {
+		if (!strcmp(fh_iter->compatible, fh->compatible)) {
+			pr_err("File handler registration failed: Compatible string '%s' already registered.\n",
+			       fh->compatible);
+			ret = -EEXIST;
+			goto exit_unlock;
+		}
+	}
+
+	if (!try_module_get(fh->ops->owner)) {
+		pr_warn("File handler '%s' unable to get reference.\n",
+			fh->compatible);
+		ret = -EAGAIN;
+		goto exit_unlock;
+	}
+
+	INIT_LIST_HEAD(&fh->list);
+	list_add_tail(&fh->list, &luo_register_file_list);
+
+exit_unlock:
+	luo_state_read_exit();
+
+	return ret;
+}
+
+/**
+ * liveupdate_unregister_file - Unregister a file handler.
+ * @fh: Pointer to the specific &struct liveupdate_file_handler instance
+ * that was previously returned by or passed to
+ * liveupdate_register_file_handler.
+ *
+ * Removes the specified handler instance @fh from the global list of
+ * registered file handlers. This function only removes the entry from the
+ * list; it does not free the memory associated with @fh itself. The caller
+ * is responsible for freeing the structure memory after this function returns
+ * successfully.
+ *
+ * Return: 0 on success. Negative errno on failure.
+ */
+int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
+{
+	unsigned long token;
+	struct luo_file *h;
+	int ret = 0;
+
+	luo_state_read_enter();
+	if (!liveupdate_state_normal() && !liveupdate_state_updated()) {
+		luo_state_read_exit();
+		return -EBUSY;
+	}
+
+	guard(rwsem_write)(&luo_register_file_list_rwsem);
+
+	xa_for_each(&luo_files_xa_out, token, h) {
+		if (h->fh == fh) {
+			luo_state_read_exit();
+			return -EBUSY;
+		}
+	}
+
+	list_del_init(&fh->list);
+	luo_state_read_exit();
+	module_put(fh->ops->owner);
+
+	return ret;
+}
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 40bfbe279d34..5692196fd425 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -34,4 +34,8 @@ int luo_do_subsystems_freeze_calls(void);
 void luo_do_subsystems_finish_calls(void);
 void luo_do_subsystems_cancel_calls(void);
 
+int luo_retrieve_file(u64 token, struct file **filep);
+int luo_register_file(u64 token, int fd);
+int luo_unregister_file(u64 token);
+
 #endif /* _LINUX_LUO_INTERNAL_H */
-- 
2.50.1.565.gc32cd1483b-goog


