Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5630C5518F
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 15:01:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B84656B00FE; Tue,  4 Aug 2026 11:01:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5C4B6B0102; Tue,  4 Aug 2026 11:01:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A721E6B0104; Tue,  4 Aug 2026 11:01:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7A5BD6B00FE
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:01:13 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 16EA61A01F5
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:01:13 +0000 (UTC)
X-FDA: 85063900026.07.ABA3A8C
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf28.hostedemail.com (Postfix) with ESMTP id CFF9AC0006
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:01:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eNXWLQLA;
	spf=pass (imf28.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785855670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=okK/WmcHe/IlDVg3t8yFB+GYShke2LQvsImQ/EEfJDU=;
	b=gOhfFx+otEcY29/JoSWSNiy4gwp71F4tTRqa4PAQZ2ajdBAe5Pkw3NiOLnSQmIusFukCBu
	Ps+/1ljyGBmpeOrNX3Ve0iRgAVjte1gxpmdIMDcGhQPOUwGosq+dX/Shz73gphIaO6vWoI
	sh9/atE71u//hrTM7b3pD5wfLYfw9kM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785855670;
	b=HSeiEexq2HpL19yaRjeawudAiT/WU726HkqzY97nH8/dIFPJdPM+zA0mPxmJRq9dXE8Q3G
	CQEZDI3wPeAkqwRpn9ybT+TzKI6S0p3vWQBBOJ5GDh2bP37FiqjEvurEkyPic8wa+fqM8a
	Ru3IqnKHbHd0becmEaOhuycBFEY1Peg=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eNXWLQLA;
	spf=pass (imf28.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-51c10ed63c0so266691cf.1
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 08:01:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785855670; cv=none;
        d=google.com; s=arc-20260327;
        b=YwVcvBr/e+E33qrhYoTsrDEdkXIKp5xzH6+H3wGX6b14hE43Sd9yS8Nwvo6qeT606j
         08kqHU3/cRuM9BcPquVkVbHACrgq9ThZdDek9TSnROBNNiG+wIDLizs4MeqM54r1mr7Y
         SYszQvKfZMcwCvawK1b5rpd+C63pPGULvV/BWuy2GmDhRMmfW5DeV2vdFcgjbZ8P/Vlh
         VPfEqY3LbayXVEalCFTtT401fRJQNVb2kneoW+UNEthjQAtYbOzR7vu1h9gSVa+AYW7K
         hOCnqL4GZjRIl1O7QLi6KN343YGb6d6/K176b5pZYGosrraOFbGwObIykl5oB54Y3chk
         itVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=okK/WmcHe/IlDVg3t8yFB+GYShke2LQvsImQ/EEfJDU=;
        fh=nIim6BVloaYrQ83mPvrsXS62SezehkFN6QfUpFMcClM=;
        b=JykcwSqgLKOhMXEsJNLBQG+lSCssgwZWUUvDzdXFKr3OcUhBAXfDbVrj49c3anYiJi
         745kY0a1G4R7DYXwUKk/8wAdRGdsj6PgJHgeKmzS76ZQ3QhhfbcFURz09X0IjJrekPcL
         KkzyTe+zGD3BkyOw2RtOOr9IZcs0DKBJXgL1MKZ2qyzju3vcULCsfafKwssvqy8gDBFj
         f+6F6Xf9/l/H+9SDIGtucftt5Kux7OkWU7pi3N6MoJOvvap2hPSRmwJZanpNeCKoc+1z
         CNu7dN/dy7ZYaDO6U1EHfYJK7kmvGcH0V9ea7FtX7trZpQ99eneSpDIp7R+OKD3qOKOX
         pcEg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785855670; x=1786460470; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=okK/WmcHe/IlDVg3t8yFB+GYShke2LQvsImQ/EEfJDU=;
        b=eNXWLQLA1fuNFt4XDrN8ReJbWCKpoGonkQyXeXqOM4Q8s/UFHTRI5NLxzO59+HbXWo
         SyZkyq7zeixL0qPlsJH3EJ50+LlA519YGQvT+vs1EWrIbcQpVm68G82HSC8jFw8zto+5
         TMPpb3k14bb1NyeXahWRlB72SNyyWqjRC2DxOJOwTJI0VDh9xhrqvNpg5+JVe9tqRJMH
         0Z9PXjw403LpTWrmRoDHx8pituYqdtAYcKqFHudCJvg1xzbI6My8KQCkWSstNF4+N+8F
         DzS6MwvtCLY8YY78RYjDYiEYf63V2wL5GqufNy33Z85S3i2uUF4vfKzaMC2w9s5GBYD7
         9NQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785855670; x=1786460470;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=okK/WmcHe/IlDVg3t8yFB+GYShke2LQvsImQ/EEfJDU=;
        b=IcEGYYWR209Ts/YO4meNCUHBgmuyAvK4I9mGcLa0cMKC+B3HlGyMi2GNQmfXpmfVPp
         tr1k8GODg0uEJ2lqZUqRPTmwxdiBwJ3TwsrC/h4ZiY34epEfNO520pzBwaZykr/CCX8u
         B6hOn1UX7yzL5g2f32RTPEQXcv3dybt+O0naLPL1pNpb9RsW3ytoBYRBoR+uDhh8sccY
         ZLDCJIMGxpS37B+5umbARLz/mmiLGfhZmCv+CholYA41OGffAkZRq6Yw2tN/c8iFsety
         qChEHUT1YwD/k6rkf07AOO0u83yQuIt99nQX3GjGZ6FvR665ywmgM7KIVknyOac7SS5x
         hGDw==
X-Forwarded-Encrypted: i=1; AHgh+RpKgtynWbqeHR7ENy5gTXSvohCM7xkDz4KvTxiA9khIEE7nXGX7a/8+QLaSDMXWqNf6pFFLP/G4sg==@kvack.org
X-Gm-Message-State: AOJu0Ywsl/nHjCiucANmLv17696znNMST1/7qmXK8dvEMsQb27KDpGrX
	CUsk8jAgxzke5tAPrsQ7ME/zidA9/Ysp4Tir2yld0UFAAEtBNcEjsGY/T5RDGYnFojgHrIPRFnA
	qjeKwMDz0AJ/Q4is2PgYz/BRxyysksVyx24CfujDP
X-Gm-Gg: AR+sD12nOhwY6l82lzLBOAuXsLl/JKFce1CoRU4RMerZLmUvUZVqCWA2XlptgniYGqW
	j2JMlRro/FepaMA1OhkNcK6MMJycRcyTLj8KrwDUAlxd5SQhm0VzLjaAVvJDc65nguQFkpwMT3d
	IkCEt57TwAzpqskIU2k7LjXeLQAmwUPHQJGNj2uuhB3G1gCRKgfId//7JbwOW0B4uOjggs2d/H5
	cbwRr0bmUKzJsNo+l1P1ggdCnW6atEyjWKhcET4cjLY9ZL+H9WYOPgkLKJtfcig2f0Sji1IY2Ba
	2OiJs6zgOJOh4S/QOg+KLzglv3dfvIMfxxqV3wLCIQDOZI79ckRpDSeSNvk8lLGRpy3+kOAmA5s
	=
X-Received: by 2002:a05:622a:a95a:b0:50d:edb1:6bd1 with SMTP id
 d75a77b69052e-52ce4064fb9mr2261011cf.13.1785855668889; Tue, 04 Aug 2026
 08:01:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260802215459.2769283-1-surenb@google.com> <20260802215459.2769283-4-surenb@google.com>
 <anB4uxEbKsa1Re0w@lucifer> <CAJuCfpGXk8jfRrJ=JwMLvpzxbNnzJUOYRHfWUX5e4vgP5j72Og@mail.gmail.com>
 <anGmhgqk-HjhejJL@lucifer>
In-Reply-To: <anGmhgqk-HjhejJL@lucifer>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 4 Aug 2026 08:00:56 -0700
X-Gm-Features: AUfX_mwoQHKou16DXo1Jd8x9iBvGN2J9-cFV_FJyi4l9zQdBjRr8a96kthPtQMw
Message-ID: <CAJuCfpH1WzCBgRbp3R5FAxked534ewTaMA_TxPjw1wCkDFZuow@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] mm: Add RCU-based VMA lookup helper that waits for writers
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com, 
	Liam.Howlett@oracle.com, david@redhat.com, willy@infradead.org, 
	shakeel.butt@linux.dev, vbabka@kernel.org, jannh@google.com, 
	aliceryhl@google.com, arve@android.com, cmllamas@google.com, 
	christian@brauner.io, tkjos@android.com, dsahern@kernel.org, 
	davem@davemloft.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-Stat-Signature: emigg7498dn85yijxf6cgu8eshay5rnr
X-Rspamd-Queue-Id: CFF9AC0006
X-HE-Tag: 1785855670-221381
X-HE-Meta: U2FsdGVkX1+3+KopnINrJ1Q5RAdpSIMLPxP2smzQU+cB6gP1R0ge76C7+OeKy1IUYDvGI7UlVLNZ5q/gIazYXqlFMhRj8lk5+RoJOA2v2JiBtSplRYGDEgLCshQvgovlTRsXx0KSWLUPZa9lOQg+C3YNca9QmqdiqblWWnUhoOqXO+Ya/iMLI8m2iDQ3kZ8llSgBgBUjEgU+q8GAt7Ifv+5TnDRmuaRLDQwlj3hn4mRu9UyPSUSLxvwGkn1UAchUeCBt90Lgl+E9FNrI/EPzpbC5S3GwL6ijb9PbAwvvUB0MhwyAWdsGMvXPIVa9Wg+UFBR5qPsSjO54xEgKDr3Ax9awa/0HnFy5Kzs9Bd/yMoH9GHev6Vz2CcNBB06ceq4mZXarxCNvynDxqbVp22gd+b+vzVGl5VRLfpOyBjAAGEf8QJSikAufvl4asXkQSsVwobBysP8b6liRcmz/vmIz7bHonlVTvc5oWL3Z0y5vkkNnhKBr7tBetA889SUQAFI9zjj8vdMUn+rpFRun17ij4Af9mOjuYg8O5xkxvlRW0Nd1h80zL6rnKNcFBfN1WSX2eFHbI2LFLtMuRbpjVaftG0NGnlM73xAOG6CICjJGHnWn/m/i3o5yiXQVqKqUK8/KmDs649BEv4jmdWMccZ5K5NckbjIp+d92mEOq4YbWnTelp/B0NUGbjyQc2f1JJtp0VbBdKfg/OFG3KOi1LGF+EBI25tv+d2KmHDC0BkccN3J2SJPN9hRX6C4PI5YR9MiHmUmCBH/7fh0IY9rYlWSo6tpb3kH5Z/BA2eWzHNg2GrMJm44imnX7YAq2+wxrj8XG46vzJuZrcbW/5Gm8z1cGUsMGwyRZ8TLcVMdYwZbYZLBIlwwsN59TLx5gCEz1v+WXKXDeo5T5m8pn8DdBK90uKtFdV8Tu/ka3179FiOSzMd0rMQj5mEUDGlc5Y4Pnd5edazfqXwITFkag8WKE42K
 kzyPITJX
 oE6kaoErkcdlKVLq+EYD2jiMjjsdO3aP9Xl/kGuMcN+bJ/1KE9FeUdY/S139ztyCGIB6OYQ7TUnOgB+j2kvGUrW2Lpdl48WXEJFSogz+xSUToJOOOWCxzZyLK6a2NhyqKmi8akREP7Kw5BpUsruVweA/RAe8Q8Fl+GSBerGk98du8agl8/zYjHdpIkuSw4rWNKUNVxSSOIts5hxioBoPAmb2yXVtW9iLvPokQTZMwCFeJsdX0RPMYUVXtVH3h8j+cb5SrP7WIZR/RE5VlK0GQwktiH7gjHdro1VZzjxDHaBcwRMxr1G9aYttcUEm6eNcV+9G1f+sz3fNKpt+K2WYhXhHXZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 4, 2026 at 1:47=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> On Mon, Aug 03, 2026 at 12:01:21PM -0700, Suren Baghdasaryan wrote:
> > On Mon, Aug 3, 2026 at 4:28=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kerne=
l.org> wrote:
> > > >
> > >
> > > Would be nice to have a:
> > >
> > > Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >
> > Ack.
>
> Thanks!
>
> >
> > >
> > > Here given https://lore.kernel.org/linux-mm/af4Zx0gJIWbdDeY2@lucifer/=
 :)
> > >
>
> > > > diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> > > > index e20d01e8d38f..6ff05e68e61b 100644
> > > > --- a/mm/mmap_lock.c
> > > > +++ b/mm/mmap_lock.c
> > > > @@ -338,6 +338,35 @@ struct vm_area_struct *lock_vma_under_rcu(stru=
ct mm_struct *mm,
> > > >       return NULL;
> > > >  }
> > > >
> > > > +/*
> > >
> > > Why not a kdoc comment?
> >
> > Indeed. Will change.
>
> Thanks!
>
> >
> > >
> > > > + * Find the VMA covering 'address' and lock it for reading. Waits =
for writers to
> > > > + * finish if the VMA is being modified. Returns NULL if there is n=
o VMA covering
> > > > + * 'address'.
> > > > + *
> > > > + * Use only in code paths where no mmap_lock and no VMA lock is he=
ld.
> > >
> > > Well, a VMA read lock can be held which would make this a noop essent=
ially.
> > >
> > > If a VMA write lock is held you're also ok as the mmap read lock will=
 preclude
> > > an mmap write lock, meaning vma_end_write_all() will have been called=
 and the
> > > write lock released.
> > >
> > > So I think you can just drop this line?
> >
> > Maybe instead of this I should say: Use when mmap_lock is not held,
> > otherwise use vma_start_read_locked() ? I think that was the original
> > reason for this comment.
>
> Yeah that works thanks!
>
> >
> > >
> > > > + *
> > > > + * The fast path does not take mmap_lock.
> > > > + */
> > > > +struct vm_area_struct *vma_start_read_unlocked(struct mm_struct *m=
m,
> > > > +                                            unsigned long address)
> > > > +{
> > > > +     struct vm_area_struct *vma;
> > > > +
> > > > +     /* Fast path: return stable VMA covering 'address': */
> > > > +     vma =3D lock_vma_under_rcu(mm, address);
> > > > +     if (vma)
> > > > +             return vma;
> > > > +
> > > > +     /* Slow path: preclude VMA writers by temporarily getting mma=
p read lock. */
> > > > +     mmap_read_lock(mm);
> > > > +     vma =3D vma_lookup(mm, address);
> > > > +     if (vma && !vma_start_read_locked(vma))
> > >
> > > This maybe warrants an unlikely() given it can only happen if refcoun=
t
> > > overflows? Also worth having a comment to that effect here?
> >
> > vma_start_read_locked()
> >   vma_start_read_locked()
> >     vma_start_read_locked_nested()
> >       unlikely(!__refcount_inc_not_zero_limited_acquire())
> >
> > already contains "unlikely" clause. Do we need to add it in all its use=
rs?
> > I can modify the comment for vma_start_read_locked() stating that
> > refcount overflow is very unlikely. Would that work or do you want
> > callers to have that too?
>
> Ah ok not an issue then. But good to add a comment at least?

Will do. Thanks!

>
> > > > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > > > index edd90892f8cc..c3a0c38a3dc3 100644
> > > > --- a/mm/userfaultfd.c
> > > > +++ b/mm/userfaultfd.c
> > > > @@ -129,8 +129,10 @@ struct vm_area_struct *find_vma_and_prepare_an=
on(struct mm_struct *mm,
> > > >   *
> > > >   * Should be called without holding mmap_lock.
> > > >   *
> > > > - * Return: A locked vma containing @address, -ENOENT if no vma is =
found, or
> > > > - * -ENOMEM if anon_vma couldn't be allocated.
> > > > + * Return: A locked vma containing @address, -ENOENT if no vma is =
found,
> > > > + * -ENOMEM if anon_vma couldn't be allocated, or -EAGAIN if vma re=
fcount
> > > > + * overflow happened due to high number of readers and the caller =
should
> > > > + * retry later.
> > >
> > > I'm guessing you're fixing this up as part of the patch? But it feels=
 a bit
> > > random, I mean fine but you should mention this change in the commit =
message +
> > > explain why.
> >
> > I'm fixing that because Vlastimil asked about these inconsistencies in
> > his previous review :)
> > I can package these fixes as a separate patch or add a comment in the
> > changelog, smth like "While at it, fix the comments for related
> > functions". Would that work?
>
> Comment in change log is fine thanks!
>
> --
> Cheers, Lorenzo

