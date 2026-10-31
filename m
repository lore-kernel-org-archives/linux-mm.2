Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD782606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 04:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=obcdZO7I
Received: by kanga.kvack.org (Postfix)
	id E56CF6B00EF; Sat, 31 Oct 2026 00:34:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E058B6B05B4; Sat, 31 Oct 2026 00:34:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF48F6B05B5; Sat, 31 Oct 2026 00:34:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AD1C66B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 00:34:19 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 279E0120460
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 04:34:19 +0000 (UTC)
X-FDA: 85381654638.12.A732637
Received: from mta0.migadu.com (out-60.mta0.migadu.com [91.218.175.60])
	by imf26.hostedemail.com (Postfix) with ESMTP id AEE7D140008
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 04:34:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=obcdZO7I;
	spf=pass (imf26.hostedemail.com: domain of jose.fernandez@linux.dev designates 91.218.175.60 as permitted sender) smtp.mailfrom=jose.fernandez@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793421256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Flx6BFpBHU/1mQwNgXF0H0qYyTFKKY1odWtVjJY4UAU=;
	b=YiTPTuSlSKYaq8pXZJ/8HOu9ju6v+mSXP8EH8Z3jWoziZs//Y++LIat5ZwJu0NJMamNI3R
	2d1qBwbdK4FeeAcbL8yG8VpfKgSyHBMU9o2Sv1ABRF+LWUSTklg4f46nc4VmC2s3qvPfOC
	6PIKQdNsfgYP91JkjizF5+jMYhtQchY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793421256;
	b=NHJ8kIw/zR4tRU5mNRN4XLYqZgrc9sRz/HwQeHq2rbaKS4KAnUuOpnV+/tx16KSLpu4ZbG
	wD4z6QrlqkgvxeSpBHuSs0mxSWTwIlii0pxaQ8KkF5m47fpyhAjf3iRXJwusE8KtO8htkA
	TYKjil7nA2lif2X04it0J9xtMYMaoPs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=obcdZO7I;
	spf=pass (imf26.hostedemail.com: domain of jose.fernandez@linux.dev designates 91.218.175.60 as permitted sender) smtp.mailfrom=jose.fernandez@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=sRRglwrZgXV0SrK/OtUomTWdFA+5PNai7nUeEM2ufrs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793421248; v=1; x=1794026048;
 b=obcdZO7INN1kPM1v5GvlYd70X42q221riOIqjegL1GE8Y3xl3zxAacC/Om/Vt4G8sfHmhE4V
 lrkL01cLaRw/2ZGemRxFlg1/kqalN891kSFL8xTDO1sd8izjxcLdmV+CdQHPgbbOizq+5r0xXIC
 hNBzQ8+9eLGKt+aU2Pk/L5sI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 84ce8c3f7c47124b;
	Sat, 31 Oct 2026 04:34:08 +0000
X-Mizu-Trace-ID: 84ce8c3f7c47124b
X-Migadu-Flow: FLOW_OUT
Date: Sat, 31 Oct 2026 04:33:59 +0000
From: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Krystian Kaniewski <krystianmkaniewski@gmail.com>, 
	stable@vger.kernel.org, "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
Subject: [PATCH v2] mm/filemap: stop fault-around when the walk steps back
Message-ID: <20261031-jf-mm-filemap-map-pages-lower-bound-v2-1-21029744e589@linux.dev>
X-B4-Tracking: v=1; b=H4sIACVu5WoC/yXNyw6CMBCF4Vchs3YSqAmpvopxMbRTHEIvaUVNC
 O9ugcVZfJv/rFA4Cxe4Nytk/kiRGCrUpQHzojAyiq0G1aq+a5XGyaH36GRmTwn3JRq54By/nHG
 IS7BIvbqy1aQ7c4NaSpmd/I6Xx/N0WYaJzXtPw7b9AbLiH4eHAAAA
X-Change-ID: 20261028-jf-mm-filemap-map-pages-lower-bound-a623ed8a81c9
X-Mailer: b4 0.15.2
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AEE7D140008
X-Stat-Signature: 56167pq1rdn3rqordrn7fg8f736x3zxg
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793421255-972585
X-HE-Meta: U2FsdGVkX1+uoQwKTR7AU6DQITqwc41uXTnnYWK3XIPu5NbfVrg40UvkQcqQdhkMAvMcE5Tj4IXa1KvCHXwc/gvusg/Udlltao+mo+IfOXOHL2Y5ZUQAsttGszRoSYFfjJGkDWpRx2HVj+ITpFSyyZkYJ5XiCLiOGduFL9UEaDYxE1pElkSNxbttRRbOf7QhQZ43rnr4bds7f1WRjZ+wVvJgxl2T6Z43+6wCc2pBJDqci/Vc19OriEzSnS6XxRH/OwXBNtabj28p30Y6m9Hijaob30yD3OWwEXa7+Yqn1VMqZMP8fNZl2SwvIUwL8F60dXx2IWozyDsbDcRXJVNemAxs/swVhGFJ6YUJAk7Dm2VaZRo55P1l/NGyxwbAst/vleXTww2AxTC26C1BVE3WD0mFmGc/+QpY7S1PCBu0JGVtU8dL3hYNjfDBB/Lc44rqsSaDN+8dFImX7VF/hMA3PCKrzRLofBAx/fS+opzdvqkwW9sWjNRWeBGjREu/gAFr+46HDkNQB4SdpZo2PeOn6qxJFzeLJoJsTExswuxVZH9xEba/zLLjj0r/x8oFzWSPOIS7aGNJD56oRlcghyrOGUERdTWZPUUcWskoz/aAwO7/JQ9+f8ojD3t9uvhD4BPuKg8pVnTYP6h98oiBhKdR63J4vB4YQnSwW6+YMQnMqMUNNs1g295ecd2Ix8I8z5GB/+abTil4ICnbDEKlqaGuFDBXo7LSwGAT/9UuWCGTefUvQOEabmCwpPS3u55gxEczVgp50UARV/BD2rs6wKQOWmd0VtJjbxtltXTYPSfCF37b9KqhTHakLDbGvtD6vNr1FPBI+K0eh+WNJeGMSRCZfMrBnICc63gnIS1JnG5dJUt3ILf+MQXKdb3Iua/SQPbLor1ew05s0QtdvDJyqYI0wL9lcDsTUp4zSZH5RqOmaOf8I8uoXvayJBOtfyXG5x6M78ehYCOyXL/JLz9Pduz
 PB5vv0qx
 pnW/531hTz0ZdX163ZWpfWzDk/kTp6/86VkGkaDwcdY08C6hMbssjD3THq99nABE5b6i6lH+pdZ1erkXDH5GiVyY4VQBh40h82wGRG6+BvSFDwYRfy014/YXoYHVpLIZrpXrsChET+ARaMgaVL3Cuuac6+ZuW3vPQ13HbSJKU7Ci1FT7yJgMhREnf0Mpr6747hT0af9/aOeVQbY946zAjOMREE8xYWcEXb1zgDXQ8+ZMp6qevebIER+sU+m2cyOHtk67VzAQGcjodEzX4oA6f8JExZyJZoo2Sc1OvxjD/Dqd+GF/pLk+2e3q0ZeMnUMqbYg22PE3AVH4E9X56vtf9zQxzNIK6IdCzdBrbdZh3AItvhPx0Dr6Y16n5IA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

filemap_map_pages() can dereference a PTE pointer outside the page table
it locked. KASAN has reported this as a use-after-free read [1]. The
same path can also write out of bounds. When the stray entry reads as
none, the fault-around loop maps a page there with set_pte_range().

Its fault-around loop walks the page cache and moves vmf->pte by the
change in index. A lower index moves it back. xas_find() can step back
to a lower index when a multi-index entry is split during the walk.

[1] fixes xas_find(), but the loop still relies on the walk never
stepping back. Stop the fault-around when the walk steps back. ->fault()
maps the faulting page if the loop did not.

Link: https://lore.kernel.org/20260904121301.200049-1-krystianmkaniewski@gmail.com [1]
Fixes: 6b24ca4a1a8d ("mm: Use multi-index entries in the page cache")
Cc: stable@vger.kernel.org
Signed-off-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
---
Changes in v2:
- Add Fixes: and Cc: stable tags, and say in the message that the loop
  can also write out of bounds (David Hildenbrand).
  https://patch.msgid.link/0a1ad7d2-ff0e-4248-8f03-2a64a9134aae@kernel.org
- Link to v1: https://patch.msgid.link/20261028-jf-mm-filemap-map-pages-lower-bound-v1-1-0bf126e876d4@linux.dev
---
 mm/filemap.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index b74bc1e5015c..1df776907140 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3968,6 +3968,13 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
 		unsigned long end;
 		vm_fault_t map_ret;
 
+		/* A lower index could move vmf->pte out of its page table. */
+		if (unlikely(xas.xa_index < last_pgoff)) {
+			folio_unlock(folio);
+			folio_put(folio);
+			break;
+		}
+
 		addr += (xas.xa_index - last_pgoff) << PAGE_SHIFT;
 		vmf->pte += xas.xa_index - last_pgoff;
 		last_pgoff = xas.xa_index;

---
base-commit: 65ba8f34ec886ec72b2c07ddc8cf3d815c32869d
change-id: 20261028-jf-mm-filemap-map-pages-lower-bound-a623ed8a81c9

Best regards,
--  
Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>


