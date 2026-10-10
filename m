Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB0A3CA9EBE
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 11:25:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B7C06B0088; Sat, 10 Oct 2026 07:25:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 368276B008A; Sat, 10 Oct 2026 07:25:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 257486B008C; Sat, 10 Oct 2026 07:25:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DE10D6B0088
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 07:25:53 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6BC9FA0294
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 11:25:52 +0000 (UTC)
X-FDA: 85306486944.28.90E67C3
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf30.hostedemail.com (Postfix) with ESMTP id CC60480005
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 11:25:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=I+ZOUoUb;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791631550;
	b=mmEEv8G756iRAjw0fvMuTOl/XHKe0pzxw+VRPlimZhwIs6X/WHYdJS4kEyAIkwA6xlzr3S
	Fw6N61Ufuu935Ea2hPUqRG/2CP31pEJubpxeS115YJkvGHvBaztgWYIGySRbLb97ZYQkhZ
	pGLI8E9JHSohBNGTk6/e+BiKQraSibA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=I+ZOUoUb;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791631550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=P0oeUsShMWj3bJ1nudJ9ra0uDTnpz7SXDogBWHR7tfw=;
	b=0UWf+8qcqFs/GxxjuHNIBZcayxNmvZdpISiNz/OSflrMPTpBYgF2YnESLqU+LC1lhai41X
	QGAj2DHoRp+NnViV5owCSynsj9WND6+I3StCUGkOt7+6fKm3U+1iVbTJGWOhmi9Y89FzPg
	uGB+GplecmVJFDBLam2+Q99Z69SbRdw=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3ab60ff4273so467664a91.0
        for <linux-mm@kvack.org>; Sat, 10 Oct 2026 04:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1791631548; x=1792236348; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=P0oeUsShMWj3bJ1nudJ9ra0uDTnpz7SXDogBWHR7tfw=;
        b=I+ZOUoUblKPI9M6V5u19d1TEm/MfJgkkzyg7qv6kWSxICVYBw+YDd307cOjfa2nZgv
         WqfbGqTfU5ZIWZB8YJg4yCDYwxjias2LN8XBDDhYuodtc94RuXvNMVK0B1fnfW1Ey0WI
         H7OuOmlWUTQgC6wZsKaiVs3dkkSg7VwWRieaeTWgirMG0JiTrZF5lDhvFib1dtnPyrSK
         jto5RlCv9QQvUu5V2DGWKOL6e8+9C3+Rhms30DxeWz1pAPqfP9qKqJnKsvbK4Abfuca3
         dqOiCKI7pCEb/qNMcTcsytLqG7FUP2lNCzPIzPOBg/jTFYegBx4sPxBxO/xFs1zlbh1t
         DtjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791631548; x=1792236348;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P0oeUsShMWj3bJ1nudJ9ra0uDTnpz7SXDogBWHR7tfw=;
        b=rrgvZvr8IBw63cBD/0IKayccyJjFOs/iRr6TsYHMv3vBTz0zrkmHARDEyPbzteT21T
         al76mdENtzKIrZuZgxAzDF1MTGGFnsDRpzjtkQCYLLMDzUF1NdOv92RNKwGZXhRhrVEB
         2P6uGLLncbVFva/sAi2O6z3WuTCHRv4tX+9Av/OXUlPMRPn/ru25QRWH2QITQ2mNAl2M
         9+TM15CvYsg3GFK9R6080Ib7jWxB5zufjWop2majbX87ahEidwfucR8xzCVzPr+xvSJC
         +t5eKCMj9bX1WowLAG3NSn/otYvh5rkEIAz6PIhSfdDe45jGJHZIf02xLvOZ3qwgY1gF
         Xzmw==
X-Forwarded-Encrypted: i=1; AKwUvBz4461yaOPk0Asi0c5rpLxW8sN9fR7PFxaV7vX3Q7VQ+1eqxGH54LLcSjq7h5yFdhC9QG4y1oOlbg==@kvack.org
X-Gm-Message-State: AFq9FYIY5/sFjczaroxoyOXA3KcP7duW0qpA+jEDJQmk92bWFdOGSjVR
	4OriH42eWS5r8jZak5RUPM2ROfwUSu07v/CoZYBWHEySjd6G9pEhnmv580ztdZP+rVQ=
X-Gm-Gg: AYBFou1X5+cmjeaP2r/amm4Il/MBeNe48Xd9RkTGm59OmAQa6hXVYmsVd/18PCPy95p
	9dUycCCrCGMg58KqJqaNddZVQkwLBWN9Nlbx7f65eLqB8jGzsAekUDL3tvSNKBLXqDIBd+Ka6+W
	SVelm6DYGFj9oDa1o9rxaXPNJEdnQcrEcs6DvrRWW+Y/UF6pzycEnZlllSAdjN83e0Od0+OnDOQ
	8cq5w/5yN11cjgpbBlfVAW+yuqQWtcFkHz876tshhjOm8YBGPuvwIe5hH1pN3Qq8O6Cu9CRbE60
	EvLQwOY2HLLLxwUfqsKE0XiAqO7AwXCkma2dZOilk9Gi/fqrR6lE8uaYGd0wu6PrMw6+z0Sca6h
	/owOEx0GFtqQZBYAy0jXKCUrHjs/LR8SLRk4KfGdsqRyozj1aSX/oxgPJvTkl2CN0o00U/aNqPX
	L1s1IfWsmyGz6eao241HiFN7NJO07Ie21vLFObnTLFcdfJrn0M+/1eFZ9z3eBvqsNFFj4NrTUuw
	AcVk/U0g7yZekkw55KDlzvRZMSaoXYK3IBZvQ==
X-Received: by 2002:a17:90b:3a48:b0:39d:f6a6:60d8 with SMTP id 98e67ed59e1d1-3ab3a33db57mr4120069a91.3.1791631547298;
        Sat, 10 Oct 2026 04:25:47 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([139.177.225.249])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab3690474esm7900233a91.0.2026.10.10.04.25.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 10 Oct 2026 04:25:45 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Dave Hansen <dave.hansen@intel.com>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 0/4] mm: Fix page-table teardown during memory hot-remove
Date: Sat, 10 Oct 2026 19:24:53 +0800
Message-ID: <20261010112457.49485-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yidsw4iycj3ezxinek6b7jhcz69upo6w
X-Rspamd-Queue-Id: CC60480005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791631549-96108
X-HE-Meta: U2FsdGVkX19t/ODWEQPfIlXA2FcVijopAl+JpwToCd/3ZX28EmvEu6ggrOEUOx+gw2cduFoVJnHCLJz53p+STJfmbM+BZ5lr+aOJozAGIZkz0QamPR0zXOlpwUVG8nCywkST6ubOWwGiz5eD9QDI/OHhRT85lYAJCPi9jAUHry7SPdCMf7MLFQjzsLXOJ6IMgLY0d9OehFOh1FANuEFjOUr8vMpzawabQCo8DBfsQxUAqpF9Q7hdzHKimVp+f11qXu1YF9mvxqvladOKogl9MC2vRqemNRxlgf02cW4on/UFWMqzaSGhLTV6JxjcDAipXK4jCh78BmPs+plSElSJhCW3dzV2V8ZWvWLx0lOGv6Ty98ynVwzTcLdWE56qFPg52viaj9ID8/abE0feiqIQqeV7xEALi89h2mzS8vIrQON9M4O3+UU47Q+0aE8qjOKRSY30/q01RXrltuRHuDvO/KQJoimH5QIY8Sn6Y6G/+lCbdGW3bPq/IT7gxZM0NjmL9m7TcgfsVJvY0FT1xqcGwhuHp83Obe4qacSRx5bLledKA9hJEpzH/YOMnNkRqvEMELTBdXfIX1djFxBG9S6M6ku9+HumvEUa9aXF4ioMbmzgt3IB4vy0Zmy/Y1IGDVqQeJCMkquBfgXZ6Q48tOI2tXChxzrHx8AVQ/SNAn/b/SOdW63agP7GwZs5zs0qXn+wscfc1aqJE9b9V4nSffqkGh9CpyAorB1BP1kem14YNv+LyUi3QCMfyivAE04EbA2JNINeWild4rZLGPHwpdPeaLn67Gr2bHD4ggjbD22u4WgCvsuVNz7HdgOlCCtatbfNN0mCSO05LHdByLnhPrgdR+02n8j85fPGS6UVFPzDIwLGqWWYsfBZUE7/8kIaKITsj7m0GTzHrxnxpWKEGO4cTiqmWIXDcSCayf4iKLvPao7cwXitc+cXT9xrwtWhiZrIftDmnthH52zT2EshRRD
 rSOnqnSn
 mECrv6JFWGIsxX8HLepkY55uEnuywZsascqFOljfHAjB7FLsI2Dz88rOUMbEZ4nuNldOYQzNeLbaR0qOTq2uRes5qZ4xtObmZE6HtjMCkERbi4YjwOQTmncL4MdHeQVq7q14VhSEuGgQiuvjMDJoMHAniXpR6spnzhlms99Wah8Jz+1FX2/crwgeFunhLkcpV+rIK6ANQo3FN3+3Z9ogdpqAwr7kpjJvtbSURvCi34yTThm8K+zuPM58BsiIFDrH3FSVPRSJnWGZUDOWNI3F9STYYTwywruynxfp4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Memory hot-remove can free page-table pages allocated through paths with
different constructor state. Some paths run the page-table constructor,
while generic sparse-vmemmap population may not. The x86, RISC-V, and
arm64 teardown paths did not handle that distinction consistently,
leaving constructor/destructor accounting unbalanced.

Make pagetable_free() test PageTable() and run the destructor only when
the constructor initialized the page. The RISC-V and arm64 fixes then
use this common helper for their memory-hot-remove paths.

The architecture fixes depend on the common MM change in patch 1, so
this remains a single series. I expect it to go through the MM tree,
with review or acks from the relevant architecture maintainers.

Changes since v1:
- Move the destructor decision from x86 into pagetable_free(), as
  suggested by David Hildenbrand.
- Use pagetable_free() for non-reserved RISC-V page-table pages and
  simplify reserved-page handling.
- Collect David Hildenbrand's Acked-by on the RISC-V PUD fix.
- Use pagetable_free() for arm64 intermediate page-table pages, as
  suggested by David Hildenbrand.
- Trim and update the commit messages, as requested by Dave Hansen.

Muchun Song (4):
  mm: fix missing page-table destructor in pagetable_free()
  riscv/mm: fix hotplug page-table destructor handling
  riscv/mm: fix missing destructor for hotplug PUD tables
  arm64/mm: fix destructor for unconstructed hotplug page tables

 arch/arm64/mm/mmu.c  |  3 +--
 arch/riscv/mm/init.c | 32 +++++++++++++-------------------
 include/linux/mm.h   | 37 ++++++++++++++++++++-----------------
 3 files changed, 34 insertions(+), 38 deletions(-)


base-commit: 8b38ed9ab5b09c8ba168cbcc49524e9b380ee5c4
-- 
2.54.0


