Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1724DC44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 18:16:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCA596B00BA; Wed, 15 Jul 2026 14:16:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA2516B00BB; Wed, 15 Jul 2026 14:16:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABAF66B00BC; Wed, 15 Jul 2026 14:16:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7183C6B00BA
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:16:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F2D52A02D3
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:16:27 +0000 (UTC)
X-FDA: 84991816014.01.E880142
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf14.hostedemail.com (Postfix) with ESMTP id 20151100006
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:16:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ODuOg0lf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784139386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hJyDStROVAjhZv77Mf9h0pLyMcLfVsgmfa9JsYP9Vb0=;
	b=SteZnm5eaTOZUfYztXd3gguzOZG0XUnFuHwMRi3Jp+5niG8Yaj/eVN6DlacJBv6dz1sjxW
	dJOnpHEY5m0P/WghRlsyZ27UWSMCbB4eVC1BDPhY8zMeii61zgIuNCDajkHKiSTQ9bNLQY
	GnEmOkaX6NhmhDmuSvh+nLKYvYIpYwc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ODuOg0lf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784139386;
	b=slDUWy5xpLFtXD8owO2M1ENg8C0px88PUsgioj8leGa1vv4kKGSo29Vg76tlf56DI/eEyU
	FaINug9JloqhKdf3fN75+oN1yBDrJ9LXyqQLFMjYAijCPUjY8vcEtcBXLBoYhnQ2REGz8t
	tRzDllwfU8x/GmPfZh75awd65/dpvLM=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2cacf197759so40562185ad.2
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784139385; x=1784744185; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=hJyDStROVAjhZv77Mf9h0pLyMcLfVsgmfa9JsYP9Vb0=;
        b=ODuOg0lfbKloo77HeAOiSMBGYauzZl04iAn/XbBRmYOFwS89pUmZbxjjmLmfxiPtbN
         9mhe0DkrXmookpwVB6v790ExFgbV3Guf7+Llgp81086CQZZ/mql8R4JVEIdqAD8getb6
         MXw41xpjIJX029ytVUrcBXOPqa5yZw6H5B7k3pLyNdC59PSiWK6zG8G/oCeu7QtfoORe
         wxZ0o14b6I2Rup4uaXLTMX5zRG32gpJTrklIxUHJ6mE5Ah1AJ6+Ay0vbO7bM6QJkybZ1
         GvPNNMxlBpJtBCqGC/8VHbIH/io46+ySZxLJ6m0qp30GNDHV3Ac8X7ZK/8XU9o70cae8
         bH3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784139385; x=1784744185;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hJyDStROVAjhZv77Mf9h0pLyMcLfVsgmfa9JsYP9Vb0=;
        b=UUiTfhx6gSeyFePMlNeq4+hvroUHn+9i8orPyh1DWVVv1ILdHhEv/HeoPAAmGq9raU
         eRN3CEeeiVE6zkdQI/oobEIcyzu/RuU6M3pSeMa2z3ahN/e/6R8YO5tol9HGfTePB94T
         tleOe++a91oTX3NmRUZsX41m4i5/xBYBTtQ4dm3kBPwQq/A0OFUEF2Z/9YoXufKf2Uqp
         N9iYtwWqllY1gVOgX4OXAB1oUq4O+ZVJbi0hWFD+u0QEcWymdI43deU/y7tRL4eRyr1y
         NnX0MwzEo6CbO3NJ51ZrURxVPCDEzqtg/wtjBULUJwaLQ9sCwdTusaB6Nw2P0gVgV3GT
         jPeg==
X-Forwarded-Encrypted: i=1; AHgh+RrwakV4qP/VBX4QTDwqbm0Y8DLKwtIlC64TNf84SOyfOv8oUj8VXEO1CR776yqJVH6kCu3OrBmyew==@kvack.org
X-Gm-Message-State: AOJu0YzohazO5yid5QmSHBZGBcdIz+MnOgRXaI64DmJ7/vDHj3sv7e1Y
	1SkJRPcm0ZL4PtZ/HrVPLCKwCjSCzzQU7Dl+Qqx4UB2AC4xBTFULwG2y
X-Gm-Gg: AfdE7cmbPwUsQFl35R4VO7R1sA/xrzLFN0/XQddYk676qV8pR0SqgYBjyMiiCin0KCq
	dyl+ycD+eodQE0MBn0fP34k07Gdq18sINYJTjXkR4cUOBWrJ/gMP3iSEHU4Rn49edoU1l0z3EsZ
	BhZ2Nv3aYekG93GpH0/2Cmnt2wWsLbm62WSfAAAs7sr8IkI1br9eEvbQMeikWo5WYnY9ED6/o77
	0rQqhhaoVNA7K+Qs/zo2dzEDGdFos+POXmuVbkP7rpQtnR1aC3dZE5/CEguSGwA9E6snfmW9SEb
	bZoxOeJ2JvYx50o/jvG/1Dl+Oeze5dwaheKtI9oQW3eQF/Vn0EUKrASh8LWas0tzukPi8TfQIDJ
	/Nsy8Ph/aokwSTqNamz19xwxLjIaN7YPZvojxgv+SYlECbD4MTu7qO3IGUHX4uxDCbBo6MZ+dPX
	5cqnWB343isKtt17f02wWyuLjpWpG2UPxkp5sKC5+nAUws3wdonWXImN5MmW0=
X-Received: by 2002:a17:903:19c5:b0:2ca:bb6:e7c6 with SMTP id d9443c01a7336-2ce9ef22bc9mr189071215ad.37.1784139385005;
        Wed, 15 Jul 2026 11:16:25 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf0fdb3a0asm7052845ad.0.2026.07.15.11.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 11:16:24 -0700 (PDT)
Subject: [PATCH v9 4/8] mshv: Use hmm_range_fault_unlocked_timeout() for
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
Cc: dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rdma@vger.kernel.org
Date: Wed, 15 Jul 2026 11:16:22 -0700
Message-ID: <178413938249.1155966.292562154596800687.stgit@skinsburskii>
In-Reply-To: <178413903133.1155966.3904063656020521607.stgit@skinsburskii>
References: <178413903133.1155966.3904063656020521607.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 20151100006
X-Stat-Signature: 9fycz4qdr6e558ydz5af1u4tgtne7k5s
X-Rspam-User: 
X-HE-Tag: 1784139385-571373
X-HE-Meta: U2FsdGVkX19sVo6uHaocEPagOaWKKYFaM6PsNK2xJADK+Jy4LYbO4rXlNLEOhgd9BYTTT3UtBrXoG5eEUEkNfpk1yMCaw6s0Rs1cKYdN5YvTGlXH92t+yxxxMTxH7HtYkkBiEIf7Zp2jB2oWyhOvcwWAz1ZNM327YEhDmPM3oo90cCowke1rj21waQoSWB/uG79SEMx8TccokkGhqom6M5qI8Xhju11t9qFP0YUi4ppH78XnsX4fHYlWxN1qDim+vFwy21/SaLjgfhiscCPAVpe3eeLpoDlNV3gAVlWLJoMIkEgcTtFEgqSbuBfjwiR9dDQJefRc04zdvtTk66EF6BCcMokt1Cn8DMf1uYc6dIfFQ/v7xSZu8wSTp+NmJ2zMKy5xF56eREsiQyNr6id5/CZgbiiguGcfLb3yPytBOSFq5U/Mpl2TRvpoVqpCy7E5IWhwIUdeVFxnvzENoVCNRkxJL61h1g8qUGF03qYaAN0yZK/uRobiG7ea1bF6eCIRHnBQ27+aJmcI7sNkmxm6M+fdRm93iFW0/kZCBotkCRWlryiMdJ4EWA6nbPFX3rsoxCyF5khC+iZXUgNnxnTEi60qhPlxlhIQb9QFLWSdylJy0NXJQLKySWfYFv3rdo9HsHilQnEbumhFbbVbpMTUGqC3ts0NSb4i2eZMPLEkhfNZk9y9vWTS2RjPrNznN5AofzEyebiGsp5GVHnF5QnwlStdixTZkEXyNVbSEaga0YcQnfSCTGwM8Qhot8MEg7dflC7TWVkUS8BLFbAke0FWLl1gS+zJHJc+vyXI6nbyoBmuaIwvHuYIbWp0GGAHYHASqMiy7IC45zdVHS5RZ7QoV2iy/ociKLjCIOmWXxWxOM1O3wjI7FHkZwp1G5FS47/rWetepGAAPKybq/L9tsqMvA8SNp2PpStSdslwEUitOiri6i+YhX8UUqF91VGpKE6njhF6a0HsUjUEbFC8fv7
 WoTvbfuY
 fhjD7S5OYOtHDX1GdH4dAF9QoBPRJIjmY5d+1pyBHy8P6JM65cNNW8zjolpS643gRLX0Ncd3Y1qHeF5Ltke/Doqit/EQN2aSRLilM0OPe9u+PyR0Ca/lE/XUwQbtewaisol6CkukHgfyAocSffX1yB+fXD1wzDhIz8BPPDxthIGS5mEkEpO0z6geC8iw2O0Vs+kWcsigjJxNTMiSIEXwfwNw3OPin1XOXCxVg9NLDMzB7ch3ynzwtroaBSxnci9iYLOm81elVHe7E37XlIUPYbpAoQ0XDqLgNfemYeGapHWKWZJRGbVLlQ7a/eenPp4rdyyvZ5FqgrTAiRW0PIgbamEBrco1vsV/6U3lLSRQXHfZWKEHAFGe0zpzSHY2KUZ4hs6kcqIkCB8IlM0U06rB6Ry//Ra+jyFBZeF/K3i0O+pKOKkxaTXzHnqOkXeoKn+H391cezRbI7vIMvcvmq+VzD4QnUGPdolu+zwKBUO9LxfuyZ6pZ4dho4R1GYDMiiTfDjC8qvvLvOduJDEKAsfXjmLP5siSiOtsA+4Q9PtgW4YZHzfOsMx24ZkzPQqX6L7cHnKkdHueLnHi1zeKCH/N+WleR2K5WLnKvCBQnENglbeTAZxwgWqaB4Et0UfGuT8K+51JO8L1ABrUHVOK/lpLp74WZO7FGqBZeZNIixG1aCXuMYDW3eQUaeWBWPqD0fde1T7buhqXxt5tPpIo=
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

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
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
 



