Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 617F0C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 15:45:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47E3C6B00D9; Mon,  6 Jul 2026 11:45:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 455A46B00DA; Mon,  6 Jul 2026 11:45:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36BA56B00DC; Mon,  6 Jul 2026 11:45:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A4586B00D9
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:45:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8B27E1C0C44
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 15:45:16 +0000 (UTC)
X-FDA: 84958775832.20.572B425
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 86FFA4000E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 15:45:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LzikD01h;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783352714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BezWf31aY4w6w/a+lqeQnI/w17h6Fee4KI8S5RVgbig=;
	b=jz61SzAtaW8Tvb3Wdtd4J5HZIXzSHv2yYOLkbCaqy5JInq7tBr5N21txDoHGQ3XCvzP5l7
	gRJiCb+swIBDxInp+aO717Lx6JEDRkFy5Q2+Q1SlBTMAc6QNpNIEM0hekt4PP8eKkXGYyR
	78bkcnJFc/xIqIzia95Vbzw6uVtbtXw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LzikD01h;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783352714;
	b=zJSARKb+kAiLIWNI24v2nUd4589YMfU4cog0JTlS4X5y5PSWRja05t6wa2Kcr97LKYBT4s
	qlg/rK7c4gPOZuQeS+P0qfjGiwcR/r3NsP/8pzwqsCR8LIhMx6PRVvpH8slGrlgEYsNZKw
	0sKMmHHOjmNJXARz/AXXtTSwgZTH0p0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783352713;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BezWf31aY4w6w/a+lqeQnI/w17h6Fee4KI8S5RVgbig=;
	b=LzikD01h9df9PpsXAUbz4ibuqHof+WSS5m3atqbe68qwImN26boxyatY/RyrS4ZPp1ZJGK
	m1YEbeN+Mr9Uw/Zpy+bNu8k67ZnREf+6b2FWk4fe3IUHQU95uZMSzir8EEvXxu6CLJNY2V
	1hvWkEzM87XR44fkAZn5u2Ljilpe1AE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-510-6sLrIIyvOgODbJ2HxQVQoA-1; Mon,
 06 Jul 2026 11:45:08 -0400
X-MC-Unique: 6sLrIIyvOgODbJ2HxQVQoA-1
X-Mimecast-MFC-AGG-ID: 6sLrIIyvOgODbJ2HxQVQoA_1783352705
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AFBF11955DC3;
	Mon,  6 Jul 2026 15:45:05 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.22.58.4])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 67988195604B;
	Mon,  6 Jul 2026 15:44:57 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Nico Pache <npache@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6/8] mm/khugepaged: unmap pte before releasing vma write lock
Date: Mon,  6 Jul 2026 09:44:53 -0600
Message-ID: <20260706154500.39178-7-npache@redhat.com>
In-Reply-To: <20260706154500.39178-1-npache@redhat.com>
References: <20260706154500.39178-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: 1HsCJASuIBOSiAQ5dogkAAbu22r7dtYicM77RXT2crQ_1783352705
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: aqpzae9d31mb7aqf3yfqc1xi4knay1t9
X-Rspamd-Queue-Id: 86FFA4000E
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783352714-887873
X-HE-Meta: U2FsdGVkX19dfZvkcDjOz9Jnr5yOPCO/GYtSrZz7C2NQ7xe0dYWYcs2ooUQO1czMm7i4Qy1AgFquTgizfqeaaIQGLro/K5bLCz4QznzOsjPbKESOK6irjGY2KxOdwq5lxDTRZASkfzYRWlKxupZGhGX7dP2SfA6TMB7hvhx+D97Va9Z9KZa8rlVKTGfhKUGkMu6b+lEm1TaMBkm6v8qmp/Uchp7XwuCvyiFrq2pxmFdTlcgJPt+ynoEHTfsDBTvmp4zHdovYwgoaKsKe5aUhaCcrpf0xYDsnaSgfjD0DvqlxuKZ4XHGM2EZc8RnxLeQe0o8m+UUtOU6Ydsb8jBUb4nzm1gxSB6mg/YmG3S0c2gzZVxwKXHLxeXiz5PLTFM0mvhaMuvh+fmrUTG1OqNkrBPUHTY98Xt7WOEgqnG/yormspPHWwlhjHbKnsLT2/Ic+Bqf/CqvbQ6Ob8MwlKgdw59EfPD+eukMDzQLlCtV4iCQejd/rpzJL0MPAE/Rjvw891gPW6h9DOarjSoCmeFgzbg36XGDoBW7dq7FZaKG1jzl3VCSkSmffoRZQpiEQHwgnyhNcYLB4hOnseJIb1fsZt8f1jb/9z4qCg7x1kWZX2BpqlbGNY8EnPGRm4vlNLo9oTlG/b6Cu/aDrJiBob++6qeZGNxoMN2XkQsSBEDv7koBeiwlka76Vjm9Cl0DQWH3ErbZ7+CK9OI5BI5sw8SsIbDXw8eI91R6u+I1UCW+fqtifrtdpsrE3RJveepn3e/T50eAPflw0owEARhz/1TCPKVduju+yu4GEUgQXIdy+Zb7nORJYpLA7wGPzBNKFSiEr8IU9DhDPvKJ5L/tmUCaiYtgHEu5RJbD7ZzGkbEKhqHljLjyqFXjyz+K7kJbSdGcv7ABhtERhPzlSZ7OY7rGujD1sqHfAlG3mtcM8y5xItxcyq/VlkNW3tT7z3/VR/NKqB4qGUa7pC8L18ywTGVP
 nwKbgc7N
 pGRzxLRwTLh8Zp6jZhPCkOcysG0uBl4EX8GhM1IPV53jd1894EJcgkZ9ySytD9QAA3KADo3YCFRIiACZyX4XptyRwNLunb3SSupDsc2adSHz6J0dDjKGlV+1qRpichIdNGN7uvPB6+ZbaNk+r1IkkcP1rAKzlchKp2v3kRymE7qdamh5cp8N0Q5jyctrcvrVjwiQHOORNOi4pguYVyp/kt7xfaHy9pKRn/HEA2QuRU866H8Q/wBtJ7VWOKQG3Nl/qYb5G/zVYAt7uhTkwgaaUzTEJ6n4/jh4UAuuNjp+6IGWYUViTOUy4HypEDr7m9W9/tAbzM2ijBoEsudMKshNyBxC8fL3HFrWYTYnb994G2X3r53M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We are currently dropping the anon_vma write lock before unmapping the
PTE. Although this is safe, due to us still holding the mmap_write_lock,
its safer and less confusing to switch the order of these two operations.

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index c4ea2dc1591b..3c6f1254deca 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1548,10 +1548,10 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 
 	result = SCAN_SUCCEED;
 out_up_write:
-	if (anon_vma_locked)
-		anon_vma_unlock_write(vma->anon_vma);
 	if (pte)
 		pte_unmap(pte);
+	if (anon_vma_locked)
+		anon_vma_unlock_write(vma->anon_vma);
 	mmap_write_unlock(mm);
 out_nolock:
 	if (folio)
-- 
2.54.0


