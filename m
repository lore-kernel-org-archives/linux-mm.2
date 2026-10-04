Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BA5FCA5FEC
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 09:16:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D269F6B008A; Sun,  4 Oct 2026 05:16:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD7906B0092; Sun,  4 Oct 2026 05:16:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C14736B0093; Sun,  4 Oct 2026 05:16:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E1E16B008A
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 05:16:45 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AE4E640593
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 09:16:43 +0000 (UTC)
X-FDA: 85284388686.05.E986414
Received: from relay.hostedemail.com (unirelay08 [10.200.18.71])
	by imf20.hostedemail.com (Postfix) with ESMTP id E200F1C0005
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 09:16:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791105401;
	b=8ZvYJYlHmUYJ3uLr7HFGpxpROjStoU3ddiVJ8Pa6jXV805gH6lO/bH8HGDkDwOI945xm3P
	kYbSbHkX4DDVLI4nmVjJwdwUzN8ZABOsdA/ESGuUbHeNkYEzmOYPq5K4qgPkslvyn+V0Jn
	4Qje3x+vtlaWivk+90DzmpWU7t1McE8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791105401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pcvJ+jCMAJmM0AnDK31466hqGai5ZVEENzn8YaAuejw=;
	b=PdObjVdMNnq8P5um0hL/TBmZwnamTTNvfgQrwccp3guMUXWDTsWtELF1hodN6QveQVR1Dn
	ZWynfho1j4A6GTpMT7V4gAdC75SnX+cCM0CRGtgvbU0SZi2pOPq1mW0j9lHoWtPHlvSSIA
	E1kfUF7lZy+7wP5lDPhPTexSp5hVVpo=
Received: from omf05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 520041403DA;
	Sun,  4 Oct 2026 09:16:40 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf05.hostedemail.com (Postfix) with ESMTPA id 952BC2000E;
	Sun,  4 Oct 2026 09:16:35 +0000 (UTC)
Date: Sun, 4 Oct 2026 05:16:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, SJ Park <sj@kernel.org>,
 damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Bijan Tabatabai <bijan311@gmail.com>,
 Ajay Joshi <ajayjoshi@micron.com>, Honggyu Kim <honggyu.kim@sk.com>,
 Yunjeong Mun <yunjeong.mun@sk.com>, Akinobu Mita <akinobu.mita@gmail.com>,
 Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@linux.dev>
Subject: Re: [PATCH] mm/damon: add damos_node_eligible_mem_bp tracepoint
Message-ID: <20261004051632.71726836@fedora>
In-Reply-To: <20261003202727.3673-1-ravis.opensrc@gmail.com>
References: <20261003202727.3673-1-ravis.opensrc@gmail.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1++plVshDREp1/65N9g55w+NMnmWqeBIxk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=pcvJ+jCMAJmM0AnDK31466hqGai5ZVEENzn8YaAuejw=; b=UaAwM2oO6Vs0SeMXPz9kGc9q2fLKlKqmTw2H6rdSRsVD7Bo3aKpXTFvZwlh8zK+OBavXEnlpEi7YD/bU73MDV7p3sQWLPNmQGBupb04v0nderDm+bKHdQrtF9R0ql3HM0DJZerIz3v2no7DchRC2AEsGq0RF9wRsTHh9R7uqfVg=
X-HE-Meta: U2FsdGVkX1/sZ6OkXRl1d895imVbao+eFLq8ZGKTfRYFYqpekrSfk5wwPwGOUTd2Evu4vjL39RNPNr1q9lyU/bShTeEnB+bay1dplCDNECqxSPE0grBiXKG6VZWzuWaKoXV8/P7qmITFW4J+8W4GZlZ6oLk1M+ke2NLS1vWCusYRRVTXHVRGKXQIV3zxlFfP22BVG7l6crUFxIQtjMIEJFOW43D9ETpxzPqLu1stTZaZSZTgbNe24ZHoL6TasLei/52xnMp3KyhxuEDDyfXrvxEM0KPXCWRZyjjLkLcMKCke0GT95/Nvuu1kU50fq5uOSfUjuVm4exp3hZAh+V7TLSl2m7tUZL4H/fw6n1YdYVSUzkLx2DqIAw==
X-Rspamd-Server: rspam06
X-Stat-Signature: hgzpbhgko3ewzf83g9wi6bcmbayauxyd
X-Rspam-User: 
X-Rspamd-Queue-Id: E200F1C0005
X-HE-Tag-Orig: 1791105395-87746
X-HE-Tag: 1791105401-819620
X-HE-Meta: U2FsdGVkX1+RsNUNMFfIUomXep4/8vKE71IL97jVVCs6a6bkAcIhQbUnKqFqafiLNfkS/kl7MGbDZzkH2ty8a74FYNiU24T1sFMyMOON8B7P5zSerDXP+nnH8zc8PmiNExl7RabIjI1aBx+rNVOuc14YzZoMwCyUwdnGZeqy9jtChH/HVW59XiLjzV/pmGQ7MKmSdQq7XisODVuvBZdMzKVZEv49lU0k0v9OxIKurNuluMCBGYOdRTiit6EFQ3nKZ76N7qoFKEm2H+cVKhMk0hd/V3n2hGVdAt9pQlt2IEKomY3XqEj/I7dQYUnSH+I2SJlaTPigg7IJvn5wANNzUBUt0gDZySbiJSbueMdd6A6bi056I7Qni0oOYONJ23DfLl1zm5sUmEtc/Vp2MJX1sKcNJCrkI4vhU6UXGjPxyv6PquSAa1gS0XwbOjr8jiYN//SADTPst0TDkld+FgKp+v2Z51pYoJzxXdmuU3ISumcLodluS0Q3Fm+Hv71RF8wjcuY5jAPEzWEs8edL2/PwBxaDdcLA3VEhNlA6zvaE1W/sEMp51OsVD0JtMR88pIwXow0Gd9u30lOUszGt+7/WRYdUDMDtEbS51PHa5tjzJGo9C9dqjkp2mi64YpUnfA8SOuaH/9gCJLu0BcatnBWbs7LP2dcKTdP4voF+K2EfOvO3v0WcUhvuFt59HvsXBnrMZbPj/rtXQEw9ytrY2FmIV/oe7MkjKW3Tu1OEmhxpwYKxXOrVekKkCtUMH/a3Sa7t3J39mvtl7TvjclY2DrC40OsQqPnoMVzjy3pA22memUL26+HATeh3Ay01UcmIY5+3LUnUvJTI9T5Dy81ZOmCljXPT5J2OzA5Y/6C9Kyc+J88h6r65JpFb/3H5aVV97rbtM1ftUMxg7OyI8cYZ9BYGGjWaIJ/SVBVD7xgpcb8g3Q2abQMfU9rPTYGOCbc6hh6yiEw5Y5R6fAqqYu6JK1y
 NG408DRc
 8riTOYkHKg6CLSiSOlo1OSJ2UGZv/7C8WcrHtTX5eK60F6BgcuVnUNZ1Ukcy2/v+YcETo9pn9nndNu8W58/oSwxosGSK8kxrbdh6sqZvnZkGSSu5j7UGGV3f3SjwRtaoTXkLKFNGfFsrfHRC+XCMxh3P4mk0+iIr6Dz4HS761ljtNao8ITzyhbCoub4bzJw4CQfhSvISd3Yt6382/yYZmXbYV47DJSTEd9CY1SyE6ZY8IFRC+2tWZhuk1pF3PUViEHawKIW5yKegIH9c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  3 Oct 2026 13:27:27 -0700
Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> Add a tracepoint for DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP quota goal
> evaluation.  The tracepoint fires once per quota-score computation when
> the goal metric is DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP, exposing
> context_idx, scheme_idx, nid, target_value, and current_value.
> current_value is reported as the quota tuning sees it, after the goal's
> complement setting is applied.
> 
> The DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP metric expresses node memory
> occupancy as basis points of eligible bytes.  This information is not
> exposed through any existing external interface (perf stat, /proc, or
> sysfs), so the tracepoint is the only way for userspace to observe the
> target and current eligible-memory basis point values at quota-scoring
> time.
> 
> Link: https://lore.kernel.org/linux-mm/20260428030520.701-1-ravis.opensrc@gmail.com/
> Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
> ---
>  include/trace/events/damon.h | 31 +++++++++++++++++++++++++++++++
>  mm/damon/core.c              | 16 ++++++++++++++++
>  2 files changed, 47 insertions(+)
> 
> diff --git a/include/trace/events/damon.h b/include/trace/events/damon.h
> index 8851727ae162..2c7249cc7c88 100644
> --- a/include/trace/events/damon.h
> +++ b/include/trace/events/damon.h
> @@ -74,6 +74,37 @@ TRACE_EVENT(damos_esz,
>  			__entry->esz)
>  );
>  
> +/* Per-tick DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP goal evaluation. */
> +TRACE_EVENT(damos_node_eligible_mem_bp,
> +
> +	TP_PROTO(unsigned int context_idx, unsigned int scheme_idx,
> +		int nid,
> +		unsigned long target_value, unsigned long current_value),
> +
> +	TP_ARGS(context_idx, scheme_idx, nid, target_value, current_value),
> +
> +	TP_STRUCT__entry(
> +		__field(unsigned int, context_idx)
> +		__field(unsigned int, scheme_idx)
> +		__field(int, nid)

Can you move the nid after the two unsigned long values below. This
creates a structure, and on 64bit machines, this adds a 4 byte padding
in the middle of the ring buffer.

> +		__field(unsigned long, target_value)
> +		__field(unsigned long, current_value)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->context_idx = context_idx;
> +		__entry->scheme_idx = scheme_idx;
> +		__entry->nid = nid;
> +		__entry->target_value = target_value;
> +		__entry->current_value = current_value;
> +	),
> +
> +	TP_printk("ctx_idx=%u scheme_idx=%u nid=%d target_value=%lu current_value=%lu",
> +			__entry->context_idx, __entry->scheme_idx,
> +			__entry->nid,
> +			__entry->target_value, __entry->current_value)
> +);
> +
>  TRACE_EVENT_CONDITION(damos_before_apply,
>  
>  	TP_PROTO(unsigned int context_idx, unsigned int scheme_idx,
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index b63e60ef8990..6ddd15dc4f55 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -3294,6 +3294,22 @@ static unsigned long damos_quota_score(struct damon_ctx *c, struct damos *s)
>  		highest_score = max(highest_score,
>  				mult_frac(goal->current_value, 10000,
>  					goal->target_value));
> +
> +		if (goal->metric == DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP &&
> +		    trace_damos_node_eligible_mem_bp_enabled()) {

If you move the trace_damos_node_eligible_mem_bp_enabled() before the
goal->metric check, you will save yourself a branch when tracing is
off. As the trace_*_enabled() is a static branch (nop or jmp) it has no
cmp branch, but the above will keep the goal->metric still exposed. By
swapping the two compares, the goal->metric check will be hidder behind
the 'nop' when tracing is disabled.

-- Steve


> +			unsigned int cidx = 0, sidx = 0;
> +			struct damos *siter;
> +
> +			damon_for_each_scheme(siter, c) {
> +				if (siter == s)
> +					break;
> +				sidx++;
> +			}
> +			trace_damos_node_eligible_mem_bp(cidx, sidx,
> +					goal->nid,
> +					goal->target_value,
> +					goal->current_value);
> +		}
>  	}
>  
>  	return highest_score;
> 
> base-commit: 763ad0211c7b587344f03bc4d1299810aeb736f4


