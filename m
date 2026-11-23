Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D2F6606A321
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 16:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=gH1aRZct
Received: by kanga.kvack.org (Postfix)
	id 7E6526B05B6; Mon, 23 Nov 2026 11:33:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 796BB6B05C6; Mon, 23 Nov 2026 11:33:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 684CB6B05C7; Mon, 23 Nov 2026 11:33:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 400AC6B05B6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:33:18 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C12E7C0978
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:33:17 +0000 (UTC)
X-FDA: 85466928834.06.6A9E9ED
Received: from mta1.migadu.com (out-112.mta1.migadu.com [95.215.58.112])
	by imf24.hostedemail.com (Postfix) with ESMTP id CBC1C180010
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:33:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gH1aRZct;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.112 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795451596;
	b=VWKAyU8Gb+DoIA3dXWClgd/g16I0P6Ieqe498OsE3/guWwuhtWzjH0hfjrY1MOL9ofj5r+
	OX6Qj5C58LxCPIL/3ln+p/rpGod1tYR5Thjtdh6t76YwGdPiHC9polAdalakaYx577rGSn
	QQQa9BGOAeE37bXpuOsLPRKuvon0AXw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795451596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DhQbaSa0CfJ0wCyRhCBz64gdWankS2u2hv2CXXOomHI=;
	b=IlmSk7RSxNyvffCABQhMN+KytIISSX60p6UttfRpIiBKM+t98/ah2rv22NF5lLB6ViSkWV
	y4GZn26GCCHUwR50knX+TOLEprvxWPsq1xK7P4toeAVwLupxDxsM/Ohu1ylJtJ5MsCo4qR
	bfgAKhwAbUqj1TOGDOdz1Djjyvx+LGg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gH1aRZct;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.112 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=st7VKYLVy6A9Ld9OVqz5qlImi+UrV4Mo/my8tn0Ta8c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795451594; v=1; x=1796056394;
 b=gH1aRZcthwWczpHGDLSIGLIEZ46YNc5kHsOggWrOPKYqDwNY8zkGF1CF1LTKLhPzHxFFlfj9
 pI/fHM/b+Xvck/0HtodsKm2FudE3TTDqOnJoPb3zIrIJLdcrJup+W/QqWssjpY8CLvWrep4dr9i
 4MkF2vSkSqbaLXqiOmVBA/vE=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 8a75eed899b12e5e;
	Mon, 23 Nov 2026 16:33:14 +0000
X-Mizu-Trace-ID: 8a75eed899b12e5e
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	apopple@nvidia.com,
	byungchul@sk.com,
	david@kernel.org,
	gourry@gourry.net,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	liam@infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	matthew.brost@intel.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	kas@kernel.org,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kernel-team@meta.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: Usama Arif <usama.arif@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v3 2/5] mm: don't PTE-batch a swap-in of a folio with a hardware-poisoned page
Date: Mon, 23 Nov 2026 08:32:08 -0800
Message-ID: <20261123163301.1568240-3-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261123163301.1568240-1-usama.arif@linux.dev>
References: <20261123163301.1568240-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CBC1C180010
X-Stat-Signature: en6eyfo8wkdh8a3r8sp54iurjjoqmptj
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795451595-134547
X-HE-Meta: U2FsdGVkX1+xAcuEJmJy9HhFArdLOT7him6d/1a1pZfUaT3MmigrUWslyZa9+wHDqlJM2LrkwU0I3q2rxbjYy8nIp334iIBoHySxTk6C+m0XnOydW/c/2j2YKuiRk1U0Hoa66hZcomaoOnxneOOBC3We73i0ecLWxgHMv/NJ4kNJdX36EqSBRfaYMWpRhxIo1n2spd1bPRFUFLzTD6+sFVNzg230E4jnWS4jXZ4lbkhhuMKMkb5T+Ynt/S3dEYJyhzzTHeJ39FZ/xkNmVtRdv297ZVnHujHBAoiYZ4PmB8KwTSwOhcHM1q+gUPFw6QiW/b2I3FEvogapIzXzwSb9G83Nmyhpo5uogImVCDU3MqOiQPbiBQyQakJWtc6UA+tp8gV4aFBJb3Mf3X0ZtOO22O/SV78Gojg0x/GzJaXPNOg8sBnSQrIyYw5fVu/M3FN/wj6yPEm1vXuDVcB/kKdSeaW4wFZ4C0nnXST+6Y2WxMFS0rfLqJNUpPafPlXhZeUv96psCoODFLUqMNsuCeJZB0GPaeQfROnxycls76K6eq7JfG4jEbzcyyXxEoj7RB5B4+Q6v5SDAgNmwa4AVktn3syLNF6ag/LBp8br2G4+WptcyEIPRfcJQ9573wD1iWkWeB52U2olnY7VjY+ARoMbb6SUTNsKI8ro5+8JgT/ClrP6IQbMnz5fC+3BA3ro+XEO62w+lHXBL6Xw++V7wI5bQmnQRl2k94BP49pG+87u7fRy+s+R8WFu++hMXXk/8wbfkdWRqqlOUWpyI1kZPJ1Y4wioj7gJTkjecvHtUUfbgP2SpsmnC3Mg3rtdgJqUWH3TaaA/L6GlXIDSjn8DpnD90uXoPiHRO0/r58A1WmRKSWyB2KqPrMBNKnk8hItrAvLozlyrD153YSHzlpiwtnb19W52DLDGuKLov7Z/lLQEedM4rKkl3VMVbDwDNVnqWwqn/g7QfjUsPSm1WTlGUJT
 03M73JbI
 cZqylS5JqR2RQQ/glkR4AkubSs/dr4mV7ELY9fTpsnhuL8QOgr2CqDnONq8/19fWbeswvRR2dtdGANWf+WAymHbhNmT6cMZOjZWIisBUZ+cVvm3INIpa5O//firjtIdDS2ZFW2NHSZbL1nJy4yc1XIndJ/WnmNwX0lr4s6KglT/Fm2HCjQH7Uqvbr/Wq0y3KqRtBy3hoWu0+qSIft3iBcWcBS8AtmDDoKbx2HTgWvaCKMVQL4lGCLQTSB9840pjK8tCjbDRGidZPtJnRAw0+2RMmSZxg1NNydzKQFVQ2olBj2p4gLWPvd3Z/xrhAyyob+py4k/CM6uk/OKPn6jOVNao9KNvIXr/igrG+QRKzs8GbJO0/oCcJgdxTVjEX/6tRO05mYMmGw2OytqaR85ecb/3zETAu+E1HRmSgTE4uSES/8OVXy7pqsfHyO7VSpBXH69vofGhoBiix/YhGO8JcrdxkmZmmKcrfOWLsg6lus44artHal6tgG3T3MVj3+VGgCVx1u6lnjWTtpluQmhpsLyCHMrSqLFi6kpuFodOzaZ4BqG7AhBCJA1bWfbPO7DmomU7/Qz3zss3gcX4U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

do_swap_page() checks PageHWPoison() on the faulting page, but the
large-folio batching path then maps the rest of the folio without
looking at its other pages. A poisoned page that is not the one being
faulted gets mapped anyway, and the fault that would have reported it
never happens.

Skip batching for such an anon folio and let each page take its own
fault, where the existing check catches it. do_set_pmd() already backs
off the same way.

Leave a freshly read folio alone: it is not anon yet and can only be
mapped as a whole, and falling back would free it with the poisoned
page still in it, which the retried fault can then get back from the
page allocator.

Fixes: 508758960b8d ("mm: swap: entirely map large folios found in swapcache")
Cc: stable@vger.kernel.org
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/memory.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index 282266dd5e5dfa..d7b200e00bce17 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5194,6 +5194,11 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		pte_t *folio_ptep;
 		pte_t folio_pte;
 
+		/* A poisoned page in the folio must take its own fault. */
+		if (folio_test_anon(folio) &&
+		    folio_contain_hwpoisoned_page(folio))
+			goto check_folio;
+
 		folio_pte_range(folio, vma, address, idx, &folio_start,
 				&folio_end);
 		if (unlikely((folio_end - folio_start) >> PAGE_SHIFT != nr))
-- 
2.53.1-Meta


