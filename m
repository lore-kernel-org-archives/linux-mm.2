Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CB5E60A3825
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 06:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=BwZh7KTz
Received: by kanga.kvack.org (Postfix)
	id 86F646B0617; Wed, 21 Oct 2026 02:05:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F7496B0618; Wed, 21 Oct 2026 02:05:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64B286B0619; Wed, 21 Oct 2026 02:05:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2BC2B6B0617
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:05:39 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 10AA84047C
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:05:38 +0000 (UTC)
X-FDA: 85345596756.17.6EC03DB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id B9819A0005
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:05:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BwZh7KTz;
	spf=pass (imf25.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792562735;
	b=MbBaQh4kRfAspGfBetbrpaiLasHGQ9viYA3BE2cBOuI9pV8uWe2UjHXNQkGPEghUlHCVTL
	ynUOSsByOsdLOAY5OZHA2SO6rEGXkLfzt1SG/CV+YXn3lu6JGo9jIyWP++fDes/Z2PjjSO
	fSkoDLb2Rzis95ZCud58hFmbGV4bwh4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BwZh7KTz;
	spf=pass (imf25.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792562735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HEmj1411uY6iAreTcWJKGyUmaby42JAEKedKWfFEblE=;
	b=DFPnH4mtPtWWGtUvGGmlsvWYvdWMd6k+nkIbpeQijdFCx1bF9cQ3VKJYOtLNUEy8krlKav
	arOS9l5T7acouGNyfFU5xoL0ZOyZH6XGIR5gp3IhrKNTolrZnSm0rJMNZA40HYpum2VrOG
	zysqQMHaZni50A6FnW4KFZRWyujoHBE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792562735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HEmj1411uY6iAreTcWJKGyUmaby42JAEKedKWfFEblE=;
	b=BwZh7KTz6KXHVUsRkDsfsZlmU1nGJCPz71AL7oLP56oIO7QNGE2AsYi3aUZvnJVryxdPvW
	GFr0teh0t9ubn6224wYTvnSSE5pHNyLKGcCGWZJXJUw4uTpk9XnOcKC2ATbMSlHKrKnskE
	WI11cUdKra2WMIbbXzj/7yIxl67tT9k=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-119-HkjxEeF-OMa_cg6XehQfqA-1; Wed, 21 Oct 2026 02:05:33 -0400
X-MC-Unique: HkjxEeF-OMa_cg6XehQfqA-1
X-Mimecast-MFC-AGG-ID: HkjxEeF-OMa_cg6XehQfqA_1792562733
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-48c7fe9736eso310677f8f.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 23:05:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792562733; x=1793167533;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HEmj1411uY6iAreTcWJKGyUmaby42JAEKedKWfFEblE=;
        b=HqbeSzQ0kZ8PX52FVAfzYh1GcfT+bXqrhk7dJkUVbeaqm2MwwpIEERMoeZNUY+FmOy
         Blbs8TWF3KqCugVanoGd45Fd/nnHKXUjVS4lWu5D9BtUMNlium1W8hz0sltPQpZzJXv0
         0s5Fu1f0E7c1gOWhhSOSIlWp2t5d3m9v00jzgk7ETy/gEx7tBiu5HA/yzjektFcsyvx5
         iJ4yiyKW5WuSuwTwRsdM3ijOS5rBdTtO48m01ETXwxCFjp+eefB1AkozywYZaUKKhASi
         m9IfixjJ8mM5htu1XqCekKLkEJ3EoNDEFJZQJAW/zjeX0hEC1elqBNRtfF3a0iocbc1g
         p65w==
X-Gm-Message-State: AFq9FYKTd8Xx95vyIoQCSIpL43xi4eXRQp+Ju1tgxej3gxiaIhki9WrD
	nFZg7ZyKsVAAXzFQlqWlsoOam06Du9tzuGtWQpZHKHnJ0UbZpPZv0LDZOm/yKdpr0Iv7xga43IQ
	ea4m6W6XVolA2jPH0b3Um36g011gJaKAr+sPumHDMOzM0ejSWnvsSdok3o8XUS9ce/5TePVaf2f
	0/6nMgIpvo84oWDiV2uJkXxu5e34ncWCh3H4Ejyg==
X-Gm-Gg: AYBFou2zIfpssKgRk0ZLQdulBZTDsbzM37RYO5xwDxVkeq3w8o1jKtjoTPrd7AGGSrN
	+YJeYlwPRVNj67FzMEAQd4UbAPCDoQve3VMzJBzuzG8x9F3iTBzFIYQ7pxabU4FQ4g6IRdrdWAt
	aiclQKJbdAR49rXN4T4MIgmKxY508XmzfqllxmSWKE13ume5PI8sab4Jh0bXkUuosstHdBYmtVU
	MiNM1pW6OMhFvEpjFd6GvjDQxbu7c2barjk9BqquWENeeJpdMtQG+Ed+2jUbyhK3Z8A1vZGM5TN
	d35wYrTIcIrlbimgTFoxm12OXuBaKpz4Ej3CzHw4TlLAbXpGCuutcVXzHkkrISz4F4MGssaXq3t
	cXKAIhhMJIFiwDaUPw0g6TDb8X08k6fw/Xb8w
X-Received: by 2002:a05:6000:26c9:b0:48e:1299:663f with SMTP id ffacd0b85a97d-48e264f1802mr1981605f8f.56.1792562732600;
        Tue, 20 Oct 2026 23:05:32 -0700 (PDT)
X-Received: by 2002:a05:6000:26c9:b0:48e:1299:663f with SMTP id ffacd0b85a97d-48e264f1802mr1981527f8f.56.1792562732039;
        Tue, 20 Oct 2026 23:05:32 -0700 (PDT)
Received: from fedora.redhat.corp (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e254f02f1sm3413741f8f.3.2026.10.20.23.05.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 23:05:30 -0700 (PDT)
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
Subject: [PATCH v16 04/12] mm/hmm: do the plumbing for HMM to participate in migration
Date: Wed, 21 Oct 2026 09:04:58 +0300
Message-ID: <20261021060506.2377545-5-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261021060506.2377545-1-mpenttil@redhat.com>
References: <20261021060506.2377545-1-mpenttil@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DXVcbXFciLfOaO39d1UawZPgvGl8ZuI6XE8eL5LzPjg_1792562733
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pqga61qea3z1ka9q7endk64hpdd1ho6w
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B9819A0005
X-Rspam-User: 
X-HE-Tag: 1792562735-235174
X-HE-Meta: U2FsdGVkX197M+jclKObMqILuXp/pCrjaI5BY3Rke9IgFy1THCsAAeKDTbkhHuYvkAaQMD1/b52n3pHzXCtuhpdsPJReOvYXGiLz2rdS/mdzPbEojq1oS0dvF3wJahhGTPi/nu6GVGzvyIKHqVouORkk8unk54FOnI1E1KI3EdLOQxPMEJGa6I3PG+Qk7PKrWPdfm0fsUvxMth9NetxeuwyosKz+REzFHVSs7NM5fJOwkM99nnTpB+Tpgh90W02YHML6esuMOAa8SduByISbIftmhEWcszexvCXjsK0qqy+Y/S6x33gln58g7XFbkt+qisM3wmJw+Zi5SnBUO0NsxcqhWTFtZ+QZ7ZBzh1rw8oDe+0ySlKw4SV/C5y0OKJO4p7p1rvoh2+40aidm+fmWKJS0v1u+5+c+SJQSTCHv2332v+wjW72Q2OSIbISPtxp7P0xiCuY+r5arAU1qx2WxL9bKdVMgbW608ckaRMwss/i/tp44x8lnUeVEZEcsKtzhCOhT+Sm8EeL6ITsE5ySlwak6OdL+aC99BarouzZsXdJrixFpDXAUwhU+hDiH0+QyGm1DSJFDOKhFOr78NIrKDI9DiRgE9CGhhzdce/zGezxc1NlAehNSGDkkeeAXXVtQcuI/jgflu23wSasmMaI6LzKd8zUNS/SNJTN4TGBlHo34FXwugmEKHgoqDr4GUPyOmxKLaPMPXJRIeK2ugLvsJGcLt6LbCjXz7SLxnOlXbgPkGHAVtIJf0/HLJJGJ1B6PdLQFCdzo8udxoMy/oYDwl1ZCbJCkP525rMGEf3V+/Kf5mNbCt0897Bnx7KJj96UeWrka7olJmxv3tWtKfd6vg4uB3phPwQ+FuV+l3J/YFZaPWC7DNNGc+wfZDwzZgXIJDD0Wg0iDa1d+ghY/SxyQ4SbBgTnmRjmkVSRaub39AftjeSL0bKbyd4Dm4BaKfxxh+yRtBAnT1f0szoE+rad
 X3g9f0CT
 srn+sglsMxiFYBIQ48B7A2R2AEv6MWN1kdEhrin611xIDogkAR/83vt98bThhQMvYolpOanRnW+INcNr2v13QHBJrfOTqNDoBcHPL7xRpiDf86fMZMkOMQeCc2zyd25px+ILIPH0HWFom+Xbs5X8lmdKVZM94xY1Z7Ckmc9QSEy/CNU4GIrslTMhyuiuu1kXXAcunmgksVdEGkKIr6iFQYI581B/i0S2uOdIMJTh4W0uCNWZg3WfMMTXu0jds2Pq4lW3jBAygQG/wrxnSCNWGbSj+pL132v4rpWCcRfBc2yNBQhgw+GZPUixjjipdG84Ld5sxV+xrt882tt9Eqw8anRtXW8H7TUzmCjfelq/mMC88ic4xEw6qezhu839uYP6eCoCMkUE78X2gtqocq139TPcJnfWMzeK2lqqTYRNR73/B+pZ6LpV9T/IP32c21BRhC0mpXraTSzJ0CoxZlZekhpdB9XC1MVJSQpMNIL08dZkturmJvWC0zPvdTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mika Penttilä <mpenttil@redhat.com>

Do the preparations in hmm_range_fault() and pagewalk callbacks to
do the "collecting" part of migration, needed for migration.

These steps include locking for pmd/pte if migrating, and calling the
still dummy hmm_vma_handle_migrate_prepare_pmd() and
hmm_vma_handle_migrate_prepare()  functions in the pagewalk.

When doing migration, have to have pmd/pte table locked for the
duration of both hmm_vma_handle*() and hmm_vma_handle_migrate_prepare*()
walks, and unlock when handling the faults.

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
 mm/hmm.c | 343 ++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 289 insertions(+), 54 deletions(-)

diff --git a/mm/hmm.c b/mm/hmm.c
index 4e9542aedc25..119e70dbca56 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -42,6 +42,16 @@ struct hmm_vma_walk {
 	unsigned long			start;
 	unsigned long			end;
 	unsigned long			last;
+	/*
+	 * For migration we need pte/pmd locked for the handle_* and
+	 * prepare_* regions. While faulting we have to drop the locks
+	 * and start again. ptelocked and pmdlocked hold the state
+	 * and tell  if need to drop locks before faulting.
+	 * ptl is the lock held for pte or pmd.
+	 */
+	bool				ptelocked;
+	bool				pmdlocked;
+	spinlock_t			*ptl;
 	/* fault and lock drop related fields */
 	bool				*mmlocked;
 	unsigned long			fault_end;
@@ -63,6 +73,16 @@ struct hmm_vma_walk {
  */
 #define HMM_FAULT_UNLOCKED	-ENOLCK
 
+#define HMM_ASSERT_PTE_LOCKED(hmm_vma_walk, locked)		\
+	WARN_ON_ONCE((hmm_vma_walk)->ptelocked != locked)
+
+#define HMM_ASSERT_PMD_LOCKED(hmm_vma_walk, locked)		\
+	WARN_ON_ONCE((hmm_vma_walk)->pmdlocked != locked)
+
+#define HMM_ASSERT_UNLOCKED(hmm_vma_walk)			\
+	WARN_ON_ONCE((hmm_vma_walk)->ptelocked ||		\
+		     (hmm_vma_walk)->pmdlocked)
+
 enum {
 	HMM_NEED_FAULT = 1 << 0,
 	HMM_NEED_WRITE_FAULT = 1 << 1,
@@ -76,14 +96,38 @@ enum {
 };
 
 static int hmm_pfns_fill(unsigned long addr, unsigned long end,
-			 struct hmm_range *range, unsigned long cpu_flags)
+			 struct hmm_vma_walk *hmm_vma_walk, unsigned long cpu_flags)
 {
+	struct hmm_range *range = hmm_vma_walk->range;
 	unsigned long i = (addr - range->start) >> PAGE_SHIFT;
+	enum migrate_vma_info minfo;
+	bool migrate = false;
+
+	minfo = hmm_select_migrate(range);
+	if (cpu_flags != HMM_PFN_ERROR) {
+		if (minfo && (vma_is_anonymous(hmm_vma_walk->vma))) {
+			cpu_flags |= HMM_PFN_MIGRATE;
+			migrate = true;
+		}
+	}
+
+	if (migrate && thp_migration_supported() &&
+	    (minfo & MIGRATE_VMA_SELECT_COMPOUND) &&
+	    IS_ALIGNED(addr, HPAGE_PMD_SIZE) &&
+	    IS_ALIGNED(end, HPAGE_PMD_SIZE) &&
+		end-addr == HPAGE_PMD_SIZE) {
+		range->hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
+		range->hmm_pfns[i] |= cpu_flags | HMM_PFN_COMPOUND;
+		addr += PAGE_SIZE;
+		i++;
+		cpu_flags = 0;
+	}
 
 	for (; addr < end; addr += PAGE_SIZE, i++) {
 		range->hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
 		range->hmm_pfns[i] |= cpu_flags;
 	}
+
 	return 0;
 }
 
@@ -103,6 +147,7 @@ static int hmm_record_fault(unsigned long addr, unsigned long end,
 	struct hmm_vma_walk *hmm_vma_walk = walk->private;
 
 	WARN_ON_ONCE(!required_fault);
+	HMM_ASSERT_UNLOCKED(hmm_vma_walk);
 	hmm_vma_walk->last = addr;
 	hmm_vma_walk->fault_end = end;
 	hmm_vma_walk->required_fault = required_fault;
@@ -187,11 +232,16 @@ static int hmm_vma_walk_hole(unsigned long addr, unsigned long end,
 	if (!walk->vma) {
 		if (required_fault)
 			return -EFAULT;
-		return hmm_pfns_fill(addr, end, range, HMM_PFN_ERROR);
+		return hmm_pfns_fill(addr, end, hmm_vma_walk, HMM_PFN_ERROR);
 	}
-	if (required_fault)
+	if (required_fault) {
+		if (hmm_vma_walk->pmdlocked) {
+			spin_unlock(hmm_vma_walk->ptl);
+			hmm_vma_walk->pmdlocked = false;
+		}
 		return hmm_record_fault(addr, end, required_fault, walk);
-	return hmm_pfns_fill(addr, end, range, 0);
+	}
+	return hmm_pfns_fill(addr, end, hmm_vma_walk, 0);
 }
 
 static inline unsigned long hmm_pfn_flags_order(unsigned long order)
@@ -224,8 +274,13 @@ static int hmm_vma_handle_pmd(struct mm_walk *walk, unsigned long addr,
 	cpu_flags = pmd_to_hmm_pfn_flags(range, pmd);
 	required_fault =
 		hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, cpu_flags);
-	if (required_fault)
+	if (required_fault) {
+		if (hmm_vma_walk->pmdlocked) {
+			spin_unlock(hmm_vma_walk->ptl);
+			hmm_vma_walk->pmdlocked = false;
+		}
 		return hmm_record_fault(addr, end, required_fault, walk);
+	}
 
 	pfn = pmd_pfn(pmd) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
 	for (i = 0; addr < end; addr += PAGE_SIZE, i++, pfn++) {
@@ -305,14 +360,25 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 			goto fault;
 
 		if (softleaf_is_migration(entry)) {
-			pte_unmap(ptep);
-			hmm_vma_walk->last = addr;
-			migration_entry_wait(walk->mm, pmdp, addr);
-			return -EBUSY;
+			if (!hmm_select_migrate(range)) {
+				HMM_ASSERT_UNLOCKED(hmm_vma_walk);
+				pte_unmap(ptep);
+				hmm_vma_walk->last = addr;
+				migration_entry_wait(walk->mm, pmdp, addr);
+				return -EBUSY;
+			}
+			return 0;
 		}
 
 		/* Report error for everything else */
-		pte_unmap(ptep);
+
+		if (hmm_vma_walk->ptelocked) {
+			pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
+			hmm_vma_walk->ptelocked = false;
+		} else {
+			pte_unmap(ptep);
+		}
+
 		return -EFAULT;
 	}
 
@@ -329,7 +395,13 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 	if (!vm_normal_page(walk->vma, addr, pte) &&
 	    !is_zero_pfn(pte_pfn(pte))) {
 		if (hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags, 0)) {
-			pte_unmap(ptep);
+			if (hmm_vma_walk->ptelocked) {
+				pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
+				hmm_vma_walk->ptelocked = false;
+			} else {
+				pte_unmap(ptep);
+			}
+
 			return -EFAULT;
 		}
 		new_pfn_flags = HMM_PFN_ERROR;
@@ -342,7 +414,12 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 	return 0;
 
 fault:
-	pte_unmap(ptep);
+	if (hmm_vma_walk->ptelocked) {
+		pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
+		hmm_vma_walk->ptelocked = false;
+	} else {
+		pte_unmap(ptep);
+	}
 	/* Fault any virtual address we were asked to fault */
 	return hmm_record_fault(addr, end, required_fault, walk);
 }
@@ -386,13 +463,18 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 	required_fault = hmm_range_need_fault(hmm_vma_walk, hmm_pfns,
 					      npages, 0);
 	if (required_fault) {
-		if (softleaf_is_device_private(entry))
+		if (softleaf_is_device_private(entry)) {
+			if (hmm_vma_walk->pmdlocked) {
+				spin_unlock(hmm_vma_walk->ptl);
+				hmm_vma_walk->pmdlocked = false;
+			}
 			return hmm_record_fault(addr, end, required_fault, walk);
+		}
 		else
 			return -EFAULT;
 	}
 
-	return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
+	return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
 }
 #else
 static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
@@ -400,15 +482,58 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 				     pmd_t pmd)
 {
 	struct hmm_vma_walk *hmm_vma_walk = walk->private;
-	struct hmm_range *range = hmm_vma_walk->range;
 	unsigned long npages = (end - start) >> PAGE_SHIFT;
 
 	if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
 		return -EFAULT;
-	return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
+	return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
 }
 #endif  /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
 
+#ifdef CONFIG_DEVICE_MIGRATION
+static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
+					      pmd_t *pmdp,
+					      unsigned long start,
+					      unsigned long end,
+					      unsigned long *hmm_pfn)
+{
+	// TODO: implement migration entry insertion
+	return 0;
+}
+
+static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
+					  pmd_t *pmdp,
+					  pte_t *ptep,
+					  unsigned long addr,
+					  unsigned long *hmm_pfn,
+					  bool *unmapped)
+{
+	// TODO: implement migration entry insertion
+	return 0;
+}
+
+#else
+static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
+					      pmd_t *pmdp,
+					      unsigned long start,
+					      unsigned long end,
+					      unsigned long *hmm_pfn)
+{
+	return 0;
+}
+
+static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
+					  pmd_t *pmdp,
+					  pte_t *ptep,
+					  unsigned long addr,
+					  unsigned long *hmm_pfn,
+					  bool *unmapped)
+{
+	return 0;
+}
+
+#endif
+
 static int hmm_vma_capture_migrate_range(unsigned long start,
 					 unsigned long end,
 					 struct mm_walk *walk)
@@ -468,46 +593,116 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 {
 	struct hmm_vma_walk *hmm_vma_walk = walk->private;
 	struct hmm_range *range = hmm_vma_walk->range;
-	unsigned long *hmm_pfns =
-		&range->hmm_pfns[(start - range->start) >> PAGE_SHIFT];
 	unsigned long npages = (end - start) >> PAGE_SHIFT;
+	struct mm_struct *mm = walk->vma->vm_mm;
+	unsigned long *hmm_pfns, *hmm_pfns_start;
+	enum migrate_vma_info minfo;
 	unsigned long addr = start;
+	bool unmapped = false;
+	unsigned long i;
 	pte_t *ptep;
 	pmd_t pmd;
+	int r = 0;
 
+	minfo = hmm_select_migrate(range);
+	hmm_pfns_start = &range->hmm_pfns[(start - range->start) >> PAGE_SHIFT];
 again:
-	pmd = pmdp_get_lockless(pmdp);
-	if (pmd_none(pmd))
-		return hmm_vma_walk_hole(start, end, -1, walk);
+	hmm_pfns = &range->hmm_pfns[(addr - range->start) >> PAGE_SHIFT];
+	hmm_vma_walk->ptelocked = false;
+	hmm_vma_walk->pmdlocked = false;
+
+	if (minfo) {
+		hmm_vma_walk->ptl = pmd_lock(mm, pmdp);
+		hmm_vma_walk->pmdlocked = true;
+		pmd = pmdp_get(pmdp);
+	} else
+		pmd = pmdp_get_lockless(pmdp);
+
+	if (pmd_none(pmd)) {
+		r = hmm_vma_walk_hole(start, end, -1, walk);
+
+		if (hmm_vma_walk->pmdlocked) {
+			spin_unlock(hmm_vma_walk->ptl);
+			hmm_vma_walk->pmdlocked = false;
+		}
+		return r;
+	}
 
 	if (thp_migration_supported() && pmd_is_migration_entry(pmd)) {
-		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0)) {
-			hmm_vma_walk->last = addr;
-			pmd_migration_entry_wait(walk->mm, pmdp);
-			return -EBUSY;
+		if (!minfo) {
+			if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns_start, npages, 0)) {
+				hmm_vma_walk->last = addr;
+				pmd_migration_entry_wait(walk->mm, pmdp);
+				return -EBUSY;
+			}
+			for (i = 0; start < end; start += PAGE_SIZE, i++)
+				hmm_pfns_start[i] &= HMM_PFN_INOUT_FLAGS;
+		}
+
+		if (hmm_vma_walk->pmdlocked) {
+			spin_unlock(hmm_vma_walk->ptl);
+			hmm_vma_walk->pmdlocked = false;
 		}
-		return hmm_pfns_fill(start, end, range, 0);
+
+		return 0;
 	}
 
-	if (!pmd_present(pmd))
-		return hmm_vma_handle_absent_pmd(walk, start, end, hmm_pfns,
-						 pmd);
+	if (pmd_trans_huge(pmd) || !pmd_present(pmd)) {
+		if (!pmd_present(pmd)) {
+			r = hmm_vma_handle_absent_pmd(walk, start, end, hmm_pfns_start,
+						      pmd);
+			// If not migrating we are done
+			if (r || !minfo) {
+				if (hmm_vma_walk->pmdlocked) {
+					spin_unlock(hmm_vma_walk->ptl);
+					hmm_vma_walk->pmdlocked = false;
+				}
+				return r;
+			}
+		}
 
-	if (pmd_trans_huge(pmd)) {
-		/*
-		 * No need to take pmd_lock here, even if some other thread
-		 * is splitting the huge pmd we will get that event through
-		 * mmu_notifier callback.
-		 *
-		 * So just read pmd value and check again it's a transparent
-		 * huge or device mapping one and compute corresponding pfn
-		 * values.
-		 */
-		pmd = pmdp_get_lockless(pmdp);
-		if (!pmd_trans_huge(pmd))
-			goto again;
+		if (pmd_trans_huge(pmd)) {
+			/*
+			 * No need to take pmd_lock here if not migrating,
+			 * even if some other thread is splitting the huge
+			 * pmd we will get that event through mmu_notifier callback.
+			 *
+			 * So just read pmd value and check again it's a transparent
+			 * huge or device mapping one and compute corresponding pfn
+			 * values.
+			 */
+
+			if (!minfo) {
+				pmd = pmdp_get_lockless(pmdp);
+				if (!pmd_trans_huge(pmd))
+					goto again;
+			}
 
-		return hmm_vma_handle_pmd(walk, addr, end, hmm_pfns, pmd);
+			r = hmm_vma_handle_pmd(walk, start, end, hmm_pfns_start, pmd);
+
+			// If not migrating we are done
+			if (r || !minfo) {
+				if (hmm_vma_walk->pmdlocked) {
+					spin_unlock(hmm_vma_walk->ptl);
+					hmm_vma_walk->pmdlocked = false;
+				}
+				return r;
+			}
+		}
+
+		r = hmm_vma_handle_migrate_prepare_pmd(walk, pmdp, start, end, hmm_pfns_start);
+
+		if (hmm_vma_walk->pmdlocked) {
+			spin_unlock(hmm_vma_walk->ptl);
+			hmm_vma_walk->pmdlocked = false;
+		}
+
+		return r;
+	}
+
+	if (hmm_vma_walk->pmdlocked) {
+		spin_unlock(hmm_vma_walk->ptl);
+		hmm_vma_walk->pmdlocked = false;
 	}
 
 	/*
@@ -517,24 +712,64 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 	 * recover.
 	 */
 	if (pmd_bad(pmd)) {
-		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
+		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns_start, npages, 0))
 			return -EFAULT;
-		return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
+		return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
 	}
 
-	ptep = pte_offset_map(pmdp, addr);
-	if (!ptep)
+	if (minfo) {
+		ptep = pte_offset_map_lock(mm, pmdp, addr, &hmm_vma_walk->ptl);
+		if (ptep)
+			hmm_vma_walk->ptelocked = true;
+	} else {
+		ptep = pte_offset_map(pmdp, addr);
+	}
+	if (!ptep) {
+		addr = start;
 		goto again;
+	}
+
 	for (; addr < end; addr += PAGE_SIZE, ptep++, hmm_pfns++) {
-		int r;
 
 		r = hmm_vma_handle_pte(walk, addr, end, pmdp, ptep, hmm_pfns);
 		if (r) {
-			/* hmm_vma_handle_pte() did pte_unmap() */
+			/* hmm_vma_handle_pte() did pte_unmap() / pte_unmap_unlock */
+			if (unmapped)
+				flush_tlb_range(walk->vma, start, addr);
 			return r;
 		}
+
+		r = hmm_vma_handle_migrate_prepare(walk, pmdp, ptep, addr, hmm_pfns, &unmapped);
+		if (r == -EAGAIN) {
+			HMM_ASSERT_UNLOCKED(hmm_vma_walk);
+			if (unmapped) {
+				flush_tlb_range(walk->vma, start, addr);
+				unmapped = false;
+			}
+			goto again;
+		}
+		if (r) {
+			/* A non -EAGAIN error here means migrate_vma_split_folio()
+			 * already dropped the PTE lock and cleared ptelocked.
+			 */
+			HMM_ASSERT_UNLOCKED(hmm_vma_walk);
+			if (unmapped)
+				flush_tlb_range(walk->vma, start, addr);
+			hmm_pfns_fill(addr, end, hmm_vma_walk, HMM_PFN_ERROR);
+			return 0;
+		}
 	}
-	pte_unmap(ptep - 1);
+
+	if (unmapped)
+		flush_tlb_range(walk->vma, start, addr);
+
+	if (hmm_vma_walk->ptelocked) {
+		pte_unmap_unlock(ptep - 1, hmm_vma_walk->ptl);
+		hmm_vma_walk->ptelocked = false;
+	} else {
+		pte_unmap(ptep - 1);
+	}
+
 	return 0;
 }
 
@@ -682,7 +917,7 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
 				 (end - start) >> PAGE_SHIFT, 0))
 		return -EFAULT;
 
-	hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
+	hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
 
 	/* Skip this vma and continue processing the next vma. */
 	return 1;
@@ -798,9 +1033,9 @@ static int hmm_range_fault_locked(struct hmm_range *range, bool *locked)
 		if (ret == HMM_FAULT_PENDING) {
 			ret = hmm_do_fault(mm, &hmm_vma_walk);
 			if (ret == HMM_FAULT_UNLOCKED) {
-				if (fatal_signal_pending(current))
-					return -EINTR;
-				return -EBUSY;
+				ret = fatal_signal_pending(current) ? -EINTR :
+					-EBUSY;
+				break;
 			}
 		}
 		/*
-- 
2.55.0


