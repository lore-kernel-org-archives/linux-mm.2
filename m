Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 055BECAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:00:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60EBF8E0007; Wed, 24 Sep 2025 11:00:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E68E8E0001; Wed, 24 Sep 2025 11:00:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FC938E0007; Wed, 24 Sep 2025 11:00:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 38DC28E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:00:11 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D97B516085D
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:10 +0000 (UTC)
X-FDA: 83924454180.17.C8AE973
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf09.hostedemail.com (Postfix) with ESMTP id E7DB7140010
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=J22e0BFk;
	spf=pass (imf09.hostedemail.com: domain of 3dQfUaAgKCCIH8AIK8L9EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3dQfUaAgKCCIH8AIK8L9EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758726009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=927/lHF2vNu0XxZ1FGlpxq1I27djjd2ax6gbW3uqrWQ=;
	b=eknzx6LZ9YjsIeGchcAphsYuTQzY5TyLGY13p2GJ3yuiC46WnwM/12V8+oE1XvdFcyupeM
	2rBCQzPsB5VzRStO4zNrezU4yNybWiUeGVvu1i2ZTaDbP1X7+hFshS0hgiKN6JZnV6CglS
	FDhEPyrLqKiHXtdUgWSb4W35mM1Ts5c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758726009; a=rsa-sha256;
	cv=none;
	b=jyxF14TfPANAL/stbjHKMzoQ0OhmURPj8YF4rJ8Uko9FhGHxPucMzvkcwMWZ3sCWfED0Rn
	5TNx69S3wz1+KhrhzLXuYBItet3JJ9Yk/MFokkTA723EKHEVQeoVZb01JNu0XKMOYOXfzp
	kYRklciAKTgLUnspKPUmvAWApAQKAxA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=J22e0BFk;
	spf=pass (imf09.hostedemail.com: domain of 3dQfUaAgKCCIH8AIK8L9EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3dQfUaAgKCCIH8AIK8L9EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45f2c1556aeso22472845e9.3
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758726007; x=1759330807; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=927/lHF2vNu0XxZ1FGlpxq1I27djjd2ax6gbW3uqrWQ=;
        b=J22e0BFkOMSPRLbUQomJ0SK0dc/OtempBRE47S9dEE5B6N8YUsKeMmEaeusQ7sIGix
         i6+0yuRfZIfOhWQ+iR4c13yYalvNGDxk2+tntzdfsGvtXOTEQrktgwYDOyjRcZ6BoxKT
         sf6uRmmLVZwkN+Z5cOtGtIxssEY1WL2j2YNNlRxgIY+ofzAwH/mziU0hrKx3BYQINr3D
         Hypdn2J5KtVypz71T20AbpgD5yo1KFNlOi4obKBAUuMH/l/eIcQh5BRK8sFXAb1VBUpo
         8LDZhDARHSx/yI9NKITXmNIcn1D6O5PAP5NRFVBrNso/aPpex0Sgh9HVN55HIQrKf09V
         zViQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758726007; x=1759330807;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=927/lHF2vNu0XxZ1FGlpxq1I27djjd2ax6gbW3uqrWQ=;
        b=f6N0E3QGatuVkWJkRysyVcxJYCWAGszpgMGAcQ0Byh0JFWnKMbQLb+kib2c8kloyg1
         BqwPppp01L3crEBGY6RYkMkZTCbFhUAuC2IX+NDpCJWq8MWc8cfCFdGdbDW3IzPt/OHC
         vcTyF0/V2Z81EEue9kzxisppvBn4FBtXQDbRzTvSrpQWHmXJfIE6jL5Lxyx6C2gLop0G
         H3oQvDTf5DcSdwkwSUhE3QVOJLHeKo7A7i5hNZ0jH3pmqUNtpjKOQuCvOwk9ckdj3aXn
         Idd135QyMwvc+CDTDjHjE2mrP5azStbMyrPft8BXUtFuicf9q/9TrgGbstSe/cZHsZyO
         UVLw==
X-Forwarded-Encrypted: i=1; AJvYcCWhYcbJanxdrnxJF3CIu418GBKXLU+lgMKL8+PY97hrjAvcWQ6tK7QULQ7g7/jJYmdlr8K8FxqyVw==@kvack.org
X-Gm-Message-State: AOJu0YxnmwjsHJ4voCZWOwS+OayUX7g8M9ASnGlX4k5N8vo+gM8UhLfH
	aiX4SaWjHxmA86G6mk3ClQtbz27IFqaxFOQ2k5PSOEoBtvGcPF0zhd6FHYo6SVhqwvVSnjXHpp4
	yDM1I6UwYa12cUQ==
X-Google-Smtp-Source: AGHT+IHBYuTfCDyMl4IXnL9KHYj5g7KpkNQnHbq4nxEziZs+xO/jJjkNAvzvrh9akC6IylkUFnRqISJyOAfYRg==
X-Received: from wrbfm4.prod.google.com ([2002:a05:6000:2804:b0:3ec:dc85:55e8])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:61e:b0:408:ffd8:2742 with SMTP id ffacd0b85a97d-40e4adc167fmr240695f8f.33.1758726005002;
 Wed, 24 Sep 2025 08:00:05 -0700 (PDT)
Date: Wed, 24 Sep 2025 14:59:35 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAFgH1GgC/x2MQQqAIBAAvxJ7bqG0sPpKdNhsrYXQUIhA+nvSc
 RhmMiSOwgmmKkPkW5IEX6CtK7AH+Z1RtsKgGtU3o9K4dkhJ8KKi6DyDRdOtvR40GeUslO6K7OT 5n/Pyvh+w7EPGYwAAAA==
X-Change-Id: 20250923-b4-asi-page-alloc-74b5383a72fc
X-Mailer: b4 0.14.2
Message-ID: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
Subject: [PATCH 00/21] mm: ASI direct map management
From: Brendan Jackman <jackmanb@google.com>
To: jackmanb@google.com, Andy Lutomirski <luto@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: peterz@infradead.org, bp@alien8.de, dave.hansen@linux.intel.com, 
	mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org, 
	david@redhat.com, derkling@google.com, junaids@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, reijiw@google.com, 
	rientjes@google.com, rppt@kernel.org, vbabka@suse.cz, x86@kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: izz8ym8bmqng6wq1nex758cy5cfbm4i6
X-Rspamd-Queue-Id: E7DB7140010
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758726008-208973
X-HE-Meta: U2FsdGVkX1/EW0O3dLBsn5Oy2q5282Gr9KxUWTopeDKYaZmbMmf9DB8I6qdbTqjlOlSYIcjBzf+yK/foFzlpFbcxFRb5Xrfm+htHwXTAJ0qHxN5EQrc9emwc2W6f2g3k0/fL5xLp8tNv8Jz9AQOveCeGiAi6tOfutjsxMNQrty+ZnhEH6GwmL8SnImzPPwQxMR1IN16YSYIZ5ilJqs2JcPajPtxs20wmF/0vKUK+4GuXjWPnKLLOY6Bh7U0VQq29OxdrYRpGp979NdEctxEbUlCstASG40CAdFRV49ySQNY0RlI+1Z9FZkZDhAz1A2G471eZ4his8T6prZPa3vEclEfsQZSzlCdOmvfiYHWLTIkBKnlbFYOqtdB13mchYCMIXY1jI/AqS0BtWnxMH7f4ipIrMFvsy+b6Urf84mSDgFCwd9CJvccVJ6QgMJc1H0pQJhwYqPFd4uZkhf9k8ZVWsvKE802O5BSFOFx7QYl6WkLLNO0gjD3JNLQLy+U5PprCBJfl8YuejbHuqKStLT7Slh1CsMy/L9AkY5/VnPF/MV6gXP0uMGDziVuhKwoj8qAOeU3UmICu/aNsL4DxtmAbyBTF2wO5idlhAtIxPngKDhktfn/TfE8TTvDTYv7K/PWcKQviW7XpXc5btKN/pXTZf4hGaO+/csRTjUDhJpCpImT0TOAACShmsZ8pJYMzoZu9nZgalhEO2Zmd8qy0k9sNHNMJ57/7fzNsKB+F5lUNP7XsLwr1gBn+dxZHfkS3rx9HCip4tHvaj99MlfbXWFnsGX43/f/ktvskfJzzsHmR+nhKKwUdpi0rSwtezggJeWNS5jVzFpjIAmHhyQFJNYG18L2FPvJ8jRTb+UmqWEh0CGVlVI63cPpDqLz2SF1Xldg815TtZGvSD+aELB+eJ65ZLlotCLeLRBI1i6fHED/n/pHTWXebkdTyyhNitgOqyHR+DUILhB9i3Jxh42Wd4Be
 yaXoAxSI
 XTm91rBOo198G7e8YCfCFudvoZfdy0Xi6hnrxLPEFqAp4Ma/T+0JYH1Skr4ji8h6HCoVhFPHeCWu5uSd5x7ki9xtqdTpefUjz3bAXweEPVIRJpxNV1zwfHP0mbHkdd3es5BhnDmdfcc5A3o68JM+zGsR6qHiLaMalmS/qZf8Lg/QjwWOKq0n1AZE6tbVaC5PQIoAkkhVkWTX5U0fnGVP6ysLyZHsd+YajDccnEHoDsj9j3pyUK7QJk6RxRwUmLxJFgjxBV9VDM8ByqviTOBmydGjVdc8nKc2ebQDM53ZL9SlMVQDSzUtkqrOYSdho5ETPLS7oZ2W45mgSu39eWU1rBUxHrDGismxU+bXGor3qB2y2KSVoNl5c8CfpzECxkc1S/vJQkwUNK5ksj86uW+q6HfmPmWNNWuSNbl9lD/XGa/L7WnQD45WUh1kmY+UcBUifbWyh1hq7goWa4+o+sIN4lbWxJ9ucaYy+2z1nBBZNju36gMdU17961mXRaIlxbxDD4LhNY4FN2G7ihmx5HE1AUrxQd1vBhGdg/VR3o5sGQsTYica0rKn5gxx2Jidw8f/6GmAZJYKwo/Qqvuv1CoG3yUSS8YfoFiMf6zmtknBBMVk2lQnYsDE/XxQHFAbBC1sAMz6g
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As per [0] I think ASI is ready to start merging. This is the first
step. The scope of this series is: everything needed to set up the
direct map in the restricted address spaces.

.:: Scope

Why is this the scope of the first series? The objective here is to
reach a MVP of ASI that people can actually run, as soon as possible.
Very broadly, this requires a) a restricted address space to exist and
b) a bunch of logic for transitioning in and out of it. An MVP of
ASI doesn't require too much flexibility w.r.t. the contents of the
restricted address space, but at least being able to omit user data from
the direct map seems like a good starting point. The rest of the address
space can be constructed trivially by just cloning the unrestricted
address space as illustrated in [1] (a commit from the branch published
in [0]), but that isn't included in this series, this is just for the
direct map.

So this series focuses on part a). The alternative would be to focus on
part b) first, instead just trivially creating the entire restricted
address space as a clone of the unrestricted one (i.e. starting from an
ASI that protects nothing).

.:: Design

Whether or not memory will be mapped into the restricted address space
("sensitivity") is determined at allocation time. This is encoded in a
new GFP flag called __GFP_SENSITIVE, which is added to GFP_USER. Some
early discussions questioned whether this GFP flag is really needed or
if we could instead determine sensitivity by some contextual hint. I'm
not aware of something that could provide this hint at the moment, but
if one exists I'd be happy to use it here. However, in the long term
it should be assumed that a GFP flag will need to appear eventually,
since we'll need to be able to annotate the sensitivity of pretty much
arbitrary memory.

So, the important thing we end up needing to design here is what
the allocator does with __GFP_SENSITIVE. This was discussed in [2] and
at LSF/MM/BPF 2024 [3]. The allocator needs to be able to map and unmap
pages into the restricted address space. Problems with this are:

1. Changing mappings might require allocating pagetables (allocating
   while allocating).

2. Unmapping pages requires a TLB shootdown, which is slow and anyway
   can't be done with IRQs off.

3. Mapping pages into the restricted address space, in the general case,
   requires zeroing them in case they contain leftover data that was
   previously sensitive.

The simple solution for point 1 is to just set a minimum granularity at
which sensitivity can change, and pre-allocate direct map pagetables
down to that granularity. This suggests that pages need to be physically
grouped by sensitivity. The second 2 points illustrate that changing
sensitivity is highly undesirable from a performance point of view. All
of this adds up to needing to be able to index free pages by
sensitivity, leading to the conclusion that we want separate freelists
for sensitive and nonsensitive pages.

The page allocator already has a mechanism to physically group, and to
index pages, by a property, namely migratetype. So the approach taken
here is to extend this concept to additionally encode sensitivity. So
when ASI is enabled, we basically double the number of free-page lists,
and add a pageblock flag that can be used to check a page's sensitivity
without needing to walk pagetables.

.:: Structure of the series

Some generic boilerplate for ASI:
	x86/mm/asi: Add CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
	x86/mm/asi: add X86_FEATURE_ASI and asi=

Minimal ASI setup specifically for direct map management:
	x86/mm: factor out phys_pgd_init()
	x86/mm/asi: set up asi_nonsensitive_pgd
	x86/mm/pat: mirror direct map changes to ASI
	mm/page_alloc: add __GFP_SENSITIVE and always set it

Misc preparatory patches for easier review:
	mm: introduce for_each_free_list()
	mm: rejig pageblock mask definitions
	mm/page_alloc: Invert is_check_pages_enabled() check
	mm/page_alloc: remove ifdefs from pindex helpers

One very big annoying preparatory patch, separated to try and mitigate
review pain (sorry, I don't love this, but I think it's the best way):
	mm: introduce freetype_t

The interesting bit where the actual functionality gets added:
	mm/asi: encode sensitivity in freetypes and pageblocks
	mm/page_alloc_test: unit test pindex helpers
	x86/mm/pat: introduce cpa_fault option
	mm/page_alloc: rename ALLOC_NON_BLOCK back to _HARDER
	mm/page_alloc: introduce ALLOC_NOBLOCK
	mm/slub: defer application of gfp_allowed_mask
	mm/asi: support changing pageblock sensitivity

Misc other stuff that feels just related enough to go in this series:
	mm/asi: bad_page() when ASI mappings are wrong
	x86/mm/asi: don't use global pages when ASI enabled
	mm: asi_test: Smoke test for [non]sensitive page allocs

.:: Testing

Google is running ASI in production but this implementation is totally
different (the way we manage the direct map internally is not good,
things are working nicely so far but as we expand its footprint we're
expecting to run into an unfixable performance issue sooner or later).

Aside from the KUnit tests I've just tested this in a VM by running
these tests from run_vmtests.sh:

compaction, cow, migration, mmap, hugetlb

thp fails, but this also happens without these patches - I think it's a
bug with the ksft_set_plan(), I'll try to investigate this when I can.

Anyway if anyone has more tests they'd like me to do please let me
know. In particular I don't think anything on the list above will
exercise CMA or memory hotplug, but I don't know a good way to do that.
Also note that aside from the KUnit tests which do a super minimal
check, nothing here cares about the actual validity of the restricted
address space, it's just to try and catch cases where ASI breaks non-ASI
logic.

If people are interested, I can start a kind of "asi-next" branch that
contains everything from this patchset plus all the remaining prototype
logic to actually run ASI. Let me know if that seems useful to you
(I will have to do it sooner or later for benchmarking anyway).

[0] [Discuss] First steps for ASI (ASI is fast again)
    https://lore.kernel.org/all/20250812173109.295750-1-jackmanb@google.com/
[1] mm: asi: Share most of the kernel address space with unrestricted
    https://github.com/bjackman/linux/commit/04fd7a0b0098a
[2] [PATCH RFC 00/11] mm: ASI integration for the page allocator
    https://lore.kernel.org/lkml/20250313-asi-page-alloc-v1-0-04972e046cea@google.com/
[3] LSF/MM/BPF 2025 slides
    https://docs.google.com/presentation/d/1waibhMBXhfJ2qVEz8KtXop9MZ6UyjlWmK71i0WIH7CY/edit?slide=id.p#slide=id.p
    CP:
    https://lore.kernel.org/all/20250129124034.2612562-1-jackmanb@google.com/

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
Brendan Jackman (21):
      x86/mm/asi: Add CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
      x86/mm/asi: add X86_FEATURE_ASI and asi=
      x86/mm: factor out phys_pgd_init()
      x86/mm/asi: set up asi_nonsensitive_pgd
      x86/mm/pat: mirror direct map changes to ASI
      mm/page_alloc: add __GFP_SENSITIVE and always set it
      mm: introduce for_each_free_list()
      mm: rejig pageblock mask definitions
      mm/page_alloc: Invert is_check_pages_enabled() check
      mm/page_alloc: remove ifdefs from pindex helpers
      mm: introduce freetype_t
      mm/asi: encode sensitivity in freetypes and pageblocks
      mm/page_alloc_test: unit test pindex helpers
      x86/mm/pat: introduce cpa_fault option
      mm/page_alloc: rename ALLOC_NON_BLOCK back to _HARDER
      mm/page_alloc: introduce ALLOC_NOBLOCK
      mm/slub: defer application of gfp_allowed_mask
      mm/asi: support changing pageblock sensitivity
      mm/asi: bad_page() when ASI mappings are wrong
      x86/mm/asi: don't use global pages when ASI enabled
      mm: asi_test: smoke test for [non]sensitive page allocs

 Documentation/admin-guide/kernel-parameters.txt |   8 +
 arch/Kconfig                                    |  13 +
 arch/x86/.kunitconfig                           |   7 +
 arch/x86/Kconfig                                |   8 +
 arch/x86/include/asm/asi.h                      |  19 +
 arch/x86/include/asm/cpufeatures.h              |   1 +
 arch/x86/include/asm/set_memory.h               |  13 +
 arch/x86/mm/Makefile                            |   3 +
 arch/x86/mm/asi.c                               |  47 ++
 arch/x86/mm/asi_test.c                          | 145 ++++++
 arch/x86/mm/init.c                              |  10 +-
 arch/x86/mm/init_64.c                           |  54 +-
 arch/x86/mm/pat/set_memory.c                    | 118 ++++-
 include/linux/asi.h                             |  19 +
 include/linux/gfp.h                             |  16 +-
 include/linux/gfp_types.h                       |  15 +-
 include/linux/mmzone.h                          |  98 +++-
 include/linux/pageblock-flags.h                 |  24 +-
 include/linux/set_memory.h                      |   8 +
 include/trace/events/mmflags.h                  |   1 +
 init/main.c                                     |   1 +
 kernel/panic.c                                  |   2 +
 kernel/power/snapshot.c                         |   7 +-
 mm/Kconfig                                      |   5 +
 mm/Makefile                                     |   1 +
 mm/compaction.c                                 |  32 +-
 mm/init-mm.c                                    |   3 +
 mm/internal.h                                   |  44 +-
 mm/mm_init.c                                    |  11 +-
 mm/page_alloc.c                                 | 664 +++++++++++++++++-------
 mm/page_alloc_test.c                            |  70 +++
 mm/page_isolation.c                             |   2 +-
 mm/page_owner.c                                 |   7 +-
 mm/page_reporting.c                             |   4 +-
 mm/show_mem.c                                   |   2 +-
 mm/slub.c                                       |   4 +-
 36 files changed, 1205 insertions(+), 281 deletions(-)
---
base-commit: bf2602a3cb2381fb1a04bf1c39a290518d2538d1
change-id: 20250923-b4-asi-page-alloc-74b5383a72fc

Best regards,
-- 
Brendan Jackman <jackmanb@google.com>


