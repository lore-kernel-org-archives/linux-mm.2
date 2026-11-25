Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68ACB606A326
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 08:43:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E83F6B093B; Wed, 25 Nov 2026 03:43:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 898886B093D; Wed, 25 Nov 2026 03:43:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AEBA6B093E; Wed, 25 Nov 2026 03:43:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 58A206B093B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 03:43:08 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4CD5F160D6D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:43:07 +0000 (UTC)
X-FDA: 85473001614.20.150EE1E
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7BBBD1C0005
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:43:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf18.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795596185;
	b=GRoCIVaYeF+EtNUYem3+4YQadheOOenoJa1lfiA3n4kP5Xh6DuuegMbILw91wTwzuF6ax0
	wYtRh+7vbpt5mDmjyM4Uam90ccaD6ePW/lHE+KCD3t7ejH/07w8+UcXWkzfXAO/SmkP9yE
	Ita8f+ID+TZnYlbgh6QWhd+NB8kMRN4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795596185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=1mOvzWhP6BsC2DveCsIqITs/FmHLNBNTXAMNKDO4qhw=;
	b=qZwmIRgUGnamMAP4S+CIngw7WD6Wq+MS6ucC9wvWpO5bLXsvINEqWnNBMMzwi/0IdnXY3h
	+CqHL2l2BJooEXCnowuR3Aoldlavjb6B1ZQyzdLUkNt7vhNGa6ledVEPKhoN1aN8NtVM1I
	t0LZxxIYED2PYNOQMW/UWMy0HZkckqc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf18.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7C2816732A; Wed, 25 Nov 2026 09:43:00 +0100 (CET)
Date: Wed, 25 Nov 2026 09:43:00 +0100
From: Christoph Hellwig <hch@lst.de>
To: willy@infradead.org, jack@suse.cz
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: what is the correct hugepage dependency for large pagecache folios
Message-ID: <20261125084300.GA23551@lst.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: ffy3jo7deax7r77n58yka5wf14ieoq9p
X-Rspamd-Queue-Id: 7BBBD1C0005
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795596185-297938
X-HE-Meta: U2FsdGVkX1+n0RWfceM9DTTMEIar6Gq7D4THDuDQjd/51/JmVXIieGe2jpTUXjDVl/5zhvMK/Qmbgs2ymwSYPvdVIrONlKlamhHuUFpbWnLAVSgie6pGtgjVdfn/CFhGGfTT3SaHe0VbvBR0e4iPs/9nB452cl/8valp2/mxt+fTYPeaRFrppR6T6zzgKnbQdlT6flPlEiHokp5uDomXr5DVJD8Fk+4/1MYLx5s/lQxqZds3fhtFmcxR41nO4b6uPw+FsEG+UwzOpZoT7cCaAVYUqdJLhSy4KeqO+kXLYYXIF0KIry/t3JKNyC/Tw9RqyTifAph+ayY7Q2dHmMZ562FbP0E8QaGG1s4xrgSIrNrvIkE5RfoBVkqO4j5sVNolJYgM9QVlTowv5AMTgBhOBmXAD5ZF1+p7PpBY9VLU2yU9ZlEjS5upSD2xRPs5JEfi6fiKYViEavPx84SOnk8UoUJVzrvpq8B9nufFcUqkath0FsQ5teJ7LX9o93yGoMq6x5iVnuCNEvcb9VeBn8bfH4BUvfpZ9iIL1mKvMLeojD61Gu2l3RzNFsCKl32R2L3uWnqk0re7beMCZbxBXFxlDzZ4zR/LQH/zBhHPbNi5tP/dVSwnYmIwByGMknM3CbLBLsX0C9JSW4GeYXxNkKDkiA3/t7luomuYfstMu3jBSpRz2KeBu3Ua0Wpm/7Icd717iQVhCbbS4BikIEOMuGZWcoFkubKytj7nIH9UlEOrXQ5T3HTDKVgrm6N8dX49mSq0K+Um2tVPVezLIUG9vQL7C+Q0oIUyElV0v7m7SEJGch13m+Kt5Y+/2ZeSQKTRjTUqDsrXpTmKDZ8zcwI4/mGRZIdT6zH9x0UqTieIiJq5KQPEHW7V5l76CKdj7D2V++Nxd8h0PYCr2AUVr4NghHu5wYYJWTdyQm7uQHhkEGT8OyJgvDeStHWuBs3x8SQraAJHyH7X6sF7PZ1jSqFNJWj
 5aQVFe3U
 bWX1zadd3qGMjFXAAMzHMZl3ag83IV9hNxVSpJ8cOsaO0G9BWwkmjUJKXRnwslFMWFMGrLAp+36D0jO1nH4Q1qA/MtdTo3CkF3E/FbPw7THYmTLPR0CTVm/XC8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi all,

we ran into an interesting cluster of issues with an LLM review for
the (not upstream submitted yet but public) xraid code.

The LLM complained that largest_zero_folio might only return a
PAGE_SIZE zero folio, and this can happen because either:

 - CONFIG_TRANSPARENT_HUGEPAGE is enabled by has_transparent_hugepage
   returns false
 - huge_zero_init can fail to allocate a PMD-sized huge folio even
   when transparent huge pages are supported and
   CONFIG_PERSISTENT_HUGE_ZERO_FOLIO is selected

This boils down to three interesting questions:

 1) should mapping_max_folio_size_supported check has_transparent_hugepage
    instead of CONFIG_TRANSPARENT_HUGEPAGE, or do all the required bits
    for large folios in the page work fine even if there is no hardware
    support for PMD-level or other mappings?
 2) should huge_zero_init aim to allocate a large zero folio even
    when has_transparent_hugepage returns true so that file systems
    can assume to have a file system-block sized zero folio?
 3) should we fail to boot if the allocation in huge_zero_init
    fails?

Note that only 1) really applies to the current upstream kernel as both
current users of largest_zero_folio can fall back to building bios
with multiple segments of zero_page, but for some of my pending code
that won't be as easy, so if we can't actually reliably get a common
zero folio of mapping_max_folio_size_supported we might have to allocate
a duplicate one in fs code.

