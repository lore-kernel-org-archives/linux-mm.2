Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A477C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:23:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80F3B6B0088; Mon, 14 Sep 2026 10:23:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C0326B008C; Mon, 14 Sep 2026 10:23:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D8EF6B0095; Mon, 14 Sep 2026 10:23:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D4186B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:23:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C2BD41C0014
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:23:37 +0000 (UTC)
X-FDA: 85212586074.16.A96C8B9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4649220008
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:23:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZrN7HNCk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789395816;
	b=JB/OlbfkHKi4vxdH0l33XpIv2K/UKjA0DKhm1bWB37cFK3AHGqUgn0VbgGjEhVVVWQaNdi
	cQG0TooS9NVcZdKLUFZvul1kmmVuF1+zPG1H8va0NP6Dp629DYZt++Apj+evgRpA2uikb0
	HveOSjICAdDOxTk6usjCQvKgsJ/rC50=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZrN7HNCk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789395816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ep919c/A8naa0L7/1EU26ygjkhlh33Hy/XJA/cnxVTQ=;
	b=jp7LbAp7xfaooylKba/Gf0RvwSAUwooPHWQgvq87yfW0uPFvUMqAF8nv4v27EbSx/ubWMK
	QRK3j+lXb1OQa9G0MgxlUj1uX6LYztkiE5F3i0Dlsxm+j9/MTdyV+LhAQnsdmiOMAenMfe
	qnlVYWPbyDptafq+6BWAvfnunPzAPUQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6909043BE5;
	Mon, 14 Sep 2026 14:23:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86C81F000FF;
	Mon, 14 Sep 2026 14:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789395815;
	bh=ep919c/A8naa0L7/1EU26ygjkhlh33Hy/XJA/cnxVTQ=;
	h=From:To:Cc:Subject:Date;
	b=ZrN7HNCkhe53u8UJM+fiF2ur5cR5zGmJ5GkiXDwUSXocPzDYY+ykkqGpFcBwZjl1l
	 5oIqkZkGah2Lm4iWMs8f1RGiWsw/t2ZPNQQm/h6ayVAU/qDfiRLElRFFDeRBz898zy
	 EebHqYPujLpDBkvyHi9/aUe6XTd9o7bUVCmw/WgMreRkX2wiCur8zRhLK4CRhSbR6x
	 ZswdZvyuH5IEd4K60LNLZ5rTFr6JEtc3KbkeBVEr4CcH3th4TUOgwJSt0p3r4/BVWO
	 ruXQ9cXyNajpxI1tXy2dLST+3Cce8fCQB9nZRC1lEV9rVyDd+Hi02G6uW3qUTODXZW
	 N0f3/ppCkuJJA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/8] mm/damon: move damos filter range arguments validation to core
Date: Mon, 14 Sep 2026 07:23:17 -0700
Message-ID: <20260914142327.92510-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4649220008
X-Stat-Signature: 9h6a1n6fcat4uxm5cgu87wrbbu61zmds
X-HE-Tag: 1789395816-586650
X-HE-Meta: U2FsdGVkX197wCWNI3IRPQ47qOcjkRmDjxgUgNxjLvqjs0FcgawP2V38nH6dhh2yp/bvod2DVZViFE3UewjYyUc0I+EBULiA8H5ShdUGMUO+WEvuoCNq9tOfydzcyFC2TEnU5wBjCxSVAY0tNWu+v3lllJu4Y3UBTOmtuHbUxSGzUi9IBtj0mnY5BxUV28V8i33LHgw9Qy4WtIcOaOsIzSRUFluetpOQWYnCrAXFLa4DhAyuJNbTkJe2xM+nQyrW2OJQdeL/p7eX3D49BgPz1u1iT2+4ECzwICtHVJ/cAk0ceeTuqgrHv38/J7zFdH13+EU0/poEMIXXZ0lvy0Bn5vjXBqwMqwTt5IKvfpCrQkP+woB6H5MdNKyp1mlsHJh2X7bpFpVUqFHlaTxfEIh6C6Vaqfr7efKGI0Svp4SjCXo35jgduEqf94nND2nwNHcJJBZWszYMTc2dNujmGB4EbYt/z0MpmJpY2cdQYICklYjXQMhFsJeKaABQ3rR9/TE8y/XxsyFrtxKwElO4IbTpghxPrOim63h0PgEJauC2UWuSkIBTToAX+mk7u3bNa2NhivTAH2EpazwMOTWDBP1M9yBF1VDZgdo+3WBSe7955aPvl0UeP2J4VxjBhVA8VoTyDJHjzv44GWwMBSCYEPKwQ6uS1rZVR/7TpfHZcMHwmycdt6I1hoRMoPEa7G732J1TNO716Fz3g7H0UjqLj0+WfW6ONd0AMH6tJBjz5kKNjXmEeh49jHCoW8xshSE340lG725ogYXSRSTGz8bRh592rx/0saO16wGMdgmcHO2c65hN0VZx9NpFig0T+nf09SjfLKlihXbkbjgIOMLEjdFRbSKae7hra9Zy0dzj5qT/rYEAMxMUm4yWknZTTIQTLH/eppmGVs6MEePKFktqv3aslxC9mJTZq4MR48J+s/TP10Z96QZDWunjbdwykuX6fuY6/vkQYE9Kw3rrnhy4maQ
 A1eiGm/I
 YkKbDZuP4Qm1fzVHiMJVYVRJmvvR2IrVBjvIHAD1Rlkxh/elAdpxFcF4Ar2DBKG/gdQOzbYkT4j8Pf/dyqUUVdWqyi0fYT3LCeZgJfYPwhouctB4Ct1WYe5TAHex/2H98krAJ1nGsx0yn6TQZh8wuPEj8Lgbntkw6Zos0HS5X85qysOGDbVAmG7N02vUTjI2I6qMBUTT4mAdjyRfW2p42nwfI2CYaPODyz6OwbFUKZZJgaDs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMOS filter range arguments are being validated in the DAMON sysfs
interface.  Some of those have minor time-of-check to time-of-use
(TOCTOU) bugs.  In future, other callers might have duplicated
validations with similar bugs.

Fix the bugs and further refactor the code to move the validation to the
core layer.  Also add kunit test cases for the validations.

Patches 1 and 2 fix the existing TOCTOU bugs.  Patches 3 and 4 adds the
validation in the core layer.  Patch 5 drops the replicated validation
in DAMON sysfs interface.  Patch 6 further cleanup the code.  Patches 7
and 8 extends kunit tests to test the validation.

Changes from RFC v2
- RFC v2: https://lore.kernel.org/20260913171706.103052-1-sj@kernel.org
- Drop RFC tag.
- Rebase to latest mm-new.
Changes from RFC
- RFC: https://lore.kernel.org/20260912191807.138502-1-sj@kernel.org
- Handle error from damos_commit_filter_arg() on all call sites.

SJ Park (8):
  mm/damon/sysfs-schemes: read sysfs_filter->addr_range only once
  mm/damon/sysfs-schemes: read sysfs_filter->sz_range only once
  mm/damon/core: return an error from damos_commit_filter_arg()
  mm/damon/core: disallow max < min damos filter range arguments commit
  mm/damon/sysfs-schemes: drop centralized filter range arg validations
  mm/damon/sysfs-schemes: use switch-case in add_scheme_filters()
  mm/damon/core-kunit: extend damos_commit_filter_for() for wrong input
  mm/damon/core-kunit: test invalid damos filter commits

 mm/damon/core.c             | 47 +++++++++++++++++++++++++++----------
 mm/damon/sysfs-schemes.c    | 32 ++++++++++---------------
 mm/damon/tests/core-kunit.h | 38 +++++++++++++++++++++++-------
 3 files changed, 76 insertions(+), 41 deletions(-)


base-commit: 5e38c61dbb4349ff7e900d97d96f369c64678eea
-- 
2.47.3

