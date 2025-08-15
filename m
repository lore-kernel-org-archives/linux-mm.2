Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 616D8CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 10:19:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA0888E01EB; Fri, 15 Aug 2025 06:19:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E76E78E0002; Fri, 15 Aug 2025 06:19:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB4328E01EB; Fri, 15 Aug 2025 06:19:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CA5FA8E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 06:19:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 283BD11821E
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 10:19:15 +0000 (UTC)
X-FDA: 83778594270.28.60D954A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 82B30C0004
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 10:19:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OtxIvXeC;
	spf=pass (imf22.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755253153; a=rsa-sha256;
	cv=none;
	b=ictDsJYFpwPtUQjCneRfsnhZoSFT81hL8smNxXG0gfpp6D6R5jR0Ff3djG1Mf0RSdFiFrE
	ZdrzP39Y5ZZvs7Jb53LBhgz5ByZojKwQg2YAAEdKlNWA2B4Svy+EBFCaN4gvmJI2cxEXBB
	UBH0ibJN077QyaAaQxgZnjC7BhuM+yA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OtxIvXeC;
	spf=pass (imf22.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755253153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=t9yTrSZxBLBRnXcPLT3+k33IhBJPlYLGfVrtVnOwBtU=;
	b=8LKqyj44TWaE1JMzffvT/LD1NBlKtREE5o5OPfc8RD6xct13JX8J6hqbkzyCAsSlyVJW68
	MLfwuFYosTIkcQswpjIcBvflL5SKxxksih+PR2saWP/e1SoWoskxsy7XOdKmZkN28fwSsw
	WnWtUFmZNSFj0iX9bb5sflyP/16tROI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D51940C53;
	Fri, 15 Aug 2025 10:19:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4861EC4CEEB;
	Fri, 15 Aug 2025 10:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755253152;
	bh=um+JeXiZbrAs0/YN/fvbnO33vFoCowSQ1SJJFzC5/qo=;
	h=From:To:Cc:Subject:Date:From;
	b=OtxIvXeCj42F86SZKir9Tr2WK2MBFJze8EBy/vHSEXNB0UR2+JDommuakQfusGN8s
	 qih8UDAmVimta/fKQ8HsEIVdFcWobatv/uPiHscoKKEyiHw3HkhHvAdTD9kO/eXPai
	 xauVlchIodchaVuLtIg/1+intag6AQzKlmNZKIs5LWfc+KYn7SxEt+q+0Rqvw7bCtC
	 UiZoRjOvVKsbl24/progW3Qeo6Io7nOPlMnInYtpo0RugKk8ejeELcVdbvGVMsYQGr
	 uXIbZaTZnHPHdjLxsazKu3oWWW0S/vef5QreUEFgnl+/I2mghzqNK4VggNQrFQqEug
	 nFVN31brDAMVQ==
From: Will Deacon <will@kernel.org>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Keir Fraser <keirf@google.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	David Hildenbrand <david@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Frederick Mayle <fmayle@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Xu <peterx@redhat.com>
Subject: [PATCH] mm/gup: Drain batched mlock folio processing before attempting migration
Date: Fri, 15 Aug 2025 11:18:58 +0100
Message-Id: <20250815101858.24352-1-will@kernel.org>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 82B30C0004
X-Stat-Signature: c8krnqag8ympwim9igfmf1na1ug1tinb
X-Rspam-User: 
X-HE-Tag: 1755253153-853239
X-HE-Meta: U2FsdGVkX1+JvpCPRlARzD11AibZ03nDtF5FUw1glerhvxcOSV4kJtqZt52rfApfkVmUeyveQZXtEV/NMowB7BSt0Qs76z9KZFouELxLG9tftnxaQZgRUXRYtcPCTCgMzgtgDgF2DZeod/ZcsFE7Tky9QEKDU7x2Qyaw6HyZM80hzaEZnntzWdfrRDaFhtz6dcJuIzotmtAKW0kCQthe2CLjEX9U22DFEQElmCOalNw+xmqAW2S7bjBEc467tsnflSTzXtISfA9mHt6QWIKCB1/6WCgOEggpFHF+4dvLJuniVi6bHgOl7BRopgOfCFg08DNbpZa6VI4aK8n+5hMtj+dNxKqiTJMrBVsdDL4TYoNxX5FmpN1Jns75PyL4nfdlkxO4wCcxfWuC4mJCnJ4yjCFAd3m5bx4zEu5eSQ4720af+HCR1Q9qtyBFzQlkKHb/PrpqKhAe411KlxCmYr573wFfrl70z1+ZilcNter3ikeiK9BS9R2awhHB4nInCG19Fa82cXYWvxgS5S5WTm29MZpuRMHHFEr90oEgHRLE/9RihWtNlydKZjPHu8g1fN8DYdPWx6/q1vZADQ0rnhIfU6cDIYFnEmHWnVjsWWmI+mNSh3/j3+7OSo8U7Jmiu/i28h4FkzWtGg/nTlgnQCsRgqggmeGsjbx+KUdFv8oF3+2rj0k3QZ1GAi8y5cDUNv3rWQTFygGAw4e9mpWRZrkPKrttCYLcC9dzxLDKrEElWwl/aYlahcvZJGxhP/U8ExzieA0g24cu+Lxf+ahCbYTom/8yb9v86RUbXVz0s5hSo6vdy2CseOZGijyFqQt+M5ZqVqc4mgM0EwHJzyGcFRzFyc1k+clhISnS3MBoOlIJRfef+/WqJuVTpO0pi0Za0akmwjF8myRsachyXSJc40YdlQNvHvUKSMUjomeut1STWZ9UhCYosPslBjdCr13JMEqBCpjrwv+MBwcEvU1du6f
 bTe1ELI8
 PbXHzWCT3EnwWTjKW+xTlp5rM0aaq3JhAOwschtO+1abX1D+XCLqE6MduY3t26vTs/2piYF2BazK3Zl7kvJVxVPMg8YI/7bOSvERzQphhVcwGflz1IPbRFAO9Zss10El4q5SJM+AhRD3bq12sbXbVn4HMjNTOo4FB467QBVgTxwi62fRddhxpbC1599GwkKesN4k6BpSfdxD01j04nwNKHSFtFYTQqHYpBNK4DEEBLs3cPDi9TBbW/8TFY9kxsiwUeC+Gh2hhScFGCSUFtB7sYReBVDr4VHXy2lU5MSQ7CGuYVdipALs9BB8bu/7OQ5yxHDjvkUS++hR+u+S5uuThcH05hVs/AJHSxb7/dJtytpKDYnQlYYgC61B/GS0Lf2nwct1raIpEOu6M9n2WHBdzM+44p37yjR0OO4Y+++409phq4kc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When taking a longterm GUP pin via pin_user_pages(),
__gup_longterm_locked() tries to migrate target folios that should not
be longterm pinned, for example because they reside in a CMA region or
movable zone. This is done by first pinning all of the target folios
anyway, collecting all of the longterm-unpinnable target folios into a
list, dropping the pins that were just taken and finally handing the
list off to migrate_pages() for the actual migration.

It is critically important that no unexpected references are held on the
folios being migrated, otherwise the migration will fail and
pin_user_pages() will return -ENOMEM to its caller. Unfortunately, it is
relatively easy to observe migration failures when running pKVM (which
uses pin_user_pages() on crosvm's virtual address space to resolve
stage-2 page faults from the guest) on a 6.15-based Pixel 6 device and
this results in the VM terminating prematurely.

In the failure case, 'crosvm' has called mlock(MLOCK_ONFAULT) on its
mapping of guest memory prior to the pinning. Subsequently, when
pin_user_pages() walks the page-table, the relevant 'pte' is not
present and so the faulting logic allocates a new folio, mlocks it
with mlock_folio() and maps it in the page-table.

Since commit 2fbb0c10d1e8 ("mm/munlock: mlock_page() munlock_page()
batch by pagevec"), mlock/munlock operations on a folio (formerly page),
are deferred. For example, mlock_folio() takes an additional reference
on the target folio before placing it into a per-cpu 'folio_batch' for
later processing by mlock_folio_batch(), which drops the refcount once
the operation is complete. Processing of the batches is coupled with
the LRU batch logic and can be forcefully drained with
lru_add_drain_all() but as long as a folio remains unprocessed on the
batch, its refcount will be elevated.

This deferred batching therefore interacts poorly with the pKVM pinning
scenario as we can find ourselves in a situation where the migration
code fails to migrate a folio due to the elevated refcount from the
pending mlock operation.

Extend the existing LRU draining logic in
collect_longterm_unpinnable_folios() so that unpinnable mlocked folios
on the LRU also trigger a drain.

Cc: Hugh Dickins <hughd@google.com>
Cc: Keir Fraser <keirf@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: David Hildenbrand <david@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Frederick Mayle <fmayle@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Xu <peterx@redhat.com>
Fixes: 2fbb0c10d1e8 ("mm/munlock: mlock_page() munlock_page() batch by pagevec")
Signed-off-by: Will Deacon <will@kernel.org>
---

This has been quite unpleasant to debug and, as I'm not intimately
familiar with the mm internals, I've tried to include all the relevant
details in the commit message in case there's a preferred alternative
way of solving the problem or there's a flaw in my logic.

 mm/gup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/gup.c b/mm/gup.c
index adffe663594d..656835890f05 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2307,7 +2307,8 @@ static unsigned long collect_longterm_unpinnable_folios(
 			continue;
 		}
 
-		if (!folio_test_lru(folio) && drain_allow) {
+		if (drain_allow &&
+		   (!folio_test_lru(folio) || folio_test_mlocked(folio))) {
 			lru_add_drain_all();
 			drain_allow = false;
 		}
-- 
2.51.0.rc1.167.g924127e9c0-goog


