Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D6E8CD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:02:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C90C46B00CD; Fri, 29 May 2026 11:02:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C67926B00CF; Fri, 29 May 2026 11:02:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A92E26B00D0; Fri, 29 May 2026 11:02:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 90B586B00CD
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:02:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2A0B21201D1
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:02:36 +0000 (UTC)
X-FDA: 84820773912.15.26C3DC9
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2FB64160019
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:02:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AFDLEzhA;
	spf=pass (imf08.hostedemail.com: domain of 3iKoZaggKCJs5M86+BDOBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--ardb.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3iKoZaggKCJs5M86+BDOBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780066954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1EyPAfNS2y6WG0YPoe21sR6PBixrZIgpxdj99NPdSN8=;
	b=TM2s+mjLu25Lp+JQwgYHjc+OBQHrrHeN60Cf4j17rXBWREckX77I6Wl3oe8n3ngg1wYGQX
	+/eKqm6iQk8IJexisvP22XACNqCQrOrf04/V8WPQQwtCwE+vXeKFZaDCLpPQ+ku0APVQHC
	fexWTkPvQw4fiBWvRbetHy9L+PeQwNo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AFDLEzhA;
	spf=pass (imf08.hostedemail.com: domain of 3iKoZaggKCJs5M86+BDOBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--ardb.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3iKoZaggKCJs5M86+BDOBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780066954; a=rsa-sha256;
	cv=none;
	b=p4Q3f7pTE4E6RGD5Mi4h9/kLMDMN6Slxuc+HFfMYSByf6dRQQvdtm11XV9L5C5ThH1sCn+
	p+qzHx7GI2ufuttjjbJWzi/UFqkGJqnJL7P1XUfSLRQUGw2BOTnD3WqY8CpMRZpBIT5bu8
	a0QE3fcxngjHBd8Ex6y9rw6VML5yc60=
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-68b6f4f3c06so1652963a12.0
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780066952; x=1780671752; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1EyPAfNS2y6WG0YPoe21sR6PBixrZIgpxdj99NPdSN8=;
        b=AFDLEzhAYD+RkCgMo+IHPjGXxN3VWj4BbLVbyqLTvAU5TvoBdx4L+DWNtFLySaN1yd
         CDBPPupmwfNCDSgdVilzyBBU1wMb6W0i9XkLtLY8Rxhym8mPWeZLAGKkr7cgWjEbsIIq
         us6ctFZQPf6sssubF3d0o/HzpStj5tYgx43/zoRGGkMuvsCzwIPug9Isxwr1mNEZ9adI
         lhl4EwKP4P3CT2pc1C/RN8CEjNg13xl+L8hzHVndesWo6nuaTiVjNhjHlyWgG/Yc3FfC
         ab1G6TIUQORvWF3noT5nLjWYgAFz2MulbLp72DWTxx+Vj7uCUgLRaTeQvgVxrLsiJjhj
         Yayg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780066952; x=1780671752;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1EyPAfNS2y6WG0YPoe21sR6PBixrZIgpxdj99NPdSN8=;
        b=Xx2zv1EtPRyLIDnbUU12zFjwgaU+suqcAXblFNtE4YESsPN0QvNLqaNbRO1mhQG52a
         QpeELlENjVq2cx21WS6cAPLuImlrMmI2yQ9KMWKnnxPGGusk+Gu/Rqa5zKXvWIOnFIVd
         amPtmIUSOamYTodkxJitB39KyOJX0z83KssVEVVLvG0ltljiAbFcWg1dGo6DFHtyWl9x
         Cy/t/qmFe5XHzBxHihdGE1NENGP3BAaOQ+ZVrpDKDPPd4vjTien+SnK8n3NtW3iIzbMI
         Yc5MZfq0BwhLmZkf2dBqgjsPsIn9wOQKp9d9lZ5wEROb5yEj4h2Pd098GndKlq3d8yEf
         km4A==
X-Forwarded-Encrypted: i=1; AFNElJ9ExR/voAeJOnEBa5yhwWeWUOFF/wULhb4+vMKpD71jJqFSxwHwrbKCNmhOLOog9QOSuIGIGbu2wQ==@kvack.org
X-Gm-Message-State: AOJu0YxM9FQ4xtmRe/NQVsNGBafmz5P//OHnx9dLd++lx3EbaE/1WRFv
	ixz9PgDGkJHpP4DDZnDWY+rqaX9um6aFhdIeCIBum2LsL2qc5FsYOcQTe60IrkOOm3sOrR+TTQ=
	=
X-Received: from edpg3.prod.google.com ([2002:aa7:d1c3:0:b0:68b:f715:5345])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:a29b:10b0:683:be46:c20c
 with SMTP id 4fb4d7f45d1cf-68c8a65763dmr15813a12.16.1780066952419; Fri, 29
 May 2026 08:02:32 -0700 (PDT)
Date: Fri, 29 May 2026 17:02:03 +0200
In-Reply-To: <20260529150150.1670604-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260529150150.1670604-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1322; i=ardb@kernel.org;
 h=from:subject; bh=4saoJOhT3cEc7dpWXJZksxFCf7gWJDz5CDZcsy0RHE0=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIUtyVe4Vpn2a3EuL7z5c9yPshq/FTf8NSmKzXz68s33ZB
 ld1mYh7HaUsDGJcDLJiiiwCs/++23l6olSt8yxZmDmsTCBDGLg4BWAibDIM/2u5Yv7kFfP5v2Ww
 OfqOx3NBpOKey7t5vhR6LI5Y9SY78z3D/5SO1Jh354yPPvIQfsjEWFAfIL3vxawn2VI8ya8XJ21 dxwwA
X-Mailer: git-send-email 2.54.0.823.g6e5bcc1fc9-goog
Message-ID: <20260529150150.1670604-29-ardb+git@google.com>
Subject: [PATCH v7 12/15] sh: Drop cache flush of the zero page at boot
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>, 
	Liz Prucka <lizprucka@google.com>, Seth Jenkins <sethjenkins@google.com>, 
	Kees Cook <kees@kernel.org>, Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-sh@vger.kernel.org, Yoshinori Sato <ysato@users.sourceforge.jp>, 
	Rich Felker <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
	Geert Uytterhoeven <geert+renesas@glider.be>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 77j558i45bfhuzse94yqd585fj5xb7to
X-Rspamd-Queue-Id: 2FB64160019
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780066953-34939
X-HE-Meta: U2FsdGVkX18+W+wMcQYwmMv2hta/nTkq5xMdXEWn5OT5sxMPOXXQ5RCzKL9UZiGOlNSd6w2LqvLmIDwXtzYvLYhZK2TsGNeRNU3pODhKcTZT8vyfesbq4D6OdpJF/CIS9HorrgjmIh4Js6lHQ6BoPaU5mxLyoPnwb3e0LJA935DryZjJ+Wc5Ev5zvjH6dszCXGVH53BShPoBXZ4iGjzEyTUU7UgUViPLOfxMy4498ZPUZmPTBYU6J9x66qL1y3b92Y48puNgh5eJ4zsfBr8f01t/ZKTCYJ6m8eMHS+9+mI8v2WdyEa4rD+BqDaq79RFkrIBrAbPS8BwHM7RaT9D3Ppr/HVARJVRnFE0mb6ioTc6YB06NuIh7j7tmP6RhJqJum0RrRpFy5gNm9KHPhI+VuwnvQgRR426sl2iODeAyVOsUpMC+cK5e9VC9fSkLE13XjD94Dw4StB6hjsbw0rUbFYbFaXQMvJKPv1dxETjFxJm+8tPYeJWIBuSl87oP+7AJACIejxNgHHYtRYx5e56J7qxYQbkW/mDy90W3rwChUMSkD2kvUlMbihdG3u0bNYywwU5iCjfWQN6Zn5sqkdTkf/PVdkrhTxo70Ea6zqKQByyiAEAJegSuFsY3g12nOgXdY7BuO6qvjQP2WQyUsD2+kLMiNfPjqnsO1ALGpu86wfUtiht0L451bT8k86s1V1ebVT2NQTL64CyH8o/dvlPx33VpNwgbIX7h95YxZvuerA1ek4sFv2Glu5OdO2BSa3F9W6RUcdi1NZq9vdD5DQeZ1wJU3V/Tbe/0vVXpuEv3AwyK4zi2JrrFDt5zuCZi9COcZ9xYgo9sjJQrKUxy+UkwlITEO60235SL/stoT519zU4VKrXgk2DJ8PFnFfCcF8H93knoU1qzWxJwe9WbbOSsxC63KOykxDRcFOSMIq304RsV70YmDb+HspM0qixaTwh0TmeYa5/Kto2Ri7v6T82
 WJ1GbQb+
 arxD4YDJLoYlF1fBP0eAXbtlUjxoQUFoCmdIK2yK9Copamrjh5JgbuVSyYkuSslk9kkS60bJLJ6HU+VygZ1HozLND765zgc8+VL8/fK3hhDdttSGyFPa7pa/DiMeSgdp9/3lro237o9vRGW2r53R2rntLoKpd8x6SRg5K3UIzIg1FvetWxBjDIpkg/Cf7fl6p1y+aZsd0aMoMAgJPiDLzs1og6FxRM74NrTI6WZUAd47rRkF5N7QuBfdZL996EfsHqdxIrx6ZtHI2cehP/gW6K+7V1QNLbO6RM9SWnvBZ9lHtdkeJZkWhSXCcNDhA+by1xx6TK74BfNaSmVv+qXNrHn3CrUzF9qOTEwMWiVj9A/rcJeWUZJSiJulrp5UaywPjXmbTBK/jlN/Q9nUbOvL+Ji3aXOLwN4JfsJjBVZ1SKDFWu6Sc20Rz+rdCFA292zHchehIltYct8DiOwvxLnoUgDz32omav3MOPyNoKXyznB5PzKrvGGsW0RXIJUB9wDnjx4JfJQdEzfq3QXeho6/iwWLH48HvVM1gnLuV0dyq2eCQ5e4goJPUZj1aFfbFKdGStBzF31U1QX0+MMRHNg1Vj6uOsTDaPBpg6SpCv7pzN+ifKf1AZaCu1dhimT/CU1SbZRPuO+GtoCXB2NS2AdPlSXOx29WeehSldXgJgZe6TWuyaHBoGonDVxYDEmeJxJhXPk/zjveAzN1Llfj48PF/7ajalw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

SuperH performs cache maintenance on the zero page during boot,
presumably because before commit

  6215d9f4470f ("arch, mm: consolidate empty_zero_page")

the zero page did double duty as a boot params region, and was cleared
separately, as it was not part of BSS. The memset() in question was
dropped by that commit, but the __flush_wback_region() call remained.

As empty_zero_page[] has been moved to BSS, it can be treated as any
other BSS memory, and so the cache flush can be dropped.

Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/sh/mm/init.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
index 4e40d5e96be9..110308bdef01 100644
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -331,9 +331,6 @@ void __init mem_init(void)
 	/* Set this up early, so we can take care of the zero page */
 	cpu_cache_init();
 
-	/* clear the zero-page */
-	__flush_wback_region(empty_zero_page, PAGE_SIZE);
-
 	vsyscall_init();
 
 	pr_info("virtual kernel memory layout:\n"
-- 
2.54.0.823.g6e5bcc1fc9-goog


