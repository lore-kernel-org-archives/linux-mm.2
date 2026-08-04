Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C794C55ABA
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 04:27:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E6956B00B7; Tue,  4 Aug 2026 00:27:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 690796B00C9; Tue,  4 Aug 2026 00:27:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A77F6B00CA; Tue,  4 Aug 2026 00:27:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 29D176B00C9
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:27:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AE831C08B7
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:27:30 +0000 (UTC)
X-FDA: 85062303060.20.1871570
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7688216000B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:27:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PMHqxnmn;
	spf=pass (imf08.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785817648;
	b=k3kHnKCT1GyTQXCDr8xjPDWtQZThNNsdG/njDq0ayWnnZMQPKdoc+JWSPFzHt2l0rc+lMz
	PDKBeTy1clzNSY9lKZfFDSIa2J3fjsCgtsNBa3Ej29obWulQ0kw1J+26uvbEaH7dMYkbet
	yocsMrNeTz+QD1+/5XzSFGtk4OBsJ3g=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PMHqxnmn;
	spf=pass (imf08.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785817648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p+Wrj+fEG23grALcs/D4e+T/chcmptdybXX8nN5bDvk=;
	b=0TnN3rGilSpO1QjZLwtGtIWgiDvFGnA1YCWcH+VTWqjz5qr7gjBleXUIG1l1PsRfzKgtCG
	Ah0boE5wJLkq36w08bvz2dF87QT8Z6D1g6a5vhgS+l57KgHb6oxjXnkkAFlKO52RR70gsX
	YbTU5zpq2ZRmcdIlQmTF2zZKz8ByVwE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785817647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p+Wrj+fEG23grALcs/D4e+T/chcmptdybXX8nN5bDvk=;
	b=PMHqxnmnaO0GZqN1I1AClAeIrRPY4UU+2HTIex7bGHXrhpkVDJY/bzlyCMt01eIKeVmOPY
	I2sgDZA1L6YaSTTbWUAAYZ/XByPrBBP5FCQHsn4UZUqiOUYsDvm4A2wwLvJa61zsxsIHjJ
	q9XmkGRZ34lAnNgWxmz38pIcBcOrNl0=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665-g8vkwBv1MTG3uXFXUx7Ovg-1; Tue, 04 Aug 2026 00:27:26 -0400
X-MC-Unique: g8vkwBv1MTG3uXFXUx7Ovg-1
X-Mimecast-MFC-AGG-ID: g8vkwBv1MTG3uXFXUx7Ovg_1785817645
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-39fb3a7fed6so486121fa.1
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 21:27:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785817645; x=1786422445;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p+Wrj+fEG23grALcs/D4e+T/chcmptdybXX8nN5bDvk=;
        b=n2a3LB0YWUVdK+8Izg1TpW5QiD5/iJHPKPJW9KfZ+VVZLzJnu6B2Yi/s+pqhQ5+B1k
         L+6CHSDbkbzPRo2oJbXfMcJjqLifP/Brpa+/jCSpS29EIrQYmVzkIyZVsRpgLgr5bsf6
         XYRHAcAkB5fmOJDCxcup37xosBQI8KZKQvfuXFNlnvnCuPJv00Zidea1tW2iW1mYy00e
         yC3pNbRa1UXaEz0GZg3iRJhYRk2wSKggVdNjhQlnyfN5oLxErMcjfyLuG8Q5CkKYp944
         5b63NNvXEDIxNWL44u+fLT8p0GuspnGNWPyB6p+FfkmPgh0zb9VgdG4JBpPrSyZ21QAR
         zqwA==
X-Gm-Message-State: AOJu0YzIfiFDxMxP1CDdWpXA8WKg65afyYNx+8gk7d49vSIMXpa7FE5y
	JJFW0H2CHREC/B/qpPbLDyoN8Z9quytfxLHDhjLwF9wgO+57zRdZ3RxyUi7jmRM4TvixQlQhnv1
	PNiDoYcq0I8XXpf2LX/ytqxVLMQYoCAVu+k3u+kmVptTnYE87k2ssjPXuTk+Mv8aLQIgNmQvi/F
	aql0huuEBF0dv/wo1u0rqBie2GcF3D3xk33NnraA==
X-Gm-Gg: AR+sD13wvldaVDlDryVVAJiakM9uV/KK4az9RwCVU2SWXAXZFhIYioutBzvOsHsKULT
	xJr7eePAImxN7N/Sdlykt7Z/7iJE31KOS9cyRhwdZZn/UzEXYTYw/K9pIEXSls6/NyBEeUHxUqt
	A1W46hvkUt6t0c1aP09rk2jd5wFW1LvHILd49271gcRjwkSG07kowgONIXreDqa7nEDSBk8UNkI
	pPJJLssjGUKW4AFO9tgsro9Eg1C5hOGuEdRWE/yyMAByyHC3rizvzscX4MajL/PkSFJrBDVMxwf
	CzcSoYWuRC1PbYnWxmVcJGrcsGBJap4K0Q4YIbXvq+Fhb6Ladve1G+kiqho/Hya65Yaqt0gzvzy
	mEXJWNledA4GvkqBx
X-Received: by 2002:a05:6512:400a:b0:5b2:aa73:ea5c with SMTP id 2adb3069b0e04-5b2f282e27cmr151477e87.20.1785817644659;
        Mon, 03 Aug 2026 21:27:24 -0700 (PDT)
X-Received: by 2002:a05:6512:400a:b0:5b2:aa73:ea5c with SMTP id 2adb3069b0e04-5b2f282e27cmr151455e87.20.1785817644120;
        Mon, 03 Aug 2026 21:27:24 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b2e23c46c4sm2311351e87.17.2026.08.03.21.27.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 21:27:22 -0700 (PDT)
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
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v13 07/11] mm/hmm: migrate collection in HMM pagewalk - pmd level
Date: Tue,  4 Aug 2026 07:26:27 +0300
Message-ID: <20260804042631.2175585-8-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260804042631.2175585-1-mpenttil@redhat.com>
References: <20260804042631.2175585-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 15h3DPnOsv4o1OITSAtXRFsQWPShdxS3Sj_Zg5Q_RW4_1785817645
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7688216000B
X-Stat-Signature: 64q7yuosxgq4yhx53b3ay3kdg3ay1snb
X-Rspam-User: 
X-HE-Tag: 1785817648-179659
X-HE-Meta: U2FsdGVkX1/ZsLG+0JrH/Cpkb+a0KXTPo/lWXZ3pLCnLAXQXSlhydAS4mEWEsU0ZuY62AUFg3Y1lb3ymNiTJCHJtC3xx+H/5/PC2j2SS5mBJqXKdMVax+mIiJfMvrNp0mHHZ+EtF9uQCZp0t+YEkG8Yl6qrXiGdyBHEjFG1eQHS6hLDprxYlPBKs5Cmx2XCSdbsWw14dG9JUOVgL80TtpSrrDIbGODnrIsSZZ87ennGpJPvTA3B6HGTP5HRpy157yb/66LZQiOsskbt+i89A8kkNMMOniTjvsPp2IIdrWNKssKfCIH0jZtcagapMAjmuf/pdVqyx67y0OLvqTQnTNsIfZZkh/WcGp/8nny1MgAP12rDe80JAPHhtVqvgdPIrdrf2AFCP/s8ProhnwVegVqVvC7nDMcqSCUUuVRK0jruZgXyKTjubhvb3tj1dRflDHK80vbyGYUFJj85rTpOFNPe2kWy4rTOoDM3t2VbMWRURWmeWUCO57pluDNrZAR8dgMBwQcbR2Lx6Fd11lzNtUNK6gOOv0pNBpwrhrwljTHXPlMw4YPV5SmYzOW0wfB1AghbyhbH8YeIch5Al3wTk1jNAX8dV+sKsYUU7vjtgHxppoDjikFN4FqSX3R3vp4osTgQwEgt2XTSg8Lm4Malzu9Zcojf1XMlU2MhQbqbbaaebgkPgcfg5Bqm8HKwmXY0dCgdAOBNlU6o3KsBnPQ5XdZ8hzLfK2Im5QmaOoc4fyJcwsECnw31I/TMQAx8uPbmrFGtHaXh6pIz79ryoFjVky+/EKnW0R5xjoJSCel7T+KJ3zDKijPVEtYycE7RfV8BLV/j4A2GF9kMk7RawaRk5C5HDZd2a1mM62yQHS4OMPP30J0dYwWvA+ktC30UIySANViXvp9/LdZ+jnM18w6fVC5hHKPcOgkD4VPuyAcgA7J7p8CBzisBPp/27YbzFRhOx3fySt+zAK+jW+Gi07Bb
 hADAEOpG
 +vhA6FdMExi6Uw6MiEe3tPNOWDkFkY2sZNIApH/PCcaBnzW1Aq6Hg8m82+j3P5GbgNRhURpEiaeECDzfdHkHcZYtNj/DcrZSgMt8IPd+IhpUa3nhGllCLT0HfesvpMb1v5j/36nMrV+lVezl+3f6WRAHfHz0fe0mw5E+7lRTKNd4hTnbyn5EFNJiTT/42zLTNKL9Diz9WcnRNOTIafysZttTsp+hqAXvFmT9ZjKnE0BYwCrY9B6/1AxUR9maJmo7RkEkz4VsnoaDojxiVJHuQ29v31HF1uZOswGgSy6idavZhpGcri8p74Og5glxQwTa7SgEmFSUyAQSMNfOs12Dk+k9kMKmIY6q64wK1KvYzWFPdxpvmiU3cwClWfpDjlB7Kr92Iv/Zthj3nDrziOtztiCljCmlitjiOifd6PjA6t1LJpDm1Ty0YkZFKeK/f7X2Xgw//jrCp12QiQNcUu83vulEFA+XGR08IPemI7JpVI0uUD0Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mika Penttilä <mpenttil@redhat.com>

Implement the needed hmm_vma_handle_migrate_prepare_pmd() function
which is mostly carried over from migrate_device.c's
migrate_vma_collect_huge_pmd() function.

With HMM pagewalk based migration, the idea is that
hmm_vma_handle_*() are responsible for faulting,
and the pfn collecting part. hmm_vma_handle_migrate_prepare*()
do the migration decisions (with HMM_PFN_MIGRATE), possibly split
folios, and insert migration ptes/pmds.

HMM pagewalk based migration is enabled in later commit, for now
now hmm_select_migrate() returns 0.

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
 mm/hmm.c | 96 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 94 insertions(+), 2 deletions(-)

diff --git a/mm/hmm.c b/mm/hmm.c
index 2d902b8bcd58..61b9147fd8ed 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -549,8 +549,100 @@ static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
 					      unsigned long end,
 					      unsigned long *hmm_pfn)
 {
-	// TODO: implement migration entry insertion
-	return 0;
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
+	if (!(hmm_pfn[0] & HMM_PFN_VALID))
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
+	if (folio != fault_folio && unlikely(!folio_trylock(folio))) {
+		folio_put(folio);
+		hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
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
+			r = -ENOENT;  // fallback
+			goto unlock_out;
+		}
+		for (i = 1, start += PAGE_SIZE; start < end; start += PAGE_SIZE, i++)
+			hmm_pfn[i] &= HMM_PFN_INOUT_FLAGS;
+
+	} else {
+		r = -ENOENT;  // fallback
+		goto unlock_out;
+	}
+
+out:
+	return r;
+
+unlock_out:
+	if (folio != fault_folio)
+		folio_unlock(folio);
+	folio_put(folio);
+	goto out;
 }
 
 /*
-- 
2.55.0


