Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B83E606A330
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 23:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=NUCthv/r
Received: by kanga.kvack.org (Postfix)
	id ED86C6B05BA; Mon, 16 Nov 2026 18:07:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E62066B05BB; Mon, 16 Nov 2026 18:07:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDCF76B05BC; Mon, 16 Nov 2026 18:07:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D96F6B05BA
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:07:03 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9059F4020B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:07:01 +0000 (UTC)
X-FDA: 85442519442.21.AC7E19F
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf18.hostedemail.com (Postfix) with ESMTP id AAE9B1C000A
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:06:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="NUCthv/r";
	spf=pass (imf18.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.215.181 as permitted sender) smtp.mailfrom=jeffxu@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794870419;
	b=Kk0a4PqHgBK3Y8+zHPjEEKQct4QggHMx4oA3DqBhtTPp5FPYE7161kf6EXJkY10BzwAil1
	GqUbyGio/Y5YDOX8RGudiMgSKMzfRVYHKKbJgcRDCmElO52d976CPWhBnvIf3EJqKW+67K
	jTrrDrVdHwHieTCurFt+8mzbFQDNsNM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="NUCthv/r";
	spf=pass (imf18.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.215.181 as permitted sender) smtp.mailfrom=jeffxu@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794870419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GHp/rfBUvBjHE1yqZXzAoWkqkfTsJ4axSlVmhZm3xoI=;
	b=6w/zlEpnfGPGkDjIrZFcJzj1rCUAQQn32zsMTsWFhjU5U4vb39pF3DfJOxKPq5L3ISnwHV
	UlM8SF1OB25t0kQZetOowxnJlxfM2yhysD9pbt5sOs4jvS685+JbWUAxYiieybS0oyuGsR
	orjbEPwpsZvuwkm41PXMqXE4D5wNGC0=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cd6b9a2735fso250718a12.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:06:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794870418; x=1795475218; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GHp/rfBUvBjHE1yqZXzAoWkqkfTsJ4axSlVmhZm3xoI=;
        b=NUCthv/rb+Kq6NHDbzbENGgDkNwTnd+xVB7gj/0uFCMpJzYlxWUY8wX14ANY7qPgPh
         KQYSd7CyjgVqgXS5d64tdYWbKFd5fMc6JwCgUT3mN+Bc+GGxit/3kFaeGoNdFvL5AVY/
         zmtjLKx4ylyXhhBQBsjMoVpdtvtBKfdx8wG0g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794870418; x=1795475218;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GHp/rfBUvBjHE1yqZXzAoWkqkfTsJ4axSlVmhZm3xoI=;
        b=cPWKaOV85xGBInyDmWKdfgHdbrzf+pa87HDp6gbk6KwuxLtTykKZHV8F8vmsE9yH9/
         xb7Jqg0ZPbrqEhRLAu9oetMW3JJ69z5uzRCzd6jXN+dvWSo2xHuTbqYSvledPfR/AcR1
         5uWR+LO2cmD0eQ/tgjJA/k9ntozT3+Wab5J6kPxgm00dS1spG62lLi7TTV5w/dlcr+7/
         u/xMRScq+3eb4OL6wowpbcRb9jG0kbn7hdZdLTF0B8ipivJcfW7ojiBpSfUL/MRIaDsC
         33n57ZgUYD+gynsUewXH5P+GW/MhD1M+FVhNwOC0v+XfFUzGC0zjYuBg3tMqefCNbcui
         12Uw==
X-Forwarded-Encrypted: i=1; AL+hErErReQ7x2Mi4fUbN2HXA8cgFHhOCZQ8THd0h/Tw+/SKcrcjy5wYs2JrrZp2iDVMIScoA0EXl7DqUg==@kvack.org
X-Gm-Message-State: APuU4Z/Tu10XbCwbj60PkfxMVeJcN0x62SXHB5v/pGYOuOoiRIWMZs6A
	hKDDUUX86f3tIPGXwdvVOndcC5DVa6IOc/1x5uAGghSp4bu2P/F1AklPm7DAjcwhIA==
X-Gm-Gg: AYBFou3MNvmethL1225o6Ou9O14r6QhumTJ8skFAD1uvCBDONX8RO2HglQUkicP0YZ7
	rdLm+a+1pzO7kn6VvLPXMQt/VgSodN2h8lG6fCJP+qvTe2p3zXVf2HRh6lX89m6CIwLqx9IOPzm
	ounerB8sWczdG3J4slzIkZ/6ay1rzpQ3xykrvx80HhYoaRN7rek6znMQqhex8/i38oTbIIySwDE
	rgZlQ5J4RDdjtYAMc4VQbnakk2yKDodxyqPZCoWEMHwB4qm8atV+uWkrPOKKhXxf9LNBZ5hB0RA
	X2FYEenjo3xP6hl4uuDzGSmj+DnVK8c3pNLzOfXtk6WeEGo0uxJnLE03X4XBULDvxxiawf4nBpZ
	5HhEdIEaTTkM5qzwWemCYaxiGwR0X2L4FUs+meaO5qoAn4ICQBrC7LrMWGw/P4oq8YVBcIjwzlz
	qvg8tMrZtshqWBheRSPOBpUWrfxYVMFjPEQazD57teU4qF7FiLw/Jl9FTZ2LqtDY6UzPXqHkrx4
	hsQtgMQa9Wz8OQf3xj8repQF6Gxw4Ej1+icXEbrP4C1XHEmNlo4Np9K3IhutWYszmyAJpAbRZrf
	GO/OkD2cbPVwMf7W3bZSxItFfQT2fe9TQ2d3piLSV7p+JIMyCqhuj3Ycyymvg33Hg+TOVzrn8lg
	8kyqVMtCBETC+cX8idg==
X-Received: by 2002:a05:6300:40d:b0:3f9:aef5:48 with SMTP id adf61e73a8af0-3f9aef5038fmr8109961637.1.1794870418391;
        Mon, 16 Nov 2026 15:06:58 -0800 (PST)
Received: from localhost (221.247.125.34.bc.googleusercontent.com. [34.125.247.221])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-8bed1a6dbd9sm4131985b3a.27.2026.11.16.15.06.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 15:06:58 -0800 (PST)
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
Subject: [PATCH v1 5/7] mm: kasan: skip KASAN for GFP_HIGHUSER
Date: Mon, 16 Nov 2026 15:06:25 -0800
Message-ID: <20261116230627.3537051-6-jeffxu@chromium.org>
X-Mailer: git-send-email 2.56.0.679.gc527c65306-goog
In-Reply-To: <20261116230627.3537051-1-jeffxu@chromium.org>
References: <20261116230627.3537051-1-jeffxu@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wgbh5h4s68jfq1iyia3ezt81uiym87oi
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AAE9B1C000A
X-HE-Tag: 1794870419-40248
X-HE-Meta: U2FsdGVkX1/QA/F+gd4Kr2mF6Farq52DatzVU24S2MB9BvCMY+Z45eUm+QXmxkJej29jfC14grPEJz6aJKhqfqgazB1f5HIG7qDRvMPNgd8y39nIx1Yb+93oH5BxgUev8pQFppMIgJA/VrNIsVGwsRgSINudrQ4e//sHbwdlhKhs06JarkzTegLQxuL29IwKGW9EfczAASzGbMpxTO67x8vsY3fHBx5Ze3iewylrHCNKUiucbyZ52rQd2ypjpm8tDa6VUfmgQF5VqQXBNLRK2LIpwIIwWEOB4xyZqiSj6g8t12CSJaoa+JCiwcQZW/9n3TIO8N2S82FNptVgFJvZ/t/MPIUTxfNDp6r7m78fK+GpbL6aywJ6mrGXmS1Oe2JfTU91kE52N98ia0bE58oJ6QXPW0KdnUwFh43SGhVHSmsYNpQOrbi4Yk/xQoZMgmtcJGQQOsaTlOfV/ImS5G7WdWi2tohVOGS8UZaXd3XxXxppVDf3z5MCESX5ZLMEDSR6YjBcTAQ+ooUiYgoPs+bIiJ4aLyW0nOBrFDOwzCK1+9cBtIs9yn4MbpUzB58x8I0uZZdoJbGv3o8giTxIrFXCf0dp3s8LfdOEmPll3bA96H106ZVPDxcl7W5BAPCTvAK7SMqxJaNEV3cVmhk5f7fTZ4zaG1W18zLFdiR7y3MKmQnz4Lc2PEevGrisrpKBEpQOACR2hksibn9AmeACBw40qklCAQRaw8cWo6z5lACLGt9wWUQn8aT2sNbEqkXHB2YgpywUL7ab0b/Ty3xGDT1FiT3lBa/jvUIYflOODPM7G0jLUc+icMK2j49hyMKkCGgOCf0It3wsPmxxMhlyo511i9ODaAjmfyGTBghdhgKn46kG0xjoxB0mZDJh3Zi2C1jgdDfDr4ha5zyqEXgGiQV8hAZIoe2Yvk4XiVlPGmN0mPNbTwgLZfmab4kWN72iNShEJehPjMDnXS70MUYxnTL
 Xrrel0OA
 kaeoUsA3fJ4ORiBKKEj7Bx9qogtRNcQpN0jDI9SurVybl1o7cZ5ODNmZiw/qFaDrogWH+jvy5qq8e+3MPp6p8p0/svZm17srhjvrBvRn8r4fUDi9JzldUT9Ia40f10uyh6GT88WkFKbuL9jQtCe06JHP7n9XErS8gWBohJcrkRkog0SFgy3iVNWGFUjDkBWb4nG/wUrRO6HSU5FHfI/oN6RJQTrxkOP1yagncvESCebj9JUZgD/EcNBSqj1MRm6An+/9LT7VP5h5P4re5R7US5e1QjAD5+fUXFmyGOOXuBaPFAJQRU+a9hmANwA7VizDGVRlLq9hnQsxa0Tlc+ybyUEHxoms5KUwGQ523X1fQlWVkMJBwdtDCp4SI3Akz0c6BeJzG5At2OHULCYj70B/WKGs6/OzJUa65vMq7Y8daWfnov2Xoe/Zs7Xq9fZtDjWb22Wv0HhWk9rLljXE9wTDL/pkm2keuyxCkqAaj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Move __GFP_SKIP_KASAN from GFP_HIGHUSER_MOVABLE to GFP_HIGHUSER so that
both GFP_HIGHUSER and GFP_HIGHUSER_MOVABLE allocations skip KASAN
unpoisoning on allocation and poisoning on free in HW_TAGS mode.

Previously, commit c275c5c6d50a ("kasan: disable freed user page
poisoning with HW tags"), commit 70c248aca9e7 ("mm: kasan: Skip
unpoisoning of user pages"), and commit 0a54864f8dfb ("kasan: remove
PG_skip_kasan_poison flag") added __GFP_SKIP_KASAN to
GFP_HIGHUSER_MOVABLE because user pages are not intended to be used as
directly addressable kernel data structures, and the lower likelihood of
catching a kernel linear-map bug on user payload pages does not justify
tagging all 256 16-byte MTE granules per 4 KB page on every allocation
and free.

GFP_HIGHUSER shares the same kernel-accessibility contract in
include/linux/gfp_types.h ("for userspace allocations that may be mapped
to userspace, do not need to be directly accessible by the kernel but
that cannot move once in use"). The only semantic difference between
GFP_HIGHUSER and GFP_HIGHUSER_MOVABLE is __GFP_MOVABLE.

For every 4 KB page without __GFP_SKIP_KASAN under CONFIG_KASAN_HW_TAGS,
mte_set_mem_tag_range() tags all 256 16-byte MTE granules (via STG/STZG
and DC GVA/GZVA) on allocation (__kasan_unpoison_pages) and again on
free (__kasan_poison_pages). For users of GFP_HIGHUSER, this can
significantly impact performance when allocating and freeing large
buffers. For example, in graphics and interactive UI workloads, large
DMA-BUF and DRM/GPU buffers are allocated with GFP_HIGHUSER: while
steady-state rendering reuses swapchain buffers, UI window resizes,
surface creation/teardown, and app or scene launches synchronously
allocate and release tens to hundreds of megabytes of DMA-BUF
framebuffers (~32 MB per 4K RGBA frame, or ~96 MB for a triple-buffered
surface) and GPU shmem pools directly on UI, compositor, and render
threads. Touching millions of 16-byte granules stalls these critical
threads for milliseconds per buffer, a significant share of the 8.3 ms
(120 Hz) / 16.7 ms (60 Hz) frame budget, while polluting CPU L1/L2 data
and MTE tag caches, evicting hot working-set cachelines, and saturating
DRAM bandwidth (especially on free when DMA pages are cold in the CPU
cache).

GFP_HIGHUSER is used by subsystems such as the DMA-BUF system heap, DRM
GEM shmem/TTM and non-movable HugeTLB. They use it instead of
GFP_HIGHUSER_MOVABLE only because their pages are pinned for DMA or
cannot migrate.

What skipping KASAN means for the kernel's own accesses to these pages:

- Through vmap(): nothing changes. With CONFIG_KASAN_HW_TAGS those
  pointers already carry the match-all tag, so the page tags never
  protected these accesses.
- Through kmap_local_page() or page_address() (for example ramfs):
  post_alloc_hook() now gives the pages the match-all tag, so these
  accesses are no longer checked. GFP_HIGHUSER_MOVABLE pages already
  behave this way. Callers that want to keep the checks use
  GFP_HIGHUSER_KASAN: the previous patches in this series converted
  pipe, FUSE, kexec and RDS, and backports of this patch should
  include them.

Slab allocations cannot use GFP_HIGHUSER, because they do not accept
__GFP_HIGHMEM. GFP_KERNEL, GFP_USER and vmalloc() allocations are not
affected.

This patch does not address the false-positive KASAN report after shmem
swap-in readahead with MTE that was reported on drm/panthor [1, 2].
There, swap_cluster_readahead() allocates swap-cache folios for
neighboring swap slots with the gfp mask of the shmem mapping being
swapped in. If such a slot holds a page that userspace maps with
PROT_MTE, the folio keeps a KASAN tag in page->flags that does not
match the userspace tags restored by arch_swap_restore().

This patch only removes one way to hit it: shmem mappings that use
GFP_HIGHUSER (such as drm_gem_shmem_helper or panthor) now pass
__GFP_SKIP_KASAN to readahead, so the neighboring folios no longer get
a KASAN tag. The readahead path itself is unchanged, and shmem mappings
with other gfp masks that lack __GFP_SKIP_KASAN can still trigger the
report. That issue should be followed up separately, for example in
[1].

On an Armv9.2-A device running a 6.12-based kernel with kasan.mode=sync,
this reduces the allocation + release time of a ~32 MB buffer from
/dev/dma_heap/system by ~80%: allocation is ~59% faster and release ~98%
faster. Poisoning on free accounted for ~55% of the total before. In an
application loading benchmark, the OpenGL score improves by 15-23%,
recovering 60-80% of the regression that enabling MTE causes.

Link: https://lore.kernel.org/r/20260519-panthor-kasan-v2-1-b7384458f076@gmail.com/ [1]
Link: https://lore.kernel.org/r/20260521105148.5497c281@fedora/ [2]
Assisted-by: LLM
Signed-off-by: Jeff Xu <jeffxu@chromium.org>
---
 include/linux/gfp_types.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
index 567c93fc1cfb..bcc4827deb4c 100644
--- a/include/linux/gfp_types.h
+++ b/include/linux/gfp_types.h
@@ -386,9 +386,9 @@ enum {
 #define GFP_USER	(__GFP_RECLAIM | __GFP_IO | __GFP_FS | __GFP_HARDWALL)
 #define GFP_DMA		__GFP_DMA
 #define GFP_DMA32	__GFP_DMA32
-#define GFP_HIGHUSER	(GFP_USER | __GFP_HIGHMEM)
+#define GFP_HIGHUSER	(GFP_USER | __GFP_HIGHMEM | __GFP_SKIP_KASAN)
 #define GFP_HIGHUSER_KASAN	(GFP_USER | __GFP_HIGHMEM)
-#define GFP_HIGHUSER_MOVABLE	(GFP_HIGHUSER | __GFP_MOVABLE | __GFP_SKIP_KASAN)
+#define GFP_HIGHUSER_MOVABLE	(GFP_HIGHUSER | __GFP_MOVABLE)
 #define GFP_TRANSHUGE_LIGHT	((GFP_HIGHUSER_MOVABLE | __GFP_COMP | \
 			 __GFP_NOMEMALLOC | __GFP_NOWARN) & ~__GFP_RECLAIM)
 #define GFP_TRANSHUGE	(GFP_TRANSHUGE_LIGHT | __GFP_DIRECT_RECLAIM)
-- 
2.56.0.611.g1030f0b940-goog


