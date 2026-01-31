Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B00C0D7976A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 19:41:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E19B96B0005; Sat, 31 Jan 2026 14:41:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9DA16B008C; Sat, 31 Jan 2026 14:41:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C98216B008A; Sat, 31 Jan 2026 14:41:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB99E6B0005
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 14:41:53 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4E1A5C1CF6
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 19:41:53 +0000 (UTC)
X-FDA: 84393279306.02.14AF12D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id BAE07180006
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 19:41:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LA7wXFxe;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769888511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0/g7VUIGH43TAiRE93QatYdrcBo/9gG+NbZ+rTi7pho=;
	b=d00skcGPdurTR8WmsamHbfSU03C0NBdVC0GcpNoW68E3wutJqdy/7pF5aLg4UKrWpvJKXy
	cBubMAhEki3tLTI9gVnFyIB7H8OOSCgqGrMprlFdUK+DTK1tVfPrsXharWcRrZX6vwF4vN
	8hM55QTAVbu+Y0lXn1G4G8gsI/LpSg4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LA7wXFxe;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769888511; a=rsa-sha256;
	cv=none;
	b=F6nyl/nAe3XxtKUkt1AlBfcq8ehqAepKGf6/ELaSutareuml/7QQdhPcWVlQKPF5aYb7dv
	qINp0qQzZ8HVFbexA1mX0fHVR5nIdnAw5+jgcYRZAd5Bs/VtXweGfe73rF8oIuvjZm6iwq
	Xf8kmrPs220MrAlB3jl+H/XxQIBQW+8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B9C0743F26;
	Sat, 31 Jan 2026 19:41:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82EE8C4CEF1;
	Sat, 31 Jan 2026 19:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769888510;
	bh=Lni0/9CHbjEMqtpfuZwpe7kNBiN1clVWOsovCwhBxjQ=;
	h=From:To:Cc:Subject:Date:From;
	b=LA7wXFxe4H6NpXWZXW19T7QuVddWQh/1KQZfPkOcngYhzqAJgib5hqcQ/WpZTeBLS
	 rHrzj8264fZocWwS8Xm9A/M8j8UMHBw9UmcMTGcO8Cp6XznEfVBFyNRCADxKJZo+Ov
	 LhyVTiIAghQqBJadr6a9Mluyk6lB6/O0GZSf/rfnyu7f1if1/9ZSPsFOP/2GJdpIof
	 +hFMqutJPTOkctSZnQtrEEBY6obeEXik16eIirkj271Aco1br/dCx5DU3oXVHMSp9P
	 qr9qYal/agW/obRuv4Dcttajw5+8p81+2BhVQnbAfGcZkFL7kC6T5tMJxXRvnCkvbZ
	 CH3q2Et+JnDCw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/2] mm/damon/core: improve DAMOS quota efficiency for core layer filters
Date: Sat, 31 Jan 2026 11:41:41 -0800
Message-ID: <20260131194145.66286-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BAE07180006
X-Stat-Signature: 8duuebjk4m15pfguixcpwgxnbtc63kts
X-Rspam-User: 
X-HE-Tag: 1769888511-655300
X-HE-Meta: U2FsdGVkX1/TQneL9NEW+ZhXJkxPk5jU6w2Xvd/GRhbImcSkHkmfITbvhIgNbK+X7f/1gebFVoLpaGvtF1A0SJI0FFpn3La2p6VoByqr438S2rTNKPr6t6Ah7IVKj72GL84lZDcLVKCrebOBbDRqLNBQ71N1t+yqTa2boXglJ0xJAKneb9kW40oraw6veAU7ExLP68pqxPyzAJbb0RZUWivywmnBkgIrc8screPuzdl3F+DsAczGe37vbVASviu6OLWJgzJt8saNwI+STxL4aVJlcG0K27h4n0EFCVgfhxmhtZux2/IvKXnqyxVQGSziTRIPmHJIxdbTnub02Iz/oGtD5q4GpzsS3j6dPmpGJptD8HMgY1y6x6HySHO4eL84J3tnyhq4DUwUa9P8eJGFHnkcF0PUCPrgGtXBYTS0cq2pD2WsbHII2iI+Q28YwV66ZAsySvHtCLSoqMu6mrsJUguz1ScqMcyIFs6VdQIVIlddUVXC/V69kSeND7q5Zoo/YDJUpiBzANG6AYx1VdWR6UZnpxLa56cRz0TmjJNIkVSZWRYqPb0G9dx23uFgLtMLNnCYwwBlBXHEZRhtp4vf91cVIY3C4zIuh6xSy/003Y5Es5BHzq258e1gF6hIVtYkC5KbxkZHPEj+3pg5xstQUW/8o7WDWyPZ4Gq9gWn3hSJaQp5RAtoE57KMlKGvDXbUdDQ34bFJloDromkw3tpTCDzl2putRSeLRGXzGdRdg7mfi5mgY1THVqZ43L5WkunxTblC7L2IizVTvL5JjgpSoZGiKRX/fu2JCAG7yZgG7rDp/gUvYDYLKifj5JzcBmffpAL5fx/FQmDiNjzKlg5em+GE6w00QYzJxGU0dKTHpdOVS+gTEZtaOcLKz0YN5Zs52IR/15qhKFWTMzSPExgHUbmHl1ZgtblZeF/RSxbZfTbdFw1rC61wa2OM48v/ICCU9vBXmUYvkEmmhgbNiad
 JfZtVZcL
 6qFBkgpELC0twHdgzjqgPUHlOAGVKVjqIQEogfudQN8VEZv1KNJnGhomBVOUmugPcI5Ob6ZfXvtZbNviyosZfjtR9m3Oocq1Wn/yKGZpdaEY7s0To/LrY6iIitDEoqbaxoPQDgX5OKdaB6uKtTQF31rwXOi1wWSCukrRmgKTHhMKtgukGLF6mNNfNKFSxOHVCqjXfUrVhDxiPub4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Improve two below problematic behaviors of DAMOS that makes it less
efficient when core layer filters are used.

DAMOS generates the under-quota regions prioritization-purpose access
temperature histogram [1] with only the scheme target access pattern.
The DAMOS filters are ignored on the histogram, and this can result in
the scheme not applied to eligible regions.  For working around this,
users had to use separate DAMON contexts.  The memory tiering approaches
are such examples.

DAMOS splits regions that intersect with address filters, so that only
filtered-out part of the region is skipped.  But, the implementation is
skipping the other part of the region that is not filtered out, too.  As
a result, DAMOS can work slower than expected.

Improve the two inefficient behaviors with two patches, respectively.
Read the patches for more details about the problem and how those are
fixed.

[1] "Prioritization" section of Documentation/mm/damon/design.rst

SeongJae Park (2):
  mm/damon/core: set quota-score histogram with core filters
  mm/damon/core: do non-safe region walk on kdamond_apply_schemes()

 mm/damon/core.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)


base-commit: ae5fb88b410209639b49d5d271809fdb614df91f
-- 
2.47.3

