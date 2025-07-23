Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C769C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:47:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5420D6B0109; Wed, 23 Jul 2025 10:47:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F3086B010B; Wed, 23 Jul 2025 10:47:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 393B56B010C; Wed, 23 Jul 2025 10:47:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 223F46B0109
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E3854140724
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:21 +0000 (UTC)
X-FDA: 83695807482.07.474498E
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf30.hostedemail.com (Postfix) with ESMTP id CD8BB8000F
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=rtqpOkjZ;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753282039; a=rsa-sha256;
	cv=none;
	b=Pn9UsRj2uy6vHjhKOYNFCpHJbrEOladG+dOmBoe49d3cowdfF7VMIJMOD4sq1/dQwNE/cp
	Okj11VzcxBqTLyj+oY+oVIN4dVKiolJJE/ms/PKe5ktcAl77d1RCzohBs5Rkxl5GISiRwi
	04H6sdDCl1D9NYKLks2xee1HnyfeTgw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=rtqpOkjZ;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753282039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PZSlqdnTxC2Wjx/Crjm0HF+UsFjTh+cAEzYLoPE8XGM=;
	b=oDxBhE4RCK/2EO9V8SwyQEwqv3tEwmj1bQyet7F9WjCB9o4kKX3cpE2v/X4Ca850SMGQdq
	SlnqsRQ3WA/0skEP8HGE5+OBt3gd9+/2TiiSEuEFS3eXQvFsVS4RshfV9Q9BKvrT6NLBX9
	Q/MxTROvpYNY+pnoEcanWNROBSqKmHo=
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-70e3e0415a7so261087b3.0
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1753282039; x=1753886839; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PZSlqdnTxC2Wjx/Crjm0HF+UsFjTh+cAEzYLoPE8XGM=;
        b=rtqpOkjZyxpRpS3fUE2tx4MBZwDgwgt8hGPo/s7sRxK18wrSOJJFndcJ5/kotCrFQp
         yGLxmg9AIEVYjAhFHOmyb8+o6KZluOl0/G0TriO8eQ2Z+MEnjjSPSzVYQfl4SGRh08+O
         WbxhoFwrv7kAkGAX/1kAXuDJd4XVJ4Pzbm+eXP88mpxF/63EM7oIMgLRjMpYLVyOsKMM
         cvtXrA6TiWUZq1h5A6vv9K/IdIP3ItvdlAQVPqmdAJi0qYIjoMOocVX6BTj0dSwgHpP+
         nT8IZqtXQIZKBD+njjPn/LhcKzUKqF82nbFKFwjLqAPiZ1G+QvpYv3MTV9tKIWHDkAxZ
         kDOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753282039; x=1753886839;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PZSlqdnTxC2Wjx/Crjm0HF+UsFjTh+cAEzYLoPE8XGM=;
        b=kb71jIv5X43xEyvSxowHSprV0t0xa6WlLBOzTZa4lk317MFmIdGRyAXFvWDnNRGGla
         rWXSqjVtdyF5cWjaQf2q4GtNuIeXYWCGVoeqvGhm+gM12ukPlmnHQsQyka1NLsdc+IBS
         1Qyj5T+NqFbhrfwE3ANrFO9WkA8nmEdFM6NcOx1/nSPl1I7AI7P+NtFzQhlYA0jLpYM5
         Dqh37Yjzl9Pj0dka7Mhz/OJkw0H6XlMWVqEpqrNc54nKCSAuXy/E7NVoFzkY1cG1fqCB
         cnQysxOt157HjCHJtxG6Mfjmmc6gFUJxbjuh52VcMJMpVNrggpYvLRiLkkAbvCDCV3pi
         SmYQ==
X-Forwarded-Encrypted: i=1; AJvYcCWBRcxoWJAniI29cYS7BhpM11hRSStV+BU4OEl+8mXyH5ZuMkKYjdJbjXCobL3q+G7gaqiWzRdGJA==@kvack.org
X-Gm-Message-State: AOJu0Yz2tlZtPxkWlRi8wnfgYEvF1rgYbLqOlypFFgNV0cHa3KUZMbwr
	rYki2VB6KNtKqFVU1X+N8tHlh4eMzh7dJrImWJmIiGVe5RMAVMxcnE6/MdWIGYJ+Vb4=
X-Gm-Gg: ASbGncvs6HB5U49unUDsKTLj/KfaeBfwNu53xg+4xlQXKIVqm1qFi8fBDkY47fkt4NZ
	yk0loM+jmL9sJ5IFwiWR973A4zgUANfvXKIAfclepgxoUnOgLXaLOvoFzFAM8iSh6XVwXY7GUGN
	W8PefCrP59cvLOgBrKRttrmMZ4qX8esAup7Ya/YoEcHJbjcNE/N6kYvRb5z439rgUVAW+Dh8JE5
	jD6V8s0Dhv2J9r6BgvLOUDRDPkCq0z33TYv4zzt+gkaRzUooxBcIhJfktCJ6yCR41meAwSDEaiW
	zyRipqtNLl4aqJmajDSV4EbM9mD5Nw3dijJlb9ZbE0MmHnwnUlyVNCdQhoC4S/ETHqzP5HUJnfB
	Q356kqV2o9CxwPGOsgWnlJB3OKjEEtQUnbCS30CyLFpw3GzxtIK4M30tckPegI2Fa6sEbyIytmT
	FtlXtfsAfaD4/2Hg==
X-Google-Smtp-Source: AGHT+IFN9e7mm9DK4PFQKKKYO6Lt9oj1mK23kThGYjIcIMOCvVxNcrxRaUhkgKiI35z2KgooHTIX8A==
X-Received: by 2002:a05:690c:4d87:b0:719:a0ff:1bd1 with SMTP id 00721157ae682-719b4b2610cmr39176557b3.3.1753282038557;
        Wed, 23 Jul 2025 07:47:18 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-719532c7e4fsm30482117b3.72.2025.07.23.07.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 07:47:18 -0700 (PDT)
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
Subject: [PATCH v2 12/32] liveupdate: luo_subsystems: add subsystem registration
Date: Wed, 23 Jul 2025 14:46:25 +0000
Message-ID: <20250723144649.1696299-13-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CD8BB8000F
X-Stat-Signature: ppeuxchxqzm3edr6ktwzs6wod67emcgz
X-HE-Tag: 1753282039-258588
X-HE-Meta: U2FsdGVkX1+2kRcQUILhgdWMMFC9+QUM28B77pcv8QVNRmy54u9Epg+8fUj0RkWhmk1HJZaIAyPQIxG6/fdPnF6CJUOUIz108o5Q00DRT4+jJ7JJGdq+fuG+UbSsj+8jaMw4xaeV3BWUx3yvIZRsncVGwh+PCsKbqfVB5KOEBXyzJlBdnCpocLNMRmf9J1louv4N1GkdrfUNutz1SlQi1yt5YITf2n4bEoPS5+jOKJF0SW8O9qVp/sjWqrtiltqsr6RA0t35TxThg+ZfN8JiMzmqtpXfHdNV9pWIEa7YJz6DhH+Gpp8Pw2Y60BHMxvIN1ZK2KJRhp6BFPdrbZCkkigXmQHIODWZaw1fT0I3XHeBfQFGWWhp7MFjLI6MKPHKz2rDQLy2hLw5DA9KTgMlAXZqFoNyDtDRlrEt7oNKZDLcWU5Pga43sgHsqt9qfSBfMNe/1+fLgu/p/bjXbOIHbca/qWGrgE5kFZ+5aV4AQmzEPJVnejeYsOPTOsxze2W0400nGjq8ux2iyeW+6sy0G4vL/zGM6hGGBA/8i/Ang3SEZG6xH7japKlLmU7l2ipDFzjXT96CDRCoxizA64vKvifFH3GCcZ20uaCgh2IVPN0Xb08k0T1R94x+4nJ7rvxQmu0TdRYKmVFKXQRk4oJmG0U7v5Hvs3cnWm69BmB+qy5b75oA6XYOtJ1iZDvixGREICR3bD3FQBuVpOva24K64PXDNYrLp0nWFmpNlQ+qhJrsSZ2fXl9CIhDTTUcvjXXuZYc4e5w8kdXaiEvdDNafGGui3CxfNiN7t2tjiRPAioZ6BHB9/MEs2I5dK6nlgQz2guL3VZILwrY3xYElaGYFtGo3qFMnUkxdONKC/vIci41GboY2k0cd6/t989SnAuOoTXVB1AN910fjy+Mm+BYEuQvYtutN2YFUboq9OpDcP3NJ8fJ7d2j4DbZGrdYQfLYcNSOQYE6D946KULNrBf3U
 TTixQDj1
 0Br2pUv/u+er/Kt1usrwwZ4tBOnZxXiKhk45PQW7+299aOh/tcwoZJjvnjhef6vKKTQhA10XZGWmGETCaAp232+jFS/jDd+HSeup8EhK7leNuuNzAKGmBDTY6Xd/lpDM+4Q07Bo/ELq2Mn6QGXjjuXNT5K3K/t/9XMpCVPcHYJf5K96R75zaMgjDkQh6mtcdfDtCAZNRCxbcM7klQ1Ce7y6sBOrLpW7CfIUVEo5q6cAlt0r/+E1jLoQNITjoSzjs97fAC7Ez05PABJKEMV7sHOu3yJKv61h3q9XWD5xE91nfpdVAAeV6KVtxMk3li+OR+dEZ/rkoyJB28Rpv3Z7zFgTZuSNkgbn8UeavX0/7ND6GTLk1ObvszA/xTDQ11oi1BjkA/rV9falnG1su1agQpPJXWhvbhat1RtOkJBlRlzyZRBociq932AmcyG5I0x2Aty7bEPpnKZL4MxGULfT7pi23lfH+RFnCt8OW9lSdgQCh8LhIZuIqiyEg5IGW8ieFLsDOuh2ApJvlOncTnMPZoHBGinz6dbJG+ZMwhgAvev2azOAs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce the framework for kernel subsystems (e.g., KVM, IOMMU, device
drivers) to register with LUO and participate in the live update process
via callbacks.

Subsystem Registration:
- Defines struct liveupdate_subsystem in linux/liveupdate.h,
  which subsystems use to provide their name and optional callbacks
  (prepare, freeze, cancel, finish). The callbacks accept
  a u64 *data intended for passing state/handles.
- Exports liveupdate_register_subsystem() and
  liveupdate_unregister_subsystem() API functions.
- Adds drivers/misc/liveupdate/luo_subsystems.c to manage a list
  of registered subsystems.
  Registration/unregistration is restricted to
  specific LUO states (NORMAL/UPDATED).

Callback Framework:
- The main luo_core.c state transition functions
  now delegate to new luo_do_subsystems_*_calls() functions
  defined in luo_subsystems.c.
- These new functions are intended to iterate through the registered
  subsystems and invoke their corresponding callbacks.

FDT Integration:
- Adds a /subsystems subnode within the main LUO FDT created in
  luo_core.c. This node has its own compatibility string
  (subsystems-v1).
- luo_subsystems_fdt_setup() populates this node by adding a
  property for each registered subsystem, using the subsystem's
  name.
  Currently, these properties are initialized with a placeholder
  u64 value (0).
- luo_subsystems_startup() is called from luo_core.c on boot to
  find and validate the /subsystems node in the FDT received via
  KHO. It panics if the node is missing or incompatible.
- Adds a stub API function liveupdate_get_subsystem_data() intended
  for subsystems to retrieve their persisted u64 data from the FDT
      in the new kernel.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/liveupdate.h         |  61 +++++++
 kernel/liveupdate/Makefile         |   1 +
 kernel/liveupdate/luo_core.c       |  19 +-
 kernel/liveupdate/luo_internal.h   |   7 +
 kernel/liveupdate/luo_subsystems.c | 284 +++++++++++++++++++++++++++++
 5 files changed, 370 insertions(+), 2 deletions(-)
 create mode 100644 kernel/liveupdate/luo_subsystems.c

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index da8f05c81e51..fed68b9ab32b 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -88,6 +88,47 @@ enum liveupdate_state  {
 	LIVEUPDATE_STATE_UPDATED = 4,
 };
 
+/**
+ * struct liveupdate_subsystem_ops - LUO events callback functions
+ * @prepare:      Optional. Called during LUO prepare phase. Should perform
+ *                preparatory actions and can store a u64 handle/state
+ *                via the 'data' pointer for use in later callbacks.
+ *                Return 0 on success, negative error code on failure.
+ * @freeze:       Optional. Called during LUO freeze event (before actual jump
+ *                to new kernel). Should perform final state saving actions and
+ *                can update the u64 handle/state via the 'data' pointer. Retur:
+ *                0 on success, negative error code on failure.
+ * @cancel:       Optional. Called if the live update process is canceled after
+ *                prepare (or freeze) was called. Receives the u64 data
+ *                set by prepare/freeze. Used for cleanup.
+ * @finish:       Optional. Called after the live update is finished in the new
+ *                kernel.
+ *                Receives the u64 data set by prepare/freeze. Used for cleanup.
+ */
+struct liveupdate_subsystem_ops {
+	int (*prepare)(void *arg, u64 *data);
+	int (*freeze)(void *arg, u64 *data);
+	void (*cancel)(void *arg, u64 data);
+	void (*finish)(void *arg, u64 data);
+};
+
+/**
+ * struct liveupdate_subsystem - Represents a subsystem participating in LUO
+ * @ops:          Callback functions
+ * @name:         Unique name identifying the subsystem.
+ * @arg:          Add this argument to callback functions.
+ * @list:         List head used internally by LUO. Should not be modified by
+ *                caller after registration.
+ * @private_data: For LUO internal use, cached value of data field.
+ */
+struct liveupdate_subsystem {
+	const struct liveupdate_subsystem_ops *ops;
+	const char *name;
+	void *arg;
+	struct list_head list;
+	u64 private_data;
+};
+
 #ifdef CONFIG_LIVEUPDATE
 
 /* Return true if live update orchestrator is enabled */
@@ -109,6 +150,10 @@ bool liveupdate_state_normal(void);
 
 enum liveupdate_state liveupdate_get_state(void);
 
+int liveupdate_register_subsystem(struct liveupdate_subsystem *h);
+int liveupdate_unregister_subsystem(struct liveupdate_subsystem *h);
+int liveupdate_get_subsystem_data(struct liveupdate_subsystem *h, u64 *data);
+
 #else /* CONFIG_LIVEUPDATE */
 
 static inline int liveupdate_reboot(void)
@@ -136,5 +181,21 @@ static inline enum liveupdate_state liveupdate_get_state(void)
 	return LIVEUPDATE_STATE_NORMAL;
 }
 
+static inline int liveupdate_register_subsystem(struct liveupdate_subsystem *h)
+{
+	return 0;
+}
+
+static inline int liveupdate_unregister_subsystem(struct liveupdate_subsystem *h)
+{
+	return 0;
+}
+
+static inline int liveupdate_get_subsystem_data(struct liveupdate_subsystem *h,
+						u64 *data)
+{
+	return -ENODATA;
+}
+
 #endif /* CONFIG_LIVEUPDATE */
 #endif /* _LINUX_LIVEUPDATE_H */
diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
index b3c72c405780..999208a1fdbb 100644
--- a/kernel/liveupdate/Makefile
+++ b/kernel/liveupdate/Makefile
@@ -6,3 +6,4 @@
 obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
 obj-$(CONFIG_KEXEC_HANDOVER_DEBUG)	+= kexec_handover_debug.o
 obj-$(CONFIG_LIVEUPDATE)		+= luo_core.o
+obj-$(CONFIG_LIVEUPDATE)		+= luo_subsystems.o
diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index c80a1f188359..fff84c51d986 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -130,6 +130,10 @@ static int luo_fdt_setup(void)
 	if (ret)
 		goto exit_free;
 
+	ret = luo_subsystems_fdt_setup(fdt_out);
+	if (ret)
+		goto exit_free;
+
 	ret = kho_preserve_phys(__pa(fdt_out), LUO_FDT_SIZE);
 	if (ret)
 		goto exit_free;
@@ -160,20 +164,30 @@ static void luo_fdt_destroy(void)
 
 static int luo_do_prepare_calls(void)
 {
-	return 0;
+	int ret;
+
+	ret = luo_do_subsystems_prepare_calls();
+
+	return ret;
 }
 
 static int luo_do_freeze_calls(void)
 {
-	return 0;
+	int ret;
+
+	ret = luo_do_subsystems_freeze_calls();
+
+	return ret;
 }
 
 static void luo_do_finish_calls(void)
 {
+	luo_do_subsystems_finish_calls();
 }
 
 static void luo_do_cancel_calls(void)
 {
+	luo_do_subsystems_cancel_calls();
 }
 
 static int __luo_prepare(void)
@@ -419,6 +433,7 @@ static int __init luo_startup(void)
 	}
 
 	__luo_set_state(LIVEUPDATE_STATE_UPDATED);
+	luo_subsystems_startup(luo_fdt_in);
 
 	return 0;
 }
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 3d10f3eb20a7..98bf799adb61 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -18,4 +18,11 @@ void luo_state_read_exit(void);
 
 const char *luo_current_state_str(void);
 
+void luo_subsystems_startup(void *fdt);
+int luo_subsystems_fdt_setup(void *fdt);
+int luo_do_subsystems_prepare_calls(void);
+int luo_do_subsystems_freeze_calls(void);
+void luo_do_subsystems_finish_calls(void);
+void luo_do_subsystems_cancel_calls(void);
+
 #endif /* _LINUX_LUO_INTERNAL_H */
diff --git a/kernel/liveupdate/luo_subsystems.c b/kernel/liveupdate/luo_subsystems.c
new file mode 100644
index 000000000000..436929a17de0
--- /dev/null
+++ b/kernel/liveupdate/luo_subsystems.c
@@ -0,0 +1,284 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+/**
+ * DOC: LUO Subsystems support
+ *
+ * Various kernel subsystems register with the Live Update Orchestrator to
+ * participate in the live update process. These subsystems are notified at
+ * different stages of the live update sequence, allowing them to serialize
+ * device state before the reboot and restore it afterwards. Examples include
+ * the device layer, interrupt controllers, KVM, IOMMU, and specific device
+ * drivers.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/err.h>
+#include <linux/libfdt.h>
+#include <linux/liveupdate.h>
+#include <linux/mutex.h>
+#include <linux/string.h>
+#include "luo_internal.h"
+
+#define LUO_SUBSYSTEMS_NODE_NAME	"subsystems"
+#define LUO_SUBSYSTEMS_COMPATIBLE	"subsystems-v1"
+
+static DEFINE_MUTEX(luo_subsystem_list_mutex);
+static LIST_HEAD(luo_subsystems_list);
+static void *luo_fdt_out;
+static void *luo_fdt_in;
+
+/**
+ * luo_subsystems_fdt_setup - Adds and populates the 'subsystems' node in the
+ * FDT.
+ * @fdt: Pointer to the LUO FDT blob.
+ *
+ * Add subsystems node and each subsystem to the LUO FDT blob.
+ *
+ * Returns: 0 on success, negative errno on failure.
+ */
+int luo_subsystems_fdt_setup(void *fdt)
+{
+	struct liveupdate_subsystem *subsystem;
+	const u64 zero_data = 0;
+	int ret, node_offset;
+
+	ret = fdt_add_subnode(fdt, 0, LUO_SUBSYSTEMS_NODE_NAME);
+	if (ret < 0)
+		goto exit_error;
+
+	node_offset = ret;
+	ret = fdt_setprop_string(fdt, node_offset, "compatible",
+				 LUO_SUBSYSTEMS_COMPATIBLE);
+	if (ret < 0)
+		goto exit_error;
+
+	list_for_each_entry(subsystem, &luo_subsystems_list, list) {
+		ret = fdt_setprop(fdt, node_offset, subsystem->name,
+				  &zero_data, sizeof(zero_data));
+		if (ret < 0)
+			goto exit_error;
+	}
+
+	luo_fdt_out = fdt;
+	return 0;
+exit_error:
+	pr_err("Failed to setup 'subsystems' node to FDT: %s\n",
+	       fdt_strerror(ret));
+	return -ENOSPC;
+}
+
+/**
+ * luo_subsystems_startup - Validates the LUO subsystems FDT node at startup.
+ * @fdt: Pointer to the LUO FDT blob passed from the previous kernel.
+ *
+ * This __init function checks the existence and validity of the '/subsystems'
+ * node in the FDT. This node is considered mandatory. It calls panic() if
+ * the node is missing, inaccessible, or invalid (e.g., missing compatible,
+ * wrong compatible string), indicating a critical configuration error for LUO.
+ */
+void __init luo_subsystems_startup(void *fdt)
+{
+	int ret, node_offset;
+
+	node_offset = fdt_subnode_offset(fdt, 0, LUO_SUBSYSTEMS_NODE_NAME);
+	if (node_offset < 0)
+		panic("Failed to find /subsystems node\n");
+
+	ret = fdt_node_check_compatible(fdt, node_offset,
+					LUO_SUBSYSTEMS_COMPATIBLE);
+	if (ret) {
+		panic("FDT '%s' is incompatible with '%s' [%d]\n",
+		      LUO_SUBSYSTEMS_NODE_NAME, LUO_SUBSYSTEMS_COMPATIBLE, ret);
+	}
+	luo_fdt_in = fdt;
+}
+
+/**
+ * luo_do_subsystems_prepare_calls - Calls prepare callbacks and updates FDT
+ * if all prepares succeed. Handles cancellation on failure.
+ *
+ * Phase 1: Calls 'prepare' for all subsystems and stores results temporarily.
+ * If any 'prepare' fails, calls 'cancel' on previously prepared subsystems
+ * and returns the error.
+ * Phase 2: If all 'prepare' calls succeeded, writes the stored data to the FDT.
+ * If any FDT write fails, calls 'cancel' on *all* prepared subsystems and
+ * returns the FDT error.
+ *
+ * Returns: 0 on success. Negative errno on failure.
+ */
+int luo_do_subsystems_prepare_calls(void)
+{
+	return 0;
+}
+
+/**
+ * luo_do_subsystems_freeze_calls - Calls freeze callbacks and updates FDT
+ * if all freezes succeed. Handles cancellation on failure.
+ *
+ * Phase 1: Calls 'freeze' for all subsystems and stores results temporarily.
+ * If any 'freeze' fails, calls 'cancel' on previously called subsystems
+ * and returns the error.
+ * Phase 2: If all 'freeze' calls succeeded, writes the stored data to the FDT.
+ * If any FDT write fails, calls 'cancel' on *all* subsystems and
+ * returns the FDT error.
+ *
+ * Returns: 0 on success. Negative errno on failure.
+ */
+int luo_do_subsystems_freeze_calls(void)
+{
+	return 0;
+}
+
+/**
+ * luo_do_subsystems_finish_calls- Calls finish callbacks for all subsystems.
+ *
+ * This function is called at the end of live update cycle to do the final
+ * clean-up or housekeeping of the post-live update states.
+ */
+void luo_do_subsystems_finish_calls(void)
+{
+}
+
+/**
+ * luo_do_subsystems_cancel_calls - Calls cancel callbacks for all subsystems.
+ *
+ * This function is typically called when the live update process needs to be
+ * aborted externally, for example, after the prepare phase may have run but
+ * before actual reboot. It iterates through all registered subsystems and calls
+ * the 'cancel' callback for those that implement it and likely completed
+ * prepare.
+ */
+void luo_do_subsystems_cancel_calls(void)
+{
+}
+
+/**
+ * liveupdate_register_subsystem - Register a kernel subsystem handler with LUO
+ * @h: Pointer to the liveupdate_subsystem structure allocated and populated
+ * by the calling subsystem.
+ *
+ * Registers a subsystem handler that provides callbacks for different events
+ * of the live update cycle. Registration is typically done during the
+ * subsystem's module init or core initialization.
+ *
+ * Can only be called when LUO is in the NORMAL or UPDATED states.
+ * The provided name (@h->name) must be unique among registered subsystems.
+ *
+ * Return: 0 on success, negative error code otherwise.
+ */
+int liveupdate_register_subsystem(struct liveupdate_subsystem *h)
+{
+	struct liveupdate_subsystem *iter;
+	int ret = 0;
+
+	luo_state_read_enter();
+	if (!liveupdate_state_normal() && !liveupdate_state_updated()) {
+		luo_state_read_exit();
+		return -EBUSY;
+	}
+
+	mutex_lock(&luo_subsystem_list_mutex);
+	list_for_each_entry(iter, &luo_subsystems_list, list) {
+		if (iter == h) {
+			pr_warn("Subsystem '%s' (%p) already registered.\n",
+				h->name, h);
+			ret = -EEXIST;
+			goto out_unlock;
+		}
+
+		if (!strcmp(iter->name, h->name)) {
+			pr_err("Subsystem with name '%s' already registered.\n",
+			       h->name);
+			ret = -EEXIST;
+			goto out_unlock;
+		}
+	}
+
+	INIT_LIST_HEAD(&h->list);
+	list_add_tail(&h->list, &luo_subsystems_list);
+
+out_unlock:
+	mutex_unlock(&luo_subsystem_list_mutex);
+	luo_state_read_exit();
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(liveupdate_register_subsystem);
+
+/**
+ * liveupdate_unregister_subsystem - Unregister a kernel subsystem handler from
+ * LUO
+ * @h: Pointer to the same liveupdate_subsystem structure that was used during
+ * registration.
+ *
+ * Unregisters a previously registered subsystem handler. Typically called
+ * during module exit or subsystem teardown. LUO removes the structure from its
+ * internal list; the caller is responsible for any necessary memory cleanup
+ * of the structure itself.
+ *
+ * Return: 0 on success, negative error code otherwise.
+ * -EINVAL if h is NULL.
+ * -ENOENT if the specified handler @h is not found in the registration list.
+ * -EBUSY if LUO is not in the NORMAL state.
+ */
+int liveupdate_unregister_subsystem(struct liveupdate_subsystem *h)
+{
+	struct liveupdate_subsystem *iter;
+	bool found = false;
+	int ret = 0;
+
+	luo_state_read_enter();
+	if (!liveupdate_state_normal() && !liveupdate_state_updated()) {
+		luo_state_read_exit();
+		return -EBUSY;
+	}
+
+	mutex_lock(&luo_subsystem_list_mutex);
+	list_for_each_entry(iter, &luo_subsystems_list, list) {
+		if (iter == h) {
+			found = true;
+			break;
+		}
+	}
+
+	if (found) {
+		list_del_init(&h->list);
+	} else {
+		pr_warn("Subsystem handler '%s' not found for unregistration.\n",
+			h->name);
+		ret = -ENOENT;
+	}
+
+	mutex_unlock(&luo_subsystem_list_mutex);
+	luo_state_read_exit();
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(liveupdate_unregister_subsystem);
+
+/**
+ * liveupdate_get_subsystem_data - Retrieve raw private data for a subsystem
+ * from FDT.
+ * @h:      Pointer to the liveupdate_subsystem structure representing the
+ * subsystem instance. The 'name' field is used to find the property.
+ * @data:   Output pointer where the subsystem's raw private u64 data will be
+ * stored via memcpy.
+ *
+ * Reads the 8-byte data property associated with the subsystem @h->name
+ * directly from the '/subsystems' node within the globally accessible
+ * 'luo_fdt_in' blob. Returns appropriate error codes if inputs are invalid, or
+ * nodes/properties are missing or invalid.
+ *
+ * Return:  0 on success. -ENOENT on error.
+ */
+int liveupdate_get_subsystem_data(struct liveupdate_subsystem *h, u64 *data)
+{
+	return 0;
+}
+EXPORT_SYMBOL_GPL(liveupdate_get_subsystem_data);
-- 
2.50.0.727.gbf7dc18ff4-goog


