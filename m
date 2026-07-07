Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4055C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 12:42:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68A416B009D; Tue,  7 Jul 2026 08:42:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63A8C6B009E; Tue,  7 Jul 2026 08:42:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 550DA6B009F; Tue,  7 Jul 2026 08:42:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 33E016B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:42:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B7B111A03E1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:42:55 +0000 (UTC)
X-FDA: 84961945110.29.BD9F619
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id C9FEC80002
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:42:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RMFpvBiw;
	spf=pass (imf30.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783428173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8IqbW2OJCLuhVwTEUye5YebDvvSBz0huNf63qStwY4o=;
	b=FSnDfN7iSMzc7DYEWWBriojG7IGJy2gdOjb9ghnD/ydxnzCMIyZQuxyvs9dqOq818xklAI
	K1yEphpaSn4kbOEYtRMFNl5AMn5rrUcTYd2S3l6JY6iTtB2UNk3/u/Z9OUkzcBus52Liqw
	VCWiBNeH95kYIii+x4Jih3z6zccXofg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RMFpvBiw;
	spf=pass (imf30.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783428173;
	b=Mot8ZI+ge0xJBxVr2DtQuo3qNerTd2al8T6BxUAB0VzRysvOygvZ8oSkZj9n6p7dAP8yrQ
	qvG5uh0eAEnKQ7Em+KB0HsdQWGbpMFTY2tzfcsf7hmEhuwNbW9+SFnP+rVwpBDUdRgK7Wn
	XzA9+/OJL2+BzpzwFE59VuESXl//9ak=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BF377437D4
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:42:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65021F00AC4
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783428172;
	bh=8IqbW2OJCLuhVwTEUye5YebDvvSBz0huNf63qStwY4o=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=RMFpvBiwSQPv6XLANZHH7BtONShiDUjyn0g+mjJBbViajpYwSWsvPQaadc+7CAABi
	 k9r06UkbnEPefvhNvi0K9+tJU5R7JwJSv12fnqtA9PT1bbBIcTBC3tfsDigdo0vZwH
	 CG8JMQOXU0ZZlYjozkkK68a2jvqvxcLi91VoGploD9xU7uBjMjBrXpE/+QXRMLU1vG
	 purR8VFWXxfT83f04gkxW/LivoR6mSrnO0l3TKNN3EcrGwL8hLV5qwKbcGkrF3VaCG
	 VScoDZZCKj+JOlaJrO9z2DJuO2uqb5cG3wdLbUbF3vmYqwsOJVhqW/duf3yRNFsR3v
	 lwiuHfnVLuajg==
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-92e5c92c389so201919385a.3
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 05:42:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rq/d1xiwg09SwvvtE/GVChzfXoWkNT5yqiNbkVwnI3/2ic3DPeUHl52IUJnG9AePRQaao/q9YHC/Q==@kvack.org
X-Gm-Message-State: AOJu0YxUMjupLR1KQNoK5Pw068vq50XEtmzKQBZSw04gvsFhEYeE/Dtn
	d3WfGIKYTrmihuQml+NAYXcyI46CoAZQzI9AgwwEiqYy+TsedhZoPPl3owQDwwyskUOW75iLf9X
	7gyHtZZS8BOs65wy5Q/mSPsIKsARXzXg=
X-Received: by 2002:a05:620a:1986:b0:915:9047:940b with SMTP id
 af79cd13be357-92ebb4c8ed4mr622437885a.1.1783428171905; Tue, 07 Jul 2026
 05:42:51 -0700 (PDT)
MIME-Version: 1.0
References: <5790c4a4-d502-4180-82f5-47de5809a4fe@kernel.org>
 <20260620081017.89085-1-baohua@kernel.org> <4aa8350e-712f-4380-b3bf-2ff06cf2a35d@kernel.org>
 <CAGsJ_4xR0Ge707s8JAfd5Fw10+U+25_nuBGuVayx9qnxR+NnGQ@mail.gmail.com>
 <c29f90c6-2075-43e8-8f0d-0d6718a0f124@kernel.org> <aj0u12N_GzGtQT6K@cmpxchg.org>
 <3af41c23-2365-4ac1-b1b9-076b6ef7ae9e@kernel.org> <CAGsJ_4wXTpTS4RF=qPs0wvF3UosrOQ7s9-zdXpx4OKGEysf=VA@mail.gmail.com>
 <aj5OEyV5WsVkwUWt@cmpxchg.org>
In-Reply-To: <aj5OEyV5WsVkwUWt@cmpxchg.org>
From: Barry Song <baohua@kernel.org>
Date: Tue, 7 Jul 2026 20:42:38 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y9DDi2ctZk1m63mwqG=5XYHWBHYx8eRsXKcmJS6WuHwQ@mail.gmail.com>
X-Gm-Features: AVVi8CdHlEciTY0UI46SD-jcTYQSLWSz_KWFcoIGgF7IiJ_6V3xd_3Dt5QVEW64
Message-ID: <CAGsJ_4y9DDi2ctZk1m63mwqG=5XYHWBHYx8eRsXKcmJS6WuHwQ@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: Avoiding split large folios if swap has no space
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, dev.jain@arm.com, kasong@tencent.com, 
	lance.yang@linux.dev, liam@infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, npache@redhat.com, qi.zheng@linux.dev, 
	ryan.roberts@arm.com, shakeel.butt@linux.dev, weixugc@google.com, 
	yuanchu@google.com, zhaonanzhe@xiaomi.com, ziy@nvidia.com, 
	Michal Hocko <mhocko@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C9FEC80002
X-Stat-Signature: gpkcxp8f5ajkidoa5eg16ycx61yw4wx5
X-HE-Tag: 1783428173-706983
X-HE-Meta: U2FsdGVkX18d9aBw66Pqt6MM6W9QG2ySxNakoA3O0rRqIUy2B+m+b0jSIIF1kA2W0afrtwl9K1jMSfPHl20DzKbDSEKOQ/6vbqFxB4MzRXYeFWLrnLDa1Xgmhl5MyQrOAXam9ULCGdwTpnBb+gXZnScou1f0QskYh3ZLm82pa83XxJ1ayHma+SBNJPp8/MCNx3aDLgvj7C2kRbeh/e2HbmQ3UJxL8zPrmD9b+/Cda2zQDhPS2F01IRMGfNqNr+fPUbLKBDWF4bgF0PhM67A7sQJSRwqIqGT8oHTrmoZonp4Sp3cFnU58iLjAl17iRMwfdIULcsm2PMFMmvKaNo85Cn/VuSOxYp96zCAzqLPsY4BRRyLE4EB840mzrx70/rjFg7wVCuyW0KjrP/bNmfeCtBpPudh/GiAajUR/DwWNKnTjtTbuesoezbZE1c/XCm2yACEq9HQFK73MXcpFiJv7UPglvvoECcXo41YgxQLQwYDHfFiMJ/LTJS0RXxbmcjExQHa2AmtboVZSF27JUGh5U6kLcSg4VLkxBKhtgKnza1F4PMuFRA/YTPhE1X9jNv3T90NXfNaxrCFKeeJTmW2wD7dZ2s5LDkrpHFHS5JOCqMy0CTczeIKSjSFGHVOmiWHPndHqbRWh6JVW3J44U0cXDeaoUJdg1SUAD/TQO6r97LUGURqaCqKByiV6+S17RErhKQdUNvObLVtRrEvz7L9YRq6uKhvi1mQw3hm8v7DxD2TdN6iquBh6SIFRAv5i4Ja2b0Y2aQMOgkxVkIh77Xwaa3v/AF+r61eUJPZhlovaKxtelBMN0H3+sAOU2+I3Vvqf5GBVhFy8BovnDwkj5guAhyG8nxLFN5SfGQ2lIqGQ5rfIlBWUpznLiR/efzc73+hrLz8XYU5YEERl2z9RvHQde7ay03G5oNb5dPnJCnzrbZenVMNRDCPXNDfcwfbUZ/fZ8Z7cozdsipjVEaPnW+K
 m6Ox95lS
 osVq7uI2N9143CovsCUHlEs8dCltcHaIBwRK1dY30p0IvqJvoUU5RvEg9dcW+y/YUsTj6lGLJutq+v0AmBU3l+/NNhDajQI3oOh8AWR3YJrrKTQ2p0qJBwMhmZwzqhLGTDqoi1RerrfBhsLxFTTk/qDfW/Fs00sgOQwoVLt7YOu/+eTqJoRZlBe+Jg449UuBdfdmDTGHjBJ1jAGoE4DY/VMN7fI/bn3BDCxgp66DgpR5g5USQ2CxAcrmpSzWJiMFKVLTZVPiF5Oplah7vAP0VuRzQ8FLq+AyJHXMIex6cKxdAriy+J5P0rssJz4qJWrsNSFMloDNpUQSNf+lYUwi+W4dTjOLZEvz2hiUihTPqPZnKBRtO6+/RLiQi2EMcGGDb/bN2+7uNhcOGjcqakOGE4MPAgmcuHfQrIS51
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 6:02=E2=80=AFPM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> On Fri, Jun 26, 2026 at 02:15:58PM +0800, Barry Song wrote:
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -5578,7 +5578,7 @@ int __init mem_cgroup_init(void)
> >   *
> >   * Returns 0 on success, -ENOMEM on failure.
> >   */
> > -int __mem_cgroup_try_charge_swap(struct folio *folio)
> > +int __mem_cgroup_try_charge_swap(struct folio *folio, long *left_space=
)
> >  {
> >         unsigned int nr_pages =3D folio_nr_pages(folio);
> >         struct swap_cluster_info *ci;
> > @@ -5611,6 +5611,10 @@ int __mem_cgroup_try_charge_swap(struct folio *f=
olio)
> >                 memcg_memory_event(memcg, MEMCG_SWAP_MAX);
> >                 memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
> >                 mem_cgroup_private_id_put(memcg, nr_pages);
> > +               if (folio_test_large(folio))
> > +                       *left_space =3D mem_cgroup_get_nr_swap_pages(me=
mcg);
>
> It's a bit awkward to walk up the whole hierarchy again when we
> already have the counter that failed. Please do something like this
> (not tested!), then use page_counter_margin() against @counter:

Thanks very much for your suggestion, Johannes! Sorry for the late
reply. I've been quite busy recently, so I asked Xueyuan Chen (Cc'ed)
to help send RFC v2, which will include your suggestion.

Best Regards
Barry

