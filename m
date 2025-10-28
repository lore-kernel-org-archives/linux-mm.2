Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B514ECCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 04:17:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E576D8010E; Tue, 28 Oct 2025 00:17:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2E5F800E4; Tue, 28 Oct 2025 00:17:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6B4B8010E; Tue, 28 Oct 2025 00:17:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BFD2D800E4
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:17:41 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 426171603A3
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 04:17:41 +0000 (UTC)
X-FDA: 84046214322.30.7511E81
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4FF2A40006
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 04:17:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="m/Z9reD3";
	spf=pass (imf01.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761625059; a=rsa-sha256;
	cv=none;
	b=c8w4iBp+a88+8a1DoIBM/gIQZcoewwTjyd3sVu031Sxzc2+YUC5VezQBVMS7Flm3FX2sgw
	MJuK1XTCl/TNrNGKXLjvJE+wemyBIXsjRHJDR/aETtOvQsFaZp1HvUJ4WzJi/41o+6wCQd
	p7xS0frQe510xovWzfGsSJ7Nx5wne18=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="m/Z9reD3";
	spf=pass (imf01.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761625059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2cAevRJm/yIdn/zFvFaKRkG15E90y6nwgwebq1Zvcoo=;
	b=tSvDXaL/SVd6YUvcqLyHVAe8qfGZKCBkuQCJuJ/8gV5Qy6CbuflrucUZaHcVsvQHArYnOS
	qmTPo81WGixw2j4PoMXVuOpqSLHVmC7C53va6atEOp2NFXG5RjnMj1P2X3CvxoV0u7gjx6
	7SNnZL7NajiHfHSCqpq4x+lBQB52zBQ=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-47105bbb8d9so26945e9.1
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 21:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761625058; x=1762229858; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2cAevRJm/yIdn/zFvFaKRkG15E90y6nwgwebq1Zvcoo=;
        b=m/Z9reD36DEz1uUK9E28Nw7INiQry7O9WB0I/66zNcQPu+RGtZOs4qcMT0y4GUowNK
         cmh7pNEtd6GUIlR01XAEnWreYuPsWlJcgEFndnuWJHgcHifVDp/H3B65JQ6u89R1vVE/
         FOi29d15W+w7SiFBCVS3T8gPXYw4PPWofmzVRO9zPMh3iU4IdQVXgvS2bnVSOfNO/rmK
         yCo7oj+rnDVdIInJtvdASqdn2zlEmi1VtrQvCaiZFwLD778j8SF7khaCpC/QytuMbIo5
         MQ3Sy7e04qQYo14jUWKLdt78E0SXTuXHqeWE2mSy5K4U+AMTndGFdmbwfXoMN5CbdHTP
         kHQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761625058; x=1762229858;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2cAevRJm/yIdn/zFvFaKRkG15E90y6nwgwebq1Zvcoo=;
        b=HdoFIHmJpxYu93hmoh2uqUKUjC3E4k6XAdrYqcPusPUCjghMSfVVTP1LFTVchEffgI
         sDQ53BuHLKS7XO1t5l1T/fCifeIT9HuePkrL312z6c7w9/goihXgcyOwlzwoJohVKZNW
         BcxyItJL8OVaOE+GIyfZr7p8L/hhR7nKqSKahfC5s/bObvGsBQDXCggC+dMGJViv/ph4
         kFYa8paokUMuVbOgkfK6ttMSv0C5//9KwZRNmrZec2aoJ211VOOGgDDB1E+V75XP/pSJ
         gUjUzIyZUzzdvekjm5xOBBbPyb37uAsym3J4g+i1zBI37MbwGXwlzQbRjBoEbNWLrbs0
         Ng8Q==
X-Forwarded-Encrypted: i=1; AJvYcCVFX68Cs7uQRGsdCqaueZ8TF6MAv9NYXrCSYvEVa88bDV4xGL0iCpwvFRu3uc/uXP03ws2AKMO57Q==@kvack.org
X-Gm-Message-State: AOJu0YyUUL4iBlmLfSD9mVMF/rgeSvcBunn5u+fBXWuwAJkHiHd3hkYJ
	NwSUYS1R6Ft1buxO5EHwMfwutLPSQCttwJthN9Mn2qx/icb/as41KCmmZ4U4fy+YGv6Vlq0a0UX
	E9rEOSC9xti2nQjdiOGaAUKHjlvdzteH/JAgVzGHM
X-Gm-Gg: ASbGncvh/ESmFhOQNneidauo8coI/X6psgFEe6bRrfW2ilSjy2vu52xip/s69br0UxY
	uSgdr7vvnMgnjKSwS5X03WNkTPQLftPf3TZlK32F7bmr6j+bXCKnDQi0F9OOS0H9toZsXavYuGx
	O1ligfEgnPcnCiGumrOhWBA2+t2/mbuCZvzB8w7n9PBhOgG660b/wtP/XdxBEfmH4MH6n6DNa9q
	KBJGvqLVXGt5iSFs6wBlv9cRbm6msMVE4yEyZAfcoS9zr10+TokTiTuzcvRK3vyCowaTkME8tzd
	3I7gWtjm+FU+UyJ0XqSMsE1eUOjU
X-Google-Smtp-Source: AGHT+IE+E4tY+etIsCFF2nPDoUHnyT22SnJy9UYp9PvQ/KhLgWN6YLuk42P54iQFHSSSkaspkz8UX/surNJ8nzJ1vaM=
X-Received: by 2002:a05:600c:c0da:b0:475:da0c:38a8 with SMTP id
 5b1f17b1804b1-47718507566mr1227225e9.4.1761625057533; Mon, 27 Oct 2025
 21:17:37 -0700 (PDT)
MIME-Version: 1.0
References: <20250118231549.1652825-1-jiaqiyan@google.com> <20250919155832.1084091-1-william.roche@oracle.com>
 <CACw3F521fi5HWhCKi_KrkNLXkw668HO4h8+DjkP2+vBuK-=org@mail.gmail.com> <24367c05-ad1f-4546-b2ed-69e587113a54@oracle.com>
In-Reply-To: <24367c05-ad1f-4546-b2ed-69e587113a54@oracle.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Mon, 27 Oct 2025 21:17:26 -0700
X-Gm-Features: AWmQ_bmX6ASj90LVpGKygNwiwwkhojJGWTI7LXhkciYIpunIwL2ADJiOsQmDDCU
Message-ID: <CACw3F53ycL5xDwHC2dYxi9RXBAF=nQjwT4HWnRWewQLaHFU_kw@mail.gmail.com>
Subject: Re: [RFC PATCH v1 0/3] Userspace MFR Policy via memfd
To: William Roche <william.roche@oracle.com>
Cc: Ackerley Tng <ackerleytng@google.com>, jgg@nvidia.com, akpm@linux-foundation.org, 
	ankita@nvidia.com, dave.hansen@linux.intel.com, david@redhat.com, 
	duenwen@google.com, jane.chu@oracle.com, jthoughton@google.com, 
	linmiaohe@huawei.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, muchun.song@linux.dev, 
	nao.horiguchi@gmail.com, osalvador@suse.de, peterx@redhat.com, 
	rientjes@google.com, sidhartha.kumar@oracle.com, tony.luck@intel.com, 
	wangkefeng.wang@huawei.com, willy@infradead.org, harry.yoo@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 55qi4ed7s6knar5yxbxe7tbfkmzyd8dj
X-Rspamd-Queue-Id: 4FF2A40006
X-Rspamd-Server: rspam09
X-HE-Tag: 1761625059-185919
X-HE-Meta: U2FsdGVkX1+Q9nZYwMyysPL32hEEuL0giuWyEy83saOKlxT5YWx2NrsWlhenUbWW/IVHz9hTIRWsPTK/xRY2zV/SFf//9xRGkhtDE2eVz80pLXlo+Wp58VwzAv/YdBJ19Xl2agIylfZsjq39bF30KV5ktgS/qqDUJ/I64PZLeVdjWUWE8O+ZzS20+GsgQ2AG+AI7SNpmJ5m7T+jcq8uhr6Za2EPHCrGhpusHK0Rra60w0N6aZ6p5Xcru7Uaq3r1gQTOIFxlx0lSQwvf7U1xc0poqUnN8eJW1uargmXl6BLhmbZuDMg0Wk7EuH20Q1cLjLCuDrpT5/3lfJcvqX7EqVAblQGLyGcJK0MnB/+ARXhZ0Ecedp+FGT1g6qHAGKBSDYWrgOOucPNqPye0h9ccbmM1bFcJk8YaQJzFjCV95vPsl55dFRPvWctdjTKtRfmVjlBHkwJ/22VrR9bNE/QLeD593ViHY9Kw8sk3QoVhqDo2zFRJXK9JuBR+Z20Xk9j7oBrlV5yFSv0JS4P/V4IifbgCIypPONc9WQ/ywap1ZdRhaCCh+i4W8JFMMJWo7qNp9aJlv1TIdCekoHVp33wwpSLMs0/5zf3PrsiRbnfl2dIoxChSVtrkIoLd7PlNbuN5KfT1Vks+nEYb+cc+cZOQBq1JWK6UE19SVch86xuh6aQ1IW00W+AJN38CDYpu2KxX5zpNL4+HmoWC2NSFvL9sfun4kQZi50aaRJ3+6aq7Gp2eR0gs9h/71MGZ2tWr8/TjBVy+W5rzN5NHaIMiPeqzPr4jg0ClSMISC0rCZ5YLLu2zFk5UiGvx3pCCzIWWV1OuVLwigYhysMGk4JZ7+b1LMhNX0jfJ/JgsvrxUjWNmi6m587zQXCn1JpLv7tqcBb+iY72ALJnXyjgFWP3avvONHQep4DXYv35mCTIjXrza9vbOdSQWmQCPydRAd1cNdkcW11LHBo9V9vpGTUfdzgnF
 lPomRtoe
 EUixTAEFkHEN9Hwvbvqc5+M870+BQBfrvwG1ooQ/USPhaF0hgzMitsnbGk0xh3A6sk0v1u7fnGPPUof8ofE5FbBJ3OxU4ybzd/bLeLGpAKdrUdHvLsjBEsl6Umaxj1NqMv7bbANfetYRZ9EQabpNCCMhRsq87ocBpjNPp5i5T36Y4DAulRt8yTXpzZQ3jMkiVBMTWoCR5UoQ8Gq8dxGF6g0YghSfZIMtDO5JzgNJlP3A7xRy32tfvX3CDNPzucnXu4Gy24vjU7rJ0APNGBIcySncVrWIQZjaDm5WE+MtgbF2+HnSY8iZVhlIKzES9KQY71AWGZrTpaP/ygq3SDwYQI/Ha9g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 1:57=E2=80=AFPM William Roche <william.roche@oracle=
.com> wrote:
>
> On 10/14/25 00:14, Jiaqi Yan wrote:
>  > On Fri, Sep 19, 2025 at 8:58=E2=80=AFAM William Roche wrote:
>  > [...]
>  >>
>  >> Using this framework, I realized that the code provided here has a
>  >> problem:
>  >> When the error impacts a large folio, the release of this folio
>  >> doesn't isolate the sub-page(s) actually impacted by the poison.
>  >> __rmqueue_pcplist() can return a known poisoned page to
>  >> get_page_from_freelist().
>  >
>  > Just curious, how exactly you can repro this leaking of a known poison
>  > page? It may help me debug my patch.
>  >
>
> When the memfd segment impacted by a memory error is released, the
> sub-page impacted by a memory error is not removed from the freelist and
> an allocation of memory (large enough to increase the chance to get this
> page) crashes the system with the following stack trace (for example):
>
> [  479.572513] RIP: 0010:clear_page_erms+0xb/0x20
> [...]
> [  479.587565]  post_alloc_hook+0xbd/0xd0
> [  479.588371]  get_page_from_freelist+0x3a6/0x6d0
> [  479.589221]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  479.590122]  __alloc_frozen_pages_noprof+0x186/0x380
> [  479.591012]  alloc_pages_mpol+0x7b/0x180
> [  479.591787]  vma_alloc_folio_noprof+0x70/0xf0
> [  479.592609]  alloc_anon_folio+0x1a0/0x3a0
> [  479.593401]  do_anonymous_page+0x13f/0x4d0
> [  479.594174]  ? pte_offset_map_rw_nolock+0x1f/0xa0
> [  479.595035]  __handle_mm_fault+0x581/0x6c0
> [  479.595799]  handle_mm_fault+0xcf/0x2a0
> [  479.596539]  do_user_addr_fault+0x22b/0x6e0
> [  479.597349]  exc_page_fault+0x67/0x170
> [  479.598095]  asm_exc_page_fault+0x26/0x30
>
> The idea is to run the test program in the VM and instead of using
> madvise to poison the location, I take the physical address of the
> location, and use Qemu 'gpa2hpa' address of the location,
> so that I can inject the error on the hypervisor with the
> hwpoison-inject module (for example).
> Let the test program finish and run a memory allocator (trying to take
> as much memory as possible)
> You should end up on a panic of the VM.

Thanks William, I can even repro with the hugetlb-mfr selftest withou a VM.

>
>  >>
>  >> This revealed some mm limitations, as I would have expected that the
>  >> check_new_pages() mechanism used by the __rmqueue functions would
>  >> filter these pages out, but I noticed that this has been disabled by
>  >> default in 2023 with:
>  >> [PATCH] mm, page_alloc: reduce page alloc/free sanity checks
>  >> https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
>  >
>  > Thanks for the reference. I did turned on CONFIG_DEBUG_VM=3Dy during d=
ev
>  > and testing but didn't notice any WARNING on "bad page"; It is very
>  > likely I was just lucky.
>  >
>  >>
>  >>
>  >> This problem seems to be avoided if we call take_page_off_buddy(page)
>  >> in the filemap_offline_hwpoison_folio_hugetlb() function without
>  >> testing if PageBuddy(page) is true first.
>  >
>  > Oh, I think you are right, filemap_offline_hwpoison_folio_hugetlb
>  > shouldn't call take_page_off_buddy(page) depend on PageBuddy(page) or
>  > not. take_page_off_buddy will check PageBuddy or not, on the page_head
>  > of different page orders. So maybe somehow a known poisoned page is
>  > not taken off from buddy allocator due to this?
>  >
>  > Let me try to fix it in v2, by the end of the week. If you could test
>  > with your way of repro as well, that will be very helpful!
>
>
> Of course, I'll run the test on your v2 version and let you know how it
> goes.

Sorry it took more than I expect to prepare v2. I want to get rid of
populate_memfd_hwp_folios and want to insert
filemap_offline_hwpoison_folio into remove_inode_single_folio so that
everything can be done on the fly in remove_inode_hugepages's while
loop. This refactor isn't as trivial as I thought.

I was struggled with page refcount for some time, for a couple of reasons:
1. filemap_offline_hwpoison_folio has to put 1 refcount on hwpoison-ed
folio so it can be dissolved. But I immediately got a "BUG: Bad page
state in process" due to "page: refcount:-1".
2. It turns out to be that remove_inode_hugepages also puts folios'
refcount via folio_batch_release. I avoided this for hwpoison-ed folio
by removing it from the fbatch.

I have just tested v2 with the hugetlb-mfr selftest and didn't see
"BUG: Bad page" for either nonzero refcount or hwpoison after some
hours of running/up time. Meanwhile, I will send v2 as a draft to you
for more test coverage.

>
>
>  >> But according to me it leaves a (small) race condition where a new
>  >> page allocation could get a poisoned sub-page between the dissolve
>  >> phase and the attempt to remove it from the buddy allocator.
>
> I still think that the way we recycle the impacted large page still has
> a (much smaller) race condition where a memory allocation can get the
> poisoned page, as we don't have the checks to filter the poisoned page
> from the freelist.
> I'm not sure we have a way to recycle the page without having a moment
> when the poison page is in the freelist.
> (I'd be happy to be proven wrong ;) )
>
>
>  >> If performance requires using Hugetlb pages, than maybe we could
>  >> accept to loose a huge page after a memory impacted
>  >> MFD_MF_KEEP_UE_MAPPED memfd segment is released ? If it can easily
>  >> avoid some other corruption.
>
> What I meant is: if we don't have a reliable way to recycle an impacted
> large page, we could start with a version of the code where we don't
> recycle it, just to avoid the risk...
>
>
>  >
>  > There is also another possible path if VMM can change to back VM
>  > memory with *1G guest_memfd*, which wraps 1G hugetlbfs. In Ackerley's
>  > work [1], guest_memfd can split the 1G page for conversions. If we
>  > re-use the splitting for memory failure recovery, we can probably
>  > achieve something generally similar to THP's memory failure recovery:
>  > split 1G to 2M and 4k chunks, then unmap only 4k of poisoned page. We
>  > still lose the 1G TLB size so VM may be subject to some performance
>  > sacrifice.
>  >
>  > [1]
> https://lore.kernel.org/linux-mm/2ae41e0d80339da2b57011622ac2288fed65cd01=
.1747264138.git.ackerleytng@google.com
>
>
> Thanks for the pointer.
> I personally think that splitting the large page into base pages, is
> just fine.
> The main possibility I see in this project is to significantly increase
> the probability to survive a memory error on large pages backed VMs.
>
> HTH.
>
> Thanks a lot,
> William.

