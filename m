Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 809FEC5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 16:33:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47AB26B00A1; Mon, 10 Aug 2026 12:33:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42BF86B00A2; Mon, 10 Aug 2026 12:33:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 341536B00A3; Mon, 10 Aug 2026 12:33:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0220F6B00A1
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:33:46 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 80DE6C01EE
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:33:46 +0000 (UTC)
X-FDA: 85085906052.05.61C8D48
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf25.hostedemail.com (Postfix) with ESMTP id 87607A0008
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:33:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dTLSQLYw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786379624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=92IdV19r0TDh/ZZaldtV1bjlAmTbuJX6DPtxnWcUDvU=;
	b=se36myhZeHdEW5Z+fwVmh6+CBve0u9AsofUehAYh+uZGX6UWZYzOYXwAF3FfodTPGqpFSr
	y2LFUBxtrAu0UECsNi9+PzQ7W38tgvug9Of3Q/xPRAmD+MWyUfu1Ed2i7o4Qb1GB/OG45K
	Yp7Yh0kxeeojcDTXe/76kuqIskldjaI=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dTLSQLYw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786379624;
	b=eL7pKg8t5RSCbmXLrFRbnOOsQ82U9zYRSpZC1uFYTtQsVD+1duq1s4bZslFJqocBlpMdA/
	cTd3dYJnM8fEzMO7DsvfH/YcC1TJJlM87tyck8E4Y1NDD3+xIypO9TL/zrL/g6q3OxwSGx
	kgHdCUNd/Agtaue0huy7QTyIkZiUF48=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-476a130c138so1999262f8f.0
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:33:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786379623; cv=none;
        d=google.com; s=arc-20260327;
        b=k+tY4AHYBRFD3xsgq2IAMQfHpSBx8BtO0W6xXeyCea7Ds1Pw235WQTnTNyLJGRxj6M
         BNgUsPF9ceNLC+WG1E3aSfYAqZcK6j/hrQ5aVOO6u5l+qlVGIcYpfQh2RHcj552Ca7c6
         5+tJydj5IjcJUNlZp1+p7M7RMXinnIrFcAMQb8BuZRsd+jIegv36fX7fcwbsELj06kYC
         xJmZUu5iPWtswGiBcS4zIARiWI+d1z3MnHkdxbyrJEkQ9dkcSGWdSO+dwoLopNsQptXq
         q1EAs2hoI94Gc4CGXZ80CAyZgGGXBsyHYEKjg3PNPxOL0KdqzMCFHO5MeSK9ogjvQtMP
         7/oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=92IdV19r0TDh/ZZaldtV1bjlAmTbuJX6DPtxnWcUDvU=;
        fh=AHSOw34A7xORqQM7YQjEJaWEZst+ReC1HUa2d7ReRBU=;
        b=LBXyQAJlJcrRj4ZQeKgp891+3dP07h/T/9KUwPZ+qnsftRS6rEDq+A4EBTutD3ps43
         aNKUHRVV/Ugwru9tqikX/3+36vdRhoIvT2heh+NAqIg/g/6JNa05bj8NJnVsOBzY9yuo
         VLHQostHZ7eZrrh72qywc1PaG5hazRwIha8D2dG+A6c9FymFxKe2rUhEjcfPpJML72Gs
         HcKm3Xfv2bYJTz7kkusHFOvDQ7B3K7x34wz86kP9cWoKsyVzvXD7vRnPKCJ6M5YdGp8Z
         f1OJtz9917SwFYW4e4X3J3EDDBpPneBsr1GEyHBoOTujoI4ef5kdX58fNv2N+xoflyTF
         +xHg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786379623; x=1786984423; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=92IdV19r0TDh/ZZaldtV1bjlAmTbuJX6DPtxnWcUDvU=;
        b=dTLSQLYwtvQZeG6kuwQ7+uqw90aSK55nxioG2Zfzm/I12lc/TVCFmfCMlpH9E+zt1x
         e4ztvFCceztpMq4SL4BNauiV5vxwnT7cAywicb+PLhA0tqnKB3UIoUqq8AabuaFcib7P
         H3pOaLO7meEu4vGDGP9ehXtm7HdU5wWgANU19+LqZwEHOL075/6qRsx7zPFhqog0tka/
         0TFPo5oXpIkdVcSV/GdcUcGerQJOvWtd/XghbY8/hsZj8nj3Goo2KzyNOYHH+p0Qle8D
         OORu+cQV0mwXcQF1Ze4K0msr5iRaH3wWagrkXji0zbHianJm7jQh5LK+/PnkPVLxDr5D
         jskA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786379623; x=1786984423;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=92IdV19r0TDh/ZZaldtV1bjlAmTbuJX6DPtxnWcUDvU=;
        b=cjiO98LucnCooRSnBY5O7Ig9RUIrAjc6ZwrTQY+vINVDx/RPlTrDFTHoIhbib32VpU
         4nM9jAyXV1+0W6tamKFKOhiM4hB3bqQmFItwJNQESOiNBaNM3sA5TyZa4PhNC2Q4LJAl
         DbucykrdEf7WgwUmxkuJN3/1wyDKfXQ5YkRPdfzKMTAnSdHLPmyAQpxoixCb6cuARKcJ
         i4HXDG46gkAvXEVZ7SUepptRFchP/pJi+6nug2z5gGkdyg2KBX6r8pfQv3CxTZraN/Hm
         xliz9AQFJ/NykPfAhVW3BkyfxBZu/YZKsQduh6U7IWCN2JYAW0DUoKB3IYPiHu1iwldR
         2AAw==
X-Forwarded-Encrypted: i=1; AHgh+RqstAZJIQaW6aeJLDUDbYxvAN+s4BLYdLClqQYdfEKmAW9JDh3ZHwwE7H67sCPv+Qz1U95QyjsoQQ==@kvack.org
X-Gm-Message-State: AOJu0YwxHVozSnaZIAr41ok7CZvdOs0jnWmYkNSGKGqBuBUyVbCBl1B1
	4XdBWclefudMfIPk8KSvSvvlq5lmUQFQVmCAyfBxmaT/VUe+83w6qJGfUYJRucGwGsWOIp9MZK9
	3KKpb4i58vat1YGyse/dO4I56wfPFCpk=
X-Gm-Gg: AR+sD10NLbjCO6GOhOCsZ/cc2fIfHmPVCoxT8Ko9Y/LeAzx3AqyGobe47tzLqlkeJLv
	qxtDARg3KM4urYTx6E/R3df9XMp4FW0YqwORirgucH6/q1EUAJEML1SmhBhLM8SNzRH5Ygwkb/R
	OuLFTcK0+grtvSH2QYMXKZa7SEAvmWbUqJQHtlQFcX59QwK8qJ/LlcNqNlLQwZdu4uqGoETCLzw
	W4/QJ7D1TbZwyvlYS9O9jlHtZLH0eutiYQiyFE8Za+CUYD9RsCn43XVnQmr4bTPQHqklAMrmGcA
	4eO9IlVT34mTnyqAYjERYHm5BcgHHuUrxc0P8lHGmQcomOpzgbI4VTqfbxe+OTgl6qntZvOPQfi
	+CTZtuTNRWV8/
X-Received: by 2002:a05:6000:c50:b0:47f:7c50:2222 with SMTP id
 ffacd0b85a97d-47ffd967728mr37586913f8f.24.1786379622849; Mon, 10 Aug 2026
 09:33:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260806184254.3790858-1-nphamcs@gmail.com> <6a756c71.01d0871a.3a0d52.003a.GAE@google.com>
 <CACePvbVKpkyV7KpUoiYPTUN0MgEcRUzZL71qTL5ePyjHTA3Kbg@mail.gmail.com>
In-Reply-To: <CACePvbVKpkyV7KpUoiYPTUN0MgEcRUzZL71qTL5ePyjHTA3Kbg@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 10 Aug 2026 09:33:31 -0700
X-Gm-Features: AUfX_mzZKBGWa5jQHBx4faGYg8WQuFE8t_gvjrXgkg0wPeZavX_nvUNwRzCJVmE
Message-ID: <CAKEwX=M=08W43G3dSjRh1p7Z0QFSDQZWuNWguon1yETvxW+89A@mail.gmail.com>
Subject: Re: [syzbot ci] Re: Virtual Swap Space (Swap Table Edition)
To: Chris Li <chrisl@kernel.org>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	baoquan.he@linux.dev, cgroups@vger.kernel.org, chengming.zhou@linux.dev, 
	corbet@lwn.net, david@kernel.org, gourry@gourry.net, hannes@cmpxchg.org, 
	haowenchao22@gmail.com, kasong@tencent.com, kernel-team@meta.com, 
	liam@infradead.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, mhocko@kernel.org, muchun.song@linux.dev, 
	qi.zheng@linux.dev, riel@surriel.com, roman.gushchin@linux.dev, 
	rppt@kernel.org, shakeel.butt@linux.dev, shikemeng@huaweicloud.com, 
	surenb@google.com, vbabka@kernel.org, weixugc@google.com, yosry@kernel.org, 
	youngjun.park@lge.com, yuanchu@google.com, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: adf5wr97pfoc5akadj5zpns6yepfjrue
X-Rspamd-Queue-Id: 87607A0008
X-HE-Tag: 1786379624-149702
X-HE-Meta: U2FsdGVkX1+63wl9uLHmv0kw8eprl14AKjkYhFKdeqOCVtyG54pVZDbv0i5P1zzEAXObBQt3pIVXcwx3Ww/Iz6gEvmuP8YUwLAXYmtDu69dZCW9R0hbNpadrXA+m+MdrIJ9rs+QPW9XdHvYpTH9L7I/gIJdf7ypG7zKWB1aELWu3HVVJ1KKSSmFYuxsO813STnIOd8fUyOPuSWs2LWT0imhy7+BqrX5d9IzFfXkgx6IU2DWeV5dpFeksSI4w7DkVpQRqvVnQiyki+WkofS8AHf0kmmoKXTTjnfivICbUbKdgng732G717oVUrzalKFKdfEG90BkKTPWK2Mp24ux+mz/NvJ4+I7egG5uDi1c8pf5O0mEdlx/fxUAaQrnrEz/6npmgq7saC39S4kLkpj7X5/xnIj9kCDWIe77wGr7PSxcJSfolYTJYFpv+p8/QOeFyndNuFcQnZfIpRsX+1DbC0WPqTpQ5Lxkl7/emz0BjT3kryKC8E8xFK8bPbKMpzcduQFRYcWKtTwm2h1q2wYU1GvEgZbbfWiaQmKMSE35WXFD0Gy/iqsgO65mQGkyL2XzPxdZUsUoY6wnE2qjNA7x6WSGGTSkyAME0uV1ES9nPEHYME7io1q0xA2+XGEgomXRSnM6t0O42D4kqA4DHBf8jXMg4C2tZlCbvUgCLFcrIA4fX3qaSKQ6s3JjDE0gInOtO4jzBqza6IG8euv+LZL8q76KqYxqdxHPeSqe9ts23JWBt+OQRqzxQxjwx26DPCHZE5fD23bDq0hu/BVscg0/TmA7adufJ69ujgRGtjOsf+bczBy38n1UsDFxeImY7srMTHsA9VRR/YX+C5k8BWLf2HdpChMMdCSZeJu9/xKPDUAGlwUcn1WBPFBFih73FQJVHljynI/q2CXPkQXibZY42wln3nkKM57sOfvCJTTk5cEMUZCJzEmD4tXlToxvENKOZ+n+G0NXpapzPOy4qZ9g
 X6NhhUcy
 0SoUZIVJrZ26R4QFOh2FA917PLy/um5CB1q1864kz3oMof9OKbrRDQh+A46srDdCN8Qx4y8P32UE0IVPk+ys5J1ItKMEjew9efoFyghUXfWovCxFkZLrrSrokhmbNU7PS4NPyeQGUutzdP5Zbltzt+3kJew+IuF5nBd5t3rVHBy+PREnv/kWyPCGPkCibt1b+IKt6EVPyLYBR/Qh5o6HcJPD1RMlsXgHiQ5/6VV+46LAPD9K1Tl0WvBKzjdveedfpltSIQJQ2dN+LU6BxfxEUDnXOz2A47UXHQwTfYysnj6VsfjEw6W+2B7JOufrN7U4lMdkaIam0zxKtjdR1sSB/a0WhXVIL5SSKoP/lCtR3T+YJLhFgm0TApeJ9cNxKCcfAAANwi8SWdUpiQrVEr2qSd2gdviLLOAYxWoDKZLhBt15+IJiojr6PZf8jKdGia6qbA0/zbYn1l/wt/leDVo7w6m/EkK8yidTZV2ETqHEnNgYc2sQZteBaA4DIomuXQ0UOmPBOn1q2+Hq7tPcGzLijTO2QvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 7, 2026 at 12:21=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote:
>
> Hi Nhat,
>
> On Thu, Aug 6, 2026 at 10:26=E2=80=AFPM syzbot ci
> <syzbot+cif942a042aaa8793c@syzkaller.appspotmail.com> wrote:
> >
> > syzbot ci has tested the following series
> >
> > [v3] Virtual Swap Space (Swap Table Edition)
> > https://lore.kernel.org/all/20260806184254.3790858-1-nphamcs@gmail.com
> > * [PATCH v3 01/11] mm, swap: add virtual swap device infrastructure
> > * [PATCH v3 02/11] mm, swap: support zswap and zeroswap as vswap backen=
ds
> > * [PATCH v3 03/11] mm, swap: prepare the swap IO path for vswap
> > * [PATCH v3 04/11] mm, swap: support physical swap as a vswap backend
> > * [PATCH v3 05/11] mm, swap: enable THP swapin for vswap entries
> > * [PATCH v3 06/11] mm, swap: write back vswap zswap entries to physical=
 swap
> > * [PATCH v3 07/11] mm, swap: reclaim physical slots backing cache-only =
vswap entries
> > * [PATCH v3 08/11] mm, swap: only charge physical swap entries
> > * [PATCH v3 09/11] mm, swap: add debugfs counters for vswap
> > * [PATCH v3 10/11] mm, swap: defer memcg_table allocation for physical =
swap clusters
> > * [PATCH v3 11/11] mm, swap: widen swap_info_struct max/pages to unsign=
ed long
> >
> > and found the following issue:
> > KASAN: null-ptr-deref Read in swap_entry_backend_has_flag
> >
> > Full report is available here:
> > https://ci.syzbot.org/series/e7da1097-3230-4e50-80cb-1dfafeebea40
>
> Please take a look at the syzbot report and let us know what you think.
>
> Chris
>

Oh it's a real bug. Not too hard to fix though.

Basically, before adding the folio to the swap cache, all bets are
off. If you don't lock the PTE ("and pte mapped but not yet locked"),
the swap entry can even go away under you. With the old code and no
indirection, it's fine - we pin the swap device, and we only need that
swap device's property here (for the sync IO dispatch). With vswap
though, you need to also check vswap's entry backend device. I need to
add proper rcu/null check here in the case the vswap entry (and its
cluster) goes away.

Ironically, I think I got this correct in the pre-swap-table version
:) I was way, way overly defensive over there (I think I add one extra
pin for the vswap entry, and then pin the backend device to just for
good measures, which is not really necessary).

