Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C7ECEFCE4B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 22:02:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1CC96B0005; Wed,  4 Mar 2026 17:02:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCACA6B0088; Wed,  4 Mar 2026 17:02:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD6796B0089; Wed,  4 Mar 2026 17:02:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9B7C66B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 17:02:35 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 22F8D8C1FE
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 22:02:35 +0000 (UTC)
X-FDA: 84509755470.01.84D8EFD
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id 729F640016
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 22:02:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=UCFQqR2b;
	spf=none (imf11.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772661753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ubkGAWt2PwudxcJDXQT+2LLWc96LXI7vXpBVWksTJYo=;
	b=E8LREj/b7Pb0Oysx7m0uh18bx0bcgLwWTa5O7y9RHg8c9CPUBGjN998NK0xRKzGOMaglQj
	I9Xgeih4bVLibVYl/VmPMaGVD4WfQOdAQSV+8VTifs5I7fmde1kj1Qhs03Y981O3CMNRID
	DCpct1FDpul9yziJiJvSgNJr8fatXHo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772661753; a=rsa-sha256;
	cv=none;
	b=uQI3qAJ7KMjLGSTPfd9pyylneDKHIxNRdKphphO5Vw+2tKP41Pvksih/q0OP7RRSBBDNTS
	b4JLjj3XEE8t/PgYl2daNWoovEq7tPHKGey66KrpVGbAqse8entlYgO66xUWCszgnWwI1E
	yJ/3MZHYO7e1OgVZiIgH7BegrtcvkbM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=UCFQqR2b;
	spf=none (imf11.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ubkGAWt2PwudxcJDXQT+2LLWc96LXI7vXpBVWksTJYo=; b=UCFQqR2bTe9XmtGEiZYtTn0v4w
	f4LdyQl21LILBx9U+HMBFaOSkBlkopYOfYo7MCOvv7L8ify84nmdvZZWMlXQMvDkuQlL+TKdDU+2I
	r7VX7aEO7OaXoJPsicSCCyo6py+RpZxEffMVB5aofq8cytNJi0rmeWWU86F33ffrdpeF/vrhSm+rB
	og4CSK4DvYq9cZenK7rLBkJgoLEZvcdmIn3Gc7JhngdDQsRYNSDj32pat4BkhJMlsFmQEkn5nZrHN
	L/lZq98uVYGkAFaSMR2/yELZ2iGMYYmJzHsbNLvYLLF2kafJqC0JvPQwCkHoupBpQhj0+jeSTXusR
	iC9ZyQrQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxuIS-0000000Dxjp-3DuG;
	Wed, 04 Mar 2026 22:02:26 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 9FA22300B40; Wed, 04 Mar 2026 23:02:23 +0100 (CET)
Date: Wed, 4 Mar 2026 23:02:23 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH RFC 2/3] locking/percpu-rwsem: Extract
 __percpu_up_read_slowpath()
Message-ID: <20260304220223.GS606826@noisy.programming.kicks-ass.net>
References: <cover.1772642407.git.d@ilvokhin.com>
 <6b1f1521ca186d5c402a65619d8f30fe83b93bf6.1772642407.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b1f1521ca186d5c402a65619d8f30fe83b93bf6.1772642407.git.d@ilvokhin.com>
X-Rspam-User: 
X-Stat-Signature: puikmpftbtshc17j57o7jkc5d5kjppgx
X-Rspamd-Queue-Id: 729F640016
X-Rspamd-Server: rspam03
X-HE-Tag: 1772661752-306752
X-HE-Meta: U2FsdGVkX1+Nu80SyYJSBJI3eLHuOBDWkVytS2GNjHEFc+V0oJtDjVvEamK29TjW7rGCYYWw5sxnwyr3+iV7pIDBdtqcuceATrEuH3xxml4MHy33/hpl3E5YDLRYGc8deYzimCtdZYPWgbjNYEh/1MID1tC/UgPwtPtL1pPSeg1P9p5ruuePtOoWz74d31Gv76/9PApmjG2JT9IVYXAapKW//3SBAtzCx/k7lSl1C2fVzMOTny+gjgNPBFTFAjgNbJ8ImpBh6oOTaWKQBwCal2v4K3Z1SoCDGi0pljhPrwnTVG6nLPDkUAPRgmqZT4+lJo3mX7dXe408lMeG2peZXAw1ov/Q0GyRN9/V0pQuWyhvn3qlkEaifNQP7ywgMomNAhkOaWpzQ0j5ve49dmHs2PMRmqRNF6OB6SJUk+e+ByFyo0AdoIBXxlb0lM4qiXpGyio82OGQe+hp31fChZ4UNf8SJw4uFOzKlQ1SSDK+Ui8ZbwMh92AeJdw570rdwic1VKG+y7lZyos/l6WDyl+rwy7M8IGJC0Hqg22egP75qL+YMsDw7/UTPRYKXmbBmHqwiLdBCBk9ymeZKbySn1zx0nLpeP4CzjIKPTG2VKSTNxri6aLrQDaZRGamvWGE6VJfshqxmsE7snohEFaXXQE2WVAnRv0po4KuVQT5nRdwNoPTeS9D4cOR1hsmDPjmG5vE3oaB76EzSAb5JLqDoFSBzgNhx2HeeSOzMKuR7jBS39RuoEx4GnMaeU+zhwXDCoqX615BnGXoEYX3RTbPJnGt7OQbAVewBgTI7SJTVjK6ao/jeM1IviFqI19G/IZxAck7fblvmzILIEPR/ymBS83CO5Vrvl6EDXcxQB0+Xz4MACRhbr/T0tvFU5LrHYzjNLEi4hy5pq8jmxvvddqIIgUe895G0qUD1CTVBU3CTGDqK3kOMiU7xTreBVaY05ackBYT2OzQR09wYM8LJCmJ0+/
 6or2H9rt
 KjdSnSBI7s18f5PlUh5LZs8Ds6oNLrsVaCRP8hBPrGHrjY3+7QkhS86LKhMt38Y5+mFW8Q/2UXmzOf2fjcWZy3tCchhgGzHG8HaV7QbirDn5VhQnhfNvFqQNB5MSz+Ls7gbLBIA48fyog49bRio3jNyfl9zsyXFSSHMV/6rGodJ7DPLlZDLmeM7PWG1RVlGreAuYwhoUiBNNvr7yCmvwUpsFi78/as2MOgLm5jSg+0OyM+zdEUpqs9HwcHyKfG+/b2bO/Sfa74Fkq4psU7DBNPWWSTanTXOjqRdyP2uuKk8lXqhO1vzm5pq29ecSrXgopstdk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 04, 2026 at 04:56:16PM +0000, Dmitry Ilvokhin wrote:
> Move the percpu_up_read() slowpath out of the inline function into a new
> __percpu_up_read_slowpath() to avoid binary size increase from adding a
> tracepoint to an inlined function.
>
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> ---
>  include/linux/percpu-rwsem.h  | 15 +++------------
>  kernel/locking/percpu-rwsem.c | 18 ++++++++++++++++++
>  2 files changed, 21 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/percpu-rwsem.h b/include/linux/percpu-rwsem.h
> index c8cb010d655e..89506895365c 100644
> --- a/include/linux/percpu-rwsem.h
> +++ b/include/linux/percpu-rwsem.h
> @@ -107,6 +107,8 @@ static inline bool percpu_down_read_trylock(struct percpu_rw_semaphore *sem)
>  	return ret;
>  }
>  
> +void __percpu_up_read_slowpath(struct percpu_rw_semaphore *sem);
> +

extern for consistency with all the other declarations in this header.

s/_slowpath//, the corresponding down function also doesn't have
_slowpath on.

>  static inline void percpu_up_read(struct percpu_rw_semaphore *sem)
>  {
>  	rwsem_release(&sem->dep_map, _RET_IP_);

