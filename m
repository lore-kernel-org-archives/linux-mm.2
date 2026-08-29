Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0981CC61DBE
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 09:56:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9148C6B0088; Sat, 29 Aug 2026 05:56:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C52F6B008A; Sat, 29 Aug 2026 05:56:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DB1C6B008C; Sat, 29 Aug 2026 05:56:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5D6F76B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 05:56:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 41015A0683
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 09:56:47 +0000 (UTC)
X-FDA: 85153852854.13.0D25D9F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6002220002
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 09:56:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P5+BAN31;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787997405;
	b=ShW8ebZtjlM/ZlskcoVGuAi4N0pShiiFyGCqzRDs2znqTO+h6eFtWvvos6QyffwpaY4jmg
	EzC6ZoupC+tgPhZnQyMQygk8PgUZ40DZGFYpaqNXcewBXBTrKU/wDRFsA1N/Thi2+jUDGY
	P23qWZDDwFJv8w/K+xLPHBPVuMstetk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P5+BAN31;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787997405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UrFVACfUigNKuEeAS2rOrHF/W3WbbIlyxgRKUtLSz3E=;
	b=wy8alhP7foP9Q9pLMh6S5ErnMz5KdCuh6eAriogSbXf78mVWbbBx0HqRIeBvBIfpT1jMqk
	BACVPYk8WljBa2GLB32w+BrVZOXodJi8kAVHhL6g+8lJS4FLyP11hVpdAssqjpfMlaedN1
	dKe24QM/+HKnhlJQt4YrpBnZqzqfrnM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3EAF044789
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 09:56:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 177D31F01560
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 09:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787997404;
	bh=UrFVACfUigNKuEeAS2rOrHF/W3WbbIlyxgRKUtLSz3E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=P5+BAN313h0CYeJo4TIOg6k1doINAoWJENv7bG0Iwvo1zxMOQ05wiV5Tlbbmbkivz
	 Fr+7RZKRDy1cZSaDDJF/ghikBBUh6aP7HgY6cMc2fmam85lNhaHg7tPJPoz2lUlr5g
	 JttkLUyZDJ4DV6ghVpEjgVOYlMRP11K18a22LhgAZAZDEiMs8Q/EIEXg7zOPfgo11u
	 bSjUNzqkRZphDgk0frTJTYODh/EnC8h5aTI3bumwoJj+Z53fq8LvdMM2Vhm2YrP6Wh
	 S7ApTqpxIQT4ox6317a3q5IKqz53YLJ8k0pObjgXlEARelFGvhU0J2X5qAmqNDZ3iO
	 nqwfj+LdoyNRw==
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-92ed3993c1eso93415585a.1
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 02:56:43 -0700 (PDT)
X-Gm-Message-State: AFuF++nqDKqaqImc0EllrHnhBsjnobU/cr/wDewtzNHHjeHTm4yTAO0L
	YPfT/RwWuNDqAv0mgEuv62dqkCr/uD1NjAMFv/9ArYpRoyvmM5aoxKrvTtfTzYLh+/1zSr5/dxR
	rbpfJVjGok89VFambwUPgovPoi/A0N5s=
X-Received: by 2002:a05:620a:a410:20b0:932:dbf6:6f9 with SMTP id
 af79cd13be357-9391377b55bmr1149584285a.9.1787997403348; Sat, 29 Aug 2026
 02:56:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com> <20260826-mglru-flags-cleanup-v3-3-d9f1c75549c8@tencent.com>
In-Reply-To: <20260826-mglru-flags-cleanup-v3-3-d9f1c75549c8@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 29 Aug 2026 17:56:32 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wKiM+99c5JzW4kp=J+2qPNGemnAg4x1PeiudamwLOf9w@mail.gmail.com>
X-Gm-Features: AcwNN1V7KSbbFyvp8SG4r87uwEoqsTqZAxA7dZIuQ66MlFFh0qP85fwkFdw6IWM
Message-ID: <CAGsJ_4wKiM+99c5JzW4kp=J+2qPNGemnAg4x1PeiudamwLOf9w@mail.gmail.com>
Subject: Re: [PATCH v3 3/6] mm/migrate: copy all referenced state via folio_migrate_lru_refs
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ridong Chen <ridong.chen@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6002220002
X-Stat-Signature: b4h1bwm511b37nxyxkhckqdmttefa1tp
X-HE-Tag: 1787997405-961699
X-HE-Meta: U2FsdGVkX19qB/qByx9aK7aa5/QOGsmmusjjchCXOPAmJEaoNWjHeUDqJD9lZtMIU9WtcrqJaidITv+c3dIJq8whNIPUIizbGAAB16FY2ADZtwLpBpsM5Wi4L77hbHDH4Qgy7DqVT2Xt88llkSAlJM8NoHvFb18Y6I7QPKoG/MHjGSW4hKJFcvuXjfTJQndSfu4xomsq5cz3mmFOgyE0U3z8H033nKVZJMKWP6M6GI8VY+iSUA1zJrqQ/HAF4KRPqcweKNwwmnJWMcfY/Jtv8yjIphSY7fcm1vJMi8pjubS5MQZrwaZTNn7Io5CvEy4N9dlhiwSCo4R4vPzuOFcxWxTh67tXGqvI7H7xbX9NUel7waOJT1EiIWTi5a8E2YikWajqQF1aJjEpwZxa+yFSgIi992YgPOBJPEegwQiP5uIy6i1nsn9PDTiB3BYEHNtP7Bbt+Div1g2NtabaP8Q+nwUtTbaWc5lIuOxUhd+GZNVC40FlL0LFkKzz+sI/UcxXq3REIa13YK4Ukxw3/zt1xsyUpEsD2sZqXcs+1hJkssG9v+XZHE+PNShVuOb6xmyBBhfZ3B//TUHvJCaSeJxxU+CJajMHSerC+k12CwGpMUydAwVhk+IdsSg3POjPc4AYFDIpyv45qCnM9aNHNOpT0Z8nGRxsXCCM6Y1U0qmadl2flRVmKFkHIQRTKa7eSZ2X4B11yh5X35Kqnk5UgL6pyW7cOI3m1GI7Bd7n5OPVxVd4a5993MPojN7QqJQgDE3uw6sctd6La65U54dHQP6sLZcBcyQt3DfRnGY1A/+Xex+/J3/5IzGhxI8q1p3R+qmWQe2nrWWDkHfePEt/U0RfLAR2T5Vkwic8l5iVuOVnAL+V1oEmYbkhayznbmQA/HoHq66Ie9b3TtL7fERbM88VVoG8UZm/fhy1PUlPmErXwy4cKUeX0RTswXs80WriruiKwEw/V1U5gMup9TOsZ/o
 w9xvIiL2
 XxgeHweesokvtIfriCWFxlatrDdKv3Cq8DqEztBmpWtpLxqLAgf8gxkWysTua6FfmDzh0i30rOX88rSCrMe8L5LO2kwQlHkEhy5PVgqC0ryrnTaxuJPv8CEJY0EONKUy9r4thwX5ELK//O+0K0i8n4hYuSNneXccbwYhbRrTBAbtINaQA4xEeyvc28WIy4KHov0Qg4GFadd3GTU/+U0Vml34pMMk5y1PBXWeKLKZMOH7gTM4vxs685MFOTtQUjq2IQi0LjMHwx0rFnelMr5bYDAVHmGArij1jLDaCpCU7MZv4ZP+7v4BsSmaiXyh7JOH1y15SeRz3+Odgx7q/eFLBbGqh8jCjK1+dkh1U7abmzf9kx4BFzPQTPRajTBIFEoVaPSVT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 1:53=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> folio_migrate_flags() copies PG_referenced separately from the MGLRU
> refs counter, which folio_migrate_refs() transfers. Yet under MGLRU,
> PG_referenced and the refs counter bits together describe the
> referenced status of a folio.
>
> Consolidate the two: rename folio_migrate_refs() to
> folio_migrate_lru_refs() and let it copy the complete referenced
> status, i.e., the MGLRU refs count including PG_referenced, or just
> PG_referenced for the active/inactive LRU. Drop the open-coded
> PG_referenced copy so the referenced status is transferred in one
> place. No behavior change is intended: under the active/inactive LRU
> the extra bits are unused, so operating on them is a noop.
>
> Transfer the reference state first, before the destination folio is
> marked uptodate, so a concurrent lockless reader cannot have its
> reference update overwritten by the copy.
>
> Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

Yep. We now have some unified code for both MGLRU and
active/inactive LRU in `folio_migrate_flags()`.

Reviewed-by: Barry Song <baohua@kernel.org>

