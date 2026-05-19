Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8932DCD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 18:41:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B88E06B0005; Tue, 19 May 2026 14:41:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B38F96B0088; Tue, 19 May 2026 14:41:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A013C6B008A; Tue, 19 May 2026 14:41:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C3516B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 14:41:47 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2E0DC140918
	for <linux-mm@kvack.org>; Tue, 19 May 2026 18:41:47 +0000 (UTC)
X-FDA: 84785038254.09.7E82142
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0D660160006
	for <linux-mm@kvack.org>; Tue, 19 May 2026 18:41:44 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LzJJ9aUm;
	spf=pass (imf08.hostedemail.com: domain of shy828301@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=shy828301@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779216105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sgMtJYuaR0izLLaK1FUWPlLIzmxQrZ1MxrGID/mYXGU=;
	b=0oP6m4AqH1vbCuiaKg0E1M7O47FtAdk1dDjjMvKKJy9bNcyjCcOcE6Bt6EpAv49CE9Vz9a
	p8lNYXQiGRQIbHwbLaCrZJRRocRU1UvEp5/CfTmE3707ydSaosO7yYTjCiZvZ+4rP2MFRF
	NjnXQhM7gqEohY8ZELH8mlKXkVQ62Cs=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LzJJ9aUm;
	spf=pass (imf08.hostedemail.com: domain of shy828301@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=shy828301@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779216105; a=rsa-sha256;
	cv=pass;
	b=q3M3VDfeDEOYsDjCWb9xem+9GwfPScNn2bSa8lD1nNF7Pi8FYyWH3U19z9rqGfuKN1hRQh
	YgyzyrfFvfqoR1b8ju8d45rUYDr1ER4n9yAB4O9sL4Tb/42eml01/lhiTtFtjc31ljEWLd
	MHycX2k3mNn3ueloJ/bxS3j0l+ZFHZw=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6870f904c6bso36372a12.0
        for <linux-mm@kvack.org>; Tue, 19 May 2026 11:41:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779216103; cv=none;
        d=google.com; s=arc-20240605;
        b=hPW7K5Ukf9K/CRDR1gS/mu/n5JnaVvk+3UqkwlyByT9SqDmIPnUaOX9IqfkwudPDPr
         9VPNnrw6icR0xGPI0RV5KSsMKTVbbrntcg7G3524+u57G6tunH4bn7gGswWraaQUYYpR
         ifmSMxiNbkP5Q4vW0mJJWr7WXN42e0HWiD9D6fyOeNn1hvs7HrV9i6dPYXJtIYrc1YSi
         Vor/nMg864sgh+UP23Sj94bHA0C0LG5hMJCFWdmH6RfIYApLGO00Uy5aNmdCnCeQmKOk
         yZDX6fFAU4P6MvDvmAj/oFv1fUxAZdaz7xNs9oSjyY4IIirkeYhqmDzT4gvYR4EYKo0P
         EVPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sgMtJYuaR0izLLaK1FUWPlLIzmxQrZ1MxrGID/mYXGU=;
        fh=dA8qw5NEomNxNXW3t88oiY4JrddeaIgo9CKwccyrkh4=;
        b=PUJCuj34GeTIeY8afAUFm4/NppNulIt7o9ozCsPiD99zDrzWEHWek+uZg3eazX5D5L
         e8pkGWPf4g1SepXi0NVYZiFtXFYEdWYwleCBA5MT5rVLSplX5d2xHSzOzLjLx/z1PcUc
         fKihcZy5Ul9MVRnVaPyqT2eilU2cxkILoEDJqWEMMgQSySy4rnwtSojh6HgES9zkNsCz
         Kv4f5cGVsuIn2CnE4+Gob/XHcBSNm963C7rcrAJkjv2+5+9Qerr8QkhpgljUtnWW3HTK
         Pgg4INH6chfMiB+Gy5WbAeYGJGgeO+GIThY0D48Cf6C9HFCgYBqRU36ZAQ1KeZoJZmTR
         HLhA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779216103; x=1779820903; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sgMtJYuaR0izLLaK1FUWPlLIzmxQrZ1MxrGID/mYXGU=;
        b=LzJJ9aUmZcnJPI2R7apT6y83io7pR3e3LAFmfpDiLkods/szEByhEf9Y42vKlK18+h
         b0ii4mOLXLtVVdb0vFCEuuyvGDEI2c8sJJiBq8JfrW8lsyrgRtZZiS8a2geqFxvIBU9N
         t+Vgu62Tf6UeeaIkt4hDq/Yn7Fkjwvu9Re62FxB9r2sqKt9yWlvhZKFP4+4sIV+aphoq
         YZ1o7jGClFvDPregI4w/OxbNNl98xcWOQe+rVKOYBZ4tO4WRQuwQra41f+OrD+9mtYp4
         A33Bq4+pkvkAaPhJc1tVH5qVQHDJUMqXXWdLcySXx1WeC6X9z36qonI+RfHrj4Zzk4oD
         S1cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779216103; x=1779820903;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sgMtJYuaR0izLLaK1FUWPlLIzmxQrZ1MxrGID/mYXGU=;
        b=KXByWHFNH0D9mYBCnbOdVzPLEz6n4BaBBBDABlpoF0pjmo2AJZi29IyYE7C6+i1Lqk
         niK6RGucdiXhZACJ/3r2AXAHr/NvwfmHu8DfIA2NFBWodKWoARp7Pd2ZH3UJCkUNY+Qv
         /k3NQ5mj2iY7hZj46XFZCmBOXqYpDKEHFN3HN9ih5FX/jczNvtF6BRXWj54MDN2GqI2c
         +PDfeTkwvdtbQpG8OImKXzjp4nwHsjE3EExqM5xmWxl8B1dijhSGeR60GVTr+cXBc4cr
         LnX1hHUzfGzhsUeIk9PiGV53FfhwlX5ihYlfb54PhWjQSLJFlOp+Jr2rdnmLg2iJVwq3
         f27w==
X-Forwarded-Encrypted: i=1; AFNElJ9gCaII7q1dJYb0p16BQN8ORkLddT08cx2/PtxceTqyyGFHZqNDZBok/cSCKUB1j39d6GKeE3CB8A==@kvack.org
X-Gm-Message-State: AOJu0Yx95pC3KoBuaHKp9xIWb6a+8I6PEci+OANJYi2HVLatgNbL740K
	oZ+mT98DCLD0qv5yt+7zhSV0RsvaVQGDIq7bKjY3ZkSkwW/0d+d9i0EINSieMZz4Tj1wD2VuA+I
	D26sIyTS/6cdBDMsNyXbaZBOnqjke5vI=
X-Gm-Gg: Acq92OF61YP+6xNpUntSb3+Mlcl6jbDJayz8TYsF7yy777Su7XTcJC2tXj9MmquFETH
	VvxSSwGvLF6LnWZwPVYmWNL7YjgiVIc90xZP2IynvOQljLh9rDTgR+br6gYqHv9R+zVtj0StgQZ
	t9Yq4X+x0N1Hi9iY7UxKtBXZXI1/6jmdvvK2uylRXm3GZfBsU1DKZP1N7gW5IRq5SrKMnKnV4+V
	jySsNHTBvo3rPcIqt/7AULA6L4OYq0A92GCfG6f5gK6rJtVGfdTHCv+bgTtajM3jm1AyYmWJ/SM
	wKHAmWkNPQ==
X-Received: by 2002:a05:6402:524c:b0:67c:96e7:3427 with SMTP id
 4fb4d7f45d1cf-683bad350f8mr10588073a12.0.1779216103209; Tue, 19 May 2026
 11:41:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260430040427.4672-1-baohua@kernel.org> <afNM-gIqxpyJ6ro7@casper.infradead.org>
 <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
 <afS_L-5XeWIldTXA@casper.infradead.org> <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
 <afTpoL3FklpQZNMM@casper.infradead.org> <CAGsJ_4ysMcrmDLSOwBkf7qwCQrcDWeEMXkHDajTJFMLKUk0bSQ@mail.gmail.com>
 <CAHbLzkrOSoh-jmR=uaNvx73n_wn+vExoKY0UzH5zGcfdAiDbNg@mail.gmail.com>
 <agxfLNuLCAT3F4cW@lucifer> <agxnJ8R-G3CRjeTR@lucifer>
In-Reply-To: <agxnJ8R-G3CRjeTR@lucifer>
From: Yang Shi <shy828301@gmail.com>
Date: Tue, 19 May 2026 11:41:30 -0700
X-Gm-Features: AVHnY4KjLtyViRy-FP1MJx-LYZJZfACCXodkXf2RGwVY3_NriDPxFvXtK5Jn_zQ
Message-ID: <CAHbLzkpjOLrdRSUF3-G4d9uz6tn6QYwgB66UU9bud5WHr5FWEw@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Barry Song <baohua@kernel.org>, Matthew Wilcox <willy@infradead.org>, surenb@google.com, 
	akpm@linux-foundation.org, linux-mm@kvack.org, david@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, mhocko@suse.com, 
	jack@suse.cz, pfalcato@suse.de, wanglian@kylinos.cn, chentao@kylinos.cn, 
	lianux.mm@gmail.com, kunwu.chan@gmail.com, liyangouwen1@oppo.com, 
	chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	Nanzhe Zhao <nzzhao@126.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0D660160006
X-Stat-Signature: gtqdf17oybsckhubxhzniz5kqnf85zaa
X-HE-Tag: 1779216104-998872
X-HE-Meta: U2FsdGVkX19iPxuwoDLrmiRwrlOAsKAr7qMc7qRoLuK91z/ZuJKMPlBj0MHXDLcpzQSUrJDIAaq/nBYKur1Tk7YnxE3kgpnRCA+WrC5gXEY/BjVTl5zjEKoNIlgmNUz4T2/xk1Rua15upaQwKibtbCXtEYkxjT6JsaFQeylItRCWN/k5sbXYcc5dyX2HQESAZ4XFrhVH4Sfe0BZjzXGiiU9Gp00Q6dMYoIn2FunVbHseBzLsmON24xqMy0oNWWNuxa08HKm6eWiBaYOTjidWmaNS11VejWZhShYcq6gDsdN73I7eBwFY+8qVkB/ziasR2wsCAZOdzyDJHotMhHCfF4l+yuU3C4YtotMhkwkFSVYR71Qbcr22DuRyWLPczpwk94Pq3D5s9TrA6K/SK0qcJzYMeQEWsHmvYUpcrV1mxyfLkg7kOUDk7h8dkIUxKMA/p+EgIeEeD+5xX9/4DqAWG9grqGF9kkRZbqBzPRiPccOi1xKKYxmUvm12tUuFeeaLWgGSla1h8i6UWvAI0UFu1NhX9WMrznZDXsYfypjrDsis8dgANLWtSzGxRVIFTtDsbpJMO5i/C1YUFAVSflLYg21VQg64Ci0RKFNiY8zk9OIiQjPDQvfk4G3U7a59MWQ71DY8IQbJ9OglN9iL1KmlaHJX58W6gKnp5zA/3EP1F+C79Htm3FejYIfQIm2qzNywTumMilYVJh71+zQNlYTJzoK+51rZqTYC9lP5jVWl8Vyx5gw4eo81T9xhMInwabOOvbuVPgqhQqNxF7rQ1JZFgsakybix1qWbaHxijgpzsXhrnUMq9fOqylrTdI1sBXqbd5GrekXFzIqGu9Q0pzOY+0CxooEMLav8INSGlbIygjsWCEEbjF0kmKZfxr5Mzo5ULdjZpOyZqo5lQkVyJnyQ0gpCTwT04C9gEOFK98loZgCNK5smzQkcYo8m31O1Dauvu02Orl+Lciu2mUXAXyc
 o3SmBdLS
 Kj08xy/uGmXubVluaDzfTF8bcOhONwz9B1UKYLtCNT9E3VeskKBeZTbi9gs9A+Job5xzUXJuwnMlWyoiewHkug1FvKuGL47Z2Q7HhZHJgTc2C89WRjgM6XBh36tva9pxhMbYDtLvIFAzj05Wgp6qwQgL+G6W2uRjy0AJP963N7r3zr3JdhAfxigkkxijzEQQCz080H/bDkgtHdsabLehRUqktFgd6jNeATQVUwTHY6htcgUu3ueKce+JdDBj6qy0/BcrH1/ZZUl9PRIx1LBHiVLTQGfvFb2OEP8K6B5jJSa+B8332fjoxPEYlUJW8o3uH1ByWRo/kxzxFI5zAmeAZYdl2lrn07w5cB6gDCKbu22R/eLA0hrEgmbJFJc+GHE9kOlP78Z6sw7nmMVOUyrmsP1SnG5wg52NXLZqTTENZ8g8FPt6uUZzoZyL98MR7ENWcU3CyMgyuusNlzy5Ev7Hjg4bIdpAtZbVaD+/xVYNyjAWSY/0GRzwFWCSlArMRSEtv7schtBiXZZ/nejUsIDRdVgGAOaL47LxY1Q+BJJRPWGrgaFZOQbG0byKiYDJaE6IHZDTeT7hYof7I+T+ER93ZzW/WBNTjxb0QvNhO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 6:39=E2=80=AFAM Lorenzo Stoakes <ljs@kernel.org> wr=
ote:
>
> On Tue, May 19, 2026 at 02:12:10PM +0100, Lorenzo Stoakes wrote:
> > On Mon, May 18, 2026 at 02:21:14PM -0700, Yang Shi wrote:
> > > Maybe a little bit off topic. This is an interesting idea. It seems
> > > possible we don't have to take vma write lock unconditionally. IIUC
> > > the write lock is mainly used to serialize against page fault and
> > > madvise, right? I got a crazy idea off the top of my head. We may be
> >
> > Err no, it serialises against literally any modification or read of any
> > characteristic of VMAs.

If I remember correctly, you are not supposed to change VMA
flags/size/mm pointer/vm_file/pgoff/prot, etc, under read vma lock or
read mmap_lock.

> >
> > > able to just take vma write lock iff vma->anon_vma is not NULL.
> >
> > Except if we don't take it and vma->anon_vma is NULL, then somebody can
> > anon_vma_prepare() and change vma->anon_vma midway through a fork and c=
ompletely
> > screw up the anon_vma fork hierarchy.
>
> correction: this won't happen as per Barry (see - I managed to confuse my=
self
> here :), since for vma->anon_vma install we take the mmap read lock.
>
> BUT we also have to consider other cases.
>
> >
> > So no.
> >
> > >
> > > First of all, write mmap_lock is held, so the vma can't go or be
> > > changed under us.
> >
> > vma->anon_vma can be changed.
>
> Correction: no it can't :)

Yes, vma->anon_vma change should require taking read mmap_lock.

>
> >
> > >
> > > Secondly, if vma->anon_vma is NULL, it basically means either no page
> > > fault happened or no cow happened, so there is no page table to copy,
> > > this is also what copy_page_range() does currently. So we can shrink
> > > the critical section to:
> >
> > Firstly, with no VMA write lock, !vma->anon_vma means a fault can race =
and
> > secondly copy_page_range() checks vma_needs_copy(), there are other cas=
es - PFN
> > maps, mixed maps, UFFD W/P (ugh), guard regions.
> >
> > So yeah this isn't sufficient.
>
> However this is true...

Yes, fault can race with fork. Basically this is actually the purpose
of this idea. We can have improved page fault scalability. In my
proposal (take write vma lock if vma->anon_vma is not NULL), the race
just happens on the VMAs which page fault has not happened on before.
vma_needs_copy() also skips the VMAs which don't have vma->anon_vma.
So there is basically no difference in semantics other than more page
fault races IIUC. It should be safe as long as we can guarantee there
is no writable PTE point to a shared page after fork.

For guard regions, it can be serialized by vma write lock if
vma->anon_vma exists. If vma->anon_vma is NULL, it will prepare
anon_vma, which will take read mmap_lock if I read the code correctly.

I have not investigated UFFD yet.

>
> >
> > >
> > > if (vma->anon_vma) {
> > >     vma_start_write_killable(src_vma);
> > >     anon_vma_fork(dst_vma, src_vma);
> > >     copy_page_range(dst_vma, src_vma);
> > > }
> >
> > Yeah that's totally broken fo reasons above as I said :)
> >
> > >
> > > But page fault can happen before write mmap_lock is taken, when we
> > > check vma->anon_vma, it is possible it has not been set up yet. But i=
t
> > > seems to be equivalent to page fault after fork and won't break the
> > > semantic.
> >
> > It will totally break how the anon_vma hierarchy works :) See the links=
 at the
> > top of https://ljs.io/talks for a link to various slides on anon_vma be=
haviour
> > (it's really a pain to think about because it's a super broken abstract=
ion).
> >
> > You could end up with a CoW mapping that's unreachable from rmap and yo=
u could
> > get some nasty issues with page table entries pointing at freed folios =
:)
>
> Correction: actually we should be safe given mmap read lock on anon_vma i=
nstall.
>
> >
> > >
> > > Anyway, just a crazy idea, I may miss some corner cases.
> >
> > Yeah sorry to push back here but this is just not a viable approach.

No worries. Thanks for all the feedback. Just tried to explore whether
such an idea is feasible or not.

> >
> > And this is forgetting that we have relied on page faults being blocked=
 by fork
> > _forever_, who knows what else has baked in assumptions about that
> > serialisation.
> >
> > Forking is one of the nastiest parts of mm and has had multiple, subtle=
, corner
> > case breakages that have been a nightmare to deal with.

Yes, this might be the biggest concern. The page fault can race with
fork. If some applications rely on such subtle behavior, it may break,
but such applications are fragile too.

> >
> > So I'm very much against changing this behaviour to try to fix somethin=
g in the
> > fault path.
> >
> > We should address the fault path issues in the fault path :)

Yeah, this idea was inspired by Barry's "not take vma read lock
unconditionally" idea. Maybe irrelevant to Barry's priority inversion
problem, just an idea for further optimization on page fault
scalability. This probably should be a separate topic.

Thanks,
Yang

>
> Above still all true though.
>
> >
> > >
> > > Thanks,
> > > Yang
> > >
> > > }
> > >
> > > >
> > > > Based on the above, we may want to re-check whether fork()
> > > > can be blocked by page faults. At the same time, if Suren,
> > > > you, or anyone else has any comments, please feel free to
> > > > share them.
> > > >
> > > > Best Regards
> > > > Barry
> > > >
> >
> > Cheers, Lorenzo
>
> So still a nope :)
>
> Cheers, Lorenzo

