Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84B1DCA5FC5
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 19:15:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 591C36B0088; Wed, 30 Sep 2026 15:15:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56ABD6B008A; Wed, 30 Sep 2026 15:15:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47F8F6B0093; Wed, 30 Sep 2026 15:15:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 080826B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 15:15:30 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8B6401C0818
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 19:15:30 +0000 (UTC)
X-FDA: 85271382420.01.2C48146
Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6C09540010
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 19:15:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=tenstorrent.com header.s=google header.b=gO5WG1Ph;
	dmarc=pass (policy=reject) header.from=tenstorrent.com;
	spf=pass (imf17.hostedemail.com: domain of asrinivasan@tenstorrent.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=asrinivasan@tenstorrent.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790795728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sykxas6Adj+WIJltS14TUveHVHPawmc/B3/hESpzPNs=;
	b=vrrKB/rV+UBMVOZTWmrJdrzM+cpTKtl1zxIy/PPAd0TVp9521kLOdsMnaP7vic1zIesOTr
	LHkkPXOjF08Ra+iqBk/LtSLhcwq+w6JAFVpFHgns47vVBO77dQuU3rcWRyXVKVTfa1zPWX
	boenbZrQcxi3XHZAndkwGzEJzjGv55k=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=tenstorrent.com header.s=google header.b=gO5WG1Ph;
	dmarc=pass (policy=reject) header.from=tenstorrent.com;
	spf=pass (imf17.hostedemail.com: domain of asrinivasan@tenstorrent.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=asrinivasan@tenstorrent.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790795728;
	b=gsdbygm5qklLHpB25ptcyKv0gP5Edq9TfqbEIMe+rPM2gaDCw2Txyc+W+ApmepYjtzNO3I
	2v+RlB8OVnsWv0J7EbCFB7veJrgDolyLltwIhzResHQZHdfjl5VWCRrFtBndQ+20QDpCNp
	xxdgjHwc4JmDg1OjUozh8xCDNAo4Wxk=
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-67583c777abso76154d50.1
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 12:15:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790795727; cv=none;
        d=google.com; s=arc-20260327;
        b=V0tSKKKWCsEJ3dFyu7Lev+xMRHaicbd9on4Z/GXUvqFNjIgteKAVm5KO0TnGpjzvOF
         ghNM+wYo0OyrsgyZdINoRnJnC8Ioz8sYOVO+26xXD5cOP9p2LT1GqG/3XClDITbOAxiW
         f+arHHP+5AeB0/ygUIdRWuO0KX+01WA3NQHkg3CVOg04k1jWOi+Lh+Q8eUOM0H2IInn2
         sxr+230GnE81d2PasalVLue9F6rCF6DCdLabwMR7ZbyczAexNK+oB9TmAjVc3z6N7Y8y
         2mYOvHKr2olxKflEzXBzxcm13oHNjr6IEUzwCd5zpWIKjYZVT60gNn8eIPcydwD7OiVS
         B35A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sykxas6Adj+WIJltS14TUveHVHPawmc/B3/hESpzPNs=;
        fh=98puPBj8iMk/lvSxY8a+giFKJUMFUZGwFweNMAx4EFI=;
        b=LGdSGwcmvOQO3uOMlNT/3xg6LimqvE7SPLirdwWfz1rS/ZXBaT4mAXSPPpvVzjJh2s
         S8tpad2bN8La7/Fi+RQI/rmG04AJ+P//VoWP2AmwpuCgtgfLatIfT+WsPG94xoWgKM8y
         buZCS1EtrQ+pfrSJcodWfiY+yuzdeBL1GS4j2uuh3ejtSJrtWwmBiKTL5YxxVhAW74MZ
         JMzhgnkVUO6EtA2Cm0nqsJsV6FReoU3nXE/NEi9oZ2x86UZuEfkzRRxZzcDOZe1lsMvt
         0FxE9PTNXMamJeiRl5RVbTfNAnOvFW6krmA5qjymi86lz2KwZcZV5TaP3ak9qb6BOmL5
         eCaw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tenstorrent.com; s=google; t=1790795727; x=1791400527; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sykxas6Adj+WIJltS14TUveHVHPawmc/B3/hESpzPNs=;
        b=gO5WG1Phak1RY30W+jw4cBfIohZpWI09HcjMilxU8UEDo27zq4yqiqp3KRl89YO5B+
         ZyeXJD806pTA6GX2j5n/uLtqNeohevFpNLxMbI8IqEaEwCVM8ly0EUuZ8Z/dA8wGLsou
         aaMNhznBlhxJybZFTkDIAGN9QviM4pd+d/JPOjeTrWyQHp/riRbEuDuJ3U5hesnvc7cE
         oIzNQcANzbyJa582g0/448NsQDzZsShj5h+pbIynESsYlBYBOvla2snGk8fPtkssG+yv
         PgfKmx5x/g0jffuYlLJh7nkUKqcEF3bRsphyQHNs/92v6BTVWcJNfIAl5XS/I27hDoSe
         ekGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790795727; x=1791400527;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sykxas6Adj+WIJltS14TUveHVHPawmc/B3/hESpzPNs=;
        b=vOeKbleAdwVXg0fXxkGrlHgAelGtwwuwmTD4BuQuHfGrr4ce3qcsN/jlkZIfUg+8zT
         B8wOEglDaZxsFVSsutCyRJf/ZL3T7e3BaxjZMohVUyojbFTYahn33OGMMyZSXi+WQTw9
         9HC89bXvqXFC92NV5KTWGW1S61/wvGrVY64M4zuykJ6YgG1i3Cfi6fKY+EG3kgo4KizJ
         isWUeq8XUteTJ5CqIz8x74qKBCVN4DI59fZfpg/ibrSFStn+laMjasAKYn6SUhyz1wMk
         rq1ZMw+KMjZlXsZy7p1M+KiprqBntKOpt7CKCqqD/Y046616EPVxbOsD5rHDly2zc0Qy
         cg+g==
X-Forwarded-Encrypted: i=1; AKwUvBwAhRhaBqyxni6VG7vBdyGxE9YL2/hxyyJQgCSGUkZEOvQ/8zNLIsgbWMCHb6vQfs/LCjM+bHGjWA==@kvack.org
X-Gm-Message-State: AFq9FYJoYFO3yKThmpG6UXEoyOMN/KUaFLPBXFdUEWHAa48qgVpGyKnf
	w1ZsNswzdOnRQ15aDGCmjwTN6Fk4RUgxfMEU6bv7rVu3K+IryeKnVCI8+hNIkwRpqNLYJz3v4mS
	qiQ4nl18EuUHB3o15NGWWjwb7fKpDPUgoTcfHxJ2gVQ==
X-Gm-Gg: AYBFou2D4YHlVSkzslRBpUTAm+R92FzSq1F741QdA64sxk7TLgCtC1ywOQjWDxMSEyC
	P8LlQZU1sFvN22SI0iEAN19hoKU1H1SjNXPa1hL6eFwNKDtLAVSCYScfyodaSQ7y1npFfjUru+E
	wGRzjegSy7DjjT15AByCERS/SrsKv+eexBNs+D2+bAsjsdJ3QUcMn81paDr9SnYbwpGyJPLJWzQ
	rKec9NlS6IzXPVw+ep7Xpbe7FLyogTL//nS08atdq6tFlgkJxuPw0CGBDRhNeYylcmVSdRVkn54
	ou0qs3UwClQhO+WBrScAoVQAAStvsdbNMizVdswXTtgSntqfS8GWwJL2QsruE4kX8sRGZwc5frH
	QsbqmThyUNA==
X-Received: by 2002:a05:690e:1586:10b0:672:96c4:af92 with SMTP id
 956f58d0204a3-676911e16b6mr273044d50.33.1790795727505; Wed, 30 Sep 2026
 12:15:27 -0700 (PDT)
MIME-Version: 1.0
References: <20260930-fix-dontunmap-partial-self-merge-v2-0-f388985a0f0a@kernel.org>
In-Reply-To: <20260930-fix-dontunmap-partial-self-merge-v2-0-f388985a0f0a@kernel.org>
From: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
Date: Wed, 30 Sep 2026 14:15:16 -0500
X-Gm-Features: AclHuK-pvBqXamSowcqonc1nkj-a8CmAPv0aSHfEztWllhc4V4grOHWSW8mGpDM
Message-ID: <CAEev2e8TXNwon=Ro27WYvyn-N5j=CenA8pEgLTPerMQtDh2OWw@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] mm/mremap: fix two issues with MREMAP_DONTUNMAP
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
	Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6C09540010
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: zxjoedbpexz4sir1iec8be7synmfufke
X-HE-Tag: 1790795728-913111
X-HE-Meta: U2FsdGVkX1+NDkO6gFUvoYmXZHlqkjAzsZ6e0+6oryUax5hlX5YaOr9wLQUZ+ZI98FmB/D1F/P1qYWVeXcP93ldjuiUymsgS20t0rN8Sqb0ZE5xHhFodgTQqX5qxJKszHk9icLTP9kMglFE13bxUf9S5PmtL9un+Veele7LriDM3xn8vN95fHpp76x0lBD8zmOtonW4O8sS1PN+ZcBG+/IDu3qOgK5gl5AKjlK8d1V0ncWzKWopn4IU+m2yfL83Dh4MAICMPiXiYr9SRdnw1K2XSGUbyxRa+On59aScydsVd+T7l2WmcR/8k9GZkr9WviFrIj2uoLOFhtYmKjVZBYO48j1+ORiYQ/QBUAUKqRNwVi+qdbuhgXKb7esDc8ID0PhCHruCCCeC3jKOari79O1NHo4GA+ueg0AHZRz6JBq3hfTUhOZoT0DBqsDiKsYuZY0zUzvKZ4PvIk9ZXyS8liHwqsCE0rdNBxzQMfocgykHbGTjosYeeonfyuUrLGfyGNjseU9+8cCVgC0qrCytUA0x+JZEUgnJbbImIIpqzr2kirhAQijVPH1uCot1DjXnHr7Y0I8q9b5LpkeWZ1EgIhG3ZluN/L7/3AIgtQ3s/BXtDeYdCzdCPr++wQIAyleePHpS5PasDBgtYvLOLv9obi64DxkN19nNiZ0KuXG3JaoSn6kF4No7sWyZCqqxvxa5P41pghdcue85apvptrXLbddNtRWlOlOgT17oqw2Bufq8WpwUFOSMVLw2AT99wZ+Yruy2qu4vw+6HzMVVkoeVq7ayAKYsHQIIvNrUc6iK/LvGIA/DQBgAXgTH6pb44KkpTV2bHyZMnaLVDhaZOlSa6RoJbhlyZaadV9QXL5TRwLDPCW084uk8q+BoOLxd5O8QHxK6sFFZJXW4zKEPsGQIsQ8dWwF15KzmO+AX/PSgyBM88XGDUJa6egkKxhucAI/jPYTgClVg8AdTdMygJ031
 WaH+Y/y8
 8XX+EiA3FgUtU7YwMr+aguVdX7lk9iy+tmz86D7khIzUrLQFBEomUwew6juumqjZvUz3pMyNsckja0jJM2D/2+ssX2vew/XFr1Nr6ebAekynCsrSiaaLB3g+hFN3nyTNVWd6pcQUld3kSxTgOJ+0KAphg7eCKlICt6wd0rcib7U4IEFnN3zoyZa9QFFKG82lsXI9ccR8ykA+o0BJGp59xJ+Wm6R4iFdFIKdZkB/vzYy9E1wPcX0dHOKY2d8ahc2eprOqaOLmuZERL1QZj+07WF89Rvje4CQoW6lIB8tOkcUGmW8S9hQmu6XaeeI+qfO8wbXD45DLxG2OgO7C9gRMEiQfmjQu4SfU+Lo/mhfeInuSlsfvUO0SpEv7qcvfOOI8mao9s7Ru7bxPCXnxvYVqsXZwOToK8IWioNZRpBD2A7acqND4Q6r3Gq5esvaqUxQZEfbKolS1mpit38fWXwcPih32rjEb4cvmMrnEce1MWiQK3ggSx6SNGppaoQxmyYjXaO99R6XGIJNtdC2X6ssD8IQWD8zxohKQ3UoEAIu9aZl6/0MGXBzXR2j1XOBhrTeGGcLK+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 1:47=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> The MREMAP_DONTUNMAP feature is highly unusual in that it permits mremap(=
)
> operations that keep the original VMA in place.
>
> Historically this has led to a lot of bugs where non-obvious interactions
> occur between existing mremap() operations and the original VMA.
>
> Commit 397432cab17b ("mm/mremap: account mm->locked_vm correctly for
> MREMAP_DONTUNMAP") fixed an accidentally introduced bug around
> mm->locked_vm accounting, but this wasn't the only issue.
>
> And thus history repeats itself, as it turns out that mm->locked_vm
> accounting is broken by MREMAP_DONTUNMAP yet again by two further cases,
> and has been broken ever since the feature was introduced.
>
> Both relate to the fact that VMA_LOCKED_BIT is cleared on the source
> VMA (it has to be as all page tables are moved):
>
> 1. If an unfaulted VMA_LOCKONFAULT_BIT anonymous VMA self-merges it
>    clears the VMA_LOCKED_BIT flag and permanently leaks mm->locked_vm
>    pages.
>
> 2. If a partial mremap() is performed on a locked VMA there is a leak equ=
al
>    to the number of pages not copied.
>
> (Both for MREMAP_DONTUNMAP operations only)
>
> Both issues can be fixed by treating the source range as distinct from th=
e
> destination range, which is the definition of what MREMAP_DONTUNMAP does =
so
> is appropriate.
>
> In case 1, simply disallow the self-merge, keeping adjacent source and
> destination VMAs distinct.
>
> In case 2, split the source range ahead of time if the VMA is mlock()'d, =
so
> accounting is always correct.
>
> Both changes were tested locally and confirmed to fix the issues.
>
> For the purposes of a backport, the fixes are kept distinct, a follow-up
> series can add self-tests.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
> v2:
> * Added tags (thanks everybody!)
> * Updated 2/2 to avoid splitting the VMA if the VMA was not mlock()'d. It
>   is only meaningful and necessary to perform the split in this case. Thi=
s
>   also fixes the proc_maps_race selftests that broke, as reported by
>   Anirudh.
>
> v1:
> https://lore.kernel.org/r/20260920-fix-dontunmap-partial-self-merge-v1-0-=
6ffb556f8f8b@kernel.org
>
> ---
> Lorenzo Stoakes (ARM) (2):
>       mm/mremap: fix locked_vm leak from MREMAP_DONTUNMAP self-merge
>       mm/mremap: fix locked_vm leak by splitting VMA for MREMAP_DONTUNMAP
>
>  mm/mremap.c                   | 70 ++++++++++++++++++++++++++++++++-----=
------
>  mm/vma.c                      | 21 +++++++++++--
>  mm/vma.h                      |  7 ++++-
>  tools/testing/vma/tests/vma.c | 10 +++----
>  4 files changed, 81 insertions(+), 27 deletions(-)

Thanks, the selftests are passing now.

Tested-by: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>

Regards
Anirudh Srinivasan

