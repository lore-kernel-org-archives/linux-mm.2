Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3B2DCD3427
	for <linux-mm@archiver.kernel.org>; Sat,  2 May 2026 02:05:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEDE86B0005; Fri,  1 May 2026 22:05:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9E986B008A; Fri,  1 May 2026 22:05:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB57B6B008C; Fri,  1 May 2026 22:05:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA0EE6B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 22:05:17 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 622A240496
	for <linux-mm@kvack.org>; Sat,  2 May 2026 02:05:17 +0000 (UTC)
X-FDA: 84720837474.11.27BBFA3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id EB07A20009
	for <linux-mm@kvack.org>; Sat,  2 May 2026 02:05:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=osX1ugss;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777687515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zJBT5j+j/CXmd0mbZvADP7wRjK+P+RIuYW6tGgk5u5M=;
	b=3FpDdRmzi8YL/xrie+dwAjSsjpI/nitzcyJ7S96HJ1zdUjjS5H5DRUhZxNRrweIs9xKmQb
	jWNm5MxAtbfBm30Np6eHTLq/3yfFFAgyizToFHh2bzAmy+lCNA5EU4J4lpvujdr0zYEOkw
	mLWXmfXAnkBWFey95r2wAN98ANag0t0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777687516; a=rsa-sha256;
	cv=none;
	b=Dxz9voG45SziAGIphG94CV44Oz3OyaStaVrohjsHl4DqbpMYrObW3Ah+0I0DQbqdeW3UTu
	pxhQWnDHCpOZv2Q+o8ZxAcHFWPrZBiftt/VlveDlf0mnBqBJ5ZItoePSZfwfB0FJ1qjBM4
	VbaewxmlYge9xDSexeaBC/Zb6ykOqNI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=osX1ugss;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4AE50600CB;
	Sat,  2 May 2026 02:05:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6190AC2BCB4;
	Sat,  2 May 2026 02:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777687515;
	bh=fB1OcL3ViFGZJkDKi9eqU2TPDeF3kgjENu7ZrO+s+Pw=;
	h=From:To:Cc:Subject:Date:From;
	b=osX1ugssVOVSVakmAnzjJ/AYdjcwM6kU+ht+by/Scg/ZCIvcCi7GH7XXWkpICn0CL
	 QJwcKW4i7QRz4bhrRZtB5Oy1xgjRvNIZGHem63fFTDXpigZFSBL8BgXkT7AcjZCP1u
	 Uljw/JXYvTleDEDeqAeduMkhRR1N7pAYTdBJxzsQMs3le++zQ0h+oIx9hYDpgkxlbm
	 AwCrVFtXzNas/mQzlpiiO3vZD5KM2l0/tqbKYKNGnhPK+t3J0rAQQwVobvovhJfTv6
	 qbrlflMp5PdnjfC1gZvu9YFXMqR/WrU76HlBo0U5U7mAC5fQJtWeo5EIJKGSnSXeG1
	 AS6pfezDKcVaQ==
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
	linux-mm@kvack.org
Subject: [PATCH 0/2] mm/damon/stat: add kdamond_pid parameter
Date: Fri,  1 May 2026 19:05:02 -0700
Message-ID: <20260502020505.80822-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: EB07A20009
X-Rspamd-Server: rspam04
X-Stat-Signature: xnxmqhycgywsgwqmx4ggsjx1ca3ypbdo
X-HE-Tag: 1777687515-929486
X-HE-Meta: U2FsdGVkX1/ae155sjsnL/X3zmZfqKlGqdxwXp86Rsge6X4nrdaOjR6uiUzKv3qm+9HCMIEhzCmeGZkH8v7jJVF5/eiMtMT3B2pL+szVVDDjG0skfTGuQIldId/Ol2sBknk8R7eUr7LRcur1yUDbdkQICrqCKN0B+eOVupIeI2OPeZMX1egmFL4qU2FvQZcfXyP3SWCpr0hcqnBquT/HmGTOlKE96hLfuzMaPGU/UvIWuvH9M26AFFJZ8Wajf9yvGoyg1xczSi8AEqvFvnVa02luoOeq1GYGV/kW0jFkklWpvcJW2zkNSn7uO2ZXJm4wsfd9nXt4EImFZR4H0F0sxIr3Z7EyEzS8etum8w981pF+wmjz4RLaXHRSCGvQNiKreZywJuDHvc5raRSi6d4hCiY/BIjEet3wRcxLG6G35L0EuwZvurTyICMGif512c3wKfhwce+GcvqlCBdwFTlADPNL9b2e6xfJF7faSVCl6Sc5/ZxHORd0PO7AAsq2ijxT96ExMZsj7Aqz8BLM+6Wp4h7EGygbCJjV9MVB5BwSkHlQPsJvlfDdFCzXLS7DO9pl72KTo3vrKR2wQPWjoqgM4MvA73TM9iK2qJmwWKMUMhIrkaHxxB20pGsabKMKNkQYfrk+IcZxMGBZDof+ZYg5F3yR4hei2MfKTeGRGSZ/Z/KhxFORl5IGbgtNqw+420qdRXMj2gpBsukjRF1vSOFUPnyxndoZGADhrAWo0iOvf+K0KewYh9gSnXlwYa2AT88Lw0O9WyRANIK141hOMTew+afYRtP+Ex/AjnnhEtpMczQUNnlo5k8MvsPt9dljJJIalWU+NvVg+Mju1T6X9+54zwcl/wN0xtm/yn01UZocc3FuvbG/MUT4FEAeRJElC2OsIBCNd325/hYRyB/+cZtUty1h4oyJT5pS54XZdR8FECCE8gXSfQDBDHeV3OKgCMjXl+cCrFhWzbuQPc31tMl
 cA16waCi
 vafnB+Nw8WepUbNUh1BfJPjFgYYnFq8PL9OXeTBm35zrT2oj/IioM5z/Ca9Le1e5ImfH3dvL3ekpDFmVPinrgwhNGervvq1XQDM1SwwBqXdRgTKEOsYOP/CCuA0YHkZuN+PExyoTgN9EAeax04pslEqpegDin3TtZ2vL5kjJE4lZ77sxhFwpND1pbpN+bah2duktkTn86gOwJT7u+r8jVLhzhyofbhD4qrITSZT5re8aynXByrRIoolLMTZhx1BiY6b2OCx/0DLl1zTe7hVBmsRMvWQ==
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

Changes from RFC v2.1
- v2.1: https://lore.kernel.org/20260430142013.80993-1-sj@kernel.org
- Add parameter description.
- Rebase to latest mm-new.
Changes from RFC v2
- v2: https://lore.kernel.org/20260425203309.108879-1-sj@kernel.org
- Rebase to latest mm-new.
Changes from RFC v1.2
- rfc v1.2: https://lore.kernel.org/20260416002149.87090-1-sj@kernel.org
- Detect and use fresh kdamond pid.
Changes from RFC v1.1
- rfc v1.1: https://lore.kernel.org/20260414235912.98174-1-sj@kernel.org
- Close the parentheses of error handling block.
Changes from RFC
- rfc: https://lore.kernel.org/20260414053742.90296-1-sj@kernel.org
- Fix damon_kdamond_pid() failure handling.

SeongJae Park (2):
  mm/damon/stat: add a parameter for reading kdamond pid
  Docs/admin-guide/mm/damon/stat: document kdamond_pid parameter

 Documentation/admin-guide/mm/damon/stat.rst |  7 ++++
 mm/damon/stat.c                             | 39 +++++++++++++++++++++
 2 files changed, 46 insertions(+)


base-commit: c9d6cc2ef4bef0a86002460ee8c39a1c76b3f1f7
-- 
2.47.3

