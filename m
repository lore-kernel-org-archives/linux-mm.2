Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 078A5C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 14:08:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6FDE6B0093; Tue, 11 Aug 2026 10:08:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FA876B0095; Tue, 11 Aug 2026 10:08:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EB2F6B0096; Tue, 11 Aug 2026 10:08:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6335A6B0093
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:08:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D6690120441
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:08:24 +0000 (UTC)
X-FDA: 85089168528.11.331EA50
Received: from relay.hostedemail.com (unirelay02 [10.200.18.65])
	by imf04.hostedemail.com (Postfix) with ESMTP id 18BB340016
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:08:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786457303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DrhhLWg9CEZyhOPLrgFK29GxC7I4+sU4gOjgdDlRpWU=;
	b=Ilcv2/VB+U01KG+j7RZy871PffURPhqV8u8xXv44/clbuwkcznToxIgWWHSekYeYi5NFGd
	5yHETEP4Ed+zhhcfqm1nXBHI0+UCbbX0rEaa4J71MRRgYhu4k42egaMoGYHjjCyK8rcbSM
	sfkN6XDgo5OhQuji1j4yMDASyqseGxg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786457303;
	b=MP6eh1AET+9IqoHwHn8unPnXOrLxakAMVUmI18HHzB9tOmCS65jJnp41qWuXoC150KkKx/
	v6c1Q7+wA/2UoM0K8But/GtvX0yuoYHO5fHAtffO5ayrkGoRpc4fA2jegouVHPM+KFuVVn
	PbRp8OYzeW9JZoQPYT9RHTqoMmeFKlo=
Received: from omf08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A81D7120478;
	Tue, 11 Aug 2026 14:08:21 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf08.hostedemail.com (Postfix) with ESMTPA id 5ADB720026;
	Tue, 11 Aug 2026 14:08:19 +0000 (UTC)
Date: Tue, 11 Aug 2026 10:08:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Xiang Gao <gxxa03070307@gmail.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Lorenzo Stoakes <ljs@kernel.org>, gao xu
 <gaoxu2@honor.com>, yinchuang1@xiaomi.com,
 linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Xiang Gao <gaoxiang17@xiaomi.com>
Subject: Re: [RFC] tracing: aggregate ring-buffer usage statistics
Message-ID: <20260811100830.7976bbe8@gandalf.local.home>
In-Reply-To: <20260811114818.1449933-1-gaoxiang17@xiaomi.com>
References: <20260811114818.1449933-1-gaoxiang17@xiaomi.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19zyPRC4beHFmE52u3seDFJGcDmTtLkMT8=
X-HE-Meta: U2FsdGVkX1+qeOzVfeecE03pKVIZMZL/LY3tB5U71jzeeyt6L3MZ1zr6w/hrbWhiABmgTwFrlALMrYYr/G3aZrM/G5u03tBo8oV8UdJsNXKu5MbZYPTFm4lewncdptWOdMcCvmPCT3C4NukIe2aLr6DFeNWoXPGeuqtoumc4xw5rVLe/EURLRuUdb7OEjcQZCKkoPSZ8dJ3e+DSdKqJp2x8sSjXTeqsx2C4IUgvf5buHEQyO6ZISV1yIaBHxO35Gvii5Rf9wQWCh5Qw9+AwzHZx0wd6e7rIjCwnc/2e+2dJfPTGtoZzUXFmDQn1zYlcBUkiDIcOXkKKobzUhRU4aJvi6jRqM7p24
X-HE-Tag-Orig: 1786457299-268855
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 18BB340016
X-Stat-Signature: 1uwzqw5mnwmh3u8qo41mkaefgh791rd1
X-Rspam-User: 
X-HE-Tag: 1786457302-789796
X-HE-Meta: U2FsdGVkX1/wWmcPE1eUdVVJ7gE0t8RTl4wd4nwhvqFH3f0uduq6GxmZpGEfvk9Ye1NYZG5U3lWqBlzlUTUi+BaYjnRT+ovgm9JkMg6xA+tslaOnvwa2t2a0xiDFh8E/4vuGRPr+LE6IuqpZZGL41+rq3KJcuquYyNHhkumKI6fd7wExC1qwjl7oLDCnIyOn9O345DG2tg/Clv+EL7W+1mPjpy7I3WUpIDUblrFa9A1vMTXGZ/qfhZZxoK8AiYO5KaM1PAxOdL2IKEU7JeFoOEFNKZIvNmnJEtnQCmV4U2ETsDtvaN4rI3P3XwN7Q0T5NcHt3gPN7W2pphLJRXDEUZJsAG/U8l8ydt5NM/13n61WnjJ7oekPEPki86O9eLFDsUcmZ7KwyNiqN4yZxGXlioaNHNDGXSL37+gxPfOhqhQ4kv6GTaL6fBOqcHqprsqU/78b/pW0D0QLHtt4KwJc4p/oWjqoKeWbjwLIC9gHa5JL+Dxyx5mEQoE636SNFTVlooh0c0jD7UwkFzOtcUMwryqu8mL1rfzT0R5WrkXVw5DLE9BDgQ/IKpfjF4v1Cuboi2ExWQTDbJVyGVbwtAQHIpRafqy8nIsVqIe8mXQgKW2SCh8PVBcKsPEp4V2+aCxuncJbm9wcHfJmCMOeRMQD9Uc+U2tO31gO1uri8B+AaFi+CjMxtk6N4Y97yNfbthjr3h6sXo7m8P22IVgkYSpjFQEVH7hxUQXYDWu4vuqxyl3PVHjMRVxqb1YQd6LKEz9nLjnd75a5+/OGvYUl7tX7kMewYgdYH7e6qTUxpoqXcQW5Iz9T0HX42W6K3KsuwtGdhpMBTxyLM6fNmYniP9wN1Di3aedDiu/1H6UPDcV2ncaMxHxjRZ6xDjc3rlcxWbdIMU1sZu8ZB3/rSeR8BNU+CNbD/L8kF6XpTJsmVofyYxi2yZcV0TqJmTc6MYumeuWe8ku8bm2jC0Xy6jT2BmR
 1qg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 11 Aug 2026 19:48:18 +0800
Xiang Gao <gxxa03070307@gmail.com> wrote:

> One possible interface would be under:
> 
>   /sys/kernel/tracing/trace_stats/
> 
> It could provide an aggregate buffer value together with a breakdown
> for main and snapshot buffers. Per-CPU statistics could also be added
> if useful.

As I previous said. I'm OK with adding a file there.

-- Steve

