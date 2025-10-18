Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41378CCD193
	for <linux-mm@archiver.kernel.org>; Sat, 18 Oct 2025 17:18:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ABEB8E000F; Sat, 18 Oct 2025 13:18:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 635E78E0002; Sat, 18 Oct 2025 13:18:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FCA78E000F; Sat, 18 Oct 2025 13:18:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2DAF58E0002
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 13:18:10 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EC6C0C018E
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 17:18:09 +0000 (UTC)
X-FDA: 84011893098.18.9E67386
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf11.hostedemail.com (Postfix) with ESMTP id 22C4440002
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 17:18:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VaTPsuhE;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760807888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i2rPu3rJk61NsUDORe6hfrEPNayKm6hvJ8nWbKNdE/g=;
	b=Dfhg+ZRwg+8RK2YQjXMm6c5dE341lxXs4gMUQHVCAHSAN4OiBu93FiXo/PFK9RmGmDCknT
	XaCYMBOGJOuPQQCV+90fJRcLs6px8plGDFZWCEwqo02FVbsZNjZPzp9P0MZF4PUg1/JUjo
	oP8yIVSXsQhjkg2+V3s6g/eZm8VbdaY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760807888; a=rsa-sha256;
	cv=none;
	b=FO1C9AyJVGe/d2zsFigWCHHy2oORmhZfxTeZeqFzdZkMV73rRkeAm50REKB4wt4bplDeJi
	7+cGwebrE4uNxYPXgUntuPWY5KIbff9jz7mC6PSqOHsUom+oHhbehrCYAFPImQ7QehgB+b
	FBo7F0EpDodQvHOINVlEVBYKzIiMl9w=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VaTPsuhE;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-87d8fa51993so13141256d6.1
        for <linux-mm@kvack.org>; Sat, 18 Oct 2025 10:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1760807887; x=1761412687; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i2rPu3rJk61NsUDORe6hfrEPNayKm6hvJ8nWbKNdE/g=;
        b=VaTPsuhEOw5pqeJSeh4TEnwcaadB311lymhSeyaES6SpQ95yzoauM2PUgF+fmoRlCJ
         UqsVk2bYaMmT06+aLpzTWJxMn5IGxUwkjkv6rnd83fiAo/EdqaOKMeHIGqxKwB+REpml
         muorW+FOTMWYjy6jYcSbXFP5xwe+hk9/QXCfMS2pUS+lDAWvuvAZwhX13Uzg3MTlN99D
         gKvb9DMLpLlNaa/FynMwmNwxEEBx1yFJWnRK/nDxlpTqn1XsR5PFygmoRIZH374qSwXo
         0PB4dGMPfOLC/EjavgdmpQ0w3nwo/FMp9RBNujOKU1WAzCjm0ZImHCpeZCWaBAyJFIO5
         Wmmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760807887; x=1761412687;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i2rPu3rJk61NsUDORe6hfrEPNayKm6hvJ8nWbKNdE/g=;
        b=bggxw0I9LkPKaFOx5EaCWsHNDqTQjprEJAZcgPHlOK7TX3iliAq0UbvF4WHpCYWIoy
         WGEuH3eug5DMLXT5k9YPnJEN28/1LCASbqnkDc6EoAZtv87hn2vsh4IsdvMD62qOr7yn
         RQi8ZYCmqPBp8AxN/bkj3xjMAPyz+/gTdWPOis/U3TipE8+pCOL/wmHFJkVRVQonZga4
         sKTmgEwURevq1krBkdMq3Q3iFEPBAu6BbTcoZhdnPq6fhD7h+FbgOtCiRHR7Hmhc8/V9
         xpts3CKaakfyrnijE9JNjYf/xOT2VJ5WgogBaIw1O7O4Hzo+7CfIkb016k4WkpCRQaPu
         u3bQ==
X-Forwarded-Encrypted: i=1; AJvYcCUtO8CiE9Qwr3ng3gv3Tk2+IE2fyIYYeYoTG6oVZb1/f2DcVEPQWKYOFaK55pmuY9SpndmFXy6M5g==@kvack.org
X-Gm-Message-State: AOJu0YzjACdKWQ3Eh9iPs5AbOdSujcvDa7KQnvwLKbhKPOSdYwrMy00O
	kk0KF/XYl7Wbg2/i0tP2LFdrEQvtFuIhGgu6PasP3ManbaoK43sFdDJkBlxHECr1BEA=
X-Gm-Gg: ASbGnctn0p+8aMhk0gl1dxahRpHyUtKchAdnfu7rNlqJFx1YoDS1llahKiqD2ESKCt4
	HxcVVV0eFAuX1D8wtHbQkwOabGraTv7eogNEftEB1JpR42E+s/rXiDI+duoREEXNGi21Y9eYmD7
	atG2wXJd62lb9j+L0tOIUr9ooy+ZertiwnxgHinOajomkIhT+Cc3LVaEu4n3FmEcLi1xZYdK7WU
	WKRBl6h313O0kFv4wlhBhc2/hmVQqW6mh4f2KjowecmeUwJm8KUo5I5s7EDevBa1ERmH6vObtlC
	YHcWmBZtPWIDeG9vjHoDmcxOBvoHZEhB8hnk7NIQBuu8HqifDKjMOceTOLKmxEFQzwQFogvgyTs
	76znf0iCmkgcg+GwURKT189vWrIRGzj8INP8WsA6h2eHXJbGk1l5SVy/Av5KvMv2UTKYDPyUk2B
	RKT9dxSyTxM46Q6gIp1Q0z4pTaFp43tfeKKXq2wEvORTiwmyi+f4F2LdpQD6Hqk01avbspeF/ym
	LducIIQUZHISXIxCpr2gSBkioE+kyrW
X-Google-Smtp-Source: AGHT+IFVF7YTAGmDUxpNHm20v159jaCZkyWRtFxoFzlU1BR8eeX69kBkAQ/hkjYMJqzT0Bo97bEDpg==
X-Received: by 2002:a05:622a:1a18:b0:4e8:b889:5c3c with SMTP id d75a77b69052e-4e8b8895f08mr10843041cf.33.1760807887246;
        Sat, 18 Oct 2025 10:18:07 -0700 (PDT)
Received: from soleen.us-east4-b.c.cloudtop-prod-us-east.internal (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87d02d8e909sm18478116d6.62.2025.10.18.10.18.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Oct 2025 10:18:06 -0700 (PDT)
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
	tj@kernel.org,
	jasonmiu@google.com,
	dmatlack@google.com,
	skhawaja@google.com
Subject: [PATCH v6 07/10] kho: move kho debugfs directory to liveupdate
Date: Sat, 18 Oct 2025 13:17:53 -0400
Message-ID: <20251018171756.1724191-8-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.915.g61a8936c21-goog
In-Reply-To: <20251018171756.1724191-1-pasha.tatashin@soleen.com>
References: <20251018171756.1724191-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 22C4440002
X-Rspamd-Server: rspam02
X-Stat-Signature: iy13gx74dgai5sy1kxhgtogteukswd7n
X-HE-Tag: 1760807887-418893
X-HE-Meta: U2FsdGVkX19gRkKGESZRXzARSdslKNFyo0avkWp5mG7xSglViiG1NkHqr4aY5K34i4r1tUW8jyTas4lS/vuaMnF7A5WjF6/Cw/IW0O4x06eqon7dFr9UwoHnsLZ7osyr+++j6dP59kBRMaCAI758anxANNDFcdby5LTShhd+4/uJv+DrvWQS1T4q+x7kXaBGf/4mFph1mu6FPmOutHa/3n7dep7XOEM+M4jTOz1YCqOTWIPGmMdmC1kcZjnXwE+wuRCIFzUsjM1hph1ysyEcBQRagBx2+LF6OujJ8f4DLyJURhEHVbPc7lpbmFbvtbwreGYX5QaoA8K+jyIT4swJ6bWmvCtdESA5R/m8VAJJ2DuVvwN/G9F01OSMIh2zQvksIfNnRSVPtayN1QgzNQZWcDlBKAN1d/Tos0vRRpY4aT3r5kHKieqfPe3zBMG75/Sm69ALhkz2O6fBr+hy/T2zoLi0YaZbcGIEDYeN/tNpZCMZQQN6iMfR4d6ft3exBiDpMft91NG9nt941Xb0+w9Re3fyeyznxSdlz/ZaCRmU6ze139u3AvXF1tt4q4+q9OIfAiMqpxk/OVruWwXfEc9v8JIZvIeu8euQT3V7g8UMxqB7VV6LloOvy8MahKbCrA4GyoS0w03D8vScEM/9erQZ1j1R1lTmhypBQOLUC/oA0/ZSuPFsnIvz1NghcBVW9AWAK0okjjgnLSez0fRfBDoAsyv+fUJOgwuwSKJSXeIWqORUvcOdxHcQRFv/tNZWx1dbwQOVEuu73khNjqLhlxZUR9NQTrsJywejVixev4Y6Sv4XDv1ib8AXCC1YXHexuq3iJYM5OuN2sJF6EDIy9fopQRdgCN/xHLba+pOQN+ulXB9yWQuyIpnI0vt1aziBYNWLLy5WnMEIEt7tyrISK5vs5vo+iIpQShiXMhjbbhY5MozNfhI1KOnl5VKvBMDLTmHuMFNAFVNYqUjhQx3IGtj
 OFo6KxYL
 nU7cArWqEffEwUdel5rca4HjW1ImPwDhnGSdfqAX/U4kjHLUIcbtC9hxU6Tds4yvXIlymfi5JHLztUwrN7Ws2HVVDATDXiKrBHrK4RktkM5iKEoOnbY7+7sNtdNHPSGvI/gsPUen4A0/5ldsa4BQBlCcf2l1mgtdJfEn353wCR4msiTQgc35PigbeAzCQCgMUlpbPqrVoUQwTj6w0DepFiLF0WvMAfrSIaRQ0iOqNjITPnUcfYfOOlW+cuu7tKaKtKnuq3zgTH6fByqdJVQ8D+o+l0RmQ3WKn7V2b/XHHRlix/HRFC9Fm7wL4kQXNK+BpHVdS4RYXuCAbzxI=
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
index 6ddcd17fac3c..63447564dbe8 100644
--- a/kernel/liveupdate/kexec_handover_debugfs.c
+++ b/kernel/liveupdate/kexec_handover_debugfs.c
@@ -15,7 +15,7 @@
 #include <linux/mm.h>
 #include "kexec_handover_internal.h"
 
-static struct dentry *debugfs_root;
+struct dentry *liveupdate_debugfs_root;
 
 struct fdt_debugfs {
 	struct list_head list;
@@ -115,7 +115,7 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 
 	INIT_LIST_HEAD(&dbg->fdt_list);
 
-	dir = debugfs_create_dir("in", debugfs_root);
+	dir = debugfs_create_dir("kho_in", liveupdate_debugfs_root);
 	if (IS_ERR(dir)) {
 		err = PTR_ERR(dir);
 		goto err_out;
@@ -175,7 +175,7 @@ __init int kho_out_debugfs_init(struct kho_debugfs *dbg)
 
 	INIT_LIST_HEAD(&dbg->fdt_list);
 
-	dir = debugfs_create_dir("out", debugfs_root);
+	dir = debugfs_create_dir("kho_out", liveupdate_debugfs_root);
 	if (IS_ERR(dir))
 		return -ENOMEM;
 
@@ -209,8 +209,8 @@ __init int kho_out_debugfs_init(struct kho_debugfs *dbg)
 
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
index de90a678274d..b3fc1957affa 100644
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


