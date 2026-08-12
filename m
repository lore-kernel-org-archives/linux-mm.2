Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D585C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 10:40:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B23C16B00CD; Wed, 12 Aug 2026 06:40:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFC296B00CE; Wed, 12 Aug 2026 06:40:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A11D16B00CF; Wed, 12 Aug 2026 06:40:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D82B6B00CD
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:40:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 991AB80148
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:40:01 +0000 (UTC)
X-FDA: 85092272202.10.B7255E8
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id DCB5540003
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:39:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VPTqmjPq;
	spf=pass (imf01.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786531199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=f/zbV338bs86RCvE0uOChgTAyhcecT4O06NPuUtGzAI=;
	b=X88K0RPRWwXBZUXMXkF67HwFL3ZjzleKlso0v4/rVDTmQX19S5kkDKGewvUaBcXMGUu3h8
	fzuSrQoYWcuo0nXPHj51fWz3J6wUlw0IzK/h42RR0kHEz1vyDAqGaWOFrk1QG3/f5tJcYv
	a6I1fiKXjYRrmjFTfY4j2pVXtOH81bs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VPTqmjPq;
	spf=pass (imf01.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786531199;
	b=NzAXKKDwDEdsI+9CEKpYLYyCKBvH/Mpf4SZ+8UiVJbWclob6JLO7d3FRAIwx3VesDZ0prL
	o8fr69awWKjzT3mpYHtTrcwmmrSBmU0r2z6s2ZnXgP8tAu6LSQ/CAU5jViqr18WEP5+5aA
	GG2QPG8zieJVs8u1h8uUAsxawlpHonU=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-c9cf07d2df6so486156a12.2
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 03:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786531199; x=1787135999; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=f/zbV338bs86RCvE0uOChgTAyhcecT4O06NPuUtGzAI=;
        b=VPTqmjPq7V8PgWka1JrGQ6zm4WwQNo7CRt2oO1zhxpYWIOwvFZx+nUN+jMEu+YD1Dk
         oCEdZI9E039pAi2awvWWVmdHL+Tts2xXbhN4z5R2GiJ1Xx6oFI7ScV3aBYsU/qjsMBVF
         7o/zHAL9hpbEZP+AI2WJ33P6ojgi7NfB7BbivmdGcJdvhiFCzMvgQ5jFGfFOEMwTfmMm
         /2XKIFex1FxapQBpzWWYChTDeXqVTlHfEPraff4t5MVMy3wrtxfca2M20aGkp6OCrg0h
         FR667gzDmArs9+QdsPSCbS165597kTIjEBV9CZWPZYBgVJ1EY/ZizkQhPKWy0nmb61Nn
         GJSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786531199; x=1787135999;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f/zbV338bs86RCvE0uOChgTAyhcecT4O06NPuUtGzAI=;
        b=YsaCQORbnpxa2iIwee8mNAYwe28C5cdOI6TzV3WuRrN5ZqB6d/uDyq4tTn1tmLDM2l
         gI0LesoyB/WXjuXfF5JGILXlP5yWwh2RI4bY9Yyj7SsUymT3Jj/EuFys5rwTUd2BOZ4a
         tQ74Hxy4PE+1Ubxh25C6nq1T70GX5iPyWLtANLjozl+wUuWL4fVVBCavZgi/gwQAfK39
         wreOvHZ8u20ja6sRtYQLL/KJiYggmLCP2fc2EdZoRwMk+HWYC1tS8Rk0BpnPYFbdIhlH
         aLt4xXag7rXWd0BQb/CGjyF5wBJyTKEcoAksbaoN6ms/VLwJgLTusaskLuLJqHdfX7ef
         5KcQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq6grQMkY9IkonobTvv0J4aN0iCVTrpPyrMEmBjqtUpkHqhrFW7enDbEQRz2pcynUzl7C0XNklO0Q==@kvack.org
X-Gm-Message-State: AOJu0YyaEiAVttx5jmk+SM1B/dZld0V4b8bY+mtu0eeZWDRllXPQrL6w
	XgG6fcIhbgevXZVSaqW/FUkYAkLZwP9yXOQpYFdEvSr7GTY6xGK4ABzA
X-Gm-Gg: AR+sD11kBHAO8jyx7xtF/nHeui74Um4PrfejL7i1w7MAEhga8ffNcaKrCYf98rtiCka
	XilCXq4SvMJvdQRVMChd07TYbeRLB44GkOdQx1Cg5u1M0WS0o9xthBUhFskomVRiBNW2hHfmJ7X
	bi8sef3gjC1R1e/8FoR8uhlkflBDVe5nSMgL8Ex6AEAcSeIDJs0SCOSCkmMzA09KB/d3vGD5ouC
	8eCGclBqPA0zjoUHodDhP/wDXz9EXRpNWxEOyc7xwH/OXAss/Sg4BYJgjcFflEhEM9iKkggzmxC
	qNrGp4WMHF8574CYeBLzN6LgIfSQUQozatQfN/4DUDblqCrR17AZ594PFAYl5BAO1acyYxm8jN+
	/jm3nfPQ9CYclGSyQnWZFagV/MOpebLkrcQnNfRwySC1wHjnh03+MpK1ylBdfDerTL1jjUd4wiz
	BHJnt3S+NDydf50k5VgA/erV38B2SAqK3SWj4bZcU5IEkudiFQH/G7S+niBZhtUddEyXgEyCOsq
	wp5Vm6oXL9E+O4=
X-Received: by 2002:a05:6a21:9cc8:b0:3c3:875d:704d with SMTP id adf61e73a8af0-3cc3f774c67mr4263074637.25.1786531198591;
        Wed, 12 Aug 2026 03:39:58 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:85a:5c46:85a5:ec7:8aa8:72be])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31cf3d0b432sm9931990eec.8.2026.08.12.03.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 03:39:58 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [PATCH v2 0/3] docs/mm/damon/design: add explanation of nr_snapshots
Date: Wed, 12 Aug 2026 18:39:59 +0800
Message-ID: <20260812104002.15225-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: w1pay55mn1ady5693cf88t8b6hnmn9h3
X-Rspamd-Queue-Id: DCB5540003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786531199-612517
X-HE-Meta: U2FsdGVkX1+w6KRPYffDXa2us+5ovNddcKrX7KZpY3NOUxG9+BUcv8yaaWUCEPELwr6ZXKGwJxjvjmybp5yj2u03zhwWZQ29Y04mUR84k1ttGR3g/Tz/GJQtAVNeth4msLfV9k1GtbeGoVFpuVfVDmX8mwTApk1s14FRwVM4xLcAJWOLBY9rorPVtO3hJ8vUhljqzxUNsH6rouzfOMs+RfFoCYCb8Xd+nFA1y/XUwdeB037/OioDaF4ztL1PSf5wyKW0twchtnDcQtwane3RwWFB61xJyVGi/itCFBexfkyOFyl8IAcpOFg+ltQtuddMg2lgq+9ohCmUYQwukTsN5lK/8klVQkcocicjXhieG7qWwraHj2BnhHSVqeZXLR71tc3g439NWw6/seYxRJ5Ijy7iTDbC/gBe8bEucEwHk0JsS07KMXtRKw4Ko7Bf8+ADF7l/iHuZb9xazR4wcMWauYfoNMFYEU51QsKlRfmY73163+Afw8MHZKG0w6Ti8oXxCG+EHlY5JrD2W0oXUKwouJPbONFeBBX9NuvMkbQkOJdfSEWK+tykBJsmeV//vbLQrAOoQYEG7tYMM1Nk2x90r3Z/gpZGlxpiRbJ0S7Ao4D7rawFFSdhWEr3WkXT4+YHITRC66e6FP+RWWwhDnh/8T5GJB/0NVTcM0YyPIeKX/XO8qbV45oLjhYpNo+3wqkxgRI//rAJVHkSCYFtcyR72oJb8jZd4294K87/mN+TpmC5wZCs+GFDL4a798HYqC5/326TvSoBNo3hNDCW/xWCqHNp34rsUuOnkdEFhou2kB8tOUyPeuTdq3GuomkjT1dfYA7tE1/eUDOge0zYRsjq0RTM1aavtHWil1NHKQGVxv46kW8QpfXtTSW65KeZJaClvKX3l7PxRCbY+4cjez0j1eQ2BffE8nuHmNWbTRkuJTpHgkERr+M5pLa2yKwTasEczZ7rjyYYz4jvmv//gEoi
 Vw1IROwc
 umqsvob9JWGmYmJgC7fZoa+4Ji+vuJlGBMYOgBo/YYGrzA5nrrhNRkqcBdtPsZxoWXBb20+49eKsvaLBrKhIvBWXMOpTU1EYRNJ3D6F9/7VJ892RRvAlA8fnvCGTniKZpdJclskERs8Mcdry/pgG1zlPRUTm5abDwAue7EpGRcOIjg1lc4yKxNwEMZIxl2m3bccGk20ENgrUnL0ryfwwPV78WZPftPxFU7KR2VFbGgjxBTTiBGp+6CRQD7vsJL6UmdnddqejwlyENGFqfEDDiJQvRIglnGMrBSG83BAImPHFxGwM+AM9CqRZ2Lsmuy/fcy6dtB6yiwAVs4wm8emvabslefg9G/hi52DXNWpwa0Yef1kHC/YzIQTfLVpDD5Yv3KfGLKTzEarvD+D9/7XRClnK1CUTpLw0HBnd5BVCDwfelPdKz8ba4+ZVhLkKwu+mUm/ylgxX+f4r0XrmECmao6GLurh9wQ8A4/Ql9m6N7UuVcm1+FY96pBimfAGzCtu2wpA0Wb6tk5BMWx2w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an explanation of nr_snapshots to avoid misunderstandings.

Changes from v1:
- v1: https://lore.kernel.org/damon/20260811101841.804596-1-aethernet65535@gmail.com
- Patch 1 word order adjustment: Repositioned "completely" ("tried to be
  completely applied" -> "completely tried to be applied").
- Patch 2: Use two spaces between sentences.
- Patch 3: Add the "Reviewed-by:" of SJ, because he added this in v1.
- Patch 3: Make some minor modifications, Patch 3 can be applied after
  Patch 2.

Liew Rui Yan (3):
  docs/mm/damon/design: accurate semantics of nr_snapshots
  docs/mm/damon/design: difference between watermarks and nr_snapshots
  docs/mm/damon/design: fix typo of max_nr_snapshots

 Documentation/mm/damon/design.rst | 7 ++++---
 include/linux/damon.h             | 5 +++--
 2 files changed, 7 insertions(+), 5 deletions(-)

-- 
2.55.0


