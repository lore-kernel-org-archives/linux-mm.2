Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4CB5FF8865
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 07:16:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 328ED6B0005; Mon, 27 Apr 2026 03:16:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D9096B0088; Mon, 27 Apr 2026 03:16:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C9216B008C; Mon, 27 Apr 2026 03:16:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 04DE56B0005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 03:16:37 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A141C4078F
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:16:36 +0000 (UTC)
X-FDA: 84703477992.03.06A206A
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf30.hostedemail.com (Postfix) with ESMTP id AEA8C80003
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:16:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=G4vJKCsN;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777274194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7AvPAXsuvtgC8xHgqZ0h0f5zzV7f6VHw1kg2bqEt4fs=;
	b=nV8OigvsxI2yWYPgsTOk48tsX2k7F4WqbL+4PyQTcHakIZG43rQmZHUd7jaXIULdMxRMaC
	R4RxsQdpm9heVQqAdh3brANNBQOg1HvEsQuoTIVUTwJ4dVw9yVFOMpUPo5Nv9EI38yTDpY
	FqirUBIn60nWEapEF4KHa/2qEwSxCAg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777274194; a=rsa-sha256;
	cv=none;
	b=a3QIpjXdHQrIRTnx6IPoI6+kjpByqKH6hK8G2l1/UuSCo0xPeeG4vAVfBy5vMMDPEHMwi/
	L/EqLs7vYuNyKRqbLk5Mnzsx6eLeCu1RFhfMmGSQv0xZOrmI7072+ITS5y0nLmKbTlDaSj
	mHVQfzKDL0K/FZ9bXaHz2Hzr7nwjRQE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=G4vJKCsN;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-488b8bc6bc9so70774845e9.3
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 00:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777274193; x=1777878993; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7AvPAXsuvtgC8xHgqZ0h0f5zzV7f6VHw1kg2bqEt4fs=;
        b=G4vJKCsN677wn77sgaBHKgrAi/xFk8Et9HUzRbF+ZVtv0HUPMakz0WI0Mj82LaoXpD
         2BuHrZsW1S56ZjNjXkpYGwCh3zf4mlhQjhqUkKSpoONQKKOibFXklmwZSg2NiOtAfhnj
         4fPoW27QYm2leQeTwyar1jHalq5On+viVjVLAF3r8FtePnbJjRZxc9Bi+Hyybkm6JL4r
         krBE7VGb78mQpodmLWVfEar2EwnwNTLJG3MwwqNF5K4LbLC2MuD9yrAhwe5EoakGJ9mF
         PTen4SIvJJwfDkAlgbY+n5ufmeCL1GSM6PbrhTPeypYGpxjHYcroXE0SJfuEcRsrLtk7
         dkfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777274193; x=1777878993;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7AvPAXsuvtgC8xHgqZ0h0f5zzV7f6VHw1kg2bqEt4fs=;
        b=FgpmIg/Q7nktkL3V0K+q4sMswOXogVpDCyZDECS1KY/s0U6824v2IBSXsiOXRh7leg
         1l2rM5qdzCRsbbYWyKpflvcZRub7+2mNArRIGqMTudFlk39y7hC3Tz0mFOBQmEpQQ0Mu
         enPbGGtBN3SIGdSpN6NWjmDD7XGPzi1JOX4f4d9pLBPm5vkAlzFcb6ciqSjXZMRJ08EE
         SOcTb1HwH0WIjt4T4ZdTd+lb16EFkLV3OaQimY3WJMmjiBrEUvww4yl2RnqAnlAseTyy
         KKflLoWCuRvOSaI+5OXkVHXV4o7Cxz7qPZo6eJyt5TmlFCYK7i9esG3KX0papdqAtBnN
         p0IQ==
X-Forwarded-Encrypted: i=1; AFNElJ+hss53UTj6kCycuCK2Xm1w5f3rQQq1K4iHs/nIrN41htLA7C0WHYm94k/QofGPyzra081V/+926g==@kvack.org
X-Gm-Message-State: AOJu0Yy3+6E4xXPd0FfIzIjfCDe+YmEsjRdkBb18ipPnCTy2BZJgglK6
	OVMobsjf1aU1wL/XpKkSf/hR1iLmSzIZpINudgNY0JWrsSTY74ZsjS1nBKU6BwmxlYlkDQp0ba0
	rGqFN28M=
X-Gm-Gg: AeBDievVg+oTgT0om/YK7NR199gUJrtUs3l+hfNYWKKh+P+G8l5jJEXeqcBnp0VEXHi
	9v6Z4no2BvzV85opQIlUJedtvP7Yd9NtME2p5PniWG9chnZo43oFFfU6cBCar0XoitC997jaLOd
	dbrUkvyJ5YbT8mkKL0rlxKb+Bq7kBXp3sqUahWLLMb2HFVw24T33Qjiza/bYpgWGBtN49Bu3zG3
	z+/yHSJ+uVxn4WP/3gr+oXhbfIGyWQspxlKj3SQnT9Q2mNZNiTMg1E/oZGzAO5RG4vUG3S+JgkO
	FbNhie4N02xG2Tv7mGGQL3TFJZUCElhv0mv1aln8L7EppIL6i5s6ljwbN6Srw0YYo4SLZ23kIeo
	M/hOrNpMqq6GRyUpLDE/sOCxUTaOr2Ja/DfLDShXKtExP9z4vlFFiLCO17NtnoGCQXA31sGccLL
	Maz8qDw0lJ2ypCjn4YdTTavgkblfgHgk0XaWYVbzuVwQOer1Q=
X-Received: by 2002:a05:600c:858c:b0:48a:55d8:7882 with SMTP id 5b1f17b1804b1-48a55d87a58mr307347815e9.9.1777274192917;
        Mon, 27 Apr 2026 00:16:32 -0700 (PDT)
Received: from localhost (109-81-17-171.rct.o2.cz. [109.81.17.171])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fc177dafsm936339475e9.4.2026.04.27.00.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 00:16:32 -0700 (PDT)
Date: Mon, 27 Apr 2026 09:16:31 +0200
From: Michal Hocko <mhocko@suse.com>
To: Minchan Kim <minchan@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
	hca@linux.ibm.com, linux-s390@vger.kernel.org, brauner@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [PATCH v1 2/3] mm: process_mrelease: skip LRU movement for
 exclusive file folios
Message-ID: <ae8NT0tLt7eBmH6j@tiehlicka>
References: <20260421230239.172582-1-minchan@kernel.org>
 <20260421230239.172582-3-minchan@kernel.org>
 <aesg-sj6_VmXyqxb@tiehlicka>
 <7c7da8ae-cd39-4edf-b94f-c79ab85df456@kernel.org>
 <aevBRh08X4UTMUj9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aevBRh08X4UTMUj9@google.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AEA8C80003
X-Stat-Signature: 91jujthgcb1hfcdxeyjfwbqand38hykn
X-Rspam-User: 
X-HE-Tag: 1777274194-622734
X-HE-Meta: U2FsdGVkX1+mX8FdqqGSPxQN46LmJHtAuBTbGiRGpR4x9H3IvgEIxk6lehZLFMaifg6oLW4AO0ljSUN9UuAxyJmQxnKpzNeFwcMDR7VD6YOE4WxUQsoI3nolsAPhgc02Yd0AWjpgRknJrfXgjtStOHzRYeccOdT7CmyfQhVGIX2+vfoelNQssFnX0MAPTYWLrvyeJNf7oy6iiehzwA8PPk8RAZLGU0/k7M9luaib+dv+Fmijh3FZNWa87k3Ohx2Euv/a51IkWc1dxQ2Ced2F5dgngKGRY5avas8xq/cMxQqz9CqmJZnJlo0xAFqqDXAwVNxAHMb4CodgV0ak4Pq9b2p4QnV9lTRB7Hi/jesEPmO8mj6BBs9Ak6A0/3OWNqqLThxiUYgPE3sKW+PXBHBe0kX0rv9IimZm4ZXr2S4wL69x8jHcxGDDB7zO9v53BElf8ZqwRdHGBHf3ZntNrh2+E2FfVi1wP1IO2ai1iCyj3Pug0+Z271Xc+G/gwpGPuWmvTcVYpD8wKaGfNyAx++y9lNT9s9N2bnvLGaK8Wrh3ZUPnMr2Nwgnb3NA6aAsFmhDd6uqCsvgWV3zCRaIZryyiC5I4Cfa52qUwhXOO0GP8S6N8MVJwG3ogE7O1TTX2M3HhlYNMhH1y/Fk7r0BkPdy8eK1/y70dOJDRXkXc/0noTMsbJCoghOD7oni/qmefzTVKesqbvxbsuc7z9WBrtlFIJfxfAysosC1li/VRrOOaypMaFBjtnRSliq9CDqtmuo2ejLA1u8byuBmhyjDy6i0Hqg8gt3FmdKj+gyYNwoNF0Yh9gM+RlIXZP8lw1ORxPw871J5F5ajwg7uQG5GLXMvbzlKoi28FXb2YReIA9h3Rc+361BA+E0McDei7hYABz/XAHw6ZgojnFledzIqC/ZP7DIna7lge+HKVD084q9teJLoLWPrbSBu6KPsgBjXHazF3UzU8LEx2zb5EM5ZWPl8
 zUklHIKV
 zEUsTknESAanLtGaKBKSC366e62DRNQQBwEPmO9QcGL85kAvBCKao9AR+Auzt0lZJc/ZF18gD9iuarw7Ak+uQbg+t115UErGckox1YW0BQcMYA/OPvwPmrZpqNr++EgWw8rjA6pxLN11MgKAgqB9z3NwsENi6tAEkfmTE64lORRubiQfMeqiUxtIP9DO4HhRcbtjjHaNj3+EkywuZ2rcqftKBUcL68ERBKs0Oiy30xal4aM+665VPEdFeKhExIb97CPscbqjFEarDJ13B2gEb5QuNXQ8fmdovqIzq+DpTG8d8BB4ha7APym6z/6r4j0FtzlpBshQyWAdw+evH6tTgSE7Opz134Q197C8gbWqqT5YAY02E2kidHlgEL5xdAUTelx2jH7Dc9ij009p23wLlA3M5dnrDx4jrMdrWq36gTH9/G4E8VZk/naOuYbYG2hn7EpMhLcfJC5hCw+Sem4myvKp5/ASv9K+F0yrgEnfn0zwIpaZq6kXZXfzh8LvYYFV9kkxN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 24-04-26 12:15:18, Minchan Kim wrote:
> On Fri, Apr 24, 2026 at 09:57:16AM +0200, David Hildenbrand (Arm) wrote:
> > On 4/24/26 09:51, Michal Hocko wrote:
> > > On Tue 21-04-26 16:02:38, Minchan Kim wrote:
> > >> For the process_mrelease reclaim, skip LRU handling for exclusive
> > >> file-backed folios since they will be freed soon so pointless
> > >> to move around in the LRU.
> > >>
> > >> This avoids costly LRU movement which accounts for a significant portion
> > >> of the time during unmap_page_range.
> > >>
> > >> -   91.31%     0.00%  mmap_exit_test   [kernel.kallsyms]  [.] exit_mm
> > >>      exit_mm
> > >>      __mmput
> > >>      exit_mmap
> > >>      unmap_vmas
> > >>    - unmap_page_range
> > >>       - 55.75% folio_mark_accessed
> > >>          + 48.79% __folio_batch_add_and_move
> > >>            4.23% workingset_activation
> > >>       + 12.94% folio_remove_rmap_ptes
> > >>       + 9.86% page_table_check_clear
> > >>       + 3.34% tlb_flush_mmu
> > >>         1.06% __page_table_check_pte_clear
> > >>
> > >> Signed-off-by: Minchan Kim <minchan@kernel.org>
> > > 
> > > As pointed out in the previous version of the patch. I really dislike
> > > this to be mrelease or OOM specific. Behavior. You do not explain why
> > > this needs to be this way, except for the performance reasons. My main
> > > question is still unanswered (and NAK before this is sorted out). Why
> > > this cannot be applied in general for _any_ exiting task. As you argue
> > > the memory will just likely go away so why to bother?
> > 
> > I think there was a lengthy discussion involving Johannes from a previous series.
> > 
> > That should be linked here indeed.
> 
> How about this?
> 
>     mm: process_mrelease: skip LRU movement for exclusive file folios
> 
>     During process_mrelease() or OOM reaping, unmapping file-backed folios
>     spends a significant portion of CPU time in folio_mark_accessed() to
>     maintain accurate LRU state (~55% of unmap time as shown in the profile
>     below).
> 
>     This patch skips LRU handling for exclusive file-backed folios during
>     such emergency memory reclaim.
> 
>     One might ask why this optimization shouldn't be applied to any exiting
>     task in general. The reason is that for a normal, orderly exit or just
>     pure kill, it is worth paying the CPU cost to preserve the active state
>     of clean file folios in case they are reused soon. Preserving cache hits
>     is beneficial for overall system performance.

This is a statement rather than an explanation. Why is it worth paying
the cost? What is different here?

>     However, process_mrelease() and OOM reaping are emergency operations
>     triggered under extreme memory pressure. In these scenarios, the highest
>     priority is to recover memory as quickly as possible to avoid further
>     kills or system jank. Spending half of the unmap time on LRU maintenance
>     for pages belonging to a victim process is a bad trade-off. If speeding up
>     the victim's reclaim by avoiding LRU movement and evicting cache negatively
>     affects the workflow (due to immediate restart), it implies a sub-optimal
>     kill target selection by the userspace policy (e.g., LMKD), rather than
>     a problem in this expedited APIs.

Your change effectively boils down to break aging for exclusively mapped
file pages when those pages should have been activated. All that because
the activation has some (batched) overhead. You argue that the overhead
is not a good trade-off for OOM path because those pages are exclusive
to the process and therefore they will go away after the task exits.
The same line of argument applies to task exiting normally too. Task
exit it not the most hot path but certainly something noticeable,
especially so for huge tasks.

All that being said, you really need to focus why breaking the aging is
a worth optimization. Keep in mind that while the page might be
exlusively mapped it could still be actively consumed from the page
cache and breaking the aging could lead to refaults.
-- 
Michal Hocko
SUSE Labs

