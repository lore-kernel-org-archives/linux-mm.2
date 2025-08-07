Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BDC9C87FCB
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 01:46:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 721A56B00AF; Wed,  6 Aug 2025 21:45:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D1746B00B0; Wed,  6 Aug 2025 21:45:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54B776B00B1; Wed,  6 Aug 2025 21:45:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2F5BD6B00B0
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:45:20 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7024F11623A
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:18 +0000 (UTC)
X-FDA: 83748268716.08.BADFA50
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf27.hostedemail.com (Postfix) with ESMTP id 64CFB40012
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=je5zOl9n;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754531116; a=rsa-sha256;
	cv=none;
	b=mBDXcHP0L+6TYEzdALCLDuP2paQHh9FTPk6S9t9agrQMqICectgtny92i37kl3xHIv+cUT
	Xa10VpfZ2NEkOIUr/Gki8GEcL2VIPcytJNLyuoQ2dsLvPJ/n1PAE6nLQ+3SLm7eHqLvsoz
	XL4Y6zG0OMJMIsW1rAv8x0cCbD7nsDc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=je5zOl9n;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754531116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WF/QU/y7x54PCzdmrSK0bQUFRNe6CNoszBlEiHHR+XM=;
	b=Aummtcl/GqxO+BUptm4jK/z02BURKIQqvHL8eNPqQ/OHhjmDJWL8FE3gpo+LBux/kCzdE8
	1kQg742BI1W3DKMtGRNk06HK1bHMp7sgMZM0UAa/jZ+zQ0mRWCqCObXOfnr+plYNbtpdwG
	WY+knweu6reVJnb67/W6QG1oCFZQ+pk=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4b0a0870791so7513801cf.0
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 18:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754531115; x=1755135915; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WF/QU/y7x54PCzdmrSK0bQUFRNe6CNoszBlEiHHR+XM=;
        b=je5zOl9n9fN20ukJER66WATqI2G+/p06qrRTVd78e2tUIdPNyKU30kakGNenuTcbfL
         Kta0G6nodNRtKYangJOXhvDrH5hs0bEpDBY2HvZ9ishY+kqp9Y7lEhEy80iY0bj8KaDv
         DYG3065G7yIK7qS9PMfHgrHFSUCIB5JW9NLckAfbTb5uMdmiJe70oxN7xN02Wj/CrhSF
         PH9Dz0RSRa+wVDBLqVzzRYTzL2uZ8Icou7abE6J89WseeJlEtJZY+2acdH3ehAC8mMek
         Pp/OSxD8gRUxQMw5iiThINmPO3iqyU39nnLFrKasWKmHhySbDBSqeMnibbuGXpZ5c9wX
         HITQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754531115; x=1755135915;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WF/QU/y7x54PCzdmrSK0bQUFRNe6CNoszBlEiHHR+XM=;
        b=tTkOGUVQ0CW5mpE5Ha8XK4TSW2p8gZ9R1/p+6Qs/dxhYqxjMu1bg394xwCUKi2s/N+
         MYshpNb+LxELRw7YY8JiNVMquIYu7DAg4NYLtVxwFA9ylgn0DLOg/hHZjq/7IReVaR+D
         F9pcexzt5TCzYJZsgT1Fq1FSF3EHDOxTLtsXIHlTauIRfTfjStMLSbvLvkpc2cee1E4Y
         qM3gTfEM8d6svTdHA12ocn3p3BuECGkjdaxXF408mRy9v1GrTIuOfABl/v3smBqR086d
         D7LVPx1ob9X3Lhsz9OmoyDg9dCRSI/yjUuoMD9XwBwo+zgcKZ8vs3s2rdZ1QxFgjHAq5
         WMsA==
X-Forwarded-Encrypted: i=1; AJvYcCUgmj5HvgK1tdsnbvNoshPXqPZQvRjSqtMr0fBh/FbI6I2QMVsJ1iBpATv/4mbFYvQ1cqHl4igQyQ==@kvack.org
X-Gm-Message-State: AOJu0YzoFbuIvg0YLFdgC3j7kyQ2/+iZ+pYIAp5PlB1mt5l+YO0BBD/I
	++0KV89K8weGLXoNpzfZWm+3/iwAXkzezYCc3IYuNIm2LLzcyKFKR5NXEYQcSKEL3a8=
X-Gm-Gg: ASbGnctynIh1/FtpJ09oLrVGNuEHvkOK+gsZn9fF6JRgAXWRdWmIo6qgn7dVJ00tuZm
	jh4FIGPkziDyl/VHiOfoeYg1kmdGPfAssyj/WgtcdFLevm4Nzh9BavtgQqmieTyNc2aIp6f5Jp+
	MxjIzEVfFTTxHHuA9WzRPYC4RV9oYAg30v0DAdkGKtmyUnuzqJlyWwHDh/A5O1BQ72np1AZMmQ9
	tiRz8cS5Rh4hl04eathy79fpEeAEFGteDpypLDHN5r8bIyQNDZWCP+/cAdaFD6MD2XC5MByRdmB
	BRBhJeWRVh/Fg7ekSWgjrjgHd7KSv/pWMt/6W6WdYrRySI5TktaSGhuB1SrZpyPFDgj6vBrLkr2
	SyuskjGP+cdsthkI9h9ZI0WMyHjvzbOrn1Qf/VUROFLCMVjfevUyY8PZDsheCXvZYIve7MIMSkA
	3sZmcEtw/O7a/DdUkjCtRKrt0=
X-Google-Smtp-Source: AGHT+IFKHH1YeAK0b2tzEkZQep5rY0nibsccM8bhcvnZ6YiF0cNDdr12cF9wjVLlo+2LNmKUV8uQBg==
X-Received: by 2002:ac8:6904:0:b0:4b0:6463:7d0d with SMTP id d75a77b69052e-4b0915c39d2mr77833781cf.42.1754531115362;
        Wed, 06 Aug 2025 18:45:15 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077cde5a01sm92969046d6.70.2025.08.06.18.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 18:45:14 -0700 (PDT)
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
Subject: [PATCH v3 19/30] liveupdate: luo_sysfs: add sysfs state monitoring
Date: Thu,  7 Aug 2025 01:44:25 +0000
Message-ID: <20250807014442.3829950-20-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
In-Reply-To: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 64CFB40012
X-Stat-Signature: 11ytwcqp66g8atwpf7jhxwjbq8ajzdeq
X-HE-Tag: 1754531116-918063
X-HE-Meta: U2FsdGVkX19ILqpZsVnIQ1MStF+cZi+rlsrx9xturP3V6oV4+y0HcJa/eViCPiYiF6m4BXfV96XboFJ7aI4uWQcikST5D2+e44raJY1LW7lv/AAc+ixdizObVrzcrUn1glGuICc5JD61SKV4+ruXnLBCh3CJ7FryZ2LB+4QFZycm6he6KepWWr1VIMp6F8zPBdvYqS82STi0trnL1DqJl8+C3loFWTq0Rh4loAC5Gpuoq/GxreLFpjVf+PrtQ4BL3OgeH8tEdA+B4zIq7DuG/Tr/JJB3JtRyBJGg6h33p77aj9UG+xgcSK/+ijpkrDsivuMB34jUf2vsdmW4GD3y4lKDCfnSx8hj/PUKNqDR5+54qJNeUVGBRNcxBP+PCWq3QfKlAlfyx+iPItIc+pI6lWwkhHkbRhwTRTogxOxNAqyqQgVFu8yPS4b5J7Urbrs62rn6oOVuAMfl5Dnurq+5nFWsiXAKjZeZhaZ3GhwMFBsJWuRPEW69k+RVPtgh3n2GG48cJv/EngPklri+3aNcB29EtB93AtZZgrTxFe4RWZSAq3uRFxMRbn7KF9NEf6Cls45MuJ0y1JyN+/LI949Em3qYJzhZ9GmNng7bt3l7wBFBsihSH1CAO9eba0Y0SlguTVsudMHF9PYDdWlfb/8/E15UZBOELcdzTtthC0KekuADNhqdP45fMV94s6kld3TGYhFt8BMa7G7AwN1jHPO3TRgzaEngyf92jtCxHX0QSePbGF1d9sbHUvFThRnTkNJPDu1b58QZ7C8Z93tMdb9W2BiNq+yl5YXgRY4N/U3N5T9L5xqnt4SZ3L+LnZ0ORlRlrHb52U7FTa3p+zKalLlfbVMiK+tWAtNPqegZO9tRaJj0irRNM8RCUCBZswoJNpeQtZ6gnFksqiDTimRGYhA9uHfnLTOK1CqQovsfkKLti6EIH/oDxQ7A1IgRYe31Z5xWcehepz44DgRunwfgW0x
 v+V2QmVk
 sOh9HrNp20uFy00SR60bsfG4hrHKzs6PirSM6rFFj5e5ZANyPFTeuVXcIMAZu3bcM7Nahfw3J/k63oW4LoM3k6mB43KI7TXk8yYy8Ysakazg6YrzsyyTEQrUtrnhQGqyBcofQva+hSgtegrv7zjMoZmbbNmL4wS8yEfBEigynUC1t/QCk2Kj9kdh9ywlUcyqrX3w6+ouQWcMx6kYi0xSTJqJ56zbfFi0IxWXKb3fHEWYP57hDIDr1QgHgYqDvNOHoerqF7gi9TFkGZIETwhMCET/lDM2iGf3bNoHGYhgRMJzrAX3oUxR0Ie4u4s8qvxqX547r7oZQ2ebGKRKw4BbAEbll37FyNR5APOK1qg2bybnnIsq+RMh31a6cJ3OCDzQyl4NM/hg9SqJMyUXtoJcMiOb0N/yXvTq1q5IYTTFJs/CTJyoTpKsRxWDFpPRnnE6ReGFkXZFtmjcv2Hfs6cbR9wj1GUI31hYj4jwS
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
index c67fa2797796..47f5d0378a75 100644
--- a/kernel/liveupdate/Makefile
+++ b/kernel/liveupdate/Makefile
@@ -13,3 +13,4 @@ obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
 obj-$(CONFIG_KEXEC_HANDOVER_DEBUG)	+= kexec_handover_debug.o
 
 obj-$(CONFIG_LIVEUPDATE)		+= luo.o
+obj-$(CONFIG_LIVEUPDATE_SYSFS_API)	+= luo_sysfs.o
diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index 64d53b31d6d8..bd07ee859112 100644
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
index 01bd0d3b023b..9091ed04c606 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -47,4 +47,10 @@ int luo_file_freeze(u64 token);
 int luo_file_cancel(u64 token);
 int luo_file_finish(u64 token);
 
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
2.50.1.565.gc32cd1483b-goog


