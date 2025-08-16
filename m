Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE09ECA0EE6
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 17:36:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37E886B0325; Sat, 16 Aug 2025 13:36:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 308856B0326; Sat, 16 Aug 2025 13:36:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A8326B0324; Sat, 16 Aug 2025 13:36:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 046426B0320
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 13:36:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0119859157
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 17:36:31 +0000 (UTC)
X-FDA: 83783325024.09.FC8EB80
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf22.hostedemail.com (Postfix) with ESMTP id EBDE4C0004
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 17:36:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DL+Ka+iP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of sudarsanm@google.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=sudarsanm@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755365790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zbAmPbuOmgWndLCTRVJ+2FYbeiH8FV5AAURokx0966U=;
	b=8XCizs0mwDPHmoDxJGmK4RJhudssSs3bNaLs2v8RzWYD1scdlt2G/yO60MFJCl+fy4yetK
	vOypfz9tRB++Dx06RShgBJcCiPm9Y6f0GRyLyzaF7oOnBViiE7W74FpwkDWAHZIJlgosCs
	MvnFTPppDJuI7OIKf5vhZ1+5pZS5/aU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DL+Ka+iP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of sudarsanm@google.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=sudarsanm@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755365790; a=rsa-sha256;
	cv=none;
	b=H1b5Y+fm3NpSj0Tzy3mSev38GMwZ6auEpF3p4cFTlmvsm83CmwqW6uaZAjrc7vUzMNc8KC
	5eDzxzWLRnjBG0JYDN+OoIR2oJKaXzte7+jHJePNfHPTM6cbTegX6ll9ZqAm/ljzj4xdAY
	OET2NQa6BDwGL6HrOh1RthNZjBh5cfA=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3bb2fb3a48aso788260f8f.1
        for <linux-mm@kvack.org>; Sat, 16 Aug 2025 10:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755365788; x=1755970588; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zbAmPbuOmgWndLCTRVJ+2FYbeiH8FV5AAURokx0966U=;
        b=DL+Ka+iPP7KFD2gDF0ynbMJDsdePyHPQnRRNaX1bka25zMgTjreBvxBsQ4dHMTmNGj
         aVKFFafrwNej4pNnoHpsGh6OGpyDxeOYAW7f9IaltFfkDTj8sKQD77zpm0vObR365C6y
         X4/8tCmf7fCeeKh1TjTD8QWhEmkQFgLoxfft/LmBtdM9aF1HnlRWJeA6D4LCS8jNZgco
         d+eczAMbNQuEemgDA9IhQOI3tLuGeGIMCQ8aTKVq0wcdoWhur3NaHE+KW0wi8jzseLWB
         wIraTPWcY/lM3CmNdKMYU2/LQD7+ewOQ+jvbwz6j3FldIZ7ZAZhHZ2/aGv6gPNjeUNe6
         ZbxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755365788; x=1755970588;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zbAmPbuOmgWndLCTRVJ+2FYbeiH8FV5AAURokx0966U=;
        b=mVuZeIPwTAgHyHfI3iy6zJa+7tCphPXxNEgvPKF/KKYOUJ+kSJtkI+95saKiXws+u2
         p21tW/22nAoE3xwcow1uq/MjxDAWQLQgEDUdak0tIPUEKrZBgh9kZR6M4EHKKsAOLTT0
         HqdfzOkV8dFnExRK0gnbEg0CaVYketFXxjsroWiiZuv/lR53q7CYnKnj2EHk17Wjczrn
         MaJXKOXS9av0xez1mF/M7YaK+2BsHgEONOz+IWCc28fR/u7744zqEGDnFdkXKoqmEk0F
         WE7bJi80FwYS3YtJQcimnQs4LeKtB5QEfI6yUefXLcy5aNXHbx5iRsW/J2WndeUBuh85
         Befw==
X-Forwarded-Encrypted: i=1; AJvYcCV9lLel2UFogVYtuLxKynLrF9DvsC2GiikWFp2KLxaAtjrM7ZEwAvU+18II/e3k7kYB95KDrjOfng==@kvack.org
X-Gm-Message-State: AOJu0Yy+fFWurTfquf3E/4mjGqwnawsHNxHAaE3ibD1q2hWx9nOnjBdC
	IwHKVtzgMppsC7YzlwFw60yBg4oTlxcXHfQStLmig6o1484TQQOO3OM8m1ldkPKhykdB8uw40wC
	QzX3GkMOIUAj8IrcDBGuJ37IUC5l6pZVgpSxD94Ac
X-Gm-Gg: ASbGncsovGrr5fsmNycP+pmh/eAexqBZMazZpuyiVa6pDrBhrXCtTyCafi5SXhNYI+5
	u4f3XEt1aCNXPqweluoZ/gdbdw1O1Bkh1CLDkKG5g06deKS61qYPHgumJyb9wYJZ2sQEEZAlSbN
	m4PCxBpLL1+RCEvgkg8MduHNxNAYlwBY4bENgP83MT1HwYDDiLpyNrvjHjSKu2NTLickp6E9Dlk
	sCZKkvTZaFt4AUZXb4=
X-Google-Smtp-Source: AGHT+IH57a5L4FXLdqv+gwlm8S/vBI1fJsoLCl/im/Ajf86jsaISYSARuZtqO8jeex2xgGUJHW6f3/4DIq0X2cZ+sB0=
X-Received: by 2002:a05:6000:178e:b0:3b6:12d9:9f1b with SMTP id
 ffacd0b85a97d-3bb672f19c2mr4665936f8f.22.1755365788171; Sat, 16 Aug 2025
 10:36:28 -0700 (PDT)
MIME-Version: 1.0
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
 <20250815225259.3012455-2-sudarsanm@google.com> <aKA7180s0HdLfOKc@harry>
In-Reply-To: <aKA7180s0HdLfOKc@harry>
From: Sudarsan Mahendran <sudarsanm@google.com>
Date: Sat, 16 Aug 2025 10:35:52 -0700
X-Gm-Features: Ac12FXyTARxvTJupHhS96bw1bsi8H9sCxD5JZoeQYYGiBe03aIwFGUsh85LfrI8
Message-ID: <CAA9mObAiQbAYvzhW---VoqDA6Zsb152p5ePMvbco0xgwyvaB2Q@mail.gmail.com>
Subject: Re: [PATCH v5 00/14] SLUB percpu sheaves
To: Harry Yoo <harry.yoo@oracle.com>
Cc: vbabka@suse.cz, Liam.Howlett@oracle.com, cl@gentwo.org, howlett@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	maple-tree@lists.infradead.org, rcu@vger.kernel.org, rientjes@google.com, 
	roman.gushchin@linux.dev, surenb@google.com, urezki@gmail.com, 
	Greg Thelen <gthelen@google.com>
Content-Type: multipart/alternative; boundary="00000000000041fd82063c7ef21d"
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EBDE4C0004
X-Stat-Signature: w4ssew47e4qr3uh1784cyg11k7abmun5
X-Rspam-User: 
X-HE-Tag: 1755365789-187568
X-HE-Meta: U2FsdGVkX1/5oeHYWI/ajMyogNJvEkriznio5JSd5lXm2+IwZioPok7gIQMo10erFwtb4I3SMJ3PMPH8bfI3VZ4a/TiQzndaVAnQe8DTNoRgAjREiO88PWvQUNo72JclmnLHeSJkh+sh26XLeJCgtMafSVHPLJ4y5xu4cNvw1ZaGKwUdAYjTLJSl+GqQDdj1Xgqv7iXBBQBiTIwkZPg8IdbtOQ8poTW9t1b+9QQqME2RPpseZMQ8iSD4Sfzj6mKjBS1LNPKTqGadTeW9yTzuKCq5wh0uEvw1Dw0E0UUP1Q+iTUO+xWu+fgmuw4OhXuMAHVBT1iYqPUA04B3l/7DC4a3PQTyPpnX/E3OBP6czrGf5elOYC/2X+hUp+9NEXL3oDEwc9kXyAgwYxOpmsqCL6JA9EePZqp7KdsFaw1MFIjPJbL0rR1gRT3w67FOBzxyqjtozANhj1ypySU+8a35lO75U/X+yDdercVGzraP8sTVfc62Igg6I0VEPaB6/SmK+d+LroDodZ04q5gE3H1A6459dFkXABn6a23Dkytplzqwo3EPZHRSD7TVsDEcW16GohnPOuby6rrb7m5uv/tgQtKVPNHhzgtMo7o/UMQ1aKf0USYppgbALzTe1yv1SdgYxXBIgA7brQfJKRuKtEwjVMBRFs5+GlcGL5AovK5kETG/t3qUJBDwY8B+MI5RBMKC3fZEg69ig0FfEtLmdCNsTbNdCTAtRdAJDcQR5NA64VUdF23GIFvAKh6ZlP/SXG4+5kkwhFJ7ukeoxB1uSaGOohIQOR+TXA7iZQax+ps7ONt/aAu3zygza+T9ayRySRy56FvXZiiUjp5heKlkV1Gq/pQzWh7L+7FKbVpdunz+JzQFBcLkcTbGU5L7FJv/LK1rRaSpF31vYwo3CaizqqeXDhvMbqtxofaSvwZfjv+WbX/DZdspdkvnDA9DLT2au1Zpk442y//2IxNkg3O2u3qr
 Js03jhDK
 svkHd3pX+2xMQzx8xbl/Lboi6C0p/ov3bCFnAEMAPOAQc1tsk5UKIIvTK1x93w9PF5Is5w/dX9bneRFfTVKuKcDgej7Ir+QZ2dlKD4gA8FkiqEPayQIvdQTKZLUol8OuJNZ3wfti+lYy+RyQk/KnuZ5s6oNCewDj2whnPf8vn5meyur3yyFzXn7qqPoCqTIO7RQ6F2c849gpccO19KngTHvXHCL416NEV24c7VE8eva8nKMJfBC4qj4QBhuguN5n2wnuKV2bUDHgQIF5q22fA6rayGLqyCLyDX69k7IwdGhRQ58F4pxi2y0hO9OvhZXT0pODf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--00000000000041fd82063c7ef21d
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 16, 2025 at 1:06=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
>
> On Fri, Aug 15, 2025 at 03:53:00PM -0700, Sudarsan Mahendran wrote:
> > Hi Vlastimil,
> >
> > I ported this patch series on top of v6.17.
> > I had to resolve some merge conflicts because of
> > fba46a5d83ca8decb338722fb4899026d8d9ead2
> >
> > The conflict resolution looks like:
> >
> > @@ -5524,20 +5335,19 @@ EXPORT_SYMBOL_GPL(mas_store_prealloc);
> >  int mas_preallocate(struct ma_state *mas, void *entry, gfp_t gfp)
> >  {
> >         MA_WR_STATE(wr_mas, mas, entry);
> > -       int ret =3D 0;
> > -       int request;
> >
> >         mas_wr_prealloc_setup(&wr_mas);
> >         mas->store_type =3D mas_wr_store_type(&wr_mas);
> > -       request =3D mas_prealloc_calc(&wr_mas, entry);
> > -       if (!request)
> > +       mas_prealloc_calc(&wr_mas, entry);
> > +       if (!mas->node_request)
> >                 goto set_flag;
> >
> >         mas->mas_flags &=3D ~MA_STATE_PREALLOC;
> > -       mas_node_count_gfp(mas, request, gfp);
> > +       mas_alloc_nodes(mas, gfp);
> >         if (mas_is_err(mas)) {
> > -               mas_set_alloc_req(mas, 0);
> > -               ret =3D xa_err(mas->node);
> > +               int ret =3D xa_err(mas->node);
> > +
> > +               mas->node_request =3D 0;
> >                 mas_destroy(mas);
> >                 mas_reset(mas);
> >                 return ret;
> > @@ -5545,7 +5355,7 @@ int mas_preallocate(struct ma_state *mas, void
*entry, gfp_t gfp)
> >
> >  set_flag:
> >         mas->mas_flags |=3D MA_STATE_PREALLOC;
> > -       return ret;
> > +       return 0;
> >  }
> >  EXPORT_SYMBOL_GPL(mas_preallocate);
> >
> >
> >
> > When I try to boot this kernel, I see kernel panic
> > with rcu_free_sheaf() doing recursion into __kmem_cache_free_bulk()
> >
> > Stack trace:
> >
> > [    1.583673] Oops: stack guard page: 0000 [#1] SMP NOPTI
> > [    1.583676] CPU: 103 UID: 0 PID: 0 Comm: swapper/103 Not tainted
6.17.0-smp-sheaves2 #1 NONE
> > [    1.583679] RIP: 0010:__kmem_cache_free_bulk+0x57/0x540
> > [    1.583684] Code: 48 85 f6 0f 84 b8 04 00 00 49 89 d6 49 89 ff 48 85
ff 0f 84 fe 03 00 00 49 83 7f 08 00 0f 84 f3 03 00 00 0f 1f 44 00 00 31 c0
<48> 89 44 24 18 65 8b 05 6d 26 dc 02 89 44 24 2c 31 ff 89 f8 c7 44
> > [    1.583685] RSP: 0018:ff40dbc49b048fc0 EFLAGS: 00010246
> > [    1.583687] RAX: 0000000000000000 RBX: 0000000000000012 RCX:
ffffffff939e8640
> > [    1.583687] RDX: ff2afe75213e6c90 RSI: 0000000000000012 RDI:
ff2afe750004ad00
> > [    1.583688] RBP: ff40dbc49b049130 R08: ff2afe75368c2500 R09:
ff2afe75368c3b00
> > [    1.583689] R10: ff2afe75368c2500 R11: ff2afe75368c3b00 R12:
ff2aff31ba00b000
> > [    1.583690] R13: ffffffff939e8640 R14: ff2afe75213e6c90 R15:
ff2afe750004ad00
> > [    1.583690] FS:  0000000000000000(0000) GS:ff2aff31ba00b000(0000)
knlGS:0000000000000000
> > [    1.583691] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [    1.583692] CR2: ff40dbc49b048fb8 CR3: 0000000017c3e001 CR4:
0000000000771ef0
> > [    1.583692] PKRU: 55555554
> > [    1.583693] Call Trace:
> > [    1.583694]  <IRQ>
> > [    1.583696]  __kmem_cache_free_bulk+0x2c7/0x540
>
> [..]
>
> > [    1.583759]  __kmem_cache_free_bulk+0x2c7/0x540
>
> Hi Sudarsan, thanks for the report.
>
> I'm not really sure how __kmem_cache_free_bulk() can call itself.
> There's no recursion of __kmem_cache_free_bulk() in the code.
Hi Harry,

I assume somehow the free_to_pcs_bulk() fallback case is taken, thus
calling __kmem_cache_free_bulk(), which calls free_to_pcs_bulk() ad nauseam=
.

free_to_pcs_bulk()
{
...
fallback:
        __kmem_cache_free_bulk(s, size, p);
...
}

static void __kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void
**p)
{
        if (!size)
                return;

        /*
         * freeing to sheaves is so incompatible with the detached freelist
so
         * once we go that way, we have to do everything differently
         */
        if (s && s->cpu_sheaves) {
                free_to_pcs_bulk(s, size, p);
                return;
        }
...

Thanks Greg for pointing this out.


> As v6.17-rc1 is known to cause a few surprising bugs, could you please
> rebase onto of mm-hotfixes-unstable and check if it still reproduces?
>
> > [    1.583761]  ? update_group_capacity+0xad/0x1f0
> > [    1.583763]  ? sched_balance_rq+0x4f6/0x1e80
> > [    1.583765]  __kmem_cache_free_bulk+0x2c7/0x540
> > [    1.583767]  ? update_irq_load_avg+0x35/0x480
> > [    1.583768]  ? __pfx_rcu_free_sheaf+0x10/0x10
> > [    1.583769]  rcu_free_sheaf+0x86/0x110
> > [    1.583771]  rcu_do_batch+0x245/0x750
> > [    1.583772]  rcu_core+0x13a/0x260
> > [    1.583773]  handle_softirqs+0xcb/0x270
> > [    1.583775]  __irq_exit_rcu+0x48/0xf0
> > [    1.583776]  sysvec_apic_timer_interrupt+0x74/0x80
> > [    1.583778]  </IRQ>
> > [    1.583778]  <TASK>
> > [    1.583779]  asm_sysvec_apic_timer_interrupt+0x1a/0x20
> > [    1.583780] RIP: 0010:cpuidle_enter_state+0x101/0x290
> > [    1.583781] Code: 85 f4 ff ff 49 89 c4 8b 73 04 bf ff ff ff ff e8 d5
44 d4 ff 31 ff e8 9e c7 37 ff 80 7c 24 04 00 74 05 e8 12 45 d4 ff fb 85 ed
<0f> 88 ba 00 00 00 89 e9 48 6b f9 68 4c 8b 44 24 08 49 8b 54 38 30
> > [    1.583782] RSP: 0018:ff40dbc4809afe80 EFLAGS: 00000202
> > [    1.583782] RAX: ff2aff31ba00b000 RBX: ff2afe75614b0800 RCX:
000000005e64b52b
> > [    1.583783] RDX: 000000005e73f761 RSI: 0000000000000067 RDI:
0000000000000000
> > [    1.583783] RBP: 0000000000000002 R08: fffffffffffffff6 R09:
0000000000000000
> > [    1.583784] R10: 0000000000000380 R11: ffffffff908c38d0 R12:
000000005e64b535
> > [    1.583784] R13: 000000005e5580da R14: ffffffff92890b10 R15:
0000000000000002
> > [    1.583784]  ? __pfx_read_tsc+0x10/0x10
> > [    1.583787]  cpuidle_enter+0x2c/0x40
> > [    1.583788]  do_idle+0x1a7/0x240
> > [    1.583790]  cpu_startup_entry+0x2a/0x30
> > [    1.583791]  start_secondary+0x95/0xa0
> > [    1.583794]  common_startup_64+0x13e/0x140
> > [    1.583796]  </TASK>
> > [    1.583796] Modules linked in:
> > [    1.583798] ---[ end trace 0000000000000000 ]---
> > [    1.583798] RIP: 0010:__kmem_cache_free_bulk+0x57/0x540
> > [    1.583800] Code: 48 85 f6 0f 84 b8 04 00 00 49 89 d6 49 89 ff 48 85
ff 0f 84 fe 03 00 00 49 83 7f 08 00 0f 84 f3 03 00 00 0f 1f 44 00 00 31 c0
<48> 89 44 24 18 65 8b 05 6d 26 dc 02 89 44 24 2c 31 ff 89 f8 c7 44
> > [    1.583800] RSP: 0018:ff40dbc49b048fc0 EFLAGS: 00010246
> > [    1.583801] RAX: 0000000000000000 RBX: 0000000000000012 RCX:
ffffffff939e8640
> > [    1.583801] RDX: ff2afe75213e6c90 RSI: 0000000000000012 RDI:
ff2afe750004ad00
> > [    1.583801] RBP: ff40dbc49b049130 R08: ff2afe75368c2500 R09:
ff2afe75368c3b00
> > [    1.583802] R10: ff2afe75368c2500 R11: ff2afe75368c3b00 R12:
ff2aff31ba00b000
> > [    1.583802] R13: ffffffff939e8640 R14: ff2afe75213e6c90 R15:
ff2afe750004ad00
> > [    1.583802] FS:  0000000000000000(0000) GS:ff2aff31ba00b000(0000)
knlGS:0000000000000000
> > [    1.583803] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [    1.583803] CR2: ff40dbc49b048fb8 CR3: 0000000017c3e001 CR4:
0000000000771ef0
> > [    1.583803] PKRU: 55555554
> > [    1.583804] Kernel panic - not syncing: Fatal exception in interrupt
> > [    1.584659] Kernel Offset: 0xf600000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> >
> >

--00000000000041fd82063c7ef21d
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br><br>On Sat, Aug 16, 2025 at 1:06=E2=
=80=AFAM Harry Yoo &lt;<a href=3D"mailto:harry.yoo@oracle.com" target=3D"_b=
lank">harry.yoo@oracle.com</a>&gt; wrote:<br>&gt;<br>&gt; On Fri, Aug 15, 2=
025 at 03:53:00PM -0700, Sudarsan Mahendran wrote:<br>&gt; &gt; Hi Vlastimi=
l,<br>&gt; &gt;<br>&gt; &gt; I ported this patch series on top of v6.17.<br=
>&gt; &gt; I had to resolve some merge conflicts because of<br>&gt; &gt; fb=
a46a5d83ca8decb338722fb4899026d8d9ead2<br>&gt; &gt;<br>&gt; &gt; The confli=
ct resolution looks like:<br>&gt; &gt;<br>&gt; &gt; @@ -5524,20 +5335,19 @@=
 EXPORT_SYMBOL_GPL(mas_store_prealloc);<br>&gt; &gt; =C2=A0int mas_prealloc=
ate(struct ma_state *mas, void *entry, gfp_t gfp)<br>&gt; &gt; =C2=A0{<br>&=
gt; &gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 MA_WR_STATE(wr_mas, mas, entry);<br>&g=
t; &gt; - =C2=A0 =C2=A0 =C2=A0 int ret =3D 0;<br>&gt; &gt; - =C2=A0 =C2=A0 =
=C2=A0 int request;<br>&gt; &gt;<br>&gt; &gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 m=
as_wr_prealloc_setup(&amp;wr_mas);<br>&gt; &gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 mas-&gt;store_type =3D mas_wr_store_type(&amp;wr_mas);<br>&gt; &gt; - =C2=
=A0 =C2=A0 =C2=A0 request =3D mas_prealloc_calc(&amp;wr_mas, entry);<br>&gt=
; &gt; - =C2=A0 =C2=A0 =C2=A0 if (!request)<br>&gt; &gt; + =C2=A0 =C2=A0 =
=C2=A0 mas_prealloc_calc(&amp;wr_mas, entry);<br>&gt; &gt; + =C2=A0 =C2=A0 =
=C2=A0 if (!mas-&gt;node_request)<br>&gt; &gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 goto set_flag;<br>&gt; &gt;<br>&gt; &gt; =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 mas-&gt;mas_flags &amp;=3D ~MA_STATE_PREALLOC;<br>&gt=
; &gt; - =C2=A0 =C2=A0 =C2=A0 mas_node_count_gfp(mas, request, gfp);<br>&gt=
; &gt; + =C2=A0 =C2=A0 =C2=A0 mas_alloc_nodes(mas, gfp);<br>&gt; &gt; =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 if (mas_is_err(mas)) {<br>&gt; &gt; - =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mas_set_alloc_req(mas, 0);<br>&gt; &=
gt; - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D xa_err(mas-&=
gt;node);<br>&gt; &gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 i=
nt ret =3D xa_err(mas-&gt;node);<br>&gt; &gt; +<br>&gt; &gt; + =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mas-&gt;node_request =3D 0;<br>&gt; =
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mas_destroy(ma=
s);<br>&gt; &gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ma=
s_reset(mas);<br>&gt; &gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 return ret;<br>&gt; &gt; @@ -5545,7 +5355,7 @@ int mas_preallocate(=
struct ma_state *mas, void *entry, gfp_t gfp)<br>&gt; &gt;<br>&gt; &gt; =C2=
=A0set_flag:<br>&gt; &gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 mas-&gt;mas_flags |=
=3D MA_STATE_PREALLOC;<br>&gt; &gt; - =C2=A0 =C2=A0 =C2=A0 return ret;<br>&=
gt; &gt; + =C2=A0 =C2=A0 =C2=A0 return 0;<br>&gt; &gt; =C2=A0}<br>&gt; &gt;=
 =C2=A0EXPORT_SYMBOL_GPL(mas_preallocate);<br>&gt; &gt;<br>&gt; &gt;<br>&gt=
; &gt;<br>&gt; &gt; When I try to boot this kernel, I see kernel panic<br>&=
gt; &gt; with rcu_free_sheaf() doing recursion into __kmem_cache_free_bulk(=
)<br>&gt; &gt;<br>&gt; &gt; Stack trace:<br>&gt; &gt;<br>&gt; &gt; [ =C2=A0=
 =C2=A01.583673] Oops: stack guard page: 0000 [#1] SMP NOPTI<br>&gt; &gt; [=
 =C2=A0 =C2=A01.583676] CPU: 103 UID: 0 PID: 0 Comm: swapper/103 Not tainte=
d 6.17.0-smp-sheaves2 #1 NONE<br>&gt; &gt; [ =C2=A0 =C2=A01.583679] RIP: 00=
10:__kmem_cache_free_bulk+0x57/0x540<br>&gt; &gt; [ =C2=A0 =C2=A01.583684] =
Code: 48 85 f6 0f 84 b8 04 00 00 49 89 d6 49 89 ff 48 85 ff 0f 84 fe 03 00 =
00 49 83 7f 08 00 0f 84 f3 03 00 00 0f 1f 44 00 00 31 c0 &lt;48&gt; 89 44 2=
4 18 65 8b 05 6d 26 dc 02 89 44 24 2c 31 ff 89 f8 c7 44<br>&gt; &gt; [ =C2=
=A0 =C2=A01.583685] RSP: 0018:ff40dbc49b048fc0 EFLAGS: 00010246<br>&gt; &gt=
; [ =C2=A0 =C2=A01.583687] RAX: 0000000000000000 RBX: 0000000000000012 RCX:=
 ffffffff939e8640<br>&gt; &gt; [ =C2=A0 =C2=A01.583687] RDX: ff2afe75213e6c=
90 RSI: 0000000000000012 RDI: ff2afe750004ad00<br>&gt; &gt; [ =C2=A0 =C2=A0=
1.583688] RBP: ff40dbc49b049130 R08: ff2afe75368c2500 R09: ff2afe75368c3b00=
<br>&gt; &gt; [ =C2=A0 =C2=A01.583689] R10: ff2afe75368c2500 R11: ff2afe753=
68c3b00 R12: ff2aff31ba00b000<br>&gt; &gt; [ =C2=A0 =C2=A01.583690] R13: ff=
ffffff939e8640 R14: ff2afe75213e6c90 R15: ff2afe750004ad00<br>&gt; &gt; [ =
=C2=A0 =C2=A01.583690] FS: =C2=A00000000000000000(0000) GS:ff2aff31ba00b000=
(0000) knlGS:0000000000000000<br>&gt; &gt; [ =C2=A0 =C2=A01.583691] CS: =C2=
=A00010 DS: 0000 ES: 0000 CR0: 0000000080050033<br>&gt; &gt; [ =C2=A0 =C2=
=A01.583692] CR2: ff40dbc49b048fb8 CR3: 0000000017c3e001 CR4: 0000000000771=
ef0<br>&gt; &gt; [ =C2=A0 =C2=A01.583692] PKRU: 55555554<br>&gt; &gt; [ =C2=
=A0 =C2=A01.583693] Call Trace:<br>&gt; &gt; [ =C2=A0 =C2=A01.583694] =C2=
=A0&lt;IRQ&gt;<br>&gt; &gt; [ =C2=A0 =C2=A01.583696] =C2=A0__kmem_cache_fre=
e_bulk+0x2c7/0x540<br>&gt;<br>&gt; [..]<br>&gt;<br>&gt; &gt; [ =C2=A0 =C2=
=A01.583759] =C2=A0__kmem_cache_free_bulk+0x2c7/0x540<br>&gt;<br>&gt; Hi Su=
darsan, thanks for the report.<br>&gt;<br>&gt; I&#39;m not really sure how =
__kmem_cache_free_bulk() can call itself.<br>&gt; There&#39;s no recursion =
of __kmem_cache_free_bulk() in the code.<br>Hi Harry,<br><br>I assume someh=
ow the <font face=3D"monospace">free_to_pcs_bulk()</font> fallback case is =
taken, thus calling <font face=3D"monospace">__kmem_cache_free_bulk()</font=
>, which calls <font face=3D"monospace">free_to_pcs_bulk()</font> ad nausea=
m.<br><br><font face=3D"monospace">free_to_pcs_bulk()<br>{<br>...<br>fallba=
ck:<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 __kmem_cache_free_bulk(s, size, p);<br>.=
..<br>}</font><br><br><font face=3D"monospace">static void __kmem_cache_fre=
e_bulk(struct kmem_cache *s, size_t size, void **p)<br>{<br>=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 if (!size)<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 return;<br><br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0* freeing to sheaves is so incompatible with the detach=
ed freelist so<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* once we go that way, =
we have to do everything differently<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*=
/<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (s &amp;&amp; s-&gt;cpu_sheaves) {<br>=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 free_to_pcs_bulk(s,=
 size, p);<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 retur=
n;<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>...</font><br><br>Thanks Greg for po=
inting this out.<br><br><br>&gt; As v6.17-rc1 is known to cause a few surpr=
ising bugs, could you please<br>&gt; rebase onto of mm-hotfixes-unstable an=
d check if it still reproduces?<br>&gt;<br>&gt; &gt; [ =C2=A0 =C2=A01.58376=
1] =C2=A0? update_group_capacity+0xad/0x1f0<br>&gt; &gt; [ =C2=A0 =C2=A01.5=
83763] =C2=A0? sched_balance_rq+0x4f6/0x1e80<br>&gt; &gt; [ =C2=A0 =C2=A01.=
583765] =C2=A0__kmem_cache_free_bulk+0x2c7/0x540<br>&gt; &gt; [ =C2=A0 =C2=
=A01.583767] =C2=A0? update_irq_load_avg+0x35/0x480<br>&gt; &gt; [ =C2=A0 =
=C2=A01.583768] =C2=A0? __pfx_rcu_free_sheaf+0x10/0x10<br>&gt; &gt; [ =C2=
=A0 =C2=A01.583769] =C2=A0rcu_free_sheaf+0x86/0x110<br>&gt; &gt; [ =C2=A0 =
=C2=A01.583771] =C2=A0rcu_do_batch+0x245/0x750<br>&gt; &gt; [ =C2=A0 =C2=A0=
1.583772] =C2=A0rcu_core+0x13a/0x260<br>&gt; &gt; [ =C2=A0 =C2=A01.583773] =
=C2=A0handle_softirqs+0xcb/0x270<br>&gt; &gt; [ =C2=A0 =C2=A01.583775] =C2=
=A0__irq_exit_rcu+0x48/0xf0<br>&gt; &gt; [ =C2=A0 =C2=A01.583776] =C2=A0sys=
vec_apic_timer_interrupt+0x74/0x80<br>&gt; &gt; [ =C2=A0 =C2=A01.583778] =
=C2=A0&lt;/IRQ&gt;<br>&gt; &gt; [ =C2=A0 =C2=A01.583778] =C2=A0&lt;TASK&gt;=
<br>&gt; &gt; [ =C2=A0 =C2=A01.583779] =C2=A0asm_sysvec_apic_timer_interrup=
t+0x1a/0x20<br>&gt; &gt; [ =C2=A0 =C2=A01.583780] RIP: 0010:cpuidle_enter_s=
tate+0x101/0x290<br>&gt; &gt; [ =C2=A0 =C2=A01.583781] Code: 85 f4 ff ff 49=
 89 c4 8b 73 04 bf ff ff ff ff e8 d5 44 d4 ff 31 ff e8 9e c7 37 ff 80 7c 24=
 04 00 74 05 e8 12 45 d4 ff fb 85 ed &lt;0f&gt; 88 ba 00 00 00 89 e9 48 6b =
f9 68 4c 8b 44 24 08 49 8b 54 38 30<br>&gt; &gt; [ =C2=A0 =C2=A01.583782] R=
SP: 0018:ff40dbc4809afe80 EFLAGS: 00000202<br>&gt; &gt; [ =C2=A0 =C2=A01.58=
3782] RAX: ff2aff31ba00b000 RBX: ff2afe75614b0800 RCX: 000000005e64b52b<br>=
&gt; &gt; [ =C2=A0 =C2=A01.583783] RDX: 000000005e73f761 RSI: 0000000000000=
067 RDI: 0000000000000000<br>&gt; &gt; [ =C2=A0 =C2=A01.583783] RBP: 000000=
0000000002 R08: fffffffffffffff6 R09: 0000000000000000<br>&gt; &gt; [ =C2=
=A0 =C2=A01.583784] R10: 0000000000000380 R11: ffffffff908c38d0 R12: 000000=
005e64b535<br>&gt; &gt; [ =C2=A0 =C2=A01.583784] R13: 000000005e5580da R14:=
 ffffffff92890b10 R15: 0000000000000002<br>&gt; &gt; [ =C2=A0 =C2=A01.58378=
4] =C2=A0? __pfx_read_tsc+0x10/0x10<br>&gt; &gt; [ =C2=A0 =C2=A01.583787] =
=C2=A0cpuidle_enter+0x2c/0x40<br>&gt; &gt; [ =C2=A0 =C2=A01.583788] =C2=A0d=
o_idle+0x1a7/0x240<br>&gt; &gt; [ =C2=A0 =C2=A01.583790] =C2=A0cpu_startup_=
entry+0x2a/0x30<br>&gt; &gt; [ =C2=A0 =C2=A01.583791] =C2=A0start_secondary=
+0x95/0xa0<br>&gt; &gt; [ =C2=A0 =C2=A01.583794] =C2=A0common_startup_64+0x=
13e/0x140<br>&gt; &gt; [ =C2=A0 =C2=A01.583796] =C2=A0&lt;/TASK&gt;<br>&gt;=
 &gt; [ =C2=A0 =C2=A01.583796] Modules linked in:<br>&gt; &gt; [ =C2=A0 =C2=
=A01.583798] ---[ end trace 0000000000000000 ]---<br>&gt; &gt; [ =C2=A0 =C2=
=A01.583798] RIP: 0010:__kmem_cache_free_bulk+0x57/0x540<br>&gt; &gt; [ =C2=
=A0 =C2=A01.583800] Code: 48 85 f6 0f 84 b8 04 00 00 49 89 d6 49 89 ff 48 8=
5 ff 0f 84 fe 03 00 00 49 83 7f 08 00 0f 84 f3 03 00 00 0f 1f 44 00 00 31 c=
0 &lt;48&gt; 89 44 24 18 65 8b 05 6d 26 dc 02 89 44 24 2c 31 ff 89 f8 c7 44=
<br>&gt; &gt; [ =C2=A0 =C2=A01.583800] RSP: 0018:ff40dbc49b048fc0 EFLAGS: 0=
0010246<br>&gt; &gt; [ =C2=A0 =C2=A01.583801] RAX: 0000000000000000 RBX: 00=
00000000000012 RCX: ffffffff939e8640<br>&gt; &gt; [ =C2=A0 =C2=A01.583801] =
RDX: ff2afe75213e6c90 RSI: 0000000000000012 RDI: ff2afe750004ad00<br>&gt; &=
gt; [ =C2=A0 =C2=A01.583801] RBP: ff40dbc49b049130 R08: ff2afe75368c2500 R0=
9: ff2afe75368c3b00<br>&gt; &gt; [ =C2=A0 =C2=A01.583802] R10: ff2afe75368c=
2500 R11: ff2afe75368c3b00 R12: ff2aff31ba00b000<br>&gt; &gt; [ =C2=A0 =C2=
=A01.583802] R13: ffffffff939e8640 R14: ff2afe75213e6c90 R15: ff2afe750004a=
d00<br>&gt; &gt; [ =C2=A0 =C2=A01.583802] FS: =C2=A00000000000000000(0000) =
GS:ff2aff31ba00b000(0000) knlGS:0000000000000000<br>&gt; &gt; [ =C2=A0 =C2=
=A01.583803] CS: =C2=A00010 DS: 0000 ES: 0000 CR0: 0000000080050033<br>&gt;=
 &gt; [ =C2=A0 =C2=A01.583803] CR2: ff40dbc49b048fb8 CR3: 0000000017c3e001 =
CR4: 0000000000771ef0<br>&gt; &gt; [ =C2=A0 =C2=A01.583803] PKRU: 55555554<=
br>&gt; &gt; [ =C2=A0 =C2=A01.583804] Kernel panic - not syncing: Fatal exc=
eption in interrupt<br>&gt; &gt; [ =C2=A0 =C2=A01.584659] Kernel Offset: 0x=
f600000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xfff=
fffffbfffffff)<br>&gt; &gt;<br>&gt; &gt;</div>
</div>

--00000000000041fd82063c7ef21d--

