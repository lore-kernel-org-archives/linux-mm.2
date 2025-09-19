Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68C12CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 12:40:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1F1E8E0003; Fri, 19 Sep 2025 08:40:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAFD28E0001; Fri, 19 Sep 2025 08:40:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D5128E0003; Fri, 19 Sep 2025 08:40:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 799D88E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 08:40:48 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 45361C068C
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 12:40:48 +0000 (UTC)
X-FDA: 83905958976.23.2B1A032
Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	by imf12.hostedemail.com (Postfix) with ESMTP id 497144000A
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 12:40:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="o bLAWdc";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=n8+eomSU;
	spf=pass (imf12.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758285646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wuvDNaiAvAvSGeMLUplFIMVyMw23wgCwW9wv1JnwK0k=;
	b=WJugEC2vU8wuhyXnXDhlBhAmvC022oj1bAQDeKmgikWOIPhq2A52t7l+jRwvmnzDqWHcuo
	b6D0t72xXYL0vtLihSPo6qDPQd9no2bs+iMXhCTEWm+av4nGnmAaLhXRWev2FWdKq1jRwP
	aPcK98ODjt+gJi66NkIjRJdEt6PW2NM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758285646; a=rsa-sha256;
	cv=none;
	b=BhG8Xbshu6w/4gfYZC97TmbFCYfaf2NBHTss5LxlSkTitW9Jhi0st6vqLNafVAT35ejyYj
	m6Oh7nA1WBUGasIJPKSScPOOTqhZ9zEBY9gic/xe679nkCB1DdYSYLuXDSB8fCY8uIBnTQ
	i3eucAwpIBi/BqT+11ZgEsIPpXivx5s=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="o bLAWdc";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=n8+eomSU;
	spf=pass (imf12.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfhigh.phl.internal (Postfix) with ESMTP id B76011400167;
	Fri, 19 Sep 2025 08:40:45 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Fri, 19 Sep 2025 08:40:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1758285645; x=
	1758372045; bh=wuvDNaiAvAvSGeMLUplFIMVyMw23wgCwW9wv1JnwK0k=; b=o
	bLAWdcHu6MBmN0v7b8k006MBalYYsTHkKHHEyNeUVIWS4zDmTG5RsWD8Eu4st2Ep
	x72rwYjx8/VZSKfPMntKi/yCB9kcpj2DA8YiSK9DEnlZNX63ZM71YCGeT0/Og8R9
	+dBNsiy+urY11QyDWDDGMJHKSjB01/d2dz0mBn8OJCE80Sg8svPjocsh+M2VkpNr
	JHcup192PXiAwE4DQLbKbqtKWrrg+RedH6NkchsiXZK1O4LeVZxf/ylDlyNsOdy6
	yqj3ASnHOfgO6Ifs2HU43VngeJ3qsVJkVxM8LyYQ+CeQIg5Sknwes9/9urg+U7XM
	CFoGvWUtYJC7I4nDwE07Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1758285645; x=1758372045; bh=w
	uvDNaiAvAvSGeMLUplFIMVyMw23wgCwW9wv1JnwK0k=; b=n8+eomSUAJxKDuHxM
	4xsvKPdkstKitVeOM0yyacKzVbSCU0U4yq/NsCsqYSC8VhwTKAT/xnXpA2jt6igB
	+vPpQE41onWAX3881u4ytmZwOyfNoqQz6drMzZ7bag34xB5BT9vuf2iCknQElzUM
	GyTA9Up8PEukDhJU7Zp4WfDKgjSp/RRn7TEWReABsMXe0ck5ALgsTvhPti2cI4Wm
	i3Lg2mXCuiN5EjJO9kpGR9obr6tR0PLEvyw1IwcoPvUhkcPW3XGpQvav7TKui3Jw
	SO1pqm4NfW9FlkvyaRykShUN8NQYYybdqY+BhDpwm401EWRLrIp38DV5OAwqtEDt
	CJHvA==
X-ME-Sender: <xms:TU_NaKecyUMhU_G7m3PTi4NGOlJ9QR8Irqo4-_bnYbX8F_C_eAi1-Q>
    <xme:TU_NaFtZa_49KYfftmT3E94S-N87l87G7hd_sb5RmqtHgAB6ivTJQmL-FYkxUQWU3
    emsmUeR2FLzjvQapqc>
X-ME-Received: <xmr:TU_NaJKmhjL9XkundVcTR7t9rMD24Ygv_aqanCKUKZ7IMPGNqiNodhe1TlmVSw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdegledvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeegveehtdfgvdfhudegffeuuddvgeevjefhveevgefhvdevieevteei
    vdehjefhjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepudek
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouh
    hnuggrthhiohhnrdhorhhgpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrdgtohhm
    pdhrtghpthhtohephhhughhhugesghhoohhglhgvrdgtohhmpdhrtghpthhtohepfihilh
    hlhiesihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehlohhrvghniihordhsthho
    rghkvghssehorhgrtghlvgdrtghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtth
    esohhrrggtlhgvrdgtohhmpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgiipdhr
    tghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehsuhhrvghnsg
    esghhoohhglhgvrdgtohhm
X-ME-Proxy: <xmx:TU_NaPbKU7RZoC7cDCDnQP7Aa4UmWzeppB1IS6hI2zuyl98CQvojIQ>
    <xmx:TU_NaHIK9xssbI0oQus0Y51XNXXFuwA_jfDMLmfcp-h1mbtbYVFw2Q>
    <xmx:TU_NaAr-SKP9MnWpYtY1lgRj1bS6V-XO27dPEztvBWZlDGSPzAQjjA>
    <xmx:TU_NaIC9o1nqKx-9tUZywA09o2h9mzJH-3rRrtOVF7PHs3NBJg9YCw>
    <xmx:TU_NaAlAKvWgzOC8tCHBVvY3T7_VBwtq9hVA_jSMlGHr7NppcWpW_a_W>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 19 Sep 2025 08:40:44 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Matthew Wilcox <willy@infradead.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv2 1/5] mm/page_vma_mapped: Track if the page is mapped across page table boundary
Date: Fri, 19 Sep 2025 13:40:32 +0100
Message-ID: <20250919124036.455709-2-kirill@shutemov.name>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250919124036.455709-1-kirill@shutemov.name>
References: <20250919124036.455709-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 497144000A
X-Stat-Signature: rcsxk5cm7q5yj44o39ety31ngtddjsuy
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758285646-989633
X-HE-Meta: U2FsdGVkX18yGUz+ABUyCHoC39fujYEI4HxxHyGOjIxdo4eBVm30qcj4Alxh5kFl0bnYNiUYf9nmS39CpbKBhfDOVc9GX0D/eEd96x7g+AXPLr+z1xJPUx8NYkYWz8IUyHIWmxqitVGUJoQc9EVwo2ByFQ0Qod/pAV0JCg+axX3WdWHGgEnxrW7IOdtxQ+lfBqanMkcEz8EpenYgrrx5pD1LPBX5ONK+ytghO3PqTL/OVw+uBGUmtGiYhmrygoGVp7yfWo0cFLCeMom1qtyk6MYMzX0wvQ98fIQRjmUUor7ha7J0mkmyObjQ7FqmHnld22aXVNexDEXR0hRBPk3rk8S+mPHvHoLs+d3spfGWPoYmJc0IqrM+sbqbFTTLcgBV7sBofv44/Ak6uRAURPnqgnYk8BtGnJPtJ9cdW3C0D7PSW9Qm7nF9R4lz4qJf8krPa6LsPONmF6IsVP7l5RhpjRBcQItyoT4QKIcKkTf7e+eYxTZXhRqNbXetUhTkIUqF7kvwb0P15IQs9coDHy+MoHAU+6gT7hV51P0vsSKd7NnSHYTtgrNVgB2mdzc/cn5Q76fc8fhuuGZNM0UqtYvtPwOPH8/IK0ub3UKm1EAHId4kTPugWzxSzpmjpOLnzKlalFQ7PjxU0XYRHUcYfFvmaicetkMeC+6SWNhun3ybUW1H73ENwClK64YXj4dKNa+hPz5COeaRvKUA2GxuQSsXCMe690rtoQ0kq14eHoyjTXkmqdnPSjBg4rIt+Wcl7PHdN5VF1oB7lHxCGvooP6qEzU5bFnYhze/TOf+rinlD7lx7W26YzdlJ1+U75soVwXubrPKFbZwq54cpgvRpdNneGCSEN9yVJy1OfswU0hBjIRH/NGtDlXANjheXsUhTokqjt8glwKqcbnCaRxUfvvsWRAzGIDd6r71U8YsRCRxiRptsqV1iQWUTWKsUVxLn/ZfSoxZUMAw+vBV/YhECo4A
 RA+/VbTw
 iif7NBRGBkY6DI2E8fGbLOvZJCZ1Jsny8kzHG9k6UZOBPtbJltBpvoqDDdPEpJ6j6mo5Cgtim5ev/3XGeiJw9BPtol5F4zrf5TNYKYmp5eUyjB81l4Vs9GzM2rvMOyxg7oMNqDxBVuNA4x+JyVI1YeXwfCljFyg1RUl9UuY46YvuSfpi2S3JF23DduEfuBhFj0Tst8Qrg2dGXpofHtNW08l91UxDLXwExeo1IGFjPLD54ntz0W9DqK1DqMtWGzWIzaCTVsAcM2Mjlq/Ty5valRT8OLZY/5dX32hYaAYXogXD/DZzSPLgp3K7j0f3EU5F2tOMkj1+QSGOIPw7/OTnjvKrkZSVg5cybWeWpsXwrh2ASQx/KTystpt5683yhnokmTKD/hH1FT0BnErTao//JzqFYYgLqiXyhxchzJgkCS2WCuXECNZ41tazYX0qCLbzqm7F05HaWR7Bmsu0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

Add a PVMW_PGTABLE_CROSSSED flag that page_vma_mapped_walk() will set if
the page is mapped across page table boundary. Unlike other PVMW_*
flags, this one is result of page_vma_mapped_walk() and not set by the
caller.

folio_referenced_one() will use it detect if it safe to mlock the folio.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 include/linux/rmap.h | 5 +++++
 mm/page_vma_mapped.c | 1 +
 2 files changed, 6 insertions(+)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 6cd020eea37a..04797cea3205 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -928,6 +928,11 @@ struct page *make_device_exclusive(struct mm_struct *mm, unsigned long addr,
 /* Look for migration entries rather than present PTEs */
 #define PVMW_MIGRATION		(1 << 1)
 
+/* Result flags */
+
+/* The page is mapped across page boundary */
+#define PVMW_PGTABLE_CROSSSED	(1 << 16)
+
 struct page_vma_mapped_walk {
 	unsigned long pfn;
 	unsigned long nr_pages;
diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index e981a1a292d2..a184b88743c3 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -309,6 +309,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 				}
 				pte_unmap(pvmw->pte);
 				pvmw->pte = NULL;
+				pvmw->flags |= PVMW_PGTABLE_CROSSSED;
 				goto restart;
 			}
 			pvmw->pte++;
-- 
2.50.1


