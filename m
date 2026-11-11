Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1993606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=goodmis.org header.i=@goodmis.org header.a=rsa-sha256 header.s=dkim1 header.b=7BpeV/CN
Received: by kanga.kvack.org (Postfix)
	id C5B696B05B1; Wed, 11 Nov 2026 18:15:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0A9F6B05B2; Wed, 11 Nov 2026 18:15:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFA126B05BC; Wed, 11 Nov 2026 18:15:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8923F6B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:15:22 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 04B2FA0402
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:15:21 +0000 (UTC)
X-FDA: 85424396484.14.1303CE3
Received: from relay.hostedemail.com (unirelay05 [10.200.18.68])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2DBFA1C0002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:15:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794438920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gmDNsQ8h2wciKasKQCbqVP3maaL4qbrw5sZmT7BnjeA=;
	b=ycmZAe+OBuXvChxPzw05FScz1dogxsVzztHQKfVaie7c3hTM6/PNdOsUyrSxNSfUKKz4CV
	5gg7rWe8t/m8q/I1bWo4/SQQf3ZQCdTaS6f9u11CFaPFpKGbmJU/IOFemujcrXy7basasW
	Rc/4uQbAKKY7IoV75ramKE6ytERCbFA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794438920;
	b=SQ3VyhyC6BeQwdHXESEIB9OEcy6j6ep00KssPDYLDsBgkh9F7Tr5s3CuRvckFrYakOseMK
	0ckCP6rThcYVG950F4dRpCvrGsYPc2PE24q+uo5dkkCj/9QAmx3DaqUZc17wHqa8SfISml
	Erl8qsDxylwFvG7NxaUHzmvOvgq34M4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	none
Received: from omf12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 42BF340216;
	Wed, 11 Nov 2026 23:15:15 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf12.hostedemail.com (Postfix) with ESMTPA id 7DEE41A;
	Wed, 11 Nov 2026 23:14:54 +0000 (UTC)
Date: Wed, 11 Nov 2026 18:14:47 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Tao Cui <cui.tao@linux.dev>, akpm@linux-foundation.org,
 dgilbert@interlog.com, mkp@kernel.org, loberman@redhat.com,
 jmeneghi@redhat.com, kraxel@redhat.com, vivek.kasireddy@intel.com,
 mst@redhat.com, jasowangio@gmail.com, eperezma@redhat.com,
 stefanha@redhat.com, sgarzare@redhat.com, mhiramat@kernel.org,
 jgg@ziepe.ca, kevin.tian@intel.com, axboe@kernel.dk, linux-mm@kvack.org,
 James.Bottomley@hansenpartnership.com, sumit.semwal@linaro.org,
 christian.koenig@amd.com, phasta@kernel.org, joro@8bytes.org,
 will@kernel.org, linux-scsi@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
 linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, linux-trace-kernel@vger.kernel.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, bobbyeshleman@meta.com,
 mathieu.desnoyers@efficios.com, robin.murphy@arm.com, mason@kernel.org,
 aesteve@redhat.com, tjmercier@google.com, harry@kernel.org, vbabka@suse.cz,
 cuitao@kylinos.cn
Subject: Re: [PATCH 4/7] tracing: account ring buffer pages and trace_array
 metadata to memcg
Message-ID: <20261111181447.3c483a50@fedora>
In-Reply-To: <avScKhR22kFOQ1z4@google.com>
References: <20261106131829.3228926-1-cui.tao@linux.dev>
	<20261106131829.3228926-5-cui.tao@linux.dev>
	<avScKhR22kFOQ1z4@google.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18kGGg1w/ZySP1UptBt2yyJGC8WbNBioPU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=gmDNsQ8h2wciKasKQCbqVP3maaL4qbrw5sZmT7BnjeA=; b=7BpeV/CNBK0xn7L5qTZRDTfRvQV7U2cQp/mCdojV1+x96AlRZ9rtulOhbTPnbSonEkl9dmgz3eGjHb8p+E0h3XDjeebpimn+FH/g477dsAXlpcaBL9IKpa4sWBqls3LUz3Nl8QeSDhvVfF3uaAU+FhhTMPtyWJPI5tA4IvX91lQ=
X-HE-Meta: U2FsdGVkX1+FAoSScfo676HReBJlhh89iBeR1SRWVaCqtKRtwKahRcTeRtp0PW6X+8tP0+cIcuPmi2dveZHq+M/PfpnjBQfOKdRrGrE6L6XJMKcHrkYMPwWfT5W0HZpH0ZA4Tjcgp99PZuSv7mPL4a7u5MFDGa5PSeaKjEeGZ88gtDz4qBX9Zmj8tooxKlDTcIzzVtZdHTNqYaysHU8krqFFZhQV25li+r73imgz99krf7wx8TB68OGyy17GR6OQunJdYHkV2EjKXilR7+DL4H7NvH48tc6IGNBrCqnO6wIQzDRZ3F+KJfPb6Hec+mdDc+COvRxaHejVamxGg/o8L4iQ0lpkg48J
X-Stat-Signature: t3rfkj5n6s5965qhn8q6cza9f5heee84
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag-Orig: 1794438894-129449
X-Rspamd-Queue-Id: 2DBFA1C0002
X-HE-Tag: 1794438920-441688
X-HE-Meta: U2FsdGVkX188tR/3P3n5F+jC11x5p5DnwSVYat40BWKeXt2vQXLsXkwEsDlZdACJKGXwi4gQwyt2/UPa/RVgAx4hrvS6fIp2YK79Fi1soZR/tOIqfLvqu6sckAcFXSjq8sNctuNrYyaDHyIsiPup0ywASawYerRWUy2Jt4V5IhDHL1w6AeS6YIRpFQFKr2KWIvtJ3n08oJyrBsDlifqYEydx3cXtECGW6H2012iXlxI1XgsSmcwJYKVdQKIZQ2BDqbB3Bb+YO29BLBRqX+f8uVyd3yYr88g40784hVBjeqYAne21RvHisc0vaKWn+TbZQZbjgbSGWTU/MYUiToUA7fNeNSNJzMGN461x/NIgPeZalIBZ36BMZrKIKCU+K1svjuuoDWmg4n13WEcAa/cITGBiRnntF9aM/PHT/Ow4cPjBkSDxaE/y13UHqGEAtt7v0LSDqVOTQsCK/GBTR+WJX7Y7geod+6mcGI7bJaj2tMYzs/o7hHVe4uNJiolE6JhFIDbT1Ilf9qBaGxEYskPHZj96huUACkchge8cyTdybb133RNBiwh2LfkijofbwMbGeRtQaVLmHs4cwTTJmC04xP4gPFzvTGBWpJNjQy3RhrTMrQV0x5+1J/KEeTk32ZnvqnADvIt4O2h4N3ch+WeYVOhf3D45j1kc/dC94D3WHAA5vTV6nQYMT+zEh4SUk3oU1KMRefYE/aGII2QL+1ZJdtoFGph6lO7DE4tt1Isvn/ZooFzwaQYF1g2JsYwYbHE5PGC8pvFftTdcpchkmNg5AGMg+Q7K5HqlxPJt3EEp3RW6gyQeHXhVNVF619Y1GeB7duJCqfpMxIoQjtyZ+hAmPqlZKiVwE3QcTHEVwanRHW3UfbjJONlf98kJPC0yxqlOSdHWRDCjdwVlalhst7yi4tmIJnfAKu/fYAjM7tMKYjGkxdr85Lw7d1mGrw9jg+Xu+ZRcDkb/MoS9gU9LLmD
 bn+QeteV
 xiJlGXFB2soI/FdJ/IHlc/DVT29IrFBEh4KjEk7rBCsmuGZqmQpEnh0sWVAfq9RPJx7Imur0prvY3T6+Un0hD6vSzJN7X1PB6B0JNDE5FOc2WPpjVCNLWpAnvkS1SFn+Ju6fUL1PrrHdrUi+DC7gX24/ajFEd8Xqs5gw9REX5KMi949Bzr5+K/fgrmkAMr83tL3FOjaqxLXgopVz6oUfCp6iMhjuwU0Cx/8L2dHLrwQr5lqY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 11 Nov 2026 16:47:38 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:

> On Fri, Nov 06, 2026 at 09:18:26PM +0800, Tao Cui wrote:
> > From: Tao Cui <cuitao@kylinos.cn>
> > 
> > Creating an instance immediately allocates two full sets of per-cpu
> > ring buffers, array buffer plus snapshot, about 1.375MB per cpu per set
> > on the default config, plus the trace_array and its name.  None of it
> > is charged: neither trace.c nor ring_buffer.c passes __GFP_ACCOUNT,
> > while user_events in the same directory accounts everything it
> > allocates.

As the name suggests, "user_events" are for users and are special.

> > 
> > Instance creation is currently gated by tracefs file permissions
> > alone, so a
> > rootful container with the host tracefs bound in can create instances
> > until the host runs out of memory.

You mean, "works as expected"?

>  Charge the ring buffer pages and
> > the trace_array metadata to the creating cgroup.
> > 
> > Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> > ---
> >  kernel/trace/ring_buffer.c | 8 +++++++-
> >  kernel/trace/trace.c       | 6 +++---
> >  2 files changed, 10 insertions(+), 4 deletions(-)
> > 
> > diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> > index 1fd28a72e6ee..676c059c112c 100644
> > --- a/kernel/trace/ring_buffer.c
> > +++ b/kernel/trace/ring_buffer.c
> > @@ -441,7 +441,13 @@ static struct buffer_data_page *alloc_cpu_data(int cpu, int order)
> >  	 * gracefully without invoking oom-killer and the system is not
> >  	 * destabilized.
> >  	 */
> > -	mflags = GFP_KERNEL | __GFP_RETRY_MAYFAIL | __GFP_COMP | __GFP_ZERO;
> > +	/*
> > +	 * The subbuffers are charged to the memcg of whoever caused the
> > +	 * allocation: the creator of a trace instance, or root at boot for
> > +	 * the global trace.
> > +	 */
> > +	mflags = GFP_KERNEL | __GFP_RETRY_MAYFAIL | __GFP_COMP | __GFP_ZERO |
> > +		  __GFP_ACCOUNT;
> >  
> >  	page = alloc_pages_node(cpu_to_node(cpu), mflags, order);
> >  	if (!page)  
> 
> Hum, by default tracefs is root only. 
> 
> And even if made accessible to other users: 
> 
>   1. The life span of a trace instance is not tied to the caller.
>   2. The ring buffer is shared by multiple users.

Right. Is there a use case out there that allows non-admin to create an
instance? Tracing ring buffers can expose a lot and should not be given
to unprivileged users.

What exactly is this trying to achieve?

-- Steve


> 
> Overall I am not convinced charging the creator makes much sense.
> 
> Eventually a few allocations for iterators could be GFP_ACCOUNT.
> 


