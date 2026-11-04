Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C07A86070989
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 21:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=OF81ZidU
Received: by kanga.kvack.org (Postfix)
	id C3D0F6B00EF; Wed,  4 Nov 2026 16:52:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BED516B05B0; Wed,  4 Nov 2026 16:52:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B06916B05B1; Wed,  4 Nov 2026 16:52:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 88B886B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:52:52 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EF10C12077C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:52:51 +0000 (UTC)
X-FDA: 85398786942.03.E3E3B07
Received: from mta1.migadu.com (out-152.mta1.migadu.com [95.215.58.152])
	by imf16.hostedemail.com (Postfix) with ESMTP id B73A918000A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:52:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OF81ZidU;
	spf=pass (imf16.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.152 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793829170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EOQecW951XnrbiS/Up+TYLD26Kqi5K026ERWTR9xkgQ=;
	b=T0pKWZA25mO1NgbOY3s72ofWGYFsSZBe7qB6cqXdbMdEB3thHJ7xQ/mp7G6EA24qcP4lKm
	7cRv9NrWC8RIL+gjUST8QqdsTi1JmghLGSt93LkQSWiFIlGke8WvbefS59sgA0VoCdd01Q
	2inXd79ZgvnwOYakZFqX2BktVq6DQvg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793829170;
	b=s8hQOVJ0Zcnjx0rcm5JUoAc5dZUmLEK65fg+IFB8VJpaXHU11tfUAzymcOwSHtbAnIS1Cb
	fWebI/U26dNOpS8WpJOe5NmfpS8pQS9TACrQApkV1mZ/c6qkoCqobc8tvTmTb3Nsa2bv8f
	t7w11XZIf2itGfEIgO27kdMB1v+maDs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OF81ZidU;
	spf=pass (imf16.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.152 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=M0FIOF1DLHsXObG+kd/KQNs8mRLPiwWKZte8OxN1x/M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793829165; v=1; x=1794433965;
 b=OF81ZidU2OazYJbzq3ROQpcsIgzV2oGcgeat8EWG+HD53tZTNHiDcmJdrQUGflewUyYgRHz4
 1R8BabrS2n7vbRKru/nGRGVi5rptQU+plgxy2D+xfcX22cHaLBQ/szWS012nTzjQjvnqzrD7t+x
 rQCzw3Vpuu+uz3SzRusEMJ+Q=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id a0a1d10de7c52127;
	Wed, 04 Nov 2026 21:52:44 +0000
X-Mizu-Trace-ID: a0a1d10de7c52127
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Bradley Morgan <brads@mainlining.org>
Cc: Usama Arif <usama.arif@linux.dev>,
	akpm@linux-foundation.org,
	baoquan.he@linux.dev,
	david@kernel.org,
	hannes@cmpxchg.org,
	hbathini@linux.ibm.com,
	jbohac@suse.cz,
	kas@kernel.org,
	kernel-team@meta.com,
	kexec@lists.infradead.org,
	leitao@debian.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	riel@surriel.com,
	rppt@kernel.org,
	ruirui.yang@linux.dev,
	shakeel.butt@linux.dev
Subject: Re: [PATCH] crash: keep crashkernel C =?US-ASCII?Q?MA_pages_reserved_if_activation_fails?=
Date: Wed,  4 Nov 2026 13:52:36 -0800
Message-ID: <20261104215237.203332-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <661AFDEC-B8DF-4A5B-8C58-1D39F518F068@mainlining.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: pgujk31btwepgy56w79gaw1untymsyan
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: B73A918000A
X-Rspam-User: 
X-HE-Tag: 1793829166-793750
X-HE-Meta: U2FsdGVkX18FHJk58+Gyqc8yAuw2VgE1d9YzN+ZPUGxc8RPigz1C2E9yYSTxCoTb56rH9nSzAuBy361Hav4aqIlrf9+qQPYYXrBeTFDj9freQO3uFINWUCl6AyigUpoeCs3ibXys9LtXxsl3lv4AlNEl2SzpaRMzmz57s5m+HGEU5hinhoErA+2J6aMVN6mCo4DvAKS4WCO/ESvjIhopatDUwf7EtHpxA4KIWkROIAkIIHTOpvX9VKxbiWI7npeRAOhM1LZxuT4Xa180wL4RwKvkQwv1E0oFVW+WTvq1SkYvvLOWxYXyzWrbC05PdgQ34xwbKdSBFBUT8F0/i4/OFhq0cIVzDKpyyTHdca4QjUqIhl4vTbys9tmZt8mKT6QWL21hhzK/nbQ9QJ+y+iScP8MFhFedxLsf60nnlP5TARcZiOf6n9hwO/yjqF9ht+E1/Xg6Q+o9rKtDcb2ct9gaCAbeJzc2dljE5IJP4PKkCijrMAtn8VGo5D/rEpsEBYbFRilID6fjv85yDdHDojABZyzSNTMEDh5mosfujos7us09XiIz0fD3HonuBXNt2fp5Ejxn4s4HGT5anAt+d/mRI6ys8Ag/Dpu5iHt8TjdkrYVmIhTWXhkkI0Y1txgl3yoPJSx9KsVRWqYtValVTFnnFOkvw4TUHQJHRaFJZxfdqSEkj1s7pFC5jiDPnuGlwTZKtrXbDMGyKhq+EasPGdiSxxFow/tVhpW3ZvgfTfMGQJyA4w3i98CPdwErzaH4avAY03jIRwpnxChz22kjHnv4tLaUvKNToDF9ox0hZaqxtlyTSsAZjs1eCyd/BKoa9QJu6u2MzNoE5DadLJvdTxVBnxHIL7dhqOZ3Oy6RmG1F4ptPX0MduL/thurFLp2z4uO2Upo++vk2nopvZyCoqqmTMecIG5NuYE8vjPdWQo9cshXC0+YMjuwttGkK2z77wmyMCY523nq805AG7lkEEnX
 1xFqFIWL
 kFnFRmXmel2fnz8xohQRi2cUbEn8+NS8sxqxo9L3StPGB80gbHESop+KcrURgmWYFYJP2jcri04VoL7lb9CoP/e5KBT8mpCg1Y4Xg/a8yrsLunW7crPkOLSgOr3/dSQOW/ag7fX2TvDFhCXROdtyzgP/3GIOGQrkyfkbbUZNJD3gMuIeLWdMuh8vQX+Gjl9z0R6zpkumI1H46ku8HdSriYHDuwr08ONbZbETD+DYRZE5Al3DBi8zPeZYJh2uTgWi3onhxP9hiNf9Ohr2zFhZHoX152o12wiv3armaw12M7P9Ntd+ExO5/jm1wGfDWpqz12+KqdADsimUrvkCKbKDW4GEsNm4krqDriVer
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 04 Nov 2026 19:16:42 +0000 Bradley Morgan <brads@mainlining.org> wrote:

> On 4 November 2026 14:56:00 GMT, Usama Arif <usama.arif@linux.dev> wrote:
> >reserve_crashkernel_cma() adds each crashkernel CMA area to
> >crashk_cma_ranges[] as soon as it is declared. If the area later fails
> >activation, e.g. because movablecore= put the ZONE_MOVABLE boundary
> >inside it, cma_activate_area() releases the pages to the buddy allocator
> >as ordinary memory. The range is still handed to the crash kernel and
> >excluded from the vmcore, so kernel data that lands there is overwritten
> >by the crash kernel and missing from the dump.
> >
> >Mark the areas with cma_reserve_pages_on_error(), so that a failed
> >activation leaves the pages reserved: lost to the first kernel, but safe
> >for the crash kernel to use.
> >
> >Fixes: ab475510e042 ("kdump: implement reserve_crashkernel_cma")
> >Signed-off-by: Usama Arif <usama.arif@linux.dev>
> >---
> > kernel/crash_reserve.c | 1 +
> > 1 file changed, 1 insertion(+)
> >
> >diff --git a/kernel/crash_reserve.c b/kernel/crash_reserve.c
> >index a03f0a4305a4e..a4b616ed49482 100644
> >--- a/kernel/crash_reserve.c
> >+++ b/kernel/crash_reserve.c
> >@@ -498,6 +498,7 @@ void __init reserve_crashkernel_cma(unsigned long long cma_size)
> > 			continue;
> > 		}
> > 
> >+		cma_reserve_pages_on_error(res);
> 
> You do know that this will activate under every bitmap_zalloc() failure,
> right? Is that accounted for?

Yes, that's intended. By the time cma_activate_area() runs, the range is
already in crashk_cma_ranges[], so the crash kernel will use it no matter
why activation failed. Keeping the pages reserved is the only way to make
sure the first kernel has nothing there that gets overwritten or goes
missing from the vmcore; the area then behaves like a regular
crashkernel= reservation of the same size.

fadump made the same choice; it is what cma_reserve_pages_on_error() was
added for in commit 27d121d0ec6d ("mm/cma: provide option to opt out
from exposing pages on activation failure").

The bitmap is one bit per page (32 KiB per GiB with 4K pages) and is
allocated at core_initcall, so a failure there is very unlikely.

The alternative is to give the memory back and to drop the
range from crashk_cma_ranges[] when activation fails, leaving the crash
kernel with less memory than requested. I do think that is acceptable as
well. But we do need either whats done in this patch or give the memory
back. Happy to send the alternative as v2 is everyone thinks that the
better way forward.

> 
> > 		crashk_cma_ranges[crashk_cma_cnt].start = cma_get_base(res);
> > 		crashk_cma_ranges[crashk_cma_cnt].end =
> > 			crashk_cma_ranges[crashk_cma_cnt].start +
> >
> 
> --- Thanks!
> 

