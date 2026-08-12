Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF8C1C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:23:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE2A66B0103; Wed, 12 Aug 2026 09:23:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB9706B0104; Wed, 12 Aug 2026 09:23:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD0506B0105; Wed, 12 Aug 2026 09:23:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A85A56B0103
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:23:30 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4BE54A287D
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:23:30 +0000 (UTC)
X-FDA: 85092684180.10.4B6BF49
Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4F68710000E
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:23:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="Q XUbyLn";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=KPaN37AQ;
	spf=pass (imf05.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786541008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7/1Od9SJ6IhS+FCj32O5qawyk1eH8bdwgb4C18ahL3g=;
	b=KyXLNApm48F8+z+lWLh2mnFiDuf4R3TVT3zekjPqus4JjS+s2OTk3eSzim5HPBV8WEwRHI
	zzLyOIyPIeFRBBND0x9ihH+ItGW/tRAvIf91K74AQq1BKOfguRfpivJ8wA8/waStjlR4we
	0mysR0xSaANXtWscG/sFwQysG54O7ZU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786541008;
	b=3fDdUJNb5YKwl3fy31g/MCE0wqQ+PGMKp7nQs5AaUuJQ7mxI+s8XZgGm4mFcEGY3ohWFQW
	XcOGgJrhDTK/tgdm2/RfBbG5SXPDfa0jN6wpMTDALnmCFPaLLU+8bExhzCVZEjiPUqpPqk
	pyqFbLn0VWRL/d8ajzAQ6ZD/rkpGE6Q=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="Q XUbyLn";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=KPaN37AQ;
	spf=pass (imf05.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 2D21E7A00D8;
	Wed, 12 Aug 2026 09:23:27 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Wed, 12 Aug 2026 09:23:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786541007; x=
	1786627407; bh=7/1Od9SJ6IhS+FCj32O5qawyk1eH8bdwgb4C18ahL3g=; b=Q
	XUbyLnygX6Hg80MGiM5NtW/Et2v4mgvuNkaN/mXkvIweCC6AMxMMBp4XytNuAXaB
	AqH2R9pIBMg6QfNb/IiphyivuSXTeMRjdrILMEEaQZVYuIom5xT9quL+p6k4eJZD
	YFoiUeTMdijymZ5tiOTn6DaqNEkdPVD9V2Cf/Bu4e4KWmDN9ez25+9lHkr7smv+G
	NAeIN5qrS43z1vKzPgxNUlsXI5/T26Uq2eT7nIzVO1EUb1hQE7Hh5ddN7S7k3jDL
	iNulunUp4VOe9Ha07eDG4eIfoIIopEBWxv/aCTwnIAKgxARe+zzMMm6hV1ZEw+1G
	G0MErmvqgPDPP38qJQkFw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786541007; x=1786627407; bh=7
	/1Od9SJ6IhS+FCj32O5qawyk1eH8bdwgb4C18ahL3g=; b=KPaN37AQb6Ihsr5EM
	bzfrZySkcG0An+V8801fZGNmWzjnrYcWn8iabQL/U/1tFZdjX6pwuv41yRZWloVP
	WG6INcHEWRF0QZjwpuRrohdIgy+E1yJ1nA0SACltYpI6ThddOcQAKq/0QQctv9s+
	UXAOjycmwB37tcVa+JpC9VMcjd+zuhYwU7u/mytgV3lKWRuAeO7khEEIR0xP5Z3W
	1a1Sf8pecn7bYh7yJSDQDHv5Boagq9i6hs3eW1tn/dqoY18XhK1UyNUAy49HZvRW
	f5a8vVUpcagvoU7uZqVMC00SEfVH4KzzvK65JpIwykEU3fIncuef5DRxpF4mA/xy
	PPDCA==
X-ME-Sender: <xms:znN8amXRwEBfKUAn7PMA8cv55W_D6v-UNbJ2E6EFYCnpQEBn0kY95g>
    <xme:znN8auclE7Z7kOoMQlJBITrqNzt9-aHGJKgAyOwBXAoHZKfA0JE8qCncfhhVwLrqQ
    gg4A9eMc6FVc5rZJ4yGI5t0Mq612uHdmBS07OLGzQLbZG900CjN8BFq>
X-ME-Received: <xmr:znN8ajO-BG8RMqYH-W28s1bQIHtM4XioKur7wQl-bSW0FJp6noBokSJXm_U>
X-ME-Proxy-Cause: dmFkZTEqChZjxU8lqj02ht3p8wYuzmrYEvg5d87zO8AQZiDFbK4iKtuSdYsxN+c2ZoTQsd
    zQCY87aTj+m9TAVwdwmdnHKtWVRXEr5fYrOyK1UHI3A+jsshF0fdPBAQVaID4Wjh7c0VEi
    dMMoETa/m0t33XZQU/UKXL4JlwUkkgq4rn6LMFa3pgr2l0Q8gT02Cw2LTLC9qVW3zH4Meh
    qM5Q9QulYPPXeKlcMtfCTbhFhqEmjDBhZKmzHTdwgvJ4UJe4phkHLyfIFsN1xpYIRuVU2w
    753LB2HCYBO3y/gIk+V2c2W66P34Qvl7+NN+EKfE2PSluCBz1GoS4+OMA2hGu38Uv91MGe
    4sTC5n92K1OBThe1XxwGhr1GgpYY+WoIkK4tbDPzVa+TSQLKZWYQ/zq5apU+YI+o3tVECK
    P+PdOrfvJf3ku5k0iSYdGKAgoT4PHJG1I6KcwVNl2YHf0vo513CyZEEe0x+JfEndboES2a
    9udf7lXx7WK+fRrtAl3v2jY+cP3lSrTFT68GhvpMYPTHYRgt+TTydDiZL6Y8S7oXvastST
    Z1Yt6tB4jTmzKMQ9DjoHIquzS15QUsewYVi/NQgWUjfAZe92uTmiDHYNszwvxNeu/uUbeH
    Ivg6hBCV9ysXNP206u2eN2kMLiEqfSltcj4+UB7B5xMbfeDtHdW3nlbvWbOg
X-ME-Proxy: <xmx:znN8amIgs-eq_Ej0lJcXPYKbOOBCXJcAERJNr3vWmEXX4NWIH1NsQw>
    <xmx:znN8apnn_WsmEpBf8hPQ2Lz4FIBzL6uVzWai0OAy1TqcoBpk3ddrRw>
    <xmx:znN8alY4LJhHNa_UQQCaAD1TXsSdm5KO2XyhzvXh4r5QcnjRTkz9Ug>
    <xmx:znN8aohvW2F9GuoqCa0-QxMYdXBT3sIhx0wD1AHTV2nFwc9SGk_ogw>
    <xmx:z3N8aveq971dOhAM_UVsOg8lIzWWaScVHA4349O07bM1gAvlCnDNEyg0>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 12 Aug 2026 09:23:26 -0400 (EDT)
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
Subject: [PATCH v3 07/18] selftests/mm: add folio-order check for address ranges
Date: Wed, 12 Aug 2026 14:22:53 +0100
Message-ID: <20260812132304.199287-8-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260812132304.199287-1-kirill@shutemov.name>
References: <20260812132304.199287-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 4yd4axs1ezextgfxqfmzysz3tamqzhn1
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4F68710000E
X-HE-Tag: 1786541008-726017
X-HE-Meta: U2FsdGVkX1/DCnCigyVMskRCveeDdoJo1W3EGaPLceTV7PhLBSvFmts+qfvUGR/AsVbv9U0ZUsjGHzWMOca/PXoxrCXm6FrP+Q8zPbwCKhOJcnzkiMo/So6OwVFJsQq6aMFekjcpRUG8OGsQv9GzfYud6Lg7rwL6o4p7CnxgKVi7+DmYJbXxEn5MW0idxMq3xlpgaouL2BO0cEJf2lWxL31ot+SVVRVobDkbpM7R+XFhdJaD1/dNGniJ1C6xFXwQAlA0JVcW81TKRfCYSEan4WAcs/xJrw+8fcFp4E+YVtnkdKlIvDyEKAwSXZoyMZCYliFBc2NoMtZEbcyousqA+mC4D4joYrDGv8Zd5bvWomAwV4kEJU6ZmIUb5naXICN1kSyY9H2tcD/WQku6qyZl4nr8ge1G6Er04lZsXrdIVNNFNfA2JhlhBE0psWv+YkEGHinT1Wrya8824oPnepCB5nxaIMOLtUbt2WyvU9Z0RjfcslxP1DF/B7gd58k51JEQuunBC4Kp6etqKanM91SoqARlkRKBIVXvUAx5o2qbsgTnP91mHSg2rk2UDSlPRK6p5s5KRvUqrPZIdPonx8AuMJidAXWF5utejXCyT3s8wFp6cBya6lSpcukH2MIUZuRDfRwYOTUXSUD8BVvr17w+yAMydRVgioNFul0h95xeMbzg/6cX/S8c3sHF98l/gOrMi1/F2L9yrOhdH0Bapgiec43UxEHLFM01hzvExe2tCCWwfp3WHbjAvPl43pyvqCa7jzQHmv1NF/GSs89G4Vn5stCt6juy6r2RH5l1ihpor2DdPPP8cOrNLEhcDa+QcgvWjsnID9McDXhtdTq563LDo6EF/SmyAmMYZQK3H8X1TnyykTQeUdMYJvP4XGZBIMrRcDHWUHuZU2/lY6pKqT9e3WDYCK5fFP0w9gLHCGooWj2eRA2kjq+j293WKYVWlw4wqqWb3VCSwVVyDfV6lNg
 MZJ3n5CX
 ihavt00uc3VIOtbsc89pPvJRKIuuXol1yBUy43mgjWtBCPx2AGelv4FEHx4+Ol8qvjCjKVc2jT//2BGnM9bF/Wve74m9/ymjNszJbUVcwH13fuaLSniDKqaHoUvfL5YWUxYnpdelX9qmADGENcEYK+50UhDVAPpj7PXc3cBq4qxrXMGv3qhKv0m9wfxGROSZtR1HNhOcPfTBTR9iG91k8yH/6T1DDEsoqKkjEZcLR6zzHkAvEmtvsrt2orj+p7rlehz/0oGfioElzq3J8PFfLLBLYVlaSKcMZBjCHUDgOUOZGyVmgz/c4HhQqXCmGQmk974wOYQcvnwy4OV99W2Sp6Jz88cJApI0vVqy5YNg8m+FOfi2gV/vV9xpW4T8Z7YtFj+OVNyziKiiwr+0vyt6oKBgaYa1iBSR0ZcFkjjKy+zrl/RTh2PWmIm2G+RUp9V4VFvgoZQ8Y32z1S9vzGWZ61TmKQV0K3EYgF71cWJLgxCGdDxA5qvufaAQHs6erlFabGFbF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

An mTHP collapse test has to ask whether a range came out as folios of one
particular order, placed where a collapse would place them.  Nothing
answers that today: is_backed_by_folio() classifies the folio behind a
single page, and check_huge_anon() reads smaps AnonHugePages, which only
accounts PMD mappings.

Add is_range_backed_by_folio_orders().  For every order-aligned window of
the range it requires a present head PFN at its natural alignment and a
contiguous PFN run across the window.  A window stitched together from
several folios, or one holding a folio shifted off its natural position,
fails -- which is what makes the helper usable for "this window collapsed
and that one did not".

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


