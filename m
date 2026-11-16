Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99B29606A333
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 03:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CJo63AYE
Received: by kanga.kvack.org (Postfix)
	id A247B6B05B4; Sun, 15 Nov 2026 22:18:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FBA36B05B5; Sun, 15 Nov 2026 22:18:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EAEC6B05B6; Sun, 15 Nov 2026 22:18:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 65BF16B05B4
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:18:23 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E0401C0576
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:18:22 +0000 (UTC)
X-FDA: 85439524044.23.18AF242
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf10.hostedemail.com (Postfix) with ESMTP id E7544C0003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:18:20 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=CJo63AYE;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794799101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/O0UqoG1L12MCxVVxaMuav5eOheizO1ao/WWSQ9qpIw=;
	b=0pViJ1uRK5l2IAwlfXnl3m8XsdC06q+iJaTg3UNFnOb4AkNnF+EPRLDrEq/usC0iOTZKxE
	k/6Bl2zHo4M2uQcMEBzgUrqX9RaUwywt/xCT1KRTdDtAhyVfZrzOknI/2G+OosRwu35Ma5
	NBwuaUHiCCR+2fN94mwCNV8ocXEkVjI=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794799101;
	b=LneZWF4RZiSfejDoOIPHs8Lm5lAKpj6WyulWpPSRVgWiXJ8aff1einXKUlNBnF86IZ7q0u
	Ycaw0hEXX7ZRsJtbY/4VL4xW6DXxB8y3vQZoAyhxXmYFL6slO8OtaM43SR7/6zYKeP1aHR
	2l4rm0Z6c1P9p0N68ew8FTw2+5gOIpU=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=CJo63AYE;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c506a231b88so414761366b.3
        for <linux-mm@kvack.org>; Sun, 15 Nov 2026 19:18:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794799099; cv=none;
        d=google.com; s=arc-20260327;
        b=hsh71fYYMGUFoyoxDIkMAl4v4r6da3j209CV+EVeTtvE/rwbrRtlh/RcmAKrvYDxHh
         05MJgPHboymzs1fPDOgrogiVnDk8b/y9nP6j6eEh07fGKkpBaUQYNYzqlroXEy7zVms4
         U5VlyUiJuz3IVfKnP+Bgn/Pf7B3DwrW09ghvD9UrYeXu0syuV83IBuw7eZXCWs7Fih1I
         y+lr8DQAIAAitM4mycYtNEklKrhA8JsEqaPgFAJTH7TO8jLXX0DPAKzuFCdSuEkqq2lK
         bUv/8k3C5R48o3+G7HM3+6dFCBvNDq7/0Cx8r0wrzeHQ2ePMuNokd4zxJIjC1/LEP9jF
         p5Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/O0UqoG1L12MCxVVxaMuav5eOheizO1ao/WWSQ9qpIw=;
        fh=ojALNSNLXJqqTc10AdI6IsHTXf38yEHvKaWKEDz75T4=;
        b=A8Zw+LKErrj2mkVyYBcZreW9qViclct8eTpHYaQAiN+1InCVjJSOt2uKs86AGrK1OO
         HPNhfuOPSrwYnp8lO5BEFhitYAZXxQLPTWwNW3pbZQsZX4+prd9Z4r3dXLgT0u/yA0WM
         qyqXb8CJtcFC1DV/XQtIS0dZBRUogleN2bzOMicsiQwFekd/aFHi4hgGKd9NYqD+d5O4
         nzFZ207VqFSuBGFCSClRXXjgF9SQasPmq7PFCNOkHnoXDfMVJE1E8BQGQZoTQzHvDO/W
         xnKDGXq1BU9Q9ZT3nOeoPCJWM6UR1/F1EcUMeJJD7UfpUmh7Ti+/dMoIEpcG3YZL6D4e
         3Lzw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794799099; x=1795403899; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/O0UqoG1L12MCxVVxaMuav5eOheizO1ao/WWSQ9qpIw=;
        b=CJo63AYEd9/3RtNYqOsDdhqtzQG28hr5BM53oixvcwAdgvabFhX+3xkH/LpX2eEqYl
         FRsX4fMrBkUpIdZQSO3jQ35eZ/pXDfOZsMIHDMyFPlPru/E0V8AjDrWyksRaHS0wG64E
         OYQPsR5sIQWndPENn+c/r5+6RhVv33VZrfPnalyxnefXudunhR2VlZKv3jOn2YiwHtkJ
         lnifb8GP90SS7+SVgsCQwGv2kRAChHEtr/MYGslhs3vIfLFtH80+e4m8KuTcT1W4WK7A
         4p1tOv4DyX1HsAm9QZx7aypow4aiRqrmxYlTClNP5wxPOok+NrTjt6wrFgbDJEL6EfYS
         IgTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794799099; x=1795403899;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/O0UqoG1L12MCxVVxaMuav5eOheizO1ao/WWSQ9qpIw=;
        b=bDdcWR4S+KO8JVExtD+66izMrekf285oIoAUUGfDZba/72PVNifuapUDdcLiCzqOcK
         jA0SnpgvWHBMc/juzaM047NLUI2gyQfCkstmr9ZhNwVwWCYsq79RTcMtBMxnyKz7xCp1
         1RvN2bFGcRFeLuxJ4NkCVWIuqrVFJF0rl6j9eKF2OcE81Yhi2vh3LUWAXlEfdGXDBlGV
         LF/KLxaqDVVEzzk+Pis1zpX0BpjNUJOl4AIWANmu4EizdtU0Qw4qs1Y+z2OJCJoIktIv
         TnpuDZXEGVJOa5+vqteuHnO5OJafBo1EsaynsKtP15Kxu99O3rv27kjMewL21FHQ9FY2
         rn+Q==
X-Forwarded-Encrypted: i=1; AL+hErHvSfC3CESpo3IxGa7gGdH0wHHUWqOcJfve5MyI332SGUAn6NqARPCz4UjZcjXIRwqsEOzINzuVgQ==@kvack.org
X-Gm-Message-State: APuU4Z/xEPwxHzsqKy5JMFDhacxouTefOewY8h2WQrr5lbEDW4DeRFZM
	Jvf/lKouxk5a9o88/FkrwvRzSB1xnxqBBbfwIC8hbQ3akxgiRq0yXvajjty8C4ND3fjKjDbxlfp
	Xw8QCyZCDz7UFoXHX4RTZpX3EGkBpVi4=
X-Gm-Gg: AYBFou0yKD/Y5pFeq+Cx1jP6uvyDa5jRZLrI16YglGDxdWvzcjiI9lwykU6cc/yJPZ7
	gyKUBfBXOx/AblUeMdlhG9vRrEECpyhueO892gfyb3R/ip6mBeVwGNO2JakiuaA8Rm/GLPfReA7
	pAJ4YUz3kVg7chRfAM7Fc0DYxOS2vr4FBBVowhnMzGeIbcwFSfX0NIVaMAHedMyC6YkCievPGVT
	xRe81PmG2TJ9pLranX0G+99r+GGx0kksf4KAhfJllzg6Kej3iTl8gkVedNx/6x7QskZjK52BXT7
	uiyXFZVJTYnyLIuA7DSxlMxZhtOO+5Ruldb1RB52i9LctJqTgpdkAnfc4ziQqVLmAePzzZzBRi/
	kgZa1PTSoFoVKFsUkGUvz9OXH+UnnCDtEw+2FLU2t4OpDPGKkFD1iaWxWl5Tg5S5UA76rBw==
X-Received: by 2002:a17:907:3e0d:b0:c4d:8e7:29b9 with SMTP id
 a640c23a62f3a-c50961d1c5bmr782313266b.5.1794799099188; Sun, 15 Nov 2026
 19:18:19 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261112081928.3014946-1-ridong.chen@linux.dev>
 <avV52J2rD19cjM2J@KASONG-MC4> <CAGsJ_4yibOkJmi9niJ8svu2NdEkZ5Qyf98VO6qMrJMa_9wGFgQ@mail.gmail.com>
 <c01ec177-da44-49bc-a542-35b64554526f@linux.dev> <CAGsJ_4xx8ivDeh1d5pvJOEgndRL8rf=CO2==T480pAm=j2X0ZQ@mail.gmail.com>
 <e4f50794-0c47-4fd3-8c3d-f3888f83dd2e@linux.dev>
In-Reply-To: <e4f50794-0c47-4fd3-8c3d-f3888f83dd2e@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 16 Nov 2026 11:17:43 +0800
X-Gm-Features: AclHuK-576g1ZsYN5Em4fQm0xWI0S0zRqi93o5imuX55ZMFCNfrCGTymUozk3ms
Message-ID: <CAMgjq7Co89oBiErnEE3q0=GncTDWPBvOYNysbZ4k5wccWQER8A@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: deactivate anon folios into the oldest generation
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Barry Song <baohua@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Yu Zhao <yuzhao@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: gquftp1m95t56dsf7af8wb8rsy8t8z9w
X-Rspam-User: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E7544C0003
X-HE-Tag: 1794799100-992917
X-HE-Meta: U2FsdGVkX18SyPpZgI8Bk6zuZ+Ag8/8aQ70r9WVLhaMmFA/9kvt1LgqoxJ2wYRMsfqBYTmyyVPIN0TKtCIBIuTXwKXMXd6LrHq7BRD8wn6jwaqdsWOs+VBoIgPNeaXIvR8sHDfFDD+UbegC9vwbx/CA8MmBh44z1kN+K25g9FyMHQpx239A5y9SYsEyNX2Dp/l6XCM6PO45Ac42dmpbn+TgXxlWu2i7Z8WZ4gF1wjZjhcfd6+IgWELMfd3DdM3pIEE9bYbcg7ZQ7JdwuGkX++7EHZ3g1r68uaqffmh+jZeZOFIro3VqF7vTkgKuDZh220UPbzA9EtT49k/xm2l8fSFu2B8yqsje+PmAv1W7dXCwBloj2TOXk42joaOaU/vYdV6TWAqfajE9rN56lhGVThRdqhhckE9TGn5VZ7Eu+3qVO+h9LzYSkgTG12wqx80cXzig+tionUPPrPCsDuCUSfLcG82z6GBGzMekQs8Frog1KEnyhM9DyMRdKdaY11jF+tpSIgY0OuuVZK/X6flVSQGYYJB5BzVQBEeWN7kfTmvvWWX0EbNXzLd2f+RCeChneOH/wGlIO/CwW1vxwwWbKTfFBWtYnwycsIDjEMOjxpSMB6CVuNZnlyhmOWXywGRyns+J945HEdrJ3sOJSYgvtN4h9f1gHhjTua+fMjzHQcIsknKDE0nGmum11zfoB+VdmP2MadeyyNwjpVtRYlwb4BoeznbPMqiTbJ7EfgsCWeM4ZaygrDPuKDmIBth+eCQncEM/jVfjcmdufnO3X69zPwWo2K+VCMT1cuk+AcOx4+SPpYgcmhCqTaDiZGBVr2ap1Xz1C7p/pQWiqA9q8bmR/+psRfoPSfRzz5QsIP6/UuTS7tVpXHfEEf/Xb9qkidugTl3WyrHvajFwUH6PdHKJ8+uzHJKcOhK+5rN48TRfhS6eQXrhCTG3c5ZMA5fpUP7laJhVsXXxUoOg9dckyOJK
 efbT403D
 U2CnRo592d2zmiQXKoMLtrGoacmZ7lvk1H4X/HyMstrLDjIS2Dh8VdHSLCTR52cObMhXTp353BXl/osZelw0DvMBiJ5aQhw4NpAxbogxxkOh1mLIzi0KY74hzWQbxZ4Rf7UexANXbgQyGHxKT3It06/9frBweysDJerRhZPFANYIgmRW8/mOOpMoWdJkjxSml58kLRIDsf30pDdVXKSBEaZjwFcjUEvhP1a/KjdwAupcPvX3lEP+vk/mUvQJhm/RwpoBpguZccNQxgbhQ3otPomBQRcXNOKFqP3AyYcJ+gbByf16Kd8y6eaEiSsgFShIJzq3dDQiHamnVgCBiU7NaNQ4ICtvEWLOPIlixtSvKci+QrvI/uAnAtSEpuuOFYG6HyUlO78XPbPZJzDDLr1GWVyRn6ZxQ9CY4f0LkTNi3fpWZSqRmD8oPD/LQyfK9lzEsJIwD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 9:48=E2=80=AFAM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
> On 11/16/2026 8:28 AM, Barry Song wrote:
> > For example, something along these lines:
> >
> > lru_gen_deactivate_folio()
> > {
> >          int type =3D folio_is_file_lru(folio);
> >          int zone =3D folio_zonenum(folio);
> >          int gen =3D lru_gen_from_seq(lrugen->min_seq[type]);
> >
> >          if (folio_lru_gen(folio) < 0)
> >                  return false;
> >
> >          folio_clear_active(folio);
> >          folio_clear_referenced(folio);
> >
> >          list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
> > }
> >
>
> I think that works, and it is better than what this patch does. It
> puts both anon and file folios at the head of the oldest generation,
> which matches the classic LRU, and it avoids the two problems I
> mentioned (too aggressive for anon, and moving file folios from the
> head to the tail).
>
> A plain list_move() is not enough though. We also need to:
>
> - update the gen bits in folio->flags with a cmpxchg loop, as
>   folio_inc_gen() does, since folio_update_gen() can change them
>   locklessly from the page table walk;
> - fix up lrugen->nr_pages and the LRU sizes. lru_gen_update_size()
>   warns on an active -> inactive move ("demotion requires
>   isolation"), so this would be done as a deletion from old_gen
>   followed by an addition to new_gen.
>
> min_seq only advances under the LRU lock, so it is stable here.
> Something like:
>
> static bool lru_gen_deactivate_folio(struct lruvec *lruvec,
>                                         struct folio *folio)
> {
>           int type =3D folio_is_file_lru(folio);
>           int zone =3D folio_zonenum(folio);
>           struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
>           int new_gen =3D lru_gen_from_seq(lrugen->min_seq[type]);
>           unsigned long new_flags, old_flags =3D READ_ONCE(folio->flags.f=
);
>           int old_gen;
>
>           do {
>                 old_gen =3D ((old_flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF)=
 - 1;
>                 if (old_gen < 0)
>                         return false;
>                 new_flags =3D old_flags & ~LRU_GEN_MASK;
>                 new_flags |=3D (new_gen + 1UL) << LRU_GEN_PGOFF;
>           } while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
>
>           if (old_gen !=3D new_gen) {
>                 lru_gen_update_size(lruvec, folio, old_gen, -1);
>                 lru_gen_update_size(lruvec, folio, -1, new_gen);
>           }
>           list_move(&folio->lru, &lrugen->folios[new_gen][type][zone]);
>
>           return true;
> }
>
>
> > Right now, lru_deactivate() seems unnecessarily complicated,
> > incurring additional CPU overhead and LRU lock contention:
> >
> > 1. Remove the folio from the LRU list.
> > 2. Add the folio to the LRU cache.
> > 3. Drain the LRU cache.
> > 4. Add the folio back to the LRU list.
> >
> > Why do we need all these intermediate steps instead of moving
> > the folio directly in a single operation, given that we're
> > already manipulating the LRU list?
> >
> > Am I missing something?
> >
> I don't think the batch itself is the problem. The folio stays on the
> LRU while it sits in the per-cpu batch; only when the batch is
> drained do we take the LRU lock once for up to a batch of folios and
> do del + add under it. So the batch reduces lock contention rather
> than adding to it. What the in-place move saves is the del/add pair
> inside the lock.
>
> So I plan to keep the batching and, in lru_deactivate(), call
> lru_gen_deactivate_folio() instead of lruvec_del_folio() +
> lruvec_add_folio() when MGLRU is enabled. I'll test it and send v2
> if that sounds good to you.

Right, keeping the batch sounds like a good idea.

And I think we can make this cleaner if we build it on top of:
https://lore.kernel.org/linux-mm/CAMgjq7A1dWJ6DoF6+CxfjysxjzAChWrdk=3Dz_Jvt=
LMyFWdoYTyw@mail.gmail.com/

By having a "lru_gen_add_folio(lruvec, folio, min_seq, max_seq, tail)"

lru_gen_add_folio can cap the target window by the given [min_seq,
max_seq], -1 means no limitation. Avoid a lot of redundant code, and
we still have just one unifed place to add a folio into the gens
(except lazy promotion), I think.

