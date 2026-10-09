Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0642CCA9EBE
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 16:55:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E00F6B0092; Fri,  9 Oct 2026 12:55:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B7CB6B0096; Fri,  9 Oct 2026 12:55:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F9F26B0092; Fri,  9 Oct 2026 12:55:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1953E6B0092
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 12:55:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B4DAAA7FBE
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 16:55:27 +0000 (UTC)
X-FDA: 85303688694.04.DF31DD9
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id B7A0A140004
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 16:55:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Hk9gKhlv;
	spf=pass (imf23.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791564926;
	b=IJErJyIWX2Z9FnqON8x4RWYJglQk0ga3XhLmejTaIfL93KDFYvpJnUif5cvUYuTvr7vc/J
	x02N+6tOPJ2rYOcCLWJ+zYJKmbUhTv68/IdRyEuCVD6dp38TuY/ahzjVy4rr3F3FW5xjSm
	XFAY6kGg+bBZEvLVcRUCKLnsK7TYNco=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Hk9gKhlv;
	spf=pass (imf23.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791564926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=sJ0QLUJbB8GL4J29eH2wQvGHtd7BOI8S/MTobEfkKmI=;
	b=OYdwQ+zFzM7Rcq1GxIbCIYBZAoRUBKt82uZDgrPeFWYukcWDSlo4oh4CgYldMsuuSbg7iF
	5csGi3s50PrlPF/rJ2YNMhGviC6jrCEonFgPwdxFL8gnAZcc8a9ufqVbjzFiNoJnXEIBXW
	F7pPIYp5mIceV138ExGEXGZaLfqj/+E=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=sJ0QLUJbB8GL4J29eH2wQvGHtd7BOI8S/MTobEfkKmI=; b=Hk9gKhlv3kRasCsAQqRe9ihI/A
	tihmh+XcPPf5skvCU90zcg+vVoJCXAi/QawwTRCUO23Knxcym7+M3kx9zsxEhWQ0jqv5t15tIUWUT
	veqipLMPv61Z6I3c7Q95qO+NPL/fsIumgTzWL7ay9SUgkb8WNLw9Nq5k8PV94su4Vkdknj27czkxY
	nZTpB9XG1L9KYjD/28X6niwBR03olcMrpDbUXFOxsZ7avSspDS61xr3TBhywQlRO5ebzJw1tQP/ud
	uzWpr6ijEyUZmoBuSbvJJhL4avWYadCkzj29/odoaKNEgGnJC8dCKP7ACkkiTykKJMK8mEmHaa6AI
	gPpzB1cw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xFDsN-0000000GDDG-25Wb;
	Fri, 09 Oct 2026 16:55:19 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Daniel Palmer <daniel@thingy.jp>,
	Tal Zussman <tz2294@columbia.edu>,
	Lorenzo Stoakes <ljs@kernel.org>
Subject: [RFC PATCH 0/2] Removing add_to_page_cache_lru()
Date: Fri,  9 Oct 2026 17:55:10 +0100
Message-ID: <20261009165518.3863950-1-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: turk1s9ep9sfmu4gcgg5acbmpzfz7m15
X-Rspamd-Queue-Id: B7A0A140004
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791564924-759850
X-HE-Meta: U2FsdGVkX19/aKoZT/CKoEL2rSxn40udWXJXPg7hxfZoS2zego/6qlHuyZarxhNZpbh/6YY926sZuCqEkLoOUHdPg1bjZOY+tIQVliOG3vQHoy0X607I0gDPj/IEjt1eXrc11B+Jf1NMfMCXtFsxSNMxpOSOFRj4SeyGQ19y5ERw7gBERN7pQGCaNpxlFg3aB1VAFMleMVfzfcWoa4Y1sJR7KpTaNeb9I1B9dK7oNWDUakLXmUYVIWhW2JAFFznarnEkJ66MOXl7TXx2xVsou1ow/Oh87d2vaituy9JuHE3OJIgyEUuhSm1Wot5bZuD6FwfBtLRbdalNRAbaSaYSt9a8XXfAwJjH57JM2hkiTwspRbqj9fdYRXHZAO3skg/GTpv5LWwBH5iknf16jf+kVRlUYYe1+6NZp4dlVmNl0E8NiDRe1lq0MScRufoeB7KFN84rz9+HDxk41cc0v6Aymad0c4kJa/gBgsgms4uscvkYBiol8P0An3YinWB2vNIDEz7UdPOzCYfxDPezxaesAt/AJzIxlOxp8AgrUXzfPvBoSFDebaAzsRQTM+6KmMPhTcMU+mUCbmE43v5FecKnm7lqPIs2Y3B5P+ePCZyW/FJdPw172s9m8IUx8c/duJMSLs076pIYKMh3CAfnq2tjSXRqo1jwvTQX6dZ7EThk+da2hXo+pn195KQaEOnXE7GbezT2PA3+VesmHBkJLduWQMRaTC6YhGAWBw29XR+kEIpgbWA/a43okmpJywwzi4p2pgBqyYiIF7pdsPSb+bVXXXTgEsHrp4AJWbKE6VAkHdVexi2yvvm6q49BbpA2LaaMCSod+vRIXtkWSTRNS1CWLjA1zT2C77lGXbYYEp640E29+6kn0YOZEpGx2k14fGdSYmAI1BG936xcLbCMMCbJplGwF+QMff9YWp9tKqJqFgFQGyd5ekbaFwtl9j5xsqrG1D5+kbMpEdzMAUG9PzO
 SuXX1tbR
 iK3Vz2b4qLe6yzCysAkYnGXxGdBoZ+Ps6YgWI98EW9M8MyPgBbkux5jhbU8fiUPiL077B0w9NU2nlDQoDIGmrCCRO+bf7sjoB6eUI1MNdbOGqD6lrUhPLCxJEpzhZabck2MABSYV6xE3A1hU3IVmSD67tbl0NtJlLQ9uAde3tMuIg+zDL5g1BDfCaEg229WBLR9E3Fed1eu5HJZVA6hW4g3ibQCF5+p6298raj9vMvpQJNXs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If the build bots actually test NOMMU, they'll blow up on this.
I'm looking for human feedback on how best to proceed with removing
the last user of add_to_page_cache_lru().  Assuming that ramfs-nommu is
a useful tool to have around (and Daniel recently sent a patch to it,
so that seems like a good assumption).

Since there's no MMU, if we want to be able to mmap a file, we have to
allocate all the memory for the file contiguously.  Right now, we do
that by allocating a high-order, non-compound page, calling split_page()
and adding the resulting pages to the page cache one at a time.

This patch uses folio_split() instead.  This uses the generic
huge_memory code which will happily drop the pages which are past i_size.
Unfortunately, we currently have to select TRANSPARENT_HUGEPAGE on NOMMU
which feels really weird.

I have a patch to add CONFIG_LARGE_FOLIO, selected by TRANSPARENT_HUGEPAGE
and HUGETLBFS_PAGE, but it's buried in the hugetlb-hwpoisn patch series.
And it doesn't actually split apart the large folio code from the
THP code.  But it'd be a start, and we could finish that work off later.

What do people think?  Is that the right path forward?

Matthew Wilcox (Oracle) (2):
  ramfs: Use filemap_add_folio() on nommu systems
  mm: Remove add_to_page_cache_lru()

 fs/ramfs/file-nommu.c   | 53 +++++++++++++----------------------------
 include/linux/pagemap.h |  2 --
 mm/folio-compat.c       |  7 ------
 3 files changed, 17 insertions(+), 45 deletions(-)

-- 
2.47.3


