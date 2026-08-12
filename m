Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEB36C5B567
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 05:22:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B92C56B0088; Wed, 12 Aug 2026 01:22:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B43ED6B008A; Wed, 12 Aug 2026 01:22:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0D986B0092; Wed, 12 Aug 2026 01:22:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 768816B0088
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 01:22:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D63FA160281
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:22:57 +0000 (UTC)
X-FDA: 85091473194.16.DF94E2F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0D277160003
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:22:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kJ0EKCsu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of nathan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=nathan@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786512176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=z0N6OJ/27Ug3QgSr1OO1qU2RGmbk3As92oPs3a+1uKQ=;
	b=2akiRi9xhi0NWS/ENs/yu3NKqHLaR/AJ+sj03/lbDkWn3pgEVoGevzR9AVzahxgZAVmISh
	ql1FIVQhCXThrDLrsLuCW01w7Plnf8d/PFBSnNjmRq52qKxXR0EXjL9sIKGr2U3ooFT29W
	uBMSox6yMBmhOUQK6MtuspnuyU7rti4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kJ0EKCsu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of nathan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=nathan@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786512176;
	b=JmJZFR7APk+Vp975w6xD7i54Q48ClydhXF835xMPV9lALEC35bfm8Lv7trOjqiv63kkrHj
	ZEY4OEDdNeI6/+NvoEoPEGH4HlcYJ9AUVj54AFN5V3hNeTVThGTDn0eOOiJpS7R0E+QPaz
	vg0vseYoL2iZUTS2UcF6cJELQ3ZW3Po=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 77ED240B1A;
	Wed, 12 Aug 2026 05:22:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772C91F000E9;
	Wed, 12 Aug 2026 05:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786512174;
	bh=z0N6OJ/27Ug3QgSr1OO1qU2RGmbk3As92oPs3a+1uKQ=;
	h=From:Date:Subject:To:Cc;
	b=kJ0EKCsuJEKADrYClfbcjpLpAf3V/ibD36KwUDBtU43CPKhwuvQ3ZBvGriwaKANIW
	 ssGtdcNnOwI5pzK2vVklAWWstvtQDmRJF50fHlLUU2Xz1Rsz5wtq8er7dUIraoMGlH
	 ZJZZ9vblQC4ehNNlCQuA5OD1GHd/ViMsIwSzrtkrikeJ8RTavTYfKAry7KuLEavUpp
	 pJCMGGJztyBn30/qv+dml10LYIIicE3hrIeN02F/fsLuLXvn9/99rAdEuMenVbXLA7
	 KAIjSKtHn1jyA331za+vhgeKZbZaZfe6IPUCzPP1Pud/Qhd2r8bqGAJxbsiNyrBnpV
	 odxDRgtYBtjog==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 11 Aug 2026 22:22:42 -0700
Subject: [PATCH] arch_numa: Avoid false positive fortify warning in
 setup_node_to_cpumask_map()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260811-arch_numa-avoid-fortify-warning-v1-1-59ce3e689f3a@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXNQQrCMBBA0auUWTuQxBKLVxGRMZ20I5jIpK1K6
 d2Nunyb/1corMIFjs0KyosUyanC7hoII6WBUfpqcMZ501mLpGG8pPlOSEuWHmPWSeIbn6RJ0oD
 eU+wOrdm31kGtPJSjvH6H0/nvMl9vHKZvFrbtA/ITFe6DAAAA
X-Change-ID: 20260811-arch_numa-avoid-fortify-warning-66af87403412
To: Mike Rapoport <rppt@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
 stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=4393; i=nathan@kernel.org;
 h=from:subject:message-id; bh=SlLaVPw6ZHbuS1BVax13M+yBfy0AfsczeTQZub6iweA=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDFk1zJrOP7fuuht76JlD5PGGl59vHxWM9/h2mCXXaf1aQ
 YbvR7cUdJSyMIhxMciKKbJUP1Y9bmg45yzjjVOTYOawMoEMYeDiFICJ7F7C8IeXOzH4cFOKb9cR
 /zrj6XsiH7v37Enfkbrpm7Bh9PxT0dWMDPu7yrs4b747+PD6/TbFmRe2/t+zbKvj9i8rXiae3Bn
 9bjUnAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716
X-Rspam-User: 
X-Rspamd-Queue-Id: 0D277160003
X-Rspamd-Server: rspam07
X-Stat-Signature: hfdocqd8ajf5grjinb5qxisaz8sjh8wz
X-HE-Tag: 1786512175-765324
X-HE-Meta: U2FsdGVkX1//51Ygh9j+SS6WYn7tkCHPjLUeTCSABHtkI/1Fe8tGbshzCIbanJWnZpmHEQN4/7tG1yVkl5U5obByPoT0bhsKSs3eRWh09eAXKH4pj3Z10roP3zckyrAhXXX9QYhzywrTuDV27Nc2ckAQZV6VMnQR8RgXUgBxIdqmpJrc5mwfes+q6XWIRFE2fo6uQG8nvfcCR7xhbmSQpeLlpXdlaL4kjqIaUg5Xlowt8jnua47sn4HHI495BFvy8xxR9k47S8WotQ1f3aoJLsGptIR7VLIJNCOaJGNVLdFZGaYQTE0+pu+N0JzgLqxdefU6qcdhxvzM61azc4r7dVyHSHDG7IyBW1FOn75SuuJPLyGYKbxRporbIp0xL9kNMl0qV1rXih3KIAAUpel2sp/ExD9zUjDwYn8EVolNWXln1KT3wrR6pt4MJHJHO6Ql6iJ9NIE9X7cz0S+t1y929ecYFW5Gzd9LaVH+tF9RzSxOFR3PpdkjE/bSuVhK5Ax+C2Vzcs+PJZvuJkk6BECrrlZUCA0eSDN+Wng1PADniABS9JQKp0cRvLZVjuo/+WU9MdzAQWPJbDtejk8j0+Z7HnXbyXM6qwxLIHz7WqnlYOIC7zwC8TWHWC1QKwma8rn8RKKFnZ2kjVOgpCvTIl6NtGcSzCxhr9LBIHgK4rEuvztdx14I0VtmOtnM4869/fd3O5fD7iCQ7/EOl+JGSTFFBG0yaFcJqzHIwXUdELlS7tT0DLAkBwoz1CsVRrkSb6SJq998S5WvgvnFmHGAUg2EGBa7zTpOxwgcJpEihdWv2jvn+3IclpDsYvhCMzxTFsNcl8SfH7DGeD9y7hkawZlhsc36Jn8n5zoSQCYTVPiBa3A6MeCRBrd43k+fy4d11EvfrRsf3RiMygSCGcENTMt0FHHc4UqmgHXvcSSejVFQp4LQGvP6tIIpdEg08gECfNAhMN5NN+ywwUzsiv+5AC2
 B0rBZ6pg
 MA7Yl/9yTRfrpUorkORliCjyJBhDqw73y5XcHEvYtzmdUg/VHGWp5P2Brn8dyyUshJSR6574/qorryUgQ3bK1HB5RNoiQ6qO5eyG7eqzmsvFdHxWX2qjqzW/rgZKmEyzONWzV9Xr+oXswyO7E1oTAy/tqshXtwGxD5k95I/AeO25TG9ypVMsTQbwZxfO3L7TNf5XmpQd+342bw8YYtkBRGHomLUTSqk8XHk6fTC+o9U+rLirzJCPSKJlNWSOZHbkylNxBFAyTFydNgFXi2cGrrnG3UT2BfK5mFEgXQXOY/Y32A5fA5LJtR/uad2chGLSE++Fc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When building ARCH=riscv using clang with CONFIG_FORTIFY_SOURCE and
CONFIG_UBSAN_BOUNDS enabled, CONFIG_NR_CPUS > 64, and the default value
of 2 for CONFIG_NODES_SHIFT, there is a compiletime warning from the
fortify routines.

  In file included from mm/arch_numa.c:11:
  In file included from include/linux/acpi.h:14:
  In file included from include/linux/resource_ext.h:11:
  In file included from include/linux/slab.h:17:
  In file included from include/linux/gfp.h:7:
  In file included from include/linux/mmzone.h:8:
  In file included from include/linux/spinlock.h:60:
  In file included from include/linux/interrupt_rc.h:17:
  In file included from include/linux/smp.h:13:
  In file included from include/linux/cpumask.h:11:
  In file included from include/linux/bitmap.h:13:
  In file included from include/linux/string.h:383:
  include/linux/fortify-string.h:430:4: warning: call to '__write_overflow_field' declared with 'warning' attribute: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Wattribue-warning]
    430 |                         __write_overflow_field(p_size_field, size);
        |                         ^
  include/linux/fortify-string.h:430:4: note: called by function 'fortify_memset_chk(unsigned long, unsigned long, unsigned long)'
  include/linux/bitmap.h:248:3: note: inlined by function 'setup_node_to_cpumask_map'
    248 |                 memset(dst, 0, len);
        |                 ^
  include/linux/fortify-string.h:462:25: note: expanded from macro 'memset'
    462 | #define memset(p, c, s) __fortify_memset_chk(p, c, s,                   \
        |                         ^
  include/linux/fortify-string.h:453:2: note: expanded from macro '__fortify_memset_chk'
    453 |         fortify_memset_chk(__fortify_size, p_size, p_size_field),       \
        |         ^
  include/linux/fortify-string.h:430:4: note: use '-gline-directives-only' (implied by '-g1') or higher for more accurate inlining chain locations
    430 |                         __write_overflow_field(p_size_field, size);
        |                         ^
  1 warning generated.

In this configuration, MAX_NUMNODES is 4. clang unrolls the for loop in
setup_node_to_cpumask_map() past this, which triggers the fortify check
when accessing node_to_cpumask_map on the theoretical fifth loop
iteration because it would be an out of bounds write.

Make it clear to clang that nr_node_ids is bounded by MAX_NUMNODES due
to the logic in setup_nr_node_ids() by early returning in
setup_node_to_cpumask_map() should that condition be violated.

Cc: stable@vger.kernel.org # all applicable
Closes: https://github.com/ClangBuiltLinux/linux/issues/2174
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
This is based on mm-unstable due to the move of arch_numa.c from mm/ to
drivers/base/ living there. I have CC'd stable because this warning
appears in my testing back to at least 6.1 but I see no reason why it
should not apply to all trees. No fixes tag since this is a layered
problem that just happens to appear under certain conditions.

Another alternative would be using the __assume macro to say something
like

  __assume(nr_node_ids <= MAX_NUMNODES);

but that seems a little more fragile.
---
 mm/arch_numa.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mm/arch_numa.c b/mm/arch_numa.c
index 442ea239bba7..bd7772b05bcf 100644
--- a/mm/arch_numa.c
+++ b/mm/arch_numa.c
@@ -105,6 +105,18 @@ static void __init setup_node_to_cpumask_map(void)
 	if (nr_node_ids == MAX_NUMNODES)
 		setup_nr_node_ids();
 
+	/*
+	 * This check should never be true but it makes it clear to compilers
+	 * that node_to_cpumask_map is bound by nr_node_ids, avoiding false
+	 * positive fortify warnings when accessing node_to_cpumask_map in the
+	 * for loop below.
+	 */
+	if (unlikely(nr_node_ids > MAX_NUMNODES)) {
+		pr_err("nr_node_ids (%u) is larger than MAX_NUMNODES (%d)",
+		       nr_node_ids, MAX_NUMNODES);
+		return;
+	}
+
 	/* allocate and clear the mapping */
 	for (node = 0; node < nr_node_ids; node++) {
 		alloc_bootmem_cpumask_var(&node_to_cpumask_map[node]);

---
base-commit: 47870fb9b0e3bd20b45e3a069b4c766f3dcb721a
change-id: 20260811-arch_numa-avoid-fortify-warning-66af87403412

Best regards,
--  
Cheers,
Nathan


