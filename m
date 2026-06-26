Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC449CDE00B
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 00:17:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 942056B00DB; Thu, 25 Jun 2026 20:17:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 919E46B00DC; Thu, 25 Jun 2026 20:17:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8311C6B00DD; Thu, 25 Jun 2026 20:17:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5E3B06B00DB
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:17:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DE5CF120320
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:16:59 +0000 (UTC)
X-FDA: 84920148558.03.91B73FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4EC6BA0008
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:16:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G+z1VXpl;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782433018;
	b=qw0ub4YXtZcyPz/yuNKdS4m3ShekyKcwTO2qN31z+xQoZYY8l9QMxcFoAbQafbkDQyoUEW
	cdL0qJErhn0j9eklLH0Qf3YeyVNvhuJHzPrOMqBFY6oq8E1pfeEZt/b5n+hG2TftaVT+m3
	ISJBsGfU/CijztGyA3Y7rL1+yBpWeeQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782433018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=L4S838e3r5V3cM54ncDt5yU8BcFFqMQDkA1b0LUKUrM=;
	b=fN5X7qHF+u8huo9qWKeBaRnEmZuNyNfov7TKPIq9H2AGcdX3ibYqwuBv0IpkZYjygVgv0F
	A+9th8Qh1Xv+rSp83HyPNEMywmj1B00FLn87gdkeH2CE0q6LzHMN347I4qJIe6fxmopFZh
	6ALk94+ykIf43Iap3KCdxajLwJ9oFdM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G+z1VXpl;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 87ECE441BF;
	Fri, 26 Jun 2026 00:16:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA501F000E9;
	Fri, 26 Jun 2026 00:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782433017;
	bh=L4S838e3r5V3cM54ncDt5yU8BcFFqMQDkA1b0LUKUrM=;
	h=From:To:Cc:Subject:Date;
	b=G+z1VXplWChwGFpXuL/+3hO0oAuUxNVv2XhM+9q+83bRJSS+iKlhTpICaD6sLK/IZ
	 IAaXGyY2kTh7ULzNXiwuim86EXHJCeef7KntsLvCWklxefixSnoOIe76VjcLvN8ZQC
	 li/LN7yYttF+X4VC8buwzS+q+PwcOLJ2UhafH4qaAR7fcbczCHSTTEy/TfDkW1kXPU
	 W5go1KjlBocjtWAdLPpkFLslFvjaKL9mkauEBfPpDx2NXtYkCkzx5L3lZmsMURc/Ea
	 wNtzKOc5LZH6p5D8U9E9SPihwmNF/ysS6jHMzXSrycMpbcoctRulGjE2EHP3GHubK9
	 zjPU4k+mx95aw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
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
Subject: [RFC PATCH v1.3 00/11] mm/damon: update, optimize, and clean up doc, tests, and code
Date: Thu, 25 Jun 2026 17:16:31 -0700
Message-ID: <20260626001644.85825-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4EC6BA0008
X-Stat-Signature: 7gs1zxirfb1sgenek45eds4z3n3fsua3
X-HE-Tag: 1782433018-278499
X-HE-Meta: U2FsdGVkX1/VkiwphvLx4/PmKmHjcb7gYdIcIxF0InwTN2Ef3G4+pn0Ii8PWYlDlLAIJ0kgosx5k/LtRXHigg1UXv9FK7Q2IqvNJf3X3/QYxRqUOm5nQo0CG0xYkqVgQC3NdVpMRfGy4LzBd7q4yOMLDwCU5bfRtE30N8oTBuHqU48nb1fY8pndC/jzv4HSGowI2CXzo/aC2mibJc7wu5UBmVM/sPPU3CZcXRLfFXH30rWZTVFFbPJ8kKMc5Ei5V0/Ti0LfHgPqNh07BCwvU2xMgjrkGeviZaUBRV1dxwOntZfxcEohATtNQiiza4PdtTRS+ny0qlZ/6jFw9inU8qliFP6xiJv2Dxw1WYOGvmGCS+JV6WG6+aY1qUTJ3yQ8mB79OoxCrFHex65CzR1YOlosmSK+FSXqkWelk1mtviMk4nsOm2Ds/N4wm4YLy1GKfH6QRwZLIH9pJP8vr9SKkfyQSFte+NWBhSCiNZGkric3GUSmdLYySS+mds5zn6NYQYWhh10ujYqfbZ5iumSPn3btLfS1C4es8KWk9Vi+LhTjHk1H/CzUIXV5hmKAzyloY+o0MycP0pSgRfSsve3ffYFF5pL2EZsqpg81MpRkKRI2hNAVw77oUiPNzzdkrUUUiOp5CvYS11C+XdIOT6hdSMHkGy7U0RuCyM7hmXNQ6RD9mT0krnY3FAfL0f8DeRszls/QC0oQxG4WZEes3tNoF0bkcxSrBR1lUVuXVXPSjTPmL1COYhPX0Q807EPl7bC+SRS9J855reNVJee53SfBst2FcPAFtNnMP+nKj9bh3cXdn4gZAK/NL8k5KUVyI6PzfFftxfwDkYuyB9jUPNENUTb0JaFqhqFn8B5QdKKEqY248RO/tTnztlt2fZJzxUU0jY79dKf31Ko2mY9lzPwiP+M2h1FKj3yiKxsT81gCIG3WGTI+W5bmgIMQPxAhxSmVhDvfLkmxteVcM23/cu72
 9qRP9SHZ
 ElOHKS89QJuADzbAazhXkoQAo7+tb0QE+s0lzDeU05prJ4SqlAab+4Cb3jnZZrVxijcqp13D2FI0lFatx86kibQjF9AJAjN6xsnam7K+CW0ir0XRbIAhzKzOS24pm5fcI+tmeoeKKy4ydBEaMmVxKYnKlqJDvkBR65VlKIgL+m+d8RJS0ZcknLYlUmXPXPU9Zm3MkEa3WZfIIigIKAmX9WbhLhDGA5AAVMWw9k8upLSXorGc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Patches 1 and 2 update the design and ABI documents for recently added
DAMON features.  Patches 3-7 add or update more unit and self tests for
DAMON to cover recently changed or added functions and sysfs files.
Patch 8 optimizes damon_commit_target_regions() to skip unnecessary
adjacent ranges setup.  Patches 9-11 clean and fix up recently added
DAMON sysfs interface code for readability.

Changes from RFC v1.2
- RFC v1.2: https://lore.kernel.org/20260625142357.103500-1-sj@kernel.org
- Fix broken sphinx syntax in patch 1.
- Drop unused counts[] for damon_rand() test in patch 3.
Changes from RFC v1.1
- RFC v1.1: https://lore.kernel.org/20260625050756.91115-1-sj@kernel.org
- Document nid requirement for node_eligible_mem_bp.
- Fix typos: s/memmcg/memcg/, s/geets/gets/.
- Drop damon_rnd() randomness test case; test boundness only.
- Fixup dests dir selftest to do real test with correct file permission
  checks.
Changes from RFC
- RFC: https://lore.kernel.org/20260624142008.87180-1-sj@kernel.org
- Rebase directly to latest mm-new.

SeongJae Park (11):
  Docs/mm/damon/design: update for DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP
  Docs/ABI/damon: document probe files
  mm/damon/tests/core-kunit: test damon_rand()
  selftests/damon/sysfs.sh: test multiple probe dirs creation
  selftests/damon/sysfs.sh: test {core,ops}_filters/ directories
  selftests/damon/sysfs.sh: test dests dir
  selftests/damon/sysfs.sh: test all files in quota goal dir
  mm/damon/core: reduce range setup in damon_commit_target_regions()
  mm/damon/sysfs: split probe setup function out
  mm/damon/sysfs: split out filters setup function
  mm/damon/sysfs: fix typos in probe_{add,rm}_dirs: s/attr/probe/

 .../ABI/testing/sysfs-kernel-mm-damon         |  40 +++++++
 Documentation/mm/damon/design.rst             |   6 +-
 mm/damon/core.c                               |  22 +++-
 mm/damon/sysfs.c                              | 102 ++++++++++--------
 mm/damon/tests/core-kunit.h                   |  15 +++
 tools/testing/selftests/damon/sysfs.sh        |  71 +++++++++++-
 6 files changed, 203 insertions(+), 53 deletions(-)


base-commit: 7221b218afc0bff75d656bb193cb6709737cbbf6
-- 
2.47.3

