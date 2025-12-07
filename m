Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE141D2CE17
	for <linux-mm@archiver.kernel.org>; Sun,  7 Dec 2025 16:18:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D00406B0005; Sun,  7 Dec 2025 11:18:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAFD26B0007; Sun,  7 Dec 2025 11:18:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC6936B0008; Sun,  7 Dec 2025 11:18:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A9EAC6B0005
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 11:18:04 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 44088C08A0
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 16:18:04 +0000 (UTC)
X-FDA: 84193181688.28.2754778
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id AC908A0017
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 16:18:02 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hx/RPkQJ";
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765124282; a=rsa-sha256;
	cv=none;
	b=uHY/wKYA82qMtnks+gIwLspKea2HeTPaUaSrkEUDnEp7CqTI3/QZD5ool5EqEIUpx1C2qX
	dgoy34VBZ9DBMn4Ar4Z11PrFJ1bpRKYm4/ZcLOnyDawjj0+S5n4oG2vC8M5PGZvhCmO7zO
	HwufPwkOrOits7far9jGvlf44vpeupI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hx/RPkQJ";
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765124282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=IFbtioVwjPgTz9RGOWKLcWwm2r+DeWEZdEQueuSwrKI=;
	b=OQVZqvw86pPGmD2TJDWPDwVusAFHr36IlH0skptWs/XqteFZD43gO6BGUiCJluESqSMAlM
	H3+xrvA+XvrzdK6UQdpRUqKpIOpIe1y4Hj4aoDsQQg0UspdjhNRqkXT7w1ZHTwvZXZFTMF
	jjiK/P2+QbKqqKGmDfoGLDQFxHcIEc4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 735C343DF5;
	Sun,  7 Dec 2025 16:18:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9F6C4CEFB;
	Sun,  7 Dec 2025 16:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765124281;
	bh=WY1HUCK6dVbMqOfj9ILVOTmqrGtjd3bt/apdnq21NBQ=;
	h=Date:From:To:Cc:Subject:From;
	b=hx/RPkQJGYp1jmeiZaTximUFvCYqIJZZPTgJT2m90fCUQsopjNrtxQqgpUMFlk1vJ
	 0gEi28LOD/N1i25hYXfZvJSg3+BbfYnsjD+NnJbetIHjdZE8fxfsLYTWiHweFDr1gb
	 SrEbmqEkhd5GWYLECay4Og3DqkhbOPbVQ3F/QFTKpXywVnP/1kBLKPHcpmqXZM253V
	 SV19htCktSZ4e2FrALNWzXIok9bFTeuWOUCt0aP9aCkRJOBhA+ouM1sYibzx243lzG
	 Ybt1cXhfp3889SXIKo5H18TgDhiAxgGWdoTF0qBHlJQiiqI9yUCzS50j2+LeAlliaK
	 lkZHrm+cwPivw==
Date: Sun, 7 Dec 2025 18:17:56 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] memblock: introduce check_pages boot parameter
Message-ID: <aTWotB5ev3q9VdXj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: AC908A0017
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: bbtrmwzpcdugfmxeuf36bc484gm9bp9m
X-HE-Tag: 1765124282-689383
X-HE-Meta: U2FsdGVkX1/EzOuz6ke5VXoeUftSsLvqCQbaq88FSH6Z0CZZqGhXq2AWlakFnqXdn1kzWK/QU7e0VsDF2NsilzvWcGuA3Gye6EhIO89B39z2PzUUEv70MLuVgepAcICDNtwnf0S3vsiNWrU77Pg8pP6Fa/tB/YROnfWkqcmQvsCqffOX9fLdKYJhBwEQIlI77d0VKX1vw2achMY2d1ZvBwm5r576MwRkJDc4SDoTSYPx+UoChoELJcQvReDwXUZ0TGL0GhLdTeR4OAmZsFupCYb4RTDDK6hG9gq+oH9lcs05sVxOGefL0ZzL9f+PM5TK3/Mpol47ytZnORmk7E1gvvOAEcXaKcVjB3naxZaU7OAoWi/Q3BAntVz8su9S/GdqPAjZjo2h4Da4+q1VI3f3tZOeYxyS7ljubHF19XhiMLPmJ8wxUEdxbTsn6YKWJxLiWrP5urZgogFsuX8q5SG1s04DRwlCIKhupd3qriUxvS3aa+q02iqM8Y5cDjzSJ1v+s3vSv6JUIlE05JdZSarmp0Hi6RcBlTMZDREemHkREbdxQliSomK6tTXz0I6WsnKSC/OZWb9+z68R45Wp0AobJwdIuhZQGfbCfiLhyTxXu6YugFgdI8BIYAou7A3oRCo89rxSAN5B1jJPyCrN8egc170Rx4E5Yf2dqT5zzYV3faN139/1xcZQ5EaR5dNMN/oUcjpnx2ogTsPcLG+2V+GQa8VXkz5JZvbFuXJeNXKOeEqnxWypqy6FJTQLLMERjce+3XDJVzbYNlV8tsaU7SNPxn06DkPkSE5RwTr1z/lVi+Gn2wbsg78cV/4NKttbjOcoZz4nNqA768VGrV9DF0lyMSQu6u6V1VjqmRa7pU+742GF6Kb5vXUcNaOSlGuOiny8Juyn4+uUrlEQx6NziTKr5ugf0UDUCy+K087TuciYAhpp/dbtyVFzepe9zq8CqS/qR8aUKppUJu4TwkzEMqD
 3rWpGiAt
 VIuxcF+j5B27OpgRNpOLGbILfOI8AGxHf0tV5Lz534BGb3P3cBJMB7e859zNxPm1QAhdnoofCQEB9t9/CaYv5zV6IFHgyJR4W27qSLB+5RLg9wSEYHhXNd5xyy2p9ETvmAttqD+XxBWeYqj5YQdbaQAamYCRI8wypwtTgWsRnM6SQM7PHRHsWRd8NBg7iw8bZfsYUojD/4cI2qVAluaR/WvW3q4BD6VVXMX1RDZXiQJO/5H8Sxm4xEP443OOVXOV8xUr15+8SVb06WdX+ehkTtzD/OziPGuJm+FnDUM15ikODMeX64IYPq3GBu7wQYWJddEQypQlk70CQC4LXjN02SFq+oKORO9Fh5504Sp+9s/npWI0aeONOKorDoM9mWnkV8kq3SA6k+IbduAw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

The following changes since commit ac3fd01e4c1efce8f2c054cdeb2ddd2fc0fb150d:

  Linux 6.18-rc7 (2025-11-23 14:53:16 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock tags/memblock-6.19-rc1

for you to fetch changes up to 83c8f7b5e194eaf3fb268c513e23e23e892de8ed:

  mm/mm_init: Introduce a boot parameter for check_pages (2025-12-04 19:40:25 +0200)

----------------------------------------------------------------
memblock: introduce check_pages boot parameter

... to decouple simple checks for page state on allocation and free from
CONFIG_DEBUG_VM.

check_pages parameter allows enabling page checking without building kernel
with CONFIG_DEBUG_VM or forcing init_on_{alloc, free} or other heavier
mechanisms.

----------------------------------------------------------------
Joshua Hahn (1):
      mm/mm_init: Introduce a boot parameter for check_pages

 Documentation/admin-guide/kernel-parameters.txt |  8 ++++++++
 mm/mm_init.c                                    | 10 +++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

-- 
Sincerely yours,
Mike.

