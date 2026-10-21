Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1C7F60A4AEE
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 06:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DAz1g+9G
Received: by kanga.kvack.org (Postfix)
	id C187A6B061E; Wed, 21 Oct 2026 02:05:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC8F46B061F; Wed, 21 Oct 2026 02:05:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A698D6B0620; Wed, 21 Oct 2026 02:05:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6219C6B061E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:05:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C8E58A0472
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:05:57 +0000 (UTC)
X-FDA: 85345597554.02.F573E94
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id A0933A0002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:05:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DAz1g+9G;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792562755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uJkX/xjNUMT8lfIvEdgG314iYnxdnOBpym4KTOp3llE=;
	b=Eirk7uW1zGjuOgYipIYonKNEtHraekh9M/i93Gwi9cYJCFL2UPcoDqr42a8Y5Hxbhr/bcE
	O2fiDH89Rv94nP0OFgVBilvUMnL8SCV72fZhxm9T6Lp3SGD/gTGKiKlkV9UMtjAWIxzbWe
	aPomLEnK0Oqm0WjF/Cex1Tuj+zjfNEc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DAz1g+9G;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792562755;
	b=BzGonTxtMvQOZfB7KjZrs//QVVlaA4QhM02606NnvABfZHX1gjGoEcDBPDZ2stjer8XrMt
	6Lc5ADLQOogTxvFA6DJVoQd7+2JsC0eumzPUD6qy+E7zb2LBgvBsEf8UpZ778y4U9wfYGr
	EwnnpwTeKpAbOTE4PAnmtCPZDr3NfEw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792562755;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uJkX/xjNUMT8lfIvEdgG314iYnxdnOBpym4KTOp3llE=;
	b=DAz1g+9G/pMvSgNMuHuf7+ovOTCkDDJqbA2VJtGjTg7DfsSgaOzPRa2wkcegA5/DOYBpg2
	9+u/iK+YyUl2FIzat9N2xNoULdcpo7FYJZOhOhSwrmdN4e4DrdgN8fp35rinZ0sXgD7z71
	PZP6HsPMYELg8h3XgPgSXE9ZNZoSWZI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-180-mjYDmjWyMYyLrgdM_AVL2A-1; Wed, 21 Oct 2026 02:05:48 -0400
X-MC-Unique: mjYDmjWyMYyLrgdM_AVL2A-1
X-Mimecast-MFC-AGG-ID: mjYDmjWyMYyLrgdM_AVL2A_1792562747
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-49953abe51fso2241715e9.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 23:05:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792562747; x=1793167547;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uJkX/xjNUMT8lfIvEdgG314iYnxdnOBpym4KTOp3llE=;
        b=cQjwL06uj6I6WY0UqNvIlau8dnA/PA27Eqr0NggZ7G9HL9CPiGE4cF592mb3fqhJ5M
         2DHdcCc0SMI0hgQzLffyvX/TYoXoP+OX/7R1QwNVpHRQejLZ/QnskKR/DuJrNtgTRirE
         ExE79KOGD81so9DbQ7T0Kag9f90XvCTAEE0OLynUVNGlcP/611s21OgBZD/8ZncTsHfJ
         AVuaIE/uLBy51P7wR+vxqLMy8v/IfJNH683dKUYMi5GeKaoMHD5dJa1Pn/2yIeKSFCge
         Q+HxkYSi9v4yFelBPuf+uaZdfTVZIfxjz+fe0pt4mqUDYw8B9uYnS5EV4Nx7NuHPFqqi
         YEuw==
X-Gm-Message-State: AFq9FYL8yD+SPbq2iVkM0jNz1biaeFSZ+9lBfs+SMOm6PsVGjxxgrlnE
	2NMCTbEFT8p8i+EWI6ZwMBo+cji/RkVUxWPU89nOH+SfI5mFUpmkaK4Io+V/ImiHjZH4++X5OSN
	IoeizUrMnnocZyEbMKTYUFi2MfNiNblXuIJEk5qkoZLpCcyubMXnVrnSG/2gkS7UoKDOW6QTaxc
	QN+FjW3xc7m6rj2r2dkIzuXn/vrACMSeSajsiNwg==
X-Gm-Gg: AYBFou3xWb1eT0FpL2OAbpTKC8cN0DP1DDPDt6Azc4W0h4Fz9xQtiIr9yRvZahgVHwb
	nz2OXahBkxGGdGFnNzQX/LFC09xJTu97gsfnelU6f3xjU++HS9VWyBx2nt9p7nSbPPxj+fXodFg
	xYR3dIe6jgj+roBA68vddq9iJOT1PKhqVRD9Jrvpc/8DR7YbHRQ0w476hm1MSbYTm069D2wlJKc
	Eldm1dPJ2UfEykRA1fIqcUfAS0WZxyUdml+m+BhVqf6JT6knRNpFj8vYyKaKj63tcSnUKpL5ZPI
	CiCSv0QbGpK8/B57Tm41/HZp+XfwxjW3FRU7EXqvDvQQ1l9eU4XyFK0EuZIgjImqX2IlAKw5hbk
	41UnGLVrWDjEN3RTAte/Uhwz1/7+aO3oj2+E6
X-Received: by 2002:a05:600c:8012:b0:4a1:ef1f:a27a with SMTP id 5b1f17b1804b1-4a1fdd396ccmr15655945e9.27.1792562747415;
        Tue, 20 Oct 2026 23:05:47 -0700 (PDT)
X-Received: by 2002:a05:600c:8012:b0:4a1:ef1f:a27a with SMTP id 5b1f17b1804b1-4a1fdd396ccmr15655265e9.27.1792562746857;
        Tue, 20 Oct 2026 23:05:46 -0700 (PDT)
Received: from fedora.redhat.corp (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e254f02f1sm3413741f8f.3.2026.10.20.23.05.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 23:05:45 -0700 (PDT)
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
Subject: [PATCH v16 08/12] mm/hmm: implement rollback for device page migration in HMM pagewalk
Date: Wed, 21 Oct 2026 09:05:02 +0300
Message-ID: <20261021060506.2377545-9-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261021060506.2377545-1-mpenttil@redhat.com>
References: <20261021060506.2377545-1-mpenttil@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DUVM0VSM6w53dGtNOBOFq5SazGxtkKwOxHaWwC0gsmk_1792562747
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A0933A0002
X-Stat-Signature: jspyqwtjtasuiog3o4q9nf5k5t3ys1iu
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792562755-671656
X-HE-Meta: U2FsdGVkX18Hrge/lvqzvqQM0Lq0Tm1WXKiP+xdSbjp0qnhlSGIZkMHsIG0CiK3jP+JRnkszW9ezJT1ZA5EwnRAnftQgfIWQSiaLMp0cJbDh7YcFyZV8vfWqRBaimKLa/6sTFRuFCz9DfE4qIYJdtVD5y/XvmHwN5nvKH8LkrCNBsm+ZBzaDnGRc+LqV8ZNJrvqZKq+b+1XDl9rVD+9xXX2DPQbWKT69KguMzz89FuxRO+yKg4dp5WdEk6NDhqu7KGhuTg/ohAEOYFJKsm2slXetq9WS2ZbuLpZFul5nlyoAexsPQvUAQfWlBcMY407y0mTPo+y3YBda1J3k8EpQVyn5vj07Q5KYaVrboHa6EvM7fRG5W2PrfIdOFkxHnwJbQc4qeBQEjMTbdWA+G8AgNFvr5egWNk8w88HrtudkTyhyqWjkXUmppdWLw5NEAaElq+MZo+NkuAiHUubuaj4mWNbigQ6gYc6XdPf9nUQ2xZ9NAqvH2gruP0Mp7C081+wW5uxmEbDC6BPHdRT+4PJQ+ueZWF8RIvkW3BDdKLwm9hBdFf3x8LuyEjpu9N+bjhpATohS82tv96BqMN2Y1/pfHv12aIJCFfEOuz/c+j3CksIY7hH4/UhDzo2wosBrj9DX5kNHtIfxo/Vx0+eCEb0Zctu7tkdB0klF5Smwi/31VyNX52DCdsBn7P3KSxQoxYcjd4R1LRAjHJHphl0N3aIgjx/Sm3Jr8OsfVALw5GVW8pC0Wix9ldHc65MgDtIlAi5OpXJuKvGGIoaNNtQPm6ZdHU58zPw+yv7u+kbVlE+Nd7bam1a9pH1AaWbPstksHnd0pm1MEo/XQN5SmjLq7Azk5HEx1T5H2BAZoZOGm1UqIUjBOIQVSI2w3xvXMRpJzMVu2CqJQD29H/EVPe9cqX/ly3nSBHrrVTKsoUl6I19Ivsqj9ghEAaRN24BR1Nuk9cCXEK13YKsNZvny7ki9pUo
 ZxZdJANk
 21tanPPf8lzACsdz2/KgPR/aaIEDVqXWkdZQwv4uEcr2bMN33Y310pZwRLhHePdaESb8Se2cxNAhTDrkLyXRFk5psOV2fvrXiRoocpG4iucEv3JSt5S6Dz7JUCpIR/Z5l9udTxiB/jGFDMYATq96m79+dXfWutxYG/UMFlCSZXvbjOU1iRb4FrXRZPL+qXjpykLvuLlj6NDy/J0S+3MXDkNqIS6J7SsVROq83IsPj5z3YrCJh/NYjkNQ/jj42nk930Q6sCiJlI4i9dtyFV5UQ7QMoHnDOjeBnUy5VPz9Ac+adAh3YHgyjBCF0+mL1VoYokF+5ETwtEumFmTKtzEN6eOc0cUVJDiUOYgcmRVhHHXti5dNsg5w4ynwbUXpiGwttuF1+qTJjecX40SZbqTck/OvSxotfDwWy0l00T8Eqom/mS3xgspWMjh0FkVzkPS8YzGgs/cPYrtQrfBe1jQNbMVbbmIjKo6lJZWgVHlPKYSIUHAT4vtySiXJNQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mika Penttilä <mpenttil@redhat.com>

During the migration pagewalk, the PTE table could be cleared and/or
changed into PMD leaf or even another PTE table while dropped locks.

In these cases the possibly inserted migration ptes are gone. We have
to however undo the collecting done so far, so unlock the folios and
drop reference taken.

During the pagewalk we notice such scenarios if going to recollect a pfn
but have already committed to migrate the entry with HMM_PFN_MIGRATE, in
which case do rollback. Rollback clears (HMM_PFN_VALID | HMM_PFN_MIGRATE)
which is safe, as migration is entirely driven by default_flags.

If we encounter migration ptes they are just skipped to allow for restart
own walks.

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
 include/linux/hmm.h | 22 +++++++++++++
 mm/hmm.c            | 79 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 101 insertions(+)

diff --git a/include/linux/hmm.h b/include/linux/hmm.h
index 4f56f3419cb4..b08ebc1343dd 100644
--- a/include/linux/hmm.h
+++ b/include/linux/hmm.h
@@ -111,6 +111,28 @@ static inline unsigned int hmm_pfn_to_map_order(unsigned long hmm_pfn)
 	return (hmm_pfn >> HMM_PFN_ORDER_SHIFT) & 0x1F;
 }
 
+/*
+ * hmm_pfn_collected() - is this pfn entry prepared for migration ?
+ * If collected the folio's refcount is increased and the folio
+ * is locked.
+ */
+static inline bool hmm_pfn_collected(unsigned long hmm_pfn)
+{
+	return (hmm_pfn & (HMM_PFN_VALID | HMM_PFN_MIGRATE)) ==
+		(HMM_PFN_VALID | HMM_PFN_MIGRATE);
+}
+
+/*
+ * hmm_pfn_rollback_collected() - undoes the collection of hmm_pfn
+ *
+ * Note for total rollback the folio's refcount has to be put
+ * and folio has to be unlocked.
+ */
+static inline unsigned long hmm_pfn_rollback_collected(unsigned long hmm_pfn)
+{
+	return hmm_pfn & ~(HMM_PFN_VALID | HMM_PFN_MIGRATE | HMM_PFN_COMPOUND);
+}
+
 /*
  * struct hmm_range - track invalidation lock on virtual address range
  *
diff --git a/mm/hmm.c b/mm/hmm.c
index 36a4edde9823..5a1471fd5d28 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -95,6 +95,11 @@ enum {
 			      HMM_PFN_P2PDMA_BUS,
 };
 
+static void hmm_vma_handle_migrate_prepare_rollback(const struct hmm_vma_walk *hmm_vma_walk,
+						    unsigned long start,
+						    unsigned long end,
+						    unsigned long *hmm_pfn);
+
 static int hmm_pfns_fill(unsigned long addr, unsigned long end,
 			 struct hmm_vma_walk *hmm_vma_walk, unsigned long cpu_flags)
 {
@@ -111,6 +116,8 @@ static int hmm_pfns_fill(unsigned long addr, unsigned long end,
 		}
 	}
 
+	hmm_vma_handle_migrate_prepare_rollback(hmm_vma_walk, addr, end, &range->hmm_pfns[i]);
+
 	if (migrate && thp_migration_supported() &&
 	    (minfo & MIGRATE_VMA_SELECT_COMPOUND) &&
 	    IS_ALIGNED(addr, HPAGE_PMD_SIZE) &&
@@ -282,6 +289,8 @@ static int hmm_vma_handle_pmd(struct mm_walk *walk, unsigned long addr,
 		return hmm_record_fault(addr, end, required_fault, walk);
 	}
 
+	hmm_vma_handle_migrate_prepare_rollback(hmm_vma_walk, addr,
+						end, hmm_pfns);
 	pfn = pmd_pfn(pmd) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
 	for (i = 0; addr < end; addr += PAGE_SIZE, i++, pfn++) {
 		hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
@@ -412,6 +421,9 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 
 	new_pfn_flags = pte_pfn(pte) | cpu_flags;
 out:
+	hmm_vma_handle_migrate_prepare_rollback(hmm_vma_walk, addr,
+						addr + PAGE_SIZE,
+						hmm_pfn);
 	*hmm_pfn = (*hmm_pfn & HMM_PFN_INOUT_FLAGS) | new_pfn_flags;
 	return 0;
 
@@ -450,6 +462,9 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 		if (softleaf_is_device_private_write(entry))
 			cpu_flags |= HMM_PFN_WRITE;
 
+		hmm_vma_handle_migrate_prepare_rollback(hmm_vma_walk,
+							start, end,
+							hmm_pfns);
 		/*
 		 * Fully populate the PFN list though subsequent PFNs could be
 		 * inferred, because drivers which are not yet aware of large
@@ -568,6 +583,51 @@ static int migrate_vma_split_folio(struct folio *folio,
 	return __migrate_vma_split_folio(folio, fault_page);
 }
 
+/*
+ * Due to dropping ptl locks for splitting for instance, would we
+ * overwrite already collected pfns? This could happen when pmd
+ * pointing to a page table has vanished and been replaced with
+ * a leaf pmd, or another page table. In that case unref and unlock
+ * the folios, the pfns of which were collected from the disappeared
+ * page tables.
+ *
+ * Migrate mode drives fault/migration requests only via range->default_flags.
+ * (HMM_PFN_VALID | HMM_PFN_MIGRATE) denotes a collected entry and can safely
+ * be cleared from hmm_pfn[].
+ */
+static void hmm_vma_handle_migrate_prepare_rollback(const struct hmm_vma_walk *hmm_vma_walk,
+						    unsigned long start,
+						    unsigned long end,
+						    unsigned long *hmm_pfn)
+{
+	struct hmm_range *range = hmm_vma_walk->range;
+	struct migrate_vma *migrate = range->migrate;
+	struct folio *fault_folio = NULL;
+	enum migrate_vma_info minfo;
+	struct folio *folio;
+	unsigned long i;
+
+	minfo = hmm_select_migrate(range);
+	if (!minfo)
+		return;
+
+	WARN_ON_ONCE(!migrate);
+
+	fault_folio = migrate->fault_page ?
+		page_folio(migrate->fault_page) : NULL;
+
+	for (i = 0; start < end; start += PAGE_SIZE, i++) {
+		if (hmm_pfn_collected(hmm_pfn[i])) {
+			folio = page_folio(hmm_pfn_to_page(hmm_pfn[i]));
+			if (folio != fault_folio)
+				folio_unlock(folio);
+			folio_put(folio);
+			hmm_pfn[i] = hmm_pfn_rollback_collected(hmm_pfn[i]);
+
+		}
+	}
+}
+
 static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
 					      pmd_t *pmdp,
 					      unsigned long start,
@@ -722,6 +782,11 @@ static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
 	pte = ptep_get(ptep);
 
 	if (pte_none(pte)) {
+		hmm_vma_handle_migrate_prepare_rollback(hmm_vma_walk,
+							addr,
+							addr + PAGE_SIZE,
+							hmm_pfn);
+
 		if (vma_is_anonymous(walk->vma)) {
 			*hmm_pfn &= HMM_PFN_INOUT_FLAGS;
 			*hmm_pfn |= HMM_PFN_MIGRATE;
@@ -769,6 +834,10 @@ static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
 		pfn = pte_pfn(pte);
 		if (is_zero_pfn(pfn) &&
 		    (minfo & MIGRATE_VMA_SELECT_SYSTEM)) {
+			hmm_vma_handle_migrate_prepare_rollback(hmm_vma_walk,
+								addr,
+								addr + PAGE_SIZE,
+								hmm_pfn);
 			*hmm_pfn = HMM_PFN_MIGRATE;
 			goto out;
 		}
@@ -897,6 +966,13 @@ static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
 }
 
 #else
+static void hmm_vma_handle_migrate_prepare_rollback(const struct hmm_vma_walk *hmm_vma_walk,
+						    unsigned long start,
+						    unsigned long end,
+						    unsigned long *hmm_pfn)
+{
+}
+
 static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
 					      pmd_t *pmdp,
 					      unsigned long start,
@@ -1117,6 +1193,9 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 		if (ptep) {
 			lazy_mmu_mode_enable();
 			hmm_vma_walk->ptelocked = true;
+		} else {
+			/* The pte table is gone */
+			hmm_vma_handle_migrate_prepare_rollback(walk->private, addr, end, hmm_pfns);
 		}
 	} else {
 		ptep = pte_offset_map(pmdp, addr);
-- 
2.55.0


