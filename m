Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0D99CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 11:58:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43E3D6B00BE; Mon, 11 May 2026 07:58:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 415AF6B00BF; Mon, 11 May 2026 07:58:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 305336B00C0; Mon, 11 May 2026 07:58:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A5DC6B00BE
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:58:48 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CFB24C1B5E
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:58:47 +0000 (UTC)
X-FDA: 84754992294.08.A7CD5EF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 00A27C0002
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:58:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J6GMfdxP;
	spf=pass (imf10.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778500726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1oj3h8HqpoRcMXXXVdigFg4x7AxtHA4faIQ7hwZet2A=;
	b=EpZdZiJr+HBwUYrlrQ+KAMLp5mw00ziWJPaws5IzXA4d/wD+1x8/gVaCBHBJ1bAHzksQ9Y
	0vuRGDg1ooncPHjg0t6aGLTwSJ6SPn2w1wYqLpI9CuL2PG5P5F7qjZAiV0rdfSskgiHU9x
	HIhEJ+LjRBWR2L/9jg2rgxmOSHfn784=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J6GMfdxP;
	spf=pass (imf10.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778500726; a=rsa-sha256;
	cv=none;
	b=UdCOpWsLG3iF3slxsTyaLjGS1++esugoWGK9kw3q/7ZPmimwj5A+P2xj6MzUBDFxNCHPUc
	JJy1hDHCQZxbOyJbgDsKK6cmkO7jIzmjVxa07Ia2TWLWU67Rzv0dYX/KKXZcT2XlMdmhdF
	/P3StYGU26Df1M5WlmA5uYXfaEYlGsU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 29A1D43345;
	Mon, 11 May 2026 11:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45600C2BCC9;
	Mon, 11 May 2026 11:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778500725;
	bh=6R6WN7QnLwKTUc2bC5H1Z4sYb5q8DLb1p7kKZ09YbHE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=J6GMfdxPoBnkQmf6f0ysMCxxkecaXuPL1FRe/aiVrCN5gHGBTjTiKh68s35ujlkI8
	 IFTxsjnaWspo9Crp/8/onQdUc29YJ2cC1leVMEWUgg3iQRFbS6BqXBTf1pzQyXb9zu
	 1TJEDr4uHdSm14vLZestczhSe5bI4gk+bYeDiTamxaxcmFD3ufe5Z0FH+mkvP0pqP6
	 +vKQ3Y9nqcJnXu6arPhEV2ZkErOz4AoeUxVv3yWaD0La0dBQLh3jxX6MZzTF7JDKt/
	 2TawDzCykxEPxi7s7cha/9G+B1ZJS03E+KNokDphYSkYciRuJio2XseexZ7yolfQtJ
	 0dsyFjuCFieog==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 11 May 2026 07:58:27 -0400
Subject: [PATCH v7 1/3] mm: preserve PG_dropbehind flag during folio split
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260511-dontcache-v7-1-2848ddce8090@kernel.org>
References: <20260511-dontcache-v7-0-2848ddce8090@kernel.org>
In-Reply-To: <20260511-dontcache-v7-0-2848ddce8090@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
 Ritesh Harjani <ritesh.list@gmail.com>, 
 Chuck Lever <chuck.lever@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nfs@vger.kernel.org, linux-mm@kvack.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1084; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=6R6WN7QnLwKTUc2bC5H1Z4sYb5q8DLb1p7kKZ09YbHE=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBqAcRw/d2G69PENt9dpII3eX7moPHrfcJfJVKpz
 U2jJnpt2f+JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCagHEcAAKCRAADmhBGVaC
 FSjED/9B+1yQ1WSrNNdIhOxP4U+WPleq5eEldlJUXnR4U9UuQ/YPgnW30Hq1QkSq5ty0m8y/KE4
 AEYuxkB8dn2QqREbvLR8O7Loa4ODbWwRbjyX3f5XwYhpKUvCcnHvOU024VkKdYL8Pvr5gcLv9UC
 b6mg0hgxPVyVLGawrZZ5g8X1zeiuOXcqLt1sGzX7IuUP2R+DnXGx7nw81hYT/HEP8AexYoFNEOr
 sIgKtTqr6iFoMCfFjTuTxHqdDCUXuAWBzV1ie8uvQuQbOrthLwlL6TEUXee/qh+6tduhiOBqw//
 7t7m4rkTuh9jXRhQeJi6vzWJeAr+q7jdkguKYL1yndnzZxiLFeHlZMRog8bqFBG3UFfWSWR/vXP
 a10nr0XN7wpWsqyYIAF61tPIoODLz6N+3TMIt4Tr5X8sEFWLTKXzxyM8DecOhtmfIK5oB3CkVtm
 gDXuKXhYHwWmybz+d5fZEiZ7lUEMZswt/pcFGR1Y30S3UEuSrPsKom3Ddki1Ljf4+qAnv+1m8OY
 Vm80xMmiAGz50Pecc46IEeqOMTJras52eY6RFSRyD9TMsZs2xh4gcWZPTiI+UrSbLEvOZdyXki/
 VGlyMDvbI/Teu3yd5oE/IAJQQ1Z0EFRT1WJbkdlCPRZ9GWDZEZrXF6OaNgaCNhVq/NqXKPh7P3N
 aewMDqixNIZwhpg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: 6hy8iz7q9cga7nz1qzm1uzkkf6b8jckw
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 00A27C0002
X-Rspam-User: 
X-HE-Tag: 1778500725-469530
X-HE-Meta: U2FsdGVkX1/BPv6jMORTFugBLMRvExyYjIF8Gnf0S4i6ao4TF/Nh1uM9W9jsBmEog77ClQh8a8w1mbz4PzMES+5oo/06y/1XYxGAbn9gvZMkm6Sm2pStHCQO/D26IssgfUz5LJR12ySBXkICZfd/88AZIDfDY14WOppHEPaqiogywE/oMDesGxHHjVotkmRqdyzKInSiMi2WyIpWkr9SRes87V/EzgdzOno7kliokSFae2o1TQ4bIYR5rEWDfA17hrCwKwNFac+Kio9dH4XCgqSnp14S3+VhPoAi7j3zK6DpEdr4kIKaBI99yryt7Vceqf/qhJ3wBMOez7Fub2RsFHHN51Vvf9bOBoOy5VNr1gjIdw74Z9SITG+OL2C71uXOuDMOs5peqYuoarJ/DPLbdn5OL2aDhHUXmH8KMNbSgHi28ERjpX7WCJu9vDWbN2q9B9XiN5YQhY2K9AU4kTQahgJsr6YkBWQfFRgxCE2oEk/9UFLiRRQ8b5s2k9q+HSXS/6L1goVD0v6RYzg8+DNfGrhnIYUlnY0LMjLh7HBMHliZ6zGSA2MMXwkAX76SlVBzr5pbnEbSsTmuqPUtyx66gFR4To3QByT1z6Y+QN5KSZAcCkLTtA9YxIJ2qJJ+jJUQyViX+9TCu7VYMhgbkMXmxFh3NnkqKRWo8Uyy/ITsgeSOUB4/OgZtRkHRkc1kDfeZg480Qtj7fSna+/ZTfsmDvJYnSjzXZ+9B5o9MYBEQH3oP4m6wmbCCKS6ELScEL/LtmCp9v9w7EwgIpwLu33llLzVBED09fjd8ozGAYrchFVVa4scSNt/VsLCpzYOyg15iyCs+Mkh/J545iCoVwRKr2OQJs+YlD25S+PznymlFubMxAbCFHAj4jeB4phdtMesvOGSZuy/hlviil5DJKspthhDyG23qbCGkENIghOhAIVAFOdFJ+G78ci+Rxys+3GQBHr/eeBEGDXh75mecL60
 orwtEoum
 HBYZbtbXBajkTPPiKSiaz/ER4nzgCrSRdI4gafSDET3btFufyAkAk4S3HZm5f86d50crchzedaelDRY3lZWeFhUuGDqeAB0cICAplm0WA8XefvZC3fsFp2cttbCJ1heR3d/yqJqu74KXGpSI+OI6ve5TkAk5Dc/ARoU5r5VS/xQt0i6/S7OoaDJQQGOb+hJjxBXMVHVMfTrSmmK+BQcIGetgqQtYgMqHdFY5rOXawzG/GdWGA2xQndSV8GInta1FgvHOgHscOwwrHqDBKsfaMk9kkNAwC2PsLIXPAfZ8eaw7Zg/YTYNTUc1RzkEwPZ8atxmq1qI0AJg6efNS6G3MtWtOe4jp+JssYELLPLDIlDNnFKms=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__split_folio_to_order() copies page flags from the original folio to
newly created sub-folios using an explicit allowlist, but PG_dropbehind
is not included. When a large folio with PG_dropbehind set is split,
only the head sub-folio retains the flag; all tail sub-folios silently
lose it and will not be reclaimed eagerly after writeback completes.

Add PG_dropbehind to the flag copy mask so that the drop-behind hint
is preserved across folio splits.

Fixes: a323281cdfec ("mm: add PG_dropbehind folio flag")
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 mm/huge_memory.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 970e077019b7..e01917b14d1a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3642,6 +3642,7 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 				 (1L << PG_arch_3) |
 #endif
 				 (1L << PG_dirty) |
+				 (1L << PG_dropbehind) |
 				 LRU_GEN_MASK | LRU_REFS_MASK));
 
 		if (handle_hwpoison &&

-- 
2.54.0


