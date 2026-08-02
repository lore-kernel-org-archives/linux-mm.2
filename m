Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DE5FC55162
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 19:53:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3ACE96B008A; Sun,  2 Aug 2026 15:53:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35E076B0092; Sun,  2 Aug 2026 15:53:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FE796B0093; Sun,  2 Aug 2026 15:53:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E43F46B008A
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 15:53:06 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 76EBA80522
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 19:53:06 +0000 (UTC)
X-FDA: 85057377972.20.96FED34
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	by imf28.hostedemail.com (Postfix) with ESMTP id 814B2C0002
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 19:53:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="I zoNT2L";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=Czd9oGqE;
	spf=pass (imf28.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785700384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Yc9ml7CfBPQ/cIKQqowgz5k8tYCqly+NyaD0PaW07E=;
	b=EoBMn8QxEJgew7Jin4b2eWcfF/ONxVp9XX0MMZ6J57YouVvFubLIeVGtCelfgIwSV6tc5Z
	1X0YX7BPHjGZbGNTGacFzueqYBAIROS7Jfq26AbeaJFd6/0/4K2HRTwj7WEfx5NnEP8Rns
	omU0eC7X74mXqCKa0YJoBwbHqnqwH94=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="I zoNT2L";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=Czd9oGqE;
	spf=pass (imf28.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785700384;
	b=jW1/OWqRtsH8nlKgO6ZVhiTqVAt5K3MPz8hEiU0KNZjIRWPzXoA+W3d/QPIyPsYFAy7jGj
	gJM0u6cBlDbxM2dVmywbT+o9ii1bNV+vIv6MOJjhkTDXdkoyStyED0VSnlfrZ/ZVZqoEER
	oY0mYHauOqaEz0WclTaHkEMjE9MMnSs=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 074461400051;
	Sun,  2 Aug 2026 15:53:04 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Sun, 02 Aug 2026 15:53:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1785700384; x=
	1785786784; bh=1Yc9ml7CfBPQ/cIKQqowgz5k8tYCqly+NyaD0PaW07E=; b=I
	zoNT2L3/dKDrxX7QCfoolISbpCCpOFRTvHNf5Dnq+a8XqbxrCnYUxUddYdamsEZB
	e43GShQg/CJVZHtvALxDAOR+TvHgO/ZbjhNA+L9ljsf9UQ8hz2e+rbZ2v9Q40BCh
	sCfgSgrt5MQsN8IJF1iMV8Xc5hir5/o4Jixt23tf0J7ZC49LB4TiC/zU7JlZuqtk
	hEhn29ErswubY0ONplZ5nriMaH0aNyh3kW+wRhp5H0com66mpm3G4qV9DhLuLpfv
	cyq4cL9pfPwwL/iFVrDcymVigu6tNrTSEeBtlQj9vjB1DgJMTG/zxu/UU8CBF6Ci
	E9RWA8av7ULnOipUehZ+w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1785700384; x=1785786784; bh=1
	Yc9ml7CfBPQ/cIKQqowgz5k8tYCqly+NyaD0PaW07E=; b=Czd9oGqEKgRLHKRhY
	Vna28jK1EghLAPWLC3G12/xNNsCNKeyR87+5UnvovqJF8JNUuN7Awd3p3CnvwlKQ
	bhTLTVzBbZm8Yc1BrSUfGhj0uRkkbXd6n/EUQWTmorqm51A/6qLumfMzDytHMHlI
	QvpiaBEGKsyxCtYMowGDaCNX24PT7LRq1wmVOeq4uc+bVZQaLbLdVJJ6zq6Nt6Fv
	jXTiV7rKtZjxaRWg2eZ48na9IMTXA3/Pn9/LF8/xAhFdjiQvm1WT/Jhg5sMP+nPj
	zIaNthRXA5VmxngAXSAIImfmMkAGj3zWJl81sVyIWs/ytgGfFT3Hb4RiQSXoQ0GH
	E1+gA==
X-ME-Sender: <xms:H6BvamCPiZKsDaHwMfQIjqmMyi6bOov_DlOwmAbYlIFengiOt0pUhA>
    <xme:H6BvarDznRJmAFDXLfDZYKVPCAa4WEEzHtw99J8Zv8QaoPH9FfWGC7pKI_z-rpKX2
    gmzEiwy0mbYoUvDzrZ4mrWTUEzwEDzOQUgDRjp9HewKnF6ZWd-o9_uI>
X-ME-Received: <xmr:H6Bvamh_lmJrK-fXu80ILQJUeWwtvu1SIpcE923N0HrAK_a6rZsWe4AfnLk>
X-ME-Proxy-Cause: dmFkZTFcbv35QwNbwWPHQBcJdrWasH4YRFOBaNWig98oa0GgLD3LmQrthvyDgK5JnDhp96
    dBkNywOXlTP9Hby+cm0vRQHofuB4BhsdtVcBrMer/A2AOpegfr9Hr7RYzI6OqquxWhxeXC
    aB5bOw4cR5G6EDzO4v2r94SJnXRDYvi2NMwyCB/quID+suEuw0TjLUMYjjQ5pFm1F3OqpQ
    Ctej7rOharBpUeBz9hjZojzUlseCYYYMV+BulSa6+jD3O5m4ZOeULsSyQlLb9bciCyrhiP
    bT+z0cGYr8PFizBGTpPnPZCe+jZkx/DQlEsoaoSV2SjHlZpE6q2+n/t1AcZaLqu1qPGmAT
    BkOOyujnxS1vXWxSunZU9KLceiCDM3h+HuZoPbLVK1NwQpUH6QHf7AUk1ebU1xyA5YckA7
    gGQaE+poT7LDMsG+DAUtWkyoo4wwOimaqksPNvRtr/stXgEBnc7k4T0H7+F7Z64oIo0miP
    9ztnIsPDlPqaDKCmUlYCmPvjgBg7XqIQpAWwO4dBOh3ys3GhMlcGlUno4TCvPOgEY7nDV3
    YPirq6COLeiKL8FRcQrXzd3H095Q0sqWpKpY1afRicX7v6byx8vIArye4rkTK9GrfmQkxI
    RUCJx3S4l5xFQSIACt7scyxVovTD85vAtUxRClk36P4wyNgzln3DOcrAgjNQ
X-ME-Proxy: <xmx:H6Bvand22O8NVYbzVDntV8NozIQfBN6fsuU5x1ruxQp-G32IJ-wuTA>
    <xmx:H6BvajieC9abqYic6kwz0s_GzH42VchdMTpE-Jl5qN7iq-pA_nKeaQ>
    <xmx:H6BvatME8RTDx9ESqX_Iw9oGcecsZE3w72Lh77UdGZHRcI7v2Irkjg>
    <xmx:H6BvankYMNmUC7RtolJ5cTfu3BU3cfQG2SHsZ2PV50T9Hd4Im2wBgQ>
    <xmx:IKBval9N5EGVqugCGbuPuULAUSabiTUgYeZPyJBH9dLNlUhM43Ec9wW7>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 2 Aug 2026 15:53:02 -0400 (EDT)
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
Subject: [PATCH 02/16] selftests/mm: add folio-order check for VA ranges
Date: Sun,  2 Aug 2026 20:52:34 +0100
Message-ID: <20260802195254.1937477-3-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260802195254.1937477-1-kirill@shutemov.name>
References: <20260802195254.1937477-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 814B2C0002
X-Stat-Signature: tym5s79oxfmb4865w97d4tdpuxctc8we
X-HE-Tag: 1785700384-348119
X-HE-Meta: U2FsdGVkX182sjkRk+WGmJRekH1p3CPN/gUyN0tUiKfBx2QOravyiVNpwtHAKWeaafjQUwf+B6vSqsa7jx+6VkFw9LX+kDXE3Jw8D6t9TC5zJ4Sy1Iv/3kmTcwPL0OR80NJhdbCLo/BCuIBjj0Y9i9vFxy11RCGkJhT0HbeOQpetNLSlN4t425GQ8/BJi4OqtouO6EV/58c22RaVmVh/uGxF4uE5ST5xFwfyKeZ+pw6uqAYBP6DX4zJoFcWLzMnilHkHoJiagfhcFpiB1gyVc1tutnlwp5hheJLRRxRwQknel1y00QVAk5WrkBCfrOpgWjh/hN+6YvdoVtP3OphGroq7l1+c6SGWhQJeGY2INwwpZBEw7jNBO10ZnNTvpb3lvdIR2Oo1GdCWQLSZYlNPczeQH2ucVBuRTekiQlUCkCoAlrAquMZitlrSTTftDN3HAGd3uZY9Hby6X83kFFyRTlSyn1sBcbqMGX4oeo0gIUCp40iOaI950QUk8NEOhuABCfzAZYmJlSJanOor4KK1vA5RoU6yLCn7UXfP2GKOIydQcO0FAf/l2XihZySqZG15ptojyrwhbsdQXjLJMjU71ho7XvJ6c8tEgHR1DeTt3NKNS7CvHl0xsdyNuHnSmPy5iavM67k9Ni95vQYB2oAhgWkrVKjo0kiBIGic0UkDM+rjuxVxfVnTRqLId6QUrZMIxCNLeOgWxXLBDu0zvy8MYBiFKWO7dNfY6CjFJlpW1jZcuuUGgWZDJO0zbJRYGz0mT42kwRdKQmBcx3C5cKxy2NhV3wzaOx78hS1NGtT6jOQFl8Hw0aZawFpZYmg1J6vH48F2TM+DjsaGdm88G5CRDdihQNBJcjECj8/iIjywyx3GOYOEBBhjly8b9VTCrya7ZLXUTH57Es4dWCwOR8VX/nX877pQJSK9Hx2s/2G90rUIOctfVmgXjguVYi34jw6KMaVGf84jggWqaXQevwL
 9UAslOnM
 tZ4uCRFhefJpFmtDQQ6nDpDFTJJjDGg2S4lDZ9tQNNvY6NKD9vfVZLcAXKPEUTd+7XIMhYuTw/3FDbHyb0nqmVD/CebYkGvsaTdlOWLnThBUQSx1vRCnFkngPaw9VcLlt7x2KZLJHm2c4uH1qR1VnpGJNTLXXmoUMAhSfjyejA7RmP2FCM5i76X2U0150pwYRzJtnr4NBc6abAjgKZaaRFx3XsfvGt/+rzkrKk8bLSLYBj5RxIjJ79WElN3V9ZjryLRcDpDQOWhN4dnfg9b/yjV0TpiLYfWvp+R8oCWngM6Zz80UcxnLP7hUp8TaxtYDvxeI9jG4dFGOJU78vOofXVHzMsRaNMxkwpA1NQNws1ITJjRi458YyLJfa5lx3haWnT2Zzyq0mt/X16zzdr8VKPfyinTsgauZDfhPEYWIZ8jb8LggSo9PkSnd7E0DcNKa//9AxLvo9Eebbihw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

is_backed_by_folio() answers "what order folio backs this page", but
mTHP collapse tests need the range-level question: is every
order-aligned window of this VA range backed by one folio of exactly
that order, mapped head-to-tail?

Add is_range_backed_by_folio_orders(): per window, require a present
and naturally aligned head PFN, a contiguous PFN run across the
window, and is_backed_by_folio() agreeing on the order. A window
assembled from pieces of different folios, or mapping a folio outside
its natural position, fails the check.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/vm_util.c | 46 ++++++++++++++++++++++++++++
 tools/testing/selftests/mm/vm_util.h |  2 ++
 2 files changed, 48 insertions(+)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 343a15e25a9f..793342095420 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -365,6 +365,52 @@ bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
 	return false;
 }
 
+/*
+ * Check whether the range [start, start + len) is backed by folios of
+ * exactly @order, mapped at their natural alignment.
+ *
+ * is_backed_by_folio() classifies the folio backing one page; here we
+ * additionally require that each order-aligned window of the range maps
+ * one such folio head-to-tail: the VA range must be naturally aligned,
+ * each window's PFN run must be contiguous, and the first PFN must be
+ * the (naturally aligned) folio head.
+ *
+ * This is the check "did this range collapse into order-@order folios":
+ * a window assembled from parts of several folios, or mapping a folio
+ * shifted from its natural position, fails.
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
index 5eb90e0d1d13..76e9938a908e 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -97,6 +97,8 @@ int64_t allocate_transhuge(void *ptr, int pagemap_fd);
 int pageflags_get(unsigned long pfn, int kpageflags_fd, uint64_t *flags);
 bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
 			int kpageflags_fd);
+bool is_range_backed_by_folio_orders(char *start, size_t len, int order,
+				     int pagemap_fd, int kpageflags_fd);
 
 int uffd_register(int uffd, void *addr, uint64_t len,
 		  bool miss, bool wp, bool minor);
-- 
2.54.0


