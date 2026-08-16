Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A34BEC5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:50:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 737556B08B9; Sun, 16 Aug 2026 18:48:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6374D6B08BC; Sun, 16 Aug 2026 18:48:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43AD06B08BA; Sun, 16 Aug 2026 18:48:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 00E9F6B08B8
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:48:01 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4210D1605E5
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:56 +0000 (UTC)
X-FDA: 85108621752.08.6B41491
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf26.hostedemail.com (Postfix) with ESMTP id 64929140008
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="J 2MIBzR";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="J/P8NbYc";
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920474;
	b=5CipHJk4PChnCCcNuOxTcuYZVBy78nWekzrtPIv0TPHgZjd1WZ8w5l15LR7MEshrPuXJLA
	4Sg/CugP5ch4Lf1e8OBKmd0DHdf/q7TvcXveFCLODD/WmT2QNe8h8YlXXvKSdBQZoKT7YZ
	3qKeS1t4coAyRfQJTe5abjBvMB3bXsU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="J 2MIBzR";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="J/P8NbYc";
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6nKA+x05SWCXqc9tAtZ9fIuQuNqLhmkMozez9tYtOg8=;
	b=fy8tu70OlGq3HoXtFSo8kiuwfa4Ah7ASZwAI2ZA5eRfLhy7V6E2tsmazzyKKIQMZat6aA/
	jhNLKgZvU4oFvq0Nw1pcPV6iypmJGWTatnP/IDyOPrmlttojc6HiAjHr/Rd1aGtUNFmAm/
	Ha2IqVkdbvEVSsJfBvz6LzfN9s2dBkY=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id ED57E14000FA;
	Sun, 16 Aug 2026 18:47:53 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Sun, 16 Aug 2026 18:47:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920473; x=
	1787006873; bh=6nKA+x05SWCXqc9tAtZ9fIuQuNqLhmkMozez9tYtOg8=; b=J
	2MIBzRgxUP1C4fIjfMGKaTm5D0/70cOQRHKAbA2pFShrgKmGO1NRT0pDfPKhBD15
	HXSqf3NsaCIleEj/q4hDHVHX9JGeoP9UY13JE55foNll6OzHp2g5Vk0uFAJIdY4w
	GoO1Yg6tsF2g+kWdbyG7BWiB5m28OxHZoMTpJ/e+M9RAaV2uFSRL40wNl1JkXpKF
	H0a9hOB0HY8+RNI0kZp1Bn1uVhNnk0D9LTLf0sAdhXUtaXB/Tg+lxrUj4edzFeL/
	njv4WlY3IIA3p8BkcnDozs2Bf6Usp5OKhLCy9kW+QzrUena3ltGTKavDK/nUVo1+
	IMeSMRBK+DmhTjOnIrvBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920473; x=1787006873; bh=6
	nKA+x05SWCXqc9tAtZ9fIuQuNqLhmkMozez9tYtOg8=; b=J/P8NbYcP6xCTt5pt
	yUGsWYlcL5jXSEBSpHo5972USkYsQ4clKoiQmAxZfiapt3giYptu6UTfctr+Ux+Z
	3RhxGo/0KNda0UZVE2m3Yruac+La6uxGyjkj6L5QP82mf8mjZK1DODa+rEi5LyAu
	cTaf8ctK+B1NMVYNCbtVDXY5yhmgL4LRnrsHm85REZi0il4ySqfrtaPo2gkjN/gS
	NzcbaykTcpMTHuwT1q9a/oStrP2GFiGnKqwUf49YL/jxsoX3XZdYDzyUwCCDAeS6
	vMUXpAuCeF89aQ8/g2ihCWhko3penp8Csz0Q401gDWY0aBssIjsDYMRm878T1f1y
	c3e7w==
X-ME-Sender: <xms:GT6CaqrvauPI-5F91b8wxSvyKJSrQbxgyHhKq3rYRhQE_BPmsmyoQQ>
    <xme:GT6Cat_8BQ8Evg857fLm8kLc33LATZeixRawXmwg0XjPRPceWiwYH_0Z2C2cs963p
    _BBgRF7KqreQxfMWRBWARslXR16ZMiFg4Ht2gI4HdcGK36kThfAP1k>
X-ME-Received: <xmr:GT6CarT8HqOaiV-BMbUlsX1maFYXlnliODeiLj2baT6o_pirxk5YOkmpi-Y>
X-ME-Proxy-Cause: dmFkZTGLjSC+Sq1mG4OxzCqJWZCyq6WBdNxixaUzytYe9+wGJyabxJMeXSGoSuAsbaseo8
    j4DSEFeK04hDwZtES01hwyaQU7EBbvB2uUyGWGXfBIvFkincgAhOfMPuQIYJEtCVnAaSQR
    A4Ax8HD1ONlE2jDjL1mVvD+0hWY7OblS1nu5BjF2+enir154N1oLAu20vju0M/bNfdRnaJ
    kR8ssngVd0jx9kVZmvlOu6xrNJDHPkWuaI7duTsmkJWDtl1nRnZmYTu08hiimZvSmFoDki
    6dltoqAKCLj0c9eKP1Vuuwv4Z4pwJTjTf79O9CtQykYTwcA2QZ7OKyC8oLqq7vFkYshLpw
    LbZeDrUOk8rhM5rSxocjaWFP41pGzRhRHl0flKSZneFSf+mPmKgFKw4251gunztkdKVNyH
    QnRYsGz5L/GXiKiy1v3S/SrN7GzTBcXp0MYjJsgYyrkQ0uihcwm0LmFwzy8ExXjXwl/DcJ
    Bqw+WfxPjvkY6ZNwBmZbpr0mZaQ4NNtCOskJtyCw9HD9a7mzzSdUorDoJlDWU180C8lZ54
    HZEFuOjndqiCWeC0hQcqgUiK5PiUEeazn7abJ+/umTML33AYxBH0wTQylP6xID9xXksZyN
    k1UDRxZM6cfUp4CdSMNeruahniVs/40VjqqWeFlJs8fuMuUCsfGpnTv8yfQA
X-ME-Proxy: <xmx:GT6CamczuDaAvElUCT6NWOqCS0uGo89Bl4-xkNsxmOS4JxDrbjHAHA>
    <xmx:GT6CagKu8X5IybB2Cr7f9AjwTUM2C_095ar5-6iwb-T70Pl8KgpptQ>
    <xmx:GT6CajEBFmVXIuW_bw2m5oU8_Z1FhEskuxmdLCX5C1oXLHXuZ9Lg9A>
    <xmx:GT6Cao7cZMP1atvMHzcNqcbIvofy0j0S5fSiwjfE3RO4RpBXbSPkGg>
    <xmx:GT6CaptNvAXrW6ozbY7ylNvb3zr1TdbgQ_lrOv-QyUQi5AD32TcU1lgY>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:47:53 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org,
	jannh@google.com,
	willy@infradead.org,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [RFC PATCH 52/57] selftests/mm: cover a hole-y window in a sub-PMD VMA
Date: Sun, 16 Aug 2026 23:46:04 +0100
Message-ID: <20260816224609.308019-53-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 64929140008
X-Rspam-User: 
X-Stat-Signature: bxyr73brks8ei9s51nag8p1gky6hifak
X-Rspamd-Server: rspam06
X-HE-Tag: 1786920474-641663
X-HE-Meta: U2FsdGVkX19q8FUIQWowj1jq+5u8d/TpuVsvPxERZZyc53RX0TDXhGf4UyzSJA64JBQrm66N4tV9RSTryz9Vmln6v8C0Qd9R9Tr6OdM2USC7WLrsC6fjA+dm94ebsNjopmj3alLcKI2NuKAfEjegctzRYWWjkZFFnr2+XRGWNoXLs168tPgZ6r3FC+EEzias4F1cvZEze7LJiO37Bc3HdEfyVND/RRi9iyc2Yh5o1xv/qJFoI5HwTPIo3dP2j/YRS6mVMd00CtsbSb245m7n492mqBt1pQV5QrtuiyAMBA7ffQn06fEz07VFWfpNtlHpVVVLB13DhbTok5Htse6ZdGYKhWxTgE+bsuQbtVJfr3pVr1ScLsa8yjLU6Tu4lNQVwPMFQHeGvMYyQ/sYXwpDPpmf2RSuO1rV6Jw4pZnIX954eGOR6N/rtQjzulxdqIrfM0ewjKMJBGPsoWnL2Z8alvkND4u3+mBiln66mOhtOUUOXdJqEXKiu9sH4IDZi9YH4OkePV256g4TfkrO+5Q/Ua22N0+JfVWtrMLZkmWAXS8aJfExcyRFZaUtj5rnpdVYJVwyKw3YqOTfxOmzkCct9+okdk8OzoSytC++qWduj/KMEkzmRUP6Agg7LrD1VwhFPKgGtowzgZrJnjUN/Kzz08v0SG1rUlD6clYVNgfMSoiwlYPwgdpMEK0A6305btDRc1SI5ytobAk39LG1lJRIVeur736juEpQXpIyopAgxdapZuDzZ9fc2ui9j1xFzIu9Am2vZR2w+cvx94y17HpBFDEJZGBg9Sq1/wNMwJb0uiyXd7UG3rpHCGk8zFHSv9KTNz0dN6gePtzMuuTfEQzwNpz2ScciwBR5WA+UcD21cDztdDoq0Vtwt8hIBObNZD5r5j9G6daKftJCgiMlH5k+66NRmN90IJQXgoyNaSYhvgELoDWzCLbcWyWO1M+AnRj0o/MDCZOzNtzYoyhXkT9
 2DvAcyKT
 BP1fuWVtS+2Iz6GAenBZtUltUZ7zqH1W+iURJLEMjldi2uWIYzdIB7y91MqP/MKCpk+iR/Ncc3RAxCqm9KGHHzaJP/W2w3vowZcVkXjNnFhryscjVrF3JMGiLvKjTOlO0y1nws/HrwPOqDwehl2wcBEqglQqyDDDrhn4CE5T2+a1ZChspKiqnajC0mASoDt6wOUmX1tzsnj+Itx8tRy9a7PsoH5FuGoTWfiohu8GKansY2MJiNivt+JZdYlYC2s/vx2O3Te3BTYLcdHxK/9lQQYNk3fjYMF/diM3GRSFBdHPeTjiCGqOCP/i/se4P/rnKkhxxuM9KW19LLF0+ySpOSdm+iq71ou7LKQ28cRgwu5E1+flGyHfKU8zaSX6udCxufGZeeSj+W5BPrdbt0RTRDDsuTt1mGPuNpG0HRv55gA2fl8tlXKnZDmVFBZw8l6QWNJtdjBdr8BWJ0WU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

A collapse over a partially populated window has to zero the slots it
found empty.  The destination comes from the allocator holding whatever
was last written to it, and a slot the process never touched must read
back zero.

Nothing in the suite checks that.  validate_memory() only re-reads the
pattern fill_memory() wrote, and every caller passes it the faulted extent
alone, so a collapse that left stale bytes behind the holes would pass
every case here.

Check it where population and sub-PMD eligibility meet, which no existing
case covers either.  One page is faulted in a window-sized VMA; the case
expects the window collapsed, the faulted page unchanged, and every byte
behind the holes zero.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 50 +++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 85f138cfb9b2..b61e32566d47 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1599,6 +1599,55 @@ static void collapse_order_sub_pmd_range(struct collapse_context *c,
 	__collapse_order_sub_pmd_vma(c, ops, nr_windows, __func__);
 }
 
+/*
+ * A partially populated window in a sub-PMD VMA: population and
+ * sub-PMD eligibility at once. The unfaulted slots must come back
+ * zero-filled in the collapsed folio, and the faulted ones unchanged.
+ */
+static void collapse_order_sub_pmd_holes(struct collapse_context *c,
+					 struct mem_ops *ops)
+{
+	size_t size = mthp_window_size();
+	char *bytes;
+	void *p;
+	size_t i;
+
+	mthp_push_target_order();
+
+	p = mmap(BASE_ADDR, size, PROT_READ | PROT_WRITE,
+		 MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	bytes = p;
+	if (p != BASE_ADDR)
+		ksft_exit_fail_msg("Failed to allocate VMA at %p\n", BASE_ADDR);
+
+	fill_memory(p, 0, page_size);
+	if (!window_not_collapsed(p, size))
+		ksft_exit_fail_msg("Unexpected large folio after fault\n");
+
+	madvise(p, size, MADV_HUGEPAGE);
+	ksft_print_msg("Collapse hole-y window inside a sub-PMD VMA...");
+	if (!khugepaged_wait_full_pass()) {
+		fail("Timeout");
+	} else if (window_collapsed(p, size)) {
+		/* The unfaulted tail must be zero-filled. */
+		for (i = page_size; i < size; i++) {
+			if (bytes[i])
+				break;
+		}
+		if (i == size)
+			success("OK");
+		else
+			fail("Fail");
+	} else {
+		fail("Fail");
+	}
+
+	validate_memory(p, 0, page_size);
+	munmap(p, size);
+	thp_pop_settings();
+	ksft_test_result_report(exit_status, "%s\n", __func__);
+}
+
 static void usage(void)
 {
 	fprintf(stderr, "\nUsage: ./khugepaged [OPTIONS] <test type> [dir]\n\n");
@@ -1888,6 +1937,7 @@ int main(int argc, char **argv)
 		TEST(collapse_order_mixed_sources, mthp_khugepaged_context, anon_ops);
 		TEST(collapse_order_sub_pmd_vma, mthp_khugepaged_context, anon_ops);
 		TEST(collapse_order_sub_pmd_range, mthp_khugepaged_context, anon_ops);
+		TEST(collapse_order_sub_pmd_holes, mthp_khugepaged_context, anon_ops);
 	}
 
 	TEST(collapse_full, madvise_context, anon_ops);
-- 
2.54.0


