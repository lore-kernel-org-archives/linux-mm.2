Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DAEDCFD313
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 22:24:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C68B16B00A9; Sat, 22 Nov 2025 17:24:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C19C36B00AB; Sat, 22 Nov 2025 17:24:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABA876B00AC; Sat, 22 Nov 2025 17:24:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 90E276B00A9
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 17:24:39 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5A0AF58F58
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:24:39 +0000 (UTC)
X-FDA: 84139673478.21.97F1F80
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf16.hostedemail.com (Postfix) with ESMTP id 83E26180008
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:24:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jpYiE56h;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763850277; a=rsa-sha256;
	cv=none;
	b=j5Kmx7xVlMT5jaimcRDlatHHsW94VJF3sAwypWchPoIts5QHWp6CzYxMOL6e/CPIMPmkXT
	UrmygzsL+rv+cgjYLkg12yCJaurtu1O1gsdWrszAeRk0aM8YMNxrZ30PKPy26j0npBzRL/
	+gVYTq0zsNzfNn8YSra9IPqgeZJoUbI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jpYiE56h;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763850277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=62PEQYDhS44k4KirgxolX0bFfpu4NqLUXaq5TcT1ZZY=;
	b=vuuBqmUTtAdqoF0oGEOS3ElDfG0vZslikLBP1xyq7qc6/YMGXzd1CmU7cIH6AvMmlVXyJ7
	d7TBAv/c0yxJjM+K5xcvwDi6ItDY6L2Epsd25RHPesXq/QqCIky62IGdrWbn/cskmCcAKZ
	5dWKalN7hLBrW81L6TxBFSbNG965Bm8=
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-78a76afeff5so30830137b3.0
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 14:24:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763850276; x=1764455076; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=62PEQYDhS44k4KirgxolX0bFfpu4NqLUXaq5TcT1ZZY=;
        b=jpYiE56hJtvMKgjuEtl4gYtcq7ZsWOFHhDWLYNbCzYb9LQ6X8Ag4FE8JYy+ad6k2SK
         GYOPvvVSxUd1KZcOhooXz/MEAxr7OnorKLNzZpAXUQF6FzPpeVqI9UXODOhRBhanjI6h
         rJ7zBNB99kVAb8vk4rwfxTUmH2rPZPDaCqgb4ZtmmLZ6k/LtxER/XfeZ42sNFmX+5x7Z
         cbD+cPCUP2OM5fXi/feywNaWg1fGppugAlDmwl39m/V7PjKHU5Vh8Q09aCTg8gxhgakv
         v2w+KLj4Lttuj9hD456Sv3ZON1tb6TO3K1SqF9hWPfkhcIQdewzKSzxfQphSntLBRCr1
         G/zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763850276; x=1764455076;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=62PEQYDhS44k4KirgxolX0bFfpu4NqLUXaq5TcT1ZZY=;
        b=OD2IgryZv9NKZHi87ttAURjU2dvVhuPMh6BBvtCW8Gc0B16Q+lK5aXswDdMVAcTXlL
         hWFMxKWpADc3gS3Iqa0RBRVI7hDWpCBZoe13GPb3WNQxyz5QK2aju4a4dtmowgz1PxmN
         h3HKjSW/oRHyiNWflva1V9YikDGB1TwNDbFVMhSLrP9AAUiEI6hHdqVozZWy3QjrecNY
         uDnq00PXS2pUyLXmOCMSwfpmoWIG9SIObgyWfyBrw2AYCf9Ar2eFfJkxQlHaGByBeTF5
         OgE2AFStjA78N9HKfUvDfDwt8qHmIV1byhsjuIauYFvi0knybECxq+1uz10hCoRLpEJs
         hfrA==
X-Forwarded-Encrypted: i=1; AJvYcCUMP6+PLSC0xJ+0okX9NPkcatBFxYw7fEhw1dCkBYpnkt963PQIqIqyN4eZ/BgQ94sYtB729c/PCQ==@kvack.org
X-Gm-Message-State: AOJu0Ywhh3tq3qVKXH6IAJq83a3gG3EbsN1ZokpMyfAsMQl/ALZo/QZ9
	O2LYWOqGg+aSP7bYM14f9TL1WdolKgMRKe6nMSlYAqoy/qGyV3oxj7uedpeNa85ge2U=
X-Gm-Gg: ASbGnctsd0saef7kqsm922lghUrLT4QN5arDAKQ5izaixbmTnnIMCa6uJJNPth1cY2N
	tRKTcFr1W1tbSQu2rt2d552PxqmNrNdjmTRnFysT4eSMkrbFGwsJtz2SU6Y/EeFGn2E9tFJC8mb
	kgT+DowDF7Niff66N20ltzKCT28VEp5d0zp6BFvvcw3Xejj9UGlqYRLTUexs2XTgvJm2eVd7/Mh
	2BTQ4Gm0RCo5vzmPQEWOUZg1VOamRPFnjjm0Ls8N+3cqLup2RpNqCPTVrZr5q4/ySyBBSdi4A9E
	GuOX40FS4NRXQd2R8UtkX4dhj5SE6b50RtqHCu8LgxLrkyRLUqbnPFrdoWoAFslIbY64mxELYnD
	SIps5KUgZfz0nqQN4qVa6YiBAZFVO149aU1zyrvQIXO8p0H70Cun+T6FHYsllJgvBtiWmei9ZcF
	j4uCQ6N5FH3E2SFwlVROjBG2inZXpHKhBbJuBOH3ASqeoHa3oakndXm2CFUUllMcsQVi6K3ljLx
	MoHdFo=
X-Google-Smtp-Source: AGHT+IHkNZ1O05/wx0JB3pi70sYZwOs5GclCpL45vuZfhM2JjOjXMdM7CjvQ81K6Kvb3Obn+lJkkcQ==
X-Received: by 2002:a05:690c:3690:b0:788:182e:b29e with SMTP id 00721157ae682-78a8b47de80mr61772657b3.7.1763850276575;
        Sat, 22 Nov 2025 14:24:36 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a79779a4esm28858937b3.0.2025.11.22.14.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 14:24:36 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
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
	chrisl@kernel.org
Subject: [PATCH v7 20/22] liveupdate: luo_file: Add internal APIs for file preservation
Date: Sat, 22 Nov 2025 17:23:47 -0500
Message-ID: <20251122222351.1059049-21-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
In-Reply-To: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 83E26180008
X-Stat-Signature: 5a7raeyqqyors4qq11e44aeq6seb5zyd
X-HE-Tag: 1763850277-570370
X-HE-Meta: U2FsdGVkX19Nf+GKx95bnWc8Z9+XcvNyZMVj7EOpQvjmvHU1R7BzRVe5FVsy853Aa6mnbD/KZMF5Yur0SxcLcaVJ3TM54tqEgDepYSWzWb8i3HhasqFyut1ze0po8v3JNYvvk+CmATm7yIyrOeHQvhBY7aOdLBgx/Nt/uheK67ujTYqBMv+4G5QnxrGN1CXZeyfJXE5rTnTuig4uu6CQmeFgYjiW9Qh9LvYJgExIK6l/js5HKY47s6dH2LwN464uphGrPIMHinhYeOqY2sQqjE1hDgKdU0xOv3j4HXkW9O9buqJn7ouZJdro4/Lxh4gbzPckEshgSVLcBXSYImydh4AQC8zYBdZzNpLEOlM+ECa8s0qAY+brVlFBfZh+g7RkvzXmsz6GMuWAYlKIas4cC3ummAU5aHGNaAk3YX+ACwBv/0zpvyCnPXIWN3QAqLqU/JTzg1iimtYVrDVzD40A87yDO5jInZ3b+h7G88vpBARxf7j3dz3TloJ8Q/j1ZlIusOEEIw1xWFTSwB/od9XZ+V8vzbGiQ24/i4gn4HU5lwKJVzb7gC77/hbrm6kVh/YNvzWCAHvVw+ApQFtXy157L6RRn3DmoPyDznmnCRCRCnB7N9ZOpd2+IfOyAX5AdrlOUiH6it/Ht1ks9jEZpkmUR7SsgjXhasTDYHrHeCAg6NZ2ZpXGUH5EDV/5xXod+WJRSPXT5dfvKdXXMl6kbBXEaNP5iETE7GAjbB5XhJt43PgjRgbYPuOsacaCR7WvnnHYUAVHnPFXsc13ON8p6oRJHe0IMT9AT44V4QI2gW8tXQKgUjiG3zCMJ5n6dgmDeHcFlYsmtm5sOe+2wFisdUriH/4aOoQmOJDkXGQ2n5D2xeWecrnnA1FYia6GIA57KcNEAagOU1pP5kzpdvpst248AQ+P2fTpBgETbKe4wRBE8ExeYSwgPoPR+rfE2t9Crqp3GOxraA2FUGXVOAeUXEl
 RiUAAyYI
 PnBZneEAHb18L8n/kry9Bufuw5ojsmr5XehRv507t6aVDbFEXmaGT/+LSMw259ZjcIxaGQ/tL7p715sacVY6ioL55K7IwFnMs0AtBi+QzinIoSRW/bbwWp+ZyLBYUrIaVgBFKOLUGuvT9FlVVetyBgZ/lrFHTb8aRA77O0Smw7dkPXWjPd2XzRxvdOC/Kvf7TTTJq++WOa3yQTfSDpo8vOMFIiGKJcqqf3L9AjCbdsQO9SwQOfccubbkq2Cgd07+ywaskdcCxu3jZO0VzdY9UgYQvRb6Js670V+s2+CQt6fa2wikxAW7A8IHCKZfjqj5fst9SfihS2tca3C3MiGIlvUlNlCgCuHMQGuN4Uww/n7q3ZSRjKXEqU+j6wh3m7aXoVcJ27HKe9Jp3NOPDvk2MwxpxbCHq9RHdF/lG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The core liveupdate mechanism allows userspace to preserve file
descriptors. However, kernel subsystems often manage struct file
objects directly and need to participate in the preservation process
programmatically without relying solely on userspace interaction.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/liveupdate.h       | 23 +++++++++++
 kernel/liveupdate/luo_file.c     | 71 ++++++++++++++++++++++++++++++++
 kernel/liveupdate/luo_internal.h | 16 +++++++
 3 files changed, 110 insertions(+)

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index a7f6ee5b6771..c9503d2cda7b 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -15,11 +15,13 @@
 #include <uapi/linux/liveupdate.h>
 
 struct liveupdate_file_handler;
+struct liveupdate_session;
 struct file;
 
 /**
  * struct liveupdate_file_op_args - Arguments for file operation callbacks.
  * @handler:          The file handler being called.
+ * @session:          The session this file belongs to.
  * @retrieved:        The retrieve status for the 'can_finish / finish'
  *                    operation.
  * @file:             The file object. For retrieve: [OUT] The callback sets
@@ -37,6 +39,7 @@ struct file;
  */
 struct liveupdate_file_op_args {
 	struct liveupdate_file_handler *handler;
+	struct liveupdate_session *session;
 	bool retrieved;
 	struct file *file;
 	u64 serialized_data;
@@ -112,6 +115,14 @@ int liveupdate_reboot(void);
 int liveupdate_register_file_handler(struct liveupdate_file_handler *fh);
 int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh);
 
+/* kernel can internally retrieve files */
+int liveupdate_get_file_incoming(struct liveupdate_session *s, u64 token,
+				 struct file **filep);
+
+/* Get a token for an outgoing file, or -ENOENT if file is not preserved */
+int liveupdate_get_token_outgoing(struct liveupdate_session *s,
+				  struct file *file, u64 *tokenp);
+
 #else /* CONFIG_LIVEUPDATE */
 
 static inline bool liveupdate_enabled(void)
@@ -134,5 +145,17 @@ static inline int liveupdate_unregister_file_handler(struct liveupdate_file_hand
 	return -EOPNOTSUPP;
 }
 
+static inline int liveupdate_get_file_incoming(struct liveupdate_session *s,
+					       u64 token, struct file **filep)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int liveupdate_get_token_outgoing(struct liveupdate_session *s,
+						struct file *file, u64 *tokenp)
+{
+	return -EOPNOTSUPP;
+}
+
 #endif /* CONFIG_LIVEUPDATE */
 #endif /* _LINUX_LIVEUPDATE_H */
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index b235d1b562ad..670649932de4 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -299,6 +299,7 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 	mutex_init(&luo_file->mutex);
 
 	args.handler = fh;
+	args.session = luo_session_from_file_set(file_set);
 	args.file = file;
 	err = fh->ops->preserve(&args);
 	if (err)
@@ -350,6 +351,7 @@ void luo_file_unpreserve_files(struct luo_file_set *file_set)
 					   struct luo_file, list);
 
 		args.handler = luo_file->fh;
+		args.session = luo_session_from_file_set(file_set);
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
 		args.private_data = luo_file->private_data;
@@ -377,6 +379,7 @@ static int luo_file_freeze_one(struct luo_file_set *file_set,
 		struct liveupdate_file_op_args args = {0};
 
 		args.handler = luo_file->fh;
+		args.session = luo_session_from_file_set(file_set);
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
 		args.private_data = luo_file->private_data;
@@ -398,6 +401,7 @@ static void luo_file_unfreeze_one(struct luo_file_set *file_set,
 		struct liveupdate_file_op_args args = {0};
 
 		args.handler = luo_file->fh;
+		args.session = luo_session_from_file_set(file_set);
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
 		args.private_data = luo_file->private_data;
@@ -581,6 +585,7 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 	}
 
 	args.handler = luo_file->fh;
+	args.session = luo_session_from_file_set(file_set);
 	args.serialized_data = luo_file->serialized_data;
 	err = luo_file->fh->ops->retrieve(&args);
 	if (!err) {
@@ -606,6 +611,7 @@ static int luo_file_can_finish_one(struct luo_file_set *file_set,
 		struct liveupdate_file_op_args args = {0};
 
 		args.handler = luo_file->fh;
+		args.session = luo_session_from_file_set(file_set);
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
 		args.retrieved = luo_file->retrieved;
@@ -623,6 +629,7 @@ static void luo_file_finish_one(struct luo_file_set *file_set,
 	guard(mutex)(&luo_file->mutex);
 
 	args.handler = luo_file->fh;
+	args.session = luo_session_from_file_set(file_set);
 	args.file = luo_file->file;
 	args.serialized_data = luo_file->serialized_data;
 	args.retrieved = luo_file->retrieved;
@@ -889,3 +896,67 @@ int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 
 	return 0;
 }
+
+/**
+ * liveupdate_get_token_outgoing - Get the token for a preserved file.
+ * @s:      The outgoing liveupdate session.
+ * @file:   The file object to search for.
+ * @tokenp: Output parameter for the found token.
+ *
+ * Searches the list of preserved files in an outgoing session for a matching
+ * file object. If found, the corresponding user-provided token is returned.
+ *
+ * This function is intended for in-kernel callers that need to correlate a
+ * file with its liveupdate token.
+ *
+ * Context: Can be called from any context that can acquire the session mutex.
+ * Return: 0 on success, -ENOENT if the file is not preserved in this session.
+ */
+int liveupdate_get_token_outgoing(struct liveupdate_session *s,
+				  struct file *file, u64 *tokenp)
+{
+	struct luo_file_set *file_set = luo_file_set_from_session(s);
+	struct luo_file *luo_file;
+	int err = -ENOENT;
+
+	list_for_each_entry(luo_file, &file_set->files_list, list) {
+		if (luo_file->file == file) {
+			if (tokenp)
+				*tokenp = luo_file->token;
+			err = 0;
+			break;
+		}
+	}
+
+	return err;
+}
+
+/**
+ * liveupdate_get_file_incoming - Retrieves a preserved file for in-kernel use.
+ * @s:      The incoming liveupdate session (restored from the previous kernel).
+ * @token:  The unique token identifying the file to retrieve.
+ * @filep:  On success, this will be populated with a pointer to the retrieved
+ *          'struct file'.
+ *
+ * Provides a kernel-internal API for other subsystems to retrieve their
+ * preserved files after a live update. This function is a simple wrapper
+ * around luo_retrieve_file(), allowing callers to find a file by its token.
+ *
+ * The operation is idempotent; subsequent calls for the same token will return
+ * a pointer to the same 'struct file' object.
+ *
+ * The caller receives a new reference to the file and must call fput() when it
+ * is no longer needed. The file's lifetime is managed by LUO and any userspace
+ * file descriptors. If the caller needs to hold a reference to the file beyond
+ * the immediate scope, it must call get_file() itself.
+ *
+ * Context: Can be called from any context in the new kernel that has a handle
+ *          to a restored session.
+ * Return: 0 on success. Returns -ENOENT if no file with the matching token is
+ *         found, or any other negative errno on failure.
+ */
+int liveupdate_get_file_incoming(struct liveupdate_session *s, u64 token,
+				 struct file **filep)
+{
+	return luo_retrieve_file(luo_file_set_from_session(s), token, filep);
+}
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index c8973b543d1d..734469464664 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -84,6 +84,22 @@ struct luo_session {
 	struct mutex mutex;
 };
 
+static inline struct liveupdate_session *luo_session_from_file_set(struct luo_file_set *file_set)
+{
+	struct luo_session *session;
+
+	session = container_of(file_set, struct luo_session, file_set);
+
+	return (struct liveupdate_session *)session;
+}
+
+static inline struct luo_file_set *luo_file_set_from_session(struct liveupdate_session *s)
+{
+	struct luo_session *session = (struct luo_session *)s;
+
+	return &session->file_set;
+}
+
 int luo_session_create(const char *name, struct file **filep);
 int luo_session_retrieve(const char *name, struct file **filep);
 int __init luo_session_setup_outgoing(void *fdt);
-- 
2.52.0.rc2.455.g230fcf2819-goog


