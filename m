Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDEB4CEBF88
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 23:34:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7610C8E0022; Sat, 15 Nov 2025 18:34:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6507C8E0007; Sat, 15 Nov 2025 18:34:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C7F68E0022; Sat, 15 Nov 2025 18:34:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 33CFE8E0007
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 18:34:52 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EAA6EC078E
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 23:34:51 +0000 (UTC)
X-FDA: 84114448782.02.FADF48B
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf09.hostedemail.com (Postfix) with ESMTP id 20413140004
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 23:34:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=FZNTVnWl;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763249690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VyQXl7tWXRV/YETkSwjN2Plb4i1qeg0xlo6fhXkHNVA=;
	b=DXFc0cjJJMiDrCKWv89eWlOIcTw5Xrh1fEBX8rt/8YQUCTMVDaLogwImcApDRshrZKtneO
	Jp0P6gqTvgdxhsLL2Inyn0HjE12w09ucd0HfpHoapq3+t/wseqcPRuabhJEam386S7Mi5p
	sD16es/ZrKAiDVUVv3WWtK/nO3z3unM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763249690; a=rsa-sha256;
	cv=none;
	b=bZrl0O6FCk+Qub0HXlLPbN0mj8KoNI2ws9GsxPngxf9h6HlAMJCOqDNZaMLh0Hk8RerKoA
	Vp259y4mFv7cVoHedhMd/fZ8kMdo/VS3rXqRYX+xMjqei4/dInlUbXS6z/oVnW00v2Xu1B
	MzTg3hz+s5juYR476eB2Hg9LNq3lqGs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=FZNTVnWl;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-71d71bcab6fso28794107b3.0
        for <linux-mm@kvack.org>; Sat, 15 Nov 2025 15:34:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763249689; x=1763854489; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VyQXl7tWXRV/YETkSwjN2Plb4i1qeg0xlo6fhXkHNVA=;
        b=FZNTVnWlUSLgQTKCFTIkPD/x4cpJH+8LuUhSiLwDSh8QEyiVenjp5dQIH92tzxRT+/
         V9Cf/4HBV5f/R2McQY44NDIMsvWWDckC3l0JY6iqQN+kGh7MBcv7gn/qsG8yc+51QSxb
         +GVAfKbxN4TZwk7eNukPhAsgzZcE3tNeQ2Ny5rYMXGoClLcH7dIDieB4pXxemJseBLTX
         NJarGQX6f3LRJ9gFgUKWvNkeST76FXOV5vj2Q1dMtXRcwKQerAXiLNvdGW2lAayH1e+o
         n+rarzR5t5mycPa6R8R1QcnszmmqtKEdU26rNpBTW5YdMdOWomzv2vVDiYalk+sk6GWW
         bHSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763249689; x=1763854489;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VyQXl7tWXRV/YETkSwjN2Plb4i1qeg0xlo6fhXkHNVA=;
        b=F6r5N1nWCAe/1/8P0nRzWOY8gEMEqLS+RvebHa+WcVCB+eA6NkVRkbrnnvw4gaacj7
         Qk3HIaTvxk691mb9ytGxTvhRKaFwPq1I1Ah40nQ6EdOFml+Y5ahiLlcjbmdi9zJYW+ME
         Jn2EJ239G6FdGhKUkagvmu7dzZQSpWdsQWKM6NTvy/o/SiiUmO3qulCsAsMFFxl+kcXN
         gks6LH8wn9YdavEroPV2HAVH+kiIZXNGE4kWVUiDt49nA6PBmtt0hTyO2KESDLlH1eLC
         xB2n/wYmq4dQ1SAp7Pjps6GwK08Kq+/tFOCHjm4TR+3Vj+fV1TteK8POe3qCOYjSrhJT
         foHQ==
X-Forwarded-Encrypted: i=1; AJvYcCUahvZwcyQXxrCGr5VEOviUiWjtxWvmVRVcZcnB5niYzGa5h6U9XL1V/VYt6q+qaLjTWXeKbxt3ig==@kvack.org
X-Gm-Message-State: AOJu0YzRJd5y63xuhXmAgqQapKtk4ppgIERo3GFo92pzO+Mk/3/uLvIL
	TavbdPok4WCXkGGYVn0vGEaLz3TtRNSJehJiJ/wKzoZTzNSW1VQBRypjpJoG/IA6Tvo=
X-Gm-Gg: ASbGncu5VRYvA0obwUDqmY9hzf/m6iYk8VyGFUjXVVPX8AdP6dhMJhqNcbjrTcQg/9o
	wnYCtiDiGncSKhTC9W9mfHrZM6OjxjgXs3Law6ci3/7ILaLIfL7iJZZpmtu1YRFXcFSDSRrPFxm
	8PCeqhQRfj4uL5RmQlfspI+9irSCYIIT50BXz220JlK6/Ss1VvgmN97RyQTYNF2vRdYwPtbq8vB
	jSXuzcpFUlVEGC++dj3Yihb0u+ZtCF3rrxXYksqvYy6LUmZRV4S1kPqv2zQypmj2UvyE8X2U82q
	GfNQ4VICzhsIligsZJLRKfY0/SzfNHL2utzskFdwjGdX0knBrt/4QP4m8UKgOnv77uSMfAzBNlu
	zSfTf4UMKWYK5CDw6lxvujyCGGQojH5wClYSNX6hnQrETfkHEBmSFvYQ1ChkBjLx6XVJh0olpco
	jZOG6IeKSOyL8HdN8atZRQh9ryRbymZmg8uoWTG95yBfUeSYK6xiIO/z/XlsIHkUAY1Av2
X-Google-Smtp-Source: AGHT+IEy3rWCZZa0SeOLBQxT1yFnRWPZjFkRUtPU+kVtuy5howb5ZMUGXRB8KQbRbOWcLX2jr1XF1w==
X-Received: by 2002:a05:690c:a003:b0:788:161c:722e with SMTP id 00721157ae682-78929e81770mr63042867b3.26.1763249689113;
        Sat, 15 Nov 2025 15:34:49 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7882218774esm28462007b3.57.2025.11.15.15.34.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Nov 2025 15:34:48 -0800 (PST)
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
Subject: [PATCH v6 14/20] liveupdate: luo_file: add private argument to store runtime state
Date: Sat, 15 Nov 2025 18:34:00 -0500
Message-ID: <20251115233409.768044-15-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251115233409.768044-1-pasha.tatashin@soleen.com>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yco5a9hgwq9pmbuhbg4gu46fptayr4xb
X-Rspam-User: 
X-Rspamd-Queue-Id: 20413140004
X-Rspamd-Server: rspam10
X-HE-Tag: 1763249689-448822
X-HE-Meta: U2FsdGVkX1+bqgaiJ/iSC82ZbGgfpQuBUmp2O4ckxUYBL8yC+m4p71S1CUQTW4+JgCSFAF0gNptKveB5MFoTaUFBVKKrZdb869Csp+1s9xJI85Yjtx07CKDuTowkon9x6G+KfRC9LdmGa9NHci/Ezen6hxdDNB2nj6kZWqg+fdVe4jAobqR9m+KsxxDWvKfio6BKQjNEfqwoO2e4ytSXEVbzwz5QqHkqNOK/n22RGNs47D9XAD0l8tVoQSU+4U/Otc/KUL6BlZNTFHZqC6tAux8KNzwSnVe176WsGqdiZiROZnokFTlRwjb2Wfb/jaliQW1iMXANmvQnugLtUJBWs7ktjeGwYY6Vv7P0c12AQgfTPsQA6TSwnzvgv6jKx5d/n4veNw9WfhC5q7nOTiXmyD97Sl3RDxYIm1/iJTSBJSeKMjupLmPbavP8XYvoXo8+lpPG/kbb84DidTBZgQ+SIcfKAoddTLAxzcV87ejVld8Pt/RtgwlgsxhUSm8eZsSriqUFXajUvbcFznwNGgua4yqOy3lIAV6PIov8qx7SoeOZonTD7gmhkcbLctowKiSeeWedR4y824yi50Nu5YroTUNc039ro0/p6wPNYmId7uDeARHkGIEQFeOCJ5lJ6i1vHGFMQWUdPvWotxlpp+s1XSHxkmog3xGpfDyy59gO9erAbfQVqTPyw0QJ1GX8azwpvm8cOOTQDuLk25g7gDf7xV38eLaVpWkd9DH2o3jsXJUVI8zwt4gPjFo+dwmrHzchOYbWHlaDMLviSe/QwMo32MgqIvmeyx3Y1fupRa77rJmBZ/gW24R7OgI3EHawDFoexSKkXgycM8Pu0rx3Tr4LRbG8A0t+9WOJdlWbMvW/V3MB95hUUrkgbsf/ak0/WMsdHpZKa6ngG/R0/+oskeW23emzIpDn79bPNKUzDEQU5617330eYMvppGfAw43yOeE1yLGUcH9Y+DiOzoAlC7f
 Q9fU1RT1
 LLnNch7aLfFuyA51p65wUshay/46Hdd3E4I/yQBO6tIZa/4j8wdMA7OvaS0kEFz3fddSJcznKJX5qd7OfLmtH63w6A9byAAxw4ccEPaiP2DP+6i6iX0xZVNrs2X4X4QwkIbbUqwy5nfY03ZeZY7EIu+zr2PjA3jqi8R1+uCHwNIqaYsm4beItNBBFLKp4BBOKVz3rRM1FntYGu8cS6M8mBek5XgtIWBH57rgp+XKP5DSxwU+nXmdw8KC+SnYzBte8qy2rlBoI9nQ7m3nPYqPee2wa80+gmANMQOWmtMy8LSEZoCLG3eEiLtkBU5Z0Te1cEJSogsSloQPBqcdc9qmnN2zdU5aiwpsiG2NClrJWreB10ojhR6puciEGSjp/z5i7UJGoQ1qsFWNingFRMKkgH01baE8vhtb3CE2cib3IMnuEt44lSrEWGJQIQQ==
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
index 36a831ae3ead..defc69a1985d 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -29,6 +29,10 @@ struct file;
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
@@ -39,6 +43,7 @@ struct liveupdate_file_op_args {
 	bool retrieved;
 	struct file *file;
 	u64 serialized_data;
+	void *private_data;
 };
 
 /**
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 3d3bd84cb281..df337c9c4f21 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -126,6 +126,10 @@ static LIST_HEAD(luo_file_handler_list);
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
@@ -152,6 +156,7 @@ struct luo_file {
 	struct liveupdate_file_handler *fh;
 	struct file *file;
 	u64 serialized_data;
+	void *private_data;
 	bool retrieved;
 	struct mutex mutex;
 	struct list_head list;
@@ -309,6 +314,7 @@ int luo_preserve_file(struct luo_session *session, u64 token, int fd)
 		goto exit_err;
 	} else {
 		luo_file->serialized_data = args.serialized_data;
+		luo_file->private_data = args.private_data;
 		list_add_tail(&luo_file->list, &session->files_list);
 		session->count++;
 	}
@@ -356,6 +362,7 @@ void luo_file_unpreserve_files(struct luo_session *session)
 		args.session = (struct liveupdate_session *)session;
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
+		args.private_data = luo_file->private_data;
 		luo_file->fh->ops->unpreserve(&args);
 		luo_flb_file_unpreserve(luo_file->fh);
 
@@ -384,6 +391,7 @@ static int luo_file_freeze_one(struct luo_session *session,
 		args.session = (struct liveupdate_session *)session;
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
+		args.private_data = luo_file->private_data;
 
 		err = luo_file->fh->ops->freeze(&args);
 		if (!err)
@@ -405,6 +413,7 @@ static void luo_file_unfreeze_one(struct luo_session *session,
 		args.session = (struct liveupdate_session *)session;
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
+		args.private_data = luo_file->private_data;
 
 		luo_file->fh->ops->unfreeze(&args);
 	}
-- 
2.52.0.rc1.455.g30608eb744-goog


