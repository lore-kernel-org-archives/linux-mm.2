Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD626D68BCC
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 02:29:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 389CD6B0088; Wed, 17 Dec 2025 21:29:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 337556B0089; Wed, 17 Dec 2025 21:29:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 243CD6B008A; Wed, 17 Dec 2025 21:29:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0DFD06B0088
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 21:29:20 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A89A816048E
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 02:29:19 +0000 (UTC)
X-FDA: 84231010038.11.CC0FDF5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id C62BD1C000E
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 02:29:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=y1ikC2bI;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766024957; a=rsa-sha256;
	cv=none;
	b=0vHVyhHd9Zwk8fQQGVcVGWZlo/PfTEPK7sHD79hzSthYtN0Gq+siGHtBDIWcYR+DlGSjUz
	YUdEYfUArfzbLz47dGZrA0JowPQ3EsJwQc8ihcBxANI0X1AKqixlCiA3gRr5sF6KTowwKB
	G86qbRlKEzI5YuJxXhd+pUKO4fpIzzY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=y1ikC2bI;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766024957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M1WBau27FWCT73pl5CqAFioOtGWmEf5XBTzGN/88Y9M=;
	b=16ID2R4ujXN6BvhyiiJWbGobKOewpeKgtGq2ORt3LieKdtnRgMb18h9YkvI5R3Ope6Oio5
	5v/z+8EiAz0FyZV/FooiRAkagTV156AqroZ1H4XPnNy9SwKR9mZ7W5wWm9e3woqLRPz5tq
	VlF5YutUfX44poqcBnHFoxElAUjcjMM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EBD88600AA;
	Thu, 18 Dec 2025 02:29:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5579BC4CEF5;
	Thu, 18 Dec 2025 02:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766024956;
	bh=Ld07Vda6IixwRcRyakjPgYDvAjrVt2F9zTBIS04BOdY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=y1ikC2bI7zSdD4HUu5+e0WzHBTNPqUeFbYw2cjjAdX6LTJ8GH0U/PAYyDjUpBbpB+
	 5B+9gpClhr4QU/npEMxzNrCmTj1NPKjuaVqmyALxB91fEQ1f21FJWQpU4W+rRwc05a
	 n4xiIDZQEodQNF9YXi1vGsVTe84Q4nwSZXlqUUiM=
Date: Wed, 17 Dec 2025 18:29:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: SeongJae Park <sj@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 damon@lists.linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 12/12] mm/damon/core: add trace point for damos stat per
 apply interval
Message-Id: <20251217182915.5284d66b58ac7b744b8dcf7f@linux-foundation.org>
In-Reply-To: <20251217235219.2750-1-sj@kernel.org>
References: <20251217174851.28e7c4e5@gandalf.local.home>
	<20251217235219.2750-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C62BD1C000E
X-Stat-Signature: 1wx3owskz4j7cew7jjz8dsxus94iqwdf
X-Rspam-User: 
X-HE-Tag: 1766024957-437413
X-HE-Meta: U2FsdGVkX19dXDmoNBFn6vmDqzqo1Q9Gn4GBXp7paixO4RXRdJ1bIw70qnKbdZX8cW/MbAj9x+3cceXTAnb51qqS7XNO/a5MkgSK01dsKCQTXRVaN4qnxAfP6Uze8G5j/AzE3+IR9Yu+ie1oO8vuDnGGw+QKHy6YTR+uqP/V6dPYbcfpnsxBWLJYvPESyl5n6jKA1ZZd/SUlax+QfFt9Ray798C5ZPWHeBCATxvpLSHHPPBalUFSQwzMHxFbHAdOUb1J8JLKbtS1BeaQwWraTM0RpHBf7kYsFkV9k+OuA2MeVbDUonF8rJZpJCVcKzjqFHWqmCBrS2x52/9Aj8eD1FBDrbA/C50r4giLaUyhiOx/Fmd2Mm2pX+yrdZzMcObjGFupxB7qhowBDWGjQGBoopkCgtHfpDl5/YlGQh0YcgQhPtZ5Vw8u+AKFnE9TM7a4LFxYgP9VhqnNhYj/CrJQzEC/obklWhDnQmNcwp7KQXAr/3Kaklddt2uQOQzbv+hA//rB8sxK49HTPCNeGcTvVhXz1g81NvRu+ToezAkJFB4zOHtXNbwuOgf/hZXoxVF4CLV0XPYe5g4B5fa6sgejKybDNqknLZZNfGK+nXcN0ebSDyvBCyMaRHHiFpkpjMYxbKiLHQGcJyP2lmq1ZW/Sh9RXXKRcvwEncYNC12VxNyRi4nwlX2Sv5miRKhZQA71RjizeOS9wmDBBzSsO8uX/8nfnoXu624u/wW0DhfWskhnuv/A/Dl9/Pc/R8mC1Dz9qtH45WQymbUVnTlOcQU33btOXK/eCqY24qF1kO1xqtJkV5M1bOgcJc4M4WPGtPLc8NLGcI14UeF3A1Jq7awRihwFf/AGGu6LKaBEyo01U5c8CjmJOONc28ueecvP1JfStoDhvBp0KGIpyIOAyYqDhTSJqWa6oH7q1wZyR9eVxQ2AGzHjB91SsP/GRz1hPSajicdXgm1qtfosKijqVsTR
 3MrUguXg
 UwCu+zSb2ryPHvVsItT8PPqbI4F5pfGuvSEs8Oyg6QFsm5ZNx4MB1n4qfnWGdsy0Clyyt9lfSVM5B4JqMNpPVB8JIZeYelEMO8xPVdEd/iY7Vh6VSq/FfN0gVB5En880uKuP3kt1lAoUucZRs3SQWZG5ZqjA1CnebegpqNdO5kO2oQo5Cc4qkuYOsBVNqutIf/UQGqkPWw22fixMmIntZscGi8Bbe/EIS7rg6dUgThKoUMindfdPfgPiSA0I34DuFQoeP9wKt0rhbZA8OT7KfBvO51snQbbljRjFH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 17 Dec 2025 15:52:18 -0800 SeongJae Park <sj@kernel.org> wrote:

> On Wed, 17 Dec 2025 17:48:51 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Tue, 16 Dec 2025 00:01:25 -0800
> > SeongJae Park <sj@kernel.org> wrote:
> > 
> > > +	TP_printk("ctx_idx=%u scheme_idx=%u nr_tried=%lu sz_tried=%lu "
> > > +			"nr_applied=%lu sz_tried=%lu sz_ops_filter_passed=%lu "
> > > +			"qt_exceeds=%lu nr_snapshots=%lu",
> > 
> > Nit, but it's been stated that strings should not be broken up because of
> > the column limit.

screw the rules

> --- a/include/trace/events/damon.h
> +++ b/include/trace/events/damon.h
> @@ -40,9 +40,7 @@ TRACE_EVENT(damos_stat_after_apply_interval,
>  		__entry->nr_snapshots = stat->nr_snapshots;
>  	),
>  
> -	TP_printk("ctx_idx=%u scheme_idx=%u nr_tried=%lu sz_tried=%lu "
> -			"nr_applied=%lu sz_tried=%lu sz_ops_filter_passed=%lu "
> -			"qt_exceeds=%lu nr_snapshots=%lu",
> +	TP_printk("ctx_idx=%u scheme_idx=%u nr_tried=%lu sz_tried=%lu nr_applied=%lu sz_tried=%lu sz_ops_filter_passed=%lu qt_exceeds=%lu nr_snapshots=%lu",
>  			__entry->context_idx, __entry->scheme_idx,
>  			__entry->nr_tried, __entry->sz_tried,
>  			__entry->nr_applied, __entry->sz_applied,

because that's just crazy.  Let's use some judgment here!

