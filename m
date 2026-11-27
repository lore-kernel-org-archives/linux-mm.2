Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ACBB606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 06:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZfTSixKG
Received: by kanga.kvack.org (Postfix)
	id 8679D6B05B3; Fri, 27 Nov 2026 01:03:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 819646B05B4; Fri, 27 Nov 2026 01:03:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7550F6B05B5; Fri, 27 Nov 2026 01:03:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2DFBC6B05B3
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:03:57 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 72085C0212
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 06:03:56 +0000 (UTC)
X-FDA: 85479858072.29.DEA2F41
Received: from mta0.migadu.com (out-149.mta0.migadu.com [91.218.175.149])
	by imf22.hostedemail.com (Postfix) with ESMTP id 81991C0009
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 06:03:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZfTSixKG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.149 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795759434;
	b=Z6CfLFEJm6qHsxPXYW5ovz4KF+IkfmBxI1Ue8F1SPV+kaCHmhV/hb+RhQD3g03KAa4avFP
	eKiXV3x2hUJRKRSaW5+XmmxiISzo3shG74RYEiYy+ggqzCkloI+eaAqudui0KjqZWwjMEg
	o0JTI1H9Q63P8X4yVvIArm/Bs3twm7w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795759434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vq6Ie0MXcKbpZcClaYYkQNs+fysoljLg1mBQZgwN90g=;
	b=eQI61XpzTqxyycDHK1FpYdXpoou/iCKSBxKCE09/GvJFl6xvIGarHjO88AMO+j5Aq7SezJ
	tAbZjJyLzvIFTAkifI2rG4CQBK5TkL08eI3cqdkFt37atBx/XGyskQRW/rPvnje6FCoW39
	bGhjjBstRbHkEC3E+kay3RrDTSLrULM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZfTSixKG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.149 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=QKRPFUc3FN/IojMgCxlw2DQy13FR3rSKBkEjWNTSPv8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795759433; v=1; x=1796364233;
 b=ZfTSixKGum9ldr3hwamaS86x5nMIAl1bwZS9TOlVcbhzi3cJrnHYscMeSgRu33PBi7FYFESq
 IUyBLIf0Z8P7X+RhSjsp14bxuaPFo6gC63NogJGuqS3VBYeVLi3c/1fEE5Hhvn4QQx7pEk6vITY
 cW4u0uUFZ9xbzV3NkrnO5WBc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7c7a1f6361f0762a;
	Fri, 27 Nov 2026 06:03:52 +0000
X-Mizu-Trace-ID: 7c7a1f6361f0762a
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Barry Song <baohua@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org (open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [RFC PATCH 2/2] mm/mglru: prefetch the previous folio in scan_folios()
Date: Fri, 27 Nov 2026 14:03:15 +0800
Message-Id: <20261127060315.1119672-3-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261127060315.1119672-1-ridong.chen@linux.dev>
References: <20261127060315.1119672-1-ridong.chen@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 81991C0009
X-Stat-Signature: c5cpj8m8rbfwzhuatoupsus4uq7qap3c
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795759434-292491
X-HE-Meta: U2FsdGVkX1+xnsbNdRuBKHdjeTKHzu42SsIYEjFE6ecnDiYgP4FghBfKrhWh8PJNd700kPgCpTxDOrL+J0Q9jlUi0DZk6mcTRM4waVhRxdlmeHsnmOmYhJHoLGdYRxaMGfozV2/LkjAY5AmQNcDeG7wYCGQsJnPWNKNaZmLZQ/WbWD+s1e6PfmETSatHINERYubJ27A8JkIID5DKqqwSwDWiGIWFLFcvqbHP6atp7p25IkHI27faxPINuyETq6dBedGx9E0vp9Ck8Gc8EFaFVLyVZnc/s9sWPRkwlOKz63uO66easq4n4UFgaQ+qapXQhS9O37zZ+srLUvxYpVYGUTaheSyTWzed7tZ0gcrX2YlEOdYeIxDXmCHnjLBbc17Nb37yBU7q6JoaTpRsbmG2qlVnCTeZyuW6hYi1kXl9W9uNrgIyg7pZ3bkFM3CifxFtHUwDFjV+gi6YCR0+7a98YA2A9PZzm1W9RrtcnT43m6SABsgDnBv9sh+ReS5QpfiGXhpQlUPO87N24ygoqdar+m/MN/h5RDzdUaDCusOkamCI1bN40DTrIIB4RcOqF0yTZJlApEnY8jS0Njf/MuY45z56gBASh7M1p63Fzmj4lLOhj1Gr8l+GSwDKVfTy8W1zAlqteFKgigvgHVTDoFMA/mOn2axtrLmWjOg6RjaWJSQ7iZw67i2lT3asPH45ZeifaAmvcBKt+pXwxwU0eCATybw3zsAw1SuGtb24F9Nf7/SJBXOk05+9le2I5hxb/yLFpIIgiNp3inPDQqNRQLPh3YxkxUcw+1OgUDnbpMln47ykBs5cogkYm10zmnJbp+4UIzExz0B+oAhzh+fboQ1HzRuF6tFs/e/edAgjEJpUbxl3Sa2Zqt7A2JydbBqP0w2b5Io5OMvj8M+oyAVmKXEKMYRV25sZcgyOynxkhhf9+NWqgm0NzlwmNrtU3QUtf+S55HSA+Tg+NBpL7czwAJd
 +v/ZN6mX
 uQKijhGYoYMsFuJpRAm6UcLC7FncF25KLGq4s53IDrWkX/C9+LpqhmrGRADIrP4RYJ4Iiei0G7XrZvU+GkJOTKxoq1wJXirOFfjon0/dgWKkk66yI0015ZU14RxVMtdBJIXa5CBbM0aApaBHGk7xBT/s4kaW0niwekhE/hxwz9P13PxEAIDEg9hQr4EJO3Na8kHdl6WjBqKTUtYvB9CyAJcNbgO1cEfj+g2KZYTPGO10qEJSCkTlEG5qFhy6Y3//xxRpvg90LDsfpI6PAnmWUkTjptGMmGJP4gBUB0TmS8+c5BRy+qMYFizcrDbLkhPW48k3KdbtCLcEsb0LD3HOrJb4j3ejDLOhIQsOQFOD0KZO0Ejuv36lDPaCRwKOEFlTFbR7vVF7ggv66WpiGiQqjY9BkvliAN9ZDTd7NH8M+H+PBrIKGqEYxG7E+g4VOciXp2A5qtloYM3mMmcudIly3bPZnLbgpnva4n4+nJrEyKEg9xzKuJASXIX0WOETf5X9npeNC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ridong Chen <chenridong@xiaomi.com>

scan_folios() walks a gen list from the tail under lru_lock. Isolating
a folio unlinks it, which writes the lru pointers of its neighbour, and
the next iteration then reads that neighbour's flags. Both miss in the
cache when many CPUs reclaim from the same lruvec, and the misses are
taken while other CPUs wait for the lock.

isolate_lru_folios() prefetches the previous folio for the same
reason, and inc_min_seq() prefetches the next one as it walks its list
from the head. Do the same in scan_folios(), which walks from the tail
like isolate_lru_folios().

Tested on an i7-13700HX (8P+8E cores, 24 threads), turbo off and the
performance governor. 24 files of 128MiB on ext4 on brd, all threads in
one memcg with memory.max=1G, random 4K pread(), so nearly every read
refaults and every thread ends up in direct reclaim. Reads per second
per CPU, mean of 2 runs, with and without this change in one kernel and
the runs interleaved:

  CPUs      base   patched
     1    426681    425912   -0.2%
     2    387442    392010   +1.2%
     4    360312    365538   +1.5%
     8    314549    322524   +2.5%
    12    235058    245057   +4.3%
    16    184086    200956   +9.2%
    24    124478    145011  +16.5%

Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/vmscan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9dbdcda04f13..14f75c6fc4a8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4814,6 +4814,8 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			struct folio *folio = lru_to_folio(head);
 			int delta = folio_nr_pages(folio);
 
+			prefetchw_prev_lru_folio(folio, head);
+
 			VM_WARN_ON_ONCE_FOLIO(folio_test_unevictable(folio), folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_test_active(folio), folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_is_file_lru(folio) != type, folio);
-- 
2.34.1


