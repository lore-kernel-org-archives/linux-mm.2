Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39C88D65C63
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 23:52:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16ED16B0005; Wed, 17 Dec 2025 18:52:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11D256B0089; Wed, 17 Dec 2025 18:52:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 028F86B008A; Wed, 17 Dec 2025 18:52:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E58526B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 18:52:34 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 94BB61A0007
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 23:52:34 +0000 (UTC)
X-FDA: 84230615028.17.C0C0440
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 117301C000B
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 23:52:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="uxY0KrN/";
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766015553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+PXhlrp1Z2DWxLTE26R4zqyb32svJBYAwHOtF3/GY2c=;
	b=jl43JbGlfOM0aiQxsvW+J3032hMpS4FRWr+eN89gMKF+qW0SDa3Sfj5fJlkJLj4G9mdLmx
	yd/RMKtJcDybSmT3sDRoNQROKxl05D7g3hoRpHRubYKCoyoJlqyGPUlbtWbm/L8FhfILhp
	gWKLQQcmTIxYZEoFZe3KZAS/zngS2zM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766015553; a=rsa-sha256;
	cv=none;
	b=0PU8cwk/5rHfQFHz5QqAehsQlglietZdRzNMKXebCcqWy77tUNQHm6AiORvtNR8fsL54Pw
	HbzUBEsG56HtAAv0j9bYygvM/hhxNKS56yq40cqZ10zwYqbmBDsDtfnqgbSkQF+vh/82he
	RmQsLUG36QM09Nl//L7GmoItUEiWKjA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="uxY0KrN/";
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A3EC4017C;
	Wed, 17 Dec 2025 23:52:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C026AC4CEF5;
	Wed, 17 Dec 2025 23:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766015551;
	bh=XT8meyHBHOL7oQLxt33J3A3bJJUsQVWtW+JbMwaJIwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uxY0KrN/CWK4Xcio6Nf/3PIx+7iKCUBoGYm2WQFrc5T8ayzRzPy9ieGpFWs6TV6/y
	 5jGiCgMTU+5AvcyqMob7f4T325xnTmsVzEkdecj5/Byb83zq9bCioTSEK3Va+NFNef
	 6hlTmRW0H3CXr477ASBYpyg3Z4uHozV5Px783jsPhDg2rEAmwPh38OB1FkqaNNb+u+
	 DZJFq+lAKnoIYfoWPscPJpd4gQggUYJ4N8KdOW61A6U4d8ojPD9qmp+TC3YrGz/Zyp
	 hlysZWshFhFScj+7G/AlqGgPW8w8z9jsqYj5QweevH4c3F8zeiTFllGJ0Hi9Op4qFL
	 Bj2cDzR7RJK1g==
From: SeongJae Park <sj@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 12/12] mm/damon/core: add trace point for damos stat per apply interval
Date: Wed, 17 Dec 2025 15:52:18 -0800
Message-ID: <20251217235219.2750-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251217174851.28e7c4e5@gandalf.local.home>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dou9nsetpjwrbdkwq8gu8gsk7tigao18
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 117301C000B
X-Rspam-User: 
X-HE-Tag: 1766015552-595019
X-HE-Meta: U2FsdGVkX19Gp9Wfp65PGDQcCoTzMSit9t7sTE5ulwYBSJxuDS2Ee/y4YsolQTFgi/u3trgaFZ1m3IgDE6H54SIhhcTkYSpr7+uxY5tPMoacINu5MQDO8S9gCbM9uTTy69SrIHoZG3kUiBZivOpIvl9os9GvlgdqbMPu0Hrz1RQOqPZC8jyZFi4MiRtrLL7pQ3VMEZu0E3k1C44fED0PYKpAAkq1G/eIHc/Cz5f93VSww9pQCrL7hVU4l13JLpUSRzywSWOgf9QTlvbSJ+0U4RBVU5+cDXD5BWq5dS+dPKSVdphcoOsY/sDqbPjjbRz+aqCYMS55JxlLXCrOftNvYeBXsWIKAIl6nwVJsA7HaDwkEgN+TQHJxHTfvWxHj+yW5RuImoK14ARMZm8aWPdlVCQCQmTNnbXy13eBD+B2pUicn/Vq22L247CrFc2ktAtlTBP5K88HLWIqz4wJCCUTFWvdJUqviaQtWQCqK/OaGiP10jzjSYaK/hF8nT8SjRTqsPjeN7mOVQuayznNGIuCJf4Z4F7jCxAu4haUtZfwQa7wkp/hGExI9z9TQaJ97uEm38kSZlzJpIj/Uedqu5kTLQb9hEFPy/WKmG1vD3TXVBN7YvEmxh0bvh2hJEj9eLy9f7WvIDcFtUaIm01hSv+3PShDARti4X92ki5ywAn3YSZjmEBLdSGJA7p6lBFBBJBtOle9XWOYm+uS35tk1Vjx0xB7FPbxaWPvwYdqyaZ0LVQgHjlaBpZuA6+UwuT57hxmy55AVHcQx5uBp6hbVqbKirjqqFRC6OYMlPT2vWaxqgmtoy4jNi61Q00kjHsgTG1jPqfLeCGerCqr8nbXZrmNjY052yhD2igE/igoTuwyoVqwzaJinWwNLsNno9aOls62Aje2LicfCSWn8pmbSaeM2NnWeoJbmbUSo9r84v53BP4If2cikB/lDw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 17 Dec 2025 17:48:51 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:

> On Tue, 16 Dec 2025 00:01:25 -0800
> SeongJae Park <sj@kernel.org> wrote:
> 
> > +	TP_printk("ctx_idx=%u scheme_idx=%u nr_tried=%lu sz_tried=%lu "
> > +			"nr_applied=%lu sz_tried=%lu sz_ops_filter_passed=%lu "
> > +			"qt_exceeds=%lu nr_snapshots=%lu",
> 
> Nit, but it's been stated that strings should not be broken up because of
> the column limit.

I also found checkpatch.pl shows warning for that.  I was ignoring that since I
was thinking that's just a recommendation.  But as I got more than one warning,
now I'd like to fix this.

Andrew, could you please add below attaching fixup patch?

> 
> > +			__entry->context_idx, __entry->scheme_idx,
> > +			__entry->nr_tried, __entry->sz_tried,
> > +			__entry->nr_applied, __entry->sz_applied,
> > +			__entry->sz_ops_filter_passed, __entry->qt_exceeds,
> > +			__entry->nr_snapshots)
> > +);
> > +
> >  TRACE_EVENT(damos_esz,
> >  
> >  	TP_PROTO(unsigned int context_idx, unsigned int scheme_idx,
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index 8908aec6670f..68dd2f7acba2 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -2256,6 +2256,22 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
> >  	quota->min_score = score;
> >  }
> >  
> > +static void damos_trace_stat(struct damon_ctx *c, struct damos *s)
> > +{
> > +	unsigned int cidx = 0, sidx = 0;
> > +	struct damos *siter;
> > +
> > +	if (!trace_damos_stat_after_apply_interval_enabled())
> > +		return;
> 
> Other than that, from a tracing POV:
> 
> Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Thank you! :)


Thanks,
SJ

[...]

=== >8 ===
From 67a7762ee1ade258c53913ea4ecf9bafd4746ea9 Mon Sep 17 00:00:00 2001
From: SeongJae Park <sj@kernel.org>
Date: Wed, 17 Dec 2025 15:42:06 -0800
Subject: [PATCH] mm/damon: do not break the string for damos_stat tracepoint

The format string for damos_stat tracepoint is broken up to multiple
lines.  Strings shouldn't be broken up due to the column limit, though.
Update the string to be put on a single line.

Suggested-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/trace/events/damon.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/trace/events/damon.h b/include/trace/events/damon.h
index 24fc402ab3c8..bf25ee07cb48 100644
--- a/include/trace/events/damon.h
+++ b/include/trace/events/damon.h
@@ -40,9 +40,7 @@ TRACE_EVENT(damos_stat_after_apply_interval,
 		__entry->nr_snapshots = stat->nr_snapshots;
 	),
 
-	TP_printk("ctx_idx=%u scheme_idx=%u nr_tried=%lu sz_tried=%lu "
-			"nr_applied=%lu sz_tried=%lu sz_ops_filter_passed=%lu "
-			"qt_exceeds=%lu nr_snapshots=%lu",
+	TP_printk("ctx_idx=%u scheme_idx=%u nr_tried=%lu sz_tried=%lu nr_applied=%lu sz_tried=%lu sz_ops_filter_passed=%lu qt_exceeds=%lu nr_snapshots=%lu",
 			__entry->context_idx, __entry->scheme_idx,
 			__entry->nr_tried, __entry->sz_tried,
 			__entry->nr_applied, __entry->sz_applied,
-- 
2.47.3


