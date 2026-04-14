Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D00FDF34C61
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 04:50:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F2EB6B008A; Tue, 14 Apr 2026 00:50:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CA186B0092; Tue, 14 Apr 2026 00:50:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2073E6B0095; Tue, 14 Apr 2026 00:50:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 14A0A6B008A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 00:50:16 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ACC6A1B7DC9
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:50:15 +0000 (UTC)
X-FDA: 84655934790.15.CB3D6C4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 303F1180005
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:50:14 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ig2EsDVr;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776142214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JtoQZ9WVVxNM9h8vf/7WucxMZUTpjCWqCDF1wPzSZcM=;
	b=2rytvy5y0Y5ePRL5B6Ylhhu2eFaidWPerFNM6bbinCYT49e6FSgvhK1ZOlUWvuRT1MtHP6
	1BMFe+yagsyuNyI1z1wT0YY0cPOKDNQxeRN11EGlUGm3of+Ue1ArIb9cISQKDBYlvI/wrb
	uNDmp8iI0OFA6hZlzHAfB/qS0AkYgx8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ig2EsDVr;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776142214; a=rsa-sha256;
	cv=none;
	b=gboR2n39cu8aKxRX5IM4qUnXqklFVzkPtdHNxYA7KNfGr2CPZ5wdIikjuQeLZPDOvdw/61
	woFiI21qR363akX3CT9cu/sN37401BveE2iQ+y8JNn/ZpcdAHL4T50zdlcHfpjLiBOGa1R
	qpP+VAMbGRwzp/2Ikp1onGw2FtZehYc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4280760128;
	Tue, 14 Apr 2026 04:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DEF5C19425;
	Tue, 14 Apr 2026 04:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776142213;
	bh=5iCWCEKDDPqCsu8fPNYfYCrKYrkHznMpVFlO5/hTiEM=;
	h=From:To:Cc:Subject:Date:From;
	b=ig2EsDVrV8+izTRy5sFOD53mkrEuyIkC8qHm83mIPXjSfpIzzy8jKzPPxbsQsYCAD
	 CZtZkQMHgW2nHHW/G7Bq1HvWQ7gbrLdTc3cEbOB8VLqo1dAxOfLet2EFFaP9S539WM
	 DQjIBHwAl8EhKQ6sXwKluZzovn8V6CXaY1xgNhkUgKSrT2zLdOhzCvYm1KyQRjngOC
	 FTWOsm/S4FtXx9wjItiZVbRGLHzciK6It931s/BuyhBi20ec92xzKfPYd5A06wKyH5
	 s+cucEE5zQP51jJibAa9mtUNUZyL/LsXWnU3BxhgeQ49nPytIVAxikoNwwAlQLGBNp
	 ROh6jkeuTjKFQ==
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
Subject: [RFC PATCH 0/2] mm/damon/stat: add kdamond_pid parameter
Date: Mon, 13 Apr 2026 21:49:58 -0700
Message-ID: <20260414045002.88110-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: hdaqkrr5deby4615zdr9oqbi1qzzpdgm
X-Rspamd-Queue-Id: 303F1180005
X-Rspamd-Server: rspam09
X-HE-Tag: 1776142214-25381
X-HE-Meta: U2FsdGVkX189tID8ESK9GKae1MjxcOi2Pr4k8OSoZy8L0XPU+AkMA71FkmjIAkV6FsTv23XlvGncfi6U1pzqqxXwz1e2CHdnu58jvuCsV5uXoX1epInkuMsHs8FqiPck38RPcS/GDzik3T4W5Qg2B34wGXtFhkb9vxrh4zkuQrDLVwEUj+vO7+cojyoZyO1sE6CY8Cm14vwWkACUEXImMY6Sy6F7IK2SHS8ZuU1cbGWHUz1Je/jZOJROji+QRaUpqIeBc3lXLFzxhyGS5Xr2q98yrrpyF+taykrt1UfjQ/ZizkFZkFl+OVP2blcWIpimQmBdI2RxqC60YeNrhVJYhQxbfrkPZNYTbKCQRn86EbmG5Bg/ZzkHKCZ87OyG4nHGrHAQjA5KiY/b6/NkFsFBTeB1ONZXqhCvrCcHKtO9rTD5D5sCKpMK8YDM+WLRhT4O4mX3FVnRYDYkvLPA21LGD0aKRFv7vi10nsenVKtxTbOKGyOWtTGin0mOYTnraMvKRoWt1hJSD769mjJM63uyTTD28Z4vFuHia7lpO4AbMGBf7mj7WPxEgPQwlZjkqwu+kp2H8akwfpq6h592/YKggXF0a0PLoHTDzeE7uM8YZHbpVRR6DiJ7B8NxYEXLs37PZ1PA717YS1ukIb5GVmQlnPnPk3Q4BfyPWbcuA3fmbF+yEDCici/2zocLGq+sA0VihRSNEyqezYIIBUnjfqadcKvrd0vQg7mdKsDITn+YAzkqgcFZmzMAWooOwaEAwyLTt+U7jffheKg715AzIf2kr88f/MdqPghxxgiD+J0MVdr84cA+AfnMUQxQTMbGCLVpSOuzWwZSBnQPktQPhjeA3UgW8O5ZONp6IwJ7G0l/sgmQYNEQetXG/orbmnjmVsAazxLuqY1HYsUidD18ZokptD/zizgKBdrCEptwsjeL5mEaZneNdeLdnV3i/OrIcPIy39EJSF59RnXGgjK5aOJ
 F8w1iKkT
 mhGgReEz/aytaTr/NobIMOK64Ej65OEvOdfMxllIoL3x23zgCkroiKOFn/Zvu0Speo7gfVpgxYjla86YYPO4/pklH6tZEx/3EKWt/SIpvdtirLC1gFx+m/OrhGJ3vCxEDUEtdCAcsTxzxW98Ntk5l6zu5LLyyGyfPNspIIdkZ3cy+pmRyOcKy66QT5nQPlf/9n/ul0AGhU0ytvJjrND+m/69YKmY7HdBYM0fVl4myLPYsuM+fjyhcsx+XSDOGlcFbn+P8
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

SeongJae Park (2):
  mm/damon/stat: add a parameter for reading kdamond pid
  Docs/admin-guide/mm/damon/stat: document kdamond_pid parameter

 Documentation/admin-guide/mm/damon/stat.rst |  7 +++++++
 mm/damon/stat.c                             | 13 +++++++++++++
 2 files changed, 20 insertions(+)


base-commit: 5262d0a487d50faeefbca2e4ebbdfbed3f69426e
-- 
2.47.3

