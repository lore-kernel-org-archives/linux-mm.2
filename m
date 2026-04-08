Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D9F8105D993
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 02:20:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5283F6B0088; Tue,  7 Apr 2026 22:20:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D8D36B0089; Tue,  7 Apr 2026 22:20:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EE396B008A; Tue,  7 Apr 2026 22:20:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 313056B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 22:20:50 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 90E491609F6
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:20:49 +0000 (UTC)
X-FDA: 84633785418.15.955A4A9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9AFD640002
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:20:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FhSehnji;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775614847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EkTMDGKP948BYYsNDQ6v54eavDd4YZn/lUk2B2IC8qw=;
	b=SrAXu29An/nAHMvayZnZ15GlwJEm4Y5oe01iLVZWv4E61h4RgyfoWpp/pWQ+wJtGz9yDqr
	bcKz8ZRYIBFa2YzI1B2Q3iVXLr5H6ayOuYuplKXRmUKuVQY4T3RQl0EQCpKVQ139S7dPOU
	F6RwvxR/5WMLZfc76bcMQyhHaTo23kM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FhSehnji;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775614847; a=rsa-sha256;
	cv=none;
	b=k7aCNHPE7eGfSH7xxo77bqfQUpQFqLii5rCshPVXj5ZnzwaAxSNXvEpQUvyXo0Mit6KyG8
	Jd8hij7UIEAXg8sG8M7TzweFrhVZncN9AoR6N+KT6haXr1iKU0QxkKlwsas0XKs1nvkR/y
	uP90AGeCC12s2a862s/MFobn1t9zrZs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6CE70443C6
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:20:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 317D7C2BCB5
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775614846;
	bh=EkTMDGKP948BYYsNDQ6v54eavDd4YZn/lUk2B2IC8qw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=FhSehnjihi7vemqR/JEZDVofEmDPgOjyLbgVSjUtwKCsGzV28aa8G+llG5/pLkVJn
	 bbj4/nMhBrJIrQO7BT8IKBaoeR9B28VycAFAs3ehyFKnqRdhQy5Qd2zGLYsij13pkc
	 0q9lTjJnMcXyUXgC0B3jEDDM+eJFbGzjk3xtRms+oQc8bwIWdrqvG9hpfhgQ6fXYSr
	 iWOeSwb60H7mEzHNvq6rLlzX+5tkq4KIvQUZIXS2+GTUnYH01VMCyX8H31I7jvugar
	 iwcxPdSonjak+9E+jHhmtIU1sT6hzVBQT9hV70ULBdf/KrrmUsvZw9n5i4m04eDO8O
	 PvQaHaoLWYLIA==
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-89cd8596724so63829996d6.0
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 19:20:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWxt8q4YZRPJKT41Q9fAlNMsB3duEULCgRq6k2JK+SvA3np94lkza5RBv0wEDWB9hDBkG5ZQGl5jw==@kvack.org
X-Gm-Message-State: AOJu0YxsCKpoGWF3KZ0Dn6XQ//LZD5kviZXR0J+3tsqEBX3K2AmnzoFY
	H3lDfFGIUXl4UcNBn1hA/Lho8Fz+V+y+N6L09IrEpKJPmwfPeL14PMDMmpzH2tihhVRcFTb2S1w
	pOKmq2Jo2TKIDvCC10F5F+yfGf+8tXxo=
X-Received: by 2002:a05:6214:1d07:b0:89c:d424:aceb with SMTP id
 6a1803df08f44-8a7043ee093mr331232136d6.31.1775614845504; Tue, 07 Apr 2026
 19:20:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260407110002.204755-1-wujianyue000@gmail.com>
 <adUTC-7iyOAUlhR7@cmpxchg.org> <adWxonmfjvcwXMg8@MiWiFi-R3L-srv>
In-Reply-To: <adWxonmfjvcwXMg8@MiWiFi-R3L-srv>
From: Barry Song <baohua@kernel.org>
Date: Wed, 8 Apr 2026 10:20:34 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yNZiRpgyTbooJEkkefVxgWOywkcVd2BeY5Dq2wuicNNA@mail.gmail.com>
X-Gm-Features: AQROBzABPWMVwekFvRSuJev5R_1ZnyCXzik3x46t1Zi8Xx69sex2MtowCdnYFI4
Message-ID: <CAGsJ_4yNZiRpgyTbooJEkkefVxgWOywkcVd2BeY5Dq2wuicNNA@mail.gmail.com>
Subject: Re: [PATCH] mm: move folio LRU helpers out of swap
To: Baoquan He <bhe@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Jianyue Wu <wujianyue000@gmail.com>, linux-mm@kvack.org, 
	akpm@linux-foundation.org, david@kernel.org, mhocko@suse.com, 
	zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, 
	lorenzo.stoakes@oracle.com, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9AFD640002
X-Stat-Signature: 34xayjt6pu3813zhuxdai1x8afbi6gtn
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775614847-442394
X-HE-Meta: U2FsdGVkX19Uu4hhPYY/3J8nQwS6HttCE4505Etlc4Y+HRPWh7hh6qU94UA/NqaSWkYifZD6rk7+TQ3LesjX7Ux54GvzpyhLEtg0HrhJXMobITF4dFQdk+b2GHjoBVYhNb8gIxQbdvdnAshFPb6+rH87VSVO5kuk2ZnAmn6rQyNugSJJoOK6DGIjoVg5N2bSeS9RPXDuegGmlEM8OZQF07BHqfcTPzPCaGfLXOtz61iAspNn6IBDtvE97qYbmVCe/SONtqjDmcPe7LBGdLoFMYR5Orhy6e87A84u7U+SqVIfmC5vnalsmXi44AvlEmWqauDbd20+OBd6KVDv54/OIGGn8WHWI9lXAeNcFM/oUH7QDcUyMslGI4O8gDbH5GVvwhA6ehpD92i5Eq6T2hly0INAup9Q2r3QxFtliPSiTDU4069jnQk/3S//dLdNtzh+6/DrSsNAGPoaiXBxnLk9fWNdvIPJJaJfnCwet0exd3XFazYuS6YS5EZ4ZXuA4e5XqIsAlKVvtnlVh1BrZgGrxDfccBQjPWSI/fZbsBwDCVKRfdmpDkGzRt+KhrQDeCbK03eG7rzkGrFZpZtPdUoTtRsaMlUFvuY11Qq0lLAfIGIbcZj1af3nd1wtBHRUrnRG0YmFHL5YeZkEIo/y2CfTH8uNPQQvJC3LtfoRW7Pn5gggnyGq9/j2UG/YcyXezjesT3cyrd08sNPLG5DUFNw1t6/6zsmHkjXoN/W/40rUeYRfLkKyJMByZFivQWCr45n0jEN6t8bJJR5V1POkaQcDdH/ELRljb6TUrvZaVYLQHDierDDS2HNr1kh1Myg/yw8XCDI/HBLh88CTTnweHZj59697UZ4vGVrD2WRpfiVq8jZzDoBXgZmwzLyGxjcUIkp2xv6g8N63srLV7U6ypu5iDl01gCzRLXX7RN6Vf02ZcOcH/hK8WzTRXDQNOSUNg/r8Frux1YMnIu1nXJ711jY
 wYoJEwbP
 979RPZ20vvI/sejJeS1X+VxfKqNcx6VhVXPEUjUrBIqgNftEByRXFgTlW0zlqo1lo3YN79slVNwdpyVi2FXg7jutFIg4KsUriTPa+J+69+RsH51K306xWbzbu8AtImvVtxj4dK5SrZ3qltwpcEX8S78rs98dEJKfvo7ZNO4n7fberIJIkWvyrQ8A/k1Va1tDS9fG7ydss8LlLrrMW3o6VcOmuiv0ZGs0upaOSJOVTapgklWYtbeFwz9CKAf62kL7dDgBDOqg0RKbjJMOHn2sXWwoLAwQuSCfUGkPMy7myFZpM9BL0/YKQqFG8fg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 8, 2026 at 9:39=E2=80=AFAM Baoquan He <bhe@redhat.com> wrote:
>
> On 04/07/26 at 10:22am, Johannes Weiner wrote:
> > On Tue, Apr 07, 2026 at 07:00:02PM +0800, Jianyue Wu wrote:
> > > All allocated folios are added into lru lists for later reclaim wheth=
er
> > > they are file or anonymous folios. However those folio lru operation =
codes
> > > are put in mm/swap.c which is not so appropriate. Because swap code i=
s
> > > only for anonymous folios.
> >
> > Ironically, the only thing that doesn't fit in this file is the swap
> > stuff. The page_cluster & sysctl should be static in swap_state.c.
> >
> > The rest seems thematically relatively clean - infrastructure for
> > managing folio lifetime. swap.c is not the best name for it, but short
> > of finding a very clear improvement I'd just leave it alone.
>
> Can't agree more. We should move page_cluster & sysctl and swap_setup()
> to mm/swap_state.c, and rename mm/swap.c to mm/folio_lru.c or something
> like that.

Another issue is that many MM-internal items are placed in the
top-level include/linux/swap.h, which is supposed to be used by
code outside the MM subsystem as well.

For example, the following are actually MM-internal:

extern int vm_swappiness;
swap_setup();
workingset_*();
try_to_free_pages();
zone_reclaimable_pages();
lruvec_lru_size();
try_to_free_mem_cgroup_pages();
...

Thanks
Barry

