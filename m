Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2B81CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 20:38:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 248B98E0009; Fri,  3 Oct 2025 16:38:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 220478E0008; Fri,  3 Oct 2025 16:38:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15DA08E0009; Fri,  3 Oct 2025 16:38:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 027FD8E0008
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 16:38:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9D2DFC08E4
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 20:38:56 +0000 (UTC)
X-FDA: 83957967072.07.7D49B39
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2024540005
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 20:38:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ZqJ/d9ql";
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759523935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dknTB9JrvKEFpPPqSFqHnlUX9vHqW9Rme4AqZC2h4pc=;
	b=woUZSp0KgPEAZV72lvEEsRViuFVdrWINb4ifnoo62i1/K5h6gi2McHRPpuWbkhlSQCNtGj
	0X9FMnGdwIettqxZdly8qaUJNVRhlhgD2s7ABUcVawViGy7hIdTCrp9u2OLIFPZlEGmTUl
	9MpNtw/Sao4DXt/Y8XCHZOT6RtwYCOA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759523935; a=rsa-sha256;
	cv=none;
	b=OEhfXvMViCKeyVBri/VZWkbSxI3lWoeh+czPb5zN2AtKTT7WmPGffkUxDh0AVnuoCsszDh
	wIkO+SObseF10lDNYuGq5bZPRXnB8/iG9evq2JgTlxKlxpU4nu66xBM4efZDdClMV9Lb6l
	43cn8EJbr5MsTXNnkYIMl+2YEaD/bgc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ZqJ/d9ql";
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 79DD3605A1;
	Fri,  3 Oct 2025 20:38:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB82C4CEF5;
	Fri,  3 Oct 2025 20:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759523934;
	bh=8Kylk+IGScGVl68XY62G0IZ7hqRC6OFEitrMjSrCFis=;
	h=From:To:Cc:Subject:Date:From;
	b=ZqJ/d9qlMsYouwfCYmYg3wszEYzw8EOZv8jG1Utxyek0uCcIgTzGt3A1ekVkuEV8/
	 OAnoFpAtFI/a0+DKGJnUnGH2EVvrQmNv0iZWMmmegz05Sv22XotbcOk2/ld5Qz+TYl
	 QDyKE+VWzCBMQ9JLUR6n1p93F6JWzuoGqeAUAUYwCAJEvTEJK3vx3blOcW7T1R5nFM
	 1EjxKBGNH6HB31vrPWvaasZXlGgl2spFk+6bJlEqw33NCIvhmgZPrx3NulvezhqlLN
	 aTPcz2gBpZCSHccRx6QiVpr0upiomnXZ7yOad9xBR9a5ZTpXk5G2RY0wyV+OEkxl9v
	 0SY1aFcD4xiAQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	cgroups@vger.kernel.org,
	kernel-team@meta.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/4] mm/zswap: misc cleanup of code and documentations
Date: Fri,  3 Oct 2025 13:38:47 -0700
Message-Id: <20251003203851.43128-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2024540005
X-Stat-Signature: 8ocxc6uarkdmnoxzsojmrz8y7c6jrkc1
X-Rspam-User: 
X-HE-Tag: 1759523934-989487
X-HE-Meta: U2FsdGVkX18RROfdze815Y3bMNm3+3ak/4EznEZuGRKTJG5jjW8EgeCIWQI+fpHIvY+BS7PWOj+u4zbh2Xhdblb9jBLqmlmfV8MPHz1Y4qfDOfeZrR8ry7NRaWsPNwmzKDwPPH3NvA+9Bvi/lPYrnWhbkR7NuPaAl2i5f7Eg8B9qiQDF2JUWlmAcFqprfj00gx7+JAVXf9oKj7i89B4bH/C1LW6ZU+ImeJafEbzhdbvyNW9VziFTSgP2VdxER99RrfwJLz+M5fDap3LWw71TqBxBd8p3t02qYN3DxnEZ4aw3skHV7RhA1uEbVXmhb/N7Vekq+pgQB/nL61P35bj8F6Gfu8+Z7AGlu/deKouEgKG5v0rcDeUqa+CFkI3vPYE+JlbSpenMkUc7AmX0vIxhDZStdTl32VYPdJcXDwHT8ANHQFDoiSdrwfQ4jOvXUEf7+GBF5UNhYqXgzTButcWKKS+Hh2kMYRE/mbTfs5KeRZlC/FI3rAd4F7Zx1vP2JueWnpopPxS1OhTOWFJW3YKd09qLRA/7iym+hlAk2q1UXOAARKl3U0a4LbqJGg6PaR0cTj3OFUlt8qMgDjGj+qGW+uaN/WefwdBchJ6XnwHpP57iqz5TCOaBTIevuvQTICt8FQyymjdiBiQbDrkjYdlvsV+Mvd9Oo+IssqeyyGf42iSsQWJAPFXMHZsOfuHdNJ66KF5JOe1OghFQl6VgBrM87EHmbZBlTd7J7NEs7L0Go9TDRtGgN6XLGlxAI8oLvOXGzDs8RA9cB59p85TEbX1f+bNxblhbNyRJtUCzP2fcdRhzQdS4iqKAH7I0BlKzIQSlZMQINsivfhioqCx0yIkncSsOpWaXZ7wdzu6Uy+VUgw82JKB/of4Ao42J59ok35eh9/tCuqksKrUpk954uJSz8NMGwJSHATqorj/BWLNDlP2aSWQsyrnd/EHVqyaIgIFWEhU7DMCpxZM3k8cnoAc
 yftvXmwX
 z9NJXJyKeVTQK2mUY/E/ZzbxsKHKi5MOVaLJ8YIfEDjPcBTtOeHdVh5tIoFHxwK2l5V1wInnvWgz+lJsOLWoPzO2o1oVaALzIZpZ8zM8undCaHTTs0k4zsuMl30v4VN8NhhdNWbvtubQAXEour6JlXfFgxzYiAWKIwXeQapKaxCGh0gOTOr1oWeKwCH3rFh0+gj3ZJKyn9fPRquQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Cleanup an unnecessary local variable write in incompressible pages
handling, typos (s/zwap/zswap/) and outdated comments/documentations
about the zswap's red-black tree, which is replaced by xarray.

SeongJae Park (4):
  mm/zswap: remove unnecessary dlen writes for incompressible pages
  mm/zswap: fix typos: s/zwap/zswap/
  mm/zswap: s/red-black tree/xarray/
  Docs/admin-guide/mm/zswap: s/red-black tree/xarray/

 Documentation/admin-guide/mm/zswap.rst | 10 +++++-----
 mm/memcontrol.c                        |  2 +-
 mm/zswap.c                             |  7 +++----
 3 files changed, 9 insertions(+), 10 deletions(-)


base-commit: 2e943d9cc1fdd399a2f95d1c1d6b865d04bfa239
-- 
2.39.5

