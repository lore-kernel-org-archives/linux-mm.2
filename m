Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A156ACCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 16:10:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 513CB8E00CF; Fri, 24 Oct 2025 12:10:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44C3E8E00C9; Fri, 24 Oct 2025 12:10:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 317068E00CF; Fri, 24 Oct 2025 12:10:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 10A118E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:10:15 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B7767160ED0
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:10:14 +0000 (UTC)
X-FDA: 84033494748.21.17F3A80
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf14.hostedemail.com (Postfix) with ESMTP id D6EA810000A
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:10:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=E1V2tCu0;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761322212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J0Chij7I5YmPbNPLJtF290sPw75eaI56z9Bpyk1lLtA=;
	b=al8+WnuOaO7rEX7n1OfLOPPXcB9NW8oQpHtNZSZ4kzdIBFaq0K3vE7/vCxhKTn8GFE2NvH
	LRWhvAuZ1WjPQEINKIZX7sn1aQWD7CZ6bG+NjKZVduPur6UdK/DnQBeJsJOSobR0SrAUgd
	PEGZtTN9RU/RPwQJ+8UKHh5gw3Riydw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761322212; a=rsa-sha256;
	cv=none;
	b=if81QwvdWuY3R+VU8Kx6o6M2FTx5pBMUC9jeEgFzAA8pW/SSgzo/1AVXbO6iXxk50OJxmm
	2dOsDIORrqUXE81ir7gcGQsJbhHtK9mvskRdTEz9cTm7eTo5p869Z1sCcqdQm2t54rxjvV
	1HF+xcGYF2h2ZKRbJr23hDPd4vCLSFg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=E1V2tCu0;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-73b4e3d0756so23223907b3.3
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761322212; x=1761927012; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J0Chij7I5YmPbNPLJtF290sPw75eaI56z9Bpyk1lLtA=;
        b=E1V2tCu0SZR7B7SmKwWX5A1r+vbGnCLzmQmBCnKs3m24KWxqE9yYVUzY6kp/aZSOWW
         PHNSqL7UGWM6U6NbQJiRTG6zNV2nGwHsMRBgocJmicIF4zCb0pyUKwnqG8HlRP3hR3w9
         wA3kL7ApWhDbTdvCd45aP1HQMmbYc5XBRk88mWjO+pAGk4Oux+oNalmW8bFtUd76Jhnz
         /wE807eaKSpOK2bgd07YR6VeJTMskVNHF/kTXLCYcdYFTj2ykbp14P23aH3yb3SolRPx
         Ww/A913WomN02hxjLzxWn8I4Grst0UZWEOewaCWeplioswX85aLM9GSdMKEsIHQ7kFnQ
         E8BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761322212; x=1761927012;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J0Chij7I5YmPbNPLJtF290sPw75eaI56z9Bpyk1lLtA=;
        b=XnClWjiQXgw/VYCWdTN0IGpWhjQk2O9GBG6cNqjkEmH0IUERete8cTVypUl/6AkRYn
         eJS1ufDUABEeoMmAMT8OamOH7LWeVyC2hks+pUd/nLPaK4fX3Th1mcBMHsN5e2q4/kC6
         hX7JZcI8qURjGtOhApMA7QRgRe1TGjSfEjhj9El070rKHkMDKDpn7+1sXv76CiGbz2SV
         F821PmrV9uA9dBkBHCXqkRWw92d7cbaMqhCi8ZBAR35bfJMG0PGahM5l/UkshUkGyGxU
         6SFeqRxo1AvtDOORPgdMdd+joI6dGUNUHY/QD7KfNtBDCIpOKEurqJyLpnhPocdOl5Gz
         HFPw==
X-Forwarded-Encrypted: i=1; AJvYcCUhjEyRlBWBvDD1TBA/Ots+TAV9qmpoUFggenNjzD56WOz3aqEih+CqrpIL6NjCVelQELNAXCNKcw==@kvack.org
X-Gm-Message-State: AOJu0YwyHp9qW8OpoTSUAz9lvnGsjw6E1Qe+WNXdvkFLW32zYEd70+On
	l0F2FMNsm4R2ZiyFZR3AS/xyuG94QnBYdAI56U4rRfrmj6KH+HxWgerXGYY1cndy37FKwhXW/KF
	ZQQlX
X-Gm-Gg: ASbGncsHDnkZtGMML2GjHGaG1WUSFqErBXh1Km9drLXiKF/2oA2AvzB8LRJEXAitB6u
	IKIfa4kM4FtvO9TdcD/t59xIOkhqxfTX438zMERf6wUKkQC0krxBSW1Jiqxx7I5oI4ybaMcmzRA
	kOFZEPUc1GnoLRum9crBYEOXuHsC+BTZlHbR7Y8dV9+YOQIiJAxs83RXPHPYVki/1V6a3nDGWbs
	O9IZdpoFVQ69gyJoBAIqZycnZvi5y1fjlkHw96GK6Gm9+3W2oHEyhqUwzyi1VE65PdNUHI8aPKh
	zN0E50l4EWpz+/x8MgmC6NhE/0dI763YEJzJ8c/rcU8DUNBu12FDPRLoY5MgQtf3UZVvGxlzVeW
	WwFHLa//Nd3H/V0f2/t4Ci5lrx9gvDeLqTr+e3SRCBhY4YLYS8qk/nle4b22zutzNG4Uigjk5BR
	qWYhzCa/S+C9L7GMngS9yufm8tCHgHThclPnUnQzI/SpiuY5jpxODWgr/UqikZsbZeYzJ16Mla2
	c3JlUGLKNLUGB3smPAsZao=
X-Google-Smtp-Source: AGHT+IGrHktoB2+zSyNVNIoeQp5HcQOC7JtCZnm9h30tzfcmrjcwbTqgqHhgYQabiysiaKaamJl5yw==
X-Received: by 2002:a05:690c:dd3:b0:780:fe72:934b with SMTP id 00721157ae682-785e0231474mr22622787b3.48.1761322211974;
        Fri, 24 Oct 2025 09:10:11 -0700 (PDT)
Received: from soleen.us-east4-b.c.cloudtop-prod-us-east.internal (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-785cd6edd87sm14099197b3.51.2025.10.24.09.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 09:10:11 -0700 (PDT)
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
Subject: [PATCH v8 7/8] liveupdate: kho: move kho debugfs directory to liveupdate
Date: Fri, 24 Oct 2025 12:10:01 -0400
Message-ID: <20251024161002.747372-8-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.1.821.gb6fe4d2222-goog
In-Reply-To: <20251024161002.747372-1-pasha.tatashin@soleen.com>
References: <20251024161002.747372-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: dz3qe1579c4o6tgdky5adkhe695pkhjo
X-Rspam-User: 
X-Rspamd-Queue-Id: D6EA810000A
X-HE-Tag: 1761322212-521566
X-HE-Meta: U2FsdGVkX19sChEi1OVXl+wE4C0FsHYl0SFvXJMovzAS74QXx/B4dNCvRWZCLehoynncpRXC0OZIHdCrqwR7K5GP+cYthyBNPwc+VieOcpa/RQYESElVhv+pEVaxkL6olui1V/bG0YFXnuFBCvE1shTFrm+pfHGjvKimZfOFvpGF7qXMfzSVsWZWq+muoQy1Vmyon1PPVNVXYvVhVVbQptDnMsBkQxtQtNUXiHnJK8FYSFSp+GWbBXVGy1ijKWPb8EhF4Lz1ZwdNsCApLsZbHoU8kySelpTO4GFjPpToCNMgtujmg7LreCdMliNMbnh/flbzXHVfHFdXtW+Ou09MmA2v27FHNy2Drm/w/kpwS7022aLCIt/0ykDx8O0z1cvzbaBrGolWca1jzXAFqtqwHOU77+u1PhHBxwlIFzSaed8ElIkcAnzMVEVhnjjMusX+reYjez9xqx7HFrM6/uuzbZRa2V57uu9oOKGmyP/OVkQHzpIerqIbQXY5mKf6WqPFwZMmwrBKcdyfi9zQfIT7ZnWwf93JbKyud7IiuYISyZmlSURa+ZZHq70H4OreA5MLbusKv8K4XRZNdLaxBnWhubTOzXBQ9c3stfoGGrzgGpT5tv+fpshO7r1G91ZA83lAH3oON7TcA8kkL87CIT2aOiS81v8rjrqmH3js+oyKUfl2Q0APlbrFAWZGubjUhDqFE5HPcdM0sI6Hqdh7gZ/dMGpaRipEiR3c9SwN/AcdiEFsWhm1CQDrENfFuLlNj0LFwqhC/lPZHlu3Sg/9IyY50pEC/kovncu0aqZQ9v5OtDfaiJeiSUni6Wfj5SuSQfGO2IP43XFPCzGaOhJKdJINCKEiaRcdhIRwuiA6Sz1uyQx0n0XEKJmxUR1nXZ4XJ4ifUMt1ycG+CGE9vDzT8cg6/DFGAr/b6vV87hcQKoP2gVldVJ6sH2SRUhkCgwvYVos7kUVaqSGoBy8N+jZjn1G
 dXjKTNnt
 mbQWx186bC5/jGOEO8t1CLLEGdAGZddmR/7eDX5DHcWl74vEFElZSPZP5mzcwhsAXCugUWCHxnVSwHMXMfTQUQ6joTVmWjxj4VQUND/lFHWMhpbhsw8fnIv9caeve1sG2DfOHCmwLr4nSqKavEZgFVjR2qEtwbYfu6XiW7inWaHZmq8MC6h3zGPDMsgPoahXaC18GhhJBByPrYPnTyBKakcVpze3wQMGquENknpg3WQyGdLdBQyfAmtkqLMbaTBWpKKgSVF6Zn9AEMuPuTQO4xlSRVJJbHKZ9gbf85K0p7n6wbxVBYCpiQ3ELcbzsdC/cmfg8q/KXL5U7BLs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now, that LUO and KHO both live under kernel/liveupdate, it makes
sense to also move the kho debugfs files to liveupdate/ in order to
keep current and upcoming LUO/KHO features organized.

The old names:
/sys/kernel/debug/kho/out/
/sys/kernel/debug/kho/in/

The new names:
/sys/kernel/debug/liveupdate/kho_out/
/sys/kernel/debug/liveupdate/kho_in/

Also, export the liveupdate_debufs_root, so future LUO selftests,
kexec telemtry, and other users could use it as well.

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
2.51.1.821.gb6fe4d2222-goog


