Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FCF2C4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 05:32:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00C916B007B; Tue, 21 Jul 2026 01:32:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F25B06B008A; Tue, 21 Jul 2026 01:32:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3C7D6B008C; Tue, 21 Jul 2026 01:32:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BB2E66B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 01:32:13 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 30504160202
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:32:13 +0000 (UTC)
X-FDA: 85011662946.16.D1DCEF5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3BA7240004
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:32:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WJq9DsMU;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784611931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RzkhmVysTB+3FhpZHqTBXRWAVQ4ajFkqoNkLX2Icq6U=;
	b=W1g5h0E2YJDA5DXFjI9kjU1DRddYnJW22DdOVrGhyjUgH7BvGmLJG4snEd9DzMN81Ehbn0
	k8G0pJemfUEl02ufUMo3Mt5CWXCGb0DrWSNhLceRuX4as93fsX9Afcd3emqcqwLvsqeqB8
	p89a+2FKzFmZcmW1BtgH7lbfryvpo1U=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WJq9DsMU;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784611931;
	b=wIFo8eMxAk9STRgqvDcIR0bGX8yDdVgk+S3625CaRRvyQxhwBEJojrZVUILzj4Kpb0oLVu
	bNCW8mqTrGqIMUEsS79QveSDvhpYrOxPgqRxH++r0gMSxmpNqF0o9A4MDsSnHBdvkFqbH5
	Ath1Qo3736kY2eFZXJjnQK164GfmcF4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EA84743F12
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:32:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21C71F00AC4
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784611929;
	bh=RzkhmVysTB+3FhpZHqTBXRWAVQ4ajFkqoNkLX2Icq6U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=WJq9DsMUaXv4iEHRkwxbJA6TNxFeqZJDjozrUev13yLD4uJsRlrhg6rhur2nqC7xl
	 R8mDjtWChby49M35n2a8dkrVCpnvFT8LbokCalZBXNELcXI/1KZIHfIt72vv8y4BYg
	 2HC9lnlCzB7ogUuy268VtMdxdJJOtFK8mFHPAU8qtxBkH3npUOCUc2YkCayS+yhWK0
	 qPCFFUeTbGnArRrYKFQzsoBvrpuG4tCDCMriyTgURIBdPLOAUxwFKnp+lq5M6F4He1
	 TfQVpdZXQKD8GRz6meOUCH2NHixNNRl0VypBvVaZkhgpuVGm26OTndxWMa3ns0PqEC
	 amTwejGPvwONg==
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8ff5d1b0f91so74090536d6.2
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 22:32:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqLVE32RJq3j7vGxPI4xTrlkfVzGBo/Cu0Bc4Xj/n0UuDCs4FhKYGkPRpEgkJeyPzMnUfgr+wpmIQ==@kvack.org
X-Gm-Message-State: AOJu0YwzwSq50+iZqybouWWMlkJhbPqDTMzOJG0w237edUh2/DgFWFNv
	a3wiLhwovefqUPKFljnSm2VxfeJ3Ue1P378bV1IpCrDeSpB/+hfKW8EDDWvNeP0N4FICkxNXSVr
	fMxXd2fOIJxazrSY3Eb++XHSdrL/NpB4=
X-Received: by 2002:a05:620a:708a:b0:92e:fd2c:6a21 with SMTP id
 af79cd13be357-930b3ed4e6bmr1663562985a.27.1784611928996; Mon, 20 Jul 2026
 22:32:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260715120813.3609949-1-jiangwen6@xiaomi.com>
 <20260715120813.3609949-2-jiangwen6@xiaomi.com> <6adafb9c-b966-473b-90ba-3432b5574039@kernel.org>
In-Reply-To: <6adafb9c-b966-473b-90ba-3432b5574039@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Tue, 21 Jul 2026 13:31:56 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y6EQp0mC7d7Pzah_3s+zOz=Q1_ZLUZm6LkM4TU-2u8YA@mail.gmail.com>
X-Gm-Features: AUfX_mybLSmHnkoJKgQHlMTCQ-UCwhsLJMzd21312ixk_MsP-fohERkDNrtkZ54
Message-ID: <CAGsJ_4y6EQp0mC7d7Pzah_3s+zOz=Q1_ZLUZm6LkM4TU-2u8YA@mail.gmail.com>
Subject: Re: [PATCH v7 1/7] arm64/hugetlb: Extend batching of multiple
 CONT_PTE in a single PTE setup
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Wen Jiang <jiangwenxiaomi@gmail.com>, akpm@linux-foundation.org, 
	catalin.marinas@arm.com, linux-mm@kvack.org, urezki@gmail.com, 
	will@kernel.org, Xueyuan.chen21@gmail.com, ajd@linux.ibm.com, 
	anshuman.khandual@arm.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, rppt@kernel.org, ryan.roberts@arm.com, 
	dev.jain@arm.com, Wen Jiang <jiangwen6@xiaomi.com>, Leo Yan <leo.yan@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 3BA7240004
X-Rspamd-Server: rspam01
X-Stat-Signature: tsf9ingjh8dyeamqphedf473u8xy93un
X-HE-Tag: 1784611931-241066
X-HE-Meta: U2FsdGVkX1+8S0rDzdkhSzmZTAfnRkHpgTQYPp7EKqNuP5xAqHAX+Put9XEP+GOhK0js3zJlYV2+7+XC3QK6RAGo4RNC8RPJl1cEM5Og3z8RKHVfZhM/qh8jcO7R2MK923uxzwVQ3P5Esl8KxW7AgxavfSvFqCM4gx1tPfXNVIkkA9tR2omR/y8JKqEKt0unzP5aqq1OvATTBnOia6G9dPZBA0JI0/fS1NlrzgwQLXt9dp2jqhNtYB7C62D7vAfhcDqkts2DMUgMUljJKh+9ljUiE56J3dGCRe/W2N4k1hrqQWMnfsljAIvx71ecTSd2J6GzbLM3KPQhOycCfTvYAQtURxBwnheSFkFlX61JYS1EV1FYIxEGeePpwc3fOCxYnazz6byp+G1aqZ29995wnyK7Uc3+8xlAAYKbdZQoeDCErfV6zbuPXa3Zs6YNT+UZdmpbbwr83R0emJnNJsCHuzE08SM4onUR9jvOXBsalPemsp3EFu9weddyzV18IJIKJXDvbZn+/gyicxr2fbxbpXuWipC5WZN2gKujAEC3QnYMsWtY7C1dZhbmWSu3ZTd/PsNuVfmXDdBzb7swd0xwad5pFB5Owcnj2I0Zjo48RvEyKf5/qSUNy1R58bOFXVDaE7oOCc/v5mwxG1ZzK+zkZkDVewD8SH1bW9mzZmc8As6OVt9O+w6ZjAmlKc7oZjZ6ERh5wq2YsKbZeiLeHMTKvzjum3btLBb+Xjb9ehmAkoySap9WEigH9szVbwBYsldBf8Yq/NBPVVeWA9BEWn9BaD1GJRVVqvSz/nVh49UJyddaisIFwcbDuEHocYBFe56KNHeSX15pkWFyXYc9km8Hdko0CMtkcUwg2oMXhf+yl8xgBtRJCbJXXdUhBeerLhtd/RpfGwZVFReDu3nhntZw438oZDXxjIj6OqokMyFNgj4146FZlbxwU8IeTdubYvMma4OQ8UuI0LdVfMG0ocY
 RIebhq6+
 X/2qOeTL9tFaTAjPKibKngC4fheErb02qM98njpIobLB/pdxrWgT4K6JEOMwcMqUwfM7MbvebvUjBUwPSrITm3WvbeBSbcDS2FG/yJm7/nWr/FFXXaff1rgorczfy8aBFw8K9WeQ0yTvQIGuC6LiaVXA4DlWXSmEwguYAUGkW/D34p8WEncVNnJtKGOS3Yp6YBnsoqBZgiD73OlpDeGGk5oBEg6gfM7hbn5859zLcEmRXaeWJZK1DqdamckM2eFZASwWpDyR8jZTrp6zZncWcfCwFX3+ykltyzQXtsLqjUCqBiBH9uOOUrZULGw5Ly8edCVyeOjHbad8l6RI80ekDiLtPD8OekzS7xVugBlFxsYY1jHa3NDIj2R9l77tbu9tRwmBVHCV5HNmCuQbCjb2X4p64lRlLNIX8jhzEfz6Qz+6Va1JRHptcejODZtGETHxqUD32AzMussxHxeiiwKciWpHbRVSjFfv+KCFx7a3Udy1jdEEPVksL5oeFH+hJ5uNNO4GvZzg5hU95vpSlvacHyGkMUurcavHkrFGBfFMPetsPcutd3IaTsoMJqrP0DAnOkA/iGKv/xfwZnJVlAowSoCgLMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 4:16=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 7/15/26 13:08, Wen Jiang wrote:
> > From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> >
> > For sizes aligned to CONT_PTE_SIZE and smaller than PMD_SIZE,
> > we can handle CONT_PTE_SIZE groups together.
> >
> > These additional sizes are mapping spans used by non-hugetlbfs(vmalloc)
> > mm code, not new HugeTLB hstate sizes.
> >
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> > Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > Tested-by: Leo Yan <leo.yan@arm.com>
> > Reviewed-by: Dev Jain <dev.jain@arm.com>
> > ---
> >  arch/arm64/mm/hugetlbpage.c | 15 +++++++++++++++
>
> Huh, why are we touching hugetlbpage.c, which is HUGETLB-only material:
>
> $ cat arch/arm64/mm/Makefile  | grep hugetlbpage
> obj-$(CONFIG_HUGETLB_PAGE)      +=3D hugetlbpage.o
>
> Something is off here, if vmalloc ends up reusing some of these helpers, =
they
> should probably get moved out here into common arm64 code.

This has been an issue since the original commit f7ee1f13d606c1
("mm/vmalloc: enable mapping of huge pages at pte level in vmap").

I agree that this likely needs some code reorganization. However, that woul=
d
probably be better handled as a separate follow-up series rather than as pa=
rt
of this one, since it is not a small or trivial change.

The main problem is that the kernel lacks a set_ptes() helper for kernel
space. As a result, hugetlb has been repurposed for this across multiple
architectures since 2021 [1].

[1] https://lore.kernel.org/all/cover.1620795204.git.christophe.leroy@csgro=
up.eu/

Best Regards
Barry

