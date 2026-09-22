Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8C12C982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 11:10:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B4CE6B0098; Tue, 22 Sep 2026 07:10:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 964BF6B009B; Tue, 22 Sep 2026 07:10:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 856906B009D; Tue, 22 Sep 2026 07:10:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5B6F56B0098
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 07:10:49 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E10B91203FD
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:10:48 +0000 (UTC)
X-FDA: 85241130576.28.DED41F1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 13AF4C0008
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:10:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Cw/Zr3ZL";
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790075447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FWjWwozCfG09p014wbFDCqQeW+3NpBoNoOf7ed+0xEM=;
	b=mOIL80AX7Dm7kGnDvsLJ5Jlk/IIE6WXkzgL/XRcJ4ohKXSvToiW15hhn9jIqEXTI44sT0w
	cmrPobHvaYN4V0zWegXxZ3BiENlDHGxVvHyTRazdnSqzOeq1gSh8kh8SF2uWVtk5MWiQ+4
	wb4D2LzYm6YXv8s+8jomi5e7VvLSomE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Cw/Zr3ZL";
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790075447;
	b=gvCR+fTwMQ1NEaTNwgbHjb/FH0IubZO9q8f8lobfaxGCOjH13flaSjnLtT202ms0Ey7wMz
	ie/4EtqZTw+MQYMYvGYtQ7eGuAuBY4LEDouYR2bsGWeYustTAbJAbD7Kf1FljyFBPXOXO8
	NZhDfGVytJQuf0q6C6UdtY1xf+oxDcs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3726560E13
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:10:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E16421F00899
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790075445;
	bh=FWjWwozCfG09p014wbFDCqQeW+3NpBoNoOf7ed+0xEM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Cw/Zr3ZL8HZC88La1lOAIil2qn+N0Wq/11RMxuhFvv4Pra0o7BYINUytDkgJy3cvR
	 AcDR6onlpqTgNzpGen+1dmUMA6eHvteT2O6Wt2tnkkxPxOB+TXVaj02L/r+bIGaxqV
	 5xlPUoGD5duVFr+uIvqJiFkyQWUs2mQMnU2fAlgLHqwN98mgiBtK9X+3rpXK/+jSW0
	 Ev0I7iGWVcAAnsuoQvanmTc5/742tVAL8V5Kyh29sslKu9MUyGE1gQNfuu6RQcu9kD
	 TooBDUL6qTxWaFkT6eLm1NcHjI4k772uSTKdQVxvnu+p7Xt9x1kqxKZBKtOQtSlPDc
	 047DT+b2taTrg==
Received: by mail-qk2-f41.google.com with SMTP id af79cd13be357-93910ad2273so476993885a.0
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:10:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxJPjls/iWpt3vPwIQLGJRBtn0Ma4baMtIiDq7XgBbZYbi0zQqUH5LgVj1zzzRIBQPl2kZFVNpQjg==@kvack.org
X-Gm-Message-State: AFuF++k2oDQr3+qox8CN4zOIlAQG2com10bxFjn1jYoUH6ke4LUcD1HD
	Booh50QO3qQ6NeZVM5O9w9MvwZLQuqrui25ZGMVssn1Y3/jx1G2oUjDAXticCXWXI9ZzEG6l86O
	MIwTBviwCScIw6/M/goBL4gdxMBLMshw=
X-Received: by 2002:a05:620a:6cc9:b0:939:6de8:43dc with SMTP id
 af79cd13be357-93c15e78cefmr509373185a.48.1790075445161; Tue, 22 Sep 2026
 04:10:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260921152449.629486-1-alex@ghiti.fr> <70cae945-3a4a-40db-96ac-5ce66a3fa186@kernel.org>
 <CAGsJ_4y8-wD0yMV8GCtCz5MfNrOKqUaTd+UgH=8MoP_nuvPnGg@mail.gmail.com>
 <108487b7-0529-4282-b5f4-355804b4c0cf@kernel.org> <CAGsJ_4zGmGh70QtRBpnhueev3qt_bgB4ZiE9fkW-hgNjAVhv+w@mail.gmail.com>
 <arJcPIaqJOzLpkel@gremlin>
In-Reply-To: <arJcPIaqJOzLpkel@gremlin>
From: Barry Song <baohua@kernel.org>
Date: Tue, 22 Sep 2026 19:10:34 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zLY6eZWUufuVqLgEVf93G1JoKtk9ObftkoTwbAimG8Yw@mail.gmail.com>
X-Gm-Features: AcwNN1WGDooBKfoE6NAcLPXoe3osiB8r5tT_HlJWIcwGy2CzV98OLFsDfzwfKSw
Message-ID: <CAGsJ_4zLY6eZWUufuVqLgEVf93G1JoKtk9ObftkoTwbAimG8Yw@mail.gmail.com>
Subject: Re: [PATCH] mm: madvise: drop MADV_PAGEOUT folios at swap writeback completion
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>, akpm@linux-foundation.org, 
	willy@infradead.org, jack@suse.cz, liam@infradead.org, vbabka@kernel.org, 
	jannh@google.com, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	youngjun.park@lge.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, yosry@kernel.org, 
	chengming.zhou@linux.dev, kunwu.chan@gmail.com, tz2294@columbia.edu, 
	hch@lst.de, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 13AF4C0008
X-Stat-Signature: qif5ohwwy1ay36af1sscw8zc6kri995s
X-HE-Tag: 1790075446-564701
X-HE-Meta: U2FsdGVkX1+DIyJeqIkwocQjoOikrh8pptf4dvDttLt5Jf9dCj5QHUe2MqirLc2ruaUbrr2AMIOK1ZbD039JblMP+9DiogGpJfI0lX4sySTwIK6eeXTyvIHCIQ2Kllqujgpabneu08rbh4FtuEzxdz3g1r5jJxbJd3XaGP7yNslQWrqVu5YEZPOQ94dKEIywM6pEcAF4Y/NbfTtAidroLzcKE6b+FAzac8iED/+POgtnUTcd78P90DVXHS/k/nw7CP8E1I9D5X4LyEFlYreZyPb1uJd2zoGjV4N2hgV9oxJ08VHSj3EhuZQCljS0q13Wrb8dKUS+CDcbVD5r2vxV8sB2gtctLS1xSyFfBxCXROHy49ztFQNShhIOuJCkMh3aOOQBrbftMdUj0iczBT1zgoy6BnWnAtB0UmKz0yhx310uxJvaW3+9Av7PQxh5rEdTOGMsnOwNHZkGy8RtsvwEF7E/nJhmNRL1tVrgy+GUvPTTVcGzSp8lO05aULcaRPoZBaDf88HEs3FrHs06ZINRMe4Lb8iJSGe2q8ONfRqdIRXAOy3HmH98br2PzMGYw8EFgyr/LPlvb2gilaoU2UPYcAHksbd9hBo6i1smjqVnj6RpKzNf8nstupmG55hlT87p7dVbMMOpFozN2NoRpuYfTgn0t27Rr5hwjBS81lM6mNXGn9HEpjWRplodo/J2b8OdgQ1J7qEADuA2oA+P3hKsPzURlqbyfL4IObC+c7he9O7sRGhdtwODLWoekjcrBrqFXpRR4RyeN5Oiyuwwd1YsxX3eOe629LoxaWZQxhJj8FUflXtdQ8aqCAkzK9zX5JIrSsppWFWrcBp/QMOeF6l6g+6XnkCj+u0A3BZAUJZyI3j71c89xjv3dVeybM1KqVLO+7wHFDqhAAxg6f4E+GBKlNgTm9Bt0edF7Wi8dBBdxb6MMH45xfi4JpFTyvosb/TONScRf4NjXs//inh5Bn8
 F6uaLrzw
 +YxVouhtFxXOuV/6anLJPVddMeNmpeV1/RyUGT4wmUP6orAIUAtuM0FUf9GzHiUWD3bjqaV5QF88vVO9xwaqHvWEWGlURc+9+FHhp+b7y5QoxInZJ+eS8ckzsYp+OsDU+Nm310s1O6T/bXjzAaRciCQwJLISC2liR/g26IGNBSgr4RNELv88bU3HIBmrMTDiK8T5oBnb6ve74vtyOYOsWL9Onmg+UKcZLT/gYvtKf/xPXA5VayYmjxR2F77rfiBfuD4U5I/rM52LbvbnfR4CuUPueVl2gAFJLQabB1gRGzHuK/dhU8xO0wiX223fv0wCsSQ2X05DquiOWhVZgZzpK2qQ+ABpGioym2y9hxFxIDNBUxoXi7G4jNgjMQUlITn3PsD9u2ekYgnqiv63wRqb8bGe+nljh8iRXhWF05TgTdFu444a166+lia1viw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 6:47=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> On Tue, Sep 22, 2026 at 06:37:38PM +0800, Barry Song wrote:
> > On Tue, Sep 22, 2026 at 6:20=E2=80=AFPM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> > >
> > > On 9/21/26 23:56, Barry Song wrote:
> > > > On Mon, Sep 21, 2026 at 11:37=E2=80=AFPM David Hildenbrand (Arm)
> > > > <david@kernel.org> wrote:
> > > >>
> > > >> On 9/21/26 17:24, Alexandre Ghiti wrote:
> > > >>> On an asynchronous swap device MADV_PAGEOUT only marks the folio
> > > >>> PG_reclaim and rotates it to the tail of the inactive list once i=
ts
> > > >>> writeback completes, so the memory is not actually freed until a =
later
> > > >>> reclaim scan removes the by then clean swap cache folio.
> > > >> But we have the same behavior when just reclaiming memory ordinari=
ly? It's added
> > > >> to the swapcache and only the next scan actually frees up the memo=
ry.
> > > >>
> > > >> Wouldn't we memory we reclaim ... just gone, like in the sync case=
?
> > > >
> > > > For synchronous I/O, such as zswap and zram, the memory is released
> > > > immediately after sync I/O is done.
> > > >
> > > > For asynchronous I/O, such as NVMe, the swapcache is currently
> > > > expected to be rotated back to the tail of the LRU and wait for
> > > > another scan. Alexandre once mentioned that when he tried handling
> > > > async I/O the same way as sync I/O=E2=80=94releasing the memory onc=
e the I/O
> > > > completed=E2=80=94he saw some regression. So, delaying the release =
until a
> > > > later scan may allow swapcache hits before the folios are eventuall=
y
> > > > reclaimed.
> > >
> > > "may", do we have any evidence that this actually is relevant in prac=
tice?
> > >
> > > We asked to reclaim memory. We wrote the memory out to disk. We unmap=
ped it from
> > > the page tables. We made the workload the could, access the page imme=
diately
> > > again suffer already.
> > >
> > > We should just evict them as soon as possible to free up memory.
> >
> > I suggested this to Alexandre, and he found that it could regress some
> > workloads [1]. That is why Alexandre is only making the folios
> > immediately reclaimable for `MADV_PAGEOUT`.
> >
> > See Alexandre's description:
> >
> > "Future work
> > -----------
> > Barry suggested extending this to MADV_PAGEOUT and general reclaim. I
> > prototyped dropbehind for all reclaimed swap folios and it regressed
> > sysbench OLTP throughput by ~15% on NVMe swap: dropping the swap cache
> > immediately turns cheap in-cache refaults into disk reads and collapses
> > swap readahead clustering. Neither blk-wbt, mq-deadline nor a PG_workin=
gset
> > gate recovered it. MADV_PAGEOUT alone may still be worth it, since ther=
e
> > userspace has explicitly declared the range cold, but I have not measur=
ed
> > that case in isolation yet."
> >
> > [1] https://lore.kernel.org/linux-mm/20260921151306.625134-1-alex@ghiti=
.fr/
> >
> > Best Regards
> > Barry
>
> This patch as-is is just way way way WAY too complicated and fragile IMO.
>
> Whatever cases you have found, they need to be fixed somewhere
> fundamental. All of this feels like a hack.
>
> If you're having to write a comment like:
>
> /*
>  * If X is Y, but not if B, and if Z is J but not if the moon's bright at
>  * night, then maybe we will foo the bar, but only if the baz is blarghed=
,
>  * ...
>  */
>
> That usually means you're doing something horribly wrong.
>
> And this patch has multiple comments like that.

I'm not quite sure if you've read the context carefully :-) or why
you're angry with me.

I did suggest that we should reclaim memory immediately after
writeback completes, both for general memory reclaim and for
`MADV_PAGEOUT`, while Alexandre was working on zswap dropbehind.

Alexandre then found that this might not be a good idea for generic
reclaim, but thought it might still be worth trying for `MADV_PAGEOUT`.
That's why this patch came about.

The discussion between David and me is whether we should do this for
`MADV_PAGEOUT` only, or also apply the same approach to generic
reclaim. So far, we haven't even gotten into the code details.

And this is also the first day I've seen the code. I agree that I can
work with Alexandre to improve the code through review, but please
keep in mind that this is literally my first day looking at it,
my respected Lorenzo. :-)

Best Regards
Barry

