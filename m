Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6513760A380C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WsF8M/mK
Received: by kanga.kvack.org (Postfix)
	id B76AF6B05C5; Fri, 13 Nov 2026 16:26:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFBD96B05BE; Fri, 13 Nov 2026 16:26:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 976836B05C7; Fri, 13 Nov 2026 16:26:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 700576B05BE
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:26:41 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 66FB340157
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:26:40 +0000 (UTC)
X-FDA: 85431380160.29.D318CD5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 36C0F40004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:26:38 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="WsF8M/mK";
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794605198;
	b=eGDgurSfOnF8hQpyzLyKXA2kKuJaeZVzriCBjezYVTkZbdGUrw+rpi+xU/3jkx0ixIg9h/
	R1bn8zx1XjbsnFTBmewd1HxGxmdN5/UJSrIqNHh0fpetPr8IIV1o9FChH8ejg72die8dNd
	6QvvAadsMcF1Hnuy8qKCzmMMBnxs+BQ=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="WsF8M/mK";
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794605198;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6JtMkq3Mj1Gs8M72xLAd5Gui7Cf+Nu6B+jWxfF6iCP4=;
	b=fU8KrOp0AsZST7ppKyv5BsdUeA62XzLV227KxTdV95nTHN6itzaon6BenJvT7s9DMjKlJR
	t15hz2MhXY4IxFQilE35GxVEJqQdRZydTTdAezTomtuXv5JxgRfMKhFeESCZhYBUpWmVyz
	PWxkn+rzlwwvMRlTdfR0eeTJAtFQOjw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 31751431F8;
	Fri, 13 Nov 2026 21:26:37 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794605197;
	b=MMHT9cwDusqzAtNsC5rIv7ltSDW/cVF4+ZgIYyKf/FOMsjpokoiwA4B7v0z3GLpMkjAD
	 b/EULA75ftWO4EFiZq2RZBIZlouywrhaIw82z+BmSNfc/yKcFmjYXWlm5Pf5zZufU+nS1
	 SMzmJHAYD3+nlNeVFTDdQZXwrV+kA0LWjv6jXYRYpoOwCbglu8iiN8BSI0VzPXCdsrOfn
	 ogNaxGnwt/1YH4Ss+KNgKzx7n3GG+oDBkzsuswsLxow7uMQUuzrEOZM9kPgTTrIgozS5u
	 sjaasnHRHouEsCAK+HR9XXilfjdI0OU1zyrCkVoznd53g89QTZXhzlIB+6MxGN1oLKA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794605197;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=6JtMkq3Mj1Gs8M72xLAd5Gui7Cf+Nu6B+jWxfF6iCP4=;
	b=SqfA2epqn9nsG1P5Th86Y3061E5gi2l6ihBA+EUoXTjoit5GcXNBdoVccXhb7KyGLm/l
	 qVLQ7XMh/XJoJE/GQLEWD53ggKvWASmeXG+bPsL7aKU7W4/W747ArdzYDHF03TSNNwZwu
	 2eT73YGtIks44N1oPUedIW0UxhL7YvhV91OFd4sEW5ogyy9/MW3BkZqt77s+PgMZwlIa1
	 7ZsyGGPbybwR2jG5AfuWVqJijY0X3PxiK3V/TFmYk3kZneDxXQREYYAU9jM1w9REWNFk1
	 fNjpskdktAna6VHedquAUG3xXM3PmFHgr+432ckg7uux9pCEHm1541aS+ZSydzdpAHw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 73EFA1F000C4;
	Fri, 13 Nov 2026 21:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794605197;
	bh=6JtMkq3Mj1Gs8M72xLAd5Gui7Cf+Nu6B+jWxfF6iCP4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=WsF8M/mKgOhp4f8H6Q/nmYw184rF2TTSkIz/7qdBEbU+poKbagbUqkr/HhLzQ0gQV
	 LNsxlQeEdpNb5B/EWyTnU+XyhFNLsgP8uzfOAkldAqLASPCPulDMQbrtiqRb/TCGQ8
	 KEKC5ja9JUCG2P8M7slWTYB+UPQXHQYqqXrdK1clHJ3o3+ay6aXzVey/yZ7r1r0ih2
	 RKPhEIjQQ8a/XX30pKFBnazX2DjMjwrs/JhfQjYefNegdVMxLKySFVz5XaOf4u8J6Z
	 PhHt7xYt3ctUC091tINZEEqjzN5rIYwGnQjORo9FWLxdUqp2eUoL5aJbv9Vth34xM3
	 kIa3FQJQVo93g==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id E1FDD49B11;
	Fri, 13 Nov 2026 21:26:35 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 14 Nov 2026 05:26:17 +0800
Subject: [PATCH RFC 1/8] mm: add folio_prev()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261114-swap-thp-split-v1-1-dfa8d4fa448d@tencent.com>
References: <20261114-swap-thp-split-v1-0-dfa8d4fa448d@tencent.com>
In-Reply-To: <20261114-swap-thp-split-v1-0-dfa8d4fa448d@tencent.com>
To: linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Matthew Wilcox <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794605194; l=2033;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=8U+vChwHY7bImKDhKYpDCcJf0GyjeC844R7WWMIwhQE=;
 b=bwhRW6oU8F0MtgXSJAnvYmhFawAQqpNqSAeZ2CULRpOAFzH0mFOKzLo2F/+QLfhx2XXIX4rwT
 ElUU4af3Wo1CMV9aLfBV4At7whxEIEoMjum5LCSYHN1XJI4QoArc9Pf
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: a7q661fe5cjjxs7ajrg4cxx4mzaushb9
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 36C0F40004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794605198-139164
X-HE-Meta: U2FsdGVkX190XPBA7J9Evtc5nmayxV4crfp5LEXNh2/AHnAZX9CP/ussXl7zLM1s1JMOs1KidWyIRszXNO7cirCipbqcP5YIV6y8vwJd1BJ2YHsH06VOdYhwMMr1QbOsSCX3fdjNP+gAiBAbndTiOa8V749XDkWUEYivQD+MwWraGBnnDPy5552rZnS1PSjFw4LBXy94zf5DL9FHBb0DtE+iqAOmcHfaj6Ad9KyCB3eZxUpChtihz9BsZvw9k5daeJ5mab0aJ7WpxAYBb0ZomKYsl1aDIR1vFThLNu9xJAJLhYocpck5OgRFQ14HD/+vvYtOWEnjBBnHS3N68Qbqhz7gaXVeIoGADt5AuNrtzxU3x8G9txiokqqWJ6PDhBXG/T2+LzowICzKz4OYrWDXv4fD3Z3gJktNqcrSVeNxXxTJlZhkJWRLyNnJ0XfDWCNRn2GdVs8Rt/zFCj6Lbf7YWBTwXqVZcdQ2pgU/1QCpnWJ1Sq/M0o/203ewOSbYMe7vsSodfoomzgGvnCS6pyXUKvcheesInecWoCXQ9ewb05jtZgZQ2QIf7t5R+7LBZnreaBLRVv/N41RHbgf5Q0IQgV8Lzg5zTPHMFHSBUYMakU4cNPq0FocVy73ZhIZLioDRyU2bhOS0QIfTG6MF1NCkfaSagHWqQxYTRve/dK9fccZDwd8ykOStBxAAvLT1wDq1YFOox05lze8nOn9qzNGRsXjbHiGkOYL3nLwf5SxisybKotbit6/ZVwi92P4GJiq6pKjB9YlMe1AJrCb2cFi8NJQK8DNrMIeO9GU+sOaLY5KD3/ga1eFklOyl1lHAeaQ47X/7igfASBwjYKy9mh4wwsMfG2w5uSnGlJ+PqUDggE1tgXefZ+TsAel2PFa/i5t7Go0Pwo7LKNKiCMpQVj0DsaNRBWs4WK6Els/u+e4d1G9BA5f8glOa+kKrQ7+ULfUKzVLVlX2EEekG6i1LS3e
 sys0kEMy
 B2TVgNu32Ejj0KFOvLsDNC3MoH8kPNyakb/McyppxeSP3iqWV+6SrRW/ZzYrfkeJeWi9lPstGOO7A5vECvkikG7tw28HoOOq0JS7gCRQru1XQ8HOeAiqt7tFdcQiCZdVFWIzaOJJn0tGXHGKDEoGGAPPx/JU3pTyEw8cXa3hS1UZow2Vls1G1XfG1aEDxFwTsWw74LaU2yZAMlTPqKijMf2fwofbhcx88PRKodhceBw1msZGlwhTekFpZZmNj8fwc1ABvPpX2PfbAnMt6VYwgk5Racs8uvMwUzV22Ws97ik48WxtJpaOMXM7RvnF25DAyVX4T+jc8JpkN5UFPkUG6mTMc+UsBDW7s+cwdG/jxPTfDFVTfoJ6WT+J0zHM/2GHfOp9bYaDSAR7tNSd/Hp/KxDAkMcagsXSuAaoZo7XaqQKbXoomEDpcTv/xVYJtuPffG3uE5yhjl/MfDSYkueQzEiAZsTGplIHVESHSUv7Jg9hohVQuqHzWfephTxobWnMqurD0o4AM1CeY8rU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

This is similar to folio_next(). But to get the head of the previous
folio, the compound info of the current folio isn't helpful. So here just
retrieve the previous page frame's compound info instead.

This creates a nice side effect that we don't require the current folio
to be still valid as we don't need any info from it and @folio is never
dereferenced, just pointer arithmetic.

The caller has to ensure the previous folio is legal though, as there
is no reliable way to tell from @folio whether one exists.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 77b5d450fe45..5b529bc6624f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3076,6 +3076,29 @@ static inline struct folio *folio_next(struct folio *folio)
 	return (struct folio *)folio_page(folio, folio_nr_pages(folio));
 }
 
+/**
+ * folio_prev - Move to the previous physical folio.
+ * @folio: The folio we're currently operating on.
+ *
+ * The inverse of folio_next().  Use it to move from one folio to the
+ * previous one in physically contiguous memory which may span more than
+ * one folio.  Do not use it if the memory is only virtually contiguous.
+ * This is the folio equivalent to writing ``page--``.
+ *
+ * The caller has to ensure the previous folio is legal; there is no way
+ * to tell from @folio whether one exists.  @folio itself is never
+ * dereferenced, only the page preceding it, so it may be a sentinel
+ * pointer instead of a folio.
+ *
+ * Context: We assume that the folios are refcounted and/or locked at a
+ * higher level and do not adjust the reference counts.
+ * Return: The previous struct folio.
+ */
+static inline struct folio *folio_prev(struct folio *folio)
+{
+	return page_folio(&folio->page - 1);
+}
+
 /**
  * folio_shift - The size of the memory described by this folio.
  * @folio: The folio.

-- 
2.56.1



