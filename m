Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB235C4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 15:57:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46D086B009E; Fri, 17 Jul 2026 11:57:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 445686B009D; Fri, 17 Jul 2026 11:57:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30E076B00A0; Fri, 17 Jul 2026 11:57:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CA09C6B009E
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 11:57:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1EAEF120197
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 15:18:45 +0000 (UTC)
X-FDA: 84998625810.04.180DED1
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9332440008
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 15:18:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r96JvKub;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784301523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AfKaZoWxPE0ZpkObgiJe2CrqXCoOTbFr6iS/og3So18=;
	b=c3mQY698bIhfzBsPkyiGkNj+Ahv4CFtP0qx8EjxlotyC5XP0hFch09I8m6djdE0j8T5NHD
	ln9IqGR1HPnGdne7qElufZjELZvAAz55LBzhjh63LHCa8QolhHMq3FJdqpmBTij8/K3qme
	VCdeZNzu3H5cOivSdoDc81ebustMKcs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r96JvKub;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784301523;
	b=yALleVgTcmGSl+FT4nnm2jIday1TW0KoMv4JS7ztN8L8ZBGqOs+OBhicAo+/J/xByKxu96
	s1B/PcVXaJayj1EisIojZIDiOHSjXfKhTgjKSY3TeW84T5hp1cuFQytiVvi4IRRRjMIqeS
	nngGTMn6xYNaOfu0JzuaTniiQq8kMfQ=
Date: Fri, 17 Jul 2026 08:18:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784301516;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AfKaZoWxPE0ZpkObgiJe2CrqXCoOTbFr6iS/og3So18=;
	b=r96JvKubiNVJVM1S7SWC6IHAgxwJAOy7lov0IzuNdTWWLm9Wxqk4l0fYJduObOmlRs0ndC
	bWqgXEryI+wqlbPMmMKRywxyLcaFnWq9gvWfWlD/pTaBwWJ1kSWM1pJAyT8TFviECnEnQs
	eO7JtentyyTYXd/U1eXO1nOtuOoHn6w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Hao Ge <hao.ge@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, Suren Baghdasaryan <surenb@google.com>, 
	Kees Cook <kees@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	Danielle Constantino <dcostantino@meta.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	"Harry Yoo (Oracle)" <harry@kernel.org>
Subject: Re: [PATCH slab/for-next-fixes v3 0/4] mm/slab: fix unbounded
 recursion in free path with memalloc profiling
Message-ID: <alpHadRGUeaaMUKJ@linux.dev>
References: <20260713-kmalloc-no-objext-v3-0-47c7bd138de7@kernel.org>
 <alkypcRUZa_r6uGV@linux.dev>
 <c993627d-9071-4fb4-b5fe-e0a49ed26abb@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c993627d-9071-4fb4-b5fe-e0a49ed26abb@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 9332440008
X-Stat-Signature: y5wnzh4ks98rpkfri9e19ow5yoeu4ujj
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784301520-900872
X-HE-Meta: U2FsdGVkX19oeVDenb1kxqclPEcT7wJAtBdUzNc8nE1zPEuLOAyMPbfMUfDlZt2NreLjN9TkKdEMAyAlHfeaPaFArRyHOPwz+4eR9gt3UCVxXex6jcrpwHZpiDdYEZoCmraa5bVKy1gQW0SSLjD4QOF/LOEcqAfW68mXXz0rRDBAc07f2x4uPXMWcOO7T+h94TFCSKtdcBJG8j/4AED+O1MMFWhhozsNjgNVFj0EE8FgGgLJqiAmo95MU10q7bTaolFq4tRAsfXrg0gI6vSjcQyz14LRzmmidrfy4mgKZI9ifOhck1SIhbqEIV7sc7i492oQ4RuVZ06YUa5Ae8fgM7+9nMOBHJtbhUl2I9nqKNbePyXZTO9POJfUSHbP/EJBeh0bl1k4zvXHyxyxwoastZDUNnMeheOxqbm/GXKw2RlodUzhw3VlkdUkjUozMq/3wnMGAHtLaJ5CsCs7juODauh+jwajhxDHjbujKDfZECJoPe/10uhcWnx1VhY5r59OuzSc0W1PP5TDu2OYQzoj8HxVvrJnqImDqD5Tp60wZcV99UGJRkYmNviMKSPNC1P8c2S3V1QqOv+v0jDDjN5Bx2Ij/9Z/YaAO9Peur4lM2bCNHYuIf8OOqQLqj3tPJWMEBdYvGXs/L9nj8/ovdErAWckfWDA65L+JCVLgoJHLfjH5o0my/ld4HZgtetmhKXWLB25LOhUVElX3OWE5XT/SfdUJ1UgJy0FCSVqG5FxYPRqD4OfB0YFxHvu22ngX/kSHqoubdi2Z2olXnq2isAEbnPySy19JQJrUX/CEgLUvs1Z64wnv2J5ngnutlXiWx00Vwg+yO2UGZ7hKj6X47gTbxJtSAmKiMo6l7liwmmkcVAKWeg9JRX1zxIaqquG5B12vcckuw4ZZehaJc32K/JuYWyj74pqUoTW3jGBqLBCWNzsGWFt+swoV8IXdu6QFHPF+WTi2d1eo/V2XFG5J+4n
 KhmPVHTq
 EOGnS5ReBfu73sY5hXQtVIUHdeFTrbqdc2FcpXd3livuoZ7Elcm2r3Q66iS4BI2hZNzVIP7YdDM3Wy4DZaJWza/NvioTrmjM2gbtOs2x49LigL4R53mcLzniLHZz7mhRZOo0sDsfGPchxxq5o59OakaGM5vtvIR98B8VzYm/LSKcu/SLyYctcuBqypTjbOEeDd6N2N4fUtzU+rTWqB9KVNERycqJ8CroBgaxIH9oUy5DXzCSqaUYL2qfhgJCEZ2tuUdDvezUI46vj/yZL65BzDeK/wr1QihEkVLwd7bh2hDHN3iAS102KHHMWCw/+8umtPeQ1PcoPAjAxVE7N9JqSEXfi7vO5ZsCxASae8YQgHkW1hFtzVSYfQhryY65lzDJIFfAnacIo5vte1MaetwXRofX4r1NmWws2lWJxvmnDFnM6AFPEVgfVux1OdTPogwTbpsqFvSK6KdUMnU088mEgdGR5RV6Rgl6FwGRAvGcqYh5/Ws+Ssg+4qufHS+xWrO190YW49OqTW8hyIDJ5adhg+u3l1YDjbdng43553lCQhShztNnWhgKhkgDwMpTiAbYbbPn1tReGyDd57pIgos+Ul5xLhSQTiwbGZe9t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 09:16:19AM +0800, Hao Ge wrote:
> On 2026/7/17 03:37, Shakeel Butt wrote:
> > On Mon, Jul 13, 2026 at 11:28:48PM +0900, Harry Yoo (Oracle) wrote:
> > > This is a follow-up fix after the recent discussion [1].
> > > See patch 4 for the detailed description on the bug.
> > > 
> > > Based on slab/for-next-fixes (af9ea231c0b45) and is available at
> > > git.kernel.org [2].
> > > 
> > > Instead preventing cycles by bumping up the allocation size of obj_exts
> > > arrays, it introduces a new kmalloc type called KMALLOC_NO_OBJ_EXT and
> > > disallow formation of cycles between kmalloc types when allocating
> > > obj_exts arrays. obj_exts arrays of normal kmalloc caches are served
> > > from KMALLOC_NO_OBJ_EXT caches (that don't have obj_exts), and all other
> > > obj_exts arrays are served from normal kmalloc caches.
> > > 
> > > I tried to reuse SLAB_ALLOC_NO_RECURSE to make kmalloc_slab() select
> > > KMALLOC_NO_OBJ_EXT, but it was not great because it does not allow
> > > sheaves for those caches. So I introduced a new slab alloc flag
> > > SLAB_ALLOC_NO_OBJ_EXT.
> > > 
> > > To avoid huge confusion, I had to decouple "disallowing sheaves"
> > > semantics from SLAB_NO_OBJ_EXT and introduced SLAB_NO_SHEAVES.
> > > 
> > > While this cannot be directly backported to v6.18 and v6.12 due to lack
> > > of SLAB_ALLOC_* flags and kmalloc_flags(), I don't this will be
> > > particularily challenging to backport it. Instead of a new slab alloc
> > > flag, we can use __GFP_NO_OBJ_EXT to select KMALLOC_NO_OBJ_EXT as
> > > kmalloc caches don't have sheaves in v6.18 anyway.
> > > 
> > > [1] https://lore.kernel.org/linux-mm/9a139365-28e6-4f1e-b35b-7f6091e9aa14@kernel.org
> > > 
> > > [2] https://git.kernel.org/pub/scm/linux/kernel/git/harry/linux.git/log/?h=kmalloc-no-objext-v3r1
> > > 
> > > To: Vlastimil Babka <vbabka@kernel.org>
> > > To: Andrew Morton <akpm@linux-foundation.org>
> > > To: Hao Li <hao.li@linux.dev>
> > > To: Christoph Lameter <cl@gentwo.org>
> > > To: David Rientjes <rientjes@google.com>
> > > To: Roman Gushchin <roman.gushchin@linux.dev>
> > > To: Suren Baghdasaryan <surenb@google.com>
> > > To: Hao Ge <hao.ge@linux.dev>
> > > To: Kees Cook <kees@kernel.org>
> > > To: Pedro Falcato <pfalcato@suse.de>
> > > To: Shakeel Butt <shakeel.butt@linux.dev>
> > > To: Danielle Constantino <dcostantino@meta.com>
> > > To: Liam R. Howlett <liam@infradead.org>
> > > Cc: linux-mm@kvack.org
> > > Cc: linux-kernel@vger.kernel.org
> > > Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
> > I tested next-20260716 which has this series against next-20260707 which does
> > not have the fix. The reproducer were able to trigger the leak/recursion on
> > next-20260707 but not on next-20260716. So, you can add:
> 
> 
> Hi Shakeel
> 
> 
> It seems you have a consistent stable reproduction method or test script.
> 
> Would you mind sharing it if possible?  I'm sorry if this was provided
> earlier and I overlooked it.
> 
> I'd like to thoroughly investigate and learn about this problem.
> 
> Thank you very much.
> 
> 


From dcb6ca5c051738d64f7a901402f5f257babbc385 Mon Sep 17 00:00:00 2001
From: Shakeel Butt <shakeel.butt@linux.dev>
Date: Fri, 17 Jul 2026 08:12:11 -0700
Subject: [PATCH] slub: repro unbounded recursion in slub objext array
 allocation

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 repro_public/Makefile       |   1 +
 repro_public/README.md      | 128 +++++++++++++++++++++++++
 repro_public/repro_objext.c | 180 ++++++++++++++++++++++++++++++++++++
 repro_public/run_repro.sh   |  26 ++++++
 4 files changed, 335 insertions(+)
 create mode 100644 repro_public/Makefile
 create mode 100644 repro_public/README.md
 create mode 100644 repro_public/repro_objext.c
 create mode 100755 repro_public/run_repro.sh

diff --git a/repro_public/Makefile b/repro_public/Makefile
new file mode 100644
index 000000000000..0629fc5b6fb7
--- /dev/null
+++ b/repro_public/Makefile
@@ -0,0 +1 @@
+obj-m := repro_objext.o
diff --git a/repro_public/README.md b/repro_public/README.md
new file mode 100644
index 000000000000..21ec3f5c01e6
--- /dev/null
+++ b/repro_public/README.md
@@ -0,0 +1,128 @@
+# Reproducer: SLUB obj_exts free-recursion / cross-cycle leak
+
+With `CONFIG_MEM_ALLOC_PROFILING=y` and profiling enabled, every
+`KMALLOC_NORMAL` slab gets a `slabobj_ext` (obj_exts) array that is itself
+`kmalloc()`'d from a `KMALLOC_NORMAL` cache. `sizeof(struct slabobj_ext) == 16`,
+so with the right slab geometry the arrays reference each other:
+
+- `kmalloc-512` with 64 objs/slab -> array is `64*16 = 1024` bytes -> `kmalloc-1k`
+- `kmalloc-1k`  with 32 objs/slab -> array is `32*16 =  512` bytes -> `kmalloc-512`
+
+A `kmalloc-512` slab and a `kmalloc-1k` slab then hold each other's obj_exts
+array (a 2-cycle). Discarding one frees the other's array, which empties and
+discards that slab, and so on:
+
+```
+__free_slab() -> unaccount_slab() -> free_slab_obj_exts() -> kfree()
+             -> discard_slab() -> __free_slab() ...
+```
+
+At production scale this recurses until the 16 KiB kernel stack overflows
+(stack guard page). In a small VM it deterministically manifests as a *leak*:
+the mutually-pinned slabs can never be reclaimed, so `kmalloc-512`/`kmalloc-1k`
+retain thousands of unreclaimable objects after a shrink storm. Same root cause.
+
+Related upstream commits:
+- `4b8736964640` ("mm/slab: add allocation accounting into slab allocation and
+  free paths") — introduced the obj_exts arrays (Fixes:).
+- `280ea9c3154b` ("mm/slab: avoid allocating slabobj_ext array from its own
+  slab") — bumps the size only when the array would come from the *same* cache
+  (`object_size ==`); does NOT break the `kmalloc-512 <-> kmalloc-1k` cross
+  cycle, so it is insufficient.
+
+## Files
+
+- `repro_objext.c` — the reproducer kernel module.
+- `Makefile`       — out-of-tree module makefile (`obj-m := repro_objext.o`).
+- `run_repro.sh`   — in-guest driver: enables profiling, prints the slab
+  geometry, insmods the module, hammers `shrink`, and reports the leftover
+  object counts (all via `/dev/kmsg` so it survives in `dmesg`).
+
+## Requirements
+
+Kernel `.config`:
+
+```
+CONFIG_MEM_ALLOC_PROFILING=y      # trigger: obj_exts on KMALLOC_NORMAL slabs
+CONFIG_MEMCG=y                    # selects CONFIG_SLAB_OBJ_EXT=y
+CONFIG_MODULES=y
+CONFIG_MODULE_UNLOAD=y
+# CONFIG_SLUB is the default allocator
+```
+
+Tools: a kernel build toolchain (`make`, `gcc`/clang, `binutils`, `bison`,
+`flex`, `libelf-dev`, `libssl-dev`, `bc`, `pahole`) and either
+[virtme-ng](https://github.com/arighi/virtme-ng) or `qemu-system-x86_64`.
+
+## Build
+
+```sh
+# 1. Build the kernel under test (with the config options above).
+make -C /path/to/kernel -j"$(nproc)" bzImage modules
+# ('modules' is needed so Module.symvers includes mem_alloc_profiling_key,
+#  which kmalloc() references when profiling is compiled in.)
+
+# 2. Build the reproducer module against that kernel.
+make -C /path/to/kernel M="$PWD" modules   # produces repro_objext.ko
+```
+
+## Run
+
+Boot the kernel with two boot-cmdline parameters:
+
+```
+slub_min_objects=64            # forces kmalloc-512=64 objs/slab and
+                               # kmalloc-1k=32 objs/slab -> the cross-cycle geometry
+sysctl.vm.mem_profiling=1      # enables profiling at boot; a runtime
+                               # `echo 1 > /proc/sys/vm/mem_profiling` is REJECTED
+                               # unless CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT=y
+                               # or this boot param is set.
+```
+
+With virtme-ng:
+
+```sh
+cd /path/to/kernel
+vng --cpus 8 -m 12G -a "slub_min_objects=64 sysctl.vm.mem_profiling=1" \
+    -- bash /path/to/run_repro.sh /path/to/repro_objext.ko
+```
+
+Or, by hand inside any guest booted with the params above:
+
+```sh
+insmod repro_objext.ko n=2000000 rounds=4 shrink=1 keep=0 shrink_iters=8
+for i in $(seq 1 80); do
+  for c in kmalloc-128 kmalloc-256 kmalloc-512 kmalloc-1k kmalloc-2k kmalloc-4k; do
+    echo 1 > /sys/kernel/slab/$c/shrink 2>/dev/null
+  done
+done
+cat /sys/kernel/slab/kmalloc-512/objects
+cat /sys/kernel/slab/kmalloc-1k/objects
+```
+
+The module returns `-ECANCELED` on purpose (it does all its work in init and
+then unloads itself); the `insmod: Operation canceled` message is expected.
+
+## Expected results
+
+Verify the geometry printed by the driver is `k512 objs=64` and `k1k objs=32`
+and `profiling_runtime=1`; otherwise the cross-cycle is not exercised.
+
+- **Buggy kernel** (cross-cycle not fixed): after the shrink storm,
+  `kmalloc-512`/`kmalloc-1k` stay pinned at thousands of objects (e.g. ~8000),
+  far above the pre-insmod baseline. At production scale/geometry the same
+  condition overflows the kernel stack instead.
+- **Fixed kernel**: object counts return to the pre-insmod baseline (a few
+  hundred); no leak, no recursion.
+
+## Module parameters
+
+| param          | default   | meaning                                                   |
+|----------------|-----------|-----------------------------------------------------------|
+| `n`            | 2000000   | objects per size class per round                          |
+| `rounds`       | 4         | warm-up rounds to build obj_exts density                  |
+| `keep`         | 0         | keep 1-in-`keep` objects live per round (0 = free all)    |
+| `shrink`       | 1         | hammer `kmem_cache_shrink` via sysfs after the churn      |
+| `shrink_iters` | 8         | shrink passes per round                                   |
+| `size_lo`      | 384       | small request size (-> kmalloc-512)                       |
+| `size_hi`      | 768       | large request size (-> kmalloc-1k)                        |
diff --git a/repro_public/repro_objext.c b/repro_public/repro_objext.c
new file mode 100644
index 000000000000..01a53693dbef
--- /dev/null
+++ b/repro_public/repro_objext.c
@@ -0,0 +1,180 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * repro_objext.c — reproduce the SLUB obj_exts free-recursion stack overflow.
+ *
+ * Bug: with CONFIG_MEM_ALLOC_PROFILING=y and vm.mem_profiling on,
+ * every KMALLOC_NORMAL slab gets a slabobj_ext (obj_exts) vector allocated from
+ * another KMALLOC_NORMAL slab. sizeof(slabobj_ext)==16, so kmalloc-1k's vector
+ * (objs*16) lands in kmalloc-512 and kmalloc-512's vector lands in kmalloc-1k ->
+ * cross-referencing chains and a kmalloc-1k<->kmalloc-512 2-cycle. When many such
+ * slabs are discarded (per-cpu partial flush __put_partials, or kmem_cache_shrink),
+ * __free_slab()->unaccount_slab()->free_slab_obj_exts()->kfree(vector) empties the
+ * slab that holds the vector, which discards THAT slab, recursing without bound and
+ * overflowing the 16 KiB task stack (VMAP guard page).
+ *
+ * Boot: append `sysctl.vm.mem_profiling=1` (or =1,compressed) to the kernel cmdline,
+ * OR echo 1 > /proc/sys/vm/mem_profiling before insmod.
+ *
+ * WITHOUT fix: "BUG: TASK stack guard page was hit" recursion -> panic/hang/reboot;
+ *              "REPRODUCER DONE" is NEVER printed (note: the overflow may also
+ *              corrupt the console TX path, so the box may just die silently —
+ *              treat a VM that never prints DONE / dies / reboots as a CRASH).
+ * WITH fix:    no obj_exts on KMALLOC_NORMAL slabs -> no recursion ->
+ *              "REPRODUCER DONE no-crash" printed, insmod returns (module unloads).
+ *
+ * Tunables (module params):
+ *   n         objects per size class per round (default 2,000,000)
+ *   rounds    warm-up rounds to build obj_exts density (default 4)
+ *   keep      keep 1-in-`keep` objects live after each round to leave slabs at low
+ *             occupancy (denser cross-referenced partial slabs). 0 = free all.
+ *   shrink    after the churn, hammer kmem_cache_shrink via
+ *             /sys/kernel/slab/<cache>/shrink to force the discard cascade.
+ *   sizes_lo/sizes_hi  the two kmalloc request sizes (default 768 -> kmalloc-1k,
+ *             384 -> kmalloc-512).
+ */
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/uaccess.h>
+#include <linux/delay.h>
+
+static unsigned long n = 2000000;
+module_param(n, ulong, 0444);
+MODULE_PARM_DESC(n, "objects per size class per round");
+
+static unsigned int rounds = 4;
+module_param(rounds, uint, 0444);
+MODULE_PARM_DESC(rounds, "warm-up rounds");
+
+static unsigned int keep;
+module_param(keep, uint, 0444);
+MODULE_PARM_DESC(keep, "keep 1-in-keep objects live after each round (0=free all)");
+
+static unsigned int shrink = 1;
+module_param(shrink, uint, 0444);
+MODULE_PARM_DESC(shrink, "hammer kmem_cache_shrink via sysfs after churn");
+
+static unsigned int shrink_iters = 8;
+module_param(shrink_iters, uint, 0444);
+MODULE_PARM_DESC(shrink_iters, "how many shrink passes");
+
+static unsigned int size_lo = 384;	/* -> kmalloc-512 */
+module_param(size_lo, uint, 0444);
+static unsigned int size_hi = 768;	/* -> kmalloc-1k  */
+module_param(size_hi, uint, 0444);
+
+static void **a;	/* kmalloc-1k (size_hi) */
+static void **b;	/* kmalloc-512 (size_lo) */
+
+static void echo_to(const char *path, const char *val)
+{
+	struct file *f;
+	loff_t pos = 0;
+
+	f = filp_open(path, O_WRONLY, 0);
+	if (IS_ERR(f))
+		return;
+	kernel_write(f, val, strlen(val), &pos);
+	filp_close(f, NULL);
+}
+
+/* Force kmem_cache_shrink on the two caches: walks partial lists and discards
+ * empty slabs -> discard_slab -> __free_slab -> free_slab_obj_exts -> kfree.
+ * If the freed obj_exts vectors cross-reference, the recursion fires here. */
+static void do_shrink(void)
+{
+	unsigned int i;
+	char p1[64], p2[64];
+
+	snprintf(p1, sizeof(p1), "/sys/kernel/slab/kmalloc-1k/shrink");
+	snprintf(p2, sizeof(p2), "/sys/kernel/slab/kmalloc-512/shrink");
+	for (i = 0; i < shrink_iters; i++) {
+		echo_to(p1, "1\n");
+		echo_to(p2, "1\n");
+	}
+	/* also the cg variants if present (harmless if absent) */
+	echo_to("/sys/kernel/slab/kmalloc-rnd-08-1k/shrink", "1\n");
+	echo_to("/sys/kernel/slab/kmalloc-rnd-07-512/shrink", "1\n");
+}
+
+static void do_round(unsigned long cnt, bool last)
+{
+	unsigned long i;
+
+	for (i = 0; i < cnt; i++) {
+		a[i] = kmalloc(size_hi, GFP_KERNEL);
+		b[i] = kmalloc(size_lo, GFP_KERNEL);
+		if (a[i])
+			*(volatile char *)a[i] = 1;
+		if (b[i])
+			*(volatile char *)b[i] = 1;
+	}
+	if (last)
+		pr_emerg("REPRODUCER: allocated %lu+%lu objs, starting free-storm (keep=%u)\n",
+			 cnt, cnt, keep);
+
+	/* Free-storm. If keep>0, leave 1-in-keep live to keep slabs partial &
+	 * densely cross-referenced; those are freed only on the final round. */
+	for (i = 0; i < cnt; i++) {
+		if (keep && (i % keep) == 0)
+			continue;	/* leave this one live for now */
+		kfree(a[i]);
+		kfree(b[i]);
+	}
+}
+
+static int __init repro_init(void)
+{
+	unsigned int r;
+	unsigned long i;
+
+	pr_emerg("REPRODUCER START n=%lu rounds=%u keep=%u shrink=%u sizes=%u/%u mem_profiling=%d\n",
+		 n, rounds, keep, shrink, size_lo, size_hi,
+		 IS_ENABLED(CONFIG_MEM_ALLOC_PROFILING));
+
+	a = vmalloc(n * sizeof(void *));
+	b = vmalloc(n * sizeof(void *));
+	if (!a || !b) {
+		pr_emerg("REPRODUCER: vmalloc failed, reduce n=\n");
+		goto out;
+	}
+
+	for (r = 0; r < rounds; r++) {
+		do_round(n, r == rounds - 1);
+		if (shrink)
+			do_shrink();
+	}
+
+	/* Free everything that was kept live, then shrink hard: this is the
+	 * discard-cascade moment most likely to hit the recursion. */
+	if (keep) {
+		pr_emerg("REPRODUCER: freeing kept-live objects then shrinking\n");
+		for (i = 0; i < n; i++) {
+			if ((i % keep) == 0) {
+				kfree(a[i]);
+				kfree(b[i]);
+			}
+		}
+	}
+	if (shrink) {
+		pr_emerg("REPRODUCER: final shrink storm\n");
+		do_shrink();
+	}
+
+	pr_emerg("REPRODUCER DONE no-crash (fix present)\n");
+out:
+	vfree(a);
+	vfree(b);
+	/* Return error so the module unloads itself; the test only needs init. */
+	return -ECANCELED;
+}
+
+static void __exit repro_exit(void) { }
+
+module_init(repro_init);
+module_exit(repro_exit);
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Reproducer for SLUB obj_exts free-recursion stack overflow");
+
diff --git a/repro_public/run_repro.sh b/repro_public/run_repro.sh
new file mode 100755
index 000000000000..08c7e57014bc
--- /dev/null
+++ b/repro_public/run_repro.sh
@@ -0,0 +1,26 @@
+#!/bin/bash
+# Branch reproducer driver. Arg1 = path to repro_objext.ko built against this kernel.
+# All diagnostics go to /dev/kmsg so they survive in the dmesg dump (vng stdout is lossy).
+set +e
+KO="$1"
+L(){ echo "BT| $*" > /dev/kmsg 2>/dev/null; }
+k(){ awk '{print $1}' /sys/kernel/slab/$1/objects 2>/dev/null; }
+g(){ cat /sys/kernel/slab/$1/$2 2>/dev/null; }
+L "===== BRANCHTEST START ====="
+L "uname=$(uname -r)"
+L "cmdline=$(cat /proc/cmdline)"
+echo 1 > /proc/sys/vm/mem_profiling 2>/dev/null
+L "profiling_runtime=$(cat /proc/sys/vm/mem_profiling 2>/dev/null)"
+L "GEOM k512 objs=$(g kmalloc-512 objs_per_slab) ord=$(g kmalloc-512 order) | k1k objs=$(g kmalloc-1k objs_per_slab) ord=$(g kmalloc-1k order) | k2k objs=$(g kmalloc-2k objs_per_slab) | k256 objs=$(g kmalloc-256 objs_per_slab)"
+L "noobjext_caches=$(ls -d /sys/kernel/slab/*no-objext* 2>/dev/null | wc -l)"
+L "BEFORE k512=$(k kmalloc-512) k1k=$(k kmalloc-1k)"
+insmod "$KO" n=2000000 rounds=4 shrink=1 keep=0 shrink_iters=8
+L "insmod_rc=$?"
+# extra external shrink storm to force the discard cascade
+for i in $(seq 1 80); do for c in kmalloc-128 kmalloc-256 kmalloc-512 kmalloc-1k kmalloc-2k kmalloc-4k; do echo 1 > /sys/kernel/slab/$c/shrink 2>/dev/null; done; done
+sleep 1
+L "AFTER k512=$(k kmalloc-512) k1k=$(k kmalloc-1k)"
+L "===== BRANCHTEST END ====="
+echo "=====DMESG DUMP====="
+dmesg | grep -E "BT\||REPRODUCER|stack guard|BUG:|Oops|Call Trace|Kernel panic|guard page"
+echo "=====BRANCHTEST_DONE====="
-- 
2.53.0-Meta


