Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D92C6D1BDD6
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 20:03:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A0F76B0010; Wed,  3 Dec 2025 15:03:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 252196B0022; Wed,  3 Dec 2025 15:03:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 119C66B0023; Wed,  3 Dec 2025 15:03:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ED77D6B0010
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 15:03:06 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D2FF1C0762
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 20:03:02 +0000 (UTC)
X-FDA: 84179233404.22.2DEE77F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id D89F9120019
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 20:03:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kFPh0oDw;
	spf=pass (imf29.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764792180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/POvIGdLxYSPZ+kE+DlLWmWYUwJGp2ZWEu9uE+7YbuA=;
	b=K/eHBdMohj0axQUvfhncvkHWK50vvjwB0HeUn7iqu6+vrK2f34jCw16S6kdHM5xf++amiZ
	hisTgPUmlGlflEFbCkTiQtwwdk8UYoDwFgCmwi1k/j9y2k/I5nQ0mAddCuFQJG6XsuPldK
	su3E2uD5cUDMu3t/drAY3MAgNmxQPSs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kFPh0oDw;
	spf=pass (imf29.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764792180; a=rsa-sha256;
	cv=none;
	b=Xm5QW+97YlG8CLyGODxHVeIIL5lDKBGVHNoI+edkvVm1v5+UnVm+3R0eycGuzrzxTUQ1pj
	DxCZfqtkV2qM3d7rXz9qDEZ/vE96CA4uy1aaIPv6H0XgmvglJVD07mnCRUOiajBdQto/AY
	yBntYu1kSFJ/P7jvjxR070DwivZ2ADM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E6ED60125
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 20:03:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21B2C4CEF5
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 20:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764792179;
	bh=zYwe0xCTZ2W7hA3cLYQ9QmyDo2quSAFHfHUgpeoxydc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=kFPh0oDweczMpVOqsoJ+L0QxG0rnGm2j9Ea7OSGyezdtKnL+VG5odroIsZj7GZp+e
	 Ge50y6mOocuSBSaCcm2xPqxw20NUc19xXgONQ8fbq7v9cx+n012ux/886e2Sx6gz7J
	 xV91JPfvLn3V2jKyyCdyV2G+PQEmb4IR70UEPFIgSY4RZX29w/TFvYo5ECjCXup2a+
	 n31qtUk86ThtrNHXLVco111QObm+U1unMVP43Vl2ADMC7a12X+nrxZRYi06MDfsY0s
	 9tazTOARsGoAzI43mbJlF71E/3NyD3GChth39FjzFOl3tQpKgZLq59nYYG8MPWv4YK
	 QRsjKKErimS3w==
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-640daf41b19so408350d50.0
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 12:02:59 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUS8C8TAFUEn6VxVe2eeuJIlic93S3bWNtgPxXYT1XcA1QDhg0O4YVr1gGj1N4/sPinkHvEl869kQ==@kvack.org
X-Gm-Message-State: AOJu0YyM1uM7lY7M5IZDT+u+XrqKpX99oXmtH4P1tgMFPRAjEKnQqEXy
	eHUA/PRfze8d/C2CRL2jY846r5o2t9pATKExlXTMIj37WZ4fvBomTUt5BAxy3iGikC8kxRRVxNq
	TLBRCxIOYPePSgsdl/bNaCpQf/9rvy6PbzYVB/GXzgw==
X-Google-Smtp-Source: AGHT+IEl4T7/NFo2J5AN+fJvvoxpqRvB5CfFxCMA0EzzJ5FYOCQWRYH4mqhDRUpFQ3wVU874l5HtwD7y8mqudSOMwSk=
X-Received: by 2002:a05:690e:d06:b0:644:39e0:43e0 with SMTP id
 956f58d0204a3-6443d6f0f48mr574383d50.14.1764792179070; Wed, 03 Dec 2025
 12:02:59 -0800 (PST)
MIME-Version: 1.0
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org> <gkbiqbml5ikvmqybklyzsff46gemhtczm374f4qx54y5glagru@elgd2tfmoezt>
In-Reply-To: <gkbiqbml5ikvmqybklyzsff46gemhtczm374f4qx54y5glagru@elgd2tfmoezt>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 4 Dec 2025 00:02:47 +0400
X-Gmail-Original-Message-ID: <CACePvbX=5m5VuXN2V2_DB1sbNw+tEu=BKBxnuEXmY0V+hQS2_w@mail.gmail.com>
X-Gm-Features: AWmQ_bm3aGMBDdtr40K84F6HwQfvqKcoDa_jcN4EVCh9OaBcdc1Jl2Pa16Sz_KQ
Message-ID: <CACePvbX=5m5VuXN2V2_DB1sbNw+tEu=BKBxnuEXmY0V+hQS2_w@mail.gmail.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	pratmal@google.com, sweettea@google.com, gthelen@google.com, 
	weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: pgtfq3jfskjz4t3mgjp8p88mt3yaitq3
X-Rspam-User: 
X-Rspamd-Queue-Id: D89F9120019
X-Rspamd-Server: rspam09
X-HE-Tag: 1764792180-772414
X-HE-Meta: U2FsdGVkX1/fPRqrhJvARD+rs9HWP/Y4Rz+vn1ymTOYC21yw2/nQP9/vAesuGOJo2b/n+snzYs5e90gkaYIUZoCMkTPewxSL8HO888NsD1PQao5oRey/6zEOFy1MCz4GtyL1qAsy3O546nv4IUqE9hj0a7RpMb3cv2dXgB/DILyWHq7vE0AmuPMj9A91ydN646kpyfXImTmsgoJ//hUVVbOwDKtDwkIzkme0754Jc4m9fveOG4Hl2w17dDoE9mFFtRGr0P8EMT1eNFK8+wYXEV7qHv7E6tHuMbI6wTJH11js4sIiZc0L0a+EKlZmo9/jZ1XFMIkeDJ6c+vnVA3rOZZ/GN4kD8SslElLpHQz7x1DMym6sCW5ymKxrMIA9IMOmCXphNOcCAtEg++6/eLT36Bum2Ij3dNtwm+QtBdGOxDZPbH74pnbtMG0cow7MzbWeon3IX0UA0GiE5J4zyP0a88iLl6ag0qrTRhXyDQd649z9PmlQlgyBj64nARi95NyrsroQJ/rD5dPX1kk/jBl30QAlSEhbS/Brbt4vn6Qlkw7u0eIqsjulvcj5B241JjaDfiI0VvDBuZpnGtAztu/fIXR85YqKPxcWcoZvx5wcZD/6m3KpEBpHaw/XB2fsY6PzYY4s6TxJSdyfQg50mfR1qUXp9UQwpPuKD+lB4YDqI+ikfNq2A7daiO7J1SoJ1gfBFe1PLTZGq3NwOEUfSyK5+jaPkEetkIAPjXa4YWXDHXFeoR+S+w2EwsX9vVCqyC3/VngveLo2NgknklM6c8nlR3dgyQxDKd8F0/ETUpaWA+XvR0eO/dbBP4PsILuzzB1NUPJbtqt4g4MzyN/JECxLZ0kWkPmhg9uFbFVtgc/9nWw+ye5/O6Qja5fez/RG9TU1U4DW80dJ/mN0TcqnuBugm7CPzLWfUaABiGJKjb7CbvZqrSOl3xCSfvmCWyd9pG2dbAxkERKXncYgje6r9cA
 0QrguQ3C
 o1SozshefJ3errF1iOS7facejFdbJG1I4VFv6MXPjJ60PVfyHyb0sZ0b0uSLUiZwg4jLvD0OSqMhsUEu1PiDIFPU1moHxLalxAqkaIEtkOej1J9Fmv5H3NitutLoa5xwt97dFuA0DwkJUE2E/Iua1Bgez+DEo9tm7Ok8x1V+8nzMmaf4jmKi9Xm1CWwmV2S/zBDz88yjb5Q7cCYqUqFn0umfsbHQlZvsFA2UsXJmY9ijDkcnTKzJ0dBdAdSg60zPhg35CZSHhReXAnY1fFBF+HeANk8+bAgHmAmXGo/442iTpQpYah9NmXC/3PQB+8cEBA53tGnQVMl5D2afWx3UUPZ0JY8/jnOtTbejAg+vrA/h0sy8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 3, 2025 at 12:37=E2=80=AFPM Yosry Ahmed <yosry.ahmed@linux.dev>=
 wrote:
>
> On Fri, Nov 21, 2025 at 01:31:43AM -0800, Chris Li wrote:
> > The current zswap requires a backing swapfile. The swap slot used
> > by zswap is not able to be used by the swapfile. That waste swapfile
> > space.
> >
> > The ghost swapfile is a swapfile that only contains the swapfile header
> > for zswap. The swapfile header indicate the size of the swapfile. There
> > is no swap data section in the ghost swapfile, therefore, no waste of
> > swapfile space.  As such, any write to a ghost swapfile will fail. To
> > prevents accidental read or write of ghost swapfile, bdev of
> > swap_info_struct is set to NULL. Ghost swapfile will also set the SSD
> > flag because there is no rotation disk access when using zswap.
> >
> > The zswap write back has been disabled if all swapfiles in the system
> > are ghost swap files.
> >
> > Signed-off-by: Chris Li <chrisl@kernel.org>
>
> I did not know which subthread to reply to at this point, so I am just
> replying to the main thread. I have been trying to stay out of this for
> various reasons, but I was mentioned a few times and I also think this
> is getting out of hand tbh.

Thanks for saving the discussion.

>
> First of all, I want to clarify that I am not "representing" any entity
> here, I am speaking as an upstream zswap maintainer. Obviously I have
> Google's interests in mind, but I am not representing Google here.

Ack, same here.

> Second, Chris keeps bringing up that the community picked and/or
> strongly favored the swap table approach over virtual swap back in 2023.
> I just want to make it absolutely clear that this was NOT my read of the
> room, and I do not think that the community really made a decision or
> favored any approach back then.

OK. Let's move on from that to our current discussion.

> Third, Chris, please stop trying to force this into a company vs company
> situation. You keep mentioning personal attacks, but you are making this
> personal more than anyone in this thread by taking this approach.

Let me clarify, it is absolutely not my intention to make it company
vs company, that does not fit the description either. Please accept my
apology for that. My original intention is that it is a group of
people sharing the same idea. More like I am against a whole group
(team VS). It is not about which company at all. Round robin N -> 1
intense arguing put me in an uncomfortable situation, feeling
excluded.

On one hand I wish there was someone representing  the group as the
main speaker, that would make the discussion feel more equal, more
inclusive. On the other hand, any perspective is important, it is hard
to require the voice to route through the main speaker. It is hard to
execute in practice. So I give up suggesting that.  I am open for
suggestions on how to make the discussion more inclusive for newcomers
to the existing established group.

> Now with all of that out of the way, I want to try to salvage the
> technical discussion here. Taking several steps back, and

Thank you for driving the discussion back to the technical side. I
really appreciate it.

> oversimplifying a bit: Chris mentioned having a frontend and backend and
> an optional redirection when a page is moved between swap backends. This
> is conceptually the same as the virtual swap proposal.

In my perspective, it is not the same as a virtual swap proposal.
There is some overlap, they both can do redirection.

But they originally aim to solve two different problems. One of the
important goals of the swap table is  to allow continuing mTHP swap
entry when all the space left is not continues. For the rest of the
discusion we call it "continuous mTHP allocator". It allocate
continuous swap entry out of non continues file location.

Let's say you have a 1G swapfile, all full not available slots.
1) free 4 pages at swap offset 1, 3, 5, 7. All discontiguous spaces
add up to 16K.
2) Now allocate one mTHP order 2, 16K in size.
Previous allocator can not be satisfied with this requirement. Because
the 4 empty slots are not contiguous.
Here the redirection and growth of the front swap entry comes in, it
is all part of the consideration all alone, not an afterthought.
This following step will allow allocating 16K continuous swap entries
out of offset [1,3,5,7]
3) We grow the front end part of the swapfile, effectively bump up the
max size and add a new cluster of order 2, with a swap table.
That is where the front end of the swap and back end file store comes in.

BTW, Please don't accuse me copy cat the name "virtual swapfile". I
introduce it here 1/8/2025 before Nhat does:
https://lore.kernel.org/linux-mm/CACePvbX76veOLK82X-_dhOAa52n0OXA1GsFf3uv9a=
suArpoYLw@mail.gmail.com/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3Dquote=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
I think we need to have a separation of the swap cache and the backing
of IO of the swap file. I call it the "virtual swapfile".
It is virtual in two aspect:
1) There is an up front size at swap on, but no up front allocation of
the vmalloc array. The array grows as needed.
2) There is a virtual to physical swap entry mapping. The cost is 4
bytes per swap entry. But it will solve a lot of problems all
together.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3Dquote ends =3D=3D=3D=3D=3D=3D=3D=
=3D=3D
Side story:
I want to pass the "virtual swapfile"  for Kairui to propose as LSF
topic. Coincidentally  Nhat proposes the virtual swap as a LSF topic
at 1/16/2025, a few days after I mention "virtual swapfile" in the lsf
topic related discussion. It is right before Kairui purpose "virtual
swapfile". Kairui renamed our version as "swap table". That is the
history behind the name of "swap table".
https://lore.kernel.org/linux-mm/20250116092254.204549-1-nphamcs@gmail.com/

I am sure Nhat did not see that email and come up with it
independently, coincidentally. I just want to establish that I have
prior art introducing the name "virtual swapfile" before Nhat's LSF
"virtual swap" topic. After all, it is just a name. I am just as happy
using "swap table".

To avoid confuse the reader I will call my version of "virtual swap"
the "front end".

The front end owns the cluster and swap table (swap cache). 8 bytes.
The back end only contain file position pointer. 4 bytes.

4) The back end will need different allocate because the allocating
assumption is different, it does not have alignment requirement. It
just need to track which block location is available.
It will need to have a back end specific allocator.  It only manage
the location of the swapfile cannot allocate from fronted. e.g.
redirection entry create a hole. or the new cluster added from step 3.

5) the backend location pointer is optional of the cluster. For the
cluster new allocated from step, It must have location pointer,
because its offset is out of the backing file range.
That is a 4 byte just like a swap entry.
This backend location pointer can be used by solution like VS as well.
That is part of the consideration as well, so not a after thought.
The allocator mention here is more like a file system design rather
than pure memory location, because it need to consider block location
for combining block level IO.

So the mTHP allocator can do swapfile location redirection. But that
is a side benefit of a different design goal (mTHP allocation). This
physical location pointer description match my 2024 LSF pony talk
slide. I just did not put text in the slide there. So it is not some
thing after thought, it pre-dates back to 2024 talks.

> I think the key difference here is:
> - In Chris's proposal, we start with a swap entry that represents a swap
>   slot in swapfile A. If we do writeback (or swap tiering), we create
>   another swap entry in swapfile B, and have the first swap entry point

Correction. Instead of swapfile B, Backend location in swapfile B. in
step 5). It only 4 byte. The back end does not have swap cache. The
swap cache belong to front end A (8 bytes).

>   to it instead of the slot in swapfile A. If we want to reuse the swap
>   slot in swapfile A, we create a new swap entry that points to it.
>
>   So we start with a swap entry that directly maps to a swap slot, and

Again, in my description swap slot A has a file backend location
pointer points to swapfile B.
It is only the bottom half the swap slot B, not the full swap slot. It
does not have 8 byte swap entry overhead of B.

>   optionally put a redirection there to point to another swap slot for
>   writeback/tiering.

Point to another swapfile location backend, not swap entry.(4 bytes)

>   Everything is a swapfile, even zswap will need to be represented by a
>   separate (ghost) swapfile.

Allow ghost swapfile. I wouldn't go as far saying ban the current
zswap writeback, that part is TBD. My description is enable memory
swap tiers without actual physical file backing. Enable ghost
swapfile.

>
> - In the virtual swap proposal, swap entries are in a completely
>   different space than swap slots. A swap entry points to an arbitrary
>   swap slot (or zswap entry) from the beginning, and writeback (or
>   tiering) does not change that, it only changes what is being pointed
>   to.
>
> Regarding memory overhead (assuming x86_64), Chris's proposal has 8
> bytes per entry in the swap table that is used to hold both the swap
> count as well as the swapcache or shadow entry. Nhat's RFC for virtual
Ack

> swap had 48 bytes of overhead, but that's a PoC of a specific
> implementaiton.

Ack.

> Disregarding any specific implementation, any space optimizations that
> can be applied to the swap table (e.g. combining swap count and
> swapcache in an 8 byte field) can also be applied to virtual swap. The
> only *real* difference is that with virtual swap we need to store the
> swap slot (or zswap entry), while for the current swap table proposal it
> is implied by the index of the entry. That's an additional 8 bytes.

No, the VS has a smaller design scope. VS does not enable "continous
mTHP allocation" . At least that is not mention in any previous VS
material.

> So I think a fully optimized implementation of virtual swap could end up
> with an overhead of 16 bytes per-entry. Everything else (locks,
> rcu_head, etc) can probably be optimized away by using similar
> optimizations as the swap table (e.g. do locking and alloc/freeing in

With the continues mTHP allocator mention above, it already has the
all things VS needed.
I am not sure we still need VS if we have "continues mTHP allocator",
that is TBD.

Yes, VS can reuse the physical location pointer by "continues mTHP allocato=
r".

The overhead is for above swap table of redirection is 12 bytes not 16 byte=
s.

> batches). In fact, I think we can use the swap table as the allocator in
> the virtual swap space, reusing all the locking and allocation

That is my feel all alone. Let swap table manage that.

> optimizations. The difference would be that the swap table is indexed by
> the virtual swap ID rather than the swap slot index.

 In the "continous mTHP allocator" it is just physical location pointer,

> Another important aspect here, in the simple case the swap table does
> have lower overhead than virtual swap (8 bytes vs 16 bytes). Although
> the difference isn't large to begin with, I don't think it's always the
> case. I think this is only true for the simple case of having a swapped
> out page on a disk swapfile or in a zswap (ghost) swapfile.

Please redo your evaluation after reading the above "continuous mTHP alloct=
or".

> Once a page is written back from zswap to disk swapfile, in the swap
> table approach we'll have two swap table entries. One in the ghost

One one entry with back end location pointer. (12 byte)

> swapfile (with a redirection), and one in the disk swapfile. That's 16
> bytes, equal to the overhead of virtual swap.

Again 12 bytes using "continues mTHP allocator" frame work.

> Now imagine a scenario where we have zswap, SSD, and HDD swapfiles with
> tiering. If a page goes to zswap, then SSD, then HDD, we'll end up with
> 3 swap table entries for a single swapped out page. That's 24 bytes. So
> the memory overhead is not really constant, it scales with the number of
> tiers (as opposed to virtual swap).

Nope, Only one front swap entry remain the same, every time it write
to a different tier, it only update the back end physical location
pointer.
It always points to the finial physical location. Only 12 bytes total.

You are paying 24 bytes because you don't have the front end vs back end sp=
lit.
Your redirection includes the front end 8 byte as well. Because you
include the front end, now you need to do the relay forward.
That is the benefit to have front end and back end split of the swap
file. Make it more like a file system design.

> Another scenario is where we have SSD and HDD swapfiles with tiering. If
> a page starts in SSD and goes to HDD, we'll have to swap table entries
> for it (as above). The SSD entry would be wasted (has a redirection),
> but Chris mentioned that we can fix this by allocating another frontend
> cluster that points at the same SSD slot. How does this fit in the

No a fix. It is in the design consideration all alone. When the
redirection happen, that underlying physical block location pointer
will add to the backend allocator. The backend don't overlap with swap
entry location can be allocated from front end.

> 8-byte swap table entry tho? The 8-bytes can only hold the swapcache or
> shadow (and swapcount), but not the swap slot. For the current
> implementation, the slot is implied by the swap table index, but if we
> have separate front end swap tables, then we'll also need to store the
> actual slot.

Please read the above description regarding the front end and back end
split then ask your question again. The "continuous mTHP allocator"
above should answer your question.

> We can workaround this by having different types of clusters and swap
> tables, where "virtual" clusters have 16 bytes instead of 8 bytes per
> entry for that, sure.. but at that point we're at significantly more
> complexity to end up where virtual swap would have put us.

No, that further complicating things. Please don't go there. The front
end and back end location split is design to simplify situation like
this. It is conceptual much cleaner as well.

>
> Chris, Johannes, Nhat -- please correct me if I am wrong here or if I
> missed something. I think the current swap table work by Kairui is

Yes, see the above explanation of the "continuous mTHP allocator".

> great, and we can reuse it for virtual swap (as I mentioned above). But
> I don't think forcing everything to use a swapfile and extending swap
> tables to support indirections and frontend/backend split is the way to
> go (for the reasons described above).

IMHO, it is the way to go if consider mTHP allocating. You have
different assumption than mine in my design, I correct your
description as much as I can above. I am interested in your opinion
after read the above description of "continuous mTHP allocator", which
is match the 2024 LSF talk slide regarding swap cache redirecting
physical locations.

Chris

