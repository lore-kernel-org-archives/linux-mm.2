Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BBB6C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 19:27:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E66216B0092; Fri, 11 Sep 2026 15:27:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0F836B0093; Fri, 11 Sep 2026 15:27:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFD706B0095; Fri, 11 Sep 2026 15:27:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AF1EC6B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:27:01 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D8E13A484D
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:27:00 +0000 (UTC)
X-FDA: 85202464200.23.9F2951D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2BDC440004
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:26:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JMsyThF+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789154819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b0O4uX2KxGpU0xHP/fkirBcUw3lYbB//1G421bBqPZ0=;
	b=s7beSs+O2KqHmM8caTPyKrTmgTu0u2H0hRcoyFISIfTM4cSFh9Mn0BGz3osfKNjo46JesE
	PDSkkXLTJAzK767bn6cHUP4j9Fpwfs2SnHEwwCb5lb3RzB1Ice3v9w4IULQkR6z3amSgbO
	d1UVsLzUK/SPOYUMG7JgBuRgD1+9HDA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789154819;
	b=07GHhN/ZV0UD+G4Gl9mnlG8MkEY/IDH+X5JowDrvrZOItSBOA3gxu76zMl2BdeNxcsIrU3
	RPCY+UHeetBttmCbfuAogyhEUymA8n9OBRh57xXFlO3lFwUdlVo42QgjaRla0yklk2EFmJ
	gcMhqEmGRawtGQp7Jc6r3XNWT+wMw7o=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JMsyThF+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 42E50439D8;
	Fri, 11 Sep 2026 19:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 164BD1F000FF;
	Fri, 11 Sep 2026 19:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789154818;
	bh=b0O4uX2KxGpU0xHP/fkirBcUw3lYbB//1G421bBqPZ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JMsyThF+eFING3jywDW0rCma9gBDFSSk9za7CH91vogQleXQjw0OVhjzTcvJtUlpq
	 Ro01gdMnSouNoCkjH/sI1zR5/UG8e/bodteawGjp5FGv2zR7905Po83AAEZE72tS9A
	 z2EKdi0NWqdrj+9MIDgM9rPgD1MisZ0DQKzWYyBrSb0EtChz3sfBlEo8uwZCKiiz7Q
	 kbNRycbizvQc4D/+xWVrcrpLXolXYmuooi/e7vvg8CxL0+gvtrw8I0b2K6LIBU6aXw
	 IZy+IN1zGvMgMNP+UJgc1sv4BED3yUlNrPNUdom3Qyr/mm/5kr9QBo/dBu89An5or6
	 wIra8LV56l1og==
Date: Fri, 11 Sep 2026 20:26:52 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, xueyuan.chen21@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 5/7] proc/task_mmu: change proc_get_vma() to stop
 returning gate VMA at the end
Message-ID: <aqRVzecC23YpZeh0@gremlin>
References: <20260910234737.1340642-1-surenb@google.com>
 <20260910234737.1340642-6-surenb@google.com>
 <aqRF4YB7Ijk9PmRM@gremlin>
 <aqRPeZH4yeYXfWgS@gremlin>
 <CAJuCfpG-8sQjg2ECiRQpjn9tBj3AfEXnmgmomdfFGS7JoDhZ4w@mail.gmail.com>
 <aqRSvISJtYrt5Gvp@gremlin>
 <CAJuCfpGvB4o1HrKsi4zbzKNmdxppW_76xJUbaYeE+sN6w-u6UA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpGvB4o1HrKsi4zbzKNmdxppW_76xJUbaYeE+sN6w-u6UA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2BDC440004
X-Stat-Signature: m5o7k13c39ou9kgqy97dawh4qo143ftp
X-HE-Tag: 1789154819-655472
X-HE-Meta: U2FsdGVkX1//gzqwxbZ0BVta6J8HDIX9NZlVrhpOWdpca8ECoqK7olihmIjo9uBQto+R9EVn27DRX05kYaTBFt+Wkwuvy51WUhxwjSVZljVl9sf77naYPaAeh9hDWdHzZOjs8bZZEIC6VuavvEgkwdxsj9cs6dgudF+dri5Lv72nuWiT0y8EEWvXhShsUh0sy2wkfU9T5Koo91C4O+jdt7lw6iHwrsJBmjVKnGnHwHWYEpJD5vLJ88XUQ1d5u5M0cFXXIQV4KCVa6PXgKIq3aQf+HQ2PpIcDzC4wqitcnOB7VBpsLZOW4IRl+k6MeQLNAUN//81m0UBH2xP4OUcEWyy54GFaydzKvBV4wPRXO5KFnv7M/SD516Pa8YGT+6OkunQVVO0XUsYH03pVsGzqiRRxPuhhLqfSoexy9tiMCbS5L+FEUWfhJuQfFjiirbwXxPx8syPXrXs1xxcu+KYnhIBDzq6xSxUtZMQtHdhXyrxt/7IgYuMOD/lteAx/iH1cX+K+LwMB/nLHGntbeCybLRwIzpdCXBPLHf/E68VKfw/QImaO3G64oAeP4Hg39M0YhsKHiJ9KemSm9v7SPauEowMQzzUBIEh9eOrjpGvdpujKmaZV327oYeSvKD0p3qRAG9olhxiU8mrNDqrghrmJyQTi8z8htirrVDVnG/fjzlO5BievNUY+f7TRC4DXAKC8VByMrPC9Z1dMg1q0h0jw3Agro+FRB/XJYpgcHJWeZ/DZluu71n5MSosO80h5326beF7qmuSi6LmXqPg2SyOvb9aX4QGzhBeUCloN1ZJoBWWzE7OC4qC55rmIQeRZw0jnilsA3QYAuyp9kzI0cIv/YX83yToYauybEg/X29fs5Snv3GbmmsGe3AuUy0QcSycNURkaf1Dohv7jlt1JZcRaal2I0gTYsl6EFMcMxu4RdQvApQmyojtM5dEpyCpF6f0Ji6N8+vSheComtqXjrpU
 a3EncbiZ
 vzvdytdjm2D7xj9hex/sDYT9mocQ3PxTkIvym4lLZWilTV7hTYpLKWrsmdWFe82SzY6jjwHu1MUJVCTMXUsS0S0lM5oBIEoieuAcOehz0qhAvKvWoxB6m2jL7oa33Drz4HkwQidfk3+qTcEDPdom+VbTUXABft5CLG2SEHeJnfSTj5JA828JUp+92slQSOr9tvRS5MCbzVTV1KyPaSFP9l0MX0Ua0iCxewnXXzdVlT9H45dUmJqXbKgYp7WuShQ8AVjys3x3ZgAcP+FmlslM1Q81R69DPhdJsSN9jEPKqfw6j9Mj/0jE4ADXLILqy7tH/U50REY2s+bw2S/owgWY4jNsR7gezDrJlZElhcv3+daZiIn3GSwICjyUvpPQT52e9LLCvFisCjVk6qaI7JrSnHrBDns8C+Iocn0sZUPrqKsVf0uHSGUYkOAN2xG2BuAX5vHX4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 12:18:41PM -0700, Suren Baghdasaryan wrote:
> On Fri, Sep 11, 2026 at 12:13 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > On Fri, Sep 11, 2026 at 12:11:55PM -0700, Suren Baghdasaryan wrote:
> > > On Fri, Sep 11, 2026 at 12:03 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> > > >
> > > > On Fri, Sep 11, 2026 at 07:26:49PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > > > On Thu, Sep 10, 2026 at 04:47:35PM -0700, Suren Baghdasaryan wrote:
> > > > > > proc_get_vma() returning gate VMA at the end is desirable for the its
> > > > > > current m_start/m_next callers, as they need to report a gate VMA at the
> > > > > > end of the address space. This behavior is very specific to these callers
> > > > > > and makes proc_get_vma() hard to use for other purposes.
> > > > > >
> > > > > > Move this usage-specific behavior into the callers themselves so that
> > > > > > proc_get_vma() returns either a valid VMA, an error or a NULL when no
> > > > > > more VMAs are available. This makes it more generic, simpler and usable
> > > > > > in the later patches.
> > > > > >
> > > > > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > > >
> > > > > Yes, very good change, thanks!
> > > > >
> > > > > Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > > > >
> > > > > > ---
> > > > > >  fs/proc/task_mmu.c | 23 ++++++++++++++++++-----
> > > > > >  1 file changed, 18 insertions(+), 5 deletions(-)
> > > > > >
> > > > > > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > > > > > index ecce7ce116cb..9a3c996c1d61 100644
> > > > > > --- a/fs/proc/task_mmu.c
> > > > > > +++ b/fs/proc/task_mmu.c
> > > > > > @@ -236,9 +236,6 @@ static struct vm_area_struct *proc_get_vma(struct seq_file *m, loff_t *ppos)
> > > > > >              * found the extended vma with the same vm_start.
> > > > > >              */
> > > > > >             *ppos = vma->vm_end;
> > > > > > -   } else {
> > > > > > -           *ppos = SENTINEL_VMA_GATE;
> > > > > > -           vma = get_gate_vma(priv->lock_ctx.mm);
> > > > >
> > > > > Yeah this is just so confusing as-was.
> > > > >
> > > > > >     }
> > > > > >
> > > > > >     return vma;
> > > > > > @@ -248,6 +245,7 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
> > > > > >  {
> > > > > >     struct proc_maps_private *priv = m->private;
> > > > > >     struct proc_maps_locking_ctx *lock_ctx;
> > > > > > +   struct vm_area_struct *vma;
> > > > > >     loff_t last_addr = *ppos;
> > > > > >     struct mm_struct *mm;
> > > > > >
> > > > > > @@ -280,16 +278,31 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
> > > > > >     if (last_addr == SENTINEL_VMA_GATE)
> > > > > >             return get_gate_vma(mm);
> > > > > >
> > > > > > -   return proc_get_vma(m, ppos);
> > > > > > +   vma = proc_get_vma(m, ppos);
> > > > > > +   if (vma)
> > > > > > +           return vma;
> > > > > > +
> > > > > > +   /* Return gate VMA at the end */
> > > > > > +   *ppos = SENTINEL_VMA_GATE;
> > > > > > +   return get_gate_vma(mm);
> > > > > >  }
> > > > > >
> > > > > >  static void *m_next(struct seq_file *m, void *v, loff_t *ppos)
> > > > > >  {
> > > > > > +   struct proc_maps_private *priv = m->private;
> > > > > > +   struct vm_area_struct *vma;
> > > > > > +
> > > > > >     if (*ppos == SENTINEL_VMA_GATE) {
> > > > > >             *ppos = SENTINEL_VMA_END;
> > > > > >             return NULL;
> > > > > >     }
> > > > > > -   return proc_get_vma(m, ppos);
> > > > > > +   vma = proc_get_vma(m, ppos);
> > > > > > +   if (vma)
> > > > > > +           return vma;
> > > > >
> > > > > OK so I guess the logic is, iterate through every VMA, then once you run out,
> > > > > report the gate VMA. Makes sense.
> > > >
> > > > Hmm one thing on this though - m_start() still has:
> > > >
> > > >         if (last_addr == SENTINEL_VMA_GATE)
> > > >                 return get_gate_vma(mm);
> > > >
> > > > As well as:
> > > >
> > > >         vma = proc_get_vma(m, ppos);
> > > >         if (vma)
> > > >                 return vma;
> > > >
> > > >         /* Return gate VMA at the end */
> > > >         *ppos = SENTINEL_VMA_GATE;
> > > >         return get_gate_vma(mm);
> > > >
> > > > Now at the end.
> > > >
> > > > Is this correct? Is it maybe duplicated now?
> > >
> > > Yeah, I noticed that too but I it's not duplication. The first check
> > > handles the case when right after m_next() hit the end of the address
> > > space and set *ppos = SENTINEL_VMA_GATE, we ran out of page space and
> > > had to flush its content. Once that's done, m_start will be called and
> > > last_addr will be set to SENTINEL_VMA_GATE. In that case we should
> > > return get_gate_vma() and avoid calling proc_get_vma(). That's what
> > > the first check for sentinel is doing. The second one handles the case
> > > when m_start() itself readches the end of the address space and has to
> > > return SENTINEL_VMA_GATE.
> > >
> > > It's possible this can be refactored a bit and made cleaner but I
> > > would keep that as a separate change.
> >
> > Maybe just add a comment to the first one to explain when it'll trigger? That
> > should suffice, cleanups can be separate yes.
>
> Will do. Appreciate the reviews!
>
> I'll post the update today because there is some urgency to backport
> these patches and I want to have a public link when backporting but I
> don't expect anyone to burn the midnight oil to review the final
> version. Have a nice weekend!

Well you have tags on most things from me now so it'll only be one patch I
think? That'll be missing mine anyway.

>
> >
> > >
> > > >
> > > > >
> > > > > > +
> > > > > > +   /* Return gate VMA at the end */
> > > > > > +   *ppos = SENTINEL_VMA_GATE;
> > > > > > +   return get_gate_vma(priv->lock_ctx.mm);
> > > > > >  }
> > > > > >
> > > > > >  static void m_stop(struct seq_file *m, void *v)
> > > > > > --
> > > > > > 2.55.0.1007.g17ff1f9808-goog
> > > > > >
> > > > >
> > > > > --
> > > > > Cheers, Lorenzo
> > > >
> > > > --
> > > > Cheers, Lorenzo
> >
> > --
> > Cheers, Lorenzo

--
Cheers, Lorenzo

