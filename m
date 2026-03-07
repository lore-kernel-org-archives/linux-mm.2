Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E452EF55104
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 19:54:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40DB26B008A; Sat,  7 Mar 2026 14:54:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E53F6B0095; Sat,  7 Mar 2026 14:54:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CA246B0096; Sat,  7 Mar 2026 14:54:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 19DC96B008A
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 14:54:10 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D086D1601C1
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 19:54:09 +0000 (UTC)
X-FDA: 84520318218.21.C6A69C6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 413EE40008
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 19:54:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wq2xWmi4;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772913248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dDAaBzVGHdixYTVEv7b0kSe6mYtlW4zEeXzSxUH5aJc=;
	b=s0S0aotQEV3ZKzzaZ2hB4y5Fu4CtlnxAkzBcR4CG8jZ6LIHVtJsQHJWmUebKL+ihlo17aQ
	bSrrLajhH17Tdxt12sVEA+rEQKaGWl8qYYkGTGANcoXzUDkFPk3+oqDCoNjMNzQmImyyAX
	yRd39Z8jgwTmtqHcpV2JnlZ6hwAbqEw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wq2xWmi4;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772913248; a=rsa-sha256;
	cv=none;
	b=yjbWL5HyA4nzOTndJVFpmcX2Xu7eKSDJ/MF2nwtqPp0tL4dYdBljDhe+1uKV6R7RYkdbyg
	E0ucXSJbGJocRA+ktL/qkpquIWEGxKhjd1nsS/FnjWVjijCpo8XRe3aTkA2jDrsNRvk3t+
	q3CKPTsCJvJIlmE4br19lgYSBGtdF+U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4345D43333;
	Sat,  7 Mar 2026 19:54:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A1FC19422;
	Sat,  7 Mar 2026 19:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772913247;
	bh=7ODZDQJM/Fjl22DmH1XWyzvb3MSVSALXM4f2MjB/9Bw=;
	h=From:To:Cc:Subject:Date:From;
	b=Wq2xWmi4yYSpo/lcxJhDT7T/lmEBVCzdUEzZ2yMEyV3qoLcloM1VKkdIj7rsIXgVR
	 FYtUGLSd9bra3Wexb8R0tSfamwTQreuDrEcbOSm1wW6I0lhEhhirxA41zJfXd6+qxi
	 DCXY4vwLz3zObm8iS8eQASFKWKJRcJH07joiDvCBU/Zf0KIKR4DrFu8oWq/wpdjko3
	 EhQ0nP2bpfc8BGngw24mek2z0jtmguzblsnmosh3AdMS0CTWU/rmCqpJDbJcBB5eoT
	 vN0XbGWsW1arlYmE5rlmZ97LKGwjLN5FvnoPxNhNN0vmgyhBezB1dp7SqiOjA4uDaW
	 5y4/i99PboWoQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	wang lian <lianux.mm@gmail.com>
Subject: [PATCH 0/7] mm/damon: improve/fixup/update ratio calculation, test and documentation
Date: Sat,  7 Mar 2026 11:53:48 -0800
Message-ID: <20260307195356.203753-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 413EE40008
X-Rspamd-Server: rspam07
X-Stat-Signature: b4eaybj7thern7qi1dyz6indoedbfczz
X-Rspam-User: 
X-HE-Tag: 1772913248-342076
X-HE-Meta: U2FsdGVkX1/bQYhSxf6BmmeUiLEJEARkLqlzdF9Q2CaT4ri61nmQv29XQ2Bv+/HYJp9wQ78iGlYdi7R5YRyQCX2wRxGlYgwPkaZz1yDjugz7NcCpmn+h0tP4aP3tDhxEDMX9l8Hw6stkS1ypvCL2Qc1bGzpQgIPzBWBr+qiAADDQDjeV+g2KuRzUEItVdTgu8ZgOZ/sukkEQ9pLBkHipzFUBC+513RC6bPF4vxfBd86Ziyxm9Vqi/LEt7NAwLsUSXb9q3lMOgyo9jSx/uUnnVz3JcbMoHbtTi+0/wB5KEe4ay1hcEOwpMCxg229joRf+8ecgakC2VleF/s3Ga1mGkBpg4Y/KDrQz2u8bX7NzNUhJFdA8LNNeWOgjMG7CQ8CSUZL2mf2ftrpEdRNwmK5MywwaoRNAW9ogTd8nJD4qZfNDHIKole7nElehraLnrJwOedLJufOGlpTSkW2t9rQy0mEewnWWsodJluC5J54mSzWpibj50nqn5GX9NbRo6PxSuEjFDvEyEykMC7GcQWf0dJyFiPOxjwIABFbL85TYsylFfdWym1ybULldEPJqWX2kuiJJTapX4Vo2G36g2rjF2OVZHvCZg9ZW/Dr7DK6uZJjkUZvJjrTp6wtZLnIHPsR1n6t3Q789UTdCx/8VnQqZgQr8ah6hHIiGlL6+HXZI5LWxBr2etqeQaEEj42JrPkRzDudia52jZOOjLC0EXNVgdkE3N60FZe8IV+rd7p5R4GUR3g1CqkOzicaedhu4F1BeCW59KeYxGPl2bTHlNilnbmrq3eLxbqzA0iDSePLG8nqhvr5IM5w0Dex/E6M9w4H8H1MD/xBeUPTjyh9ntg5OVyThvziatmUkR+WMKoWYwH5ATeIl+kLhQgHZVAP0GywEosmpfBNdfUJhMLNG7ndosvN/Rp6qMK0U1+Su2BiiJ7VzM1s0jBHEF9cVnDLbgEQ1Hwozz3dOSQ/lXkwNDq+
 K9UpwMwx
 SIk86M29Banw4XevXU7kLqILOL0Qp8hkaF9naHl25Tz9nH3v0gPjjpxudpQN2qbTKZ/oltP0IZs3eyltx+1ixMtNT3r/DoRu/4GJYXtlb6dQkpPN+Fo1guSk9Ogm9u6I/8/q+0HyMiCEJpUPT4ffHI+cLu4deJiEjwMUvn1KKz05iBO268fGt1SjUW+lkRlYj3Hf0VjhzdpIbHbDpFiYa85li18PIoPqirCGiEDoyQE7ycBaHmjNFPlf1S+Dsv3o79jb2OtI1YLrn1zq5VVwfQsBnIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Yet another batch of misc/minor improvements and fixups.  Use
mult_frac() instead of the worse open-coding for rate calculations
(patch 1).  Add a test for a previously found and fixed bug (patch 2).
Improve and update comments and documentations for easier code review
and up-to-date information (patches 3-6).  Finally, fix an obvious typo
(patch 7).

SeongJae Park (7):
  mm/damon/core: use mult_frac()
  mm/damon/tests/core-kunit: add a test for damon_is_last_region()
  mm/damon/core: clarify damon_set_attrs() usages
  mm/damon: document non-zero length damon_region assumption
  Docs/admin-guide/mm/damn/lru_sort: fix intervals autotune parameter
    name
  Docs/mm/damon/maintainer-profile: use flexible review cadence
  Docs/mm/damon/index: fix typo: autoamted -> automated

 .../admin-guide/mm/damon/lru_sort.rst         |  4 +--
 Documentation/mm/damon/index.rst              |  2 +-
 Documentation/mm/damon/maintainer-profile.rst |  8 ++---
 include/linux/damon.h                         |  2 ++
 mm/damon/core.c                               | 32 ++++++++++++-------
 mm/damon/tests/core-kunit.h                   | 23 +++++++++++++
 6 files changed, 52 insertions(+), 19 deletions(-)


base-commit: fa1e30b2dede645519bf6743439d3925922651bc
-- 
2.47.3

