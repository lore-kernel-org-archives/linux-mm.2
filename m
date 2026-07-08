Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00C73C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 02:49:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4507B6B00A4; Tue,  7 Jul 2026 22:49:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E3AF6B00AA; Tue,  7 Jul 2026 22:49:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C43C6B00A7; Tue,  7 Jul 2026 22:49:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DCFB76B00A6
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 22:49:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5551A903AB
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 02:49:08 +0000 (UTC)
X-FDA: 84964077576.29.06C72A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id BE20CC0004
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 02:49:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YQBxiWMn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783478946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FjsCU14SCNwzNXGXZ9ta5DksRZeNC0xj5z1tjd9bQ8A=;
	b=iEVnlJlTi+Z0O72PekypNXzwQVLrgCcksZB6ogZaVy0LF7STCOdMAP6UZSNEmP9QvRn4su
	3Sl0/Z4mt2jZhvtRXpj3undnC5whvDMF39BIw6PiV/FvgSinB+yYN1KTvYTYJzD62Fx8JR
	GnY5en47F/4EGn99p16aR7B1GmCcfcE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YQBxiWMn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783478946;
	b=zSlpf5qFTWEjJA8OrhRy9gPTeZztvTh1gIMuhwbp+YCbjTZHvOl0jCDKQjzrkoTUNo1+TP
	1cdWH99OkxQh/RsuKgK0cTQ31ggmwEtku7TBiiaGL0zXxe/Yw6LC9amDmlpxWQYqB2B65x
	f/rjsyS+AH3Fpefx8i7BQK5O0XVIKWE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 640996111A;
	Wed,  8 Jul 2026 02:49:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70EF1F00A3A;
	Wed,  8 Jul 2026 02:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783478946;
	bh=FjsCU14SCNwzNXGXZ9ta5DksRZeNC0xj5z1tjd9bQ8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YQBxiWMn5csztPVWxR312BoeH8CAJetZe9cV+cunf/pwgo1/exVkg1GkhoSd1pbkm
	 jlFXGA9IKrAGYGEccyfCgeeAg0nMGYwOA7bwkPmDcu92d+hFKFglvS+beTN5aGxHJm
	 nBA27K2XaOHiA4ywfwo8FutH+gRPNZX0VA573iDhHcH/3B50Y9LGXCWc9EWk8fg3V/
	 cypcKhNEbPS2AAa3fq4laHviOS2FVYzm2WCVjcsobvogTbl+R+sBDiB0gCLQ3B+8eO
	 8hm0PqJhaOwFV3uLRoSAWQzH2gvKSpnVP0DBcXL2V/TRJeU5d/2bksNQNAAsRrDEpy
	 jBxdlvT+kPuyw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 7/7] mm/damon/core: handle unreset probe_hits in probe_hits_mvsum()
Date: Tue,  7 Jul 2026 19:48:53 -0700
Message-ID: <20260708024855.116614-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260708024855.116614-1-sj@kernel.org>
References: <20260708024855.116614-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BE20CC0004
X-Stat-Signature: 7owhrj18ceji6qcxqxtrmm7rswsomwb1
X-HE-Tag: 1783478946-760814
X-HE-Meta: U2FsdGVkX18a8bl2cyiDuBuXbHGfY4vl/ohk5l/9ly8QOHgKiqBDjPJMQAhhFh8HDLayC4HjARmGemJ2nuYfwNHWWCaBAfigSxJxuTqmEwrlTZ4zoYQDSU2vuIul4GUSwqP8s/CbUNgl2zTEvgel3j+E38R9CQ7hz8MBTM81aZuitwMmKZx88vSLJECraUuP5qB6tc6DJWxuOa497ttmLfV2WtlRxdC5JGp6cx4YSwY9Xz7C6EpPUq2iyZJc9NQXpk1Ei5u+EZ7uvakzDScxs8I5hOugTXbsFLnF2Wcdb4OO100LOKf7kGEOd2hIIq6BTrkZWsXTgkvKbb0qsyXD1bpBquLHJw1L7IQBnz1mU6P+QgM1Z9R674dPVIUW9jyPo+e8cKSJt5ck/cA/mSO9FelgspFcdFDSRiRjPXdo4OuPt+uW8no+nSxhY+8XAkuKyMJbM5QwK/f4iVuNeq6IzfzzaX0xLB4qKFcpXyerP8KRVvdt6aSED+uxKZahogqwZZXor9TMPUdX32sIqi7g4sy/K2ug8eIiRUhvGS2nr527UbGqB+CP25QDoaNCSPD+pOmHQLTyNqkVgHxwI1Sk8KbjVpJPisQ6Bw6g8qJ4JAPPU2pWr1Z4JihGZ0n7KTsBCm93MnVAi4tPmt+lkDGQnvavXDRh0jUrUSG930UuujgwiftjGFZhcaPmIdXpYRBLKOICv+x7DXZ4CuUPPFx0oToviJ8AQP3RTpe5szazYP8bDicY/TVZEMo8HPmAUdYngTQPPN6OIzrkKaV76/vSsd0oadRKQinLgiYYT9uMVXIdpu1KFB6nS+ghO4h0Von/Yi+b9lNw/vQFOflM+Io5FKYRilFRTaWiTh591hjJt1LwYlRvMt1eMzKcUuKjzpUpIH5OOhiyf6JKk3VU/Sjmh9TGkoOshDrpQLWT4OyG/f+afcjI+6nvgxgD1YHIjyhwvJ7+vtg25Yo5x3woM0B
 tzpoqf1D
 IFiJyF7i+fEE2ejAU66bj0mhltBXvqYLB7NJ1YiTGcUF0l+hBxSvYBKl7r21hgiESmata+0ZiN/h336O7aiplfxGNZusZ2Wjs2XvwPc3x9WqAuSxCJyX4zAXGZnXf8I/li7MdUNel1ph5LnQbrPrYGukCnnifGSHNIvYJy6sz+xEuZqof3VrR+4Ntx7H8FG/TsaizlfUcLiPH1omH7JYh5t3owIP7HdMHiEwRDdIvdr4gTbG2sU6dDERJ6MsT/FytVG5NCJwLZKhJuoQ1lSe7WVACjQ==
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
index 15d31285515d6..11473aa1f70f4 100644
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

