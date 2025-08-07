Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F30FDC87FD3
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 01:45:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BC946B00A4; Wed,  6 Aug 2025 21:45:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 746B76B00A5; Wed,  6 Aug 2025 21:45:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E7D96B00A6; Wed,  6 Aug 2025 21:45:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 43C796B00A4
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:45:08 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F2CE6140526
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:07 +0000 (UTC)
X-FDA: 83748268254.02.6657161
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1A9A4140008
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=kDcF4qsD;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754531106; a=rsa-sha256;
	cv=none;
	b=K96gQVOMr8cJDmR7xC0YgtxtJgy3UBFIBPUCke+HLBgxkqBom6c5PYpY6qCihVajF03qQL
	vhx2/B7iuB05+swHYUdqFe/Uv6n1O5Ngdd54ZWeXZuj5CWJm/o84zE+M+v3ZCwTDpPuOZl
	lqS2rDfSN4Y3g+7x4416Gx2Ln7LN2vU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=kDcF4qsD;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754531106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=POmsI4cKyi9S3VeBB0onB4St1mju1grpKYfRTV4Eix0=;
	b=vdw1+V1KPWzyy/RNEx4dnn+a+oqGTb8TIDulgqa6+BK3TX4d7ak4nW7OjlGZN9qgBVkzov
	rs8w+TIDkn+dZKJOMSibBzCbbvlc0X9v8Q9jpPSycJEygJele5NIpgOL0XThE/Wyj05yfF
	5b9cbr6oaaa5RhrHMN5hALoGPXbT0vU=
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-70884da4b55so6135206d6.3
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 18:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754531105; x=1755135905; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=POmsI4cKyi9S3VeBB0onB4St1mju1grpKYfRTV4Eix0=;
        b=kDcF4qsDtJ7m8Yjh79Ai6RcWBYbxtGgbVSzTBVdEdduaGzzmbWPiqiVpoLbtLtgQok
         OwvC5+Kt91gbgQYI/gpBGuy1MWGpnBOtUJP9jWjKwlCDfdc6cGIJEQwH6sNswpnDHf0M
         /+pYzZ71FRdy0fuxFrnvyBHq2iJE0uXeiHhND1nZlQj4ezMjFY3pwbR48dkIkgEdesrs
         m0d/rHoIZmriAniLNuVkpfQqgDtxCXf9361GIHt/ioHY8Pp7tiNzAryNleZtnLTCUw7u
         JNIXyWaeuEEKXdEYesk2PTgAhNYwMv2XAhd85J2yceK/c3xEX98uD193gCHGX89aWQLR
         BacQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754531105; x=1755135905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=POmsI4cKyi9S3VeBB0onB4St1mju1grpKYfRTV4Eix0=;
        b=s9qaML2Muj/sRnFkj2tEQuz2QxdunMR208e2ky8zh/CQCJrcp2v3UsaSQ23RpJxaM0
         zCfWacp/sz1+CralR+wFMELAVu6FH0s1aIdu8mrxxeXdfbv6lx8suKeK7UTVc/VxBQbh
         I3jGSUrIK6qsqL4/KjLdhm3eg7MghMLx/ywBc1Mf1R+J9cl+FU7FlkN7TkigPxiTsKIq
         uihHrqQFrx519orKQ+LYlNvdg71be5VfMs20M112ZBtcIqqO8vEvOyq2QYUaeIdghm+G
         892FvIfprKZEf4NOA5jgWvG1vxLinOF6Udf0tgJ1eBQYdNEM0t9XsO2Wn1mjRJwibMTY
         lwPg==
X-Forwarded-Encrypted: i=1; AJvYcCUkpXP2lhmbrdV8hBeUNDucOOCI3mz5Jbd9zxZ8dDNPoEZGPjk2+LlE3OO4fqlYFF1mcBfmtmERlQ==@kvack.org
X-Gm-Message-State: AOJu0YyxqPRtMhUOiA1XgFrxYEUdWCSvf8V8pZiv1N56YXRnWT9DAejz
	UIjB5hV70LV/ITchhb1TDiU89w/p1t5QMrerqhizq4DyM1syvQvwFggXcBjhdAPFzYQ=
X-Gm-Gg: ASbGncv9jg5VClaCiSuTBJwxPPX4lhjDNkLLiWL1J247QGW9nfFKpa4KcHqkQSD9R4I
	z1mtl2bhHJxOI084Xuo6gwKz0N0yyKt3w5E/HLJZc9ElUy4dcS5KsljrKwOldAoahvH4zwiV2AO
	2I6p4V03xy4xV8hCwQff6bqGoexdiPOd7aexhohnZwXJr1mAK8PJSFkm4dPKwFdidLArS0RmDKU
	/vlefUPBHccNdjvQe8w833lF7cLR1Zy05+xcC93hZSaM3WoymQkGTmMQqjiYxVqadMsqpo8IeWS
	ezlBrCNctEsRNFZEUyV4vRWkDldC4NUTUvO/sUD97MomfJs/WBwGEyc2f/7489aE/X0W+NVYbkc
	ZeskcjmITMNHZ2tJh8opQfv35yucmGj1R5saMXfhAWwN29E3KzxlS7+xi679cyGsNRu2ERajyg4
	aaZ5rR4E/n1airjwechSM/Aqk=
X-Google-Smtp-Source: AGHT+IEuCsnH/h0FE1lLlqyA7mXVLkxUqHzbw/Ube1ATJQ1Zxa9P26pU4dT/1eci+C5au6rvsXS+Ig==
X-Received: by 2002:a05:6214:d65:b0:709:5874:83b9 with SMTP id 6a1803df08f44-7097af93e9amr65378806d6.34.1754531104826;
        Wed, 06 Aug 2025 18:45:04 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077cde5a01sm92969046d6.70.2025.08.06.18.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 18:45:04 -0700 (PDT)
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
Subject: [PATCH v3 12/30] liveupdate: luo_subsystems: add subsystem registration
Date: Thu,  7 Aug 2025 01:44:18 +0000
Message-ID: <20250807014442.3829950-13-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
In-Reply-To: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1A9A4140008
X-Stat-Signature: mk5mq3ex4gugpnknbrnbamj8k4kbujrk
X-Rspam-User: 
X-HE-Tag: 1754531105-161107
X-HE-Meta: U2FsdGVkX1+cdaVsDRpKV7c5rNz8Wz4CPP2VQg1+PUWptRoI4SqWgUJMOUYJmam3xjeseQZSvB73W4MGGIqcbBvScBdsWfJnH2m5vSFSScwFwu8UX016hHlAAJ8kEO0eMLJq4GZOzy3T/4D4pYx44hKNpdCdlU7PMxUUee6V+Mx1H0M+wqSkqM92ionME1ciO7UEOuzKraL89nzFBa5y4rMOS1ST/wstzGJHnjYrpFB9OTwRJ7LIo8W54cOejRAuS0z9vFmoYfo5S4nnovM3WeHw2PdaOamTlltYDqZ62wE9OHYYzU3QatCBChtkt4K1hPNVTzb3Iavqb5MCcfYDnKqkKkpgvfo2IM3FqD5c4deI6S6JHs8tG8sZE23uWS3FXwlO0omm+PS+ROka/3U489MRZN+2fT2MovlHZUb4jh5XlUSzcUW6YG1F8l3aVbMuRBw/YFS6XecGpHseqq7XXu64PnASzGaGCH0JSxlqYcXI8nY5ktthpNvxlaMCw9Z0ipyC/bdWcGj2zL957UbWPdbKusFuF99pqNATxOq6mKosND8S+vAaDkWqCDJ0nIwahagW5q/NZbktPWgXKYsh5IaW2cct8RI6v6qNC6BqH5U9dwHn9gu6Vk5cGg8kNaM0mdoAn0ey6JLXJdOs2NabMdc2GFYfVGUEALJpIU4UBEkY8PQPviNdBABIPuPsIPb0hp7Dpeta+aozwWHheWFa3SldoL6hYQaLw7xR1QWAstSFyDWHhCbzncgeTjGIIIJN+l/7tPgwu0CvH+3qwfy1xN0SwyEAjHzS+C5Jz52qZ4TeI2xiEZL1d5AVktO3DAfqIv0DnPQwGRoywU74NwIwzfdgkaLiX8UFngN1ng3Ru3XqN9Kv50GJv6IJcdX4kbunJ4Rqm34Pp54KFJSVnZVatE2cQofLOhgEBUBYR7SZeTvBmA/nSxfhj6mr0H9gUYzMhImrWAKrPB60X5FrXUV
 AwFyQjvH
 gaAzWGkBcf5gCTcYJd3rjd3qmQGi/6c5+gS2/dN5Lwsb0gjVvf3i/DMwYH/ww6q9pcIg5+MuAFtwC/u8qOyxg9MNGHd5SaMwFOwPQJHJvRh7FPS6uRGfnhz1zouag0rFavOt4ntyIDP3c88LHQMnAyyaVokKJodQrY8j/M8sp2qCWQZOqB/OMNy1iOYmw/SOK4T1dfB1T/jULiI+bBGDuCKKiYaZjsNcgKWMB/tl71X6lK1FWD2nrds56xv43Wu30AghcDyMJEsW9zd2g49KpWkfvxY4t/jiGivkGgQ5apzhGRNxAGNqnatiKHKmNM4wm1u1XsOPU4e+wrJaC8dDuGKTJA4xVbwX/+LBsNqbld0TOZlI8O7xHLsFrkxYOERo+K2MBm7gk4Mi0xkiril4zG2QwIQZW7EWGVLVchGeAVAjYGHjtDHB+0fkL/14VaD5TS3ck
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce the framework for kernel subsystems (e.g., KVM, IOMMU, device
drivers) to register with LUO and participate in the live update process
via callbacks.

Subsystem Registration:
- Defines struct liveupdate_subsystem in linux/liveupdate.h,
  which subsystems use to provide their name and optional callbacks
  (prepare, freeze, cancel, finish). The callbacks accept
  a u64 *data intended for passing state/handles.
- Exports liveupdate_register_subsystem() and
  liveupdate_unregister_subsystem() API functions.
- Adds drivers/misc/liveupdate/luo_subsystems.c to manage a list
  of registered subsystems.
  Registration/unregistration is restricted to
  specific LUO states (NORMAL/UPDATED).

Callback Framework:
- The main luo_core.c state transition functions
  now delegate to new luo_do_subsystems_*_calls() functions
  defined in luo_subsystems.c.
- These new functions are intended to iterate through the registered
  subsystems and invoke their corresponding callbacks.

FDT Integration:
- Adds a /subsystems subnode within the main LUO FDT created in
  luo_core.c. This node has its own compatibility string
  (subsystems-v1).
- luo_subsystems_fdt_setup() populates this node by adding a
  property for each registered subsystem, using the subsystem's
  name.
  Currently, these properties are initialized with a placeholder
  u64 value (0).
- luo_subsystems_startup() is called from luo_core.c on boot to
  find and validate the /subsystems node in the FDT received via
  KHO.
- Adds a stub API function liveupdate_get_subsystem_data() intended
  for subsystems to retrieve their persisted u64 data from the FDT
      in the new kernel.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/liveupdate.h         |  66 +++++++
 kernel/liveupdate/Makefile         |   3 +-
 kernel/liveupdate/luo_core.c       |  19 +-
 kernel/liveupdate/luo_internal.h   |   7 +
 kernel/liveupdate/luo_subsystems.c | 291 +++++++++++++++++++++++++++++
 5 files changed, 383 insertions(+), 3 deletions(-)
 create mode 100644 kernel/liveupdate/luo_subsystems.c

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index 85a6828c95b0..4c378a986cfe 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -12,6 +12,52 @@
 #include <linux/list.h>
 #include <uapi/linux/liveupdate.h>
 
+struct liveupdate_subsystem;
+
+/**
+ * struct liveupdate_subsystem_ops - LUO events callback functions
+ * @prepare:      Optional. Called during LUO prepare phase. Should perform
+ *                preparatory actions and can store a u64 handle/state
+ *                via the 'data' pointer for use in later callbacks.
+ *                Return 0 on success, negative error code on failure.
+ * @freeze:       Optional. Called during LUO freeze event (before actual jump
+ *                to new kernel). Should perform final state saving actions and
+ *                can update the u64 handle/state via the 'data' pointer. Retur:
+ *                0 on success, negative error code on failure.
+ * @cancel:       Optional. Called if the live update process is canceled after
+ *                prepare (or freeze) was called. Receives the u64 data
+ *                set by prepare/freeze. Used for cleanup.
+ * @boot:         Optional. Call durng boot post live update. This callback is
+ *                done when subsystem register during live update.
+ * @finish:       Optional. Called after the live update is finished in the new
+ *                kernel.
+ *                Receives the u64 data set by prepare/freeze. Used for cleanup.
+ * @owner:        Module reference
+ */
+struct liveupdate_subsystem_ops {
+	int (*prepare)(struct liveupdate_subsystem *handle, u64 *data);
+	int (*freeze)(struct liveupdate_subsystem *handle, u64 *data);
+	void (*cancel)(struct liveupdate_subsystem *handle, u64 data);
+	void (*boot)(struct liveupdate_subsystem *handle, u64 data);
+	void (*finish)(struct liveupdate_subsystem *handle, u64 data);
+	struct module *owner;
+};
+
+/**
+ * struct liveupdate_subsystem - Represents a subsystem participating in LUO
+ * @ops:          Callback functions
+ * @name:         Unique name identifying the subsystem.
+ * @list:         List head used internally by LUO. Should not be modified by
+ *                caller after registration.
+ * @private_data: For LUO internal use, cached value of data field.
+ */
+struct liveupdate_subsystem {
+	const struct liveupdate_subsystem_ops *ops;
+	const char *name;
+	struct list_head list;
+	u64 private_data;
+};
+
 #ifdef CONFIG_LIVEUPDATE
 
 /* Return true if live update orchestrator is enabled */
@@ -33,6 +79,10 @@ bool liveupdate_state_normal(void);
 
 enum liveupdate_state liveupdate_get_state(void);
 
+int liveupdate_register_subsystem(struct liveupdate_subsystem *h);
+int liveupdate_unregister_subsystem(struct liveupdate_subsystem *h);
+int liveupdate_get_subsystem_data(struct liveupdate_subsystem *h, u64 *data);
+
 #else /* CONFIG_LIVEUPDATE */
 
 static inline int liveupdate_reboot(void)
@@ -60,5 +110,21 @@ static inline enum liveupdate_state liveupdate_get_state(void)
 	return LIVEUPDATE_STATE_NORMAL;
 }
 
+static inline int liveupdate_register_subsystem(struct liveupdate_subsystem *h)
+{
+	return 0;
+}
+
+static inline int liveupdate_unregister_subsystem(struct liveupdate_subsystem *h)
+{
+	return 0;
+}
+
+static inline int liveupdate_get_subsystem_data(struct liveupdate_subsystem *h,
+						u64 *data)
+{
+	return -ENODATA;
+}
+
 #endif /* CONFIG_LIVEUPDATE */
 #endif /* _LINUX_LIVEUPDATE_H */
diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
index 8627b7691943..47e9ad56675b 100644
--- a/kernel/liveupdate/Makefile
+++ b/kernel/liveupdate/Makefile
@@ -5,7 +5,8 @@
 
 luo-y :=								\
 		luo_core.o						\
-		luo_ioctl.o
+		luo_ioctl.o						\
+		luo_subsystems.o
 
 obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
 obj-$(CONFIG_KEXEC_HANDOVER_DEBUG)	+= kexec_handover_debug.o
diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index 951422e51dd3..64d53b31d6d8 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -130,6 +130,10 @@ static int luo_fdt_setup(void)
 	if (ret)
 		goto exit_free;
 
+	ret = luo_subsystems_fdt_setup(fdt_out);
+	if (ret)
+		goto exit_free;
+
 	ret = kho_preserve_phys(__pa(fdt_out), LUO_FDT_SIZE);
 	if (ret)
 		goto exit_free;
@@ -160,20 +164,30 @@ static void luo_fdt_destroy(void)
 
 static int luo_do_prepare_calls(void)
 {
-	return 0;
+	int ret;
+
+	ret = luo_do_subsystems_prepare_calls();
+
+	return ret;
 }
 
 static int luo_do_freeze_calls(void)
 {
-	return 0;
+	int ret;
+
+	ret = luo_do_subsystems_freeze_calls();
+
+	return ret;
 }
 
 static void luo_do_finish_calls(void)
 {
+	luo_do_subsystems_finish_calls();
 }
 
 static void luo_do_cancel_calls(void)
 {
+	luo_do_subsystems_cancel_calls();
 }
 
 static int __luo_prepare(void)
@@ -415,6 +429,7 @@ static int __init luo_startup(void)
 	}
 
 	__luo_set_state(LIVEUPDATE_STATE_UPDATED);
+	luo_subsystems_startup(luo_fdt_in);
 
 	return 0;
 }
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index b61c17b78830..40bfbe279d34 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -27,4 +27,11 @@ void luo_state_read_exit(void);
 
 const char *luo_current_state_str(void);
 
+void luo_subsystems_startup(void *fdt);
+int luo_subsystems_fdt_setup(void *fdt);
+int luo_do_subsystems_prepare_calls(void);
+int luo_do_subsystems_freeze_calls(void);
+void luo_do_subsystems_finish_calls(void);
+void luo_do_subsystems_cancel_calls(void);
+
 #endif /* _LINUX_LUO_INTERNAL_H */
diff --git a/kernel/liveupdate/luo_subsystems.c b/kernel/liveupdate/luo_subsystems.c
new file mode 100644
index 000000000000..69f00d5c000e
--- /dev/null
+++ b/kernel/liveupdate/luo_subsystems.c
@@ -0,0 +1,291 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+/**
+ * DOC: LUO Subsystems support
+ *
+ * Various kernel subsystems register with the Live Update Orchestrator to
+ * participate in the live update process. These subsystems are notified at
+ * different stages of the live update sequence, allowing them to serialize
+ * device state before the reboot and restore it afterwards. Examples include
+ * the device layer, interrupt controllers, KVM, IOMMU, and specific device
+ * drivers.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/err.h>
+#include <linux/libfdt.h>
+#include <linux/liveupdate.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/string.h>
+#include "luo_internal.h"
+
+#define LUO_SUBSYSTEMS_NODE_NAME	"subsystems"
+#define LUO_SUBSYSTEMS_COMPATIBLE	"subsystems-v1"
+
+static DEFINE_MUTEX(luo_subsystem_list_mutex);
+static LIST_HEAD(luo_subsystems_list);
+static void *luo_fdt_out;
+static void *luo_fdt_in;
+
+/**
+ * luo_subsystems_fdt_setup - Adds and populates the 'subsystems' node in the
+ * FDT.
+ * @fdt: Pointer to the LUO FDT blob.
+ *
+ * Add subsystems node and each subsystem to the LUO FDT blob.
+ *
+ * Returns: 0 on success, negative errno on failure.
+ */
+int luo_subsystems_fdt_setup(void *fdt)
+{
+	struct liveupdate_subsystem *subsystem;
+	const u64 zero_data = 0;
+	int ret, node_offset;
+
+	guard(mutex)(&luo_subsystem_list_mutex);
+	ret = fdt_add_subnode(fdt, 0, LUO_SUBSYSTEMS_NODE_NAME);
+	if (ret < 0)
+		goto exit_error;
+
+	node_offset = ret;
+	ret = fdt_setprop_string(fdt, node_offset, "compatible",
+				 LUO_SUBSYSTEMS_COMPATIBLE);
+	if (ret < 0)
+		goto exit_error;
+
+	list_for_each_entry(subsystem, &luo_subsystems_list, list) {
+		ret = fdt_setprop(fdt, node_offset, subsystem->name,
+				  &zero_data, sizeof(zero_data));
+		if (ret < 0)
+			goto exit_error;
+	}
+
+	luo_fdt_out = fdt;
+	return 0;
+exit_error:
+	pr_err("Failed to setup 'subsystems' node to FDT: %s\n",
+	       fdt_strerror(ret));
+	return -ENOSPC;
+}
+
+/**
+ * luo_subsystems_startup - Validates the LUO subsystems FDT node at startup.
+ * @fdt: Pointer to the LUO FDT blob passed from the previous kernel.
+ *
+ * This __init function checks the existence and validity of the '/subsystems'
+ * node in the FDT. This node is considered mandatory.
+ */
+void __init luo_subsystems_startup(void *fdt)
+{
+	int ret, node_offset;
+
+	guard(mutex)(&luo_subsystem_list_mutex);
+	node_offset = fdt_subnode_offset(fdt, 0, LUO_SUBSYSTEMS_NODE_NAME);
+	if (node_offset < 0)
+		luo_restore_fail("Failed to find /subsystems node\n");
+
+	ret = fdt_node_check_compatible(fdt, node_offset,
+					LUO_SUBSYSTEMS_COMPATIBLE);
+	if (ret) {
+		luo_restore_fail("FDT '%s' is incompatible with '%s' [%d]\n",
+				 LUO_SUBSYSTEMS_NODE_NAME,
+				 LUO_SUBSYSTEMS_COMPATIBLE, ret);
+	}
+	luo_fdt_in = fdt;
+}
+
+static int luo_get_subsystem_data(struct liveupdate_subsystem *h, u64 *data)
+{
+	return 0;
+}
+
+/**
+ * luo_do_subsystems_prepare_calls - Calls prepare callbacks and updates FDT
+ * if all prepares succeed. Handles cancellation on failure.
+ *
+ * Phase 1: Calls 'prepare' for all subsystems and stores results temporarily.
+ * If any 'prepare' fails, calls 'cancel' on previously prepared subsystems
+ * and returns the error.
+ * Phase 2: If all 'prepare' calls succeeded, writes the stored data to the FDT.
+ * If any FDT write fails, calls 'cancel' on *all* prepared subsystems and
+ * returns the FDT error.
+ *
+ * Returns: 0 on success. Negative errno on failure.
+ */
+int luo_do_subsystems_prepare_calls(void)
+{
+	return 0;
+}
+
+/**
+ * luo_do_subsystems_freeze_calls - Calls freeze callbacks and updates FDT
+ * if all freezes succeed. Handles cancellation on failure.
+ *
+ * Phase 1: Calls 'freeze' for all subsystems and stores results temporarily.
+ * If any 'freeze' fails, calls 'cancel' on previously called subsystems
+ * and returns the error.
+ * Phase 2: If all 'freeze' calls succeeded, writes the stored data to the FDT.
+ * If any FDT write fails, calls 'cancel' on *all* subsystems and
+ * returns the FDT error.
+ *
+ * Returns: 0 on success. Negative errno on failure.
+ */
+int luo_do_subsystems_freeze_calls(void)
+{
+	return 0;
+}
+
+/**
+ * luo_do_subsystems_finish_calls- Calls finish callbacks for all subsystems.
+ *
+ * This function is called at the end of live update cycle to do the final
+ * clean-up or housekeeping of the post-live update states.
+ */
+void luo_do_subsystems_finish_calls(void)
+{
+}
+
+/**
+ * luo_do_subsystems_cancel_calls - Calls cancel callbacks for all subsystems.
+ *
+ * This function is typically called when the live update process needs to be
+ * aborted externally, for example, after the prepare phase may have run but
+ * before actual reboot. It iterates through all registered subsystems and calls
+ * the 'cancel' callback for those that implement it and likely completed
+ * prepare.
+ */
+void luo_do_subsystems_cancel_calls(void)
+{
+}
+
+/**
+ * liveupdate_register_subsystem - Register a kernel subsystem handler with LUO
+ * @h: Pointer to the liveupdate_subsystem structure allocated and populated
+ * by the calling subsystem.
+ *
+ * Registers a subsystem handler that provides callbacks for different events
+ * of the live update cycle. Registration is typically done during the
+ * subsystem's module init or core initialization.
+ *
+ * Can only be called when LUO is in the NORMAL or UPDATED states.
+ * The provided name (@h->name) must be unique among registered subsystems.
+ *
+ * Return: 0 on success, negative error code otherwise.
+ */
+int liveupdate_register_subsystem(struct liveupdate_subsystem *h)
+{
+	struct liveupdate_subsystem *iter;
+	int ret = 0;
+
+	luo_state_read_enter();
+	if (!liveupdate_state_normal() && !liveupdate_state_updated()) {
+		luo_state_read_exit();
+		return -EBUSY;
+	}
+
+	guard(mutex)(&luo_subsystem_list_mutex);
+	list_for_each_entry(iter, &luo_subsystems_list, list) {
+		if (iter == h) {
+			pr_warn("Subsystem '%s' (%p) already registered.\n",
+				h->name, h);
+			ret = -EEXIST;
+			goto out_unlock;
+		}
+
+		if (!strcmp(iter->name, h->name)) {
+			pr_err("Subsystem with name '%s' already registered.\n",
+			       h->name);
+			ret = -EEXIST;
+			goto out_unlock;
+		}
+	}
+
+	if (!try_module_get(h->ops->owner)) {
+		pr_warn("Subsystem '%s' unable to get reference.\n", h->name);
+		ret = -EAGAIN;
+		goto out_unlock;
+	}
+
+	INIT_LIST_HEAD(&h->list);
+	list_add_tail(&h->list, &luo_subsystems_list);
+
+out_unlock:
+	/*
+	 * If we are booting during live update, and subsystem provided a boot
+	 * callback, do it now, since we know that subsystem has already
+	 * initialized.
+	 */
+	if (!ret && liveupdate_state_updated() && h->ops->boot) {
+		u64 data;
+
+		ret = luo_get_subsystem_data(h, &data);
+		if (!WARN_ON_ONCE(ret))
+			h->ops->boot(h, data);
+	}
+
+	luo_state_read_exit();
+
+	return ret;
+}
+
+/**
+ * liveupdate_unregister_subsystem - Unregister a kernel subsystem handler from
+ * LUO
+ * @h: Pointer to the same liveupdate_subsystem structure that was used during
+ * registration.
+ *
+ * Unregisters a previously registered subsystem handler. Typically called
+ * during module exit or subsystem teardown. LUO removes the structure from its
+ * internal list; the caller is responsible for any necessary memory cleanup
+ * of the structure itself.
+ *
+ * Return: 0 on success, negative error code otherwise.
+ * -EINVAL if h is NULL.
+ * -ENOENT if the specified handler @h is not found in the registration list.
+ * -EBUSY if LUO is not in the NORMAL state.
+ */
+int liveupdate_unregister_subsystem(struct liveupdate_subsystem *h)
+{
+	struct liveupdate_subsystem *iter;
+	bool found = false;
+	int ret = 0;
+
+	luo_state_read_enter();
+	if (!liveupdate_state_normal() && !liveupdate_state_updated()) {
+		luo_state_read_exit();
+		return -EBUSY;
+	}
+
+	guard(mutex)(&luo_subsystem_list_mutex);
+	list_for_each_entry(iter, &luo_subsystems_list, list) {
+		if (iter == h) {
+			found = true;
+			break;
+		}
+	}
+
+	if (found) {
+		list_del_init(&h->list);
+	} else {
+		pr_warn("Subsystem handler '%s' not found for unregistration.\n",
+			h->name);
+		ret = -ENOENT;
+	}
+
+	module_put(h->ops->owner);
+	luo_state_read_exit();
+
+	return ret;
+}
+
+int liveupdate_get_subsystem_data(struct liveupdate_subsystem *h, u64 *data)
+{
+	return 0;
+}
-- 
2.50.1.565.gc32cd1483b-goog


