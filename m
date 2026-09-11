Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53B35C88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 19:12:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F3B06B0092; Fri, 11 Sep 2026 15:12:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CB0E6B0098; Fri, 11 Sep 2026 15:12:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BACD6B0099; Fri, 11 Sep 2026 15:12:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F136E6B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:12:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 328631A0357
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:12:11 +0000 (UTC)
X-FDA: 85202426862.09.4F2D73C
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf28.hostedemail.com (Postfix) with ESMTP id 43A8FC000D
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:12:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pRvk86cm;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of surenb@google.com designates 74.125.230.205 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pRvk86cm;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of surenb@google.com designates 74.125.230.205 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789153929;
	b=UOXstRxNz9iZ1dK8t70PKdwJrX226emp8KRT9v2ar0N2/ERcM+pHlF1BGOAJQWQIeLernF
	UH/Wh9FDp/T1AsxEd8OFOLWqozX8ccnQeg0eLHyT0VwLACL7gOK065LQiZwYdb30zZfqEo
	kwjl0PufJ1ximeh8iLBx24OVXaSywus=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789153929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=saJSQNQB4V5HEb80TKj8yYWIyI7Lc38n7nBGhE1SZ5s=;
	b=ARtl004v5K/FbEA/Ua5kztXuYwB4w37p/kqyantc3j926ZHKT+wa4nuA2dOMD9bYrf8mTX
	kOKgchsxz/UszjUvr6HBJantjlUcPE0hgBwsUevMv196+TiO/sGJD32yF8Vj7YpgszoPHR
	w0F3+7tZh7jQjGISTds4+Ieqekpndg0=
Received: by mail-qk2-f13.google.com with SMTP id d75a77b69052e-5306706e89dso101281cf.1
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:12:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789153928; cv=none;
        d=google.com; s=arc-20260327;
        b=dYe3FbyAmgSgMjXrgOh99sjTCzFWjsP4nEtsLH3QZd8cuFYDD9M4oFcdzUYXKYFdsO
         FfBMkg2zBEklxrvuUZgkTWsHBscOvqk6i9iPOnw87E/4kAJWjrdC11ISd/tHgr0LHt7J
         xQgaXs3bYvWVhRWCh2FeqpoCP8OZvBlguD6zlBNKa7veiM36t2PQ7K/LcTosH6GJIl0O
         VbqzPzPDgxGqwEUBpW7xA9f8VpsaegBW5DldioctJdGKhb+GECD2NXQwOKfbPrRKmEfV
         JrF4GYUvaRKbHtLZKtQLgwqGc3GxFU1+/sFyuNZRdG5PYbt5uRI6a8IaKhymG8q1M+IL
         8vjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=saJSQNQB4V5HEb80TKj8yYWIyI7Lc38n7nBGhE1SZ5s=;
        fh=rvaDqKwIUTDNo/4Lxr0vi89/2yjZcb3wHvLWDe9Y5HQ=;
        b=PenkUh7Mof5JmJYQ/c6Qd8hE6mmJ5v7PToqfo/uxdjs5QW2ZLH/yECiY1RUo+EsQ3I
         FC13apP+9TXFkJkjMXgNORrZkX11RrSj8BN4K2IkzhKczFrNdaCx7IiwidOQCmOVrhdl
         0tL67n9LaDbmG8i8Z2KGNCa+pwLlSjxW4J44RSwO23GZN1808uUR+VH1VuB3L/utCuwP
         6lyi8Y9sIaI+gl3uZjCWfdcDbHM2M6YraccL3RgR88ANjOsJuaXQRbeJjcWf8TDr5pJE
         2ZrVHUm1hMyF7LT4EtWjKzwUgjKPdciIs6o1QKYbhgn0xqWcbcS4Sm50SkSFYrIURljX
         bNgw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789153928; x=1789758728; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=saJSQNQB4V5HEb80TKj8yYWIyI7Lc38n7nBGhE1SZ5s=;
        b=pRvk86cmegX0//B+lqHlmVBsSBDGP7C9pPjDRoZMsLjwqM8O5ChpXz52tCOTL8898M
         AjjsYxYbRPaXb83WGvcZU+0jo469NxX4wCJThtdUVJ14PtQZg0hfGTl9cbrK3h/cMoAY
         8QtQqGSNAZTgPqhHPlc/jQ4i3rB6yMPaiqQ2KBwLYXHMTjWKNZQmMmhComGvKU5SuKf1
         K7WAOiZisiXZf5R8ztSChh1A8QzHcYSHZ7OKdSw3L7wrRTM9+IUbJIc3OjGoEBSmdaRp
         098ISYZ1opf/jNwJmmZS61Z8N70XxpmQrd/iq0duwRyORFym2MpWwtYfE3Nxs45cw9n2
         Myuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789153928; x=1789758728;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=saJSQNQB4V5HEb80TKj8yYWIyI7Lc38n7nBGhE1SZ5s=;
        b=rbMmPTozOaHRbZ0gTOCUH5y1rBLOFiIRk77HI2FODluE33WabSi65w9+XwhGx5XA6L
         DKWnULJ5JuVf8HQBItlY5is52APLNq/LAj/SPzKuEvmt9HloI0DGdKjJMP3FlaK4/v5b
         lLk8FcqENwDf8S3J6SOCQkg2GLbWD+j+SvbUhtRYVUt+0HCYw0U2QI7pRyvsux4pY3M6
         BfD0rm9Ku31iKD/QnAASmWGekaTiug9nl70GKrmUrNCJzwTUEgb27jhL++lM9p3WC0E1
         WG+uOrYdpiKOf5ofoWMfk25tQXziTeWg+4uGmK/VCuJt8aUSnlYOeklw0xYe6pBCUMHc
         coSg==
X-Forwarded-Encrypted: i=1; AKwUvBxF9sDoQRjB9CEgh2qNlYT0/jMExd+g0hbF1OK6N+0kIqLyZSGSE+bE1gGUkEDf01YrmXr6Mvmt2A==@kvack.org
X-Gm-Message-State: AFuF++kazUdwi3ofUtxlqWXFmJwZHLGMQ3apb1j56pzAcJiaf4TV2Vx3
	FrxQK+bMtwvpzO9j3U2C4U478QrcaM1V2fKTCxMyodPwvQmdPMHsiKoFktpwnkfuaQRx8QrOosS
	psMnMu2bectc45oIsr9jXYVJ+jXA14nJGHpTmZVXN
X-Gm-Gg: AYBFou15Pl4FgqMzyXVWi+hjlM11P6yzFYSs7zSUwJSAPQBsEe28hManH4epUVXzqub
	a21GZnZt+/s9DouSOCSYSE0AID0+J9DMuqPwXFlW9zCYbetzGF1UiGAE9GXhVS1PIutjqvSp70W
	S4F9kuSQGAmPe1HBbkVwi3YvLauJ19ZrYTcDmS5F/GwEk1JCegN05zLlkgGm2DawDqsVOmr6Z3f
	pyJ/h12lBIyYE34x9lZJLHbJfdH2bX+4VQn5qGhZDpcThceZru6s8aeDQugq0py1TcxkD9xhcBT
	ztw5v2QkKcRE3aQL54TWocxQFQ+rjxtDY4AqFtzwEOb7Eb34EDLBvxzxpn9FegdWdsPMrPEtSLE
	y9GdWSERvbQ==
X-Received: by 2002:a05:622a:4d94:b0:51b:ff0a:2048 with SMTP id
 d75a77b69052e-530e492ef32mr2365241cf.3.1789153927778; Fri, 11 Sep 2026
 12:12:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260910234737.1340642-1-surenb@google.com> <20260910234737.1340642-6-surenb@google.com>
 <aqRF4YB7Ijk9PmRM@gremlin> <aqRPeZH4yeYXfWgS@gremlin>
In-Reply-To: <aqRPeZH4yeYXfWgS@gremlin>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 11 Sep 2026 12:11:55 -0700
X-Gm-Features: AcwNN1Wy-CE4ovXulpkIU8FXd9kbfWYedpTSzKiPANojbqSxgWkXPeoHYX3MZto
Message-ID: <CAJuCfpG-8sQjg2ECiRQpjn9tBj3AfEXnmgmomdfFGS7JoDhZ4w@mail.gmail.com>
Subject: Re: [PATCH v3 5/7] proc/task_mmu: change proc_get_vma() to stop
 returning gate VMA at the end
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, xueyuan.chen21@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 43A8FC000D
X-Stat-Signature: uogzz58ikktd3sgwjqz7cc43yty4cgm6
X-Rspamd-Server: rspam01
X-HE-Tag: 1789153929-209395
X-HE-Meta: U2FsdGVkX1+6WPtWFQyIp0k57ARxmB71yvwj/NerAlSAKzDa2cjQSl3fZZyWUU6Rx8BVKjcJlr4Jtrje1enVwbVBhRRoMUtwB1E41iFUpW10e9uCVOCkLug8qxZgy3306dWIC8NFErZT00d23wfrR0eedgwZLZNiuqdkBEWjDQgBGIxONnzoZtbY0zvrrNxphU2dUP1a7T1Hf6T8SNAOooOpGrw5MSE/Tu/kBqDuDYdEkeS8qhd0J0NM11ikrP3Dz9045vsUM1tPlcpj+6fo+u6f/6wadEYRzYGfqdMKrdLNrZ+dhEHyVSB+l6jwwCAzfVhN+sHo4Zgbl4XlRNKJ/6UScc0rfr+ti7ZCHO1gkyydPIibl1JkcEbXUT4mT2A00/7UpCsYO54ZQ+OuTmWEDrjhAehqQTrkkNmSzXnta7A+GRi+B/8wXSEWuAAsA+oc8V95nNw8gxKdX68k/HAx56ZNteuvZ8LHbRnxFCn968qXjjSmyFJfaZmu3j65rVcmh0lWgs3qUwUcZsMZfmFjGsFUqh67koZ6r2bbfG8xo2Pi64XtjBBoHw0Q4WSUdAX8u7XDvPWCt4ZFw/jzTPEktr3sy+ts8qj257bygQHG6SusuDKqWRoHthEVHwUjKsY6b0abjGbghruD6z77bdUjtkrMpcGDVaRqGSQlgLmI2lWl0Irg38b6hEjKTNsUzDIYHlyVdnJI9mX18lVaZzHSBKzGM97f16YIg73sWh8bHSMDy//TqfoLn90vki6j+Bzsa00WS7Rytest5cLNeEXwVrIBdD0h0OyelBUTlNZPRH/x3SHauYbzDesfAcR+zGcTH1gKeROdfZkzqYeuRIdnfYGjBOBpy+rcHCLwkizbXpdlivkVv2MEIWOvwtjAm3kLuf+kMYEgP2mw5EMYi0n5VBbZNAKzEnafYWPl2sH+lzKE3D4NlEiIPRb77Xi183dTqIpIz+a/NHWnoArLp6S
 h5FSO3a3
 G21ycgMhdEoCYEquC9lQomrvYwDG5WxUtdxowneNUd6hl4G8B38WatqPvYekCWFnZfiRCVggJYMkafTQrId9C2J5PX1nO1vVl1vC1PawrSRIX23HvYVPZtLpYI8LDH3FByIAfnnAI48jRK9HdtX4pp91ThtkXRAyTbDpcaAQM3wA/duozhXe9KAsBQfZ/W996zzzCmmIAQmJWYrmoNc7XfrKiB2TtOfAptUNCGI1pPjKV9IHyZYUiLu8nzpVmG77YRDfwcATA9NnT1w/4V57BRm6jFKwG/4K4rfpN9pHk06AaBgWvzwKPC8fbFtf+GGkXWA9UCX/z07FYwjwN6ih3JUMBktYuP1mpIRdgmOYS/ONu5GRky+DxqWeILWein/vMTnmpKKEYCTSrracAk9ftMCKgPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 12:03=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.=
org> wrote:
>
> On Fri, Sep 11, 2026 at 07:26:49PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Thu, Sep 10, 2026 at 04:47:35PM -0700, Suren Baghdasaryan wrote:
> > > proc_get_vma() returning gate VMA at the end is desirable for the its
> > > current m_start/m_next callers, as they need to report a gate VMA at =
the
> > > end of the address space. This behavior is very specific to these cal=
lers
> > > and makes proc_get_vma() hard to use for other purposes.
> > >
> > > Move this usage-specific behavior into the callers themselves so that
> > > proc_get_vma() returns either a valid VMA, an error or a NULL when no
> > > more VMAs are available. This makes it more generic, simpler and usab=
le
> > > in the later patches.
> > >
> > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> >
> > Yes, very good change, thanks!
> >
> > Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >
> > > ---
> > >  fs/proc/task_mmu.c | 23 ++++++++++++++++++-----
> > >  1 file changed, 18 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > > index ecce7ce116cb..9a3c996c1d61 100644
> > > --- a/fs/proc/task_mmu.c
> > > +++ b/fs/proc/task_mmu.c
> > > @@ -236,9 +236,6 @@ static struct vm_area_struct *proc_get_vma(struct=
 seq_file *m, loff_t *ppos)
> > >              * found the extended vma with the same vm_start.
> > >              */
> > >             *ppos =3D vma->vm_end;
> > > -   } else {
> > > -           *ppos =3D SENTINEL_VMA_GATE;
> > > -           vma =3D get_gate_vma(priv->lock_ctx.mm);
> >
> > Yeah this is just so confusing as-was.
> >
> > >     }
> > >
> > >     return vma;
> > > @@ -248,6 +245,7 @@ static void *m_start(struct seq_file *m, loff_t *=
ppos)
> > >  {
> > >     struct proc_maps_private *priv =3D m->private;
> > >     struct proc_maps_locking_ctx *lock_ctx;
> > > +   struct vm_area_struct *vma;
> > >     loff_t last_addr =3D *ppos;
> > >     struct mm_struct *mm;
> > >
> > > @@ -280,16 +278,31 @@ static void *m_start(struct seq_file *m, loff_t=
 *ppos)
> > >     if (last_addr =3D=3D SENTINEL_VMA_GATE)
> > >             return get_gate_vma(mm);
> > >
> > > -   return proc_get_vma(m, ppos);
> > > +   vma =3D proc_get_vma(m, ppos);
> > > +   if (vma)
> > > +           return vma;
> > > +
> > > +   /* Return gate VMA at the end */
> > > +   *ppos =3D SENTINEL_VMA_GATE;
> > > +   return get_gate_vma(mm);
> > >  }
> > >
> > >  static void *m_next(struct seq_file *m, void *v, loff_t *ppos)
> > >  {
> > > +   struct proc_maps_private *priv =3D m->private;
> > > +   struct vm_area_struct *vma;
> > > +
> > >     if (*ppos =3D=3D SENTINEL_VMA_GATE) {
> > >             *ppos =3D SENTINEL_VMA_END;
> > >             return NULL;
> > >     }
> > > -   return proc_get_vma(m, ppos);
> > > +   vma =3D proc_get_vma(m, ppos);
> > > +   if (vma)
> > > +           return vma;
> >
> > OK so I guess the logic is, iterate through every VMA, then once you ru=
n out,
> > report the gate VMA. Makes sense.
>
> Hmm one thing on this though - m_start() still has:
>
>         if (last_addr =3D=3D SENTINEL_VMA_GATE)
>                 return get_gate_vma(mm);
>
> As well as:
>
>         vma =3D proc_get_vma(m, ppos);
>         if (vma)
>                 return vma;
>
>         /* Return gate VMA at the end */
>         *ppos =3D SENTINEL_VMA_GATE;
>         return get_gate_vma(mm);
>
> Now at the end.
>
> Is this correct? Is it maybe duplicated now?

Yeah, I noticed that too but I it's not duplication. The first check
handles the case when right after m_next() hit the end of the address
space and set *ppos =3D SENTINEL_VMA_GATE, we ran out of page space and
had to flush its content. Once that's done, m_start will be called and
last_addr will be set to SENTINEL_VMA_GATE. In that case we should
return get_gate_vma() and avoid calling proc_get_vma(). That's what
the first check for sentinel is doing. The second one handles the case
when m_start() itself readches the end of the address space and has to
return SENTINEL_VMA_GATE.

It's possible this can be refactored a bit and made cleaner but I
would keep that as a separate change.

>
> >
> > > +
> > > +   /* Return gate VMA at the end */
> > > +   *ppos =3D SENTINEL_VMA_GATE;
> > > +   return get_gate_vma(priv->lock_ctx.mm);
> > >  }
> > >
> > >  static void m_stop(struct seq_file *m, void *v)
> > > --
> > > 2.55.0.1007.g17ff1f9808-goog
> > >
> >
> > --
> > Cheers, Lorenzo
>
> --
> Cheers, Lorenzo

