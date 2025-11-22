Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B413CFD312
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 22:24:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3D2E6B008A; Sat, 22 Nov 2025 17:24:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DED586B008C; Sat, 22 Nov 2025 17:24:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C401F6B0092; Sat, 22 Nov 2025 17:24:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AD6F16B008A
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 17:24:23 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7DC464F4F9
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:24:23 +0000 (UTC)
X-FDA: 84139672806.12.9D6AE67
Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	by imf18.hostedemail.com (Postfix) with ESMTP id AB4A11C0012
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:24:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=dKhTfDib;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763850261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3+3x59DbFWdBPdmdih5ENuDC3ZjNMKrWdUeGoJeNo7E=;
	b=TJvNJGH/gU/Hz2zmfvI3KG8P1veKbNbBtrWhE3fdZn4kTjSL3yBpY6kUZlkbdGNlce+K8y
	Sr9FFM12CnnTj3RSeNaIecueE8h3ePP1ws1FOoQ9xiVUYaGrtVMrbW1b1gKyrPCY3so+ya
	PyguDFBymJXNQmLhHbKLxzzsDtrUUrc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=dKhTfDib;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763850261; a=rsa-sha256;
	cv=none;
	b=Xr1avPNsS2whOrLXKuoAvqlDBH38n8zb4OkCq1O/VDwq8VGYLsgUYlrRKK94WcONS0GnHZ
	K0btf1JLOygmOOHteHBw/6zYlfiE2sSk6RcijH9oZQhKi2HibXfwbFhfG4J/Ul8HZPloj1
	rLck5+yFlV9GWjJasTNOge4mDr9fcVc=
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-64308342458so806376d50.0
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 14:24:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763850261; x=1764455061; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3+3x59DbFWdBPdmdih5ENuDC3ZjNMKrWdUeGoJeNo7E=;
        b=dKhTfDibLNYAIpYIJwMm9GgJ1tS2kQkI0d+TYryYzY47tCzVrtveW+/fXH7hZRH0+s
         rWhuLFeSL0UAaS4EjIjCmAVr5hZc0lWuQ6cVAC6nPA0ghw/aPGMAy19Jj3pSdLxGrlx9
         1TAC+9Fu01Xx00uUhn5txo5TJ6s7xuE99OuSdovy/TfI6l/3AN0vVT1d6qNcYT/AAwLF
         bR3GZFq2eICcwx/Nda+w3qGC8yVGKfG0B+I17WUD5GekGkTuxLqUP0/BjvH4h249unGz
         AEen2e7+IrVPhrTrISNXrCQkSVz6OHZTWeeyJpSFg4Wdgivloy6So8/lzKbSpgK44Pyp
         q4dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763850261; x=1764455061;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3+3x59DbFWdBPdmdih5ENuDC3ZjNMKrWdUeGoJeNo7E=;
        b=JbPipL2ujYnc18VTZP8m9M8uy77kSjKPxoCaE2uhiUnXzKvynzD1RH/zSEKWWnSbAX
         hfMyDASWL801EegOh2cojWhhjwo/gWNQRI+LaWZf6nFOZtNmDQlRhdBh77ifzH3dQ2KO
         oOseCfwKzaqv3uzMKrJiag0m1Ioyvlj+C8Ae4dWJpIP61AQ438EiYHbsqXYJh0sPjpB4
         8wZDC3s1xZOS8KrRZhhI71SoG/UpEHopZaOAOpm7RtSYFhoz2tBxM4NmTczbOM+t2NBr
         og04FqLMVMvnPWUWMPcqshgMyW6MJfz90CrZlYebTYIEWHMU+znKmxnEvK46K6L58Chx
         gIIw==
X-Forwarded-Encrypted: i=1; AJvYcCViNNjycVcHp7IjNjPKF0ymSGxvU3wsaY1H7CLa9CnZpRCkrmXg3WJ/0qldlDDfl7p4xOseK2PkMQ==@kvack.org
X-Gm-Message-State: AOJu0YzcCgshiGWSoWiFtjF3xaCPU2x0NV7N4/nZxPTFXRPkomYK0qq/
	Fsk3kvKR6UAvybAwcHNfzSRZZ0SBrNy4qkDnxeoZXg/8IKhTY6/G6cEz6iEXOA3yaFk=
X-Gm-Gg: ASbGncuDTJYpaC9wtg9A8Y2ZkmKjBixBV5DYEBXy3m2/NWFCLY1+bF6//Xh18+KumC1
	zCoLE1W4zMTp5ekEumhR1fg+h3VjFo22kHSWVD+0VnyDyRMUwX+FGkJ5wKN0fC326hU96/kGr/c
	nnmmJe8kifMw+gJowNjIa/HY7H4m74EQ0IMVVlf0rLHxnxE+WbB59ewbElTCjP3+EGhASfosW62
	RqRaFMtx4HU6KbTbRqVrcf8RqawckAzG+6GUXU4h0914iXWZBs97TcVym9eMGrUXh/ODUKzW8dB
	5XHcKl01V/E/a49MKcsVq5ExGFhgXjHrjWkQkKqgEn+l4AMvzyePSeDjb8BYr4yz49X3KDNuC4N
	BBiXHEcxDykUBSgshNT3erH0+iBy7Q0xTcyx1miu7jn8sORQ7PAdKiJflNtGKsrQMJwwuqQAPUb
	dbKuMCFWTv7CPrD4wIkI0sDWKKLIH1VlGfcO4DIn3Z/XPTco8g7UOOS7VzFh8Apzf2mgKewW5Mm
	7l8bWg=
X-Google-Smtp-Source: AGHT+IHLBVEUSrsRTAR569f2nmbBoHdToiAZD4CXjMMgQTOgrYNyCyqBuS6WcJxB+UmOJcCfJHKxnQ==
X-Received: by 2002:a53:acd3:0:10b0:63f:55de:63cc with SMTP id 956f58d0204a3-64302ab185bmr3797706d50.31.1763850260775;
        Sat, 22 Nov 2025 14:24:20 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a79779a4esm28858937b3.0.2025.11.22.14.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 14:24:20 -0800 (PST)
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
Subject: [PATCH v7 12/22] mm: shmem: export some functions to internal.h
Date: Sat, 22 Nov 2025 17:23:39 -0500
Message-ID: <20251122222351.1059049-13-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
In-Reply-To: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AB4A11C0012
X-Stat-Signature: g5um13skme7j5b85bocjtdmdhnqipf9z
X-Rspam-User: 
X-HE-Tag: 1763850261-93068
X-HE-Meta: U2FsdGVkX19zA53hOfu+lFIGoHW0IJyACmThCVSHu08mwN9zZcTcpMrE3YWCHMBenUDUqT0OQCHb8XlPZHrtcGIecyV7cusA6cRo5duZAnIlY/RYsKRF0/Upl5PwILl1cWRjRSu0YrNrKkH5SF2D7470CWW2B9n08Q4fyZEkYsUJtEzMjF+pO+PAuutkfnqkz07I0jmq9wgy6OeMaqN4eaReW3F9fvA/0PRbLfsozIP8Xh4oDbC9mAxocmuCPEINPlLaIPiT8N+FtTGEmyFeA/3UBchxVrUUTEY8nnfLtq6Rwz3WFJLbfTVavcudSVtEUN7B0t7zsmnSkJMtmwPY33k/pRN3iG8NmgaVY/6YnmWiuciD7530uRnFdxQJu/vAXVWrW6mWyOLtROfyuRRlxDwrI69SzX9CY3MyjISh+vrNrVJhCzDh1+guAhTyzIl5BSiVAvoOTfqIpIZ2mrBcNdqYPZvEwO6yhhd66cbhtA27jpSD/+rbUPFTCAk4QX8h0g2AWGaQmfD1kplskEXSi2iADRDBNi8bcLosgKOi7S7ZiLEhWna2HGxUCDpeYRB9QEqhTiekfxl80MvQtS58MgeTFGwv4t/I2jLPL5pmWs2khpEo1oVYu9sTFVXlJ0odhtiYyB+c3k6KRTM1IATCGhmLsa+vyVP8TeAZfLJSMvNSzsD3q83DBBRDV+qrFMy1hUo4wXr683hFGMbs+N/3EXVceNn2OEefp+CT0F0uGC8CEpe7kQrsILLRPJl0ji64IlcHWQweU2FiLZxC7JLKKjuV6A+s6OGDAZgSJvsV7nPe9CbNXCvPFRvdbhZIjwZDJFURMmKrG+MFwaAn3YxWG8wa4D8S9wGZRY/DGJ+lXC87fNnITt2vF2EmEftMw52yIfcl0NBgC4zFxsFMwxCkBFZ/M7Cloq2d/Ty/sh/6e2J4qOr548qBoKeePL4IWqA4Rr06pm2aCx1i7c6KCX1
 kfmSamHR
 4glJu5+aMvzu6Yh7Q2n5OHgWd/AVhwrJd6ZLDYShmp6jR6W+M6zYQuVWCBrqNl3h63THmH2Wp/DCydHWZ4ckWBz8vobWsbk3cpIazKEpAgmHYIuT9FWuJrignaDfEihYMIocrA044YuBHd+gsPU8USYBZitZSE4RDZOfEumM05a71gFu4qHmgtkDLcLiGJIRo6IisYweA4PiIV1k1PrSuho2/jOwFE16YdKflT0kPKymRRR3rSD3ORp0oEUdSjvrIKUx5zn1Jz76r3NR60YU4gDJupNQO3F8/dzcIZ8jYt5C9lX++KnGGTHueLIOAMNi+xdnSULXiu7er+BU1EZ/JUTJej7rhiD+O0uRh2g2MlUENrhacKcVI79aVr3cYkO5TKsQ1a9kQ6MQYnVB1cfB9F7QTYh7RvBfsD8B1k3OLQT8SfZPUnOryl3yncQRfScKDdBb1E26XreZ3KyI=
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
index cb74a5d202ac..b9cd7f8d50fa 100644
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
2.52.0.rc2.455.g230fcf2819-goog


