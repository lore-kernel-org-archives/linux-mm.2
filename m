Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D31FC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:18:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 242EA6B00E6; Mon,  6 Jul 2026 04:18:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F3F86B00E8; Mon,  6 Jul 2026 04:18:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E46E6B00EA; Mon,  6 Jul 2026 04:18:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D425D6B00E6
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:18:35 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4EB86120348
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:18:35 +0000 (UTC)
X-FDA: 84957650190.18.CE7B12A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 613B580003
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:18:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XtUY7xGI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783325913;
	b=yIbReR3Sta6HSDN5nlhB90aRHQ0DU+wjSkcpshG0oH0mk0/bGOfwA/AKj94yhPAm6Xu3+L
	O0nMFqwFVEVjP9Lp3/5L1Jat4XNdEbMG5/7V+HvMWTBXzMX2VWJ39+1b5jlxKaN9zk0cmU
	OmJXdPb65B5C3lvxzLKL8v/NRL1iCnk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XtUY7xGI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783325913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o5s3lTRxE/V5YUOPhxcmUD7alNSYQeowuWxLscV1KZs=;
	b=1OcsrcpbPdQzceG092dOtizG7puTsM28jzyAbDcNuiu0N+jAmOsdmVtYOtsjB1hpYrqMfe
	qdhmX98ZVPpv4ovmtBB6lUHWJKt3jhPJ/b7BoVhQaN6Zo01vBVxM4Y+ceryH9WNLS8iM0C
	PFdMqQwMc+KH7bNTwMQMF8lak09lGoY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5094C4162C
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:18:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 356331F00ACA
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783325912;
	bh=o5s3lTRxE/V5YUOPhxcmUD7alNSYQeowuWxLscV1KZs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=XtUY7xGISOSQTy4FPuSdUfqFavcmAPMF+prQHSnpQqUAgVekJwh01RbUXcvWMqZHT
	 GG9OSRSODPBOkNry+DRI2fIN6RQ8PgK/C0U0rbCR1S4A9hW8LIwaloj2BeOr3j4Ov/
	 tvZE8Iji7FEIT3LMsrnn1wuqMqDqla8Dpv84ExiZIiw6o9pglpMSuv7mKCHohPSHNu
	 FXZPEm948eOJm/cZivU005/11txfM1IqYa4GSowRg/rPqPCSbywyAomtWXgtJ3X7Pw
	 xp0LqTLhggkp4pcNgOvU0KrJ0XAiaEhTyB27dFZqEnAE0FQfDa+z0jp0iv2Pduwzh3
	 80cls/PnG8T4Q==
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-92e55b62640so122278985a.0
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 01:18:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqSdqP4G1/M1X3/yGYWx+EhCIaM/DD8aXjFegbUuVq6IsXprVSXNrlUhUpXaBA/7SaZjNCfZyZRcA==@kvack.org
X-Gm-Message-State: AOJu0Yzg217efeVIrnVN8ZGRerWev+SllZJfpBmraumnIBX8fB1ssAof
	e+eJIV6DegpeYSTwW5m/s1kdYVOFR8uj+qQKTzZEUVlDBDHscnaNNifKhu3N6Gw9Z66vvoS4OX5
	WkZl26HUerh5n2Kdz2vTdDfqcG53QGLg=
X-Received: by 2002:a05:620a:4710:b0:920:56af:cee6 with SMTP id
 af79cd13be357-92e9a38a1e6mr1195190785a.16.1783325911560; Mon, 06 Jul 2026
 01:18:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260701235955.36126-1-baohua@kernel.org> <20260701235955.36126-2-baohua@kernel.org>
 <a9829fdd-75b3-4035-935a-f3a74fdc29bc@kernel.org>
In-Reply-To: <a9829fdd-75b3-4035-935a-f3a74fdc29bc@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Mon, 6 Jul 2026 16:18:19 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xwfCoy3utvtAqAstKGD9ScH-n55bTTKrLiHj=c2doZFg@mail.gmail.com>
X-Gm-Features: AVVi8CfHg6vK3ggIODcckgd9ACuCFCVejR0-Xv6RsgkTkX5OOt2_S_h3eu4f26s
Message-ID: <CAGsJ_4xwfCoy3utvtAqAstKGD9ScH-n55bTTKrLiHj=c2doZFg@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] mm: avoid unnecessary lru drain for wp_can_reuse_anon_folio()
To: "David Hildenbrand (Arm)" <david@kernel.org>, baoquan.he@linux.dev, kasong@tencent.com, 
	shakeel.butt@linux.dev
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, chrisl@kernel.org, 
	jp.kobryn@linux.dev, liam@infradead.org, linux-kernel@vger.kernel.org, 
	ljs@kernel.org, mhocko@suse.com, nphamcs@gmail.com, rppt@kernel.org, 
	shikemeng@huaweicloud.com, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, youngjun.park@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 613B580003
X-Rspam-User: 
X-Stat-Signature: q3xeg91q78debo8xujmgft5s7gnp5dhi
X-Rspamd-Server: rspam03
X-HE-Tag: 1783325913-229690
X-HE-Meta: U2FsdGVkX1+g+/kIhpwFTpfUsxaGG5tCsfJlNJOrjY5Ev3KcKBLroVlTqC1Clq9ZDqKXVXCgYq4FwH/HYhXV4Qgi3d0Oil2fGnszZrcW/jN37ljdwInKDjTMt7BIBKD7D6FBUmaOXIAYgGymBIGZzr9HLRbfcv2u9oE5BoPyVRVQFa8Y3Z54DKJiIPu1juNcYlfobH1cOguWwLaVI3Hhce07mhktZo3ombPp0HNe9tDSotPiA6NBUIr7x6xrvkzINcTdVaOc5t6FA0Qf35xE12cKgw4fNz2qLBSwt7G+olp+RyJBXwpaqq2AE5IXwA2HWLuU/1WpB0NiLXVKtDsgWazdXZvyzQJ6DDS/qmg7oZLsOxsxOoxhfjytkqdlgU56PjxWlXXZFrIBfyeJLfsgoKbL4DdgT2LVbvcY36Mcn8XdDLT5dDfW+PuP3jsYfh2wddwz1qaDZN8c8jumvJ4HOaAC1NsYPzsojkGLMdSeyhQHA9l6JAcD98mCc6ZYxwuhiPr8oAxAAAFY4FJ3nxUZu9G3YzW1XBHW42RtQiclNZaswGjPSLYKjU5SI+ADb1Xej1BXK2dxMO+zmwFYYn55NBZrhSLrZa4YbZl0gus+p+qq+64UDbaSn43Uhs6lT3xl72g4FsA0fHDcZtTTmotg6lvi1UJFxef5dAv+MsgcsMBlby/ejNmvKg+ofz/QOoZyThE9VeUsipmhseid2cAudXMjdIfudwcrGwspO+iK8JsMSy3pzuNKBsTHy278QlwK6GJECRN4l3vDVO8thR4EO58Y0yR/CAIpi9NRQybWK04zNcasPZXw2yNgh6SS5InWPCANa7JqJlRJ5LE9dy9mXiMESeC2flWHysb8+qcEs72O3SFshk/rKhCO3UI6t1AFcjUDpMLuqDuRqrtlJa3jyh2dmaFaAhmap9eke1COW6LNw8ZXxsUAG/zrG9YDrcK6x+5FkBPI4xvl4GvaO+c
 EjWZhgJe
 4ACUFUzQkZsdENK0H2A+3yaZzgxptHhpomYGabzJqsov1wCc8UhD5E2RCMwbzC8CD3Ada8x6RMC/TloG40oqjAfKCl90qb5VcnXqGcqA1hM5JSSa/SRjTDXAHnn16sdXYVE+12fc+clFIMao6Vs7ct/sE/PnqZU/RcFauwLrgr01jdWjHzhSRvdehbi3ngoB1Olb1VMpX/tSsi/2B+cZSEoIpFe/YpwmiMaeKV6wzJ90NHyOlCDbAYxVy+SBlVMI6+6Ojrw3kb13KcM0CFO8NLZGrKq4/mZ7zXPxUqMydJikVByI1pbJp80eETa2DuJ+VO+e1nKqEtVuUFKmCamE21KcdOV7ERzYYYw0f+nAhpNRfq95P08nSXtK6kb3v1A/ez9AQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 2, 2026 at 4:05=E2=80=AFPM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
> On 7/2/26 01:59, Barry Song (Xiaomi) wrote:
> > There is a case where `folio_ref_count(folio) =3D=3D 3` and
> > `!folio_test_swapcache(folio)`. In that case, both
> > `folio_ref_count(folio) > 3` and
> > `folio_ref_count(folio) > 1 + folio_test_swapcache(folio)` evaluate
> > false, causing an unnecessary local LRU drain.
> >
> > During an Ubuntu boot, I observed over 5,000 redundant local LRU
> > drains. For a kernel build with a minimal configuration, I observed
> > more than 20,000 redundant drains.
> >
> > Fix this by checking against: `1 + in_swapcache + in_lrucache`
> > instead of hardcoding `folio_ref_count(folio) > 3`.
> >
> > Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> > Reviewed-by: Kairui Song <kasong@tencent.com>
> > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> > Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > ---
> The other folks should probably re-review this patch that changed quite a=
 bit :)
>
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks!

Hi Baoquan, Shakeel, and Kairui,

Would you like to re-review the patches so I can re-collect your
tags? If not, are you okay with me removing your tags when I
send v4?

The concept hasn't changed since v2, but the code readability has
improved quite a bit based on David's suggestions.

Best Regards
Barry

