Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E436CA0FE1
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 15:26:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB8066B00B3; Thu, 21 Aug 2025 11:26:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8FD46B00B5; Thu, 21 Aug 2025 11:26:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CDD66B00B6; Thu, 21 Aug 2025 11:26:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8ADD36B00B3
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:26:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3E40258EB2
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 15:26:14 +0000 (UTC)
X-FDA: 83801140668.17.07842E2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id E411840007
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 15:26:11 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YvvpiNFM;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755789972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JEKkDobB8vwmnFpvY8PoyUMJCycz91A8IkaT8DFK9XU=;
	b=4HorrzqZL5mhFy95lI4sbzTSYaN1iIVmHpZ6EPaS6y86C8vBgoKl85i9SbxtNEr89gF8Zx
	zcLEmhNZv8yJsnHM4BvAKR8bJg1n5/WrWpmJBXZ+jJucc9tvZc1qU2DFD/n8OSPg9I99uw
	RGlZiHESdcxLPK+CnvHDWBayIa6Omt4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YvvpiNFM;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755789972; a=rsa-sha256;
	cv=none;
	b=zTsiKrwTiKVWb9vT3UGinAT3gtM6E2maFrvCIMBiQwhLIjOD0yrPOitvNyaxGulUsyNjnE
	zDQHlnAf7+Mo1KhqD/K9ibirpvrXm2AbAptZmgtfp2bZZWw3Je3bZQLXIFYt6fFCHHdtn8
	nOqpanIY5ZBUJU5MN9l3DAdMT/Poiq8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755789971;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JEKkDobB8vwmnFpvY8PoyUMJCycz91A8IkaT8DFK9XU=;
	b=YvvpiNFMPeyo+Diq7WO+z/dX4WVekcOuPLOTQC1obdairmSUKDZ66ChNMvCg2YXasSTP/X
	v3VSHPrep6oXp2brhGD+Aq1mDN6TNUw1Oor1h5bNbvppkA9XPsgUUeIW/H7UQF8Nh+ahPW
	hJbT+jh9vqXXVJKIzcITuhg/FS/jIWg=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-A4aXUy-1OWaDpqBFjW14nw-1; Thu, 21 Aug 2025 11:26:10 -0400
X-MC-Unique: A4aXUy-1OWaDpqBFjW14nw-1
X-Mimecast-MFC-AGG-ID: A4aXUy-1OWaDpqBFjW14nw_1755789970
Received: by mail-yb1-f199.google.com with SMTP id 3f1490d57ef6-e950f1d3da5so1026505276.1
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 08:26:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755789970; x=1756394770;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JEKkDobB8vwmnFpvY8PoyUMJCycz91A8IkaT8DFK9XU=;
        b=Y0vLNSpaSk+JM9FHNTiR08htGlju22TflaPnyO8W+2ruyrKatGQQIoOyvHGK9BP0lS
         /nlSXQoOPD8b4CuKoMksDcKbZpEYj7cqq4K8Bqi1ZP4sp+u+gPvkJbpKpFmTNy5OxniO
         rb/iPjadaw+Ol43Vi0gvjdSSSj16MwrV34ZIE+RmBHvd560MwxebS2W4JIdwpToPbYyf
         UCpByBTslRpX8hz3Lr3EyV1tqZl3XISyyBMTuMVVsqspLMrEZHGH64xImsi2jhiTRaEL
         nTod3XqImBapUghrCujSq0tIpFsM34lnz3QSUOOsIH7PRZ5sKF0NVB5SKTqM12gINoY1
         ZIMA==
X-Forwarded-Encrypted: i=1; AJvYcCV0aZBBVORXx+2Sk96mEA+bk7UuTm+uO13uEnsbf47V70dOovwAevlw9pS+A3Py1ewVGQI1ZUl77w==@kvack.org
X-Gm-Message-State: AOJu0YwoZsPp1n7o7GtLJQNePUx/E6Hf+9VbFc5Kh8EybA5oJHp/G2/a
	8WdLtBdOJpOPUZ7CBi+zVh32Hncf1Uyou64QcbWUgyrsObQBUsElzSFsCJBzslLAYmA9GcgFE3X
	Aht+h7Hd5pfisbOjK/3ugqMmWBg2PwFjSXcnFKBOVa7Rfznp4FlXt5CB4C0ciw6wDIFt5VQ51m/
	Ia8B3aTJMeUqLRPK/Z87n+vg1Qlsk=
X-Gm-Gg: ASbGncuSFTIVC7wiopBO+PDOcLwImyNNUnYVwLwTx4gShORWxVwymmpyk8Hf0lRH/5/
	BO4uUkWl3MbOWGomBB1AXFSRX29e88Ae6aFH8rn93c5FssmGJ2GYhCAkrpYl/31byqUiHe5ejLg
	doJhaWQTfGsINOtZXPjK4m9gI=
X-Received: by 2002:a05:6902:100b:b0:e93:b92c:ee20 with SMTP id 3f1490d57ef6-e95088e66fdmr2698959276.6.1755789969175;
        Thu, 21 Aug 2025 08:26:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEA0f6PQCn0aQQ73DO5x40Ev9z93mEJijQRhHTNYum23X09DqH0vh6LBZKUrLyYzx7jARY0Uu5ScQ6B+4yOKuI=
X-Received: by 2002:a05:6902:100b:b0:e93:b92c:ee20 with SMTP id
 3f1490d57ef6-e95088e66fdmr2698871276.6.1755789968301; Thu, 21 Aug 2025
 08:26:08 -0700 (PDT)
MIME-Version: 1.0
References: <20250819134205.622806-1-npache@redhat.com> <e971c7e0-70f0-4ce0-b288-4b581e8c15d3@lucifer.local>
 <38b37195-28c8-4471-bd06-951083118efd@arm.com> <0d9c6088-536b-4d7a-8f75-9be5f0faa86f@lucifer.local>
In-Reply-To: <0d9c6088-536b-4d7a-8f75-9be5f0faa86f@lucifer.local>
From: Nico Pache <npache@redhat.com>
Date: Thu, 21 Aug 2025 09:25:42 -0600
X-Gm-Features: Ac12FXxfRB0-YWz05cxs6Jud7daM5CQrb2gQwUVzVsT0dS5nUzi2PQuSgYs9--g
Message-ID: <CAA1CXcCqhFoGBvFK-ox2sJw7QHaFt+-Lw09BDYsAGKg4qc8nSw@mail.gmail.com>
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
X-Mimecast-MFC-PROC-ID: dQL4gjRCCTU-MfXNlxV9EAuUawf3_tp5ynirTWFmmtY_1755789970
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E411840007
X-Stat-Signature: hoqgmw3spfz4os1q3s3bq3znmi5w9cag
X-Rspam-User: 
X-HE-Tag: 1755789971-363648
X-HE-Meta: U2FsdGVkX1/jIZz1UlXqv3owtki9oKHDgBfmfOLYL8PXTYV5ArQY0zF/ONnOiAZwB3GAr/ZE9ZbC30GmwI59rJZz5Bj5CzT01t3lAP9PEMaKuDp7cLnyfljBPYRd/eguONDezSaToiQOkatvgawfyPT92U30Vy/D8XqeRYyanEmxWh+UcRuL7vr4z3x9CkxcRGNzc5UZbXrRQFNiV/p736wZu6B3SiCl5u3TJUD2UNN0rI7OIF+MR9iDMj5YThjBGpYBrvv3JJ1TLsJi6OjyktGOQnRLIRPt/qyKqg9NMYj3YCXc3nFJwmjIvFliugp+xXnqt/UiqOY/+BsSYBliR6gcT4VRi4qBBx/2pTdjxU15glJ5vtXDOeyDRskqSGKZBn1rhm/e9uXqAF0UXemIBK1eg4u2ZtpQjWPOhKxjBG3MWJHZgJm7pSTDKbiJn7MK8Q2S5Or1I3mdHY3RKriwD6CArI3Qbq4Lz7uO3cDW5fE/yZEZWuVMKwm60WcSV0Z6V1UCJIEsUbHqOKQ28rejEghSH88NbuB+o1j1dCMYsQQ6P6ulC5jKmQqOk1miLG79++6yjVqO49K/mKZWL4Am/u/zvL8hL2iAf4oIjj5J6sdD1GEF7S59gxnVXLPSNA7R9h7ILP2o7afAVf3DFPQRhqMNZ0l3nNci4AmVgWdHUz5mzZzwaqtqaOScy7RvOVLgSqBaTZqXGIPC94+V8UXSrgXZTfQxlesRTgFx77k3eh/K3dg0b3qct6i5dEoyQao+wKgIUA344rXX4cgbXYom0SrKGdIX8IcI9MlmcOHWTpblw9uf1UESzfNqN5b0XQT24XbSa5SYAPXaeyAVa2EYreAxJRWz4kGcJfPW2K5XkiaDPnHjny612zC2f0zR9IEtMudzWMVuxD0msGQh6aAXE/ibrtNYlGesdcTZX+RrCS6P0UkeEOMzpOpCj7iD24lI1XEg5qo48hjVRxpS9iy
 00x5AC1K
 DNRZRhpjge5UnyJFaEU80QmcreCuXh+6hKcHNAidG4ahkaaArfSxWUbwxWEem8D9nshVBF1HH1fF0RCmZ4r7BK85GGLAj2F4AYUJmOt9X6izJJVsdnGzU/U+KOyaZFDQ/Csyt4iyBdC9O09fFiZp30fc5M1lLzmF069wGLXIyE5TZBZZQifKfMJ4oQ7CZVx8Fqj2B+BMubp5p1OdNiiZXKHVtxrJ0yAtxch2T+a/tzTla0MpZTui+JgFalCcw69gZUHLOIFrmIpQInop2PPRNM6RERivJCys6Guo78RSBX0zqBXuVs1TTA0bD8ozu0+U6B1OzA1vyxBb7LqTcMsJRyFR56sKS/I+FCMWoHd32I+WpyMfANlJfXqw6ds9DRDNBZd6aNnvRUpPBKTgGz78kuo3t+xgYg123QrdhaVmRfqW2F3t1Ht+a7N7nBgEXtK7QNemjKCBPfjW03+Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 9:20=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Thu, Aug 21, 2025 at 08:43:18PM +0530, Dev Jain wrote:
> >
> > On 21/08/25 8:31 pm, Lorenzo Stoakes wrote:
> > > OK so I noticed in patch 13/13 (!) where you change the documentation=
 that you
> > > essentially state that the whole method used to determine the ratio o=
f PTEs to
> > > collapse to mTHP is broken:
> > >
> > >     khugepaged uses max_ptes_none scaled to the order of the enabled
> > >     mTHP size to determine collapses. When using mTHPs it's recommend=
ed
> > >     to set max_ptes_none low-- ideally less than HPAGE_PMD_NR / 2 (25=
5
> > >     on 4k page size). This will prevent undesired "creep" behavior th=
at
> > >     leads to continuously collapsing to the largest mTHP size; when w=
e
> > >     collapse, we are bringing in new non-zero pages that will, on a
> > >     subsequent scan, cause the max_ptes_none check of the +1 order to
> > >     always be satisfied. By limiting this to less than half the curre=
nt
> > >     order, we make sure we don't cause this feedback
> > >     loop. max_ptes_shared and max_ptes_swap have no effect when
> > >     collapsing to a mTHP, and mTHP collapse will fail on shared or
> > >     swapped out pages.
> > >
> > > This seems to me to suggest that using
> > > /sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none as some =
means
> > > of establishing a 'ratio' to do this calculation is fundamentally fla=
wed.
> > >
> > > So surely we ought to introduce a new sysfs tunable for this? Perhaps
> > >
> > > /sys/kernel/mm/transparent_hugepage/khugepaged/mthp_max_ptes_none_rat=
io
> > >
> > > Or something like this?
> > >
> > > It's already questionable that we are taking a value that is expresse=
d
> > > essentially in terms of PTE entries per PMD and then use it implicitl=
y to
> > > determine the ratio for mTHP, but to then say 'oh but the default val=
ue is
> > > known-broken' is just a blocker for the series in my opinion.
> > >
> > > This really has to be done a different way I think.
> > >
> > > Cheers, Lorenzo
> >
> > FWIW this was my version of the documentation patch:
> > https://lore.kernel.org/all/20250211111326.14295-18-dev.jain@arm.com/
> >
> > The discussion about the creep problem started here:
> > https://lore.kernel.org/all/7098654a-776d-413b-8aca-28f811620df7@arm.co=
m/
> >
> > and the discussion continuing here:
> > https://lore.kernel.org/all/37375ace-5601-4d6c-9dac-d1c8268698e9@redhat=
.com/
> >
> > ending with a summary I gave here:
> > https://lore.kernel.org/all/8114d47b-b383-4d6e-ab65-a0e88b99c873@arm.co=
m/
> >
> > This should help you with the context.
> >
> >
>
> Thanks and I"ll have a look, but this series is unmergeable with a broken
> default in
> /sys/kernel/mm/transparent_hugepage/khugepaged/mthp_max_ptes_none_ratio
> sorry.
>
> We need to have a new tunable as far as I can tell. I also find the use o=
f
> this PMD-specific value as an arbitrary way of expressing a ratio pretty
> gross.
The first thing that comes to mind is that we can pin max_ptes_none to
255 if it exceeds 255. It's worth noting that the issue occurs only
for adjacently enabled mTHP sizes.

ie)
if order!=3DHPAGE_PMD_ORDER && khugepaged_max_ptes_none > 255
      temp_max_ptes_none =3D 255;
>
> Thanks, Lorenzo
>


