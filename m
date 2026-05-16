Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1318CD4F3C
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 17:31:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 002396B0005; Sat, 16 May 2026 13:31:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF6A56B0088; Sat, 16 May 2026 13:31:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0ACB6B008C; Sat, 16 May 2026 13:31:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D3C536B0005
	for <linux-mm@kvack.org>; Sat, 16 May 2026 13:31:17 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 884601C11CE
	for <linux-mm@kvack.org>; Sat, 16 May 2026 17:31:17 +0000 (UTC)
X-FDA: 84773974194.27.5E59D92
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id DDE9C80009
	for <linux-mm@kvack.org>; Sat, 16 May 2026 17:31:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gdVaVsiO;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778952675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=atGDr9kdcrg2d3mM0tDu58jKtAfqYoRqtjCdlvPV8jM=;
	b=amlzaBVfH9MN/bP5I9qARpIZaVVzwjYccWRWlOMjT4JYqZWFq0HTMIAJ1GvWIuIcQB6621
	owWNQlWwA57LbVtfpy07pa6o0gpN/hAnvVo2K8ukIGP4RspDnFsJwO8EXVZOiIa+8sD9vZ
	W5zj8ExkNSiW+q9eTqhYl3e/MESI3zg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gdVaVsiO;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778952675; a=rsa-sha256;
	cv=none;
	b=lawCS9dG3KL3dMTfMRGlDMpjWvfI+EloIFPxWzy+jxqg73GRF+fRJQTny2ESg+CHjAz8dI
	17SrhF9gAk6BIJAe+bXWVSIGU6lFPTDY5Z5anrcPme29032Q3w9XyZsACbbUK+mpsMCt42
	g0J6vuvLrf9THDdStQSBEaQ22RDYQ3I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3442D60138;
	Sat, 16 May 2026 17:31:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F966C19425;
	Sat, 16 May 2026 17:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778952674;
	bh=SNjjBidjzGKmfFde6yETBzWsMij61VKv2/xFwvTci5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gdVaVsiOs2AYfzYCT64op6Zw2Ix0z1WF45QeXlhK/Jp7zuJkH4WIptL9JveJwcZx1
	 Lv7+zYdDbReHDrQKj/NRqwOerCWJGINJHywQJuplNIQrwFQ8eYzWBlmm5R40IFxfzw
	 n4xtwkrf80pCahA+TLzOqvlalNaXSMqSVq57JBoPAGvdJ3Cy/LNbdFwMi4iapYR3V5
	 tWmiJUujo8xyYRQO8KkBtD8qFm6VRFQhvPFrSsr13KcHH8r3viH1/wDQeKT1PbdrJv
	 G5SWlNpaG1EhBARy5opvq+2ITZ7OoeWG9xzDFQfqIP77X5JPD/OljeyMm0ZVpldRsh
	 BiCik1NSgu2Dw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2.2 18/28] mm/damon: trace probe_hits
Date: Sat, 16 May 2026 10:31:06 -0700
Message-ID: <20260516173107.148242-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515004433.128933-19-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DDE9C80009
X-Rspam-User: 
X-Stat-Signature: k3tuh5x3tzws6s7duosot1f6u39mu8du
X-HE-Tag: 1778952675-45534
X-HE-Meta: U2FsdGVkX19lnvtLrSNDqONyijCU7iumduokNrpXXohx9tFfrlu17oZNw5d0+NQkOY6R/wjkfjHbNQ446gL0aflch6REWkwhE/LOCf2FXA4V9RZruyB/Rt0OaGfAS41jZZN6klnmp7la1ItgjY8kFQ7j9z57isQtm1TzbLDfE5H7sAXYNkQH8/Kfz3SW+S79xKD6wFC4z+9QA00+ABXG9KL6cwAUZwiJCqSkOn70sMjOIjAJ5/BM2pxfJj5qepXPWSkFrx+XGwSQGfpLvoyatmofhYxX9Lel4pWY1uLjPssTSytCe05nqwkg12AwtEv0gjR45eeyJWLwdoscxyceXJaLJMLCrPFcBw1Tdv8T7Sb32f+HlGo9X94JQYe0PyXc82/A2gBfEuffjpfzFNfQBcbAoEDfqTokiwR4xNRlZRtNWJ1vayQe7jqCQi/DfgP3jTekc4A9jD165kQZ0mdb8m/hNg6j42IzNkp9AJ0OwIX9WgqsW+KKnN5CvN8li7ANYB48k4pLEmafSzGnd18vtTn71se+d78V6VRCfm4J62eWTSlJfNUjjtW0dqwGQg5Suh3yhoLLqR6SdOb2VoMHzWiI+0MUlHlJEdBm1uNqCkoMgB9WH2Qm3ykI4ER6R+j1hmke/Y9kWMzsoAgLZkZ7zkimgPmc08EqMgi7u7pLgQPWMQnyrdM7O5BzepADt3LPssNpNQp4LmIKLkANLg1z2WF3VQhB7BcuihWQ0fc8pGWkaP9BSjJIeGjtxIZk9wPr7SsQFSfceHI/YTb4zxAMYE6HN1k7EqLLaBZTznwAY/xKX2tGMw8vHp31zC2gbJEBiVa7lCCt0pP5Ppm6KN2O7m0yztTrAX/3X3Zpm2fJ5RCvGoNG2TAtpDoTxTRWNk8HQtQSfimuOgyVwcucQy35vZBsAn4gz16fnOdlLpKCATsYJyt1t+6+l4I5h8s29UpdLOj9SZj75vyhWAvvPsz
 GiLSq6Cq
 WeuxV49COsO3sok1//7JPdtxL/on/8XcH+EMw2YxC85QFwZ+24IXR0nR3ele1m1eTjK5Jq8/FYy23bFuUCslAkcWie5NJylZH5ySLLRRxe7oLKUrZT24XZs3+/+iGuJxJCPGXC0isJUuSsxh397yAsE5AX2pZFyJkB3Rt8GQVXcTtBmlTIe26vJTfoZhs29bsrJkoDCh/ApMDoZ9fF/KJEzKqVQbbAaH50F1Gxy3yjgOdlNwENU7NQGjgri3ZnorgqsVz2E2TFDmAnrRhKJbX+TOlHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 May 2026 17:44:19 -0700 SeongJae Park <sj@kernel.org> wrote:

> Introduce a new tracepoint for exposing the per-region per-probe
> positive sample count via tracefs.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  include/trace/events/damon.h | 38 ++++++++++++++++++++++++++++++++++++
>  mm/damon/core.c              |  9 +++++++++
>  2 files changed, 47 insertions(+)
> 
> diff --git a/include/trace/events/damon.h b/include/trace/events/damon.h
> index 24fc402ab3c85..ec1e317923fd3 100644
> --- a/include/trace/events/damon.h
> +++ b/include/trace/events/damon.h
> @@ -130,6 +130,44 @@ TRACE_EVENT(damon_monitor_intervals_tune,
>  	TP_printk("sample_us=%lu", __entry->sample_us)
>  );
>  
> +TRACE_EVENT_CONDITION(damon_aggregated_v2,

I was thinking [1] about a better name of this tracepoint.  I will rename this
to 'damon_region_aggregated'.  And I will deprecate damon_aggregated, with
multi phase, like we did for DAMON debugfs interface.  The idea off the top of
my head at the moment is,

1. announce it as deprecated on the document, by end of 2026
2. rename it (e.g., damon_aggregated_deprecated) by end of 2027
3. removing the code by end of 2028

The deprecation might be done faster than the current idea.

As Steven commented [2], it should be ok to immediately removing it or
extending it to have probe_hits.  But I realize I'm quite lazy at DAMON
user-space tool development, and feel more comfortable on this approach for
now.  Please let me know if anyone has a different opinion.

[1] https://lore.kernel.org/20260514000611.147809-1-sj@kernel.org
[2] https://lore.kernel.org/20260513203237.3b1b3286@gandalf.local.home


Thanks,
SJ

[...]

