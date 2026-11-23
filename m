Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3F59606A333
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 15:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=h0PjryXV
Received: by kanga.kvack.org (Postfix)
	id 087716B05B0; Mon, 23 Nov 2026 10:23:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05F806B05B4; Mon, 23 Nov 2026 10:23:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB72E6B05B5; Mon, 23 Nov 2026 10:23:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BBEEC6B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:23:23 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 475771208F7
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:23:23 +0000 (UTC)
X-FDA: 85466752686.26.F8EA03E
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf20.hostedemail.com (Postfix) with ESMTP id 688D51C0006
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:23:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=h0PjryXV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ngocthang2710.1999@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=ngocthang2710.1999@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795447401;
	b=rEtGg76h7NWIDeOOElo+E12GBeO7bXsP6yyqucKkQnQlBoq8z4+XN93WXtBBG8gAaNwgI/
	49bY3BtKcJtnhpWxZ1DtynJgz4sjCO2eq0QCiNtjXxjmx3rSC/aUIe4DlBHMrN7uDdWkWT
	6rQ7SbYUK0u+OkwO3zC6YGv87hYACX0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795447401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O52/z45+638cNdNcb3gm/OrMOWWSLJyJAuo7deVUGvc=;
	b=hcIqlkVYpbq/Wxy7VJHrIMp7qTAJBobhrNHDQQeslkL0dUAoqujN89GWp01Z7jocKaV7Yw
	DOCY2HAO4fEn5Y3Jrm3chvuI4o4plKQqMlFag9qsda1xwcIQbHlXqpAh+v+hFEGi9i/Tv6
	iqkBvKVfbpZPoi7QdQQhhmBcwyF7o90=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=h0PjryXV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ngocthang2710.1999@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=ngocthang2710.1999@gmail.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3b413997581so2889127a91.2
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:23:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795447400; x=1796052200; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O52/z45+638cNdNcb3gm/OrMOWWSLJyJAuo7deVUGvc=;
        b=h0PjryXVlUzi+5x9E9LUv8qhGkhFHrXXKpvN3yrPj9SqlTWxVrTXjzb+LB67I5zgbU
         Vol8YXbbVJksiFVAbiM4xtA4/sbX+c7q9bl6L5qRrIzeuv1SbqH3Ehh9hncnP15ckVVt
         hnWJ8+S3oWOvkJ9UwMIcq8I2TfZqGG5oyH3DtWiXp4L8aIxQgqpVWn+M+D1n4h2TrHV2
         Ww0oNAm9nuFJ/bV/5j/LXzK3eN1FebzuWRzDxGTLMSYjA/P73KOXbmFqHG2RMKYgMgQO
         /MBzKQ5vbN6efLjn/3AbGfuya+W7q9N8XwxDvI26tAaEtaQvm6VzC7mtL+eaJUQYFHdJ
         eWPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795447400; x=1796052200;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=O52/z45+638cNdNcb3gm/OrMOWWSLJyJAuo7deVUGvc=;
        b=EVou3CkR8gGNKQMgxljzv17e/yVXt18Y40C2pCBMCX0lDtVGSAK6/nokY3pnFkYjK+
         4S9rX45XAjb5SknDlP6143xa3dDu7cbgpUP70EgYI00O1ALIJxOghfiZjpG9PHpatAlf
         hFn4aVuCwG5mPhel4pHIPQV94j85JIE99Ghp5pDakGEsQZBnHWdc7A8C6l2DHAu5vfeK
         h3zc6YyB9hHY4CtcOxus1xNhj4601wtmFoidkN5qy9Jnmw0O5T5mUqYiVYVaZWKW5WEt
         ZkxKGi/y8lWgxHCJiZOA9hEjExpqPlsapgXbMFeGvinTTHHZE+KplGtHnvPfbFhalumq
         p2pw==
X-Forwarded-Encrypted: i=1; AL+hErGS4wzvbRWM1QJwP5hGhma9zVe0eitRBK344DyYEzeMWg7BHIsM0Qh1sgqpyCU34ZwBddemDA2rYA==@kvack.org
X-Gm-Message-State: APuU4Z+navvjij73vjW/Yj/KDZ/BUPtuTi5U91g7VVvhxfuNUH12y8zR
	7WgNOeQlnrV24W6Q/MQv6AYJQox3bAo0Sx0Y4ZN0KMAYo7dfGjUNydP2
X-Gm-Gg: AZFdTZeYtztFquEZW+DLT58hdbUrXrHm9B64lIiA8E6NvAOgrSEbELRnwaImvgR24fy
	OhpAXaMpqOYIoP9IwOkxvmTm5b5OlytofrXR+5yc9h4Lf0Fk0V6EKB6JATNyTJmOb3cLED2V9nw
	qPcTyZcb+zfw9YbjTYv8azftWIp+tH0YA60lK984QVuEqb5EI6vNH0shJ5VkWUBzpxfHhrfpDVK
	zSr1/ja26R3hLlAtRUkZM/CniL3/0YYZHRLKWQrd90Yp1Zkg1p67pbaC26a1m63048uBK9CEiwe
	jcswA63wIqgJZppa9ElhVgdZzNyBuAv34gDkeV5KdpQ1henFvSgnry1iXAg3FOKayNJ/q3uTXzU
	/+9jC7LsrBbpdFJUtelJUW8yxELnYVwVS1/pcTTZdub55deLlsE4BU+xZ9DPM/aOycDylSHzHQr
	jrjOO/8gfruwFHNghR/gYCcLv7ybj+zfBMixFpOKiU1INQn4FTS4iOjiqMaZJxKH2bOFgc8Wt+h
	EPC4T/OfaH5RMP4RfdbAFLFqJqH4mCeY3IzHLx0+bwlGWSRGM/YSaut4tRm73NQX34Ye3ZOzqw5
	F4YpZWmqZsDWtSJLUDWgeT2wPMflvM8=
X-Received: by 2002:a17:90b:3810:b0:3b1:bee2:223d with SMTP id 98e67ed59e1d1-3b41c9bc27emr10778729a91.53.1795447399920;
        Mon, 23 Nov 2026 07:23:19 -0800 (PST)
Received: from thangnn-ASUS.. ([2a09:bac5:d452:16c8::245:e])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41abb1b66sm19145548a91.1.2026.11.23.07.23.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 07:23:19 -0800 (PST)
From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Breno Leitao <leitao@debian.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+527fed49e5b988882c9a@syzkaller.appspotmail.com,
	syzbot+4d078516add5f4f12cea@syzkaller.appspotmail.com
Subject: [PATCH v2] mm/slub: don't let kmemleak report rcu sheaves
Date: Mon, 23 Nov 2026 22:23:13 +0700
Message-ID: <20261123152313.359601-1-ngocthang2710.1999@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261113151837.123795-1-ngocthang2710.1999@gmail.com>
References: <20261113151837.123795-1-ngocthang2710.1999@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6uxk3jrs8bmuu5e14uadskjhwgshx6eq
X-Rspamd-Queue-Id: 688D51C0006
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795447401-766281
X-HE-Meta: U2FsdGVkX186jaRHmYbQMehIV+3fOTo7h49CMRCxOOri9EKEl+7HyfpANL4FpqbcwzEICI4QCxGaHPo9dVoGnwZt7Ql50v4lIv3UGMDgva9Hpk1WzefhuL/Klp9BfXqJ9QUSLs24sI/XLqq/P1s/3PcD5mucK4QxQdR3U2CqTigIKPeg8f+KwncDYWip2FqoE3A3LG8hMvcJpEPMzLpZDIP3CZmmZ/N5a1nHKItNucPDIqkIzvCicPUnarsqR4vptV3XuvgIpqUXa23iqzPqWoc8wcbdlCpW6hGZSTfnJayiZhOraRblIUbQCCPcLEWakFtLgfGNRxXue5Jv4P4rzkdQxL+Ne1sfdoQL26EKjaZME7y8QA7nLK5pi4spCPWC7KndcgP6/9V+XM8kjqM70tm/WFt6bC5QqigflnBGBy9bPnSl6gyEclgh8/NCeoId91H7ix/QsJabSvqwFn+XYcuKl5+3hJuOdvCQ2YysRfX22K9FLgSJWTQSyJh8Jo/OYDxXjWw6mahUZTH7aw1d00JRNlmeINW8B+bzAuNbx1QviabgYosHfov91FGEp4NcFlesvuWx9mPhXrjLJCR98xQaWd1WqZ4b5v/s5laR1hdNApoudmY/MPDWT9MI6O+0Y1amGYj5En36eVwAdrFV/6MUW7CovdzNJhTUj2OlZpn751PpJST9w78bOVqESKog3JJGOnMgVGT3lFDmNxTCNXZVqgU0N8/BauKB+pUBYzyhGxtYh6g0PfXilc/g8Fw+oS4HF8ase3XE7e56xMS3VaS/V7qcAZ9gqMuUMNFyt7qj6jt5xC6Q24MP2ncPRZ2cOV5L+ZnYvymS5aWVKbnh7OJm6wImyPTbIYNs83xyzdQ5YzyFQhRGmhIdjDjRwCuPcJ98krjg3D6a5d2p6FyghzHA8UKvg7VaZcnlS9+qt+Gmn88jrR/k3cebU70LGGSr29QLR5gAAxlDuIOpsLJ
 XWAZipwj
 V7/GelaRnBP1RQJj4WyFZ/BUmQeKaAcBMZV8JqpFJEZRCaJFqxJyV7yZ+4SkKOWyBjhAT6J0MhuzkgJAvgigzz1umNIqPGeW60CN9SchMqdqZSytLftYkUKq27B8v+OtG7/CuGdmlGSCSW32vJ02zvgieQ441zjNH0pOKVBV4ChAgCOgy8hFo8+AUuyLFUkGwEm+FHP3t1+HOGrRbjLxVOfyR6VhuZJdgHSYX7cQ1YsTXA6yL1fdLtsR+mUXWZH41yzGto5s53Oh4Og/lfZRApCbvF7fUM6M9asMvx5EvhkMRvejLnYuBE1bp9pgay2hG6wYdslMh/IBnzgLLUV1DIKugr6/+0EirzK/hKJIgj/COs257Ib/tpp3KQ5pvAx0Gi0xtPmOK3tzKAqdXfWFXTQA3zHoKeGe0Yl4sGnQWyiyybakTs2UY6o+2iuuV6ryMu1juaeoD4pN3QcgelXi5MW9H9RP0fE3v7aTcPL2kR6Zbzjb0fJB3PN7PwDtNaZit8p1y9wGH5u58cz0aIVKhJx9mEy62eoUrwEEHagUCDy46esRzT157KR2W6UPqvqRApME0x0m0tKovCd69btcXIO9u7H/ll7KsZtf09FlIVMCTSykCl0LNPqjaBYCGXG6AmHZY1iL8kJjOwr4DFDmIFcEnsMveQWxGTmmZonfzYmDIvgrP2rnKhc/XVrG1B+lOKtBMkaf7q4jabz0CBa3ruIdCFexM3cJvDHa9YyTrU1yXYLIXqu2sZ+VUWkBNUhezG+sflrfogJS+uVnpGxWwZUKVFGwepWsu/A6TIH/5dhxtuZ84Fv+DYyFi5wEngRDoz+7xTKhhovV9Ua3tJOO0SPRkJko3Dwzlp/itGkON94wPorU1CfEB6I4GrpjQQXddmoyxSojSvXxGfjB0fT89IIQhG9oSKjY9URf9mANMCqw9E+4YkZ6AB+KPg/9LbJq2YXzJ+9Nk2hMjUiW+sxo5bZ/ifw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

kmemleak reports sheaves as leaked:

  unreferenced object 0xffff8881009d4e00 (size 512):
    hex dump (first 32 bytes):
      b0 7e 81 2d 81 88 ff ff 60 bd b3 81 ff ff ff ff
      00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00
    backtrace:
      __alloc_empty_sheaf mm/slub.c:2854 [inline]
      alloc_empty_sheaf mm/slub.c:2874 [inline]
      __pcs_replace_full_main+0xf7/0x330 mm/slub.c:6094
      free_to_pcs mm/slub.c:6147 [inline]
      kfree+0x353/0x390 mm/slub.c:6923

The same happens for sheaves allocated by __pcs_replace_empty_main(),
__kfree_rcu_sheaf() and kmem_cache_prefill_sheaf().

The second word is rcu_free_sheaf: the sheaf was handed to call_rcu() by
__kfree_rcu_sheaf() and is waiting for a grace period. Sheaves are
recycled between the pcs, the barn and rcu, so any sheaf can end up
there, no matter where it was allocated. While queued, the only
reference to it is the ->next pointer of the previous callback.

That callback often lives in memory kmemleak never scans. kmemleak
itself frees every kmemleak_object with call_rcu(free_object_rcu), and
those come from the SLAB_NOLEAKTRACE object_cache. struct slab of a
SLAB_TYPESAFE_BY_RCU cache pending rcu_free_slab() is another case, as
slab pages are frozen and skipped by scan_zone_pages(). The chain from
rcu_data is cut, and the sheaf, typically old, looks unreferenced. Since
it is then not scanned either, the objects it is about to free can be
reported as well.

Making kmemleak follow rcu callback lists would mean digging into rcu
internals and would still break at any untracked callback. Sheaves are
allocator metadata, always owned by a pcs, a barn or an rcu callback, so
mark them with kmemleak_not_leak() instead: they are never reported but
still scanned, so objects queued in them stay referenced. Allocations
that can't spin are not tracked by kmemleak, so skip them, as
alloc_slab_obj_exts() does.

Fixes: ec66e0d59952 ("slab: add sheaf support for batching kfree_rcu() operations")
Reported-by: syzbot+527fed49e5b988882c9a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=527fed49e5b988882c9a
Reported-by: syzbot+4d078516add5f4f12cea@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4d078516add5f4f12cea
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
---
v2:
- Rewrite the explanation. v1 blamed struct slab, but in my reproducer
  most reported sheaves are queued right behind kmemleak's own
  free_object_rcu() callback, whose kmemleak_object comes from the
  SLAB_NOLEAKTRACE object_cache and is never scanned. struct slab
  remains another possible break, as Catalin pointed out.
- Comment: "e.g. struct slab" -> "e.g. its own metadata".
- Also fixes syzbot 4d078516add5f4f12cea (sheaves allocated by
  __pcs_replace_full_main()), same root cause.
- Rebased on v7.4-rc4; applies to next-20261120 as well. There,
  sheaves of SLAB_NOLEAKTRACE caches are not tracked, and
  kmemleak_not_leak() on them is a harmless no-op (paint_ptr() ignores
  unknown objects).
- Code unchanged otherwise, so I kept Catalin's Reviewed-by.

v1: https://lore.kernel.org/all/20261113151837.123795-1-ngocthang2710.1999@gmail.com/

Tested in QEMU (syzbot config, 2 vCPUs), stalling a grace period with a
preempted reader on CPU0 while CPU1 queues rcu_free_slab() and
rcu_free_sheaf() callbacks, then running kmemleak scans:

  before (v7.4-rc3): 176 reports, 82 of them sheaves (allocated by
          __kfree_rcu_sheaf, kmem_cache_prefill_sheaf,
          __pcs_replace_full_main, __pcs_replace_empty_main), the rest
          maple nodes held by them
  after  (v7.4-rc4 + v2, 4 runs): no sheaf or maple node reports.
          5-9 reports per run remain, all from a single exited task
          (task_struct, pid, creds) waiting for its RCU callback. Same
          kmemleak blind spot, not sheaf related.

 mm/slub.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index 5c33d12470601..ed52c1c5d31da 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2856,6 +2856,14 @@ static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
 	if (unlikely(!sheaf))
 		return NULL;
 
+	/*
+	 * A queued rcu sheaf may only be referenced by an earlier rcu callback
+	 * in memory kmemleak doesn't scan (e.g. its own metadata). Never
+	 * report sheaves, but keep scanning the objects they hold.
+	 */
+	if (alloc_flags_allow_spinning(alloc_flags))
+		kmemleak_not_leak(sheaf);
+
 	sheaf->cache = s;
 
 	stat(s, SHEAF_ALLOC);
-- 
2.43.0


