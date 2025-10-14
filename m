Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD92ACCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 23:15:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 230588E0140; Tue, 14 Oct 2025 19:15:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C6158E0041; Tue, 14 Oct 2025 19:15:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFFD68E0140; Tue, 14 Oct 2025 19:15:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DB27D8E0041
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 19:15:12 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8AC081406E1
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 23:15:12 +0000 (UTC)
X-FDA: 83998277664.26.D510585
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7F06320008
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 23:15:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gUGjyPky;
	spf=pass (imf03.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760483710; a=rsa-sha256;
	cv=none;
	b=6pJoBn1TOgcaJg+AFQul7c5Cu2xFjb3AQ2z5WHZgp0b9JAHeV8taQTD4RPk5F3i89CKr/Q
	UpX+LHNqf4YO8Ynle6wul+jgZheGt+tskDGsY3IC7eEaanwYALDf0HkACwd/CCnN/OOwil
	s1wjmuuqQzby4qB26GF5hdkEh66DJoM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gUGjyPky;
	spf=pass (imf03.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760483710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nzFo/w0Qj8OvgfMsejgN1W3LOUb+8BQstccWgX+yOQo=;
	b=s7R5AqODYxdjphZSZmCNakk6+pWoTMqSWcn5qb6cdF1B5/4uTrgfXGsbaLqAle2pdlUiZf
	dmuKjMj1RKda4nemo1y2F4wKYGu2E6mHZd2cpfeYdMxFjVAde39zRT5oPo/6xryFWpHFxW
	/ymjSjdieMc5dVPVrQGyMa/5+X8Rw08=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760483709;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nzFo/w0Qj8OvgfMsejgN1W3LOUb+8BQstccWgX+yOQo=;
	b=gUGjyPkyF/RaNN+Px6jUvtUyjrPDMTpIrzkQ2IQLv6gUxAgwbM4D34oyhLMOpsB0TQCgI3
	bKDSoGk+meoOijThjLmH4uNr4CA2pdMPvZ+LSaHt5lBwDjcm+t3Rr9Di2ORBb4eM8+gdx6
	18OrrgPgZgd3yca7qoff/7Y5Un4dN0w=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-36-p8ld2igQOoqc8G3-LjM5JA-1; Tue, 14 Oct 2025 19:15:08 -0400
X-MC-Unique: p8ld2igQOoqc8G3-LjM5JA-1
X-Mimecast-MFC-AGG-ID: p8ld2igQOoqc8G3-LjM5JA_1760483708
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8645d39787bso3778718985a.2
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 16:15:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760483708; x=1761088508;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nzFo/w0Qj8OvgfMsejgN1W3LOUb+8BQstccWgX+yOQo=;
        b=XRsFyV5u9JW2c7vfrqhfckehKgpmoUs1N9FBTIpKK0jy9OXvEx+5UTouRE8atM2BJ+
         1SRx67EjEnvyRuBeqNej3T/ErFZu5UVc1JrSThJcCPYKcImPjDjQNGuv09fqinrGU/hl
         EUPY4Uld26KZFP9UWeW1k5bffHiSspOLHupXCtf5P1mgs1lbecVlt4YwAS3CQ7ALbqJV
         NdZo24H8f9LC7mVXdZK/l60aUS+RGSLxILQVKNpPFNReqmb3ECIA20jSmZ6VTQQboaT5
         C5PxPsSYo+musnla7fHSWHndyvg8HVm6d+2y0N1QShQ+ISrlXeydWqU6u+2/7cM9Fza5
         PC4A==
X-Forwarded-Encrypted: i=1; AJvYcCU5TS6+MHJbbDfGGVbg+JWQqiOuofzPSs7dAp50H/sQJkiq7D7mQAIEsSfVfRu2OBfpZu9/bpFzmA==@kvack.org
X-Gm-Message-State: AOJu0YxXn/wM0qXAiiqPMQn1Ldu+qtXr3HYf7kdfMC+LqQFuhCx0jzKc
	MbnDgP4s1qmn4ulOlLkuL9LJRqNss9gytNTGb9z1XWqRd+m3xbJyyAcY2YVKDvxhxO8OYP+Rxl6
	2Ul8VPURnmzo/yBG83WOY4gUl1pVMqQ5l/a046/7w7+tbG3kMxBE4
X-Gm-Gg: ASbGncuyY9SgJUVTWBREFQhettDGRckt8QJ2vpAK4vYLjA2YTI7Vflnil9SznUk31Hx
	ZCz4iP5w/L5g5/6XrR1CV7Ax6xo7AVRatRGPxdz4IX0MJj+DHYj+St6+KnBAIq1AjC1Rfly39Gi
	2RNqxfSHhy4AFd0O0Ud15z0cvQXHeto5vOVSDUiRT5WHAGo9zpYVQekXUApAqvSVvQbY2OLSWJT
	zqzt0weTUIhfnye3pj/mPbpPrCyyzmtDw+3TZxX3i5k82vTzexh9e4U/ftXXRmOqpZ3rIdCjn1x
	pfyk8/VOPjm0dgW0idVc+q4i3qCvRQ==
X-Received: by 2002:a05:620a:410f:b0:806:7c82:fd2f with SMTP id af79cd13be357-8835509897bmr3876982985a.75.1760483707772;
        Tue, 14 Oct 2025 16:15:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFd/tIIPBz928gHS+Wnqdak0VkFeVFx8rUClYPU2w+ExFoWEFASF0U/Scf1/dE0/VkUh8nN1Q==
X-Received: by 2002:a05:620a:410f:b0:806:7c82:fd2f with SMTP id af79cd13be357-8835509897bmr3876975885a.75.1760483707106;
        Tue, 14 Oct 2025 16:15:07 -0700 (PDT)
Received: from x1.com ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-884a23693a0sm1280258685a.53.2025.10.14.16.15.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 16:15:06 -0700 (PDT)
From: Peter Xu <peterx@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	James Houghton <jthoughton@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	peterx@redhat.com,
	Oscar Salvador <osalvador@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH v4 1/4] mm: Introduce vm_uffd_ops API
Date: Tue, 14 Oct 2025 19:14:58 -0400
Message-ID: <20251014231501.2301398-2-peterx@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251014231501.2301398-1-peterx@redhat.com>
References: <20251014231501.2301398-1-peterx@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7mDGmf-yvWK892Qe8PUxMk9BAFgDrE6q7Bvzt9IEuok_1760483708
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Stat-Signature: chpn8ztmgngw7ahzpx3xfog1awge319e
X-Rspamd-Queue-Id: 7F06320008
X-Rspamd-Server: rspam09
X-HE-Tag: 1760483710-28179
X-HE-Meta: U2FsdGVkX1/HGaFs7UYW5/Azc6t0UJCSm+ezK3TrgOa07FhCD8lYoc+Ya43Sn7unW1h/L3pEy/P9FnyvbRumog9th03BjZmhS+h24cxPFjpUQAKQ2j4JOTDOYVmQaFqdA6dpx5QGx5cIXtuU7MK0phg68JQmDXeqJxXTfW8pXxcJ3p1RUqDbpCXathdI6g9NoITQmhINRT4IFOPp5y9DDwS2GfUUGx/JDW7co4Nr0SdRCpU6gE1VGhaOfVPjgJ5C9gApqRXzycs1CV55aAKN1ca0c80jipE8zxS8wqD2EiU4ZUi6hSrAG8VlYTbvsz3k9FSnk2Lt/v/Lr/BMN28CVrrRoetL34AppWLcz+yUQTHO+aNMeB3k3Rs6Yi+pbw/R4i8BCeoDuBi7xiSAl7rzogeD2sViLVq6O+fC2Zfq6MgY35QfrGUsrZlXNnWbfA/v6uEe5vLjDLhYDEKohmE+M805QJVqzfmG+RCCulov7Hm5D5IDTzacVuKmpjhNu87ewjr3JwZKbllwsILkIjbn3eZg9kbsRtBaIljPKLV57UePm3siqlmvVFYoc2E0EnMiR2wAChAo/GPkc+6y0uJbHA7W+EH4brcP5Fz/TdJjabhZIzkRfkftFQ1YXJHp3DziUwcs83PIwa8AtCorRldxJbRq6DLAdnZ1Ax2IK415Ta/dA1Qd58NFnZhvuAZV4kkyHOivT1s9HfL8w0AfpuOjGq4SOjNNS6unHKVBkW6bHPtNAylyEPXSop+jawH56adP4kPD1Th1ELUDxaZpEtyY6mCE+rtR2MuA0WRxQ6HQfj+1sXWRhjDFnxadpWmzH1XwXcn9PgzUFA9rKKmQmaqYiPg7LdSTlNXlwcp0b4UQeWaC00t+9Vbq+AxgYpi84Wub6WebOICwB8R8Hfg9uOEEO1SVutBeOKnvp5TLX7LLWxVpdtUV/WpyonN7ngO8AbcmCxhCtXlIqCxGJzTaOUF
 ZOwGM3cZ
 1DfOWFjsifMqX9tnBZfc6f/ew0BHEgmg87i4DRm14rLSpm+KUxi0ybfqIHa1KhCZeBv91513ho4k0oxlC+xcctzOim7/1FCITIw/5nYkse2nj2GyB5ZIJI9CP/HmHQ/hi9g0uzmIYtQNHyqOsbjZcLPvZfO70MjrmQHIYWkZEemlG54olGRv/psO3Ijs+3mVK7sF0e3ySEsaHpIouZ/y+LymxaxX1tPJYMnFp7ZEpvCRP/o/ZafoxaUmBlg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, most of the userfaultfd features are implemented directly in the
core mm.  It will invoke VMA specific functions whenever necessary.  So far
it is fine because it almost only interacts with shmem and hugetlbfs.

Introduce a generic userfaultfd API extension for vm_operations_struct,
so that any code that implements vm_operations_struct (including kernel
modules that can be compiled separately from the kernel core) can support
userfaults without modifying the core files.

With this API applied, if a module wants to support userfaultfd, the
module should only need to properly define vm_uffd_ops and hook it to
vm_operations_struct, instead of changing anything in core mm.

This API will not work for anonymous memory. Handling of userfault
operations for anonymous memory remains unchanged in core mm.

Due to a security concern while reviewing older versions of this series
[1], uffd_copy() will be temprorarily removed.  IOW, MISSING-capable memory
types can only be hard-coded and implemented in mm/.  It would also affect
UFFDIO_COPY and UFFDIO_ZEROPAGE.  Other functions should still be able to
be provided from vm_uffd_ops.

Introduces the API only so that existing userfaultfd users can be moved
over without breaking them.

[1] https://lore.kernel.org/all/20250627154655.2085903-1-peterx@redhat.com/

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 include/linux/mm.h            |  9 +++++++++
 include/linux/userfaultfd_k.h | 29 +++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5c01c4b59ca67..011962130c148 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -620,6 +620,8 @@ struct vm_fault {
 					 */
 };
 
+struct vm_uffd_ops;
+
 /*
  * These are the virtual MM functions - opening of an area, closing and
  * unmapping it (needed to keep files on disk up-to-date etc), pointer
@@ -705,6 +707,13 @@ struct vm_operations_struct {
 	struct page *(*find_normal_page)(struct vm_area_struct *vma,
 					 unsigned long addr);
 #endif /* CONFIG_FIND_NORMAL_PAGE */
+#ifdef CONFIG_USERFAULTFD
+	/*
+	 * Userfaultfd related ops.  Modules need to define this to support
+	 * userfaultfd.
+	 */
+	const struct vm_uffd_ops *userfaultfd_ops;
+#endif
 };
 
 #ifdef CONFIG_NUMA_BALANCING
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index c0e716aec26aa..b5b4f3f174b32 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -92,6 +92,35 @@ enum mfill_atomic_mode {
 	NR_MFILL_ATOMIC_MODES,
 };
 
+/* VMA userfaultfd operations */
+struct vm_uffd_ops {
+	/**
+	 * @supported_ioctls: userfaultfd ioctls supported in bitmask.
+	 *
+	 * Userfaultfd ioctls supported by the module.  Below will always
+	 * be supported by default whenever a module provides vm_uffd_ops:
+	 *
+	 *   _UFFDIO_API, _UFFDIO_REGISTER, _UFFDIO_UNREGISTER, _UFFDIO_WAKE
+	 *
+	 * The module needs to provide all the rest optionally supported
+	 * ioctls as a bitmask.  For example, a module needs to set the bit
+	 * BIT(_UFFDIO_CONTINUE) to support userfaultfd minor faults.
+	 */
+	unsigned long supported_ioctls;
+	/**
+	 * minor_get_folio: Handler to resolve UFFDIO_CONTINUE request.
+	 * Must be specified if _UFFDIO_CONTINUE is set.
+	 *
+	 * @inode: the inode for folio lookup
+	 * @pgoff: the pgoff of the folio
+	 * @folio: returned folio pointer
+	 *
+	 * Return: zero if succeeded, negative for errors.
+	 */
+	int (*minor_get_folio)(struct inode *inode, pgoff_t pgoff,
+			       struct folio **folio);
+};
+
 #define MFILL_ATOMIC_MODE_BITS (const_ilog2(NR_MFILL_ATOMIC_MODES - 1) + 1)
 #define MFILL_ATOMIC_BIT(nr) BIT(MFILL_ATOMIC_MODE_BITS + (nr))
 #define MFILL_ATOMIC_FLAG(nr) ((__force uffd_flags_t) MFILL_ATOMIC_BIT(nr))
-- 
2.50.1


