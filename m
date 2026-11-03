Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5CB7606A337
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 06:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DE5UgZuG
Received: by kanga.kvack.org (Postfix)
	id E3B236B05BF; Tue,  3 Nov 2026 01:17:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC50B6B05C0; Tue,  3 Nov 2026 01:17:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB5086B05C1; Tue,  3 Nov 2026 01:17:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9FF2C6B05BF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:17:25 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9A592404F6
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:17:24 +0000 (UTC)
X-FDA: 85392800808.05.6585933
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 59E1B40007
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:17:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DE5UgZuG;
	spf=pass (imf11.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793686642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YJKtASFXSozFleqVLs7kYWFKCja/REnxHfhs5K4R3gw=;
	b=wB1sOYUQFenG21D8Jl3TwHzR71pUUzeOsXZhBWOqYDKjopDpxGoIAXC+YK8NS8ovAQqtyv
	VikqllNuxPSF4Tuosm79mOdn3PrTtQ3rOFhCy86l/HHqdC2Ax+xyFC+C0eBXeW07XFUu6t
	0p+ojIsAZxTibauUJxxt7YRoPElLseU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793686642;
	b=VeqJSrtezC+RQPLqx7SVSxLjYc3JHSugpwXIeajXnSwXina11ktyfhFK8RqNOh9ipLlMu4
	s4+jXwMWh4xiVpP81CxJz1so6Ka4zyBQbBF+oR/v58aYb86y3RwyovYs8auv5QhINApJkm
	gCRvDA/768u+Iv8sYaUgCp3vJIAC/iM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DE5UgZuG;
	spf=pass (imf11.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793686641;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YJKtASFXSozFleqVLs7kYWFKCja/REnxHfhs5K4R3gw=;
	b=DE5UgZuG97YXQe26fVlzQxtBmey9q7lluylKVVtfvd0OvwEcqF5d/zHQPmNYuOzQg0XEbc
	YfMxzrD+MslEQiCkDXtzAiZiqP00EEmZWMvknLDbXRauVlK1OBgc50LyaymY/NURfJMUav
	aAps2NerPFcPTIOS+HcbKlTJ23zb/+0=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-398-kbo2oePFO5O198C91SOm-w-1; Tue, 03 Nov 2026 01:17:20 -0500
X-MC-Unique: kbo2oePFO5O198C91SOm-w-1
X-Mimecast-MFC-AGG-ID: kbo2oePFO5O198C91SOm-w_1793686639
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5be3e0d9c34so2050371e87.3
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 22:17:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793686639; x=1794291439;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YJKtASFXSozFleqVLs7kYWFKCja/REnxHfhs5K4R3gw=;
        b=vz8QlT5nL16JQYAp6tIPSiPC68v7nfejJFeSTtELUS4zpijSmszjt/VDF3ieFibsYN
         RvIQDacEfPzepu3QbOnlf4UBpcqx/RsEX2IojsP8FnkCV3JjF1ISu67TSA1xdg2A7xQl
         8I3D7fdo4bOPsnvnufvBJX+MPjpVPk2Cy9PfhuynXdk4ud57E4WeL1yKP0b0BqjwDTh7
         ZgjWlP8RccjTIqrCb20sEMjWqaysy08Lx8e9p4d8mHE/80tD/MZ8vCs+fvp5eJmqjchk
         CE6c4ZayiDI46riZ7IQVf6N7TPb6dnniTLVe3ThcDgqrvlEMzo0hMZkfHykeIbD1i0Fy
         7eug==
X-Gm-Message-State: APuU4Z+pbsKKoSdMIfEODX4viDE6dP7xUv/hZ/RmhxcgOi/6hAyhQ4x1
	pgHAzM5BNUcyDqd/V9OmT6StV6WYENGKKpOHJve2X13Sn2apPjefsmo0QQfPAO+9wMbwdpEfjtv
	YIHnC4dagzI6lsUrpm8B7is+Az571Izugti50IUBz9gTHy04rPsgDsco4SznhKKVIR2aqV1OrI+
	Afqsx0qUmHCtjsfjMZzCjM+89XmnzleFhmX0l79w==
X-Gm-Gg: AYBFou08iVDaUUe7YA5r7/BtDhevpzyp//UqupPwRpxsd3bvvEcPfcF5gyTvIHBq74K
	wjJ3vi++auUyzHdzqGQtCOSBVSjfiTkNNj/YWh0SfjwQApF36W05Tebjqp7gMIYceV2Tp0iA/Od
	t3aq4kRzhcCngzfEHr5zfiSw6J4jBKmnmNAgJaYA7HxGPpEDk+mrE1y3GIWE+tePWi626BY8R7u
	oQElX4S90kpVnBmZHcVGnnKzcwBKEWrYesGygsXdr7TEm4VY98sk/a6+oQGmMRa1q0GXAH5zkQh
	FiSM9zgZCDNwqdfxosXbEfnI3bTavqa36vpMaR4MnfQ2ybQgYq03LtLvwpWpwSAqhZQo5uPSYae
	kW5U/PIm5eCPM/N0Me2h13ko+KZocWce7J16VzBYXbeG9Rt6aRvnCCscn6cXqtJ6EJeMQFw==
X-Received: by 2002:a05:6512:3a84:b0:5bf:be4d:13d0 with SMTP id 2adb3069b0e04-5bfd956226emr3849940e87.19.1793686638787;
        Mon, 02 Nov 2026 22:17:18 -0800 (PST)
X-Received: by 2002:a05:6512:3a84:b0:5bf:be4d:13d0 with SMTP id 2adb3069b0e04-5bfd956226emr3849909e87.19.1793686638234;
        Mon, 02 Nov 2026 22:17:18 -0800 (PST)
Received: from fedora (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bfe073e0f9sm1964634e87.54.2026.11.02.22.17.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 22:17:17 -0800 (PST)
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
	Danilo Krummrich <dakr@kernel.org>,
	Marco Pagani <marpagan@redhat.com>
Subject: [PATCH v17 10/12] lib/test_hmm: add a new testcase for the migrate on fault
Date: Tue,  3 Nov 2026 08:16:27 +0200
Message-ID: <20261103061629.972669-11-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261103061629.972669-1-mpenttil@redhat.com>
References: <20261103061629.972669-1-mpenttil@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3ljIqrNCfpSFHOhJYBb3sVBzrYN3RCAkpij7VauLEh4_1793686639
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9axguqdzbrggo5ed9e8nt9xw9wj3dimx
X-Rspamd-Queue-Id: 59E1B40007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793686642-912818
X-HE-Meta: U2FsdGVkX1/lXsnsS1oy0xtfBi5SwwAjPwkQjLaGSQ9uNs954YXKEb9CtDgYNHfA+vxR7++tVfcfOntE9P3GOgI1lCq2sO/7jGvTuBJllKbNfNR71ILNHFBFqPkq+ptdXh+7qkkeRVg3qMnPvMrnNWmkeY7h9g7QzqQ1cwzpTKTHHU/zPXMQ7O2tFBACTPA8edqbISS0fVDvuZ65LmikUA+DOzqNC9g29WnfQdOyRQUrWOZ3dRGh+JqarXWsc2j7f+X1Y4hroBIoPs5lbjEhxP+MHZCsgwvBSqKCrEjXsJV3Hj/Ccy91+1gHdgy3CpALt6QWUGruf+ejCTWQEh0ss2dZUK9rBK5emmhdYQ0FSJQZf4cUPrDMmg8dgmI3aAwM6bRIi8y5qVokKJTpJ/CYcP2N8ZH2rUsu079RT1B1I23K5o6V5ITH04k6FTsnGDyYsM+pcbhE5IiW4r1w/RryAtm6EDXsVyfAyl5OwrqFR1hZq2mGogNg0pNqQAXixLbLuOVxDrBCmZ2zzLS9mp8tMRZjENLuWDpXhMPueMWVLEsVAyoNfFSg7vqAqL2bmREluhh38hydrAy3QZislv6UoNRPpZCmP23SVE2PQPItK2pZAWosdmEnglErxu+d29VEZcI95bATDS8RjnHzmg2GpBEiGvm0C/HD7P8K+YQCfNBcNycOehfQYdNpFoLwMnzz/yIIdsdsZktfBXerfnkdlz4rhcDZd4M6/7aYknG8+KQ+ErzxPnt88GckmHXEW6MB9jhS+W+806jNTqZlO/eZ834BXl3N1YPeLGFPjCgxCg1mjvEx/lLjp2QHud7rXhbW0X4772q1pdla8VfPCnMNKLlVK2l69w/ytxKADbF/mWdHR6hi0w2ZzZIlyXYShk5Mk9Ng22L1BNLiwR2RXVccw5cmM0mihoOFHgezHESceixO6GS57pMvZSp4f7hh66Bid5oUq3lWPPwc7pYlz40
 6WjQ9Qhg
 Orz6wH6AjZY0EzPgRtjQ2SnS8Y1YuKg2tsivCipO+kvpjqWmDRhL9wFCq3dq9Y/hzxBhAvzGTYwWVN8iEYOdGXKshtJUDfxL5SHje3usaFAdUmXb6aQhfRykpSZQaWfkA/fizPwerRTFMBjHcJr9ciyq+5s01KsHzqCIGJyarb8Hmul6EhUmevCcvvxAyElutnjVvCNx3SNgs1zWMTLgVoisbzdq2zg1FeB7LfUz/TXq/WsIc6oy9xIWXbTn0A7xsYuqqV4z/bp7IHZ7Zi28uASg66AV1S2HBrpCt6tGZFWgjSmcw1Bj5u/SGJF1yosv3CN2X99WiMHLi8PQsMxAbFbDxXIMknEBw5DpfWKpXifP4ekd0uGigxkOTnIHaaklf98PwDUSkvilZWom7jJKmGKPbjax/O1ARJQ2Nguz/hYIT60mke8GyBXBi67LN5EpqPcC3/ILjhFIm34MbWasxqL90JA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mika Penttilä <mpenttil@redhat.com>

Enhance the hmm test driver (lib/test_hmm) with a migrate on fault
case: a single hmm_range_fault() walk with HMM_PFN_REQ_FAULT |
HMM_PFN_REQ_MIGRATE faults in and collects the range, which is then
migrated to device private memory and mapped into the dmirror page
table. The selftest leaves the first two pages unwritten, so page 0
has to be faulted in and page 1 maps the zero page.

If mmu_interval_read_retry() trips after migrate_vma_pages(), the
dmirror mapping is skipped and the -EBUSY retry re-walks. Normally the
trip comes from an unmap or zap: the migration ptes are gone,
migrate_vma_finalize() releases the destination pages and the retry
migrates again. Pages committed to device memory without a dmirror
mapping (e.g. after a huge zero pmd split in migrate_vma_insert_page())
are still consistent, since any invalidation also clears the dmirror
page table, and a real device would map them on its next fault. The
selftest doesn't hit that case: the unwritten pages share a pmd with
written ones, so there is no huge zero pmd.

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
 tools/testing/selftests/mm/hmm-tests.c |  56 ++++++++
 3 files changed, 226 insertions(+), 23 deletions(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index f05f801b8404..2045896493ae 100644
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
@@ -1645,6 +1787,10 @@ static long dmirror_fops_unlocked_ioctl(struct file *filp,
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
index e5f273ca84c1..bacf573d83a9 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -333,6 +333,13 @@ static int hmm_migrate_sys_to_dev(int fd,
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
@@ -937,6 +944,55 @@ TEST_F(hmm, migrate)
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
+	int val;
+
+	npages = ALIGN(HMM_BUFFER_SIZE, self->page_size) >> self->page_shift;
+	ASSERT_NE(npages, 0);
+	size = npages << self->page_shift;
+
+	buffer = hmm_buffer_alloc(size, size,
+				  PROT_READ | PROT_WRITE,
+				  MAP_PRIVATE | MAP_ANONYMOUS, -1);
+	ASSERT_NE(buffer, NULL);
+
+	/*
+	 * Initialize buffer in system memory but leave the first two pages
+	 * zero: page 0 stays pte_none so that hmm_range_fault() has to fault
+	 * it in, page 1 is mapped to the zero page.
+	 */
+	i = 2 * self->page_size / sizeof(*ptr);
+	for (ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+		ptr[i] = i;
+
+	val = *(int *)(buffer->ptr + self->page_size);
+	ASSERT_EQ(val, 0);
+
+	/* Fault and migrate memory to device. */
+	ret = hmm_migrate_on_fault_sys_to_dev(self->fd, buffer, npages);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(buffer->cpages, npages);
+
+	/* Check what the device read. */
+	for (i = 0, ptr = buffer->mirror; i < 2 * self->page_size / sizeof(*ptr); ++i)
+		ASSERT_EQ(ptr[i], 0);
+	for (; i < size / sizeof(*ptr); ++i)
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


