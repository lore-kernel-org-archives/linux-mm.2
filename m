Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FCC4606A33D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=W+eaxTWh
Received: by kanga.kvack.org (Postfix)
	id 615506B00EF; Mon,  2 Nov 2026 05:00:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C5B46B05B1; Mon,  2 Nov 2026 05:00:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B3CD6B05B2; Mon,  2 Nov 2026 05:00:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 222736B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:00:43 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B5A99C0C75
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:00:42 +0000 (UTC)
X-FDA: 85389734724.17.D1B732A
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf21.hostedemail.com (Postfix) with ESMTP id C5CB31C0015
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:00:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=W+eaxTWh;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793613640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=amSkxba5qfGyP7Qk9zi7pRhILciZaFXKsvrCsRUizH0=;
	b=EYmpKfUBFS9JRX7dTWMbl3VywvuxZ/pZ4hdHB+qb65fuNvQFZmZ2MMyyvuDWVCdePSRnPz
	yCrhIcXiUah26J0gmQjzIMR3FMO501pozZsmkEaTRIfRkdVXZgQgOnNOmR7c6o/+idEtFd
	C2JAy/pOKe4+HWs+kSIntzNQOXtlLtw=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=W+eaxTWh;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793613640;
	b=Hu8DXXH/zqiNxV8bY95Nm0Qo50ZdPZGJY0qvCNVpAL61Cjvr+DIBQ1gUqzNa2Q7H4dZfnV
	+pPRxZQghg6BTLkOwlKh2+mWlcGsWSU03aOc4zqvAwg47kbAqIuuDMnrfCe4jSTyU+gnpV
	gg7dnC09EMBOpDkSFOTsdpMQroyW2Ac=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a2d6cf958bso12001175e9.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 02:00:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793613639; cv=none;
        d=google.com; s=arc-20260327;
        b=khD4kPRB05ANFZnlEUrgbaoa2jH1tZbboK+NuvB4l1jKKzp4a78R68I0iYL7hmzt9o
         FbdEje5UPTiAYphSjHuvGrW6K7Yc2M3e5l/Bw8OiHBV3YAa1oKxD78jQh+r+13WDYDYO
         te07u9sHYV2/XiBzvgCm59x2nxy5jHqJf9FmxfC4waYO69ACZ+KqRRjJEqrvAPip3LX2
         9M2hAjjhM7iBPg6wNr1tslcXitesferg9lS1TmJETp9W3Oh1WxL8UzrjDveehOQtLa7e
         T2J5M9AOTLdGR+lV0oiLPc6pGCjHrPkSJht0PB6kDCBDJ0gfvU0wJafJOVh7q/g04yCs
         v2UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=amSkxba5qfGyP7Qk9zi7pRhILciZaFXKsvrCsRUizH0=;
        fh=LsfcbaAaDn2pyZB9o+UH+7N/gVVO1AUkX62ESjs9srk=;
        b=E4Fl676WoEWP7B+tNjbudqyCtZBpTotqp1WhtknIbQPips5YEo8H1cCmFKyPMtGXRb
         WfWOKWGs3ij4ktKleqoV8XS73hm1go1M1M74rewxdq2pkQbI8CeWuWWz8JSvBfs9PF+2
         1EfUtTd+Pwvy8opoZdQJEng3uS+iVbJUqFyKFJ18ZkWBEdQ3S0TekSETvPZGMT5ycRsX
         rlZlAg3KE+FA6GWdC+q69X2NNUa4axhzZXCztm82HhiiEN78VOvx2Y3jUw6dxrC/I0Kw
         vsG+a9PMWqkjfixGOY7Edx5zhKutavkrEzb37kE+Sj2xeJkPIlAWs2v5r/ESLyttcVaG
         a6+w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793613639; x=1794218439; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=amSkxba5qfGyP7Qk9zi7pRhILciZaFXKsvrCsRUizH0=;
        b=W+eaxTWhZmT74L6FmRrTHyZ3N4y7j4q+JylD47+bzNmIvAyxg7SVbn6Hv94wnQehkD
         k130XdCrDAFJvG11ps7c+Qw/Wuds26pbsepq4Lcxa73H3m7XTm5FjEhuT69d337UM/ML
         VZ2ZIkuBe2yUTDLvNqgsq/j3BCq/9NmuFJohmnLjWj7H+vQOPfVXlWQaeUvaG7UHH4Zz
         ixwmUn3YDCDywU/LbLa3lo75+G5Qf0QttEZUknEUPB0V3aI1K10MvTVYvtxVTQ4LgDPA
         oY5Qwl9+9F6SK2hi860d6147o6rFCkUFgmQmyTfSJlmOqjTWdk9+cptjOIrp7p58S9np
         0ICg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793613639; x=1794218439;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=amSkxba5qfGyP7Qk9zi7pRhILciZaFXKsvrCsRUizH0=;
        b=gTEZeqdyYtoRoTXahqXTh9lqrdhKQHt9DdFCeJgimCpjgxX++yt4sTeT/IRSlTc0HQ
         zZ4wlgXSfOzusCAoEY9QyNqY8OH9c1xjzB6l99/Uwy5Vgr7WC6wnELTJ0X8g/Tb0D3Nu
         YDVcFL5aDfVHunPf7A3DxtSHzB5Iy2Wx+4HkHDZQEYhGW5cDiQ5q4HV3QnqCe8nHPJTU
         5MHVsMPkOKbk9DvdYWMCx1kmLdUWNjWAyhvjiP6DYkUs4ZmDnZ+uuooPjRIPRR3i25ZJ
         DiMDCGmXkbJYSWOp8IklxSKfnQMLlv5ldZmSqGfaXW8qudySz7AEiUbXnyiXctg2xkcR
         2ehA==
X-Forwarded-Encrypted: i=1; AKwUvByuk4/g2bKT2edbkAwScZlOO2F+XeQZzLIiV6KIZ2f3cbJlN0KErz3ZT2UjMv4Y5JtP1CXcG6uPKA==@kvack.org
X-Gm-Message-State: AFq9FYJGsA0BjozbCtQGtCniXwj7nVVEmS2LhgEAueey+xRA2AkgFVRZ
	O3R9SWlian9J4XC/GuU4yE5jcHecFJNgIT6GDKrtaZGWmiopO+/XZZW6Nl+n65/fsT4utJJUAcn
	GThBeBT6uzocywB3p5Ewt7EvyzJodV6k=
X-Gm-Gg: AYBFou0iFf4YhOErPwK9B7oRNJtqIofnHaokdIst5RZU4s39v8eSI37AUIg3VZHzSB5
	UDVRM/0H2Xc954mZrB2j3k8X0ev2xosy46l0pALMcND7vrYaRRpDnwR1jqpNAIJX7acUNPGl3+x
	Vf3FDtSN6SgzRhKEqMF5ybOaOlTVPNFma/Ynomk1p0I11zLCtcVoOhpS3AkbRDyoXc7ZpuFO/GS
	ZQGEuneYs8CoR/+UUzT1Pky0Lyvu79Y7z1la8tZ0U8Bc9mXZsb4Zk9hmfasoGWTlNqd+KzFWe2Z
	xaL0w+II/KDJmYopRCJtFX2Fp9+Cx3F4kJNBO/GuQbiQn32ZywORr3k6xdiYqVyHsKzbZXfT5dT
	HS90JdPTAO+u5JSxUhcupEOsDiG/Kgzt/9RtNhz+BNWkWjHqrnrvcxgavy0O7+dr1FD7s
X-Received: by 2002:a05:600c:8b0a:b0:4a2:e0c:2b0a with SMTP id
 5b1f17b1804b1-4ac1709a200mr224792265e9.16.1793613638622; Mon, 02 Nov 2026
 02:00:38 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261022220203.91911-1-baohua@kernel.org> <20261022220203.91911-6-baohua@kernel.org>
 <sashiko-outbox-183271@kernel.org> <CAMgjq7C4Tu1zVCpyv82aXrGh_rmkQLngGCkoKvQrRgEYf7sC=Q@mail.gmail.com>
In-Reply-To: <CAMgjq7C4Tu1zVCpyv82aXrGh_rmkQLngGCkoKvQrRgEYf7sC=Q@mail.gmail.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Mon, 2 Nov 2026 18:00:26 +0800
X-Gm-Features: AclHuK98JNvzxZC08YSH0QO_4Na3EWlc07Kgyk4sBPqBWgkibwQxiMB2ukaoSnM
Message-ID: <CAN_Opa-AScm9=EeXO_Uy8VjbQ=bqY9P++rFP8H1RhUB4dOt6xw@mail.gmail.com>
Subject: Re: [RFC PATCH v5 05/14] mm/mglru: skip zones above reclaim_idx
 instead of rotating them
To: Kairui Song <ryncsn@gmail.com>
Cc: sashiko-reviews@lists.linux.dev, "Barry Song (Xiaomi)" <baohua@kernel.org>, 
	akpm@linux-foundation.org, linux-mm@kvack.org, hui.zhu@linux.dev, 
	axelrasmussen@google.com, baolin.wang@linux.alibaba.com, david@kernel.org, 
	hannes@cmpxchg.org, ljs@kernel.org, mhocko@kernel.org, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, weixugc@google.com, yuanchu@google.com, 
	zhuhui@kylinos.cn, baoquan.he@linux.dev, liuxiang.277@bytedance.com, 
	wangzicheng@honor.com, lianux.mm@gmail.com, liam@infradead.org, 
	surenb@google.com, mhocko@suse.com, rppt@kernel.org, zhangbo56@xiaomi.com, 
	lyugaofei@xiaomi.com, ridong.chen@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C5CB31C0015
X-Stat-Signature: 7fuxaygsojbnyftt83jhtd3shpgbd6ya
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793613640-884243
X-HE-Meta: U2FsdGVkX1/tAMkjj3QBQ9txho99SnZkzI48MEPK2plqp5aP6tXdE4iS1Ddq72skSz0utvQFrTxITWzLokQbFHXyIgGftHf/SaNi0VKm9TcWesY/b1zrTRjuk8deXdEgsl24UpgeGftuIK0129MsgrRLY/yLEbtbUfmkb/bdi2cRp6ymfvMiCfJOGAn133JRf6CqFTcVxrflnzzW4a6fb9+pOrZdAeeoTejegIjN4FqWfE9X2FK+uKgiByRzL/riPoJg0tPQ61WynhfUlFQ4qBFfrHzNvsJnYWmHDeROotSasRiUDZ1a0mSBxSqeUmivJ5/FjEYePeH9/L6COObFfVcGwTg7yG5RTG8u1VZh+B/7jP1V4Ui+Ln408bw1/iPpvD40XHlQ1Q/TXn/TqUNbTe0LBw4iqJF7KdTVmtShSRzit3U/X8+Ni3QwQ9UzrO5fcy8d0i10rGud4obnrm2WsYfEWL5/92++fl/schqlAIeLPB71kz6KE6WhBUIkbBEv8dTa8zpe1GUVeQVViGLzCbPFh2MPa4//e1yKw1Ele5/zsylW45TFKxLkcHafoQw7KY8u6wVE6hmCncpHHsGuattrkjf9RhFcc/Bva6n11kMPNKfDqijrkGXLIKBk8hS/h8gG8EyNmdHumuNTX4QTNpfmBC78IGPwWHRjGuuEqzbcuOdHZ3uren4e2xJiyR6j6NWCACwk2ReCNK6OzsJcjVAqEIEl0+F2bGr2FQX5q3oaSL1maWxs3HHxqxwt42I0U/b9H88G6apBTVkavdQ7TxPZcgc4I8IJ1nJHb/m/tiqYYKwIz162cxHXrpOuBZxLxu7zlFVkrt9/n5U4e8goKZ57ITtPRwxYzFWJw7nq87Ox8dOC1XSLxQkFXEN2G21G+wl32y22l61hgVnpSr43znly9HhQ+0KyBxUolB1/CN9u2BX+TDLLgxmUlNs0yjyR1oHHHAr/p5I8xtkApMp
 +QkBAYXv
 FwE6/8aXkmwK+4ZIZLYBTLw3QU9L7k6IRZrOOdziAF5Tb7N4NRfjt6FGAmVw0lZrSLPXA846ty4/H4eBKcr0jauZfxwPvmLYpbNGMDMzbznolJ/UvgCiM4ZBFCTNnaHyAR9z1xc+MsGM1urnSKRRo9BhM/tLQu6qYnGKnlI3aPAVg4LijeWrkgO6ThEB8gSinmDE1ze6mesE4U52V46KthzntpBrkiuQVk585FNlI/VOheTfAmhFlszfSZaP8sCRvl4izy9AO3XOqt/rgxm2B6ndeW/16sA2iyTwE6VIE2mLz1H/VvyOUEtpgSEvs7EXHvARucIjp61JGjaLH04w7nlWIQeWZ4ukxj84KYmsGg7/YWbZzuVEYeDbQ8pkMhSni775MeBKkqfO8qdP6njVA8ePtbP8ysKVrwgOMUeJScN6lWH15d2IbNJLViwCZg7ncG8YdRswx1fn/N0DsT21u8iQSBshNWf3HJT5eDGT5jtiP8S1FUOChkEZS3CeaW+MQdE8jOyFqhKsa3xLTN3AsLnUR6xfSoqBKyoStTz6JswZl0lTcONS2SoU+DosjAv234Tnw7UgzO3lNdCjfGNelE5EcoA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Oct 25, 2026 at 12:19=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> On Sat, Oct 24, 2026 at 6:03=E2=80=AFAM <sashiko-bot@kernel.org> wrote:
> >
> > Thank you for your contribution! Sashiko AI review found 1 potential is=
sue(s) to consider:
> > - [High] mm/mglru: pinned min_seq in higher zones stalls aging in scan_=
folios()
> > --
> >
> > commit 1b2f683d6b8bd1e171eb9677315ba8a3d9431b9b
> > Author: Kairui Song <kasong@tencent.com>
> >
> > mm/mglru: skip zones above reclaim_idx instead of rotating them
> >
> > This commit restricts scan_folios() and lruvec_populated_min_seq() duri=
ng
> > eviction to zones at or below sc->reclaim_idx, and removes the ineligib=
le-zone
> > rotation branch from sort_folio(). try_to_inc_min_seq() continues to ch=
eck all
> > zones up to MAX_NR_ZONES before advancing min_seq.
> >
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index a365a4bc8c988..09ea72b354a56 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -4132,7 +4132,7 @@ static bool inc_min_seq(struct lruvec *lruvec, =
int type, int swappiness)
> > >
> > >  /* Similar to lruvec_evictable_size, return the oldest populated seq=
 of the type */
> > >  static unsigned long lruvec_populated_min_seq(struct lruvec *lruvec,=
 int type,
> > > -                                           unsigned long max_seq)
> > > +                                           int zone_limit, unsigned =
long max_seq)
> > >  {
> > >       int gen, zone;
> > >       unsigned long min_seq;
> > > @@ -4143,7 +4143,7 @@ static unsigned long lruvec_populated_min_seq(s=
truct lruvec *lruvec, int type,
> > >       min_seq =3D READ_ONCE(lrugen->min_seq[type]);
> > >       while (min_seq <=3D max_seq) {
> > >               gen =3D lru_gen_from_seq(min_seq);
> > > -             for (zone =3D 0; zone < MAX_NR_ZONES; zone++) {
> > > +             for (zone =3D 0; zone < zone_limit; zone++) {
> > >                       if (!list_empty(&lrugen->folios[gen][type][zone=
]))
> > >                               return min_seq;
> > >               }
> > > @@ -4166,7 +4166,7 @@ static void try_to_inc_min_seq(struct lruvec *l=
ruvec, int swappiness)
> > >       /* Requires at least MIN_NR_GENS gens for basic functionality *=
/
> > >       seq =3D lrugen->max_seq - MIN_NR_GENS;
> > >       for_each_evictable_type(type, swappiness) {
> > > -             min_seq[type] =3D lruvec_populated_min_seq(lruvec, type=
, seq + 1);
> > > +             min_seq[type] =3D lruvec_populated_min_seq(lruvec, type=
, MAX_NR_ZONES, seq + 1);
> > >               if (min_seq[type] > lrugen->min_seq[type])
> > >                       seq_inc_flag =3D true;
> > >       }
> >
> > [ ... ]
> >
> > > @@ -4863,10 +4864,8 @@ static bool sort_folio(struct lruvec *lruvec, =
struct folio *folio, struct scan_c
> > >        * longer be promoted or protected, so just isolate them. The o=
ne
> > >        * exception is lru_gen_reparent_memcg(), which is handled abov=
e.
> > >        */
> > > -     if (min_gen =3D=3D max_gen) {
> > > -             VM_WARN_ON_ONCE(zone > sc->reclaim_idx);
> > > +     if (min_gen =3D=3D max_gen)
> > >               return false;
> > > -     }
> > >
> > >       /* protected */
> > >       if (tier > tier_idx || refs + workingset =3D=3D BIT(LRU_REFS_WI=
DTH) + 1) {
> > > @@ -4883,13 +4882,6 @@ static bool sort_folio(struct lruvec *lruvec, =
struct folio *folio, struct scan_c
> > >               return true;
> > >       }
> > >
> > > -     /* ineligible */
> > > -     if (zone > sc->reclaim_idx) {
> > > -             gen =3D folio_inc_gen(lruvec, folio, min_gen);
> > > -             list_move_tail(&folio->lru, &lrugen->folios[gen][type][=
zone]);
> > > -             return true;
> > > -     }
> > > -
> > >       return false;
> > >  }
> > >
> > > @@ -4921,16 +4913,17 @@ static int scan_folios(unsigned long nr_to_sc=
an, struct lruvec *lruvec,
> > >                      struct scan_control *sc, int type, int tier,
> > >                      struct list_head *list, int *isolatedp)
> > >  {
> > > -     int i;
> > >       enum node_stat_item item;
> > > +     int zone_idx;
> > >       int sorted =3D 0;
> > >       int scanned =3D 0;
> > >       int isolated =3D 0;
> > >       int skipped =3D 0;
> > >       int gen, max_gen;
> > > -     unsigned long min_seq;
> > > +     unsigned long seq;
> > >       unsigned long remaining =3D nr_to_scan;
> > >       struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> > > +     struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
> > >       DEFINE_MAX_SEQ(lruvec);
> > >
> > >       VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
> > > @@ -4942,24 +4935,22 @@ static int scan_folios(unsigned long nr_to_sc=
an, struct lruvec *lruvec,
> > >        * when under pressure to respect swappiness more and reduce IO=
 cost.
> > >        */
> > >       if (sc->priority =3D=3D DEF_PRIORITY)
> > > -             min_seq =3D lrugen->min_seq[type];
> > > +             seq =3D lrugen->min_seq[type];
> > >       else
> > > -             min_seq =3D lruvec_populated_min_seq(lruvec, type, lrug=
en->max_seq);
> > > +             seq =3D lrugen->max_seq;
> > >
> > > -     gen =3D lru_gen_from_seq(min_seq);
> > > +     seq =3D lruvec_populated_min_seq(lruvec, type, sc->reclaim_idx =
+ 1, seq);
> > > +     gen =3D lru_gen_from_seq(seq);
> > >       max_gen =3D lru_gen_from_seq(max_seq);
> > >
> > > -     for (i =3D MAX_NR_ZONES; i > 0; i--) {
> > > +     /* Scan eligible zones in descending order. */
> > > +     for (zone_idx =3D sc->reclaim_idx; zone_idx >=3D 0; zone_idx--)=
 {
> >
> > [Severity: High]
> > During zone-constrained reclaim in mm/vmscan.c (where sc->reclaim_idx i=
s below
> > MAX_NR_ZONES - 1 and zones above sc->reclaim_idx are populated, such as
> > GFP_DMA32 reclaim with a populated ZONE_NORMAL or GFP_KERNEL reclaim wi=
th a
> > populated ZONE_MOVABLE), can keeping MAX_NR_ZONES in try_to_inc_min_seq=
()
> > while removing the ineligible-zone rotation from sort_folio() stall agi=
ng and
> > memcg rotation?
>
> Yeah it can stall aging, but this series lifted the restriction of
> MIN_NR_GEN on eviction, and eviction will start the the last populated
> gen of a zone instead of min_seq, and we have more proactive aging
> when the gens are imbalanced, so this won't be a problem, it won't
> cause OOM. I'm not sure if it will cause any performance issue though,
> if this is concerning we can keep the old behavior, or trigger aging
> when the populated gen that satisfy a reclain is below (MIN_NR_GEN -
> 1) or imbalanced, this seems a better solution to me, still avoid a
> lot of redundant work while ensure there is no reclaim effenciency
> issue. We already have the right helper to do so in this series, so
> seem not hard or dirty.

Thanks, that makes sense regarding OOM.
Could lru_gen_imbalanced() trigger aging soon enough when few
populated generations are eligible for reclaim, or could reclaim
efficiency suffer while min_seq remains pinned?

Would the additional trigger you suggested for this case be worthwhile?

Thanks,
Kunwu

