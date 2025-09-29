Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB7A4CAC5BB
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 01:05:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 735918E001F; Sun, 28 Sep 2025 21:04:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 649448E0006; Sun, 28 Sep 2025 21:04:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C1718E001F; Sun, 28 Sep 2025 21:04:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 18CBF8E0006
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 21:04:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E250F16020B
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:04:48 +0000 (UTC)
X-FDA: 83940493056.21.F8FD437
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0ECB840005
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:04:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=dEWD+Fgd;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759107887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o6klfNbsQaSU6FDtMq1rEXrmqStKMVNSQ5o5W34IBdA=;
	b=0Nz1j5iYXKt1fFhGkliPERsnBXPXNDHKaXRS5Ghp52fdXtmjJIhVazEk5wFZEwRVj1UQge
	CdywK+WWZsm3nR9EcLLOcejS7eEbty9mr5iS02pRgSF6X79RjL2SBX7rrwCuu0m3u/zXYw
	OAkeDS4whc4HxxuGXMqqTwwoh7CJjBQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=dEWD+Fgd;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759107887; a=rsa-sha256;
	cv=none;
	b=cs7b7OJ8UJNx7ukZyOddy0D+72ycvM0tEd5z4S/VuOwQikTUhny0gGSxmhdy3Y2ErqVsxb
	njrwTZRzvUcqlPfd4sFwF4Cm1JzlmrVWt1NhlCsEJ8qVJd9+1/3rLhtxegi3ciQdjsXMmd
	udyy2uNHaXkDgBnq1750+NozhtgTr1Q=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4dce9229787so33647961cf.0
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 18:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759107886; x=1759712686; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o6klfNbsQaSU6FDtMq1rEXrmqStKMVNSQ5o5W34IBdA=;
        b=dEWD+FgdCy+yGbW1t+R/nDvbEZuVkd/x0K8SjLEL1Wdwx3RlqfuWPl4bDUYymVqWGy
         3bGhYTli5SAx8Z1gs5zN00FNTd0PzSO7MdSJGcvTZg2MBhJj5FyhdhrdKz0wux1JVqD9
         va3vPu+O+IAiEu3e7Sf1ONZSLeMK/YwGBgszYSdxcj/SWRhfowUZzX5pfzGZ0E+bWJik
         C4Fgp3f8iYwNCt/4t8gHnJBgEqNGjhdlxunAISof3xy8wLDaTZifEI8xDPEwI14BVPO/
         v5VwO/sdNwv4wjpKPFZAhkIhBBwx3c5ldL3ZFq1VRtmiTi3p2c1OeGf+YsgFdQ6aO3CH
         ljpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759107886; x=1759712686;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o6klfNbsQaSU6FDtMq1rEXrmqStKMVNSQ5o5W34IBdA=;
        b=mpjaal2F/FKSQLnR+I7O0bi9C7Unx4zhLhfEEYTDF/mJDQ3fm5NQRe08ayO2EJJOXH
         YXWiBXiKWETpo5lAOdIHlTor12QEFjwbzL1OJE76rNIJBNHxYJw3F/4jI1caeG7aY8Sn
         by47hLVnjyb3LueMjoQgeBo0Az/yMwvcyVB/hgt4O6xcZavrOeXwSyOhyy5meiWhHMTD
         7PjGWIb1L06oshqhc5KbrERlxeh5/19uIsBKo2x/v2YngxthPlghS1+TNbUyGwnwen9w
         WDJ474Hy0Mz9dspviE9LyJyQFh2inE49mDDJXR71OXplBoWABKnMPkKkjERFo0Vln4zn
         eRhg==
X-Forwarded-Encrypted: i=1; AJvYcCUKC4+TBvB+KAHb22Nl0Azt2nhhMDL/ID6iFuqwsjoqzCA8yDBI+s9fJWHLzJW2HKhBw68morFPMw==@kvack.org
X-Gm-Message-State: AOJu0YzNi/cQtc8hBSbR1IzFyF1c1YRxW4qH0Daycjx705mx02GXMYhW
	T3nEIzh7yBzqPmK23xeb5c3RasngQPkD4+kjvhSGshwn6iuCW04kTPcwIFQLHtCpk6k=
X-Gm-Gg: ASbGncvgA2mapGJsjOMBvkWAImKg8gscouslxPIhXXzHYq1TTnl4YkQnV7wr6ckOPPR
	jFRAKdgDhBE+nZZimkbaIgrcmUMhUlSYOp+DbI/p/uSgYq+xIcMw9dWf1ufXjnGn9dfR83yCutI
	HkuhXD6hVRgNXcEgaqMXDW5Swt+pqYph8ZUQSd91HNx2Ree9+4c1ZXaEgHeqE1QHDmIXCrFEJM9
	HdCbOE4ey2vZnfHe5n2K0EVmikTtj90VdoNvD9sgfY96tPZ19DDMcgO53EIbqt4uYB65Ox8IaUb
	1horT0OwsOcIDonGfCKWIed6Yk3A3rK6Zgp9tihlEGU8F+kAhx5WkPzGzBxpOqyENZd6/yuv1ah
	/DOUDI4OfZElLxbMa+IlH4MLXDPmNUojd0nQQKnaPZxbO6pwGx8uYiFwweQdB4f9QwPNuk2YV1d
	8MZZL0C7XDbrpjfTdX+pd3dWhotInt
X-Google-Smtp-Source: AGHT+IHEKESKD14PFByufgCCj+q1xbdbjfqjaSBhECif5xZZLUIBv1xuJQ+qilMP2TC7MJ+Z1A1Lng==
X-Received: by 2002:a05:622a:19a3:b0:4df:194:b46d with SMTP id d75a77b69052e-4df0194c12cmr84674601cf.80.1759107886091;
        Sun, 28 Sep 2025 18:04:46 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4db0c0fbe63sm64561521cf.23.2025.09.28.18.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Sep 2025 18:04:45 -0700 (PDT)
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
	witu@nvidia.com,
	hughd@google.com,
	skhawaja@google.com,
	chrisl@kernel.org,
	steven.sistare@oracle.com
Subject: [PATCH v4 23/30] mm: shmem: export some functions to internal.h
Date: Mon, 29 Sep 2025 01:03:14 +0000
Message-ID: <20250929010321.3462457-24-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
In-Reply-To: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0ECB840005
X-Stat-Signature: mqmca4ssemrbdsbdi4e3xbgkmeqnbsw8
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759107886-985238
X-HE-Meta: U2FsdGVkX1/G7+d0y0DUd+egeVub9/65gKUCrYGKgjhPPubwioEqnRKDapJnPg5LMjxQwjAqrzeahlM+Zs9ey34zCQU1QmAp0O2qJizIUjGypTOGIsbIc1P8w64RYqAAfbpSgFX3qLzUj0crmIAmHtOhnrEsM7vh6oFFczmTwVi21p29hS2BOToz1Iwwx5UZBVGpyr+pd2wBHNA80ZG4h4h85QeDZQP9jAtKCaUQEoKmHzJCnD/Bs/MOiSzEtxkXGdCPVo2ozR38sgOdVxFLpDNoCe6XjLkhwpOmUj9sTGwA/D/97Ug+XYttHAZ0SqH3r2LGpwFURBZ1fwf6DZcBtOJTVDn1s8mXuTFvuUhe2j8SBuXAZI4NSZxGx4AN8RVauW9N6zYBDKjtdtBi7pHJbRXi3hzXof+/e1or58apcV/KuGLl0Tq0s85A2nvCLiLg/1pF5LiRH1sDhtBKLbLYtXOrKFSuifO2H9Y0HqO4D+105L76N9+ala6H36iJyLcgTeyza44o2Il8fl4dROjkU9BaZpDoYGQnj0+bBuiexPt96v+7f4Js024l7Sa30lLfouATYKt4NkKYTetnuN5cXNS1iDZkh1yO2N9xuyqNalC8e9J+Xz6vNKHKWiJBzOq+UelcsWFZx9KTPEhCZRTGDhQg4pDBhkZdDtKebl7aNOzZVYiu7c9CnoeJAb1Kdg+HVrmEUTCfd/nm931j/5tmERN7DkWRp17TZQ3aSuIu+hVaA3jFaIAKjfQfvKjG9Zw9Xv+FwptOtWh6jtNodY7AsypvrCYpI4Ju2X2QOy/kiJdCHMIo+DHAXLDkCsXp6FhrYhky3ds9ncWYJXAIdI3HzbhPqE6IhfX6Z08VH5s5Rjzc1Rd2weCAzZMZBFhCB0I7Y4/X/LMHgpa4NWSMAh3Rbnq1I6yeQYSy+iUiyg3a/zXcLCX8bgieU8XSfODnC9+ZjX+SrRGnTTrx6wwdart
 GY/Iek6E
 TOf2jZC/HBE/+YZF8TmZtM8M4Ok9PHEl+2S73ao6WU7avm6saGIbrN1UaqMcQ2MQ6TeHzj6fDW6PDmIB0jDefhS0VYo/hnxDaWukbhxo/HqqieEEZiG0SSTDyzpARSDmBXkr8tMXfMRmYzl0IVkdA9fA2IuVHifEh9gJf/DtXvCH1rWP1XJ3xqvdF8pWxMASmkXUZzXrvfB+ZX8KLovhPba2GJsiGAeZKM3EgpHT4tHgeCrw3mzOie12hjGDIe2D7bkqlEZXyIBT/D3yQ4EMYQI/6xKSgNRqI4BlHwGaUILkGq5iIHiOBHnZcVrV0QrxNoVUmTssjFqsWcSeGRx365TKd24XGZ31f0Q+APTagdZtKE4hkDm72daITzJnEi70jOKP5rzpNmfT0aJk=
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
functionality will also be used in the future by Live Update
Orchestrator (LUO) to recreate memfd files after a live update.

Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
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
index bd7d9afe5a27..4647a0b2831c 100644
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
2.51.0.536.g15c5d4f767-goog


