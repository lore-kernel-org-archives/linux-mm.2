Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A953C982CF
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 11:20:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 250446B008A; Thu, 17 Sep 2026 07:20:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22A0B6B008C; Thu, 17 Sep 2026 07:20:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 167426B0092; Thu, 17 Sep 2026 07:20:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EBCBD6B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 07:20:08 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C9018C02D6
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 11:20:06 +0000 (UTC)
X-FDA: 85223010012.22.0CB2F3A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0EFFC40006
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 11:20:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QxN+1YE2;
	spf=pass (imf04.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789644005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NEGqrSAKrqGoI0SIzaLX3vygCaEvANVXqJwEJNrgs8o=;
	b=yb5iT+XhUyYWV9iOn4y7pIpcsd1z7x3k0RL2wPdSxh3eVcZMaImPZJPsXgSpCIPSDCIDXe
	SYIqMYRjDoeVXCnH9qzrH+/+RLy1NHaAfN6D3ZIhkzyFYgAMqmUZ6AWLE46VnVN9AdqRU0
	99RtATDk0G47qFxXMDFaVDZ0p7fKBtQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789644005;
	b=XU9/IrpZzZmmuggm5PGzyPi8z0oPSa5YosnN8EQIzDc+V/hxdgIdc0ZqNs1WJETws/vFlx
	+A+C9Gl6xyTxois6EB0fVuNDkuQVYzBh4Vsj+USdVT0YblQRpENeyU/QTvajD0GPXabhRZ
	dOnHOZ9/eu6FAgbmUvZCZ4SqdcYNmII=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QxN+1YE2;
	spf=pass (imf04.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 622571476;
	Thu, 17 Sep 2026 04:20:00 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id AA5CA3F7B4;
	Thu, 17 Sep 2026 04:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789644004; bh=FdbJphTMJPgRywCx0hEP0U2fQHwubJbn1B/dY939TKM=;
	h=From:To:Cc:Subject:Date:From;
	b=QxN+1YE2r/U+nXFGOBumA0ZPUU8irtevO832nM0JUYVRbGUoMcNsVn4fSbLd2we3R
	 iAm9w9oFLJBb9PKi56HdZs+3WkiD006PjpaIQfafWJwTo8AHe/W+t0RHmtPgTRzdsh
	 oy69xK7Du89Ag/Uw1CKx6t+6GA0WhK91jVM6u0Ok=
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
Subject: [PATCH 0/9] selftests/mm: improve mremap_test
Date: Thu, 17 Sep 2026 16:49:42 +0530
Message-ID: <20260917111951.188266-1-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: angjr69odcbotue1q711jhhcuef3ueim
X-Rspam-User: 
X-Rspamd-Queue-Id: 0EFFC40006
X-Rspamd-Server: rspam03
X-HE-Tag: 1789644004-197755
X-HE-Meta: U2FsdGVkX18L/XAMCW3zzjuQtR/wr+6b3eGxa3eBzY1EO055opaCE9Osux4Q0oXqNjngDcTg45Gn9OT5WzBJj1FNBkt7vVRfFdenii89mxRPpAg4+EYZR6FLVzxdw/FcBfRhMJVpeiAiLTULUEW3wZjhajAi0b3wvZ7kibiTSP7Svk+YVzF82kMN4TpRMakMOG/00cARa5m03ZQCkDCfS6XDCkXRN5KqxkUoURY/1MKlxDEv1CEhC43f6kh+SGBTqeFXMq/YObYLuMtcLNvoNZHODQB5Gj+iDqyp2CVLy1exIksM0PqUHIDTjIfSm1nQYUyN+xXi85UECtIstVkdQ7iz4oJQgDp8YUGx8j9IO7L3MBNDA/w/3j3vk4gq/HmxDhOis9jvcHVuIn69yvoIR4YpYkgK1I065tkzy2Wp9/EEmLNYb9DwDjHqKq/eU+U5qYUuy1LmAyeD15RIoYFpglXk+PrJI6+wD7w88W2yw+vkjRThGFu9J01voJn+oEEmRESQJ5dKt//IYttK620SaEPxkwmmma/qfrjs4iOGkJg5Yd0zRDNfqV6+xo6S+WzgVA5xTWmlY5Ns0lUj3EeR1X+oifTCeifM3MJiopB1d/TIYXtNRGCPa2lP5PCleP2O7bBKitYuCtqreQE3CPotzpsQrwA3VWUGl+V+mn2YtjVWGtT2BR0owwLGSrp/A/kAktfS6Dro2E1IPL04i9+OVUTZSyWF+bWU7QLx5oA0bQj1loFFA7DB8pLBY07NWzMKYReW4euaT6uHz5V/KtF7s8vj5dzGavupuLXAykaUN3WtaXfeMF5VvVNnb090pHqTX2x8QMKT3CSwYopCH92z6uDxCgfxNPEKFzbqhszkkWha/L3cVk9NQWL6vw041uDaW7HF59tkuKyivsVOjkJlAJe4OvFNbZieeBIoGSAIjCyEjms/WHyL7/PRprEocR9G42MJv2hD7popn4YSCTG
 wqebFPuE
 NirQfB/rO5Njs9P4e+SKDKHgfdf8EXmM6DqgqJtZNiMJRnBPX70XG/6DSoedd12F3Xeck9FmBVENtlwtt1ZcLMCYijAyFWRY+JBbFEWBO3zkOnUVRRwaqJLIKaiQ92jZ9LaFlxOdlxe1fOo+nkBomUNhgIWZtdXD7MLmnFc4PwkB87tAgYfs08ldHhRApnLz96zwyQ5lPDPC9wvYx28NP91GFm4ABeRDATwz0K6GAnVBy+AM=
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


