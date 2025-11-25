Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93B9AD0EE0E
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 16:59:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D256A6B0089; Tue, 25 Nov 2025 11:59:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD7A16B008A; Tue, 25 Nov 2025 11:59:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB3C06B008C; Tue, 25 Nov 2025 11:59:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 973C36B0089
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 11:59:35 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4C600B8005
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:59:35 +0000 (UTC)
X-FDA: 84149740710.25.D02D252
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf15.hostedemail.com (Postfix) with ESMTP id 835E4A0008
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:59:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ZhWjs7hh;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764089973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yx9quZG9gLF2dl0IKuMBsHxvDi//DiVhoRUqED9zxDI=;
	b=H6dDnLlq9YupzJaFE48QMSiFMpxCM0x256lSSowfG2IOybg+r3gYA/VNUV92ANw/4LZWN9
	8lTIrhLA+F+0v9TCszZNf4j/8WuRcTd0JfyZ2Hyiyk6knrViUbcFeoqHiO796Iua7/Hm54
	9wQr2aMaM0hqcN0u1NYIOCweh9+KiFc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764089973; a=rsa-sha256;
	cv=none;
	b=zioCLJr5Q2+aJKLpNTvB+U+EhQa/zbhQeWLYDZlINrgNVV/zDOM1C9RxsPHw1WIkQoOXNi
	aM9MhSCW/IqVSSIyKM7981aGxSkfqnGu9+E6D5Q7VtTtf820cB40iTTIkJraZYt5B8U9AX
	P97IeSPRF0hr12eGrF+uC5WK6Cq2IcY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ZhWjs7hh;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-789314f0920so50511757b3.1
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:59:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764089972; x=1764694772; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yx9quZG9gLF2dl0IKuMBsHxvDi//DiVhoRUqED9zxDI=;
        b=ZhWjs7hhmvKp+hg+l2dkS+1k9a48SPp1Tqg3AMIh0gwLTTcg2kNC4cuxKoAHz7wZz0
         7Jticp7oyu3nL0JAOy1r26kP7P5ACqvgYQk1AR7pBZMiuBOAAKzTaktFUJp4db0L2ptK
         tw9oWtCqwMbV27BkJCa0QP9MKaQ76JIA4tG9LJ4DgIbJAznMOM9R5/ARBbsqvmDX9Ap2
         T9ePzmEjqNuZDC/2zIko/0aBTGILTUFTdTUsgJdr6c/rOngEqY9/LQmZhAihK3YK8ZzI
         bTEE3jgVDwrfvKvVmBZ2LcQ4eR9MF/cctyaL+937/htuC7InGR+WCOvPTtccKyb04raG
         904A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764089972; x=1764694772;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yx9quZG9gLF2dl0IKuMBsHxvDi//DiVhoRUqED9zxDI=;
        b=FdM3flopTl1cOHgh3hQAkA7PQavP0R47Wv8JQUGGHPhhhEoTT8A0rtfQXVcTI28Icl
         8pojL6gnkZ+R1pQZN4lda7U4HqGCVCPB/uz3zVxpvQHtxcggSU5f1EkQs2Ojj1Xkoj9+
         Xt5DVGqN9Xe+of2M0RP90s0n+MLNpBp/ALaLS8RVhKdpYVYeOvGGTKxidZQxjiaFxXkf
         joUoA6OKckYfEnybFOz2DgKRCCPAGLdEq6iMilnvhRrkWxF1KbzBKntUtietuehtOPjI
         C/ZxNmzw/2js2MoGNvXnv4QXHWq2oL+QyYYfk/wINhbXGYA9Yt1Kn5SlWz6v4/qZIPxT
         zNaQ==
X-Forwarded-Encrypted: i=1; AJvYcCXnIkbOHZLZMZixWLRzXQ0XVAIXmgiaCd4N4IFQJ+4mYYCmxPpEyt/N2Cx8jljYKBzaKFShAb1OFA==@kvack.org
X-Gm-Message-State: AOJu0YwX1QT5yXphMBZtFOI8gbyCo3tf1n7xdzIM775X17vbano2r4zX
	a8PfV5PmksRu5SETjSOE+DxoDIoBwt+QKvQT54Ool+RDp3+h1UIU1AKxvqv1pWa3Pfw=
X-Gm-Gg: ASbGncsKUVjyV8hMJsS2Y3TML5C+HetPR36XXtX7jOk+KfJBZ3HlPjxSaJrnxBh6AK2
	sXRqa/i/UwlJPQeGXsXunouLoUgbxL/oPx40OdG4/DcXafCnrXcVB6JZmH+ZiNYqj+PQYW4Y6aI
	74LWoXAhZQc110DZNLERyhJKWlU+OwMS/H849wMCpbBCJqfma0ai+iLsGbLXf5r394TUNpgY25X
	q4rh1ge5yQGs1YvkyAHQiWQ9gNpJjl1kTl3Cn4+KSfL5zK07S7nY8wyUNDrTqczHkydAbZYBg5a
	ZqIikzqpFkvbOU0CnYPmA5AFRZYMuiVszrXVaKb9ueCYDRfM6EzNd1BlRwvxbsM77oFz7cDNgW7
	CoRFbkzYGfcDMVHVM0QnvB1uvu5UZBY3awRI7oohba8sWI0H3b2MjJ8vGQSp/Avk+/KgSC1QT1i
	MlDSMXGfPxxCQbe3Vkd/8Dc1W25pH6ISoq+fWD/GdmfxRIUYuzeGN2lUHWAjg7i9p4
X-Google-Smtp-Source: AGHT+IEW6KgCKYwZ7XEqOpbUcHlowFzPqPsBiqMYeBlVaw8DURiXeYQOxuH5IPmz+1TT/Eb1rS/paQ==
X-Received: by 2002:a05:690c:338f:b0:788:737:4830 with SMTP id 00721157ae682-78ab6fce723mr28091657b3.66.1764089972519;
        Tue, 25 Nov 2025 08:59:32 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a798a5518sm57284357b3.14.2025.11.25.08.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 08:59:32 -0800 (PST)
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
Subject: [PATCH v8 13/18] liveupdate: luo_file: add private argument to store runtime state
Date: Tue, 25 Nov 2025 11:58:43 -0500
Message-ID: <20251125165850.3389713-14-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.460.gd25c4c69ec-goog
In-Reply-To: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
References: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 835E4A0008
X-Stat-Signature: 5d45gqt4pr74fp64j3jmoakixu3adsej
X-HE-Tag: 1764089973-38238
X-HE-Meta: U2FsdGVkX18LCsyuLemk6ZeopY/lyuzJ12HqPWsvuOUAv/wxau1EzPfHx2IlqoyqFtBgcPVL/VI5/nJjDiAU63mpHhDq/bDm7IlHR/hQGCUWZbTsl9uMv32vNciRB6oMAEPRhrpHIzmfFttLt5qgUPf6WS+xBBsFG93Jp6xrIIbyvps40YCKwHRtD58gQp819AQk83Me4j9mzq2n7RnAs5RYzp4g2hThJZIxcuVbeEu0dWq9hWNqPRJxyoRiS9L1m/eU2eQI5/Egh3da57+qhyRCMhFg24srdDNQrcAihDv170TtD7jFiuvZ92Vf9OeFUMCI0Ib4gouPjjOEWc7aPsVxFUVQ+3jQgZquVti7dGymsEkI1b1JbfUh0rPCyI83+OKgug2whEHxwgyMJEJlCANHTdE7hRr8VqwtxeNtPn7i9m1La4eHUFOg+h/luhWPKYD+xn5HxBSBnVb/ugltYZv5Ib6IZgnglnJ2vfsxRd5Ymc2BjNVZZVDHr9pmfu+ug8IwGOxNlvKWp6DABhcDp98pI/RFTGIlb16F7v4k6vpsTsTG9ZVXOjiEcNMi+9JlNunOYqqUnFFTF67DoJ3HXDXQjDCLmxesXAIeBQJIBFyZyM3JnP3+rWxG6LfBtVBClgFjgXxlDCfeFGFAkcZ3WRWxPKpRfODJiH9Xp8uyCSh34sHFfOtbErV3vJZJVVmlWmaV3CksHBPUkHTs2eq5AdRx+1mt75wJqPd0dgnT08s1bTLlTOtCPO36KrMExUT4tRWsHugWpxrNb4HmqTrZ0USIDQNO9AKO/PeWBCzQAHreZWSBq38NnodPHMEIOHBcDtWOJ4CCPSkrF9lE00/S4ep9J3ioczkGQEeCx20vJaOMwqUgLHvC2/h5/2RGubKSPlLoGefoI88S+uUL7lilxrn+PyxvM9l586lZBPYKMlHRKFURBuN+2yBZNqbp2XqVKnfc8ehN4vVIRtLicRl
 5jlX9O3j
 ft1R/NZ32i+BU0ORJCn96TYJjTk9wrZU0J6VApp5Lwk9kLoJlcYqDTA0NOJvUrrAboFMb2LlGUsKv7YS2dbQvvYDrvpeGnqDnrheAyBJ5KgiPlmPKC/lzz0uaTVoS57Rspoc0q0gfYONy/GW3K60i3Xt+EchpG2G2kJE4Xg7gg0iLjQtFY4IuRidwJFThvaCgAsr9w0GNJymCXPPi8KsOEGQuiYqObCcQWh1/BAj6zIhNGtLxq94mrIy4zn+A3ndKPdxBU10EQvwXzxcTUp78tfOKVEwIGTN2kDhYq9nqCXC6yp6WIUH2Tj7dlGM5IN1cv48l4yMcZUyi0tzpDOBNyf85EGXSFG4JfoV2sf/FN3PArbMk7TNRux9F8g33QgV9lk12gw7azeYSMa4oxCOQD3MU7Jiprl7sryFoQQJw+foPTxsoZYSCud6WqA==
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
index e9727cb1275a..ddff87917b21 100644
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
@@ -298,6 +303,7 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 		goto err_kfree;
 
 	luo_file->serialized_data = args.serialized_data;
+	luo_file->private_data = args.private_data;
 	list_add_tail(&luo_file->list, &file_set->files_list);
 	file_set->count++;
 
@@ -344,6 +350,7 @@ void luo_file_unpreserve_files(struct luo_file_set *file_set)
 		args.handler = luo_file->fh;
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
+		args.private_data = luo_file->private_data;
 		luo_file->fh->ops->unpreserve(&args);
 
 		list_del(&luo_file->list);
@@ -370,6 +377,7 @@ static int luo_file_freeze_one(struct luo_file_set *file_set,
 		args.handler = luo_file->fh;
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
+		args.private_data = luo_file->private_data;
 
 		err = luo_file->fh->ops->freeze(&args);
 		if (!err)
@@ -390,6 +398,7 @@ static void luo_file_unfreeze_one(struct luo_file_set *file_set,
 		args.handler = luo_file->fh;
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
+		args.private_data = luo_file->private_data;
 
 		luo_file->fh->ops->unfreeze(&args);
 	}
-- 
2.52.0.460.gd25c4c69ec-goog


