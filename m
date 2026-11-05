Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF388606A336
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 15:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eHTnPPRl
Received: by kanga.kvack.org (Postfix)
	id DA3636B05B6; Thu,  5 Nov 2026 10:38:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2D196B05B7; Thu,  5 Nov 2026 10:38:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1EE96B05B8; Thu,  5 Nov 2026 10:38:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8EC806B05B6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:38:51 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 212DFA88C9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:38:51 +0000 (UTC)
X-FDA: 85401473262.21.8D86451
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 253B11C0006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:38:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eHTnPPRl;
	spf=pass (imf20.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793893129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ZRMOu7q8zj8hzZXCiqSBsOFqMESxoThKf7jqYV+cxg=;
	b=iKDulMUbUydgWIvmjTrwDaUKW9SfAmQ1kedzfiEUBndp9RCufkHou4MzCFAga6a4YWkwBI
	Bc5AzKEB+Sk4/J40AcQOTp6aehCZiEUued4jg4Q/lLiyBcj1qh1JjWuGdsiRuHvb946psS
	DxkEqu52J1q9ph5JXZlNSYxZfvh/tEo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eHTnPPRl;
	spf=pass (imf20.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793893129;
	b=SxqCW8NDdRkuXeo1ckqxrp7cbuTlC0QPGD7jYtt4QeY6M6VNzNvTzN8L4l45LVTlRlF7kC
	3+7ZPivfsaYw1gbjPV4GiQGPSABCCt2zWZP44v4Caz3IwM6wYpRG5+GmfLNQpegUjlOIj9
	Z0tTnQA8TdFkqm0gkAcw7EInWA+z0tU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8CB0543677
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:38:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF4B1F00A1A
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793893127;
	bh=0ZRMOu7q8zj8hzZXCiqSBsOFqMESxoThKf7jqYV+cxg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=eHTnPPRlc0IH7Q8u3jaVpzNg12W4eRz/VwrILsZzaVscg0JSbM7yFkdkvamrOilYv
	 PRIvX/sqpEDayj+Lk93vQDhjPTOAxYuegaE4P94ccLX3a2yR6vMwleDpCiMEZRbaq+
	 eot6JHGw3a6ueS2ysJI8vNzq/73IwWSIndFB4A75LOh0NlWwZtnMC0cII1bMHcA/HA
	 e2RmPVM21KYVjaZlRGD7bbnFh3EzkFwlFlXURm3gCqQkcynaax6Ya4QpYxJvMh+YJJ
	 GCwZbt+jCS1M74E1L5AFBUcH5Noi6xZ+gp8Vk/Gqbu5WYrIkfVNbPow5hRpUT8lahV
	 YUZWyhqKMB0Dw==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c414e5d282eso269300666b.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 07:38:47 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBy7SLD5YlW7MI5Jzs1NyFBygw8jJhmPK9KK05nsZsF0hI2W6m0GnkF1PjjUKnjUoubuLNUMj4Xi/w==@kvack.org
X-Gm-Message-State: APuU4Z+UWnHH2IykwTA3DAKmL/GtTN64tob3fBaamkrZ992dNi1N96No
	FrH5FIO1lhBeQvGjQUnWBMX4fmPezYJ+8geUhHccQDOJaY4683tOB8buiAJi6b+XlIkDGRdpxI4
	xoXy35JxlUUdo+5pmJhZNjN7ucGi5MLE=
X-Received: by 2002:a17:907:5c5:b0:c49:df95:f0dc with SMTP id
 a640c23a62f3a-c4ca7b1b763mr1566645766b.19.1793893126389; Thu, 05 Nov 2026
 07:38:46 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <47ed45b5-de67-41aa-aa21-a3ba3479a7cc@vivo.com>
 <anXJ-5_vO7-toSe1@google.com> <CAKEwX=Mm2tXcen-quRXHf1Y2qSHYvpEUe4xiw-mHYaJnRUR-EA@mail.gmail.com>
 <auKqt6b4AxCLziIH@google.com> <aufPMirl4cD7tz0X@google.com>
 <18e4542967ebdd10.3137322e32332e3235332e313736.1dfc41.0000sendgmr@google.com>
 <CAKEwX=MV_xEUvz91pz6uc4qXWnWOUDtXZ2zASdNVOBHBLeA60w@mail.gmail.com>
 <18e4ebf806e937ec.3137322e32332e3235332e313736.1bf52a.0000sendgmr@google.com>
 <CAKEwX=PFdgEbba+H3fEnJFDnfkxCTsvuHEb4numVwJRaiMgwKQ@mail.gmail.com>
 <179384102494.19062.12740032892044628762.b4-reply@b4> <auwOBaRtM9p_Wxfx@google.com>
 <18e529a5ab0738f7.3137322e32332e3235332e313736.873cb.0000sendgmr@google.com> <CAKEwX=OUt4=wqDLiPvYuiTnkpuZYnszkuNQScNR93hHhVPRRGA@mail.gmail.com>
In-Reply-To: <CAKEwX=OUt4=wqDLiPvYuiTnkpuZYnszkuNQScNR93hHhVPRRGA@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 5 Nov 2026 07:38:35 -0800
X-Gmail-Original-Message-ID: <CAO9r8zMMGem-LTJQseT5xSSBjfr3UX2gzG_ftpw6+KF8m9v5yw@mail.gmail.com>
X-Gm-Features: AclHuK9v1LUqQa8y4F5WwBt7lgtm31VOg2z9IkfQynsl03ZvTXjiDfaCGV4M1pA
Message-ID: <CAO9r8zMMGem-LTJQseT5xSSBjfr3UX2gzG_ftpw6+KF8m9v5yw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] mm: zsmalloc: make shrinker compaction budget-aware
To: Nhat Pham <nphamcs@gmail.com>
Cc: Chris Wiseman <chriswiseman@google.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Xueyuan Chen <xueyuan.chen21@gmail.com>, Xueyuan Chen <xueyuan.chen@vivo.com>, 
	Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ps87st17ikpdm9eq5mgpt7uz8yqbejg9
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 253B11C0006
X-HE-Tag: 1793893128-665825
X-HE-Meta: U2FsdGVkX1+/yMSOhv8QAufGFO8frtcvrVI03DeECxDTVohu/m7OIDF2Xd8PERZ0HObtKsDBslz8qAAiDdS/YWYWoLyRPOfrhtCy6lk0b2FSdDDVyGVZp+5IyrICKRhJ5sxH3K/VsbkHiHDgC+A8l07mZ7xD3GRL8NGIi7NylUm3J754+I4YdsFx3869IV5hb4VD/+AXKS3crcFAIy3+d4gRYkYbL51IdDwQpt0HAwFkXV8wlVfLydc1JzXKvWqOakgPA6sTTgCPGHmKH25oxbvIN3/joxhuwufFHSQkK+Q3mHhCge/Dc0o/CrQwuxE06zT30z8eNBiD7pf4vURq4cyyK8Lw6p+xFNvNDHjuqQK/ASqas+7UbBXQxH4eVgJkDo4bEwWuZZcj0Vg+bIztm1mIFS+FAs4nUMzZF6VoibIinfcgPkka+jYBmeiNSeStOQmZUxa5A5J+1F/yA5tPBw9kxaMSeBgwyel3tkWva8WRMuSe2QKIrxJA3sA/eytqIvcNTPVMhdOZ+dnp/x0JOjPr9WEm2kFb1DI7mOWUnP92Q4T3PnE2yOR7ND6e61txkrIPDCjrafJJTjf//FEo1DVWlis/DlcOiz5ZNbsfVGDOU8sHint80pPsd6SqP8OWw60H/QV0oGJT7FYF1Av/uNpyhHyaHxIketr9n5pKzWiaRvgnzbSUoh7klSAcdtvIoNg9W159CRR9jjg4FeK/CC246ss4VXa/UQfV8RFzXR2fWYo9ylX1qFttUdEpNopDgsgJawRNeHPw0XEKdFbCHVJcbxZnptMNOZve6jTVXFUu3LJdzE67LHNuKmwsFO2ZAl7KHBwCLQUSc3jO7W5P5KNCZjCskq4nXeO4hlE9VnGBPMhSy641bgwDhJPKDhDPs0nSOsXEkdUGHje5EF+xqJ853v33RwFH5/nW+EqxGpTxNX7WyLB7wuj0uMS5Plfy9D/j5nFoS+Yx5kWA9U8
 eL1zE0D3
 Xa8eCTdCE+LeXA5imXNQNY7Zzrf+x0060uKt8Qj4iLZC7y+e059nHNIvYDhElDjt5Cp0JSkF8gLxbqElyvfv9f5crOt6/lAyqQMZOPl7h3QUgVlOh6PxnNDsVCRg0zifxBCywtOG6mJo+MtG2n32gxouRSQYTOBuaZ9OiLskTYv0boxEfDXioZaLI6pCKplPs+V5Q93nvd5jNCcky2/bN2C+y3JxFk+q5VIE4GBim1zTMjKHASflUobPsZ8VBcJbEZ2sCYvx84Vgbn94fR481zfTgIaGUkchsXXD6Sf6KMmdJaxS8LS00dpIdurvvY/ag8jfIWsM2qLJbBd4cKL7c5nBCJR/Tbaxsup2yqqvW6Oh1qlfqhI0wttvLNkl5kSVh3QMbVGf86iENP54/AaSO2LRP3pICDC+cNCPbyrK56Uhr29OlD060I83Zrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 5, 2026 at 7:08=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote:
>
> On Thu, Nov 5, 2026 at 6:36=E2=80=AFAM Chris Wiseman <chriswiseman@google=
.com> wrote:
> >
> > On Wed, Nov 4, 2026 at 9:05 PM Sergey Senozhatsky <senozhatsky@chromium=
.org> wrote:
> > >
> > > On (26/11/05 09:10), Xueyuan Chen wrote:
> > > [..]
> > > > > SGTM, but I'll let Sergey chime in!
> > > >
> > > > Thanks, Nhat and Chris, for the discussion.
> > > >
> > > > If Sergey has no objections, I'd be happy to send a follow-up serie=
s
> > > > to make the shrinker configurable and add the unlocked pre-check as
> > > > Nhat suggested.
> > >
> > > Thanks.  Sounds like you and Chris will to have "Rock-Paper-Scissors"
> > > to determine who sends a oatch ;)  Just joking, let's first figure
> > > out how exactly we want that zsmalloc-shrinker thing to behave wrt
> > > zswap expectations.
> >
> > Haha, Xueyuan is welcome to send the patches!
> >
> > Dumb question on the zswap side - aren't the zswap shrinker and the
> > zsmalloc shrinker independent?  Even if zswap's shrinker is turned off
> > at runtime, normal swap-ins still free slots and leave fragmentation
> > behind, and unlike zram, zswap doesn't have a manual sysfs compact knob=
.
> > Would it be simpler to just keep CONFIG_ZSMALLOC_SHRINKER as its own
> > standalone config rather than tying it to zswap's runtime knob?
>
> Yeah those 2 shrinkers are independent! I think we should just let
> ZSMALLOC_SHRINKER default to the value of ZSWAP_DEFAULT_ON.
> zswap_load() (i.e zswap-in) by itself is enough to create
> fragmentation. The zswap shrinker is just another trigger (and it's
> also irrelevant if zswap is disabled anyway).

If zram doesn't benefit from zsmalloc shrinker, especially during
reclaim, I wonder how much zswap benefits. AFAICT, it was hooked up
before zsmalloc was hooked into compaction, and compaction seems like
the right place to do this although it technically is freeing pages
from the page allocator's perspective.

I wonder if this is something we can collect some data about, and
maybe kill it off instead of putting off behind a config option. If
hooking it into compaction is not enough, maybe we should add a
similar interface in zswap to do proactive pool compaction from
userspace, or maybe move the interface to zsmalloc itself.

>
> How do you feel about this, folks?

