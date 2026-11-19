Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC25D606A32C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 06:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=Gjr0Q0KB
Received: by kanga.kvack.org (Postfix)
	id AD7EB6B05B2; Thu, 19 Nov 2026 01:59:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A619B6B05B3; Thu, 19 Nov 2026 01:59:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DBC06B05B5; Thu, 19 Nov 2026 01:59:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4CE8F6B05B2
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 01:59:19 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B9FBF1C43DD
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 06:59:18 +0000 (UTC)
X-FDA: 85450967196.21.8FC0D0E
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id DAEAA80004
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 06:59:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Gjr0Q0KB;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795071556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=EpkpAe8MEN5BuQD0iXz34+1elSDBS0pp25xEYHL3/ks=;
	b=Axj1+HclODvGxn/SJU50l45W/M/8haVNuQViaGZScdik2HlCyWVmp/sA6Y9WnGBjdFwA0G
	/Dc/f4ck4PzG5HGa6yFY33HwIQw505Z2qES5ff6LLtz+tv1Gj8vZYh1ySzNqDr5CK+BHOZ
	I09iFYqK1sdgldhJ0ky6aN7xMFOTZW0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Gjr0Q0KB;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795071556;
	b=cckTP3O8IR18yAdPay9Q2ox0vXtWeP5ssTkbI4E9q77ohxFyAXwLSlGOcprbaTdeuZ/yVr
	e3OkJjK4MExx2bL1tBuwZTLFzhMH5exZ+SvaPHUC3mmyG0rqEWZ/M5xcTBYBS5n2z/ggkP
	jVUwTU/DoOBGwq9kHKCfvLIs5y2tkX4=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3b3e85baf7cso756933a91.0
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 22:59:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1795071554; x=1795676354; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=EpkpAe8MEN5BuQD0iXz34+1elSDBS0pp25xEYHL3/ks=;
        b=Gjr0Q0KB9LRAzKYx1QNqFK6ren8EHAznsdFX8EZXhKE3aSm7UEpSoWGiCdpepcWHI2
         t8+4ltTkKN3vbeSX2KZfx9a3ui959J9d5+TPkhA6BJVWokKsQBWOyQQFb42VN+oeDURE
         v0mXvIrzq9zLTArh2XaAaYjJmTdG8e9yEvfcxj/GvX2CixrNOTNo3T5eGkpjypxcFeVu
         oVCOk3o58dPfsbvtJWFRQIXtHNAqQ9zk7vC64SE5K/8vw91hetN629F0Md2Qx8c5UUK0
         L06BWHmat+3qAICaJbxD2NZ9oZwzw0JmzPtS33w6Ax5Exr6fj7fv3lmwzBY5aQrT87aP
         +8LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795071554; x=1795676354;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EpkpAe8MEN5BuQD0iXz34+1elSDBS0pp25xEYHL3/ks=;
        b=oxcAJ+WaXkqRqyJ6wepnJ9zqghciCKLaW2tCwCzsMG+MjOdsLPf/Rboqc9RgBW6oL1
         n+5ih71ZD55uPCPRqa/6RkA7R7WMBlEYgiZnstGUz4d0yKhhEcg/rTQN25sSVsUtRuRv
         7ZjsUgkzXTWye2SJQCv8zafheCmJ6IwXQmfkbq/+FFA8RgX8KYb+82SDRTV+miDsWSjD
         OqpxILgypgJGsnfefWOIuid2pghPqdd95SAXdOi1z0CFYVANEtcXWZxQJehMJgKWUG/U
         XE4iFol9ljm/p5XwsnhexMz6bj9NxhmWQozWWSZEZl1lL4pV3eGPAYiojEVVFjxGDFgg
         cfeg==
X-Forwarded-Encrypted: i=1; AL+hErEJ+T3jCcCBKtWPtwp68iDamAZ/09VzNwH3/P4VffZ1O4z+PatTadSmm2s9d4EFgDVzyBL7tXfVQA==@kvack.org
X-Gm-Message-State: APuU4Z+ROi8e0iqwvjU+pt9taFoep5zHKWI6juJsiz0NKW6rDi0fn/yY
	vDDhdrSQAoUK3CW8j8uPOgg16KPArklZBPpqjwCs0lQp1Nrz9EbF6lG/wUgdk1T4jkY=
X-Gm-Gg: AZFdTZfDBQcNg1/Jwd1gJVI5Jp1wXzzRQBmFKkjE16JrylkYjdeJMMvHqY5Q11OZgxp
	g9XAI53tLjJAmygPxYlr+2Dn5va5YNS86in+vJhEFDWvql03t6WJJ4eIm1gxc32QlIN/WeoUq0t
	1w65Wd9uQMXVnph662Nhk4OJg/fSbgV45BI7iIdhAiVSJJ4Kclj2+9n8Ok8cljaOWWsgibDnUeq
	DM49oy24yXPwUJ5gFu/rLmnF2GSerlxeJ9TtTEaObMoLB/6eQVoM2B3lnZYwNg16CKuUaAMLLYp
	2iVejcxWHdyT8tA4V5HoUzrR/fmpUx8NHPJM+WWrB+lrqsLwHBUNfy7x/V6o5tgaislMDNvoAIW
	7aZqQTphjby99TtiVRj3s5k4clSxaEGQsVuWuTcrTRo8Kyt5avDhEQE5rA7jvOhBhPfDL3saUcu
	/rmBmzN5yft1dXDwXxMSiFyjUgMro+pAbm90W+5oWwoEjJb3QF0BabJXbhXW7LfQjtUW3GFS5tt
	iJ14Yl9l5oIW4lsYfnyrCoTzFsNlpTIPZIrrkVZieGd2KEY+KqCka5i3QwN7tTCretFjI/6IK5z
	SiL8yhMNV1LGWZhCNQeMHBIhBzNGh34wd2Wi/ASAEF8P4GBCwft2D+s4F0M=
X-Received: by 2002:a17:90a:d60f:b0:3b0:a7b5:c037 with SMTP id 98e67ed59e1d1-3b3d063e959mr4839420a91.1.1795071553983;
        Wed, 18 Nov 2026 22:59:13 -0800 (PST)
Received: from G6L4RL2QG9 ([2408:8440:c38:5ca5:3175:932a:757b:716a])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b402e75223sm597488a91.4.2026.11.18.22.58.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 18 Nov 2026 22:59:13 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Chris Down <chris@chrisdown.name>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Muchun Song <muchun.song@linux.dev>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Pranjal Shrivastava <praan@google.com>,
	Ketan <ketan.kishore@oss.qualcomm.com>,
	Mostafa Saleh <smostafa@google.com>,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sashiko <sashiko-bot@kernel.org>,
	kasan-dev@googlegroups.com,
	workflows@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 0/7] KMSAN: Move per-page metadata out of struct page
Date: Thu, 19 Nov 2026 14:58:05 +0800
Message-ID: <20261119065812.89959-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: x418qhhiu4yt7sg3dg3utwf5tnspwy4s
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DAEAA80004
X-HE-Tag: 1795071555-714820
X-HE-Meta: U2FsdGVkX1+mzl9z0qEQ187mWgL0mWxvQmEenuzVNJuflnYm1yOkih/fDBcKx9fU2z3loj7fxeu2IGl7qFTMS6q3wM8P6vjERSaQWpaugrhzhHzwrVrWgFByYgzIwIKfTBo8apCuovUttIuiZnBrzwiZu1BAvJMvVoTZsMHKgN3Guh6nwNfmkNp50yvYLg0cCdgg/aWafVBLDmtyUSj7dlrw9oloIIJGOcRh69Ap4OpoXl3k1pvvuX7kT/C9Join32JBbvV3tSRGQrdv4Be9DSb7EVPJ+x3AyXEytYFyouDCnLl1zcbvDfpy3CTZHYPGKHxaAEjelL8yz/LguzOPgIT+WlTHf0Pe7ZitpOkLWzCrgjj5zsgp07d24Tb8dvJcFT+QeoOV/pS3mPAUpfGQ1S12IAfbIteO6AytP2MaKPOJmqXKxCWVvUjdY7+rWublGAGvbKpCJS6mf+kiVa1dBGCcNu0pUxOQJXmUjVIBurBB7X9A7hGDLdX56Cje4B4AETrnfiqxIWNBUYyeaSG2YzqUlMeTMzjW99FeZz3LoyThxOteRLIRCn5hQWu3gQOYGlKu5Fzho5cT4DPy0X4i2eh87SOcxkpVPEsq3QVtLxdgeIYyYaDJhE5CQOh09zisUm1z+Dv+86tF7F1dVUglXAOpunEpt9a6T3ysIqvfrDYGN836GyFGd60ZQ2lsT05+gOyTZc/IQ/gTAaC5geDVG7V+GzDIANOX4GEogZhzGL7G62LugKGxISfFhSRBj6pGy8Ob0AllDAGv6crLiWdMDW2ZxG/5hmkpO+Y7XeSsc0USxrkTLCid6oXVLA/licynzkDU2C+kmxbHgDhPfOsTGlKAWZVq+R7mFSEV8JRiBfcmi2L6pHwOvWt/zoihUf7sK8sBmez/vEQg+a5K+IGPJOH4Ah/8n9sDSzxI/2JB6ltjKicCvswuwWb00rFiw7U+n5We0ZZWVl5fyAm83PE
 /Pq7iKN5
 Bl38PQc5oHiz9CyruU1+dL2qsbPHgys99ozpYjcWIxk03FEnJYvXfvr1W7v6XcbA6a9FaGM0JrLIrtgrWhpu8+rD5OxbEPXeZhIeq1kzKMlc+HjN1+ooFOzZDxkFV2XBSaFcpjdmSO3FBEo7aeLRZUlrdX3Yk8n7zlvuuif3xXQaKHjmd6a3hIfScbJRwiCREL3c7ROFU+ilbQjNtaUSVz54fiuUwRpTVLC98zG1tnqxrkXnWrXWfZuBD+hAV17SU5CaKHIv35bSJCynUnHaDmdfarC/eu1UNyxaiW8B/QHcUlDLhpgktF/Uf1QxwK+9k0vsj3AsPJDWTKOJY7OpJo1rQWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series fixes a KMSAN metadata-loss bug triggered when boot-time
gigantic HugeTLB pages reinitialize their page descriptors after
kmsan_init_shadow(). KMSAN currently stores each page's shadow and
origin pointers in struct page, so the later initialization drops the
metadata mappings and leaves their backing pages unreachable.

Preserving the pointers around the HugeTLB initialization would add
KMSAN-specific state handling to the memmap path. Moving
kmsan_init_shadow() later is not viable either, because it allocates
metadata from memblock while gigantic page descriptors are initialized
after memblock teardown.

Move the metadata pointers to page_ext instead. page_ext storage is
independent of struct page contents and is made available before
kmsan_init_shadow(), so later page-descriptor initialization cannot
erase the mappings.

The series first decouples KMSAN metadata access from its storage, then
makes page_ext safe and available during early boot, and finally moves
the metadata pointers. The move also shrinks struct page from 80 to 64
bytes on x86-64 KMSAN builds, allowing HugeTLB Vmemmap Optimization to
be used with KMSAN.

v3:
- Fix page_ext client alignment on 32-bit architectures by using u64
  alignment as the cap (reported by Sashiko).
- Open-code the lowest power-of-two factor and use a local for the u64
  alignment (suggested by Andrew Morton and Mike Rapoport).
- Use DIV_ROUND_UP() for page_ext accounting instead of relying on the
  caller's size alignment (suggested by Mike Rapoport).
- Simplify the page_ext alignment commit message.
- Collect Reviewed-by and Tested-by tags from Chris Down for patches
  1-4, 6, and 7, and Reviewed-by for patch 5.
- Collect Reviewed-by tags from Mike Rapoport for patches 3-5.
- Rebase onto mm/mm-new.

v2: https://lore.kernel.org/20261117120627.50601-1-songmuchun@bytedance.com/
- Fetch shadow and origin through one masked metadata resolver
  (suggested by Chris Down).
- Add a fix for pre-existing page_ext client misalignment.
- Use vmalloc for runtime SPARSEMEM page_ext backing
  (suggested by Mike Rapoport).
- Unify page_ext allocation and initialization entry points and document
  the later FLATMEM callback timing (noted by Chris Down).
- Allocate all boot-time SPARSEMEM page_ext from memblock
  (suggested by Mike Rapoport).
- Keep memblock allocations above DMA and suppress per-section free
  messages (suggested by Chris Down).
- Inline the unchecked page_ext lookup while keeping page_ext.c
  instrumented (suggested by Chris Down).
- Update the KMSAN metadata documentation and describe HVO enablement
  (suggested by Chris Down).
- Expand the series from three to seven patches.
- Drop all v1 Reviewed-by tags because the affected patches were
  substantially reworked and split.

v1: https://lore.kernel.org/20261114104150.58424-1-songmuchun@bytedance.com/

Muchun Song (7):
  kmsan: encapsulate per-page metadata access
  mm/page_ext: fix client data alignment
  mm/page_ext: always use vmalloc for section page extensions
  mm/page_ext: use common allocation and initialization entry points
  mm/page_ext: allocate page extensions early for SPARSEMEM
  mm/page_ext: inline unchecked page extension lookup
  kmsan: fix metadata loss during HugeTLB struct page reinitialization

 Documentation/dev-tools/kmsan.rst |   8 +-
 include/linux/kmsan.h             |   2 +
 include/linux/mm.h                |  12 +-
 include/linux/mm_types.h          |  12 --
 include/linux/page_ext.h          |  61 +++++++--
 lib/Kconfig.kmsan                 |   1 +
 mm/kmsan/shadow.c                 | 199 +++++++++++++++++++--------
 mm/mm_init.c                      |  11 +-
 mm/page_ext.c                     | 221 ++++++++++++------------------
 9 files changed, 290 insertions(+), 237 deletions(-)


base-commit: 3dfc09a9493ddaa5e7722a29165d8450b55b4d3f
-- 
2.54.0


