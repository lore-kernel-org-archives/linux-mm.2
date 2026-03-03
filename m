Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7602AEC0495
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:12:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC8C26B00AF; Tue,  3 Mar 2026 05:12:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA0686B00B6; Tue,  3 Mar 2026 05:12:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD6746B00BA; Tue,  3 Mar 2026 05:12:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ABED76B00AF
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:12:55 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 32E221403D6
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:12:55 +0000 (UTC)
X-FDA: 84504338310.02.F46A196
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id A3F8040003
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:12:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="p/+SabYa";
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772532773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=k+uFP62ViGukj8jARL8eAaQWP5rLX7quSPmfSuWUTXo=;
	b=10zhxVT4T+Ms3W/ksd6Us19FUQHcrqTeMvc2yyewWv5LNHwBGjww6Q3wCeXhUN9rDZy7N7
	LtsRZA2lwYDf1SQX9zd/Kn4GGqoH+v/kqhNkEFkNOBeqV3wFJA5zWnfkRF2BSt1yG6VLJs
	IcjeU1zFEfl8iKQndRw5MuCoDGosYLs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="p/+SabYa";
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772532773; a=rsa-sha256;
	cv=none;
	b=BGJgExX8naf30oFlWYiX35Pyl5BE1jBMWGGhpc+EbVKidwGP+YSyugltsG6/GM0B0urlrv
	midL2VRFik3L1jgjtBnSVq7DAqLpYPeyHYkSNZl4BGJBQcvzcdcrMA2VBtq108BDbeazrB
	Jthp2HlmmKhQ4TqSXPC9Ghh+dLw1j7g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ADB72441DE;
	Tue,  3 Mar 2026 10:12:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18BF7C116C6;
	Tue,  3 Mar 2026 10:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772532772;
	bh=QUoN8n5q5DF0utBmkEV5z51l/ueCTY4b7t6dkFsSAlE=;
	h=From:To:Cc:Subject:Date:From;
	b=p/+SabYaHTZfFnOfUY/3odZBn9WemruYkJV2T5ThkK3e0SZwOZZNM+cGmt9yDL0Ne
	 MkRFHkl+ea+dphYiXCnAbKLQs81zJUM2xhml1aHy9M2mXNd9yQ3dV1Dl3mYn+bt44h
	 9MhI6Th9CLG8YOXmGB4Bpv8VWFnFW+xGdOmwCRwqMzdqCQWvH/J2Ge+Q2kJi7PKhA6
	 6UTbl62S+sI95Np8TGNQEmQxUaw8vnRhIbvwnQzLbBD6ZnDFrmGqaXjOMpovyuy7iE
	 FmacI4np6IGSpWvRf1UKMk5ehTR6b0ChqF3uTXOFWpXEcbsfOgHYMRb9WRQ137kojv
	 AO5jF4tbZl3GQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: stable@vger.kernel.org
Cc: linux-mm <linux-mm@kvack.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Li Ying <liying3@sungrowpower.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Lameter <cl@linux.com>,
	"Liam R . Howlett" <Liam.Howlett@Oracle.com>
Subject: [PATCH 6.6.y] mm/mempolicy: fix wrong mmap_read_unlock() in migrate_to_node()
Date: Tue,  3 Mar 2026 11:12:45 +0100
Message-ID: <20260303101245.22290-1-david@kernel.org>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A3F8040003
X-Stat-Signature: htrtsdinmojsgxor36nhphim6hdpofoh
X-Rspam-User: 
X-HE-Tag: 1772532773-592494
X-HE-Meta: U2FsdGVkX1+uJztvCPDUReABGsqYqZhxRds3KKkgvQj5Ck0c53OGTpf5Y1HCQnx+slDCIpTA4P16uorTFe70hORf1qCxK+IdgfK6hdXdSyMChiaVk4SImLCBO0MD57ET/Yj8Z1OVNk+5sLMVS//UbBhdBufe96Fq2apc4GkFLdr0wHmzW5LHZWuuAL9CGviw4QSXXHnucZD2/FxTaU/Wf3TsDiLzZjSSq1gObfM3N/ey3k6dhusSlzSAqR5M0ZmjeN7qa4KNMAQP3CKcpJpYgq8HrbK28XMUbtUd6ba+rXRpbtY7Qc4PlOLsOb9mNb+k45WHUyn+xnPihVaJjw+0c9lob2l9cgxXGeRG4AnjmkZ6zCqDV4XEtq7yV2C6IELeG+nzBwd+gH8cgA7fLG9u1GKLz+1g+1UyxH2YAfkW4ws3H9NMlGk8jqCgkooAYeitpuNls1+NfbknPpGpJeOmupjdQ46bE+GHHayaZO+8x4YaU9Ias9+1PDRZxxMRP/vVeiB2CSycnAoeT2YTDvD5zFFAHlZjtvm9PxJ5VsXLbC7AN0fTkJRYcLt1HdHDxT8yPKEU7DTntTzjeEnRtIKX1ZaGUNEX+3tndja6IUJXyhs2GE+i3BEvZh+UyFYGQUXElbKVSwhhaaQeJq4fobzcId6iCtEL1vsDPZvSLFO/GpByajEn+PveZ8z+uxzFsrOprawRB6cNYQt09ev2+62AUOsI6jg/OZLKkAHGZ1ZdrJaD5rGpOB1mjuQHz17fBmbKo5J5qPnAiWkbxQNe9/tM0iQIlL4ztTykW7pIht5jV443mcIv2VocsdcetB/+R3iAPgJ6S/erp9YS+c85bb/RqtWHNV2sbWdJAS5ryostqCOdsbBGajAjpkE0KJ0P7GcPMeGOH0LZJjj08LHN4MY8lfKsdHMXYm1Tq1wSUl1rbJZOJETzvil21hVRkx/zPa108wCn8U7NGTiJr/igBcx
 I8nWe9BO
 rRdmy1KTsPBXFMFarQul531zVhnDjZH+SrKa+S+1abEb3EYtKAuQvvduDInNpoBroWn5i7/NpIv6MDFIqvBgOchauZ77UtMow5c2j5XCIJHLZohvaEfB1sHRYGvgGvvEMpNzOLk+Q8cLdPj6OECDKFM1gUTbWweR7/XU2gMTTeJRLlPOEkvm7AGm3yyzh9uJ5GdrujrQKb5UtccMdgDVNaEO23Z6tpzrAQeDSllVSllirzDj3BIaBuU0FF3GLNbHY7wjFOx/YX87pknYD6F+r0rW3DZbW1JV1M4qdwi5b6q61vYwH9qgjmd4SKP66TYfOwDyC0ZEMRQUaGazzuscrUBH7S9l6mCpzopXslbdXjE8G8xjvZFnhAbDd3JuOSZ1XVsYay0GRNLJZTSz10OXbC3SZIewfHU1fdthxhpNNcvEXarO+MHwR5oMjabwwna8AdNM09fDoY097+MvUwfsKqWFxjYhswNrXej0AersXX5k4IT0iW35gf9MOQAXxdy7RdAozPSYU8SQFMe0cM8tLts/2t6PSF+HXgTJjbo2HeUEr1g1SHCegI4Okc6pN6AsI8sZB5OThqjk31DOIRZ6DbxkPDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The backport of commit 091c1dd2d4df ("mm/mempolicy: fix migrate_to_node()
assuming there is at least one VMA in a MM") contains an error:
migrate_to_node() does not lock the mmap_lock itself, that is handled by
the caller instead.

So let's drop the wrong mmap_read_unlock(). Fortunately, this path is
very hard to hit in practice.

Fixes: a13b2b9b0b0b ("mm/mempolicy: fix migrate_to_node() assuming there is at least one VMA in a MM")
Reported-by: Li Ying <liying3@sungrowpower.com>
Closes: https://lore.kernel.org/r/aaZgUNxAyKC2IwuG@casper.infradead.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/mempolicy.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 94c74c594d10..d8007e1c2690 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1071,10 +1071,8 @@ static long migrate_to_node(struct mm_struct *mm, int source, int dest,
 
 	VM_BUG_ON(!(flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)));
 	vma = find_vma(mm, 0);
-	if (unlikely(!vma)) {
-		mmap_read_unlock(mm);
+	if (unlikely(!vma))
 		return 0;
-	}
 
 	/*
 	 * This does not migrate the range, but isolates all pages that
-- 
2.43.0


