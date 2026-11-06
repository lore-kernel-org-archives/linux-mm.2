Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB581606A332
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 12:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=Ulq2Gtno
Received: by kanga.kvack.org (Postfix)
	id 19FFC6B05B3; Fri,  6 Nov 2026 07:28:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1775A6B05B4; Fri,  6 Nov 2026 07:28:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F34896B05B7; Fri,  6 Nov 2026 07:28:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF5956B05B3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:28:01 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 46DDE1C4863
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:28:01 +0000 (UTC)
X-FDA: 85404621162.21.208D997
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf26.hostedemail.com (Postfix) with ESMTP id 68D21140003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:27:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Ulq2Gtno;
	spf=pass (imf26.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793968079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=NwiypONsoLZzkdBGuzeZ3yGbT8VUdMblEVHsZrbIo4U=;
	b=pSGxZn92D4mr2ePzrC4UnAO1tUQLJT0hoAiSRP0U+pJwh+6sQ8Mho9CbB2gSzlvanJlY+8
	wxewL0VscEjt0zWGOc5wCiqyBRBIxmPWWzE/8jt4P9c+HXM4k70q/Vs6mJ+dHtuWJ2wG2c
	OIPfeWlqU9Sv1tkCEwyKVSfK1EBtLuU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793968079;
	b=MlJ7GVTGF5ZWa8T2EWZ+7QOOof36wRBiInbgZVpfT3UnHHYd1in8LkZx/pl6uqYFYLYn5L
	ZWVTLer4WwLrXxrHZBb4aGrL7+z3FBVOzVQoVvw7mnjexvNYfevKPvBEusYUckrxMb9J2p
	bHFlctd+j9ClKkC/mlMg1mluG8s1KlU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Ulq2Gtno;
	spf=pass (imf26.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=NwiypONsoLZzkdBGuzeZ3yGbT8VUdMblEVHsZrbIo4U=; b=Ulq2Gtno2cozebVUNoQKeEA1oJ
	FKFj1scdcKVIIlbtFUj1G4qq76gHRSzxr3SXyBPYxI+YwqTJyygfee3hGIHAfly/8mmU7zdF8C6/Z
	VH6cR+UzBGI6eUamT8/llFce39TGw/5CYwU1g3MgtYmd9hars+tepDghiPy1Wp5r1APzyb/lzZdDH
	RFSwrQKkUHh7n0YzLIvbo/99Z9Pm+ji7oyw2rtH/l2Rc2L1XWQ4mvUpW6fnxFQxgW4jc0XgEWyU59
	ZQ46SilyLGloE9eRv5d1YMIb4Gt9rQBO6VzhCZO5kcXSfe8XC7SDlTPt3LZAsSBU92xb/1RqptETP
	FiUMgchA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xPJ2c-009HTh-2h;
	Fri, 06 Nov 2026 12:27:35 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH 0/4] writeback: make slow writeback report more actionable
Date: Fri, 06 Nov 2026 04:26:30 -0800
Message-Id: <20261106-writeback_stall_report-v1-0-bf0c3b9023a5@debian.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHvH7WoC/x3MUQqDMBAFwKss79tAIhoxVyklRLttl4rKJqgg3
 l3oHGBOZFbhjEAnlDfJsswI5CrC+E3zh428EAi1rb1ztjW7SuEhjb+YS5qmqLwuWozrbNfa5Pu
 +8agIq/Jbjn/8eF7XDdljRqtoAAAA
X-Change-ID: 20261105-writeback_stall_report-170750a69946
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Julian Sun <sunjunchao@bytedance.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, cgroups@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com, 
 stable@vger.kernel.org
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=3335; i=leitao@debian.org;
 h=from:subject:message-id; bh=1HmsM4AmOu1Z2b61jfdJLukN4nebCK9JA4xCaLqawJk=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBq7cexdV0P/wi9k7Ii4huksYbn7v1NjChk3inU1
 3b4BgEFIAKJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCau3HsQAKCRA1o5Of/Hh3
 bZbqD/sG6F4YNxE6zVSdVXQRyXNr0ImaQGVClKuo+AjvsLcnbyE6d46B80pR6vPYgU61oD3KBJ0
 MpNeJyj8gh3G2sJqdxVKwEW56gvY17zTbfLQLmip3IEiBidfe77rvM5CYrizlowLDcaaXAMq8o+
 ToI9m6tjlDvMoX/FZx02QUCLou1sMMF78B6FZIc8C0e+klHmme/+fPotUvHsbBm2VwuEtc9bbAa
 nT9RphAsfrzDTwvlsfIAfcJhknM9a5vkl9+Fn3jqX70trWZcAawP8ovMBUXZnwSq2o1ktcSHX98
 Q/Osb8goyIvEp5LJq02/GoEnoRcp6USB2SK5krK26BOu2xiF6HBEO45IlCc7v6T4gEZor0OJ54K
 3SSzUkgKuaIv4D2xpY2cEADO5Hi9G2NM+65ndmsbjjQQmApWYew+SlLIeVzKxFnLl+E95j+H0xZ
 oWIO2yqIqN5NCSnt7bltva5ePrIAJ5RWkM8IcavueMjck6V0EdW7YLm/0cdYvDY/Cy4+SAu2s15
 ycD0FaY2RGHcPaXdC6HqI4R/ajzWjffLK7APrnWQILcul3kORjy217bZTN9SBpCvCknQ0DHOq/r
 4N5J/7dNVlbopT/VLdXqvUMqNAF/RNuwFUhHzWnPJQV8PVEN5gRXxy08BCEpt16xJ3RXhdEmd5E
 QwN9QsIXME0EuFg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 5354htbu9bk46fkh6wxnab5bf1r7fs4m
X-Rspamd-Queue-Id: 68D21140003
X-Rspam-User: 
X-HE-Tag: 1793968079-102213
X-HE-Meta: U2FsdGVkX18OsI+7BExdBw7xg5/xTzZWnvCQaxy394+jizAdsTFtXR7vFQuOxwI44CntX4adxt0PJaZyVzsN1REGjonqUeDLbi12sL1RYbJRxHhWhOHsR68YfraebVP0K/l3bOQgw+JuEKSEhojXv7MnT4XIBbol+VQ0HAV1NChAlyJQh//TKm0mUIR5hrEX0ta7zmTdm+Wnukyfg9CdX1JVhZexZuH4bDqhwwB5GAN4CnGVyer1gCFVWRo+yuYUDTIQuaVJC+WcWrT1CUtvnlVJpJ4vfYENTEShmSyHfgLKkyEwjQ/2A3LywmE85hnhH0bCMgwSgxUcVyBZdG4tg7/4ALp+lN6XFJiKX8gMi+vqcnGjMTsqblkqM7ch6fGDKOYkzMqmeux1Jmb/HuqpCrGsHI/1+x3AA8S3QB3t9IyTDy1AeK5EsI5dF8XsbfZinwepB/7Of3YU+e4kLqNlXNZUkH01mKx71mNm8SG16GhG9Sc5l+WbrG+8kHPa1hrTNm2dDkPX13IvJjmALQ21elNlEYKU3CHgj8td2G6H6aIKpoG3+FPPFiu9U5hOFVNG2saOQn2hHV4QBezLXM2oR93zlYYNZJF+vV6/F6YChMgndv34WM/g4cMTgCHMYN1QIepz77Tk5DUUiJkJfXUPQe7uFTXQpwDdfGRiWtMV4ia40/cV15a5N3p759CidXVFfYEe9PR/Bs6UqfxfLnn6r/qHoTy465xE6iXr2kCnpX13ii+NHDobAc4Tl1Xg/kDQ4NdhyiXtFGua9I6kdns7G2GeGEAlUk14dAYfcJRCLCVfpwI1rd3Al5CJa3YyKKjC0xbmABzzTvovHfCggR0FMswu0RXnoWK85iJXqhk25YohJE6w81raM+BFLxT/xZITLF2yJdWI7bv6+lILroNdV+Y7XYWUP2o62nZaw3+vI0DEtc35BETvmPLevhA48fmG5KZsEGr93APB9lwIuhG
 L/85Nhig
 qtXHRwF5U3st/cFwsVBDOeN3sKzDMotdgjYYxhRdYQpSlZd/vdAAiVTlpIq2V9zWhg8j0xP50IMb5CjJl2k3kWUPT5ZbmJcsCBQ7kNo+Y0ceaIj9JA/mQJ34MX8qTynuRJjyEv1mhWqXY7jI+iwnJ0Rt3o5rl9V3i5ZoLIt3b2Lx/DDuMPDr6NgFYKR7hznMUkXdA1QYnzBZjOYnRqQeZJ5y0axvTFxdgcq9rOO34gyaqru63Vb0ZgspX0PP6kyirZpCP69WommQogeTWYW5+BWf3tNMm9s+S181K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Since v6.19, writeback waiters are woken while their writeback makes
progress, so a slow sync no longer trips the hung task detector.
Instead, a waiter past hung_task_timeout_secs logs:

  INFO: The task sync:180 has been waiting for writeback completion for more than 28 seconds.

Across the Meta fleet, this line is logged about 19,000 times a day
(the median over 40 days), and up to 82,000 times on a busy day.

Over one day, 194 hosts logged 16,858 of these lines for only about
2,000 waits, half of them longer than 160 seconds. Most reports were
printed twice, and a wait logged a median of 7 lines.

Going through these reports, a few things made them hard to use and
quickly act on:

1. The message has no trailing newline, so it only shows up once the
   next message is logged. Patch 1 fixes that, for stable.
2. It does not say which device is slow. Patch 2 adds the bdi and the
   number of work items left.
3. The end of the wait is logged as one more "has been waiting" line.
   Patch 3 logs the total wait instead.
4. It is printed every half timeout, often twice. Patch 4 prints it
   once per timeout.

With the series, a sync of files dirtied from two cgroups, on a null_blk
device throttled to 4 MB/s and with hung_task_timeout_secs set to 5,
logs:

  [    7.632999] INFO: The task sync:275 has been waiting for writeback completion for more than 5 seconds.
  [    7.633006]       bdi 252:0, work items left: 2
  [   12.913256] INFO: The task sync:275 has been waiting for writeback completion for more than 10 seconds.
  [   12.913263]       bdi 252:0, work items left: 2
  [   18.353245] INFO: The task sync:275 has been waiting for writeback completion for more than 16 seconds.
  [   18.353252]       bdi 252:0, work items left: 2
  [   23.633304] INFO: The task sync:275 has been waiting for writeback completion for more than 21 seconds.
  [   23.633312]       bdi 252:0, work items left: 2
  [   28.893299] INFO: The task sync:275 has been waiting for writeback completion for more than 26 seconds.
  [   28.893307]       bdi 252:0, work items left: 2
  [   31.792987] The task sync:275 waited 29 seconds for writeback completion on bdi 252:0

Without patch 4, the same test logs 18 reports.

One question I left open: the report uses pr_info(). The hung task
warning these waiters used to trigger uses pr_err(), which still reaches
the consoles, netconsole included, with "quiet" on the command line
(console loglevel 4). The report does not, and pr_warn() would not
either. Should it be pr_err()?

Signed-off-by: Breno Leitao <leitao@debian.org>
---
Breno Leitao (4):
      writeback: add the missing newline to the slow writeback report
      writeback: name the bdi in the slow writeback report
      writeback: log the end of a slow writeback wait
      writeback: report a slow writeback wait once per timeout

 fs/fs-writeback.c                | 37 ++++++++++++++++++++++++++++---------
 include/linux/backing-dev-defs.h |  1 +
 include/linux/backing-dev.h      |  3 ++-
 mm/memcontrol.c                  |  2 +-
 4 files changed, 32 insertions(+), 11 deletions(-)
---
base-commit: 8b7179210b22f8e48a82c5ceacb9d56a9c4cfec4
change-id: 20261105-writeback_stall_report-170750a69946

Best regards,
--  
Breno Leitao <leitao@debian.org>


