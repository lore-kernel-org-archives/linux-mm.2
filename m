Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E9E7FF886F
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 06:56:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EF6C6B008C; Tue, 28 Apr 2026 02:56:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49F556B0092; Tue, 28 Apr 2026 02:56:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38F586B0093; Tue, 28 Apr 2026 02:56:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 255D36B008C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 02:56:42 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B3D1A8B4A4
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 06:56:41 +0000 (UTC)
X-FDA: 84707056602.16.F004AE8
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf16.hostedemail.com (Postfix) with ESMTP id A7D0E180004
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 06:56:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=RwZeCqnz;
	spf=pass (imf16.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777359399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B20i2WYVNCTtPC1H0a1XPOVbe8oJoCNkE6Fhoj7KHNQ=;
	b=PV0GHVPKshgaMvnZSr6lrzfoTM7JdI9L63JWXV0hG98cIkGDgE+hqgIL8K6j/e6TOQAfMq
	7KpD6dHCgnoqqC+qJPr2rXTBCFTAiBrRFusqbSUC663LH4cnneoScXfmc6Z5K6xYwEmEc8
	VP1bGnuuVLOOtTQQF75RrOGxAkX0Ba8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777359399; a=rsa-sha256;
	cv=none;
	b=c5/pFXXMk24seGKT1VjvSvKU/F4dkUIOSlS1tcG1A9AlLQR8GTxseOo3lZHNknXSVKSs4y
	9qMiVj/+qG3Z8on03flPImYrRWPmP+EmAROszgPi9eO3mAX4D+AahdMhLJKp2RzgPKKTUu
	J7g5+6/XlQFHSWcOB8oWJ5nG7F6MWJ4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=RwZeCqnz;
	spf=pass (imf16.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-43cf7683a28so7319619f8f.2
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 23:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777359398; x=1777964198; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=B20i2WYVNCTtPC1H0a1XPOVbe8oJoCNkE6Fhoj7KHNQ=;
        b=RwZeCqnz4WG2fx9nQQa0i3jdmtA2rbfH3OvxJROnuu9QuqYJnYzedxjaw7w66pp725
         SSDImBijcSEEOP3iBy7j+48A7EJ2W8ukYt+b0PGUYl63DlhaPIjZGF258a7ocyYxvlB/
         ZwJaACQ9XL9ABosn/knn129tpDBj+f7EI7fudHPmGFK608L7zkofclHIV//G3L31iiTW
         fRnM+8spr2v8dhT4j9osYmtDSJParM+K2BYG4TJdlZNVu11bnln0/icgbOTf6Pz6djtN
         Uc625MEcHbLqnZnDeAimVLfRc7MOq+TVwRrnadlfKV5vAeVT67FG0H8akvONFE/TdEjl
         kIKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777359398; x=1777964198;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B20i2WYVNCTtPC1H0a1XPOVbe8oJoCNkE6Fhoj7KHNQ=;
        b=JtVa7tSehQfuepoEpXrbQL6KJSIwt/BRr/xKrZzZNknofloasnjJWf9MP9LVXVdj6u
         27xpn5RDq04/m9f+Ieed3+ycvckcmzrvYuA2TPjaDJp02WuYkJeYKx11f0I7lracVi6s
         gQdSwrUKybT7Lvei4ecxMY+a5WbFiV8EexNZmpA6zHHMhn2vnty1yZ0GFOEH+wCunN6n
         uqVjtIriTX3+IcpsdjGfvkazLpuDtQHBGqP/LbSC+7hJYpOQVTBphlSSvKRRKEbHKOhI
         hJXm7OX5Ldn9G4PPkRTSyKvkIxE1Z8kuutFSgmsoulNDcRNxM1lTVz7neTH5HHnxtb8X
         WOuA==
X-Forwarded-Encrypted: i=1; AFNElJ/FZmf0CGQglO+TiRVoX5/GdZiw8z3U41n9iY2ErqtjnKYU3g3MYYjf3M79QZ7Vhv4F66PhEJqWWg==@kvack.org
X-Gm-Message-State: AOJu0YxMQ6PgFMn1D/gvvU0ia7KAUg2x9AZkGlyFXswMUoXOHk9AYjtb
	Yia7B27Q+KY5RvU+Bqq3qc1R2fDvAweBPgtvwb38yCEVHZEiRBMEPqdgoSFQeeSpwcc=
X-Gm-Gg: AeBDieteXKocOM5ed1cfziUD2dgSeuNOjTiQ/vx03JDXQoG+GSUe3FrIJsmnQu/ZD3o
	dM6jGo2OGYzMo1BKixH+wr1hMsoZb5dQE0bK9g8YaxVageXhFRNlssDJcWJ83ZVRe6blIW8t4gk
	0JN4efssmxRH9pxelNqyK6f6YR1Td+RVfpJ3iHs50ww7hXwmnGtcnDuW3C4S/rIRe1ADeCbIY6i
	eC31v/MHcvBlvaM5bEIVVoUlL0yeUYc3+t8HAHTNmBn/rlKoFOfTkYXct2omyOlGidLYVXaIn+U
	JXbVJFvRluLMAMZELz7QT2WNkPqIg+D9y0FUKyMvnpHTHAvx5cFeTBJEpqM4ET51UzBiPZxQUzb
	/SbJ2VZlCkAyyoN70tpvbFmnIjC+JN7flOvDdYiF4xZL7GRaMmjOoQf0j9+jQCpmRa1lHk0g4gh
	lS6aBHG3HWFlp057FYrAEbw7gXuAcGQdoQe44We/XhH01EuOY=
X-Received: by 2002:a05:6000:2511:b0:43d:73d4:b34 with SMTP id ffacd0b85a97d-44647dd1544mr3185020f8f.16.1777359397775;
        Mon, 27 Apr 2026 23:56:37 -0700 (PDT)
Received: from localhost (109-81-17-171.rct.o2.cz. [109.81.17.171])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4463f5b50c1sm3831876f8f.17.2026.04.27.23.56.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 23:56:37 -0700 (PDT)
Date: Tue, 28 Apr 2026 08:56:36 +0200
From: Michal Hocko <mhocko@suse.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	akpm@linux-foundation.org, hca@linux.ibm.com,
	linux-s390@vger.kernel.org, brauner@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, timmurray@google.com
Subject: Re: [PATCH v1 2/3] mm: process_mrelease: skip LRU movement for
 exclusive file folios
Message-ID: <afBaJLLFigkdszov@tiehlicka>
References: <20260421230239.172582-1-minchan@kernel.org>
 <20260421230239.172582-3-minchan@kernel.org>
 <aesg-sj6_VmXyqxb@tiehlicka>
 <7c7da8ae-cd39-4edf-b94f-c79ab85df456@kernel.org>
 <aevBRh08X4UTMUj9@google.com>
 <ae8NT0tLt7eBmH6j@tiehlicka>
 <CAJuCfpHQdA7C50V2WjNrdYcp7feV5ukgxJf+vMNEcp0P1SGEow@mail.gmail.com>
 <ae-Zu-VAzAA7SdLa@tiehlicka>
 <ae_roPR64e6sY_fN@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ae_roPR64e6sY_fN@google.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A7D0E180004
X-Rspam-User: 
X-Stat-Signature: d1yewd9pq5ti8y5ppb5chxhsjstnmy7q
X-HE-Tag: 1777359399-934211
X-HE-Meta: U2FsdGVkX1+2kOyx6/pybVymTJfizRLzgTMdSKhnmd5V6Yr/ykCmOSb52y4zYu0pMQJueZKCVGqGaZibwX/1HnPP4j9CfkldvmZpdqArH7BqLjoA2z0IGzpqc1CiXAe3oE3yHDjBFCssRKBfPVWZCW7bO3xAdyN39tYfXybyA9ayvJ0SkaJu/TfOa3yEnEW4uJP7vWJkS6ZoxUcLuQeoGX7t71DQndXcyhG4uXseofNbTh13FJDs5T97iCFPc1ylbbaCE/1FAsPmcv4/YNnpjZzcO4zXNiyFo+aeIsx+Rb9yQsg8AhqM6Vuue6xVGDPcFXnyXJvQYe6LG92B0rj9VxDGaaH+cX62iTACzNScW2b7pl4gMSmkbyat7p9J5IP3VWPQ+P5Lhl3ppZSyDBydnToUSvNGWLD6DfIVMyA4IyYdKHJeymnNr5UFbsbM+TQwLOf5ehehvxwkUwLd4WMKjWW4TminFGEoHzism/y7H0gx3S1+7sYorwlAinmOaEUhTK87UEmnSRXkqAE4Kht8K04iYpEfAnw4wmFxHgmdLjQ5c5iklnaGDIibP1HQZADp8qtWUGkderzwZfKMk1kaFwitQS18xLpA5sH3wruWH7mORpbIVb7AETThCXBSBu/Foaugq6KCrDNT8wcfuOUAytXvSnQ3ypmIAI5iNv1zbyFlMrkaGSxeDAusThPu2c5M0RXOK/kN0YuZrOd2Ge11uJ5D48qMavp3Im8Ju8FGajKwnkELgL61/6aD4NcIdYhnoOopM8Qcy3GOU7XtUVlr9doP/qEmxRL9bTj+hXqNkin8vlCSG9d06W9shAScljtdkmY/Z86aNa8kqc1/JBhmQ+IMHrF3mx/MHjYoRlvSe5HvQiatsrUo7au0X5bJS7KScoWnhNsHI8/+jry4D0JYNUW25nBYdRq96nGMLe8rF0/6Y3Sp8Nusy+/9S7qw8odw/wIqQGTfqQfWyurkuOL
 YLm1itfH
 tV+9j8TfUiEHaeWVwSfCZJjvmdsPK+CuZyEUhRo/3fYgwr5Ke1zqtz0tWPT/zgEA31rUvBV7rmOeI0KnG0B+df0WxGSonM7ZlN48U7xEtjDEnfDt40jKO6qCkgHN9msORw1GEl3G+hEajeoZUGiua1FZLmow5WbXsgErM/nht0ZQ/PsG4P5H+Ef+QHlVl0rE/9Yde2yvS9mS1ScL/AbBd3ZQBw3efKW2a6kwYo01EjCSri4vdaGhGuMxdPxwe/Rf8sThCEUaxf1le45SHMZMgQYNWYiJsQJFu/KsnbOtVdJgMhocl+wkEzfcSf0gVDVMc3uSTHFE5MGreVSkK7XrWJL4LT+0z9g3iuoJVV0pXQit9ZzPUFfB2E+byru0VpXXVG5fZQOJu/aesJJoNWRMOrmaMfo4H1W5My87omFPObQFITX43AxbtLM08vAHVZweW8wNk05IX7jZ1ZWihuVPdWy81iqy0R/7rhvQxZ4phM0wjRbawmCI0SAmkRxTv/FXH9bwBXl5xjWi1PjpZIbkQ4z0Eb5MJLEjU9ATxMf+d4Ae2yFQHFF8Y4F+OaR6+pjZFE8ALpanXrIjK40qSLNRBoXl0BQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 27-04-26 16:05:04, Minchan Kim wrote:
> On Mon, Apr 27, 2026 at 07:15:39PM +0200, Michal Hocko wrote:
> > On Mon 27-04-26 09:48:28, Suren Baghdasaryan wrote:
> > > On Mon, Apr 27, 2026 at 12:16 AM Michal Hocko <mhocko@suse.com> wrote:
> > > >
> > > > On Fri 24-04-26 12:15:18, Minchan Kim wrote:
> > > > > On Fri, Apr 24, 2026 at 09:57:16AM +0200, David Hildenbrand (Arm) wrote:
> > > > > > On 4/24/26 09:51, Michal Hocko wrote:
> > > > > > > On Tue 21-04-26 16:02:38, Minchan Kim wrote:
> > > > > > >> For the process_mrelease reclaim, skip LRU handling for exclusive
> > > > > > >> file-backed folios since they will be freed soon so pointless
> > > > > > >> to move around in the LRU.
> > > > > > >>
> > > > > > >> This avoids costly LRU movement which accounts for a significant portion
> > > > > > >> of the time during unmap_page_range.
> > > > > > >>
> > > > > > >> -   91.31%     0.00%  mmap_exit_test   [kernel.kallsyms]  [.] exit_mm
> > > > > > >>      exit_mm
> > > > > > >>      __mmput
> > > > > > >>      exit_mmap
> > > > > > >>      unmap_vmas
> > > > > > >>    - unmap_page_range
> > > > > > >>       - 55.75% folio_mark_accessed
> > > > > > >>          + 48.79% __folio_batch_add_and_move
> > > > > > >>            4.23% workingset_activation
> > > > > > >>       + 12.94% folio_remove_rmap_ptes
> > > > > > >>       + 9.86% page_table_check_clear
> > > > > > >>       + 3.34% tlb_flush_mmu
> > > > > > >>         1.06% __page_table_check_pte_clear
> > > > > > >>
> > > > > > >> Signed-off-by: Minchan Kim <minchan@kernel.org>
> > > > > > >
> > > > > > > As pointed out in the previous version of the patch. I really dislike
> > > > > > > this to be mrelease or OOM specific. Behavior. You do not explain why
> > > > > > > this needs to be this way, except for the performance reasons. My main
> > > > > > > question is still unanswered (and NAK before this is sorted out). Why
> > > > > > > this cannot be applied in general for _any_ exiting task. As you argue
> > > > > > > the memory will just likely go away so why to bother?
> > > > > >
> > > > > > I think there was a lengthy discussion involving Johannes from a previous series.
> > > > > >
> > > > > > That should be linked here indeed.
> > > > >
> > > > > How about this?
> > > > >
> > > > >     mm: process_mrelease: skip LRU movement for exclusive file folios
> > > > >
> > > > >     During process_mrelease() or OOM reaping, unmapping file-backed folios
> > > > >     spends a significant portion of CPU time in folio_mark_accessed() to
> > > > >     maintain accurate LRU state (~55% of unmap time as shown in the profile
> > > > >     below).
> > > > >
> > > > >     This patch skips LRU handling for exclusive file-backed folios during
> > > > >     such emergency memory reclaim.
> > > > >
> > > > >     One might ask why this optimization shouldn't be applied to any exiting
> > > > >     task in general. The reason is that for a normal, orderly exit or just
> > > > >     pure kill, it is worth paying the CPU cost to preserve the active state
> > > > >     of clean file folios in case they are reused soon. Preserving cache hits
> > > > >     is beneficial for overall system performance.
> > > >
> > > > This is a statement rather than an explanation. Why is it worth paying
> > > > the cost? What is different here?
> > > >
> > > > >     However, process_mrelease() and OOM reaping are emergency operations
> > > > >     triggered under extreme memory pressure. In these scenarios, the highest
> > > > >     priority is to recover memory as quickly as possible to avoid further
> > > > >     kills or system jank. Spending half of the unmap time on LRU maintenance
> > > > >     for pages belonging to a victim process is a bad trade-off. If speeding up
> > > > >     the victim's reclaim by avoiding LRU movement and evicting cache negatively
> > > > >     affects the workflow (due to immediate restart), it implies a sub-optimal
> > > > >     kill target selection by the userspace policy (e.g., LMKD), rather than
> > > > >     a problem in this expedited APIs.
> > > >
> > > > Your change effectively boils down to break aging for exclusively mapped
> > > > file pages when those pages should have been activated. All that because
> > > > the activation has some (batched) overhead. You argue that the overhead
> > > > is not a good trade-off for OOM path because those pages are exclusive
> > > > to the process and therefore they will go away after the task exits.
> > > 
> > > I think Minchan's argument is that mm reaping occurs only in special
> > > conditions (under high memory pressure) and for a very specific reason
> > > (to free up memory and prevent system memory starvation). Therefore
> > > priority in such conditions should shift towards more aggressive
> > > memory reclaim instead of normal aging. I can see both his point and a
> > > counter-argument that this might cause more refaults in some cases.
> > 
> > The way I see this is that the standard memory reclaim under a heavy
> > memory pressure would likely encounter those pages and aged them
> > accordingly already. So this is effectivelly racing with that process
> > and makes a potentially opposite decision.
> > I suspect that a lack of memory reclaim, as implied by the other patch
> > (to deal with clean page cache), is the reason why this one makes a
> > difference in these Android deployments.
> 
> The claim that kswapd would have already aged these pages is just an
> assumption; it is ultimately a matter of timing. We cannot reliably
> predict whether kswapd has processed them, nor can we know the future
> access patterns of a dying process.
> 
> Global system policies are not always optimal for every specific use case.
> That is precisely why we have hinting APIs like madvise and fadvise.
> 
> While hinting APIs can indeed conflict with global policies, a negative
> performance impact would imply that userspace is misusing the API, not
> that the optimization itself shouldn't exist.
> 
> We should view process_mrelease() (and this flag) as a similar hinting
> mechanism where userspace explicitly requests expedited, aggressive reclaim
> for a specific target under memory pressure.

This is you bending definition of what process_mrelease is. And I
disagree. There is nothing about aggressiveness for process_mrelease.
There are no aging assumptions. We do not have an official man page but
this is from the initial comment introducing the syscall
        DESCRIPTION
          The process_mrelease() system call is used to free the memory of
          an exiting process.

          The pidfd selects the process referred to by the PID file
          descriptor.
          (See pidfd_open(2) for further information)

          The flags argument is reserved for future use; currently, this
          argument must be specified as 0.

Userspace oom killers are one obvious users of the interface.

> > Unless I am completely wrong and misreading the whole situation this
> > might be very Android specific change. The question is whether these
> > side effects are generally useful for other worklods. So we really need
> > much more explanation of the actual behavior after this change for wider
> > variety of workloads.
> 
> While the primary motivation comes from Android's LMKD, this optimization
> is not active for normal workloads. It only applies to tasks that are
> already being reaped by the OOM reaper or by process_mrelease() with the
> special flag (via MMF_UNSTABLE).
> 
> Therefore, it is an opt-in or emergency-only behavior that will not hurt
> a wider variety of general workloads unless they explicitly use this
> targeted reclaim API. Any system with a userspace killer needing fast,
> targeted reclaim can benefit from this.

But any user of this interface will see side effects of your
implementation.

Look, you haven't convinced me that you are fully aware of all the
consequences. Your arguments are weak and you seem to be uninterested
about usecases beyond your specific Android LMK implementation.

So I am not in support of this change, same as with the page cache one.
Again, I am NOT NAKing this patch but I do insist a) the patch
description is damn clear about side effects and b) there is a support
from other non-Android people using this syscall.
-- 
Michal Hocko
SUSE Labs

