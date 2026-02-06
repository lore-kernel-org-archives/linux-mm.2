Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48E23EE6B48
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 19:13:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A52946B0092; Fri,  6 Feb 2026 14:13:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A093D6B0093; Fri,  6 Feb 2026 14:13:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8357B6B0096; Fri,  6 Feb 2026 14:13:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B1386B0092
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 14:13:12 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 228DA1402D3
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 19:13:12 +0000 (UTC)
X-FDA: 84414979824.23.DCC80F8
Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	by imf19.hostedemail.com (Postfix) with ESMTP id 409071A000A
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 19:13:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=dubeyko-com.20230601.gappssmtp.com header.s=20230601 header.b=ltlQZNjM;
	spf=pass (imf19.hostedemail.com: domain of slava@dubeyko.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=slava@dubeyko.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770405190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kl58u+sFBQ4YmsvUDIxZwjfmqlOJxFYb10cvJ3X1hxk=;
	b=5z5+SmTcvdB9Vym1XPRkOuML76VZCbqFVGaL7A0TYHYypc6/iPnTtyehGBxX7T7rQWdwkz
	to5LyUX/6VBlcora5Tslwxg/hqdL4mr+55/SX0HGiPdu2XjQqp6nBmbZMlfft1im+nqeG2
	4dZfPUnFxjpL+IUA3+1KoyyGJegMxj8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770405190; a=rsa-sha256;
	cv=none;
	b=xrZAqIoFq1tnP0PvKQwC2HiPxMxdbvAX9ebPH2pefG1HweKBzUDlBtf5V7STLdJ+bTAsIv
	XMUtTB1ilJhIbI064jycJk6U3sXOvU1s26OG2bGArYSDNqQAWtBMbVTHQ7I5P+En3UKZeB
	dQcSZehxUM0ypWLrtZ0cmLptxM7du/A=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=dubeyko-com.20230601.gappssmtp.com header.s=20230601 header.b=ltlQZNjM;
	spf=pass (imf19.hostedemail.com: domain of slava@dubeyko.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=slava@dubeyko.com;
	dmarc=none
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-649ea5e097bso2237925d50.1
        for <linux-mm@kvack.org>; Fri, 06 Feb 2026 11:13:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1770405189; x=1771009989; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kl58u+sFBQ4YmsvUDIxZwjfmqlOJxFYb10cvJ3X1hxk=;
        b=ltlQZNjMeC+IlGud83roFmArDmwIGH4uAwWrnE5uAKcIU0Yl86De2p25h1gLRw4h/7
         Q2x8wNvzNsneroObofa3tELd1qTMuisj4BVXQncbogPTx72WyWim41p46yj0GHGOirGD
         +f5QunFQ7/3f63J7UXEhBWi085yGYSkUi/6LcaXsXB/njfTajW3SC9JjKDq2WBb/vNZV
         pyR8QVbD1Rm17sX9BHd404G9yRLSPqU1PWwjTLUb70MN+phV0LK35/Y3EYHGUrefwU8N
         5zqeQM1r/SBp4rU4LbsW1QgH9QMcU/iDo3VcRaD81EQi1AgdkOGxZf5yHXExJ+Iv8rmI
         pkYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770405189; x=1771009989;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kl58u+sFBQ4YmsvUDIxZwjfmqlOJxFYb10cvJ3X1hxk=;
        b=JHgW0UjxNbC5rn0Rh7REC/IVr/5DxxPq+Yh607lP5F7y3Wc0KZGWgVBy66Am+d2hAx
         6brq1id40jWMxEjjj4QUQEp5c/izqRbGQ6+3RVcn+icHY4ehDs8iOqshESqtZ/Uf/5nV
         IkQqB7zNdux9+xWj/F8PJbCT+hJ1sSoOpcY7486ClzpnwqJD/Tb4S5gYyKkQZnwiW0I8
         xpIK4/hklhGKQgoxP2Ww600W+i4r58fP8bW0zb47wLXT43qqAHIDOWC7ekT/XL1ApM74
         Su6eNxwGqdKxfdK6zIeXAck8/bchxbQdKCIum38xgzkkK06zPT5V6Ff0tWRdEYOjRn9V
         bQPQ==
X-Forwarded-Encrypted: i=1; AJvYcCWKB2uzYiWtvv8sFIiXC0oUcH0o9+9OF8hsEZLtC3QJ74LSIJGhVg+PpuJcO/mOr+9Ul6GiAKR2EA==@kvack.org
X-Gm-Message-State: AOJu0YyHytHZNTPpPm+Fdir/RyzZRQg+L1bD4dWzajcwnDwShkFss7T7
	+l5EsDYNbPEg+J27jPv7i4jUkq2UVNcynHjfb9X6vvo7f8Yh27pb8UbXK/JtPjrMBJ4=
X-Gm-Gg: AZuq6aLr17omWMfJYhBpVxkDtBkxVpVVkivuJGNwzzHTPskcJnsZcaf3ZBRTW+XCGsm
	S9liZgOfjtjrZDk8k3zo37u6LTQbOUPZV5B2g4ITyQ5s9gDJgMIXsYigDCzMzTRRFqw7IypMAPd
	yNQYZu17SPaeJeAzOEgt7yYjyZ2Y5bLYcHxvL+wawocG7L8cg3Gh7h5jESpCRX9PUJ/LxxFKyXi
	3ZK3Q2M2XxO7d+Vj0TSTu3TPwveUifCevgYV+cHVsJNmx4fUtgGlyK6XIYVxOpyRPpJWu0DDo47
	imJPZMVZGlW2Yc//DgBNpEa0fCXfna9gE6fG6DQXmtDGuB54ESXTVb8U+WEQrIh2OV0ZR1kT4Xh
	bgzYlPbPCnm35z0WEXlskkwEY5DxfEzbLJwK4r/UU/sSh+/ir61XMfi7lyVNKdQP73ChPAmNvAO
	v6Dgdhnmezu9Ho0tp97iRsNG/dSIpZoVLv1yctwHNvumtMH0lFe5nCyRKUAZL2bK1biYzwV08R1
	tqHy+sFHG5tUVgM43Nn4fI=
X-Received: by 2002:a81:b813:0:b0:795:294c:fd3d with SMTP id 00721157ae682-7952ab55894mr57194667b3.50.1770405189073;
        Fri, 06 Feb 2026 11:13:09 -0800 (PST)
Received: from pop-os.attlocal.net ([2600:1700:6476:1430:9fc0:ed7d:72bd:ecd1])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7952a28697fsm29051277b3.50.2026.02.06.11.13.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Feb 2026 11:13:08 -0800 (PST)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org
Cc: Slava.Dubeyko@ibm.com,
	slava@dubeyko.com,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v1 1/4] ml-lib: Introduce Machine Learning (ML) library declarations
Date: Fri,  6 Feb 2026 11:11:33 -0800
Message-Id: <20260206191136.2609767-2-slava@dubeyko.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260206191136.2609767-1-slava@dubeyko.com>
References: <20260206191136.2609767-1-slava@dubeyko.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 409071A000A
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: dj84bnd5fwjop3pr85u7jez8w7yh8rmm
X-HE-Tag: 1770405190-51600
X-HE-Meta: U2FsdGVkX18Xd5Glm6NEQVtX9NH3msK4iG3+ArTx4H5onlNOjopYDOgu5N8Nc1UuWmQ8Gy4qyQetEZUK53LLzjep9LsRl6NtL8LKzHRdj+SfcjA4HJwOfX6wdeWN86NEPZr6hK0xEkcXAdVivNRXw8f8Q44RuHqZNYa/+q/xxkIUfhdOsZMQ4SnO0ksoaijZ2SlTOmIP3SR3ylIujGO8hgEec4iptlvCLJoaP/7mPbdfIh//PxFkO6HGS6IznvGj43AJgd0McK9XXoPG3Q27qfMfPs7KqiV7obJO5+F9v9UCsFea0gWenWHtCpAkNp+HqxY4Z3djpnk3OWVTFMY4h5pkzXl3Ng4+qpWtPETTVbCZE3cHmRa0qr5nhOmTcc7Rw6zqCKhdeZJtWRssN4skh3OIfxZnRBXkBADoLjUfi3IuF1CxWZKpEjHzGyaz2abMaHbQC+T/Je19IGlLhMxNyS4wb3QLIw49Za6/JrSx6wxhDYYbFbEyh3dXq3XPL3v4E8iz1u+ucP4KK+oUP/x5+1iYPx/OPawxlzIzZZ/8fjSKqN9gpvwmzhqID1opJRYOmmEnv7xlfsIniRejEJFsUfeqLWFkOZtu12L4o8SL/gdiyyAvjLsxDhdK29uqnj+dZOiE0ucEfK2frWdH2EbvQp86h16n8J5Sf0eiaUSsTm42l9uE6dhDRJVUoURdz4T89SrghDHqeF8KZM922vTiNg8FiVS40HEz7GbwSV5VzM/QCSvhoQW2xLp/k/ZhEbyf3lQGiR6NTIpzkVKfmXVGNID6izM/9x9Co0kxZQRrAWy7pwEI8zqRKZxuIBZZ/ukCXGPuafuEHne6ZYBrGsi9GjcSDVIbahgcWRfFVummtXyhbzSxf1KAE8/eqxVakm8SyP11EEiAx05XwvWU/ThcMOIMGqZvR2DjxvElH3I8+EDK9q+sS8GuajujPKCHtDJmBlAf7su9Et0XH7bkC2G
 juJCnGhQ
 Rg9w9jEZ4mL/24upZjHKBPJ+1LZASc22arRSNAL29lwbK0k/xU5a+4fc12SPvl/o4Y8spC3Ayejj8/4WaIsEIhK0PvffsC9GMDa3w1+U3paQ4vtwLZ1HmrpUpYIb4zEg07PdSr5rkaf9A1kS3VjOb77qyIhSnZ16NEGeVrPao2k4Pvqmdx6BOKHt2YBeQESiHeB9uJ8VVV1SxivLUahMgMseHvGtGi0fC80X2AR4zs+rApTxAfYLjkFPQ8vEEl/gLlTCmU4gWMkJl2I4orN7S2ritEDdKC0oySuLrvOB545JS7KKp4Htz7Ne6pgyoAOTfpzJ+20GLniYEtt4v3CGsgqtzTDevBB5zrgszSUHJJIxc14UZpu/VVw2XBlN0uqb5eMW9qlpZjk6Ec9TJzphbKvsCCUB2Ls+KVpgy05QLtSHv/m077NaE+7zj6pqn81fDffi5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Any kernel subsystem can be extended by one or several ML model(s).
ML model is represented by struct ml_lib_model that contains:
(1) ML model mode, (2) ML model state, (3) pointer on parent kernel
subsystem, (4) parent kernel subsystem state, (5) ML model options,
(6) current dataset, (7) ML model specialized operations,
(8) dataset specialized operations.

Any kernel subsystem can be in several modes that define
how this subsystem interacts with ML model in user-space:
(1) EMERGENCY_MODE - ignore ML model and run default algorithm(s),
(2) LEARNING_MODE - ML model is learning and any recommendations
requires of checking and errors back-propagation,
(3) COLLABORATION_MODE - ML model has good prediction but still
requires correction by default algorithm(s),
(4) RECOMMENDATION_MODE - ML model is capable to substitute
the default algorithm(s).

ML model can be: (1) created, (2) initialized, (3) started,
(4) running, (5) stopped, (6) shutted down.

The API of ML model includes:
(1) ml_model_create() - create ML model and initialize generic field
(2) ml_model_init() - execute specialized logic of ML model initialization
(3) ml_model_re_init() - execute specialized logic of ML model re-init
(4) ml_model_start() - start ML model activity
(5) ml_model_stop() - stop ML model activity
(6) ml_model_destroy() - destroy ML model and free all allocated memory
(7) get_system_state() - get current state of parent kernel subsystem
(8) ml_model_get_dataset() - prepare dataset for extraction by user-space agent
(9) ml_model_discard_dataset() - discard/obsolete dataset by user-space agent
(10) ml_model_preprocess_data() - preprocess data of current dataset
(11) ml_model_publish_data() - notify user-space agent about new dataset
(12) ml_model_preprocess_recommendation() - preprocess ML model recommendations
(13) estimate_system_state() - estimate parent kernel subsystem mode
(14) apply_ml_model_recommendation() - apply ML model recommendations
(15) execute_ml_model_operation() - execute logic following ML model mode
(16) estimate_ml_model_efficiency() - estimate ML model efficiency
(17) ml_model_error_backpropagation() - execute error backpropagation
(18) correct_system_state() - correct parent kernel subsystem mode

Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
---
 include/linux/ml-lib/ml_lib.h | 425 ++++++++++++++++++++++++++++++++++
 1 file changed, 425 insertions(+)
 create mode 100644 include/linux/ml-lib/ml_lib.h

diff --git a/include/linux/ml-lib/ml_lib.h b/include/linux/ml-lib/ml_lib.h
new file mode 100644
index 000000000000..001e781e0bf1
--- /dev/null
+++ b/include/linux/ml-lib/ml_lib.h
@@ -0,0 +1,425 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Machine Learning (ML) library
+ *
+ * Copyright (C) 2025-2026 Viacheslav Dubeyko <slava@dubeyko.com>
+ */
+
+#ifndef _LINUX_ML_LIB_H
+#define _LINUX_ML_LIB_H
+
+/*
+ * Any kernel subsystem can be in several modes
+ * that define how this subsystem interacts with
+ * ML model in user-space:
+ * (1) EMERGENCY_MODE - ignore ML model and run default algorithm(s).
+ * (2) LEARNING_MODE - ML model is learning and any recommendations
+ *                     requires of checking and errors back-propagation.
+ * (3) COLLABORATION_MODE - ML model has good prediction but still
+ *                          requires correction by default algorithm(s).
+ * (4) RECOMMENDATION_MODE - ML model is capable to substitute
+ *                           the default algorithm(s).
+ */
+enum ml_lib_system_mode {
+	ML_LIB_UNKNOWN_MODE,
+	ML_LIB_EMERGENCY_MODE,
+	ML_LIB_LEARNING_MODE,
+	ML_LIB_COLLABORATION_MODE,
+	ML_LIB_RECOMMENDATION_MODE,
+	ML_LIB_MODE_MAX
+};
+
+enum {
+	ML_LIB_UNKNOWN_MODEL_STATE,
+	ML_LIB_MODEL_CREATED,
+	ML_LIB_MODEL_INITIALIZED,
+	ML_LIB_MODEL_STARTED,
+	ML_LIB_MODEL_RUNNING,
+	ML_LIB_MODEL_STOPPED,
+	ML_LIB_MODEL_SHUTTING_DOWN,
+	ML_LIB_MODEL_STATE_MAX
+};
+
+struct ml_lib_model;
+
+#define ML_LIB_SLEEP_TIMEOUT_DEFAULT	(10)
+
+/*
+ * struct ml_lib_model_options - ML model global options
+ * @sleep_timeout: main thread's sleep timeout
+ *
+ * These options define behavior of ML model.
+ * The options can be defined during init() or re-init() call.
+ */
+struct ml_lib_model_options {
+	u32 sleep_timeout;
+};
+
+/*
+ * struct ml_lib_model_run_config - ML model run config
+ * @sleep_timeout: main thread's sleep timeout
+ *
+ * The run config is used for correction of ML model options
+ * by means of start/stop methods pair.
+ */
+struct ml_lib_model_run_config {
+	u32 sleep_timeout;
+};
+
+/*
+ * struct ml_lib_subsystem - kernel subsystem object
+ * @type: object type
+ * @size: number of bytes in allocated object
+ * @private: private data of subsystem
+ */
+struct ml_lib_subsystem {
+	atomic_t type;
+	size_t size;
+
+	void *private;
+};
+
+enum {
+	ML_LIB_UNKNOWN_SUBSYSTEM_TYPE,
+	ML_LIB_GENERIC_SUBSYSTEM,
+	ML_LIB_SPECIALIZED_SUBSYSTEM,
+	ML_LIB_SUBSYSTEM_TYPE_MAX
+};
+
+/*
+ * struct ml_lib_subsystem_state - shared kernel subsystem state
+ * @state: object state
+ * @size: number of bytes in allocated object
+ */
+struct ml_lib_subsystem_state {
+	atomic_t state;
+	size_t size;
+};
+
+enum {
+	ML_LIB_UNKNOWN_SUBSYSTEM_STATE,
+	ML_LIB_SUBSYSTEM_CREATED,
+	ML_LIB_SUBSYSTEM_INITIALIZED,
+	ML_LIB_SUBSYSTEM_STARTED,
+	ML_LIB_SUBSYSTEM_RUNNING,
+	ML_LIB_SUBSYSTEM_SHUTTING_DOWN,
+	ML_LIB_SUBSYSTEM_STOPPED,
+	ML_LIB_SUBSYSTEM_STATE_MAX
+};
+
+struct ml_lib_subsystem_state_operations {
+	void *(*allocate)(size_t size, gfp_t gfp);
+	void (*free)(struct ml_lib_subsystem_state *state);
+	int (*init)(struct ml_lib_subsystem_state *state);
+	int (*destroy)(struct ml_lib_subsystem_state *state);
+	int (*check_state)(struct ml_lib_subsystem_state *state);
+	struct ml_lib_subsystem_state *
+	    (*snapshot_state)(struct ml_lib_subsystem *object);
+	int (*estimate_system_state)(struct ml_lib_model *ml_model);
+	int (*correct_system_state)(struct ml_lib_model *ml_model);
+};
+
+/*
+ * struct ml_lib_dataset - exported subsystem's dataset
+ * @type: object type
+ * @state: object state
+ * @allocated_size: number of bytes in allocated object
+ * @portion_offset: portion offset in the data stream
+ * @portion_size: extracted portion size
+ */
+struct ml_lib_dataset {
+	atomic_t type;
+	atomic_t state;
+	size_t allocated_size;
+
+	u64 portion_offset;
+	u32 portion_size;
+};
+
+enum {
+	ML_LIB_UNKNOWN_DATASET_TYPE,
+	ML_LIB_EMPTY_DATASET,
+	ML_LIB_VALUE_DATASET,
+	ML_LIB_STRUCTURE_DATASET,
+	ML_LIB_MEMORY_STREAM_DATASET,
+	ML_LIB_DATASET_TYPE_MAX
+};
+
+enum {
+	ML_LIB_UNKNOWN_DATASET_STATE,
+	ML_LIB_DATASET_ALLOCATED,
+	ML_LIB_DATASET_CLEAN,
+	ML_LIB_DATASET_EXTRACTED_PARTIALLY,
+	ML_LIB_DATASET_EXTRACTED_COMPLETELY,
+	ML_LIB_DATASET_OBSOLETE,
+	ML_LIB_DATASET_EXTRACTION_FAILURE,
+	ML_LIB_DATASET_CORRUPTED,
+	ML_LIB_DATASET_STATE_MAX
+};
+
+struct ml_lib_dataset_operations {
+	void *(*allocate)(size_t size, gfp_t gfp);
+	void (*free)(struct ml_lib_dataset *dataset);
+	int (*init)(struct ml_lib_dataset *dataset);
+	int (*destroy)(struct ml_lib_dataset *dataset);
+	int (*extract)(struct ml_lib_model *ml_model,
+			struct ml_lib_dataset *dataset);
+	int (*preprocess_data)(struct ml_lib_model *ml_model,
+				struct ml_lib_dataset *dataset);
+	int (*publish_data)(struct ml_lib_model *ml_model,
+			    struct ml_lib_dataset *dataset);
+};
+
+/*
+ * struct ml_lib_request_config - dataset operation configuration
+ * @type: object type
+ * @state: object state
+ * @size: number of bytes in allocated object
+ */
+struct ml_lib_request_config {
+	atomic_t type;
+	atomic_t state;
+	size_t size;
+};
+
+enum {
+	ML_LIB_UNKNOWN_REQUEST_CONFIG_TYPE,
+	ML_LIB_EMPTY_REQUEST_CONFIG,
+	ML_LIB_REQUEST_CONFIG_TYPE_MAX
+};
+
+enum {
+	ML_LIB_UNKNOWN_REQUEST_CONFIG_STATE,
+	ML_LIB_REQUEST_CONFIG_ALLOCATED,
+	ML_LIB_REQUEST_CONFIG_INITIALIZED,
+	ML_LIB_REQUEST_CONFIG_STATE_MAX
+};
+
+struct ml_lib_request_config_operations {
+	void *(*allocate)(size_t size, gfp_t gfp);
+	void (*free)(struct ml_lib_request_config *config);
+	int (*init)(struct ml_lib_request_config *config);
+	int (*destroy)(struct ml_lib_request_config *config);
+};
+
+struct ml_lib_user_space_request {
+};
+
+struct ml_lib_user_space_request_operations {
+	int (*operation)(struct ml_lib_model *ml_model,
+			 struct ml_lib_user_space_request *request);
+};
+
+struct ml_lib_user_space_notification {
+};
+
+struct ml_lib_user_space_notification_operations {
+	int (*operation)(struct ml_lib_model *ml_model,
+			 struct ml_lib_user_space_notification *notify);
+};
+
+struct ml_lib_user_space_recommendation {
+};
+
+struct ml_lib_user_space_recommendation_operations {
+	int (*operation)(struct ml_lib_model *ml_model,
+			 struct ml_lib_user_space_recommendation *hint);
+};
+
+struct ml_lib_backpropagation_feedback {
+};
+
+struct ml_lib_backpropagation_operations {
+	int (*operation)(struct ml_lib_model *ml_model,
+			 struct ml_lib_user_space_recommendation *hint);
+};
+
+/*
+ * struct ml_lib_model_operations - ML model operations
+ * @create: specialized method of ML model creation
+ * @init: specialized method of ML model initialization
+ * @re_init: specialized method of ML model re-initialization
+ * @start: specialized method of ML model start
+ * @stop: specialized method of ML model stop
+ * @destroy: specialized method of ML model destroy
+ * @get_system_state: specialized method of getting subsystem state
+ * @get_dataset: specialized method of getting a dataset
+ * @preprocess_data: specialized method of data preprocessing
+ * @publish_data: specialized method of sharing data with user-space
+ * @preprocess_recommendation: specialized method of preprocess recomendations
+ * @estimate_system_state: specialized method of system state estimation
+ * @apply_recommendation: specialized method of recommendations applying
+ * @execute_operation: specialized method of operation execution
+ * @estimate_efficiency: specialized method of operation efficiency estimation
+ * @error_backpropagation: specialized method of error backpropagation
+ * @correct_system_state: specialized method of subsystem state correction
+ */
+struct ml_lib_model_operations {
+	int (*create)(struct ml_lib_model *ml_model);
+	int (*init)(struct ml_lib_model *ml_model,
+		    struct ml_lib_model_options *options);
+	int (*re_init)(struct ml_lib_model *ml_model,
+			struct ml_lib_model_options *options);
+	int (*start)(struct ml_lib_model *ml_model,
+		     struct ml_lib_model_run_config *config);
+	int (*stop)(struct ml_lib_model *ml_model);
+	void (*destroy)(struct ml_lib_model *ml_model);
+	struct ml_lib_subsystem_state *
+		(*get_system_state)(struct ml_lib_model *ml_model);
+	int (*get_dataset)(struct ml_lib_model *ml_model,
+			   struct ml_lib_dataset *dataset);
+	int (*preprocess_data)(struct ml_lib_model *ml_model,
+				struct ml_lib_dataset *dataset);
+	int (*publish_data)(struct ml_lib_model *ml_model,
+			    struct ml_lib_dataset *dataset,
+			    struct ml_lib_user_space_notification *notify);
+	int (*preprocess_recommendation)(struct ml_lib_model *ml_model,
+			    struct ml_lib_user_space_recommendation *hint);
+	int (*estimate_system_state)(struct ml_lib_model *ml_model);
+	int (*apply_recommendation)(struct ml_lib_model *ml_model,
+			    struct ml_lib_user_space_recommendation *hint);
+	int (*execute_operation)(struct ml_lib_model *ml_model,
+			    struct ml_lib_user_space_recommendation *hint,
+			    struct ml_lib_user_space_request *request);
+	int (*estimate_efficiency)(struct ml_lib_model *ml_model,
+			    struct ml_lib_user_space_recommendation *hint,
+			    struct ml_lib_user_space_request *request);
+	int (*error_backpropagation)(struct ml_lib_model *ml_model,
+			    struct ml_lib_backpropagation_feedback *feedback,
+			    struct ml_lib_user_space_notification *notify);
+	int (*correct_system_state)(struct ml_lib_model *ml_model);
+};
+
+/*
+ * struct ml_lib_model - ML model declaration
+ * @mode: ML model mode (enum ml_lib_system_mode)
+ * @state: ML model state
+ * @subsystem_name: name of susbsystem
+ * @model_name: name of the ML model
+ * @parent: parent kernel subsystem
+ * @parent_state: parent kernel subsystem's state
+ * @options: ML model options
+ * @model_ops: ML model specialized operations
+ * @system_state_ops: subsystem state specialized operations
+ * @dataset_ops: dataset specialized operations
+ * @request_config_ops: specialized dataset configuration operations
+ * @kobj: /sys/<subsystem>/<ml_model>/ ML model object
+ * @kobj_unregister: completion state for <ml_model> kernel object
+ */
+struct ml_lib_model {
+	atomic_t mode;
+	atomic_t state;
+	const char *subsystem_name;
+	const char *model_name;
+
+	struct ml_lib_subsystem *parent;
+
+	spinlock_t parent_state_lock;
+	struct ml_lib_subsystem_state * __rcu parent_state;
+
+	spinlock_t options_lock;
+	struct ml_lib_model_options * __rcu options;
+
+	spinlock_t dataset_lock;
+	struct ml_lib_dataset * __rcu dataset;
+
+	struct ml_lib_model_operations *model_ops;
+	struct ml_lib_subsystem_state_operations *system_state_ops;
+	struct ml_lib_dataset_operations *dataset_ops;
+	struct ml_lib_request_config_operations *request_config_ops;
+
+	/* /sys/<subsystem>/<ml_model>/ */
+	struct kobject kobj;
+	struct completion kobj_unregister;
+};
+
+/* ML library API */
+
+void *allocate_ml_model(size_t size, gfp_t gfp);
+void free_ml_model(struct ml_lib_model *ml_model);
+void *allocate_subsystem_object(size_t size, gfp_t gfp);
+void free_subsystem_object(struct ml_lib_subsystem *object);
+void *allocate_ml_model_options(size_t size, gfp_t gfp);
+void free_ml_model_options(struct ml_lib_model_options *options);
+void *allocate_subsystem_state(size_t size, gfp_t gfp);
+void free_subsystem_state(struct ml_lib_subsystem_state *state);
+void *allocate_dataset(size_t size, gfp_t gfp);
+void free_dataset(struct ml_lib_dataset *dataset);
+void *allocate_request_config(size_t size, gfp_t gfp);
+void free_request_config(struct ml_lib_request_config *config);
+
+int ml_model_create(struct ml_lib_model *ml_model,
+		    const char *subsystem_name,
+		    const char *model_name,
+		    struct kobject *subsystem_kobj);
+int ml_model_init(struct ml_lib_model *ml_model,
+		  struct ml_lib_model_options *options);
+int ml_model_re_init(struct ml_lib_model *ml_model,
+		     struct ml_lib_model_options *options);
+int ml_model_start(struct ml_lib_model *ml_model,
+		   struct ml_lib_model_run_config *config);
+int ml_model_stop(struct ml_lib_model *ml_model);
+void ml_model_destroy(struct ml_lib_model *ml_model);
+struct ml_lib_subsystem_state *get_system_state(struct ml_lib_model *ml_model);
+int ml_model_get_dataset(struct ml_lib_model *ml_model,
+			 struct ml_lib_request_config *config,
+			 struct ml_lib_user_space_request *request);
+int ml_model_discard_dataset(struct ml_lib_model *ml_model);
+int ml_model_preprocess_data(struct ml_lib_model *ml_model,
+			     struct ml_lib_dataset *dataset);
+int ml_model_publish_data(struct ml_lib_model *ml_model,
+			  struct ml_lib_dataset *dataset,
+			  struct ml_lib_user_space_notification *notify);
+int ml_model_preprocess_recommendation(struct ml_lib_model *ml_model,
+			 struct ml_lib_user_space_recommendation *hint);
+int estimate_system_state(struct ml_lib_model *ml_model);
+int apply_ml_model_recommendation(struct ml_lib_model *ml_model,
+			 struct ml_lib_user_space_recommendation *hint);
+int execute_ml_model_operation(struct ml_lib_model *ml_model,
+			 struct ml_lib_user_space_recommendation *hint,
+			 struct ml_lib_user_space_request *request);
+int estimate_ml_model_efficiency(struct ml_lib_model *ml_model,
+			 struct ml_lib_user_space_recommendation *hint,
+			 struct ml_lib_user_space_request *request);
+int ml_model_error_backpropagation(struct ml_lib_model *ml_model,
+			    struct ml_lib_backpropagation_feedback *feedback,
+			    struct ml_lib_user_space_notification *notify);
+int correct_system_state(struct ml_lib_model *ml_model);
+
+/* Generic implementation of ML model's methods */
+
+int generic_create_ml_model(struct ml_lib_model *ml_model);
+int generic_init_ml_model(struct ml_lib_model *ml_model,
+			  struct ml_lib_model_options *options);
+int generic_re_init_ml_model(struct ml_lib_model *ml_model,
+			     struct ml_lib_model_options *options);
+int generic_start_ml_model(struct ml_lib_model *ml_model,
+			   struct ml_lib_model_run_config *config);
+int generic_stop_ml_model(struct ml_lib_model *ml_model);
+void generic_destroy_ml_model(struct ml_lib_model *ml_model);
+struct ml_lib_subsystem_state *
+generic_get_system_state(struct ml_lib_model *ml_model);
+int generic_get_dataset(struct ml_lib_model *ml_model,
+			struct ml_lib_dataset *dataset);
+int generic_preprocess_data(struct ml_lib_model *ml_model,
+			    struct ml_lib_dataset *dataset);
+int generic_publish_data(struct ml_lib_model *ml_model,
+			 struct ml_lib_dataset *dataset,
+			 struct ml_lib_user_space_notification *notify);
+int generic_preprocess_recommendation(struct ml_lib_model *ml_model,
+			 struct ml_lib_user_space_recommendation *hint);
+int generic_estimate_system_state(struct ml_lib_model *ml_model);
+int generic_apply_recommendation(struct ml_lib_model *ml_model,
+			 struct ml_lib_user_space_recommendation *hint);
+int generic_execute_operation(struct ml_lib_model *ml_model,
+			 struct ml_lib_user_space_recommendation *hint,
+			 struct ml_lib_user_space_request *request);
+int generic_estimate_efficiency(struct ml_lib_model *ml_model,
+			 struct ml_lib_user_space_recommendation *hint,
+			 struct ml_lib_user_space_request *request);
+int generic_error_backpropagation(struct ml_lib_model *ml_model,
+			    struct ml_lib_backpropagation_feedback *feedback,
+			    struct ml_lib_user_space_notification *notify);
+int generic_correct_system_state(struct ml_lib_model *ml_model);
+
+#endif /* _LINUX_ML_LIB_H */
-- 
2.34.1


