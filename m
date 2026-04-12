Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21043E937FC
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 19:00:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 870696B0098; Sun, 12 Apr 2026 15:00:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8473F6B0099; Sun, 12 Apr 2026 15:00:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 736626B009B; Sun, 12 Apr 2026 15:00:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 62A976B0098
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 15:00:33 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2BD4713BF94
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 19:00:33 +0000 (UTC)
X-FDA: 84650819946.20.F5F6AAC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6F7592000A
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 19:00:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g1Mdcr8m;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776020431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5IxD4T2BKcSgf21/TO78D7ZWesK+YyElZlffCFp5Rvo=;
	b=77I8rtiWrNzB6s+PY1Y9jWZJKwfjRj1SuC0zgus2PsDHuVWB8Q8qIfuKEk2eOb/6qKSUHd
	Pe0Yu5LzrccZTpSSkGyPLEgmpJqArN51bdkrbtndKu4QxeMXOYl7TffAZe4z1wM9Fx7Qbl
	QKAsvbn1m1vEo3kP+V3j31ZIHORJ0Bo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g1Mdcr8m;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776020431; a=rsa-sha256;
	cv=none;
	b=SM6MiV1UEqU2Hd7ssSFcaxkIUekTmUPKIqaxZ8T2U/w+w17cP3Q4H8JAW1qbG+Og0Z8Noq
	T6pnVXVh/2nPkcIvPN6EbctC+WOOL0ra6ubW8N7MLZMIAzoGnbqLHLMoXwC91ieaAEVltF
	pB5ngPdJXNvxln4jdD6soPty1sgpNc4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 86934438E5;
	Sun, 12 Apr 2026 19:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EBE1C19424;
	Sun, 12 Apr 2026 19:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776020430;
	bh=9fGCFaYmiOtu98w+dglbaRj6ZG+ZWxVZAKKzaNaEbNg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=g1Mdcr8m9w7rpzRvM0fQIY2TqEIxFWCbJvHebiQ1yaz3iHjfGIzQ6d7f9BVHqVUfh
	 88PYtztAGsZyme1f7JwZDPM2SNqpx+8kHfYLjB+ZFfGuncAH6CfOiVBKIOeXydPqHf
	 IsZp0OXlC1U9E+vZ19Co1+jH3WbFK4JnvE6aamisFIb4yYtuJd+D78abLTosE7BKnf
	 NSdHKqDAQsxzNAVb4+tvJj9cqVSRo0udtgc/IHttEB6zXwS2RAjuCL4xCYxHsXmxn+
	 pDjNju6dFJzV1pqZNO2lRo5vMiF51KiR7R+q5OtLmYKJMyqDeXfvLg0KfI8kCBig5V
	 5uWq75wKahseA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sun, 12 Apr 2026 20:59:36 +0200
Subject: [PATCH RFC 05/13] fs/proc/task_mmu: remove mapcount comment in
 smaps_account()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260412-mapcount-v1-5-05e8dfab52e0@kernel.org>
References: <20260412-mapcount-v1-0-05e8dfab52e0@kernel.org>
In-Reply-To: <20260412-mapcount-v1-0-05e8dfab52e0@kernel.org>
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Jann Horn <jannh@google.com>, Brendan Jackman <jackmanb@google.com>, 
 Zi Yan <ziy@nvidia.com>, Pedro Falcato <pfalcato@suse.de>, 
 Matthew Wilcox <willy@infradead.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-fsdevel@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspamd-Queue-Id: 6F7592000A
X-Stat-Signature: 9azaoswxti9uijz48r3779nfu31mzjn1
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776020431-295519
X-HE-Meta: U2FsdGVkX1/ufJKj/Y8XE7tITwtBjceDYJbOhkv+8JemNeMiCUxHN+Dg+oYg+TiWg3bjuWSI4qhl9DkyqZnB9O6rzzPAm6xDt7jctZFpLxSMASLZrql83aPW6eQxn6EdDmVZzOw/OsxBvMxYD28eyqDMT6S4qNtewMRhUQBE1ot8Y/tzIY2TPfSNhpJa3v46RkUFTH9VvUg7cRhIaLX3SWp1qAzPxBFdrKOpKxpDQZ7AUL9qMSizqTz8MEb3XsW4gOsPpUWF3KKTxOxotNCmmBDKmnvrWPAQbwrMe4l5rogQpipmPGoEXo2Dg0XRo2hMQeb2SarGWDzbR1uwHs0cZYAw+kmugdNzOD5+7Che+biheZSywEYA7IUnQgvCOkfq2UBzrS7nXv23jAyPBK+31oqkEW/LWPnwZd8uD1Dzz91ZdeUljKidhtsteeEmWEHVhaYpP/MEr4/1FrllHXyfhngCqsZWY1iKajvX43yxmj4sA9KyqgJdv0ceGhBke1HLuNRPmkei2IW+6ObZ4LuEVTu3slwDf1vDWVFYtH/g7iT0tEDbHQcv0twbVWduhQp/Fe5kxLELqZp6p3yM0zg4B9l15crNSWmULtQnAgrNTe0XEIh3fd2YdeIbYVCLJXayK02fa0pykaIW2oWQwKMq7vF90qHSZ+HaXMPMUe9P98EolESXmeeJnKgM0Zexf5zglA6N5XfLHcw/kZfQHYW4CCB4Wlvmc4I0Q0AkfufeWUVLMVtFwyDwT0rNiReBZMUhHD4IcTGAbtTzbbjgvEkix8taNIgfQY/7MmKr4oVXTK+suMNL/YbjHSApILM5mU35JPh6Bqfmm05G3AP0bj3I/AQJ23rHV3Uno8a2cCCscpwy3lb/EMPSJELteMluueHhSacCEseCj9ZmW8VOK3z8zRoBXxWCGzTkyBpD9Ie7qod0usbwgCwPpz6QkDUAY+nXiaTQ8XrdcZy+wi9Z4pQ
 bTOMnl6u
 IeC/DJ7xztDWL3sIkFkgi7TMC8PilYR6MkHYCv4pI0fpF49q5sltBtxXlyf7iwND59oGu7O5XXrTUIgH1KXI0dovB6G0T+xc9kHSazlf6yQkdwvVVYsA+kvSrS7KmzlHKk1bQbS767aeoHreuWBBnvRtlVFYeHoAgAS+/dW6Rpp0DP2RsjMk+kVGfNKqOWrFEOokGADJmbuVB/HBGMWXqLUSq4Rga9wW8HODhC2HAkaUWYB86BhdHRN8geiL0gRGkiEbU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reading the mapcount is a usually a snapshot that can change immediately
afterwards, except when the folio is locked and the folio is unmapped.

For example, nothing stops other folio/page mappings that are not protected
through the same PTL from going away; the folio lock cannot prevent that
situation.

Let's just drop the comment.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 fs/proc/task_mmu.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 1e1572849fed..55b037768c60 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -968,11 +968,6 @@ static void smaps_account(struct mem_size_stats *mss, struct page *page,
 		exclusive = !folio_maybe_mapped_shared(folio);
 	}
 
-	/*
-	 * We obtain a snapshot of the mapcount. Without holding the folio lock
-	 * this snapshot can be slightly wrong as we cannot always read the
-	 * mapcount atomically.
-	 */
 	for (i = 0; i < nr; i++, page++) {
 		unsigned long pss = PAGE_SIZE << PSS_SHIFT;
 

-- 
2.43.0


