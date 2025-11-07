Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 223E8CCF9E3
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 21:06:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78D338E001C; Fri,  7 Nov 2025 16:06:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73CEE8E001A; Fri,  7 Nov 2025 16:06:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DDFA8E001C; Fri,  7 Nov 2025 16:06:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4A6468E001A
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:06:06 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 135721A0608
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:06:06 +0000 (UTC)
X-FDA: 84085043532.09.8489F39
Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	by imf03.hostedemail.com (Postfix) with ESMTP id 264512000A
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:06:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=b+urK9t7;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762549564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kO0F0lPOuqRuP1r+X7yx5ua65c5v8nyw+1ERu/tsRgQ=;
	b=lwr9I72VOC3eyruuxUkOQv0VGez2PDs+Lp52bgYW61EpFUq39iRjFI3EqBZGFoPjLlfwEO
	xj7HAvdCb4VQ6tgskIhwV0Zywqg8N/SErIN1a1lfpERBnT/O6wxYxk/yMDSDUFD8W8p97P
	w9AVLGV58CwFPAIjGzQ7jTGdWBkRnRA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762549564; a=rsa-sha256;
	cv=none;
	b=GjsK97eRSsPsjA/4eZFlyPQSGOBu4HRm1cU4GwhwlpGstotMYJWXdtqMOaQ6oO+xTAkp0G
	/zDN0TC1iFijqsOr+LzZ8JvgXIm6P5NXfHiO51Ai05sAJ4Et1BTi/xgfe3JGvrHB8KBls4
	90rwoZwijffSTPgJj2dfPysjq1OFXwI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=b+urK9t7;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-63f97ab5cfcso1016998d50.0
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 13:06:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762549563; x=1763154363; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kO0F0lPOuqRuP1r+X7yx5ua65c5v8nyw+1ERu/tsRgQ=;
        b=b+urK9t7ykuUkYosgU/4BqiqWi/JIOSFQKFbkHXA8sy0q+zM3WWkgEjw3IC9bFruaA
         C4w2OXuZiGLYlmBfGE8iFovb1qBXCTfBpqROi1qMCJgyLW2vOHiN/0JxQNSUarruX7aC
         rhVAdPv2h9rLtmMwA6U1PAKTZkeNdSdOSPfi8L97d86G1+SWfulm9iblIXtj6PaGBRHL
         k8TSjEDyuHKThGHP0gvQXKfbgtPkARFFVrMWfuTyw35TNXgWqTLwj6xP+IWZ6xbebuhw
         GEaiHZ0P1X7TQYibTfMEmQPbyhuOxae4A/Ks7eG85eNCyC+6T5X1j9bIG7bgnrPUyM9m
         QpTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762549563; x=1763154363;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kO0F0lPOuqRuP1r+X7yx5ua65c5v8nyw+1ERu/tsRgQ=;
        b=S4iuQUUexvxRK6WA5pvivouJ6O7uPVI27VfmYXPwyGW7qZWYa4Z93+Yj3ovN2leLG4
         6Wahrout+KMI2HsTpS2UyE5/qUebut0CUPpRzb+uT5CgODY5qQqzlrddf4ip69syECtO
         ZcR2c+5pgEl+WNztI9Lb2jZrgVF00bpW5UZtko4R7GLyaGXqAG0gVAKu9hMMoVqfJ15G
         q66L5WQFPtF/RAUPuTvRfC9iDld21nHH4UQ2Sag5WozdDxk3Ay4KrpG/4zGmsoQG2Y5Y
         Dtgtu+HONOJ868ZRmvraq3X9TCAuskRoBn1O2R9YaJ5rU3uIfOw4b/wPuF/euOpwWZSt
         xpVw==
X-Forwarded-Encrypted: i=1; AJvYcCWGGuwWyjHYspiWPgzsRfK1QesscYEKDZMVKcnp9lg2NM/+C2poGrPU6pWjzb+l2AuwFU8913BTIw==@kvack.org
X-Gm-Message-State: AOJu0YyBQJwcd8xKgWURem5TcH0mGGc8j0EvCXTNsBT84dkJ4td2CqUr
	rM2BdBqz1BfO1IfXb7r0uLrbKo3P2uJRpWPsCsDPxmeOoGE9safsYOQ32rpzsP0I2t8=
X-Gm-Gg: ASbGncuG1JqOa+OImD6xlaLf/ig3B2DZKyui2P4p2ULvXwDiQKMzokf4d4J/1EYvh6k
	tU2QecNhH//enXzTtiYwBV3FVXGDorHRZPXjAt7TufVnxV6/kQY3iIkZyBnmX45pZ0b7ItegEk5
	s93DBpLfqh4Hr4E1nQUaywuIM9IuacNvVob4mYlXF6dBqL09tC0b1R31FC/zdFOW7bqquhIs3uM
	30B1IAosnQXj0m6hRdDumm5QNUOHHJ00AssWycAjv8Lu7yI5LGMG7HzWa9jND2ffbQe3dBPDzjg
	5IsGUy0mdLXMvSkyYECAZvTbdbISwzhAtOp7KVw/+f18U7gxPo4YZIHB422M7FXmkiDedE3igLy
	b6S1UgpW0jkOu9TqJIVTTuBZSCE27eToO1OaiLAadcLEj773Zg3HZktDZ1H2bC87GoXpT4LHeNq
	37Z5tvkCoSvfL1zYJdmZ9JxtqTy5jRRV+RxV822/SNfIQaaalR85xgXWoyC/Y2MUs=
X-Google-Smtp-Source: AGHT+IGUrCGSnQ3TU6q4/qNhItgcbFdsWINOhF2gqc7ZvS0Ysq3WXcStnQvjg9cKvk8ErPoxGLBe8w==
X-Received: by 2002:a53:d005:0:b0:63e:10f1:28d9 with SMTP id 956f58d0204a3-640d45ce885mr343426d50.57.1762549563137;
        Fri, 07 Nov 2025 13:06:03 -0800 (PST)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-787d68754d3sm990817b3.26.2025.11.07.13.06.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 13:06:02 -0800 (PST)
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
	chrisl@kernel.org
Subject: [PATCH v5 16/22] liveupdate: luo_file: add private argument to store runtime state
Date: Fri,  7 Nov 2025 16:03:14 -0500
Message-ID: <20251107210526.257742-17-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
In-Reply-To: <20251107210526.257742-1-pasha.tatashin@soleen.com>
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ig76sb78p1onn9zdnh9jqkw9wnfxyauu
X-Rspam-User: 
X-Rspamd-Queue-Id: 264512000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1762549563-88627
X-HE-Meta: U2FsdGVkX1/1AiqtX+iezZ1eFzTWv6Apy0PCGNfssQLJoczmZhjhKjfpSchezQCgTbF2envvQvtKzsjcpiKCSNHC6wa2zqeKVHcDp9IELXhpWEIFOiX1qmUOmmsvuOn+6JBy34oYV9cfpA1y3bXT+RZSghOYj9D8MAhLp81gpMgsj0umDf3liXSS90udBY0dlw2VIHh86uIRUy91dFeBwvB73Nikfsme2WndfYCBd96+fwqVcfj77Cz3XGzAXnDmGOfe0NXgrGl//uh7NkR1n7xEYExLMTbToAHHI5GdODC9F4unOkCBLuw8w/td42g+RROQWHRTbrAPHtAtHOmeQPLwkRIH/6Yi+FIrB78U5mrp/XwL0YZehtXyF5ny8anpxc0rwfYjvgi1kOTdGuyzWaroFA15AYzO+WT3yX5Ac/kG8wNa4v/7geba8Iv9hf1aJ9Wv3ycelwtYMOh1uYFktHNuBTA4Z6wMPDzm4OkA/RdKL24KmDWdAI3BbATOJXqRydcdyTz3yGFtMBi2+O8Xl/ikb9LjXFWjllMGqCO3nOrbPNuoco/YprfX+F7dl3ZCzF8RPHuyy9Z7bmusqPPB3Sl7zBkXX3lbIqXA6+QIs3qilezqz1qp0wfc6i8jQMSzQA5LGWvON3oQdIkNzsfqD8Tf/h0izissFAGtG10Re3/jSYBDDMiQgbH43FedJWEV9gxvq4GmbNcq3V/7jbPUQ30UGTHOEqakFTyuYYE9LatzbTK2p4Tk4KNwR+N9Idke+vG33pKsHAl4wn9igakRU9o/+mCJMwIPAHpY42xdyM9RabIQ5SoFeDvjF0iUTLDlk1PX/pW6ClFpBpvq2kO/d2Gr8RbwQqe2EUyM8HWyMjYBC8V/zuJfUqXtYdRK8pmhoGrS8jADCkm9WhvdNszjBRlz2TIcfNcXUvRje3agGuQgWbaQ6NB6F567DT7gL7nLUBwsjeVjUwPeKvuve01
 pEbo3+Sf
 3COQ0ou4DuY4LWAAy6ZuO3rtE5yoIqe2lQRHJ0LPScenCNNZwpLLbqBQwpCvhWJVxffvn6jVz0eEqRi0+VmrHuw16EWv05erXmnlW+NKNmr/hVDHyF5PYS8DM95n0ubxi5/F7MbfixLB3X2n3o7ffXa4Fim0P8OwEC4EN/GHSWKwgusywiKKRYAkTuHc9p/0wPgdhc5mfbYMsJUspC3HV18yFV3SdnIPxJBZign381iLu11uCvdBr9mJ/nJzK/Kr5lH2s45U2XgjyNFbhOXIsgBZbY9cykAafTscgWx1tWuboiK07apw1B86moFJGQ3MNEXxjNg94ffj0v2nJJKCaLKykNz7dEYZIPKm9u5cRoFpktHxYckFNv78ULjjGhp4X/M2kHEIsn8QGGR7bDIBOT7jE2fxy27FRrSaYqgj/Q3Y495A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pratyush Yadav <pratyush@kernel.org>

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

Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Co-developed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/liveupdate.h   | 5 +++++
 kernel/liveupdate/luo_file.c | 9 +++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index ce39b77c89c3..3f55447d18ab 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -29,6 +29,10 @@ struct file;
  *                    this to the file being operated on.
  * @serialized_data:  The opaque u64 handle, preserve/prepare/freeze may update
  *                    this field.
+ * @private_data:     Private data for the file used to hold runtime state that
+ *                    is not preserved. Set by the handler's .preserve()
+ *                    callback, and must be freed in the handlers's
+ *                    .unpreserve() callback.
  *
  * This structure bundles all parameters for the file operation callbacks.
  * The 'data' and 'file' fields are used for both input and output.
@@ -39,6 +43,7 @@ struct liveupdate_file_op_args {
 	bool retrieved;
 	struct file *file;
 	u64 serialized_data;
+	void *private_data;
 };
 
 /**
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 7816c418a595..713069b96278 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -125,6 +125,10 @@ static LIST_HEAD(luo_file_handler_list);
  *                 This handle is passed back to the handler's .freeze(),
  *                 .retrieve(), and .finish() callbacks, allowing it to track
  *                 and update its serialized state across phases.
+ * @private_data:  Pointer to the private data for the file used to hold runtime
+ *                 state that is not preserved. Set by the handler's .preserve()
+ *                 callback, and must be freed in the handlers's .unpreserve()
+ *                 callback.
  * @retrieved:     A flag indicating whether a user/kernel in the new kernel has
  *                 successfully called retrieve() on this file. This prevents
  *                 multiple retrieval attempts.
@@ -151,6 +155,7 @@ struct luo_file {
 	struct liveupdate_file_handler *fh;
 	struct file *file;
 	u64 serialized_data;
+	void *private_data;
 	bool retrieved;
 	struct mutex mutex;
 	struct list_head list;
@@ -307,6 +312,7 @@ int luo_preserve_file(struct luo_session *session, u64 token, int fd)
 		goto exit_err;
 	} else {
 		luo_file->serialized_data = args.serialized_data;
+		luo_file->private_data = args.private_data;
 		list_add_tail(&luo_file->list, &session->files_list);
 		session->count++;
 	}
@@ -354,6 +360,7 @@ void luo_file_unpreserve_files(struct luo_session *session)
 		args.session = (struct liveupdate_session *)session;
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
+		args.private_data = luo_file->private_data;
 		luo_file->fh->ops->unpreserve(&args);
 		luo_flb_file_unpreserve(luo_file->fh);
 
@@ -382,6 +389,7 @@ static int luo_file_freeze_one(struct luo_session *session,
 		args.session = (struct liveupdate_session *)session;
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
+		args.private_data = luo_file->private_data;
 
 		err = luo_file->fh->ops->freeze(&args);
 		if (!err)
@@ -403,6 +411,7 @@ static void luo_file_unfreeze_one(struct luo_session *session,
 		args.session = (struct liveupdate_session *)session;
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
+		args.private_data = luo_file->private_data;
 
 		luo_file->fh->ops->unfreeze(&args);
 	}
-- 
2.51.2.1041.gc1ab5b90ca-goog


