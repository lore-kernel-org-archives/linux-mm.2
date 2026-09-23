Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3A91C98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 21:32:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E25A6B009E; Wed, 23 Sep 2026 17:32:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1936A6B00A0; Wed, 23 Sep 2026 17:32:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D0506B00A1; Wed, 23 Sep 2026 17:32:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D433B6B009E
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:32:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5485AC0141
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:32:46 +0000 (UTC)
X-FDA: 85246326732.16.F8BB7B2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6A762100009
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:32:44 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MSnXC3ob;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790199164;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=67PY3pgKoYnQUxj/r2xV1xSFzHVbYNKdoqPwkcjQS5w=;
	b=Sh935ZIgExAmHfOIYYcaytgy/VDPxD21k7OJVKvAOpQBLuTMxhcQjDm5G/4bOHd0xh9Wdt
	D+QoCMXT6KKccDnQwZb3nOR4cQhJZkfYO1cfwR7dbkVn4FlM19udjbwEQ5UEPdEDEWM3nd
	PHIuVcFMKUgftOEzqSQntf7g1GsTGKE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MSnXC3ob;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790199164;
	b=LypfPmpjrRv1tZMA6x9KcGvPw7dX/z2VaPwTuuHuFuhE+1H7EFhR0y9Fsnq+nkLpVBFfXp
	1cRhh4niwBz1bdZptU3f7NzAD0u8cE1vficwRAUlETIojYqn1QF3b3y7eps8l2w9ELuFHv
	4jlrvMzyQdiHWNx1JD5eAXxXvfHdB20=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3246A60008;
	Wed, 23 Sep 2026 21:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CED3DC2BCB8;
	Wed, 23 Sep 2026 21:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790199162;
	bh=yJwx3LFN6Jb/AbJSL4mP3ngyI/fgl2LvbA8+QvfNDK8=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=MSnXC3obsLviV7aXic1WHuHsgO6WyeLg0FlurffqdupIFy724c9fNChaBcGAHHibJ
	 IkOj3C4NcFw/j3/t7RDEPWj25TYvzgO/6FgWHqBwB4jKbPG1AXalLqzYlYJEOVHiHp
	 DKw3bIsunIK8+gFr4sU6j7ybtK+2juQioYn6ACj2z6bmt9K5PNzctns4L34rWIXnxW
	 3uV/zF1Vmq3kzsOVFrlPNMC7WgsMNXdEuoajQUBu3vXq6b9iLiJ3WSS2XYnmUlnes+
	 beGjpUzdIL0hSmEGsINUmbuKXYm6FTkqaEFGDk1jMn5o1sR8nm29b1ARhH49Y2O89v
	 fInFrAV2reSqQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4634C98302;
	Wed, 23 Sep 2026 21:32:42 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Subject: [PATCH v6 00/17] mm/huge_memory: clean up and decouple the anon
 and file split helpers
Date: Wed, 23 Sep 2026 23:32:31 +0200
Message-Id: <20260923-swap-thp-cleanup-v6-0-ba1b4ba72c6f@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/23P0U6EMBAF0F/Z9NmatlNK65P/YXxoh0FqtBDKs
 ms2/LtljREDjze5c27mxjKNkTJ7Ot3YSHPMsU8lmIcTw86nN+KxKZkpoYywQvN88QOfuoHjB/l
 0HrhBUoEMthAsK2fDSG283smX15+cz+GdcFqdtdHFPPXj131zlmvvl7d7fpZccGOdA+drRITni
 RJSmh6x/2TrwKw2hIQDQhWiUUTaovFeuz0BG0LJAwIK4YKGtpIGFNg9of8Id/iILkSoQHlolaB
 a7olqQ8jqgKgKAc7WNkDdtEH8J5Zl+QbKyuIY0AEAAA==
X-Change-ID: 20260804-swap-thp-cleanup-6ce2be6cf3b8
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790199160; l=6412;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=yJwx3LFN6Jb/AbJSL4mP3ngyI/fgl2LvbA8+QvfNDK8=;
 b=9H5m9RcQQDhhP8RBpbQf1MZ8hnSoY7VYjd9T6prEy7qQ+wqXxxmtINkdtu7o62TO9yl7cZ3Fq
 m38WfwTtcllAS7LJgnRasNHclbKy7tWyVqeyeAz+gN1vYkD7LC+J8Ze
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: 1dmuy8q7y4a9emiewsutaj6gwexk1r9p
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6A762100009
X-HE-Tag: 1790199164-879801
X-HE-Meta: U2FsdGVkX1/KR5wWmnnERa/OiD/OSUjK9QE5QpE3F3o4jiP+kW9ELHG+7aKULMTC6rovW2p9Zx5rht1CZP1d8GMq4LqpWxZWgT4D12+Q7fLkx03OTk16/5PWRlHmbfdD3mq54df0TnVTrXWe/p8OuoUp14PYycO0C2dCOu+sANb521UTZz6IaHlK17Q/KbvXbVgUcGfhhyg9Fk+nSinFhwWHpeOi97+hH4mVAQXiYHHbGaNbBuMF7tcToW4uOKOm6KiHOzsvFVInLulaqAmVriMGIOlYDjDuahamSzmqwisL4vmhDdZxupSIY+Uwm5dl6uGPigBxsdLq4LU/DjjVc0GZaIcj9ZcZ3Ag5EdVER5u4Jh1BBOp8UtZbIL9nrwm4G5Cg+H5suzsVAgLrQOMo8obcc79MYK0cICvqiepV7K1FgrHQ3HmguqoIb1Nf12I5oOvQ30KV5lvv+LJREjzegIaDKakg6Y5Kt3oRrp3F8SVo4i5AczY0qhc2JzWw6IidSr4SLt0LQc8MFpKv+1Z7ItRHF/51cImK/AuOpjnYC8fp6yFiz8TFtub6s3GDybNCozi+CeWPSvRwn4NTBWeH1p4BS8rQeCO3RnUCwRfiE6ySUjooI9EGez3EPoFxGwQOcLXLQk+MY51kOducR5oWE3Iq4AnAQL5q77H8SkhaDxDYLtgMfkkGTJ7MfFjPvVGHd3zyjEqUZoEG9fx2Iub0PsIzsx/ZKsoc4R0Fgko1lSQONQpfpQyZGXgkjwkaOy4PZq7Wp+9RF+xH2/+F53NbefqwLOvB60RvjPQJ9Jjo3DUu1WtxpDi8FNRLN+JGYGEdOjXynoq70rb/ssb+S9TuMn698ZwvxfBKFuqRQ0xGfNrpxBuyEW8Ih4HvCn76qUwBj0GP3utcMszfyCilmEv3ctgZDZU5oV0a9wBlV6Pvb+EVMHmXuk7QDiqVYk9KHdtvrZRVqFmCU3mMeidNXS4
 KKy08Rnr
 JUPmgtJvXl3zy//6quRDViVUEEREYe2NbfH8L09shqo2alLkwmXBn2lE4Coxu7TD4DFDR+NPaWLPj8WFg2NYo1isS0BgW1sL/agsToz+lo+U1ThqkmofRYv8Xp2XdSoEw8sIBhfu2NImeuFSYZcstbcwjvXuLV0sQa4qkdzoMGxcJc/ptiiLuZMJLa7wAFNisf2hCU1LmYRMPNBmPreVn4XGYo4XC0apz+5p9IlNWgq6ZAAzUfqlAWPhrKeMz8hLthuHac8wWp+H7o88gKFZAKpiZhgiVggrDqBLgHy4Vky1ltecnr3H81FUkUnPN95Jvue1c+EpE3fN34qfLomthJe47z2DsIN376FB22/oDtun5uxRKhN4JdqNGvTybnT76Hn1wXZdEtG1PamHhGlKo4HyxGDQC/9iGY/e3rk2Ao885kC/8hrAWGqo4Q6CEae7o/0dRaq1SrxYwW1KycZq+VuC5hxLaXLwAATvkqWLimwANvzXQmTwjSC+C7HhH13h9BXINqh14/pl15XUjm+Bri1yvATe2baTgOFJI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The folio split path handles anon, page cache and swap cache folios in
one routine.  That mixing is what makes the swap cache split
restrictions hard to lift and to review. We now support uniform split to
order-0 only, and no mappingless swap cache folios. And it has left a fair
number of dead or redundant checks behind.

This series prepares for lifting those restrictions by cleaning up the
code first: split the routine into an anon and a file helper, and keep
all swap cache handling in the anon helper.  The file helper never sees
a swap cache folio, folio_check_splittable() rejects them up front.

Apart from two bug fixes (patch 1 and 2) and a slight adjustment of anon
splitting (patch 12), this is a pure cleanup.

Testing:

The in-tree split_huge_page_test selftest (uniform, non-uniform and
in-folio-offset splits of anon and pagecache folios) passes 62/62 over
600 runs on the patched kernel.

ftrace function_graph tracing filtered on __folio_split() was used to
compare per-call durations between the base and the patched kernel on
the same x86-64 box (interleaved runs across alternating reboots.
135 split calls per run, 600 test runs):

Before: 68.52 us, stddev: 1.58
After:  67.38 us, stddev: 1.33

The patched kernel is slightly faster. The stack usage and object size
change as the config and compiler change, but in general the stack
usage is reduced and object size is basically unchanged.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
Changes in v6:
- Comments updated and make a few variables const as suggested by
  [David Hildenbrand]
- Link to v5: https://patch.msgid.link/20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com

Changes in v5:
- Rebase onto mm-new.
- Rename remap_folio() to remap_anon_folio(), and reword the changelog
  to explain why only anon folios are remapped. [David Hildenbrand,
  Kiryl Shutsemau]
- Expand the folio_mapped() comment in the anon helper, and drop the
  folio_lock_anon_vma_read() reference from the changelog.
  [Zi Yan, Kiryl Shutsemau]
- Kept the old test result and the code change is identical, and initial
  test matches previous results.
- Clarify the after-split folio freeing changelog.
- Collect Reviewed-by/Acked-by tags.
- Link to v4: https://patch.msgid.link/20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com

Changes in v4:
- Rebase on top of mm-unstable, also mergable on mm-new now.
- Patch 12 might need some attention as we can skip anon_vma locking for
  unmapped anon folio now due to further cleanup, including unmapped anon
  swap cache (not mappingless swap cache).
- Drop the two swap cache behavior changes, will be sent separately once
  this lands, so it gets its own attention. Also drop related doc
  updates. [ David Hildenbrand ]
- Rename the split helpers to __folio_freeze_split_anon() and
  __folio_freeze_split_file(), frozen implies unmapped.
  [ Kiryl Shutsemau, David Hildenbrand ]
- Keep zone_device_private_split_cb() in the anon helper only, and add
  VM_WARN_ON_ONCE_FOLIO(folio_is_device_private()) to the file helper:
  device private folios can only back anonymous memory.
  [ Kiryl Shutsemau ]
- Replace the "bool unmap" parameter with a folio_mapped(), rename
  remap_page() to remap_folio() and document it. [ David Hildenbrand ]
- Move the racy folio_expected_ref_count() check into unmap_folio()
  instead of duplicating it.
- Make more locals const.
- Reword the mm/swap off-by-one fix: non-uniform swap cache split is not
  enabled yet, so the bogus sanity check is currently dead code.
- Collect Reviewed-by/Acked-by tags.
- Link to v3: https://patch.msgid.link/20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com

Changes in v3:
- Get rid of for_each_folio_safe and open code it.
- Check if the folio is mapped before freeing it swap cache to avoid
  potential performance lose.
- Initial test and binary analyze showed everything is very similiar to
  previously series.
- Drop the redundant mapping argument of __split_frozen_folio
- Link to v2: https://patch.msgid.link/20260813-swap-thp-cleanup-v2-0-d2ee48c6aa49@tencent.com

Changes in v2:
- Return -EBUSY instead of -EINVAL for swap cache & shmem folio split
  attempt.
- Introduce a for_each_folio_safe macro to dedupliate the code and
  hightlight the reason we need to keep the iterate safe from folio
  freeing. [ Zi Yan ]
- Rename __split_unmapped_folio() to __split_frozen_folio [ Zi Yan ]
- Rename __folio_freeze_split_unmap_anon. [ Zi Yan ]
- Several comment improments [ Zi Yan ]
- Drop an unused do_lru argument.
- Previouse test results are basically unchanged, stack usage reduced,
  object very slightly larger.
- Link to v1: https://patch.msgid.link/20260808-swap-thp-cleanup-v1-0-689939a7ccc3@tencent.com

---
Kairui Song (17):
      mm/swap: fix off-by-one in swap cache replace sanity check
      mm/huge_memory: fix rejection of swap cache folios with a mapping
      mm/huge_memory: invert folio_ref_freeze() check to reduce indentation
      mm/huge_memory: split the routine for splitting anon and file folio
      mm/huge_memory: rename __split_unmapped_folio() to __split_frozen_folio()
      mm/huge_memory: consolidate irq and locking for folio split
      mm/huge_memory: move EOF trimming into the file split helper
      mm/huge_memory: move unmap and remap into the split helpers
      mm/huge_memory: rename remap_page() to remap_anon_folio()
      mm/huge_memory: move the racy refcount check into unmap_folio()
      mm/huge_memory: move filemap management into the file split helper
      mm/huge_memory: move anon_vma handling into the anon split helper
      mm/huge_memory: move memcg switch into the file split helper
      mm/huge_memory: drop the unused do_lru argument of the file split helper
      mm/huge_memory: clean up after-split folio freeing in __folio_split
      mm/huge_memory: count only swap cache refs in anon folio split
      mm/huge_memory: drop the redundant mapping argument of __split_frozen_folio

 mm/huge_memory.c | 584 +++++++++++++++++++++++++++++--------------------------
 mm/swap_state.c  |   3 +-
 2 files changed, 306 insertions(+), 281 deletions(-)
---
base-commit: 55f19451cabacdf97712a9c26a3def6d3ff8ff56
change-id: 20260804-swap-thp-cleanup-6ce2be6cf3b8

Best regards,
--  
Kairui Song <kasong@tencent.com>



