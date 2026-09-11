Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A39A3C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 17:39:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B7C36B008A; Fri, 11 Sep 2026 13:39:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 668DE6B008C; Fri, 11 Sep 2026 13:39:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 530416B0092; Fri, 11 Sep 2026 13:39:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 16F236B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:39:17 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 750FA1402E5
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:39:16 +0000 (UTC)
X-FDA: 85202192712.14.EAEFEAB
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf08.hostedemail.com (Postfix) with ESMTP id 86DE816000D
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:39:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oZ2cmWje;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789148354;
	b=Mw47IosTrZvPAzIu+2zKKIPBonwT2QNezOvPIVdyT98Q/2UBvNyPRmLwcYKvNd6s2CZaWV
	IP3JqKDw6VL7MlQwMJZiHLBeehuLw8byeHMGMaNuXu/GZNlSGFFkOg1tDCaBDSvuQ++56Z
	l8MkXZh2PG5YIHgAUstLvtRtH1lEMrY=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oZ2cmWje;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789148354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lDyI28LyXxLbVi5W3K5kzQ8tDJnYvbGU2xd2J7fxK38=;
	b=6srJb3p7+3JANZbLNN50DmlbCkMxrhzuadaI4xv1j2Ach245QhTkQUXcyuknmdCtyf0kOP
	ksNWddNHTkkTt369Kwg4YGe3VzA2pvTONV6h2cEp2COF/Cz/2P8zsW6vT9SXGGa0pl5wIx
	FsbxEsO+kf+yHC2n+C7OXhnsEQjxqKg=
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-53012819c04so74211cf.0
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:39:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789148354; cv=none;
        d=google.com; s=arc-20260327;
        b=gpVOyV9VA4ORzsaAnwcMunTRKzqB/QxMSyPAM3KujqxYCPx7HEh/1Kf1Vy1/bUblda
         yGWo/ueyTc0pOXHcFDOSTEuzi6t2eOQlC7qcG4V7uxK4W/nAABnLmgvquZ/KMucdDMFS
         q6fnhmOp35ev3YTrWjadihOmhygnJU7dsj9QfTd/bp2N9ZQS1qus5HxMICyCGfXtDqKR
         2n/5Pww4KO5UZ5KnXJ/jyFI7J4Znl7W2f4vKKRuBRlHSM6Npc/ddJQ3NqJzmAVKFGgjU
         kw8LgO26uCiK/bVGIaenMzLtCucO1RPzYrfU6dZpn8KO66sGZ2R+MQY+71Uy1vh1uQ/w
         v4uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lDyI28LyXxLbVi5W3K5kzQ8tDJnYvbGU2xd2J7fxK38=;
        fh=uwOMxJONYnUsE0CD7I7lPI8ey3mTTwO7SbVZpYluMZI=;
        b=EVbxC593h0pCtN2FJnrOX097rd1PzZG9wkUQdsgaDhfD5OiVBmYvO5ML8zd5Al3xZO
         5/2h1ifQZT/IccbfhJLujPnQJTWnQFRzvpyGZ9b3OAHOAOKZE8EDEyanup5kPSbzpCD1
         RUcVjhDhPu5MO0/iO4aYv+KaNBxZ+joKdwNsjrwMGZU3mqMJUpqh/xyGeGJkYwkqXJ4E
         fU1GQhSCSK4tOH1vYunAMdnWvjN0omNtDbqukFqA86jgUtNoTzx9S7r+CYwkO7U5/iK3
         bF+ZzfVSz2gycSzabXltTNfCcXwKLliKr6vIu9GmvpJowaEZruClZ8tYXNELBFH3Qb17
         r/OQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789148354; x=1789753154; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lDyI28LyXxLbVi5W3K5kzQ8tDJnYvbGU2xd2J7fxK38=;
        b=oZ2cmWjeVDpYnL9P4Dh25V3tMQY9mx4Z/RVI9Zs8BIUFbtePXLwxItgHkuJ7rIhRib
         UtC+POp7Icul5kbejoRqCiLZ6bAEPoOOGQ5OtnG594e5fXhTuI/mrsdSQgJndJvftyNA
         63ybywo/0rTN5grCQugzJbl6cdx3i2MLB4gQqntpOGDGWUsNGnikIwmNKzmPoioSbRSJ
         e0boqNgfSo547fJAPXv4zoxz1aL/heO6mTp/eszG2oEIEzJhX4qBiiOmnro1U4hRh4Ob
         mXprnCQMH+nZicV9CydZakdH2P6LtSX8XoA2nIg1JCoKZtidi3jhjKty7/eFdk67OC/s
         SO9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789148354; x=1789753154;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lDyI28LyXxLbVi5W3K5kzQ8tDJnYvbGU2xd2J7fxK38=;
        b=VAt+Db13I76+JtgmczpjEeiaQeJqdtocefb7hn1Y2C1eNqZHVOiCsDqgNfK9MGSFrq
         Ha/IF+ElVY8NG6tYBXLmQORMui8sN6ILx9OU0LDw+e2fkzg8SVZ9+P5OqF+EmAnOJASw
         iHs4k2az4O8zhVgnfQovrdgGVBxCo6Lhno7lK8oqB0r8IL8HnLxmpAP4a0Nc9aueY6L6
         f8pVVfpc91Pjt0VLcx/nJQmSJRD2OseUjrBqTzxTJwKiz0BQheHjAM9UEa9w7wjMWCJ0
         EVUR0paTpVxzVgi9HRT+rcWNOqekuuVxyHwnkREL7uiqCYVeVmTKdpUp/QIaqHayAGoj
         /xBA==
X-Forwarded-Encrypted: i=1; AKwUvBziledCSitwxkBM+cPyFryQZAz9hEHNEfyRBG0v0TTshPifNBf28P1UgPr4sLAzGfghjhf2hdBRVw==@kvack.org
X-Gm-Message-State: AFuF++lpkuJPW9EY4SCp+1T8rG9Uqe88knGZj5+ifcMOz28GB/hkElwg
	ZYfG/e2W0oVM4hK0GODwOZ0dARmClYuUCPtW4Qo2Td5Cd99ZhIb9ThgtQiyP3kTeDPU7+mqDAib
	n9Ly08xOQMbO3t5sz+a5P2hJ5ppsSJE/QP/m8hOX8
X-Gm-Gg: AYBFou0c8kjhC30xDxzj4Xc+MBtCd4ZXIOO7zBBMjpbiQVCU83kT2f32Drnua/Ua5Zg
	q+48fddm5RMfEO1G59PVDdMQbLUDlHJJZaaNdzkyIL9s+YxIDI6v+Q+Hv8667Z35bapgWdNqxDn
	dPi68f+ZyerHjHuhl6Fnq4WEMwI7XXD5mihDJll7OnilLFhhtCoagFteBvrXCPmI2a0yNHqjsKh
	xuFig8XW8wwNsYw21ecUHRpg5yL4KPmAsjU3uqd2PBwD16Gle4hpc++LS5xzIwQdOkizjMHCjpD
	R+BnaYzCXJp/yGQuh+X34QGO8a+9C9gmf6NFmDLE3qk81lppqtokdw==
X-Received: by 2002:a05:622a:124e:b0:530:d8ce:c26f with SMTP id
 d75a77b69052e-530e46f45camr675921cf.6.1789148352915; Fri, 11 Sep 2026
 10:39:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260910234737.1340642-1-surenb@google.com> <20260910234737.1340642-4-surenb@google.com>
 <aqQoPTTUC9M5HkYb@gremlin> <CAJuCfpEHeFSMamNhf=FLvFjh9D8DBwZtbKwL0zi=x-2g8B+ENw@mail.gmail.com>
 <aqQzk2AT05r6rOyT@gremlin>
In-Reply-To: <aqQzk2AT05r6rOyT@gremlin>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 11 Sep 2026 10:39:01 -0700
X-Gm-Features: AcwNN1XkyBoM4HG4ag-rjvAtmsYry_LOY1Kt-_sjnaCPmrsfivCEhhSHxjviJXs
Message-ID: <CAJuCfpEMd=hVtwe_9Rp1kqigYJwqEUGCD+ViQmoacAZONCR6DA@mail.gmail.com>
Subject: Re: [PATCH v3 3/7] proc/task_mmu: clarify shmem mapping walk
 conditions in smap_gather_stats()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, xueyuan.chen21@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 86DE816000D
X-Stat-Signature: 75gizfkm6d811yq6148kdmbiufdpghkp
X-HE-Tag: 1789148354-472621
X-HE-Meta: U2FsdGVkX182d0oXk0FRc/73pe2y8CUH1qlxeu7dPYIm/oQ7O6c63ldsIxEfF8AuKStjHfLs6XPmW/IBHawwYr/2W/9GLxjDrwZ9KFeTQ8j9z1ZgngK0z4hS2GOZLrieLtVEz+sGj4HbOCxc1NZJnp86n7i1PjtqtFuCHqLEx9NhYlF3Urhiov7Ic6naPqQvjiQHZB9ho8HKebaO4DTQrJmZq8cCx7cN0aMAUGE7ywqiwARaREP6lKdv5F1EgFhXXQYTFpbq1PISy71fifsRmIKJvGM2VfXi7WDXFlrPxXxMkS2gPeARZn6GcjbvjKGNmtqwjlH1f5czgPOhiIZNPYch3OBJ7O/s7VuureDFPx3YvWv64kZbSS9OtYG6yd/KG7VZunEpzwDD7b8v2cY5/vw3vkKh5KCwUIrIe5xGuw23OEvENAsftFYojIZh0Z1fPpZYjJEYTqVASkEYGxPCtb1keA2BOE9tTefMK0Ptft5mAyDaYnXKXscBnrrgH3UwP0dbGasaXbDJDTMWVlqmLXK51QLFaiik2Vtry4Uc1jBhNAe+EXAsEh+YXtgz86n0ANC2Cfk5IlG5EPW6RGQF6uG/7IbABRzdWygJJb1sJ/BIwoKn+oFqhsaXJcqxARbjUDRc3z+JHu4GGViut95VmgnDUs895DcQ4Xhlkkw1tXCspCAmyCMJ6jviNzVSQvGmrd11/80Sgthm7NH4TYiBKZNmsZdZ42YKaYn36QiytxUCYBkgA3JBAaiqxcUO7KwhBOFgdyPKzSJqKzTLsUWLdPNYO39u72WkmU8lLcMmoSF94uahew31bygrjOPUygOb8OOgufCh5S+iRUpMEg4sU4+uoR2zLPCaOyeDmGeXoEDADzF0ptU/e/q7LrS9ZxlmYMBxG4UByjvjtKs62xOl+nFfISBMPBw+hdfqT55g+qEmrRdlRUNOdVFo9GGErhcuH27vCRidK/Y/ZftDXte
 Hj5PpqN9
 42LinU0Oh5ludkdYOAQtyCs5io4JdiOuZOEAITtYWz0oogYpzdPvpfOK1KHRhRkIOAXQWuyALR0264OlYOt6w/NVmNiyqztPHC7jLdSrmRTGj7q/bBAGryw/oc1+d2j1xSNDMM+lIMiC5D0FUZmTtVb1n8V+FKi4TSrOuaE+ra1Zf0yBDZphcuc4NuPUbVzvJrOBOYgJWMxh2aDb+dxX5Zx8A13JvFyw8ERXYYm7+Q9QvHZ/DYWBY0ewKawv8gyY5kEppj68VzDFfOW6zpImQPpRA5LWGr83QYEpl2y0iml4yhZolioQcZUpYIS87d+O3Hv+l7KvHHL39LdIW+p16+uIdedp8XBCcK9NcKHCdd9TAjDB265BcUvWqlim3pUvNyQm0OYM96lkF21mbx1CfpwkhBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 10:10=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.=
org> wrote:
>
> On Fri, Sep 11, 2026 at 04:58:40PM +0000, Suren Baghdasaryan wrote:
> > On Fri, Sep 11, 2026 at 4:28=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kern=
el.org> wrote:
> > >
> > > On Thu, Sep 10, 2026 at 04:47:33PM -0700, Suren Baghdasaryan wrote:
> > > > smap_gather_stats() optimizes stats gathering by skipping the walk =
for
> > > > shmem mappings in certain conditions. Update the comment to clarify
> > > > these conditions and use vma_is_cow_mapping() for COW identificatio=
n
> > > > instead of open-coding it.
> > > > Instead of using (start !=3D 0) condition to identify partial walks=
, use
> > > > more semantically correct (start > vma->vm_start) check.
> > >
> > > I don't agree what you're doing is semantically correct, it's a hack =
really.
> > >
> > > Callers are passing start=3D0 to indicate that the entire VMA should =
be
> > > processed and that happens to fulfil your criteria but in a surprisin=
g way.
> > >
> > > And the start in these cases is corrupted.
> >
> > Well, the "other" Lorenzo does not agree with you and suggested this
> > approach in [1]. Specifically, see the comment:
> > ```
> > I also don't love that 0 is taken to be 'start from vma->vm_start' and =
I
> > also don't love that the code in smap_gather_stats() actually special c=
ases
> > this...
>
> I'm not sure what part of this is disagreement?
>
> It's saying passing 0 is a hack, which is one that is still in place and =
which
> this patch makes worse, because instead of explicitly calling out the inv=
alid
> value, you're treating it as if it were valid.
>
> >
> > How about passing last_vma_end and making smap_gather_stats() more sane=
? In
> > the other invocation of smap_gather_stats() we could pass vma->vm_start
> > here.
>
> Yup, well me of 3 months ago should have suggested what I suggested re: w=
rapper
> (I think you cut that suggestion out of my reply).
>
> > ```
> >
> > [1] https://lore.kernel.org/all/aifO_rCurVhFRTcl@lucifer/
>
> >
> > >
> > > >
> > > > No functional change intended.
> > > >
> > > > Suggested by: David Hildenbrand (Arm) <david@kernel.org>
> > > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > > ---
> > > >  fs/proc/task_mmu.c | 24 ++++++++++--------------
> > > >  1 file changed, 10 insertions(+), 14 deletions(-)
> > > >
> > > > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > > > index cfc7af1b551d..3c40c9cbb9c9 100644
> > > > --- a/fs/proc/task_mmu.c
> > > > +++ b/fs/proc/task_mmu.c
> > > > @@ -1257,6 +1257,7 @@ static void smap_gather_stats(struct proc_map=
s_private *priv,
> > > >                             struct mem_size_stats *mss, unsigned lo=
ng start)
> > > >  {
> > > >       const struct mm_walk_ops *ops =3D get_smaps_walk_ops(priv);
> > > > +     const bool is_partial =3D start > vma->vm_start;
> > >
> > > Yeah not in love with this, without changing how it's called.
> >
> > See [1]. This is exactly how you wrote it at the end of that reply.
>
> Assuming you passed vma->vm_start, not 0? Passing 0 makes it really stran=
ge.

Ah! Now I see the problem you are pointing out. Ok, in v2 [2] this was
done correctly and that's the way you want it!
Okay, I agree this split was incorrect. I think I'll move is_partial
conversion completely into the next patch and this one will only
update the comment and use vma_is_cow_mapping() instead of open-coding
it.

[2] https://lore.kernel.org/all/20260907063918.3432401-4-surenb@google.com/

>
> I see that in the patch I suggested I didn't update the other callers lik=
e I
> said you should in the reply, my bad from 3 months ago, but I don't think=
 that
> invalidates what's been raised here.
>
> >
> > >
> > > If you're reworking it all already, the actually semantically correct=
 thing
> > > I think would be to do something like:
> > >
> > > static void smap_gather_stats_range(struct proc_maps_private *priv,
> > >                 struct vm_area_struct *vma, struct mem_size_stats *ms=
s,
> > >                 unsigned long start)
> > > {
> > >         ...
> > > }
> > >
> > > Then to drop a parameter in smap_gather_stats() like:
> > >
> > > static void smap_gather_stats_range(struct proc_maps_private *priv,
> > >                 struct vm_area_struct *vma, struct mem_size_stats *ms=
s)
> > > {
> > >         smap_gather_stats_range(priv, vma, mss, vma->vm_start);
> > > }
> > >
> > > And then you remove the hack and make is_partial not be accidentally =
true for an
> > > invalid start parameter.
> > >
> > > >
> > > >       /* Invalid start */
> > > >       if (start >=3D vma->vm_end)
> > > > @@ -1270,23 +1271,18 @@ static void smap_gather_stats(struct proc_m=
aps_private *priv,
> > > >
> > > >       if (vma->vm_file && shmem_mapping(vma->vm_file->f_mapping)) {
> > > >               /*
> > > > -              * For shared or readonly shmem mappings we know that=
 all
> > > > -              * swapped out pages belong to the shmem object, and =
we can
> > > > -              * obtain the swap value much more efficiently. For p=
rivate
> > > > -              * writable mappings, we might have COW pages that ar=
e
> > > > -              * not affected by the parent swapped out pages of th=
e shmem
> > > > -              * object, so we have to distinguish them during the =
page walk.
> > > > -              * Unless we know that the shmem object (or the part =
mapped by
> > > > -              * our VMA) has no swapped out pages at all.
> > > > +              * CoW mappings might map anon folios that do not bel=
ong to
> > > > +              * shmem. Perform a less efficient page table walk in=
 this
> > > > +              * situation, unless we know that the shmem object (o=
r the
> > > > +              * part mapped by our VMA) has no swapped out pages a=
t all.
> > > >                */
> > > > -             unsigned long shmem_swapped =3D shmem_swap_usage(vma)=
;
> > > > +             const unsigned long shmem_swapped =3D shmem_swap_usag=
e(vma);
> > > > +             const bool is_cow =3D vma_is_cow_mapping(vma);
> > >
> > > Nice to see this helper naturally slot in to new stuff :)
> > >
> > > >
> > > > -             if (!start && (!shmem_swapped || (vma->vm_flags & VM_=
SHARED) ||
> > > > -                                     !(vma->vm_flags & VM_WRITE)))=
 {
> > > > -                     mss->swap +=3D shmem_swapped;
> > > > -             } else {
> > > > +             if (is_partial || (shmem_swapped && is_cow))
> > > >                       ops =3D get_smaps_shmem_walk_ops(priv);
> > > > -             }
> > > > +             else
> > > > +                     mss->swap +=3D shmem_swapped;
> > > >       }
> > > >
> > > >       if (!start)
> > >
> > > Also not absolutely in love with the fact you only use is_partial abo=
ve and
> > > leave:
> > >
> > >         if (!start)
> > >                 walk_page_vma(vma, ops, mss);
> > >         else
> > >                 walk_page_range(vma->vm_mm, start, vma->vm_end, ops, =
mss);
> > >
> > > As-is.
> > >
> > > Should be:
> > >
> > >         if (is_partial)
> > >                 walk_page_range(vma->vm_mm, start, vma->vm_end, ops, =
mss);
> > >         else
> > >                 walk_page_vma(vma, ops, mss);
> >
> > True, that can be changed here too. This whole block is replaced in
> > the next patch though.
>
> Yep I think that should be squashed into this one, as I say there.
>
> >
> > >
> > > But I also wonder whether, with start not being corrupted (!) you cou=
ld
> > > just replace this with:
> > >
> > >         walk_page_range_vma(vma, start, vma->vm_end, ops, mss);
> >
> > Yep, that's done in the very next patch.
>
> As above.
>
> >
> > >
> > > Looking at the pagewalk.c implementations I don't know why
> > > walk_page_range_vma() doesn't just forward [vma->vm_start, vma->vm_en=
d) to
> > > walk_page_range_vma()... but that's another thing :)
> > >
> > > > --
> > > > 2.55.0.1007.g17ff1f9808-goog
> > > >
> > >
> > > --
> > > Cheers, Lorenzo
>
> --
> Cheers, Lorenzo

