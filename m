Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4CE8C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 05:39:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87AFD6B0088; Mon, 31 Aug 2026 01:39:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82B556B008A; Mon, 31 Aug 2026 01:39:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 741E56B008C; Mon, 31 Aug 2026 01:39:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4513C6B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 01:39:03 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 29A3314041D
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:39:01 +0000 (UTC)
X-FDA: 85160460882.22.C0003F7
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7E0F7C0004
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:38:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="CIYH/44P";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ngocthang2710.1999@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=ngocthang2710.1999@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788154739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DCO9UVAZL7IBEVYT4FWzK81SLKfxURvKrv7BU2smeUE=;
	b=oK+cnMrM4f2jxvNP8qNNRNfNilHLysmAeddM6OpdDamltnltXJMeTAEvGAtISaPYQORicL
	L7M7+fk4mEJVwEbHwh+T9YUFM6cIGHYZJxWNVIQFyIxMACyrsMS+3hGeoUZadBVBGkX8Fi
	eIGFqyxMxrPosDXZtaLajvtN6264RpY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="CIYH/44P";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ngocthang2710.1999@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=ngocthang2710.1999@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788154739;
	b=eZ2x64FCKRW/aTdXxU1doHVlqibFtapFTyBUWQaYMM0U0ANb/fSrvPFfN1p8+MkirlH7lw
	2RxrNwGB4cy3OJ0KzXH1db18Ogld4yZJeWgjAWmMghOnBnFhRubQNcHPBAO7QIBra1cTyB
	lbXH1YU8oSo7KdOES2q+xsKp/hDxHDg=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-84864086bfeso3166710b3a.1
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 22:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788154738; x=1788759538; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DCO9UVAZL7IBEVYT4FWzK81SLKfxURvKrv7BU2smeUE=;
        b=CIYH/44PcnqhkdAZCb9Pk5SnGdCTGqxliSCkM9R7b9v+ztRfc5R981sPhaUvtiaR0H
         jog9PjsVVSiAjpOm+4E82kAnK3uQtE2YzLm1N0z5glFzxoHdLPfW+RZ//GPmzDGjHoqJ
         PeArqQzTLyAJuAK5kPsJ010pjG6pfHpvXdZwjeUVltPUY1jyOIZeyhfwMW6FMKB6xrSq
         mmTj1QR7K/7jnYaSgr5Tygqz/573rLVvXnym4Zgh3kIcyuQifNgT23j/ObCZ297Tuo74
         IwXFPoqmelPJR0EVmvNM6MN5kZ6syNH+1WKcKtU8Ez4vDwRIVtYr2odAjxgok6biDMv9
         /tmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788154738; x=1788759538;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DCO9UVAZL7IBEVYT4FWzK81SLKfxURvKrv7BU2smeUE=;
        b=QxX0cPsH6unAcyklFk8ek0wPD72eTZnkXz1JxDywaGL9nxNeMv6RRy6HVuuzglNPlP
         1hDgw4jZ0AmtkqOQ3jehknMLMgGNoSkeaTp6XezXhZ6P+wDwwclvzjJPLdbPRdtHNviX
         MQ/0kU4j7On/1qJ/OODdWhZDf8xfnmB9cpsjH8TH6GHLRqvYsuBnm7piY0zNLykFD3pQ
         DF9qq7AIYygDAUCqQUMLrtBeiyr4e8RrZe8imV/gm5qCh6AczluA3PLj+ur04qpcQl54
         D0kFdo8pIyoBeWmKYXM88mn99VixQopCVu7GaUHGkI9OFVk34dVJCj/DCkelnJFNqijG
         oitA==
X-Forwarded-Encrypted: i=1; AHgh+RralFIyPEQcD4COEC7wQBMlzSkTVWLISh6awdmMxM5s1AXr6zTUtEyN8yZ81C2xxNGMV/BzIWiLVA==@kvack.org
X-Gm-Message-State: AFuF++nKW/WGQNggNVXkW8XT0K2DySRrX7rEcNFzN8HJTOd+kDKdZHzX
	b0JjAB/Sd3x+gblVuzr1mRJJYW4gG07L2KUtLxTVjrFMvklMTlTKUapY
X-Gm-Gg: AR+sD12U2x2jnrDp/VNnMWrkaBW+Zrn5TJ+og2LZACCiN2hcZSfYiJkJtf+658R75iU
	Xz+hmj+BneM191DLPn0STrItPGNwX+HDDt8qRlyv6ZUbmKELok3FcnOl94ghiGz8it/bW8cY7Qn
	C6JkyyT4uQGEYhPdB2LFIiz2RBuCx2WMFkKseZTICkedmgFwC+RzgjjqBgv4wQwXV6rUnZCfGnB
	ZB6GAGj79XiLg4GfASXtaU/2AI395sRp09FehKbcLvl13Q3aaQw7zrlcw/wx3m5Xh32ygEwLkX4
	OB2Jh1VdUG3Jo/IB1dwwZC1bxfQFMCm7Y8dpb6BN/IkivUy06o7YvsZuPoQOe2EQTRf0z00qdHk
	vEFei5nSe0Ps1W781VYcxJ6bNQpiexw3+8ZN2uWmeUYSHzenyiDKgVV9YauWOBPJbXeeDzOo3s3
	wv8ONZ/s+mu7osBw1sk5DCVqLNWL1m0NS2H5dPbK//n1F3K5267hfz0O4bUkY89wNVKZsxMTjxp
	6iTpl9ncQ==
X-Received: by 2002:a05:6a20:9c11:b0:3d0:9164:98a7 with SMTP id adf61e73a8af0-3d2686a9ae9mr37495013637.11.1788154738197;
        Sun, 30 Aug 2026 22:38:58 -0700 (PDT)
Received: from thangnn-ASUS.. ([2405:4802:21dc:72d0:19f0:b2d5:4cfe:4463])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc1f36dbf62sm3505850a12.25.2026.08.30.22.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 22:38:57 -0700 (PDT)
From: ThangNN99 <ngocthang2710.1999@gmail.com>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Cc: Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	ThangNN99 <ngocthang2710.1999@gmail.com>,
	syzbot+acf142088e0182172e58@syzkaller.appspotmail.com
Subject: [PATCH] mm/slab: don't use kfree_rcu sheaves on PREEMPT_RT in kvfree_call_rcu()
Date: Mon, 31 Aug 2026 12:38:46 +0700
Message-ID: <20260831053846.107974-1-ngocthang2710.1999@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 89xkobc1a5kiteowy7mgdh54p3f9xzgg
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7E0F7C0004
X-Rspam-User: 
X-HE-Tag: 1788154739-927030
X-HE-Meta: U2FsdGVkX1/rc8dnbcMAIdOgo4gfw/4Cnz/r6XX5YBvFkwbdMJbOOwNGX0DG3uCmDzQlzCFcEElX/rp3FyZ+oCK2uXHqBDLBasJMuq5XoyfL/d0qcSlZol11CEVBSx5tNRnjrLwyEVFKe8gw7c4TJY85H7IaG8C1Y2e/5nzKAdSmp1577P93N4EGQGBkr0VmWhV2m/Zse/WX5vs4AbQ3jMwOeckQ5e+Q1bT2jcrbY9fImvkwMdXIjX5R4UIyD/7f28VUX6ce6QiDx3MsreX1iRzRFS5UBCgO/XdDdTB296s8v0uFLFPiNI8LSwoooEcQEfbAvvQUeGlIzA0Fi14RDwkE+KAoN9Noffrxq186YBTjostLexZxY6QMYTj1pcmvuSjIMCN1us6SmHxSwbiGsxkdPPB0vZjTbpkVQCeeKTO9HKCyHz4CLZIL0Im+4ZpguIQSk/6EWx/6j9ZzX4TAGvCsiH/h6bbBnKgdzchQhAZLyRkG776GqW7zc8KpKxZ1JQ0nwOMgdWjfQwZF5rfivOhaMAvSZVGvlWhSSXzwQR6YMNNe0cpXIMkNv6Y1KS3H/wqIWsDAcCGxeGrps9S1cyR2M12HTyHrQcu69PcuhWqqwI7w0UKHkwUSnRQtFToOtK9iYcut5AbKWhGXIBH7WdvJ9USFuRZBWsLqKdTltvcnWUqPEvTeTIWOr8ZCAsQJbUOdIAxv+fmf76UjPkIicEXO6eSLuM33uTu6kyydHJOYHXsuzL9W9v2m/LCIuf5k/K7HQatRgDQdTZ1RPxoDod1sbJZt8NwVm24qeU/h6mVKJQtCrUreWVd9oe4jVSDpIfo0bTd5WPdL7LmMZCYsBzOgxkk62CXdMYR7Tn7I6M74BDKUgjlec/P3zEP/sZQOdVBJjoO9VbuSBXEO/clMNiKbCpLGanF71LV+LwJ2biL8WlRHdLazzXOlYLJzi3JeB0Ub1A0ARfNVx5I2Hhk
 mvQlKimF
 TRkscsgSPznsG++MXtwbePIghA2xRGtIx3i3Swqwfl0r8Bd6vd3N0oG5LS8JygqH3y3i8odV89QhDxBIMBpB4u3dVR8EgJvua+mD/9xou62Amqk4kVlw8/U7yNygx+LJtGj0/cqCMUFgYukLgnNLvuPscj7w5VrBQQkjvdC2yi/ixhKf5Z3kP/z8nRzeMuVFCdxgPrvh8y2pimz1ZkV8uA+Ck+bjwy3jQdgVR7PryXOLGTM114gCrJLLCy6dsIFaP9FKtSkFGMPC8Q18aal3h9bXHVyU1Yzl9D+G0wvYrMCfxd3a76+71COAaFJhHWYR4yMuGdiWeJCom75v/WcPvJRxBStL5Zc5t/PRpc4qylVxyIZtfYqU1BcTQc7+9qWP0G+o8SNMC20rQVgv7XNh2K1GAryBMp/vAtWNE7fcmlH/D3l9cLFY5YrQVNqenRx3l3EYvFGOGZ/68Gd1iqkBu68vua/fVvsVlRHZaiWEzUKlP0ff8E+rEEinbjEbj1eI/obUIyt4DoJVz/hu8UGd9L1CaQeinmpKH3h5uwp8ifEyivGXu+8J8dGF4gRCbEt0YudaAwuP/BGMF6ZAnVtg6Z5dNwB6+1ctaJZgkjsPR5TTnR7dRdlqm1Z/m4m36DMm13uQcuQFQqiuCOsaFBz4JkPykxpC5ihvIjzGMo87xdHlO0cyma3Zh6gc4vCu14qkPA+VA7/f7mffP65ReHrB+7wSD3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot reports a possible circular locking dependency between
&p->pi_lock and the per-CPU kfree_rcu sheaf lock (_T->lock) on
PREEMPT_RT:

  __balance_push_cpu_stop()               [holds p->pi_lock, raw]
    select_fallback_rq()
      cpuset_cpus_allowed_fallback()
        set_cpus_allowed_force()
          kfree_rcu(ac.user_mask)
            kvfree_call_rcu()
              kfree_rcu_sheaf()
                __kfree_rcu_sheaf()
                  local_trylock(&s->cpu_sheaves->lock)   <- _T->lock

set_cpus_allowed_force() uses kfree_rcu() instead of kfree() here
specifically because it can be called with p->pi_lock (a raw
spinlock) held, and plain kfree() may sleep under PREEMPT_RT.

Commit 2a8bb29ec9b2 ("mm/slab: allow kfree_rcu_sheaf() on
PREEMPT_RT") made kvfree_call_rcu() try the sheaves fast path on
PREEMPT_RT too, since __kfree_rcu_sheaf() only trylocks there and
so cannot itself block. True, but the sheaf/barn locks it trylocks
are also taken as regular, blocking locks elsewhere, so lockdep
still records a lock-class ordering cycle against any raw spinlock
already held by the caller, which is what syzbot caught.

The plain kfree_rcu()/kvfree_rcu() API gives kvfree_call_rcu() no
way to know the caller is in such a context, so keep it
conservative on PREEMPT_RT and skip the sheaves layer there,
falling back to the existing raw_spinlock_t-protected krcp list,
which is always safe to nest under another raw spinlock. This
restores the pre-2a8bb29ec9b2 behavior of kvfree_call_rcu().

kfree_call_rcu_nolock(), added later in commit 3bc999d944b3
("mm/slab: introduce kfree_rcu_nolock()") for unknown/atomic
contexts, is unaffected: it already falls back to a lock-free
defer_kfree_rcu() when the sheaves trylock doesn't pan out, so it
keeps using SLAB_FREE_NOLOCK on PREEMPT_RT. Callers like
set_cpus_allowed_force() that want the sheaves fast path under a
raw spinlock should migrate to that API instead.

Reported-by: syzbot+acf142088e0182172e58@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=acf142088e0182172e58
Fixes: 2a8bb29ec9b2 ("mm/slab: allow kfree_rcu_sheaf() on PREEMPT_RT")
Signed-off-by: ThangNN99 <ngocthang2710.1999@gmail.com>
---
 mm/slab_common.c | 9 ++++++++-
 mm/slub.c        | 7 ++++---
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index b19ba1b31484..6d6cd78d00c4 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -2034,7 +2034,14 @@ void kvfree_call_rcu(struct kvfree_rcu_head *head, void *ptr)
 	if (!head)
 		might_sleep();
 
-	if (kfree_rcu_sheaf(ptr))
+	/*
+	 * Callers may hold a raw spinlock here on PREEMPT_RT (e.g.
+	 * set_cpus_allowed_force() with p->pi_lock held), and the sheaf/barn
+	 * locks are also taken as blocking locks elsewhere, so trying them
+	 * here creates a lockdep-visible ordering conflict. Skip sheaves on
+	 * PREEMPT_RT; use kfree_rcu_nolock() instead if this doesn't apply.
+	 */
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && kfree_rcu_sheaf(ptr))
 		return;
 
 	// Queue the object but don't yet schedule the batch.
diff --git a/mm/slub.c b/mm/slub.c
index f9b56cb439e7..83bc322557f8 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6088,10 +6088,11 @@ static void rcu_free_sheaf(struct rcu_head *head)
 /*
  * kvfree_call_rcu() can be called while holding a raw_spinlock_t. Since
  * __kfree_rcu_sheaf() may acquire a spinlock_t (sleeping lock on PREEMPT_RT),
- * this would violate lock nesting rules. Therefore, kvfree_call_rcu() avoids
- * this problem by passing SLAB_FREE_NOLOCK on PREEMPT_RT.
+ * this would violate lock nesting rules. kvfree_call_rcu() avoids this by
+ * bypassing the sheaves layer on PREEMPT_RT; use kfree_call_rcu_nolock()
+ * instead for atomic/unknown-context callers that need the sheaves path.
  *
- * However, lockdep still complains that it is invalid to acquire spinlock_t
+ * lockdep still complains that it is invalid to acquire spinlock_t
  * while holding raw_spinlock_t, even on !PREEMPT_RT where spinlock_t is a
  * spinning lock. Tell lockdep that acquiring spinlock_t is valid here
  * by temporarily raising the wait-type to LD_WAIT_CONFIG. Skip the lockdep map
-- 
2.43.0


