Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D902C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 12:20:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 606D96B008A; Wed,  8 Jul 2026 08:20:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5909E6B008C; Wed,  8 Jul 2026 08:20:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4597D6B0092; Wed,  8 Jul 2026 08:20:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 163E86B008A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:20:51 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7E84187023
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 12:20:50 +0000 (UTC)
X-FDA: 84965518260.11.4054456
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf08.hostedemail.com (Postfix) with ESMTP id 91FDE16000E
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 12:20:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MoRVEU5I;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783513249;
	b=X7TQHAqkQwinpM4hUGgZTDIghVPJT3L6Ww4Ss02EtIlVw3eXoSYMNkL0gECAmjeoHZkIU8
	Kyd9eQk1oR1D+OrqlpePzbjCDbjRyrwenWNrnfTZI+FG0rMUcch+0Xlls9hTR1Ce2MuZH/
	KoEWn5nQ9V0wklce+fOUAmFuma6U6jI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MoRVEU5I;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783513249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JE2eto0rTcmGeQDmN1z5HNPDhBhNNJkb6xZo9UCW1u4=;
	b=HBYCV7qhblHm9mtM6CGJS0Ag0WrWX50CX6BCaw3ebP3qqEYqA9JXZdTcanm7u8ntClbp35
	3HTWckGup632oWAdb2F6qCW9JZoA6T41Ef2cWhoipQh+Hhf9KAHjRgJfLdCRQ4NvdAopir
	SQQwkDw5tUMutS4v+PWVrQMjJVMP9DI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783513246;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JE2eto0rTcmGeQDmN1z5HNPDhBhNNJkb6xZo9UCW1u4=;
	b=MoRVEU5IKS3apV7HlZfdXtZ/WUvo7E4qL1LcnrjycfrSCQlpQGlanolDS8Xv436G4Vr+sF
	hJI9Mgkj5/Sl/AkpURRpVaD2lS5PFDaMf+ZmumQWuy3DC+OSjIVKwxZUKkK0Fq1LSQkayo
	TBEUrAKEq2AG+v6GX/ra2MBKIbl1UDY=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	apopple@nvidia.com,
	balbirs@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	matthew.brost@intel.com,
	npache@redhat.com,
	rakie.kim@sk.com,
	ryan.roberts@arm.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org
Subject: [PATCH v2 0/3] mm: handle device-private PMDs in walk callbacks
Date: Wed,  8 Jul 2026 05:20:06 -0700
Message-ID: <20260708122040.861335-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 91FDE16000E
X-Rspam-User: 
X-Stat-Signature: tf9tpx9hpsiyuxmyqp8tuz4334en7nng
X-Rspamd-Server: rspam03
X-HE-Tag: 1783513248-589984
X-HE-Meta: U2FsdGVkX196m87snGgiQeUbuBGlnwOguB6LFjx03nO0czmZ1/dfxrGx6SfX5xCHNOCZzm/n2Q0YAmCYYWAfGlTYbSjUF09cvCyMJGBjOZFJ16lvXsRMXytSzh8bAnEZhjWa2VvUrYxqS0LRejDpeuQjyW+ixS0sU0qLs1/vQKIrK3K/vl2qPFoiW2hTHT/MQdjUPTMyF6pbNIqtbFzFiVCMBKWyNH1Q3Rh16VTIOCJyy9rf1/QoIMgliuzWeDwuuGoqsusnKtV+z3HLOKsT4+0s3r23WzXHpcu6PtAzhloWEHDws21rvLTvPh4AK2fyrfvG0Pz8l+bDqjEKrw1nEz74MBbGik82H5wJ6P3Omv98vZIVdU3kY5cDe3Atp0JG8BcmjRRfkhhu3XLh0a/vhjoKoPtfhRdpBWt/j23py0UHFAl7Gu0qnsVDXMMs2/RLgxNaq7ULTNSPoA33ftEmJg9ggYqQbil2oBSpxsr94MD9loIIHWuqNwUX1GFhEfPoz3J7yBDjvK7SiySZARhbZ4QpcWBHNamXh8FpAWJwRQg2onZj8hBkoJZmXRcZT2PBaSabqyWtybjUhJOzeIWKxRr5tOfDALY+c+nyaohdQzUKASq0dBcRnmPc8RuZP+/i97kHaUeP5dc7yTbEFixJWF9MJ/XMWuyG7gu4MK6FqSyZ9VBrOpVVLw6BR2lQwL0qMn2bQUEvT6MwziPgya0pVWClYOtexRg7HQ/doLkfOHnUjQA3r+t3VfSEpTJX1mPhyu2gJYogjwZ2WDSBAa0MnEqVXz55AxYjraW2NlD702rbdmvT0Pildy57QnMmxL9NifME5F6Dd6qPMgK0mHGin2dVIw2Zbuxd+wkpfKbWtA+FhT4/MuOvNC5IA/bHSh1bkfXAR9cAXSqgnIQxMQBG5TK+tYy2adbp+8MYvHycyZ+vCZr9vHYDT3zHgg08VKi2j54gSjMgTRYc47Lcplf
 NttBrSJL
 QO/BkEI08VCkqWsqVW4E8dMn6kE+tes0JjWuw0HpkzGRKX3qRY4nSENFdC4+K3vYuwrbaMtAO2sE2Np5ZYuNcWMW6VsczzWdYJ+RyTsFbqU4JPUUvZtETV+HPEajN9WzquDJWTOFTe3zlFF4XexVlxkPMFIyv0rX3ejsDJgNoLmlapHRYSZi+sD3qRrTm9cGVwFIOl8x3hAq7Ge2SasFLQBUJsWfPP+1CEEuC7zfP0P7T/nOXh43DUJ7jejoxjXS9Nm2ruVlEYcNJY5Occo6i0BcyaR2hlU4VwR71plze6I83PneThC+M0nACMWNZes+nVWw4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I have followed Joshua's suggestion in [1] for v2. The patches look different
but acheive the same goal, so I have kept the Reviewed-by tags from v1.
Joshua, Zi and Balbir please let me know if this wasn't ok!

Since commit 368076f52ebe ("mm/huge_memory: add device-private THP support
to PMD operations") a PMD may hold a device-private swap entry whenever
an HMM-based GPU driver migrates an anonymous THP folio to device memory
via migrate_vma_pages().

pmd_trans_huge_lock() succeeds for such PMDs (pmd_is_huge() returns true
for any non-present, non-none huge PMD), so several MM walk callbacks
that used to assume present THP or migration entry are now reachable with
a device-private PMD. The results range from a VM_BUG_ON() firing on debug
kernels, to an oops on a bogus vmemmap dereference, to silently isolating
an unrelated live folio from LRU in the aliasing case.

[1] https://lore.kernel.org/all/20260707191917.3213033-1-joshua.hahnjy@gmail.com/

v1 -> v2: https://lore.kernel.org/all/20260707135255.292870-1-usama.arif@linux.dev/
- Patch 1 now gates queue_folios_pmd() on !pmd_present() instead of
  checking only pmd_is_device_private_entry(). This matches the PTE path,
  keeps migration entries counted in qp->nr_failed, and skips other
  non-present PMDs such as device-private entries before calling
  pmd_folio(). (Joshua)
- Patches 2 and 3 now fold device-private PMD handling into the existing
  !pmd_present() VM_BUG_ON() condition instead of using a separate early
  pmd_is_device_private_entry() check. (Joshua)
- cc stable (Zi)
 
Usama Arif (3):
  mm/mempolicy: skip non-present PMDs when queueing folios
  mm/madvise: skip device-private PMDs in cold and pageout walks
  mm/huge_memory: skip device-private PMDs in madvise_free_huge_pmd

 mm/huge_memory.c | 3 ++-
 mm/madvise.c     | 3 ++-
 mm/mempolicy.c   | 8 +++++---
 3 files changed, 9 insertions(+), 5 deletions(-)

-- 
2.53.0-Meta


