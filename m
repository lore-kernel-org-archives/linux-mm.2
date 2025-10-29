Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B315CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 20:46:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A70A8E00FA; Wed, 29 Oct 2025 16:46:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17F1A8E00B2; Wed, 29 Oct 2025 16:46:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 095738E00FA; Wed, 29 Oct 2025 16:46:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E785F8E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:46:11 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 915E413BF0E
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:46:11 +0000 (UTC)
X-FDA: 84052334142.24.899C163
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 210FC80006
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:46:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dhjUqb6m;
	spf=pass (imf02.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761770769; a=rsa-sha256;
	cv=none;
	b=CA5/QOdDMxAm5POjb+sTbcxzMyePu0+YuYc9NSlHFCeZGq7AV7FWLVsDyRBYB+lPMErfP6
	/lx9Md/JWQN1hxh67IxMvTW4GXC8MJwIjNJ0yXVwLAhUD+r+GJ3fYnOLlGbR01uNgfRc2l
	0CoDUpb/yuh/lwz7sDaZstgopsPfNzE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dhjUqb6m;
	spf=pass (imf02.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761770769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oc7TviWFReNwMnSXKOGb/n3L3/gUc3bxbMJqDDekPOM=;
	b=26qdbqotPPBKIeA6ofeckiqC1XE0boG57NWHGVTVTpEX4nyAhhVqsjmyhgsgx/iBOsts7n
	d7X7bwPXKNHxxZVBbbWVcwud5yjIX4gQ1g7NFT62qmAGGVVry9hyyU3vXth6u6n4tOeHLK
	PdpHEzYphufs0lcrqXSU3IccZ/mBnxI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761770768;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Oc7TviWFReNwMnSXKOGb/n3L3/gUc3bxbMJqDDekPOM=;
	b=dhjUqb6mg0S1cykpQw2fBRWlpR3VEz/ZswOPNMZ1NzaUfycq49TqZSm2rbcF5rWLC+6968
	u8yCJTSMLUwqwCaaK5kBDxuAYhik0GOnO559ub8WxtTmazPpTI1Zuox9M8dUZ4hOPLczSF
	0G5mgIucCMTFfkvSNahlE0NyNHURZsU=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-425-jdPjoNbGO5SoJvOTVLrzMA-1; Wed, 29 Oct 2025 16:46:07 -0400
X-MC-Unique: jdPjoNbGO5SoJvOTVLrzMA-1
X-Mimecast-MFC-AGG-ID: jdPjoNbGO5SoJvOTVLrzMA_1761770766
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-591ead2ba5fso146764e87.1
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 13:46:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761770766; x=1762375566;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Oc7TviWFReNwMnSXKOGb/n3L3/gUc3bxbMJqDDekPOM=;
        b=aAS2+QwOBCNfcjlvCpy8ojJ5FtmCHcOGAmhzXsbFT5WBn2FC7VwpkBrEgD+ZOQQw6Z
         akbvRFxLiq05pUrTya7r9Wco+6yID8sN4IMvRmYthmUUkmcMaAJUGMIYMCgMep3nwI9+
         +/iOna/ZTFMkoFS3L0MJ95V3OmarTODCWH48O1W8W3WKQR5ebwSkRVZgnDI4E5JNUIu+
         G9Aa1QDPuF0/zgbyI9/FWgMIDlKUwvaOMsrdxmc/8ho2pyqTrEmzbH5YhlOKKY8x1RXA
         4V/4OLPBQ755PDANDbWiX1q8zzSokkL57zRsdaBwBDE2WwtUD167xi3HJ/ehe5uzNKS0
         KxaQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/u1ewjW2aH1ZCFdN6drHhU6E0WVu0eCovhLx3ANznct58Ri3yUhEVhmEbIKlnAdDvE1JbODstvQ==@kvack.org
X-Gm-Message-State: AOJu0YwXHLIFRbsOk4ZwwaqjJMU2dEWU7VIHkKwfhcs+s4h/DDK4LAJ7
	hXb4vwl7rvVXoKu2dleV1dPzHqkdXdJzY69b0qvGoSB55avXz8FzThBIKj113T4r/MpD7SpN6hx
	gQfgPV2dVpzJbC8ED6K6Rgov0Ok0bq/T9oPYz1k/dVCn4EFSx5YP3M7gLJgirvLblywYioIdxe2
	hwAoI3/xFHmD+uk5+CE5DaYnttCx4=
X-Gm-Gg: ASbGnctOdpYbHjDL9tTqJ6/qbv9J6U0PI9IdyKBIVj43LjdU5CsGS+bdFuIOncIfgjR
	doXFKdGAIuzvk8A+G0Bmt2A48u7f63CQN1I9LKUenqXDBAwAQCeQdWEEyhbpfPPC+AFyBU3EfHF
	yRiA3JMmJnbkiiJGb2i4a5ER1YdVT57lqcBYX8Ae+qMOmMxvgpZGpx6ApPj6BE+GwPd47Cvw==
X-Received: by 2002:a05:6512:b20:b0:592:f263:a8be with SMTP id 2adb3069b0e04-5941287135emr1435955e87.17.1761770765575;
        Wed, 29 Oct 2025 13:46:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IESQyEgec9ex4Rpf1NItxvzspecqCkRicn0v9c5QWtVC9BBjbVp+t2j6z7oKTbm0IWm6xmKhy+0SdXD0hdMpZU=
X-Received: by 2002:a05:6512:b20:b0:592:f263:a8be with SMTP id
 2adb3069b0e04-5941287135emr1435937e87.17.1761770765022; Wed, 29 Oct 2025
 13:46:05 -0700 (PDT)
MIME-Version: 1.0
References: <20251022183717.70829-1-npache@redhat.com> <20251022183717.70829-7-npache@redhat.com>
 <5f8c69c1-d07b-4957-b671-b37fccf729f1@lucifer.local> <063f8369-96c7-4345-ab28-7265ed7214cb@linux.alibaba.com>
 <9a3f2d8d-abd1-488c-8550-21cd12efff3e@lucifer.local> <e2a89e74-1533-4a83-8d0f-3f4821750e25@redhat.com>
 <64b9a6cd-d2e4-4142-bf41-abe80bf1f61a@lucifer.local> <dc002ef9-53ee-4466-b963-baadfd5162b7@redhat.com>
 <a97780ab-6256-43b7-8c0a-80ecbdc3d52d@lucifer.local> <2d8ed924-6d06-42e4-a876-381fb331f926@redhat.com>
In-Reply-To: <2d8ed924-6d06-42e4-a876-381fb331f926@redhat.com>
From: Nico Pache <npache@redhat.com>
Date: Wed, 29 Oct 2025 14:45:37 -0600
X-Gm-Features: AWmQ_bm4p9MBC5sUu8O6J9Sn0293VN6CpobZZzMQVEnRiyb3Ke7AEB3M45KqdEg
Message-ID: <CAA1CXcBi8N2a3b4uEKQ8mzGWTiUEVuPDXx3vonDyBDakjd9bHw@mail.gmail.com>
Subject: Re: [PATCH v12 mm-new 06/15] khugepaged: introduce
 collapse_max_ptes_none helper function
To: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, ziy@nvidia.com, 
	Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, akpm@linux-foundation.org, baohua@kernel.org, 
	willy@infradead.org, peterx@redhat.com, wangkefeng.wang@huawei.com, 
	usamaarif642@gmail.com, sunnanyong@huawei.com, vishal.moola@gmail.com, 
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, kas@kernel.org, 
	aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com, 
	catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org, 
	dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org, jglisse@google.com, 
	surenb@google.com, zokeefe@google.com, hannes@cmpxchg.org, 
	rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org, hughd@google.com, 
	richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz, 
	rppt@kernel.org, jannh@google.com, pfalcato@suse.de
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: topwDytSy8_pDr0_d1-TMpR5JooMt1lJXsUDo11kRW4_1761770766
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: n36upuijxq8dpizdgwujknenifq3x3q5
X-Rspamd-Queue-Id: 210FC80006
X-Rspamd-Server: rspam09
X-HE-Tag: 1761770768-22751
X-HE-Meta: U2FsdGVkX18Z2SONF2qoEn+0haT2HPnGIrVbF/n7/k5y6Wbiorf930gFCQeLE5wAErjbuLp2LCz3bjJVTXc5BUkF0ZQAaEx56dxKD1E4f9A1L0j4179ATNB4mYJMjpAGLr51fAkYiezVbZ1ZkseSmAj0rachXyM6lWZPaaVSkHXlHw9OZKacj/E7kgzzDsAAJQdTPWRvRQx6m/mGabUhXTedAf7cvuIEk4O6wvfbEg4GN1lsCSfo5v0rePJroUHL94IPW/2q6sn/b+rpE64zk41TOI9XIJxd2jzGoxBL3CWDi9KFJCrB5djh49jqvrUD6sBfb+fnSHIrACLQBhuyUsR8D1YH5j2UBvF0utQgSaVE5wtWvZhn50peU4khNITzBcwkicrAyPyE3vRyw9CyjhKlqork4EVZdXru2k4+CI9MWzXPnGfCwWv+9r8O4rTs3wC79HGqOFFjH1RrNdqDcKkVqUlEzS3QhVqbEYbvERWKGdToTMT8z8xB+b8NRAKwn2KnyrQ3dgwCGJeRGcsYhOoS8pbTP2nxy7SRe4wyV8ggGRGowRQIb/+b+0JoAnotYdea8CIPKiVFaZbs5TyEeuv9/Atje2aO2TnMMTAoY8fmD/zurI6Th3GIial4vTWPcs4aZ56VVrleozuOLbXxFZO+sLa/rogz5cCjuZBJURYr8cJPEJWjcqQmpN+fbjoW3ooWP3rP/6ZgSl8Uz1DcX6AFX5kY1qjMUPyagWu0OC+PV+Xd4O+woWYzxpcL3OI+1WHPB0oqs5x+pTa0eNdZief7/gfRHElmsWXzDucI7qKWTZ9rjYduIQRYe0pCpP59hbG0lCVO8kEVHvDb69N16mVQccYEgq8F23zkQobbC88nTSfWtl0sZXvq+V81Qgo+F/rYQiwyde8zAS3+3qhIZU3bJ9GydOxIO/GFMZR0xOI9wzSJ4YWa/80kL5vPE/UIlLWY06gbxGdlkFTAaE8
 MomCnLtO
 YPTKeFW6H1N7iMo7i1mlNwc+0uc8oNDAPA9KXWPq3aZqZVRkkyKvJYktqDKOI1v2UwpAl2wC/JmThOK+/j1fGg0HuUjelmvd6NYU2PTEfYOZ1Wzdq7TYLsTO94IiE4N09a0XRjxnpHc80y6qCa/jocwHBPtPnmewE7q6v5y74ZT4s0Z2d/TXfVNrIuZN5gCx/yh+cs++hCHuq6Pd3bVbLk7NFRleYHfOLyIKXdWSFcQqfy+0jlgIZFendM4XWqGF4OdVA1Myj2bnUO7sQGJcc3jx2H0v1NRK9+GhjW+tkFJj1fg8ZpPDm6kVGfZQOp8qAH3sXtFmYrgq1vCnSba+P4H4iR5Iu9Bhj1H4CScGFrDb9T++vZufo+FRhcACFF0uTfv+tSp7vgAh82Bc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 9:04=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
>
> >>
> >> No creep, because you'll always collapse.
> >
> > OK so in the 511 scenario, do we simply immediately collapse to the lar=
gest
> > possible _mTHP_ page size if based on adjacent none/zero page entries i=
n the
> > PTE, and _never_ collapse to PMD on this basis even if we do have suffi=
cient
> > none/zero PTE entries to do so?
>
> Right. And if we fail to allocate a PMD, we would collapse to smaller
> sizes, and later, once a PMD is possible, collapse to a PMD.
>
> But there is no creep, as we would have collapsed a PMD right from the
> start either way.
>
> >
> > And only collapse to PMD size if we have sufficient adjacent PTE entrie=
s that
> > are populated?
> >
> > Let's really nail this down actually so we can be super clear what the =
issue is
> > here.
> >
>
> I hope what I wrote above made sense.
>
> >
> >>
> >> Creep only happens if you wouldn't collapse a PMD without prior mTHP
> >> collapse, but suddenly would in the same scenario simply because you h=
ad
> >> prior mTHP collapse.
> >>
> >> At least that's my understanding.
> >
> > OK, that makes sense, is the logic (this may be part of the bit I haven=
't
> > reviewed yet tbh) then that for khugepaged mTHP we have the system wher=
e we
> > always require prior mTHP collapse _first_?
>
> So I would describe creep as
>
> "we would not collapse a PMD THP because max_ptes_none is violated, but
> because we collapsed smaller mTHP THPs before, we essentially suddenly
> have more PTEs that are not none-or-zero, making us suddenly collapse a
> PMD THP at the same place".
>
> Assume the following: max_ptes_none =3D 256
>
> This means we would only collapse if at most half (256/512) of the PTEs
> are none-or-zero.
>
> But imagine the (simplified) PTE layout with PMD =3D 8 entries to simplif=
y:
>
> [ P Z P Z P Z Z Z ]
>
> 3 Present vs. 5 Zero -> do not collapse a PMD (8)
>
> But sssume we collapse smaller mTHP (2 entries) first
>
> [ P P P P P P Z Z ]
>
> We collapsed 3x "P Z" into "P P" because the ratio allowed for it.
>
> Suddenly we have
>
> 6 Present vs 2 Zero and we collapse a PMD (8)
>
> [ P P P P P P P P ]
>
> That's the "creep" problem.

I'd like to add a little to this,

The worst case scenario is all mTHP sizes enabled and a value of 256.
A 16kb collapse would then lead all the way up to a PMD collapse,
stopping to collapse at each mTHP level on each subsequent scan of the
same PMD range. The larger the max_pte_none value is, the less "stops"
it will make before reaching a PMD size, but it will ultimately creep
up to a PMD. Hence the cap. At 511, a single pte in a range will
always satisfy the PMD collapse, so we will never attempt any other
orders (other than in the case of the collapse failing, which David
explains above).

Hopefully that helps give some more insight to the creep problem.

Cheers
-- Nico

>
> >
> >>
> >>>
> >>>> max_ptes_none =3D=3D 0 -> collapse mTHP only if all non-none/zero
> >>>>
> >>>> And for the intermediate values
> >>>>
> >>>> (1) pr_warn() when mTHPs are enabled, stating that mTHP collapse is =
not
> >>>> supported yet with other values
> >>>
> >>> It feels a bit much to issue a kernel warning every time somebody twi=
ddles that
> >>> value, and it's kind of against user expectation a bit.
> >>
> >> pr_warn_once() is what I meant.
> >
> > Right, but even then it feels a bit extreme, warnings are pretty seriou=
s
> > things. Then again there's precedent for this, and it may be the least =
worse
> > solution.
> >
> > I just picture a cloud provider turning this on with mTHP then getting =
their
> > monitoring team reporting some urgent communication about warnings in d=
mesg :)
>
> I mean, one could make the states mutually, maybe?
>
> Disallow enabling mTHP with max_ptes_none set to unsupported values and
> the other way around.
>
> That would probably be cleanest, although the implementation might get a
> bit more involved (but it's solvable).
>
> But the concern could be that there are configs that could suddenly
> break: someone that set max_ptes_none and enabled mTHP.
>
>
> I'll note that we could also consider only supporting "max_ptes_none =3D
> 511" (default) to start with.
>
> The nice thing about that value is that it us fully supported with the
> underused shrinker, because max_ptes_none=3D511 -> never shrink.
>
> --
> Cheers
>
> David / dhildenb
>


