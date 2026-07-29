Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34FD7C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 03:38:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DC356B008C; Tue, 28 Jul 2026 23:38:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B43D6B0092; Tue, 28 Jul 2026 23:38:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F1316B0093; Tue, 28 Jul 2026 23:38:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 09D5D6B008C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 23:38:03 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9D9CC1A04EB
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:38:02 +0000 (UTC)
X-FDA: 85040405604.18.352C247
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 216E04000D
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:38:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SO6J+KXG;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785296281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=PHXHv/8aRUsKBfW2c2nIcEHw5jx7iOabXJGxsw9CVD4=;
	b=3sALhrLq7qY2XU7HTKD+5SzTxl2TazvG+OI4UMi2BiPh7971ZdtTUDn8QXXcXkgo902wEY
	KmfGqIUMOiRKejQpGFb6+L2g5j3HM5/K/Vy1Vo83CKqY8kuRlvxFjZTh6ZELUJ6Phn0I/6
	0gwR+YLK1hG2RMYkFwJlc/077w6hrhw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785296281;
	b=aprc34m9qHD2Gqtpi0Y5ahshphHJCSAEwRyAV9uUa45bYtFT8ziA2SrJywEbJTEutgN9cI
	GLsaq/ALF1wn8QY9StpvAajg/t5conext7PGa4aEa+76xkqj32s/aN2+XqYi5YybEvw6DH
	B4z3IBR8mUc/eSsXHGq8b4OpWy0i2EI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SO6J+KXG;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0409940100;
	Wed, 29 Jul 2026 03:38:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3471B1F000E9;
	Wed, 29 Jul 2026 03:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785296279;
	bh=PHXHv/8aRUsKBfW2c2nIcEHw5jx7iOabXJGxsw9CVD4=;
	h=From:To:Cc:Subject:Date;
	b=SO6J+KXGJ+KUH/INHpG2J3XmOghTN32xj2I3aUF8jHBFcCQJan0Ay60/+mVNh53ly
	 rsSr61U/6oVD8O58hiJfnh1WaihBVkSZFmaPg11HpYc0Jy5zUsUxjbFFTiXjlMYI4C
	 Wx+H3XRV2eZv4dybzFbdRGiT2PZDQmCm/zF8CRBTzlGNc2G9yv41YcvOFT6iiRcpxz
	 EOsyF1O2GzQe9qOqYYQN9biolkpM1et/UFUpXIxtA0n8SE5/zg9L/iJ2CQqtJyGB7K
	 mmSOoPnHRmX0bBNzkwmVZwodSHQ6hixPZeYjHBoPv3RtfnrqrouCGXsHG6um/LZtcg
	 LoXhDcN2Hf3aw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 00/10] mm/damon: cleanup code, add test cases, and update guidances in docs
Date: Tue, 28 Jul 2026 20:37:40 -0700
Message-ID: <20260729033751.131213-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 216E04000D
X-Stat-Signature: uajjam53soq8zqex3iebz6ipkkrub6fz
X-Rspam-User: 
X-HE-Tag: 1785296280-256629
X-HE-Meta: U2FsdGVkX19rQ+wuUS4V8rcLtCsHW63bsYgEhNQz+6ncLMETnKnsDLkSGVuDlO56DkY/BInKAJj4zeS+Fs/O/UcIN65hkbr7fnb+O+zsYR0Z5UCNTi74aPh0okyA0WkiRd2hQrJ/0f/wiJVnOes5TtxC6dlHMkxZaxbTUImyVJttMEtk3PgbfEJ5HT0ZeHIvPI3XBEnJ5RuxDkC7AsORwZk7RMU2YsBgK8Ve2pTi7T9RY5AYqotXUYRxP6ogPE0+1MSEmLYus7xpoN9Z4P/KnnxWFKtVytGxTbttjR7bT5hVTHXINubAdHruRFYGdVkZ0R/FVwiWcDwXxTOPpzKkm03pt5FYV5eBzPUhBAM1EObmSxehv4pQSGO8+JMDVboFt6+4i9Zf0H2XdAkY8ECTk3eWaTTDbqaTh4pB6xqJL9QyLfYPmox3WY1Y24xlY5mUL6cU+fiHcqyL4lJ1GUddFDdxJoAlPRUQYIRodM+xFBmxf+be7Jp4763ansGl11t5BmNZavakihul31ZLIoT3QmhYa3+TFBR+DRskubjLgwtgsuf7yz5X9yY4b+mI6J58XWUiy7Tp8usR2105k2BDwXLKznkILw8vUT3cVKafdnf/HHBTNhzwaKs/gb3Jp+3tdkz+ZOFpGaFRx0y5UVWNjjyaa1abPyVmFvqN4qkMX+bJiWBpR0o0x0+nsT1KpVirkHwT37LrW9iGrjVFla2OohZqaDwBPHLC2PWZnjy2pZk6YK+r4RcxdGarcJva6F0QEbOYOMD0/ACzkfia4CqzAy68IKQWRfDZeXo5pwiZRjl3tQqFjOgpMHQNzowpqL9lJfKTweU633nF0UotvwQRsrsifCmEYvZRHxmkGfqxLAXPTex91cf+dK6xfdlSBKVyg4UnSh6+Cw065mtYcjH7skHWobx1zlSFeqHKbjxDc6OnkhVKFiynPgI7TvJyqW7NWOSHIj0wq+SjrfGV6NY
 t+n67Tnr
 tzNAwzKfe6fNDgYOWZTFXChZ0UBWhzPMH+XGGV1H8VXyqM+m73CKiVaGIBZOn76xFI/3fWU+tg5Qok+jZaADgcetiYRqS3oagKfbEhsbhp8PlR0QrFaz6UktR5wQyvBWcHxGkkUVMuW1qzFBtedKZbXOSsHytvzDBFAx8Ex0sZZja0XEkLRlpTukNTQq8UtDrZAvmaPfL3tEuxDaq5sElwrhPJisUSftCVaYyWAk15sVcF2s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Misc cleanup, improvements and updates of code, test, and documents.

Patches 1-3 cleanup DAMON code.  Patches 4-8 adds kunit and selftest
test cases for recently fixed bugs and a new feature.  Patches 9 and 10
update guidelines for AI review and what document to read, on DAMON
documents.

Changes from RFC
- RFC: https://lore.kernel.org/20260728052811.192712-1-sj@kernel.org
- Remove ctx parameter of __damon_va_init_regions().
- Fix damon_nr_samples_per_aggr() overflow kunit test.
- Rebase to the latest mm-new.

SJ Park (10):
  mm/damon/core: use damon_nr_samples_per_aggr() for max merge threshold
  mm/damon/core: remove debug messages
  mm/damon/vaddr: remove a debug message
  mm/damon/tests/core-kunit: extend set_regions() test for error case
  mm/damon/tests/core-kunit: test <=0 size damon_set_regions() inputs
  mm/damon/tests/core-kunit: test overlapping ranges for set_regions()
  mm/damon/tests/core-kunit: test damon_nr_samples_per_aggr()
  selftests/damon/sysfs.sh: test hugepage_mem_bp quota goal
  Docs/mm/damon/maintainer-profile: update AI review for Sashiko replies
  Docs/ABI/damon: recommend subsystem doc instead of admin-guide

 .../ABI/testing/sysfs-kernel-mm-damon         |  2 +-
 Documentation/mm/damon/maintainer-profile.rst | 19 ++----
 mm/damon/core.c                               | 12 +---
 mm/damon/tests/core-kunit.h                   | 65 ++++++++++++++++---
 mm/damon/vaddr.c                              | 16 +----
 tools/testing/selftests/damon/sysfs.sh        |  1 +
 6 files changed, 68 insertions(+), 47 deletions(-)


base-commit: bc87db7fa4d8d45745620150a9487efcb6ebbd51
-- 
2.47.3

