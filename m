Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4E67D7879F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 18:02:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26D046B00A3; Fri, 19 Dec 2025 13:02:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 249E46B00A5; Fri, 19 Dec 2025 13:02:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 136476B00A7; Fri, 19 Dec 2025 13:02:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 032C96B00A3
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 13:02:53 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A0F46140367
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 18:02:52 +0000 (UTC)
X-FDA: 84236991384.10.F09621F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8FC0E80017
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 18:02:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E95UB0UQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of lgoncalv@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=lgoncalv@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766167370; a=rsa-sha256;
	cv=none;
	b=kKbT/3BleXzoOagrEosppFopQlUV9S7UVpZfSDLb5xZ6eZXTy8BgcKahIG1LKBPFrc8E5N
	ZO++8CmdHxmZo2I54yQlfCY8CauOaxw4QTBQq3CB8mKOi2JUhZz2h6CcP54cqOWWZYBA+z
	fTycX2s4iwRPbi5Ta2p1SLVsdGiC1BQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E95UB0UQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of lgoncalv@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=lgoncalv@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766167370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZH+aI24H1Mv6F+Km0lz8E8kB3nbFXN5ma2j3LpWd/jU=;
	b=0gG7iTuDDhEYQqDN3GF52eDMl405ZdFKu8U2/1e4+hadad+hMwS0d6O81IAyUUY5J9rVPj
	gQesPDEPog/RT1w5qA1cJC5M+Ck7YeF2m0UY6Hiv34/1pJViho6vAyJMihutc8fExvFTRJ
	BW4Lajro1hK7qfvOwAvjbNc1eGQyqw4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766167369;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZH+aI24H1Mv6F+Km0lz8E8kB3nbFXN5ma2j3LpWd/jU=;
	b=E95UB0UQkUwYH7Efa1vtNb0yKC/wWv20daVNBIZqSkdDr38CXuUQ7l0F5yEbrDeV1S5bJ2
	HgVlvCkatOPb6qZTBWm6x1II2NfKvIAcvw8r+bZI9VlGibBqbh0I9MYhhg7H+4zu03I2fB
	qJYDjbq8j4ji0vRkJ+65zeZsbi8csCo=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-621-3P4v9Qg9Ng6HoIUWYYPajA-1; Fri,
 19 Dec 2025 13:02:46 -0500
X-MC-Unique: 3P4v9Qg9Ng6HoIUWYYPajA-1
X-Mimecast-MFC-AGG-ID: 3P4v9Qg9Ng6HoIUWYYPajA_1766167364
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5BCA71956046;
	Fri, 19 Dec 2025 18:02:43 +0000 (UTC)
Received: from localhost (unknown [10.22.88.80])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 04A3519560B4;
	Fri, 19 Dec 2025 18:02:41 +0000 (UTC)
Date: Fri, 19 Dec 2025 15:02:40 -0300
From: "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
To: Hao Li <hao.li@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Alexei Starovoitov <ast@kernel.org>,
	"open list:SLAB ALLOCATOR" <linux-mm@kvack.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:Real-time Linux (PREEMPT_RT):Keyword:PREEMPT_RT" <linux-rt-devel@lists.linux.dev>,
	skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
	syzbot+b1546ad4a95331b2101e@syzkaller.appspotmail.com
Subject: Re: [PATCH] slab: fix kmalloc_nolock() context check for PREEMPT_RT
Message-ID: <aUWRr1NI4VR9i7pj@redhat.com>
References: <20251219085755.139846-1-swarajgaikwad1925@gmail.com>
 <6fcfe0cc-3826-42c2-9c54-c127dc8379e1@suse.cz>
 <aUVTJyd74OoCtSyN@redhat.com>
 <p2kiryxpwq7iu7x6jq65kzff4uivbdd3cne7rizax5b33ce5yx@nr5hfrnfevxy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p2kiryxpwq7iu7x6jq65kzff4uivbdd3cne7rizax5b33ce5yx@nr5hfrnfevxy>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8FC0E80017
X-Stat-Signature: mw9pauyryrrmeurdc7ixfedyqqctctka
X-HE-Tag: 1766167370-669834
X-HE-Meta: U2FsdGVkX19sEi+lDzFlqvxij8jSUqDZcIXqvUgLkhUWN6QUm90knK/KqUadfe0dbn9VxsH77TDVL1BeM8/ns/tCqovVT2yN4pqI1onEZras2ljJbdr5s41bJ3YyBJckwxEGb5Gz8aPn6h1PYwEWfVrWWv+hG3tTXnvPVUIDGJVeM2EiPz3nTodsTc+AORbkJsHRlniTqoqEr3Wr1+dyAecAMd7eWdyXs3vWCfh1wJMOMccmJC8kIwwG21HiZrwAWHt11gvcLuExGl0qYzWeHA9dBU4Fw4mfr9H3xoh/5H7CdbfNR6uY1y8hRzvVrQy5fZt9lDbCg7B0HZLfQK4PEnE1Bxg5nmQqAtOgeUe0F2Z2d4AdU4w/4b8Y1JzwElXsFI9bTMbJu6ZWxYn5V03OyxH325jWZi5hI3hTo6xNuR3F6wtpksoGP8fPDRAhKrtV+WiEKEfMD13hdX4VVbUbMuSmstYSqzj4BRwyWOMM62qwIH9yyGtoqDtzVibQvsVLmDf7cU6owk64+qIuWuFWOzjcReX8paIkET/IfSMVwQ8xAhsCIC0LaN3zR6o53YtFfa61lnJcp8nBzvX0LB5VvhFCl7hxL/ieYPC6JZeyV+6bICrQVwt6iHwCUX+hy9asgT8mDHI9KDiMYy1qh2CUz1Vo2JTxtS1z2d030LhQcbfE0ruluMst4uUKjNnDiLJbZP/K04Hk/KEb8kgD+0S9lCrbOJ6nhZ14r1rLTcZ2QoQGfdIAQTBi+6JE+pL3vXxCycG2P2Z1juBUH2Eff5M16EXgnq/J6GaAVOJ7oYT7XoyExtuWmGoK1p25DCiE9ID7FqZ5n4e+E/cHct9ksRAOxCkpkBNSwp3xWZ548oJXXgh9zPqlnbgj9vj4CDgBScXyNXC8/vOkB8OCfgsabbeGUySA3QPx9cfFEfNVWOyLXNFRDlBJztmMQtae2O0O1uQ4jPWxFc9Xd4KnlK5yCXD
 8JNW3VXd
 oD93dyES63AxN7lLlojT0ASDzq+xOoHef5kNxmZd4Gz6usnMYnJvFKbPme5rOhY6KTKYNVMUaFbdypszdQPawx1Hic1XRIk5GNATuYBebRGC7mXCBaISDRhyAogyAc723xz4Sw8u6jvu8dFSJ1KAm7BvNwlrsPoxyWJsENIVYZDtcSfxtu0UYavTNldIz7yNud5jjIRWTSnrFEyi7nQeQ68Ur8ousjVP/Nvu18MKuyEyt1lq8ka3Q9HzLPAW6gChXCKxlax1Te2yN5QdWruqQMSvK4HV8JUeqj92RRmH3h0MmGVVh+PYJzA112VHqTY5r7IFudg367tjUAH6jguOkkXHlXgJbeRUjK4hJ1KWcCVXaHAf3/RBKqZmjEzfjz99rlOCAqMISLLJdaKIbHml9Ow+AXXXcXugE3kS/M1KEVyXJQ2c3WcP7TYBXeqRV/KkNQ7JLu9GLMEnKr+O4NE+nAAKrZNtZWY/M8xucDJfJfBmCjzFYl6Y/biEVfxY6Wt1bswLuALxlMKTYpU7rV37B4eTiecUoyhbbOMIQqa9EPf47kb0X2PdQYBiK7andnlnFw2FejnrlVXmWkDuLLU+5b+WG+hvi5+5Kh6nOJDrtSN1hQ+eUk5RR+RO+8sru3/Lf4wmijxA9KT5bsardoQnrkOzFxA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 11:22:02PM +0800, Hao Li wrote:
> On Fri, Dec 19, 2025 at 10:29:11AM -0300, Luis Claudio R. Goncalves wrote:
> > On Fri, Dec 19, 2025 at 10:31:55AM +0100, Vlastimil Babka wrote:
> > > On 12/19/25 09:57, Swaraj Gaikwad wrote:
> > > > On PREEMPT_RT kernels, local_lock becomes a sleeping lock. The current
> > > > check in kmalloc_nolock() only verifies we're not in NMI or hard IRQ
> > > > context, but misses the case where preemption is disabled.
> > > > 
> > > > When a BPF program runs from a tracepoint with preemption disabled
> > > > (preempt_count > 0), kmalloc_nolock() proceeds to call
> > > > local_lock_irqsave() which attempts to acquire a sleeping lock,
> > > > triggering:
> > > > 
> > > >   BUG: sleeping function called from invalid context
> > > >   in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 6128
> > > >   preempt_count: 2, expected: 0
> > > > 
> > > > Fix this by also checking preempt_count() on PREEMPT_RT, ensuring
> > > > kmalloc_nolock() returns NULL early when called from any
> > > > non-preemptible context.
> > > > 
> > > > Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> > > > Reported-by: syzbot+b1546ad4a95331b2101e@syzkaller.appspotmail.com
> > > > Closes: https://syzkaller.appspot.com/bug?extid=b1546ad4a95331b2101e
> > > > Signed-off-by: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
> > > > ---
> > > > Tested by building with syz config and running the syzbot
> > > > reproducer - kernel no longer crashes.
> > > > 
> > > >  mm/slub.c | 8 ++++++--
> > > >  1 file changed, 6 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/mm/slub.c b/mm/slub.c
> > > > index 2acce22590f8..1dd8a25664c5 100644
> > > > --- a/mm/slub.c
> > > > +++ b/mm/slub.c
> > > > @@ -5689,8 +5689,12 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
> > > >  	if (unlikely(!size))
> > > >  		return ZERO_SIZE_PTR;
> > > > 
> > > > -	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
> > > > -		/* kmalloc_nolock() in PREEMPT_RT is not supported from irq */
> > > > +	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq() || preempt_count() ))
> > > 
> > > AFAICS we can just simplify that to preempt_count() then, since in_nmi() and
> > > in_hardirq() both are a special cases of that.
> > > 
> > > Any comment from RT folks please?
> > 
> > Maybe, for the purpose of this change, using in_atomic() or !preemptible()
> > would be a bit more descriptive, as both macros check preempt_count()?
> 
> Hi,
> 
> I might be misunderstanding the situation, but my current understanding
> is as follows:
> 
> __might_sleep will report this BUG if it is called with IRQs disabled or
> in atomic context. Therefore, to avoid this BUG, it seems necessary to
> check preemptible(), since in_atomic() alone does not appear to be
> sufficient.

You are correct. I focused in the condition proposed (for which
preempt_count() was enough) and missed the real requirement.
 
> As a side note, once Vlastimil's "sheaves for all" branch is merged into
> mainline, the local_lock_cpu_slab(s, flags); statement that currently
> triggers the BUG is expected to be removed. Furthermore, the entire
> nolock path in SLUB is planned to be implemented using trylock
> semantics, which should eliminate the possibility of sleeping, even on
> RT kernels. At that point, it seems we would only need to guard against
> deadlock risks from NMI and IRQ, so this condition might need to be
> reverted to in_nmi() || in_hardirq() again.
> 
> Please let me know if I'm missing something here or if there are
> additional constraints I haven't considered. I'd appreciate any
> corrections or further insights.
> 
> Thanks
> 
> > 
> > Luis
> >  
> > > > +		/*
> > > > +		 * kmalloc_nolock() in PREEMPT_RT is not supported from
> > > > +		 * non-preemptible context because local_lock becomes a
> > > > +		 * sleeping lock on RT.
> > > > +		 */
> > > >  		return NULL;
> > > >  retry:
> > > >  	if (unlikely(size > KMALLOC_MAX_CACHE_SIZE))
> > > > 
> > > > base-commit: 559e608c46553c107dbba19dae0854af7b219400
> > > > --
> > > > 2.52.0
> > > > 
> > > 
> > > 
> > ---end quoted text---
> > 
> > 
> 
---end quoted text---


