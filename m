Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7EEAFEC0E8
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 17:23:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F41986B0005; Tue, 24 Mar 2026 13:23:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECB076B0089; Tue, 24 Mar 2026 13:23:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D93086B008A; Tue, 24 Mar 2026 13:23:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C12B76B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:23:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8003214032E
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 17:23:38 +0000 (UTC)
X-FDA: 84581628516.16.B80BB57
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf19.hostedemail.com (Postfix) with ESMTP id 69EB21A0007
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 17:23:36 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="cDM/cHwe";
	spf=pass (imf19.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774373016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ADQFV5wS3JCAtbpPelSvRH/EcbFi5KJMA+4XwSLSTOE=;
	b=xmsMaHQVui6QEQlUgLZ1vm0cDjTgUs93erIxKgfIMtZxUwBXGFkTyir8/Pl1UOtcW7BSKm
	/FNIbRVAGmZa58JRHVvQH+LT+q+uJyZ8ps9Dmy1NPEa6ApUEhJIMl2oB/taH/DY32h8I7c
	psMDtm94iRkO8N69zauya8aXyYvo8WM=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="cDM/cHwe";
	spf=pass (imf19.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774373016; a=rsa-sha256;
	cv=pass;
	b=LvHIsy6JgOKnFvS4+hoQpxlv2olngLPle6i0Meiow2TVj0nkJ48+d9PQB9gZ+mRUNbq39D
	L9iqOcpuDVodqS58KCfsAA111V9v9QJtnT6eymBOntkxTSGnDIRBVw9qqjwN4Q3ruuqlKI
	Euqf7t/RzijVKKENOGC4DWDykN7WFnk=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-48540d21f7dso48270525e9.0
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:23:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774373015; cv=none;
        d=google.com; s=arc-20240605;
        b=Dk4byTo2nsHQRAvFIHrDXWtVif+lJVN66qCVLG0iFVSCL7yqKHLpPJJoKufpSinfPB
         YiJgWa/r0QpjuubjN4cm3N5fknJoDBxQYsp4CKXnIh4xeRqaRVhfXldliSxBisOGOdA0
         emo8SxGw3B7rn7X0AX1d2HZNJM/0w0PMc38Us4EEIH/pqi5h68VPOSj8S5kKkKjfLyLe
         z5oj5q57u2DLD480iEhSK0cy4nVSu9AyJ1e0B1oabAvISqM0eBlef8go3pDn2E4qyr+J
         Zw8tL1vzI8Gbp2nOOJaOAdEHgmoNpH3kFN61x/V7oO7PkCMKowh3Lrke+tfFxjHmS6Fn
         poDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ADQFV5wS3JCAtbpPelSvRH/EcbFi5KJMA+4XwSLSTOE=;
        fh=hdwGWKg7kTM15JILprIZvoUWuEAqXIntGPnEToUsVuA=;
        b=G8mYBDI4elBOLo8pFnR8VgubugY6G8rPNbGL7z7bOHLTKvcF5+uO7VNfiWdUARdfb5
         WHKq/frcVD8S3N+J4ybGA4oFYOLgE/POVvKsgHiUeYt/WDLwQ9u6U4/P+qWZ3YVn30nL
         SNzynIJ7fQ4uxiHNzpdIwtyvG7ce1hitvPCX2JqJWxPTBpyDvfcPkjqDypjThHTHHK/F
         LF3RKPEi5QR+T0qrXggTKy6AIVWhaEL/LcZwwY09+AhedQ+W+pNVemALFOAN8MXdTQ2h
         n0LcgZJDojPnobKX4hL6CmyXI/bYBI2+2grExHcq057gx9QcI0ygUh5xxHywZ7oFsLKN
         5htw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774373015; x=1774977815; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ADQFV5wS3JCAtbpPelSvRH/EcbFi5KJMA+4XwSLSTOE=;
        b=cDM/cHwemfd4BvgVGgfXUPK5/fe8gjfHW9HpRji3LczsZSm/hq/ZjoE+hgoPrDSddS
         1uDv5qO8YO/OItuZBtmWsFU20++wD9D021NtIzih0eKyGrd+tL9HdJ53h1bf9qGB5++8
         7UY6JDHgsMhPWaejIvnxGrel71DWKPfSJwHHTEcsBpCTSxBsgLV+mLf4oZG/ZKQAAe8u
         NDPAYeHviEyQxaQa5Ald2ed3aRCWEAFcz1XiWNGW4pfW5mkz09u1+mlFiX0hYJd/Xq0q
         OSSLr9svWYGADxklP6xxjkHuftKLY0PTd8RTvFUdLgm5wfISZpiciwWf3nBAq5wqhe7G
         VKcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774373015; x=1774977815;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ADQFV5wS3JCAtbpPelSvRH/EcbFi5KJMA+4XwSLSTOE=;
        b=OW0xk2Xy/mvuiQGJYfMnTGNUzJkdOHVWjl/VDtkUyeNIyeFVbxLhdITf8yOy/Rfvcq
         mfNrzTvRIsWv5uPPShwysxO/hK8PoowBKJLiSPXfaS7J434claCVqxp2m8aQShAX6Zgc
         xYmrzZ6FEqzeiq9yNrLqpTLhLXB8UJxs2EAbZmQ3UGUNVaqMg13ytxVjA8H2B7lsXJ5L
         YCTjz8hHvXEqcMmulZhbBsiIZYc1yTJQbNlpQao1l4LoRLb1VJNbGT9Ooa9UDVIn5h8l
         Vv9qAQX2lTA9XJq6ezN/iJ07yr0aypCDLMFn7BkKpnPDF7H/bB0tyRd2GibXHSBSQ9hk
         jDCg==
X-Forwarded-Encrypted: i=1; AJvYcCUsuBIRYKORnCy5Um2d/VLCvnPaJqchv1a0rL3zrbULo7RuV92VLnpiHDeYkDjNxFjVm1JOlG5xzg==@kvack.org
X-Gm-Message-State: AOJu0Yw23pdHBmcmmWQvRbvSAvH5dk2z+yDomdqb6EvcnSHzbRClo35D
	+fQXQlbL3bPfdyq9BfkbA4j0nxfDnuCuWri5P+84PhEfQBhxkQ5PtrP9afzPz/32sM0/4Jq2y+B
	72RihTUx+v0WE8TwOaj4dMnbTKn4BaXQ=
X-Gm-Gg: ATEYQzw+f58rv9k0D5KKYbGYi/KhyGdKcGZ4W+KWhf8uMk85fSVRfDxjUbpNKS50WG2
	2mw9qpVpqsp2glu61g/DEtsNBkYHp8Cpn7dsZW/Nbqx0MfCoK1HVRgPvQJb+ZsAiyKtNoSMn6xS
	5KxiD+NQVJ+JHMGOwbw59oBYtZ1wvn0QDHvV20UKTYJy7eyFPCzlQwiRvZ0NPCVjIXVlrVuo/Nh
	0zWJYfLvpx+LYdI5/VaSN2H0YCBFzGPyKDuFn91FcNo6JrW+b0jyHQIZNaACHHdXJqyK153Q5r6
	P44o2CAsWJWLVsxhoJybuTBw1ull74O+iJ4B++hjDtTQ+pD6dtqwoxI=
X-Received: by 2002:a05:6000:4028:b0:43b:436d:781b with SMTP id
 ffacd0b85a97d-43b88a1acdemr451493f8f.40.1774373014027; Tue, 24 Mar 2026
 10:23:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260320192735.748051-1-nphamcs@gmail.com> <20260324131931.4004123-1-safinaskar@gmail.com>
In-Reply-To: <20260324131931.4004123-1-safinaskar@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 24 Mar 2026 13:23:22 -0400
X-Gm-Features: AQROBzC3hVhU93LxfbLzywKCT0KcJoCMPUplZMLmSEgnO1rcgM2PnL8QUVFELHg
Message-ID: <CAKEwX=MgoPmiFdBQXK_4=XuR-8mVpGr+3Ku2MfjPmHCeuUdGJg@mail.gmail.com>
Subject: Re: [PATCH v5 00/21] Virtual Swap Space
To: Askar Safin <safinaskar@gmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, apopple@nvidia.com, 
	axelrasmussen@google.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	bhe@redhat.com, byungchul@sk.com, cgroups@vger.kernel.org, 
	chengming.zhou@linux.dev, chrisl@kernel.org, corbet@lwn.net, david@kernel.org, 
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, 
	jannh@google.com, joshua.hahnjy@gmail.com, kasong@tencent.com, 
	kernel-team@meta.com, lance.yang@linux.dev, lenb@kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, matthew.brost@intel.com, 
	mhocko@suse.com, muchun.song@linux.dev, npache@redhat.com, pavel@kernel.org, 
	peterx@redhat.com, peterz@infradead.org, pfalcato@suse.de, rafael@kernel.org, 
	rakie.kim@sk.com, riel@surriel.com, roman.gushchin@linux.dev, rppt@kernel.org, 
	ryan.roberts@arm.com, shakeel.butt@linux.dev, shikemeng@huaweicloud.com, 
	surenb@google.com, tglx@kernel.org, vbabka@suse.cz, weixugc@google.com, 
	ying.huang@linux.alibaba.com, yosry.ahmed@linux.dev, yuanchu@google.com, 
	zhengqi.arch@bytedance.com, ziy@nvidia.com, Kairui Song <ryncsn@gmail.com>, 
	Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 69EB21A0007
X-Stat-Signature: u97qw643a3spwu4sc3zd7du5dmpwn4yh
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774373016-540537
X-HE-Meta: U2FsdGVkX19+K81K3pN45vhD7ewOjXnZZMQ7scGn41Ekhxk+JEHk5jUX/2zc2e009cY5m70td6IT9jN4tpRTx55WAh9SQzt1Bvx8T+9bXSTQlcpHkRZu0sRB57ijAvcoEDBaNxMBdQ/uk1ImkdcvR6f+byaCmhoTLWSUx89h2Fd5kiLZMl8K0i8P5pJ1Ky8zo2tIu8EKIL4TV6kfawVtgCyeH4XeWWSbo7MDgTcS4B9fL9FQxrBX12gCNHxmPrtnx+t8G83lcgopP1K2INkDsXZKRpuU5/kF0oHbcm15k+SmfBisS125z05nWE+utUyAKLMyjKxaD9mg5Tke1/2h/Ilw4dBGPyx9Ns0NrzRFQWUy3jwDDRDDL+AQ9umVA8jxtOCTQ8gZZUznj+bUagcKo+lmhbUGnSD9OVsgWgb/MqMIzx1eQe7bG0uy6ut1wg8xtlnmAC4Ra5xG6jl0+42n1w/+1fgdxVkLYA6j719p66b+kDrivbWFkgeGI7Y6mus3jFF2nRBcTfYfiN+jk6FcBkA4TbklSFHU4nql/PST2PtdtENpqGYi3emv/yX/23HGaA8neb3s+OOwy8+sxkxQSGRJtU7qO5T5JDvhqOIIxqSQ/3szWywSfnRyj+61qlMwfXvgEC3FSjMBEeVDk71IPcn+KjhvxH517rEQJ214g+CBOLRz8bwV2JOD4RwRndBGiaH3dy05YJoMOlXh/We29EAlUoSn7McYh6BrbfkQtlV9znjjUtWJVrMMfCFRv7tbQqKdowsimMFSKTW/9L4jmD2PbsSOhqKHlqklMLRvyAOSRgRb9R6FakJDC+kYch4p8eKesrVIR7sC/eeeeekFJY4p+84rBbQH2ArtSdGo20PjkfuG6wKtiTk7MTllzrclEYV3VyQvF5mLByhh41fShVWnWqAfC9+BQAfL1AwJJrvjIVVN/fNtERdDmTOuQePAdgSq0TjhDgE754iaND8
 qwCPU670
 FHvasEulGfoaBrE1IMjdA8vrZ1m18pjecriDkEAQfvyzkCIBrryuO+zsSbevd/QiqVJLWGZodVWslrJeg3PtkHEen+yKJ0XYKUeP0+tWdsYIi9RPrkd/Y9AbOVOfrWSRlRIgFozwXhHsyrhLJyEwwIl/XhE1a+tAWOpEbEXLFMbaDdyEyyYRsBifSHMuOvjlIgaX7R2lQpz6F7dnxjc9eeCWnwea0IzM/nl0e2HMA0a9o34eJp65xaGRSeteqRu728Yy0ybjJQ6YXUG7XNdBB0F+Xkve2R4kMu+/Rfxs6z0SKtCPlNmWsXD5jtq0KuZnvC97gT3YtkzpyPjoevsI5H1c5G0zE/+kysySzBqZX1mEupfzLRh0I2eXnvd4rCXFhgz8jI3bHF+EEIzGpBfzsG7NcEt0913R3B4OnepjtFDcvSFwcxJhYYTP3Zrxy1CPR5DXby01cuYlq2ZV7CK7dUy/0wZ8JFxSAnhM/2x1JGlxHEkqrTq1PBvReq7lFUwkTzI5TXjaD5zFxPawuY1I7Ey602saxGdmeVTWUoHZel8E1fHWT6My1pmaG6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 9:19=E2=80=AFAM Askar Safin <safinaskar@gmail.com> =
wrote:
>
> Nhat Pham <nphamcs@gmail.com>:
> > We can even perform compressed writeback
> > (i.e writing these pages without decompressing them) (see [12]).
>
> > [12]: https://lore.kernel.org/linux-mm/ZeZSDLWwDed0CgT3@casper.infradea=
d.org/
>
> This is supported in zram. The support was added here:
> https://lore.kernel.org/all/20251201094754.4149975-1-senozhatsky@chromium=
.org/ .
> It is already in mainline.

I'm aware of that work. It's an improvement, but my understanding is:

1. It only works for zram.

2. We still occupy the full PAGE_SIZE slot.

3. The writeback IO request is still of size PAGE_SIZE.

So we're saving the CPU work for decompression, but not the rest of
the potential benefits of compressed writeback.

For zswap, decoupling zswap and disk swap is a pre-requisite
(otherwise every zswap slot occupy a PAGE_SIZE slot in the swapfile
anyway).

Then, we have two alternatives. Either we implement a small-slot
allocator for swapfile-infra, or we writeback a full backing page for
compressed memory. The second option is a bit more straightforward,
but then we lose relative age of these objects - a backing page might
combine very recent compressed pages and very old compressed pages.

These approaches have different performance tradeoffs and need to be
evaluated. But anyway this is future work.

