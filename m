Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57F0CC88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 11:20:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07C446B0096; Thu, 17 Sep 2026 07:20:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02D486B0098; Thu, 17 Sep 2026 07:20:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAE126B0099; Thu, 17 Sep 2026 07:20:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C61906B0096
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 07:20:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5F9991402DA
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 11:20:26 +0000 (UTC)
X-FDA: 85223010852.19.2DC8936
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id B06071A0002
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 11:20:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gUy9vtxW;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gUy9vtxW;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789644024;
	b=2APw8ccWS6OfXcOv/RW8Sw5vyJ/G1XhFccb1KNchbyxK6Ae3fc7L5KeaIlqlE1bOtj/33E
	ZcH0FjGuacQTsYc04hK/mJ94h94GGyn7B/ScG+PlHlvp5KkogSeIyvxFJAH/wXxJwXf4B0
	ZPSYXaj4XbMp3hfs2SvIVGYT8r3zm+s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789644024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kBrA4B4V5ZO5iERuABPWoek7KU+EcH3kb5qa8+bb5KI=;
	b=q8Fafw8GZ71LKEJiEz0kP9ZJLHeFEfCfFP54Vicaeg+5bYqN8I5Dwbw8oelsJP/HsHPKYp
	WrZ9JNzcwjrYwS2tFmVkjPqU8e0OiggJUaK2ivu5500OjakdblbdYxci8LwOBatQEzuR7W
	rg0mUwiMsA/HRvx8dx6mVLmfIrE6Wok=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2496E1476;
	Thu, 17 Sep 2026 04:20:20 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 614B13F7B4;
	Thu, 17 Sep 2026 04:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789644023; bh=EmkguL785IIXMYOOGQrzJ/6/Y6ZZO1ERK0FFTi6WP+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gUy9vtxW0YnWq62iM9fFT3hlcJG0544ifU+eQ2qQc+owbvmRKseIMpvzXECU0+CvR
	 IjyNZrBJHOkB8rjfKhx/P5jURG7VhxQRtIZgjrjb/l0cSqK/ROXNqNQXrIXwRLKbXc
	 /QKkF7+Tubiz8tUweFgFOmpvtSZqKgpxzmi4QoS8=
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
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH 4/9] selftests/mm: mremap_test: correct multiple VMA range size
Date: Thu, 17 Sep 2026 16:49:46 +0530
Message-ID: <20260917111951.188266-5-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260917111951.188266-1-sarthak.sharma@arm.com>
References: <20260917111951.188266-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B06071A0002
X-Stat-Signature: q4y9si6nxqpgxd8smdmmz881os9sofeg
X-Rspamd-Server: rspam01
X-HE-Tag: 1789644024-390414
X-HE-Meta: U2FsdGVkX1+YzKtLxRrdBHOukmMs4muF3Op/at7qgNvCPE5zpNaoYkYncpZlHUsfE8areg9GM+6QZgflD47BtE72yId0gy7845Hz6bhhEtcw1MKpYAMm1wUo9Hs57Jnb6LmvZG1MJenh97nR1Gta/hXbv2t32XMh1BD8Ny+G1tmJVW5PP7U5w68sm8wx5UrbNF9VWWPpwZUinRa7FRnzNpPyR1KKB/MId+JI0+Era7g3LWKatVEZD64kO/aLSGLIFHkT/AvoZsxFlIGM1TyNUGAY+MC2mOrKq31ExQBOJ5WavysPb7gwEePNup61xDkXDqDrVbumakjZ4hUMASliUHfcUJNlQTPAHwjo3l7+v8Eszf8Yk/grHmwxFLH0t04cpfN3nNLrsueXHG6Zu6pKdZaKQ3YeLt4c8qZ94yTp0bw1dUDHaZm38mHVftU8FI3IqG6VVGBUV6e/D/aZik5LeBv/tXM930pchnYjnV86n+7mHr9Emka+WS34O2VdEyUDWt5J/Lq4S8MMh9XX9Zg0TQu+ul/VhhD+6Pa+11TJ7X1vqIS25WZT65oaMW4E1xpwMDLi1MXl780j1Zoqm6Mcs3+fIU7gvphEEt3mYFkDrtSH29k85fRYtr+KHXV0X2SYWnOhBBlHvYIP0jJuqpviBVfbkHFLto9uq/YyKOrgAiEwDEoUbZdQ70rZvIqNqpxC4qr6CRG7QK/3SruCIiXAb8FpRlezP+jADDCEZHczlCVwdSPTCy3uuDZwUtfBt2UORydX3S8ka+hezayndIn+sMO/NSiquTt/CdApLPvwO6K+CxC1dG8IJAveWXRTch3rXp60a5GGNfu/bxhKrky42mWyOVXC+w3Utpswxc7DsjTF5k+2IrEuM4GlQpn4H51P5vfR+XSyAU5Rd2epxw4zfJgptdZIbwnKKRTWpZcvPZl7cJGYwRPtDcwARHA5pnJ7dK3s8cSBW9QgLUXSLPq
 apwhGX+u
 SEHSBPRc0TUBJWbQWgR2rZAwNIrHNcoV2oE0ZXFf7rs2HQ8pyf9V+GSoXReonRHIFeuNpvK70EFYXDHWsoAjhvDNO71Mm4e/W5bR0uM3z8eCWpWiWbn7ykXbzbQdRh09wi+sOXXvpEGuCxk8hJRr082Oiu/rBCoRunXPagC4hQcp/sznmYAPTLsQSRRDkSeAkmVgcqdTjRGuy8rG13qcXsEursNbQwmCeWoKsnPJv4lZCD6ymJKiObBWxjYxV90BFJ/JQtGSETkOnr/u29SkSKcEKQQQDMQt6D1Qx+zEY4sWsWVE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the test mremap_move_multiple_vmas(), pages 4
to 6 form a single VMA. But the helper function
is_multiple_vma_range_ok() checks pages 4 and 5 as
one range and treats page 6 separately.

Check all three pages as a single range and skip
the page 6 iteration to match the actual VMA layout.

Fixes: d53f248258e1 ("tools/testing/selftests: extend mremap_test to test multi-VMA mremap")
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 tools/testing/selftests/mm/mremap_test.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index ba9b7f7566d0..869df22d46db 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -373,7 +373,10 @@ static bool is_multiple_vma_range_ok(unsigned int pattern_seed,
 	for (i = 0; i <= 10; i += 2) {
 		int j;
 		char *buf = &ptr[i * page_size];
-		size_t size = i == 4 ? 2 * page_size : page_size;
+		size_t size = i == 4 ? 3 * page_size : page_size;
+
+		if (i == 6)
+			continue;
 
 		for (j = 0; j < size; j++) {
 			char chr = rand();
-- 
2.53.0


