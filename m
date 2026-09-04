Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 764B9C624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 15:11:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3E7C6B009F; Fri,  4 Sep 2026 11:10:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F15F56B00A0; Fri,  4 Sep 2026 11:10:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E054E6B00A1; Fri,  4 Sep 2026 11:10:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C1C906B009F
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:10:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 458CAC0157
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:10:47 +0000 (UTC)
X-FDA: 85176416934.07.9D8EBD1
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf04.hostedemail.com (Postfix) with ESMTP id 638154000B
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:10:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="e 16hbKI";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="SKTzj4/4";
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788534645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r93rUlDolzw1y/GkO8pLufE2QiyunUPjQLxePIB9XW4=;
	b=gzoJpu/EVDh/zuH77hH8IvN7rQZ3CawpNYOUvbQ3Hi2rszV1svq4olmTUghq2ymNK9Wc0+
	V/EAMKtDcS/XpDPqOvwQWxkOfF5jN/3Iy5gHB1bwiZylOnGkKJXdp+VJjECzLX36vhrSYu
	qSCw0hSp4ynb8e/f4897ZK8ZGLWNssU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="e 16hbKI";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="SKTzj4/4";
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788534645;
	b=1XKh2sHe1Fzqm6YtWsy4Po+yqKyvQpZSEnEQKAbt6yrkv7oF16q197hsNdkqyN1ieoYm7y
	/QlPcWiriaA02WNJjHFDX0NG1Vj0T8yuzCk5p1Daomuppe3MCFRKLOH3gsLGkW1mwG02+8
	UG3+UD72oKqXfuyqfskWPE0IjNPYrn4=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id EA54E14000EA;
	Fri,  4 Sep 2026 11:10:44 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Fri, 04 Sep 2026 11:10:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788534644; x=
	1788621044; bh=r93rUlDolzw1y/GkO8pLufE2QiyunUPjQLxePIB9XW4=; b=e
	16hbKIphh+Ow3R7n0z+kJKD9ONUcVEFDCOGO2E8vrb2+imltlrO3ZhsCKXNPWqgR
	7t1oGPD+d6GWvatfWUgRTQl1YvqEEtCj05McCzMhto5h8BkBnx1pJJ18OkincXRF
	FFHWckDj7ojS1nF6KX/cQRbsAruYHmm2jy4LutA4RJITCMu2fOAV3o/jkzdp5krm
	zhlQuYCsFyQD8aQ8DA5I0tDFmPnmHO8KEV/WEMoCqpZyUgk7dJ4KJSie1OA9GZIL
	lL9Gi4riD1jtYuU+tbFhCbUBijquLPLJCKdzre9Qw++W6tSNOb84dc+2Palhop1L
	mfPAwYKMpdXeavMKG9RRg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1788534644; x=1788621044; bh=r
	93rUlDolzw1y/GkO8pLufE2QiyunUPjQLxePIB9XW4=; b=SKTzj4/4U68GjSc+o
	Hi5BEucItBtyQ69SNx773bFJp5k0BkWpJui5LB1oLLE0Puz7qfWuxAfe38rc/oAs
	KcHEvUq6fxJ8YXJlzH3lWtUACOaQJb0vdEDaMWAGUhvoduDu7BDVipipdsV8WJYG
	CT2phgyWyWLyNi+zUUJmOaQfCRgywLud1aD5K18LdJ+8JJaYZu69LGEoERyl3ElP
	APFGLwSaEJnIiF6pnpZYPZq9Ud3hsHc0sGPPLWiU+2iFypA5CpjA6U4KDpJaklOE
	98vuCMre3jUuV4Prttan7KiAS5WIGCuOXtBcOhyDbFmMv1g7geuE2/QhMIDQOoxB
	+Ynrw==
X-ME-Sender: <xms:dN-aaqSP8YVs8lVYFLP3hOWacJCUyapFECY8gzjTj7oiQatpW8mnMQ>
    <xme:dN-aaqdZvdTs_K1DE5oPOEox3QVApzUpzbb_zIqsM1N6jyuACbQtYeytEOojBf6oH
    za0bo_jdklZ05Wy9r2ewag02fqdQQqCxVt8m2rCw4ydUZY7jvWQfLXN-A>
X-ME-Received: <xmr:dN-aaufo3jcEzCoyuKlA_-JSDhnZ2fG7b8tGvsBoBCAV2E2C5gg6IT5cqpc>
X-ME-Proxy-Cause: dmFkZTET6cjphBfz4H8Wg4Mwj3Q2fsO4rbzY0RZa6uwdK6ABZ7pEhWaf3DWE0Wh23XozXl
    YXqBYYUtwtfZ1qQ9wX2bCqZqo/yq027VrzWqESBcvph06bOS8vyiOGOCS0fh2RY7A/kSFI
    L9MElk4eZ3HddGFY9A2GQHzM4/P7C4mhUDQ1iVikEtpcmuF5W8uFTm0u0CjZbROqFnINk4
    xO1zzX/Hj74YRRcHjJyG4ygWf0Hx5RhGZptpxeuVNBh7kD8dz0lfmQnwRvV5yZ57YM54K9
    KH8vVIjAAxpTayQfOZqnAJ2Uka0rmt6zQ0IYLz8TzxO+2W2OgPHZMW2lenfH2WoNpxg3Fu
    Is3rPBrDcBofCc7b6n/mkzPMHKzzFB4wzBYnbd1msgXXEWv5pcCEVAkkpXV9YTA1f+AM90
    fYGiwvFVPfibntr1gJm7N6PIziBa7N46Lwg7LpYrTxie3Cplo8XWo5c5qbj8fii7o4EfVR
    zfSbEJevvnyN65ADRgmIr9g+rY4WZTz40ZJjjzhrz6KlTzdXqInEhXD/5UgvIKmrLiG/Ei
    WEbYbLJho2MkPL6L3dEmJJAHfoOP0bVno1RgvPqFSrXsgRxEx+FsUvVjz0Lo15IVXh8/9y
    v+lUAhRzWHZNhw1wTWJu6ajdwVgYkVDa1b2c/L4M/R8ruWXpUUg6Ab5PYxIA
X-ME-Proxy: <xmx:dN-aag9QRbModmiuTHX39hOOaiOW8GTLktNsBrZUhACQ9OPB_Kx7SQ>
    <xmx:dN-aauOv47StyTeP06AAtQn17IJ3VLia6JNfjwlXkHhWlrwhneBaRw>
    <xmx:dN-aauVsVvaHMOGs_pr-ZDBBKpXGRxcTYIItV63WTJrjwl_k6fnKbA>
    <xmx:dN-aaujadB2sSllencJVymi7sN1WwQVxXbhhkyxQmz6sU3KZ2FZiIQ>
    <xmx:dN-aagJCCAOwwXx_QqpiiiRNFp4Z8eh543cm-fFgO3rKd89LmCCMImoz>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 4 Sep 2026 11:10:44 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH 08/12] mm/collapse: separate scanning a PTE table from collapsing it
Date: Fri,  4 Sep 2026 16:10:22 +0100
Message-ID: <1a1bc537850bd7ef73bed5ac4985634bb8dd95e1.1788533997.git.kas@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1788533997.git.kas@kernel.org>
References: <cover.1788533997.git.kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 638154000B
X-Stat-Signature: 8csg4txhjh7yhhbpypkqn4sehkekpqmm
X-Rspam-User: 
X-HE-Tag: 1788534645-641228
X-HE-Meta: U2FsdGVkX19cx1UnCptT9tj2YJpVD6w4GKPO2r9g36s3kVpnGkbdnQa0CqkLAYCqMiLX7VVUGu7S+VsIH0LgB6DfHTQIFI/7A7qH4ZubYnNMPpXPPhAkwQ9peDyIrfC3zxp4O508/gXjSK3kXwmEUSJoAwQRzJW6sEn3I5CxL6fyHJZkhWmOUCjX8YjzONqREhi2Fa9j+SAxdfcQAS49pujyW0sIe4eNI7zurz8KM+W/FQNqOM3wGY3LrSmQWQo7PmqzI6czBgANCdC6ATMgeNjemqVbvTfw3H7Ldl9EmY47rpu53K/YkgPRFg7rpZ5vtfMZlC8qDSqdrkYph36I2NGBT3qE52V2/K2E9MxN0SKsD4MoXz4H+h+/wAkCgElsY5UizB7o6FOvqDeLFbTu6aljWJFNIT/+K2aHECszLLMENMElK3cTSSdziNuZpBPalg1rzc1//pzYTdIQoU9o5mdR1d6nw45DHWGg+NMY62qNFMotLmbccRQsIcXds7BXzzKFB73VNMbqpG4g6HQ/DHkmFF4c7SXasNly0Ki4lO2XvWUjGuLQVdYXfwvkqAcma2bpGF7zE7cpoPM3Drdl0lSCRBD/bTjrVPhXRzeXKEm4mS4KwxpTop+JbnwF5N3+CxjUIqERkYb6KtCabZNExt3s2tCgN4DxxfE3dSgS9A/vUXVgZM6mKIbLrIpOtVqFkkmW+fdONE5GJDV0KolNd0A2lTnlfqnIHCU68ECvNYpf/xAmSdZTltJ6sBHXZ4sR/gPrSvtqLeJnNYGJheA9zTU5nByP7vfB8GO27rSOO8m41+W9LRBa3wMYv6JHNvU9hoEQlscFOhHUGhEA7ud6XyMS1om9HEjie43qdYllyUt5S1PvFd1Qg5l0MhM6549OlsWCtGh2gdKWn1YuGWc86AY1V+5parFB4chEyJC0ogaRysgrPBh3aBKdnBzrwMPwNyJihZeXl4TrVZoC9Wr
 cbqbrDpU
 7zaO3izhze1j0asD/qpHVrjc6PXfMucCDm0YQ7Wysy0XZg8Yy9o229PhFWoXevaD1iA1a+11kAWaPzAlAhEC5dlVy7GzB2Tzt/YFdavUgoejlgozzqZPZSvYzWTY2vzRS9rNGizKe+WPZpmlUwK+6Ztlf7PMxugW+AwUDAZ1WHDggobsZI688gxGdLDBDE8N2Q1TN41lJ8IqYw6CuUvN/s3JbDO1VnJWQBmvksUSI0qfcUHuoKLKsOIjJtxxg2ykb+d7VnFwj3bx3y0hNEIoOLc/UATvp9H20kNMQc7D2446f6vjcziJoRvg2INa9+i3tZMfAyd8Yj2bbo+WC8ZwMQwvcMw7G+xRC7bE7F/jWU42yC114WeVgwJU83zDSNdOYD1cK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

A collapse is two jobs.  One reads a PTE table under mmap_lock and decides
whether the range is worth collapsing.  The other allocates, isolates,
copies and flushes, and wants the lock given up first.

collapse_single_pmd() did both, so the boundary between them was somewhere
in the middle of a function.

Give each half its own function:

  - collapse_scan_pmd() scans one table and only reads.  The anonymous
    scan that used to carry that name keeps its body as
    collapse_scan_anon_pmd(), and collapse_scan_pmd() is now the entry
    that picks the anonymous or the file side.

  - collapse_run_pmd() does the collapse the scan asked for.
    SCAN_SUCCEED from the scan means there is something to run; anything
    else is why there is not.

collapse_single_pmd() is now the two of them with the mmap_lock drop in
between, so its callers see what they saw before.

Scan results (beyond SCAN_SUCCEED) communicated via collapse_control
structure: the orders, the referenced and swapped-out counts, and for a
file the file itself and the offset in it.

A file collapse works on the page cache and never sees a VMA.  The scan
takes the file reference while it still has VMA and the run unpins it
when it is done.

Tracing changes with it.  mm_khugepaged_scan_pmd now fires before
mm_collapse_huge_page instead of after it.  Its status field already reads
SCAN_SUCCEED for an accepted table, so what the collapse then made of that
table is mm_collapse_huge_page's to report, per order.

The two calls to that tracepoint become one.  They differed in what the
collapse between them changed; with the collapse no longer here, both
carry the same arguments.  failed_pfn is set only where a PTE was refused,
so it is -1 exactly when the result is SCAN_SUCCEED.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/collapse.h   |  14 ++++++
 mm/khugepaged.c | 121 ++++++++++++++++++++++++++++++++++--------------
 2 files changed, 100 insertions(+), 35 deletions(-)

diff --git a/mm/collapse.h b/mm/collapse.h
index 05282eed9a35..f03cad8ed40e 100644
--- a/mm/collapse.h
+++ b/mm/collapse.h
@@ -100,6 +100,20 @@ struct collapse_control {
 
 	/* Each bit marks a PTE the scan accepted as a collapse source */
 	DECLARE_BITMAP(eligible_ptes, MAX_PTRS_PER_PTE);
+
+	/*
+	 * What a scan found and the run after it needs.  Live only between the
+	 * two, and read by nobody else.
+	 *
+	 * The file side takes a reference while it still has the VMA, since a
+	 * file collapse works on the page cache and never sees one; the run is
+	 * what gives it back.
+	 */
+	unsigned long scan_orders;
+	int scan_referenced;
+	int scan_unmapped;
+	struct file *scan_file;
+	pgoff_t scan_pgoff;
 };
 
 #endif	/* __MM_COLLAPSE_H */
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 511ffb381fe9..120af57540df 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1550,14 +1550,14 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
 	return last_result;
 }
 
-static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
-		struct vm_area_struct *vma, unsigned long start_addr,
-		bool *lock_dropped, struct collapse_control *cc)
+static enum scan_result collapse_scan_anon_pmd(struct vm_area_struct *vma,
+		unsigned long start_addr, struct collapse_control *cc)
 {
 	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER);
 	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
 	unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
 	enum tva_type tva_flags = cc->policy.tva_type;
+	struct mm_struct *mm = vma->vm_mm;
 	pmd_t *pmd;
 	pte_t *pte, *_pte, pteval;
 	int i;
@@ -1737,19 +1737,17 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
 	if (result == SCAN_SUCCEED) {
-		/* collapse_huge_page() expects the lock to be dropped before calling */
-		mmap_read_unlock(mm);
-		result = mthp_collapse(mm, start_addr, referenced,
-				       unmapped, cc, enabled_orders);
-		/* mmap_lock was released above, set lock_dropped */
-		*lock_dropped = true;
-		trace_mm_khugepaged_scan_pmd(mm, -1, referenced, none_or_zero,
-					     SCAN_SUCCEED, unmapped);
-	} else {
-out:
-		trace_mm_khugepaged_scan_pmd(mm, failed_pfn, referenced,
-					     none_or_zero, result, unmapped);
+		cc->scan_orders = enabled_orders;
+		cc->scan_referenced = referenced;
+		cc->scan_unmapped = unmapped;
 	}
+out:
+	/*
+	 * failed_pfn is only set where a PTE was refused, so it is -1 on the
+	 * path that returns SCAN_SUCCEED.
+	 */
+	trace_mm_khugepaged_scan_pmd(mm, failed_pfn, referenced,
+				     none_or_zero, result, unmapped);
 	return result;
 }
 
@@ -2759,30 +2757,58 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 	return result;
 }
 
-/*
- * Try to collapse a single PMD starting at a PMD aligned addr, and return
- * the results.
- */
-static enum scan_result collapse_single_pmd(unsigned long addr,
-		struct vm_area_struct *vma, bool *lock_dropped,
-		struct collapse_control *cc)
+static void collapse_control_init(struct collapse_control *cc)
 {
-	struct mm_struct *mm = vma->vm_mm;
-	bool triggered_wb = false;
-	enum scan_result result;
-	struct file *file;
-	pgoff_t pgoff;
+	cc->progress = 0;
+	cc->scan_file = NULL;
+}
 
-	mmap_assert_locked(mm);
+static void collapse_control_release(struct collapse_control *cc)
+{
+	/* A scan that took a file reference should have been run */
+	if (WARN_ON_ONCE(cc->scan_file)) {
+		fput(cc->scan_file);
+		cc->scan_file = NULL;
+	}
+}
+
+static enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
+		unsigned long addr, struct collapse_control *cc)
+{
+	mmap_assert_locked(vma->vm_mm);
+	/* Whatever the last scan found has to have been run by now */
+	if (WARN_ON_ONCE(cc->scan_file)) {
+		fput(cc->scan_file);
+		cc->scan_file = NULL;
+	}
 
 	if (vma_is_anonymous(vma))
-		return collapse_scan_pmd(mm, vma, addr, lock_dropped, cc);
+		return collapse_scan_anon_pmd(vma, addr, cc);
 
-	file = get_file(vma->vm_file);
-	pgoff = linear_page_index(vma, addr);
+	/*
+	 * A file collapse works on the page cache and never sees a VMA, so take
+	 * what it needs from this one while it is still here.  Judging the
+	 * range needs the page cache and no lock, so it happens in the run.
+	 */
+	cc->scan_file = get_file(vma->vm_file);
+	cc->scan_pgoff = linear_page_index(vma, addr);
+	return SCAN_SUCCEED;
+}
 
-	mmap_read_unlock(mm);
-	*lock_dropped = true;
+static enum scan_result collapse_run_pmd(struct mm_struct *mm,
+		unsigned long addr, struct collapse_control *cc)
+{
+	struct file *file = cc->scan_file;
+	bool triggered_wb = false;
+	enum scan_result result;
+	pgoff_t pgoff;
+
+	if (!file)
+		return mthp_collapse(mm, addr, cc->scan_referenced,
+				     cc->scan_unmapped, cc, cc->scan_orders);
+
+	cc->scan_file = NULL;
+	pgoff = cc->scan_pgoff;
 retry:
 	result = collapse_scan_file(mm, addr, file, pgoff, cc);
 
@@ -2812,6 +2838,28 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
 	return result;
 }
 
+/*
+ * Try to collapse a single PMD starting at a PMD aligned addr, and return
+ * the results.
+ */
+static enum scan_result collapse_single_pmd(unsigned long addr,
+		struct vm_area_struct *vma, bool *lock_dropped,
+		struct collapse_control *cc)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	enum scan_result result;
+
+	result = collapse_scan_pmd(vma, addr, cc);
+	if (result != SCAN_SUCCEED)
+		return result;
+
+	/* The collapse takes its own locks, so give this up */
+	mmap_read_unlock(mm);
+	*lock_dropped = true;
+
+	return collapse_run_pmd(mm, addr, cc);
+}
+
 static void collapse_scan_mm_slot(unsigned int progress_max,
 		enum scan_result *result, struct collapse_control *cc)
 	__releases(&khugepaged_mm_lock)
@@ -2954,10 +3002,10 @@ static void khugepaged_do_scan(struct collapse_control *cc)
 
 	lru_add_drain_all();
 
+	collapse_control_init(cc);
 	/* One policy for the whole pass, so every table is judged the same */
 	collapse_policy_khugepaged(&cc->policy);
 
-	cc->progress = 0;
 	while (true) {
 		cond_resched();
 
@@ -2988,6 +3036,8 @@ static void khugepaged_do_scan(struct collapse_control *cc)
 			khugepaged_alloc_sleep();
 		}
 	}
+
+	collapse_control_release(cc);
 }
 
 static bool khugepaged_should_wakeup(void)
@@ -3184,8 +3234,8 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	cc = kmalloc_obj(*cc);
 	if (!cc)
 		return -ENOMEM;
+	collapse_control_init(cc);
 	collapse_policy_forced(&cc->policy);
-	cc->progress = 0;
 
 	lru_add_drain_all();
 
@@ -3242,6 +3292,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	}
 out_nolock:
 	mmap_assert_locked(mm);
+	collapse_control_release(cc);
 	kfree(cc);
 
 	return thps == ((hend - hstart) >> HPAGE_PMD_SHIFT) ? 0
-- 
2.54.0


