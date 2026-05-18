Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E846CD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 18:17:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0BCB6B0088; Mon, 18 May 2026 14:17:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE0BF6B0093; Mon, 18 May 2026 14:17:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD96D6B0005; Mon, 18 May 2026 14:17:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AAED26B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 14:17:48 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6E89240A65
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:17:48 +0000 (UTC)
X-FDA: 84781349016.17.8B71F2B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 70A59A0010
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:17:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bRAtmhXH;
	spf=pass (imf25.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779128266;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yrPQCkEZ8hFTwszAolYBd0sABYt9jC6Imku/EuFg5R4=;
	b=dtyft2FgGubPONe1kX04HISFElMsIwOIBxWR8O4Hdaoq2OmR5fPepnI3z7LPYIoASc+5rR
	u7/ZU4K1oZYSf/moliZBMaQ16uQBnZhwZeIrPohN3Cps2Mpwr3toaFUFWpMQd8ZfL3m7xv
	/VbemQF+Ch8wqd731s1Rky8yxtP0d3c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779128266; a=rsa-sha256;
	cv=none;
	b=7PTjwHspA/bYfwzujAEu7fgAfpP9MVlWu6+64jCPybFKWrG0GMD4jx4+mCUSsEJ4L2/F8y
	/nWv7oLzFNmVNKNsmc35vn34Lj5kShIe6xlGhUAdGVvDJN4RK66JOYZejIbceaE450edDg
	RQePScfuOgReKfLQxgHQNlMZp/kGJyY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bRAtmhXH;
	spf=pass (imf25.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D876060128;
	Mon, 18 May 2026 18:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 85BFBC2BCC9;
	Mon, 18 May 2026 18:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779128265;
	bh=aVAYRCF7fpcH4fE/r8x3fxMBl+z01QeRVwKC6iFuOtI=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=bRAtmhXHDokhqvFEewWkVhT2zPlHSo5s7VDSykNtcQvIR+B4OlkOwwzCAWA/nbvVN
	 Sl3A9950ps0TWTwqezCrVvoFq3z03vGqcN9CcPFW08i5qUz/X/ZWhSlerJk5qVl4vN
	 LO8lyxetnZYbm6kHqHALvxFUmAhMRke3x/WZRBqKgKKHrdFOM/kkp+wr+CRxw00quK
	 CzJjrhP3RLAPn94NfA08+377ggJ+Zmg0wFddimnWqSChP8PrG0Xlh8o4OcKddQ9OU6
	 zitvp2om944rTTLotZCUS6ku8xHxkj2TPopprWEATu4ksSFdu43fjO4SRbEKnE6TrE
	 LRtn+t+BfwtWQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7335ECD4F52;
	Mon, 18 May 2026 18:17:45 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Subject: [PATCH RFC 0/5] Test readback from fd on hugetlbfs mount
Date: Mon, 18 May 2026 11:17:32 -0700
Message-Id: <20260518-port-hugetlb-selftests-v1-0-d64ba3a785fe@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALxXC2oC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDUwNj3YL8ohLdjNL01JKcJN3i1Jy0ktTikmJdy6RkM+OklFRTQ0MzJaD
 mgqLUtMwKsMHRSkFuzkqxtbUAtv9QKW0AAAA=
X-Change-ID: 20260503-port-hugetlb-selftests-9bc63bde5116
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
 muchun.song@linux.dev, osalvador@suse.de
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779128265; l=1923;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=aVAYRCF7fpcH4fE/r8x3fxMBl+z01QeRVwKC6iFuOtI=;
 b=+r7KYrdkoJP5CPg+cUFpdVi0hERhxpSIqRqAicUAgbGChju5O7GgStBPIRKVnYedFhDyJSaQf
 OobXVllVPbZBKb9C324yvDI5HnNpIK9pzvr/lVbJilPV18vGKGdgtlI
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 70A59A0010
X-Stat-Signature: etzgn879eoz4hm8ugzaej3yqrw7d6kqc
X-Rspam-User: 
X-HE-Tag: 1779128266-376752
X-HE-Meta: U2FsdGVkX1/g1jJiRZQaHbksEF50qZLOkyDeRWX4vlo9/MnBBe/79uLz3io9ECkTYywll4Tm+QTeiRSrR8qK7H3lwSk0/xgBHxWJwalOKMwUrJtfydxz+ziwI/S12HTHrYw0r52TcPIdhcHCGxx/IV4hKZxsR56CfEWaz+WfYMqxeayyAJcbDNe21S+rSfxcBc6Xw/ireEabAkHGSlOxZdMerUiu69gOICagkumN/NncPt6NbEgzhw3JjogyMN4CqxU5uv2LplAPbp2QI58q5zzSYBY69fF401x7BdNRSL4bMSDCdTirRUwUO/YMlf0mrEgjU0xz2seQUZxscW1jZlSO2GHj6pg9mueN7Gp+Hjnt5SL+c78yX91hRGCIi0ISw7ZSW5G/PpH6cxsE66MJoGrL5ytdD/8TxCOh3YkVPOTqOhWiuVGpgV/7c0+sQGfnyE+Q71+TuFtfCIN95UnjUnRf0CCoZiG2YG7cUKXttoXmzLFd7SpgndcU1MTZpYL9aYT6vaPH7sF53s7TJqM+aDIiG0f3UKDnWhUTaAuOEvjVDE23dbwYFdE3QOympv7X2N/cUZEHSwFkGpx5Mx6+hJUeGjOEGiUuTsLmCQi4fum3gyhmUAFXU5ojWchavuIbTE9S9WodExTtiy/qDkSCzf7qj/1n62A5zXsoDtC6p0oONKFPS98E+9c7fT7asKteqpZoz/Vs8enkocZOdt6zYrsfLOAwXKWbM8dUeAxOdLmyfLMEYUMLVgVpu3SU+Qt8jVIrFEDsFnBgBgNdNEp+8Rjqq/ofYICjFrYLd8LR+EEeEs/vQ/UNpc66JdpUaF8mqVYrEj8rCX3ZzLHr16o6S5BxUMwSYzc1pN1H/RP3WgojW+V20m8W5+f+HqpFkuHXDHm5m3KAKvYr2C/dGxCNVcqDWO8IfomZWNWs7AI2aiVXkSiu9XsNEAPvH5e7dzdNVFqTPKPJ1gWzqqprQ9a
 EHr4ylXL
 34Hv5SyVi4JlXGSV6gRFP0mr5vpGpeRUsOXuVnCTdEy9CsoGw2d9PlAf1MM+gRpKfPR0u9ZRa+NDNSZTCNva2HEFB8JYWN0f37mbzcqaEhMGMCRtfAddoXJa8KSe4OVtzMoLTUXJ05rQ/ibhMQGtrGxF1/RW/qxLL3VL32hrySLb7i2AbBeo6vqEPgqsavwAKqi3jMZeLaZtOhgPyqihy0J/jnfsnp4eIJuu35Hao9p4Wc+zoiq+jKOZfxZ7Po5tO/QRqZ29NqCFfnjdH0elbQeTgnt1xBqFv8u88N+LfVunUdpoRIfI1R9OnFGq8tytku8ykhtHLaGVEDkiWY6+6fDaqi+XV3qmhPifUW2N3C5s72GP51IgvWOAWmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

I'm thinking of consolidating the tests for libhugetlbfs as kernel
selftests, and to start that off, I picked the simplest test:
tests/readback.c

I refactored hugepage-mmap.c to use the kselftest harness, and then used
FIXTURE_VARIANT from the harness to port in testing readback from an fd on
a hugetlbfs mount.

This output shows that the original test behavior was retained for the
memfd part:

  # ./hugepage-mmap
  TAP version 13
  1..1
  # Returned address is 0x7f312f200000
  # First hex is 0
  # First hex is 3020100
  ok 1 Read same data
  # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0

  # ./hugepage-mmap
  TAP version 13
  1..1
  # Starting 1 tests from 1 test cases.
  #  RUN           hugepage_mmap.read_write ...
  # hugepage-mmap.c:41:read_write:Returned address is 0x7f19f3a00000
  # hugepage-mmap.c:54:read_write:First hex is 0
  # hugepage-mmap.c:59:read_write:First hex is 3020100
  #            OK  hugepage_mmap.read_write
  ok 1 hugepage_mmap.read_write
  # PASSED: 1 / 1 tests passed.
  # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0

Let me know what you think before I genericize the 2M hugepage size to
other sizes!

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
Ackerley Tng (5):
      mm: selftests: Inline check_bytes() function into caller
      mm: selftests: Inline {read,write}_bytes functions
      mm: selftests: Refactor hugepage-mmap to use kselftest harness
      mm: selftests: Update hugepage-mmap to support hugetlbfs mount
      mm: selftests: Port readback test logic from libhugetlbfs

 tools/testing/selftests/mm/hugepage-mmap.c | 143 +++++++++++++++++++++--------
 1 file changed, 105 insertions(+), 38 deletions(-)
---
base-commit: 66edb901bf874d9e0787326ba12d3548b2da8700
change-id: 20260503-port-hugetlb-selftests-9bc63bde5116

Best regards,
--
Ackerley Tng <ackerleytng@google.com>



