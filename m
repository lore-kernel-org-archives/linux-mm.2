Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B95A606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 11:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HRA702GZ
Received: by kanga.kvack.org (Postfix)
	id 46B296B05B7; Tue, 10 Nov 2026 06:24:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35CDC6B05B8; Tue, 10 Nov 2026 06:24:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1864B6B05B9; Tue, 10 Nov 2026 06:24:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E08046B05B7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:24:46 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 632B6C04FF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:24:46 +0000 (UTC)
X-FDA: 85418976972.17.D2AD791
Received: from mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf23.hostedemail.com (Postfix) with ESMTP id 75307140003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:24:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HRA702GZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794309884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xc/2Ec+isrnw7gxi44tzolJqOLCV74Dq//tFYw2pc30=;
	b=7thjGbxZ3n70i9FIAdvhsvXWxMTflaoIZT4VlbWs6giwrJzf4e+dy0MsVxIroAksHpEJgr
	fP3Dv64ImLVyA7EvkpEZt5dGo4Sxwk43H6UeMmgqwdqCwmlldatKZHix8BlR5WFSQowEtv
	jL/3RYYOqL5s9z2DP/fFrUHv9zq3ePI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794309884;
	b=ndwuRfHLsHbWKDd64ydPjJKbVPaFwTUj5jMGqaPi9NEm1/mLTaIyxD17utkNzocfXjcDRX
	XOuWtzKbSkcAu6reHEZ2IQwHz/vFmf+Hx24LWK49B1vjBrjwAWFjIJEvh8jbTIJ4GT15k1
	3eBm5LZYszaqUjxaZXsnZTDso4QhSuQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HRA702GZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=kYvyfDK0ROE4CNDauI9kgGxJwtog7X2zxAx8KX+EfBM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794309883; v=1; x=1794914683;
 b=HRA702GZnLe6rctJhDQuM+ozDS99Y6I83jb7m2Te53GS/hs2+bFIZ2s+2cVGJMwAK/Owan6N
 20o+OdmwXDveZmtlleLBldslCBbxqEGAILLWaDa9vd4MwMVxUAOiLKuGQOVdjKeCgfTjK8eDDjO
 cJ9wglN3lckVV9nThG0g6dh8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6c351c2373b5f8e3;
	Tue, 10 Nov 2026 11:24:42 +0000
X-Mizu-Trace-ID: 6c351c2373b5f8e3
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Uladzislau Rezki <urezki@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	Hao Ge <hao.ge@linux.dev>
Subject: [PATCH v4 3/9] mm/vmalloc: BUG_ON() on an unaligned range in vmap_range_noflush()
Date: Tue, 10 Nov 2026 19:25:40 +0800
Message-Id: <20261110112546.261415-4-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261110112546.261415-1-hao.ge@linux.dev>
References: <20261110112546.261415-1-hao.ge@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 79n6sncmdo75g8g5jaj71rreazfr4r9k
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 75307140003
X-HE-Tag: 1794309884-321138
X-HE-Meta: U2FsdGVkX19Ri2wk/1Al9hvf827XUcDcRztsB7iCzIe5MUTzCGnxIxZz0bfUNC+gIOoctN+SqIDLUBP4f8XQKrwLl1WhZ4RQSiPrY6Ts0AYPjEv9gFtz0imAXi45IUIpxCIdYDGL+s4NwZIEBgFCK2XjmUU1s7ZO/Mh9xE1tdptLwiK2O/dtfSkZqf+9o/oV/DQ3dysS2HEbwf87YlHrhrT+GbtfjAEAWRSmDFvQcxn7527qwtcSZ5D1SDL+nm/aK/au4tOZhsJ4Waq/YaiNT602PxGZGKF9getxBNGQ+twlAedrlMIIDKhMXdwKqIW1y8lPvh3iOLevWh2jTIYq11hZEy6MhrqjXOTNy7+wRttU/eIrTNqwwDQZDWbh4TTrZyWt5DEwGvuJmz/6nAxR3vfMKlcNu3AxJC66pHnipEkGsePdphQjHefmHL56dyPlpSE5Knmhcc3+TUA1mDoH9OlutPAgpTWuknEwrYPGiZtc5EztGLggzJuzKl+NRSbnc/2qxGIDJzpvJAGMwP+zhG2Xx82IBqb3NxIursOa53zaS62J7YdAeNLjpnbOlhyOJwB2ufc+jPePAUEIau1kFiGyeAdeJsfMYR4NokNqNq/o60OLU6uXIIX9W5zDusoO3s21ktMHBRBq7Gmd74YN5YhFpEyeYD3S+WvBk9pN5wDHVfLIcPQdOxSswZkM7ikOj+GueSxjoiU78RVOsrktSWVp26cs6983WEmllM4onMjGU2dS+IIMgldwCgiriV6sixxWLbLEOWrdBqX0yG+eXAj6eZmcokPv5g/5aDsMKfm8XxPmWJ7Da+VC9Cum2JwRElOgTQNxY3CBJHVGF750OGh08paraC/oqB6qZ7EJmNLQT9DuQY2NjSpWnYutxa2KoUxT3LdiR/3/BNYrxDA661Kny/LvdbnTiiOXgM+vFhEB4cKLZQfjkJJ+PV43+snc2sVG4LRagaeRvZKZXgK
 jJ43FkqT
 k+ZKYXdkiwJQ9L/ER4HN4SbBuQRsyUy+kRAhscAR0Fzv6abqtxWxvmmJoB27iVXkDWVAr+CkRofpWdvmgXmAswScqY7hxRyAfKJFWgZCv2gYNVZ+CH0geDAN0EwFEIidRFpilOzoSM0tCuB/+kET+70kVFt7SAgbOMvSQHU14AK8YWVO9eTURyV1EDZkrBJ1LGreNA8kplGW7d3/Rutw0925ZBtdgXDmaftrtGAWuD/O5SZ9ZHtu4E7T8223vU1afC04AZ5KXhVIHYeR4XqXDSklm73HAOINcfhkgi0JUkSPXAFO5utGzC2L4vVCp1Wd7Vv1Fu1Iy603FxCN0uwB3tKoF25BPIcOmXFfN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

commit a739e6b557af ("mm: vmalloc: WARN_ON if mapping size is not
PAGE_SIZE aligned") put the check in vmap_pte_range(), which is too
late, because the upper levels may already have installed page
tables for a range that is rejected anyway.

The pte loop maps whole pages and stops only when addr lands
exactly on end.  An unaligned end lets addr jump over it and the
loop keeps mapping past the range.  An unaligned start maps the
page below the range and usually misses end too.  Such a range is
never a legitimate request, and the corruption it leaves behind is
hard to attribute to the caller afterwards, so bug out on addr and
end at the entry of vmap_range_noflush() and drop the check from
vmap_pte_range().

Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 mm/vmalloc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 093b8d5f7b0e..27f2674a5556 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -125,9 +125,6 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 	unsigned long size;
 	unsigned int nr_pages;
 
-	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
-		return -EINVAL;
-
 	pfn = phys_addr >> PAGE_SHIFT;
 	pte = pte_alloc_kernel_track(pmd, addr, mask);
 	if (!pte)
@@ -347,6 +344,7 @@ static int vmap_range_noflush(unsigned long addr, unsigned long end,
 	 */
 	might_sleep();
 	BUG_ON(addr >= end);
+	BUG_ON(!PAGE_ALIGNED(addr) || !PAGE_ALIGNED(end));
 
 	start = addr;
 	pgd = pgd_offset_k(addr);
-- 
2.25.1


