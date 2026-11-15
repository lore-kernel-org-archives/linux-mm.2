Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A841C606A31F
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 15:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QOQ5B2UQ
Received: by kanga.kvack.org (Postfix)
	id C28396B00EF; Sun, 15 Nov 2026 10:34:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD8AA6B05B0; Sun, 15 Nov 2026 10:34:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC6E46B05B2; Sun, 15 Nov 2026 10:34:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A8996B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 10:34:23 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 071F1803B3
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:34:23 +0000 (UTC)
X-FDA: 85437750006.01.80B11FD
Received: from mta0.migadu.com (out-117.mta0.migadu.com [91.218.175.117])
	by imf19.hostedemail.com (Postfix) with ESMTP id D8AD51A0006
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:34:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QOQ5B2UQ;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.117 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794756861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D9eYfMQniN4MTERSNCoJWid+KzRgcjYDpVDX0WIaOcs=;
	b=HLT5BsJbiozvQJLvxkarXE1aIvDsq88uUlsRoU8sPPsWRjEbyNTT0MH/3+6juUQsufYQEo
	rRNml+Q6PAkuOSOZo2qbY2LxVUaep1EHIZXJ4PffkAjeBEs2fxKfPM82bqUEMzPkktBjUm
	QPp5j7Q/be9Kt3j7nnXTtQ8BY0zA/Ro=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794756861;
	b=BCZyZmwQWE8DOWCQ5bkgKM730LI1mG3mqJFcUv627J/U8A1mh+jaFCZ82DorGsmrtxtymB
	XZ3Mco/ZdJSNuk3r/Olyzphi0FdUoXrCbXU6oRAS6o9KBMAuWh1YB5Zu6UaXtLJZiks9sQ
	t6lr1sBBas/F7Zrch1rVgSWwaRLhI2I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QOQ5B2UQ;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.117 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=D9eYfMQniN4MTERSNCoJWid+KzRgcjYDpVDX0WIaOcs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794756857; v=1; x=1795361657;
 b=QOQ5B2UQUdcw2pVPpUCjj4AzTtujU0vVL/9lS/ybwhefeK0OL1KDpz5YyyEQT32Tld+5tlWQ
 o/n1ZUi7xHptYeppnRU11jU6bGNnkp9pzXyYX6MkVDZSvWmAlB+LzYHsm6neXixTKCVmbTNhJco
 D3+nId2JmO73KCc4Zgw1eVec=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d21ea3c6ecf23a6a;
	Sun, 15 Nov 2026 15:34:17 +0000
X-Mizu-Trace-ID: d21ea3c6ecf23a6a
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: will@kernel.org,
	aneesh.kumar@kernel.org,
	akpm@linux-foundation.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	arnd@arndb.de,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jack@suse.cz,
	zwisler@kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	mason@kernel.org
Subject: Re: [PATCH] mm/huge_memory: flush dirty file PMDs before removing rmap
Date: Sun, 15 Nov 2026 23:34:11 +0800
Message-ID: <20261115153411.87967-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261113-dirty_file_pmd-v1-1-8c11f2a2e65f@kernel.org>
References: <20261113-dirty_file_pmd-v1-1-8c11f2a2e65f@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D8AD51A0006
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 9ruq9dbc7f79pkzcf1d4seq6g6bmx6rc
X-Rspam-User: 
X-HE-Tag: 1794756860-464157
X-HE-Meta: U2FsdGVkX19FZ6hq3Xy+09+Lj8t1WiiI0/nCjklsWtTD/lpe9PHgkAp0fPAIhkvJ32QvZxUT+wnPkJn/Ngq5hqv3xziq7gLRkT2p/VY54yjTorJPfabprMwZBD1APpIT/aJMNjtcKP8eLEh7fAgYyNS23F06+2qsWU0NBuCOW01RlFL4OePTYvjso8YUfyvblCQWPZarFQ5Lv6J2NTTmaKXFmpFkycE4l0WUkVAVYQLQS7MT7W204sANDbtcl1PP8Shw6lCXhKVsIQI87o+5uJwsFbfYLF7jBbDjJbIy/9EDWWt9sq2ltKJkkvZGPzO+yJxzHIBkbvDtuaQI+lFV/LVGWY2Ku+EQoPZNi1KtK6CHz9gAHYeHvs9B5B0nLSA2LgH9KtIDNEHRXYWiJOf25opuFgomsJHlcj6bt1rthCkxCad4Tt+SDkALoenElhFvBP6LjyyUB8YtvJmN5qWuBHUtNv295Y9gQ3RaMhjJcuwlp4556afuZ3HoARI2uvQI5ipNIJfYkw7WJPmEpAs38fVgq4nw944huEIIAUNWvVNNx1wst5IJlbrAKPO3EmPr94DY4wvcL8UIMrp5tXP9ckuguUOyPy8yt6mktk3IS17gyCUer5vHjt//NCYTv9b5lGXo0ZFNa9G5P7znR3BgYA2hY2EOdPg71YRjEuwi10TaxMttMVxh6xY4kGKcnwkpzDcW/b33Z2joVyodrgAKlcnlNy8jLwiV5JmmgUnpjd4EfzKJo2HlEmxEUgDSPlMQnyikHaqYj7WZn2g4qMMdtBfcVUvXXg+EvoTKb8vgPP4p3Y2CWa8GbOsKlwPIqioXk5JsAzOmBAAM7eyUe/4S2FC0jQmFmk7qIi5izSlH1sWdK5l30iVBA1fVedczcpAStLRMpfklenyzIYAiWmrhu9eCvQq5KsakF98Sf7CCMUOoSIMsLKIqLEGPfD9XfUqyfurINyOoROUnPd0GZfm
 Xab5lNKY
 6YQAxPiqUA55GAU6JkuDUiO+AESDxJOKDB0ht/D8ja2aH7pa9Uws5BTfn97sI6zW4fSXcvYQ+HFnzl6/iMzqIZbRA2WWVPW+GuUGb85OGeQz8MQGiHVWcqrOr7W2rDXDhR1AsV9hCOnqKcrCTbkVsBDBAqUBrBZmaPzTJ+YrU8DcqNDtvm4dG8E6zWsn8YIgMVpltqA9yEKJSN00rfGj1DQa45+HXtARdkoH4mTSzQCfjiwM9iJ3eATOtU9da5w2/DK5qO2p7mznn2pwLKE+tKVTXuD5uEb+rraKhZg3cfcH/hezsYm1+i5AgXKHzMWtFTch798KCgxu8kWlP3IyCPix0RA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Fri, Nov 13, 2026 at 06:15:26PM +0100, David Hildenbrand (Arm) wrote:
>Unmapping a file PMD can lose concurrent stores when it races with
>writeback. zap_huge_pmd() removes rmap and drops the PMD lock before the
>gather flushes the TLB. Writeback can then clean the folio while another
>CPU can still write through a stale writable TLB entry. Those stores do
>not fault and dirty the folio again. Filesystem DAX has the same problem
>with its dirty tags.
>
>Commit 5df397dec7c4 ("mm: delay page_remove_rmap() until after the TLB
>has been flushed") fixed the same race for PTEs by adding delayed rmap
>removal to the mmu_gather infrastructure. The PMD path still removes
>rmap before flushing.
>
>Flush the TLB under the PMD lock before removing rmap for dirty file
>PMDs. Skip the early flush at address-space teardown, when no users
>remain, and for mappings without writeback, including shmem and device
>DAX.
>
>Use tlb_can_delay_rmap() to share the PTE path's architecture checks.
>On s390, clearing the entry already handles TLB synchronization, and
>__tlb_remove_page_size() immediately drops the mapping reference, so
>rmap must be removed first. UP cannot have concurrent stores from
>another CPU while holding the page table lock. Make the predicate
>side-effect-free and set the gather's delayed_rmap flag when an entry
>is actually queued for delayed rmap removal.

Right, I'd expect tlb->delayed_rmap to mean the gather still has rmaps to
remove :)

>Queue the folio before the early flush, while the gather still has a
>valid range. Keep batching references and drain a full batch only after
>dropping the PMD lock. The early flush resets the gather's TLB state,
>so draining the batch does not flush that range again.
>
>Although writing to files through mmap is generally discouraged,
>unmapping such mappings may become slower: each dirty file PMD now
>requires a TLB flush under the PMD lock. Future work should properly
>extend the delayed-rmap machinery to PMDs and hold the PMD spinlock
>across multiple entries, so their TLB invalidations and rmap removals
>can be batched.

Nice work!

>Fixes: 4b4bb46d00b3 ("dax: clear dirty entry tags on cache flush")
>Cc: stable@vger.kernel.org
>Reported-by: Kiryl Shutsemau <kas@kernel.org>
>Link: https://lore.kernel.org/linux-mm/aoWw_iKEDLjKL2jr@thinkstation/
>Reported-by: Chris Mason <mason@kernel.org>
>Suggested-by: Lance Yang <lance.yang@linux.dev>
>Suggested-by: Usama Arif <usama.arif@linux.dev>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

Nothing jumped out at me, so:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

