Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58EF8606A331
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 08:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UBAiMSoh
Received: by kanga.kvack.org (Postfix)
	id 76D076B05B7; Sun, 15 Nov 2026 03:32:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71D046B05B8; Sun, 15 Nov 2026 03:32:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6324D6B05B9; Sun, 15 Nov 2026 03:32:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 393AD6B05B7
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 03:32:32 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B7E0F4061B
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 08:32:31 +0000 (UTC)
X-FDA: 85436686902.12.22D5558
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id B6AFE1C0002
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 08:32:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UBAiMSoh;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794731549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GCh8Ifwi9uvxPPglO9UrnRFnfH7l5jkW/d7XdsHHxuw=;
	b=t9ITQ0Xl3tnw6PZxYnK1A4k6egKyFmVZY3P4X4HCI6jIVTWU6Fjxq0gtlZdRm1d78ExyV/
	pmu7YWLvYFDsuq94ue4Qc/OzVdxn6E4tkN7R7Zn4/xO2DI1TAdzlRImtUGTeSTEA3BxgXs
	Qp3ARMuA6HvMcxon6oydpcMr4ktHDtA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794731549;
	b=EioDVagUxlFNTztdyQbNPKbeG7nbTDM6dmmvafA+OddXmYxWfOmgttMkK9TrtrJ6sXBs7J
	kvL3Tr8kZFs9mSJ7/YryWYxZn2pb/OoeG1Ww1p8aKTVa8WaCQPnAR76x0mMXfjpXiOHYSw
	tlIvPYwMIkP84iHuHPhaYBHczAFPv7M=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UBAiMSoh;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9B9D045A8E
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 08:32:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646DF1F00927
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 08:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794731548;
	bh=GCh8Ifwi9uvxPPglO9UrnRFnfH7l5jkW/d7XdsHHxuw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=UBAiMSohkM5KfXVEBDBy7CRMSsOwbi1hP3rk3TU9/89oUkVe6UCm24Vb3CmDvF4z/
	 yOY2RgiM29r4sEzCm3ye06DBabOoobyPOBVJdK/ul04D58nDcjm6CSoPQQlwL3m5Wl
	 cMULqRqaEbyaqO5ca8h1WaukMsbfXjTwzBSoBZ6LvdM5fKavmHsNrligN54uDxAUuI
	 2hHStRSpuj80FGStPpW38bJWdVKz4ajq+TfMvojqW7zhOt8LatpTF1QE3lCuDVaj+/
	 LVg1FCcDhsaxf+rveFojuvcmQ5VjVEFROICOciEYtkVmmOOBvFchnHvXia5UB1PoJH
	 RHbGFhep+UAhA==
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-9495e8ae23aso156292185a.2
        for <linux-mm@kvack.org>; Sun, 15 Nov 2026 00:32:28 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFFkQvw1Ara30R6vGVp5LwSrb6T5zBJJ3GgYCLUSzmgKZMushiLDS+lLubqd5W0TntwQqj+ZYz7ww==@kvack.org
X-Gm-Message-State: APuU4Z/wPDc9Kp0aUNS8bJK7cHAi7D/w2a6HoUZa7XgGlCKic1/zuy8W
	HRE6sG0Xebmb1gjixoJm2Tq8A1Efd9OQo740e4oQcvCA5PpgHwU7rpkZonR21NO/BbV6K9DTeqe
	KlkBqEP+A76gzcdX9WLLpZuDhWB/K/AQ=
X-Received: by 2002:a05:620a:2614:b0:939:fde0:a71b with SMTP id
 af79cd13be357-9494b86e99fmr1135729085a.0.1794731547421; Sun, 15 Nov 2026
 00:32:27 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261103113711.1832834-1-max.kellermann@ionos.com>
 <20261103113711.1832834-4-max.kellermann@ionos.com> <CAGsJ_4y+LX-CSnDJ59VT2nc-i=rB=4iMuBQYawMCktk-_SPykg@mail.gmail.com>
 <CAKPOu+9XP8CP-EiLqd_Q-F6EWUQPgi4Ysz7wu8LZijR+j0_uyQ@mail.gmail.com>
In-Reply-To: <CAKPOu+9XP8CP-EiLqd_Q-F6EWUQPgi4Ysz7wu8LZijR+j0_uyQ@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Sun, 15 Nov 2026 16:32:16 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zp8WJosxkVwRtfEvySBwp38bLd-0g6cV0G1BPb2V=hPg@mail.gmail.com>
X-Gm-Features: AclHuK903Z9BUzVG_q0fBix3SipsrwutJuy-Sym-wmyWv56RpJEBqKKFqIWDC2c
Message-ID: <CAGsJ_4zp8WJosxkVwRtfEvySBwp38bLd-0g6cV0G1BPb2V=hPg@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] mm/mglru: cache the last memcg node, make tail
 insertion constant time
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: gmxjpiqsc83gpo9xcspkuakkpdiec4gr
X-Rspamd-Queue-Id: B6AFE1C0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794731549-214759
X-HE-Meta: U2FsdGVkX18HcWrQ9R1zHArXc2IQpArOSJnk9mkPv3lpWH/4OhxfQyS/PAwIcq5gRf2QzJzRz5q0v6ZjSjMQX3CzbIlbIC/sIVZd+ThXXu1HDzEdnmR7mjVX8ditb+m/0aDAjM6PVM5AUvSrt9/QHrF/lhmTYrHSVrw5jp2C296j6hiCyUjSGnBlc+BNkZ4Qts3Z3c5w/mY1tlIum3AQKunE5zptDvEiSRuYQ46d3AvHjDrGNZNU4NP13WvyeaplHNaO5UbqlAPof1sA9xcspuNA4uMxh/gZcWqBpV0c+o9DjGz6d+FSrTMxIeKOdMpN0ms7f2t4ak6jAyG/J9PDbAF8TVWSzGepUKG3SExVGwFm4BzrxoHI/pYNr4w0DSYDFRYVCx97f0Jrkt/ujJtUM2Sco1XUN74M3sfvqxADgtVQczwPqSoVyy5NRE9EOq2Zth18AWttoXs8o/cq27BhXymrxzo8uxiELWgGwHGLGuSqgpDf2Wsdq5cYoxh9+4icpj3ZKWqAeOPQFa1xTjkr10UzTbl2ONb+CxE8LahRGDNoNWnQpVlMJ1SD6bExgFsEThgPgdLnDPXo8FtkEtciWxdqmrNlhc6fWZdO2sOPSr8/lO78hTRGj3kcA+tHg2RkDWmCozvQmjdqpwwvul9gjYxyRqgpg3vONahO4Uy92ASiWkDMo/nbRuIaBOXWSxGEs6lcrtS8FnZcSB7yOU/G2PJbpMtFtKwc6r3fdGbjsUFk5QNmKMHaZrncjCZ9Z0BGJ5EZSJSpzBO7J/YrU2c4xGbnF037MlH1oDasUekbDcqFGFrRGR9eZFKhulh13EceFg6exsUSdEmcGWtYeg4vmfh5bEJ0CsxiKNR2fqKECTTNfD9mZ5tjVfAzhjneyXgN+8cFm92vzDzsO2FZaWEnvtHq68n+iZJdqiS7KkFCUA1bbE9N/5+tm0hwKSBDoi2WKBb+7nSQHp1sBQFbGby
 W8sDt7IA
 O7urWSBWk4C7mpQJYVVYnshtoN4i7psMLtNOvY8tvIjmlKrxc+yX+b617Zx1Hcic7rzpzGLW/hH4hc9DeIAWYMM+iAEpfzVyOiXGCUVAEyzrUW8RqSn1EP/u/WXajnprRQgqROhMLKPI20paDQp5avLewxoCM+QJ/KUMfJzIg0/e6+9QubzYmU91bsEuLidmr+uBrasW02oTE08Z2Rd3w9RjF/yGCEuDJyZYCoTSLIiK26+hmwSL3UJvo57ugJ7n4QL5/CDIQy1FqcVjymnRKQJla1JlbhbwQlqUkAfB+yDg1IWTvx5zxeEgh5OlihW9A5iHJECQ/Zqva2LAvMddTCFa3yUoDGnl+gGbsjNZ7nwiZA673pkhAiLrS3y83oIfSVQaApNMR0WhzBvY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 4, 2026 at 3:55=E2=80=AFPM Max Kellermann <max.kellermann@ionos=
.com> wrote:
>
> On Wed, Nov 4, 2026 at 4:40=E2=80=AFAM Barry Song <baohua@kernel.org> wro=
te:
> >
> > On Tue, Nov 3, 2026 at 7:37=E2=80=AFPM Max Kellermann <max.kellermann@i=
onos.com> wrote:
> > >
> > > Rotating or onlining a memcg currently uses hlist_nulls_add_tail_rcu(=
)
> > > which walks the destination bin to find its tail while holding
> > > `memcg_lru.lock` with interrupts disabled.  With thousands of cgroups=
,
> > > this takes a long time and causes severe lock contention.
> >
> > This is the main cause of the soft lockups and RCU stalls,
> > right? If so, we may want to add a Fixes tag.
>
> Yes. I added (for v3): Fixes: e4dde56cd208 ("mm: multi-gen LRU:
> per-node lru_gen_folio lists")
>
> This commit added lru_gen_rotate_memcg() which calls
> hlist_nulls_add_tail_rcu() (full linked list walk under spinlock).
>
> > The fix itself may not be directly applicable to stable
> > kernels, but based on the logic of this patch, we should
> > be able to work out a backport, right?
>
> The primary copy of these patches lives in our kernel branch that is
> based on 6.18 LTS.  So I already have a set of patches that can be
> backported more easily.  Do you want me to submit these versions, too
> - and if yes, how?
>
> For me, it is not entirely clear if a stable backport is really
> necessary (thus I did not Cc stable).  It's not a bug; just awful
> performance when you have thousands of memcgs, but few people have
> that.  But that's up for you to decide.

Okay, thanks!

I guess we can only reproduce the soft lockup with thousands of
memcgs being rapidly rotated by artificial test scripts? In real-world
scenarios, would this be more likely to manifest as a performance issue
rather than a soft lockup?

If so, let's focus on upstream mainline development first.

>
> > Another option is to leave the cleanups in patches 1 and 2
> > out for now, and make patch 3 self-contained as the first
> > patch in your series, if that makes backporting easier.
>
> I don't think that makes backporting any easier - they are not really
> cleanups, but refactoring to make [3/5] as simple&small as possible.
> I wouldn't squash them; it improves nothing but makes review harder.
>
> > I'd appreciate it if you could also mention Ridong's earlier
> > work in the changelog:
> >
> > https://lore.kernel.org/all/20251119083722.1365680-1-chenridong@huaweic=
loud.com/
>
> Aye.
>
> > > +       if (at_head || !last)
> > >                 hlist_nulls_add_head_rcu(&lrugen->list, head);
> >
> > Do we still need at_head now that MEMCG_LRU_OLD has been removed?
>
> Yes, for the "!last" case.  This is, unfortunately, a special case.
> If you prefer, we could move this special-casing to the hlist_nulls
> API so callers need not be aware of it.

I mean, you might not need `at_head` at all if you rebase your code
onto either mm-new or mm-unstable.

https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/log/?h=3Dmm-new
https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/log/?h=3Dmm-uns=
table

Thanks
Barry

