Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 150DECA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 06:12:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF0028E0007; Mon,  1 Sep 2025 02:12:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C78F68E0006; Mon,  1 Sep 2025 02:12:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB5368E0007; Mon,  1 Sep 2025 02:12:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA0A98E0006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 02:12:40 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 76AEB1A06A8
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:12:40 +0000 (UTC)
X-FDA: 83839662480.12.E993520
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf17.hostedemail.com (Postfix) with ESMTP id 89A9F4000D
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:12:38 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=i+k94aYr;
	spf=pass (imf17.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756707158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rDgr77Raexwz3O9eJEn4/d6TiABMKv+OO6Kr02/4yzA=;
	b=u9iC+Xfhtvri45r93YUWXnptYlYJEeolLOCVx1B5yS8mhxwpbDqMqcDDWP4RjPxhkjkjYg
	GYPF3LUGzQrWHa+tUNE+5oGcqO1ACSfubw9ATcbFJgJpBmiVEyt6eq6lkx9Dq8+XEjPU6F
	PZIqlLyXxbhTR2xdDlKWRmGK1+wd8bM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=i+k94aYr;
	spf=pass (imf17.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756707158; a=rsa-sha256;
	cv=none;
	b=Y8HPMzfjkH5Ib5Ygl80AYHmIkzAx8YhNROj5E1BDNxd6eQBfZjqWho17OEw00TjzI83hcc
	TbsL1zKE8YqU4OApxhzT/Frelaqd+6WQq1f+1M0p3d5mAyObH9IQEP4JUn2mWpczTdtwHU
	BoKCgTjDux9nDc3qAgdzKHFpUwPYsb0=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-61cd1046d42so4815808a12.3
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 23:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756707157; x=1757311957; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rDgr77Raexwz3O9eJEn4/d6TiABMKv+OO6Kr02/4yzA=;
        b=i+k94aYrzGH6Qjz2EP9+f+8iXGzVFZxoMTQFVUI6yxQxi5mg7Wgr/9XgSJxgPaber6
         FRwqwzAKdUttCGQguoTGpXffGpsPGRjVV+ngpL6xeEhyijh52MMy8WbODY9hISAjVqZE
         ejC8s1/rkMw/xowiw8VTjkM2rCa3dV4Os0nBghfJA/ImulkyrQGKa9PYK5AcU3tpm1gF
         gGbCM4sFCHtsK5/Zbb3evoIBuDAGftHTwieuEnZ4Hvaxk+hIwXu+l/UN17DRXmlSZZN7
         Qn804gEkFF0AJrW2cc1OhwyA0MAm5PLznBmqIVc6J3nSQ1IwI79SFlZ1gsRVkFQlyZAG
         klfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756707157; x=1757311957;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rDgr77Raexwz3O9eJEn4/d6TiABMKv+OO6Kr02/4yzA=;
        b=DgewTotO51QUcfX1oZViev72c4CUvWbjTOBFHPxlDoRil7Vw3mhjFFh2KxCSbwHEy5
         qj6QSJ3ewqZ8a2sTMpyfgTdREnUWUFix/h2ZS/XGKf2RAd5iwsw/28kCrnUbSZQfeZqZ
         XQTvOzmWrt/Ti9I2JsTBaxFVtbFnHHznN/ngul/hDG85d0lTKSCjxjJoUDaenAIbgjOW
         Lv6SqbMLqrEb7P/TpUtz6QT1PLAEK9fIu0Gm5G5iR0UiW/9J6nFlx5JbyNiFAHdnm5xI
         NiRkMZCFDkQs5LrJphoGdR+pMaO6WI4LR/QskuGSVGJWvvL6xAvHi/tPixfWKyxvfgir
         NEsA==
X-Forwarded-Encrypted: i=1; AJvYcCWxUkbQsmPgz5MK30BA9pR4kBg44Ddws5OD4lz9WoSUzo0tINxkOOca8R70Y+AqUHEPz57eBRH1Ng==@kvack.org
X-Gm-Message-State: AOJu0Yzc0xWcXdzvIlcGvMobzj0DlQC5sTy1ehGh+BP4shTqnSYltDVJ
	ySBdLrUA/6DAX9rq7A2vA7zQN7hUT08RzcPDkutpUPr6Egi//Bb1vzFMMl3XX6Ndh4o=
X-Gm-Gg: ASbGnct9LyZ0Mmay8176HheIE0hc+b6X1EnoSH5U5fqWUfVT1vfxVleRuiaZI+fXNHJ
	kih/CKWhfaPGnRi6Cr1h/sC1p4icmZ23D6FejrRFG8PllGocuFGwqx2UFJ1ycSYfBUFc8ch1mHe
	Yt2FirhyevkI4tB5izBqMDeGscTmi2I5xjJ25r3dJonPGzuLgj+FsmuKmpJ4kWu20P2J9J9Ko6u
	CvBV0AyUzSlGNw6fCNNTtyAewnNGtCigPIWWa9zCqlBHUkJTKX5tBzFN7xFa6ZsYsVJX8Lt3hNg
	0FO5XIdREnDyFxD0b9IWphir/7Ng57HygVVWUe9UkmwHTsmsuytqfxsnMHjiTvvb4B8objrriXp
	GCPIPw6Jj0qq9gZUr60q7O4QMPg+gnnFf+W0rlgCsyseVm/z30Gu67kOEWlJ3mDkhozzmp/TADh
	QFflFGCxDkd6ApMIjrkS7j5DrJ/4wTHyyr
X-Google-Smtp-Source: AGHT+IHFcJKCkw/RTMX7106ev96b/+IR0if6QTDEGodFGX5ZCSVjZIik/iqJRJ/PVGIEAJZPuC7HJA==
X-Received: by 2002:a05:6402:44d4:b0:61a:8e5c:f4ef with SMTP id 4fb4d7f45d1cf-61d26c33dd5mr5229225a12.18.1756707157157;
        Sun, 31 Aug 2025 23:12:37 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61cfc231561sm6374533a12.23.2025.08.31.23.12.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 23:12:36 -0700 (PDT)
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
	vishal.moola@gmail.com
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH v3 05/12] mm/oom_kill: add `const` to pointer parameter
Date: Mon,  1 Sep 2025 08:12:16 +0200
Message-ID: <20250901061223.2939097-6-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901061223.2939097-1-max.kellermann@ionos.com>
References: <20250901061223.2939097-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 89A9F4000D
X-Rspam-User: 
X-Stat-Signature: ksscdfuo889tbntdgwpz8u94up6e5mt9
X-Rspamd-Server: rspam09
X-HE-Tag: 1756707158-667260
X-HE-Meta: U2FsdGVkX190odXLTCbFZ/2ROC2w4n/9q8gve9n1hFUp1Xk6KR80yw3WVA2j5k6RIOvoz/tZURacFv9ob50a7fcLopN/FNCYELkaA6+vFkXbaZc6hY9EFAtvgS37Pc+S+tNqjNtADCOmqXKDYXpq96vwL672Di1HyCqTtUjTpkfEY00GEZGh9C8w+KwU36LA0ictijqxpLAsgsUKaVMBN0vWKHTdOHMChAXYFR3ZVd2RnGWgRkJ/OSC6Ckqf6i0Yxu0ewJBiIcczAMJd6iK1Vlx40psBExpsU6qxVojvczM+h90uL6D0Vt5aKuBtjTAq6ZMMmwiwu2c81PACXl1Lwan7ymgfWtDrab+aETcPGDy7X0XBQqvn3/91svIVuXP931NBj/QTOwTc8pi/NncgKn5gNRaUH5QsMMKOIzLVd9tlFjNWvV5wZJMsNhMWg3RyThGWVnAaN7mNJjcps2Dyc+FlORMtwRA6nI2ss6LGXeHtPi08/9A3fI3eOwNaay3SldcKHMr/P2loZLN3g/7/o7hvL6oTVaxzQ2KDRiw1ckcKG9yeReqiSVs+0+RrU+jbDXasn3ZzA1nZu8NujOz1GsCnOaehRCtF87fuy9RA13LMerQY5OmxvFlYrIukIXqs1QJU+K/w/wowtVNoJIurJYira4rqJJP4yRTgJZpGek1C46BL1xz6jc112Swtfwd4Dm3zAt3pJnPDgu4Ju9ISW9qpYjNygjY7nOHNBiRAkOselqth3Cg5fluBGPCH5vpq7mqW1QmLQe9UU6kJSlczwm9kBFYdCjw7UNoNZyQ1NqPgnEHxSXQ2ItHXwrSa71OOAul+vFyDWoGIH8wiI0lWof7HRD3Tup8McRKpO1OWbwBb1ozZ4tTIhJbRmWxGkVEehyyvh9a/QWbw2eusCiDE5gKzZ71R2rcP6oA3T91eSgx4+mvovzPWYeDCLhiL/PM+kizNVe2uJI6Qmcn2qrU
 ixeMIsY6
 sGNPrCUoyehrpO0aetnTbta16EPsudHMAKwcIhmfnnhsSYan/4Dz5Gx5+riKdr1rAZ6oLNxA28ZiE0IhqoBqJMC0p9PnkcqoSP85tPQeLe6AvwGpA/VmctAmDQqrGV8MxPG9hjlaQOo/649yg4Elchtuy88Yw92znj+2KPBH3ke+tvcZFsUYkZ8zD9MfGj0BsEWZQRwp+fuQSDSXZ1HeZHr9ciORKZQL6guurQ6lSQ7+Fnhfffpx7N5khFpt8FtuFNLEOEJ7aIq0RgM5AE5dWSRPp3I66arcXerQW0iwS00ZClsnabibwCHk1r9gsgB0E4z7jj156WXm18OxC2m4SIcLSwWU9hS0YCc5sITGi9kUmnR4KqO5/hdwYtGeiXLNERL77rab8CGtlJNNcAl1B6zXWwHr0YaUxt1fjc4sV/lU5bEpsHjsDlVm+6DlQ75G8MzIOWhQAUeuOpe9ffph/OA9reSWMcl9ygvh5YIRJc406BYs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For improved const-correctness.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 include/linux/mm.h | 2 +-
 mm/oom_kill.c      | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

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
index 17650f0b516e..2620b32a8eba 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -490,7 +490,8 @@ static bool oom_killer_disabled __read_mostly;
  * task's threads: if one of those is using this mm then this task was also
  * using it.
  */
-bool process_shares_mm(struct task_struct *p, struct mm_struct *mm)
+bool process_shares_mm(const struct task_struct *const p,
+		       const struct mm_struct *const mm)
 {
 	struct task_struct *t;
 
-- 
2.47.2


