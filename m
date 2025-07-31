Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87D2BC87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 09:57:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBE8B6B008A; Thu, 31 Jul 2025 05:57:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E41566B008C; Thu, 31 Jul 2025 05:57:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D089E6B0092; Thu, 31 Jul 2025 05:57:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BBC616B008A
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 05:57:35 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 38910114338
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 09:57:35 +0000 (UTC)
X-FDA: 83724107670.08.135BDCB
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf17.hostedemail.com (Postfix) with ESMTP id 350C540003
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 09:57:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753955853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=R/ZMu34+dfDqJr70iyRbEwHfXPhMJ5Qmf33UpYcbmoo=;
	b=FeEqrCMT2Ur8qy5npLeZ49KZ5mAxZR2Yp4G8HEk3mHVaYS3kqjHqa7g1+X2NNsKMp/8CSP
	4T43oM+wWpagK+0cvHEb5pPCSnDKtNTnZwD6Rrg+hESz9KhVXThwJDENzlB5p0eU6s6iZV
	zNsb4MEa+mz9njKXWynbEiXiT55GvoU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753955853; a=rsa-sha256;
	cv=none;
	b=bSQL4Prs9qQCjuyUQFil4MD1M+wMD62eUSgvp8QMN3zJUlv8DFV+QcWo26W49EuXdLCwY9
	E76pH0IxK353svfFpOTOTzFjRWmEGG51TNo5rQqTVnIAJVRPg8EpotVVYlEg1Fiw3hNc7i
	2hHOlSr6tiQ66MJtNCeGB+nnlcv2Q5w=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-af8ffa04463so130685866b.2
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 02:57:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753955852; x=1754560652;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R/ZMu34+dfDqJr70iyRbEwHfXPhMJ5Qmf33UpYcbmoo=;
        b=eIZGb971XFIp3Hhb5zrCdo8KbwSWJLTYicKNDZYENopNj7pp7eBGN5NHC1G7JzdjWv
         DcCK9R8uGnxDbqqGvlZTkGe5kQT7yHJvjj5W+feXU2wXEwvzGTJSQ6cPUsbpadj+V/w9
         5GsnHEqzuuEpQmv59FBKzyM3xVT13Ffabvj+yfNtu0UEEx6G1d3uL1+RPn7esktwAscU
         TgAF4Pxg0h6jKAn3z8QUMI2U/ORa725NAKFOXKuIYTzWupTI5rqoAMUUddeLK3CLpSBl
         dJYcvEF2qey2lwmlmKbHI5MlYXzebTGxB4Wib/qVUr5MIE1+to+SGj8ZnuNGV47C9OFj
         wZ9Q==
X-Gm-Message-State: AOJu0Yx8+lr+GVrvGLX/x81QDr8M4h+F/d9rFqdUBjf4P7Q9bvQe3Ipw
	3ByKDQAQPD/vEpYiJIBOlE1DzIXZu+7L8PjnQVbwL8RiiAYO6XD6wYhy
X-Gm-Gg: ASbGncsY//Ejixu3tUAU+72T5mn1XqSjM+YRejjtHk7B6f6vtpxaaELvaZ6Tpdzf4bm
	z43I1bd5Qz/y5WBbc5FnoYm7JAZDJCmHuOjd4ZZGF9mBHDRgbYvPCEoqKmlvjznDiiYAvvrFuJY
	DzlymGRIMRqEWTm/a5SvgT3/ybLJNYI1n+BRhVjiegP2Vs4dU/9vLY4a2PbJ9zcsa5Xevr4veAL
	xkIMwfsRyPGahF0OLAcjlcVxd4U78NyivPRi/A2gQXnT5+7c1JAe3Y0WGaJAuiVBjC/M+GPFLdJ
	LQUB8SVzpUA+FYWNWaI4SGXdsxzCjMeD6+X1VUp0INRZqp4RSqGXGztUoM64U0yTg5vCL1uckmz
	e5KVb+beVs4wh8w==
X-Google-Smtp-Source: AGHT+IHDwS1JVl5cXBKnOS59wjRCq8XbXS0qqPh/VTauGUKlgaq/Hd0hJtKARbxzzFd4RBE4+Bq4Qg==
X-Received: by 2002:a17:907:7204:b0:ae3:ed38:8f63 with SMTP id a640c23a62f3a-af8fd6b45ccmr837277566b.14.1753955851359;
        Thu, 31 Jul 2025 02:57:31 -0700 (PDT)
Received: from localhost ([2a03:2880:30ff:70::])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a1e8992sm83409966b.91.2025.07.31.02.57.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 02:57:30 -0700 (PDT)
From: Breno Leitao <leitao@debian.org>
Date: Thu, 31 Jul 2025 02:57:18 -0700
Subject: [PATCH] mm/kmemleak: avoid deadlock by moving pr_warn() outside
 kmemleak_lock
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250731-kmemleak_lock-v1-1-728fd470198f@debian.org>
X-B4-Tracking: v=1; b=H4sIAP49i2gC/x3MWwqDMBQFwK1czreBaFJCs5UiEuypXuKLBKQg7
 r3QWcBcqCzKiigXCk+tum+I0jaCcU7bRKNvREFnu4cNrjV55bow5WHZx2w8rQ/eMYUn0QiOwo9
 +/9+rv+8fiSpraV8AAAA=
X-Change-ID: 20250731-kmemleak_lock-4e04743ea79e
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 netdev@vger.kernel.org, kuba@kernel.org, stable@kenrel.org, 
 kernel-team@meta.com, Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-dd21f
X-Developer-Signature: v=1; a=openpgp-sha256; l=1989; i=leitao@debian.org;
 h=from:subject:message-id; bh=IT7WZL+si5He7mq4mj2zOeV6liA8QI4VawPHix9Uwmk=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBoiz4JTz9wQ0LLi6k6r0lLFiorWuKQhaEMAQ/+q
 r/kHLh8WaKJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaIs+CQAKCRA1o5Of/Hh3
 bZMeD/9x9pPREt190983hCENkhsa6Phfwo0J3tQRaG2Ju9HghxMjvO52+wKBq2yoGBeHQnkPdzN
 tsCv1LzVCe/p+MQlbd4G8hqGAUiX5fi6XSUtCmnlXvPFbN+W869mgW3EfthighxDrk23e/mk0Cz
 pb3rZ92zDS94zmJw97L32m8Q73B537Ytmj8EP+UsKnYC/uscFFMaLIc66J25yTjtBPY3AS1RD//
 yTAcSsPCh1mTYPtu4jOse7QdrSAvgA9mutATtEqyD7+ofl4jYOa1NMl1zuyab+DrnsB0EqZSi0z
 Gil6xzz+b7WLbmSvdW+J7ulxmjNBVJ2iay5FVLZ3gsqR02nyRSmO3ofeWz9jqjiN+5Vf9Jhm2Qx
 ltKIA39iOdQdcZU8dL0Lng+BN50PzoD3VaXOtgPEpauqd60gJ/L8OQpSVgpyfjg5Dxv5r4mfAVO
 c81oB6xEXjc2kaQLlFJ6eRPNX+fLefwc//MvmUJQCneJOiKdArufGC+QqTJcCqgOyEE9Kg/q5wa
 ZRXAHNIwn0JpW2WfeE4tRhUq+WDi5mBzLDL36fTA2EAuV8dDXmd9iqaXOr5TwHPylHCi3qbcYvT
 s5W7nMHNyUV8gHbm7A1cyo3xgPVxcyJbQPWFc087/g0MoOvsESH+7fzLRcg1aEpPre/heqYv5D8
 uq3vALiHv9alnTg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Rspamd-Queue-Id: 350C540003
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: fjpzih8fe479ef7jjwg3ztgegb7isexz
X-HE-Tag: 1753955852-600727
X-HE-Meta: U2FsdGVkX1+WWA9/9ewmlBqQvHA+qlUmLZc5kg+z0K4W9QpLPWFAn8t/zUtUHX2T+1z/BREJ6oTJEFLNMp60mU0m3dHM3NB2oiY0uaFSK7iYnmVdoFIFliWtS5a70wQYN2Xwx+C9RKp8B/ON9K5q9mOj9Z6FizEBf5LC3v5U+h2ps73RdrjPu7cn+xe0BOXe9i3eqnnAYXEEikcvoSA0GSJ7061gAqY6XdcD7t0c0Zn239EAKF/TY75hPCazytxKbvc9S69GIOb4G0S6ZDF8nIaSMAYA1J8OgLz4u3dH7npwpf6YdoNdvebPf3oHKZseJNeDu1ZvPJNIIofhT51+HFXs3BfV5jb4kBTFTKRqZo/KIGfgpEs4fYeIm2sCl+bVEhTW0NIdcgzRQEdGnaGK8axgTnqoVDH4omUJJHcEbD1Jegtqu4r9kpnGsxVyDBdaMmFamxSPYzyPoNqtrRmBGaEW2+KuPfe0mLj54ioV+ujtyMl4o7XWXAVnPlZPLmPMYH17IN3260WeHIvGEKPIyxT/08mM/t1MDXqYu1jTK+dmtNvPPnVb0jeGT12JNsLnJ0Vc9CmZt+XxXdow9rjMt6P8+YFaAZ1OPh4etpxkuqUaVJ+D3hdhlm9YeJRX7HXCMwJcMOoBmA28m8QRKBt/4j1ue7ZKRfKHTCp46s9cYXCXaGWerjvb/vkD7PUkoGtckf8Wg8S2nTt0SsdBNzG5gVSjHWicS/aohlsEviOT96Ez0SuLGP6Y1SvAAKXmx6zPA9BZRUlhkSNsgGC76cVp3w3YQI52iHwndJLYJuPYPYKQswxSGjuzh9rtUsjMgEye5E+sIY4ZvA93Fqsl7a4QJ4Yk2Vj1bXmhmPLAmv2y9t2OdTjbANDuB28wB93T0TuoXpY0Bis7tTKtUb4HfruIHI1Cv95SF8cL4vlHcNPkZpTXx2iKSjLPOemuiunluMlpj9Rea4+UXvDXIhp0CbO
 AAXEPGiV
 D25HP1jDK0aQWEwvCmYhYWu6ETq0UfXLa0CNkhWLzJYtn5QbpkQp/dDqtT3Rwlb8NB2cGTpDBA1ASAdH93twieDTcVXgZV9n9phVos/2Qm8AnAeYGvEgrGUxQFwcPngydLl5WgJ9q41jtHfFspHTZ4LsmhoUWXIUjEZthbCil951Mj68v+Y3/kBW3kEmcX3Dd7EGeHIH+0D5RuqyUCalKmbyCJp41XhxJIEEubzWNa3D5ex4FT6Pa0hrHLBlxyvMII9I6rDzj+3D3mbQkl1UUJ8/eaANI7swJ7cSttiK662vUj+4BFy3iP1i4DTuui2RwmbrAnuQIN512tHEHxnOoXVQBa6a2vWEjfVKPVJH9DRK3NpZn85zb5iyC0LJTz5IYZZ36udXafeINEajBvUI8O+Rw9Ydoiy+m/LXxdduXYnPvFXoUKXzREMKIKkTZrt3FMyPL4vajTsBXsnTqn3Wu8eTByLPwquGhxSiX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When netpoll is enabled, calling pr_warn_once() while holding
kmemleak_lock in mem_pool_alloc() can cause a deadlock due to lock
inversion with the netconsole subsystem. This occurs because
pr_warn_once() may trigger netpoll, which eventually leads to
__alloc_skb() and back into kmemleak code, attempting to reacquire
kmemleak_lock.

This is the path for the deadlock.

mem_pool_alloc()
  -> raw_spin_lock_irqsave(&kmemleak_lock, flags);
      -> pr_warn_once()
          -> netconsole subsystem
	     -> netpoll
	         -> __alloc_skb
		   -> __create_object
		     -> raw_spin_lock_irqsave(&kmemleak_lock, flags);

Fix this by setting a flag and issuing the pr_warn_once() after
kmemleak_lock is released.

Reported-by: Jakub Kicinski <kuba@kernel.org>
Fixes: c5665868183fec ("mm: kmemleak: use the memory pool for early allocations")
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/kmemleak.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 8d588e6853110..e0333455c7384 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -470,6 +470,7 @@ static struct kmemleak_object *mem_pool_alloc(gfp_t gfp)
 {
 	unsigned long flags;
 	struct kmemleak_object *object;
+	bool warn = false;
 
 	/* try the slab allocator first */
 	if (object_cache) {
@@ -488,8 +489,10 @@ static struct kmemleak_object *mem_pool_alloc(gfp_t gfp)
 	else if (mem_pool_free_count)
 		object = &mem_pool[--mem_pool_free_count];
 	else
-		pr_warn_once("Memory pool empty, consider increasing CONFIG_DEBUG_KMEMLEAK_MEM_POOL_SIZE\n");
+		warn = true;
 	raw_spin_unlock_irqrestore(&kmemleak_lock, flags);
+	if (warn)
+		pr_warn_once("Memory pool empty, consider increasing CONFIG_DEBUG_KMEMLEAK_MEM_POOL_SIZE\n");
 
 	return object;
 }

---
base-commit: 260f6f4fda93c8485c8037865c941b42b9cba5d2
change-id: 20250731-kmemleak_lock-4e04743ea79e

Best regards,
--  
Breno Leitao <leitao@debian.org>


