Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E270CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 09:19:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC6488E0014; Wed,  1 Oct 2025 05:19:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9DF48E0006; Wed,  1 Oct 2025 05:19:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DAE68E0014; Wed,  1 Oct 2025 05:19:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8BCCF8E0006
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 05:19:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 40828448CC
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 09:19:10 +0000 (UTC)
X-FDA: 83948996460.04.EC05B80
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7D3EF14000D
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 09:19:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fiOmAdUp;
	spf=pass (imf23.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759310348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=w2XxZ+xl14l9r3XHZiZ+ypWVAtzLOudFxqCIGOf+QiU=;
	b=x2bgRPgBU6GG+ok9qm8XWgb0IR7hntyp1lYlhVgunLNV/CkQ4KHa0NkRcI8UpJNG/fbckd
	JzUjae0UYCxjBUuT/q31AYQewBw2GaJ3BANv8dPZhuQCzt9nbvSeUFigd221+D3doZ0WO6
	9h0EcLxs2hVKa7ig2gubSi50m1EzAho=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759310348; a=rsa-sha256;
	cv=none;
	b=31I2r8y2tx6FrZ+IEH+hLYmQ4cPIdl/RcKFLIlT8Z9T0OQEQ59IoqTN2IYVz6ApnIvdmnp
	/TW66w0O7Z2JOAInCnoBFEY38b8nScRtO4ElWwUzD1LrHJhutMzatico+yqLXKVXeNtp3D
	hV1M3+djT8BC+PiThWId5gdrKjse92U=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fiOmAdUp;
	spf=pass (imf23.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-afcb7a16441so1130633566b.2
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 02:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759310347; x=1759915147; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w2XxZ+xl14l9r3XHZiZ+ypWVAtzLOudFxqCIGOf+QiU=;
        b=fiOmAdUpHICoIly4t136GC12Nz5FcL9ej6ePaYZGI59IaDwaU2Z6RZ2ylxfS+RKg9x
         2kenQeMPghw4lZEZ0UkGby6hSJgUDraIbFJr/axGxl4kD4M5onEHGVviIAZuGNHUzXVh
         sJ3cjHEELZIeHvCr1fiFUKChRs7O5A3KSZ6kR+yirAM5rmiADBAl16x4dPHlPxMuOvma
         8A+GUXZwGhmE/y+AcL7TVe3cBLtX7Rd/eH8exzVAfbjLuvfXzy3IrZSdMmZkO+AEozkT
         lNTyoX/OABhZXgitVZqO2oPcpN5cc5RwaaDrXFMY5x2vB40jJNL8ysMl1J7g+Q1Gb/wN
         IRIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759310347; x=1759915147;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w2XxZ+xl14l9r3XHZiZ+ypWVAtzLOudFxqCIGOf+QiU=;
        b=upHlYkvK/AmtikOM+diCWL0KJRto2IYAD/OumD4KDcsP032MfEebHn6ipchbCwWX4e
         MZ9XrTShwdTDwZhlnKxQ3eiYAoDEpt++I0hKxibbG8HICkv7sB2HLgnbWValmLE6gaTQ
         xTZmlNrSdXHnhWfP86mhZQRTZJ1bnP0uyO4amigJaOwKzeXnP3Zun5rXPkGLu5F9VQYY
         mWv6VjtzYwmCux03/cNwXqcwgQssEyHzgYWbTDrAw4em0c9xAuKJa9P3Yaw4LjFFq35A
         TQvsFwvaoSwoPcPYpfLKa+/ENe/roQQ1sKr0/aRYnWdIkfqTzxXicOmsti6bMSPM6SfQ
         rS0A==
X-Gm-Message-State: AOJu0Yxfj1BIjFmVtJRMLrI79f31UpNgP3Tm9sa5SZ9PnuRIUuZaOaX5
	K6t838f+rVcrn2GSecpoEPiMr582VA/L2aqJBNTLhhy5aiVkeFGjjGN3
X-Gm-Gg: ASbGncvnjL/AaBRq3FVwLxeB1twxl4iRXD92svmsWD/277wjnRYVyy9DJDGBQg/gkGY
	22qdVgLKD1EPipC612xlicBateqMuVO2pOEkxgKNkRZ7SQXv6XpiMveU5m7fY8wi8KZtajoRQiy
	BhlWDac2v8NC753OMhZM447KHoKMDaoXoYeUE8ywjDXVYyYifOd9zxsaffIYp3QlyFFcV9jRFYt
	yAHpuziuX2t3cHkuEQQlxG2ewey35l1lyspb6Tcn4RWx4vKTtYfJECxMx4p5WjvzU78WP3K6/6y
	cpGk3DHP3AZ+1CVOiPa7/i9bFU0jmzo65CxJ8pcjCtN9p8MST1U03RmsCIWqSIKYPLAyjm6crG/
	bvRh56WvaL2GYuKjkF+hpAa4fOazW81cZ8Rc8OPwaAXQggI3wHw==
X-Google-Smtp-Source: AGHT+IF4xiLr2SE92aAO38iZ8EL1iza+x5xxbePzjC5HFZcqRtCy2godAMFIJxWaumC60Nlmeu1Lug==
X-Received: by 2002:a17:907:3f16:b0:b41:e675:95e3 with SMTP id a640c23a62f3a-b46e1950cb2mr354840266b.16.1759310346909;
        Wed, 01 Oct 2025 02:19:06 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b3d277598bdsm708788066b.3.2025.10.01.02.19.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 01 Oct 2025 02:19:06 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev
Cc: linux-mm@kvack.org,
	kirill@shutemov.name,
	raghavendra.kt@amd.com,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [Patch v2 0/2] mm_slot: following fixup for usage of mm_slot_entry()
Date: Wed,  1 Oct 2025 09:18:58 +0000
Message-Id: <20251001091900.20041-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7D3EF14000D
X-Stat-Signature: s3i6qowgpziymucz5cfer8pnkm7ocmbr
X-Rspam-User: 
X-HE-Tag: 1759310348-87934
X-HE-Meta: U2FsdGVkX19V4SjqYJ21CG8Ty9/KzzPwXNnmAEDVMSTkkiBGRr9V40kcFsvbwUE97QPyjAKQvD+e0O+2ELVEpFZAkeBzXJX6phUDLCOm/mTZ1pLqaWpJgMsknt2ExVhEDNR5nQc0+9xCSw8I5UrhezPeHbgjFsIa3FOWrku2BHNaD5AhCSaARFoX4Y/MR8Y6jYLe2V+x464ZwKYyXgsfmKktiThlDXbZbqhrjSpco+MZq7u2rVYCo+kCajRSdswT85XZ6X64omFWoZM+oSvKozP2sIIAxDiGeRuH/L9M3qwJSCr24eiL/pEcu9mxhEDyIYDC57tlNfEN9I3TrOO18eLNIyg8rkpVERjn1k02iasMub2cqvDYA6Rvn2ePNBRL84qWgdaQUQCvVVwWJ4lI2iyr2VKZ/Ybsv9uBOkljxZ7Nu8OkUKugaTJkhQWHKucg9B7mlZG2zqrUMm8DExnKOed/CbkAd43YwlukcRp1YjxxK2cQonOOqzPqTOXrsw1te5Iha1p8bNBRxKhj7tcq/BIM5m6SHwsNOaL1ugoDHygABFC5+JkHVJDD44yMKqW5g9mO/AoV1e42/lXtLxnhRtnkJtXZugQozoGCfBSUFUR44gkbj5apCyDWx80iGwsKJ6jBcBUFAny0DGfdDlb9GQxAp9t8kSzOgBR2rHzUtTsYcWgO4yejmwqBiiQ877GNZRislNnF1SW6qXIa+SUjX6sfJcLHnSWyYxdlYif1SQrGWeAcHSONtKXam/KwbVpB9co53B+4V/XeoSIFikz1XLyRO2xFdo9vwNFJIDjwmBJs/ELm0XYF1Yr0i7bLDdNRnhEd02UQl8EbHWsIAvRayWsVwuw/8zKhyQpxNWyMWXOL0qEAFLhVKm3s1uH24PZZgym7+Qmo35jMt/GbXb8aY6er4hiUCZKEWIkcnY+4NkynrG4+Sb/DdvU8tH+YxHjgMiWMnnfkMaoUtMbiC6r
 LriGPFDg
 rYV1JbQMSvJbU2vNNLYSGNgD5UVaKpqvsz1/c659ckMQk1fpXRHYelZb6cDM41yHp6nj68b2OYDvjYwByw4H98lrRvqXGDvaGkHZ5wRq/qtB4ikANEQU9KxIFzfCHTBgvxuBKkm1LfRtTRfImbdSDTQK8H+2x4cKwoOS2G/+LPsEqpH3v/BH/XRqupSREY5I/8orFm/0US4dFazvljaMuwSrqGANe3OsIeUTznf9P6AvPAyw4uxIghju2HeqOsl/jGe1BQ6fHAQiUKzXPqfPCeNtzp8ziDSmzmhQmw+nSyJoB9a4forNxngf6h5qttlv3B+JZuVUwoW80YpBiU1Axg9QCzpEnFeQdrap19AaE+SyQE7nPah+I1MeUG5HoJJcaLs6EuvJ7BUeJZIcABp91qtAImZZanpJgr4KUCMET2QWpaxIQBOOYBVpJ9FHuhqw2ocOvBaZVyw3Y7XynreqU1MQCtK5hqLJNHM5jEYZZ7wQRJi1gKq+eC/ClWRPjpncsgcWb1uAsZO7TVMraQLxV5swAgjuuba7Nmu052fwcsBRnM2krJEmy/NI9zAeP8g1K7UNa5BoB9eDNd/8BYf5O2N7/iA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We got some late review commits during review of "mm_slot: fix the usage of
mm_slot_entry()" in [1].

The v2 is merged into mm-stable, here are following fixup based on current
mm-stable with last commit 1367da7eb875 ("mm: swap: check for stable address
space before operating on the VMA").

Since there is no code change from latest review in [1], I preserve the RB and
Ack-by.

[1]: https://lkml.kernel.org/r/20250927004539.19308-1-richard.weiyang@gmail.com

Wei Yang (2):
  mm/ksm: cleanup mm_slot_entry() invocation
  mm/khugepaged: use KMEM_CACHE()

 mm/khugepaged.c |  5 +----
 mm/ksm.c        | 27 ++++++++++++++-------------
 2 files changed, 15 insertions(+), 17 deletions(-)

-- 
2.34.1


