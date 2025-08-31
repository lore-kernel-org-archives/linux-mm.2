Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 062BDCA1001
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 09:39:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4888C8E000C; Sun, 31 Aug 2025 05:39:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 410188E0001; Sun, 31 Aug 2025 05:39:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FFA78E000C; Sun, 31 Aug 2025 05:39:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 167478E0001
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 05:39:46 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AD9948525F
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:39:45 +0000 (UTC)
X-FDA: 83836555530.18.27A54BE
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf26.hostedemail.com (Postfix) with ESMTP id BFB0D140008
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:39:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=dwWFV61c;
	spf=pass (imf26.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756633183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z+6TrnZpXfWUfs5R5hmEGqosfCHRnwv9JCMokN8V3u0=;
	b=awTlZJ673OI9y9cDLcsMj05X7nt6nkAxPPilSlLcemRF6w+6Wyza/YQ+pJ1AUkxTXp1N7W
	wxhcW8ebP5fYTbYs9LDWg/h6R5qNqPDc37EGrQcPBDRRk7T6KLJhpbtVXBXpFBYWxIdvP6
	XQKw84w8wPbDcrhnr1WGey2Pj8g3fac=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=dwWFV61c;
	spf=pass (imf26.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756633183; a=rsa-sha256;
	cv=none;
	b=OBV0ZtdE/xY7k8RNmeQqjXvbA2t2U7Ef/SwXrPPqgc+ZWCFFBvpuIRL+0aO3q5hZZlm7qt
	3gKAClp0rpf79irXYf+cGc1bDYyUFfjABHsdxCzXrIIIvI7ltm7EQOC4pHVEXpDRYZIo6G
	Xo1ejQUrTelZOT6oNOavsFyXJQXdgvg=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-afcb7a16441so518909866b.2
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 02:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756633182; x=1757237982; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z+6TrnZpXfWUfs5R5hmEGqosfCHRnwv9JCMokN8V3u0=;
        b=dwWFV61cfBkxyeEqJf0qa6JXg0+oilAbM1HrX7erwNpUi1hDRpHx+jlCJbmVE3tsSY
         cuziNi/8bn71QgaBd8T5yuKtVOyN8BdgZ0d0detVGJFT4+M/l8jJbN87uNCs+zWRMVFC
         m2JajKn5gIePmBWEEdh2pYg+iWVjnSq+dKU0x4tAQcSE0Qn9akx4K+Ah/2JrhuhKL+TQ
         QWTxusWdrTPh5G5s3ZmccZXolshQg4uNEjqaZnsc4I8AlsbXngXjnak+pQvqaSkqmngo
         OGOjAaiDASaflAlC+9/dj9MtJj42y6O++t1aTeRvdX0ezJpwnlKsr2qVMRwNF1yOrEpz
         oT/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756633182; x=1757237982;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z+6TrnZpXfWUfs5R5hmEGqosfCHRnwv9JCMokN8V3u0=;
        b=cfJHqrNgZxkBhVWQrzD4GNIcCrJsr+U4j41SwICzmqvMLOH7HAcBhDLmOj2DSxaIM9
         Q4ubf7n/J5tSktplhpjXVEsjSZtVu2pZeXhXoNCR7NKZ314tvKPbV8mwweoHltP+Y4Xc
         So9XEY06CJElA3AvlSHKvb3AXcfNDp5jOU570Oc7J5MbJGrDvndc6YslDTZu8AsWZUeT
         nm0Dqc6RLiyQT8feHcjH9DYM03G7qAIsW+dsWja9tsCzUtOLayIJgK0/1MlvEpwMdx7R
         iJ6ctCGJc7gU+2+1/mbXKR7gbtz9LqGKsX3pv9eA5iRESWvQNd8tN3dvpDtTYtkbWw1G
         +9zg==
X-Forwarded-Encrypted: i=1; AJvYcCXvznUevVmBTW4FRMeYpIK07I8gge+I6bYNo553w4Xq+Y7VYeA8m4OF/NqfZTAEG9TOp2rKU09LSg==@kvack.org
X-Gm-Message-State: AOJu0Yy9CfSUizMcOEsYCJJ9qx0zJ2ShHt+YT0JapNSVu193B2nSoSJ1
	SDuMXcvC6iut9rvSmzUX7ZafNmHH9zNh7vv8cs4pDlBlSCwwCqRRHyiy7uO7+45SwME=
X-Gm-Gg: ASbGncsjIKwyObLJqPYiQ+P83NB92i1ICJW2mq57DmoA7zoYVCs1mRrVMoYtjjNecSI
	h7Wd/dImuoiZ7Zn7SddbcMbczM2bA11liV5f0mGTa4QAIWN44WxBhzlewmTQlRh8/VOBlSS0b5h
	FqdoePKqvVOJOiy9Qj2g9zaGlO7SQW09omca1ABNwd70NGJi/ehecZmTqeF9IcG7UXuS+h6FGNd
	loQg4e5+JzriB/1SNWwE6P90Evafw5QC9Tov1UPwCsBjn5Z6xo2JhFDMlFBO95Br7VIM/78J8kQ
	Zqc1Jt54cbCzcg/LWSn9rO8O7ATJp0063Ikhc5iL5gZT1qoBvO6iFWhwTsE4KAPgbZNe+fAidrj
	UdzaVvvV/PBSiwJfsKrBVWxxkEK3SaSXGtCEk+K8CXWM7E490D7FbX9jaVEZmgXY6pK6PlqhSyp
	+eE0LPSg4HNoYa4+uPH+DRumxw+GQOozAiHr9xEyvcFKw=
X-Google-Smtp-Source: AGHT+IGKkYjGFHect88v3nBapIIglEjinBdFDzqUzlkxH0/8a2RUDjlFw52sTmajInsUVkVgdBglUA==
X-Received: by 2002:a17:906:2692:b0:b04:1896:1236 with SMTP id a640c23a62f3a-b0418961257mr125476166b.22.1756633182252;
        Sun, 31 Aug 2025 02:39:42 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefcbd8656sm597512566b.56.2025.08.31.02.39.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 02:39:41 -0700 (PDT)
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
Subject: [PATCH v2 07/12] parisc/sys_parisc.c: add `const` to mmap_upper_limit() parameter
Date: Sun, 31 Aug 2025 11:39:13 +0200
Message-ID: <20250831093918.2815332-8-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250831093918.2815332-1-max.kellermann@ionos.com>
References: <20250831093918.2815332-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BFB0D140008
X-Stat-Signature: e5iz4hm9s56styekjng4rb6ynu6yzs63
X-Rspam-User: 
X-HE-Tag: 1756633183-703027
X-HE-Meta: U2FsdGVkX19HQ8v/WcCSklP3P4QspbJALueaLgDTHfdgIs3T4pfb+XOQ3ivAjyoqOZxu5sJaVrMAkCReHIJfJEOivdvsmVEKsQ1nURNf3mtdDq96YltAUqm4W2Jm8MYk9HC8R+a50v6Mra57PQ8TdeKqsaA7JbUmjTDPml5mP9jdi30F0xcM6lnJCivncUMyuLAMJucLCpBAGZD6R/PoSp74LjZgJdEdKKhOXBkleUXHbmdQ9U7Ez3MKnFXC7iK2P2992KiOQjHVwNx4ywHPzRCjS3rAgDS+901t4GGh9KqVHgLo8SeN7+N1CxdD8/nNvOBJjM9/egXMLXu50KH5N6ZedG0JZT/1Ar9aA1ksBBfeWhfErSGuUDPkyovpvEzcT1N3MFtCfXXR0S9U5vLrc9/bmBsBeUGbh02BM+vVJkoVGEqgj3JavwALaMn/Ha05qLAJRPdEQZQgiie34XElKZLbYTQy6nDcmiuZbBCWLFGVTjt0aZ/hYPkeEoYN4PPLAA2wLE5F+UvwVdTNxI81xa43Pjxrs3Z88ZG/tLm+0z6O8izDbjTmI30lx0PDbjb10mESHuY0n6tS7ge1Hjidz9b25Eo7v6jIsDgcAG4IaJjdWQ9mR+++apCTL5ECv4UoMfM2HuJOVD6KcGyYBIIl+KXHY0odeeoeK5P9Z8K7RF9Cqx6E5PC496RA9khl4qt83iIpg9LNo+8msD4vFhMRnO6IFNAcQfOxBvQrl4Y6NqoSeOtK5CUEZa/57XaK+YLOOiF5CZ8bCG9+WWBEWOdjp6rVLe3M53Czwp8+P6JzglnvI7mtrwbJaE0pnmtTXp8wCdzYw/hRRHq5Sidg68G7L2/fomOTLzhBdmbNF1N3ZGZHgf6/C3S4stkQQISfeByzaL6CF/VKA5jaQePpKiw4tGNy1o9EieRx1S+hmpnBWmZcmGHtaf4RlZ/boySxoGB1URPdDYQV8SGU2XRnkxZ
 LFouMsth
 BZJxsJ0cEDmupO3VCe6YslqTvN3CgO4D246pQYU9r5xUELDKG3i0bSFv9vCT4OXBDEX7OLKoZ519K6YQkIQtAVHuaLFywBpawm0O6GNCN/Gj0y25JjDYZ9gC8sD9SugdpQ3OA4G2O2asoneWYRtt3YMtDipFyCoQQwM7zzpbwd1YJ5AXYCUnzbj/QAKRnTJFI80O1ViJi93NSiB9unW1g5BPH1du3MO/DIyZzFUTBuuuZJksm0zKww/uO7gH2BJQdYdeWFBfI/Ni7+PreoBuRL+5NwNVDUadquPS79hS4RjHp2EZApG6bijGnLv/ptdbHigkZOcbmD9oCtUKcGo9cOk/D0OzQt5O4+gKFDI/K/9OJEAKlGHeVswaZTCMocSgCTT0sBcEK3/fIDoW3StAvKeaNQshPvgLUDK8wgb27Dk8wAyls4UFhic+ATKycZ08tARznSytaAM6zqWhVKXremLrmY6pBbj3g1MTk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For improved const-correctness.  This piece is necessary to make the
`rlim_stack` parameter to mmap_base() const.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 arch/parisc/include/asm/processor.h | 2 +-
 arch/parisc/kernel/sys_parisc.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/include/asm/processor.h b/arch/parisc/include/asm/processor.h
index 4c14bde39aac..dd0b5e199559 100644
--- a/arch/parisc/include/asm/processor.h
+++ b/arch/parisc/include/asm/processor.h
@@ -48,7 +48,7 @@
 #ifndef __ASSEMBLER__
 
 struct rlimit;
-unsigned long mmap_upper_limit(struct rlimit *rlim_stack);
+unsigned long mmap_upper_limit(const struct rlimit *rlim_stack);
 unsigned long calc_max_stack_size(unsigned long stack_max);
 
 /*
diff --git a/arch/parisc/kernel/sys_parisc.c b/arch/parisc/kernel/sys_parisc.c
index f852fe274abe..c2bbaef7e6b7 100644
--- a/arch/parisc/kernel/sys_parisc.c
+++ b/arch/parisc/kernel/sys_parisc.c
@@ -77,7 +77,7 @@ unsigned long calc_max_stack_size(unsigned long stack_max)
  * indicating that "current" should be used instead of a passed-in
  * value from the exec bprm as done with arch_pick_mmap_layout().
  */
-unsigned long mmap_upper_limit(struct rlimit *rlim_stack)
+unsigned long mmap_upper_limit(const struct rlimit *const rlim_stack)
 {
 	unsigned long stack_base;
 
-- 
2.47.2


