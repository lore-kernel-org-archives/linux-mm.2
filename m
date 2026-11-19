Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39B01606A331
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 15:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=readmodwrite-com.20260707.gappssmtp.com header.i=@readmodwrite-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=tK7Y6pzS
Received: by kanga.kvack.org (Postfix)
	id A579F6B065B; Thu, 19 Nov 2026 10:32:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2D1C6B0691; Thu, 19 Nov 2026 10:32:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91BBD6B0692; Thu, 19 Nov 2026 10:32:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 670196B065B
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 10:32:19 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 06A28A0B85
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:32:19 +0000 (UTC)
X-FDA: 85452259998.15.2140D05
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf18.hostedemail.com (Postfix) with ESMTP id 255D11C0018
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:32:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b=tK7Y6pzS;
	spf=none (imf18.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.221.48) smtp.mailfrom=matt@readmodwrite.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795102337;
	b=cKg4AyL4jOUOxbXqmXIy8kvCWceYonU+bv5inUYuztZXyOeK5uP300KI8+ys0hUhF1ibyn
	asQZDQyP3l44hlvdqaOBgpz53ln77qz7ZGq7UbORUDRLBakeNCNzbsM614j8XdF3W0tJKw
	fc5OSt4ifeqPOyZOKTl39tB1K/Vd8pw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795102337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wro5V0Ze32ughDdDR7smbyONLvJqMo//GzOrC12jS9E=;
	b=hvG4TjQjN41mXBoMdm5If9jBgG7Y4FfeqjAvuQ/lFK+xQonfKQsEUooZIkYJhYCGwO7tH8
	bUFg0/M/xM4mvNo9z71eEl9MDuuQzSZJv031yTH/up2utN5yhvivBLH9RDmJwS6tvAFqgO
	NcDFClv6JGa0UCx6DnUQEM38lqKF0jU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b=tK7Y6pzS;
	spf=none (imf18.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.221.48) smtp.mailfrom=matt@readmodwrite.com;
	dmarc=none
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-498f5fa5103so1435363f8f.2
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:32:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=readmodwrite-com.20260707.gappssmtp.com; s=20260707; t=1795102336; x=1795707136; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wro5V0Ze32ughDdDR7smbyONLvJqMo//GzOrC12jS9E=;
        b=tK7Y6pzSeWesU31RYTeAWzAM1tmR9t3GeppEg++69GjmDNPeoikFKtJx0BD832HmQU
         Ikl3PV0tiB9cUb81i6V2rE439xYyvJcU9NgaAfDUG+4t/5gtyPKIq+HSguUIGUC45HP8
         XSJwqWGK/ZTv0bDhnguI8h8iVsxueaaP6y4+bCoasLGWs5seQR4+8v41IgMkgIPftRai
         h1ky7PSvxFJKrsVIUTSP5I0gRiuAWgeUIG4ynJro0HKJHGRtR19CiWeF2Sdx96cAlpcs
         XGwr3Uu/V82+y7o7sw0dDpNlx20fUfYPgCbw0BVeUQej6fHO6vouMCwiFnHRlNQbkDQ4
         pknA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795102336; x=1795707136;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wro5V0Ze32ughDdDR7smbyONLvJqMo//GzOrC12jS9E=;
        b=zfIkpk+VWTnmrMPrB9VeaGhbb38p61z46lmNskTU7JNNQTnJ/9aHmCFcy+Jva4eKTU
         FnQ4YutjE2lm6/dGbxOZGzstfaAMrQhtzL3QX0eiMUC6f67B747rusDGQRqe9G9yBlpo
         mYq4KQiQmPvv/KCxemha2tvtyybsWep/VfmpxPUhCsngBpvDo2uoor+YJ4ZjEWA/jMFc
         sBb89k6TJNMhKa2cOpzGbSUJyaexEmxn0RMqPzPgFroGuINxLFib1j6UkBPIoEIeBwsT
         /0nz+3Wcg7xUS4FSy2/HjRPxNDbY0EMNc+eLcxZ3+bzXFV5sS4RxCwXPuOUxN4AkattG
         XDZQ==
X-Forwarded-Encrypted: i=1; AL+hErHD5uAka+rTL1/zOHdDH+02k8Xu65mRkhPn3l5waYwwqzZwmpAD2E6eNBKGSczugun59hIJt17zlA==@kvack.org
X-Gm-Message-State: APuU4Z/2j8uI9ZwbkmjMTwc25mmLILmq81FuPOwyRCbXmf1q9oYcHYHT
	rGFSY2XRJ2l9A6b0+FkwGTsHxSou5vqCYpxeEWkjV2W0KxzZYyhnsx28ALy3YZu8tq4=
X-Gm-Gg: AZFdTZdEiI0T4sZoJ58vWCtw/6tSAOmRjmjm2FnpOfUtrQ41j7ddl9wuuQFH+cQjvGW
	aAyvumKvHPJIGMtU0QEHvvxxImBlXrDa26ESARFHe2s4oTOFTXlBVM/Cj7t1MjkSvHpYuP++JUb
	gaTnO3G4MOVGUuGe0zWyG7dMlFcR722NvMQiCSeH12+mPmrZa+U0jXv2lQqFupkur2zcsmGIVd6
	BvNPDxGUjyFjQkxUhaz/bslLRqTSGJAJbBc9xXobTXovsM6++04ovWAYwHUS0yRFz83e1GTt64X
	MBWA5EpYZYYdIEiZbbNzdftDW+1vXvzcuVkTi1R6/ADpwy7rYfkWOTJM4EJ6mSlcR8bgO6cLjYK
	5pzys18p2FVtd7fO4ZBl9uucN+6KnmMj8zRMbtHF4z5hkiEujLI4Y2LJd4K5S+dYiuPHsbs0k3j
	maoMEHqqT/f/TLWngZ1bSHKAO7BmNPZ+dhJXzB4x9+q5nwR1UrzGVrbdsGjDUqZEl2cDDoOXfFZ
	6JZ6Iu9Eq7LqeLiFqBbWnSM9nsTOCDy0EZQlL3oklNIHiG6NyxBRceuFAIXHiscrmqw1LUWNJBx
	oCx49DssN3CURa3FBOD2u3BaBVcYBOA=
X-Received: by 2002:a05:6000:22ca:b0:4a8:a1fe:ea94 with SMTP id ffacd0b85a97d-4a8a1feec0bmr7859855f8f.3.1795102335760;
        Thu, 19 Nov 2026 07:32:15 -0800 (PST)
Received: from matt-Precision-5490.. ([2a09:bac6:37a8:294b::41d:4e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab65cb41f4sm237463f8f.7.2026.11.19.07.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 07:32:15 -0800 (PST)
From: Matt Fleming <matt@readmodwrite.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@kernel.org>,
	Caleb Kan <calebkan1106@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	kernel-team@cloudflare.com,
	Matt Fleming <mfleming@cloudflare.com>
Subject: [PATCH v4 10/10] scripts/gdb: Decode compressed stack depot frames
Date: Thu, 19 Nov 2026 15:31:43 +0000
Message-ID: <20261119153143.4099483-11-matt@readmodwrite.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261119153143.4099483-1-matt@readmodwrite.com>
References: <20261119153143.4099483-1-matt@readmodwrite.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 255D11C0018
X-Rspam-User:
X-Stat-Signature: ebs8zcjr4b5xz4emd5xtir5i13fuct76
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795102336-283786
X-HE-Meta: U2FsdGVkX19x+Shd/Tbfmu5W6Ou3FQcztdLFGwITyCJktrIa/zYtV3vLsju4At2tS6KPQb8XOx8s+e74+91K14CbkLFcsfR1j0crp0H5gSqhgU8zskW7DDwCEz6yMsfPdHpboi1EsQSiIHsGIIgVJfbKLS0toCrfDmpYTIsACj/6BNjurfri0YZTYGjQAR2iabv6AtG16wSHU4ypRNZcrP/tFfftbc0iYwMWnae3WfFcs/fXn/rdEJpvjbDlahi6A04JfzbWdx1YfAmmxaVXMmX7ccLTqBItqAfP+mr7pM5NFdQ4IrDzZbI1KtyvjzjqNFu8mY1KTQ9K4CYO8YASwFwU/wMjug144OynPVDK/Dg04O6WAgCj/gnQ7Hw0umUn7u8WVvdGZSN3EYSdieK2CY8amV1CBEzAD3xTklGIoqYFsWt9oyi8dkHj4QjtwzB9y4UVipzeu5ZSlTld1OnB0muCDQ1aGp+7neraiHYqDb8YuNys0Hu4mst0CdGGxw6Rz9HUtO3QM6mdBzqi8siwX1/xXApua0sMTIl2c1zoc8wQTp8u5nE7hKcdqWnqODTy7TCP/N53nGTUyi/L4VQ88Vt/8Sxx7QXQPh/MoF0G56nqFYZ2/qb5G6DE8zIHxeV2vy93daCMlgIJ50GYodgqAiYY3Eq/54pJGFui5zT4hAOf19EtMQPVBT3+dEzKifDwQTUATHwPjaVDwS7pdMspZtho/J03zXNgIf8nZML+s961ud0k348pQOqLcaCtaldZdZE2oQ1L5O8ATl0iKAfKnVL8K+0x+t8wIT1lX0YLGnUclj1RbrK3yTJWzLCS+/nApzg8Z+bmAdWVuZoSLBskc2DlmrfQyZ6K/zPU5oS5gxdt/pqAQFWt41BEHXYCRh/eY16otq2qhE95pSDvi/6dbwX+e9uJKdMmZsx9nFDNMw3y3iWnNP4sTo+R4nrqEeaqoYMxRBuPX56f7ii6mxq
 p9mFlKbU
 7FGTW8I9eVo85FShqzkHo9bWWunf1QcSONob17QpO5lOJ7LYB221Duvo1F4rlqHW/7MF+OF8RzyakAj60ys2FeB2ftdMmlW3bVeVYpkJiB3lEFZjJMMMyRRQKUGP72QopDOBNDb5pW5Oc8NBSpxbBKzBIg+in42Pl4WfDAM7U37tndecg2Eut9kjzhLOI7HMMZucBm8hR3L29F2IrW30EjRQbA0pdiFRef+MeQEar5u698+nMphR8pk/mJnlR5Dy5ntb5B8nrwGtN3cwYm3EPppdOegjGz30WlRwZp1J8qwUyaCn/vGF/RtnJHkLx8saRBT14R0hUXB71WwW8YXNQ8U+0mZqGtWgiHdEClq/+uUThRzphn8oTmlPL93XcSNKoRgdQqp/2lo8NthSx+ECe4mBLO+T8wobwLOOHMFAdWStnKCEFHgMdAuEEnVGbk3qj+5TNKayWucvQ3KNISo518CsGwKkKPju5acntKUyCKCcvIASajVTPUgYk7TEaQlz+p4Ew7zaG3sL0FFDvpHaOXwOZADfEo6n/2Hgzk+s5ofPcroU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Matt Fleming <mfleming@cloudflare.com>

lx-stack_depot_lookup reads stack_record->entries directly and would
misread compressed frames as full-width addresses. Export
STACK_RECORD_COMPRESSED through constants.py.in and decompress frames
the same way as arch_stack_depot_frame_decompress() on x86-64 and
arm64.

Other architectures never compress frames (the generic hook rejects
compression), but the helper raises an error if it meets compressed
frames there.

Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
---
 scripts/gdb/linux/constants.py.in |  5 +++++
 scripts/gdb/linux/stackdepot.py   | 23 +++++++++++++++++++----
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/scripts/gdb/linux/constants.py.in b/scripts/gdb/linux/constants.py.in
index dab8b80bed69..da6b39c3dc13 100644
--- a/scripts/gdb/linux/constants.py.in
+++ b/scripts/gdb/linux/constants.py.in
@@ -22,6 +22,7 @@
 #include <linux/radix-tree.h>
 #include <linux/maple_tree.h>
 #include <linux/slab.h>
+#include <linux/stackdepot.h>
 #include <linux/threads.h>
 #include <linux/vmalloc.h>
 
@@ -112,6 +113,10 @@ if IS_BUILTIN(CONFIG_PAGE_OWNER):
     LX_GDBPARSED(PAGE_EXT_OWNER)
     LX_GDBPARSED(PAGE_EXT_OWNER_ALLOCATED)
 
+/* linux/stackdepot.h */
+if IS_BUILTIN(CONFIG_STACKDEPOT):
+    LX_GDBPARSED(STACK_RECORD_COMPRESSED)
+
 /* linux/slab.h */
 LX_GDBPARSED(SLAB_RED_ZONE)
 LX_GDBPARSED(SLAB_POISON)
diff --git a/scripts/gdb/linux/stackdepot.py b/scripts/gdb/linux/stackdepot.py
index aaa18af25cd1..0ff06121a8f5 100644
--- a/scripts/gdb/linux/stackdepot.py
+++ b/scripts/gdb/linux/stackdepot.py
@@ -20,6 +20,21 @@ def help():
     gdb.write("Unrecognized command\n")
     raise gdb.GdbError(t)
 
+def stack_record_entry(stack, i):
+    if not int(stack['flags']) & constants.LX_STACK_RECORD_COMPRESSED:
+        return int(stack['entries'][i])
+
+    # Mirror arch_stack_depot_frame_decompress().
+    payload = int(stack['compressed_entries'][i])
+    if utils.is_target_arch("x86-64"):
+        return 0xffffffff00000000 | payload
+    if utils.is_target_arch("aarch64"):
+        text = int(gdb.parse_and_eval("(unsigned long)&_text"))
+        if payload & 0x80000000:
+            payload -= 1 << 32
+        return (text + payload) & 0xffffffffffffffff
+    raise gdb.GdbError("compressed stack depot frames are not supported on this architecture\n")
+
 def stack_depot_fetch(handle):
     global DEPOT_STACK_ALIGN
     global stack_record_type
@@ -40,7 +55,7 @@ def stack_depot_fetch(handle):
     pool_index = parts['pool_index_plus_1'] - 1
     if pool_index >= pools_num:
         gdb.write("pool index %d out of bounds (%d) for stack id 0x%08x\n" % (pool_index, pools_num, handle))
-        return gdb.Value(0), 0
+        return [], 0
 
     stack_pools = gdb.parse_and_eval('stack_pools')
 
@@ -48,10 +63,10 @@ def stack_depot_fetch(handle):
         pool = stack_pools[pool_index]
         stack = (pool + gdb.Value(offset).cast(utils.get_size_t_type())).cast(stack_record_type.get_type().pointer())
         size = int(stack['size'].cast(utils.get_ulong_type()))
-        return stack['entries'], size
+        return [stack_record_entry(stack, i) for i in range(size)], size
     except Exception as e:
         gdb.write("%s\n" % e)
-        return gdb.Value(0), 0
+        return [], 0
 
 def stack_depot_print(handle):
     if not constants.LX_CONFIG_STACKDEPOT:
@@ -61,7 +76,7 @@ def stack_depot_print(handle):
     if nr_entries > 0:
         for i in range(0, nr_entries):
             try:
-                gdb.execute("x /i 0x%x" % (int(entries[i])))
+                gdb.execute("x /i 0x%x" % entries[i])
             except Exception as e:
                 gdb.write("%s\n" % e)
 
-- 
2.43.0


