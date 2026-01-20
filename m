Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE5A9CA5FD1
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 17:55:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 148C96B0476; Tue, 20 Jan 2026 12:55:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 120786B0478; Tue, 20 Jan 2026 12:55:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3A6B6B0479; Tue, 20 Jan 2026 12:55:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E05AA6B0476
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 12:55:02 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9307159D83
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 17:55:02 +0000 (UTC)
X-FDA: 84353093244.01.7D2052E
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf06.hostedemail.com (Postfix) with ESMTP id A916F180007
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 17:55:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=X8w41tvy;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768931700; a=rsa-sha256;
	cv=pass;
	b=VoC3R5NykhuMOrdybJDFOGdWE+4RJWvcKJdtQ1FD9Va72EtlA0RkWe8nia1Qm1MKA9fXrb
	msOQ7xpC3AUgkypB43uUrJaEY1N4U3s6G6a3+MG+554bsMT4YgiTY8y6sNICd2WF6/UcwP
	aAI1IzRZ0C5So5l3aiLZP9AoFzsUHAA=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=X8w41tvy;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768931700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CSI8A4TsHJKLPFzycUoWUfFc682TNPoMjAF0fDDKMCo=;
	b=PKEclTtDREC+kz+PbNmsTsH/hIVCpuP3HZ/3D1epcSlphtlp2AsLxcSrdAqVTp/dgWY6GK
	P6RZH0UkKwE27qEuSI/qBtEavNqDBYB40kk+XU/UcLu+/t1js2dx0eS/7uah//D6a4fTaB
	jNcKcH7rtNjGJhjfeIqSQzqQ+wIILL8=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-47edd9024b1so36746755e9.3
        for <linux-mm@kvack.org>; Tue, 20 Jan 2026 09:55:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768931699; cv=none;
        d=google.com; s=arc-20240605;
        b=AGhgFoaxq/+yKAmBesnJUwJ/aMEZEumkKo3x5hF62Eu/x/q2Lt1/0kCRzhlpUZphn5
         nS4siSGzunx1Fy8+cdKByOaxiw8YTn5jQKB5W5uEYsXP6VvP4RGobgWN1FLnLD+Hz6+i
         GxpUKoWoyrgCwO87qimRlGlVlPvApl4B8o88QqYvItbt5tQMLwHCs0vj/cLreiRqFu4i
         +DQKSCgjSd9Xn1S64/XLNyKdeslkHPY0X+fjKPT9ea2Sniyk5W6++EQVv/4277J31YGH
         KdofmQdvLbFrOHSD0GA/Da8Y9/t1u4kIpEoLACxig1A9UNYuhceCo7RIjEkD+ARdmFz+
         Cv2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CSI8A4TsHJKLPFzycUoWUfFc682TNPoMjAF0fDDKMCo=;
        fh=ftw06nU66Li4fm0Gg3d3S/m5WaBGVa1/0iZLb8Jp8hQ=;
        b=AoMNJBXkMcY5Gq19fGqt6j31elIFdSbMsxFZW1KsMWH1Jz/7COJwcvzljBowCRwWF8
         oRWYUBerYqaQS5MgSa7uqqnh6uwh9QNyO638JkZt+hlUETe3b9mOzYkOHE5q1dd2yzvo
         Onu9Wq/xaCbZXNjpSnMkCuV5RPaDccHFLgnJFIvq97OWYrhZ5//9YQtofjfMe2J4DNjO
         B44MgwxJsVk+saIG/2euLGhoZsdr1xrqnBTvMdoOUNQiC8ua9ZO23QsDJrJ6UChciAM+
         gxpImtTar0DYUTbrevXcJp5tJbkaNQUlsFl6Mbg5NzfJrVLXxWGCoJzFKQ7HXOdjU+X+
         wGFg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768931699; x=1769536499; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CSI8A4TsHJKLPFzycUoWUfFc682TNPoMjAF0fDDKMCo=;
        b=X8w41tvy+85eXMItOwBteM0VW7uAGIjetwMem2Mqrz/MgTjRHmb0MYP6AXsMrJDMap
         rWKf4dCdLEYSYg+ahbKFuDbSyB4/qGOJM8d/yTF82aFlJMAgvC60kHD52V963mlKNB3G
         aFPFfZdOXDznaWhNHTYgnFU/kfdMyRVD2BmtXp0PIZw1fGqI4kwmq57iundtVTHLYk4S
         DIJoe1hphOvqz1rZMNhyHb0raeBH5vk/rWjGZKbhS+PeQBbmq+pKRzW64fV3A+1+YM5g
         r3IiGLi7AEGenD49Ggr8m+fhKReWhqhCsXbShjr4icXiYpxTOR3xd6jdoj3VIyOhZWzA
         UGgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768931699; x=1769536499;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CSI8A4TsHJKLPFzycUoWUfFc682TNPoMjAF0fDDKMCo=;
        b=GB+CHpNWI7/1+KbMHbuc+nc4JysYHPpntG53LJy2H2a0I7x9p5BA8FitOpMX113maX
         Nj56YauNllhnE4J0otSBmNmZ1OQj4wF8XO5+rjL/0Bss8IByGm25Dfvovqp9y5PZYTMv
         kLuCDEtdl22zgmxLz+NjmJagWKXY5TCyQdeDDbEnkIkbPGc9hGfgwYG8tMVEndPkqRVj
         sQ0nesR062E4Fjbal+0KsLV5tw7dUWrUeAUsf1QEEAa5EqrQC7V10J+Ld0JmfwzlucTr
         CffH7avakmWPN+tBSVoJ3hVGkU1GryTAZKW36YEK8THqKwZOObiJTWA8Ik4Cz7r9IXFx
         5Vmw==
X-Forwarded-Encrypted: i=1; AJvYcCWDeyvexSqaJ44c6+QUhGXenkTVqTZixFC0iD3ABgOaWlcleopanG0YSbsJ3tEkQfVjLC+PojF8JA==@kvack.org
X-Gm-Message-State: AOJu0Yx9xnoIhbed47IkoTSPxSRq76jGwbrBI83rKk2VVgC8W17wnYbC
	Ng5xdEiG65zAJtvLEBhuKdyT0DlFc5RoQNAHOPSrEDoPF0ZcgDBawRDko2OCIei7GXn8i4TaSAX
	NmDhvfbKIScB02vuEQMr5DnKVdO6JDbo=
X-Gm-Gg: AZuq6aKm8wJErs/Bni6IUIwasTy6qcjKklPf62TpQBRMuSa3D6t3OOBO3e22K9eYoJF
	uNyXEUKQMDCJQgwwiZEttbXWVImM/AEOXwq9NgSJMhn51mJmK3m8KJcGqQfZH+TFAUjC9OLd9rX
	ynnYxUBkGYBOM2K4PZrWH9VxRd9nGTbh/JutYpswqNIVFgeopwn119uraw3PevzZaC8IZtGi6TT
	X9Pzav9ZSeZZoeTJxyBclzfm1pMY37I2/hXZPSJSU2iCNG6W22QkCQgXvs4F/oIrCIzVsUHD8Sb
	mXBa6rvl4Hktr2pb5Gfqrn2H3nrvPg==
X-Received: by 2002:a05:6000:310d:b0:430:f58d:40e5 with SMTP id
 ffacd0b85a97d-4356a051bbamr17722513f8f.30.1768931698830; Tue, 20 Jan 2026
 09:54:58 -0800 (PST)
MIME-Version: 1.0
References: <cover.1768845098.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1768845098.git.m.wieczorretman@pm.me>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Tue, 20 Jan 2026 18:54:48 +0100
X-Gm-Features: AZwV_QjKpw6bSXc49tC7Ft6D0ET5YLTkUvlrSRTXNNU3JrK5sgQbId38njXfil8
Message-ID: <CA+fCnZf+U3RhmMeGxQ-UypJw2yGd8RJ0gFKrCXsC1eQ5YO-eXw@mail.gmail.com>
Subject: Re: [PATCH v9 00/13] kasan: x86: arm64: KASAN tag-based mode for x86
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: chleroy@kernel.org, surenb@google.com, justinstitt@google.com, 
	nsc@kernel.org, jan.kiszka@siemens.com, trintaeoitogc@gmail.com, 
	dave.hansen@linux.intel.com, ryabinin.a.a@gmail.com, kees@kernel.org, 
	maciej.wieczor-retman@intel.com, urezki@gmail.com, will@kernel.org, 
	nick.desaulniers+lkml@gmail.com, brgerst@gmail.com, ubizjak@gmail.com, 
	rppt@kernel.org, samitolvanen@google.com, thuth@redhat.com, mhocko@suse.com, 
	nathan@kernel.org, osandov@fb.com, thomas.lendacky@amd.com, 
	yeoreum.yun@arm.com, akpm@linux-foundation.org, catalin.marinas@arm.com, 
	morbo@google.com, jackmanb@google.com, mingo@redhat.com, jpoimboe@kernel.org, 
	vbabka@suse.cz, corbet@lwn.net, lorenzo.stoakes@oracle.com, 
	vincenzo.frascino@arm.com, luto@kernel.org, glider@google.com, 
	weixugc@google.com, axelrasmussen@google.com, samuel.holland@sifive.com, 
	kbingham@kernel.org, jeremy.linton@arm.com, kas@kernel.org, tglx@kernel.org, 
	ardb@kernel.org, peterz@infradead.org, hpa@zytor.com, dvyukov@google.com, 
	yuanchu@google.com, leitao@debian.org, david@kernel.org, 
	anshuman.khandual@arm.com, bp@alien8.de, Liam.Howlett@oracle.com, 
	kasan-dev@googlegroups.com, linux-kbuild@vger.kernel.org, x86@kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A916F180007
X-Rspamd-Server: rspam06
X-Stat-Signature: 3erwwaizuqcx6dt1gysg7escfbseafda
X-Rspam-User: 
X-HE-Tag: 1768931700-793064
X-HE-Meta: U2FsdGVkX1+Q1OIxiqjqazDCzO9DmO4mBeX8JeLBvghaWaYfdaqGN+3NYfrG7wg2aTRKsU1JPgcjPsvVBlcl8s22CkXRUdfoPFSLHFHZYgfOROGLxpGhrpmkgREUUmf0qVyLW3EYPIHJMP8vTMkByJPA3wQxD1ozAqPjUtOC0KOPkaRbZdWfqOZt+eC8Rwg+MMAuOJNp55qnGjgEbVAhIrDFbIrJEOEQ26kAuakWaITZu2/BjAeus1H49QLuzdM71E6s+xVRj/3FaVMyMijODq4sOcEz0z4u7yq7G3sHAVHgf9fyvzJJQRJ8uCgq/4aOVNvmumttn0gSxzB3PAZPgJD7UDOwJUN/GxeWpO6szC1SvpWRkP/f6JCjT1KP7912VIj94U6fYg54FMr+DXt8CDtnA6nlc2wNhXpPZdepLBy0O1b5dRQ0WjZuWwitYakIX1JLzKp0Ldrwm0QNHPW9x//KT+PTExriS0x9slx+lYmPPA58bBjr3WsvVn9T53+6HAIXy5/rBFE9DanpVqdqkqrLcdBsDJHZSGesWXSPOnhVD8ll/d19sydhaXSRWJXf3HlfWdrkvTeP16swvOgY/sfNck8QwhDBYKLPcr5n/1lSvNH50K+Y83lc13Q5mDmNm3oVuuwFXsz4c7SzSyPW6pe284la0yXkzbXffO8FUXESmE71qaCykBkXJoh/M7CKdt0MD/Ymp0UyUEfo2vguJvFYdrqn30hoO4bRUlc3kP6M4IFeJTERPCJzrsBCpYLiANIyebE3t6WUP8vC014ed/ofKorX4T2pZwAOuz8j48uyXp0co7vpu3D4X1FgGyMGKwCNcQgZx9EGm80lrxHQ9t7YdxOiTMGlURPWF8q1Ix77qEOKPdUYi/8WXzgp8xIvkIoEekQYa0XRIaa38ZiUB1P0L461Om15zhQ8oYSEqCrNEPebZdzuDbqUv6dKSECyqczZE7VuK9WBuGUn1eB
 brJMFKpp
 3RoKgsN1Sph/BFLLEl9z5F4prgpcbSmW7eajYD0veXAj5li8ocMD0GOP/AyRIf1wW6G296UEf2G6M32f3eY4T9NPCVCFlokigtS1RbPy6YFBq68QQjUGgfpd7UXg35geH75X5EhHAd707oyQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 3:40=E2=80=AFPM Maciej Wieczor-Retman
<m.wieczorretman@pm.me> wrote:
>
> Maciej Wieczor-Retman (11):
>   kasan: Fix inline mode for x86 tag-based mode
>   x86/kasan: Add arch specific kasan functions
>   x86/mm: Reset tag for virtual to physical address conversions
>   mm/execmem: Untag addresses in EXECMEM_ROX related pointer arithmetic
>   x86/mm: Use physical address comparisons in fill_p*d/pte
>   x86/kasan: Initialize KASAN raw shadow memory
>   x86/mm: Reset tags in a canonical address helper call
>   x86/mm: Initialize LAM_SUP
>   x86: Increase minimal SLAB alignment for KASAN
>   x86/kasan: Use a logical bit shift for kasan_mem_to_shadow
>   x86/kasan: Make software tag-based kasan available
>
> Samuel Holland (2):
>   kasan: sw_tags: Use arithmetic shift for shadow computation
>   kasan: arm64: x86: Make special tags arch specific
>
>  Documentation/arch/arm64/kasan-offsets.sh |  8 ++-
>  Documentation/arch/x86/x86_64/mm.rst      | 10 ++-

Still missing Documentation/dev-tools/kasan.rst updates. Feel free to
send as a separate patch to avoid resending the whole series.



>  MAINTAINERS                               |  4 +-
>  arch/arm64/Kconfig                        | 10 +--
>  arch/arm64/include/asm/kasan-tags.h       | 14 ++++
>  arch/arm64/include/asm/kasan.h            |  7 +-
>  arch/arm64/include/asm/memory.h           | 14 +++-
>  arch/arm64/include/asm/uaccess.h          |  1 +
>  arch/arm64/mm/Makefile                    |  2 +
>  arch/arm64/mm/kasan_init.c                |  7 +-
>  arch/arm64/mm/kasan_sw_tags.c             | 35 ++++++++++
>  arch/x86/Kconfig                          |  4 ++
>  arch/x86/boot/compressed/misc.h           |  1 +
>  arch/x86/include/asm/cache.h              |  4 ++
>  arch/x86/include/asm/kasan-tags.h         |  9 +++
>  arch/x86/include/asm/kasan.h              | 79 ++++++++++++++++++++++-
>  arch/x86/include/asm/page.h               |  8 +++
>  arch/x86/include/asm/page_64.h            |  1 +
>  arch/x86/kernel/head_64.S                 |  3 +
>  arch/x86/mm/init.c                        |  3 +
>  arch/x86/mm/init_64.c                     | 11 ++--
>  arch/x86/mm/kasan_init_64.c               | 24 ++++++-
>  arch/x86/mm/maccess.c                     |  2 +-
>  arch/x86/mm/physaddr.c                    |  2 +
>  include/linux/kasan-tags.h                | 21 ++++--
>  include/linux/kasan.h                     | 13 ++--
>  include/linux/mm.h                        |  6 +-
>  include/linux/mmzone.h                    |  2 +-
>  include/linux/page-flags-layout.h         |  9 +--
>  lib/Kconfig.kasan                         |  3 +-
>  mm/execmem.c                              |  9 ++-
>  mm/kasan/kasan.h                          |  7 ++
>  mm/kasan/report.c                         | 15 ++++-
>  mm/vmalloc.c                              |  7 +-
>  scripts/Makefile.kasan                    |  3 +
>  scripts/gdb/linux/kasan.py                |  5 +-
>  scripts/gdb/linux/mm.py                   |  5 +-
>  37 files changed, 312 insertions(+), 56 deletions(-)
>  create mode 100644 arch/arm64/include/asm/kasan-tags.h
>  create mode 100644 arch/arm64/mm/kasan_sw_tags.c
>  create mode 100644 arch/x86/include/asm/kasan-tags.h

