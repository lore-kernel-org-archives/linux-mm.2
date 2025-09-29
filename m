Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EAB9CAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 05:30:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D2448E0003; Mon, 29 Sep 2025 01:30:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6836D8E0002; Mon, 29 Sep 2025 01:30:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54A9E8E0003; Mon, 29 Sep 2025 01:30:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 397DA8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:30:51 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AE1C7B7D3E
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 05:30:50 +0000 (UTC)
X-FDA: 83941163460.01.F1801A2
Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	by imf04.hostedemail.com (Postfix) with ESMTP id C90F44000A
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 05:30:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=EkThpBh3;
	spf=pass (imf04.hostedemail.com: domain of jthoughton@google.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759123848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H6RpQue8OwKA5zQcpcRYCFi/JKqNnjRsrmsTTJodjmk=;
	b=FpW46zMvlYTcVPYKaAQeWrMu3r3KEJ9OIS2vxGYvH061s1vm6+TxNZw5vNL7lCwUSn6dfx
	ga8aL6laP0AX6rPo6mS8rGxBSdCMEhcRnWGCByIpnsfN9sOfDbvNj2tlMjFA31NqeFksco
	XADh/E6iUL33eJV4dZBhUL6606c0Wsw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=EkThpBh3;
	spf=pass (imf04.hostedemail.com: domain of jthoughton@google.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759123848; a=rsa-sha256;
	cv=none;
	b=irrAiiFqveuhKLZ7MAx1GomEWlBTEma9h+f/Z5kA4WEuQRl5uPT+4qG5Uuapmos4tOo7zE
	l7sYVxJ6OxVCWZWS8evagCfI8c4rGTBYRlPHm6NcSQ0HGrUEOgpqtxCU1WNfE1aNV90IyP
	okobQOq1lqmL1jLCP9C1W7V7RtpBSvM=
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-6354a4b4871so3803271d50.2
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 22:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759123848; x=1759728648; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H6RpQue8OwKA5zQcpcRYCFi/JKqNnjRsrmsTTJodjmk=;
        b=EkThpBh3bGHdaXCNLnjOiwdob20Us1RTbOUM5nudOFAOpS7J9b7FY8lchzhgOOPkx0
         PXkTZTV5WDwjGBuZ9wIdjX91Pq2ydc6gx2VNUmdzr6hvQiN+7kA5kqRei/qnzQ/j9Xgr
         DaUhul/NMFJapS+at8/WVrnurE1d7YG6X5PCGZgd0QKaF/sgrjM6+kIzciv5VQ+Gm9jV
         W4KHU1UVEJYwJY93miGap/E6CPUI4LSbU+zoz+XelW/cdgLmmrxxmHJ/szgDEwAUuhi7
         vrZnr6F2urXhwUEjkLCOOKynFnnWBx9P8Q8pnyUjZLhHMpoDyH541Gsx/K/QcznKTi18
         BIrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759123848; x=1759728648;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H6RpQue8OwKA5zQcpcRYCFi/JKqNnjRsrmsTTJodjmk=;
        b=BclT+XKuGTkVpW8CzMRYwhcVV+ijdLfCszz8Y3UMHRGq5HgMxDai+0rx0z7VBq+f8H
         Z9V88GRk3HGM+1/dEXB/gLd78f/zIgpSEoZXW4JbDN0LFrML+Jqj8VlDJ8PEv9M5uFQW
         v8gV9T058jOl+e/KKXB/Aj140e5fgTWYzIo7IFE+UuhVn9bDzP1cqdyrBmE9jrFUN1g+
         1g5B5/tIrZOnXgV2mYkW+rCVGHYhtyN8Kune8+sB08N8yoczhhA6K2TKlxqm7SZvkjqq
         euGurCB4sTl9j+YtApUhtvk1o+2dc4b4VptV5jVgkz0n6ba9KJVTJP+zNNwgoKAOcgKN
         QHpA==
X-Forwarded-Encrypted: i=1; AJvYcCXna7vxiqfhNMncnfE8VNE5rvmAn7mxmr25rdGCOc/yya4wd9gnn8UJVvLAZrG3ctvsu+DWmSc/Hg==@kvack.org
X-Gm-Message-State: AOJu0YzJwlzC/8eeJYtKc2N8ilWJ5Mg1UUOdB0FOjgjFlpKONGC9zsr2
	AsHnBOsuoyOqVPjseYt/mDoK2IvIdT7HlybP6yKg+BW3jiBVMaAPRoiD2eRWbGnmcmqcgXEPfa7
	+Osl0hV0VdM3NHVqA6UMAolERsScbz6PK6Nt/W8QTGE1ELpX7CzwCDiYhYQo=
X-Gm-Gg: ASbGncuWuAfbfM5Zy3mST9/EIOw4jQ8LJCb0x+6565kLBudKHgwB+Pu4B8aZD7EJwoI
	eaBZhNBImj0o57MgxD/EuCjb+YgQFSVUL6flwQl8j7u1w/5zr23sM9D75S85IAS43qV0u/KNhfi
	k3am2GCfpD9CLsgHLNaBBa4Z0VeSh1fn4pBp/ipulgROGCfVXh0u0J3BqQ+77mxs3OX8VAjU30C
	jafu0GSgQTUhPSMkE4ziQmmVA==
X-Google-Smtp-Source: AGHT+IGzHKJ7xHU3naTUQkRjp7yIyNsupo8BklnNDDQzGwoTBHcFOvT48upAsARg3m/lEoftd7Vapu9fQiwGfx5uQB0=
X-Received: by 2002:a05:690e:1509:b0:635:4ece:2411 with SMTP id
 956f58d0204a3-6361a8a2f8amr16801592d50.49.1759123847547; Sun, 28 Sep 2025
 22:30:47 -0700 (PDT)
MIME-Version: 1.0
References: <1757967196.153116687@apps.rackspace.com> <CADrL8HWGcj1oANGY=qAzpYi_-E-Xbi=L28Bmyyf8H7auVix=QQ@mail.gmail.com>
 <1757977128.137610687@apps.rackspace.com> <CADrL8HX78-oh0k2qAgqPvNVAhi4ESYvjRsScPGR2P2Dts13Bfw@mail.gmail.com>
 <aMl4qLyNovWHhty9@x1.local> <1758037938.96199037@apps.rackspace.com>
 <aMmMnfU-Koopc9mL@x1.local> <1758043654.112619688@apps.rackspace.com>
 <CAJHvVciL-6OLMPDGQjZ=VGDwvwKJznq0BL49uSj+DSq63LOUYQ@mail.gmail.com>
 <1758052343.971831541@apps.rackspace.com> <CAJHvVchHKxiVKFjUz4ir4PVDvUihLhiSRMBWqpMEZfwLdereuA@mail.gmail.com>
 <1758306560.96630670@apps.rackspace.com> <CAJHvVcj_gd=48k-dgbLeEoqn_f+QD-ifscu_DPvpAmPd1Kg=GA@mail.gmail.com>
 <1758998720.44976697@apps.rackspace.com>
In-Reply-To: <1758998720.44976697@apps.rackspace.com>
From: James Houghton <jthoughton@google.com>
Date: Sun, 28 Sep 2025 22:30:10 -0700
X-Gm-Features: AS18NWCAE9ldDAqVUvYjUE-2to0WXry3BcEeBojlBq2sKNq_5zKucI1FOeTlSh4
Message-ID: <CADrL8HW0eNsHnEsEdKYRNvFRBMvrDMrHawa55Kik9QFeVNEwgA@mail.gmail.com>
Subject: Re: PROBLEM: userfaultfd REGISTER minor mode on MAP_PRIVATE range fails
To: "David P. Reed" <dpreed@deepplum.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>, Peter Xu <peterx@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C90F44000A
X-Rspamd-Server: rspam05
X-Stat-Signature: qqzpp9ktqnhyhr45eyqno44p8aqwyfih
X-Rspam-User: 
X-HE-Tag: 1759123848-511640
X-HE-Meta: U2FsdGVkX19KESKH04NnrkBtJoGUhQUjCEKR6kBDxR9iMIymA32YF7e5FX6MEBBFbQ1dagTjtVLEVQKNy/y2553a+oPpHJ9mF8JRILd8F+U6/k6F59EAtnQ1D4BEcWhPKAp8CYKNnbyjwNHp4wmaP607mLM5JLwm7PXbZadXstHWvWmZ1mxHs1boaizrX02ioH7/KO6UJ673WgUvEWrbu5W38XIjsZDoPoDgvpbQTqAaJavlDGUjH1ZTOPinmC5wBwzJbqdF+O9sZx74o4Pw9h98qrrRTpOITP7GRwSg8AethhqfSvbblnIA7MJukH8vopz3oxaZoXL0rLFSrn/x/tv8CvAzMwkZ6xe88+PmhIljf71izWYZDzJ4Wmx4GfqOZNHcTRmrY1eMA2gN+HE81ve7Yw1A9dWawxWrXYEPfJpC24PLSPEex3BJTxZB1TCQ1Z2DmL2AgGUeMq5Ypg3Ldyan0dpXKjvwcT6fNxak5cdncH9uOjzgeyPlHUuRh4fBwOrgrfqk+/qPnLf/XYpoH7QMqwhfei5u+X7qMumJuJ2xT6Z3R5SIy+78KZSZzEw4NKgdpTB6Np0+T7u8Cc7F0sUc0q1/Kq71kUW4ayaXYF0bY8HGycB+jI6wwm8fmKEKEGqztte3pcvBUVMkNCgAD5CInFpiavu8oQJFK9AXpzTSZQCsWrxtUmi77dULyFN5rH3mJ+VZ5jGtSDrf2UvD2ho5xgDu4YpGKR3hgHk8AsfqMNOk2iDZ3RMq3EPgWH3rIF8FXmhEh4xWbuCpQYhhVHpr1xRLBz+4VKonS077jTXRqodJ29iE/bgK74tS3TQeOQxab+kRx9YTAWV5czUBe7LD1t9bNeXL6WDq5SY3R1jHFHH1ECrgSPsrbGucZcQEYUd8qd4g/VWpBY/zHB/YVlUbY9M0g6QGtemdWssB+EPfe/ch398hHtfjflPNgpE4CT0fSvWtVksnpeBY+Fx
 LyBW22vE
 I+W3+4iLLrlEs+ZYH0F7enbxDJErNHQsBMI+NxfFWsiwik72yK8Sk5pVLPc8w5moaONIlc7ZiveF4QkKsuHtz5jsi2cf4JBfW692oKirtUlNIyEFhgrnZ4OL1E31dM2p3Dfmb+N+RQdRVCzZmFG5ccuxaD7w669U7YXpW8qTsgCom/H3ndUTsM5qlAKt6QLHxg2GyRJCYUj7xi1qe55mjktzcrCF/k1LUb6zQ5OEDSfcj07+rerwfwQu/ViXyfP35quXRHSqV8AkDDnh4sPRVy9/sh6TPV4lRfjDxdbPraeTsmGeNvkla1gXYLBuGGkQPOS5QoD4Dpd28E1I1S79QXdb/Ww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 27, 2025 at 11:45=E2=80=AFAM David P. Reed <dpreed@deepplum.com=
> wrote:
>
> OK - responses below.

I think Peter will be able to help you the most, but I want to give my
two cents anyway.

>
> I'm still unclear what my role is vs. the others cc'ed on this problem re=
port is.
>
> Is anyone here (other than Andrew) a decision maker on what userfaultfd i=
s supposed to do? I can see what the current code DOES - and honestly, it's=
 seriously whacked semantically. (see the ExtMem paper for a reasonable use=
 case that it cannot serve, my use case is quite similar). So is anyone her=
e wanting to improve the functionality? I'm sure its current functions are =
used by some folks here - Google employees presumably focused on ChromeOS o=
r Android, I suppose, suggest that there's a use case there.

I think all of us want userfaultfd to be as useful as possible. :)
Peter, Axel, and I are quite familiar with userfaultfd's use as a tool
for enabling post-copy live migration for virtual machines.
Userfaultfd minor faults were created expressly for this purpose. Axel
wrote the userfaultfd minor fault support; I wrote the corresponding
userspace code to use it in Google Cloud.

Peter is quite a bit more familiar with userfaultfd than me (and I
think Axel, but I don't want to speak for him), so please excuse our
mistakes. (mm is complicated!)

There are a few others who care about userfaultfd who might jump in as
soon as patches get sent. I think these folks (so on top of Peter and
Andrew, people like Suren, Lorenzo, David Hildenbrand) will be the
folks who Ack or Nak the patches.

>
>
>
> My role started out by reporting that the documentation is both incomplet=
e and confusing, both in the man pages and the "kernel documentation". And =
the rationale presented in the documentation doesn't make sense. Some of yo=
u guys admit that you really don't understand how "swap" is different from =
"file-backed paging" (except for the corner cases of hugetlbfs [sort of "fi=
le backed"], "file-backed by /dev/zero" [which ends up using "swap"], and t=
mpfs [also "file backed" but using "swap"]. And yet "anonymous, private" us=
es "swap" and the "swap cache", not the "page cache".

The documentation is confusing; I agreed with you originally that it
should be updated. (Do you want to send a patch? Perhaps I could give
it a go when I find the time.)

I spent some time writing out how I define the various terms being
used here, I'll leave it at the end of this email in case it is
helpful, but otherwise please just ignore it. I wouldn't say that the
rationale in the documentation doesn't make sense. Userfaultfd exists
to solve specific problems.

>
> Now, after digging into the question, I feel like there was never, ever a=
 coherent architectural design for userfaultfd as a function. It's apparent=
ly just a "hack", not a "feature".

Userfaultfd certainly isn't perfect, but it is critical for things
like VM live migration, Android GC, CRIU, etc..

>
> I'd be happy to propose a much more coherent design (in my opinion as an =
operating systems designer for the past more than 20 years, starting with M=
ultics in 1970 - you guys may not be interested in my input, which is fair.=
 Is Linus interested? That would be a bunch of work for me, because I would=
 do a thorough job, not just a bunch of random patches. But I'm not proposi=
ng to join the maintainer-club - I'm retired from that space, and I find th=
e Linux kernel contributors poorly organized and chaotic.
>
> Or, I can just drop this interaction - concluding that userfaultfd is kin=
d of useless as is, and really badly documented to boot.

I am interested to hear your ideas for how you think userfaultfd
should work and how it solves your problem. :) At the end of the day,
I'm just trying (though clearly failing miserably) to help you solve
your problem.

Your characterization of userfaultfd as a "useless" "bunch of random
patches" that is just a "hack" is wrong. I understand; it doesn't
support your needs. I think what Peter, Axel, and I have been trying
to understand is what exactly you're trying to do and how userfaultfd
could (or may not) help you get there. You've shared some[1]
details[2] about what you're looking for, so thank you for that, but I
am still struggling to understand how the flexibility that you're
asking for is actually the right tool for the problem(s) you're trying
to solve.

[1]: https://lore.kernel.org/linux-mm/1758037039.08578612@apps.rackspace.co=
m/
[2]: https://lore.kernel.org/linux-mm/1758042583.108320755@apps.rackspace.c=
om/

> There is no sensible way to respond to a "missing event" when "missing" m=
eans the page is swapped out (to SWAP) by UFFDIO_COPY or UFFDIO_ZEROPAGE. T=
hat's just weird, and you continue to insist on it. Where is the page that =
was swapped out? Well, one could look at the PTE in /proc/pid/maps, and you=
 find that its "swap entry" is there as an index into a block device. (so, =
maybe you can open the swap device using some file descriptor and mmap() it=
 into the manager process, then UFFDIO_COPY, but what if the swap page is a=
ctually in the "swap cache", you can't mmap any swap cache page via any use=
rspace API - do you know a way to do that?)

(Please see the terms that I use at the bottom of this email; let me
reply using those terms.)

UFFDIO_COPY has quite well-defined semantics (albeit, perhaps not
*documented* well):

* For anonymous VMAs: UFFDIO_COPY will allocate page(s), copy some
user memory into the page(s) and map those pages at the specified VAs.
* For hugetlbfs and shmem/tmpfs VMAs, UFFDIO_COPY will fill holes in
the file's page cache with new pages, copy the user memory in, and map
those pages. UFFDIO_CONTINUE is additionally supported; it skips the
hole-filling step and requires the page cache to be populated.

For UFFDIO_COPY, if a page at a to-be-populated VA has already been
allocated (including if it has been reclaimed), the call will be
rejected. It would effectively be overwriting the contents of the
page; this is not supported today.

If "missing" includes swapped out pages, UFFDIO_COPY and
UFFDIO_ZEROPAGE would need to be allowed to overwrite the existing
contents. "Sensible" or not, there has been no need for this yet.

> Now I reported a bug in UFFIO_REGISTER [...]

The bug you reported is in the documentation only.

> [...] which you keep saying is the same as UFFDIO_CONTINUE. Well, it isn'=
t! I can register a minor handler (which allows continue) if I use MAP_ANON=
YMOUS|MAP_SHARED. The same "swap cache" mechanics exactly apply. The only "=
sharing" is potential future sharing after that process forks, in which cas=
e, the same "swap page" is shared until a Copy on Write forces the page to =
be unshared - it is a writeable page, just sharing the same physical block.=
 It can be swapped out to the swap cache and the swap device, which sets th=
e PTE to be a "swap entry" that causes a page fault.

(Using the terms at the bottom of this email.)

For UFFDIO_CONTINUE, the swap cache mechanics are like:

1. For anonymous pages in the VMA: swap-outs will not clear the PTEs,
touching the page will swap it back in again, UFFDIO_CONTINUE on it is
disallowed.
2. For page cache pages in the VMA (i.e., not-yet-written-to pages for
MAP_PRIVATE, any page for MAP_SHARED): swap-outs will clear the PTEs,
and touching the page will trigger a minor fault, and UFFDIO_CONTINUE
will swap it back in.

For MAP_ANONYMOUS|MAP_PRIVATE, all pages in the VMA will be anonymous
pages, so UFFDIO_CONTINUE will never be allowed, therefore
registration in the first place is disallowed.

(IMHO, it was dubious to have even allowed registering userfaultfd
minor faults with *any* MAP_PRIVATE VMA.)

> The swap device doesn't know where the pages are mapped. You need to look=
 at the PTEs of all the processes to find the translation to swap cache ent=
ry, and if you want to go backward from swap entry to pages, you need to us=
e a special XArray that finds VMAs given swap entry.
>
> But the point here I keep making is that UFFDIO_REGISTER rejects only MAP=
_ANONYMOUS that are MAP_PRIVATE and also not huge pages. To me that's weird=
.

I hope my above explanation (of sorts) makes it a little less weird.

> If it is the CoW case that doesn't work (I doubt it), well, you have to r=
ead the swapped out page into memory before copying it anyway. Then you cop=
y on write, from the page read or found in the swap cache.
>
> Now, as you say, that may require allocating a new page, also in the swap=
 cache. Is that a "missing" page in the weird userfaultfd terminology? If s=
o, to handle it can't be done with UFFIO_COPY, because you can't access the=
 contents from userspace. And it's not "write protected" from the perspecti=
ve of WP.

No it isn't a missing userfault. Data exists at the VA for which a
userfault would be generated, therefore it cannot be "missing".

>
>
>
> > The only exception I can
> > think of is swap faults, I could see anon swap faults (perhaps
> > specifically when the page is in the swap cache?) being considered
> > UFFD minor faults, but I would be curious to know what the use case is
> > for that / why you would want to do that. The original use case for
> > UFFD minor fault support was demand paging for VMs, where you have
> > some kind of shared memory (shmem or hugetlb) where one side of the
> > mapping is given to the VM, and the other side of the shared mapping
> > is used by the hypervisor to populate guest memory on-demand in
> > response to userfaultfd events.
>
>
>
> I think I've just answered this. userfaultfd doesn't support the "swap ou=
t" part of anonymous swapping at all. So, how could a manager get the page =
contents as of the instant it is put in the swap cache for writing out to t=
he swap device? There's no "swap out" event mechanism, and no way to treat =
the swap device cached into the swap cache as a page source. (not to mentio=
n the zswap mechanism, which compresses some of the pages into an invisible=
 piece of memory).
>
>
> >
> > To me it's not intended userfaultfd minor events are generated for
> > writeprotect faults, to me that's the domain of userfaultfd-wp, not
> > minor faults. James might be right that these unintentionally trigger
> > minor faults today, I would need to do some more reading of the code
> > to be certain though.
>
> I don't particulary care about writeprotect faults, but CoW probably shou=
ldn't be considered the same as a writeprotect fault, because CoW is trigge=
red by a write into a writeable area, ONLY in one of the mappings, whicheve=
r is written first. The process doesn't think of it as a "write" - it just =
is a kernel optimization of a common case where fork is followed by non-use=
, so the actual copy could have been done at fork time, semantically. It's =
a deferred read and allocation.
>
>
>
> I hope this helps clarify my concerns.
>
> There are several reasonable outcomes -
>
> 1. Much better documentation of what the code actually does (and why).

Agreed.

> 2. Fix the "bug" that prevents REGISTER of "minor" handler on private, an=
onymous mappings (obviously, you can REGISTER missing handlers as well), th=
en document actually what happens during the life cycle of swapping of page=
s in detail, including MAP_PRIVATE|MAP_ANONYMOUS VMAs.

Not a bug.

> 3. Do a thorough analysis of what userfaultfd really should do, if the go=
al is to provide the ability of a "manager process" to get to handle all ca=
ses of page fault behavior on a case-by-case basis for regions of user addr=
essable pages.

What userfaultfd "should do" is up to the problems we need it to solve.

> I'd be happy to contribute to (but not manage) whichever outcome - and I =
have what I think is a reasonable use case. (and I'm aware that this API ac=
cidentally created a serious hacker exploit earlier in its life, by creatin=
g a way to hang one process from another. I think that's no longer so easy.=
)

I would be glad to hear what changes you think should be made to
userfaultfd to better suit your needs.

Sorry if this reply is somewhat incoherent; I've gone back and forth a
few times on how to respond to your points in the most helpful way I
can. I've tried to be as clear as possible without being too verbose.

- James

--

Alrighty here are the terms/definitions I use, as I mentioned above.
Again feel, free to ignore them if they are unhelpful:

A "file-backed VMA" will load pages into the page cache. For most
filesystems, the page is loaded from a disk (or a proper device), but
for special filesystems like tmpfs, hugetlbfs, and ramfs, the page
cache is populated with zeroed pages initially.

tmpfs is kind of like a filesystem API for shmem, but they are so
interconnected that many people use the terms interchangeably. (To
clarify, I don't think of "shmem" as shorthand for "shared memory"; to
me, it is the name of an mm subsystem.) Every MAP_ANONYMOUS|MAP_SHARED
VMA is a shmem VMA; it is as if there is a tmpfs file backing VMAs
like these, so they are in some contexts considered "file-backed". See
shmem_zero_setup(). As far as I'm concerned, vma->vm_file is set, so
the VMA is file-backed (even though the mmap flags included
MAP_ANONYMOUS). I assume this is what you are referring to when you
say "file-backed by /dev/zero".

For any MAP_PRIVATE VMA, some pages may be "anonymous", in that no
page cache is holding a reference to it (i.e., generally speaking, the
only references on the page are the ones taken by the PTEs mapping the
page). Reclaim of pages like these will put them in a swap cache.

For pages where a reference is held in a page cache, if the page is
dirty, it can be written out to disk. shmem implements "writeout" by
swapping just like anonymous pages, but other filesystems implement it
how you would expect.

