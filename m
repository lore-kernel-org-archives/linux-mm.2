Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8624CA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 02:21:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B69DB6B0093; Mon, 28 Sep 2026 22:21:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B41816B00B1; Mon, 28 Sep 2026 22:21:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5A636B00B2; Mon, 28 Sep 2026 22:21:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7F3096B0093
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 22:21:31 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0F6BD1C2A99
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:21:31 +0000 (UTC)
X-FDA: 85265198382.09.4DC2C8D
Received: from mail-wr2-f34.google.com (mail-wr2-f34.google.com [74.125.225.98])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1EA61C0002
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:21:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AgqTKQB7;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf28.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.225.98 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790648489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QhRXGlPI7eTuBNU9/cBeyXlhvR5QBZCVis/qgqQbLB8=;
	b=nlKdFgVO8CrbnghUQhTN7hPk2/bOR8iPdFkF9nboBCYdzbNOjz2fRlB5hLux4/3hSK2nsf
	3QSi38DoD2k09vFInR2lRhVAA3Z34JlcNiVGDc3V+TriOxWAahdC9B0Vsw4AvgoaEiN8T2
	lPIc/95ddwQvogBvUSiixD57CjyXNK8=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AgqTKQB7;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf28.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.225.98 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790648489;
	b=cx8xUhb7DH6lCtZRFyDTSBI3sHbna6g9UgKzPnoHFcvBjrJhqNq3FDiEE8JuDsONbQn8ir
	3owt0nGXRBu2wQkxzSlLQ7McESEQ/NBJAcfHUYeRpnkFSFrkSkP/VIpOIRF97/EXZII9nr
	HxHmicO80+oRf/GHc62xhx7RgHCl+0I=
Received: by mail-wr2-f34.google.com with SMTP id ffacd0b85a97d-48af4663da5so43471f8f.3
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 19:21:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790648487; cv=none;
        d=google.com; s=arc-20260327;
        b=P25paY44kF9GnLgHJNl0sYbKVhFCzZadubJhlbvloNflYHCOSStrIeevS3u0jFgaw9
         Lbv5Lb8aLi4wI3RY1TVHZqy3GgtkYq5D8AtcV1q4Z6yAW6cI4HjJKSCXZvgWAts7xaSH
         3xLhRh/e603yBey3etuESM7zy4/I2q/YoAlxWJdlo3HMfWMnafOgEZlMzqVQzIEdqTXv
         lEbQ/4vgkvwYexbnN9l/e7BzwEGo8j23aFLHBl5xJ2nga6P90LHNH4ozluZvaLxgX9E3
         xQ2MsmBuZlKsT6hYaiE3teCQPgoFf1ytehq5+ywwhIikSzP8sdvpn7bMekYafM/zqi3c
         X52w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QhRXGlPI7eTuBNU9/cBeyXlhvR5QBZCVis/qgqQbLB8=;
        fh=GH25zDrPNwrwe5AVROT3b1R35u6CxJyiUOpgTWYK92A=;
        b=lKdOZGDoZvhmUoXLkRPnX4BmxMU5sjMoA5R1LIua14xCWa5rOgUkzMvViZdUAfc3YG
         euVq5VqCx6q1zOwxKizEV/FoGXaWKzQiU/GGnhkv5eX1LnBKl9vwCaizyKExej7Crbt7
         SM0ITFy8Nz7iSy453TWqNKpHdf9AbJfbybBc4PKyBFXu+xeM2XOalnBxtKwgMqCwHsxT
         7OSqJdEY21G6XFNn5k1qX9fcepXdIMSD+/1qzT/GNvV/zLVxR4CvBIgDqzA4ZqidjC2o
         /fR1XfdTATh6TNFEZtPwU7m5lcqDlJO40RELMmijD+p0pziUuEcNie5jXkxGbzNAZkl4
         pVcg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790648487; x=1791253287; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QhRXGlPI7eTuBNU9/cBeyXlhvR5QBZCVis/qgqQbLB8=;
        b=AgqTKQB7EAYxfvPY4rVC6YBXyHv2bWnSxkf/GgXvEnmqjLu0sdPAWDap4b2Dakk7nq
         C+IOVZi0v6QnMNloAiKspFJ6DMFr2+yKuw4JzqlMzfRpHskTOENx3jbvVaucUKyxyXm7
         DO21Q+0CMle7YrKfxqa0DW0yP9KhhWAPKSXMXpVqL/3brM5zQzEuXffvgAADeiRNAwYh
         sCwdWSaE4kXHjzPxkrV+xs7MIKycfwTquzlDm+29Y2GTxAEVQDmlAS7ZuaJHjMPSCXrJ
         u3Kwx5zI31YhMjnc2G5y1vi5090C9ACJOMWCQeaQ4SKgRHjwAGOG3Z8DbBRCh2GCanXt
         D+Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790648487; x=1791253287;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QhRXGlPI7eTuBNU9/cBeyXlhvR5QBZCVis/qgqQbLB8=;
        b=ZABJtRKGTUtU+nslXYNmK07gLpFzVEDZO88rLwPmqhaOImqaQqLCAttKPtW4iLIY+l
         zaGAcW4e+2LMONXdoqa3R9nVGE+0mohG8auN2yZvA48yD3OBNNcZkgoglGa8j51EFcZ0
         sQxZGZbbkQu2d77GYx4xlpq+YwF21OEBjsb6QuQyuQmRd61913fjy8ArBFMrWT3H4R5S
         zQ5oHfBM8FLf2VMxYQwx3c+LsIA+y+UGo7/YAYQZ+StBWjFKeylMZ1C5cmvDEOj3cbTq
         nW+UpBNjJEN3m/tzf2Rhevcok0ZO9pCcWwfZaeersMNYcMankXFZMBpOsKAWvzYitCXi
         gxhg==
X-Forwarded-Encrypted: i=1; AKwUvBxVGF7Cn2GOhN5N3t5NfqhBmMRVn1JulJLrs31+oHGjSJumNAVpKiqHa8aq0P2Xd9MceLqE1eNHhA==@kvack.org
X-Gm-Message-State: AFq9FYL6mySe1ZqmNyrpulTTOkm/OEWsjhlSz10VTejaIiEcGRoTbZco
	esA5HGuvJ9Mtva30JKdEmNKb+gJNCYp74AepNICyJd45VK7CFs0GrigoNdW/MuXn/bWW1jEDeLZ
	6D0MjlUkMhogteLsNZv0iewLHR5Q12h0=
X-Gm-Gg: AYBFou2jQ05iOYVkHo8tHgA5654R3PbTWoVFht3odo+q8R/Ea/p9o8rb4rcukMnxqV4
	5Dxk/nH6yNQbPKfs9maZ+DTM7Okx0Nge1PuSWBEMpJV0SU4G+xucGV+1YdJNp2DlYH+tpou/biM
	AaVtlJO1d5HQ1cZbwkbYaoUEyYP7GrTmIu/Zb3sCjLQTqIqD8Okqo2zSeI2CXlHz8PQ0TDSc/fX
	+J1YzS8rCTlnF9u3odncaKcQbpBPst8J5uKYn5MJH1vLNG5av6uARvVi+rCFY+zXuiuZTD0A+Wv
	FjPYnQEia9hlnnWwX0taFIlZlbHZJK4BqInKD8UVKD43s69p1Yo8LYRWCAH4RTHdKkI=
X-Received: by 2002:a05:6000:268a:b0:486:f9d9:fe0d with SMTP id
 ffacd0b85a97d-48872abc48emr28274596f8f.29.1790648487350; Mon, 28 Sep 2026
 19:21:27 -0700 (PDT)
MIME-Version: 1.0
References: <20260923062832.479455-1-jiangwen6@xiaomi.com> <20260923062832.479455-4-jiangwen6@xiaomi.com>
 <CAGsJ_4z-oqoxKynRr6mz0-5zZU_2NBnPkwz05CEEHHnwTyqa-Q@mail.gmail.com>
In-Reply-To: <CAGsJ_4z-oqoxKynRr6mz0-5zZU_2NBnPkwz05CEEHHnwTyqa-Q@mail.gmail.com>
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Date: Tue, 29 Sep 2026 10:21:16 +0800
X-Gm-Features: AclHuK8No2tft3nV17h4GBsP_bu8Pg3JxoSCR-9ncascs6inJDmmsjStzCiYUMU
Message-ID: <CAHKocdGWbEukM6y5iYDR3u-9jJrqr=zDxqAkR1smR+o+TFKGug@mail.gmail.com>
Subject: Re: [PATCH v9 03/10] mm/vmalloc: use pte_set_huge()/pte_clear_huge()
 for PTE-level block mappings
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org, 
	urezki@gmail.com, will@kernel.org, Xueyuan.chen21@gmail.com, 
	ajd@linux.ibm.com, anshuman.khandual@arm.com, chleroy@kernel.org, 
	david@kernel.org, dev.jain@arm.com, jiangwen6@xiaomi.com, leo.yan@arm.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, maddy@linux.ibm.com, mpe@ellerman.id.au, 
	npiggin@gmail.com, rppt@kernel.org, ryan.roberts@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: ge68wwye3ck9cm1b99tsxd7nmhxm1ucx
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1EA61C0002
X-HE-Tag: 1790648488-844517
X-HE-Meta: U2FsdGVkX1/axBGzsu8BnFRBJM7xq3IZnEWCP9bPAK+jR7i2y9JQnY/B+flYHj9BBF0ohjX3FLcVUyEOsVqSoEnwxD/W5md0eBXVDc1gixvxbdYy1JmwkkWe83z6zL8XDtT9sS592Ykf+yONX+LrdbnMhizS4eNDgcBcly9bXEA3sIvSGmHsUSu+LBKU/dcuqF5xisTtQrdHuIJC7UCsiq3RQAwUsQd3QjwbMNkmqeoD2Guto4gFeYwEGe7laY0zygTYz9TKztb334+RmSRdkh4VYSbJ9AsGf8IdkgtP9hsTicXHi89bl3unWzrP2EpG4rJ02ulbmt01bgFlyE90AL60aICnQHxIF9wqB6CNtLeTO0DpaRTtNZAXadjPZJxfV9+7Ft9KtKaPj53dv0vTzokQaMUGcl3T3tsOnTAUhCA8wkrn2lyeJj8bmPDiO/noW+Lc11sfPsLD8jmKD0RjB7mmLPkag0MGFu5xMDauFFKBO7JiIfHcJ5cmFltxunVu3prxSOOvu3pJPwCBaHYeNCnCuvKHhnCyY+P0ogVOy63oGHHY+ttgC6N/++xAfh0mTa9s6oRgwB5xH70Cwccp2YHV+/qmGuBqXDuOPBMHPB07o3dgItV43Q6FxvTTP66E4fQTJD+JHekDe9O3B+x3Eoq+s8a4HNbAuAYMePlcuKZ+ev+eu1TwCO3dtKYrCqkAO1gOsRasnaXNlTLNa0ttFgplROhfT+SX0+IHCrVEJjZaE5qyqqv3BBkB+D87wH/Zqutggd2I9jhJp+Hs2l9u7ePhnCTw92cKWu6eOsckrzDsn/2V/uZLEAtFxNFKaSXWWVo00BN3dxls4uTYn5gJgvLOfU+tH2R4hDxUbuCxt4zbC5NTuUs6gn7mMaOk39tkQPXMfpduS05YxTqIeNNbMfO+Rcp041We9ZhuF5vHnpZWzYwxVAciUZouZ81ZAvjOCrG5laQs59SBdru19Ta
 9h7zdHi4
 Ki1kIRtALkQDInQDPuzdhEmaUkfBF2qxMhXwWI9rmTtp7nW154BNTq10+7BAQJ9wgCa+bWsP9Pv2QAA4MzbkaZt5FShiHqVjzwPGq8WJz1xegFxIK63Ukr6wBMmturXeRu0r12nu4SKH325foET+KLCVBXpwSoum0N0VE6Z27jhqLxgaMwkc0mbxwPlK8aQURW/cPHBheNoQiDgslHJEj5nhg2uRskn30EN9/zwO237tBh2+adMZGb+8Qe42txmdipEx4FDk94+HE5rW2gpCrYsMpQG19IyBeSnq9qVeF120q+vasEvnV+0XKgwZBDvZ+SekZQ/JryupT2+6yAQFb60K5AcUR6vU1ardBqzWiwjcGE57vkjs1wApqekEYEW+P0IhvInO9ekjVIajvZ7gSCygj+/RF+ht2DsQOMam9DgpRvjuRV2pGue5LHWpp1zAvPGWg7H4H9JMzI3WFuAwnuZd+dyv0YeE/Tq9TrcswF8d4VqZ8IuGOehk0rers8wf1YVKLPOda+BsGuwImxMiFLsBPla5pXydnLZO2xS/fcg8rkmnVkgzOl7a+wKexTc1QCu8BkYa2q1oXOCLasokAGJzjlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 24 Sept 2026 at 05:38, Barry Song <baohua@kernel.org> wrote:
>
> On Wed, Sep 23, 2026 at 2:28=E2=80=AFPM Wen Jiang <jiangwenxiaomi@gmail.c=
om> wrote:
> >
> > vmap installs PTE-level block mappings by reusing set_huge_pte_at() and
> > huge_ptep_get_and_clear() under #ifdef CONFIG_HUGETLB_PAGE. This makes
> > the feature silently unavailable on CONFIG_HUGETLB_PAGE=3Dn kernels and
> > couples mm/vmalloc.c to HugeTLB internals it does not otherwise need.
> >
> > Now that arm64 and powerpc/8xx provide pte_set_huge() and
> > pte_clear_huge(), add the generic fallbacks next to the existing
> > pmd/pud_set_huge() family and convert vmap_pte_range() and
> > vunmap_pte_range() to the new helpers. The CONFIG_HUGETLB_PAGE guards
> > around the block-mapping paths are dropped, so PTE-level block mappings
> > now also work on CONFIG_HUGETLB_PAGE=3Dn kernels, and mm/vmalloc.c no
> > longer includes <linux/hugetlb.h>.
> >
> > The fallbacks exist only to keep the build working on architectures
> > without PTE-level block mapping support. They are unreachable there:
>
> Since this is a `BUILD_BUG`, can the compiler simply eliminate the call?
> I guess the build would still pass even without the fallbacks, so this is
> more of a build-time check than something needed to keep the build passin=
g?
>
> Am I missing something?
>

Hi Barry,

The generic fallbacks are actually needed to keep the build passing.
Without them, x86 defconfig fails with "implicit declaration of
function 'pte_set_huge'" =E2=80=94 the compiler requires a declaration at t=
he
call site before dead code elimination can kick in. So "keep the build
working" in the changelog is accurate.

Thanks,
Wen

> > the callers only run when arch_vmap_pte_range_map_size() or
> > arch_vmap_pte_range_unmap_size() return a size other than PAGE_SIZE,
> > which requires an arch implementation. BUILD_BUG() makes that
> > explicit rather than silently doing nothing.
> >
> > Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
>
> Nice to see that `#ifdef CONFIG_HUGETLB_PAGE` and
> `#include <linux/hugetlb.h>` are no longer needed in `vmalloc`.
>
> Nothing concerns me except for the changelog issue mentioned above.
> Please double-check whether the changelog needs to be corrected.
>
> Reviewed-by: Barry Song <baohua@kernel.org>

