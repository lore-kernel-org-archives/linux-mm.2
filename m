Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B707FFCE07F
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 13:32:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24B266B009B; Thu, 26 Feb 2026 08:32:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F2416B009D; Thu, 26 Feb 2026 08:32:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F4AA6B009E; Thu, 26 Feb 2026 08:32:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EF63E6B009B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 08:32:52 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6A10955EAB
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:32:52 +0000 (UTC)
X-FDA: 84486698184.26.E22375B
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	by imf01.hostedemail.com (Postfix) with ESMTP id E53174000C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:32:48 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=eYza4UBR;
	spf=pass (imf01.hostedemail.com: domain of zhangdandan@uniontech.com designates 54.254.200.92 as permitted sender) smtp.mailfrom=zhangdandan@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772112770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wIAqc9ZjSWfa/F2Z89KnaSRh5o6S817igYSMsy6Yias=;
	b=UtUXQRgQ/OJrg21APk/iH7pvxL5gTrSlu4fBh2Fm/XRUVTdE/4YI3NvCcgGgqpWw5amLLZ
	KGXrV0qxhRSYvPPRgyuGHLxrdqjDfNojR5Y14/6kn8wyNL+jbje1S+V6SOmrDhDtWqBFx3
	pmKvlA0TrVGpiwxE8Sz2B1xn1AnvXis=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=eYza4UBR;
	spf=pass (imf01.hostedemail.com: domain of zhangdandan@uniontech.com designates 54.254.200.92 as permitted sender) smtp.mailfrom=zhangdandan@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772112770; a=rsa-sha256;
	cv=none;
	b=yZZ4aQM6K3NPSkDd//p67w25IbIWS+O427z8/CMkG4WWCqh5YUZTh11f5awwYdXum8bmHR
	3P8KXAz88GGySUBisMqNwvJVu2p15rXkHZJV+BYEzZFu4ZdTEPG7Fr9l3XiV5lTBRKq+EO
	vbxYLaAFAFnZZdQXrWZ8jvl2xyW1vO8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1772112730;
	bh=wIAqc9ZjSWfa/F2Z89KnaSRh5o6S817igYSMsy6Yias=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=eYza4UBRaVzP6QafQtmzd4Ou8+Lvsp3TceeLtja//jGOmPtr2TbDk12RlNj6uYKXK
	 acYeGLzYP0/9JVI4+NKtjYCGDnJ1Dg2ae6EFP84Zb53++PBIJDHYna7fZ5tr0UIdEa
	 PHDowcjlvycd1G4QE2Zb/ekQTJusC40IRXaWjiN4=
X-QQ-mid: zesmtpip4t1772112714t22e84ed1
X-QQ-Originating-IP: y4BUbQojiwAYU3AEeB9zl5yJkZDVNE3EZ4cRoAVfcKs=
Received: from uos-PC ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 26 Feb 2026 21:31:52 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 1048834162358125244
EX-QQ-RecipientCnt: 6
From: Morduan Zang <zhangdandan@uniontech.com>
To: bfoster@redhat.com
Cc: linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	willy@infradead.org,
	Morduan Zang <zhangdandan@uniontech.com>
Subject: [PATCH] mm: fix pagecache_isize_extended() early-return bypass for large folio mappings
Date: Thu, 26 Feb 2026 21:31:49 +0800
Message-ID: <3F3A46783F8E9D52+20260226133149.79586-1-zhangdandan@uniontech.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20240919160741.208162-3-bfoster@redhat.com>
References: <20240919160741.208162-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz6b-0
X-QQ-XMAILINFO: ODcDgdcDagQKK73kbnoKVnPAelgFd7Q6Mg6OyC7hgcKFpHFWBkzjjlmp
	g5Rq9T2TLhJC0skg/q0ul79P4ZzcquUzKn/uvFOZY11/U23Buz22qL+kBfJbNX/ll4YLmj0
	2zB4sAyugLaRRWWp4axXbr3I8NiqTWgTLX0nlkO7mZ4yivC45MMnCC+fFt9PaV0pW9gMlnz
	9uUS4prTcLH/EsvYUYJQ3uFTRJ3iSsHlY93b9mUXLgytGgbQMVksS7uuzYvwT7kn0XcRrpU
	yy/CWG609P3JZgd4z0cFs0e4jTTKePY9/Da0zpxUTOwOsYFSBodddq0D6JB1svxvcB2Rpm3
	uQdC2+RMqJKRY82HkXvPkaKPma8s5EqANcIUDMTBc0pT6Mtmu5YthikZOEQie0u0x49mWrW
	Tr+iv44nsnV2DqbEn9HCFvK4TrGH+VJb+rndyDgn/vZwJRxGuRsyEiN4FVgjOVX63GYLQ2p
	klBBDahAm0C00dBanm5HLp/DGP+XodoBy5PzQgLE4gAaZRMFaLwu0evWbND/gsQRbz4LzAw
	cWAmKcum8VbFW/mLo+XTAA4KE4GD02ufecukPzyzDdbwjP1WznIkOniXHsKrCFwa/AHxL4j
	CcCIxZ1bldViPLk223Zcpc/RxUR5GQOCgxWQ2xFw8lpKfnE1YfCHgXmWvsnyGSG1wHmPrWU
	l0iO83vJskwMJr5yD92dIu2TlEHl5/iVlyGyRGTRvX7AK5vrxY8NOYCDX0r9dcYQo14DC2Z
	gsoLWMslbMvwGFs3+KHAuQrsqq+kNAJ+3cXtvHS+vQdQOS4MJRC9htVepg/v1pkJjqiGJtT
	LXVhdLOsaAACn44UZHu7/fQNhS0EOYoX7PCI4dYFOoj4hu5MdkFo4YKxCyk13EnU5fvG4vK
	eGwMoq8p6DdOVH4pqdp0fx8LdfvuWMbSsUrgghp8WjmQ3sr9kPnPhdaIT4IgDqZP445jrGS
	C7oxVE8g3bNNaZTRyD34GCCgxfl0C2+bJeSaHJ8K67KdT/VmE2LbANPh7WOgnq3mEiWLIQ8
	rCIzBYnQ==
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
X-QQ-RECHKSPAM: 0
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E53174000C
X-Stat-Signature: 984ik3d14hckykijnjjbsjc7zwmtg5p9
X-Rspam-User: 
X-HE-Tag: 1772112768-685365
X-HE-Meta: U2FsdGVkX1+qC+IL7Lxr5HtrBcNpNKj7N8f7uBPQGZ/Lg2PtXjKOfzGFLfJw1oay1b63gG5ZXKq3UFitO3K7mIHXH6s7MnEHW0D2NaXZ1+NsZZGHqL3B2QHhSMHUUBiBoQgXawSh7tODm45YtgkTUFjZpJxZ2tQUbR0jWUekSX0IsO6BsyZoUl8QWSWLNx9/kjKkzdL4QNmqo3lEcw6kb0kreX2cWHxPMZdFzR/L7dD7tvPNfKrmfcJ+G7xakWbcSZYmDqbP0O/k6Wo6B/8MeGed3UYYHwDxLQw56abGoxeFyGTxSBK1abw4XWe73a7c7zIiX0of1A1s02ILIrV4PkAxRGl/I3XSW1gAK1bDm5uKGYMxXk3AjUUWCasiayCSDOl62I1wYXLSW7gNfEHNUNy66fKLuFN2txuCFvnh2gDu5XyHHfqEmHtt8KI+/XkzI2w4Wv3O8wLD9d9aNvWgB/+0xwd5+9uoyC4YVG95J7iyRJpzGyS559vPR0kon89ps++P/a78scxxYqe2COcvOfWIE6ElN/+ecFCgtj/BJg/T0TdpEONhTVMLzNtENlR++LLCooGLthI7i8xq3iwa1kSkomazBIBi1HNrYBjBN3XP02vspwUm1ZGpfloqwsCmfq/E2g6c08VaSXsKbcAjugvbPcwiOUTcs+g8i0w/JPvuCeJoof6ChpzRXDdrVmGrX8Mg2iMMPwnGFmKWzt4IhOyLcLQGK24FbadcW2bA7GVYJqP+3qeD6WRzGF7nM4s3t9roQCrej6j4BTqQlMsoeDGLXLvPVjOglPIS6zQnlG+Ar36lqqUl0jicwX3G060ASbA8La+DHA4mzkA2JGSZwGWB90PTjYZpa8zVaA0Rkw2NC1S8/M0GlParlzy1mdj05Ze07EINqTRSPlh/Gs8BKJVAkdH+LziFjmLvuVC0VZGYqB4cI029oCDHbVE9UEe2/7qPaynq7PGj+l0pKqh
 7sdH+vY1
 QwNVZHOqh0c3IgIRwwzacIx9EcFNAmeI1QJzJcd+9Up96xf3DOyTjSVLzcOoln72yUE+Thl4Otpg0Qc4cL9rsNksaDnnPA7E6u+7KASnxz7ZqzGvlcyGPAD5BVE3aqE/thjP2eHzaghzNHl4vb+8yV3fYXzm8k7DcbrN+I40J0Vf25rY0Ha4YjokzcK+bjdWEam6UiglqnwoCz2Ys47IanMHs+Z8+PZPXbMZBpOFTe93oILGZYpS3T/UjMgCj0V2Mr9r8+uM3ZTxZhGHtJ+5zyk62SEvaQBokctjwxEm+8RBur7lz/bi984QaK6Nybn/Ljsu8s9anVHNETlJJu8nzsBaKFMUy8aB2LB7XuDp4/rFlY0RKFwKgdBjR4rLEkJdyyj0kGb47YyAuXEE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pagecache_isize_extended() has two early-return guards that were designed
for the traditional sub-page block-size case:

  Guard 1:  if (from >= to || bsize >= PAGE_SIZE)
                return;

  Guard 2:  rounded_from = round_up(from, bsize);
            if (to <= rounded_from || !(rounded_from & (PAGE_SIZE - 1)))
                return;

Guard 1 was originally "bsize == PAGE_SIZE" and was widened to
"bsize >= PAGE_SIZE" by commit 2ebe90dab980 ("mm: convert
pagecache_isize_extended to use a folio").  The rationale is correct
for the traditional buffer_head path: when the block size equals the page
size, every folio covers exactly one block, so writeback's EOF handling
(e.g. iomap_writepage_handle_eof()) zeros the post-EOF tail of the folio
before writing it out, and no action is needed here.

Guard 2 covers the case where @from rounded up to the next block boundary
is already PAGE_SIZE-aligned, meaning no hole block straddles a page
boundary.

Both guards are correct for the traditional case.  However, commit
52aecaee1c26 ("mm: zero range of eof folio exposed by inode size extension")
added post-EOF zeroing inside pagecache_isize_extended() to
handle dirty folios that will not go through writeback before the new
i_size becomes visible.  That zeroing code is placed after both guards,
so it is unreachable whenever either guard fires.

The same stale-data window is also covered by xfstests generic/363
which uses fsx with "-e 1" (EOF pollution mode) and exercises a broad
range of size-changing operations.

Fixes: 52aecaee1c26 ("mm: zero range of eof folio exposed by inode size extension")
Fixes: 2ebe90dab980 ("mm: convert pagecache_isize_extended to use a folio")
Signed-off-by: Morduan Zang <zhangdandan@uniontech.com>
---
 mm/truncate.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index 12467c1bd711..d3e473a206b3 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -847,13 +847,32 @@ void pagecache_isize_extended(struct inode *inode, loff_t from, loff_t to)
 
 	WARN_ON(to > inode->i_size);
 
-	if (from >= to || bsize >= PAGE_SIZE)
+	if (from >= to)
 		return;
+
+	/*
+	 * For filesystems with bsize >= PAGE_SIZE, the traditional buffer_head
+	 * path handles post-EOF zeroing correctly at writeback time. However,
+	 * with large folios enabled, a single folio can span multiple PAGE_SIZE
+	 * blocks, so mmap writes beyond EOF within the same folio are not zeroed
+	 * at writeback time before i_size is extended. We must handle this here.
+	 */
+	if (bsize >= PAGE_SIZE) {
+		/*
+		 * Only needed if the mapping supports large folios, since otherwise
+		 * each folio is exactly one page and writeback handles EOF zeroing.
+		 */
+		if (!mapping_large_folio_support(inode->i_mapping))
+			return;
+		goto find_folio;
+	}
+
 	/* Page straddling @from will not have any hole block created? */
 	rounded_from = round_up(from, bsize);
 	if (to <= rounded_from || !(rounded_from & (PAGE_SIZE - 1)))
 		return;
 
+find_folio:
 	folio = filemap_lock_folio(inode->i_mapping, from / PAGE_SIZE);
 	/* Folio not cached? Nothing to do */
 	if (IS_ERR(folio))
-- 
2.50.1


