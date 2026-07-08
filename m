Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2803C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 12:21:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89F726B0095; Wed,  8 Jul 2026 08:21:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 876866B0098; Wed,  8 Jul 2026 08:21:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 765AD6B0099; Wed,  8 Jul 2026 08:21:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4A8FE6B0095
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:21:02 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BE99A166158
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 12:21:01 +0000 (UTC)
X-FDA: 84965518722.29.E8AD471
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1F9D610000C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 12:20:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CtaObjrd;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783513260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Fn1VOZHGCiDZaYCm98LuGj7iddLxiK8xDaGMUh3nqA=;
	b=KCwxhrzZSmgk8b0ixMnUulvEMAotBkcihm7g0nYwOH3zfF1GU4k71SCKSpxz1GF0nB82oD
	oGxyCgi937/NnkdGtwaF8C21o7zW22De0L3jJhqugs+2gZz+baga6PupqBOvo08pZoLT5x
	UiH+XaGob0n5259xqk5CsetIlaGvyig=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CtaObjrd;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783513260;
	b=wVtU75DsgScoLsD8WUinFDuKRWrlprcd4R5kt3CX+Y56tJ7VwC1xJudvOcf8gsDl40hJya
	VEcHVYC1vQ0k+YehqXxHF1higEAm93VH/2J5ZrQJNrj2ElXJA2vN4Bg5I3YwTTaF03CHz1
	ni5LRJLRS8j0LAd0uL0hZyAi4SVdeHs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783513257;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2Fn1VOZHGCiDZaYCm98LuGj7iddLxiK8xDaGMUh3nqA=;
	b=CtaObjrdR977XBk5Te7aEsP20O9ZZ1icNmNajWdyd2wpUY/OdU9o0CqFpIc2L3g1OKXtBF
	o5Vy+Rv/QkfN+NdURZyX6kVlf1nGAIIzF4AmBh24KQVSICX6gerC569Cb0Etg4f3HmitjY
	+rF24lBH4avmkC6JF2hd2DODvXvECAc=
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
Cc: sashiko-bot <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v2 2/3] mm/madvise: skip device-private PMDs in cold and pageout walks
Date: Wed,  8 Jul 2026 05:20:08 -0700
Message-ID: <20260708122040.861335-3-usama.arif@linux.dev>
In-Reply-To: <20260708122040.861335-1-usama.arif@linux.dev>
References: <20260708122040.861335-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1F9D610000C
X-Stat-Signature: up3jfxjjbrwmc81seo9gsp8ptfb3jacy
X-HE-Tag: 1783513259-651116
X-HE-Meta: U2FsdGVkX1/nXFuDZr+KyvUaC+YMyuCv1eClaCz90EA0lqRK9FtVQkKisZPFp8coO+rM7wLv2Jiy1RAkQXi/nXpmpHh1lpV/DXOcFEX35uD8cHs0YZvKZ3SyjePR08NJyRf5ygw7cudZgtgS/WRbvWXiAWfe2UHqHW7enpDNGJGBvj8jJEuS0K7xJG8OY7R03KmA8m9JAw7pXXBfANIYqLMYfAzKtlE9GWYzTwNO8J1kTPInF153Rm97i/yVm31ZpO3lnbh/FVuvwLEI7+9mClza3lRDo7SurZADntGDw1ejyRMEwV2AvB6MKL12e1Iw3JOF1/4uZzuJiJQpC2uiWjCcHg/VLbhG5ndnstwMTTVsTUd0C8qXsPilnX7lO7QsKbz9J/hKUOSowaXU+f1hFXaV0Y75QoOW6h/ygL84eb1KD6bb3xUkVCo1sr0l93ZgIOpKjBRB3axnWf2tmymt2M4QCA6DRGs1TZXTc1RSRnDNyv9sTk3OSu31wRBsDj/oj6yDalJ6KaWWzn2bWcW1uKeg379Kabx9lIqO1pODp2P5+9mbU0JTv6lRkLPavxwnMOs3cPYoc22I/q1hpedp84XAEot/4YH6UWKfvxFHpahcbJ+7IX4AMLLsFA3sPz56L5/+bPAkMG7NM7h3Jt7r36tf6Fn4EUNUmJ2r5JGvmIXhz1yiTDhNTBlBU+Bd6vvi4QdTHO3xKrhxZkoXMFoNbT9dZrTPddeUu0byplbeMPG2V4upOtF16+gEgTrmHnJgqenbNgIhBhPQi4OxGjfiD9kFSxXHFzP3l6e53myi7FIm+OtxTMkTNwfBg7U1OwVo/20dSUSmJaObGufmmhmQuQP+FqPrDCT6TKyd4CCQ3SOGSOPmJD+9OAzi03yhXlMgpvzzI/tFOUOz7O7ZHGUFJmol+XH9500zqVjBbWBsUX/foxtzCZePSwgjK2QoMT9Ul1xDLNM6vwHpU3gfxIF
 d0It1vO5
 C7p7Zjcmx1cKaPsTw29nTeTS5138ICyCtaVEnAHjX45V1LeLmGKvNfZ8OZO5VTmGNSxZze++uOF2tx4cuVYGNxX41lQeCNeGtqbfE/rf1fOWQXwhtMIqmwXl4jO4OYdjc8vj+ZsBm0uWF9aNzqfNxI+c8Hc65cmIV3NeOsGsw5II9twvgCXZbDvPCL2IzG4FN2gCn0QhY5x0Jb4+sdZ2Q138Bs0fzBDTS8J0ZFVfUQN00dDEOkyY/MtZ/n0nc4p1aKoOUL9f8TEnU4VEF9mr+c1EtHMUo3IelVODgbPWtVFwp/miz8KcBfDGNs3j3ufJmEq4lYn3sOLzKgn1n0id6uU+P/wyKz5588wTllFTXhPLbqMhsX2RWUUCfhTgGnFlCb88l9QvX74IvjmJ3xZGK2TOpjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

madvise_cold_or_pageout_pte_range() takes pmd_trans_huge_lock(), whose
pmd_is_huge() check returns true for a device-private PMD. The subsequent
!pmd_present() branch has a VM_BUG_ON() asserting migration is the only
allowed non-present case; a device-private PMD trips it.

Allow device-private PMDs in that non-present assertion and continue to
huge_unlock before calling pmd_folio(). This keeps the assertion for
unexpected PMD softleafs while skipping device-private PMDs like other
non-present PMDs in this path.

Potential trigger: an HMM-based GPU driver races with
madvise(MADV_COLD)/MADV_PAGEOUT: pmd_trans_huge(*pmd) reads true, then
migrate_vma_pages() flips the PMD to a device-private entry before the
PMD lock is acquired.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260703173903.3789516-1-usama.arif%40linux.dev?part=6
Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
Cc: <stable@vger.kernel.org>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/madvise.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 9292f60b19aa..1065b5a84ea7 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -389,7 +389,8 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 
 		if (unlikely(!pmd_present(orig_pmd))) {
 			VM_BUG_ON(thp_migration_supported() &&
-					!pmd_is_migration_entry(orig_pmd));
+					!pmd_is_migration_entry(orig_pmd) &&
+					!pmd_is_device_private_entry(orig_pmd));
 			goto huge_unlock;
 		}
 
-- 
2.53.0-Meta


