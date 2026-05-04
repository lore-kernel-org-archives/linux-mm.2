Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DD26FF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 23:36:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBA566B008A; Mon,  4 May 2026 19:36:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E92E86B008C; Mon,  4 May 2026 19:36:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5A386B0092; Mon,  4 May 2026 19:36:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C03896B008A
	for <linux-mm@kvack.org>; Mon,  4 May 2026 19:36:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 67A121602F6
	for <linux-mm@kvack.org>; Mon,  4 May 2026 23:36:33 +0000 (UTC)
X-FDA: 84731349066.23.350E81F
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9EC26180004
	for <linux-mm@kvack.org>; Mon,  4 May 2026 23:36:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jNHf1Qre;
	spf=pass (imf24.hostedemail.com: domain of 3fi35aQ0KCBUvw23D2z5wvAvE19916z.x97638FI-775Gvx5.9C1@flex--abhishekbapat.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3fi35aQ0KCBUvw23D2z5wvAvE19916z.x97638FI-775Gvx5.9C1@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777937791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=08AQr2uL2/ZNq+SW+24c1u9Obl8u2hOTuInIp2FYA2Y=;
	b=MSgojAHPsik/K1Sv2XyfSn+kl6hJ9vLxkVqRSaSHsi7FTc29wWWAhz11WHeHX7rS+E5aLq
	CdUMbgtf1hlPfhEzoubzwinxdpN00QPpVIMH6R6oLiuug2Qml4LzJzt7qy+3R3vviyGYzk
	WinyXTzkFgjLBDtihiytU5cUxATBlZo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jNHf1Qre;
	spf=pass (imf24.hostedemail.com: domain of 3fi35aQ0KCBUvw23D2z5wvAvE19916z.x97638FI-775Gvx5.9C1@flex--abhishekbapat.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3fi35aQ0KCBUvw23D2z5wvAvE19916z.x97638FI-775Gvx5.9C1@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777937791; a=rsa-sha256;
	cv=none;
	b=lzFrLAyPkh32aIo1N9J2GVLNh9tNWa9noWokoiL8sUZ9DTOKHQJSlLDQC0qV3KqflrKNfC
	TUSIE/vlYPpjnv2o+xWZta3ibeIHvgjfnaLS46g5IpxyNOk0vFTmCQvb1bnjY2+4ojg/r9
	Yov2OhES5yIN2yew6zoB7znANR7OOI4=
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2f3eb8f3419so1455799eec.1
        for <linux-mm@kvack.org>; Mon, 04 May 2026 16:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777937790; x=1778542590; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=08AQr2uL2/ZNq+SW+24c1u9Obl8u2hOTuInIp2FYA2Y=;
        b=jNHf1Qrejb8wVIUnufGWJsT1oVvLjaHyZkipt9S9uE17jw3Gm5QeBs18YW2k2MTs5j
         tDDgYgpddwZ8xYa8AI1whBB7vsLLenRgbYyKSK19lmpJKdt2Dqn5Sg09v/7AzwSuJk/N
         YK2yMh40XgE4059VuZllPMjSONokeTLvaqVS7JiPinVkP0dMtWmVt/IfWI1SMXCHGRXJ
         S64QV0Wfp9VG+694lClxWebkLT2Nv3KcJJV1DUYAjvb1M7donSRxy4nadNaraX63kcBw
         tSVGYXAxqV0LiU8Cr7GIIJooK4+tkajF75tCYlf85hnfi0Ek3vXfqJJeuLjf6nzKsZlw
         J/hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777937790; x=1778542590;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=08AQr2uL2/ZNq+SW+24c1u9Obl8u2hOTuInIp2FYA2Y=;
        b=EssMWaK2ZnJoI6rUX0dABVX4vFIGb2+Ng0/7e0ibg12Xx6Y5JLVx4xswQpmjkqeeF/
         SaFPpHZICj86dzb78OhY/cIkS62Bc0qfo9QA52HvrAu64giIytarzpswK0QGmJ8X0uTX
         Cz1kFyuwXDkU+epoo5vqT8AxGf4BY3niB0HqXRRyDK3MrX05gXUV2KJ3c1GEspGGUsuO
         UnvV87l6eedkEwBPp7cDXxqAS/e3z82JOhEBva1aQzr3CM3uGwyoQSJ93DjXfG6guZCX
         EVtbSrhU9VeyMuTN9W9FeUj7kk46qLazGtAkPmRuXa4BYqJN6R7x40fyjv5b4z3wPk2h
         yKNQ==
X-Forwarded-Encrypted: i=1; AFNElJ+V1/eLOHBCBqr3wduk6Z0/566wq0bb2LfpofN3XK33yHAtAkPfKHLGSIOSudkz3IZ74mfRzAk4Kw==@kvack.org
X-Gm-Message-State: AOJu0YxrlWimkTKsVqUSY0RpyqX8Mc/zzKBEd2DO9O5gPZilg/osQMAE
	jD8IFhQHCup3xRtQB5+ionmYed+DCnfbASnL8UgFkD/eONbQdlmpg0EHGQDZrbptO0dNdk4+YOg
	auSbuJn+W6RT0pZ/Y94J2UlCiUi4Okl3pGQ==
X-Received: from dybbs42.prod.google.com ([2002:a05:7300:a22a:b0:2ee:2c3a:8aaf])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:43:b0:12c:2e07:3fd with SMTP id a92af1059eb24-130b1c6d589mr516965c88.32.1777937790210;
 Mon, 04 May 2026 16:36:30 -0700 (PDT)
Date: Mon,  4 May 2026 23:36:19 +0000
In-Reply-To: <cover.1777936301.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1777936301.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <d064a1a8de127c0e321f675a9966e533a0917e7e.1777936301.git.abhishekbapat@google.com>
Subject: [PATCH 1/6] alloc_tag: add ioctl to /proc/allocinfo
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 9EC26180004
X-Rspamd-Server: rspam06
X-Stat-Signature: gs7dxmd9ozc4io1133xzmfwru1wij61e
X-HE-Tag: 1777937791-683272
X-HE-Meta: U2FsdGVkX18FwysW0GiwFPqUe4zh2o9tZvmUCEOJ0Ze4AvwNqDPauC0Dqb4Cui+JFbUBKmh3dZ76aWsePYpiCUTFXL6SvpXvxHDYFf/s1dcQkYycm8PJ3PCzPa3uvd+gVp0OkUubu5ox/h1p24CSdPMvGHC1jnVmL2dQPa4XDhL8Tsn2hJaMFPLjmvwMemoy5pZkVhbon6lrdQGgejNuiv3oWPg/rL0SuPwh1v5CzAGoLsogBBJeM7XKBuV9yAq3rQ89gE35nfGhrnIsqMSlI+gGeF6D6Yo5RK8QAk+cD6UEn4czQVG3wo1YdyG6R8Tnl7yAC+pJ3uORTC5MgG81z1FxdFHZMtkkE1O0c2YFVHkPaZjdEyp6XneVdg/J9rQXThzUlpOGIGXdNz/f1SboETuP0sKj/ozaSBZxLotqn0dD4x9X82UyrH8yBywk9llIE2ZCBCrdl3r0JKfNX0HGMcPwQ5sdtlmurU+ZiCWhEvHjZeZdrtwqWL1WHY/mQz668Nr2cwsnHjNeRpdPMkSW/2kQcsHCS533qpwbcYVmhO1fkSjI2gJlDDHQwsv2uMmv1SZKkwrG4IrKIxKlJfxHRSYDGKTxLvtSg008iK2PFwIUgJm35b0YRpqiZXV+A976+5U1BkrY4jaB/nqD+Ov3fBByt/Ee9WU033JmNDwSdMZhaPXswglIT/7xnkHzJtLrIRAuETvwHfwcTkSfVLkIweRzbU6nBC8avRGbUvBBv+lQIzhCfljsC6LG0GVBRaKLC1ktvvhScbASTVTRhm6QwYX4b0tYWPA1GZAWbC/z/pH+fHYDIWaB0PIL0QR3kQXMMunpA/4Y/iampiq2vA59d2i+BvyV6iIURTwVJ4saK1zDX/m7tJGlzO4SBJ6M4aa/3fcmIhMaxsTy5oHzXcjf5V8gD3A37Ug1TlFlDBJFYZGwgHXoMo5g2hkRvfS0zmaVaUULT4VICUYXUh/K8hi
 mWXKF98i
 eJcKjgRwjx7cwZGVbnRQnQ9JAOkHrEZEkdeFfRz2y7OcSc4PJfewu38sTUullKJYyUENGaIog+heqF6YglKb/sBYzPFboaljaAq5guNBci7ZT5VZiLu7TeHwpkaK3DXrJTQWUJJZRPwUN+aV7WgVW2kUUPWQ8y1A0i8XejiicM+YSW/NoidzouxBEr+78ggObevQvrwsKXgEPBBO/r5uqMw3t9q7HFg3pQa7gjHrU3rBfSTjSofbMT99B1ogoLvuj3QYzKfkUEGCEgHb8/SdXTLsDREfkr9mXpapAJslbKY1aMKi2Uty54KSVm89YquPhbG2iYB0YNsI9+cStUNSTcgD5PO8OJ2NmSU3vJZFjHbChwo11rolVZJ8wF3YtR7gr7u9gT5mTMFH8tQvoY3f9+3NO1RmQ3NfiXAjwxcJ2PaqVsvA3E+5Mzm6UdKARzl5pS4ireZNmox7tMa8uSls4NOQUkBv6vcdjUfLdlKxBAulz/EkxXHsNM2k3dbO5UoTA3G+1PBACxxMmtSyBt5Lch4LVL7+q44MXC4Vz4TCtOyiC95wS8LHCXpBlg7bjgxCRVXYiFteRr1uVdKcDkbL9fVbCCgkuvjC72qKn+ZafnTFt67B7NoNYfJM1P6M3cF1S8bpIIdbXrz5lkmC8FuuBmIDDXhHJ6HTQVEaIwtOg/DYs1HVad2MOZ3QMn3JAt0Sn/fIY1eARXn3QPUGvhxW8nZCe577CjpWrolCwL3DrnqOyKgRj3en1eGS/dA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Suren Baghdasaryan <surenb@google.com>

Add the following ioctl commands for /proc/allocinfo file:

ALLOCINFO_IOC_CONTENT_ID - gets content identifier which can be used
to check whether the file content has changed specifically due to module
load/unload. Every time a module is loaded / unloaded, the returned
value will be different. By comparing the identifier value at the
beginning and at the end of the content retrieval operation, users can
validate retrieved information for consistency.

ALLOCINFO_IOC_GET_AT - gets the record at the specified position. This
is the position of a record in /proc/allocinfo.

ALLOCINFO_IOC_GET_NEXT - gets the record next to the last retrieved
one. If no records were previously retrieved, returns the first
record.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
---
 .../userspace-api/ioctl/ioctl-number.rst      |   2 +
 include/linux/codetag.h                       |   1 +
 include/uapi/linux/alloc_tag.h                |  54 ++++++
 lib/alloc_tag.c                               | 178 +++++++++++++++++-
 lib/codetag.c                                 |  11 ++
 5 files changed, 244 insertions(+), 2 deletions(-)
 create mode 100644 include/uapi/linux/alloc_tag.h

diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
index 331223761fff..84f6808a8578 100644
--- a/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -349,6 +349,8 @@ Code  Seq#    Include File                                             Comments
                                                                        <mailto:luzmaximilian@gmail.com>
 0xA5  20-2F  linux/surface_aggregator/dtx.h                            Microsoft Surface DTX driver
                                                                        <mailto:luzmaximilian@gmail.com>
+0xA6  00-0F  uapi/linux/alloc_tag.h                                    Memory allocation profiling
+                                                                       <mailto:surenb@google.com>
 0xAA  00-3F  linux/uapi/linux/userfaultfd.h
 0xAB  00-1F  linux/nbd.h
 0xAC  00-1F  linux/raw.h
diff --git a/include/linux/codetag.h b/include/linux/codetag.h
index 8ea2a5f7c98a..2bcd4e7c809e 100644
--- a/include/linux/codetag.h
+++ b/include/linux/codetag.h
@@ -76,6 +76,7 @@ struct codetag_iterator {
 
 void codetag_lock_module_list(struct codetag_type *cttype, bool lock);
 bool codetag_trylock_module_list(struct codetag_type *cttype);
+unsigned long codetag_get_content_id(struct codetag_type *cttype);
 struct codetag_iterator codetag_get_ct_iter(struct codetag_type *cttype);
 struct codetag *codetag_next_ct(struct codetag_iterator *iter);
 
diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
new file mode 100644
index 000000000000..e9a5b55fcc7a
--- /dev/null
+++ b/include/uapi/linux/alloc_tag.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ *  include/linux/alloc_tag.h
+ */
+
+#ifndef _UAPI_ALLOC_TAG_H
+#define _UAPI_ALLOC_TAG_H
+
+#include <linux/types.h>
+
+#define ALLOCINFO_STR_SIZE	64
+
+struct allocinfo_content_id {
+	__u64 id;
+};
+
+struct allocinfo_tag {
+	/* Longer names are trimmed */
+	char modname[ALLOCINFO_STR_SIZE];
+	char function[ALLOCINFO_STR_SIZE];
+	char filename[ALLOCINFO_STR_SIZE];
+	__u64 lineno;
+};
+
+struct allocinfo_counter {
+	__u64 bytes;
+	__u64 calls;
+	__u8 accurate;
+	__u8 pad[7]; /* Add alignment to not break the 32-bit compatible interface */
+};
+
+struct allocinfo_tag_data {
+	struct allocinfo_tag tag;
+	struct allocinfo_counter counter;
+};
+
+struct allocinfo_get_at {
+	__u64 pos;	/* input */
+	struct allocinfo_tag_data data;
+};
+
+#define _ALLOCINFO_IOC_CONTENT_ID	0
+#define _ALLOCINFO_IOC_GET_AT		1
+#define _ALLOCINFO_IOC_GET_NEXT		2
+
+#define ALLOCINFO_IOC_BASE		0xA6
+#define ALLOCINFO_IOC_CONTENT_ID	_IOR(ALLOCINFO_IOC_BASE, _ALLOCINFO_IOC_CONTENT_ID,	\
+					     struct allocinfo_content_id)
+#define ALLOCINFO_IOC_GET_AT		_IOWR(ALLOCINFO_IOC_BASE, _ALLOCINFO_IOC_GET_AT,	\
+					      struct allocinfo_get_at)
+#define ALLOCINFO_IOC_GET_NEXT		_IOR(ALLOCINFO_IOC_BASE, _ALLOCINFO_IOC_GET_NEXT,	\
+					     struct allocinfo_tag_data)
+
+#endif /* _UAPI_ALLOC_TAG_H */
diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index ed1bdcf1f8ab..5c24d2f954d4 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -14,6 +14,7 @@
 #include <linux/string_choices.h>
 #include <linux/vmalloc.h>
 #include <linux/kmemleak.h>
+#include <uapi/linux/alloc_tag.h>
 
 #define ALLOCINFO_FILE_NAME		"allocinfo"
 #define MODULE_ALLOC_TAG_VMAP_SIZE	(100000UL * sizeof(struct alloc_tag))
@@ -46,6 +47,9 @@ int alloc_tag_ref_offs;
 struct allocinfo_private {
 	struct codetag_iterator iter;
 	bool print_header;
+	/* ioctl uses a separate iterator not to interfere with reads */
+	struct codetag_iterator ioctl_iter;
+	bool positioned; /* seq_open_private() sets to 0 */
 };
 
 static void *allocinfo_start(struct seq_file *m, loff_t *pos)
@@ -125,6 +129,177 @@ static const struct seq_operations allocinfo_seq_op = {
 	.show	= allocinfo_show,
 };
 
+static int allocinfo_open(struct inode *inode, struct file *file)
+{
+	return seq_open_private(file, &allocinfo_seq_op,
+				sizeof(struct allocinfo_private));
+}
+
+static int allocinfo_release(struct inode *inode, struct file *file)
+{
+	return seq_release_private(inode, file);
+}
+
+static const char *allocinfo_str(const char *str)
+{
+	size_t len = strlen(str);
+
+	/* Keep an extra space for the trailing NULL. */
+	if (len >= ALLOCINFO_STR_SIZE)
+		str += (len - ALLOCINFO_STR_SIZE) + 1;
+	return str;
+}
+
+/* Copy a string and trim from the beginning if it's too long */
+static void allocinfo_copy_str(char *dest, const char *src)
+{
+	strscpy(dest, allocinfo_str(src), ALLOCINFO_STR_SIZE);
+}
+
+static void allocinfo_to_params(struct codetag *ct,
+				struct allocinfo_tag_data *data)
+{
+	struct alloc_tag *tag = ct_to_alloc_tag(ct);
+	struct alloc_tag_counters counter = alloc_tag_read(tag);
+
+	if (ct->modname)
+		allocinfo_copy_str(data->tag.modname, ct->modname);
+	else
+		data->tag.modname[0] = '\0';
+	allocinfo_copy_str(data->tag.function, ct->function);
+	allocinfo_copy_str(data->tag.filename, ct->filename);
+	data->tag.lineno = ct->lineno;
+	data->counter.bytes = counter.bytes;
+	data->counter.calls = counter.calls;
+	data->counter.accurate = !alloc_tag_is_inaccurate(tag);
+}
+
+static int allocinfo_ioctl_get_content_id(struct seq_file *m, void __user *arg)
+{
+	struct allocinfo_content_id params;
+
+	codetag_lock_module_list(alloc_tag_cttype, true);
+	params.id = codetag_get_content_id(alloc_tag_cttype);
+	codetag_lock_module_list(alloc_tag_cttype, false);
+	if (copy_to_user(arg, &params, sizeof(params)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
+{
+	struct allocinfo_private *priv;
+	struct codetag *ct;
+	__u64 pos;
+	struct allocinfo_get_at params = {0};
+
+	if (copy_from_user(&params, arg, sizeof(params)))
+		return -EFAULT;
+
+	priv = (struct allocinfo_private *)m->private;
+	pos = params.pos;
+
+	codetag_lock_module_list(alloc_tag_cttype, true);
+
+	/* Find the codetag */
+	priv->ioctl_iter = codetag_get_ct_iter(alloc_tag_cttype);
+	ct = codetag_next_ct(&priv->ioctl_iter);
+	while (ct && pos--)
+		ct = codetag_next_ct(&priv->ioctl_iter);
+	if (ct) {
+		allocinfo_to_params(ct, &params.data);
+		priv->positioned = true;
+	}
+
+	codetag_lock_module_list(alloc_tag_cttype, false);
+
+	if (!ct)
+		return -ENOENT;
+
+	if (copy_to_user(arg, &params, sizeof(params)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
+{
+	struct allocinfo_private *priv;
+	struct codetag *ct;
+	struct allocinfo_tag_data params = {0};
+	int ret = 0;
+
+	priv = (struct allocinfo_private *)m->private;
+
+	codetag_lock_module_list(alloc_tag_cttype, true);
+
+	if (!priv->positioned) {
+		priv->ioctl_iter = codetag_get_ct_iter(alloc_tag_cttype);
+		priv->positioned = true;
+	}
+
+	ct = codetag_next_ct(&priv->ioctl_iter);
+	if (ct)
+		allocinfo_to_params(ct, &params);
+
+	if (!ct) {
+		priv->positioned = false;
+		ret = -ENOENT;
+	}
+	codetag_lock_module_list(alloc_tag_cttype, false);
+
+	if (ret == 0) {
+		if (copy_to_user(arg, &params, sizeof(params)))
+			return -EFAULT;
+	}
+	return ret;
+}
+
+static long allocinfo_ioctl(struct file *file, unsigned int cmd,
+			    unsigned long __arg)
+{
+	void __user *arg = (void __user *)__arg;
+	int ret;
+
+	switch (cmd) {
+	case ALLOCINFO_IOC_CONTENT_ID:
+		ret = allocinfo_ioctl_get_content_id(file->private_data, arg);
+		break;
+	case ALLOCINFO_IOC_GET_AT:
+		ret = allocinfo_ioctl_get_at(file->private_data, arg);
+		break;
+	case ALLOCINFO_IOC_GET_NEXT:
+		ret = allocinfo_ioctl_get_next(file->private_data, arg);
+		break;
+	default:
+		ret = -ENOIOCTLCMD;
+		break;
+	}
+
+	return ret;
+}
+
+#ifdef CONFIG_COMPAT
+static long allocinfo_compat_ioctl(struct file *file, unsigned int cmd,
+				   unsigned long arg)
+{
+	return allocinfo_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
+}
+#endif
+
+static const struct proc_ops allocinfo_proc_ops = {
+	.proc_open		= allocinfo_open,
+	.proc_read_iter		= seq_read_iter,
+	.proc_lseek		= seq_lseek,
+	.proc_release		= allocinfo_release,
+	.proc_ioctl		= allocinfo_ioctl,
+#ifdef CONFIG_COMPAT
+	.proc_compat_ioctl	= allocinfo_compat_ioctl,
+#endif
+
+};
+
 size_t alloc_tag_top_users(struct codetag_bytes *tags, size_t count, bool can_sleep)
 {
 	struct codetag_iterator iter;
@@ -946,8 +1121,7 @@ static int __init alloc_tag_init(void)
 		return 0;
 	}
 
-	if (!proc_create_seq_private(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_seq_op,
-				     sizeof(struct allocinfo_private), NULL)) {
+	if (!proc_create(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_proc_ops)) {
 		pr_err("Failed to create %s file\n", ALLOCINFO_FILE_NAME);
 		shutdown_mem_profiling(false);
 		return -ENOMEM;
diff --git a/lib/codetag.c b/lib/codetag.c
index 304667897ad4..93aa30991563 100644
--- a/lib/codetag.c
+++ b/lib/codetag.c
@@ -48,6 +48,17 @@ bool codetag_trylock_module_list(struct codetag_type *cttype)
 	return down_read_trylock(&cttype->mod_lock) != 0;
 }
 
+unsigned long codetag_get_content_id(struct codetag_type *cttype)
+{
+	lockdep_assert_held(&cttype->mod_lock);
+
+	/*
+	 * next_mod_seq is updated on every load, so can be used to identify
+	 * content changes.
+	 */
+	return cttype->next_mod_seq;
+}
+
 struct codetag_iterator codetag_get_ct_iter(struct codetag_type *cttype)
 {
 	struct codetag_iterator iter = {
-- 
2.54.0.545.g6539524ca2-goog


