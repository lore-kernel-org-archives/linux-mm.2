Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33515CAC5B5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 01:04:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B67D8E0011; Sun, 28 Sep 2025 21:03:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07ABC8E000F; Sun, 28 Sep 2025 21:03:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E10338E0011; Sun, 28 Sep 2025 21:03:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C46BA8E000F
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 21:03:47 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8DE7AB74E5
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:03:47 +0000 (UTC)
X-FDA: 83940490494.29.E9771C3
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id C42FC20002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:03:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=TlrfNBph;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759107825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JRKEwXa1tg/M6bNaqOfoeFXrUpvvgwejj9DdMRFtL4w=;
	b=DMuJLksvgqi3G+4QXin6ZViZtGea15tlvDIwdN7RuLg5ggtzv2VwY1OdwCUmGzPO5QauMk
	nLTJ+nb+ToAYnOyIiODppcMA4F8EZZ8IezfjxTV7n6/yQ/nmLDlGtOKQOKwGDK2kruoHPx
	Z2Y3W/gc33ZzL+9+ACtzi2FuhrKIvVU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=TlrfNBph;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759107825; a=rsa-sha256;
	cv=none;
	b=dqxm0N56B+8bMVbYw2mm4dgq/9FAYtvV6eKf1eQo7cEGOjDtehAVbRiNH1iGWBzNfE49Dd
	n4OmeraVWF5HBy8P/bhQfbhkpNvWLCZOdOdnXO/OLqyDOJy3r4O8nol6hosKFmlMsqeDLR
	ZWuLVYPI/tvxHCg+Kpp9yvqCWvbnRcM=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4d142e9903fso26838661cf.0
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 18:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759107825; x=1759712625; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JRKEwXa1tg/M6bNaqOfoeFXrUpvvgwejj9DdMRFtL4w=;
        b=TlrfNBph25JCLC9SGuoKOQWN5d6U6f0lflXmiD6Nip2jAGiD+KxYYn0Ru9JMFAlvrz
         H9lFQHwo0tf2CnJere8C1Tv7FHtuJm2sjm5HJ5a87Rgja/epNeNApfUrdbKRTYN9pyGg
         gzYIFim2Zdz3i/qjahaJPYtBl0WFOkgpjvdaYr8yCxE9LUVJ5QFEXFc9fZHkB2JE69hN
         MAkJnrpFRVTrV3i8tECcpG/d2tShSnFa6e1JNl7Xx6yn/QxcNfpBOX9Qhfzmuxen42yN
         fqPeXXXVuekQKfsHriIpwPNNkq+5hdjuo/8nhQeahk0Gd3++9hZfT8I5lZpCpVIrRwV1
         3fJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759107825; x=1759712625;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JRKEwXa1tg/M6bNaqOfoeFXrUpvvgwejj9DdMRFtL4w=;
        b=WpKkrQWwdp78/oF5w9M9T2VjrFnw3a6I2xFKZxTv8LTaAPha0XXFPpPa494BAthA4Z
         Zth9hKGpoGgUIpmSxvR+Ix05o/wr2Dhi6/sxxKq/OxryC+4r9lr7LlN5qpRUUxV0V1dh
         EGBUOeQeQHkgUYhz/TvTk0MRSevBP9qZZT/Ewejm/pa63k13cCjdeh9xSh+hDZ+b9ig/
         tMnufnUez8i5Q9/cWgpDCdWjIQu+4orGGG2TZxf301z3I1D+LjEmVWOcGwGfTSBq9sRV
         xV50BNYj35dgCUJJbn7WQuf6OGdF1xpQxStH5YBUW06WipDh5U5/LQpytdnLYIyqwPMc
         9jMg==
X-Forwarded-Encrypted: i=1; AJvYcCUpZNjXdHjVbfRll9UAUbFVq5mTWgSL5k3FCIwlq1AiS2u8tRJt/1kCCD8KGhDlEIcZAsMUy+Ojug==@kvack.org
X-Gm-Message-State: AOJu0YxmM7HMoqTNzI9zL72qG6oYAOUnUvh4M/jojwuxud9xRZZxv0uN
	g4qrAjbxiZqk5BPLgoaBKyQ3+Wfgq+LXSSSvLlSzWD/nVYuy5GwCGnySBx8L/qnrk9g=
X-Gm-Gg: ASbGncvavgCo1TR16hrGU+qJom7+01nLa++VwqjUFwO06k9V5UZcu7K7GFLSgU6sTin
	diD5BukK9ChLb/VL26M+IKNLboppCntbEI156KsBw2OaYyMcTyUTT22SJ2lhVdnh5pJjvvhKdEL
	mKZk6Kys8k3h0rrrL1CIuz8fLGZWoQN38ZKPkK0pn4lyk82TiBFT0OjMaH3B//6GNcETX4gor6/
	iYVB1Teh9a+yRoUiK8kjz9SNXKeL5IboJUSvHf2EEaLjfoVuwsQYoyu3vcr9VWb6FvdNuSmCHU3
	31ecDnap3X5MNxXEmC/+7KTqNj22Byc98YkV6YJAeqGO/o6JvNvyAOxWWfTIJXJagLEP2E4g51y
	EqdOK9nIn7HwCyhP5ZXqqY/P1ZyxDWUMJUIsg3GG4Y4WJNADhrS6JWXEKYItRDfl4CLOiJtLybj
	gHZU2HJegAiD1+lBJ3TA==
X-Google-Smtp-Source: AGHT+IEwhqe/BqmKvNuWGS3uf0Nm2/PuSwk/9IAcyGtlVKkcjZXQAFpVwNkxDeP2e7Bl4f/no/k03w==
X-Received: by 2002:ac8:7e86:0:b0:4d9:c572:f9b6 with SMTP id d75a77b69052e-4da4bbe418cmr172161361cf.55.1759107824543;
        Sun, 28 Sep 2025 18:03:44 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4db0c0fbe63sm64561521cf.23.2025.09.28.18.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Sep 2025 18:03:43 -0700 (PDT)
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
Subject: [PATCH v4 09/30] liveupdate: luo_subsystems: add subsystem registration
Date: Mon, 29 Sep 2025 01:03:00 +0000
Message-ID: <20250929010321.3462457-10-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
In-Reply-To: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C42FC20002
X-Stat-Signature: x3n494dnkpqayqzie7b8bq3mqoess49m
X-HE-Tag: 1759107825-429157
X-HE-Meta: U2FsdGVkX18WqPVM/3VES4aQr7PamkTpedb5CUhxEIHB5V0agxY441nh7cyighTduyJbeJt5j3DTbhMX0QttX2N8zWXhkAhDcFcJxAOoM96+EdFc+ctuHkSd7m7X46k35pZ9I+BzKUlpBvihSlT9YbHixaJMJePTyyrBp+HMTmfR9sGmbOP8EMK5hmKyVC0ixJJDPV5ArNDxNdE75Ma3GuKZYFl76sES4MCVzYEB8poIE4ib6yMXvvKdwz7lyiBGdUlpGhr3zA1zKc8titCki4Ma92WByNZ6p6hW32Kqq71bm+gIXgHL4lnJbqBCFMhPlxUpfvjVc710SpiSNk4i4+38cRrfQp0MD+vg9smG38gWcTRAJyrBMPU/py49MqGP+hw2e3ILmpCSAPgzDWGxAkym7dRkYY+mGljAD1RlAyZMxQs2W7HKVPaJqhA3V/OJdYDwpcXQ+H5rhXPWAfQSod9zQ5zF4Kex9tnpvaEnxjtSIrV4J+45XCD2LeYFQAgieSPAEE0DvHos02fwhqBgLR8AsHGcJKQ/SdDYVt3MsZ5/kDjDGRa+X3YpD1SE2ZnJEe1ta2qP16c41vUn7KdbblggPwIP9IFbxarZQbNFoQtdMQyY8DHTq9BO6ld7q+UhPIRolnSYUpzBO01FMlNABJTOEE8voJx88N+Pwhx4ClD/pHzI7z6MZ4LWoh9yby6WaKYQuVdd1ZxRL+qfjPMHfKC6OzQ2iZxOfrNWESDb5LhUKdaWBFW6HIVR+YcBle7P8KcOnlFUWcFLqdNa0NOlz3YEE+Ys9zu1xvxWpn+oyAQFRYNR1f7FlzmidDr4zykPFwzp9O0JBabEUmHwaEZ4QdRfrTOKbMqi1lFR1b+WtIduwBCKnlEgt2Z0q6qzMKJ7DylEKCRH2vtV6UfrRCgDQ5ZBtb7KJ1EX8L7lWG+3vzOmqKItTh5750M5kbOYv+AzwYeC94PfX/RE67cFe7o
 GcrL4COS
 qW/Q/KaqpcC5c09umy16yo2h1LTfYY4n2bFuRG/ptBPOXeCSn9tfFHBPF9PZnf6mOWupSOgnWsMirPa2Zl/N1NizVbfZFlJqYu18hSALuQ2K6LqoWg8FVuD/IIrPR/hNYuOd2mcwSQnFhntQCSvEWt04OTebHGR4FahV3Jn0iAaUCvS9Xk7rYCgp5zo7bqXCVSgXLLy2eHbYyneXsTqMByGaT1biq+Ce4RjvTOLx023n6oX2ImccBk9i4gPOIqCxYtxpaNQZg6qhoACYlIh5m6mBmOG+UKw4zPwQTIHaw+vrw4uRWR7PKl9ZzlcsPV09o59JciU0ZDJarf+MiCZYuOSWXcEFp57sh+yGJH2sS68Kg+mTIkfCuwoQMJVtFQTmoTehIp1raJNi01PnkdinAD6qeSUSzW25MdIEK8TG6ox7abWGboErwG4Qwh+6UKVx3vJwW
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
index d90cc3b4bf7b..2881bab0c6df 100644
--- a/kernel/liveupdate/Makefile
+++ b/kernel/liveupdate/Makefile
@@ -2,7 +2,8 @@
 
 luo-y :=								\
 		luo_core.o						\
-		luo_ioctl.o
+		luo_ioctl.o						\
+		luo_subsystems.o
 
 obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
 obj-$(CONFIG_KEXEC_HANDOVER_DEBUG)	+= kexec_handover_debug.o
diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index 10796481447a..92edaeaaad3e 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -130,6 +130,10 @@ static int luo_fdt_setup(void)
 	if (ret)
 		goto exit_free;
 
+	ret = luo_subsystems_fdt_setup(fdt_out);
+	if (ret)
+		goto exit_free;
+
 	ret = kho_add_subtree(LUO_KHO_ENTRY_NAME, fdt_out);
 	if (ret)
 		goto exit_free;
@@ -153,20 +157,30 @@ static void luo_fdt_destroy(void)
 
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
@@ -408,6 +422,7 @@ static int __init luo_startup(void)
 	}
 
 	__luo_set_state(LIVEUPDATE_STATE_UPDATED);
+	luo_subsystems_startup(luo_fdt_in);
 
 	return 0;
 }
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index c98842caa4a0..c62fbbb0790c 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -32,4 +32,11 @@ void *luo_contig_alloc_preserve(size_t size);
 void luo_contig_free_unpreserve(void *mem, size_t size);
 void luo_contig_free_restore(void *mem, size_t size);
 
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
2.51.0.536.g15c5d4f767-goog


