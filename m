Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53903CD37AC
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 01:44:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B77576B0088; Wed, 13 May 2026 21:44:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4F436B008A; Wed, 13 May 2026 21:44:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A65956B008C; Wed, 13 May 2026 21:44:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 97D7F6B0088
	for <linux-mm@kvack.org>; Wed, 13 May 2026 21:44:49 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3F09FA0206
	for <linux-mm@kvack.org>; Thu, 14 May 2026 01:44:49 +0000 (UTC)
X-FDA: 84764331498.12.1D618AD
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf16.hostedemail.com (Postfix) with ESMTP id 229C818000E
	for <linux-mm@kvack.org>; Thu, 14 May 2026 01:44:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SMCH79jV;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778723087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yde0U0bJqJwXSCoKFDXMQRsREod/oul5ZXXMrQ0I248=;
	b=uDvzS/9bJqCF1gwuRrohLpGZBZqZnB7pi6ITegGHudZo7AnG4Uwj2kr2HXxJdP3k1bHGNy
	ajIN4URRnXAzAe8EIKj8aL17+9EjtlbEz+3WsBUZyMtxwaCJMWU2cjNs0FXuWJynJ+awCL
	shWDkIBsIdydKwpJeeQ8sKHMu2v8oxM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778723087; a=rsa-sha256;
	cv=pass;
	b=CV7YoB144q+QsffFWETULf/0MeH06DGZROecilf8ZfIW3niJWe/ALaxzv1x1TjzgetBzQs
	PhnBxmqnPVdRvoNog/KykmrMGctdxT3t8xB01I6F1axbz1C62qIgTPnTmx62UqYqHYKhxK
	KoZsRPalk25V9J9zNF6jW+y9kJVminE=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SMCH79jV;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-50d6b393d60so183431cf.0
        for <linux-mm@kvack.org>; Wed, 13 May 2026 18:44:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778723086; cv=none;
        d=google.com; s=arc-20240605;
        b=doaKtls2jVuVPhDKZBaQ8OOfi1YxL90k91gIgMLk/sxmKCsXPP2Uqb/P4wjwgQWzrp
         6gbx38wUXJCg9jpOOUIm/tdJkBamoRkvxYsoztrB3gOMdVvqsjnHZenBkbukHAfrnVj5
         OCSjb/l1L6WEaBegrS+3ClTWd3dXuEW31o2aeIhPk/SUhM3vZ2vJPERiOqGHQaoDkJby
         E5MPfzgIri8RpqHX46jvFQnrAZNLqoRAb7s2gxv09t8tSypcI5FwpIgLWn7nq7yEf++w
         QqhN9eeB5gYnC4Tge45NqD/i0he460joUiQLA4cMN6v4KZign/hDqpHDvYAiV1r2UAE7
         jcIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yde0U0bJqJwXSCoKFDXMQRsREod/oul5ZXXMrQ0I248=;
        fh=loZtzT/mD9jw7IXe5IsA6xagiSOI7QeZbpWwUKDow1w=;
        b=ckyglhpAmjXMykjiIleEhBqZXNh6R4AeYs10A8pVmq2081s6b2Nwk/6LdmrMWhYBlL
         nwbrSmTo0sf8cpRN8Lo5vLck7ge+5mtwqpgHhCRwaD7Oh3JmtjvXIyfkiDW4PQaeS31h
         kKOTs/tub5F++6FD+/Gp1RN8RGLHnf1Gl0QKMrTyBgCwkSe2xIS1D0Hk2251zUFK8T0l
         r1FXLkYiKLs/f3dWQ9RR1Ryacbey1ousYBXgjb/KU8ZPfYubAje8oY9gahddNcMrI2T9
         g1TG9dp+0ONax14ZxzDuBXxgbP6YD0Q8fIngukZrDVzbw51PQ4gGkqYdfHnQjR8FE2wq
         SIOQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778723086; x=1779327886; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yde0U0bJqJwXSCoKFDXMQRsREod/oul5ZXXMrQ0I248=;
        b=SMCH79jVhJNEy+aGa6WdbBbWAS1tqIY26hwNPX3zX9frK70+nWs3jK3J90J2151isx
         hnw0lsuaNSTd7yfnyWdx1khgtLipDcUS61Y2QXixMsGFB7YmImc35bKxfQjogXGFNNs6
         VaPRVKK46zl6I7SwLvE88Qe1sJgCiczhQUPE5fCe5FLvRJtGbUHEnF6GUs+NEfYBy/Yb
         6PEcrJoevrniM9bAviNCXLssgN33UsZeYxMQTcYE+h0aF1YsG2kQ/GJxwyy+SA/FQ6+/
         6pIy+6ZgpR+VwuA1srKt5zkq2tDmFb635ewWXcHjNpnmfCqihDqJdJSzrq9jeJ6vTLb8
         N0ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778723086; x=1779327886;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yde0U0bJqJwXSCoKFDXMQRsREod/oul5ZXXMrQ0I248=;
        b=l6FrXIVf4Gc/I82YvCjKL7EhbfSaYuClwfOIRIZ+/rmgFEwRAOKqKdmApYm6OC3Igd
         7ymT0Ep8J5drgU0doY8tNy16tvI98ye7Ty20fhcpue0vS8rWU+X4w5MLi1hL49mKoJxj
         IANYTf/+MM5cb/FbCbiOKePDxJU9gA7SXq2+jEmV440nuLB/eOMDIW1uL8TW5Zko++9F
         gfG7o24ETe2W3P5tAHJHLJQ5FCx/RrehVRFfr/uJ6iHh6VBFXVqMnKHuQ+GlPEiyaBHQ
         nXKtXyobh53NWpadiDoSHE2k02E5IhOQjJq8+oaeCCZLOUbsGj+ESSQs99DbG/hyVK07
         5bYQ==
X-Forwarded-Encrypted: i=1; AFNElJ/n5qfSJLfC671nHJz0C/RqXYYKJdC5/DxxdA4L10Yx6Z8wqjR+v6qM8yPp4YP2TtEWk2c7NCfr0A==@kvack.org
X-Gm-Message-State: AOJu0Yx6eLDP+jJ6BVFOX61knq2wTSNC10IxgqdzZCdJ692nlDT/lgzn
	Uow6krP5GvrH+3fEiLhFmPxH52XYzS1dvTYUpWluufve3Bgbz5nioytdDVFOzf2OnKs29F47uIh
	eqyA6dAkE04ifVTG4btX62jXnk0Y4XnWXXqXHxrbu
X-Gm-Gg: Acq92OERVxTL2G2K+KbW36R592S7zfGQ/lMcbRIjEgVHR+mNyWf7qgV+OubID3DZZVr
	915MplA2GKDGc6+5y1Ocgul0QrhnlcZQ+K2ZHKjiTIZiMcn4uJFPg48EbQ8w/qd9de89e9VDEuY
	a+lOu/ZhzFkVozcPaUY+mSSIZBiQqeC98V96FkUzHDpZoy5EjQaT4KB00UzyQTPSn9QkuDJ23su
	5rIoaQRDeElIZE7PSJ1TJibMITup0cVTjqJuW0B6AKrbXdybXNUhrEi9d4AKUHU75FSNJBUITTz
	obA33TO2FiKOqosp
X-Received: by 2002:a05:622a:1f88:b0:509:174d:3224 with SMTP id
 d75a77b69052e-51644c810b3mr4774031cf.11.1778723085693; Wed, 13 May 2026
 18:44:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
 <20260429182005.00BF70D8@davehans-spike.ostc.intel.com> <a46738ebd632ff046bc9b0d02a5382de5f2e9f2e.camel@intel.com>
 <7a82a652-f861-4d72-8bd7-4e082af482f2@intel.com>
In-Reply-To: <7a82a652-f861-4d72-8bd7-4e082af482f2@intel.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 13 May 2026 18:44:34 -0700
X-Gm-Features: AVHnY4Jt4QmJWVTzQnyCdXY6sBVDbRk5irYyk1r4A_ldBM-AmDW5rbWOcn1BM4w
Message-ID: <CAJuCfpHBzYUNEe_LBpeERf68_fso=Hy+UZWtqejTUkm1O4NLfA@mail.gmail.com>
Subject: Re: [PATCH 6/6] x86/mm: Avoid mmap lock for shadow stack pop fast path
To: Dave Hansen <dave.hansen@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"ljs@kernel.org" <ljs@kernel.org>, "vbabka@kernel.org" <vbabka@kernel.org>, 
	"shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 229C818000E
X-Stat-Signature: sp6rw9pgwgjr7npb54uyeza9ct5hqrhz
X-Rspam-User: 
X-HE-Tag: 1778723086-32747
X-HE-Meta: U2FsdGVkX1+s1u9uqZVDzyx9RIBPYLVcXWc7bGpueIKE2G6+8zskHw2p4x9jHZNigjBwVkiebfYq79UVaz1LbgoDEb/RG6BBWuafqymtuz7RZKlcBirfyQKXiSB6cM30A0aBy1o/kV1LipeIpGKrdi+0rAOSua8CWokQjwlhgzsbGJg2MCitr0DHH6N0QAY7M/unH2EyjvC1Ld3GgeOul5IRWsBE4lAsOiongcfUV7fT0U2hCXLQDTGBfG/AM0xofb3PzoTttZUdzgisBXyPiDOK6gCLuujiT6mV/kWPlNgXdldBBXGAlf3RWpndH0N2/c79p4pPrcvoTatYNKuXzVlNL5TgrfxuucxoozGkhZuWEGWyVQpzHsS8Rw531SDoVT1bzjnIDYmAwhSXD+z0Sg3CAQwfQkhc13JNqbdqY3jaNcOKSwtQjJk3IqKsiugkWf9Mv3l3ETT+jUX75CzBDeu4SQF2XCVzVtkHcprf0i0GHihtTbse2LS6suwNtL8f2OzpeIx18Yt2D0j27Uvu3bJ7obTOjlJzEbABAMFWPZqP5GUeQqOlkGI0wDaoQ6YQzgy3uMctWlYIEgDOmMrwgEXa2aIEry5WP+XdCHwg5XnYztJ1Lh8x8sQ+TO31uJCcw8i0pZfjh3dgaEdEyeKTkZJgQzhJcQdqtDHYEi+94GhiTxzN5JjYoDUcRbbYCXuiM3ipTvSRMaQCnNE2KFdO0buY64g5pwTzttWYgt/UKblszLvy1QLMsSPdytC88gYncn9mYQyRLf7He4oL47SsNOy4GFeiO5hXJWGou1UcNj0tiVetNPJfy7dNhN2cZeFdSxNTXGBOUpFIKkMJiQvm4n8ClI1gozHudvZflPZDQHk7GD3xcPhoGENgX6MgT6vmSdHGp0ouzyvFn4zXBbP3ZyiKrDGbRmLhjKszjITmHfkkuqn1Q47jWf/wBpaL+qzQz72JzQWeIZPP59ix5Jm
 1+L+MtuG
 nG3p29wWyc7Mru5HuUSNdP4Z9+xFVx+iLm+1VrVB6rwk9nDwF3KbMQS4JHFTDMhnLGuJu7SgoauTUsDP1jbTDMx1a3Ndi6yo422EyA4NloDxfvJGALzse1sCNyVyRW809SS160krbPVVshGX5aoQAmt3u99MeuJP5zTu64dGingoBWseUX4vijTHKX2f8IhBuyQRI3sZbMXteaWyJkQUthRdtnq7o/g5GLBD8HXWus1gx9n3oF4GbKOcGDD9jgV+Q4uC+9Q0jY8sdjKpTYRVF3PXGeKnn2Y7t1KH1utq7RMq58wLjZ3JIU8eihtllKZ7kIJ3lSEIIDvvY9WfNghSAHY5nPjf11rPqjMopTJh6BUYr1LkXxVj+FcQzUZSEwxAlPfglSh1vE3P0KSM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 5, 2026 at 9:39=E2=80=AFAM Dave Hansen <dave.hansen@intel.com> =
wrote:
>
> On 5/4/26 16:15, Edgecombe, Rick P wrote:
> >
> > I guess the problem is the lock ordering. Not sure if there is any slow=
 path
> > avoidance details that could make this splat a false positive. But how =
about
> > this simpler munmap() case:
> >
> > Shadow stack signal                          munmap()
> > -------------------                          --------
> > vma_start_read() (VM_SHADOW_STACK check)
> >                                              mmap_write_lock()
> > mmap_read_lock() (user fault) <- deadlock
> >                                              vma_start_write() <-deadlo=
ck
>
> It's a little more complicated than that in practice, but I think you're
> right.
>
> I'm not sure when this would happen in practice because the fault is
> actually on the VMA that's being held for read. So I think another
> writer would have had to sneak in there and zap the VMA.

Not necessarily to zap the VMA but to modify it, which requires
write-locking it (split, merge, remap, etc). Note that write-locking a
VMA always involves mmap_write_lock() followed by vma_start_write(),
IOW we end up write-locking both mmap and per-VMA locks in that order.

The lock ordering when we take both mmap and per-VMA locks is to
always take mmap_lock first, followed by the per-VMA lock. With this
change we read-lock the VMA first and then call
get_shstk_data()->get_user()->might_fault()->might_lock_read(mm->mmap_lock)=
.
So, we take per-VMA read-lock and then mmap_read_lock and that's the
problem.

>
> The funny thing is that the fault handler is really just trying to find
> the VMA. The thing causing the fault *has* the VMA. So it's as simple as
> just passing the VMA down into the fault handler, right? How hard could
> it be? ;)
>
> There are still games to play, but they all involve dropping locks and
> retrying, like:
>
> retry:
>         vma =3D lock_vma_under_rcu()
>         // muck with VMA
>         pagefault_disable() // avoid deadlock
>         ret =3D copy_from_user()
>         pagefault_enable()
>         vma_end_read();
>
>         if (!ret)
>                 return SUCCESS;
>
>         mmap_read_lock()
>         vma =3D vma_lookup()
>         mmap_read_unlock() // avoid deadlock before touching userspace
>         // check for valid VMA to avoid looping when there is no VMA
>         if (!vma)
>                 return -ERRNO;
>
>         // uh oh, slow path, something faulted
>         get_user_pages()??
>         //or
>         copy_from_user() without the VMA??
>
>         goto retry;
>
>
> This also needs some very careful thought, but something like this
> should work, where we avoid fault handling (and lock taking) in the
> actual #PF and do it in a context where the VMA lock is held:
>
>         vma =3D lock_vma_under_rcu();
>         pagefault_disable() // avoid deadlock
>
>         while (1) {
>                 ret =3D copy_from_user()
>                 if (!ret)
>                         break;
>                 handle_mm_fault(vma, address, FAULT_FLAG_VMA_LOCK...);
>         };
>
>         pagefault_enable()
>         vma_end_read();
>
> That's effectively just short-circuiting the #PF code which does the:
>
>         vma =3D lock_vma_under_rcu(mm, address);
>         ...
>         fault =3D handle_mm_fault(vma, address, ... FAULT_FLAG_VMA_LOCK)
>
> sequence _itself_.

IMHO that looks more complex than the original speculation+retry solution :=
)

