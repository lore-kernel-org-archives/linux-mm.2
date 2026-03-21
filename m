Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15745109446F
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 18:06:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50FDA6B00FA; Sat, 21 Mar 2026 14:05:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 373F46B0104; Sat, 21 Mar 2026 14:05:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 041836B0101; Sat, 21 Mar 2026 14:05:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C47FA6B00FA
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 14:05:56 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7A4CCBA2CD
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:05:56 +0000 (UTC)
X-FDA: 84570848712.01.FE0B8EC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 75A334000B
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:05:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="M/vgM6tD";
	spf=pass (imf27.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774116354;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Rx0Ci0X5B9HqYz+5nUo/zdk7ebvpX2jnSkHQCGa0RY=;
	b=rqTCRZ1JuMOXIQyIgfEutoP4wEdt3zU214y4rsBMwAFJr6/EWWmgV5gbiM1x8X0ZW4cibk
	5LwBebfWBEymMoUowEcExG3d/G6k0mHPC8rFs/muNTrSBouPsT44lXW1+uhZB+sLhbH0b3
	yt30ClwiV3Er0eR/QgmW+LeAgFwFxEw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="M/vgM6tD";
	spf=pass (imf27.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774116354; a=rsa-sha256;
	cv=none;
	b=mF65d3wbBvYhxYX7mhqk4easafEl9n9aD9aUx6yS6zDkNR4XTGm5BtugVgye7fLgEuEuqu
	znmCkqsFl4o2RCnFcgSk456Y/aDnve+g40ZagcCAOvgtfburiISgyZqwjjTR4BWIbff+PQ
	5Cb5u1xE4UAKvo8f4CRCLrp1sGPYRyQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 90E904419B;
	Sat, 21 Mar 2026 18:05:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6999AC2BCAF;
	Sat, 21 Mar 2026 18:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774116353;
	bh=VHLu6lZjuBOtEUS8VdUimMihtKDkPhY/OYWvCSJtAds=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=M/vgM6tDO/uLn0NZ+xX/qS3lo54sgsfsZ3UMyIfwozPXaOpUDusCBITwW8wJMZz6x
	 A0SLA1FsoXSKlI4W+T7/q7GugqkKWbPE4/oRlMDf2KzCBn4YFfEzXe876XBpjumYGN
	 Dc7HsQs3YAlMMbbNb9QMC+3ID3wx2neTOlYmCYvTvubYsnKhJFgAsduDTlfE9ousL9
	 tVefWu9ah6zX3v3HgiUbTdBA0w9ae0Ndgp8FODiH+g21ZGe2Lm83Qjk4CbHmdC+IFJ
	 FeMnZ1D9ZcAsgOUoXnkpgrT7oxzFaSqflI8x9zxd1aGSrdr26EYAtqwtxvMHj2urGq
	 ZHhSEfdzNho7w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B38F109448E;
	Sat, 21 Mar 2026 18:05:53 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Sat, 21 Mar 2026 23:35:47 +0530
Subject: [PATCH v6 2/6] mm/vmalloc: fix vrealloc() grow-in-place check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260321-vmalloc-shrink-v6-2-062ca7b7ceb2@zohomail.in>
References: <20260321-vmalloc-shrink-v6-0-062ca7b7ceb2@zohomail.in>
In-Reply-To: <20260321-vmalloc-shrink-v6-0-062ca7b7ceb2@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774116351; l=1250;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=w90h6aByrvZe7M9pbnNSecs/NY6vWML8p6XHr/QXZq4=;
 b=KexBhgjzhjxhyLbuUOfWatjeAXgA9SkFNWaZp4aArRYDJYWYq1g/pF7XSztMPVb/Ga6zsw3X0
 LKH+xk6OfJiAKNWXkgjApLUsIQtI71bg+osn31qBTzXt5AdUOUQtbVH
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Queue-Id: 75A334000B
X-Stat-Signature: z1mr39icmqzzs88nfcmzgr6ew1q7fr48
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774116354-70208
X-HE-Meta: U2FsdGVkX18DowFxZZW9IHoM2IWojrnY5oZf1UKj2H+PDaQbKkBrw3fNux449zEDydMe0mvZkXL0uZU0Qi1c2STiwd3C5D3B3E3o3bny249IRz8h7eyOu9X6GZtbWyySoFzEydAMBd1S64/378A9CQaHlPWdjRSpKve9YGCgN8kgu327NXB0ffUhAzH9W1abuW32UWfgIMkeMggKkE8bKJTbjN6mrXUnbbeLCNChYfMUhV7HogXoNW02Qrniz0FWaROJ0xz3d5M8aD5Q+FkpFSQUPF0B7YYZLDpIcqH8/hpMhgDSJmvDHkmtgxBfaEO3tSn4h0xB0rS0NZw0lielP/3s3PwDsaa98f6HnrIymvMF6RagSxsSZy4wK5lXndtcbusO2ga6v+qeJNeZd+H8/h9KCj08xeTLabS/3XrJerAEG3ukrvLjpNhmrANzBKUqiaWv7y9FN1fGAq9gnSPPTr/QbKxoaV4nBZiyvTA1k/glojQG0uFjAWXC2RMUDNO0uTT4mwIVJ9M7Q+IsTkB1nL+efWyVVXCilw5SqBUNa3NI5YCPB2rcL1BS3DJuAsr4zhAD8VV0AuZwwDXqV9o/wNYlM91D8FMQWCb2fuQI+XA/4XH0Rc1hNMtY9ypM2uRWNFnFpGgaou2IQAiRSQzMtMHMIRerELEyl3EePQmw6tvGmTZZZIlt2XWpzLxdwSVyPMIYJjgS0V4EMvXnZ+1Dkgmo8XFcQdaAkpMzwvbXyBw+KkSBKVNWZNOwP9R8VYXMw3URtggr9/7MDGHkXM61FijTS6yvsvF9qXuAVDqmisf4Zjcm8FDac3CkiPI7B6XAWRSe/1hZ03qC5AiZxQVD6uzh0I4Ae4aphEQgNTcNiEXsnECTpDpyA1gmKTGy2awWZy+DIfmQ41ktbfT4dTvuAq4DjtEXfn1Evn+QtySjuioX00RdZP2ZJNEQedi8sEE0ObnnAnw+sutXEwOvWPT
 kDmTWuGC
 x9s8iQw7M8X7+2uKfTy7PN30wgtMFD++JPJsKgMtKAMyBoWdligt0G3U9n071oFfU2kvozjyJ+MF53owHHoEMyMfAenp7J+S5+lPRo8z9FEticfarND3OLWAE8MM+mcZNJlvz7MqC0o9L3c2FYRfJePx5WhYzgU2AmBtlnZA+RW3yf1kR0lkeGm1wlbo8iu7aYG/30/ew/8Xpo2LLFGhICs7jJ3QCGfyUIeSJufIRWs3+Ihq0THf6z2U4BgSMn73yYdmr9VIifiXMQkwLl/faLwZhzEda5OLnHgNKKsL72VS1pXV6KhTq04NzgpINPbJgaRZ0mlaDyJOsAA+3VUsxvyhtGhnz9xLqPBRkBlmW7W/HLwofIRnulZhiBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shivam Kalra <shivamkalra98@zohomail.in>

Fix the grow-in-place check in vrealloc() to compare the requested size
against the actual physical page count (vm->nr_pages) rather than the
virtual area size (alloced_size, derived from get_vm_area_size()).

The virtual reservation size (get_vm_area_size()) does not decrease when
pages are freed during a shrink operation. Consequently, without this fix,
a subsequent grow-in-place operation after a shrink would incorrectly
succeed and attempt to access freed pages. Correcting this check is a
prerequisite for the upcoming vrealloc() shrink functionality.

Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 mm/vmalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 3977398e56e4..7bc7a6892c1a 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4361,7 +4361,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 	/*
 	 * We already have the bytes available in the allocation; use them.
 	 */
-	if (size <= alloced_size) {
+	if (size <= (size_t)vm->nr_pages << PAGE_SHIFT) {
 		/*
 		 * No need to zero memory here, as unused memory will have
 		 * already been zeroed at initial allocation time or during

-- 
2.43.0



