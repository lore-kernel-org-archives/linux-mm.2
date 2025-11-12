Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AD53CCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 15:42:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84DD08E000B; Wed, 12 Nov 2025 10:42:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 825938E0002; Wed, 12 Nov 2025 10:42:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73AA98E000B; Wed, 12 Nov 2025 10:42:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5CF418E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:42:03 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2EA5E160583
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:42:03 +0000 (UTC)
X-FDA: 84102370926.24.CECBA00
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id A7AA3180009
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:42:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aVg6vKow;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762962121; a=rsa-sha256;
	cv=none;
	b=fZvpwVkSnv1iu6JwDdd6GWuzMiHgKx9i9k9lDqmMllRq7OaQ+caihp99qtQz6iAzgaFZug
	SCihfEA//wUhCGRJB8wAwsf1Xjlvg/68KtpGJjtCFB6nyW+sBMhXuk9+tR8y8Cm5JFEIRf
	+JLnyg9j6WUU4YtZeSNA3pBqjj0oaLQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aVg6vKow;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762962121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4i1fZuHcSX4YPrXwiLX6kBr6QM38WuQPVodqsUnZyh8=;
	b=y/Jr6YhKlBfRyM9ZBTQpt2ZYFRww//oFc4b3wWwoGz1maMwNGvx/wx27Zy41Gs3/vFWB2B
	RfeBGAgbsItWsh0VooiNs2l4wJjEqiL2wfYv2HwNDJb9LlPgv4D1XXrkiHDNNj89cKaSs5
	c5re/hxlWfpG6kin7jR9KnJR06s95vA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CE982601A5;
	Wed, 12 Nov 2025 15:42:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88B5C4CEF7;
	Wed, 12 Nov 2025 15:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762962120;
	bh=RV6XEf4RD0FSD3rZ6zn+ujLr2U2ziSUdSWBe0aiDwBo=;
	h=From:To:Cc:Subject:Date:From;
	b=aVg6vKowroSd0N7vGnLb3piydnhBDNsCjtJovexqZWBWkXsTe/9ohWwJqVFUVtVxE
	 NVzabcponIiM5dP/bhvobHVssD8SIjVhM6txqc/vtF+QVyrQDtidaC6cThCAGxrjxE
	 kujjKtMP0CxabrtCiDdqjKhH6GwOG5xW/Z2H1JydwtQfi6hILw9HkdrSZ+zisSOkHf
	 6/69xw2Wy7QKZtnhqHr0ybrz9ev6KFD9sbE1vLxtlRwlG+CR7HrQH2X0yZtruP5ogx
	 xJrM2cVPZyMC0cpoX3CyrrKwx5K0rNs6drjnmCug3F2Qj/wXGPp7CVFczHXYheaFDG
	 WmCxhH83o5l9w==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Bill Wendling <morbo@google.com>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Justin Stitt <justinstitt@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	llvm@lists.linux.dev
Subject: [PATCH 0/9] mm/damon: misc cleanups
Date: Wed, 12 Nov 2025 07:41:03 -0800
Message-ID: <20251112154114.66053-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A7AA3180009
X-Stat-Signature: 3tzzbkdshep87k1i5p8dtyx4kcxrim6q
X-Rspam-User: 
X-HE-Tag: 1762962121-15348
X-HE-Meta: U2FsdGVkX18z09wgbgPIlqZsohNR5lRloRw20qRd/ICVqbfP8Z2WoYgZJc9iHl634axe1T4u+s3Gzit/tEoObbafzMmvES0qQg0XgP1dNzqTvYO4CyKSPFyGv/gzRCGJBjCexiG/27lGYOuLM7lcd7x5SFWczVuq4FMfjnNfmYuKQ7WyPtOCZJ0MBYL22d96VOmqe7m/6cpqs8kcOXhAVdmH7CJ9UEdG+5l4mxE3KDZ0uczi31/jTh3Uk6INF2N17DcdOlXsivgklr4gPAoNNfQ5/q1DRKOU5mvcLafTZidrKGUwQVtsPtvUyADNlRBFd+P8zLBjaGUVOD7u2EmXK2vcAugbT3Gx5pQ3fHuNBS0M3zD2Xdm7Yj943JCYTWyshoHTLHrX+YPgaEFKX5v52d/UXmvgaNJQqQ9IOuh7qkaw9SQyPPNDBxTvMoDRU3xnLh+lpKmRWDEf7+TUnBp40cVVmRf8IeqUgUzQBhR/9bd9K6lZ1UrIYm5z1iFuViwiS/y//DLznGubnizymVsRwDGmiPqloGtBondIt+OP6DYPCNVKft7l1+tYpRqKhHSrPMwfq/zAbyLpe/+ZtVhiqMVctpCngqLIZ3e/EFLCstd62Fh0EbUcAJHWd4LsTRVhoOduOYqpyb/YW54V5L9BtRIbm6iyWIfJVo+57q6kG2WExybGa3a/ryYGwrm1wh/4hDmY5cEc9/Q8QW9S4F9Nw9xl8RmEAKvbNtoet2Bo81hQAGs60Ol01h52oxp8EQy5KOvbutaD/hhgOKL3gE0hbmJfII2xP6y8YXSwO3ePflMhqj+iuFUm5lMeuHYTPaZgoFujsa1x4Jy7ClHgYD2wBZeItFUde/4NCkyzWgLcHsF/vjDn7IAeWYZLHsBvI3ZiuG6HOH3juOPTB4xgRabxvZ6NLHL/tOxF6nbYcWxWsutAZPMh+rR0EA1jGhZkR0iornsllKU3VjIkrit8lv6
 RcPGuhQy
 8S4CPRrqdXnZMKZ+2GW/cly/mew7FliKSxnwKvRBlFlEcRQ4q/S3bJgF72miyCbLDh74jtu5Ryamk6dls8Z20lU5DNlFc7ZWvu8f5x5HOK91FPSbNJRxtcbGvTHq/0Jzr2I6j8km2sIGCPRyR95RdSFfxbzegtEGkNDKtm5hVOqmVa++dMueYbfU3PGw35i4Ft7nrBILliOwj9nDOvNi7HUCr8fyOLoSlpt5crNY5Gv3ciGCubYB4LeOkf6BM+D97yZJkClms8AHom0fas9sy1fu6y6IE8jrFtWN5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Yet another batch of misc cleanups and refactoring for DAMON code,
tests, and documents.

First two patches (1and 2) rename DAMOS core filters related code for
readability.

Three following patches (3-5) refactor page table walk callback
functions in DAMON, as suggested by Hugh and David, and I promised.

Next two patches (6 and 7) refactor DAMON core layer kunit test and
sysfs interface selftest to be simple and deduplicated.

Final two patches (8 and 9) fix up sphinx and grammatical errors on
documents.

SeongJae Park (9):
  mm/damon: rename damos core filter helpers to have word core
  mm/damon: rename damos->filters to damos->core_filters
  mm/damon/vaddr: cleanup using pmd_trans_huge_lock()
  mm/damon/vaddr: use vm_normal_folio{,_pmd}() instead of
    damon_get_folio()
  mm/damon/vaddr: consistently use only pmd_entry for damos_migrate
  mm/damon/tests/core-kunit: remove DAMON_MIN_REGION redefinition
  selftests/damon/sysfs.py: merge DAMON status dumping into commitment
    assertion
  Docs/mm/damon/maintainer-profile: fix a typo on mm-untable link
  Docs/mm/damon/maintainer-profile: fix grammartical errors

 .clang-format                                 |   4 +-
 Documentation/mm/damon/maintainer-profile.rst |  10 +-
 include/linux/damon.h                         |  14 +-
 mm/damon/core.c                               |  25 ++-
 mm/damon/tests/core-kunit.h                   |  59 ++++----
 mm/damon/vaddr.c                              | 143 +++++++-----------
 .../selftests/damon/drgn_dump_damon_status.py |   8 +-
 tools/testing/selftests/damon/sysfs.py        |  45 ++----
 8 files changed, 121 insertions(+), 187 deletions(-)


base-commit: 4e9ec347bc14de636aec3014dee3b5d279ca33bf
-- 
2.47.3

