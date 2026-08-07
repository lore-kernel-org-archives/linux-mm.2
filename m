Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02B6EC5AC7C
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 11:37:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4599D6B009B; Fri,  7 Aug 2026 07:37:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 430876B009D; Fri,  7 Aug 2026 07:37:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 347B56B009E; Fri,  7 Aug 2026 07:37:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 121826B009B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:37:10 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A2F37801ED
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:37:09 +0000 (UTC)
X-FDA: 85074272178.03.2C016CD
Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	by imf18.hostedemail.com (Postfix) with ESMTP id ADE891C0006
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:37:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="D maVQLP";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=ik8DZv6U;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786102627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l5gMlhY734ld4sS1EqunE+HNrHgaVjUphYaBo5q1iDU=;
	b=7u6Dm6eXpVn6s2V4fcRSEe65CyIn8DSwB5jmKmY5GTWD0xFdDXXCC2koZPs15MyUX8o82j
	PjSn+BXxRBn8S4PtW43PxXsFxfaOJOcqwP2qMYa5cqnOED5+GbhCg9bg+gZoyWjHL0nO1S
	IQ7W8ZqwZe29E/O6PPkS8ldj4mXv+og=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="D maVQLP";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=ik8DZv6U;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786102627;
	b=oKqrm/1X8J/cYuiDiFo7gQyj1e5PHjf/ko9eNZUAqajCUJfjCEgpHtkhfxDGponnXHCdFI
	oPx3ahoMmI0zzygXbaMRiy9ehMfsXcoJ95tdqJYbwaaEJDmCdgGGQ9xfbyHGu8V3FfVZ8r
	6eA7lOq6UkWuApEtLr/aIgUt7Wb6TN8=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 87F197A00C4;
	Fri,  7 Aug 2026 07:37:06 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Fri, 07 Aug 2026 07:37:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786102626; x=
	1786189026; bh=l5gMlhY734ld4sS1EqunE+HNrHgaVjUphYaBo5q1iDU=; b=D
	maVQLPwpHskr8ZYltXRDXvTDO8EUBoI4blSsCsLSlmOcSIZ5ccYVXjE+i79PZEqg
	z/sKey8i+8JWvTFRLTNGewLfay5YbjPW/wgYN/Z315ZrVTAzODHNQafq25GNFIZ9
	XDwhx6gKAxkNEup6fSy33LYr3OVwCddMUd4TS9hRsdcadROm2yobmhPy8N8+RJB0
	IfeFfwU0kTIL28WWDS1hYuJsnDPKesoddmWNIoMTiyeVs1uveNgvs1P61ozuucpe
	8PFZJII0akGLU7mCMND5Yw28Lss0WxeEEepFDwc2mjZAa00Pappe0TrAabPM2LeJ
	9NiNoZDtHj3958r/lFCxg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786102626; x=1786189026; bh=l
	5gMlhY734ld4sS1EqunE+HNrHgaVjUphYaBo5q1iDU=; b=ik8DZv6UZHXaMv2hq
	XY6dHfmZtlMNX1O288ZJ2ib/FFhKWLJGAxLrrsxsBbgzEI1aXVNketVyDOmFa7Xh
	5a2Ji+qnQyLfpGZ+/ChVJA+ZuDNWkS9PwYqS5nGrx85AHneCY46NTbCeFpteqvhQ
	BU4z8DVKX3R52DOn1IZ3t9Qr6uBldXiF6Af5KDFFWVID8Vt0mIglXtOVhGLPIzmw
	SxPJuUGgUE9XxbBtI02WifuQFxNliGlaewXV7tS03dDDMNPxtOL8/jvda4EtzwJ6
	4Z8tB0aBqTcVK/h/VKlJ/4cQlYKbcE5em4EXtCl4TJNpe+1NjMkw6T2sgh/4KAgz
	Ag4Qw==
X-ME-Sender: <xms:YsN1avPgV4ttFl4CSJ7Iy4gTK0vLqk9bS3WFIrsC1CbJorsWps9ZKg>
    <xme:YsN1at5gszCspb8G7Z0aGZpkH2h3EfMmzXViy_7oOziKo4VtV6EbkKZxGsff074PJ
    KN_lOoanB_71ZHJJDhZ8F2A3YWqeHjjSC1xeN_vD7dy45XOOo7x_y6z>
X-ME-Received: <xmr:YsN1amzyzP7TgQ59Y47WyT0KZB2ojMLtMXHBaEYV81gsf2fDYA1pVyiLyp4>
X-ME-Proxy-Cause: dmFkZTEcBCtHwgFqhRPkncf0k+1ylINMWkiJotqLKgP2XUmyCnaVLH6jJFUJYUtwVpCetV
    bzy51nCrHgVQnKUbL6xUc35a2wACIZl+NbR3y/w0ModeWlKP4SKCXfcn2Mi8esZBMBdaWx
    faB4jzBJOawj2LBnFTgyCBiywrPp7FpNgfXB5cgYmB0wgvQ/HhhWAfKjMf/weJgLhMF/VV
    yXrMoja9EZiHjuXu8bb94hiDoU2fqI8TuwJJmzzN4TUL6MxSST+GnkpA2ZnKWVewXCphJB
    Lec89iAB+bDvFyV3zsxjbJ8cA1IEQ3aF+gxi5HDHtN75oTRJtbf/Sd54tDaiXy5fa0cQqS
    TiLXeHKeb+yhvBs42rwl+ePNPwrcrCpwjXd2vzbNyTKLhIUtrOJAuN15gqmTF5MDKkfuGE
    uX9cm0I6yOBZ1hS9pgoUq5/SSInRuWjFQciDGDhe5m6S8U21ILwj8Ehydnx3O86lYuTp6L
    fSAMba/DSXMK6QG7KbZBNIOGbS4ZIfQGxHMWj9JOmhpF3QRHO18vsM+2xfgxQWleRPyUKu
    2P9eT8X6NWOWfhoEeN/z+SQeX35x7EzXlyyXFcTy/vMzJnPTvm3GDLShNMCBPaN3cTdM9z
    iBcgXeu6d//2ZKvvtP6tze5ZH0X0hTji9BezWMplN8bOwaSsxF2RjWKc6Q2Q
X-ME-Proxy: <xmx:YsN1atRQfDSRW9Z_KLkiHCWcK7W158Phy3nu0SNBgWeUiqk3-cUXyg>
    <xmx:YsN1au80xTPpTI6mK8il8QPndiQ1HSrKs9Qg3VNtSXlUN1iBBr06ag>
    <xmx:YsN1aqJVI0Y6sagPa6141JmxtJuBUljnBtVVhWnm932EtKQsdntFig>
    <xmx:YsN1aisoRFnADVkEtE9dnKLiwQd88PrJ6J_ryCDblTzuofgZ72NwDw>
    <xmx:YsN1anvmPPxzitgUd8uih3PaHBJFFPnsBRaZl0VIuS77GLTwzZLD-odb>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 7 Aug 2026 07:37:05 -0400 (EDT)
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
Subject: [PATCH v2 06/17] selftests/mm: add folio-order check for address ranges
Date: Fri,  7 Aug 2026 12:36:36 +0100
Message-ID: <20260807113647.3744609-7-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807113647.3744609-1-kirill@shutemov.name>
References: <20260807113647.3744609-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: ADE891C0006
X-Stat-Signature: u3ja1xxhzx6t3tqpu8fwd55dqs4ex47f
X-Rspam-User: 
X-HE-Tag: 1786102627-949062
X-HE-Meta: U2FsdGVkX1+70wwyFwe+jdoh9st9Duv2FjbAgM6TYWs6L8D+Rl2soOrrvTLKNAB0DJqIidRyZ658RLaGxxxxfjisn+MhfcZrc9jo2K4qlR2hGlCPzNjiY5qqHq0tOYb5oswEjOiYduiGPABNAYzc1PrShLCZ0bcx5q+0pgK0y75HG/nQX90B9pqEhDPYzEsVRmROYM7YAkw51Wd987HWnzvRlBcTeLRHyM7SrxBZrNR5QGJVd42drWFCIlrzv+0Y1PrppSr0I5g5X8omjgderw++S0H7l0xZQ6MZtuqOfMzUBEHebGTE4CIgwQn01a5wx/Wn4oNpD0NV0hPEwAtEEaClRrhj2jvHI4LhPRxMqR965AEuaOXjTwcd8+k7YxydxBxyEzWFenN7muyRMRj2PE9N39chaXVfIDe6mxnvaIMzZxAyL7PrjeXKlTxcUw3ddG6qdjK5U+zSxRezkch2ayMnT2p4pJxK53Zp2foqFZRiI+JsDOot0JieTkKXRJRYuNmNXUui6Y427ljLCdx4y6G3bW0egIIXMv8aCZMrwGFtytWghRucqqPcolKWAA6KkBq72H7fxWOD+94UjoW5V0BztoBH2tkQhOesgPT7nQOfMFePs+wxkhY1nYOujt358f4YPUrqv7oMyqCcqhVwVun2iHspXxCJiy4q9gLRo6avZ6JKUFFwJfD0DfxxOmEEKcX0bq/4JCU6wVEmy8mnDciMWI5SnXFHsH9TcjC6O0j2AZhTjRL8VkP59vNM+4QcYU12WOm7D5Fzc9HvUw9ojXrjTBBOkAmnEMZbcXMyAb2G4VaIFwnVBYyhLVTWk06mghzBbMj41ofaOoqdL7b1kkV0zGwsSVueges4iuO2EN/8q8J2U6m3KWvkQJtGG8wz5Dn0NpKlCgfC483X3IxyImMXsC0u8RZMTN3QmsVoVle2V/UsiMXv9tA5vXxStcYw3HCHS5gEa+vIVC0RPnH
 qA3rhJNg
 olBntkl6Vauh0vSqNlOBQU+pJ3qrT0sFKwh6RF+mmTbgygZGHUR+7WvdnZmm04vzHycesAIsdflWTzYlwDOTxLDAU7zKHxkrsZWg4j8PerVvTPG9a7GpxGaQNjTjrQFgLiSqUks7Kl6utxAmP/0vSxeGlQc4rdx7y2YctBaM9FUz5A4ObR5GxVgo99aOnN5XNBM5i8RefBgVtHKG/N+RV9mnmhcq8wc6X7ObHFJrCsago8y9vmPxT8xFG4TEAXSlqBQ2vS1vPYEGXjX2Xvpq2lk4dX0qrygp83MCb/yXFw+TnCckK/zQs3+WLGmqINNr3CbLv8Raiz7IlmwzNp2kaa5epP1PXCZfc2hrJSV1flk+9oun+vIzopAMIhYRh+2Ikjm+irWQG7jILZCqpoyai74GF/zBFXY18HJHIr/h+wsJSAV1xe5BM6BlOqFhX43QVc0/9KPNd6UDbOqA=
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
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/vm_util.c | 42 ++++++++++++++++++++++++++++
 tools/testing/selftests/mm/vm_util.h |  2 ++
 2 files changed, 44 insertions(+)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 3c276865a778..3f586f2c3d33 100644
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


