Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3139E606A324
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 18:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aIkIKK05
Received: by kanga.kvack.org (Postfix)
	id 704436B05D4; Thu, 29 Oct 2026 14:32:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DC4D6B05D7; Thu, 29 Oct 2026 14:32:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CFC46B05D4; Thu, 29 Oct 2026 14:32:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 349AA6B05D4
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:32:52 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 92CD2804A0
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 18:32:51 +0000 (UTC)
X-FDA: 85376510142.07.61C1462
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 75C401C0005
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 18:32:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aIkIKK05;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793298769;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8siEiW80N9vi14SdVxolv/f/YD8Btawb+y9/5dfekKs=;
	b=aZx2vZO/sNhowt3wTIfD1Am5NFF19QmMx2+MGBMjnA9jYLtlSv/yUK2YbCAp+59MW6mffz
	12YYgrY3ROogKazQBoc0XTnqk+V+R0huGZ4zP65Jt1zORwOopDVRl08Hwtf8BBJTz5tNI3
	l4UfEQKWUrDLfyhBJ5mNDQgmvqa7/rY=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aIkIKK05;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793298769;
	b=Bs1FK9a/5lXaQcX+u9GQs1h9BQbKcmyDMyr8gMDE62CL36j8oK4ebtl7mYJQobipQFlrNq
	oWuJScl2QkdxVAjH8VGWQtBD2xJfcPWFnMexUVrinswZdyqfKK0blirA29pUaRdYXQqUql
	87bIaRVtYLuVU9BL3DpbHT3+YCJaIuM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 08D2860615;
	Thu, 29 Oct 2026 18:32:49 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793298768;
	b=jM/7uio4+97seb1sV9uove/T6bji7d1kj3Dzkt0jxbY4nTwAv7XHrFBnlea5fq6W85Ty
	 iI0RpNY1goNETnLlntl3p6QdQ5SzKooMor0uMm1uldTtdmpoG3jKFrmOf+s+Kd7E1uPT4
	 vnwI3RFAQ8YVZAGXONr8dG1BuBkB6ACI/1od4uZHLsG/R+E3rmLBwwXK8OThjV8y3Kxzf
	 vjeDGW1P6AKKO8++HzK6OveMm5iJUepoqzk290ymSwxJocI/kxcNRkj5XcxBZSaOCBgAS
	 13baSSsCv/nJM3S7ygWUQjXkfPcEDa8ga/VCl+G19YpSTcPYkxsVpGmJmPGgONlS4kg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793298768;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=8siEiW80N9vi14SdVxolv/f/YD8Btawb+y9/5dfekKs=;
	b=ucQKrqcoBVBeQ7bZRgKre/TLCuitgmjrmu58AtZYV5haH8E7NUNpyB5W/IAhZwP/snQ5
	 ZiyPaW8i8Dch+joQi2XASNvCbaSpjR235GxCYTcabA5Ymh6a0bgapM0/E+jc9da7eqTty
	 gpARp+AxittT0SF//UcuUCWuIz5bLRLY5CwzEvmgW9KPwN6b6XhdvlahJBYMRCvMMkngL
	 JiAHYYU2eYSyTh3oFewKh1GUekq71omTCtUGjR9Sh0rFp/domhqu+a2ufUXej2Nb9akVx
	 e5FSwHydq9g180AbqkUkEFX9Lylvrl5GvocBDAS1ZLHhSrm9Sgxt0Zs4aupznMtg8lw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id A173D1F01824;
	Thu, 29 Oct 2026 18:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793298768;
	bh=8siEiW80N9vi14SdVxolv/f/YD8Btawb+y9/5dfekKs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=aIkIKK05GV8kayJ/fVVtStE1hQxEf/HIpoVCNW5veLMwhkWp6Jh7u7pcwSc6qVIEK
	 WMyOKauFi/wQfLHshGXREQcmqxGFBA5q1jQUBI+gtnPEtQi7dS1bjG2cu51ruezyG8
	 pD0BgTIW4ykuC/QQU14ofTuMFBa2lxlk+jwEk/vbaefJ+dCWzaaeDeWI0QL1tt5xs9
	 11c1QvAS4F5MNBuIZJqSVznMeJmrh6/p+hSIcAvVaobYVB/r/QQc/zkWL7gVy/ta6p
	 f2mEEIJfe2HgZg+8y/9cwHteJ/i9l9H6xo/qQdpB+SNd9jD30b9MbefVCm0zwZJ4lx
	 qr19VIU/mk4Bw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 0B76E45957;
	Thu, 29 Oct 2026 18:32:47 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 30 Oct 2026 02:31:41 +0800
Subject: [PATCH 1/3] mm/zswap: drop the stale zswap entry of a zero folio
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261030-swap-fixes-v1-1-73f73a59f2fc@tencent.com>
References: <20261030-swap-fixes-v1-0-73f73a59f2fc@tencent.com>
In-Reply-To: <20261030-swap-fixes-v1-0-73f73a59f2fc@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
 Youngjun Park <youngjun.park@lge.com>, Yosry Ahmed <yosry@kernel.org>, 
 Chengming Zhou <chengming.zhou@linux.dev>, 
 Usama Arif <usamaarif642@gmail.com>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Chuanhua Han <hanchuanhua@oppo.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Mani Tofigh <mt4022@columbia.edu>, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>, Josef Bacik <josef@toxicpanda.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793298765; l=2762;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=Xn6wBaxs47PABMIOsovdsII1DHl3JPR04Vav6SHkQvA=;
 b=kH2Vbsl0GjvjwSMuOje0D+Ghnvzt7n+7cJTAJcz0EnhxhQ0cz/16dZ3jWFyGPkoZsBr0IS7Xo
 6d7Z3YSUD+fA2vDleYo1OD+QleLPLt7uDPh3RBXaCSXqJYvtaAo4l5c
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 75C401C0005
X-Stat-Signature: dezuhu1oqi7orpdh8r4g9sro8a9dwk64
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793298769-894822
X-HE-Meta: U2FsdGVkX18IVinLi4d2kXCpUtYRB+C4y9bQ2/jc09tzeQdXDSsJhVx9BlVdNsUZ15Q9Cig/9FbX5FZ3jrhAPZP4yU1Us9N93c3zkurwXsF8ie3euRuyF3BZLt7tOxbAT95FFaFDl0HyPO2FPkyOV85Q7eq3DgmGPh2lr2dROkhpYXBBNXcdPIl0HKy2JY9AOPC+5C98iwg+g1L1XbfWvAfJybtuvFuNqht16O215flS4xlE6s/J9qM13I5aXmyF/sYH2I+Z3rH2JYCyQ6+ePrA0G3kccKNLqOyWVyR+8qODOMsaM3w5sWzcqPbS16z/4wlGjBQi3/WI6PZb988BFv/EurCIdE25QOtgijmP9C/VJ47Mcl793c/IwRycLPOuskyx79GpU+1NfpGhztt71VxxS2nnRMK6BVSraNtHuAmza1lFGD9NuRrpyj6Sh62q9he/mrttHf70f6LEDwOfCJCLhNhKcdjRmMw+63ZDFTImwBeR9VsCBPd4pY8CHWIbCEkfbbVxp6YzsNRDvMiENqlMscJNar3IQJDs6CZ+tZRbLPFll8Uogc45i/jCdnc9fz2i4K8Xz5GgG6v2mVZxx0pia/E3MCLx013Kai25K0Ms3VYkzwmvhURvJWUS/iPZHUePtUKt/Rr6jEk2COXAwftc3LrZeYrat9S41uKtAupksKJACGaOWv211cEC/HOetRVBnWZrB+fcgfpJBBm2OLPqR27XgtaGgyMMLeHjc7Bi2o/lpt9kNzMRCq0OibsjEv4+NWAipFfn9oyfdoj1i8Jf90c1O8lUQBzpf8oHyEcmGyHXNng/CEBbzVsqDxq7WwgC2mnb+LHYxODVWHBPDB5Wt0ke2UcfWaa25FyU/g2aHsg2UXNH1z6uXlyjsinScpiJ/Lpp0s+pyoJOct7cgTeRRJZ8m1GGrh41bWJetRyvwIUffOLLvs6rYYcXmqh5jwUEj0LL9VzUgxoMS56
 QGuh9S7H
 RW0kBKhFXlfvRGJL39uT2bSgjxuB/52GzcycJi0741CATW5eUT54UWXsXe/sWSwCOZSiLruQz1rkXLoirJG+3Q//Sd+XE79aEYxIWGIzwX0dKQmduqtIDmQKaeEsv2qtxjVDltda/Srfcptu6DzVzFfRWIRDm+MGgSniXsGmRbU3ucZy8GfB5hkJr8a3gweoTeW0EHtYZx9cUisjXW3/cE3LSgkaP0IMS6o6uk8sziR6CG6pAfgtugaujVr7oj8tT/kzHFQGj0Bnjvqgd09ShEg+eOtbAd5APLBfQOsTwHfX7Bvgleop+/ppheO621POeHU9yp/RhaCfoRmvZJH3SuMVoR/gS4wW0csTOeRnyy/p0WVnKRb/ktHLrR6XcEKT8qzExSU/tolu2Bn7p5jXTyZiOrRxKsaxaSObQZKqL9Z5flPM01SpOlXHetbPJ1gNnqd2vuvL3JhUPrZJH5pvp17IV3WYDVQ0Fom8TGAAOzbSCf0B2hn3x7VZy/nv300U4LLxzbT2thg2YjYBx8upvDeBrBXsdtVf0RIlKA8aPNTRcwQo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

A folio can stay in the swap cache after zswap_store() has stored it,
when a swapin fault gets a reference on it before reclaim can remove it.
do_swap_page() maps an exclusive folio writable and, for a read fault,
keeps it in the swap cache, so it can be modified and swapped out again
to the same slot. zswap_store() handles this, it replaces the old entry,
or drops it if the store fails or zswap got disabled, "otherwise,
writeback could overwrite the new data in the swapfile".

swap_writeout() does not get as far as zswap_store() if the folio is
zero-filled now. It only sets the zero flag of the slot, and the zswap
entry with the previous contents stays in the tree and on the LRU:

  reclaim            fault              zswap shrinker
  zswap_store(D1)
                     swap cache hit,
                     map, write zeroes
  swap_writeout()
    zero flag set
  folio reclaimed
                                        zswap_writeback_entry()
                                          swap_cache_alloc_folio()
                                          decompress D1, uptodate
                     swap cache hit:
                     maps D1

Swapin looks at the zero flag first, but only when it has to read the
folio. The folio that zswap writeback leaves in the swap cache is up to
date as far as anybody can tell, so the process gets its old data back
instead of the zeroes it has written, until that folio is reclaimed.

Invalidate the zswap entries in the zero-filled case as well. The folio
is locked and in the swap cache, which keeps zswap writeback away.

Fixes: 0ca0c24e3211 ("mm: store zero pages to be swapped out in a bitmap")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
[kasong@tencent.com: fix zswap_invalidate() arguments]
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/page_io.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/page_io.c b/mm/page_io.c
index c6824fcd483e..65681eed9c80 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -224,7 +224,17 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 	 * acquired internally by swap_zeromap_folio_set/clear.
 	 */
 	if (is_folio_zero_filled(folio)) {
+		swp_entry_t entry = folio->swap;
+
 		swap_zeromap_folio_set(folio);
+
+		/*
+		 * The folio may have been stored in zswap before and dirtied
+		 * again while it stayed in the swap cache. Drop the old copy,
+		 * or zswap writeback would bring it back into the swap cache.
+		 */
+		zswap_invalidate(swp_type(entry), swp_offset(entry),
+				 folio_nr_pages(folio));
 		goto out_unlock;
 	}
 

-- 
2.56.0



