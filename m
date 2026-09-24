Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90FACC982FD
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 05:00:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 641546B0088; Thu, 24 Sep 2026 01:00:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CBBC6B008A; Thu, 24 Sep 2026 01:00:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 493076B008C; Thu, 24 Sep 2026 01:00:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 206A06B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 01:00:25 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A44BE40209
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:00:24 +0000 (UTC)
X-FDA: 85247454768.01.DE8DC34
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id EB21240002
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:00:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KZ9h2msH;
	spf=pass (imf04.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790226023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pZl3139OevTxMWSdZq0v3cR681uyicte+glWHxOdASA=;
	b=sWDlGTX2oIitMusTLegzVuKnXfRG88lqErCqePKNPfxmpCTuQr4pnlidP8kX6aiNrwpr5X
	FcCneZwkufjlKbpsccdhSwFelJ8/QPJrMmQjTi0aHeHkeYegG6dg1ntIH4bAogll79uYQN
	gzoIUw793jyt03/z38cijAgFqVyAdg4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790226023;
	b=JnThDDsjshAaBcPaaBJtudhyvTnq7pD5WHDa80/zufhIPnBsZnULu4HUUFagLE0LksZHMV
	T5K3SwVvUW7rxcjJF2e91ochpWigosawB7ygS+0M8TO4PbDLJ8/jy7Ejs0UfpzBPpyndrY
	2OsqVYlsce8Bg1RYzL3GlvjZBMCNrI0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KZ9h2msH;
	spf=pass (imf04.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 155201476;
	Wed, 23 Sep 2026 22:00:18 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0788D3F86C;
	Wed, 23 Sep 2026 22:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790226021; bh=tPX67aEPDEd7r2wDN9ioKFl2JR/762YH2SOtC7CbixY=;
	h=From:To:Cc:Subject:Date:From;
	b=KZ9h2msHFsblo3XmZ56AhcpauP3bjVNkKTEaa44vuMnD6DfHbc4cKP5fXAhq+NQF9
	 bt4FIAKOteDcjVkDrsQhMxuS47AC8Cer1r6EdBfg2fOWtD2QTp1uHQwtIbrdVcH+Pz
	 tXRpPf2BI/D2QBTCHeiGrh+OW0tj0DGKjKx3+2Mc=
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
Subject: [PATCH RESEND 0/9] selftests/mm: improve mremap_test
Date: Thu, 24 Sep 2026 10:30:00 +0530
Message-ID: <20260924050009.19974-1-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EB21240002
X-Stat-Signature: wpit33gnpbt6676dwzyupskr6m7ehcbt
X-HE-Tag: 1790226022-905296
X-HE-Meta: U2FsdGVkX19oDxqWnGygF6whvni3n2Ml7S6Hz54gOTB6FJiDfEa+oOLSryQUAvX5SIcQM1PRAUFMoi3UiBRK7htzCUpj5jsl0jNO8SzHKcMJI+HJ913LxjJldl8H2bXjcwWfEEuAON2ZAoKsyU4bDH6y/lIqBEsrnZuk4Ngj/HktyOUe98uu2yH5jG2i/+RCtEE727jwaWzIN+fXs8Bc0qwoSsskGiCGVq9ArHOtTQiuJ3cEhL5ciLpbt9+9aTO+RP+gQdsCPdHHlLNuVy+6ZMM7jn7Ja7RQEtSMUk5XFHKeW0Lz/HdoLn81DJGfpP1NI35CJ09IIaLZJXZJPa0tUHrzBayHnxdHvIe2OWPh+Hv+p1ASP9x37cyi7kqhabbEMf/WnSnoJGfK2E8t/ialJxcKdZaVhvoZ9GT1acPCro/LUIFfA/t9DlTzxdL4sM0QEBYVXUr2E0gOzNIn7GTWirbT4G3n8xcXb9PiF+GSMNnPE0ZY4oOw73LqtHN+7PZzu0NM/SnYp3V63+G0ccKdefCNGaIy7Iqm3M7lKZrZbIonf2TLp0Jrqq+fmM7ESa3XfZI0OOkdS+W4T2hY25PxMThQNV0aS+Wyh+j8bkIDJZB+lkQLFmhAoC+YpkbVWy6Y64RMBl9p5rfKCTxeQ2nies29h8JZ0nnf3HhGdY+ewD6gKLtmS4UCBFbPunF/BV9ntUjWXVzYymCnKG2UYxSBDK44Sklo1aqDODN1/G3tEePXOhRLSJ5kI0eq7DfeFMqwX2BjhYsKU7YL/K25wsqAng2bCS18JUiEoJz9MfMeVj0J16VrH8U8zxH8Doxw6tjEa5ym8Aq9fDTnVpAMJM/Tim0MyXAsTnZn75fis4Ebu8Vj8wX1Lv300x66cB9VWSerrKXq5jN4QvZrUQ1eePsW8Wm8bcfHCeQHtazf194FfxTJKkt1iVWqGYsZ3inyJp8OVu74B651FJqdReH6q5/
 cvAiXQ7+
 uPZ6dmuhftfYtnfE75ZgSRO3CHEISpmiP0QoJJCUSkB/rJTiWp9yJjCciEdrUqNxc7G5jPCwIm/Ig0Hqs6NTUOfVlBuO7urg48s20tYWiQdVPvzQpuiuYE9scge8ouxvIV7eT2QquAgON8RiH7BZElczTVQRKh/xmD+gUn8Fseh967tu/5ofdYGGFaSXBmsLAxpPMPcI1O8X/3ibmcUFntSW9mCpelDdyUrQWpIJtG1Skr4E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series fixes several correctness issues in mremap_test and
simplifies and strengthens its data validation.

Patch 1 converts the mremap_test to use kselftest helpers, removes
manual tracking of failed tests and corrects some spelling errors.

Patches 2 to 5 fix userfaultfd skipping, unexpected mremap success
handling, multi-VMA data validation and failure reporting when data
corruption is detected.

Patch 6 removes the randomization and uses a simple pattern based approach.

Patch 7 removes perf tests and timing infrastructure.

Patch 8 removes validation threshold and always validates complete mappings.

Patch 9 strengthens the multi VMA validation by also checking the
mapping state of holes after remapping.

---
Sarthak Sharma (9):
  selftests/mm: mremap_test: use kselftest helpers
  selftests/mm: mremap_test: skip test when userfaultfd is unavailable
  selftests/mm: mremap_test: fail unexpected mremap successes
  selftests/mm: mremap_test: correct multiple VMA range size
  selftests/mm: mremap_test: fail on data corruption
  selftests/mm: mremap_test: replace random data with deterministic
    pattern
  selftests/mm: mremap_test: remove perf tests and timing
  selftests/mm: mremap_test: remove validation threshold
  selftests/mm: mremap_test: strengthen multi VMA validation

 tools/testing/selftests/mm/mremap_test.c | 600 +++++++++--------------
 1 file changed, 220 insertions(+), 380 deletions(-)

-- 
2.53.0


