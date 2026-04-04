Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 658DAE88D87
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 07:17:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 498716B0005; Sat,  4 Apr 2026 03:17:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 449046B0089; Sat,  4 Apr 2026 03:17:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 337776B008A; Sat,  4 Apr 2026 03:17:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 22C3B6B0005
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 03:17:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 740DCC1EDD
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 07:17:38 +0000 (UTC)
X-FDA: 84620018196.12.940C560
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id C681BC0004
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 07:17:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=QqU1bXRO;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775287056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vxHSxQTiSROLSCEz/HR/Hur/9my7UlNa+rqcrvgfgaw=;
	b=55ErvkJONt5eGyQEHglPiYClae9mRkeWYkXaI8+n0JLjf0WyMgEayy8fRxwD/thLDkyT7e
	bHalikX9aBzK4IznwHmLj9x07kOOQ9sauB1YOjby9K+cV1X3E58gK16uQyf6uyJ5aYA0aq
	ZUTfxkMJvK+2egJi9e6GWIfCTkJhFhA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775287056; a=rsa-sha256;
	cv=none;
	b=TrTYaHiGLFt4TRZpnJ9/vCpeBoBdfmMplW5KeRsENzJT8RBGjFuB061nJz93EA1tUWimg7
	eQ3sdLun8neNYfEsOo4DiA4zkhUKaofG0dG1NMxyoJY9T529K80d9FKpeXLGGZsvFgPw+1
	+mPKNoheCXFCyMFQOnqkHzU4SGzDIPI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=QqU1bXRO;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2ad9f316d68so10337175ad.2
        for <linux-mm@kvack.org>; Sat, 04 Apr 2026 00:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775287054; x=1775891854; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vxHSxQTiSROLSCEz/HR/Hur/9my7UlNa+rqcrvgfgaw=;
        b=QqU1bXROeccnav8okm7ZNxmP5UTZySEGcbeOaL5l/xpVkvmF104sr7ZnXTXFx7vbdT
         Qy7fJeXl6V8puf1S2Me3nr6O5qKtHnK6FuoRFna1CkVMpzbQk2nTIWdm3BSIX0dw9vL3
         jmcdB749rtWbK4c1TCJuVIG9I7qYD/aYvNjuesINhWqmfZihZeHTR6+Mc0B52r+lJ5DQ
         TKr0wqErCmLuXRMmTKoX6u/KUWJFMhi8OA3XIjP3qQUZlGd29h84C24HGEkJIO8XhWo0
         hz1qbUkG2Ol01thX3B0s9l7kf9va9rlb3AurV0wcGp1vQGNQD6Zmy0fcQ7Vmobe5M5nR
         yUJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775287054; x=1775891854;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vxHSxQTiSROLSCEz/HR/Hur/9my7UlNa+rqcrvgfgaw=;
        b=PdiiWIEZOdJxltfZN/VCbtSM3//L2RQgi5ldLLOr7L6hwhCjWWXmilAczUYz4HBveY
         Zhx9Pk0CgjqBoj5fmnNdPg37aPiEBuw54EIrZDOtQSkc7I0BjMqUuB2n5A7dXRhCc4HI
         vNNhkzJHxidxZjgwKg1DuWwUdjUqn2qbioVCt/t8UG8Aa0zxGRKe41DFlVc/joFFKgWP
         972Cs0It41akPKar21JOCJBV+7FN3oERUg8dqYMhikFpv+VRMRVrT+jl7A8nkcE3NAea
         8joK1+597N4gWZ72WeYevZ2o0eXe8eR32Gksw7fAqvpISiW/9NMYX3JDWbD00Veve63J
         VgpQ==
X-Forwarded-Encrypted: i=1; AJvYcCVrLDKFZ/5biiuoydbr3nmmYeIDW6oHook4dJfYXjvBSF5/S1efDh36Y2GGJnTAK5IuKTZfk+OoTg==@kvack.org
X-Gm-Message-State: AOJu0YzxRkMC+xJH4j1L4t8YO1qSgbUvYyS3B4m9nmRFErEqg6R6GNR3
	XHy3supauZqqldiH5f4v5Zds/+WJZS8jWJdR2/RjpmsggqFiDVDsPQyeg2QrrkXSnWg=
X-Gm-Gg: AeBDietEefI+ZqfG5fJNcsdPYPtjE7JvNg7Y8s71buJLfv0oGfCDe+NIMJp8SpPFwRS
	weWSn2wlLnq1j8hRK2ass6Pmh0mFs/UXSNqQDxS5ZYHFQrN7/UfZcan5b28udvVWNqRV9b6zI/h
	jGhbzJQDHTL3uf/P/4Pwjvm3NvDQM+XLLr2ht+cjZBefVzg17JlnWqXoch42oqgPOSg4Q2fzgEf
	t41fspdpjank6xyOehqbswOnLXZfQ9ajE3oaRe4UQnr+pQKU9QhWc7j7p+CI2496oICbbtv1YBI
	NCNAjPDuyh2du811uvLXCBitLlOrCPBkq35tU1IFHq5PNspFfnBcC//BBU4R2DAURRqKsG1B+XG
	rru7fZAsN86QrCJYNlfVTMoVHWKukb+c4WLcPJUWqFVvNk2mKqnX45rlks4ICj9SEfVIIu5MfWA
	U08/EU7hW0Ax8HCuJhQskrW0cOjfI3MBPd1L0fkwZV3IuXkhU2J9XJ2w==
X-Received: by 2002:a17:903:2808:b0:2b2:539b:d29a with SMTP id d9443c01a7336-2b28178ad30mr37104585ad.23.1775287054199;
        Sat, 04 Apr 2026 00:17:34 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b274979525sm94675115ad.45.2026.04.04.00.17.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Apr 2026 00:17:33 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Muchun Song <songmuchun@bytedance.com>,
	WANG Xuerui <kernel@xen0n.name>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Chaitanya S Prakash <chaitanyas.prakash@arm.com>,
	Yuquan Wang <wangyuquan1236@phytium.com.cn>,
	Petr Tesarik <ptesarik@suse.com>,
	Austin Kim <austin.kim@lge.com>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Junhui Liu <junhui.liu@pigmoral.tech>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Alex Shi <alexs@kernel.org>,
	Chengkaitao <chengkaitao@kylinos.cn>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	sparclinux@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/5] mm/sparse-vmemmap: provide generic vmemmap_set_pmd() and vmemmap_check_pmd()
Date: Sat,  4 Apr 2026 15:17:04 +0800
Message-Id: <20260404071720.3577290-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C681BC0004
X-Stat-Signature: iswg35e1ko8w5nqe1fdxbtdzsmpna97r
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775287055-906107
X-HE-Meta: U2FsdGVkX18eKtnnGjlLRTJj+AP1+926n6LXnyfgShUnJIpQyHwrql7RW99tEeyyNLbWCvBFu/DlqtQpKgMcQaXeuNjQxl525tEs/hOU+ywcv6XbP/LDHFvuAzlzcM3DtLbHD1ZLpma45s2DNtUUu5t55v9OVQyhdnirJ0AIDNZ7OOha20maa18Jh+I+gEVEwbZUNRGHmeDB3FOQgQqlTRdjFNI9ujrQdh+MHPpjHZiBDKtoEonk0ASKzX6aJ4hy67FkAAQZWaLweFNQQhleqNQS2wrrSbGuCs+zAI8Mt8YLbiGWmVbd/hlAJxiMybffB3kyqiUqtG9qGfZLzbnwm6GknvBfcdSru63GxI0xFloZH3ZdkuevQ2zsyEMazbssKX3kzyZzsT2uL6+7HT3wfU1rbKYaVcGhjVQ6QzF2j71aaDODvcnrF6Pm401kNRuJ10FMHpHXqMoc9lMfYTjjKWTcEA/glFOiwaaM9RWMzFzUM1l1+xkFVO1bvEsKqOW6zjcSt0Ne3oVaPO1Huar1b1lWSV2TQY9h9iGKtwEDa3bppeg4X+OXVy4Ap6ySIhDcsJRHHjaCOb8LPbaurVHZM5neBAXUhYTdaqewV5XqelysnlqyXp0z+W/iGfhQgzEvtEC/sn5mDIw89IuDmHBLXdG2ppgWi23Mdb7udL6s7DoG7ew6Duy5XTC0p/QYyh2GeUpALK7F/h9+PGjrqD4i52nhHoSQNq2LOzfJJcPVdwZVHQA6huhdc6FBqFnhpl+ltCdc8amQz5ZFohS6m5CKCg/Sb6hntneHUW5c3rk9DDFZzTfIj0cnXl5NmZ9uGquD++Pt9WhzbAqdkBu7xPG6RTSCuaMuG8pP6chaEnGE3YVw360Q3XEntCAxil9sm6enbb23c0lewiVUdATCFyssLOoEkbdKZR4VK1PeJMHe/4cJ/fvQO9NUYjaAVFmszB+sIGYEcVBuPUafOZUDpK3
 IJ2zynQq
 kmf/moSytU50QtFjFqxQywgrLZBqUJEo4o0SC7UAgi2F0IIhADUNsjvORyiBoPwKD4MG2l2RGqjQlkMlh+U5+XuBOAwkWV+JgK3aXUjWmOPjapI3c+WQZKfjwi+aiCG9pv3cW4E/sPdeY0qKfTAFvOAXFHPFaMoKoPZ3bWWW+HX8pkBuBVMkdqPwdsIYR244oWnEfx3R+Yc/UeF/lezOxKE7ZhD6g/0LOc7v7e+Hrl0i3/wR6gnN0Z/CxyE8ZDLWdryPhei1p3vOeMxGv2st8j0ZswxfZT+VMojmnYkMQ/NQOBFcgUVIxZr2eo3yC/vyexMRubNcy7rF0xJBTmxDOSNIzZq9iJiPGWlVYReM3vL4ATw8kmNVo85ELcYm6XAVw3AmJP/DWmxEUeTDc22aa6hAMXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The two weak functions vmemmap_set_pmd() and vmemmap_check_pmd() are
currently no-ops on every architecture, forcing each platform that needs
them to duplicate the same handful of lines. Provide a generic implementation:

- vmemmap_set_pmd() simply sets a huge PMD with PAGE_KERNEL protection.

- vmemmap_check_pmd() verifies that the PMD is present and leaf,
  then calls the existing vmemmap_verify() helper.

Architectures that need special handling can continue to override the
weak symbols; everyone else gets the standard version for free.

This series drops the custom implementations in arm64, riscv, loongarch,
and sparc, replacing them with the generic implementation introduced
in the first patch.

Muchun Song (5):
  mm/sparse-vmemmap: provide generic vmemmap_set_pmd() and
    vmemmap_check_pmd()
  arm64/mm: drop vmemmap_pmd helpers and use generic code
  riscv/mm: drop vmemmap_pmd helpers and use generic code
  loongarch/mm: drop vmemmap_check_pmd helper and use generic code
  sparc/mm: drop vmemmap_check_pmd helper and use generic code

 arch/arm64/mm/mmu.c      | 14 --------------
 arch/loongarch/mm/init.c | 11 -----------
 arch/riscv/mm/init.c     | 13 -------------
 arch/sparc/mm/init_64.c  | 11 -----------
 mm/sparse-vmemmap.c      |  7 ++++++-
 5 files changed, 6 insertions(+), 50 deletions(-)

-- 
2.20.1


