Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAE29CA0EFC
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 16:46:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3D088E0011; Thu, 21 Aug 2025 12:46:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F13878E0001; Thu, 21 Aug 2025 12:46:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E29BA8E0011; Thu, 21 Aug 2025 12:46:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D2E198E0001
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:46:51 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5CA5C1A00E0
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:46:51 +0000 (UTC)
X-FDA: 83801343822.15.2C15DB0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id DFF0B120003
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:46:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="eBiL0/vk";
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755794809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CrtIXbgafzeCezod7PYLVl1s+ax0OUuwvjrZLQ9YMkw=;
	b=uSUoVG68zgNLR221KmGhcIe7A9tPLTPVb8/onWi5t9cWGWvXavvpsY23jpD9RHRYGkShwW
	1ugWSqz3gxBVcvACZ8NBgnj0qoC92ExlDwjzPYn5TbAUd/gl0/IM6eNqDxGocnK1IIZt42
	tBmLKof9MV5CSTDggL/zsAAVeoF24v0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="eBiL0/vk";
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755794809; a=rsa-sha256;
	cv=none;
	b=sSiS3nCPM1n1KT6OcDtmnzxCUQ7M4C05aGaHnC8FQYVeNnsEEyorlo3LFpqaOTyr+JAtPb
	B3/TDS53Q1VpOj2SCwm16oO3J88584jSCWyQWPp20DzcaHkeLHKwkFXHtY2GYj92ezusnk
	ZEOrsdOkgb5lVHJuWU7dJ23dOPnWqME=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755794808;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CrtIXbgafzeCezod7PYLVl1s+ax0OUuwvjrZLQ9YMkw=;
	b=eBiL0/vkdGRiCg1eOXk87zgfx2mft0OFH31y7gjNvJNHIDffyUNpIoXioPZPCu6FQXnkSM
	ZMp3BVI+PmEvjWH32FrxfohglkzCdcqOL1uhuNhs/pQM2dq9yv7qd8qhuCQUnzReKgZ+7t
	XXSuDUBNcnLGTqgThg6PlcZKP10NM9Y=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-114-KY92UF2EMN6Waw0A3FeFXQ-1; Thu, 21 Aug 2025 12:46:47 -0400
X-MC-Unique: KY92UF2EMN6Waw0A3FeFXQ-1
X-Mimecast-MFC-AGG-ID: KY92UF2EMN6Waw0A3FeFXQ_1755794806
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-71d600f9467so15221157b3.0
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 09:46:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755794806; x=1756399606;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CrtIXbgafzeCezod7PYLVl1s+ax0OUuwvjrZLQ9YMkw=;
        b=tHiEbbvMhaRdnbBKx4qrRmqyAqgeRZYlhXSvMU6/5fEAiVXRDRvSxjof9DBWJzp8m0
         wzpuBzZ7++aPvtzWBE0gHCYiDaJE/c3t75IlY5hiDa5HJMyeuiPTt3gVsB6xK2TYVr+Y
         gOINB6LHlBh15mNyaF8hOstAPuxvQjrEn72i9pv7M/BE3dhHjS5BHOAjhznVdV1YIVkg
         8Xb/ZBgVVzCRgWwoiHFbplJAIdmAVf3B/FC2P/qK1R0RpM4wFHu83Bhw0Oo6XuluU6qW
         2x/28FE8vYG0UhwbFLy43AzzlgBLwUAPf5IBwB3or4fOQbEizaId36CGW8Qlm6Ig1AEp
         5l9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWrHOV9i2RrB3wC/GKvn7Ipd+ivJccoK30LsL86a2+bqOQ/fXtglkIaNxlIOdSJdqTX7pxCiJ59Vw==@kvack.org
X-Gm-Message-State: AOJu0YyGbsrF1mr3UyF2OkSgnsY5P9fWMxsbyNO/OCJZop0QFpqJuKga
	c6f5NngR3CQI2kCXOXHGvfVG6tVtepMU6uKto/4AF/m6l6WnFPMq7HPR91YUATjSMmaj+8Gb5xh
	b2FVyjDf9ezus+V4pjFKVx+/otvrECJKDgF625usH9osNM6QdspGwkjBBbENUKclxnOXjr1+Lry
	kaC4dMVcjVt0m4dGo69plmUdhdgks=
X-Gm-Gg: ASbGncsL4YWmc21EF4UBd+qqmZHmk9GVPH+BxAhs+CjTqVEUpF2saGKJJqzTVwf9coV
	SY6DTOBi72r1LHiY/2PQzKL6dPaXUaczr0qlw/BqV3W9Nf34l8I75sM+y427L3tbSOBp/zc7+F8
	zuGlhf4emC6ftTOFtYXPeix4A=
X-Received: by 2002:a05:6902:100e:b0:e93:3bef:e01e with SMTP id 3f1490d57ef6-e951c2c83e8mr219570276.2.1755794806140;
        Thu, 21 Aug 2025 09:46:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHfqUfsas2F3doNqS6BSKUG3YCszLmKMRtctwEjzAX/JZnaeEO3udW9FnxE4ev1vtDOEGhPCLBWe8mQkGNnEvw=
X-Received: by 2002:a05:6902:100e:b0:e93:3bef:e01e with SMTP id
 3f1490d57ef6-e951c2c83e8mr219500276.2.1755794805518; Thu, 21 Aug 2025
 09:46:45 -0700 (PDT)
MIME-Version: 1.0
References: <20250819134205.622806-1-npache@redhat.com> <e971c7e0-70f0-4ce0-b288-4b581e8c15d3@lucifer.local>
 <38b37195-28c8-4471-bd06-951083118efd@arm.com> <0d9c6088-536b-4d7a-8f75-9be5f0faa86f@lucifer.local>
 <CAA1CXcCqhFoGBvFK-ox2sJw7QHaFt+-Lw09BDYsAGKg4qc8nSw@mail.gmail.com>
 <CAA1CXcAXTL811VJxqyL18CUw8FNek6ibPr6pKJ_7rfGn-ZU-1A@mail.gmail.com> <5bea5efa-2efc-4c01-8aa1-a8711482153c@lucifer.local>
In-Reply-To: <5bea5efa-2efc-4c01-8aa1-a8711482153c@lucifer.local>
From: Nico Pache <npache@redhat.com>
Date: Thu, 21 Aug 2025 10:46:18 -0600
X-Gm-Features: Ac12FXzSV_TeCPS1yO_m6RxtfmwTbbPB-Js0Syvou348xGcst1M_U3eimOxq4ZI
Message-ID: <CAA1CXcBDq9PucQdfQRh1iqJLPB6Jn6mNy28v_AuHWb9kz1gpqQ@mail.gmail.com>
Subject: Re: [PATCH v10 00/13] khugepaged: mTHP support
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, ryan.roberts@arm.com, corbet@lwn.net, 
	rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org, 
	peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com, 
	sunnanyong@huawei.com, vishal.moola@gmail.com, 
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, 
	kirill.shutemov@linux.intel.com, aarcange@redhat.com, raquini@redhat.com, 
	anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de, 
	will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org, 
	jglisse@google.com, surenb@google.com, zokeefe@google.com, hannes@cmpxchg.org, 
	rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org, hughd@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zhrTWWahu8JPPS2jsg2GPln3DpASFuyy7NfVsQb34xA_1755794806
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DFF0B120003
X-Stat-Signature: kdxw8rfy1ikq74dxc5hyon3u7mbpu7en
X-Rspam-User: 
X-HE-Tag: 1755794808-78360
X-HE-Meta: U2FsdGVkX182bjZPXEaeA04LwPqdyNtBJlNoQKlL2W7ZmQloKEr23NxOZeCdRRXJCXWskXeRUxxXoLkodmD2z3wl2zq9CzOyOUx+dH9aLyIoVg9DL3vFDfaI157dW3uompPx4DldL5kwitkZH+RFs7cDr6Xkg7zCoDC6Rd/sJE0EO9uuRzN7JWsStkbctg1KB9/6nJwN0GtNt2m1x/r3mPzNwbHlKIbQoEpOwgMndb0wuKkVvQ69MI2c4wunMpUhhAH3Xy37csbELz0Srd97FA+ubiAKkprbiTAL7MnlnifOmZaP096E52XBhDnErOCxwPUhcJWFpj40ccff0TlhiaB2hwUHQIRzWthW0EPFj4JPo0bJf1yeyotpdd13yB4o2rAFRhX+TEHvCNWC9ckkuHWbZkJzhS+nxrxzJdNxSnaF6SplPNAIzxDcqPB7PnvcaKMcXgWIglL/rGWC8FuRWY/Sdr7NPKgJW39cWYAEpHo2ZwlA00exhAdZHgztj9xMzE9SF0U4FyEQmc4ATA7BSIM2TZ0r3xWRu8WDBWoKPEdmwq2oRg78tEmffW7qEFQWarhWD4QlaPwc4E3hmBD1ZAo9lVqTxMoQrlc4sqsXF4wX9JmdLh5yynhdGWaCdPk8rxRbv87xTj2VatelFC6enTPgUqki0tBF+KMV5+hCRTQOVPZpwkZfMtlssPHBqiLn1+9+la7KFVlo3s83CyXJpdFTZS5zy6rUaqQouLRVo4GBaIxJxNKxYw8fEm7eTfYIITqF/Xbh+T8vXcyxS80O1twHlrcyPCI2XhIMqEHdJ8gMlGsnuTA3bfuTbs48YNFk2dkmuyqpA5xiCczmHCHzxqQqzoPrCCfZImX2HZl8l8IeRFf3sxmFKQsWBAF59aSPOQdlaubxl/bW+iIF01dqy5CjsvftFwaBnUCewfdodQItllzvt36ktG5NaT9LzJT2uk0kW7X3ND+11TmfW5i
 QDBHBtWp
 UWo/MJ7PFjX9Kstcp3AtGlZVAv6m/jE8AI/cSLl3oaFShZnzjBkZy/22kj0fnFQclVH0xxKD/WxEAulSnwJj96njJVET6RtbQSWN3eNplCaPCxWeFzuFoAApJb16NNV6+l4cK9tBvlCeJcQvEdumExSMv65rRP0ig9cbJP1AnATSHgFM4GI1+iTXUvHedGOhA0W3tGN7NvhO9ahQO7Xvqw/QUbyNVu9cdCNliuj6mVh8UsO6lQ7nR5pS6ZxcBEBlk5Yq5Ut0H8Vb6DKzsHxIWj5QzgQ+u0f8kDxOW/85id7+ejKrEvNExnlD+C0vu0JC2dkIzuBwmOQ+FHykPLYohaoLzCBT1hYrSse9GA9KMTrmS4F1rFVnwrMFcyiQwfE0waT/GFPcXpluPTF4+AS6SOJF4bZS0RpCDxCp0gjGnxBYMvNd0ML3OfgmWZT5RaQDEZ7zW5XONfsg9uL8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 9:40=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Thu, Aug 21, 2025 at 09:27:19AM -0600, Nico Pache wrote:
> > On Thu, Aug 21, 2025 at 9:25=E2=80=AFAM Nico Pache <npache@redhat.com> =
wrote:
> > >
> > > On Thu, Aug 21, 2025 at 9:20=E2=80=AFAM Lorenzo Stoakes
> > > <lorenzo.stoakes@oracle.com> wrote:
> > > >
> > > > On Thu, Aug 21, 2025 at 08:43:18PM +0530, Dev Jain wrote:
> > > > >
> > > > > On 21/08/25 8:31 pm, Lorenzo Stoakes wrote:
> > > > > > OK so I noticed in patch 13/13 (!) where you change the documen=
tation that you
> > > > > > essentially state that the whole method used to determine the r=
atio of PTEs to
> > > > > > collapse to mTHP is broken:
> > > > > >
> > > > > >     khugepaged uses max_ptes_none scaled to the order of the en=
abled
> > > > > >     mTHP size to determine collapses. When using mTHPs it's rec=
ommended
> > > > > >     to set max_ptes_none low-- ideally less than HPAGE_PMD_NR /=
 2 (255
> > > > > >     on 4k page size). This will prevent undesired "creep" behav=
ior that
> > > > > >     leads to continuously collapsing to the largest mTHP size; =
when we
> > > > > >     collapse, we are bringing in new non-zero pages that will, =
on a
> > > > > >     subsequent scan, cause the max_ptes_none check of the +1 or=
der to
> > > > > >     always be satisfied. By limiting this to less than half the=
 current
> > > > > >     order, we make sure we don't cause this feedback
> > > > > >     loop. max_ptes_shared and max_ptes_swap have no effect when
> > > > > >     collapsing to a mTHP, and mTHP collapse will fail on shared=
 or
> > > > > >     swapped out pages.
> > > > > >
> > > > > > This seems to me to suggest that using
> > > > > > /sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none as=
 some means
> > > > > > of establishing a 'ratio' to do this calculation is fundamental=
ly flawed.
> > > > > >
> > > > > > So surely we ought to introduce a new sysfs tunable for this? P=
erhaps
> > > > > >
> > > > > > /sys/kernel/mm/transparent_hugepage/khugepaged/mthp_max_ptes_no=
ne_ratio
> > > > > >
> > > > > > Or something like this?
> > > > > >
> > > > > > It's already questionable that we are taking a value that is ex=
pressed
> > > > > > essentially in terms of PTE entries per PMD and then use it imp=
licitly to
> > > > > > determine the ratio for mTHP, but to then say 'oh but the defau=
lt value is
> > > > > > known-broken' is just a blocker for the series in my opinion.
> > > > > >
> > > > > > This really has to be done a different way I think.
> > > > > >
> > > > > > Cheers, Lorenzo
> > > > >
> > > > > FWIW this was my version of the documentation patch:
> > > > > https://lore.kernel.org/all/20250211111326.14295-18-dev.jain@arm.=
com/
> > > > >
> > > > > The discussion about the creep problem started here:
> > > > > https://lore.kernel.org/all/7098654a-776d-413b-8aca-28f811620df7@=
arm.com/
> > > > >
> > > > > and the discussion continuing here:
> > > > > https://lore.kernel.org/all/37375ace-5601-4d6c-9dac-d1c8268698e9@=
redhat.com/
> > > > >
> > > > > ending with a summary I gave here:
> > > > > https://lore.kernel.org/all/8114d47b-b383-4d6e-ab65-a0e88b99c873@=
arm.com/
> > > > >
> > > > > This should help you with the context.
> > > > >
> > > > >
> > > >
> > > > Thanks and I"ll have a look, but this series is unmergeable with a =
broken
> > > > default in
> > > > /sys/kernel/mm/transparent_hugepage/khugepaged/mthp_max_ptes_none_r=
atio
> > > > sorry.
> > > >
> > > > We need to have a new tunable as far as I can tell. I also find the=
 use of
> > > > this PMD-specific value as an arbitrary way of expressing a ratio p=
retty
> > > > gross.
> > > The first thing that comes to mind is that we can pin max_ptes_none t=
o
> > > 255 if it exceeds 255. It's worth noting that the issue occurs only
> > > for adjacently enabled mTHP sizes.
>
> No! Presumably the default of 511 (for PMDs with 512 entries) is set for =
a
> reason, arbitrarily changing this to suit a specific case seems crazy no?
We wouldn't be changing it for PMD collapse, just for the new
behavior. At 511, no mTHP collapses would ever occur anyways, unless
you have 2MB disabled and other mTHP sizes enabled. Technically at 511
only the highest enabled order always gets collapsed.

Ive also argued in the past that 511 is a terrible default for
anything other than thp.enabled=3Dalways, but that's a whole other can
of worms we dont need to discuss now.

with this cap of 255, the PMD scan/collapse would work as intended,
then in mTHP collapses we would never introduce this undesired
behavior. We've discussed before that this would be a hard problem to
solve without introducing some expensive way of tracking what has
already been through a collapse, and that doesnt even consider what
happens if things change or are unmapped, and rescanning that section
would be helpful. So having a strictly enforced limit of 255 actually
seems like a good idea to me, as it completely avoids the undesired
behavior and does not require the admins to be aware of such an issue.

Another thought similar to what (IIRC) Dev has mentioned before, if we
have max_ptes_none > 255 then we only consider collapses to the
largest enabled order, that way no creep to the largest enabled order
would occur in the first place, and we would get there straight away.

To me one of these two solutions seem sane in the context of what we
are dealing with.
>
> > >
> > > ie)
> > > if order!=3DHPAGE_PMD_ORDER && khugepaged_max_ptes_none > 255
> > >       temp_max_ptes_none =3D 255;
> > Oh and my second point, introducing a new tunable to control mTHP
> > collapse may become exceedingly complex from a tuning and code
> > management standpoint.
>
> Umm right now you hve a ratio expressed in PTES per mTHP * ((PTEs per PMD=
) /
> PMD) 'except please don't set to the usual default when using mTHP' and i=
t's
> currently default-broken.
>
> I'm really not sure how that is simpler than a seprate tunable that can b=
e
> expressed as a ratio (e.g. percentage) that actually makes some kind of s=
ense?
I agree that the current tunable wasn't designed for this, but we
tried to come up with something that leverages the tunable we have to
avoid new tunables and added complexity.
>
> And we can make anything workable from a code management point of view by
> refactoring/developing appropriately.
What happens if max_ptes_none =3D 0 and the ratio is 50% - 1 pte
(ideally the max number)? seems like we would be saying we want no new
none pages, but also to allow new none pages. To me that seems equally
broken and more confusing than just taking a scale of the current
number (now with a cap).


-- Nico

>
> And given you're now proposing changing the default for even THP pages wi=
th a
> cap or perhaps having mTHP being used silently change the cap - that is c=
learly
> _far_ worse from a tuning standpoint.
>
> With a new tunable you can just set a sensible default and people don't e=
ven
> necessarily have to think about it.
>


