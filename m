Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 731F4C982EE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 13:17:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CC446B00D5; Mon, 21 Sep 2026 09:17:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47D0B6B00D7; Mon, 21 Sep 2026 09:17:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B9B36B00D9; Mon, 21 Sep 2026 09:17:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 106346B00D5
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:17:52 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 790541C09A6
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:17:51 +0000 (UTC)
X-FDA: 85237821942.14.5679DE1
Received: from mta0.migadu.com (out-201.mta0.migadu.com [91.218.175.201])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7EDE31C0006
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:17:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E4vNZoGT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.201 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789996669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e7J3QTjTF70u7VTLKk+bXscovi5fNJVgb7m1iXC/1ac=;
	b=pK4gOP0x9CqB6tiZymxmEfLfKXEX3kfd2W7hiT/FE/j3kvZARJT1/2AG1sCtSHRwTPctgh
	QJDGbMAHCdMZCpP091ok1u3unAbUYfpdZfFBZa251qASnQMIZvvQqJp5BNC4BPt7EULG22
	F7ieQ+IAQOmbtoAbJytvviOsWwvpufk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789996669;
	b=YiGW66H8/kXYZ4KNY+RYnb/klsR54zffbifKwn3xEaRHsKh9bc9SQrIuFKYzsaA9ird8kZ
	fyp7VZo4U+D8yWgswGsxCjMmG6ThUyTni9I/GQsuns5/MCv7HFAB8QyoA1ftc80qmE6SuB
	HYTzGDHroqV486SzWp/khWW+UEco+WY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E4vNZoGT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.201 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=TgBqgmk/OGkiRG4oFsrkPk1fFb54WBL3zueWiSKqe7I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789996668; v=1; x=1790601468;
 b=E4vNZoGT1Z9K7ZSq8aTtO8JWLC+bxKugBY5+nu/e0Zu3M/HhYKxssxvflfUQqzbWM2Sqsywx
 4uitAdpslgeTvro0v2ET1uPLP9ZOv/xjnkybrDjkoDcwmX9b4o8R8L3iFKziwWVv8bw0FRMvnus
 Ih7RxqEmgQ1AADo942YiqV48=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f052238703df67d5;
	Mon, 21 Sep 2026 13:17:48 +0000
X-Mizu-Trace-ID: f052238703df67d5
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
Date: Mon, 21 Sep 2026 21:17:21 +0800
Subject: [PATCH v2 1/3] mm/vmalloc: fix vmalloc_dump_obj address alignment
 for last-page lookups
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-vmalloc_dump_obj-v2-1-73fceb3ed1c8@linux.dev>
References: <20260921-vmalloc_dump_obj-v2-0-73fceb3ed1c8@linux.dev>
In-Reply-To: <20260921-vmalloc_dump_obj-v2-0-73fceb3ed1c8@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, Ye Liu <liuye@kylinos.cn>
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7EDE31C0006
X-Stat-Signature: 8hq3yaufqi1cr79iczxjcmwaj39hbrwa
X-HE-Tag: 1789996669-212844
X-HE-Meta: U2FsdGVkX1/gEg+F/4+H3TsaIJuuzE1yrCFgVU28bj2d6uZQwCb3e/Z7HnzvdYY4txIvSdVOLe5X+Tl7YE1h0Q2UqzUvN3MqhjZbNS6QgIkXx9y6MYEJc+TxL8dzuZCpaYPWI9Kj3MxActKdH51Y4R56qTagqCJqTQcAmmVpweqwTDys9t9PIUvZF6CJ/pV+SBPMXXE/4l+0syUhagPz86LHVun+tuHXGvbGlv/uwEpzW8p3OxVHGz+c7s/dOQpa54idIBu8EJRwsEUg9W2EvNOfrGiZEHvcFPs5zfqWwGVQTFj2G6tMgSRSfoeuYKC4orGyBcqUHVABATWUxE7QmTVNOqTqQZsPLqrOoa9vlv25TZXHywlE3hm+6soi2UX7FcW1uhJs7hScK6in8gVox1pR5w4Md7DqHovh98brY+xb6Ig4UbGh7nMkrUgNXDrI1GThpnTR/y9u1K1r+fl/zQj0qukxLHK4JodL2pQJKMH+GokSFD0TMIyU3D3gzPjyQE4PTWLLTHCS8y9M+HH+kSeFx//qMxmWLa5YEa0vl/Eo/aI5/JJsn/5+BwGxTektPni7tCXyaOPT+gJ5wseFtoU0840q3Uyq0nvmJ6lrZ1jr5MyVYiEUFzLJMylxebosOhGt7Z1AkNm4piHihGgg2E7YPNUwxArVfm4RYmCFovYf584AniiprnzCLIZSWw/1Afr6k7Pjhs9RPIIeDuBt7yPtXF+p6hOAaZiZh2QWpBuIPkdkg57ZI3HNUmhV6NjdZPjWgy+bjvwwleRI0yTYsojWqAt+Htl786r3VgCHi07YDeP/tBkOQhKCbV9YQkNOqrCq9GuvJQJd5lVehH3Cjpb1niaJGfUIM4xyvXTxkzQ833oOwM03EKCSchpVR/qAWwgA4KGnHNR1MOZFymw6BEX670yUuBymH429r8xMT2K1v1/K+u7djpTuQ/XYAr6GLqo5c+Qkszp1xOH2R00
 EMFJZiWE
 /1wDzHCwivG5E3rp229liHy3F6zueM4/U1Bzj6lZ0rnf+0qX9wC5KRDZV9zumZAuZpmzjoUB4GU3Rcv+cWKp+7ORb4kqyvhLvVxmqSmOhCPSIrrhC0UfLWOS6UrPecpL2jIUEGpwWy4zG2QqmsvcyvzSmOcrk4r0MW7VdkZUQR0sH1Z4xxljzA34+s0c4XePkpl0NxdsgPKvcW/F4gyF1wBTQWURXSutzkfrB1qUqPAiFE3z86EnIplSrLU/zRZzpc0bGB5Xew1xnBepuXRK4Sr//LDscwpu0OtLZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

vmalloc_dump_obj() uses PAGE_ALIGN() to normalize the input address
before looking it up in the per-node busy tree.  PAGE_ALIGN() rounds
up, which can push an address in the last page of a vmalloc allocation
to va_end -- outside the [va_start, va_end) range that
__find_vmap_area() searches.  This causes the lookup to miss the VA
and return false, degrading diagnostic output in OOM dumps and KASAN
reports to the less informative "vmalloc memory" fallback.

The upward alignment can also change the addr_to_node() mapping when
the page boundary crosses a vmap zone boundary, causing the search to
hit the wrong node entirely.

Use PAGE_ALIGN_DOWN() instead, which rounds down to the page
containing the address.  This keeps the address within the VA range
and preserves the correct node mapping.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 mm/vmalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 859e6d2d57a3..df42d8a6f058 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -5277,7 +5277,7 @@ bool vmalloc_dump_obj(void *object)
 	unsigned long addr;
 	unsigned long nr_pages;
 
-	addr = PAGE_ALIGN((unsigned long) object);
+	addr = PAGE_ALIGN_DOWN((unsigned long) object);
 	vn = addr_to_node(addr);
 
 	if (!spin_trylock(&vn->busy.lock))

-- 
2.25.1


