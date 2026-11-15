Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EB72606A327
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 02:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.a=rsa-sha256 header.s=s110527 header.b=IkKyId5K
Received: by kanga.kvack.org (Postfix)
	id DE29A6B05B0; Sat, 14 Nov 2026 21:46:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB7BB6B05B1; Sat, 14 Nov 2026 21:46:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C09AB6B05B3; Sat, 14 Nov 2026 21:46:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F8F66B05B0
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 21:46:19 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 06F93404DC
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 02:46:19 +0000 (UTC)
X-FDA: 85435814478.07.FA31B61
Received: from m16.mail.126.com (m16.mail.126.com [117.135.210.9])
	by imf16.hostedemail.com (Postfix) with ESMTP id DC843180006
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 02:46:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=126.com header.s=s110527 header.b=IkKyId5K;
	spf=pass (imf16.hostedemail.com: domain of nzzhao@126.com designates 117.135.210.9 as permitted sender) smtp.mailfrom=nzzhao@126.com;
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=xiaomi.com (policy=quarantine)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794710777;
	b=bAGGNjJhbEzTyv4/M+ub9jPwa6gudc4Hsp/sL4gsaS3NoHk8YI4PqKyDb9FYyzy6BeTE2m
	kjXS0gJFbnW/xHRxib3CJQ1pnfw/N2ZRIia8Bk8eOAxvRpHPQvCKzRQvtfOBZsidY+a0Km
	rAhKq7rGdXHp70QxfSkV0LTXj4fiwO4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=126.com header.s=s110527 header.b=IkKyId5K;
	spf=pass (imf16.hostedemail.com: domain of nzzhao@126.com designates 117.135.210.9 as permitted sender) smtp.mailfrom=nzzhao@126.com;
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=xiaomi.com (policy=quarantine)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794710777;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1A6ILGYMHRkFiraGoEIBeJ2vKZxeuMJlFrT2mhzR1hs=;
	b=ag0BCFbU3kNyvJQonI7OH55hWBW46JIB2WPK+FaTeIyoDW9DKTEdTyrrlNs9IahAPbq5Xl
	4lZTNb1wUnNm4KIEciPG5yQpha7OqLRvPhZlDVa5FQaK07zOGL9rBvtXYc/uNtscPrcx7g
	aMiUPuT9bwWYbjXDATayc6dvehs2S7s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=1A
	6ILGYMHRkFiraGoEIBeJ2vKZxeuMJlFrT2mhzR1hs=; b=IkKyId5KkdnMA3672Y
	PVjCUCyHB3RR1aw58IxumKwA/mJK27MMzwB5x6H8SdIYd5saj49nr5LFLXtUMPmJ
	1rBvAVqzrZOyK3zD/ZM8gHMEx501J3T6HFgRIwG4LI+gHyPB0CHHgv96YZYACu5Z
	rO2S8Ml+f935s2hvQ8r1Q745Y=
Received: from nzzhao-ThinkCentre-M760t.mioffice.cn (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PikvCgD3H_OtHPlq+ob+DQ--.31738S6;
	Sun, 15 Nov 2026 10:45:23 +0800 (CST)
From: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nanzhe Zhao <zhaonanzhe@xiaomi.com>,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Minchan Kim <minchan@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Usama Arif <usama.arif@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Ying Huang <ying.huang@intel.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	Wajdi K Feghali <wajdi.k.feghali@intel.com>,
	Bala Seshasayee <bala.seshasayee@linux.intel.com>,
	Nick Terrell <terrelln@fb.com>,
	Barry Song <baohua@kernel.org>,
	Tangquan Zheng <zhengtangquan@oppo.com>,
	Bo Zhang <zhangbo56@xiaomi.com>
Subject: [RFC PATCH v4 4/4] mm: swap: allow direct reclaim for synchronous multi-page swapin
Date: Sun, 15 Nov 2026 10:44:51 +0800
Message-ID: <20261115024455.1465726-5-zhaonanzhe@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261115024455.1465726-1-zhaonanzhe@xiaomi.com>
References: <20261115024455.1465726-1-zhaonanzhe@xiaomi.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PikvCgD3H_OtHPlq+ob+DQ--.31738S6
X-Coremail-Antispam: 1Uf129KBjvJXoW7tFyxWrWDAF48XFWrAw4fZrb_yoW8GrW3pF
	ZFg3s3GFy8Wr17GwsrW3WjkFyUG3ykWF15Ja9Fgr12v3W3Wr1xuryDtw18XFWUGr93Aa4k
	Zw4DAF4xuFs0vF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j2VbkUUUUU=
X-CM-SenderInfo: xq22xtbr6rjloofrz/xtbBowNQIGr5HMNkbQAA3V
X-Rspamd-Queue-Id: DC843180006
X-Stat-Signature: hndfjw8o1ad57wocenujbgtwpyo7x9ab
X-Rspamd-Pre-Result: action=add header;
	module=dmarc;
	Action set by DMARC
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam: Yes
X-HE-Tag: 1794710773-254389
X-HE-Meta: U2FsdGVkX1+0lnQ0JPOKcU+Ttzd7qKI+zghnGa5Ixq9KdbC4s9crZ5mpMcDGH0kSZMzQELuR2AvQj9bFPnvGCOVP8qIMMFdJS0PsuBE0IsI0isW1wrbrfmA/CAn2P65Ya303bK2XSOPbdKGoW5DGgY14ilZ9hOFrv48c69sp/kPz1TJ9itTdBTN675wsHsGCN2wxyob6d1uh9Rpb7PCiVIfIAGEU/ssLVkmvAq8/LD6+F8WD0glZ72TDNOnDji6dNH814r+UuVkcZOaPbk6jN8LIHf8SQQbCn0OulwSdF2LzbbGiYBvfe9XUAEs11XqC9sr5KO5T7qUWf6tWgSigP83CYbxytLF7t7clx6vvRth4Rv75pFEmuxG1XZNtsZHKmkWLHdyqVl91p+5Z5L2wNTC20RQg4/dHq8XigXSNCHXC1xWqS2ms4qGT9eAumyDpcV4aof5oZ2n9obNBen454SOhLvbj4kOoDgcHA+ELWF45ohbPYyB8zujU41HZVOhxC4zc9G9xGn2m1MuF7dAZok4Tr87NEUuEeqlG8Ksw7xqUBFr0YiPMtTxj0esTTbkZtWfq3xVt9M7zNGC+QL6j+CrMUwfU2i+m4LDSm94b4R4Rm8uZMxS95dEfPDU3e/JLilGUlcdWPIntkOoTv0ATOiO4zHvh3fxbB89SEGif/EeIJ5bk7FQoTkZ4cGnuPL94Kd22bi+j6hHL4XsedYLBL/7C17P/35kI6AosmFBSOMn76X7O5Lee68rGJm7ZK2npEECmuht6gq8B5O3vhPeTC8FMzB6rymH8YMx3j6SlvuKuxvvpZ75FsPMNqSFkb+fxkQ6HZq96dE2np+Dd8L45BgN6UDSvpQ+1u1CL2OCzGsTy9p/h3etn+LMjinb6G5pwhMVf0JG/gDaS9G9z7odOptSDWlCMmPLYtP5oUcfvbNvaGGAsXG2IvmzTpR/RCwTFNCXZPtYH+tJWFtpOYpk
 R42MX42p
 wQ2C4PouDGTx8tgBl4dYILFflnxgKvRfJjwIahk+M4J9SL4T7N51Et6HBc3224Dn2NQJUfwHfHqZ1Zs6hqLprvbZSUOl6POEsZUFhKs//k2SpBgcarcXd7Jcz1kpsvZAD00Mu26gSw/w0hmQ4IE4n1SYeab42g/Vpj5D8ea4YYzwjXQW+Z2StUOUd7izbQi7/72Y2OZUJSsbwd77sIzhMk3F59yArJ+4alTVnQRtqSzJflWnj/04LXmd0GAEgQbyers7c/FKPBgXA0K3v6RKBq677F5N7siENQkUpetbGGdAsN9pFbbEpIWZGBE+4UQ2i+fXZHzSpUteCZ0D2lcKmo8Qn/jVYTdhhDZXvmb7kAppoE/kugR4ymYDR2zptVRCN3SqOmkA25Dg/zt0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Synchronous swap devices such as zram complete swap I/O in the faulting
context. With multi-page compression enabled, a 16 KiB block is
stored and decompressed as a single object.

The swapin allocation inherits the VMA's THP gfp mask, which drops
__GFP_DIRECT_RECLAIM for VMAs without MADV_HUGEPAGE. Under memory
pressure, the order-2 allocation fails and falls back to order-0,
requiring the entire 16 KiB block to be decompressed just to swap in
an order-0 page.

Allow direct reclaim for order-2 swapin allocation to improve the
allocation success rate and avoid partial reads.

Signed-off-by: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
---
 mm/swap_state.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index da65d75ceead..912b0e21a781 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -462,6 +462,13 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 	if (mpol || !vmf) {
 		folio = folio_alloc_mpol(gfp, order, mpol, ilx, numa_node_id());
 	} else {
+		/*
+		 * zsmalloc uses order-2 pages to store compressed data.
+		 * Allow direct reclaim to improve allocation success and
+		 * avoid partial reads.
+		 */
+		if (order == 2)
+			gfp |= __GFP_RECLAIM;
 		address = round_down(vmf->address, PAGE_SIZE << order);
 		folio = vma_alloc_folio(gfp, order, vmf->vma, address);
 	}
-- 
2.43.0


