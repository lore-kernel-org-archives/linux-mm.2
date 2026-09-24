Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFD43C98304
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 01:56:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 820666B0088; Wed, 23 Sep 2026 21:56:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D1636B008A; Wed, 23 Sep 2026 21:56:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 698C76B008C; Wed, 23 Sep 2026 21:56:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F9C76B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:56:24 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C78ED1C1C0B
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 01:56:23 +0000 (UTC)
X-FDA: 85246991046.17.B62C5A2
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf20.hostedemail.com (Postfix) with ESMTP id D52FB1C0002
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 01:56:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=V4mTc4bL;
	spf=pass (imf20.hostedemail.com: domain of kunwu.chan@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790214981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T6Z/PnVGjpKTIVo2L9T5LNyOiMhwiMnMKAIShdnqWZU=;
	b=Kq+REIkgXcHX7jKkc5oP4E7Cuw/tsLmzytaFFcn8fTAigKK1uHDTf7DiewXW0dVT+OTmtQ
	KhUhgET+RRjRl+UA/DNQwY5rbiy6fnv4TwXQJRC5vUdU/U31/TD9TkbXozd2mbc9aesOnO
	XbBH6SvKwbZFRosvad7oZcCSI0IOMRg=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=V4mTc4bL;
	spf=pass (imf20.hostedemail.com: domain of kunwu.chan@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790214981;
	b=wVoQb800mfjKT6VdmPP+acLfjF4wEZHCwI3XprWRzJSF2Gwh7FNqlAR3FBA589u2Cxsi/G
	pOMIysCjXA8NJn1cSSCpoliLTV/4IO3N4YWaHDK7EHAiyJej81B/M1wfWzuLVOR6Fyso+W
	On68SN5mB1HtQsvyr/MSXuROE4BipYY=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912e64ccso10126765e9.0
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 18:56:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790214980; cv=none;
        d=google.com; s=arc-20260327;
        b=HaZdAvhkGAT9k+pwUV287dIWe2BqBlpo7ZZ3M0wayUDDpNnow1DB4rRo1DmXFreBz9
         UAUcvtLlaXMnifuT+7DnVUjkToFX17g3HedwjeiIG2JN12AEiuT6mn5/w0xG1uJtQAZZ
         /tWpNEIrqHAJQIJeQ18xxIgyNUdiZJ2ryMHP+fHs/dvNuumf4JYpB+lJX1EMWO37440J
         zg22nFKsmCvM+l4q7EGaEPqImYsOYxn7EY/8M/LTlntOO3ejdy/jVgsjhIvFYL/MQM6H
         UO255KO+SdrPeg6DGhqyBIoP1ulsP/1bdOxuswvadLV0LfY2ADPUUmp2oo6vtjcxcRuI
         WNgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=T6Z/PnVGjpKTIVo2L9T5LNyOiMhwiMnMKAIShdnqWZU=;
        fh=KI6Y8iNamtghImqpRJASfDc2Nqba7uYoJw5R0PxYD6s=;
        b=og4agU14gaFwEih5Db2eVbRveCjPiEDNwDFVeyYAKAayA5lWEyKi7dtHNKuQq7SJbv
         xcunDEQ0vaEnE/DHz4MLldeVzj4afujyrhCFn+wAESvZzpDHmxdhSeqwV94pfxtr31NC
         B9kY/9CpCy6t2tkFvdiDn0p6ahrz0/rcjBoSppM6OXSSQuXMBNpSp5QClqr3y8S/gbI1
         +8kipGlgfdt2S4WkYpgUMykYxM1cxFL8rW6zqSSzNPc5ahcDbVqJkoGeHD2lvaLA9uxE
         9gF5qfNM0PcTlp38vPOcutYMfajaZYhAb2Oy6h94nhooR1kGaMdkIvsvZ8zUl2HS930Q
         CGJA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790214980; x=1790819780; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=T6Z/PnVGjpKTIVo2L9T5LNyOiMhwiMnMKAIShdnqWZU=;
        b=V4mTc4bLPsmQeKABnGE/xXws8MpFmzYKfxwWhstWdn414uV9aKiMTr7oBDK0en/9nP
         qR6mz6GRcKWx1gPWo0bseLQKqtwAJmDAlEYPqndcXL1gn2m5hTlHK1tEoaqbfalw/46O
         raGPFy6aMBCR/mFK4arAGi3IpuT4xpa/4Li+X/WCvmR1orNDvY+lqalYGerMlnYjZmaQ
         YzEwPy4IC7VDnOGjNpleAq3oph3n5TAoYdMCE1Q+rH0xLI9R3QtvpEGVRK6UCvAHICEV
         QRFFPp5CriNRlEEPqJSDPvkVzgdggLNIsuklC3+V2jck89nGium3Cp+LeXCc//nSaTRj
         eGPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790214980; x=1790819780;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T6Z/PnVGjpKTIVo2L9T5LNyOiMhwiMnMKAIShdnqWZU=;
        b=ZFTKGXaJ5sddo2xxZ3TdBQxIzYeYfai1/M6oH2ZIuFKX/a0AOqDAsDEePqYPZ0YPKK
         inLeYSSlY9zT5Up1L5uLHqu9k4zjLHEPlEhIq2oVljfNDmpjeUGPNoo2F4cVZXYZWuSV
         1v30PtG88ePgeYKspsYdwgozEiUbFMQwRBMNF5JlaiIbzGit8Yf8QGh+pHv0LHDQBC2a
         I7SZVvq3Y3EDMP5mEJupyUMNOM4z85WnCQgEOMI9+ZNrXbMuW5pk5SJiIPojK5MwlnXU
         Cpg5xqDT4gmk6sU9Hlhk4SKd5gQmS44f5U9wLPnw3OFnHWaS8Acs9iRKKAgioWfWvK1L
         oOuw==
X-Forwarded-Encrypted: i=1; AKwUvByOgF7+RAuChheCAnft/V5LRh4cdfO2m+j/YMyfStcM5EkR5IIC92WbVHl4Z3SQ13bYwGhUDNcL6w==@kvack.org
X-Gm-Message-State: AFuF++lscDAQ5n2DY7l8DojnRvRp0/rla5IEjPX02XpuiPvktB4A//Ke
	HbVolctc0B5Vjdsa9Y58fTEY/DVqoxvDZXjHyeUWE2V65P9cQJm+wTvqG2MjZYeAOeLit6ynNkl
	AWLYIXH6uyKmvX5MKTSHgoHuAxPGn7dA=
X-Gm-Gg: AYBFou3ns6oT4h0EEIUxEJcY86BDgjyNG1WlXIxaRhFAAPf5OCFx2wIMnKs4YG2Hnsv
	p5b0mjpvdd+PJcnhvA+PWjluBhUefIE/+C0X9KbQz6kAHTLAkii8i8zd3fcfUBSGNb0Royk5mSz
	eSPCvIdO/xjXO3n6NUUfFPEFCX8grhC88kc/vC3TXu1kC1sd48cCbhaU5dYFsvquykB/AbrTH1x
	jpPEQ4wAm4OG6e5Dq0oHWNYdeHNr8GXahyw6WVLLNMcPAbMR7E2jUQb97Mik84mX+FFdNLAN4dB
	tpOSnsvLpS6iumN7pYik1/3ymQvjnb0NtUKi2lIbAo2ZB/0npS3lLK+5G4K0+e+/G0CG11cA7MZ
	XW2elYVjztpJebA==
X-Received: by 2002:a05:600c:34c1:b0:49f:bd3c:bc21 with SMTP id
 5b1f17b1804b1-49fe670781emr14793475e9.28.1790214979782; Wed, 23 Sep 2026
 18:56:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260920072043.430390-1-hebaoquan@kylinos.cn> <CACePvbXiUmGV920BM58FKuP_iuvhRuoSZrGrrS53rLctJd5uVw@mail.gmail.com>
In-Reply-To: <CACePvbXiUmGV920BM58FKuP_iuvhRuoSZrGrrS53rLctJd5uVw@mail.gmail.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Thu, 24 Sep 2026 09:56:08 +0800
X-Gm-Features: AclHuK_mj4niWNcydt7-p-fYvtFJAG2bfKOsnaAyE3CnlQa3pCABR1PEvyYvBP0
Message-ID: <CAN_Opa9usQWbCFL0chY-MCJ94-SQt4neOmcgz2S+_b=90fFZLw@mail.gmail.com>
Subject: Re: [RFC PATCH 00/17] mm, swap: xswap writeback to a physical backend
To: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	kasong@tencent.com, hannes@cmpxchg.org, nphamcs@gmail.com, baohua@kernel.org, 
	youngjun.park@lge.com, david@kernel.org, baoquan.he@linux.dev, 
	gourry@gourry.net, riel@surriel.com, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D52FB1C0002
X-Rspam-User: 
X-Stat-Signature: bhiaqjeppqj16nh7fkhkihuqco7daz4n
X-HE-Tag: 1790214981-925854
X-HE-Meta: U2FsdGVkX19IDKLxuquPiQSdu1JjzNmTjq9HcOzFGJ0QGwKf/XcFgde9jpB/YLcB9i5RXVGFipy/N7brJCLuyf4tCTzLIWZgALt6REkyYMX5nTCjPdQmVSQgtkfONOu+fMNkEzVu9bxg/+u/VY3Q7Ad1HnZQ4vZz6e9Q4jnh21pkZcgzJVkywAUTlzP36kzVZjj+PD2qq5LcS+q6Mn11WRX/Y4YkRHGHnJoGgG/Q42JnnVOOjs4MtwLGoMLJ/rhETMGvP2wlH4YdwoceRk3DRg3KB9gEGi4WpnPtx6Pa59KdApa25lfOIaSQKLkpgSArOqbk7tzne+VXiL8Fyg2JU2nQDKSP+XsbAyh6ua9k04T1C5RGuHAek3AEOtygNsrEoUB/hu/OlxELOC58CuWcoGTjvf+kEd2lL428qqtvS77//muBXyED7v5knhLAa5UsuNjzNFJn3ye9tTwNOytT5fknkWGTffpobH45QJ2Gr+9ZPV6ASu/9DlmNyjXSgsN1pkDEXNo/uFt4rhFBp57sWwd64tD4IbjeZ+1AXAauipzOTSBp7Ix3eIGoKLTPBX0h//8xrEez/1piDClp4A+KS3tSHJE/8K2tsW/3BDAd1sq6/amJ47lfdwXrU1EpJFkCyYux+8OO4UGyiBbr2ZXWAPmK2mM73EzKtQO/vAEb7gLhsP1j5mvbWgnSKe0njkgA07aNsCxTiv0IJu9QO/wHR7UploN+/wOa1LaOBgNoPI/4APVHxNtDNJGzDPWpl+Ng9xfTZ5jBZJwf0hWK5hNvgF98LJVnysfqSreZ4vXVcu5+1lzbMrNnBv4tsWCgoS+S3joECJYxENowEn1SQ28u0ZZtM2shqEdWptMr/PDKCo+n0Ng2He8MTdhe/zW8q4xQ53y0uTov3Ot5AMPA2CbuqNPS1TPj/8F9t5p9RDcPO5RnRRk2uIWXXf0KuUuh974Epyz3an7kqHipcOakpCS
 LRJu0y4+
 5Hb9xEJYfDd8OTXfTO2lupEQEzn9NH6JAFwe+uZmaB9QLRVZIQ9Yl+v/clOD+H8PUj3lPEdVg9PsB8Ty87y0E3MlS6oIF8gYfMWGViFoCO1+OFgNoB4srNUmU4Lx7eIGsZ1t2XUHaRviaZFs3f7x+xd1+U36hFiQFeUchW1frTPdJUdpqVP8EEgUVthaiqzUMFoU3cf6T7SLtA5Y5ub+r5BO1WhVo73RZYn8aPUPCCAXa4m+lg6MA38fN+tET12TJ5l4XVFP7A/eiofE6RxYqBrYdj74f6Ag02eqdiYeuqHQ9HmC5cEM8P68brwo+YMLmdsC5ZwkDrN2G6ie7ommP4VXDTzbOzYwH1tSlSCucuupQh+I3rA9esB41al+FBwfUJguq9XGBCipmxyX/x9gj/avdaheHkY3ioyBz35kSTtmnEBiBv3fjibyMXT5Y94AWtW1smLTqZUCbTp4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 10:23=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote=
:
>
> Hi Baoquan,
>
> First of all, thank you so much for the great work. That closes a huge
> gap in the xswap stack. It is a huge step forward.
>
> On Sat, Sep 19, 2026 at 9:20=E2=80=AFPM Baoquan He <hebaoquan@kylinos.cn>=
 wrote:
> >
> > This is the writeback layer for xswap, on top of the base series. Post =
it
> > as RFC for discussion.
> >
> > The base series keeps every swapped-out page in zswap. So the pool must
> > refuse new pages once it's full. This series gives an xswap slot a
> > backend to go, and charge it only when it really goes to real disk
> > space.
>
> We should also preserve the charge to the swap counter when swapping
> out to xswap. I don't mind having an additional counter track
> compression memory vs. disk usage, etc. The swap counter charge should
> preserve the current behavior.
>
> > Design
> > ------
> > - Backend: when zswap refuses a page, take a slot on the real swap
> >   device with the highest priority and write the page there. One IO per
> >   slot.
>
> More than that, it should also happen when zswap needs to do the
> writeback. Zswap has some write back hooks when the system is under
> pressure. Those hooks should be introduced into the core swap stack so
> other swap types can benefit from them as well.
>
> I would like to point out that the allocation strategy should be
> different when allocating for the swap backend. We might want to
> introduce an allocation flag for that. The backend doesn't care about
> fragmentation as much. Fragmentation is a performance optimization
> here. The backend can tolerate fragmentation. In the upper layer, swap
> entries are 2^N aligned and sized. It is a hard requirement.
>
> > - Ownership: that slot has no swap cache folio, so record its owner in
>
> Clarify: by "that slot," you mean the backend swap entry has no swap
> cache folio.
>
> >   the swap table entry. 0b100 in the low bits marks a backend slot, and
> >   the xswap type/offset go above. The physical side then does not treat
> >   it as free, and readahead skips it.
>
> I don't want to get ahead of ourselves. You have only considered
> writeback from xswap to disk so far. A stretch goal for you is to
> consider how we can mark the swap table so that it can work with other
> swap types as well. e.g. e.g., writing data from SSD to HDD. We don't
> have to do it in this series. But it is good to start considering this
> kind of thing so that we don't lock ourself out when we want more
> generic writeback between swap tiers.
>
> Stretch 2 is considering how to deal with data moving from xswap to
> SSD, then SSD to HDD. The front swap only needs to point to the HDD
> and skip the SSD completely. It shouldn't require a forward chain.
>
> > - Per-slot record: ci->xs_table[], one unsigned long per slot, allocate=
d
> >   the first time a cluster takes a backend. Zero means no backend.
>
> There might be some micro optimization we can do if the whole cluster
> does not point to any back ends, we might be able to design the array
> access so that we don't need to allocate the back end pointer array
> for it.
>
> > - Read: a written-out slot has no zswap copy, so swap_read_folio()
> >   follows the pointer and reads from the backend.
>
> We need to pay attention to the race condition here when moving data
> from xswap to the backend. I am not saying you have a bug here, I
> haven't read the code yet. I imagine there will be some very tricky
> swap cache interaction going on here.
>

Hi Chris,

> > - Release: verify the slot still points back to the xswap entry first;
> >   the record can go stale.
>
> What do you mean the record can go stale here?
>

I read the "stale record" here as the xswap-side xs_table[] record
of the physical slot in patch 04/17. xswap_backend_alloc() sets it
with xswap_slot_set_backend(), while the physical slot also has a
reverse mapping installed by xswap_install_rmap().

The two records are maintained separately. In xswap_backend_free(),
the forward record is cleared only if it still matches, and
xswap_free_phys_slot() then checks the reverse mapping in the
physical slot's swap table entry against the xswap entry being freed.
If the physical slot has already been recycled for another xswap
entry, that check fails and the slot is left untouched.

So my reading is that xs_table[] can still record a physical slot
after that slot has been recycled, while the reverse mapping in the
physical slot's swap table entry identifies a different xswap owner.

Thanks,
Kunwu

> > - swapoff: try_to_unuse() used to skip these slots. It now reads them
> >   back, marks the folio dirty so reclaim re-stores it in zswap, then
> >   drops the backend.
>
> It seems data can remain in zswap past swapoff? That seems wrong to
> me. In my mind, it should just read into the swap cache or promote to
> the upper swap tier.
>
> > - Reclaim: an xswap entry's count can reach 0 while its folio is still
> >   in the swap cache; the physical scanner reclaims the redundant slot
> >   through __try_to_reclaim_swap().
>
> Clarify: I assume you mean swap cache reclaim not the memory reclaim.
>
> > - Large folios: a read starts at the first physical slot, so the run is
> >   reserved whole and must be backed contiguously; otherwise the fault
> >   retries at a smaller order. xswap is SWP_SYNCHRONOUS_IO, which also
> >   skips readahead.
>
> I imagine the front swap needs to be contiguous, but the back swap doesn'=
t?
>
> > - Charging: Record the owner at allocation but do not charge. Take the
> >   charge when the entry gets a physical backend slot, and give it back
> >   with that slot.memory.swap.current then counts only real on-disk swap
> >   usage, and a cgroup with memory.swap.max at 0 can still swap out thro=
ugh
> >   zswap.
>
> I want the old swap charging behavior back. Please don't change that
> behavior. That behavior change should be a separate discussion and
> split out from this series. BTW, I am against that change.
>
> Great work.
>
> Chris
>
> >
> > Note
> > ----
> > The base series is sereis of xswap foundation. This one depends on it.
>
> Do you have a git repo I can fetch from? I will try applying your
> patches as well. I assume mm-unstable should be the base?
>
> > So if anyone wants to apply this patchset, the order is base-commit
> > as below, then xswap foundation, finally this patchset.
> >
> > [PATCH v3 00/14] mm, swap: extendable swap devices (xswap)
> > https://lore.kernel.org/all/20260916101929.149106-1-hebaoquan@kylinos.c=
n/T/#u
> >
> > base-commit: baa8de2f3448d1466a888a805c18d01c998fe052
> >
> > This partially refers to Nhat's vswap-v4 series. E.g patch 1 is
> > consistent with his patch 3, patch 12/13/14/15 are from his patch 8.
> >
> > And the last 2 patches are fixing bugs when charging patches are added.
> > Since the charging of xswap is still under discussion, I dind't merge
> > them into commits. Will squash them or take them off once decision is
> > made.
> >
> > Testing
> > -------
> > qemu KVM guest, 8G RAM.
> >
> > A 4G swap disk /dev/vdb is added as the physical backend, and zswap is
> > turned off so that every page has to reach a backend slot. Note that it
> > need create xswap device firstly then disable zswap, so every page has
> > to reach backend slot.
> >
> > The workload is memhog, as in the base series. Every page is filled wit=
h
> > a fixed pattern, so the data can be checked after a readback.
> >
> >   # echo 1 > /sys/module/zswap/parameters/enabled
> >   # echo 100 > /sys/kernel/mm/xswap/create
> >   # mkswap /dev/vdb && swapon -p 0 /dev/vdb
> >   # echo 0 > /sys/module/zswap/parameters/enabled
> >   # mkdir -p /sys/fs/cgroup/xswap_limit
> >   # echo max > /sys/fs/cgroup/xswap_limit/memory.swap.max
> >   # MEMHOG_FILL=3Dpattern numactl --cpunodebind=3D0 --membind=3D0 ./mem=
hog
> >
> > 1. Swapout to the backend
> >
> >    Run the workload with 5G of memory in a cgroup capped at 4G:
> >
> >    # awk 'NR =3D=3D 1 || $1 ~ /xswap|vdb/' /proc/swaps
> >    Filename                Type        Size      Used      Priority
> >    xswap0                  xswap       8155132   2392176   100
> >    /dev/vdb                partition   4194300   2392176   0
> >
> >    The two Used values are equal, so the pages reached the backend and
> >    the xswap side accounted for them.
> >
> > 2. Pages are read back from the device
> >
> >    Lifting memory.max and touching the pages again reads them back. The
> >    pages-swapped-in counter went up by 265642, so the read did reach th=
e
> >    device. 1010 of the folios read back were 1M, each read with one IO:
> >
> >    # echo max > /sys/fs/cgroup/xswap_limit/memory.max
> >    # cat /sys/kernel/mm/transparent_hugepage/hugepages-1024kB/stats/swp=
in
> >    1010
> >
> >    hugepages-2048kB/stats/swpin stays at 0, because the swapin order is
> >    capped below the PMD order.
> >
> > 3. verifies data correctness
> >
> >    After the readback the data is compared byte for byte against the
> >    pattern, one time with zswap on and one time with zswap off, so the
> >    pages come from zswap in one time and from the backend in the other
> >    time.  All bytes matched.
> >
> > 4. Destroying a device returns its backend slots
> >
> >    The device was filled, then destroyed with no readback first:
> >
> >    # awk '$1 =3D=3D "/dev/vdb" { print $4 }' /proc/swaps
> >    3157220
> >    # echo 0 > /sys/kernel/mm/xswap/destroy
> >    # awk '$1 =3D=3D "/dev/vdb" { print $4 }' /proc/swaps
> >    0
> >
> > 5. verifies the charge is correct
> >
> >    An xswap entry is charged only when it holds a backend slot, so the
> >    two counters have to show the same number of pages:
> >
> >    # echo $(( $(cat /sys/fs/cgroup/xswap_limit/memory.swap.current) / 4=
096 ))
> >    526852
> >    # awk '$1 =3D=3D "/dev/vdb" { print $4 / 4 }' /proc/swaps
> >    526852
> >
> >    Nothing is charged while the pages stay in zswap: with the pool hold=
ing
> >    them and the backend untouched, memory.swap.current stays 0.
> >
> > 6. A cgroup with no swap room can still reclaim its anon memory
> >
> >    With memory.swap.max at 0 and no xswap device, the cgroup ran out of
> >    room and the workload was killed. With an xswap device and zswap on,
> >    it swapped out through zswap, was charged nothing, and was not kille=
d.
> >
> >    E.g if memory.swap.max is set at 100M, the cgroup will be killed whe=
n
> >    the cap was reached.
> >
> > Baoquan He (12):
> >   mm, swap: tag a swap table entry with its owning xswap entry
> >   mm, swap: prepare the folio-less allocation path for xswap
> >   mm, swap: add a physical backend for xswap slots
> >   mm, swap: use the xswap physical backend
> >   mm, swap: fall back to disk when zswap refuses an xswap page
> >   mm, swap: support swapoff of an xswap physical backend
> >   mm, swap: reclaim physical slots backing cache-only xswap entries
> >   mm, swap: back a large xswap folio with a contiguous physical run
> >   mm, swap: enable THP swapin for xswap entries
> >   mm, swap: drop swap_folio_sector()
> >   mm, swap: do not retake the cluster lock when uncharging an xswap slo=
t
> >   mm, swap: drop a refused xswap backend run directly
> >
> > Nhat Pham (5):
> >   mm, swap: prepare the swap IO path for xswap backends
> >   mm, swap: split the swap memcg charge helpers
> >   mm, swap: do not charge zswap-backed xswap entries
> >   mm, swap: charge an xswap entry when it gets physical backing
> >   mm, swap: don't gate xswap on the physical swap free count
> >
> >  .../admin-guide/cgroup-v1/memcg_test.rst      |   2 +-
> >  include/linux/memcontrol.h                    |   6 +
> >  include/linux/swap.h                          |  69 +-
> >  include/linux/swap_ops.h                      |   9 +-
> >  mm/memcontrol-v1.c                            |  10 +-
> >  mm/memcontrol.c                               | 147 ++--
> >  mm/memory.c                                   |   7 +-
> >  mm/page_io.c                                  |  95 ++-
> >  mm/swap.h                                     |  35 +-
> >  mm/swap_state.c                               |  12 +-
> >  mm/swap_table.h                               |  53 ++
> >  mm/swapfile.c                                 | 742 ++++++++++++++++--
> >  mm/zswap.c                                    |  20 +-
> >  13 files changed, 1026 insertions(+), 181 deletions(-)
> >
> > --
> > 2.54.0
> >
> >

