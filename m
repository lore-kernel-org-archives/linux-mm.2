Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DFD4CD37AC
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 00:07:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53DAE6B0088; Wed, 13 May 2026 20:07:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C7076B008A; Wed, 13 May 2026 20:07:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38EA56B008C; Wed, 13 May 2026 20:07:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 236C56B0088
	for <linux-mm@kvack.org>; Wed, 13 May 2026 20:07:03 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A40928CA40
	for <linux-mm@kvack.org>; Thu, 14 May 2026 00:07:02 +0000 (UTC)
X-FDA: 84764085084.02.6A918A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id DD5D3180009
	for <linux-mm@kvack.org>; Thu, 14 May 2026 00:07:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oBq66Qra;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778717221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AEkq/eGfgOVH7wzNRnWx9Om54LYBeTY9WfyooVWWtCc=;
	b=qXQzPyZ/W728OBuruhsXSk8nadi+GQw4aeq7dqAz/881ygLd4sdbjnVf8HlwHXaOd8VXe9
	zlzP+UKiHHrCsfriOGYUCw7rjIxLJPcGElyw/EffIieqOy9dSQoy+3KZQvzOnnwrUBmH11
	EhJgRT/Ulmfqzehh5EF9J4J3I2ZDIO8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oBq66Qra;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778717221; a=rsa-sha256;
	cv=none;
	b=oiIZQlNjG2gmHdzKIxaNMOtoBBGhdkamMWc5B4y799SViAX911nA28JkiqE3YJSaisia2K
	WmwvrZBvc3pz5mmwQAptjeGhCTC9HOuO4wRVAtCWYEEwTOvz0e46zNLMVWePF5knvpZ8sv
	zn3SYJ9kwhmlI956bu8gHbSs8Mzdmu8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C598E40DDF;
	Thu, 14 May 2026 00:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26F3C19425;
	Thu, 14 May 2026 00:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778717219;
	bh=DWVNCpyyXtijugIs1t5TkZJG/znt8BoX/RA4gIbC7nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oBq66QraZzrbe5XdmdxhQXuV+x3xo87BOW5PwtTKnsZF5cZjBT0Dd0aFJPNxPc91s
	 HnbIdR4iAlzocR04Pr3jLgM58xMltMZP+RpCHN6PbkgGrH3sXkzeZ/yu3c6RRYXV9E
	 4o3PzZ/ctIr4yvs8dr2G+6YBOQ71cpUX3lJyvtyvl7Dk07z1t1wvXMk+85sdOYnATN
	 0u1pFzfC3HsWEpEY7yWC/DgtPoXPcPdqunQznk4hbuKEFPY9oMPlvLJx8d53BxuNWk
	 G2gyml0sZhOVP430eoyy6YawFbmTOlLMVd15w+pDwZjS80uK1tcHexVqpkFVpqasbr
	 BE9FwtRXq4R1w==
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
Subject: Re: [RFC PATCH v2 18/28] mm/damon: trace probe_hits
Date: Wed, 13 May 2026 17:06:10 -0700
Message-ID: <20260514000611.147809-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260513140732.2320c563@gandalf.local.home>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DD5D3180009
X-Rspam-User: 
X-Stat-Signature: ase7rkk8m475ywz3waju6x46oig8x4fz
X-HE-Tag: 1778717220-30029
X-HE-Meta: U2FsdGVkX1+TB1hnYW3zmIPZd/yyIXCY9ALdNvHBafpNDIi1sX/L2bIiVy3Xf/Y4XdhpT6VGDvpCLNR7EM7B1Yf10xRQaNcSVswt6oDUe1KX/0I6/9uMh3hoxXxn2xSPO9ILTPSSfN47XnKhwwG1WBBapO9YwnmVDrKqPlGw7WKvGVs3FeW2uV4zZkve7Oj19Liz6yNVF4EEJwKg1z6lrbnSs/QZxjPkwU8vohxDI65midpC3oeXHCdpnfKoWYHnFgur1qtOnakSnkI0S2QtV98xE8NMJjP57fbf3+OeQu39xA3cbTY4DhhkNYpNTysburoqeFZKHB8AIZv9cFHb5BfQg3uFOltfv4uY1FiyQkOWmPStKWXXad2mI0s3yUsgeOyiHTvutlnYEgEMey0GDFWNd/VUwEEeLV1pR+ehNbrNOqEVgsjZYSV6qDhMFRSBBv1R1i0STvgseoOm4r/PRjbkXsTZ21E+TllzMU16wUxuu+sAGhZDKmnR83UFSdrM+VhPflnToNR8OyboXmtzBf04o3OmFGU3HkA/sQh22UVNTm3vJVElgycLrYq/aDeNN60NproJWwiKhcKK769ntfiXSEDosMQH9NcJYaZZT7fFwubKc7yIpUT//KxiV4Wms6QQmrhzLW8uMCiVR+7doVBpcVFH4+6w0jCQYQJBkX/4AgTLUqIrNPXRlSa4YPynrp2sJMqgaMC1PeyySg48VpV9gijdb2N1LE6tpycAvcI0BjE8lNMBCZ1Hbzs7Yr4na2Fzk2Bd4bRXg6J5G8PG5QF3ec9wisBV1VL7emjuVNvbDmlcIIueI+Ng9VkULPWneu4vdtYdJ5SWNEeImFSfXvoKx/BmenmOYkJCyp/78AvT8HgqVd85Rio3EXDVva/iSCU8kau4upCsWsAK6geilApsVQVHf4cS+BZxSslo4z2Js2lemPqHoIedprgXsRTBqyjk7N3/NK1zQk7Rrma
 +NAHttJD
 sdSCyTc+08vDNcesmiqsEjnDWPOM6GobUQKFiRfVl3raLONZrf5aGQLr48ai2Ajyaotwp4Xlpf5Ea4HmVbn/BYAni2hu+OZkWHyBYGe33nICF4lAaU6Fg2Js17q7BLoSk03ed0Labolh9HrmN+EztAwmxYIjGCa4qiTzof8xTJOEHkK60FAOd2FXg5oaYuI3r2W0EXiH7Zj1KbXVrXi+zSwL4gIMrg3vi7E5bepqmhMDSIqxIfwHg+YncLxPsyxMb2f+GQb5g8WXz+9+N3a0aDnRUdAOzgvhOkuXUs06ODC0qRjVnxOEsVJyQOKBdsEYTVXxnGDcIkL+yRsFHxo8OpzzYcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 13 May 2026 14:07:32 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:

> On Tue, 12 May 2026 07:36:33 -0700
> SeongJae Park <sj@kernel.org> wrote:
> 
> > Introduce a new tracepoint for exposing the per-region per-probe
> > positive sample count via tracefs.
> > 
> > Signed-off-by: SeongJae Park <sj@kernel.org>
> > ---
> >  include/trace/events/damon.h | 36 ++++++++++++++++++++++++++++++++++++
> >  mm/damon/core.c              |  7 +++++++
> >  2 files changed, 43 insertions(+)
> > 
> > diff --git a/include/trace/events/damon.h b/include/trace/events/damon.h
> > index 7e25f4469b81b..d7b94c7640217 100644
> > --- a/include/trace/events/damon.h
> > +++ b/include/trace/events/damon.h
> > @@ -130,6 +130,42 @@ TRACE_EVENT(damon_monitor_intervals_tune,
> >  	TP_printk("sample_us=%lu", __entry->sample_us)
> >  );
> >  
> > +TRACE_EVENT(damon_aggregated_v2,
> > +
> > +	TP_PROTO(unsigned int target_id, struct damon_region *r,
> > +		unsigned int nr_regions, unsigned int nr_probes),
> > +
> > +	TP_ARGS(target_id, r, nr_regions, nr_probes),
> > +
> > +	TP_STRUCT__entry(
> > +		__field(unsigned long, target_id)
> > +		__field(unsigned long, start)
> > +		__field(unsigned long, end)
> > +		__field(unsigned int, nr_regions)
> > +		__field(unsigned int, nr_accesses)
> > +		__field(unsigned int, age)
> > +		__dynamic_array(unsigned char, probe_hits, nr_probes)
> > +	),
> > +
> > +	TP_fast_assign(
> > +		__entry->target_id = target_id;
> > +		__entry->start = r->ar.start;
> > +		__entry->end = r->ar.end;
> > +		__entry->nr_regions = nr_regions;
> > +		__entry->nr_accesses = r->nr_accesses;
> > +		__entry->age = r->age;
> > +		memcpy(__get_dynamic_array(probe_hits), r->probe_hits,
> > +			sizeof(*r->probe_hits) * nr_probes);
> > +	),
> > +
> > +	TP_printk("target_id=%lu nr_regions=%u %lu-%lu: %u %u probe_hits=%s",
> > +			__entry->target_id, __entry->nr_regions,
> > +			__entry->start, __entry->end,
> > +			__entry->nr_accesses, __entry->age,
> > +			__print_hex(__get_dynamic_array(probe_hits),
> > +				__get_dynamic_array_len(probe_hits)))
> > +);
> > +
> >  TRACE_EVENT(damon_aggregated,
> >  
> >  	TP_PROTO(unsigned int target_id, struct damon_region *r,
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index fe6c789f2cecb..14b15c9876516 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -1905,6 +1905,11 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
> >  {
> >  	struct damon_target *t;
> >  	unsigned int ti = 0;	/* target's index */
> > +	unsigned int nr_probes = 0;
> > +	struct damon_probe *probe;
> > +
> > +	damon_for_each_probe(probe, c)
> > +		nr_probes++;
> 
> Is the above logic needed when the tracepoint isn't enabled? If not, then you could add:
> 
> 	if (trace_damon_aggregated_v2_enabled()) {
> 		damon_for_each_probe(probe, c)
> 			nr_probes++;
> 	}
> 
> And change the tracepoint to be a conditional tracepoint:
> 
> TRACE_EVENT_CONDITION(damon_aggregated_v2,
> 
> 	TP_PROTO(..),
> 
> 	TP_ARGS(..),
> 
> 	TP_CONDITION(nr_probes > 0),
> 
> 	[..]
> 
> And then the tracepoint is only triggered if nr_probes is greater than zero
> (to handle races between the tracepoint being enabled in between the above
> check and where it triggers).

It is not needed when the tracepoint isn't enabled.  I will follow your
suggestion in the next revision.  Thank you for the nice suggestion, Steven!

Btw, if you don't mind, may I ask your opinion about the name having '_v2'
suffix?  I chose that as an RFC phase temporal name that doesn't break the
compatibility, planning to give it a better name later.  But I start feeling
just extending the original one might be another option because tracepoints are
not strict stable ABI to my understanding, and the change of the TP_prink
format should be simple enough (append the probe_hits= part) that the user
space could reasonably deal with.


Thanks,
SJ

[...]

