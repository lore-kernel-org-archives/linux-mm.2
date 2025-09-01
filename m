Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C08CFCA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 20:50:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D7EB8E000C; Mon,  1 Sep 2025 16:50:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AF1D8E0009; Mon,  1 Sep 2025 16:50:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29ED08E000C; Mon,  1 Sep 2025 16:50:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1B7738E0009
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:50:41 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CE124C098F
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 20:50:40 +0000 (UTC)
X-FDA: 83841875040.26.A093F3E
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf15.hostedemail.com (Postfix) with ESMTP id E99D8A0004
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 20:50:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=UCNcIsWB;
	spf=pass (imf15.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756759839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1NuH6wEtYyVWN8h/tjwWnU8YD95rrkeNOHDYWS/pAsg=;
	b=dPk1YuNbQ9jV0jWKqDHX17s0e0ET6oUr8xzc0fpv5pqBgtRRP8YqfdcSYAi95kt8E7PuiM
	mPJb9Sw5fhtP88rdvco7VA6bksfBntqmX4XY7uYCz6iv8hxGzUBZCkbHsdVigLxzgTiA4D
	qHt4ZzeBD+JQ+0irOpaibH/d59dBvf0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=UCNcIsWB;
	spf=pass (imf15.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756759839; a=rsa-sha256;
	cv=none;
	b=hYUhA6nEu592bRRUtKfK/zvfCzKgk4I3KHZms25UOcYxprkFohTZGQyvRL39N9q9qjrYGx
	defFygEKgtUySjhykCZ1xu2gz1kuQon9fYZJmL3YKXQF5A/Q+bM6pL5GGJfvHLWNYBZ3uE
	ugjTeemQhizpf0/PcNDK5hhKhUCva24=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-61e930b27bcso1839010a12.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 13:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756759837; x=1757364637; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1NuH6wEtYyVWN8h/tjwWnU8YD95rrkeNOHDYWS/pAsg=;
        b=UCNcIsWBLyj7qtS8FuOkt5WbmT0Pf/nn+1sisIuLY2j2X0j+XaW2AdwTfuhZfjKs0N
         nUGl0p3v2/PwPrVF7WbeTxBLF6Vap6yEz/7k9lNBh1nWyy0i3CGgzM3sljoxN4rSmBao
         +8GyviEZ/Lu0OQlUAbw9aOPsWyYDZTWJ08/GQAPRXY3pqiajrFyDpfY28anh92gW9FrU
         JaSfnfzkbvjY2r30oaRrKl8A2UuRP/xb84CHaAVIHsh8MBOEK/fpIJRCChFBoNczrumu
         Lyw5N9Uv7AZcvkwRtEXt333KG2quzqVv5Ry284Kob9OmJuQZTXHJ1px6F1a8IDe+sLwM
         eFfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756759837; x=1757364637;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1NuH6wEtYyVWN8h/tjwWnU8YD95rrkeNOHDYWS/pAsg=;
        b=hLNSauRUCMNOQCg2yl92NEBeSknQbO9dhizlvzX7DBxw7ZJpTCUd0IQEnPY74fuZk+
         aNB5bt96tHxs7/RkQPYCr3RgoIDgjsPB1akYX7H7Z92i2Ck6ePlKhAQfbQNJTJA0+jbK
         T9MrMXRFIbbm6ioMj1vssR1WTcUmisvF1hHiXFqU/bnMiNdRNZmNk+lKLle6xcyHwPWz
         sviXpdKBIvdYcYXY2CvF1evbGWcQ6TtguBajjHBDp85tvajLQKDphjBnDHGneAD55YgD
         tTC3DSA90HdOkl4dv73gcRLjknBqPI441LlyfaVHJsGna/9HTo8xm6m/dT9X8GXjeN27
         XpdA==
X-Forwarded-Encrypted: i=1; AJvYcCWH9Fdmc8rRM9n7nlvm82ADatDTck+/QxKoVAsev2LFHBN6lgCeZ7AC6Ij23Xg8LIuJ8bs23C8hFw==@kvack.org
X-Gm-Message-State: AOJu0YyMqGloVq8zFR8fRc/qkw17QEfX7qXX/XZQUzIjmyb/3mI9/2E5
	kX4Jd1S6I7yGQtDGJrIKwNyT0L2CW42IzZUKUK53PI54OJ/m6Xt0mte6LfLOUX680LI=
X-Gm-Gg: ASbGncubUkn6V1D0tLwxRXEppk42u58BD+tmbbPjKdZHepOseTSwY4RHYEWTyYsiCag
	VCs8b2qn6nFMqxwO3y6HDykG85t2NWQEckKyu60x4Yel4tGePlsDp0NjtPkEQoPjP6/sF03hgkZ
	pI/Nl3IUdrCjzZ3piKQhGJ7qoDwDgJicNiHwyc5IQglWPgOqgcyVstkeQu8GotVid9XpBBc1i4s
	ffk5P2lyJES9EHc/mkmmcdanpDLvo+sBQDM2LVgHF3V4SqyU6lvw52leEiHRPvd8CP4hMBJn9Dj
	th27uuf+qxfuWMOr6GnKYlGpkdmyWT+jl3tF2dgTltGFdK6IfMdPMKCi9HaXzUOKZrHWEREXIaV
	yFEIW3ZkYe+KLIVsaEQ3voZnG2++YiDfjn7O7aYCPRepjcxajoWRKPqdHTIjtCECe0RBktG0HTo
	Abe9uFsJh6/bLnkxBtscAw9g==
X-Google-Smtp-Source: AGHT+IFXutjj9GtlvsHvyB1kBP2ci7mQOIWVVvptrXf9bm8LYmlGCi75h3LAGpjp/G/Rnzqw/keEdA==
X-Received: by 2002:a17:907:3e89:b0:af9:e1f0:cd30 with SMTP id a640c23a62f3a-b01df53b7c4mr910004866b.60.1756759837088;
        Mon, 01 Sep 2025 13:50:37 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefcbd9090sm937339066b.69.2025.09.01.13.50.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 13:50:36 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	willy@infradead.org,
	hughd@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	vishal.moola@gmail.com,
	linux@armlinux.org.uk,
	James.Bottomley@HansenPartnership.com,
	deller@gmx.de,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	davem@davemloft.net,
	andreas@gaisler.com,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	chris@zankel.net,
	jcmvbkbc@gmail.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	weixugc@google.com,
	baolin.wang@linux.alibaba.com,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	max.kellermann@ionos.com,
	thuth@redhat.com,
	broonie@kernel.org,
	osalvador@suse.de,
	jfalempe@redhat.com,
	mpe@ellerman.id.au,
	nysal@linux.ibm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v6 05/12] mm: constify process_shares_mm() for improved const-correctness
Date: Mon,  1 Sep 2025 22:50:14 +0200
Message-ID: <20250901205021.3573313-6-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901205021.3573313-1-max.kellermann@ionos.com>
References: <20250901205021.3573313-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E99D8A0004
X-Rspam-User: 
X-Stat-Signature: ad3gjojpf67yosjekmjd55tjbqe9pu64
X-Rspamd-Server: rspam09
X-HE-Tag: 1756759838-884502
X-HE-Meta: U2FsdGVkX18QKix0k8I7EVHL0eVvG5tYCZcq4vw5hPovzGzFVZLxKttWuQXQjmawziwA4V+JW7HwyIAGMNmqs+RZ+xqaz3n1WiFzl+Wg7dfhOzKcKXdVRXGgqOdCzU9oJD4lyKRusjX+oS3lM2IYglSVIdjH+QFUI78IG1+0T2Y9mL0Y4ncaHa8mctz6O5KAxNiSPZ3Hx/qw/pB6RTdMe75mMkj7chIqIPXsXyLhcOFh74mG+htWaSrqjQ4EmKfAHGiH+Jh2UE5qw+lCdHIc+KZNk6FrEkXIGbkOeuLBZHlPFfSk2wdrS6+j3PAtGFI4zyaBCprfwr4vuktP2rDCh6+WZDzqad1IKoQ7Nz6gdO0DVfKO91KBhbbEb8og1iiCoLChSs8rH97mkPoFqbDSyEV9cTJHiCfEwj+hyt/4tmr3yEfur2qpHToTgyUdth558cGg9wMLjl+uPMHLl0aJ/tDrwh8g83rB3ccN/ARFwddkafGq75X3txGV7elUYjJOmfdvM6ofvTcpvgKp5pkePnHbOOVI0LMBPYeqAJ2C8t/dk1u9oj/8Ql/Ii3D/wyS78JW0QS0sSp7S7JCndZii0v21R2BHsZuqiy979/L1knBjsWOA7EQ4SjIYTBeNfRLKwIdRL8nu/RzE/o6eWbbrnRvV53X1oq99NUOd5Aae3uSwku4ZWoLDYYoc5h+q9HLMiVZ3EZ0VK1luZVBhWpEPx8rNKdjmY61lYGZSYCyq/SPuKJxU5GnnRkWJO19dyBet3eW6JMQEzwn0iVLRM8TqMZpsTMZGZoQz42ZQ0xatSjxY3Nj9YsMiWfhGAMx5BO91RWXaLkx5RY4wcucSQX3vj7skN8OTQJDDGON8LxnQoZNpUNW4Td57FTGLAsM8mWVLqUQok3pGa9++xYHkTa+q8svLaShzziMhGiCyVL5+rCijYBzYbsLYNj1KQ/ZKwP5OQ4A0XQOBnoUbmB5MhBo
 7xf3/tm7
 3aeT//La/Ysun38auyW6cNukxP1EyNu9RNj0rdSGaQM4cw2dC5PwwvmqgUYUNd9LsMwaWeh62t6IDL/tgDdFbaVkXGNHjBVaG2ehJb1gBOBxNcCyAZKTh9xjAUjdAN6LYSORxkImmvgzuWqX2djKuG28ZF8EWoQYFKnmU6do99UzHPrYlkN7EN89PsW+k8b/bhxzQuvLE8caEdQ7YRGkRnl/7MVZnc7GqzbwrjuG0A/Qu5/nadsUIxRIHtGR8VPvqmaA0PH6ecE0VojVhWWxqcaNgLC6ccDQN5XPflf0gSEKXgLutb2mRceSz9kgtA0nreLFCMdN6mVdw4nfYUv72WXUYeK8Q2ed2SdHR79eHXjgVuEfBA+h9iZiS5bC9a5efHW3jXtSeHP6laNEHIcE+hqg2Fl2TWGaQAk1LOw3hi7WkGptCH/DaDIV874nsQSWzs3MYsCj5eHmj2jhltHztv0DLzNGvcidouJK/otgDi4RCDoEKC97HHlds0W9Kko5V2RQo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This function only reads from the pointer arguments.

Local (loop) variables are also annotated with `const` to clarify that
these will not be written to.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/mm.h | 2 +-
 mm/oom_kill.c      | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 18deb14cb1f5..f70c6b4d5f80 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3840,7 +3840,7 @@ static inline int in_gate_area(struct mm_struct *mm, unsigned long addr)
 }
 #endif	/* __HAVE_ARCH_GATE_AREA */
 
-extern bool process_shares_mm(struct task_struct *p, struct mm_struct *mm);
+bool process_shares_mm(const struct task_struct *p, const struct mm_struct *mm);
 
 void drop_slab(void);
 
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 17650f0b516e..58bd4cf71d52 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -490,12 +490,12 @@ static bool oom_killer_disabled __read_mostly;
  * task's threads: if one of those is using this mm then this task was also
  * using it.
  */
-bool process_shares_mm(struct task_struct *p, struct mm_struct *mm)
+bool process_shares_mm(const struct task_struct *p, const struct mm_struct *mm)
 {
-	struct task_struct *t;
+	const struct task_struct *t;
 
 	for_each_thread(p, t) {
-		struct mm_struct *t_mm = READ_ONCE(t->mm);
+		const struct mm_struct *t_mm = READ_ONCE(t->mm);
 		if (t_mm)
 			return t_mm == mm;
 	}
-- 
2.47.2


