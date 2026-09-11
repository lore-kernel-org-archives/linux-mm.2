Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82377C88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 19:13:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DABC6B0093; Fri, 11 Sep 2026 15:13:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B0216B009B; Fri, 11 Sep 2026 15:13:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C8216B009D; Fri, 11 Sep 2026 15:13:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6205A6B0093
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:13:33 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A4A02140314
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:13:32 +0000 (UTC)
X-FDA: 85202430264.17.9833A74
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 029C040006
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:13:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pnylu3mz;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789154011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UUc6Gtsn7yXkmQKX9aijNaPvANqPVntk6MiQlVr6hUM=;
	b=auS6dM8kGd1bys2RtQYGtSzI6ZoQmFLP8+bvKOIagk89yiMtvH/XeySIlLwY57ihDl7rc/
	OnaN7TymkszQA+f2r5hkkin2d+KXrkCE5eyFYXakT/5PoQHcZ9630zcvVjr354Rskwq33r
	m5AvqPjxsDhHCcRIprNV3r7nOa8UMV8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789154011;
	b=Cd0AclPmAuoABVM8iqwPu1QR3Y346B39ccPQza15chXjuwSXTGOOgQS4nQ3GTHcQtMqAuS
	ffLwAO1JEBdAk0oZItRbVmv52IV3IhD9bLsXAu+FpmDvdEPykd31cu97h/SsIDwvRkh6Q1
	K+A0EKS9lXnDeTCdQsu9btpRtM7I87Q=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pnylu3mz;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 93EE360008;
	Fri, 11 Sep 2026 19:13:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361641F000FF;
	Fri, 11 Sep 2026 19:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789154010;
	bh=UUc6Gtsn7yXkmQKX9aijNaPvANqPVntk6MiQlVr6hUM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Pnylu3mzOr6v1ZBz0wjTh19bCz/9DAK2vb4NwfQuFbaPLsPuE/dNY6et4CV0XsHRe
	 GYKfMyJ3lNi9W720j0ixURhcYU/SgZn9T3ABq0VBUyImLt+7Sk7oMSIMaRNzVZ20Ko
	 1zmfRHFaPAgn9EDzrEx0fBon2GcPxgBEBhyzJlOXHeLfE5WqGfQ7ECBlszVMwb3H6R
	 1lzYqveq7Cga1xrux17QswV4N8GydXPO6yMBM++y+j9pUj0+WpgC+rBhfdbhsxbyMo
	 fTjr25Ft6G6sSnsiSAKoNte7LAoQXCepQs8pJH4f/UOFF1o48Vi3AHfjeqFt/hLrXl
	 peowQiRKl+jng==
Date: Fri, 11 Sep 2026 20:13:24 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, xueyuan.chen21@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 5/7] proc/task_mmu: change proc_get_vma() to stop
 returning gate VMA at the end
Message-ID: <aqRSvISJtYrt5Gvp@gremlin>
References: <20260910234737.1340642-1-surenb@google.com>
 <20260910234737.1340642-6-surenb@google.com>
 <aqRF4YB7Ijk9PmRM@gremlin>
 <aqRPeZH4yeYXfWgS@gremlin>
 <CAJuCfpG-8sQjg2ECiRQpjn9tBj3AfEXnmgmomdfFGS7JoDhZ4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpG-8sQjg2ECiRQpjn9tBj3AfEXnmgmomdfFGS7JoDhZ4w@mail.gmail.com>
X-Stat-Signature: hwwd3sazxzciziqxo4z5fngu5u1u1dis
X-Rspam-User: 
X-Rspamd-Queue-Id: 029C040006
X-Rspamd-Server: rspam03
X-HE-Tag: 1789154010-999981
X-HE-Meta: U2FsdGVkX1/0RDqKNJda1NDVnDALI+Ypemd39s1N5mCM+b6nOczK8e1rdHcybxvFpIwDjfOH4WuBGuITxz3xRkpy0qi6w9vjy7wvhmKACcrTU7ysD4hiMuVw8gmgO0qOYHyPxRwNWk+IZhfDzib1OwhpC1ot3RPgYiOQt0307Xne68Am83trjsQ3ruMjxYakjR6H/oyk9atECH3Ks947CyPlaK3lc1v99b1MbhdMvi2u+9G7ZLjV5m1zB/9jiRSifDg31T5vxw16CL97sWxBbnY7/dXclKC+zr/gfrTknObKNUhbGHzb+I/I0RwIq2Qo+fcRXG142pQaSOn2uV7+z51a7BnUFd5lnQ+bRyiPqN9/eCi0qk0xkEI8Ywco0C+tNZMD8sFMQyuOuIstfQqA1y6UgSWd+JF8u9yVVx/0CW+YvYRCofCDUgguMeIN1SyP8JIZdeFIEJq6O0s+PIOuW58wP5S0t8wBrvTfG22lbtk/wquZIf9YxaBHs32SkeFxrRs78b/h1VIl7RFt9wdmzIhC1x9hBTuTSbQ4d72klf/R3SK4dPZupgGUvt+w1oktNFiVIdUdlaM/29laHBjyHcz29wgRO1DwpQDNXZXPb6blZJ6hWfn/5ewqlpecf121jWFzTFkjBe0MW0LHk/M0Sp4jwdN0KTiqAaZe6E2N2AoTRxb8EcHBc5xszCZIVLQL7b6Pt6Mc6uYf4XLluoq41z+FrPmeNUmjcNqSIqWEwqnh8Jhr42kA888YDQuY5P8/s64tcldM349AuyzuRpkHSZC0n5mwqUMr9b/T0Xt95Ukq+gU4NCqjjxcsKEWClFN5L/+dJjQQKluVeC1gsFYWlIjPon50X+ahNY2kArd0VMxLx7/7n/+7fx38nrHi+FC2hxcXYmgmC6gXP5ijV5QnipgFND3cahKSNFllZhPaU/eFOzqCgfDFMqx8aIaIV8By1n4XTB/nONQq3E8OK5r
 Jkq6aFWk
 PFWyu+iNHZ92tM0TmmC7GozbNIPo5qA88w3oJUuX7h3lZats63p3KD0mayfui2fqNom2b8SiRtLRGFSIWlUbdJcLpdoTRGsbFneiJIZVB0pD0NH3WMvGw58yJEsLAPVxduj9FvuIh/fD0JgzIDwymtHV1uiyAeJY8dvm0JtF481p4a/Zf5xz2f4LUpRP0rouGKqKPC+fTMtxarB2CO1Ly896xscKqygmLajaHsHbzrBFy1X7XaGU41PYFhaou/w9ssJLK+UuZHUqj4thkrv2+hjrI0uB+3JzObMezpF/CzxlC1OvURpAm+kRZOYe7C40quaM5cJlkexeplBK5pLwsnwoDT+s34N/OWTCTHU7gZZqjslwMXYJKTaJwcXezCZaDmJ4yqOKNQyWSBZpfaP2tZtOt2zrJqYoufkfALSgKO7lXZ/QTg/yiCl3pffVd7qDOePwh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 12:11:55PM -0700, Suren Baghdasaryan wrote:
> On Fri, Sep 11, 2026 at 12:03 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > On Fri, Sep 11, 2026 at 07:26:49PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > On Thu, Sep 10, 2026 at 04:47:35PM -0700, Suren Baghdasaryan wrote:
> > > > proc_get_vma() returning gate VMA at the end is desirable for the its
> > > > current m_start/m_next callers, as they need to report a gate VMA at the
> > > > end of the address space. This behavior is very specific to these callers
> > > > and makes proc_get_vma() hard to use for other purposes.
> > > >
> > > > Move this usage-specific behavior into the callers themselves so that
> > > > proc_get_vma() returns either a valid VMA, an error or a NULL when no
> > > > more VMAs are available. This makes it more generic, simpler and usable
> > > > in the later patches.
> > > >
> > > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > >
> > > Yes, very good change, thanks!
> > >
> > > Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > >
> > > > ---
> > > >  fs/proc/task_mmu.c | 23 ++++++++++++++++++-----
> > > >  1 file changed, 18 insertions(+), 5 deletions(-)
> > > >
> > > > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > > > index ecce7ce116cb..9a3c996c1d61 100644
> > > > --- a/fs/proc/task_mmu.c
> > > > +++ b/fs/proc/task_mmu.c
> > > > @@ -236,9 +236,6 @@ static struct vm_area_struct *proc_get_vma(struct seq_file *m, loff_t *ppos)
> > > >              * found the extended vma with the same vm_start.
> > > >              */
> > > >             *ppos = vma->vm_end;
> > > > -   } else {
> > > > -           *ppos = SENTINEL_VMA_GATE;
> > > > -           vma = get_gate_vma(priv->lock_ctx.mm);
> > >
> > > Yeah this is just so confusing as-was.
> > >
> > > >     }
> > > >
> > > >     return vma;
> > > > @@ -248,6 +245,7 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
> > > >  {
> > > >     struct proc_maps_private *priv = m->private;
> > > >     struct proc_maps_locking_ctx *lock_ctx;
> > > > +   struct vm_area_struct *vma;
> > > >     loff_t last_addr = *ppos;
> > > >     struct mm_struct *mm;
> > > >
> > > > @@ -280,16 +278,31 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
> > > >     if (last_addr == SENTINEL_VMA_GATE)
> > > >             return get_gate_vma(mm);
> > > >
> > > > -   return proc_get_vma(m, ppos);
> > > > +   vma = proc_get_vma(m, ppos);
> > > > +   if (vma)
> > > > +           return vma;
> > > > +
> > > > +   /* Return gate VMA at the end */
> > > > +   *ppos = SENTINEL_VMA_GATE;
> > > > +   return get_gate_vma(mm);
> > > >  }
> > > >
> > > >  static void *m_next(struct seq_file *m, void *v, loff_t *ppos)
> > > >  {
> > > > +   struct proc_maps_private *priv = m->private;
> > > > +   struct vm_area_struct *vma;
> > > > +
> > > >     if (*ppos == SENTINEL_VMA_GATE) {
> > > >             *ppos = SENTINEL_VMA_END;
> > > >             return NULL;
> > > >     }
> > > > -   return proc_get_vma(m, ppos);
> > > > +   vma = proc_get_vma(m, ppos);
> > > > +   if (vma)
> > > > +           return vma;
> > >
> > > OK so I guess the logic is, iterate through every VMA, then once you run out,
> > > report the gate VMA. Makes sense.
> >
> > Hmm one thing on this though - m_start() still has:
> >
> >         if (last_addr == SENTINEL_VMA_GATE)
> >                 return get_gate_vma(mm);
> >
> > As well as:
> >
> >         vma = proc_get_vma(m, ppos);
> >         if (vma)
> >                 return vma;
> >
> >         /* Return gate VMA at the end */
> >         *ppos = SENTINEL_VMA_GATE;
> >         return get_gate_vma(mm);
> >
> > Now at the end.
> >
> > Is this correct? Is it maybe duplicated now?
>
> Yeah, I noticed that too but I it's not duplication. The first check
> handles the case when right after m_next() hit the end of the address
> space and set *ppos = SENTINEL_VMA_GATE, we ran out of page space and
> had to flush its content. Once that's done, m_start will be called and
> last_addr will be set to SENTINEL_VMA_GATE. In that case we should
> return get_gate_vma() and avoid calling proc_get_vma(). That's what
> the first check for sentinel is doing. The second one handles the case
> when m_start() itself readches the end of the address space and has to
> return SENTINEL_VMA_GATE.
>
> It's possible this can be refactored a bit and made cleaner but I
> would keep that as a separate change.

Maybe just add a comment to the first one to explain when it'll trigger? That
should suffice, cleanups can be separate yes.

>
> >
> > >
> > > > +
> > > > +   /* Return gate VMA at the end */
> > > > +   *ppos = SENTINEL_VMA_GATE;
> > > > +   return get_gate_vma(priv->lock_ctx.mm);
> > > >  }
> > > >
> > > >  static void m_stop(struct seq_file *m, void *v)
> > > > --
> > > > 2.55.0.1007.g17ff1f9808-goog
> > > >
> > >
> > > --
> > > Cheers, Lorenzo
> >
> > --
> > Cheers, Lorenzo

--
Cheers, Lorenzo

