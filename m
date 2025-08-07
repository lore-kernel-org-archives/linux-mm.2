Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56DC7C87FCB
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 01:45:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 154CA6B00AD; Wed,  6 Aug 2025 21:45:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1058A6B00AE; Wed,  6 Aug 2025 21:45:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE7996B00AF; Wed,  6 Aug 2025 21:45:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D9B076B00AD
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:45:16 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B6C62BB98D
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:16 +0000 (UTC)
X-FDA: 83748268632.30.B24DF6F
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf28.hostedemail.com (Postfix) with ESMTP id EDAFEC0007
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=We3AyZ2z;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754531115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8hwgDrFusb37owy5fF2KCZv/M9EocMOsOhnKlUYr6eI=;
	b=hGRFq/55AvICHMPF9Ls73qwrZDe3VX/9rXUKJ7EHvWfl7JXbA30jbnFtiTX2w2N2N+Do1B
	i/Fn7t4xSdilYOL0gzY9EoKqSZErBgvpoxpkHaOzvQ1Qqe5t9Oggn+GTLaLoaMEb5RfSlY
	jGvCP0tS/feDlPUfNy6jEYn0pstelrg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754531115; a=rsa-sha256;
	cv=none;
	b=549TYsfJjnIDvN+pBuZMClEVTI9V7DqSeYc901zCzUlhxGNbUje4a8NtZi37IgJ5Y17bwm
	tJ2YYycDPaqaf/figsivc4FxQ5kA1743nUaViRzk/x6TSjtcH0mPmcu85iJYTUIS8iEKSW
	l5Vi7gb4ogz+qzdhY/YCMgnXxRzFXLk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=We3AyZ2z;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4af14096b9eso7600271cf.3
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 18:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754531114; x=1755135914; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8hwgDrFusb37owy5fF2KCZv/M9EocMOsOhnKlUYr6eI=;
        b=We3AyZ2znv8EWHxjX+9JJt1PMU1BsBC4JkEe4GqYGT0BjvSvq+iM7G5ptFc5W0OA95
         EdWbZFgWA8y6MX1HVEH7Ma59sJucCgjV86r0d3xvTEBYduPARd1XSVCF6phuVIwGY3V6
         yF14Fv0aeE8yOv4h7zKknG5gtDVUHsU/kQyxvH7YZyBjWKy19YbcfLNh8CAI/zWMVEr3
         SZWCkaWrRFQu4ErXUKwggUIBhqpZvEBBtsC6IhqDHD5ZdD29QLvCqC3K/lXGrkYPzx/u
         FTYwLIkCOgS6Xgl/W/C4My6H4JziuWwFujmOnhCQJ35A2sXJ2WcJBFNgmgYRd9NEmCP3
         qXDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754531114; x=1755135914;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8hwgDrFusb37owy5fF2KCZv/M9EocMOsOhnKlUYr6eI=;
        b=rOGpWBol3aFVcnE3jt2qsCnV/d5+VwgaGMaMD8sSCsjZgOJahbyBBnWVT700hNU7eW
         1EoTk62FZ5ZtfXbFs938VeZHJdNvOLGSIcCLDIwPydkQDHo1ItqVRC8RyaYaxJcGvJTf
         U2BoRSn0uF7XoDTJI5Ow11vxyKIFXjJwZqVL9JiQPt05TF98dT77LTYCyhuDQvVGd//8
         uHNDAlDuQEo7AJNGDcQtphUhtRdp2qFbHsY3oQQ5YaeEgtth4TXuASmANEonAJ50/8U2
         +QMGTvg35LvRmHjgZc9uiOvMO5bsPbbKEEvuwAMsEbzEgvysbpJ9b8HYGfHPS0NhUHiZ
         aLBg==
X-Forwarded-Encrypted: i=1; AJvYcCU4bpYwwCkMo9dMgKI1xsmxopnyJlWmovNGW8Qbr1tblLbPGEuqQd3Im3oQt18jHUV4kHolzUD+qA==@kvack.org
X-Gm-Message-State: AOJu0YwT9k7yP22u/j3oF1zXCmrLk/kn7sTbnTACL7In2QSDUlksC7Ip
	y3zS01BpfBVjj6+/DlZphafqV86an5mALzgA72wS0f4JPOrjEsoL6WgXyokX0y5d1fM=
X-Gm-Gg: ASbGncvSOEjO2srgx/37P8e2zhtANoE30zjt7poDrQY08NhLxTeL9ujUn91Hu5nYwdt
	UWjXtof9EesH8450FHdSZUHNcYiElb4utPdv46FvSeFEsFsdybOaCINIxwAeSWCeCn4r1gQzYrY
	f7aTHxS10wCjrUrocUyN5X/uErnb+vcPKaDkidERNatJpy0+XDYFV60i1rm2ZbOFQrhN+TUCrGW
	8ktOaGzrD4rcFhG2LHFOYRvDU+i+qsNPh03o+unxdKCcNhAZVJ6GBj/29YdKzjVrttQxxt16QgW
	rBFSqILwo72vTfoALbrLPd5xHmJ+nnVeo3bC3AU3LF1r0dKhGC4Kj+5ktn1Z2/dAWOs5y0IsBaB
	zgRV9QZfV1kcGVTm7kvAsPsOvf4Ap4qBMI6IPm8Z7XAIglFDHkmZSgkYR1U79b3oq+CgpXZfPA8
	77mlqgKcyjgXiF
X-Google-Smtp-Source: AGHT+IH4YzyGG4XPLy7NZ5fSOZd1AAebDYYOaRO7tsFemVfq331RBpfgGYjTHTH3NPqkKUhiEWNpgA==
X-Received: by 2002:a05:622a:1211:b0:4b0:6965:dd97 with SMTP id d75a77b69052e-4b0915b344bmr63492861cf.44.1754531113855;
        Wed, 06 Aug 2025 18:45:13 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077cde5a01sm92969046d6.70.2025.08.06.18.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 18:45:13 -0700 (PDT)
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
Subject: [PATCH v3 18/30] liveupdate: luo_files: luo_ioctl: Add ioctls for per-file state management
Date: Thu,  7 Aug 2025 01:44:24 +0000
Message-ID: <20250807014442.3829950-19-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
In-Reply-To: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EDAFEC0007
X-Stat-Signature: sjy8mkrrj98tppskq3jypmq5scmu6mkc
X-Rspam-User: 
X-HE-Tag: 1754531114-846544
X-HE-Meta: U2FsdGVkX1+4156tI3os6wN2cyn8cnkwiqCMdinF0CCfJYzgT07T4L+bwY1zb0Ax7G7aILfXr70wcVZRWoNJ7gnEIAx1LJ6sApSBpWC2/2m4Y16Da0XcythUMNhJwQCRSZCiOC/faQ8mjTy4RX/cGKfxHX6yJYCsFWOWrxuN52nAAvNaRtpzprA1DnSkzHiTurGkaYW0S7QSFD8LiiIlTZ3lPZlHxz8fp1dFkoLvvgtvdmfcEddnGtIi12FfvpDT0h0Gz/5a9rfvPgPoQ7HDwzsAJFbALOUHkyPedsZrduZATFhcHdCFEWx1cwIloi+6vH5AtV0SNKYSLEIr78vTkBbBYk6ekhXgbM/WvGjKl+YlzR1iO9DViN7RlM7ohOzvqWqEBRRdjLVlszgdvNrM57MKsqjEQULrx/DXhcDihz40kWD1Gv+w3UgthRfifFUrrPBCYgrnWnH8XJN+7BCKth6ga7Gp9SFOYdNuaEyiBAfbWxFKS2EiL7oimnh/Rtt7BHcBG+OXM4/S2YOaUteZ4wYlniqQEVOCvu+FXngBd6ox54dZAmWh7kif7U7TXbkAoy7Q9mx2l0Tw14kzK88IE43D+IUyd1LiIW4fss96G9NOv+VQTPc5+PNvGC0yi1+IFM8genn3K8RI3+r9TgxYztNTWdR4JYiUbXivhMYJVgFglCBjjOU4D8W60qXhMCqfH9HrgA9f1aRh/JDF6OOZi6cWvHCpyYsKbKcBA9e6XBjulaS9KmUTKAgjFWPL7VgiHa6prQkwGD9EL8JUSVGOA5vxwohn0lV8E3LQaRqRpo8lWawUXGxrZPJfjxXlpSGnL2mUtqwg4UQdd9ePmLfVXmcIiAVY5/pQalhiYuVaxWmvLIaZ9E0E8i22ssW2DexubO8D59jOP3GbbQ35VZXLYDmhT5EnKBVWaZV3SyfHyx5N2jx1GzIO7+n5xbzXISmEhZntgbplM9m6BtVSQ0h
 vrGiKBo5
 3xdaUuuIm1Kx36zhXQEUZux8HFx2A9aOMxBu1lrzxpDWBJ3hr7FpqyzXrOl2cxw5zt3ngNkPYRLee3i6r559LSWA8HkQLcyBDIpR/aS0bleZJJfSYXRjfmaWBOLFhh4yObypawAolzNGIkivluuOFNi+Ir1Ap7zdn881VWemtjcembtVr4k71jCVFEDGSDmRMz43aKoN/9cB688v30q8glrAQv1Gg0sJ7+Hb4CXraABNz6aaIHspaodsBInjMmyA2AIu4DnEVdd7vJJISZStl+AuI1PpQ2zf5LQjFnb54xwiVcIfgaIpT7AgETVAwSn7Q3WxjHtKpkjOBsPM1EkDunYyrz0SiRqWO4Sh0lHuRoxr/lo/JnjT04cCy1sLifgO6Mb9N6ZfM/ijnqQ4EJ8O8aPmjH7pnOfmSnj61ozS18F5VDArL9iT1gJ25cn9ByJJsgzy/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a set of new ioctls to allow a userspace agent to query and
control the live update state of individual file descriptors that have
been registered for preservation.

Previously, state transitions (prepare, freeze, finish) were handled
globally for all registered resources by the main LUO state machine.
This patch provides a more granular interface, enabling a controlling
agent to manage the lifecycle of specific FDs independently, which is
useful for performance reasons.

-   Adds LIVEUPDATE_IOCTL_GET_FD_STATE to query the current state
    (e.g., NORMAL, PREPARED, FROZEN) of a file identified by its token.
-   Adds LIVEUPDATE_IOCTL_SET_FD_EVENT to trigger state transitions
    (PREPARE, FREEZE, CANCEL, FINISH) for a single file.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/uapi/linux/liveupdate.h  |  62 +++++++++++++
 kernel/liveupdate/luo_files.c    | 152 +++++++++++++++++++++++++++++++
 kernel/liveupdate/luo_internal.h |   8 ++
 kernel/liveupdate/luo_ioctl.c    |  48 ++++++++++
 4 files changed, 270 insertions(+)

diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
index 37ec5656443b..833da5a8c064 100644
--- a/include/uapi/linux/liveupdate.h
+++ b/include/uapi/linux/liveupdate.h
@@ -128,6 +128,8 @@ enum {
 	LIVEUPDATE_CMD_FD_RESTORE = 0x02,
 	LIVEUPDATE_CMD_GET_STATE = 0x03,
 	LIVEUPDATE_CMD_SET_EVENT = 0x04,
+	LIVEUPDATE_CMD_GET_FD_STATE = 0x05,
+	LIVEUPDATE_CMD_SET_FD_EVENT = 0x06,
 };
 
 /**
@@ -334,4 +336,64 @@ struct liveupdate_ioctl_set_event {
 #define LIVEUPDATE_IOCTL_SET_EVENT					\
 	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SET_EVENT)
 
+/**
+ * struct liveupdate_ioctl_get_fd_state - ioctl(LIVEUPDATE_IOCTL_GET_FD_STATE)
+ * @size:     Input; sizeof(struct liveupdate_ioctl_get_fd_state)
+ * @incoming: Input; If 1, query the state of a restored file from the incoming
+ *            (previous kernel's) set. If 0, query a file being prepared for
+ *            preservation in the current set.
+ * @token:    Input; Token of FD for which to get state.
+ * @state:    Output; The live update state of this FD.
+ *
+ * Query the current live update state of a specific preserved file descriptor.
+ *
+ * - %LIVEUPDATE_STATE_NORMAL:   Default state
+ * - %LIVEUPDATE_STATE_PREPARED: Prepare callback has been performed on this FD.
+ * - %LIVEUPDATE_STATE_FROZEN:   Freeze callback ahs been performed on this FD.
+ * - %LIVEUPDATE_STATE_UPDATED:  The system has successfully rebooted into the
+ *                               new kernel.
+ *
+ * See the definition of &enum liveupdate_state for more details on each state.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+struct liveupdate_ioctl_get_fd_state {
+	__u32		size;
+	__u8		incoming;
+	__aligned_u64	token;
+	__u32		state;
+};
+
+#define LIVEUPDATE_IOCTL_GET_FD_STATE					\
+	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_GET_FD_STATE)
+
+/**
+ * struct liveupdate_ioctl_set_fd_event - ioctl(LIVEUPDATE_IOCTL_SET_FD_EVENT)
+ * @size:  Input; sizeof(struct liveupdate_ioctl_set_fd_event)
+ * @event: Input; The live update event.
+ * @token: Input; Token of FD for which to set the provided event.
+ *
+ * Notify a specific preserved file descriptor of an event, that causes a state
+ * transition for that file descriptor.
+ *
+ * Event, can be one of the following:
+ *
+ * - %LIVEUPDATE_PREPARE: Initiates the FD live update preparation phase.
+ * - %LIVEUPDATE_FREEZE:  Initiates the FD live update freeze phase.
+ * - %LIVEUPDATE_CANCEL:  Cancel the FD preparation or freeze phase.
+ * - %LIVEUPDATE_FINISH:  FD Restoration completion and trigger cleanup.
+ *
+ * See the definition of &enum liveupdate_event for more details on each state.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+struct liveupdate_ioctl_set_fd_event {
+	__u32		size;
+	__u32		event;
+	__aligned_u64	token;
+};
+
+#define LIVEUPDATE_IOCTL_SET_FD_EVENT					\
+	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SET_FD_EVENT)
+
 #endif /* _UAPI_LIVEUPDATE_H */
diff --git a/kernel/liveupdate/luo_files.c b/kernel/liveupdate/luo_files.c
index 63f8b086b785..0d68d0c8c45e 100644
--- a/kernel/liveupdate/luo_files.c
+++ b/kernel/liveupdate/luo_files.c
@@ -740,6 +740,158 @@ void luo_unregister_all_files(void)
 	WARN_ON_ONCE(atomic64_read(&luo_files_count) != 0);
 }
 
+/**
+ * luo_file_get_state - Get the preservation state of a specific file.
+ * @token: The token of the file to query.
+ * @statep: Output pointer to store the file's current live update state.
+ * @incoming: If true, query the state of a restored file from the incoming
+ *            (previous kernel's) set. If false, query a file being prepared
+ *            for preservation in the current set.
+ *
+ * Finds the file associated with the given @token in either the incoming
+ * or outgoing tracking arrays and returns its current LUO state
+ * (NORMAL, PREPARED, FROZEN, UPDATED).
+ *
+ * Return: 0 on success, -ENOENT if the token is not found.
+ */
+int luo_file_get_state(u64 token, enum liveupdate_state *statep, bool incoming)
+{
+	struct luo_file *luo_file;
+	struct xarray *target_xa;
+	int ret = 0;
+
+	luo_state_read_enter();
+
+	target_xa = incoming ? &luo_files_xa_in : &luo_files_xa_out;
+	luo_file = xa_load(target_xa, token);
+
+	if (!luo_file) {
+		ret = -ENOENT;
+		goto out_unlock;
+	}
+
+	scoped_guard(mutex, &luo_file->mutex)
+		*statep = luo_file->state;
+
+out_unlock:
+	luo_state_read_exit();
+	return ret;
+}
+
+/**
+ * luo_file_prepare - Prepare a single registered file for live update.
+ * @token: The token of the file to prepare.
+ *
+ * Finds the file associated with @token and transitions it to the PREPARED
+ * state by invoking its handler's ->prepare() callback. This allows for
+ * granular, per-file preparation before the global LUO PREPARE event.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+int luo_file_prepare(u64 token)
+{
+	struct luo_file *luo_file;
+	int ret;
+
+	luo_state_read_enter();
+	luo_file = xa_load(&luo_files_xa_out, token);
+	if (!luo_file) {
+		ret = -ENOENT;
+		goto out_unlock;
+	}
+
+	ret = luo_files_prepare_one(luo_file);
+out_unlock:
+	luo_state_read_exit();
+	return ret;
+}
+
+/**
+ * luo_file_freeze - Freeze a single prepared file for live update.
+ * @token: The token of the file to freeze.
+ *
+ * Finds the file associated with @token and transitions it from the PREPARED
+ * to the FROZEN state by invoking its handler's ->freeze() callback. This is
+ * typically used for final, "blackout window" state saving for a specific
+ * file.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+int luo_file_freeze(u64 token)
+{
+	struct luo_file *luo_file;
+	int ret;
+
+	luo_state_read_enter();
+	luo_file = xa_load(&luo_files_xa_out, token);
+	if (!luo_file) {
+		ret = -ENOENT;
+		goto out_unlock;
+	}
+
+	ret = luo_files_freeze_one(luo_file);
+out_unlock:
+	luo_state_read_exit();
+	return ret;
+}
+
+int luo_file_cancel(u64 token)
+{
+	struct luo_file *luo_file;
+	int ret = 0;
+
+	luo_state_read_enter();
+	luo_file = xa_load(&luo_files_xa_out, token);
+	if (!luo_file) {
+		ret = -ENOENT;
+		goto out_unlock;
+	}
+
+	luo_files_cancel_one(luo_file);
+out_unlock:
+	luo_state_read_exit();
+	return ret;
+}
+
+/**
+ * luo_file_finish - Clean-up a single restored file after live update.
+ * @token: The token of the file to finalize.
+ *
+ * This function is called in the new kernel after a live update, typically
+ * after a file has been restored via luo_retrieve_file() and is no longer
+ * needed by the userspace agent in its preserved state. It invokes the
+ * handler's ->finish() callback, allowing for any final cleanup of the
+ * preserved state associated with this specific file.
+ *
+ * This must be called when LUO is in the UPDATED state.
+ *
+ * Return: 0 on success, -ENOENT if the token is not found, -EBUSY if not
+ *         in the UPDATED state.
+ */
+int luo_file_finish(u64 token)
+{
+	struct luo_file *luo_file;
+	int ret = 0;
+
+	luo_state_read_enter();
+	if (!liveupdate_state_updated()) {
+		pr_warn("finish can only be done in UPDATED state\n");
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
+	luo_file = xa_load(&luo_files_xa_in, token);
+	if (!luo_file) {
+		ret = -ENOENT;
+		goto out_unlock;
+	}
+
+	luo_files_finish_one(luo_file);
+out_unlock:
+	luo_state_read_exit();
+	return ret;
+}
+
 /**
  * luo_retrieve_file - Find a registered file instance by its token.
  * @token: The unique token of the file instance to retrieve.
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 189e032d7738..01bd0d3b023b 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -8,6 +8,8 @@
 #ifndef _LINUX_LUO_INTERNAL_H
 #define _LINUX_LUO_INTERNAL_H
 
+#include <uapi/linux/liveupdate.h>
+
 /*
  * Handles a deserialization failure: devices and memory is in unpredictable
  * state.
@@ -39,4 +41,10 @@ int luo_register_file(u64 token, int fd);
 int luo_unregister_file(u64 token);
 void luo_unregister_all_files(void);
 
+int luo_file_get_state(u64 token, enum liveupdate_state *statep, bool incoming);
+int luo_file_prepare(u64 token);
+int luo_file_freeze(u64 token);
+int luo_file_cancel(u64 token);
+int luo_file_finish(u64 token);
+
 #endif /* _LINUX_LUO_INTERNAL_H */
diff --git a/kernel/liveupdate/luo_ioctl.c b/kernel/liveupdate/luo_ioctl.c
index 7ca33d1c868f..4c0f6708e411 100644
--- a/kernel/liveupdate/luo_ioctl.c
+++ b/kernel/liveupdate/luo_ioctl.c
@@ -127,6 +127,48 @@ static int luo_ioctl_set_event(struct luo_ucmd *ucmd)
 	return ret;
 }
 
+static int luo_ioctl_get_fd_state(struct luo_ucmd *ucmd)
+{
+	struct liveupdate_ioctl_get_fd_state *argp = ucmd->cmd;
+	enum liveupdate_state state;
+	int ret;
+
+	ret = luo_file_get_state(argp->token, &state, !!argp->incoming);
+	if (ret)
+		return ret;
+
+	argp->state = state;
+	if (copy_to_user(ucmd->ubuffer, argp, ucmd->user_size))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int luo_ioctl_set_fd_event(struct luo_ucmd *ucmd)
+{
+	struct liveupdate_ioctl_set_fd_event *argp = ucmd->cmd;
+	int ret;
+
+	switch (argp->event) {
+	case LIVEUPDATE_PREPARE:
+		ret = luo_file_prepare(argp->token);
+		break;
+	case LIVEUPDATE_FREEZE:
+		ret = luo_file_freeze(argp->token);
+		break;
+	case LIVEUPDATE_FINISH:
+		ret = luo_file_finish(argp->token);
+		break;
+	case LIVEUPDATE_CANCEL:
+		ret = luo_file_cancel(argp->token);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
 static int luo_open(struct inode *inodep, struct file *filep)
 {
 	if (atomic_cmpxchg(&luo_device_in_use, 0, 1))
@@ -149,6 +191,8 @@ union ucmd_buffer {
 	struct liveupdate_ioctl_fd_restore	restore;
 	struct liveupdate_ioctl_get_state	state;
 	struct liveupdate_ioctl_set_event	event;
+	struct liveupdate_ioctl_get_fd_state	fd_state;
+	struct liveupdate_ioctl_set_fd_event	fd_event;
 };
 
 struct luo_ioctl_op {
@@ -179,6 +223,10 @@ static const struct luo_ioctl_op luo_ioctl_ops[] = {
 		 struct liveupdate_ioctl_get_state, state),
 	IOCTL_OP(LIVEUPDATE_IOCTL_SET_EVENT, luo_ioctl_set_event,
 		 struct liveupdate_ioctl_set_event, event),
+	IOCTL_OP(LIVEUPDATE_IOCTL_GET_FD_STATE, luo_ioctl_get_fd_state,
+		 struct liveupdate_ioctl_get_fd_state, token),
+	IOCTL_OP(LIVEUPDATE_IOCTL_SET_FD_EVENT, luo_ioctl_set_fd_event,
+		 struct liveupdate_ioctl_set_fd_event, token),
 };
 
 static long luo_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
-- 
2.50.1.565.gc32cd1483b-goog


