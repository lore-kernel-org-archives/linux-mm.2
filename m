Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40B03CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 17:04:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7002E6B047A; Mon,  1 Jun 2026 13:04:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D7F06B047B; Mon,  1 Jun 2026 13:04:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EDAC6B047C; Mon,  1 Jun 2026 13:04:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E08D6B047A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 13:04:48 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E93889163E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 17:04:47 +0000 (UTC)
X-FDA: 84831968214.09.05CCFA2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 74AEA4000D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 17:04:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fz9TmbMf;
	spf=pass (imf11.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780333485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pWY7+zLcstKVcaBHa6DF3oAjfO/xzJSbuw3Jcm1WeHw=;
	b=OG1H/7EX/f5EAGriXV+UCDaUZ8IoAuX3Y5DNuIyLbMYdk4g1iOwynJ4z6HgYw7cCFyA7JD
	ACP9Od8QFe49FqgL6QrcC8M1ZJ4S1YG9DL61WoiK3Lvk1qhB2DkUfjO0E4WaCUBynZVvvj
	N3S53EcqPLuXZKegXiYrxlPTps4Rwfs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fz9TmbMf;
	spf=pass (imf11.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780333485;
	b=aBTIknKprfgU6Eg4mHRurej/uiNozsGSj4Ux6uZz9ahqgmnzjK2R1EXZiI6hOiYGmTEJSy
	xfMWP2tp9eUVK7J5+Ia1051GC2pMi3KL/liTKJC+vXdnBOiViRoSNIX2heSZdY9AKFMhVr
	5B6rogNjK3f6G3oniKbcOGSB9BCcZww=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780333484;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pWY7+zLcstKVcaBHa6DF3oAjfO/xzJSbuw3Jcm1WeHw=;
	b=fz9TmbMfPXQ5O5szQljzQSp0bE3iZMtaizykRo5umLlaxHX0QdZhceE+4Hg5JqriMZ45/V
	vit3txHnXxsHo3TRSFv26LRdASczX2AUR8LpRf9Y6pgAHcVAT4RU+Ktbu3cxC2RLbFCpxa
	4dZJ41qMo0igQF52fG5B4BunsQAL7o4=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665-MXOSwRGjPgGGmYdiRTo6RQ-1; Mon, 01 Jun 2026 13:04:43 -0400
X-MC-Unique: MXOSwRGjPgGGmYdiRTo6RQ-1
X-Mimecast-MFC-AGG-ID: MXOSwRGjPgGGmYdiRTo6RQ_1780333483
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-7e0533b7d8aso44780907b3.2
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 10:04:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780333483; x=1780938283;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pWY7+zLcstKVcaBHa6DF3oAjfO/xzJSbuw3Jcm1WeHw=;
        b=PJ54Ymq/dpRCnXgmLpOeZSJmkAqMgHTYEEDR6aJRZmz4BdPhHqZGyFNCiOmWJdSKZJ
         jOtFKO7epZ/vhENwB5xojmcikfLhB4eR7838Q+2g+/on00WHrm5FNuNDaLWIf73FHRCl
         l7f1TXx0fSRSV5fOcNqnhXqVU1yhkt7nvajCDr19SEw8PGieufJ1t/ZP8u9jqZKtlv9D
         hPqvocDhf7wYhG6WRCz4dbzk4AhrbOMcX9e1IvXTudxcWa0/Oy0Ixayfc+qnNNY8Sb+e
         GwngQKM4EN+87ud1oQ2DuBh+CiCELm2welDGNqjFhTBQbPKICha1W/dCAaoZ7EMz0PB4
         SpEQ==
X-Forwarded-Encrypted: i=1; AFNElJ+XjvxC1KfJv0/3IKSof4iZJbZ7HEbxSxzubw30pR+fAaol+O+Ncnabl+GkF5vDbQ/A+F09Aub5zw==@kvack.org
X-Gm-Message-State: AOJu0YxrFx+1LQNjNIl94kExQo2HiXZTPfMwpRGRKHelNqznX4KwV7mC
	R6PGS+kMohWqTpU5VF/NgMllbpPrJ6BT6lXAMK5AwtQpay3bGZP8ggZgyc+UeHxSu7Y/75QsJo3
	HQOErk54xT5SxU5ckUqDrDrRFnfOdGUvF/opoQFDbOCExgKFHon6hcbsn2NaFtJbfrNlyB4NDc9
	gP+NL9TosJcR/O2bLo8zoEOLStvA8=
X-Gm-Gg: Acq92OGnAq8wdfe34ZLghPs0gpcZ50fp+s+2AcTZyELrPUK0TFkYcS04yP4gHDFUPXf
	tMcmN7kYxWwhbkaE5Dl05muWUPiSEbO9q3Rjwjwdr7iMQQIc5KaLq543YT6Yxx7LXbNXhojJ/R7
	xQ1oohzSe3GX4Fhow3PcsaWjnn1TmihbWlbg2rwnQBaCM2TbMr66KGcBeTjaMVVT5j2HQSsYynj
	27wKdjc3bjV6N2bFA==
X-Received: by 2002:a05:690c:c50f:b0:7d3:cf30:ef91 with SMTP id 00721157ae682-7e05a1907d0mr108659937b3.19.1780333482332;
        Mon, 01 Jun 2026 10:04:42 -0700 (PDT)
X-Received: by 2002:a05:690c:c50f:b0:7d3:cf30:ef91 with SMTP id
 00721157ae682-7e05a1907d0mr108658977b3.19.1780333481712; Mon, 01 Jun 2026
 10:04:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260522150009.121603-1-npache@redhat.com> <20260522134724.f4f11941a85ef18b307d16ae@linux-foundation.org>
 <20260601155808.2755103A59-agordeev@linux.ibm.com>
In-Reply-To: <20260601155808.2755103A59-agordeev@linux.ibm.com>
From: Nico Pache <npache@redhat.com>
Date: Mon, 1 Jun 2026 11:05:20 -0600
X-Gm-Features: AVHnY4LWX34RPOrSLZQKCFADp8MRh-hRHO-69bPjowu85AkTudvs-SlZUCsWfOs
Message-ID: <CAA1CXcAd-uQD0LgUzWAAkFKt13eFfaP3TfG9KED2RzYGhHoqpg@mail.gmail.com>
Subject: Re: [PATCH mm-hotfixes-unstable v18 00/14] khugepaged: add mTHP
 collapse support
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, 
	cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, 
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, 
	jack@suse.cz, jackmanb@google.com, jannh@google.com, jglisse@google.com, 
	joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev, 
	liam@infradead.org, ljs@kernel.org, mathieu.desnoyers@efficios.com, 
	matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com, 
	rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com, linux-s390@vger.kernel.org, linux-next@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vSdeidvDvnyCSs4Ua0OFxTBLZdvb3JKbRVBbzA_TIIQ_1780333483
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 74AEA4000D
X-Stat-Signature: bwwi5zrsnsz89xo36cbpmugjik8g9upp
X-Rspam-User: 
X-HE-Tag: 1780333485-866638
X-HE-Meta: U2FsdGVkX18Xq6JvgNnY1NICiYoU48bQ8g81JMTlBnBi5vF7MZWmH0IQOlz63EiBxCjVeJVmFO6S0CTpRn8DKek/DIULVXF7Qntlrwx3qIK8kO7J8ttFprSazp3qEyf6uMG5knkZy8AsUGSA6+zyvHLPVvAkmDj5Rm69hhL91FZLLxpkDo/KzRZJIKxfa8XQxsh4C6bPjGheODBBXTK7BKVd41E3sKw4s8iivyMJ+Hc7PurYffnvLYFoHMt1/az3zXqVcOX9rffmVp2Vgk8psZ7DlpZWClrVWr331G9T+007DawLEHCSZrtu6WTcG2rJGsKvS7h4n6xKeysvRPAGjhs91QWYGWt4p0Qb8mziymOiA9j94Vh/ONbPOvZ1LGNXc/x/KnPZXicxmzcND0uY9uOJtBQzA+jNEZMr9CM2gT12lp6fw8d5kPYKY8AFeLSEy9TSFWOui2RihSTLefbWcEGcTjgvwvW9gILIEioBTEXfePthYQz6B8dAvcf+1KcqF2Hp/Waj7r3nocx68WIrnt8Kn6Dtevd7HaJWbAY6iCRKYjF+c8ZagRpVmTBu/mKrBSvmH52KAAIILuB8WdxnLWBsjsPPm4IRrcVHLos5R+5XEDZpBh513QItaXDcTkSBMXMKpadtrJy3KIJkbsIsB397rkpr5FxHR+oKczK/QguwsLs26p2JIOWa32qQk1BIp13sb3/jxQV3xKsdiD7FGc7e70sRGnPIHTbQLtRn4LGGOklusa89OkDJ3H0B0wBLtR9nlyEH8tukCP1GYzkr/e9aMSD3kJ7rnDl3V8EmWkwUPhFjdNAGaMI3bM9h53gVcWKMYiD1S0rtZEMVSWDiB9deEVaYUYiulIc9nRs7f3dXMb6vDJMPgneoIRQDxQYi6+UO009+4xhXWm2Cnclfk+08VNvslnT+t6EyX9+l/2CSsmEHmu8Y1dYOJK+qeNhk0uAo0sAvZkBX8yUhiu4
 5qb7+bQu
 7wwcRc8xSmwu1cUjvzSIT6vOTR6CYc+TI1+rSj7dYLwU/Gzik5UfhzNL7nFUMnfWntXPvWF+hlVeShSKIdt4mgWOgD7LZ4SfZaBytiThZqu9GQFTOt2T/HZB0Yvy3Ox+pqZzk7NOYsKL/u0sGZTKd7e9c7aw1zFg5Fkdab4GplZml16Iw4YUK0Xs+GhHCk2m8A9Yb0L4sUN+74Kps3oNSvhiNdn2iXYoX0FhKeX/pYIGyVGrOTnSyo/O2ekJbCG03sNtXK9ThgOrqeE891gzrDakkrAiPNU2yaa3/LTVbqtxi6AaK3vCSAAauOm2BAu45cOhHYo61Ue0equSjbaKPvT3bDwXrB6Zt08kRfXamXKP2RZ43U0lLlf2DXLJUVp5X8+HpQoyrbbePBPE81LyOXrKR6R0Waja+laNbokG2MGq2OxE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 1, 2026 at 9:58=E2=80=AFAM Alexander Gordeev <agordeev@linux.ib=
m.com> wrote:
>
> On Fri, May 22, 2026 at 01:47:24PM -0700, Andrew Morton wrote:
>
> Hi Andrew et al,
>
> > On Fri, 22 May 2026 08:59:55 -0600 Nico Pache <npache@redhat.com> wrote=
:
> >
> > > The following series provides khugepaged with the capability to colla=
pse
> > > anonymous memory regions to mTHPs.
> >
> > Thanks, I've update mm.git's mm-unstable branch to this version.
> >
> > It sounds like I might be dropping it soon, haven't started looking at
> > that yet.  But let's at least eyeball the latest version at this time.
> >
> > Sashiko was able to apply this, so the base-it-on-hotfixes thing worked
> > well, thanks.  The AI checking made a few allegations:
>
> This series appears to cause hangs on s390 in linux-next.
> The issue is not easily reproducible, so it is not yet confirmed.
> Any ideas for a reliable reproducer that exercises the code path below?

Hi,

Thanks for the report!

was this caught by syzbot? If so, can you provide a link?

Also can you provide whether any of the mTHP sysfs settings were enabled?

Based on the report, it looks like we are either dealing with more
lock contention (due to holding the write lock longer). We could
switch to a trylock but that might cause us to lose some collapse
attempts (which will be retried later, so probably fine). I'm ok with
that approach if it prevents these potential regressions.

Cheers,
-- Nico

>
>     [ 2749.385719] sysrq: Show Blocked State
>     [ 2749.385730] task:khugepaged      state:D stack:0     pid:209   tgi=
d:209   ppid:2      task_flags:0x200040 flags:0x00000000
>     [ 2749.385735] Call Trace:
>     [ 2749.385736]  [<0000017f63c8b226>] __schedule+0x316/0x890
>     [ 2749.385740]  [<0000017f63c8b7dc>] schedule+0x3c/0xc0
>     [ 2749.385743]  [<0000017f63c8b888>] schedule_preempt_disabled+0x28/0=
x40
>     [ 2749.385746]  [<0000017f63c902ea>] rwsem_down_write_slowpath+0x2fa/=
0x8b0
>     [ 2749.385749]  [<0000017f63c90910>] down_write+0x70/0x80
>     [ 2749.385752]  [<0000017f6313407a>] collapse_huge_page+0x2ea/0x9e0
>     [ 2749.385755]  [<0000017f6313491e>] mthp_collapse+0x1ae/0x1f0
>     [ 2749.385757]  [<0000017f63134fda>] collapse_scan_pmd+0x67a/0x8f0
>     [ 2749.385760]  [<0000017f6313751a>] collapse_single_pmd+0x15a/0x260
>     [ 2749.385762]  [<0000017f6313792c>] collapse_scan_mm_slot.constprop.=
0+0x30c/0x470
>     [ 2749.385765]  [<0000017f63137cb6>] khugepaged+0x226/0x240
>     [ 2749.385768]  [<0000017f62db3128>] kthread+0x148/0x170
>     [ 2749.385770]  [<0000017f62d2c238>] __ret_from_fork+0x48/0x220
>     [ 2749.385772]  [<0000017f63c95d0a>] ret_from_fork+0xa/0x30
>
> Thanks!
>


