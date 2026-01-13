Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CABC4D30CEE
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 21:58:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26B066B0089; Tue, 13 Jan 2026 16:58:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 240086B008A; Tue, 13 Jan 2026 16:58:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 155316B008C; Tue, 13 Jan 2026 16:58:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 04D876B0089
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 16:58:58 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 99CCC1602BE
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 21:58:57 +0000 (UTC)
X-FDA: 84328306314.21.B748B36
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 40C9C40005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 21:58:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DUWzG5FC;
	spf=pass (imf17.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768341535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Aszg6VHdGxbQOUkAIqtJEqZsCMcdfPcXY7mWtBsu0l0=;
	b=H428cVs6UhXldKTX/y6mDJJ3p9BCw/ryjoTc+9IsoAr7L1nnVyHH0wIAJLYg0lhEwKw4O+
	nK6WUazSvAF6AXAJA5uqjCpGlAHpHS3FQRuzmgZFUge1OXwPV4IvloTRibhi4N97aIUuuS
	E2CgPxyZj2au7tsCPM+9U67rvW4OVfU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DUWzG5FC;
	spf=pass (imf17.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768341535; a=rsa-sha256;
	cv=none;
	b=QQ2CsNRuoxH0Nb42NKoCufHU9qWBb4OUbg1T94kRFxoPGmgYilvm4+v7PFYo5wXZNkfyXf
	uB/v8uijDpgas1JaEAwpzZ4fdxf6Xbqpzr4ClHt/RVDkY1b9v40YUyswi3UyvAPs1hXfFX
	e/2cOXdxVyV+Eec7wb0HyC/ILkyJwUI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768341534;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Aszg6VHdGxbQOUkAIqtJEqZsCMcdfPcXY7mWtBsu0l0=;
	b=DUWzG5FC6/qrLbuWFTZ3Cj4ZfH0tBaZwMnM7SX7vMG5qWzioNxo6zPjUtUCU2G3SrIYKdG
	+te4O3ioLyDsndCSylj/5nX3ObmZs5CCd7RedXSEaiA6NHltdmd4NjN1ET3jNWUFDjqgk7
	cJBHwWOpte0KpiOJY4nqzWmMlN4Nm5s=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-18-Ic0zAFQVPL2ATsS5cOxjaw-1; Tue, 13 Jan 2026 16:58:51 -0500
X-MC-Unique: Ic0zAFQVPL2ATsS5cOxjaw-1
X-Mimecast-MFC-AGG-ID: Ic0zAFQVPL2ATsS5cOxjaw_1768341531
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-7927ce1d097so39109047b3.1
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 13:58:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768341531; x=1768946331;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Aszg6VHdGxbQOUkAIqtJEqZsCMcdfPcXY7mWtBsu0l0=;
        b=RwrgyPOvP1aumu60W10dzUR4UCVef5nVK51Qooz4T639x47os7gnhN9OUM5OSNuLbg
         D9Gx5g3z5uNTCamgCzmV86/XAzmxM904k68vK8a4ByFgTinQ/YXherJEFCRz2OwQR5re
         vzXtvPfPmVd18iigHhykquDkR1rJYQ2Kmo+H1CtvwpQr5y3Mm3pM1YNJxzA+BQzBN2sp
         tKiG38dr966mgevhkMW1R47gTzpsrtqwROpLSxKlb33J8xpbbsKNMA2/olnufscux5jP
         7SPLO8MOGoIE0nkiEqAAOrNDoub1JjxHFYAvfcPSUQniHeZClcGWMHfSzop5kiMTVRIV
         /H6A==
X-Forwarded-Encrypted: i=1; AJvYcCWLf51+no0M9bT2AchWyePjIVcRqBuhM3hfalSagJA2LP4HHzNjgRqwnuKtHhftRc4VUHP12XqOPA==@kvack.org
X-Gm-Message-State: AOJu0Yy57IL6nsP6Mjqjp4OPmC/LCyh+9AD8MBpWclWeIEqSQakjSBd8
	yCkgiZZCzAwVNNFgAw9WtZg9L3yEvtbrd2ueCgDX/1r1NPpZ45X6xxYHQh2H6/UBAL//w/lqNnq
	07Db1i3FvwTO/fWTG1xALe7i7Ikq4RG8/IMDuvssBlL+Aaomd3/71FI5uFscjNRBK+kCKZuiK8m
	C7lKt/ZLyrESvXJggAAagGOX4vAls=
X-Gm-Gg: AY/fxX5enT++URbUKH+Aw9CDZInW3FNLUllmtX2NDI23o74jvY98MeqAOJluaGDUoPF
	/3F2WnujVMY6H/XTH6SnomQWDrFS7J/uV88uVBHmpzPnGTKJlxOR8e8IO/cXI6iWBO+j5/terIR
	gykYkKno0kuUxtQl9/RjDcnLL/lTfoWQKcBLisAOPY8Jg6FUeioIxi8Wbb7eW6Kh50G7pS8aHWz
	7bFQo+2
X-Received: by 2002:a05:690e:4195:b0:63e:17d8:d985 with SMTP id 956f58d0204a3-64901b06d01mr670056d50.53.1768341530667;
        Tue, 13 Jan 2026 13:58:50 -0800 (PST)
X-Received: by 2002:a05:690e:4195:b0:63e:17d8:d985 with SMTP id
 956f58d0204a3-64901b06d01mr670028d50.53.1768341530229; Tue, 13 Jan 2026
 13:58:50 -0800 (PST)
MIME-Version: 1.0
References: <20251201174627.23295-1-npache@redhat.com> <e54b6ade-e2a0-4a68-93c4-23af85479567@lucifer.local>
In-Reply-To: <e54b6ade-e2a0-4a68-93c4-23af85479567@lucifer.local>
From: Nico Pache <npache@redhat.com>
Date: Tue, 13 Jan 2026 14:58:24 -0700
X-Gm-Features: AZwV_Qi-DwUQqcw_55ZPNTuKOVRySMeatqOYhgcJmeNszHAwF1Q0M7_BZf-QJkQ
Message-ID: <CAA1CXcAP6bX2=g-S-zqPrAQq6kJbQVOvx2cYYrXSCCL4R8UPpQ@mail.gmail.com>
Subject: Re: [PATCH v13 mm-new 00/16] khugepaged: mTHP support
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, david@redhat.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org, 
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org, 
	peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com, 
	sunnanyong@huawei.com, vishal.moola@gmail.com, 
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, kas@kernel.org, 
	aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com, 
	catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org, 
	dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org, jglisse@google.com, 
	surenb@google.com, zokeefe@google.com, hannes@cmpxchg.org, 
	rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org, hughd@google.com, 
	richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz, 
	rppt@kernel.org, jannh@google.com, pfalcato@suse.de
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -NJrSA_Hv8dx21TMHuc5Prhxh_rI78rZEkO011iNAJE_1768341531
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 40C9C40005
X-Stat-Signature: ttrb3g9my17rwtt6f9wp6ws6wum6iqe5
X-HE-Tag: 1768341535-20945
X-HE-Meta: U2FsdGVkX19NnVcza/z5Ureh4Xm2WZHtvRKFF1r9FzJXW8hlB6qKMhqmpNROn3F483h44xYPYNu0s+STb6rbzdHlLSMActkwBmUrNd+oqRGh2t1SPxrjyS4zl0wVRMd7gdrGc7btia/IbkDnH43wlnESneaC7dKDWZGetXCaNESydqr9mX7+p57HALIQv2NEKErgTFnHvs4wIIF10jqAzLcDHgFqgfYaNk+jy9e356Ykz/vm44LCeJjMCUdTvVV+A/cwmfbX2SvYj2f7bv0wxF/FqG/1VWgq7khL06iQlwlWXwkQdpSLkKuVI0NhrFmYFABqQSIMZj5E1RI9rmiUOhPL6QhrWSTEGPxTcw/QZoFVHIeNvovP7/qwOxcqPUsMUdDWnjF13tGB0ydI0KmwfiS3CYk1IdxFRoT2a+P/KvxpKVFDyI799BSDMmrLCPlzx+0Wn7JE0/SDkvptOXL6UQayUEZ3+Lml2U4wpJLOX6nullQnhFRRqaMZIHyPgUCgl1qcDEXCMaM40itfrWPvH+TcrLbk7odTMQlCrCNOA1ttERps7wd/TMLEG6DNL0w3azqIyZY6MvrakxCAYNHRRy154hxLgm2JBtyHWx4YvFfYPrs7dU720K10r8jA6D4FEPx0QK54Ch5nv4ZaWN+vAUKoFE5L2uMszBenripYqNvHume0tF5Nicp/GwjUQ8/g9ECrdhBmdvOBYGIzeS17FKYFuzuiNsuCENQvxnA5upscs285nv2E02XsaQ+5VUdr4hLNV9jLatLD5NTlfe6eDqKThBrw9gRwpqiWaI0lw9g615TzTD/fZB3+c7qlv7pB0nEVjIXzokpMhxylhKpcaEPtSgiK67cuRG2e7jtkmVprDfzNZ06QXCDQXYx9mDUcLhkkmS2mDBykBK5294pOG78wywNUefNuHzJqHa6ORLPAd4HS1SoLxoYp6NfJ/jN0J60kGUYR5d6rIBvhtGn
 +Y3Ipobt
 BLSImhSAD/WIT2v7BySkmNiHokJlDzP7CaZDywwqvcOvmttVomkZa9MWEGj+XlTfd23FElKCRPMGNCfr6OnJCEBoMBPGOJm+tvh0X3doNQ0Y61BRps1CHtlrpWM/Vpjg8vkG6dI5trQojPlbrNqIXLoCxiiEUDME02C2CtTUEmgkqR2qI9nQLI6KGNzpPk+qD/cCWaZiSTTIqN0kNwDGyTpYlUU5GKybtg9EVDyvIg/m5vsAi+HO0XmerY17ccVPTIGAzP/mdFH6QZ8xlEbKVyEd9FECc4EBy5wB05hTgp81MJpHQnwAeNKodh4U45/ARSiKd175j+GreReHtPd2LVVn/d9Om8+O870ozaudj6oR4YMnOSU85844H18ZWyaFPkyuTVY8YZBbYOqfGXYKo6qHjzHQeVdTb9pm7b5XoYv9G5tQ4AixA2EZsR93tqmnHVsoQJHo9o8kcpWP2wyUMq4+H2A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 8, 2026 at 10:20=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> (Sorry for multiple mails replying to same, lei/lore are broken again so =
my
> setup isn't working properly).
>
> I tried to fixup the conflicts here to run tests locally but there's too =
many
> and I messed it up.
>
> Could you please resend this series rebased on mm-unstable please?

Yes ofc! fixed all the conflicts yesterday, just finalizing my
testing. Should be out tomorrow or Thursday.

>
> Thanks, Lorenzo
>
> On Mon, Dec 01, 2025 at 10:46:11AM -0700, Nico Pache wrote:
> > The following series provides khugepaged with the capability to collaps=
e
> > anonymous memory regions to mTHPs.
> >
> > To achieve this we generalize the khugepaged functions to no longer dep=
end
> > on PMD_ORDER. Then during the PMD scan, we use a bitmap to track indivi=
dual
> > pages that are occupied (!none/zero). After the PMD scan is done, we us=
e
> > the bitmap to find the optimal mTHP sizes for the PMD range. The
> > restriction on max_ptes_none is removed during the scan, to make sure w=
e
> > account for the whole PMD range in the bitmap. When no mTHP size is
> > enabled, the legacy behavior of khugepaged is maintained.
> >
> > We currently only support max_ptes_none values of 0 or HPAGE_PMD_NR - 1
> > (ie 511). If any other value is specified, the kernel will emit a warni=
ng
> > and no mTHP collapse will be attempted. If a mTHP collapse is attempted=
,
> > but contains swapped out, or shared pages, we don't perform the collaps=
e.
> > It is now also possible to collapse to mTHPs without requiring the PMD =
THP
> > size to be enabled. These limitiations are to prevent collapse "creep"
> > behavior. This prevents constantly promoting mTHPs to the next availabl=
e
> > size, which would occur because a collapse introduces more non-zero pag=
es
> > that would satisfy the promotion condition on subsequent scans.
> >
> > Patch 1:     Refactor/rename hpage_collapse
> > Patch 2:     Refactoring to combine madvise_collapse and khugepaged
> > Patch 3-8:   Generalize khugepaged functions for arbitrary orders and
> >            introduce some helper functions
> > Patch 9:     skip collapsing mTHP to smaller orders
> > Patch 10-11: Add per-order mTHP statistics and tracepoints
> > Patch 12:    Introduce collapse_allowable_orders
> > Patch 13-15: Introduce bitmap and mTHP collapse support, fully enabled
> > Patch 16:    Documentation
> >
> > ---------
> >  Testing
> > ---------
> > - Built for x86_64, aarch64, ppc64le, and s390x
> > - selftests mm
> > - I created a test script that I used to push khugepaged to its limits
> >    while monitoring a number of stats and tracepoints. The code is
> >    available here[1] (Run in legacy mode for these changes and set mthp
> >    sizes to inherit)
> >    The summary from my testings was that there was no significant
> >    regression noticed through this test. In some cases my changes had
> >    better collapse latencies, and was able to scan more pages in the sa=
me
> >    amount of time/work, but for the most part the results were consiste=
nt.
> > - redis testing. I tested these changes along with my defer changes
> >   (see followup [2] post for more details). We've decided to get the mT=
HP
> >   changes merged first before attempting the defer series.
> > - some basic testing on 64k page size.
> > - lots of general use.
> >
> > V13 Changes:
> > - Lots of minor nits, cleanups, comments, and renames
> > - Bitmap function simplification and more helpers (Wei, Lorenzo)
> > - Max_ptes_none (0 or 511) restriction
> > - commit description expansion
> > - list all reachable enum values in mthp_collapse()
> > - Fix ppc64 compile error due to using HPAGE_PMD_ORDER (replace with
> >   ilog2(MAX_PTRS_PER_PTE))
> >
> > V12: https://lore.kernel.org/lkml/20251022183717.70829-1-npache@redhat.=
com/
> > V11: https://lore.kernel.org/lkml/20250912032810.197475-1-npache@redhat=
.com/
> > V10: https://lore.kernel.org/lkml/20250819134205.622806-1-npache@redhat=
.com/
> > V9 : https://lore.kernel.org/lkml/20250714003207.113275-1-npache@redhat=
.com/
> > V8 : https://lore.kernel.org/lkml/20250702055742.102808-1-npache@redhat=
.com/
> > V7 : https://lore.kernel.org/lkml/20250515032226.128900-1-npache@redhat=
.com/
> > V6 : https://lore.kernel.org/lkml/20250515030312.125567-1-npache@redhat=
.com/
> > V5 : https://lore.kernel.org/lkml/20250428181218.85925-1-npache@redhat.=
com/
> > V4 : https://lore.kernel.org/lkml/20250417000238.74567-1-npache@redhat.=
com/
> > V3 : https://lore.kernel.org/lkml/20250414220557.35388-1-npache@redhat.=
com/
> > V2 : https://lore.kernel.org/lkml/20250211003028.213461-1-npache@redhat=
.com/
> > V1 : https://lore.kernel.org/lkml/20250108233128.14484-1-npache@redhat.=
com/
> >
> > A big thanks to everyone that has reviewed, tested, and participated in
> > the development process. Its been a great experience working with all o=
f
> > you on this endeavour.
> >
> > [1] - https://gitlab.com/npache/khugepaged_mthp_test
> > [2] - https://lore.kernel.org/lkml/20250515033857.132535-1-npache@redha=
t.com/
> >
> > Baolin Wang (1):
> >   khugepaged: run khugepaged for all orders
> >
> > Dev Jain (1):
> >   khugepaged: generalize alloc_charge_folio()
> >
> > Nico Pache (14):
> >   khugepaged: rename hpage_collapse_* to collapse_*
> >   introduce collapse_single_pmd to unify khugepaged and madvise_collaps=
e
> >   khugepaged: generalize hugepage_vma_revalidate for mTHP support
> >   khugepaged: introduce is_mthp_order helper
> >   khugepaged: generalize __collapse_huge_page_* for mTHP support
> >   khugepaged: introduce collapse_max_ptes_none helper function
> >   khugepaged: generalize collapse_huge_page for mTHP collapse
> >   khugepaged: skip collapsing mTHP to smaller orders
> >   khugepaged: add per-order mTHP collapse failure statistics
> >   khugepaged: improve tracepoints for mTHP orders
> >   khugepaged: introduce collapse_allowable_orders helper function
> >   khugepaged: Introduce mTHP collapse support
> >   khugepaged: avoid unnecessary mTHP collapse attempts
> >   Documentation: mm: update the admin guide for mTHP collapse
> >
> >  Documentation/admin-guide/mm/transhuge.rst |  80 ++-
> >  include/linux/huge_mm.h                    |   5 +
> >  include/trace/events/huge_memory.h         |  34 +-
> >  mm/huge_memory.c                           |  11 +
> >  mm/khugepaged.c                            | 696 +++++++++++++++------
> >  mm/mremap.c                                |   2 +-
> >  6 files changed, 618 insertions(+), 210 deletions(-)
> >
> > --
> > 2.51.1
> >
>


