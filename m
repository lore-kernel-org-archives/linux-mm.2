Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3745606A334
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 12:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=k2A3t91i
Received: by kanga.kvack.org (Postfix)
	id E0CB86B00EF; Tue, 17 Nov 2026 07:07:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8E456B05B0; Tue, 17 Nov 2026 07:07:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C558B6B05B1; Tue, 17 Nov 2026 07:07:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9220C6B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:07:08 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0FEAB120412
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:07:08 +0000 (UTC)
X-FDA: 85444485336.22.33EBB6B
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0B0CD180006
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:07:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=k2A3t91i;
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794917226;
	b=hFk4JI8FzkqIMGBix75xjxzTdGaxvzIPzoPUlz18LRG5oPHlYzAmcpWsL9ofIjaLX4OW6m
	UG3c/CeDVF3IgkJGMK8DMM3o/NURnUXafmTtMVXDGO+rebxYZkKmPbsyPWdRvorGEY3Rj0
	914F0pyEY05aee0G9LvId1Z0dZyrIfo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=k2A3t91i;
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794917226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WWAo/gwd4eMoC/+fl3ejBvS36alJNcf0i4jJ6DJ7zUo=;
	b=heF4zUuuwd4TnikrsyvUHpOU8BGMyvj7BvI2WfJ5I3bVrCWEVRuajT/LZ9JKYNcwvah7RG
	Lvk9d5H+exyHpnVyI1BIaEojqdZbqAttxNmytq/RJZkYudMxqX1JZCkt/GGmJX7/Zj2qNs
	Td4aXWpRJKI+qLlEa+59q8b9vgwHS8A=
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-15ea896ddc8so7065318c88.0
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:07:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794917224; x=1795522024; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=WWAo/gwd4eMoC/+fl3ejBvS36alJNcf0i4jJ6DJ7zUo=;
        b=k2A3t91iU39L7aerN9zJVMupumFA1WdgVLz3DDrpB35ms8QOn1oFaqoFx2UJ/lXFfp
         sKrelOJJdKL/iudjdEe5Foj/E3is8xUEHqNXPs2twF63LbAfR8FRmV7QRv3/tyqXk3ui
         WRLIIJlP7OJ/00zd0ub7bTt5Nyg4sMOzAC/a8z8G5lVczitj9FWfxy63RD8VvL/h6c18
         LJtKS0RboMHjx035jCuP+kM2ZZvk1s5rD2e2JoJXbk94x833KLHsqUohG6AQqU57dR9p
         oZ6DtXie4HsWfS2SDwiMShXxnH7xZFFR1Zqx4JHeGWUJbio0ZpAIlesMU0yW+fvuj/H5
         4ntQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794917224; x=1795522024;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WWAo/gwd4eMoC/+fl3ejBvS36alJNcf0i4jJ6DJ7zUo=;
        b=oVtpgc+z+o2+wXYUQiTDF1CeqlZSEUj6p0YEoheETL++HBUym7cN2vvWlEhCclrB1w
         7llBhXER2eASrKkNlBQeRCmIzf5Zcx7gYZsKtnXUt54HUS8IN/rkBFrHQJGak4MIVVnp
         Soaa8PFAr8QHwbjn6kw0i8uP/FlPLQZmvTFesNhj3a21huDQfRRQIH45bXd65kTstrfI
         joTMfcv0kDRaz8LpXHau5dIOnmS2EdcKH0AoiqBW0tGQEt9QYEsiOSmHMWRXw+0VAvsm
         YIlaz4sXIG112tN7egAEsgFE5Bk1ptOUYPMX3NQaBjDQhnS1m2p4Bl6ERVDG/8R4zYqV
         XTRg==
X-Forwarded-Encrypted: i=1; AL+hErFZ0q9+yjRm3C/vXetBUJws+G+qv33qYa5ulOVRJP8DuNnGhWNqbVpdACxVE9eCZKh1ay+XTem/AA==@kvack.org
X-Gm-Message-State: APuU4Z8ZxAEuEB95n1aT735ZN6e6pTeXYvgE4k8BNIdo+L3Zc/U8VvYi
	QTE7bwuelZqw3lEYhWO7Z8uVG54H9YRIYqT9/yZ/yjcX6mVQ/v/YTFeN4CrHY+pr/Do=
X-Gm-Gg: AYBFou28bjHlVLaqIYdMhHKglV9A4U7Tz7Jqmnd4rlTMIhnl7fV6aSURzrRXg66kv+s
	fe5Hoiiy23TELXSECNVWeDlo/psc7A9jU5YqJR4886UvmNlc3q5Oyqbt66MDKqIBT4hRZtJq+Wa
	WUH1zw95D1hHk+Nf7t5u/d4R+M/TZLWyhATiWIECpxSewnlFpsXEROH3+gsKhFxv+qma0FCKXqF
	4UxfpQCl4PA125XmPM/sg+k2t0419HscozqCmKE2jffvxDCqXS3jp4cxVwlLwJRkE88IljDxvlJ
	OgRrDP2Z87QsLy6wtD6gb109fUBpaCDhrNg/86L/QB21Z/M2OfoN6ogMtyCQj3ungSfjPZyr3w1
	A0p0AK7Duz35wLUCvppwClj9Iz6eu1uWyFc0zhdaj/GU5Shw+yNNMdBZ4c3+BFvIDYNNqPeIDkm
	8ziVHmlXd1ElbsfBRXjoUsiLP55mH+f3f3DshZZXNBUtJkGr6u3QgrA/ZJfRVPrkiaBhg30YVsB
	anKlnGnKplEv+EO/nY2gfAUi0RJobwWp78pLPPjfh/QqMfr/60vGDR7EWESEJ3CT64BYmF2T/jp
	SJhkSUi/+Cv41hpq7ziAMvb1bQMjQg8yUHRRmdtcQrJwp0x8s2XHbw7j3RtULo+kPQ==
X-Received: by 2002:a05:701a:ccc9:20b0:1b5:3616:59a1 with SMTP id a92af1059eb24-1b536165dc8mr3075671c88.8.1794917223191;
        Tue, 17 Nov 2026 04:07:03 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031468b7sm47347116c88.5.2026.11.17.04.06.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 17 Nov 2026 04:07:02 -0800 (PST)
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
Subject: [PATCH v2 0/7] KMSAN: Move per-page metadata out of struct page
Date: Tue, 17 Nov 2026 20:06:20 +0800
Message-ID: <20261117120627.50601-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0B0CD180006
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 3o43ndn6gt6yzg1uztb4embh449bz3xr
X-Rspam-User: 
X-HE-Tag: 1794917224-459337
X-HE-Meta: U2FsdGVkX19TJllmJCwPeHe0le7nkwdkNFQ5dhXjvR0OdswHmI4i43sD0VIOiT2TBZOONNw9h5CfPqWD4zcapyRrPKmwWI90O1aisO5dSsx9x+bnyjO4r2T/7IfqkTNNtymEh4sKG9BLZ+95i17TQ0S2u7ZK5Jh4dukwYPeWRw/EFExtILXq4Xk4c1SD33Bw7bIfbJmE9cVrHkQGE3y/J6/i8Fzp4lWp/jlSGMu0a7SE6mvOFEKEvOfyiPqN2JnHW0gT0DchPz+k0FLl/YAL8/DTrdh5XqMpctO5+mBU2twLzB9JLHlTelE8az+eJBkhmk7qsfirPCRZTeAcRl+MGwuk7O7UUqmiA689UuWX+6u5rfYW2zm4x82koXfJxvmXeNR99PuBUbb6zLaG0sQ+2MCkGZ+0PYvK6jUbdeImZ7yjLWCSR/K42pt8nTRww73qBQmYfCnwqYAynroOHH5niLkyfvNq/TQNs9656UpbT5TgeWH0pEYACq/V/9+K4/WYG6MKXpodBQ6ZkSHeoN7XDb8su+LjNsH35fMhgPCcPI59SsENJwwfq/gmmFDMDyqimDH8m+8BYk8gJe2FsVHPoKC4Gpzqw4bCSrg/b10vDdNwNB1tUe5szHsZphjP0aFSu4AD10R77i7mENMLoqpvz6ubSfbvqX9nxTVpQj/zLRmXKz3GmGGgnF4cJBwqK/EYVvWUIxWyoA1y5GywL2IGrYyHD+BH6L4OXHv0DGy14iCpYFUo+iXO9JOAjBm3payffpynxene1ML7LeaIgljqjAEgPQ4BGuPkUNWdxI0B1Aj9sFh1pPFuvImEIaJVDHjohv1r/aDXpL1UpefXZ9JGodATEaP9itqB4RskuCIlTuWvp1lV9uuPLqGIjtjXvxLqiGTE7PBzd+gDnRvcp4uFNV8HH9FVn7XZS9n0t8LjGXKnIoSvgIo+/yfuM/XwTQ4+3kV9GI43YkvhsLWhrOK
 aRUDT5k/
 yfx1sj1b9v1X6eH4FgLCI3zTUBOn51a/hlIf5uX7am4dCU+AIU0/0EcV/gWQGpATOIvQkkvQK/IBNuta4fbZq2VcVhNBZMIgKoBQf9pg2wF8BK6PoxR+DiiOQhZsvF4HnqoXuKmEO7Yxi8wmAACwBmZGXS5QlrxzA/jA53ltkkS4jM3lRK4RqmG62qCrde6Sga8472mm2VE1fLWhFjSszUq+MbgirmHUU23847EmUPNPyPvvbQe1HiVdFTaLgxX4l1MQ3Cf5002E7u5/8KGNKZacIKOZOmkGtaemUCR8A9HorAEPkGiqdLxCWA0Lv8JdncaEu/vtH3HBiAZM=
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

v2:
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
 mm/page_ext.c                     | 218 ++++++++++++------------------
 9 files changed, 286 insertions(+), 238 deletions(-)


base-commit: 67f3b04b277373438f17300e056306adbd9edf7b
-- 
2.54.0


