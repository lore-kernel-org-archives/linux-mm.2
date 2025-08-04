Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A21CEC87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 19:18:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 171B76B00A0; Mon,  4 Aug 2025 15:18:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 149C76B00A1; Mon,  4 Aug 2025 15:18:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 011B66B00A3; Mon,  4 Aug 2025 15:18:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E3BFF6B00A0
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:18:29 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 47E6EBBC72
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 19:18:29 +0000 (UTC)
X-FDA: 83740036338.20.ABB39F6
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf14.hostedemail.com (Postfix) with ESMTP id 38A68100009
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 19:18:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=liw3hWy8;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of jannh@google.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754335107; a=rsa-sha256;
	cv=none;
	b=abECOahnXkKAWLr5Gv6ZrdysPpYxBiTdgCIMbTDN3Sn/e4EJegc3eA75/iECCrE3rH85NI
	YJw3ln5pbNG1kf5R2yoep380YgVKPf0Y03AuS5UiDJvJvm0Tt7UWzrsUuzp1p3u2LyFtU0
	DLWYHq46nxhfBe3DY0kQteKK6srRdQM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=liw3hWy8;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of jannh@google.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754335107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=w6vpa7s/m259CJfR4wWBW3OSc7Z5L+y7nCDofPdwxAY=;
	b=dgnAt6RhFFVG+YDzYOknD6+whM2m49D5vFTchPovL7f+U1U8cNb0QUTQpFpuzrWcEXtIJj
	o7As98gtqU72kzIAOrRKRCoCGENpcg2VOxcgCTJGoL/R/VlA70JqiSq80sh0Wtz52hvQSc
	A1o2WwkXAXOUhMrCcvI2o0SWrtBluw8=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-459d5ab32d1so19935e9.0
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 12:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754335105; x=1754939905; darn=kvack.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=w6vpa7s/m259CJfR4wWBW3OSc7Z5L+y7nCDofPdwxAY=;
        b=liw3hWy8yZlKgVMpmoY9KBaJ6FGERyCySZdorGIDi62jXV0d0ia0e+zmAaAm8D5k60
         QtbqHqlGKil0+xhpPXq3PYeCAjLeEtkVpkGlyumegakSnY1yq38PFQdJRaGFUuf5k+lc
         gZ2afgaCIFoumSWjvaaRqShOsdWjPeOdvR9AFDQ2yDOW0k4T5nU+d+hmccF6jt1lf/Bb
         4NddiecefTTfLWIDtPny0SMdVDcae91FiVcC/MagzeqO99cyjlEl1iC8kqlgMuCI0cfA
         rfVVH/7aU4VhIWjVYGBS9xqWasOex7wMzkPX8RF4xLFMGCQCo2BVdfLZIkua7U+akaRJ
         o+qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754335105; x=1754939905;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w6vpa7s/m259CJfR4wWBW3OSc7Z5L+y7nCDofPdwxAY=;
        b=jqGhx5DBsCJSCCXDuZLa8FdnvrQs1/CZ7c5VSp2WTzbVXhQWsh2J4u1lfl5w/p8rzg
         LD2cm5LRLiKhPi1ULQiC1b9lTQKm1bi0cfLlABjmbSGwbm/2iem1gs8nR3Yp74vWI81s
         WPiT6X+DKkOKCZwqzhQGyQSf2o+xNBpgRtjET03RPaPO3UZFAvw5b5KXvV/PPFTKNF8G
         1dRgplLWYjg/WRge/fL+7XuDODEg6cyK/mN7DQqPMItthdD5UroIzNhNK/uFOgcoMaFr
         dwlTb4Ikkt+0AKCTts8k5n4OTyYO0A5KhOWju64Smx9JK8gg79yFAYn6K5wZZASOF7vc
         qIjA==
X-Forwarded-Encrypted: i=1; AJvYcCUNcSCi7A2kRuAyrfgJ5EOhXc9ke9+ylkE1ApEv/Zc1M1XSOo+iCahqzJ563eP6B2EEq7IXYsRzKw==@kvack.org
X-Gm-Message-State: AOJu0Yw6Y307mu4MtxQtdpqjCDu3VtxpkJRsdhumUmPDmpQjqN7t7cVd
	z2mGiG0D0WmYvuXyr71jxeaxoQxwdrxt9iQ7l/CyG+pZYeRJcbzNcJerSJoiWYpVSw==
X-Gm-Gg: ASbGncvnnoVw2abl2qn5EXI4wTRJeU1M1ri0K/lxuYoifhcUQTtC7/NnyBUCM75swRF
	9/rNpfAdKDHIOApqs8y5WSYBRS4rWolGms43/p7jULGitVGsCntVxOUqqzZcH9OYU8jXD0K/esC
	54Q6FJEuh720N7FU/YkUc4057Uy4WzgVtJzzmV40/zxbiXaB5S+m0CLdSNS9y+Qe2qhnDiIWZW/
	ltfYKp3oGw/J44k2rIHOxg634hF98nmGkKtHGvFx5mPYOf021yYpF7gAADywTIRGyj5+WSvQ9M6
	RB5spYutwpXNMQe0xhIPvY76fw7n7HONU6v4PfXWXyzx3ARgL3nq0UfbuIlM1JdYRMyS8JQwpYK
	Ikor4GGz1m+1yOfsc652H
X-Google-Smtp-Source: AGHT+IG9kpreVaJ7962+Z3V1su1UugHjsZ0L5Ol1JEUBzQW8+RVOF8+eegVPMtxYkffRMj+hDWF34A==
X-Received: by 2002:a05:600c:8710:b0:453:5ffb:e007 with SMTP id 5b1f17b1804b1-459e13d17b5mr185195e9.4.1754335105309;
        Mon, 04 Aug 2025 12:18:25 -0700 (PDT)
Received: from localhost ([2a00:79e0:9d:4:2069:2f99:1a0c:3fdd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b79c3abed3sm16384379f8f.10.2025.08.04.12.18.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 12:18:24 -0700 (PDT)
From: Jann Horn <jannh@google.com>
Subject: [PATCH early RFC 0/4] running KASAN off of KCSAN's TSAN hooks
Date: Mon, 04 Aug 2025 21:17:04 +0200
Message-Id: <20250804-kasan-via-kcsan-v1-0-823a6d5b5f84@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADEHkWgC/x2MQQqAIBAAvyJ7TjBBiq5BD+gaHbbcaiksFKSI/
 p51mznM3BDIMwWoxA2eIgfeXZI8EzAu6GaSbJODVtqoQpdyxYBORka5jh+RQauM0WSHAVJ1eJr
 4/I8dEPrtEm1TQ/88L4RYtiRsAAAA
X-Change-ID: 20250728-kasan-via-kcsan-e5ad0552edbb
To: Masahiro Yamada <masahiroy@kernel.org>, 
 Nathan Chancellor <nathan@kernel.org>, 
 Nicolas Schier <nicolas.schier@linux.dev>, 
 Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
 Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Marco Elver <elver@google.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kasan-dev@googlegroups.com, linux-mm@kvack.org, 
 Jann Horn <jannh@google.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1754335100; l=2607;
 i=jannh@google.com; s=20240730; h=from:subject:message-id;
 bh=PWEz9+NA3TL9Bqy+uoJY56JiWsNlBHfsy/4lEOXISf8=;
 b=nXtIxc/y9azUYFN45trrZkS2dtWwbDHscpVL5UvAgY+drSEtVoEfY3ljQ8HRkVq9Vawlwh1zo
 kPjnIzFnO5ADoel+f8BEEVlhBhu4mzDuxjpd3cFHJlcMHb3iIXrNMZ/
X-Developer-Key: i=jannh@google.com; a=ed25519;
 pk=AljNtGOzXeF6khBXDJVVvwSEkVDGnnZZYqfWhP1V+C8=
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 38A68100009
X-Stat-Signature: rtapkcnhghgzsx4jr59a8hrafhjj1k14
X-HE-Tag: 1754335106-78128
X-HE-Meta: U2FsdGVkX195R9x2kYznkAdzg2IBotdUJSL1OWfnLuv4nYzGs8Br4KMqlXvi4d98wwXP0kcEeh3JzuU7jc9Tp/YadhZtToh9TlZqb5gaaicTPbKntqlT9PMBgscu+3584tKcht4am4GFU3W5GxZwQuK+XzXxzHcjUE2Z0pkjnzZaTSL2Egb1SBxg8QeeDOWlpwLqU9EXOR5ezK2++7b5joYQd2DiGNiBzeZ6HAcc7psiXj3D57gsrDCnbgoc1+pDoZB+S16n5LyKxWf7wJ3cKw6vOcLEQz1H8UVDX8vIMocq7Mo31dII4k7SmidGUVb89NBv17NgHOh/Wlg/wicDTLBc4B2Znq4Qpx5iCE3jSJgPXsfz16BE8E4s4nFrGTs8v0CLFz58oUCbxPG/Mmzq/g9CD3iVtCf8oTNFqGXoaGgpy4UyvXxeTYIGFxgJ1W4o1Oq9Uu9HgPqT9BtoPsL4miF7JOTh7QsPb9gGSpKRDQ0HrQCSNDnFYW76NmrlEhXIEHSjC08Noxn4esV+dr+pfp4uo606Jm20Ooyual+NuWs3ZSovapU2Y4XBJc4UeCMZdXwb2fgBTia9MIJoZ0DdBBfvcaR8QvTs8UML45XuBgCH7CAgd7RN0N4XEz8m3mCAGaxgo07sKHK3PA3KCldtSQIUnrgyyI/THhHybJipPF8T58ogeONLKYURwSA/kyN9PSOGB7TVFYy7BGGIWxj2gaPCq4y6rCoakQjHX9xRnS3AhPN686ZqpVAQHliD1ZofCv0EJS8IpyMidJdILev5QgwnZPiEBBvjkuqS7UdKYdxL4S+85VL4XWILkEh9Pl7IiNaYH8tYKESjB1opugK4OAaDF0SppeQ7lNFS5kdf714s4rTMBNeAU+5Qz7qm5SuYsUVeB1tTvtXYEZUmyvo1Bs0Knbfk4MqXcPF1jqA1ZA3KZd0k8R3qRWDevw5lU87QEtbCOjTRzVvLCbv4KRE
 B0oHM6Q9
 z82h1TF+OfSQmo6uR8TRccTvLuvHjq3xeJevPOAQDvzZEtCGDWu7mNBms8ZhgkzEnkBtJtaO/zCZT2Ro6TDK2bcEvhApIqU7UyW465ocSGS/ffHiBWGskcIqpKb5NdsFFNXzcuRvSySOLvJzsBr1izJrYPyTa53kfuORslFzBCqAiMhc6m36biVnOFqMN45yT3BIrHBkOMUxshkIzUT8cwFMU+N2xViqj/ifqe1VJZ6mrI5QDZLoAbBfhajDdLO6P1iTbR5mrk67OEH8UyZ0tpZ3lw6sU+9fsi91XRb3WtkkRSc4J0ledotDH5nLFu8Wottua1XETBJZ4tgmmZGFBT/SYvpsALOFUHDGWuFrl3FHGyMEThOjh7T5URlY7jIJ9fPOI82U6IiAIhxvkdy1+6df6dA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an experimental series for running KASAN off of KCSAN's TSAN
hooks, to allow the two modes to coexist.

The first two patches are cleanups that I think are worth landing
independently of the rest of the series.

Patch 3 implements running KASAN off of KCSAN hooks; patch 4 is a little
tweak to KCSAN's integration with SLUB.

To be transparent: This is part of a larger project I'm tinkering on; I
figured I'd send this part early since it could reasonably be useful as
a standalone feature, but my real usecase involves plumbing the data
from KCSAN further into other stuff like KCOV, and my code for that
is still very much work in progress.
If you think this feature isn't worth merging by itself, I think that'd
also be reasonable; in that case I would appreciate a very short reply
on whether this is something you'd consider merging as part of a larger
feature, or if you strongly dislike what I'm doing here.

The reason why I decided to go with running KASAN off KCSAN
instrumentation, not the other way around, is that TSAN hooks provide
more information about memory ordering properties than ASAN hooks do.

An alternate approach might be to merge ASAN and TSAN in the compiler
into one combined memory access instrumentation feature; but I don't
think my weird usecase warrants significant compiler changes at this
point.

I have checked that the KASAN unit tests (other than the ones I
explicitly disabled in my patch, and also excluding the two that are
currently failing in mainline) pass with CONFIG_KASAN_KCSAN.

The current version of this series applies on top of Linux 6.16.

Signed-off-by: Jann Horn <jannh@google.com>
---
Jann Horn (4):
      kbuild: kasan,kcsan: refactor out enablement check
      kbuild: kasan: refactor open coded cflags for kasan test
      kasan: add support for running via KCSAN hooks
      mm/slub: Defer KCSAN hook on free to KASAN if available

 include/linux/kasan.h   | 14 ++++++++++++++
 kernel/kcsan/core.c     | 13 +++++++++++++
 lib/Kconfig.kasan       | 17 +++++++++++++++++
 lib/Kconfig.kcsan       |  2 +-
 mm/kasan/Makefile       | 12 ++----------
 mm/kasan/common.c       |  5 +++++
 mm/kasan/kasan.h        | 11 -----------
 mm/kasan/kasan_test_c.c |  4 ++++
 mm/kasan/shadow.c       |  3 ++-
 mm/slub.c               |  9 +++++++--
 scripts/Makefile.lib    | 20 +++++++++++---------
 11 files changed, 76 insertions(+), 34 deletions(-)
---
base-commit: 038d61fd642278bab63ee8ef722c50d10ab01e8f
change-id: 20250728-kasan-via-kcsan-e5ad0552edbb

-- 
Jann Horn <jannh@google.com>


