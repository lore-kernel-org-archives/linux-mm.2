Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6C1DD59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 10:40:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0ED936B0006; Mon, 15 Dec 2025 05:40:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09DB56B0007; Mon, 15 Dec 2025 05:40:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA6F06B0008; Mon, 15 Dec 2025 05:40:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DA3546B0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 05:40:30 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B205B61020
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 10:40:30 +0000 (UTC)
X-FDA: 84221361420.17.C0E4BE2
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf26.hostedemail.com (Postfix) with ESMTP id DC868140006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 10:40:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=c73Np0Vf;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3m-U_aQgKCLYfWYgiWjXckkcha.Ykihejqt-iigrWYg.knc@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3m-U_aQgKCLYfWYgiWjXckkcha.Ykihejqt-iigrWYg.knc@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765795229; a=rsa-sha256;
	cv=none;
	b=THmsQ4Bc4c/ORpIc9vj3B0KFMe75oPSK1PsvBoSE4oa820mo3KyXsvXtKkLpCuT366AoVB
	GtzHIyZhNxzJeB6jYFHNq/Pm8WtQP8fbfBBvyV1bk3nlEncgSezOj5dCfOZmsrkSHiMttN
	IE0yr0+0Ij1Zwcu/8j13GzHGnJSiJa8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=c73Np0Vf;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3m-U_aQgKCLYfWYgiWjXckkcha.Ykihejqt-iigrWYg.knc@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3m-U_aQgKCLYfWYgiWjXckkcha.Ykihejqt-iigrWYg.knc@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765795229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=sTvGtLS7N+gCGHNScVBwulc7S+0JY+4KtDSa6CxwkxY=;
	b=DtNVPp1JpKTuT8D+PgevWgp8qAHjQla361ll/17e2XCoOLqqdzUBJ0+1j4GHRWprCnjXhH
	Vf3Hn+yL5QEZDddm671PnQudIy2I/NFQ14ScFuC4SAQBw2Z+xnUTKARhzQcMJW1/jhjZ+K
	1uEy0y9TqxskElM9CSerUHMtV2QZF+c=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-477a11d9f89so3048715e9.3
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 02:40:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765795227; x=1766400027; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=sTvGtLS7N+gCGHNScVBwulc7S+0JY+4KtDSa6CxwkxY=;
        b=c73Np0VfpvWllNXKZDuRDz2D9PrzbopCqzFEdmlBIktxJAZTCQ8fl1eFAdJxZAmScK
         zzTXFlNz1dGgjBV0CY4v+ZRP9+Flvtnn7zuNl40kKmHkk1IHJzIAf44Xxfg6mGIJmywo
         A7W2hfSOks/uUnXvdw5j1UHGjfAxwzZd6hUJAXUxa4vq3xOfOiYYC/VmYSjR4Yzpp/ul
         hlCmzrYkcwJztbnFnYR2eJIHwdSrv2mdtlR0gXhSs6nsLdyQvI2UVS7zztAK3VkHuSz5
         0T23bcQ9csHXU6Tf0Dmk4KRh1C4iUF4EnRxP+r0aurX98iVq4nRmEN/dbvogBXQ5LvyV
         XbZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765795227; x=1766400027;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sTvGtLS7N+gCGHNScVBwulc7S+0JY+4KtDSa6CxwkxY=;
        b=bj4+XZTCCIZBVo0RQK77j1UkFkzP/YIyHOZQysgcWYhiNXgKZQyV+cRWNr1ALixCbt
         NmQLUeq4hxu4JExWtQs7z+0NqRsg3urhIyl+espmyVMfVS3kW8mEBkNizxBs+FNg12FH
         An5f+HMfGrDK6jp13FlIrSdJ2f2pL8W6lskyk+s9ECaLYitvq8I9X9bO2fI7LwTFdJzD
         NtGU/z//j+sWBkNss+J8oU2SXrANBj7NfDGprBpUaMf6jXczkKExG20q8UW92czfoUgm
         9Ipifokc6PdoVADmEAij3OEztkMIM1BQV/3H6Qg6K5mwg1VzM+e5mVp623P2DMjgr1p7
         B1Og==
X-Forwarded-Encrypted: i=1; AJvYcCVSCBDmGhpSMYU91xVVgDPgoZFdnsbbDXpid7mRAm7DWsB+eR5DE/h/ltTtB9T53fURwJzwQ+AfLA==@kvack.org
X-Gm-Message-State: AOJu0YyOLsek/hvHHQgcTd4WaibTGHW/IE6aacnOqMdb8to+S59j+NnO
	d/ce7fzwU0fFtTMyDR9SwhsU0wxrPwpxvZpmYWl5z9g/hzGgZQEdIIMLQnLZhJ91rBzPy5bbHZN
	nfSlKbf1DjeXXEQ==
X-Google-Smtp-Source: AGHT+IG5GkEWqIH4ybkcTK4ISjnWq/y+Aat4wfFxlH3Xj3He5aRLXuRIJMIOLYrtbwFX8VEwBSblMj4mh/OfzA==
X-Received: from wmpg4.prod.google.com ([2002:a05:600c:4c84:b0:477:55d3:90d1])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1c81:b0:477:a02d:397a with SMTP id 5b1f17b1804b1-47a8f89c91cmr101729205e9.2.1765795227251;
 Mon, 15 Dec 2025 02:40:27 -0800 (PST)
Date: Mon, 15 Dec 2025 10:40:25 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAJjlP2kC/4XNSw7CIBCA4as0rMXASB+48h7GGKAjJWmLgYZom
 t5dWje6MO7mn2S+mUnE4DCSYzGTgMlF58cch11BTKdGi9S1uQkwKDmwhmpB06D63hs6ONtN1/d
 cl0LVkqNAzkg+vge8uccGny+5OxcnH57bn8TX7V8yccqpFEpq3aDRrDlZ722Pe+MHspoJPh350 4HsgKhAK6hQtfzLWZblBfCIOa8FAQAA
X-Change-Id: 20251208-b4-vmalloc-might_alloc-754a791e4e10
X-Mailer: b4 0.14.2
Message-ID: <20251215-b4-vmalloc-might_alloc-v3-1-92dd8e406868@google.com>
Subject: [PATCH v3] mm/vmalloc: clarify why vmap_range_noflush() might sleep
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: DC868140006
X-Stat-Signature: jyfsi9jkjehr56w74i63snoby9omt18r
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765795228-23181
X-HE-Meta: U2FsdGVkX1+/PicfLF5Ic507uY9ZXWQ0rWZMyjWuD8kKcz7KDMalRG+vTEPKERseWBEV25jbQ18USnVBnU0SG1jrueq6EMku9YgODqdF7DaQx4bzcP79wEVosfdJixUrpxD6+XuUvOvuD/lSxRWaqN3/BKNYrop6GbNqZgY+wyrdGK9af5H8AoF4llEhc82/9zSDrVT/w8G6PuwTM677Xbb1Dg3YnaiGATU8/SE94/AIwkA/pAAVkIZxfQ9IZAXlmRm6GOanT9GZ7cPcjvMbk6Oqo8NT/g/6A8CLQ76dzNuLwjzL+9PFGwxOVJHcQYXuaYsdt8ZYPD0TkXHQtJdS3G11F/mMrHjFwej5XEJ5ig07LGL97tNCEwchVTwCyGpDVxJBlVeemK0WEGp81JbKR3P1Nu3Q9J/DPNSziMLwuIpevXydTA9VlzT6cRq/zmZS/S5f1xNb3iI01cLyvjq1PUHiTXJUuWoacwYPOwJ+DkxxDPf7lc/JeY0Ntm812j50SMOnUmlt0UBZZfbpzErrWVvztxc3EBFxHpJWQrRhVYi1Wsn32q0QHEwFyXOLkUc+X/UEAHP731KNf15XwwQwNRWbpXjUkk/9MUY4OBDx90/ciOrftjkRcgtPVEd/iJCvWTPALPIgMkOE1veYbAzS6buEFgyPmGhsvbgZiY4sVerCBbm1pThqreFlBVCSoj08e37GR3r3Us9JTkoi8flT+9lKFk4kTHSfoPddJM8rwi2UVxksMKWSrMSJjrHJWJ0zdfiYfxb6gIQ9RYnKLy6Faq7JDw/3S+cjiRFpq1uhLZ7MM+P5EaTfYZxloxS4a0OAsUbbd10YF/nm0nJ96DIL5FSUyHLLCmesR4eT63rkOZEdXfQF8XaIQuIghUiTYgW9x8mAW4IYKy9bT5YXSI9tQAHdR9g8/Q+QI5dQ7kY8BvYOTLNnDAwhMJ691lxPzqHuPKLsgvRFX/4chPGmang
 N4xoiTgA
 71KAXD0DOk54qE/WUqCWVfG2NvRNN6vPeBCgd+GbV88qGMY1bD9T1qbUK/G8WNSTSQjmzaJai/8pmRyVUWT+M7mBhUks1ao50VhLqCtlC/IR92iUo2iDWCqntunNOJ0tQ1djeQ+pYMAnb5Fy0m5iZr34AAfUzaYGXmk+h+TDZ9ZiIeDGg+lc7Hhx2dR5wQCRjCZGEAXkqpAuOhdgGk9YnGVphoEEqLgdFOFuehPeSSIg/8irk0oYVaj4OCxF+niSEC3znJ2AKso9hyz7O6sucHdlV6KoxodJYnXz0OmOVhHp1mgxu2ebMPSRQpKiqVrq0NTiuY087ozJVeIfiJkoI+Q3srlBq9phzvlcK2f1WbCMDsxbDuvnU0gryzro/ztRSEvqdGnMxXBK8Pb6GG5oq0JHj6f/F0l68s3wUXuzX6EdG+9EZKIDn3ONgYc8ZeqLN05hI637Q1QfeRm2mTlfYZ220v6BOQnMirUuabcWJmHi7E0FCPPV+w5I3L7WnpDTB8kYJVSyKxOQqDqAb3rVOHH2neTgibcUIof155daXadRRBW2rIxlku+PoWaCnWgCImG/qRRtHAOxc2I9T2GWS7xFm+kNpd+zW3HB1HnwhL1vrjSFuvC5RUxcV7Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The only reason vmap_range_noflush() can sleep is because of pagetable
allocations.

The actual allocation mechanism is arch-specific so might_alloc()
doesn't work here (what GFP flags would be used?). Hence, just add a
comment.

Also note that this might do a TLB shootdown. This is not actually
sleeping but it requires IRQs on for x86, and might_sleep() incidentally
serves to detect violations of that too.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
Applies to mm-new.

Changes in v3:
- Added note about TLB shootdowns and x86.
- Since the comment no longer fit on one line anyway, also be a bit more
  verbose in general.
- Link to v2: https://lore.kernel.org/r/20251209-b4-vmalloc-might_alloc-v2-1-2462ba26ead1@google.com

Changes in v2:
- Switched from might_alloc() to keeping might_sleep() + comment
- Link to v1: https://lore.kernel.org/r/20251208-b4-vmalloc-might_alloc-v1-1-94a9bb8ecb08@google.com
---
 mm/vmalloc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 41dd01e8430c548167d6123f6ec66bf798f20eec..be4e5f2566a4490d45de29568df538b7c8515b01 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -305,6 +305,11 @@ static int vmap_range_noflush(unsigned long addr, unsigned long end,
 	int err;
 	pgtbl_mod_mask mask = 0;
 
+	/*
+	 * Might allocate pagetables (for most archs a more precise annotation
+	 * would be might_alloc(GFP_PGTABLE_KERNEL)). Also might shootdown TLB
+	 * (requires IRQs enabled on x86).
+	 */
 	might_sleep();
 	BUG_ON(addr >= end);
 

---
base-commit: d0a24447990a9d8212bfb3a692d59efa74ce9f86
change-id: 20251208-b4-vmalloc-might_alloc-754a791e4e10

Best regards,
-- 
Brendan Jackman <jackmanb@google.com>


