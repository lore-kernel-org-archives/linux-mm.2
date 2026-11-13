Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4AF8606A32E
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=readmodwrite-com.20260707.gappssmtp.com header.i=@readmodwrite-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=bFuykAQq
Received: by kanga.kvack.org (Postfix)
	id 1619E6B05E0; Fri, 13 Nov 2026 13:57:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 118AC6B05E1; Fri, 13 Nov 2026 13:57:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF53C6B05E2; Fri, 13 Nov 2026 13:57:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA0816B05E0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:57:26 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 62A21A7559
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:57:26 +0000 (UTC)
X-FDA: 85431004092.18.27FEEA1
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8ED9B1A000B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:57:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b=bFuykAQq
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794596244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6z2IIANAK/q43/60wCSqFTZejveLr8Zsp4m5wY/kCvw=;
	b=50c5BdFCzNvf9CX+bzpgldRT0C2aZtbwsbuePnWXIfdOUDIrqYps6e7ZfWxHY9ljwCaBde
	sllbIArGoDNERB1yOdCNzVCNb4cdxuFke5oUIurDs3sW+mksWazYPwCAUh8C3MbyEyQROD
	w7BmJ7Koslml2y0/UcTC8F3t6cphLgs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b=bFuykAQq;
	dmarc=none;
	spf=none (imf19.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.128.52) smtp.mailfrom=matt@readmodwrite.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794596244;
	b=FRndWJHV3MZsiCTdAglU1+xExPIcln9k353n1xklWbZEdYbQvkFHWXOddxUqqjJGbKmX6g
	KXRy38LajM28+J3+/aexAH6gpOeeaWp5gKDUoR5Mbyca5VKJ3oHmgQpO8hmXGQpasimRt3
	f3nCRzIoF2uqTuDwJYLGSkZxRyrIs6E=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4bb5f49a61bso1795075e9.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:57:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=readmodwrite-com.20260707.gappssmtp.com; s=20260707; t=1794596243; x=1795201043; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6z2IIANAK/q43/60wCSqFTZejveLr8Zsp4m5wY/kCvw=;
        b=bFuykAQqI/MaxuNSiYs2HUCGbDnnG4IaemcFQHNL/TRSh7daUgV229Q8b1sEyxlGwk
         Wr/FKeOrKh+pzkRPGbBfMzTGN+DlkGtxNcLSoJcx3Ewu7s97m5hxMNKKVRAlL0fQut+k
         Desi4mgWQx8bxTUAQef6Krya13zJlT4g+HHSEi4Qt1xoKwQATOUtTjTxoOfG3RMCRnIb
         0cKm0W+aKU5VBt8kpvkIiAF7ZAilCx1tAEkBge57jhtq/dTUIQf0KBr8259UbSOJHE2p
         YnGyViOBKmbMevI3g/nQtIenm4oGBNLSv3vc9k7oKaS35joZ5+aTUX1oXeCBdKk+Los+
         UFgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794596243; x=1795201043;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6z2IIANAK/q43/60wCSqFTZejveLr8Zsp4m5wY/kCvw=;
        b=kfRjA4Up+7q6wxAGtdMUCougFRXO6pqasSQamsWo6pc33EkqvDAtJ944vhih9uTUh3
         2ATu6LRBbV8LMzjQ+YrVKUyIfBrmUJPw0Vqb/yidI4GPtmxepltpKYj0pXPqnb84sYle
         YMNIAECwkp6CatZTWyMGZMgbToIw1evv9BeiNlqk1DSEg7buD2rMIUU4xe94O3SeN2aZ
         alWTx0MCxnJ9jp57lVjKbYdzbGb3rhBeaXxx2Z34B6EIZXK0yZhYPYLwMlHiKYnAbhZv
         GY+jJnJ/MLY+7S0BY2utjnhGJVokry5vGo5cWR7aGyd3MILFJuD4ChmXQ92t1rpupivz
         D+/g==
X-Forwarded-Encrypted: i=1; AL+hErHRzhZhrpQF3nzguWa9OFmzcxrcsqxC5B1hNXVzZRMDs4/snZfd6Pa5pil6Xq/VCwAycJ3ypOnekQ==@kvack.org
X-Gm-Message-State: APuU4Z+dIM9tB+Bq3UEpq/BYZlRM6qwUq1ll6W41zDVcPXgrE4MBsZbc
	12pA6FqNlwed1IWaNyC2g4/ruZzMa4iT+w/daoywgNCbkq+0PMym2l9uvXbdQiu+TfE=
X-Gm-Gg: AYBFou11D8t94We373UrhirDS71hOzmisuQsmyNtNlV9aNKwv/bryMfIj+DpMD9N+A2
	58S7Nkjl8q13i0TAOnyrmlnOSVJOquWYuZhgwFGfIATO48R1ZKjjuDljOIyq/KpDOrnNSCx6bBd
	rzye/MGTxcH0IU2WmoH3nP+2DDtb61dO4SHnC/dzo5t1Eb0vxBFdo09MgHIXZWcWCK27Q4Kxc4k
	7U/IkOl7Oe0+T9MgSLzWZRUvd79PDRGFs147IM3RWDqkJ2gmKEJYx+zgOJN16EMgvIF5298jA/4
	ApDKnqu09W2B1Vh70gnO2quR8CxJvZaDYxNHTCydHZLcO7ILAk0cpDORSOrmIGSaJOtrBG89JmX
	4qn024DKFKsFlmUqJ4dqzNVHtM+Vc4VmeaBZnPMlh4FSGV/FnqGHXXZ7jtHtCjKgH8WiY0nAaeA
	sE4MVTRT2ZWuE66+/OohsNVVsJmHSDZwwLCTH4coa36+F7jxeufgtuIcxJMQx4PDuttZxpomlQF
	vJed17lRW4hx8cHfJ0at3eHdai1f35O4wkH+oq6aRThP6gbig0vVY4Ia/SxnqM2MeXO9Sp4XnVl
	bbyW6JpMMouuOiDdEt/R7+xWAsPXhBaPukR8OJaxyfohLK/Z47M=
X-Received: by 2002:a05:600c:628c:b0:4ba:6d8:dfad with SMTP id 5b1f17b1804b1-4bb55a6b67fmr78323595e9.14.1794596243301;
        Fri, 13 Nov 2026 10:57:23 -0800 (PST)
Received: from matt-Precision-5490.. ([2a09:bac6:37a8:ec8::179:1b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5f5972a7sm6417589f8f.21.2026.11.13.10.57.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 10:57:21 -0800 (PST)
From: Matt Fleming <matt@readmodwrite.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@kernel.org>,
	Caleb Kan <ckan@cloudflare.com>,
	Caleb Kan <calebkan1106@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	kernel-team@cloudflare.com,
	Matt Fleming <mfleming@cloudflare.com>
Subject: [PATCH v3 10/10] scripts/gdb: Decode compressed stack depot frames
Date: Fri, 13 Nov 2026 18:57:02 +0000
Message-ID: <20261113185702.1332171-11-matt@readmodwrite.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261113185702.1332171-1-matt@readmodwrite.com>
References: <20261113185702.1332171-1-matt@readmodwrite.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8ED9B1A000B
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: artie3si831mri6rpbn65z83ww5uupej
X-HE-Tag: 1794596244-871141
X-HE-Meta: U2FsdGVkX18ekRSKL22K8fChTXo+dKVXZxfOAemWpu0lc21F5Pt0VIsHVapEJ2rzKzwjgq8e64JM9bhOzPyI3DbsQCnoc7ZAp8EnM4mUnoTUvmrA+pVwQutqm1rkPwvx8nVTPNi0Qer358x5UK//Zcv1VUPMBJKFx7IhrrtgknyAfgcFTA6Hw3ypb1Fnw5CMy1LEmPMgNxe+meif9w3U5c1TDhe3F2ehk8aypr5yNQlz0fCK+jUfhQt7oRXaTk5/VXEEyNl0iWDcQcQR3Q6gU30ZQt/FAhjFA1v7clIHa/Uam5ml13IOqdNTiYOXqk7YT2m/CrnfI+5x0HVUevsxrm2A0jDR3fTCFldk2DVm0BuDsC+zxkmW0dlAUI5g9bv2VCC9Kb2Zg9FxReBKTJ2QjKa6bPZdVxcW/44p0mTgJLx6H2Nk31+RI3W03RyQcPvJAns7zAVOfMAJrcVKa5qPc8VqjPf0ltcOPv/+BsiELy+VuvKgW7BZJnyob4x65j+csoMbeseYXHj+mkNzuUNEYVkGHnHg7XjEACmev877YoXu1V/GKuDnMJUKwsvZnmb/lcwlI8RmCtR1ipw5NRTPozaTFI2MNUpE/CDFSdYSi7a88aMWhp5syvvKoTcALGigRyVJLDEHPlZ2z3Q6LeDhgKo2MXWbVEmJVYhHXaK1JmEaHOiQuEsQMFkeTGyYSEI8TcEskJ+0iEgdc/pu1yWy84xbETZXAUGUN0Y8NxRtcLnjShp3Ot0FU1NL9trarsXvH5GTYCb5L2qZhvNxNP+Tf1uI0uKalKxPmgbVzhKzfvfODThTF6LYrn992/cuLU9vholwJEyAufn9u7gvZfvsM4uGy4Ff9kkPhXh3d/3f2dvUGDOSgEqUTFWKPw/T/eo+c5/iwys+Xnb+A2Bv89IBvxEl2Yh9wYqRltDeNAWOyj97h2/wdCXt35jt0U94IhTHRhXUEscwmZF1XP8qOcf
 gb3JHPEz
 4PSLMOIoEu/qm+q2OgAhYG1sVPh20VqT4J/bI3nUfu6xqE7errCyoSUUhd1YUweYEkc5OyLp+GkdKCaYZlpxiQj0YHak/4xBNCYMqbQNycnBBlTHCE53VUzZl3j05NsDAegOI8ZkvA37BGhWJv3UHyaY45fgpQPxZaLwmqRLcyB53BvEqXkwiVRK7MQ9DPAyuEnGAY2b1ulXvPahsdFk96pMZs7LyP2acQAEsgfM/sB6syf0FxzAb4uQefftzKatdBjy2WkVUamoc1I5TKrR/Mbtgzc80BhJcsCbkj+ctNVS7BlwIrFTcmV9ICNMMjK8G+dRBVyzjtdLniLImmGgok+BDUuzACHxIjSDM+uq2OjtA3jqrSQbTSPAGTmtEZJy+PCJAKt9ceI4UKpa8yGBcaaw/hXivyEqxjTgNjg2wPx3/4yk=
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
index aaa18af25cd1..f689cacb3cb7 100644
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
+        text = int(gdb.parse_and_eval("(unsigned long)_text"))
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


