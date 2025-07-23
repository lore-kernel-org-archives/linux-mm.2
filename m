Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C182DC83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 11:31:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21F9D6B00A7; Wed, 23 Jul 2025 07:31:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CF5D8E0008; Wed, 23 Jul 2025 07:31:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BEE36B00A9; Wed, 23 Jul 2025 07:31:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ECA016B00A7
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:30:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3C8D78069B
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 11:30:59 +0000 (UTC)
X-FDA: 83695312638.30.1940496
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5039C80002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 11:30:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OdjM2h0X;
	spf=pass (imf30.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753270257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M9FdRXwfhMMRbD/Zbezab/R43oU6uWy4/YgTXhpJSC8=;
	b=8gUjXVTn8uY4Q2tlVov354ksCSknO/MMsOs9myVM7FFBzhRSq+Baq99fXVVyAbiqpcZT9I
	Fml4jr7zVfw8YNmxCa4Z/gDNnhACvGtCH13UeXOKKS6Rd0YJNhVjirzlKPrp3RKEZ4tEwZ
	+SGBCx6ijsV5A2Zi43ojEBhBYYytNdA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753270257; a=rsa-sha256;
	cv=none;
	b=mDk8AJGNJDqJ1mmerdQ41Wyvj1usFoJJZTbmGc8wJLFa8DiVx0asGTWLnlJeXkcBGeNA20
	hUSZqyAeFhmclRqW7MI93BV/UmdtGMXff+ypDFI6OYpLjz1ARCBu151ugR70Fpn997grjO
	l1MIeRPy3BxoIgKqnZ9j3GSUZAK5CEE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OdjM2h0X;
	spf=pass (imf30.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-234f17910d8so59385295ad.3
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 04:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753270256; x=1753875056; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M9FdRXwfhMMRbD/Zbezab/R43oU6uWy4/YgTXhpJSC8=;
        b=OdjM2h0XbD8rS0AaPa+xuuB5k10s1bTMmTcLb/RPDz7cY/3FbJdLJq/cgWGzcf92Km
         DOqK0W+KdAJDqK7DaedKWZYMtkjHlgRrHsAiEeok0+hN84zlH8zw7NZKpmtDSCgQU6HI
         LCebkSrqw+DQRDBnf2/UUgBBxwX027ctSiqIrYZZfdNijsLEusewhV9oSgOUgTpedwDy
         dFVzJ8bntUxv4mhBWXLCXyAcnnjJDrSuEVdA0oiIFkmPkMISlCXe2hZzFkoyBrOQE4Qo
         jv5km6+GxFPEN3MMZL51hXClQeU4PUrMVpL1Y9VcByaDZgW3VJ6BJFVOUDn9x1rLpi+I
         zGZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753270256; x=1753875056;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M9FdRXwfhMMRbD/Zbezab/R43oU6uWy4/YgTXhpJSC8=;
        b=rdQeJ0yqd2JtyEjvER/t4K1CHeqSayS6V+fu67lgq8DwLXvt1/KxvVquJfoV2m9blA
         o5DZxq629QWIgqlRWJ3qCtKMWv5aTbdYSpQZjEtGuEuyo/z1zMsTqNz5Mx5bw5GoeaEg
         JOmkz9AB+GjA65syYRKdnxOoIH5zGrUrZ0MVZKbC8eyAAZQDk9ZHIMHb+3NOCDukC4tl
         COmuIAyD24iY6HnjSuoGGL1lSsj+YG8ur3qrwq1qo5TogJH32GWUuGJcAFJfoJ2E7G1J
         Enn11V5FVvVO4FTX2ZM1GmTvSehRJWxoxQmo6xtkyAvEuyhe0mNjfDk/klU4P9YzHrj4
         X81g==
X-Forwarded-Encrypted: i=1; AJvYcCVrqcgBt5qCbaqA6ERZeYXzt01S3nN/qJVxWJfjrbluuHjlDHcFw6IUgoaOKz3cB/YYPVIUBR19Hw==@kvack.org
X-Gm-Message-State: AOJu0YzPe/XIN8Hc2hexvfs+ayUgWVLqhFe0bxTQDDA6oNQ7dlj9PI5R
	ZGsqduVxW1hYbxlX9jmj58y1Zh9P9mm+qz9FLTZpQqOBa8tdad8UJz9J
X-Gm-Gg: ASbGncs2cVtnSHgBrznwiOTrEzXhGo7AYz2FuyRcRVDCx6RUNpkJfbqwLwlk/Os7kBU
	uYaXowuFIrOCTOhS7t8zi0MZVKVyKim7qyaxgC8pR+gKYcpa/wd0TUj5/UikM3dLj90GuxNCUYI
	PcEdM9MhLTRwAaaVNDAfBaieatkkEAAhkPyHX+KyNgkPzIzzfIPZmQhy8ZRiVchWUnLFqrNGc2D
	65WwI28qEZRN5Q189wkxZ5cjYWtY0F6wxLw1WU0kRa5y2iCCrvxj6yqmAD7v83awbY2NcOsgpr0
	HkQ5WNevv/xMjgvxFsmv7mXDqv6nEqsKt9vJKzqKqQnLSuf7PzxDWNejQeDRopVwfGVRtndhMS+
	AV9YsCy04SjkR9dst7Y5wSc36/49gd5dpIMpF3FqkuPTwjon8Jb4=
X-Google-Smtp-Source: AGHT+IFm5D42A8rW7gtmyR7fdzi/MOVmHdHVNS5Z+T+85KD48ZLmyVV+6boqMsrgb0UOxUyG/J0QjA==
X-Received: by 2002:a17:902:dcc5:b0:23f:9a4d:2764 with SMTP id d9443c01a7336-23f9a4d28bbmr17820135ad.30.1753270256034;
        Wed, 23 Jul 2025 04:30:56 -0700 (PDT)
Received: from localhost.localdomain ([114.247.113.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23e3b5e2de8sm94712285ad.11.2025.07.23.04.30.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 23 Jul 2025 04:30:55 -0700 (PDT)
From: wang lian <lianux.mm@gmail.com>
To: ziy@nvidia.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	brauner@kernel.org,
	broonie@kernel.org,
	david@redhat.com,
	gkwang@linx-info.com,
	jannh@google.com,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	p1ucky0923@gmail.com,
	ryncsn@gmail.com,
	shuah@kernel.org,
	sj@kernel.org,
	vbabka@suse.cz,
	zijing.zhang@proton.me
Subject: Re: [PATCH v6] selftests/mm: add process_madvise() tests
Date: Wed, 23 Jul 2025 19:30:44 +0800
Message-Id: <20250723113044.40876-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <1C468AC6-C55B-41A3-9335-65B03EF65B83@nvidia.com>
References: <1C468AC6-C55B-41A3-9335-65B03EF65B83@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5039C80002
X-Stat-Signature: 4d5f8m67ypptc7cinbufhb5z848rdkt1
X-Rspam-User: 
X-HE-Tag: 1753270257-328801
X-HE-Meta: U2FsdGVkX1/B8CP00t2sH3QF3sIz7wOhTGAU/baf2lCwkCisT9pafb46i6O9uqKrDSXGZxgVDP/ADCOKqfuIYXdYHQ3i9ryQQ7tDoEAr2WmneM3O3n+0EG/cOYg5+Ito+kjYvEP8CRV/qW7dLJNB9EoskdyyPKAta3l/EG2MCtCLxNd9XrT+7KjP08TlEEDnqIup2GXufpQomvSPmctEr01eowjDCPB4QxjUojoL1i7kr4CYbKXxZivCcBlmumGuQR0ecbEjvhANL1k463d7VtzYyfuC+QR13XNjsicNb3Sn1IWO59VhkoRmot/Ijz+GaqWCUFQvsYLwMDynEMIRewPXXCIjMS7FyuRaQWmcCiwrSN6DxyHFxcNPBpTpm5bIfiD8fYgdCMMXYADyegYoV8xIIG7GBSFwgYxoC3wf2eL7H22smWwfjP5jW60nd5fBruiUv/KC0ARiDOGquUCQq56EtFC86ZXZMtEMsRlzjPmXKWoR1WthuwSO4wo9npB2fqx4dOWCD1+NY8nCNAoofnGzhj9kHgiMI/pOXKbz9B9J8GxgoQyH5AGwzFBcJ2a1aV0tNNA67d/Hxob7QWn1WMPAw+fyaY2VHeWrvtVECVh096hY4kkcgntU0Jf+UcF39LlFlHI2qoCbOiKChPN8Pa2Q1vfaxvF7jP+7tOIst/TIftSlqFVugZp5PHj2ZU0qZLb7/Nuou+OJSoN4slxgAYMu7f2f5hi2uDT8z28B5nYyi1G52qCKC2ZVAEDHgk4GK9gWoKXV2xhQChS+AlhKepE6upr4rnT3gPP6d6fHJkSeJ+ohwTxmqXAOF23x/HcjWpwY9ifXpPUvI5myFkLXEIAsENljFjU54/ocKsWRnuwyS+FRwmGoDZWLAkrxOHmBrfKuMD+yUlCZwY95lMfWE8vJJrfKb9hxCTbpmIVqjDc+3RxbQnOJoCeHCctt1WS07HhapqwGUmnSSYpE3iA
 0DIfOTp1
 C2IbBmdKlK9xDuZGy0xCVNBdaHc67oceHepVJzYLqEv9aRCv0r8iHYKjP7QA87s7CcwoXIz0PquxZtHjum+mb56Z3UzIwmCiGG72/yMtXnKEEeCoFRlJ2gSJR7Nhq865klBIhmSNwbbXgcMVFTVxf0bsQEFZBr73jk9r6eq3zyzGTQ+Y8eLwNguheRiuffQ5+36mGoKOSVBE21EfwtlRnwupF+FxkyU7crOosl+cSK1nu0IFHaqw13hf1T4E2EJrf7BK+99Nhh7vllT/PJphV8GeRW6cWeawlOh5YF8PC05jDS6/i4yo7d3TFkg3SBO+0xFt/mqpbSeNrgjCkmzoAI5PGdVNzWpyCyy7ZTgXkxM+0srfUoO4RVOOTc87jGmh1OSSOkSVb5cqbQjtyI5C0Q7i12Cd/Y2AVjMcs+QrAZlYhydZRuEXW9mbmYHLfhnd6Rrs47SEIS1adkLah63P9GG+m0rz8DnXGIEvWxqRiiDwqSOYTC3/AlqW9D6L6ZkgqD6MohX0KpoZOJ7H0pO4fYaJrKKmhej5+3pXG2xShyLv8X7Y8L9jPUYwrIQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Here an invalid address range is provided, since pid is checked before
> address ranges are checked.

> BTW, the size of iovec array cannot be bigger than IOV_MAX. It might be
> worth testing as well, if you want to.

> With default_huge_page_size() -> read_pmd_pagesize() fix, feel free to
> add:
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Tested-by: Zi Yan <ziy@nvidia.com>

> I am able to compile and run the test on arm64. Thanks.

> Best Regards,
> Yan, Zi


Hi Zi,
Thanks a lot for your review and the valuable feedback! The issues you've pointed out are very helpful.

Regarding the logic where the PID is checked before the address ranges, 
that was an oversight on my part and I will fix it. 
I'll also add the test case for the iovec array size against IOV_MAX as you suggested.

And thank you for adding your Reviewed-by and Tested-by tags when i fix this.

I plan to collect all the review comments, revise the patches, and send out a new version 
with your tags included in the next 2-3 days.

Thanks again!



Best Regards,
Wang Lian

