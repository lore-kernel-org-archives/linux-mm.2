Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D8CEC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 11:29:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7190E6B009F; Tue,  7 Jul 2026 07:29:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C9586B00A0; Tue,  7 Jul 2026 07:29:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BABF6B00A1; Tue,  7 Jul 2026 07:29:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2653F6B009F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:29:50 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 982FEC2569
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:29:49 +0000 (UTC)
X-FDA: 84961760898.09.B7D25E8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id A88F210000F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:29:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CiZitJhy;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783423787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zed0CSJYp5L4Z8pg50A4nffbazSM4sxmWmqQFaANC/A=;
	b=F2WmrF8LC8ZBp/5QZjM4o9HxjVmIJJxlMV4K1U3LhTNxP1WEWup/+w8EmKSqqwVIwfDE+X
	Dm/HONLlu1V4YU5L6tkDlQftIUoTkst4Wb3DxjcXol3nNXnX32kR9Cq8xTgra3X/EbVCSJ
	QWi3Pn0Yvs4kC1e7z8ucCXJYCMCglHQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CiZitJhy;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783423787;
	b=zZg9OrnoV5okaJQAarMWXcfcdbm+GcJYY5gNcXJLcutrC6j/TTkc/bWAEYKF3Gj8lvib9x
	mgUz4YTlFg1uaAEFo2fVfrm3JvjG2QfyA0IeWvSyXa1py2z+O/rn6aEaTmLHxkC9jSMu7T
	77dQ/qjVORFcs2S5BKBGgujcCY8SN8A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9274543B3F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:29:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771321F00A3A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783423786;
	bh=Zed0CSJYp5L4Z8pg50A4nffbazSM4sxmWmqQFaANC/A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=CiZitJhyO/OqeCnAge840Sp2s7ojzbRGuB67K5Mpg7UiErH0PpcGcSbHxTyffVQyc
	 7skL8kk+ci0+ueKnPPFr6Stej69Kdl8vblbB13gUUTlf1KVjxi7n6rdPPZr8vUHTuJ
	 U56HHN7o7C0h9eMt0CuM7M3TyByeBry8PSnDJvXjyTOcVfGertQXU1h/ppmGqEVTgN
	 ywCzX/ElCuURW8HyW5+8+Php22yIf7uttVW4iG103pdBHg1vv3TYIjwzoL4lEK1OyZ
	 Mn+21BYoVfupRUvx+p9dxUIhWbpONFOpNVChANwG6fLFSVzsJflRYI4rxv+bzQPiww
	 5GBggSZlA+wqQ==
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-7383cdb7800so3065134137.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 04:29:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Ros5VvxlbmcZTAzMNnw0cIHukmc2IAu3ufzH/MtOoUqwX08o/vD8qwO1oxZf0zR7I/SngoCZxHbPA==@kvack.org
X-Gm-Message-State: AOJu0YzKHnyENhY7eDrH6yNzyAgjDMEydBsyrSYTKGriVtGtDQhwcG2O
	vISO/leImR0eU+YzCYVJNcIeX9Zsh4ANgjP4kP+Gs3HT9ifhWEPD904gFG5Xb57YURP3rRsHlUV
	UodxdwzmaSA7X/6xN5BXUl7h6FPcUewM=
X-Received: by 2002:a05:6102:560f:b0:744:a77a:a342 with SMTP id
 ada2fe7eead31-744b7f1d365mr2457244137.22.1783423785493; Tue, 07 Jul 2026
 04:29:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260624075700.751467-1-alex@ghiti.fr> <CAGsJ_4xM=WnFO-OuwVude-DQ_UkaCi_zF_bXBP9Li5+ZPNy0VQ@mail.gmail.com>
 <CAKEwX=Oew86XUYYT49MWo27DnbEpZCnPn7+Kc-uQvavHBpf9XQ@mail.gmail.com>
In-Reply-To: <CAKEwX=Oew86XUYYT49MWo27DnbEpZCnPn7+Kc-uQvavHBpf9XQ@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 7 Jul 2026 19:29:33 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xi1pYS+r4Oae=B1t7ANnHptb1+nBkrSY_zcqEeCdf=sw@mail.gmail.com>
X-Gm-Features: AVVi8Cei_4Juc_b6wqCse91dJbRUadaheneap8ksIE0yRNOD_9TYgiiqWfQGQDY
Message-ID: <CAGsJ_4xi1pYS+r4Oae=B1t7ANnHptb1+nBkrSY_zcqEeCdf=sw@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: bypass swap readahead for zswap
To: Nhat Pham <nphamcs@gmail.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, akpm@linux-foundation.org, hannes@cmpxchg.org, 
	yosry@kernel.org, chengming.zhou@linux.dev, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, kasong@tencent.com, chrisl@kernel.org, usama.arif@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: rdza3ps4dzc318imq6j64db16b7qpgdz
X-Rspamd-Queue-Id: A88F210000F
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783423787-694578
X-HE-Meta: U2FsdGVkX1+Ld/hUNrTPaCjBn2XyEBGAIA3Ckx9+tDU45BuVNiTPi2U5n9utgD6o+n0xHwX+gtPbPCWbqD36WqWsi5AvDnr/X71mV9JDjjEKD1EOohhIoWWPM3Wiieycj+tAJjKBdlFHmdEd+Drs1QuknPJVLXrbnMGsxgegc2Wm+BMzoey7QlApPqc1+I8NO8ayvHpUWKwlwAATMaDE7KzNJzmzplJcjqcurQlL9ZHeKYPTtOf5oWbS5CWZ3u1TXR9j8zSKVD/LJ/wqGV8qeJtyis9HuP7DlqecXjqgOuGQ9Uu8qMhdRYqwWFL+GVvhf5muaFxp+IxYqOBG6QNSg6WAtABQWpfjxnN5Wmbfne8clRSdSU+bb+L3wxW6iZwfnqdLZhCMCXi2GL/PCTgn0rPqxVpM9dBQKXgj+Y4p+DYx0e+QwDHp90uGrAE6zvmnmbOEMwzU2/ykhVjprjHz4g+e+dz5Ekt1Ys2wTtbZjk0A2YPlhuQ2xJV/PVU2IJvgJml8jIqcybsZ42hUWnXd8vilnjS4rm0zrFXjR5xOher+0EExPo0H2e7G8wNYPHUrdD7XtNY5qFIDub6tC/SHcpws8ZyaPDnEIBRX0PKtK7WAxtbvDqx/uMQe7k0GvTdjjQ+uFhDMIb0/jhFfg0DX95mj4AQVMhCltd9M36MXoKwyv0wPBpYlI19EVGSOZIuo/G+ksYM7KdcD9xwwtSXSDK+UNpGm3fbhqscE0iOK5Y8nylVlNguZkkSuehz9Ys+sTMQmEsqstjVD+o+Cg6d8yQbz+MMYbIkakC6sB9nCZfrGCFfPB9/u5H+qPQoLrjAN6brLBZ5AU7A5X4YN6LxiD7oN+hra+QqEHxaqdRyAIZrPbwcAr33ZN8JAmjktbfLbHAcbP1KHTPvP2QXEPTkxBPHeDz6H10kSsch/NcaUg0lc0hONXxW4F2539HkZsdDjr1x6G0USVPZsMiZoMAn
 hLBqQPiB
 pFBZt3fl+j2KDToZPv4Pt7eFd1cAlQZg+LVItZEpPvTpY2gpnHiqu24wPlnbLZeVIz7pNV0cMyq8aSTLcAADPTuyD8rbSuRuIWSC+v26jgPjLwv5qrnGUYG5JxIm0qkGxLCAOtDjUz5Y84SSKRWCIeANlo4Fmzv6hj9avG2ABlZq/591e6XuEjxWjlnOcn3MsqKeL7y8YVVzkYWzR1AEy4F4NYTekkWP/WVsN4ZY2z3o8eOEbdcazaN7Vb0yKbXfVVPGaehkqVYi/bXiR/Gsljenzhbt+kYXI7FKF3ht3vMsbgOhiCZu4IK4Xmd6IOlK3mnih0O4KNiNIRkQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 12:39=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> On Wed, Jun 24, 2026 at 12:24=E2=80=AFPM Barry Song <baohua@kernel.org> w=
rote:
> >
> > Basically, I have been seeing the same issue recently. If the
> > readahead swap entries are also in zswap, we end up doing the
> > decompression during one page fault, but then need another page fault
> > to fetch the page from the swap cache and install the mapping. In that
> > case, readahead may not be beneficial.
>
> You're playing with zswap? Nice :)

Hi Nhat,

Sorry for the late reply. I've been quite busy recently.
I used to work on zswap when I was in the server industry. These days, I
still play with it from time to time, mostly for fun.

>
> It does feel like we're leaving some obvious wins on the table with
> zswap here, so any ideas are much appreciated :)

For my part, I'm not against either zram or zswap. They both play
important roles in their respective domains. :-)

>
> >
> > On the other hand, if the readahead swap entries are not in zswap, the
> > situation is different.
> >
> > For example, suppose we fault on the swap entry for address 1 MB and
> > readahead brings in the entry for 1 MB + 4 KB. If both entries are in
> > zswap, readahead does not seem like a good trade-off. However, if the
> > 1 MB + 4 KB entry is not in zswap and would otherwise require storage
> > I/O, then readahead can be beneficial.
>
> Yeah I can see the edge case you and Yosry brought up here. As we move
> towards supporting multiple swap backends in the same system, that can
> certainly happen. I'm hoping that locality will bail us out - pages
> close together in virtual address space hopefully have similar
> lifetime, access temperature, compressibility, and will go to the same
> swap backend, etc. - but who knows :)
>
> What if we still follow the readahead logic, but at each slot in the
> readahead window, we check if the entry is owned by zswap or is of a
> sync-io devices, in which case we skip the readahead...?

That sounds fine to me. I'm just not sure how complex the code would
be. Would the readahead path need to check whether folios are in zswap
or not? That sounds like a pain.

>
> That way, we will still submit the IO work, but spare the ones that
> require synchronous decompression work, which might affect latency...?

Yes, but it seems like it could get quite complex. So I'm fine with
either the current approach in this patch, or simply disabling
readahead once we're sure we're using zswap, without even checking
whether the current swap-in is coming from zswap.

>
> >
> > So I implemented a rather ugly fault_around-like mechanism in
> > do_swap_page(). At least with page-cluster =3D=3D 1, I am seeing a
> > performance improvement, as the readahead folios can be mapped
> > directly and do not require a second page fault.
>
> Hmm so what your proposal buys us is, if we're already doing readahead
> (synchronously), might as well install the pages in the window into
> the page tables? :)

Yes, because it avoids another page fault. Handling two pages in a
single page fault is faster than handling two separate page faults,
each faulting in one page. Since we've already read the data out
synchronously, we don't want to fault on it again. The downside is
that it increases the complexity of do_swap_page().

I'm not even trying to sell my approach=E2=80=94I did it just for fun.
do_swap_page() is already quite complex, and my fault-around
implementation only makes it more complicated. So I don't really want
to push for it to be merged upstream. I think it will become much more
attractive once we have hardware-assisted decompression in
do_swap_page(), where we no longer spend CPU cycles on
decompression.

>
> Could you explain to me how does this improve performance? If the
> pages are needed, we are transferring some work from future page
> faults to the current page fault. If the pages are not needed, then we
> are just wasting cycles right?

Yep. I'm only seeing improvements with page-cluster=3D1, which uses a
small readahead window. For page-cluster > 2, I'm seeing performance
regressions on workloads such as kernel builds. On the other hand, a
larger page-cluster provides a bigger benefit for sequential swap-ins.
So it's not a universal win.

>
> >
> > It is admittedly quite ugly and is only meant as a proof of concept :-)
>
> Dw, arguably it's easier to reason about with everything open-coded ;)

Thanks for your kind words.

Best Regards
Barry

