Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1CAACCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 10:52:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7F778E0003; Wed, 22 Oct 2025 06:52:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E57248E0002; Wed, 22 Oct 2025 06:52:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6D588E0003; Wed, 22 Oct 2025 06:52:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C25B58E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 06:52:37 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 76ED113BB0D
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:52:37 +0000 (UTC)
X-FDA: 84025436754.07.2264F84
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf04.hostedemail.com (Postfix) with ESMTP id 89F794000C
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:52:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JXYY+HYp;
	spf=pass (imf04.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761130355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yEuWOBEN/U35xXneOxk8fuulvP+81wWTxzQsKgpzxyU=;
	b=Jb5JodwpPDhO4zslcelo2feAONwqN9LTKn3FuNccNZpE0kgZ5lttqWyUgcKIZdeJCLGCQ7
	viOfYrAt6LAr4qNkAHD1NO0YH4ElyFGB5N0sKaUDSIY7D+YnRktjCujV/v7rPk6exNkG53
	bxoay+EbBRGAmb+OsaUI36J+gELeEiI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JXYY+HYp;
	spf=pass (imf04.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761130355; a=rsa-sha256;
	cv=none;
	b=pnFYKQTf521yT2UrpPWlFLiJGTuJY+3YHCBNXoJ+8t41cppZOJif5llmZcS/tKOurRSqK2
	laPGA73z4A8AHirk04iJi5tHAqXZnFwyMZ52rQHnq+UWmg836+Nl6BRVdmWnYCzXc4e8V1
	+3H2+3Pmez2Z5f/wmUETH4EIF/J293w=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-883902b96c3so651820785a.1
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 03:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761130355; x=1761735155; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yEuWOBEN/U35xXneOxk8fuulvP+81wWTxzQsKgpzxyU=;
        b=JXYY+HYpvyA757xW1/Js9kosqJ/pxsd43jSOAvhXAkrGsoihrkq3P+0WzGKpj7nbVq
         FBtKFDkvlX6vMymkd66qzSd8nyH6t14VeMv0K/bBsKZ68ypm+pz1sSDOPazOSVxqTJnI
         rZ0oJ0h8OIAYU7sdS9KVtpRMj3LCNmnG/CKW73Te7DqBAxFq5fb6Asj/LeK+CCg59z0z
         espnlqABd8qmHIDWPuk+r2d34NqIRY12xUoy7npyK2I0TBflu/2RXEAIJMgPiYuZdj+0
         iRj1Qq4p0lSu8ea9Knq+F4rYUvpUIaiKk6rsD53pmN1h3/pUTI3HdHY8svx+3bcb2Fqm
         53Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761130355; x=1761735155;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yEuWOBEN/U35xXneOxk8fuulvP+81wWTxzQsKgpzxyU=;
        b=uz+TQAHxHqYstLB0utarn8iYsic3/e/PSHCImU4oTsWotfmlObd4rAh1fF+iJTkyfs
         NjsSBVQ9tNVB5fe2QHxktFF8uX252bDEB2c7xlbzekRYN1o0xBtB/nAiMDes+P5vlR5F
         MzuNnGHyWhgXsm016Stp6LecryHzG+rTHoJ5CDnImrdJVfj/Wmg8BAFOKdrGuTDKJvco
         XqMGEpBbN7p2dox+BrxbUpG4f6cj2jqx/r/iTPl9AAaO1KdTSbJEYpauEf0PVEbpCzg3
         FmHG4gMAc/NSstrZLfPH/d7ldRyfSL2tvJRBxqx/FKFH5wNvxA+wsln5HiRGMGLeuQIy
         +0Qw==
X-Forwarded-Encrypted: i=1; AJvYcCVuwdSNdz/Q8Lfg52B4xA6ZeM8brJ0uWaysKDN5dVJOkoQLnRKuSmT1bLojlvyDunhPLqyJMmcxzw==@kvack.org
X-Gm-Message-State: AOJu0YyyjkfA2QdEL6BDMfUvERzW4dLZiGjYJmsrhVfbrxigpNEa4RZg
	iMBHU907vsJJxxSTPZhGUVXFXAORTFKl2DbOQmNbULOjPn+qpWmbC8IOIno0Davi2PFt8KXZFw4
	EujRh1UQTFBiXhLVJ//R5ZGayxF6yLUo=
X-Gm-Gg: ASbGncsuOod+3mRz18QNHpxyipelJgVoVpXQegpcOVGMeaqJ33jL/BzmVDCIiahA5Tb
	dwfAK88kQTfkXxk2tJMgV9bV2VcTn2Z5YUQpBqIp1StaZQz9O6nCfOu3fBGIuYSoxRvOtkbR1tJ
	2xobKW63QLeX/YYrSpz8nc1Fvz9t9vbTHYvWzcxJrDJSx3Q9p3ctWgqPt0pfTYsPdSvw657k7AM
	c0MqB2HhsHx38ih32yKjRN5uZhKYG98EMvUNPR7VbqkeLW0fkQ9qlby3NO2GFo7KBxM6azUVc+N
	nDhdT55M7M+IDuDh7zF3x6Ah2rY=
X-Google-Smtp-Source: AGHT+IF+UfILE16/+y31/plfKL4BsKCPsgS9omTYmo7r7nqziwmbbysRvcZ1nTCNlDK4BHMGeEjCaYDlClvwVJdT4QE=
X-Received: by 2002:a05:620a:25cf:b0:850:b7ad:c978 with SMTP id
 af79cd13be357-890708f2553mr2525779185a.49.1761130354392; Wed, 22 Oct 2025
 03:52:34 -0700 (PDT)
MIME-Version: 1.0
References: <20251013092038.6963-1-ying.huang@linux.alibaba.com>
 <20251013092038.6963-3-ying.huang@linux.alibaba.com> <CAGsJ_4xaA8QRjP9H=n1hQfEfGop7vOd5Y=J+KQzuOyfa8GK-kQ@mail.gmail.com>
 <87a51jfl44.fsf@DESKTOP-5N7EMDA> <CAGsJ_4zPH0fwBOLQwh1y6jG3tCXHLGRCTyVVSCWb+NfLCEMV0Q@mail.gmail.com>
 <871pmv9unr.fsf@DESKTOP-5N7EMDA> <CAGsJ_4zW6ogVdi=t9JCuvGD9N21mA_ORXRCakw4Av68d9n+DDw@mail.gmail.com>
 <875xc78es0.fsf@DESKTOP-5N7EMDA> <CAGsJ_4zKGS-Xd-58ufXGoyRfaZWd8wTgv0b6ibHJ2aS14mQqtw@mail.gmail.com>
 <87a51j6zg7.fsf@DESKTOP-5N7EMDA> <CAGsJ_4y32i3aNYPum=8J3_Kt6vOSisr_jg6btB-YG1uQBqHG7Q@mail.gmail.com>
 <87ms5j4444.fsf@DESKTOP-5N7EMDA>
In-Reply-To: <87ms5j4444.fsf@DESKTOP-5N7EMDA>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 22 Oct 2025 23:52:23 +1300
X-Gm-Features: AS18NWAP0fbsGHxZLrVjv_J-9bnvKPZdV1GwoS51_2cxWur2X2S3xT3hLu6HdG0
Message-ID: <CAGsJ_4xhJSLnXOZy4kPmnif5Paq+OPN_Ww+rPk2WO4-ADSC0Yw@mail.gmail.com>
Subject: Re: [PATCH -v2 2/2] arm64, tlbflush: don't TLBI broadcast if page
 reused in write fault
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Yang Shi <yang@os.amperecomputing.com>, "Christoph Lameter (Ampere)" <cl@gentwo.org>, Dev Jain <dev.jain@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Yicong Yang <yangyicong@hisilicon.com>, 
	Kefeng Wang <wangkefeng.wang@huawei.com>, Kevin Brodsky <kevin.brodsky@arm.com>, 
	Yin Fengwei <fengwei_yin@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 89F794000C
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 43z7w9u88yziee6j5reudey6zuuengk8
X-HE-Tag: 1761130355-592312
X-HE-Meta: U2FsdGVkX18d8rA+UTlpmgkA0MAni+iwdVt6UPxExu5+ZXj8krZJ3b71L66vN2mLtfZrqRarkXz+EgwvDMom5UmiO+HJsxs8Qgu/G7r7OCZTrjca3cBOcepRRunG2JpFNjvhcSuGwdnk3tJtGL/lVQyR9WFolAalnSjZjKRY4HzMoGi1+Fa5MCY3nUEgiMqaT0u3HEuE9zr0k85tK8hsK7QxV5Bvx5D8mijC3c4n9hqrCW2Wo/S5L5TKQwQY9KDD39cN5F6phZ/bAthUadhTGj6bZGdmLQ+Rqk3/uTgKESWEaofq1kyPMNj2kb/sICuStpThnuWk7pzDmIPOIIlmB3flzBp8T6W49KIl3WcTVgqOrtZSruvEUJFfqpec9XcT/VQsEuW5FhqiE5PV08bwE+NKMNmtsj80QRr27JUcJJnXAdx+KtEVjVjccIeRiZoSa3L8Iq2g2W4sDmtoXPRGMsVUii4qMrU1LjCbx9t8pzXITR4D0Azy7TvFwcrEoxQytwsFlqRSddrBugEmynpZH1eE9raxJqoWYWBAXwFOB+yM5+PNvjEI44nbRAz8haY2/KOdQ6Jr9YyTrr8Nry+VboUFH8B1dlr31Dw9T1BPytoJGEOTPz6m4ggJv1iud3xTLRyFAZ8AzxLnVQE4PFo4GxX2Xq41bTHXoFwKiXJ8OARdVKRxulTmY2U5G42ezVVS88DHlw87sXqxHl5ydlSdIxXQbCwzVzvovXIWU4JhkxCo6Rdqszs3NFXz+mLznp15vk2CY5tkXE3vbYMHqmc9s2JcyeH1DfOXkvbKK3DmnV2VrwekjG8oIQfPgKxBBPsHucXSGikHJgQM8z/87fDg6FRMIrjSEoT6UEbb6V9KOmiRb+WuCJ3F3/CjfAaMe6vdwDzZCIrdnvsyLXcQJEpCK6048nGsjmyrSuJOMlv6Zjengl5lzFf6nBqMGPrjrC3vNY6/QHUuZ8uBD8z5TrU
 sm1Izo5K
 FXNZ+qJlIO91Ykv+JFAJGbmGe5/u+idiec7IMlBn/e6Kc8LZNuK/i8RP8+n0zMVZJ8p7VOmxnOQLO/9l8Hegd/8eBDwQJywpKFejujfHbghkI5ViELWmWncdOVDFhH4utIs5Ht8EIxB2lx64ZukZCXLMZbx+IU1aNAWpIa9eQwZ4BF76DQbX6wUG+XYWOYETEfDYaqB9bkc2e+Xnp7SRGdvq2ZVR23VAyXeedTquFJl8d3mH+bk7z3BSn3KyJrRwqjFY8V82lf4vipsR7rWK0jmNKgSKlEzYfy1EGZEqLG0DPYCwSQOi3+p9Inj/riIHL21WA4Sfweoe1eSV8CIKDKp1FYnKpNyUn60J2AOn9na9kFPrR/hepb9zZTBpaf3HO7pR4HcFYoIagGoSJEUlGRylvs63IMlyzJ7dJb4Lt2c+QJmg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 11:34=E2=80=AFPM Huang, Ying
<ying.huang@linux.alibaba.com> wrote:
>
> Barry Song <21cnbao@gmail.com> writes:
>
> > On Wed, Oct 22, 2025 at 10:46=E2=80=AFPM Huang, Ying
> > <ying.huang@linux.alibaba.com> wrote:
> >
> >> >
> >> > I agree. Yet the ish barrier can still avoid the page faults during =
CPU0's PTL.
> >>
> >> IIUC, you think that dsb(ish) compared with dsb(nsh) can accelerate
> >> memory writing (visible to other CPUs).  TBH, I suspect that this is t=
he
> >> case.
> >
> > Why? In any case, nsh is not a smp domain.
>
> I think dsb(ish) will be slower than dsb(nsh) in theory.  I guess that
> dsb just wait for the memory write to be visible in the specified
> shareability domain instead of making write faster.
>
> > I believe a dmb(ishst) is sufficient to ensure that the new PTE writes
> > are visible
>
> dmb(ishst) (smp_wmb()) should pair with dmb(ishld) (smp_rmb()).
>
> > to other CPUs. I=E2=80=99m not quite sure why the current flush code us=
es dsb(ish);
> > it seems like overkill.
>
> dsb(ish) here is used for tlbi(XXis) broadcast.  It waits until the page
> table change is visible to the page table walker of the remote CPU.

It seems we=E2=80=99re aligned on all points[1], although I=E2=80=99m not s=
ure whether
you have data comparing A and B.

A:
write pte
don't broadcast pte
tlbi
don't broadcast tlbi

with

B:
write pte
broadcast pte
tlbi
don't broadcast tlbi

I guess the gain comes from "don't broadcat tlbi" ?
With B, we should be able to share many existing code.

[1] https://lore.kernel.org/linux-mm/20251013092038.6963-1-ying.huang@linux=
.alibaba.com/T/#m54312d4914c69aa550bee7df36711c03a4280c52

Thanks
Barry

