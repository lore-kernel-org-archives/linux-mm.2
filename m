Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EB8FC44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 14:42:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 901946B00AB; Wed, 15 Jul 2026 10:42:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88B336B00AE; Wed, 15 Jul 2026 10:42:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77B2F6B00AF; Wed, 15 Jul 2026 10:42:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 420F26B00AB
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:42:45 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B08A71A01EA
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:42:44 +0000 (UTC)
X-FDA: 84991277448.24.9E89966
Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	by imf14.hostedemail.com (Postfix) with ESMTP id C66C7100003
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:42:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="E HFI4Kw";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=C0L9Ddr4;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784126562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3l0XyTdKPP5hBOW6Vzm0DCbWsUBNUYrq9eqhYnO/icQ=;
	b=wjQbMDAbQ837g5gMeXJgSTJaLPoqtBgSoOzjWQ93wyS+RCOO8JumFYWLLL4pa9qYzewOyu
	szxsWrie5otPl6X6rr+Hu7g/FnLnQCdDs+JlHj5z805vcTrZqiN5/zkBqmeFngWjHXNN+c
	EzRozK5lBGwRIrnArR6gBdphyJOzBUM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="E HFI4Kw";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=C0L9Ddr4;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784126562;
	b=FLZdYEBQ9wWDA0THZR1k1HeWBQn/5m7rolqBBA6Bc000Cf00ruBYzAs2dm9jVCQcR755Kh
	f1A4MzXYIIqrzpdBiwnXSPlpdkGY2dnZTPf2tAMZQO0c6nyWc7RGMFYf3tHvluuZFdLiOp
	86GzEdj8RS1zrk4DtKo6zJeQZhQ8Y6s=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id BC2CC7A00A2;
	Wed, 15 Jul 2026 10:42:41 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Wed, 15 Jul 2026 10:42:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1784126561; x=
	1784212961; bh=3l0XyTdKPP5hBOW6Vzm0DCbWsUBNUYrq9eqhYnO/icQ=; b=E
	HFI4Kw7WoTNLWubLoH5iL4Kob2LwYAo/ezxVE04Ij8OuLCrgdmXh2XMlnAiF5AL0
	U5gZgnCNsxIRIuxNAMEClRnwTLTupIkyCE/gHaTL4ymV695XhW3eRqjkUEltnElt
	I5U4lP3JA7t26RicNjt4W8AqoRC8+O526pfZgow2ImJ8Te+U3vV+yGukHpa6w69X
	cgt1D5yrN4EDFhENBwCjOE4TkVOAfuaWnMKDDUtMP3WsIXPo9KONrHkIcO3jtzdM
	mBPNueOzSlWiw52FvuStfTFtul2gbF4iGTLz4qIZqMl/L7DyRpNQ2nfNQPdOfXiE
	RTBuxGzqOrF9r6w8uYzUw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1784126561; x=1784212961; bh=3
	l0XyTdKPP5hBOW6Vzm0DCbWsUBNUYrq9eqhYnO/icQ=; b=C0L9Ddr4whDFo59u2
	NVhLZ2w1+DV39e9SRndWby97xxTjIVe/F4LWHt2zzyouWNPQurWqp6RIC5u2vn23
	q1czZtDZREkSQ0yH97LsVXNdK4ahIV7smgNbygFcKRKC7LZw9R/ZpLw33nFRQIzw
	Nq68TtMTkXJ+g00zx+RAAI5ZHD9eImYCqthY1l3cLF/jaUICmxIigi5GfLJtxrtu
	o79g6N8ekerqaVh4b0FQ3ohW65/t7hH4DFc3Mzj6TcPHGzVzVJTdt4xx2bmYIzFo
	+M23JusCUVd9S+TCSJsuuIZK/91JWWA8jzlZ3BI0A348n3igS232keIbWuOf5MV0
	f/Q+Q==
X-ME-Sender: <xms:YZxXaqwA7p7LKIHO6-zoTCWpRU9VaNFDuv4FlRxLT7d8QMoEKhRuYw>
    <xme:YZxXaiIghCJicXG9L60yehCsAAbnMH1TNz6ctmpQV716HO4ryhlOB6Mua1NhuiiHR
    RFGsGbM6Aof7FIH6sS0iCkKU655l0xaHvQx6nmUSarj1UnUCTiXDMU>
X-ME-Received: <xmr:YZxXan0hjItO3ioQbcMilHHaK-B_vf8EJu0gd1eHyKxhe2hho7gOEKJVcOgt_A>
X-ME-Proxy-Cause: dmFkZTEr6Zm/HMNxfsNW/iezKuhtKtrCalV88quZrbEDABDdD3m9hYcYGhu1/0jgY0mEAr
    sDUumFR+I0fgMm5tFKkir+Gxq0Uv1DpOxUMI0WLzmBurypAOVcnwwlGk5Tk6YJyP4W4LJj
    a5MadW8FxxEAP1jz87bKlPC+2ZH+KYsfqVXt+HqGnx3SF8rzaGHL74vzjXVnsiR+WdtG9w
    pwvNy3UezTTxROXIgW04Z/k6vPmQcVxT0hS3LweBnBPmAR/9befwPxJnbqkfu3ZhJCreth
    Dt2wnyQXE6Mxst6SIo7a4+2Hv7YcgFwpFMxFGWDzC4hyW2dxkPtxAKABuSsV/FBv0eZGCQ
    nVBWit7wFtpeaKLi49iad9uxVS6EQc0JVo2pnLKBlinK/8Va2jWVqDNaEBfZ/RwI1BzO1/
    XPblA4/UH95biD+qvhvWWsRq19FZ071pDZ/72cPqwuX7Ar2fl+xVOuni6NaHPWJLMHzmbu
    5LV0BV83bGlCA/9oMvRLIe6r94SkBsbbeta0UgLzpcUTmTYbUe1cHmRZI8/IKUU6PsuFxE
    gtmiq+r9hT1iYga7oxFCH4e2IHM76L7elVjdzBdapr1gYCntfYM0IGEhZLLfAy63d6xUHw
    W0OHBNeOOZY1EG9etNMCEamYsHfT3h3ZTb9XjcLz/YajyyYMP9aedh6jptEQ
X-ME-Proxy: <xmx:YZxXakd6b-mp2NYg4Y0Q8tHjeFZsnA0iQLqTq617Pb9dK0HpQz-YeA>
    <xmx:YZxXaj6TMlNzS8wENBoYoiTAYYwkCxGuQ_uuseMErgfDYZKNlTTRzA>
    <xmx:YZxXav_7VR5EM9X6XwftO0yWdg69KRU29nX7H7ezwecmNif3o3mkLQ>
    <xmx:YZxXaiKH4aWHCBriEvpJ06Lj6lUb-M4sQu_Rl_Om5jsVwJNDNbbS1g>
    <xmx:YZxXaq8HML6NbFLJT4FYBK-BaRI99Esc-G_Z4PuEMC2OxXfg9ei1Bbog>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Jul 2026 10:42:40 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org
Cc: usama.anjum@arm.com,
	peterx@redhat.com,
	liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	david@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	zenghui.yu@linux.dev,
	shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	stable@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 2/2] selftests/mm: add PAGEMAP_SCAN test for THP PMD holes
Date: Wed, 15 Jul 2026 15:42:34 +0100
Message-ID: <20260715144234.442721-3-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260715144234.442721-1-kirill@shutemov.name>
References: <20260715144234.442721-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9tp8mj6r5waszxg941eiuza69x31otp5
X-Rspamd-Queue-Id: C66C7100003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784126562-806124
X-HE-Meta: U2FsdGVkX19lkaayN4UNcAgbxeDCYY2pZqHisV/FodORmcP+jXYo9d1faQM+O7riG60jEFPplK0R045FZzMWH4/7L9mJRnYWLv486MtbQVZ+lXbxYg/9SOyM5CNvWZvjgVnoDsZUFtQE28Bzc7WwWBen4ToF0ysJuzVw7i35YCIdMP3Kzha8T5PjStjlW4PbsszBqv5I4IlEFuMKoFysw9c2v0Il+Xr2al1sI+r0SLHJO6rPNPA7+UuvnM4KsS+VAfPhB149jt+h8dW5TqLTVeDhR2z+T3ljWEtU75A44PRg3UTdm71z+FNxpQyYe7nxx9SFHJumpcZq2lOGosiZIxIUlM1h4JtOMgnFqO9a8Afy/ozktXDEVF2MVADJ1sVCrhFbdX8vhlzDalCzcLNUzYf2MfmjE26trWTIJ/4emEPp2oeB9EBD0VtWY3hKcBMi06MqeQPgRbceoYzukzJwuXuIybU3xXUbShhQruRQXiGT7abUuZ3xDmdLF87pHbvUm7gSvbjSG6G8+X1Ur0rJmI4ywcMRv5UrWHMUJJkd/2IJ0WSIGYNvLBEELGgYH4Wr1SY3P8aPE9x+++jhAPgLlaYeGqGoJ+q57inNAGNDwRm709Ifo5KMFgcXeS5IReGPXOwvivvQOOcSz8aIXR+i9fh3ZxPwHZpVWiNazIX/+r5YemsARDQ4hQmQmSqDP29HJtUIva/3fF6WPhoifNAs1uvCN/MEYdI3XVtm1Oc/c/cfI+UU/mJqabV9f3m8WDz6ZEYtImB1V0AZbuEoB9M4qQWBczaY4VmZeDySflK59mlI6FfDax9x7OGstcFJ3N/8mg0Q2gTTrR+JFKLh4X8BQBza3x+gkHo82yOxQWWxrDsB0sFbYu2OjtZ7YWczmzK8BJS1UzsyRJ+XdliC/dVurxLh2xAX2t+2yOiCMcw6V+1/9mEUknk4V1C/AK5Qq/0ECZ1bkEGFuqsPB3WYjAY
 VeUibvlu
 LFIcXGZlDMY/uSNCeDZJnpSnjFzQma2VEV9Y86BDsGCBWHe0YPgo0mb/G9nKc3T5CoVH6e89to1hfPiVifekXDoBZ2dnQb1UM01QyP2iGX8sXj8fUIJxvi21NhSWSOqhagPKbCt3hUzKlvxBaKeeTLPcT5hP9VPi9PiKv2kE1VWpLZXlQT+lpZEMEwiz1o60nzPGCF7vI4V6MhYhNuPyskGmUl8YuGMMpR2bfyW7OYuvGmE/0N9GMatV0dtj5JvKRS0ZNqlv0TC744AXO4quAWv//SQ+X1S6WRDqx5gdxWN2TtX2vazunZ7xCcYpg0gyHKHx0fkU79QAYgjUB/jiIih95UtVBQFP1T1nodq9404sQpieRb2VZFKCPdeVR3BVy/v/E8pZhghL/byGySxP1rrmJFuaRdtiZq67SdPpXrvM+3fx4l8z4Vn1GPlWgRuKOpy/l01TFsckCaLMVp7jLaMRik9Ucn4Ik8N2ENm5jkynYlTfPzhMnFyiux7MmMQF9phlXvKYIPpWzp+DhSUTPfT+uNlA++SbwMJUUdDH8fB2icXOzrBngJSEYwCkSvinaiMqRDaFHVkr02wM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Add coverage for the PMD-hole case fixed by "fs/proc/task_mmu: fix
PAGEMAP_SCAN written state for PMD holes": a MAP_PRIVATE|MAP_ANON THP that
is uffd-wp'd and then dropped with MADV_DONTNEED leaves a pmd_none hole
with no page table, which PAGEMAP_SCAN must still report as written --
checked via both the fast and generic query paths, mirroring
unpopulated_scan_test().

Include <linux/mman.h> for MADV_COLLAPSE; <sys/mman.h> lacks it on older
glibc (e.g. 2.34). Same approach as commit fd5295afae91 ("selftests/mm:
hmm-tests: include linux/mman.h to access MADV_COLLAPSE").

Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Zenghui Yu <zenghui.yu@linux.dev>
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-fable-5
---
 tools/testing/selftests/mm/pagemap_ioctl.c | 66 +++++++++++++++++++++-
 1 file changed, 65 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
index 550d1f2c059b..ffa3328185e6 100644
--- a/tools/testing/selftests/mm/pagemap_ioctl.c
+++ b/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -8,6 +8,7 @@
 #include <errno.h>
 #include <malloc.h>
 #include <linux/types.h>
+#include <linux/mman.h>
 #include <linux/memfd.h>
 #include <linux/userfaultfd.h>
 #include <linux/fs.h>
@@ -1102,6 +1103,68 @@ static void unpopulated_scan_test(void)
 	munmap(mem, mem_size);
 }
 
+/*
+ * Like unpopulated_scan_test(), but the range is a MAP_PRIVATE|MAP_ANON THP
+ * that is uffd-wp'd and then dropped with MADV_DONTNEED. That leaves a
+ * pmd_none hole with no page table, which pagemap_page_category() never sees;
+ * PAGEMAP_SCAN must still report it written via pagemap_scan_pte_hole().
+ */
+static void unpopulated_thp_scan_test(void)
+{
+	struct page_region regions[16];
+	long fast = 0, slow = 0, ret;
+	int npages, i;
+	char *area, *mem;
+
+	if (!hpage_size) {
+		ksft_test_result_skip("%s THP not supported\n", __func__);
+		return;
+	}
+	npages = hpage_size / page_size;
+
+	/* Over-allocate so a PMD-aligned, THP-sized range fits inside. */
+	area = mmap(NULL, 2 * hpage_size, PROT_READ | PROT_WRITE,
+		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (area == MAP_FAILED) {
+		ksft_test_result_skip("%s mmap failed\n", __func__);
+		return;
+	}
+	mem = (char *)(((unsigned long)area + hpage_size - 1) & ~(hpage_size - 1));
+
+	wp_init(mem, hpage_size);
+
+	/* Populate, collapse to a THP, then drop: a pmd_none hole, no marker. */
+	memset(mem, 1, hpage_size);
+	if (madvise(mem, hpage_size, MADV_COLLAPSE) ||
+	    !check_huge_anon(mem, 1, hpage_size)) {
+		ksft_test_result_skip("%s could not form a THP\n", __func__);
+		goto out;
+	}
+	if (madvise(mem, hpage_size, MADV_DONTNEED)) {
+		ksft_test_result_skip("%s MADV_DONTNEED failed\n", __func__);
+		goto out;
+	}
+
+	/* Fast path: category_mask == return_mask == PAGE_IS_WRITTEN. */
+	ret = pagemap_ioctl(mem, hpage_size, regions, ARRAY_SIZE(regions), 0, 0,
+			    PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN);
+	for (i = 0; ret > 0 && i < ret; i++)
+		fast += LEN(regions[i]);
+
+	/* Generic path: same query expressed via category_anyof_mask. */
+	ret = pagemap_ioctl(mem, hpage_size, regions, ARRAY_SIZE(regions), 0, 0,
+			    0, PAGE_IS_WRITTEN, 0, PAGE_IS_WRITTEN);
+	for (i = 0; ret > 0 && i < ret; i++)
+		slow += LEN(regions[i]);
+
+	ksft_test_result(fast == npages && slow == npages,
+			 "%s pmd-hole reported written by both paths (%ld, %ld of %d)\n",
+			 __func__, fast, slow, npages);
+out:
+	wp_free(mem, hpage_size);
+	munmap(area, 2 * hpage_size);
+}
+
 int sanity_tests(void)
 {
 	unsigned long long mem_size, vec_size;
@@ -1610,7 +1673,7 @@ int main(int __attribute__((unused)) argc, char *argv[])
 	if (!hugetlb_setup_default(4))
 		ksft_print_msg("HugeTLB test will be skipped\n");
 
-	ksft_set_plan(118);
+	ksft_set_plan(119);
 
 	page_size = getpagesize();
 	hpage_size = read_pmd_pagesize();
@@ -1790,6 +1853,7 @@ int main(int __attribute__((unused)) argc, char *argv[])
 
 	/* 18. Unpopulated pte scan-path consistency */
 	unpopulated_scan_test();
+	unpopulated_thp_scan_test();
 
 	close(pagemap_fd);
 	ksft_finished();
-- 
2.54.0


