Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BE73CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 03:35:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08C708E0017; Mon, 15 Sep 2025 23:35:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 064978E0001; Mon, 15 Sep 2025 23:35:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBC768E0017; Mon, 15 Sep 2025 23:35:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DA5088E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:35:19 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 874D5C0807
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:35:19 +0000 (UTC)
X-FDA: 83893697958.29.973A7C8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id E2BCE2000C
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:35:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q5AWsJOa;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757993718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Xn0S3iaclVuSg/UMCyYatqhxi8Dv/vQ9NSVdr7EzWSk=;
	b=U3B9TbZKkxGKzTU+L6kAVCZ92tdIPMfQqibLd/0nBLnsb+uPJna7Z5AdElul63TMX3x6FY
	d2dvvPW4s/9Zsyp6qlIxMyRqjgULhSTBaZnUsoErJe3aZjcJf3mOmDaVMzPlKrMc/h6LaH
	YYagaHyAJotKFqkEk5k2UIa6DNizMTw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q5AWsJOa;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757993718; a=rsa-sha256;
	cv=none;
	b=DOeeMheaelatUX8dmNy8CCqiMCkVWF6h/cVaF7pZF3ALn/f8ggImAEYVko6MPDgneA5Uqw
	gezOH9ZsYzGDsMlC45WDc1CYZu7MPf9mJKBnpfHvIyFmStO+GvPHRyd2uJpA6hVRPZK4Gp
	PI81OTODE7j5+MAhMX0QMDxR+2iP8gA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E51B5438B4;
	Tue, 16 Sep 2025 03:35:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EDF9C4CEEB;
	Tue, 16 Sep 2025 03:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757993716;
	bh=W3dvzS2tlUSzksksMbckc+tKdCVNe/7RjYtxNtoI1mg=;
	h=From:To:Cc:Subject:Date:From;
	b=Q5AWsJOavN7d0+ussS1+eigFHxX/F9GrsUQQ97HLn6HbAGJQzkyuImy0S4raht+Xh
	 DYN2QH/w9zZp9ZXmHr/15RTswsAh8eE4xbaUzfBqr/nGfmpcrr3NExy2SWqIsJGdoZ
	 Jw6I+2RzceutyGZNcntMaIe87v6/BdU11/vOTApZZjcTAVo8pGCNQIwYZRWbuxFL0V
	 72peq0NhggItH+2Tltb6526xjM+9Ryjdy1N4AAkOleMA1rvWQpcYQPfKYLULOJPB9W
	 OsdXUiGk4dG4ESDgvOfFqnDWJH8xiOB7s7BG48Yh/L3f5onoM9aSCNA09r/o9NTrCW
	 NWzIZk1aqNFKw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/7] mm/damon: define and use DAMON initialization check function
Date: Mon, 15 Sep 2025 20:35:04 -0700
Message-Id: <20250916033511.116366-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E2BCE2000C
X-Stat-Signature: 8y7e98qe5zbbqxpnj6ers81kii6s9hix
X-HE-Tag: 1757993717-653075
X-HE-Meta: U2FsdGVkX1/AYxK7GFwvW7ANb2jJXNwH4w4yVz9w4cBNH9Zra0pch8hvBmOB8ToBAIaR3NgvHzOhwm/a+ddz9BkK1CUDw8kQ3WPl6y1bPhEbAteEDBY6KlX7eWkQNct/6Oe9ekMFkuyXa31dQJUbGjUYHN8u7+Gi1bcqSrl484QGpe369YWh4n3a4nMcBCGlawvDLeTxHGv/9eWk1hdK9+mn+11Mv4K5P0MJIsCOKwRsBj0Z3z9UjrSk2G9RCdgOpvNUlnq7h0xh+YsxgK3syBfqWgnL0lpVRy+b9/4VCGXAHx7fvhw3khPJ3Ba0jAOwOP+fYgVG1TDkis5dEqDqr84Cgr6dhBUmWUJq5i3nxnYfLt5RDSJktkFc1wYSQEmUq08+76qq7jOeIok9O40tONar9l9vLw5qCZBuDRME6i/6tIMOGiG4o0YHvEEcB+AUp2Y6bqoW8Ks5UeIw+3s/fCL7vE+cVs4HjV7fqvOK0u4F3QeeUFk1PGF3wl2wE7GU7Zgy/470Hf+oRwSXVcNaqwFC0ki3A/0v+F3c7R/BjL4TS3uO1AgfRh4KX/uqU9jIkEXZ3TVhLjnsuKYN73on2qVgqzYJheCgD2oWBrqKD1BJcc3jKEIzDn6n4QcrrCSCLH2rIHW2ipWlmWFUIVgfP9a06/YPK+acXLkR1P7Br6lb3lDQF7tDS8TxzzEkQnQtvyAvoLR9+SOm60X+3Y5GlybwjWzoaE8vX/b5sJQrw7poH8Z3TwwW+E5M00oTA4ImSfVOcXeGJcxovBXhn/M4uIczv1g7n9xhX7WtwcFplH8yQ30ID0sCmUrgSwN7hwLN3wf58yksMHV/M0ax57gDgI9u69jc09HoPjp1XFzehg+VXmLxCmOmEv5h62Mbc55mdA4hIoKrSVLMsw6Gki4q8toDSzSeUPTuqxjdCC2/3d2drgCs0KBRMGWHIqcfRUXsKOCXBn5MAMyOawb0Wui
 VCQhfUuN
 9hCIyQJsbVAcDWi7U1leQkoaTloBkgQYZ+FaCyyI0qrFxpYGNKTNjkO36ktpiesg85McQ3qJYUVrE9sxqG4HTV6HNdCnUBdp3LXbEoin0K/zQTfmPcZYqwHWHI7k9S+fmA+E7YlzRtwO7/dQ5q4pEF+n16l4DBw8PQMyYH6x17saqKzUXjHyEjbgp3TopXjqxweQZdBiW43nyPnijVLAJRfXNF/9ttSD2OZ1HEANQhWzRwdA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If DAMON is tried to be used by its API callers when it is not yet
successfully initialized, the callers could be crashed.  Such issues
actually happened and were fixed [1].  DAMON API callers are therefore
having their own hacks for seeing if it is safe to use DAMON or not.
Those built on an untreliable assumption that DAMON should be ready to
be used on module init time.  DAMON initialization could fail if
KMEM_CACHE() fails, though.  Also those are basically duplications that
make their maintenance difficult.

Make it reliable and easy to maintain, by implementing a new DAMON core
layer API function for seeing if DAMON is ready to be used or not, and
replacing the hacks of DAMON API callers with the new core layer
function.

Changes from RFC
(https://lore.kernel.org/20250912023946.62337-1-sj@kernel.org)
- Rebase on latest mm-new

[1] https://lore.kernel.org/20250909022238.2989-1-sj@kernel.org

SeongJae Park (7):
  mm/damon/core: implement damon_initialized() function
  mm/damon/stat: use damon_initialized()
  mm/damon/reclaim: use damon_initialized()
  mm/damon/lru_sort: use damon_initialized()
  samples/damon/wsse: use damon_initialized()
  samples/damon/prcl: use damon_initialized()
  samples/damon/mtier: use damon_initialized()

 include/linux/damon.h |  1 +
 mm/damon/core.c       | 10 ++++++++++
 mm/damon/lru_sort.c   |  9 +++++++--
 mm/damon/reclaim.c    |  9 +++++++--
 mm/damon/stat.c       | 10 ++++++----
 samples/damon/mtier.c | 11 +++++++----
 samples/damon/prcl.c  | 11 +++++++----
 samples/damon/wsse.c  | 15 +++++++++------
 8 files changed, 54 insertions(+), 22 deletions(-)


base-commit: b6a9d79765ceb52c8889fd24e1ff3169cc12c80b
-- 
2.39.5

