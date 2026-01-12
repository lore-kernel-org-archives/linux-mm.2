Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27F09CF45B2
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 17:29:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C2696B0095; Mon, 12 Jan 2026 12:29:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 889546B0098; Mon, 12 Jan 2026 12:29:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B5F76B0099; Mon, 12 Jan 2026 12:29:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6C7886B0095
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 12:29:35 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3E6E313BCAE
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:29:35 +0000 (UTC)
X-FDA: 84323998710.18.3282BA8
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf05.hostedemail.com (Postfix) with ESMTP id A0561100004
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:29:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a+Qy5jvU;
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768238973; a=rsa-sha256;
	cv=none;
	b=KM73npokcCxLrVZHVN+KhPwWZN3X/6NSGnFwwpHr9rwvPHiWfJfQ20BUlIiiN2goI90+hf
	jPmsrCrv0tE2xOjWcd3tIncDBo7e0WcfEdnFnHGjEJfFaNKUx938lmzBx/yg0jyMDGgHbN
	UxscTeHVQk7hKKzXyQvImliXHJ7pbdg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a+Qy5jvU;
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768238973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FY0/w6SRI+2kqetzJX1LT0B9kLK/wcrXIARZ28Atleo=;
	b=1ctwbih7ke822c/Nv/Wp7bXEVZRrV2P4i2N0j63Yi3wY3a5Db8igJGDQpxqO2RNGXXSWXL
	vwlvXbhVxLmWdZ0NaTJMebqT8KOheqAHtKtS4ueLhPHX7D/089obNV0C1TVIGImBI7xr2B
	9HB8mYH2aQWHDw3GOdErUDaOPQF31TY=
Date: Mon, 12 Jan 2026 09:29:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768238968;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FY0/w6SRI+2kqetzJX1LT0B9kLK/wcrXIARZ28Atleo=;
	b=a+Qy5jvUIu6rI6L3MSNDfOPnirV01SolmBzJs+91mceIcOXZWZC3DRiGClIVkVEYMi1GdT
	9h9ns5Wa9JtBBD3zxDWc8WULASiK/qQ1nRna0ZKqI8klrqnqPBeTtbrya1DrlR1y7FFUE3
	wB8alzoyh6v0+XmH/0J7ojnf011k2Jg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, 
	Martin Liu <liumartin@google.com>, David Rientjes <rientjes@google.com>, christian.koenig@amd.com, 
	SeongJae Park <sj@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Sweet Tea Dorminy <sweettea-kernel@dorminy.me>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <liam.howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Wei Yang <richard.weiyang@gmail.com>, David Hildenbrand <david@redhat.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, Yu Zhao <yuzhao@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Mateusz Guzik <mjguzik@gmail.com>, 
	Matthew Wilcox <willy@infradead.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: Re: [PATCH v13 2/3] mm: Fix OOM killer inaccuracy on large many-core
 systems
Message-ID: <tzgfnxf3tii4s65inlzghhrzgc5gkp2stugnuzuqnjraqbp57k@khqklb37lci2>
References: <20260111194958.1231477-1-mathieu.desnoyers@efficios.com>
 <20260111194958.1231477-3-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260111194958.1231477-3-mathieu.desnoyers@efficios.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A0561100004
X-Stat-Signature: dkoep49iz7mhwm9etwcko6n9863kzg8c
X-Rspam-User: 
X-HE-Tag: 1768238973-555804
X-HE-Meta: U2FsdGVkX1/AhJg/L8/zIbxR65VIcEuerTqYDDZ21jIRNIYKlqQA1EKDmCiGKgW4NunAV4/5Y3exY/eetB1Sr+V5hk3Z1LUvSD08lcK1O9w+HQpEfFi7tECBGtW+aqYzar3Y9P04XDpJ2xB8euiD9mtJxTtOjfe8FkAY8uWUhJe0TJSToJPRot/r169CyvQdtaB65VmtqTnVYxI8uoJ25wBHQQVEsoaQkoJYRBVDACkmFN3aZCS4dE8ByMe6leO9We5Y0VAiSgeVkpeBr80hzOkqp2BkfEA8dYFjEg4VoGh7eo2xnXMQ3ouyw7UVai0Vp0xaKerN0LY0hP3pPavC7ibcDZTdickfSm95kNkAfdHODJQB0fLvcX1C55VDAmWYvmWDF5dTImky0KJpvyZ5wxRrvdYKOWfvWcwTUhfGR4JLgi3OqiU38n0AwFLvLpyhrakpGZQxXSpouLszDPZ78jIuKLkOnCYKXf3xp75wQ1t5DPHJ14AKgZBRwIECZ0ggngw43fyPzduR00j83ZupfFzQBPpKgVhMHr8mpSxWnUqEGbkjLHh0CoJdp9TJ/EyYAVXh4tpagTN9F0dxcFwM7qaTtdCPWtxXr0FnEbaD2hEBI21YUX+J72cOIjtaHicZXJNAfM8n90MUi9GMFUWnkN6aTp9r2lpdFxhBorMQiLTHHwRrYuOp0Zvhn8ikRAam5uWNyk+RCCyyr4KNLd4JStwFQD0LUXYrY9OaFGvkQH4csmG/l+qBe0gC9h7ew1rMyV5p4c3Dn8ISL1s1zXfD6gjurc2T7BLKXs6VqDyDWUo/Zu2TygMxE4bjPXhidtiIC/Zx/VXj6rOn1pSi1QeP8qPtanKVCveI684NwpZFcdBg5C2MozbmtAoh7H3NRtpe05JeCXxBZ/P7ej2h60jLr5KVtCUDCJJwDO+jCwZIs154fpo/NFK5p4xmvuG5E0Ow
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 11, 2026 at 02:49:57PM -0500, Mathieu Desnoyers wrote:
[...]
> @@ -626,14 +631,12 @@ static void check_mm(struct mm_struct *mm)
>  			 "Please make sure 'struct resident_page_types[]' is updated as well");
>  
>  	for (i = 0; i < NR_MM_COUNTERS; i++) {
> -		long x = percpu_counter_sum(&mm->rss_stat[i]);
> -
> -		if (unlikely(x)) {
> -			pr_alert("BUG: Bad rss-counter state mm:%p type:%s val:%ld Comm:%s Pid:%d\n",
> -				 mm, resident_page_types[i], x,
> +		if (unlikely(percpu_counter_tree_precise_compare_value(&mm->rss_stat[i], 0) != 0))
> +			pr_alert("BUG: Bad rss-counter state mm:%p type:%s val:%d Comm:%s Pid:%d\n",
> +				 mm, resident_page_types[i],
> +				 percpu_counter_tree_precise_sum(&mm->rss_stat[i]),

I haven't gone through the whole series yet but this "val:%ld" to
"val:%d" conversion seems like unintended. Next patch fixed it but it
should be fixed here.


