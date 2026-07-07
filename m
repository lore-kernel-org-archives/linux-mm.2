Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C90ACC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 13:51:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 077816B00B2; Tue,  7 Jul 2026 09:50:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 001206B00B4; Tue,  7 Jul 2026 09:50:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D72F06B00B5; Tue,  7 Jul 2026 09:50:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A71096B00B2
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:50:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2AF4B1A0448
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:50:55 +0000 (UTC)
X-FDA: 84962116470.11.226ED25
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7B443180003
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:50:53 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VjX3EsM2;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783432253;
	b=rSD85TPg8F0yUh+i/amiB0u6UN5XWLJQ+eUWOYFvdEmchEi0a0UJiqjw7M5myyh90dohOt
	I8CbTGqLInzl0URazjHozkQ20PL2vH/dwjirgrQu0w/GMpNhGnKTEeywLN7b9F1Sp8AY5F
	JdByi9yTmid4vENIy7ILyPiion4jKks=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VjX3EsM2;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783432253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=of1I7i7VNy1H4HcbkZacjpj2gDgZKYHy4CXBT3cnzFM=;
	b=tLjIH6AxhBxRr0uwh2+is86014gduurhHE18/C3dDoybAjmRVoy+szt1Xpxf9gbyc6eDeb
	esV/oZ65TI2P13DxSDm5XjlNmJXKiTELsWUtDmQf6MXYjQa9P2XlwdypP6UU3s97NP3TAy
	7EoQhXWvo6Q/Ktx2YcEjIpuxhLogXLI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC76F43AD7;
	Tue,  7 Jul 2026 13:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877081F00ACA;
	Tue,  7 Jul 2026 13:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783432252;
	bh=of1I7i7VNy1H4HcbkZacjpj2gDgZKYHy4CXBT3cnzFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VjX3EsM2q3k/yVDTb4quyBr7dla8OOF2eiAEjfDZVvm5y1fbKAywgE8luHEFR4vX7
	 Bog2C1GMW1QW+vQlw8XW9EfGQFhCcGvK0kS33yuTn9LiBaw4Xz+fJ0yCYCpdWxIpB1
	 Arq8pFkyxdL33w2rKb6m7t8cE1SgcSJvehV0OvfDKOgBBPXinlnt0MqbZ24yimKmmm
	 S/fjhu6lK4TovG5pVhJw/TRaJjHzSpj67ipJlxq+FF7b3P+pPNPFVE5fz0csBJbRD4
	 SV/yfEj1dXrNa7CZabwnujff4MCN18GMuysHrHxyTurvjIe4WMP/RcFKco9WXi3ztE
	 +wsgRQWVfA/BQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 7/7] mm/damon/core: handle unreset probe_hits in probe_hits_mvsum()
Date: Tue,  7 Jul 2026 06:50:36 -0700
Message-ID: <20260707135038.90068-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260707135038.90068-1-sj@kernel.org>
References: <20260707135038.90068-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7B443180003
X-Stat-Signature: fsz8ois7h18z3xobzsjjjcy4iwiircpj
X-HE-Tag: 1783432253-160449
X-HE-Meta: U2FsdGVkX19EsHrhPvho3g8J3r2Vi9Fy8T1ZoquD6qOAHcyY1vyV02/GDmAVLyMEvTrVUqu4dqTUOQK7hpz+PytwO/vymIZj+H1GZzQrvLJIyoSfUCtiWLs1JknY0jJ4nxJ2DFla4OkYrm7Y9OCsua93FSX/t2A1NoCWGfq71vNAeEgl+b7Y64bwEnhhkFypxqj28ZT5FJbF+IV+LiU/BVfewriuDIdXOsWFNc/GHPG++tXCy3mFRL2D/vRP8Muqvir3T58bvNzo9pvoPQZAkax+99UDjX8blmeSN1gWDfRsMQARTAmGyqT5fd/IDUwoONkTIch9cn/Ushxkmz04EK3TtzxWpubApcLNxTTpI5icErOYkvLzLNo/sRBkP2XBOCBaCvj++B5XQ8PLr2BbIUXpZSSR49/99VmTROQQENjk/TkW7g/y5eg9Q/UShSZPaS1kpOTQFwfhUtytPM2VMX0JbQBwPNm77RnwV4XQFAHqz+Q7vTTnsQOVK5MhWtLNL9jsnJbkuYMjY5BE32SK1IPTvs+xZ3nFw2ECDP++8FaKjAT9bdnUGpnQH4j1/vvanQZPKzeY19DiWaBUB3pKxKgTj99AsY9JFyGVvljKg/HzvOMa7JIq3eIKMUxP/E7AIy689OoEwls0g9zuQ1fY+7eGX+v542yf2/FujJL8nFuTqDFHrlxi44qMQQwwVivd5zSW1B71dkZ6wbih0GT7Pk6ZW7Uki10mVg+bQUzhxR4sodSDSJnW1LPP6tWa0IPDunuMLJlck2owtb0MOu5620vpFAzRAAGWJNH8EhUjm5lf0D36MTwo29XwYzvaYIKdI07gurwNXNz+E7mm7UfjJUezLJOhUn2SYkpVHOUJawlQJOedfz961D97hKkuwVRmXAJYeWqG7VZyIjigyGY0AbujxXsppY3he8eGYXFdS8Obtv3bAxI/YeAxkQAeoNjQ/m/a3CXMoNVSDwRJxyf
 02xqUYtm
 pg/MEZixIrt55i5w9MlOxHWVa8nAb1GwdRkK4Lw0QOaxbqpEvqurwzoV4EVB69DYiFuSNG3aFu/LsiwifcA/pv+lSDRrSHnItn9644s6sFybY4JcxK1Az7R0pVsToleUKROLjQjDEf1Kfa4VefSZhruCx00yTuvwZE1O5s2ZJgCrkguxxTrW5wIUD0NhKPgGPUuit07UrrqFlLvdEuwFFX54csgIVjxiz4C9d0eXw3QIpDyefMWyfgvDwhTrxz7U9Uonk6mFGHGXNk/ZQj5QlZx/a9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If damon_update_monitoring_result() is called at the end of the
aggregation interval, probe_hits is not reset.  That's because the value
will be exposed to the user via damon_region_aggregated trace event.

Meanwhile, damon_probe_hits_mvsum() can be called in this state.  Due to
its logic, it will return a value that is incorrectly high.  This could
happen  if the user requested DAMOS schemes applied regions sysfs files
update exactly in the time sequence.

The impact is minor, but better to avoid.  Check the timing and simply
return the fully aggregated last_probe_hits, like
damon_nr_accesses_mvsum() also does.  It is not 100% accurate since it
is the last interval's aggregation.  But better than the value that is
completely reset.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 9a3ff0fe55a61..093da5c0b3693 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -290,6 +290,9 @@ unsigned char damon_probe_hits_mvsum(int probe_idx, struct damon_region *r,
 			ctx->passed_sample_intervals;
 	left_window_bp = mult_frac(left_window, 10000, window_len);
 
+	if (left_window_bp == 10000)
+		return r->last_probe_hits[probe_idx];
+
 	return damon_mvsum(r->probe_hits[probe_idx],
 			r->last_probe_hits[probe_idx], left_window_bp);
 }
-- 
2.47.3

