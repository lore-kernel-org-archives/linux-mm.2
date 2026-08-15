Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC11BC5B572
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 01:59:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CBD16B0753; Fri, 14 Aug 2026 21:59:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37C696B0755; Fri, 14 Aug 2026 21:59:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 293226B0756; Fri, 14 Aug 2026 21:59:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE11F6B0753
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 21:59:23 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 808571402BC
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:59:23 +0000 (UTC)
X-FDA: 85101846606.04.6A726F5
Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9236940005
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:59:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="T 7xz6jD";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=PtseMFA1;
	spf=pass (imf12.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786759161;
	b=k67qU8h7hX/D8pSLlo/RO6tyFK1oGBk8uH2xcYxOXMK/9QYsDEK5JEFxNuZZMpw9ug8SJu
	BFA44G1kQ7U0KMsY71EbEkrJyxTwbJiMZ1xcpaSVRGsVriLhcEk5vWUPJ2OMlIz0dsMH7K
	Yqr9Vkf0Hfo92GxpWDA2ROGvPRs/LPU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="T 7xz6jD";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=PtseMFA1;
	spf=pass (imf12.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786759161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aGZmf/6wBq65F2JoipHZ/CYoHcQpvbh6TEl9rP7Pel0=;
	b=hdC+FpjJC2YiwSGvqJjNesMRi2Uio4uf7zYzcXNeCHgKTnEzjp/kmZpvZO2KWv1DjU+ctB
	MtTBAQ3u4VtGl05rmQ/0AF36dNwzxsx1q34IFl63cnX9LP6m/NuzM4Y3ACIyDBrv0cUBmG
	EJnsZuLPzgs0hILfVSmHEfpp7LLstRM=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 2E01B140011E;
	Fri, 14 Aug 2026 21:59:21 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Fri, 14 Aug 2026 21:59:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786759161; x=
	1786845561; bh=aGZmf/6wBq65F2JoipHZ/CYoHcQpvbh6TEl9rP7Pel0=; b=T
	7xz6jDyNnlB0Ez2Ct771Gn2xfcopt+eC2/a8yF8l9BLM8jbCSo56u++JpCCcuuUR
	AMVPYE8m3uAS3KmUA48P0RyoNRcPHU2nSm/TuwRwKHoBCKvNDXU13OP/v1BTbZK+
	7bXh6+7gqXxJy1MTHuTuRf3MZ/ZkkrapVAdagEd/roTp5F+FDMk0zi9xh0P6DBhF
	rqsryH4uT3V+UGv5g1PtEBrYTyv++Cuf2WKYFH5FED6MrRtYdJKndkeFcmZ0ux5U
	EayLhRAKws6A7wdQ6i4eMXh9w56rMhm90mBB25M1tv6eWSm06iWfalRnqVu0YUFn
	E8TibUC4l1xJeta2irQcg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786759161; x=1786845561; bh=a
	GZmf/6wBq65F2JoipHZ/CYoHcQpvbh6TEl9rP7Pel0=; b=PtseMFA1D5viN17wS
	Nev87fgjogNlQEXUuCElSDKtZmfmV9cdgpc0pPbfJPhx5Paz4vTB6rJiSDrcj4nd
	MpNLbTN1v5yxSof5BlrtlIhhiHrTjytHFOTTvos3iWt13p0NJFgGrVyig8FnEjBd
	QupT7J4gax0ZQfoDEld8+/RqLiZUObcsaLwH9043Ge+x1SRSaIqoWfzvlddyzEyJ
	uA/WBqw0srslWUNzhXFAWvBHjv/Yqlw+kcE1+EiZO2q5IUadXDvxotQovGYKm8yn
	E3XFn3jV0xavgrmyiXR3feQ9KxUSJvjMe8QMyTjceAoPYFBuSiMS3/jy+GlvrNnv
	MFgTA==
X-ME-Sender: <xms:-Md_asGYPOSGmr-FWwuIwgdRTEa26mnBjW_AuswLtKxmouSRMFv2AA>
    <xme:-Md_apS3IJ2pf2jX7tmxDUzo4IKMRs-K2acu7fKv3nWzYcOJPsI6Sb7SbS2_BhL6X
    5YU7kppPRJ8SQ7wcaO9XhLJPqf1ikTCm2h1_GIl53kDAfTRgJ4953w>
X-ME-Received: <xmr:-Md_auphCin7_ONAWlmLbWKpDKOiNHgaE7x52dtgRqac6JePbT_xo_Kh8H8>
X-ME-Proxy-Cause: dmFkZTEYpEQiBdLKlCaLp317TOYqYwO99jnuX4YrBujo3RuW+IIGXdYj4qE1ezcGRvbtOZ
    hc7RfnfkdlTehb5Dkvk4VZTcyRAqm2CcEjaldkIQshIttrB2HSeWyAKQfsR+ykmymFv8qO
    aC/+wh3joJiQccaWn5NjVrqLVVMYdoVO37A5ZL6SnR75seJlCquk1NTOiA0EvXHIVSJ25Q
    iFONSccd/wEzNfQZlOvvQQf5bCKiGIALXd0Rd37Vcnrh56q8DfWwmvEu2ZgBGSMa525iaP
    HkMF5MKO3LDiNiHXJVHjo5f/L4XJttiAOfdXhljkaHgZI649okv5M81/eeF8HfhCZr1Ug5
    fH812civBTQ4/FE9yW9xtOi8Y0F9yKDrp1R20YTK463G/7P8yKRYnTTXddn5qzFWbXndys
    aiCpPcx5TNMkbM0QbjoCI2x1ABR670ocmpPmFHiQMaquLHhMxNhgE5Llu5/gibaYC1zkm9
    Ar2yt7xVrGUFjmYY0GTfXvXuILsLD2Q4rlHwJiD5kf1kO9y44H7QZ3a6kgmb9kzlEMLv8E
    8gx72OWly2IFG0Ahpn8cYPbn31wFFwmhj+8iYcXwP+ksUUlj7vUgpT7c1PW32uSnUDuyyd
    JLi9C9d343aoTgtRo0HxjLFqQmY6rUFKunIWpzNVxqmpjuM5j+WPCS7xbVxA
X-ME-Proxy: <xmx:-Md_anr99278L8HONDAKTE6G6GFBM1Q-N3clN3UAIBDhft9ofqmv8g>
    <xmx:-Md_ap3bklSZoSXuiR-GHu8j2sFWeRFUCeFZL-Qyvm7BBQwqqVFL0w>
    <xmx:-Md_arih243Q6M299p6_p5U_eI_c1vh7JjbODoTvLi_Ji96aZ7PArA>
    <xmx:-Md_aolRYK-Nt3teqNJhXtTGIsCzPhnfsvcSI3m33dRdf1_W75p-tQ>
    <xmx:-cd_aimnuHbDsU0tH_WgWSkbEJziyUOcgjo2sAX6PhAaqQhK1i7ETTCh>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 14 Aug 2026 21:59:20 -0400 (EDT)
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
Subject: [PATCH v4 07/19] selftests/mm: move is_backed_by_folio() into vm_util
Date: Sat, 15 Aug 2026 02:58:49 +0100
Message-ID: <20260815015901.1236937-8-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260815015901.1236937-1-kirill@shutemov.name>
References: <20260815015901.1236937-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9236940005
X-Rspam-User: 
X-Stat-Signature: i8bnimb8kkm49u9xp4erx1yz9scnri3a
X-Rspamd-Server: rspam06
X-HE-Tag: 1786759161-168926
X-HE-Meta: U2FsdGVkX1+OGYdGawkTlUHdeAgbMIx48iEOudiyHDO1IZ7GtY0tjJRqxKMBYBYR1W1Lv1zW/523RoIZRw5x6Tg4L1OLJPo3A7xvK/m+JCwyHY/TU0QDRUQIfzjyD3CGePffa1AU3EI7smnmNrLoptwNWYIgiIqdzkOnHGuLqdUnBqEb6ZZ98EUJolwnhCQ0jJoNcxDMnjb5SGgdPv9gqrwOxOGPvZwASXToWQxoZzX7TlZXZZv08xMatZbePtiYHh0e5Gi2ke0UKQ5XeBH+9/CBLpyi6BLxBleHgfem5pX1vlfntmJwFyJgv9ytke83nJzoSuoOAJ1PbTmgDCAaWi85251SRHXGP8BEUIADpe4vJ8WzGh5YxR9gB44+UivNOzA+SeN75K2daJ79SHpukP3WN6kW/jDsWymQ4zD/XwWjq3xZ9pgpNSLyUvhfbn9xREaAVDURoAAOuDbIJqcbePjheglUGkkhZu4HL5mlegsgoZ6gNCndj65USvqOqXAy8Wyr/fPeXWhpkCCdc0DIbmruQyFQynTZYMhXBwtdxnoItpYqUk1DQFxrUgOdTmqOBwB5sCJAT5xwxLUhb6894kuLq3SSbO+Fi12IC17bqx2KQyeRHL0S+k18kHbXIeFBmY0h9xTsXxpLgkDB13QKOEIgvdUYhgBSmtCdjU8HthqpIvyvnzaoEMkC14QtZuCHMCEcBHjvMOwNHMDan5BBWG93+6OAq4OiJ06ghqTkKWELIs/Af+ohmGYn604OzegYmGCVHW8cPNxJPu2BLqT83esXr8TvJUnihBiRlH3GT0RXMTporzwWZivgAhpDTm67OIJOVibSFnkiMO7rQZjzQeCtTGOnllsxGE/V2qDFSJxUsZfSCb5akE31gc0SOrRWeBtxKDI0sAAKgR3lM3r+CXl1rpCPLqwIXOT/jwlmI5E/pLqCAIcdGAoiOLJfJB8DrztZnrIKVvXhXRQ0jVb
 n2Upuhy0
 v2RBgjbvk/5JDlwsG60nZECHF9IriMMc03LEiy5Mdxzo/hwlUk52oX6YyDZ5r/eRusFLqmN9Q7iTEJf6oqD7oyss5/cJyIGMk4S4s3p0QTor7ARJhGgWFyzZHbTbu13q3DWu+SAY/538FRVWHrQZdcDtDaubMQf+F91h+S5V0Spaold4Qd7yfYiv+l1aTu4pmqOrBU6zxHbnsepunw5R02Ob9Y9jMBB4AWhAS45H5LunSAW5DaRSH8spWtLuoN9VjFnySDofCJxYZdhnnywWPyRuaeHqPlAT2CPRfjCvx5bPkoR9bAII6bvfPGV2r+YBbC28D69+tM3BGiRy6isjiZzwCpsfFH3+mk84H4tLfp3Lx4vrM7D6oY5OmEbWz+4RBsE29vuEiR4lTzIaMaIRw6VLkKaGB4Qr+viLYeLkr0sDRyVEGHrg4imsNtsykTYrQDYrNcQ7FsDJNMdNghMIr6z0CwjhM6+1i4aiSwiRwN7yqLs6OenQEaggZMIbxkJPSn67htlSAPOWBHA2kuP8MX7Zas301Fbk9jtsrTOXupryqNqmfLJz92qwI7g==
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

Assisted-by: Claude-Code:claude-opus-5
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
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
index 80bc9f597b52..5db1a7774f49 100644
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


