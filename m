Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16D32606A338
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=maqChVHY
Received: by kanga.kvack.org (Postfix)
	id 244576B05B0; Mon,  9 Nov 2026 07:04:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21C136B05B3; Mon,  9 Nov 2026 07:04:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1380A6B05B0; Mon,  9 Nov 2026 07:04:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E07F96B05B0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:04:17 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6D10D120638
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:04:17 +0000 (UTC)
X-FDA: 85415447754.10.04DD77E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5C55620011
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:04:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=maqChVHY;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794225855;
	b=Vyonhap0UiuqVg/0og2eGCgypM/MCSU8y+X7YeeRF3L16ZHZqyX4OlIBJtv0PCiCaLvVtA
	cHObDwJo1W2LETvvnx4FvC3XiM5CBzHnNNxucRIm0jDN1mBFdw0QnHNjdCdzjYd7APlJPY
	SgJ8qnimrbX+Xn1a6f4f1+wQRevLEGc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=maqChVHY;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794225855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6KtNQnmIxI0QenYCQzZ2p4IsyzDnjmwEuXaOE3U5xFI=;
	b=ERnO8Jnc/TirmnFjmc0XLBOs/WF2TK/I5wGceb3NErF3DvYx4HlHOSb47mnr2ObBoAXj/o
	ooKcfD/Ty22oyaBO6+i9A2wb+8FKAPJRk3lfPVpMoCWcc3QCwmvmpwqCrMouDS1acKQ9Gs
	zKA2y2aAzod8Bn4LpU0370kDcaPchYk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A29E9455B7;
	Mon,  9 Nov 2026 12:04:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 140081F008A5;
	Mon,  9 Nov 2026 12:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794225854;
	bh=6KtNQnmIxI0QenYCQzZ2p4IsyzDnjmwEuXaOE3U5xFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=maqChVHYt7UHd0PkqZXlPhMF5EF/+k7GB1eNh7F8HqF9xvpV8sXRBNefl0fmFp1u4
	 PKUad7AQdbEH5nmXexaX6va6BgpSOUGNMTn9Erlv2zwWhgE7QSWf+ldKMjnSZ241gg
	 gn4YGN9cIXIkeXxROiliDbE69JhFp9EsbEQkZOI4b8j3PXRz/jqspQclGkuwObYwLc
	 yZzTUlqzJEKHIDRMlBS4liICJervpwke9NhZEkgMaVVwegBiB04frU31JTPfzI/jOx
	 /ZiUXACm3w/5n45d5s+tWYFAGYc/wA5sa4dpArLN+z/kZ5/f1zE+LhHpp1WNAlAxvW
	 IC8fgzx0LH+Zg==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id 35F691980047;
	Mon,  9 Nov 2026 07:04:10 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Mon, 09 Nov 2026 07:04:11 -0500
X-ME-Sender: <xms:ubbxanVJ0NJhtycXziopWk4XCNAwqCArL31FN9dqV08EEkTHblzXyw>
    <xme:ubbxargjz1sUGoaL3GxTZMKMocATt7Qtpm0BosjuFGBY9ZpRAouHXr4p2VNuZSWTE
    PjbV3k9fmm4-eeplBdPBZAyZ-JfNPcL2awVPvA9sMLTc7HLmUjTG8I>
X-ME-Received: <xmr:ubbxapghy3Gs0Cw0tDsJcZ_JKHiBzAlrKjRABh8CIa5SwUrTTtZ7jWuX3qU>
X-ME-Proxy-Cause: dmFkZTFgcJX3QqaptuagcgdnHFOsQz9wWiwGd7fgbWtGQNXmmbQfltLWg6boYc6d5AKRlG
    aOxWDcvYi2kECOnriHvC/JUlDnzbmMpNexALRZD+bYBHTIomNBZGGdCvXnp7cpCw3lorG4
    mGkrJknDCty1x7KsL8HGILfh1AM4KqxL7tur3y4mpHTRwUy6di6Bu27Pr9NACBQYUpbMuF
    HWK/8Qq13pFWGE6fal96QlsPbVBll7/chUmg6CwRPtzvPHt+donq3X9nQyFhwbSOM0N+Io
    m6CjDIVHaS9HXPRZ818OnENAcELGySEuqqm38mAS7EtGpMa7cAB0pgdfGnkGeISrlEhMJK
    KuMC6q5DLaHRgyX/hBgjUKsMUPqtZvjgceEDkznhIAplP8bkScP9qG8/uxFiNocDvLdG9i
    N8Hy78HdgidFLTVI7NDYd2CVeoCAPHnrZoGw2UIa29B2Yp6pRijzZz0nCJPRSvjAqI3iZ9
    bzRWmV0UzyvP4GPE6jgzctKeHjJE3QxKwRHZzzwXWm86MSzEKA8+sYXUiwyJQ9b5dWatt3
    h/DZ1MoPGzMIHR9gCGVnGZsBTU2h6rGOFDUdhPxkjvGRdErnEhyPoSNtUpHkceGOd49bZu
    U9tWGzr3emLA7R+XNz5O+UrnfvFHgUmsFRCq1vM3BUqxqdafNXiPI4K1JSEQ
X-ME-Proxy: <xmx:ubbxaou2cd4MDPPsZWTc0JUPCRLO5YfSIzY5iQDBzGcmjgZBP3qjcw>
    <xmx:ubbxavtNT78aBYuwNIwH5W5RO915k0-15pwynMptd-wRw-5MbIoEnA>
    <xmx:ubbxapNRYN8vQpJ-7V7a2LWGKESPlXh6GgERsIED29lEhclHDsC-7Q>
    <xmx:ubbxahftb521JzFlFMK76h3zynBQ9Ex86ysKAL5t0YKYHWdr3bladA>
    <xmx:ubbxagk0-Xy-yC6jtYOso1yE66nO4KzIVS5amyJd0dIZs6pZbuk9BLWz>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 Nov 2026 07:04:09 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>,
	Chris Mason <mason@kernel.org>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v2 1/2] mm/memory: recheck PG_uptodate after ->page_mkwrite()
Date: Mon,  9 Nov 2026 12:04:01 +0000
Message-ID: <20261109120403.82361-2-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261109120403.82361-1-kas@kernel.org>
References: <20261109120403.82361-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5C55620011
X-Stat-Signature: mgwz6t9wyyncnqbaibapbruoi46f1af8
X-Rspam-User: 
X-HE-Tag: 1794225855-105998
X-HE-Meta: U2FsdGVkX19F4TNdwS3fdAwj5E/VAKP9O83ASdxrdtbYcZJtTs/g0LO/pez+wbwwcd2BIoAhKo3xMjewmg/KGlPbZds9jnq8q27+iNXFde9jbW0yB/5HQiLztMWQ9Mea/FBrqC+HMo5joL5IgomoIDcGCPBt29m/yVrVEh7yoLgiYwF0NFW7yDPp4zY8wTCDIa7VdDPGGlpo+m3BMLfU5G+SaWjKRfxk4rE3MLXdnZRu8cSgpheRFtfloOGS633yMNxgG5zbO4XEN3oq5cBNQ/wQGCqM/ViY2S5pz8X23pgGrUF/UMYZfnlfPl3fE3JUd+68Bo6qWMHZBb+5BmZB2POyxOTFg7ESqiVxbGRJhhYWu7yp156pM7U9nxA3e+p/B8gRfOCmk2hDkiaEjPe2ITlu3qdM1OLFkSrNynwyYmgxQrdWsGggqOJLEhOzsI7yDWnVO/nhfYXZe3wWH0t5/kn0Xyoyff7hHALVx1DhyRG0CUBid1psUNeLbAXI1pjKl2WXkJRaxsmEvt/Pd/Xumw8rSrPJo2SoNm9WPDWO6hqxyKld7W16hA/ZZGnnq3cVQwDH/hbya6zy6jVsECrDcccPkvlVcZn2lABk8ps8q1NKMwSmFWtbB4c/fuFYuKoRyMDcepa/gqrF7UDrkJjA1UF2FjZT1kh/joSMBJ2ch9T9zjAHx4lz90IIB0EBc+XBvveQCYvx5bpO+8c4VozbG7RJ26sdUgX0EZm/drDuMzQ0Ffbjw5PSAyak/lb7hFbmSpnuEL6vBeIjs5eL7IPu4XOoRB+M+m5RITYRCjDoXTENkrOOkkzYg2Z5KASqo8Zm1c98RTlcxqNAuz44g+e4Q89KoMalOTC4t13i/NxsY9k1aYeJtFmasMz/W3TPfPJKOilQJqxSMDpsAWWQIpOWyTbANuFO2+4nqkmwBVSegX7RuHO7zZD7MZBQlcT5qBQuLgI/Qn+WnHfawSsN8gw
 Whuxgfrz
 Lc32kbRL1yrJiSgWTgiH+1TZncV5NI1Ntb2BbBMpuqAJt2ATmyfi5O5ixuJsV1Sa9MpdqQHX2ZaYBowvPTalXeK1SVSKIOdlFU9OKtny7MSG0n5L6up4CqO6HEV8ut8+ruA73xuxrkhvz59z2F9kvfcFhoGUPXD89B15hBLkSycrVq/m20ABCybwKK6rUG1HM8MEJW8gN33H6WcCqAr2zXR3tAj6ZRLUNI1eJ61MmoC55sX2oVko3C1hbH0tudv3pxFu0J8oQjKg3PFLTob2Uqarqpx5T5Q0EXLpuls6btRF78w63heQyWi2xcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

do_shared_fault() unlocks the folio around ->page_mkwrite(). Writeback
can lock it in that window, fail, and clear PG_uptodate with the folio
left in the page cache. ecryptfs_writepages() does this when encryption
fails. filemap_page_mkwrite() relocks the folio and checks only
->mapping, so the fault maps a folio that is not uptodate:

    CPU0                            CPU1
    do_shared_fault()
      folio_unlock()
                                    ecryptfs_writepages()
                                      folio_clear_uptodate()
      filemap_page_mkwrite()
        folio_lock()
      finish_fault()

The next read(2) or fault on the folio reads it in again from the file,
over anything stored through the mapping in the meantime. Those stores
are lost.

Recheck PG_uptodate once ->page_mkwrite() returns with the folio locked,
and retry the fault if it is clear, the same way filemap_fault() retries
on a cached folio that lost PG_uptodate. Skip folios outside the page
cache: driver pages from ->fault() never get PG_uptodate and would
retry forever.

The check stays out of do_page_mkwrite(): wp_page_shared() calls it on
a folio that is still mapped, and a retry there would fault on the same
PTE forever.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/sashiko-outbox-202966@kernel.org/
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/memory.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index fe72e66c9c2e..cc1d0b7d15c7 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5613,6 +5613,18 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 	return VM_FAULT_OOM;
 }
 
+/*
+ * A page cache folio that is not uptodate holds data that was never read in
+ * or cleared, and mapping it leaks stale memory to userspace.
+ */
+static bool file_folio_not_uptodate(struct folio *folio)
+{
+	if (likely(folio_test_uptodate(folio)))
+		return false;
+	/* Driver pages from ->fault() never get PG_uptodate */
+	return !folio_test_anon(folio) && folio->mapping;
+}
+
 /*
  * Either the VMA lock or the mmap_lock must have been held on entry
  * (see FAULT_FLAG_VMA_LOCK) and may have been released depending on
@@ -6163,6 +6175,16 @@ static vm_fault_t do_shared_fault(struct vm_fault *vmf)
 			folio_put(folio);
 			return tmp;
 		}
+
+		/*
+		 * The folio was unlocked for ->page_mkwrite(). If it lost
+		 * PG_uptodate meanwhile, retry the fault to read it in again.
+		 */
+		if (unlikely(file_folio_not_uptodate(folio))) {
+			folio_unlock(folio);
+			folio_put(folio);
+			return VM_FAULT_NOPAGE;
+		}
 	}
 
 	ret |= finish_fault(vmf);
-- 
2.54.0


