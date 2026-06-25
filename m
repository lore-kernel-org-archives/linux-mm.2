Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 962E8CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 14:24:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 776ED6B0088; Thu, 25 Jun 2026 10:24:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FFD76B008A; Thu, 25 Jun 2026 10:24:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C9DB6B0092; Thu, 25 Jun 2026 10:24:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 283DF6B0088
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:24:34 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B27E94013E
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:24:33 +0000 (UTC)
X-FDA: 84918655626.06.F33FD8D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2FD111C0007
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:24:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nIUhv7+C;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782397472;
	b=3nKJfZ1ppoc64/ygpTuqux65Tx8C+I1ROIivtDPYKS66rrBSldyToMSSuUVpiGiENUfSSl
	+LEs3GOF8ljVQTs5p4ptNZ46W9PeeBhHL45ml1FjwsYq524UzfTdiuwwxXIlBJipG0qc1p
	jxXFcVTzhfD7mifyLlFDPXh11wu6uDA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782397472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=LZrmGHo3vflvh1oEeSShAdbEXA+TKacvFO2pVZr+qWo=;
	b=NbAr/X1kGV5sncND55mCJeBzcWmQMkytdzH9jNCFZCLfbeOepZbFCZtJJeaMCH6aNHynFK
	D21+ZLEWCNW/k+UY4kJTdl5N5qPOJd0IjxnfY1zqPwfTxDnxfj8UflKqN9pyXSBNFQz53r
	D1cHnuQMtH/wKUS24Y9TFfUjmJRxUNY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nIUhv7+C;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 836A6600C3;
	Thu, 25 Jun 2026 14:24:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22E131F00A3A;
	Thu, 25 Jun 2026 14:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782397471;
	bh=LZrmGHo3vflvh1oEeSShAdbEXA+TKacvFO2pVZr+qWo=;
	h=From:To:Cc:Subject:Date;
	b=nIUhv7+C8biL1usYwmhv0V2C5fEWQ1cND8G5CDAa+tzyP3ZfsNzmqyV3F/4qInD/a
	 FVGGWpQJiLeVueVbTK+oPwFmOmDNKChtSaANHgnd6FP0wqUH0/Qe0Mp8jMfDogYKUf
	 zdn1mGgjwDF1tFnxTtpJgPxTzEB3Wy7Q8mc8OQiFM9GVENLCRehlO3cNzVkxfvYk1r
	 swKx80fMe3iUaS6DUdeg3VgLLDMRKzgNwFzcpnejgE3bmMtL/0/RacN3jAawkktqmh
	 +H2KUzGmn/srKA8+9GKHQpN61CKFx+3NwGV2cATlkic5oG7V3P97TVC7fM3ZvVEN7/
	 LNCIGw0NIUHag==
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
Subject: [RFC PATCH v1.2 00/11] mm/damon: update, optimize, and clean up doc, tests, and code
Date: Thu, 25 Jun 2026 07:23:45 -0700
Message-ID: <20260625142357.103500-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2FD111C0007
X-Stat-Signature: 8c5pubkc7w97f664u7awy5st8gtt3uts
X-HE-Tag: 1782397472-844374
X-HE-Meta: U2FsdGVkX1+Xj7u3rQ2Pz8u4tUnRWCbl2IP7Q2ApoXyHNuRYf47MecEG8H83eyWhl+m6SSXBbElJoAEgK8apWAMPbDWR9VJnmCo9Eb+x+b04mfU9W+OLG8lC5KeyZawFswNM5/keByTQpXuQzHOJTIaO1O9bT6wivOcDCL7pM7KZSl4CT0HZ/FYobRLfvqeLby+if7P4je1an3pBoj7Xitvs9xLIlcrsvahKRxN2sRwBiO7Os3xlz9QMHA+liygHX4pr+WgLbuJW90GTKkuJ38V/vHiDPHYjWfy7Fq4PQU3eC6qmyOhhAISEk7mh79GUYlUaxaRFahskX39uFrLlaU1G5U8gGrHVTsHdykZUINpcdMtL14yWdlVO0l/LGE5hqkgKy4pLi/i3mh5SHBc9Sj1YqdLRS4HlZAHEdvk2vtUmxEL0Z3C7HgLYPAhsHcX3MYdIIA2OgvY6AAp+DAYOIzMQqTkqYfx/IJmPfakudkdby1ntz2GRZvu+mc4POFSdX86Jtz6Ver0n+9mK2tg1k6XMmoIX4wHpEknrvc6kgR740A+TuYqNTBBHf9hB6jhuyQ13YHfP0f1V2osWKBXDoJ8EIQDVu/v34K7M/W2mCBeCX0Y/b+9fOvprxUGKhdP91dnPudANbAI0Vvcg7sgRcAGdbzrPsrRbIb/GawRRBpPUwYSCArHdpp1L6yVvBgqZGAuY0pKEYUQjpV/dwXc+5nt37NAMd37IZgUsOK9BDnIi16YMKs12BQnkKN0lNJg2Z6gYrMyD61CpiTAOw5dbpsPACkCuqy0S0Lvwd70uN9gtrCQCo1sxzKBgvpOQfcPPCofexYZIGud9Xh3BdSw+6PWI6oFpknyL571JTPjrXSWjcwu/We2QAEV9UyU9STUNis8Ls2o0jlgIQKaIGzCGD93kqC8tPFvoTXbzf9RoVEul6LTQIzHBp6NkwySei4y7WT7SbGZ7vdD2qBnn2YP
 flST13jK
 H3WicbFXlU/kBq7dDv00YQtTLGF5oTwBVutBu8S+LEJqE5mGraDgjy1WdO1tEzWZg9N/d59e546e+HFifq0uMsmejrAut5E3WWEpdRgLeYfiK/JjnH/lBQ7ZpJtUCdIUgW5F+ttd26cYiA/PHVKj3NH3KUQLzM4mVO9GDgfruwCQ/b+e+aQpxEGrfgjncoHZ64Mv5HdackSxkcjDM05RG7P58Z6c9mUyE984Vh2wPa2xWAiw=
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

Changes from RFC v1.1
- RFC v1.1: https://lore.kernel.org/20260625050756.91115-1-sj@kernel.org
- Document nid requirement for node_eligible_mem_bp.
- Fix typos: s/memmcg/memcg/, s/geets/gets/.
- Drop damon_rnd() randomness test case; test boundness only.
- Fixup dests dir selftest to do real test with correct file permission checks.
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
 mm/damon/tests/core-kunit.h                   |  17 +++
 tools/testing/selftests/damon/sysfs.sh        |  71 +++++++++++-
 6 files changed, 205 insertions(+), 53 deletions(-)


base-commit: ada7832345164eed1bbca10543b0c46f13738215
-- 
2.47.3

