Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D89D606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 06:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=GJUSu9gZ
Received: by kanga.kvack.org (Postfix)
	id 192766B0620; Wed, 21 Oct 2026 02:06:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11C1B6B0621; Wed, 21 Oct 2026 02:06:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFE7F6B0622; Wed, 21 Oct 2026 02:06:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BEE036B0620
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:06:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 54374A654E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:06:02 +0000 (UTC)
X-FDA: 85345597764.16.032B099
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 26F0CC000A
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:05:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GJUSu9gZ;
	spf=pass (imf28.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792562760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2s7sy+SVvRc4UpGAfkya5y1O6jc//tVZw1Co8TmbAlo=;
	b=lX5ZU+QZX8LAKQ9/zjxAPsjm2ZCV3q2wXFmFcEY2x11ujJf+xHQr2JO2j9K4srk6io1nvC
	Vo4HIzgpcV8Z48sUEw5g6eJwdScRtUoi6fSkVYa9UEJm1d6ZMwXHjmp+qkwrS9pZeUYujB
	324L+7kt6257ZKLAbScLBEGR89XKE7M=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GJUSu9gZ;
	spf=pass (imf28.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792562760;
	b=vxaUYm1kRDAGqF+brltmbRh1xsXDGtMpF5luGC0Tt29nP3ZJMRUI6JEnTiOATMaf7c7bJU
	Qz1c5rPAe65Xjf0GHyZ+V+KCWGwfpGSxd1SYJTGiX2Q13+hQhPQGjz4xHEMVAUWAwfIcqj
	M+JevmJnQaG2HA5+7NwVkftL2fhNTTE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792562759;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2s7sy+SVvRc4UpGAfkya5y1O6jc//tVZw1Co8TmbAlo=;
	b=GJUSu9gZ2mDp/Wii4AXWxMG50PpknIVclYFet+yZpm/vHlSuHJZtE+U8NbKha3sleAiFWz
	LdEsjgviYQJqWQWotK1VAFSS90u473q8WC1xu6/qrTZ7SioNKhvEv6znG4Axn5zzOx1D2e
	Du4zWTTfE70uRAz2exivBgUUoJNFnSg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-171-qte-dE-vMW-0pZpeWkeykg-1; Wed, 21 Oct 2026 02:05:56 -0400
X-MC-Unique: qte-dE-vMW-0pZpeWkeykg-1
X-Mimecast-MFC-AGG-ID: qte-dE-vMW-0pZpeWkeykg_1792562755
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a1d1f26a63so3075165e9.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 23:05:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792562755; x=1793167555;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2s7sy+SVvRc4UpGAfkya5y1O6jc//tVZw1Co8TmbAlo=;
        b=ORkEZ98sI5R3x/wr83q0l2W6r9+Gn6HWWRwt8N42QBLEj+QwZ02PJ0qSeTFdQkYPEN
         90SfEktqExjJ2XH9iyBFzYCt6LXV5Fz98aMgwluSkO+PHpL4xZyl+E/VIo8qvfPZBNfD
         uACjs3lbd7M3nFK6b+Ayyg9i+Hs0YcCNa5GivLadCFuH16ggKAgpdajo+0/zrUOg1IBm
         1OXSAguFsVBNb+kxK1Sb4dKDKxukUgA4kqWc5MfOV5PNkV3jrWInm/MgG2I1/xq/Mp6A
         xYxIiYy9hOBQnrPDMI54FKvwumbcz9/2uL8LLRMiGAfmZJJbQECUdhCw54oMTi2NC6+O
         X8Og==
X-Gm-Message-State: AFq9FYKRrIHpToqgpxpz2hkLfASjryqrgBD15fX3tk9muycPUgfhY6pS
	G1I1h5b3ISkc4teSNvN1Z96QNNxad7tIF+n+DYs32QOBjOIwMAcU8xuHmmDdkphUJfuzoEFVyVw
	FfJrycJp7dMGsBRSOrUNbcrEjt4TMyPZwgprGyAEka6OJwpx0jX1KcFSqxotlHyODLfDGJuCbvB
	bN++mU+jhITxsy7+fxM3FzYQasYfZRXbLd6WY6iQ==
X-Gm-Gg: AYBFou2CM2a3vvceiqeA1hgJTDSCnmJNhgBTjCatVq06MyAod7Zrs0UaFQrVU4Ulk3+
	ZKoyEzCz0q8Wl5LFcduPx+kDu/bhMlb1NyGBudF6oZsrbt/aK5rVSEbbJPCGdxBvzlwzHdmIMBJ
	CzGJ4ORybXmtpnt9MKEGvTx/b04fVdg03xhhsfn+wErleDLEHu77e1s5mpkE1W4A5LO0e5/zw59
	SNzxdfFuTEisQWOjI1fvYiAmSVqiVTtuPFU9S9Ono32huuqrqBGKBGdVOKvBK1wUpqacYKcv+rA
	LUYvsnyid/eRrUZOZslCx6JdSTTnAldBR287ik59md6B6DtU9VUz8grmJgoUnQRhA5Wh/L89CaH
	7Kz+g39HOEG+xJhPC/y3OVYoPal0JK+QQ++Mm
X-Received: by 2002:a05:600c:8b4c:b0:4a1:fb01:13 with SMTP id 5b1f17b1804b1-4a1fdd15484mr17405845e9.18.1792562755003;
        Tue, 20 Oct 2026 23:05:55 -0700 (PDT)
X-Received: by 2002:a05:600c:8b4c:b0:4a1:fb01:13 with SMTP id 5b1f17b1804b1-4a1fdd15484mr17405085e9.18.1792562754409;
        Tue, 20 Oct 2026 23:05:54 -0700 (PDT)
Received: from fedora.redhat.corp (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e254f02f1sm3413741f8f.3.2026.10.20.23.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 23:05:53 -0700 (PDT)
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
	Danilo Krummrich <dakr@kernel.org>,
	Marco Pagani <marpagan@redhat.com>
Subject: [PATCH v16 10/12] lib/test_hmm: add a new testcase for the migrate on fault
Date: Wed, 21 Oct 2026 09:05:04 +0300
Message-ID: <20261021060506.2377545-11-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261021060506.2377545-1-mpenttil@redhat.com>
References: <20261021060506.2377545-1-mpenttil@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6_ZspsogNStFkYD0rt1tqdgQPKr17mMBScJ3Z6j9-ow_1792562755
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 26F0CC000A
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: enannn7jz4z3og3o4o1hjkhss5g3kb44
X-HE-Tag: 1792562759-460148
X-HE-Meta: U2FsdGVkX1/zz7ZML11syf5QCwOvfe6KRP/jmk3s7CrkzznA0K31imkTcryuvEiwjXSIWJvP1eys3fHvtn/H3rCKO9HDmCI3fZqzY48kALuc4vAadim6Mk9GAtgynYXVRPctUVb+sSfowpRz/ea5lOLEQjUTND87bTqJ9chOImrVEI0tF+JPO1CME9JoZkt1roWct92BEUCsEmI4mCnKCIEP2pUwS+j0HOXVEidTeCCQJZ/mp9aCoksImk0lK25LQUOgHbEgfOw+xSgtvNSCq5qYb/qORUSzsdiRkdPOiDcwHGMiec0RAVhkeRDnQu1Ifhkw8xt60Q8tcYWI4Jy7hGBFgaI7eXuIbhq8u1pjSIFMVctK+1eny+LSX4eNf3B/DIsdHAquoukORoy2EWcg3JAvnolERPtIfWIF/ybKj/nC8LEjhiSi1vaTdIUdz1vwMJRms+YQli2BBysPGGKvgOydATTB9A+vMvwtzLimkwLuPvcKxphDEJCEZ8/d6xdGRTh2HgpITasoUv5EbqYrQWPTdwmKO7qIANfTVCuOF7pAGmmLYH9QsWMm/xCIEaL2pNl54i/K6WHk4pjTF6ra0+CvWBDV6cJr8Bh44Kiowmoxk2pehQNnhThi8Y46sXeBT9OVZxtY2Vi9/Zwcd8PK1mjPwoK1WG0dwMMbBiCf/5vn6ITr5BaeeId4aXuBoBv3Sno6UoWgDdIcMH+EGGZg6e0Kc1u5LVo/l8JbWhVYzNhjd9iEfk/GcjDrs776eTHZWkDpfPd6N112nhBIDxSFklWwlFSpco0OzEpSATPEnj/UsCbTuad+cmXprk9S9vijnTc878s1L0xLGeQ4v95P0RSwRTXxZYx/loTmB+Mit1+qJgHVxeQ+QApigXeGo53fQCMWauX8JX2JUxwaoUyqaoVtHodUMsXQxHOfdh4v1DsFaZsBY8lmBByjBo+DJXsOQ6lqjSSciT9jYJlwZIS
 6ypCXo0U
 uyfjcZf2p3LRq/tDaS3J6pHZAOHv1z1HFdYJW1SKkghYYzUzyyXG/nESHFZMuwf7T2jO/V/DYp/n5CYmpzgwr6Jq3loiXbUgfXtnaOXbzxFa/0czMajDDKwHrachKW4l+nfIYbF0CmGMErEBJfZv2rnGwqzpSk9FwenQ2VVaLbPl4PX6uNVIjnH/ABqneYkAnxW1etz4WKfcsAcEbXMsKIqVQWFHQeQoFicqcviUguLAg71yxqWf5Hq47yuadu176Q1yB3hMv7lsWq40flXtZC/B909FYg4slE1ThDk3riF11M3EiUko7sU458TX6ranKt2ltvLCwU//pBbB5TbAIjQwZ84OhWJRvy/txiEvXXaFf/WTXTg70eIeVuinn+MGdSVjQJQSkXse80pc1O2v6ReIxFH1uvnPqEBIwl44HMGHW5zGCTeEvvFwAOSkgXvEZukXNt/+nodP2AArx1iNCR+lxSMf5H6b84u0afisv08LHL7BmEvWiiKZJ7ROSR8c0mm2Ny14hzrVNP+5V07s0/8cqqnlG6+13RW5c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mika Penttilä <mpenttil@redhat.com>

Enhance the hmm test driver (lib/test_hmm) with migrate on fault case.

Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Marco Pagani <marpagan@redhat.com>
Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
---
 lib/test_hmm.c                         | 172 +++++++++++++++++++++++--
 lib/test_hmm_uapi.h                    |  21 +--
 tools/testing/selftests/mm/hmm-tests.c |  54 ++++++++
 3 files changed, 224 insertions(+), 23 deletions(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index cd88e8177d0a..31608b6998bb 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -36,6 +36,7 @@
 #define DMIRROR_RANGE_FAULT_TIMEOUT	1000
 #define DEVMEM_CHUNK_SIZE		(256 * 1024 * 1024U)
 #define DEVMEM_CHUNKS_RESERVE		16
+#define PFNS_ARRAY_SIZE			64
 
 /*
  * For device_private pages, dpage is just a dummy struct page
@@ -355,6 +356,7 @@ static int dmirror_range_fault(struct dmirror *dmirror,
 	struct mm_struct *mm = dmirror->notifier.mm;
 	unsigned long timeout =
 		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	bool migrate = range->default_flags & HMM_PFN_REQ_MIGRATE;
 	int ret;
 
 	while (true) {
@@ -364,9 +366,15 @@ static int dmirror_range_fault(struct dmirror *dmirror,
 		}
 
 		range->notifier_seq = mmu_interval_read_begin(range->notifier);
-		mmap_read_lock(mm);
-		ret = hmm_range_fault(range);
-		mmap_read_unlock(mm);
+
+		/* mmap lock held for whole migrate on fault operation */
+		if (!migrate) {
+			mmap_read_lock(mm);
+			ret = hmm_range_fault(range);
+			mmap_read_unlock(mm);
+		} else {
+			ret = hmm_range_fault(range);
+		}
 		if (ret) {
 			if (ret == -EBUSY)
 				continue;
@@ -382,7 +390,9 @@ static int dmirror_range_fault(struct dmirror *dmirror,
 		break;
 	}
 
-	ret = dmirror_do_fault(dmirror, range);
+	/* update device page table after migration */
+	if (!migrate)
+		ret = dmirror_do_fault(dmirror, range);
 
 	mutex_unlock(&dmirror->mutex);
 out:
@@ -994,8 +1004,12 @@ static int dmirror_atomic_map(unsigned long addr, struct page *page,
 	return 0;
 }
 
-static int dmirror_migrate_finalize_and_map(struct migrate_vma *args,
-					    struct dmirror *dmirror)
+/*
+ * Map the migrated pages into the device's page table. Caller must hold
+ * dmirror->mutex.
+ */
+static int __dmirror_migrate_map_locked(struct migrate_vma *args,
+					struct dmirror *dmirror)
 {
 	unsigned long start = args->start;
 	unsigned long end = args->end;
@@ -1005,9 +1019,6 @@ static int dmirror_migrate_finalize_and_map(struct migrate_vma *args,
 	const unsigned long start_pfn = start >> PAGE_SHIFT;
 	const unsigned long end_pfn = end >> PAGE_SHIFT;
 
-	/* Map the migrated pages into the device's page tables. */
-	mutex_lock(&dmirror->mutex);
-
 	for (pfn = start_pfn; pfn < end_pfn; pfn++, src++, dst++) {
 		struct page *dpage;
 		void *entry;
@@ -1036,17 +1047,27 @@ static int dmirror_migrate_finalize_and_map(struct migrate_vma *args,
 			if (*dst & MIGRATE_PFN_WRITE)
 				entry = xa_tag_pointer(entry, DPT_XA_TAG_WRITE);
 			entry = xa_store(&dmirror->pt, pfn + i, entry, GFP_ATOMIC);
-			if (xa_is_err(entry)) {
-				mutex_unlock(&dmirror->mutex);
+			if (xa_is_err(entry))
 				return xa_err(entry);
-			}
 		}
 	}
 
-	mutex_unlock(&dmirror->mutex);
 	return 0;
 }
 
+static int dmirror_migrate_finalize_and_map(struct migrate_vma *args,
+					    struct dmirror *dmirror)
+{
+	int ret;
+
+	/* Map the migrated pages into the device's page tables. */
+	mutex_lock(&dmirror->mutex);
+	ret = __dmirror_migrate_map_locked(args, dmirror);
+	mutex_unlock(&dmirror->mutex);
+
+	return ret;
+}
+
 static int dmirror_exclusive(struct dmirror *dmirror,
 			     struct hmm_dmirror_cmd *cmd)
 {
@@ -1377,6 +1398,127 @@ static int dmirror_migrate_to_device(struct dmirror *dmirror,
 	return ret;
 }
 
+static int do_fault_and_migrate(struct dmirror *dmirror, struct hmm_range *range)
+{
+	struct migrate_vma *migrate = range->migrate;
+	unsigned long timeout =
+		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	int ret;
+
+	do {
+		mmap_read_lock(dmirror->notifier.mm);
+
+		/* Fault-in pages for migration */
+		ret = dmirror_range_fault(dmirror, range);
+		/*
+		 * Set this up even on error: hmm_range_fault() may have collected
+		 * part of the range before failing.
+		 */
+		migrate_hmm_range_setup(range);
+		if (ret) {
+			/*
+			 * dst[] entries are empty, so this marks every collected
+			 * migration as failed. finalize then restores the source
+			 * mappings and drops the associated locks/references.
+			 */
+			migrate_vma_pages(migrate);
+			migrate_vma_finalize(migrate);
+			goto unlock;
+		}
+
+		pr_debug("Migrating from sys mem to device mem\n");
+
+		dmirror_migrate_alloc_and_copy(migrate, dmirror);
+		migrate_vma_pages(migrate);
+
+		mutex_lock(&dmirror->mutex);
+		if (mmu_interval_read_retry(&dmirror->notifier,
+					    range->notifier_seq))
+			ret = -EBUSY;
+		else
+			ret = __dmirror_migrate_map_locked(migrate, dmirror);
+		mutex_unlock(&dmirror->mutex);
+
+		migrate_vma_finalize(migrate);
+unlock:
+		mmap_read_unlock(dmirror->notifier.mm);
+	} while (ret == -EBUSY && !time_after(jiffies, timeout));
+
+	return ret;
+}
+
+static int dmirror_fault_and_migrate_to_device(struct dmirror *dmirror,
+					       struct hmm_dmirror_cmd *cmd)
+{
+	unsigned long start, size, end, next;
+	unsigned long src_pfns[PFNS_ARRAY_SIZE] = { 0 };
+	unsigned long dst_pfns[PFNS_ARRAY_SIZE] = { 0 };
+	struct migrate_vma migrate = { 0 };
+	struct hmm_range range = { 0 };
+	struct dmirror_bounce bounce;
+	int ret = 0;
+
+	/* Whole range */
+	start = cmd->addr;
+	size = cmd->npages << PAGE_SHIFT;
+	end = start + size;
+
+	if (!mmget_not_zero(dmirror->notifier.mm)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	migrate.pgmap_owner = dmirror->mdevice;
+	migrate.src = src_pfns;
+	migrate.dst = dst_pfns;
+	migrate.flags = MIGRATE_VMA_SELECT_SYSTEM;
+
+	range.migrate = &migrate;
+	range.hmm_pfns = src_pfns;
+	range.pfn_flags_mask = 0;
+	range.default_flags = HMM_PFN_REQ_FAULT | HMM_PFN_REQ_MIGRATE;
+	range.dev_private_owner = dmirror->mdevice;
+	range.notifier = &dmirror->notifier;
+
+	for (next = start; next < end; next = range.end) {
+		range.start = next;
+		range.end = min(end, next + (PFNS_ARRAY_SIZE << PAGE_SHIFT));
+
+		pr_debug("Fault and migrate range start:%#lx end:%#lx\n",
+			 range.start, range.end);
+
+		ret = do_fault_and_migrate(dmirror, &range);
+		if (ret)
+			goto out_mmput;
+	}
+
+	/*
+	 * Return the migrated data for verification.
+	 * Only for pages in device zone
+	 */
+	ret = dmirror_bounce_init(&bounce, start, size);
+	if (ret)
+		goto out_mmput;
+
+	mutex_lock(&dmirror->mutex);
+	ret = dmirror_do_read(dmirror, start, end, &bounce);
+	mutex_unlock(&dmirror->mutex);
+	if (ret == 0) {
+		ret = copy_to_user(u64_to_user_ptr(cmd->ptr), bounce.ptr, bounce.size);
+		if (ret)
+			ret = -EFAULT;
+	}
+
+	cmd->cpages = bounce.cpages;
+	dmirror_bounce_fini(&bounce);
+
+
+out_mmput:
+	mmput(dmirror->notifier.mm);
+out:
+	return ret;
+}
+
 static void dmirror_mkentry(struct dmirror *dmirror, struct hmm_range *range,
 			    unsigned char *perm, unsigned long entry)
 {
@@ -1643,6 +1785,10 @@ static long dmirror_fops_unlocked_ioctl(struct file *filp,
 		ret = dmirror_migrate_to_device(dmirror, &cmd);
 		break;
 
+	case HMM_DMIRROR_MIGRATE_ON_FAULT_TO_DEV:
+		ret = dmirror_fault_and_migrate_to_device(dmirror, &cmd);
+		break;
+
 	case HMM_DMIRROR_MIGRATE_TO_SYS:
 		ret = dmirror_migrate_to_system(dmirror, &cmd);
 		break;
diff --git a/lib/test_hmm_uapi.h b/lib/test_hmm_uapi.h
index ea9b0ec404fb..67d267a3b999 100644
--- a/lib/test_hmm_uapi.h
+++ b/lib/test_hmm_uapi.h
@@ -29,16 +29,17 @@ struct hmm_dmirror_cmd {
 };
 
 /* Expose the address space of the calling process through hmm device file */
-#define HMM_DMIRROR_READ		_IOWR('H', 0x00, struct hmm_dmirror_cmd)
-#define HMM_DMIRROR_WRITE		_IOWR('H', 0x01, struct hmm_dmirror_cmd)
-#define HMM_DMIRROR_MIGRATE_TO_DEV	_IOWR('H', 0x02, struct hmm_dmirror_cmd)
-#define HMM_DMIRROR_MIGRATE_TO_SYS	_IOWR('H', 0x03, struct hmm_dmirror_cmd)
-#define HMM_DMIRROR_SNAPSHOT		_IOWR('H', 0x04, struct hmm_dmirror_cmd)
-#define HMM_DMIRROR_EXCLUSIVE		_IOWR('H', 0x05, struct hmm_dmirror_cmd)
-#define HMM_DMIRROR_CHECK_EXCLUSIVE	_IOWR('H', 0x06, struct hmm_dmirror_cmd)
-#define HMM_DMIRROR_RELEASE		_IOWR('H', 0x07, struct hmm_dmirror_cmd)
-#define HMM_DMIRROR_FLAGS		_IOWR('H', 0x08, struct hmm_dmirror_cmd)
-#define HMM_DMIRROR_READ_UNLOCKED	_IOWR('H', 0x09, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_READ			_IOWR('H', 0x00, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_WRITE			_IOWR('H', 0x01, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_MIGRATE_TO_DEV		_IOWR('H', 0x02, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_MIGRATE_TO_SYS		_IOWR('H', 0x03, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_SNAPSHOT			_IOWR('H', 0x04, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_EXCLUSIVE			_IOWR('H', 0x05, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_CHECK_EXCLUSIVE		_IOWR('H', 0x06, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_RELEASE			_IOWR('H', 0x07, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_FLAGS			_IOWR('H', 0x08, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_READ_UNLOCKED		_IOWR('H', 0x09, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_MIGRATE_ON_FAULT_TO_DEV	_IOWR('H', 0x0a, struct hmm_dmirror_cmd)
 
 #define HMM_DMIRROR_FLAG_FAIL_ALLOC	(1ULL << 0)
 
diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index e2642eca0d02..a2d1b8f494b6 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -334,6 +334,13 @@ static int hmm_migrate_sys_to_dev(int fd,
 	return hmm_dmirror_cmd(fd, HMM_DMIRROR_MIGRATE_TO_DEV, buffer, npages);
 }
 
+static int hmm_migrate_on_fault_sys_to_dev(int fd,
+					   struct hmm_buffer *buffer,
+					   unsigned long npages)
+{
+	return hmm_dmirror_cmd(fd, HMM_DMIRROR_MIGRATE_ON_FAULT_TO_DEV, buffer, npages);
+}
+
 static int hmm_migrate_dev_to_sys(int fd,
 				   struct hmm_buffer *buffer,
 				   unsigned long npages)
@@ -938,6 +945,53 @@ TEST_F(hmm, migrate)
 	hmm_buffer_free(buffer);
 }
 
+
+/*
+ * Fault and migrate anonymous memory to device private memory.
+ */
+TEST_F(hmm, migrate_on_fault)
+{
+	struct hmm_buffer *buffer;
+	unsigned long npages;
+	unsigned long size;
+	unsigned long i;
+	int *ptr;
+	int ret;
+
+	npages = ALIGN(HMM_BUFFER_SIZE, self->page_size) >> self->page_shift;
+	ASSERT_NE(npages, 0);
+	size = npages << self->page_shift;
+
+	buffer = malloc(sizeof(*buffer));
+	ASSERT_NE(buffer, NULL);
+
+	buffer->fd = -1;
+	buffer->size = size;
+	buffer->mirror = malloc(size);
+	ASSERT_NE(buffer->mirror, NULL);
+
+	buffer->ptr = mmap(NULL, size,
+			   PROT_READ | PROT_WRITE,
+			   MAP_PRIVATE | MAP_ANONYMOUS,
+			   buffer->fd, 0);
+	ASSERT_NE(buffer->ptr, MAP_FAILED);
+
+	/* Initialize buffer in system memory. */
+	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+		ptr[i] = i;
+
+	/* Fault and migrate memory to device. */
+	ret = hmm_migrate_on_fault_sys_to_dev(self->fd, buffer, npages);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(buffer->cpages, npages);
+
+	/* Check what the device read. */
+	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
+		ASSERT_EQ(ptr[i], i);
+
+	hmm_buffer_free(buffer);
+}
+
 /*
  * Migrate private file memory to device private memory.
  */
-- 
2.55.0


