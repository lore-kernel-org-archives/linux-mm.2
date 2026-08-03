Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 309CFC55162
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 07:19:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B5E96B007B; Mon,  3 Aug 2026 03:19:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 440796B00A5; Mon,  3 Aug 2026 03:19:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 308126B00A6; Mon,  3 Aug 2026 03:19:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D03B6B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 03:19:38 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 87A1B16029E
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 07:19:37 +0000 (UTC)
X-FDA: 85059107994.26.9D29C85
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id E8CFFA000B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 07:19:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lzaAoMly;
	spf=pass (imf25.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785741575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ykiHD7DY9G7XaqnDrtXQxXTCaNG81ozB7o0StBvDD0I=;
	b=vCCtoULCJUF9x1mvpr/6uXhXMtqFYuLPDIEsW+32dbrnOxqy7BZ1z05tCLSRjFSXE8s4wT
	wKkEwJw++qyFWl2xXVB0oaY5cyNQoIwSIA6rTmXAtYegES0r55rbHPaHCs5Vq29OByJNyp
	LirgIcjRLmpVi8yQFZ+IMkgFApVrLdk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lzaAoMly;
	spf=pass (imf25.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785741575;
	b=r11UfNgDtgpmyZ0cIot2uwHv+P9kW4A8H3ogi0xq/GNC62bWm8mOPsI0y/3HJ/zK2AT1yq
	ke3gX9U0tKzyzC6zhQ16IvMS7eBxax/4sVyJPV0OFjjzfiHIBziKKiFY7ZsrqFSa3n4PDC
	PQ6CqMUOiCtFukDyGwdQBV+Vq1O3Vic=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A00CE600FF;
	Mon,  3 Aug 2026 07:19:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDEC11F000E9;
	Mon,  3 Aug 2026 07:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785741574;
	bh=ykiHD7DY9G7XaqnDrtXQxXTCaNG81ozB7o0StBvDD0I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lzaAoMlymuF4kOmQnImnMrd2VoWNnAasbFn4o2tBj12KoFhxjSN8hLToPrUhEiPO3
	 oEu01foRUuD96Mip7GJ/acAD9l5u9VkO4iDzOrj9beBTGIyLAiEW/He4sdcfIWR3n7
	 RoN9b4qjdAuINP2QHcnwf5x1HZN43ZdyVyrsWPcMNbDbNFueIBK0loDZwVDtJPb2SE
	 rcklEDK89DM7Xmy1+ytTbF5YZCEtiis0hg+Kv8tXcbAnKEat5wDNORC+GyfsWBPVwO
	 T0B5vGq7AyGeM/xz3vlVg9E4xxxTYVvJpOLWt9rRX3QR2pByMJ/nbp0UJrLour9D6V
	 8QwW0AVgNn8CQ==
Date: Mon, 3 Aug 2026 07:19:32 +0000
From: Harry Yoo <harry@kernel.org>
To: hu.shengming@zte.com.cn
Cc: vbabka@kernel.org, akpm@linux-foundation.org, hao.li@linux.dev, 
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, ast@kernel.org, 
	andrii@kernel.org, puranjay@kernel.org, ameryhung@gmail.com, bigeasy@linutronix.de, 
	clrkwllms@kernel.org, rostedt@goodmis.org, paulmck@kernel.org, frederic@kernel.org, 
	neeraj.upadhyay@kernel.org, joelagnelf@nvidia.com, josh@joshtriplett.org, boqun@kernel.org, 
	urezki@gmail.com, mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com, 
	qiang.zhang@linux.dev, pfalcato@suse.de, surenb@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, 
	bpf@vger.kernel.org
Subject: Re: [PATCH v5 3/8] mm/slab: use call_rcu() in unknown context if
 irqs are enabled
Message-ID: <anBAiTl_16H7NqEr@dev>
References: <20260729-kfree_rcu_nolock-v5-3-a28cdcda9673@kernel.org>
 <20260730192119586UvhYMv4xrNqaZLKIJH9X0@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730192119586UvhYMv4xrNqaZLKIJH9X0@zte.com.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E8CFFA000B
X-Stat-Signature: 9sy5arruyjxd1k5gf1b6z918nxjmmuhi
X-HE-Tag: 1785741575-95072
X-HE-Meta: U2FsdGVkX19qYwDDZmvgHinCW3oZpldneXjkklQUgXAp2CuJFFGvZEdpJijWkU5kiEqzrpIkCh2ENTrjPYicX/MPvOQBWCjagwaIhwEEaNFURbRbh8mFq5RrrLhuOUkUFoc3rO4XugxcDIFcxrhXjA8OmlBreP6Yx+q48IroHHKDMJDTrFe6hJ+BBEmVV3SErZL+3RuxRCLgXcbsbXc05dSkthhiRz4WVcqux8e2p+xxIWqJFIJkmn16KoyacvtYVP9C24AcsKWZ1rq5gCj/ME5+33PcQaqPcUH3+G4hiYEsiyWs4neQlUF9+Gd3mvVhdtl9Q3zdz+TfEe9vCGJZGpxaLgIG63fpobmiGKml0oi37xem2N5qWo45P2k9SFlMAxc0jAH/AEz05AfwnXv2Lys8lvkCDs6WkLzpuPJOidyDXbu2e+gy6Ess5xRC4sM0uKiEKEaDspvmzG0kWjredt9fRsgWzL7/XkjZ04sHGnPk4v8GZeUhrihANJbzXusgHeRLLtzLr0fLmCWv/Qmptbssc9SAwU0+dEJOO9avLyeytfLvvKM97TPCuniwHyR9oFCfkanjiAm0tZ3Gwt58vyv8tfrkTkZ1gMw2nqFztcTzuboxKy3OjWYwJz6TRs5aiyVaE2u1iVNZrTo+CYO4qiuSxYn7WKcF8lpnnE9Z583+So52Vt7LQmiU4/8vUZNYe07CRD+PFEJwIQEf3ATmaydw/zagtkfJGAvWnCWDihRKiZSFPk6ra8hM5YZbuNWiq1Sogp9DDlE+EjAMCEzWf1Xl3Nu/JT9QH+F5GRPhnNd5a3qf82F3/B3gJRspNl4utWbse7j6N/WZiW2FvHY+/h0SZqc5Qb0nhCoJ9409et+BMuT1KUyoDjICSflOqesOS0wHx55e5LLXcFUVwyKrwSQJJHk36O7RZm7gpN9qdy0rMYghU74GlchO8uJGsEIls8+8PwIDbVrtNrmwoYx
 SXbDiOFE
 OLbRce2d4+mDyOvizZCSzR6phMtUvzqfOXZaXniX3tKwh7DNEHfeh/pOQgQ8LSP+j9gHda9HbriH+n4hc2OXiaJi68JoM7Hr61cx/1OEa77OODwJ44UuSPrcW57dEB6WfcNT1le++Vpua4ZIHtf/54CBVeKfAGDN/hC5melnPfcU4S9ZWvOxdeV9E42QWqQn/ee9oba7lZ/6k6+Aeis+ME/rkivkkFw7kYj+U9ZOUu+/cDrnjx3vt7+813A+dH68FuY6WlZAMvvi8K8Xj4f0nG2aFfVH16hV9/QaStr2JayY4k7XhsHGq67Tkj7YhUBQfpHUv+XPrFtSdRaBYeNjeqVWiW2ebUP+i8r4Hi2jRHdDNWbD0lnDe6mo/79NoV/UEV7jOWE/e5n4sWVgVT7K57rCHIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 07:21:19PM +0800, hu.shengming@zte.com.cn wrote:
> Harry wrote:
> > call_rcu() disables IRQs with local_irq_save() to protect its per-cpu
> > data structures. Therefore, if IRQs are not disabled, they cannot be
> > corrupted by reentrance into call_rcu(). So fall back to the deferred
> > path only when !allow_spin && irqs_disabled().
> > 
> > The RCU subsystem does not guarantee this contractually, and this
> > optimization relies on RCU's implementation details. Ideally, it should
> > be removed once call_rcu_nolock() is supported by the RCU subsystem.
> > 
> > Link: https://lore.kernel.org/linux-mm/CAADnVQKRVD5ZSnEKbZZU7w86gHbGHUug2pvzpgZTngNS+fg4rw@mail.gmail.com
> > Suggested-by: Alexei Starovoitov <ast@kernel.org>
> > Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
> > ---
> >  mm/slub.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 2c5ba8c326e7..bb0f2975c95b 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -6157,8 +6157,12 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
> >      if (likely(rcu_sheaf->size < s->sheaf_capacity)) {
> >          rcu_sheaf = NULL;
> >      } else {
> > -        if (unlikely(!allow_spin)) {
> > -            /* call_rcu() cannot be called in an unknown context */
> > +        /*
> > +         * With !allow_spin, we might have interrupted call_rcu()'s
> > +         * IRQ-disabled critical section. If IRQs are not disabled,
> > +         * we know that's not the case.
> > +         */
> > +        if (unlikely(!allow_spin && irqs_disabled())) {
> 
> LGTM!
> Reviewed-by: Shengming Hu <hu.shengming@zte.com.cn>

Thanks a lot, Shengming!

> I initially wondered whether in_nmi() should also be checked here.
> However, irqs_disabled() already covers the relevant reentrancy case,
> since call_rcu() disables IRQs while modifying its per-CPU data.

Exactly, that was my reasoning ;)

As a side note there is an attempt to do this in call_rcu() instead of
slab:

https://lore.kernel.org/all/20260729162207.1567770-1-puranjay@kernel.org

Just FYI.

-- 
Cheers,
Harry / Hyeonggon

