Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA605C87FCB
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 01:46:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 636E66B00B0; Wed,  6 Aug 2025 21:45:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E73D6B00B1; Wed,  6 Aug 2025 21:45:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AF146B00B2; Wed,  6 Aug 2025 21:45:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 397206B00B0
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:45:21 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 02FA01DD541
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:21 +0000 (UTC)
X-FDA: 83748268842.06.74C1CFF
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf25.hostedemail.com (Postfix) with ESMTP id 438C6A0003
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BV+QPaFf;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754531119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q7wVeHC0BKF0BnkzpBtVk7MqDMjUeUEopTUe1tEjQ6M=;
	b=LWFKP3er88wag7a6p+IbBWchb3oZtbR87toTE/UwXrFAzduCP6cnn9cOx+XnHqQ2LiryMB
	4SDKkI0WF20nBSisM/oGtTqwmCFDSHL+xMoO8l13nHs6NRs1HOxjBzplWoC6MQ5DWBj6QF
	y/aOCOT1MWPNM0J0bAvDKjXBSSgLtao=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754531119; a=rsa-sha256;
	cv=none;
	b=okFem4KVhfk6FRTV8O2wRTlOXxM36OdCCgr6r/BtygHN0LaniTnJz3LG415+mWa0dRAzru
	JXNq1yJlcZU1ECu/vhGTRSFRLZNcpET6wPNUK9fH7fGw/tf+jAjkoKTwLQI7S+MOQd44jX
	zm6E87NdRKp71jUCi10yf31cNU6QNoU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BV+QPaFf;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-70884da4b55so6136806d6.3
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 18:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754531118; x=1755135918; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q7wVeHC0BKF0BnkzpBtVk7MqDMjUeUEopTUe1tEjQ6M=;
        b=BV+QPaFfF+dCqJGh1IMCxznDf8RORuA4fD6pp4vYKuNCafUFgrqgVneHZ/BBOvqW5F
         S0kUN78b8MiodLQhmAb4fvKNcrus7czFJ+lduN2OzrRbHMkeOn+7i1GkV9+DqhU6yCLn
         IDkPTbYxzFwF0notHVULM2Oosg+VIjzqad9SmJC/ZxU/DDUAVwT9VyabPeOEpo3zpy8X
         oMEUxsBmpG6AZuVzQjrRxfoTpIn3qndBNZhc2P/zDOs9k/k2VzxIhO0hWwxSu8Ir9MKN
         5G2mbVxmc0YjYkoeXFFXvZqlYp7AJvgbGAhGFCdBVQrn+k6i6mPXJAFf56JNmNVLj0PR
         7bkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754531118; x=1755135918;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q7wVeHC0BKF0BnkzpBtVk7MqDMjUeUEopTUe1tEjQ6M=;
        b=xJh/Iei81U6BPtTUc3F7Bwc7xIzbeFLufQ0LJ8p4ZB/MnmXIExAzsosMgc20DXA+eS
         Mrplmz8FbOIoVx7ArUfkGxEI2Hh40lnOMLck4G1U3TWXuLfYGpH75YljJk0fcXTd20VX
         4t/zU/aaXGpZYxhc2A9eWry8lQDVXoNTEs6FkPOWv2SGBUmzigfhbak5tzWn3+IjnDHi
         zk3MDcPdHwlhRJI0JyqjR/JIjEqCMqvXq8C2eplXkKJIeEK5l9qzdk1iHlRISA+RM+bI
         9n+WE5lSn0ZYhtEnizVxmuCCh9SB1gLiym70W1rhHIup9Ln3q/FywYmhG1/rYSGQFPps
         gMjQ==
X-Forwarded-Encrypted: i=1; AJvYcCXbWY68OdybjdLIByiCdC7+rHbuL5B/tFIDd2lSiT69tT8UWyxVukeaBW2ynovHUPE7vbG+7b9f1g==@kvack.org
X-Gm-Message-State: AOJu0YxOvf/TgyaMZZ3DLdjuhRQOyGmGziteksJQG8EEdgyOGmiqwx++
	TE7SN3qYrayfOP/hk04Yfv33wLV/jldrY+uuEk/z87GCIFVZ/jo4UvRx0HMtXS66w3E=
X-Gm-Gg: ASbGncvJzy32x1EO/DRjh6MSNy0UDhsXL1c5Ku4m0ggm0CFhfw+GqjtUBKslFpLxrlt
	BYE7YHlcFB+fsPNpr2l6Dtlq93Br/YvVhFP4ePSvqdebtmTbUmrmnyB4qKmJQWs9HqQyRztxlSz
	R56QjJpIFGZIjmExd1jBCNPYbkZkimjPHUvrvO82Fva3NntsNshBYCAOa6CGav+o8+GwRPCy7rU
	6li+jq1uteTqXAzOYlMJykVgAWnPsJkwkiYPvuCVwuNmUiki1KYd5lUTwPS5o/C9P6lJHYwlTzy
	dSZxNPEViy2pvVZF8KrRDlh2o/5/d/zj/LjH6kb/yLQLx0BQNiyOsdnS0V7lxiXhxnegB0sZgya
	UU2tKwDfrssftLflAD33Zeh6M+iBuq7m+Pit+MdTgxLycmS9WBM5DG6LTJO0mTSLjcHplG2ZkX3
	u+cVSFpoiTXYhQ
X-Google-Smtp-Source: AGHT+IGUMFTnXz7aA5TeYDEGpdy4VXQ/e6kO5So5tD5I7KBD7rTcRc491fmczfxSCGd/3u9GjXp5RA==
X-Received: by 2002:a05:6214:2587:b0:709:65cf:be98 with SMTP id 6a1803df08f44-7097ae1016dmr57649496d6.8.1754531118246;
        Wed, 06 Aug 2025 18:45:18 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077cde5a01sm92969046d6.70.2025.08.06.18.45.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 18:45:17 -0700 (PDT)
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
Subject: [PATCH v3 21/30] kho: move kho debugfs directory to liveupdate
Date: Thu,  7 Aug 2025 01:44:27 +0000
Message-ID: <20250807014442.3829950-22-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
In-Reply-To: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 438C6A0003
X-Stat-Signature: 86hjk6to7ts75hh6a47pd5t36yxjwkwz
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754531119-208342
X-HE-Meta: U2FsdGVkX19Ug3v1+t/wZkeS4lCP4ThKhlsi2c0MKCN4YpQoAlK1T6C3n1oXQjhXbLIcxYCPvpgMUNZXxhRrDLI5pp8LgWvRH4bM5kRm716Zz5Xqyfvo2GoTKZKALYPm7Psy1L0T05e5djLQ0176aKbCORRiDmj26vj/kozAmBHkBND1oh+GkQ+oP8gKhvpPEycnEby6BL12EZRxA1bMJeCxrvYCrjHeVwkBEzEZOrZu7Gdo93I2lbS6jtYFLrpNKilJ2JN7mmF3koz9Kd30hR25NtH5QPCH8w157HenWhA96mQhFm4Sy8raZSkavjHdjLeMdWbV5rz7P1OGYbSh113m+3EFLuczXqBoIUImaDT6RictqtYwHBj7B3xRX2p+7J3/O90v2gvI7hfpeVLXBAKFz3KiBPU89W4/q6cBWPGNO6Ze/4YPqKW9YP67tBXxy1tL4ZSCS8/sQU9Dhuq0O6pmQsVdP5d2k1wmTaaa47b/cbc3YYJhRgRNEhz5yJQiHHUUlm72z/w05Q7t+ll9jzsJodVS9P3xfLybn0UCQoqQWk6vfN68P72UHTNYfU5bZMZucIMgfvSzbIHR7NDR/VGTFRD+SwEjxR5TLpTudktkdN2bYkMys/YoJHqFisXZKalqOaAj/KDz1WpmQhypVrmFxMBY0j6dxI22TUtdWuVBUjR5K8ayhOszgeQIBBhoKsqgWXzrbsRtSS/O7oqOwjpZG5yhTzkM7oN07Mh7/A3UH0x7bEmPBcLrDNzP/ZsswFPN699AW5EO57QIRyHD4tyKluI+px5HeAXdf0B9sF2u6bE9czDPWrPBe1tRjnh7GRj/QhTX2xcLwUAv/HuAUXFE+yDZwbYken7rVziQTjockCmR+ht7Am1V3+/RS0ft2xHfdkD0S+pqGVHHom4a9Rw3F2zRqClSk+zhTz+60OermEzE032xW3FrNtYfkZo97TedQVadoVzTEcAe+nI
 eLHKnQQw
 rPgJNP4phyQRz1uSxVVoUklZ3gjNEM4XWnRLENqfPNFxVneZyxNckvmPkpPExpcdLs76mXQjiMWtV3WFMhRr4aiXpV6xcgqU7W4A/ZrdhPfQzu8zt2xjmxCva9OJw20fq8BeEzaBq/gYasQgk4REkEhTz78jAa/Cg/MlY6FKbNtXHH8zwxJJPNCvJAQn7Tsob2dva436CJmGmOT/MKyvGM5oBc0bs7EHUL8xQf05Jio78ANx8i4bJ3DmLtOE7s0qgFWfjTGLOHN1/GyslxrqCgtTWrn2C0tLCpNfOWsuJYf0hPtUO78eK28FoC1qBQKUHqqVwbEYtoxWOqp8v6I3MH/I52K+m+82KSBTpY6nDSMSBjH8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now, that LUO and KHO both live under kernel/liveupdate, it makes
sense to also move the kho debugfs files to liveupdate/

The old names:
/sys/kernel/debug/kho/out/
/sys/kernel/debug/kho/in/

The new names:
/sys/kernel/debug/liveupdate/kho_out/
/sys/kernel/debug/liveupdate/kho_in/

Also, export the liveupdate_debufs_root, so LUO selftests could use
it as well.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/kexec_handover_debug.c | 11 ++++++-----
 kernel/liveupdate/luo_internal.h         |  4 ++++
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover_debug.c b/kernel/liveupdate/kexec_handover_debug.c
index af4bad225630..f06d6cdfeab3 100644
--- a/kernel/liveupdate/kexec_handover_debug.c
+++ b/kernel/liveupdate/kexec_handover_debug.c
@@ -14,8 +14,9 @@
 #include <linux/libfdt.h>
 #include <linux/mm.h>
 #include "kexec_handover_internal.h"
+#include "luo_internal.h"
 
-static struct dentry *debugfs_root;
+struct dentry *liveupdate_debugfs_root;
 
 struct fdt_debugfs {
 	struct list_head list;
@@ -120,7 +121,7 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 
 	INIT_LIST_HEAD(&dbg->fdt_list);
 
-	dir = debugfs_create_dir("in", debugfs_root);
+	dir = debugfs_create_dir("in", liveupdate_debugfs_root);
 	if (IS_ERR(dir)) {
 		err = PTR_ERR(dir);
 		goto err_out;
@@ -180,7 +181,7 @@ __init int kho_out_debugfs_init(struct kho_debugfs *dbg)
 
 	INIT_LIST_HEAD(&dbg->fdt_list);
 
-	dir = debugfs_create_dir("out", debugfs_root);
+	dir = debugfs_create_dir("out", liveupdate_debugfs_root);
 	if (IS_ERR(dir))
 		return -ENOMEM;
 
@@ -214,8 +215,8 @@ __init int kho_out_debugfs_init(struct kho_debugfs *dbg)
 
 __init int kho_debugfs_init(void)
 {
-	debugfs_root = debugfs_create_dir("kho", NULL);
-	if (IS_ERR(debugfs_root))
+	liveupdate_debugfs_root = debugfs_create_dir("liveupdate", NULL);
+	if (IS_ERR(liveupdate_debugfs_root))
 		return -ENOENT;
 	return 0;
 }
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 9091ed04c606..78bea012c383 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -53,4 +53,8 @@ void luo_sysfs_notify(void);
 static inline void luo_sysfs_notify(void) {}
 #endif
 
+#ifdef CONFIG_KEXEC_HANDOVER_DEBUG
+extern struct dentry *liveupdate_debugfs_root;
+#endif
+
 #endif /* _LINUX_LUO_INTERNAL_H */
-- 
2.50.1.565.gc32cd1483b-goog


