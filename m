Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA469CA601D
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 15:32:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E59D86B0095; Fri,  9 Oct 2026 11:32:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0A7C6B0096; Fri,  9 Oct 2026 11:32:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD29C6B0098; Fri,  9 Oct 2026 11:32:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AA2B36B0095
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:32:22 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 362DF120449
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 15:32:22 +0000 (UTC)
X-FDA: 85303479324.05.8E39C63
Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	by imf09.hostedemail.com (Postfix) with ESMTP id E386B140010
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 15:32:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="q yFb2HC";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=arIWwP2C;
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791559939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cn3XXFhc6e6bkomv46Z/zGM80flPNc5i5pMDr8LwJxw=;
	b=7cI+O4/iKvw5wIw2PRDWlu9RId9bFAunvwYTQab4s0I6KAKUl8PVjMwdGaZh/8lEB+jccr
	SCNI1YBIL+1EomyW7sLUDn9i126Mh/KFno2Q5p43zXPHMCtIui1PaVKEUTX33sihXxW+Pj
	UxAnBnkhRsL6Y/gjGFA65VEVQbJAjMg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791559940;
	b=RGuVZLYkLBZuJr2BPm4YuyEn+NkKgTQdLUBuN2FOOQg7s+YJxH+zFS/sbu6iHrKeADmhRe
	jRxr0xkFSJyK68ofx7QaMciMosVqo9azi67fu4yrBSKZq8JiJeS6RyZPUVGfIJkKyEUa2W
	l4suC/OiZv5h9dMAi6tKYOXtpRcqZFU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="q yFb2HC";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=arIWwP2C;
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 73331EC09F0
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:32:19 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Fri, 09 Oct 2026 11:32:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1791559939; x=
	1791646339; bh=Cn3XXFhc6e6bkomv46Z/zGM80flPNc5i5pMDr8LwJxw=; b=q
	yFb2HCjnAXQelO/oGqxnNE22TWroXPk49cN+/yz3/DeHGyRmSCBftqa7/K6D162c
	efYKbVImmLRe6Vx1EdVxY6WRcrmMbgKUtc8B/Ik2Ec4SSnx0ZQwX7XnXmEO6KlnU
	TPoeSbMdFgwSOoTta2nvOVJQpGX5NRjLtZvf0+kfxPgjer8bHqtiJRrW6NPet5ck
	31T64toaIRy3guMRZOqo97pDHD3QLSN2W0zniMKx8v4tTojKH1teVliYwXBNhBhT
	7JzyO7jRylxSgJsG/lHcN0++a5QLYbtxS0vk/3PaFIYhd1vF/sI9AHUVmtbCXmjl
	Vlnyjs4xn1/TX4EncN+6Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1791559939; x=1791646339; bh=C
	n3XXFhc6e6bkomv46Z/zGM80flPNc5i5pMDr8LwJxw=; b=arIWwP2CxGLwH6P/g
	5HX28Fz04DZeRipw+YhubyZKvjRA79sO7GVHjqF3Mxpkztc/GzHI8GJcEN0pYejI
	glsZ1T5idM8ABxROmFhq6aXFNfNuXgUYlV1L5RM/69qW9tER/aR6Ai3rtaY2GeaH
	2IuVgVwN0OOGUXaPAnzBonso5nUN8e9uegLhV5vqo+Nsy03KkK6JrPoNbW/d0QMr
	jiZQGzroyzFtvq4pVBzVhjrYfAP66K1sHOShIcYhoy3eSrms4IlIMtV/X6MJx4Fj
	rz+w0mcliZHH9hTwwezuOEwUnSGp+oNMa6+sulpTyz0ShEjd/X2h8b6BI+FPNXyN
	jTa6w==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1791559939; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm3:rsa-sha256:Z8DpM7zaUbItUqp34mHqL01SDZttCzabcJAoZ7yoQLW+qA6
	oCBkgyfs1aHi7s0Gkx52i8JoJ7j66/PUca0uYq0Oa420CI1+HLL2cTDSKGdKt4oO
	M28QDrsJC7Dk6nGcZSkYo3uoXw3cno9pMRF+kisaR9JfGDn/frIRJ/t3BemQoHVY
	aDtOgKrBYlq+EIM3LuDMGP7FaoyW4b6N9ms32WBSAq6hFMeZjBlytr4tHAmcnw5a
	CuQ0UXqehISdP5ZfpdSwWnefZj1BaviZ7y4m8e1v8wHg8NsQUgZDPOHU6dH0cVqu
	WhOX2QXbttM5b4n+Th/ZR4PMTHQYY7Ic8DGTLTg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:mk2CckYtfpRXfCPmFEc0d+B1b3ndA3l7PpMT9XahU9M=:Ws3RmIUfEAqHSqXsPdaDPy7aKV/9/KiXyk2W6GocU7M=;
X-ME-Sender: <xms:AwnJat0XQpjVHf7ouwuqLPmkST9q8gFalhlRW-FqS-sDhrF2pNadKA>
    <xme:AwnJanmcEkLyr6qFCQ75sDfaqndVEalFfWKPZH0DT7HvdsiCfRlMxY6cAXEWE1kJN
    f9IMYLvUG3kRZ9C5tgRIpnhRziPw4KaaslV4851xG8tunY_n2MTeO96>
X-ME-Received: <xmr:AwnJamb8Hs7MWNfX1Akp2OzF7QXDKEQbaKncf0eCqW1zYoRFG3G3Gy4rj78>
X-ME-Proxy-Cause: dmFkZTGIoGBLZMaAhgcaayk5wgp7rW9vayQkfonvs0TKGSEuuYzL1U5eWR8oX+vcbxv0ak
    vZ6V5Fk2n6N+IaumklX1qzBk7r0hEpcbcO59DsZzPQwz0SNLq5ubZVbwk/A0B0ImP1q9S/
    wvMCjtg/pGCexbzTYCAAsFMX+sI9bOrGKjIjV+CjlMDzV5ttTW2+3V5NxcPyUYh3hDVmY6
    5SaA7LVa7G47KypkYvo+NaxjJdB6S0C6Hb2KUpv2JaxJ1DNuAn/rjb2TmQMM/Oo0fomkKJ
    59473bNh2ppMgxEJkQDpXpn3GMfvTNgjovDF8A3Cgd0ETDAPdqWfdTSt6z83qaSG77WHU7
    ffUaamUPGS1b+7K+3QNQF+FTd9zCjHX64SKWGRQL/oVZG6mUrtPNt4VWOGgJ1TYv05fRdy
    3eqf5x4OrWsVhPaitdRbeifihZjArRlDw6yB4Tq80GLUtp5AD8OOpLqzdyF3CFXRwKt9dA
    2U8fro9vwPSVAP1hGvhHIRUDGgOCoxTh4ruWw7K1N4EdAvS+neuj5Q4+yxMuZ7aYdmGCPy
    s/gdBugVlSp+Sqb6YFN84EWVrU1X7+bviOvI3O+QE3yWk23k1iV8sRnHcdsyheCgIyjE32
    9KOnziinkYBgPADR0T9PJTiVIMYzXRi+wNRLoipze5oakUZbuNzMriHZWyQQ
X-ME-Proxy: <xmx:AwnJatq394ky-IG4GFVHsQt8bIW5haXhyHJSdd3ZdWoL7LW6GTYsHw>
    <xmx:AwnJakgX8Ni9oR5n90YVFEYovSInqt4kV-h9jnQdayBRtq7VOI19Xg>
    <xmx:AwnJanyqsFFFGwxCBpxM0IF16aXZSBeG3DJgh6IQpmXvCMVJ9FUsDA>
    <xmx:AwnJaq_OVkAlry0h3OaNY9_ih7HT6AzuEyps3C3gFF7DKZtcGTvwvg>
    <xmx:AwnJaofTLwOTWc4nimwJA-8uW_lRzloXODVuMYfs2niNCXPKYcpkvZkJ>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 9 Oct 2026 11:32:18 -0400 (EDT)
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
Subject: [PATCH v2 2/4] selftests/mm: check sub-PMD ranges window by window in check_huge()
Date: Fri,  9 Oct 2026 16:32:06 +0100
Message-ID: <20261009153210.236517-3-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261009153210.236517-1-kirill@shutemov.name>
References: <20261009153210.236517-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E386B140010
X-Stat-Signature: spj3qdrg6kyqeb7eozrtx3xz3px6gusu
X-HE-Tag: 1791559939-695864
X-HE-Meta: U2FsdGVkX1+HCXH2/zU97zYyQ5ojgShRlbKRqiTV4p/pCgiRKWRxCLIZqPHS/gLZ2Owyg7hFqgqFZ8uRqjCyFPePuvnlWpsfFhFFNtRQUeCLZ5Pny7rWTbLDZ6GO7phY+BJppT5Rkr3c61oqFGUU/4WUzNbaloBE6wRmEt1n+s44mzbs0t3Up/zjhuVvQ99hUvrwjW5qULHEalxj6qICbpGxTgwWUsgJuEsHewXQ5YqjQf03ULYdNKx0Ln9tDkymbecXI5/lewJ8NWhDUO1IKyf6tuBD3aSKsjtqJxck2OhF/xmSgYLQk38EPSoKz3jFTJzGbq7umXSvXgoG3bHYye8oG/a87escfUVhcO+DBc/+GQhY321fYZS1ykGpDiF9D470nRYRCfQUOyxN5SLGl6wVH+EYpdKjJ5MUP1/3XmFb23C6W390XQ00illy1pzabLBXGV25eveMtPP4Jg8LZDuttXRTiqp+gtf8Mqktv/bB4xJbido0cBZsDoyxTLNrNt16AKSpLHq6qWJeeKBvo/4eAQ2ZI7bYRUVjPK6VjhaTocD3gvJRheUnZGa6f6/LNPFaTMaGh+GXo2YP98B1XuECU3zdI2RhsY+9Z5HgijoqvZ/snUZBFKOQdmoacCVesIHWPyGVAM0jh4414Z4FPMoNZm6OasByRIprtyuoh2YjdfnW9qMSSMmzukiJc4kHfBguIh6VZGPcWR9KXZ8aKSEaQLt2u5I+W2k+aiem0ufPlsDeddDzBEcnfS+NQiHt9mJ/nV+GssPS0BzFWqfb5NTNJBaSYDab9Yk36W+Qk2utPHCvgImamq4msAB+try7e0H2K105Uj764jO0AwWZaqvI+OkAG3WWWkPpKo9JKiZuoVeIrv4g7rMnGb0YIWLO8oNmmgIbLSJ17j8jWrUOG6/lAwCSuuXJ0r1MrXblmlRjLABsP1fyaOjeqZbcxP/kvWGtcX9r1OXdE+Zp+js
 wwba3sj4
 C47UCwFUpFV9XSmmliYZe72gPwVhwi1SZat+mJU3qLi9MRn21Ltw9dmEs5Q72zo5hgiLqbRchtmq8KwGtt4YXVhQTf6Z04TiBoDylsmjDNeVPDCVha6k7juCWukzRBuV+PhSKGdrVOYSI9MEV+YMdh3hAcpRRKP4qts7c3t/Yq1b8Fv4Xkxamb5Hgq1gfM9jFXLLWSdwW+/e8Aa2G6+rJCAtfwcsvvGQjP/ZsKeHTamOYYx0FakXhorAwcHKEQN3FKtGn6lff9yv8zpukUZFFYSkiphZEUVxjRciVBrEZHv6ot8kqNrrsUfsoxnStZvGjmFGbRj81N4G+1LviFYz08zdrXuRoXE3mrxDqaqzDwinHl5rT/AQTPHRq6i1PZ2hXIUtZ39eIiZ5bkMH4G5OdHeQ07WiwqApHbP/SS1HYkcIuorNs2Evi4w7d0+iA3Aep2/IKjJC3px3Iy19zXTY0G7PEzEWIbBc+9tIDD/KpvVUB50wiLlfobOBw3UiwTc4XLW9sdHtr/tVgsQsT05+sUvwIImWH2advm/m4uTCuJrIF0LLvbxdY2vhm3iWCA/Ofx6nw
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
index 09d9135f0ca8..b62e33ad1201 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -17,7 +17,6 @@
 #define MAX_LINE_LENGTH 500
 #define PAGEMAP_PATH "/proc/self/pagemap"
 #define KPAGEFLAGS_PATH "/proc/kpageflags"
-#define MAX_NR_ORDERS 20
 
 unsigned int __page_size;
 unsigned int __page_shift;
@@ -393,34 +392,72 @@ char *__get_smap_entry(void *addr, const char *pattern, char *buf, size_t len)
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
@@ -467,8 +504,8 @@ static bool __check_huge(void *addr, size_t len, int nr_hpages,
 	kpageflags_fd = kpageflags_fd_get();
 
 	if (!check_pmd_mapping &&
-	    !check_large_folios(pagemap_fd, kpageflags_fd,
-				addr, len, nr_hpages, hpage_size))
+	    nr_hpages != count_windows_at_order(start, len, hpage_size,
+						pagemap_fd, kpageflags_fd))
 		return false;
 
 	for (; start < end; start += scan_mapping_size) {
@@ -604,52 +641,6 @@ bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
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


