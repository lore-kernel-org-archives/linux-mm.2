Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44B76C88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 18:08:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4846D6B0092; Fri, 11 Sep 2026 14:08:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 407636B0096; Fri, 11 Sep 2026 14:08:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F5796B0098; Fri, 11 Sep 2026 14:08:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 075E56B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:08:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 71BD116030D
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:08:53 +0000 (UTC)
X-FDA: 85202267346.12.4A11E64
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6A29110000D
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:08:51 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GXvmJgSz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GXvmJgSz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789150131;
	b=B/CZ4Skh8p1fU/ExFIj/M0ZvmO10K0vSFyB5QFf4mZmhgTrJQj7BFVBk8xYWmuodTCqAeS
	I7hj3HRYEe42PYyJPlM7nwZC41GquSanVK6keHEJDdMyuchkqcJhm0Sg1jTRoa3xIm2IL4
	7AISj56w4wwN02gXmKYkxn7aJNloonU=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789150131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G3lYyGqHKOjMfd0nQzQBuRt7mmmFYg8CXav6CCXPIUY=;
	b=JAV0oBpdYG4D4EubnWEmbh+PjuqTYpB9dRhbhV8njKJFbO+tul+X4VQCTVG5KBY6q1OuvT
	7LIY2wL8C7KHjH54BXjstsHaP9FVu2FDqmohmqzjUutQXg/5X//w5vb98d3o/tgKUEB1A+
	W0QQ5jzq4vA7OG53+R/rR/lPro6a+vE=
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-5306706e89dso80781cf.1
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:08:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789150130; cv=none;
        d=google.com; s=arc-20260327;
        b=rHxT5tizIi+MLF0OUJpGap+7YYY3mCJ0zYb2+70UvQY0lHsrNlENQqrH7MmN8EtloD
         8gN4Omttfi+oeVIhttNFdXhQMxP7ABMHOhVQvMCHtPQwnVVY6ReKPLuHJ1q9tz9A9GUY
         BW+ask/F5PeM1SzEryQ5HsuuxpNICoCSzoJhn1ksHrO9yl+TeP5cppZv53f+Gl5SR1ox
         8z2dcrANY3/dQFSBnxgb3KxPYk/O/9Afw/1/ohxBBsSukdRt52w26yiQI8OK/MgoCruf
         8eXq1ILvTfcAdOu79TZ77teVDWE/12AQSIQ4SgdQ3RDhP19onIemBCGbp69YOFTXsv73
         0D2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=G3lYyGqHKOjMfd0nQzQBuRt7mmmFYg8CXav6CCXPIUY=;
        fh=pTd7z/ZgQ2S/kPxzD8Qid8WVvDbLOVbl0BF3Vd371mE=;
        b=g50ubX/siYhyb2nG5f2+tbpLNyER9Obt43F118AXGDsH9vas29IHjOkz3RUosFtA6l
         517tC54wEXny6LR1oYqRepIrcWS5FSmJU1klXBAEOvNbxNONlSAfEphxlm5wvB1cfBTx
         JlQJdDwyyxvqXWal/xnUyN4wz9Cuw5UTBVi12sQv2qwyPnRLN9Qap/9raYLP+Qs5ehyh
         E/crayIehnrqE7ae0+yuAGnjFluuqbhgvkDCL3PsSjC8YWaB4sQ8riaajxNBoINKU8Oo
         O/OFZq9TREhsgARG1c7MfxVWEOcb/uPGjMGQt1BYbP/+zkUbyAC2sX5sgxEk1sWtIDUq
         aeiQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789150130; x=1789754930; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=G3lYyGqHKOjMfd0nQzQBuRt7mmmFYg8CXav6CCXPIUY=;
        b=GXvmJgSzd9dSWrROyFB+CrBHXSVpGg6oP6GO8+pEnT1eKNZ87k9WNqKVveLhuee/G9
         VMiZgowkVATw/aJfYpq4SxhuCgcYlRKQmMYHqZcbvIyj3YTdjHKaH+HQRqA/BsqeEPdE
         aCPRhynZIqT/U804b2QeYtyVGtAnEXsMR4kHfnvBZIO5kLNdoBSgrEi3C2D1VRHZ9Kn5
         DpZEqd8glRnrJSwznmHLLDpUrRw/1TX+/UXD93rC2Lzz5GmsEwA7rFG6qefN52RItnaX
         /E8hzNfkzJ1HrYajaNpzmXHX6Bh9J69IRBtQlCSvZMgSmVmg2HBpz/Mzfex02Ok7LnQB
         T+0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789150130; x=1789754930;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G3lYyGqHKOjMfd0nQzQBuRt7mmmFYg8CXav6CCXPIUY=;
        b=nGE+EK9PQw65UfNw+Cyadbf6ea3PO7HawOcV/mQoDrFGLNhBQb+UQJnoIP31HWSuyC
         pCBFLzhqbtcP3+oVSLWxY/IVLN5xT2A561o6i8NfmDLEd7RTX1phMYQ7JAXgYosnMngt
         wtCWM69czBr++enzR3/dFtRMwP1jeY9pOZ4cA1SltQif7qUmhy4vkD06Hyg82QENKjwT
         D6ktiS4MOWPH5a+bQRVB33nZXDtvlvDoiCGGrC1fL+OLNEa5/e/+JS5USz2Pc0sOK/Cw
         lo+GYvVFohV4tpjSFL6pMYnei7/Aj7oTV6jwpdzgAFKHS2zzVVMVD/aW1VWMDmP/5Bqn
         kAfQ==
X-Forwarded-Encrypted: i=1; AKwUvBz8+avDA7n2wVBwCaX3xHjSGS8cwQPMGjm12ziUhMWZlCzt7/1YQ/WNboEkaRdtC4LCrlT2ZZbQfQ==@kvack.org
X-Gm-Message-State: AFuF++mu8p0uoq99mOYSOZGigxYNJcKifcmIFR1t/Dee/X+n6dxpohG7
	Qe9roXeBz7oSzyqdTkd5pv4AyEzUq5lZhLCBJB/G/1NlhrFZUCXg+S2zAA+QlioW0HT6+vAGvLK
	KdHH9saL/cYHu+Ezz6nOI5XD2fZnDy/L2XB1hL3nV
X-Gm-Gg: AYBFou3wagiUiF/8twwwP78E6gUxJGRqycX0wx1i99DbZGWOWW2ENjxpd8Jo5S/cBLV
	GtvQHG+g3kIt6Pty8n7PUmyXVCZCpVpcVDn+SDs21IP5E+OJ4etgCYbwGF0DIePxAwTww4Nq+dB
	ergWdpyccmwliVjaF/Ud3PgUjxymXkkmMLoY3AaW9eR5F8yqk6IkA7VAfrLCzlEyEAGhCewYK7D
	zESPnGV+azY2+rHlWD1gMzdLlVcye0zvo+EK97zplf0VMEOFpFBYr87MnAfYNSyI/dqn6uCjO2w
	R1QhZg4y6+x/1I/hxftnRgP/n9zG8uF8rrM1S6xCVMJjdnUVxRc6i+3sc29ogvKlJnlz15OR9GI
	SXoXsVsdtvQ==
X-Received: by 2002:a05:622a:124e:b0:530:d8ce:c26f with SMTP id
 d75a77b69052e-530e46f45camr1234961cf.6.1789150125329; Fri, 11 Sep 2026
 11:08:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260910234737.1340642-1-surenb@google.com> <20260910234737.1340642-4-surenb@google.com>
 <aqQoPTTUC9M5HkYb@gremlin> <CAJuCfpEHeFSMamNhf=FLvFjh9D8DBwZtbKwL0zi=x-2g8B+ENw@mail.gmail.com>
 <aqQzk2AT05r6rOyT@gremlin> <CAJuCfpEMd=hVtwe_9Rp1kqigYJwqEUGCD+ViQmoacAZONCR6DA@mail.gmail.com>
 <aqQ_cPerswqY9ZPL@gremlin>
In-Reply-To: <aqQ_cPerswqY9ZPL@gremlin>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 11 Sep 2026 11:08:33 -0700
X-Gm-Features: AcwNN1XgFF_qGTm7m9tvRDVhYFWJVU8m1f8OKlmITfXyXo13YNbSPwvOnx3S2VE
Message-ID: <CAJuCfpHzjvd6wKT9XN5BUSWnrGHhcaPVOyr1rb0bJ-fetkKhvw@mail.gmail.com>
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
X-Rspamd-Queue-Id: 6A29110000D
X-Stat-Signature: tnmi93k6hi3fy45z8jeck15djdoczixe
X-Rspamd-Server: rspam01
X-HE-Tag: 1789150131-22243
X-HE-Meta: U2FsdGVkX18gGO+6gdRy4l5Rv4YWKNTRgkL88YDyA/lR2SmJiRpmtoRArcwAg66P8knp0wH9VD2sby7LUzRthwQT/1xo/SoULNg6PLI2HBeda1v4APl2PsOtQAcyySB9MHW4xkJPnST0Mk2txLmO8gHvSIsdBF+2D6lhoKMc7p5Y6bbT3tThQJWD6kOLOk/Sadn3mSZTKnYbvUFmd1GAZ1qx6ngOV/GKsjtl0jDRFjSTNxTnnycCelk1L6UfDAV4tWNaRBh9aK+tsPNTDGTTp20wSTrVX+KytD03puJUSFJRrKgn+Y3yn8Seo7hqCCV1cMJGV2o0OKml2K2IYpyAokGDcCjA4qniH547+E8d65YSWfRV2xCMn2LbX7NAKEsUAjUH9kn3VVgUF/D4B3f/svz2nM+kk8IuRqN9wAAfQ5DQxqKsH2oNYJsfBvnHIgVElQcZYN2lKMAfRjRd8juXcHvZKxod0tvGyKPbVeOmB4Dg6npvNOs8kguQzW14DYIIGkaAj1Ohb6JvVA2kDB7XkPXirRIYjF9YjkqkiHvZtI7y5EXeAQvXZ/ay734Ct+J4HKjVra9sajEGtiarASwKSUlSFO823J5tBHMNcgg0UTzCBQ7qrCBRDgXz8gYpRSgOo6LjVbEfl0v1YRGSrZftDdlsvT/UXNeTEqb9uicIGmVxqWILU3jCe97FepOIj0nx+OmmvEnXsOPBnjeynYfByZMiKkBdJuZkEfxd8mmKaiojEb2YXmDbpS5dxNVGMDDt0MjGpteG37l5DiL372mj33E0VVZccIThFa1gygtLT+X2ZXZNEuJgic6OBjlU50AdEUIhBCqzjfFbdmI7zedYwZa7dAovGN/t9CgDK/BXHiaRAZ5EFphLfSpZAAJowJk7X99G99oLb/pyailc8gqI4cYLrycrMYSSuM8bJLIhTQ+i2H9uejmJVGfBBSS7LfrRyNIOvRe4urlUihULMu0
 jvWNCljD
 0LVaBd/pbgkTTkZL1n9gbb9eJ7zmitUVy2Vx2WQb5gJltqcQ0mTTfpX+tOrKcj4XTSlbWjic5l3N5z77TjRd2jONfi+dqOti2Ppui1UZ7uqCWOB9xZB1qK9mAAKZmmMTb0lRifWyb6LfkWnO+xCKpjt1wBaMVGJctlp8nPXMzUkKIoIn3DmmOAmF1Ze3iWrhej1SUje5pWHTkQwexB6b9DXj9wbuJC/2Suf+lD+xUwtDTPD4LuPLYwhjP6yoCRDADxcXHs2aDsirL/wVVa64O68+HpEL41dtTp6RgemDEQXi/67ckAQ4jy9OfDDE3TLLK5fJqlCurzsm/aNbvLBsuV1ibpXTDC6G/iFDY4WUQCU0k+mpl8W3UpEEMzahsUh9CclnIT3e01VRO39OBRBKa2c+BkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 10:56=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.=
org> wrote:
>
> On Fri, Sep 11, 2026 at 10:39:01AM -0700, Suren Baghdasaryan wrote:
> > On Fri, Sep 11, 2026 at 10:10=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@ker=
nel.org> wrote:
> > >
> > > On Fri, Sep 11, 2026 at 04:58:40PM +0000, Suren Baghdasaryan wrote:
> > > > On Fri, Sep 11, 2026 at 4:28=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@=
kernel.org> wrote:
> > > > >
> > > > > On Thu, Sep 10, 2026 at 04:47:33PM -0700, Suren Baghdasaryan wrot=
e:
> > > > > > smap_gather_stats() optimizes stats gathering by skipping the w=
alk for
> > > > > > shmem mappings in certain conditions. Update the comment to cla=
rify
> > > > > > these conditions and use vma_is_cow_mapping() for COW identific=
ation
> > > > > > instead of open-coding it.
> > > > > > Instead of using (start !=3D 0) condition to identify partial w=
alks, use
> > > > > > more semantically correct (start > vma->vm_start) check.
> > > > >
> > > > > I don't agree what you're doing is semantically correct, it's a h=
ack really.
> > > > >
> > > > > Callers are passing start=3D0 to indicate that the entire VMA sho=
uld be
> > > > > processed and that happens to fulfil your criteria but in a surpr=
ising way.
> > > > >
> > > > > And the start in these cases is corrupted.
> > > >
> > > > Well, the "other" Lorenzo does not agree with you and suggested thi=
s
> > > > approach in [1]. Specifically, see the comment:
> > > > ```
> > > > I also don't love that 0 is taken to be 'start from vma->vm_start' =
and I
> > > > also don't love that the code in smap_gather_stats() actually speci=
al cases
> > > > this...
> > >
> > > I'm not sure what part of this is disagreement?
> > >
> > > It's saying passing 0 is a hack, which is one that is still in place =
and which
> > > this patch makes worse, because instead of explicitly calling out the=
 invalid
> > > value, you're treating it as if it were valid.
> > >
> > > >
> > > > How about passing last_vma_end and making smap_gather_stats() more =
sane? In
> > > > the other invocation of smap_gather_stats() we could pass vma->vm_s=
tart
> > > > here.
> > >
> > > Yup, well me of 3 months ago should have suggested what I suggested r=
e: wrapper
> > > (I think you cut that suggestion out of my reply).
> > >
> > > > ```
> > > >
> > > > [1] https://lore.kernel.org/all/aifO_rCurVhFRTcl@lucifer/
> > >
> > > >
> > > > >
> > > > > >
> > > > > > No functional change intended.
> > > > > >
> > > > > > Suggested by: David Hildenbrand (Arm) <david@kernel.org>
> > > > > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > > > > ---
> > > > > >  fs/proc/task_mmu.c | 24 ++++++++++--------------
> > > > > >  1 file changed, 10 insertions(+), 14 deletions(-)
> > > > > >
> > > > > > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > > > > > index cfc7af1b551d..3c40c9cbb9c9 100644
> > > > > > --- a/fs/proc/task_mmu.c
> > > > > > +++ b/fs/proc/task_mmu.c
> > > > > > @@ -1257,6 +1257,7 @@ static void smap_gather_stats(struct proc=
_maps_private *priv,
> > > > > >                             struct mem_size_stats *mss, unsigne=
d long start)
> > > > > >  {
> > > > > >       const struct mm_walk_ops *ops =3D get_smaps_walk_ops(priv=
);
> > > > > > +     const bool is_partial =3D start > vma->vm_start;
> > > > >
> > > > > Yeah not in love with this, without changing how it's called.
> > > >
> > > > See [1]. This is exactly how you wrote it at the end of that reply.
> > >
> > > Assuming you passed vma->vm_start, not 0? Passing 0 makes it really s=
trange.
> >
> > Ah! Now I see the problem you are pointing out. Ok, in v2 [2] this was
> > done correctly and that's the way you want it!
> > Okay, I agree this split was incorrect. I think I'll move is_partial
> > conversion completely into the next patch and this one will only
> > update the comment and use vma_is_cow_mapping() instead of open-coding
> > it.
>
> OK, it probably makes sense to have the CoW change separate.
>
> I replied on 4/7 about how I think that should look re: wrapper functions=
.

Yep, refactoring the patchset as we speak. Should be ready shortly. Thanks!

>
> >
> > [2] https://lore.kernel.org/all/20260907063918.3432401-4-surenb@google.=
com/
>
> --
> Cheers, Lorenzo

