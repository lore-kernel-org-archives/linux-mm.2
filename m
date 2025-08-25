Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56997CA0EFA
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 16:37:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EF7E8E0052; Mon, 25 Aug 2025 12:37:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C7068E0038; Mon, 25 Aug 2025 12:37:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DD3A8E0052; Mon, 25 Aug 2025 12:37:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 779938E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 12:37:31 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3AA33841E0
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:37:31 +0000 (UTC)
X-FDA: 83815835502.11.041026A
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5C93510000D
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:37:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eR3L9yGT;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756139849;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9VWBN5hI6vm4GSJb+4hWySQHfw8R9VEOfGfW5RFaYvQ=;
	b=EBX71ruZSKokIAcxv9qRHNFIHJ3cnXgutVF8QJjB3bybAduiGom7VZIZcUErV2lQxY7kXi
	uF2QO/szihSHAF5w+gwCdsJAFAmeoIZedRlurxnJRSkiaOcgkgly8vhd/RmHImVPN843/k
	a99xk14eP6IJJNz+Fy2qdybyRf97XPY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eR3L9yGT;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756139849; a=rsa-sha256;
	cv=none;
	b=trsoAg9AiPFXRhW22g+HqHcI4Nt/wyVIsx+peNne2+5eJ5mBGwMaa1j8DsUvw/KOoXWdsm
	o3NJMSgHqddgNK1MKvlfRlheEBC9mH+POJsJwEgEoKVN0YyCOBtUAIqHgpd3eWz2xmBLW7
	KqzMCf2gYsdOSc2XCbeqB8+UFAoMNRU=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b4717543ed9so3106971a12.3
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 09:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756139848; x=1756744648; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9VWBN5hI6vm4GSJb+4hWySQHfw8R9VEOfGfW5RFaYvQ=;
        b=eR3L9yGTUt44p0N+KNGQzXjhT3/d6/jieZ1hWq74vq93uE6mopF+XH/8CRXSWCdwuT
         diLEUqnDfJQeX0+0KCZO0RarGBgiJOQfGisu18ppBIJJUkSKpbPTOAuG2d9H8MEo1mvG
         aHJslYlJkCZF79Yl5r6IIWX0ADGBXapLJ03QkuYFun210JTCGJJRjzQbmab26x35lbI2
         avQT5xbAD8FTVEwvDBmE1kHi6gbOuIO4M2JNYElozQH7i3k4CtRkp9YU+eAZjLeHwzgF
         mPa4J1jP/kjCAHodSCeDOahJm+Jakg1AGWFj3iVMQ3Z4A3cAaUlKFzb+5ab4AbazyBIv
         Ldjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756139848; x=1756744648;
        h=content-transfer-encoding:mime-version:reply-to:message-id:date
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9VWBN5hI6vm4GSJb+4hWySQHfw8R9VEOfGfW5RFaYvQ=;
        b=C4jcgMf3xUKCfifJRMNfG7MR2OpD4YM8tEruwTpbwlmYDRnpn26pqTmG4eTqv0od31
         Z/+AGEFMquNNhK3BFN7pRvz/RtMe7NzwpmYMAC9oelJF7XP/O2Sp9tcFz+8gXrbstLa8
         dqS+BReLl3Do9b3eMx4XDzVWurMMYIlLwB0AA95eMp0Kf6twph8wzNhJkechoIsiIwa+
         Nn+Dh5zyhj9kvgCXxGNMtIEjFJuGKS3RsuobxBozKsD3u1ZBzA38QDqRPdskLQkCL05Q
         kQDy9PUpUpiYWURzYpM7rZLSzeQbf3MvK5omd6W8IskBnJjiTW6XIlB4AiRGSRddSuo2
         hEsQ==
X-Gm-Message-State: AOJu0YxcpizdMfMaFDzM794YHeSYFvyAmd37w/JSSH3RqYGGljXqLAx3
	TTzI9sO6HEEqOgHGKs302m32FbFasSdQSmyp/kimHqMeJHN3h36JF5aepPnD2++X6cQ=
X-Gm-Gg: ASbGncsM6SGD/7g3GP9cfpOCZV26WruKEDJGQwwr7IFhbB1UTpdhAojmQBrBMne9fOZ
	aEy1aEdP8WLjQ30sdN796o8GZUJ9qDUh3qQNqVxqrU7IA6bRm2PUTvrn8jVO41BUhD0dhC1LZuj
	UgtEzUtTm7TyYsl5TCHMpmSVj1+RM7laNe/Jy7UXVipWM42IY0AE+aNbKq/5PBpoxtaCubsEV8z
	c4KR8sjqrRXBJpfmALFXLpcNafctoaaoagd8OlOMAci6SXBgc6UeHu4HOBlJpqXgp1DF3Ymh1kM
	fG3KUp5T6DC4feg4QYpjqzNdbOdU2yajHuqRHI25TwXsE9qS3v0EKLvT9+QG0Gj0CE9eLO2CQm5
	SuumdziSrTDCApJvZ4jekBv7ejVi98m/Zci4UHLVvfeU=
X-Google-Smtp-Source: AGHT+IGMln+AnEhe4Xop32BwsGkP1vKS/jDJKfzqYQDYkoJiSelQYB6QRw5vsdnxLnjupDrzw+FuiA==
X-Received: by 2002:a17:903:1ca:b0:235:779:edfa with SMTP id d9443c01a7336-2462ef219dfmr135753915ad.32.1756139847374;
        Mon, 25 Aug 2025 09:37:27 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2466877a01fsm73382505ad.16.2025.08.25.09.37.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 25 Aug 2025 09:37:26 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH v2] mm/page-writeback: drop usage of folio_index
Date: Tue, 26 Aug 2025 00:37:21 +0800
Message-ID: <20250825163721.17734-1-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wc71mgapxmue3nz6x6gcdrubiux36rap
X-Rspam-User: 
X-Rspamd-Queue-Id: 5C93510000D
X-Rspamd-Server: rspam01
X-HE-Tag: 1756139849-736233
X-HE-Meta: U2FsdGVkX18A/5ZHxPELo7RZVDcEVSn8LPYbSNCj7hunAkft85OWFFTreoKuDkvB19jAHoInochHwK2prWYY6KUm9COE2mE4JoY/KMds/MBcoJBbfTKYRhlHd2vUIJMBUaY86doldFKPoSDc8INKkhNDnGgJuZkqjBz+1XTAJv6lD2LwAPxGLilr14Q1ocdOl2hZ9TeemcI1ARAjxuXvHpiASjy/dX2bXxUo7gvsvMXYC0PlOd+2RVUURRlSfBYMlcIKIKBzw94xlhJ2NtuPXznqSafOgGcDujQS1FVDTWHBY518onyTZoD5tvQQZCTVOA4ad7HYv81vo/pLh5CamKIlrST6ut8ntnygz8E6D9SpTK+4dAmJiq/GQTekyHeakJkjaIufsWjwl/O3hoggNc5DKVXs/KzFqTR7EdM9lhbNUS+TKbEd0PjIIDDta9oJixOpCxMOnJ4wJUA0aupW1yz+YoHid3fP3GOF8DNghoTs351zsCjui6aOgAkQjLoPE3oqElXnCRQj/O+v3HYurKIfM0hSkHbR4B6OiP72bEL2P8GhTEdFAiPV6Wpfg/eDM+k0dlCOD5ICrN51CZiNl11N5f/7kmBjUH4dy/Sf5KE8HvYrvMR0Zacw4fS5hAaSk/rjuff4ktH5ZFWEJD++OFB5+8hZayVgbsOFCSsg2UD2d8mDrmaFK/TvfCIcPweFqN9QnnuT13DkJDkeXsWFlu9NqK7XoJxXsBUEvcEcmK65e+LcuiwhIw0Xr+kM0KSvxLibbQJgDnFfi0iWvoa4F3ZXH4P+fW0sutAF+R1Go/0xgliNE/+/vhf9+zhQogmnG8kQ486jrX1+i3p9eTYSHlMtpxHOteNk2xBbcEnnxZFN7vKe4y4p0EyeXRWwDmijREgaFsEY6sBfm5mHTOc8qTO9tVE2oKHQgllI4dYPVvYdH4073MD4U2ws6+cxIJjre6V1jCuQ0FP4F9EWA5P
 PTLi3MHg
 VzbY/3wzfYWqFcuplzKqa0lZJT/ZT+SOHU28VmCWzaKJUyk1f7GgmzhbQoV1Z+VxX0HsUNjrBa/9Q6A2m42HwsVgHW0gcHH1lO57OE10ucYs1bNdRj7FUYlX9dB6FRiMR+KrwNbdpKW50+Oxvw8Fam33T/d79Gttyv+bNL4NzJS/FFpds/EWxP/2wAfUYDdfIr9zSoAhfKQKIlRy1NFwFgeVjjTLlzEofpDSk9RnsopGGskF/wnFn0TpYQZ2g2lLt3tisso+UM8pijXdaaRQ3CY18HJzi4ecQG/Gc4UB8FqL0y7TKDboLBlfkdGn3BT8KXcxDh75krPnImnXWnBh1yIacT3UAwFZJja61fz+nP/+i922hKL2nFf6I6GwmlFeGCr/kgl8sdzeOUqassTIAJsc1kABvrh8Z+dVGaSV9f+3cHfly0MMO+PnTNzlqaI21/+gjdwyTJT9Y1DcrdCUoVeW4v9MC4wuF0+1DqE5dAjs4jRwEYtl+1NdOdtvTV1K+mcdFRqF34QlKMARgJV9AkNmHfiwAQYYb+p1JhuHhzwQbRAK+4WTYRq/3pBJT/YkaKraCWm86owQpk3Ub1SvqoUXitPDVaBKvvjgROkt0YVE03Un/uAh2KP22lO0uOb8CDqnrXCeK+xaOV1xBQFCHPJJ2u8FAoe0vJDMgLr6kHRLCybAPiq6Mh1knIUuMpxaUB9cpW6cVxTtsIQig/HHr7Z7c6L7W2+WA97OW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

folio_index is only needed for mixed usage of page cache and swap cache.
The remaining three caller in page-writeback are for page cache tag
marking. Swap cache space doesn't use tag (explicitly sets
mapping_set_no_writeback_tags), so use folio->index here directly.

Signed-off-by: Kairui Song <kasong@tencent.com>

---

Changes in V2:
- Add a VM_WARN_ON_ONCE and some comment about why we don't use
  folio_index for __folio_mark_dirty. Other helpers all calls
  mapping_use_writeback_tags which tells the reason clearly.
- V1: https://lore.kernel.org/linux-mm/20250815121252.41315-1-ryncsn@gmail.com/

 mm/page-writeback.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 7e1e798e7213..5f90fd6a7137 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -38,10 +38,10 @@
 #include <linux/sched/rt.h>
 #include <linux/sched/signal.h>
 #include <linux/mm_inline.h>
+#include <linux/shmem_fs.h>
 #include <trace/events/writeback.h>
 
 #include "internal.h"
-#include "swap.h"
 
 /*
  * Sleep at most 200ms at a time in balance_dirty_pages().
@@ -2705,12 +2705,18 @@ void __folio_mark_dirty(struct folio *folio, struct address_space *mapping,
 {
 	unsigned long flags;
 
+	/*
+	 * Shmem writeback relies on swap, and swap writeback is LRU based,
+	 * not using the dirty mark.
+	 */
+	VM_WARN_ON_ONCE(folio_test_swapcache(folio) || shmem_mapping(mapping));
+
 	xa_lock_irqsave(&mapping->i_pages, flags);
 	if (folio->mapping) {	/* Race with truncate? */
 		WARN_ON_ONCE(warn && !folio_test_uptodate(folio));
 		folio_account_dirtied(folio, mapping);
-		__xa_set_mark(&mapping->i_pages, folio_index(folio),
-				PAGECACHE_TAG_DIRTY);
+		__xa_set_mark(&mapping->i_pages, folio->index,
+			      PAGECACHE_TAG_DIRTY);
 	}
 	xa_unlock_irqrestore(&mapping->i_pages, flags);
 }
@@ -2989,7 +2995,7 @@ bool __folio_end_writeback(struct folio *folio)
 
 		xa_lock_irqsave(&mapping->i_pages, flags);
 		ret = folio_xor_flags_has_waiters(folio, 1 << PG_writeback);
-		__xa_clear_mark(&mapping->i_pages, folio_index(folio),
+		__xa_clear_mark(&mapping->i_pages, folio->index,
 					PAGECACHE_TAG_WRITEBACK);
 		if (bdi->capabilities & BDI_CAP_WRITEBACK_ACCT) {
 			struct bdi_writeback *wb = inode_to_wb(inode);
@@ -3026,7 +3032,7 @@ void __folio_start_writeback(struct folio *folio, bool keep_write)
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 
 	if (mapping && mapping_use_writeback_tags(mapping)) {
-		XA_STATE(xas, &mapping->i_pages, folio_index(folio));
+		XA_STATE(xas, &mapping->i_pages, folio->index);
 		struct inode *inode = mapping->host;
 		struct backing_dev_info *bdi = inode_to_bdi(inode);
 		unsigned long flags;
-- 
2.51.0


