Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BF4CC9832F
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 12:05:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0A266B0088; Sun, 27 Sep 2026 08:05:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E935D6B008A; Sun, 27 Sep 2026 08:05:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5B336B008C; Sun, 27 Sep 2026 08:05:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B2B396B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 08:05:47 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3C6CA160996
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 12:05:47 +0000 (UTC)
X-FDA: 85259413134.22.5046477
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id A728F140005
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 12:05:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e2qtEcqk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790510745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DtftUOhUj36KHzHH8SjyqQEupBI7pETe4V3hNrol9A4=;
	b=lHeNjMCaZ8L2F15rcZJjp9B7PSJADcJFkaWeH5yn1BiS3PGHwtLNMcTkucqBn3oLjNgZg9
	ZcKEntcjCjQ+pnBhq66a1ybVFAHDhAJPL7QBTeDqmZyzquqXuIs3szDzkI4xRDi1HPvG09
	XnotJFthlQEZmHkATQp5SHRZPFn8Q1M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e2qtEcqk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790510745;
	b=c9CQaDNI2ffdgJg8W3zAsUjF/87R2rh4ClHOVljY1Lsgf8cXgvkNoQeFiaQnghSMbNu9x1
	dYbwOq/5XJHGRjevRNeL5ms0FEboDOFWyzrs0aNiGdc9JFW/jboKtX7ym2UPzinf8U7953
	+12BlbbmB1LR2T8fRkWTZw7j/HtwgjM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C1E943C8B;
	Sun, 27 Sep 2026 12:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D2FE1F000FF;
	Sun, 27 Sep 2026 12:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790510744;
	bh=DtftUOhUj36KHzHH8SjyqQEupBI7pETe4V3hNrol9A4=;
	h=From:To:Cc:Subject:Date;
	b=e2qtEcqkmjVz8dCb2K5NGSGGje+z1wYZys269NNmJz+GX8OOSLHIb/gBF786OB+ou
	 uB4Ay9iv28YlY/f/vngo3LVs4D6ZDDX7Jc5E7FaKlwMmBKMd1WyyhMIZ4GnpGvGcx1
	 3Gxsp8fwjQYTs1GLfjs79kDdjcLSGrumVshL7ru3CS3i8KWOl1+DjpuoQr7R/WBNy+
	 VLnh7HuMWmeh5D8otkf/iXa3esRr7CXIfK4Epa2Tx2YrkjSeyi4qI9nlKX+hRigzw8
	 P7hnRcogkia6O0rfZB6TmRfr60HLdk+6iRckpaDyzyQgZ2XxsBE6psKs5dvvfpaISd
	 bnTLXf+R94ORA==
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
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v4 0/7] snapshot_set_swap_area() unpins the previously selected swap device and
Date: Sun, 27 Sep 2026 05:05:24 -0700
Message-ID: <20260927120533.50484-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: brinsfmhjgbq8ztd5gpf1h6q4iwi7g9c
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A728F140005
X-HE-Tag: 1790510745-733371
X-HE-Meta: U2FsdGVkX1+4OeoxguUZ9emvoApTTDOlZQduYQkMFD+rpgOvs2g4FD1/EbMqX3BfZzOiK1GDV0wm+LUUTzXNSdYF7pFPBOeBbUkiUUoce1lr094JU13Y5ohGLkJFLPeMnElPf4JxvilZR1mMtGY5vId4c6zom5H1GNOQhVCKXWdEydeU1TSiHDduIKdZdBLqr5oPKBmNukNuVZ4v9yH360ic8NQfAH8NKBuQwb9bAlt9WiBsPYKccKBKKAp5KGQJtgsfEuAJppgTtasnEfEHLV4J+U0bYcRx5s/FrwyrXJ3VP6GEAcezTEdEm6BE8y7RsUUbEfXSfyhT5ij8gsfclt3OojUP8ujW7oo6ufUdasQYnpqbi9wPlNH2FijrWZP6H9+Q/sV8tuEzYj0TKeyYS2QzhTIrCUi8f+7owGq/97BoqbpfQOQeIxD2VKGjDPuMfzJk0y1dT34u2Hq0sf0lVVKkh370RDaLTnjaHS8+m0d0eDJFqDo6OWUUxfOHeZ9nd5TwKLjffSOpoy/oNGz8Pgn4qSWvk235bD6iBq/f0MTrDmIJCcxxEs2j6A+8MGoW4pUbgZLV6Sden4YKAH0WvD5j5vHf3KGgwCwiaL7D4mLNJ0u/R2Zpr52nu7vRSvxXwQ+hEz9YL2VnCjaudzSMwGNZ+IceT8emXH/hfT0eHdxepddIyOquGG2uf4QH36wRVqpsi1PSdKfY15qZgHzl2cN9L8DtIyT/weyjN8vKIGHEpbrxLX8r4E9L3HrkEkoG7+517vIr37JqnhcUbPUuTyHycnJ3qHYIwblGgMdD2tyXT3BW3Vh3tslCz1EPyZyd2S1yishNN0WtNHwz/K0SDoYNVzsZrC3ZkozxNwzCCqb0wESn80593ePh3tsJYdvnky6PZOREXAD/44ZRFgqJSirOYGDqT3yQuaLAQOXEAkHWrgnpVcTJshOZzoPjJJAEHA8tAHl6M7ncbGbmRB2
 QR4i7HF4
 DnGMjKuGBx46smjaJWFKo7ExQRNNDPBkzhbUCo/35BIHglnGuOrITkhOc0k5VdMubJ36qBnLMQuzhB/m3O18m4rEGgjsjUqGqkGN12QCxVEZXyQa2MeDaIHVUT17CoA/RzWQy8/Pabn9PhRhK6nuLtwNl6RdIYG/K+U5yGUq+3LK90UyCRjvu9XqhpKUbdS9/YHUepEXmpal8cVgQ9JxY1a3OY2xtFtM8rxAFVJY48XgJdkqJe0wGKCM7e8A0bps+I9aI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add repin_hibernation_swap_type(), which looks up the new device, clears
the old SWP_HIBERNATION flag and sets the new one under a single swap_lock
acquisition.  The same-device case is short- circuited so userspace can
re-select the same swap area without tripping WARN_ON_ONCE and -EBUSY. 
Switch snapshot_set_swap_area() to the new helper.

A failed lookup now preserves the previous pin instead of dropping it, so
a bad SNAPSHOT_SET_SWAP_AREA leaves the prior selection intact.  The open
and release paths keep using pin_hibernation_swap_type() and
unpin_hibernation_swap_type().

The race was identified during AI-assisted review of the SWP_HIBERNATION
pinning series.

SJ Park (7):
  mm/damon/core: introduce damos_quota_goal->complement
  mm/damon/core: add complement argument to damos_new_quota_goal()
  mm/damon/sysfs-schemes: support quota goal complement flag
  mm/damon/tests/core-kunit: test quota_goal->complement commit
  Docs/mm/damon/design: document damos quota goal complement flag
  Docs/admin-guide/mm/damon/usage: update for quota goal complement file
  Docs/ABI/damon: update for quota goal metric complement sysfs file

 .../ABI/testing/sysfs-kernel-mm-damon         |  6 ++++
 Documentation/admin-guide/mm/damon/usage.rst  | 15 +++++----
 Documentation/mm/damon/design.rst             | 15 ++++++---
 include/linux/damon.h                         |  4 ++-
 mm/damon/core.c                               | 33 ++++++++++++++++---
 mm/damon/lru_sort.c                           |  5 +--
 mm/damon/reclaim.c                            |  5 +--
 mm/damon/sysfs-schemes.c                      | 30 +++++++++++++++++
 mm/damon/tests/core-kunit.h                   |  3 ++
 samples/damon/mtier.c                         |  2 +-
 10 files changed, 97 insertions(+), 21 deletions(-)


base-commit: 1c2b8d2725f84b43fabe3b3e9628c91db8ca6c65
-- 
2.47.3

