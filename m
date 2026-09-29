Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C6E6CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 13:15:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83DA56B0098; Tue, 29 Sep 2026 09:15:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EE0A6B009B; Tue, 29 Sep 2026 09:15:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F32E6B009E; Tue, 29 Sep 2026 09:15:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 41BD16B0098
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 09:15:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B2589A04CB
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 13:15:32 +0000 (UTC)
X-FDA: 85266846504.19.DE06BA6
Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	by imf23.hostedemail.com (Postfix) with ESMTP id C953614000E
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 13:15:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="q soWTlE";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=mw5m8tJl;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790687730;
	b=qBx47UpN3upE7jff09SZ2lQPCUVK3Ms/7l26KL/nIAwLRnytbWMjmb6TGzWGJKC9wo5AZH
	gUlAT3JJelZYlcxRJCC6dD2bFfi/LYdKd9W0ZCkjPQjwxN+PG4qrcKSVBtQdKIzzm1aNbw
	acbs4+0eydCC7GUNsBbH6e0vSuwlXxQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="q soWTlE";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=mw5m8tJl;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790687730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/NRM+30LF3fSp2SYSiPK3zeAKDOCZTbBueBx+rIrKFw=;
	b=31hToBGt+edvtPjlfpvbI7H7YpiEyRKRI+p7LF8hmVOQ11FMAhMfpqNwYhwQLej2/QFhqw
	vL9xDWBuWkGlX7hjfdC/0M36DMGUwEuNypbuoH2nFx/FJ0cEh4v6VdQw9PigqQtcqxVRGs
	8DOg62QywVJwn95VFt6MyDg0bQkjRCo=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id 5335DEC0F91;
	Tue, 29 Sep 2026 09:15:30 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Tue, 29 Sep 2026 09:15:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1790687730; x=
	1790774130; bh=/NRM+30LF3fSp2SYSiPK3zeAKDOCZTbBueBx+rIrKFw=; b=q
	soWTlEniC7hPsRKBt6mX+toSvDFGq1kghjGlSAOZtE5TqYsZoQbd5yWASLtoSDzE
	1zjt3wShcpzdmMzAimtuyieKKTjMyZxjvuGdlRi9FfF5LCkhf4795TRHOC7eezxq
	VVoHqeLs5zbV/tqSeDKrOZnJoZvF9DGWWiu5pf/Hra3ppBVtnXXULS4czS3P8PW1
	cuHqzf6hEzXuzcYhnR8LW1XFvP8y84za5FJoWYZFVhVS988iEKJ/Z+IeHJSQSJnc
	QIFrGL+f/bLHINP7Nl9bqP7peFtZeis8mGCgdIAEsdeFzyT//n81vqMI9Q2yCT/C
	lIuv2Ln23U/0xHPTcICdw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1790687730; x=1790774130; bh=/
	NRM+30LF3fSp2SYSiPK3zeAKDOCZTbBueBx+rIrKFw=; b=mw5m8tJltb4F0wBqv
	CZLolez7HBTAxOkTvryYVFTqmYXHzmVPMp7aZsmnHWIbkhapsEUUrCOtcuXhecUT
	HCV+Mu+WLaM33/rpb87E/gzAsG31d/Mt2MTc+jBxtvvp2OILZApXWpHFuPG0YR7T
	Z+srA9shebt1KJaQyZOL9TBgkFipKrE4b8sKuloGHVzeYmQMkEh9i99uyeNqPoOj
	afGvShmZXC40f0po7FBSghquGGjnZ+n+IXqJmHvyiYwJdjRoSVQD7zLqApUT5L/v
	FlzaunI7BgpCGwiYLTJjXf4a94rqF4pvHsES2rhZZMW6iD3yh59dXzsNxiBBgAYf
	5gGhw==
X-ME-Sender: <xms:8rm7aqUtFeP9mfXehK-z0JCBwwuDlw174gtGSTMdjnTTDcbj3m8QCQ>
    <xme:8rm7aoO06_bmjAtsjqQb4Nk44D3eaw6oSHbezAq8IInuaCXC88B228SbZyp3s25cc
    GyyH4WkK9Df7r9usdr5U8tGBKSEnRrKOaJaWNi4EKGPEOfgp61p3PCy>
X-ME-Received: <xmr:8rm7aidzD1DvRtqiJ0-6UBISidYFXXd6jnGZclS5D2EgHFuG-llREv6rgwI>
X-ME-Proxy-Cause: dmFkZTGYccH7Ntb7J02Xj6JuS6MvJY1gl/a+neyh0zdr6nO/D8luWVmgZr3vVncFfxaOyz
    sDayM6uE9Hs1eK+ME/un6msYT/H9GLEGqCUuaUC0DyOMSfCWuXDxjPjsdGPyoevruFuRE+
    g2yJgkk5PdFa3SMVKZ6gjwNZL3TlLTTB/zh71tz7d1GIGv71iHICfh77uMSsSdxCueqjsF
    W9a0jjllcDDBY3d85i1vta2YOFpbdbcbcx15YCW3q0go4uhoLMlvpNUCT8+kMmJ22Ad1HO
    uVgBzj94RdAq0amic7bSBxVqTdtP3Nc9GZu2B+9nbtIeSv2ligKQDG9XD/qLIwJ7GU89iU
    rTlPqWD3zOfPv6Z7yVwA7Mi6Q+NDWZ73FxELmWRK5x1pt6EeVosS4ehFeT0mODMVkxrpjv
    RZdOQSz8z5ISUIAhJi9UEiiVFSaZKOCTFEPCGAaCNGYbN1KQm+If5qwoSxCFhcTLdvhu6O
    ZyjeP7Xxli2rzre3xhHAW+AqfUeuWsilfZKDsnOT1TOevWBk/9n3OJvp6Johjx1tw2tvjS
    nKSyiGsg7iVsUt/DBIAF0GDjI6bjRSm3BRdq/ITzNfyaawuG/MegNI71X+TbgxaCPVgfvt
    xmLx+oOhbJps0TGcBuAzwmw89aKiPwn55vcWSkyox5eXw/buLihT4GPw2ctw
X-ME-Proxy: <xmx:8rm7any4Drj1igL2P8dX5oQ2KuwWRqTKqewa_6iVZJ766AmJS1pXmw>
    <xmx:8rm7ajiRTgB5o6-dHlz9g_0KUBlIX4bDG4UxNVGcN4Q56lOcAdpkiA>
    <xmx:8rm7ak4Y3Sk5cMp0g1fJZJ5Os5vyGlZl9apUsA6VzO_teYC-jTE-Pg>
    <xmx:8rm7agp-DdsPocYRLedTKjOQRfOiJls28rel3YvTvAWOqC1hyflsDg>
    <xmx:8rm7au2LO1J5SCQw_dpBcdyiqrrpSZkQLp78tJEplgCAjSTsFEyxx31i>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 29 Sep 2026 09:15:29 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Shuah Khan <shuah@kernel.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R . Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 2/4] selftests/mm: check sub-PMD ranges window by window in check_huge()
Date: Tue, 29 Sep 2026 14:15:17 +0100
Message-ID: <20260929131521.153079-3-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260929131521.153079-1-kirill@shutemov.name>
References: <20260929131521.153079-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: osajn4phcna9irrxqjsnxhmz1txzy3iq
X-Rspam-User: 
X-Rspamd-Queue-Id: C953614000E
X-HE-Tag: 1790687730-709278
X-HE-Meta: U2FsdGVkX1+BV8hBMV93VsyqSqzGo+yMUiTMLqWfwLQ4SnaMsc4jQr0pRc3Z2OmezNhYYMP6QVXKM8tqFg1zRsyTDt14+Ugw/shslsnMqZYmiwteWgWtyiHwK5Od+NzBzDZH0Tllh0SqZPJfaZ4DAMep9W1/QQr31dKnearpAo8bUnmVpUZDw3G42EvZmw9loVG2rKPyMaFYGR6Tq3hIM4LUSllDaMsXXHNaXE2fMB4KHm7HnKtvJXc4XnxJ2J3xRRY9d0GcTclQOdsQYrFw8Vjtap8qRdyk+Km5EF3RaP2HL+1uKNx2/Msu8aEdXgt+Hn6Z6ypXFVz3ojAn0tdCrr20aY/NDxWcqzAUUgTPvywjweZ29mpwPwXMn30Jd0+dlH9hZoZP+vavrYo/Xk20ti4fGMQgPcqUkDWqS4tHEMk1RBsTsEcXDGCDZST8zZ2Js5rjrz8nGol7q60O9bk7ZlahZb0mBh1tSxGlIrzHe3PWVIBpBEUN/LvDlae4DVmpzCv2arkjcV+470h/cKGqV3MVKGth2tlz9+bvQoz9UKIGVsc6oHgT/I9nYtmRsYsZaehM+aTaqt4WQBdMCSwv2f3Kg7RD/FGkw0q/q6a9Y6e9x948x4q66ZWBpUsbnw3jvTf4MfbXVEUE1v0dQYGP/YufmztT0rR95lfGcNTbMUISOVdWc+9I+YlPt2Isk4vLQSvEJjOkpQtM8aM3vRpi8pB3fORUKiYDDqJhoL4h4jTAP/D1dq1FqAg+dDmeJDDwtGcHut5nOHLUvMSQYaZYt2O/crgl3SagpRlR5iCs5TvvGwEKIjDd73hVcN8sxVNWCovHcvsV8OftTDT6IVpoNFTqS47dZz+/GEDa8JUM+Hu6xps6AAk1bsynIMVhS/91Rjn+Es/f9bdF3b7BhXoJp4Bz0KWWfHfQQmbsHiwe83Xdx49YW0nmo71JDvWcTGe54UDhGPrSZxIRJidkFZb
 LTq+lUCW
 QlXFQW4GtReYPX1AQnvDlBkMxCycair2TUHBMfQ6I9rVYbmj5EyXecEcLxRTInI9nVnlqAOa0YHBoENTCmWMB0DgkPBt23edIEsJ10cdMIbcVpGRGuDbqcgfUADHxmiE5Jit2KoT9iSMuehFq4b7w7OVbeE1BBoMm5aB1gLCKHF9Mpe47q39pA6WzhxABsW5d0snOfM1qS7yad02p9652KvPlbI3mWlsDN+YSo8nvp2G23gVQIW4f62yzESv3cSoMbKAJJOgvdoq/emNxn6/X1qp8hbsotRGwsHPrRas0/RBrYHLzh1vRXxyGqdVDvdM8bIo3PsZaBJnNB3NsMkYgO4npuE62rcKfh/e0I4cXYEvIf3vA92Sd8/+l2eyewZZKaUNt9hrHEMgKlGXUQ1Qfq6QAsTSSKgQHC+109PfjQ6ox/MI8D14tI8FlMIebXBnIJ26g9BWLP7dPMX4RKhTwHgK3YwnJq64t9HsaH5nU7+ckvbxpavcF4VhTyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

For orders below PMD, check_huge() counts folios of the requested order
in the range and compares the count with nr_hpages.  The count does not
say where the folios are.  A folio mapped at the wrong alignment, or
split across two windows, counts the same as one placed where khugepaged
would put it.

Count aligned windows backed by a single folio of that order instead.
is_range_backed_by_order() already does it for one window.  Move it up
and use it.  All callers pass PMD-aligned ranges, so the windows line
up.  The PMD case is unchanged.

This is preparation for using check_huge() for the collapse_order cases
in khugepaged.c.

Assisted-by: LLM
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/vm_util.c | 131 +++++++++++++--------------
 1 file changed, 61 insertions(+), 70 deletions(-)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index e284e378d806..0a4b85e29e14 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -17,7 +17,6 @@
 #define MAX_LINE_LENGTH 500
 #define PAGEMAP_PATH "/proc/self/pagemap"
 #define KPAGEFLAGS_PATH "/proc/kpageflags"
-#define MAX_NR_ORDERS 20
 
 unsigned int __page_size;
 unsigned int __page_shift;
@@ -397,34 +396,72 @@ char *__get_smap_entry(void *addr, const char *pattern, char *buf, size_t len)
 	return entry;
 }
 
-static bool check_large_folios(int pagemap_fd, int kpageflags_fd,
-		void *addr, size_t len, int nr_hpages,
-		uint64_t hpage_size)
+/**
+ * is_range_backed_by_order() - check that a range is backed by @order folios
+ * @start: start of the range, a multiple of the folio size
+ * @len: length of the range in bytes, a multiple of the folio size
+ * @order: the folio order to check for
+ * @pagemap_fd: open /proc/<pid>/pagemap of the range's owner
+ * @kpageflags_fd: open /proc/kpageflags
+ *
+ * Every folio-sized, folio-aligned part of the range must map one folio of
+ * @order, head to tail, with the head at the start of the part.  A part
+ * backed by several smaller folios fails, and so does a folio mapped off
+ * its natural alignment.
+ *
+ * Returns: true if the whole range is backed that way, false otherwise.
+ */
+bool is_range_backed_by_order(char *start, size_t len, int order,
+			      int pagemap_fd, int kpageflags_fd)
 {
-	int order = 0, pagesize = getpagesize();
-	unsigned int nr_pages = hpage_size / pagesize;
-	int orders[MAX_NR_ORDERS], status;
-	bool ret = false;
+	const unsigned long nr_pages = 1UL << order;
+	const size_t folio_size = nr_pages * psize();
+	char *vaddr;
 
-	if (!nr_pages)
-		ksft_exit_fail_msg("invalid hugepage size\n");
+	if ((uintptr_t)start % folio_size || len % folio_size)
+		return false;
 
-	order = 31 - __builtin_clz(nr_pages);
-	if (!order || order >= MAX_NR_ORDERS)
-		ksft_exit_fail_msg("invalid order\n");
+	for (vaddr = start; vaddr < start + len; vaddr += folio_size) {
+		const unsigned long pfn = pagemap_get_pfn(pagemap_fd, vaddr);
+		unsigned long i;
 
-	memset(orders, 0, sizeof(int) * MAX_NR_ORDERS);
+		/* Not present, or a tail page */
+		if (pfn == -1UL || pfn % nr_pages)
+			return false;
 
-	status = gather_folio_orders(addr, len, pagemap_fd,
-			kpageflags_fd, orders, MAX_NR_ORDERS);
-	if (status)
-		goto out;
+		for (i = 1; i < nr_pages; i++) {
+			char *page = vaddr + i * psize();
 
-	if (orders[order] == nr_hpages)
-		ret = true;
+			if (pagemap_get_pfn(pagemap_fd, page) != pfn + i)
+				return false;
+		}
 
-out:
-	return ret;
+		if (!is_backed_by_folio(vaddr, order, pagemap_fd, kpageflags_fd))
+			return false;
+	}
+
+	return true;
+}
+
+/*
+ * How many hpage_size-aligned windows of the range are one folio of that
+ * size each, with the folio's head at the window start.  A folio mapped off
+ * its alignment or split across two windows counts for neither.
+ */
+static int count_windows_at_order(char *start, size_t len, uint64_t hpage_size,
+				  int pagemap_fd, int kpageflags_fd)
+{
+	const int order = sz2ord(hpage_size, psize());
+	int nr_windows = 0;
+	char *addr;
+
+	for (addr = start; addr + hpage_size <= start + len; addr += hpage_size) {
+		if (is_range_backed_by_order(addr, hpage_size, order,
+					     pagemap_fd, kpageflags_fd))
+			nr_windows++;
+	}
+
+	return nr_windows;
 }
 
 enum check_huge_type {
@@ -471,8 +508,8 @@ static bool __check_huge(void *addr, size_t len, int nr_hpages,
 	kpageflags_fd = kpageflags_fd_get();
 
 	if (!check_pmd_mapping &&
-	    !check_large_folios(pagemap_fd, kpageflags_fd,
-				addr, len, nr_hpages, hpage_size))
+	    nr_hpages != count_windows_at_order(start, len, hpage_size,
+						pagemap_fd, kpageflags_fd))
 		return false;
 
 	for (; start < end; start += scan_mapping_size) {
@@ -608,52 +645,6 @@ bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
 	ksft_exit_fail_msg("Failed to get folio info\n");
 }
 
-/**
- * is_range_backed_by_order() - check that a range is backed by @order folios
- * @start: start of the range, a multiple of the folio size
- * @len: length of the range in bytes, a multiple of the folio size
- * @order: the folio order to check for
- * @pagemap_fd: open /proc/<pid>/pagemap of the range's owner
- * @kpageflags_fd: open /proc/kpageflags
- *
- * Every folio-sized, folio-aligned part of the range must map one folio of
- * @order, head to tail, with the head at the start of the part.  A part
- * backed by several smaller folios fails, and so does a folio mapped off
- * its natural alignment.
- *
- * Returns: true if the whole range is backed that way, false otherwise.
- */
-bool is_range_backed_by_order(char *start, size_t len, int order,
-			      int pagemap_fd, int kpageflags_fd)
-{
-	const unsigned long nr_pages = 1UL << order;
-	const size_t folio_size = nr_pages * psize();
-	char *vaddr;
-
-	if ((uintptr_t)start % folio_size || len % folio_size)
-		return false;
-
-	for (vaddr = start; vaddr < start + len; vaddr += folio_size) {
-		const unsigned long pfn = pagemap_get_pfn(pagemap_fd, vaddr);
-		unsigned long i;
-
-		/* Not present, or a tail page */
-		if (pfn == -1UL || pfn % nr_pages)
-			return false;
-
-		for (i = 1; i < nr_pages; i++) {
-			char *page = vaddr + i * psize();
-
-			if (pagemap_get_pfn(pagemap_fd, page) != pfn + i)
-				return false;
-		}
-
-		if (!is_backed_by_folio(vaddr, order, pagemap_fd, kpageflags_fd))
-			return false;
-	}
-
-	return true;
-}
 
 #define TRACEFS_ROOT "/sys/kernel/tracing"
 
-- 
2.54.0


