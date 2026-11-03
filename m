Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41453606D80F
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 06:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Pg6ij7HY
Received: by kanga.kvack.org (Postfix)
	id 5AFB26B05BC; Tue,  3 Nov 2026 01:17:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 561566B05BD; Tue,  3 Nov 2026 01:17:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 450106B05BE; Tue,  3 Nov 2026 01:17:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B3AA6B05BC
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:17:19 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7B77A140380
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:17:18 +0000 (UTC)
X-FDA: 85392800556.14.723A7CB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 46793C0002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:17:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Pg6ij7HY;
	spf=pass (imf22.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793686636;
	b=qjIMuNd5X2TF6VB2OZA3Lf1fgB1QNxztgwjBbv7ka/gYP6YJI13DK+5OAqWjxYKKU9e4H9
	x7wCTIiW9zYFEhVaD4YkKliqK1Co+W5q+vyXZZfwodKIBc2zyLr6mjcHExIxj8Y3fAqV9v
	mIdOTx245GXULZZYWoZs54NW7jhxzWc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Pg6ij7HY;
	spf=pass (imf22.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793686636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jIc5h4IhkXIt4VgOmF6ym6QfRntQTchoUiwA4snRnC8=;
	b=6fZz+Eq9w2Nw4pHqc+MJ5OSQobVq9ObS99UBGcixQLScvcS4GkOQuYKNk1kOZB+sGgwafM
	govfPVe592SSzgb+PugaPUkiP99rNIB+LpOEDf9ru5HMsxpMzGxPpI2KuHfYqAwJWK5tec
	vbV8t32ez+kpnk3zF+X9Kwu9AWu08dY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793686635;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jIc5h4IhkXIt4VgOmF6ym6QfRntQTchoUiwA4snRnC8=;
	b=Pg6ij7HYY463mRWPI3Cplb4CP61HWYdl3QT62t/Fm5yEFtPXCUFOxiQgN93tazHqCCwUgx
	WYSvYBLP37SGr/lZvhV5nqXCR7PPKEOqLxw2rgPMMh1Ixu6iQqSdLXu3OYQyyG5NMm7Yj+
	yNynJp87EWNE54eREvzz5fBSUzwqEqk=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-690-WHuzYsoaMNCniz0av-qreg-1; Tue, 03 Nov 2026 01:17:14 -0500
X-MC-Unique: WHuzYsoaMNCniz0av-qreg-1
X-Mimecast-MFC-AGG-ID: WHuzYsoaMNCniz0av-qreg_1793686633
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-3ab345bb334so17424121fa.3
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 22:17:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793686633; x=1794291433;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jIc5h4IhkXIt4VgOmF6ym6QfRntQTchoUiwA4snRnC8=;
        b=V1Ae7qT1hqFUshHz8xebKkotiyVEI5GlnbeeSyLvS5hXxptVJFy9p8RWxr0dFylMG1
         QmbmOuY6D8wx0f0j54ZKHOSeCLVhS+vRj4tK+e2jc27Mu2xcQ/FDavOy3/QZYkGzo0Cc
         0Lu6WtfHxG10lBRCuj5TsRp5giOdvpLAVr9taBCCHs7WLTSYK5LemCzwBfMJfdPugxdS
         pV6eJhdxNIFCA4McZfzsg5HApYIdGR93Ng99CXwBzvvqiEAMQuywwjZ8QLX7TZB3T7zo
         //pO7+L3GcF2FaYsWKiw1lFCe7mnvyCp/l+pAtAMM9DHGEc/Vc+il90EPshqSI81Dn3P
         THhg==
X-Gm-Message-State: APuU4Z/gW4AHdEHj1kjuxRl1+Ds2dnjlO/aBEAwVD0zFAWXTpFvJgEH9
	j7I0+P0oKpd0KwQfr4CzYRkEj/fUJp6V6T3ZjI+BzTkyMm4LdV5ciOR9FkCpbTPN7AkxblImtm6
	GcwdfySPf8IvcXgMAhMRIUhOSQwFcX2OvKnUE+l6Xh9lsfabQ6RIZwUm7uAris9HxP4qUNA6lvm
	fVNjE9nCE3sOnqxNJDUj34YZbtAYFovKx7asY/mA==
X-Gm-Gg: AYBFou0x0grvwGSjs+GebtjDaMsdhB5b/YCzyRyeWF6wpclTP5c1ekHtYawRNhEZtRM
	XsKCZO399FNtQ7TmSa0l/YAhdbU92gzzTLh7fC/EPBs5UIx3nN7RSBnlqzHfPG0zlU1f0miUICn
	U7oSdZakObj4WZIungNrEzxaihDAU41ZjiADR0AGlzdEQoV07JwLoG7lOGhQTaYwBQvmHd7aGOS
	GRd7e4gJMZwoXnXV+iNEICGy1RGJnZwoIgQZJxljEkfrYkCaFXy3xN/YsGroQTFLtl76fKteedP
	r9c2Ae7+AT2JQLvcPDdoqjPP7maonWUsqo3JOcimLnvLAlUc0lKk54YAhpWuz8PpodpbV8Ki5+O
	F85O0VJg633PFreTk1cLM3H41IfOIWjgM+JjPykqd3t3tV+QFPDhKEBJBwu2cO2YQZxTz+A==
X-Received: by 2002:a05:6512:ac2:b0:5bf:e32c:51b with SMTP id 2adb3069b0e04-5bfe32c06cemr2651620e87.6.1793686633001;
        Mon, 02 Nov 2026 22:17:13 -0800 (PST)
X-Received: by 2002:a05:6512:ac2:b0:5bf:e32c:51b with SMTP id 2adb3069b0e04-5bfe32c06cemr2651592e87.6.1793686632449;
        Mon, 02 Nov 2026 22:17:12 -0800 (PST)
Received: from fedora (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bfe073e0f9sm1964634e87.54.2026.11.02.22.17.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 22:17:11 -0800 (PST)
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
Subject: [PATCH v17 08/12] mm/hmm: implement rollback for device page migration in HMM pagewalk
Date: Tue,  3 Nov 2026 08:16:25 +0200
Message-ID: <20261103061629.972669-9-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261103061629.972669-1-mpenttil@redhat.com>
References: <20261103061629.972669-1-mpenttil@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5yKWKcn6-EkLzmc8dm7gmJXE_gAoOxecjuGTnUNLPr0_1793686633
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 46793C0002
X-Stat-Signature: s1m6ss11zgnnnwqkownyuwriwzk71mjg
X-Rspam-User: 
X-HE-Tag: 1793686636-396719
X-HE-Meta: U2FsdGVkX1/d3QVTUcao7w5dlCztXmdTQz1P2jvuH93ZWsXfroUpX6m8UU7sYo4jPOH2htKVkLI1dp3z3qxFpvaBe4RM7+owgQcZQgMMV0CLls5qMFi+ADvXJsEjpSFp7nNh+/VL+D+Hfa2A7M7OQqierazkcgMq5dNs9b+zuwLSoZKEuPOsIuL9PZnZdH5JD40u9yC9SuGZTNvZIfqKWbkYNV9xtAKgBDXYnZ3KuP4j7YZDSn3uilaflnI5sj+EXaZkBtV9JtfATXhPgtYJIEPPuX5I2Zb7nG4pIsX1u8desfEf38mXo1yH6bJCxsb2fCBXEIi/Z4gR6fVr8vfnowKLz2MkBFMN/IlbVwHLsdWAB++EQm3gnfCph4r+OfhLIyw/wD6lpJjpviHkOuSjuxCklHv5UjIA3vPrTUn237hi0oNcQD4HANB8hcGnfyqHaqkh8H7jJLmrwarvAj5f9s308deYLOvodJLCyPUdNgfJ23RGMY+aIQQCNsJ/Vv0jFPVqo2NIoM0PTvXjnQKi6EMZlIHPwE7g07j3ZKL/3uGfB3O2XmZZsmsEk8tshRN+c/spjvs/8QgWmmthjrSLOBNU8Y/HYz9DQv5AKlh8oKRyDcdBNsOYPBSJjQtJiRt9XIUYKb7BQppeKKzIS7R/pY2wzas2YxPJqWhk4AYsAdDFVKNdLe+AEessk0Ib6xMGNBG5Fys0fi64rA1/vN6CgsPWYAzEftTCFS2lkhQtgH8ANC8D2iA+mbD6i2uniS3Xym6ytqUjsloesDVq0Uq79/GWu1lwoBF9bH5uXyWoqjytTH4wTdLt4+JxcMfXwM3BKxW+a1RTkbgL+0x5qfub5Hdb+OqUzEcgTTYlI7PU+BTZr2Yr0dU/gztW7n0OlthlVDsV1Ol2YEBcaJBuq4tOrHLsI3tbhsewHy02y/U7hadctgulxOaUh7wJBpsPMhaCD1wHIcq2dgJNvCMQpiw
 gAF2Tkbc
 MKNW6eHnYjf1LWRXfZNvL+ztHYuHTipmQzj1RP/hGGoYv3tE7CtN/vbvKg37kldkVK5S1MJNGij2nOi4sMTfHImpXcmh3qj4UZPI0mzRyyDbxT3HnPzT12BGidTwunUmozMWTZe34qbNQVZK62QWuac97MF6q+4n5CmW16Fr6OKDgf3PmlNYBT7cZUwymvjIsL50lLSyUxq11SoPHUzNiZKOCY6GIOCD3/ZDQf8JZt0TSOgN2y7UjazW35YRiR+sGfLxotbjNhkUC+egCAAeGlahjNk163fyKy7FKTYNHN1+6gpmeiklPPjnay4NwUhMMJNLhYKOPmFF5/RaIM+e4ovVemSC8B5m5z+RzI6q5jfpz3J9cfaxWkF/DroQFqTvKmDLMk6bCqUqGNMt4TbodPet/pW8Fqmwz5qCd
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
 include/linux/hmm.h |  22 ++++++++
 mm/hmm.c            | 127 +++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 148 insertions(+), 1 deletion(-)

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
index 690b73908f34..1c8a3fa29c4e 100644
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
@@ -239,6 +246,9 @@ static int hmm_vma_walk_hole(unsigned long addr, unsigned long end,
 			spin_unlock(hmm_vma_walk->ptl);
 			hmm_vma_walk->pmdlocked = false;
 		}
+		/* Entries collected from a vanished page table are gone */
+		hmm_vma_handle_migrate_prepare_rollback(hmm_vma_walk, addr, end,
+							hmm_pfns);
 		return hmm_record_fault(addr, end, required_fault, walk);
 	}
 	return hmm_pfns_fill(addr, end, hmm_vma_walk, 0);
@@ -274,6 +284,9 @@ static int hmm_vma_handle_pmd(struct mm_walk *walk, unsigned long addr,
 	cpu_flags = pmd_to_hmm_pfn_flags(range, pmd);
 	required_fault =
 		hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, cpu_flags);
+	/* Entries collected from a vanished page table are gone */
+	hmm_vma_handle_migrate_prepare_rollback(hmm_vma_walk, addr,
+						end, hmm_pfns);
 	if (required_fault) {
 		if (hmm_vma_walk->pmdlocked) {
 			spin_unlock(hmm_vma_walk->ptl);
@@ -331,6 +344,15 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 	if (!pte_present(pte)) {
 		const softleaf_t entry = softleaf_from_pte(pte);
 
+		/*
+		 * Our own migration entry, collected earlier in this walk:
+		 * keep the collected pfn, don't fault or roll it back.
+		 */
+		if (softleaf_is_migration(entry) && hmm_select_migrate(range) &&
+		    hmm_pfn_collected(*hmm_pfn) &&
+		    hmm_pfn_to_page(*hmm_pfn) == softleaf_to_page(entry))
+			return 0;
+
 		/*
 		 * Don't fault in device private pages owned by the caller,
 		 * just report the PFN.
@@ -416,6 +438,9 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 
 	new_pfn_flags = pte_pfn(pte) | cpu_flags;
 out:
+	hmm_vma_handle_migrate_prepare_rollback(hmm_vma_walk, addr,
+						addr + PAGE_SIZE,
+						hmm_pfn);
 	*hmm_pfn = (*hmm_pfn & HMM_PFN_INOUT_FLAGS) | new_pfn_flags;
 	return 0;
 
@@ -427,7 +452,19 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 	} else {
 		pte_unmap(ptep);
 	}
-	/* Fault any virtual address we were asked to fault */
+	/*
+	 * This pte needs a fault, so it is not our migration entry: a pfn
+	 * collected here earlier is gone, roll it back before faulting.
+	 */
+	hmm_vma_handle_migrate_prepare_rollback(hmm_vma_walk, addr,
+						addr + PAGE_SIZE, hmm_pfn);
+	/*
+	 * Fault any virtual address we were asked to fault. When migrating,
+	 * only this page: later ptes may be our own migration entries or
+	 * caller owned device private pages, which must not be faulted.
+	 */
+	if (hmm_select_migrate(range))
+		end = addr + PAGE_SIZE;
 	return hmm_record_fault(addr, end, required_fault, walk);
 }
 
@@ -454,6 +491,9 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 		if (softleaf_is_device_private_write(entry))
 			cpu_flags |= HMM_PFN_WRITE;
 
+		hmm_vma_handle_migrate_prepare_rollback(hmm_vma_walk,
+							start, end,
+							hmm_pfns);
 		/*
 		 * Fully populate the PFN list though subsequent PFNs could be
 		 * inferred, because drivers which are not yet aware of large
@@ -475,6 +515,10 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 				spin_unlock(hmm_vma_walk->ptl);
 				hmm_vma_walk->pmdlocked = false;
 			}
+			/* Entries collected from a vanished page table are gone */
+			hmm_vma_handle_migrate_prepare_rollback(hmm_vma_walk,
+								addr, end,
+								hmm_pfns);
 			return hmm_record_fault(addr, end, required_fault, walk);
 		}
 		else
@@ -561,6 +605,51 @@ static int migrate_vma_split_folio(struct folio *folio,
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
@@ -731,6 +820,11 @@ static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
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
@@ -783,6 +877,10 @@ static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
 		pfn = pte_pfn(pte);
 		if (is_zero_pfn(pfn) &&
 		    (minfo & MIGRATE_VMA_SELECT_SYSTEM)) {
+			hmm_vma_handle_migrate_prepare_rollback(hmm_vma_walk,
+								addr,
+								addr + PAGE_SIZE,
+								hmm_pfn);
 			/* Like pte_none(): only anonymous memory can be populated */
 			if (!vma_is_anonymous(walk->vma))
 				goto out;
@@ -929,6 +1027,13 @@ static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
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
@@ -1068,6 +1173,16 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 			hmm_vma_walk->pmdlocked = false;
 		}
 
+		/* Our own migration entry, collected earlier in this walk */
+		if (minfo && hmm_pfn_collected(hmm_pfns_start[0]) &&
+		    hmm_pfn_to_page(hmm_pfns_start[0]) ==
+		    softleaf_to_page(softleaf_from_pmd(pmd)))
+			return 0;
+
+		/* Not ours: entries collected from a vanished page table are gone */
+		hmm_vma_handle_migrate_prepare_rollback(hmm_vma_walk, start, end,
+							hmm_pfns_start);
+
 		if (required_fault) {
 			/*
 			 * Someone else's migration: when migrating, wait in
@@ -1171,6 +1286,10 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 		ptep = pte_offset_map(pmdp, addr);
 	}
 	if (!ptep) {
+		/*
+		 * The pte table is gone: re-walk from start, entries collected
+		 * from the old table are rolled back as they are revisited.
+		 */
 		addr = start;
 		goto again;
 	}
@@ -1192,6 +1311,12 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 				flush_tlb_range(walk->vma, start, addr);
 				unmapped = false;
 			}
+			/*
+			 * The pte lock was dropped and the pte table may have
+			 * changed: re-walk from start. Our own migration entries
+			 * are kept, anything else collected is rolled back.
+			 */
+			addr = start;
 			goto again;
 		}
 		if (r) {
-- 
2.55.0


