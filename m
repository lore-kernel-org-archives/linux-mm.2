Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 589E8C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:28:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6402E6B0110; Mon, 13 Jul 2026 12:28:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EB1E6B0112; Mon, 13 Jul 2026 12:28:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5282A6B0113; Mon, 13 Jul 2026 12:28:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 17A9C6B0110
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:28:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 86DB4C106B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:08:53 +0000 (UTC)
X-FDA: 84984085746.10.AE95DAC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id A4303C0007
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:08:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YLa/b/ra";
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783955331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S2412bZGPWPZN/aE9c6H2BeupCTWZve94f17fgRu1LA=;
	b=A+TKYySL/VybuPX9QRlMa3GMIm7BRgYB8fB9KkepQ0M+EHhyVyIWzTF//IIbbnvCaGj3Ai
	osdgfjRXSP6mP3P7YGWL7swNQtyW9b52UFw07I+MWeV2s7mSEnoDai0L4x/gCMAkKhvCR1
	PJwE2NveNTQakxaWTx8NXrldIi0Cqss=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YLa/b/ra";
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783955331;
	b=KZFeZ5ihtD73STKPQ32nw68XLakZs3ZcLCmzwd4iBLQGgjmBzJmY8QER0mDumOXsHY+5/B
	24zpiA5fDLouupl1WEW9JGiZP2JSJbvZnhAEwSdIgPk/v6z81925lKi1NQw4ngEm0btKvp
	Z37Rizgu4iayXNrE8k/qXFceaOxpZGM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D08BE415F2
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:08:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B52911F00ADB
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783955330;
	bh=S2412bZGPWPZN/aE9c6H2BeupCTWZve94f17fgRu1LA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=YLa/b/raGv92tSdUv9UAWOao6aVFMj30Ug05SffbFSQtkpuRWwsvRajvBd5pu2xy5
	 WIVDnWlGAl/+hquRbDn5vIMhIPHRRXKZqAen1EhV6YpRGJBWW62T7DmypOZSNv9BBO
	 kipg7QzfVTX3Tx0np+AycgHjCdfOyP234p67vtwOBowb0bOUwyXvbsNlzVuTwlbj1S
	 /WMM3bcWWlzBzGLScvaYDdfVWgepFW+ffTKLZntpKQyTIinnig3TPdRVSfWDYVFCvg
	 V7zTr+v2+Qh9Dr3X1gFv2w6c/1q/wS+CnHZVB8e/JEvgf8Bhi3GnEMjD8NPc9Xej6X
	 yDnHw83VDkb5A==
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-92e67555e24so193898985a.3
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 08:08:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpePN+kTjEoP4OpZNfE41DLWd/WzDZhn9vxvNN6j344OgaanqurGIFu5MkIOgtpVnKR0PjfwjYx4w==@kvack.org
X-Gm-Message-State: AOJu0YxM4g7SCA2JO9imEeCM4W0jwP5snXHA94Yk0zNNHNlZD2Zr9s/w
	a7IORGkoG8mr+9LhsWiJ6yLcA/kbBimPLx0XfUSI7AUYU4YX6dTXwE+FSnNvV/x9LyPXbA/v/a/
	av3L6RC7kg52DlPWwP03XOsyULcBaKCY=
X-Received: by 2002:a05:620a:1787:b0:92e:c118:18c2 with SMTP id
 af79cd13be357-92ef2cb6546mr875536485a.77.1783955330036; Mon, 13 Jul 2026
 08:08:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260711091157.306070-1-ridong.chen@linux.dev> <20260711091157.306070-2-ridong.chen@linux.dev>
In-Reply-To: <20260711091157.306070-2-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Mon, 13 Jul 2026 23:08:38 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y39eSYqYwSPzqcZPk1wcJEYN3HZr83MPv8pMgN8Nct5A@mail.gmail.com>
X-Gm-Features: AUfX_mw4Br7J34oOX27RZ7iWI9pqul0zzHhz-BOIuYA7_p2QyaEZNYFv5_TepBo
Message-ID: <CAGsJ_4y39eSYqYwSPzqcZPk1wcJEYN3HZr83MPv8pMgN8Nct5A@mail.gmail.com>
Subject: Re: [PATCH 1/2] memcg: move mem_cgroup_swappiness to memcontrol.h
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	David Hildenbrand <david@kernel.org>, Yuanchu Xie <yuanchu@google.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: wgcrue9kb3d3bdds5968s54rbf58185m
X-Rspamd-Queue-Id: A4303C0007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783955331-56960
X-HE-Meta: U2FsdGVkX18oUPxOUXXIYrRo2thnccR/Jwj7QXc3zjTBPJs+GLYR3cS9Si9XEVIJZyt9vD2Z6sJ6NOGZI95bD9S/fxt/NCKF5CXzl4yxcxtNesoIfClH292krJFtFSw8Ad645Rniy3uSaaQYBkMv2PGBqzoyFu7NDUgam4q7TViuCFvaWNFXuFcy9SqlGuhofoWFNPzyjm3ySERcvCSJEv8P4/oQWK/zpoYn/9N5NiyjyETWDzMOzn81MzgvMasgY5Rlic39T+dry1fcLgKHKDM9Co/lx44nPsTyeMu+wDz+ObDqmFqrZW4pNwSqDJaDhNBKy7FwmN36wGtX+bJhtbMa9WGqrTCTRa2hwWa0GNd9ApqBPqrnra9/FP6HUS5utqjO5n4V8+xk2nwAOS7CiVrOBz3qPowTTSESQ369W9nHm+b5wZxKdv8CkTRVQki8rayh8uXdmYS8m/53Qqo0JjoE+MeDRq4PyCkGM0HvGTFtsRmV2XnlVTxyuvEAwWKidYgmCEo3y8q1u8onNuT1pdM+iEcizMsdPO016aKnJDCLqJg0HSDs9b85QKq3sqpXED/HvY7e6o8G6ouX83JjM9dRXGcWUKGEC1XNcko4b01jYjop2Mvc/i58mzCikZVUxQeTYv6sCG6kYoFr/rnDO37KwXUdnqIDPLUphblKEmAAbDJjtr5me17vhKgCcq3F99SWoTPbIXIgOpJjYEv5lDoe3jVnbBo3c9DtI4p6FSdr5xfPuUG/eBew6QPWwMY8arvTEItSaVQHVISBzHyzVhUywQ++mHN7Bh3QQzjb09tjzaasbz3w1EeIES0IxaQzrCmJo4mpGL+Egb+DVaDt6BrECduU+JvI5TAgx/afq//8QTgXV/+yPVFJv7tvKciBAc83Q2t2OoN2Sy+X2gk1LsavlBSYduANT1FFA/bmvJa/X3gZsoH6L2xdEBedX8i5j4iDT0RuoOWl3k1iCax
 spB3FUPn
 wE8OUFrGrEpmRRhp4q3sjhwz07ESAHisgT8t9qKJHWhgHqHNwnu+9pvKcCf4fAmdyMMAKeDLWhCM6LYY33W4ZZrrffZIJVkA809JMN3qo0WJ7RtGk3s37tING5flWmR4ieTVlHxM7zAqv8J8Z4RKTwbsg0KCRm8n7lElBYeuro+hWzaNsIVv+XPQS0mOFSkwda0Mo7ch8ZBHF9oT7yGvCejuAx5ELQECb1HKbMqrJ0TAnJl6+gmflSLUoVYwN2DYZ7TN10Y9JuatNkcFbCoobW/66kWUwWw/N+6YCXaVcYs7PlnS/NeLSiMmqf2ATqFe0R6SgGrd/sGBLi2j4yg1EJDHKU45GZmvKWditi+bz47Ae2i0/PUcJmsDRykFh45op7Wm/K4pTdeSqTvCS49mpvozvF38aXVwVu0Rs63azjp6gm9pJHJvdcsH3DKoxXEbpqpCT3RlcBJO+AT3iWtYvEHHXZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 11, 2026 at 5:12=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> The per-memcg swappiness knob is v1-only; v2 always uses global
> vm_swappiness and ignores the per-cgroup field.
>
> Guard memcg->swappiness with CONFIG_MEMCG_V1, and move the helper
> to memcontrol.h where it belongs.
>
> No functional change for v1; v2-only kernels drop the unused field.
>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Barry Song <baohua@kernel.org>

With some nits.

> ---
[...]
>         struct mem_cgroup_per_node *nodeinfo[];
> @@ -365,6 +366,9 @@ enum objext_flags {
>
>  #define OBJEXTS_FLAGS_MASK (__NR_OBJEXTS_FLAGS - 1)
>
> +/* Defined in mm/vmscan.c; used by mem_cgroup_swappiness(). */
> +extern int vm_swappiness;

This is a bit unusual. I'm not sure whether mm/swap.h would be
a more appropriate place for this.

Thanks
Barry

