Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52475C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 19:47:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50BCA6B00A6; Tue,  7 Jul 2026 15:47:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E3E66B00A7; Tue,  7 Jul 2026 15:47:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D3626B00AA; Tue,  7 Jul 2026 15:47:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 097A66B00A6
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:47:21 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7908C8F3CF
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:47:20 +0000 (UTC)
X-FDA: 84963014640.08.821BDF8
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf31.hostedemail.com (Postfix) with ESMTP id A4BF820006
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:47:18 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gr9WzIGq;
	spf=pass (imf31.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783453638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vfGwKSNbrl+nU6kvbTrSHfyfMmoFAmwmGff/pR29LWo=;
	b=ecPcyECDviur3iaenXWom8hcpapD8RBWhhh4siimP265x6K+uNq8PSbM+sR4MgBCICSWfI
	IbECG1vKti5Go6bbrNFmSSFOwkcSNwkktTBICPkMtmO6ZNYhjOHo0WtK9hP0M58EklQ96/
	qZkM/K6wP6cNs9N9gDee1PQa8kFhC1w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783453638;
	b=qjyKnyQoRtYs4UpW5mwp+Yvp9XujdDYrqGyxnoRPwp0boKphwRgWMjU6C+Sb9OtAO55Lgc
	FIBd4QWc9dkui0a3MJYm0M1ToRXAOB0tMAXfjNWCE6wMgIv1ep01cxiwV+IrQvxeVnP128
	3QkINsWBe0LzdX1NjMU5lwRIdOte2dA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gr9WzIGq;
	spf=pass (imf31.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-385b78b44a0so16284a91.0
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 12:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783453638; x=1784058438; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=vfGwKSNbrl+nU6kvbTrSHfyfMmoFAmwmGff/pR29LWo=;
        b=gr9WzIGqEG2rHeaSjA/hdjjDcs/tpRc3nPyzEZRcCEscX4b5npHkHUDZsOY/tNLvuD
         NxCInT6NsiVax6QPMTXMFOT69SCzKrUVs99NvuF9zQAzxF0QAlbmSSxKTFhIAh/4uHo8
         PGCNB8yNIJ/b82/dabKgMrJSflOH7u8U0C75omKiIH+aIyS0v76HjiiwwEYQQSUZG8p1
         6XNixQ/w1lclqm8pF8oHPsenguRZFjW0PWGL3sEhjBDiA6XNDWsqOZ124RcgkCXotuNv
         H7i2/6+eJZN3uYqIyxFYt6JvWYYR1lp4hRcuAuNq1mUhipAW++TAiJT3L7m4ivzMJk8l
         nPZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783453638; x=1784058438;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vfGwKSNbrl+nU6kvbTrSHfyfMmoFAmwmGff/pR29LWo=;
        b=bJUT4TgLQqzHmCaP/jDBHfzkXKVOg2nco4JxHqVFb08MNr0UsFUrmLl04EVHRTVeuj
         SSCHQBEtE7JfZnFFDVMoWnuzsUTu2C5iYkjRiiazZygE2qJYxO5mxWF3/nZRZlaHosNK
         KmRlfoR0gOV9as/B4IN3EW0/l+jpDpcvduXxargYYUlzT5tldjOrgFxDpQviieTmGJmG
         skjYdrSza+sf2mF2v0Y0PKRyo2jDcZlh72huIhTnDSDtJzR4tbU4EnRbQgVrKWfWAcFx
         KgkNwne4/vI2I5PtIbo/hQPfmVpDSQp/M3Z8h0e6Z0uM3/3N31X0NCkHbMLfDzRijPoo
         9cew==
X-Forwarded-Encrypted: i=1; AHgh+RoL0mKxMYHbLPyXbdO6I/gSKJ5UD71U02Y27pnrJ/mVa85EuaTT5mhfdOnGRvbnhiu3aN514MV42w==@kvack.org
X-Gm-Message-State: AOJu0YwFw9kRusu2/4CTPpIXfVZqzgngwspWF63bTOSwXqVW0b7phKWV
	u9qdd2LGxQvSbxizwBe9f8SwUTA+arLxTRR9nH/up6HBPnv1ROE8c5Yp
X-Gm-Gg: AfdE7cmWRBgZDe0tDkdfybmh9Y4FFMgndEC+MBQ28Boc+ZdkiGhWd/LNHToB9dOq4cU
	15zBAW9k3BXzj/2doXsuffjMjArTQTOs+qBKQvWSqR9X7OTt6V8UFluFxAfo8ama5HHbJ2NI+4Y
	qQr0wilfkmojdZx399lTFYUmQsRvmRQvDlBksARQfTOzFAkxBuFrx1vlL8kuy5N2XwLJX6kH6iq
	WLXAh1BDRuodMnWLwCIeVU8MtJ/RO+9fKG71sP5Abnae3qoqkunKS49cKfBy+jSXShMQI9ToDM8
	V1zL6OpdGq/XgXk/LFCvTFLzCV9eLb0TlrrQbuGEQhpT0Rfy1tWeunoOyGgMgfQHDYAmzkykOuy
	dP8GH4/IUWY7UzdYNf3rl6to+9CeShPi4NUe2yxzmORBw4w8sgfFgVGcHcBQyqtpYYdqeLlAji1
	9J4FZ5NVs/1dVv6xltAOiJB/75/mpGP4833XIDVw2Ot9Rli4nf0VWTEeX4wHY=
X-Received: by 2002:a17:90b:2e48:b0:36a:fcf5:64d2 with SMTP id 98e67ed59e1d1-387573b24f7mr6589891a91.16.1783453637572;
        Tue, 07 Jul 2026 12:47:17 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-387d36675d5sm1660092a91.12.2026.07.07.12.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 12:47:17 -0700 (PDT)
Subject: [PATCH v7 4/8] mshv: Use hmm_range_fault_unlocked_timeout() for
 region faults
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
 corbet@lwn.net, dakr@kernel.org, david@kernel.org, decui@microsoft.com,
 haiyangz@microsoft.com, jgg@ziepe.ca, kees@kernel.org, kys@microsoft.com,
 leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com, ljs@kernel.org,
 longli@microsoft.com, lyude@redhat.com, maarten.lankhorst@linux.intel.com,
 mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
 nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
 rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
 skhan@linuxfoundation.org, skinsburskii@gmail.com, surenb@google.com,
 tzimmermann@suse.de, vbabka@kernel.org, wei.liu@kernel.org,
 skinsburskii@gmail.com
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rdma@vger.kernel.org
Date: Tue, 07 Jul 2026 12:47:15 -0700
Message-ID: <178345363584.660027.14063544694872741718.stgit@skinsburskii>
In-Reply-To: <178345345668.660027.2952911919681614557.stgit@skinsburskii>
References: <178345345668.660027.2952911919681614557.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A4BF820006
X-Stat-Signature: 3zrr56r1wdbpzexoipur4f36jgwj36w6
X-HE-Tag: 1783453638-699672
X-HE-Meta: U2FsdGVkX1+OYRztQUXQUmWjPUMA6aUf+3Vy8EA0jLJgjVb9+vgHojLSEuD2pgReldrR5tysmWMR9hKwb3r1fJMn9FvhWG/7PHDxXdWTuyuOF4YrJh4/DLsqZ5KdANSs1kkRsyl17xxtD7QF5XJ9r0rDrEvlIFc/h+8JaUnwica7osva5SBlTrsr0bY4s2EqNybsFrsKsYJfBFJuD4A1sZfchwhAROmyzUZCinZmifi4A7pxElU2Qhl5njuoFW6zH/7G73W0DLpnZCzbiFmuJJsycCQKCDfo9cJdAUNB3OdYed+1t3Ud41A3NYKh4S42xgRSd7Cd9a/VwzdDQ+GVOGL+BUE+hkbaVQ6VRD7yAM7/LdckOCY6YLotV/OwtseqwlEPiW35xGBiQH+KjrqdpS3Zs983csCREbJmDwVune8jNgHHNEe3w90ZPFJvDqmOITK8qWUNPxfdem+Y7LQejTrskPR1TIoVV4UKXxlNKk3ZiVZNTVL8b63sKI40mEjHoXkn0wrqXKO0lZa0eunfoysO1Fl5E+1Tlu4PK6maf5bOznzrpd/W9gCTFCqrtr8n4Sm9YjPcQqy4nmhCbRPVSZB6ODfB9Gw1y1gz7J98nnKi9M4YckkZhPJYXhYzS3/1beQHMfBbBmnfRaKIEtZ1hUiBtU/9O7ND+egU6U3tdUujntGdnNajYhy/BBXFSjwHR70wU2tBUJ1WJcOV531uiozfyJ92kpEUuIrG7XInq4CrhsBRKXcdqEy9k355Catio8dNnwo0cZgmvfVw/Tm27BAlCNhU9bs4l0v1x4drRbBJOO5/BUnnNCvFHvyVVXLo4GQqJNspSszkUt98yjIiTDtPuZvAps2Q06p4fr4edeIAntBIbi/bZpSXnJoW3AITLFota65z+ZjvbJAlqu0iKQGEenE0LEgCVSaITEck6Ego6Vq/3/4kjKBW2axgAYDI6n0IlPYBZvFLcQqmK6o
 q3uUQpbh
 mb/pLobBU8GolZCDPE3/IkZgPbTM3YyQEcZgYC8ebxJXo8snAFj6CMaMg821KAJPzyf1t7CGvOzivQ3gIDY0ux+ZrW3+fi2cmPERpNvbeh+PZnM5ddJmEdU1bfuYpy86TVYL5E9stDzILvazU9XYqp8YYvW4wdTIs3z0NfZ0Coef9N9ZzZKsRmBOFILfAOpx9p6x6j3qf0En9UuLs1zHp43MuAh1gYNFLW5RN0zMBlnWrtOeytlcikArkpzgvgKI+YtBfixbuPdQtonWbhjBPykmR73+9RQVLFgHKNouUHzt0MgxK/0QKZ6P7/POGBPF7M4a00zATvLPHzkeFWLfk/uwohyV/o87MouqTKnF0qyuN2b1D97A/mr36HSS3NixFRbVJdU7KGLB1OwVR3v//OzrFHQ58oqWmTo4ApoqtuJ4Dxtsxp+Q9UaBnxGhLnp/H18R05+kX6PeWb2yjsvroW0tmwaavqduM0uajXDOug7GT+QIeAUPbq2q6sZS5KREJFTuaVAZbXYgISX9scNa0yXTe/UmIi1LcAOjKZ0H9Z0YTcaMsGJpnkQRq7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MSHV currently faults movable memory regions by taking mmap_read_lock()
around hmm_range_fault(). That prevents the fault path from handling VMAs
whose fault handlers need to drop mmap_lock, such as userfaultfd-backed
mappings.

Use hmm_range_fault_unlocked_timeout() instead. Passing a timeout of 0
preserves MSHV's existing unbounded retry behavior while letting the HMM
helper own mmap_lock acquisition and refresh range->notifier_seq internally
before walking the range. After the fault succeeds, MSHV still takes
mreg_mutex and checks mmu_interval_read_retry() before installing the pages
into the region, so the existing invalidation synchronization is preserved.

Fold the small fault-and-lock helper into mshv_region_range_fault(), since
the remaining retry path is just the standard "fault, take the driver lock,
check the interval notifier sequence" pattern.

Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 drivers/hv/mshv_regions.c |   54 ++++++++-------------------------------------
 1 file changed, 10 insertions(+), 44 deletions(-)

diff --git a/drivers/hv/mshv_regions.c b/drivers/hv/mshv_regions.c
index 6d65e5b42152..dddaade31b5d 100644
--- a/drivers/hv/mshv_regions.c
+++ b/drivers/hv/mshv_regions.c
@@ -381,46 +381,6 @@ int mshv_region_get(struct mshv_mem_region *region)
 	return kref_get_unless_zero(&region->mreg_refcount);
 }
 
-/**
- * mshv_region_hmm_fault_and_lock - Handle HMM faults and lock the memory region
- * @region: Pointer to the memory region structure
- * @range: Pointer to the HMM range structure
- *
- * This function performs the following steps:
- * 1. Reads the notifier sequence for the HMM range.
- * 2. Acquires a read lock on the memory map.
- * 3. Handles HMM faults for the specified range.
- * 4. Releases the read lock on the memory map.
- * 5. If successful, locks the memory region mutex.
- * 6. Verifies if the notifier sequence has changed during the operation.
- *    If it has, releases the mutex and returns -EBUSY to match with
- *    hmm_range_fault() return code for repeating.
- *
- * Return: 0 on success, a negative error code otherwise.
- */
-static int mshv_region_hmm_fault_and_lock(struct mshv_mem_region *region,
-					  struct hmm_range *range)
-{
-	int ret;
-
-	range->notifier_seq = mmu_interval_read_begin(range->notifier);
-	mmap_read_lock(region->mreg_mni.mm);
-	ret = hmm_range_fault(range);
-	mmap_read_unlock(region->mreg_mni.mm);
-	if (ret)
-		return ret;
-
-	mutex_lock(&region->mreg_mutex);
-
-	if (mmu_interval_read_retry(range->notifier, range->notifier_seq)) {
-		mutex_unlock(&region->mreg_mutex);
-		cond_resched();
-		return -EBUSY;
-	}
-
-	return 0;
-}
-
 /**
  * mshv_region_range_fault - Handle memory range faults for a given region.
  * @region: Pointer to the memory region structure.
@@ -452,13 +412,19 @@ static int mshv_region_range_fault(struct mshv_mem_region *region,
 	range.start = region->start_uaddr + page_offset * HV_HYP_PAGE_SIZE;
 	range.end = range.start + page_count * HV_HYP_PAGE_SIZE;
 
-	do {
-		ret = mshv_region_hmm_fault_and_lock(region, &range);
-	} while (ret == -EBUSY);
-
+again:
+	ret = hmm_range_fault_unlocked_timeout(&range, 0);
 	if (ret)
 		goto out;
 
+	mutex_lock(&region->mreg_mutex);
+
+	if (mmu_interval_read_retry(range.notifier, range.notifier_seq)) {
+		mutex_unlock(&region->mreg_mutex);
+		cond_resched();
+		goto again;
+	}
+
 	for (i = 0; i < page_count; i++)
 		region->mreg_pages[page_offset + i] = hmm_pfn_to_page(pfns[i]);
 



