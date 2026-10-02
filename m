Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A11D5CA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:10:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD63C6B009E; Fri,  2 Oct 2026 05:10:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5F696B009F; Fri,  2 Oct 2026 05:10:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 926C26B00A0; Fri,  2 Oct 2026 05:10:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6C1616B009E
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:10:46 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 01EA21206BE
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:10:45 +0000 (UTC)
X-FDA: 85277116092.11.3D90250
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2D688120010
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:10:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cEJkmdkA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790932244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2/5XOnfiZIWhHaazfIksBYAhb1bM+JDK1FK2T/8kf0k=;
	b=LJyRz/7p8CHntf8ja39TKKEmBkIwekme5iu/0FSeZ8Y0O4HWGM5VK89mbexq5b4YVRnx9O
	/VpOHk7fNWqN0xhcoMoAZmo/oAN8wS7DHi6IeVouIJqXTLEF97ZB2+LcQ33QHzvVdaANcl
	6W5WQFOpOECz6DI3ORbgzfCtlExsLB8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cEJkmdkA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790932244;
	b=2RrOvsSxj/dOW03gt7+9s9FQ5a18NIXkbnpI8ZivXStKnt3v1b2KaPNwg7TAbAYwvVrHuf
	4DNWeZIp5R4lmNK2zW1dUO51+zKWfJOoTP6p+2tlCekFDjx5HuzlIzlw5Op4dYrqMW4dBp
	cVNFflVAW85eAmJLCvqCieMKQ+9yOHk=
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d90ba1d807so59107725ad.3
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 02:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790932243; x=1791537043; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2/5XOnfiZIWhHaazfIksBYAhb1bM+JDK1FK2T/8kf0k=;
        b=cEJkmdkAgo6hkk3rkNUf2cO7SWf+whPm0MWxGzkcZlwHPlJwuN/NiFXB26xKgPx4N7
         wejoEccBp8dTgNOEaevBlhTXpcbZtj0jJlYa62wgrBMy1LVPC3ZofDJqZ8wtjtCZtQyt
         rsnq98X62Q5tcvIKDQNrWSBOW9/gHiOSx2+QeX56x/06LcAUL8HygvNpRHZZ0CD+vLMw
         f4JKFBo3KXYQvfNeHuFOvq8uJsG7E9pfsPIAFxfLaeU8uUgKnWAoR+KZ3Szf3dXDgtkX
         Jwz0jxrZ8Rl+/NXNWFs3RX340us7CzkO381XO+wEKg4MLz91CGcATJSGdihS83W5vT5G
         +QFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790932243; x=1791537043;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2/5XOnfiZIWhHaazfIksBYAhb1bM+JDK1FK2T/8kf0k=;
        b=edSJFz8AkvQYBqEc/Ct5EnGyWnp0SQBXD3kMwhTziBHtzwkM37D0/k2yBT7vuUdJuT
         1NlQqZU3vEvEb00H4z/m8KXuf77E5jID2HGaLuqm4dpJfXKdTdOspHRkFRpBJdONbKDH
         UxXAc5+5P+q+eDYxgWvtD7EtgOHnFfhvwPIlTvTwrt09/8DD31L1ZxSDzh0vePg4faz/
         KFNxHM72Q+Hjk8alaWpTTx7EmgJImgtMtqjUUFYPNCe7Y5zXVXCh4Oan24BdxASKvHen
         Wg69sa6pVNqk94PGE+zz50Xkp10Xcf8vuEIWKxCsYrppQsetvNVLattisI/RMg10HCUb
         JHBA==
X-Forwarded-Encrypted: i=1; AKwUvBy2jhqt+a5fRB6edv4jGT8xJ6tzjW70KyaWOgZOLXEAT/XqVR/xSFe9KjnRaQWrhRtXa4zmEItZPw==@kvack.org
X-Gm-Message-State: AFuF++lqU8aYucuXNR8LGJDbx2rGiMYqjYMMlqcp4nJSOkRPQWgb8dk6
	G0t3+gCba36hDhwGY8h/Qj95ftg/4cYFHddVusfRt0ppSZRGb4kdYPtT
X-Gm-Gg: AYBFou2NfVB1YSA/SXH7LsSAwMepALEo+Hnq7nVh02RFlgGPxire1M6VQYagid9E5Pn
	3DkLnu+4p2S//PZMcPJWId8SF7GbhqE3y/eRZG7FA5bhlVOpYCuL7Vk12tYSWq4Qx7dl5gjDx1Q
	d7/RWtNEqtg+0TVfby7t65UpeCNhCNz4X2MdFk6IPv3pxrJWkT8TulE7w+nVhwACxhEr6EmObhn
	DIBQdr2uFOexApDYe+1reyNAvlqFbf7S7aEe0yqp92XgwLAXmNtZRYgRYTmUDASq2JJpWGsgInv
	M0n9v0Rz+zEiBZn8Y58W2q2xk3Is41SeiyqQe+E/lZSiVrmxD38EfJep3AMQ1BMPdOMTpqgZ5NC
	3oBSegVK50oijWCj2Hhz8ggdw9A8jIARAakn8/3Sg6WRtFEAMTmFBBf7cpb5bMpDBxKfnpQutuX
	Wgyrn+mHabErupprqsMbETkRhYalkRfWDgDen9IF/YDT+XJZiWv4vHntR0l/z8492wODBqrEcLA
	R1jzvbi9fqdda6Kxzk9HA==
X-Received: by 2002:a17:902:ebcd:b0:2d7:107c:917b with SMTP id d9443c01a7336-2e498517c3cmr18629185ad.0.1790932243081;
        Fri, 02 Oct 2026 02:10:43 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e49f6ab2b9sm5480555ad.36.2026.10.02.02.10.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 02:10:42 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
X-Google-Original-From: Wen Jiang <jiangwen6@xiaomi.com>
To: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	linux-mm@kvack.org,
	urezki@gmail.com,
	will@kernel.org
Cc: Xueyuan.chen21@gmail.com,
	ajd@linux.ibm.com,
	anshuman.khandual@arm.com,
	baohua@kernel.org,
	chleroy@kernel.org,
	david@kernel.org,
	dev.jain@arm.com,
	jiangwen6@xiaomi.com,
	leo.yan@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	rppt@kernel.org,
	ryan.roberts@arm.com
Subject: [PATCH v10 08/10] mm/vmalloc: extract vm_shift() to consolidate mapping shift selection
Date: Fri,  2 Oct 2026 17:09:45 +0800
Message-Id: <20261002090947.869220-9-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261002090947.869220-1-jiangwen6@xiaomi.com>
References: <20261002090947.869220-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2D688120010
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 5kw5btujmj6j3cuyk9dxc73maxks5gfd
X-HE-Tag: 1790932244-881557
X-HE-Meta: U2FsdGVkX1/YVq/BOBqZ3A9+BG/gA+Qy3eQ9nlG2OlbDeCCZ4RTRUBQeHE1YUmb08Gx5/FrjpN1t0GqXDtSsbCVIMszqkI1YhNxUvYHpkxX5+PLqACml905zhLArLZs9d+JeRE8WYGxPEtGN4uDqh1mVm/6NH6zHs62Atk7wpWt6uIl2/T/J3ZJY/ckWXV/qnpeRHkFgnygN93Hyzxp3hmgF3I4g1mOejan8PlEl+4518s7FRD5esKD7VKCghAzxqck+T88OilnRdM2KthWrOYPqNpecs+QghpeICZGIH/ZkPPk91cvDKveX4p8Wy4cPE8Xofi4koUJwkdhNrOBBFmmWa+rLWcf2UNKRmoa1lQoPEyNQtnsLMbcAYWnZ3Dd+6Y5JBWn2G+3S4EcTyPESlBIuAkQT/zV1eqf1kZQ/F1fFfsEflTnYa5CFjhR4vXZj96cFXLktuTThkvopwJftY34eTos1Yb+VspPi6o6K4EFcZpODpjLqmL8KSxC/9UEvqHqLYYmzIEdEqPYhhFQpQUSJOeEW6vjSQYg3z70yOOxS6IsKZ3EJKAMXVic+ydFb+B5CFVWDW+uTaC8UAytkjOY3qE35sQWtQUUTNZEm2KxY5i8+4r4V/pvYVCvJ7a8tLGT2vevCQs1pnQWUbV+lecEnIOsCw3o1d8ZLy2V43ZsN9RDWN7TqisNeE/ni5j+L7ATzaKKmnhC6qT7yZxxWsauaPDGAtTnd4MnlmXaJtL2NTH/2mgRo2EGRcf+YNjGIh0xtl9mBuvaPRM0cXiuo76voV1pFcVdEIJVGuAI4RKSh+Y1DG3uf6sBcxxDhPhKYYVjrbM0XwY0hNAMypwUbWIcMc8PAzf3xf5Wz7HGVIrS1YV3CYZySdKgzOJDFYDmzPGjJil3mwZ9g4YToC7mOOYxDgjP022OUE7b7WNuRjA37xSf4ge6tPfwBRR/gwO2wq+258iZJbgUDfaLsRzX
 HlhNmqNg
 zVcdie50DXWMJMy+WhKsB9yVBw7aZh45IaAwn8v6LPCm5t5jmPz0RzIQ73U1Uhmj8J3fG/g/Vrz8ShmtqcvhTOthJNCsB5kEK+0bNSFg+1/fASdR+hJMws78MPdrXeEiZlTK3Pnoa5dbxa9hSYo01OL5QHjoVNEoJOuTU/guCBlMIPeNqM890oK5iCv4YFOSgBfjXVdDfBAWJXLXzLoVvE9rlk1k++QJW2/KA/qo3oAyBTWo2RAzOq3fY3T/DFyL3CAn701TcDx+gdCqugBo+c4b7mOm34484zWDiAHeBoJoVrNQlNZAIhdAlrezYPQ7yyhGeP5MGuLwHrmmLhV0lAXvUWQhKyPHjBk5K1Fu/EhHLUemKN2gLvb0UWcrsOjrUrE27ZLboGMJdic/o9+MBZX1zB5No4a6hoqzIoSe2GPuKh5HF2cYIPXCh4iK7kqhsFIFB0+cBVu7e7Q2mPLZV1dPsy0cK7rmhfoP4FByT24ThfRgdRk5bPa5hixHInXd4WonaNq/CXzEBuFYI+EYZLpfm7c1zcrmjXQ+gnfrSJb+8OjrfW/qzf2/3FaQWDXay/ZkT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract the vmalloc mapping shift selection from
__vmalloc_node_range_noprof() into vm_shift(), preparing for reuse by the
vmap batching path.

No functional change.

Suggested-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/vmalloc.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 99bd22c086bf8..aae6141aaebf5 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3568,6 +3568,14 @@ void vunmap(const void *addr)
 }
 EXPORT_SYMBOL(vunmap);
 
+static inline unsigned int vm_shift(pgprot_t prot, unsigned long size)
+{
+	if (arch_vmap_pmd_supported(prot) && size >= PMD_SIZE)
+		return PMD_SHIFT;
+
+	return arch_vmap_pte_supported_shift(size);
+}
+
 /**
  * vmap - map an array of pages into virtually contiguous space
  * @pages: array of page pointers
@@ -4079,11 +4087,7 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
 		 * supporting them.
 		 */
 
-		if (arch_vmap_pmd_supported(prot) && size >= PMD_SIZE)
-			shift = PMD_SHIFT;
-		else
-			shift = arch_vmap_pte_supported_shift(size);
-
+		shift = vm_shift(prot, size);
 		align = max(original_align, 1UL << shift);
 	}
 
-- 
2.34.1


