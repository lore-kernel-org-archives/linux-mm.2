Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AF85C9830D
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 21:32:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A95316B0099; Wed, 23 Sep 2026 17:32:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6C9E6B009D; Wed, 23 Sep 2026 17:32:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A9E26B009E; Wed, 23 Sep 2026 17:32:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 756E26B0099
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:32:46 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F299A1C0184
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:32:45 +0000 (UTC)
X-FDA: 85246326690.29.04CEDEC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 043D2A000C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:32:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AfS2126m;
	spf=pass (imf15.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790199164;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n90hcQDNUTzDy5wNrd1Fd4JkWGCgiKtVAR4hPAIdIMI=;
	b=pXTqxe5Rkip/JowKx6PdBnnGGbw+kcCwheAbANo4vpQgR12dqy6Nxxj4VTlUHlOgkjBaN5
	IvvZb/vLF2ZnREnn5uHGKUth1TnV7Af1HC2g3rw1HaPXCPxScvP+zCLmYCeiJqhIkTZkd8
	8s2Sws2zMV6oJIlpLDwqXoS71rw4Wj8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AfS2126m;
	spf=pass (imf15.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790199164;
	b=DegoTlEEG7w4U3RFSEreR/6EwgmrukiiBqwW8MvLCLhlIcLwsESKrraKeOmPSVXOUdiZpD
	GcKUsI9U7QJNDMZWZoHllZeScmSw2WY4gfSdwwCcJ5VssVc3goI3WNL9nHlxwDoLJiAeSs
	xEyVhB0Lq5KmnJ5KRXGyISl6QmbZocI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2777043E19;
	Wed, 23 Sep 2026 21:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DCB0DC2BCF5;
	Wed, 23 Sep 2026 21:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790199162;
	bh=q6d8QZgJ9uVNO04KnNDgtygNJ+rHQadMULxGSKbRmEg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=AfS2126mBOIZCNW8Yw33eyefuLmORQ/mOw93lQcSGdTsNuzuTSLEB0E/9tbrI+jYd
	 9JCZ+veWdEvWcCQ9aw9Le41pPftAFYBeJuxgPscvf9oJ87qq6a/TvRWcgjgqWfsU9y
	 dqsHb/nw9nEmb9hTtT5bvl7kfaIPCVbw4iDQ+ruBAZeN6yIqbiekpCOzofaMgJztY3
	 naHRERim1HgDEyLhBo5It/i9+DRw6gGhVor1QeZCU7JJ/Gr4DuRCAnCU0fEOxhAH8/
	 yF4EoFU2BGmtmWW+4SJHridvuYctKdI8GDc1Bypk3phbMlU36TM9HlqMZaLCjIPCcc
	 14wRAE4itHp7w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA5C7C98304;
	Wed, 23 Sep 2026 21:32:42 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 23 Sep 2026 23:32:32 +0200
Subject: [PATCH v6 01/17] mm/swap: fix off-by-one in swap cache replace
 sanity check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-swap-thp-cleanup-v6-1-ba1b4ba72c6f@tencent.com>
References: <20260923-swap-thp-cleanup-v6-0-ba1b4ba72c6f@tencent.com>
In-Reply-To: <20260923-swap-thp-cleanup-v6-0-ba1b4ba72c6f@tencent.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, 
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>, 
 Kairui Song <ryncsn@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790199160; l=1650;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=810n4do4aOKMWihCxqnhsHXg2hcES1SAm+rRly1NOZc=;
 b=vI2SJv+2aeuKdY+dWJee/PWf/aWyUl9ypGDpgl7FiReWrKyzgi6HVzlApGTKJIbXcZeUL12EC
 CimIwkHeUSPBmNnfoHAvke7AZXvA0B0jzBZHX0CHs91bgDmImjxMDGJ
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: umkpsd59rzkz8q8c8shtu8gdf71osy3z
X-Rspamd-Queue-Id: 043D2A000C
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790199163-544616
X-HE-Meta: U2FsdGVkX1+NTdkC2T16Pb0mnMWIWdwEoLguTxPSjFXqfqiE8ys99SvvPG5GVV2b97H3+9zwBFkctB7Xt06Ha52tdBQPOyk1xuZyLp+qCq7wfrI+iVMSGo0SO74CR/9p192+6eG5DuZgVK5oltTRyOEIxFn4ZFtZWr2/FqaoWh9iEMp9UyxEB4ftUY6/wJTOhuKvl/0cu8p9rxs64ucAHl7kFvCCP3o5+qJ4PLG9XNl6+Buk6ixiZnOOsobJwEzBKZbYgF36xzUzsg55YyIWIZUJvyRu7LLdoRt/SUlMMSke9Fzh4c/RWqdj0MDaXfSNMZx/oo9zXWl7lhlx5ohSrh+WZ+41n76g0xdehcK4qhMZ3jJeOcEfRpn2TFD6VqJlTlOdJ7s4S8MQXY6vZGCd/CBgBLJrNwnMUsJgbY+mA0iban6npaTH1eEvCn50aJZ4DbhjBTThTXX+zzIW1VMjEqOxcUNT3TDCMfE3ONdAkAOgqEMnE0jCxRoJSfrz3aPn5RHVCrUzNG9NqMjn8F4U34TE5H07hcrzyEaa+AApsedNl7CpgzlOiUQHGTZLptBVu5AwJKm9505LB7plG6XI0airta3x+GSPMKHnR/1FiHD0WGvC+Bor6cGZT4xObl2wY/hRSqZytgBhEnpVkJTOcQLgceMluEHfMngzAopY0yF9qBC0BvcGjLnaM1sZ+StVTT5vThghBNtKwKM8HexKCov7k0xuZ04fnlzIMp6xzQd8d3K2Brtlr39y/lj0cwPJoWm0qviB07veUXEan3IlpXkf8JuXZR5UcAnhrj+Z7i2zQIDVPlZoosqD184lYzgxXIaQzaBUpoz28EfZZOz1uaqaifARx4yqIvxBuGO5+7DVny+EsfktoGjjLgSNOyi7+L011epF9pRQzYcmNgIRkxxIU0GhcOk+FwPzpNXx2IRIMy6zkNgc4ic4gdE4jhuAgibhYiOwZiwB3zXMpIM
 k4SxS6p5
 n8AP4JrrHF7H7DyfqDxg5hgpoPTHg1JW3xabWYeuWLL8wukTxBA3XuErLyPKOBYEzY+L+L1P0SrwvjV1AD2nQsCMfQLoisMTIlUs8lW/8u/K1VnsM2SD0t+E9IP4uYhjscZuTQhgQ/BMRXhyc1Zxkqvop4IN2T5/Q7RXHuS3+E/PsLYm1hCcuN3v4DCrnHe91Y1zlSPF8COAGg2r6/QHpQ6njrxZ5fN1qVkFi9sQRwyxjSEWuII5XVAAvFchvA5IZ77hfOo2HY547kQR5H7iTHRD0rYN5yX6D+i2pDLdAj+Su04M/6Sx1ODva1mdc4azajG7XozJvmEQjK7q4eAT59M/doiisETaJo15TDZ80hj6zyN19Xr+aWPXDVRlvDG9LxtIASrtjT4TR7BjjaEjWqg/OSIIA5/BEf6hpwTjal0bZVQVnhoKFLyXNPQr3m4nAa6Xx/qYUHlZICVJBxtf2apuYmJZD81WAYdXEH3M3DBs616nNthgDT6cMisMhAg+hNbmn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The DEBUG_VM sanity check in __swap_cache_replace_folio() iterates
the old folio's range with "while (ci_off++ < ci_end)", so the loop
body runs on the already-incremented offset: the first entry is
skipped and one entry past the range is read.  For a folio split
that entry belongs to the first after-split folio and was just
repointed by the replacement loop above, so the check would warn
spuriously whenever sub-folio orders differ from the head folio's.

Currently we don't support non-uniform swapcache split, but this still
needs a fix to clean it up and prepare for non-uniform swap cache split.

Use the same do-while pattern as the replacement loop.

Fixes: 8578e0c00dcf ("mm, swap: use the swap table for the swap cache and switch API")
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap_state.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 625c185a1ca4..cef44aadee61 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -396,8 +396,9 @@ void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 	    folio_order(old) != folio_order(new)) {
 		ci_off = swp_cluster_offset(old->swap);
 		ci_end = ci_off + folio_nr_pages(old);
-		while (ci_off++ < ci_end)
+		do {
 			WARN_ON_ONCE(swp_tb_to_folio(__swap_table_get(ci, ci_off)) != old);
+		} while (++ci_off < ci_end);
 	}
 }
 

-- 
2.55.0



