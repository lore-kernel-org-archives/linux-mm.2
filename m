Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8DDCCF58FC
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 21:08:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 049006B00B2; Wed, 19 Nov 2025 16:08:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3BFE6B00B3; Wed, 19 Nov 2025 16:08:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2A5C6B00B7; Wed, 19 Nov 2025 16:08:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CE2926B00B2
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:08:38 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1D0DC14069F
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 21:08:36 +0000 (UTC)
X-FDA: 84128595432.16.3C20D8A
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf28.hostedemail.com (Postfix) with ESMTP id 22B51C0016
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 21:08:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D3O9qOCJ;
	spf=pass (imf28.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763586514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/x+2YkUzIKw5LUN7QUbaCv0UtaIYtv82+zCXS2emyik=;
	b=NmnX31DQZcJzGsYVb80xe0spvAUsjk3mcbXk7OPBFlgQxgvBJbIY0B+lQ8kKSSlA7lnWXa
	FOJ4Hr1IpkgXdvZGMhqd6/p5aPL/B3gi0cWQJQShUxdw63iadHEP+Oenk86b8QmL4M97qJ
	KkH+8q/g9ydjM+6HzJ5Nisb4gyCv7as=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D3O9qOCJ;
	spf=pass (imf28.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763586514; a=rsa-sha256;
	cv=none;
	b=MZy06QaCHg/r8x3YOQWbEfgqtZsmwabXQeu2Jv8HxrbbMVFItMAcH2Q74NJLBn/SILzqxX
	SCrR2OzcFsxh+TDD9N/Wim5ykA862oFnjtJ0gta4dkfXG6DwgZABf+zCyG04YOJDoT7WEv
	p6312oEigigFFACLxP4WVQTo7BqQrkA=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-477a219db05so1391315e9.2
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:08:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763586512; x=1764191312; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/x+2YkUzIKw5LUN7QUbaCv0UtaIYtv82+zCXS2emyik=;
        b=D3O9qOCJ19MOodupJxnMsM2McjrBdNiAvguD8jaeAOShTiLk7lpnNONLox8D+TGiF2
         RVXP3AdUwkH95lrExtq0sG32pGqSlReXDYs94oaMfRtt5qARIR/GtvslO1mYxRPw9bzP
         gSA2Fyuznhbh0G0+tFbNNMk2YLIE9dR+qRt8Ca2SeEXOadKET+3OhYyA59X9wngQyQwl
         SIvT/rCsao43FQ8fAYIkYqmQsMN1WhQ5H6zdwAe6FeCiJXnVT1zxI+VQUbx3L4/dRnFS
         sc9E45ce95LMIjRSJHiweVyyCyntacMJcVzUzz/IctQaLfAWDLzmLdD4MNs0J3Fu2BHy
         b15w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763586512; x=1764191312;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/x+2YkUzIKw5LUN7QUbaCv0UtaIYtv82+zCXS2emyik=;
        b=CLYIVK0lctaZiZaRHBShs04ofVEvIgzbzwhDaMXbwFbW7xSJgHItDvmmCGA0AQNun2
         l3WXzCKwNCFzHMULLLpsGNMFWmftvN6FUKMgITLQBc0a0pTIqs4JCgneDnV7yiDw7TRA
         9LtPfJS7ltxndBf143YTlAHBe0/1Z2RiY1nf1o/VpDYtNW2ljKp+gKc5kzFpTnDza9xU
         XBdvkqoy0TG4gemI4J+h2xC01FgveUR1nSlWjkRJ1TGeOplueLLtLbOU2az8Hg/8n5ok
         M7JHER8VymAjcugQWV8epAl6dXoMNP1ao2W3TSUZkNn2DC77HVgo8Env0gzE6/5E3Jj7
         Or/g==
X-Forwarded-Encrypted: i=1; AJvYcCVco7+raOyaJcoVjBdbMoU0YIfKGqlvWQH3ZHRqoUQbjw9X//xUND9gqFmJ3MlXJJ23OzLmK+O5jw==@kvack.org
X-Gm-Message-State: AOJu0YzY7J8jT71FGFuVt+gu9ZqMZgNuyPyb+Ze+BQkLBZzIZlQOhmj2
	9Oxm092H0JHfchvDsB8pz5BcgCMh9G8NpLONj13DLlQ31TePvSiQv4b4
X-Gm-Gg: ASbGnct7jx2DATPIQ02xd3XgITd4lJObkV9cR5pqhPMWXqWaMKjebr8BD4NIwtMMJN+
	i20gxcpdMOYP/npfG39vxy36E5wZTATgikwRierX2SQg3kabGdiLSO79GCG+foMjNHWo/m2YfEb
	caywzLMUTbs6Fzk4iFRyYe0oP/QjDF4hme+26GZ5GMArQ4d9yahE+bCDOxZCnCrfVd/xuU3Y+mD
	c3k9S5Uphh29mBl/1kNh3HjqXgx88c5ihhoB2jPphhVpp0FIWUF9VsW3Kh9LdKBCYEVqVgxXiL/
	39WtULYhC67dGIm5Di6hY0tz1AgWUhq5pmtggg0ht5setVTfsJihNK/6d/UezPPIhwZ1p1/Cyzp
	m1FK3+BwwhvtytGcDLOHkeNCbf05lsYbYzsDAoBS7+6+s1USxxj3eeWfgENrKhvpicT0JAXWZxD
	VzSBSKy3n+L150Try95/NVJjOe4iopLWVNfbul1TlRfU3b1ckr7YhmYOl3EdM=
X-Google-Smtp-Source: AGHT+IGu/JcMLbFe1ns1xbHqyUMg1819xYufBVBDVVdgsDa4/PT7CZf0ZP5BjX/6EqeQTZop9RePOw==
X-Received: by 2002:a05:600c:19d3:b0:477:b0b8:4dd0 with SMTP id 5b1f17b1804b1-477b8a8f296mr6261345e9.17.1763586512466;
        Wed, 19 Nov 2025 13:08:32 -0800 (PST)
Received: from f.. (cst-prg-14-82.cust.vodafone.cz. [46.135.14.82])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477b831421fsm9558365e9.10.2025.11.19.13.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 13:08:31 -0800 (PST)
From: Mateusz Guzik <mjguzik@gmail.com>
To: dennis@kernel.org
Cc: akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH] percpu_counter: reduce i-cache footprint of percpu_counter_add_batch() fast path
Date: Wed, 19 Nov 2025 22:08:20 +0100
Message-ID: <20251119210820.2959128-1-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 22B51C0016
X-Stat-Signature: em9wodgfyfke9gfqrqyh1nb3suay8h4g
X-Rspam-User: 
X-HE-Tag: 1763586513-548046
X-HE-Meta: U2FsdGVkX19oarckeV1hn8BitK/+zqd+yR9EfIViUjLvN+Hlm1ftkqXnyiKQmbd08UHIBX6jogxCuRVWFa0eE7GLfW9KmkJoSb0LEsKF8glJxhNi/mk2EXiURCAIHkY3ref6zb1kbN5QX00zNS0H3Q3gApQBO+SWfhrXmQKWblCqyJxRncww6alaMkzIjqFAkLAZzKcqZ1M0XyEBR3pCQZbYvrULZl2y05qccD38QXsFvOtr6nmQOmTVjItMWBW29lX7R9J6ZU3fYQYI15hcMDgxkg1kofe9FHtXv5vdzzCubIBixCWfrSwJSuUGZ0BYAJJEfp1Ub8viv8Bhyg35EHT9Yo4QUOkur/dZ9PeuffSrIxMa3yBEIPKcHLb6MalezQpnEcSdcb/QemmV5aWmy7rHpGAVcOg4LuD4En92AGtppc5hTlYy+/yHDd5IZkCIo/4XxqvOVm9v6lC0aro9YB5WrSa1bvU5lLR4fGcntMce2QS1VHM/OEy0e//LYzB5pNII17TjiUcmdhKWDMsYQ3+FX8rotUrfQfWtBrgTNjWG+mEkmX5CNjy5oaU/vg5kZdlZZbmYQjr141+1pAMAL93BKUUiu+F+Q/JqOfr4BTMcZnPpz6X9dliNHkwtnHBcMLelV8/Qmehkc9NPNK1CI5hBFPt4e073n6z/AxLUkhLU1A5VWgQNU00QR88spPdPUjzz/N6myeJIPhVSlKI77TUMculj6VJayCkCyWakOyza2iqpk0wAjRPlWUIRjrDQ8gYl78Ly91pCXK83T0ok+dZjPQ7Sw/qfP2DM8N6dz1AogkVRZl0zpsUy9bBUYKlZDD7OwjMxGBGesIouOJbISuO2NJPomYUEa0xFbhPU/LZI304k/uyQkxkBx8BNRBA/K52wWcVZY0RkX0QZPLxN7RutMN7i+mbTB8kqkP+xnu6vbq2nSSP0vvqBeKc9Zq8LFbwQhvQzbtMOWMc5JMD
 vcB3yGSC
 eXWvgFIkPKhzndnwub+myYwAtJiW8tujn6Gi/ZxOhxN50lmgZUF+HLDinfxmqumDRjZfs/1qqh+cKxy+OeJi9WYEIKaF+oJeLpHjOIN+BY/xlkR5Aevxolhu8+oG1iMNu2cOFGscbAmSJgtXN2ms5zCFR0NHEG7iwg9YVB2uSdOsoD0i4EYF6XillP6DtKs/RQw+IgK0ycrJxun5jHH7XbT2BIggNgBXcuRsia/bRHYRwYll2zDKV9qQcPYpzxevFQIqqgxGKPdHNBiaaFpSWWWA2irVnSg6XQO0kfWbIKt9I1fkTgAqF1wJHoKwehIiE1nY7rMDb/deVz02gJwUS6Tf63znxZ9fevf+dhw9pvk7HE48nj8zE7XTvRc2SfZEujKL0MJd5Ams4a5nvgczP1FSBTYy2zwUIza4qqDBWSZaASEUcHsHrU6tRCA6CVCXvDnOs1IDiddPo4Ao=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When compiled with gcc 14.2 for the x86-64 architecture with ORC frame
unwinder the fast path still has the most unfortunate size of 66 bytes,
in part from register spilling to falicitate the fallback.

Moving it out solves the problem by keeping it just below 64 bytes.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---
 lib/percpu_counter.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index 2891f94a11c6..0cf6f1101903 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -89,24 +89,34 @@ EXPORT_SYMBOL(percpu_counter_set);
  * Safety against interrupts is achieved in 2 ways:
  * 1. the fast path uses local cmpxchg (note: no lock prefix)
  * 2. the slow path operates with interrupts disabled
+ *
+ * Slowpath is implemented as a separate routine to reduce register spillage by gcc.
  */
-void percpu_counter_add_batch(struct percpu_counter *fbc, s64 amount, s32 batch)
+static void noinline percpu_counter_add_batch_slowpath(struct percpu_counter *fbc,
+						       s64 amount, s32 batch)
 {
 	s64 count;
 	unsigned long flags;
 
+	raw_spin_lock_irqsave(&fbc->lock, flags);
+	/*
+	 * Note: by now we might have migrated to another CPU or the value
+	 * might have changed.
+	 */
+	count = __this_cpu_read(*fbc->counters);
+	fbc->count += count + amount;
+	__this_cpu_sub(*fbc->counters, count);
+	raw_spin_unlock_irqrestore(&fbc->lock, flags);
+}
+
+void percpu_counter_add_batch(struct percpu_counter *fbc, s64 amount, s32 batch)
+{
+	s64 count;
+
 	count = this_cpu_read(*fbc->counters);
 	do {
 		if (unlikely(abs(count + amount) >= batch)) {
-			raw_spin_lock_irqsave(&fbc->lock, flags);
-			/*
-			 * Note: by now we might have migrated to another CPU
-			 * or the value might have changed.
-			 */
-			count = __this_cpu_read(*fbc->counters);
-			fbc->count += count + amount;
-			__this_cpu_sub(*fbc->counters, count);
-			raw_spin_unlock_irqrestore(&fbc->lock, flags);
+			percpu_counter_add_batch_slowpath(fbc, amount, batch);
 			return;
 		}
 	} while (!this_cpu_try_cmpxchg(*fbc->counters, &count, count + amount));
-- 
2.48.1


