Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42F32CA0EC0
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 12:27:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D977D8E0035; Mon, 18 Aug 2025 08:27:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6F118E0003; Mon, 18 Aug 2025 08:27:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAC198E0035; Mon, 18 Aug 2025 08:27:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B9F938E0003
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:27:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4783FBBDD8
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:27:43 +0000 (UTC)
X-FDA: 83789804406.07.350245E
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 791A820007
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:27:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DfmB0QKp;
	spf=pass (imf13.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755520061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tLz55VslHZUWc+WNK7/9dQX6EPjwj3Sye3rvttPVWBA=;
	b=KNzDfy7nnXwLJy7+gsrvehKui5yLqsVPe7K8hm2Xcm23kqeM43SYaVPvOLGFNKhgxaY8uG
	Uug5uEORSpClKpkXY8x6xwTGYc6Lyu05svPCA440egfLEth0Py3KntCtdN4AYuHZVx7uMA
	kdv3QMzJs7WMqsbc/lLHtwyIbPCCc0w=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DfmB0QKp;
	spf=pass (imf13.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755520061; a=rsa-sha256;
	cv=none;
	b=vpNPzBtyvHVkwML7ZEu7jEgNvpnl5og1BjMn0iBwcD1kaovq4AcSNidwCkfjpXEZX+UIRP
	j+CEb8D5t7ZccrScxx3Q9bc6i5dJ+nI0kELGFcado2a7Cac5VDYjlp/VYSTfMiJvsew+8b
	w0VPhmgfDx4UrVAyj8nH/2M7LQFEhRQ=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b47174b3429so2571016a12.2
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755520060; x=1756124860; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tLz55VslHZUWc+WNK7/9dQX6EPjwj3Sye3rvttPVWBA=;
        b=DfmB0QKpD0Nz4xtgn9RBoz4Y0O9stzjN3Ks4cibIGfEcGdsCoLeSH0XGAdgwrRpuZ6
         3DOFunvLV7mipCdBvpCzefgukAS2T5dohCMR6kijHXmNuUQP2zzq0buKzn/Y6euffPFA
         nhinYSxAIvTkyAv9C+AXxN2EL0qWI3bCEb8wXJN7kN9Bq4vYWRvJsxckRfi7Tiw+p+6G
         DiZfcPEuwe7FnmQNmW1aOgXMiG7y7M0x9e761nF8sBfY9//0oollKg3htCvhiMmUSTby
         vimfbzEWbc/FdlPGuDP70xpjCOplQCjbhbBAvf6DKrftCAGrWZOhZoVjwyFXQGlX/V24
         WHTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755520060; x=1756124860;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tLz55VslHZUWc+WNK7/9dQX6EPjwj3Sye3rvttPVWBA=;
        b=MeMKSSvY2CxvVYRRBI6k85i9spA5etJ82UkZYWci/UXv+Y+qijz65Mwp7D4IKXVhJy
         OUZJlYRNBKkYy9Kmu+xWHazJNUWtySu9p6GoWsPZu2N3QGa7f3S4Zs5CnPYpnLPR+HL5
         GheuEjjhSWfYxuSrP74K3BU4Rqs/XPGeLwny8u5y3lXpOxNiBc+S0sM99FHJrZAGtkEq
         LYHQ/PcB0kGETDD/DRPhuiBo9DmQfMa9dCazaWcY3CCPNIuZ1ConlCSFXnJWvKyRhe+A
         nShOXHyohRA4+jlgbP7cwk9F1e2sB8g4n+2HaOt9c7D2mvWUr518WQEEQxB0TIeRBmyt
         lQqQ==
X-Forwarded-Encrypted: i=1; AJvYcCXUryqSKUsj7vLZxU3U+cNJENCF/QQ8KrPEsxDp/BYq2myt/LuvYnQahbwnffqe99l8dqjZ3h5Q5g==@kvack.org
X-Gm-Message-State: AOJu0YyDf4+LDL6zNQy5XzQDgnRECUr2ahE3BJQ8Pj1Tr7sv7ls4TNeJ
	trYWIZi91e6av7cLwgVTFFykA7BrMoVaJcOwVlQKEM+nCcVsZX1Og0tgAFX9huy7xbrRxQ==
X-Gm-Gg: ASbGncvpCOh+rzdxT48/VcOZwHhExvEqJdFs5R3z/lppvrOva8+exqGuLTKIq0NFtUW
	ElUvAgt4ENttSS55eyWOMybAnkb2R5FUerGzDfDLzVlw6cRqHvGIfS4yuQBPhHIVMmBHW7AQ7qf
	r5PhotYPF7o7NR/tQzP8/tBNI52a/EVk9+VQBTO/mJ//CRS7srKJ9pq6BkYKEeB6uTaDcrSJ7tC
	pM4Z1YkpIN+bfaIuRrU3bej21R/OJoiY+s/oV8E3hN+pWe4h4pmH7X5ip01xF5GKsaobdhfdiY4
	uWKVMr5Mw5hhlocQZwN3hZPVk4WqXg+V+7PiV7NYECpF2rDHKdQhJfYVRKNeiWmZ1nSJm/UXcEt
	deNusgrrXnHasKHdwhEetoAsqTbAewG/7jkKV0qkfWmiC
X-Google-Smtp-Source: AGHT+IFJoG7GUVCeL6hd8WV+Y7zmj5hS4uZb+5DVZCLwiS19xWtblwl3S9dqyVSmUGAeTUCsZgEg1w==
X-Received: by 2002:a17:902:ebc2:b0:240:10dc:b7c9 with SMTP id d9443c01a7336-24478e0ed44mr102410085ad.9.1755520060020;
        Mon, 18 Aug 2025 05:27:40 -0700 (PDT)
Received: from localhost.localdomain ([2604:a840:3::3008])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2446d57f12esm79236705ad.157.2025.08.18.05.27.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 05:27:39 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: akpm@linux-foundation.org
Cc: mhiramat@kernel.org,
	naveen@kernel.org,
	davem@davemloft.net,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [RFC PATCH 00/13] mm: Introduce Kernel Stack Watch debugging tool
Date: Mon, 18 Aug 2025 20:26:05 +0800
Message-ID: <20250818122720.434981-1-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: boou58dokjc5ygp9m8akdfkhhawndcjh
X-Rspam-User: 
X-Rspamd-Queue-Id: 791A820007
X-Rspamd-Server: rspam01
X-HE-Tag: 1755520061-630335
X-HE-Meta: U2FsdGVkX19BNly+YygR+EjFV/E3xvuL9Em0Dz4TIygkAlHj+v18iW5WwiXCqyNUf2j5gt3l6a1YZQjFzYV6D0F8DzA9yN6HhleUqvellLgSWy9K6bwRmQmbwbDcubw3grLd5OdvRK1CTcy/DV0NyyA2xFHKIvmhorl1wIfED1CqehSBlYk4wecTXnM+0XOXhfpaqz4qYQ87f7SAiJ/h90a4lWfIdAk6ZbtAtZf6EXSeNrgK333weD3Q8jMj0zWj/ug1RUI5uKLAMFOxRqCJq6vHNAUOGG2AgJgt1SGnutImMlffibLOto+4RT+sZnIFcc47os4APBLDxLHq3ADt+qA/mRXbv+CCsLd81hM5koT+5w5CdkF+Ee6tRpdsjz4n1hNGrNi4YrfEdzIH24IF1EBvpdNupstH+crSj/ovI+eKEo7BA719GtnHbrnAjJ83Lma98fSfb9uIHTWsRctWDDimP3fgC5DjOekmi9hi4EaDRJ+NccDtX6KEmCq3DFBsloivverzxq1Ycw0kQlpJdGtjRG6hPyaM8ziNtyL6zrGgKV1ZvtqtlQqiaYCsh6i0qk8UQlu2Bvp93/3RrGSmjVE6dkY04Ai0w/G4ta2L0TMkd/c5tVfTTjTYuQ1x0RJnORfK9OppeUmCoMn9aQeQZ2Jd8dHAzV5pIdD47LqXnajkEORrOKP0nRjokDn7I+vRsQBYAp4jXfNCTx3axdY1BjhxL59WYNTua6GCSk7pcBBu6nDSxtCfLvJ5nMluzvOIPtRN4G8jm2QORqxNNqX9PnCgOTeerm9+vEOBJPLAQYj6wZ/hfSwcA7FOJNrDD76hrEVKSNB2GxYnxBjKaV+RsFy2juVHUDlwQB8D7XFFcChwFqZnHQO6vTI8FuvRPj1dRB7NIHy0kBr9AlAnQ1B+RVE+XMSDQjXZDqLTr7JHk6EXDCCc/200vWZ+zk5C/szqxwW/vBv+hHQtxI5VVpu
 gtnIPrhT
 p59m4H3BEH83dXCvyjniPlwT2GLIBB93CjHNZUJl22wTNspRVonG9CYmTwS7NRhH4qQTEAYjc0gMnK1dQ5naMz1QwTq0oPCbvkqITrwCoIW1Pk+9sP3GPTRuovCmBQ+uaAd973XCrU3IzRKgBJ2j2/HAts4Izbn+JLEG32MIPkLtM5BOxO7Bh+MUEeLsUNwzCq3kZqnYnYxeroljGn4wm+L9vcnUZAqZFmdcxgoCPGBUmg+wnrINk5HI2nBhn5gG1JSy8J9+9KdZMihOZPrDl9Vsjigs3DqfiYHR+5WK8PHWKNdIsba5DFeQ5P9eCDtwBNxWU5rzWb9EUlu/A1lIEEwdWuhiMMAHGeqsc6xktA0lHEvVF8YMvaQag9MBBtRh8XkEI0y6DUj21Pf07UIVdo27l0f8x8ySZVEHd/81Vs1vhl2Z9hpgj3vx+P7Dv48LvQhUc112/9q+wxIU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series introduces Kernel Stack Watch (KSW), a lightweight
debugging tool for detecting kernel stack corruption in real-time.
The motivation comes from cases where corruption happens silently in
one function but only manifests later as a crash in another,
with no direct call trace connection. Such problems are often very
difficult to debug with existing tools.

KSW works by combining hardware breakpoints with kprobes/kretprobes.
It can watch a stack canary or a selected local variable, and detect
the moment the corruption actually occurs. This allows developers to
pinpoint the real source, rather than only observing the final crash.

Key features include:
- Lightweight design with minimal impact on bug reproducibility
- Real-time detection of stack corruption
- Simple configuration through `/proc/kstackwatch`
- Support for recursive functions with configurable nesting depth

To validate the approach, I have also prepared test modules and scripts
that simulate corruption scenarios.

I am sharing this work to seek feedback on the idea and the design.
Any comments or suggestions for improvement are very welcome.

The series is structured as follows:

Jinchao Wang (13):
  mm: Add kstackwatch build infrastructure
  x86/HWBP: Add arch_reinstall_hw_breakpoint() for atomic updates
  mm/kstackwatch: Add module core and configuration interface
  mm/kstackwatch: Add HWBP pre-allocation infrastructure
  mm/kstackwatch: Add atomic HWBP arm/disarm operations
  mm/kstackwatch: Add stack address resolution functions
  mm/kstackwatch: Add kprobe and stack watch control
  mm/kstackwatch: Wire up watch and stack subsystems in module core
  mm/kstackwatch: Add architecture support validation
  mm/kstackwatch: Handle nested function calls
  mm/kstackwatch: Ignore corruption in kretprobe trampolines
  mm/kstackwatch: Add debug and test functions
  mm/kstackwatch: Add a test module and script

 arch/x86/include/asm/hw_breakpoint.h  |   1 +
 arch/x86/kernel/hw_breakpoint.c       |  50 ++++++
 mm/Kconfig.debug                      |  23 +++
 mm/Makefile                           |   1 +
 mm/kstackwatch/Makefile               |  11 ++
 mm/kstackwatch/kernel.c               | 248 ++++++++++++++++++++++++++
 mm/kstackwatch/kstackwatch.h          |  56 ++++++
 mm/kstackwatch/kstackwatch_test.c     | 237 ++++++++++++++++++++++++
 mm/kstackwatch/stack.c                | 222 +++++++++++++++++++++++
 mm/kstackwatch/watch.c                | 240 +++++++++++++++++++++++++
 tools/kstackwatch/kstackwatch_test.sh | 122 +++++++++++++
 11 files changed, 1211 insertions(+)
 create mode 100644 mm/kstackwatch/Makefile
 create mode 100644 mm/kstackwatch/kernel.c
 create mode 100644 mm/kstackwatch/kstackwatch.h
 create mode 100644 mm/kstackwatch/kstackwatch_test.c
 create mode 100644 mm/kstackwatch/stack.c
 create mode 100644 mm/kstackwatch/watch.c
 create mode 100644 tools/kstackwatch/kstackwatch_test.sh

-- 
2.43.0


