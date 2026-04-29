Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CA36FF885A
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 00:13:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A899B6B0093; Tue, 28 Apr 2026 20:13:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A39CF6B0095; Tue, 28 Apr 2026 20:13:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 977136B0098; Tue, 28 Apr 2026 20:13:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 83ED46B0093
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:13:44 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2EEC91201F8
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 00:13:44 +0000 (UTC)
X-FDA: 84709669968.19.56C8253
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 96E3914000F
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 00:13:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kwuCmpdI;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777421622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8NvwcME2+jv2xISR8mJdpoHcvGcJ7VjUvLLG7y8X3CE=;
	b=P8WF+MffA6zFdbQmKpvuHCMmlDFzbOQNLoqGs7HJ+zoAUPmvOIlpUU/dCeTaIKikTwezjy
	FnnSJvPdBaWYGUJrUiWHnrWvCVtFZ6yJj1JrWP+TAWF+YM6YM8nmJDmGPyGgfC3djeGGKf
	t1GTmD7ZqGuegnlZxGequZKPephfVBw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kwuCmpdI;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777421622; a=rsa-sha256;
	cv=none;
	b=1zz6GSpmKPGbQ2XvgloCunKlxqlXUPrFMCoVhHKWSjBlDDC8+0SFukd1PZghgU0RtMmJ1D
	vudXw2ne64RkXYcaJ1PSGHY7mZx7yYwXi93Zef/3+j+ifw6IjVvZ/FAOrSBwRkls4u6WP+
	vQuvfCcc7YzrcSoA3DzVbafuDpz3X6M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E172C60133;
	Wed, 29 Apr 2026 00:13:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46380C2BCAF;
	Wed, 29 Apr 2026 00:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777421621;
	bh=OxmIeCCg0CwmYbh/3fPPpRuqH6P3pcR0ENAMgCFSCzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kwuCmpdIFTQLWCOwVJwEStk/0AxZ0Cq/yTDCN/4bjXHY00QJqzyCxY5h+CdjvC5ib
	 8YEGg2H0+fbl/63Dclp5eE9LM9C/pi4QiHiWGHiydf8El+gBHt9lUq1LGIy1Wdpepa
	 KCeU5gSakA3ZhorIhXZlJWi0iCuj3rVNHlt2lVcgwhxZ/XclmvedPQaJAuylQ+mSV5
	 ESG3RAP5HlvUFmb3MngOOgkaFNkuKGVCzZGCrndw9e/U6vRr+PxzoQJjNUbMkaqL/m
	 zhQYXjq+wZRA36l6yWZo4ycDWrMNsENbPiwlEtVRE+fcLIsBiBgNqziobYUBRz9adT
	 4IQnv60M9O6Fw==
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
Subject: Re: [RFC PATCH 16/19] mm/damon: trace probe_hits
Date: Tue, 28 Apr 2026 17:13:31 -0700
Message-ID: <20260429001333.87439-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260428141745.2768ac4e@gandalf.local.home>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jzz5epx3xkz9w8mn7dkc35sozo4t6xap
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 96E3914000F
X-Rspam-User: 
X-HE-Tag: 1777421622-83225
X-HE-Meta: U2FsdGVkX19GCz8a3aLZjiMHj14aAZPI2bI9xYSFRHPazxgTXF3pdudgsBXRq1m6U6jfP0WO7oqWPqtlJoR2lRXdP40V7MWYmo2cns63iIC1k2sqFFUz3X1fl1smd5vfXG6Q0Tgt1TUoMJymwTpeIluCDQHe1EAr4DQvz6rOooT2TSRwHFobIsdvTYbkO2T91YNjO8ZBXBBVPGNDo6X5gB2m4Oa00VG+aKR2vdNvhn+QDojWpFg/5ScJ+rZoyIo4vBcyG7/4ulC37PgpFpQ3ROLSEn7oKEJYROZMNfvAG9svSmGBBWvxrs55/ktbTpRogwHy60JbrOYQ3joegMCgD6OQuN+0s3JBPfKKoggPR39gADvGHv1HxQSfeeExKjBtTkbMAdU6FYo5HGokZbHiKgyEq+bOH47B40TH1LtQMw/dAWBkAMAVQmnMyh4XnU7ChbAq7ck3Ogi663gj/kSWX6fn87S9rSTPzYkzHH7d6Ds7HyiG6/0oNTDqPhkAWu8+Lto4b3kDGP7qyVR/CMEHshDBieDsvQ7ZmNQw2tAp8Yar89BwiXHDPythu/iuMIo62fQWV5kkG5+z5NWkChrK852NRUwJCmeq++6ct0eOq3p+0WvZjrtPIzT5AWvdzpO6MtOdkJgGTAHijKt3KYVzp8Yx8BGBW6+YaydXa2b28TcL+U236rfyMVcPB8wI2YUvFVqYDT8swpPSxuiNTdq/r+sK64S+OPnIPudK14vez9Y7zr5KiXoPbRNb8trDUhJ7veAIcAbnUoI/s1JaZPsjf5iTpfBaDE6uC8aOtt2y+OpQE6e6FSlyS7xyzPa7wEjzTmrWLbESsafIqkRzWdSbH4yn4A96A/sV7E1WALfzsHs86SYbsSf+dmjRlavRyL6UO7Dn49YQmFHWIYQGlEBwx62Zrle4lKkjBXv1YhujPb5UcHsvHf6xqQbtUYgEaMr5uF4JcUWfjAJCTWEXKCj
 ynBtCxMj
 V2dyXqAtJzr+g2wKXAqY2AOVmCXYYx9I9usjfj2YKmOk6xlQBk5aWiX2/QpPbohB+3hMizrwxfhpeZCiNLQKwCVMrk4X5pljT0AhLHgvOGRu8r68fywv97QpZ4YzINDJGvZ9Tyda6cvUjixwmM03UQMkYDNI6w52OXs0UhLV85GpFt+PVyIU0KOxd2Nk68DF0/zQYCxD6C/zfTmCPjXu8lYWOp0Fc3ZThxHjKLlzTStlEcbDVFfy1H1bddLg7kDJ1WU6jIcWKk5kg5lP7e4WzVfUF/AME8gKNNqQvOfRzLjia+PdQwCBkPlmyvYb6SHVRCRCRTTOWjgsb9DlokywCXVpa5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 28 Apr 2026 14:17:45 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:

> On Sun, 26 Apr 2026 13:52:17 -0700
> SeongJae Park <sj@kernel.org> wrote:
> 
> > Introduce a new tracepoint for exposing the per-region per-probe
> > positive sample count via tracefs.
> > 
> > Signed-off-by: SeongJae Park <sj@kernel.org>
> > ---
> >  include/trace/events/damon.h | 41 ++++++++++++++++++++++++++++++++++++
> >  mm/damon/core.c              |  1 +
> >  2 files changed, 42 insertions(+)
> > 
> > diff --git a/include/trace/events/damon.h b/include/trace/events/damon.h
> > index 7e25f4469b81b..121d7bc3a2c27 100644
> > --- a/include/trace/events/damon.h
> > +++ b/include/trace/events/damon.h
> > @@ -130,6 +130,47 @@ TRACE_EVENT(damon_monitor_intervals_tune,
> >  	TP_printk("sample_us=%lu", __entry->sample_us)
> >  );
> >  
> > +TRACE_EVENT(damon_aggregated_v2,
> > +
> > +	TP_PROTO(unsigned int target_id, struct damon_region *r,
> > +		unsigned int nr_regions),
> > +
> > +	TP_ARGS(target_id, r, nr_regions),
> > +
> > +	TP_STRUCT__entry(
> > +		__field(unsigned long, target_id)
> > +		__field(unsigned int, nr_regions)
> 
> Move the nr_regions to after "end" as on 64 bit machines, this creates a 4
> byte hole.

Thank you for the nice suggestion, Steven.  Will do so in the next version.


Thanks,
SJ

[...]

