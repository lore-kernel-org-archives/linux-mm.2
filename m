Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8492FC982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:35:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A322B6B00E1; Mon, 21 Sep 2026 06:35:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E1516B00E3; Mon, 21 Sep 2026 06:35:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D1096B00E4; Mon, 21 Sep 2026 06:35:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 658E96B00E1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:35:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C3FBB1A013B
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:35:23 +0000 (UTC)
X-FDA: 85237412526.10.782B1A0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id E993C1C0003
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:35:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qyO6N2YM;
	spf=pass (imf21.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789986922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xMerMaemBj+b/H8wZ9bXO12IohBw8fs77gCrxkWj86c=;
	b=NIWMZh/M6S6IRXUwV/Vafy7RtsNiCMmz4XVbKCMpBg+f4FJlZWGffqJKX62cF5ugi6Tvz8
	LlTrqus40yVtt6a/O9muNZzxBjPV+VDSZBNJ1dVkTlN7o7kXw503wQ8hce8QsZ9V76RqTt
	tRdl9E8SdC9L5H404AuY+/bzgr7YHdQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qyO6N2YM;
	spf=pass (imf21.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789986922;
	b=UH5Lho3tPFv3ICN5BLaadOwIFyk2E2Xsgvqdkx1UJwriNlQztvI5HV20KFUvZ7QMNkkoYN
	hTWPQoMoqXBijW+byLPqDlCYQbyHFnFr+e04uTgOVr8TifrH2kVBSdERL+7BQS8c0s6AEz
	UJtouWEhCGfDTsTKUyTrJu6RopFCaMs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9C342143D;
	Mon, 21 Sep 2026 03:35:17 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 222383F86C;
	Mon, 21 Sep 2026 03:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789986921; bh=s3vlN8KzPKyTD9fkA2aQfkXgGf19XzC4T6yxr/yppHc=;
	h=From:Subject:Date:To:Cc:From;
	b=qyO6N2YMmdt/Vr9iE62nlfEjCTOA/Gxi+kIxZEU9KsxbJ661aGOzSSuze4iEQ7emS
	 TjOTZOpdzITgLpB6g68bCsOzle/eb0dpftBbeHGWMv4yOJtTOt4S/fjazr4bIqyF9c
	 VJ0KzmyAmgjV6SRlled1/uSIKM5u+dQhhem3zSYM=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v2 0/2] kselftest: mm: fix intermittent failure khugepaged
 test
Date: Mon, 21 Sep 2026 11:35:00 +0100
Message-Id: <20260921-fix_khugepagd_fail-v2-0-3c2877beef61@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFQIsWoC/32NQQ6CMBREr0L+2prfKrVl5T0MIaW08KNQ0irRE
 O5u5QAu32TmzQrJRXIJqmKF6BZKFKYM4lCAHczUO0ZdZhAoJGpeMk/v5j68ejebvmu8oQfTndI
 nIZUWiJCHc3S5tUtvdeaB0jPEz/6x8F/6V7dwhqxtpcezVZdS+6uJ49GGEept275CriUhsgAAA
 A==
To: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2975; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=s3vlN8KzPKyTD9fkA2aQfkXgGf19XzC4T6yxr/yppHc=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqsQhkpRkHWGqSOL0OBsuUib1qwsbDCZewd1Uf7
 hN481PdzruJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarEIZAAKCRBt1cPRWsUx
 M+b4C/wNcLRogdBHlGyb2lfV/a4n88h2wVz78E7q2rzBERXnKg+JWPOdj38pgkGIxeYZnwCK+CG
 fooqQlutkh6S6B+KGh8tJoxVJcqtXA9mAajYyIxf8iXaavUwqXKeSJ+g/+UDYKFN9RuiM+nnJt4
 TrDmsOuNf35GZUd1OjaVhzw+5Xcong5iY9b85g22JlJLCYqJ0q5JaKsoXbGTKZ6gT0VSojAUDHE
 54FnIGUdL1kAJKAFe3YNZGuK0Yq2Emvv8p6Q4nEYF7r8XuXuc6wldUqZynsIga8ecFZuvPSyyum
 +6EcyRYZRPAF+v8z/lP4T/A1xy6/zIbLFa8aPPedK0aE3GqZkqrFleSsc6I+uo/Xh1xwOh8Br3X
 po5a3mpfv56sGPqfbnr+2iOqI04rzzqJSNwg5K0hLzCcD3JWO3LO3GXdVZ4fT+Odd9g0L7RoGNR
 3Vtne3zOrJP8jQrlSLHYqkxUnLKOXZzWiWwNHR87KD8QdVMKf+ffh0VL6NQxpiWQqwWq0=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E993C1C0003
X-Stat-Signature: unaw9bzn1zy169b5sqm8bmdrjtyiptpi
X-Rspam-User: 
X-HE-Tag: 1789986921-371203
X-HE-Meta: U2FsdGVkX19a38nC8UWOfYgVhnVotx5KDbmRZzp7rDgZABmBebvSkItWzpomvALC0PGac4wjMGA3ECN2Q42rm2YKg6d4WQ+gP7GtNG/qtfcLGKzDCEOIC6xdgfLkroJVjGBEjZz5X3WJ7+6x4nd1jBRf7MZbRbQYZdNUyeS/PutdT6aUWvL9EkrUofTtW0xAeLEea9RbOjnpGtoEVJAyZIgEph2iwomBa0pvT3ks0iPRa16DgU9D+BemmH+QBpSyb7TXe293tuoiUgDhJodP492kFlMkLJKXl8WttPvCJRDvL/Azxt23JBxfw6gxNXtYqRgjtKd25Y1WX72VFhyr/CVsNq5X41WPeshyPiKPQvbKRILdH/nh/O6Dl+FOawk3/dciGyGvkMk3f7LXfe9qT35ca6yH2qYvU5bqhX1KevFfyqnT2Mj6cnUU+icHboSbdoeuvqZ0MfP8LNtQ+lEFR6uQv3m2De4G8+iMfkFFm063VYMi9SaF9xhOA7h0tRaVOR86+gNPKJr6ne79KqkjuWchjk1r9lJvQoxWMbDXQza8B8U4kpb5TAygzoaNrEP5lsj0OdyuKthU8f4ewNsdYehTLH4gPdOKwbrf9bLMa0hR2NmTp7UPff6zyGcrSpFgV4pBqKPDlw2zCqBiTZKvaBwVb9J1CLlR01wW/mTYb7Ol1pPaWDs7sYYnNqcasPntcdtCwKUDnGnmlNWLI593AZ5xUoZBpLgqMb0QkNfhfTy7+vFwtnOFDvIT04WUofGc2HeYlEVyneGb0zVylsDyI/uX1jyX/A1/7czz1BdM9eijXhxyZ6ct+GECdJiWWCICDelTD5vm2CGNNDaB8jnDnKaei1eQ4TeuXgEFYxUZw1Lej/RWZBzvL8XoJ14CUL/Za3aOUdFjadTQ63vRbvd5X8Oy/7+MjUWAnwMlAmnmEN3kLIzOmmKqEQLrnY5xiZouInqyAK9c73dmQPTYPmd
 sXHhif/U
 i1lcutrr8vi0rAyTy90WTkZfgd+GiLvvazZUgBS2XzonGSfTVmg/rFwPThn1qLtADroI7o3/L1wEksAVvrqFF/tyvj3m3pZxe2wgqwqPIHDhJn1tY022UAYwj7FEuuPNFxyFSSI7gKFY3OjGKMJBBwJj/GK47wV11x8IbCWl5pawALwXPUMYZnyiPv2P73l/e3PPv3Lf/hw+7l+rEURt/+S7r9BNSsp8h/qyln0tqmk4/3y8AP8Wrvl/vIOlAtT8Q0SCR9+Fbm3HfG26u5G1tXuRGmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are intermittent failures in collapse_max_ptes_swap() and
collapse_max_ptes_shared() when using the khugepaged_context:

  # Run test: collapse_max_ptes_shared (khugepaged:anon)
  # Allocate huge page... OK
  # Share huge page over fork()... OK
  # Trigger CoW on page 1023 of 2048... OK
  # Maybe collapse with max_ptes_shared exceeded.... OK
  # Trigger CoW on page 1024 of 2048... Fail
  Bail out! Unexpected huge page
  # Planned tests != run tests (26 != 23)
  # Totals: pass:23 fail:0 xfail:0 xpass:0 skip:0 error:0

  # Run test: collapse_max_ptes_swap (khugepaged:anon)
  # Swapout 257 of 2048 pages... OK
  # Maybe collapse with max_ptes_swap exceeded.... OK
  # Swapout 256 of 2048 pages... OK
  Bail out! Unexpected huge page
  # Planned tests != run tests (26 != 17)
  # Totals: pass:17 fail:0 xfail:0 xpass:0 skip:0 error:0

This happens because khugepaged may collapse the pages before wait_for_scan()
is called, causing a sanity check that expects uncollapsed pages to fail.

For example, in collapse_max_ptes_swap(), after faulting the pages back in
and paging out up to max_ptes_swap pages, khugepaged may collapse them again
before c->collapse() is called.

To prevent this, mark the VMA with MADV_NOHUGEPAGE after it has been
collapsed by wait_for_scan() for anon. This prevents khugepaged from
collapsing it again before c->collapse() is called.

Also, fix false-positive results when a child process fails in tests
such as collapse_fork*() or collapse_max_ptes_shared():

  # -------------------------
  # running ./khugepaged -s 2
  # -------------------------
  #
  # Run test: collapse_max_ptes_shared (khugepaged:anon)
  # Allocate huge page... OK
  # Share huge page over fork()... OK
  # Trigger CoW on page 1023 of 2048... OK
  # Maybe collapse with max_ptes_shared exceeded.... OK
  # Trigger CoW on page 1024 of 2048... Fail
  Bail out! Unexpected huge page
  # Planned tests != run tests (26 != 23)
  # Totals: pass:23 fail:0 xfail:0 xpass:0 skip:0 error:0  // child failed.
  # Check if parent still has huge page... OK              // parent hpage success
  ok 24 collapse_max_ptes_shared                           // considered as success
  ...
  # Totals: pass:26 fail:0 xfail:0 xpass:0 skip:0 error:0

This failure was observed on NVIDIA Spark with 16KB page and this patch
is based on mm/mm-unstable

---
Changes in v2:
- remove temporary enabled setup.
- Link to v1: https://lore.kernel.org/r/20260915-fix_khugepagd_fail-v1-0-bb6f04c8759f@arm.com

---
Yeoreum Yun (2):
      kselftest: mm: return fail when child test result is fail in khugepaged
      kselftest: mm: fix intermittent failure khugepaged test

 tools/testing/selftests/mm/khugepaged.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)
---
base-commit: 8d61431ed2607386b427752505379536eb634ce8
change-id: 20260915-fix_khugepagd_fail-9d8932689200

Best regards,
-- 
Sincerely,
Yeoreum Yun


