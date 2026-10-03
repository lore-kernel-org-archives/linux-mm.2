Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D19DCA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:21:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6017B6B009D; Fri,  2 Oct 2026 20:21:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A1956B009E; Fri,  2 Oct 2026 20:21:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 343406B009F; Fri,  2 Oct 2026 20:21:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0A0206B009D
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:21:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 73461A07E0
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:38 +0000 (UTC)
X-FDA: 85279411476.18.5D18C3E
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by imf04.hostedemail.com (Postfix) with ESMTP id C3D5640009
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wlfhzG7J;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3j0rAagoKCIIpznu0mnzutmuumrk.iusrot03-ssq1giq.uxm@flex--jthoughton.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3j0rAagoKCIIpznu0mnzutmuumrk.iusrot03-ssq1giq.uxm@flex--jthoughton.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790986896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ZAZ5JKeK6vnKji79QsGpXUoqDaDTR7rYrRqlCcRuaw=;
	b=2mwEC0VQ5FqG6UCxE7onjadiQLfujQN3Via0uKgvl9S5kqBx48FWrPaXhO/yxVy5fI+qI7
	Mso/M+L6eGkQwNPJC14Wj1A41rzq1O6ZcKacIQd7+zEIJn+sATvf5yEQH9ev1f2FZO0W4h
	vdhL4GX05VF7MevhwwX79HVhp7kMmLo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wlfhzG7J;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3j0rAagoKCIIpznu0mnzutmuumrk.iusrot03-ssq1giq.uxm@flex--jthoughton.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3j0rAagoKCIIpznu0mnzutmuumrk.iusrot03-ssq1giq.uxm@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790986896;
	b=HDOGgtCllMe/YUICVs/BjENwNY6HkxL/ldMFOpyKF4jL70CR0fda4vySxYDRY4rwKoOBs1
	N021CN9MMjuUXikYnEiLCi/WjT8+wtDpbF3n0iz+Br9o124SAQAupnxXzZDBPqUjJAW5vO
	4Wu/nB750O88VPgFRe+paD4NrV1CD7w=
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-385d2703b64so267508a91.1
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 17:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790986896; x=1791591696; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2ZAZ5JKeK6vnKji79QsGpXUoqDaDTR7rYrRqlCcRuaw=;
        b=wlfhzG7Jq1YPmob+02qyGZGscfEy0XnADmdrKxFqIQeST4q1A5IYPP2rUj7XEtaYfc
         ZG074K9nwbkLRLrkYFVzPbq0esZu/dF9TwWM8RiuDE9kkRYW/Pv8jHjy5dWalqE4Y08+
         ZW/hJciCYAZjiPxggutpAZoFPFMmIs60kIM1LI5UIMovoX1ZfyfSo0W9Snt6DQSbZgoo
         UkIv6kLXuuKa3b1f9Cc8eJ+qqGUhz22QIiYywHMJk2BQYy981ukduWfsjypBxJCNaXXv
         RnwJdwGs96texXhieNLFQMBI2IhfFOi5RHr6ontBMhDUDg/Fb/czmQNYlA2zPbu1450M
         pPXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790986896; x=1791591696;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2ZAZ5JKeK6vnKji79QsGpXUoqDaDTR7rYrRqlCcRuaw=;
        b=X01njLqUHpM2qWz1yfKq1lpKTXOurnbecc6rVfq6MemcwV5VtFpARGdnetsSuUKLvp
         bBDbuGuqgy+vFAvk7EQKwgaw28dB3/YYjh/U9Vo9QspRl7VPYeBol0bYvTU4XhItqhOe
         T5QlbgEwXU4d3+MOs2qcbos5//XdCG4Qdl/m0JT+X805JbVa27ApazmtxTiqmNalX9S9
         IxWS4N6keocv66uVflOECxX2EtFUyGpqD6NxI8ekgZzzflTbpVwrkQAYoY4xkXeevsn3
         bwmEjBJ2kyQy0DAcPb6+8iA/y7xw4Hl6F6md4n7+htOql9B8YZ6O467kkeqHJY+9atJL
         EsKg==
X-Forwarded-Encrypted: i=1; AKwUvBxOKs7Haae68C/NjyQbJcHWx058NBppd+2LKuhMFmluGmT6fbGiD96a2UhuERKz2UDrwSI9959yZQ==@kvack.org
X-Gm-Message-State: AFq9FYK907dwAdg7WuW/V1z5yfnRVbSNRNfGNFN/H8znlEtTMF8E5uXD
	gnDOkFEuT+1oz+jbJY0DiRSpNM6WU+C7LkUYwaf8QnnCPxo9rFY6+ZHweMPSWD1YvQB7dmtRz5w
	fQOJzj/uXLaq5DAwFvAwUOQ==
X-Received: from pjbpv1.prod.google.com ([2002:a17:90b:3c81:b0:3a6:f669:2f33])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:268f:b0:3a4:e735:b3a3 with SMTP id 98e67ed59e1d1-3a6cec8cd26mr2396583a91.40.1790986895284;
 Fri, 02 Oct 2026 17:21:35 -0700 (PDT)
Date: Sat,  3 Oct 2026 00:21:04 +0000
In-Reply-To: <20261003002123.505555-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20261003002123.505555-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003002123.505555-2-jthoughton@google.com>
Subject: [PATCH v2 01/20] hugetlb: Don't restore vmemmap of non-HVOed folios
 on bulk restore error
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: C3D5640009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: cb686okjshsjwh978qw9jbio5iop1ykh
X-HE-Tag: 1790986896-74065
X-HE-Meta: U2FsdGVkX19wjyFameFVHp1vxdcTJRT5E/zqdimtuSg4x+mhdyirukmkhoOw8KNZ2ssJESlCl5JvnNMBSEfx479znuak84stFLa6ulvFSMjo7Z5+ioXDsyQJFPGeeaJqtbpHDCR+MZokBpFrgsYIP4X3hj456px2ZwRn0EWo/yB2Oy8BlCheQ4bcuSX0KirgixOQ237cS+iWBEm6JV55MPaFrFMMSUQMGImwTRY8tfigIoj4SUOSYA6jh9ygb5euAb6tNqUGt0AzAWrpfiX8AFMHDDKfztz5I0SKPBqSEPOwetEI7eOcgvuTO5dxc+Q0T9OMoHGtOV5GarmJWGc0N8aBrxoR8GJUmIsdKIzklO/idFjP6KHt0bAZmHpPzwTnDs8gns2dZAhSxLh2xH13BnJmZPJzhyFnQYgdyjXdimNbR+FfR+uM6/3A16O4yEWRPhT2BwJty3QjRsvyhWq2mrgR1sSMpUWMag4paZsb+RKtpA76ERChYzaDsRVYYLAkVsKLqZyZR2M2qEDfxLpKkczT8xWJP2v63jb0KZ1B4dHdd3tKcNKd4f0X3+d1akpoVKIz4A8rCoUBFTb4VFhSvkvGng2NZ//OG5KPALFvjOPlobsqmL/oRLM4zVfRbcQ8Gaai4WAG+BohGOdkuyLUprLRdCMtEFGZ2xzGY9F/Ut31ECROqOV4OfiZ6DicKZq4JWA5Or4A67/M7AoNtns0yL9b+J3OCpXATRLEwjRjGHd3KlOZBGPLzhLfD6jDt4cVlk2EFH0DDCGHmboIQWBVRdiW5qpLmzWsI7QLHk8FLCO4OVYEXLhJkPLXr00ldAy6x5CrmtiyTE9f8EaeUNvk+lj9j8LVmAh7KEgfkuITWN7oL2IZUkaIVajdbfa217TAWwbN6XOGi6+WRzYZtKt/2N7hoDTuReKR7yvfgClwdn52WESk9iKVkJvIem4K5dN0hZO7ePp/JbzvtnpInpD
 HqXUrUAZ
 tBQe+MpIesYy1RKWH2lcEcChZsajnfZaY5sQJA1SudwK2NV+CIrXrxp+ijPaYfsqvOz2w/FIU1qyPfuGBkrWhvoMDaYj6OsezLNmq+nJvJAhjruQXPWA1/tVR1d6pLElQfnQh162wOydI4SGdOxqGSATDAGugOHPKilC7YBeA0uaDfsrCPY17zdsl6cngrpVQnDuS6HOcvfS5epaw+wxU+5+vBkSAVKL5FeadiOw+Bo/qx+d+ZaNEdlWhZn+59W7kkFzV+4Hr68H2nHf3iHejlyPYcg1GRBZO+R1RXBy7sb4CukQYWfvImGlnsgNOn/kBq9DGwIohbjtZVFPoxL8pcprqMb3frDqNzS+m1ivqcKRUear20CVMHNzonRHV5QS6U4To88KXmqgx7GCME57OfreMHdrMNyj5J5AH0WD4znHjdgH/pj71+6kRxMCyMDPTguzlHgPCqDHDzqfHLIemozYyqzKFiBN98qHDHqPtaVElZ/wRyHTLnq+ByJTwTX58dw6eOJcuAsU6ZKIOa94yA+6SRg6CH+pJwjgh7GnsefzEzZouMCtRklpdsK53qDi6wYJX187m1gTW0yb/xurz6ka9W6OFkrpP/6toxv3Sfcvq54I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When hugetlb_vmemmap_restore_folios() fails, it stops processing the
list, so folio_list may still contain folios that were never vmemmap
optimized, e.g. because HVO failed when they were allocated. Their
hugetlb flag has already been cleared by remove_hugetlb_folio().

If no folios could be restored, bulk_vmemmap_restore_error() then calls
hugetlb_vmemmap_restore_folio() on every folio left on folio_list,
including those, which trips the !folio_test_hugetlb() check in
__hugetlb_vmemmap_restore_folio():

  page dumped because: VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio))
  WARNING: mm/hugetlb_vmemmap.c:503 at __hugetlb_vmemmap_restore_folio+0x270/0x300
  ...
   __hugetlb_vmemmap_restore_folio+0x270/0x300 (P)
   hugetlb_vmemmap_restore_folio+0x1c/0x30
   update_and_free_pages_bulk+0x2c0/0x368
   __nr_hugepages_store_common+0x2e8/0x3f0

Otherwise this is benign: the restore is a no-op returning success for
non-optimized folios, which are then freed as intended.

Skip the restore for folios that are not vmemmap optimized; they can be
freed right away.

This is very unlikely to happen without fault injection, as it requires
both HVO and a subsequent vmemmap restore to fail.

Fixes: cfb8c75099db ("hugetlb: perform vmemmap restoration on a list of pages")
Assisted-by: LLM
Signed-off-by: James Houghton <jthoughton@google.com>
---
 mm/hugetlb.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a1b51251103b..4dac7ed1df57 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1613,9 +1613,14 @@ static void bulk_vmemmap_restore_error(struct hstate *h,
 		 * page is made a surplus page and removed from the list.
 		 * If are able to restore vmemmap and free one hugetlb page, we
 		 * quit processing the list to retry the bulk operation.
+		 *
+		 * Folios whose vmemmap was never optimized (e.g. because HVO
+		 * failed when they were allocated) can be freed right away;
+		 * remove_hugetlb_folio() has already cleared their hugetlb flag.
 		 */
 		list_for_each_entry_safe(folio, t_folio, folio_list, lru)
-			if (hugetlb_vmemmap_restore_folio(h, folio)) {
+			if (folio_test_hugetlb_vmemmap_optimized(folio) &&
+			    hugetlb_vmemmap_restore_folio(h, folio)) {
 				list_del(&folio->lru);
 				spin_lock_irq(&hugetlb_lock);
 				add_hugetlb_folio(h, folio, true);
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


