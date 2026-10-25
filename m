Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABC94606A328
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 17:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=F2ZVb/3C
Received: by kanga.kvack.org (Postfix)
	id 792CE6B05B2; Sun, 25 Oct 2026 13:40:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71CD86B05B3; Sun, 25 Oct 2026 13:40:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 596A26B05B4; Sun, 25 Oct 2026 13:40:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2284C6B05B2
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 13:40:25 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9993E805D6
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 17:40:23 +0000 (UTC)
X-FDA: 85361862726.13.B4B75BC
Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	by imf08.hostedemail.com (Postfix) with ESMTP id D2128160008
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 17:40:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="F2ZVb/3C";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792950021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nlyb5eFqjPdmH1nFRtnItgVGTITVkyurMpQB27D3UKE=;
	b=aE1GmsRau5KH1vMdTIINCAL5P8vWISyT5uhKf0oAPOfQZROD51ba58osmSzGT81fEHd3VB
	HgHmrA/4ECDeGv8acIXj9s6js4E81Q59+vSpQSHuKiyr2jw+aY1R1bSWX32/G+CXkQifvW
	E0JCdFJJEY4dTeGh0bHiWy5Jym8s5Ws=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="F2ZVb/3C";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792950021;
	b=KW/k6alnhlCYtQ2ynPSVVIt/+niId3fPGJYyX6YhKxUd+3sTzJUoq/jtL8XP8QcLBM72F0
	xkNv4VVvOPvTw8UXrFy/qGdXiJeznUT17YujKiv+U3uZoc8GQ51oM0CsvWKRXoYuOJkW/P
	KNWxvhMaHA0gPFzPWsBRL1IFraQEslo=
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-5ead4026fe6so912888e0c.2
        for <linux-mm@kvack.org>; Sun, 25 Oct 2026 10:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792950021; x=1793554821; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=nlyb5eFqjPdmH1nFRtnItgVGTITVkyurMpQB27D3UKE=;
        b=F2ZVb/3CX1R5T1A9Qom68jExU8WtlgQwTEOkhin63V6OVU62TFzeiLBBgDUr7XAANh
         vMzURbrc+cjCyG5j3/eJijJnF33PFrOGmGLijCLnKM+zg+z8dPRd234uMYmSM/+4x0J2
         Y0ZvH7wwYtWxWlrvaPdl9XabrAijIe27Hiq4kVXHYzywa447ZhnH452IIIQZ7VeFMSHc
         sFSplqyhP/bb+4jOFIxhh1DWwHf2e9YRQuA1Iy6Drg6lfAm8muoPxBlKjtUZI8HWguNz
         TuOxN+fsvoSOktu/Lu0Bw1u4j0WftkgSGooKrNCjUpaGtPaUGZieNnrvwJV/4dGAgxXa
         AYtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792950021; x=1793554821;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=nlyb5eFqjPdmH1nFRtnItgVGTITVkyurMpQB27D3UKE=;
        b=Q/FvlnQaya64fJqU8vT16S2EHHV9qQFWSDQa+Bsf7/AIdv+AzfcFyRWdHGDzi+C8LV
         DlLSTxLes/6LLOQsFX+4OUWhMC3X+QTWod/QbQrDYbWQmm+QRU514j/h3kstCHuzIXjW
         jwEClBJFaPAhNMXOJgQXKTLmHPUWJeMcQuor4Ylom0TjNzf+8he/4MCiOw81iP44y/CK
         PaEwq5vv79x4bSP2qDRYKjvWzoDEtC5DXETxXDp//KtWhru/oeKUpROJ0XNYAFzGCKlv
         F5/unk69A813KbwKNJblRPoVtocOwLDlzLu8NbiaTdx561AhY+XNv2ehSu4d8kWZjEwz
         puwQ==
X-Forwarded-Encrypted: i=1; AKwUvBzexbSFK3+1icMX376c/EsCxb9+PE6L6oRWcdMQVi8+zw1Hp6JPWohoEIGdhX1iKlxQYQDAGPWMkw==@kvack.org
X-Gm-Message-State: AFq9FYJYXj8EfbesAntfHJwGFCGpAIqmUWJE5TbhdWYFzz6yZU1phSbT
	x7gl2fS0oCOdZTrK4nYpHU4qzI1HK0ZB56QHDr7jq63S24uICyH5dqIykQh9bnGqALo=
X-Gm-Gg: AYBFou0EK3T6HVmyy/D6LED+Hm6XuUo9sOIyjNmP55FE0DqkW/0svwiIvoGG0EsxV7e
	Ony7IXPOg/zKjg3babF8BUA+iAiDmHFf06cf4S6TowBTLRWDkF1fdF3zsPXal4QAGW9+nSr+NuG
	unpCObqD+ZWnytj+GmVUbpTboi0xqwOQMGO+rs00W4bw+y2XNTnYKRB7vYGraC6bll/NX0HiTEz
	i0SzpYiePHk+JZ5SmJdI+jwpr4rRl/CVvC/6wamEOoyoq8hEPSrwDbleU3NdvatCSdVG8pF/2O0
	xib9p93mJkoHJIdaDWxGS01CDgSuCU3rVOA43EeTm2yJQcCiklUrSSp0iVy+hyLZfIP/diMsb7f
	rGj+FtQwlcouTDkHGx8jEDqMrsi6ObfdypJJ7j6HORfG4K4pAcCrJfYWubIdWaufhcIq/cxZ3Zt
	Xhuqq7BkJjIMbA4q+dg/fCQclFTVUDKpIfuy4Os/IFDtwklmD1hZKR6oB1kCGEuMcE5wGZ7xqQr
	qX3sP/FgmV7iHtH7FQLNagVzwkib2m6DIUuF1wwOVEsH8opIUVFiiSujnCSHNoZd5YaeXP5vhVh
	c5TdWuuBvS4jMaj80f1gsQrvngSxViYbYTJ+EK5kMr1DWaHnALRYEuP31OITFBhdWLu9qnmXf/E
	/
X-Received: by 2002:a05:6122:1829:b0:5ea:d649:d1bc with SMTP id 71dfb90a1353d-5ec232b5465mr1591325e0c.18.1792950021033;
        Sun, 25 Oct 2026 10:40:21 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ec234673ebsm5783333e0c.13.2026.10.25.10.40.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 10:40:20 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	kuba@kernel.org,
	enelsonmoore@gmail.com,
	bp@alien8.de,
	shuah@kernel.org,
	david@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	vbabka@kernel.org,
	dapeng1.mi@linux.intel.com,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	surenb@google.com,
	pasha.tatashin@soleen.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	elver@google.com,
	graf@amazon.com,
	lirongqing@baidu.com,
	liam@infradead.org,
	jlayton@kernel.org
Subject: [PATCH v2 1/9] kho: expose physical address of outgoing FDT
Date: Sun, 25 Oct 2026 13:40:08 -0400
Message-ID: <20261025174017.3870481-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
In-Reply-To: <20261025174017.3870481-1-pasha.tatashin@soleen.com>
References: <20261025174017.3870481-1-pasha.tatashin@soleen.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D2128160008
X-Rspam-User: 
X-Stat-Signature: a395ptsmmbkmn6c9i75r4psget9ghtf5
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792950021-614718
X-HE-Meta: U2FsdGVkX1/US3JepsegbzNcZQWf3FlmmtFniqxxV7jH5rDZHmI8U1ePFovgNjlb0C46PHFovcSiPF/UXuZOyW8xtFYL0tucgiKmzS23Y8+FCKB4UwyEgQFnqRGbWzabGEpUD42M70n0kmRKPM5DzLz9xhQeyc+BUo+ihl3h6gmyRfqbr+W7y2euBV5cLmcWcEJezgyE05ozsOvjLTXBfJpYCRm81I3QPAEiXjj3yylcydmlGkFVrkUp27o7ZsFerb7yjVQP/BkU3EQCMMjpHGNzqK3m64NMght5bDs43b52lI3G+3fblbt5A7jrVd+PNSAeDsjAp9gCw+4c/sKNjtn6Q20hz4/KR1r2iQD74AyzzM/OGYSfxwmaYl88S03VaeoeOmm4bJZUjwYBsZ60Fl9Bnd/PI3WDcK/W71tZ0cLr3PMghyE70juuUeyihOojQIpf7pR92eX5CwmPXarjLd7qVdFYKvL8opdPc8IuDgAcs8zgceS9uHYNJvIZM18yF9Ro5izPPhes8XRvC6qSPZm8wWvzknsggyKdDVo/3+M+SEIdMthkJmIkaUNWmWTeiz+Ti6jrvruVoMeaks4exn0GNrMiqjT1ZTOpSmTj0TC0caeFsJod6WPLoppSUVqvWHlnDIn5RfMqEMyJkkcWmWkYOl9MZOp7r1jCIzwCkOf2Am4R60DwtH3xh12QAHxB3uN4zqwLIpnNiWoLXHb0pndVw9yfei/NoJZhvkNJFvy89tzJu9PjBzZwZW7Y7Sz4nB9Hq0w3PhaOuV2SlSYxU6b+AmGHuMgjjvtSbUt6k66ID5BCipSEuD35XVHYdX575wx7DApihEJoZKCCWAmv0tiOw/TNkY6/XbLnLG5a5m4ol93+0yYDeIcB4QAYCOVPV84Gy0bZztonyva0Xw6XY6nkZ3uF6mFpvxmw/ZMTWjFa8kYCUtB9+QFip52OKHpuY5RMb7f/sdqnJqIZwKj
 lgKLv99H
 nLZI6Q38X1/mFjXuZafj093amzdh/+QjUE7UzJdJ4lW1h8ZVYE7Eemde03J5fwdt3+sWwqR5A4A4UQ6gv8Rsa/7+JzcxUOQWMSuipxWS0fr2nJbPwd6inVlYykFx3WHOy674c61NcYwZwbaGVVmbVPZMbF8bG4vBMo4pfA5njfa1+RpKdedghfZSPgxRoGpJ0OO0Mmu9h2HignwKnpOncu7BbUeozA3V4u4R5+5mNrSrguMfOqDobc2lusIw9+mRhrxfSGHySU6oRE2nafEoOVBznrHC50FrR7Qx124mkI+1KyELz/I+/4x+lqReHb2bZAUDPcOU6msBtMaQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Expose the physical address of the outgoing KHO FDT via
/sys/kernel/debug/kho/out/fdt_phys (analogous to bootmem_phys) so
that userspace tooling can locate the root KHO FDT in physical memory.

Also add kho_debugfs_cleanup() and remove the KHO debugfs directory
if kho_init() fails after initializing debugfs, ensuring fdt_phys
does not retain a dangling pointer to a freed FDT.

This is going to be used by the upcoming KHO read-only mode.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 Documentation/admin-guide/mm/kho.rst        |  3 +++
 kernel/liveupdate/kexec_handover.c          | 10 ++++++----
 kernel/liveupdate/kexec_handover_debugfs.c  | 22 ++++++++++++++++++++-
 kernel/liveupdate/kexec_handover_internal.h |  7 +++++--
 4 files changed, 35 insertions(+), 7 deletions(-)

diff --git a/Documentation/admin-guide/mm/kho.rst b/Documentation/admin-guide/mm/kho.rst
index 902d171a780a..2ba884c620c5 100644
--- a/Documentation/admin-guide/mm/kho.rst
+++ b/Documentation/admin-guide/mm/kho.rst
@@ -96,6 +96,9 @@ stabilized.
     current KHO state in this file. Kexec user space tooling can use this
     as input file for the KHO payload image.
 
+``/sys/kernel/debug/kho/out/fdt_phys``
+    Physical address of the outgoing KHO FDT blob.
+
 ``/sys/kernel/debug/kho/out/bootmem_len``
     Lengths of KHO bootmem regions, which are physically contiguous
     memory regions that will always stay available for future kexec
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 6f1f55fe3181..ce5983abf181 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1851,17 +1851,17 @@ static __init int kho_init(void)
 	if (err)
 		goto err_free_fdt;
 
-	err = kho_out_debugfs_init(&kho_out.dbg);
+	err = kho_out_debugfs_init(&kho_out.dbg, kho_out.fdt);
 	if (err)
-		goto err_free_fdt;
+		goto err_cleanup_debugfs;
 
 	err = kho_out_fdt_setup();
 	if (err)
-		goto err_free_fdt;
+		goto err_cleanup_debugfs;
 
 	err = kho_kexec_metadata_init(fdt);
 	if (err)
-		goto err_free_fdt;
+		goto err_cleanup_debugfs;
 
 	if (fdt) {
 		kho_in_debugfs_init(&kho_in.dbg, fdt);
@@ -1893,6 +1893,8 @@ static __init int kho_init(void)
 
 	return 0;
 
+err_cleanup_debugfs:
+	kho_debugfs_cleanup();
 err_free_fdt:
 	kho_unpreserve_free(kho_out.fdt);
 err_free_kho_radix_tree:
diff --git a/kernel/liveupdate/kexec_handover_debugfs.c b/kernel/liveupdate/kexec_handover_debugfs.c
index 7d74477da0b7..db3830829398 100644
--- a/kernel/liveupdate/kexec_handover_debugfs.c
+++ b/kernel/liveupdate/kexec_handover_debugfs.c
@@ -95,6 +95,15 @@ static int bootmem_len_show(struct seq_file *m, void *v)
 }
 DEFINE_SHOW_ATTRIBUTE(bootmem_len);
 
+static int fdt_phys_show(struct seq_file *m, void *v)
+{
+	void *fdt = m->private;
+
+	seq_printf(m, "0x%llx\n", (unsigned long long)virt_to_phys(fdt));
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(fdt_phys);
+
 __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 {
 	struct dentry *dir, *sub_fdt_dir;
@@ -172,7 +181,7 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 	}
 }
 
-__init int kho_out_debugfs_init(struct kho_debugfs *dbg)
+__init int kho_out_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 {
 	struct dentry *dir, *f, *sub_fdt_dir;
 
@@ -196,6 +205,11 @@ __init int kho_out_debugfs_init(struct kho_debugfs *dbg)
 	if (IS_ERR(f))
 		goto err_rmdir;
 
+	f = debugfs_create_file("fdt_phys", 0400, dir, (void *)fdt,
+				&fdt_phys_fops);
+	if (IS_ERR(f))
+		goto err_rmdir;
+
 	dbg->dir = dir;
 	dbg->sub_fdt_dir = sub_fdt_dir;
 	return 0;
@@ -212,3 +226,9 @@ __init int kho_debugfs_init(void)
 		return -ENOENT;
 	return 0;
 }
+
+__init void kho_debugfs_cleanup(void)
+{
+	debugfs_remove_recursive(debugfs_root);
+	debugfs_root = NULL;
+}
diff --git a/kernel/liveupdate/kexec_handover_internal.h b/kernel/liveupdate/kexec_handover_internal.h
index e9685e1ef6d7..38181076f603 100644
--- a/kernel/liveupdate/kexec_handover_internal.h
+++ b/kernel/liveupdate/kexec_handover_internal.h
@@ -24,16 +24,19 @@ extern unsigned int kho_bootmem_cnt;
 
 #ifdef CONFIG_KEXEC_HANDOVER_DEBUGFS
 int kho_debugfs_init(void);
+void kho_debugfs_cleanup(void);
 void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt);
-int kho_out_debugfs_init(struct kho_debugfs *dbg);
+int kho_out_debugfs_init(struct kho_debugfs *dbg, const void *fdt);
 int kho_debugfs_blob_add(struct kho_debugfs *dbg, const char *name,
 			 const void *blob, size_t size, bool root);
 void kho_debugfs_blob_remove(struct kho_debugfs *dbg, void *blob);
 #else
 static inline int kho_debugfs_init(void) { return 0; }
+static inline void kho_debugfs_cleanup(void) { }
 static inline void kho_in_debugfs_init(struct kho_debugfs *dbg,
 				       const void *fdt) { }
-static inline int kho_out_debugfs_init(struct kho_debugfs *dbg) { return 0; }
+static inline int kho_out_debugfs_init(struct kho_debugfs *dbg,
+				       const void *fdt) { return 0; }
 static inline int kho_debugfs_blob_add(struct kho_debugfs *dbg,
 				       const char *name, const void *blob,
 				       size_t size, bool root) { return 0; }
-- 
2.56.0.307.g5fe7bd680c-goog


