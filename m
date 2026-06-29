Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3818DC43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 07:35:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D9566B0096; Mon, 29 Jun 2026 03:35:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B0716B0098; Mon, 29 Jun 2026 03:35:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07A486B0099; Mon, 29 Jun 2026 03:35:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D34E16B0096
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 03:35:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 37268405D5
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:35:33 +0000 (UTC)
X-FDA: 84932140146.09.542CC33
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id A620340002
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:35:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NrsYCe4l;
	spf=pass (imf07.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782718531;
	b=rxKhzOEChr6CoB9KrumTjDayYQ8XT4X1XUogcFcTuuPE/5cEwxsd7YeMGH8T6yWJFW5/Dj
	1iH+Mkmu0NxbLNpox3yMuq6EpHSs2uyA9gwAbRX4Eyd+or4A3yYUXcB+QZFskumrdYMu0i
	twxgzkR06NcUu7LF21L/jHlcX+6mvtw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782718531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YhwD5e0TAt0qKmZwhk19yeLkiMwZuJytbMfHyxkkjWg=;
	b=lCU9KHzzzvZci3Ho6bazfeYXXoHpGr7ZQ1s2hXIfHlMPog3N4UUIP2ecX6aIGkMknM6Iz5
	8pDY7+h90MrokidHBh+/uzVdbiH8PbJuH/e88sNxVsXZJh0pWAYGrQuEwTn6EtCIbmOy7l
	lFFRc0SjcHRdhI2np6ElanJex+v3x0Y=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NrsYCe4l;
	spf=pass (imf07.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782718530;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YhwD5e0TAt0qKmZwhk19yeLkiMwZuJytbMfHyxkkjWg=;
	b=NrsYCe4lkbGRXXDxbf8zEDn90dTgOi3w9K2JSEOuNgERgRirHZzOgyG0dcDJLw3RvvFdLa
	ekdTAOJHzPVsAeUxlGPrspN6BycLtTvrlS5+aMm0G87P4HcKKcGAED0yp7yWatGxRe/JXf
	UcuVWh5C3qxdfOUVNl6xyoOv3cEydt0=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-407-blsJRQ3KMia5UsSyMj-Sfg-1; Mon, 29 Jun 2026 03:35:26 -0400
X-MC-Unique: blsJRQ3KMia5UsSyMj-Sfg-1
X-Mimecast-MFC-AGG-ID: blsJRQ3KMia5UsSyMj-Sfg_1782718526
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c88cfe287e1so1640546a12.1
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 00:35:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782718525; x=1783323325;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YhwD5e0TAt0qKmZwhk19yeLkiMwZuJytbMfHyxkkjWg=;
        b=Rs8v8r+/GbnDUNSVwg+O18ZcTnNqNErN6GA+UhAejkw539F154YdJm36L9e83OFqwX
         pJfHoLnghWro1wHHmQkuy5si2R7WVhuZc2iw7S+BKI1kFku9zrLZFVshllSlCutdSPg5
         IInppUvVCo+Oj4XsEoo9WorTXtGU+XafNOBuXQHjbpWKG31Vf97EENfz7u4IUzhLm9I9
         gxzZV7IJ8hJeTrhuo/TAmIeicT3toKO5NK9j/RTRAwENsSXXoaMXK6ig84GLMaAGhWqG
         ry3PTqq7BjTPkoFTyIl5U7ekkHMZLlklylrhgmimkVc0T2fEEZQi6cEYpkAEtHjkCPrD
         LZnQ==
X-Forwarded-Encrypted: i=1; AFNElJ+qQ1d5CsId9zBt3OswyzC8lAnCIYwimPM/clz55Mfn075Llls9dXh167pmqBh5zCyD8LfdSZ0Hrw==@kvack.org
X-Gm-Message-State: AOJu0Yx4KH/sMOMOAtccoIkZGcA/U54LOvKFoNP/MhjFXFjAa1ISKsNA
	6ufSF4u8h6dNBohB7bS/MX/oMth5wusGguTEB5v2kEdXZ+Ai0s6ql7dFpCQ26S04esysaTSaLhv
	NEvZCa0prVFvbmq3C1rWgkOHKRQnGXwwhJy9Zox4zIQFccg2/VLZ7
X-Gm-Gg: AfdE7cki5CrUSmWYtVIwrRmG2m4BIhf+C39B/6lengcQgBvI1eCmTpIw0g/MLaSdQ4n
	w9gwFp0bUMU3/p3Qt6flqK8mE8sW6Qhd9n1fPU7kMoyEKC9g5e5u31C79RlAB+QW+eV7Q3VA56n
	29MmdNdeUbhCJfygfUbEaTm59TUS2gLeYgNE4DFk37zFfr9s9B3W9P6rVopHow7HWo9hX4If9Sv
	V+et009h9V/+8w/uIAVk5/sly+HPVO1ssZygj9Lk2mklyKvDhKfdnoUquigbbTLBXduleitU7np
	EVf9awLtR8gWWhNivJPw7cj4VIiOlKg746peu+EIonrV3pidTFsb5rh2cua6QLXnGX8XWKgyce5
	0UY3wPlJ2lPVfZMFD9UqLAEZZHML5l/MM
X-Received: by 2002:a05:6a21:a08:b0:3bf:79d6:f063 with SMTP id adf61e73a8af0-3bf79d740bdmr5424841637.43.1782718525443;
        Mon, 29 Jun 2026 00:35:25 -0700 (PDT)
X-Received: by 2002:a05:6a21:a08:b0:3bf:79d6:f063 with SMTP id adf61e73a8af0-3bf79d740bdmr5424801637.43.1782718524686;
        Mon, 29 Jun 2026 00:35:24 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c92bd55985asm7323848a12.31.2026.06.29.00.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 00:35:24 -0700 (PDT)
Date: Mon, 29 Jun 2026 03:34:59 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andi Kleen <andi@firstfloor.org>,
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
	Rik van Riel <riel@redhat.com>, Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>, Byungchul Park <byungchul@sk.com>,
	linux-mm@kvack.org, linux-cxl@vger.kernel.org
Subject: Re: [PATCH 0/2] mm: memory-failure: fix HWPoison flag race with
 non-atomic page flag ops
Message-ID: <20260629030657-mutt-send-email-mst@kernel.org>
References: <cover.1782676497.git.mst@redhat.com>
 <0b5f8b4b-d7dc-4b79-9555-a5b36265f3a9@kernel.org>
MIME-Version: 1.0
In-Reply-To: <0b5f8b4b-d7dc-4b79-9555-a5b36265f3a9@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: exVfBRWyA6k6s7BSxHqUQaAFLbzM4aG_RQgkvt18v_Q_1782718526
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: g49crqsjwk31d7ksdezxatiqqgwdkox9
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A620340002
X-HE-Tag: 1782718530-803955
X-HE-Meta: U2FsdGVkX19eZydgbTkK+fN8dqFAVdD/drksUxTARXdHH51i+iu3c9Xs5ou9XKtCcxRSiLEZNf15Zj9K8QeJcUHb/7pQGSnGYp73zrKdruJWGZrMjJapJcFaC3DROi4xhIVVr+kXAptubUIYVPEFOdj2ur1DOjZ12md0KIQskz5hItQ9KpUabiRjVNBWQ5K1VDm3bUoActOwmHi2L3h8yy7V0eFGQIIotb1K5Q4JhZxUPrmqUMdZ54IDRG6I/mraUMG3X9eAsizhDLWWjxnyKtmupSOZllBAUBnVBZYo0zICWoFsp6Z3WPuw4x7lIEBFXW7aj/9tOsuNKPMdockJCE//FuQV4LDXDBm3vtb3ER1rne0ZTi1YRy3jVWclqZEd/iO/rnZv/M1YP6vThJz6MZCSMU4D5ikeTrBd8FoDEdn/vJIg/rq3rKELlca5Ct+bMHUdch7EWNRgkl/WrbL8fzK4My740FQB3zXFEPoRQf3Qef51Hwv+0It84IKCs3U2jmO15igpYStmXX29nwhjypJVsRP3QjruSB7vDdzar2o1YKUXB9NoB7CcOoI/5B8T8Dlm2yEb5svx39ThIRqKh43NgdbgdBzrlUKd0Fw/uD9AL0dgpl3i49wYuB5bNlynKJv5RFQ8GMwESm80RemGm2ScmYybXQcu5HgMJNqfzgjzoNNDqlWSxh8Kyr3C+wG9iOCCjAMeEyDPx2eh2cw90DUo64LZoOTFweHKR4imBaPvuzqqzr/jDfLiZGFCW+cGAWEZ3EvSoiZnA9lvfb+yEjGZAMeEpIPR6FYd5i6SxzURNq5e18S/HFjfyIlluXR7zAQ0b91V1Rx3Hnzam+mQFqB+SQQ3NRrcCwTqZ9nUEHG+k/OglhPf24Sx7hoRGHHN1U7PQ+CHD8kPoW7QWa3R4BUapPZ6M1iZKbYW79ZcCFDfhXPIQiIaUz5uvmCiXZlzHVb8rFDVyfRgbE66dz6
 UX1r01AM
 sEayP7/lOHnIDnFjZ7rcEeqdxqLngvSGLlq2utNdl1AwIUpu8SFRPUTEppTOFqIQbnax1e1wYakYwUxynKPNpKWDoC2z4H1iHnjU9xhQyMriOvFNBCpWqY+JijhiqGLHfR3890HnhjmUk4MMUEw9Jy/ChdirJrrGLxwsaLhRIAM59wDK28ElCjxSvBecVC/+cCA8LP6GPlKI7Cfq27sMnaM8NR1USm/bvCrANgomRuJ7wBj7u9JDbX/dFd9se/Iq6JuJSZh9Ve3EpHS0yUMH7QgH17H63vzLzZU2gK2Vfzm+ZCy4XLsPL+9T73UsUUEJYuoBhdzT3PiIEL80P4zTAg/iQKUIVTqTEDRmZSLeFml4rKG4w8xyVGPcIxPua4UgibT7zYAZ4wVybeLDLpSCMZOMN1+O3tywJOJraiprhrmJU0637hL8kNnVKqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 08:49:37AM +0200, David Hildenbrand (Arm) wrote:
> On 6/28/26 23:45, Michael S. Tsirkin wrote:
> > I don't like it that we are adding overhead to the good path for
> > the benefit of memory failure, which never triggers on many systems,
> > but I don't have a better idea. Pls take a look.
> 
> As I said on Friday.
> 
> "It's also doesn't address the mf_mutex implications and the x86 thingies I
> mentioned.

Well I did attempt addressing this.  These would be these two:

	(a) We don't hold the mf_mutex on all call paths, but we really need it so a
	page_test_set_hwpoison() cannot race in weird ways with the other primitives I think.

page_test_set_hwpoison was this code you wrote:

+static void page_set_hwpoison(struct page *page)
+{
+       lockdep_assert_held(&mf_mutex);
+
+       while (!PageHWPoison(page)) {
+               SetPageHWPoison(page);
+
+               /* Make sure concurrent non-atomic writers completed. */
+               synchronize_rcu();
+       }
+}

and indeed the test+set combination seems racy.  But consider the version I posted, for example:

+/*
+ * Drain any in-flight non-atomic page flag operations that could
+ * clobber a concurrently set HWPoison bit.  Retries until the bit sticks.
+ */
+static void set_hwpoison_drain_rcu(struct page *p)
+{
+       do {
+               synchronize_rcu();
+       } while (!TestSetPageHWPoison(p));
+}
+

...

+static bool test_and_set_hwpoison_drain_rcu(struct page *p)
+{
+       bool was_set = TestSetPageHWPoison(p);
+
+       set_hwpoison_drain_rcu(p);
+       return was_set;
+}



does not seem racy without a lock. But maybe I don't get it.



	(b) There are some leftover SetPageHWPoison etc. instances. The ones in
	arch/x86/kernel/cpu/mce/core.c likely cannot grab the mutex, but maybe they are
	corner cases either way and we can document the situation.

Well, I did try to document the situation - it's in the commit log for
patch 1:

    Note: the MCE handler in arch/x86/kernel/cpu/mce/core.c also calls
    SetPageHWPoison() and is subject to the same race.  It cannot use
    the drain helpers (MCE context cannot call synchronize_rcu()).
    For recoverable MCE errors, memory_failure() is queued via work
    items (kill_me_maybe/kill_me_never) and will re-set the bit via
    test_and_set_hwpoison_drain_rcu() if it was clobbered.  The
    mce_panic() path sets HWPoison for kdump right before panic() so
    the race is irrelevant there.  The MCG_STATUS_SEAM_NR path does
    not queue memory_failure(), but the affected page belongs to a
    TDX guest whose CPU core has already been marked dead - the page
    is not subject to concurrent non-atomic flag operations in the
    buddy allocator, so the race does not apply.






> ...
> 
> I'll either take care of that myself or find someone that can work on this with
> attention to all details.
> "

> 
> This is nothing to vibe-code. This needs a real expert.

Well I had this sitting on the disk anyway, so I thought I'd post.

I wouldn't call this vibe-code - a bunch of manual work went into this,
llms mostly as a grep/sed replacement.  But hey.  I don't object to
someone taking over, for sure. Was fun, and maybe these patches will be
helpful as a starting point.

In particular, maybe I should have been more explicit about how your
points from Friday are addressed.

If you want to add a bit more to explain the exact concerns here, for
whoever works on this next, feel free to do so.




> > 
> > Non-atomic page flag operations (page->flags.f &= ~mask, __set_bit,
> > __clear_bit) can race with atomic TestSetPageHWPoison() in
> > memory_failure().  The non-atomic RMW reads flags, memory_failure()
> > atomically sets HWPoison, then the RMW writes back the old value
> > without HWPoison, clobbering the bit.
> > 
> > The race was confirmed by injecting a cpu_relax() delay between the
> > load and store of the non-atomic RMW in __free_pages_prepare, then
> > running concurrent MADV_HWPOISON injection.  The clobbered HWPoison
> > bit was observed repeatedly.
> > 
> > This series fixes the race by:
> > 
> > 1. Having memory_failure() call synchronize_rcu() + retry after
> >    setting HWPoison, so that any in-flight non-atomic RMW that
> >    read the old flags value completes before we proceed.
> > 
> > 2. Wrapping all non-atomic page flag operations in
> >    rcu_read_lock/rcu_read_unlock (CONFIG_MEMORY_FAILURE only),
> >    so that synchronize_rcu() actually drains them.
> > 
> > Performance impact (page alloc+free microbenchmark, 200K iterations,
> > 20 runs, KVM guest, error bars are 3-sigma):
> > 
> >   !PREEMPT_RCU (x86):
> >                          insns/iter      cycles/iter
> >     base:                12237 +/- 1     17954 +/- 136
> >     patched:             +22 +/- 1       -124 +/- 122
> >                          (+0.18%)        (within noise)
> > 
> >   PREEMPT_RCU:
> >                          insns/iter      cycles/iter
> >     base:                12512 +/- 3     18541 +/- 214
> >     patched:             +95 +/- 3       -12 +/- 161
> >                          (+0.76%)        (within noise)
> > 
> > When !CONFIG_MEMORY_FAILURE, all wrappers compile away completely.
> > 
> > Suggested-by: David Hildenbrand <david@redhat.com>
> 
> No ;)
> 
> -- 
> Cheers,
> 
> David


