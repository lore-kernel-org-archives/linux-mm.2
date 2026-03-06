Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F12ADFCC051
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 18:01:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FBF46B0088; Fri,  6 Mar 2026 13:01:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A9B16B00A7; Fri,  6 Mar 2026 13:01:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AC526B00A8; Fri,  6 Mar 2026 13:01:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EB87F6B0088
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 13:00:59 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 96B1259DC6
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 18:00:59 +0000 (UTC)
X-FDA: 84516404238.27.BCFB9C3
Received: from relay.hostedemail.com (unirelay06 [10.200.18.69])
	by imf08.hostedemail.com (Postfix) with ESMTP id C398E16001B
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 18:00:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772820057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q8ZBfG0sGTE9QlDrlHCSXPcKk7XAlqaSY7GhvFEaFms=;
	b=6RT2PGL//baPnrNTSTybMGoTfxJ6R0xGgMsbwppwvOGIjRFR90HdcD86Gk41Pp4Rxuv6zJ
	YDX/3xNRSFH8vhM/4g8xvdQNTIHMRo71Xged+9odTluiOk75eAekpLBD1yJnGskQINp10z
	rZpkcAVOpBHdJNGMUYj9b75Q7WrlXOY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772820057; a=rsa-sha256;
	cv=none;
	b=uykIrV5jiL+5klRqXSHckf/vRdXKBVC+33YbV+KpvZbaLvjekOjHuZjk1HbJHd9saa24o4
	lAL9BqKSB+m9JJGq33jMnopHBF5v/1e4bMpNEG+mxnVDh7zQvSgyD8Yuev4HDBhJ8+RwPw
	kUfGwmljsgV/1D1PLDo8Psxz14B3FFM=
Received: from omf11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 837631B85AE;
	Fri,  6 Mar 2026 18:00:55 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf11.hostedemail.com (Postfix) with ESMTPA id 048F22002F;
	Fri,  6 Mar 2026 18:00:51 +0000 (UTC)
Date: Fri, 6 Mar 2026 13:00:52 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Ilvokhin <d@ilvokhin.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, Johannes
 Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com, Peter Zijlstra
 <peterz@infradead.org>
Subject: Re: [PATCH 1/8] mm: use zone lock guard in
 reserve_highatomic_pageblock()
Message-ID: <20260306130052.7da8eab3@gandalf.local.home>
In-Reply-To: <20260306095336.a79fcc869a7f6d2b2e97501b@linux-foundation.org>
References: <cover.1772811429.git.d@ilvokhin.com>
	<cf489e5e79f5e9ba450111ee655d9924fe7a1620.1772811429.git.d@ilvokhin.com>
	<20260306095336.a79fcc869a7f6d2b2e97501b@linux-foundation.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/6Ow7aF6DmQhdrW9kJih2ck9+OIyCBH/U=
X-HE-Meta: U2FsdGVkX1+PCmMBt+lClgi6UsFpx96YSReA/s0JN4Fg9contLIxr2iGTktY9FD2H68DBV2ce4rR1eDF453v/D4BqPnYbBmgcbAAcqONfI9XKJ0aQ+AEZYEg/fgJkb886L3MfEqbUO/SO0gCsqukCvlRh+GqR6mgrhqS/wNVBF4AIopBFgu9itqpy8C236rhTyL7WYJuaVNmHsl3n5mMwJ3kQ3kZPjZGdSkzrY7MvcfOUL8jikJpao9sBW8cJEMnLBd0vsoViWDcrZQjSnmo1D5/Jd2yOp1lpj6Nd2gckQKQnJt9LbXr1w8VkY/tc8Ta330P/qc2uKmE0jN0krbrQwgZYSH3KUtHHDOWpflUOB6hu++YFbg1he7OjW9WNg9njSrH6es4ThqGFYLIB8XeAPMF/IKSpQxLrK9OgJdl76k3yf4KohOdqvH1beBGSize
X-Rspam-User: 
X-HE-Tag-Orig: 1772820051-753140
X-Rspamd-Queue-Id: C398E16001B
X-Rspamd-Server: rspam08
X-Stat-Signature: myjygjb5g1ih1eezpiay44u1oo6pdfkc
X-HE-Tag: 1772820057-388874
X-HE-Meta: U2FsdGVkX19WHiqHT5bFKb6vce1YIqripyca/Iqm1EGZ/tXk2G+d+GzFOwBBuAz2iefhNw/+WEMXNPTNxoD/cARemNgtiycSzjnaZsrywe3z70ng3uSm7Ov+2ONOUTyC36YQW3SAqsmDea+fhjWB/OvAzOH3MIQZXSgWemtoQMATw4zboE88Vv5d/CTzuglNT2IycezMLph+/8oQ/WCh06ghIhMQzYDjK6JhBPoe4OZR8gI+fW6QG+GP7oSeLqkl/2lwveqH/lgMlSLetJCelC6u7GLSWRCWhgrm7HIbm3aQsk2vtc8nnM8Tc/KI66+XdCx6JeB766D2PWkkddUp2VAU3R8eSFiAutyVQl6ExV9ydWRvXcJ6lzn0A7qsOWlWehKvMLZg+o6Pqe7P9alsZtS5CfL8jTEGCYIe9J4FETOQkGdHVQ8e924t2ZyhlIDuwtepdLgRDnyIJNtuSKmoO18Kt5CAzYW27Dlf4QhzDazyXN4Z6Jk5Ifn55KU8gpZdZRu6p0EzpP/Q6bfkD1AqGbREDr4fnkXjO99VukCwN/uOseN58nSgu0wAhDj4+HjbhqY7+w+F22zxnovGy3hgZin2d0cxhtVbW2I0v00kSSR7qOqai0BDL5GBFD4s3F3KLDlSyGTjO7Kpo1F9Vt3knLbSYd73kbW1oNOKxA8KchmoLOSLKO2IT5VGXVPKUh3FlK81M0ohf1566XXcGhXSLEVv9se641MevRo6n7ZtTZqQdZH8TS0QiQONgzm9Ajy754PqUu5pSXT355yIZwGsOjDNYTlQdAf4Edm3GeGGRtwBKNTHe8rVP/FB3aG/Oeg+E+KboiTGuIys/4rzhqVOITGYngD/MN+P681fh9In/1qymrngzWte95UwI6l6ngWHdlBKJ+TCIrZW8sRVP9s3E0RKm57FKrwparIQj0wUqmPJ1C5Bx+fhm1/31ByzZkPRcFNnv2FQibnowy4XeDR
 akuP6pgl
 mhJcd49H6/Ql1KlcyClMHZvUFiMCOysRp0sTTbEureo7MHxO9QXn4G34EeJAWK9vk/am8prmsnjK8RjbFL/l5DfJEz8/nmKjPsz4Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


[ Adding Peter ]

On Fri, 6 Mar 2026 09:53:36 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri,  6 Mar 2026 16:05:35 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> 
> > Use the newly introduced zone_lock_irqsave lock guard in
> > reserve_highatomic_pageblock() to replace the explicit lock/unlock and
> > goto out_unlock pattern with automatic scope-based cleanup.
> > 
> > ...
> >
> > -	zone_lock_irqsave(zone, flags);
> > +	guard(zone_lock_irqsave)(zone);  
> 
> guard() is cute, but this patch adds a little overhead - defconfig
> page_alloc.o text increases by 32 bytes, presumably all in
> reserve_highatomic_pageblock().  More instructions, larger cache
> footprint.
> 
> So we're adding a little overhead to every user's Linux machine for all
> time.  In return for which the developers get a little convenience and
> maintainability.

I think maintainability is of importance. Is there any measurable slowdown?
Or are we only worried about the text size increase?

> 
> Is it worth it?

This is being done all over the kernel. Perhaps we should look at ways to
make the generic infrastructure more performant?

-- Steve

