Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7645FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 18:17:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B62756B0005; Tue, 28 Apr 2026 14:17:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC4796B008A; Tue, 28 Apr 2026 14:17:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98C456B008C; Tue, 28 Apr 2026 14:17:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8679E6B0005
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 14:17:36 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1F0AE1203B7
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 18:17:36 +0000 (UTC)
X-FDA: 84708772512.04.1E4FE80
Received: from relay.hostedemail.com (unirelay03 [10.200.18.66])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5CE1220009
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 18:17:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777400254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u7w61K8F02Og/isGT1IpcCPQr6ekPmTZLnUp5MriaHo=;
	b=RFx3CRencwSaLMspBokhqAUxMbAgpJSI9t4JDWcPqAHjPdgpb50n5FZoJfks6OAgZWAQlR
	BMjf+a90rcvrozRart1I3eBQERh7QXwIXsNzHvG0omyBFWwFi7DuwmhHkom/BBCv7+1vHQ
	n1Wbwlsca9asqC9VgpuE4rdQmtttgxI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777400254; a=rsa-sha256;
	cv=none;
	b=fCv/cY0Afa07Z/sOaxvwFMKrhPBGRPp7w1oFMXKG9upDs0Ofeh28pq9zvJxIwyP9HnGlLA
	HYx0s6JzhchHq2p9uNIK9IwHYTGjLn3vEAKMosVopSJ2pMs2b3sYi83484wcZDKqpRdOCl
	8uNVxpUQ+s6pAYQFpEH2wSiGuSb2HXE=
Received: from omf04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 96048A037B;
	Tue, 28 Apr 2026 18:17:32 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf04.hostedemail.com (Postfix) with ESMTPA id B6A0A20031;
	Tue, 28 Apr 2026 18:17:30 +0000 (UTC)
Date: Tue, 28 Apr 2026 14:17:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 damon@lists.linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 16/19] mm/damon: trace probe_hits
Message-ID: <20260428141745.2768ac4e@gandalf.local.home>
In-Reply-To: <20260426205222.93895-17-sj@kernel.org>
References: <20260426205222.93895-1-sj@kernel.org>
	<20260426205222.93895-17-sj@kernel.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/2Osv/VST2loy+Q+wM/zb0ziB5zHmuJEc=
X-HE-Meta: U2FsdGVkX1+bOhY2GUWBxPcY0f3n9bSlRQ7NuAetINkmFXIEGE2P9gN5Ej4aestJw38OPx0baBgt/25PZZiE1VB7EyJyVdibhz94N2EKrHHHp6tuowqYE8VCZbpHEw/D0EOmMIBs4F9LubjByTQmJfZpgEBAo4NQJL+qDTomlf2ORvwaj7k0514hYstjvguJs4RyFO5EzIYxhv7JlyI9w70DByjAEA9oxNeEMIG3iBuxxVlP8yu++K+1gtiRHFsRN28XhBtorRFmqvQlBbm0Zr7Gr+UXH3Kc5VeMY62oeRXqhRkY8tM6U/zxDAwuGlXgJNvyApVE9pf/3HSXPetovkIPwD6fR8kx
X-Stat-Signature: zy7ik3mhhoquy7p5t9y86fn8djfy1w5w
X-HE-Tag-Orig: 1777400250-143348
X-Rspamd-Queue-Id: 5CE1220009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777400254-14324
X-HE-Meta: U2FsdGVkX1+mF376/ban678vMxN/S6pDVD2kU4IcMifpZ/pz5nmqBoYKsdPUV8ZWcaGLe3RlTf4B2VpmKe3WfoUHHUt1QBQphjsPzATfsBznneEsqTOKo/QMaOJHRZS6o5c5tPBWuSDubn9E7cSmWuuOBPAGxjZkW9JTIMCz+cuxqRtqN2M/Qq2ZLLhvSTwpYW+jQjtZif8+1NHdSHnp7fjPgDhz2sL59o4uUQp3KZ5WoGAK9uwg+XkLwS39wUxPbce2A2uWtPELiSUNabmozF9qfibvvIImAbs7ct/AwHRubCUfrsBK9s+JKToiyidbKNSX+e770sg+tsAIU4TFXAkvPxPYQA0FKMeIAHz+U/n+JsFYLCjUpW1idZCjMAwxeZMaCM2vIau8uClbEWr71+a6XE3hXjA/ABBKn3oA9stFH60lTUEt42ifBAKoRvT+EH9qezhoSVTlq0OJcu0HAc+dDhTXoPodVIPXb4Yjt8y9vEaL9y3QUTPI1PODoXKrkHN6G/kDvqOvz+NmOhGTT+kPBjoENndsbd77QBbLCvvC9xDCXV7Z1eZb6+7zzKmHXDXDWFH9igxZQw5OC8oIhuz0c8mbF7/pqfAILCP/U7f1mhkWBDFYW2EmSA32Ndw026jiJe3PoXGtNaDBig7q5txWZ67p+urwEdss3vuF+B145UVzR1jAvYnuWtCm5q1Xpfbvb/Rdf2NpkSoecxyEytt+R+WSqU28ZVvO+hq3RJtzbL2klTQRp3iZfhkdySVl/b+iC/gVJDdk6vzN3x6oAStB53zivDea0lGyjJHsG6mfx//V8t+2QswlQzHepBg7FjZJiHvum2ZwPzmAXYYMs65HZZZtmKEp9JSOpcpuuIk5dkknb50Xnmj1kGG9TfU2v6/hciYV8j7O0D56HXgws2vPW0Nxk6rwJwFpfZW6eyjfDvj7HzsKJIiJ3jwqxQWN4b5xUTWhpC/3Qb9O5QT
 5ocT2rnm
 nlhuG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 26 Apr 2026 13:52:17 -0700
SeongJae Park <sj@kernel.org> wrote:

> Introduce a new tracepoint for exposing the per-region per-probe
> positive sample count via tracefs.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  include/trace/events/damon.h | 41 ++++++++++++++++++++++++++++++++++++
>  mm/damon/core.c              |  1 +
>  2 files changed, 42 insertions(+)
> 
> diff --git a/include/trace/events/damon.h b/include/trace/events/damon.h
> index 7e25f4469b81b..121d7bc3a2c27 100644
> --- a/include/trace/events/damon.h
> +++ b/include/trace/events/damon.h
> @@ -130,6 +130,47 @@ TRACE_EVENT(damon_monitor_intervals_tune,
>  	TP_printk("sample_us=%lu", __entry->sample_us)
>  );
>  
> +TRACE_EVENT(damon_aggregated_v2,
> +
> +	TP_PROTO(unsigned int target_id, struct damon_region *r,
> +		unsigned int nr_regions),
> +
> +	TP_ARGS(target_id, r, nr_regions),
> +
> +	TP_STRUCT__entry(
> +		__field(unsigned long, target_id)
> +		__field(unsigned int, nr_regions)

Move the nr_regions to after "end" as on 64 bit machines, this creates a 4
byte hole.

-- Steve


> +		__field(unsigned long, start)
> +		__field(unsigned long, end)
> +		__field(unsigned int, nr_accesses)
> +		__field(unsigned int, age)
> +		__field(unsigned char, probe_hit0)
> +		__field(unsigned char, probe_hit1)
> +		__field(unsigned char, probe_hit2)
> +		__field(unsigned char, probe_hit3)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->target_id = target_id;
> +		__entry->nr_regions = nr_regions;
> +		__entry->start = r->ar.start;
> +		__entry->end = r->ar.end;
> +		__entry->nr_accesses = r->nr_accesses;
> +		__entry->age = r->age;
> +		__entry->probe_hit0 = r->probe_hits[0];
> +		__entry->probe_hit1 = r->probe_hits[1];
> +		__entry->probe_hit2 = r->probe_hits[2];
> +		__entry->probe_hit3 = r->probe_hits[3];
> +	),
> +
> +	TP_printk("target_id=%lu nr_regions=%u %lu-%lu: %u %u %hhu %hhu %hhu %hhu",
> +			__entry->target_id, __entry->nr_regions,
> +			__entry->start, __entry->end,
> +			__entry->nr_accesses, __entry->age,
> +			__entry->probe_hit0, __entry->probe_hit1,
> +			__entry->probe_hit2, __entry->probe_hit3)
> +);
> +
>  TRACE_EVENT(damon_aggregated,
>  
>  	TP_PROTO(unsigned int target_id, struct damon_region *r,
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index fe14971d72747..54834b74efef4 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -1924,6 +1924,7 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
>  			int i;
>  
>  			trace_damon_aggregated(ti, r, damon_nr_regions(t));
> +			trace_damon_aggregated_v2(ti, r, damon_nr_regions(t));
>  			damon_warn_fix_nr_accesses_corruption(r);
>  			r->last_nr_accesses = r->nr_accesses;
>  			r->nr_accesses = 0;


