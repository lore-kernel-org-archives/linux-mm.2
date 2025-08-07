Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A310C87FD3
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 01:45:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2E496B00AB; Wed,  6 Aug 2025 21:45:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E00B6B00AC; Wed,  6 Aug 2025 21:45:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 831E06B00AD; Wed,  6 Aug 2025 21:45:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 730666B00AB
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:45:15 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3F0F3BB95C
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:15 +0000 (UTC)
X-FDA: 83748268590.29.48E8410
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf11.hostedemail.com (Postfix) with ESMTP id 712EF40006
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BDQrGFNp;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754531113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5k1U17r+PzRIJkOEWEh69D1nNoyfvJ+I2xTfX4gnP+M=;
	b=vT+IZUYrW8k6uEkDv5JDXV7Mxn+ApRXHb2zKKD+98aeU78f5cbFH3nS9PuX/2wQXu7OyAE
	JkTvRqyywVd77qJWxeIGBJEqXOBlrL9pklrZvvL7wIocQXP6Xd8rtfwdhm2lPEL33oaCAT
	RmMU5dW71U2u5nruGqeR3fIb3BIJ5pU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BDQrGFNp;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754531113; a=rsa-sha256;
	cv=none;
	b=JQ6cjVwxwrtD5j2VpYJ2UUKAY7hxn32gYvMxPFqtizGOBmW4H2QspmV5tlFggRv7nzUIGY
	NsTUqEq09u1dKrfNMp+SjvAzx0y8cwuPZspSL+V3Q+YMwYLIhdjpucP+2NygZYtbaUz1i4
	7wF2MmYHNEDYrkczE5arG4kFdu1QVkU=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4b0a0870791so7513171cf.0
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 18:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754531112; x=1755135912; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5k1U17r+PzRIJkOEWEh69D1nNoyfvJ+I2xTfX4gnP+M=;
        b=BDQrGFNpNXghufaRIpCMejsq868tCgLoM7Kx/ui0FwBlo5PQy6fZv9bRKI061+mWXB
         pgKh3KxD8khS7HZ3veKx+cKcVRT2OkELsjTFMBNG48YSYvj5d4cVEjhOztQNzQlZHkfF
         PfFG2eEEj4GUQ8pyJ8DNlHYQIcYlViadX8GwIXzysVP2/TUjNtnt+Ml92d83mWiqsjDL
         5MsjJxZj0QnL69yub7MNXTdzWGTy7rotvxbIGxUdF5yD08CoaHR2GNnsA6RG5vXDvxmc
         /80RHxz2wkiTd15Xcxj1eY2F/R7Z6TWm/Z942zmjqvd20a4I5oCACxleDbCWLNcW0puz
         q61Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754531112; x=1755135912;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5k1U17r+PzRIJkOEWEh69D1nNoyfvJ+I2xTfX4gnP+M=;
        b=G3teXKfyjL2SHlb8WqsLdBi5QFF0OHO/q3IdcTigyU5sSVj20uy1ABTowNPPZheMIT
         wCDqN57jYCHGxaq8dy/d+tuK9vTn7FcHapIkUQAWMyG/ds/UsoBRgOybfSb/c+zOFbGQ
         7OBGmie2x46ijHxs2z9LrPbUNCazIvxARPfgdA9Jd8bliVhkvkYOr1q9DfMWXGmBOuSP
         3hCLqrNnJ2Mqi3qL5m6ZDnyqNwN9cfJcaw1NgGUj0DExL8LhdqF7ERBfStU3sJ2YvpE7
         2XFTkIol0R4oANHndGHKZxvaaGKfUumLSb4oPzH4cdu+Wf/oeqbmDeSNUR/DrOn8eQGp
         Q6sw==
X-Forwarded-Encrypted: i=1; AJvYcCVQdxkVk7o1yY73HM/fqz76UYcOmVthZA8X01X+shmXkl/9yVeZ2E3AJlDH9mPzfqZEJFpVh5Wv0A==@kvack.org
X-Gm-Message-State: AOJu0Yw5mWRAAYotasj1Dq3GQ/dvNaeIGmTS/Bn09Uf647313OY0hCoY
	DfkR5nVuMD5lhUwOOZxPgnz3Vc6cJ1OLT6yVvv3Su7AkAhir02kQlgBhB9P3ZgE6NkM=
X-Gm-Gg: ASbGnctVb+IWTj1XTi3faqs4RitLkOLr5jHHuk/ONoygv12zOCS8801qEl1HyTQ4D9C
	ifEf7IbhWn5LAqvP69TtUCJ+mKcjVpAhkGGoeR69UNXfjGQO/hRnx9EZ7N5VvKCWk4OL+1uxvkS
	nQkS9wgdM20jbY+o01YPNsigI2JJZrsNOt0Y5RFbqowCXWJUkxGKCvhZcpxomilgKQyd7u2dD3a
	t9Q+bHrwMIHIV8APMyjEpSLn+a57Zl9VmQlvGZduDz3gm8OGDpYJMX8v4vNZ1Wbgva0wqsuUFrm
	N7Q9YSbAvmvMdNGdQzWfyRQFDiGC5bbDYF9CChf0oZ4ahfAW+FxN9TlIbCdO3y7dZoJVjYdYSfx
	l7bVtq9YYCGWnrFFY9suLhwj2JALIFP+op2MmThdM+UwpXz0JlAx9ECbfH/eF9pu4ajooPlxTue
	muhlGrX/5y/OebkC/JkzdvVN0=
X-Google-Smtp-Source: AGHT+IFGhloL5+wAzqGLxdMTz2N8jTfQVk0LrudTV42eJiPSBl97ww3SO5T1gQQT1i9NRyGQ/H+ydQ==
X-Received: by 2002:a05:622a:10d:b0:4b0:7e72:9f05 with SMTP id d75a77b69052e-4b09157a420mr93793331cf.29.1754531112392;
        Wed, 06 Aug 2025 18:45:12 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077cde5a01sm92969046d6.70.2025.08.06.18.45.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 18:45:11 -0700 (PDT)
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
Subject: [PATCH v3 17/30] liveupdate: luo_files: luo_ioctl: Unregister all FDs on device close
Date: Thu,  7 Aug 2025 01:44:23 +0000
Message-ID: <20250807014442.3829950-18-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
In-Reply-To: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 712EF40006
X-Rspamd-Server: rspam06
X-Stat-Signature: hpgx3sinqbbjnuu6gnnc8syusc5w86cm
X-HE-Tag: 1754531113-757824
X-HE-Meta: U2FsdGVkX19zOSr5NmwZG89zwsU9u40VkxWkGcEyQLc90mqOcpSIcg6v6dIymRXvpPhpFFZuYE03yRWhG7f/7iPEczhbBuXtY+Ryir1NZp5idfpePFcQkXwaIJ5OM5Qk8KcfQM07CjWvgCap/i8VbmcqmvMwjCXmDpgVgu5KvXo6WS9I6LikhoHJqTmg1lwJwz0xoTfQDKBvvpN6Lj5jGEy06LIWOpcgaVrD05wsLXux47aZABwWcZBLlDzswGay7XysQjVAV+B3AF6fuySlcYviqCrDGuCOQ7d+9sK7nyNqDm0kKfnHdF0TU4mweI/paKKh+32FI+3v6xEal/6C+wTy2NSWq461SLNy4Um6s5+BM6K/keyuHtnwhSQRIuQpTsoK4drqOjCTeKhC3xomOMS99zbIhe2ZrqLE6OSJza9pQ0Bq80VSpM8fkwY8XtsK9/1molHcl4ZdrOXQrrhIJ2KRARAtiqKjR9ykGMaK2Fn2PCf12mX9yteHXReIzrtqJnAhOfC9RApuItMGPVIgLkvTsskZ2D5Q2eDSIgdXDj8wIy3vUyzOCYpgO/BMoeAmGN1YSwLa4mCcy1xXMhFGUGsmgvU4VoURHrwCJ5IUUccnOP8QIr/Op4G+l8Xwpzskh0ykHj4HV6AAKKK+kBN5nXJqUBh37Qr1C7713TbR3G/Sr0LeBRUkiMs4wPOUepM+BoV/Qw6h6dFYPFUn/YusQTLgcttbn0QV9wu7e8wLklNcZ9v+gpjjXufipI234pMj1Dp5Qym9JFoM/zKBszP+UhEDpSxfTV1iqymas7uK/wFFtkPKAI9JjMgdu9rhJ7KEOsyS4NlQRkpgrWmo4NgkEB47n5xVV8s2POR3bOdj8AuDGKS7p2SGP9W5jD4vYh9acH8UDAqu5t2PtJRMOdav2RMpKcR0OH/jgfcURc96ZQLgqnMSPAixy3TmWL4QWYnqBuX/lfHh/XuwucWuF3x
 Zwae+8BB
 qOhc+Iz+//K2sQ9ADFsPV6KCCuH/Qa5E6g5W2D0LRMByNu3SrrXYeYU2pdTvm8nz3ridU4Xv5qd6mvucIcp/GUscOMvyVHV/Alrnzk61xNEb1zMy1/GcOVfugNOTWq/ilqH0gHiuNsegRlQ+ABRMDaps5QkTOzGs/NSCoLlaMKH82WYls02FuquYkj9eFlZOmRZzrn9V/FeAZ4N5f0UPibGf47mOaY/+pw7CHPtEZVkXRCDok21m3dEB6Vv6ZZ0GNX+zCFxnd6/tmdu8bXe8Grby3ReolltruZrCm0aUlDiqxSIbwDOdT3vpUfAmovPfcLKAzQc/Y4jxtc++Gb+f5u7N49lhJHcDSpl4P+4LnX3EIZb0dk8FuYgRMOiuTxSppzPVQDIsDJq1qGTQfK7DREHyto/x3cNPk3kp5JiLkexjfQiJu7Ti7qaCACgFzyquQQNM0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, a file descriptor registered for preservation via the remains
globally registered with LUO until it is explicitly unregistered. This
creates a potential for resource leaks into the next kernel if the
userspace agent crashes or exits without proper cleanup before a live
update is fully initiated.

This patch ties the lifetime of FD preservation requests to the lifetime
of the open file descriptor for /dev/liveupdate, creating an implicit
"session".

When the /dev/liveupdate file descriptor is closed (either explicitly
via close() or implicitly on process exit/crash), the .release
handler, luo_release(), is now called. This handler invokes the new
function luo_unregister_all_files(), which iterates through all FDs
that were preserved through that session and unregisters them.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_files.c    | 19 +++++++++++++++++++
 kernel/liveupdate/luo_internal.h |  1 +
 kernel/liveupdate/luo_ioctl.c    |  1 +
 3 files changed, 21 insertions(+)

diff --git a/kernel/liveupdate/luo_files.c b/kernel/liveupdate/luo_files.c
index 33577c9e9a64..63f8b086b785 100644
--- a/kernel/liveupdate/luo_files.c
+++ b/kernel/liveupdate/luo_files.c
@@ -721,6 +721,25 @@ int luo_unregister_file(u64 token)
 	return ret;
 }
 
+/**
+ * luo_unregister_all_files - Unpreserve all currently registered files.
+ *
+ * Iterates through all file descriptors currently registered for preservation
+ * and unregisters them, freeing all associated resources. This is typically
+ * called when LUO agent exits.
+ */
+void luo_unregister_all_files(void)
+{
+	struct luo_file *luo_file;
+	unsigned long token;
+
+	luo_state_read_enter();
+	xa_for_each(&luo_files_xa_out, token, luo_file)
+		__luo_unregister_file(token);
+	luo_state_read_exit();
+	WARN_ON_ONCE(atomic64_read(&luo_files_count) != 0);
+}
+
 /**
  * luo_retrieve_file - Find a registered file instance by its token.
  * @token: The unique token of the file instance to retrieve.
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 5692196fd425..189e032d7738 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -37,5 +37,6 @@ void luo_do_subsystems_cancel_calls(void);
 int luo_retrieve_file(u64 token, struct file **filep);
 int luo_register_file(u64 token, int fd);
 int luo_unregister_file(u64 token);
+void luo_unregister_all_files(void);
 
 #endif /* _LINUX_LUO_INTERNAL_H */
diff --git a/kernel/liveupdate/luo_ioctl.c b/kernel/liveupdate/luo_ioctl.c
index 6f61569c94e8..7ca33d1c868f 100644
--- a/kernel/liveupdate/luo_ioctl.c
+++ b/kernel/liveupdate/luo_ioctl.c
@@ -137,6 +137,7 @@ static int luo_open(struct inode *inodep, struct file *filep)
 
 static int luo_release(struct inode *inodep, struct file *filep)
 {
+	luo_unregister_all_files();
 	atomic_set(&luo_device_in_use, 0);
 
 	return 0;
-- 
2.50.1.565.gc32cd1483b-goog


