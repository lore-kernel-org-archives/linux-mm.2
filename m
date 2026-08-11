Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 477B9C5CFC1
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 12:49:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 885116B009F; Tue, 11 Aug 2026 08:49:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E6ED6B00A0; Tue, 11 Aug 2026 08:49:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 688A86B00A1; Tue, 11 Aug 2026 08:49:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 472AA6B009F
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 08:49:42 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C2D921A03CE
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:49:41 +0000 (UTC)
X-FDA: 85088970162.20.918610A
Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0C8B140008
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:49:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lWAWFvri;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of nico.pache@linux.dev designates 95.215.58.175 as permitted sender) smtp.mailfrom=nico.pache@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786452580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XVQSZpjAJnAABJI67TTQSmMP8vAAvmycYzDtMVPpcHY=;
	b=KhDvSInyIBA/N/RF5JLqepzHrYZPjEJl4aqM/c08KiabKOWuoI163qLfCDrjo48+gGXfRN
	XOo7Af1VTBT/iUjYfsSc/T+n7Pftgfs1sqd14KPBw7jiNqWnwMPwhvAMM94HoBTBkS+ggJ
	Nij6mRgzrSt5T0yXoVr2UufHt9zsA5M=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lWAWFvri;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of nico.pache@linux.dev designates 95.215.58.175 as permitted sender) smtp.mailfrom=nico.pache@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786452580;
	b=uYNdLchkxAy+uhm9LeTPAqjkyKo/kENY6au/9AWpl2ZQhZUP/XcIYhYWRvL2om2pUVqb5f
	T4OaMkYyQ7CTAEBnJS5QvOR6Y+vReXv57gqwDGtW8xXzTCOBIzbRf7iKbB1t8ArXPOcnlD
	63s5PjMSCtn5yAqL//a+NNaEFvtn50o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786452578;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XVQSZpjAJnAABJI67TTQSmMP8vAAvmycYzDtMVPpcHY=;
	b=lWAWFvriFfl0cp/ibyF02UZQtwwi8SZU78mlgDkb5+DPPrtWhX1LpqJOka7Ib1yAOuzW9c
	vWAxwBpWMF2uFziE+mhQS2TyRonP9r4qfGbpZjaHLIOgeK8UyrqjYcxktVSHxmWakzBggR
	dnvIh6NXuT5Lmo8vmyGzLtnZgMuTQys=
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Date: Tue, 11 Aug 2026 06:48:38 -0600
Subject: [PATCH v4 6/7] mm/khugepaged: unmap pte before releasing vma write
 lock
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260811-khugepaged_pte_refactor-v4-6-ddac39d61c4a@linux.dev>
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
In-Reply-To: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 "Nico Pache (Red Hat)" <nico.pache@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: x3gmb6gzykf44zzxzf6xphxwqzx8yfb9
X-Rspamd-Queue-Id: 0C8B140008
X-HE-Tag: 1786452579-727752
X-HE-Meta: U2FsdGVkX1+1bl+y6hPGEHkMCQfw9nhA903mLLs4b/b8WWknG1XB2UYIepMuo1xWNth0AbkBAv3StqQXROhzX/VI+NDL1JQ+qFJP0C43pclFCtnH74LkCNQfq0RqKTjEe+EFaEWGnhSbTxEiumG9EgHBK+sbeSsGVBTnbYxzciqey27SF35kx1dUw7EaUJmVxMAYq3rNSWgQAX+8lQ5P5eeBA+GU2XoP61lnUW0eQ/tfgAAO8sEGLIUFopH7tDW5e255IUmQZ6YGyGWk5AYQw8MU3V1L28UnDUwJCrrhDxzWBXhJtImVJnZ0lIsl29Yj6HXN6ifSUg7lM31v9wrXmxfuT4uB+QrlkLyee4TccRedYbEIiUI5wmgF0ex/ZiD2p7h2UJAX2iBYdEz5J+dLLY5sLF561vAcwxqZkq/7W9paKgFk4xCPcFKnf6EQ7DYGMHlZLAcqgqTnXjQhQSbMCgutn6ARht1+09/vZ5CfX/Cylp19QK6vTjy/BbY5BQ7p7lw4MSEp8Qtc9/7fWlMqPTQi1GNIX2hC+KqWIGayNwaHoV1RP8CPhRkwxa68V6klkFr59zTG0wkkUsxF3EeMfD/0fR61dIXk7RhfH4UlFCupEw/I9BRevGBuV945oJNa5WR2vFW8jXgcVz2k4iltUEbMJ5dS2JSvxIpSlZDo+t8G7WINcBWaDUO+t7amXoHY56+9BCDdNQa2zaWuNYXlGorBrv7pgrUV+f0+j2RQUaQXRBGRkH1dqgvBYnKXzUKwzLCOTG697fvzHmZxbzOl3Jnd8kx3fT04DNS2IPAoU2etaXpD/QcZ5xr71EHliAVXlMoHyKxokNg9QRHjud06D8A5sjL1EI1iKzdIq4xRsrUEYEs7ReviTDt6BLmcpEayf8NNAgfCo9l2GVp+nJRrbgdhLd1uAIp4H0Lsb6Fo7JpOFopi337n63w0cJ5IJzIEH6npK7F3sUPXrdwIX/m
 GZcz+bOW
 sh9POwMSyhMS5pvdzkdZMXJhS8KKc3CG6Fj52GYZTZlNLe2fMS6yLg3zSYdOhNklxeaL8WvQE/drbya9y3vLrR2GLgB6bGlDFzw5ilidEIE44gxpFSxcvKPNaTyAJeZFQml9NCCp8ZhDHoqKP3j1ExqJYNC8JXgg6Dv2GqTIQJsUBBzu0uSgfsu7POPbgrHI/9FhgCCb7d63onIdsZVoGSa+n6vgXY97H2D5DU4wrOjge5Vg=
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
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
---
 mm/khugepaged.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b7372aba4417..0ba637df9c48 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1546,10 +1546,10 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 
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
2.55.0


