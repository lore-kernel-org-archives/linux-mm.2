Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BAE5CD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 21:06:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE8E96B0005; Mon,  8 Jun 2026 17:06:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B78DF6B008C; Mon,  8 Jun 2026 17:06:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A134C6B008A; Mon,  8 Jun 2026 17:06:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 950486B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 17:06:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4473D8CAC9
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:06:24 +0000 (UTC)
X-FDA: 84857978688.01.4CBB302
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id 68136C0007
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:06:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZP8cNywy;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf10.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780952782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=D4t056VLnliANpP3l47/phb+n9DgzAiJw8SOlskV6Ns=;
	b=M1nzAiNXMcaL3fSFiX6xfjQVZLzRqM19m7cNzyNcxRMYAnhwYtSfXuIovOfvHeaT+CJQYu
	53x1Q2Md8TGKLtNzCK2JQmU3m4JYcfYvANLvfmIMLUtKonD4lHVuwRdt7jg995LbUWmwYv
	HqPAsSGeIlNascNkLhhpZ5areMGWuoc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZP8cNywy;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf10.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780952782;
	b=d7GiOskmicPudMwgauILu3Fa4U6bZVhBe87BHBGKF91h9RGVXscEdBDV+8TvdZ8rhi4r2D
	O9Gk51bAf1LvY/2gVD3ddWt+w0j58z4qEr+qq+rJqFSfHwZlTI12uV/TSKC5BDGY+Ac5LQ
	qaTjE5suj3GrNdPZgVYZyrKPhfuuhDw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=D4t056VLnliANpP3l47/phb+n9DgzAiJw8SOlskV6Ns=; b=ZP8cNywyK+sLDCL0Lxu9wRkD31
	ly+PrnGJBy7xkRS1rFbf5NJoA6OmNY6xSyYRFunQUOXTc28IicjV07/ExWmRwTg2DqpcLyGiJT+Uc
	ke6cb6av7IPmyt1yYJeh9Ooadte5Awb2yN7RPCuoIZI//OQ/4I5b/gYxId5reRwlbibOyyMBp3S28
	515GKp6LWasunYOj147KPoy845NEBit3+2AZfmFE8M4s29cAdvM4HIk+9bneML6lvA3f0ZNLpJky9
	a9OqKflM6KGv5HkRWZNmmqSh4rm6E4rjgMbECWUujNuv21C/gxDwJMgrVQqUBcYAxg9mw4mzYG2HH
	4kDD1aBQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wWhAq-0000000EQB8-0mZs;
	Mon, 08 Jun 2026 21:06:20 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 0/6] Remove __folio_index again
Date: Mon,  8 Jun 2026 22:06:10 +0100
Message-ID: <20260608210618.3437216-1-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 68136C0007
X-Stat-Signature: k4huc7gh8c8xthw187fzpf8nnamk4x17
X-HE-Tag: 1780952782-378023
X-HE-Meta: U2FsdGVkX18x3vEJN1XXMEcY51NpaMFrmsnN98ynJl9kxkWGLXJxEgJS52KTD3mihS2FrSVD8Uu6R66EESo3F5JjnrZZYuFdDVxkAplh8v1lzG92wEAYNpaqzkob1bw+Vr0M3Wu49HFCTsZOcgeyK+JRNvwdYtONh/igJKn2DBPWeLF7VGVUIko/eDKEYSbZqr1pNfV5MqcODGKXPy/a801MzaWXm5j5xrXQC6h+azG5z47/4ZB2mLr3qym1sBYrrC4FVK7S99kYBlnpdBhY5akU0tStfYK4o86S14cdanjq2EavGDCK2k96gFLS9OvWKvMQUAzNNVV5Gx6Jdkp2QZD3r28ye6ts27UnfcDgeczev8qLH4bNG8Ibt0cVhYrxL4osSiwalB2io7UyFFyQYBDLEnehyCOvvg26q0uLBuxPNbwYRU7kTLUhkItuGdRCcFPW2XGhQvyblo76zjTKJguDvF8ghff9ypbU3LcdZwwrhFdevH16iWPyA1BUFvNgsPKe5tclFz6omECuXIls8ei31Izs7AlEiFcKJ6TWO8xswPr4GOiBMvtIa+Ntv4H8e0jGEFslYsZ9kD/puM+ejYDfTJL5JkRoPMbw8zHH525iRjkqSwtfzCG41bTi5layaxJ0SrNcRqVquPMlQkXwbnhfW7gIHqBdW3p+LkVYxLhLmo1URNxyGl6cs142BAh1E03sTlXqMrNmio35B9dun7Sjl9ENwq1jS1956IlYcyFgEhGo0hb0E+Vhk8/EBFs9WVTTK2BWi2vQVlb4eDCatsaOMfv/f5JKgD+lBI2sFYvT8CLnZ+/yHx1gRaRpyszFg8AUK8eSchePqFYXVHGM5NwR9axK74k1csL3qben2m3hDincurZ9gsPqXNo9HFJImWLOFbDs3tNIIP3jZ3CLNUj6p2V6kCR4yrUjhoFyRnqs3UPLCc3NXfhYAdb4RvgVnvx/Du5iFTqEzJZFwdy
 xw9gVrqV
 rDjYfvbeyDpCwH/VBdqswo+FER7SJICW+LCEr3ybbXHDYem9i/5xvI05U3LK1w0+3v9t6xVlC1CKtf/ecPfc+vR6ciFRtqaxSAW82uESgEuV273MV3LBxyIL8AX4E+YI3Mg557M1aW0Itw/t9z/GLHWReP1KvjwKCwUKZDFRpfPB2O1RA0cymeAji+S7hWWuUAeuvVIb35QCn5B1rjOgCkOH3WWwcPEAYFU7p753VpeVOw+kDUhClpkl+AreVN5167/y3jqU6L7bOf3A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I renamed page->index to page->__folio_index a year ago.  That proved to
be insufficient to prevent people from using it, so take more extreme
measures to make it inaccessible except through struct folio.

v2:
 - Split patch 1 into patches 1-3
 - Remove inversion of the i_size condition
 - Use page_offset() instead of page_pgoff()
 - Preserve the call to flush_dcache_page() in all circumstances
 - Use offset_in_page() instead of open-coding it
 - Remove shadowing definition of struct folio in patch 4
 - Delete the printing of page->index in show_page_info.py
 - Unname the padding where folio stores index instead of trying to
   create an unguessable name (Arnd)
 - Justify removal of page->share in patch 6

Matthew Wilcox (Oracle) (6):
  ntfs: Inline zero_partial_compressed_page()
  ntfs: Remove use of __folio_index in handle_bounds_compressed_page()
  ntfs: Use zero_user_segment() in handle_bounds_compressed_page()
  ntfs: Remove references to page->__folio_index
  show_page_info: Remove printing of page index
  mm: Remove __folio_index

 fs/ntfs/compress.c         | 53 ++++++++++++++++----------------------
 include/linux/mm_types.h   |  7 +----
 mm/zpdesc.h                |  2 --
 tools/mm/show_page_info.py |  1 -
 4 files changed, 23 insertions(+), 40 deletions(-)

-- 
2.47.3


