Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28886CA1010
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 02:55:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 848188E000A; Wed,  3 Sep 2025 22:55:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81E758E0001; Wed,  3 Sep 2025 22:55:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 734C28E000A; Wed,  3 Sep 2025 22:55:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5CB568E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 22:55:12 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F310D1409B5
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 02:55:11 +0000 (UTC)
X-FDA: 83850051222.08.FADA430
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id BD1F8140003
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 02:55:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JmjFlbDE;
	spf=pass (imf26.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756954509; a=rsa-sha256;
	cv=none;
	b=VYMogcGtEZ7z9dWm5E4OvChZkqnUnnF2isduYQPNW/PpdgAEhKb028HY3liYQl5BkczT9G
	bvxUHWMFWlDk6kxV3rhFwjztGCXLR1S9WjPLNoaTwcVuHLZK2dmZHKCMxbzhk3gb2cm3XX
	eG5I3oAQJqC5nDDgEUnJ2ORga8j2bEQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JmjFlbDE;
	spf=pass (imf26.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756954509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BFGsvyfGlZeRUoo142qkd9fYdJJZqaobhSbYex4lato=;
	b=C+01M6twKR+7hBBuHqcNiOpfythYagvJDB3kJqUYDTKq2YtkWe1Q5XVrZImMjh35d2o0gS
	t5y+DXRx9KmOjafyktAlGHSqHyuyi/rxVYhO2OvJp2aBN6P7gjPOIydBqMUB2rdaC/dzn0
	6HEcgDDkbHipNHzZZFFKVLxczjJI1Rk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756954509;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BFGsvyfGlZeRUoo142qkd9fYdJJZqaobhSbYex4lato=;
	b=JmjFlbDEySnDZF9YYVFoOFsbAnywXyUrwr9ftux3re5h2DGbfn6MZgidrMB9J5mEkuH3a5
	IS0imKgGH5sQSOUPgoI/Aab6FSjeOYQO40zVe6YuCdo3BXn/IMRyRMPqWlNg9RxkACmkBj
	OBjkbsLqBUyUar1PFOCdGvGA+m/B/l0=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-587-vLQg8eUjMRqs5lICaBeAEA-1; Wed, 03 Sep 2025 22:55:07 -0400
X-MC-Unique: vLQg8eUjMRqs5lICaBeAEA-1
X-Mimecast-MFC-AGG-ID: vLQg8eUjMRqs5lICaBeAEA_1756954507
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-722866d8e9fso9010287b3.2
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 19:55:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756954507; x=1757559307;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BFGsvyfGlZeRUoo142qkd9fYdJJZqaobhSbYex4lato=;
        b=v5TmwFxZtZlmv0rICfFZoeUVlf6JsFtZsRhXyMxvdD/h+eqekvD/p0xXcoG4tedwy5
         4x1nPPOqI5t4SbHbI3rqKRTh1o2xAF9HoNyIBV6IhihMdQR9M18pKBmjoJHbsrudz+WC
         ZFCBVVUrnAVOSgohtv3u1FQJJnaIQHjwt2wP1faGWEPUbl9Z47Agk3YUM/37VOY3SNOc
         kuJtPNjgai+3sFbS45UrkUPp5CMzSsGAi5cmtT/1UO2vYM8HDCFNzArAI+LWx2lauW9B
         gkVr8/8XeHKG8/YvbEhwvjXFfxTM5dJK0gJqNGs9jPdK30/T1ODGNBm3G8LyO5f89pfn
         onyw==
X-Forwarded-Encrypted: i=1; AJvYcCU3NbZk8y48dOvBktvxfh3SrEvLNXcUAu5cH/Tvlw2XDL9TtO8bpkaTsSk1LNSEVcB2oRy9Pc1+BA==@kvack.org
X-Gm-Message-State: AOJu0YwbvepsZ7KQlWo5bfcv6R/XF0gRhsgm6OanPVVHPQetWcXtATD0
	lNxieaDmlyzmFs+vd4Irbp90BuktfBTZKuc04fyz0y3QQfWMTEBrGKdtpJGT6RgHyep8AMkZqwV
	dvlmEIBGm/fCowV9jRA85e73GFEn1sN7WCnEGqsQA0z+BpYCbPIpV8SlqtX+yjqcKHmYqAqb+1G
	sRXi4whB5ra5SE6LCE+T65herixqI=
X-Gm-Gg: ASbGncuSh+oRUeH2UZiZrisF6lGpTROKJT1zz6RT7HiYyeNic6uP/31sqPF6I+3kr5V
	zbLmL+6T16BNj6/sfZ3cIaMVMEDylsbGDxMYa+OqRzF1uNjJ30Aibp3Mm4dbS7miz2CzYfH8HC5
	JgkFWY4OqPOLLezyBN5HGmxoZd2mQB6dSspkI=
X-Received: by 2002:a05:690e:2483:b0:5fc:aef:28c9 with SMTP id 956f58d0204a3-601782d5d5dmr1244612d50.29.1756954506645;
        Wed, 03 Sep 2025 19:55:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFDp5KBBiAm/A14c1UZ2x88hWB4XMoRs9mNoQ299w19LQV6LRXEBDT8MMPS9G/48qZ5qMyz3tFyTQ/kB1gAxKA=
X-Received: by 2002:a05:690e:2483:b0:5fc:aef:28c9 with SMTP id
 956f58d0204a3-601782d5d5dmr1244576d50.29.1756954506194; Wed, 03 Sep 2025
 19:55:06 -0700 (PDT)
MIME-Version: 1.0
References: <20250819134205.622806-1-npache@redhat.com> <0d9c6088-536b-4d7a-8f75-9be5f0faa86f@lucifer.local>
 <CAA1CXcCqhFoGBvFK-ox2sJw7QHaFt+-Lw09BDYsAGKg4qc8nSw@mail.gmail.com>
 <CAA1CXcAXTL811VJxqyL18CUw8FNek6ibPr6pKJ_7rfGn-ZU-1A@mail.gmail.com>
 <5bea5efa-2efc-4c01-8aa1-a8711482153c@lucifer.local> <CAA1CXcBDq9PucQdfQRh1iqJLPB6Jn6mNy28v_AuHWb9kz1gpqQ@mail.gmail.com>
 <d110a84a-a827-48b4-91c5-67cec3e92874@lucifer.local> <95012dfc-d82d-4ae2-b4cd-1e8dcf15e44b@redhat.com>
 <bdbb5168-7657-4f11-a42d-b75cce7e0bca@lucifer.local> <e34e1ffe-c377-4c9a-b28b-ca873f3620ac@redhat.com>
 <db2320ee-6bd4-49c1-8fce-0468f48e1842@linux.alibaba.com> <c8c5e818-536a-4d72-b8dc-36aeb1b61800@arm.com>
 <2a141eef-46e2-46e1-9b0f-066ec537600d@linux.alibaba.com> <f34b5fcb-6a97-4d97-86a8-906083b53be6@redhat.com>
 <eb02c281-6d41-44af-8eaf-8ffc29153a3a@linux.alibaba.com> <286e2cb3-6beb-4d21-b28a-2f99bb2f759b@redhat.com>
 <17075d6a-a209-4636-ae42-2f8944aea745@gmail.com> <287f3b64-bc34-48d9-9778-c519260c3dba@redhat.com>
 <ad6ed55e-2471-46be-b123-5272f3052e01@gmail.com>
In-Reply-To: <ad6ed55e-2471-46be-b123-5272f3052e01@gmail.com>
From: Nico Pache <npache@redhat.com>
Date: Wed, 3 Sep 2025 20:54:39 -0600
X-Gm-Features: Ac12FXyZ7Om70-q7zqgNTiGl13FCHecHMQ3x9cRnHFwQsUK8x6vVkC5jouQ4XXQ
Message-ID: <CAA1CXcCMPFqiiTi7hfVhhEvHs4Mddiktvpmb7dMe4coLDF0bgg@mail.gmail.com>
Subject: Re: [PATCH v10 00/13] khugepaged: mTHP support
To: Usama Arif <usamaarif642@gmail.com>
Cc: David Hildenbrand <david@redhat.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Dev Jain <dev.jain@arm.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, ziy@nvidia.com, Liam.Howlett@oracle.com, 
	ryan.roberts@arm.com, corbet@lwn.net, rostedt@goodmis.org, 
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org, 
	peterx@redhat.com, wangkefeng.wang@huawei.com, sunnanyong@huawei.com, 
	vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com, 
	yang@os.amperecomputing.com, kirill.shutemov@linux.intel.com, 
	aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com, 
	catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org, 
	dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org, jglisse@google.com, 
	surenb@google.com, zokeefe@google.com, hannes@cmpxchg.org, 
	rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org, hughd@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 41CHiYIO_cwzJ0Hqr_cdSqfK2A-nQ9RTWAI8ymtBWQ8_1756954507
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BD1F8140003
X-Stat-Signature: 4jxune4wf3ydbfwd1di7xeoy5b7qo3pp
X-Rspam-User: 
X-HE-Tag: 1756954509-182119
X-HE-Meta: U2FsdGVkX1+NUKtA/8BDZRD7LCP9OQ1hekiPLqRwweHX3vFD59b29w5VV+xR2N5zefSEss/zoUJ56as7JgVjDPZ8K2ejLU2FdjiKEGdBmiofEhANZUrPPzIw/PuZhsi9q6NmT5r+8S1UFlcCv41K26Wptl+0/X7ZtxJIQQ1Cam57usVuDuU/BeFscxclHDHLYGtrCit+SMORsysKnOb6ud7tyTitao4ZSIFunQPltPYA0+FeRSM2FWGRQUcfBmbgtANvrGRgubRcW1gV/4ku9cP0ALwzwLYhXqqfZMXgY/kFyA4ZeQEYeDJem6+7kpnvsAAgpW0V1ZwpHg4vz8PE+lvLRckPjxEB21B2Rf6wkJPMBCvtX0HVpfPIRFJKMfGYyHCm42UVghYrRZpp217i7LE9BRzaMQ/PNhAOOwxCAD/vGs69b9TEE1OIL2pCiGcpXU5tRx3gNxGHiA+BAQpwdZ4enekwxJ5Zqe8hnhtmjkmnWEK4+xFdTb318NNAcEE4Vbbtcjn1jENZFs+tCWGKPNSk1UxuRDNZNQBoOluSyFMzfmUwPlFQDB7zKhVL9UFm+Dxob/HS8jONH9KQwT701DiIZiz7J8rLnvGDWnZ0co8QpxArO7iP5n5Y0tU5BC7csrTYi4lFtcjAhITri3y9qK4W3rfC94UGMIlcWWqGgEFHUTWTcjZWlYxb1WSSApX2REh9DGQ9nLgsdYsy7XU3haY9HoJH+PoZfZzC7r2zB9x4ST+2HYNTm5Z8gBXZXD155GrpFKjEXpdv29LJ/UzFz7kVO3AfgorMxeIZ0pBaQFXsaPQAoOgvAmdg6M3EGJE21+1htfebjTVvAQHDo4NkhBDj0qt7ZyD5vslpUaD5DjcxDtIMnYwxJ8Eu5SNWJzz1SiHXKTDaLnihGNmFPvANKKucepxDn9wZySxK2jILZv2UvWpr/vm8ruJpMOVMSElMwVZBQ5ZKyjJoSZHrZoj
 Rp8YvA69
 5ywTkesXCNAGBssE1/CuEC4AX5TrsfQjuHpIDY733ogfUo2wvlvnIt6emFJoJNDWHUVeMCpXpy8NFVWNlmiEAgSDCPi5pbAyBkW/9C5EVDvsbUcUaUya29nUajMkZ3Ci+R1fg+0Lm99ZP1A5ORtwuEpBeNFa74PCFq04Hp1qCKDOFhet6SSUrSVkYnQeI/0nuo88stXM6hqCYNOP3JqU50lnxv8qDDACkZrpRbrGc/Ei5uCouR8xj4PVFbs76Tesh9ojASImLWPYTyVqjtNST48r3VazBo45yb9/GXoXuPVb6VSSuoW7HwdQgblfkCKIbYynRhWAnRQaepdTsIF2CGFoXiTlwwhoNhsZx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 2, 2025 at 2:23=E2=80=AFPM Usama Arif <usamaarif642@gmail.com> =
wrote:
>
>
>
> On 02/09/2025 12:03, David Hildenbrand wrote:
> > On 02.09.25 12:34, Usama Arif wrote:
> >>
> >>
> >> On 02/09/2025 10:03, David Hildenbrand wrote:
> >>> On 02.09.25 04:28, Baolin Wang wrote:
> >>>>
> >>>>
> >>>> On 2025/9/2 00:46, David Hildenbrand wrote:
> >>>>> On 29.08.25 03:55, Baolin Wang wrote:
> >>>>>>
> >>>>>>
> >>>>>> On 2025/8/28 18:48, Dev Jain wrote:
> >>>>>>>
> >>>>>>> On 28/08/25 3:16 pm, Baolin Wang wrote:
> >>>>>>>> (Sorry for chiming in late)
> >>>>>>>>
> >>>>>>>> On 2025/8/22 22:10, David Hildenbrand wrote:
> >>>>>>>>>>> Once could also easily support the value 255 (HPAGE_PMD_NR / =
2- 1),
> >>>>>>>>>>> but not sure
> >>>>>>>>>>> if we have to add that for now.
> >>>>>>>>>>
> >>>>>>>>>> Yeah not so sure about this, this is a 'just have to know' too=
, and
> >>>>>>>>>> yes you
> >>>>>>>>>> might add it to the docs, but people are going to be mightily
> >>>>>>>>>> confused, esp if
> >>>>>>>>>> it's a calculated value.
> >>>>>>>>>>
> >>>>>>>>>> I don't see any other way around having a separate tunable if =
we
> >>>>>>>>>> don't just have
> >>>>>>>>>> something VERY simple like on/off.
> >>>>>>>>>
> >>>>>>>>> Yeah, not advocating that we add support for other values than =
0/511,
> >>>>>>>>> really.
> >>>>>>>>>
> >>>>>>>>>>
> >>>>>>>>>> Also the mentioned issue sounds like something that needs to b=
e
> >>>>>>>>>> fixed elsewhere
> >>>>>>>>>> honestly in the algorithm used to figure out mTHP ranges (I ma=
y be
> >>>>>>>>>> wrong - and
> >>>>>>>>>> happy to stand corrected if this is somehow inherent, but real=
lly
> >>>>>>>>>> feels that
> >>>>>>>>>> way).
> >>>>>>>>>
> >>>>>>>>> I think the creep is unavoidable for certain values.
> >>>>>>>>>
> >>>>>>>>> If you have the first two pages of a PMD area populated, and yo=
u
> >>>>>>>>> allow for at least half of the #PTEs to be non/zero, you'd coll=
apse
> >>>>>>>>> first a
> >>>>>>>>> order-2 folio, then and order-3 ... until you reached PMD order=
.
> >>>>>>>>>
> >>>>>>>>> So for now we really should just support 0 / 511 to say "don't
> >>>>>>>>> collapse if there are holes" vs. "always collapse if there is a=
t
> >>>>>>>>> least one pte used".
> >>>>>>>>
> >>>>>>>> If we only allow setting 0 or 511, as Nico mentioned before, "At=
 511,
> >>>>>>>> no mTHP collapses would ever occur anyway, unless you have 2MB
> >>>>>>>> disabled and other mTHP sizes enabled. Technically, at 511, only=
 the
> >>>>>>>> highest enabled order would ever be collapsed."
> >>>>>>> I didn't understand this statement. At 511, mTHP collapses will o=
ccur if
> >>>>>>> khugepaged cannot get a PMD folio. Our goal is to collapse to the
> >>>>>>> highest order folio.
> >>>>>>
> >>>>>> Yes, I=E2=80=99m not saying that it=E2=80=99s incorrect behavior w=
hen set to 511. What I
> >>>>>> mean is, as in the example I gave below, users may only want to al=
low a
> >>>>>> large order collapse when the number of present PTEs reaches half =
of the
> >>>>>> large folio, in order to avoid RSS bloat.
> >>>>>
> >>>>> How do these users control allocation at fault time where this para=
meter
> >>>>> is completely ignored?
> >>>>
> >>>> Sorry, I did not get your point. Why does the 'max_pte_none' need to
> >>>> control allocation at fault time? Could you be more specific? Thanks=
.
> >>>
> >>> The comment over khugepaged_max_ptes_none gives a hint:
> >>>
> >>> /*
> >>>   * default collapse hugepages if there is at least one pte mapped li=
ke
> >>>   * it would have happened if the vma was large enough during page
> >>>   * fault.
> >>>   *
> >>>   * Note that these are only respected if collapse was initiated by k=
hugepaged.
> >>>   */
> >>>
> >>> In the common case (for anything that really cares about RSS bloat) y=
ou will just a
> >>> get a THP during page fault and consequently RSS bloat.
> >>>
> >>> As raised in my other reply, the only documented reason to set max_pt=
es_none=3D0 seems
> >>> to be when an application later (after once possibly getting a THP al=
ready during
> >>> page faults) did some MADV_DONTNEED and wants to control the usage of=
 THPs itself using
> >>> MADV_COLLAPSE.
> >>>
> >>> It's a questionable use case, that already got more problematic with =
mTHP and page
> >>> table reclaim.
> >>>
> >>> Let me explain:
> >>>
> >>> Before mTHP, if someone would MADV_DONTNEED (resulting in
> >>> a page table with at least one pte_none entry), there would have been=
 no way we would
> >>> get memory over-allocated afterwards with max_ptes_none=3D0.
> >>>
> >>> (1) Page faults would spot "there is a page table" and just fallback =
to order-0 pages.
> >>> (2) khugepaged was told to not collapse through max_ptes_none=3D0.
> >>>
> >>> But now:
> >>>
> >>> (A) With mTHP during page-faults, we can just end up over-allocating =
memory in such
> >>>      an area again: page faults will simply spot a bunch of pte_nones=
 around the fault area
> >>>      and install an mTHP.
> >>>
> >>> (B) With page table reclaim (when zapping all PTEs in a table at once=
), we will reclaim the
> >>>      page table. The next page fault will just try installing a PMD T=
HP again, because there is
> >>>      no PTE table anymore.
> >>>
> >>> So I question the utility of max_ptes_none. If you can't tame page fa=
ults, then there is only
> >>> limited sense in taming khugepaged. I think there is vale in setting =
max_ptes_none=3D0 for some
> >>> corner cases, but I am yet to learn why max_ptes_none=3D123 would mak=
e any sense.
> >>>
> >>>
> >>
> >> For PMD mapped THPs with THP shrinker, this has changed. You can basic=
ally tame pagefaults, as when you encounter
> >> memory pressure, the shrinker kicks in if the value is less than HPAGE=
_PMD_NR -1 (i.e. 511 for x86), and
> >> will break down those hugepages and free up zero-filled memory.
> >
> > You are not really taming page faults, though, you are undoing what pag=
e faults might have messed up :)
> >
> > I have seen in our prod workloads where
> >> the memory usage and THP usage can spike (usually when the workload st=
arts), but with memory pressure,
> >> the memory usage is lower compared to with max_ptes_none =3D 511, whil=
e still still keeping the benefits
> >> of THPs like lower TLB misses.
> >
> > Thanks for raising that: I think the current behavior is in place such =
that you don't bounce back-and-forth between khugepaged collapse and shrink=
er-split.
> >
>
> Yes, both collapse and shrinker split hinge on max_ptes_none to prevent o=
ne of these things thrashing the effect of the other.
I believe with mTHP support in khugepaged, the max_ptes_none value in
the shrinker must also leverage the 'order' scaling to properly
prevent thrashing.
I've been testing a patch for this that I might include in the V11.
>
> > There are likely other ways to achieve that, when we have in mind that =
the thp shrinker will install zero pages and max_ptes_none includes
> > zero pages.
> >
> >>
> >> I do agree that the value of max_ptes_none is magical and different wo=
rkloads can react very differently
> >> to it. The relationship is definitely not linear. i.e. if I use max_pt=
es_none =3D 256, it does not mean
> >> that the memory regression of using THP=3Dalways vs THP=3Dmadvise is h=
alved.
> >
> > To which value would you set it? Just 510? 0?
> >
>
> There are some very large workloads in the meta fleet that I experimented=
 with and found that having
> a small value works out. I experimented with 0, 51 (10%) and 256 (50%). 5=
1 was found to be an optimal
> comprimise in terms of application metrics improving, having an acceptabl=
e amount of memory regression and
> improved system level metrics (lower TLB misses, lower page faults). I am=
 sure there was a better value out
> there for these workloads, but not possible to experiment with every valu=
e.
>
> In terms of wider rollout across the fleet, we are going to target 0 (or =
a very very small value)
> when moving from THP=3Dmadvise to always. Mainly because it is the least =
likely to cause a memory regression as
> THP shrinker will deal with page faults faulting in mostly zero-filled pa=
ges and khugepaged wont collapse
> pages that are dominated by 4K zero-filled chunks.
>


