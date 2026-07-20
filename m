Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08309C4452B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 15:27:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03E7E6B00A5; Mon, 20 Jul 2026 11:27:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 016786B00A6; Mon, 20 Jul 2026 11:27:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E47846B00A7; Mon, 20 Jul 2026 11:27:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AFB016B00A5
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:27:15 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A4E171401CD
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:27:14 +0000 (UTC)
X-FDA: 85009533588.19.0047637
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3F43320006
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:27:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fOLZbrzy;
	spf=pass (imf13.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784561232;
	b=tPiPVf3A+fSmMHm0WFah6uTBtBzWdZJfrMsCZVbk6EukTUmKhsY5URRPt6rsKyo6a3zB35
	//PLPlveXynoP/FprbKCoAKew+sm440y3I1Y7MFqqCLtGqJaJR1FgLtPBTjAbglE//2jiE
	+GmoknDypdMbyG1+dDLiaYoSaKK8h9E=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fOLZbrzy;
	spf=pass (imf13.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784561232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mgKSqbnwLevn6hoy4qUeVb3wDzkEMMbiLmxONqaR+dY=;
	b=8SdBW58UABtiKvPeqOhpyc3ur5MhuBaiyh15AP0lBMJNo0C4QMP0gqDLRSoC9bWJaImj/b
	pzSvWX9i4BaJSaX59QntEbWY7VdNNH1ctWaAUpcmpJpGnwVBBW2mHiKJx7aXcMEK6veuMq
	F+UygHIRYkExtaHDQVNEY6TFpBHcaB0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784561231;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mgKSqbnwLevn6hoy4qUeVb3wDzkEMMbiLmxONqaR+dY=;
	b=fOLZbrzyYdhaYGchBT1BCZUUzSBSbvGFjp99JAM+ffsrjFBNDuqsuDqjA8h5y584w6hy8D
	Aws4hhMz+ldX4MUEpAYaGCWPwlLhTqGzC07ZZUQzZHH0+Yb2KZ4VpkVTlcXMsNz1ZJ/xjC
	V0v8IWhZAU4/qX8w1Z/VL73Zuh6Go3Y=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-343-Yq71AQMUPc2AkGlpHXwAjQ-1; Mon, 20 Jul 2026 11:27:09 -0400
X-MC-Unique: Yq71AQMUPc2AkGlpHXwAjQ-1
X-Mimecast-MFC-AGG-ID: Yq71AQMUPc2AkGlpHXwAjQ_1784561228
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-39d9337b0d3so16949251fa.0
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:27:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784561228; x=1785166028;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mgKSqbnwLevn6hoy4qUeVb3wDzkEMMbiLmxONqaR+dY=;
        b=f//wCo2foWsdjnX1hrYW/UTQiYgAnf6lPI49PVjTPmW5iWDnCJJ1VtwoluSf1e7JIb
         1o5QjQKt2hVkn3EHWB9OCCgQXZTvSW2QOFozjGJdChoJw7cZlTltQpEd0WQAARc+bwRQ
         p3MKhmnt9vOc7goNUrJ2qUSRhW3m58FYBiywz7ONYLu+KxKi+fl+XFIY5D74xF/OkZ0D
         QFndjZ3MxOyu259Dsdf/s+2/e4aDQDRYIFbo0NjCpdGp3+sFSXaj2FkUovNnq3cfxrTR
         2E3DvcCmIKzNteorVFaOr39lXNaTp84OeZFZJ/bDkXEB12SRPQEIv7QtYjEkgyHtvUWw
         1DPw==
X-Forwarded-Encrypted: i=1; AHgh+RpnP8ABIV8r0+V+zVmVngMPPjrSiPtDfmXQYkZ9LFLY7sWkyo50OshgzyYWpKsBbMNq4H+1ys2s6w==@kvack.org
X-Gm-Message-State: AOJu0YxTLBqz4eba8NHoH/UEI4S9Axa3FRLJ382N5Sh+PA5snmb+9xYa
	3Jdt53Coy7rCwdzq5sJCshx2kMQB+GMNzmkefng+HcpSL8yhLERiGLoABCA6uhWOUVjw/aEJJEv
	ocPuSaWmCREFbUW2m4JehA+lV3+6PtFwxYhyyZ/cxHdqOgVMBki2zVey5kMOkDPf76Uo9w0Vsjr
	FC00iFksm/ygXJ7FKSKQB/+ti/jqE=
X-Gm-Gg: AfdE7ckzS1buYaNdw9IIlCaLNtqu9A3VXEc5wG+72aMah+XY8qzJf3W3R2O2Ih3IxGJ
	6VtJXexIgo8GEe0xV4KNggvrkW1rWLALrc2Wzo7ZAn7QYd98lm95iQVJ/bBb4V6mmjg/pge8/av
	xvvIIK0hVtNrSef87l3roHz26+VfJX2fvWyAbJTQ8F6CQABqnWdXVMIg==
X-Received: by 2002:a05:651c:198f:b0:39c:913f:ce9e with SMTP id 38308e7fff4ca-39e9ebd6b94mr32423991fa.6.1784561227580;
        Mon, 20 Jul 2026 08:27:07 -0700 (PDT)
X-Received: by 2002:a05:651c:198f:b0:39c:913f:ce9e with SMTP id
 38308e7fff4ca-39e9ebd6b94mr32423911fa.6.1784561227180; Mon, 20 Jul 2026
 08:27:07 -0700 (PDT)
MIME-Version: 1.0
References: <18102ABA-0D8E-4DA0-AC30-544E34E445D5@nvidia.com>
 <20260609172719.803537-1-usama.arif@linux.dev> <CAA1CXcA84BtQZxOpE0sWgb2ed6y3m0NLKkWD+5MfWS9eF5dqTQ@mail.gmail.com>
 <a464c20c-8b41-4264-b560-497ed91cbaaa@kernel.org>
In-Reply-To: <a464c20c-8b41-4264-b560-497ed91cbaaa@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Mon, 20 Jul 2026 09:28:31 -0600
X-Gm-Features: AUfX_mwZ5uM7fwgr5H5twJKlnrh2Zu-nzokcG8yxCX8jCh3Ri4-874_BMKiBBbA
Message-ID: <CAA1CXcCsqkV2PrLicY5BnOMp+iJWJxsPn60g_3WXugWQqOFYpg@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v1 2/3] mm/migrate.c: Prevent folio splitting
 from interacting with KSM
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>, Zi Yan <ziy@nvidia.com>, ljs@kernel.org, 
	xu.xin16@zte.com.cn, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	usamaarif642@gmail.com, yuzhao@google.com, aarcange@redhat.com, 
	akpm@linux-foundation.org, chengming.zhou@linux.dev, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VANAbBUkMncVThcapWGxny-KKILfCpjPUScJuIYu0MU_1784561228
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3F43320006
X-Stat-Signature: sgonqb61adhn179hbi5pusw8x9p41i1s
X-Rspam-User: 
X-HE-Tag: 1784561232-297579
X-HE-Meta: U2FsdGVkX18GfTsZWHskyZtK/plk43krcKRxCWwOaoSea1eHGAcloQG1nn397XC/FWuXzUHHdWp8fb1P4FZ7sUut++1MnHC5UXhKw6JrRCyw1LrzTmFcXpd5aBkK7weXNFAepXn6kqFrlVdP70pYhqat2QcwjwPi4TxIBwacA14Dyk6sOi08xgDlp+zQGcefVC/ZNJeBnKVzEdmmep8BO43zH3ekLL/3/DiLyGjP28hHigYPB5150OpR83Lj3DULk0693QKaIqzpfPdQJT/7QWNR058ib8L918cZ1Y8QbO8owmQqwEGKofBfcqths2+rFHaMClR7cNkT+V3Gou0AfnWNtprA/Uss3OVFEpH/N7YSYGlzBAkbES3Dx3z3/xWI+ID+KbCid67uu4gEvZk+m+PasMRxLzJk8IKjwJor2n82QL4SIvJG9o3ZHSmfNbeZ5wzzzILSm05fL6qPJdeksVJTuj5GPXlc3ILwyYg0MAZeaxAEa1oawUEW9DxwHjy/U2AltG+9mS6bXGvrI9w/zukNAW3nrSn0MVS3uVPPX4bqmYov5n7/BpTo66uFxw2VeMko0AsWFSDmaTrwpGkIw3UKB/O1qx6t10UpkffmvZGNpUqUbzHQ+lILyFFFw/GWdI/AeWe3zptgqtVhlYFmJERkSyxECD0/ubIpygrsW1r31sbUhElDaElJh3gg55jym/feaVBSPhhwDrZhsvs+48eX5ymeLIPS4Yl8Q4k1dQscnV08ffRPoA4qaBRn2uDBnJw7r0FktnCd551WmFxfQ742YJ9bM1mKIN7dmUKArontuV5RuBM17hbFsEMsAmkheHKiBdWxsGb/n01P7z0aR/2XSQbzjDQLOHaBQF/Puz3J+Zc59f+ty3kmdhjpdMqSHX2G6JzBOCRNrIDTlHCmT6wA2Sfnii/Hqy9TSbYovwujdLhTj1brOSYzVxEecK6jiOibOlEyAeHtK58UjOz
 D5pUbqSy
 EiDHAPAdMz3ZWKYeUw1FMwiYi8dSXbxswsQrQ+JiitcTXYpdLMBYExw39ly1h5teYyK0CTBaSsgJkZDggi96Hfq+pPnCBf2BPsXjJw2hQkxArtJ+VWup2EScSDCcki6lny+7RnmYTZfGgCw3+gbPilesBgB3O6G9YP91C4r6mvpIJaXNK2yqLYP/yCN9tFTU6cXNd6Iryd3jDrJqygf0xma5Kn2O1xgq5kp6Szef5n2ES9q5ujF03PmzwqOYbAsr78Uf9tBNXbyKz6I3kOGmCAVyFCbnX5FTp6NMOEPOlMz1bh4wFFJpu1tkvniAmkt7OwKabAKyYKQE5DmI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 3:30=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 7/15/26 06:05, Nico Pache wrote:
> > On Tue, Jun 9, 2026 at 11:27=E2=80=AFAM Usama Arif <usama.arif@linux.de=
v> wrote:
> >>
> >> On Tue, 09 Jun 2026 10:07:20 -0400 Zi Yan <ziy@nvidia.com> wrote:
> >>
> >>>
> >
> > This would be a good intermediate solution while allowing backward
> > compatibility.
>
> And an absolute horrible user-visible toggle :)
>
> >
> >>>
> >>> Just think out loud. Or just skip huge pages all the time unless memo=
ry pressure
> >>> is present. Basically treat KSM as a way of reducing memory pressure =
by merging
> >>> pages.
> >
> > Hmm interesting. We should decide on future changes before committing
> > to one direction; however, i think the immediate solution would be
> > what I currently have prepped for v2.
> >
> > My v2 follows my RFC alternative approach: skip zeropage remapping if
> > the split comes from KSM. It also contains the patch (3) from this
> > version, which skips zeropage remapping if the shrinker is disabled.
> >
> >>
> >> I do agree with this. I questioned about if it even makes sense to spl=
it THP
> >> with KSM in RFC (https://lore.kernel.org/all/20260510114001.600681-1-u=
sama.arif@linux.dev/)
> >
> > This is indeed a good question but I don't know the right solution.
> >
> > Perhaps we can discuss it here.
> >
> > So far here are the potential solutions:
> > a) skip zeropage remapping if the split comes from KSM
> > b) skip zeropage remapping completely if the shrinker is disabled
> > c) Disable KSM THP splitting completely
> > d) add a skip_huge_page sysfs toggle
> > e) only scan THPs when memory pressure is present
> >
> > (a)+(b) would be my V2 which I can send out whenever.
> >
> > (c) is the nuclear option, but perhaps KSM for THP is rather
> > inefficient and pointless
> >
> > (d) could be used with (a) and (b) and allows more flexibility than (c)
> >
> > (e) is a more dynamic approach, and could be combined with (b) and (d)
> >
> > Let me know what you think :)
>
> Where does the current patch set fall into and what's the problem with it=
?

this series (v1) would be "dont scan VM_MERGEABLE entries when KSM is runni=
ng"

It stops all VM_MEREABLE entries from being candidates, while the V2 I
would like to propose goes back to my RFC's alternative solution
a ) "skip zeropage remapping if the split comes from KSM"

I think (a) is better than V1 as it doesnt indiscriminately target all
VM_MERGEABLE mapping but rather those that are triggering the issue
(the split).

Cheers,
-- Nico

>
> --
> Cheers,
>
> David
>


