Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1892AFF887E
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 14:52:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41A796B0095; Wed, 29 Apr 2026 10:52:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F25A6B0096; Wed, 29 Apr 2026 10:52:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3302A6B0099; Wed, 29 Apr 2026 10:52:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 204B06B0095
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:52:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3CE4C1202BB
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:52:41 +0000 (UTC)
X-FDA: 84711884922.03.22A7BEB
Received: from relay.hostedemail.com (unirelay04 [10.200.18.67])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6E1ED40002
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:52:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777474359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ugLM90Y7kk2DtlyF/mpf/bYg72pvvzvli6x4UgzHxtM=;
	b=UrAB2B1y/ZO+uCMYGedXDSO5TwJi/fPNIeUPr+AxaPSAOOOLf7DKR2AY8Y7ru/vzxkF3ph
	H4IlXip3aFSXa1aZkqH455KQeSFqHFfzyf6s2D8pZMB+j7dhtIYk921moGQS+wbIng2lCl
	zot33mrAgyZvBNoJ305Zowh3g9veRok=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777474359; a=rsa-sha256;
	cv=none;
	b=PjzGRzCcr4q29G0J70VLCdkov0mkx+rDPL4R7g6kAR+mbzLZbdHcRICfg8vyHtCjIuzH3p
	ujV+SQVnOepi9YuUpddjQyxUShEmmj0fpABg4lKvi3KE+k9HodXh3ZNhIu4/OupRkygDLn
	s3BHf3X5Sa5ioT0pwtEIjKw8uAiwHj4=
Received: from omf06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B933C1A0313;
	Wed, 29 Apr 2026 14:52:32 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf06.hostedemail.com (Postfix) with ESMTPA id A344B20011;
	Wed, 29 Apr 2026 14:52:28 +0000 (UTC)
Date: Wed, 29 Apr 2026 10:52:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: SUVONOV BUNYOD <b.suvonov@sjtu.edu.cn>
Cc: akpm <akpm@linux-foundation.org>, vbabka <vbabka@kernel.org>, linux-mm
 <linux-mm@kvack.org>, mhiramat <mhiramat@kernel.org>, mathieu desnoyers
 <mathieu.desnoyers@efficios.com>, linux-trace-kernel
 <linux-trace-kernel@vger.kernel.org>, linux-kernel
 <linux-kernel@vger.kernel.org>, surenb <surenb@google.com>, mhocko
 <mhocko@suse.com>, jackmanb <jackmanb@google.com>, hannes
 <hannes@cmpxchg.org>, ziy <ziy@nvidia.com>, david <david@kernel.org>,
 vishal moola <vishal.moola@gmail.com>, corbet <corbet@lwn.net>, skhan
 <skhan@linuxfoundation.org>, linux-doc <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2] mm/page_alloc: trace PCP refills and PCP zone lock
 usage
Message-ID: <20260429105245.192e67a8@gandalf.local.home>
In-Reply-To: <1453063691.2584758.1777433513691.JavaMail.zimbra@sjtu.edu.cn>
References: <20260425091335.346504-1-b.suvonov@sjtu.edu.cn>
	<20260427060142.131055-1-b.suvonov@sjtu.edu.cn>
	<20260428142335.3bca0166@gandalf.local.home>
	<1453063691.2584758.1777433513691.JavaMail.zimbra@sjtu.edu.cn>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/gO+H3IUx7sVHTPg/bx8A4FuIpjf3S24k=
X-HE-Meta: U2FsdGVkX1+bnbMuIeHV/UgJRUTOQxB6W5jOfn2Q0Tl/AkipVunZIoaSus3NWsVFId/CmDr8sy/VbnbG0pb/aIuMKsaKG1AeCyOC/v2A6T77ZyfIyT6VlTgf3ir5WFPnCzA+5p/LxM4uwNTx/t9CpfKW/bnRveONJSermvPB4/FoeRuVsFOmIgHwKUpLPtgfbLZj+FDkjYxsu7bchL/K2FcDIAq3ncdRKe8Dfc+R7VOLqVpUjNNDZEZfuuPD0rvxQsRxH0kK+nHQXABXhdOHwXmrCMyxfmtNcdCIC/XtQuEAHr5n76QSzc3c63+1BK6s
X-Stat-Signature: hkat18xezybbqk5dyxadixumtmrtrta1
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6E1ED40002
X-Rspam-User: 
X-HE-Tag-Orig: 1777474348-817918
X-HE-Tag: 1777474359-612947
X-HE-Meta: U2FsdGVkX1/h7/+ECKnml6lStwuUprOHAdgrVqW6j3n6xe57WltA63E/4hibCA3ho/gsMhklUrEv6dBqR0SllUaZO0+OC4LH7kKeqEY6OyGa27K/+pGKapHAGDsfKnTz7Xu9+YKJcI7tzJIV4NPQvC+Yr+3Oe+HhdcHioNfrufoPUqNl7/b9/6GkpAB/Y0UEeLqmReDZKi0aODyquyOGehgdPYp0voTbJI9s2InaP0iqZQEM/BOspT9rm5AAgSK+bsScPEQsVCDsiIMAO0ggVULyiCuYbFOtbPTzGdiPbjp2xEDNK8YpyPEO/WefCMfEa9gOXMEwgNyrR1jdUTgGCKMokv+2A1vGyN9sHINF4cmchjxrSaXcUISXTkFN5pIQMZHKcn5vI36CYzfCEvDxMxnbjSdZDNq1DW/QYjcUsQN7KIj/7xgyg5OmzYg3c/1g21lkLzQeXwKPn1T6VSXIzNcv7nSQH9JZMRDo9bzwvy8dc2GxgffOukVh8NxoeIPTtK2RHRiv5bqOzwOTawKX9mZKUgQqD7JXA4eCy27Aw3AS/Tz/z9DxwEZHRCpiWMWIVT4HHRExrc5ujrqKsihX1187w4dKrCYpgqgEnhekNnESG5xJGrMqWGZ2UOdFXE4MdlKmcJoG0a0K8u5mSx3HTVbBAuKkF5bWjw9Ou6/Q21bQ9tnLn8EPkFPyS46kYvGE4EgIXs5AlUGxa4IRvA+VKFTNVB4vJpHBcL2tDqheACKjEU1mY7x1W8wskCSf+ZF+57QRwqoL2ntw+6oyhQRKyzF//h+jJoBSlG+EPiFgIMO7oDR191rcJ6ovAWH1PbOa9CtvRnlrP+6vsAC32HHGrrZxyHG+w3BPObz1V9yiHjTM204bOQDEKVxfjvetrGTK3GrS2A8xUTGN5fGtKaizDzz7oYU0htRjiz0LU9YaJaBdMhnlragXSLhUFTwgrIDmKW6nw47DGLmCES/+I4i
 NTKgAlKW
 UvijOtYx1riK6MCodfuvICiStI8GCV805vRB+WO9ggUBpkBQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Apr 2026 11:31:53 +0800 (CST)
SUVONOV BUNYOD <b.suvonov@sjtu.edu.cn> wrote:

> Thanks for reviewing Steven,
> 
> >Why this change? It makes it much harder to understand.
> >
> >The above is not a normal macro. Ignore any checkpatch warnings about it.
> >The proper way to do the TP_STRUCT__entry() is to make it just like a struct:
> >
> >struct {
> >	unsigned long		pfn;
> >	unsigned int		order;
> >	int			migratetype;
> >};
> >
> >Thus, the macro should be:
> >
> >	TP_STRUCT__entry(
> >		__field(	unsigned long,	pfn		)
> >		__field(	unsigned int,	order		)
> >		__field(	int,		migratetype	)
> >		),  
> 
> 
> Yeah sorry for the formatting issue, will fix in v3. Any other concerns?
> What do you think about the introduction of those tracepoints themselves?
>

It's a basic tracepoint and nothing unusual about it. I only watch over how
tracepoints are created and some use cases and make sure they are done
properly. But the introduction of tracepoints in other subsystems are up to
the maintainers of those subsystems. They are the ones that know what is
useful or not.

In other words, it's up to the MM subsystem maintainers to decide.

-- Steve
 

