Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA12ACA5FE3
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:22:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F1D96B00B4; Fri,  2 Oct 2026 20:21:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A2956B00B6; Fri,  2 Oct 2026 20:21:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 393296B00B4; Fri,  2 Oct 2026 20:21:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 095746B00B4
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:21:56 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A08D6160497
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:55 +0000 (UTC)
X-FDA: 85279412190.08.6EF25DB
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by imf20.hostedemail.com (Postfix) with ESMTP id ECB061C0005
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iTupMls5;
	spf=pass (imf20.hostedemail.com: domain of 3oErAagoKCJM6G4BH34GBA3BB381.zB985AHK-997Ixz7.BE3@flex--jthoughton.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3oErAagoKCJM6G4BH34GBA3BB381.zB985AHK-997Ixz7.BE3@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790986913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k/T777lhuRfNwSeNxFtz2iSXI/VIM8j8xuLCcKpt+bw=;
	b=Z0rHYkySeG0QtBxn3qTUg1K1IIogGgIfw4ZMzHYsQkk5Et3H4urXftcP6ynJNbUe2dAuFb
	+ujSw/QEF4NvVqKpEuBIcMhy2yO65GX/lUiSlYPoOezFWyCt1p2NEUm/czY1MbiXfKbcD0
	ljsAF+KPj6uG9yVip8ZM3SZbt6efLWo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iTupMls5;
	spf=pass (imf20.hostedemail.com: domain of 3oErAagoKCJM6G4BH34GBA3BB381.zB985AHK-997Ixz7.BE3@flex--jthoughton.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3oErAagoKCJM6G4BH34GBA3BB381.zB985AHK-997Ixz7.BE3@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790986913;
	b=eWmpZ00YWXjFjac6YFb76jCMb7keHAwXGqzlUrkmMZ35IupZnpCT3uqIkateF0veg3q+7Y
	qIhwok7lrOnc9GhtxbmfWko0+NauRkN6Tha8h/kkkB2hjDI3jpxJuEvkIIbeMBi9hRUhCR
	iT7bl5wSd6UVLazqac9NVZ3aa4VI1xQ=
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3823dcc1647so53798a91.3
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 17:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790986913; x=1791591713; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k/T777lhuRfNwSeNxFtz2iSXI/VIM8j8xuLCcKpt+bw=;
        b=iTupMls5cKToqhyq3vhfUVGFwolGEOI6cX+Wfm60X6C0KRCxyAkXAb0P68VrZcD+0+
         TPWY5eqG+2hq1vyGZcII67haGIYuuCiSEd5cKJMquTdoXQWzzk0pSsGP70oWHlbkaJt8
         fzFdtI/5aMOe2PPJtO48z56auUwYPlElJv6L8+jJ2Nie7fldR1KnmrPabA8z0F9PM+82
         q1XCA7AvmT1d5bZLHgv8mXamVCExzzNHNGgRiKxmGZFqAVm+KmIEUh17vUz5XjUcpIMp
         AjAnXuGgACH9vb8HCiy2zlicyvKlo/IR5Wv4Qet9hNMiB1hiSjxSLjuO5xWZbSUwlBq6
         6Jww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790986913; x=1791591713;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=k/T777lhuRfNwSeNxFtz2iSXI/VIM8j8xuLCcKpt+bw=;
        b=LfzoikwtQHVvqmTYjM4HY7UNQYEAK771p4FUql3LoyaYNK9JleXhoZtYUBS6iE72Av
         a0qD47hJyABhddXcALYEImhvEeaC6WrLvrDT6DERdggbe6tkJ84sDzzCuLHvwT80nCjn
         upcEhMsQsM5DRTU+WpbTke/nkK/RmH+eOOnvdqiY66ZEK0+UIbQBjdA/quIjiTg+puE3
         1f00INmBAVWZm2GgvyfU6WEr1WG2INiU+twYTmU5x4dXDfddIgGHdZDODlYGcnIGAvrx
         MkW+l2ENPHgPhXNnXIiEUQIXW9NKx3NCPXICXYURYGNDtViUmrcbw+eI242EaQtax+E4
         vqtg==
X-Forwarded-Encrypted: i=1; AKwUvBzNB/SANVT+x6Y4ZwJQHC7kIgW835xq+0RwPgue/E3Put9ENKFOj1b9lZAt5SeEbcMk0ZKWMQJMiw==@kvack.org
X-Gm-Message-State: AFq9FYKelfgRpFWDCftxyfhlZrLHwg1zc8psobkMx6iX84N4p/ay8/+x
	znBWnBmoSpvH9PQDt+fNyVvmGDMSitZ6vQu3kOg9Pgy/y3nGuhrZDizOFlv34vNPEi2znYM0sxi
	yLX+3krn/YOhFOuNafTNqUw==
X-Received: from pjbdw15.prod.google.com ([2002:a17:90b:94f:b0:3a6:7ee4:e327])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:dfd0:b0:3a4:bc68:310e with SMTP id 98e67ed59e1d1-3a6ce7f684amr3283851a91.39.1790986912580;
 Fri, 02 Oct 2026 17:21:52 -0700 (PDT)
Date: Sat,  3 Oct 2026 00:21:23 +0000
In-Reply-To: <20261003002123.505555-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20261003002123.505555-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003002123.505555-21-jthoughton@google.com>
Subject: [PATCH v2 20/20 DO-NOT-MERGE] selftests/mm: Add HVO pmd-split fault
 injection tests
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
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: ECB061C0005
X-Stat-Signature: tsoo7ueqqoodyufiiq91sjr4ehsupgyd
X-HE-Tag: 1790986913-967108
X-HE-Meta: U2FsdGVkX19bIdaGKHra0pwxZINwEYESB88usSjKiJO0U9q4qXX4lTnf8TlQmif8rLLaiJ7FKESQ8LyBsPr3p1gnVBLQ0pEWoz5RYrU9YLSr4b0462aH7HiU29PytVQOq6sZNRvrWk6Lr3wQSVpNSxj/9YWHjKPP9Lq5j7RxnoGbOXUxGABPZmotcjWuVXT+3/7vd7ORVznubggkK3St8rev+Q7IL4irrXMRsSO2s8JmIoKG93z1SMW7cjRrCTeFnNTfOBGDlhHM8oxLFy5Dgt9qDftUXbfJzWST6MbHrbTcY4Zq5SFN910EStyQRfyecwgGYjDJo0A/TO8bjbO/bZenJ0K9ji4RBjltPSpv4xRuGx7Vk7a1TsKp1o/IaFDEHzgDLpYV22pcZ3y+MPESsuRgf7m6LdEc+wF3ee0LLUuZCTWSjWBFw9UHcfSzo3wAaNoOaXVhZy/iXvKeOxsdv0drLnqy+MpCNyGGjm8B/o27wiPXQFGytS2rFgMYZfeLPtG4iZMZLakoifn+V0ZWr6Z6v8SqCWlvLARn4T5ffSXkLT59yKu8x2EgPOoEQoGx4IDy65ckQ0vY6YeapjKMFU9bvs5PmXWQSlDsB3qznYiwMjJe7PNtymIJnQccm2WD8QAfHJY+vb4SJOiKRaTxC8PR2liHaV/DJkA35R73IuWPeH5LrMui0IW9YhJP0yeOeBToS/dbT7giqWvZhsYQh2AWy2f2GigAnfo2h7icwBP0CBytVYFPKXJqLZ+vxwPDb8VivqTdozYb9NrOKyB/Nb2krY76rrf2jSc8kldp9RetE4zjZuuMB4CT1D9KzOmlXp7UpG7gBH1w/Vhl0vCWDUzns9lF7XbxYWp5dsfs62qmh6Qd3pBA/+Bva9o5n8vKHq9PWwoPndDT9QHHZmbSj7cEvDo1T7daaBnillP97YUuUZqIeh81BxiI6ufIS+hSFBoeq3C3XkPit55FGUe
 exe3gR/K
 1SlJoPaWWCg6ZIOpjnQYUvoXA/bWqSQjbQmZlHVAVVvT3NfertF1OtjdarraGa4xUerlNIzcxK9ngyJBYWIhKoJwgmX+GaEWc6tLfgu/mv/jFVbrjjcH0Q3WJg06b1YE1hhZ/Gqn8Ig4v450gfAXL3bUbg8rcPkxcRk+kbaj9PeZIgyqaSM0N3eq6eByrAVEVFcHSfwZFzZR8Z+Sd2cfvN9yiUcQwFYXoxiLLfpaFpGOp7AvcCD6e7gjod0P7lR8/+We3mVmFekAxDeEKNIwPDUHbBR2DWYXAlJ/CSU7LgDV9j9/F6zbYYgwgyOcXZsBw7mmWZzYNOuMgtcHknmhktW+5jFeUVY6JBoG51di6TYb365aRifj7MMFMIPhxYJXvOYkLR1fis5rYDySnvPXNGIMkdYd521wGqD5SWgSnMMo79LQt/4+bc4gbVrfKik59bKuUW+9rdE3PIj4UtkUjH65lGt9dJa5ykA/Ha31qO/6aJhR52GbciNVcaQlryzz1uQMcZJn6kbiKVkUVlLfEMOXe9iH2dH2T0QNYeosjM25+tZ9p691qnT4pkQSdv0r2HaYRBvlKvATiL185shgqMpXHF5CNvgqnwAy1tlQmR9MPOeE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Run the stress test with PMD splitting failure injection enabled (if
supported). Keep in mind that vmemmap PMDs are only ever split, never
collapsed back to PMDs, so run this step first, before the main stress
test.

Assisted-by: LLM
Signed-off-by: James Houghton <jthoughton@google.com>
---
 tools/testing/selftests/mm/hugetlb_vmemmap_stress.sh | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb_vmemmap_stress.sh b/tools/testing/selftests/mm/hugetlb_vmemmap_stress.sh
index 94357a4a45c2..2c874d15399a 100755
--- a/tools/testing/selftests/mm/hugetlb_vmemmap_stress.sh
+++ b/tools/testing/selftests/mm/hugetlb_vmemmap_stress.sh
@@ -4,13 +4,16 @@
 # Stress test for HugeTLB vmemmap optimization (HVO).
 #
 # Phases:
-#   1. accounting: allocate N hugepages, check that nr_memmap_pages +
+#   1. pmd-inject: churn the pool with fail_hugetlb_vmemmap_pmd enabled.
+#      Runs first because vmemmap PMDs are only split once, so later phases
+#      would leave few PMD splits to fail.
+#   2. accounting: allocate N hugepages, check that nr_memmap_pages +
 #      nr_memmap_boot_pages drops by exactly N * (vmemmap pages per folio - 1),
 #      then free them and check it returns to the baseline.
-#   2. stress: churn the pool (optimize/restore) while concurrently reading
+#   3. stress: churn the pool (optimize/restore) while concurrently reading
 #      struct pages (/proc/kpageflags, /proc/kpagecount), compacting memory,
 #      and optionally reading page_owner and offlining/onlining memory.
-#   3. pte-inject: like 2, with fail_hugetlb_vmemmap_pte enabled; this hits
+#   4. pte-inject: like 2, with fail_hugetlb_vmemmap_pte enabled; this hits
 #      both the optimize rollback and the restore (partial HVO) paths.
 #
 # After each phase the pool is drained back to its original size, memmap
@@ -252,7 +255,7 @@ cleanup() {
 	local blk t
 
 	stop_workers
-	for t in fail_hugetlb_vmemmap_pte; do
+	for t in fail_hugetlb_vmemmap_pte fail_hugetlb_vmemmap_pmd; do
 		[ -d "$(fa_dir $t)" ] && fa_disable $t > /dev/null
 	done
 	if [ -f "$tmpdir/hotplug" ]; then
@@ -333,6 +336,7 @@ accounting_phase() {
 
 echo "$marker" > /dev/kmsg
 
+stress_phase pmd-inject fail_hugetlb_vmemmap_pmd
 accounting_phase
 stress_phase stress ""
 stress_phase pte-inject fail_hugetlb_vmemmap_pte
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


