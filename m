Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBEE6EDF021
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 02:27:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 497DB6B0005; Wed, 11 Feb 2026 21:27:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 462C16B008A; Wed, 11 Feb 2026 21:27:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36F096B008C; Wed, 11 Feb 2026 21:27:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1F31E6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 21:27:05 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B81688C126
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 02:27:04 +0000 (UTC)
X-FDA: 84434217168.02.752D735
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4364CA0008
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 02:27:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MC3kvcJs;
	spf=pass (imf25.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770863222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gp+jGsFt0f+B4Yx7Kn9iLrtztl6gxI2hlCohd/wkcgM=;
	b=EK7pEcICITmQvRfWqd+qmws6kG2ROuGN4Z87mTrYaccseIFmLxJs7OE29LM/ciF2pvY/3F
	bJLiHq/UUUWizZfH+BNWpFuH4La6FHll2z5pMFju4OmaLCtC8giC+dUl5Dkh8IA8v7mZ2w
	ihoMmYo204gSb11QT+mJuEyC7o+MD+k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MC3kvcJs;
	spf=pass (imf25.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770863222; a=rsa-sha256;
	cv=none;
	b=W2ZADDtyXYirrco5BHUJUcvDSNrbZSiNXTG3rskjRVYs+mMBAXsf3Z9NruywIO5Av61v2c
	2Xqe1TipwLaiyxTRmEoI1S1Xa9A9XTg6FsWkhE8yW33znkxIq1+BO2B0uSacKRW9Ijv6He
	uOofxaPGOFghFigHY4swMn2uGDId+FA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770863221;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gp+jGsFt0f+B4Yx7Kn9iLrtztl6gxI2hlCohd/wkcgM=;
	b=MC3kvcJsoWeKCSCJD/hAMwB67bnYMio+74uWHy8Kg4iUSPCkoKXrNCW5Z2lRF33nwGNNjF
	jWlUOYd8sTiyWCrIlLxWXwBNFtzze/Xg0Y7lvL0qaazzpCCdupdRoW0cSrT+Oq42xQruhA
	064TuXF5ChJVnaoE7eiv6PWKDjVgeqE=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-494-7Rf0R5HXO3-iqyhYaO6v5Q-1; Wed, 11 Feb 2026 21:26:59 -0500
X-MC-Unique: 7Rf0R5HXO3-iqyhYaO6v5Q-1
X-Mimecast-MFC-AGG-ID: 7Rf0R5HXO3-iqyhYaO6v5Q_1770863219
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-79472373f48so45996217b3.3
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 18:26:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770863219; x=1771468019;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Gp+jGsFt0f+B4Yx7Kn9iLrtztl6gxI2hlCohd/wkcgM=;
        b=OiKeE80xlRv7sT5U6ILizvM/TTCXhktYpxW/UJ+ORo6zIo51lpuFIAk7hfnpHx3AY1
         oQ8NjsoENhGZqd7I7EEoGs/+qRPfB674DVLS7epZtkEJtuGHIqVkFT5RphdVDyJz8mQ6
         NGSeylEfDBOTDtpQ0coO1fR7muWKvQh2ioco7g+MyV7fAOJHO9CLX6CwNLG2690zynk8
         ZK1s13HhVTux6cyi2uhVoKmfOPl3erCzLPw6RP0RIp+n6Ho2LsD+tiuigYMgzPpudLLO
         nvR5ffYqoz8gsOigmeJDx50IwriCTgUJZdQ6W7wn8trzqQC9WFpegBq70ToHxo8G48Jx
         MiuA==
X-Forwarded-Encrypted: i=1; AJvYcCX7K41VP4l7lvpSibFsBzAmMRLIUB4TnuDu1i2W35iL7QFCxHsFWH6QStRuBCVj5CGLDeE3/uvChg==@kvack.org
X-Gm-Message-State: AOJu0Yw2i8ipF04i3eOUJdZWViR3Nh3Y1fUb9DRLG9qqKvbFcMfo2LD2
	t5dTKgXaEVM1PLgkSatzRUvEw55ZpkFuerDVylG2T3gc95APP671edtSE9IQA2qTJuadcNTFwM0
	Cpyhvc6mHRXZUTVgmPM0koTBXql83erMS/xOO+sdn90ZVHdL4z/ZuPVi6YJ+K73akxRVxNrtWZP
	24f+BXshMVZKsqRVUoYpg5s3ezNtI=
X-Gm-Gg: AZuq6aLLl6nJoa+w75gBp56jFOPOXpCEWNiaIhtsb9QTgYPASgEMlOPATPbul2gXrfM
	enm+AaEokghVLn2KGeBjC/5j0AeKegNLbGvhnAb9F30YJ3Zg6//5emsP/hIndWU7WGVl6v0NQM+
	v1Cq9pdwTjR6hMHjgh0Hoi7z1EqiR7NzyHdnFVGXrdx5JTEcZMzWXd1GkeqRvun6EABSmQpXDiZ
	MdZAA3dLtfiJ6n4wpKL
X-Received: by 2002:a05:690c:c22f:b0:787:ffc0:40c7 with SMTP id 00721157ae682-79793235b6dmr5336917b3.68.1770863219321;
        Wed, 11 Feb 2026 18:26:59 -0800 (PST)
X-Received: by 2002:a05:690c:c22f:b0:787:ffc0:40c7 with SMTP id
 00721157ae682-79793235b6dmr5336687b3.68.1770863218927; Wed, 11 Feb 2026
 18:26:58 -0800 (PST)
MIME-Version: 1.0
References: <20260212021835.17755-1-npache@redhat.com>
In-Reply-To: <20260212021835.17755-1-npache@redhat.com>
From: Nico Pache <npache@redhat.com>
Date: Wed, 11 Feb 2026 19:26:33 -0700
X-Gm-Features: AZwV_Qg-BkTAU-WjDTooFYmBcAjb8k57QEtDvME4Zi_u-ibhuhVGQ2opfjdCsVY
Message-ID: <CAA1CXcA6AhHYjh-UA+KqPM6vEboc11t2=Mp2JKFsQqmve=Qm1g@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v1 0/5] mm: khugepaged cleanups and mTHP prerequisites
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org, anshuman.khandual@arm.com, 
	apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jackmanb@google.com, 
	jack@suse.cz, jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, 
	kas@kernel.org, lance.yang@linux.dev, Liam.Howlett@oracle.com, 
	lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com, 
	matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com, 
	rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DeAqw3ERUnjM5x-R7EmWEuZ-CmbZ0x_qdqR5GLe0pyQ_1770863219
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: fhh3cfitekz9ab34udx58i9be3g45xsm
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4364CA0008
X-HE-Tag: 1770863222-373950
X-HE-Meta: U2FsdGVkX1/WYhKAK/O4HM7SUFalE4HDrT29oCOBRRC3cbOZajidWkYJ361WsYAkuaymjpwdVZtY3oX5Pp3lEO+1GVA1QkglWPVz/g5GEW9UJFVS9metIgwHRFCEeE/u6RU4YPEu2cDuMnQ+okuFLHogg3266W8ZW8aSKkYyUlYod+rdqdVSv7XpS0tNjNa1T0nKnW9M6vu38zYtbrfO6qWGo98oKBpdib2KchhueZZ+zPfb3yBuJoePC1O+yHOAlXKD/Ydz7v7XnViU3c5qL5E5e2AXo0Xs4aj8BWeNZx1ESBzt3C51wMSkDaZ1fowqdBp69mf30XJSGPoMW+d88+AJTS21vxmm1SbFrD9K6Eg1YAsqDb8T6lZ+1oc3OAMRXYFq/IFYVFHOL60LU7xP8a834ycx3SUcKqrX23yEAPu9WH6skQYKjt0uxUR8WXBfYneO1t/ChLmjqFlLX11PessXsTyUx8Ow0+nyl49g7B9tdwVyXgnM4QwEqkezZyZYjIXpxvbbY4t2bXhMjYepXY8yCNUElVmzq6zBD1qHerDDpjrpYmYME8GDTRscRd1IhoeEGkZiqIWn6gKYRwfP/R0fhZcKZa/aHhXpAGinFV547XTSbMR/Zi1sReHE97nn/HKLs34V2KuqaopOTZXcA4XhF8Hn7PLKkxwDgAE9hjIB7kFoaPRF1QbquiiJoY4/5kwswlHdUQSOHEY1xcwRg8UVXFc9byCDg9/rhxLN0es6p5YAaPHMPSmUyCPYJW9OyTgy7k7T/3yKUUibqZrCNZLUgEghPrYZEkCy1+vILVQHriXIorWrgS2IolR9viyJoynI0BuTEM5pn53s0hiz1eLCsO/vPAu+tk3pHP+NTNn1VnJQNc7zETmO5L0HEcfzfiCHO+KV1yp5I0y1SrNLwreknmJQ2fbb5ZEIIrgfPOH63orr/rBmkSvHmHOF1VFiGapZIaBCAW0y3yxQOp9
 GMLpXOp2
 XGMKIxmlYOu5r71yQo5OIybQ44vNGX85y2EiQMUJzgRIPZQwDQPqbh+C/yVGTH+sQaY3YDBtJw7wP2VYjUQJtvqAcDPubfB/Nx19aNT6wXf9Z/eJBjP1P0s9HbWYMOrHKHlCiZNU7WqarWodYLYbjECaM0zeU4/dnCJMeN+X4QK5ro+MfuQagQmPYsJ9t9SYwgOQEMuXVjUEQVcC9TbpYbdFolIrxND6Wv91bfefVEG/4opADGw2VzL+eF7HZyIghzjQNFMVgPWT6+fyKZmrmwAv4v0vvfn1/wFsCKUkEUp1+uoy0nhN20BMM9gqZTVgkS2Z8R9F/6njAeU154cUHKtdlzuzuxVIRL8jAC98VS0wijTSv2q+2wGwHcVI6LbLJLgs5AUTaVndRfQhbCwReLHkGoWECsZy/Ru94ldZLr0FCaRY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry for the noise, my patch 4 and 5 borked when I sent it. I believe
I fixed it, but patch 5 may have been sent twice.

On Wed, Feb 11, 2026 at 7:18=E2=80=AFPM Nico Pache <npache@redhat.com> wrot=
e:
>
> The following series contains cleanups and prerequisites for my work on
> khugepaged mTHP support [1]. These have been separated out to ease review=
.
>
> The first patch in the series refactors the page fault folio to pte mappi=
ng
> and follows a similar convention as defined by map_anon_folio_pmd_(no)pf(=
).
> This not only cleans up the current implementation of do_anonymous_page()=
,
> but will allow for reuse later in the khugepaged mTHP implementation.
>
> The second patch adds a small is_pmd_order() helper to check if an order =
is
> the PMD order. This check is open-coded in a number of places. This patch
> aims to clean this up and will be used more in the khugepaged mTHP work.
> The third patch also adds a small DEFINE for (HPAGE_PMD_NR - 1) which is
> used often across the khugepaged code.
>
> The fourth and fifth patch come from the khugepaged mTHP patchset [1].
> These two patches include the rename of function prefixes, and the
> unification of khugepaged and madvise_collapse via a new
> collapse_single_pmd function.
>
> Patch 1:     refactor do_anonymous_page into map_anon_folio_pte_(no)pf
> Patch 2:     add is_pmd_order helper
> Patch 3:     Add define for (HPAGE_PMD_NR - 1)
> Patch 4:     rename hpage_collapse to collapse_
> Patch 5:     Refactoring to combine madvise_collapse and khugepaged
>
> ---------
>  Testing
> ---------
> - Built for x86_64, aarch64, ppc64le, and s390x
> - ran all arches on test suites provided by the kernel-tests project
> - selftests mm
>
> V1 Changes (for patches coming from [1]):
> - Refactor do_anonymous_page() and add helpers for use in mthp series
> - moved is_pmd_order patch to this series [2]
> - added a define for HPAGE_PMD_NR - 1
> - moved rename to this series [3]
> - Dropped acks/review-by on PATCH 5 given [4]
> - moved unification patch to this series [4]. I also had to make some
>    modifications from my previous version which include moving the new
>    madvise_collapse writeback retry logic into the collapse_single_pmd
>    function. This prevents a potential UAF bug I introduced in my v14 whe=
n
>    handling the conflict. [5][6]
>
> A big thanks to everyone that has reviewed, tested, and participated in
> the development process. Its been a great experience working with all of
> you on this endeavour.
>
> [1] - https://lore.kernel.org/all/20260122192841.128719-1-npache@redhat.c=
om/
> [2] - https://lore.kernel.org/all/20260122192841.128719-2-npache@redhat.c=
om/
> [3] - https://lore.kernel.org/all/20260122192841.128719-3-npache@redhat.c=
om/
> [4] - https://lore.kernel.org/all/20260122192841.128719-4-npache@redhat.c=
om/
> [5] - https://lore.kernel.org/all/65dcf7ab-1299-411f-9cbc-438ae72ff757@li=
nux.dev/
> [6] - https://lore.kernel.org/all/b824f131-3e51-422c-9e98-044b0a2928a6@re=
dhat.com/
>
> Nico Pache (5):
>   mm: consolidate anonymous folio PTE mapping into helpers
>   mm: introduce is_pmd_order helper
>   mm/khugepaged: define COLLAPSE_MAX_PTES_LIMIT as HPAGE_PMD_NR - 1
>   mm/khugepaged: rename hpage_collapse_* to collapse_*
>   mm/khugepaged: unify khugepaged and madv_collapse with
>     collapse_single_pmd()
>
>  include/linux/huge_mm.h |   5 ++
>  include/linux/mm.h      |   4 +
>  mm/huge_memory.c        |   2 +-
>  mm/khugepaged.c         | 194 +++++++++++++++++++++-------------------
>  mm/memory.c             |  56 ++++++++----
>  mm/mempolicy.c          |   2 +-
>  mm/mremap.c             |   2 +-
>  mm/page_alloc.c         |   2 +-
>  8 files changed, 152 insertions(+), 115 deletions(-)
>
> --
> 2.53.0
>


