Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B272606A327
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 02:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cd357yU2
Received: by kanga.kvack.org (Postfix)
	id 333AD6B05B8; Fri, 13 Nov 2026 21:27:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E5316B05B9; Fri, 13 Nov 2026 21:27:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 221F96B05BA; Fri, 13 Nov 2026 21:27:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EC04F6B05B8
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:27:26 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7B09AC034F
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:27:26 +0000 (UTC)
X-FDA: 85432138092.16.76EE5CB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8516220006
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:27:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cd357yU2;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794623244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i+Dnnd/gI7iMHU71/x9uL0ktAaO1UMoD8OaDQ/QTl0k=;
	b=HQC/WvEAA/pCWxPYshYQ5yN+K7CC7jqVlFYsUXvAspn6ldWe1GC7Ex5FiZVyfiwVIlJhuK
	qUwE7/aVN1yLT5m8DwtIdtnisPVNUy7epBVl+yGFzXG0aNV1T4uYChZAmf6X638xFwbL3t
	xeKwkCYQMd7NFZ2xSgFabNtNs0G43kw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794623244;
	b=qDAQKBWh5cWaBkCKctdaWf39DCh/ESggnklOu46FF7UlEl4aGnTcl/nsHUeab52vlLZaUp
	WYgBJVSih+53gZORq9P8dBAMnx+D8KoU6ZrdPJDovqm1K05p9yyuJ+KrjfI/mOOEri2Z7E
	948rpAxokLO7oIVx9dyVgmZ0eH+EC2A=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cd357yU2;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AB0134655B
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:27:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91EFE1F000CB
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794623243;
	bh=i+Dnnd/gI7iMHU71/x9uL0ktAaO1UMoD8OaDQ/QTl0k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Cd357yU2vwvBmMA5egy+ScUSy42kd2gJ0WqJD+8nojYCnhMkpwnZfVrjWtaLRMpSe
	 4rp7Rc/PmY5zivdAtlEc6O5+a4R/rp7ALeBS2Mackb/nwVmrIfrBNoG/xKj3XtWiHF
	 NoFPeo81VdKqlhhIkL4LDyb1ADq7SFcZw1GqEq4LwvMx+FaYV1j7mCyI5oEAkeeXCi
	 vMUiRH/zpMsR/kgszKp3LPMpNpuxP1wt4gHxP3VO2i7dWOGtDgz8xjhQufc1kBrJQL
	 hGsZV9KShKlGFsIoL/ZrUgRCdbi3eAgnDhDL+980VjO5aKZMrm2WOhrXKitJwL89J7
	 SGe2ZVEAvkcEw==
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-94959217274so219543285a.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:27:23 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEPjpA/0LvgtnscVbi//ryYe7A/ffJeSzuEtqKoWsqE9aVkg7EXkab9E70cwNMoE3AtIQ6zNSekiw==@kvack.org
X-Gm-Message-State: APuU4Z8fnQMira3VNljZXm2s16BTCQCpjLmsQrw61zfcIJs+rTLMIegU
	kv7MytqVs3AgGS5q5Dm8SEqWKP5xP0gH1OdWCgDo86juzLWEoGJtaO915Co62VYMSHcb0FKiucr
	Nfn717O93u9W2qyGOoh02OmrA7KbKnOI=
X-Received: by 2002:a05:620a:4686:b0:93c:5bfb:9a80 with SMTP id
 af79cd13be357-9494b9c66c8mr756327785a.3.1794623242680; Fri, 13 Nov 2026
 18:27:22 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261113185541.70203-1-baohua@kernel.org> <20261113185541.70203-3-baohua@kernel.org>
 <sashiko-outbox-214021@kernel.org>
In-Reply-To: <sashiko-outbox-214021@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Sat, 14 Nov 2026 10:27:11 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y0KR86ABy5-Qpmk0ws0LMXB3nZTOcnhPL_Orr1_f26-w@mail.gmail.com>
X-Gm-Features: AclHuK_VcdHScuYuDyl1DzSIbcyPv1Xg9OwGFirFhFZx4rwZiHRRoplKBudRa38
Message-ID: <CAGsJ_4y0KR86ABy5-Qpmk0ws0LMXB3nZTOcnhPL_Orr1_f26-w@mail.gmail.com>
Subject: Re: [PATCH v8 02/16] mm/mglru: extract lruvec_populated_min_seq() helper
To: sashiko-reviews@lists.linux.dev
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org, 
	hui.zhu@linux.dev, kasong@tencent.com, kunwu.chan@gmail.com, 
	liam@infradead.org, lianux.mm@gmail.com, liuxiang.277@bytedance.com, 
	lyugaofei@xiaomi.com, mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev, 
	ridong.chen@linux.dev, rppt@kernel.org, ryncsn@gmail.com, 
	shakeel.butt@linux.dev, surenb@google.com, wangzicheng@honor.com, 
	weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com, 
	zhuhui@kylinos.cn, sidchintamaneni@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Stat-Signature: cc11uzxfsu7suedq7rp411g78fumcf78
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8516220006
X-Rspam-User: 
X-HE-Tag: 1794623244-688046
X-HE-Meta: U2FsdGVkX1/Q200H2FnOtRXTUzuEgtljQfeTQpAMl0JyFY+KNngkTwnuK+nXdEAi+8Bq+BK3YzeopIbVEZoNvHWMcu5qXh2yLC9I5nDedZJiwk8l4UGR5aM+tFx1wFa3Kewck7pH8sEmeB3g3Ki9RGxO22GrPX7/sdthKJVmbvk/S6mk5cXWVU1M0O7STiXcTXdfFIFRR7l9liUTThM4kIjWu8dSuMcLxaL0fC2wlVZaRVra8xX0WAM0mMPeYRLDpo6uuKWGKVFkOPrODeKhOJzqe6O3sd0TPhqXzkNBDuesfuW3yHgdCWiIu71Y9DfrsVxxqFUEM2pgtBTUVk+sIOLQcqQapIXS9khVZyE9GBmCLz7Vl1gcC/0+3/qmaK+9tNqZEddntKF7lkiEQDX67G3pKk3DDK4QvqJePXxrlRAHY4CyCf82CPzVOM8XZAFm1wnltVNryfJQ4eTdW94VhNPvS2F0EynxY1P9YGBvcc0xGw6EqJlY6yUiWkMKAqhwQ3igaMQKKNJYRtaeYb8L7B9rIAMZzXPVYyDbqvnUpCqeDrwnXjNfszPZNdZaKs1MBhOItEPtbUrJ37sqdriC81lqwSDYSh1mCPg+eh3S9Xy7V6Lhq0bVPqitUyfaQ9BRq87w1l+TY4e085W0DhZYj5FFOvhHtMhz0QCXtMNaiyx6hP6r28BO32D9jfONWpl6OVUDIcXoRA6LjY/QhpusLVjk9lvcIoNZNLVZ7K/7lrSIuBfEdnPTD4hdY91ACLOtTpDMlIQbM98C008Hn/TNntZldqlkH0Y5qGdVPuRj7L7V7/g1dHpyc7VxyB+FyNAE4VquBb5lg2y473hFnZ1xmu/EBa0pRUG9nwEHXPp3U9SX3OxPrLH2labcdcBEEQP27A4N3UEOd8JsErDFQBseaFdogo5W5hUUgBYqkw9mbwRzisKrJ2BCriiuCfxtsHbToGYbgidwu2fEh13pSXK
 pPIwfouM
 10f2N6MMJvHbuAfhcTdjygp7AITZgvMnpvH1+1+R4J+b43VB56qCPsTJGZgo9paY4tksKAJxIYOKujINVhVR5hRPuOyAzyDOECnEsE8j2rIjy95dgoNzB8VuX63eDXhBId28CfmotzWNQC0nId0OEAlN/MT3q0yzfEvX/CaTIe4RmVaxH7RkWuqlre3mWgdufa2glzmlY1DsXpmf4NOg+QmplHvTrSiuJeI2pEZ3Su7xna45/Zyyn3PwStE5CXqVhYaKPMFs5kcs/+xyqrv3wXYZxW5/jDz1C3d+aEFx6cDUGoVN8ivU56/cFEkgAOXOdiuPxwYFRbl8i32Jx0agjmo+5fThrPc5+KXb5L2Jh/fp9K9DY3o3uFTO/dZKn5OhBbZFiRlMTPFLT1grlGg5rMpIlZaUOJp+K1lOUN/hmkVbUHO1oV8C8tQ/kONCCyLeqYnsXH+P0vhUYVSVZhHwxznsEOrU6ETZCiiA6wj26zYw1eWcFIlgJy7knnizn0AFPK19L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 14, 2026 at 10:02=E2=80=AFAM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Low] mm/mglru: off-by-one loop bound in lruvec_populated_min_seq()
> --
>
> commit 9751ca1c29ca665233058e3a3c3cfa85cc385872
> Author: Kairui Song <kasong@tencent.com>
>
> mm/mglru: extract lruvec_populated_min_seq() helper
>
> This commit extracts the search for the oldest populated generation of a
> given type from try_to_inc_min_seq() into a new lruvec_populated_min_seq(=
)
> helper bounded by max_seq.
>
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 400f87fc51e12..27dfbd3ff02b3 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -3992,30 +3992,45 @@ static bool inc_min_seq(struct lruvec *lruvec, =
int type, int swappiness)
> >       return true;
> >  }
> >
> > +/* Similar to lruvec_evictable_size, return the oldest populated seq o=
f the type */
> > +static unsigned long lruvec_populated_min_seq(struct lruvec *lruvec, i=
nt type,
> > +                                           unsigned long max_seq)
> > +{
> > +     int gen, zone;
> > +     unsigned long min_seq;
> > +     struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> > +
> > +     lockdep_assert_held(&lruvec->lru_lock);
> > +
> > +     min_seq =3D READ_ONCE(lrugen->min_seq[type]);
> > +     while (min_seq <=3D max_seq) {
> > +             gen =3D lru_gen_from_seq(min_seq);
> > +             for (zone =3D 0; zone < MAX_NR_ZONES; zone++) {
> > +                     if (!list_empty(&lrugen->folios[gen][type][zone])=
)
> > +                             return min_seq;
> > +             }
> > +             min_seq++;
> > +     }
> > +
> > +     return max_seq;
> > +}
> > +
> >  static void try_to_inc_min_seq(struct lruvec *lruvec, int swappiness)
> >  {
> > -     int gen, type, zone;
> > +     int type;
> >       bool seq_inc_flag =3D false;
> >       struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> >       DEFINE_MIN_SEQ(lruvec);
> > +     unsigned long seq;
> >
> >       VM_WARN_ON_ONCE(!seq_is_valid(lruvec));
> >
> > -     /* find the oldest populated generation */
> > +     /* Requires at least MIN_NR_GENS gens for basic functionality */
> > +     seq =3D lrugen->max_seq - MIN_NR_GENS;
> >       for_each_evictable_type(type, swappiness) {
> > -             while (min_seq[type] + MIN_NR_GENS <=3D lrugen->max_seq) =
{
> > -                     gen =3D lru_gen_from_seq(min_seq[type]);
> > -
> > -                     for (zone =3D 0; zone < MAX_NR_ZONES; zone++) {
> > -                             if (!list_empty(&lrugen->folios[gen][type=
][zone]))
> > -                                     goto next;
> > -                     }
> > -
> > -                     min_seq[type]++;
> > +             min_seq[type] =3D lruvec_populated_min_seq(lruvec, type, =
seq + 1);
> > +             if (min_seq[type] > lrugen->min_seq[type])
> >                       seq_inc_flag =3D true;
> > -             }
> > -next:
> > -             ;
> >       }
>
> [Severity: Low]
> Should lruvec_populated_min_seq() loop while (min_seq < max_seq) and
> return min_seq at the end?
>
> When min_seq =3D=3D max_seq, both the early return inside the loop and th=
e
> final return evaluate to max_seq, so scanning all zones of generation
> seq + 1 under lruvec->lru_lock is redundant work that the original loop
> skipped.  In addition, if lrugen->min_seq[type] > max_seq on entry (which
> happens in commit "mm/mglru: lift youngest gen protection for higher
> priority" when scan_folios() runs at DEF_PRIORITY while get_nr_gens() is
> MIN_NR_GENS), returning max_seq yields a sequence number below
> lrugen->min_seq[type].

it seems you are suggesting the below:

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 18a3332c71e9..307a7cbf5bc2 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3995,7 +3995,7 @@ static unsigned long
lruvec_populated_min_seq(struct lruvec *lruvec, int type,
        lockdep_assert_held(&lruvec->lru_lock);

        min_seq =3D READ_ONCE(lrugen->min_seq[type]);
-       while (min_seq <=3D max_seq) {
+       while (min_seq < max_seq) {
                gen =3D lru_gen_from_seq(min_seq);
                for (zone =3D 0; zone < zone_limit; zone++) {
                        if (!list_empty(&lrugen->folios[gen][type][zone]))
@@ -4004,7 +4004,7 @@ static unsigned long
lruvec_populated_min_seq(struct lruvec *lruvec, int type,
                min_seq++;
        }

-       return max_seq;
+       return min_seq;
 }


it seems to be simpler than the current code. let me give it a try.

>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113185541.70=
203-1-baohua@kernel.org?part=3D2

