Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5AD5606A31F
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 14:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=goodmis.org header.i=@goodmis.org header.a=rsa-sha256 header.s=dkim1 header.b=K3I3DdeR
Received: by kanga.kvack.org (Postfix)
	id DD55E6B05BB; Thu, 29 Oct 2026 10:36:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAD346B05BD; Thu, 29 Oct 2026 10:36:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC37E6B05BF; Thu, 29 Oct 2026 10:36:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AAB706B05BB
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:36:23 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E15EFA041B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:36:22 +0000 (UTC)
X-FDA: 85375914204.22.29F6E13
Received: from relay.hostedemail.com (unirelay03 [10.200.18.66])
	by imf23.hostedemail.com (Postfix) with ESMTP id 17F8F14000A
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:36:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793284581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DLWowW4hGT/hXcWpOks8o4FAs7pYlKMrY5y/WjiATro=;
	b=AsOqXxIifZrzd6nx/0W6A+3wk1Ev4Nmuv3clB39/AkeOapsYSXOb58QMGTiAnXJjQ2iKoU
	ZCXnI8SuzWp/4d1gThN/WF3Wyh4oBt+tQ46pMSqUXawNHL76A9you70WsgXDdvlk+ZZMYh
	0AkYbiJgphIyJCUDzo1EZCWCXxF/DQ0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793284581;
	b=tHWwbRphp9XSKQSQr5wQ9A0IJibw/QzbdT3hBkxm8s1IF3r4Ir//UTBw1IxMsWRLcXzPhv
	ZWNdsu47e0Zu/cswtcm3W3hej7SDM9zauNfV0l/q5ijIPSqbjZ3+CIoWfTdu5B3/sKmJn6
	0J9PBvdkXNaTmcRHPE4sUFIvJx0lJIY=
Received: from omf14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 911A3A0461;
	Thu, 29 Oct 2026 14:36:19 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf14.hostedemail.com (Postfix) with ESMTPA id 937A334;
	Thu, 29 Oct 2026 14:36:16 +0000 (UTC)
Date: Thu, 29 Oct 2026 10:36:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Xuewen Wang <wangxuewen@kylinos.cn>
Cc: hughd@google.com, baolin.wang@linux.alibaba.com, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, corbet@lwn.net, skhan@linuxfoundation.org,
 rdunlap@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/shmem: trace swapin results and order fallbacks
Message-ID: <20261029103615.31dff835@gandalf.local.home>
In-Reply-To: <20261027094014.2432692-2-wangxuewen@kylinos.cn>
References: <20261027094014.2432692-1-wangxuewen@kylinos.cn>
	<20261027094014.2432692-2-wangxuewen@kylinos.cn>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18EBqo80D1z2/O46sIMk6OrtHEvAtYnb1w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=DLWowW4hGT/hXcWpOks8o4FAs7pYlKMrY5y/WjiATro=; b=K3I3DdeRwaQjfEqIygbbx5JB4QSDy4p7NZNvhe3ryA2vsvHuFWEv7JWiDsQDy1C4h1r4kxbDy2y8qmK+XNqtWrz7nu6zKQwUJXkVxavInVqEfxiqpwckrmGBPwNg/NXmYHlw1fU90vYuKhofvKQhukH8CXXt4DJbRUbF35JAwTU=
X-HE-Meta: U2FsdGVkX18FG5ELwnhgwqGWp4TOyMCKVvMh0nOLljHoZAWZvqkPobeGn9hkoRe9fXEnuQkTnHMUSSorjKbZfk0N7mA0ZHurJm9PkjGeRRzdM8Pp/iIhUXytEPGehituShw6jsmteiCDkiylzLv7C+FvfDRK6+PM7RUjagJthakBBPXWqo7eyTPc0KwZSy9HT/KaPft+N9rXokXpm+OC+Czy8HewPnxhqHx1C3IwlrK/zxidVIMhR6jL0eu/Ck2EUyyHyLwUZD8V86VZw815lUu+7mDmNzxu+riUBaUtuw2AI5Kv4mh7S5KHCFm8b8K0
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 17F8F14000A
X-HE-Tag-Orig: 1793284576-636695
X-Stat-Signature: jbyz4xfxhejg13gck3udfxaue4a38r7w
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793284580-137388
X-HE-Meta: U2FsdGVkX1/CSa+e1HIpdyhhZhcrjhSTd+h/rBPEWlAInoCBwrXpUzmayoTJA8y3dmxPl9lDFCkUJYUurnnAmNIQUbp2WbeYYofVrktlEGcsXoL4zhkTwfKOOjDec61tugtDWb7BpcH2w+gKncV9I2T3TO13rR0u5Pvbr8Isjua2OUoKzby+9ctOBam9bTAzBEcLGNtCZQwmZGu9pmBui+xhFnTI8Q/EFeT+N6aXbKluN6PrrhVA440XOBxD3fbWnat+/rYT675qTH44cOnd3QErQ91Eihm8CBKNE6bEazhe+Ei5soqYcPWxb6EJVIz0sGDREkF41CAr6sfD365CV9IdQ6xxJqKQ+B+/g9C2VtK9Y7dJUWysLWFZ03HU1AFMvyeGHfUEkQXS3sAmQoGdKjmMe2sn3riXruP1PrJepCJna2kx9AAhnRobkrQBkGg9qHUVP5ohxsbxH7NoG2x0Z84b85R/RVmViGbckiXiuIDv9Zs13Bl8xFqzlc8+kVoBqIb6oOOKzsevh1rcKo4uICRfBzrzI4lhmTnZb+v4XlN7xAAJeRmLcnbKl0lSBHk8qgBIJjSxSgS2Su/nToMzel13/bVQA/SRuF2GXCmk8mny6pv0+083z92NkGpO7IEjxM9Ls9Xe6MIoqqtdjQLAVg2FqNTybh4LwVB6Aqd6IfQqeOSVdB1q7d3+wCyuQrtMRZCpYdXIP42tA2M3lS1B07WGTsIjQv0fR8Td/WRT5NT8T7SOxXhhkXS5bcQY5MntW+h2QNWSBzx1CFP+vynIGFj/vlx5V28UF5K4bOGQfANloM38p38104CIKt5I/WCrA8RBElHTxHsu9PmNvkvIGkrbj6kh9lFQd+fPizCys7mZVkY14gabouuSlfOsULQRtLi8DdKXHKctIi3AZxynTyBJ2nDosO40Hja7KWrYZQ2SoTj/B4hEZfpm6NSZXmDkJKi+g1aSbU1gPmZZ07+
 3JOHah3W
 iLL4URZ6rZo3NgsSzC7LHQyXQpXo5i9+hydaXLaRldmmgiV1XDkXDCm71OQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 27 Oct 2026 17:40:13 +0800
Xuewen Wang <wangxuewen@kylinos.cn> wrote:

> +TRACE_EVENT(shmem_swapin_folio,
> +
> +	TP_PROTO(struct inode *inode, pgoff_t index,
> +		 unsigned int entry_type, pgoff_t entry_offset,
> +		 int requested_order, int actual_order, unsigned int path,
> +		 unsigned int fallback, int fallback_error, int error),
> +
> +	TP_ARGS(inode, index, entry_type, entry_offset, requested_order,
> +		actual_order, path, fallback, fallback_error, error),
> +
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(unsigned long, ino)
> +		__field(unsigned long, index)
> +		__field(unsigned int, entry_type)
> +		__field(unsigned long, entry_offset)
> +		__field(int, requested_order)
> +		__field(int, actual_order)
> +		__field(unsigned int, path)
> +		__field(unsigned int, fallback)
> +		__field(int, fallback_error)
> +		__field(int, error)

There's a lot of holes in the above structure.

dev_t is 4 bytes in size, which means you have a 4 byte hole between that
and the ino (on 64 bit machines).

And another 4 byte hole between entry_type and entry_offset.

Move the longs to the beginning and the ints after that. The order of the
structure isn't important for the output, but is important for saving ring
buffer space.

-- Steve

> +	),
> +
> +	TP_fast_assign(
> +		__entry->dev = inode->i_sb->s_dev;
> +		__entry->ino = inode->i_ino;
> +		__entry->index = index;
> +		__entry->entry_type = entry_type;
> +		__entry->entry_offset = entry_offset;
> +		__entry->requested_order = requested_order;
> +		__entry->actual_order = actual_order;
> +		__entry->path = path;
> +		__entry->fallback = fallback;
> +		__entry->fallback_error = fallback_error;
> +		__entry->error = error;
> +	),
> +
> +	TP_printk("dev=%d:%d ino=%lu index=%lu entry=%u:%lu requested_order=%d actual_order=%d path=%s fallback=%s fallback_error=%d error=%d",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __entry->ino, __entry->index,
> +		  __entry->entry_type, __entry->entry_offset,
> +		  __entry->requested_order, __entry->actual_order,
> +		  __print_symbolic(__entry->path,
> +				   { SHMEM_SWAPIN_LOOKUP, "lookup" },
> +				   { SHMEM_SWAPIN_CACHE, "cache" },
> +				   { SHMEM_SWAPIN_SYNC, "sync" },
> +				   { SHMEM_SWAPIN_READAHEAD, "readahead" },
> +				   { SHMEM_SWAPIN_POISON, "poison" }),
> +		  show_shmem_swapin_fallback(__entry->fallback),
> +		  __entry->fallback_error, __entry->error)
> +);
> +
> +#endif /* _TRACE_SHMEM_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>

