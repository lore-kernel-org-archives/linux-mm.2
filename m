Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9AA1C982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 10:15:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D92F36B008C; Wed, 23 Sep 2026 06:15:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D43E46B009B; Wed, 23 Sep 2026 06:15:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5B326B009D; Wed, 23 Sep 2026 06:15:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9795A6B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:15:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 18ECC406EE
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:15:05 +0000 (UTC)
X-FDA: 85244618970.18.1259D1E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 91F364000E
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:15:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RZkL4J40;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790158503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=n2I0phNfS1GHR21q/jaUR6mt3UcxFaFBL1i6WHN29zk=;
	b=NRDF5fi7hp1b3nAZUjS8h/bXym+RBt3NpadgUJz1QlOL0KgRQu+ZrSoTpxqM09rR1xbjm3
	dYnaLJTLMpAG79ol40iitFYXdvXtTVP/VbqSv+6b4ob/dQx2oDYqU+oVLD/PAgvtJMkEQo
	HNblym/JW4L6tkCb6bgBDh82HCKgBRY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790158503;
	b=Xsnh1ErcP2FXLrj4sCbC5nhXGcvbV5EGY/nrI4xBTl2yyskL/futR5e0ThQsvaMwFXCWBK
	u/87m0Pt1ynaECqZ0XT1yR/f3dGh1jHyNXfJH2+nKav50AKaUZrrueDeqp9ucx5EEwqpFg
	81lRzysxacumWWkS065pU3wTJqVK4wQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RZkL4J40;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 095EB601F0;
	Wed, 23 Sep 2026 10:15:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3701F000FF;
	Wed, 23 Sep 2026 10:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790158502;
	bh=n2I0phNfS1GHR21q/jaUR6mt3UcxFaFBL1i6WHN29zk=;
	h=From:To:Cc:Subject:Date;
	b=RZkL4J40sAKB8oxLocTAgCS7qxCzP1aqm7k2O0R3kutq8qj10XEv6uinZXZAdL1lC
	 zbs3ovBnGhalMg7MTU5VS3/KfyinJkVjCArcQMAqGQhzmJEQkTQxI3N2MP4FxTausV
	 z5+J6PblR8fiEL2kDrJvcvC91LYK5Vfr75iG9axznnDjTQG3Eq50vZX/tKVaEqX+yB
	 B8FzbSzRIBISuoNmTYd0eKMEslNcFeI92IY5/FmXUySaHwX3qV2ny4dRyqixXMPm/N
	 /m10R9b0DsPDJwr7CnZ5EBeqD+zmyZTUA3ZiU5F8Rt20/afIeszbr1sdZEf++qbUv8
	 +ca+3QM09puEg==
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
Subject: [RFC PATCH v3 0/7] mm/damon: introduce damos quota goal target metric complement flag
Date: Wed, 23 Sep 2026 03:14:45 -0700
Message-ID: <20260923101454.5748-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 91F364000E
X-Stat-Signature: do86na5p1yjoipa9noyb8mukymz1xokr
X-HE-Tag: 1790158503-705481
X-HE-Meta: U2FsdGVkX18fS311OLC6mX68QvGf2c0xJSC5E+Kc9+SSyjhztZAlvAD4SGBP9WWuLtKUO++kKdAkKBry8PHq9Pev768+4KggVY0ynPWteNHBDzHFhK0S+CXaJSW1FmbKuISeM4KMQwXZII4M00911PdevChKargEQ3u+J0KAlwwPuvW0tjm8kGZ8+z8iOo8Ec4vZWXbgmeWnPLBFPfpEoUX54u+VILw0iBPG1a7LlxxssmCwsV9WlrGtVBgJLlRRaZlRpz+lUlvqfgaG76QQWY+X99jMPwSqPsvXGHbGaADnRDNX+Bt9zjrgAHJtH6kp+DfvPjbcZZas4zhoIeOmm+B+f65c94dLoL9rL/GsoucPNgszzAMa2E48vdxBUXFBgwHO1GU26uU8H3Hjs/xsWcmXoVrvOis0yUhcnfKckIriCo69BIFypDHmF2wCr0mg2a3qM7PeJDvq8+XKZqJzw+4xl8hCpCOWKzoEoDmy6/m7bpho/oPArD8OyTTP7NbnMKV6imzTKHa7n/DNckGMqdEGNCd1T9szFeaJHdDJ+L+Q5Y23qzWw0fZfvb5nDjeIjA/L4IrZlkwgY6/80Lt7BwjRx6EA3OWymmyKqrQGjE0rIWoToxEqS8WCSB9wqyVgfoEBkuLIv2fAchItZ1gQrHHGJqjCR4CQUh/VzVYYfPsI0o56viU8x7WI1aEPEAyLS2VKK43sdrLG+iKop89qriT6KHBQJg9UmHCt2Bz0pk33vD/2bW5xk4RsK6Mj8yHUYTfF8Yv6r5crBWhW16+Wv4STHnq2axYuzQyPBmuQSK2XrvqYED2eYjvdX3PqIxNOYVY6wCFVLaUHfqqlNZv8BXfe9ac0+wNkETMvzLLRts1KXX519Ndg4tTLmITI6jDoDPJ6I9yTfTqwIWTtBZmJTuRALrptMQqsBBWfoJgsrRdXtC+RppLEH73RGzF8ABhQ41DoWZoU6AmS6BZlxWK
 pBv6j315
 exNwNeFiIdTMTf/T7TWD7Z1qBjYsP3RKhicdM//e2dEYb77YEm+K4R5Rhlidm5BtIAwNaWZhb+tDKElKVq6L8u+aGNq0+ZcDuaxlSMOwN/5Axvv0eK/HPh/kCDJ5tT2tNhOmCm+eMG2Dgi7cBA5Ac/wQt3GBWE5mU3vYLZctNWGJ47c3t26CMB+WY3/J3Tc2I8RLPb8xMHkuhkWHRjIRisi38a+o/U9nluDe98YjQiJBluZA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Aim-oriented DAMOS quota auto-tuning assumes the aggressiveness of the
scheme (quota) and the quota goal metric are directly proportional.
Depending on the scheme setup and usage, keeping the relationship can be
challenging.

For example, let's suppose a memory tiering approach for higher upper
tier utilization.  One common idea for that (TPP) is utilizing two
schemes, one for promotion and the other one for demotion.  The
promotion scheme migrates hot pages from lower tier to upper tier,
aiming for high utilization of the upper tier.  The demotion scheme
migrates cold pages from upper tier to lower tier, aiming for head room
free memory of the upper tier.  Both schemes and their goals are in
direct proportion.  However, for this kind of use case, we need to
implement two different goal metrics (per-node memory utilization and
free memory ratio) while essentially the free memory ratio is just a
complemented value of the utilization.

To avoid adding too many new metrics, we are adding metrics that turn
out to be really needed for each found use case.  For example,
some_mem_psi_us, node_eligible_mem_bp and hugepage_mem_bp don't have
their complemented value version.  But it is not really difficult to
expect use cases that their complemented version can be useful.  For
example, hugepage_mem_bp use case may need a way to reduce the hugepage
ratio.  That would require a complemented version of hugepage_mem_bp.
Adding a new metric for each of such use cases could make the number of
metrics unnecessarily high, and discourage flexible usages of DAMOS.

Add a new flag, quota goal complement, to allow flexible tuning goal
setup without unnecessarily increasing the number of metrics.  The flag
specifies whether to use the complemented value of the given goal metric
for the tuning.  For example, if the complement flag is set, the upper
tier memory utilization ratio metric works the same as the free memory
ratio metric for the tier.

Changes from RFC v2
- RFC v2: https://lore.kernel.org/20260919011359.88921-1-sj@kernel.org
- Avoid quota goal value underflow for some_mem_psi.
- Handle complement flag for psi goal with unset last_psi_total.
- Pass complement argument to damos_new_quota_goal() from core and
  core-kunit.
- Explicitly document no-op complement behavior for user_input.
Changes from RFC
- RFC: https://lore.kernel.org/20260918142827.85303-1-sj@kernel.org
- Avoid quota goal value underflow.
- Fix usage doc for number of files in each goal directory.
- Rebase to the latest mm-new.

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


base-commit: 976311048bbb3a9e455552281fb9927fe6e8f091
-- 
2.47.3

