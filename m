Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6682CCFA19
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 21:05:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 198B08E0013; Fri,  7 Nov 2025 16:05:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 121CB8E000D; Fri,  7 Nov 2025 16:05:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F04CC8E0013; Fri,  7 Nov 2025 16:05:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D8EFD8E000D
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:05:48 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9CCC859C6C
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:05:48 +0000 (UTC)
X-FDA: 84085042776.14.D0F0D7D
Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	by imf01.hostedemail.com (Postfix) with ESMTP id B7CF940009
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:05:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=TilTrtPN;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762549546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gdwSyej57m2z8fVHqgqF2nxiJqoHnbMJTxDva58Hcjk=;
	b=0CzBU2TD7fQKIml4NNywZ4UPZhwL4vpRyzOV7efnoGqOAj6MoJEsvW9uwllJLtyQsNWPhR
	8TzFDIOUisvy41lAi/ya61/rdbQDIrZUgjtGiuUwWgzWCItTAIsZG+FMgAyHua1CD34whP
	v5dJcNrWOcAW4PcIm3yM3ChIkRWYAeQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762549546; a=rsa-sha256;
	cv=none;
	b=njqjgKB7jSntzAHj6zlaqtOsdfEmMqWwOV6uVCH4FJyP21e+1S+LcV8PhbulWk7U51Pfwb
	ogti+Vlyj49OpSxbe7zAj6ChFw5u6L+z1j+cHWwP+mkDvXfDLSnAtOqzawIEOi88nsfAHN
	c/YwMQuDFTImrjbywzD9HWH3lx8NLLs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=TilTrtPN;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-63f97ab5cfcso1016795d50.0
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 13:05:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762549546; x=1763154346; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gdwSyej57m2z8fVHqgqF2nxiJqoHnbMJTxDva58Hcjk=;
        b=TilTrtPNofnl2k7VUGzErSDsiBGuv8/0/zG3/jyEQQwzLbN2F94tKieQJCbLooaAlp
         i6t/w5EUKkoOsD7VUcftXdQ+pt0tfgJCj3NVYJrlMWjWh0BEOVLw5+fVFENl4dhEnnIC
         bp5SAMUiEW2ZeM9J4gCBkPj50QlOQTP6QuDkbjbQmNQnQCnr4XC9JjMIgsQYARrKFwmi
         giD3R+riUOCNeau/GpT+59SdNQ3/Xssm6vJowbhi3SME2VQt2lODOygAIXGNz7n+ShCV
         yVSJ/LJHT10ZDcOMpmizwim7OfJ2FjsfrA915t9tA6ZaFM337kh1NwpbtCu6LiejsXvD
         bl7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762549546; x=1763154346;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gdwSyej57m2z8fVHqgqF2nxiJqoHnbMJTxDva58Hcjk=;
        b=JXoDujeVKgW3HBQVcb/Y45xMc+n+u1c2Jzi1sI+1c238UeNGHolsvQtJP1MZKt95dw
         nyMqa1ZtEUUUwLZ4EcAf0bnuiOHHvZ4K8tPliM1MrNoJ6ySXiUuvG5iSxnFS97Hg6ocy
         JAF9PeI2lqQ0hgjdjWZGs44OnrJZTLAokz8zWRMbPT4cFTa6otL87DEeWyZPb2HAhEKV
         j543ANw/k1WK8T9PlKTnYHl4J0GkGWV0xCAUJiYkSN+OaubAsI6Jp/T+LgpQJ92gx84D
         DnE4vlW+WgdIPw69i7ZaOTqgS7nfKfDFlAtwGJsspWrhtQXLv5vxDi6vcx8kEoFwRBjQ
         QTIg==
X-Forwarded-Encrypted: i=1; AJvYcCWAFCIXHNfjaAjvadbhCuUMIPEcQhypedhZ/WMRnxVQcGpuNAbxvC+ZJLW2NxLUQetm0mDPu6xhJQ==@kvack.org
X-Gm-Message-State: AOJu0Yw/+3lp5fWeZUWwxEeVMvUf8wm5aGMXd+3KuUToWZggalAgyP6M
	hJ46oYu0RxCsNnUdOOO3ihIQEYJTjdlAlF2ed3OtvGy/6OfTUhcyeXeGmbj+GnLzYBU=
X-Gm-Gg: ASbGnctighikejGiWe/4D/oO4WycwjNmSzvxqz5VU11ukjaGWITkbBvTs02LoGf5xuK
	gvu28EEYBUIB/1MaYIkQxZfbNJeiL8Tza6yrkoC/UIYuIYEfaVfYxsEXalpieHdwVf27Nza9Gmr
	a9L+lIYhURcX9GY8AIJGgSTY1XcehueqY6/lnqNECo5PyE3olxiugx6GUYep7YCYq2TkcBK5Hng
	LqzB5T8erzYFY2GXdsmURN9to+veR8e+0HuY8/c6RctOrjbZZEwnvxoUK4JeDmYZX02ieHihB4G
	29fDzsOz8YDGqHDuObJd8Kj8J1jfRmR76PtIyO3uveHglA9BvFXCZN60kF5fueTpa1frAXZI2g5
	uwcDv7dO0qWXRpCoxFMGTd//n4FO3NH7tMzub/m4mPZsjxE9F6sMQ6dxXyb/La93lCkYOOtqLWK
	IXbUgmCNSC9aP3ISTPeCdT6CmmGV8oprIJO7gqaHjRyXzD1rnv+lK6dCv0nptTtPosqb8LWaQAI
	Yoyc/kiDlSa
X-Google-Smtp-Source: AGHT+IHDSr1AQF8Wap6vS17SlScfz5Kr2vkF9XLTYeISsPUyhEI9f5yexLUWISImV79oI8Dockuc/Q==
X-Received: by 2002:a05:690e:1657:b0:63f:aadb:397a with SMTP id 956f58d0204a3-640d45c8834mr350073d50.55.1762549545602;
        Fri, 07 Nov 2025 13:05:45 -0800 (PST)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-787d68754d3sm990817b3.26.2025.11.07.13.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 13:05:45 -0800 (PST)
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
Subject: [PATCH v5 07/22] liveupdate: luo_ioctl: add user interface
Date: Fri,  7 Nov 2025 16:03:05 -0500
Message-ID: <20251107210526.257742-8-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
In-Reply-To: <20251107210526.257742-1-pasha.tatashin@soleen.com>
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sfbxmjo8o9dnpo8u4wtjbe1513x3zoqf
X-Rspam-User: 
X-Rspamd-Queue-Id: B7CF940009
X-Rspamd-Server: rspam10
X-HE-Tag: 1762549546-296224
X-HE-Meta: U2FsdGVkX1+GVwBwPnNH9Cg3hn9ya1uE3BA0z3Qmqs0nstxjvMQaCT93Bc3we1DJxfMO8vcFl6+pcIa42hTnSvMLTHlqk+folarmqmdw7oZvTqZ7xG3IMVyG0rJ8vwGy0JcakPsTA+dwuPb05NtJPKp93MZuEJj/V0XN5u6KHUF0LnDAXfgYGXAwH9kRepeCoDiInyWduTDHa3zqEauP8nkfwDwbC63AqgHhrRp7yM4HvxOwwKmMpxnqhqpJkMCbBM23ymVJTiOyT+Xhr3w6Ob/Omxh17en4AGG/FLs3D5bYY2LE5B3JbNgJSMnqi3d9BrvzbWi8yN7Cp4qBVxstSirtYn74TfKNnq0wMd0FtkMy9Rjai+1lO7SRb7fhaELF4coBFhsfwYuevdEZX68Qb1zJyVHTP+LKWTvw6Ah1JfCv4hrBKnCKUCesgbTtuvDMjHE6/tDohsjMgyCOEBVZ8H1YNGkL3qDWv4z1G8frF+oyW4zwm8HPYRfOOv2Z3mkzkH+P3GFRyfxyfe3U66xvpd/rzFH4JMW2ZMx8E7DER9pqPdXUjCPRqlQpuy/tLUyxtAfPL5IRBF7e7O8ShnZEaL7zJ6t+LgW9D5d1wlWBJTQZYKHMVGYkc6qYmSEi4Gn2JkuiwG8mSDOEo+6InstexJLfSKVl1Xo0vSX3Bek4NNgNe5JugR5J1Cjte7+y0jSz/tdenB+qCctOyPYPFR60rGPZ/5w729CJnWDPHjN8Kmm+IeLBW7vx3iWItsjj9k2y0A0FeUpf8p6KlNnFg0R1AziJrvUuuMGr83PYAa+TOQBEdx+He3W3SnD3VRZMYUXfY5RkUOvl7PQTRzv3C2Asli0KfV+6RMuPMvkPdX+46XSs8W84Vfi/LhYECe6eCPzxO/HXjcEp7DMAIaTcJ0dZp/5eEjBxEX2U8sxuwW391P2xAve4o3/B7ermSn6xbRoFhz7jGe7Hu13Dn+FMnxk
 zXe9ibZf
 YBzv+V7cBHvYrIj2lpStSClqPGWr8XJwFJ2igDXR28i+AVgeHz73bPC/oKQUiXGBR9fOmqgJ/FyLijY7qwhfk30bPe1ZRJeQaBZoM0dP+YE4YJNE6Uz1Rt2VcmCgtd1Nd/T9tCkfsMV9YKZEiyE+Lnn/MIUzT3Vel0vLSse0YQP6v4so9ugNX43DdRHVWCuyxDxHmM+t0btePJAvWb4U6Tb7pMYfEresyF5+wEQVqMiwckhpOSC8tSUijZBWR/NpolVFuaRC1uD5YiNvHWamwj4N+lbok0HvKk1kgpAjNEIo+9vucL6PwuryWpqv8afdD04mutF+7u+mfLjFFQgAF42PMNdP14eEHotUdhppQWCHJijC/ck80SiobryypbJqR8asn3TAcMEuR1hk2oIkibrYWnA/PbwD8nHlc1qIPFhJUFHTtx2ALvSwiOSCRa/S7KhKi
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
---
 include/uapi/linux/liveupdate.h  |  64 ++++++++++++
 kernel/liveupdate/luo_internal.h |  21 ++++
 kernel/liveupdate/luo_ioctl.c    | 173 +++++++++++++++++++++++++++++++
 3 files changed, 258 insertions(+)

diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
index d2ef2f7e0dbd..3ce60e976ecc 100644
--- a/include/uapi/linux/liveupdate.h
+++ b/include/uapi/linux/liveupdate.h
@@ -46,4 +46,68 @@
 /* The maximum length of session name including null termination */
 #define LIVEUPDATE_SESSION_NAME_LENGTH 56
 
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
+ *		char.
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
+	__u8		name[64];
+};
+
+#define LIVEUPDATE_IOCTL_RETRIEVE_SESSION \
+	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_RETRIEVE_SESSION)
+
 #endif /* _UAPI_LIVEUPDATE_H */
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index b4f2d1443c76..ab4652d79e64 100644
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
 
 void *luo_alloc_preserve(size_t size);
 void luo_free_unpreserve(void *mem, size_t size);
diff --git a/kernel/liveupdate/luo_ioctl.c b/kernel/liveupdate/luo_ioctl.c
index 44d365185f7c..ab03792fec0f 100644
--- a/kernel/liveupdate/luo_ioctl.c
+++ b/kernel/liveupdate/luo_ioctl.c
@@ -5,15 +5,187 @@
  * Pasha Tatashin <pasha.tatashin@soleen.com>
  */
 
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
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/atomic.h>
+#include <linux/errno.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
 #include <linux/liveupdate.h>
 #include <linux/miscdevice.h>
+#include <uapi/linux/liveupdate.h>
+#include "luo_internal.h"
 
 struct luo_device_state {
 	struct miscdevice miscdev;
+	atomic_t in_use;
 };
 
+static int luo_ioctl_create_session(struct luo_ucmd *ucmd)
+{
+	struct liveupdate_ioctl_create_session *argp = ucmd->cmd;
+	struct file *file;
+	int ret;
+
+	argp->fd = get_unused_fd_flags(O_CLOEXEC);
+	if (argp->fd < 0)
+		return argp->fd;
+
+	ret = luo_session_create(argp->name, &file);
+	if (ret)
+		return ret;
+
+	ret = luo_ucmd_respond(ucmd, sizeof(*argp));
+	if (ret) {
+		fput(file);
+		put_unused_fd(argp->fd);
+		return ret;
+	}
+
+	fd_install(argp->fd, file);
+
+	return 0;
+}
+
+static int luo_ioctl_retrieve_session(struct luo_ucmd *ucmd)
+{
+	struct liveupdate_ioctl_retrieve_session *argp = ucmd->cmd;
+	struct file *file;
+	int ret;
+
+	argp->fd = get_unused_fd_flags(O_CLOEXEC);
+	if (argp->fd < 0)
+		return argp->fd;
+
+	ret = luo_session_retrieve(argp->name, &file);
+	if (ret < 0) {
+		put_unused_fd(argp->fd);
+
+		return ret;
+	}
+
+	ret = luo_ucmd_respond(ucmd, sizeof(*argp));
+	if (ret) {
+		fput(file);
+		put_unused_fd(argp->fd);
+		return ret;
+	}
+
+	fd_install(argp->fd, file);
+
+	return 0;
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
+	luo_session_deserialize();
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
+	int ret;
+
+	nr = _IOC_NR(cmd);
+	if (nr < LIVEUPDATE_CMD_BASE ||
+	    (nr - LIVEUPDATE_CMD_BASE) >= ARRAY_SIZE(luo_ioctl_ops)) {
+		return -EINVAL;
+	}
+
+	ucmd.ubuffer = (void __user *)arg;
+	ret = get_user(ucmd.user_size, (u32 __user *)ucmd.ubuffer);
+	if (ret)
+		return ret;
+
+	op = &luo_ioctl_ops[nr - LIVEUPDATE_CMD_BASE];
+	if (op->ioctl_num != cmd)
+		return -ENOIOCTLCMD;
+	if (ucmd.user_size < op->min_size)
+		return -EINVAL;
+
+	ucmd.cmd = &buf;
+	ret = copy_struct_from_user(ucmd.cmd, op->size, ucmd.ubuffer,
+				    ucmd.user_size);
+	if (ret)
+		return ret;
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
@@ -22,6 +194,7 @@ static struct luo_device_state luo_dev = {
 		.name  = "liveupdate",
 		.fops  = &luo_fops,
 	},
+	.in_use = ATOMIC_INIT(0),
 };
 
 static int __init liveupdate_ioctl_init(void)
-- 
2.51.2.1041.gc1ab5b90ca-goog


