Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97847C982C9
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 17:52:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55A6B6B0095; Wed, 16 Sep 2026 13:52:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 531A36B0096; Wed, 16 Sep 2026 13:52:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46F5E6B0098; Wed, 16 Sep 2026 13:52:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F6446B0095
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:52:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 69A3F404BC
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 17:52:31 +0000 (UTC)
X-FDA: 85220370102.23.97FBC9D
Received: from mail-lf2-f12.google.com (mail-lf2-f12.google.com [74.125.229.204])
	by imf16.hostedemail.com (Postfix) with ESMTP id AEEFF180005
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 17:52:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FEqGqiza;
	spf=pass (imf16.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 74.125.229.204 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789581149;
	b=hPrk8MTsV8ToYL28I38h3/1pDH0iFRAq0s+6Rpc8IJfG1QynMABNsBcxXBw5W7KdUZ9ipD
	s7+JDkr3MjV3ItyYtXXPCN1n8qYLiSgPLiXf8RIoSCoEd7jI1YLBmGaVKQbmF1jtY7+oIq
	omADFsSdq1PF4tXV7+F7gyDRHl6goDU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FEqGqiza;
	spf=pass (imf16.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 74.125.229.204 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789581149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=99q2Kz8VLvsm/yvtFk2tFIeyCDvYHKpqJj7kva7BYPs=;
	b=ifbg4mT+WAsxDBxpsLCEmwCHhmGc7+E4D2JMbzBzQqI4xVRDcutriT0M/V8TWy935Lzh26
	P7YGa8DobE8GZ8z5DOb4nwofUM06gMEFQUGMlnoFhA71AlpkDSkL5L+xe90pfC7lIEmrZX
	KBafuWH4YjplZFSeq8q+mVaa/xEsFWs=
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b79786cdafso166310e87.1
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789581148; x=1790185948; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=99q2Kz8VLvsm/yvtFk2tFIeyCDvYHKpqJj7kva7BYPs=;
        b=FEqGqiza6YKGkM1TZX4ifnJ2OmcbSJiEg6rPnBipr2XRc5dOluVsPYYCv/GAUbew1M
         qOiGJ5lRvXjnrGXiTIJB6UFzjnt0Vvg5DMVsgrfhTAWVAGYMO50mjdsIMwmJmNIuPhkA
         QsBnHISC6eZFh11y2Q1p2v1NBS4PQt6/ghNdFQosFRHfM+d45hMEEnWFaU+xmUn6are3
         LxzfanpLxcfT5b1oUJKoFt6gamX14kX/iPeEYkwdcjS3gKeY2g5/3g/1JmXdOtdMXVkt
         CHbdI1Xdl6Yum7xkx0loM/5rZcKbWb7Mpc5Ltoi/nLmU8Y7M0m25gtpcBPXFky1WEh8k
         UopQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789581148; x=1790185948;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=99q2Kz8VLvsm/yvtFk2tFIeyCDvYHKpqJj7kva7BYPs=;
        b=2ewMcVhw47UpbDqgaQeqXz1yZR21lKn83KtLdBtJoFVNTi6ZGsSbTEUgbjbO125/dQ
         iYEAbffBRYWNjrqieiflDNFtISlITmMrRuIdTYRKFG8E2KvoiyX3P2c2SZlBlmS3HV6R
         CgydLE0JmKwi7U8Z+2Xzogka2C9ssIjuVe8k3h76/uwZmy0U0EXZ76387kBId97MSZj+
         KKHY10zfYA7oFYAqNui+WP5J0F4e1WKtO6PgK0gmfYaHsnUyYz/x1RndFwejAcWBvxJB
         HMNneVF5frA/IApw+GyqbXNnvEry0rI/3OefhKlqJuXJbJPXUjt45CQqk35+AIL5xdcR
         5slA==
X-Forwarded-Encrypted: i=1; AKwUvBx4PKIUkwahlp5Xan/EhTN3cEKvijd64qbjn6bQnMHu1So4U9yVUuoboRLDESHcNYer2ScnuUjw0w==@kvack.org
X-Gm-Message-State: AFuF++n/v/pQ/ORHKv2LCqA50LWvx7X8L2Xfu+zHpAufC1GY+49VMV1A
	RBfEzqH2cacjf5Y2xs/9pRUFLEimHj5GTJCPS9YT8ZdmemvoTZ997CS7
X-Gm-Gg: AYBFou0CHBWUESaPGQfOweoq1DL3InLxzi6o5NKVvgQY1qOV0ji91UrUgcxozvvtL5G
	rRo1F8aEGt7dSQoA/OxMl2R2vWYxCPJN1aFfFEAXoYqWgXmc4Vjsw20E4rbg/JxloxMpVrXg23X
	lOvCggdYGsguA5tzus3qnhJrNjG4bs8cIe/YBaxrVfyYd/pNIlzc8hNTh3xL4vln+s0+aNzw4JF
	uiI51iB+8zh46TovzjCujPyZcczdc+i8Y9KemPoR+zMXAFH6niEdFL9X2Wur+S9DvVmU4Ch8EsK
	Y+oHa6usQ2dmRWJIXPklqH49kUg8xyMB7b4IMMdmeV9VbtXFw3OnAPCXZHU+eNMoSRG9HGURqNK
	5bBGad4uRGIhl6fLrSmecEchdU46hYozMKx6whmpiits7xSms7uytTjHzYV3eb4s+iWtdrPnC7e
	SD6M9l98mb2UVVlQo69Sx+7Uu1nFjqzZT7opclXjPouK5JmnqgNhPB3fmumC9b5kAIK+xsHHUk6
	xr7RLJ4g1JV
X-Received: by 2002:a05:6512:3182:b0:5b8:b53d:89c3 with SMTP id 2adb3069b0e04-5b8b661a3e0mr1304622e87.2.1789581147601;
        Wed, 16 Sep 2026 10:52:27 -0700 (PDT)
Received: from dellarbn.yandex.net ([80.93.240.68])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8b57897easm1080649e87.5.2026.09.16.10.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 10:52:25 -0700 (PDT)
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Shaobo Huang <huangshaobo3@xiaomi.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] kasan: unpoison task stack below watermark only in generic mode
Date: Wed, 16 Sep 2026 19:51:13 +0200
Message-ID: <20260916175113.1327454-1-ryabinin.a.a@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AEEFF180005
X-Stat-Signature: ckczo5eeuo5uai5dowechkcrk458twr8
X-HE-Tag: 1789581149-410244
X-HE-Meta: U2FsdGVkX1/pidBVc3zGvyNE9sCmrbCfPFSmdg9XzbghsY4WxBaSmUOGgWg+3YFXejCD1b9zEVNlbLq9qqAV3UEv6vlONuh3wNrk++wmUPQZw4o01TgnRIPwm/mmrbCIP/krtU8arudeoGnsfs+KUTbtq6QjcGCYhDctmNm60SUNn3b2rVezsgXlmtQ1crzQCSSMk4p3pofnTCIbqtupicvnFeMaF/VjphSQO/yKekC0yMdZ7+EAGgT0db/3Q6oFz8J2/Fa1UOMeuXD96NDUDdYhKNFpznVeqV3BJ4xgx0JX3E0S+CkkhVgOckczdWtWiho+vhIctiIrtpGXthrO/S7+0LADy9ekN/hP59oxsmSSg50ZndvRwiblXFajOIZbdz4SrxnToLRRX7sKiUxPAWXJEdQqb5HGKMeAm4ba9jdUprvyvJrjdkqy7UCTyYR4D2q8oSc+kW9HN6FhRTDVTGR9nZ+x5kAW0fX1GxtSrcA5mVb96w5L/+fkeAhpdTYKGsDAhOtdVr6RSd7o8NAPXQ5lKEXnqTF7x//bN/x7SVXbSy2uvMO5LtJRAhfX8EmlxkBdTB/J+PGDrBL8FUR/ImgrvwlQOeEjRDjmYaWQuwXf0H3e0yUb0k9j/dq85RNhSTN0meS79W2TLWOdq+rFKZS3lGGKNrY6tY3xiZmBSp1buCnqHlQEOtqiIZdEVKonTqILhrAi5xst4ejWUsqOhr7P674FZZVdyCbqFrEmv/H8J+mp9am+e3IhGh+PMIrFNIdMLNUpJdUhFe3z2+yrmbiEyMdU3LsuDu24cUBxeLAMlPHuGHSQ0Yg9Ioh450ZQ/VqPfNPyQBjdI2XACo+D+GAtQbZq8HU2n8C7jLDB9kSOgPZrEJH1meZbbXh95Pz/xhy1Nre12tq7cWwSFR3cALgaUVvLEJRUGo7kzsiRsAWCf5wZ3XmkMjFHy01V3dZijOFVj9l43apLFmmYgw7
 YHab9Haw
 kjKQpQCIn8MddSF8Zarp4OyJt2LTfBM2UMGuOYVBMUKwIqKRqo3ApTRBdBqz5WOpUM/gg2qaqDqkQa5ITSCGfYSRAfV9Ir3hyhLwpQ5wlDGnSnQH9J5/4Y6MEOQX2oMN9X3v5sWC/GfxRErf9Tz5V4NFns/0fH0dxVPYjGO3M+1f9aJ+OFTg8z2aNde4wyrA7yqXjZcPgRKVK1YQv+WXbR7wSbMFqE1jTefEkDT6P9FoIw9l1pG3RW7SS7EJkJWquSIluDRYAcN93VP1seMKh67/Fjjd/saJ6cTYfQzH7YvpFp2vsFPtuKHWKWDboygduHlClKm5plL0AjtJ2VZVBobEkpSw0DurwPUcm7SedXyUGjWAFHIRXLTEwckrWH9qmW9eh/aMoSs5+dONlrdVIqLthCFxGnZt+7sHnyB0dctLfVW8DrSFVW6ILljSTWAdpBjb2kqMcKOdSxmj2Z2PL5qoNHM3Z96Wb3iL5GP13rmWxUTFnxHtUTkcnEcRQ4hc4D1GO/YHoPMQ17dq7clRhq+s2Ww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CPU resume and BPF exception handling can discard stack frames without
running their compiler-generated epilogues. Generic KASAN needs
kasan_unpoison_task_stack_below() to clear the redzones left behind by
those frames before the stack is reused.

CONFIG_KASAN_STACK also enables this helper for SW_TAGS. The helper
derives the stack base from an untagged stack pointer, so
kasan_unpoison() writes KASAN_TAG_KERNEL (0xff) into the shadow for
[base, watermark). For a vmapped task stack, vm_area->addr still
carries the original random allocation tag. This creates a tag mismatch
at the stack base even if that memory has never held an instrumented
stack object.

When the task exits and its stack is not cached, thread_stack_free_rcu()
passes vm_area->addr to vfree(). In RCU callback context this reaches
vfree_atomic(), whose llist_add() writes to the allocation base through
the tagged pointer and triggers a false KASAN invalid-access report:

  BUG: KASAN: invalid-access in vfree_atomic+0x90/0x150
  Write of size 8 at addr c2ffffc0a8f70000 by task rcuop/7/75
  Pointer tag: [c2], memory tag: [ff]
  Call trace:
   __hwasan_store8_noabort+0xe8/0xf8
   vfree_atomic+0x90/0x150
   vfree+0x220/0x298
   thread_stack_free_rcu+0x3c/0x4c
   rcu_do_batch+0x308/0xaf0
   rcu_nocb_cb_kthread+0x33c/0x708

The deferred-free path started using the tagged vm_area->addr in
commit 449e0b4ed5a1 ("fork: clean-up naming of vm_stack/vm_struct
variables in vmap stacks code"). Previously it freed the untagged
pointer derived from tsk->stack, so the write was never tag-checked.

SW_TAGS does not need the blanket shadow reset to make subsequent stack
accesses valid: untagged kernel pointers have the match-all 0xff tag,
and the compiler initializes the shadow tags of instrumented stack
objects before use.

Return early unless CONFIG_KASAN_GENERIC is enabled. Keep the mode check
in the common helper so it covers both resume and bpf_throw().

Fixes: 449e0b4ed5a1 ("fork: clean-up naming of vm_stack/vm_struct variables in vmap stacks code")
Cc: stable@vger.kernel.org
Reported-by: Shaobo Huang <huangshaobo3@xiaomi.com>
Closes: https://lore.kernel.org/all/20260806123020.90869-1-huangshaobo3@xiaomi.com/
Assisted-by: LLM
Signed-off-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
---
 mm/kasan/common.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/mm/kasan/common.c b/mm/kasan/common.c
index b7d05c2a6d93..7d21c4db68d2 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -114,12 +114,23 @@ void kasan_unpoison_task_stack(struct task_struct *task)
 /* Unpoison the stack for the current task beyond a watermark sp value. */
 asmlinkage void kasan_unpoison_task_stack_below(const void *watermark)
 {
+	void *base;
+
+	/*
+	 * Only the generic mode needs this. In the tag-based mode the
+	 * compiler fully initializes the shadow of stack variables on
+	 * function entry, so stale tags left below the watermark are
+	 * harmless.
+	 */
+	if (!IS_ENABLED(CONFIG_KASAN_GENERIC))
+		return;
+
 	/*
 	 * Calculate the task stack base address.  Avoid using 'current'
 	 * because this function is called by early resume code which hasn't
 	 * yet set up the percpu register (%gs).
 	 */
-	void *base = (void *)((unsigned long)watermark & ~(THREAD_SIZE - 1));
+	base = (void *)((unsigned long)watermark & ~(THREAD_SIZE - 1));
 
 	kasan_unpoison(base, watermark - base, false);
 }
-- 
2.55.0


