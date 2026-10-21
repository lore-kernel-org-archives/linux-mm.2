Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19D1D606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 06:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=PyJapNZz
Received: by kanga.kvack.org (Postfix)
	id 4031B6B061F; Wed, 21 Oct 2026 02:06:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B3EA6B0621; Wed, 21 Oct 2026 02:06:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 262256B061F; Wed, 21 Oct 2026 02:06:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E6D626B061F
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:05:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 828D240485
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:05:59 +0000 (UTC)
X-FDA: 85345597638.09.5CB03D0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5953F180006
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:05:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PyJapNZz;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792562757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D1lQTE0fwMELWdutb8hdL1BhFjvM/63aN2UScfUYAXM=;
	b=4rIPBC8l7OpXKp5qksgJ7IZB+e8xDphaCHZ9JGmKmEKoI80nKL0NYCJ83d2HqKU5UfQJj6
	HlR5e0FTopStbdXePm5NN55lZTvK2QdSpkgr3pxlELqc7mAxbS9j81VD+HOg5bhcHOQrol
	cugMO8EB6rfG2WqrS9erKNhgvJ804OY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PyJapNZz;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792562757;
	b=z/Tajla/8iE5nlv6Wbkdtj+XDVY7phuPZvuKOMyHNj/g08GNKpL3Ze4gzG9QEmgzBliLa2
	n9zP+CSkTWXDjqMCkQMNY/Mqet5RfZ4DbeV8Ii2xhooaulasqZjopCmK7JzHYns1X4yFQI
	ZtFnZ0gHrYOKoKIkEzkWb7Ck3W+wlqU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792562756;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D1lQTE0fwMELWdutb8hdL1BhFjvM/63aN2UScfUYAXM=;
	b=PyJapNZzdxFONYGMIbNmAc2EQtghvreD3iX8hMTAy0A/mwdMa8FcxqHT1Xb7S+gf62s9Q2
	UtnA092brPp1suvRYJdehmV6gwwvkODaKa5n04oy/sRfmiZFqJa5oNEmzUV66An8QqEZsh
	uq/2svyzdaw9CEOkeexZJdvhmzK1LZY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-574-c3Zm93N9PEGyiqs-E6uK6w-1; Wed, 21 Oct 2026 06:05:53 +0000
X-MC-Unique: c3Zm93N9PEGyiqs-E6uK6w-1
X-Mimecast-MFC-AGG-ID: c3Zm93N9PEGyiqs-E6uK6w_1792562752
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a1e6ae710bso2089095e9.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 23:05:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792562752; x=1793167552;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=D1lQTE0fwMELWdutb8hdL1BhFjvM/63aN2UScfUYAXM=;
        b=KUHhWWTZtF2QoGZRovFngpcUzieIZlGiivue6p9vUeyt/oUudLLqPwNlGHdERE3gBc
         3Utdi+eJHqcHCGjlJnA5OCUYdRKhzX+oRAxHVA0+TJ/vcAWOKdG2+BmK3tOJOOEZIPuS
         PpQkCOkvZomRF6jAzOjO2jle8ImgXnoI0pUe4d0kAFa++ekPEn6mk58gUBOGmhUrZxUj
         sCvlx8cjmHuoBSJhCRGvLvszk+atgTRuQuQ7o47HNZHHWjOHiMW9upntnPyRiE60btvW
         dhMjdiCRD1jBUH52F2D5y5flE6sXEXrL/i/1iyQj1Vn3/XL8wZIoyK43VMU56MIOnVog
         6Ymg==
X-Gm-Message-State: AFq9FYLaNJ43PIGEz97mABa3yOc+3ExQ4mNE40zllIwWjul5Pk0qorQl
	DHnjXWcr+TvdCMcSoksXoiAfDMpZk84nLTDRXuHtj34lXbMYOMMJSl+v8xTi6j+ITJ8dA/dWzuY
	bPbdGbCbISv9AxDEgr6C2CNXEiEynej5dYuIhqWc0ceYSy8JbdFAMrMm8dZV/xSuko9QNXVgVcC
	5HVwh1+5mPduW4HIfx44newSbrQFU57mr3gURxiA==
X-Gm-Gg: AYBFou2x/O8gR/cTQBwWAfIz9C2dFUz6pnKnLXSjKr1pOncGJuzoX2p0dUgq9xQ+Cvn
	qAk+TLhOL8I6uc/Luks5eU3sSRgtC3nxz4Hc7bgBaNjS1CO9xyc1ZtVyBMyvnNv08PPTIIdPEpS
	+Qzh/BhOX7PntuhPfySEtzE1XJxLit2zggVVoeaTntwuA4JStg7CBqhIHEQmCx1HNXsJ/YMY5qk
	Mo8KLFaeAhKOJIYiR/ma7qfmyUW/YV/IjnNlYrcuz/wVwv5a07lR6BF4k96oCgJ7d85+oUgsgnY
	pAYWIAHgNTuAIKxIZjgeSeg6m6tO1Locb8cWP1R3fWsej4eQP2w+wSzJk7Xqh3yU5tJRy2vmpwF
	A1qBV0PW3uEBuAz0sTUQ/xd4JEheYXhSc169P
X-Received: by 2002:a05:600c:1c0c:b0:4a1:702f:c736 with SMTP id 5b1f17b1804b1-4a1fd8a4177mr20647965e9.3.1792562752125;
        Tue, 20 Oct 2026 23:05:52 -0700 (PDT)
X-Received: by 2002:a05:600c:1c0c:b0:4a1:702f:c736 with SMTP id 5b1f17b1804b1-4a1fd8a4177mr20647135e9.3.1792562751539;
        Tue, 20 Oct 2026 23:05:51 -0700 (PDT)
Received: from fedora.redhat.corp (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e254f02f1sm3413741f8f.3.2026.10.20.23.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 23:05:49 -0700 (PDT)
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
Subject: [PATCH v16 09/12] mm: enable device page migration from HMM pagewalk
Date: Wed, 21 Oct 2026 09:05:03 +0300
Message-ID: <20261021060506.2377545-10-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261021060506.2377545-1-mpenttil@redhat.com>
References: <20261021060506.2377545-1-mpenttil@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dgDREQigjLcVtUGvde3Ic8fmVz2n2EsHQYCaxFZ3aaQ_1792562752
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5953F180006
X-Stat-Signature: fjgd4y3ewu1cgwzkd1jr5y6nemqkc777
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792562757-113128
X-HE-Meta: U2FsdGVkX1/EtxEgdnptK+zmIywWWg3lfEPC9lcg3gbmFOroqgDGHIhcWC4N8VgcihTB3fvw5duJcmHWUxoTTM/8pDDis0FFjzKeNey8pvfySEDRNaV1PLjyUTXEEz0yukgjP0atG9uE5mF74fvy2kpQLsaGaE5SelhlQ4ry5TvxWB9/7qg7A9nYjdEYdWbS+26VjtqtyGn5r0/vRBQ/pSbScMc5KRdW7P647pTKx2glWDJoV9OKlGK36JCor3+esiM2RJnkwE6VVDKd75oR+TH5tbFGVH9OiHQve/w8BkueNJIK8y5l+eeZWST3kkR+l716/op0cQbPEX41OxKeQTGsuuMKonHTXohJtzXWAOEQ20XzjsprilU4jcQico4p/Fc9buFyDjpy7DCEhOfverALdEflq62d98z2Sq63mgjIyBw5M5ho91Mc5umBNonTO05ZE5gyJMjo4v+p18TcKFz8vD0Nrb9GKO6cD+/mHGz3Dty5aotfbVmeNLHzPQDlm7/pegT+mEy/J4RwebnVd+QxLG/tAC/aAFLwyC+FqaZotoeBijksB10Uwt5acpTi5HzixlTPZtaj6Y2NxdK/+AZe3n2+gGeDHnN8FpMFmD7fUBDERFqp1/hFk48gQNz2XK2ir5HDYtoSoFUExyL0P1aa2k71NesFegiqVlAvejqwkWQtpuJHdOh9Xurc3L4fBOLVNblbYSvG7vGGQFdDujUjXoYTUj+aQ+9vx4of4LtA+cLCmObOLixyIZHqZ+INFYCnKjLgU1M6VMMNCufAus7hnZE+IIyyNVj9Fd/m8OXBvKI9kkXe8ALbKbFnKXZ1qcXJcn8it0yb73CQc6cfCExElt6Tsj03WtjxA7dK1GSrHpxhCAXYPKSfkdGPNy5NmrRaT3/kbeNDwm2IJSCQZy5/cVA+D7LG/fUe3N1j6nUS0NTiadc8mGv7u983uUy+RMlKIFUlYlkF9MIz8PE
 Krb8qX9I
 IF0M3eguiEoGheu5BQE+L6OErwIt1TdzK5JkP0Lg7QQeniRqfkbwJRbcHQkacREjCoJpraq3ORODpYRVZMRpzRlz9bM5eEzA0luEw91pJs0N9afBRrBxX9PrQalQ6ihoWYMT0e2pQR7sifmQvhnFc+zwOosydsw+hMZVfvI/m32ZvAWdqzZFTR8qNxdVTbzuOYXwiKF6WNsvPXLnxqiAy03vTkAocOLkNdhfncjQ68S4AK7pjHZzLqfQx9IeWv0MUvdmhgjtQJAQJxVyR2TSPeLzaeHV2l5Sdx8csVshRKBlb0nKt50TVzGYgbIj0ad6fGeTeoLC4HuSVnv5fIBJSsH/W4RQ6Hh9jbX07WaLN2+SZeHQpK0PKnsnj+AySsUBLSvK5D8N6Qm2PxPBnzIfrSNUUsq20ujhdR83wS6AVEYLyJaCwnsFEPkzNpUX0rS+x+jeF9BuyyQhOdK+sXqDqEzIfYrCTrbHkAL7l4PuXUhdgbRYfzhg4lA8PJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mika Penttilä <mpenttil@redhat.com>

HMM pagewalk has now the machinery to do the first phase of
device page migration, collecting the pfns and installing
migration ptes.

Enable migration in hmm_range_fault(), and change migrate_vma_setup()
to use HMM pagewalk path. Two new flags, MIGRATE_VMA_FAULT and
MIGRATE_VMA_WRITE are introduced for migrate_vma_setup(),
to request for faulting missing pages, and requesting write
access.

Also, the migrate_vma_collect*() based paths are now unused,
so delete them.

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
 include/linux/migrate.h |  10 +-
 mm/hmm.c                |  33 ++-
 mm/migrate_device.c     | 562 ++++------------------------------------
 3 files changed, 83 insertions(+), 522 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index dd7dd7ec6995..3780c4c116b8 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -181,6 +181,8 @@ enum migrate_vma_info {
 	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
 	MIGRATE_VMA_SELECT_DEVICE_COHERENT = 1 << 2,
 	MIGRATE_VMA_SELECT_COMPOUND = 1 << 3,
+	MIGRATE_VMA_FAULT = 1 << 4,
+	MIGRATE_VMA_WRITE = 1 << 5,
 };
 
 struct migrate_vma {
@@ -218,10 +220,14 @@ struct migrate_vma {
 	struct page		*fault_page;
 };
 
-// TODO: enable migration
 static inline enum migrate_vma_info hmm_select_migrate(struct hmm_range *range)
 {
-	return 0;
+	enum migrate_vma_info minfo;
+
+	minfo = (range->default_flags & HMM_PFN_REQ_MIGRATE) ?
+		range->migrate->flags : 0;
+
+	return minfo;
 }
 
 #ifdef CONFIG_MMU_NOTIFIER
diff --git a/mm/hmm.c b/mm/hmm.c
index 5a1471fd5d28..4d853ee8e8b8 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -1542,14 +1542,43 @@ static int hmm_range_fault_locked(struct hmm_range *range, bool *locked)
  *		the invalidation to finish.
  * -EFAULT:     A page was requested to be valid and could not be made valid
  *              ie it has no backing VMA or it is illegal to access
+ * -ERANGE:     The range crosses multiple VMAs, or space for hmm_pfns array
+ *              is too low.
  *
  * This is similar to get_user_pages(), except that it can read the page tables
  * without mutating them (ie causing faults).
  *
  * The mmap lock must be held by the caller and will remain held on return.
  * New users should prefer hmm_range_fault_unlocked_timeout() unless they
- * specifically need to keep the mmap lock held across the call. This helper
- * cannot support VMAs whose fault handlers need to drop the mmap lock.
+ * specifically need to keep the mmap lock held across the call like while
+ * migrating. This helper cannot support VMAs whose fault handlers need to
+ * drop the mmap lock.
+ *
+ * If want to do migration after faulting, call hmm_range_fault() with
+ * range.default_flags of HMM_PFN_REQ_MIGRATE, and optionally
+ * HMM_PFN_REQ_FAULT|HMM_PFN_REQ_WRITE, and initialize range->migrate field.
+ * range->migrate->vma will be populated during the call,
+ * and must be stable across the whole migrate process, which is
+ * why mmap_lock must be held around this call.
+ *
+ * When HMM_PFN_REQ_MIGRATE is set, migration collection may be partial on
+ * return and the caller takes responsibility for completing or aborting it.
+ *
+ * On success, the caller must call migrate_hmm_range_setup() and may then
+ * proceed with the normal migrate_vma sequence: prepare destination pages,
+ * call migrate_vma_pages(), update device mappings as needed, and finally
+ * call migrate_vma_finalize().
+ *
+ * On -EBUSY, the caller may retry hmm_range_fault() using the same range and
+ * PFN array without undoing entries collected by the previous attempt. If
+ * the caller stops retrying, it must abort the partial migration.
+ *
+ * On any other error, or when abandoning a retry, the caller must call
+ * migrate_hmm_range_setup(), migrate_vma_pages() with no valid destination
+ * entries, and migrate_vma_finalize() to abort the partial migration.
+ *
+ * The mmap read lock must remain held until the migration has either been
+ * completed or aborted.
  */
 int hmm_range_fault(struct hmm_range *range)
 {
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 43e571e82cca..1e1a592e1267 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -18,519 +18,6 @@
 #include <asm/tlbflush.h>
 #include "internal.h"
 
-static int migrate_vma_collect_skip(unsigned long start,
-				    unsigned long end,
-				    struct mm_walk *walk)
-{
-	struct migrate_vma *migrate = walk->private;
-	unsigned long addr;
-
-	for (addr = start; addr < end; addr += PAGE_SIZE) {
-		migrate->dst[migrate->npages] = 0;
-		migrate->src[migrate->npages++] = 0;
-	}
-
-	return 0;
-}
-
-static int migrate_vma_collect_hole(unsigned long start,
-				    unsigned long end,
-				    __always_unused int depth,
-				    struct mm_walk *walk)
-{
-	struct migrate_vma *migrate = walk->private;
-	unsigned long addr;
-
-	/* Only allow populating anonymous memory. */
-	if (!vma_is_anonymous(walk->vma))
-		return migrate_vma_collect_skip(start, end, walk);
-
-	if (thp_migration_supported() &&
-		(migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
-		(IS_ALIGNED(start, HPAGE_PMD_SIZE) &&
-		 IS_ALIGNED(end, HPAGE_PMD_SIZE))) {
-		migrate->src[migrate->npages] = MIGRATE_PFN_MIGRATE |
-						MIGRATE_PFN_COMPOUND;
-		migrate->dst[migrate->npages] = 0;
-		migrate->npages++;
-		migrate->cpages++;
-
-		/*
-		 * Collect the remaining entries as holes, in case we
-		 * need to split later
-		 */
-		return migrate_vma_collect_skip(start + PAGE_SIZE, end, walk);
-	}
-
-	for (addr = start; addr < end; addr += PAGE_SIZE) {
-		migrate->src[migrate->npages] = MIGRATE_PFN_MIGRATE;
-		migrate->dst[migrate->npages] = 0;
-		migrate->npages++;
-		migrate->cpages++;
-	}
-
-	return 0;
-}
-
-/**
- * migrate_vma_split_folio() - Helper function to split a THP folio
- * @folio: the folio to split
- * @fault_page: struct page associated with the fault if any
- *
- * If @folio is not the folio containing @fault_page, the caller must hold a
- * reference on @folio. The helper consumes that reference.
- *
- * Returns 0 on success
- */
-static int migrate_vma_split_folio(struct folio *folio,
-				   struct page *fault_page)
-{
-	int ret;
-	struct folio *fault_folio = fault_page ? page_folio(fault_page) : NULL;
-	struct folio *new_fault_folio = NULL;
-
-	if (folio != fault_folio)
-		folio_lock(folio);
-
-	ret = split_folio(folio);
-	if (ret) {
-		if (folio != fault_folio) {
-			folio_unlock(folio);
-			folio_put(folio);
-		}
-		return ret;
-	}
-
-	new_fault_folio = fault_page ? page_folio(fault_page) : NULL;
-
-	/*
-	 * Ensure the lock is held on the correct
-	 * folio after the split
-	 */
-	if (!new_fault_folio) {
-		folio_unlock(folio);
-		folio_put(folio);
-	} else if (folio != new_fault_folio) {
-		if (new_fault_folio != fault_folio) {
-			folio_get(new_fault_folio);
-			folio_lock(new_fault_folio);
-		}
-		folio_unlock(folio);
-		folio_put(folio);
-	}
-
-	return 0;
-}
-
-/** migrate_vma_collect_huge_pmd - collect THP pages without splitting the
- * folio for device private pages.
- * @pmdp: pointer to pmd entry
- * @start: start address of the range for migration
- * @end: end address of the range for migration
- * @walk: mm_walk callback structure
- * @fault_folio: folio associated with the fault if any
- *
- * Collect the huge pmd entry at @pmdp for migration and set the
- * MIGRATE_PFN_COMPOUND flag in the migrate src entry to indicate that
- * migration will occur at HPAGE_PMD granularity
- */
-static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
-					unsigned long end, struct mm_walk *walk,
-					struct folio *fault_folio)
-{
-	struct mm_struct *mm = walk->mm;
-	struct folio *folio;
-	struct migrate_vma *migrate = walk->private;
-	spinlock_t *ptl;
-	int ret;
-	unsigned long write = 0;
-
-	ptl = pmd_lock(mm, pmdp);
-	if (pmd_none(*pmdp)) {
-		spin_unlock(ptl);
-		return migrate_vma_collect_hole(start, end, -1, walk);
-	}
-
-	if (pmd_trans_huge(*pmdp)) {
-		if (!(migrate->flags & MIGRATE_VMA_SELECT_SYSTEM)) {
-			spin_unlock(ptl);
-			return migrate_vma_collect_skip(start, end, walk);
-		}
-
-		folio = pmd_folio(*pmdp);
-		if (is_huge_zero_folio(folio)) {
-			spin_unlock(ptl);
-			return migrate_vma_collect_hole(start, end, -1, walk);
-		}
-		if (pmd_write(*pmdp))
-			write = MIGRATE_PFN_WRITE;
-	} else if (!pmd_present(*pmdp)) {
-		const softleaf_t entry = softleaf_from_pmd(*pmdp);
-
-		if (!softleaf_is_device_private(entry) ||
-		    !(migrate->flags & MIGRATE_VMA_SELECT_DEVICE_PRIVATE)) {
-			spin_unlock(ptl);
-			return migrate_vma_collect_skip(start, end, walk);
-		}
-
-		folio = softleaf_to_folio(entry);
-		if (folio->pgmap->owner != migrate->pgmap_owner) {
-			spin_unlock(ptl);
-			return migrate_vma_collect_skip(start, end, walk);
-		}
-
-		if (softleaf_is_device_private_write(entry))
-			write = MIGRATE_PFN_WRITE;
-	} else {
-		spin_unlock(ptl);
-		return -EAGAIN;
-	}
-
-	folio_get(folio);
-	if (folio != fault_folio && unlikely(!folio_trylock(folio))) {
-		spin_unlock(ptl);
-		folio_put(folio);
-		return migrate_vma_collect_skip(start, end, walk);
-	}
-
-	if (thp_migration_supported() &&
-		(migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
-		(IS_ALIGNED(start, HPAGE_PMD_SIZE) &&
-		 IS_ALIGNED(end, HPAGE_PMD_SIZE))) {
-
-		struct page_vma_mapped_walk pvmw = {
-			.ptl = ptl,
-			.address = start,
-			.pmd = pmdp,
-			.vma = walk->vma,
-		};
-
-		unsigned long pfn = page_to_pfn(folio_page(folio, 0));
-
-		migrate->src[migrate->npages] = migrate_pfn(pfn) | write
-						| MIGRATE_PFN_MIGRATE
-						| MIGRATE_PFN_COMPOUND;
-		migrate->dst[migrate->npages++] = 0;
-		migrate->cpages++;
-		ret = set_pmd_migration_entry(&pvmw, folio_page(folio, 0));
-		if (ret) {
-			migrate->npages--;
-			migrate->cpages--;
-			migrate->src[migrate->npages] = 0;
-			migrate->dst[migrate->npages] = 0;
-			goto fallback;
-		}
-		migrate_vma_collect_skip(start + PAGE_SIZE, end, walk);
-		spin_unlock(ptl);
-		return 0;
-	}
-
-fallback:
-	spin_unlock(ptl);
-	if (!folio_test_large(folio))
-		goto done;
-	ret = split_folio(folio);
-	if (fault_folio != folio)
-		folio_unlock(folio);
-	folio_put(folio);
-	if (ret)
-		return migrate_vma_collect_skip(start, end, walk);
-	if (pmd_none(pmdp_get_lockless(pmdp)))
-		return migrate_vma_collect_hole(start, end, -1, walk);
-
-done:
-	return -ENOENT;
-}
-
-static int migrate_vma_collect_pmd(pmd_t *pmdp,
-				   unsigned long start,
-				   unsigned long end,
-				   struct mm_walk *walk)
-{
-	struct migrate_vma *migrate = walk->private;
-	struct vm_area_struct *vma = walk->vma;
-	struct mm_struct *mm = vma->vm_mm;
-	unsigned long addr = start, unmapped = 0;
-	spinlock_t *ptl;
-	struct folio *fault_folio = migrate->fault_page ?
-		page_folio(migrate->fault_page) : NULL;
-	pte_t *ptep;
-
-again:
-	if (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp)) {
-		int ret = migrate_vma_collect_huge_pmd(pmdp, start, end, walk, fault_folio);
-
-		if (ret == -EAGAIN)
-			goto again;
-		if (ret == 0)
-			return 0;
-	}
-
-	ptep = pte_offset_map_lock(mm, pmdp, start, &ptl);
-	if (!ptep)
-		goto again;
-	lazy_mmu_mode_enable();
-	ptep += (addr - start) / PAGE_SIZE;
-
-	for (; addr < end; addr += PAGE_SIZE, ptep++) {
-		struct dev_pagemap *pgmap;
-		unsigned long mpfn = 0, pfn;
-		struct folio *folio;
-		struct page *page;
-		softleaf_t entry;
-		pte_t pte;
-
-		pte = ptep_get(ptep);
-
-		if (pte_none(pte)) {
-			if (vma_is_anonymous(vma)) {
-				mpfn = MIGRATE_PFN_MIGRATE;
-				migrate->cpages++;
-			}
-			goto next;
-		}
-
-		if (!pte_present(pte)) {
-			/*
-			 * Only care about unaddressable device page special
-			 * page table entry. Other special swap entries are not
-			 * migratable, and we ignore regular swapped page.
-			 */
-			entry = softleaf_from_pte(pte);
-			if (!softleaf_is_device_private(entry))
-				goto next;
-
-			page = softleaf_to_page(entry);
-			pgmap = page_pgmap(page);
-			if (!(migrate->flags &
-				MIGRATE_VMA_SELECT_DEVICE_PRIVATE) ||
-			    pgmap->owner != migrate->pgmap_owner)
-				goto next;
-
-			folio = page_folio(page);
-			if (folio_test_large(folio)) {
-				int ret;
-
-				/* migrate_vma_split_folio() consumes this reference */
-				if (folio != fault_folio)
-					folio_get(folio);
-				lazy_mmu_mode_disable();
-				pte_unmap_unlock(ptep, ptl);
-				ret = migrate_vma_split_folio(folio,
-							  migrate->fault_page);
-
-				if (ret) {
-					if (unmapped)
-						flush_tlb_range(walk->vma, start, end);
-
-					return migrate_vma_collect_skip(addr, end, walk);
-				}
-
-				goto again;
-			}
-
-			mpfn = migrate_pfn(page_to_pfn(page)) |
-					MIGRATE_PFN_MIGRATE;
-			if (softleaf_is_device_private_write(entry))
-				mpfn |= MIGRATE_PFN_WRITE;
-		} else {
-			pfn = pte_pfn(pte);
-			if (is_zero_pfn(pfn) &&
-			    (migrate->flags & MIGRATE_VMA_SELECT_SYSTEM)) {
-				mpfn = MIGRATE_PFN_MIGRATE;
-				migrate->cpages++;
-				goto next;
-			}
-			page = vm_normal_page(migrate->vma, addr, pte);
-			if (page && !is_zone_device_page(page) &&
-			    !(migrate->flags & MIGRATE_VMA_SELECT_SYSTEM)) {
-				goto next;
-			} else if (page && is_device_coherent_page(page)) {
-				pgmap = page_pgmap(page);
-
-				if (!(migrate->flags &
-					MIGRATE_VMA_SELECT_DEVICE_COHERENT) ||
-					pgmap->owner != migrate->pgmap_owner)
-					goto next;
-			}
-			folio = page ? page_folio(page) : NULL;
-			if (folio && folio_test_large(folio)) {
-				int ret;
-
-				/* migrate_vma_split_folio() consumes this reference */
-				if (folio != fault_folio)
-					folio_get(folio);
-				lazy_mmu_mode_disable();
-				pte_unmap_unlock(ptep, ptl);
-				ret = migrate_vma_split_folio(folio,
-							  migrate->fault_page);
-
-				if (ret) {
-					if (unmapped)
-						flush_tlb_range(walk->vma, start, end);
-
-					return migrate_vma_collect_skip(addr, end, walk);
-				}
-
-				goto again;
-			}
-			mpfn = migrate_pfn(pfn) | MIGRATE_PFN_MIGRATE;
-			mpfn |= pte_write(pte) ? MIGRATE_PFN_WRITE : 0;
-		}
-
-		if (!page || !page->mapping) {
-			mpfn = 0;
-			goto next;
-		}
-
-		/*
-		 * By getting a reference on the folio we pin it and that blocks
-		 * any kind of migration. Side effect is that it "freezes" the
-		 * pte.
-		 *
-		 * We drop this reference after isolating the folio from the lru
-		 * for non device folio (device folio are not on the lru and thus
-		 * can't be dropped from it).
-		 */
-		folio = page_folio(page);
-		folio_get(folio);
-
-		/*
-		 * We rely on folio_trylock() to avoid deadlock between
-		 * concurrent migrations where each is waiting on the others
-		 * folio lock. If we can't immediately lock the folio we fail this
-		 * migration as it is only best effort anyway.
-		 *
-		 * If we can lock the folio it's safe to set up a migration entry
-		 * now. In the common case where the folio is mapped once in a
-		 * single process setting up the migration entry now is an
-		 * optimisation to avoid walking the rmap later with
-		 * try_to_migrate().
-		 */
-		if (fault_folio == folio || folio_trylock(folio)) {
-			bool anon_exclusive;
-			pte_t swp_pte;
-
-			if (pte_present(pte))
-				flush_cache_page(vma, addr, pte_pfn(pte));
-			anon_exclusive = folio_test_anon(folio) &&
-					  PageAnonExclusive(page);
-			if (anon_exclusive) {
-				pte = ptep_clear_flush(vma, addr, ptep);
-
-				if (folio_try_share_anon_rmap_pte(folio, page)) {
-					set_pte_at(mm, addr, ptep, pte);
-					if (fault_folio != folio)
-						folio_unlock(folio);
-					folio_put(folio);
-					mpfn = 0;
-					goto next;
-				}
-			} else {
-				pte = ptep_get_and_clear(mm, addr, ptep);
-			}
-
-			migrate->cpages++;
-
-			/* Set the dirty flag on the folio now the pte is gone. */
-			if (pte_present(pte) && pte_dirty(pte))
-				folio_mark_dirty(folio);
-
-			/* Setup special migration page table entry */
-			if (mpfn & MIGRATE_PFN_WRITE)
-				entry = make_writable_migration_entry(
-							page_to_pfn(page));
-			else if (anon_exclusive)
-				entry = make_readable_exclusive_migration_entry(
-							page_to_pfn(page));
-			else
-				entry = make_readable_migration_entry(
-							page_to_pfn(page));
-			if (pte_present(pte)) {
-				if (pte_young(pte))
-					entry = make_migration_entry_young(entry);
-				if (pte_dirty(pte))
-					entry = make_migration_entry_dirty(entry);
-			}
-			swp_pte = swp_entry_to_pte(entry);
-			if (pte_present(pte)) {
-				if (pte_soft_dirty(pte))
-					swp_pte = pte_swp_mksoft_dirty(swp_pte);
-				if (pte_uffd(pte))
-					swp_pte = pte_swp_mkuffd(swp_pte);
-			} else {
-				if (pte_swp_soft_dirty(pte))
-					swp_pte = pte_swp_mksoft_dirty(swp_pte);
-				if (pte_swp_uffd(pte))
-					swp_pte = pte_swp_mkuffd(swp_pte);
-			}
-			set_pte_at(mm, addr, ptep, swp_pte);
-
-			/*
-			 * This is like regular unmap: we remove the rmap and
-			 * drop the folio refcount. The folio won't be freed, as
-			 * we took a reference just above.
-			 */
-			folio_remove_rmap_pte(folio, page, vma);
-			folio_put(folio);
-
-			if (pte_present(pte))
-				unmapped++;
-		} else {
-			folio_put(folio);
-			mpfn = 0;
-		}
-
-next:
-		migrate->dst[migrate->npages] = 0;
-		migrate->src[migrate->npages++] = mpfn;
-	}
-
-	/* Only flush the TLB if we actually modified any entries */
-	if (unmapped)
-		flush_tlb_range(walk->vma, start, end);
-
-	lazy_mmu_mode_disable();
-	pte_unmap_unlock(ptep - 1, ptl);
-
-	return 0;
-}
-
-static const struct mm_walk_ops migrate_vma_walk_ops = {
-	.pmd_entry		= migrate_vma_collect_pmd,
-	.pte_hole		= migrate_vma_collect_hole,
-	.walk_lock		= PGWALK_RDLOCK,
-};
-
-/*
- * migrate_vma_collect() - collect pages over a range of virtual addresses
- * @migrate: migrate struct containing all migration information
- *
- * This will walk the CPU page table. For each virtual address backed by a
- * valid page, it updates the src array and takes a reference on the page, in
- * order to pin the page until we lock it and unmap it.
- */
-static void migrate_vma_collect(struct migrate_vma *migrate)
-{
-	struct mmu_notifier_range range;
-
-	/*
-	 * Note that the pgmap_owner is passed to the mmu notifier callback so
-	 * that the registered device driver can skip invalidating device
-	 * private page mappings that won't be migrated.
-	 */
-	mmu_notifier_range_init_owner(&range, MMU_NOTIFY_MIGRATE, 0,
-		migrate->vma->vm_mm, migrate->start, migrate->end,
-		migrate->pgmap_owner);
-	mmu_notifier_invalidate_range_start(&range);
-
-	walk_page_range_vma(migrate->vma, migrate->start, migrate->end,
-			&migrate_vma_walk_ops, migrate);
-
-	mmu_notifier_invalidate_range_end(&range);
-	migrate->end = migrate->start + (migrate->npages << PAGE_SHIFT);
-}
-
 /*
  * migrate_vma_check_page() - check if page is pinned or not
  * @page: struct page to check
@@ -677,8 +164,9 @@ static void migrate_vma_unmap(struct migrate_vma *migrate)
  * migrate_vma_setup() - prepare to migrate a range of memory
  * @args: contains the vma, start, and pfns arrays for the migration
  *
- * Returns: negative errno on failures, 0 when 0 or more pages were migrated
- * without an error.
+ * Returns: -EINVAL on invalid arguments, 0 otherwise. A 0 return does not
+ * imply anything was collected; on return @args->cpages holds the number of
+ * pages prepared for migration (possibly 0). See the note on faulting below.
  *
  * Prepare to migrate a range of memory virtual address range by collecting all
  * the pages backing each virtual address in the range, saving them inside the
@@ -688,6 +176,20 @@ static void migrate_vma_unmap(struct migrate_vma *migrate)
  * corresponding src array entry.  Then restores any pages that are pinned, by
  * remapping and unlocking those pages.
  *
+ * By default migrate_vma_setup() is best-effort: virtual addresses that cannot
+ * be collected are left with an empty src[] entry and the rest of the range
+ * still proceeds.
+ *
+ * The optional flags MIGRATE_VMA_FAULT and MIGRATE_VMA_WRITE in @args->flags
+ * additionally fault in missing pages before collecting them, for read and for
+ * write respectively. Unlike the best-effort default, if such a fault cannot be
+ * satisfied the whole range is aborted: the partial collection is rolled back,
+ * @args->src is cleared, @args->cpages and @args->npages are reset to 0,
+ * and migrate_vma_setup() still returns 0. The fault error is therefore not
+ * observable through this interface. Callers that need to act on fault failures
+ * should instead drive the migration directly via hmm_range_fault() followed by
+ * migrate_hmm_range_setup(), which preserves the error code.
+ *
  * The caller should then allocate destination memory and copy source memory to
  * it for all those entries (ie with MIGRATE_PFN_VALID and MIGRATE_PFN_MIGRATE
  * flag set).  Once these are allocated and copied, the caller must update each
@@ -739,10 +241,20 @@ static void migrate_vma_unmap(struct migrate_vma *migrate)
  */
 int migrate_vma_setup(struct migrate_vma *args)
 {
+	int ret;
 	long nr_pages = (args->end - args->start) >> PAGE_SHIFT;
+	struct hmm_range range = {
+		.notifier = NULL,
+		.hmm_pfns = args->src,
+		.dev_private_owner = args->pgmap_owner,
+		.migrate = args,
+		.default_flags = HMM_PFN_REQ_MIGRATE
+	};
 
 	args->start &= PAGE_MASK;
 	args->end &= PAGE_MASK;
+	range.start = args->start;
+	range.end = args->end;
 	if (!args->vma || is_vm_hugetlb_page(args->vma) ||
 	    (args->vma->vm_flags & VM_SPECIAL) || vma_is_dax(args->vma))
 		return -EINVAL;
@@ -764,10 +276,24 @@ int migrate_vma_setup(struct migrate_vma *args)
 	args->cpages = 0;
 	args->npages = 0;
 
-	migrate_vma_collect(args);
+	if (args->flags & MIGRATE_VMA_FAULT)
+		range.default_flags |= HMM_PFN_REQ_FAULT;
 
-	if (args->cpages)
-		migrate_vma_unmap(args);
+	if (args->flags & MIGRATE_VMA_WRITE)
+		range.default_flags |= HMM_PFN_REQ_FAULT | HMM_PFN_REQ_WRITE;
+
+	ret = hmm_range_fault(&range);
+
+	migrate_hmm_range_setup(&range);
+
+	/* Remove migration PTEs */
+	if (ret) {
+		migrate_vma_pages(args);
+		migrate_vma_finalize(args);
+		memset(args->src, 0, sizeof(*args->src) * nr_pages);
+		args->cpages = 0;
+		args->npages = 0;
+	}
 
 	/*
 	 * At this point pages are locked and unmapped, and thus they have
-- 
2.55.0


