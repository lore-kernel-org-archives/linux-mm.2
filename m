Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35397CD5BB1
	for <linux-mm@archiver.kernel.org>; Sun, 24 May 2026 18:43:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EBF46B0092; Sun, 24 May 2026 14:43:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49CFE6B0095; Sun, 24 May 2026 14:43:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D9A06B0096; Sun, 24 May 2026 14:43:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2BDF06B0092
	for <linux-mm@kvack.org>; Sun, 24 May 2026 14:43:24 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CD7401C0BBA
	for <linux-mm@kvack.org>; Sun, 24 May 2026 18:43:23 +0000 (UTC)
X-FDA: 84803186286.03.F62D16E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 520D91C0008
	for <linux-mm@kvack.org>; Sun, 24 May 2026 18:43:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="S43XY/lQ";
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779648202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CZelRHyy4+24hs+0slQHmUCKybroVh9ZqZvNGlf5w68=;
	b=GYADh3hvN74/omGpXzpubgY6vDa2lS8YxX9/ugHC4HiJZ4ucDoh51SEgTzBRHrVGnc/e+Q
	Vhs5d50Uu1fq9y88BmzsJpwriSYcSemiiWLParZfBYKT3iWnY6yYbWnm9+9Z+FV65P1KzV
	vy+JtZKCknJI4pikcIBXMxstP+VnMI4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779648202; a=rsa-sha256;
	cv=none;
	b=JxBsHFrAbz1e4CIlltCB5qTqqUlJNwBJDwNosIGiVIm/6qrotiEYTyga1PlszOhkucFhcA
	Psmw7900x2S4HYc3AuHvlOfrWChwUdX6Ed0Y97WPszoaCa5E8BrYExnhVL6fEFvI3Aqh85
	L7nKab/8YYNxq+wQAeqGdgTtbX9eKNI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="S43XY/lQ";
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ABCDF601E3;
	Sun, 24 May 2026 18:43:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955FD1F000E9;
	Sun, 24 May 2026 18:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779648201;
	bh=CZelRHyy4+24hs+0slQHmUCKybroVh9ZqZvNGlf5w68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S43XY/lQE9+p1arX6jzhG/EZWJjAN7YzynR4seFV81jRUHOZm++U7NybpsgkxKYA1
	 lXXPkhhLB5DOvGxjcpn2HU0r5lWLIN+U4XQ8hdwdBVFCx0PY7dMsd4x4cpKFWRdSyl
	 GkCaYiPSSjBl0h0B/XUtCbAoOTrnxun10TXW79T+vF16ujP3FPth+K3R6wy74slcmP
	 soDLYz1FHAJfIYAC1Tp8lm3NRB/ATStkzma7H+zepqpx65TwjNqka46/b3SbWtlGnc
	 m/zkHD8vhxE/+9bkwSXulyCgrGzRWGyDR1cEo0LIDkrVdRl4216ucqh4luGFLDG3mh
	 r5zyM+VYHODXg==
From: SeongJae Park <sj@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	mattsva.kernel@gmail.com,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs/mm: fix spelling mistakes in memory management docs
Date: Sun, 24 May 2026 11:43:13 -0700
Message-ID: <20260524184313.1991-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260524133701.3470-1-lance.yang@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 520D91C0008
X-Stat-Signature: 3eri3nszz16cxqsmkcq1n8kipux8g4q1
X-Rspamd-Server: rspam06
X-HE-Tag: 1779648202-944665
X-HE-Meta: U2FsdGVkX1//jl85wlYZre2x7FAN64bNtZFUVlvAZaQQxbLJrHIA9LJvs1oLQ6DesKxL1Mcur5/ySS1qiwyRe5KXDiqp1eDYmUVM8K8Acir4bdhOUYkmJa6lcX8BQKJ60g3hhbOPHgSTkShJVwe/ii9CgkwaBmt6Q28FcsHmuugDc8aI7+9z3lvsgxRPKB78UePHCQxJi/JmYULHwTb72EoXzxbuttLM8OWKEznNpztbuHwkwxnXQCpqIwdJFZ+PCz/DhMpKRRpaqoV7JgDcuODtrB9SuPvAqB6nWNiuKvZO9+HBpzGbHPxW9ErkL62ZLv2v2vL0wE/UnDcUAEOWgj2wQreIOTt09jm76mrV2oSe4gxV/h05arH9RZpB/nbMAFi/+kZhLyx4HM9G3x0lNhLlNnoR4QKBh5D0J0wTHC0lmnsTzxZNzuQdDL0e+u5dk2B+Z2RacCVUgEuRUss6/X1b/oMJcjW0WSCdQ7HA+0213GWr0rNJmxLm8Vozmp4UIozOeM6NULhf1W0NvU6ZD/6zKFiNvHnVpwn+44zia5PFD9QXtINIH3OcUaf/tpkbclA3ieIKZxR0Sr81CVi4+FnBplMC+tWBiRY+c96WcKA4ABuMnP4HMKxpSHSh8yEOJLgQhf8q/ab2rX5SuFTCABnX2TICu+IgMcNOO32HYMfcN2Hk+xlDWxQYoG5anIQ6cMFKOw457Juo8AwgCBS6MeOjLh772cINJX4nBrY8rMgC+SLAtr+2FH2u1SSSSOUkpw1w+m8proZGzwJJt4d+poJK5JoTrOTjAHQdWj1iyfwfjTJ3rv0FfBeJPxSPG/Re7qJyMWgQ/pad99vXu/soQHBz/tbZNeeTN2wvzNJcLbbQgccz6LZB/hai7RfvbKSSxZ5Vx9UqPafOKg0BIEZthUjcc5XT6OnDb7XrZo4Jmv38dei05vPCrjTZzOoWt43brGDsPDmQNNhy1ayEnSs
 JNoD6J5m
 yQSVndxgDebScLd2UHzWLrU57GzlIq+l0qChisp8yo0QL1w2dAar74f6wJudcmcW9aGHSo3Ewgl8tYGaKdYg/Ifh7EM1g7PZ82fP7dIE2g+/ebb5GYhTdQBw/Paeg0uLrMIDM/19gOQn/tf+D16QzXXFZqLlt1jByQnpcWzU5f4guT8dI+cKbaKr7f+NmMhu3snKi/DYaINR8XtIDb3WKDWL653lLuT+cPxSiG0El6P7xj0zIWWp9fNLj3SezwHf+XuKl6zDQA/TTqXlDubeEwexukC7i8BaAYh//NHfzIoCZU7tuEbyutEDTuj0DRwrlWocfTOlE0Txthzo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 24 May 2026 21:37:01 +0800 Lance Yang <lance.yang@linux.dev> wrote:

> Hi,
> 
> On Sun, May 24, 2026 at 02:49:21PM +0200, mattsva wrote:
> >Signed-off-by: mattsva <mattsva.kernel@gmail.com>
> 
> Missing changelog ... and Signed-off-by should use your real identity,
> not a handle :)
> 
> checkpatch.pl is your friend, please run it next time :)
> 
> >---
> > Documentation/admin-guide/mm/damon/lru_sort.rst | 2 +-
> > Documentation/admin-guide/mm/damon/reclaim.rst  | 2 +-
> > Documentation/admin-guide/mm/transhuge.rst      | 2 +-
> > 3 files changed, 3 insertions(+), 3 deletions(-)
> >
> >diff --git a/Documentation/admin-guide/mm/damon/lru_sort.rst b/Documentation/admin-guide/mm/damon/lru_sort.rst
> >index 14cc6b2db897..25e2f042a383 100644
> >--- a/Documentation/admin-guide/mm/damon/lru_sort.rst
> >+++ b/Documentation/admin-guide/mm/damon/lru_sort.rst
> >@@ -75,7 +75,7 @@ Make DAMON_LRU_SORT reads the input parameters again, except ``enabled``.
> > 
> > Input parameters that updated while DAMON_LRU_SORT is running are not applied
> > by default.  Once this parameter is set as ``Y``, DAMON_LRU_SORT reads values
> >-of parametrs except ``enabled`` again.  Once the re-reading is done, this
> >+of parameters except ``enabled`` again.  Once the re-reading is done, this
> > parameter is set as ``N``.  If invalid parameters are found while the
> > re-reading, DAMON_LRU_SORT will be disabled.
> > 
> >diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
> >index d7a0225b4950..01a34c215b66 100644
> >--- a/Documentation/admin-guide/mm/damon/reclaim.rst
> >+++ b/Documentation/admin-guide/mm/damon/reclaim.rst
> >@@ -67,7 +67,7 @@ Make DAMON_RECLAIM reads the input parameters again, except ``enabled``.
> > 
> > Input parameters that updated while DAMON_RECLAIM is running are not applied
> > by default.  Once this parameter is set as ``Y``, DAMON_RECLAIM reads values
> >-of parametrs except ``enabled`` again.  Once the re-reading is done, this
> >+of parameters except ``enabled`` again.  Once the re-reading is done, this
> > parameter is set as ``N``.  If invalid parameters are found while the
> > re-reading, DAMON_RECLAIM will be disabled.
> 
> Already fixed in mm-new:
> 
> https://lore.kernel.org/20260426231619.107231-3-sj@kernel.org

Thank you for checking this, Lance!

I also double confirm the typos in DAMON docs are already fixed in mm.git.

> 
> >diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
> >index 5fbc3d89bb07..5d08a2a1c15f 100644
> >--- a/Documentation/admin-guide/mm/transhuge.rst
> >+++ b/Documentation/admin-guide/mm/transhuge.rst
> >@@ -210,7 +210,7 @@ PMD-mappable transparent hugepage::
> > 	cat /sys/kernel/mm/transparent_hugepage/hpage_pmd_size
> > 
> > All THPs at fault and collapse time will be added to _deferred_list,
> >-and will therefore be split under memory presure if they are considered
> >+and will therefore be split under memory pressure if they are considered
> 
> This one as well:
> 
> https://lore.kernel.org/20260520051751.74396-1-leon.hwang@linux.dev

I also double checked this.  Lance is correct.

> 
> > "underused". A THP is underused if the number of zero-filled pages in
> > the THP is above max_ptes_none (see below). It is possible to disable
> > this behaviour by writing 0 to shrink_underused, and enable it by writing
> >-- 
> 
> So this patch is stale now: all three hunks are already covered in
> mm-new.

I agree to Lance.


Thanks,
SJ

[...]

