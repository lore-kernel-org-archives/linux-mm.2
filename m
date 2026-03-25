Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F3D91093168
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:19:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2FB06B0093; Wed, 25 Mar 2026 10:19:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE1016B009E; Wed, 25 Mar 2026 10:19:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F6E66B00A0; Wed, 25 Mar 2026 10:19:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9185D6B0093
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:19:18 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 33E37E0280
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:19:18 +0000 (UTC)
X-FDA: 84584792796.24.0FA90D8
Received: from relay.hostedemail.com (unirelay03 [10.200.18.66])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6169614000A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:19:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774448356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9JKMwSLfumsF4b7cd02f8z7LSLOVI8Oat/c80ePsBOI=;
	b=T5B0mfYPpFA76wIfhj+ADwsVEF4earsKPg/y6wOwwMhaNELTqBB9bY6z7VfJgYBfY9z9Mp
	VgezhPsGc67WwUXt7/Kwrrpc7pN1p5pXS7fzHCwwb9HBW9jwiUzPw1YvScYVrp+QbdMXqb
	bWVQK93v72CnAQ+j2DlrZihlKWLKzfE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774448356; a=rsa-sha256;
	cv=none;
	b=0w1K0+hoT3aeBTXs3OYvuGKulFvVLBlt+D9gAhkFuS0rjDMMa7ETT1UcuUPXUmxrj/aJw+
	i5HmP9Vz19YgxX5dqfMvbPKAz1EKWXDCyX8E1jQYWnQxKCOgOtbIWBDW0zXcfCYH4BBcIs
	l5JwqeWjcrXRRS6DhbnLfkx7fH9yhsw=
Received: from omf07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 27EDABBCAB;
	Wed, 25 Mar 2026 14:19:13 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf07.hostedemail.com (Postfix) with ESMTPA id AC7222002C;
	Wed, 25 Mar 2026 14:19:07 +0000 (UTC)
Date: Wed, 25 Mar 2026 10:19:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox
 <willy@infradead.org>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>,
 Len Brown <lenb@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Oscar
 Salvador <osalvador@suse.de>, Qi Zheng <zhengqi.arch@bytedance.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 linux-pm@vger.kernel.org
Subject: Re: [PATCH v4 0/5] mm: zone lock tracepoint instrumentation
Message-ID: <20260325101946.41c613ab@gandalf.local.home>
In-Reply-To: <acPRq1YPeGR8EqMB@shell.ilvokhin.com>
References: <cover.1772206930.git.d@ilvokhin.com>
	<aa7G1nD7Rd9F4eBH@casper.infradead.org>
	<aa7XdpIVtLFS3FIu@shell.ilvokhin.com>
	<aa7dgQDMEz34eadj@casper.infradead.org>
	<20260309151317.7bba06dd@gandalf.local.home>
	<aa8xawMxLeUjkyHx@casper.infradead.org>
	<20260309171700.063318b5@gandalf.local.home>
	<abhAoF5EpiPigsx7@shell.ilvokhin.com>
	<abv4riGLlubast8v@shell.ilvokhin.com>
	<20260324163918.1a3c5c960d85a4243c9ae314@linux-foundation.org>
	<acPRq1YPeGR8EqMB@shell.ilvokhin.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/EMkt4khKrTUfV151jFVgSJ/6WQG5xPGI=
X-HE-Meta: U2FsdGVkX18CJYrOTc7hVR96FhN5yCibV3LQj4C7QJWHQd5CtYPpmFI5Ak5tJTbML02SPWJJs1n1pcrr5b+mM2O/2nhj0D1ILm08d78uSc4jhaXkh0u/jOFtbXpv5AQIp9xh12/yPSQdsTUpCjwCSvCF+PTrOg/MhY1uejk0xP3xxfiHPmkMH5dcttFZpoXUYEyQZsCd8fbix5P+GQwn6p1kpygA+K0H+WufhLP9mP/6JmyLh/zYaVXSBQZUWecJCX4l3TSg6BaEGAztVQB5Fv2ERbA3GLl88MUAKldXSJLQ272axuD9DrgZjtjipA7SdjKT4ErE0byYNs1x7SKz2ePVbrZg8IWANBEzEzAvpoBoJ2BRSn1lGDkwBPiLB2h/
X-Rspam-User: 
X-Rspamd-Queue-Id: 6169614000A
X-Stat-Signature: 5pc3ns6srogdgk3or4s6ppnqsb11ntij
X-Rspamd-Server: rspam06
X-HE-Tag-Orig: 1774448347-522659
X-HE-Tag: 1774448356-956521
X-HE-Meta: U2FsdGVkX19FppDmvCmS7Va5x9sx/BjcS7NL6K0eu4s5MOEYUVC4fwK81G6Qgk5+8PBMbZd67TaCd+yIpPhn4YGdex8DVJPVekIj6+9/vq0tJALSEK4KFts8Zvh+TS31tfiEVQauni/4AuUtsv1/91Q/FMsrAm6uE3ZUoF9UxYFdzd610m5dUYEDBXctv+jq9BZC0Tip0YOb8ZVTv9lMxXjA7Pkp1GY+FjPG699/V0RqzuqVsgPzcEjJAWIkzNzhacEXURZYXs/7lFtd77VlZIejgi3MmcmaFqUUoErBpj+SH1gkYm/wnzFiEt0mR9QvcL+8puvXO22ZmZhdxdpxZycFygKWSvaxBKuH3zC1QFEOjrdOBSeOVrhMgd+a4EvLyOpg4guADNPbmjza9U98ILt5AzpEj7zQKLA1m+82vrq/8tRJiDf9D7j4foII8xzXXQAyvh0/L8h7GjYlOrqkrReh5bWl95TTdKrCdeWlorT/LFod6SVVcH436cvq+d0oTcITWzCvo9okb/DBkVXoxfpip8czslhe21A8+LbgcF2vQ83KtTU7pOqckP6/stm9RtLcK3viArOQy7EunvvVfW3c8svhLVpxK9dbQ3nRbEOeNLZtz3qr7ImxDLLuZ9YjhyqqNJAaDS9ZLIMslfA8kzi0TltLeG4MscepO2s7YmPiBxMbFnMjh1PhhFfa3Lm6ClY/ZTA4XBJgj1NQia33Gapl8XNacQtHTUmqXZ4Q4s7gFDVFGwnKOFm5XVLlQYxE9hqPTp+1VZtmgDW/eeZsT78jH9bHWDhsu2ZqWp6fFcYiOqx3+W7KbzoO7ARc9i8cxFCiLLewpQqhD+Whvlqn0Tz/OJB6GYX1XnYyI+XnA5+q6r2UZi+rT4FDmaeoTaHCQTT+J5WBrd7LymgBQE8Ho2dD+fLYeskRCK725cDFeXuDxtN4tnaoWxpMOPIRpWQY/hTzAL0piM2wYSdNJ88
 iZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Mar 2026 12:14:35 +0000
Dmitry Ilvokhin <d@ilvokhin.com> wrote:

> > Please send that v2 sometime and hopefully Steven can help push it along?  
> 
> I'll send the next version of the generic locking series soon. Any help
> in pushing it along would be appreciated.

I'll see what I can do when I see v2!

-- Steve

