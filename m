Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10B3AD0EE0E
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 16:59:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 582B66B0026; Tue, 25 Nov 2025 11:59:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 532FD6B0028; Tue, 25 Nov 2025 11:59:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D4A76B002A; Tue, 25 Nov 2025 11:59:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 23BB86B0026
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 11:59:09 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CF894B8061
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:59:08 +0000 (UTC)
X-FDA: 84149739576.10.2EC9525
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf17.hostedemail.com (Postfix) with ESMTP id 071944000B
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:59:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Rdrq8QMl;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764089947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qY9wo9jaEowvBGqUAjQT6FCUqqOXzwqYWEwdmUcM3GY=;
	b=n+rZbQ151+WVMp7hEDqnxFdguFfhpsW5dOlZYKdtoEe0wJbDXTP+lxsBB2nJU1emLW4jOg
	MRNas3qc43mUdkUbExMBzqrddEElTpSlKCVDx8vUHE9Pyre7gf3esc2/MVb4A+/T0097j9
	Uu387R0867wcdtc3YBvPkASyqhiNS1k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764089947; a=rsa-sha256;
	cv=none;
	b=v7QZgY4dar0mT6QQIw20CGIPnQ9qIjYcmn5MZFbfXR0F3WNWAUyU30A+OTRXvrz482rkDB
	hwQQImXpbw2TuiR3my4Rgr4rvGT8mdPiaHfOebo+WXhpvUDWiDhGs4NQDwVINHBAEdDu46
	3f0EXYCfuj20jkjciswD0CJORO+kGBs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Rdrq8QMl;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-78a8bed470bso38813147b3.0
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:59:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764089946; x=1764694746; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qY9wo9jaEowvBGqUAjQT6FCUqqOXzwqYWEwdmUcM3GY=;
        b=Rdrq8QMlzcQG9e5WNomZAldMogKXl7pCTrDVZx3D0OtEaMwNgmew9oSSFB9fKK0qGR
         1RtjBjZNOE7x1SyVWIbouaj6J+9U7kMVFYobR+Fr958giSAxgHnv4Ado6aTIV19755CW
         ttnQ5j7KtQWRNtcpPc+de3sAtxxa93QXWjHneX6kd2x6YVnzXyxKf2CofRQY96KPW3pP
         ipeCgHMDkseFoGqhtKCqRh7Q3jr1BY/eOb/COEP6VJ7bC28BOUEWchw5WfjXt/JLIh2d
         wgV81V27bT2dLJsAXmSf1rMsDjCpsFPZcbj3frKfOpAJ4Cn+tGXdw+9TYhbkUEVdUymG
         H//g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764089946; x=1764694746;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qY9wo9jaEowvBGqUAjQT6FCUqqOXzwqYWEwdmUcM3GY=;
        b=LKZqhkBHPbzl50BaZPSe9vjRnAYmd/l1pHCJWIKc9Q7FJCK8aiQ0YTzYiuYD9mYESP
         cdD2FOyk8VtS3z8Q4TMGhniBIv4y9VoLll/SsPVkxuEFSWOJzNz9iqFZ8JnCSf8rOXVC
         yUxn3Vvy1W2VojsWLtRJYeFiATFOFfdCe6QmQfhRkNGXOHfGsMsKrsHAwbo6MdnkHHKO
         Rd4FrfCD+kyPOV+YS3lwqmiWsmhDftQM4coguTtUjyeQhC4XehL5zfuGBUj4udFh5DNg
         VgPwQcAAHfTxBvL/d4NVp+KR/v0DZYYGRLxU0oCfC+s2FFyWUZn00ouG4d8FRCgzOmik
         LmkQ==
X-Forwarded-Encrypted: i=1; AJvYcCV3jYtInVC1zSy9nxYUkcIcl5C6sy05jKGryXZ7Q52AphZpO8BSDp1QFXzsT7fWgfT9jMU/q/C73g==@kvack.org
X-Gm-Message-State: AOJu0YyE37/5/hif1LSyiRDqDo7SuTxNDZ81CrE075qPu8VYp53zcbC5
	rmFcuDvVbVI4yEg/WjOX+vy0Ylr3/VAmDVVabeuU4SehoZTT34IZcW/3WRqQKkjI2AM=
X-Gm-Gg: ASbGncsc8bPIfLX1nP3VzvCTTQcGD/x4x4da5PsveegqnJ1iGi114bDN58BArwQDz4U
	TQEpZPaVObntAcYNG9eBzEJ7oCXchlxKDojB3bSdIK5ThL5fqNkWFm8uFvUmGmksfKYM1QRdwG/
	u6Ni77bRVCaHQipCKzSxc1E2Hkr5pm5O/JOo2UarhCMA68d1ijYgBgJFsgihqBEHr1yrtmeiMzM
	rDpWEttQ91GL5//N+Q7N5jibzMCfXWzjG8gJWBvlpWdMXcd7viqPpTMv15yDAt8RGPu7kUEOGtg
	kgHu5R0ikVjwIboGHoLXnrYCJXRUtO4bo2CB4ZP1stPFKE+5HIqzGZHqJctcv7UgRfq2mvxhfpC
	Fq8dzM4NomNTyqy4nLamwnSIFND3C7todgPsLlHgorlxvAZ+GYX9cTiwt3pf9JB1SyV12ur/XYI
	5x6lqytbO4Bs7R8C3JAtZURWRTukjtPU4QgqZh3WZ1odq8D6OO9zw36ZEFkWaVC+LC
X-Google-Smtp-Source: AGHT+IFBNMs4cA9mfXfs+UfRF6OXAxVhmWhl0xvnB86ygK/E+UbH0gsrwEnsBLd9L25QsRfTdYCESw==
X-Received: by 2002:a05:690c:6806:b0:788:20a1:48c0 with SMTP id 00721157ae682-78ab6d6ce3dmr62989787b3.12.1764089945871;
        Tue, 25 Nov 2025 08:59:05 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a798a5518sm57284357b3.14.2025.11.25.08.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 08:59:05 -0800 (PST)
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
Subject: [PATCH v8 05/18] liveupdate: luo_core: add user interface
Date: Tue, 25 Nov 2025 11:58:35 -0500
Message-ID: <20251125165850.3389713-6-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.460.gd25c4c69ec-goog
In-Reply-To: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
References: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 071944000B
X-Stat-Signature: 91x66h3piscxj7dr7ksu9zduhj1tmj31
X-HE-Tag: 1764089946-903165
X-HE-Meta: U2FsdGVkX1+mQvVolYtB1XzuyV3OJZhifL8yw3XXuUQ03HQdklIiSiliNqxICPocNFjyJ2bSiG8PlF+ttg8EYXbIOszzf9xXL3Cu0rxwJpLsytyjsrqRXsj3mnF2t+Ulh1BTsZ3nK3pEXaCSn57P6Gjftu6Z3fjmo0CwaKy/hd4sCr9WtYk3fsIepZzT/t1r+yj1lU16j2X5RKC3MSRmnl7HuwZxJuTG45uybFjkJudfh8KKr6d9rF0sb2cYetbYu6uw9xnDEPvqtfxatlDITfZcMxOoBqIqlSJ7FloVFKi4VLnQ5ruXHT60Bi+FAafvmD+/G5VdjWUhQWkLphXehKqkiTiSH9jvyFEME4+71nI7ciQF4dtCguMfM2yUJjZWjLFzcgcmECXtI9Rnfb5yh+5gVvPm22iXL0LxWVOam1UA4se5m+YJSqEaKaLhzz6SpbV9bG/cuYYQjEbLCFgvoJ+9Ei2f0CGnSCNxarjZnM/qi6iNQzBNlKBhIpnfnsxpumtCu1R8fhI2EkEgZ+HPtBZ7YiSIBBBmcig1JJ2C989yOu49EKL3vEevhq0anZ49NZupyZ8ZTXLYBi1TD5Cl3wwKq7/U+6B50Xr3LhKvBYA0/qIi0U/FxX5AaYOESzXqZt7dw7VVTVo77dK40kaSqMbposXj0r7HJIhbhOKJqhK5bmu/yoY1OEn09kreWj7fxUnJEO4T5stKXYO4S+LYz+vjzgSw8354en7pKvsiqtNpqVsFJ/V5M5mU/mRTbQN6VMAeoWxw32Gy2Etzvp2awhjBt5a0rEx4MJfT5IOjMChfKLfDzBwplC60Yb9SXA5uJrHyUcTvx0fLdUJqt4/nCzYW+vao9aChWSIt1oqlIfPjnV6pBxKLC3+Ka7wVMZPZmHUlyC5WsmV4WH1I84j/03SH6OFz4P91nFd3OfqLwP+OHE55s/ebomF/JHhbqQNy0tJ4cIpPCz3il/Ze4mD
 aHCV1Bn+
 hmstktPUBNpQ1N7uGMuhentUO8FF6HmC801Q42SI9rwpUucM4+9ZnTk3mqhzsBRWdXTgf6EstDOBkOUA7sLZV665w2ZUh/P7DlcSh1uV9vQqxogkUa+FySz7uueJtYn9ssEo4tE5BTTRxzbm87pHePR4Ab8Q1GkwcJ6+XaIgWMJb5m9ek78xtMs7LQRIpqluQjdqh+d5R9EB6mZ7pOAZxXKPHtokMrLZ3oB6Fne6vrjVbU86pEG+03UIKF6/HmPNww+3sOQS2j/1SL2PYKAN6j9Yrt+A/BS2xsQVkyz8RlJOziGwkQUXFJHe/Cko/0YGWJxcUj/whgzlhZ3re0msxneMZdyg4lku6OWUgBOZ0YntfOh/rkZJtGaQjuf0vS+1ydjzmHtI+hnTl4NNiU/AmAiq0wk5wvNkhkD7l3IkcYDrzk6dvc5f2Cr8T04SbBbMobBiEZakqB6weUeDwyDJCB32PNQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce the user-space interface for the Live Update Orchestrator
via ioctl commands, enabling external control over the live update
process and management of preserved resources.

The idea is that there is going to be a single userspace agent driving
the live update, therefore, only a single process can ever hold this
device opened at a time.

The following ioctl commands are introduced:

LIVEUPDATE_IOCTL_CREATE_SESSION
Provides a way for userspace to create a named session for grouping file
descriptors that need to be preserved. It returns a new file descriptor
representing the session.

LIVEUPDATE_IOCTL_RETRIEVE_SESSION
Allows the userspace agent in the new kernel to reclaim a preserved
session by its name, receiving a new file descriptor to manage the
restored resources.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
---
 include/uapi/linux/liveupdate.h  |  64 +++++++++++
 kernel/liveupdate/luo_core.c     | 178 +++++++++++++++++++++++++++++++
 kernel/liveupdate/luo_internal.h |  21 ++++
 3 files changed, 263 insertions(+)

diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
index 40578ae19668..1183cf984b5f 100644
--- a/include/uapi/linux/liveupdate.h
+++ b/include/uapi/linux/liveupdate.h
@@ -46,4 +46,68 @@
 /* The maximum length of session name including null termination */
 #define LIVEUPDATE_SESSION_NAME_LENGTH 64
 
+/* The /dev/liveupdate ioctl commands */
+enum {
+	LIVEUPDATE_CMD_BASE = 0x00,
+	LIVEUPDATE_CMD_CREATE_SESSION = LIVEUPDATE_CMD_BASE,
+	LIVEUPDATE_CMD_RETRIEVE_SESSION = 0x01,
+};
+
+/**
+ * struct liveupdate_ioctl_create_session - ioctl(LIVEUPDATE_IOCTL_CREATE_SESSION)
+ * @size:	Input; sizeof(struct liveupdate_ioctl_create_session)
+ * @fd:		Output; The new file descriptor for the created session.
+ * @name:	Input; A null-terminated string for the session name, max
+ *		length %LIVEUPDATE_SESSION_NAME_LENGTH including termination
+ *		character.
+ *
+ * Creates a new live update session for managing preserved resources.
+ * This ioctl can only be called on the main /dev/liveupdate device.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+struct liveupdate_ioctl_create_session {
+	__u32		size;
+	__s32		fd;
+	__u8		name[LIVEUPDATE_SESSION_NAME_LENGTH];
+};
+
+#define LIVEUPDATE_IOCTL_CREATE_SESSION					\
+	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_CREATE_SESSION)
+
+/**
+ * struct liveupdate_ioctl_retrieve_session - ioctl(LIVEUPDATE_IOCTL_RETRIEVE_SESSION)
+ * @size:    Input; sizeof(struct liveupdate_ioctl_retrieve_session)
+ * @fd:      Output; The new file descriptor for the retrieved session.
+ * @name:    Input; A null-terminated string identifying the session to retrieve.
+ *           The name must exactly match the name used when the session was
+ *           created in the previous kernel.
+ *
+ * Retrieves a handle (a new file descriptor) for a preserved session by its
+ * name. This is the primary mechanism for a userspace agent to regain control
+ * of its preserved resources after a live update.
+ *
+ * The userspace application provides the null-terminated `name` of a session
+ * it created before the live update. If a preserved session with a matching
+ * name is found, the kernel instantiates it and returns a new file descriptor
+ * in the `fd` field. This new session FD can then be used for all file-specific
+ * operations, such as restoring individual file descriptors with
+ * LIVEUPDATE_SESSION_RETRIEVE_FD.
+ *
+ * It is the responsibility of the userspace application to know the names of
+ * the sessions it needs to retrieve. If no session with the given name is
+ * found, the ioctl will fail with -ENOENT.
+ *
+ * This ioctl can only be called on the main /dev/liveupdate device when the
+ * system is in the LIVEUPDATE_STATE_UPDATED state.
+ */
+struct liveupdate_ioctl_retrieve_session {
+	__u32		size;
+	__s32		fd;
+	__u8		name[LIVEUPDATE_SESSION_NAME_LENGTH];
+};
+
+#define LIVEUPDATE_IOCTL_RETRIEVE_SESSION \
+	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_RETRIEVE_SESSION)
+
 #endif /* _UAPI_LIVEUPDATE_H */
diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index a0f7788cd003..f7ecaf7740d1 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -41,7 +41,13 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/atomic.h>
+#include <linux/errno.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/init.h>
 #include <linux/io.h>
+#include <linux/kernel.h>
 #include <linux/kexec_handover.h>
 #include <linux/kho/abi/luo.h>
 #include <linux/kobject.h>
@@ -246,12 +252,183 @@ bool liveupdate_enabled(void)
 	return luo_global.enabled;
 }
 
+/**
+ * DOC: LUO ioctl Interface
+ *
+ * The IOCTL user-space control interface for the LUO subsystem.
+ * It registers a character device, typically found at ``/dev/liveupdate``,
+ * which allows a userspace agent to manage the LUO state machine and its
+ * associated resources, such as preservable file descriptors.
+ *
+ * To ensure that the state machine is controlled by a single entity, access
+ * to this device is exclusive: only one process is permitted to have
+ * ``/dev/liveupdate`` open at any given time. Subsequent open attempts will
+ * fail with -EBUSY until the first process closes its file descriptor.
+ * This singleton model simplifies state management by preventing conflicting
+ * commands from multiple userspace agents.
+ */
+
 struct luo_device_state {
 	struct miscdevice miscdev;
+	atomic_t in_use;
 };
 
+static int luo_ioctl_create_session(struct luo_ucmd *ucmd)
+{
+	struct liveupdate_ioctl_create_session *argp = ucmd->cmd;
+	struct file *file;
+	int err;
+
+	argp->fd = get_unused_fd_flags(O_CLOEXEC);
+	if (argp->fd < 0)
+		return argp->fd;
+
+	err = luo_session_create(argp->name, &file);
+	if (err)
+		goto err_put_fd;
+
+	err = luo_ucmd_respond(ucmd, sizeof(*argp));
+	if (err)
+		goto err_put_file;
+
+	fd_install(argp->fd, file);
+
+	return 0;
+
+err_put_file:
+	fput(file);
+err_put_fd:
+	put_unused_fd(argp->fd);
+
+	return err;
+}
+
+static int luo_ioctl_retrieve_session(struct luo_ucmd *ucmd)
+{
+	struct liveupdate_ioctl_retrieve_session *argp = ucmd->cmd;
+	struct file *file;
+	int err;
+
+	argp->fd = get_unused_fd_flags(O_CLOEXEC);
+	if (argp->fd < 0)
+		return argp->fd;
+
+	err = luo_session_retrieve(argp->name, &file);
+	if (err < 0)
+		goto err_put_fd;
+
+	err = luo_ucmd_respond(ucmd, sizeof(*argp));
+	if (err)
+		goto err_put_file;
+
+	fd_install(argp->fd, file);
+
+	return 0;
+
+err_put_file:
+	fput(file);
+err_put_fd:
+	put_unused_fd(argp->fd);
+
+	return err;
+}
+
+static int luo_open(struct inode *inodep, struct file *filep)
+{
+	struct luo_device_state *ldev = container_of(filep->private_data,
+						     struct luo_device_state,
+						     miscdev);
+
+	if (atomic_cmpxchg(&ldev->in_use, 0, 1))
+		return -EBUSY;
+
+	/* Always return -EIO to user if deserialization fail */
+	if (luo_session_deserialize()) {
+		atomic_set(&ldev->in_use, 0);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int luo_release(struct inode *inodep, struct file *filep)
+{
+	struct luo_device_state *ldev = container_of(filep->private_data,
+						     struct luo_device_state,
+						     miscdev);
+	atomic_set(&ldev->in_use, 0);
+
+	return 0;
+}
+
+union ucmd_buffer {
+	struct liveupdate_ioctl_create_session create;
+	struct liveupdate_ioctl_retrieve_session retrieve;
+};
+
+struct luo_ioctl_op {
+	unsigned int size;
+	unsigned int min_size;
+	unsigned int ioctl_num;
+	int (*execute)(struct luo_ucmd *ucmd);
+};
+
+#define IOCTL_OP(_ioctl, _fn, _struct, _last)                                  \
+	[_IOC_NR(_ioctl) - LIVEUPDATE_CMD_BASE] = {                            \
+		.size = sizeof(_struct) +                                      \
+			BUILD_BUG_ON_ZERO(sizeof(union ucmd_buffer) <          \
+					  sizeof(_struct)),                    \
+		.min_size = offsetofend(_struct, _last),                       \
+		.ioctl_num = _ioctl,                                           \
+		.execute = _fn,                                                \
+	}
+
+static const struct luo_ioctl_op luo_ioctl_ops[] = {
+	IOCTL_OP(LIVEUPDATE_IOCTL_CREATE_SESSION, luo_ioctl_create_session,
+		 struct liveupdate_ioctl_create_session, name),
+	IOCTL_OP(LIVEUPDATE_IOCTL_RETRIEVE_SESSION, luo_ioctl_retrieve_session,
+		 struct liveupdate_ioctl_retrieve_session, name),
+};
+
+static long luo_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
+{
+	const struct luo_ioctl_op *op;
+	struct luo_ucmd ucmd = {};
+	union ucmd_buffer buf;
+	unsigned int nr;
+	int err;
+
+	nr = _IOC_NR(cmd);
+	if (nr < LIVEUPDATE_CMD_BASE ||
+	    (nr - LIVEUPDATE_CMD_BASE) >= ARRAY_SIZE(luo_ioctl_ops)) {
+		return -EINVAL;
+	}
+
+	ucmd.ubuffer = (void __user *)arg;
+	err = get_user(ucmd.user_size, (u32 __user *)ucmd.ubuffer);
+	if (err)
+		return err;
+
+	op = &luo_ioctl_ops[nr - LIVEUPDATE_CMD_BASE];
+	if (op->ioctl_num != cmd)
+		return -ENOIOCTLCMD;
+	if (ucmd.user_size < op->min_size)
+		return -EINVAL;
+
+	ucmd.cmd = &buf;
+	err = copy_struct_from_user(ucmd.cmd, op->size, ucmd.ubuffer,
+				    ucmd.user_size);
+	if (err)
+		return err;
+
+	return op->execute(&ucmd);
+}
+
 static const struct file_operations luo_fops = {
 	.owner		= THIS_MODULE,
+	.open		= luo_open,
+	.release	= luo_release,
+	.unlocked_ioctl	= luo_ioctl,
 };
 
 static struct luo_device_state luo_dev = {
@@ -260,6 +437,7 @@ static struct luo_device_state luo_dev = {
 		.name  = "liveupdate",
 		.fops  = &luo_fops,
 	},
+	.in_use = ATOMIC_INIT(0),
 };
 
 static int __init liveupdate_ioctl_init(void)
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 05ae91695ec6..1292ac47eef8 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -9,6 +9,27 @@
 #define _LINUX_LUO_INTERNAL_H
 
 #include <linux/liveupdate.h>
+#include <linux/uaccess.h>
+
+struct luo_ucmd {
+	void __user *ubuffer;
+	u32 user_size;
+	void *cmd;
+};
+
+static inline int luo_ucmd_respond(struct luo_ucmd *ucmd,
+				   size_t kernel_cmd_size)
+{
+	/*
+	 * Copy the minimum of what the user provided and what we actually
+	 * have.
+	 */
+	if (copy_to_user(ucmd->ubuffer, ucmd->cmd,
+			 min_t(size_t, ucmd->user_size, kernel_cmd_size))) {
+		return -EFAULT;
+	}
+	return 0;
+}
 
 /*
  * Handles a deserialization failure: devices and memory is in unpredictable
-- 
2.52.0.460.gd25c4c69ec-goog


