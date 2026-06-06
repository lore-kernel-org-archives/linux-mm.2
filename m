Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90972CD6E55
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 03:50:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B3586B0005; Fri,  5 Jun 2026 23:50:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2687E6B0092; Fri,  5 Jun 2026 23:50:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B5806B0005; Fri,  5 Jun 2026 23:50:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E96246B008C
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 23:50:37 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8B9B51A0349
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 03:50:37 +0000 (UTC)
X-FDA: 84848110914.29.3E50234
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf22.hostedemail.com (Postfix) with ESMTP id 886AFC0009
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 03:50:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=huQW4xxB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=f+E3cFfL;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=huQW4xxB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=f+E3cFfL;
	spf=pass (imf22.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780717835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gILGC54YllDJCaWwgWBdRVH7kRRphrRc85OeaLBmt3c=;
	b=F5kx8c+Jk2n602OdeEUbTNQUCXPezXSx6A42OpJ6R1qxten8SwdJ7v9E/Qrclg06cUH+wB
	TGsbT/1/dYvzddEZ20OQZEM1S0FcQfn+jEy00hfFNyOHFkeT3C7Lip6HHXSsbj/AEWn8M0
	dXgVEB6+Ff9dtwOCjSwmJHQOEBsCKHU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=huQW4xxB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=f+E3cFfL;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=huQW4xxB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=f+E3cFfL;
	spf=pass (imf22.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780717835;
	b=fGX4AbF0x7DVsGrEHfN0VeGpARD35/MPCcRGXmFReaabc3Y+2UCJIvYWPz3Z8wqFZNqBNm
	Koit3MWGCZIA+YbhkNkT8VDu6MS7Wg+bLK9hW7aQztQy4oFSCZjagYTmfELDCba1jbGZwf
	r0ObWRqgGa+9Y2JvEjdJdCQA+irYZXg=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3B4326B341;
	Sat,  6 Jun 2026 03:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780717834; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gILGC54YllDJCaWwgWBdRVH7kRRphrRc85OeaLBmt3c=;
	b=huQW4xxBTIAxaRXB6trlcWTcgaUaAaV9BXoNXC+qlzO0FoFjGyfQQWHzIVbiy93Z+plCnf
	DC96+q3GgcTW2J/zwWxNju9i6sfu/aUpgFJAwnTL962qUUdstWzfq3pTKH7PY8Y/7/Qijy
	hCPoM9wwt81oTTeAUBV3By1P2t7DkuQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780717834;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gILGC54YllDJCaWwgWBdRVH7kRRphrRc85OeaLBmt3c=;
	b=f+E3cFfL/kX2m7aCDvhoFJLgaOw6mhwc28JiYQ9htfE6abNmw+UhbGaDSWGtoDhzCVdosz
	krxUmuMFyIz9vlDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780717834; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gILGC54YllDJCaWwgWBdRVH7kRRphrRc85OeaLBmt3c=;
	b=huQW4xxBTIAxaRXB6trlcWTcgaUaAaV9BXoNXC+qlzO0FoFjGyfQQWHzIVbiy93Z+plCnf
	DC96+q3GgcTW2J/zwWxNju9i6sfu/aUpgFJAwnTL962qUUdstWzfq3pTKH7PY8Y/7/Qijy
	hCPoM9wwt81oTTeAUBV3By1P2t7DkuQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780717834;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gILGC54YllDJCaWwgWBdRVH7kRRphrRc85OeaLBmt3c=;
	b=f+E3cFfL/kX2m7aCDvhoFJLgaOw6mhwc28JiYQ9htfE6abNmw+UhbGaDSWGtoDhzCVdosz
	krxUmuMFyIz9vlDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5B7EE779A9;
	Sat,  6 Jun 2026 03:50:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KIiMEwmZI2poQwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Sat, 06 Jun 2026 03:50:33 +0000
From: Oscar Salvador <osalvador@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Karsten Desler <kdesler@soohrt.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Andreas Larsson <andreas@gaisler.com>,
	"David S . Miller" <davem@davemloft.net>,
	Huacai Chen <chenhuacai@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Oscar Salvador <osalvador@suse.de>
Subject: [PATCH 1/8] mm,hugetlb: Encode extra padding for aligning directly in hugetlb_get_unmapped_area
Date: Sat,  6 Jun 2026 05:49:56 +0200
Message-ID: <20260606035003.529685-2-osalvador@suse.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260606035003.529685-1-osalvador@suse.de>
References: <20260606035003.529685-1-osalvador@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 886AFC0009
X-Stat-Signature: 4ooim46en31k3jj9yum1hnrmt9q8sm53
X-Rspam-User: 
X-HE-Tag: 1780717835-764195
X-HE-Meta: U2FsdGVkX1/keU8AUtyNmX5hsp+GGkG7fSGp4gs9xmI6JQObF9QN4dtq7UsWxDulK/kAqCR63F+37hyuRjjyv8aAHeyEFHBlouhFVLQS5EVEG/oqEu8XynN/i1KC2nS/PCo9BzTYCy76jFT4jGM7dMS1cFG/Y4lioK/ngTRpaXPNYZu2+KAKkoJqIslMXrvd73WiBDbK+QN6b8eaA1xDwqnlCppFiHfYWdsYm3pP8BdsduHJQgM1+c3Hw+tmJux/EgTUecfDDOdbYZe+RO4PAOrQeQTgr+5r3OMq+EfrLjUDh3AbfkgMmD0w0feu07m4mCjql0Y3cC9G87KOcg2RbcLNhcw4kPAqeyqI5HlK0diUhAo0NqCzGCmnqpVBGWLtwoh8UfW7c/UBSsVaEOg57CmyhZBedNmI5zY+3QcvkvUCyOgRB0a8pQcBq9xAOrSTKmI4aTXNYv49f7XsEyynhPDOJQC9BMiqVp1eoIfrkQpGTz3leoZpbDpGgVnm6pixf22ZVulOuobeadPy3ju3F6/P6t2X6VRJEmSV+SkZJDHGGOZ5d3Z49ih6fIuTPA3VEGF4JjDMKYX5s3ccy7Zc3WB5NIfzb6CcyygCa/AGw2crgwBCBDbUtplzLJSOnoezUBFdnORsTbSI0xHL9k7BPtC/ZZyAwo5whtzVWU4+0IVcrt3IW1z/TJKgsSY+Gs8sn0gMR2QpkT7lllEgnOgvD5FJB5RiVJZn8Pon7GqrHJwClJbEfNu5onif7GuV3Djk1T7Kujj/o+UNXQDE7OtO/KbycxM1THe4LzG/Yt04+tniO20OTwHHbVkivlyQb5SEj0VmrKgJC5p9+8X8XspYA3HG6y1F9sO7jmDWz2t3wMqUopBm19LjuWlAcK6HPbFBdGLlMTxlga6oCSGgWxZZcuiCQf7t72nN1zQZJxTYyFyaPb0+WZ8UL11Nnm/Uze//pqg7H+Ee+QNxb1kFhan
 /njPKwx7
 +GV3QxkGoYGM+3kgeXJQkCKo18srfrsbRKh3stVFCP99BwHcjtsQznNcooaIDoTm3OFBIQYHufQRHYRnZsWIRAQF0oFZwBpQafm87ofJb7JTgNPh6zDeDhMc+Z84i4RGaDzl4E9eP6Qohvk2c9ceh+niMcT4Dv4kSu2qnEFLrdCKltSis9LC36qfrpZfYTg0MGWwQT7yGdqQDtP58WpVQAb6nwCDTNEwzgtLPw+eGtbhffIAdbSPxJUsNhvIC1Re3ENH29SJOiSx3CneIPuqhhQUbnmXyJP5EsdMeFrSUZWpBk2FOCW5Znyu1kjiLSy7VWfjCc3mnSPnqYsOaEZt9UKreWKpXin6M8Lrb3Zn6AOwjRtmKapzqNzNLYc71+QmcPgeCKLhtfbfj+A1Egh2eadYelvhX7WLcGl3Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, for hugetlb mappings arches query the align_mask needed in order to
satisfy allocating a gap for the mapping, as it counts the worst-case scenario
which is being off by one page from boundary of the next hugetlb aligned address.

Later on, unmapped_area{_topdown} add this 'align_mask' on top of the
mapping's length we requested to count for worst-case scenario and get a gap
big enough, and then do the proper masking off once we get the address.

This means we have to special case hugetlb in quite a few places to first
1) ignore align_offset and 2) return a proper align_mask, but we can just do
as THP mappings do and encode the align_mask directly in hugetlb_get_unmapped_area
and pass that down to mm_get_unmapped_area_vmflags.

Once we get the address, we can properly mask it off before handing it over to
userspace.

This also allows us to fix a regression on AMD15h family for hugetlb
mappings [1].

[1] https://lore.kernel.org/linux-mm/20260527143643.GO31091@soohrt.org/

Fixes: 7bd3f1e1a9ae ("mm: make hugetlb mappings go through mm_get_unmapped_area_vmflags")
Reported-by: Karsten Desler <kdesler@soohrt.org>
Closes: https://lore.kernel.org/linux-mm/20260527143643.GO31091@soohrt.org/
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
---
 fs/hugetlbfs/inode.c    | 25 ++++++++++++++++++++++++-
 include/linux/hugetlb.h |  2 +-
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 78d61bf2bd9b..da9bfb5b79f7 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -184,7 +184,30 @@ hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
 	if (addr)
 		addr0 = ALIGN(addr, huge_page_size(h));
 
-	return mm_get_unmapped_area_vmflags(file, addr0, len, pgoff, flags, 0);
+	/*
+	 * hugetlb mappings need to be huge page aligned.
+	 * mm_get_unmapped_area_vmflags() only gives back PAGE_SIZE aligned
+	 * areas.
+	 *
+	 * Extend the requested unmapped area for the worse case scenario:
+	 * the address comes back and needs to be aligned up to by one small
+	 * page short of a large page.
+	 */
+	len += huge_page_size(h) - PAGE_SIZE;
+	/*
+	 * pgoff is being used for coloring, but hugetlb mappings need strict
+	 * alignment, so it is always ignored by special casing it down the road.
+	 * Set it to 0 here, so we do not need to be hugetlb-aware later on.
+	 */
+	pgoff = 0;
+	addr0 = mm_get_unmapped_area_vmflags(file, addr0, len, pgoff, flags, 0);
+	if (IS_ERR_VALUE(addr0))
+		return addr0;
+
+	/* Align the address to the next huge_page_size boundary */
+	addr0 = ALIGN(addr0, huge_page_size(h));
+
+	return addr0;
 }
 
 /*
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 5957bc25efa8..924e9a464214 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1085,7 +1085,7 @@ bool is_raw_hwpoison_page_in_hugepage(struct page *page);
 
 static inline unsigned long huge_page_mask_align(struct file *file)
 {
-	return PAGE_MASK & ~huge_page_mask(hstate_file(file));
+	return 0;
 }
 
 #else	/* CONFIG_HUGETLB_PAGE */
-- 
2.35.3


