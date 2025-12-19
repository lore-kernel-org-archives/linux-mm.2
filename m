Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20998D78771
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 13:29:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5899B6B0088; Fri, 19 Dec 2025 08:29:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52FDA6B0089; Fri, 19 Dec 2025 08:29:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 411936B008A; Fri, 19 Dec 2025 08:29:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2FAB06B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:29:24 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C926F1A020D
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 13:29:23 +0000 (UTC)
X-FDA: 84236302206.12.8BA5170
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id C28A010000E
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 13:29:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i3PwNEE2;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of lgoncalv@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=lgoncalv@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766150962; a=rsa-sha256;
	cv=none;
	b=SkKOkYN6Vv3V94kllW8rmYxTtJ+3UJreRk8LV5jEid1P1Pp6/6S9dgJr/BJCSMpqng6+sg
	WuDPvlmWoP/D01H6fgoGn/szTQLj33UlHMgiLyfZzR1SugF6hOMN23VeGzUYb9Odobo4mz
	vaJnJZCV35rwyMvLuXHSyzoCcs55oPo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i3PwNEE2;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of lgoncalv@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=lgoncalv@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766150962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gc1KgNJYDUojdtdDVs3DJiTbaHAULdvjgF82hY95pD4=;
	b=Lcv+3Ol//NvvwRdiOSNqT6wd0OUW3+BGgtNkoPx5Lc8YAkB0oKp5A8XS4HGwSfN/+N9cxB
	nz+xTLNV7wclyE/125JYpPRoqKOf5JomKrF0PKRcXYSNP9BLPb1JWDo2vrYCP8Gzo8cTaJ
	SNYk8UN4bFnyc1FEYvw1GG/PMETUWqY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766150961;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gc1KgNJYDUojdtdDVs3DJiTbaHAULdvjgF82hY95pD4=;
	b=i3PwNEE2GX/DtUUJ4rewlVtgXTp4ur/6HxJIWAHU6ovBth82VlE5Fd6Zpy9CiHsMztj0tW
	KzCZk9MPjhqfoCfK9TnEkBHUrfhw67dUr5+fSchk6jBpXpy01guqMU4JqqFAWN5np3Diy9
	FHf4qFJr4k8yLaGLk05up0BpgAMhleo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-680-EKtsByJJPmyEl0rqWcX71A-1; Fri,
 19 Dec 2025 08:29:17 -0500
X-MC-Unique: EKtsByJJPmyEl0rqWcX71A-1
X-Mimecast-MFC-AGG-ID: EKtsByJJPmyEl0rqWcX71A_1766150955
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 722961956054;
	Fri, 19 Dec 2025 13:29:14 +0000 (UTC)
Received: from localhost (unknown [10.22.64.26])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C049619540DF;
	Fri, 19 Dec 2025 13:29:12 +0000 (UTC)
Date: Fri, 19 Dec 2025 10:29:11 -0300
From: "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>,
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
Message-ID: <aUVTJyd74OoCtSyN@redhat.com>
References: <20251219085755.139846-1-swarajgaikwad1925@gmail.com>
 <6fcfe0cc-3826-42c2-9c54-c127dc8379e1@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6fcfe0cc-3826-42c2-9c54-c127dc8379e1@suse.cz>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C28A010000E
X-Stat-Signature: mwq7xbe3r5z89n5ue6bkzc3qdy44pn9e
X-HE-Tag: 1766150961-389789
X-HE-Meta: U2FsdGVkX18iQMlgyaLlAnNnicKrikoo1jzTjhR5ano7h/LiWV173Q+ijUkOyCFKoe1SETqw3TtQPoIFdxlNoGdacZ1+bADs5Ed/fY9sI17nEUXVQKg6gAEXSvO3IX+yjKcYhCkxFJjMpBraA2S0aqUQGpNfuceA+Fa5WBDpVG9x3hOaSnzpoxKdqf1NA73PLBNLQEHzhvywF3lbIPV6D3HrbCZ27Slb3mrAfVc0m+0g96SMTwJ6qEG8ydf79nGrQFcI4vLf3ZNRA/38T1Wldy3ULDbVM8ly5VQVVnd1mUUwLSWbTAYM3dJpZTfx/qfEs1ZKZv5A/ZeQ+4ZRyhBDgE9/dv5lUMymT8bxYQo4OuMr+JlAgh5PAtxh6FAo9J7qLgYjn+AF1tjqwb23cR4Bxx8pQwMFYMj8UoNfEaTOV73WH7UU2slWLqxXG4bIA5MTot9YIVb3kBrw7QhaSW9xXCxVhG9t53YrFw6E3APOn3DLIIZXHPLsjdKpdQsHTNXTJUGweHxX11/B0MSFGIamUVWIwxyHVUEGh0WIODpnScBq9iBYEND6EH0lugzyZJaviEYZxxTW+KuG8qyK8YxTGM5W/2t4FlEAqaZd1LM1sQBN3AOUdK2PjtTEfMWv9l4KhH8i7kgy9XzoatoUUUQ5hMeemx+/5md8XgothYxP7L+p8aZLr77q/QbU0hqvZFOvdU8WFD15I7vgkovsRS+Bv1k4OrKiALNbIGsXY1uZ3BPBczf6w5xwoS7C855qKoZqONBldVYRlcxAlM9sWP4dF05pMTg2QJLTz+av6gHLZYX1wggpQ2r2kGsiXUNsybQ/ovBPkcY6FYTSgtVq+8fo4S9X0bLX8cQGxZO+JaYcNSfjICYcgqofhexZSZwIWMUASL5lsCGg7ScmGw2oPcUqeeDq7R4jY4ieNPE4yZ8oFa/qZTuUGnyV0lQSdSaCG6ydhabwdKRbMjA21UJfLot
 kkBOQ2GU
 NNu5LV88bQt+UC3+j4ZAZlYtkogotBoJu44m77rjQv0TmL58/dzS0drA8Xxf976AOGWLLNsnD+oVIjwzFhaUJ+APvg3rmWRV4n8ue77FWzF2z5onhMYYZHaQ5VjSmtfVkrKfFBcCULQfEOSCcBzzDtvdFgBIIDVcnJ8R+g0KYxfbXtkZv4pCPY9lFB3g3oyYHq5VvbO5IuBZ0bQts3RsE6/t5No5FKBXE8gn+WQddgJV0itfOWwYPrUrwbwC3GvH9Cpj/WMEuywhJVV0sd6RQoU/4JlgszJJBOBDGh0rCgVeAQM8qdjb2qTAo3r9Mtf7kOMe2F76xoDwD2rQSHjjZA5Zz6Zgw61JhRl9y+GHqKQ2wLAtZwafAask3ugzDxxURQrou5I9nkT8dK6Zeo4NjE0xy5QfeIc5apB+2TfIaEL0XP2ICGD42AxlSGNRL8+ukUfdqgRqzcDZYwP2OCzKwdcyu3bN1hIedvOCRXigBgQ8IwcGkZ/Zu4RRmdE+Rtpv7bb6yG8euyYe33pUwEiG4RnRRhXASM8m5XMZjIJENeKqJU3F2vsB6vww0dOLHpEdUTq3QYXP/aKC1p0JmjylgnMxopvqD1AwEjNfFWoV7wXzvU7DEeYUzw5KbliZ3pVJ/DQhbY6rrvqrFkicd4Mzd0avtMQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 10:31:55AM +0100, Vlastimil Babka wrote:
> On 12/19/25 09:57, Swaraj Gaikwad wrote:
> > On PREEMPT_RT kernels, local_lock becomes a sleeping lock. The current
> > check in kmalloc_nolock() only verifies we're not in NMI or hard IRQ
> > context, but misses the case where preemption is disabled.
> > 
> > When a BPF program runs from a tracepoint with preemption disabled
> > (preempt_count > 0), kmalloc_nolock() proceeds to call
> > local_lock_irqsave() which attempts to acquire a sleeping lock,
> > triggering:
> > 
> >   BUG: sleeping function called from invalid context
> >   in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 6128
> >   preempt_count: 2, expected: 0
> > 
> > Fix this by also checking preempt_count() on PREEMPT_RT, ensuring
> > kmalloc_nolock() returns NULL early when called from any
> > non-preemptible context.
> > 
> > Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> > Reported-by: syzbot+b1546ad4a95331b2101e@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=b1546ad4a95331b2101e
> > Signed-off-by: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
> > ---
> > Tested by building with syz config and running the syzbot
> > reproducer - kernel no longer crashes.
> > 
> >  mm/slub.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 2acce22590f8..1dd8a25664c5 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -5689,8 +5689,12 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
> >  	if (unlikely(!size))
> >  		return ZERO_SIZE_PTR;
> > 
> > -	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
> > -		/* kmalloc_nolock() in PREEMPT_RT is not supported from irq */
> > +	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq() || preempt_count() ))
> 
> AFAICS we can just simplify that to preempt_count() then, since in_nmi() and
> in_hardirq() both are a special cases of that.
> 
> Any comment from RT folks please?

Maybe, for the purpose of this change, using in_atomic() or !preemptible()
would be a bit more descriptive, as both macros check preempt_count()?

Luis
 
> > +		/*
> > +		 * kmalloc_nolock() in PREEMPT_RT is not supported from
> > +		 * non-preemptible context because local_lock becomes a
> > +		 * sleeping lock on RT.
> > +		 */
> >  		return NULL;
> >  retry:
> >  	if (unlikely(size > KMALLOC_MAX_CACHE_SIZE))
> > 
> > base-commit: 559e608c46553c107dbba19dae0854af7b219400
> > --
> > 2.52.0
> > 
> 
> 
---end quoted text---


