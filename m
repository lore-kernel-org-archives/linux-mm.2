Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 798D2F433CD
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 00:22:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B33F56B0088; Wed, 15 Apr 2026 20:22:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A76A56B0092; Wed, 15 Apr 2026 20:22:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93E136B008A; Wed, 15 Apr 2026 20:22:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 809476B0088
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 20:22:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 045541606C1
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 00:22:01 +0000 (UTC)
X-FDA: 84662516484.20.07C7A02
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6CFD2180003
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 00:22:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XO0LzLDc;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776298920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6rxhdj1pTdj080XBRZ9JAuWuZ7BSIOJykr8Qmiqu7jw=;
	b=opqCzyzm6LP6UsJ32YxSNy9XcxKcNpvBkhZdbxKBArifC7XZb3f/qfSwWLdBCEL5ydM0xO
	kcwxkuN2eXCMXj1mJ4XZWjcY7gr/NeCRqU7taCV6NusKwywOJYVtoUMP40nB4FwFH0VtkM
	C5kgzcrZqgsn4Wb1++Sdo5VYhnyOw+c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776298920; a=rsa-sha256;
	cv=none;
	b=kvNpbOeUp+wCqTSujQwGVm2sicQa0pjWm1mYKKABnmDt9zK1CaFQHCw56IBHp0H+X5rXFn
	iQkGSzFlMWRVJPqgyztE7IltdlsXAyULTrIhT0NC/hN79oDQq4YaTlJlLZnpPrDTq5Ngao
	55AqRCgA5tQmabk6aGZuXET6yU9LqBo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XO0LzLDc;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 63E5E417C4;
	Thu, 16 Apr 2026 00:21:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21B1C19424;
	Thu, 16 Apr 2026 00:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776298919;
	bh=4aCM2a3NrSe0b28zTKT01qVpGH9mP8AJfok0bnI/F04=;
	h=From:To:Cc:Subject:Date:From;
	b=XO0LzLDcbkq3gAmnsRuFTrN6VyKXKAFpBnpTwRQbzmvo+RxFbLxgdiTFJcKihAXob
	 m+TzjKNcfu24qbPZhOLSz/IV3EXPCSMqxY6RVMErTfvdT868Y8sHM33hqTY7ixMiaN
	 wbfIQ9iy9vAii4YKsjxF7xl7j0oJcX4yKNw8nQbLeaXDRG4wdfb2wmQIuQtS1V1llm
	 u39MDqgpU/srdv6eiKz1q1cmiwOWIXgUdjCaMONwhHsaofOCPmQcWa7qBk1fqvqXsz
	 WiQy3JgQUCxbdZHSYoUE7nXnmUk7MAACNpdIjkEwrSeNCUb+yocWjrwm3J64+gEAwF
	 usdS4+iN0VnYg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
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
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 0/2] mm/damon/stat: add kdamond_pid parameter
Date: Wed, 15 Apr 2026 17:21:45 -0700
Message-ID: <20260416002149.87090-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6CFD2180003
X-Rspamd-Server: rspam07
X-Stat-Signature: bcqjrea6wap94uowyq3gcja5sac5a65d
X-Rspam-User: 
X-HE-Tag: 1776298920-235977
X-HE-Meta: U2FsdGVkX186+hNSMEBho1Dzg1FZS5WIr0xoNin2wSqcDMu15g70PdWoj5Fm6qCCu6j8RyBQ8Ruh8ldzKGLcohXcSpMEjsL/yp6l27dBolpyYfCeIry2Bp7HcmHhIgHMxyRfpo5+TsnfUQ2lGlMrWFLtSNqepb/eEizm+T6VpsySCD84WWOeLmyWK9Fq314iYsoavFLolEFLNpVkEOIXtQt6hMfw4ZcOxtfVZRzD9Ew4/bVCQqGJb3oCZoZwLC+NjE8xTbyJUOAxY4Tvgxy8oy7TYiOwQ7XsZp6Je15Yc41zF4qZhRVbLS1MPluuV31daezIFybC8yqJfgW0HVPabOoAkwf2KZ3QWxojtBa1QQRttaxhM9yJVIj714Vix8TKufvCyUJ03sqXpFPBrfynQyp52FMr9eo+J8q7AQaGsFIPHwSescoVk9RXusPmXZ6P+k+Ucoqk3hv35h9BoTBH1zkXEILwoVmKnK/YW8XO5w+6j6XxayhpVF2rQabaDJikchmmlNU06qb9ObynjEhCkWXnnU5V7vHCA9erCinNyXnidnSYJUVmBbNjiYZV0xTXinBWo2t82lEkVluzpHPcrP8slQA/2sK30zwms+cegxdn7PAUKuZOlXs4DHioO71hdybGUAa216g9m2wJz+VYdhmKv7TQAuhdT+0ZDW0ikzv0QytE36T3YdQAPO2AC+am9U/mP75Gb8rD4JU/B+ZeLlUsx6XLI5nbcTUivjey66rqZDzE8xDT5nIx9ST+KwzH1uEIuF5VG+wfDsC+q88qDUS4xaSmwFfMFkrD5zJ90qo6u3iOq7xVU3x2vEPVw5xfa+YpML1KuhK1q4/ja/HiRTb+TrHq48NiOxY2IZyQhSDSFe/w0S3ZfXX3jM+st0z2Q2Jq8sy/nZHN51yAqdB8P0Fu92D0vGwAMnc+Ckf5Kwa9CG4NlCEqvLEAGMWzEuKf2mxqyvTYnm6zhBqBbo7
 sbyzu+w8
 Ee9H01VdoF5tYm29eHYtUvUigATkSN7xnuJM/IcnsNCk+OgGG+KItnr2afVZjCWbOe1tFKL8t3VrJrsYCE27v28QavKDczrnpbj82Gy60/2Ah0o3INFzqXhuadBtlWox+FV+oGhrShDe0Fr8Gd6FzbUum6IRHRLDK45RYlDLpbnFSkvK0W0C51LzsPzyNmcRHsOODgdsRX4zqum1bCJdroMYyT1XF3Ax3zj70MiM7YHBtMeY8HeGjTgOrcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_STAT doesn't provide the pid of its kdamond, unlike DAMON_RECLAIM
and DAMON_LRU_SORT.  This makes user-space management of DAMON_STAT
unnecessarily complicated.  Provide the information via a new parameter,
namely kdamond_pid, and document it.

Changes from RFC v1.1
- rfc v1.1: https://lore.kernel.org/20260414235912.98174-1-sj@kernel.org
- Close the parentheses of error handling block.
Changes from RFC
- rfc: https://lore.kernel.org/20260414053742.90296-1-sj@kernel.org
- Fix damon_kdamond_pid() failure handling.

SeongJae Park (2):
  mm/damon/stat: add a parameter for reading kdamond pid
  Docs/admin-guide/mm/damon/stat: document kdamond_pid parameter

 Documentation/admin-guide/mm/damon/stat.rst |  7 +++++++
 mm/damon/stat.c                             | 18 ++++++++++++++++++
 2 files changed, 25 insertions(+)


base-commit: bf44f59d29186d80db01e4124a8ab23b3b235b32
-- 
2.47.3

