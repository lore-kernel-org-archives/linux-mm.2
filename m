Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4D20606A68D
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 03:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=RlTFDi0u
Received: by kanga.kvack.org (Postfix)
	id 523536B05B5; Sun, 22 Nov 2026 22:31:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AD7B6B05B6; Sun, 22 Nov 2026 22:31:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34E246B05B7; Sun, 22 Nov 2026 22:31:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ECF806B05B5
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 22:31:23 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5B8A680796
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:31:23 +0000 (UTC)
X-FDA: 85464958446.22.4AA7208
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf08.hostedemail.com (Postfix) with ESMTP id 905AC160003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:31:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=RlTFDi0u;
	spf=pass (imf08.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.210.177 as permitted sender) smtp.mailfrom=jeffxu@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795404681;
	b=qPPXSZtii65xVP/piRFs1tCgGa4TJApiScqhzHaWaiSBZ63o6ZipsacIzSGLYbRL4i9Sqg
	D+HSOXnAEgJX4hSIMbtK4e4gxnBcSemMB+X5nJlmyJfO54RzZNIgERR76+ZQuPBCT/31d7
	fPRuCI/DRqtuZKHBK9VEvNS3aA8p2yw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795404681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=n3/QgCFjzvK6G73Tiampz5hPbLES3QQEgOsn43qeBn8=;
	b=ttH92ieHN3w7rSGNpjVQUxJPEgTIE+1uPUYdkf/z0VEcc0q1S+Wqd9i6buD8RYjenQqkCH
	yrI9AIwRtqajU6HE6prPgRvlC7MWuhldM9mLKQBf/uFfg8e3FhArE9YPi5kI7QZX86qvsC
	OOEEs6JdFSXD8fUo8z/4bLCH9k2FUqc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=RlTFDi0u;
	spf=pass (imf08.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.210.177 as permitted sender) smtp.mailfrom=jeffxu@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8b3d544148dso36673b3a.3
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:31:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1795404680; x=1796009480; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=n3/QgCFjzvK6G73Tiampz5hPbLES3QQEgOsn43qeBn8=;
        b=RlTFDi0unGz9cPLDVNm5SDe67uJykCbJlrTvQ9Wv5RxbkVw2UNpukOOcNBunyO2Qf2
         FKUZh53i+jS6OEExvfX2tt7yX+kGFLFwry+DlTnBdQLfovVJiaz6D1adQ6z3lZDe4rsJ
         Mn0r0+wNYnTHwxvUTXAt0CVMM+fEWNuhBQg7A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795404680; x=1796009480;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n3/QgCFjzvK6G73Tiampz5hPbLES3QQEgOsn43qeBn8=;
        b=oBUWlLSNDLCqPJVS5yt6nLuhMtzLZVf4r1QCThFvHPTWLc/LDjqgw1Nzk1//ogGEjq
         IjNR9/RGgM4g4PFGadhHS4aIdkvTuSXb2eIUuwNApJeMg5OifgKFYn6X/xB6B9qTGzo3
         owZRG83aAJapEXa40FRH4CeF89tcRs0bEHwbMVx7qeoH6jOLp0pIckn8lN4Aa7n3rf5r
         rjtPbKW/i4/Fm4d1IqkXB63sfRX8cV4w+xylZnh70lB+3VzahUmmcsObgzeJCJJnwJda
         vgSwF6XIgOX9AxGJ95t4jaS9WyMcUkcrS5w1WyWv+CbNeMaTLeL6VqlBV67bTGOd6Ko9
         lBuA==
X-Forwarded-Encrypted: i=1; AL+hErGIlctixubV3WL6SsUKYXkHUVH0UEpNDju5XPyD6gEgNlAKReB+4Yi9rwwaNOLRow+popaIj7dbeg==@kvack.org
X-Gm-Message-State: APuU4Z/pq/gS5qUFrG++XsxyodqwtOFfd3yiHE83mQJjCZH2y/tJ+Pye
	GNlj/CdVPCgxTTQIwWf2Ub4soHGB4J40DeSv7LHlNKX6BqbgK5cNEV8H7c5U78lDZw==
X-Gm-Gg: AZFdTZclh/x0CwWi6dc3H5Gh+rm4U7qV+/dJ1tnyKNxpeDbml3u3GVDOagCNPpIOtY/
	vz5WYNeIH6xdJTg01OJ2K05bYRWd2rRBLn0ZeN83tmZ1YzrAz42u+1nBWA4b2bkeyMR5615ugGC
	Yr/EVIfKftQrxrQC/2jPeJgPueqnxPyuWNyLw4uOhxD9NV9tDRqGAb/GTQnRi0nnsJg5PGqXTg2
	J544bPtiJKZ6enTLy9roTx3Mx2crN0LFE6E/M/X4fkuiZ5tWOkGzI6V6NepWTbrsp777rh48zfA
	fqa7QfDqb4ibn7uRcIJ6YPlkwWjr3rEzE8OMLlCw+AkOi6ke3QjnUShZjacQMRW76kJ9svG/WN7
	C7BbYLwq0NgfCtR8jn6GIjp+LtL+zrJf0URpC7lVU3rvkcUmM9pFNvlrpvzUFsrq360T6grI6MI
	qc9+8jsSNj9njDBoKVkAWBLXuqPpMAc4q8L6VZvaFu2MW5ktyN5ZnGT1jxkL1ZRRduHXYBpibnq
	dC1tw4+h6TIuViOV12q1vnxADtiieVxiVOT6YztDr1fegPg3GoVF+o/9t9ZhIogLwFm9TaU39WL
	wXeFF7QCC/hTzPwwX/iOxFHwEkCEdPPVV9jKdDGjyrFitSCeiyQN972AgVXf7ENuL6XSNA==
X-Received: by 2002:a05:6a00:c1ca:20b0:8b0:4ee8:10b7 with SMTP id d2e1a72fcca58-8c8792b617bmr11211724b3a.1.1795404680238;
        Sun, 22 Nov 2026 19:31:20 -0800 (PST)
Received: from localhost (221.247.125.34.bc.googleusercontent.com. [34.125.247.221])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-8c87285c14fsm4712022b3a.15.2026.11.22.19.31.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2026 19:31:19 -0800 (PST)
From: Jeff Xu <jeffxu@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Jeff Xu <jeffxu@chromium.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Marco Elver <elver@google.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chia-I Wu <olvaffe@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Ian Rickards <ian.rickards@arm.com>,
	Jann Horn <jannh@google.com>,
	Jeff Vander Stoep <jeffv@google.com>,
	Jeff Xu <jeffxu@google.com>,
	Kees Cook <kees@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Collingbourne <peter@pcc.me.uk>,
	=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?= <ptosi@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Tomasz Figa <tfiga@chromium.org>,
	Will Deacon <will@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Baoquan He <baoquan.he@linux.dev>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Allison Henderson <achender@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-mm@kvack.org,
	kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kexec@lists.infradead.org,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] mm: kasan: skip KASAN for GFP_HIGHUSER
Date: Sun, 22 Nov 2026 19:31:09 -0800
Message-ID: <20261123033111.2349160-1-jeffxu@chromium.org>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: 905AC160003
X-Stat-Signature: 3okn7fufzy5wsfpf5ym3tgtqgi3arrc6
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795404681-972882
X-HE-Meta: U2FsdGVkX19GEHb2E8x/Wsi8LnTuPHXKwI98zzc0sqKwJBX1FRXgSf2rfX2WEvJo9htdMpn/RAxB6Izbfd9pXwsr/qjZ6yc0sfwyBSf4zESMyzF7zb/eNdiLA4pDw8igIrBCzVaPu7TPXPe0OL9cR0l6KHw+CzH6owy7yHML1msdfR8hwqWAlaNWAEK4sbIh4CPiv6tmIQmtwoEPjYldQONrBIj2RTwj4644rIwOE4ilJpeVQxQ5StkeAbmXW8dV20hW/sapwvt1MayD3jNCbOxLuU4mgnvRD3Lc7ovCfWe/fcvnlxkCU2BRjrNyzN2223ojIkgEx+YKxYdaA2sBuyhRRLvu2+VfDUT2yQFh9P9Scr5T/zbnlUbH2cLa2kq1p4Zn8npTlkqpQpvYygaRRb5NOgDZiXkbb+9Oy/wTngRnln02vsWx9KKSZceDLh6yvQYBa/Jc9p6pURKgb18DKT1VfFrLv3JNp+cfe1lQvQDM5V7fS1c6MdTiOiqdSXcBxbQIziroQoJnpcbo4fs+byTBV1LFNJZhFcOtCE8vPOIDTwY8xquUyn9dCZEKqCiH2xFgmBow68obk5lGMkInLWLLbnjEtT9PzlnxERFlmXPFyXvijkaeFTu0Qph0uwKfPsXJQ97D3g4vBmkHiZrbA57H1oKqwx23/ug7vKdx5oBPMuWl1KRqHs7nlyCUIaOjvU2UhorFCYCB3M6hEAqXnWFDSCAAr0jyfkFoh56wzW5TV3qTlipA41fPoKtLUyaNI13esk3EMF9whHpsiHUx0MF9XzHCGgBJVdwrQ5g/2uWx3k2J/so00jUhh6h2+FO2MKUAE9U+JKJm+5Z/lAmw+HTHGeMaf8mt4GJ76Bf5c2lCnIZD+gzR8Dy3fFABID2vhvqy6G66bmRFYUIz4puR99GRaJrGdE38qoQxuU+x/XkswA5vFpdiFC3P8TC8QghB6VfhJZuxMDUDhxz2T5d
 o2KqSR0c
 l84tkh4IyESCfozF4JveuDHOBxktKC9DSnOC1/Zc65MGLA6RX+pMhK3ZbQInm2De9IDmVXxO82GU5ajbrE11T9G4UYVrR5zWhXdJNoRSgCWMhUCodzhK0sM2o4mcpu89Cy+ipZy3YKNGToGtb1QK06kgfgUwbX273y1/YPK2fgDiukQI5mzcNEvLEy/y6VyFnkGbGSpVz5IeTXAN04eD0bDtKnI7pxi609fjyJlv7t0m57Q8lfUtVIcw1/yX2oEEBXwj1dPS1sMaj5iBYKUbJDo7O8hz8OS4+IT/842Vin5b+LUnPS9Mh5KsXTW2meLZEHt8VbwIDseFCokhHqfEYJqf9PWng/2ENKf+T+mvSg746IRHEhnp27VlpvX1nyABu5agHUq2D1oyC8rhthhBbw0C9w1LA2ZsS5gkqkJqPyzjnoU/ErPldlKSuSOHDjZge5pveHyTtMfcSiG5LcYj0I/2ANUZ5vKa9KkgnQXu+w1HHz+UvPaM5SqGW4IsnzRHrIIY/enr0WfD5r91f7P1IQkqrz61S627ZRe1Eg6ZjcDbuaKiJC+cvz6VXYjQo/tEXXzMGcSTKIXZSHpLtyJo73JNGxbrdfv8UdV2nZHk37fRAunHUL0PlLtyR2TJJTzB5AefHaykGaxBOh+XjitLL039VB0J/QsXyTEsZ2JiNLZai+53K0dVuuOv1N5Gpi9RL2Z9l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi all,

This series moves __GFP_SKIP_KASAN from GFP_HIGHUSER_MOVABLE to
GFP_HIGHUSER (patch 1) and adds a KUnit test for __GFP_SKIP_KASAN
(patch 2).

GFP_HIGHUSER_MOVABLE already skips KASAN tagging under
CONFIG_KASAN_HW_TAGS, whereas GFP_HIGHUSER does not despite sharing the
same userspace-allocation contract. On an Armv9.2-A device (6.12 kernel,
kasan.mode=sync), skipping KASAN on GFP_HIGHUSER cuts 32 MB
/dev/dma_heap/system alloc+free latency by ~80% and improves an
app-loading OpenGL benchmark by 15-23%. As a side effect, GFP_HIGHUSER
shmem mappings (such as drm_gem_shmem_helper / panthor [1, 2]) stop
hitting the swap-in readahead PROT_MTE tag mismatch, though the general
readahead issue for other gfp masks remains separate.

Changes since v1 [3]:
- Dropped GFP_HIGHUSER_KASAN, the pipe/FUSE/kexec/RDS conversions, and
  page_alloc_highuser_kasan (v1 patches 1-4 and 7) following David
  Hildenbrand's and Tomasz Figa's feedback; kept those callers on
  GFP_HIGHUSER (2 patches instead of 7).
- Rewrote patch 1's commit message concisely (Lorenzo Stoakes).
- Dropped Assisted-by: trailers from the patches, keeping tool
  disclosure here (Lorenzo Stoakes).
- Rebased onto mm-unstable (d12eccbcb79a).
- Kept the fs/kexec/RDS maintainers from v1 on Cc for visibility since
  those patches were dropped.

Testing: built and booted both commits on arm64 with
CONFIG_KASAN_HW_TAGS under QEMU (virt,mte=on) across kasan.mode=sync,
async, and asymm (9/9 runs passed for page_alloc_skip_kasan; 3/3 failed
as expected when patch 1 was reverted, with the next test still
passing). Verified W=1 builds with 0 warnings across arm64 (HW_TAGS,
generic, SW_TAGS, no KASAN) and x86_64 (generic, no KASAN). KUnit tests
were not run on real hardware.

Tooling: an AI coding assistant was used under the author's direction to
audit GFP_HIGHUSER callers, draft the KUnit test helper and changelog
revisions, and run the QEMU/KUnit build and test matrix.

Link: https://lore.kernel.org/r/20260519-panthor-kasan-v2-1-b7384458f076@gmail.com/ [1]
Link: https://lore.kernel.org/r/20260521105148.5497c281@fedora/ [2]
Link: https://lore.kernel.org/all/20261116230627.3537051-1-jeffxu@chromium.org/ [3]

Jeff Xu (2):
  mm: kasan: skip KASAN for GFP_HIGHUSER
  mm/kasan/kunit: add page_alloc_skip_kasan test

 include/linux/gfp_types.h |  4 ++--
 mm/kasan/kasan_test_c.c   | 44 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+), 2 deletions(-)

base-commit: d12eccbcb79a4fa35c3aa588eb79056af62eb859
-- 
2.56.1.750.gf70dc682cf-goog

