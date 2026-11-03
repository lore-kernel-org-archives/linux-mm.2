Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3962606A33C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 06:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=SIRP9pnP
Received: by kanga.kvack.org (Postfix)
	id 737156B05B7; Tue,  3 Nov 2026 01:17:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 711B76B05B8; Tue,  3 Nov 2026 01:17:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FD7A6B05B9; Tue,  3 Nov 2026 01:17:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 394636B05B7
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:17:06 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B183C1A04D8
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:17:05 +0000 (UTC)
X-FDA: 85392800010.21.7BD8FB3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf31.hostedemail.com (Postfix) with ESMTP id A629720002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:17:04 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SIRP9pnP;
	spf=pass (imf31.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793686623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xPj1CmnBZuUKYsibDOO8F9tznIiNHrfeip0Ruho/ab0=;
	b=TtHf4635AQHUKZQy7dkOD9OE5aVqRqr6o0aI3l2duOTEW/4M5WHbzbNFFtDl3QPgHKJ1zn
	SRqaBQfdc+j3R9g+HdxEM+URHm8xMsIAOJmjx5RA/TOGnz+RGg6y8udNP0B+jStsQvg1BW
	DEFb6fxS+JS92ujiyoWpmHFxy2e93j4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793686623;
	b=NpI+ePciTOkpiEnj7CWLJDSwQCfKN6xln8XTTyXATx4ulrZEeH4UTExfQXPWSpogPdIh06
	jcnr/JfP5aQTuiMkOB/6QAFGVxBQqsynOEVU3MDwFnN48uNjLYaYlsghn3cEIlK9Dtbsyc
	Snpurf+l5rH6zjQDCl71z6xfbNlJKAM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SIRP9pnP;
	spf=pass (imf31.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793686623;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xPj1CmnBZuUKYsibDOO8F9tznIiNHrfeip0Ruho/ab0=;
	b=SIRP9pnP8oXaZmOGZi9ZPyfHqatAOwCUGvqP78lPxNKgIbm13jXJXsH6GZKmRN+4KMY0MP
	43eYd0A4/uBZzTvCnrrkubCTHcyvLGDrdMXClH45W3bAQyuB87SSYe7oV4ApQCqyLMFMru
	JrmnxADCTRGUG8/lhx0Q7eBq3zwWPBc=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-576-_SWwvA7QOiS9svEUwDI1OA-1; Tue, 03 Nov 2026 01:17:01 -0500
X-MC-Unique: _SWwvA7QOiS9svEUwDI1OA-1
X-Mimecast-MFC-AGG-ID: _SWwvA7QOiS9svEUwDI1OA_1793686620
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5bccb762619so1432347e87.2
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 22:17:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793686620; x=1794291420;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xPj1CmnBZuUKYsibDOO8F9tznIiNHrfeip0Ruho/ab0=;
        b=KxATvL58DSdozLPuLr/HI68ykXmATfxC4uR8mO87XZjZjYcvgEOlUTk3CrZn7qeP4l
         RKjheDAALr6q2meO3OQm0vyQD45qCiGy7wUGmDtnCR9DBXvjVPXeeC8SPpJfUW26V80a
         wqOoVd5ysimt/7+Gw2gpBQCaRhqu5skSd4GHCRPX+Y8IY+c/bBFzWj3mTmp9PRbtbg5O
         GIBuOA6s2o3rz+nWOKOCoqi45rGYkpOIHB6e51+GvSqvl4376fQlkp9IgG9AS2BIyeXi
         ykUzKfuTtyuCPFEuuWuLlJgayBDsQS90eG2sy1miTR96fZ2kJ5BzWKUMlL8ZtI/CiTNS
         kSGg==
X-Gm-Message-State: APuU4Z+rFDZOS2HI/V0opninNTHcW4tF/uVwYRTAE8eA9dZst8S5i2G+
	U69YAT+pChGj1Gh/yCk3Tt+Ma6q0RLVJrb6I3a3M9eYMCKBeDTO6l95gpaRYta/LFjZsDpSbHDK
	8dRdib8DTZb+21gjdTJidBjCImjwjycJSiZM8ywOGiPzr38yRJw4mHrdA1VTqMVB+1ohzy+yzd9
	DkNLT8oJSVc+113SS3LbRp1SAsO7kIteO2mE9qxw==
X-Gm-Gg: AYBFou3Z41cVglbO3eKiBPJU9FiYxw5ZjsYVKHMUqVejK94c/nF0WhfDDk46IDkaOdt
	OHMHhdao8OBZWMdim/vV3qR1SCM2nvNaW7abo+EGeV3qyCJRIWGrO/Iebj5XgUZ7EzaDoRyywvo
	lZAjmNZE2M9n/qA/bZIJLN+0RkitbA3O2eskLXY0Z7c1TkbORxNPnh+l7MiOUQTwt7wD54grYrd
	nxVHjSlljjDTTNE7e1tBktPUdEkvWks/zl89cmC4bhWZNcBEaBFa+eGeE60w2elZMSoC61EDgnW
	H4lWuptP9XZKCdLtxFF+7FnOh2XUBYsD1uizuiwoC6/vYghL4ZMcywAp18NLFH5e6TMNtm0/xgy
	4UhNP7pwtEK+mczydSOlQ7yiGR76Mt0aVbkgTYcnre5opIX4nF0rP+R31pyBm0n2LciFN4g==
X-Received: by 2002:a05:6512:3b0e:b0:5bf:ce41:8a61 with SMTP id 2adb3069b0e04-5bfd95662a4mr3992338e87.26.1793686620238;
        Mon, 02 Nov 2026 22:17:00 -0800 (PST)
X-Received: by 2002:a05:6512:3b0e:b0:5bf:ce41:8a61 with SMTP id 2adb3069b0e04-5bfd95662a4mr3992310e87.26.1793686619684;
        Mon, 02 Nov 2026 22:16:59 -0800 (PST)
Received: from fedora (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bfe073e0f9sm1964634e87.54.2026.11.02.22.16.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 22:16:58 -0800 (PST)
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
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH v17 06/12] mm/hmm: migrate collection in HMM pagewalk - pmd level
Date: Tue,  3 Nov 2026 08:16:23 +0200
Message-ID: <20261103061629.972669-7-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261103061629.972669-1-mpenttil@redhat.com>
References: <20261103061629.972669-1-mpenttil@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Xhi0aTPVMSfd2T6PvLuCrZoxNyvrz2_e8mEjBMbgWYo_1793686620
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A629720002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: q447pcrupcokjsc95smk7c94zmmixgae
X-Rspam-User: 
X-HE-Tag: 1793686624-953373
X-HE-Meta: U2FsdGVkX18OR9no7AmzAnqs7Fw4OzHSDJE6UpUdB1BdptW+Ky2OyNuAaXY3vKufo7s2zFNtf1gT2HXqUmSWeGyVE1ux1+l9dlKAITlQgRDcHFOwqb+S3BOmyTdF/JiQLh115Jmfa76bTo8JAHJvs7CMQFLdPiNOb6m2nswe+/rzTZ6VCVO8tLVgeRVx/VD5KmYtmOoJtH6FTx5rwqmOTG1/reVoKSvJrseL6JUurTpo29pz7PsbJDZl+YCdR8qLeKLoVfMhhBJTcgWB7fDzr13xdvpO3dHNvWmZMPXZJ9QutVhs0CVzfZfb2vfedrG7qLWXcKkPuSgqv7tOvF+dAo/UPL++rfNN0B+OByixzilMvBAMH8Nvi+AosKv3OIdtttP+jG2wwuMt0ptm9rAFMi+2mBRs/skAaQCejjEtSkhccXRFmN+4ma7wTjbpc2zXkIzjN0/PodIHMv/gaCVrL7EJ8pdywq5ES8Sq9Wb6hZEbG7g6sSItkhM8r5PwmQUo/CTQmlY2LQcsnm/725Yoh3b6JZf3CCBw+FVSyeWcxdCBbF3e2N39dfOBQoYy0PkyDIwMz+JG9vP10VQ6K2k+JozxADuEipNMQaKqJ6pYiU5p7yShF7rRz2kWlKurQVbhql9JS7w4SbjTU01qd0Wh0hjSVZcuac931Pqo8901o3XkDIqKaRR9ZrBj4bphPfck2jeh1MUzs3FwzNc9P6RL/d1MecsBiUSggtyR+YFuCLX8TmX4zzb0z4L8JQ5n88/TQb+8ITHLcRcORx6p4HrKlapmQn+heaelj9xxHJTwFiJ76o5kC72ZZnWWylnUiDj3w2amcoVcAyn/RbEZLeJ+ZXTGk2/lmfCmvQXryK0kzmytVWXLqAabafQHxATen4OlmNR+1jTxmTdtBRnCRDyFLrvIEnBQH+dwThIlloq3z7viMw06YRM9azHbbk2VoUNWfmaYfIhGaKj9VDZr/Eu
 7Xvz+7wN
 Qs2jjTfOjJoNvagkPW7kL6CN2/EAJE1MqMIvroKrZmgnFAaACskBhZSyGWUGyordvSxcm4r/chp/xDtNeYmlZb7RpwaUhsbD5HqxdqUHbE89UFTLqRbVlHETCdr0R3YA9Ur/dPgkLBCbROib4FOrGEj6zTi5CfWCnvIC1M/x7ddnBwVu0ei04STWgYbu/fpS4QbJXGyntphjSnxSPWSqc11+Y1/Szu3vDOLaleMnfUqe+JRRN9VxKLsC3AjPAFgHkvf8CBBXVJ0TkPqDg+DvkyPPhYDaBZwSSU0BNfuo6izpLHWzwD6ynIe9PwU/f7W51FGMQMcQrypvsE+ac9SjK4W1qudTawsXl7+HwPwJQiJ5ijiISHaBYSnYkCpyHZ2DLa3O+guvKoCLjIwPyQ8LQIcjb3MBwNvpsPwVh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mika Penttilä <mpenttil@redhat.com>

Implement the needed hmm_vma_handle_migrate_prepare_pmd() function
which is mostly carried over from migrate_device.c's
migrate_vma_collect_huge_pmd() function.

With HMM pagewalk based migration, the idea is that
hmm_vma_handle_*() are responsible for faulting, and the pfn
collecting part. hmm_vma_handle_migrate_prepare*() do the
migration decisions (with HMM_PFN_MIGRATE), possibly split
folios, and insert migration ptes/pmds.

Locking follows the same rules as at the pte level (see the previous
commit): the folio is only trylocked, a PMD-mapped THP is collected
whole behind its pmd migration entry (its only mapping in the vma), and
a swapcache folio still referenced by other swap entries is not
collected. On a trylock or split failure the valid pfns are kept and
nothing is migrated.

HMM pagewalk based migration is enabled in later commit, for now
hmm_select_migrate() returns 0.

Also avoid the problems present in the migrate_vma_collect_huge_pmd()
split fallback path this HMM path supersedes:

      - extra refcount for fault_folio makes split_folio() fail
      - wrong folio unlocked after split_folio()

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
 mm/hmm.c | 183 +++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 152 insertions(+), 31 deletions(-)

diff --git a/mm/hmm.c b/mm/hmm.c
index ec9280ef2682..cbde004fd778 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -496,7 +496,33 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 
 #ifdef CONFIG_DEVICE_MIGRATION
 /**
- * migrate_vma_split_folio() - Helper function to split a THP folio
+ * __migrate_vma_split_folio() - split a locked folio for migration
+ * @folio: the folio to split, locked and referenced by the caller
+ * @fault_page: fault page if any
+ *
+ * The fault folio is split at @fault_page, so the caller's lock and reference
+ * stay on the folio containing @fault_page. For any other folio our lock and
+ * reference are dropped, whether or not the split succeeds.
+ *
+ * Returns 0 on success.
+ */
+static int __migrate_vma_split_folio(struct folio *folio,
+				     struct page *fault_page)
+{
+	int ret;
+
+	if (fault_page && folio == page_folio(fault_page))
+		return split_huge_page(fault_page);
+
+	/* Someone else may have split it while we waited for the lock */
+	ret = folio_test_large(folio) ? split_folio(folio) : 0;
+	folio_unlock(folio);
+	folio_put(folio);
+	return ret;
+}
+
+/**
+ * migrate_vma_split_folio() - drop the pte lock and split a THP folio
  * @folio: the folio to split
  * @fault_page: struct page associated with the fault if any
  * @hmm_vma_walk: walk in progress
@@ -511,9 +537,7 @@ static int migrate_vma_split_folio(struct folio *folio,
 				   struct hmm_vma_walk *hmm_vma_walk,
 				   pte_t *ptep)
 {
-	int ret;
 	struct folio *fault_folio = fault_page ? page_folio(fault_page) : NULL;
-	struct folio *new_fault_folio = NULL;
 
 	/*
 	 * Take the reference while still holding the PTE lock, so the folio
@@ -530,44 +554,136 @@ static int migrate_vma_split_folio(struct folio *folio,
 	if (folio != fault_folio)
 		folio_lock(folio);
 
-	ret = split_folio(folio);
-	if (ret) {
-		if (folio != fault_folio) {
+	return __migrate_vma_split_folio(folio, fault_page);
+}
+
+static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
+					      pmd_t *pmdp,
+					      unsigned long start,
+					      unsigned long end,
+					      unsigned long *hmm_pfn)
+{
+	struct hmm_vma_walk *hmm_vma_walk = walk->private;
+	struct hmm_range *range = hmm_vma_walk->range;
+	struct migrate_vma *migrate = range->migrate;
+	struct folio *fault_folio = NULL;
+	enum migrate_vma_info minfo;
+	struct folio *folio;
+	unsigned long i;
+	int r = 0;
+
+	// Do we want to migrate at all?
+	minfo = hmm_select_migrate(range);
+	if (!minfo)
+		return r;
+
+	WARN_ON_ONCE(!migrate);
+	HMM_ASSERT_PMD_LOCKED(hmm_vma_walk, true);
+
+	fault_folio = migrate->fault_page ?
+		page_folio(migrate->fault_page) : NULL;
+
+	if (pmd_none(*pmdp))
+		return hmm_pfns_fill(start, end, hmm_vma_walk, 0);
+
+	/* Like at the pte level, NUMA hinting (protnone) pmds are migrated */
+	if (!(hmm_pfn[0] & HMM_PFN_VALID) &&
+	    !(pmd_trans_huge(*pmdp) && pmd_protnone(*pmdp)))
+		goto out;
+
+	if (pmd_trans_huge(*pmdp)) {
+		if (!(minfo & MIGRATE_VMA_SELECT_SYSTEM))
+			goto out;
+
+		folio = pmd_folio(*pmdp);
+		if (is_huge_zero_folio(folio))
+			return hmm_pfns_fill(start, end, hmm_vma_walk, 0);
+
+	} else if (!pmd_present(*pmdp)) {
+		const softleaf_t entry = softleaf_from_pmd(*pmdp);
+
+		if (!softleaf_is_device_private(entry))
+			goto out;
+
+		if (!(minfo & MIGRATE_VMA_SELECT_DEVICE_PRIVATE))
+			goto out;
+
+		folio = softleaf_to_folio(entry);
+		if (folio->pgmap->owner != migrate->pgmap_owner)
+			goto out;
+	} else {
+		hmm_vma_walk->last = start;
+		return -EBUSY;
+	}
+
+	folio_get(folio);
+
+	/* Can't lock it: not migrated, the valid pfns stay as reported */
+	if (folio != fault_folio && unlikely(!folio_trylock(folio))) {
+		folio_put(folio);
+		return 0;
+	}
+
+	/* Swapcache folio still referenced elsewhere: see the pte level */
+	if (folio_test_swapcache(folio) && !folio_free_swap(folio)) {
+		if (folio != fault_folio)
 			folio_unlock(folio);
-			folio_put(folio);
+		folio_put(folio);
+		return 0;
+	}
+
+	if (thp_migration_supported() &&
+	    (migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
+	    (IS_ALIGNED(start, HPAGE_PMD_SIZE) &&
+	     IS_ALIGNED(end, HPAGE_PMD_SIZE))) {
+		struct page_vma_mapped_walk pvmw = {
+			.ptl = hmm_vma_walk->ptl,
+			.address = start,
+			.pmd = pmdp,
+			.vma = walk->vma,
+		};
+
+		hmm_pfn[0] |= HMM_PFN_MIGRATE | HMM_PFN_COMPOUND;
+
+		r = set_pmd_migration_entry(&pvmw, folio_page(folio, 0));
+		if (r) {
+			hmm_pfn[0] &= ~(HMM_PFN_MIGRATE | HMM_PFN_COMPOUND);
+			goto split;	/* fall back to splitting the pmd */
 		}
-		return ret;
+		/* Collected; a protnone pmd was not reported valid before */
+		hmm_pfn[0] |= HMM_PFN_VALID;
+		for (i = 1, start += PAGE_SIZE; start < end; start += PAGE_SIZE, i++)
+			hmm_pfn[i] &= HMM_PFN_INOUT_FLAGS;
+
+	} else {
+		goto split;		/* fall back to splitting the pmd */
 	}
 
-	new_fault_folio = fault_page ? page_folio(fault_page) : NULL;
+out:
+	return r;
+
+split:
+	spin_unlock(hmm_vma_walk->ptl);
+	hmm_vma_walk->pmdlocked = false;
 
 	/*
-	 * Ensure the lock is held on the correct
-	 * folio after the split
+	 * folio_get() above took an extra reference. For the fault folio the
+	 * caller still holds a reference and the lock, which is the
+	 * precondition of __migrate_vma_split_folio(), so drop the extra one.
 	 */
-	if (!new_fault_folio) {
-		folio_unlock(folio);
+	if (folio == fault_folio)
 		folio_put(folio);
-	} else if (folio != new_fault_folio) {
-		if (new_fault_folio != fault_folio) {
-			folio_get(new_fault_folio);
-			folio_lock(new_fault_folio);
-		}
-		folio_unlock(folio);
-		folio_put(folio);
-	}
 
-	return 0;
-}
+	/* Split failed: not migrated, the valid pfns stay as reported */
+	if (__migrate_vma_split_folio(folio, migrate->fault_page))
+		return 0;
 
-static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
-					      pmd_t *pmdp,
-					      unsigned long start,
-					      unsigned long end,
-					      unsigned long *hmm_pfn)
-{
-	// TODO: implement migration entry insertion
-	return 0;
+	/* Re-walked as PTEs from start: drop the pmd-level output */
+	for (i = 0; i < (end - start) >> PAGE_SHIFT; i++)
+		hmm_pfn[i] &= HMM_PFN_INOUT_FLAGS;
+
+	hmm_vma_walk->last = start;
+	return -EBUSY;
 }
 
 /*
@@ -1016,6 +1132,11 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 			hmm_vma_walk->pmdlocked = false;
 		}
 
+		/*
+		 * hmm_vma_handle_migrate_prepare_pmd() splits the huge pmd in
+		 * place when needed and returns -EBUSY to re-walk the range as
+		 * PTEs.
+		 */
 		return r;
 	}
 
-- 
2.55.0


