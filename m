Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 612B11061B2B
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 11:13:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A37DB6B008C; Tue, 31 Mar 2026 07:13:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E8F06B0095; Tue, 31 Mar 2026 07:13:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D6D86B0096; Tue, 31 Mar 2026 07:13:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 759256B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:13:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 21E281B8E64
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:13:44 +0000 (UTC)
X-FDA: 84606097968.13.2B3F6AE
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf22.hostedemail.com (Postfix) with ESMTP id 45B64C000F
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:13:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="iRy/8V6O";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3ZKzLaQUKCEEhoyhujrrjoh.frpolqx0-ppnydfn.ruj@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3ZKzLaQUKCEEhoyhujrrjoh.frpolqx0-ppnydfn.ruj@flex--elver.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774955622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=D/S7iVczJ0MEwQfPuMb0KszemegRr23Tc4ucFBvZfLA=;
	b=qWzvUruSV0EJjFll+UGagJpwTeBDPUr74DiuNFqsDB+Iieb/DeQZh0sTbVt9YnyN9PgsdW
	5bNDCy/V4Aq9cNjeX4DgYyyrnTsVe7ysgqC3ffQWiExtjxrEOPygwnHBsgnSBazsPfTke/
	VqRHaHdsyJhBdX+WznbDBx12FTTSxYY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774955622; a=rsa-sha256;
	cv=none;
	b=BU2dBr7DX6cbwRqQJLp/Umsi70rxhr1k6SIlI2k+NTXllAaqX8EnTK+SzkIi5r7FEztWoV
	KYitIAY4LP7av910hIxyM83R0J/y4HV/f8Mrw2et/1X7qEaRWzHs4PfEIyqJptbAZbdw/E
	ZFzjb1LAcPzBe6hgqCzJV4tDoWsQK6M=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="iRy/8V6O";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3ZKzLaQUKCEEhoyhujrrjoh.frpolqx0-ppnydfn.ruj@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3ZKzLaQUKCEEhoyhujrrjoh.frpolqx0-ppnydfn.ruj@flex--elver.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48378df3469so38376115e9.1
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774955621; x=1775560421; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=D/S7iVczJ0MEwQfPuMb0KszemegRr23Tc4ucFBvZfLA=;
        b=iRy/8V6OGyijNSoT/pGqNF/TVngKg3JbHu8JdfdM303E0G9MOdNWvveK8T5qjNs7PA
         rdLtFjOtlO/irLuW9zDN2gDPfapJte7wx5Pwh0g6UWRRDB1hzVJiVFBBQhhqQkXc1y+r
         bwF+IMfiQuGzgkdwi60U5EB8btrfv1VNaw2NFkyMTn+JKPI18z2qlCnPV4N3/6nRjeIU
         fYMp6bZ1ZlxwDVxOOY7XlbYg2jeaojogGWoh1/UBqt0aPD0+PORTzl9vSzh1Ef5gaJKU
         u1jQ7k4zZrj0PfQytVcMIEDxW1TRplRZDOevR03IMTXX93zbN3lxxa0zH6dP7s/ej2lg
         G1mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774955621; x=1775560421;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D/S7iVczJ0MEwQfPuMb0KszemegRr23Tc4ucFBvZfLA=;
        b=IWlym45TK9glHma/GVWwepvulFbXTwiiawnG2/jN5nRfexRNZt5QDmtLCf7/SVoXqp
         +D7sl0f+Ni1o21Zy0oyAA6GG1KzB9hz2zYcMoCGS9hWFqV4YdaOcQZi2ZEz4ODc7zFFw
         HhYJx0IGeoDNNiTCON8mX+kcfrrYzAmkOS53rFrSrWmUXZ6EhbAt0H41p6A/zrtxHOCP
         GPtP2cDVlaVBLLZ667vqK0veK+HnYHBljv8771Th34ACIJ7m7ea1MEAV0wuFi2GfwZPB
         CLECU4fv8FZRyOOy9MPznzuPkaY/E1U3pEjjoVl9++OP1PJes/N9xL+Mu+88OB7TjPdP
         MhMQ==
X-Forwarded-Encrypted: i=1; AJvYcCV2QbK9YGoaHNnutgWv0Ilq6hx6fgSyOMydx8DlMmSIDCN2sPQiWomjqACppVfS0CPxhc0yQRW/2A==@kvack.org
X-Gm-Message-State: AOJu0YzolLxxhUje8KcXwBG4o9Y4/VhQx66ejc87qJkKbsgI9nj4h3Q6
	nJVCu26zDd+vDPHJhJ0Q/iUMNzO1VCQCXNdMLLV14ZrVpNmHWvrnh2mmOAKg1UOVPR5INs3pQhv
	vcg==
X-Received: from wmcx8-n1.prod.google.com ([2002:a05:600c:c1c8:10b0:487:34a1:234c])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:468b:b0:485:3989:b3e4
 with SMTP id 5b1f17b1804b1-4887828a552mr51660205e9.6.1774955620458; Tue, 31
 Mar 2026 04:13:40 -0700 (PDT)
Date: Tue, 31 Mar 2026 13:12:27 +0200
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260331111240.153913-1-elver@google.com>
Subject: [PATCH v1] slab: support for compiler-assisted type-based slab cache partitioning
From: Marco Elver <elver@google.com>
To: elver@google.com, Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, Harry Yoo <harry.yoo@oracle.com>, 
	Hao Li <hao.li@linux.dev>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, kasan-dev@googlegroups.com, 
	llvm@lists.linux.dev, Andrey Konovalov <andreyknvl@gmail.com>, 
	Florent Revest <revest@google.com>, GONG Ruiqi <gongruiqi@huaweicloud.com>, 
	Jann Horn <jannh@google.com>, KP Singh <kpsingh@kernel.org>, 
	Matteo Rizzo <matteorizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 45B64C000F
X-Stat-Signature: m3bst1zjrncfxmg75pbq546zzuopnnf4
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774955622-571069
X-HE-Meta: U2FsdGVkX1/0bZ3jY0WsmsGIHW1CM4rfYdDHZ4QruBk8fytXqIy3r2LKbNrr+SkqlNQ6ZZ/sVR0lzjUyZRqQ0EegYaLqNIeG7D8dkD8lBYsJVZZ9e75ycbzne6mH8YjBgAEBKGgUo0Snba+EQliiF3Hojoseek2gaITqeKIiol9jwYIi/g/ws1QgwM4i9jL9vjflvKe/gzEtVbmr17wa84gjLRKON99qeCKmQ4Sdo4Q2GDOO0Z0lb98eneTEMLfc8zEz7CS9RwCHQ/HfH37jJbZMBJ7CCDR9uO3HCK2lOVMaHnwB1WCL/CQ7fS2ioon4GOET+aVzEBNmFJIFxlVlCOib1FS8d7BNLUSdmW7ooxvLPBzJhjHS/JvoPyhPMPOVOUaUtX/jWz6S4guA+a2e9vgh/wAgX8ee0Qfzl2UCWWaIXGMLGvKumyBKQ+glr2u5Tx9PuAoyENlQVMYytLEJOcsYTAxiiy6JBFIifim23TLTKz0jwZR56STe7S77hPdo6nPWhItZLi+4TMgwgONel7g9rV6P263opPVBG2UEkN+Rl3JcNAQApj923aafflB6kJ2lwawU7gHzDBBqrgRLVVWCa57ZJrlU+8xbMW8ZRunszJbZplVQ7t0272MpvX4X0rYzZdX1sQs1bsvg/Bg5QKw/lOWBv5ThZNL/6cV1ucXdFq4hStKAdlNc0uRynoH5lofbG+NxN1WgeAY6z9t2mus8CpdDVjLhuY0D0iKyhrdFAX181kJf3WqETN6FJ96KpCSvNJZ0H1Ojxl4K4DR1tHhShxV9AUw0IQ35eP7f0nCnnMlBXAQh+1jIqEmFztS5HNrGOxm4E5ieJAowD8hUlUShjxKsUrxDsEyPgzMZJnPyM6KlRrnWh0s4NLNva5URcoFpmaJS9ckLZX06+F9dsSMyDBzDPboE2ZxCA+eTFYbBnwMezx6AnHXbfmyh4djBCUPzlcR4tkZ9bAGhScK
 J2llL26s
 gyBaFqAd+yHHExoKgjkumB+g/HLtUGZptxhSpICPi1vKKW+Q8gKLH7yF4ZfP+ywLFRfMASzXNropAIX+YJ0fgZP/gIvFhBV0zgHhgP6QbA/6SYuBjihi7SvUXycLNVYOFjziePlJaqPE81XN9bHe87eac4A3YfYn2TS5LxQcKodLCLB/fw0FLRXA1l6H8EpHUyA8hg0ronxGaqOn9sKX6GuruOhfnxOXaA4cAfNKVT8hqBp+N3Mj9KIjKgJwQP2DvvoZXI20JK3BI+JJxhTc5DQnNp94T8R7+2/hJQhkXh230BJC5yacIqEb4hW2VcK6hUqfyUU5bIATpB8ubs9V6LU6IA5M1NmBXMGE6zIrL/NdLvj5WnYAkVIaKF6zLN9K4M+KsfmeLOF/XXb9JBOKrZrlup9TZ1iw310jtITXByO3vpd/YuaTH9PW/cdowFqssU0KxPiVood4cc2Z0UZuq/m3fs2nRW6RBoB8sa4wo6xifOFr3+qPjvMT/fACBye0Cdj9VkzEURVaZ8TAySG7Q1aFIUnvMaYkTBpDsfFbWdWoD5GDtKBtIVz71PckHMEU07FiwVvNTCV1OW1+DEwKA4nsKdch+Ds6fXc1rJvbVMWX/UHHhYLvLFN14FyqI7dTdbyAfsh0IUdZ0N184CfpIvC8iZ7e0Fo7qSdc2+gTS5kcg6jAzTd2+Qly+MrfQ/LTp+nJJsc8cFr/gIWUP21GNFCsvfr7j+B6TF+TDwjx9t7kRbdkFYH7KvuQ5pGiJGzTN+2Y4jK2QydnaNELmqcQQrZv2S3AukV9OLpKkAfxWJe4PkIMlB5HFB/JjVZw5avJudPOWHG2C2QUc+QKCg/1WJCcjHaNKU0WdaKmiBEsMmGPbSBFkz34yWXJljBFbSwGFSAfObrRc0OsQK1ksyU+SlBuwGtGfyuJSJy+4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rework the general infrastructure around RANDOM_KMALLOC_CACHES into more
flexible PARTITION_KMALLOC_CACHES, with the former being a partitioning
mode of the latter.

Introduce a new mode, TYPED_KMALLOC_CACHES, which leverages a feature
available in Clang 22 and later, called "allocation tokens" via
__builtin_infer_alloc_token [1]. Unlike RANDOM_KMALLOC_CACHES, this mode
deterministically assigns a slab cache to an allocation of type T,
regardless of allocation site.

The builtin __builtin_infer_alloc_token(<malloc-args>, ...) instructs
the compiler to infer an allocation type from arguments commonly passed
to memory-allocating functions and returns a type-derived token ID. The
implementation passes kmalloc-args to the builtin: the compiler performs
best-effort type inference, and then recognizes common patterns such as
`kmalloc(sizeof(T), ...)`, `kmalloc(sizeof(T) * n, ...)`, but also
`(T *)kmalloc(...)`. Where the compiler fails to infer a type the
fallback token (default: 0) is chosen.

Note: kmalloc_obj(..) APIs fix the pattern how size and result type are
expressed, and therefore ensures there's not much drift in which
patterns the compiler needs to recognize. Specifically, kmalloc_obj()
and friends expand to `(TYPE *)KMALLOC(__obj_size, GFP)`, which the
compiler recognizes via the cast to TYPE*.

Clang's default token ID calculation is described as [1]:

   typehashpointersplit: This mode assigns a token ID based on the hash
   of the allocated type's name, where the top half ID-space is reserved
   for types that contain pointers and the bottom half for types that do
   not contain pointers.

Separating pointer-containing objects from pointerless objects and data
allocations can help mitigate certain classes of memory corruption
exploits [2]: attackers who gains a buffer overflow on a primitive
buffer cannot use it to directly corrupt pointers or other critical
metadata in an object residing in a different, isolated heap region.

It is important to note that heap isolation strategies offer a
best-effort approach, and do not provide a 100% security guarantee,
albeit achievable at relatively low performance cost. Note that this
also does not prevent cross-cache attacks, and SLAB_VIRTUAL [3] should
be used as a complementary mitigation (once available).

With all that, my kernel (x86 defconfig) shows me a histogram of slab
cache object distribution per /proc/slabinfo (after boot):

  <slab cache>      <objs> <hist>
  kmalloc-part-15    1537  +++++++++++++++
  kmalloc-part-14    2996  +++++++++++++++++++++++++++++
  kmalloc-part-13    1555  +++++++++++++++
  kmalloc-part-12    1045  ++++++++++
  kmalloc-part-11    1717  +++++++++++++++++
  kmalloc-part-10    1489  ++++++++++++++
  kmalloc-part-09     851  ++++++++
  kmalloc-part-08     710  +++++++
  kmalloc-part-07     100  +
  kmalloc-part-06     217  ++
  kmalloc-part-05     105  +
  kmalloc-part-04    4047  ++++++++++++++++++++++++++++++++++++++++
  kmalloc-part-03     276  ++
  kmalloc-part-02     283  ++
  kmalloc-part-01     316  +++
  kmalloc            1599  +++++++++++++++

The above /proc/slabinfo snapshot shows me there are 6943 allocated
objects (slabs 00 - 07) that the compiler claims contain no pointers or
it was unable to infer the type of, and 11900 objects that contain
pointers (slabs 08 - 15). On a whole, this looks relatively sane.

Additionally, when I compile my kernel with -Rpass=alloc-token, which
provides diagnostics where (after dead-code elimination) type inference
failed, I see 179 allocation sites where the compiler failed to identify
a type (down from 966 when I sent the RFC [4]). Some initial review
confirms these are mostly variable sized buffers, but also include
structs with trailing flexible length arrays.

Link: https://clang.llvm.org/docs/AllocToken.html [1]
Link: https://blog.dfsec.com/ios/2025/05/30/blasting-past-ios-18/ [2]
Link: https://lwn.net/Articles/944647/ [3]
Link: https://lore.kernel.org/all/20250825154505.1558444-1-elver@google.com/ [4]
Link: https://discourse.llvm.org/t/rfc-a-framework-for-allocator-partitioning-hints/87434
Signed-off-by: Marco Elver <elver@google.com>
---
Changelog:
v1:
* Rebase and switch to builtin name that was released in Clang 22.
* Keep RANDOM_KMALLOC_CACHES the default.

RFC: https://lore.kernel.org/all/20250825154505.1558444-1-elver@google.com/
---
 Makefile                        |  5 ++
 include/linux/percpu.h          |  2 +-
 include/linux/slab.h            | 94 ++++++++++++++++++++-------------
 kernel/configs/hardening.config |  2 +-
 mm/Kconfig                      | 45 ++++++++++++----
 mm/kfence/kfence_test.c         |  4 +-
 mm/slab.h                       |  4 +-
 mm/slab_common.c                | 48 ++++++++---------
 mm/slub.c                       | 31 +++++------
 9 files changed, 144 insertions(+), 91 deletions(-)

diff --git a/Makefile b/Makefile
index 2294decf0afc..93bb704bbf0e 100644
--- a/Makefile
+++ b/Makefile
@@ -957,6 +957,11 @@ KBUILD_CFLAGS	+= $(CC_AUTO_VAR_INIT_ZERO_ENABLER)
 endif
 endif
 
+ifdef CONFIG_TYPED_KMALLOC_CACHES
+# PARTITION_KMALLOC_CACHES_NR + 1
+KBUILD_CFLAGS	+= -falloc-token-max=16
+endif
+
 ifdef CONFIG_CC_IS_CLANG
 ifdef CONFIG_CC_HAS_COUNTED_BY_PTR
 KBUILD_CFLAGS	+= -fexperimental-late-parse-attributes
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 85bf8dd9f087..271b41be314d 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -36,7 +36,7 @@
 #define PCPU_BITMAP_BLOCK_BITS		(PCPU_BITMAP_BLOCK_SIZE >>	\
 					 PCPU_MIN_ALLOC_SHIFT)
 
-#ifdef CONFIG_RANDOM_KMALLOC_CACHES
+#ifdef CONFIG_PARTITION_KMALLOC_CACHES
 # if defined(CONFIG_LOCKDEP) && !defined(CONFIG_PAGE_SIZE_4KB)
 # define PERCPU_DYNAMIC_SIZE_SHIFT      13
 # else
diff --git a/include/linux/slab.h b/include/linux/slab.h
index 15a60b501b95..c0bf00ee6025 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -612,10 +612,10 @@ static inline unsigned int arch_slab_minalign(void)
 #define SLAB_OBJ_MIN_SIZE      (KMALLOC_MIN_SIZE < 16 ? \
                                (KMALLOC_MIN_SIZE) : 16)
 
-#ifdef CONFIG_RANDOM_KMALLOC_CACHES
-#define RANDOM_KMALLOC_CACHES_NR	15 // # of cache copies
+#ifdef CONFIG_PARTITION_KMALLOC_CACHES
+#define PARTITION_KMALLOC_CACHES_NR	15 // # of cache copies
 #else
-#define RANDOM_KMALLOC_CACHES_NR	0
+#define PARTITION_KMALLOC_CACHES_NR	0
 #endif
 
 /*
@@ -634,8 +634,8 @@ enum kmalloc_cache_type {
 #ifndef CONFIG_MEMCG
 	KMALLOC_CGROUP = KMALLOC_NORMAL,
 #endif
-	KMALLOC_RANDOM_START = KMALLOC_NORMAL,
-	KMALLOC_RANDOM_END = KMALLOC_RANDOM_START + RANDOM_KMALLOC_CACHES_NR,
+	KMALLOC_PARTITION_START = KMALLOC_NORMAL,
+	KMALLOC_PARTITION_END = KMALLOC_PARTITION_START + PARTITION_KMALLOC_CACHES_NR,
 #ifdef CONFIG_SLUB_TINY
 	KMALLOC_RECLAIM = KMALLOC_NORMAL,
 #else
@@ -662,9 +662,20 @@ extern kmem_buckets kmalloc_caches[NR_KMALLOC_TYPES];
 	(IS_ENABLED(CONFIG_ZONE_DMA)   ? __GFP_DMA : 0) |	\
 	(IS_ENABLED(CONFIG_MEMCG) ? __GFP_ACCOUNT : 0))
 
+#ifdef CONFIG_RANDOM_KMALLOC_CACHES
 extern unsigned long random_kmalloc_seed;
+typedef struct { unsigned long ip; } kmalloc_token_t;
+#define __kmalloc_token(...) ((kmalloc_token_t) { .ip = _RET_IP_ })
+#elif defined(CONFIG_TYPED_KMALLOC_CACHES)
+typedef struct { unsigned long v; } kmalloc_token_t;
+#define __kmalloc_token(...) ((kmalloc_token_t){ .v = __builtin_infer_alloc_token(__VA_ARGS__) })
+#else
+/* no-op */
+typedef struct {} kmalloc_token_t;
+#define __kmalloc_token(...) ((kmalloc_token_t){})
+#endif
 
-static __always_inline enum kmalloc_cache_type kmalloc_type(gfp_t flags, unsigned long caller)
+static __always_inline enum kmalloc_cache_type kmalloc_type(gfp_t flags, kmalloc_token_t token)
 {
 	/*
 	 * The most common case is KMALLOC_NORMAL, so test for it
@@ -672,9 +683,11 @@ static __always_inline enum kmalloc_cache_type kmalloc_type(gfp_t flags, unsigne
 	 */
 	if (likely((flags & KMALLOC_NOT_NORMAL_BITS) == 0))
 #ifdef CONFIG_RANDOM_KMALLOC_CACHES
-		/* RANDOM_KMALLOC_CACHES_NR (=15) copies + the KMALLOC_NORMAL */
-		return KMALLOC_RANDOM_START + hash_64(caller ^ random_kmalloc_seed,
-						      ilog2(RANDOM_KMALLOC_CACHES_NR + 1));
+		/* PARTITION_KMALLOC_CACHES_NR (=15) copies + the KMALLOC_NORMAL */
+		return KMALLOC_PARTITION_START + hash_64(token.ip ^ random_kmalloc_seed,
+							 ilog2(PARTITION_KMALLOC_CACHES_NR + 1));
+#elif defined(CONFIG_TYPED_KMALLOC_CACHES)
+		return KMALLOC_PARTITION_START + token.v;
 #else
 		return KMALLOC_NORMAL;
 #endif
@@ -864,10 +877,10 @@ unsigned int kmem_cache_sheaf_size(struct slab_sheaf *sheaf);
  * with the exception of kunit tests
  */
 
-void *__kmalloc_noprof(size_t size, gfp_t flags)
+void *__kmalloc_noprof(size_t size, gfp_t flags, kmalloc_token_t token)
 				__assume_kmalloc_alignment __alloc_size(1);
 
-void *__kmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node)
+void *__kmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node, kmalloc_token_t token)
 				__assume_kmalloc_alignment __alloc_size(1);
 
 void *__kmalloc_cache_noprof(struct kmem_cache *s, gfp_t flags, size_t size)
@@ -938,7 +951,7 @@ void *__kmalloc_large_node_noprof(size_t size, gfp_t flags, int node)
  *	Try really hard to succeed the allocation but fail
  *	eventually.
  */
-static __always_inline __alloc_size(1) void *kmalloc_noprof(size_t size, gfp_t flags)
+static __always_inline __alloc_size(1) void *_kmalloc_noprof(size_t size, gfp_t flags, kmalloc_token_t token)
 {
 	if (__builtin_constant_p(size) && size) {
 		unsigned int index;
@@ -948,14 +961,16 @@ static __always_inline __alloc_size(1) void *kmalloc_noprof(size_t size, gfp_t f
 
 		index = kmalloc_index(size);
 		return __kmalloc_cache_noprof(
-				kmalloc_caches[kmalloc_type(flags, _RET_IP_)][index],
+				kmalloc_caches[kmalloc_type(flags, token)][index],
 				flags, size);
 	}
-	return __kmalloc_noprof(size, flags);
+	return __kmalloc_noprof(size, flags, token);
 }
+#define kmalloc_noprof(...)			_kmalloc_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
 #define kmalloc(...)				alloc_hooks(kmalloc_noprof(__VA_ARGS__))
 
-void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node);
+void *_kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node, kmalloc_token_t token);
+#define kmalloc_nolock_noprof(...)		_kmalloc_nolock_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
 #define kmalloc_nolock(...)			alloc_hooks(kmalloc_nolock_noprof(__VA_ARGS__))
 
 /**
@@ -1060,12 +1075,12 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node);
 	__alloc_flex(kvzalloc, default_gfp(__VA_ARGS__), typeof(P), FAM, COUNT)
 
 #define kmem_buckets_alloc(_b, _size, _flags)	\
-	alloc_hooks(__kmalloc_node_noprof(PASS_BUCKET_PARAMS(_size, _b), _flags, NUMA_NO_NODE))
+	alloc_hooks(__kmalloc_node_noprof(PASS_BUCKET_PARAMS(_size, _b), _flags, NUMA_NO_NODE, __kmalloc_token(_size)))
 
 #define kmem_buckets_alloc_track_caller(_b, _size, _flags)	\
-	alloc_hooks(__kmalloc_node_track_caller_noprof(PASS_BUCKET_PARAMS(_size, _b), _flags, NUMA_NO_NODE, _RET_IP_))
+	alloc_hooks(__kmalloc_node_track_caller_noprof(PASS_BUCKET_PARAMS(_size, _b), _flags, NUMA_NO_NODE, _RET_IP_, __kmalloc_token(_size)))
 
-static __always_inline __alloc_size(1) void *kmalloc_node_noprof(size_t size, gfp_t flags, int node)
+static __always_inline __alloc_size(1) void *_kmalloc_node_noprof(size_t size, gfp_t flags, int node, kmalloc_token_t token)
 {
 	if (__builtin_constant_p(size) && size) {
 		unsigned int index;
@@ -1075,11 +1090,12 @@ static __always_inline __alloc_size(1) void *kmalloc_node_noprof(size_t size, gf
 
 		index = kmalloc_index(size);
 		return __kmalloc_cache_node_noprof(
-				kmalloc_caches[kmalloc_type(flags, _RET_IP_)][index],
+				kmalloc_caches[kmalloc_type(flags, token)][index],
 				flags, node, size);
 	}
-	return __kmalloc_node_noprof(PASS_BUCKET_PARAMS(size, NULL), flags, node);
+	return __kmalloc_node_noprof(PASS_BUCKET_PARAMS(size, NULL), flags, node, token);
 }
+#define kmalloc_node_noprof(...)		_kmalloc_node_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
 #define kmalloc_node(...)			alloc_hooks(kmalloc_node_noprof(__VA_ARGS__))
 
 /**
@@ -1088,14 +1104,15 @@ static __always_inline __alloc_size(1) void *kmalloc_node_noprof(size_t size, gf
  * @size: element size.
  * @flags: the type of memory to allocate (see kmalloc).
  */
-static inline __alloc_size(1, 2) void *kmalloc_array_noprof(size_t n, size_t size, gfp_t flags)
+static inline __alloc_size(1, 2) void *_kmalloc_array_noprof(size_t n, size_t size, gfp_t flags, kmalloc_token_t token)
 {
 	size_t bytes;
 
 	if (unlikely(check_mul_overflow(n, size, &bytes)))
 		return NULL;
-	return kmalloc_noprof(bytes, flags);
+	return _kmalloc_noprof(bytes, flags, token);
 }
+#define kmalloc_array_noprof(...)		_kmalloc_array_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
 #define kmalloc_array(...)			alloc_hooks(kmalloc_array_noprof(__VA_ARGS__))
 
 /**
@@ -1138,9 +1155,9 @@ static inline __realloc_size(2, 3) void * __must_check krealloc_array_noprof(voi
 #define kcalloc(n, size, flags)		kmalloc_array(n, size, (flags) | __GFP_ZERO)
 
 void *__kmalloc_node_track_caller_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node,
-					 unsigned long caller) __alloc_size(1);
+					 unsigned long caller, kmalloc_token_t token) __alloc_size(1);
 #define kmalloc_node_track_caller_noprof(size, flags, node, caller) \
-	__kmalloc_node_track_caller_noprof(PASS_BUCKET_PARAMS(size, NULL), flags, node, caller)
+	__kmalloc_node_track_caller_noprof(PASS_BUCKET_PARAMS(size, NULL), flags, node, caller, __kmalloc_token(size))
 #define kmalloc_node_track_caller(...)		\
 	alloc_hooks(kmalloc_node_track_caller_noprof(__VA_ARGS__, _RET_IP_))
 
@@ -1157,17 +1174,18 @@ void *__kmalloc_node_track_caller_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flag
 #define kmalloc_track_caller_noprof(...)	\
 		kmalloc_node_track_caller_noprof(__VA_ARGS__, NUMA_NO_NODE, _RET_IP_)
 
-static inline __alloc_size(1, 2) void *kmalloc_array_node_noprof(size_t n, size_t size, gfp_t flags,
-							  int node)
+static inline __alloc_size(1, 2) void *_kmalloc_array_node_noprof(size_t n, size_t size, gfp_t flags,
+								  int node, kmalloc_token_t token)
 {
 	size_t bytes;
 
 	if (unlikely(check_mul_overflow(n, size, &bytes)))
 		return NULL;
 	if (__builtin_constant_p(n) && __builtin_constant_p(size))
-		return kmalloc_node_noprof(bytes, flags, node);
-	return __kmalloc_node_noprof(PASS_BUCKET_PARAMS(bytes, NULL), flags, node);
+		return _kmalloc_node_noprof(bytes, flags, node, token);
+	return __kmalloc_node_noprof(PASS_BUCKET_PARAMS(bytes, NULL), flags, node, token);
 }
+#define kmalloc_array_node_noprof(...)		_kmalloc_array_node_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
 #define kmalloc_array_node(...)			alloc_hooks(kmalloc_array_node_noprof(__VA_ARGS__))
 
 #define kcalloc_node(_n, _size, _flags, _node)	\
@@ -1183,39 +1201,43 @@ static inline __alloc_size(1, 2) void *kmalloc_array_node_noprof(size_t n, size_
  * @size: how many bytes of memory are required.
  * @flags: the type of memory to allocate (see kmalloc).
  */
-static inline __alloc_size(1) void *kzalloc_noprof(size_t size, gfp_t flags)
+static inline __alloc_size(1) void *_kzalloc_noprof(size_t size, gfp_t flags, kmalloc_token_t token)
 {
-	return kmalloc_noprof(size, flags | __GFP_ZERO);
+	return _kmalloc_noprof(size, flags | __GFP_ZERO, token);
 }
+#define kzalloc_noprof(...)			_kzalloc_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
 #define kzalloc(...)				alloc_hooks(kzalloc_noprof(__VA_ARGS__))
 #define kzalloc_node(_size, _flags, _node)	kmalloc_node(_size, (_flags)|__GFP_ZERO, _node)
 
 void *__kvmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), unsigned long align,
-			     gfp_t flags, int node) __alloc_size(1);
+			     gfp_t flags, int node, kmalloc_token_t token) __alloc_size(1);
 #define kvmalloc_node_align_noprof(_size, _align, _flags, _node)	\
-	__kvmalloc_node_noprof(PASS_BUCKET_PARAMS(_size, NULL), _align, _flags, _node)
+	__kvmalloc_node_noprof(PASS_BUCKET_PARAMS(_size, NULL), _align, _flags, _node, __kmalloc_token(_size))
 #define kvmalloc_node_align(...)		\
 	alloc_hooks(kvmalloc_node_align_noprof(__VA_ARGS__))
 #define kvmalloc_node(_s, _f, _n)		kvmalloc_node_align(_s, 1, _f, _n)
+#define kvmalloc_node_noprof(size, flags, node)	\
+	kvmalloc_node_align_noprof(size, 1, flags, node)
 #define kvmalloc(...)				kvmalloc_node(__VA_ARGS__, NUMA_NO_NODE)
+#define kvmalloc_noprof(_size, _flags)		kvmalloc_node_noprof(_size, _flags, NUMA_NO_NODE)
 #define kvzalloc(_size, _flags)			kvmalloc(_size, (_flags)|__GFP_ZERO)
 
 #define kvzalloc_node(_size, _flags, _node)	kvmalloc_node(_size, (_flags)|__GFP_ZERO, _node)
 
 #define kmem_buckets_valloc(_b, _size, _flags)	\
-	alloc_hooks(__kvmalloc_node_noprof(PASS_BUCKET_PARAMS(_size, _b), 1, _flags, NUMA_NO_NODE))
+	alloc_hooks(__kvmalloc_node_noprof(PASS_BUCKET_PARAMS(_size, _b), 1, _flags, NUMA_NO_NODE, __kmalloc_token(_size)))
 
 static inline __alloc_size(1, 2) void *
-kvmalloc_array_node_noprof(size_t n, size_t size, gfp_t flags, int node)
+_kvmalloc_array_node_noprof(size_t n, size_t size, gfp_t flags, int node, kmalloc_token_t token)
 {
 	size_t bytes;
 
 	if (unlikely(check_mul_overflow(n, size, &bytes)))
 		return NULL;
 
-	return kvmalloc_node_align_noprof(bytes, 1, flags, node);
+	return __kvmalloc_node_noprof(PASS_BUCKET_PARAMS(bytes, NULL), 1, flags, node, token);
 }
-
+#define kvmalloc_array_node_noprof(...)		_kvmalloc_array_node_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
 #define kvmalloc_array_noprof(...)		kvmalloc_array_node_noprof(__VA_ARGS__, NUMA_NO_NODE)
 #define kvcalloc_node_noprof(_n,_s,_f,_node)	kvmalloc_array_node_noprof(_n,_s,(_f)|__GFP_ZERO,_node)
 #define kvcalloc_noprof(...)			kvcalloc_node_noprof(__VA_ARGS__, NUMA_NO_NODE)
diff --git a/kernel/configs/hardening.config b/kernel/configs/hardening.config
index 7c3924614e01..2963b6bd890f 100644
--- a/kernel/configs/hardening.config
+++ b/kernel/configs/hardening.config
@@ -22,7 +22,7 @@ CONFIG_SLAB_FREELIST_RANDOM=y
 CONFIG_SLAB_FREELIST_HARDENED=y
 CONFIG_SLAB_BUCKETS=y
 CONFIG_SHUFFLE_PAGE_ALLOCATOR=y
-CONFIG_RANDOM_KMALLOC_CACHES=y
+CONFIG_PARTITION_KMALLOC_CACHES=y
 
 # Sanity check userspace page table mappings.
 CONFIG_PAGE_TABLE_CHECK=y
diff --git a/mm/Kconfig b/mm/Kconfig
index ebd8ea353687..fa4ffc1fcb80 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -247,22 +247,47 @@ config SLUB_STATS
 	  out which slabs are relevant to a particular load.
 	  Try running: slabinfo -DA
 
-config RANDOM_KMALLOC_CACHES
-	default n
+config PARTITION_KMALLOC_CACHES
 	depends on !SLUB_TINY
-	bool "Randomize slab caches for normal kmalloc"
+	bool "Partitioned slab caches for normal kmalloc"
 	help
-	  A hardening feature that creates multiple copies of slab caches for
-	  normal kmalloc allocation and makes kmalloc randomly pick one based
-	  on code address, which makes the attackers more difficult to spray
-	  vulnerable memory objects on the heap for the purpose of exploiting
-	  memory vulnerabilities.
+	  A hardening feature that creates multiple isolated copies of slab
+	  caches for normal kmalloc allocations. This makes it more difficult
+	  to exploit memory-safety vulnerabilities by attacking vulnerable
+	  co-located memory objects. Several modes are provided.
 
 	  Currently the number of copies is set to 16, a reasonably large value
 	  that effectively diverges the memory objects allocated for different
 	  subsystems or modules into different caches, at the expense of a
-	  limited degree of memory and CPU overhead that relates to hardware and
-	  system workload.
+	  limited degree of memory and CPU overhead that relates to hardware
+	  and system workload.
+
+choice
+	prompt "Partitioned slab cache mode"
+	depends on PARTITION_KMALLOC_CACHES
+	default RANDOM_KMALLOC_CACHES
+	help
+	  Selects the slab cache partitioning mode.
+
+config RANDOM_KMALLOC_CACHES
+	bool "Randomize slab caches for normal kmalloc"
+	help
+	  Randomly pick a slab cache based on code address.
+
+config TYPED_KMALLOC_CACHES
+	bool "Type based slab cache selection for normal kmalloc"
+	depends on $(cc-option,-falloc-token-max=123)
+	help
+	  Rely on Clang's allocation tokens to choose a slab cache, where token
+	  IDs are derived from the allocated type.
+
+	  The current effectiveness of Clang's type inference can be judged by
+	  -Rpass=alloc-token, which provides diagnostics where (after dead-code
+	  elimination) type inference failed.
+
+	  Requires Clang 22 or later.
+
+endchoice
 
 endmenu # Slab allocator options
 
diff --git a/mm/kfence/kfence_test.c b/mm/kfence/kfence_test.c
index 5725a367246d..8807ea8ed0d3 100644
--- a/mm/kfence/kfence_test.c
+++ b/mm/kfence/kfence_test.c
@@ -214,7 +214,7 @@ static void test_cache_destroy(void)
 static inline size_t kmalloc_cache_alignment(size_t size)
 {
 	/* just to get ->align so no need to pass in the real caller */
-	enum kmalloc_cache_type type = kmalloc_type(GFP_KERNEL, 0);
+	enum kmalloc_cache_type type = kmalloc_type(GFP_KERNEL, __kmalloc_token(0));
 	return kmalloc_caches[type][__kmalloc_index(size, false)]->align;
 }
 
@@ -285,7 +285,7 @@ static void *test_alloc(struct kunit *test, size_t size, gfp_t gfp, enum allocat
 
 		if (is_kfence_address(alloc)) {
 			struct slab *slab = virt_to_slab(alloc);
-			enum kmalloc_cache_type type = kmalloc_type(GFP_KERNEL, _RET_IP_);
+			enum kmalloc_cache_type type = kmalloc_type(GFP_KERNEL, __kmalloc_token(size));
 			struct kmem_cache *s = test_cache ?:
 					kmalloc_caches[type][__kmalloc_index(size, false)];
 
diff --git a/mm/slab.h b/mm/slab.h
index e9ab292acd22..dd49d37e253d 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -361,12 +361,12 @@ static inline unsigned int size_index_elem(unsigned int bytes)
  * KMALLOC_MAX_CACHE_SIZE and the caller must check that.
  */
 static inline struct kmem_cache *
-kmalloc_slab(size_t size, kmem_buckets *b, gfp_t flags, unsigned long caller)
+kmalloc_slab(size_t size, kmem_buckets *b, gfp_t flags, kmalloc_token_t token)
 {
 	unsigned int index;
 
 	if (!b)
-		b = &kmalloc_caches[kmalloc_type(flags, caller)];
+		b = &kmalloc_caches[kmalloc_type(flags, token)];
 	if (size <= 192)
 		index = kmalloc_size_index[size_index_elem(size)];
 	else
diff --git a/mm/slab_common.c b/mm/slab_common.c
index d5a70a831a2a..21ab7dd79b5e 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -787,7 +787,7 @@ size_t kmalloc_size_roundup(size_t size)
 		 * The flags don't matter since size_index is common to all.
 		 * Neither does the caller for just getting ->object_size.
 		 */
-		return kmalloc_slab(size, NULL, GFP_KERNEL, 0)->object_size;
+		return kmalloc_slab(size, NULL, GFP_KERNEL, __kmalloc_token(0))->object_size;
 	}
 
 	/* Above the smaller buckets, size is a multiple of page size. */
@@ -821,26 +821,26 @@ EXPORT_SYMBOL(kmalloc_size_roundup);
 #define KMALLOC_RCL_NAME(sz)
 #endif
 
-#ifdef CONFIG_RANDOM_KMALLOC_CACHES
-#define __KMALLOC_RANDOM_CONCAT(a, b) a ## b
-#define KMALLOC_RANDOM_NAME(N, sz) __KMALLOC_RANDOM_CONCAT(KMA_RAND_, N)(sz)
-#define KMA_RAND_1(sz)                  .name[KMALLOC_RANDOM_START +  1] = "kmalloc-rnd-01-" #sz,
-#define KMA_RAND_2(sz)  KMA_RAND_1(sz)  .name[KMALLOC_RANDOM_START +  2] = "kmalloc-rnd-02-" #sz,
-#define KMA_RAND_3(sz)  KMA_RAND_2(sz)  .name[KMALLOC_RANDOM_START +  3] = "kmalloc-rnd-03-" #sz,
-#define KMA_RAND_4(sz)  KMA_RAND_3(sz)  .name[KMALLOC_RANDOM_START +  4] = "kmalloc-rnd-04-" #sz,
-#define KMA_RAND_5(sz)  KMA_RAND_4(sz)  .name[KMALLOC_RANDOM_START +  5] = "kmalloc-rnd-05-" #sz,
-#define KMA_RAND_6(sz)  KMA_RAND_5(sz)  .name[KMALLOC_RANDOM_START +  6] = "kmalloc-rnd-06-" #sz,
-#define KMA_RAND_7(sz)  KMA_RAND_6(sz)  .name[KMALLOC_RANDOM_START +  7] = "kmalloc-rnd-07-" #sz,
-#define KMA_RAND_8(sz)  KMA_RAND_7(sz)  .name[KMALLOC_RANDOM_START +  8] = "kmalloc-rnd-08-" #sz,
-#define KMA_RAND_9(sz)  KMA_RAND_8(sz)  .name[KMALLOC_RANDOM_START +  9] = "kmalloc-rnd-09-" #sz,
-#define KMA_RAND_10(sz) KMA_RAND_9(sz)  .name[KMALLOC_RANDOM_START + 10] = "kmalloc-rnd-10-" #sz,
-#define KMA_RAND_11(sz) KMA_RAND_10(sz) .name[KMALLOC_RANDOM_START + 11] = "kmalloc-rnd-11-" #sz,
-#define KMA_RAND_12(sz) KMA_RAND_11(sz) .name[KMALLOC_RANDOM_START + 12] = "kmalloc-rnd-12-" #sz,
-#define KMA_RAND_13(sz) KMA_RAND_12(sz) .name[KMALLOC_RANDOM_START + 13] = "kmalloc-rnd-13-" #sz,
-#define KMA_RAND_14(sz) KMA_RAND_13(sz) .name[KMALLOC_RANDOM_START + 14] = "kmalloc-rnd-14-" #sz,
-#define KMA_RAND_15(sz) KMA_RAND_14(sz) .name[KMALLOC_RANDOM_START + 15] = "kmalloc-rnd-15-" #sz,
-#else // CONFIG_RANDOM_KMALLOC_CACHES
-#define KMALLOC_RANDOM_NAME(N, sz)
+#ifdef CONFIG_PARTITION_KMALLOC_CACHES
+#define __KMALLOC_PARTITION_CONCAT(a, b) a ## b
+#define KMALLOC_PARTITION_NAME(N, sz) __KMALLOC_PARTITION_CONCAT(KMA_PART_, N)(sz)
+#define KMA_PART_1(sz)                  .name[KMALLOC_PARTITION_START +  1] = "kmalloc-part-01-" #sz,
+#define KMA_PART_2(sz)  KMA_PART_1(sz)  .name[KMALLOC_PARTITION_START +  2] = "kmalloc-part-02-" #sz,
+#define KMA_PART_3(sz)  KMA_PART_2(sz)  .name[KMALLOC_PARTITION_START +  3] = "kmalloc-part-03-" #sz,
+#define KMA_PART_4(sz)  KMA_PART_3(sz)  .name[KMALLOC_PARTITION_START +  4] = "kmalloc-part-04-" #sz,
+#define KMA_PART_5(sz)  KMA_PART_4(sz)  .name[KMALLOC_PARTITION_START +  5] = "kmalloc-part-05-" #sz,
+#define KMA_PART_6(sz)  KMA_PART_5(sz)  .name[KMALLOC_PARTITION_START +  6] = "kmalloc-part-06-" #sz,
+#define KMA_PART_7(sz)  KMA_PART_6(sz)  .name[KMALLOC_PARTITION_START +  7] = "kmalloc-part-07-" #sz,
+#define KMA_PART_8(sz)  KMA_PART_7(sz)  .name[KMALLOC_PARTITION_START +  8] = "kmalloc-part-08-" #sz,
+#define KMA_PART_9(sz)  KMA_PART_8(sz)  .name[KMALLOC_PARTITION_START +  9] = "kmalloc-part-09-" #sz,
+#define KMA_PART_10(sz) KMA_PART_9(sz)  .name[KMALLOC_PARTITION_START + 10] = "kmalloc-part-10-" #sz,
+#define KMA_PART_11(sz) KMA_PART_10(sz) .name[KMALLOC_PARTITION_START + 11] = "kmalloc-part-11-" #sz,
+#define KMA_PART_12(sz) KMA_PART_11(sz) .name[KMALLOC_PARTITION_START + 12] = "kmalloc-part-12-" #sz,
+#define KMA_PART_13(sz) KMA_PART_12(sz) .name[KMALLOC_PARTITION_START + 13] = "kmalloc-part-13-" #sz,
+#define KMA_PART_14(sz) KMA_PART_13(sz) .name[KMALLOC_PARTITION_START + 14] = "kmalloc-part-14-" #sz,
+#define KMA_PART_15(sz) KMA_PART_14(sz) .name[KMALLOC_PARTITION_START + 15] = "kmalloc-part-15-" #sz,
+#else // CONFIG_PARTITION_KMALLOC_CACHES
+#define KMALLOC_PARTITION_NAME(N, sz)
 #endif
 
 #define INIT_KMALLOC_INFO(__size, __short_size)			\
@@ -849,7 +849,7 @@ EXPORT_SYMBOL(kmalloc_size_roundup);
 	KMALLOC_RCL_NAME(__short_size)				\
 	KMALLOC_CGROUP_NAME(__short_size)			\
 	KMALLOC_DMA_NAME(__short_size)				\
-	KMALLOC_RANDOM_NAME(RANDOM_KMALLOC_CACHES_NR, __short_size)	\
+	KMALLOC_PARTITION_NAME(PARTITION_KMALLOC_CACHES_NR, __short_size)	\
 	.size = __size,						\
 }
 
@@ -961,8 +961,8 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type)
 		flags |= SLAB_CACHE_DMA;
 	}
 
-#ifdef CONFIG_RANDOM_KMALLOC_CACHES
-	if (type >= KMALLOC_RANDOM_START && type <= KMALLOC_RANDOM_END)
+#ifdef CONFIG_PARTITION_KMALLOC_CACHES
+	if (type >= KMALLOC_PARTITION_START && type <= KMALLOC_PARTITION_END)
 		flags |= SLAB_NO_MERGE;
 #endif
 
diff --git a/mm/slub.c b/mm/slub.c
index 2b2d33cc735c..b13d1117c87d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2125,7 +2125,7 @@ static inline size_t obj_exts_alloc_size(struct kmem_cache *s,
 	if (!is_kmalloc_normal(s))
 		return sz;
 
-	obj_exts_cache = kmalloc_slab(sz, NULL, gfp, 0);
+	obj_exts_cache = kmalloc_slab(sz, NULL, gfp, __kmalloc_token(0));
 	/*
 	 * We can't simply compare s with obj_exts_cache, because random kmalloc
 	 * caches have multiple caches per size, selected by caller address.
@@ -5239,7 +5239,7 @@ EXPORT_SYMBOL(__kmalloc_large_node_noprof);
 
 static __always_inline
 void *__do_kmalloc_node(size_t size, kmem_buckets *b, gfp_t flags, int node,
-			unsigned long caller)
+			unsigned long caller, kmalloc_token_t token)
 {
 	struct kmem_cache *s;
 	void *ret;
@@ -5254,22 +5254,22 @@ void *__do_kmalloc_node(size_t size, kmem_buckets *b, gfp_t flags, int node,
 	if (unlikely(!size))
 		return ZERO_SIZE_PTR;
 
-	s = kmalloc_slab(size, b, flags, caller);
+	s = kmalloc_slab(size, b, flags, token);
 
 	ret = slab_alloc_node(s, NULL, flags, node, caller, size);
 	ret = kasan_kmalloc(s, ret, size, flags);
 	trace_kmalloc(caller, ret, size, s->size, flags, node);
 	return ret;
 }
-void *__kmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node)
+void *__kmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node, kmalloc_token_t token)
 {
-	return __do_kmalloc_node(size, PASS_BUCKET_PARAM(b), flags, node, _RET_IP_);
+	return __do_kmalloc_node(size, PASS_BUCKET_PARAM(b), flags, node, _RET_IP_, token);
 }
 EXPORT_SYMBOL(__kmalloc_node_noprof);
 
-void *__kmalloc_noprof(size_t size, gfp_t flags)
+void *__kmalloc_noprof(size_t size, gfp_t flags, kmalloc_token_t token)
 {
-	return __do_kmalloc_node(size, NULL, flags, NUMA_NO_NODE, _RET_IP_);
+	return __do_kmalloc_node(size, NULL, flags, NUMA_NO_NODE, _RET_IP_, token);
 }
 EXPORT_SYMBOL(__kmalloc_noprof);
 
@@ -5284,7 +5284,7 @@ EXPORT_SYMBOL(__kmalloc_noprof);
  * NULL does not mean EBUSY or EAGAIN. It means ENOMEM.
  * There is no reason to call it again and expect !NULL.
  */
-void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
+void *_kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node, kmalloc_token_t token)
 {
 	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_NOMEMALLOC | gfp_flags;
 	struct kmem_cache *s;
@@ -5307,7 +5307,7 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
 retry:
 	if (unlikely(size > KMALLOC_MAX_CACHE_SIZE))
 		return NULL;
-	s = kmalloc_slab(size, NULL, alloc_gfp, _RET_IP_);
+	s = kmalloc_slab(size, NULL, alloc_gfp, token);
 
 	if (!(s->flags & __CMPXCHG_DOUBLE) && !kmem_cache_debug(s))
 		/*
@@ -5360,12 +5360,12 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
 	ret = kasan_kmalloc(s, ret, size, alloc_gfp);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(kmalloc_nolock_noprof);
+EXPORT_SYMBOL_GPL(_kmalloc_nolock_noprof);
 
 void *__kmalloc_node_track_caller_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags,
-					 int node, unsigned long caller)
+					 int node, unsigned long caller, kmalloc_token_t token)
 {
-	return __do_kmalloc_node(size, PASS_BUCKET_PARAM(b), flags, node, caller);
+	return __do_kmalloc_node(size, PASS_BUCKET_PARAM(b), flags, node, caller, token);
 
 }
 EXPORT_SYMBOL(__kmalloc_node_track_caller_noprof);
@@ -6726,6 +6726,7 @@ static gfp_t kmalloc_gfp_adjust(gfp_t flags, size_t size)
  * @align: desired alignment.
  * @flags: gfp mask for the allocation - must be compatible (superset) with GFP_KERNEL.
  * @node: numa node to allocate from
+ * @token: allocation token.
  *
  * Only alignments up to those guaranteed by kmalloc() will be honored. Please see
  * Documentation/core-api/memory-allocation.rst for more details.
@@ -6740,7 +6741,7 @@ static gfp_t kmalloc_gfp_adjust(gfp_t flags, size_t size)
  * Return: pointer to the allocated memory of %NULL in case of failure
  */
 void *__kvmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), unsigned long align,
-			     gfp_t flags, int node)
+			     gfp_t flags, int node, kmalloc_token_t token)
 {
 	bool allow_block;
 	void *ret;
@@ -6751,7 +6752,7 @@ void *__kvmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), unsigned long align,
 	 */
 	ret = __do_kmalloc_node(size, PASS_BUCKET_PARAM(b),
 				kmalloc_gfp_adjust(flags, size),
-				node, _RET_IP_);
+				node, _RET_IP_, token);
 	if (ret || size <= PAGE_SIZE)
 		return ret;
 
@@ -8351,7 +8352,7 @@ static void __init bootstrap_kmalloc_sheaves(void)
 {
 	enum kmalloc_cache_type type;
 
-	for (type = KMALLOC_NORMAL; type <= KMALLOC_RANDOM_END; type++) {
+	for (type = KMALLOC_NORMAL; type <= KMALLOC_PARTITION_END; type++) {
 		for (int idx = 0; idx < KMALLOC_SHIFT_HIGH + 1; idx++) {
 			if (kmalloc_caches[type][idx])
 				bootstrap_cache_sheaves(kmalloc_caches[type][idx]);
-- 
2.53.0.1018.g2bb0e51243-goog


