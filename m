Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CF1F606A323
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 05:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=ZPbGqmMX
Received: by kanga.kvack.org (Postfix)
	id AE76A6B05B2; Thu, 12 Nov 2026 00:14:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABF326B05B3; Thu, 12 Nov 2026 00:14:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AE8A6B05B4; Thu, 12 Nov 2026 00:14:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 714466B05B2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:14:58 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 68F0814042A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:14:57 +0000 (UTC)
X-FDA: 85425302634.01.D2E2BEB
Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	by imf05.hostedemail.com (Postfix) with ESMTP id 38DFA100003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:14:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=ZPbGqmMX;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf05.hostedemail.com: domain of "prvs=76985aab9=farbere@amazon.com" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=76985aab9=farbere@amazon.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794460495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M4/2JvgJOG5HlY3nX1goOy1ausz+pub3HY5HFXA2L+4=;
	b=lx2ygrpv9PQQKOTDxAG/dmSu6bbKjUsc9fFZYQ6LCeCEJCJ6b5bVDw/5Iq2m49TH08F4GP
	J9ZHMqrE+0av+SbMcOP8h0mhFOl/BzS37eFhQqempKEbp5jvNf6n0yiUKFBxYis5RtcfPB
	rwyw/pKXpZ3fk2eoVwmcnSoKBNx+AeE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=ZPbGqmMX;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf05.hostedemail.com: domain of "prvs=76985aab9=farbere@amazon.com" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=76985aab9=farbere@amazon.com"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794460495;
	b=2J4xsqt6UT9Pe3BtC+Wz9AFN0+UYiYfIHwYjqv0OkBMsdiTMWXvZ691kqU1zchHTp37qd7
	BRElM2z/tSn43ijV+cTnQEUTholmhec9vYhMevmqG3UeTUnBB7J4M2aqrWBAtV/tDdZQDS
	NJVCPG4SZCjk1PDRLbBVk+voh7gRKmY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794460495; x=1825996495;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M4/2JvgJOG5HlY3nX1goOy1ausz+pub3HY5HFXA2L+4=;
  b=ZPbGqmMXF8LEKMBHr6iOQ/Nhi1+e2B2m90WZbgQLPj+3NssslD3ON7iw
   q2mN3feADKMzGmpGF/blSixCouKkcL6+Ov+N90nY/ownsyNeCBY0szx8+
   AA7Nz3ZtFuB5yZf8klDPZD9cxiYbjp8M/acqSfHlzTtwsEpPgrgh77COA
   3i7hewNqzKBiIwxozlUdiMLUuUr/NaBFoq+8NBBdadp/RsfeLD+Z5xsEv
   f3vK3tduT42CM1iz1+hyZwZqlkSTBVzitCxm4hjhCNjs6zeqWTmM/6seH
   h2u/E4tpZgvHlC9KikA/u4Rks/h6LZgG+Qvfmn+ieHcOPH/nEeUcGtYCB
   g==;
X-CSE-ConnectionGUID: WnvE7toySZ69JPTZ+ZyMFw==
X-CSE-MsgGUID: Xlb5CAEcQrKeT6sdCXy/2g==
X-IronPort-AV: E=Sophos;i="6.27,209,1787011200"; 
   d="scan'208";a="33759945"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 05:14:54 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:12731]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.50.212:2525] with esmtp (Farcaster)
 id d97f51c0-ccc4-46f3-b7a8-86dc99864a2b; Thu, 12 Nov 2026 05:14:53 +0000 (UTC)
X-Farcaster-Flow-ID: d97f51c0-ccc4-46f3-b7a8-86dc99864a2b
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Thu, 12 Nov 2026 05:14:53 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Thu, 12 Nov 2026
 05:14:49 +0000
From: Eliav Farber <farbere@amazon.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Zi Yan <ziy@nvidia.com>
CC: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Baolin
 Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>,
	"Ryan Roberts" <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry
 Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
	<usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner
	<tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin"
	<hpa@zytor.com>, <x86@kernel.org>, William Kucharski
	<william.kucharski@linux.dev>, Vishal Moola <vishal.moola@gmail.com>, "Alex
 Williamson" <alex@shazbot.org>, Matthew Wilcox <willy@infradead.org>, Peter
 Xu <peterx@redhat.com>, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Eliav Farber
	<farbere@amazon.com>
Subject: [PATCH v2 1/4] mm: drop the huge PMD assertion from walk_to_pmd()
Date: Thu, 12 Nov 2026 05:14:37 +0000
Message-ID: <20261112051440.16140-2-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261112051440.16140-1-farbere@amazon.com>
References: <20261112051440.16140-1-farbere@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC001.ant.amazon.com (10.13.139.241) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 38DFA100003
X-Stat-Signature: ph8x568z4tsg6efrxc4apiouyprzegjh
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794460494-218882
X-HE-Meta: U2FsdGVkX18jP9yj3Wc5bAhaRNxAmztI7OQnubuYmbZOe1pzTvKFw5zt9HgiT4jZ5ErI385wDGGbtYUqliOUBCgeyHBKJYP/v8hnpYePklexgRO6F8OgHNTPMl8+IXMAwiRJpy8b5+sagTJZPwOKqKUamGcir4g4GTI7tCticwZHJtyks7xECws00/q+9KfMM1jErTRKz6X/FAXoT+RKQ+KRqTXEhtxtQr1qgven0E+M/t7y08eoifidVnB/xDfAEiw5ZepyDbsBfeuzBdxtAKMnvJ99en27gpsnnRVEY230l/DC86LBUmneTKLW//g4E+kYvMAPoG5Mu4W8mpRhGTwSVDiJ0gVajmle/2QFRukIEdrAmK0/vJeYZLj0T6uH/wOa8NQbTPCagYVVyaFn9h1cCgVBrzgc0hOxhOkeLBLBrJ8zivx6gUF77IMVG4C+nfhyUA1/TSvsC8wNxIHq31wmVvlNVR5vmUZBQqYT+4pEdF/gfLybylIsDl8JfvARSqcogfaWwcXEnNaAl23B3cQ4dkQYtRJlDEK8WUBMaoXm/IcrNEG/2bbXDuIkjzj+A4WLxC9yFuNIVXF1ABeV444ZHl0PU0ECjXVe7d9zIXMzyZjgLq5q4gIB2vfDXVPjkPTAhKxMLZxx9UQcEuB5OzfZxp/13PV3iyxbmN0Y3Ln7RNg/BGg9guzWIdI942Mkt+By/rhqnrXj8W3wOylgsKLb4uGzJjWZ+rGUJTDLf/Q+JaxIjQBLoIWWywPwi7sAkT34K/PGdOZ2I468zWyrI8j7bba7fWvZqHqB3GYblAI2LnD4LiXci9OXem9knc4AjJNonrWUrW/IZxRk+Dbe+LGA5RslI41eeKtzduMSe3jaS/UKbbUBKryFFTYyhomJ9VWiC+qtHqNjOVn7bKROsO7fFUDMS1tYrvEaA7kfSzBzbXBADw/zno1DdjscuCkKKygR5mdH+gX4itFeeQh
 XtuVM8gn
 og/pDakK4E4pz+jEcLxgah7ObLV6xHgBq40EGo4bNJwd49KhiBwJBkwkLC+X5PqnQAsLJmEBLlbMzquLVNFA5CMo5k2D4Z8FR3s2T0kf9m9EFHBmEx/VpntKI4xRo78ioTxjH92r0ye50EPLPd0RahUA/0x4ZhUiwwDQznCSL9dShf2qNTKTLb3RV+L5+uqGUnw/52tQ/eGGu3NAi2eaceVjkDBqDKEaYkH2jgh5hw3JbFeMGRnxiyx3WykWVb9QOUznUAb8mT3RxbdGPRc89boFNF837vDGpUNtWH5DyJdMb6DaEQl2xjEwYJHScQ2t51YMDXaAnrQAIAxen1272GxLTbYBOMdOiJ1/Hl5+eDCO8sqFTWM6dAE86hzN+9ta5PFvyTG3tl66CEhUU1IIJ+0DJw/KeCMsummwdXndW4FWKFuO+5ECenmhULkM+jjgY87vYZn2qowiMFK9WjHhNQLHawH9pEJo1O10upMV3rlL/C+u7KOAMT0XFDlJQliR+QvZTsfr3QXpaa9ahAROm2tHTCv0n/OVCH/nCVKS6vviBXkNvMjXlAWAoQ6gY1Q5vZkrSgGHUpwgIAtqIkv8l/HQx9lgHLegld3aTasvNRtZjLmdS7vpFQqYRIt8Z1/e2GNkuzfD+WdJCFHLV2axXxzOgQRca/DjgZvAqerLTyEhjWSTTbPJ+VALKTdXUuYzm/IdZAz0PCLcCoBKGpUGWXb90EpwMW46KVRD0WhV2tblnGTTowUMGk+Cc+ATCto1jS6bh4HJEnngTv+PsMwLGJBAP6ZlE/uK73Gc9aAcbMwaLxYiNfv/l6cGpZMzU4MAv486NTTGo+ThY6PuT9QTejhgRF7oIO0iwOAqr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

walk_to_pmd() asserts that the PMD it returns is not a huge entry. That
held when commit c2febafc6773 ("mm: convert generic code to 5-level
paging") added the assertion: nothing installed a huge PMD over the
mappings its callers walk.

ARCH_SUPPORTS_HUGE_PFNMAP changed that. A VM_PFNMAP mapping whose driver
provides both ->fault and ->huge_fault can have a PMD leaf installed by a
concurrent huge fault over the same address, so a caller can observe one
and BUG on CONFIG_DEBUG_VM=y.

The walk does not need the invariant. pmd_alloc() only allocates when the
PUD is empty and otherwise returns pmd_offset(), so a leaf is returned
rather than overwritten. Every caller already copes with one, because
they all reach pte_offset_map_lock(), which refuses to walk a leaf and
returns NULL: insert_pages() turns that into -EFAULT, get_locked_pte()
passes the NULL to its callers, and insert_pfn() returns a fault code.

Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
Signed-off-by: Eliav Farber <farbere@amazon.com>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
 mm/memory.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index ec3d9d99ccee..0f54ee0a6d88 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2384,7 +2384,6 @@ static pmd_t *walk_to_pmd(struct mm_struct *mm, unsigned long addr)
 	if (!pmd)
 		return NULL;
 
-	VM_BUG_ON(pmd_trans_huge(*pmd));
 	return pmd;
 }
 
-- 
2.47.3


