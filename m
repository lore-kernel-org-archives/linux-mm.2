Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79FC5CA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 10:04:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21A626B0092; Mon,  5 Oct 2026 06:04:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CAD36B0093; Mon,  5 Oct 2026 06:04:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BBC86B0095; Mon,  5 Oct 2026 06:04:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC24C6B0092
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 06:04:48 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EC03BA5BDC
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 10:04:47 +0000 (UTC)
X-FDA: 85288138614.07.9FF0BE8
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 289164000D
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 10:04:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DWPyQ7Wt;
	spf=pass (imf04.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791194686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ndTgZQw5uRGHNOH8AqWMxH2rBGXg/PpSxnD0ym+93as=;
	b=Uec5HD6If2aVYRwc7UIeIePHum/7P+xc8t+9YAcEo4+tAcHk0fnAXj7PukGRvJsvgCjCLW
	sBSchqxI6/pbxq6gwd3StcbXl+0aJfE+iDNIbDcRKXExHW6cDhg1ZIALU66HwETPLN22cW
	aofadEzooxT1E9am0LoqU3+G3rW19kI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791194686;
	b=Pci8BmtZRRkjYi7auWQ5knssgc/gucSzATWlnbqL2veOGwhB75wvdYfwJzDxS1HuF7aylR
	W1mA+b1x55Q9ROKjwWovPXN3MeGxgi9iSw+p49QXrUxQ6os8SInJVDPFoiTkoRZTFJnYly
	ymOXfWjTY4byHTXUoYfXZBXu1/usYZ0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DWPyQ7Wt;
	spf=pass (imf04.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cc4c7fab7b6so1030718a12.0
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 03:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791194685; x=1791799485; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ndTgZQw5uRGHNOH8AqWMxH2rBGXg/PpSxnD0ym+93as=;
        b=DWPyQ7WtHQ+UrhvCnqplfhZPBpw02ZyUj/QwJWDHjw9Wjtn/bdunSlI3KSpkbPjXcQ
         nk7VudOqK0x6Ni6N55wjk0jLgNdvd/a2aD3YvE97TBi7H/dZFmJuQk/iKD2sqmZzQp+G
         sW3f2W9BkTJwxTwR4kMdcuEsgt65yac+mvY16+iGnY6noL7FHCR/W7kxxauJwHC5RzZH
         Iezto0i5c/OV4g1db+KmilyopPJArau5Jfx1QEbhnZYKa2k0NPQ6JMij9lGJT0Htgfck
         LQZ8+V+ANxnpPsOlXKl+YkUzeIckKG6eZNigpBRjLa1x3l6beRYfCFE+VCTMRua2fx/u
         HAaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791194685; x=1791799485;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ndTgZQw5uRGHNOH8AqWMxH2rBGXg/PpSxnD0ym+93as=;
        b=jxgbNr7N3z+6ftHwVuEs2JcqjvxYd7bUThW36zSa5YThMTes/A95xi3a0pClyYczHu
         EJfYKUFT+Mf/Skqm6uGYS9NGprDmfJHgN2oVhL3i8KBYBTHsB9Eyh9+nsIwBHPBqfDf1
         5dqXfKM3NENInokgCKSBSVfmPOymZoI7zwKdz5UEBtPAsWOdAVxbui5GGdpdTD1eXyHg
         zpcdZnBpHmXMjNZfp/GaRCgC+M49J7hZPF//5kvsfXCAZet4M2bhgQEAjZY6fAPkd9rb
         13ccqcP7Ios9QEpUWVypP5fRICSQV+OvHNB7M/ARa+tFXETjwUz4uUMvxIfttLj5eGtS
         NSvQ==
X-Forwarded-Encrypted: i=1; AKwUvByy+gVvIP3byiy26MX3YP5b7FTLGIRk9jQvrse9wbD7t8l2y8czBtMmq4ItTyxvRLu/9RiqikzSwg==@kvack.org
X-Gm-Message-State: AFq9FYIzZvTCp/jPqpU1WjCH3AECmJngbWT+WV1wQYtD8RoaWUk0QLmn
	1c7MbjNq7UpRwWwcsI4Z5mzERIUqrSaxv+Sx7zPC7VcdCVNCx3VX4uqG
X-Gm-Gg: AYBFou017H1ficI3KUyN6w/NYjhLNRl927UUO3lfDHUfkRt/3vz/PvbCIrGbX3jUW5Y
	5mCBo1yCtp222G4qSplAkSfCyhttL+JDVKikkGqpXN5qTAyumkQDRxCKw8Ln15JaO/8ACfMTlbk
	LkLzBQvpeoj5u1Z3jc94iNiKvEsLpqIpDhbuZxsv5DM03mEft6Mi2RyemAQYFwtWJKUdlZtkUjL
	Y7nWAXNPDiicUZuAKo82JcRLLkOIi0ETXxKogV7oSdErvZLsp0ignl4ilNTxasJlC83ZUKm9LmP
	x4PSfl1t4AgyQuPyfbevv/K7Jf9mc/NYcD9SgB1akHKFdbXlzkGEzsiyNQpMHfH3NkNEDsWwvtW
	tagPKgjikxSIGeMOKehzWSjecsQFR6JYG+gVXTYKIGgqlJxua23EEGx9pHCvCGl3fFvw7a36utW
	O+QVROQaUPqwIH0HOQ/qCzQJ8n49gtTLbcdIwnI2IBdugaauCX1MBxnSxI9yaqTilO5t2hbWwz2
	ixhXOAFU4kDkh9zG+Xa2A==
X-Received: by 2002:a17:90b:2752:b0:3a4:b0b9:6b3e with SMTP id 98e67ed59e1d1-3a7873d9565mr5545486a91.36.1791194684453;
        Mon, 05 Oct 2026 03:04:44 -0700 (PDT)
Received: from gmail.com ([216.195.201.24])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a78e4cd01asm10487467a91.14.2026.10.05.03.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 03:04:44 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: Kunwu Chan <kunwu.chan@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Bijan Tabatabai <bijan311@gmail.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	Honggyu Kim <honggyu.kim@sk.com>,
	Yunjeong Mun <yunjeong.mun@sk.com>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Lian Wang <lianux.mm@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>
Subject: Re: [PATCH] mm/damon: add damos_node_eligible_mem_bp tracepoint
Date: Mon,  5 Oct 2026 18:04:29 +0800
Message-ID: <20261005100435.1211485-1-kunwu.chan@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261003202727.3673-1-ravis.opensrc@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: h9hos3ao4o7xhhmyhcxeowx9om95rwse
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 289164000D
X-HE-Tag: 1791194685-679681
X-HE-Meta: U2FsdGVkX19w1B74jukrGc3YxMvddeqVpB3eB6LHtw9Mrftz6qgS6sN2xd7iDBbEXk6/6f7WylykiaOAeqHviWpR220tN1KIZcn+9dbXqGb5UjU8yMug/4ap/bryoEcnQF5ot5IaIa9br3D/FWobqPVWW2PqCOZXPrrdTKwAhaVoIgU0erwdBRAiKFoEa9X+4yWmgEIdJJdHlNiZPtqc+uULZr28fqFoxoE80Rv6oTErhyF0LWAR+gVIcnEBiIVtI6NUiGGi1UFxreZjn7uDvu8GeNnqjvObUcDoRD9Ev0ks8YP1uYWW0X4lCHVNGtrOTJdp2MWm0DgVIcFISncNJb+x44BfEOZvdvZMOCPq3+lhVzz4cc36FWbQ2Ox5PRzmSkqaj2xo0QrjbsFjM4yiOcPVrecAN7EWrDJvIGQAk2PkK0pqNPcRn5sOLpRee7VNO+GxzBv3JN9GohWOMvhFuD2OuPU0Y5OwU1P3zomVwoKK8eJT6CzcKESHz74EgFvCvLgW+Wa4p7VxHQKHV6N5i6fxUqT0YDoQZYjkBXCgIAsDFPhPa1GzqGqrnoWodZiudXXWcA7pm7SCbMWHN4FmyvWnSduXJZRSpEzXUsL2RUH8kG8QJVnem1NDpzYa8FQqih8+Ri9KZTDorNldarGi0Hme2RGTnAL3MKSA6pSNp8xk3ZK0O6mTvg9rfzwWYj56nRHILmZMUcB0+8BMCDWJgwBQ5n7o3FxI4wGf8cSStTcMA4WeCg9dlzGuxwSPe+hu5Sths56fWlo5QEYJ5cfLylQn1gZZBdXuOj4sW/NR84c6lJMSYGjTgLH1Wt8duHXx8AEh2XS4qgVHU5b8ws2ZZwu5lEzmgiFp6Wweh6/bp3JvuWQJHPvoHOoLMskml1dm546ZrFeTKSLDeqeenC4TNgMYia4ODK8cPvVsH+dENtyvH1cBov2W1rksGnFsfXUQaYyI2Ek70agXX1YF5rn
 dtNew+xi
 Dj6ExGtfzjoqNxCv/38320rg89zBZKj2l6Vg1C+AZtMMjVFtIIurYPbNfMgRB2Tab/ZsB+rN4hkb/ViWhkCSdvb7PvRpwCKuIXZG8cM/O6LXFM5taBNCHmEju/DgY3yub2vDuFcoP43EZCmfcc8Q7WBtfT8N1xbOnVdbi6BT1ryOFM06vsJE0W5QY1sCf2xJCFFIL8CsEZiJl2bEuV5lUG4FwolVfijlxyOP9Y5yzP2JS0td8OC1Ya/WX0fYdJpLyCZLB4zP3BNgk5OV3NK+fXc1jbzAI7ksMdyryZe6dKdKqSip6/tvsVRQHsqxXImQ7pgFYszfezABOJMjy09+z7qO2dfmwynr8td1/eOiFaeZBq6PCmJqWq9l71Y7hBUUMRCKHvoAKIN5cBrOFvSu/23i2h9NvK3mBHFMWWbakVDnw5f452o7HAU+pRlKrALQ8Xl/a32WXGv38ntN9IhLvLW945ZkOAzmw0Obqi7nLV8WnzpOMxYWJ82K+e828VIRqQYVt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hi Ravi,

I agree with SJ that this would be more useful as a general quota-goal
tracepoint rather than being specific to NODE_ELIGIBLE_MEM_BP. The
target_value and current_value fields are not metric-specific.

On Sat,  3 Oct 2026 13:27:27 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

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

The comment says "Per-tick", but the event is emitted for each matching
goal in damos_quota_score(). "Per quota-goal evaluation" would be more
precise.

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
> +		__field(unsigned long, target_value)
> +		__field(unsigned long, current_value)

Also, context_idx is currently always 0 here, since
damos_quota_score() only has struct damon_ctx * and no context index.
If this tracepoint is generalized, it may be worth considering how the
context/scheme are identified rather than introducing another tracepoint 
field that is currently always 0.

Thanks,
Kunwu

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
> -- 
> 2.54.0 (Apple Git-157)
> 
> 

Sent using hkml (https://github.com/sjp38/hackermail)

