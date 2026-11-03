Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 178AE606A339
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I666OMCZ
Received: by kanga.kvack.org (Postfix)
	id A6A3E6B05C6; Tue,  3 Nov 2026 11:18:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A33C36B05C7; Tue,  3 Nov 2026 11:18:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8120D6B05C7; Tue,  3 Nov 2026 11:18:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4B4F76B05C5
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:18:29 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CACC9120493
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:18:28 +0000 (UTC)
X-FDA: 85394315496.22.C3F9932
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id ACBC1140009
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:18:26 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I666OMCZ;
	spf=pass (imf26.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793722706;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TIlg5+Jr+rE39YU9MasG/yuhvLUgY4s1vPHwCpCoHYw=;
	b=8k6QiKYTnxUNA7hD9iQqnY0OL95SGraWb0/brhDr2JrPfW8Ggd3lUJq/qWtnoOzGomVUlL
	/v78Ntf+NVYE7ly68xzI9jgmJCMEbQ7x5DkFL/iayywwuLqNP1KhT/XLFEBKjCteaGhu2V
	xKEFG1fEq23AuDjJoCzB49a2VDveqiA=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I666OMCZ;
	spf=pass (imf26.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793722706;
	b=oUhTNOJHD5I9qiTvu4zVATs6Hc7/JIz2wYlqEp+upmOBbdXRvr+zi2miqXk+44pkGy9s1n
	537wUautuMkVIvH9O8KY/Kgt/TfVO8YmPLs24YpoH7e7o8lGVakKll1Ib6aKNz5xsCAz2d
	dQeX3HByzLsFfumwxD/gPcPxQ+FXHpI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 29DE260A02;
	Tue,  3 Nov 2026 16:18:26 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793722705;
	b=sZbthj0I6I9c5Yi52Mwu/N+vrazO8TwK74TZBIb61+UZ8oZtkPfpxCtqBHX/ehWgA3BO
	 QUei4g/tpJ7tHO2+i6MIrKBVc2/aXoXjY2dXyhtV28W0V09ie0ASHrC8Wr9D0mcQgMt6G
	 Vvy7s6wKXw4zt8JFwdFKugAHeow2yJdcIkg9R0r8uyn2vRREzk94E3BxnByRMZ3LgMnHT
	 1lJ+IAaQ/LjRqg1RT0QXP7JyhMS+sucTf4WTykqTUJUaK7Uv6lpJ8/YwyNMLZmbLJ2Yu7
	 IoASEX9V1B5wi2hOd78Q2uCO2Fmz/mPdjjO/lw3JgLg6OjwpRoE02CjdIMhRjkP4GTw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793722705;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=TIlg5+Jr+rE39YU9MasG/yuhvLUgY4s1vPHwCpCoHYw=;
	b=JSFlhq59ychgGHrcfXqcE3kVdS3iVtKRp4PWR7oO6QMyKf5EIUxqgQ6Tb+krhp0iTcWL
	 Ljqmd54C9KDOJB3SLDV3m6kkrTTNaDfHE7snTaGcHfEtTGA3PK+fyGiQlRh3IzV9UeDEq
	 1XYJMzn4pudf+J6P0ZbQTnENIWlwWagz4GYvNtWyu0QWVPAgHsW5Lzm8nv/vEb42/cgFA
	 pVu+sQVXYe62ItxM6kELnn3ltCoyb03Nz9YrHM1hhj3cN6N8Lh6TAEJJZlxDLrk7WUinC
	 sRtkflGBk82ZZD5yP8oez3kR71aYHejnLTnA+q+CE6w6MH2gEHS++gqmPMkhqTZPQ/A==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id F1B391F00919;
	Tue,  3 Nov 2026 16:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793722705;
	bh=TIlg5+Jr+rE39YU9MasG/yuhvLUgY4s1vPHwCpCoHYw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=I666OMCZwN2Zl5HxaGVFOwcRY7UqL9cjjD4lBglUgCN3rjmbzeVfbtjUieDusr5Au
	 oaHxUonpjkvqh+oX9i4bZaq7Jvde1WbYQP3mKhx/rBkR7KxRsCVi9E6d9wipbPf9ZO
	 uZ7tMfz3ewZVRyOu6p3csy/v+/mYP/Alton0tAD97DcEZLBWoylrC1VqOh14n4BkXL
	 k19y9QOqWvrDSxdP+vzQE3bxyZ3UUva97OOWhdohE4DAg8I3sG//r+5pENGK23e+gD
	 1cKODou14+chmkI2WK0QsCFkUPADFqwgqXR/RS3SxrGVQWTZcraXJIOUi7xkZcIUEQ
	 qthkP5NIp8ESQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 5CA5146A0B;
	Tue,  3 Nov 2026 16:18:23 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 04 Nov 2026 00:18:14 +0800
Subject: [PATCH v2 1/4] mm/zswap: drop the stale zswap entry of a zero
 folio
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261104-swap-fixes-v2-1-204be064be5b@tencent.com>
References: <20261104-swap-fixes-v2-0-204be064be5b@tencent.com>
In-Reply-To: <20261104-swap-fixes-v2-0-204be064be5b@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Usama Arif <usamaarif642@gmail.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Chuanhua Han <hanchuanhua@oppo.com>, Mani Tofigh <mt4022@columbia.edu>, 
 NeilBrown <neil@brown.name>, Christoph Hellwig <hch@lst.de>, 
 linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793722701; l=2902;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=5JIfvqgJZSkDLS+9X8sNXJzSR9p+F+l9mzgjMoyRQf0=;
 b=nnIkmk/QGTpjHCzmkNn8ZZTzaxluVqlOIuUU6+PAEz3ckDifiSnny/fyr9FzDbFlimey9SHP+
 EbB2jPyII0rACVUq8xQ3eS4VRNg/1DDZ3CFhSZzZONMVtqLoOMRKBgI
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: 1mgpf1yw3ztih13ypie6y8x8yipr37tu
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: ACBC1140009
X-HE-Tag: 1793722706-877475
X-HE-Meta: U2FsdGVkX19aOdHe4PZ/vz9RtiDRR7ajbglSGg5+AzCF2eBKXm/q9bkwKROt1YpBLUWFIOvH0hAVaVnniHUw6NtehpnLxHdXH7cRVXfCO+hXbYjfS3l/yRMq/enSwOTRgh4g+Wcoohg2SjO+qLOcRbXhkjPVCN4zpY83GZ6d6aT0G1iQQ4pK7dLyUysojdB49ZvTJH7Qk8CjOpSk9yu8XCCV9DNXXOHsPFXGUrXcJVAHejuM6b6HqWPzH5Yi/GSUUzRHfLxGhvXq26yj5qF8M0H5jiCESBSxpAIp76CrAhq3e7wuBwMILGfDW9HBlD9GM1dJ30yytbS229rDGHboHnZNXsVKHHfSviaLorigtTC+JaWxi4mbF6P0I2UrmeH767nvziAFBESa4EJyJmN/oOhg679TuXwAICSilYfp+FdyrWaMPN9+y93blTDi9uYSQMh+IwCkBqD0TjrzT+ps+gjRGAtwS72vcYULK8cXbjVpK7EDOFciQmvuABQDgcV/myluCyjCc/65XioBht5rb3Jav79iK2MJPlAc7KtVZ48lBwNh+vKJNMCrAqH8z1KBFddJ93b7DdEm2Mj+WkZbGB047TjBi3eoapHU9oKbQJmimkzD3XvLuU8Tba/bVDo7TAfBRFURz+5BOuv9qi21zzbQ5D8AM9kuLhxJ6/M3cFU4q06+19sSdpeWCc5ExFrVTYeN1Vsgh6GLvb8SSG8wtv/hVa46TpOt7bVLKDePQ0gOz5ISncikuKMCG62uHVWJoaabXtR20aCgdZWJiY381zBsx2hZghKaHwR3tY/oPB0jPyFf9JvEWkeX+s1umbtX6suPsU1FSZ1BuQe4vZvulJAn3CCOj8eEFRtMHCRu+dan821LNvXCRfCKzSa3pUDC1wbMpIenzWXT59xMb+yxzfilUbp1UuLhNmG+ORLD6wEFA7+XH2SClXvhYItWagdxeb78POnwm6sF2YJb9Tb
 GbFTQrwv
 wzx5uwUx33jjKmx6b+95J4A8R1NT0M7ILBX3TVNGZQJWBqMZK6stRT+dP3F2qpKWOW8ISB/oAV+kWX1MrOzGxvI8c423qpB9AF+iYx7rnFmKgdka+RNujEaTKSCDU29MskkiDXUOOn27uYcTzMRQAr8RMSeN2gWTA8oZLajlLGpv1vt0VsKOTbX6R7SwPynStT6TFOLEgrAakovh/3oupouHjBxqmeeDDR6JzksIlaBtqctB12A9PYhEX5+J2zJ4P9k769lVb+9Q0ivXL6mEDHb/4wSqrYjTmzph/DwxwcC9LD5u0Ko4DLiCxzbWVXPgHV0rYhg5Pf/TmSr07XwRaKN3RjHKs+kivr3TrMvvlYYtmGzH+ENiJCs+Zy1/3L+dFkeJSUMSlKJUJOsVlTgAKWQbxYchEg4TAGSu0c/oWjURNL6s991YwuLP2yqDDbojF15TeA2k1SGO4nJQ6vj7J8nHKHQp6vJNpycEVqGO3dpYiPll6srnRNsXJ0RF+E5r4fNK3G0TO3t4QuUaPGVW+CpuWbn8SiToIRdshGw7EGGAsXSWFW3q3RjN6cm7c70BOYdVg5SCgbWiJyh0YS1Nn/QSSuDXeaX6+sDr55WVhA4vxJY3oy7IQFgKE71qatfgGSHJ2
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
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Yosry Ahmed <yosry@kernel.org>
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



