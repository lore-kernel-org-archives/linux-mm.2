Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E8ACCCF9E3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 15:28:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D630280004; Thu, 30 Oct 2025 11:28:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 786E2280003; Thu, 30 Oct 2025 11:28:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64E38280004; Thu, 30 Oct 2025 11:28:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4D417280003
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 11:28:07 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DABACB697B
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 15:28:06 +0000 (UTC)
X-FDA: 84055161372.14.3A6429D
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf16.hostedemail.com (Postfix) with ESMTP id E94FA180002
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 15:28:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ZIsW/gwG";
	spf=pass (imf16.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761838085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=17s53pVmMkcMZT8ne5HIpndSpVg+pfPjrs/QsaSS0o4=;
	b=OjDWqih8sHo9DR5ccrkmoFGIUaCjfmX1vP24Y/0lPHLiNWn0c1wtX8Vo9eHwo8HsSw8Eq8
	cIwdc8X/pGbaWTaIMFaNyxniM+1ueL8f31XZd6vPnt/t0KVHTm85YDFOUP72XlA410VvsD
	ZefHM4nqtRP2asMr9M3UB31e7NzTf4E=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ZIsW/gwG";
	spf=pass (imf16.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761838085; a=rsa-sha256;
	cv=none;
	b=ig1QDWs4jmbDk0q/i7PdGK/DYNDvdGDc6HR7b/HiMZQy8hI2L5oGAJcyRL5ynM45z9OkKi
	nKOO8EEuaQMbi/TSDbNn6SPceiIKQ0OKf87FSYM1hcI86hwmlNSU6+4V4/CcjuiiBgI9So
	XNe9Q9o2aWQcjwiSDjxeiYfmMvNeRhw=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3ee64bc6b85so1157437f8f.3
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 08:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761838083; x=1762442883; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=17s53pVmMkcMZT8ne5HIpndSpVg+pfPjrs/QsaSS0o4=;
        b=ZIsW/gwGD0VQ5d2IfHTmKwuiAZ/UOZoa5X2sXC9lelvFkfaYTVYZXbZxnyG9ueuK+d
         uACCu6RocUtpzZ/ZJGasvLb64WBX6/N7EnFHTxsQtP4u9zbHKUd4vZTj/ifIZmj0LVEa
         Lp3GGQ9zELY5fxVQlOqN0Tiir1g9hp2D4+mjf0nZcY5u+d+gAh6RVwdA8Cz9iJeinzAL
         9qOqcMZlvyKKc8GUOKo7YWSTgm+I2BfOFfEj3rdy6Yh3fsGsWJD6lSGFGJ7XOYhGW62Q
         u7yP0ku7ChkNPmE7CaZDyB7lwbOcFBTRVqBM3NFsXlIvGfS8UU08e5pL41fyo2dG+del
         tO8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761838083; x=1762442883;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=17s53pVmMkcMZT8ne5HIpndSpVg+pfPjrs/QsaSS0o4=;
        b=wWMw9u3XpfxWX0IwTntOuRqloMVikgDkcKsrcpYQ/4kILJxE/E1GsFMjvaBcDr5yBs
         dpbEx70FCcxHl9PJEB/dFZp0TuwW6nUZlaXdiZXAn2iFE70CVuxhSWghTyXCstmumV78
         pBAn8G1g2euIZN8lC41abe5jpJTCwQLdKVGhMN3riWgkbdIEI64VSbJ2GiPx0zNeKlPV
         38Ig3AohqqOGOh5RS4SnnazNv/O4oWPNCWKOtspFRXrYsDcpM3Zx/TIJzZW9jNU9FJaH
         u9qfJSCKKGqc8mjfuqE4fVFzRAiutn9yFtXbEGy3mtpdNr4q9lcPMEf8MkO++fYyH7od
         OUow==
X-Forwarded-Encrypted: i=1; AJvYcCU4LqiMUP+rQWw3lCVp0EgWE6/YCMcLxup+0sFB+gFHg0nq9VrCEvOZWP7q0IGp3Sr9v1lOUkcm3w==@kvack.org
X-Gm-Message-State: AOJu0Yx9uO7gUYgZd0ua5zLbxdY/3uHE55IBCYTO3WmnTEWDWMecfuA+
	V8mX/xd+G010b0u9jxO/3jtR82JeTI6wwYd8sJzvh5tR7kA9jkPWkdIKlYOBEChN9Ar8xM8/UW+
	SnSJ1fGz6Y7unkeUo86dfgr26NfYXgXE=
X-Gm-Gg: ASbGncuMBFKWOM4wSarXZehOly2FpzFg/I4k3hjfvRoHlWCdv+1lWPHa+QIgfaj2PzR
	s9vsrstWyebejYPpD1vIAWbHriIkhxAPvBQeKrpC+c5XJWqL+0Ym+k9IvTqtXVZ1HIV8vOnJxpL
	0+McocD72JgbGashHxq89mucDhJvJu8BrbMyVw7Mwt/C2JPmvncDk+gWZwsC1KDsEKGlAACFoc5
	PmtUPByeU+rmyQk86KrrGBKOlybCOTXObsMTI1clgBPBbyLKdaZNjFDURdXFc+QnZXhtMYzNrJw
X-Google-Smtp-Source: AGHT+IGXaWxPk/3M+cKYU/Pj7lpnExCAg79uXAbYfhqPsFtqXmL801omvA7wJAIBtF+VQCS8C9jbNQcSyBX5V1IM/6A=
X-Received: by 2002:a05:6000:2006:b0:427:847:9d59 with SMTP id
 ffacd0b85a97d-429b4c9ee68mr3815611f8f.45.1761838083095; Thu, 30 Oct 2025
 08:28:03 -0700 (PDT)
MIME-Version: 1.0
References: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz>
 <20251023-sheaves-for-all-v1-10-6ffa2c9941c0@suse.cz> <aQLqZjjq1SPD3Fml@hyeyoo>
 <06241684-e056-40bd-88cc-0eb2d9d062bd@suse.cz>
In-Reply-To: <06241684-e056-40bd-88cc-0eb2d9d062bd@suse.cz>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Thu, 30 Oct 2025 08:27:51 -0700
X-Gm-Features: AWmQ_bnX5zwf36gXg3U_L6nD0Y-OhNsAUiH1Wv4xcOqbTsg1lnruV_RapPX3X1o
Message-ID: <CAADnVQ+K-gWm6KKzKZ0vVwfT2H1UXSoaD=eA1aRUHpA5MCLAvA@mail.gmail.com>
Subject: Re: [PATCH RFC 10/19] slab: remove cpu (partial) slabs usage from
 allocation paths
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Uladzislau Rezki <urezki@gmail.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Alexei Starovoitov <ast@kernel.org>, linux-mm <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>, linux-rt-devel@lists.linux.dev, 
	bpf <bpf@vger.kernel.org>, kasan-dev <kasan-dev@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 9qez7khizdsecxmsd7okwtu43hano9p3
X-Rspamd-Queue-Id: E94FA180002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761838084-23625
X-HE-Meta: U2FsdGVkX1+JZ1mUwk9Bf8WrvF/xf9C9cV4+OEKoBaBkJfFYydYCfnDTffpRV72s/JZNayyDegw4gvuETlaH0K0Kk0Y7Ez3BcUKf+MthRcw69b2T3edaPaNZfH8HO/paXEpgkBgSDZJdYveR7yrO6AMX1iVDheoaDIYfJAhQt/kh7aRHv1GLGjKSinrnAsvOTgTtGx/dpOXVNSJk1H+026CoiEb+Wx3hoExITPIhV881tGzuGVUjlgY2/4mfxTUOWt0QqCJ015onHOuItEaIgj2H+4bKpCIx3ctOjxYITy8p0To3hCPrxD7beMjOcEhroRCp+WRP0mLBcfNHsD7agDhe665pbm1ZZl2ncfcvWoFAuHWfaEasFLlr3n2mrgolmN2fPwX1kwNQAlEz58lKJBDqyrp+1FApXhuPtMLXxcL4nrl5IsLRq4uQFIqDvjL6ATAfJR8xQ4y1jVaCf2RVJa0wnEdZmKsHVeh1G7+6TY8Yl8kt04uxQj61Aw1xZ9+az1MhZ71tY/kSNDZCxe8VDeGgZOYdwS6Vp7qX1TlFLUt4HMJv4RnBhzZknVKrWH0c2gzr3ICRt86Dbc2+Jc+aW45BNCWhmtkazRTE0Knx/X+YCK1v+YOXT6/7XPXdJIJYKf2kyDTaiuEHFyCYv4TOCqs9mE26XC5hhB9+vY+9ziPzCvM6u14NkNEii3xxb6EFX2lFTPLtZAGjgR3umc5CPEuonPUTooW/fc3IlBDwwn8DS+mbjMqL1MLQs/R3gaEW28C6QoXOffCBDul147Uu4MbPh5gdYxobnfuBPwbVChBYqcEwzS6r3yhEfJYN9DZN8ZIVmhso/QunXF7+xLla48sk+Y60I7HfMfg3yx9KZZXWTVaezih5m1HmXm6GRRLNMQm3f72hBIdmYdo4KLlIk8mMSPDEfsAIM7CG8n9n+znNeWnf6Kq8gekZRSMEOGW8elUmzY+EQfylGgafwNb
 nZzdQNUi
 Z3krOUaZeGgTZAjI2nLGHN7Et+rFVnBpbZKkbnIU7HDKtqeBlQ80BLiA1rfHzCw7jxglwT8ox/t03e3aXvuMsB035NbX2lKyf/cg19yzshYrJdod7vIeSxZjRr1vNzsA8gIpZf4km3zpu0rha6tcv58NI8c2Z+rIKeUapy5CB1HSlKXdvXpTC9M+FePQhyFF7McSzFPVKeNKbHah+puz/8GbGIhtxXIedgTluJY2Anq+m92SUjABEMaGw1sXukILnwtsCNKz7FROH3QuzUsm1WNKc4Njxftb+WbtFck0NOkbQ6dQwKkUbdgSJECect51jhlmBXRIQ4C1ypvwfDEvVJ3lLMCzkngXTqOeKYVF30WSmhhlrkVbjkRUxG6Q1O/zVvWabItIJBGtt5Is=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 6:09=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> On 10/30/25 05:32, Harry Yoo wrote:
> > On Thu, Oct 23, 2025 at 03:52:32PM +0200, Vlastimil Babka wrote:
> >> diff --git a/mm/slub.c b/mm/slub.c
> >> index e2b052657d11..bd67336e7c1f 100644
> >> --- a/mm/slub.c
> >> +++ b/mm/slub.c
> >> @@ -4790,66 +4509,15 @@ static void *___slab_alloc(struct kmem_cache *=
s, gfp_t gfpflags, int node,
> >>
> >>      stat(s, ALLOC_SLAB);
> >>
> >> -    if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
> >> -            freelist =3D alloc_single_from_new_slab(s, slab, orig_siz=
e, gfpflags);
> >> -
> >> -            if (unlikely(!freelist))
> >> -                    goto new_objects;
> >> -
> >> -            if (s->flags & SLAB_STORE_USER)
> >> -                    set_track(s, freelist, TRACK_ALLOC, addr,
> >> -                              gfpflags & ~(__GFP_DIRECT_RECLAIM));
> >> -
> >> -            return freelist;
> >> -    }
> >> -
> >> -    /*
> >> -     * No other reference to the slab yet so we can
> >> -     * muck around with it freely without cmpxchg
> >> -     */
> >> -    freelist =3D slab->freelist;
> >> -    slab->freelist =3D NULL;
> >> -    slab->inuse =3D slab->objects;
> >> -    slab->frozen =3D 1;
> >> -
> >> -    inc_slabs_node(s, slab_nid(slab), slab->objects);
> >> +    freelist =3D alloc_single_from_new_slab(s, slab, orig_size, gfpfl=
ags);
> >>
> >> -    if (unlikely(!pfmemalloc_match(slab, gfpflags) && allow_spin)) {
> >> -            /*
> >> -             * For !pfmemalloc_match() case we don't load freelist so=
 that
> >> -             * we don't make further mismatched allocations easier.
> >> -             */
> >> -            deactivate_slab(s, slab, get_freepointer(s, freelist));
> >> -            return freelist;
> >> -    }
> >> +    if (unlikely(!freelist))
> >> +            goto new_objects;
> >
> > We may end up in an endless loop in !allow_spin case?
> > (e.g., kmalloc_nolock() is called in NMI context and n->list_lock is
> > held in the process context on the same CPU)
> >
> > Allocate a new slab, but somebody is holding n->list_lock, so trylock f=
ails,
> > free the slab, goto new_objects, and repeat.
>
> Ugh, yeah. However, AFAICS this possibility already exists prior to this
> patch, only it's limited to SLUB_TINY/kmem_cache_debug(s). But we should =
fix
> it in 6.18 then.
> How? Grab the single object and defer deactivation of the slab minus one
> object? Would work except for kmem_cache_debug(s) we open again a race fo=
r
> inconsistency check failure, and we have to undo the simple slab freeing =
fix
>  and handle the accounting issue differently again.
> Fail the allocation for the debug case to avoid the consistency check
> issues? Would it be acceptable for kmalloc_nolock() users?

You mean something like:
diff --git a/mm/slub.c b/mm/slub.c
index a8fcc7e6f25a..e9a8b75f31d7 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4658,8 +4658,11 @@ static void *___slab_alloc(struct kmem_cache
*s, gfp_t gfpflags, int node,
        if (kmem_cache_debug(s)) {
                freelist =3D alloc_single_from_new_slab(s, slab,
orig_size, gfpflags);

-               if (unlikely(!freelist))
+               if (unlikely(!freelist)) {
+                       if (!allow_spin)
+                               return NULL;
                        goto new_objects;
+               }

or I misunderstood the issue?

