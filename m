Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E31F9C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:48:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4BAE6B011A; Wed, 23 Jul 2025 10:47:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FC1A6B011B; Wed, 23 Jul 2025 10:47:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A2988E0002; Wed, 23 Jul 2025 10:47:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 76ECD6B011A
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:32 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4CD111605E2
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:32 +0000 (UTC)
X-FDA: 83695807944.05.B6E92E1
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	by imf23.hostedemail.com (Postfix) with ESMTP id 720BE140002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=Z3bvjtEB;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753282050; a=rsa-sha256;
	cv=none;
	b=OVlEIChPbtYd0fIyT85UwqOQ6SVhaTT//2q4nsS8Cq9tl38vZLExdBYQB3vjOYLmIzlKbg
	XuTY7kRpqZz9OB0t6BBnIFFS+6T6+2PeJZzhdU5fc30m5xIj1fFoZymWRCEPiY2/opit4G
	zQDrRh1EVpAK89I/VSatf7RYz8JEfy0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=Z3bvjtEB;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753282050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BuaZboxZCQ/wXH7LW7KxgHTaIDnECxtLxwF2+wVPu54=;
	b=GPEGKRSQiorQoANzTjZxIheelnPaDAzsZVa3igUNQGPdH/Z8CuSvOinDrMeYWmg1r57d2n
	UKoW6lpw3KBWsXI7KMvXcAHSlWYvjC2HSUneMdbopKEWw0bBlxDWJZZJrJoVDshXhCOmAa
	TjdCEeoMnZQMe1h9+S5t0cbfjdFLMC8=
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-70f862dbeaeso63739337b3.1
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1753282049; x=1753886849; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BuaZboxZCQ/wXH7LW7KxgHTaIDnECxtLxwF2+wVPu54=;
        b=Z3bvjtEBvjkCFBeftTXLvYL2IpNeIFfdVic7SWlDMxKVIt87roJJa4T5+nDnQim7o6
         zs227JgGrQuzluuhf68fMPnT8e4pflmu79YVlcIjcAEJvt4V1Dg3ZRUG/l1DIi39cWCK
         YBvbmRVQgyu0A+Cmve5pmdE5BMtjvRRFdqoAIah31FGwbcw0SLNXXXe2len4lfd+Q/oM
         OM8Dufajg7MDCMF9xDzyWZBhwKf48KvON8f9a6Ktebty9b5WdAw9dNuw+uFmKn7IHWi9
         arJMBbLR+yBKHspjnZoxikKyOtEcL4L5m0zfxsOc1WqvpNDlhDUOgGxsy/H65NZZ5XCB
         O0hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753282049; x=1753886849;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BuaZboxZCQ/wXH7LW7KxgHTaIDnECxtLxwF2+wVPu54=;
        b=Qv6w+uyLuchi8csjgtRFTWMB0KYP2T3RNSKp6BiDtK3mrcXni9YURjB8ZSwn34LEfc
         KSUwjn0ytLT2sRHH6Y/iQdGqDVkDdyyJP6vRVjXhBkQFqSriLqvqrj+B4dyY70ybuiYZ
         oQfwnw1ht1NrbFEjuObGLKOgNR3P3frLHDmcItcq1l2jTepkPd8UBzVAumWpLadEF5qW
         Sbn9FnVNvkCLlD4PfR8uttKuQp5y3fhpd8Va5VayJhBAp4KMzo1BIEor4hirwYQ9oAcF
         rLhkIiEHufraTRA2UntStFyXgE6qU773CpFj3GavQ4dIcf9KIDB/qiS7F9/sdkuU+Goz
         1hPw==
X-Forwarded-Encrypted: i=1; AJvYcCU0Ohdb6wGKQ1yB+PM4xEYksF3t5zOsjwYzSBNVs6zZX1aHKYvE0di3bkAmqaK6EErFwFH7pesX3g==@kvack.org
X-Gm-Message-State: AOJu0YydIvsS584vdSR1GwQnwamPU06jZmVr8AZNqzHPxCGvMve3kpyl
	24SuQH64yOwnKzBHF9BH7HRvpPs3YnVY1FxPZZuqmto3UCac9A4MUEMel1anJI/UIVw=
X-Gm-Gg: ASbGncvJsh7Xbr0kiLy0A72Al8RpYBRlMniAAcVIDo0Fguoj7ct5uqkpyOxjU13gbhl
	Y+791ohs3HpD6CTiwG6GsFZdAoamom1fwQGGpj7odqxEXLjYI0JbvjshUFBiG+HeT8XrByGMe6O
	i6xisurIdSxNEo6uvEOLPgjI2qDJCQczeJ7B+mhI04H1vYiPKUfKF16Mej+eCPEmhHK/dT4gNf1
	/tVhrf/O0+qhEcP9iM8dfGMSpfWlLHr3eCiMDoI06HWEbT5RRO+Cl8OwRzEzuYuyS3PS9yAxRuw
	1vR4ZOYzv28JWJnzb+FhzLq+RYrVq/gnhjkg/0T4gmavzL9f9F1z5eIXOATLvXBTMKAhPBmqF31
	UfvAcNxGH/N5jaVw6GTwHmAfy/eG8x8rjjtyCpKWgNFY8mC8RGXVRrkalsmfJnjx0PRyCBHCDBs
	/EAq1phuhSGo/Rfw==
X-Google-Smtp-Source: AGHT+IHIEOVDLgBUtd06XIvFo8+3Y7nL7WITrWUa0ITVg5fLvibUXHlW/Jf3oLpOE6dYCWJXFxrBHg==
X-Received: by 2002:a05:690c:6909:b0:70d:f673:140b with SMTP id 00721157ae682-719b4221fcfmr41663997b3.14.1753282049214;
        Wed, 23 Jul 2025 07:47:29 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-719532c7e4fsm30482117b3.72.2025.07.23.07.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 07:47:28 -0700 (PDT)
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
Subject: [PATCH v2 17/32] liveupdate: luo_sysfs: add sysfs state monitoring
Date: Wed, 23 Jul 2025 14:46:30 +0000
Message-ID: <20250723144649.1696299-18-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 720BE140002
X-Stat-Signature: xtay374g9doz89yheru74qsit41n8i98
X-HE-Tag: 1753282050-838044
X-HE-Meta: U2FsdGVkX199aAg1CD5KCOrliZ22q4IEwLqvwFXxXNQxYxUos611Iq4H8066mDi05Jg3jg5e3OwAI68pv/OiYEDWXZcR/RLYiRhVSXH3x8wMAn5YRkvvKnVqnGqfM92Xv2otggVzqTL7rcjTvuEO3bl4Ki5x4AOIxXieH2qz+8/jaystkxQ7CH4gFmPxjuUrdl+iZkqoilugKa0vcqhsabg1OLcPjElqQ7P16JZ+JekHi5oIBf9QQg40WJuk7KEkykGPclN5UPC+F7OzLit/t3QSTaLXJkG1C05Odbya0NITzRsLN/iB3S3w30irNnlVXbEp5B4tFioSEUwNGon4ORCSImN58C8S0Y+j+eXoKEgiL9hJbwQWWdo3SnSAiEGq4NJdTpVohinHFMQBPhLKF8+RnwrR6lqN4mz0bF1YTLXw0zoExK6x3u6qsLyIyiZUVurQMgq7QbJ6YCFhA8xAV4erAvsTd9LN1Nx9pizWTvGg/jFdDEbo3w0zo2u7zCwS/fjeFP35tnbaOTUaBjnr/fd5UB9X4IVjrVLccF3/2C9j4JouMdtj+qNaynLyW/nPAdFnoRHz/CIapEOxH9BDUj3A8yFAhWAdkmMcp81KBN4WqrhTaK29vNV07W9tgN7uILUv2wS4Vz86qVIlVn3+VkKXGG7ea04n5PBs3bZQY10/GF4whcr1U9+r0vVgXkZSG4fRnm+3nmGX4epj4As9ql1HqA0SmabFYbbcfCOj25Yro7d+scXdZcJAkn/lMl18EYzGcobuCFt5yI03QHze45E5RTMMWlk7RZEzQtRBOAKFCOkNvPs1aeEnvnsueN1d/6Wj+C3ntviUatais6tpBkUq3/37j+kb52zv3xxn653uwJ8ye55kGcNGsJRRpSnpEDzLzfVMuJYVRHzRkd9/2mLWDelBtEVD9Blgg9jHh9rrmyU/9tN2StAlrabMdSrgjmsxjvOAbXDWqaqnZ04
 PKfrS7OR
 AtcwjoQlZjB47wYwd0el42ZR7BkGueCoAtWcaHtGIsccZzN/lpJKseNcCvptbyJgUs4pvR0Gsvt5H6MHLqAzjpZ0kUvp3Ng8HUgO6ockp8cbV63mffBPfxrRUNOyAmlTHqtXY652VkmKxdrxColNfNLHWzEaNm4NF18o03GmJrQ+BsLLEmnLkF8JuOgWuvkZShKBdXrVCvf3exBxNhcvvI0NWfb5ywtPAjdn3x1td8xQjp0ihxB3Vyv7JnWpuic8fxz9AvSQC6BTPTRkRS9LVc+Svnyn5Ra8W/rL4FrjAm7DJlgP5++5EIrJfamxU6SokkDgMjGUjOay1216wTLPCJAX93u7y+PerjzMIvKKv2viKuFc7We/Vwya4sn+o3tyRk/dNaNszeLBE/OdXcBKwwJTYjkZoJ7sdPGlNjhTCv42s/cjkp0984qUEbFbxj19gEm6TGV2Et6v0kPQAihaoeXHkWY1nIDLXU3LzV6EfAo3pgFhmhZscyCYXXP1Ad6UDN2MGtfDham4qXFgJuT56t9hmVXklP30VhNzmk32glu++tjDpnInhHqiVmEwQ26Kltrr8YXs661OZ3FM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a sysfs interface for the Live Update Orchestrator
under /sys/kernel/liveupdate/. This interface provides a way for
userspace tools and scripts to monitor the current state of the LUO
state machine.

The main feature is a read-only file, state, which displays the
current LUO state as a string ("normal", "prepared", "frozen",
"updated"). The interface uses sysfs_notify to allow userspace
listeners (e.g., via poll) to be efficiently notified of state changes.

ABI documentation for this new sysfs interface is added in
Documentation/ABI/testing/sysfs-kernel-liveupdate.

This read-only sysfs interface complements the main ioctl interface
provided by /dev/liveupdate, which handles LUO control operations and
resource management.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 .../ABI/testing/sysfs-kernel-liveupdate       | 51 ++++++++++
 kernel/liveupdate/Kconfig                     | 18 ++++
 kernel/liveupdate/Makefile                    |  1 +
 kernel/liveupdate/luo_core.c                  |  1 +
 kernel/liveupdate/luo_internal.h              |  6 ++
 kernel/liveupdate/luo_sysfs.c                 | 92 +++++++++++++++++++
 6 files changed, 169 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-liveupdate
 create mode 100644 kernel/liveupdate/luo_sysfs.c

diff --git a/Documentation/ABI/testing/sysfs-kernel-liveupdate b/Documentation/ABI/testing/sysfs-kernel-liveupdate
new file mode 100644
index 000000000000..bb85cbae4943
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-kernel-liveupdate
@@ -0,0 +1,51 @@
+What:		/sys/kernel/liveupdate/
+Date:		May 2025
+KernelVersion:	6.16.0
+Contact:	pasha.tatashin@soleen.com
+Description:	Directory containing interfaces to query the live
+		update orchestrator. Live update is the ability to reboot the
+		host kernel (e.g., via kexec, without a full power cycle) while
+		keeping specifically designated devices operational ("alive")
+		across the transition. After the new kernel boots, these devices
+		can be re-attached to their original workloads (e.g., virtual
+		machines) with their state preserved. This is particularly
+		useful, for example, for quick hypervisor updates without
+		terminating running virtual machines.
+
+
+What:		/sys/kernel/liveupdate/state
+Date:		May 2025
+KernelVersion:	6.16.0
+Contact:	pasha.tatashin@soleen.com
+Description:	Read-only file that displays the current state of the live
+		update orchestrator as a string. Possible values are:
+
+		"normal"	No live update operation is in progress. This is
+				the default operational state.
+
+		"prepared"	The live update preparation phase has completed
+				successfully (e.g., triggered via the
+				/dev/liveupdate event). Kernel subsystems have
+				been notified via the %LIVEUPDATE_PREPARE
+				event/callback and should have initiated state
+				saving. User workloads (e.g., VMs) are generally
+				still running, but some operations (like device
+				unbinding or new DMA mappings) might be
+				restricted. The system is ready for the reboot
+				trigger.
+
+		"frozen"	The final reboot notification has been sent
+				(e.g., triggered via the 'reboot()' syscall),
+				corresponding to the %LIVEUPDATE_REBOOT kernel
+				event. Subsystems have had their final chance to
+				save state. User workloads must be suspended.
+				The system is about to execute the reboot into
+				the new kernel (imminent kexec). This state
+				corresponds to the "blackout window".
+
+		"updated"	The system has successfully rebooted into the
+				new kernel via live update. Restoration of
+				preserved resources can now occur (typically via
+				ioctl commands). The system is awaiting the
+				final 'finish' signal after user space completes
+				restoration tasks.
diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
index f6b0bde188d9..75a17ca8a592 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -29,6 +29,24 @@ config LIVEUPDATE
 
 	  If unsure, say N.
 
+config LIVEUPDATE_SYSFS_API
+	bool "Live Update sysfs monitoring interface"
+	depends on SYSFS
+	depends on LIVEUPDATE
+	help
+	  Enable a sysfs interface for the Live Update Orchestrator
+	  at /sys/kernel/liveupdate/.
+
+	  This allows monitoring the LUO state ('normal', 'prepared',
+	  'frozen', 'updated') via the read-only 'state' file.
+
+	  This interface complements the primary /dev/liveupdate ioctl
+	  interface, which handles the full update process.
+	  This sysfs API may be useful for scripting, or userspace monitoring
+	  needed to coordinate application restarts and minimize downtime.
+
+	  If unsure, say N.
+
 config KEXEC_HANDOVER
 	bool "kexec handover"
 	depends on ARCH_SUPPORTS_KEXEC_HANDOVER && ARCH_SUPPORTS_KEXEC_FILE
diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
index cb3ea380f6b9..e35ddc51ab2b 100644
--- a/kernel/liveupdate/Makefile
+++ b/kernel/liveupdate/Makefile
@@ -9,3 +9,4 @@ obj-$(CONFIG_LIVEUPDATE)		+= luo_core.o
 obj-$(CONFIG_LIVEUPDATE)		+= luo_files.o
 obj-$(CONFIG_LIVEUPDATE)		+= luo_ioctl.o
 obj-$(CONFIG_LIVEUPDATE)		+= luo_subsystems.o
+obj-$(CONFIG_LIVEUPDATE_SYSFS_API)	+= luo_sysfs.o
diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index fff84c51d986..41dbe784445e 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -100,6 +100,7 @@ static inline bool is_current_luo_state(enum liveupdate_state expected_state)
 static void __luo_set_state(enum liveupdate_state state)
 {
 	WRITE_ONCE(luo_state, state);
+	luo_sysfs_notify();
 }
 
 static inline void luo_set_state(enum liveupdate_state state)
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index f77e8b3044f9..05cd861ed2a8 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -29,4 +29,10 @@ int luo_retrieve_file(u64 token, struct file **filep);
 int luo_register_file(u64 token, int fd);
 int luo_unregister_file(u64 token);
 
+#ifdef CONFIG_LIVEUPDATE_SYSFS_API
+void luo_sysfs_notify(void);
+#else
+static inline void luo_sysfs_notify(void) {}
+#endif
+
 #endif /* _LINUX_LUO_INTERNAL_H */
diff --git a/kernel/liveupdate/luo_sysfs.c b/kernel/liveupdate/luo_sysfs.c
new file mode 100644
index 000000000000..935946bb741b
--- /dev/null
+++ b/kernel/liveupdate/luo_sysfs.c
@@ -0,0 +1,92 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+/**
+ * DOC: LUO sysfs interface
+ *
+ * Provides a sysfs interface at ``/sys/kernel/liveupdate/`` for monitoring LUO
+ * state.  Live update allows rebooting the kernel (via kexec) while preserving
+ * designated device state for attached workloads (e.g., VMs), useful for
+ * minimizing downtime during hypervisor updates.
+ *
+ * /sys/kernel/liveupdate/state
+ * ----------------------------
+ * - Permissions:  Read-only
+ * - Description:  Displays the current LUO state string.
+ * - Valid States:
+ *     @normal
+ *       Idle state.
+ *     @prepared
+ *       Preparation phase complete (triggered via '/dev/liveupdate'). Resources
+ *       checked, state saving initiated via %LIVEUPDATE_PREPARE event.
+ *       Workloads mostly running but may be restricted. Ready forreboot
+ *       trigger.
+ *     @frozen
+ *       Final reboot notification sent (triggered via 'reboot'). Corresponds to
+ *       %LIVEUPDATE_REBOOT event. Final state saving. Workloads must be
+ *       suspended. System about to kexec ("blackout window").
+ *     @updated
+ *       New kernel booted via live update. Awaiting 'finish' signal.
+ *
+ * Userspace Interaction & Blackout Window Reduction
+ * -------------------------------------------------
+ * Userspace monitors the ``state`` file to coordinate actions:
+ *   - Suspend workloads before @frozen state is entered.
+ *   - Initiate resource restoration upon entering @updated state.
+ *   - Resume workloads after restoration, minimizing downtime.
+ */
+
+#include <linux/kobject.h>
+#include <linux/liveupdate.h>
+#include <linux/sysfs.h>
+#include "luo_internal.h"
+
+static bool luo_sysfs_initialized;
+
+#define LUO_DIR_NAME	"liveupdate"
+
+void luo_sysfs_notify(void)
+{
+	if (luo_sysfs_initialized)
+		sysfs_notify(kernel_kobj, LUO_DIR_NAME, "state");
+}
+
+/* Show the current live update state */
+static ssize_t state_show(struct kobject *kobj, struct kobj_attribute *attr,
+			  char *buf)
+{
+	return sysfs_emit(buf, "%s\n", luo_current_state_str());
+}
+
+static struct kobj_attribute state_attribute = __ATTR_RO(state);
+
+static struct attribute *luo_attrs[] = {
+	&state_attribute.attr,
+	NULL
+};
+
+static struct attribute_group luo_attr_group = {
+	.attrs = luo_attrs,
+	.name = LUO_DIR_NAME,
+};
+
+static int __init luo_init(void)
+{
+	int ret;
+
+	ret = sysfs_create_group(kernel_kobj, &luo_attr_group);
+	if (ret) {
+		pr_err("Failed to create group\n");
+		return ret;
+	}
+
+	luo_sysfs_initialized = true;
+	pr_info("Initialized\n");
+
+	return 0;
+}
+subsys_initcall(luo_init);
-- 
2.50.0.727.gbf7dc18ff4-goog


