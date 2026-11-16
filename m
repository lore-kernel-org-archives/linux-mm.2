Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79A7A606A885
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 23:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=NiWvKwbM
Received: by kanga.kvack.org (Postfix)
	id 90C116B00EF; Mon, 16 Nov 2026 18:06:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BC856B05B0; Mon, 16 Nov 2026 18:06:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75CB16B05B3; Mon, 16 Nov 2026 18:06:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5054E6B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:06:49 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CC4E8140264
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:06:48 +0000 (UTC)
X-FDA: 85442518896.11.D5BE87C
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf28.hostedemail.com (Postfix) with ESMTP id 072CAC0008
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:06:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=NiWvKwbM;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf28.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.216.46 as permitted sender) smtp.mailfrom=jeffxu@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794870407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TIKThpPDZ4NJSXYRfFfOL841Z/zWYVoqxjZupCxQAek=;
	b=Z2h8PJWSIM1xiSxfRJwG4Mg8fRtJT1uTd3kLfYh3RC5IySocqW8cqW3T9J5F1Yb3wwA7QX
	CnUtPkYIXwFoDSachTVmg6TdvnHWcqxTXrnyGVavALjdH6yfSXkp0xUcG91Ie/wCt+aC/r
	8H4cemzuly3vRHgJqt62NgRiRNNADKc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794870407;
	b=i0w4hDh37QWBYSz7rdsVd/dosq3+y4eDraFNCWN1JXbdwnXeOErvfHo4tQ83kn71rnMBdx
	J8HDcS0eoVBamecZ1rBv83oOK8JR3wrkckn73hRU2gShJ+PMdG2wlKeDa9WAYZaWdnEnQO
	Q3Sw+Lb+GN1xqmjg7ZpoZjYU4b8FG7s=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=NiWvKwbM;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf28.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.216.46 as permitted sender) smtp.mailfrom=jeffxu@chromium.org
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3b0d0f38abdso725606a91.3
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:06:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794870405; x=1795475205; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TIKThpPDZ4NJSXYRfFfOL841Z/zWYVoqxjZupCxQAek=;
        b=NiWvKwbMpHDSSCiRs5fqUSTHXLRHXVfPl7eRnOEuWywP4kskvtNMQSJrcR6mNYRZAr
         mbjXsTz39a7fxjkur1P4axzNQWcl2dehEBzwQgLIFd16pF1E1Ni7Yq7D5fWD+nAH1lz1
         UhjRwZmjjB1uCus3obOcXi0O/x8Cw1z6cPWxc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794870405; x=1795475205;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TIKThpPDZ4NJSXYRfFfOL841Z/zWYVoqxjZupCxQAek=;
        b=1n7lUqZWZjcZWRAjf0G5slxNRj/PeyTm0QiAOMzm/pTLcr3efdyFKhS330GF/Mw58R
         Rm1akNaaA5xjxNc2KJ4eS11iNznH/BGPE2W+7fQmPbpMgF+g+p22mcy5hOdV6BUSgXDW
         u9RCXnqw/URGgfa+ZjtbJIkI61lTzesMQSswTgEkAyze/JHumm/zgYyC8ilUsUGDdm9g
         jDaiEMfuCX2C2ahTaKutiETmil2VUGBps34D1/SJTzMaYK1w8HzpKjF3mPwNIGa1AL8I
         DXK3M/LhAW0IN2clWwnQ8OgVX/95WXceNUgE0cd85onZJexwEqnzRvjCI+uMgC0nnskc
         yfqw==
X-Forwarded-Encrypted: i=1; AL+hErEPCjS2wzTquap8PUVMs6mdg0oHeO0IFmAxqo1PqIPo2PlhjJxCk8RMP/HaiP3xQ3u5X/6JLh1V7Q==@kvack.org
X-Gm-Message-State: APuU4Z/bbjy1v5pZI14EE/2Rsd7cqYNPYAWalRiQFw76gnN7z3CSGYh6
	TvEBkJERrzsSpPKCCm3hrK5PJHIZg8KNu25KMil1XOS387edeGHWSyAovrBq94V+hw==
X-Gm-Gg: AZFdTZfj6zl0JINBjrVppHwpmPgMfD42qJT0Y9uXdPHcUQPX/HkkbR1Ht8QME/r0KkY
	fIE6mWl2f/NGwi6B4QCGJmzw61aBvo2bL2EEdQ4wZuEruKRZY7hMgCmLQ6PKCvC6bKKS34NI0fs
	yFNd2WD5sLSNukMtGRPNSY26cCHlnHwTKqZip1UxKAtUEqTVhOenIKQmiLN7gNZW45n5Uea6gG1
	ofdLR/XV6F0tVjlP0iyrqKRd5eRd4CydMyG11klQAs76qP7CbM3N1BU0GeIMfUJkHESVKD0fSsB
	om4J//SALg7+rTY9XD3uDkzu3KtomYmOcGcg2nU3ukI6OiN2RjQ8fZ5NJRe58UrlIqv3YYRwwaq
	6BSd/h2IaNQI13kK8u/Y73VHkKNLhjJvCtWzFugRHWbAOkkZHjKGbBe1zz4tao68aVqfRuoUHtb
	PSB8uHA9S14q7dwJGXKdSZyizELpvLs3HCg5duBw0N9mlgKGEKuN2zSfUb0g7O+M9kw5vk1A/RM
	FWqolEfgiZ+rJADQcmEL9lvL7c9jO7NT8+orLHF8NjQlo2JGOe7YguIkYFyJneB5EGIJXllcqb/
	adSOoB2Egu7BflT/7n0M7GzrPKhDjHyqGH3OcAXRsOgoPdCCswGq2A3SW23Qoi5kDGKktROms3M
	XmRbIEu0yo71+sGPh
X-Received: by 2002:a17:90b:5546:b0:3a0:238b:db4d with SMTP id 98e67ed59e1d1-3b1b0a49be1mr17581397a91.5.1794870405500;
        Mon, 16 Nov 2026 15:06:45 -0800 (PST)
Received: from localhost (221.247.125.34.bc.googleusercontent.com. [34.125.247.221])
        by smtp.gmail.com with UTF8SMTPSA id 98e67ed59e1d1-3b1b3b110c0sm9530818a91.3.2026.11.16.15.06.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 15:06:45 -0800 (PST)
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
	Evgenii Stepanov <eugenis@google.com>,
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
Subject: [PATCH v1 0/7] mm: kasan: skip KASAN for GFP_HIGHUSER
Date: Mon, 16 Nov 2026 15:06:20 -0800
Message-ID: <20261116230627.3537051-1-jeffxu@chromium.org>
X-Mailer: git-send-email 2.56.0.679.gc527c65306-goog
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 072CAC0008
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ju96474zgtme54oc3546eya9cc5hz7wd
X-Rspam-User: 
X-HE-Tag: 1794870406-143684
X-HE-Meta: U2FsdGVkX1/hJNPZImBa1FMzZgsN8scozLQDOKiQv4IIco1EQt0ZRz6Yh5kGTYsmc51841PgRqQSjUKR1xwD9C/pwfB45kYXCpLbVvVkVoPi+NkrqJLLSqMT8+ozTqaBOrtL7Yeucl8x9LdEfh9phmh0HX/Npfsz95zwVkL8BzgV+wktfiN0IH1konaKvpuxsmew2jo2nKPRelO+pkrCrwwgKUOzKzXuQOmilW3m8evQwj+N6aSWI4uQcRuJa4EcADOLpzGvYl+I4h2rDiVSBN0Bg/naUhHVYAt/o+p3g3YMEsMbC9yH93Khkejfy4oygA8x+4KERQvGDgICk5BeidVqNtN+e1G+XYhvhCLGaqgHX1FhL1vSJY6tw4ls5prijR5U984Sg0RQ94bI3fh9zmZEBPdFzMeLhWwwOmwm6u/mkVayeNqQI7CtVNl1y59VFVYGRxnn8Y7dA5C9+Z3EuxIPtlG3b+4cfPPd0bIPTDl4gjm8VJW0cjvhB1bmSF3AyNyO4Aa4DSW82S9vxqp7aj4OYYh1CsuNT+IY38Qo0fF6CS9Tepn6u5yBfFHvATnHG2Z726KBagnCExwddz8ffH/jamMgL8JO9bMOKEFO9F+02GUANip1LuPBtNiuvQcamXG8uL168j0mXQUeOTp2+LRr+TLxrZncyEjbGesp5WUZN53iCdYQ3nOVsS/bI80Wk24cf4KEkTmaq1m01SdVUqhanh1gzxggbk7aRRIRzhpLcspIaxN9jTXtwnvor+2pwqx8UluhjH8PjdmMvF2U/QAEZNMNZySx9bceeEq7Xwc5gf1dJPf9/OOhnqhXxUTnEY6o+wvePrz4tEbsNyZB9zc2Z7cxjc0ywc4b+vk8naBGZ0m60RdNYBrDoxbmKJD9N4KPuppog6lN5GeQc7gogqary53wYQ9LHHkYrIdNPBhfjfZ1TavNQwxieOFo9qsnQt4rphL3eMi/3QnJ9jg
 y2bJqDSK
 WVWRh6YHF++ROiqvMHwNq71UUFISEynQc1GpEq03FfFa1K4hMZYIQzcTfNcBo4FKOew9fu7hppfBn9k4+FpTfQSAD0R1LiF9acHnvomrdo3Qnhg4TTtZOMTe0hG9vO2dIPxXw19pXqQaBnejJKSwiND7ImM80zUmPkw+f30lwcpRzCowCdnWdlR55l/1Iu3lwPTKE1JNFzPF1okJnx8rMCaCKs0f4I8Wx5d7LLJP6oTewxPrvyNdKw7UHaalAhoBfm43GgbWSWkl26fAq4Wc95Th6OoBhyAL/d54yyAYxV024LAxpWvqnIrZf1WjFTb2/n5RUkJkMQ9DhKDc+HhNRw/D0TWAD0v7yGZcipmcwZmdEm94y5t3+/qrEc2xiQu8M1bpG5EQxBiwD1SyzC2CHdlgqxd029gWUxLDsbyAj3ovT8sedA3hVFKFnRg30Q+oVBW/S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi all,

Currently, GFP_HIGHUSER_MOVABLE includes __GFP_SKIP_KASAN (commits
c275c5c6d50a, 70c248aca9e7, and 0a54864f8dfb), allowing movable
userspace page allocations to skip KASAN page unpoisoning on allocation
and poisoning on free under CONFIG_KASAN_HW_TAGS (ARM64 MTE). However,
GFP_HIGHUSER does not include __GFP_SKIP_KASAN, even though it shares
the same kernel-accessibility contract in include/linux/gfp_types.h
("for userspace allocations that may be mapped to userspace, do not need
to be directly accessible by the kernel but that cannot move once in
use") and differs only by !__GFP_MOVABLE.

Moving __GFP_SKIP_KASAN to GFP_HIGHUSER addresses the performance issue
below (following up on the earlier drm/panthor discussion [1, 2]). The
swap issue from that discussion is not addressed by this series:

1. Performance: For every 4 KB page without __GFP_SKIP_KASAN,
   mte_set_mem_tag_range() tags all 256 16-byte MTE granules (via
   STG/STZG and DC GVA/GZVA) on allocation and again on free. In
   graphics and UI workloads, DMA-BUF (system_heap) and DRM/GPU
   (shmem/TTM) buffers use GFP_HIGHUSER; while steady-state rendering
   reuses buffers, window resizes, surface transitions, and app launches
   synchronously allocate and free tens to hundreds of megabytes (~32 MB
   per 4K RGBA frame) on UI/compositor/render threads. That takes a
   significant share of the 8.3 ms (120 Hz) / 16.7 ms (60 Hz) frame
   budget and thrashes CPU data/MTE tag caches (especially on
   cold-cache free). On Armv9.2-A, skipping KASAN cuts ~32 MB DMA-BUF
   alloc+free latency by ~80% (~98% faster close()) and improves the
   OpenGL score of an app-loading benchmark by 15-23%.

2. False-positive KASAN report after shmem swap-in readahead [1] (not
   addressed here): when a shmem page is swapped in,
   swap_cluster_readahead() also reads the neighboring swap slots and
   allocates their swap-cache folios with the gfp mask of that shmem
   mapping. A neighboring slot can hold an unrelated page that
   userspace maps with PROT_MTE. If the mask lacks __GFP_SKIP_KASAN,
   that page's folio gets a KASAN tag in page->flags. When its owner
   faults it in, arch_swap_restore() writes the saved userspace tags to
   the memory, but page->flags keeps the KASAN tag. Later kernel
   accesses through page_address() then use a tag that does not match
   the memory and are reported by KASAN.

   This series does not fix the readahead path. It only removes one
   way to hit it: shmem mappings that use GFP_HIGHUSER (e.g.
   drm_gem_shmem_helper / panthor) now pass __GFP_SKIP_KASAN to
   readahead, so the neighboring folios no longer get a KASAN tag.
   Shmem mappings with other gfp masks that lack __GFP_SKIP_KASAN
   (e.g. GFP_KERNEL) can still trigger the report. That issue should
   be followed up separately, for example in [1].

What changes for users of GFP_HIGHUSER pages under CONFIG_KASAN_HW_TAGS
(other KASAN modes are not affected):

- Access through vmap(): nothing changes. Those pointers already carry
  the match-all tag and are not checked today.
- Access through kmap_local_page() or page_address() (for example
  ramfs): accesses are no longer checked by KASAN, as is already the
  case for GFP_HIGHUSER_MOVABLE pages.
- Buffers that the kernel itself fills (pipe, FUSE, kexec, RDS) keep
  KASAN checking by using the new GFP_HIGHUSER_KASAN (patches 1-4).

GFP_KERNEL, GFP_USER, slab and vmalloc() allocations are not affected.

Patch 1 adds GFP_HIGHUSER_KASAN, and Patches 2-4 use it for the pipe
buffer pages of pipe and FUSE, kexec segment pages and RDS message
pages, with no functional change. Patch 5 then moves __GFP_SKIP_KASAN
from GFP_HIGHUSER_MOVABLE to GFP_HIGHUSER. Patch 6 adds a KUnit test
(page_alloc_skip_kasan) verifying the __GFP_SKIP_KASAN page allocation
contract under CONFIG_KASAN_HW_TAGS, and Patch 7 adds one for
GFP_HIGHUSER_KASAN (page_alloc_highuser_kasan).

The conversions come first so that these buffers keep their KASAN
checking at every commit of the series.

Testing: on arm64 with CONFIG_KASAN_HW_TAGS under QEMU (virt,mte=on),
every commit builds and boots, and the KASAN KUnit suite was run with
kasan.mode=sync, async and asymm. The two new tests pass, and each
fails when the property it checks is broken on purpose. vmalloc_oob
and kasan_strings (async and asymm) fail there with or without this
series, and a few other tests fail intermittently under QEMU. The
changed files also build on arm64 with generic and software tag-based
KASAN and without KASAN, and on x86_64 with generic KASAN and without.
The FUSE, kexec and RDS changes are build tested only, and the KUnit
tests were not run on real hardware.

Tooling: an AI coding assistant was used under the author's direction
to audit GFP_HIGHUSER callers, draft GFP_HIGHUSER_KASAN (patch 1),
the subsystem conversions (patches 2-4), the page_alloc_highuser_kasan
test (patch 7), and the revised skip-test helper (patch 6), and revise
patch 5's changelog and this cover letter. It also scripted and ran the
builds and QEMU KUnit tests above.

Feedback and thoughts -- particularly on whether any other bare
GFP_HIGHUSER caller using kmap_local_page() would prefer opting back
into KASAN via GFP_HIGHUSER_KASAN -- are very welcome.

Link: https://lore.kernel.org/r/20260519-panthor-kasan-v2-1-b7384458f076@gmail.com/ [1]
Link: https://lore.kernel.org/r/20260521105148.5497c281@fedora/ [2]

Jeff Xu (7):
  mm: add GFP_HIGHUSER_KASAN
  pipe, fuse: use GFP_HIGHUSER_KASAN for pipe buffer pages
  kexec: use GFP_HIGHUSER_KASAN for segment pages
  net/rds: use GFP_HIGHUSER_KASAN for message pages
  mm: kasan: skip KASAN for GFP_HIGHUSER
  mm/kasan/kunit: add page_alloc_skip_kasan test
  mm/kasan/kunit: add page_alloc_highuser_kasan test

 fs/fuse/dev.c             |  2 +-
 fs/pipe.c                 |  4 +--
 include/linux/gfp_types.h | 15 ++++++--
 kernel/kexec_core.c       |  2 +-
 mm/kasan/kasan_test_c.c   | 72 +++++++++++++++++++++++++++++++++++++++
 net/rds/ib_recv.c         |  2 +-
 net/rds/message.c         |  2 +-
 7 files changed, 91 insertions(+), 8 deletions(-)


base-commit: 4b028d0cedf95f66b8c5294fde2d7d698bf830da
-- 
2.56.0.611.g1030f0b940-goog

