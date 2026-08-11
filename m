Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 859E2C5AD55
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 01:11:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 500E16B007B; Mon, 10 Aug 2026 21:11:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B1536B008A; Mon, 10 Aug 2026 21:11:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A0AF6B008C; Mon, 10 Aug 2026 21:11:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC41E6B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 21:11:22 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 72751A2322
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 01:11:22 +0000 (UTC)
X-FDA: 85087210404.02.09ACEB3
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9598510000F
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 01:11:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CBqrFTdX;
	spf=pass (imf05.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786410680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8iGTAx1qGxRGrv4d/rfwDbXvwTo8qGr7U1FhbXziu8g=;
	b=s/cUPssK9MvmEE5tOtoJSkJJdIQwMq9fJGq43XBvsbzvMSU9Gh9G53qBCMHM0VqOzFJdHR
	s41xr3C51j7agBpAf5FsFYyD1xlROHUnWiQvNfbRYuieJCWOqgTyJbxyOJhaZf8BOfRNVK
	kFWlUalMnpVVDKu+GVUfKIAKYTodgBo=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CBqrFTdX;
	spf=pass (imf05.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786410680;
	b=tTdkQmwxLu3FvyHF2SAdZCHWDtyXJimOSZVberSjZGEJ78OGNleq5WRzVOEsDNxM0pxO/c
	r4bQqwyFAgqzB63LcBz8nIpxD1fpV3dkYOpMmrrUqCht+fdzYUTAsGR47bb7fpITcQv508
	oRVsEXQVV0mOPZU6LllIL6wga+hvHbk=
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-39faf9e2c62so13766221fa.3
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 18:11:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786410679; cv=none;
        d=google.com; s=arc-20260327;
        b=camUvMNMA0xmfIJGNvDSfbaPviiGISflNIHnSMX8CJJHqFijbJkbd7YgprN24Gec2D
         cu2rGm28e8DGlC3tjTLzQIiuauF365SF2jsoE26jKbT+wIGYfhXjJG9bFr6WqngOfsJ2
         ipNmgUV73V7SZ29mrqPcrSCxYj/pOCLm/uJvrMXI7ln5S6H3ZovZeujUPLHbRR6WcAtv
         pg0y1SS3k9q2xCKC6uaPJFntWp3+T1MjkA+EALRAu2tTDcmw6zhh9x51AdWWcxhn6Zjk
         MeQL1A75b30K2QhDzdlqECWYLGWF1OW2F4JpDHogQeZUBVKCfebbxFY81D4CLpTVG4dS
         HYig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8iGTAx1qGxRGrv4d/rfwDbXvwTo8qGr7U1FhbXziu8g=;
        fh=FnTeqw5Sda9ic5PBHx80WvyTnZ/LRzXghBjE4EN16bI=;
        b=SChkBgd6/ouuUaMdkcFgLQ3AAhzW3xMvSB/DdbT57O2kkr+wizo7eQ9u13v6zMrufQ
         60/GrAft9BBg+a/siWDJMhoISfws3+doO9CGLXRv71DECQ+QX9sdjEhoN97gA960Sv4c
         151e0D4MUO/cJARXUo8LKc5WU4Hq43g4Yu/JUOEpCDan2NLJROKicRrSuYu6YlrIOv+D
         NVX1ckycb3UJ5xkOr8rYK8hBi5hKQs4AsKlxkexkDsYFSXTEaRMrek0C+6l9w9iLQKaD
         icggYPg375xfdup2isSDF93Y1BYlc06olQLl4v3cAxRzCAo0OxSK/6SRD++dVD93d7Ze
         w0hA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786410679; x=1787015479; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8iGTAx1qGxRGrv4d/rfwDbXvwTo8qGr7U1FhbXziu8g=;
        b=CBqrFTdXpvHXl4RJrLC8Up3fupVxaaJN+vbSNIEZvZa3Ju1jHFB2qnNqdZJta1PDD9
         VWeIqG1nN8IXEyuOxR70jR3tzamP7y4ciYeKk3IXqQ78b9FkXdaiXxhasvTSyEPZh5MC
         GoJxmWDeLEUWbpmt0UZHoJdQIRjecV80VSnqe0prR2OVWE24Lf5vo/3TFZABiWyfcpfq
         /SztAjKEWlrxq35b4maKJ91odpMYnZbOXirQDemIVSW5RuZzwQTvVLtGyj3i7sf8fUA2
         SeMnbUm9M6cyQ+nRct5WPR8yVbgvxcCf1PCVqukw52RHNapnnj/lzcgEHgkGHKW1Beol
         DGow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786410679; x=1787015479;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8iGTAx1qGxRGrv4d/rfwDbXvwTo8qGr7U1FhbXziu8g=;
        b=OUNgK7GgDFED8s6kfKg/TAvANgL7enKMEapy3FDox9vXvyjxtTWxtP6KK+NTkmm5st
         Mh4AaNs3c0vNK8QTouB9T7/q/Gkqsa3iD2A7CVYHQQ0Ep5S/4yHlXtgh66oasB0Z2U/C
         XGQdSzjvRPKzIVllFyHxOftSZUpmOvhdAmHVD9xYj1icG2zjfdWVE8uhyfjBx8dG4K+Q
         mc7OMM2Tp9iC528Q/MNcVn1SJifBpwzZcQ7YVXAHlNUMQGE+EzlFfsC4WBrntsPjxduB
         zG3Ysrd2ROtGuQQQnLaihlF6hBSEDWPdjcYOtDR9j9GHTPytLhueg7JYooNYBbfgr9TF
         Bthg==
X-Gm-Message-State: AOJu0YylQgrWeRlqkI+IBovQo5RKxalcGDl1LJ3JRUEEDmOtu/32sbIb
	CCeouy8UmQRdrHn3KzvqPJ1d3Iui/g7SN/QB1JxeW6h5lMrfRFHUG5ywg9eQJLAdjn5bVKlfJDX
	7Q6KZ0tzqJZcgOk16G/xLovXrLLYDXGs=
X-Gm-Gg: AR+sD11aezIcm/ePM1ULgBGJZ5QmV4r8x6bWZoNVxqASIpbbXQfmZoRargU/wwp6pOr
	GAxUexCNoRkWsgIPHeADkYQkRpGLWb7zu87v8mKeo2B9tkJgG0pVzVh7OhXedn63IY+E67F2iQx
	iJt1s7N1Yp7eTgu3r9yqFXtA9TYA+JaSwtT76YIEtkPzhplSmHQadVwI//Fyc2GKW5ubNkqCHqg
	8k5eR+cCFMu7HYkJA+h3Tej9j3Z6zfYxArv844QLBU7tnVFAT4irR9pZ5VbPTBOwdE+B4MaCFIq
	RyxmBwfoutOdWaU0G57Y1rCqPvkKqZm7yIBjDAcwHlsR0ST0Qx2yWI6iHCu2saggCDgXZWFfKQ=
	=
X-Received: by 2002:a05:6512:3d16:b0:5ae:bb31:4b98 with SMTP id
 2adb3069b0e04-5b3181a7373mr681724e87.20.1786410678477; Mon, 10 Aug 2026
 18:11:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260731-shrink_zswap_entry_v2-0-0-v2-0-e72083aa8734@gmail.com>
 <20260731-shrink_zswap_entry_v2-0-0-v2-2-e72083aa8734@gmail.com> <anpqSQ3dSpTgNPl0@google.com>
In-Reply-To: <anpqSQ3dSpTgNPl0@google.com>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Tue, 11 Aug 2026 09:11:04 +0800
X-Gm-Features: AUfX_myE62o1PEjdyeKCKAXkKnk6VpqJ6rR2srbnDdl4X818sEqrAeTSRJ1MmrM
Message-ID: <CAJxJ_ji7Mm4b=N-nEB+RAg0MrZ=wdVb8vEpGcaReaQqzWjMhmA@mail.gmail.com>
Subject: Re: [PATCH RFC v2 2/2] mm/zswap: reference the pool by index to
 shrink struct zswap_entry
To: Yosry Ahmed <yosry@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: p6af7jai6oiym7e15irnbc14p3mkca3j
X-Rspamd-Queue-Id: 9598510000F
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786410680-42317
X-HE-Meta: U2FsdGVkX19NshogLiGmRwEjdWSYxteBwa0eSMzQhLpDs0Rgq7tUW1kZofmY6n5Jh7I7R2q1TClqPZv5b1dMcEXi0/ABRHx8neawwhOzu+wcvjqw0DHYlqfI/wiXT/d5UD19Q7uAtZzz3c++d5joHFjVmwWy9zdxRpr8V0lRPi9JE4BnX7myJ3IajFURMHsYMB12PvxhpSXcMfo1jHaka0iTQzLL3vqiPBZvAqZLamjbvJqIp/U44OFvmJKkDMXpD+UqYlY+TCW7nz7k97wlPdb8C2SfwtMBR5BCzab17x5HMtweDfh8ntBMHP+H1rx1f7jz8LiJawLfn7YgJB+LFzoV38ZaS23kjK2imevWlWYJUUq3YGfO9ESVb74zVJrbF5oW2rFicxduTOyPksf2VeCeHBDFRhCS2j/unRAqvLS1KZMdlAb+1w66dsOQuuIs4nGorHxOoP3UF/8xflSr5AGcujMBH1H13LBWAZ95fbQIEA47/kTsCSV/zRRHcy6/8WZ4//9u3UHU7xZ4I1P/accnzQVQ/wz6lR9yQvOwGZiJ3mufVVsAusMW9+1B2Ow3s43cfpk3/dJyZsBPeHPTi29vqr9Bu3D2Oh6EBwu9V7NUecFetn2iG5T0YJ0A5I6b9Op8fzQ2v+shkyfxmvP/e00g9loHTaOgjtJAcQuyf4JbZh1zceaFj/WqJEXhGGcdTxWdLVrtKdTfMx8ZFAxuumB8aD9/fKnyk7CEldm5h6OVBZp0oPWiZsavFAJtHEY0EE0gfYuRt4vdptJ6cFWyUiNtgOIgsgjbBdbnM7PtXZ+D7hHZvs0r1UAzYmoWsphFmn38mldM9DGjMR5cjDqyptfOyHWtIceN7M6xzoaeh+bd8/CQKJAJ8fxpBXr5ZeIrD2EkqqZYYupcPWG7Wtyg2Ch8qoy3qk9u/QJ4gUPRGlbD1YmZI/75iD4CohNi99ykDd9krwkMhB9/VbcbO+h
 Jlp7/Pst
 TR5dxkl8ppgKK3DWXDGIHwyroZK0dgfoezGSV3yn7q6RDdbzYrK/nvzGZmo+NxLy7NMuQY2lbsKyViXMwXTgBDUK223RWkeWpns9fwk6l6SfIzsz0ipBMQ1pUCh/IfZm8FRY6DrK9cZJfNWpdtlAKr9D2rJn4z07sqhdOlYo+om4NLVQHQ4Xs7dh0gH9YTNG05dLy61fnBkzsuc72Sm2QKzxXyVL0gMVAR/UmJDQlIJD9EgBK/AYuOc1N9/XcLc50rqbfjcDfKTqUHj8AhkNUiOu/TtY3E1FflF5KE8tFOP+fmXJ6IS9HmTLYuQ6LvA7XFPQaDAUN4Fl4u04jd8DSpDSKKCtv6HkmsEKCGk4DKROot3o4r248YTJPTBOV5fKRfcjqlv8+64xrnOOLUw7evKokQR20fyg1rvnf1XPBRmtDaya6jemEuat7BdPxRrSsuBrAaiGXsnQG3bdtngg60IArOq5qgULiwqE6PIPePWpI4P5clHUcCou3CXEyQuGkiPef8FJPIIXs5io=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 8:20=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Fri, Jul 31, 2026 at 08:32:48AM +0800, Jianyue Wu wrote:
> > struct zswap_entry is one allocation per stored page, so its size is pu=
re
> > overhead.  It currently embeds an 8-byte pool pointer, even though the
> > live pools now sit in a small fixed array indexed by a u8 slot number.
> >
> > Replace the per-entry pool pointer with that u8 slot index and resolve =
it
> > through a zswap_entry_pool() helper.  A live entry holds a reference to
> > its pool, so the slot cannot be reused under it; the lookup therefore
> > needs no RCU read-side section (rcu_dereference_protected(..., true)).
> >
> > The u8 fits in the padding after the bool referenced field, shrinking t=
he
> > entry from 56 to 48 bytes on x86_64.  This raises objs_per_slab from 73
> > to 85 and saves about 2MiB of metadata per 1GiB of data held in zswap.
> >
> > Suggested-by: Chris Li <chrisl@kernel.org>
> > Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
> > ---
> >  mm/zswap.c | 33 +++++++++++++++++++++++++--------
> >  1 file changed, 25 insertions(+), 8 deletions(-)
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index b203934d3be8..d4f4db2999f2 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -190,7 +190,7 @@ static struct shrinker *zswap_shrinker;
> >   *              writeback logic. The entry is only reclaimed by the wr=
iteback
> >   *              logic if referenced is unset. See comments in the shri=
nker
> >   *              section for context.
> > - * pool - the zswap_pool the entry's data is in
> > + * pool_idx - slot of the zswap_pool that the entry's data is in.
> >   * handle - zsmalloc allocation handle that stores the compressed page=
 data
> >   * objcg - the obj_cgroup that the compressed memory is charged to
> >   * lru - handle to the pool's lru used to evict pages.
> > @@ -199,12 +199,22 @@ struct zswap_entry {
> >       swp_entry_t swpentry;
> >       unsigned int length;
> >       bool referenced;
> > -     struct zswap_pool *pool;
> > +     u8 pool_idx;
> >       unsigned long handle;
> >       struct obj_cgroup *objcg;
> >       struct list_head lru;
> >  };
> >
> > +static struct zswap_pool *zswap_entry_pool(struct zswap_entry *entry)
> > +{
> > +     /*
> > +      * A live entry holds a reference to its pool, so the slot cannot=
 be
> > +      * cleared or reused under it.  This is not an RCU read-side walk=
.
> > +      */
> > +     return rcu_dereference_protected(zswap_pools[entry->pool_idx],
> > +                                      true /* entry pins pool */);
>
> Probably doesn't matter in practice, but maybe entry->handle or
> something instead of 'true' to make it clear we are checking for an
> "active" entry?
>
Thanks, good point, I'll use entry->handle as the condition:
       return rcu_dereference_protected(zswap_pools[entry->pool_idx],


entry->handle /* live entry pins pool */);

Best regards,
Jianyue

