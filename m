Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D615ACA5FC7
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 16:00:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C64406B0088; Wed, 30 Sep 2026 12:00:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C14A56B008A; Wed, 30 Sep 2026 12:00:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2B046B008C; Wed, 30 Sep 2026 12:00:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 855956B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 12:00:02 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DD894160131
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 16:00:01 +0000 (UTC)
X-FDA: 85270889802.01.AF80D30
Received: from mail-yx2-f38.google.com (mail-yx2-f38.google.com [74.125.224.166])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5F33F18000B
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 15:59:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=tenstorrent.com header.s=google header.b=Eb+ywFlB;
	spf=pass (imf06.hostedemail.com: domain of asrinivasan@tenstorrent.com designates 74.125.224.166 as permitted sender) smtp.mailfrom=asrinivasan@tenstorrent.com;
	dmarc=pass (policy=reject) header.from=tenstorrent.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790784000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YMxQ9b6X1p34U0/6ooz+lLlNpeyvqyp2NfoWFlwIw1I=;
	b=GV7DAGgO+CWFOXxV4EC6r5gWqnqajKQpJXDq2sEMcus6iSWnIJAQb6Kc2SWHQ2tlYjJvy/
	Fmlw3Jc5NPEl6FeWMOz68LAVlpEiDpZNxeh9+NiE2+MfZK61Og17hWaxI+HpTe1DbAORTu
	NK0gkU4T7KVWSY49b/JyAPk/m0jx980=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=tenstorrent.com header.s=google header.b=Eb+ywFlB;
	spf=pass (imf06.hostedemail.com: domain of asrinivasan@tenstorrent.com designates 74.125.224.166 as permitted sender) smtp.mailfrom=asrinivasan@tenstorrent.com;
	dmarc=pass (policy=reject) header.from=tenstorrent.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790784000;
	b=sC3vqEEexTYJdLHqCcQGwYpHYThi8ZcG7wbpEvgrS4oTYy2efO/Km2/eDgSsTD8ThOdVN4
	U8OiLo/X/VprayIY7m8gaiECJelewlz6rF67Qs6PtjpFY4tazv5BVA5WwN+n1Sw2BJ9CpF
	GUIPGutHQYlBrBvwRQCbaxQf6ebtzdg=
Received: by mail-yx2-f38.google.com with SMTP id 00721157ae682-8ac4967f1c9so9368177b3.2
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 08:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tenstorrent.com; s=google; t=1790783997; x=1791388797; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YMxQ9b6X1p34U0/6ooz+lLlNpeyvqyp2NfoWFlwIw1I=;
        b=Eb+ywFlB1xbdUstztKV8j5aDtAMTlpdo08RJLu+qO2I1SSzz/XxnSiFzpMCSTP98sI
         jJSXqejJSAI0AU/tFCFJM9Bfajr5XkKwt/VCS2oiYFs3rRbAwXLmAElAGCpdtaY/6Zbh
         1ve3nmpbGcvMK0e03Fyc+tPdSI40RH+zbzYGO52uJG/8cB4hcBBm51Y6EZz+tIktyYUH
         Sk4SzeeKn5wcyliyNK9AFfxTGhDzhETnFvSPyWLBzNAePnsV/JeHj8EZuVN3v3F/n8/K
         dpwwcvfSrb1CnCNwJsgAJYkiwG+GWtbRS+0z95GAHq4CbhCDjV909Kud3JwxDM/MwZBJ
         HcDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790783997; x=1791388797;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YMxQ9b6X1p34U0/6ooz+lLlNpeyvqyp2NfoWFlwIw1I=;
        b=tMJc+qSqfwTWPa3Q7wu3wGFtjkEVA7Gh4oZe6hBphlpSEQok6f+H9BT1gLnTU866Dt
         ggd7mSD8UpuoqGJnlN8qJwjYtga8rSOfeu/nIVNlS+CKAmUYO79qXp7yxa+eTAZrgwxy
         C2pcTP0gD3NRaaqpg3QgM4DSPRFhYCwrQtGwh7NUIkKLG7eViT5yA/TcW6zclceN2ntd
         b9h35WJ3NGbxhcgirlNgqut4hNMRroSBAl1s7XKWiBrwknTW48g9CfAFaHd5Jvefc6Pw
         4p52GXhBv+g8lqmGTzXcHZRzFl2uI5RLi9NUYsMi8aedv7gHNq1dhvoU9NULm+RGGH01
         9qbg==
X-Forwarded-Encrypted: i=1; AKwUvByWoxqddNYsP/OlxsLNK3BnPgWOvbWY8g8GBHyPcj/kRZzp5fR/DlG4Jgyqp2ar149g+dwnvBZaZA==@kvack.org
X-Gm-Message-State: AFq9FYKrHIo9UsFmYe7eMiwQfmBSV7qorbaBdceF0QKm2oRFmiXs6EzN
	sP48g9ITrVTtQPEIBkMsiUyxCkR+rLZy+PwBRD7E1ZHZ9vwfnPgUoDI5Iimxr+kJH8k=
X-Gm-Gg: AYBFou12zUtyg6RFxsZTaWlLDqMz/e2/J7fyv2vMvvxQmLYqjJ3h4/ySXLBAOkgPCvB
	4DhJaUcMFNe3FpWe9F1gR+6Q+nMWQpTNJkUrQCQ9oNeryR2zgy16tB/GR/FdD1dou9wbIk1o3xR
	oW/DrVqspNDqpNl3Hn+WUiHVgga6lpJdiG0lI+t+AOhAxa+SuDD1wjZAD4JWEqLTUodilU8K95d
	eAYDm/7XHTyhCs5vqGBKzvbVA3CsfKxCy6SfX5U6fdXfevjwbq1lWRQ7HhgYroDUnDGOZsT+gW4
	EG1w0E/UiWEpckn0fVBioYFDm77yBGdDIaopg+zjDlks4tITWU+KITy08Ol/7OmnSFAZ+p2s1YF
	fGN6KQ8UfzbY4jC4VTFe80KYYJB8D8uS+a2apizMMO6+mfOEOmd4Dg1hXjbxQQKLRPX3VjfbrVI
	sr7KmAsuXcMyGAtVHCVD+aKdKT+nM0cLk/drEjWg8eYUUUBEEUHiE15DiWHi7Fq0IHSdaZ0D/v3
	5xytyjgYdIFLKqJy8jvFuvPEdY4BrppLu4szQ==
X-Received: by 2002:a05:690c:9990:b0:89a:63da:fa90 with SMTP id 00721157ae682-8ac93318690mr7925077b3.75.1790783997212;
        Wed, 30 Sep 2026 08:59:57 -0700 (PDT)
Received: from toolbox ([12.55.13.134])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8acdada3294sm380647b3.47.2026.09.30.08.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 08:59:56 -0700 (PDT)
Date: Wed, 30 Sep 2026 10:59:50 -0500
From: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
	Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH 0/2] mm/mremap: fix two issues with MREMAP_DONTUNMAP
Message-ID: <ux7od2uydetgsu3dpy6mmilhqm5phhnk2ioxn54w3nb3feohxf@2jqovoqzfs4n>
References: <20260920-fix-dontunmap-partial-self-merge-v1-0-6ffb556f8f8b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260920-fix-dontunmap-partial-self-merge-v1-0-6ffb556f8f8b@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5F33F18000B
X-Stat-Signature: wh57z54unp74eepftwxznrarfu19r5yz
X-HE-Tag: 1790783998-314011
X-HE-Meta: U2FsdGVkX185IuD7CTUy1FIFBgrkPf5eoBjyHfeiWKMOS8TEhXrNlcJqPPNCIw8RDe+diV0Ag13QZDXgGohEAy6GfYcsfGV835Tzkv7+MIuP6pTIkieNZ+vPBn/f92xMEKQMt9tNVun4arYnLGsL8l7dTtZnEPfm1yN1kcz4SkciUgLipOPlQEysUgHZMWy9PUSVhTWpuFcEuyaWJ9Vq7OmwXC1Ttv5/AIpfwY4U79AinJPue1BUhOCDz98I9mtNkZMTBsVXMnvvCxqveWMulpiAG3kb1RNV38FMPjP2m3V8bOLMxTCxHf2yYZN3pDA/pax6bMqIrTVABOf2lEKeQY3ZCLidoPOGOatmNbepYIQZuNpFM+AqS+V5tg/7IuyAr2GQsHfUU0MFgDVOe7K5yr5fyXrk22Ol5lKHSdlgRDydV+uHt4r2N6vB1ozOzV7XzXf+0raRDy8CntZ7hpK8bd/dVmmcMRv3KciHkSfT2CGkMsPNkjT5qrQTnyw3Bg3hB6fM/IIAPplxFZP1J+2IVhUaDDZF1fZnf0yfhYlfSqPqeFTZ+fcX5Ar2rAfE3aJrt5BW7wJdhUvRFiPkjNzCfLccGjg3Z64czdcIgD4GvPl8PBFPoIqMv1GKJHHougRusr1cG7Ceo3lia7nASZ0+7I05nwPYe2RQckElFqc9tTXbGh0JBONsdLnW6xxcPXdv8iMh9atePjy/7I0HErMnXAxPisnHUXLniSpbfuqdKEApU4U8CqvJpkthez8GxAEVWZCXUKa300XR/VFazwj4nnsOhaaAhJAarAVvgWkpMkB6I/JPS/DW2kV778qJp1qcNTLE2MrhMIUHmtKwyuCRhR2X/J0R3AQC6+8bzBcTTWVqNWoXpWSB4aB+gmhThPeIQ1tqW3KYh0M3OzP38o53WV/54ihYedvEKEyreYU8MinD5KifSxFZs2ARu0mnH6O40Cp4j0JdXOuoqrh6dpx
 Wi/AEoPg
 Z+kU4IRojKVLdXJ0FtlMnGzHQ3J40V0QYcOAQhc+PUr8uhTrc3zqJ84YQZx/7d7uYMd5mZJ96Z/3brTz7epL051Ak+4lULHopkcHTt38UG0pGYnv7ut3m14RzlmVfP7FLg2FJej3ec0XB5w4n7sd9vyH/rQWQyJ951faTEjwAhBClNATecpgodBYiahLLsUcs8Hik49i2EOHeB5G0TJQKmPSv1/AJfaiplAcN4PA2vn2I4UEpwMGQkL9j6o/XhSnl6ENHJmVgikEBzZbOA0Oz3URzYNyx7qwUT3rQr//PYXjR/FWQssZbBnODhlpCn8O74gXrsfyjTgo1Prqf2/M071LWcfeTe8dmQaGXiIoKBBvwZT2z9sUelCJCz0JfveW5Zb3C8JzZHij8WrDgSaa5fySFZCixHfXb6bBregfq6C6Z5sanD2cBd8vfktDhybbZZ7Kc1AuRqgMOa/0Ka9YfPMxwWrD7s/LJk0a3Fh4FQBmhQBQU0J9Y6LH8IMVi+Arsuy4xOk8LTuDZaW0QimR43yunLkIc51sCXlZDoWfKrQ2flWbFwsT9JGKoAC05pDMMz7KL1rEkTKtFgQfOvhOFAiil2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 20, 2026 at 03:13:09PM +0100, Lorenzo Stoakes (ARM) wrote:
> The MREMAP_DONTUNMAP feature is highly unusual in that it permits mremap()
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
> 2. If a partial mremap() is performed on a locked VMA there is a leak equal
>    to the number of pages not copied.
> 
> (Both for MREMAP_DONTUNMAP operations only)
> 
> Both issues can be fixed by treating the source range as distinct from the
> destination range, which is the definition of what MREMAP_DONTUNMAP does so
> is appropriate.
> 
> In case 1, simply disallow the self-merge, keeping adjacent source and
> destination VMAs distinct.
> 
> In case 2, split the source range ahead of time, so accounting is always
> correct.
> 
> Both changes were tested locally and confirmed to fix the issues.
> 
> For the purposes of a backport, the fixes are kept distinct, a follow-up
> series can add self-tests.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
> Lorenzo Stoakes (ARM) (2):
>       mm/mremap: fix locked_vm leak from MREMAP_DONTUNMAP self-merge
>       mm/mremap: fix locked_vm leak by splitting VMA for MREMAP_DONTUNMAP

Hello,

Apologies for the double mail. I did not hit reply all first time.

I am seeing some failures in the proc_maps_race kselftests after
this patch was added to linux-next. The failures are in
test_maps_tearing_from_remap and test_maps_tearing_from_resize. I have
attached some logs below

# #  RUN           proc_maps_race.maps.test_maps_tearing_from_remap ...
# ==== Tearing from remap ====
# Before modification 
# 3fb317e000-3fb3181000 r--p 00000000 00:00 0 
# 3fb3181000-3fb3184000 rw-p 00000000 00:00 0 
# 3fb3184000-3fb3187000 r--p 00000000 00:00 0 
# -----------------page boundary-----------------
# 3fb3187000-3fb318a000 rw-p 00000000 00:00 0 
# 3fb318a000-3fb318d000 r--p 00000000 00:00 0 
# 3fb318d000-3fb3190000 rw-p 00000000 00:00 0 
# 
# After modification 
# 3fb317e000-3fb3181000 r--p 00000000 00:00 0 
# 3fb3181000-3fb3184000 rw-p 00000000 00:00 0 
# 3fb3184000-3fb3185000 r--p 00000000 00:00 0 
# -----------------page boundary-----------------
# 3fb3185000-3fb3186000 rw-p 00000000 00:00 0 
# 3fb3186000-3fb3187000 r--p 00000000 00:00 0 
# 3fb3187000-3fb3189000 rw-p 00000000 00:00 0 
# 
# After restore 
# 3fb317e000-3fb3181000 r--p 00000000 00:00 0 
# 3fb3181000-3fb3184000 rw-p 00000000 00:00 0 
# 3fb3184000-3fb3187000 r--p 00000000 00:00 0 
# -----------------page boundary-----------------
# 3fb3187000-3fb3189000 rw-p 00000000 00:00 0 
# 3fb3189000-3fb318a000 rw-p 00000000 00:00 0 
# 3fb318a000-3fb318d000 r--p 00000000 00:00 0 
# 
# # proc-maps-race.c:1081:test_maps_tearing_from_remap:Expected 0 (0) != capture_mod_pattern(self, &remapped_last_line, &remapped_first_line, &restored_last_line, &restored_first_line) (0)
# # test_maps_tearing_from_remap: Test terminated by timeout
# #          FAIL  proc_maps_race.maps.test_maps_tearing_from_remap
# not ok 3 proc_maps_race.maps.test_maps_tearing_from_remap

# #  RUN           proc_maps_race.smaps.test_maps_tearing_from_resize ...
# ==== Tearing from resize ====
# Before modificationB
# Locked:                0 kB
# THPeligible:           0
# VmFlags: rd wr mr mw me ac 
# -----------------page boundary-----------------
# 3fb30a0000-3fb30a3000 r--p 00000000 00:00 0 
# Size:                 12 kB
# KernelPageSize:        4 kB
# 
# After modificationB
# Locked:                0 kB
# THPeligible:           0
# VmFlags: rd wr mr mw me ac 
# -----------------page boundary-----------------
# 3fb30a0000-3fb30a3000 r--p 00000000 00:00 0 
# Size:                 12 kB
# KernelPageSize:        4 kB
# 
# After restoreB
# Locked:                0 kB
# THPeligible:           0
# VmFlags: rd wr mr mw me ac 
# -----------------page boundary-----------------
# 3fb30a0000-3fb30a3000 r--p 00000000 00:00 0 
# Size:                 12 kB
# KernelPageSize:        4 kB
# 
# Expected stats:                                                             Rss 808 kB
#                                                              Pss 86 kB
#                                                        Pss_Dirty 51 kB
#                                                         Pss_Anon 48 kB
#                                                         Pss_File 34 kB
#                                                        Pss_Shmem 3 kB
#                                                     Shared_Clean 696 kB
#                                                     Shared_Dirty 84 kB
#                                                    Private_Clean 0 kB
#                                                    Private_Dirty 28 kB
#                                                       Referenced 760 kB
#                                                        Anonymous 104 kB
#                                                              KSM 0 kB
#                                                         LazyFree 0 kB
#                                                    AnonHugePages 0 kB
#                                                   ShmemPmdMapped 0 kB
#                                                    FilePmdMapped 0 kB
#                                                   Shared_Hugetlb 0 kB
#                                                  Private_Hugetlb 0 kB
#                                                             Swap 0 kB
#                                                          SwapPss 0 kB
#                                                           Locked 0 kB
# Actual stats:                                                             Rss 808 kB
#                                                              Pss 98 kB
#                                                        Pss_Dirty 59 kB
#                                                         Pss_Anon 56 kB
#                                                         Pss_File 38 kB
#                                                        Pss_Shmem 3 kB
#                                                     Shared_Clean 696 kB
#                                                     Shared_Dirty 84 kB
#                                                    Private_Clean 0 kB
#                                                    Private_Dirty 28 kB
#                                                       Referenced 756 kB
#                                                        Anonymous 104 kB
#                                                              KSM 0 kB
#                                                         LazyFree 0 kB
#                                                    AnonHugePages 0 kB
#                                                   ShmemPmdMapped 0 kB
#                                                    FilePmdMapped 0 kB
#                                                   Shared_Hugetlb 0 kB
#                                                  Private_Hugetlb 0 kB
#                                                             Swap 0 kB
#                                                          SwapPss 0 kB
#                                                           Locked 0 kB
# # proc-maps-race.c:1050:test_maps_tearing_from_resize:Expected 0 (0) != compare_smaps_rollup(self, &orig_stats, &stats) (0)

I'm not sure if this is inteded or the tests need updating.

While running this selftest in LAVA, there seems to be another issue
where the 30 second test timeout doesn't seem to work properly. It
appears as thought the test has hung. I am still looking into this. This
issue doesn't seem to happen while running the test from a shell. It is
probably something to do with how LAVA runs the test.

Regards
Anirudh Srinivasan

> 
>  mm/mremap.c                   | 87 +++++++++++++++++++++++++++----------------
>  mm/vma.c                      | 19 +++++++++-
>  mm/vma.h                      |  7 +++-
>  tools/testing/vma/tests/vma.c | 10 ++---
>  4 files changed, 83 insertions(+), 40 deletions(-)
> ---
> base-commit: a3d0117e02bfa1c3bb6c50e7afe42bbecdbb3459
> change-id: 20260920-fix-dontunmap-partial-self-merge-74a98b1d5a65
> 
> Best regards,
> -- 
> Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 

