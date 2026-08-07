Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CB06C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 11:37:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDFBE6B0099; Fri,  7 Aug 2026 07:37:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E916D6B009B; Fri,  7 Aug 2026 07:37:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA7776B009D; Fri,  7 Aug 2026 07:37:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B10566B0099
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:37:07 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 49A0A1C0C96
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:37:07 +0000 (UTC)
X-FDA: 85074272094.12.3341D1E
Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	by imf14.hostedemail.com (Postfix) with ESMTP id 618B1100009
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:37:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="m 2UMoDi";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=DITeJelQ;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786102625;
	b=bJEyI+RMoPeNpIhVgSs7PL/JsfbO5aG7sp3AaNStzZiWA4xYNeZKgkrVLVcrxhq68beQC3
	tvzXdb5YLe4aOocSfS2G5sMt/vDIC3bfwFX134+D7yWSxuSN2bKeFIFcpYexyxawgn/W4u
	F2jVkQ9ZIAt24Yp602EqMhiFpBhwWS8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="m 2UMoDi";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=DITeJelQ;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786102625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A0HHfxeX5RuaRDWyznuRMDrKtp+1CgdzuTwwJX2D5b0=;
	b=MVqxWCjmHIIgIqB3m08V3sfAKPDDJjF1IG57OWeCAfHNYPvrCLxD8Gqxm1S9l/+zfPHtry
	xoE9ZhXzjdpSPWnLpSawX9+Uckmv5rw402ADm3aOFwKbSQdE0QR3zscAUt0Ons2wtAA762
	OTn3wN6f6fxseBhoAYbcXL0kiuln3+E=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id 2DF841D00082;
	Fri,  7 Aug 2026 07:37:04 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Fri, 07 Aug 2026 07:37:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786102624; x=
	1786189024; bh=A0HHfxeX5RuaRDWyznuRMDrKtp+1CgdzuTwwJX2D5b0=; b=m
	2UMoDijXexCVrGBOds9UUyroJkfOqIZhMvFfFDoPFjj5ahoY35kTY/Pv30RU53fV
	TTr6sAemI4NKo0rrn9qfby+0AoBcOPvpr11lOyb/uABlw1JLHodEtqcXXUqg659k
	5rkapFsSj5NcWKdKrp1z0l/qZ/kWG1k2vEIUVryFh7uNG6nSP362NXheGHzjc2ds
	Ty4ydTPHnCojmOzOhy8G7YxfJ/fzEeDYAV1fHgFT4Z8c8rJdSV0greQOz0MKLXiD
	7LqJZOppb3ai8dSFlnWWx8cNMPIAWvDiRH6CMkqwakwPmuea+yNH4aki3mdZuzzZ
	hMv9AUqlvTygqC/oq+JgA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786102624; x=1786189024; bh=A
	0HHfxeX5RuaRDWyznuRMDrKtp+1CgdzuTwwJX2D5b0=; b=DITeJelQOMZvsRliO
	L1AswV/l0UkmK8H9jaIiWQwLHU0xJjox9kwCdwMi1mTJvxPGAmgHtmQuQrvEA+Is
	nQ4ew0Y83uATbbvoobhX3xPqRSrLtidRltxiSezlrHrQGqFL+aORPRwRZJIwB4Z3
	3YWupHEHyECwl26ACtVV2XwbRW8LLN8vO1Iq9Pd1ho9TUSRUPDFfL0UwmhPzrRHh
	+iRD0kKcxbBz4BJ3gesfAP0VFAfLdCdaHJrmxoMaeOQvCvJNp0cdEcYl/e2zhu43
	o6O+KG6Tz/kTs7DJAYdYYaQ8rYVew+GRkdkR3NC6wRN9SxMTH479HZwm1bsFt0hV
	ec4fA==
X-ME-Sender: <xms:X8N1ai_GtLVsW6w7qbbz-YP3Z1g9rIoYmhxh-Ltfjq22Uws7_lTouA>
    <xme:X8N1aunbF4bWXYs67EY06Ubl-D6vu-9FT4Y328q6x8QYu00hB1rf6_QrQqrxrMLej
    gA2P3LmLXm3xy-hlmo-4u4nEEoxNybZQKQaRmdVlVGGalO7NtlCg0A>
X-ME-Received: <xmr:X8N1ag0JZMLArwVfPOG_FWXPqAtAQ6LQeTUbfCFJsFSBSn5bBCqTTeb-ULM>
X-ME-Proxy-Cause: dmFkZTEfW3x2Qrq7ELqxlr/x69vk0aYaa/E/2AWrFAl7yu0Vg+jIGlS0mjOCk5J5e5/NJH
    T3J+l8M+cQ15gxg/u6FQhwxKudsrf7tN5cWcEThveGDS0KcOU0uMrzGx0YBmylEV4PfT2X
    SbTqClZY3SINVohR/2NzYRxeOu5tU+SgKqY1sS5oM8U15+ky277S+G1Ww7YAUM5Z6EK46p
    TQK1COWwyEQl/dhwe51H5lWCLFzTj8K9hkk/JBO/DvOgEgoe5sMihzFP04eKTIrZCF8dte
    tQwhoNU+zszgTlPncqprVsvTwAgpjyPciGBDZXKQScTz4u1orAuTZg8Fi2VomZsbF2qQo6
    JT6Sdos6SVoZTTW3+wS1zU1oDV+fbohsxvhGj0aeg73Xml+3CBIK14V5C8qv4Asbm9bXKZ
    Eh7U1twb1bxCOrCTVx7DPnpB29er5uVSfoP+NWHNHQEya3MER92j1+HR/PyTKk+R5j3bjf
    KwuIkMP1Ne0I34rb8/q7DifDC/AnEY0jLOJhKfPfqUvCoYYMQ5L/gOgu1YhwvO/8KVuSCC
    5W0edYKA3/t1jWwxDfYFy6oXwGzxzfi38ItQrh4PocwCS75TZdwAPkjtE2s7t4nUL8BiPG
    1k6qk00KQU1fwiF0KCDdk7UOhnJRzHRmWaHLty6LpaM3ChWMft+QdOZpcW5w
X-ME-Proxy: <xmx:X8N1ajTbfRGFwZ61P_Hqd3FN9mMc9uiNss-caJ7r2SHf-joN2ZmIfA>
    <xmx:X8N1agMfwLDEfZEyyq7gBujQUytAqDB-N7xkjJhkUig8sNRdKrZIOQ>
    <xmx:X8N1angMX15MLripPeQutwyrSSNIRt9rguRiVBtVOOi1rJKlihEIVg>
    <xmx:X8N1agJO7npsjhnUkrZ77t8dZ1aUQGpFB0Lnd0oPLZACWxNOX4AJNw>
    <xmx:YMN1amFQi41bE9evRu6RM-nVdGnNt7vywJELXcMg54XWdHcNIp2ZS88Q>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 7 Aug 2026 07:37:03 -0400 (EDT)
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
	kas@kernel.org
Subject: [PATCH v2 05/17] selftests/mm: move is_backed_by_folio() into vm_util
Date: Fri,  7 Aug 2026 12:36:35 +0100
Message-ID: <20260807113647.3744609-6-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807113647.3744609-1-kirill@shutemov.name>
References: <20260807113647.3744609-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 618B1100009
X-Stat-Signature: gsg99bme93yr676896ou44csj4im71mn
X-Rspam-User: 
X-HE-Tag: 1786102625-316784
X-HE-Meta: U2FsdGVkX18n9BaT/Nrf0T6HG+g+VLWq3TDKJe3aHVilvUS5zOnXeb8G5cmr8Mrti+OtN+d0IpHD/NZUP4VY8232rIULG36H7t3jM1rhlihdfhQXbPeW+9lasPF6PJ/Wo8/p/t4620uLXqZ2q77aeDlaEzr2xca9w2TbIn24+Hd0Yi0yMU1L33kXlgfa10kuGbiHILy1Lzyo0LHd2TCcrn3fNiYRFkVuJCsmhHuj7c0UxkE8YNhrvWCqK1UO5FmQtQnFuMhEFniKhaWFEJgSAPo+h4joRzD3ZVoCQ+TIO2vLHbBUJFeGYkjqZLX3EesuJjMi07cyvBrM5oNMLYbHdN67pv7bLxf3s+7nVgBjUec63mNsKPUUXEtcVD38gFlR0iT5H7PJYw2bqZsVrRPIy8iK+fG77XiwyVn7MLGpiFx6MHcQ/fvMCWDA97ac3lBgPX+97OZDyjVL9DEbHeXA47OhecHRI7XNGLyobNMz3M+UAGm4dTRwL/igTbYf/Nrf+PRSKx/2Md3lSaVwx+wM/H/wGPtIvp/vUwkG3RtFTtvuiWuF3g48VkNs+THwQqSkWJ5QRiffuuaHYUYkS6rBt4Vy1JrSF5wDUFB2dX+WxxxYHJaSr3koScdV6oLgrQoxU5WGbr9Mi1K4CjxNd/qJEw5/V5pl7H3ay3Mg+/OepS407vNBLuSejUMboiLmr80nchw4yiCP4/BIaZ8FMBrPgTkYJkm++PzTZ37TzUZsk/QnOSkpn154pVOu2cGUYH5QdngvRboV6ZvpkdsJPGL+piqQum2Qo2kqiZPwpc5f9yzzeGBqTBzAN8iOGbFt1Plr5lvlMxB8I1VN3pf5yooUHWTnAc3ERIBDQzSBMfuBjuBQWOI4uVvkK5260cjRoQCVJM4u4ILySjsgZMB5wAxOEr4pHc+NRJUSLNiX4k425d3xPsrXLnFtI3u0//Rm6kizh70EbA9UGh9zUPd0D+t
 TY/yxrmg
 7wmTGaOy1WSBUZPtjPjjdbAPiNG0vFo3YYjUUFNNAi5FxWOTqioQaRBD9oiR86ViycyW7vMoyfmYUdDuNJUChX2IWAbAbVr/mmDhWyyu7O55rc6jMk8dVx65vXx/wCOoRc5ZWZsW31bvxbqohguoHzzwnqepl0w9kp9AxraKGTJj2SqIMsbBGFcW5KG/uqglU6MG2bT+FUi/R9gtisro52FJUa4px7mSh0s5SYwddrTbIK9GMGjbZdVEKhd2QwsmHPUrWbrpzb5iK3JvOsKH5M+FKMmG3sWXTl7XXB+0QeMCYKuBZN3g+2ES60tlFccpbKiqmvoZFzOWoWq2Gsgfkq9FYwcVQPOoLr2Xb+AedMXt2EKXhKgBuKLWIaQ3hkZ24qw5ZmiQOeiw9bHBOxiKH0Qa1QawiNMP9WUBIKxx4m1MZKd6Pc5MsuS4CDsb9MUDvJ/9dL314h7zJ51lGdW/oWdf0oh4w6rf/Nxa/CejQ6m24pe5G8dBOUVjgOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The khugepaged selftest is about to gain mTHP collapse coverage, which
needs to check that an address range is backed by a folio of a given
order.  split_huge_page_test.c already has the building block:
is_backed_by_folio() reads the compound head and tail flags from
/proc/kpageflags to classify the folio behind a page.

Move it into vm_util so other tests can use it.  No functional change.

Assisted-by: Claude-Code:claude-opus-5
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 .../selftests/mm/split_huge_page_test.c       | 62 -------------------
 tools/testing/selftests/mm/vm_util.c          | 62 +++++++++++++++++++
 tools/testing/selftests/mm/vm_util.h          |  2 +
 3 files changed, 64 insertions(+), 62 deletions(-)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 86a603692826..0adfe7dde7e5 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -42,68 +42,6 @@ const char *kpageflags_proc = "/proc/kpageflags";
 int pagemap_fd;
 int kpageflags_fd;
 
-static bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
-		int kpageflags_fd)
-{
-	const uint64_t folio_head_flags = KPF_THP | KPF_COMPOUND_HEAD;
-	const uint64_t folio_tail_flags = KPF_THP | KPF_COMPOUND_TAIL;
-	const unsigned long nr_pages = 1UL << order;
-	unsigned long pfn_head;
-	uint64_t pfn_flags;
-	unsigned long pfn;
-	unsigned long i;
-
-	pfn = pagemap_get_pfn(pagemap_fd, vaddr);
-
-	/* non present page */
-	if (pfn == -1UL)
-		return false;
-
-	if (pageflags_get(pfn, kpageflags_fd, &pfn_flags))
-		goto fail;
-
-	/* check for order-0 pages */
-	if (!order) {
-		if (pfn_flags & (folio_head_flags | folio_tail_flags))
-			return false;
-		return true;
-	}
-
-	/* non THP folio */
-	if (!(pfn_flags & KPF_THP))
-		return false;
-
-	pfn_head = pfn & ~(nr_pages - 1);
-
-	if (pageflags_get(pfn_head, kpageflags_fd, &pfn_flags))
-		goto fail;
-
-	/* head PFN has no compound_head flag set */
-	if ((pfn_flags & folio_head_flags) != folio_head_flags)
-		return false;
-
-	/* check all tail PFN flags */
-	for (i = 1; i < nr_pages; i++) {
-		if (pageflags_get(pfn_head + i, kpageflags_fd, &pfn_flags))
-			goto fail;
-		if ((pfn_flags & folio_tail_flags) != folio_tail_flags)
-			return false;
-	}
-
-	/*
-	 * check the PFN after this folio, but if its flags cannot be obtained,
-	 * assume this folio has the expected order
-	 */
-	if (pageflags_get(pfn_head + nr_pages, kpageflags_fd, &pfn_flags))
-		return true;
-
-	/* If we find another tail page, then the folio is larger. */
-	return (pfn_flags & folio_tail_flags) != folio_tail_flags;
-fail:
-	ksft_exit_fail_msg("Failed to get folio info\n");
-	return false;
-}
-
 static int check_after_split_folio_orders(char *vaddr_start, size_t len,
 		int pagemap_fd, int kpageflags_fd, int orders[], int nr_orders)
 {
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 360c9ec6702b..3c276865a778 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -494,6 +494,68 @@ int pageflags_get(unsigned long pfn, int kpageflags_fd, uint64_t *flags)
 	return 0;
 }
 
+bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
+			int kpageflags_fd)
+{
+	const uint64_t folio_head_flags = KPF_THP | KPF_COMPOUND_HEAD;
+	const uint64_t folio_tail_flags = KPF_THP | KPF_COMPOUND_TAIL;
+	const unsigned long nr_pages = 1UL << order;
+	unsigned long pfn_head;
+	uint64_t pfn_flags;
+	unsigned long pfn;
+	unsigned long i;
+
+	pfn = pagemap_get_pfn(pagemap_fd, vaddr);
+
+	/* non present page */
+	if (pfn == -1UL)
+		return false;
+
+	if (pageflags_get(pfn, kpageflags_fd, &pfn_flags))
+		goto fail;
+
+	/* check for order-0 pages */
+	if (!order) {
+		if (pfn_flags & (folio_head_flags | folio_tail_flags))
+			return false;
+		return true;
+	}
+
+	/* non THP folio */
+	if (!(pfn_flags & KPF_THP))
+		return false;
+
+	pfn_head = pfn & ~(nr_pages - 1);
+
+	if (pageflags_get(pfn_head, kpageflags_fd, &pfn_flags))
+		goto fail;
+
+	/* head PFN has no compound_head flag set */
+	if ((pfn_flags & folio_head_flags) != folio_head_flags)
+		return false;
+
+	/* check all tail PFN flags */
+	for (i = 1; i < nr_pages; i++) {
+		if (pageflags_get(pfn_head + i, kpageflags_fd, &pfn_flags))
+			goto fail;
+		if ((pfn_flags & folio_tail_flags) != folio_tail_flags)
+			return false;
+	}
+
+	/*
+	 * check the PFN after this folio, but if its flags cannot be obtained,
+	 * assume this folio has the expected order
+	 */
+	if (pageflags_get(pfn_head + nr_pages, kpageflags_fd, &pfn_flags))
+		return true;
+
+	/* If we find another tail page, then the folio is larger. */
+	return (pfn_flags & folio_tail_flags) != folio_tail_flags;
+fail:
+	ksft_exit_fail_msg("Failed to get folio info\n");
+	return false;
+}
+
 /* If `ioctls' non-NULL, the allowed ioctls will be returned into the var */
 int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
 			      bool miss, bool wp, bool minor, uint64_t *ioctls)
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 9a49af88702e..56a28ce7d029 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -97,6 +97,8 @@ int64_t allocate_transhuge(void *ptr, int pagemap_fd);
 int pageflags_get(unsigned long pfn, int kpageflags_fd, uint64_t *flags);
 int gather_folio_orders(char *vaddr_start, size_t len,
 		int pagemap_fd, int kpageflags_fd, int orders[], int nr_orders);
+bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
+			int kpageflags_fd);
 
 int uffd_register(int uffd, void *addr, uint64_t len,
 		  bool miss, bool wp, bool minor);
-- 
2.54.0


