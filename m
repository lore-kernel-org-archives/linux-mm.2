Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FF24CD6E7D
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 00:36:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FBC46B0005; Fri,  5 Jun 2026 20:36:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D3A66B008A; Fri,  5 Jun 2026 20:36:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 510686B008C; Fri,  5 Jun 2026 20:36:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 404266B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 20:36:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D1F998D280
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 00:36:38 +0000 (UTC)
X-FDA: 84847622076.02.A549205
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4834BC000C
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 00:36:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Fw/vLaTX";
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780706197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=if7f2i827CYYs4L2MWjOunPYSfsBUmgkGAdZ7VFnG54=;
	b=rY6eqiNeSahYegRqb135+UWlHpml4ybFIuVh8IJ7tAo2bDdp9704v+4YnFUJ44bvuZ9PDm
	GCmyqzZW4x9YUaKF/BvUnB7P35LsWUcd/HFX8hf9yD+HzdVnc7XkKvHPc1zpOPnHx6zmKB
	Wt+t/epPJPcb8A18uTsJQxLmIEgfKkA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Fw/vLaTX";
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780706197;
	b=U9fB7PbmWa2zWwXyVT5r51YvpVFdZhz/eGx+EXKPNVsWiKDIjVMnf7yuWkNOCI0Z8kVTsI
	6nfiizAKd2cj2EEDW+LzTHroa9T6tvVqhdAn014yH9FjWLWIEKeWelgtKZWwmIdBF50wYU
	AZs4eqBBV9BpSZ+EcEfbJSRRwSH/0nw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6EDF544389;
	Sat,  6 Jun 2026 00:36:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16C481F00893;
	Sat,  6 Jun 2026 00:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780706196;
	bh=if7f2i827CYYs4L2MWjOunPYSfsBUmgkGAdZ7VFnG54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fw/vLaTXL6yirNSzNZu4/QAtzAszDN+U36IQdoYEJdWbuAk6oju9WLGXzn9xi1DvV
	 sedxmaFJCY7H4ijFitBnuhKd4PYgEsKAwWwuOAWB/cVZ1T9tr0gbefFIDE6qZ6X28J
	 PfH5zCrVAQte3BUWNF58USZTO9D8Z/qtLNORH61oX6wXpcTd6PgroQj2Vz38GAVqWf
	 hoen9t5E9ArWsx21uZevAez1HHKtHY9uQFKSP9j77izBeZZ0t6YOEU/jSrFSCPHzNK
	 JopifGHCD99GzXSM0UHfQ+asewWGBkQzzLvXqwb4VSZC9JA1hvxaiggSXWpnZmbjFh
	 nRbrhGpiyUg9g==
From: SeongJae Park <sj@kernel.org>
To: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	shuah@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] selftests/damon: add regression test for damos_walk() vs kdamond exit race
Date: Fri,  5 Jun 2026 17:36:27 -0700
Message-ID: <20260606003627.88973-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAF+TLO0TOKr3nef9RnbBuZ8A-jNpV1po26t1BO6JbSqMhfABvw@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4834BC000C
X-Stat-Signature: iqghd6g4musw5bp5hx43oixgqz7yawbp
X-Rspam-User: 
X-HE-Tag: 1780706197-955167
X-HE-Meta: U2FsdGVkX1+ocAk/Q9H1hVrwmmqrmT5HU704UXnr/HQWj+LktvoUSVEfk1C3cyaFdh+D/dQ/nCkZmeUa49KxYJWcg2IlRgpIYOrfd1e5pBziyp0Gq1CKM/IBtpJAHSL4q3/zQy/1RmjV/Bma4ARalQe6alKNSjXr8p1PcReTxTXAWljoNBG+TIUuVErxG1UmfhM9VpkOfO0VDpfwuG+Rot5mKouiXIlHR8Hjf6FoD4HZGeqPZGM84vgSyXR5aMTnrcwj7hjJHZzNkg16fVqhNGkD7vA9yUieLOwM3lz9rU/R69s7nKCOG4aFgr+aHCeicNX79nuspfL+YyHWVErlWzNKPPezC98Am3OFrG+n0Rn+Tx3+GFBJnfhu8Sdaqar/f62wUbyvt7/ZP37r4YZnKs0e+AzWKd2VIVtOP0PGQQqvkNMOyyO1wfRjO2jtUieLnEC7MGXmUnW4/1CCxPUfgr2mY3uEr4dFSVaPna8u/XispKyIgEtbHs/FKa9CZZtH+Qz6fi5G17qnHV49p2/C3DzZm7syLsCHeFyFikYSzhuvchBqlH3joeMKof1feo8VbdnWksAxiaJVpd1qAJreKEOjiPZslzeTbjbNI04rl1nA5tQwOepFy+OqP/EkG4H6wG+Z1nKhZfUe5pEdzMghxTVdRETeD85OK71yZ20I/JqLOoHLhXnwl+HBnqUuAPhrD1479X0bBw0AsAU3GGYjMLu5ExrMcAdm7FxpqntmPJQv5/sytdQYdjw/u0icieP3yxVlQyC1TTQ5MLWi/L7vCTj0fd678ZDXcgUTO24rUDT7dBZNKonaex2TZ488YxXGO1yGCZFbyTsAtSh2cQlBfib6HFEVu6wl2W6NezuGMvW8LeylP5w3UU1YOEv4rbFrwKAJZcUKabEc8XKeq+X8MD24/20ufCOs0bjbRzXUY8yK3prx0F0fDlWvKVoR4uTOB0KcNt8d2kJmZH3I3Zg
 7Z5h4Me0
 koDZv0SmFe9jjCPMnIljrcRmUQlviiz9tAcRJjtqnvuAx3wZ6Tp7taGKMzhy2d1e4qh1oFlxvTscJ+xeRfOy2WlwlOyXaIF9b1eY+riPQWzNgR4QGyChx/mawfZ3qSi4XcaG7WNF+89OueiSboOW7pVmmDYujb4mJzw3DixMf49LWN3ZXgv6bOueRmE7G3FSh9khPt10t5YNY0N94JoJSvRqYkOWH47xoa2FgZ862NcWExQqyxNTeU3qtNEUO0CxSIhaJtnkYJF1PcV0I9yoj+RvV9dNbkB+X/Gvh8fUCPJrm6gipEQbknzpVPxgNZWpVd5FAmhSMiEs+BKY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 5 Jun 2026 12:44:50 +0530 Sailesh Nandanavanam <saileshnandanavanam@gmail.com> wrote:

> Hi SeongJae,
> 
> Apologies for the delayed response.

No worry!

[...]
> I agree that a KUnit test is the right approach since it runs inside the
> kernel and can directly set walk_control_obsolete to simulate the race
> condition reliably without timing dependencies.
> 
> I will drop the userspace selftest approach and write a KUnit test for
> damos_walk() functionality including walk_control_obsolete. I will verify
> it fails on a kernel with commit 33c3f6c2b48c ("mm/damon/core: fix
> damos_walk() vs kdamond_fn() exit race") reverted and passes with the fix
> present before sending v3.
> 
> Regarding other feedback:
> - Will use correct commit description format with subject in brackets
> - Will remove the Fixes: tag
> - Will add blank line before _damon_sysfs import
> - Will add changelog and link previous versions
> - Will share revision plan and wait at least one day
>   before sending new version

Sounds good.  Please consider using in-line reply [1] from the next time,
though!

> 
> Please give me some time to study mm/damon/tests/core-kunit.h and implement
> this properly.

No rush, take your time.

[1] https://subspace.kernel.org/etiquette.html#do-not-top-post-when-replying


Thanks,
SJ

[...]

