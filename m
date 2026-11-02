Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5667060D01E7
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gvpLyEv1
Received: by kanga.kvack.org (Postfix)
	id 6F41F6B0606; Mon,  2 Nov 2026 10:29:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A4EC6B0607; Mon,  2 Nov 2026 10:29:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 593016B060D; Mon,  2 Nov 2026 10:29:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3F5FE6B0606
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:29:01 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D827BC014B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:29:00 +0000 (UTC)
X-FDA: 85390562040.17.3C3BD85
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 49F1320005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:28:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gvpLyEv1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vgW6iwfR4oxej1sYSTg0bSps9+FkII3Zqymh4t6eG2I=;
	b=jqbJfXfkLKL1UELXYUDEknZFnk1jjvBbIqDwCYOJvDvxdePNt1Yo2AGm7SbQHjbno8Kptw
	HnU6yIaLABRbmAKSjchnz8R+2iPVW8DpqvenoIf/Ty4Sz79bZW1tq284ObHVeS+alVwKpL
	/jxWjksHK5WfYHqFpCqi0wWQDxUCrCQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gvpLyEv1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633339;
	b=OM7QfVqVLU7x91+dmdR9pPe5zRCJ2fxacZyEcRYnWmdllfboLPDXB7HbR8H8Nrm4tNfEug
	47abSHOeCzrTaF0wmjmYNbjmNIc8Dy5aTavFWfl/ogLWLpoUs6KbiOUJxIF6RU54U1jE6w
	8bWkGD7AXMuqAHvtLCCWC3aO/cKmZwQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6A95B4141D;
	Mon,  2 Nov 2026 15:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08BF61F00A17;
	Mon,  2 Nov 2026 15:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633338;
	bh=vgW6iwfR4oxej1sYSTg0bSps9+FkII3Zqymh4t6eG2I=;
	h=From:To:Cc:Subject:Date;
	b=gvpLyEv1W1KJxo1PAJDh8KPS32YJFHX7/HsmuuZht4rmXQ1GtOc6nGzDPSSy5NnCf
	 LMx0sQVe1Yt1Us1YPjKRcAxNNDHs6AtycyfPlTz7kKK+XCJH0WhLzjqPvkq8YIAiKs
	 wDkwg/aum3jc9pA3ldSeevn0LfCRUQEuWAlK6bo5HTM3+IjQ/7HKUEKIkyBNn6GSbZ
	 ecp+8bNQtdUoAzfhCV5mjdmWHn9ghCd93h6BXd0O36MA8uWkvWWwzHiGUkTxHoIjKp
	 5VA+3lP+TzWTeECyXAFF8Dr4pJxXV5bmsXd4jdkxNOb/jrrD+YeQ024oW8ht+4dBMd
	 uLmqwT6KhOzNA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 0/3] Docs/admin-guide/mm/damon: minor fixes
Date: Mon,  2 Nov 2026 07:28:44 -0800
Message-ID: <20261102152849.96057-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 49F1320005
X-Stat-Signature: 9dwia7yuykaixebakbqaq8ewb7tdmk7d
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793633339-199414
X-HE-Meta: U2FsdGVkX18ZodfN9dPSeME6V9cK2VGum3wEdUHzQfT4daI3IRY5pjyoV38pZR9VpUCO/Ej1HKVmBi1q6A5DBAR8Ps3rpM014zKVFZxt6EUgBU/qEIMpZQDe79bgnnCH5An39w0bCnLS9vYGtfO8/RKOMP0w+CboJJKHIc1DRq5qWgGRUDM96R829iWUAI2ehfKLzGSgv8MhuMiSH+9km5iIgPHHzWa2tpLxUJ0qAqkXoWuw4OxdLaj7AmCwh8S2krm2+lmG4iC8o0AWfK3vDxYScUWfFlhz51MVGlDhhvVHSobqtXYT0hzurcYN4jJXser9W3dqK8kkmscXysh4o28tvn2ds1kyaa2EQjHLYXHCBmB/IMqHY6OZNsWw2SzRNa5jYnu1OumLu8xNyUMk9n16tXiiR2DgqqryIFjbPR9vNWcHXNyv+WNgcJpibRAe9TRia0Z3fApkRzcsFNJb59exPtXiM/C/MT7MoBLV+LW1osotPoaXq3TgpTjvHlVDJPue3XhwouHMZqKcMef6AdcyBPxzU5FfO5TyXrX/U7BgTqva44FukphVppPSFXopaUzgqByMXiOqDdxBalzY2rhSCpsToj3xoW8o4cePGDu49B/ooBbZnzTh/ijD92C8EgKruRYtHIlWpwclwZPkM9SRYvNQQD+l0CNPrdWa2oZ1DZeGeDV1x3IrK86iZfSpQWaoES8+dzFHWwSHVMe5v/asHTU1L3+wXD+qdI9D7w9Ba/hDqsxyOK7dBbdVd1wuWgnQgtnGaN7+MNX0JpDEfopNTLWTg48MS5uplj6zSCxWSl9UAOZQchcoE7JVHQ4tduVEu5ja7nfkLIsEnyRmLBCn991ryqPF7MxfdC8lmQHIq2qeVDgPZ0Eid13MydkCLIcrRl3+kO5wDny/sNYGPHphvHdMpMpGN1bdF0Jt027YVsYSDAi2sq7PU2W3eTHgSoVDPT7E6SDLgZ0omhd
 XYDlofmp
 3ojlr4wujORAuprkq/wWgMYljtPOQ9dhfjnEeTQ30dzl+gfOwMuKkzKeMNh+L9wxHcQv40ZM+aKuFpeBtTq7TYkShzwMk12jCpmzthQGlNBwkdmLfXp6Av8cUNv8HfzWHpK5jG0pr+zXmP7KYzM/aZmR1v6n8pJ6piR3ak4DuYngILbd04G9lzAkGTBjMWXXyjsd7hEsGmuTU2QU/vo7nZKB6fiku7HldvZtknVIAy4jCsQDdNkHOObNgbboG8SWtknwO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>

Docs/admin-guide/mm/damon: minor fixes

This small patch series fixes various typos, copy-paste mistakes, and an
incorrect command syntax in the DAMON documentation files.

Changes from v1
- v1: https://lore.kernel.org/20261006061549.627-1-adrianhuang0701@gmail.com
- Collect R-b: from SJ.
- Rebase to latest mm-new.

Adrian Huang (Lenovo) (3):
  Docs/admin-guide/mm/damon: fix various typos
  Docs/admin-guide/mm/damon/lru_sort: fix copy-paste mistakes
  Docs/admin-guide/mm/damon/usage: fix incorrect option syntax in perf
    example

 Documentation/admin-guide/mm/damon/lru_sort.rst | 6 +++---
 Documentation/admin-guide/mm/damon/reclaim.rst  | 4 ++--
 Documentation/admin-guide/mm/damon/start.rst    | 6 +++---
 Documentation/admin-guide/mm/damon/stat.rst     | 2 +-
 Documentation/admin-guide/mm/damon/usage.rst    | 2 +-
 5 files changed, 10 insertions(+), 10 deletions(-)


base-commit: 7fa9b9f1350aa38c32315a6de022c770e78dbfae
-- 
2.47.3

