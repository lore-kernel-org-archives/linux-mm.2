Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD311F99C70
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 01:44:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFA2D6B0169; Fri, 17 Apr 2026 21:44:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B82776B016A; Fri, 17 Apr 2026 21:44:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A70FD6B016C; Fri, 17 Apr 2026 21:44:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9229D6B0169
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 21:44:46 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2E78F8B5CA
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 01:44:46 +0000 (UTC)
X-FDA: 84669982572.18.ACA04FF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9CF5F100013
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 01:44:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T0ytZ3Zs;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776476684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=O06esOF1oWbGQP8SLoU5ZnwJh/4OJ+iRbmcd13WFJ+k=;
	b=Dhf8JJU4d2jJJO+T3sJ2PrkneFxhGmZOSNZT4zy6wRnglrdUxzql9PIuyKy56b2L3nPI+O
	g3iZ+vDCLL029+eu5pTrmtqP9DH7oQn+mi7esXr2eYTyE9bRsnriEhbVzy0VI9ZSlTSfXa
	fnspLCVEozDtcXT+z+qgjhdd8kRaUXI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T0ytZ3Zs;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776476684; a=rsa-sha256;
	cv=none;
	b=LXKo/mXk8IAWHMDfHvvw++Gd7DYYeJcUuiph5gnFty6HCyrnlKjCBQ9NiMbo+odJtJMW75
	ufqoOLZi8Uu32NI0/hG+Ss/wX9RJroJPNa862dIZwLSE//9/mrEOwdXDGb3o3sHfXkRcLd
	1aQLmiztWuQIdGqhF7G+X8yjdLmmY7w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C61C460138;
	Sat, 18 Apr 2026 01:44:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE80C19425;
	Sat, 18 Apr 2026 01:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776476683;
	bh=ZbbWApNXMeEozcLH4rPeqK//jQK96YdSuckBUrb5QFw=;
	h=From:To:Cc:Subject:Date:From;
	b=T0ytZ3ZslrkRINMmVTjZP3x3uWYfyOCtGOhSR3gxcCP1iYijMUErd8DkDZK+ofgFV
	 n7uuqBsI1XrwLi1HaXO89yglvI78Z0InMNZAb91NB8ap+FnDh3sJlbe2I1rpfqqa3k
	 Fi3BLOFn9dl6Bsu3fH2qmJ3945aUexzLW8zPV6WSiJRIk+oGAxuksT2vFZ7TlKp5cy
	 KJQhhKPNVhpLaz7wNkCTpA5LG/b2sf6KkhGRLdvyOijnaUQ1euHxdowlumzhiEasb2
	 143BpscDRWrbKHv0OtKmlK9KBmjt5n17oL9PAFwbrf67PDPI0DOtZuKLy/HFjxmgOy
	 5HZC+YhPE/ZJw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 19 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 0/3] mm/damon/modules: detect and use fresh status
Date: Fri, 17 Apr 2026 18:44:34 -0700
Message-ID: <20260418014439.6353-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: s4twanh4tmc5mbtujqz45cs7zz66i9rb
X-Rspamd-Queue-Id: 9CF5F100013
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776476684-990671
X-HE-Meta: U2FsdGVkX1+601YSAUH8i2BpWZjmCHY9TBUChwscluf34mLQ3f3Fn69XGcu9/im9OfUQ93AN8REkmj2KYeFx392e5tDSV/E+E4U64sm6F8dDAW4b6vf4TbC3uwJY60vd5nrJ2I3eI6KJP8xIhKXPFtYSvwWYmu6ICt231/kKc0ULeWqg4Nwu1z21wfT68My8+EzD3cbGt1VWZ151AC7jg2TA7WdAWKdHdKebYTH3cF1uxFCUTaU5WKdo8IYixDkLG2vX1yjJBq92Ib+6haoyC3Q9BZL79NIwzKMBD10Ysi6pW4SSSwg1c85WV2FQlRJ2GzYRBZosAnpwjhc0mybZWFv9h+edgxbA7z1rE1MqHBG7ZTnt12d+YJSlYkisr8gw/Q3Y0O1B8UsMuKvCvOtb27TOesAogbiwe1or3Nt0w/GnfQe5yLunpploa7b35OTLfbGJHLH+GHrBtrVGh6Y1ytyPjCf8ew68gxaVliZF83XmCO3wnXV0SgbUI2l7ufar6Fb5CsvW/vcBU2opmkJgxohUvnppsdXIRUIGo7bgY7mZ3jPZT1tLq4Q85NIDn11VglaEurv6RFsr/XhpW0i4Q5gGYsLAo2XucPaGhiXtKDlnSOpoyEbxBc4q1U89Y1fsLl1FaZ/YJ2DkUIgVQ6QV6OuAmCGRL0obATWXr6lwOI1OqqCJj6qZuXScd0oiSAEiUXuG0fLMQE3I1JtQZ2QopGfziDeV0ElYhAOMxNJOoRvXetisVcJ1D4GaEBBXKeuLk8HM7on1MBnjqnXSPE0gxRle+7/CblKDarmzIPg0H11IbeJXNGi4jP4i7XSFPY9X3z3N8W0aME56OoYk5Zx3pXjA9CDCcH8znIulWvIbbPEzSJTFgx1f/UMXulJ1OS7Cg6/gegpeneEk5mrF3IQDgKcFWT2gDQRb3R/Spkl9fpUj+jtg8SNzH+AXU6em9BjwSOI8otwmdoX9fJ8kd73
 f27BcHM3
 PcPuYMZdZM+4bLW7GiKNKTnVxe9NhPzOfDzTGSAzwIyE7fy/jQ6HvRpL5Ung55TCCTUm6D8LOB9kkH+bQS+qQA8rXb5rxkaFX9+fnc8IqOAoZWbQn/wFTtmHwzxTBcbJo6wWrkU3jmQe0ws79o2qIl/TGH0//Act1SqCrx5PStL8CJWu+vexOib91Ipprc0GW83biF0E6xBqi/hiidvy0uS2lFB1U8rObW4CimNt1SN5qlYSgAeQ+iulXiGuzwEQxlqkA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON modules including DAMON_RECLAIM, DAMON_LRU_SORT and DAMON_STAT
commonly expose the kdamond running status via their parameters.  Under
certain scenarios including wrong user inputs and memory allocation
failures, those parameter values can be stale.  It can confuse users.
For DAMON_RECLAIM and DAMON_LRU_SORT, it even makes the kdamond unable
to be restarted before the system reboot.

The problem comes from the fact that there are multiple events for the
status changes and it is difficult to follow up all the scenarios.  Fix
the issue by detecting and using the status on demand, instead of using
a cached status that is difficult to be updated.

Patches 1-3 fix the bugs in DAMON_RECLAIM, DAMON_LRU_SORT and DAMON_STAT
in the order.

Changes from v2
- v2: https://lore.kernel.org/20260413185249.5921-1-aethernet65535@gmail.com
- Add RFC tag back, for sashiko review.
- Detect and use fresh status instead of trying to catch up all scenarios.
- Change Liew from the responsible author to a credit-deserved co-developer.
- Move authorship responsibility to SJ.
- Add DAMON_STAT fix.
  - RFC of the fix was posted separately
    (https://lore.kernel.org/20260416143857.76146-1-sj@kernel.org), and
    only commit message wordsmithing is added in this version.
Changes from RFC
- rfc: https://lore.kernel.org/20260330164347.12772-1-aethernet65535@gmail.com
- Remove RFC tag.
- Remove 'damon_thread_status' structure and damon_update_thread_status()
  (SJ pointed out this was too much extension of core API for a problem
  that can be fixed more simply).
- Add a fallback in damon_{lru_sort, reclaim}_turn() 'N' path. If
  damon_stop() fails but kdamond is not running, forcefully reset the
  parameters.
- Reset 'enabled' and 'kdamond_pid' when damon_commit_ctx() fails in
  damon_{lru_sort, reclaim}_apply_parameters() (kdamond will terminate
  eventually in this case).

SeongJae Park (3):
  mm/damon/reclaim: detect and use fresh enabled and kdamond_pid values
  mm/damon/lru_sort: detect and use fresh enabled and kdamond_pid values
  mm/damon/stat: detect and use fresh enabled value

 mm/damon/lru_sort.c | 63 ++++++++++++++++++++++++++++++---------------
 mm/damon/reclaim.c  | 63 ++++++++++++++++++++++++++++++---------------
 mm/damon/stat.c     | 30 ++++++++++++++-------
 3 files changed, 104 insertions(+), 52 deletions(-)


base-commit: 045e2ae4d82f0ee748f2f72fe64696c7da155b1c
-- 
2.47.3

