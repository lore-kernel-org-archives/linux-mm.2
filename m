Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95A9DFF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 14:49:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A3196B008C; Mon, 27 Apr 2026 10:49:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 053746B0092; Mon, 27 Apr 2026 10:49:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5DEE6B0093; Mon, 27 Apr 2026 10:49:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D02E06B008C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:49:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D5C561C10DC
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:46:09 +0000 (UTC)
X-FDA: 84704610900.13.2513FC1
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8AFAC80003
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:46:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HvD8NVmW;
	spf=pass (imf02.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777301167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iY7rfihtjlRuTjfO46wdna0FPFvKE5ldiB/zsCx9cHg=;
	b=C0V4EPu4WChMM/bOtEgSOUKDcWpvSvJljxogLc9rmQLmdcrIYOpJYNsbrWceVEu98QmWhd
	O1T+TRiC5Ao+tbRr/4Mgqdq5o61JdJWWyT7WS6DtQEcEzt5IuAkBSPcMTW6L7SmzK4ChjO
	EuTylvHq+VX9dyZ8tNBul8y2c6go4/I=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777301167; a=rsa-sha256;
	cv=pass;
	b=EMLmfe2cBKmkosVL9ZE61+EnEDNk3cLBov0CvGSllPQVlM5+CLQjudFChbD63LXghosilt
	YxOe62DmKH+PWT2I5b1N0hO7/MCSqAXHrj16IfphYl8cGZqzjoqr1HwJjHKbQOuWTnCRMp
	O2LRkquw5R9/KEM5fZ7yTgNKFeDfXOY=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HvD8NVmW;
	spf=pass (imf02.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4891e86fabeso113634495e9.1
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:46:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777301165; cv=none;
        d=google.com; s=arc-20240605;
        b=CVHKpL3LfCdASFghLpAd7MUXIwQjJFhADk+vU1vzYTu0LI5wor0ymNOx3Klbt5NtUZ
         NCaBryiUr6wIBnlNUF8ISdzM/0inDoNN/H49ZXlYfG6U6kPPQxk9wAPIfFiixQKEaybz
         SrYxPjtSfa1DSU8K6x3I+mYuyNhqRflfuCiMkGDJSD6mnGwa4f7eg4yf0jmnE1QaiTKV
         FrIcprgKFBRhNeFJXX0JgRpGVu5257PmxyNjaRdMFrti9ppn9G7RBDFY6wqpLdYMGbIY
         LVBXDBXKuzHCbqMDsbfPeUQPlWHJq19m8NCIfYWWg0A/Ci8Z2n5JGrKM4lex5Hx/dUug
         ISEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iY7rfihtjlRuTjfO46wdna0FPFvKE5ldiB/zsCx9cHg=;
        fh=f2ySA+CzmXDFW6/KB8gRZ3axRAJKCw+VaIxcsA+jTHs=;
        b=QhGjaEtIs4FhCVze11zKght5YC88bxoMYnI1NmP9lDMZz3dRrjpag+amtltSHVL55y
         H70b2o5kJdUG6mMr4jTS45xq0mPNqweiGpqakn0+O9Y6kk8WjR7/E0L+BEwROLRJI+68
         J626iZ3BCi3piR/WxfWX8QDViRRUqGbUPNsXC0EJyBEyduryRK2UVW2XRWOWWTKnX2sa
         XM0PCOb/uQL2dqS8H2wdAp3Wvw8ON1kjQH0+FgTu7aeKWzzvVxr1WORJ2Qg+KkQ5tR2g
         by1OsK/NGbLN03JxMbGUmSM7N9oMl7S7Y7rLV14qpn6X/n9gAc/Wuvi8DzMJNedISfG6
         5tEA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777301165; x=1777905965; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iY7rfihtjlRuTjfO46wdna0FPFvKE5ldiB/zsCx9cHg=;
        b=HvD8NVmWhjNlzm9nvk1BEc8twJXGikJPD21cTo1f3v4PBsTBidqhACLANKWbuszeIw
         oR4pv21DkoESzNFJHxgeEZxUB6pz3BUP0JGVZsV8SWjF8I2/L8tVHOcufqZxsxB0TRDM
         TMCLxgwoicSp/4lxEdN+ViBATYc+iUlj1/FYCvLyQgzBmwBa4RwkUEu449/YBYdo6JrR
         +FlywmIpa1IauUEKvdCx7vdMhaL15ftX0I1gd9iaLgQGwDRPB+KfMNiiAl19Gs80I7np
         VS5KlPNLAaa0rT5BLV6S8KYPEqn5vKj9xXxuySxpmSKWZyOsD4hHJaVtWOpF/5HWa7yE
         r0Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777301165; x=1777905965;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iY7rfihtjlRuTjfO46wdna0FPFvKE5ldiB/zsCx9cHg=;
        b=J1Yqu+bEFd7QrjxRxl0hOobhlahrdISI727O2Slq7+eRbNrbYggAswjiFbHy0mAT52
         +F4uE5FQxxjbw4HayOEKYbjig3xpi3C9eMZ6/va9uS15wT7NGI9qEeWT9DHHmKrnNUfH
         VHk1uCfezrfE8GaEx0SLjMeDHSiW4kz9F1ggB5HFTaftWeDFtyG67fWBctr8gwMgYJY2
         q1X6dw6illPQTxlgbTDpnW8566btAr5teVFz5meIotnbu0hiAWO/WTMCmKYRTwo472f9
         jmZlwFZ/i5zVegBbBf1+omJzYsQq9tpGcBTucFvHedF02v5BFav1PoqL71L+dUpgdY65
         lj+Q==
X-Forwarded-Encrypted: i=1; AFNElJ/uC1bbvUVZsevXYy9rB8UEwGc7DFZj5Am9rHZCzKqAEmT6o/qmNNS2hIPESFaV2g0Ub0HCUCVxig==@kvack.org
X-Gm-Message-State: AOJu0YzSnNbQKa01Tv1bNqhCTZEpTj77EdH8XmLSi4qq/6LhZ+FAj8+h
	0SpGPfsnoUYDbU2lHTN973AOTcy9i3i78ERqftWg+SHKgA7JHGCqY1kPdQZFopLKiFu17XCdAI6
	1+CBAS9fC+tbPQgt4meadEeD5HAUrcQ4=
X-Gm-Gg: AeBDieuOQLr51uamxn38QCGSu7oOr8tXcOLZcZdY2ecjaPmRe0m+n1tg15QNYU+oWGZ
	QCRdS/AFRYSRp30EmwS6zn3yFBIitvAaPOxrjjehCa1kNilT4dV9seWlVpfIOXeGqpaSmdvKheY
	wFe6J7/C53Qp9G8U9SpQVytRs+MHWPZlnqGDP9GxdJr/q7GbwVmlKukStjzUYgeaSk2ir6aE6Hg
	YKCnLcit2muogp6RVURAC5li5exIalnlX7+SUONAa6HTuOmXjX3NsD6Cn/o7rXTAJLRQuvJjuef
	3F8gRdGYLwIz8jnycr0N3o8pyw2sWU34aaXylN0MN/UwHWt0lm/tGywUDyy16HmJ6mpGVuDoAHl
	o3y4=
X-Received: by 2002:a05:600c:c10e:b0:488:8185:e672 with SMTP id
 5b1f17b1804b1-488fb792e84mr495623225e9.30.1777301165238; Mon, 27 Apr 2026
 07:46:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260416091022.36823-1-harry@kernel.org> <20260416091022.36823-6-harry@kernel.org>
 <56381493-214b-406d-9121-f80be7658445@kernel.org> <7101d55e-ba43-4df9-a345-2af579f8e940@kernel.org>
In-Reply-To: <7101d55e-ba43-4df9-a345-2af579f8e940@kernel.org>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Mon, 27 Apr 2026 15:45:53 +0100
X-Gm-Features: AVHnY4Lx1d3_T5YLZckb2mOZ8lMlfGDMDVMHWOLrPRoWbJYjm0i7T0hWMsHHk3Y
Message-ID: <CAADnVQL6iajm6L+VzqRB4b-u8OPhQSnUASnfciKGeRR4EDOutA@mail.gmail.com>
Subject: Re: [PATCH 5/8] mm/slab: make kfree_rcu_nolock() work with sheaves
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Alexei Starovoitov <ast@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
	"Paul E . McKenney" <paulmck@kernel.org>, Frederic Weisbecker <frederic@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>, Zqiang <qiang.zhang@linux.dev>, 
	Steven Rostedt <rostedt@goodmis.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, rcu@vger.kernel.org, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8AFAC80003
X-Stat-Signature: ijiystcg8u5yq35g7r3g5khbhce97twf
X-Rspam-User: 
X-HE-Tag: 1777301167-838988
X-HE-Meta: U2FsdGVkX1+RgkJfgrnuuK2cUuemCEzEGsxiAw63C5JdBqan523cgWZgZLrHEPy6oGIzyggX8aHklzzwHEph3msXlwD3ZHRFNMeXJX7UzO6uP7NyifFIwPkcLwnRJAytCBS73GsNtUREOIiE5Z0BhBj97pO2F7/BlSREoswrPX2nEMTBBg5g9KzjFQVHQQO87fwjEFIleg2D0ZvNI6SbMymy9bqfjuCfPErg2kABHMYS99gUFtSElPYh5elhyUP+HCAzAZWqFZXO1eLnGSszHxvCo+TpfBtQpmhJjJW6w9r4CCL6zZjWbXYae2aOplDQFkPPZtULyC/BfcDjf047BaCS3t0dva2eVlG9vYTgdgN7lqMr+GFLUpUtUM+lLJvDYrjgrfTQ/8U3JLKv+ZpWhYUedqFSduyTapKHl36sMawtd/N/IUvL9+xDFYAS7Rh31+5Lsz6sQKgvsfedHmbU/S8EBF13oqqUH0iR5C31Joi21gGsC/s9y45ogcfTahVpLoxr9hz4z3DU1BfEVSL3sJ3gQoMG4ZNTfrOFMG8WtptgeXSJKZ5mBLg5fYa3U+abUHD5CIVw7BnnXbRHeUUP05m0G/3Yn3dygUdpS72CUCKySohZ6mnqhNcRDsmWF+7uvgBagEh4LBkM0ABhOEqRp8WuyHsGwoL877G0BX3Sa3E+C+P3QyRB8qV19D16qpYs6sVfaqD2t66Ja57BYWLrBu8dhz+/A4DKapZv8ZUhiQBadv6P6V2GPk+xfEprWuUvCPrPihC/OsPFyJLB9js2nT+kt5xo20QVEsRbDHWB4S7p+KdgViytOWfprgZg6rFeeDOjwMmhipfmDsOzDHnw87s5iaDobwu1K/wOJecH5DNTDoa/s5HCR+aIXOyrpA5EupLkvJyFHiGejIyO4Jbyvt4+tTmu4s4Wx8Tf7Lhx5xSrccmlltgScH/rmF5uWQaR2uMGphnJJlBRUJNxEKa
 w3X9wn+2
 sML8IDFw55YfSM7blxOs0WT+dQkkW/l87vR8NJ/y7GCmSsnvX8Mq7OVq5dgCBCSlj4rqmAJzWRulyx/pUCooMpX5XTL2jmtHB4SQX+R5UJmaSQpAM+n8GbLWtCMghQpoBHMTRzt7wZE+mMkEdfqRCA9DrXxBv9Uw0HmqGXktL025RxCYj3MioY9jAle9XaLzFvQ3KNTkD8t3bgTLYX1kdKb3plJ8q15IfnTHbgOPk/P7TZk/H4k8zbxo2cySuwttTub7BAm6KHwJMMrZMA5n2PgR7sr0mT6jGZNsZ2Dg+fJAxaho67yrDywSQL8f0R2vEobyM0oXyPhwjcNw+Z0KlNHibax+Hv9aR3pUVrTpab4MpwpZOhqnvMumkN7jV5pWY9hEGyne0prnQk77iHBuAzV7zIllEurVvZWYSzFgv6tERmAFKB17/+pOmjFB3koJPK+264cvfmCnT3HsXsHKEyrRvVxekoOtUy8o4t960GZHRxbNNCJzFbQjyAKT6KpI5XwwMXdif4X66Bs882Rv8RlfEaKOLyZyNXBCkmpcMgsC8qktN7P9g/8tWuI9QqM/iP279E4mUTmYCxNw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 2:53=E2=80=AFPM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> On 4/27/26 15:32, Vlastimil Babka (SUSE) wrote:
> > On 4/16/26 11:10, Harry Yoo (Oracle) wrote:
> >> @@ -2111,8 +2111,7 @@ void kvfree_call_rcu_ptr(struct rcu_ptr *head, v=
oid *ptr, bool allow_spin)
> >>                              IS_ENABLED(CONFIG_DEBUG_KMEMLEAK)))
> >>              goto defer_free;
> >>
> >> -    if (!IS_ENABLED(CONFIG_PREEMPT_RT) &&
> >> -                    (allow_spin && kfree_rcu_sheaf(ptr)))
> >> +    if (!IS_ENABLED(CONFIG_PREEMPT_RT) && kfree_rcu_sheaf(ptr, allow_=
spin))
> >>              return;
> >
> > I wonder if this patch is enough to drop (or reduce a lot) the PREEMPT_=
RT
> > incompatibility? It IIRC came from Ulad's review point [1] that since R=
T
> > spinlock is in fact a mutex, it's not unsafe to take it with e.g. disab=
led
> > preemption, and it's also why kfree_rcu_cpu uses a raw_spin_lock_t, etc=
.
> >
> > But with kfree_rcu_sheaf now having allow_spin parameter and only doing=
 a
> > trylock at most with that false, it should now be safe to allow it for
> > CONFIG_PREEMPT_RT, only pass allow_spin =3D false unconditionally there=
?
>
> Oh I forgot about...
>
> > [1] https://lore.kernel.org/all/aL_uhPtztx7Ef0T2@pc636/
> >
> >>
> >>      // Queue the object but don't yet schedule the batch.
> >> diff --git a/mm/slub.c b/mm/slub.c
> >> index 6f658ec00751..d0db8d070570 100644
> >> --- a/mm/slub.c
> >> +++ b/mm/slub.c
> >> @@ -5895,7 +5895,7 @@ static void rcu_free_sheaf(struct rcu_head *head=
)
> >>   */
> >>  static DEFINE_WAIT_OVERRIDE_MAP(kfree_rcu_sheaf_map, LD_WAIT_CONFIG);
> >>
> >> -bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
> >> +bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, bool allow_sp=
in)
> >>  {
> >>      struct slub_percpu_sheaves *pcs;
> >>      struct slab_sheaf *rcu_sheaf;
> >> @@ -5933,7 +5933,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, voi=
d *obj)
> >>                      goto fail;
> >>              }
> >>
> >> -            empty =3D barn_get_empty_sheaf(barn, true);
> >> +            empty =3D barn_get_empty_sheaf(barn, allow_spin);
> >>
> >>              if (empty) {
> >>                      pcs->rcu_free =3D empty;
> >> @@ -5942,6 +5942,10 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, vo=
id *obj)
> >>
> >>              local_unlock(&s->cpu_sheaves->lock);
> >>
> >> +            /* It's easier to fall back than trying harder with !allo=
w_spin */
> >> +            if (!allow_spin)
> >> +                    goto fail;
> >> +
> >>              empty =3D alloc_empty_sheaf(s, GFP_NOWAIT);
> >>
> >>              if (!empty)
> >> @@ -5973,6 +5977,12 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, vo=
id *obj)
> >>      if (likely(rcu_sheaf->size < s->sheaf_capacity)) {
> >>              rcu_sheaf =3D NULL;
> >>      } else {
> >> +            if (unlikely(!allow_spin)) {
> >> +                    /* call_rcu() cannot be called in an unknown cont=
ext */
> >> +                    rcu_sheaf->size--;
> >> +                    local_unlock(&s->cpu_sheaves->lock);
> >> +                    goto fail;
> >> +            }
>
> ... this part, so an unconditional allow_spin=3Dfalse on RT would only fi=
ll
> the rcu_sheaf once and then stop working.
>
> However, can we condition this on in_nmi() or something, and pretend the
> other cases of "unknown context" exist? Installing BPF hooks
> allocating/freeing memory into call_rcu() internals sounds crazy, no?

Unfortunately no. People attach to tracepoint lock contention
which can be inside call_rcu.
As discussed call_rcu_nolock() is only way forward.

