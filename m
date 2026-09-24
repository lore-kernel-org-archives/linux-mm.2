Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43889C982FD
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 05:00:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 222776B0092; Thu, 24 Sep 2026 01:00:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D3E46B0093; Thu, 24 Sep 2026 01:00:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C2516B0095; Thu, 24 Sep 2026 01:00:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D1EFD6B0092
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 01:00:35 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 229E4801DE
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:00:35 +0000 (UTC)
X-FDA: 85247455230.06.0217E0B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 784E3100009
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:00:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LuFybSna;
	spf=pass (imf05.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790226033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E/RrF7kA/fgEOFKSC3c0R9J7Kn9uYszrhArRbaGcg8U=;
	b=5zS0cDM6Nid6G9d/LyCcGjYAlgao0u+l4qfoPs6aSHSGwWAxpKq7YciQvihVtHpkhB1Xqf
	wAJKzPfbQtPweaiAfsDbKFM7dkz7g9WyEvVK+16Q0jXhVHeptejy8qDn03WoDKX5NQlFie
	HzwfSfUSLWUkUeRf0bc9M81pexEZ4Go=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790226033;
	b=GkJCz74s1BaXb4LKit+9HaXE3aeiXJWYc9CPhZuqfVZXieatFo/L7rUPrTr5oW7Gz1MdsE
	qh2LXb3Sz5TkMBTnG83yr152smWXqDCNqkssd6SxpYn9hLOoxRWj07+IurD8qCREPwi8i+
	EKdtDC4Vrehbn+phFtV2Bt3wgoCqsak=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LuFybSna;
	spf=pass (imf05.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 986F01650;
	Wed, 23 Sep 2026 22:00:28 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6D7A93F86C;
	Wed, 23 Sep 2026 22:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790226032; bh=byGcsqmsm/N1R0xTXpl1j3TGY+DHgMvLIEITNN4nqJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LuFybSnaBK6aX9A1irXAYXSeNMGzh4XW6ctNbILwMrWmmAnlhIn77jfPGpRYPkd7A
	 RqxBLqNFn91VSuvKtcW7w9vDPCCRho8LPF1Cqfao4evfSKjU1lUzqVLmAxCi48iGOD
	 DaAMkeqiYABjim6BmgEzJZFnhZyAjA2oYemwlcX8=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Park Tae-sun <ts930@dgu.ac.kr>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH RESEND 2/9] selftests/mm: mremap_test: skip test when userfaultfd is unavailable
Date: Thu, 24 Sep 2026 10:30:02 +0530
Message-ID: <20260924050009.19974-3-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924050009.19974-1-sarthak.sharma@arm.com>
References: <20260924050009.19974-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 784E3100009
X-Stat-Signature: d5q9qceoo4hiewuszsqnikpgdjzrandw
X-Rspam-User: 
X-HE-Tag: 1790226033-445134
X-HE-Meta: U2FsdGVkX1/m3ddYxkEG/zO4GYFGNJm6vfxg787tnoaXfTsAZS2fb0tHp5JtDEGw1LK1N3vXqTkyVd1zcuoAPXwyjzsaWM/ZYYCsnVC5MEVGHj2uEC6oMKPpRayCmTCbraLmQu2O7ya1HTe6FYlfwtPSdLsh4BKZHlGEMCTfFJzfCk1UiUlJnYtVOGoguKyzTA6Dikfl7+wg+XfPkwqbsZkrdxu6VWfwI07NriAR8S8yawrwAgW0YvB4VCCTP6cO5kt3GdS2XfzNhSOgQN6F9HkD6nQP+p9pZEkdIsGsSGssCUZ9538qHJ7CWYdyUCn08JDri6DrPaktll4LRNZesc9L484yXHQPdMLtwIp664zFhYKzvtpkYd9rwBYkk0IffJr70VO2y0gliL5ESGj+st9eAXED1U8yucLQnRlkZNta+YU+/uX+e/8WK09mtjk6xwRcTC9gXyhY48y1+FCul4I4ErAoBevNVSiRjq/WoDW3fdzITk6B0Gr4uVBqc9NvMRW0pAb16My+g7t6O9acCbDWSRm7r8brECFH70MMO7vLwZ/Z8GsAuxSZJ+W6xeiwCRQ51NMi8qj7mlm66lVvrUrgy3EhYqRXp8itSZhhSdH1RlQoXVabGdDGdx//xrHOzuv+M/2af5LIIwsl/r5zr1FVulWbK4S8QYNwii7uWTlyhRi6z21Wog0I8Vzhd2QFbhma15SdW14Sif7BNLvjzBtjNVoEvtao17A0EXjDkp2WSqPzNYCant2TV//Yd/PTLjUwM3WKynlWKZV51y75+FZcsrSuj//ogGGAKVWkwy1gObkSR2yzzUmo9fnZgoUlXlxXuvupUiz6/s2qB8FEm92z+b6DLm5dvfZTjFDq9JUe/RcQJvRqFDqcQKqQL0lUgDwnWvWsCfG3xEhMEex1LqcRPP01UQN5QCxRK72Gm9C+9GpLHv190gP0QQliYm1Ibkxw77Q5Re3jsK6VfIJ
 w8LqXqMj
 XJoe3RZ3F/dWeT7qW/aA+CbRbHsn+KOwwkQD4jAhpsfRqd0+kEKPrDDp7NSCajDKMNNyYx14y3COUXLL5lMKZEkVDgT6Hz+Z0ZGXAt/nkXwvovCK+Xg9lWrAUVfG8apozn5RnWXQBsokHaRInEKkT1N9+lzmWJV+aoPgkU8ATblK/K+vdNwhU/0J8wiSbGeVYtx5puGDBLsw5lOOQRhCiWp3dGrHwIY1l5rdm7YDjo15Za8Qu4sR9nqGi3V2zH+T30nxZcGfevezNnPhdoc1NskPwD3b2+1eAbl93
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The userfaultfd syscall can return ENOSYS even when __NR_userfaultfd is
defined by the architecture headers, for example when the kernel is
built without CONFIG_USERFAULTFD. The test currently skips for EPERM
when the caller lacks permission to use userfaultfd but treats
ENOSYS as a failure.

Handle ENOSYS like EPERM and skip the mremap_move_multi_invalid_vmas()
test when userfaultfd syscall is not implemented.

Fixes: 742d3663a577 ("selftests/mm: add test for invalid multi VMA operations")
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 tools/testing/selftests/mm/mremap_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index 5532d3151ed0..a5813a5e8f5b 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -721,7 +721,7 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
 	if (uffd == -1) {
 		err = errno;
 		ksft_perror("userfaultfd");
-		if (err == EPERM) {
+		if (err == EPERM || err == ENOSYS) {
 			ksft_test_result_skip("%s - missing uffd\n", test_name);
 			return;
 		}
-- 
2.53.0


