Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07447CD6E74
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 17:04:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D8296B0005; Thu,  4 Jun 2026 13:04:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B0B06B0088; Thu,  4 Jun 2026 13:04:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C60B6B008A; Thu,  4 Jun 2026 13:04:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D4A46B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 13:04:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A52CB161903
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 17:03:59 +0000 (UTC)
X-FDA: 84842852598.01.19E196D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 24CC21C0006
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 17:03:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KixjPKkc;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780592637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mFdbSvVLclwxYmscPcZ8kkZXJU9Ks9VowvahVknrrs4=;
	b=24OUG5cd40JhZT4T6jZ+LsYeLqVIOV/HYtLxRxiniGpcuWMrJ4oVW+c3eCGcCHQ5x+dNEh
	6MdDGCEfbf4W+7qYSoOgdYSgkiBTB0CI+BWv5vxwaDheL092/YKSgWq89Nxoxz7Pkyhr4o
	Gm9rRAJ4C6gn9Vn7jJ4oIa+yuhyv2w8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KixjPKkc;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780592637;
	b=EtW0eyIm0O6rBQ+MGidZEgKLXbgTWYlYxNKuucxORJXLM8I9VPHAXe2LyALk9/KPPRVdxv
	lbtw14tNrGUcP1NZdjh1xNIofKOR0bBKTqB6LYV+fHVAhXcydBIjwj1HUFmGxunzdykN1c
	I3HqPI8c1YlD3H3ysqFV9LiNPSy2U8g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780592636;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mFdbSvVLclwxYmscPcZ8kkZXJU9Ks9VowvahVknrrs4=;
	b=KixjPKkcIh2mT0u10q+P/TOAblb3SHaXmQr7H6VDzAOZL1j+HZMvdcWNnidwC2KTk0Lv5E
	EdqZZc3Diaf+nx7m3IFz2vQWpc0BdPKy+yn5Ej7c/rzCoAsZ0X1GX0XKNIg4KZ4g0dkTMU
	tCdQHdIpONx3r3f9Lmy6RXjaLSiMU30=
Received: from mail-yx1-f69.google.com (mail-yx1-f69.google.com
 [74.125.224.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-281-CbwltO-KMQugo1QYBkwVIA-1; Thu, 04 Jun 2026 13:03:55 -0400
X-MC-Unique: CbwltO-KMQugo1QYBkwVIA-1
X-Mimecast-MFC-AGG-ID: CbwltO-KMQugo1QYBkwVIA_1780592635
Received: by mail-yx1-f69.google.com with SMTP id 956f58d0204a3-66044a47d6fso1845742d50.2
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 10:03:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780592635; x=1781197435;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mFdbSvVLclwxYmscPcZ8kkZXJU9Ks9VowvahVknrrs4=;
        b=Uw8WPt2Cddxpum8d8g4eLhUd7cCAnCUAfVuZY/dqffYtUe7FRs72HLpAKKtKURER+2
         f8TD7YRhuZb4D4Hzd4losSph9pVb5+7ckhB7oJOGKgXhWY0PSyf5k7DQEc35Q8hghrme
         mPahKdNWvNbd6of8qRVw+aeXtUMeCnd76SCMCuVBSrZY3srAR+yL2v93jFXeLMEjskn3
         nBHNPhv9qTefCrPG4RpAGR8PssW4d21XdW0o1WBLFsjTiivr5v/0o6UcChM07ooM5Jer
         PfVjvTFERqMeTjW2xcTJTziYpyy3r8Vw7wsOSBNxcLkgsS/Cus1m2pZ4SLQu48F7nDyE
         rzqQ==
X-Forwarded-Encrypted: i=1; AFNElJ9uYOI/xMWzEs1WXKvevvU2XsEcUk4smKHXCGHmLKvwCaPJlx3DSGZaT35rWMc5QL5QsisOo8iPBQ==@kvack.org
X-Gm-Message-State: AOJu0Yy644h74ZOQnPPSFiDnijo4oW2h27YBFgKbByXecwTSktWVQPCB
	buaxX+hvBtfSdzieXo1AY4veNB+62tzjbD+ozeVOOu2+KIi+hYAMIUhqrJlT6jcVbi01iiXxwUV
	3bJXOKvrLqswZ+42THmZDK9xPXbdHp4PvfCW5Kz3IxRnVKXXI6vjitndPfXR++GU3TnFJ2N5D/P
	ZxB93gIhTq5y1sARQcjoF4gTecIsI=
X-Gm-Gg: Acq92OEobMkFxz6NqWPLuOFcbMjz6yOjfxsJh65y7Z/y5Ex9aGSghv7x2I/GYENxBjB
	jiMhy7fYnj+BMZgjlXYYNxvNVrOq3bdFudtrNnM0vmKRL1U7kNR7u/fgKQny/P9JjHEdifB0/2R
	5BTCyH56YkcUTL06D3JQ5vdPKoxxj+Z3TQ9/C8SR4OM6IUlaU9J+riRU37YWASgF/FZxO8AJxT2
	oKEG1/6reL8GTM=
X-Received: by 2002:a53:d016:0:b0:660:689b:1539 with SMTP id 956f58d0204a3-660dc5af389mr7257809d50.58.1780592634539;
        Thu, 04 Jun 2026 10:03:54 -0700 (PDT)
X-Received: by 2002:a53:d016:0:b0:660:689b:1539 with SMTP id
 956f58d0204a3-660dc5af389mr7257769d50.58.1780592633890; Thu, 04 Jun 2026
 10:03:53 -0700 (PDT)
MIME-Version: 1.0
References: <2024af56-5e99-4799-a586-e9ba756cecb9@kernel.org>
 <20260601032804.96122-1-lance.yang@linux.dev> <f5d38f64-ab92-496d-afd3-29ccc17fec2b@kernel.org>
 <616de1a8-1cfd-40b8-b04f-7b324be40bfd@linux.dev> <6b11bf0a-769c-4ef2-ac6f-2af38200a6bc@kernel.org>
 <baa0a462-46e0-44ab-b583-c722ad253afe@linux.dev> <06d9b665-945f-4967-9ed9-b06514478996@kernel.org>
 <CAA1CXcAeEGOsqp-ywAQ7GMYQzXEeco-rUxUkk2hEF69HybC4=w@mail.gmail.com>
In-Reply-To: <CAA1CXcAeEGOsqp-ywAQ7GMYQzXEeco-rUxUkk2hEF69HybC4=w@mail.gmail.com>
From: Nico Pache <npache@redhat.com>
Date: Thu, 4 Jun 2026 11:04:35 -0600
X-Gm-Features: AVHnY4I_L8TwfZPfpH2lQFz1V2RvpVRsRnPJ_VPp-rqHDi22wC_1Io6tlGI8brU
Message-ID: <CAA1CXcBSPVG4CJFCBDvbuodcJ_7eXoDQTpK0ZN0HEhkDPi-DEw@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v18 06/14] mm/khugepaged: generalize
 collapse_huge_page for mTHP collapse
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com, 
	jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, 
	liam@infradead.org, ljs@kernel.org, mathieu.desnoyers@efficios.com, 
	matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com, 
	rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com, usama.arif@linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hm1p-uFE9NBFqlQM8IxzxsCWWakC0WeuoPSkqh7zbJo_1780592635
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 24CC21C0006
X-Stat-Signature: yjcusx3rbucbw1ktobcpaysif5cdednu
X-HE-Tag: 1780592636-817953
X-HE-Meta: U2FsdGVkX1/NgbkvlWtg31NSf3GG+zgKPsayc35FadbVpAG+YbmQIHhMVCw/53c+Wwd5DRI6gDN/FCM1pbM39GktKFwohomfYNg526E2CbaB1mxQQjZmSu8+XAu8QK9EEjiK8sPXrAv2zdbbPeIgraZiBcu6wOt58IHIsVyfSipK3DAmgP1HOYGwGqK4XrZYIjKuf0y3phD61elIJ8kPREaesQIEeY1B4xcspBVPBiwxkMrtBaj6rAR3ooe/5Ay2R5EnJQX9drmOgCNNQBY/KloI/SK9GnIdqfbR19U2FYUCWEgUB8rMJOvVBZhrqEHIC0y0tZAtE30cbZCbrqb8LTATVz9G3LT9vARWdlnBlaWnpelDN/C8HMjToyMXCQF/iil/qiwpunmyWwLZPu1oh3qf8JrM1dhNNxprvZRXhfwkPF1g7WBPVl4TAtoskntj2NffR76hc1ZZBGCLpb3kmsKXt+NQQqXewIpch/893q+DdjEsrnK0lguB2Y2jQmm1NP+QoZweEKZd8swRPoxh5oLtaIEfy/1m0vMfni91j2+OKkyVecFlepXWLvx9R3qfbjIpszNADRtOX7haslIc+jCJie0G3C1pvLcMgqSAxUJp920v0+7tfDXqANQc7vqwJ9mVHz4IwhoW7ncyIDKq7PWh4oPK2yPpVg4L2+TBpmGDR7B6LvS1VSK3zNKZ+/ReGjqgfpc4pkOcY3iijdZ8HTnmqNfIokUZJp4Owm17vrvZ+6WYCgEwJTlLeTWman/9cBUhuwJflxzAkYnngHLMwSobLMmvrsmP6zhwea/tBZx7/JYt2/N1CgTWKNrDSOz8U4YLmZ5nE2zz9sayeucbI2D6+mIWzSN94oYd0Aj+lE9FOuCyDMnRgx66DVOiaGaH1GroxDdaz69jEGDVmQSjY9pPsy8cYiM5pgSGV1ARuACCr3Qyz1DZpDCTs4iGhbCo4pExHt80tjV35pVC/+W
 8/gLx6pW
 4+wFO+HvnsirgchEK/30Rvbd7mC5W+SJePNcBbp3mcevZL1R5OYzxkUc2Eysh7htl/C3eOg2uXgEy8/4KMOR5vcBo03zlns/kLYdqmkzr24aVdRdspf4o5xEUx1tJADR0cEUeJBo7cvXhWPGo3wXQyM2K17IcFvImREqsFyxeCF9RSnI7+77CXCuw6oVcE1RvWQhvZGGx4ferfcLcw7QHW0KvrS+jMLR4iRtKTUfz5IT2ozzbOjBJq2sfo8cGdCG8Z7Wvn7VrTJVkCxCPHrUDYQ+PE9L7yRLgIWLvUR32Lm9sLNPMoQWB/hqLVT/UMhLbmufj/jh2e3UEO3gxzEQzp8yQBgdKuskOo6a53IgamMj/uZiCX1Io8lXxDFQhxWxrSOjIRUSd+JJNp1CFSUeqCItjwcQW8oy2osOuoSZaPWjADvOQVNsx9tt4007KZ4239KLck0aOnjoe/qVczHwfztyAmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 1, 2026 at 9:00=E2=80=AFAM Nico Pache <npache@redhat.com> wrote=
:
>
> On Mon, Jun 1, 2026 at 5:14=E2=80=AFAM David Hildenbrand (Arm) <david@ker=
nel.org> wrote:
> >
> > On 6/1/26 12:47, Lance Yang wrote:
> > >
> > >
> > > On 2026/6/1 18:23, David Hildenbrand (Arm) wrote:
> > >> On 6/1/26 11:08, Lance Yang wrote:
> > >>>
> > >>>
> > >>>
> > >>> One small thing, I think we should probably keep the smp_wmb(), and=
 just
> > >>> move it before the earlier pmd_populate().
> > >>>
> > >>> IIUC, the ordering we want is still:
> > >>>
> > >>>    clear old PTEs
> > >>>    smp_wmb()
> > >>>    pmd_populate()
> > >>>
> > >>> so another CPU cannot walk through the re-installed PMD and still o=
bserve
> > >>> the old PTEs, right?
> > >>
> > >> There is a smp_wmb() in __folio_mark_uptodate(), that should be suff=
icient?
> > >
> > > Ah, cool! __folio_mark_uptodate() already does the job :P
> > >
> > > So yeah, no extra smp_wmb() needed here!
> >
> > Yeah. BTW, I think we'd need a spin_lock_nested(), so @Nico, treat my c=
ode as a
> > draft.
>
> Okay, I read the above and did some investigating.
>
> I will try to implement and verify the changes you suggested :)

I've implemented something slightly different actually and I *think* its be=
tter!

} else {
       /* this is map_anon_folio_pte_nopf with no mmu update */
        __map_anon_folio_pte_nopf(folio, pte, vma, start_addr,
                      /*uffd_wp=3D*/ false);
       smp_wmb();
        pmd_populate(mm, pmd, pmd_pgtable(_pmd));
        /*
         * Some architectures (e.g. MIPS) walk the live page table in
         * their implementation. update_mmu_cache_range() must be called
         * with a valid page table hierarchy and the PTE lock held.
         * Acquire it nested inside pmd_ptl when they are distinct locks.
         */
        if (pte_ptl !=3D pmd_ptl)
            spin_lock_nested(pte_ptl, SINGLE_DEPTH_NESTING);
        update_mmu_cache_range(NULL, vma, start_addr, pte, nr_pages);
        if (pte_ptl !=3D pmd_ptl)
            spin_unlock(pte_ptl);
    }
spin_unlock(pmd_ptl);

The logic here is that when the PMD becomes visible, PTEs are already
populated (no possibility of spurious faults on local CPU)

the SMP_WMB makes sure of the above

And the pmd is installed with the pte and pmd lock both held through
the mmu_cache update.

This follows the conventions used in pmd_install() and clears the
potential for local CPU faults hitting cleared PTE entries.

I think both approaches are correct but this prevents any possibility
of my first point. although mmap_write_lock prevents this too.

Let me know what you think. I can revert to your implementation but
this is what I tested.

Cheers,
-- Nico

>
> Or an even crazier idea... what if we ensure MIPS checks for PMD_none
> before walking a PTE table?
>
> -- Nico
>
> >
> > --
> > Cheers,
> >
> > David
> >


