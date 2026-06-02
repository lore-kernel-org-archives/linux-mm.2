Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67C3DCD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 15:29:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE2976B0088; Tue,  2 Jun 2026 11:29:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C935E6B008C; Tue,  2 Jun 2026 11:29:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B81FD6B0092; Tue,  2 Jun 2026 11:29:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A82216B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:29:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4A27C93010
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 15:29:33 +0000 (UTC)
X-FDA: 84835357026.11.B2C9B3D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id EBC6CC000A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 15:29:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="C2/XgSLv";
	spf=pass (imf10.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780414171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zoHOGHc6Dr79Ii3CKFCTRjW9SLXuC6GuIiX+icbDNi0=;
	b=OCZVY8I46eL8C5v0DALocsMAL0mIodq/IOK+xMNoAE/XHPT6Jz8CXNT0ehxZfGh+WMOCd+
	xIj4MUvYdjhrFiztfWza0qb402Wk0IScraKqbbTTAmVUvWCHfYv21KC0REGbX/aByBCJ92
	Hwtn+phXHVXb2zq4+MHG44R7HDLQQlM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780414171;
	b=guFM/I1/bofZfuxiuaBQqPghnEmL9kPADtpvqXIUNApa7tOKyijIRC9m/BVMG4+ecAx3HE
	948upPLZnz7eP5CArNCimzV91bcibY35w4ERzfUO2cLFWkAMGkvZ5C9lZGN9+Swkaodjth
	FvVUDG8rxEnF9jc09SEgYZjviMrxQbY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="C2/XgSLv";
	spf=pass (imf10.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780414170;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zoHOGHc6Dr79Ii3CKFCTRjW9SLXuC6GuIiX+icbDNi0=;
	b=C2/XgSLvJOJqQFRiOdtokB5IQpWKjGYJdhZQ4A+l+ccu5enm9xcZjwRF+6jppu+xZDWDHx
	0u2l48aeaYEC28ebDUOFtzQNRPu+Frdu/OkjVTO0dcTR9lqYim5E2m03I6DNO8llXJ6bF3
	K/VLvuSOrjVJpvXm73bkkDZH2k2ZbTI=
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com
 [74.125.224.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-426-u5_qcTJTPjqwVYLB_Cc6bw-1; Tue, 02 Jun 2026 11:29:28 -0400
X-MC-Unique: u5_qcTJTPjqwVYLB_Cc6bw-1
X-Mimecast-MFC-AGG-ID: u5_qcTJTPjqwVYLB_Cc6bw_1780414167
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-66044a47d6fso8005728d50.2
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 08:29:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780414167; x=1781018967;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zoHOGHc6Dr79Ii3CKFCTRjW9SLXuC6GuIiX+icbDNi0=;
        b=h7KXTA4RetP+SlE7YqgrclpJBecERrfOuET5TMv24eTdlb7ST+lwcY0cGpikM7jV9k
         NRniQp3jeS2g1uPQn5p8Ri0nDuGW4YYW04D555nYPp7ZLqqvMisZcLOWHVxZpMAu8vt/
         6aasJalP2xa/q4l5fGWjWXxdunOkKZzueai43LGibTxPAiV3qK8ws/fcxr5xLs3P6Y+3
         LsVj93BtDGsAMTodSCCT3GBx4WKoGIZDIKtn7JHA4agRJw1HgV7wHMF2RtKXGq00S+Zj
         CxebqTXT0CHI91Yz+JtENiV643kknaFq1FujCqsfVA2Dile3njds7Ifwfvj2BVsPNvpe
         lDPg==
X-Forwarded-Encrypted: i=1; AFNElJ98PGTP++B2/XyTpSSmvRBllk5o+0rAdqFKCvQrpXfAi3kzcWTPRFoo8niQQMjuM35HQGf/PLeQRw==@kvack.org
X-Gm-Message-State: AOJu0YwECl3RDEBj54vQRaO6fFurV8Dxyp0U3fi+m6eMzqz2wX9/jdyc
	0JFdc9WBt23PT7QW6qnMLtMXx4PWGm5R28oYLHiBbE/kaVkfCfN22Z1Jxj6XL/tz8B28NnKzdBH
	hx2z8aExpMlahVOpvzm4qncDDQvRzxFIlfWuxejtEWOlG+kAxcZAgNYN2cFgxMmZ/WUu61CiYV2
	nWNhfneqJwauBm1EOfopHdpFbK/xs=
X-Gm-Gg: Acq92OGmizg9OTAf+uE9G71K2TrxYImZybWWCRDKgc4DpfQTYd8E2IRGiVlH5/xgnzi
	UyWBy5/ioeZLboIZVObi+iILCgj75YG94ENpg/VAnFvqknQwjUTAnIOnJgHcV7ARIE9ky0yh6Xq
	bQ7lwXKo2EkxdL7iT1AgkUpd2+ejaa3/RiQn2tagoW4H7YBRhQsBQM6ip8IV5co1suiVlXoWiCv
	QffWulCeg4AVKEO5g==
X-Received: by 2002:a05:690e:4395:b0:651:bf58:446b with SMTP id 956f58d0204a3-660d5e4dcfamr221840d50.10.1780414167103;
        Tue, 02 Jun 2026 08:29:27 -0700 (PDT)
X-Received: by 2002:a05:690e:4395:b0:651:bf58:446b with SMTP id
 956f58d0204a3-660d5e4dcfamr221781d50.10.1780414166617; Tue, 02 Jun 2026
 08:29:26 -0700 (PDT)
MIME-Version: 1.0
References: <2024af56-5e99-4799-a586-e9ba756cecb9@kernel.org>
 <20260601032804.96122-1-lance.yang@linux.dev> <f5d38f64-ab92-496d-afd3-29ccc17fec2b@kernel.org>
 <616de1a8-1cfd-40b8-b04f-7b324be40bfd@linux.dev> <6b11bf0a-769c-4ef2-ac6f-2af38200a6bc@kernel.org>
 <baa0a462-46e0-44ab-b583-c722ad253afe@linux.dev>
In-Reply-To: <baa0a462-46e0-44ab-b583-c722ad253afe@linux.dev>
From: Nico Pache <npache@redhat.com>
Date: Tue, 2 Jun 2026 09:30:06 -0600
X-Gm-Features: AVHnY4Kv1G0ugXWOd835wx5jHS-wLy0DPKwsrrM_yqPdHcBhPWzJa9aKptOmpM8
Message-ID: <CAA1CXcD7peS3WHueVgAWhhRrjBO_1b19+Xc0CfZBSO8OwJJKQw@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v18 06/14] mm/khugepaged: generalize
 collapse_huge_page for mTHP collapse
To: Lance Yang <lance.yang@linux.dev>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-doc@vger.kernel.org, 
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
X-Mimecast-MFC-PROC-ID: 6u4UKnPyiJI8bCfIfGOcBGFicIN-RRj5ThnphIpTuJY_1780414167
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EBC6CC000A
X-Stat-Signature: agzmbs9dqggwag9aop89utjcdx4mnwtc
X-HE-Tag: 1780414170-394201
X-HE-Meta: U2FsdGVkX1/BIKJBkmehX1pqYlsdHSczNal8AgTbOsP6rirWjXQj1MeW7CzlcgqgBkroiu8+rxMz3b5PGkprDUTMpUIaU/OoQ1UMZhCrG8yCT9/hxSRv7qImSn/6PyLUviUir2SjUtWkddQobuYd9a3TaIrQcJks9+9sqlV6UrX0TYOzaevO1Ndcaf++ILh+tlKx7hUh0qkSDjTBgUg64VbzicRBUaEW9nkClJ0CoS7tJ5RpzcOrlWW42CxfEVa4S+8RGmL9hhge1mqmWYeObmV+PqC+DcMHm5BksGN19i2Dgg5Pl2RLNfiymDAWLUtEOFzWtXHVT7YC74AfpOcTMXBXSj1D7/AmENqOM/sOsTWseYy0Sch8NHZrfaWz3k9i3ZM4GZu3kmZOtlYYiSMMLc3wwPAezRSDYRoGrcmY605zoi2MLS+PmW8Of/IWYVI/g737nz/6HPQuDaIkpQWirfq5NK2IsXjyRok1/Q9lzGHoDD65wt4y6w0rh2xD176B3dmxX/EXnaSxq4ZTr9HvJriO3RRuslSi1aANS2pJEtyUDi0NevOK0CAdBgXmdvOfGzXykMygJAuPfmT0/g7OImgWxusPCQzHesDNvTCLKRMvvCu7gZkcwd60WUPPbnA268TNRYVB4oc2EY3wlR8XJ2tDlmNlpf+dBd6hTNSTLCzwmDUpsTRzBMpjHIO6PN6cpHZ5H1fIITXllTndHX2Kk7J9m9fBgkfS8zdxezlKJL4/8GWtuA6lMj9ZVOa2nNdoJLOaemRGVogGxZ12r2phMltdNEmy8PLzbwXrrIZebLsRpcSEL8X68hWTutOAfD8U7DPncGm/hRFsy9rkaLxFJa3dRfkryeRXDOuIdPtiIw04nhjfS+tF+sxsNk0EVz7T1CMz3bIN34N7Xsp+XxmS6LKX2q9T70DJKk6ruO6Q2tclXIo3ZO0i3mTnFSl4p7Aoz3nyFxSuQrfMeULgJ9a
 9E7WxsPT
 VsFKcQ5ebQtirGflvx6RROhiocbXOzRUeX5UZgqMqNM9BJfUARWfe4x/C7now9RHk3V7hHph0iiK/9gLxCeOSC0D0iF5+QoCQgRF9Be147+32Tr7HroZBmrRURY1NjN/Jc9ktXbLGcEKT4rdW8quxL/bNjz3xqtzgUSQm6Y0vWY21jkc14E0yZRMgLCwuDJSOnETlQ/1LUT10B/U63fM6CQJDecVl39OzLij75T5jWpdeCO1LMoJgfp9gf3u1vG68ktFn6TmMBW+X+PBBFPUDJuqiMXXWVsMinMSNIxPr0EVIsQz9qgQ2qow524MJbKJAj9AjkU/c5O+zpRj2uuoaZXGnQza0X8FZHPTrMg/ktGRNrCmfjer3TnAqDw2zXxxnNH6QDfPWVyrJIGCu/uVwJ+743XimWmTXqZHFggEez/Lr0dY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 1, 2026 at 4:48=E2=80=AFAM Lance Yang <lance.yang@linux.dev> wr=
ote:
>
>
>
> On 2026/6/1 18:23, David Hildenbrand (Arm) wrote:
> > On 6/1/26 11:08, Lance Yang wrote:
> >>
> >>
> >> On 2026/6/1 14:54, David Hildenbrand (Arm) wrote:
> >>> On 6/1/26 05:28, Lance Yang wrote:
> >>>>
> >>>>
> >>>> Ah, fair point.
> >>>>
> >>>> I was mostly worried about arch hooks that walk vma->vm_mm again, ra=
ther
> >>>> than only using the pte pointer passed in. For example, mips does:
> >>>
> >>> Right, a re-walk would be the real problem.
> >>>
> >>>>
> >>>>     update_mmu_cache_range()
> >>>>       -> __update_tlb()
> >>>>         -> pgd_offset(vma->vm_mm, address)
> >>>>         -> pte_offset_map(...)
> >>>>
> >>>> and __update_tlb() has this assumption:
> >>>>
> >>>>          /*
> >>>>           * update_mmu_cache() is called between pte_offset_map_lock=
()
> >>>>           * and pte_unmap_unlock(), so we can assume that ptep is no=
t
> >>>>           * NULL here: and what should be done below if it were NULL=
?
> >>>>           */
> >>>>
> >>>> So if khugepaged happens to run with current->active_mm =3D=3D vma->=
vm_mm
> >>>> here, could __update_tlb() hit the none PMD, get NULL from
> >>>> pte_offset_map(), and then dereference it?
> >>>
> >>> Likely yes -- that MIPS code is horrible. And the comment in MIPS cod=
e
> >>> even spells that out. :(
> >>>
> >>> Do you know about other code like that, or is MIPS the only one doing=
 a
> >>> re-walk and crossing fingers?
> >>>
> >>>>
> >>>> Just wanted to raise it since some arch code may still have assumpti=
ons
> >>>> like this, and the always-enable-mTHP work is getting closer ...
> >>>
> >>> Right. I assume set_pte_at() couldn't trigger something similar (re-w=
alk) in
> >>> arch code,
> >>> because we simply provide the ptep. update_mmu_cache_range() only con=
sumes the
> >>> pte.
> >>>
> >>>>
> >>>> Probably very very very hard to hit, though :)
> >>>
> >>> Delaying update_mmu_cache_range() is nasty, as we'd have to make sure=
 that
> >>> nobody can interfere in the meantime ... and the PMD lock will not be=
 sufficient.
> >>>
> >>> Maybe we could reinstall the page table with the cleared (none) entri=
es while
> >>> still holding the PTL?
> >>>
> >>> Thinking out loud:
> >>>
> >>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> >>> index 5ba298d420b7..e39b750b1e6f 100644
> >>> --- a/mm/khugepaged.c
> >>> +++ b/mm/khugepaged.c
> >>> @@ -1413,13 +1413,17 @@ static enum scan_result collapse_huge_page(st=
ruct
> >>> mm_struct *mm, unsigned long s
> >>>                   map_anon_folio_pmd_nopf(folio, pmd, vma, pmd_addr);
> >>>           } else {
> >>>                   /*
> >>> -                * set_ptes is called in map_anon_folio_pte_nopf with=
 the
> >>> -                * pmd_ptl lock still held; this is safe as the PMD i=
s expected
> >>> -                * to be none. The pmd entry is then repopulated belo=
w.
> >>> +                * Re-insert the page table with the cleared entries,=
 but
> >>> +                * hold the PTL, such that no one can mess with the r=
e-installed
> >>> +                * page table until we updated the temporarily-cleare=
d entries
> >>> +                * through map_anon_folio_pte_nopf().
> >>>                    */
> >>> -               map_anon_folio_pte_nopf(folio, pte, vma, start_addr, =
/
> >>> *uffd_wp=3D*/ false);
> >>> -               smp_wmb(); /* make PTEs visible before PMD. See pmd_i=
nstall() */
> >>
> >> One small thing, I think we should probably keep the smp_wmb(), and ju=
st
> >> move it before the earlier pmd_populate().
> >>
> >> IIUC, the ordering we want is still:
> >>
> >>    clear old PTEs
> >>    smp_wmb()
> >>    pmd_populate()
> >>
> >> so another CPU cannot walk through the re-installed PMD and still obse=
rve
> >> the old PTEs, right?
> >
> > There is a smp_wmb() in __folio_mark_uptodate(), that should be suffici=
ent?
>
> Ah, cool! __folio_mark_uptodate() already does the job :P
>
> So yeah, no extra smp_wmb() needed here!

are we sure? that folio_mark_uptodate is done before the PTEs are
reinstalled. Then we reinstall the PMD right after. Currently
separated by the smp_wmb().

I was copying this from other THP code that performs similar PTE/PMD juggli=
ng.

I can remove it, but I'd rather air on the side of caution with this.

>
> Cheers, Lance
>


