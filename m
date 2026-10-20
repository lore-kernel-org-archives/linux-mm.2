Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 722BE606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 01:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=IX3NTm1E
Received: by kanga.kvack.org (Postfix)
	id 869CC6B0114; Mon, 19 Oct 2026 21:37:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F41D6B0116; Mon, 19 Oct 2026 21:37:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 694816B011C; Mon, 19 Oct 2026 21:37:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3F0036B0114
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:37:08 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BC696C0868
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 01:37:07 +0000 (UTC)
X-FDA: 85341291294.14.2BBE3D3
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf23.hostedemail.com (Postfix) with ESMTP id AB0D2140004
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 01:37:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IX3NTm1E;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of sidchintamaneni@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=sidchintamaneni@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792460225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BGjAR6GJbqkB0JeXW82W/emLheBNUt2rVvKEQMHhSAc=;
	b=iyPl6Q4DI/TRitOg6vNs2p9ZQOxvtguoddz+z4ZNEqRCWBWe0qEZgssB0FNpWLauWq2i8j
	Musar2ls59BhIeadozffnr34VlNoDWpPKLiBFij2mUM6amXqdDg0ocIHsXISGPvqtHnCVF
	SkCjoa56rZXzHlT3ISm/crxj+yV3qvI=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IX3NTm1E;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of sidchintamaneni@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=sidchintamaneni@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792460225;
	b=CzeEw+ZZtnGPtzcVBTdQbUxlTzDgAYOGsveyK4TlSIJR3PvwuhMZipxKWTMgt2mPqnJ/SC
	GChISb4lWgSmLLYHP6kgCvk/IP191ulSoWtk1C2LzjuKArso1ecTZx2KlxnLzqqvTvKHsg
	PwpBSCW0u7riYddhNR9YVQXxr7UQSyk=
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-8b0e21048f8so20447407b3.0
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 18:37:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792460225; cv=none;
        d=google.com; s=arc-20260327;
        b=kpwYNJBffp6jzsTm6cvXEy2lgQQ7rOwgigFbIOHfCBF1SneM87SaRmGLJepixFHjDK
         du/bh6fAQH9s0lqecATW3jCBe3hu7RmD0k/K7g2wdwQ/iP6ECrHlkapbqblUuZCcpwHm
         B9y2BYiYWgDoCCMOZ+yTRponoOe1qnek+4/k7wgREIoGCXkqksnDpUkhfvOF48KbvKK8
         HXwL8SSjogvgVcLnZLNEyDBvrhnrTmPpo2o81WdZGRCOk3EDMqawDNf/XIvM/p47ESQQ
         xr3RNxUNjGPy1emxUjbNiXZmErjqD/XLV6jjpRJwgohMXWd4lRZBmuNNuhCghPuyuSvn
         6RnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BGjAR6GJbqkB0JeXW82W/emLheBNUt2rVvKEQMHhSAc=;
        fh=AxwDxtlM/OsQbQ5VjmJxhwZxmehJt/oty8MLN7VPd7c=;
        b=PyJtC96HwjYwgrjodFH+Zjyobe7txIqPhui72JN02RZY6iDfuWQOimGeuOrGU545c5
         nr+i0aMzij8tXuk+UrcN2n4ahuyMmt34JEc7vEZyaZKFKA6CPy1rQGcFN9g8qTTkU79V
         l0F/A6UYeM9RHTSYlPZf7YFrSyx34IbS6fjAwucUPUvj//4zs9GTTJmeVc7Z8fAV0unQ
         ReRLRqpIU7ydvhfQ9LrMTTBu+Aq1LFqMfQGBWSV2iPFcQMl4Co1b2YmUp3cob44qmSRz
         BSlObC8Rhh/CJYW7k6AMp7gn7NDeX65p7FYdYp9nzqp9JtEqdFnkX4EDGROI8CX3wZW1
         OmGw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792460225; x=1793065025; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BGjAR6GJbqkB0JeXW82W/emLheBNUt2rVvKEQMHhSAc=;
        b=IX3NTm1ETczd8D1ngFmVsbQScl3NhKC/f/rv9gHXxVtkSnGmUJdKNqDRaAd6uvrkMD
         XrOlDMwbjEjcSauUfjIS7ssAL+P31EC9if5AMK0l4Al0VI0o90USpojcG6CZv3erw9cc
         NaJxqDfdwSng5J4bEEQs81Bsde5GGC1kg6k20Js/7fyAhQf8oieNeKOD0O5zVOkGj3tK
         hfI7ZR0V8X8D8NXQEuyqzrGTXdiJkNoUe+pjdKms1hSC6r2qveVaztwuZ/9nKdM8APIp
         09EC7vwGfLDYUaX/XWuvA7sDAOBJbdl+QAUSNup1J893J8mp3Zlx3aih8Kj1QjFVG0gZ
         LcHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792460225; x=1793065025;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BGjAR6GJbqkB0JeXW82W/emLheBNUt2rVvKEQMHhSAc=;
        b=X1JjwnjaKB0Zi/khB5VSKPllPAKqkFisJQSPdySPIiVkXn3gYBKd7ZQjYj/ohHrlvI
         Ur0OzTZ7IUPA9bcq1+cJdBcEyJgSeP0pbWj/kfAGKfzTzc7bFt/AxMyWZyk5tjs5n6DW
         YfY4hswLuJiRDHA/wEYVIRbpRl6y3O4s1ZnqgPRERTbTPq5oaGZdhSWKL0chqE8PsCLT
         FHuDtf9YXlNZGookP5HuKw/X99lX7DLEgKxy4PHnLuFUkQxqbR0aYfenH2qgBtE37Ys3
         iQDUPsJaKeykAujSHxFwCS30jvJ7iQFglGqkBaQHPnkU7YAwnci16uI1idysKJLR3yMi
         UKjw==
X-Forwarded-Encrypted: i=1; AKwUvBwYMFfo8fuDEvWJcxaYvhzosuAEDLj0RypwjgEYKa/+z1h2dzsQxE/SQmqSXUcmwnr7jVhaS0bbGA==@kvack.org
X-Gm-Message-State: AFq9FYLC84Kt0xXzNWbWq8Ehp09I34jkXqopO7ebSLjlqgnj6GgXYlvc
	YYiH6fgNagevUsH96n7lpto2fwKmHFVlNm8hCUguAeLwcBNvrZ3dFqx0zWjIjLBMUN/luiACXSo
	hQzHEar6ypQYxAFSqUFTs+Mnw70ODbb8=
X-Gm-Gg: AYBFou3e2FIRM8H9++4kaw5kejrGr83Es9jOb4y/6ZMqDNcVhEUywQSD3rj3VW/cC7b
	ArrCc5h/LeLVQIOVkfPmXsQ4KAwWguC7GEoPMXiXGprgOxN/l4UpuVdQIkL8SuJ5t9lawn8WL3q
	qTanl1NZFL0vLVy+YljBputyRo6yadwq65rV+Yya883rkF3nN2HOG85qPH3k0zvsMZPFaAXT6+P
	/TmXBQSJOtiJ/2Tiz2RcHBGICr1/PxoAq2Dyc3KE6YfQhrlzpVUh60OiZSb8aICEeYRSA5exToL
	Z3hlLlvXuGqk32nYtI38hySz9+6vFd7QaTlguJgYL75/NMcAb3k0rMGyzQFG2EZVs7kJd8fOxqc
	VU3tr2zfaEgR2rBxWrX4MUqrC2KakAKKFPZjVQhb5FwLpMBr1tDCs7exuLWvUjBgnY/mLQhCAKS
	I5Csaf+aFKWH/m7GIgJPxgo4ywpONA0tVl5cr4D9qU4GyqWTx8BPvPhRa3r086fO2eq5xbiBKYO
	JZ6Jaxf
X-Received: by 2002:a05:690c:f8c:b0:8b0:a957:80bc with SMTP id
 00721157ae682-8b0f2196dc2mr38396937b3.40.1792460224531; Mon, 19 Oct 2026
 18:37:04 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261017050928.128582-1-sidchintamaneni@gmail.com>
 <20261017050928.128582-2-sidchintamaneni@gmail.com> <CAGsJ_4wGq9oc05=-g4aWptLdCbTwUjMjXk4Rd6KjJ6x=tzMm+g@mail.gmail.com>
 <CAE5sdEhGFtGF6LC4xNkMwGj3vTxLOW=GNBXnk3-JmsgjntXx0Q@mail.gmail.com>
 <CAGsJ_4wmvBvEn_vXu8-c6BRAnRewYmTs8iUd8T7KRx7_svZrwg@mail.gmail.com>
 <CAE5sdEiq3bY1kgMUQ6x7RRJCx0JH4sQ9Z_a9_YQSM5FKNwpk8A@mail.gmail.com>
 <CAGsJ_4yZ3rueVMaRJ_+25Nnab0WH5ZLQeLjporWAFj7xJnJFHA@mail.gmail.com>
 <CAE5sdEjFgVoQbWw12=+AKdCOB9cWm-akxzbX7hJzvyO3vpCtgw@mail.gmail.com> <CAGsJ_4yrAosgxnxqc18qXyeJQHszYOdTxJw4TzSJqp10YQWjag@mail.gmail.com>
In-Reply-To: <CAGsJ_4yrAosgxnxqc18qXyeJQHszYOdTxJw4TzSJqp10YQWjag@mail.gmail.com>
From: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Date: Mon, 19 Oct 2026 18:36:53 -0700
X-Gm-Features: AclHuK8ck52zGHHnsy_oDpaMPdyA6LZuDR7CHNRNZa81ymtH366yW7A4g5vgegE
Message-ID: <CAE5sdEj9biuOuXp7aej7pV1Zyjc0kqcH12Oi6gLyJCeuihF6Hw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm: multi-gen LRU: fix NULL lruvec->pgdat deref in get_lruvec()
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, ljs@kernel.org, 
	kasong@tencent.com, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	yuzhao@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	apais@microsoft.com, rlmenge@gmail.com, stable@vger.kernel.org, 
	Hardik Garg <hargar@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: AB0D2140004
X-Stat-Signature: 99h6btohjh58c93yi3yzec53sfuku8i5
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792460225-320857
X-HE-Meta: U2FsdGVkX19ls6clmkmqYrEInyYh853w4LWa0GpDMuDsTFb0IsJ4qVhnHGcIFk3PwVLmMUWwwnPAC2NepoX7d/t8RviLaULEdBzOJOF9Hu9GII46FsLRPuJXmZFS37g27cvMTEQSf6gWwgJOgD59umFltLut5eCWb8bv+QqssoAeQqOkSA/yskgZ9OuKoyjKp31ZSmD00s9+izumm4GW7ghG/VCh//y0AjyMjDpp7ZrmPf010Kf/XNy2Jf2kZTzwW6gkZCbFYrcjEpzmFaJ+g0dIbd/3+0WlN8SUjBVVQ+MKQJjTlCmH0DmifQfOS83RsDHEe1lvw16vdXkdXpeghbf9j/c9xiQms0TM11QFVZeCI5eOiGFmQehb5rQvTLeTOicDQ7Ye9xTaGDDFDLZGxbWkWTnfM+Qvplke+ZEZx/CboYCmEtIwhyL4eAliGeV7567qy3JTYIGOl4xuZz19N1lS3Ge03AuRiF5D/00WJp0XmkZ9qQSj0hBnndfGbeyGcFgPYIISd+7yMOzUsOEEOOI9sEfwqsHFoYV1WXMGo9v9MiZa4+w+NCi0C6mJYV2iw7Z5fjmj0dBNadj3Tmx8MKRFT4e8yD83OnFwpu94odE26ksdnKXFUMpOomhuvb7QwKCPmTrtaGOyzmpZJHYxRr1ejZSFh7Ql1l3rtAsfgBQz8aozbC4uyEGttwa1arnUIP1a/l+z2M9MClQKNOK4x1SROtRBUsKYZGFSFgKCWNCYuscTzDu10vpuOt7KWT6N6Av5ll6ct6f57ssFRqTCuAEKlKf2Tt4CkPtgjiU/W6LYNnsKQBGWCvFAafKI128g0LIoaviEBMsreOoBtJx9Q5c0fwMmmTltFu8Op1j7yee13bgXD2crRsw2CZ/+tIrK/26QzgRLdztssyZxzyvzlHZbQPiwXnv2waWmb5v7GhTVZkIarKcpvsq+euFxZgnJHs37OgTc+F2BtylBkdZ
 fasOjAWl
 snNqkNBFkIItuGD2tAVj8k8tbQQ7Zj3VM0jLV0o0/3RcRSM+ON1ez6UDoHl7ffxHKYSpseTewOMav7KkaVuN96bfh03G0uPEigOcM+1UrFixFc5Z8qritBBHdHeYXlE3IlDqM82RszIyBOmo1iBE9CUKbBdv1IQGxu44l5OMW3OPmf4wYNOgBEpeLN0fmbiq68lCB39kcroYNSpgA88GX5htD166yK+Ff0N8dQYYHDkVO029SE16BIrADqLVYxhIhTpI8C5+v7CBvUxR5VjXQJ9tIG8aaQs4pw/vh7FHNfvZQAbYXqapwtN1sDk6S9ENOoQO08w+lyfCKifIwuOLMcajZes+ycCvqxwNGMYXmres3KmYO5O0lc2+JzaQUHMb3JRvyfiTJLvaYD60h37y8YrQsAffhQoSipWHyjVYk3BD719XPuc3hHLNESCcs/j7UCoSrBBO+fs992F/Tu8snahTYSg81MtcaV1AVKnIWZLqV4mAnTolV5zKsG3Jj/KKX8cGGhF1yUCzx9cHhhqPxALw7Cxb5TdCcMZOu/LM02QcEPK0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 19 Oct 2026 at 18:20, Barry Song <baohua@kernel.org> wrote:
>
> On Tue, Oct 20, 2026 at 9:02=E2=80=AFAM Siddharth Chintamaneni
> <sidchintamaneni@gmail.com> wrote:
> >
> [...]
> > >
> > > Thanks!
> > > I guess you mean the following:
> > >
> > > -module_init(kswapd_init)
> > > +//module_init(kswapd_init)
> > >
> > > Yes, I can reproduce it with the above as well.
> > >
> > > But kswapd_init() is definitely called before we enter userspace,
> > > so this doesn't seem to be an issue here?
> > >
> >
> > Looking at the callee sites of get_lruvec, all of them happen after
> > boot. So it should be fine. Anyway code clean up will address the
> > issue.
> >
> > > So I feel there is no bug here, but this cleanup is still welcome.
> >
> > Are you ok with the patch as is, or would you recommend  changing the
> > callsite of get_lruvec to mem_cgroup_lruvec?
>
> Overall, I'd be happy to see MGLRU-specific code being removed.
>
> If possible, could we split this into a two-patch series? The
> first patch would be this one, and the second would drop
> get_lruvec().
>
> In any case, if this isn't a bug fix, there's no need for a Fixes tag or
> a stable backport.
>

If that is the case, do we still need this patch?

> BTW, I've been struggling to understand why MGLRU introduced
> its own version in the first place. Maybe your follow-up
> patchset will help clarify that :-)
>

I have a theory -
when MGLRU was introduced lru_vec also returns NULL
https://elixir.bootlin.com/linux/v6.1.190/source/mm/vmscan.c#L3163
that is not the case anymore. I haven't looked at the refactoring that
happened later around it yet.
That might be the reason but I could be wrong.

> Best Regards
> Barry

