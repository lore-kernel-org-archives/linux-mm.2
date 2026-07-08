Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45AC1C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 16:36:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3450A6B0088; Wed,  8 Jul 2026 12:36:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F5A16B008A; Wed,  8 Jul 2026 12:36:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20CCB6B008C; Wed,  8 Jul 2026 12:36:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA55F6B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 12:36:53 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 51790401F0
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 16:36:53 +0000 (UTC)
X-FDA: 84966163506.17.C88856A
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf31.hostedemail.com (Postfix) with ESMTP id 84BBA20006
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 16:36:51 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=swoBkTv+;
	spf=pass (imf31.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783528611;
	b=LDZ7wKs4zN0N2gjq4Gc2zLrZ5UGf0FXQOoZetSz19MK0R8Bn04wRapNk0QondLjkZ1J78M
	Gul2dn4gR+wcMMbKCbZ7e33Y2RALljEIB6J/UaxGWC8e6VBW5/LpqtINfUTmIKWGcSYB8Y
	a3uKiJu4nuMIMC92O2X+7g14veJGOVY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=swoBkTv+;
	spf=pass (imf31.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783528611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jru2Xn1d/tBHCWGdcqrYsKFvTPIWXgg78WJpvLW47rw=;
	b=6sWGnvnIrkEeCEW/i9ontpBSzWk+h3eheiCTRA9nFNJPBPF2H/0Bshu6rAdRfZtyy+F2Af
	bkKAkQybQ4wnjr/bJh2mZ+Z8bITx3mnfeaVGQu2Cl7A5bTWssJHQeVPtUXHEmDSpUiBnel
	6inGUPabBKhJDSfBPCMrK6DuzMGlyIY=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2cacef7d299so116775ad.1
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 09:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783528610; x=1784133410; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jru2Xn1d/tBHCWGdcqrYsKFvTPIWXgg78WJpvLW47rw=;
        b=swoBkTv+IL+F9IVka8gFX9onJJF/oFH8BRbZhNy13tXkL2LiK9MsEzGF9rkMVPIOIZ
         ELvtQ0VG3dK7jJz0TCdq4Pb1lj2S+mN7KycXCj0FYkJ8TbZL4UXAo+cRxF8EVPebCCRZ
         SbII0lClxka0lHABHeGE8Lc0l9sYvW410XT9w/Smny5wROTrCZpdwTPg5p7zLysQiLME
         kZNdKw9e0TU2JkZ6aytaMEEG+7iOWacrXowli4lxrmO/8jP0vh5TOMr6OLAWIElqrh5s
         2acM4YHUHsbZZuwUA87efJ79DqzIrBMpZYNuxqDk/GkfGlTdgjs8/5FOlLpQ2xGWxbJq
         Fkrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783528610; x=1784133410;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jru2Xn1d/tBHCWGdcqrYsKFvTPIWXgg78WJpvLW47rw=;
        b=WqRnw2fceATo9HCuo175lls9HTtZxm6lBeIasYVh6kHZaPonh902/tuGPD7VRcu88t
         nqXuv0nwCFkC6mfw6S8XeEIgPzuGjHGAJyygEGyTexAU06pza321BMr6l4lqyTLtKqUE
         cAsgONVA+uN+BSynb7We+cUyNoAHvs1Fn8wiXcAh1i3HzsQjTGMYPnp9eCjMcyqxfeV6
         jv/CTzwGdBLmRp0haHfYO7mYQK50yex64pm/a158DtIQ4clktn/OF+94dJ0QD+piw5yt
         /mrBCLYz5u6E5PRBxWDROVCILNEpIS6XQUwFwgWPu/2qbpeFB182AlqgMZwGwfz8iSKw
         mB6w==
X-Forwarded-Encrypted: i=1; AHgh+Ro/vTmb4/bzMK84FiqdEfxdUOF8q8OlZnmbFzC21E19lUvCdMevNLVOnWFqtoIpPMCZJ0C5pGLwCg==@kvack.org
X-Gm-Message-State: AOJu0YwDYPuakVN1rN5dRBMS6WIRAYHykXo+VbXO7db2CAoTx8koHNNd
	2G/Q0GkA1QPv6L84C1nOLTIVp3OkOVgkOVgw2nOCo4jJeDsDcZ2fGZJ2B688d4nOCg==
X-Gm-Gg: AfdE7cknkoaYMXyosMBGts+v7zCg/3/i6VQn7VBRWGxWiIjsIzEffKDXYaxS4iPgm8e
	7u6g7W0ZmV7+R/dzhAnLQu8JFssH25SROXF/Erp7q6ds98Iy2d14Uzc/DIWw0qTT/kqiMWs6ITi
	Ptbip6XZ/5iQqth/fQ5mOll+dYaidpcrG1rK9hkzYH/EyaRvN03sSM6LHknBzFRvIZ8C3TYxC+P
	rtuOG53meuR3Y+n3I5dPmL5KoBdmOE8Put7rdsGcm4V0CXAG6HmyXDQikkhAxQOI8pSw1Y0xgSr
	z7e4FK++wwDQoHBmubFQ/30Y00/6++mFDoYI/oGQjKFf4rD1/Byl5JRX3lNEXE777xLkcfjAw0U
	ph2AKaRyhAKzyVeltlizZqFvRGB7ToKM/4ezpvMJXwhsdcaq/KnOBQ2QT7ajjHdn9gAaGcNT4UI
	3FNrWTv/+G4h8yYZi8RPn6cs0HonuE20/hs+BeUpHxYUx2hD/1/uoIYXnxT3jeH/ZRMPNWkkafJ
	nU5QLV0qfODfMd1Oks2/Q==
X-Received: by 2002:a17:902:d4cd:b0:2bf:3579:cdaa with SMTP id d9443c01a7336-2ccff76d125mr137455ad.10.1783528609731;
        Wed, 08 Jul 2026 09:36:49 -0700 (PDT)
Received: from google.com (168.136.83.34.bc.googleusercontent.com. [34.83.136.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84854bf8c9asm66186b3a.41.2026.07.08.09.36.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 09:36:49 -0700 (PDT)
Date: Wed, 8 Jul 2026 16:36:46 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pranjal Shrivastava <praan@google.com>, 
	Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Alexander Graf <graf@amazon.com>, David Matlack <dmatlack@google.com>, kexec@lists.infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] kho: Support preserving unsplit high-order pages
Message-ID: <ak57VeunO8qd4wEh@google.com>
References: <20260703020832.1731864-1-praan@google.com>
 <2vxz7bn5mv0n.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <2vxz7bn5mv0n.fsf@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 84BBA20006
X-Stat-Signature: m7qjpfowbrpftezg4dqo9wur8wurrsca
X-HE-Tag: 1783528611-850455
X-HE-Meta: U2FsdGVkX1/2eO0CnO+f3VRM14TpaexhvioLknnZTXpw3XcQO/fxtHKnb1sxOGmWd/SCc4aPHYzycoE+JMFPG92w9u7awLPe+T+L1WnIkQ0qSN6W4l4ZhAjMS65870kM/DWYARnaZ+wi9kS9rVk6YxCC/tfLd5RGuM/BDfHs2KiKZ+q49rFN01VR8Tw3PtQCQQB0sz3ljwATOgpD5uFRYNoLj4vdSF9vFQ9L8rRvEqOwinxEapwJTp4Ulz0DK4zPcPSdmEeCewv1VPYnKDA6KrBeyT9HKwv8T40zirHaCB9zd05wuQbcHrGRa2M4gNmeYyKqzaezjS7KsJ4uTmc5NgQTe9ulda0gLVZo4/2tCVwDehHsXxYbeBDd6hdSU/Fs26NsNhdQmhv5S2vTeMos8VjmlRugQ+HaKYIuoicknIPRNtLs8a9dyxurcDtIN0BlL9ih8DhfRdTZ6W1rE62gITOT8Me8Hnq5xHBlOY/XSzDveONsWMNrOYM/W3KCx/8Ky1HRnjxCG8JK+uI/gV59yMA+n3PtjxB77X0iTA7y92AvpTa+rQHHitRLK+HBTWnFxGBUQlkumS6NXmWTicd7tA6mM7LvUHS7kvoHl89R/f+m7o+/Qsbim5ubOb0jgnGLqMLdqnBzFuweIQ1BVPEEnbULNCZfMvtTAZ83fvQXEUPi2//z69ILzUByrsC1GwbMDqsc8DkNuUtfoHssDzmcARXoLeK9W/ZvMRIbctdmM3CvvsPwyH2WlVKKoK5Y5MWnaUgmPUPUjc4tDHOHbT/LOY+etGyzoCOVeCy2T8L7AAEvelzMafe8w5ZBfgjxOA7llKdlDeujMjHLksVk16vHUUd36RT3xzABo03sp/NdOCXd/cPj1/oCggtTO9JvyHXCVQAJcZ350lyGFCDmx7WEhDpuuK9UmI7w0DlKJXBbge3m/Tke/JyrtlgXM7nJ9EUrMnfRB8R96cN04yXoCvA
 OCNd8aws
 zVEtY9WS7hrAkkobcRSU3YwN/T1NyHVxLnRaQjAmF4mgykUyIvRxCbg4fU7Z16E7DROQrCG/6RP31y2vcSBb1toQMDFCuvRZlh6voj6vuqbNWUrsYJ3wN+zJ00ly7tzto93CKc7UELewqRhxJcCcGEKuWWmxDpTRz8ltJIpyY1viKFkUmi11oPGEVAFsJFI+LxXb7s17rW+bvQDI3ZtIivivh7YYCqSeqxU/ww642Zsk3JqKdcw0p7xx4SWakMG//JR62tKDPxp6A7UsY0BIcExpgAjvq+RwXb5GlLiSRfgHuH1bhiTYVRm40Laff+ZRcVJp1eagWvao0KHfAcwwiKN5nfUQUnm/J8n74yR/68+kxEj4CnO12Yysq4v8/KxwJZSElK4NxVDAA2J5INAboYBHk4QVLI+wwTYLQbV3LpCYfGjmoVkC08ZXtmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 04:11:04PM +0200, Pratyush Yadav wrote:
>On Fri, Jul 03 2026, Pranjal Shrivastava wrote:
>

[snip]
>>
>> 3. kho_restore_page() applies the correct refcount pattern based on the
>>    preserved metadata.
>
>Why do you need to save the type of pages in KHO metadata? For example,
>for pages or folios, we don't store any type information and leave it to
>the caller choose the right API. So reserve-mem and kho vmalloc need
>pages, they can call kho_{preserve,restore}_pages(), and memfd needs
>folios so it can call kho_{preserve,restore}_folio(). The radix tree
>itself does not hold the information. The caller knows what its memory
>is supposed to be so it calls the right restore API.
>
>So why can't we add a kho_{preserve,restore}_page_multi() (pick a better
>name; we can argue about the naming later)? Then your driver knows it is
>restoring DMA buffers so it can call kho_restore_page_multi(), and KHO
>takes care of initializing the pages with the right refcounts.
>
>You won't have to muck about with the ABI in that case.

+1

I think this makes sense. The mm already relies on the allocator to
track the type of pages it has and expectes it to use free_pages or
put_page() or free_page(), so it is natural for KHO to rely on the
caller to call the right restore API.

Lets add kho_preserve/restore_page_contig|_order|_nonsplit and the dma
preservation can use the appropriate one during restore.
>
>>
>> 4. A new helper, kho_split_preserved_pages(), is provided for subsystems
>>    that may need to split memory after it has already been preserved.
>
>Umm, that sounds scary... Why do you need to do that? What's the use
>case? Why is the driver reconfiguring its memory after preservation? I
>assume these are DMA buffers, so why do they suddenly look different?
>
>And in either case, why does KHO need to do the split? Why can't the
>driver unpreserve old preservation, then split the pages, and then
>preserve the new ones?
>
>>
>> Considerations
>> ==============
>>
>> 1. A primary goal of this approach is to prevent driver/subsystem code
>>    from peeking into MM internals. Drivers should not need to understand
>>    the distinction between head/tail pages or compound metadata. The KHO
>>    core handles this internally.
>>
>> 2. To handle rare cases where a caller might wish to split a high-order
>>    block after preservation, we provide kho_split_preserved_pages().
>>
>> 3. The callers must ensure that the split_page() doesn't race with
>>    kho_preserve_pages for consistency.
>>
>> 4. Folios are always implicitly considered of the CONTIG type
>>
>> Thanks,
>> Praan
>>
>> [1] https://lore.kernel.org/all/20260505002737.2213734-1-skhawaja@google.com/
>> [2] https://elixir.bootlin.com/linux/v7.1.1/source/mm/page_alloc.c#L1370
>> [3] https://elixir.bootlin.com/linux/v7.1.1/source/mm/page_alloc.c#L1027
>> [4] https://elixir.bootlin.com/linux/v7.1.1/source/mm/page_alloc.c#L1034
>>
>> Pranjal Shrivastava (4):
>>   kho: Introduce infrastructure to track preserved page types
>>   kho: Detect preserved page types
>>   kho: Implement page-aware refcount restoration
>>   kho: Introduce kho_split_preserved_pages() helper
>>
>>  include/linux/kexec_handover.h     |   7 ++
>>  include/linux/kho_radix_tree.h     |  17 +++-
>>  kernel/liveupdate/kexec_handover.c | 144 +++++++++++++++++++++--------
>>  3 files changed, 124 insertions(+), 44 deletions(-)
>>
>>
>> base-commit: 87320be9f0d24fce67631b7eef919f0b79c3e45c
>
>-- 
>Regards,
>Pratyush Yadav

Sami

