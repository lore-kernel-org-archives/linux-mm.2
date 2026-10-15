Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22AE6CC6B38
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 21:30:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D42186B0095; Thu, 15 Oct 2026 17:30:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1B386B0096; Thu, 15 Oct 2026 17:30:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C06966B0098; Thu, 15 Oct 2026 17:30:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 946DE6B0095
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 17:30:41 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 131F81C206C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 21:30:41 +0000 (UTC)
X-FDA: 85326155082.01.29C80DE
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0885340005
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 21:30:38 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rLomQzxp;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792099839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6QOUwpYyaURolaGh43C2DQXMGVfTGXyyd22jdUdTcOM=;
	b=wBHHTFgkKJXAhxDarGVP2Bj0OvPJfQEtL4jBE1e/idYRVeKhnuQaFw2jA3/NWYCSk9mpRA
	QnU4WBkY1vFCJ+xWG1feUOsepBLnDczkTBEkEvLTza+UbdT8Nt+oD+C+9GJcjCrPivsgFl
	neJxyZIRQfaK7xGcyVFa2gkRNsQ3Aaw=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rLomQzxp;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792099839;
	b=fDeWT1VNCkpGHOJSX7i/A1T1s55Y8V382Cx5BpCWJVpaSd3T5PvEVKLBABilKw+ubeqwig
	U9mfTJQHOx8W6VNi6v2+deukU+KqUolUkv8YHTeGuiJb/xOo8ls+Y60enQDsQXnFfsqmdY
	HMFfe9+Tx+e9TayttjyzxbqpHCEhASc=
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-3a7858d3a20so19382611fa.0
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:30:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792099837; cv=none;
        d=google.com; s=arc-20260327;
        b=Gb2GDw8uMUS7whdfxY7sbq62qghzZJUJPk4t8AeXdiw9AtTlxI2LYitbkXTNIGbrc8
         gpX83C8a+ddnXLAWBnBr8pGyvYCWpsoYhLj9iL9iSkhBG2HIyiCAM4mo8TmUDrkBDgin
         cnWh/aJa81dt1pKO+x3qTZz6rCPGrMkh1uj7KAcQQKqR/JwmYjuhXjs5Y6boCwCUQkmI
         taQULAQSAqK5UFZwq60W8GhDkiQf4rbqsc+eI7Tw4D0VRQ05WY5wyC/GXdjsvrloEkvh
         duyUiKUVTCMt3Xbm7lNw0BYarhu+PAIa7VKy5wH/QCZvjvn5XNN3+TfY0VYOy/tuWYYH
         dDAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6QOUwpYyaURolaGh43C2DQXMGVfTGXyyd22jdUdTcOM=;
        fh=E/5S7u8NEMqDHTVfQnGS5aOXCPI1vWAI0SmxFQkOsJI=;
        b=mJW6IAkcMdEsxWL5VBMygOuu9HuNqtjz59+dRDBbMv7O4VdEXJy0Ph7OoRYW7DtnKs
         6tzUj542tkMBcVy9WSfUiBaMHltpziMjrKgrrckwBIJnCWG4kkKh61l7yiZIJCugrDJu
         dzJLqPaASNuvirLJiCp4jnfS3JVWy/ZUbT92HM3qnY8rOkDULUWBeo/am3ikUCJWaHcM
         dNoDt233gKLsv9pXp6Nc7+cbFr97pilqhBAfjRsFf4MKaxnlX0gHGo0EgS6FJJ4QGORW
         6bOS8MJiwa83B8wokNZJozUc+LuoadC5Xzw7kt5IchQ1hSYX3HLXqGWLizkRFPfYSoT/
         1sKA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792099837; x=1792704637; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6QOUwpYyaURolaGh43C2DQXMGVfTGXyyd22jdUdTcOM=;
        b=rLomQzxpJGPbrtCV9bzaJaCeqkYLb8tyRPYuYxF5YU/PJZXyVby9SmdYe773oLOfYd
         g3811JcDm3FF9Xia1Qc13HcCnN3tEQFgAH9gHh+Vn3xVGyb9KCjAaEiQVbl+3UPONUQ+
         ek1QgKlp4DVZwMkiau9OQY7K5fjgs6aM1XpXIhA32vp9X2zeK6iaZAIa4ewy3ip8PzDc
         QfUlxbrofZdI+IJTywxdhLCOtrO5SwVeUgbnFX4BAjHJdzKqGafP6VxM1NRWBJ3Hc5So
         gp0eUTuI1nBOxQdK6fWXg2rKXvnj7Kn51F3QRqL0MfUGSy4g/43M5CDlZowsJmQWiSzx
         zh3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792099837; x=1792704637;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6QOUwpYyaURolaGh43C2DQXMGVfTGXyyd22jdUdTcOM=;
        b=MNN8eo5HFwZEzN7UNCrbTPvawbsxiHqUJvKOi5Zvqh1b80PbRIYQT7/sGexA+WXlci
         dW2eOPuhCzwqpqGlxjToc7X5/PeKBMVLMea5IgwHh9xN3r52xpNObkcjfuGWv8IbGAzx
         gkCwywIs0KlB2n/aBBoFHk3eH+2iAHqNtw8+aX2BubRVAp1dPxb/OHZnwsPMOJstd2bs
         1DbsskXh137sxm55SY/zLzI2bZvZOP7C59GVrMC7yfpEY3i+4h3w8jisIVsJoCPsr7Ah
         eNk4yJpTkXysw/uww8GNdRALH+UUMt1RzsxVZwevb/+ZKub7GGM97CyO6KrJr337Wn0p
         pJ5Q==
X-Forwarded-Encrypted: i=1; AKwUvByDWSTgT+75dp+e7qvAo3Yibfy/bqEj39AKzcqYQde4NIo1w1QUCTAAZHeHQGpeAZxRrhhFqjYnzg==@kvack.org
X-Gm-Message-State: AFq9FYKMOAJAhCtUWQup9MoId5V8DfImOZ/9H/Yw0jmugcDPupocTHot
	OapHvnhcqGjQOOsgKtU5fY7h8l5rxnpoP1NYrWSd3rKoqKqX3+8v8ixJEkY0hJKW3NAnHnVXQ8E
	ix4V/Ro9X1x322Ux5cdZ1IXErDxAsmyA=
X-Gm-Gg: AYBFou3R1f9pYA6XsRJJ48K7t94AeSLbz6qldltcPYCevb9rb1vkyGwcHiXFebg7sGw
	HZc13IDqL5MXhZRccbDIGmXBQ3n3IiRAwCzbsB588s36r1qo3tCj4tgZ7Xbp3xO7aw4DQGHyBxD
	Vdy9Q6XhyKS1YXv+rmKyitiwS7qsEyZHPWzc/suiMY9eh02IeUzqyMTwHqp0BSCiJAppvan4xPu
	T48msulcudFN6hlJe2j/QtV1qMaby8JxlKsKiR43KukoBTp+llObhNMUABG3AT6+ts2uWNARHRI
	mnNMQQtGvtFCZTbGrZWEF2iMI7Cqqosi7DSYf2r6K28lJF41QREI01jfiwR2d1k0rRun3GyH7yR
	sCs25tFOlHHjJEsPZzbXOGdMvbl8K5fJuHIKr
X-Received: by 2002:a05:6512:1151:b0:5be:41a1:d2ae with SMTP id
 2adb3069b0e04-5be41a1d3ebmr1107279e87.15.1792099836702; Thu, 15 Oct 2026
 14:30:36 -0700 (PDT)
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <20261008182814.27450-6-kanchanapsridhar2026@gmail.com> <as7JC8o2kggiq_ss@google.com>
 <CACpmpofXMGBP70Rn7jHLwOF38GRKMUGoW3rb1Jp2SPH7ygKcfw@mail.gmail.com> <CAO9r8zOEcGmg8eVttu41htugnng0ahnVQbubiJfxVH+GfDe47Q@mail.gmail.com>
In-Reply-To: <CAO9r8zOEcGmg8eVttu41htugnng0ahnVQbubiJfxVH+GfDe47Q@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Thu, 15 Oct 2026 14:30:22 -0700
X-Gm-Features: AclHuK_VkvA5Ou--PjXINBAVxrFNqnCfphylRWwthtObaGmikBDgzUqpBnjQop4
Message-ID: <CACpmpodDA=oqnVa_hsJpyhGt=4zxknYF=QX9L6-sJbxsRxtM2w@mail.gmail.com>
Subject: Re: [PATCH v1 5/8] mm: zswap: Store the folio's node id in the zswap_entry.
To: Yosry Ahmed <yosry@kernel.org>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: hi8yse1nfpkteoefwizy4ir84hx73tuj
X-Rspam-User: 
X-Rspamd-Queue-Id: 0885340005
X-Rspamd-Server: rspam08
X-HE-Tag: 1792099838-658229
X-HE-Meta: U2FsdGVkX18BeA1tuOMwJ6K/5+WarN2Q3SK2+6Gbf6w1n1AJnsyoS0T0FQdpr+4gzqNWY6ASrkB0UNna7RysXFKsa5Bh2Cpcl9gj0XAqftypcONWrWvpZjWbs5pzTlRTBMyMbvFj5KMFysSfWUBqC6F9dW8dYD8h7LuRuP2MvGXgN3M2MKGs6HVwIb7Y4CDSw2/ZwJ1HkqbRvGL5PU8gcivXarcG8qmO+aRPzc1PFPs3K7RSu4aLRma4pqb2UDgm2eThcMRJmw+qASH6h0g9mC0LOLxHGdj7vl8jipTfYaCHIz5H8iViFH663MWwco0q5ydiaNQsuGUI0r7TI1ZvFcc1QwQKV8qGoV5UFK3FMjFR8gPdRZdAZyAp7UW2uM9EdF4OE/z7xnq5kVm1jHWWEUflspzMlxWqyruoFYOv2qHN5wbZEItBgUzF9EauawiFRw7SrVgBlLJ+7zmiR3DpspPt5rb5f8YnmJoU9G2vvLgxXeF+6T1yAsgdpooorWVAd2e2aFhXBli7iTvWHWIi+rIhcJJTAaXhyJMWCii7NtriMeuol2T0ZtZHa9Dx88Fm6aeDgHCd5xRefsdx4oFWPrPuNwOTEcCkr4C50/svr9H6E6XI17wSCZ4jB/vEEE0GwQdg3hHYSlA4JB/TXwd1X8Ditr2e2+AxUuZM9FDSv+SA947rGzThJuc6UDNKh3d5LHXmcQ8OBV4MzWq3orEpD8an4bRI/Hr1mdhcrPb3d+DWZwhqixkbV1f0F5UynsQttoXQ6QqwDdj9qyLjYqGEfVLl1Q3p+n3CCSmO5SHF0Ggv7ZsCrbPFXW9+4eJBFPxT+My4Hi1Zo+02ey5V6i/UpwQdcv64+j95OjRIQok5Hx2xOlIkENzLW2+WP8wpJsYbvs3ycH49tMMSs+d/EDx+iKOyceJudggvpVWa+j7ebB6wr6EvHL+xjIyGslMBsxT1iELaBzwV8xt9zDPySBL
 vZir5lRo
 RyqMPeR2XBoAoNMlUZKk4+zZCS9oPqgJXb1Vznmod8KW14f9JkB/RPEN+YS8GTViHV9r30zsJuQqmKqnaeVOCPbqAkCxNEcQUs0ku2XuxHZE98wMBf1ixHRjl3F4dmixFfEca/oZtKn/BBWrlLNKgJ/PpZjyZFGa69VnERxLl0FpCBFUMqENdC++X8r8Znk2MvUP17yAoQkWIU5JFvab+W3qF2hHd3li1BXKz1ttc6yw8OlBXdua0Q+ZAiTqSFraeOQUSWDor5T4GYNvoRqyh3x+dvy1d4uK+9LUYn9xvfN3uVdTB6QOebfv6NwvBIq3cJMhBKBSyIGuGnk18Q7qcjMcnr9MffEHeO6zyNC0zDdN0b6zQC02vPLI964uKpe1zTutbnuFHqhypkHc6AYf5zXSIgC7TwvAiH0wMtZUbh/I6if/lNXXr/5FoiL3C1YIctKm1yl6iLGzB3A6buTbPh0nMLSZFj8eN8H4UkUVv05VTecpgLCF78EtgJFpyiRCpTCHYa3RYQkaPcA8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 8:17=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Tue, Oct 13, 2026 at 6:17=E2=80=AFPM Kanchana P. Sridhar
> <kanchanapsridhar2026@gmail.com> wrote:
> >
> > On Tue, Oct 13, 2026 at 5:18=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> =
wrote:
> > >
> > > On Thu, Oct 08, 2026 at 11:28:11AM -0700, Kanchana P. Sridhar wrote:
> > > > When storing a folio in zswap, save the folio's node id in the zswa=
p
> > > > entry instead of relying on the zswap_entry being allocated on the =
same
> > > > node. This enables optimizations such as batch allocation of zswap
> > > > entries for large folios using kmem_cache_alloc_bulk() that does no=
t
> > > > support specifying a node id.
> > > >
> > > > The size of the zswap_entry remains unchanged as 'referenced' is lu=
mped
> > > > in with the 'length' (as it doesn't need a full unsigned int anyway=
).
> > > >
> > > > Suggested-by: Nhat Pham <nphamcs@gmail.com>
> > > > Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > > Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> > > > Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
> > > > ---
> > > >  mm/zswap.c | 23 +++++++++++------------
> > > >  1 file changed, 11 insertions(+), 12 deletions(-)
> > > >
> > > > diff --git a/mm/zswap.c b/mm/zswap.c
> > > > index ca513a9f89e3..c2731d3acb2c 100644
> > > > --- a/mm/zswap.c
> > > > +++ b/mm/zswap.c
> > > > @@ -194,6 +194,7 @@ static struct shrinker *zswap_shrinker;
> > > >   *              writeback logic. The entry is only reclaimed by th=
e writeback
> > > >   *              logic if referenced is unset. See comments in the =
shrinker
> > > >   *              section for context.
> > > > + * nid - NUMA node id of the page for which this is the zswap entr=
y.
> > > >   * pool_idx - id of the zswap_pool that the entry's data is in.
> > > >   * handle - zsmalloc allocation handle that stores the compressed =
page data
> > > >   * objcg - the obj_cgroup that the compressed memory is charged to
> > > > @@ -201,8 +202,11 @@ static struct shrinker *zswap_shrinker;
> > > >   */
> > > >  struct zswap_entry {
> > > >       swp_entry_t swpentry;
> > > > -     unsigned int length;
> > > > -     bool referenced;
> > > > +     struct {
> > > > +             unsigned int length:31;
> > > > +             bool referenced:1;
> > > > +     };
> > > > +     int nid;
> > >
> > > This will increase the size of the struct now with pool_idx, right?
> >
> > I was gathering the struct size with the struct {unsigned int
> > length:31; bool referenced:1} as suggested in v14, for my before/after
> > comparisons:
> >
> > before:
> > struct zswap_entry {
> >         swp_entry_t                swpentry;             /*     0     8=
 */
> >         struct {
> >                 unsigned int       length:31;            /*     8: 0  4=
 */
> >
> >                 /* Bitfield combined with next fields */
> >
> >                 bool               referenced:1;         /*    11: 7  1=
 */
> >         };                                               /*     8     4=
 */
> >         int                        nid;                  /*    12     4=
 */
> >         u8                         pool_idx;             /*    16     1=
 */
> >
> >         /* XXX 7 bytes hole, try to pack */
> >
> >         long unsigned int          handle;               /*    24     8=
 */
> >         struct obj_cgroup *        objcg;                /*    32     8=
 */
> >         struct list_head           lru;                  /*    40    16=
 */
> >
> >         /* size: 56, cachelines: 1, members: 7 */
> >         /* sum members: 49, holes: 1, sum holes: 7 */
> >         /* last cacheline: 56 bytes */
> > };
> >
> > after:
> > struct zswap_entry {
> >         swp_entry_t                swpentry;             /*     0     8=
 */
> >         struct {
> >                 unsigned int       length:31;            /*     8: 0  4=
 */
> >
> >                 /* Bitfield combined with next fields */
> >
> >                 bool               referenced:1;         /*    11: 7  1=
 */
> >         };                                               /*     8     4=
 */
> >         int                        nid;                  /*    12     4=
 */
> >         long unsigned int          handle;               /*    16     8=
 */
> >         struct obj_cgroup *        objcg;                /*    24     8=
 */
> >         struct list_head           lru;                  /*    32    16=
 */
> >         u8                         pool_idx;             /*    48     1=
 */
> >
> >         /* size: 56, cachelines: 1, members: 7 */
> >         /* padding: 7 */
> >         /* last cacheline: 56 bytes */
> > };
> >
> > And decided to go with the placement in patch 7, since it also
> > separates out members by compress/decompress path accesses. pool_idx
> > is set once, and never changes. Further, moving pool_idx to the end
> > gets rid of holes.
>
> Please look at the layout I pasted (quoted below). Your patch
> increases the struct size from 48 bytes to 56 bytes, undoing the
> optimization introduced by pool_idx. We need to pack length, pool_idx,
> and referenced in a single u32 to keep the size constant.

Thanks for the suggestion. I have modified the layout such that the
size remains unchanged at 48 bytes. The "u8 pool_idx" requires byte
alignment, so I moved the 1-bit "referenced" field to be before this:

#define ZSWAP_MAX_COMPR_LENGTH_SHIFT 18U
struct zswap_entry {
  swp_entry_t swpentry;
  struct {
    unsigned int length:ZSWAP_MAX_COMPR_LENGTH_SHIFT;
    bool referenced:1U;
    u8 pool_idx;
  };
  int nid;
  unsigned long handle;
  struct obj_cgroup *objcg;
  struct list_head lru;
};

struct zswap_entry {
        swp_entry_t                swpentry;             /*     0     8 */
        struct {
                unsigned int       length:18;            /*     8: 0  4 */

                /* Bitfield combined with next fields */

                bool               referenced:1;         /*    10: 2  1 */

                /* XXX 5 bits hole, try to pack */

                u8                 pool_idx;             /*    11     1 */
        };                                               /*     8     4 */
        int                        nid;                  /*    12     4 */
        long unsigned int          handle;               /*    16     8 */
        struct obj_cgroup *        objcg;                /*    24     8 */
        struct list_head           lru;                  /*    32    16 */

        /* size: 48, cachelines: 1, members: 6 */
        /* last cacheline: 48 bytes */
};

The macro is required to add a build time assertion in zswap_setup():

 BUILD_BUG_ON(ZSWAP_MAX_COMPR_LENGTH_SHIFT < PAGE_SHIFT);

>
> FWIW, moving pool_idx to the end just trades holes for padding, I am
> not sure if that's necessarily an improvement.
>
> >
> > >
> > > Before you patch on x86_64:
> > >
> > > struct zswap_entry {
> > >         swp_entry_t                swpentry;             /*     0    =
 8 */
> > >         unsigned int               length;               /*     8    =
 4 */
> > >         bool                       referenced;           /*    12    =
 1 */
> > >         u8                         pool_idx;             /*    13    =
 1 */
> > >
> > >         /* XXX 2 bytes hole, try to pack */
> > >
> > >         unsigned long              handle;               /*    16    =
 8 */
> > >         struct obj_cgroup *        objcg;                /*    24    =
 8 */
> > >         struct list_head           lru;                  /*    32    =
16 */
> > >
> > >         /* size: 48, cachelines: 1, members: 7 */
> > >         /* sum members: 46, holes: 1, sum holes: 2 */
> > >         /* last cacheline: 48 bytes */
> > > };
> > >
> > > After:
> > >
> > > struct zswap_entry {
> > >         swp_entry_t                swpentry;             /*     0    =
 8 */
> > >         struct {
> > >                 unsigned int       length:31;            /*     8: 0 =
 4 */
> > >
> > >                 /* Bitfield combined with next fields */
> > >
> > >                 bool               referenced:1;         /*    11: 7 =
 1 */
> > >         };                                               /*     8    =
 4 */
> > >         struct {
> > >                 unsigned int               length:31;            /*  =
   0: 0  4 */
> > >
> > >                 /* Bitfield combined with next fields */
> > >
> > >                 bool                       referenced:1;         /*  =
   3: 7  1 */
> > >
> > >                 /* size: 4, cachelines: 1, members: 2 */
> > >                 /* last cacheline: 4 bytes */
> > >         };
> > >
> > >         int                        nid;                  /*    12    =
 4 */
> > >         u8                         pool_idx;             /*    16    =
 1 */
> > >
> > >         /* XXX 7 bytes hole, try to pack */
> > >
> > >         unsigned long              handle;               /*    24    =
 8 */
> > >         struct obj_cgroup *        objcg;                /*    32    =
 8 */
> > >         struct list_head           lru;                  /*    40    =
16 */
> > >
> > >         /* size: 56, cachelines: 1, members: 7 */
> > >         /* sum members: 49, holes: 1, sum holes: 7 */
> > >         /* last cacheline: 56 bytes */
> > > };
> > >
> > > I think we want to reorder the fields. We can probably also avoid the
> > > bitfield if the maximum page size is 64K (is it?)
> >
> > It seems on ARM64, the max page size is 64K, however on PPC, it can be
> > 256K. So it appears we need at least 18 bits on currently supported
> > architectures.
>
> In this case unfortunately we need to stick with bitfields. We should
> probably add a build-time assertion that the width of length is enough
> to cover PAGE_SIZE.
>
> > If you agree with the pool_idx placement to be moved to the end as
> > proposed in patch 7, I can try and optimize this further, by limiting
> > the "unsigned int length:18", if you think this makes sense.
>
> I don't think we can put pool_idx to the end and keep the struct size
> constant. For length, yeah let's use the minimum number of bits needed
> and add an assertion, so that the free to use bits are obvious.

This is all taken care of in my latest version.

>
> >
> > >
> > > struct zswap_entry {
> > >         swp_entry_t                swpentry;             /*     0    =
 8 */
> > >         u16                        length;               /*     8    =
 2 */
> > >         u8                         pool_idx;             /*    10    =
 1 */
> > >         bool                       referenced;           /*    11    =
 1 */
> > >         int                        nid;                  /*    12    =
 4 */
> > >         unsigned long              handle;               /*    16    =
 8 */
> > >         struct obj_cgroup *        objcg;                /*    24    =
 8 */
> > >         struct list_head           lru;                  /*    32    =
16 */
> > >
> > >         /* size: 48, cachelines: 1, members: 8 */
> > >         /* last cacheline: 48 bytes */
> > > };
> > >
> > >
> > > >       u8 pool_idx;
> > > >       unsigned long handle;
> > > >       struct obj_cgroup *objcg;
> > > > @@ -672,14 +676,8 @@ static int zswap_enabled_param_set(const char =
*val,
> > > >  * lru functions
> > > >  **********************************/
> > > >
> > > > -static inline int entry_to_nid(struct zswap_entry *entry)
> > > > -{
> > > > -     return page_to_nid(virt_to_page(entry));
> > > > -}
> > > > -
> > > >  static void zswap_lru_add(struct zswap_entry *entry)
> > > >  {
> > > > -     int nid =3D entry_to_nid(entry);
> > > >       struct mem_cgroup *memcg;
> > > >
> > > >       /*
> > > > @@ -696,19 +694,18 @@ static void zswap_lru_add(struct zswap_entry =
*entry)
> > > >       rcu_read_lock();
> > > >       memcg =3D obj_cgroup_memcg(entry->objcg);
> > > >       /* will always succeed */
> > > > -     list_lru_add(&zswap_list_lru, &entry->lru, nid, memcg);
> > > > +     list_lru_add(&zswap_list_lru, &entry->lru, entry->nid, memcg)=
;
> > > >       rcu_read_unlock();
> > > >  }
> > > >
> > > >  static void zswap_lru_del(struct zswap_entry *entry)
> > > >  {
> > > > -     int nid =3D entry_to_nid(entry);
> > > >       struct mem_cgroup *memcg;
> > > >
> > > >       rcu_read_lock();
> > > >       memcg =3D obj_cgroup_memcg(entry->objcg);
> > > >       /* will always succeed */
> > > > -     list_lru_del(&zswap_list_lru, &entry->lru, nid, memcg);
> > > > +     list_lru_del(&zswap_list_lru, &entry->lru, entry->nid, memcg)=
;
> > > >       rcu_read_unlock();
> > > >  }
> > > >
> > > > @@ -1449,9 +1446,10 @@ static bool zswap_store_page(struct folio *f=
olio, long index,
> > > >  {
> > > >       swp_entry_t page_swpentry =3D folio_swap_entry(folio, index);
> > > >       struct zswap_entry *entry, *old;
> > > > +     int nid =3D folio_nid(folio);
> > > >
> > > >       /* allocate entry */
> > > > -     entry =3D zswap_entry_cache_alloc(GFP_KERNEL, folio_nid(folio=
));
> > > > +     entry =3D zswap_entry_cache_alloc(GFP_KERNEL, nid);
> > >
> > > We don't need to allocate the entry on the same node anymore, should =
we
> > > drop this and let the slab allocator handle it as it sees fit?
> >
> > Was this a recent change? I see the folio_nid(folio) on my version of
> > mm-unstable as of 10-3-2026. Let me check, and yes, allowing the slab
> > allocated handle this is probably a good idea.
>
> We allocate the entry on the same node to avoid having to store nid in
> the zswap entry (see entry_to_nid()). If we store it, then there's no
> need to allocate on the node.

With patch 0006, we try to bulk allocate all entries for the batch.
Only if this fails, we call zswap_entry_cache_alloc(gfp, nid). So
patch 0006 addresses this already, and the nid is used on in the
fallback case.

>
> >
> > Along the same lines, I have been working on replacing zsmalloc with
> > direct SLAB allocations for the zswap compressed data storage and see
> > very promising results: memory savings and latency improvements. I
> > will submit an RFC shortly.
>
> Keep in mind that zsmalloc is movable memory, while slab memory isn't.
> Zsmalloc may also be less likely to make a new allocation in the store
> path. There are other considerations beyond memory overhead and
> latency here.

I realize this means we trade off page migration for writeback for the
pages representing zswap compressed data. This might not necessarily
be a bad thing for 2 main reasons, the way I see it in this specific
context:

1) Page migration would only be transferring a memory pressure problem
elsewhere. Not sure how well this would work with memcgs or
containers. At some point someone would need to do writeback.
2) I don't believe there is a zswap specific page migration flow in
the kernel other than zsmalloc compaction. IOW, memory tiering
components like CXL are handled directly in the reclaim path. From
what I understand, things wouldn't break with slab memory for zswap
compressed storage, but I could be wrong. I hope to include the
architecture level considerations/trade-offs in the RFC.

>
> >
> > >
> > > >       if (!entry) {
> > > >               zswap_reject_kmemcache_fail++;
> > > >               return false;
> > > > @@ -1466,6 +1464,7 @@ static bool zswap_store_page(struct folio *fo=
lio, long index,
> > > >        * to an unrelated live pool.
> > > >        */
> > > >       entry->pool_idx =3D pool->idx;
> > > > +     entry->nid =3D nid;
> > > >
> > > >       old =3D xa_store(swap_zswap_tree(page_swpentry),
> > > >                      swp_offset(page_swpentry),
> > > > --
> > > > 2.39.5
> > > >

