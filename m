Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B5B3EFCE4D
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 22:55:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92A726B0005; Wed,  4 Mar 2026 17:55:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90BA26B0088; Wed,  4 Mar 2026 17:55:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8430A6B0089; Wed,  4 Mar 2026 17:55:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 70F396B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 17:55:58 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0FFE21A06B4
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 22:55:58 +0000 (UTC)
X-FDA: 84509889996.26.4CD513A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 59FB71C000A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 22:55:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WWhjr6g0;
	spf=pass (imf20.hostedemail.com: domain of mhiramat@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772664956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TISI90182QlKTb91GK/S5C9xZaCSe3G5cnFe8+3ZK+U=;
	b=jaG2EscHbHiIOUXNk4NK/tbNiG9jelRIK7H0n41XB+iBoxHvsBpEIit1NlBSWYyUM9zOY8
	49olZHLdpx+ubKzmWUsSsN34KIdlr/g/Qhyw//pqpoaGrlX2r/5oAGxzhzZ5NsEsEAMV8G
	3kq2R0j7OtK4lz4a6uW7O+oVb6CR78I=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WWhjr6g0;
	spf=pass (imf20.hostedemail.com: domain of mhiramat@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772664956; a=rsa-sha256;
	cv=none;
	b=xzLnlv6XX+BYF/e8ihILt+E8y7Vty4C2+jV3YluGYYSY/3x9QU8jUk4uPNl7VCmCUJPrZi
	lLdRp7ghFeuQAALzBLCgd9itmI3o4rlc7cKI1X8f4h4w1nwDvgAQ0DqT+t8DT1gXbuLGjF
	ZZjh1zO/jYoFvf2fWWrf6E2gb1F2IwI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C98486014B;
	Wed,  4 Mar 2026 22:55:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96504C4CEF7;
	Wed,  4 Mar 2026 22:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772664955;
	bh=Th0k5BwLXjcKqKxNPyWtlPrNyyCtPIZvtetPczGQdsQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WWhjr6g0YC/LGPHBiN1pOKYTPC9D7XGrawhQ9VLi6aULm0neouoE2TgJ2spzkdHk5
	 DdX/AlePnhz7ZyyXe3lq3uO+KAyX4vJv5uF3SVt6AowTxQBphvW2PsWjh+GAJ8bR1o
	 bGnHKj/e1Dqj1+DLjbnMlJK4n4UefH5hrkG8fIFFctIXAkmU6EBSZV9BXd85uHX3sm
	 U4Qsoxlfpmbl13fvlzO6KECwLGyZZbFyX4W4MOSoJEs5HCN4AUgJ+A3Vo81unCgIAt
	 IFSk8a+CiWezGNMSHNTtRuqHQ741kixcB5IFYeigIrYXVJwcYLjzILj/mIRs0MnFWJ
	 98Lj/W3RqnJbw==
Date: Thu, 5 Mar 2026 07:55:52 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph
 Lameter <cl@gentwo.org>, Steven Rostedt <rostedt@goodmis.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Peter Zijlstra
 <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Will Deacon
 <will@kernel.org>, Boqun Feng <boqun@kernel.org>, Waiman Long
 <longman@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH RFC 1/3] locking: Add contended_release tracepoint
Message-Id: <20260305075552.0840e6b107dd9560e09e4f86@kernel.org>
In-Reply-To: <f8605471fd84ebff963c011aa98f79ed17f493c7.1772642407.git.d@ilvokhin.com>
References: <cover.1772642407.git.d@ilvokhin.com>
	<f8605471fd84ebff963c011aa98f79ed17f493c7.1772642407.git.d@ilvokhin.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 59FB71C000A
X-Stat-Signature: ix6f7q5woziq1ayatofjg5r1gibyfdhr
X-Rspam-User: 
X-HE-Tag: 1772664956-362693
X-HE-Meta: U2FsdGVkX19OASceVUllrSFqZQab/8XTd1LMbn6uzTjFplwwSYruIjk9Jg+h5QB7Hg79hsMn5JjBM41RlovW6wHYLUO0KAY97AQfymKy9es7PDuE/frDnpwpMybX+QvlDLhPVD6NZAmdGthEOH/qdlcsviRjjQpYKZJ6s5KXHjpaaSApcMKozQlYpc2iB+nBmsL9RniUOxdr5iEaDe09XlxkClbYcRGKshOHFCwqUDeTHwBk4delnEoRlBkjs/h96ifOd36PaUk85j9O66bqVVMzoUsOMr6iTvQPUqjECJJn9wsncOulvKpfGTqsUM20yNACrVMpjOfCzGWW8zrnnwtnWuglVrTSBmUmSZq7cPLyLCDpwRUVZgrZLUTOUCpnudN5hgMxVtaMg8zYBSGD2tZJKShP0J3eypdkaCYPXieVjpFwZ7H3CFwnhVL0oA9H8hQ652OPel1/njite2NblaaimBmi47C88ya0so7+fFehyAMQCYa7q9xX8vVpo9B08C7CAUgtLIPnZk4O6VnaldwgMOAqy/u8+39XxdBbtI2++9bDT/J508kQ1tpPUVadnLYRRfJ/yfi0+BCIi5852Q17H2FsM38QcVucMACPvXd+8ajlm3Ug4TyVQ2wwI4YGMo0P4ttQm+xkeTuf8Gn3spPckaBx7Rg7mHuKkdCmgE3p1p46a0j+uZKrX/5rlnsya9fKEUb5gzVEggcjZ1tJmrbmDPO2CEaunKKMJUvwkf30/TiTAnmnC1WmUxAMAmUw4bcfQrWpc091a0YDUcauc4JzMd7YbW706JP4ODBoNLg6/FO4A5tZTqIRxO/7ZnM2ALoqK+AtxKIF6zWO1jSuec43DoolrT8W8U/UGin+xYpThXuSeSyzepX/BJA5c6ia+iH4G9IQoSrpfQoFUqGkQjril7ur0d/8iTKuGpLIcDp/UiruFuZS64Invkou676ZKRrmfOG0S3HY2vxZIto
 LVnNvcEb
 DeWXMP6ZlS6hkyxAZdf5xwFSx17ubdUzEkaJUYppX8Zv+6l75Q4ZeDKLUGW5BI2P84c6N1KtngzBOI/vGHgmWfDY27yqB2kkoe0ecFjFdV7m4J87Oe1SEmgzV9fntixH4Wje1RTR3VHkoQknvdWU+Wm/s++OfK5HV2gMv8bCU5QqKrj7VjoSXMr14Xii1jdIWQ3SSNRA9lmjydKL7ywQNT9J2CeAlyGDyaYW+MLV3z7XnUlvIV+fMK/dkqZ+gBkrHuBc2Y65ckv4ngsWJA+c+5yqxlukkbObm9ThaWIOOIVf1uMyZf6v6liQiFjfwejyYF7zggiqnU5Do1pPXzC8a/xWodEOpeD6l1REk3jIFAZBjWRL7qIqfvxsfww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  4 Mar 2026 16:56:15 +0000
Dmitry Ilvokhin <d@ilvokhin.com> wrote:

> Add the contended_release trace event. This tracepoint fires on the
> holder side when a contended lock is released, complementing the
> existing contention_begin/contention_end tracepoints which fire on the
> waiter side.
> 
> This enables correlating lock hold time under contention with waiter
> events by lock address. Subsequent patches wire this tracepoint into
> the individual lock implementations.
> 

OK, but I don't recommend you to split the traceevent definition
and its usage. Could you combine [1/3] and [3/3], so that we can
understand why this event is introduced and where it is recorded
by checking one commit?

Thank you,

> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> ---
>  include/trace/events/lock.h | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/include/trace/events/lock.h b/include/trace/events/lock.h
> index 8e89baa3775f..4f28e41977ec 100644
> --- a/include/trace/events/lock.h
> +++ b/include/trace/events/lock.h
> @@ -138,6 +138,23 @@ TRACE_EVENT(contention_end,
>  	TP_printk("%p (ret=%d)", __entry->lock_addr, __entry->ret)
>  );
>  
> +TRACE_EVENT(contended_release,
> +
> +	TP_PROTO(void *lock),
> +
> +	TP_ARGS(lock),
> +
> +	TP_STRUCT__entry(
> +		__field(void *, lock_addr)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->lock_addr = lock;
> +	),
> +
> +	TP_printk("%p", __entry->lock_addr)
> +);
> +
>  #endif /* _TRACE_LOCK_H */
>  
>  /* This part must be outside protection */
> -- 
> 2.47.3
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

