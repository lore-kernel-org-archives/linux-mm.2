Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39991FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 18:23:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 686D76B0005; Tue, 28 Apr 2026 14:23:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 637926B008A; Tue, 28 Apr 2026 14:23:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54D6A6B008C; Tue, 28 Apr 2026 14:23:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4190E6B0005
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 14:23:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C99C4C0B51
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 18:23:29 +0000 (UTC)
X-FDA: 84708787338.18.9647427
Received: from relay.hostedemail.com (unirelay04 [10.200.18.67])
	by imf17.hostedemail.com (Postfix) with ESMTP id 022EC40014
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 18:23:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777400607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1eYUjbbyndGu1rXwATzecgfGJKBBopj+VpiTWFKTeN8=;
	b=hsDVqW8ytXgg3t72irse6Sg92pUdNCMXS/RuXPvYtJZFLXviYQCV0DTShSqhaKscgqwnWb
	WM7GRwvumTviurbgnTBi99RnqkrpFwm/KO4hE69KTMIcOQypXri7zfkm2/fosM39QqMJ4F
	dg3x077OgTQGeegus7zcy1cKa5syhO8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777400607; a=rsa-sha256;
	cv=none;
	b=P0MxEm9ALW/SmVXiLRL54xZVjaxyG6ASRVjwBQr9vl26HeBFr7YJj9US/5s3fcK/nf/aoV
	xofKO3YuS3EWSTcoJN7VWxzZ3UUSX2TqpzAW1hVO7hlq9rJ5jNAg+fI9a4jGiNnvGZL4if
	raW+NTm1YhJPRfRnwxYCa9DRwWlyQGk=
Received: from omf17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CAAAD1A019F;
	Tue, 28 Apr 2026 18:23:23 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf17.hostedemail.com (Postfix) with ESMTPA id 18B901A;
	Tue, 28 Apr 2026 18:23:20 +0000 (UTC)
Date: Tue, 28 Apr 2026 14:23:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Bunyod Suvonov <b.suvonov@sjtu.edu.cn>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, linux-mm@kvack.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, david@kernel.org,
 vishal.moola@gmail.com, corbet@lwn.net, skhan@linuxfoundation.org,
 linux-doc@vger.kernel.org
Subject: Re: [PATCH v2] mm/page_alloc: trace PCP refills and PCP zone lock
 usage
Message-ID: <20260428142335.3bca0166@gandalf.local.home>
In-Reply-To: <20260427060142.131055-1-b.suvonov@sjtu.edu.cn>
References: <20260425091335.346504-1-b.suvonov@sjtu.edu.cn>
	<20260427060142.131055-1-b.suvonov@sjtu.edu.cn>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+UFa9J6ZZ2ZCYIdHrHbaM4b3uPpjbsHn0=
X-HE-Meta: U2FsdGVkX1/1l2zYtyLHECIBTXZzaTsijdArxXDL4dGI03ymfn0eos1R7Rf+Ej3EUn4kWeGDWlbhwXewVl034g/zeL6EG9CH+GSQ8Y/65m0p8EEr+n1xRHjJ5cFgWMn3j6I/sfs/b99G5BwuBXrYlkQRznZSlEFLJcUughZb5sAYSlTghZ7hPj1ytx3ftMELzol4OThU1AlAnEAyefusg1kLtNCjN+wJPn8Qc8HoGTLxaHIp9q5sQPPVJiFKvNURHMHPNPbcdob79uFscTR05YKjPdvaM+/u7earOlCco1y6I7PcA9+iXuNPVCyMbA7X
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 022EC40014
X-Rspam-User: 
X-HE-Tag-Orig: 1777400600-860295
X-Stat-Signature: jpczmtwahztt1zjqjftxr8k5jpj5d63s
X-HE-Tag: 1777400606-963061
X-HE-Meta: U2FsdGVkX1/GKH2kM95ReId6v3oixYXYv21Gkra9O+UfG4nA2e0aa6pY2Mji/R4XiXxi/JdbSSKaUM4LH0zdpwMDwKZ1mZYe1EJp3zrK3SzAIjJKYn5l+X5hvFpsXNzG2p11GFgqmtD3pNSz+phyOF4+19Atgq7JV4gLRFL2olPGDg86AkMktoauvO1JsULPsLE5y71F4xMeVM4Q645YqdBfNKCz1+rdeCVCZLoTT2tmNafOVp8pxAuaqrOVq3FhhDHzDvXAgjMWg/S1mRHq/aqRaxfw4H49gIK9uenjALqAl6bcMAASFW6jKHYSbKGv2/CB4lSrDFJVMmZXFA3ndMxnWcQ/mOqoqQcbq0gEHMPinNEPhM7FGsUFPRq6Jl6PxdZzZ+9bpJmjfcP/oM0ZCuzw3EFwWnpSpbQYp3z6KrFn27lAmLDGzci8pUzV7vA0yINe27ZJLsq8mqh40/zcJxiU1kOyIsJdMLuNX+3QjYzFE4L+YA/N1q/pTwYbStuI1sED1fTj/z7kqYMlckjRO2UqedTGdP69a3HzQlrFt8Fz8/P0KpXtZhUGRwK7w1yewt7eF8iXa86MMH8hga7aD6Oq1upwrClBFyPu2aQWjvKXKuD2a8iTx/3fhYseyZLe3D+aEICbgRVM/qRtm5IXJZl0OCGO1XsBVIDqz0wjXoiOReLUkF0an8JFfjtg8LDQw15JlFbfc/0GKuYKyzKLYYsJKjfcqT0HFLxrgsSiYjT8chUXwyl5hhTcbCzDQb97fCo5dBokk1MBTMDf3dBwE9K1voqQB4Hqc4D1WLjJ4lnArpFF2iYEHsXHH3q44zGowsfBC90gzul5vnH2Zpf7GBzH3PZW7pSCOgq0vxp37XkK10o/cduNYj8dCsHFzHarcZDbJyA95pIFYFbYfQU2UFh4VDwLCVIdOuRYe52uiEpwlJ8jVhuia2K4VE3u6loFP/sCtaWAm/DJ/MmBY5j
 8tbTlnLf
 JwtIG8DY7DfjsyA/W2KIsIrdDT7MH99qANwueDGO8sd/jro/ZqjntZKrSnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Apr 2026 14:01:42 +0800
Bunyod Suvonov <b.suvonov@sjtu.edu.cn> wrote:

> +	TP_STRUCT__entry(
> +		__field(int, nid)
> +		__field(int, zid)
> +		__field(unsigned long, nr_pages)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->nid		= nid;
> +		__entry->zid		= zid;
> +		__entry->nr_pages	= nr_pages;
> +	),
> +
> +	TP_printk("nid=%d zid=%d nr_pages=%lu",
> +		__entry->nid, __entry->zid, __entry->nr_pages)
> +);
> +
> +DEFINE_EVENT(mm_page_pcpu_zone_locked, mm_page_pcpu_refill_zone_locked,
> +
> +	TP_PROTO(int nid, int zid, unsigned long nr_pages),
> +
> +	TP_ARGS(nid, zid, nr_pages)
> +);
> +
> +DEFINE_EVENT(mm_page_pcpu_zone_locked, mm_page_pcpu_drain_zone_locked,
> +
> +	TP_PROTO(int nid, int zid, unsigned long nr_pages),
> +
> +	TP_ARGS(nid, zid, nr_pages)
> +);
> +
> +DECLARE_EVENT_CLASS(mm_page_pcpu,
>  
>  	TP_PROTO(struct page *page, unsigned int order, int migratetype),
>  
>  	TP_ARGS(page, order, migratetype),
>  
>  	TP_STRUCT__entry(
> -		__field(	unsigned long,	pfn		)
> -		__field(	unsigned int,	order		)
> -		__field(	int,		migratetype	)
> +		__field(unsigned long, pfn)
> +		__field(unsigned int, order)
> +		__field(int, migratetype)

Why this change? It makes it much harder to understand.

The above is not a normal macro. Ignore any checkpatch warnings about it.
The proper way to do the TP_STRUCT__entry() is to make it just like a struct:

struct {
	unsigned long		pfn;
	unsigned int		order;
	int			migratetype;
};

Thus, the macro should be:

	TP_STRUCT__entry(
		__field(	unsigned long,	pfn		)
		__field(	unsigned int,	order		)
		__field(	int,		migratetype	)
	),

-- Steve



>  	),
>  

