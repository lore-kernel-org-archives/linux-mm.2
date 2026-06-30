Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53F0FC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 04:08:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF0D46B00A8; Tue, 30 Jun 2026 00:08:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B99156B00B1; Tue, 30 Jun 2026 00:08:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EB756B00AA; Tue, 30 Jun 2026 00:08:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 54C556B00AA
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:08:28 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9203D8D0C0
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:08:27 +0000 (UTC)
X-FDA: 84935247054.05.E33251D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0D648100004
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:08:25 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kcr+VZa0;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782792506;
	b=tCRmOEmeboefgiDIG/1J7FGZ9OmNs+Gwfonhz2yar/TGRUjvlgJAvILOdEkBmdeTXfNdc6
	xiwtY836RwwsydDS9nTaF129x3udvtf0L/QXPQZaZU3J54WLeWSjEMeW0MvmHNC1zLB+0v
	T6L5GkQivUeEIZj3/22BfBrN5EV9nK4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782792506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CUnTNnIb74vuucSNXoGi9/IfHGsNCXgoVOsKdS+73Y8=;
	b=SX/aEMUQ8saP4d9BnT/hSzLHOm5noosQTZp3NCngCwFSN22LSqo8xSvlp5nRk16DooAqCB
	h60joHWkXg76mKu3/QQriBgFL/f+DLa13E6A2TJE9JG7YD0oPnhZ5FMKUEhG6rbyDy2H0y
	y30toozGTe4aPtMLu2iqV0H+ILCHhOc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kcr+VZa0;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9D4B6600FC;
	Tue, 30 Jun 2026 04:08:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBD01F00A3F;
	Tue, 30 Jun 2026 04:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782792505;
	bh=CUnTNnIb74vuucSNXoGi9/IfHGsNCXgoVOsKdS+73Y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kcr+VZa0lHJCaMhWhwVq1oHyKcy9hfbk8LDqi33TOlC7ZG/49SthhgupQ/aWbwJI9
	 1JoCtIyPIKsI3h4jnDtkTdGR9TtgdXO2ZFAXihqPfJu75Dxe5P9bt1AzCbwOkaMFOE
	 +pBeiqptnxIVQzVQ6j+DG8XHick0tG3zxnnBM3y3Fp3QDh8VHhX5Iu7StqPehXjAYk
	 2Czwr2DXjqtyZzjhwjMXzEBsWX7TCiFIlGbt0VjhtPMM+pwWiSlf9yeQP18cYnH+1O
	 V4AA5sjm7WUj+GXN3WfzGId6JDH14FszaalCO3Ii0rn94IKHlELAHeF/+swn5/DAJF
	 1L7VuSprHtTog==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 04/18] mm/damon/core: handle unreset nr_accesses in damon_nr_accesses_mvsum()
Date: Mon, 29 Jun 2026 21:07:57 -0700
Message-ID: <20260630040812.149729-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630040812.149729-1-sj@kernel.org>
References: <20260630040812.149729-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ksfn5f9gamt7sr8me7k9hk34qpk46se7
X-Rspamd-Queue-Id: 0D648100004
X-Rspamd-Server: rspam06
X-HE-Tag: 1782792505-779958
X-HE-Meta: U2FsdGVkX1/MxPVX57NriBPKRJ8pQ/6dogyHvtuyhI2C3pmtKH1gFs9faxxIoc8fwigAAXxs8diMMt6zo1TFn1MsRfAQU9GiZ0x7hHq5bBE9z2PS8Mc+qSZUovtQfR0REPDnD8DPE2Xyk6HHB3Fb219KLz8piokNbVcw14FNez+AtNwxBXxC+3CjVqnrPyRrDFXHFTzMgqDsfmi/eMTgph+m7yTiBFOyWJsGhVkxKzw9blMU0VxqqZqSGBP/VY168JrFZBjYtUIU3/aVGfqiFPuKCZPnqpIx3mK1EUwzTc2vqcN87IGxPqaOFNL5LiHTwn/bnbNhKb3LvBvqv6zSfxmc4ZnmRxozpniEh/3RmOOAiAbLhujultXjc9VPWTuEswA1jD0j0t9lFmGSxW0Phqm1nSrPf/uw9KL544Aoph7MZRUIxvODiQNC5uMXtrQzI1GAtA7Rjc4F7G0YJORrmWxIMj6BkD9kcdeAATj5bfsOqDnOvHBZO3jNoFkBke28oUqf1IBmkwdnb6poDNKVW7w8K9CJcHWWIsbN6n7y8wl3drwhkKmotcK2ZNzET4N/xL92X94liuGHpsXzO9iw4Fl7zKKm5FzhsYP5CcCEo/NtEjX9CoNMl5VQV+Yd356a2lqpyVOAQwSiJOCaRB5xp1ZqgVIFi8VrtjfQHCD7dhhAyn+qUjK5SVIrEowkwLNZetcrR9/hfGoHs70omh8jOp6GA6GGpfX3eFf3LphETE5s+zyyrNocOF4UpUXw/exc4IZyJK+eH+A7toO+3ZsMKYfbJSCpLUsjlcHeX5hEukWkdijErBAsYdIIVX1aYLvRAMI8IfAnbs8OcgqdQoSs+z+lp+euu/CaaViV+m1d3uRwoEtSLkJxlMmnZ5Us+WZ/tM9Zmh4b/KmHeFZmBV0OkBOYuCsKmERlOzA8VWUBEQ7Rb+xQD84NE8RkCMBNuM4tOsM9U4P+kmfqpL7Pgz8
 0tLo+EdH
 kTI4DegAehm/XDsvUe1vI0wMHwXAmdRywKby+P9OA7LpNzB8JXK7iWe5zx4sNtgHhj1BgOzhEbqrr3zSS5FkPxN23cmGGVHU0g0qhIPsiWoyVDXT/KnbZJ1M3ylm3BCMDkvXPA/7ooFuEYn0Y/exe631ntDMLXmnvK7TKx3WInsUhTKTntyrjuROuC+kS5jRwu5JZ2eIv07XKnI1Md4drDQiPMidYkU+gqnrQPW+eAa6dAOtumUZYBkf26glwez/fyOeUt/VACg1ZoqT+xQQif3CgAg==
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

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 669b701e50a7d..70cbc382bec04 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -266,6 +266,9 @@ unsigned int damon_nr_accesses_mvsum(struct damon_region *r,
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

