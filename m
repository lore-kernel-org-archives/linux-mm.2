Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F28ECD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 14:24:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A73C16B00A0; Mon, 22 Jun 2026 10:21:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FCDE6B00A5; Mon, 22 Jun 2026 10:21:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 939B26B00A6; Mon, 22 Jun 2026 10:21:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E66A6B00A0
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:21:55 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9AE7A401A7
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:21:54 +0000 (UTC)
X-FDA: 84907762548.12.5FAE6E8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id ED15DC000E
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:21:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="O/gsGAEn";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782138113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vYxKAARUNBtbGSRQbbixuaBWR8GWiG7hC3Axny9Vo6E=;
	b=JbGRg3fOAZRSDOZ9AxOw+5sZrZQ+E4MoSYRmWEvtVBU02lWzjEXVGAOB2noQ70dmttNs37
	azg2nCkpvwuYGHFdUd6PmCEgSn2C4CoNDeBVJnKQ09JO5s9yidJyHxs46bEGIMUuMjHOvL
	la/ZD/EVmnAocrpKBydDJHBf+d93U/o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782138113;
	b=Hi8K3UbeH5l5c91Onv7SowezdBxySmoWLz9KIgVoUzviwYTgn7vvJN3hXhVwaTgwmmGSNi
	3O86LCotnK4G1NgKMrrrijJU4cuo2S1M6lLkDpuHPMt8BYOUb114qvlOPui9iDJ+kCeT2u
	/ilQ1Na9VjedL871zAjJtRrjBNJ94MI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="O/gsGAEn";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EE0BF4450D;
	Mon, 22 Jun 2026 14:21:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC7521F000E9;
	Mon, 22 Jun 2026 14:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782138111;
	bh=vYxKAARUNBtbGSRQbbixuaBWR8GWiG7hC3Axny9Vo6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O/gsGAEnXlSwNYVDUgTYyT2hdhwlfwt/Iv9ZnbcnNwYNjfkYlv+kvws666V2jPyq5
	 awGM7v/K6ob7qeo32zuOefsUakp3DX0sbyfiwzcRR084kFhnIwUMSsbHw+mElnoLzX
	 E+28v+qIrUCDwMCda/NMGGoTIm+ajE1EQxIbqFhOwJ4ZDNWb/yVxwn6d1AMp48Fn7r
	 ywyJI3WVLOtBoBzUcvYKzM+1uYqj3JGj2OA1CBUu/E9FGVw59fvAvygAQkfbyjiMDY
	 9ab7v8gNsWc9Lriv4ihnq1D047BGtaiR2tatzmfpemwpLcZVIc2nVWnk2A8kCKieDy
	 pgwxuVoYL+1iw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 04/18] mm/damon/core: handle unreset nr_accesses in damon_nr_accesses_mvsum()
Date: Mon, 22 Jun 2026 07:21:24 -0700
Message-ID: <20260622142139.30269-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260622142139.30269-1-sj@kernel.org>
References: <20260622142139.30269-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: ED15DC000E
X-Rspam-User: 
X-Stat-Signature: asbpc518acr3bi5a5mc45ewppj81767y
X-HE-Tag: 1782138112-866895
X-HE-Meta: U2FsdGVkX19MWYsgr8NBV7xDKnopOwwdLfyU7FsT8BDpeGy/dY9GprctymKzyJ3AV1BBr/UFbJZi1rcGVqFnP7Xs3mpIPcKJFYCc4CIWrKgEBk0x95Wfp2UfRbOOYMKmW3SVe4NCQqAn2GToF4fTXt6oTeKwmikoeeHUYaffg7jF9tw54Gnn/HJRLDx+Hhk0+qekmBCTu4E/onjvVjY6umTbr1DX6lSQWnP37Fzy5llnrBDZDrNuzsGVcF5EjGOwU0pRwb05pTO2JmS2Ak0wUO0BgXdp3ssH3StvRHy+UN8MAjc6nFE9wcL0mVfLPzF0NbpPQ/z1uKLDovC1I0GmMxiP9o+CCTMiP6i8jQPpuIirf7/mWZuS6k+WjNQwo7urhHIwjVvjxq2paenJw840zSVqBzjWdNIIDFrUIsC2oI/hEYzZIAAa5GG6kI+QSmk8MOEsVQA2Tl5HEutXmOYa8zzjaSI6aJKoAqNnbo2IrU5wr6ZweQAZpzya3wPbCq3KzNYyXgtIXu667EEVvv9Vw33nm3gFOUmQRAXfyS1jSbVHPQqRE59FM3Z5tn3mqUh4tG/G1Gh5fDBIQNjMDIk07NFh8bA7lUmSbArPuVLTzp/tHsKWll6xWe1Nh5RZ4S11C+1XHqZLTvR8SGNdgeMbUm84gjlyHYqgKwk+J48CEsCTqrkEm2jRjuaZHPirf2JJelBX/zQsZbYFSJuHv2+jAD/ggbmvfVYimuVxWKuO8jGnaLRQEAnlqy6Vtj/yuP6R+naXJzI0wV6hdYNNBIuojKVK67biqaJJndvsaLEUxSyIHHi0LSRzpFWprjmgBAHVgNOoFlvCrRsVNJgDtQ6Myeyqf2HGw2RkHtav1tvlCD3Gl5q5oU0ijCZXYjRfGpB7idnHqQZ4XdLFMylrS8rpeEDcdBrJxB+rXjb7OQ8+84ie7lXUd+WWMNsCYLkRvha9qsflaVoH9l9dIwa5e5P
 asKGpLUR
 EJrzsnBlrCCokPklSYOAxBL4syRvplBY7NvHFP3c7uN43NrvymAAwPz/cU8QXRBvbDG/HRj28vQrQJmmxKm5l/j41KUarAWL40PA9xhdscjAPVedNDmJ0jaeZaLfvmXvxkbERexjhEunT4FfxIgX/V0Md3r3GK7eU7BRONrX61rP962UwGGgFTKBO4N5sMuKMx1PnV2cQulTLT1yAZMcb5XozGCsrzSBD/kGUizKdNSHSnR2az1i8ArW3SvFmkGfWLr3DKL0+5zzVbOH1qGw7H2fqdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_set_attrs() works like reverting aggregations that were made so
far for this aggregation window.  If this is the end of the aggregation,
however, kdamond_fn() will do the operations at the end of the
aggregation interval, using cached timestamps.  For such operations that
rely on damon_region->nr_accesses, damon_update_monitoring_results()
doesn't reset the nr_accesses if it is called at the end of the
aggregation window.

damon_nr_accesses_mvsum() works with fresh timestamps, though.  The
nr_accesses that are not reset in this case can make the logic to
unnecessarily count nr_accesses, resulting in returning
higher-than-expected pseudo moving sum nr_accesses.  No code is using
damon_nr_accesses_mvsum() yet, so this is not causing a real problem.
Following commits will add usage of the function, though.  For safe
usages, calculate the pseudo moving sum without nr_accesses if the
remaining window is full.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 191533685cf2f..9d501ad34f44c 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -268,6 +268,9 @@ unsigned int damon_nr_accesses_mvsum(struct damon_region *r,
 			ctx->passed_sample_intervals;
 	left_window_bp = mult_frac(left_window, 10000, window_len);
 
+	if (left_window_bp == 10000)
+		return r->last_nr_accesses;
+
 	return damon_mvsum(r->nr_accesses, r->last_nr_accesses,
 			left_window_bp);
 }
-- 
2.47.3

