Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 960F8606A325
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 14:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QngqSkRO
Received: by kanga.kvack.org (Postfix)
	id 8F88B6B05BF; Wed, 28 Oct 2026 10:14:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 880B96B05C1; Wed, 28 Oct 2026 10:14:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 748366B05C2; Wed, 28 Oct 2026 10:14:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4CA2D6B05C1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:14:41 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E4F56A8B5C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:14:40 +0000 (UTC)
X-FDA: 85372230720.01.D945D4D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 47D6FC0005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:14:39 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QngqSkRO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793196879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hPBW/7zRH6GMUll1hA8NAc0pSWv7wG1/hRY77ehO/Hk=;
	b=qyaEsq02Gp0noRxnfl8YxcNuKhAoh4FOn2a5hi06cxXpNdp8EnHYnmrL0qGYxFizx6Nfid
	QL1/kcqcGysRjAt89MB5ETreQM2F9dX8C4tBxlGrL+uM7VXGpyMOcvmgh/KQVXwSZCm9tP
	ub6pHqH+K4UcnQ2HA/QxzBQLArEqk+4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QngqSkRO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793196879;
	b=L9nEWBSehiHVMrsiY5+C9MtvhNJr/9dsTqD3rZVawhQz2isW0TpA1u6psT6a3q7VEHoWeC
	7CYhUUXA9I5hWrmRAySoHvuPU2SC6qFJorpXMlsgkbZlZvFbhoQAaUoowv9t7e4HCqtIDP
	2A3lYZXr0MHGnrUfHU53DCHiphU/abU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 894D743AAC;
	Wed, 28 Oct 2026 14:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 400CE1F01828;
	Wed, 28 Oct 2026 14:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793196878;
	bh=hPBW/7zRH6GMUll1hA8NAc0pSWv7wG1/hRY77ehO/Hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QngqSkROpFbKx0iJsex49+S4ybLbfMAzkuqorTHIDs7qAu5EWm6H+4yPLkgShGtgN
	 eT5qVSh5xtm2glCQIsvBTFD0L+InUjEGfwZ519gp1nClEGE+60ZtlGphCMZGmpuBa2
	 CGEOtW/QggNxLfMSOV9NG6UKTAY3nS/6Qoq+HlnUy8CzYsnj2znxTMy+wN76RVq5vN
	 GB+PQP8ep9bnbxQJJ9AEoTDf+DizgRAdMFNXDkZ80m1YWyNgDWo7yixnRmFp/mkMEf
	 Mhwt69njQ8ylNbvLDODXcP2hx8lA/gRu/LKupzDE9EDeRTWcIFKyO6rICE/eGSo1AQ
	 1wAIBfiRs9QnQ==
From: SJ Park <sj@kernel.org>
To: stable@vger.kernel.org
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6.6.y 1/2] mm/damon/sysfs: put target pids for damon_start() failure
Date: Wed, 28 Oct 2026 07:14:28 -0700
Message-ID: <20261028141430.161175-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028141430.161175-1-sj@kernel.org>
References: <20261028141430.161175-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 47D6FC0005
X-Stat-Signature: c31t78omsofnr7y3uhsa11yng9cjkaqp
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793196879-281790
X-HE-Meta: U2FsdGVkX1+4TG5SF4YE7iaNkiiRnSX2H86Tq/qT46cWj6DT+y6j3BDVDpAPksv5cdmXLtHW3BXnJeEKBrFsQ7M96nJVVVIcjLKlX8RuOFAJ366Hsab8Tjun1T+c9xxfaxnB+L0+gObzAZf2iPBAZUfNniLz0ONcQkQ0ktYuzOZps1RiWPd/pwWqgTtaqROo1nzrpk8Rg6oZZ5rLAmEz5fPqQoMbazvFp5mcqxFeUBYCFn+FtYLYT0neoFgD1uqfl316G2v1DF6+LIk3mPLFXki0Cb12lzkrRH87Z7VM0F+qnDigtgWYdO/c2kScvv7tkdDfD5lZcgl8oK3Kxgn6/+7pqe8j8pY4sEOsi4FlFKzpRiwJv6GPyJ922sSIJ6+xzswztQ1EonqqYn9/ToswZPyrBKOVQNB+5Jz/T1gbX/i2r1sjevc/+JMXZsFfh05KgPtSS300pMtgSiRNPsmCMWVJf2yMpZ2kLLE06IV4i8NKuQjwRw8m8q0eE3vEEEO33D7B9AImUj6IVwhK55c0xsdeL1rTXp6y+2hTAVlTtQH8FmyZFgpXmQhj5oedQ88I0P6nQ+FwRTMGP0mvGVSguZ1XI1OGll2TY2zX7sBUW05umjviTTrQeB20OIpT1MrWKHzVyPTlsZs1ZcTbhEKh9Zco7v5BjemukWlTw0DEjMOnLtQzwznUKkkvzJjbV2+13Ew33WXDwsxofJGvtVzRNfr9rvn5IAL0/absktKpwDk+m8pRjCkYSxsDzufVwW7+zNonS9EHKRt0I4XzoDa+8SwCYb79xGYDaKbZ6tF0Gmk2JqDYHhxSvl754WNFz3LOsUvLuafx3yF5Ui2pfMAOFsxZLtnUO8Ki8Fnj95BLBnRiDVyRv7KNTpgU+MZ0+NScvoA9PobuTEX1PLcwVLw3YBSTQVVWlga08ZLxvXivJ3RehEEWd/a9Jpyb2z9fBDlVdgDDlX3RPkk+WDkZvdt
 7CoUeTjT
 TI890oamq6XINY1AYi+Ebn8NCE0ucHG+budoNkqbdGfmCbBLHOzEfG2ytA6V+Yw0kpfjpAZulcZIf/LZjjoi9rk51yUAfTcYpAP20+KXpLuyKA3UjVFt6Amysd32VwEV00MKTyDw4/j1d9nrYLEhgvEr8s+mzne+LZ1HSVxXjYFnUtNNLiK2y0X66s091NfwsHHGiuaa9RBLuzgEoOXFAVyLERT/0vytbD2SvX8ZM+UXfBwKiUfz+KEafArVNOvnrN0Zy8AiVWts1Z2pMBBBUhwiEHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

damon_sysfs_turn_damon_on() allocates and sets up damon_ctx to start.
If it is for virtual address space monitoring, the setup increases the
reference counts of the target pids.  After the setup, the function
invokes damon_start().  If damon_start() fails, it deallocates the
damon_ctx object without decreasing the reference counts of target pids.
As a result, pids can be leaked.

Fix the leak by putting pids using damon_sysfs_destroy_targets() before
deallocating the damon_ctx object.

Fixes: a61ea561c871 ("mm/damon/sysfs: link DAMON for virtual address spaces monitoring")
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 46980a4bef23a..d95fda1054a00 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1465,6 +1465,7 @@ static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
 		return PTR_ERR(ctx);
 	err = damon_start(&ctx, 1, false);
 	if (err) {
+		damon_sysfs_destroy_targets(ctx);
 		damon_destroy_ctx(ctx);
 		return err;
 	}
-- 
2.47.3

