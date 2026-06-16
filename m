Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B72A4CD98E1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:06:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0B366B00D7; Tue, 16 Jun 2026 17:06:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8A776B00DB; Tue, 16 Jun 2026 17:06:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C04336B00D9; Tue, 16 Jun 2026 17:06:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 933C46B00D8
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:06:15 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6613B1C0CFB
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 15:09:10 +0000 (UTC)
X-FDA: 84886108860.11.9F6411C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id BB8E68001E
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 15:09:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C8qFnTPQ;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781622548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7AQfxYHOzLeqiua4ZzY6THHZwKua0+qCtLmY2SG4IcA=;
	b=NQKUhfFOfVCjBUtycqbtb/a3H5i0M2GyGxd5KBa7Ha6nsjsbsrhFLF2/mrOxuvKXxnBSN4
	mqyn6t2FYpdNaURjgLZub2toWcljMOz8ShAkJwf9FpNd3H6jGfJ3yEXOsGxNELNdK4KjAi
	2hQ1HIQmQOySks3ykPu7f6S6ZDC6+uU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C8qFnTPQ;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781622548;
	b=ka+ZOTYp4gvs8+rZcm9tCM5uERBhom51n9/bNezaz9wJbT/mjAAkwxZwBZD28WCZtre4Yz
	7SYea6/VgW5u3kMoGPfW/tjPagaX0YorDvpSVBnTqSpOQpyoUAbCJE72ARwo7injs1BUHa
	B3fAPoxD2g9M3ayM6hIDoS22W01PQWY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 15C73402E5;
	Tue, 16 Jun 2026 15:09:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726251F00A3E;
	Tue, 16 Jun 2026 15:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781622548;
	bh=7AQfxYHOzLeqiua4ZzY6THHZwKua0+qCtLmY2SG4IcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C8qFnTPQ0UjZhyH8ZqOwp+E8+pzyc75j4zvRxPXzpo9zAkIdmMbN17EUQ4Y3REjxY
	 SDtstjPx0b93kqW2PZo1UFYDw2CFLEV1w3v7zZ8wEJL+j5jXMVtspJtXjyAR6EPVtY
	 bpeI6X15JbXGQ22BCNSTzY3FemkH9O4lneLKi970oJXPNTNkYVPVeQF9MrBp9Jb35l
	 INZuAlznieU1xmF5Xwx4AHOzcq5QCUY8gpHnwnwv/5kK16RPxmyEBnzuuvEz7S6Ccb
	 OgUFKFIeFlsfc6d00y24fg4S1iCLjmkGxbSy4/1CoxKxlq9mSjdOyuzkzit7M1erBs
	 G7REw5bPAPHVA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 9/9] mm/damon/sysfs: kobject_del() probe dirs
Date: Tue, 16 Jun 2026 08:08:43 -0700
Message-ID: <20260616150844.88305-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260616150844.88305-1-sj@kernel.org>
References: <20260616150844.88305-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BB8E68001E
X-Stat-Signature: sir3x1y8m96roy7y5aruwi5f5qb94sas
X-Rspam-User: 
X-HE-Tag: 1781622548-194456
X-HE-Meta: U2FsdGVkX18cvYt5nl5Qps+nc7JAXSOjQ9Nq+7sg8917ClwSmwOVKq7ZSe4kbB4mCqczPpaC/tCK9GPRaO6ulkZJbT+E8jPSUxHg7Ax4ntTVKKm5uwmZyBVDc+fzPFSBgAaj8GtWxz8ujyQ7m84h4Al1ZqEJy/Le0+am8Jsmcz03a3P+6nkKXkX7duFDUL7UzaDPxVQ8bVGZNoq50wMuQ8gqo/LjiMpzEpFvwMmOCzRrsBIz0R47z0QaEF5oj5TZCuXgwCbAvKk1UQfxv/SaKO/48vaCmwQ7SD6AXOxcho4dX10dXFWfyXqo6utzRIrzRvMZGZYXueVfjrpe0pAT5IrJEG8HOQhmCAOvTH3ePpWM1ua/6GMI3kt21p2JoIhm9LxZpVmGDycZ4uNPRKTyeQz50WuvUVmRz77Qk1BJzbmi+dJM/zv+WRznXJvlyz9tVPU9pT4alVK/9jkyJt9rkbIZCYM2GKRxNqr3L8oBGHQh5mm+irMcvQomTwMyaCTFtLbcrlookBJIIkKPlpoQLgktKXFFhNTh2gz+Ezo95Xqihsy9QmQfWnULfvUxVpnG+3/CohKVVveKu/qouJaomwieBo7xyFD7ibsiFoqR96WwoK3QLhUhX003qZsaXr4YTxMkzghBHIP+rQ6WF9hg9rXZPoDBuCrTBf6nIfw4bqyjvDCPzgX2ieXUllEdm4bnrQfT1Xz2ERrRrOb+D6R+28JOitOLKCTiZU41/ZBEgkJlJErNK4w0ljvcphj8RDR8lffH8t5Gj9LzeDhkK4evyE2PeAiJADk74qhNHufkmK3XsOth4EguAeJJ9/nzpWBtw7XzbsivOyJPepMAGQD5+ZnUpmpvqTDdy+RW63cVp9kJgdeLlS45OxJn9fGA/Y4V97dW6eZSDFqB/XTjq15+5gYrFu5Vvdz9rFWD14hhU3zibNx6WpzpdaUirdb4zB2NcR3N1DLAas/2cn0kB8d
 VSS2LrkJ
 pHx39qsvgaKOYJ++YWPW9E9CowLyWVe45kipWz8NrVNSBrRaMpYNPESIJpb0PLdF8zJPzhh/nz+8WPDZbyBhZL7WTN1rVJu2lNj7FXQ7zFQcp98lfH8w0RW1mH9zW1XDSXloyRnilif/UgASkZlv75eeSuDUQkoDPUyKQzlr/ReDvmf/nV8RDC/Z2GQfRvZQ41+QwedzEwk6dvD4RfhVjId2XA25XrIAJ87JmteBizz7dm5xNVy9XDrzWsnQIqyG2IKX/Lb0V1G6lpjM/G2htQ5rrJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts. Fix
those issues for data attribute probe directories by adding
kobject_del() calls.

Fixes: bf3ea3d30880 ("mm/damon/sysfs: implement probe dir")
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 04725ff3d9f3c..04ca0a34e1206 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1139,6 +1139,7 @@ static void damon_sysfs_probes_rm_dirs(
 
 	for (i = 0; i < probes->nr; i++) {
 		damon_sysfs_probe_rm_dirs(probes_arr[i]);
+		kobject_del(&probes_arr[i]->kobj);
 		kobject_put(&probes_arr[i]->kobj);
 	}
 	probes->nr = 0;
-- 
2.47.3

