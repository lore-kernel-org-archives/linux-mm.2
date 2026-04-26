Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87E60FF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 23:16:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B09BE6B0088; Sun, 26 Apr 2026 19:16:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A99C16B008C; Sun, 26 Apr 2026 19:16:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A92B6B008A; Sun, 26 Apr 2026 19:16:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8CE9A6B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 19:16:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1579D12057E
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 23:16:31 +0000 (UTC)
X-FDA: 84702268182.17.6E66884
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 961B41A0004
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 23:16:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kZ3Xw33y;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777245389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=EoIT9c8Ct1vPzpsjeMM9IGjhNB/I97ZHT5jxhgIm/+0=;
	b=ExTCJCVWI5w8FOLqWxtF5Nb54oKqFKGP82jFt57wCckeEPESkI5kOVjrjvptzaSW1k9NGZ
	aGjTKXuI+40ADhpdV422onBr7/X3FwV3huknYZFWGdhBj8i6oL/RrasJqk0Si9sy4I0VpR
	oS15FoOXhlI0mtJjobne6lpFn9F7k3o=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kZ3Xw33y;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777245389; a=rsa-sha256;
	cv=none;
	b=syC46/w/Jqmmg0swdy7wg5nyQ1xVrYGlpndFHcPcfCHIM6UXIISw9Q7KuqCyH1qu8GtXpf
	ykAjYNI693SzrMw+NeJ+4ro3ArO40ZI9jkYTsBq/pUXSGa5UKgqOfyzJyOQ1+dNixTPaAQ
	vdY85C3PhtZfOBygUfd4pjC5ixD2zGU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 10DCB60138;
	Sun, 26 Apr 2026 23:16:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198D5C2BCAF;
	Sun, 26 Apr 2026 23:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777245388;
	bh=xK3N5VQUiYZLj+igl9pSNGuZYFek1+bNERSn81pIloY=;
	h=From:To:Cc:Subject:Date:From;
	b=kZ3Xw33yEQRge/f82YUoMVioGH2Xx8fnIyFxVU/gew+SEqkwR6K9UUxhlOxYfWmw4
	 fz+YwLgLl6rKrDQ7czhrk5AMQLId/KHnncfuR5iVkqgE2C3TKA87ss3suB1k/IbGPD
	 2U7sl8r4uCq0/SIje84IV+jW2UxwIyLPuSIFa4SUUE58ItBr9KcH3Ar3ReHfU0kd61
	 ErSKPe0kba+7xW1UxhfOzA5gQwcEoEVnIvbSpSCE1n2e3rI3thHNq7KGE1gOz4nDC0
	 768QWXaWDnvyMYA4HoO4MWWjmJcuhCK10fpOwBZ6u24mNXcM1x2uPX/2YipArB+iM0
	 7nl2WwK1fcpLA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 0/4] mm/damon: repost non-hotfix reviewed patches in damon/next tree
Date: Sun, 26 Apr 2026 16:16:13 -0700
Message-ID: <20260426231619.107231-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 961B41A0004
X-Rspamd-Server: rspam06
X-Stat-Signature: mdj1ty6fhys8ba6jziitrjiqbc9scj8y
X-HE-Tag: 1777245389-518001
X-HE-Meta: U2FsdGVkX1977TWESRJ4o2ivm4iJWYSfU0T2Un/KXS5tFhdylj+b0TpRgIFXUqpa0VDItuUlDKgitoARsRj/FGoPJsHKGFcHK3XAqPf5tpGUp3x3F7dPjEPFes1p86eh1KqDc8Qv2AoHk5FzAh1PRMNsSYdeIajecCx/3Zkv+Zze0mU9g6TOIZ0JU8epEoFIadKUgXuMnMqqXbAgSkvudiakeHVFBvNFuCS0oBt/15fW/6XxuQIinqqIIsJY241my6N3ragGZnfQaAWzgJBeij6r7H1XdrJoL5P6gCRhBjkPwuwvL1zyQQA9aEIf/f8wnX/0ZVPJVadIzEvfQA8lul/oGZJnPtmVmQkHfr7yxrPyz2Lue0Zxy3eCdsZw2bXUwa/HrdqUtY9bvBdS5cGXAOQThpBimaTVMV928PR3FgIEGA6K5f8HZyiMk7KNbqLaMGeiBOj0QcvDWgGZucFbU9MzZtRm/vJJ4jeEwJqD8reDTaBOtXdvZfAgUZqcW6I3EUFMX1oJ8POfx3sdqe2YhMbaI2llm25rmTacQmL22opN1JPU2Vogyy7ZWv3u5qjMxnRx+sXOkaiaHKC+UXrtcs/6o0IqxG4kRhG/wtYvTni+ktxnCdrl5M4nWimrx4DBUVLGgVtToHwrhEgjTjJHfeNckykdDFbWh16NPSL2s2R4Pwaq6kMYkZeHz0KKI36MiGJMRXiALKXPJb4/eGyhOtswhAW0Mxf21vs8w2tHO2dRqGKWQlmCSc7nZim+9WH89Yvfck2+R+RFBCuDLTSplhD6OTA9cHWhCUKW3doNxfUvdTFRKJLftoKVkKW3gkgWgVqdNPOT+V9wdQaur01YzEMMO7QosGdF/Yu5XM5yqEBKXmcnCyWLNiC2Ecwn6uYWv8+ogk/YrzAL0EgPtjRJjmbddRLLtGCaGM7T6ElAJbCKhpaBrYO42yeKgJJIJz0Q2kGV04aOH0arUFid3o2
 sm25T6HP
 Tn/GOsAkCMOmXu20ibGx7+rKWQJtXs0IeztQCfkYNNPPiWytBel82jb825CAtG4J4uliUmWdQnn//aIOQMPDgaR2Wxu+/ug5MSUgoPFx0rKUxEoQjKEIreNCkNlUCYzFt3St4xXoHznQPh0hF9FoGXA/8KUdCb05L3TEQbEtdrqVUMq26KjPX2BJklLuuXbXjzEpUnF+/ByGUkFbzoDMG1KSQr08CorRMaMT8jMtBHKggdmo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Re-posting non-hotfix DAMON patches that reviewed by DAMON maintainer
but not yet merged into mm.git.

The first patch from Liew Rui Yan add a minor performance optimization
using ilog2() instead of inefficient manual implementation of the
functionality.

The second patch from Cheng-Han Wu fixes a minor typo:
s/parametrs/parameters/.

The third patch from Liew Rui Yan make commit_inputs operation of
DAMON_RECLAIM and DAMON_LRU_SORT synchronous to improve the user
experience.

The fourth patch from Asier Gutierrez adds a new DAMOS action,
DAMOS_COLLAPSE for deterministic DAMOS-based access-aware THP system.

Changes from v1
- v1: https://lore.kernel.org/20260402155733.77050-1-sj@kernel.org
- Add DAMOS_COLLAPSE patch.
- Rebase to latest mm-new.

Asier Gutierrez (1):
  mm/damon: support MADV_COLLAPSE via DAMOS_COLLAPSE scheme action

Cheng-Han Wu (1):
  Docs/admin-guide/mm/damon: fix 'parametrs' typo

Liew Rui Yan (2):
  mm/damon/ops-common: optimize damon_hot_score() using ilog2()
  mm/damon: add synchronous commit for commit_inputs

 .../admin-guide/mm/damon/lru_sort.rst         |  2 +-
 .../admin-guide/mm/damon/reclaim.rst          |  2 +-
 Documentation/mm/damon/design.rst             |  4 ++
 include/linux/damon.h                         |  2 +
 mm/damon/lru_sort.c                           | 46 ++++++++++++++++---
 mm/damon/ops-common.c                         |  9 ++--
 mm/damon/reclaim.c                            | 46 ++++++++++++++++---
 mm/damon/sysfs-schemes.c                      |  4 ++
 mm/damon/vaddr.c                              |  3 ++
 tools/testing/selftests/damon/sysfs.py        | 11 +++--
 10 files changed, 105 insertions(+), 24 deletions(-)


base-commit: 1e24f85d7a997307185d5345c1711f485570a123
-- 
2.47.3

