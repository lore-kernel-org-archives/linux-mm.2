Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 270F3CAC587
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 01:58:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CBE18E0001; Sun, 14 Sep 2025 21:58:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 205018E000B; Sun, 14 Sep 2025 21:58:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F1B08E0001; Sun, 14 Sep 2025 21:58:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E4C508E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 21:58:16 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9D14186332
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 01:58:16 +0000 (UTC)
X-FDA: 83889824592.15.31E1D2D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1C0CFA0004
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 01:58:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZSIXbF3H;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757901495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HOqbBgATsgkiNjljOq0z+jAMYENNMSO380m9PEMhE7E=;
	b=vivXcELNxFypxWWDA50oNmn6sJlaxKrOckWGuYvG1bS7IiSlI3gKI+4bVmi7r43eWAChcV
	mEnD7DEEujyuh7hQ9S14Gck8p1XNWq4jYzquokiZuFoR3i8HLvnhkkaj7LglD7xAJQCQxA
	HqhKnjK+nU/835f2InuBzowTO5tQqw8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757901495; a=rsa-sha256;
	cv=none;
	b=J+t9wJd4TOHYRlh+KQIXS3VN7KZqN8W361HC3XjHWgt+mB8A6Z7WLL9rlKJJTTsqKWBq19
	hewcC8jJfGJL0PbDTNKajKNUhKPcQpXmjBs16sIFn6bQNfDAwenO0m9834E6PXnM2VRf54
	8gQGdDnJ99MLoxqlu4D4A4QyyrZWYzM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZSIXbF3H;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 93F86601F7;
	Mon, 15 Sep 2025 01:58:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 364D4C4CEF7;
	Mon, 15 Sep 2025 01:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757901494;
	bh=lwwcDoDvfbiO59qIbS3KSPJx7Imyoi3zWNGgCLtUpbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZSIXbF3HQeUNsua7xhtgFRxmM6uwD27cHJsPA39zVIJ/+b3Ow/J4bj0OOcEX4fJ4G
	 Y+XpVVmglbAYHNkFqCHnhQU18w8/VG3Q5/hEmJDoRjpNFBW7URJ1069oRmhd0/Ia2/
	 Z7ZW8nqBQwozDkEZrLk6VcJUsvdzrDCpNlO7raHromB0ltWaAI7bx+bEUojsG91SS4
	 F4ZcgZ3YDVafcHivFxGBBPSvOV2/pmgQsoRvkR3RR+OZCtezxsKQLiFqLDhWyQVM0g
	 jrnAT9GqKej3Z0pySZC0hFxbsYR8YnNAdBHE8m0HBH9rA/NoXUYwDzymi63vEshrw7
	 J4p0cL7kj7BXw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/6] mm/damon/core: set effective quota on first charge window
Date: Sun, 14 Sep 2025 18:58:03 -0700
Message-Id: <20250915015807.101505-3-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250915015807.101505-1-sj@kernel.org>
References: <20250915015807.101505-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1C0CFA0004
X-Stat-Signature: 3scc6inwinxo6hatcahpwrdfpgfk4utu
X-Rspam-User: 
X-HE-Tag: 1757901494-931395
X-HE-Meta: U2FsdGVkX180MW/BhmL6E19xVJey/yyJqG29k2eVyJLCz+CUXUWWW2A9SksAxsx0AAbTvMKxh7qjA4CKgoPv9CgHP20EtY8ctuLpa14EJ7UGgcvim1Fs7cgGA00Dzt3wEWZuTy1pwSWzY6lIxXp3pfNHl4tBpzI/wSkHb8hoQtUQcL2zh6152JyVkxdMrs7lJ8N4EqbJ9HNPRUR3b+lth9vWQPd4bCmMHlve03wY7KvhpjsIjrK9iDpTSV+iNdnUaFTErnodN0/2JGR8IkhWM/mn4E/2+chyQxYqCA3jNHGf6u05yBImJ10AvJglepy+KggOkfb7xFYgUKaSJmX7NSx2TA705eFSGUovWeMaT0tqhiv3KsQqDEme9ELxHCnOrfeL/NvB16z6pxdfqRmPuk4HQglDX6KOl6hiI6KJZB+6Q8/I/b4kC4EesMsJ4mBk+smqIcnKwXqIAH4bu5TBsTYVmGHOjOZdjJw9LkxmqtyGR4anQFUuyzxpEuCdinExyy0q/kawVgiZOMVxjNqp/XdW3o6Bo/gpFor1IcBKzgbhtWqqF8xNSerArpunksLXUpHx1apkx/Er2LF1LiDFbmeSGPLtwRvggboeVRhy1wOUrOj50yJKsDsjLwqLCxFPle+jtB115SKyTM6pdvY/COp7nB6BwoEqmJF+Fq2rmQ0SiHEi0l9amXMiKiK1zZ7VbkvK7ESmLync2pXCvP/FMQ8xCSuDcNZYo5ZXvu/Rj5l2thiO9HdHx+uDfqIE+/7yNGXEWiGeegjgKmw5tnF0a+0a+jicthxvBdt+obzuNPFkj5hyL/c9BHI4Jo3YwEpXN042dIdgwwgJRj837Les5+fbDjUg64H7YS66eyu7rKd+A/3m7fLCFV0CJjbUYfQV6lLHkUUn4uC6A5D2LljXbMuVRCr77hI6N4v1YeE8qTmt3q18m+MtDR6eg1WI/xz88f/2xLnOEj74fepOMFw
 6BSgovMY
 E2kR+qgd8EmlKEWwdInbexs4OiRv1YeN3cHHXxjMFaka57M4mHYeykHn5K5GqsKnu7Z0M6WuK1ssnStYO8+3NHzW3YBi7ZJGp2AsEWrpm0Y3XrbufrOyIuivyoy3szdU9IYN08LmAfbEQJb5dO75BZFM32XlG4SjZdqJ2Qt7ntxdIH++7n/N4vCknsC+1bV5dX9Qc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The effective quota of a scheme is initialized zero, which means there
is no quota.  It is set based on user-specified time/quota/quota goals.
But the later value set is done only from the second charge window.  As
a result, a scheme having a user-specified quota can work as not having
the quota (unexpectedly fast) for the first charge window.  In practical
and common use cases the quota interval is not too long, and the
scheme's target access pattern is restrictive.  Hence the issue should
be modest.  That said, it is apparently an unintended misbehavior.  Fix
the problem by setting esz on the first charge window.

Fixes: 1cd243030059 ("mm/damon/schemes: implement time quota") # 5.16.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 996647caca02..84de1cea5440 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2142,8 +2142,10 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 		return;
 
 	/* First charge window */
-	if (!quota->total_charged_sz && !quota->charged_from)
+	if (!quota->total_charged_sz && !quota->charged_from) {
 		quota->charged_from = jiffies;
+		damos_set_effective_quota(quota);
+	}
 
 	/* New charge window starts */
 	if (time_after_eq(jiffies, quota->charged_from +
-- 
2.39.5

