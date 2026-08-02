Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C0B2C55162
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 19:53:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FB7A6B0088; Sun,  2 Aug 2026 15:53:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35DD16B008A; Sun,  2 Aug 2026 15:53:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24C7F6B0092; Sun,  2 Aug 2026 15:53:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E57566B0088
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 15:53:04 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6A0EF14034F
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 19:53:04 +0000 (UTC)
X-FDA: 85057377888.14.AF669E7
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	by imf26.hostedemail.com (Postfix) with ESMTP id 72B3F140004
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 19:53:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="r GgZefw";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="lGsyB/5G";
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785700382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=exSxa18tvSalYuxDaP6ddzC4ErD/EJHfkXborP8h5XM=;
	b=yathtdQJWNl79g+O/7jrn6FMX27myyFa0+Oh0lZjxH4gEDNoXRHAG86pC/UEJmaWAPOevh
	p2K82jKLm/jPhIuAbFTNnHsnEZehs/Kl91Z4Nz9B/dZEOtf4cN29Nb6DW4ET7pKPCnHYKX
	/P6PkDl7+0O5CnnO2Eur05pvk6Er/LE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785700382;
	b=WpaBLmJriN9sqlQ8hxwdeKTitWqUWbFXuLivMM36Bvy1elElwUBtId3PLYhuu0KYa0AJcY
	R8f76nCmJYBeJLqpUcxyViZz0Z/vFzxDPG+dDAb1XEFoxhRkt9i5MUr1FsXv21muq7s5SQ
	5mX69IjCoNGwGvC1kPZN4X1wDoirtQE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="r GgZefw";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="lGsyB/5G";
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfhigh.phl.internal (Postfix) with ESMTP id F34C91400056;
	Sun,  2 Aug 2026 15:53:01 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Sun, 02 Aug 2026 15:53:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1785700381; x=
	1785786781; bh=exSxa18tvSalYuxDaP6ddzC4ErD/EJHfkXborP8h5XM=; b=r
	GgZefwTFg1VWLseoCMtP+k8C6/cIK1kf+cfzTrNvw3bskA4eoxwjknIHcJXPE5pG
	K2mf4ZVHcNoYukzxFBMjirQ/AT2GS3FZ29ScAzb7alsyJuVaoA1nTVV5eyJbtD+y
	3JjbPRYZkhPltuAdA3XlRad/HzNxWoZuHrF1khpD0/2bn03WOwiFj/BJBlB6SbeP
	XxoywY52t7Q6OdQHteMLlYKViJ8P54rcSh6UdtEJoQWBb0onBCDPH6bLUXxK+kMG
	JL2oYpYiV/D3yelGm8G62Sx6pN8LCcUwMD2uoHFnrxvaoyh19zSFem55Hjg9uECE
	5Hilbux+0Wz2FCZlRqjKw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1785700381; x=1785786781; bh=e
	xSxa18tvSalYuxDaP6ddzC4ErD/EJHfkXborP8h5XM=; b=lGsyB/5GX4Uy7xpSd
	WbHVbtTRX1nEuCxfzEOovNVjft8Cf3qN1n5cXWQ2qgSb8OdoOBI5IKR1YF8vt8ec
	YLHFx6smUguS+xLrtx1OcByGVDBuhGV1iPhmWnmUX9e7tpgrIsuSXTNUJlYc/dGK
	JzCmjH1QY/ovdbLUoZM334AcF06RDpByUm8T+Wtwcr9rx2VSfFqZQL6IuW4z0j81
	BPt9c6ZRUq7+jw4iOLrpZByZVWyRj/s54mEe0tIjUiHDkso0hteht302MIiEOvHh
	oEECoo2Pp587vYY0nMZi+KRS5CHAAoZqQiQLT+mI+I/KIihH7MnDc5/NAgy12JbC
	Y9tEg==
X-ME-Sender: <xms:HaBvatJXvAaq5pXv7sGZDuRkvpmSUjBf9-AlSepvIU-oCrVNBtl7uw>
    <xme:HaBvajq4a9FeY4ch927Kzpj4i-MPZQ4XPvPX69PMXGavT2vMxF9Hqwc8C8w9SRAez
    9YyqUgLf-qy2_r5c1HNwCw_cIK7WrH_uugayqh0NdSGzkkfAQpEFTGR>
X-ME-Received: <xmr:HaBvaioq_1nb06NZyoyOgKgzEF-dlwoICBHtUNFRRe7ixgfWWoWu0ux0hTE>
X-ME-Proxy-Cause: dmFkZTFcbv35QwNbwWPHQBcJdrWasH4YRFOBaNWig98oa0GgLD3LmQrthvyDgK5JnDhp96
    dBkNywOXlTP9Hby+cm0vRQHofuB4BhsdtVcBrMer/A2AOpegfr9Hr7RYzI6OqquxWhxeXC
    aB5bOw4cR5G6EDzO4v2r94SJnXRDYvi2NMwyCB/quID+suEuw0TjLUMYjjQ5pFm1F3OqpQ
    Ctej7rOharBpUeBz9hjZojzUlseCYYYMV+BulSa6+jD3O5m4ZOeULsSyQlLb9bciCyrhiP
    bT+z0cGYr8PFizBGTpPnPZCe+jZkx/DQlEsoaoSV2SjHlZpE6q2+n/t1AcZaLqu1qPGmNP
    WeW4sbaB+hDCdok+K551BijkIgMPto0pUlo2Qa25tWIIjzZ5oFhMdk64zmrXWt9mXklEb5
    kBG0XwjD99DtjoNRzDR/al+grOyrijltYB81RXtFyTi0Np5b/jcsHiGX0hP7wdkGelJZxM
    Us6Hnt+HK0e2facSWJMwzWMP3xu5Wl2WycLB/zP5Cr/nnWTkwwe6t0QWWxgIrnun83mayr
    sZgZ5XJD2niKDfEyqdMgUTgZS3RYPdauXRnwE8nsv1da2Wpr0VhZqSABZu9Deg4hGtekJT
    lF5aoyrN0Od7cgpjWEu0aDxBg/Xs2ii+sxGqemprvzvvV4bk3BVdZrzW06zA
X-ME-Proxy: <xmx:HaBvahF3q_dRpnBMlrZuZGEFlz0G8Xz0i3fN9g5qwujoAdSwuPa-Cg>
    <xmx:HaBvaso7ZdcKzmlM_qOAjKyEpN94DPzYeGO8pqCyoV2Ablw6QelgvA>
    <xmx:HaBvav1HQgqNOZbv_LRZ25qmGGz8tuPUMll2Nh7MQ1uKrh02MxaQRg>
    <xmx:HaBvaltt2aXKEDkayayVUhuzsgEZhoofM43qBgMupD-JaOmxhK2-Qw>
    <xmx:HaBvajyIkGcInjdm5sdtubS77WCfol00GpNgeKl8sV7-GoQDjURbYKkN>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 2 Aug 2026 15:53:00 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Nico Pache <nico.pache@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH 01/16] selftests/mm: move is_backed_by_folio() into vm_util
Date: Sun,  2 Aug 2026 20:52:33 +0100
Message-ID: <20260802195254.1937477-2-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260802195254.1937477-1-kirill@shutemov.name>
References: <20260802195254.1937477-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 72B3F140004
X-Stat-Signature: a7hizcw8644hyyze18qzx8dhs7cmpy7z
X-Rspam-User: 
X-HE-Tag: 1785700382-246951
X-HE-Meta: U2FsdGVkX1885AJ23UFNjutcMQSTkCcpnJBR33yNDgFGU4SUjj0af8gN+DCB/YDpmkxTzRbntZ+IXeXjwsvJ6KAE9TUTSg8fA2SF3dCXsNUGnmsccgVO6SCU+Z/Pb3Z0SLEGeBCZ32strCAHemyrmLb8E0bRukIj4ac/+KoJVhmt9TqWr7+FTAYzLc7vSV8Wbmnu9BwOz7NYHAi0nR9uHQQ/tQLySnkGfc8ltRuLehHPD5cBn41601d48k6gkSu5PNWXFYwqKgVKgbxKaON3CnoG2dwSfWlCvaKkDboX35VvazqkFPFlqETmhlZb/3Rcd5BZzdNrJoW2cwTg9+Ai9D4NQNAZS0zeXVyMZO02jFz3NxktyEL1q/F7qRPS8IOLeDBc0WhFUaG5LDAsgLFxMyKrQ8RLSlEzNt1RlsjngdUXCE1IxAcxEYpx7OR/eeBoZvVGlkR+eB0pwoZsNyeVJoKqmOy7Tzue7U32XpzJfRoYN4n17/9EZPZE7SaiIgBYopG1dfAyoD1163wsoazYu4Wq6SG+qptABWFxZ9RgGAq103wXfRd1FR4/5txhkBdsUgFG6KuD1mC7bZk76uXp5HaWLPT6wKVbjt09perWNnNjY9cPqGRP4WIukQ7NipyfyE50WEUVEjronFvvQZYhUmJ4uJZ3/m+39DPxrFs7vjUiyEnUEd5IR/pr79ZazIr7Kp6BiT/LtCqRZlg7DNvIQZOH4k1twkeTa0AhTN9RuhArT/N92OxptpplreZAQxgB4YARJbzgigcFwDFmwUAF/zvUfg0jfvCzwCSRwp2tH55XGksH434YARY7GulqyChoCAzGWPHRNC8Q9uFFJhb1K9D7xhwreJEROktGB3J/hxc8WkLx1DQwPDyAbAtqnKvYZVkBDFU6BJAcN+TUwY9sacsjo5SjHL4ZTbVkcLMmxTmHTKPdkiBZ/9rl/QuXc+R5Y+PjQrhTP+DdqfEK7zV
 I65aZ3Hp
 UYCTskTsZ8/4kLKAKPWRCOv502dST1aYRF74RRHOfBoccA4RMqpAeQqV/qSjfOfvrqfw4nqYSJ0+81sPR06Ap+P7IX+vqCjkhFOcJXvZaKEYvvKk5AdpkaVOjfwLeayLdAGqNh37LQ9Ms9qhAbfW3K3egQltIQFvRQkQjj/gNt1epSj+13DMnFrlQWshJgF74LueWXuD3n8c73ZN9uhz0VySt3pfP3s7MucEo1PBtKxiwEbj+TnPAeMZQ8X4R64XQtTJWmSUGKzyq8F43NxkwqNVGUPT0cadnxzN8TJQ4uKPEiwd9aX3tFKFbsjc1ZrIqxaeqHW0ZF1Ddzkiq2q+akRXUUc/MWBXQu7ZaSULyT1m/SBC2L1iPh08yLWeo0bGIW+mC4N3/9miVVNIAAW1a7TlFpTLpdxKCYTcIbv8R6+QDMEbnphjpa6jaHyuLn98QVK7JvPdyLegB/E0qV/iQQE8hMPlWxafkuFvYayJY6p+nnqOcwCxVaAeMXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The khugepaged selftest is about to gain mTHP collapse coverage, which
needs to verify that a VA range is backed by a folio of a given order.
split_huge_page_test.c already has the building block for that:
is_backed_by_folio() classifies the folio backing a page via
/proc/kpageflags compound head/tail flags.

Move it into vm_util so other tests can use it. No functional change.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 .../selftests/mm/split_huge_page_test.c       | 62 -------------------
 tools/testing/selftests/mm/vm_util.c          | 62 +++++++++++++++++++
 tools/testing/selftests/mm/vm_util.h          |  2 +
 3 files changed, 64 insertions(+), 62 deletions(-)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 32b991472f74..9b3885bd001b 100644
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
 static int vaddr_pageflags_get(char *vaddr, int pagemap_fd, int kpageflags_fd,
 		uint64_t *flags)
 {
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index ef1ea11981a7..343a15e25a9f 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -303,6 +303,68 @@ int pageflags_get(unsigned long pfn, int kpageflags_fd, uint64_t *flags)
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
index 7799154b67ee..5eb90e0d1d13 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -95,6 +95,8 @@ bool check_huge_file(void *addr, int nr_hpages, uint64_t hpage_size);
 bool check_huge_shmem(void *addr, int nr_hpages, uint64_t hpage_size);
 int64_t allocate_transhuge(void *ptr, int pagemap_fd);
 int pageflags_get(unsigned long pfn, int kpageflags_fd, uint64_t *flags);
+bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
+			int kpageflags_fd);
 
 int uffd_register(int uffd, void *addr, uint64_t len,
 		  bool miss, bool wp, bool minor);
-- 
2.54.0


