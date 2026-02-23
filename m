Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D986EC1118
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 18:15:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9694B6B0005; Mon, 23 Feb 2026 13:15:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 941426B0089; Mon, 23 Feb 2026 13:15:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84DB26B008A; Mon, 23 Feb 2026 13:15:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 70A356B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 13:15:33 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 240298AD0E
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 18:15:33 +0000 (UTC)
X-FDA: 84476524146.10.34A282F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1C2AB40010
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 18:15:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dDg3qDNg;
	spf=pass (imf12.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771870531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7hCkgYWja+Rs04C1655JmfwFrULUIzYVBwxAKqMgVDA=;
	b=mEOyaMSDIgpMnDbTjaoOjoB5cQTOdcruQNadlWKpkAHtT63pG0rjd5bQPMD21193LcaW62
	6ZHQAa6LPvKGilpQB/Tn6KBExCRn62jM8ETa/L7/GTEhjkMMkqpQ0LtlOwOYjAWsxTXVK3
	eUU+A4UoxSTVi30/NyxNm/avm3zoqHo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dDg3qDNg;
	spf=pass (imf12.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771870531; a=rsa-sha256;
	cv=none;
	b=rJ/tdP5Gj/470Lphnn0CVFvJZn1AN2DLGp/Wr1oj2Ub1O60awng1MW5TN6DOWYYKjlEyK6
	B3WTSmB3ZHyPiYlmxQV0Hu6oRM6LDGuv/UoO7gVAYumF6X4MY8AjKZC7nTvkzbfTNJZ+1Y
	cMRQYHbVrVOMejm0eJyVBRM8PGXfIEI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F2C0D417D9
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 18:15:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1DCCC116C6
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 18:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771870529;
	bh=87PJ9eg6meuLZO9kE2Fe5OcHqyxOzh7ZTDW3lwCq018=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dDg3qDNgCO8izKpxPO6U0bI0ubn2XcLwe7g2/75seBNMrOqKwIftGk3cpWLTMyPw3
	 G61NyOAAzIMQ8/LmOpyX5nuYom5lNtk3865Ra60hWR7lMFzPcI3eNi5wg9No9do8PS
	 +Ou/SGQwV30t9Lq24z4WRzzjl3LselO8r1IrSj+S0wnGrxRUMoqD6vYGY/GGCTy7/E
	 /P08YmkBNfU27ZyWXAXHZB8V45aQTtNsWlIoQf07NE1IykwB858lHDZvlSFoHEol5P
	 fEa3BLprBHgXSoiB5E+EgNKjD+Xhp9/Ko4pnoMKj5RHvxdBK+aH4eUvZhcesMt4AWe
	 ONbLF5kZi9OfA==
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-649b1ca87ddso4035262d50.3
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 10:15:29 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWDIk1sVBrV81fLHfoDjV48xqun2vihTwbcUu4fC18X8XShXaHU/IbXHW4lx5heyzCtKExMVAL8nA==@kvack.org
X-Gm-Message-State: AOJu0YwPodg6FaxWD/iCmYveKqebWvh1ehSPX46fW91xvdb1rFpkQGNq
	vUN+zQnPVxjLiJXLNKtwdr9FzY3h7a4gAoRNu/ReNWlJM6EVN62FA79kiiinSUME00ZZcsxSXs9
	/eTjynCkX2xr6YUsyHA42iLVB7bCJVy5W3FiLUrRhgg==
X-Received: by 2002:a05:690e:203:b0:64a:d1ef:d135 with SMTP id
 956f58d0204a3-64c787d739bmr5783740d50.31.1771870525934; Mon, 23 Feb 2026
 10:15:25 -0800 (PST)
MIME-Version: 1.0
References: <aZW0voL4MmnMQlaR@yjaykim-PowerEdge-T330> <aZiKQwT7KjWDLspH@infradead.org>
 <CACePvbW6uT5OKDg0RWS3ZBGcppBkz+MREDVXdwSat_qM=Nc5CA@mail.gmail.com> <aZxUtFaVaJbkAM8Z@infradead.org>
In-Reply-To: <aZxUtFaVaJbkAM8Z@infradead.org>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 23 Feb 2026 10:15:14 -0800
X-Gmail-Original-Message-ID: <CACePvbWkGk5Z+QueOBNCdrr1mzGxQZbRbfeskOrLsmWEvF5ToA@mail.gmail.com>
X-Gm-Features: AaiRm51k6fvUc-a7pGrBYKPMrgKmuCM7xhusy1pgi4-MOGyFAdv40P1WvazwQ_Y
Message-ID: <CACePvbWkGk5Z+QueOBNCdrr1mzGxQZbRbfeskOrLsmWEvF5ToA@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Flash Friendly Swap
To: Christoph Hellwig <hch@infradead.org>
Cc: YoungJun Park <youngjun.park@lge.com>, lsf-pc@lists.linux-foundation.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 3zjd8kdzrhitjs9zhu7unc4ncod177au
X-Rspam-User: 
X-Rspamd-Queue-Id: 1C2AB40010
X-Rspamd-Server: rspam01
X-HE-Tag: 1771870530-20507
X-HE-Meta: U2FsdGVkX19WmEXvzq9XKX+WIMUm2drnBq33V5dQJbOzUTzKrh14IXTtWhnDlvz4AJQ/RVuBc/7VXvajkjbisooNNPo2fWUlcNDGqBdmS1iXm5bDP5jwuZUE35KfOCWb/oQEzDMB9QpdRcLHRx1b+6nnFdAo4bsERQR4AQsbpAHaiPtpLh9xqkHW7gsIi53QVUQglwxkgLp4CPnBtea/0t/h4sKshSl3hPG+Y+NkYOo5hbEZPrrs8nXGRvWEyjnVMcPn1BmhV3h734kU+S1Zd65tX7bwxc4rSehIsJaAr3sdB7/5UUlkbRikr5MY2b0HYfCYqiaym5zRaIC0B79KMhtB47w2vhfk93m9lJmW28G+6N6kuhItDzwfEQ+C/ih4Tx28uotNyKWus83zI2jFbRbmvQKgMTeUS6N3ROLENYZ0no/SBAcsWLt5WRhkILP5qGQ1MpFzqHZ6wZd81tJnzSKkJXrkYNjf9eKTMaNKDhcxt54VUsexZ++ezbEiovnuXKR4Gz0gGM71VZ1HCALHr+McWu5lhgpMxjOIntqsE48gFVJYCmOdPavf5Tg11WbQC3fDM7eTRSZHpBsYmQ6/77MISVWbhDbcZRNkSZrxUDyz0faguNE+tmroNoCDYQOjFIuxUtBNMaqjjWU7SEuYaMl3EuhUZtt61VCpi4+eTX3qmzmvKWJKi5TtQqtjjMUOFfArgL43UrlnTZc3vqcU0wBI/ht987ZbQKjxxYWpGo+g+eX0zcbmH3XgiYVjUxEdCDSOeHBFLVij4sJKEjhbOG5mtj7Hq7Qws7egq9L+mstFkAOGp3jdjsRH4lkHdmlzxA+V88Y00tI6JCUTJ5097tUrWmQODROgpXCIi/3W98kwHrZanCBNSJTYe+vD0MNyrYPQ9pkXn43qhib0wTy7tCowO9hkW2asGXKmT9iMM4b1ejVpePTLvKLbwLIwwQ9ZfH2MlkW6bWPD42sSETN
 paumoqGw
 ob7AZgw5MbxA4OEeysFZWO6hqCYqWO/mW+6tsk9oQa3QqILPDi0b2Z8RXYtpw4QqiOKelkklbgV8JalLX/wJk6ptND8ANLRvECAblG+1YIuK5E9TthVQquGAV/3lePuwxQkmSssCCFvdk/xhxkUhau8Fu6UoYFNTTvpGounP7Pd+pCuVUUn4bI7jRYJQeJOUcColGeUseEEMAuV+r/Xs7yT8aeOm4AJS57WysDOZB6TupgUmoU/Woe+BUS0JaTaeCIFsrn1Op33f+H8LHfjqGE5JHQNg8RpcZ3fwGXA3/Ad/lWUxBpxojJclfZ0v+ClKy9hkLE4zzuoTbTD5uXwh9L/qCe5Ky2tRBVQTIig57fLc4Eo4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 5:23=E2=80=AFAM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
> On Fri, Feb 20, 2026 at 03:47:18PM -0800, Chris Li wrote:
> > Hi Christoph,
> >
> > On Fri, Feb 20, 2026 at 8:22=E2=80=AFAM Christoph Hellwig <hch@infradea=
d.org> wrote:
> > >
> > > Honestly, I think always writing sequentially when swapping and
> > > reclaiming in lumps (I'd call them "zones" :)) is probably the best
> > > idea.  Even for the these days unlikely case of swapping to HDD it
> >
> > For the flash device with FTL, the location of the data written is
> > most likely logical anyway.  The flash devices tend to group the new
> > data internally to the same erase block together even when they are
> > discontinuous from the block device point of view.
>
> Yes, but that's not the point..
>
> > It is easy to write
> > out sequentially when the swap device is mostly empty. That is how the
> > cluster allocator does currently any way. However, the tricky part is
> > what when some random 4K blocks get swapped in, that will create holes
> > on both the swap device and internal write out data. Very quickly the
> > free cluster on swap devices will get all used up and that you will
> > not be able to write out sequentially any more. The FTL layer
> > internally wants to GC those holes to create a large empty erase
> > block. I do see where to pick up the next write location can have a
> > huge impact on the flash internal GC behavior and write amplification
> > factor.
>
> And that is the point.  The FTL will always do a bad job with these work
> loads.  You should not do overwrites, and can do much better

I am not sure I understand "You should not do overwrites". Can you
help clarify it for me? Let say we always prefer to the write to new
clusters while some swap entries has been free. What happen we run out
of new cluster to write? Wouldn't we be forced to overwrite the
previous free swap location? It seems to me the "overwrite" is
un-avoidable if you keep swapping in and out. That is the part I am
missing.

I think if we gain insight into the FTL GC behavior, we can design
swap to be more friendly to flash. That is why it is great to have the
flash storage vendor provide some inputs. Some of the optimization
might be vendor specific as well.

> optimizations in the MM based on that.  I'm pretty sure YoungJun can
> explain all what they did.
>
> >
> > > would do the right thing.  So please no conditional version that need
> >
> > I agree. There is another LSF/MM topic related to this, the plug-able
> > swap ops backends. I hope that the flash friendly swap layout can
> > implement the swap ops framework without conditional versioning nor
> > stack block drivers.
> >
> > https://lore.kernel.org/linux-mm/aZiFvzlBJiYBUDre@MiWiFi-R3L-srv/
>
> And it should just be the default block device (and maybe file backed)
> swap.

Let me repeat what you are saying just to make sure I get it right.
You want the flash-friendly swap to be the default block device swap.
How about zswap and zram swap? The FTL shouldn't play a major role in
selecting the swap location. I am not sure it will be the right
default for them.

Chris

