Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF9F3F513ED
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 14:42:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B43FB6B0092; Sat,  7 Mar 2026 09:42:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B059A6B0093; Sat,  7 Mar 2026 09:42:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A08576B0095; Sat,  7 Mar 2026 09:42:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 905FB6B0092
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 09:42:22 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2D0CF1605C2
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 14:42:22 +0000 (UTC)
X-FDA: 84519532524.04.29EF263
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id 453381C0007
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 14:42:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O15b0Fr9;
	spf=pass (imf18.hostedemail.com: domain of qq570070308@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=qq570070308@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772894540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6QA6JTgkCmC8RnKP+cAmYpuoERGcQQmKSYmaGYS81ag=;
	b=yJRJbaPsVRXofiMzBGDHNMkHhUnr3Hx5+tc+A272S1Pq+Hrj24PFaf6rgkvNV5MDMGUuT3
	Dd6aeqV4KLJ5lBp4hyPZZQ0hzvMrbL1yd9RtNCgQJHJFo3ivm5RJ3Jx+GxhkQq6OafAWKa
	VsUPQ6WstDiaPXJqQrc9S5I4S9l2r20=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772894540; a=rsa-sha256;
	cv=none;
	b=O1WuwDg9J0lNuXRScAjxaDgg3rn3Tt/Xrnf+casNa9w5d1yCBRHmXNaBpyNSeh26+8pjF2
	blnSrOZwXi7qLUsjm8yJwQ+0BZLmNhzfpfz7ooZYC844ADrG6gDewfO+d0+5EaNL8xCfY1
	Ql7BBMn7W1xhmrOCoGWtiR/zGEt+QRU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O15b0Fr9;
	spf=pass (imf18.hostedemail.com: domain of qq570070308@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=qq570070308@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-824c9da9928so5855360b3a.3
        for <linux-mm@kvack.org>; Sat, 07 Mar 2026 06:42:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772894539; x=1773499339; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6QA6JTgkCmC8RnKP+cAmYpuoERGcQQmKSYmaGYS81ag=;
        b=O15b0Fr9At8gZGZnK87mJ/uyfz+byKlNhNoCsrj7bhHgHySP70pQNO4BukFj97W31B
         yp7Kap2HImnTKHwpb0rOSRv4UkHio91SQ54kuHYpBAJLZI7WEKkLvdpNTa6VS8zQ7L2w
         o1Nel1ApVZILNK7lwAbC5gzOSuJAPzaomNhcu9PWKiE+08WsvUBj/xFZYKoc6LhuhL9O
         N+zf7jvHoUOtftRa8lCaj9N679PSVrQ4iS7n8kyLXm1npZoAZQkvrXrpC1VTDQ5QdDjX
         LgiynUjoP7ar1e9EfkQQJzdsV6K/HHu6xSh6G81hvZT4eJsAlvLzggUw2AkalothJkn1
         ZqdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772894539; x=1773499339;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6QA6JTgkCmC8RnKP+cAmYpuoERGcQQmKSYmaGYS81ag=;
        b=YsSbm516wPuZyELEbnArwA2ouNRQNXJsBN+D9F9J1Jgy7DvBDjr3icBdaREIfZ4Ci4
         F0TYFUX/reQVAqcaoGgjEHFoUQnFFyXmBM4xSOgtlviBJuAnz2lszRfGVjwdAyoietlY
         DBEat5zmV0u8O0HoYtpKqgKEKJakL6xv87rgBifFOfIBWDX0uC3C2Pci6QEf4l7EFAYx
         8wze+3zWFBiPgdtziFKHNyMSbJzoBE/UrYOqgocSZ5irSqlE5oidZNDxYE8PFrxgdVjx
         Aw1baW6d+JQIbFGO7INgrrsxHT5hRRi9HcGnPfgpUEwnfSwx66Mrg5xlhkHEP5uK1C5o
         +4wg==
X-Forwarded-Encrypted: i=1; AJvYcCUUKgDXJmXtQSG0luBaxKD/HJWM1ncYGcHFthDwV88MDdZAk3Ab3euQOwDl5xMr3PQL2gcRJdQtVA==@kvack.org
X-Gm-Message-State: AOJu0YysC8/7D8xPCODKrGOlcD2WsMIN0KdbpOYtSLGsCzsoBj16Mhnx
	oYCg4jCvWMcVHAoyFU6FRGu4azCeTqTVi8Ea8T5uzhRT1APjJWHIYqC3
X-Gm-Gg: ATEYQzxJQYKI4wpjJQ2e1H60HAUCD3Yteq9Akwh3TxwrrsDlpp1FrN5vYw6IR7P0ZW6
	sj3pjM9X6hkW+BRkHvtLKBRGUqki2B3AWm8IOF+JouMlxRCV6RQJBjitZIJayrNhLCnxoNcPbex
	u22AqO34ea7JoSVFE2YDWwVQaStxAkIuIPG4c+FxMV9C3ypYvZDRfosW51Hs76aaabpwDybvzsj
	0Oezk4zkBx+tlOrGccRH4MUgPhZIBE9KIdMEpkU1fm5y86kNlv5b4rMzYwSHkc5rXqOS7wacGGR
	xT5s6mIzS5ypXIcAxbZnQz+TvcnxZKw+EyC8JYoO65/XC7Lq3JGj6vxNXxQLEgo+oS/looimotR
	MF9oRMA0+YOh30Q0EUEtjdeHGaKaMYY6xzV5FNqWmKDz7/z6NNoIn1zzjhYGXs7LH1Z4OYQbrI6
	gXawMoTnaAarefoGq0T9RIUkVUNIn/AxXb4p2ISMTbywc=
X-Received: by 2002:a05:6a00:1815:b0:821:8492:7f66 with SMTP id d2e1a72fcca58-829a2ded871mr4982644b3a.22.1772894538988;
        Sat, 07 Mar 2026 06:42:18 -0800 (PST)
Received: from DESKTOP-3LEPQG8.localdomain ([119.28.20.50])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829a48b2c41sm4778981b3a.54.2026.03.07.06.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Mar 2026 06:42:18 -0800 (PST)
From: Xie Yuanbin <qq570070308@gmail.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org
Cc: Liam.Howlett@oracle.com,
	david@kernel.org,
	justinstitt@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	llvm@lists.linux.dev,
	mhocko@suse.com,
	morbo@google.com,
	nathan@kernel.org,
	nick.desaulniers+lkml@gmail.com,
	qq570070308@gmail.com,
	surenb@google.com,
	vbabka@kernel.org
Subject: Re: [PATCH] mm: optimize once judgment with clang
Date: Sat,  7 Mar 2026 22:41:35 +0800
Message-ID: <20260307144135.380683-1-qq570070308@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aavd4hoAO1DFLuJP@kernel.org>
References: <aavd4hoAO1DFLuJP@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 453381C0007
X-Stat-Signature: 3ohe71t5enncosp64hichbxdnump9rkt
X-Rspam-User: 
X-HE-Tag: 1772894540-403723
X-HE-Meta: U2FsdGVkX19sRNCy8V6oWsqkdzlFYU/9KvUQQKc/iVYkwaQjezSfosloazwh4/8ELdBDdqqtXkKzbX8ZejrYzSJ1l5bHC381daNBsSXWUPAc6gxgTNeQX8LkLt7kiIVJjHJh3Yn00PhLVFGd6TWbSdlzcDA69WrSfdnWeCxCB08T6lHVT5U2MTe5NP1OXXAWJzqNXiRPWPS233LlhWTqeuArvSi/TfeaAUzrSTK8fOrO8+lgAACvYhUjM3i8B6HpoyX8AJwMscnFnli2f4ju6yVq9KaSfHInWQPTWJLlbVrW8XQkP/A2iEQ80u6byDVZ7Y436842P5qrICnX+mQFFOWR7Qvb605YP0+Duep9zKOmMIoA3zvIa/rTF3Z2ldEAqdvioel+yo6WwagfeucZQwfz5iCtwZD4LK57GDyrFOVwPXw1dP9LyS2X7XgCq5S/WgLjj8PskAGrqiiTmuZiwAI2RW+7tQLPrV4MtzrUOdNdMUryYsUedWiI22t9BYaJ5qgI+z/JO2K0OVC0TG7Rvt8vugyI280tbe9ujFOBX6edcZOPcJGFb4NCc9RDxqZkf1sr+RDkPltCRci11Z0et8wTrxCJC+2yE69r5PurubnuEHSobF0mhqbpvrKOUQ+OsRLJVbBMUsx4eIu1B0eTPyErDIYMfWrHqDA65CfmATSZjMXpsKPlZrErsql4z+23SxyA+jmdNjwXnJs2kh18LEj/1A9J9q7vxy7o1COk2B/MX9jS4CPi5eDnbJfX1eTUcE1LDphR8dikWCq6rNyIOCK4On81jiMqGFZ8UDvdIy6AgJvt0VkFA855HG+H5wP4gMrQ3PPXd+vht7sjGJHHMJZNUEGutfMWeuWYagpiDdgEonih8uurrKC3rQMrvdV3PnsaZpxYmwPsB5i1XbNGYpYmv/hDv1lKVGL1yOrpOfqUeb3hUzBMdPbGu/ESwYNAMW0BCUOyaS55Y7GKW/C
 qYd3zB5k
 BkJJLYIv0xPnMWw6Bv/4iPnjes5oGnCVVgqelqouPIWmy5Ucm6DcmRkobdALRKOVIyU5X0tejPinth3UQQfu3L80n+6tzl/1f/rhsX+4g9+gVTdaY0mCNYzXrKA4vumtGzmHB4E8/Camp+KumbRve9iuEtp7Q9TRT4vckJLWxphGSucJzuijIFoZZx0B1FAl+/3tY5Bn/+RyCOkWNIdGNrtyE5gT4hLvFG7qbKKjkolDIUTjXACo+ipnsk8lnoa3Z3pBZpVlGmxfQMDu4mB57QxExUGfud6ZUFE5KFShnx5AF+vVE8c+1Z2kUkZyUlf0KB0z8RB+K4iY3Cw98TSbl7KiAWMIadwC727Z0cvNowsc14lBOOAk6AiZXYLUc71htZhnENrD0uV3HqpQWmidR5ThvMFw1i/dEpikFpRchLwHDD82ybf8QpuF7nUSVst00boMBurxmGAH+Ta/pnFJVw6KZJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 7 Mar 2026 10:12:18 +0200, Mike Rapoport wrote:
> On Sat, Mar 07, 2026 at 02:54:04PM +0800, Xie Yuanbin wrote:
>> commit 242b872239f6a7deacbc ("include/linux/once_lite.h: fix judgment in
>> WARN_ONCE with clang") helps optimize performance and size under the
>> clang compiler, but the modification is not complete.
>
> How much does it actually optimize for size?

Basing on commit a0ae2a256046c0c5d377 ("Add linux-next specific
files for 20260306"), compiler "Debian clang version 21.1.8 (5)",
arm64 default defconfig, and setting CONFIG_CC_OPTIMIZE_FOR_SIZE=y,
the size result is:
|                                    | size     |
|                                   -|         -|
| Image.gz                           | 14256146 |
| size of ".text" section in vmlinex | 17035264 |

Basing on above, revert the commit 242b872239f6a7deacbc
("include/linux/once_lite.h: fix judgment in WARN_ONCE with clang"),
and build again:
|                                    | size            |
|                                   -|	              -|
| Image.gz                           | 14258152(+2006) |
| size of ".text" section in vmlinex | 17039360(+4096) |

> Note that performance is really not critical here because we are already
> dealing with slow path of debug code.

It seems that WARN_ON_ONCE_GFP() is not affected by in CONFIG_DEBUG_VM,
and it is used in __alloc_frozen_pages_noprof(), which seems to be a hot
path.

