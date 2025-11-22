Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81109CFD313
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 22:24:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDE326B008C; Sat, 22 Nov 2025 17:24:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF2066B0095; Sat, 22 Nov 2025 17:24:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A44466B0093; Sat, 22 Nov 2025 17:24:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8F3AF6B008C
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 17:24:25 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 477C957A6E
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:24:25 +0000 (UTC)
X-FDA: 84139672890.26.59D94CA
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9905F1A0006
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:24:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=SVap8JTm;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763850263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ff4h/Y+aeCaryuraEaQmIoWWBfglnwQ79bUWNkRIqMI=;
	b=xZT8J9VY1/39iSIhqRZPjxLpRmL+CBmzMefZ+1HKOFGDDwzwl0fBE8jyYGGcVAKw4ocWkl
	0teDcSsQhOqkbHN8SgUjTxkX+gDLOHf2o5HGs+2iz1fXF6cyw5onNn/tEpr1C0O5CMXaas
	bJtsjtNYOeSsD9KfzDKsd5yXELdraW8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=SVap8JTm;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763850263; a=rsa-sha256;
	cv=none;
	b=5c2wUPFLjjKsE1s/51N+adcKARC3YhAGUqAIDspFbLGcfGfEDlwJC0m75iDNmbaVbEunvA
	s6ui2CY1/3EeeW45z6bxh1gDFkhCkFOvEOHd1Bk4Yzx/ogY+mrJvODiG+wAQZQcZ4NiSAo
	L3qnh6fNG06bt+I+60OJ7ePyXyi2F7Y=
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-78665368a5cso30146007b3.3
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 14:24:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763850263; x=1764455063; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ff4h/Y+aeCaryuraEaQmIoWWBfglnwQ79bUWNkRIqMI=;
        b=SVap8JTmVYjXZl7FTQSVFfSBGQZuMA/OaBOCKAQA/ybHVVeACitfOyBjV5D3fovseC
         Nvj6TuPHyLPz4s1aiw3jjGJMLvT5IAzY5EG/2xcnfgDGohrldgCgB7MJZ1CpkqmAcOB+
         zO51iG0L767otjp6mokFPiXFmy2Gt0fekZvoTxtjVBO2gkTFDtHCb/Lim+6JE1eeUkfG
         42/VVpoTDudEBGPQnHbVGSoBp06s0fKmqcQwL2eBtYSS4auzz6est51+FYTjxBCGMG9r
         KWeyHByfgqurmtPrqE0TwSdNuFt6AzvtN3y0WuCBba7yhXAeh4pt6oPtQeJGgryYDYVp
         //OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763850263; x=1764455063;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Ff4h/Y+aeCaryuraEaQmIoWWBfglnwQ79bUWNkRIqMI=;
        b=w5yms5t995RBiUErhchcx4cIE+k0KmnuHUdY/HLV2UBO5w0WzRUS+/Q+9FqNnWQ7kY
         njqWUjUZ00ur4TtATOiD3H7F7NrRqnTMya0pwjYr1JXLPz8lbYX/NMqZXHC8Kvk6qEOj
         hmyD5Ikp7+0QdBAHljuyJe3pqXiTNpDUPhY9Olt5Ofy864CJn14/nDBbLmgXkH9tdRjn
         HjP8oWrKF4UXMg48WePofgXARuXLjSTMQ/eIX8qtD+uyXOEjRaanmWM9pA0dMOObFVW6
         FVHn35CPhXWvz/9K6Iu7IckiZq3qaJ/SojvQJSkduXqztuY9hQfs25t6AQwb0+Vxv6Am
         2iCQ==
X-Forwarded-Encrypted: i=1; AJvYcCXkTSgGgNIYJ0zKd7qFU99z6v6ovCkw+SbUTw8M9eoZultqKoGJI+w4eMS7DFRB1Q2RtPsBcTWmvQ==@kvack.org
X-Gm-Message-State: AOJu0YyG5A/5e4DEaOj8jryt3yyVUMR0Cs4a+Dr6t4T4H/917rnIVq6o
	3wUbRJyLJyNCfsQjZjsUkRXU3VDQxEuDCgQI0INbuHpEi6G1ZoLdIDkBoKj95fHZOZo=
X-Gm-Gg: ASbGncuixf8NLoU8qPXT977+FSWF6eWQg2eXQvyJQ/i2DAETK9IpC0Z9Mf8spmhZ5r1
	uH6N6ONngrNhu7YphEKoiN0rL0gcdFwMsyeP0L5moNrqXLIJvgVXBJ6IPU9gZOOT1VyVtTCirSZ
	BvKeuGEWuMVP5e+7QXKn57dzd0Iq/foXAdF/xUCMIHSe7LqRPzuNQgCAB4QHgmvobsfVceKmqcT
	uBhUehBGx/WkILEqj00hkpn4JurSiuo8Y4vCAi6XZViWBFefnjDbfvtnjjm16B1hvhfdmtO5Hr/
	ihxndNlMY9y+uQMQylE6rYJwgdAt0Ffsi0M2/RzmbDzL1Zxyi9jytiTp3uBuJ8eJ9AtMftXlVTB
	fuxWR4UC8arN+lnPOvWqnK6If+wnNmZSx2kFfAEUmnkQ242w8arJApzN43VC0CxX+2kr9W7ZPs6
	ll1JgD2/O8oKa6VlJn+fXY9nTu8Za+v5CjBIXvi8FRTtM1/B3r1JRz9s4NUe0yr3Cuu96THGJhn
	2PosSE=
X-Google-Smtp-Source: AGHT+IEh/qsJ9xlDDV/YCr14e57USKSEfNEr00YTzpdoNrXFY7RlW6SCMXKos9LFs3pSvdRKqhUulg==
X-Received: by 2002:a05:690c:6282:b0:789:24a4:59dc with SMTP id 00721157ae682-78a8b54896emr60698047b3.70.1763850262632;
        Sat, 22 Nov 2025 14:24:22 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a79779a4esm28858937b3.0.2025.11.22.14.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 14:24:22 -0800 (PST)
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
Subject: [PATCH v7 13/22] liveupdate: luo_file: add private argument to store runtime state
Date: Sat, 22 Nov 2025 17:23:40 -0500
Message-ID: <20251122222351.1059049-14-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
In-Reply-To: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9905F1A0006
X-Stat-Signature: ahtisyfz5ej9eks7yxm98xpb4t4wxym5
X-Rspam-User: 
X-HE-Tag: 1763850263-51702
X-HE-Meta: U2FsdGVkX18gw+QyD9KYeSCH6mo3Fl6rRlma6p4WwsTKFdYbX3S2iJ8Otyl59T92WyMWYYH3cbIrptQzlF7bJ9P6W/MoLDK1Oe0Fz7mQDWn9mgyyzcaMK+ulK7J+Dr3ZMvwTfHA4PL37u7jaE2CoiLYQ/ttKZH7ah7PRzG1VM/DycoAU/a048GCk+A6k2agrdjrfXZG7pNJZW4WvmuUVwYEOFIjbGY36OCgMCh6rvWlKhU7NLpizR4mOr53CADHT0U+dDpdBKLDSGhsUSTO4FOABiShwBFRYAf4yIFt3igpzYnj//op0bpY/6qhevI/7DNsDxKxpQznLTibxCBgZbfxDd2VhaEFt8uEeYvqSEK2EHf/NsQXIgieZRk+9UocyLztJPkuacMfpjDEWIL+VC+kMSsFZx1bfGzUHol9Ac7Erpc4c3pC02bwn0p7vz7s/ahPkPrMfSAi4VgYn1UsGjFgDI7N/hOUHjzBuUiceZstb7v+ZyRE5NNHYbHP03HiHLD0xsvnmZLFoeb4UshvBwNgOTAthXrh+MpLkzJ3FKhIN0E74ByYllaWVWtLdBj2maEULRhW82+Z3nL/Xq8NEP0F8w93oAo6TGOm02gGh6kdYV4brxLLsuGydeqyiNz2zHQdusg6YAV4I4N0Xtkoxzn4N8ZvJaAhW7JKFckLnTRuPonFAtVESTkNIm20v+BAJfxAgXUqwZQPVyjdiWSgar9kARiJ2TgwzRUkTJhcIZi9KAvihF3+N59z8yzRfAJvdBdlsAhZpfzhEIbB1UJdcWONl6F8v+Via0BYzcht71gf68929Hk4VulyGrv3XVH+PXUmbRTeK8nle++DbNbbULXMGoROTAU49xehlsljl7D7VLctdJbrbL9SFmC14C5rC26PPSfai3si5t0uMHv5L6Ztek3Gl4oqUiAHU0dp+e06BBtsssbq30yVKL56u3LloZShAvjSpZ8rD8mBNjgk
 kbDN+WxS
 CLZWb0wCv5hVALS4Gm/ws0xhHVb12597rWYRu7pZ7705aW4YcTlGUBTXlIgWs5DSOGAx93QgUi5Hg+A4RykvEJ2zBRJXuR2Y+3DfF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pratyush Yadav <ptyadav@amazon.de>

Currently file handlers only get the serialized_data field to store
their state. This field has a pointer to the serialized state of the
file, and it becomes a part of LUO file's serialized state.

File handlers can also need some runtime state to track information that
shouldn't make it in the serialized data.

One such example is a vmalloc pointer. While kho_preserve_vmalloc()
preserves the memory backing a vmalloc allocation, it does not store the
original vmap pointer, since that has no use being passed to the next
kernel. The pointer is needed to free the memory in case the file is
unpreserved.

Provide a private field in struct luo_file and pass it to all the
callbacks. The field's can be set by preserve, and must be freed by
unpreserve.

Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
Co-developed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/liveupdate.h   | 5 +++++
 kernel/liveupdate/luo_file.c | 9 +++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index 122ad8f16ff9..a7f6ee5b6771 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -27,6 +27,10 @@ struct file;
  *                    this to the file being operated on.
  * @serialized_data:  The opaque u64 handle, preserve/prepare/freeze may update
  *                    this field.
+ * @private_data:     Private data for the file used to hold runtime state that
+ *                    is not preserved. Set by the handler's .preserve()
+ *                    callback, and must be freed in the handler's
+ *                    .unpreserve() callback.
  *
  * This structure bundles all parameters for the file operation callbacks.
  * The 'data' and 'file' fields are used for both input and output.
@@ -36,6 +40,7 @@ struct liveupdate_file_op_args {
 	bool retrieved;
 	struct file *file;
 	u64 serialized_data;
+	void *private_data;
 };
 
 /**
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index f10d6c37328c..b235d1b562ad 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -129,6 +129,10 @@ static LIST_HEAD(luo_file_handler_list);
  *                 This handle is passed back to the handler's .freeze(),
  *                 .retrieve(), and .finish() callbacks, allowing it to track
  *                 and update its serialized state across phases.
+ * @private_data:  Pointer to the private data for the file used to hold runtime
+ *                 state that is not preserved. Set by the handler's .preserve()
+ *                 callback, and must be freed in the handler's .unpreserve()
+ *                 callback.
  * @retrieved:     A flag indicating whether a user/kernel in the new kernel has
  *                 successfully called retrieve() on this file. This prevents
  *                 multiple retrieval attempts.
@@ -155,6 +159,7 @@ struct luo_file {
 	struct liveupdate_file_handler *fh;
 	struct file *file;
 	u64 serialized_data;
+	void *private_data;
 	bool retrieved;
 	struct mutex mutex;
 	struct list_head list;
@@ -300,6 +305,7 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 		goto err_kfree;
 
 	luo_file->serialized_data = args.serialized_data;
+	luo_file->private_data = args.private_data;
 	list_add_tail(&luo_file->list, &file_set->files_list);
 	file_set->count++;
 
@@ -346,6 +352,7 @@ void luo_file_unpreserve_files(struct luo_file_set *file_set)
 		args.handler = luo_file->fh;
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
+		args.private_data = luo_file->private_data;
 		luo_file->fh->ops->unpreserve(&args);
 
 		list_del(&luo_file->list);
@@ -372,6 +379,7 @@ static int luo_file_freeze_one(struct luo_file_set *file_set,
 		args.handler = luo_file->fh;
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
+		args.private_data = luo_file->private_data;
 
 		err = luo_file->fh->ops->freeze(&args);
 		if (!err)
@@ -392,6 +400,7 @@ static void luo_file_unfreeze_one(struct luo_file_set *file_set,
 		args.handler = luo_file->fh;
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
+		args.private_data = luo_file->private_data;
 
 		luo_file->fh->ops->unfreeze(&args);
 	}
-- 
2.52.0.rc2.455.g230fcf2819-goog


