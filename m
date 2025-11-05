Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBFBBCCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 07:25:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2F328E0007; Wed,  5 Nov 2025 02:25:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B06D28E0002; Wed,  5 Nov 2025 02:25:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1D408E0007; Wed,  5 Nov 2025 02:25:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8E6778E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 02:25:40 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CB4E7160208
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 07:25:39 +0000 (UTC)
X-FDA: 84075718398.22.BD38748
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1A165180002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 07:25:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aWeTUWnL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762327538; a=rsa-sha256;
	cv=none;
	b=wgJpQmid5ZyKef2JnTM83dQxFPu+d77OqzGncN8R3PpNyqsufj6x6z6HHPi5PVOlKOH0Y5
	UybBa7J8BbyDLL998+HMnhq7ipq9HQsXBXsv8EA4j9BBMXblKmZBUG36pB27L+RSm0AwxI
	HtWrobV8zGgXTsORKzeN53gXOghiFnc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aWeTUWnL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762327538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=4xQ3WzoW9kCNzox1YmcFZP78kmxdmU4B1TBR71iMc/Q=;
	b=CDFp0/Bq5Ag0BZ8M1WmlZIKZCtk3KeazAflV0q9myo6sHC6F2PcVFk3naWBc2u2pexJjl9
	vYNQu4xNkxqsfgCFifLSTcZ3lW2ScT7IHwzli6PAzTbX6etARuG4SsE5J/km9cmp/qvXtq
	Rilg3YFoejDGU1sqbZPwYYygsrwyiA4=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b3e7cc84b82so1248091666b.0
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 23:25:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762327536; x=1762932336; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4xQ3WzoW9kCNzox1YmcFZP78kmxdmU4B1TBR71iMc/Q=;
        b=aWeTUWnLPY+ZIg2qp78xYselbs7aXJBBDEQ6hhg9fenzO3tSyU2ojdxf8OfKBz/BFW
         AZ4IJdT74i+NieJUT2wtG9qF+v0BCpx3agF69NyAE9npZMxujX2pA2u1z/kjYjT7kgH/
         CpaqDbRAFAg1Ow2g0OQvNyd6h+r6t4KoZTM20Ao2IIatnzzkSOUR11JmGJZcLXk2a2xj
         n+5K7tw2mysdQzNogiTgX9rKQK8Nbmdx2apoFqMOZlwOrI0J2x8CmGnaxU9+g9+rTWy3
         AFglSlb1bdBLV2LVVk0ZYAIywS3/v5R+zWE8EBr/WKsXs0YE6W+PTSsLL7NVs6QNv9fF
         X7YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762327536; x=1762932336;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4xQ3WzoW9kCNzox1YmcFZP78kmxdmU4B1TBR71iMc/Q=;
        b=EJ6kvEA5xgSh9fBaso6MJsfOcW4Cty8fH98eYTLJfVG0CPmUiqqZUq1qqhPY2jOgzM
         BrY81oDC2umFPQiXYf7RfROXJ9XL3NFIv1JbJMa8HoOpL50A7XgTiVglkUF1gGcTNtZd
         4i3YM67YyyFUHAikJVa5PdeJ43TNTPIjavweBu/mOmr1Wo/glCGKjMpsp1Wve38m1RpO
         xsqRXCY8HtQAcwHBBVxIaRIS2CvZMnMlyI+qi2BNtGKgyikGjNTtRQ6QvW42WprCrkBx
         VKwFU9WiUg4QKJbXsq0+bRU7tehfmyvdk6Wr3fEbz1tF6v8LccFuDyN9Hl6eGy4V+CYG
         zpFw==
X-Gm-Message-State: AOJu0Yz6qVwnk4bSCMaYRVqcpCFfty5BBVkqF4BbXz4TS7Hl9aiDi3/1
	yZ62JrSyuYodIbnBJCByfiMXKtrg19d7BZ/+E7MekGWYOBilakCCTHgR
X-Gm-Gg: ASbGncuIgXsgrm5cNWb/xHUS7bPjl2TAeJg1PX4ZA5sLxGcitdYrZg/K/Nyr2VtTEiD
	44NR8FL1DkYvytE4jv8/P0dkeCT1BAx3Zl8srZHZG7JGPshzCcMhp4QZjreW8OZTSq1oR/kezY6
	F0rel8FUQLJSWub0XUIS8xMocKzccrpW2GpqWVF41VKBKToljLO6GxKE3QT1y3wxBOYSxstW54A
	N3ECemh5IAb2Lk8Ejv2DVvHjKxk3tcn28dPjkcWuJVrQsbI/GVsBdvk8v3QFQQtbGxb/72EZ6Yp
	GNruD8bDU81+tcAA49tPtZojcTUfI8YYplWrN6duXVeSv3dTswJn3B9LMyLTk025BtTVpUJE4Lb
	GiLT3caYBlKO7wsksPE9mMfGJTc1I1qcgnnzAZbpsHsTBZGq3oHtU8XgXaIuFIQBGwRbV0bKOF3
	M=
X-Google-Smtp-Source: AGHT+IEaGh5U5en5o77tSV6vAbHNiDqWKqI8tp89ZXjH+sL8R3mPcYICpEdQ4rP4/q9XzPZJRNeQbQ==
X-Received: by 2002:a17:907:3d10:b0:b6d:6c8f:6af6 with SMTP id a640c23a62f3a-b7265297e84mr188233166b.16.1762327536147;
        Tue, 04 Nov 2025 23:25:36 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b723fe38a4esm416804466b.62.2025.11.04.23.25.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Nov 2025 23:25:35 -0800 (PST)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: [Patch v2] mm/huge_memory: merge uniform_split_supported() and non_uniform_split_supported()
Date: Wed,  5 Nov 2025 07:25:21 +0000
Message-Id: <20251105072521.1505-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1A165180002
X-Stat-Signature: 6weukah6aaggc79z9gqwznzzxhpbrnzp
X-Rspam-User: 
X-HE-Tag: 1762327537-195315
X-HE-Meta: U2FsdGVkX19Xl4YnGCi4mSgDl+IriYQBJxrk/Bto/NqC3iV1qNLvH5Kg13O58qB+jJTcc6zjz4XGK7gWw3wwodZkmMBUAzeBaF9B9lOCnOiUaEzHLwUutxh6uvAbVTFoK7JpVacM9VfoMTR4YuQ3qQ2gWMkw6MdQYQMHU+vjUHUxg1YtptSNHANSRbuvnbVpwSUcyQrI6fb8RPKA2bHQTMX432s6eO7CKiZklJtzFmkzz+IGdBMYCoSaJQMZPQMjQj7oeHwwNOWBpAaBLIAQubxMAQC2ulbzGonFsM3uxbDTGDUqjkvEhJFN+O0nsTwwyf2l1URMCfxrqKIA3xt/nsRsWVacwlqRCifZ6kuZ1tab+TuTkKU2xlq5wZRJ3Mh96fisM3GI3SRx/gBdlcRtAOUzMQWcQH/iwpqKbLPpkugE0psGoMSt9OEVC3+Lyp4MJu4KvLv+XtjcvAxUaVV+nygEWEZiqOJdLwSRmAgh2D0T5KLGpzDn50d9tPs/TAejy4YcYa9Ra+1vwwZnrSudjneOprjuahpGf/3U71KCeLZCsYffA1SHrktXPyvqVN5O/D1jRgrXZ04MtZSE8EenL6TcdKNKUs4c0/Yw0nWKRPDgxtQ/LmpFDDgpy1+9VNpWKXHS+EkNccPVhC4HJZgV5SMUzqFRJrhE7gSz15AFG+bt2aUNTFeyx3e1Co6ZECWhnsk/vLLzDIiGq/KpQ44TNIVIPqy2eXxZjoA3UtgwmFbuzoMMuH/n2ND21DVBXLuln5u9CFans109ODDRgIN4yDG4gRl64xbzYsQNe/eEP16R66pPTKxEglogkvb8TrSF2DLdXuWCkfG9Rs+Ah9+f8kroRPnpOqphYFQLMguZHA3XFd/nez3RXEGrGkHOGTK6VAhPrQjiQIcr8QnJU5NxCxgbPB86sN6xGcbmVqbMPX4lcxVpk2G5/1Hw+VxPV8IHXaEDmfQBQwNeyEepmy6
 fmgfbdD8
 VMHNNzB3KwvzqDDk1hIWOmFXoV1VG9PGeqvL4UFIosR3YIpL64repLzlTrPs+raHrgnXX5NIxP19jHvmBBh0fBO6OtXDdY8qidRlpLDS6vHNMe7MxKAmYM2ppVrmtTcksT6GKW3yKzCDMTulW8iD9QdozfUAvOvSccMXxRNMZ9tdNmQjItEMzHhQuowt0k9Y2jE4+q02Jc0IwfEyxS7AVuOuXEcauTLGkIqIsTPjn9U9X8N+NNJ53YwDBwlNkrNaIeobVEEI47tPEcIjqL81xquYb3KWAqZYv72rpaiSOSX5ebY5eBgSQMDBrg9sAsNf92RtcSR6kNQG9WdXJB52rzXpsLrRBG9I6UpI0Ws1nWluX0NkzRvW6JMqW1Ak+6riMeG3TUzXMoN8tXLLedcOJ5B4FNAsjlReZ3aTueFAyL50+q3N/SNDy+pES7ldmFnIGFNszEnoDZkbr47Zno4CgRjuVKZyVdONH/nfDowNrRBGpb0aT2OjNQl0o/Bq499W0mGeQwyAi3drVNDpRmkaTMIfYSyApiSLqwhbBrrM8OCOE3+yvhAYQ6F9mWSYx7QtucQVeFBe0m3y3aYYjbsD4QCyz3EMvpj9Bm66Lm935ds+xGlot4EZGUNtnmw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The functions uniform_split_supported() and
non_uniform_split_supported() share significantly similar logic.

The only functional difference is that uniform_split_supported()
includes an additional check on the requested @new_order.

The reason for this check comes from the following two aspects:

  * some file system or swap cache just supports order-0 folio
  * the behavioral difference between uniform/non-uniform split

The behavioral difference between uniform split and non-uniform:

  * uniform split splits folio directly to @new_order
  * non-uniform split creates after-split folios with orders from
    folio_order(folio) - 1 to new_order.

This means for non-uniform split or !new_order split we should check the
file system and swap cache respectively.

This commit unifies the logic and merge the two functions into a single
combined helper, removing redundant code and simplifying the split
support checking mechanism.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>

---
v2:
  * remove need_check
  * update comment
  * add more explanation in change log
  * selftests/split_huge_page_test pass
---
 include/linux/huge_mm.h |  8 ++---
 mm/huge_memory.c        | 70 ++++++++++++++++++-----------------------
 2 files changed, 33 insertions(+), 45 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index cbb2243f8e56..79343809a7be 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -369,10 +369,8 @@ int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list
 		unsigned int new_order, bool unmapped);
 int min_order_for_split(struct folio *folio);
 int split_folio_to_list(struct folio *folio, struct list_head *list);
-bool uniform_split_supported(struct folio *folio, unsigned int new_order,
-		bool warns);
-bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
-		bool warns);
+bool folio_split_supported(struct folio *folio, unsigned int new_order,
+		bool uniform_split, bool warns);
 int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
 		struct list_head *list);
 
@@ -403,7 +401,7 @@ static inline int split_huge_page_to_order(struct page *page, unsigned int new_o
 static inline int try_folio_split_to_order(struct folio *folio,
 		struct page *page, unsigned int new_order)
 {
-	if (!non_uniform_split_supported(folio, new_order, /* warns= */ false))
+	if (!folio_split_supported(folio, new_order, /* uniform_split = */ false, /* warns= */ false))
 		return split_huge_page_to_order(&folio->page, new_order);
 	return folio_split(folio, new_order, page, NULL);
 }
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 381a49c5ac3f..db442e0e3a46 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3666,55 +3666,49 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 	return 0;
 }
 
-bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
-		bool warns)
+bool folio_split_supported(struct folio *folio, unsigned int new_order,
+		bool uniform_split, bool warns)
 {
 	if (folio_test_anon(folio)) {
 		/* order-1 is not supported for anonymous THP. */
 		VM_WARN_ONCE(warns && new_order == 1,
 				"Cannot split to order-1 folio");
 		return new_order != 1;
-	} else if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
-	    !mapping_large_folio_support(folio->mapping)) {
-		/*
-		 * No split if the file system does not support large folio.
-		 * Note that we might still have THPs in such mappings due to
-		 * CONFIG_READ_ONLY_THP_FOR_FS. But in that case, the mapping
-		 * does not actually support large folios properly.
-		 */
-		VM_WARN_ONCE(warns,
-			"Cannot split file folio to non-0 order");
-		return false;
-	}
-
-	/* Only swapping a whole PMD-mapped folio is supported */
-	if (folio_test_swapcache(folio)) {
-		VM_WARN_ONCE(warns,
-			"Cannot split swapcache folio to non-0 order");
-		return false;
-	}
-
-	return true;
-}
-
-/* See comments in non_uniform_split_supported() */
-bool uniform_split_supported(struct folio *folio, unsigned int new_order,
-		bool warns)
-{
-	if (folio_test_anon(folio)) {
-		VM_WARN_ONCE(warns && new_order == 1,
-				"Cannot split to order-1 folio");
-		return new_order != 1;
-	} else  if (new_order) {
+	} else if (!uniform_split || new_order) {
 		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
 		    !mapping_large_folio_support(folio->mapping)) {
+			/*
+			 * We can always split a folio down to a single page
+			 * (new_order == 0) uniformly.
+			 *
+			 * For any other scenario
+			 *   a) uniform split targeting a large folio
+			 *      (new_order > 0)
+			 *   b) any non-uniform split
+			 * we must confirm that the file system supports large
+			 * folios.
+			 *
+			 * Note that we might still have THPs in such
+			 * mappings, which is created from khugepaged when
+			 * CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that
+			 * case, the mapping does not actually support large
+			 * folios properly.
+			 */
 			VM_WARN_ONCE(warns,
 				"Cannot split file folio to non-0 order");
 			return false;
 		}
 	}
 
-	if (new_order && folio_test_swapcache(folio)) {
+	/*
+	 * swapcache folio could only be split to order 0
+	 *
+	 * non-uniform split creates after-split folios with orders from
+	 * folio_order(folio) - 1 to new_order, making it not suitable for any
+	 * swapcache folio split. Only uniform split to order-0 can be used
+	 * here.
+	 */
+	if ((!uniform_split || new_order) && folio_test_swapcache(folio)) {
 		VM_WARN_ONCE(warns,
 			"Cannot split swapcache folio to non-0 order");
 		return false;
@@ -3772,11 +3766,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	if (new_order >= old_order)
 		return -EINVAL;
 
-	if (uniform_split && !uniform_split_supported(folio, new_order, true))
-		return -EINVAL;
-
-	if (!uniform_split &&
-	    !non_uniform_split_supported(folio, new_order, true))
+	if (!folio_split_supported(folio, new_order, uniform_split, /* warn = */ true))
 		return -EINVAL;
 
 	is_hzp = is_huge_zero_folio(folio);
-- 
2.34.1


