Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02E93C61DE4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 04:34:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFC3E6B00DB; Tue,  1 Sep 2026 00:34:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C10736B00E5; Tue,  1 Sep 2026 00:34:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 978C56B00DB; Tue,  1 Sep 2026 00:34:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5592A6B00DD
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:34:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AE6BB802D7
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:34:28 +0000 (UTC)
X-FDA: 85163927016.10.7C42633
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2026E1C0004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:34:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lYH3zQ5S;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788237267;
	b=JqbGntlraLY1Ut+8OD2D+8wY4Nt1X12BcRPuVcd25L58WO22RYS1kqovbU5NlM7SD4Xc59
	oPBFJgMwsMV9KkCiLAJo5FroksNMzMNKS1ahbkIPMplbLMwjmGULZckZZJwk5ScZY/AJt6
	T9phP/5W06gErFN+b2XsJGVuiGaSmHc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lYH3zQ5S;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788237267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=atWhsqWAE5VXdJdWplOPI8OSXhIZpjioTpYT4VKG/08=;
	b=ZxFWwI236UnFq0QQ4LgG2ghE2WTuERzbQzU4wocIeyCRM/8qU0+l2KgTHrzYlpsxVwY2B7
	bE51BOpnusoJ09VoFJvtoDrGaiJnsHH3IV5M5jZZKbEKH536aPZayTkwo8PFNtgJjbuk/M
	XWXDEQMB3yhvfKhC9QLAKA9ZWQJds5U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2EF784013A;
	Tue,  1 Sep 2026 04:34:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E065C1F00A3E;
	Tue,  1 Sep 2026 04:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788237266;
	bh=atWhsqWAE5VXdJdWplOPI8OSXhIZpjioTpYT4VKG/08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lYH3zQ5SYuwmCzVXw1REpmSNZgFjVOsByf6Q1uK0lugnPZhdQWMzCHvyY4kH+Z3RV
	 oUTL0YnSlkcmSj1DGoGZf9ya/a2JfqIoPPNpD8728FfC1jeYBqLMx+rBC6IeufIehi
	 o+8xoqtqOA4nxI6KoEJV/Sfg3TcOUNXSGHaNP43tBO4ZuFQT490Ux9Mkx3nKVGHYxa
	 Ce8sCG0hmz/9kEgQw2dDvqoPTCFE8dVqYplQ0N/VaiCYFlHnV0Dbi3oGkZW7fz7hE0
	 i2KaXBCGMPg3r1qkYEjM6n6PjJCwG2T/OWYkMjAElBAb+dgRFH4otY681Frxkf2hVF
	 qgwyMFxfkeaFQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 02/17] mm/damon/paddr: support PGIDLE_UNSET probe filter type
Date: Mon, 31 Aug 2026 21:33:58 -0700
Message-ID: <20260901043417.2165-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901043417.2165-1-sj@kernel.org>
References: <20260901043417.2165-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2026E1C0004
X-Stat-Signature: mdybk3fdykpng3g39s5m8aupmtyzbpxo
X-Rspam-User: 
X-HE-Tag: 1788237267-404460
X-HE-Meta: U2FsdGVkX1/StdKAAjxtIe1cTI2Maf5e7+lEBpXTGaizG2FE9R5FoSlfNZnJiAhS+rSrrCf4EJ1GWbHo+N8L2trtWtQwAALQ7/FXU8Qnjw0oxdTfnnmOWBJmAsMCWpdar4PXvTGBtInQMZ3CFZF/LeY0ibQmdGqj2laeFDDtqC+x+O+CKrpy5l3dy+HkUxBOxZNtg1z6aZoA92lDX2Nzm68xkjGhqQrX/M4TUFUHhXwM+8OeneZKzXlt3Js6denuCbdwMfmDR8EnicqeeTSlWjBvFUl2cK8W+ZlXeeJbaASQdoac66LeVcdS9UJbSuQqb7QYaRcWUtzrfopX1rs7oS+3XX8Ms9MpRTkPY+rZ7+d6itLgyui9lw+8+f057lodOutv/idS8FrCc1sLH+BYsB1OKEs7Sc6ispSnxaTsqVJ4YKxs/tZMgN51LIGc7xgnVPwiGgD1mZMmsRvdRlg/jqEmpUoQYZN3Z2PVlkxys/ojO4XeAhS39Lb/00bB4UzbYlIPoz3ViEbd+fUIiVixqzCBoYeXD3cMN6+//a7Up9bNe/gbt7AEorGzdrLZWht0zENzenRt8RDri2DfZ/35L3YtwZRNP9W68NAIB+BUxQIOLl7xp3x3bwjdo4jD6+98FumNXAv00Y1+Lny6kceHg37MJH4DY0XgRyadeFuaIUxovfVJ3Ed718ZsXt0heppwF8f/m6T8EpIKqxFTF1azTu0NiuEX1ThUOPX0SKGfOFV/Y2dZthyn5CGEnPB2UiK7RYkG4I/qbqCnX+Okkv/9M8LcRaYojG3d/g6aZju9jEf/LM3KNanC4kwHsTze9kj8VQ2polmz30SMtpjRiXymgpuJ+GhDmmT+JXG96vXYQNbJ+ohxCnVkdtYjLyKW3c+T5m+BQ7uhY4dHVMD61PIHlGKVSD+YOViWUERCU9BDGTq19fca2xMJeQ9ly9TzhJ1KbF1f/Lk9D3u/g+ljCIB
 udObv1/b
 SSqmBVem0uWtqdO4oXJunngSdIuexGbymaRj8bAnPnxtu+qJbNGUu5VOtdlnHu2LZiY5y8Qloi3rOtuP8atfqAUjc7DGaCr+YcPMwSdJha8pW4yPw+IxAtPzE/tkmVKA4EmPdXuNTLmxgvhDiHNf79PlKDd52csPnnot68LWkWt54EXi7ym6zzRvdd9zZwi8YeYguudtMHH+1i88WhIgj46ZOFGAxffsAK663FsgXRuUCgw3CQWZCzsvfMuxRn9uV34fjJe7DM0hX1/90/lMUUxLDWUyPoBKUtfdCSMAKuCdYV80=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement support of DAMON_FILTER_TYPE_PGIDLE_UNSET in the physical
address space DAMON operations set.  It reuses damon_folio_young(),
which was being used for access monitoring.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/paddr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 9ddd1ec8202b7..6f756f8493894 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -132,6 +132,12 @@ static bool damon_pa_filter_match(struct damon_filter *filter,
 			matched = filter->memcg_id == mem_cgroup_id(memcg);
 		rcu_read_unlock();
 		break;
+	case DAMON_FILTER_TYPE_PGIDLE_UNSET:
+		if (!folio)
+			matched = false;
+		else
+			matched = damon_folio_young(folio);
+		break;
 	default:
 		break;
 	}
-- 
2.47.3

