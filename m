Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 806EE103E16D
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 12:26:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA1566B01A8; Wed, 18 Mar 2026 08:26:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E79386B01AA; Wed, 18 Mar 2026 08:26:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB5F76B01AB; Wed, 18 Mar 2026 08:26:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CAD016B01A8
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:26:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 93BEA1D6D9
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:26:43 +0000 (UTC)
X-FDA: 84559107486.11.756DFA3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id EEF1240011
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:26:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HjRFv400;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773836802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kkIay9ZlQYHgLbMEIJHy5NQ9GxMMZTjjOr0jouTVDiM=;
	b=b33TilmSJlnvA0OPxjWSMyFzwVq9Lg8AHc8bbwXC+bIpe/UXL22ljJjZfMo2l9C16Hhwt0
	TgWRJK7Wlw47CLUOKpL8ZLRd82mTIMpJhLGUMxp4oGJ3iO+I8S4yS+Mk9lDBIjgQmpoUxk
	Nr7XiV6HvYDm5L45OsRdP1Z9x5/pNcM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773836802; a=rsa-sha256;
	cv=none;
	b=cou+x7D2sxqgBtBlLV8+3PBZckGeNYRDvtEsQKVhNFAz7kiZ4tTmCKSQG/c/1JYnAS6kZO
	ILHsJH1mH4d7TuLMHVfNo21HJtsvpvhx8nduYL/Mr5N0h3oUzdGJvyiNVyuUCreLo0JZL7
	YYINcuPZ/MjKi+Bo6R21UX1uMMhROo8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HjRFv400;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 02918439E6;
	Wed, 18 Mar 2026 12:26:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37CFDC19421;
	Wed, 18 Mar 2026 12:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773836800;
	bh=wlo6/KmRGeDlUQg4uZ5/ZwNJBHL6qZdYnfzLfFT0mzE=;
	h=From:To:Cc:Subject:Date:From;
	b=HjRFv4007y/PrRV1FU6H7y2F+D0zeEEji4DUTBFRMoQltXzjT8Sf1lBJbVJc9UvZI
	 tkp18Os4zDDMnUTg/ItfBtIqbcJgAhnEQ0rJgnczob2BzIUaSzjR3gEv9Q+ruLpPl8
	 9yxRM3j5la+5Zw5sxYqKOuPZb5/UZPmNAKYWcBjoLgGKzrzJgAblsD1yrQvjCIsMDt
	 7ESlXLv8vNCbU/f9AA6ICRk9DKdM5rIqs/ZbjaGBpvtKwl7Erw0HxopdKOFsjUna8I
	 80dQ/ETgezHlVDC+EgG3C9yYZbXROu3zcyCZdyZMJ4gd0a+pvJ+c+R+XvkflmzvLEM
	 BiIAOGzx7baNw==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Rik van Riel <riel@surriel.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry.yoo@oracle.com>,
	Jann Horn <jannh@google.com>,
	Sasha Levin <sashal@kernel.org>,
	Jiakai Xu <jiakaipeanut@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH mm-hotfixes] mm/rmap: clear vma->anon_vma on error
Date: Wed, 18 Mar 2026 12:26:32 +0000
Message-ID: <20260318122632.63404-1-ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EEF1240011
X-Stat-Signature: jc986fssfw9qefndjbkzgzjf7rtk96in
X-Rspam-User: 
X-HE-Tag: 1773836801-468557
X-HE-Meta: U2FsdGVkX19tZ2fxXQYgRI6XXrlXc/PS4u7Qd2Yb1bg7Y1gmeflkLvYcDxtPEOyEqWFW0vf6GbWvUc/TVxbwsbc/gOHFKY8qTEMsl/Bk5dy87vwKdEbiWG/F5Rd44hAtdlB9BITa638yvG6OCGbDAHUz/bZV8WquF53QaWlEw1ox8i1sSi5SiIBr732gcD9OxQMAopQ2mvSRos2wli1Y+vDouwkzQat8rT6lPGTh79IwPZsdA+ELhi6QyEzk0tPiXSKR2IfbhZ/DP3YHiHCO6gbFUQPz/DZ5USTht4a7K0Ah26VXbR27MJc7iyKRBn+1ZaoAeZEQFp2wUCxhNIS6sSLiqm9vU9oFUQ/nRW+UmVmVBFsCHCIs/K2LRCbzc9lNIn22PXEncD+F047T8h+EFDntjjDGig0Mcdn7mJzOzmRFdiY5wOuCAJI9o1cmYHdIzouQdeyVijbYqNp5kC2pDm/rCBZ9Ej46+qYKgiaG6LVAWeo6hK+jDkYlzTaupX5qXNt20Y56JgJ00/6f8xrzMYaN61Ehas889xKXX2EZCU+wn46ENKtHE+ZESbNAo0gdqxwLTjC81x6tNXidLRyx7Q7TfTt78qjJSe5RBMESvB5OstHYyPbeTLriITu/hq+L/DwBQPwe+7Im23VENvarGUspS2936VdLI2QQeXA86UxxJ1XhPRK0dfqqSzVImmIjSzAWpqbA8xXukTM/SiEigCoxVYZ0qZ+RxP3W2FOtzrDeFH6gzG8QJ0LAKgjBxkGef4f2vpWrglnkUGnCYp2orIF1m0b9b5gOHzfVdVwHLW7isUZcSP5DK5jggRNPWZTh4mLrWiG9Gcm+gqSr1rFCnGmaZsvA65Hwawk9Kiowz/oM/Gd0wjD5wwKq+fvqTY4V460Z3hIONPB/k3HUeJzrWb0W0vvujwoEIQUzI6Za/Bwt7IuyobcwVV6p3N/Akzi/HsvgWOXMtda6Hib4up/
 vUOburh3
 ePvT6vpyhbHscp5H7kIAzKKdGHKzEyQsMZSyqGOJcOMkd7uDMyhuL/uunguq7bMisFZw3rTGjAwqkUEapxFrl4D5WeDAQ8nMXo0Oci1ewJOM8qDsiY7nFauc8i0Wo1ulHjRuC/sdlCKGdeGJ4eibbyEnRTVgj3lb/FFyZIc1T5bC2/WQt/pjYjITA0b4aMk0Ol1ohkXmIG0DaKhBJNfzFi3P7Vrb5Dxq+n7DQHXc12nntnu0UCjuUYIHlxPTcprF+WhshhicWABPPkTtye6adKzoF9ZJx3A5WOHrsR/blUFo57J6dvvezUfLqF31iANM9kZ4FaPkkfPE3vWGWCalvpT/wMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 542eda1a8329 ("mm/rmap: improve anon_vma_clone(), unlink_anon_vmas()
comments, add asserts") alters the way errors are handled, but overlooked
one important aspect of clean up.

When a VMA encounters an error state in anon_vma_clone() (that is, on
attempted allocation of anon_vma_chain objects), it cleans up partially
established state in cleanup_partial_anon_vmas(), before returning an
error.

However, this occurs prior to anon_vma->num_active_vmas being incremented,
and it also fails to clear the VMA's vma->anon_vma field, which remains in
place.

This is immediately an inconsistent state, because
anon_vma->num_active_vmas is supposed to track the number of VMAs whose
vma->anon_vma field references that anon_vma, and now that count is
off-by-negative-1 for each VMA for which this error state has occurred.

When VMAs are unlinked from this anon_vma, unlink_anon_vmas() will
eventually underflow anon_vma->num_active_vmas, which will trigger a
warning.

This will always eventually happen, as we unlink anon_vma's at process
teardown.

It could also cause maybe_reuse_anon_vma() to incorrectly permit the reuse
of an anon_vma which has active VMAs attached, which will lead to a
persistently invalid state.

The solution is to clear the VMA's anon_vma field when we clean up partial
state, as the fact we are doing so indicates clearly that the VMA is not
correctly integrated into the anon_vma tree and thus this field is invalid.

Reported-by: Sasha Levin <sashal@kernel.org>
Closes: https://lore.kernel.org/linux-mm/20260302151547.2389070-1-sashal@kernel.org/
Reported-by: Jiakai Xu <jiakaipeanut@gmail.com>
Closes: https://lore.kernel.org/linux-mm/CAFb8wJvRhatRD-9DVmr5v5pixTMPEr3UKjYBJjCd09OfH55CKg@mail.gmail.com/
Fixes: 542eda1a8329 ("mm/rmap: improve anon_vma_clone(), unlink_anon_vmas() comments, add asserts")
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/rmap.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/rmap.c b/mm/rmap.c
index 6398d7eef393..abe4712a220c 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -457,6 +457,13 @@ static void cleanup_partial_anon_vmas(struct vm_area_struct *vma)
 		list_del(&avc->same_vma);
 		anon_vma_chain_free(avc);
 	}
+
+	/*
+	 * The anon_vma assigned to this VMA is no longer valid, as we were not
+	 * able to correctly clone AVC state. Avoid inconsistent anon_vma tree
+	 * state by resetting.
+	 */
+	vma->anon_vma = NULL;
 }

 /**
--
2.53.0

