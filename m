Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CAD1606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 06:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=OBBug+3u
Received: by kanga.kvack.org (Postfix)
	id 53A4B6B0612; Wed, 21 Oct 2026 02:05:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EA6F6B0614; Wed, 21 Oct 2026 02:05:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B2A56B0615; Wed, 21 Oct 2026 02:05:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 079FA6B0612
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:05:32 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8467AC0484
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:05:32 +0000 (UTC)
X-FDA: 85345596504.13.154E96C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 26C4B20006
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:05:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OBBug+3u;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792562730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XHN2LiOQU7r0d0fe1KkDFs3khSrbeSD24b1q7hC8HmQ=;
	b=7hyN1zhDmQlNliuHzW0xyR9xGQlI/gXqqV1ESWEIh04h6aGHJbM/CWMIvoaRySvrD9P46X
	mogKT7CcvK8GntpCGlnRu1gi1g5X/ifWk2ZfAO1sTI74Pwt1MgHXDQ6AfVMlnffl8L5UyW
	grYri7gWTNChBfn5UzR75WlImEYIS3Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OBBug+3u;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792562730;
	b=LjMtf2isWVB8m9em/ceqoQmuF+PfWMNkMOgpNHFMXpYKK0cf59pXiEEPobp7RxWAu5gYxn
	bL8OzrDFHfQrGqk5hvfcUHXv1iu9MLgt64GWwo/Y/V/+FHWPz3nGa9HLwa1uHbnBZFZmXx
	I3Qs90CWiBnian3yAfk8WP3i0wFyrWo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792562729;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XHN2LiOQU7r0d0fe1KkDFs3khSrbeSD24b1q7hC8HmQ=;
	b=OBBug+3uibLU9oY5f8ZtzOw7+wl9nlBhOGJHQVIx/yGJYOln+el0yOaRKmdyqP6/Q2IDJY
	NhfykKwcvLcYzOGLrpydgE1w6UqyIm0q/PNnTeQxpev8GG2mPJqa4miaTa+UjDv+L30Bwv
	ybQTJoozXBZEaX2Z6vsybXBFe7LE/bE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-205-zUszmNbjMjuUnjKoRja-Fw-1; Wed, 21 Oct 2026 02:05:26 -0400
X-MC-Unique: zUszmNbjMjuUnjKoRja-Fw-1
X-Mimecast-MFC-AGG-ID: zUszmNbjMjuUnjKoRja-Fw_1792562725
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-48e17d30a79so184908f8f.3
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 23:05:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792562725; x=1793167525;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XHN2LiOQU7r0d0fe1KkDFs3khSrbeSD24b1q7hC8HmQ=;
        b=jpvyVphiQ3xyGEdGnAdm5ktoShmUlhyUyel8WXD+6/TVDwrmmIqVDeAF8UeW6x9+cV
         k8Kksg1ECCi9LpQMBtNUV95QD6itdozyEeae5Xglze8+8xxoNixtJmq0eMUOTtOdUXsm
         SFQyDY/BAgc2UZB0NPprped6/RFpQwa15oHqZSDib551iCrzSC4lCkAxwClYSBBDXfJr
         RTludYr4ifnJFXTA/7BDOagcMEtWo6mRn+93roA/MvF1hTuSYdCWi93GZKIv3oGjLRkF
         IteBfiutHaEijqTjvf+49cOSdRivre65b1ZdI6wcOX68Sef4E+P6wQuDRGbhOfKksbSn
         MXdA==
X-Gm-Message-State: AFq9FYKJSCE6nTDE9b+dVnsL3FTeha9QPxRNKjYfukCnXo29NKNU7Olr
	74isY/K/SBdUNaN7Y3np+4DhkweVKoddCNxJwqygzDFBsQLIuiFZ2RvEFhRZm197T0ayyPozZl8
	LpcGslU3kIU/aBHc8BbrQ5mDBOaBWNYRMkvUzhhvOCFP1I+ZYBx00BM208hVJE7dN/e870w7UGP
	53c5htD3sfkpqH4ih6YAfT46PW1rFc6QvksxQtTA==
X-Gm-Gg: AYBFou27C9D45OQbXN6sR+8s2QqcTN6F6Kvk3+ZhzsP0YRKnXe6aTOrIqitSnAPkHEm
	mjh0sudJUNzrxL4PNy9mioXxQLdsRmGFq0GM6myie80qE19a4G7WDtG9d5wvy4wdaXVYsLTfsUH
	K/hRzWw4R59fj9++YWd7cnslumeBCm/dUC7rpRXzo2BVGkJ2vm9AU4NtrinI93Wovl3bXepJqjW
	67fXPYsE9RbNlCaxGnXABF7t2IDZFDXB5ymHxZXOg2FiUUMWo/JkvLFfpir1DD24aFmvm7c0mSG
	2uIXcx4efzPhh4iquirWDXqPgBcQeJuGomgK1uBeqhpp7pE8+N3I7pMv2/BrWhZlVF32W4IhnSP
	8avdxppJScNqB3donqxPP67C7PmUVeQns6gMV
X-Received: by 2002:a05:600c:a40f:b0:4a1:cf60:dcc3 with SMTP id 5b1f17b1804b1-4a1fdd32796mr13913145e9.29.1792562724963;
        Tue, 20 Oct 2026 23:05:24 -0700 (PDT)
X-Received: by 2002:a05:600c:a40f:b0:4a1:cf60:dcc3 with SMTP id 5b1f17b1804b1-4a1fdd32796mr13912565e9.29.1792562724382;
        Tue, 20 Oct 2026 23:05:24 -0700 (PDT)
Received: from fedora.redhat.corp (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e254f02f1sm3413741f8f.3.2026.10.20.23.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 23:05:23 -0700 (PDT)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH v16 02/12] mm: add helper to convert HMM pfn to migrate pfn
Date: Wed, 21 Oct 2026 09:04:56 +0300
Message-ID: <20261021060506.2377545-3-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261021060506.2377545-1-mpenttil@redhat.com>
References: <20261021060506.2377545-1-mpenttil@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: O7WzGpsUuv7xGY5tbLObF93liG0YchVYH9iSrPSeJ6I_1792562725
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 26C4B20006
X-Stat-Signature: achgwiuhq3o57whem6s9s8fx4i8qwbkj
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792562729-549810
X-HE-Meta: U2FsdGVkX1+72DOFsONCvMvhGCSlz6DZfSW/t+HPyo9+ey40tlmC2aqYDKH4HZVyW/FvxnOx+6tuz+wGgWdsdh2psOZY7MGzNT3cySZ7zupNYESnSDvaKFvqURyFFW1VadR70MalGP7znWIqzm6pgbLXO9oVwIaNd+m/wRr86vhjkR7E6Nu9Ldnk2NzMEOkJPGtOQpL8X6WWGtzGA4/esFdCzU4oHjcwvLw76iNsgINE7ZAN0+LSH1AFdQD5XGdqRCPo+jyREHWosO5XpDYlX4RtRixCfHP3lTQr8Xv7vh1Kdq6tM3ah+34OCFReNKWL0TNw4W69hDsTdoUckjjhPMuer4kTVeL4kFjM+YVizTEImyiv251FDj8Hpz6AGlN3qAQRbl+SI9ajdT4xM8wWzWGLqDxpJzow0s99wpYl9qokGKmy+Lg2ifFaUzsgRBatsYKw9IwJli7Q8nfyeqfb4/rV2XIbnxwdiPXzUWcfRDOGPwNKZtK2zEz+fEqXCJ28LDgalED1WjZTv0E6dAO3tkunwWZsB2ZzryxXZfwkMH+Eg6z3nMg+DHNv4gx++OGhtyEe+oGcQp7u7Ocb5Sk26TJZ6yKl784MSqpolphzatsxOoHPPLh7PoiPygjD1iQNz57PLalYDqaj2nuSyUysodqpw20rRY0nkeiDRffp1ELhOgB56xQiJorda7fqzsu1hyQoAbJga16BItM92ptbATs9BIBywOiFvV3tUzGcFnZNts+bY16aZ8vWsP1GwmaUqsWLN3LhrbtAwChukmA7QSS/r4n9VxDULnqxrGJz+FVsz6CfmIDZmdPI2denpjjx/6A3CfxcshEQix24FfRMAdufHrZOUpLowqr2VxMLmMgJwQiiUBVhky8hv0L+U/JRAon0loQnPR2OBlSnHfsMoSSq8y+Gu4JktNvoq0rnXy9ubNsg89aBZdPrOAqSg+InDnNRY6AfKjCXQARfNjv
 cJITfPof
 i7gnpF+wnKsDQo7aLTRkmuU8ekm9DXH2+5+HwOIZhofut6oJxe5A//wPaxpovUUEuuBVtTb/351gf1ZJ/EjK+tLdS1ap1nTiyQLbburr6fXL1MIDAbioK36cd428cS0zq90GVKRSI6waPAzHUhrH9DefF3MWQMab/ulC5jqQx2AHLlWnqwKk2FVJbqguMC3DMDaMLcuzdCFPnDlZBqEGh5CxkI6Kb+VfVg8JQ2hQ9Qo+95I/dd3mlEVLEAd+jhaiEuN5IGFA1DZLC97CTkjc4T0iy7GTtioFIEaBLJcZkLxaKAaZzPbLTWWd4q4WoMGopYiouig5R63oPfIFN62tBTvjHJkI0VXW7NWEsK9ZJN7WYXYPvIw3l5FM7Y+f0aAwJLbyuJkhffopsmD9hTxQat8dkqDIMeh5BVvXUH8bNby1daSsmM3+N9wMXcz5InbbbuXQTFSfOnJywNvcJbWTApKBEX1SjjZkY0Qxxi/OJL9A1DxN0zvBsbFUjow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mika Penttilä <mpenttil@redhat.com>

The unified HMM/migrate_device pagewalk does the "collecting"
on the HMM side, so we need a helper to transfer pfns to the
migrate_vma world.

Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Suggested-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
---
 include/linux/hmm.h     | 29 +++++++++++++++++-----
 include/linux/migrate.h |  3 ++-
 mm/migrate_device.c     | 55 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 80 insertions(+), 7 deletions(-)

diff --git a/include/linux/hmm.h b/include/linux/hmm.h
index 6f04e3932f5b..4f56f3419cb4 100644
--- a/include/linux/hmm.h
+++ b/include/linux/hmm.h
@@ -13,6 +13,8 @@
 
 struct mmu_interval_notifier;
 
+struct migrate_vma;
+
 /*
  * On output:
  * 0             - The page is faultable and a future call with 
@@ -27,13 +29,22 @@ struct mmu_interval_notifier;
  * HMM_PFN_P2PDMA_BUS - Bus mapped P2P transfer
  * HMM_PFN_DMA_MAPPED - Flag preserved on input-to-output transformation
  *                      to mark that page is already DMA mapped
+ * HMM_PFN_MIGRATE    - The entry is to be migrated. Note, HMM_PFN_MIGRATE
+ *                      alone without HMM_PFN_VALID denotes the
+ *                      empty page.
+ *                      This flag optionally together with HMM_PFN_COMPOUND
+ *                      are indicators for migrate_hmm_range_setup() to
+ *                      setup the migrate pfns.
+ * HMM_PFN_COMPOUND   - The entry represents a > 0 order page
  *
  * On input:
- * 0                 - Return the current state of the page, do not fault it.
- * HMM_PFN_REQ_FAULT - The output must have HMM_PFN_VALID or hmm_range_fault()
- *                     will fail
- * HMM_PFN_REQ_WRITE - The output must have HMM_PFN_WRITE or hmm_range_fault()
- *                     will fail. Must be combined with HMM_PFN_REQ_FAULT.
+ * 0                   - Return the current state of the page, do not fault it.
+ * HMM_PFN_REQ_FAULT   - The output must have HMM_PFN_VALID or hmm_range_fault()
+ *                       will fail
+ * HMM_PFN_REQ_WRITE   - The output must have HMM_PFN_WRITE or hmm_range_fault()
+ *                       will fail. Must be combined with HMM_PFN_REQ_FAULT.
+ * HMM_PFN_REQ_MIGRATE - For default_flags only, request to migrate the range,
+ *                       according to hmm_range.migrate.flags
  */
 enum hmm_pfn_flags {
 	/* Output fields and flags */
@@ -48,11 +59,15 @@ enum hmm_pfn_flags {
 	HMM_PFN_P2PDMA     = 1UL << (BITS_PER_LONG - 5),
 	HMM_PFN_P2PDMA_BUS = 1UL << (BITS_PER_LONG - 6),
 
-	HMM_PFN_ORDER_SHIFT = (BITS_PER_LONG - 11),
+	/* Migrate request */
+	HMM_PFN_MIGRATE    = 1UL << (BITS_PER_LONG - 7),
+	HMM_PFN_COMPOUND   = 1UL << (BITS_PER_LONG - 8),
+	HMM_PFN_ORDER_SHIFT = (BITS_PER_LONG - 13),
 
 	/* Input flags */
 	HMM_PFN_REQ_FAULT = HMM_PFN_VALID,
 	HMM_PFN_REQ_WRITE = HMM_PFN_WRITE,
+	HMM_PFN_REQ_MIGRATE = HMM_PFN_MIGRATE,
 
 	HMM_PFN_FLAGS = ~((1UL << HMM_PFN_ORDER_SHIFT) - 1),
 };
@@ -107,6 +122,7 @@ static inline unsigned int hmm_pfn_to_map_order(unsigned long hmm_pfn)
  * @default_flags: default flags for the range (write, read, ... see hmm doc)
  * @pfn_flags_mask: allows to mask pfn flags so that only default_flags matter
  * @dev_private_owner: owner of device private pages
+ * @migrate: structure for migrating a range of a VMA
  */
 struct hmm_range {
 	struct mmu_interval_notifier *notifier;
@@ -117,6 +133,7 @@ struct hmm_range {
 	unsigned long		default_flags;
 	unsigned long		pfn_flags_mask;
 	void			*dev_private_owner;
+	struct migrate_vma      *migrate;
 };
 
 /*
diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 78424b3824c2..280ec9a866c7 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -3,6 +3,7 @@
 #define _LINUX_MIGRATE_H
 
 #include <linux/mm.h>
+#include <linux/hmm.h>
 #include <linux/mempolicy.h>
 #include <linux/migrate_mode.h>
 #include <linux/hugetlb.h>
@@ -202,7 +203,7 @@ void migrate_device_pages(unsigned long *src_pfns, unsigned long *dst_pfns,
 			unsigned long npages);
 void migrate_device_finalize(unsigned long *src_pfns,
 			unsigned long *dst_pfns, unsigned long npages);
-
+void migrate_hmm_range_setup(struct hmm_range *range);
 #endif /* CONFIG_MIGRATION */
 
 #endif /* _LINUX_MIGRATE_H */
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 009bfa8b212d..43e571e82cca 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -1528,3 +1528,58 @@ int migrate_device_coherent_folio(struct folio *folio)
 		return 0;
 	return -EBUSY;
 }
+
+/**
+ * migrate_hmm_range_setup() - prepare to migrate a range of memory
+ * @range: contains pointer to struct migrate_vma to be set up.
+ *
+ * When collecting has been done with hmm_range_fault(), this
+ * should be called next, and completes range->migrate by
+ * populating migrate->src[] and migrate->dst[]
+ * using range->hmm_pfns[].
+ * Also, migrate->cpages and migrate->npages get initialized.
+ * After migrate_hmm_range_setup(), range->migrate is good
+ * for the rest of the migrate_vma_* flow.
+ */
+void migrate_hmm_range_setup(struct hmm_range *range)
+{
+	struct migrate_vma *migrate = range->migrate;
+
+	if (!migrate)
+		return;
+
+	migrate->npages = (migrate->end - migrate->start) >> PAGE_SHIFT;
+	migrate->cpages = 0;
+
+	for (unsigned long i = 0; i < migrate->npages; i++) {
+		unsigned long pfn = range->hmm_pfns[i];
+
+		/*
+		 * We are only interested in entries to be
+		 * migrated.
+		 */
+		if (!(pfn & HMM_PFN_MIGRATE)) {
+			migrate->src[i] = 0;
+			migrate->dst[i] = 0;
+			continue;
+		}
+
+		migrate->cpages++;
+
+		/* HMM_PFN_MIGRATE without HMM_PFN_VALID denotes the special zero page */
+		if (pfn & HMM_PFN_VALID)
+			migrate->src[i] = migrate_pfn(page_to_pfn(hmm_pfn_to_page(pfn)));
+		else
+			migrate->src[i] = 0;
+
+		migrate->src[i] |= MIGRATE_PFN_MIGRATE;
+		migrate->src[i] |= (pfn & HMM_PFN_WRITE) ? MIGRATE_PFN_WRITE : 0;
+		migrate->src[i] |= (pfn & HMM_PFN_COMPOUND) ? MIGRATE_PFN_COMPOUND : 0;
+		migrate->dst[i] = 0;
+	}
+
+	if (migrate->cpages)
+		migrate_vma_unmap(migrate);
+
+}
+EXPORT_SYMBOL(migrate_hmm_range_setup);
-- 
2.55.0


