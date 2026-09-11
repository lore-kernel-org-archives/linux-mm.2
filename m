Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66D76C88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 19:45:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F24B6B00B3; Fri, 11 Sep 2026 15:45:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C9496B00B4; Fri, 11 Sep 2026 15:45:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DF626B00B5; Fri, 11 Sep 2026 15:45:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3BA9F6B00B3
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:45:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 68437C034C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:45:24 +0000 (UTC)
X-FDA: 85202510568.27.989F14D
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5B31220004
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:45:22 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WvXlUeal;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of surenb@google.com designates 74.125.230.205 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789155922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pGrPjSb9GRO+ZgaFFa5EElvDumbPFInkcUYffxOe9sg=;
	b=X/Q2QdKcM11bBp47cdNFc2HviKIxlGXkNr8S1BfI7+WDF7rUB8p4pRVRzIxXLriB9YygaE
	QIehlTbzVG46xa8WN3ENwNizyWhxD5/6x4yJUnGmiSKVZt82kCt69u17zxlVbmQbkZYzex
	vDiSSbOjM/J+ollT9UIupqFmOroUF98=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789155922;
	b=n1Wm1LmcFj74CIMbwrCMtOVyrIJyOHnL4Ufd+EExyKIP5vHhNnyBleKu+gwJJ4iBB187PE
	1wnd4QXemrn5kegCW6lzcemHAy6d1Jd3h9AHdoh75eR6VZ5A3HzwetJTe8FN55OHcl9OfW
	7tJ8ZWegPqPekoT6PiRGcutLXpl5ePo=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WvXlUeal;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of surenb@google.com designates 74.125.230.205 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qk2-f13.google.com with SMTP id d75a77b69052e-530d5fc2cd8so102011cf.1
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:45:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789155921; cv=none;
        d=google.com; s=arc-20260327;
        b=Wc1/2dyeduOpRyiK2YrXOTZHfSdugjXizKh7HDfNsniNepCK36pWzSUYffV2XDJ3J7
         oyDNEdXUL8KWyk/1/BZJHkhqjYligLe/I6yypZhT1B08olyu2ps3tXFJDa/0N+Plx8Qh
         UnTe9Zahp4eE7DssFldu93Hk9hR+gLpMeegBKmULgNcmctASRp18iBCB2MnjPLPzv3PB
         rhMU3hRtj1afdqudsqHBUaLac8+bmyxe0MCoqAFssOEbb8zrcE4/JSy5ocmrkxXmJZyK
         u3lMg30qdL1QZjf/hPz8CRy60+2PzND1dYEdOcxtHzsw31mnpeZ/PIel1SwvWIhWVKUv
         9rQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pGrPjSb9GRO+ZgaFFa5EElvDumbPFInkcUYffxOe9sg=;
        fh=tx0+6ZOFmOeSu/TeKDITrgKfiEhbYiUOTL7wV49bcHs=;
        b=e0sdgP1D+0NO/jwV8Cx1/eQ8CAz6aoc0rxX3ANFIseQUKCiO9x4MZMedfp06CttYZm
         +sCgE5Xju6MLTEnmIGtPsFVP831b4ZxNYxc3Wh6hrD3OMKfjjfinSLqpgqUHUMnSIkXn
         8BuEUwVH3uhL+R9rO0/e7CwS9b6C7BKh4yyTHmeHf37hH+m70v9BJ4VfSMIDY9tRXNG3
         7tCY1AeHEOeyQGAUetRhol3wUFTus3qd7l62QONloJrBUB6ga2GaKq3guwlO/oEJVrA1
         FeWHN1Jb8wdEys99V6zr/9IfqFdhcKYc81z6JoO1Jc14FNBMcn72rgc9PHzHeR62flYJ
         n7cw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789155921; x=1789760721; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pGrPjSb9GRO+ZgaFFa5EElvDumbPFInkcUYffxOe9sg=;
        b=WvXlUealbWIZ+jhczR8/p/Hgeh1IrOVbz2Vt5GNTPDkNHtPdJACX2jeZSXts/pYQu7
         WqmgTcHaJzJYzuuA1w8nqz7PXZAWHUp0Ou0kjH94yHGQe45AZ9w3ZqXK2kunxImhN/5o
         pEo24puKGDmA2g07tBOf1mTpfycP6Q3VG5/nL9Sa21lqQIGx4KkwR81Wp4HyFlYat0i2
         d+7ux6c+dUXi97NjtNGi1EdTL/AWEXETCHZSDtHG33xj8o98jG13lj3wepjMpcFebZPe
         fbXju1bFHl3TqUtv5gFL7VK+dG0HnT9rK85O4u2oZKvgywxXzuUxLONKsAvD8BtXQZF2
         7YXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789155921; x=1789760721;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pGrPjSb9GRO+ZgaFFa5EElvDumbPFInkcUYffxOe9sg=;
        b=ODZjCXAaEVpBOC/NisnxwIQ2evZOtwxZpYEiLi1NYcIKSjAqCbycNtalPOu3XAfFuJ
         BLbYE90jYi2SI+T8Sf4OxNLT80xEyZW0qVdTpTq+T6LPZnr7Qpq7KQg4XJAGwTjoF5C5
         E2kDbAyvVoAyjx9vGyBvkckpZGPlWoVQtwC8O8dqqDBaRljJpfpJfV3x1G7UBtQACZdE
         u+IyzsfkmeVYCq4gaqmnsaZUPoF09V8FOaso5KynBX9/xEVhGQluqr2+9+hXvjI+S9Od
         t3s7bDivk0wl/4XeR5M9TGGGc4GE4e6Najt0SO7Sxmu+65yGgddNTX8IdqYAJtTZEfeR
         w/1w==
X-Forwarded-Encrypted: i=1; AKwUvBw6Ov0BJIbfMkiTMqMrgo6YA/W8cN8WgJkTDk/bsMtMn/DOyiOEArE2VuGyJnjZS430+UwbFCuf8g==@kvack.org
X-Gm-Message-State: AFuF++k4zMvfNz6SKjd3824Dgz7vbkqesmUhXAv+yQYoUc4MVfMIMc1F
	EtZIR9OrXSiqVhST7ZMj3tZh6l16Jxd4p//70czvT4YrFDOqBVXyWoFzywjjQxwqRJKY9Yqj+US
	CtPzMDR02InkembFaaNZcg7fu5+9GGWDuc2jY3Xtc
X-Gm-Gg: AYBFou0xnJ0GCYi74TdZbtRKzjaM4U/uD9n/5/ajB/ryVu36gls8AO6ciokydhEkA8z
	tw5EZi6A4hLwJHc5ZjjEfQ5/CQQWHQRPCljf5DNpNhAKeGYaQSLL3KSnvJPyRbSIEMFXIck6lVR
	fFviVJvIQ2iTdJJ4r7bGTl+I7nDJGvl8+bmrjLbczen/zguEEBfvrQNHdHX9x1uUm3WLghQuorh
	B7rP4h0YsRLyNUWW4nlpdA9ssmhNQ3porPtU4eRAyh1WXf17T7YASEkA+aBxLdLeXgyrl0ae2/8
	4jIU0xocoWzOX6Q34H6JMD/pWtSbayMEw/wNmx2HIqkNVUUuktCchnH4yBX245UxkZrhPwR6IGx
	F1Ac+siSyQQ==
X-Received: by 2002:a05:622a:87:b0:530:d9fc:253d with SMTP id
 d75a77b69052e-530e46521edmr2823151cf.6.1789155920731; Fri, 11 Sep 2026
 12:45:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260910234737.1340642-1-surenb@google.com> <20260910234737.1340642-6-surenb@google.com>
 <aqRF4YB7Ijk9PmRM@gremlin> <aqRPeZH4yeYXfWgS@gremlin> <CAJuCfpG-8sQjg2ECiRQpjn9tBj3AfEXnmgmomdfFGS7JoDhZ4w@mail.gmail.com>
 <aqRSvISJtYrt5Gvp@gremlin> <CAJuCfpGvB4o1HrKsi4zbzKNmdxppW_76xJUbaYeE+sN6w-u6UA@mail.gmail.com>
 <aqRVzecC23YpZeh0@gremlin> <CAJuCfpGOR5X6R2NwASMFwp=UtWCCDn64OJNEmzbMh9DDmn2d4Q@mail.gmail.com>
In-Reply-To: <CAJuCfpGOR5X6R2NwASMFwp=UtWCCDn64OJNEmzbMh9DDmn2d4Q@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 11 Sep 2026 12:45:09 -0700
X-Gm-Features: AcwNN1V3wd_DRFhQoDAVPV55rR1lWbHmfqoCJKHGvI1cpuMNSdgNmX8FA14BwPI
Message-ID: <CAJuCfpH0bDKabXqPRTQ0vHVeVwNZ9K2qgtwaJcCJD7v0ua-ZaQ@mail.gmail.com>
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
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5B31220004
X-Stat-Signature: at7mh4s7numdqfxex9muok13o3cnm7wt
X-HE-Tag: 1789155922-649115
X-HE-Meta: U2FsdGVkX1+7cQ4XExPll92O/0YsD9qEF+TGRTiZI2gDtoumPK5WlkLBRt8c0udXhPII8d/Q34APe6cr8o35IXFNEjZpCc+O0L3s125o4cPxbsohWhZo8AFARch6R0Zo4wpPxoRWasi8lJlWvn1Y6+bPUBDkE1NU3XI+yyULcQDhGEWtUT5bMsco3A9nX9wFrQp/OVTV8reiaslnvUtkXCt6Hqc0QVYsaFndPQQBeCd1R7OBSZ0bTPqopC8EmyHunDkMB/Kdoxir26SrclXPVLURyvdnnuY0kBnFj8nwa7XzXYGpnKNfjRfNn3WqB5VOzYa71NMhy+YLeRjss6j/HE02KrIzV5PZuS6g+mcJJWYsiRgCDWvf5+/e6C/NjvJCUE/TbM5Apph3wJlygMUDHiDPDzcTwY0IWW5r5JPp3Qn4sWjiQUEK4oUCfT1+TnRIZws4sSsfE/eg8eQrSaWN7Ak0PKgg5kaBd6zwa38HZhX1PXVJkDXiWApyZzYzm7kh/yDB+CSALgXUlt3OCdQbEagaFzVRbRLe+FMUvMq8V/pn3gwLLsjuoxXoJohjXHA75lwe/ZrY2klzWuATx2+S55XR5vr5t1RMvciePUErs6A4XkUBN4DAmG0msWe1MBReKqBxtIYsXiqEn42qgMPeAYDl3R2L5ueHvLqXxo3tlAT7Ja1rYLk4rVZqjWxN/gsOi6i4A909HYe9HS8bkmiUb1ODTlk8gUpMhHEpu47hNzH9FQmqX+snDg/qopmG49VG/mSyy5F7gLoCW1c4KU2k+MLN8lkM4oMHk1blP6mpHyOdj2clMp7Yi1xSihzr7S6vGWX+7L4X8bKzMRb1J6ud7hhPNBJQ1RCsemdHK9wCdU/QN7Emul0GquV9Erc28A7uHavEQl6XJg1T9yuNUA8cIOe50rXzx0D+SUWww/PW/G1CjK4yMzwYxxTMY33mpgKJfCuOLVLcPyhG5tExPDL
 JBKMAp5z
 u/NzpsKFzXWprmNSKbwrClZ8vs6Mka+MaSAKWkhzJU+Fjv9l1HTY3ZDpW+D2SXylORyzlSOKZz/ob+W5G1OK9Ty3aPXINQUclxnUFOswOUCzMr+RNIr+gEq0iQwXsUR5Rvo2Y17syLLW/429Jz1O3cdLz0dYwbjpe8lVrmvvSoeT6VNv2hhoNdD4E6+hBfq+/BGQUPQyemZh3W1Pz8tM0cQhHnfGr2FEZvg2VG/glXxrGkKG1uHFoIMPQ6KSA5hYhr3jqk45oE0SJMvbqMqH+gWdQHueVYRyVJ09SUUnQThOXBoD0LeEYFfnjw4uz2K4x9HCe/9jvTf9JHXkMwk8eSkhNw2PYpYecy+OpkdGJZM0sMhAK+rqz+HUeE1vCxYDUC5m/PO7yBivU81yqpQTrS885NA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 12:44=E2=80=AFPM Suren Baghdasaryan <surenb@google.=
com> wrote:
>
> On Fri, Sep 11, 2026 at 12:26=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kerne=
l.org> wrote:
> >
> > On Fri, Sep 11, 2026 at 12:18:41PM -0700, Suren Baghdasaryan wrote:
> > > On Fri, Sep 11, 2026 at 12:13=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@k=
ernel.org> wrote:
> > > >
> > > > On Fri, Sep 11, 2026 at 12:11:55PM -0700, Suren Baghdasaryan wrote:
> > > > > On Fri, Sep 11, 2026 at 12:03=E2=80=AFPM Lorenzo Stoakes (ARM) <l=
js@kernel.org> wrote:
> > > > > >
> > > > > > On Fri, Sep 11, 2026 at 07:26:49PM +0100, Lorenzo Stoakes (ARM)=
 wrote:
> > > > > > > On Thu, Sep 10, 2026 at 04:47:35PM -0700, Suren Baghdasaryan =
wrote:
> > > > > > > > proc_get_vma() returning gate VMA at the end is desirable f=
or the its
> > > > > > > > current m_start/m_next callers, as they need to report a ga=
te VMA at the
> > > > > > > > end of the address space. This behavior is very specific to=
 these callers
> > > > > > > > and makes proc_get_vma() hard to use for other purposes.
> > > > > > > >
> > > > > > > > Move this usage-specific behavior into the callers themselv=
es so that
> > > > > > > > proc_get_vma() returns either a valid VMA, an error or a NU=
LL when no
> > > > > > > > more VMAs are available. This makes it more generic, simple=
r and usable
> > > > > > > > in the later patches.
> > > > > > > >
> > > > > > > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > > > > >
> > > > > > > Yes, very good change, thanks!
> > > > > > >
> > > > > > > Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > > > > > >
> > > > > > > > ---
> > > > > > > >  fs/proc/task_mmu.c | 23 ++++++++++++++++++-----
> > > > > > > >  1 file changed, 18 insertions(+), 5 deletions(-)
> > > > > > > >
> > > > > > > > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > > > > > > > index ecce7ce116cb..9a3c996c1d61 100644
> > > > > > > > --- a/fs/proc/task_mmu.c
> > > > > > > > +++ b/fs/proc/task_mmu.c
> > > > > > > > @@ -236,9 +236,6 @@ static struct vm_area_struct *proc_get_=
vma(struct seq_file *m, loff_t *ppos)
> > > > > > > >              * found the extended vma with the same vm_star=
t.
> > > > > > > >              */
> > > > > > > >             *ppos =3D vma->vm_end;
> > > > > > > > -   } else {
> > > > > > > > -           *ppos =3D SENTINEL_VMA_GATE;
> > > > > > > > -           vma =3D get_gate_vma(priv->lock_ctx.mm);
> > > > > > >
> > > > > > > Yeah this is just so confusing as-was.
> > > > > > >
> > > > > > > >     }
> > > > > > > >
> > > > > > > >     return vma;
> > > > > > > > @@ -248,6 +245,7 @@ static void *m_start(struct seq_file *m=
, loff_t *ppos)
> > > > > > > >  {
> > > > > > > >     struct proc_maps_private *priv =3D m->private;
> > > > > > > >     struct proc_maps_locking_ctx *lock_ctx;
> > > > > > > > +   struct vm_area_struct *vma;
> > > > > > > >     loff_t last_addr =3D *ppos;
> > > > > > > >     struct mm_struct *mm;
> > > > > > > >
> > > > > > > > @@ -280,16 +278,31 @@ static void *m_start(struct seq_file =
*m, loff_t *ppos)
> > > > > > > >     if (last_addr =3D=3D SENTINEL_VMA_GATE)
> > > > > > > >             return get_gate_vma(mm);
> > > > > > > >
> > > > > > > > -   return proc_get_vma(m, ppos);
> > > > > > > > +   vma =3D proc_get_vma(m, ppos);
> > > > > > > > +   if (vma)
> > > > > > > > +           return vma;
> > > > > > > > +
> > > > > > > > +   /* Return gate VMA at the end */
> > > > > > > > +   *ppos =3D SENTINEL_VMA_GATE;
> > > > > > > > +   return get_gate_vma(mm);
> > > > > > > >  }
> > > > > > > >
> > > > > > > >  static void *m_next(struct seq_file *m, void *v, loff_t *p=
pos)
> > > > > > > >  {
> > > > > > > > +   struct proc_maps_private *priv =3D m->private;
> > > > > > > > +   struct vm_area_struct *vma;
> > > > > > > > +
> > > > > > > >     if (*ppos =3D=3D SENTINEL_VMA_GATE) {
> > > > > > > >             *ppos =3D SENTINEL_VMA_END;
> > > > > > > >             return NULL;
> > > > > > > >     }
> > > > > > > > -   return proc_get_vma(m, ppos);
> > > > > > > > +   vma =3D proc_get_vma(m, ppos);
> > > > > > > > +   if (vma)
> > > > > > > > +           return vma;
> > > > > > >
> > > > > > > OK so I guess the logic is, iterate through every VMA, then o=
nce you run out,
> > > > > > > report the gate VMA. Makes sense.
> > > > > >
> > > > > > Hmm one thing on this though - m_start() still has:
> > > > > >
> > > > > >         if (last_addr =3D=3D SENTINEL_VMA_GATE)
> > > > > >                 return get_gate_vma(mm);
> > > > > >
> > > > > > As well as:
> > > > > >
> > > > > >         vma =3D proc_get_vma(m, ppos);
> > > > > >         if (vma)
> > > > > >                 return vma;
> > > > > >
> > > > > >         /* Return gate VMA at the end */
> > > > > >         *ppos =3D SENTINEL_VMA_GATE;
> > > > > >         return get_gate_vma(mm);
> > > > > >
> > > > > > Now at the end.
> > > > > >
> > > > > > Is this correct? Is it maybe duplicated now?
> > > > >
> > > > > Yeah, I noticed that too but I it's not duplication. The first ch=
eck
> > > > > handles the case when right after m_next() hit the end of the add=
ress
> > > > > space and set *ppos =3D SENTINEL_VMA_GATE, we ran out of page spa=
ce and
> > > > > had to flush its content. Once that's done, m_start will be calle=
d and
> > > > > last_addr will be set to SENTINEL_VMA_GATE. In that case we shoul=
d
> > > > > return get_gate_vma() and avoid calling proc_get_vma(). That's wh=
at
> > > > > the first check for sentinel is doing. The second one handles the=
 case
> > > > > when m_start() itself readches the end of the address space and h=
as to
> > > > > return SENTINEL_VMA_GATE.
> > > > >
> > > > > It's possible this can be refactored a bit and made cleaner but I
> > > > > would keep that as a separate change.
> > > >
> > > > Maybe just add a comment to the first one to explain when it'll tri=
gger? That
> > > > should suffice, cleanups can be separate yes.
> > >
> > > Will do. Appreciate the reviews!
> > >
> > > I'll post the update today because there is some urgency to backport
> > > these patches and I want to have a public link when backporting but I
> > > don't expect anyone to burn the midnight oil to review the final
> > > version. Have a nice weekend!
> >
> > Well you have tags on most things from me now so it'll only be one patc=
h I
> > think? That'll be missing mine anyway.
>
> Yep, thanks!
>
> Posted v4 at https://lore.kernel.org/all/20260911194145.1781926-1-surenb@=
google.com/
> and the only patch missing your stamp is
> https://lore.kernel.org/all/20260911194145.1781926-4-surenb@google.com/

Oh, and this one:
https://lore.kernel.org/all/20260911194145.1781926-5-surenb@google.com/

These were kinda related.

>
> >
> > >
> > > >
> > > > >
> > > > > >
> > > > > > >
> > > > > > > > +
> > > > > > > > +   /* Return gate VMA at the end */
> > > > > > > > +   *ppos =3D SENTINEL_VMA_GATE;
> > > > > > > > +   return get_gate_vma(priv->lock_ctx.mm);
> > > > > > > >  }
> > > > > > > >
> > > > > > > >  static void m_stop(struct seq_file *m, void *v)
> > > > > > > > --
> > > > > > > > 2.55.0.1007.g17ff1f9808-goog
> > > > > > > >
> > > > > > >
> > > > > > > --
> > > > > > > Cheers, Lorenzo
> > > > > >
> > > > > > --
> > > > > > Cheers, Lorenzo
> > > >
> > > > --
> > > > Cheers, Lorenzo
> >
> > --
> > Cheers, Lorenzo

