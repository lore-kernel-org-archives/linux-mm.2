Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22437C982D7
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 00:25:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0D926B00B2; Fri, 18 Sep 2026 20:25:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B75BD6B00B3; Fri, 18 Sep 2026 20:25:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A85F86B00B4; Fri, 18 Sep 2026 20:25:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 81FE36B00B2
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:25:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0D457120153
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:25:16 +0000 (UTC)
X-FDA: 85228617432.18.0FF83C0
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2BC7620002
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:25:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="d zcUVM1";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=OAtfrkZO;
	spf=pass (imf13.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789777513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E20qks4EGRXlLr5iwwk3xar+b94xA/2CHubWgJ4qnkI=;
	b=jGmrSqhz6JPrNgf4Y9BT6kwdXMdQVFHQDxpCmteFXZqyfcriuMxsNbq+d96AQJSuJ6UDyF
	DTrJNIdjUiVdug16Sbqj/8tEUC+KFN06cIz95AQjUIclXCLb3XiUbBy/cZ8DG3VuPsUdGU
	cLECKx5ItnpX3HnbUdqC/jo/Hlm2FkQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789777513;
	b=Rg+Qs7EGeMTjuVoPQXPtIkdn6VEXCwEq0LDkbnk5C48BWEbxYjXqaLdu5jRjIE4TxZaY9w
	Vs75kwXzr8QrygCtyI9vPZECr4wCzc9GtfbAlVWn5nfFfzaSnps2TrLmKbYRBikdPDFq52
	POUmaW1tb5fjtzjsr21Wn4kZPlugIuQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="d zcUVM1";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=OAtfrkZO;
	spf=pass (imf13.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id AE46BEC0232;
	Fri, 18 Sep 2026 20:25:12 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Fri, 18 Sep 2026 20:25:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789777512; x=
	1789863912; bh=E20qks4EGRXlLr5iwwk3xar+b94xA/2CHubWgJ4qnkI=; b=d
	zcUVM1Zub0MueH1wRB6cZbScLWZsIjm0WsCXCmlW65fcbX3MDA1WcsrjsQCHXFas
	1UXuuGhUBJcBgg68DJy2MHUi68VLZA0fjqHRZ3c1w+akUpK7iYkmIZDU597p2GIC
	BC7fRP4YbfGG10J0VCMwRp887LsAH/+tBc9F7+loTw2jgRQqxgRKKoHeWS1I9TyI
	E3p1e/cmaNuoLf3z+parbFJS5LaIVXprQtm2jCgesrPjPsErl/hPkIdLqnSEbvle
	VFWufWVEqWK+OPl3eBZ0xpZco/4iXBxSvgfFF/TDgvG8wfEKRV+RnDBijYaEq/WH
	Ge+nPuFx4KJ/8HvFMlxGQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1789777512; x=1789863912; bh=E
	20qks4EGRXlLr5iwwk3xar+b94xA/2CHubWgJ4qnkI=; b=OAtfrkZOIBPmRkb6u
	zmmiAT0WXBX0k6glN1ORs9tpqV7JoeCnkmND+oXdLCNcDStC9HJzAjL+PloWSoZe
	Nx2ffaaVrBCPEXZFYQGwY76Hc707EDcEy8dtDSBLZSjgSGeI1R7HS8EhfIxlDv3c
	N1+2p3VTSzMsDvIDAZi/KAVOb5SVh3Zu1Zk9dKkhuLHvBXE/fyj8ICvOtFhRuqTM
	68v5f4S5Lr9A7AhlyTpDYWTJKpiXYTVDj5tI+jHBM4TbBTInsAn6NRjRc4R7DfZv
	8E7F2SBim/TXwNc+Emt76W65rDU/i0PuhOjowLdku97OAb/wkfpR0bIX5Rfuiko0
	0TraA==
X-ME-Sender: <xms:aNatan9vEyO48Uv1o21ycefis0NXHUGZty045SJMiaWhCtGJj4mUOg>
    <xme:aNatalnrSnsJssMSo2L_-JtnL-FGgjPlZw-_A54HMlrNfzjypFImTsFckRjlECKaM
    QhylXLN26BMJbx58P6p0t4iweiW0af2nSmAoCmK0bgmiTUWNhY34QXN>
X-ME-Received: <xmr:aNataqJcwuM-qSAekEkMf-meqJzH84XsXNhdfiwGclo54-b5ISXtG2g3jgM>
X-ME-Proxy-Cause: dmFkZTFyC+XeKYnZ766rqTYe4SsoatN0doBd7ADemiperjFlmE10ggdkgYpZeWmNOU4aBc
    lm02WEvCO2QGG+A0SGXMzCjVWjDSVCQ5WJ/xmSMbLZJLqVjt5aEnrGd0hUbHPJ/ejcqjFa
    xrmYY/YNxh9EpvRrTjNMqslNp6oZ1XKAjj0b9YUD/U+Umt4HJhNRFStrIx7jR3Gf+CAD8k
    /TwEvtSve0+WgA7utVqBt9LeXDUSIUkf7dn/1M9JWIyORT8Kp2cNKrwYutOzK/Z35sBm5S
    qWNICJAq9yYROUOkEgx1cQSYtjkPP2DMZwKGXS3JxTiE+xMdBmJUepOSBHs3/DvnVTIMpb
    L5ESyndOi5bpaoFBmYeOsEvwEeyOHIUd7LfqffZ1zJn/8T6rxqqLc5X+pIl0tLpk/I/6lI
    /m45Kkjv6LalblttsA9sVVkWfW66qntLgNMH+qJw1GNJLP4FWUOa1W8xhs7TwkJFRw4FTH
    y+wT+BZuEF+uA2L7okyeFi3weDYxSq6LAiBZLt+3uD+C0GGXGaCMA8qHFifjwmTCNGcw6C
    7DP3l6YC/8NPz72pHkfr1IAbIxWRIGx+Uc+g2wFMtzscVj8gpIsVDAdGm8YUYEyZiLpZos
    lrS40yPVOEWU/+6cprb6tzvgBFdWbi8bVY0ROLUzRB+i4cuDKvn1etqkrH7Q
X-ME-Proxy: <xmx:aNatajpmJMTgKZ4CHQYdYFSW6174vGkOGz-c3suU6woNv6bMwpeuxQ>
    <xmx:aNatavQB3wThDRTtrzPkXdqc5Q2iD9UAa1uCykADEgW277_8p1A-bg>
    <xmx:aNatau62lndZQ6Pye9_36gB0DcsEt2Xd44-8uHiDwenJlxls4ZwZ0g>
    <xmx:aNatavYO5RJ3hL8z5bpTKbp31nNjL33a1yEuWgcXE9Q5OwdtNoKdpA>
    <xmx:aNataqzVx9XknLhaLnLsW4CHJiUPSYIEwPyLwBOaOR4rzSRSbT1vBb0J>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 18 Sep 2026 20:25:11 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Usama Arif <usama.arif@linux.dev>,
	"Nico Pache (Red Hat)" <nico.pache@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	kernel-team@meta.com
Subject: [PATCH v6 07/19] selftests/mm: move is_backed_by_folio() into vm_util
Date: Sat, 19 Sep 2026 01:24:37 +0100
Message-ID: <20260919002451.496763-8-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260919002451.496763-1-kirill@shutemov.name>
References: <20260919002451.496763-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2BC7620002
X-Stat-Signature: kgtjztfb8p9saipydmcu1ihbjbnt4rwd
X-Rspam-User: 
X-HE-Tag: 1789777512-570216
X-HE-Meta: U2FsdGVkX19idu0NkPC8bjXZL7skzQuwFawwrITAlKt5rx4ThNy6S78eKE8qowoKLkpHZgIzpUZCdqHOkyagTjTfxqLkosC3jmPHO9xzIlimv0FQV/UGN4T5QyIZg3RgWB1zxlQHl0P9LV1WuyXtggNRLYZyCOtefnwOeIgMawCTxlnfDxMqGX7aFq4CfNYGIN/Y0v8/l4TuvCkgTV5SFxUkC6txraNTI+gpih+AX66FtJXrTzDd2jUOl+c59z5KDHd9TJvmkNfXPjCNGHnuNln9olgslXa6/N+1ahunT6enNx+v40bGu9TW8p+R4h5Oo9TjPe/xQ+bIKx6Ba3sfiUsJPeHvbI+YG5+sZCqGdiy+9co7cb0frG1Vlxa36HCuhAQzlR7r6EdFjycdGstduEsxEO0ffs5OM6+AuJMPkQaOtmZwE9TDcO5uOQN8PZQfaEtcPB451lCwPS/A6Ixp9ITnPbNqfDgL4Xmiv6FcLKtNtFY81dygvA22G3ia52832TXbpHNfLdp409Ju8841COmOUT1Xpe86U6444PnLIOyvTzBTdKr8OivOM+aLzTR+sDdPZmq6dNjdTlbd6qRqngBwRrC68mM179lPTXfYJPkJ3wVdtXwiRBW7D2BIb1cuI5+Z2MNz38zDcjkzKX9nX6Ix2qPR3nfGNoCYLsCRrZTmn98iJP7tfaLMoovfDHDNOE7rP/bZFIUysBDrFXq9vg1UWm+hjPayx2CWTCTaitikhguvbwPTtSCSuUc6s4RXbwF14Prz8kVc1VhandGJqSfWC9PFe82+uWtekJJLyZFHfqGWOjoQMAaWYiSdTuZwEZdYq4ya09MjAsS3ZXUa5Daaq0BabrWZTu70xtObB5zcEqEMqC+1rkQxAiOLD8g1f9UTr2iv0gmDe7x7b9o6on23o4FzbI1nVrzEO/3hoFqVNLCUcsED8UYjv8Y4/t1blax94wMQPbbiQZd3nfI
 +mdFNUPR
 j3ZR/fyJIHhoAX96TVAvO9gVGHhOH/3PxoXvKJpufmdPWVPCZbA188j2rcGfUKM33RIb2Va23MBAGaJNvdMj3TA2kriH0F5W8njCxaiXxieTVu4DBS4lgP38o1MVyUryMUqOw8Bu4Fgcz0zAilsWYf9YhD8new34ARwgpSNRpj0ZH9cxbsjSY03rB2Q4mIlsOyc2uVR2A7jZrnf1Wmzy5ftdExiw6MEPKbHHcNQyHuVtR/XiDm35vSu7LFtJrQTEmKfmX6ZfqPff3BLcd3Ch4V/ObLo+0FsDt97l3zWDC7JVcAjNYQF9lPkiTTmEhQKBU74FSMqLYeygizePn3+e+GWrUeM/XZJ02c6YgitcvX2JoyeOxaebMQgjVPe+TAcRD6b9N1a9kDi8r9bk9bdR2M2PMojd0rcPUlDHbqvWinvxXH1Uc4Nijue6ebgKodrFtMkQRHBi7tUlmd7rW8N6wc8QpPpyYJn0PaFNp6WlMYPWQHE7V1AtlQvvgKFNUizkXYDnoiXHpg0ZGmKF1oxjmmWXnwfEEYCU0cTRYSQEotX1Z9SiUWtf+GtqfEd0Ss9/mfC06saSLVeUxKLs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Checking that an address range is backed by a folio of a given order is
useful to any test that builds or collapses large folios.  mTHP collapse
coverage in the khugepaged selftest needs exactly that.

split_huge_page_test.c already has the building block:
is_backed_by_folio() reads the compound head and tail flags from
/proc/kpageflags to classify the folio behind a page.

Move it into vm_util so other tests can use it.  No functional change.

Assisted-by: LLM
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 .../selftests/mm/split_huge_page_test.c       | 61 -------------------
 tools/testing/selftests/mm/vm_util.c          | 61 +++++++++++++++++++
 tools/testing/selftests/mm/vm_util.h          |  2 +
 3 files changed, 63 insertions(+), 61 deletions(-)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 68f508c9a355..c5d96a4b1db3 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -41,67 +41,6 @@ const char *kpageflags_proc = "/proc/kpageflags";
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
-}
-
 static int check_after_split_folio_orders(char *vaddr_start, size_t len,
 		int pagemap_fd, int kpageflags_fd, int orders[], int nr_orders)
 {
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 4751db798c3a..cc5dfd1e6c94 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -494,6 +494,67 @@ int pageflags_get(unsigned long pfn, int kpageflags_fd, uint64_t *flags)
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
+}
+
 /* If `ioctls' non-NULL, the allowed ioctls will be returned into the var */
 int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
 			      bool miss, bool wp, bool minor, uint64_t *ioctls)
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 64a86e8a0c41..f12979a70135 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -99,6 +99,8 @@ int64_t allocate_transhuge(void *ptr, int pagemap_fd);
 int pageflags_get(unsigned long pfn, int kpageflags_fd, uint64_t *flags);
 int gather_folio_orders(char *vaddr_start, size_t len,
 		int pagemap_fd, int kpageflags_fd, int orders[], int nr_orders);
+bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
+			int kpageflags_fd);
 
 int uffd_register(int uffd, void *addr, uint64_t len,
 		  bool miss, bool wp, bool minor);
-- 
2.54.0


