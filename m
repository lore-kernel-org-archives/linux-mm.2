Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CC69C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 15:39:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E12D46B00F6; Tue, 14 Jul 2026 11:39:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEB486B00F8; Tue, 14 Jul 2026 11:39:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDD096B00FA; Tue, 14 Jul 2026 11:39:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A55596B00F6
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:39:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2D0281C03E0
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:39:12 +0000 (UTC)
X-FDA: 84987790944.27.7C59ACF
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5ACB3180002
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:39:10 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cQ0YtouV;
	spf=pass (imf06.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784043550;
	b=ngOtODKdtw1MjkCTpZ8/A3GwW276YRD8rG+qE19A++qpy44tgoBnjX206CHUNYMjhScrYe
	axDSe4LTWkE8WBYkDMoaAhTvBIEUzFLeUGkfOqgzuVFTqgLA8P8x3YM4hdJkM9VFEhcX2t
	9kHwtfmW35CHPdD6cZSoY94Fw7HS0Ps=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cQ0YtouV;
	spf=pass (imf06.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784043550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h2jZPg8BmRJ0mbFQa7ElFHkaNBrmZCQEMsa0xC0hHN8=;
	b=wWw365DIBtJnhR/QmkdkI9v6YqSkzjbyVbKlwZ/iR48pcMOqLKLZORQjokahPPhCYcJKYH
	HgCp8CX5uwYxNtzmWlOsnvKfUkYVcPA28xYBS/Fx2wC0ryaCRzSG+I/ILNGrTmXwaQ/aeS
	MWQurdZv4FDEbaDUGF/vbesKOZrm/zA=
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7e9ef94c0e2so490647a34.3
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784043549; x=1784648349; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=h2jZPg8BmRJ0mbFQa7ElFHkaNBrmZCQEMsa0xC0hHN8=;
        b=cQ0YtouVErgHGJskYFOnuyFWYgYztA3RcxDeFpvv8VPck3Jo4/zz4bn7GJ0BJshg9C
         rYqKpUtsLpzlQT2PzpxkGMQ7FueB31C/88jRFsRqEsOWPJOtQCu15s2MFaB2mtI8XZQi
         RddxFmZVrkXMSqxaTpsxUncSGAbx695lXWP7xVA7SiYapUmnPIeq209yICtRumHdfqK5
         dN2PR21AFck9eBJghGO18J7YBrHv8jNTpJY3SnayIq/dCVKOiylzhM1J089StffBPR0U
         L7c5MnTwwd9r2PibhchwNSlC9+OVH8Ubpnlwpn22Ks1JGUku1w/VLaYshnDZzP8YyCTY
         fEnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784043549; x=1784648349;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=h2jZPg8BmRJ0mbFQa7ElFHkaNBrmZCQEMsa0xC0hHN8=;
        b=B19npy3pA0IVf9W3SlbjuS2C7ByFJvY63bHEL7RtOSWLH20QJdP9sYS+B6h1IWerf5
         Uc87kw9eUZBmAJsnkpSiKEa0JescBDeyhKJWFEdEFQeJBrOLcqcw79zBUTqGdIV+dD0/
         hjkDJZ5QGR4wN+7Nww515i/c67w6cOkjj6bNWUXeKct3DTOelzhKZ4J2tmm7zZimnuM6
         kowHuYFrNUb9MUR6VtjxLeQ0zDSRu2nPgvTb/J0hhAIKX25GkdTbEJm5JP414dAFUEEn
         AfBMao0T4wFfiib07rE7IPXJnMvWmPa4hb/caDzNlNcPYKpMmL/HrN58LprSGKq/nEQ0
         iTtA==
X-Forwarded-Encrypted: i=1; AFNElJ9D9McPUAglRT3IYjXDcoxT/2dygRnIcukCNv+OTe5O3OeSyj1TpJBF/Ug2wwjYCC8OeknYzaaWig==@kvack.org
X-Gm-Message-State: AOJu0YyFcde8ZgG042njFUH5CM6AHNJTbt2W4agmLF9reNuhlQR3vgmJ
	jGScLd7FHFn2Z9z83rCmdJ9sFYL1SyAadm9Gz3M165PYkjLE/0Czr9GB
X-Gm-Gg: AfdE7ckQw16HvwZxRyZcz8nl6YwQNykud00wVDYGrug7xTZtQDgHGon0jWEKxPYZEGS
	mOTROOEMjWcBxjxoujtl6JGoFZE6r1c01D5uQ5/+AnLOhvK6RPKemnAf/HMtsv/ZZmiZW6Oo6Zi
	TKnronYk51VOFvFJQybIUS+zYtcn7vidKODu+2FFdPNbnCOsrgFxKA/29wjQLTaLVaLz+83lTaq
	74uOjUrb4h8/11BDI24UQrPW45bNbUyZxMuW/fbu+Ax3a7hW7lNrUywR1rqnHg8sV1djyOVydau
	DbC1DQZPlXgIBjLxkIu64DzNb7nEzo24nkXxz87mh5sexqKA5GwVLxs3T9Yjo299aBTwIswsenJ
	2pfxdWEyh5kYCeJ94yafer+0VOUs41iD1g7osKN396PiXr88pneqZEbeo/KWnSyfPyLTg/eiJ9s
	iI+kW9n+RMtNarQCjBiu4U3kwAVA2S/xZlUhmsJF4GTwE=
X-Received: by 2002:a05:6830:6ae6:b0:7e6:e385:4c1e with SMTP id 46e09a7af769-7ec096027c1mr8121305a34.4.1784043549120;
        Tue, 14 Jul 2026 08:39:09 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:5f::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ebcb3f2b86sm15347657a34.26.2026.07.14.08.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 08:39:08 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Xu <peterx@redhat.com>,
	Wupeng Ma <mawupeng1@huawei.com>,
	fvdl@google.com,
	rientjes@google.com,
	jthoughton@google.com,
	vannapurve@google.com,
	erdemaktas@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	David Carlier <devnexen@gmail.com>,
	Zhao Li <enderaoelyther@gmail.com>,
	lance.yang@linux.dev
Subject: Re: [PATCH v2 2/5] mm: hugetlb: Fix subpool usage leak on allocation failure
Date: Tue, 14 Jul 2026 08:39:06 -0700
Message-ID: <20260714153906.772019-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAEvNRgGN0HSJ2iLSDD2haSKOxifa-uhkO9Hwossh0+Q_d9fzOw@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5ACB3180002
X-Stat-Signature: rbw4p8ikfmhxnhcm8c9b6g7o61u57gfs
X-HE-Tag: 1784043550-104975
X-HE-Meta: U2FsdGVkX1+Zec+HCwBKAkmxExJfiIV1f3PaoFKCqQtKMfVtqqGV71aXQQ8xgO6klZwBE7+5VvswnGk4864RNBG0173RMFMQYySiWiO5ymPgeTgrVFCeW/FzsmbVSSYAAy8y+qHHcqTaFU63x4navmDRIn5LLwNI8Q+eoGT4x0ZwSIUb1AC8cMrLeg7hT2Qpvo1/fZBqFW/D5bt9aumkydnNKg9yIXlGOHEMIw2b0s2xK31L+kZ5lE3SDnYxmgZ0LVvqp+bgoOTSxoSpDXIf7/nTbPaaS27N3zd7A0+vsJC8FgSJr2WCyReu4OlhLgiF5fKRTo2p6+b33JVWnAK6gHmK1pZN+fXlsUxzCsKQoZsd4379pMiSiwQ2A5Un17kYjbjcQRwmKl0YjgdC/+qmhmfEgBttphAIQtkhlrd/j++l/gXSq0uFY8bE/Sz4xY4StuG7mZhpXOVyr0KpG3s3PfPqMEHJSLIBhJi/OEPAppqYLrmKaaw7AcI0shDJX5+Sb59LZv9Ld725b0ZAmrh8lD8OH5B96jKugR9l4hmScjqf8nrKVA1QNDxEUmoeaBAPfoEx6NgAGaUPAmlV+FzK1XYRhzC2xRwS/AqIV+OWseOy+7zBLL2PX4nmsjeONn4zsaIlud3Hip2+avgLSc9L6QXHfgf28Ja9G07L8bv0xhn2+AyI1AYMrI6TP6ZmlpIYRSGoTCmCGIfcn8BFxsy65+p7kOTX5jteEj3Jo3fS1OzQ/+H4nJMhslUqn86uGYmmnOv93piXsInGH2efxOIFaLriL1fO2ZoEqPZ+tZ/VbAo/2hmOU24o+Ivu/2Toys5HMYM7KeHlW3oY8DMkojoL0EVrW6mhGDQkZ9VrPxNCzz6ReGLV4I810WiBvQRg/o8SUi4pWzobDQYJm476jIwT/N0E80P6UOtbWKqUnWRMlUbeCVAQbQdUhlSqlQ5ViUPdhTobtUnYdIWl6al4kXF
 M2MlPg3S
 p0v1/PCtsv9vpPInkwuZEQA27XH9/cQsXblEJqFId5FnwPBXdNFEN+XavOWkqduvElGSnJI3ejTGOVt8ixzjtXpLTPwONgi6mrvK1VltAfDtH+MsP4wzqCCewSPinsByP+p5tcg8B+Jyzkt+2VpElwXBLTtUGR4ZYtuB7+ELionG7akFVuaEXj09cPrnUEGOyFt9MwSEQmhQ3cWP2/DKt+zQMf++ongo64i3d0+Xm65buVriR0mdZtvVTd4J3fbUj+91nAPhfmcjpZlnKifGBw2hrMdiHj2MeWJeiAdAvagp2qSfJJH41Ba/yYSF/8SkQvCoAYkVowVyJASFji2u9cLBxb51BRkPwDvTnFtqviezys7pAeV0PDGBlSnvviQ+rheUwndGqonkipsPkmepKyPgdyOQ5qg1NbVKiZcs326nUkfT3MYhcgPangU6iH/OxWUS7zcEOpSlkFQunS9TMmeyt2VFBtsjgevLEBUR6vDtIIbYL2EXhK8/JYJ7eQ2gLGnbzOVFmAUDDLlO/KcbOfEkAfVcBGeBhLTWs7ynty3P9MAtbMyTNMARE3cSIvh8LF+0L4+HXhUBQfExPgXjVH+ojxBXKIkf4QD6iMK2ah9FiPOrCMOqZHmolSs1N7kxxq4VPCRJQOLWJN5P40QbOJjpd4yEMd37KiO9gManFSPVaAi2GKvfuTWORqI1dxkMwFNn749JJuvdq5HIAXYoTlU1Feg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 9 Jul 2026 15:15:50 -0700 Ackerley Tng <ackerleytng@google.com> wrote:

> Ackerley Tng <ackerleytng@google.com> writes:
> 
> > Joshua Hahn <joshua.hahnjy@gmail.com> writes:
> >
> >> Hi Ackerley,
> >>
> >> Thank you for this series. I really wanted to work on hugeTLB accounting
> >> fixes but never got the time to get to it. I'm very grateful that you
> >> are taking a look!!
> >>
> >>> From: Ackerley Tng <ackerleytng@google.com>
> >>>
> >>> When alloc_hugetlb_folio() fails early (e.g. buddy allocation failure or
> >>> hugetlb cgroup charging failure) and gbl_chg == 1 (meaning a reservation
> >>> was not used, but a global page was allocated instead), the subpool page
> >>> acquired via hugepage_subpool_get_pages() must still be returned.
> >>>
> >>> Currently, the error path out_subpool_put: only calls
> >>> hugepage_subpool_put_pages() if !gbl_chg is true. If gbl_chg is 1, it
> >>> skips it, permanently leaking the subpool's used_hpages counter.
> >>>
> >>> With the earlier patch to always track used_hpages in the subpool, always
> >>> call hugepage_subpool_put_pages() if map_chg is true to consistently
> >>> restore the page to the subpool. Only call hugetlb_acct_memory() to adjust
> >>> global reservations if gbl_chg == 0 since gbl_chg == 0 indicates a
> >>> subpool (and global) reservation was used.
> >>
> >> So I think that I've seen that this part of the accounting specifically
> >> is a bit suspicious. There have been two attempts in the past to fix
> >> this area [1] [2]. I think functionally they are quite similar to this
> >> fix, they just open-code the contents of the put_pages function inside
> >> the condition. I've Cc-ed the authors of those two patches in case
> >> they wanted to chime in.
> >>
> >
> > Thanks for connecting us! I didn't realize this was already being worked
> > on. Also adding Lance, who commented at [3].
> >
> >> I reference these fixes because I think they handle the minimum
> >> subpage case a bit differently. To be honest, I recall reading those
> >> fixes a while back and getting a bit confused on what exactly happens
> >> when the page is absorbed to fulfill the minimum size...
> >>
> >> It does seem like Sashiko also notes this as a possible concern.
> >> WDYT? Does your reproducer for this issue also work when a minimum
> >> size is set (let's say, to 1?)
> >>
> >
> > Let me look into this more!
> >

Hi Ackerley, sorry that the reply took a while : -(

> I was looking at Sashiko's comment [4] and Sashiko is right that there
> could be a race. Specifically, at the time of
> hugepage_subpool_get_page(), I might be using a reservation, hence
> returning 1 (thread A), but at the time of hugepage_subpool_put_page(),
> some other thread (B) might already have restored a reservation to the
> subpool.
> 
> With used_hpages tracking within the subpool, we can rely on the return value of
> hugepage_subpool_put_page():
> 
> + Return 1: Reservation should be returned elsewhere (pool has enough pages to
>   satisfy minimum, or doesn't track minimums)
> + Return 0: Reservation does not need to be returned elsewhere
> 
> But calling hugepage_subpool_put_pages(1) doesn't say anything about whether the
> 1 (in this case, 1 doesn't always represent a page, since specifically on the
> error cases, the page wasn't allocated) consumed a reservation or not.
> 
> + gbl_chg == 0 means a reservation was used, and
> + gbl_chg == 1 means a reservation *should be used*, but
> + gbl_chg == 1 does not necessarily mean a reservation should be used, since
>   h->resv_huge_pages may not have been decremented yet. (See goto
>   out_subpool_put and goto out_uncharge_cgroup_reservation in
>   alloc_hugetlb_folio())

Yeah... this kind of tripped me up.

> So, we need to track if h->resv_huge_pages-- happened (with some local variable
> like reservation_consumed)
> 
> | reservation_consumed | hugepage_subpool_put_pages() return value |
> h->resv_huge_pages++ |
> |----------------------|-------------------------------------------|----------------------|
> | 1                    | 1                                         |
> Yes                  |
> | 1                    | 0                                         |
> No                   |
> | 0                    | 1                                         |
> No                   |
> | 0                    | 0                                         |
> No                   |
> 
> TLDR: replace !gbl_chg with reservation_consumed?

This seems like quite a reasonable approach. It's new information that
we can't derive from the existing flags we have.

>     <<== reservation_consumed = true
> 
> 	if (!gbl_chg) {
> 		folio_set_hugetlb_restore_reserve(folio);
> 		h->resv_huge_pages--;
>         <<== reservation_consumed = true
> 	}
> 
> 	if (map_chg) {
> 		long gbl_reserve = hugepage_subpool_put_pages(spool, 1);
> 
> 		if (!gbl_chg)  <<== this should be reservation_consumed
> 			hugetlb_acct_memory(h, -gbl_reserve);
> 	}
> 
> I believe this depends on always tracking used_hpages in subpools, in order to
> know for sure, just based on a number (with no page information), if the page is
> supposed to use a reservation.
> 
> 
> Perhaps related: does it make sense to flipping the reservation tracking
> to instead track an "available" page count? This is basically the
> mathematical opposite of rsvd_huge_pages, as in,
> 
>   available_pages = free_huge_pages - resv_huge_pages
> 
> This way, there's no need to synchronize the number of reserved pages in
> both the subpool and global hstate.
> 
> It's quite confusing now, that reserved_pages-- can be either "used a
> reservation" or "unreserve". If we track the opposite, available_pages--
> will definitely mean the page's availability is removed from the global
> hstate and transferred to the subpool, and allocating page doesn't
> involve updating both the subpool and hstate.

I think I like the semantic change, since it does make the code a lot
more obvious on why and where we are making the accounting changes.
One fear that I have is that this churn could introduce some new
subtle accounting errors, since we have been fixing this area for
quite some time now. Let's audit very carefully to make sure that
there are no new accounting errors that will be introduced : -)

> One downside I can think of is that creating hugepages (surplus, or
> promote/demote, or hotplug, or runtime echo 1 > nr_hugepages) would need
> to update the global hstate's available_pages count, but I imagine that
> would be less frequent than allocating huge pages?

Yup I think so. You might be more familiar with the new usecase you
are adding as part of the guest_memfd, but I have not really seen a
usecase for hugeTLB that would require userspace to do many hugeTLB
allocations (that THP wouldn't be able to serve). Having this accuracy
seems to be much more important than the rare contention we will see.

Thanks again for the fixes and ideas Ackerley! Looking forward to your
new approach : -)
Joshua

> >>
> >> [...snip...]
> >>
> >>
> >> [1] https://lore.kernel.org/linux-mm/20260428113037.88766-2-enderaoelyther@gmail.com/
> >> [2] https://lore.kernel.org/linux-mm/20260515202902.461539-1-devnexen@gmail.com/
> > [3] https://lore.kernel.org/linux-mm/20260428113059.79001-1-lance.yang@linux.dev/
> [4] https://sashiko.dev/#/patchset/20260708-hugetlb-alloc-failure-fixes-v2-0-c7f27cbb462b%40google.com?part=2,

