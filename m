Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 074DEC9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 20:54:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 074906B008A; Fri, 25 Sep 2026 16:54:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 025306B008C; Fri, 25 Sep 2026 16:54:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E31256B0092; Fri, 25 Sep 2026 16:54:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC91C6B008A
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 16:54:56 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3B9231A0713
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:54:56 +0000 (UTC)
X-FDA: 85253488992.13.45AD292
Received: from mail-wr2-f35.google.com (mail-wr2-f35.google.com [74.125.225.99])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8C88E1A0002
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:54:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="dt/t9/ss";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of raghunathpalla.0209@gmail.com designates 74.125.225.99 as permitted sender) smtp.mailfrom=raghunathpalla.0209@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790369694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jkJN4xCRSU+PqlIsdfJnZSqQwzMkeBYjwbAco/SlXBw=;
	b=K4WxEdwY3b/rAXOrqLf1g9Yh+RSlRkkISdSjSYu2prlPPpb1miiTK8VvZ9u55JsmiYOGjc
	MU2z0iZvKAYStqUCAsqTDMf+pIqtVME9s5yUbWXZo70WafNhVr2NC57p1bNisRTKkaYc4S
	QjNsomc+8AH0imM/HE/id+9E9yN+Eto=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="dt/t9/ss";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of raghunathpalla.0209@gmail.com designates 74.125.225.99 as permitted sender) smtp.mailfrom=raghunathpalla.0209@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790369694;
	b=lARUmhy7Wo36RQTWqGuDPlDQywTs1Csa3z58acmjVdmHyRfQjFR5y5yp4/891og7mChb/D
	6RT+HsTj6FBw2KNcI21AkJLW0hnch2OElSXZKeQWZ+5LFnPQqGsljiHRcWKdlJ+Jj8h4Bq
	ydyQcQDmbrxPe6qZNyGTqxycf3HWMmg=
Received: by mail-wr2-f35.google.com with SMTP id ffacd0b85a97d-48877902c99so1105474f8f.2
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 13:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790369693; x=1790974493; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jkJN4xCRSU+PqlIsdfJnZSqQwzMkeBYjwbAco/SlXBw=;
        b=dt/t9/ssMeLZlFG75r1q6cdkqsiGkSmcwaSjTCzk4+igDDoqfgZFyWqd2oNRr3RlTG
         vTR0yi395p0Er9ldsOawk1reHxymjG1LVVXnI+fTQQ4dXld75boJeV/htChceq1W7yP1
         bRI2731mH2FFJ7/za4vPA+VlXoaJEgrMJZCq1QRmjPl/WxwAZ61uhP3iwWwdFo/VvYpw
         tUlC1MJhINWk3Mo9qI14GpAZThjtuG0KoSo4aXXJQx+3+cOCtGyG6r5QsqKP70wUdJee
         z0Bn1+1qBcLp+UlNcqFZ8VPRw//RvG9peBmeBeAYtAZ8Rbo3+cKoVTiyjevP71G8CtGj
         CBNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790369693; x=1790974493;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jkJN4xCRSU+PqlIsdfJnZSqQwzMkeBYjwbAco/SlXBw=;
        b=EOOA9VNoONNlfTHDWRIiAdTgJnny2iG2vdFvTS2xomm9+kr+y8xRtWdne+7UT2t3OX
         cNmhIwYXauNhEQ6SmA0mMlcu6dMWL/QBwaMQ6FDCyzGBQt0wN8PvcfMCydlK5VSqZgaH
         avGRVQ3tqCZwbaLL2a+pSVXzA3G1oWzzf0w63Eo7Wf0u6YtHX4qaySMJI4cZcuoF1iB5
         AdVhFg1tuZbbeV8o0BrGDJnphVp0HO3d89ekUVD/HNUPHUWxJbacfLL37eAxT8KKIRBR
         u3yYYYEqLTAkgtuhpHrCeYmQWHOy8GZyUbwEt57x5SzuhQViM8baE0g/pGGaTWQ8nxYW
         F8AQ==
X-Forwarded-Encrypted: i=1; AKwUvBwcmCyt/HxmVnUnlEsDUAXYmia8n2r6Z9NT6fH5E12ZPKfSwyVoLEz0cQ2SIRC1dU5fN06UgDipZg==@kvack.org
X-Gm-Message-State: AFuF++kjnNg2xut4lHBNHI/GbWVlbo0JqN2BLkYc3x9WTY3lyDDP4DzW
	gROyOWFPRuSXcqJS9Ib4wqnjA4XeJDHjlBFBN2JeBEr6T58xX/CEVWw2
X-Gm-Gg: AYBFou22zFYye0lst2JbTJ3nOyfGfV9dwvwiYsnyWNUiOk9boUALBCaWsV/zCA5RXKD
	PhL4xelE2iUwVQg8hMuUeoKXwtcA71TN14YJw9vM6hHL5E3XXw8TZ5fZCb5A5tHWMXU0t58QtUu
	BBivq/G9CwtvcHQKpLEM4Rv9P+qdjN6fG9nglgQDSO1Aa9sA+cZ89zS2s8RhXssI+36Y6d+CuQy
	A6R1u3qLR0zQjjf30G17TcXefQel/g6Ql6UEFffqMKS8VZsy9N3p1PjFYwTq8Be52QHj1XiFPJB
	s9u/N3/yJ92l1iwwsRQgYQ0tRurTF8jnuBPnevdP1/2p4m5HOzLc5U+vUj4vY6KQZN630/ZoHUa
	KwHIwN6n+VuZLeUBt+ZkMEoWYLsdKOFEjMjyzMPtEmp5w1MJmowMmpMw7w4AvqrQzR6O0BlJ2ex
	UnnWKm5BJ9GNB7ewDHbS82I4M7C4N+0/HrCxnL0FQx/Z97pcQySOy6wSoRFa69OE1xYVgfNDGAu
	IqNEhAa7+YWDk9jJ4V4N69uc+v6T7VBe91Hfbq53GKVqmXkpKWBa0z9QTN6ajxatm0E
X-Received: by 2002:a05:6000:2302:b0:487:27f9:835 with SMTP id ffacd0b85a97d-4887170d4f6mr13089116f8f.42.1790369692647;
        Fri, 25 Sep 2026 13:54:52 -0700 (PDT)
Received: from Raghu007.. (sgyl-44-b2-v4wan-174108-cust110.vm6.cable.virginm.net. [80.1.81.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a64ef3asm9790136f8f.30.2026.09.25.13.54.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 13:54:52 -0700 (PDT)
From: Palla Raghunath <raghunathpalla.0209@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Shuah Khan <shuah@kernel.org>,
	Brigham Campbell <me@brighamcampbell.com>,
	linux-kernel-mentees@lists.linux.dev,
	raghunathpalla.0209@gmail.com,
	syzbot+442828bb356b10813a47@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	linux-mm@kvack.org
Subject: [PATCH] mm/vmalloc: do not warn on -ENOMEM from va_clip() in pcpu_get_vm_areas()
Date: Fri, 25 Sep 2026 21:54:49 +0100
Message-Id: <20260925205450.21262-1-raghunathpalla.0209@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8f7867tsr4xykmem4eoy714gs5mdru3b
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8C88E1A0002
X-HE-Tag: 1790369694-442491
X-HE-Meta: U2FsdGVkX19pkqWiskD8RGU9J8rs3Qc7cC5ss6mqJiLnLHNTXObcLqvPaKitjVmk8fh39IcRtOxjychVV/bThHZT2kTh0aK/v+t6TH44sAHPl+/rD8KqVaY/J+G3mIcx2KaZdKlLraHYALCI1JckkPEZn05BU50LS+OS5oc0gNOWLYzZTESn/lS6hzDS+RZDPQorPwYkCLIdWDQZvpBZHc8WnVsvfKZKbdjKbfi25wpBWxJ8vxCKSXCL1uIVVr1KeQL57U4udd+yEawT8sYPIntB2XlwEtiDE2kpml9ir6SFxh5TOe9LU227q912yn+yFajYtSKrqeS/0GPTDw1OYGKw7XsSOrBE1h2ILSOwT7zCuA6lZSGBcmL1oNK03msbKIoi2p189t5sGDkN4q2mcLahUtJq3UfasoR5CG2koUlR1c4eEnDt+2m62fDrVPpJyPfxsJm9jbluwOAldYMvwXlFXsmznX4oF2tfwd1gAulKMFo83v2dVZGrm9YrviAFn610Zo1pacAJbVr58p88OWMwvFvRmqaCmCcpTHk8nNOSqCRKCafxrzMaMrZ0AuGXi+Jgm9FZLBHfPjPUgeF/phpFx07sYw2wMf4o+u99ECXDBZUg0ITv6OokKV4ekUpmaURkypfQbySkJffWtDtg3oKn0lysH15YZ9GBTZoUB5713uzKTByk2D3ZK0x9PRWPQ2/p4SM/vK2l4PKFFUD3KpQgggV78c2WJ8nwGtMrdzqJRkCpn7tyHVgOWOGCJkzWdrzt68ikZgqEyfVxRWUzRx9vGjXzCEwbGKQNtzK3RL5o9aTZXk/+68rj4uKSFyho+hBrkW8HokSItU3O0OcJnqz6Bu1TbibnbJ4UOqH7xz9IUs+fqWOBGsk7qaG+flqLGFmr+mH+SGQXWgWr2YHJduCnslZe0867ZnRm1/hxvxN/2fUOYBEWGudlYEIB6oMku/dfPY/cX5DsD/VFw6f
 iFcLbKoL
 ewFGGVaDXTbtL/IRhvyIyTkJ+b3jIzRI+hXcUkx6Xw8hW51GgpeVQUWQtUBZ/Lpbu+FfgJcKI51eqDdwJUEsW5QwmCd5nLMkfGxhRiOVe2FAsGsn7PCKIFvcfzrTi9nOzXyb58/qWMgT1zPoErv+Eg3dz7JMhCEtze6cdpFoA9xuBD9jP7EAWbaiT5jGFMbeWWfYa1nQyogaYidHor1ejIA619QI6e+DavA2Y9WqEw5zzUVhjroijyshjrX4HOYZK61A/zTxDbdgQkey+q/bxXVY27Nkhe+VcqLkK/LGSQ9kBtW4lPDKqhxUfjMNE5qmT8nO52zID1mS5ZMdgfL1sO6HEh/Wwh28BNZ54+kxq+VR5xyOFecR7bjfavmsVGsBaBPH99bzQD3BIKYCA23rSwHtmqqJUhdhAoydxgxhu8b20+3b2Y70CTyj6c7/iMrzTwWPtWskfqfxQflT8Yo5FlUzyDJaSSFC2RvgvlCkX2wOs9gU5A8J+EWNkcPEUbM+QOQbORUn2327WKtHTA3wCdqr+bG6TdlLFfhClwsRxpcOf4PLQEBqPf+J1dQWyAYn1pAsFwNWJoJhSiO66vnfTZA+bP3VDy5F8wMiZ06f7uAGKAi7w8So1UcHAXV8fuRtoj6ivsjRIeAwLw/mQhbemuPhWyrj6n/lGk0zKMMVJICQiaoKMAwhBpe2T8CJ+R+MXTdkpHn0YgOz7jLg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When pcpu_get_vm_areas() has to split a free vmap_area in the middle
(NE_FIT_TYPE), va_clip() needs an extra vmap_area object. It takes the
per-cpu ne_fit_preload_node if one is there, and otherwise falls back
to kmem_cache_alloc(GFP_NOWAIT), which may fail and return -ENOMEM.
pcpu_get_vm_areas() never preloads, and a single call can do more than
one such split: on a NUMA system it places one area per node group, so
the first split consumes the preloaded object and the next one depends
on the GFP_NOWAIT allocation.

That failure is expected and already handled: the recovery path returns
the areas clipped so far to the free tree, purges lazily freed areas and
retries. But the error is checked with WARN_ON_ONCE(), so a transient
allocation failure under memory pressure or fault injection triggers a
kernel warning, and a panic with panic_on_warn. syzbot hit this on a
two-node VM while creating a per-cpu BPF array map.

Keep the WARN_ON_ONCE() for errors other than -ENOMEM, which do indicate
a bug, and take the recovery path either way. This matches what commit
b9183788a2de ("mm/vmalloc: do not warn on -ENOMEM from va_alloc()") did
for the other va_clip() caller.

Fixes: 1b23ff80b399 ("mm/vmalloc: invoke classify_va_fit_type() in adjust_va_to_fit_type()")
Reported-by: syzbot+442828bb356b10813a47@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=442828bb356b10813a47
Signed-off-by: Palla Raghunath <raghunathpalla.0209@gmail.com>
---
 mm/vmalloc.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index bea9f76ed7e7..24c7d0a5472e 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -5107,9 +5107,14 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 
 		ret = va_clip(&free_vmap_area_root,
 			&free_vmap_area_list, va, start, size);
-		if (WARN_ON_ONCE(unlikely(ret)))
-			/* It is a BUG(), but trigger recovery instead. */
+		if (unlikely(ret)) {
+			/*
+			 * -ENOMEM from the GFP_NOWAIT fallback is expected.
+			 * Anything else is a BUG(), but trigger recovery instead.
+			 */
+			WARN_ON_ONCE(ret != -ENOMEM);
 			goto recovery;
+		}
 
 		/* Allocated area. */
 		va = vas[area];
-- 
2.34.1


