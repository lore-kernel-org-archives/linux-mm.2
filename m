Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77EF0CCD1A5
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 00:57:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 067EE8E0012; Tue, 21 Oct 2025 20:57:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03FB88E0002; Tue, 21 Oct 2025 20:57:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E96AE8E0012; Tue, 21 Oct 2025 20:57:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DA8858E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 20:57:30 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AA1FFBABBA
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 00:57:30 +0000 (UTC)
X-FDA: 84023937060.29.160D4C8
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf22.hostedemail.com (Postfix) with ESMTP id D2EB2C000B
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 00:57:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Zg7trQIk;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761094648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pcy9ROlMFFrxYmRYWOB+KoxotgZLEgmv04f04lRuCLg=;
	b=faPx+vU8VKnoi4ENAa+VE8sCYPSEZJJRUGWnLckgDjMl4zx86nIXKQGltddgxrUVuJ3LAf
	B59UH7jnzNtqJqjiQGup4HM5VzjpsSol/yX91WA3zkVDO3G2lY2rnPSF13al1nIyZsxHXK
	ufxjhrsJazfCsPecjtzI28ZCM2yi+Q4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Zg7trQIk;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761094648; a=rsa-sha256;
	cv=none;
	b=EwSPWgfEOAxu3BcqjFaiUTy83odmpEuJcrILiI23wxmcXH5VREDtoM2exHN4p+OWA3dz94
	2QB6O8JhBA+o/M14BgNVMYhd/ZAKxPoOuNZeBUbNK10r/iz9VQgrHedNIaewULh/h5g7iK
	o72j+yUKEmycIudodGQPOK6S+brMJCs=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4e89d4f0e8bso5195691cf.1
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 17:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761094648; x=1761699448; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Pcy9ROlMFFrxYmRYWOB+KoxotgZLEgmv04f04lRuCLg=;
        b=Zg7trQIk9zt7nz3U18pgNz6V1+y0GyMxQYkR7ZZkhDnUgCO3dvD5lRRVDOiIC3Qkkl
         rxzjgFtOzmpg/JfaTmNcwP3crPDCkwMEo+XyyiYF8I4iwMSySwrX2vnISz5tCwcqns4/
         a0M7zQJqxMFAnxBTBx2ZkQa8NdJDRFOI/fohU7HJq02LM07M6iSL/OcFdYJrqMr6BhuP
         MIRdDbGnqa8pprbNhgbXEHmloCZxrEQLQmcXjl8saMQTvNC/WfCmF5i3hQUcs01/FkB2
         TeyxYtZKUrjycJGyVj91cDZNgyFb69UhYPvOs551RVYPiycB4J75S0g2JmOdXfodSH9a
         eB8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761094648; x=1761699448;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pcy9ROlMFFrxYmRYWOB+KoxotgZLEgmv04f04lRuCLg=;
        b=AQKVkQDE6C0/5QIfKWsFEbYV+KB+dveYVg7IEY7HGDfko4Ff75VbfCEUQXSKivAita
         m0uMS9ZpXUDV53V/Pv/K1oMJaTAf/kJRPPGofMibMa4KuZU/1zvAbjTVdxSfexKReW3/
         OPI5WRJ53Uj9ZYLByiYJHtLJqq00kh5s3qZA1Jz89iENWHWpHTFot9uRqGtDazNsZg0A
         PP/JajZ8wr9Xn1mw5rvGwZBHMVd7xKShM9crgC/aqcufkPoO95d2+X22yuTCsFDEAU4e
         kWMbZXOF83P7lZr6vBL9gEfYJHfAqL7s5UX3AkIP1SdmWi6PcfibhVbbwFZsvtB1i7UQ
         vwWg==
X-Forwarded-Encrypted: i=1; AJvYcCUlzDhoo54HJwMTVrmTTM52gAHEipAKcTpRLmTXT8C2sExmn+TU2WFV5+iJQGQZV5FLd1RXj0P/hA==@kvack.org
X-Gm-Message-State: AOJu0YyPrIQRSGr/KghLd/RXgPzaOMU5kjqFswXe2yH/x+w6Ss7xE6qK
	ObIDUcv1kr2BHTldVMMj2HiaeDAKSlZIVZpTaCT/2j87VhG1XqLdbOy7a2goQkGDO64=
X-Gm-Gg: ASbGncvI/djsxSdMmFQCExxVT0Lf1Yne+54LGcAj/COM69PP7eV5hqFT9AzPDnG5jpf
	nqs4r+d2IMXTXLg+n/snlhxAUHOlDV80cKiMP0bFsy1gytWrcBvxphnTUrw2T6F1O3SV0wTsBAo
	G5oHD2zterBcZeyH5vy/diRLBCe8MP+saUn4MuhxkXI1xpmdJMlKEtVt5nZvn1t2pBfTA6HLg0w
	UhLy+YtWzuyKWg9zzY8mmStWSWFDxOSMd8vvOZ0qjWZG05ND/qAFDLzZ7u3P2ujApbT7zTBrElp
	Oew3JelkF7HsjLvE5aCUfV7gvwK9cJMDIQhgnpjthzSeN5xmFzt5QNfF5vC8VWFFJJz8I+koAZA
	5I5OxMsPQ4NzywefEM5qL1wzeSL8IYs2Kk2Oix94rLdbjzduINSYzIeCXEEzvn5rf0PkIcVWezP
	9MpnixucI0c8cuCnFR9psoTB26egK0Q7uQO7UFguGe9bkoqTovO8JDzS7o2HtypqDhu7GCunwGP
	0kFMGcoLdbyFu31OnKGPw==
X-Google-Smtp-Source: AGHT+IE6c9SGq1VaL57v0krF0Yo2JROYiPXfKdfjnZS+o2r+gBektScJV8dUmdmPm+e/5KTw56WryA==
X-Received: by 2002:ac8:7c54:0:b0:4e8:b3cf:b9fa with SMTP id d75a77b69052e-4e8b3cfbabdmr154195831cf.29.1761094647906;
        Tue, 21 Oct 2025 17:57:27 -0700 (PDT)
Received: from soleen.us-east4-b.c.cloudtop-prod-us-east.internal (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4e8aaf3432dsm84169501cf.2.2025.10.21.17.57.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 17:57:27 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	brauner@kernel.org,
	corbet@lwn.net,
	graf@amazon.com,
	jgg@ziepe.ca,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	masahiroy@kernel.org,
	ojeda@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	rppt@kernel.org,
	tj@kernel.org
Subject: [PATCHv7 7/7] liveupdate: kho: move kho debugfs directory to liveupdate
Date: Tue, 21 Oct 2025 20:57:19 -0400
Message-ID: <20251022005719.3670224-8-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.915.g61a8936c21-goog
In-Reply-To: <20251022005719.3670224-1-pasha.tatashin@soleen.com>
References: <20251022005719.3670224-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9mmf793a83k65a4kg4zmj9m1ge76ij9g
X-Rspamd-Queue-Id: D2EB2C000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761094648-534998
X-HE-Meta: U2FsdGVkX18nwu0pvVp3hDy65JqW2a2K8bbBsbkLEBKXNk01VDxDb74yPsL4lngQzQ2selQhNPiBc2q7xtjamlCGufsRF1KCsmjZ/ZzrcY1RtJI8zalc1jcjh8nHsnrz2vyDrZbYzYoT5wuzTMNmZeFAeqgtUeY7p7dSB1PM/nGnQouKj9MM01UXKJLxdHw0XchGjXVl5/0dqfw8Map+7okDlR0YTEAANkTM9ECY2bLaTsY6hcoX8CHYMFJcIkh3c5r/RJm2CsRzRV9Ah3FO3i/7/TCdq3P77wTNtP8DP50eFIFiI7wLAh3VnnD/ZPdTtbEKYhgavSNiLoTJe5nJ2BXEx4P744ifGCvz+YtBKs0uOjSdtHMdmEguswzcQQ5WrwuF9Z/vviOXDM4oC9kouZdkqAL0BmXrBy9szB8XgSmc2q/JCOcATpK4B5x2VZWXBvVyj+zxovS6wcDfKkc9numG3z/ZsqbcR2tTL4vL95vK/aMUrT4zXns+Io2bHB7lwpMnekU7PWfjAlJAus4ClRq8RfkEAxGAC12hoR1Ud/j2tDxuHimaXoQ7ytnHQjk4mtUpBZNl7oaWWmQYG3uSI2dRVleETYJqDOHKgRanw6TJcHpzyLNjWsN5x+oM74xjal7ZAgtSBi0VwuLqyJhAiJ6bG7M/H1RcS73CKxwAHwG+gdPf79EdoTYcygboOxd9M16S4VeacQNPTQDMdLdpPNnUJOQXaSBRVs006B55yOkG1WYDMcFyE5PBkbcqCT/CgHr/Dap2T558zlM6NhP1kR42ZtmiO41vKul4DVahJw6rJ5t24HgTogJKm0aq/12oSTnrxH7FPann9332/OQxMjNZiV+VE71DkAbf0yr6wWlSxo9pAaoccjmHZG5/MdO02x9INph9UMiQsbtWeJKR5s2izMBz7+eIkdJ7me/5HsoqyuPLBQ3scETKy+1nzC4l2TsZGJutZaTMI70HiZt
 Uq6UDakL
 LgguMNvprxtzAf7qBmJSzy6M2gM/Kz4isV7Tj9m+FKfkVBbQXJFstfx1pPLPp5uw1sIltSFQ4t20VrGOgT33iZ6TaW6fa50mxQr9vv28B2Gl00rGV4t7ARTWK9Nm0+y5SRdrtU71D35g0ntetK4WFlWPbwqnrNzykjtc0BRUwUqQreu0PFUQ+ELXy+F7agElYqwWgV25FakFep3WqrtQu7eJwb2AVBbL85wfaZrUkhLlBEqgCxj6p8ic9zg66Z9SN60uRtPNzdY2uNXRmaNFBlbeJYvcqfogQ3WumrMk5vr9sqKWzj734FE1gc/jCkdFSFmtZLaG1jbhOEqk=
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

Also, export the liveupdate_debufs_root, so future LUO selftests could
use it as well.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/kexec_handover_debugfs.c  | 10 +++++-----
 kernel/liveupdate/kexec_handover_internal.h |  2 ++
 tools/testing/selftests/kho/init.c          |  2 +-
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover_debugfs.c b/kernel/liveupdate/kexec_handover_debugfs.c
index 46e9e6c0791f..454b7d34ddc3 100644
--- a/kernel/liveupdate/kexec_handover_debugfs.c
+++ b/kernel/liveupdate/kexec_handover_debugfs.c
@@ -15,7 +15,7 @@
 #include <linux/mm.h>
 #include "kexec_handover_internal.h"
 
-static struct dentry *debugfs_root;
+struct dentry *liveupdate_debugfs_root;
 
 struct fdt_debugfs {
 	struct list_head list;
@@ -118,7 +118,7 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 
 	INIT_LIST_HEAD(&dbg->fdt_list);
 
-	dir = debugfs_create_dir("in", debugfs_root);
+	dir = debugfs_create_dir("kho_in", liveupdate_debugfs_root);
 	if (IS_ERR(dir)) {
 		err = PTR_ERR(dir);
 		goto err_out;
@@ -178,7 +178,7 @@ __init int kho_out_debugfs_init(struct kho_debugfs *dbg)
 
 	INIT_LIST_HEAD(&dbg->fdt_list);
 
-	dir = debugfs_create_dir("out", debugfs_root);
+	dir = debugfs_create_dir("kho_out", liveupdate_debugfs_root);
 	if (IS_ERR(dir))
 		return -ENOMEM;
 
@@ -212,8 +212,8 @@ __init int kho_out_debugfs_init(struct kho_debugfs *dbg)
 
 __init int kho_debugfs_init(void)
 {
-	debugfs_root = debugfs_create_dir("kho", NULL);
-	if (IS_ERR(debugfs_root))
+	liveupdate_debugfs_root = debugfs_create_dir("liveupdate", NULL);
+	if (IS_ERR(liveupdate_debugfs_root))
 		return -ENOENT;
 	return 0;
 }
diff --git a/kernel/liveupdate/kexec_handover_internal.h b/kernel/liveupdate/kexec_handover_internal.h
index 17ae101dc6ae..92798346fa5a 100644
--- a/kernel/liveupdate/kexec_handover_internal.h
+++ b/kernel/liveupdate/kexec_handover_internal.h
@@ -15,6 +15,8 @@ struct kho_debugfs {
 	struct list_head fdt_list;
 };
 
+extern struct dentry *liveupdate_debugfs_root;
+
 #else
 struct kho_debugfs {};
 #endif
diff --git a/tools/testing/selftests/kho/init.c b/tools/testing/selftests/kho/init.c
index 6d9e91d55d68..f0136a30ce8b 100644
--- a/tools/testing/selftests/kho/init.c
+++ b/tools/testing/selftests/kho/init.c
@@ -11,7 +11,7 @@
 /* from arch/x86/include/asm/setup.h */
 #define COMMAND_LINE_SIZE	2048
 
-#define KHO_FINALIZE "/debugfs/kho/out/finalize"
+#define KHO_FINALIZE "/debugfs/liveupdate/kho_out/finalize"
 #define KERNEL_IMAGE "/kernel"
 
 static int mount_filesystems(void)
-- 
2.51.0.915.g61a8936c21-goog


