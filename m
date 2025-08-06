Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03E31C87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 15:47:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AA7B6B007B; Wed,  6 Aug 2025 11:47:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 981F36B00A5; Wed,  6 Aug 2025 11:47:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 897CA6B00A8; Wed,  6 Aug 2025 11:47:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7848C6B007B
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 11:47:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 06C1016069A
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 15:47:06 +0000 (UTC)
X-FDA: 83746761252.28.D39C1B0
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf09.hostedemail.com (Postfix) with ESMTP id 29B1A14000F
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 15:47:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lItcBdro;
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754495224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jzR5hZORzLK1MdSlqmP/wfvTXuXPRKmGcAHBnX2kHxc=;
	b=ulMBqQf0RTapax5QrEjFLhxX+uZBZYC/MyTT/aAjNqBHkX8NSSr6wpayZOeZPF+7n1/fbH
	JYzzMgJeYdMoRB2AwoCQW53CNXchmX787uO1ITT3ApwQQ0cP/ZRaoKVp5bZUrtT/OWy2D+
	TJSKErecrnAJGQDWBftXh2sgrWISdSE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754495224; a=rsa-sha256;
	cv=none;
	b=Skhbgdg3dKOyL4JXhMbJvxhCL12BMu2Dih2/v7mdCyBke9gl50YXtkteMgmiBs2kYKTJ3p
	C3SjbLQFhqn1oZH1DDLaI/TOdxLD/sorXRTfR8OeyqI6raBvWRzneadSCL11HN6TNpq/iY
	clyBHQW12kQ+fl9mp4qvnMm1fh6h1I8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lItcBdro;
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4b099118fedso235181cf.1
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 08:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754495223; x=1755100023; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jzR5hZORzLK1MdSlqmP/wfvTXuXPRKmGcAHBnX2kHxc=;
        b=lItcBdrobJdcvCvcfubJ8N8TdRZdWNQOERbnN+JmQHXctxSAwFpLhXV0pGAi3b4yBU
         /uGh+pRz4rGFkoAejoFuaxM4X/t7RDGxsXrUNe5tHATRKe+d8nqEvu/Rv37VeWVO0eE/
         76k2QWmL9aKwZIaIwXRqcq0Ej0XzMBFJu1lxKpMVaICjTSwYBdyMUAoOeaXNUpZrGU6i
         QeOwE/tcoPjJu9h7GdFP7GmqXkwKyTu6hRyldKvmvkBpG2+Ff5U8qpK9hygYOgrbsktY
         XEx8MM/rOdkJ45WLimLjfwgOyd8ENylKrJXTSJdTztEeD7IOhzUziGTxL4+tPwwJyfEL
         G1Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754495223; x=1755100023;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jzR5hZORzLK1MdSlqmP/wfvTXuXPRKmGcAHBnX2kHxc=;
        b=f+C/vwaWcWmR0kFFMTkOTBEpwje5IpxUaW8xISPDhVEo+d1rOqcOvIbpUg0kjf/x+i
         gXRNKGN0BvtgVlX9pL+mXzmrrrc7ey3ZJqTIRQfcZD0tHytpg0zvGDRLa9madeONOAq2
         ZmE5mS66Ehm+2fG5cMECIbsJpLeugKfP/y+Jz/kHxfY7uu4o4rYyAm56TSynpqBX1aFt
         zlRIhhLvCcU/YPBu2aLWLjiYktnrGiu5U12pPWPly+bS93EBzUFcMMHCyfjuH2J3FI5M
         7PE31g1v/B9m7/5AKlGf7bfWr68DNCJUV5uAdhvfM2XPdpGl4OZy00PrjscBPpu7Cw6X
         JHbA==
X-Forwarded-Encrypted: i=1; AJvYcCWYLGkC6PH4WlNizwPBxsMyBeVb+aOseYXJsVUlg0Oplcl68abQWFamivnslh7EWPO66Kokza7E1w==@kvack.org
X-Gm-Message-State: AOJu0Yw7scadCmcvqkcmYYl5hoVuuz7S/U460YovtkxLonbva4RkuVqO
	n1yenVei5NlrHbuP6Hs2EZvB47gfDS358MvmNDPAAmXFGPL6S4IZofycU8KgtiJmrnVvbrM9/aW
	zXGUwjLdcU2fk8JIANi7A0eroaG6J5N9D4M7gE4wy
X-Gm-Gg: ASbGnctAVGvO0Bk31AQaFgjnQcIUWT4HtWl9yXlyuNrl7jvQlXVC1XYk4L8XJOISi3T
	JFzKOg6VQZA4uGPm1auCqP7LjmLVViRwuT+cCrSirn/fW25BG8uhhpWM6iVcCgE85f+c2MofPQJ
	6zPe38HZlAgrHOM9wtYoJKru82e2I4bCwWJf91haUNgVT43x5SYKavpytg7Q91FW3YgxMkJvHtE
	ho/O0nXiZtbm2e413iWTSx1UU5yg+HtoygY5A==
X-Google-Smtp-Source: AGHT+IEYh053v3QF4PQwxhsLJXp/FIJIxdvbBIzUpxM1WEijiLmhfG9OEz0K75yz2Pw4+euNot61Qt8yZuFDMeSfSC8=
X-Received: by 2002:ac8:5894:0:b0:4a5:a83d:f50d with SMTP id
 d75a77b69052e-4b09276bd9fmr4745741cf.11.1754495222647; Wed, 06 Aug 2025
 08:47:02 -0700 (PDT)
MIME-Version: 1.0
References: <aIz1xrzBc2Spa2OH@x1.local> <CAJuCfpFJGaDaFyNLa3JsVh19NWLGNGo1ebC_ijGTgPGNyfUFig@mail.gmail.com>
 <aI0Ffc9WXeU2X71O@x1.local> <CAJuCfpFSY3fDH36dabS=nGzasZJ6FtQ_jv79eFWVZrEWRMMTiQ@mail.gmail.com>
 <aI1ckD3KhNvoMtlv@x1.local> <CAJuCfpHcScutgGi3imYTJVXBqs=jcqZ5CkKKe=sfVHjUg0Y6RQ@mail.gmail.com>
 <aJIXlN-ZD_soWdP0@x1.local> <CAJuCfpFzP_W8i8pwL+-Uv-n+2LixgFrzqn2HsY_h-1kbP=g3JQ@mail.gmail.com>
 <CAJuCfpFEf92gTR+Jw+1wcCcT0fEt-SP193NHzpyxVXJA=VAwng@mail.gmail.com>
 <CAJuCfpFeSVq+hq4JRJStLgFfQgmS6SQ7zoFsj4=SeQT89r3TTw@mail.gmail.com>
 <aJKkjEYmeq93w35-@x1.local> <CAJuCfpGpEOaKdqpqTpfbw1cdHEEWhiu6KRFQFWaM-AKODiDFcg@mail.gmail.com>
In-Reply-To: <CAJuCfpGpEOaKdqpqTpfbw1cdHEEWhiu6KRFQFWaM-AKODiDFcg@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 6 Aug 2025 08:46:49 -0700
X-Gm-Features: Ac12FXyLuMHK7bomXAcy0jhshEgEmzN6kvzy2ZCVRN5POfKeFAP3qWtXtAqAj14
Message-ID: <CAJuCfpE1y_bN9_8c-5mBsSQrFjAz69R8L3+w4GPYPPa0M_2z6Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] userfaultfd: fix a crash when UFFDIO_MOVE handles
 a THP hole
To: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org, aarcange@redhat.com, 
	lokeshgidra@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 29B1A14000F
X-Stat-Signature: z4173j7yms18kqgz6g8ztgy6jnztdx9g
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754495223-759536
X-HE-Meta: U2FsdGVkX18kP2IyG+Hz5zKevBaonH9d+zuqzOqKR7fZxPKS+PwoQfNMY26BaUKLArPIgVsW9XaL1Xee8s5bF27K4grWwTR3ezXtaG2wWH3sT2TypR2UPT0UKsKTD2fxnrEdVu20CUS9woJMdgrkcCAf0mixgIPlWfBVycodIFL2ByWLgKFxYBkU7qk+AIOdOYNuhr3YbgFS5q/T8fwKmDdfP444rR+k78Q9jFqB1s3XdJR6F5gPdTbJL2qz0hxbu6TSX8ehP0KPmdI1DrGpATiBkY47zpnzpHxeG1CTU3St6Va0NebtDJhamb+pOm+H5MgB+7k7lznxnin/RsvmtN1BVYPcp6YOcuHkstWD5i7XwdzOgq3ots+j2tRyMMlbmX9MdiWUPMrrlQtu6l2vP3ll6vikdMBxTvu/+5JwPxdjn9OTQY1eusoooPQfKzgo759zpKqnTIg73oGHFDrtY6BXgOOjypWFLq8PJ/vaXN0yYziLhFstemm08ExHIH/JPzQU3uJmXqXQXYRGEKNIwLM3SWguiMBLp7XLCuzkU3xocAHKxj+BYoxbDnt0QWMFKE3RSahd5SZUkvh1ZgzXflbB+5oDJcQtFE+vkqY2MNWZGwlYPhsIhWWBLpvpCQhelmzuLHQz4Yp6cRW6qhCbMhZSgVROncwH6moNA6naS1Zk7gF2qvoxsKLFFv+SmHacK1Z3xvFay9ibKv5zOZ+QhmMIG+GFCagvG0GHWps7FEHr3a0hTFfY6kYJVKCkdBl2og3wcUKLT3O2oGI/PreXqjPjE0+IzoDUCscLaI2ssQuIwHq/qq5WmZI6VwoZ5V0FECn0ejf5guKtQgh7/bjm3+RvKazOPyR8/FJfUZGVQ3WIdGbm+mgp0/bBLfvTjaxdGKzCIW9D5nAD1bSMYZuuZH2JLhXMhf3oM2IxSbtmEIOP4FwAa0vQETw15fJUb5kSZcMskRacOBkMm9/SiBQ
 +4WypFQp
 n11mCD7jGAphHNKibJvqFrznAleFjLRc81TnFdsPtkuQkyPEqTiCKcrAFFTLOuAI0DeVInsoF2EFKQuzYg5QccR0MiL4SLsxEbRvUt0KH8aFZChjB4VD6IAtlJkW9wt/tSM191Zq/zP21/QUZseCJgI4b6vVYhCa6AQv/5gxxDVtYlHz1/IHVvH6CtTVouCsIKX9kcoaX70b5sils6Y94KGAc0zLl6R7h+kO6tSvxJIKyiBmMrBPL3ixY6e1PsUUFscj/3jkzUWSgp2VRFVq8jXWxkGVqKY8tJx8oOQAKwT3n1ZVhHGIDony46kbLgZaP5nQ8UpEUDpTTSEzSrY0HS5ROyfip2eynTX6sKMA3RlCY4zKK5oSTfCl14//9mXikus+z3tNTcUxSrb4/7uTGN3Awww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 6, 2025 at 8:06=E2=80=AFAM Suren Baghdasaryan <surenb@google.co=
m> wrote:
>
> On Tue, Aug 5, 2025 at 5:41=E2=80=AFPM Peter Xu <peterx@redhat.com> wrote=
:
> >
> > On Tue, Aug 05, 2025 at 04:41:18PM -0700, Suren Baghdasaryan wrote:
> > > Ok, I let the reproducer run for half a day and it did not hit this
> > > case, so I must have done something wrong during my initial
> > > investigation. Sorry for the confusion. I could have sworn that I saw
> > > this case but now it just does not happen.
> >
> > I'm wildly guessing you might have hit the numa balancing bug I mention=
ed,
> > that might explain what you mentioned previously on the testing results=
.
> > It might just be tricky to reproduce:
> >
> >   - We'll need a valid THP (pmd) first in the MOVE source region
> >
> >   - THP needs to be selected by numa balancing for a check (marking
> >     prot_none)
> >
> >   - (before any further access..) UFFDIO_MOVE needs to happen on top tr=
ying
> >     to move the whole THP being marked as prot_none.
> >
> > AFAICT, task_numa_work() is the only place that can mark the THP, and w=
hen
> > it happens, should see change_huge_pmd(cp_flags=3DMM_CP_PROT_NUMA) and =
then
> > returns with HPAGE_PMD_NR.
> >
> > [sorry I am still pretty occupied with other things.  I can try to repr=
oduce
> >  together with you after I get more time back]
> >
> > > With migration entry being the only case that leads to that
> > > pmd_folio(), the only check we need to add is the "if
> > > (pmd_present(*src_pmd))" before pmd_folio(). Would you like me to
> > > check anything else or should I go ahead and post that fix?
> >
> > We could fix the migration entry first, then if any of us can reproduce=
 the
> > above numa balancing issue then it can be a 2nd patch on top.
> >
> > After all, so far we didn't yet prove it, either some unreproduceable t=
est,
> > or pure code analysis.  Meanwhile it might also be cleaner if we have o=
ne
> > patch fix one issue, rather than having one patch fix two bugs.
> >
> > What do you think?
>
> Agree, that seems reasonable. I'll post the new fix today.

v3 is posted at
https://lore.kernel.org/all/20250806154015.769024-1-surenb@google.com/

> Thanks,
> Suren.
>
> >
> > Thanks,
> >
> > --
> > Peter Xu
> >

