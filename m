Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2E8EFEFB6D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:06:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7B176B0005; Fri, 27 Feb 2026 12:06:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E52B76B0088; Fri, 27 Feb 2026 12:06:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB3C86B0089; Fri, 27 Feb 2026 12:06:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C60F26B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:06:28 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 75C36C2B38
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:06:28 +0000 (UTC)
X-FDA: 84490865256.07.2F4AF01
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id F043A14000C
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:06:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q5SzMJfe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772211987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UtzWZvDgY8nb8nuN6kV1r1EN9iykf9huXOZHZMAKxNU=;
	b=cA7wUpo+03sgAJau6y/3mfo4MvRKvMHlqOA7vvzSesbr4nrXfEoDLEHshyEba+6ooUCHIN
	hAwQULvBh8t85o+Oag309H+8zgb6xJaepwMGKjtaei5zQ+BLumsx/zMJPzbcF7Hq0MTKh9
	HARyt4OjWBIzQzv7Y9xo9tSQ8CqpmQ0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q5SzMJfe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772211987; a=rsa-sha256;
	cv=none;
	b=gcOVJGstufjJ/kSW/KASe09kwIwSqapb2iyeff0oMGbGgOINxK6VkuSXxRtCJ7plNJrfkX
	M68PuAfHQSNxyvGVNw3q6rxY6/GfQ8C5FKtT/+C2oX/3HpSlr/0EseqZN21/iZ04ZCjXyt
	KAyiHXPD+yudZd0498hg29FQhG7RADc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 53A3D60054;
	Fri, 27 Feb 2026 17:06:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D08A1C116C6;
	Fri, 27 Feb 2026 17:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772211986;
	bh=gOPUWgSYxPSkieXO6bzAOQyk0dTjUJNdnhpqYAjiM9k=;
	h=From:To:Cc:Subject:Date:From;
	b=Q5SzMJfeKxpI1IDH7ZiI4vtYCqHXxgRoBrYerZL6o1wCsQ91az3Ek5mic5UBnr35b
	 g5mKtnZRt7C9SpCHiZQziYVLBERO9VBoDLTSpN77LgrZwajRIiBy2tSVNxBCorZavB
	 xRrl3Du9dAY/sBS9dhfOxhL34u2Fctb78aSqe9uY0Yq+zczrQ1DEosjZMaOCl+oQhv
	 RUz1R4z+H6nFhq4vKaiG1Jk57FttwPEQFTdqpOjVJ48WJUgYpSMD32arGh1twmtoFa
	 WumVr/lB76r3FgQQ8GUdlCpE+pJwuAQsxHD4yQbiCys67MAk1k8gr0ZCYfQWIFtR6m
	 VCj1wPR1m4bKA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/2] mm/damon/core: improve DAMOS quota efficiency for core layer filters
Date: Fri, 27 Feb 2026 09:06:19 -0800
Message-ID: <20260227170623.95384-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F043A14000C
X-Stat-Signature: skizzedazuwao5afs89z37h1ceykiiuf
X-Rspam-User: 
X-HE-Tag: 1772211986-329901
X-HE-Meta: U2FsdGVkX1837pQMPOoLjOSbp5t2BLlSk99+P62mmbIyqkmLVzZnIUnm/Og2mM2YIDeaoYrfMQIeAY0VaR2JLiIM9nWJJgoVEmgUMfZBYEDFbITOklodpD8mfBkUfucnFbPYnjG8vr+e6vfvZqjrLlRqb+vnA2sQFXpF0rarZVuClkqe+4MIxzRZRHdVwp+htrlF0+/ASJB7ZaqBTF6Ca3O3liZ7SuM3NXGScLZLk9pw1Q/WrpzW/gm4c7qEBF4+/I6cdj9wVd6elgWS2QMB7Ot6zP8rTkjON9frIAgJ9xE4Qk7khExMd8k/pRSioJza/P3hyYMrc0JrAPES7j0H9zaUnGr+KwZjwjBCH89vYGCAEC4h58nj/SD/iTXZKc/jA5dx8JKX2n1Yhp2b7CB7FZQGGeaLMnzqPNocOQWvMBsHXTnlutIGuku3YYGDa/u4RSls/xvaDOEO+NzwY3JQAeS5kCSLItHW71O2xOwP4PZw0fNUwnLBt5JWLXYx18H63xrtlpR26hsCxbgI7yP8WCzlnTjC73zWtPYRiOb11cSBvhHXe9J5a1N6jrW4r2OvCN7EbXGf6wm2nrXpDgD6lG4MT3bOVyRdJAl/INGhsBwDmv0WpRJMMK9jiUY4lpDVJy1cXFWZaxQnobLRXlrLa2SjG9D4LOux8lVPws3F6erlfif6PRL1AR5qD3yy9YWsIPP+UFez/d6+inMFSAL6ukP1jOlYz8fGBp/mH7wNLE5IhfPQhpzh4frs6+uESlgEXGuUzrqkKvdzmNWDOfqpM1hpjP6kvEtmfXja0CNPXFM67PrxlrNHkD28BBIbG/a1YKM9+ysWjFser5COXluXpBKZ/IwF9zRiDFAbltVJ78Ugwgm3l+55x80ho1PSs//2/1aQYu/arzRMjK48Kmw3qTOPlBF290yEbJsbh9Tjuj7gnsiw/e/MyDQ7nMUo1XXwK+e1UmQQJqQIXLmtq8B
 9NfIHFH/
 UjQFLQVJaVVk6vp02dZpsgIskiIgQJ0FAHn+LFbGOiHQKRSaNciDbKIudBr08QCfYUuvuUGVgE4lOh5RuCMPXxAfKNvXNSQQ91kB+jpgDZzjgbtvCce50duK4qvbHaN6hJBHa9MfX1ZN8H9ZQjnBgT/GpiAY6IQWzErrYIAD8lx6tIUX5NB8CSx3KLk5k3BUfQTfh105AlD8tY7Na2IexLFuZ/Us8VhsSighk
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

Changes from RFC v1
(https://lore.kernel.org/20260131194145.66286-1-sj@kernel.org)
- Rebase to latest mm-new
- Wordsmith the second patch description

[1] "Prioritization" section of Documentation/mm/damon/design.rst

SeongJae Park (2):
  mm/damon/core: set quota-score histogram with core filters
  mm/damon/core: do non-safe region walk on kdamond_apply_schemes()

 mm/damon/core.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)


base-commit: e264beaf78369f82d09a8845207ec2479f0e61a7
-- 
2.47.3

