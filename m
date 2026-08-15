Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D2ABC5CFDB
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 10:03:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00D536B07B7; Sat, 15 Aug 2026 06:03:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFFED6B07B8; Sat, 15 Aug 2026 06:03:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E16556B07B9; Sat, 15 Aug 2026 06:03:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C26E46B07B7
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 06:03:47 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 57C6C160340
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 10:03:47 +0000 (UTC)
X-FDA: 85103067294.21.2DB4284
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 71FBD4000C
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 10:03:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ILOeqGZL;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786788225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DOzchtcAHZDrYydQsfg14A4ebsbu888nAlLiso2W+V4=;
	b=nkM6vIEXLRfGqVN95wpu75fGjTY9H1HgFCp7OH3885zUNg/rd3Wg5PK1AnENSkhAdKA13x
	mQayu6XY0IVjcgzErzURMKtcBD6CP4jzbrGCjkre/H+8gAVaiL9FyyfBNIJRoNvbI9ACE9
	SzaaD85tuHLt8+z5omRJMOhDkPn+E5o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786788225;
	b=eC75+mdzkPVHMYDhcONQ2CUsXEicc3tG1lyU/jLjwiLQCVg7UUY0qDEu4vioo2/K3hLMfh
	9/C5bgrTQv3JXY2O+ACHoV/Fj10IPLKQWQSQuqwDeL8LltrYqxA4hZt4a4le2j+tIgFpk2
	jI7FodrMLE/bdcsL4JwvJthc0OeNLeg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ILOeqGZL;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 584C043F86
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 10:03:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CCF71F00A3D
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 10:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786788224;
	bh=DOzchtcAHZDrYydQsfg14A4ebsbu888nAlLiso2W+V4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ILOeqGZLsTQ/yq5Y4w0xEXmVcS2zD0lsim0EsZyCKoNOaS/btWc+ThWQhlTLMBVj/
	 YmFf3GSY27rWv0/JWRfSa8gw1iRgGrND6NzDMBWOt7I0y6v58GRIqObZ0k2dIa+jqI
	 /5Wa7H2H9TlF58DUZxNKICSXbUXXFKbWrggBg/waKOUPD78Kg/dl0FXSS42Ckqnrr6
	 W9MS/9gigr952LG2ITav1L3w1kBD9CcDX5vMskzkKx/STmJW26X8RR7EhYG9jh6IsP
	 qFJyHJpSPRKXhCLT8j0YVOjm0OP7S9vLBphUrwfCNPBes9fu7bFHvLT9JFlefP0JO4
	 XWYWSvDos7wiw==
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-92f03daaa97so108724785a.2
        for <linux-mm@kvack.org>; Sat, 15 Aug 2026 03:03:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoNUC5Elvk/Z7GdqxVFA9hj6VQrUmWl9YjDh39L74opUYlkKVvG7X+2KDXzejsWLXj6GC4XD0UynQ==@kvack.org
X-Gm-Message-State: AOJu0YzFN5zrMIx49HbFXhXe8InwAjEeUWm3vydJ0bVT8bhF9Q0YUs0Q
	qBSXn1zuPyfNZU2HqSwaGUUX2q6M7SnJNEy8LZDezsKQ0WguBELjte1hOi8IW7oOmj8xnQiNceG
	oid2C76QjlclOb+TdmRJdzTD26HPPF2g=
X-Received: by 2002:a05:620a:a2da:20b0:931:18e:8642 with SMTP id
 af79cd13be357-936d1fdd990mr978019985a.2.1786788223590; Sat, 15 Aug 2026
 03:03:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260815084026.44078-1-eamon112009@gmail.com>
In-Reply-To: <20260815084026.44078-1-eamon112009@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 15 Aug 2026 18:03:32 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zvttvJbCdi=9FTrfq=XbJm4F=dYfmLmd8r7LH4s_TO1A@mail.gmail.com>
X-Gm-Features: AcwNN1VsPR0lFiFnPCcSmn5uQMXXz9otGbRp-PcMRShmansBxVE1KjB4Yps6RZg
Message-ID: <CAGsJ_4zvttvJbCdi=9FTrfq=XbJm4F=dYfmLmd8r7LH4s_TO1A@mail.gmail.com>
Subject: Re: [PATCH] mm: cma: make mm/cma.h self-contained and conditionalize includes
To: Eamon Sippy <eamon112009@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: myfdt4xwabz6i9gfmrkeq79hhjzow7ee
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 71FBD4000C
X-HE-Tag: 1786788225-716287
X-HE-Meta: U2FsdGVkX1+eBHruf0w0w5qo31EzTV6RMBJMGB9S9/bmrv+R1bC7C5WXgkM0M5YzOYLKBJy+KiNm59DqypLKajC98Tn0/hom5/jWLk1n00ZDAwGEuSKIpl6PfgEqWNhnJYFxoDJ3dhti8ygJwFAEkwjIQBqxBYKQ1kewWW1hiY3lEiayw251mJi3GWj4iM4iKPpBrnIHmlodfQowDe5AnKmiV6UiLSX9JIfEIxuOAD7Fxn+i1sB3uxhj6Syof6sxSwoV5qibZjAw7s9/vXZpGqp6H+PRlenLa4kIjiRaLTiykYdXHckQZmkznF1D+jBPvXaRzgH7OTFeJ8MikvYHyQiRg2Tbt2+ffdmGybxtDkJYnjotDNEU25xsefLR004E1JX6bSB5TPvGwZ6Wc3Kynp7V6KSAsntBG3+tyAlWe8wsamJUmvSMCbzzAbMPJb3y7Ge/D0HZaphKZhwYYFkwH6kJY1yFdFTEaDMbinNxyrI6L4Sn/p+3+/BOAdb44grlhPQQFMNsw3HCQqlNFbAtblBUhQTBe3QdF1EVS1CwZE5bjAPQXpnP7EikqgoSOtEKYIbE9BlPpYiv75ZFoReiUuf0+3vr131twO8CQcN5JbTnZFV3VbyNiwsmcKAiI0jsQBIik9qI0xFE9x5x/eOAT9JyWUT9oWDjGU2MLmhsBO9ogPp236B2VE14giH3r67gAXwBnmPGaPsJO9NmHf4jFOyggqjvnYRDqXgydMeJeiHlL4UbeeIB6aSB6RFifPggRi0zBr5kfU55ibZYcIRh2LSCsuFmR8drsLhrAnvia4V2yVh9u4WI5qq8r3O3yqhwYeJf3N4hyB9rJlqHIG+Pq6wRKm6bDSWxJo+X6T43x/K/DJ17o39zpq3zhJYqfun7NSWEtzalULyv5exQIKR9hWXEYAsyRobGDhnj2U8r+iBjWZi+q1cxbKyj9GQXn6byKFNOXvUGnaxhmHlndsS
 4Ld8EO+J
 1kYb0qz9+1uH6MlZ16oTHcX/yPtrCMPSzs2ddCS0b8i0YMOAsJbMn8ob704QLA0OmX0BsguA8sDSFe2cB9jKzK9FP02Bb2Sck8birKn3PUVopsyncTP/q4dZwh6zak0lkBJi3ukUyJDYGfW6J8Dc+NTzxWf0y86Yjjd8OQPP/Zo9BBp2n9uHNddgoQcpu6tg7gj7UkMLtvnw5+SYpuctx9i8zmasaG5xQeoAUBii5h7tGkLqThgwyO2sKWSz79UJCsid5HdDBYxVdfwVeBk/nEHOni9EJgZFAT8+sTECiW0uaqQMqRHSCaXCG3cbbJUnbd1x18j3N2gQUctmiJ/IDnSEWbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 15, 2026 at 4:41=E2=80=AFPM Eamon Sippy <eamon112009@gmail.com>=
 wrote:
>
> mm/cma.h uses types from <linux/spinlock.h>, <linux/mutex.h>,
> <linux/atomic.h> and <linux/list.h> without explicitly including them,
> violating the kernel header self-containment guidelines.
>
> <linux/debugfs.h> and <linux/kobject.h> are also included unconditionally
> even though they are only needed under CONFIG_CMA_DEBUGFS and
> CONFIG_CMA_SYSFS respectively. Move the struct cma_kobject definition and
> <linux/kobject.h> inside the CONFIG_CMA_SYSFS block, and move
> <linux/debugfs.h> inside CONFIG_CMA_DEBUGFS.
>
> Remove spurious trailing semicolons after the empty inline function bodie=
s
> in the CONFIG_CMA_SYSFS #else branch.
>
> Add <linux/cma.h> so that MAX_CMA_AREAS and CMA_MAX_NAME are always
> available when this header is included.
>
> Signed-off-by: Eamon Sippy <eamon112009@gmail.com>
[...]
> +       unsigned long available_count;
>         unsigned int order_per_bit; /* Order of pages represented by one =
bit */
> -       spinlock_t      lock;
> +       spinlock_t lock;        /* protects allocation bitmap */

I=E2=80=99m not convinced this lock is only for protecting the bitmap. It a=
lso
protects things such as cma->available_count and the allocation checks
around page_range_contiguous(). Could we drop the added comment or
use a more accurate description?

>         struct mutex alloc_mutex;

Best Regards
Barry

