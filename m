Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4247FC982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 04:06:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 980956B0098; Thu, 17 Sep 2026 00:05:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E1C16B0099; Thu, 17 Sep 2026 00:05:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75C1A6B009B; Thu, 17 Sep 2026 00:05:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 527026B0098
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 00:05:50 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1A84AA4807
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:05:48 +0000 (UTC)
X-FDA: 85221915576.10.2F610D5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9497416000F
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:05:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A8eLihI6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789617946;
	b=vYI48oAvcpz3u4kEueZaxHmkAcne4haSZVkcOX8r4Qmi5YVoanEP8sf2hlEyOCr1SQQMDy
	XsaWz/Aa08iQqmUUk9Di30LNdEQEdySnKs3QCI3RflnKHb9re8ThqkAFaR1DEu227JPBSc
	vSs1EiQ7S/i/hNSpDVq3omv5yqpsuJw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A8eLihI6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789617946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9Dc5CanTIf6GDg8K6CuoIgCUBKSe5DtyaqsQ5FEzOQU=;
	b=FgTm+hmErl/mTkQbmH/CLXHcQ/qZ4ehqbwb1kjTT9v2K8aU/dP7ka/XJpoZh2Xbdm6A13U
	XJBM8TxzZD60dH3YAVvKysHO1eyBdf4X9RwLtiiKORgcpCLtQldgjCqQ8aDXQ25fFl94QM
	F9svZRVCr9DA7DJ7HCJ16K0MUKIhHss=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B320960A53;
	Thu, 17 Sep 2026 04:05:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB531F000FF;
	Thu, 17 Sep 2026 04:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789617945;
	bh=9Dc5CanTIf6GDg8K6CuoIgCUBKSe5DtyaqsQ5FEzOQU=;
	h=From:To:Cc:Subject:Date;
	b=A8eLihI6td8S+vpQQSmsaa4nza1N6dwTkWhljnrghlXxKhwUtHQcHV3f60xGquklE
	 gdkk+YnXjULAwsEC1kFlGu8zHoV1mpbXvkDR7YH3CL16DleKd+drLkSiJx6v0ARN6E
	 X3hfyMAWZVvv836IH6qVd41lNPI9wVVQ8ssx1RVm+++Et41g5QtRg/s0/OBFnM/d7J
	 omUnHQthRetlCVNRpI0JQ0MBpwAiIqp/W+gmQbEMnO+xJz/5YhNrLbSi9s+QPnOBfw
	 1uEiusobFr8fNv7vGDF8zfTrtUA8O9CeY+TRq10HB4vizboofjUBKK+VQFLiUem3qn
	 qbFSHwdVepHeg==
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
Subject: [RFC PATCH v2 00/10] mm/damon: improve readability, clarity and test coverage
Date: Wed, 16 Sep 2026 21:05:26 -0700
Message-ID: <20260917040537.107341-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9497416000F
X-Stat-Signature: kq8gtwuda5q89niwauhn567jyxyiok7s
X-HE-Tag: 1789617946-219539
X-HE-Meta: U2FsdGVkX18osGOy3EFKUiBuV7NtGrW9KCPp9CGD02N2ojeGwV8TZpnsQkSu4q/nIRMHqN9B9dGE4+7m1usU0oInkhvq4wLdeBYGZ5D1cmzjo3BC6N0WuBwUsulCrBXRG+Di44ALzMN5GQMztxAGRUSSfH3m56hM055H1Tyem3WE8wpElX2Wu6s9XHF4QDt/Va2aztqKfdGBvnfEeE4BjSJ/o4V5Pnb7Tm79PZFn6jv/DNNI4gPZONcNvB03fHASYUDVXLTK94nQvLzApCq5LmRu1OUKXEpbKQ7+gqiq9GGo9+I4yQeKIiybNZ5D30XFCvEb+NZ0D3BjjqWO/VFvw7EHVoO0QgCdYLOeCrrN8GgwsCf74G2elWf8Mpo2LjR8XnMmAeOl7w8DBAvHg4RyWv5knowwwM5zKUpj+RTPqqkDoQTI+5lvjByHl5gzHi2smVU//yrBoKjJKh/WE4ZPORUlDeUzU1C1dfkEVwcHq4C9lV1z1gjJVJQXmOcEqtFg0RfGu+m5zdBoDvPPOvZerGL5rzt9dl3xRb4IlzbYEAYzjjTwhwg8tAOVAdSscPeXJQg/8jEcgUFQsKh7lEMFf6thFZeLzQ9z8fl/h1FwLo/fRStrIjUafrnhrxEGaWEry7BZa6zFbtgOJYfG46KpGK/9C6MSEotcdQVfNFkgocd0e0obZAwq7GJZeAxCWe8dTnxQV3E1UkpxhKMmiQ6Rvt4/he0q6oCN0F9a/CT39MgrnKkg1TfnN7OYTY2Lw77az6OmxpXFf7Fsk8e+ScbFqLFZ0hAHSG7GjCnpeL8H+eHqA8v1mbR2jfCmMfXPvJaDXjIV/y9Aah/Tgyb6uOpsVgklAJbGX8GR1aAIjU1HgZSbxPPOlAmv42Lrc7b2Nzx2kmyXLeIuOdv2rRcRT5F7dGqpbZgu3gImlDYzSkMb4gmOBAK1dCs3315Dwc8lNoY+lhwTri9q4GrA/CPReiy
 jwV9h7yh
 vbKDg67kj9tZQZ62HjXJa55yJoI0/FZlJOBg1m6ebSvyWsEKqoU8mjpjybMzpLgLUgp6JkUyl+EIdqFwrZ49PkKcuhNXtapEjNhjJj3mlfVua+qDJ4cYzhWwRXOF0GP+4VSK0nB3tcUVuwSI4nj+iZWf8GFWI/GxGYOEQ2FwS5hMW+1vts5jUqCryIMwDBlRjJsUoDeYmBOh/9sOhV3EuZ1JpNLKdxE3EkQ+UGe0qbYd4+1E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Yet another batch of miscellaneous DAMON minor improvements.  Mostly
focused on readability and clarity of code and document, and unit/self
test coverage.  No user-visible behavioral change is intended.

Changes from RFC
- RFC: https://lore.kernel.org/20260912200814.145612-1-sj@kernel.org
- Fix a typo in the selftest warning message.
- Collect A-b: from Randy.
- Split out damos_adjust_quota() fix to an individual hotfix patch.
- Add a patch for initializing walk_control_obsolete in damon_new_ctx().
- Add a patch for probe_hits_wsum damos filter commit kunit test.
- Trivial patch sequence update.
- Rebase to the latest mm-new.

SJ Park (10):
  mm/damon/api: remove NR_DAMOS_FILTER_TYPES
  mm/damon/core: use abs_diff() in damon_feed_loop_next_input()
  mm/damon/core: use mult_frac() in damon_feed_loop_next_input()
  mm/damon/core: set damon_ctx->walk_control_obsolete in damon_new_ctx()
  mm/damon/core: document damon_call()/damon_start() race hang issue
  mm/damon/paddr: remove pa parameter from damon_pa_filter_pass()
  mm/damon/tests/core-kunit: test eligible_mem_bp commitment
  mm/damon/tests/core-kunit: add probe_hits_wsum damos filter commit
    test
  selftests/damon/sysfs_memcg_path_leak: fail only for real DAMON leak
  Docs/mm/damon/design: clarify bp is basis point

 Documentation/mm/damon/design.rst             |  5 ++--
 include/linux/damon.h                         |  2 --
 mm/damon/core.c                               | 19 ++++--------
 mm/damon/paddr.c                              |  5 ++--
 mm/damon/tests/core-kunit.h                   | 30 +++++++++++++++++++
 .../selftests/damon/sysfs_memcg_path_leak.sh  |  7 +++++
 6 files changed, 48 insertions(+), 20 deletions(-)


base-commit: b7c76a308c2afda7cfc2ce98be3eed466be71337
-- 
2.47.3

