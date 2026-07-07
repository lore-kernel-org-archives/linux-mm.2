Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B1CFC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 14:34:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B3756B0005; Tue,  7 Jul 2026 10:34:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18BCB6B00A7; Tue,  7 Jul 2026 10:34:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07C8A6B00AC; Tue,  7 Jul 2026 10:34:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D1F5B6B0005
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:34:29 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5FDF0A0479
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:34:29 +0000 (UTC)
X-FDA: 84962226258.02.4255D7F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6123D18000C
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:34:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cHr5YAQg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783434867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7f2N/SJQhJLGukCIcGmJQv9G5BEKubFQyKhmhbtamRg=;
	b=ZlUwS8Gx6jAJUokuXyPfn1098e0PjV2zkdEerwq0nth4txp/rCySDgKn9I5SUkgrIG1+hX
	DHiRzd3eqm9vgH0Xq6jIIpjyHxHhR4tN42A+Rue9Gc1edcWdnZgBIHWKACSnoZIbqVxjtd
	nC35WhaiNcCoCaIH9d7YUKuQRrgDajM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cHr5YAQg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783434867;
	b=1Grcri+VlhsdHpNVYwaKLKw/D1Suyaqzxye9FW+FtvyAVlZwqlRxpnKBD6KaaXBmu9OGfd
	WbmNDmfIb4sDzatN+c5twmltoICmyjg1CXQHVIuk5fKEvc+l16Ucz3h/Hza/E7ALxamnIa
	G6DWbb4z12GrzDytAlveEMq1d2gZdyA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 836784188A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:34:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676FB1F000E9
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783434866;
	bh=7f2N/SJQhJLGukCIcGmJQv9G5BEKubFQyKhmhbtamRg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=cHr5YAQgwuJ40WYqmmXAvD5Yud1eg+3k/oTgssQil4smRcvOqud5HdZobqZ1DkSXs
	 Cw2u7GwpXyQTAf5gUWJ7CXzBtie7nKH7vMiLPeNAcyC/5MMyR4j2peWV7JU5Xjv1tS
	 spAe+JFdqwTmMSjtAshqBS0E2Pzjxg5wtGG99SdOZ+oSQDPla+ZjP7jiUO0Gj0IjQ0
	 rVnHcCNxtAhm01KECAvj0tyMbxIynhgT0z8gfkpnZXroRE5kEOiCKzJrTnxgg4wrhd
	 5UUrrTdE4F1P4mIySLv8Q4de9TTwvyQaeZT+OysYYYIeEwHeytkMTlX4AAliA4NvwJ
	 ylhbhxHe6TVMw==
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-51c16ac21acso20828251cf.0
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 07:34:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Ro+ZMUSqFandBYYVoqVXx6OYmYAh6ZgOcsqkIF8ZQ3E0BynaGz/gfT7AzQAY6ptp7sWYHZGTXYZjA==@kvack.org
X-Gm-Message-State: AOJu0YwcobQihg/U7O+inD8jqw57QhckW3+g1lxVs6JJLU7oWzY+zYNW
	m9L4Xke7C/ve3oF7l2A+fcjx8J4JnDUt7cARV/px7C28AQdR0HIcK/n8B0BWRGHGfTUIm4qUbeR
	Ao0JlSGZz6fb0X5HUMSRYot33XoK5QWo=
X-Received: by 2002:a05:622a:e094:20b0:51c:7b12:1207 with SMTP id
 d75a77b69052e-51c7b12179amr15829651cf.85.1783434865720; Tue, 07 Jul 2026
 07:34:25 -0700 (PDT)
MIME-Version: 1.0
References: <173f3fd983d735155d47e9e39d27f0c2d62a7c31.1783307463.git.baolin.wang@linux.alibaba.com>
 <CAMgjq7AQcyypJ-VhJ_CxY6fdEph64fxjOzzYU-=EkMrHemkpzA@mail.gmail.com>
 <8ef0b72e-a0e8-4913-8d30-519335305260@linux.alibaba.com> <CAGsJ_4z5N6FSfWt5WUZ5YmqhCzLcd3Cj1sc9B79WYX9ZbDH8Gw@mail.gmail.com>
 <d01bae40-f94d-4e8a-baac-ad6fffa18b64@linux.alibaba.com>
In-Reply-To: <d01bae40-f94d-4e8a-baac-ad6fffa18b64@linux.alibaba.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 7 Jul 2026 22:34:12 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zbBRe383GQLGuPivUXXnjhs2L9xFyandXkCOUotcb7Vg@mail.gmail.com>
X-Gm-Features: AVVi8Cdk8e1_A5dUPq7XT_kY-SwTQ4Hn7kKDOOl2oDp5wOSBPnjQwov2kRW5pUQ
Message-ID: <CAGsJ_4zbBRe383GQLGuPivUXXnjhs2L9xFyandXkCOUotcb7Vg@mail.gmail.com>
Subject: Re: [PATCH 6.18.y] mm: shmem: fix potential livelock issue for shmem
 direct swapin
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Kairui Song <ryncsn@gmail.com>, akpm@linux-foundation.org, hughd@google.com, 
	stable@vger.kernel.org, machao26@xiaomi.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6123D18000C
X-Stat-Signature: x4wqq6p96din8tna5nf3xzdyqdod4zbj
X-Rspam-User: 
X-HE-Tag: 1783434867-763573
X-HE-Meta: U2FsdGVkX1/pnc4z/VodTlMjjaln0n3Uw8HC0zXhNO3tE6B8NX43a0ydstzNrHNeVKVyHPrv5T6qx/WGctoyDSULTnEGedhwhJlCcbsx5N1cp3O0DPkajzRRhMXV5rJDYNT0h7jRsPakhs/cS/jGISmSonAmecGICRjZWb3y13PfNT/lwKcYlBE9KN5GBRSIXusBeVJuR5mq7qZlggGtNzKelSXzTjOBsxUhyYbhc9yrrsjDNXoZ2AiSKNI4lOXe8ZK5+1cOXHNnJytzQvwDe9Ak2fyUd33wnCzIEOFjgVsGD8yMxtFMqNgpEW3M4JA7zRxZ3ew6rXU/cetWn2y0CP6euclf1kO2wChbHtzONu1BurmGHrB7VFEN0tEG4fjalhtNDiKM4HFCZE/QyO2haCMVbQem4TNh1QecqU0oDWss615+F4TZwnbtSwGMPSUQZHM8Zfc8RGd2+4rhOQqILHHt9lkP+jV+ScKZqcFOh/044YMm6HvVbhFKEnNE1RwDI56+OmYk84Az4JEwVl+Qs4wAL7M7MuH+4ThH1gklL+3B86CsRbEhFwpqJVFcMrMeivkSgpvbNtg90Z1Ki+glydsne18wAnC0NP6j6axTFlq+KjIZHBNkDnwj3w7caWuGU3SaZ9HWWkpGL1MnFGMsqEA0b+3l6zwD5DG/EFG1VweAKCxIP+WR2hM9Kp6ur/5PILKGzVztRf4NRqgg19/2XDDCdNtOlTtKwTdO6+KnM5beRml5JFMRww63XEE5HJQWtErqp/2wuk02ELiRMdgQ2IIlUERzQNYwZKGrO98D4I/Nb+ZkUq0LDOk1Th009uDEyeLIZT+8HCX550jJsR/o9fJVPsmwVw4A37V4LKLweWTPdfK+d01F5fAQR9CWjL2GQMHkfHtP2/cgtqRawXQuaxn38p/AwngUDnzBwwH8pUf5YutGvFHd0nzkW9z9niAhdwG7WXFB5FtATfn4wuJ
 eJ8bpmO4
 l8iVAVhZbUFgrY++mcNYa6qEg6SkNxuXHJi9P/Za7AKuZWvPn9Xn84D4GCUfWeZ0PFJN7JGDVrwiyyNhbytMcBZDXst3IuAlyqXTzarUjipGwOlFZCCd9bDxppwSsEVvJjnisPqYTWMqRkkUf7DIp5Mm/VVfu/UUh9AATajQrczzfMhM3YyEZrYNh6dvSCVswQAYwjBEZrkTo0LJ3IV0g2VR0+FxQk9xKpQLrqKnULUkIdjypF27zDOmZuMxmEHjXXm4oIa0GPld5Qdy8jDNJ/C14k1SH8c2DlasVRzfqPHeIKggBmvinM4kIEULsbJFPgqub57Rf3A5cDeXn3PQfXdXrzgnd4a2a2TCFAuVYZ4Sz+FkSUU2xANVM1A1tHKCsBc4g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 7, 2026 at 9:53=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
>
>
> On 7/6/26 9:04 PM, Barry Song wrote:
> > On Mon, Jul 6, 2026 at 8:08=E2=80=AFPM Baolin Wang
> > <baolin.wang@linux.alibaba.com> wrote:
> >>
> >>
> >>
> >> On 7/6/26 1:59 PM, Kairui Song wrote:
> >>> On Mon, Jul 6, 2026 at 11:25=E2=80=AFAM Baolin Wang
> >>> <baolin.wang@linux.alibaba.com> wrote:
> >>>>
> >>>> When skipping swapcache for synchronous IO swap devices, swapcache_p=
repare()
> >>>> is used to prevent parallel swapin from proceeding with the swap cac=
he flag.
> >>>> However, on PREEMPT kernels this can lead to a livelock, as reported=
 by Chao[1]:
> >>>>
> >>>> Thread A starts direct swapin of a shmem folio and calls swapcache_p=
repare()
> >>>> to set SWAP_HAS_CACHE. It may then be preempted inside workingset_re=
fault().
> >>>> Meanwhile, a higher priority thread B also attempts direct swapin of=
 the same
> >>>> shmem swap entry. Since swapcache_prepare() already marks the entry,=
 thread B
> >>>> repeatedly gets -EEXIST and busy-loops waiting for thread A to finis=
h. But as
> >>>> thread B runs at higher priority, thread A cannot preempt it, result=
ing in
> >>>> starvation and a livelock.
> >>>>
> >>>> Fix it by yielding the CPU with schedule_timeout_uninterruptible(1) =
when
> >>>> swapcache_prepare() fails, following the same approach used in commi=
ts
> >>>> 029c4628b2eb ("mm: swap: get rid of livelock in swapin readahead") a=
nd
> >>>> 13ddaf26be32 ("mm/swap: fix race when skipping swapcache").
> >>>>
> >>>> Note that mainline does not have this potential issue, which has alr=
eady been
> >>>> resolved by Kairui's swap refactoring work[2].
> >>>>
> >>>> [1] https://lore.kernel.org/all/700a2cbf90a2484f979aac858f08f5d4@xia=
omi.com/
> >>>> [2] https://lore.kernel.org/all/20260517-swap-table-p4-v5-0-88ae43e0=
64c7@tencent.com/
> >>>> Fixes: 1dd44c0af4fa ("mm: shmem: skip swapcache for swapin of synchr=
onous swap device")
> >>>> Reported-by: Ma Chao <machao26@xiaomi.com>
> >>>> Closes: https://lore.kernel.org/all/700a2cbf90a2484f979aac858f08f5d4=
@xiaomi.com/
> >>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> >>>> ---
> >>>> Hi Chao, could you try this patch to check if it fixes your issue? T=
hanks.
> >>>> ---
> >>>>    mm/shmem.c | 2 ++
> >>>>    1 file changed, 2 insertions(+)
> >>>>
> >>>> diff --git a/mm/shmem.c b/mm/shmem.c
> >>>> index 94c5b0d78ac3..d4cb57b3b0ef 100644
> >>>> --- a/mm/shmem.c
> >>>> +++ b/mm/shmem.c
> >>>> @@ -2066,6 +2066,8 @@ static struct folio *shmem_swap_alloc_folio(st=
ruct inode *inode,
> >>>>           if (swapcache_prepare(entry, nr_pages)) {
> >>>>                   folio_put(new);
> >>>>                   new =3D ERR_PTR(-EEXIST);
> >>>> +               /* Relax a bit to prevent rapid repeated page faults=
 */
> >>>> +               schedule_timeout_uninterruptible(1);
> >>>>                   /* Try smaller folio to avoid cache conflict */
> >>>>                   goto fallback;
> >>>>           }
> >>>> --
> >>>> 2.47.3
> >>>>
> >>>
> >>> Thanks! That's much more simpler than I expected. Do we need a wakeup
> >>> queue like the one in commit 01626a1823024? Perhaps the reporter can
> >>> help confirm and test? I personally prefer to keep it simple if shmem
> >>> users aren't as sensitive as anon users.
> >>
> >> I agree. I'd like to keep the bugfix as simple as possible, if the
> >> reporter's scenario isn't latency-sensitive.
> >
> > On Android, we don't see much shmem; it's much less common
> > than anon. So the chance of this concurrency happening should
> > be lower than for anon. However, shmem can be shared by
> > multiple processes, so could this still happen if process A is
> > blocked by process B?
>
> Could you be more specific about how that happens? I think we should fix
> this starvation/livelock issue if you think it could still happen.

Hi Baolin,

I think your change has fixed the livelock issue, but an unconditional
one-tick sleep could still be problematic, as commit 01626a1823 tried to
address in do_swap_page():

"mm: avoid unconditional one-tick sleep when swapcache_prepare fails"

If possible, I would suggest that your fix also include the change from
commit 01626a1823 to avoid the issue caused by
schedule_timeout_uninterruptible(1): an unconditional one-tick sleep
could cause UI stuttering. At least, this would make the code more
defensive.

Thanks
Barry

