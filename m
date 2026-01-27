Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6EDDD2FEF4
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 23:44:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AD606B008A; Tue, 27 Jan 2026 18:44:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 598906B008C; Tue, 27 Jan 2026 18:44:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CE696B0092; Tue, 27 Jan 2026 18:44:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 40B736B008A
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 18:44:27 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E5A0CD3532
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 23:44:26 +0000 (UTC)
X-FDA: 84379375332.28.CB59E8F
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf18.hostedemail.com (Postfix) with ESMTP id 17A751C0013
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 23:44:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rw9aTQfc;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769557465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rWKhogrgDYfP+mABM+WRRO2AR1U7gX8ZMeWgwNxCK2g=;
	b=z6/LsTQnndYycPMAEj6te3V+1rErnZk2k7fz73SRsPSkr/KCTf7dFu2ETJ4jNUuYfjm9on
	QdUuj7h99gy2PAhia09fY7iBirCGptucHN3tQQCEZmgrw5OUOJSpTSKV2JTtfj4wkmxk0D
	rSxaevsfteX7fQC6bRi6n7pvdKsCCmM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rw9aTQfc;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769557465; a=rsa-sha256;
	cv=none;
	b=5b4CtoaH0tfealShMKqrxjeDtLfxs5eDnyRSM3ULEeqAXQ7ZXAyqgOBZl/INeXPWV/keOk
	OxnFJDGcNZDltdMXaZU8KlXdTbef/UFCaR+w9lUsYq4bgwNO8N8fllt8VnWIsFvRoMLrib
	FVkaHLfyZ/08HikRxCz1oOWpzASKu3s=
Date: Tue, 27 Jan 2026 15:43:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769557459;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rWKhogrgDYfP+mABM+WRRO2AR1U7gX8ZMeWgwNxCK2g=;
	b=rw9aTQfc5op4FjU7TIB4ogB5HvPbv6+K9tFpTKVOMNNTq+wuLOzHxn/AwqXIUdIJfwh0EP
	vf9lOCmrG/fbwLR+XksFm2jGheXRIHpI2rhdPmI7jwKFktW71NT14UIRhDa/RST2DoJk9x
	Z5rtR9lqFbL5d0piShKOUCbpRXzVoSk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Thomas Ballasi <tballasi@linux.microsoft.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, mhiramat@kernel.org, rostedt@goodmis.org
Subject: Re: [PATCH v5 2/3] mm: vmscan: add cgroup IDs to vmscan tracepoints
Message-ID: <aXlM7KqRIkerP8Pa@linux.dev>
References: <20260115123809.2257-1-tballasi@linux.microsoft.com>
 <20260122182510.2126-1-tballasi@linux.microsoft.com>
 <20260122182510.2126-3-tballasi@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122182510.2126-3-tballasi@linux.microsoft.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 47s7gek49e94jqbq8n5pdjyr6in6g976
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 17A751C0013
X-HE-Tag: 1769557464-75487
X-HE-Meta: U2FsdGVkX1+E780owT6RHXhjqng181hnRBqFAgN2BNc+6jui5PSPdmCP7MR8mdwx/my3vLiJfRaiyHVFcwGVJfuQjqTWxl31L+vzEV/ytjPVesoIQTA2C+e4IBcV+fA2gxk+F2QYDXUQwnJbFak0TL/EddUGJp+QRhW1ChERjRYUrjUsxILFYU0jmH+zZ3TLINRI55lWhAqz8S4iis9kEMAdpZracMXLaIlzJ7RD87NjsEPJ2gwydXyeFzj5Pz23gREzTD3SqtmATeTwALCE1n9XqzV2nV2ro70/cVhc+0HaCtx2sqiJUmu9XmMnGYt9YzHdCsBy0sdFYumMKwH9eWFOPblW4WK/UFaKKeF6UEwC6F/CW3sSoyiOc/4z72dW5l9my3rrEKoKU3lfpVYqhillHyqD1Lt4rvX6KRmeFU11L5gfQygK/wbS7RVkhHjDlgpBUN9M6e/D8Js8kyHWU3V6UQv8CdxCpIeVrl1fcSXgYvRoHZtTEoQmX2SarIbG6kplld6CoJ+V0HPUT61r7OL955YQKFb0z1Lov+uD48XqrXH+r5sYTzYzw3bhD3IYaeI1GRXevvZo0Sk7+51PvwxX5Ik4wFpKSQBhar4fH0c5SgFxcfZpTmZEX2mDY2YRgc6vuJ4K9L56NY5uzj3rfx6YjQ0bQWGnq0d43KCXUZuPUhu6dkOF6zZTJhZTW0759PIm26FSxGZqgbzq56CwEMhe26aw9IrfPJR/g/CY87XjRgjlgyRZQYpVac0JyPnu2652DE5QTv/I6FFXgtVYNJeKLB+TzsG4OkBAUZWKVovGh5Ilvs63DrG82Yz3QA3hY8SfbwjtTZ5AuJEsS/wxaoQSaNsbaha/3atBYUILFttZUwDCrmwnMzfW8s7iz2MmOB8SPB3cReCy7Uol/LLrQFvBzUusoO5mGRkql63C8pjmY6Z3+FYvVMEMOngI+7uiZWGhE3kKrdDnWkv3Daf
 uvO6ajBV
 sT7LKrOvIMAQ1D0DaLKn5SluriisCxWn9CBOaY5KwAq0XChG/hDLdye6Gi6BhfXIpitXMuXYUYu77fMLjBe0SrDD+nsb6iILkihiGcE3HLSsGoL95NuNdii35TLZVL/NgUYqfLD7aiIZlsh3cNjQCJKtLY96uLha+zc+lhE7a93uym5ridXSMlNoVp8c2oYCCAGPJC9h9EMQ1MCuWkR5AaniVQMlo2GqzNSmi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 10:25:09AM -0800, Thomas Ballasi wrote:
> Memory reclaim events are currently difficult to attribute to
> specific cgroups, making debugging memory pressure issues
> challenging.  This patch adds memory cgroup ID (memcg_id) to key
> vmscan tracepoints to enable better correlation and analysis.
> 
> For operations not associated with a specific cgroup, the field
> is defaulted to 0.
> 
> Signed-off-by: Thomas Ballasi <tballasi@linux.microsoft.com>
> ---
>  include/trace/events/vmscan.h | 83 ++++++++++++++++++++---------------
>  mm/shrinker.c                 |  6 ++-
>  mm/vmscan.c                   | 17 +++----
>  3 files changed, 61 insertions(+), 45 deletions(-)
> 
> diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
> index 490958fa10dee..20160e79eb0d7 100644
> --- a/include/trace/events/vmscan.h
> +++ b/include/trace/events/vmscan.h
> @@ -114,85 +114,92 @@ TRACE_EVENT(mm_vmscan_wakeup_kswapd,
>  
>  DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_begin_template,
>  
> -	TP_PROTO(int order, gfp_t gfp_flags),
> +	TP_PROTO(gfp_t gfp_flags, int order, u64 memcg_id),
>  
> -	TP_ARGS(order, gfp_flags),
> +	TP_ARGS(gfp_flags, order, memcg_id),
>  
>  	TP_STRUCT__entry(
> -		__field(	int,	order		)
>  		__field(	unsigned long,	gfp_flags	)
> +		__field(	u64,	memcg_id	)
> +		__field(	int,	order		)
>  	),
>  
>  	TP_fast_assign(
> -		__entry->order		= order;
>  		__entry->gfp_flags	= (__force unsigned long)gfp_flags;
> +		__entry->order		= order;
> +		__entry->memcg_id	= memcg_id;

Please pass memcg pointer to tracepoints and call mem_cgroup_id(memcg)
here.


