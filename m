Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AD9CEB26FF
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 19:11:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97BD36B0088; Tue, 10 Feb 2026 14:11:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92A436B0089; Tue, 10 Feb 2026 14:11:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FE276B008A; Tue, 10 Feb 2026 14:11:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6C0856B0088
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 14:11:27 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1F5B413B88A
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 19:11:27 +0000 (UTC)
X-FDA: 84429490614.24.009DBA1
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0851DA000C
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 19:11:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d7kiuwZz;
	spf=pass (imf15.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770750685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lg02zJ+zmG8JzV6FX7AzgYv4xtyX97EATX1939W+INc=;
	b=Cdnrpk2CsBps0/G/vY69W4QZjNQPF89uhadeJj8UeKbAQTAzdmV6Ojay6MGk0lc0Mtu/t5
	G/O10LjS2rpN8g0z59FA5fx5J7COyhzDa05svI+wIlqxPvAO5wwBKb2WdgzikJgJXu3fUx
	gg+fPAyVTOJjopEc8wJZye5Nuk5Ef6c=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d7kiuwZz;
	spf=pass (imf15.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770750685; a=rsa-sha256;
	cv=pass;
	b=hLILU9t9aWk7ibUuj4q3cLJ+ziqnsgwWX2ji6SOmRUyF4pR2UQTOhBycvp6+cyPTPcwZkv
	eCJqg/Se5odNMllx4hhfdu+SHYcAq+/ZC+SDCa0g9GasHRd4dCK6ZjbbNCNtwYPfZR3UuS
	ViSt3dYggTszS1CUTIflEK3QHxqLuF0=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-481188b7760so42744255e9.0
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 11:11:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770750683; cv=none;
        d=google.com; s=arc-20240605;
        b=VeLwBwZpVvrWqarGZEG4959C2GirQdm0G1j+TkVq7movYI6weToc+Rvjs5N5ZVyXPU
         geGNgnWM5Jycc2MCyZdg53+3M02gQg4trwb143wPu4diT0Zk0tItaDL4KRGTK04YF/NH
         0c2SZ05lCoLFXBA8Ou0slSNm5wUL3ER+Ny+NblkUt/+rlKHCaz31czu4405+pUaAYZB5
         St1cPS3R9SFRL110X9oXk/OT+ssF+/HTnHvoZh5WLDQfsyU+7qDckNejUuanx2q6uTFl
         wONjtN7xnHgSDF9XJbhQhJOgeg2jJS9q11p/syyQNUCHznj2d7O+UVdA3F6ZanFGNa9d
         wwzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lg02zJ+zmG8JzV6FX7AzgYv4xtyX97EATX1939W+INc=;
        fh=ABXmZnBdoZTR4yAxk+iKzJ1hvPe/vHvC1K3Uxj2KghI=;
        b=BSra2teWoZ2jWglox3HOU4lQoYdKlgvjtoX/pkdNtlg2VbbruON5zrdMg5r11pdEaU
         lkjSllquCWsWeU2zwrpJO+0zJxCPcfbWgMM+lohYc4km6XNZiaJIGDi1k/ba62xTYugR
         1fWpy27QqxI01vkVu/+B6kpByERzVxHa7bafCMR8IVZbEGs3wjzFyyhcaXqK3c4sEMEc
         +C+Utynv9RIIPus7n1P4q9gnQklgCOKVXHv6DW4lTxXLjE5JJhXaMOkKP0IcqWUAP5Vq
         x8F2vSfn6875dRQFptFkCEpVk/lw6ncoLgo+jcSgCFoSH42tnwDldgMzario92LXB481
         1xrw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770750683; x=1771355483; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lg02zJ+zmG8JzV6FX7AzgYv4xtyX97EATX1939W+INc=;
        b=d7kiuwZzuO7sF68gsvOUTl9fNfIo8OIHtT5bLfWmsW2jcIDxoyWRlzudPz1ehSTR5N
         AygZVDMsU4t4fQQXCSZ7i3P0MK5fFqIMTevhnMPYreRMkD1MGCWQXrG1PHskbkg7UmET
         yZM3OwDLsCtHit5xC9RjyuwIlTVwUQuoEO/lvALw6jUoi0S46iIMnJdB2RDUXkCj0zlT
         HbVGBZscRmRsfa0f7F5jD7QB31L+XvARb6GPEpnZNVUbLx+qBckkabTitHmPBM6UFdrS
         58I2njAizLWtQX1A0QDT/7g4fD8G49DFoXNbNkTvypLQT/c1x4LbFyDUHqLPRjVKyHgg
         Z5UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770750683; x=1771355483;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lg02zJ+zmG8JzV6FX7AzgYv4xtyX97EATX1939W+INc=;
        b=duOg5PQS84n1fz8ahy5ou3McB+WvJ/6kdNc34/Ad6fvqnNYi+iMsJW27/pZAHowQT6
         UrqdjrbAgiZHDUrKTsB54QyEFC4slkHFExV3wdSeqpLa18X7rUCcbxD7JLckRAbbyZuu
         FOw8xKzmmdDIsVyNBget3hsuOcMjzkYnMPM1Hug9OH0GUnT4nACb7udhLyzI7h7LaK0N
         C7ApR71aevS8vNHFit0NEf/kruRfDcMuxCgxUOX3NXvRW4QkGwuD+sfhYdVRxTdNpuWC
         fUMQuH8DznrYeL9CaTgTqem6GN6buf3qAhR3u7CORwDmYvS/SBb7YbhHvy9QfaHTeupo
         DxUw==
X-Gm-Message-State: AOJu0YwlvdbIU1N5Q9neHUHCTJOKVTzvNafvtIrjvZxIQhyOZWxSfc0K
	xKskeI0Uj3osRz+31NofnRnecAG9T88t0s1iApLrUSYOTIVHBc8PUf/lQ0sKDeQBrn4+5XO57FO
	gFBFx/P+NLIXNB5JUGBIwtuOhvRilGCc=
X-Gm-Gg: AZuq6aJ8asDFsR0fbQK1chcgqPqpK5/t04QgJD+LVcwZQWKcbT5s0f6xcyEhS8x/GA8
	nnIDBGyG54tFJAbEsfbjh45B+zSqCDCXuFxSdzHhlWakbk2JRqQmqi3xX8vmQkMfY+CFN6lQrCF
	lxu/WQdHXSlrUChehZshVxkyA25GqYT+APP0fzXZBQcWgKJWks9JL7OOjF1p3mQmIMR8oH+3Zko
	rquJrEtFuwwdv9m+DOIfcp0Io3mbQcJiZqaprV7oSb61p4NSblKkoehxHFFSSboT1Hn4hc8488G
	nSBV5EOe47yCBojL7TGUrkhJkcMfNPVpzVRT4dI=
X-Received: by 2002:a05:600c:348a:b0:480:3ad0:93bf with SMTP id
 5b1f17b1804b1-48320966729mr228687565e9.24.1770750682952; Tue, 10 Feb 2026
 11:11:22 -0800 (PST)
MIME-Version: 1.0
References: <20260208215839.87595-2-nphamcs@gmail.com> <20260208222652.328284-1-nphamcs@gmail.com>
 <CAMgjq7AQNGK-a=AOgvn4-V+zGO21QMbMTVbrYSW_R2oDSLoC+A@mail.gmail.com>
In-Reply-To: <CAMgjq7AQNGK-a=AOgvn4-V+zGO21QMbMTVbrYSW_R2oDSLoC+A@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 10 Feb 2026 11:11:11 -0800
X-Gm-Features: AZwV_QjiOO6j26eMiBTeyevvXh-PkDtsFLmP_Tcm2odsndmNAGBnH1r-vL0qIJ0
Message-ID: <CAKEwX=OUni7PuUqGQUhbMDtErurFN_i=1RgzyQsNXy4LABhXoA@mail.gmail.com>
Subject: Re: [PATCH v3 00/20] Virtual Swap Space
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, hannes@cmpxchg.org, 
	hughd@google.com, yosry.ahmed@linux.dev, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	len.brown@intel.com, chengming.zhou@linux.dev, chrisl@kernel.org, 
	huang.ying.caritas@gmail.com, ryan.roberts@arm.com, shikemeng@huaweicloud.com, 
	viro@zeniv.linux.org.uk, baohua@kernel.org, bhe@redhat.com, osalvador@suse.de, 
	christophe.leroy@csgroup.eu, pavel@kernel.org, kernel-team@meta.com, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-pm@vger.kernel.org, peterx@redhat.com, riel@surriel.com, 
	joshua.hahnjy@gmail.com, npache@redhat.com, gourry@gourry.net, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	rafael@kernel.org, jannh@google.com, pfalcato@suse.de, 
	zhengqi.arch@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0851DA000C
X-Stat-Signature: cjxxdorw7pksh6frb478ctxurzrkwwd5
X-Rspam-User: 
X-HE-Tag: 1770750684-324474
X-HE-Meta: U2FsdGVkX1/hic2aCszX3NhPEL4RgGz3RQ0BTNUMUY483VtonJM3ltmuvZPWlXmbcBu3m1yYkthBONnQw5eJuqFYhv6nHmwCidGXx5PfgV3M1dWVaodcjMWGnmA9jtnVIK45YionCwnblbFb9GIZ/+02tfYS7N0Gl2HXT2dAcrSgZ6ZXtNEq7uS1zwo70tQ4O3RMUJT3nx4hCOxfr0O30tSU0lVim6tYJXAcc+zV+BdtDU3g6YTGzbHuI+9HRB33H9PfQHDwVTdReZEI+xH1qHlOBJIOILikSnHTGZEyMQ2JiKLl43f92zp7spnXSEOapKUNXISm6EXcuzrySYSy1Y7jfC5SISKEeTid/U8IDWftoJFjybMPJaoCDAXZyU1f+bfe9dvNfq73cuLuHfO16WKTf3ZhHHO5WhJrYlHn0TnDEcusI+inZySyJ1uGOmtw+YQq2SnuGnRdIrQONgMpbG2rOk/5qor0AoJEwbr9UP1HBlOstSV5xceA9Ct9nXFP53yJrIe+GxettCmt3DOuKCXL0ZYVJIXKVcUswO4oAeUaHdgJp83eBVEot3tEHua8auahkHpt8SLw2LMM+GTkb5RR1SpxHJ7UmDqtijdj3/bYn95FFzW07GYWXiGZtSbmh3ugwzarEKZE+qVmpvGV9CEeG5CTINmOUWQiC//3F6SLnuj1D27fV8Yw3Y3A9DMeOJK1V30Un1uIGHZLpTWQ+TIwj/0bKkL9rsyXPmaAzIOaRT+b8CQG1KZvdLDOFqR62SyAyvp6c71PaNOHqjXH/6LbKbOwwTW3YluqETJL00zwyfY566cb3XEZMF+rFnFoWIwas5CP1kDmt+D+SuqjqJBBCP+IPYoROydQVUdK0yxMkUXfoD5ycEOX7C+yJLXdteLsQyH6L7nfrCJzeEZW0P78AnF6p3sY6NGvWapO/8Oj2rES5xCZzYJnODgT5efAahJaRTHbdb/DZsLbbI6
 3UBV/nZg
 F4ll7MT7qPYy6FIOx8Mp7w7fHk5Fcsmy7VUWO6EEAoOZlp+VLXbjS0WkTTQG4+c72PT7n3whNZce+9QGoQREEAUSxY/Cu9si4VRL9XIwaLj606lhItp+Pvkel8btVGv6Sk00DJ6bOqOWEYRm49fKAMMkQbsunA27cNZZjuu9g3gLkgUIH8tLAPWFF/zNpot2Mp+8zlrkRKfrfWPb+kKer2a3CA245aWZsz7qBoR1KPy1XvHYIj5f7DmtrDoJB7gfiEJGS3j/BSfvOcCZ66kSvL2+ELwFPIvUw6jQahVQ7AeMr35arDOw8IGLVQvGprekWigfgFcbf8THxpi4wCGHTi7/fzfgSxmh9+flulHest1hV4k2pfLfwzjoBZ0JTJfuLj739t+OKbn5hlTFWibvg+PTfLL+XHtIjd7BqNCdIT6/mWaCbOSjPgc9W82rhVCNolgA9oJ+See+3zb6dJkIT9s4isvvWbxlrYiILezc+LvPSoGLKyPDcmtSbvP3fY1nRwBXLDdQbxfWQ5VtULllMD+fIwg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 10, 2026 at 10:00=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> On Mon, Feb 9, 2026 at 7:57=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
> >
> > Anyway, resending this (in-reply-to patch 1 of the series):
>
> Hi Nhat,
>
> > Changelog:
> > * RFC v2 -> v3:
> >     * Implement a cluster-based allocation algorithm for virtual swap
> >       slots, inspired by Kairui Song and Chris Li's implementation, as
> >       well as Johannes Weiner's suggestions. This eliminates the lock
> >           contention issues on the virtual swap layer.
> >     * Re-use swap table for the reverse mapping.
> >     * Remove CONFIG_VIRTUAL_SWAP.
>
> I really do think we better make this optional, not a replacement or
> mandatory. There are many hard to evaluate effects as this
> fundamentally changes the swap workflow with a lot of behavior changes
> at once. e.g. it seems the folio will be reactivated instead of
> splitted if the physical swap device is fragmented; slot is allocated
> at IO and not at unmap, and maybe many others. Just like zswap is
> optional. Some common workloads would see an obvious performance or
> memory usage regression following this design, see below.

Ideally, if we can close the performance gap and have only one
version, then that would be the best :)

Problem with making it optional, or maintaining effectively two swap
implementations, is that it will make the patch series unreadable and
unreviewable, and the code base unmaintanable :) You'll have x2 the
amount of code to reason about and test, much more merge conflicts at
rebase and cherry-pick time. And any improvement to one version takes
extra work to graft onto the other version.

>
> >     * Reducing the size of the swap descriptor from 48 bytes to 24
> >       bytes, i.e another 50% reduction in memory overhead from v2.
>
> Honestly if you keep reducing that you might just end up
> reimplementing the swap table format :)

There's nothing wrong with that ;)

I like the swap table format (and your cluster-based swap allocator) a
lot. This patch series does not aim to remove that design - I just
want to separate the address space of physical and virtual swaps to
enable new use cases...

>
> > This patch series is based on 6.19. There are a couple more
> > swap-related changes in the mm-stable branch that I would need to
> > coordinate with, but I would like to send this out as an update, to sho=
w
> > that the lock contention issues that plagued earlier versions have been
> > resolved and performance on the kernel build benchmark is now on-par wi=
th
> > baseline. Furthermore, memory overhead has been substantially reduced
> > compared to the last RFC version.
>
> Thanks for the effort!
>
> > * Operationally, static provisioning the swapfile for zswap pose
> >   significant challenges, because the sysadmin has to prescribe how
> >   much swap is needed a priori, for each combination of
> >   (memory size x disk space x workload usage). It is even more
> >   complicated when we take into account the variance of memory
> >   compression, which changes the reclaim dynamics (and as a result,
> >   swap space size requirement). The problem is further exarcebated for
> >   users who rely on swap utilization (and exhaustion) as an OOM signal.
>
> So I thought about it again, this one seems not to be an issue. In

I mean, it is a real production issue :) We have a variety of server
machines and services. Each of the former has its own memory and drive
size. Each of the latter has its own access characteristics,
compressibility, latency tolerance (and hence would prefer a different
swapping solutions - zswap, disk swap, zswap x disk swap). Coupled
with the fact that now multiple services can cooccur on one host, and
one services can be deployed on different kinds of hosts, statically
sizing the swapfile becomes operationally impossible and leaves a lot
of wins on the table. So swap space has to be dynamic.


> most cases, having a 1:1 virtual swap setup is enough, and very soon
> the static overhead will be really trivial. There won't even be any
> fragmentation issue either, since if the physical memory size is
> identical to swap space, then you can always find a matching part. And
> besides, dynamic growth of swap files is actually very doable and
> useful, that will make physical swap files adjustable at runtime, so
> users won't need to waste a swap type id to extend physical swap
> space.

By "dynamic growth of swap files", do you mean dynamically adjusting
the size of the swapfile? then that capacity does not exist right now,
and I don't see a good design laid out for it... At the very least,
the swap allocator needs to be dynamic in nature. I assume it's going
to look something very similar to vswap's current attempt, which
relies on a tree structure (radix tree i.e xarray). Sounds familiar?
;)

I feel like each of the problem I mention in this cover letter can be
solved partially with some amount of hacks, but none of them will
solve it all. And once you slaps all the hacks together, you just get
virtual swap, potentially shoved within specific backend codebase
(zswap or zram). That's not... ideal.

>
> > * Another motivation is to simplify swapoff, which is both complicated
> >   and expensive in the current design, precisely because we are storing
> >   an encoding of the backend positional information in the page table,
> >   and thus requires a full page table walk to remove these references.
>
> The swapoff here is not really a clean swapoff, minor faults will
> still be triggered afterwards, and metadata is not released. So this
> new swapoff cannot really guarantee the same performance as the old
> swapoff. And on the other hand we can already just read everything
> into the swap cache then ignore the page table walk with the older
> design too, that's just not a clean swapoff.

I don't understand your point regarding the "reading everything into
swap cache". Yes, you can do that, but you would still lock the swap
device in place, because the page table entries still refer to slots
on the physical swap device - you cannot free the swap device, nor
space on disk, not even the swapfile's metadata (especially since the
swap cache is now intertwined with the physical swap layer).

>
> > struct swp_desc {
> >         union {
> >                 swp_slot_t         slot;                 /*     0     8=
 */
> >                 struct zswap_entry * zswap_entry;        /*     0     8=
 */
> >         };                                               /*     0     8=
 */
> >         union {
> >                 struct folio *     swap_cache;           /*     8     8=
 */
> >                 void *             shadow;               /*     8     8=
 */
> >         };                                               /*     8     8=
 */
> >         unsigned int               swap_count;           /*    16     4=
 */
> >         unsigned short             memcgid:16;           /*    20: 0  2=
 */
> >         bool                       in_swapcache:1;       /*    22: 0  1=
 */
>
> A standalone bit for swapcache looks like the old SWAP_HAS_CACHE that
> causes many issues...

Yeah this was based on 6.19, which did not have your swap cache change yet =
:)

I have taken a look at your latest swap table work in mm-stable, and I
think most of that can conceptually incorporated in to this line of
work as well.

Chiefly, the new swap cache synchronization scheme (i.e whoever puts
the folio in swap cache first gets exclusive rights) still works in
virtual swap world (and hence, the removal of swap cache pin, which is
one bit in the virtual swap descriptor).

Similarly, do you think we cannot hold the folio lock in place of the
cluster lock in the virtual swap world? Same for a lot of the memory
overhead reduction tricks (such as using shadow for cgroup id instead
of a separate swap_cgroup unsigned short field). I think comparing the
two this way is a bit apples-to-oranges (especially given the new
features enabled by vswap).

[...]

> That 3 - 4 times more memory usage, quite a trade off. With a
> 128G device, which is not something rare, it would be 1G of memory.
> Swap table p3 / p4 is about 320M / 256M, and we do have a way to cut
> that down close to be <1 byte or 3 byte per page with swap table
> compaction, which was discussed in LSFMM last year, or even 1 bit
> which was once suggested by Baolin, that would make it much smaller
> down to <24MB (This is just an idea for now, but the compaction is
> very doable as we already have "LRU"s for swap clusters in swap
> allocator).
>
> I don't think it looks good as a mandatory overhead. We do have a huge
> user base of swap over many different kinds of devices, it was not
> long ago two new kernel bugzilla issue  or bug reported was sent to
> the maillist about swap over disk, and I'm still trying to investigate
> one of them which seems to be actually a page LRU issue and not swap
> problem..  OK a little off topic, anyway, I'm not saying that we don't
> want more features, as I mentioned above, it would be better if this
> can be optional and minimal. See more test info below.

Side note - I might have missed this. If it's still ongoing, would
love to help debug this :)

>
> > We actually see a slight improvement in systime (by 1.5%) :) This is
> > likely because we no longer have to perform swap charging for zswap
> > entries, and virtual swap allocator is simpler than that of physical
> > swap.
>
> Congrats! Yeah, I guess that's because vswap has a smaller lock scope
> than zswap with a reduced callpath?

Ah yeah that too. I neglected to mention this, but with vswap you can
merge several swap operations in zswap code path and no longer have to
release-then-reacquire the swap locks, since zswap entries live in the
same lock scope as swap cache entries.

It's more of a side note either way, because my main goal with this
patch series is to enable new features. Getting a performance win is
always nice of course :)

>
> >
> > Using SSD swap as the backend:
> >
> > Baseline:
> > real: mean: 200.3s, stdev: 2.33s
> > sys: mean: 489.88s, stdev: 9.62s
> >
> > Vswap:
> > real: mean: 201.47s, stdev: 2.98s
> > sys: mean: 487.36s, stdev: 5.53s
> >
> > The performance is neck-to-neck.
>
> Thanks for the bench, but please also test with global pressure too.

Do you mean using memory to the point where it triggered the global waterma=
rks?

> One mistake I made when working on the prototype of swap tables was
> only focusing on cgroup memory pressure, which is really not how
> everyone uses Linux, and that's why I reworked it for a long time to
> tweak the RCU allocation / freeing of swap table pages so there won't
> be any regression even for lowend and global pressure. That's kind of
> critical for devices like Android.
>
> I did an overnight bench on this with global pressure, comparing to
> mainline 6.19 and swap table p3 (I do include such test for each swap
> table serie, p2 / p3 is close so I just rebase and latest p3 on top of
> your base commit just to be fair and that's easier for me too) and it
> doesn't look that good.
>
> Test machine setup for vm-scalability:
> # lscpu | grep "Model name"
> Model name:          AMD EPYC 7K62 48-Core Processor
>
> # free -m
>               total        used        free      shared  buff/cache   ava=
ilable
> Mem:          31582         909       26388           8        4284      =
 29989
> Swap:         40959          41       40918
>
> The swap setup follows the recommendation from Huang
> (https://lore.kernel.org/linux-mm/87ed474kvx.fsf@yhuang6-desk2.ccr.corp.i=
ntel.com/).
>
> Test (average of 18 test run):
> vm-scalability/usemem --init-time -O -y -x -n 1 56G
>
> 6.19:
> Throughput: 618.49 MB/s (stdev 31.3)
> Free latency: 5754780.50us (stdev 69542.7)
>
> swap-table-p3 (3.8%, 0.5% better):
> Throughput: 642.02 MB/s (stdev 25.1)
> Free latency: 5728544.16us (stdev 48592.51)
>
> vswap (3.2%, 244% worse):
> Throughput: 598.67 MB/s (stdev 25.1)
> Free latency: 13987175.66us (stdev 125148.57)
>
> That's a huge regression with freeing. I have a vm-scatiliby test
> matrix, not every setup has such significant >200% regression, but on
> average the freeing time is about at least 15 - 50% slower (for
> example /data/vm-scalability/usemem --init-time -O -y -x -n 32 1536M
> the regression is about 2583221.62us vs 2153735.59us). Throughput is
> all lower too.
>
> Freeing is important as it was causing many problems before, it's the
> reason why we had a swap slot freeing cache years ago (and later we
> removed that since the freeing cache causes more problems and swap
> allocator already improved it better than having the cache). People
> even tried to optimize that:
> https://lore.kernel.org/linux-mm/20250909065349.574894-1-liulei.rjpt@vivo=
.com/
> (This seems a already fixed downstream issue, solved by swap allocator
> or swap table). Some workloads might amplify the free latency greatly
> and cause serious lags as shown above.
>
> Another thing I personally cares about is how swap works on my daily
> laptop :), building the kernel in a 2G test VM using NVME as swap,
> which is a very practical workload I do everyday, the result is also
> not good (average of 8 test run, make -j12):

Hmm this one I don't think I can reproduce without your laptop ;)

Jokes aside, I did try to run the kernel build with disk swapping, and
the performance is on par with baseline. Swap performance with NVME
swap tends to be dominated by IO work in my experiments. Do you think
I missed something here? Maybe it's the concurrency difference (since
I always run with -j$(nproc), i.e the number of workers =3D=3D the number
of processors).

> #free -m
>                total        used        free      shared  buff/cache   av=
ailable
> Mem:            1465         216        1026           0         300     =
   1248
> Swap:           4095          36        4059
>
> 6.19 systime:
> 109.6s
> swap-table p3:
> 108.9s
> vswap systime:
> 118.7s
>
> On a build server, it's also slower (make -j48 with 4G memory VM and
> NVME swap, average of 10 testrun):
> # free -m
>                total        used        free      shared  buff/cache   av=
ailable
> Mem:            3877        1444        2019         737        1376     =
   2432
> Swap:          32767        1886       30881
>
> # lscpu | grep "Model name"
> Model name:                              Intel(R) Xeon(R) Platinum
> 8255C CPU @ 2.50GHz
>
> 6.19 systime:
> 435.601s
> swap-table p3:
> 432.793s
> vswap systime:
> 455.652s
>
> In conclusion it's about 4.3 - 8.3% slower for common workloads under
> global pressure, and there is a up to 200% regression on freeing. ZRAM
> shows an even larger workload regression but I'll skip that part since
> your series is focusing on zswap now. Redis is also ~20% slower
> compared to mm-stable (327515.00 RPS vs 405827.81 RPS), that's mostly
> due to swap-table-p2 in mm-stable so I didn't do further comparisons.

I'll see if I can reproduce the issues! I'll start with usemem one
first, as that seems easier to reproduce...

>
> So if that's not a bug with this series, I think the double free or

It could be a non-crashing bug that subtly regresses certain swap
operations, but yeah let me study your test case first!

> decoupling of swap / underlying slots might be the problem with the
> freeing regression shown above. That's really a serious issue, and the
> global pressure might be a critical issue too as the metadata is much
> larger, and is already causing regressions for very common workloads.
> Low end users could hit the min watermark easily and could have
> serious jitters or allocation failures.
>
> That's part of the issue I've found, so I really do think we need a
> flexible way to implementa that and not have a mandatory layer. After
> swap table P4 we should be able to figure out a way to fit all needs,
> with a clean defined set of swap API, metadata and layers, as was
> discussed at LSFMM last year.

