Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CDA1CC6B2D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 22:26:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A933E6B0098; Wed, 14 Oct 2026 18:26:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A43EE6B0099; Wed, 14 Oct 2026 18:26:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 933306B009B; Wed, 14 Oct 2026 18:26:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 622E66B0098
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:26:15 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DDA2AA80E7
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 22:26:14 +0000 (UTC)
X-FDA: 85322666268.03.F5FBD21
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf26.hostedemail.com (Postfix) with ESMTP id 01998140004
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 22:26:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lubHV4Yx;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792016773;
	b=7gf9NhpnrtNRnYhjsFHMAzj3+F3OkSsU8oOaInPxX7DCUdm7LVkmJDEjW4Q2VwZ7gMEoBV
	iJxFtPYwGgeBmVwk0U9r8lPgEC61VjUu97JfxJejmnlQVzN6wBoFBp8YCA8DSQtT3MwPYP
	+NK+I9qh1XTzb8K6gWKMDcVZmWxVrC0=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lubHV4Yx;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792016773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hrLsYh+bDCQ4SD2pq57KfdodfbjKTaIF5lmaAgEwzww=;
	b=xuldmrE8u2ZNeWmdJZ8OjIVRxx5+u9/UmNl9LBVXqwC1BHddIBn8+WYkNRnfSDDAQjPHBq
	fd56kakT3FxD1feg45Ih1IIUS+evlXXKQBukEYrUcGwGtreB3FA5yjVUyl57GwrxxERb6l
	T+0ixUv58Lj4FHWxpP4HLzS5vksb2hk=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-48c4d870d54so2922006f8f.2
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:26:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792016772; cv=none;
        d=google.com; s=arc-20260327;
        b=iu5wJhdyT9mARq+cljT6lUBOQzIErGqspy+uSJmqrVPaJD3hyY9JhHl5NXwS9A0+QG
         +I8M6FxnGXrwIT2RcA7My2OPerXd0UC7TuWkKCzpc1MEIO+Y0k8aD3+Lu7wzHR5fdQqg
         wST9r3XKJ21wBjbfoP/Hf9tT8m3Nb9nasb+/zmCwJ0t1OC3X5E7Lxoq+I6urWFzuvBmb
         qJFYEacT7LaZeRAo4k4YY5xdZ+KDtQEG2+Atra0E4hdnZSftacj8G+VXH/UKi+I1KJIk
         9WNrzKcz88jVCfIuIiSiKzw/wWAt+MtjEMpP1ztC40lget08LzpBVyxztczFzZKZGOlK
         nMAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hrLsYh+bDCQ4SD2pq57KfdodfbjKTaIF5lmaAgEwzww=;
        fh=ugbYsZ25jOd4NCKt06L+TlU8sRU4+mBeiftQsNOKVwo=;
        b=rVwQ0AceHTJXrjDYS16Qht+CdPJy43hkgp7JEeJFG+Edv5RqXgrq+VomxfWjv/pNxT
         8fuh9y6MV+H2cbdNazL1i2L+XFrCuAJcDDJ7KZ28Vt/4pfmK+m7VeYag8PgVVee45vGh
         skMKsp9mPGido4XUVhBJX65Q5ohkYAGiUalsqL3prONQzqkK2Ju7L9qJmKo+guHlhouz
         E21yOGJJ76/+fyo1DHFkP1xQZrNd40f/1hIDWXBu6H+y1T88phnBKJTJK1zFF3FdEZyb
         15OtdNuxWBV3K3inVMs7EndvZFf0yFEdfCDqF2Xn/Jlg2AgLeiOhw5a/Yw1KA24Nrs6B
         IZRw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792016772; x=1792621572; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hrLsYh+bDCQ4SD2pq57KfdodfbjKTaIF5lmaAgEwzww=;
        b=lubHV4Yxf3oF19yuQcFAQnaL3F/xhB5jzz0+1/dRTjN+iTXFb/2D8+o5sZWfEgqpPh
         JIOc78CkiyVnrdIQP4qrqVctmWauAz2eJgD0i5N3sKD6975o8YETS9SswTiYnm08F33T
         tmfWzCJ95C/LAffcRBZuTpsS1p7926zOhlBa0PUjbfVGrjbOk8FXhUF8qDLnp8sC7J0B
         r3FAXJkJEEuwSLi9g1QYHeTaGh7wtVw47e6MMiHdsaLEOUsZ9nkbjQp6TN0vKEacz/Sh
         TbKLG5KWmEMS5vOI/bv9lZ52KPYl6sW9cxqgagbCeYlhPkxj/W88WtlaHdZUnVQwuWt7
         cDuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792016772; x=1792621572;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hrLsYh+bDCQ4SD2pq57KfdodfbjKTaIF5lmaAgEwzww=;
        b=vZqM/gj7u0S/Qc717Kze8JtKygiKm1rihu1zLq9CRS+j40EId8dcXLXpswlH84+TXe
         6M7Q4vToh71QFZSaafQABfZ1ewekykhbLGys3a8ImtuqwRiZXGyYyQG84WHFqo8p6U1N
         EjUvBjFR0X/4WHKkg3bMo4xxDRIu/1VErdZ816VC4A36Ic4G6GYKCCh54BrFjrNLgSSy
         iXMRZv5KLrYUFlhSXJ+OyOvpV98+J/ieiUbzcwvFvEVvS/ni4cMJG6TdgkNLswevEAIZ
         avt3P59hb1JN5trdLnTCry3ZtLGA5spXbG+3mrt9LthGb29QVc+K0+c2tr4kFRWW6b6I
         lCpQ==
X-Forwarded-Encrypted: i=1; AKwUvBwXg1PKB2Rq0lMttyuh7ExxFjXD2sXCyoF4FWIR/JBBSigHwnHzS4S4r3nfriQKaMM2Eg8Q40fSiA==@kvack.org
X-Gm-Message-State: AFq9FYKt4pvBocJIPj5L0nHQN9Uj4UtB3cx43+ph3c74iU9irozOsKRd
	cMHfauTTDKY1/y6N8UO319qGS2/082CYyZn6qwI5XgBRENP0asjlRXPvbFsBlHEM1UVOWKqEQXP
	caNcsNUsIUPE4qmTNLJurvPVdtfCedZ4=
X-Gm-Gg: AYBFou0Z0e4iPS0a63iytPCXdWKnVYXX6XVyh0Itb7s8zhYSoKjHwm5y/JbasWXUV4d
	kGj0JJJeR9ew2D90vZrpFJZ8gOU/sblQrgr4+bE3lSXjUcksOvhoL4YHCFxyP4PW8FjjCKZFCCa
	xdiBccbvPkCckRTD134iOvUq/nZXLANn5ANn8v+QGSdgcUEEGY6VGjIHik3NzRMOlxfW634V+oO
	P2yWVigYDXKA3NK8M2dTBPayZwhDA2Ne9DpbOnzrYuLe4/WM7St3iBVCErzNMBu0TsQG3YKVbNJ
	LvjDHyQtbm424OjoPJzMqhy08Ufr23jJB/b5sw5MIQ5Phc4B82Wl5xKLNWI8miNWfLr7HQreBRg
	nF5lrdkcngfX9/y/aeIEGmOOMCq41FxqNiKa9ew==
X-Received: by 2002:a05:6000:989:b0:48d:b650:69aa with SMTP id
 ffacd0b85a97d-48dbacf596fmr32237437f8f.50.1792016771662; Wed, 14 Oct 2026
 15:26:11 -0700 (PDT)
MIME-Version: 1.0
References: <20261013221307.850803-1-joannelkoong@gmail.com>
 <20261014030737.2102-1-lance.yang@linux.dev> <CAGsJ_4wxKQK=caM6a_AqJArGyJdBgq_=i=gSNjiVePkGBZHnpg@mail.gmail.com>
 <75a46520-0771-4a50-ba77-ba815dfb6bac@linux.dev>
In-Reply-To: <75a46520-0771-4a50-ba77-ba815dfb6bac@linux.dev>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 14 Oct 2026 15:25:59 -0700
X-Gm-Features: AclHuK9UfZ-sx1-TECHAp9W_R-OgLeze4vd70DCXAYZ9g1bHKOlxo8H-AHDm1oE
Message-ID: <CAJnrk1Z_5x05rYRCwX=SDvK9v=AB_bHHe=1csaPA_yZj6jbnUg@mail.gmail.com>
Subject: Re: [PATCH v1] mm: unqueue deferred split folios outside the lruvec lock
To: Lance Yang <lance.yang@linux.dev>
Cc: Barry Song <baohua@kernel.org>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, hannes@cmpxchg.org, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, ryan.roberts@arm.com, 
	usama.arif@linux.dev, hughd@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: m53ukyyufh9x14sfo6i8grm41geabyge
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 01998140004
X-HE-Tag: 1792016772-884889
X-HE-Meta: U2FsdGVkX19LdeTg7MI8JXC7AVCl65VCbigkm0Wkobk6/nbS9hMtd5ae2d/Dt/EHHD8BJbRAZQJupedUaJXh6rm+kCIOL4AXmx7OTjCffwQi59XATLuSrov3tT+0NoEY86/r5IxqpVZrifx6PjxxMv+1Eik+p/UddMH+9/Nh/RZSRgIOrjXWIGKEu7G4peqF2Bz8sqCcZyI5cySpfC+j6ZytLlUn3/dk6E23J9UT60dlu+TiJtsNw/Xy+UuNTi9zxnZATteT06SnRLm0kyPQz2G4R4C+QNRMkZjd86ngtdo1RHrbD7WvCKn2csemnwCrK2LYNgJ6VMyWjZMFmvZM9NVoukCrMVtttT16l/oVsKkiaheKrXB+Zqd3MkM4vsYmFK3Nym6gmUSENEQ5vQE1BHG/Wp2lysrsuhNotW+UMU6wgnj5PAYhfv3NEOloajxz3NpGTVjaQtoNN1nW+t3rE3ekUuCU+ztxRXsVGA309ewbpB2CHFNUmB+EdxzjKap4orRWe2jSTaX2HRfFxy8vaqyRWjfXke6CgbXsebDqAM6X4Z9xygefYeEIR8hpHJcFfEOgJI9DRmLgQ225il9nMcTscXfPBpIttuTZ0ojxvMzW4ocidEJl4n098zYBSWdi/UFJ84rar4uBljK6FCO0qlyvszmwNKRcLXhVDQacMX+p5H7HiwROQHzmjITvJQ/B2tczCxRhf4HlwoT/hIBnSKkCdpjwVwJ3RtsnDpj/7wQA2udfXDUuwTd+Xc+5Qd7OGGmLiW76ua3nnxolIHF+yKtaLVDZ59jwLXKddPgX+NfZRz66n9qvkDw3SLsXm7YRaqaM4jk0YeIYTD0T3SMF059zjKOTD6rf4mrOERW9UdTxI//vQZmnnohD0+X9WBWZoE6XUO0oH9J7YH7ap4sCNE0GmVbO0+8ZUbtyfCFGxX+DcEJhxuL/bYDCA2gsEiR9OrOgMkn8aq9+RaHkSgL
 GLRBMt5c
 VKTvdFIA/mqpgIw2m+vdqBJ7rz2aBEZCzEqFi7nX+P/PxilQySLImyjtlZQdIXMaIUMdTI+UeTFM6H8JII8zp3rtiAftzyefbD1Mdxo1MpEfukLod+E+ltYNNmZO0H+5wfXm4WOrfbzHQ+D0IMXxP4sdlZxkFsAZonDsOC+wkFmGAPMpckuLE/s2SHHkf9m74eS7+M304uZuHZnTy0QKcBLdl05VZPBWrQN/UfuqEpxb1ACEYy9O+cs8S+ulf6T+HLhmkNIIyVWWsX+khw6czYLTqNtUF7aAnnwTGERc+P8ukGE8vavSFAWSrt+oGr7k12dHPwTsC050oiD+PvtMZn1X0WwMip1pcmugytQ2zPq++kQtWdHVTSgRb3geJG/Zg3FkUFwuQ5ehsoFlCDz9xFJcs6/biWeoYmBEU5gMjCQ7UO8+9i04BhL7kEBjVu/NtLhs1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 9:24=E2=80=AFPM Lance Yang <lance.yang@linux.dev> w=
rote:
>
>
>
> On 2026/10/14 11:13, Barry Song wrote:
> > On Wed, Oct 14, 2026 at 11:07=E2=80=AFAM Lance Yang <lance.yang@linux.d=
ev> wrote:
> >>
> >>
> >> On Tue, Oct 13, 2026 at 03:13:07PM -0700, Joanne Koong wrote:
> >>> move_folios_to_lru(), folio_batch_move_lru() and folios_put_refs() ca=
ll
> >>> folio_unqueue_deferred_split() on folios where the refcount has dropp=
ed
> >>> to zero. In these paths, folio_unqueue_deferred_split() is called wit=
h
> >>> the lruvec lock often held (move_folios_to_lru() always holds it and
> >>> folio_batch_move_lru()/folios_put_refs() usually hold it for every fo=
lio
> >>> in the batch except the first). However, it's not needed to hold the
> >>> lruvec lock.
> >>>
> >>> The lruvec lock protects folio->lru and the reclaim LRU lists whereas
> >>> the deferred split queue lives on folio->_deferred_list in
> >>> deferred_split_lru. The deferred_split_lru is a list_lru with its own
> >>> per-memcg per-node lock.
> >>>
> >>> There are already other existing callers that call
> >>> folio_unqueue_deferred_split() without holding the lruvec lock (eg
> >>> __folio_put(), shrink_folio_list(), __folio_migrate_mapping(), ...).
> >>>
> >>> Add folio_batch_unqueue_deferred_split() and use it in
> >>> move_folios_to_lru(), folio_batch_move_lru(), and folios_put_refs() t=
o
> >>> unqueue each batch of zero-refcount folios from the deferred split li=
st
> >>> after the lruvec lock is released and before
> >>> mem_cgroup_uncharge_folios(). This helps shorten the lruvec lock's
> >>> critical sections, which run with IRQs disabled and are highly
> >>> contended.
> >>
> >> Nice work! Thanks!
> >>
> >> BTW, have you seen measurable overhead from unqueueing deferred split
> >> folios under the lruvec lock?
> >>
> >> Any before/after numbers for this change, including the cost of the ex=
tra
> >> pass over the batch?
> >
> > I recall Joanne mentioning some data on this in the link below. Is that=
 right?
> >
> > https://lore.kernel.org/linux-mm/CAJnrk1a2PpUGTsCgS7jct2KET4K2zAL+_h+te=
8G1MaU9bXs99w@mail.gmail.com/
>
> Thanks, Barry! Yes, those numbers answer my question about the
> observed overhead :)
>
> Joanne, have you rerun that benchmark with this patch? I'd be
> interested in the before/after runtime and lruvec lock wait.

Hi Lance,

(Thanks Barry for providing the link to the earlier discussion!)

I have not run those benchmarks with this patch yet but I will get
those numbers and add them to v2 when I send that out.

Thanks,
Joanne

