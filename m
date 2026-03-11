Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 049291062896
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 12:55:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F4336B0005; Wed, 11 Mar 2026 08:55:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A1F76B0089; Wed, 11 Mar 2026 08:55:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 183D16B008A; Wed, 11 Mar 2026 08:55:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E734E6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:55:52 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4365A88C9A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:55:52 +0000 (UTC)
X-FDA: 84533779344.21.5C1375B
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8D0DCA0013
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:55:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DyV8DjkL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3VGaxaQoKCDsjZiXmfkphfdlldib.Zljifkru-jjhsXZh.lod@flex--mclapinski.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3VGaxaQoKCDsjZiXmfkphfdlldib.Zljifkru-jjhsXZh.lod@flex--mclapinski.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773233750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2Y9gskyCpeZiaybJRnS79bVzWhSmmn3pZfV0wtEdZDk=;
	b=7GhjZROE5TXa/RratwMWpFfkEYwX5YP2mxm+sEui80cTogMSClkE9jhgGqjILZNWQ4JhUE
	dUWjqT8pA2kuSc92MCcbUEOI8ae7Jekd6Ylw5ZzMmE3jUHgx9R5e+FyxrfavrY8MC6upm5
	YfohGQLKIMdNr9QOOaqR9m9LT6/FOx4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DyV8DjkL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3VGaxaQoKCDsjZiXmfkphfdlldib.Zljifkru-jjhsXZh.lod@flex--mclapinski.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3VGaxaQoKCDsjZiXmfkphfdlldib.Zljifkru-jjhsXZh.lod@flex--mclapinski.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773233750; a=rsa-sha256;
	cv=none;
	b=m25zwNqUeGSDmUikeFquJX9VT3ottOs9yIgQLAfuL3+MkyWMqvxMP06y9a+0voRIvT1EDx
	JUyPJ0FqgZi2kUmMFYzfmgTQDajT/ZJqDF3zA0yjaOcaKhDzGyx8YxE9z1gjJbKO47pld+
	A4DQSUvzLIQA2mqYE+h2A+ZNpxnjtjA=
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b94a1fee936so335242266b.1
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773233749; x=1773838549; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2Y9gskyCpeZiaybJRnS79bVzWhSmmn3pZfV0wtEdZDk=;
        b=DyV8DjkL2u0XU2LEdxBGJztoWTDJ9DHDTudYFlYnLUeAg6Mib+bI1iRQXEDrwyUh0M
         dh85dooBUsC7YTMXUGQ+HIliKbheSAPupI1mG9sc9ZeVmzZFkVH5UNegKs/2u3uDJk7S
         AD+wftuBjyBOzAkKh6BQboLTAUSAqs0VngYbVSap5VxVtJe2UwzLgeZhsbGc7P2Q31jv
         I2XicLF4XykeB3Qon2qIJEFOcg8y5OtF3YPblAPgJ5p7ZVd16JjIlfzvJOAcWaenYGLj
         BKHYBL9IQvxVZ5I6C8fCKZ/b+jF+Odss14a1cijCSH5bnKpq4jdoOvBtqxpaDU6eziGi
         To4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773233749; x=1773838549;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2Y9gskyCpeZiaybJRnS79bVzWhSmmn3pZfV0wtEdZDk=;
        b=iu+d1teiDXDE/Y2+5/R5V7erlFOeeMZlIfz9MBCgJRcBAoo131MspF/2s/mBNRx2Ys
         xddYwA/1JvvI6BRnpdCW2rVz57Axkpvnf98qbKXnqYLME2k4Bwu9TQI2rzVqJHjcYU05
         5ckEAW/GRBUg2P5jWGQfg12fd9RQAbAmLiwl2X7O41aaRo2DeXZldDOwY43/iwNZ9dJz
         UEstcTsPPhTiPrBiQouz5SusH2CzuP37sL7HiBLyjBXewQ7sP+DILYrngBGw2NvNigLC
         FbB4xlrS0+2g7EmlanDEYEYwNl59tR74IlS70SUcmPet8UUkkRFT0YGx34SO9yZ1ybp4
         dNsw==
X-Forwarded-Encrypted: i=1; AJvYcCX+JqaQsmoj2UXa3Si+dijMmLgY+SPxnN+vJnj/vwn9c/DNehp+8/cLR2TpQiR24vlIz9EzoKs3Gg==@kvack.org
X-Gm-Message-State: AOJu0YwmHAzPfh2thl//gPFw3Mgk2dLuRn+uUAf1h6lSRwfguTfezcL9
	XpZZdaMSWvjI+MBlRw/owtGca9Vo1mxtAK2+NUprF93pSS01mT2lKuV+ARfj+ar42LG1CfqeW5b
	qDLAZ3/XtPfiMx/dEWoG5KA==
X-Received: from ejpi2.prod.google.com ([2002:a17:906:4442:b0:b93:57db:4eba])
 (user=mclapinski job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:f495:b0:b93:62dd:a4a4 with SMTP id a640c23a62f3a-b972e6a5b85mr118824966b.51.1773233748733;
 Wed, 11 Mar 2026 05:55:48 -0700 (PDT)
Date: Wed, 11 Mar 2026 13:55:37 +0100
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260311125539.4123672-1-mclapinski@google.com>
Subject: [PATCH v6 0/2] kho: add support for deferred struct page init
From: Michal Clapinski <mclapinski@google.com>
To: Evangelos Petrongonas <epetron@amazon.de>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Michal Clapinski <mclapinski@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8D0DCA0013
X-Stat-Signature: grtzxi1u847z6sxdtbau3y9anzcqrtfp
X-Rspam-User: 
X-HE-Tag: 1773233750-970093
X-HE-Meta: U2FsdGVkX19fUzl9a28Xjb7NtDj2WhkpqS32rZJKjr5Xs9pxKIUnutaP6U144Uf97rUFGUBlEC1Y+NrDWnC4lW0n0MWqNamehYBUK8jnRC92mocISfhzh5brhwZe6jxFeaAKzLMvFzjWi7AZkeQ9Ok/V0dU+qsK40qz2hYvRF7JxQPyufa9Ja7pu9xDe8BQ5vQtWGe1z2244a3SM9mkVzEVHN/XSeSBQ+ip0AMuSyS+IJsg3eN2nYvJ3wiPzVYDnwxpMk7WBiBqQu2XN9l8kSr6yximlbOXXy420IGsXiZtQzgI7KGv1YPZ0lpSmfroUDnbBzVm8HUz2jZfWdY0YoDqxJQDZMZyUn8C9cWqmQp60qp0Y42VCPe4ONDgvs15pYGEMvBbssvD8+yKKxiguNqpnHk8NzG6KNdvv6HrGA3oexfjSLmI8RW//2Md4voKiKUaTTq3kGpZwDad3gisl7IsJMy1hLv6TPEjqjN2tqY5f8daUcYRQJP2EiCDcYm7JNZNCXmZ+zNM3aJn3rz4h+2gNTpzqxnEZpS1kBxnPJbrMlb5e6a9bV8/g2ubDUdvXiJiGON8nwt8PqHXXROg8uA/h4rhMoZsTGeal2Hxr0MHkZ1XLpVS1gWnL0yw6GwzgMEjKe1SWLK6x19bU/DUt5d+GiUQd7u5eZPnt+0Wb9/G5Lxa2oIXYV6KcpBobIO6eNhrjUXBwUWZyQPkPr+r4V8QuTcdZzizSkdjRW06j/xbKbF1JBLx/aiSitu36MrsEl1wRLW+gVbCXuAKwV7HHs7Ues0v935bFrvi6Qa/pTE+eIKXYC0k6c6xINZ6CSMLQXKqGXmuxVwZcaoQIt3gYFQ0GvLB1dXfctpmjEa5as1mKmwjWD14B7Jm473UFVb86oob62dJN7z48tk1YXc1a3l5bYBfLM7nOquD1hB+3/ErvmtLIwYBjJ+ZZh+UMd8DX2CtZovaOEg9VBDCQ2Oi
 4Wj6JNvq
 fi16mMFL/EXbKBPxz4W0DEbHb+CWw47UzLM548crlRbf6uafzXWJDN0/lqYATD8t9FPpAa4V097RjrFVS3MHuDp+/CN/YIvKcMPHFd4Jnby6LztZfdr67lNKfGITJAUWtaRMi2OuQR08QRWjkRm8cpDbCOHvM7mnXojsM7+9qISnpIJ/2rgHKkUmNn4g2b+YTC9IKN+Up+B+bZp9mIQnO+0ZzJD2N6qVAd4wrYxrjpwllvhDWqXadHTeT883QkOFUwo92foYxJKRyobOEQch7YSNcN2PHSlZ6lXKM6iQubaK0C+CMjsyDXysotKz5zVS/8psHizTGGn+0FmbA2u8lP2hBMWxI10t9q0Ky8PQln+opEQM196CWhuK2IFtCt7Ix2V2Xp9+jeYl79SpQRCFdEsjnAtutooSJq9eLj6WBhffARQ7QslwvgDpKOyOxvYkT5kev3VrDqDS7oclTE/0FySgn2CLroahpooqfqS7gh8YRAn6X20eQwX8lR7UncftqGzhDEUfANF04u/eHWHyhZrpQfRGcfkP5E2GqJaxcLEJN1N5vs7l74Uq90T0Lv07eKak+e2afWWTHdSHYpF9Mhmmih6aDcTLe0V4RJfEsFmLP/zUPFv9R/9BBGBdrKEf6Xm8MUBhdDf7lD8k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CONFIG_DEFERRED_STRUCT_PAGE_INIT (hereinafter DEFERRED) is
enabled, struct page initialization is deferred to parallel kthreads
that run later in the boot process.

Currently, KHO is incompatible with DEFERRED.
This series fixes that incompatibility.
---
v6:
- reimplemented the initialization of kho scratch
v5:
- rebased
v4:
- added a new commit to fix deferred init of kho scratch
- switched to ulong when refering to pfn
v3:
- changed commit msg
- don't invoke early_pfn_to_nid if CONFIG_DEFERRED_STRUCT_PAGE_INIT=n
v2:
- updated a comment

I took Evangelos's test code:
https://git.infradead.org/?p=users/vpetrog/linux.git;a=shortlog;h=refs/heads/kho-deferred-struct-page-init
and then modified it to this monster test that does 2 allocations:
at core_initcall (early) and at module_init (late). Then kexec, then
2 more allocations at these points, then restore the original 2, then
kexec, then restore the other 2. Basically I test preservation of early
and late allocation both on cold and on warm boot.
Tested it both with and without DEFERRED.

Evangelos Petrongonas (1):
  kho: make preserved pages compatible with deferred struct page init

Michal Clapinski (1):
  kho: fix deferred init of kho scratch

 include/linux/kexec_handover.h     |  6 +++
 include/linux/memblock.h           |  2 -
 kernel/liveupdate/Kconfig          |  2 -
 kernel/liveupdate/kexec_handover.c | 62 +++++++++++++++++++++++++++++-
 mm/memblock.c                      | 22 -----------
 mm/mm_init.c                       | 17 +++++---
 6 files changed, 78 insertions(+), 33 deletions(-)

-- 
2.53.0.473.g4a7958ca14-goog


