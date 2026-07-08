Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF3B4C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 12:20:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A3A46B008C; Wed,  8 Jul 2026 08:20:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62D466B0095; Wed,  8 Jul 2026 08:20:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F5036B0096; Wed,  8 Jul 2026 08:20:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2513E6B008C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:20:56 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A1786120113
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 12:20:55 +0000 (UTC)
X-FDA: 84965518470.13.D6951BF
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf28.hostedemail.com (Postfix) with ESMTP id DF398C0006
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 12:20:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=klKLKaKp;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783513254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pLR4NTdd81YwHMva27KFRdPfSNha1yNVphS6scVIA8Y=;
	b=OSpBkB+kbeCmAIYQAowOJUN//j/EAPKDoXOzUwMiYlte+qEb4pv13F6icOwSXyRkMGmRwE
	HHsd2pEzlT3H3BVXR2e7O6JnL+Vn/PTMYdQp9J9Y64BQxoekFZu2KtCOFnP205mP2VuS/f
	5MXs8Al9Sd7TwdPP/zrZ7Yx9Y7z++7U=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=klKLKaKp;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783513254;
	b=2truHtD7WN68eJjPJn9sNUUVNZ7JqvDYU8XUovIoYjLCJVUKlC/VH6E3ixOppqV1boY4/e
	1Y1FxLqmtaVg4ALAMn5HRZsKWzbKmgFtFPJn6HhJkHQ7f2vHdLUkgwWBkgvOxc6z+ImdHx
	tupJqKlNscyJi9+gheIgH2RmCGDJ7zo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783513252;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pLR4NTdd81YwHMva27KFRdPfSNha1yNVphS6scVIA8Y=;
	b=klKLKaKplweSEQGqTSBhvVQKqIE/wZDOFqmqFojo/YESsUhqb8YNMex/lxIBX+G7/lD9SD
	W+K/4Kz5m9z+IKgKIIJx+u11F0X5XEv5iPIIfBDd64Z0U01DH7+k0MRgMmT21SDLSipEYD
	TTmx4fKshMqLGdALX4PfGjY6QRogNLU=
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
Subject: [PATCH v2 1/3] mm/mempolicy: skip non-present PMDs when queueing folios
Date: Wed,  8 Jul 2026 05:20:07 -0700
Message-ID: <20260708122040.861335-2-usama.arif@linux.dev>
In-Reply-To: <20260708122040.861335-1-usama.arif@linux.dev>
References: <20260708122040.861335-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DF398C0006
X-Stat-Signature: f39soq9sprat1snczupbb5ufos6idw3c
X-HE-Tag: 1783513253-295474
X-HE-Meta: U2FsdGVkX1/lJb94qUGM5FDjON1xrJKAtXRWIFyeHhL7cH1UEYOgEZTIQCBsbYWQLy4RDeChHZDBvDRtS/XXQiH38uNvO0qCOQsb0AQovoxQxbJpHqlVKIVkX6UkMe1XEW4176eaLUrBefQxhQpInOYQin1bQXDwmTgqsrEN1TgKcz9kQjW6Nx5m6rzE08Sz8ZWIe5QebdRYGwb4Sx18OG1RyahUD+VfljfczKS15dmzmqm9OiamkwLpD/JsJZIE8dDXjdfpQFXd8XSf2LWZ9HMFmO40wkoCUvIXpQ7O6Gr4jPerwlp7P79TDD+80FSVLb/irIy9z0if9yYX8hfAyo8kaddV3Z3glHMbU5rWUPV5nT/5JUmbXpjprMIRLTXjkgTr9LAIVQ6M8aoGxULvdiOECtSisJZlcTD/d+/pJo+QEQYdJ6TsxMjnW/lubtlAXQvOCHUTdy7lJcN+eremvpjoLqJ8whLuw8khZVOS4pfw3JPUt48bJbHXRmVdoRazHLpYezlLcKO+qZ7dDbS3KHTPAgraKQOww/pBIQFFz7qlxrMIYmGduTJn9LVMhO9K5OC+H1W4SHN7ssmv4+aS2GPu+WEMEBIyi7q+ezoZ9XrWbl5Vc6H3PBAFDDL6vS+2G0gvezonqvJiHFNdJrZ6XVd9VADO+YYHttRkX1KWiZPi4XMYa4Majp4fXTzRzooyUV0VZnlJHgBdsBEedy2t4xkU0qMNG0/jhh23X6fAgG81ibKQ+f07jMhHT76NZ+JImPs51wDevXQqOrvddVzE4D0Uw4A45Q+8BiBzya0zWGxHGcCxc1sh9W5RlmWdoRrJuM3DyFhnbAigeLrv3VWuLtvOtzDMD+9M+hQ/lT9pPhfW6azN3yhr8XIVIdzTQyxrD2Seh85lnfBSCESHbIx79pEKydQHtNtXpMTmwMXw1dsRzAxfbqP2LvwzXYDiYGaNO7Sn1rBaUBZ20D+qax7
 4hqyB8HH
 VoED1iEGn4fl9Z5A9P45H+GNoVE/Zxa/pV2+xR3kLHvwDIUB3iECfcmmVdI6PnWtmgF8jWuoblcbJrceTu5EBb00hDWCqPmVwmuO3NhMoaII1doRBX0Hk1HRjpBb355bFboFx2nit2G31ZyxXh017nLTwTAV+xROdSz4IzGeVnokdYYz174dfM4LW7AwWnDcJUiHJHxyVntCBYKh/+CoAA8+eQOuZPlkrkBV7w6fXPpyBz9u4VVfLrwSre+7f2//uzwm1UTnPDLC1v94asEkqnyVl54eSZCCbdoJ24UtWuNfDO1f1c5y9L3kiqf/6p8O1+gyLvBZBAHGPjApW0SbQwtC//eyaSsqSQJJEsWSwpz8vFhWBxY/dRZszjwVIdlYU+Xn/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

queue_folios_pmd() is called under pmd_trans_huge_lock(), whose
pmd_is_huge() check returns true for any non-present, non-none PMD
softleaf. Passing such a PMD to pmd_folio() treats the softleaf encoding
as a hardware PFN and can return a bogus folio pointer.

Mirror queue_folios_pte_range(): handle non-present entries before
looking up a folio. Keep migration entries counted as failures, but skip
other non-present PMDs such as device-private entries.

Potential trigger: an HMM-based GPU driver migrates an anonymous THP
folio to device memory via migrate_vma_pages(), leaving a device-private
PMD. Userspace then calls mbind(), migrate_pages() or
set_mempolicy_home_node() on that range.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260703173903.3789516-1-usama.arif%40linux.dev?part=6
Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
Cc: <stable@vger.kernel.org>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/mempolicy.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 914f81863db5..4785b55c02da 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -654,12 +654,14 @@ static void queue_folios_pmd(pmd_t *pmd, struct mm_walk *walk)
 {
 	struct folio *folio;
 	struct queue_pages *qp = walk->private;
+	pmd_t pmdval = *pmd;
 
-	if (unlikely(pmd_is_migration_entry(*pmd))) {
-		qp->nr_failed++;
+	if (unlikely(!pmd_present(pmdval))) {
+		if (pmd_is_migration_entry(pmdval))
+			qp->nr_failed++;
 		return;
 	}
-	folio = pmd_folio(*pmd);
+	folio = pmd_folio(pmdval);
 	if (is_huge_zero_folio(folio)) {
 		walk->action = ACTION_CONTINUE;
 		return;
-- 
2.53.0-Meta


