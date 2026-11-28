Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1DD4606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 09:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=ZMT8PZN/
Received: by kanga.kvack.org (Postfix)
	id AE6566B05B6; Sat, 28 Nov 2026 04:21:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A213C6B05B7; Sat, 28 Nov 2026 04:21:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 937226B05B8; Sat, 28 Nov 2026 04:21:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 17F2E6B05B6
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 04:21:59 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 95FA41C3E40
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 09:21:58 +0000 (UTC)
X-FDA: 85483985916.12.667B222
Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	by imf28.hostedemail.com (Postfix) with ESMTP id 99D54C0004
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 09:21:56 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b="ZMT8PZN/";
	spf=pass (imf28.hostedemail.com: domain of chris@chrisdown.name designates 74.125.224.45 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795857716;
	b=nrUDhWPZHNM5S81AJ+U9t65TR/0s0DRJg6mgC9lAyTytwr5SBVL/MWaMJyB3hm6H+Oz3Gw
	KTIht4c1WswtORAAvrtxYP/KCkayiGOCoi199ASk3hBjUDBMyT28MaAHhp1S8m3h+8sDtZ
	o2UoCxGymOTDzklbjY3y8w1aPeHH92g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795857716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S/tHl+2/aELrbIwf0Ksau3tprNWFE1rPE6zNQAZmUkc=;
	b=Fm01Hwoayp4fukdkatRs+ZkSJO8thE2pQMD+Xdn1vzmAoIoCD/pjG3GIYP5AdaDI0KWYzi
	VnS8oaibi6SWJWmqlDvNSquf+ZREDlBrQHIpNI9eNJtzB5Mz93fZ9TMFqMc50gyi8oUCAa
	8hJEHq0z5J7wZxrg7pLYUG0kEpI1cJE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b="ZMT8PZN/";
	spf=pass (imf28.hostedemail.com: domain of chris@chrisdown.name designates 74.125.224.45 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-67dc7eb1442so9519430d50.0
        for <linux-mm@kvack.org>; Sat, 28 Nov 2026 01:21:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1795857716; x=1796462516; darn=kvack.org;
        h=user-agent:content-disposition:content-type:mime-version:cc:to
         :subject:from:references:in-reply-to:message-id:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=S/tHl+2/aELrbIwf0Ksau3tprNWFE1rPE6zNQAZmUkc=;
        b=ZMT8PZN/QhM+0fZxMeayiMm2hOITHUzuUHB8VYN8leo/wHLYJKysrzdk+ZolmUnwtP
         TLwEJrCO0Ngl2SBxOBzj+SlCXoQzfjTF0Dw6MFWeja8FfhHwrNiWotoAZShHU7pNt8SL
         4h//viln1B3NueYqOg/hahA5c1NvcBQlDErdY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795857716; x=1796462516;
        h=user-agent:content-disposition:content-type:mime-version:cc:to
         :subject:from:references:in-reply-to:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S/tHl+2/aELrbIwf0Ksau3tprNWFE1rPE6zNQAZmUkc=;
        b=Qm7wDaO9AcSOjpIfU3X5TDKR7I+4rLEGHgdqpxOfaSEozRFXHInbhMf7I+StxBdJyy
         4D5Ww5bR4AVHsXe3ui7oooujpmz0QuDh62A9rAFdG31iDIjq3/LVP/QGN39k0qjiBOmO
         hpZKoRtWOiAaTVWIRmtWEY24ocGXEyzoJPDodbXiwzNVWwNgBrXp0JPAQrpd8QtN0VfP
         BgSN7jGjwzRZzBWfJ0PkR9K85NSBfpIGTb92FTAE7P9TWIbdwc1PJsdmAOdSA9L7QebP
         H7fetTagrlqcm+z2Lk8Jn95O4XnHnthGrIbhWsvCbowmPo3Xe1mHzAoZ4KU9K35SsmZG
         RJNA==
X-Forwarded-Encrypted: i=1; AL+hErEB4cc84vSvVqMTwrpM3/FLXzrJsUBC0X0xWQP2oewOW6Wf2BJ2BfXe5Dx9ZXzvcQFAORa3zEx/bg==@kvack.org
X-Gm-Message-State: APuU4Z99QPm66olcy7uKna0MRXhaG+iNz6bOHs/UuPcBHb3ug5jWh4LY
	0fvX4fDt8EljQ4QPR2CYCkFj6Kt6EzWjCHSkDhXGgTE4t/zgp7KDwTcAgZSsWm3ZQeM=
X-Gm-Gg: AZFdTZdGy8GrzzNt/L3S6XRJXkpKO8Uk1gPSWqr/V55Rpe04MC6F2rIMfxvKCpPpogK
	SNeMcMGWU5Zr5D6BOaECXVZjIPbJGXS78FEGYThYijiz3y6GK9P83wwVrniCp0TyPhF0pQ1olqb
	btXyKb/cIrnrhq5m3LW+9b8iz1CoSvGKq1JTjBPWNyyuELo2KthL8Pz0nSrK0B2TDbwmh6x5fMl
	8oqa6YdZiHbLBOMTxQF5+VVrXV/kkhsnvqqdXek96b1lZYl3m6HYh+SOrjNjoloOzE8U+su5L0T
	/ii6U46saGbse5IfNlxeMSt3N2dm+HwIVd1gJFhGkfdZaTYHAZO6BpEMnvGfBHt40q8+zRBp86t
	ApmBKGsOiTkqm0fenEi3bi3oRMsBpiFPDr3eu+pSkkwiDpk4e6YrcjxURMCya0Kp+kCVXKPV8H6
	zRYxZCbHUOfSufY7AzLWOqiPNr18hcEn0B0p4HtfkeZwkomwXb6mvr8JT68b4WgGT6ekqe44Jw4
	/oZZiyhH70NOoLH4SaeF4NHXZcuj/XD8P3ZygvM9Y0GhzA+Jd1XFrmWI5sUEPTgKmNJ8pDa4nf0
	aqmn77aoc0NbOSf03yfUORMDpRXeqpShi+20myAXLQynGrAnD0MKA7pAZBCmPfu/lMbK/Vx2yQl
	7ULVqQcXw1uQFqDUBFbFFIqzXdeOkSXGHYLBpa6M884q6pIFPrfg8ThppIt4A8uJrqanabJk3Pa
	iGLNc9PQBTmZv+33Kk3S54x2viUQWxA7hbswWF3cK5ZFLAai09EATq3ttzAirLxT+8fVmoxUebj
	UPVl0NBiTeqYqzyKFANvH4=
X-Received: by 2002:a05:690e:b8d:b0:679:cc49:55cb with SMTP id 956f58d0204a3-67df44b8ae6mr13485805d50.99.1795857715699;
        Sat, 28 Nov 2026 01:21:55 -0800 (PST)
Received: from [172.20.0.3] (c-73-207-185-9.hsd1.ga.comcast.net. [73.207.185.9])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67df33e01e1sm12359048d50.23.2026.11.28.01.21.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2026 01:21:55 -0800 (PST)
Date: Sat, 28 Nov 2026 01:21:52 -0800
Message-ID: <ea408fb02711a52bdd9aef4650c7079945a2bb71.1795835884.git.chris@chrisdown.name>
In-Reply-To: <cover.1795835884.git.chris@chrisdown.name>
References: <cover.1795835884.git.chris@chrisdown.name>
From: Chris Down <chris@chrisdown.name>
Subject: [PATCH v2 2/2] kho: don't fail kho_init() when debugfs is disabled
To: rppt@kernel.org,
    pasha.tatashin@soleen.com,
    pratyush@kernel.org
Cc: graf@amazon.com,
    kexec@lists.infradead.org,
    linux-mm@kvack.org,
    linux-kernel@vger.kernel.org,
    kernel-team@meta.com
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 99D54C0004
X-Stat-Signature: p6kwk1u8r3551ifed3ky1rzys3zb7449
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795857716-885389
X-HE-Meta: U2FsdGVkX1+D0JC1O6ChgE0rYeJQln7MKcGo8bJTrMV0foF5/NjC+54r4W6X7DFF9/ILcnOncizK+1PrEcSpCX2u+EUAcN/V6QKEEzOxyB4vJCVgD+at7s12w1d89oxSLfh8WQD2O2fY94d1eqqRLO12WFNlzHM+s1m903nHLOmvFw5yBXpL+q6U0BBQOtRO9alTQ9VOad9Cu4nQ+WW2+FiogFaYLfJ8OP5/7R5YmmErbK0aep7V4iTC9LrxknQNNf7BIXcNCvjpDlN8MeO9xO+6T2aTJUQgLSVDuAnu7t6XmX5W5ZEuYot8seUUPL6xC1Ddn+mzp9VFmVYA7oToBoHMa1x+Exiu8xf92xBbpBannPliVngqnxqZ1K8wIB43OWrIABbC/LaEPyA/yvKqomSl5ynZITCuZZ6s5R8AhQ/3kcatlZKlwignqM6ty394W4UnALrHjlqghfs89ju4ZJu2XBx043Da0q1uDs7sH7m8eLcMPUjMqaD9MSsxB6mBezxq5yU0sbR/HjYw3DZr16T1p/QCyzXAtHljUAVPmabXL7KbKFPjsUsLowmUf/hiiR/1LTvl5zDGx+fVtYrli4P32GJ12C277K02/SU4zNRm7Jl+/f0qxa789lo3Cc4N5SI3kczRX9QCTnZ5r6KQZWaStILRbmdI8dmbDAfJcaZB5ywLCZDvFCO5UiAqFHBAECvBOlic+V+RYL+ddldxcyz9GCm9MeC/As8zvkYH1KWKdFsL6cXlTwBMRrM4/VrvS5Z54/xweQf310pPfccpLCMdzemgbp1H3GPey28SPC2dHkeoUUzkhy6ICj+ZlnOFtBiAGwVeXJ76XrruVsybD+HWpRcO0ATZrhvxirzn1Gqdwx2IO1ewnm105SEksYoPVEHmJt1AA2K3EoeqVlpA1VttlUHEJkNTeHfy/QcnPjOggcOm1YFjLp6bX1S2mcHLBXx2AZFoo8YJ3F6oopo
 I6ljz6cw
 SQieSTa7PY1uerS8dQmkaWMR7e5IQ0spBzPHD8ykN58sNPXxWq+TUp7gk4Xsud9z9MHY+drQxK9KxD5gr8MO2B+l+LBHOSbnlaS62vau9EB9g+AJ5hjKFI9GhDvlc2+GAkEjcp+KrUiW1pLfQ1uFaQrkCCSqwcSRdIGjVAxbk68WojAJtFHclL76+ebcnLSMo+6rItAR3ooDmdo8Cg17EXrKdA0mMYn+ZyBUva8bEqPOtdftCoF78abU+uacEOgvTB9cllxbw/dJAcyqqfbZ24txI7RHI3MpS7GOiKxXbuQZ+/krs7L0htfx6jQk6uPHwCGErWi2OGcLRVkH/f2KHcw/b/Ie8y1X9H1p1EIyLXgxYciQ2g7spCu49FXmnUqobcxwSVPk2AizC48MJWyBz74e9UePo8NJ9KaT79rIWVPAYn7050c1mwoH3GzFzlCxnrUenTu48gMKzaZvIB5pV/3QUX4h/wqfoz5i7tiFrsuSdfLgzzpcR/qG/oYkM+ZBlVLcyYy0V5AkiRsr8+8rZbntKaFMq48jmZBwdAkSg3cLb+gqgVtpeeM4xYc0fLNHhyFRFMbV1HJJotCxIshW5dEKX+VEgd4LUZP63ClHXTZ9dvpI2PLYxiDCqcFOAlrE/vyzwhPmmEpu2V2T+DGOAq2HS7ifVyBpxKRsVgEM1qAwTnoE0zjOCFU1Inw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

kho_init() fails if kho_debugfs_init() or kho_out_debugfs_init() can't
create their debugfs entries, and a failed kho_init() turns KHO off.
That made sense while KHO could only be finalised through debugfs, but
commit 03d3963464a4 ("kho: make debugfs interface optional") made the
debugfs interface optional, and these days KHO doesn't need any of its
files to work.

This is a problem because debugfs can be disabled at boot with
debugfs=off, or by default with CONFIG_DEBUG_FS_ALLOW_NONE, in which
case every attempt to create a debugfs entry returns -EPERM. Given that
CONFIG_KEXEC_HANDOVER_DEBUGFS defaults to y when KHO is built in, KHO
and LUO can't be used at all on such a kernel. With kho=on liveupdate=on
debugfs=off, /dev/liveupdate never appears and a kexec hands nothing
over. kho_init() doesn't log why, so the only sign of it is the
WARN_ON_ONCE() that LUO then trips in kho_radix_add_key().

So, let's carry on without the debugfs entries when they can't be
created, as kho_in_debugfs_init() already does for the incoming FDT.

Two things then run without KHO's debugfs directories for the first
time. kho_debugfs_blob_add() would fail and trip the WARN_ON_ONCE() in
its callers, so let's make it do nothing when it has no directory to add
the blob to. kho_in_debugfs_init() would log an error on every KHO boot,
so let's make it return early when the kho directory doesn't exist.

With this applied, test_kho and luo_kexec_simple both get their state
back across a KHO kexec between two kernels booted with debugfs=off.

Fixes: 03d3963464a4 ("kho: make debugfs interface optional")
Signed-off-by: Chris Down <chris@chrisdown.name>
---
 kernel/liveupdate/kexec_handover.c          |  9 ++-------
 kernel/liveupdate/kexec_handover_debugfs.c  | 19 +++++++++++--------
 kernel/liveupdate/kexec_handover_internal.h |  8 ++++----
 3 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 663dd22e7172..4cee37ad9426 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1847,13 +1847,8 @@ static __init int kho_init(void)
 		goto err_free_kho_radix_tree;
 	}
 
-	err = kho_debugfs_init();
-	if (err)
-		goto err_free_fdt;
-
-	err = kho_out_debugfs_init(&kho_out.dbg);
-	if (err)
-		goto err_free_fdt;
+	kho_debugfs_init();
+	kho_out_debugfs_init(&kho_out.dbg);
 
 	err = kho_out_fdt_setup();
 	if (err)
diff --git a/kernel/liveupdate/kexec_handover_debugfs.c b/kernel/liveupdate/kexec_handover_debugfs.c
index 3a91c47ad7a6..cedfc955391a 100644
--- a/kernel/liveupdate/kexec_handover_debugfs.c
+++ b/kernel/liveupdate/kexec_handover_debugfs.c
@@ -59,6 +59,10 @@ int kho_debugfs_blob_add(struct kho_debugfs *dbg, const char *name,
 	else
 		dir = dbg->sub_fdt_dir;
 
+	/* The directories are NULL if they could not be created. */
+	if (!dir)
+		return 0;
+
 	return __kho_debugfs_blob_add(&dbg->fdt_list, dir, name, blob, size);
 }
 
@@ -101,6 +105,9 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 
 	INIT_LIST_HEAD(&dbg->fdt_list);
 
+	if (IS_ERR(debugfs_root))
+		return;
+
 	dir = debugfs_create_dir("in", debugfs_root);
 	if (IS_ERR(dir)) {
 		err = PTR_ERR(dir);
@@ -129,7 +136,7 @@ err_out:
 	}
 }
 
-__init int kho_out_debugfs_init(struct kho_debugfs *dbg)
+__init void kho_out_debugfs_init(struct kho_debugfs *dbg)
 {
 	struct dentry *dir, *f, *sub_fdt_dir;
 
@@ -137,7 +144,7 @@ __init int kho_out_debugfs_init(struct kho_debugfs *dbg)
 
 	dir = debugfs_create_dir("out", debugfs_root);
 	if (IS_ERR(dir))
-		return -ENOMEM;
+		return;
 
 	sub_fdt_dir = debugfs_create_dir("sub_fdts", dir);
 	if (IS_ERR(sub_fdt_dir))
@@ -155,17 +162,13 @@ __init int kho_out_debugfs_init(struct kho_debugfs *dbg)
 
 	dbg->dir = dir;
 	dbg->sub_fdt_dir = sub_fdt_dir;
-	return 0;
+	return;
 
 err_rmdir:
 	debugfs_remove_recursive(dir);
-	return -ENOENT;
 }
 
-__init int kho_debugfs_init(void)
+__init void kho_debugfs_init(void)
 {
 	debugfs_root = debugfs_create_dir("kho", NULL);
-	if (IS_ERR(debugfs_root))
-		return -ENOENT;
-	return 0;
 }
diff --git a/kernel/liveupdate/kexec_handover_internal.h b/kernel/liveupdate/kexec_handover_internal.h
index e9685e1ef6d7..424467a98da2 100644
--- a/kernel/liveupdate/kexec_handover_internal.h
+++ b/kernel/liveupdate/kexec_handover_internal.h
@@ -23,17 +23,17 @@ extern struct kho_bootmem *kho_bootmem;
 extern unsigned int kho_bootmem_cnt;
 
 #ifdef CONFIG_KEXEC_HANDOVER_DEBUGFS
-int kho_debugfs_init(void);
+void kho_debugfs_init(void);
 void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt);
-int kho_out_debugfs_init(struct kho_debugfs *dbg);
+void kho_out_debugfs_init(struct kho_debugfs *dbg);
 int kho_debugfs_blob_add(struct kho_debugfs *dbg, const char *name,
 			 const void *blob, size_t size, bool root);
 void kho_debugfs_blob_remove(struct kho_debugfs *dbg, void *blob);
 #else
-static inline int kho_debugfs_init(void) { return 0; }
+static inline void kho_debugfs_init(void) { }
 static inline void kho_in_debugfs_init(struct kho_debugfs *dbg,
 				       const void *fdt) { }
-static inline int kho_out_debugfs_init(struct kho_debugfs *dbg) { return 0; }
+static inline void kho_out_debugfs_init(struct kho_debugfs *dbg) { }
 static inline int kho_debugfs_blob_add(struct kho_debugfs *dbg,
 				       const char *name, const void *blob,
 				       size_t size, bool root) { return 0; }
-- 
2.56.1


