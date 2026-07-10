Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FBF1C44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 21:27:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AE2D6B00CB; Fri, 10 Jul 2026 17:26:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 885436B00CC; Fri, 10 Jul 2026 17:26:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FEE56B00CD; Fri, 10 Jul 2026 17:26:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1FF326B00CB
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:26:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9B2EA1697B6
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:26:56 +0000 (UTC)
X-FDA: 84974152032.21.090F6E3
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf11.hostedemail.com (Postfix) with ESMTP id BE46F40003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:26:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=T7XFjlpj;
	spf=pass (imf11.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783718814;
	b=eizBrWpsF0BujM58DTJqKXM1rvXDD89MQBpLvAIOz4C2s+IBaQ3toryohuMaDZjwu02pQS
	ki7a8KdsKHjgVBnOjQSMptuh4N8XLWgDx4WKrbpstY8gwHRU6GtzOCc+tWJVRH7hcUfwP9
	QFB27U25K6MFbtScbp2XUOxaBjUDtTE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=T7XFjlpj;
	spf=pass (imf11.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783718814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3sr6piRbjR+cpoS2FsjQdy3tGYWA8BG46QjFZOECUzI=;
	b=zT6Fhjjp1PwW1rdFXJWStdRsJlJs7fOVbdcM1tCQCt0rQTAS9aXI1J+i6xTR1jfz8ycOkp
	GL7S1IhvnqhYBvwiNLLG+vFclRB/nu++gUqO1/7Nl/MRZvZaHLK0a358DE4gHcIpQ7yYVw
	Q/gILmf4YHrbXXIW6AwiyxjGw47NHv4=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2cabc0a1ab6so17032935ad.0
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783718814; x=1784323614; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=3sr6piRbjR+cpoS2FsjQdy3tGYWA8BG46QjFZOECUzI=;
        b=T7XFjlpjHL2z9iHMrox/lroQvjwqT9GquaRKV1a5iAyY/t/+WHAR9XbhElWWnT+J/S
         PRf2kjgX6Ej28jajBRD4O8L0jujPmx5O22iEe4nLJuIkSq0fIOg3tln9IO+N8Df8BSyG
         TkpEguoc9OFyi/JnNHg3BcSq0AUzEEBLLZh6dCBBl8uhN8f3kMNpZcBJx3OLVGWxPX6m
         vcLwKJ5pMTv3ld2WcVocuYJQ0ZhNfc2lXVozZtHTZDAFAM05IpruHNkYdop7sFjPJ6v7
         mCidXTISZ/d6lerONvEkedXv6TdoYMLA+1i9EQ4XexsMIRIc7/MTocZnZoW7bA3uEMZN
         RHUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783718814; x=1784323614;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3sr6piRbjR+cpoS2FsjQdy3tGYWA8BG46QjFZOECUzI=;
        b=jKXAb7APAisBbBpr8PbuQHKgEbsJntgFl2YnvXwnynxoEZ9bbQanuA6bbHdS9jaPXf
         GePLDAXaoHnGJDPLp1WsdXlFeX84DxZPV1MDNeXMrPqAR2MuGEmZWuraDSvfyOt2ZaNP
         QtOFwplHAuEaKob6KcnIv+hp5k1AJHsK/BI4pdfsDsGK+7QiWsgEyo2o+Ep+Zs0SF4Y1
         5VnD9n9Ik6arWK3FCSUmWvx4kd7hSM8ucQgPAT9eTqtVOb2sAg6XA3Ng5BpgWuz5g2Ne
         7K7nGj89ZyCgHrAl2JIAvUIoxbuNd6IUeG/7AJmk931o7grziCo4ISOvopLuVkWbU0C5
         NHig==
X-Forwarded-Encrypted: i=1; AHgh+RqyTk4oN5R3NYK8X8Pe6TzyAoQ+nOK+l3yCGQ9NVIXR+yr4cOD79Ala/IO/vk/t0qpzlOhtKspzhQ==@kvack.org
X-Gm-Message-State: AOJu0YySOtKFSmJWcpHwnQ1vii2kRIk5NqmR5wjImSQRWgxCWexKsi7V
	hGaL012ZJWWqOcrJRBsUvCVN16dWAgpb6Fwn2B6OEfG+G2SY82opQA2e
X-Gm-Gg: AfdE7clS9CvVMvOZEcgY3jCS79TPvVe1BcofwA6kZkJ0IPRk7gkIQqjIubJsS5wU2mu
	XPWEwH80pLA+2At2AIfL2sHJrNYVKa7F72EqMlGq2iNhLKlGJ/DiC8tNsqmgmX1xWP9GmVs86AK
	B5iHfHA59GJvtUo2MjMME4s/Y2ESNm3hV6fqao2KZHZSoEnFC4y0KZ2t6dUPU9rzjnctiyibDSD
	I3LTlxFiZuPupiUcSyzgoLGH46BjCWhoVZg7MqKIn9oNr07TYvt8C4pQD6MVPgVeY58RMBn0U57
	+QrFwweSnslCxmX9+6KXVm0B+cf4w/BQ5xd9mBivrrbIW7gRiECqJzxRMUC8OFm7DO/5wd1iZKz
	Xkd9u2wgtxXR/PLsLTCMtTyMQq/HEQLpP6md10dWw40McvGtyWjqwoGZSH7OVSFtQt1+ghEpjlf
	i2F5CklHN1rP8hCcYUCCxsSjM+6sp3/D1Zt6W3lerVHi9Nk88ZF3pWNL5v1ZM=
X-Received: by 2002:a17:902:dacf:b0:2c2:7baf:139f with SMTP id d9443c01a7336-2ce9ef1bd15mr7721375ad.30.1783718813633;
        Fri, 10 Jul 2026 14:26:53 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9d1e0c4sm66015545ad.49.2026.07.10.14.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 14:26:53 -0700 (PDT)
Subject: [PATCH v8 4/8] mshv: Use hmm_range_fault_unlocked_timeout() for
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
Date: Fri, 10 Jul 2026 14:26:50 -0700
Message-ID: <178371881034.900500.5214601525971121683.stgit@skinsburskii>
In-Reply-To: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BE46F40003
X-Stat-Signature: nyufgmik7zz7cx4zkpdzyoz9rcobwiwe
X-HE-Tag: 1783718814-173402
X-HE-Meta: U2FsdGVkX1/Wk/vF+dLuoSI2ITNumUW/jGTylAQTGGIwf5FE+TXutPTudcjkAGIvjZT6riFxgwA2tfJEZrN6yiuGZGw7P6I6wkSVb3tcT82qL4n0sFw7gHcviSgZPALHBby6hB+4Ca4qIuGFINdtfsptQD7FH1i85cSy7cQeD326sH9obqBmhYwIwGNOZWWnbKA3RXyi5xEOVwoOraxyFh1i9EaWIoO6Txunib8BuK4ToAZNAEt9OnWrYoZIyYD3UAP0QfYaLkcPbhUhzTQj62V7TJ8LWNaHJZ35eKTkV1kKusPuBO4f+0o3LP8UjjJJtEtMtR9aNBXEcz3iJpCcu3w8YhivxO2FcdGT4lm24Cb8Keln9318jXxw+jecy5eff+TBf2Lux/IR0REUBgkLdiiO1wedn2clsTYFrZkqVZwVw695AhGuQjZOxQ2fRZ5utyrwGwfmKFInWEMP3mfRWOQeQxfFKxYLdKwObj4fm/rJECedj06z6OZvmMpyS0i+3d8IrjVh8KE/52U5BgssxsU5nV6yCwJ8dyPJ1QSbFm4EincuwWOcAoNtoJNw4MnNy4UBDizqwDAcZNZV9npd6cnWWU07BIhTIwtq9xUh8HGzazW7TLruyxlwCGDbP2LcSrejTF0ydMESELbb/JcjDeVTE479nhf5xhU+38Yk9KGf+Ko5v1GI40etOZBYBH+MAKTKfxTuQmxIk9BjQZg2v3NMQXI0oaTs/tVKmpKo1VhrWepB8NjXioh3YUbdJjdyVdSB27vDeRr1cvuW2RlXba96nBZMT8nR8yBHBvpd3uJVy38frgPFAOyn/sEj17qJ89AOmzfJFXdSrQD3GwtkUu5kiF7CVSkQBoVVE9d6A/Qdx8yrY6t9F1ZdWpq/G8tTdhCVlndSDmMNdPtvBsmpLWuFyDVJ8vTKhQ59DQQW+soZlxTXBC/0POCHoV8DxAxNq49Hib5NBEVby9ZwX+3
 11iot3Wv
 0JpCw9S2cdS+JBr5fQGkSOkb0cZp9CJxSJi4lEulY/eB+ZSPxCSzfAAZcVDdoBaN3Clbx9sSgYHSad1A36GE50ZNTFbekphR+2SURB6BCJZzm4KpJ+8t+9f4qOpKWW/vpnWOlNvw0XcP1oY97wZnuPJ2lHS44IwH9dmACvt66pMDE1LmezMs3p893KgDbN8d0bxAyxyLsgPKiOp+GaY47vqrKqiqA8Cqin8TCuJGDUKFtZtNhb4pjbc9E7zmb6MVPhYZ44hhyJ02imz6p2alb0s+ScjpgaqdVGgPfqKcrtaTR4eOOW73v2Kx/v4OppNdRxIvnHhGlLimgOWmNhenW9Io53BjSBUKsHMt+OV8ZBLhEOlgs7BPeHrHgQbAFdEAwUFrebuKHj7Rf68+IlY0MLI4qRoJ2APsgh5dXGNiP90Huj9lNC1o9bu8/RFQijrnVGc6BcEmgtYdBOcVNmrf39W6CN05lEeih+1m56kU30nfYj7rLqcV6/AodI5mKw4ig7vkn6fhiG3NWi5cH78G7ZPmaIXpZR1cUINXNjXcPPejiFMYXaWFz+qqNBI9A2MuwVYWEGL3+XGBOVsc=
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
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
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
 



