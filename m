Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 778BAFF886F
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 20:39:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 874036B0088; Sun,  3 May 2026 16:39:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 824BE6B008A; Sun,  3 May 2026 16:39:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73B1C6B008C; Sun,  3 May 2026 16:39:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 630166B0088
	for <linux-mm@kvack.org>; Sun,  3 May 2026 16:39:24 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D6EB1160593
	for <linux-mm@kvack.org>; Sun,  3 May 2026 20:39:23 +0000 (UTC)
X-FDA: 84727273806.16.E27E87A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id C940D1C000A
	for <linux-mm@kvack.org>; Sun,  3 May 2026 20:39:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AaGWexQ1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777840762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yy36aEN1ISq3rx8gbkVjtmwzFJPPiPu+6w78nwiNyyA=;
	b=PNElYxmFLjNn7LQ0YDYCAvCo6oZAToHT3IIvV14XzgKAldwSenGxDsKzGW3sofmN9Q92rg
	5ZAN/ptP0i+LuDj0McBVphBGLv0SzawmnCjGb6LTdP5mfW8E2OBIP83pNPF50CKr8UABck
	jm6SWvZJlFQ1y8Zpl6Uia0p1tiEFQrM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777840762; a=rsa-sha256;
	cv=none;
	b=nTYEgAIa5FIE0hTeuMc2vvCASGoLYWqhbWy0TZ895yyy7DoznuTU99EhNZR9fRWRJqiTH+
	BbyCaBZ8/p1B65q3LNNO9YFe/GBBKtNASI/4nZkUOZgyRcyqb+40Vt/gPnnfGdtSNJq+LG
	AnlSYKh66xnrQOjQ/8yV6OFgDHaVceI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AaGWexQ1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F0B8443BF
	for <linux-mm@kvack.org>; Sun,  3 May 2026 20:39:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B7B4C2BD04
	for <linux-mm@kvack.org>; Sun,  3 May 2026 20:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777840760;
	bh=OYTEHp7kfu60uKZpC7uNHUoEqcMaDbfVrENwGSgXkAg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=AaGWexQ13gf82hQWB+FAl3ibjW4mbkDbS1GJh505f+BGfDPc03XYC3Zss3edMV4ZJ
	 DUwtWEtXIsczETxuHWOYHx5CxKBx+mb7JBjjW/Q7AXcxa6UIfwRqV/Zn51WKOcBsMp
	 bFu9MwTUA+HqnMgiioGs52oZhuIjNtt0r82EsdfhdvfpiMubOWOj7+ws6jhlmjB4zW
	 pSMu6gEYh3bgUQrlhgmDaf5Q4E0kn0ZvLr8PAKjVL0HN224g71jgMtdo9zM7PW1Ozr
	 GBYpylIGAZ9+VE5Nv0nw7p4q7jui//Obr0a8J+RuTby7Ph7G6YVOsLlPN/bxxYQa3Z
	 SQoa4rrnaEMrw==
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8b7dccd6fe4so5234706d6.1
        for <linux-mm@kvack.org>; Sun, 03 May 2026 13:39:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/xSezjmwdxkoRhMBmXKgTPdeTzOcbbpGWoTbjUvreiXVjFunE5bPNQT/qYn2Nz1AAYgFXyWk1fFg==@kvack.org
X-Gm-Message-State: AOJu0YwI38CCBeaA8qeW3ju4VCtxpYrnX+Td5G840B2bKT9w9OoGxQXF
	UUpeM+q+yclesfDrKK+6XntkwNbfC752apTGlKuVk4orp2dQWk3vzzXFPU4+T3OEt6ir3dB3ubs
	CX968Ud6WWxLyeW4ev88jsvsFvZnW3js=
X-Received: by 2002:ad4:5be8:0:b0:8a7:16f8:442a with SMTP id
 6a1803df08f44-8b6691f4b71mr126409566d6.39.1777840759244; Sun, 03 May 2026
 13:39:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260430040427.4672-1-baohua@kernel.org> <afNM-gIqxpyJ6ro7@casper.infradead.org>
 <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
 <afS_L-5XeWIldTXA@casper.infradead.org> <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
 <afTpoL3FklpQZNMM@casper.infradead.org> <CAGsJ_4x8sNtgv7Y198Gh9NSY+SE2o_JPFAxG9aWE+xXsB9vwGg@mail.gmail.com>
 <afUBXnPVnt7Jt5hh@casper.infradead.org>
In-Reply-To: <afUBXnPVnt7Jt5hh@casper.infradead.org>
From: Barry Song <baohua@kernel.org>
Date: Mon, 4 May 2026 04:39:08 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z3MfP_sx1+qSr00dP5wshOuCAOcbT3RJ_He6Ddz_LnKA@mail.gmail.com>
X-Gm-Features: AVHnY4J-8SFfwvh8WWDAqxVa-cYngpmLlGJISHly6gCLbGvwUy-qMx6Jb2WhZWc
Message-ID: <CAGsJ_4z3MfP_sx1+qSr00dP5wshOuCAOcbT3RJ_He6Ddz_LnKA@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, david@kernel.org, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, jack@suse.cz, pfalcato@suse.de, 
	wanglian@kylinos.cn, chentao@kylinos.cn, lianux.mm@gmail.com, 
	kunwu.chan@gmail.com, liyangouwen1@oppo.com, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	bhe@redhat.com, youngjun.park@lge.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C940D1C000A
X-Stat-Signature: td5nm3rfiuxcjm1d74stwmf5ef1edpsx
X-Rspam-User: 
X-HE-Tag: 1777840761-83242
X-HE-Meta: U2FsdGVkX1/nO4tGL9BhncQe1sduR7LxGvAYtP9fFJMdxYO+9eMcYEuMkVjoeMVC6hJeIYok+ZEzUiKr+sVLqwyjFyo5fg1yqQNIjqfb3LOZroVVn7FZ0WuzmM7ueQNLPo0pDp/grM7VDncwD3qsFa0civJP2SE0MyKkUjfW4Vc5G+I0rD/pMy9NlM6NHq3etneYFt1MxzsVdJ1dV1Sr+7siV83wt7IK4yTq7Fz73P58/G8B+7LHAQoHdhwPkCaCap8viEaJ7yKvDDq7Q3U2hI36WheNPhynm7bxstUkFb6q5XItr8WOPN4eClRmFJCqHvwdFN0XZSlvInxQdEgzrmR6Sog2+ojr5RY9RCEwbjYd3K1fBJ82pmqO0n2qHO7DHqOKiGB8PMSfZiahwQaD6rD29oKh4OErup84XRF06IouhlMwVCJKXdm1vfSZKd/DBhEgZ2Dj+RyvMg8Ya5u7ob8zN7l+xN/jXc0SXJ+rlh45EPcGkQpHFBqXLhXtuc72anncOUiBSNp59Wtpv3/V0z+ARvfo5o197jNmdrHVudN2ZjSP2Lofjb9DCRL0rHi6o0DCPwPGyoCaqG1O8HhStQvjY3TsF59VrGtwq2n/ZvEM5B0r9IaGVp67M3UEfVaOYdvQlc7chl4DLybW+TGlpEhVdt+//vDVBVpTesYIzpYnQYqOBYsyFzi6GXxht1RKduHRZh2louNndTGp/nxQiCI4MegBCeucS7b8vH3g5Lo5vX5/G42cQS+/hmbDvTa/YG9XROeQUapS73sj5ELFvDoR/HQI3pJ1KTyLZQ52qMEDmfKICf/1/2MDrJqoqZ3R+jCTDFwe2II//C1c+Hl+w+OBIsmSe0a5T98alSzJz3hv6coISXMrR0fPbFuOdtZoKvi5sOinsCRj2k8cbkdCMWVnUoH0G6dCWyix31juKZoRsqsKeDZ6IGrArTNZLbn+n1d5lppKRJzlhE3SzMN
 +qXDfN9T
 zNrlhBw10senIPQTHpWlTpznIIU/rw2rFQ1tTkGFRQXvm4W9tPGWez2X09pwscH0UAtkeuWbM8O03Nr/fXMWmLZc6K558Rl0/dCgBwCM//PSRlgOHKYa2DQ69EpLZCs6KxHBmVWSvJy+OGrfJrmBNrkt/WxCCQsgl5mnMYpjPQCL74Qn7qwpJfOnbkBTU5DljmY1Ij0pP5ClZBB1wjhDH3JxWzGRv4gqDgvb42dZSbipSWXRMMnqwMV3+SpqWH1N2MYAp2+sueOawbbNFYGFbcRXrJPrukl0Paf5rpSgBP+BlFddnzpJyjafJWZwCUlTprjSGBOmA7Zr+/CH2EK1qhviNS/XfLefBUHgA1GFqUmhh3XBaNoqJJXeXvXA725C0R5WYRBYtuA83m1f98/svA4R6WP+ZTHsBOYaPqC+smTi5iEVd3D8AvxzBus9lj5baI68lpIMOJaM2mBQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 2, 2026 at 3:39=E2=80=AFAM Matthew Wilcox <willy@infradead.org>=
 wrote:
>
> On Sat, May 02, 2026 at 02:25:37AM +0800, Barry Song wrote:
> > On Sat, May 2, 2026 at 1:58=E2=80=AFAM Matthew Wilcox <willy@infradead.=
org> wrote:
> > > Yes, but that still fails to answer "does this actually happen".  How=
 much
> > > performance is all this complexity in the page fault handler buying u=
s?
> > > If you don't answer this question, I'm just going to go in and rip it
> > > all out.

I guess the only way to answer this question is to
remove all retry code for file VMA and run a real test.
For defensive programming, I am generally very cautious
about this approach, but if this is the only way to clarify
whether we still need PF retry for file, I can give it a try
and run a complete test on Android phones after lsf/mm/bpf.

> >
> > I=E2=80=99m getting quite confused. In patch 4/5, you suggest a more
> > restrictive condition using
> > if (folio_test_uptodate(folio) && !folio_test_writeback(folio))
> > rather than if (folio_test_uptodate(folio)), before we decide to skip
> > retrying the page fault [1].
> > That seems to suggest we should be more cautious about when we can skip
> > retrying the page fault.
> >
> > However, in the cover letter, you suggest removing all retry code entir=
ely.
> > Does this suggestion apply only to file-backed page faults?
>
> I'm making sure that if Andrew decides to override me he at least sees

No, I don=E2=80=99t want Andrew to override you unless there is a real PI
issue for file, and only if you still still insist on =E2=80=9Cripping it o=
ut=E2=80=9D
after a thorough test with it removed.

> that there are other problems with this patchset beyond "I don't like
> the additional complexity".

The other issue you are pointing out is that, for anon, we
should be more cautious before deciding to skip PF retry,
which seems to be the opposite direction of what you expect
for file.

>
> And maybe we decide to do the fallback for anon-mm but not file memory.

I was targeting a unified approach for both file-backed
and anonymous memory. For example, if anon requires retry
under the per-VMA lock, we may already have the necessary
branch in place that file-backed cases can also leverage.
For anon cases, high-level language GCs can operate on a
small portion of a large heap requiring VMA writes, which
is fairly common, as I explained to Jan.

> Or maybe it's just something somebody happens upon when reading the
> mailing list (or more likely it's just grist for an AI).

Maybe one or two years from now. For now, at least, there are still
humans working on the kernel :-)

Best Regards
Barry

