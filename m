Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28C31C5B572
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 01:59:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04F5C6B0755; Fri, 14 Aug 2026 21:59:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3C546B0757; Fri, 14 Aug 2026 21:59:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E51E86B0758; Fri, 14 Aug 2026 21:59:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B29916B0755
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 21:59:25 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 42FDDA2916
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:59:25 +0000 (UTC)
X-FDA: 85101846690.23.83CCCFC
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	by imf21.hostedemail.com (Postfix) with ESMTP id 66D331C0002
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:59:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="s 5oC2QI";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=a2z10bm5;
	spf=pass (imf21.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786759163;
	b=IQ4IfVIxmvIBO6qdJslpMq2Bv1zS5Zp4n+JiURbUbaFPde2Ya/GTuwPwogx3m+qTg0GAXo
	ICmygr+nrdtnVZ40nqtC5p9DBzUjg6X+VIt7yiV1njFOqHdUQO66QMDw+nMQt3hGmYEsYS
	tSWUtj19/M78ozT8t3b1n8XUT9q7YH0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="s 5oC2QI";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=a2z10bm5;
	spf=pass (imf21.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786759163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3BluNDLCZhWfJh2T22U9KUR4xuqo32ndiTxV1AaNaIU=;
	b=5KQqm+tpnRp+1cur2NItUI1l5v0m7dgOayeYGSdEDTAC/6gaMZ0Lp29kCSi14ThgEeqflS
	hj9+mlitpD4PS+hHne50yVThlp0TetwdA5JBLYlYCJkNxC/35W2SPUIRpYzJaqWhPZyglE
	xCpyuklMHwCM8gR2312sfxvYitlgcEQ=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 01CF1EC022E;
	Fri, 14 Aug 2026 21:59:23 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 14 Aug 2026 21:59:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786759162; x=
	1786845562; bh=3BluNDLCZhWfJh2T22U9KUR4xuqo32ndiTxV1AaNaIU=; b=s
	5oC2QIzgW1HHEplcurKvHDjlWHAlUd6YZD2TjDoHobEFka0+vVyYjFAf2VBePPcE
	LXsOxgFGJ421hTgcFCISjyzgJYU4VMKG6C0PGWeizZj3bpJ+nAcTVXqQljRZbr7i
	aJDsgLUMkIFVnnjgneyfUbGAbDBBpGwjmU1xiwLLbf1JOQUMIklLQT5vbHwXOyzn
	IK3cWHI0tJC9EYagt0INL1epWpclZCY2z6LccMWY7OPxicvB1DyurqqphVGxHRex
	wUKaFAghicwjbymzSL1TFUylF4bvLQKgJ8d6tf8O8cE2sSwIJho8rD/B/nO3/Ohi
	BcpArZpYAuzpcZz9l7K1w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786759162; x=1786845562; bh=3
	BluNDLCZhWfJh2T22U9KUR4xuqo32ndiTxV1AaNaIU=; b=a2z10bm5YOWcOXb4s
	dd61rq5lq1mP35OFj/TUe9CmxkmYsLqbcisjbnmVImeks10TRr1zsnsZTBWZW38b
	5TjSOKsczJCkvFp2aCzl3kUoSe0acFihBbTYXDT1GM1yTT4gDjX5KzvqnoaUX+yN
	xOI7ZGYEz37iwaUvGWWTVcgUDsK+zbAOXijNsdxV/Q7WJduUexodyyHSnaYVof02
	cLPdEFoX4MRw3ZUVDWUd5IJawdQu4yQ02CI7dyrBorbXqDo/B7mDoeP3KPrlnUyO
	SZi13+PWti/tNL05Jfncqth0pJ8ikpXUZc/dsrwOL8MYmvrt6lt1gvzz7VrWXDL+
	XY1PA==
X-ME-Sender: <xms:-sd_al9pzt9u2WDn3sUpwYOZscvTDS_GRyEMVOR5IukDa9_je_X6tA>
    <xme:-sd_atp-TBH0rgdQ-nxcbJdFlLY7jKejmvRujiKaGBKFVqJH85i0ToyEDy5n7US2r
    GNz1HFHjx1OunRucDirf7ONncZuZAbW-ezuDHrDwHrvXVWJMsp77Q>
X-ME-Received: <xmr:-sd_argeP12mBsLerqgVpVtyP42ZmX9Rg0IS7ap9sTN1xVWP95TwG4ZuGBg>
X-ME-Proxy-Cause: dmFkZTEYpEQiBdLKlCaLp317TOYqYwO99jnuX4YrBujo3RuW+IIGXdYj4qE1ezcGRvbtOZ
    hc7RfnfkdlTehb5Dkvk4VZTcyRAqm2CcEjaldkIQshIttrB2HSeWyAKQfsR+ykmymFv8qO
    aC/+wh3joJiQccaWn5NjVrqLVVMYdoVO37A5ZL6SnR75seJlCquk1NTOiA0EvXHIVSJ25Q
    iFONSccd/wEzNfQZlOvvQQf5bCKiGIALXd0Rd37Vcnrh56q8DfWwmvEu2ZgBGSMa525iaP
    HkMF5MKO3LDiNiHXJVHjo5f/L4XJttiAOfdXhljkaHgZI649okv5M81/eeF8HfhCZr1UAm
    rgJ76CjNAg/U/EKabJ+37G6BvMM6OBu2S56U3YWsJffoiZIE7o7yRmzI1OaELgILaiNqOo
    1Uq53GRRyG0wmSwHCaXQhUmxPHpjgx3LBvDZvJI2g8hLT3dlzx/tzjmukS8sdOlYlQxFrf
    pF33J8KwidLs+W9kyG792FlRJ9R+6AJij5y8/PXNhargdOkNqPDsBM/c5bDG3fYqAw/ov9
    v6QBN4oqUXjbKiyjShwtcAMIWpXKpukDz46zSH5kDTrXYEI9fAj5YLBZW2zQ19ZOhLXATj
    WaTc5JbID9LNOP/VpoCk3VliNaVr5JQe7/9AwoupdqfOs0kCJnidsvyZ21hA
X-ME-Proxy: <xmx:-sd_ajB19bySXyk7mrqj2Tj4QatB9BwGWFT09NX5TW8RXG0M6J6zNg>
    <xmx:-sd_ahtY1HLopn72acFat2cyo5oU-vIhQUM6b5YoqestzOOsCJ7vyQ>
    <xmx:-sd_al7Xvk1bOj7o23j_6KWwEZ5rHUu37w3XvcgfzOR3-9ChaNyoZA>
    <xmx:-sd_ajdNWe7FHu46nn7j15ZwxQ7tFXknMoWBzhTYb60YLkjGXDzzJw>
    <xmx:-sd_aqctT2RgUxzVDtaH4o0grigTnbpyPCJIeZT0Ugp_9HI_xqhN3lax>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 14 Aug 2026 21:59:22 -0400 (EDT)
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
Subject: [PATCH v4 08/19] selftests/mm: add folio-order check for address ranges
Date: Sat, 15 Aug 2026 02:58:50 +0100
Message-ID: <20260815015901.1236937-9-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260815015901.1236937-1-kirill@shutemov.name>
References: <20260815015901.1236937-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 66D331C0002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: e4473rsscopy4msinsy4tp3x1btha9z1
X-HE-Tag: 1786759163-781938
X-HE-Meta: U2FsdGVkX18mXMrYYvui9KkeVMm32HQmP4yeQvFmsVjKBEwWIJ9h/wSSkdaT/Ac3NdCGzFtRFlbIv4fKPhqOoajY7YoTjh4v1LNMaU2lFAA9BGn1KUcUfoogCiGyntpj2a8Z5BWbzdxFLe7GGFCx2L4ZasDsBpMR+qti2nBEaGCCXyQny3eZIrVq5j7ODs/koD962P+mC0HNpJvtKDIkmfTu4aFgvcUmG+rn2lQpbAn1Pu+HJXjpBTymneYovBcwD0fi5EPe7KxsN7+S9FQKyF+0PgCmN22CeZfcTa23pfds9gYUiUjfIo5YtvzUPDWgfl2JJbrWHiV/jwOupcu87pC55d7vJ7ypLo11wvrMuRvMHkxX2AnoJ6kaFXntrRMtSKroPYvLPQIivcdsr+eiRxP1TyR5K7ZR2rvmAh6HzJy+AtV6kwZsIJYDXQuKHC355MLQluElkNrMryzxo9aBligKmapWAyCePJCzerSzIV1mrVMtaVKj+a2pwZxmlJy+cRnBpHEf0F4PzASa9U5CkOlcO3Nlk1HUvKBCIs1NaS1pH3HLpsBJp0QVrQhKby4WwgAL1SZ5cVhirvkm2V3wJIH76TMNzwV7gV/FBRjgiNPkzvkh4LPeOaUE48usT/h1aCVcX0kmIZNpmpg9hUr+AtXlO9w+CC1ggc/gr6wKf6oCFtVKuJpyvgyM2b1KBIp56w80jswSHANoLTYk6s2Y4iPL9lD3nsM4b6AvjRlqxsYpc/INWSiDS9n1q5RJJ7k5+PmDPSXMV583VyJ0dPyeelBxU2YFS9joK7hy3VKgpvqoIKS0Vw104zcJb4LuIVXW7xNStAQNLHLlGOO6NQXbVYo7xrbSXfdOkanTC9Saa9usrcGASyrWaeo7/AKLopEdE5HrBfR2IrCcxV47r9Rf/1l2PiPKiEOnSCDL3hYTSEUDsrXr3z8oY2Y1ZG+y3uo0zvgbnDIw1pkkiozTIC3
 LwUDW1j4
 KMxcMDHNp0SgdhphmY8U5dA0aR1DmSEFksBkYWNUqWsDchS+LQDg74nrpskUe06rxbj/R2FfsTNl4HIVF/bcjRLNGceUJDxDwVeegzl78GcrdvVQK8+Fk40wupOWDSn726WJhcZcSrS6gDXG86gD/OgbD4Srxmbh0Ah/0Zp5DXybD6PbqAZ62armKXhFXWM8fvEiPJ/lXzncJusGQ0jHlre5/veLMPl48ruqRUlVq/Z0A3wDMvfdcpX9QoGMGErrw5IuDyA6oSk5BeEM8T54KdDIEmz1jSojTcbENh1bK/J8gv7x4McB/jsXvuHjzNAdQJH5H4/OH91uV4Yo2tI/er8ykvZ2/XIO4R+J5RH2nAVGAECWrsFskpAly9xv/XF6fp54VlZXo+aa2hfz1Z0+ya2iFOvO20Xmk6rv58U5zLFajEfXxGtOFyk08IYbEcIcHYTv8yz8dYMKV5Wjft/5L+UNy2MBLEJdp3SsyrwelLIuXqea7PWOMJ442seB3vdyBq6Lc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

An mTHP collapse test needs to know that a range is backed by folios of the
target order, and that they sit where a collapse would put them.  Nothing
answers that today: is_backed_by_folio() classifies the folio behind a
single page, and check_huge_anon() reads smaps AnonHugePages, which only
accounts PMD mappings.

Add is_range_backed_by_folio_orders().  For every order-aligned window of
the range it requires a present head PFN at its natural alignment and a
contiguous PFN run across the window.

A window backed by two smaller folios fails the contiguity check, and a
folio mapped off the window's alignment fails the head check.  The mTHP
cases need both to tell a collapsed window from the one beside it.

Assisted-by: Claude-Code:claude-opus-5
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/vm_util.c | 42 ++++++++++++++++++++++++++++
 tools/testing/selftests/mm/vm_util.h |  2 ++
 2 files changed, 44 insertions(+)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 5db1a7774f49..c9bd6c92fa41 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -556,6 +556,48 @@ bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
 	return false;
 }
 
+/*
+ * Check whether every order-@order window of [start, len) maps exactly one
+ * folio of that order, head to tail.  The address range must be naturally
+ * aligned, each window's PFN run must be contiguous, and a window's first
+ * PFN must be the folio head.
+ *
+ * This is the check "did this range collapse into order-@order folios": a
+ * window assembled from parts of several folios, or mapping a folio shifted
+ * from its natural position, fails.
+ */
+bool is_range_backed_by_folio_orders(char *start, size_t len, int order,
+				     int pagemap_fd, int kpageflags_fd)
+{
+	const unsigned long nr_pages = 1UL << order;
+	const size_t window = nr_pages * psize();
+	char *vaddr;
+
+	if ((uintptr_t)start % window || len % window)
+		return false;
+
+	for (vaddr = start; vaddr < start + len; vaddr += window) {
+		unsigned long pfn = pagemap_get_pfn(pagemap_fd, vaddr);
+		unsigned long i;
+
+		/* Not present, or not mapping the folio head. */
+		if (pfn == -1UL || pfn % nr_pages)
+			return false;
+
+		for (i = 1; i < nr_pages; i++) {
+			if (pagemap_get_pfn(pagemap_fd, vaddr + i * psize()) !=
+			    pfn + i)
+				return false;
+		}
+
+		if (!is_backed_by_folio(vaddr, order, pagemap_fd,
+					kpageflags_fd))
+			return false;
+	}
+
+	return true;
+}
+
 /* If `ioctls' non-NULL, the allowed ioctls will be returned into the var */
 int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
 			      bool miss, bool wp, bool minor, uint64_t *ioctls)
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 56a28ce7d029..39dfb18dc10c 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -99,6 +99,8 @@ int gather_folio_orders(char *vaddr_start, size_t len,
 		int pagemap_fd, int kpageflags_fd, int orders[], int nr_orders);
 bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
 			int kpageflags_fd);
+bool is_range_backed_by_folio_orders(char *start, size_t len, int order,
+				     int pagemap_fd, int kpageflags_fd);
 
 int uffd_register(int uffd, void *addr, uint64_t len,
 		  bool miss, bool wp, bool minor);
-- 
2.54.0


