Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9CA1FCB61C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 16:16:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BA3B6B00B0; Fri,  6 Mar 2026 11:16:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17B1E6B00B4; Fri,  6 Mar 2026 11:16:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A8286B00B5; Fri,  6 Mar 2026 11:16:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EC9A96B00B0
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:16:00 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9A6D2BA5AD
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:16:00 +0000 (UTC)
X-FDA: 84516139680.16.B8334EB
Received: from relay.hostedemail.com (unirelay05 [10.200.18.68])
	by imf08.hostedemail.com (Postfix) with ESMTP id C1F7116001B
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:15:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772813758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k69NxbDwsRBqco/VQrD3RyU+oVBY3RE5rtQ7uWqfBHM=;
	b=lAN705eTD3CO2bP4sTzqLRvIxHcPxwgDCifM6aAFx7rOJVXsn/XeHdDRfU60WYnAoxsfn/
	qYOX9/NO0li2og4cu5thuunE42kUlTPHsUBbBz8qFmjcY++jRXrwKpAWXtvonXuOiCd30Q
	3UimhloekH6qf9gm2LVcRPJVXX1osVw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772813758; a=rsa-sha256;
	cv=none;
	b=jvvebCG4AMSvZ7HctkJ30rHizwvjg8g1Sj5INN0et0ZbcHUXLZZcuCLCZnfM5bIV/ZBjMo
	tPbtpWZqBoTzH5lKsfCxapJy4ufWpw71T1d4uQDKSUgSyi4ZtQG0Nyw2uqW0E1Thjql74I
	R9APWr1DlQ5p4VuVor4sISlIOPZhrNs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	none
Received: from omf02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 026E559A1B;
	Fri,  6 Mar 2026 16:15:56 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf02.hostedemail.com (Postfix) with ESMTPA id EF40C80011;
	Fri,  6 Mar 2026 16:15:53 +0000 (UTC)
Date: Fri, 6 Mar 2026 11:15:54 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, Johannes
 Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 0/8] mm: introduce zone lock guards
Message-ID: <20260306111554.2bb29b05@gandalf.local.home>
In-Reply-To: <cover.1772811429.git.d@ilvokhin.com>
References: <cover.1772811429.git.d@ilvokhin.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/tuoj/FLMPa0UPrYOx7INpk/t0Ezcuz70=
X-HE-Meta: U2FsdGVkX18o2yCoAdNudJeUMcXbnJEYHu+uAzjxxnehAq7dDUP/xmvv8xmVDKJ+sHdFfRBbTFzK07D9SBVNG5lu0qwnhTVsnM0o5Gy4q6LyibMOFHlIKceH6YgDFyDb4ZybrsY35RjwPhrNL8y2bWtIUgcw7+xgUv0gar9Sr7WU2RNOGA6X1f1GYYlhnTWxe4CqRoS/n0zqBTw814P8ihlQb3gz9bjChSO0Ow58vqnWJ8iuH79Z5OsmOuK5oWi0nk+aChJ5I3ofXEfZxGeaLcUGBrRgbUYqKx49GI8648/JWtoDNmHF3fqmrgZqGdc8wsxmZ6urtG+pqAnLpwBi19wHYtu6vyzOr049HFbEac+QJcz9neQK7Ba9DGybJ8ILp/AAaOfTCqbX29HClISE4gyQh41ENihXnfQX3kPpC/irPqTZBMUjIfoWA3DSxkPM
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C1F7116001B
X-Stat-Signature: jgk3cj3jcw6oc48khwk7f3tcnuoap3uf
X-HE-Tag-Orig: 1772813753-241209
X-HE-Tag: 1772813758-906811
X-HE-Meta: U2FsdGVkX18NdjCQIlJNDuOzahwoD8PWQ693FRXHENfq2AI/Mw41g1/xz8uxRkDQqOPYZyuPhNegM9kuZEIG48hqGUQgoqEadORDNZIOtAVCdnGBskc/pz6qWzy8uBAuG0z+RxDInCAVQPkopq3wxtHnP3g+oQnHt8d3iSWyRGbdYQAdA2SZ+96xftl7OAxVJkVAiorLB30jh+WqAxuWNthK0BfjK3Y2LmtA48YktQuRCl8zOXTmRCbJCGNQ+6b6ORA7Wzn5W+1D2Z+876aNBzqSqSnEKg7YT+rrZY1C6me996+b0987RenyAIA5u11kJoCB1CwlGXx353eaLQmgZKYrBnRoaJlHvVsxKcMEg0ZSd85+j1qPL6/ai7AzAdc3mvFvaDco9hJW1BTYKut9b3HaMdIeErIuEVuRMzgVMBZLUOTXq1Hum4Vbz2FwO5sKuzknvrCIPQznvn07jUJbXyDrCl5Nyf9Z/TbukoXSHkneeJ6Sr3ZhdtrMRYcPxqsbKncp879/AwDnloCXAFHqAwu58r/iOd9t4QFhd7ESVo3/3aJBdYFRKKwl6EoYj0KbgKcQi82Sb7Od14OglO8udQgT5KHMvx0P07pqK4vTCOp1tK7KAiI1VpCyqqP2AHOjatoJ4h5PH3Eq7V4va9W7WT5ojqwmQa+n+SsYsfLuDldBqyoXPUgZTJMV+FuvEf9OBCvzkA73+BIWo5BwKN6eOQConERMUI/vjWw2okDMLkg1Q4phGQA8YNwnY2fBBcPXdn+mdAZOUvkAXa8EQdx8LygUzDM98E9ehpGoIJPWDRHJUMDRb9BVdgdfQ7kFQe3cxZ0u9+dwJ6Kw2kbHUmg+yhLjne68cKs/O7KBC9ZxvrK63wopPh3eHufXKRxTpISpVBsZfISr3c1hsyt9GMPPIrC0lOeTyoH5kZYLxVOClHgxykXDr6LavRP2L5/JgWJD1pQ1l67WujPKr6mfDEe
 znS7z5+2
 4uBKwmLjPfkr0nM22ATKOLnb2lvh/jqzDSx9INyihshkaCDTBiW65sdY0iA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  6 Mar 2026 16:05:34 +0000
Dmitry Ilvokhin <d@ilvokhin.com> wrote:

> This series defines DEFINE_LOCK_GUARD_1 for zone_lock_irqsave and uses
> it across several mm functions to replace explicit lock/unlock patterns
> with automatic scope-based cleanup.
> 
> This simplifies the control flow by removing 'flags' variables, goto
> labels, and redundant unlock calls.
> 
> Patches are ordered by decreasing value. The first six patches simplify
> the control flow by removing gotos, multiple unlock paths, or 'ret'
> variables. The last two are simpler lock/unlock pair conversions that
> only remove 'flags' and can be dropped if considered unnecessary churn.
> 
> Based on mm-new.
> 
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>

Thanks, the code looks much cleaner.

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve

