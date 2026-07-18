Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E27C8C4451B
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 13:12:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E7D36B0093; Sat, 18 Jul 2026 09:12:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BEB76B0098; Sat, 18 Jul 2026 09:12:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FC8A6B0099; Sat, 18 Jul 2026 09:12:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 68AD46B0093
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 09:12:46 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EBD9C1A0324
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 13:12:45 +0000 (UTC)
X-FDA: 85001937090.10.B7D67A4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 13CE41A0007
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 13:12:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bt7ePLLY;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784380364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x7rJS01XOrIpoa6iyAGH7gMXTyHGvxg/Dgt1lX1U9tI=;
	b=aUPyY1CADwqakx5tWftEmfjntUheEuNFGVN79xOgLqQXh0eR2ZT5dcwKxFiuyMWGC31tJl
	I37JXAGwQGuex3UllyttZG6WSxASVUAnB9wJKY0CDUIt64yyjab5SSHllpOi8f9wVpJtEd
	+FJ81Xjt3co9/FSvNtRLwGtdREkwmBc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bt7ePLLY;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784380364;
	b=6w/ZHhUOzmRGgkQMgC7kb9CNaSxiiiz//f+CpdnFUGK2Bpb/+fYkvC+FWzmzzdquPF7FgL
	oF4iOmvz2xonkPR4/g++pD6yJvuuSTVyesv02diohxkX8ZtXREH+maoiiuqvPR64BGyXTH
	Q4MIW/O2x+gqfMNEZQryJpCJtysZNa4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BDACF45064
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 13:12:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A537F1F00ADE
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 13:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784380362;
	bh=x7rJS01XOrIpoa6iyAGH7gMXTyHGvxg/Dgt1lX1U9tI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=bt7ePLLYMtPWWgofH4D8wo52ubSiLmaPf7wVZievV8FROxGLzBvyV0XgFlPyWktPF
	 SoDJBdla7XnJSiJ2ixYTQxKi4HxuqzqSWp4oC+uAAfhkS4Guca0BHmGSDl95FKBDNs
	 3CjPXcHhhLrXq9nHUkVPQ/NED8vlVnytAC/FYFyliwneaW1BeDo/Danf7Jb11dDrRS
	 Ef5/+fsAx8ljhgNXza8aWcZDYAbK9PgTIrm8eCpJZ7xQ9DJBOfRMHQ+eWtAv9vmyay
	 oqrFaEVjlyeNgtVqbQrohu2p4pTrwHiWdG6/eIB6m8BT4Xti0jeI8AM9jBA4sAJfrG
	 ApK3lHzXzIgBA==
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-92e53581361so671627185a.1
        for <linux-mm@kvack.org>; Sat, 18 Jul 2026 06:12:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoJpW9KjGjBYkwrOplzIQAEFssytJexxSVXzk087xZJyM2K2rlrZKtYR9oIXvuXnQsTSoc2RGc5Rg==@kvack.org
X-Gm-Message-State: AOJu0YwLuycoof2/+x0F/HChsmkwt/GLuA/Q1CAd6IEiNIKskrnF4SMQ
	qFdXfZXgDE0W9VidH3XmdmKa348iiX0F1GHu7LCiwIIEwCLj8EXa/YBj8D72IA1jofovv/RGTzd
	4BgO8iHWbPKVTZD1yrP5W1o/x9pQs4nE=
X-Received: by 2002:a05:620a:28c7:b0:92e:c116:bf0c with SMTP id
 af79cd13be357-930b4363e0fmr624423585a.85.1784380361851; Sat, 18 Jul 2026
 06:12:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260718095251.82937-1-ridong.chen@linux.dev> <20260718095251.82937-4-ridong.chen@linux.dev>
In-Reply-To: <20260718095251.82937-4-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Sat, 18 Jul 2026 21:12:27 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4ws4mu4Gw9-NWhuXwK_heGfFH_zuuJSPb3Bxm27F5ZuKA@mail.gmail.com>
X-Gm-Features: AUfX_mw8wtGIPA7p--PrOuN-0Gu50WrPojtnhCHjAF-4UOekGFKxwjnN7BHSoOI
Message-ID: <CAGsJ_4ws4mu4Gw9-NWhuXwK_heGfFH_zuuJSPb3Bxm27F5ZuKA@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] mm: vmscan: drop unused gfp_mask parameter from __node_reclaim()
To: Ridong Chen <ridong.chen@linux.dev>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, ljs@kernel.org, 
	kasong@tencent.com, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, hezhongkun.hzk@bytedance.com, muchun.song@linux.dev, 
	dave@stgolabs.net, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 13CE41A0007
X-Stat-Signature: 48rtyxk9qafgmhzy5m7ncnpght5sowa7
X-HE-Tag: 1784380363-532890
X-HE-Meta: U2FsdGVkX1/igb6MWDbgSvq94ut1LSfUnxXzQFRgv++BsYu6aptiv48HElcd6uDJRWK1d2W4wUCdqJ4/AtLyqsnim6c9qBvu30sHHOkfVDmznK2tbTir7i2iuHYl+6vBBlT5IEISa7LQQkl56hTFDdGTk5Z/um82rZMu+KxZcX43TDsNqT92KW1BMzFrBWgi1jDOcclaFlx7GjO3H9zFyK8dmZf64QyJDCrZmG0WKV235CllqT8mL7d0KYI+7xvZhfhspcr68XIyIpp6CpvsR7Mju6NqMTK5CUgZN59CUfWK4P6j814p1biDkKzo1+MbPIzV9z4sGxtwDpbIcjbjISgdJJk052APeJfgxOV7rJS7N2m6gDQC2SdiZcIstcnkRM6Vj0tZbAJgsp95h0b9wa5bmXCoaYvA41aWmr8savdVcZ2Rbu9WbtRmGCfwbUUP2Q2961q+dhDEMc1lm+azT7w4epdRxZajbLZnKlObwkFyzSkcLzR6RElwTJdOFNAvjBQsKxkY+UsC83LV1LrOHUUzDaXp/Y8EOQPoNHoOVzGxgkwZKYIwB9LK248ePzTmhHAJdcE00W2JXCPhUsE7z3Ftr2o3rlNANMx8xKtWp3fW4MgUM+uP28n+7GaYA0d7pV/l1oRV0mtouU72VqyVzHPF+c+O1dNp4+ZSM9C/06iSEMYY7Dcik/64qh3h84GOI2tvhKS8XcxI3eymibwnW6MvjDqPmxnAfLK3NB3qbP0quDSA+TiX5XCsI+WW5I0dQzgH4IzuW+/hNTiZNChOJzIHRdr4zxcWU5n6oZ1Dl/K3TrhCjCLZ6Yr47M4JcNX4kzofw42wLk6aqPpM4pfuXNNB8+wPBk6oaYcCQo4ZUBSQXqrPOJSGfTZBbi69waRUAvpuS9vX1vchmPSKfCGjBtGhlBDXeH8BbzO5srGuxFxkLhi51auJgXtOvbTH6wDrFn7hmwDczvtjMAV1q+A
 RmU/UPfX
 IZfLwXubrb9jzEOgeh4n3wl6zl0Y0WHJL8ZM4PmtcVHxUT6PnstJVvupkkyZfrS3Gj/tkzTejlPicdaTTIA6Bj5Mrmb4fxjyR7+9foLSP9/8suil9abPACXnhxk8b0S8qh6fgYeKRQn2LVYNiSkOzlw/2NXPeunQJDvnbQApIV9pUOOblTKneBY1tNe94/fKpWYYD+DuxNVxLvEHlRc9/iO6//lWTWdrEH/yzAhhKvWqqcORO3RbFY1tvauPZlz/96eNq4MOkX3gzqiMpwMu8BciqpBRsFmYOiZNDtKL3VpBIHZGdiNDLaxXq7YNt9GjetPFnfBGmLjSR0h5gD6ytLA//ZbU7gA5UrUDifCaqzwf0V3IjHcxu7FAZxE3UE9V1/lrs8vXmiGbT4pFzpfjxdB/7IW8ukvFAaxnIpM2Q9QejQR1LwEuxmCvAqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 18, 2026 at 5:54=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> Commit 57972c78e678 ("mm/vmscan: make __node_reclaim() more generic")
> moved the scan_control construction out to the callers and passed the
> struct in by pointer.  After that change every use of the gfp mask inside
> __node_reclaim() goes through sc->gfp_mask, leaving the gfp_mask paramete=
r
> unused. Just remove the dead parameter and update the callers accordingly=
.
> No functional change.
>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>

Reviewed-by: Barry Song <baohua@kernel.org>

