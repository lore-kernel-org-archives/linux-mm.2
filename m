Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D87BCA100C
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 07:03:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C89E8E0009; Wed,  3 Sep 2025 03:03:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89FF96B000C; Wed,  3 Sep 2025 03:03:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7430D8E0009; Wed,  3 Sep 2025 03:03:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5AAF06B0008
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 03:03:03 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2853A13B04C
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 07:03:03 +0000 (UTC)
X-FDA: 83847047046.25.B32B5B6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id E39D440010
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 07:03:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Qkmel6dh;
	spf=pass (imf17.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756882980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9yhEzid0coX4qzN/T+DJZ37q8NluTxlwBeVgR6BscUg=;
	b=t7VgbPbeo1gmUCX56N8/TTk1CeoGxo8AJIZV9c7sTc4iSmDSl+LLwr5nYLJcFzjRsIvJKk
	yTSGBfmmSjmlYaBC/4AIUo7psH3MayxU3F3G2rGhpCnvmzU25oUyiNXSVFiyh8StotlRqE
	4fImnXxCoDLrkpBZL2I2kzg1c6t7X28=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Qkmel6dh;
	spf=pass (imf17.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756882981; a=rsa-sha256;
	cv=none;
	b=UkNedqQwNXCPiOEFpXsje5c1bDygFqEw6UsTvLlGbU0sU5LgUhRfM+t/4wjj67hDakiBem
	Zh/jANu9gIv3rI2K3dXmphce9VoRWl901OX47ou6w9FN0r8WRRRz6YtSzkTtFP4gFADz0+
	diS5c6QLhAVxwJwR8aLKRssxUZ8xhgo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756882980;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9yhEzid0coX4qzN/T+DJZ37q8NluTxlwBeVgR6BscUg=;
	b=Qkmel6dhW9n9jCjIN8ijRbctAO4ROTsrpdAy4+vyohGQOAP2hTLdvRrkOlB1AgefUk+byp
	SWSBbAZRONmv5/EztzcUbQ/syI18C2a/kbE7bZq2ougWZRa7nHqt7WI1s1R6Z3HsErd6Qm
	j+twMBlqWjBYY0n28jz2yYbGbq/dm9Q=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-391-n8beVVAYMFWH1sBhxPHKpw-1; Wed, 03 Sep 2025 03:02:59 -0400
X-MC-Unique: n8beVVAYMFWH1sBhxPHKpw-1
X-Mimecast-MFC-AGG-ID: n8beVVAYMFWH1sBhxPHKpw_1756882978
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3d1fe9ecd9dso2943266f8f.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 00:02:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756882978; x=1757487778;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9yhEzid0coX4qzN/T+DJZ37q8NluTxlwBeVgR6BscUg=;
        b=e0JJW+rSfxS2udp5x7I2t0CtQRij7HXB9EEHxptPeL4ppmDIHMCe4WMvcjuJeWOyjE
         0Mgtcjx4z9YYtCAq1MmZ25QiSrcMJ9ZuJ6ACiN/A1yfjFFQyioLTU+fQiSg9t8fkdSs2
         ReSEuHdLpF8qORWsWm0iNIZKYdmNXEeTfjCqjO/tWioXmRuS8qB3wvurFHPgRWncR+ZB
         bPXRBIeoXe57CGYqUOqAXkIBjEl3ttgfpxtuNi446t1GKDVOgV++g7q2tR+GHkePIBvh
         9DUZx8ElOve2sAlGAMr+GW9y/IVpCuR/MnbCi28JnbEwwVCkEpa4micb02tDwSUTQ8hs
         Bf/Q==
X-Gm-Message-State: AOJu0Yzee1KclUKY8y6F2DVx1xBwnUBIEbuh1z9XcoeYuDPBmP/s/8Ik
	5etsFwYQaa65jRRfHh13fx9EMW79XG4tCD+383aFk0XHOtCGCA2lGgrr0xwG9oVkC0wQvQI15dp
	piolxzT0GVEkSu1J/O1+Bt7e7z77kDQPzOUIAn1lIQIk7cv0cm5wK
X-Gm-Gg: ASbGnct1jOaMt+toboLr+EWnUBQcOLbCUMbHYUpROKKXk8LNTkaraBlukshQeAoGA69
	i8EN0xqDpGDemlL38GK9rY8tnjiQabnS7QZKnRp0FrPoO2sxGtZEP9c85In3BCvjdj8kwDPWRBx
	hnoj115yibRhqlGIK3fZrbZ2GcC5vVXzuIS5yvFro6YSIS+LUlfzWcwpbya1HWxX50Yaho9XgBJ
	P51JJl9AbEnQ5DWe/HaH5upQWDpZzwzRypu5ER2QtoJXvfeP13cviVXOyFDl2jJnVwNyPXf29+7
	gCCWCnhHYkh8TprptVuTtCQUKpXllAIi6xmG5npqBLgHOU6doSFz6Vowl2QkL1GUb+QgwZ4/FP9
	s/KoRvR1Gsn0PZrJZSyj0O9a0
X-Received: by 2002:a05:6000:290f:b0:3c9:ad8:fec9 with SMTP id ffacd0b85a97d-3d1df539f94mr10808514f8f.58.1756882977768;
        Wed, 03 Sep 2025 00:02:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF6G9T+n01gQot9IX0ds2bfSowvj6oYMtabhkeOUIoI2hiuiSDp08eAIEryVuwexq/s1b1Xkw==
X-Received: by 2002:a05:6000:290f:b0:3c9:ad8:fec9 with SMTP id ffacd0b85a97d-3d1df539f94mr10808480f8f.58.1756882977316;
        Wed, 03 Sep 2025 00:02:57 -0700 (PDT)
Received: from localhost (p200300d82f099c0081732a94640ddd31.dip0.t-ipconnect.de. [2003:d8:2f09:9c00:8173:2a94:640d:dd31])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b6f0c6dc1sm309420145e9.1.2025.09.03.00.02.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 00:02:56 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH v2 1/2] selftests/mm: split_huge_page_test: fix occasional is_backed_by_folio() wrong results
Date: Wed,  3 Sep 2025 09:02:52 +0200
Message-ID: <20250903070253.34556-2-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250903070253.34556-1-david@redhat.com>
References: <20250903070253.34556-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4nPS_bLnD2v8TcX8bKX69pd_82Knnz4JrqC-GIJcC88_1756882978
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E39D440010
X-Stat-Signature: ugz5yitp1pexmpstbrb9t4c1zeeyhqah
X-Rspam-User: 
X-HE-Tag: 1756882980-3472
X-HE-Meta: U2FsdGVkX1/MT8aZfVjXCHIJK0ATU0QN3+puDMqogGUd0ODaDpdZSdqQpi92CF4+o4bJmMH+Omv2SJ83xdyaLcpnw0JbQCuzQX+OOu5TLzcRgs0bbyJWA3vzdOUwr7KWsB5NqY5uA2BLyW1cEdmr8lCs989KYg9Y0ZZ3frzZLYBouGlrtFeVHfM+ulnMQesD5bO/O2vopa6deI6mNUWulVstZLH9KPoqyzgRDfXBP9W4dhzke/RfAh2aVn0KQ3FeaekebGrSNMMgONXk0sl4KrYKXiJcZeMTmB6maPik+iV0TyX5X0jaxMzpk5xQKkjU4158WRymAtlnzB6qHq4LnkCpK49gsqfYoGOaDHw2QJWgIgHvpFVte5/OlH5k2nM7dlYqzLIop1s9ZHhlcEegZhwRF4tyFcbZigbfhf7TKg5WPukWW1BgYelXIdsRwHcXq8F8bThDGMabKUytWq6qlSNVmsFUKGsAQ9N0QWr+Kzp0GO2iExTzl2JRMIPtJlRD1f9lmEKM8wW0VFzKZo2XUuW+FRHtxN5XDO33L7ZsBJv43nBYzuENAWYTGfhqQb7HgYqc9rV3PUYp9kcoufbilf6BLH4to/2Ia4WWH/UeeDTtyq9qmHqB1mtxoYYO+UOx5h9PXlYmUrpe6ofkfk7ZasLtjCSCqNueqO1KnExwj1QTfZWi0sp1hSZac7SJpBxI23+TupxtLqPxqvTQ4h3rfiZz0L/HNLSxTUPRF3YSNV0slVXAPdJEc+cZrTE7OVpQDwjw6wZK4RfyGV0vcg1HVRzU5mpAlQVOuQDgEOUsRtpL12vEq7gJGF3IzD3cJoKKZ1rLmYgcH+7NS1nFqJZ/GjTQjSO5IKNALJ9gKgnSkB4zz9E6iM0L+M/loRD89x+Jza0XRl/eB6eDf6L+Bk0O00NHzIc9bqylAtFg5uNyEShmNfq/kck9/QG4z6RXq+hnAKC0NBTeT3I84yK82we
 B8GIBydE
 SUQyxGda0Zbw+lRN3kODPGtdtX7hecoxq0+L2XvzMH1AUHbx7VCb9sZeXLOtyssiDgCQ9i8ESEWHagyhsyULnqotXscsiNeqByd2UHa1fe4sDvHhrg/0bvMxPFtExSm0swMtSXbvipvePKgs84i4xI1ydJqsP5MvBVcUsgebL5MI7YlY0IN0DLWQhjNRKn6ekJgBccVejy5vZQPaEWEmT5CKDNed1nlDDO71r4+hRJJDL3Caoqar3VuB9hlxERkItkXEtCRpWWjmDUchfOAZb9Nov20A6RVMacCG0fsM2FvbHAJeapwV9n5pF5KaCDqFRs6kz13CSaZzZOyTpPoXfpfqbnBxPeeu47hqyR2D0OFE7hEyeI7IV4cndp7s3OhYgInjZQR/VChMbnl8HF8sTof9TIerNd5QONSQHnyUaIXGZIbXMzV72eoRueM7h315SvHikDPkbQvjpPXPue7P2xt5lRvo6AmTPPUj2B1c3IHYpKG1C++hAIgcNkx1LfcC1YJzVDMfWVTKus7FLYDOh2qY/JsA5YqFSTmzeKZ1nMGihFnjvZF8UuTNp094tvkYE4AN6IcryJQvXoSUfwLnTrogh6fcUUye72MG/OmaFAXmZeCXQTzFsRhQSBC2MNgybWUumcQYQZhbqm9uTLISQZCn4UsoCQNIDdeTCdB/XOn0/8RM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When checking for actual tail or head pages of a folio, we must make
sure that the KPF_COMPOUND_HEAD/KPF_COMPOUND_TAIL flag is paired with
KPF_THP.

For example, if we have another large folio after our large folio in
physical memory, our "pfn_flags & (KPF_THP | KPF_COMPOUND_TAIL)" would
trigger even though it's actually a head page of the next folio.

If is_backed_by_folio() returns a wrong result, split_pte_mapped_thp()
can fail with "Some THPs are missing during mremap".

Fix it by checking for head/tail pages of folios properly. Add
folio_tail_flags/folio_head_flags to improve readability and use these
masks also when just testing for any compound page.

Fixes: 169b456b0162 ("selftests/mm: reimplement is_backed_by_thp() with more precise check")
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 tools/testing/selftests/mm/split_huge_page_test.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 10ae65ea032f6..72d6d8bb329ed 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -44,6 +44,8 @@ int kpageflags_fd;
 static bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
 		int kpageflags_fd)
 {
+	const uint64_t folio_head_flags = KPF_THP | KPF_COMPOUND_HEAD;
+	const uint64_t folio_tail_flags = KPF_THP | KPF_COMPOUND_TAIL;
 	const unsigned long nr_pages = 1UL << order;
 	unsigned long pfn_head;
 	uint64_t pfn_flags;
@@ -61,7 +63,7 @@ static bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
 
 	/* check for order-0 pages */
 	if (!order) {
-		if (pfn_flags & (KPF_THP | KPF_COMPOUND_HEAD | KPF_COMPOUND_TAIL))
+		if (pfn_flags & (folio_head_flags | folio_tail_flags))
 			return false;
 		return true;
 	}
@@ -76,14 +78,14 @@ static bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
 		goto fail;
 
 	/* head PFN has no compound_head flag set */
-	if (!(pfn_flags & (KPF_THP | KPF_COMPOUND_HEAD)))
+	if ((pfn_flags & folio_head_flags) != folio_head_flags)
 		return false;
 
 	/* check all tail PFN flags */
 	for (i = 1; i < nr_pages; i++) {
 		if (pageflags_get(pfn_head + i, kpageflags_fd, &pfn_flags))
 			goto fail;
-		if (!(pfn_flags & (KPF_THP | KPF_COMPOUND_TAIL)))
+		if ((pfn_flags & folio_tail_flags) != folio_tail_flags)
 			return false;
 	}
 
@@ -94,11 +96,8 @@ static bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
 	if (pageflags_get(pfn_head + nr_pages, kpageflags_fd, &pfn_flags))
 		return true;
 
-	/* this folio is bigger than the given order */
-	if (pfn_flags & (KPF_THP | KPF_COMPOUND_TAIL))
-		return false;
-
-	return true;
+	/* If we find another tail page, then the folio is larger. */
+	return (pfn_flags & folio_tail_flags) != folio_tail_flags;
 fail:
 	ksft_exit_fail_msg("Failed to get folio info\n");
 	return false;
-- 
2.50.1


