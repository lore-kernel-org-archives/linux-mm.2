Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63E8BFD0045
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 22:28:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EBF26B0005; Sat, 28 Feb 2026 17:28:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37AE96B008A; Sat, 28 Feb 2026 17:28:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27AEA6B008A; Sat, 28 Feb 2026 17:28:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 191626B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 17:28:43 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A74281A02EE
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 22:28:42 +0000 (UTC)
X-FDA: 84495306084.15.7D8A2F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3FF461C0002
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 22:28:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eExcrfpI;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772317721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=k3j18GLMxV/tG2kzOw0L6wWwcexJlsnv40zEVE3BIM0=;
	b=laxSu6IDa2NCr7XLJINFCUMiqQVhiIN6XOfz89YVW2FhfBaPU0Rdw6vcpat2Zl1gOTK+3F
	1hih9tLQSkOqnNYf1w+8kL5i91D66iJMfNg+no9gJEPRb6ofWlk/IuTeYVYa8DrCOgJSQy
	L2+3H51jFZKJK3LNco+t/VKra5lDy9Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772317721; a=rsa-sha256;
	cv=none;
	b=ldjQG0iTKja4fk++w7fcUpLUNMp7lO02QRcdwIq8KWerQM4okQ2wmgmsF9rOHyubQh8HNW
	TK7TFqcpJdSToV7ISpSRaFDEwYfcM3Bx95aGff4tpbvXA3pSSrBoAlyvNnsDcyWOvCzkAE
	M0U6QAGfPdZI+djahMyqaE1MzUwvroc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eExcrfpI;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1112540DB0;
	Sat, 28 Feb 2026 22:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC3EC116D0;
	Sat, 28 Feb 2026 22:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772317719;
	bh=3nM294S6J5PfuhiMKe5iqRSZkPsVsLyIz8tFcgHPvZA=;
	h=From:To:Cc:Subject:Date:From;
	b=eExcrfpITzO0YCE1K6TX5+Qsc3Dba7Va+Tuai7Z1Evt+mjN3FhhBNp+VMYOyjAXz+
	 IAxVuGkfbeRO/kOxzQKxDLdYj/VfcQp7DpISeFgVOoUrq2gZul6kxsAB1O7ZlhXifT
	 PZRDY6GtNzg8VJuN8Be8JubTnckhpWWU3sAcppxCYiCwZ7my1kv02B/7wwXAmvjugf
	 0v7Nsq7zidWeNHJFhu4FHfie1e+G3vcPyt4U0rfqMDCKSor52gIkan+tst0HeEL9HI
	 tq63kx6cOnSmmTYgZF6zo2FRPLJ5VXfnYyZusBEXHsmmbEKQMEF8ApbNRbfb2Jcm6E
	 6/j7OZl7ISnpg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/3] mm/damon: strictly respect min_nr_regions
Date: Sat, 28 Feb 2026 14:28:24 -0800
Message-ID: <20260228222831.7232-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dqhoxwoqgjokzmin4rb9wpgupxxng8x1
X-Rspam-User: 
X-Rspamd-Queue-Id: 3FF461C0002
X-Rspamd-Server: rspam12
X-HE-Tag: 1772317721-974192
X-HE-Meta: U2FsdGVkX1/RrncmxZY3KNsHN+L2axJoCJBt1JiT+IlStT6lSd1BtFv1PJHvSH0KqhQh2udyNnHVvNjdPDCzB1eDwZ9ltFNQoXHKE5mSh7UJbYDkoPJKNGcRzUFLKm+bnj3zwbMctx+9+o9X3vGl2eIBwYqbPklZQqab/Vt5fyTNbEYThjnSPuNSmhw1mTjb7VlDWn2zPvd9RInryvXgZJdPAvqBm+UQDauFr+iGidslnUFATCzdZ4VPM45UF42Nk9qpvqDJte/DmwRi9+j/6O5nXvHMNxIvy7UiPDarTZImR+usIASr2Cm4wOtoEKpiJLeRfWozyHKNh8z8HEAdP+DolTdAC+sz5SYCnM3Bi0rdGTwnnUeltojYb+DI3uwRSQyJYp11RN6ceUWEh9SwVnPrCiKQmqK86kfhNRD7Z2OBW+Kuotgp5EvGYcW7ZkUlDDa16Gu/FSRB94VLwiQizdu7p9aHHh9xhJdL6rds89yqjHQIMsvHjpsswhN7xkwQMuxx8NV1i1aaOZ2OBOQ/YmtccU3ezA+BXbd0KVKlgyByVqM0ClgKIjjiMRST15Mwg13muQoFvf8PDhcpJ3dsaoxqMMnvWI150+kB+t+Acdd2d87sYhcscU/2lNTz+R6ZzcErf5lG9byIwyXhSyqH1CpUIOQf28jpR1Hi0GzAzM4H95zulGgEb4e+6mytwJUd35rxKvhb2HC+2te49/S1NxyX7NxKGK6/ce9fqLZUqV3eLAmX35nDlj/9e9bOs4KB5JSzO1rbqp9jUv5rT4QbjO39dNjOeWVVQoO0y/DkS0FPFKDT980SIxuwmJwfxfPpL8VVg6ymGApddIJyKxE4pHWw6/5kjcoz46YE1trUwaHxEuAK7wXpfXWvqkgPAMNB+hke3uYnze5zdxeMK807exiAIoOHKtwmPo0MvxxKzY6JHbxNq4fgoRSGNXFFbN6kcKAhRvpOEDYbhZpWZWu
 iCo/7myM
 XaIks
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON core respects min_nr_regions only at merge operation.  DAMON API
callers are therefore responsible to respect or ignore that.  Only vaddr
ops is respecting that, but only for initial start time.  DAMON sysfs
interface allows users to setup the initial regions that DAMON core also
respects.  But, again, it works for only the initial time.  Users
setting the regions for min_nr_regions can be difficult and inefficient,
when the min_nr_regions value is high.  There was actually a report [1]
from a user.  The use case was page granular access monitoring with a
large aggregation interval.

Make the following three changes for resolving the issue.  First (patch
1), make DAMON core split regions at the beginning and every aggregation
interval, to respect the min_nr_regions.  Second (patch 2), drop the
vaddr's split operations and related code that are no more needed.
Third (patch 3), add a kunit test for the newly introduced function.

[1] https://lore.kernel.org/CAC5umyjmJE9SBqjbetZZecpY54bHpn2AvCGNv3aF6J=1cfoPXQ@mail.gmail.com

Revision History
================

Changes from RFC v2
(https://lore.kernel.org/20260221180341.10313-1-sj@kernel.org)
- Drop RFC
- Rebase to latest mm-new

Changes from RFC v1
(https://lore.kernel.org/20260217000400.69056-1-sj@kernel.org)
- Split regions every aggregation interval

SeongJae Park (3):
  mm/damon/core: split regions for min_nr_regions
  mm/damon/vaddr: do not split regions for min_nr_regions
  mm/damon/test/core-kunit: add damon_apply_min_nr_regions() test

 mm/damon/core.c              | 45 ++++++++++++++++++---
 mm/damon/tests/core-kunit.h  | 52 ++++++++++++++++++++++++
 mm/damon/tests/vaddr-kunit.h | 76 ------------------------------------
 mm/damon/vaddr.c             | 70 +--------------------------------
 4 files changed, 93 insertions(+), 150 deletions(-)


base-commit: e4506bd63542dc58b2913cd374c518526c008a2c
-- 
2.47.3

