Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46A76CD5BCB
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 05:09:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE8D66B009E; Mon, 25 May 2026 01:09:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7C0B6B009F; Mon, 25 May 2026 01:09:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 904036B00A0; Mon, 25 May 2026 01:09:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6C9F26B009F
	for <linux-mm@kvack.org>; Mon, 25 May 2026 01:09:05 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1BFFFA013C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 05:09:05 +0000 (UTC)
X-FDA: 84804763050.11.DA36C3E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id F2C88100009
	for <linux-mm@kvack.org>; Mon, 25 May 2026 05:09:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=g0db+i8a;
	spf=pass (imf14.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779685743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rBIdZie6RpIvBk6Y4z+QSU0EMts/JP8b+GhZQsswjNU=;
	b=3PdR1RGMAVjk0gXSQbP+kLl8e7V4hmNfY4uJl723VEJA2OVYqTJOCWlS2dqErgttV0ustd
	T7pkin+5ll5Dq3Byt/UDqsPDLwMn7MP0izKc+WjpbkENYrIojzeaEheDfDiUeEoA47VcC/
	CzFz35ykwiHjurA50T/KT5p5+M2gyZg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=g0db+i8a;
	spf=pass (imf14.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779685743; a=rsa-sha256;
	cv=none;
	b=NeH2+D+8W1arOZMvWy39cQBskpyKvLa0t2e2dvn5ZXzutVpfc599GmquNdrGPjnv9u+YvN
	d22Ua9ZoheThl8wyGKtQbBiUMXextc6iUQCxTpdjWf4P9LOQqbhZzTH5a1qrfvpqqHP1Kc
	zF9F+1fNbjz0HEsv5V+u/InzKbG78o4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779685742;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rBIdZie6RpIvBk6Y4z+QSU0EMts/JP8b+GhZQsswjNU=;
	b=g0db+i8aSVQXbrNM57O3xGotBX3Ipndeit+H8EvNS7+w/JS34UycW8HzZsMUNteAvR3Vgp
	zCHa9hoiO7e4U9iNOMMZ9oLKHhMO6uuZT5qoQcE0SCqS9fRISVA3lt95wOJRB+FsvUUBj0
	W10UgPp/cuPb29k9fzTOCPpoYGOgdy0=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-541-KAJP0ntzNDCTHODXKbxluw-1; Mon, 25 May 2026 01:09:00 -0400
X-MC-Unique: KAJP0ntzNDCTHODXKbxluw-1
X-Mimecast-MFC-AGG-ID: KAJP0ntzNDCTHODXKbxluw_1779685739
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-393c9ff86c8so7136971fa.2
        for <linux-mm@kvack.org>; Sun, 24 May 2026 22:09:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779685739; x=1780290539;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rBIdZie6RpIvBk6Y4z+QSU0EMts/JP8b+GhZQsswjNU=;
        b=Z1EAgZN7lmGsFLBb/EW6Nh1gERT2BaB0DXis6sEmOwVRKVFRuzawYV5bahPhXJLw1q
         3Xl1/H/njE79YHpzanUScyJTOQHIXcSGD4o7N5xh2CzVZcKx7tnLkOMZXb7Z/GNROHFX
         mAaxwvAkAGFUncubyCnDuSL+7aOcnffwlt0NCJVdmIyOnKLTXk4+w31v1jN2IhFsFib+
         51kVp9pa3W8rgtOULEkGgp2XOeUM1l+32SgY9ogWnzsdjrLZzZGyCxZsfV+yWvPbhHWd
         kbaIVYzyD4NeiUG8SQ5UU5iSXBNWpTplqR1ugKeY54veKTAZOkSnACs6jTmDgO2C35AJ
         a08A==
X-Gm-Message-State: AOJu0YwYyyAo0iQBmKcd7mKPzmjUvCVfVZSdU77iBkQCdsOp/F01OadX
	KAJFzxIUv8khx/6vhipxvQXWOptAckLmf2SCtAW38wGxhPE79MRoUaPk5KNgUNRA/fgxD8IlOi+
	OsfDBYPICJUEerGypWuvhdjYr5U1WRH1DersI9A2V7VAvbtzi8hssmsR8Wh4u+8DNsfSMKc4xUM
	JcZm2j2GPICi8t4q0rQe0EVq6ZZvVZ2RnJwMwOFw==
X-Gm-Gg: Acq92OGT8I7hCA+Jo0OVCGotuhgNOIDsKt56eUSjdDxoK+p00Xef6zceP2WFyIKf9aw
	04rJfo/TDbQ8WidMciHx3F5oz9pQ5tR52ZBV66CEiU2RGryK65gdZCxMWw8K53bLkApckP1rI4g
	3QDdaWB8DVCjWZCk4vzy6dhOxh99MBsICm+YixTiFlMBieKteQTUaq2AXLL3TjWPbzpEKOXK2Zd
	PLkub1pc3nd8xQZW7uhIptpIcaxgiE/qdsmXzJWC717rDBMgrqX3fdq7z4Ca7/5KHeDaAKgJOuY
	QY25Yyl6Qj5R48zA6AC+g0nqYolmIy8yPVESc0I5tcuhK+xSPqxrjS/jirWMj0Pwn9lcQ/ARonI
	i4no3zh0/b5lemW9pXCVKHzCYQ8mGupPflYvyTs9hnYUj5uI=
X-Received: by 2002:a2e:ab10:0:b0:395:2467:9e74 with SMTP id 38308e7fff4ca-395d8cca5c3mr45770941fa.14.1779685739017;
        Sun, 24 May 2026 22:08:59 -0700 (PDT)
X-Received: by 2002:a2e:ab10:0:b0:395:2467:9e74 with SMTP id 38308e7fff4ca-395d8cca5c3mr45770571fa.14.1779685738413;
        Sun, 24 May 2026 22:08:58 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-395dca7bcddsm20698161fa.16.2026.05.24.22.08.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 22:08:58 -0700 (PDT)
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
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Marco Pagani <marpagan@redhat.com>
Subject: [PATCH v11 5/5] lib/test_hmm: add a new testcase for the migrate on fault
Date: Mon, 25 May 2026 08:08:30 +0300
Message-ID: <20260525050830.100254-6-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260525050830.100254-1-mpenttil@redhat.com>
References: <20260525050830.100254-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: RqSX36rNfB7udbMesl-lnrDvcWMDox3MYoYVHT1NZMs_1779685739
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F2C88100009
X-Stat-Signature: 7h4x51exsy4z4g99qkko9dtnzpyueqec
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779685742-880425
X-HE-Meta: U2FsdGVkX19090yuqJIvoWrnicxIA9H/33VHLo9blGzQJAP2uIyIvr8QXRuZ/q8YYEFS9fBjL4+B/msRDYt3LC1qcHAFMoQ9m81Bv19nsJPIqh8NXG82jwq6Cc3bmh9n6UfdoD+00wJElvd7CSO/JOcgMOShiktPATsItWLAFzum83vtdlmkokJRqoGdWIXK6jYwKa5RExTObBydShnlbT53eMcmGFDJxB39qubXoGKeZq7667CGAd+G4AQsmvBdtR81ZMJLGcJYO1Uz0tSb5RfH4QFQps/DEyjoQC4ZOYL/9hY+YG5x66/q+A7GiYtl1iiaN5Di6rmvAU/k6HlGBhsHS/1xTkv1nsyt+wJ2vdsgwK4JjcQAyWufj9Y/uzH5K6lVZq7yKCX7SDHcLXb5aVm1LXWzRGRIVcUX8AyCm3PzRyRWUr9jT2gmQ6imgfFobcJdtKt7+p1LYES4NkxEQOj0x6CPw4DPrg9jobi/41jTw34ellKpvZMcpqNmVrJ6La7vxZno1fApCjVcV+nRwHgU2jqV7EWXp6N/0DwsycmMJWKWkT/VmdImQOGjoWeHMcMDZt/ESyrotvn3XP9RYSO3yRv0gKZgZEaL3BZ9oc80VfeQDwYpbVuucdlPvB2GzuaVSD8ShQqNHm6kLxrUaCSfipu2kbKwCCd7TDhD02iTxkwAZXUkBjrx+/PFewt3K67aS9n+AQBcFjlNTU4D8CUqOPxzDpzH07dkLoGY6Tks4XXlV6AlrNgZ6e3Vav28EmtYBMiwQy9ZFx4zfpXetLCChaeypTuBR8phuPu/Bn1jaYzw6gOvAN2gogodg6TL91GaIzBWz9QsNVx8E2EfuVzS5V7hVtyOoum6BOuhYfyTyM8YOpMMyPnzeH5GAXs4Gg6MmX5ha1IY7WCSpmQrvUw8PCVyLuilIPwxWxDqxDB5iAwmwHEnjNqVny/1BR8VELKwSwt8vBD5ohZFhW4
 qnEIhPIh
 1w7IcYW8bE1wVojtptrsiJ0F918L0JnQHjZQ2zX7FWtWG5cvIZz6PpkoSOvdZlBiD3qxsGUxXhOKf0flToa2rIQAALPXEeS0utYFO5g60HaDjgGgz3PXJ+Y95xib0GfI744hP5i9Qr4AgZYqebfjN+BCMH7HHsfIeHQnhV22TTVwQK0sC8fhV5Bnh04QAJ0T0RNK5/fn+uN/XiyvLrGnVhiSY651QC+Ve2wRtYMpRwM2Ww0xcJfeNnjPBQWsow2xD2kFhy4q5Dt9FCvallOz5+ES3+GIe/YQa7Im0vKXgLgy730B3QfnrTsS1z6xoVJHsV9RnVPu4aEzYPd/H8s9841vVtsBpjHnnlPX3FSxaegcKdai4nYF7MoeWCz3L0pXYkKU6HRTNMRg/2WFzHAxrPg/NXPj7EYUqtl2ptMnV4sQ6JdgtfIWWIOil2kBVlOzbJMS2EmCmqlFXNMZJ1JCMfPWVDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
 lib/test_hmm.c                         | 116 ++++++++++++++++++++++++-
 lib/test_hmm_uapi.h                    |  19 ++--
 tools/testing/selftests/mm/hmm-tests.c |  54 ++++++++++++
 3 files changed, 176 insertions(+), 13 deletions(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 1a3e21325cf2..d45666b51f33 100644
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
@@ -1258,6 +1268,100 @@ static int dmirror_migrate_to_device(struct dmirror *dmirror,
 	return ret;
 }
 
+static int do_fault_and_migrate(struct dmirror *dmirror, struct hmm_range *range)
+{
+	struct migrate_vma *migrate = range->migrate;
+	int ret;
+
+	mmap_read_lock(dmirror->notifier.mm);
+
+	/* Fault-in pages for migration */
+	ret = dmirror_range_fault(dmirror, range);
+
+	pr_debug("Migrating from sys mem to device mem\n");
+	migrate_hmm_range_setup(range);
+
+	dmirror_migrate_alloc_and_copy(migrate, dmirror);
+	migrate_vma_pages(migrate);
+	dmirror_migrate_finalize_and_map(migrate, dmirror);
+	migrate_vma_finalize(migrate);
+
+	mmap_read_unlock(dmirror->notifier.mm);
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
@@ -1524,6 +1628,10 @@ static long dmirror_fops_unlocked_ioctl(struct file *filp,
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
index f94c6d457338..0b6e7a419e36 100644
--- a/lib/test_hmm_uapi.h
+++ b/lib/test_hmm_uapi.h
@@ -29,15 +29,16 @@ struct hmm_dmirror_cmd {
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
+#define HMM_DMIRROR_READ			_IOWR('H', 0x00, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_WRITE			_IOWR('H', 0x01, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_MIGRATE_TO_DEV		_IOWR('H', 0x02, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_MIGRATE_ON_FAULT_TO_DEV	_IOWR('H', 0x03, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_MIGRATE_TO_SYS		_IOWR('H', 0x04, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_SNAPSHOT			_IOWR('H', 0x05, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_EXCLUSIVE			_IOWR('H', 0x06, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_CHECK_EXCLUSIVE		_IOWR('H', 0x07, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_RELEASE			_IOWR('H', 0x08, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_FLAGS			_IOWR('H', 0x09, struct hmm_dmirror_cmd)
 
 #define HMM_DMIRROR_FLAG_FAIL_ALLOC	(1ULL << 0)
 
diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index 77fb4c5d871b..c8d6a3c33ef2 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -278,6 +278,13 @@ static int hmm_migrate_sys_to_dev(int fd,
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
@@ -985,6 +992,53 @@ TEST_F(hmm, migrate)
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
2.50.0


