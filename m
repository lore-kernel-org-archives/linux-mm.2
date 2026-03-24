Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2493EF532C0
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 01:27:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 589446B0089; Mon, 23 Mar 2026 21:27:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53A6E6B008A; Mon, 23 Mar 2026 21:27:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 450316B008C; Mon, 23 Mar 2026 21:27:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 358346B0089
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 21:27:44 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DD45E8CDDC
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:27:43 +0000 (UTC)
X-FDA: 84579219606.17.8D41770
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5888010000F
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:27:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tnUvAwzj;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tnUvAwzj;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774315662; a=rsa-sha256;
	cv=none;
	b=BfavB6IyubzkLIqemKkoC7Qn/EsrBGquP3x0rAbBIfTAN+hAS/vQKApcY/vVEXExN6EZZr
	Aof2iktj8Ph0B3MciD+GR2TUgxOY4WioumJ2PXG8sSEdeYPJl4LsPBLMY7MkRKljAFiwvE
	DlYPF9W2WCC0wROL+Feyu33WwPBjeFk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774315662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e8/e0rXHSBqAB/q8AZioHXD1zP+hZiTvz8LUDi18zWY=;
	b=nXa389O0zSHXbugB4V330KF5/sazGXr5lAkVDwp2/Zqn+zjaKn4FBGjbFwXzCBMp9kvW14
	lK3ec+/cNLkQeQafE49WePLcLtphq9TD771VUyL2TQWMavjDXkIuzWTtyxMlFsTCWSY8Ls
	nEZsJbG95FJZs5VdrC/5nuWAsy1spCs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1E9C243FE8;
	Tue, 24 Mar 2026 01:27:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B07EC4CEF7;
	Tue, 24 Mar 2026 01:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774315661;
	bh=dtIGXjHCqBmAAmml2iPbNBnXhRFU1QkE5kANm1m/JNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tnUvAwzjlJpD9qqZuKME+ic5r6VywcWiYZdBEPvnum/Gcn/E2JrQGiHU8U6ZX2Yz/
	 kEZOjsVk8AQxXPcPgbTf6SHzJhs+H7V+WI47OzckcTnFv1hQ7QY5of5BLz470sWnaP
	 mTviwerV4SnAKZCnbOCgkXuPJn46H7+mMgU610suLvcVqTUvLRHbDibyT0JFR6XYs1
	 burFaghxubWVyUO7sNaljd0rlrU6AXZI8/v0hUzecEQPdC9QyS9d+8RKrDUGO1Aq0c
	 cdepkZ2FlekaJbTHywgRrapbYZoLshRPqDw5PIg3Dxp81jxfv1Hmd0W858eHNwUps+
	 CuVrOSyqFPhLw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko status) [RFC PATCH v5 00/10] mm/damon: let DAMON be paused and resumed
Date: Mon, 23 Mar 2026 18:27:37 -0700
Message-ID: <20260324012738.39394-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260323231538.84452-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5888010000F
X-Stat-Signature: nk5sbz697wmsii6k7jumdhiuzza4uipz
X-Rspam-User: 
X-HE-Tag: 1774315662-165773
X-HE-Meta: U2FsdGVkX1+sxd5bm0256yeD1fvI+Q0k6uNMq7+zMQDM/ZkLdU2vUdz43dW/Li3wqiXWGf/5hHQb76ns5n1C0TutvInuQsGJXtXKn7bBjm4XoPI6JrbE5LUWypMUikmOlRgiuCCLgkkbeBIoDNCR9RLa5HPrPIBu713gnFKdjFy1xrGjcDrZwI6xN6BlPK2BBMimymiLntFzxkBqh4ivi3nBYTfSWMtBM8XCRw45f6lYZjWCK2PuRJJCUWyNlhkriBQ56KLmhrnXfWeRuR9nuhlRmuluMIs4Yh2Lvbs+Gd9oxwE+uS/PXIbGI0+LCK0CBe+pQthPnpHfL5ukfqKnDAufmIwOHSD4KjKmyuSDzklRXn6klBM6vsH1HIoQqvoZXboUUBMV2GVczbXfGVDd2lJg7MTiBMs6v21r6s8mMMFxZDJibnHmRDiMSQGcNlq1ZewTaO1dSH3cY0DpRdybNxWKd6+ma4paWZgvRU3ohtNs+QMQCrivpfA0RM/+xd10A7S7bezCkL19QIhFFgOzcAMwwsy5Vv0iTcdPQ54V3q8jEqC0Pt/uHO2SfwB/D3dG+pV0bDymDDAuxfskkB7wtkH/Vi6yPa+Ogvu03kJj1nSvGsVNYS8ULzg1EMZxLR/i/weHQcRwLOl4kX7UfpOT7iz59Vh5J10G7OJzLWDFAPx125TtM5LIOjC75izNJtszBtOZsTtrrievyw2GlALznWn38DYkHfa3t0t6R2bKclScYHdQg+K15zy3HfQw1IykL1rsAfzjFU0D6sP7KXq3IUlg007fzveCm5CsKB5rSVTAxzWPObLbkP0HqNLcDhWcnT0DM42vy33Z69ABcuM2HTJCq9jNeR8uIcrP8E7Z3afxy9jQhVzybbGMTtcKETthP5SjV+rfkdNTlaUGMtlElg7VrbLtpuWbw3AVr/bwRnUtZjpwGNXYpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding sashiko.dev review status for this thread.

# review url: https://sashiko.dev/#/patchset/20260323231538.84452-1-sj@kernel.org

- [RFC PATCH v5 01/10] mm/damon/core: introduce damon_ctx->paused
  - status: Reviewed
  - review: ISSUES MAY FOUND
- [RFC PATCH v5 02/10] mm/damon/sysfs: add pause file under context dir
  - status: Reviewed
  - review: No issues found.
- [RFC PATCH v5 03/10] Docs/mm/damon/design: update for context pause/resume feature
  - status: Reviewed
  - review: No issues found.
- [RFC PATCH v5 04/10] Docs/admin-guide/mm/damon/usage: update for pause file
  - status: Reviewed
  - review: No issues found.
- [RFC PATCH v5 05/10] Docs/ABI/damon: update for pause sysfs file
  - status: Reviewed
  - review: No issues found.
- [RFC PATCH v5 06/10] mm/damon/tests/core-kunit: test pause commitment
  - status: Reviewed
  - review: No issues found.
- [RFC PATCH v5 07/10] selftests/damon/_damon_sysfs: support pause file staging
  - status: Reviewed
  - review: ISSUES MAY FOUND
- [RFC PATCH v5 08/10] selftests/damon/drgn_dump_damon_status: dump pause
  - status: Reviewed
  - review: No issues found.
- [RFC PATCH v5 09/10] selftests/damon/sysfs.py: check pause on assert_ctx_committed()
  - status: Reviewed
  - review: No issues found.
- [RFC PATCH v5 10/10] selftests/damon/sysfs.py: pause DAMON before dumping status
  - status: Reviewed
  - review: No issues found.

# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --thread_status --for_forwarding \
#             20260323231538.84452-1-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

Sent using hkml (https://github.com/sjp38/hackermail)

