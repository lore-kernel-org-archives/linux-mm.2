Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECF8BFCB619
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 16:06:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AC646B0089; Fri,  6 Mar 2026 11:06:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FAB36B009E; Fri,  6 Mar 2026 11:06:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A1AB6B0093; Fri,  6 Mar 2026 11:06:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 275746B0089
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:06:28 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C0DD28BAA6
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:06:27 +0000 (UTC)
X-FDA: 84516115614.21.A7B3BF4
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1512F40007
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:06:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=H2V38ufF;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf12.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772813186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pGDQ9Ydxn2jbdNgrbPTdlWBfprirVVZp7HKCQ8LPMyE=;
	b=I/yMa6EzULbUMh0+eqKHSjrLk3yUSk9e/I0SUQrcLTUkLQEBy/BAwqD9+BOSyFtA7g9dnK
	NX88Fy33iyKl0Gpny/OM7gL51SHb2OIzjCtzVLqD+8gG/66iNI14ORyWLAuLQ2EHLzeOUQ
	gK6RhMoJIjiz+C9MtaNN1GH0yjYhVfg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=H2V38ufF;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf12.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772813186; a=rsa-sha256;
	cv=none;
	b=j6RHOjo94NCw7JhTsiOtYWKxQpbdK8mWnmG8GXY4RwD4stRKAc25yVPMrvGgrouyAlf7YW
	P7Yt2xCx1ipH5DMgndDh03M8YtK1ZK8TllPC6EEYBJuk8+QBcVQudCJU3zHnUtJqj87W6M
	eXJe0rCLMEIIt2KSyBA+78BiW+Ey7OU=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 2958CB3439;
	Fri, 06 Mar 2026 16:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772813184;
	bh=pGDQ9Ydxn2jbdNgrbPTdlWBfprirVVZp7HKCQ8LPMyE=;
	h=From:To:Cc:Subject:Date;
	b=H2V38ufFgO3maqA5ljthXDrLz6D6nZPRqy/jTmgXGUvxKW7JhUBznsHXj2DCJd8qs
	 H1zPSvOXgdtniNKgZN8iRubFjD5tbtmDAFT5EqFlziUv1hmW4wy0SaUMPH/ElWrAzh
	 0H3+9OewstRjdr3rMGOpg+vkOoCX9eISw97tMBSM=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 0/8] mm: introduce zone lock guards
Date: Fri,  6 Mar 2026 16:05:34 +0000
Message-ID: <cover.1772811429.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1512F40007
X-Stat-Signature: regbbcauwg6p6gqfcjishgapfancotn7
X-Rspam-User: 
X-HE-Tag: 1772813185-618760
X-HE-Meta: U2FsdGVkX18vGKbCZB/3GAleUZMefjfRd0bRjMywV9VsVcvx4FqyXt2s/D+h7Wf23RtRfe8W4R8U9S3ru+8Pe1D6gTD6fQUug9ltikM6AKTErOSWkgbmxbrlqvgOyF/RMLEeNGDDBWF2dfWeo0aZZsafdw0CdKuwwz9/hUXmRPSZEXs+UAGj5NCQyG7AqGwScDM0Sp4B6PJHOwdngJEWPYzRQDnQj9Ft0qmm2B7NbuDNEvWRsepGV4KtrySCN890fDzSVQEbnW32Hz2FWbJ0iXnIqOfqC2+VZnLQDMqWnpjVfKb6iStHgA+OKV0xHJ9dQp3GQG8IuAGxVYpZGqQT5mgT4MWU32BDTSLRuWfXqIMjoiqRU2kaD6zcxpPsBVfvDgvZtYRMnOZflNJ3I/LiVo6eNC739//NTpaIdk9AjNoffwqW0YBqfT+tAV2AmQzdhwULiuFEnFbkabVrwpNmgm8RdgEAj2ae0sthBqsmVVNKy1hF1DMNI+wOtyYTbz8q0nnIKQOQJ91Y1n0D0IBbJEmgtaZ0PeyQOXeI5gdA0oQ3aS7hGc+CE/8yoTVWPvu2JvP9Acx1AmguXUUggfaZS5OczSQGdYnseWaFbaszZcAGoBLHknR+2EvxjOu28QykWag+e+7LTnFYu6mbdlmcxtLk//Fa143m1Xlt17So3LDLdfQBiQMUv/DntJZ9u4OPXgApF2uw/h5w+oLohR/tlU/PT0wGYuA3CV2ikcdkXhXM4Q2jc1EI3Cbuir3FODg9VDpr4VQ2835Bnz2PCilLDGxIpyBEIQctqpAzGSH4+sLkEL8jJLj/m1l6xThxZmg9P89laPVdZwLGGNekEgizu14LPo92xbyGg7Rrs4g9Ri2bHJIBw/zZgOx67VWRHZx8gcm5O8DcIrFgaoa5hbqFd8ZyXHHmlue0IqWwCeiKX0ih8Gsw6EW1jFm+wHfnxQ6bbrlD/2VTwby4E6mZyjn
 +9KhcqCw
 jrtXqGPdOK6p5EWND81zngqHrrL3BVo8h0ABO+yy9/4crMT16f3XbwfgvkF1GteMLjV2KsJhmgF+l2t99GqlCi/AGLIB4CEcsi8vl2qghQpx1h6HGA0r47UO4l7FV55dLslSH1W9etPQP25epIV/XhOYdNDEvGNV/lydmPK/TksrZzM8DSkMBVBVm62QQnMdLUjyb/pF95BURqYVrcZFwwKMZBi661NdvVHg22y+wSA8QihFlBLbZpJRHGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series defines DEFINE_LOCK_GUARD_1 for zone_lock_irqsave and uses
it across several mm functions to replace explicit lock/unlock patterns
with automatic scope-based cleanup.

This simplifies the control flow by removing 'flags' variables, goto
labels, and redundant unlock calls.

Patches are ordered by decreasing value. The first six patches simplify
the control flow by removing gotos, multiple unlock paths, or 'ret'
variables. The last two are simpler lock/unlock pair conversions that
only remove 'flags' and can be dropped if considered unnecessary churn.

Based on mm-new.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>

Dmitry Ilvokhin (8):
  mm: use zone lock guard in reserve_highatomic_pageblock()
  mm: use zone lock guard in unset_migratetype_isolate()
  mm: use zone lock guard in unreserve_highatomic_pageblock()
  mm: use zone lock guard in set_migratetype_isolate()
  mm: use zone lock guard in take_page_off_buddy()
  mm: use zone lock guard in put_page_back_buddy()
  mm: use zone lock guard in free_pcppages_bulk()
  mm: use zone lock guard in __offline_isolated_pages()

 include/linux/mmzone_lock.h |  9 +++++
 mm/page_alloc.c             | 50 +++++++++------------------
 mm/page_isolation.c         | 67 ++++++++++++++++---------------------
 3 files changed, 53 insertions(+), 73 deletions(-)

-- 
2.47.3


