Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E872C5DF93
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 15:09:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 960816B009B; Fri, 21 Aug 2026 11:09:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 910A76B009D; Fri, 21 Aug 2026 11:09:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D9766B009F; Fri, 21 Aug 2026 11:09:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 549A66B009B
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:09:31 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CE6F31A01A5
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:09:30 +0000 (UTC)
X-FDA: 85125610500.06.C7B2CFC
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf31.hostedemail.com (Postfix) with ESMTP id 236B42000D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:09:28 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=W0poab5a;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787324969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=km/KnQoou2cC+qse6JnYkYGCCo/Enm/DijWAIfXBagw=;
	b=pXxqKAMTOXxxF9wGTaiLHoIBuNvHvfBZuIY3id+pYBeMf0FV19ErmR0+C7ON1GPn22fH6G
	ok08279WyWwBd7Gk/FKol/oJgs8BepX0rojoByKcaTnW/nS8J/m1ZA/geEshBKlBdGEORF
	fK7biQAH+m6xjGQcv6vZtGdZL0PkUr8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=W0poab5a;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787324969;
	b=QXCJmrb+bIWuZ62Y2ITVSKgyaOJtil93Kg2yu6BfmHE97Hcx1S1Ud+SwzxqTXYpkjtIsrJ
	/rLZQGOIR071HPB9iNPgoX4cAI5p1JPD1+0HggT0TLZPdkEU7ajAJlaD8kDySOePjrHY9V
	YL1hgyD6Mac5JaPoldjAI0YWvj1O8M8=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-51c08df8513so6827811cf.3
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 08:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1787324968; x=1787929768; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=km/KnQoou2cC+qse6JnYkYGCCo/Enm/DijWAIfXBagw=;
        b=W0poab5a0mixnavSvIr2yQFf7H1Q7qw4Kx4gP3haXWNJikBeuQbFtoHVA/K614+2K6
         VDLLy5rSCz6aLT09GmfFxU75W4KZggxvYduO4IkoW6Rdb2FNR0Q9Ycioq8t8we0UvuCl
         QvIL5FOVLEtP0xG2Ee8OqAQcD1td/RtLQ68SrWM5pbNHqzHW3neJhWpqRsjwIs2bI/Sr
         m32eCHLeL/lc1SJRc1wdMhmuOMlehQdwSLOqRYstYpsmg0lhYcCZtqNyza+Qn3kRFGMl
         RHeNfwPoF7DeO0c51Yvr/CjlUv7PxgjOlwDJlMd8vTnxLzDztCc3BF16lsMn4ixbX1Tw
         kbcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787324968; x=1787929768;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=km/KnQoou2cC+qse6JnYkYGCCo/Enm/DijWAIfXBagw=;
        b=SomkD3tH+H5D5EBjQgOcptu1tLf5HC7AqCrE9bqfbwMiNoelhYfH/lKQwye1MFj2+l
         hmpN7IRfpUkt+oNTrQqEsoS+UAnsFB/0tAPf92Pi+K3sem+u3udmX8Fsi8FYJZnkWW0E
         AjPo4pHB24Fkl73kiJUUkCGOeAA/Zy/Tl0kLwRRw50RWkDj0boeYFhmIqwYTyYtnZGSm
         jQHyGUcGU/NjWX1WCl+axCtq38WKDvuXm8T9rDAP5307OJ1yibpyWHRCju2drc7a1/CW
         dtJBjF5KPCCeJKqaLQ7FlcbyZqlEzDM+lkcIJ6ZOw4AOgGe5CzDCwIs1L1b2BKeH3Mpd
         Yeng==
X-Gm-Message-State: AOJu0YzQdvGM18UUu+j/H7BiiHRItST/hgeEcmySOpeczfDIoCFhXEO3
	swXvoWoQdZ02qBbwDWQMYbN4xj/Q1sXsAgGgUsm9TZJ8ipSe5b1OT6NoBVjAfKorPI3jm06Af0T
	S1C55gbc=
X-Gm-Gg: AR+sD12V94gcKJytrqJLtXsIneZfyuPJwzN3CV/bYT5ORXB3I1sJVwrvxESzC+EFNbN
	w8neLzOccWUBePFUuYspuq5O7oxPA/ePieGQQKQTHx+VAv78C1x5BpXcv1q+myza8OJ0N2UQJmX
	lg2zf8U6DbRXv6dRkqinwot9rlRUjkCBXV7YmIQOBxF6AjBxXsuUILJYs9Xj+UJIpRtlmJn+RMG
	0aXjMR+a8FE60kxN0PWCxWtkiTi60TcfhdfKwBEz0HttHaDgeeQAKNA4qvaiy2SPWlmsqMkdO11
	dpnLfpBZI0UjYDwOA3cI885vySNIipuPbRRDsbSzniobfmPQ0zTL3scg0LOM4tqdE+oiEsftLde
	dpBkqqYGYMyogtdVIf0uHDpkRVRkJhGN2157WIolOQQWyC5aJnQi1tTEZtc6RS8Z8GE611S/8/4
	pAxhp3/RFXSlpDDjY1GS3S4S9efws8aTI5938QVepLQrWgbRUEMjIJishBqrfiwwSbBM9wwVNKc
	rmAXcxKvXP6u0A5GI0CYIQlaiowmNJTIsSZVmj/xY7juIL4Yg==
X-Received: by 2002:a05:622a:17c7:b0:51b:cdc2:fb99 with SMTP id d75a77b69052e-52df5a08502mr70705551cf.24.1787324967962;
        Fri, 21 Aug 2026 08:09:27 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52df40eb50csm19708061cf.0.2026.08.21.08.09.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 08:09:27 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Gregory Price (Meta)" <gourry@gourry.net>
Subject: [PATCH] mm/madvise: use folio_trylock() in the cold/pageout PMD split
Date: Fri, 21 Aug 2026 11:09:12 -0400
Message-ID: <20260821150912.183976-1-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 236B42000D
X-Stat-Signature: 7er4mg6i5gait57b8fwgcdf8yj4x1afi
X-Rspam-User: 
X-HE-Tag: 1787324968-780081
X-HE-Meta: U2FsdGVkX1+e9GoQXoCfo5rKg8nbpaSv47Oyfxv5/Xh/nIHQ6n9VQ9pjx3zl9SvZnpYKVzmmpt/CTtxVC/eRkwJ1ZH4S5IZmGMH/qsjYa78iB5OjUtaB3gFtc5PVyFO9AoUpzjNC8LKUMUMrn50ynSMs9FrFJUbQw8JQdltJdsz2frq1lWwiowclufpe+1pm5wEsOdu4bd87x2OR+4dL07uQfTAhtIyc1322nmqmy82Gwx9OMtROXP7bpnHN/Lmq64ojemPeahuuxz8VhdiGhF1c6h/2AtObY2baR8r1ZuOLXL69V4BR6DCBui8/pB5YmJQaCo78y9PX4XT4Zzu7igyAn7SgFqNbnTwplQZXQbRCyj5WjlmNIJ4iEqreQrNAWIN5Z008IY1Bqi8hcqRCs6RTQSoB352ITSY73s9bAHR0F7t0kUXf8Ph5L5V4GhXDZY6DizCHi4ZFG0cf1e56kXE10BFZhwlOy6ObhOVK5lktjj6OJEu2icCXuQOIdiphw1RDh2hmApnQBY6lyXS+jQ/Eu16Ood+r2FnxUfZ5KDBR/E+cVQLNyx6YhXlkJ/3rpbZsmNXEKdfsYO23YksBu7/3mxT3kc3f7YKP8t1qAn1dYm1F2QjskQBy3RFTvF6NkvOzJvtij5ir7Mw9dyM52CslvmnB/IHgwJAcdvM2BOO5V7jhu+lUYMTYgM2Y7iEuRCsptz3w4xzSFnW2GePK3CqdJKKIN//sjuJaW0rzcvDVflldVMQU8KvCCUdzYsUvf0Olab/UnAX+m48iteT0c6pnC2yae+DWH3TIoBfaciQoSyQbCJSv4Vh6E4qJvz4JAvFecW0ON6d2NzDss76aALhZJa4lLaJ0Xjl/rve9u8Sq8kbwZVdqRLiOKkpABxuQ7m+1wmb9X4xlZHOjV2HdbVFZmbWoDH+9OvmipBuUjaSq56+iNjqlluWyKBl86MIdJXBzZy+qtt+u9Q9L4eb
 9UCS3ehk
 f3juFKzByHyCFlf6VIWCzQJphgGDrpPzxzBXP4Cg54HvF567r0SMZCDY3V7pbdufhjwk3GfzNftdz6+bNknRqG6B87Ef3u7IMglcQbGC4hIVVsRckErsvwx5bmHNyMNCvUtgsomaU1edSNosRGY/YVi9amtWHYlyE9CaNmlorZyBPQ05DQig9cdjWY6VHAmopjAA20/pF9dfSkwqkhnlOJNB+Qt+Nxp/nzvkjlRNWBvQ7frIaCA4blEWJgPJYhjILENHAsM8YW+INypjVaW/RLnggXnt63AzlRhcdJ4n9SU0WLVGjzqFm2Wrb5QieqQqP5dddQSuR0kZ5+c4sd0uV3Do7pi9g2tY2y8AntRY5xL+YslR9oftO3vwjrLx6ih4MRDuurukEbFbbDlkWhB5aJk/ObJORz9OZY7Y4ilRMd7a7k7mexlMdeJbdAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MADV_COLD or MADV_PAGEOUT over part of a PMD splits the THP in
madvise_cold_or_pageout_pte_range().  Two threads doing that to
the same THP create spurious failures.

  CPU0                          CPU1
  ----                          ----
  folio_get()
  spin_unlock(ptl)
  folio_lock()
                                folio_get()
                                spin_unlock(ptl)
                                folio_lock()  <- blocks, keeps its ref
  split_folio()
    folio_expected_ref_count(folio) != folio_ref_count(folio) - 1
    -EAGAIN

CPU1 cannot drop its reference until it gets the lock CPU0 holds, so CPU0's
split always fails.  folio_trylock() makes CPU1 leave without ever taking a
reference.  The PTE branch of this same function already does this, as do
madvise_free_pte_range() and madvise_free_huge_pmd().

Reproducer: 400 rounds of eight threads calling MADV_COLD on half of each
of eight THPs, re-formed with MADV_COLLAPSE between rounds.  From
/proc/vmstat:

                     thp_split_page   thp_split_page_failed
    before                     3186                     860
    after                      3200                       0

The short before count is rounds where every thread failed and the
advice was dropped for that THP entirely.

On failure the walker returns 0 and nothing retries.  The PMD path becomes
best effort when the folio lock is held elsewhere - same as the PTE path.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260817220810.1175596-1-gourry%40gourry.net
Assisted-by: Claude:claude-opus-5
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/madvise.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 07a21ca31bad..bd9119880ef2 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -405,9 +405,10 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 		if (next - addr != HPAGE_PMD_SIZE) {
 			int err;
 
+			if (!folio_trylock(folio))
+				goto huge_unlock;
 			folio_get(folio);
 			spin_unlock(ptl);
-			folio_lock(folio);
 			err = split_folio(folio);
 			folio_unlock(folio);
 			folio_put(folio);
-- 
2.55.0


