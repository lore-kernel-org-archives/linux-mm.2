Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27CEED0EE0D
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 16:59:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFED36B007B; Tue, 25 Nov 2025 11:59:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEBA56B0089; Tue, 25 Nov 2025 11:59:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8C7F6B008A; Tue, 25 Nov 2025 11:59:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8FD3D6B007B
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 11:59:33 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 58A8D88A9D
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:59:33 +0000 (UTC)
X-FDA: 84149740626.29.A8CB3C2
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7A69020005
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:59:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jv4vhu8z;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764089971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VfwgkEKDg4HJju8ezcZR8QklgFqMiwexlZP+Lehn03I=;
	b=d5pRb+br6JIRZ3uGGjRLtJivsHDDN1eH78rzuxT0VzYL+REHL7TClc0K0UNxVKyjRkjXzA
	/ASmmpDeHnFZBmnTit3GVKeZtPpIF4rSQ2mzkUJ9BZfG4HN3N+LUXPxmCncVbRcoVn46NZ
	VaQYKHd0JVip9NFFzgIgntjLRq0PtZ8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jv4vhu8z;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764089971; a=rsa-sha256;
	cv=none;
	b=SmJGQpVT7pEj2AAPIx6ZBDuI1kR48oQAyIFs3QaQPcXC8WRLSgWpshO4c3roxiU3CYz0wa
	usNuq2MHL4gSAsa9TAOi4VNTrcwEPu6iR0Wohicx/M90rK9OU9pKL4mMjbC+WUAk69KA8H
	Y9q1XJHef9mPrXL/hpm3mghzAcAsupM=
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-640d790d444so4987774d50.0
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:59:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764089970; x=1764694770; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VfwgkEKDg4HJju8ezcZR8QklgFqMiwexlZP+Lehn03I=;
        b=jv4vhu8z6bmdM5I/sijJTj9/SdFsDb9pmgZrhXpPSeATz4hhmN2MPCOcph/twCbsWR
         ZQg9PGDq++chMCnzPHlgCeR5tMshIUsxcxu2H/4dw+Lzpfoolfosq+wnfvaPzPFe6oCW
         w/4ZKnRcEBrCk56lvR4RhgMaWArTcyfuzsA8xBXqgHwo/NkGPdVlEQ8ZGWFMCjRi2uSW
         9Xht2yeEfDjXRwEaxcQB0oS3MGPLe4iKh52v9JmdsraoJgcBLV23xe+ALi3F05k7iu9c
         c5nVqbrK+ild8A853G9EXqCBhU0hjxn3f7cg2V15ZcAAlXvjdov2oFsIpMTXNT/DTFt/
         FGrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764089970; x=1764694770;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VfwgkEKDg4HJju8ezcZR8QklgFqMiwexlZP+Lehn03I=;
        b=iCFzIsrBaO3FZ8Gx8wGm9D/OJfBjIJGKBg3DgvjAd8PQ4L+ASJHyGrtYNjki5HmuDF
         svlNKT9HeRVs2eeFZzJqV3Dlc4do+EDgHy2f49xnWPUHWZLdhnQymZ85x/h3BISQgxc+
         2T/Yfj/GUIUL0UVlOBDX6TMBY2umOyY1oQB/qahcRMb50jNeHdDhsrw4udr+Xw3nKYRI
         M+rzHpncDQenjLmn1R0HAoILMMZf/UW3+QrK6jPzjY3AdJkUSiKI5C0xZ/KmZQ+hyil/
         EjvsGfTfYNpjmGVvJDNnukAWYujEtGOmQ33wU44tkS9G2u4XGPBD3nI2/m0cq2U6+50+
         T0Qg==
X-Forwarded-Encrypted: i=1; AJvYcCW+a64CsRxEVQzL0yyAC3YcQtJVXH8RI1YStPskuoXsUjk8D3Vutdn7wKBI69mY57cGmgy33LTnDQ==@kvack.org
X-Gm-Message-State: AOJu0YypeQ911NyYsBSA46QYsDTxf67+HX9HmsUpkm+f3X3DK4wHhgr9
	E+qVpj2enIfJGj+Exr93da11fGo0DpDPghVxBCfoCGGsYCeUcOtAjLWk7EaT/ZmCk4A=
X-Gm-Gg: ASbGncvwZ4GrpxtFvtkb2WalH+cuLo8wzMvIrqShh8zvtO98FvCZUHU46V+4JvMfJad
	P7+HTz34Rw+3SdpFwToN1lzn/OQKCYUnKtSGiYYoy0KNnVnnE+28WHT8vmJwf78WhQ2YIONPv36
	oFh3J+cGnLtRGcnny6+PWJLVRuFAiHpkfp2uTNDAj4lClQ0Qk/Dit5NHyppLd3JdPvaZ7yp/frF
	BqK0EmITAhDq52fQdvkFNoxpAJYYNOXoWkTy1pfBHCjhM5gdPv3i/t8emhyvGDXE4Q/HjDp0x5Y
	MtB5bCUfdLPVp6nhaIj8emNRY7LpvcoLr1NmvgxYFxnTEplXBKz8wjq/F7yjwYHhhm4/iY156t6
	vOTSpy+sq45CmePv7W0MmVitm1Nplpe7f/ncKuwM8Pgwg6idZNeUou+4drIRm4sJrhehU657BSh
	ptmpnyy7+Mv6unL7C+br+hYcfRcar7pWPmycYLpO12DtRUmHtJRXVIO3/xeu7SAS8/Gnz3Y2+Ki
	iXKu2M=
X-Google-Smtp-Source: AGHT+IHxFSNIvKptfLX2O2s6I7Ya1I+lmAyOHmAnZEOWuFdMycjzG+KGE1lNfFdZGkk9BfTpPXWC4g==
X-Received: by 2002:a53:d048:0:20b0:63f:beb2:950f with SMTP id 956f58d0204a3-64302a5d4c6mr9409405d50.34.1764089970594;
        Tue, 25 Nov 2025 08:59:30 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a798a5518sm57284357b3.14.2025.11.25.08.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 08:59:30 -0800 (PST)
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
Subject: [PATCH v8 12/18] mm: shmem: export some functions to internal.h
Date: Tue, 25 Nov 2025 11:58:42 -0500
Message-ID: <20251125165850.3389713-13-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.460.gd25c4c69ec-goog
In-Reply-To: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
References: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7A69020005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 1ofy46mj9psf54burmnoc6c6rcjuofp3
X-HE-Tag: 1764089971-878171
X-HE-Meta: U2FsdGVkX1/S+YEwC0I7s9yQtBW82J8nI1DVDR5YHSvbskcCgjP4/evgnAX2by2h+BhPgdbAxeqUX2bqkgSEvUvBQHG0GJC9RkLR+oT0CnePLbyV8PIhgi4VRmNTKi/755CKMPRUiup7JOMqCzKX9lxSAx9Abz92BAwMgvBwwUPo3KZhNojucfG5pkxnk980DUf6np8Kycw4oTjotNpKX8dkscna07qJkMo9I4VIOu/C1DPwr7aQbN/7jniHXaI2+R9V6jMS4Sd2/+Ioaqnylxuy8u4H/PbauNh8b0IgNuDJbyVYt82F2dz7y33z5GQVmZ5A0vtsgiLef1dgJmRfuLmE5j/jWphp3SMjRS6QOy9aimAqoFJSneL8maeOdvs1is9pU/IN4v1ai9zFv4wloneygeuh1KI6UZ9CmrGZPsLNxvhFXbPvMmF5SANmJ3LR733Vlpxy2HKbxGII5P+QR8+wk3q4RDCZO1XjGlouIz9HqLxWrWw6DjjHtku3W5qcaBxGgCKF9yFRV/XypZtEdNPlXaokZL0FulNxa8jUda4u5nAGqgnNH33iaoIlu/+je3JYs8EW+glNnCc5kOBdftDYrJdm0IMLp4KY7mFfPLapW08wJP8JZG4cCaA9+bImCjJ5SO2PXL0fdJs5gbHm0gR3MLSjGLly+K674H2FXUR03AJ4Iyt4jRlxsIerqpSzqrD1aDVG6pTZINdmiPR+s8fQP7kwZiBVP7/TxoBZwdiqSmWBavqUgxr6U6iz27LYjXlsOurAwmo1dA0xYrY4DKQsoy18/vYl/Bw+KiWw1zHD/tP7ZfyypuZLp0KFORf/rb54kh5kq1KMfO2j66Wpae04yr3imYRdtOvSHFDxiDQU4j6MZ7EJC9++DpfPRMQn0GWqsNy4ltd7FEBIiWflZYMTmURq0c4SEIOkaCatZxjpcEcqB2TCMlCiGeyaXTBKY7MGBMzeery1hWHcJTw
 0dt2rJyz
 /NYEqQEfG3ooayW6GKnPo3rFwJZc18LVBEIRhK0ltJYL4innfJdMvclIQBKhTuSanJvwaiYR27e+Sz5e1UMvHqIQnyRed8df7c7lFVnGPMm52nh04+aawKkM10b4xxFmkAc2p+9GMlhHYGs/IvhwPFqI3via7gFzRNBRSwe2tt50xb8dAsIhPZeUDgjidI3VTQzodes9wsbVs2BVje5qtMrMU/KDcfv2UfYPE05BHRIQhIKY9K+zA2XRdfl2jn2cqFXesbO7tOW+BwTIL6wWfOxm8XFxXd0RQrA8p+/JdzWmsW4du7p2auYi8drJjLDl17GlFJmaAPRiZ49uhG1MMaLFS6sDh3MeUvV4YN3Y7Goh3moRlDVBzt1UZk7G7So+STJZCc0qfOCDV7JGXwiZKUglcWNOaAianhWzoRXuRxSC8kKXb5VmxyXSUvT1JmK/NTG6QYI7BA8bUJAI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pratyush Yadav <ptyadav@amazon.de>

shmem_inode_acct_blocks(), shmem_recalc_inode(), and
shmem_add_to_page_cache() are used by shmem_alloc_and_add_folio(). This
functionality will be used by memfd LUO integration.

Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/internal.h |  6 ++++++
 mm/shmem.c    | 10 +++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 1561fc2ff5b8..4ba155524f80 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1562,6 +1562,12 @@ void __meminit __init_page_from_nid(unsigned long pfn, int nid);
 unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
 			  int priority);
 
+int shmem_add_to_page_cache(struct folio *folio,
+			    struct address_space *mapping,
+			    pgoff_t index, void *expected, gfp_t gfp);
+int shmem_inode_acct_blocks(struct inode *inode, long pages);
+bool shmem_recalc_inode(struct inode *inode, long alloced, long swapped);
+
 #ifdef CONFIG_SHRINKER_DEBUG
 static inline __printf(2, 0) int shrinker_debugfs_name_alloc(
 			struct shrinker *shrinker, const char *fmt, va_list ap)
diff --git a/mm/shmem.c b/mm/shmem.c
index 786573479360..679721e48a87 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -219,7 +219,7 @@ static inline void shmem_unacct_blocks(unsigned long flags, long pages)
 		vm_unacct_memory(pages * VM_ACCT(PAGE_SIZE));
 }
 
-static int shmem_inode_acct_blocks(struct inode *inode, long pages)
+int shmem_inode_acct_blocks(struct inode *inode, long pages)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
@@ -435,7 +435,7 @@ static void shmem_free_inode(struct super_block *sb, size_t freed_ispace)
  *
  * Return: true if swapped was incremented from 0, for shmem_writeout().
  */
-static bool shmem_recalc_inode(struct inode *inode, long alloced, long swapped)
+bool shmem_recalc_inode(struct inode *inode, long alloced, long swapped)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	bool first_swapped = false;
@@ -861,9 +861,9 @@ static void shmem_update_stats(struct folio *folio, int nr_pages)
 /*
  * Somewhat like filemap_add_folio, but error if expected item has gone.
  */
-static int shmem_add_to_page_cache(struct folio *folio,
-				   struct address_space *mapping,
-				   pgoff_t index, void *expected, gfp_t gfp)
+int shmem_add_to_page_cache(struct folio *folio,
+			    struct address_space *mapping,
+			    pgoff_t index, void *expected, gfp_t gfp)
 {
 	XA_STATE_ORDER(xas, &mapping->i_pages, index, folio_order(folio));
 	unsigned long nr = folio_nr_pages(folio);
-- 
2.52.0.460.gd25c4c69ec-goog


