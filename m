Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF6D3C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 05:30:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D21316B00A4; Thu, 17 Sep 2026 01:30:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF96D6B00A5; Thu, 17 Sep 2026 01:30:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C10C46B00A6; Thu, 17 Sep 2026 01:30:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A33F26B00A4
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 01:30:41 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1D4A480231
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:30:41 +0000 (UTC)
X-FDA: 85222129482.22.86191A5
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf02.hostedemail.com (Postfix) with ESMTP id 53CB680004
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:30:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jB0pOzwu;
	spf=pass (imf02.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789623039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NzaNd9dh5gQiSMMbEDA26vNGMF5WFO7Tl8lfuiT6OXc=;
	b=a2VINfApn8KdvePEvyiocmTOBENG1RFBpw5GvWWR95hr5Fv923AZXkSg8JZuSihQIT52AV
	flBJKYQdJjIrVPX8QZXzbU0u3m6hNuMWKSpEciJhLdKd+hCUpyjpa3cnR35UmBqRLNm8XG
	SKzz89Q8yiuxM/4WOs+sq3ZT1VnEzGg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789623039;
	b=LFKSdaL+BfQldLDHcEBW0CmjU7v2yeE5LFGRgHuMJS4e08JI6bdm4JNhGQNDYGI3iZqnzU
	sPlYKwDxAD0AwVq/GUu4kE8GBwTBSrzDuzswJ15phezn9YOxNmppai3khHPlIa3r7rFc8y
	THzIN5FMCfJaV+8+/jVl4tC4+QFVpXs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jB0pOzwu;
	spf=pass (imf02.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc1cebad4afso327713a12.0
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 22:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789623038; x=1790227838; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NzaNd9dh5gQiSMMbEDA26vNGMF5WFO7Tl8lfuiT6OXc=;
        b=jB0pOzwu2lqmbwHEhOgOTVsxGgaXPLkb86BkWNX8XxMc2NPaPZYZdcRiucGOCSFNV7
         y5KENzllfO6MzD2aAj0Wx4rvJJjsa43baY3hIQCc0NJ0xxyWwHXtdvxw+4NyCkpP1kcC
         nMxvvkEMSNBT6AKZVxc/aqB+lpALPEYdwkSXK2Wov+MzKhSFiT/8gDJPwgoYBcF6vTcq
         R2PrqCrnlXtJfYKmbB8EzTnKQGFEF6h+qn4gaV/v/aFJORXpIpdqsa9DK9x6iyuOsjek
         AlWD2puVLhd3++EsA12kOKnx1ommiJ7vLK36yx08o4hIlcXbXh3UBg/tYy8fz9JSVo+v
         rYXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789623038; x=1790227838;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NzaNd9dh5gQiSMMbEDA26vNGMF5WFO7Tl8lfuiT6OXc=;
        b=03UvDLVsMVRmHq5JbXrZldpYN0D082lnNAAtoBry3Do2qAO6vnZqst07LM4vx6tehG
         +/ccY9+PDKKTXQe/IkbUdpNPs6qXdqyDQXuis+da9+o6c3SsJod1EC9bvdgpwY4U/Gxk
         BRAYa5J5Ctl4QsS5meu+aJLNA2QzKmN6ruZyKURDSHe+ACJ/6i0P4ORPP6a1+V1K0ZuR
         Pi+Yx5yIGtB6AC5C4QoBosl6KTrz35e5IvBNN7DTauoub3PdoJmCoxEEp23WBH8pDORM
         9oiEcvkxNVUSzFqETbXwML3jEzkJwYOYdjkOylUql+HbdZDrQD4zjlfOJS13rE1pOyH1
         85WQ==
X-Forwarded-Encrypted: i=1; AKwUvByoN33kOP0LnatYHa1L6BVuFVpytRGQgPf3aA/naHZT7exelHM6kn+YSq14sbjIoCILeq3FdlXu7A==@kvack.org
X-Gm-Message-State: AFuF++lDA83dT5wQFr9aCA9CKiHVS+LACz80RNJ92TxC86YFNhDiE4dv
	puj1uqyuF7BqSyXtLfnvOq1s4Atsw+bGrX0Rr6OpMQlI39x/JciV3duK
X-Gm-Gg: AYBFou00fcmAy7CyHI3m164ab57xwCnVrz3DX+HLlVY2cm2jR545G8gnAIXNZB2B87C
	FU6EMpF/l0rxQ1HaUAkLbu68fOppevpIIWwySA0cnX/uxAnoJf2dxs8jlmYHRZH3qemVwTw7Lv+
	86fOF/s87uYep9BuKMm3VtGY7gAtOOP6vtXRhOBRk83rIzCE2LJ4cVegxndl4OSXpUFKCRKiTOB
	uDE9wIgBPxgJgpKKfEVzNRRkqw4UIJrFfz7lZP0PKSmJZjmn28hd7NWsEzeJADugGH/9KI4aqys
	l+MnaGVaHlyOf7UFuC/OHUKo9l/UJ5knbDpZIAcBIGKvCk1+v2WY7k6ZckQs82MEVqdLvNwprLT
	RfGpqXaqb8i3aCaMiZbBACZo1KplfZN3TpueVI/YFjIq+3O3WDSP96CY9cMmX/5+D8Dh6EzJANJ
	UnIkwrbhDIYd6W61lfJQYc5ylhTu3cXGGoa1bvV6/4aSuwNY6OfFdZt1JhydZ1r+o+fHWhYRe6A
	R225v6u7+40qlqTLLPWgRu2eCo=
X-Received: by 2002:a17:90b:3b91:b0:381:6c5:3f63 with SMTP id 98e67ed59e1d1-39e1e2bf7a7mr16057715a91.6.1789623038178;
        Wed, 16 Sep 2026 22:30:38 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e3abada87sm1955836a91.14.2026.09.16.22.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 22:30:37 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
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
	ryan.roberts@arm.com,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v8 08/10] mm/vmalloc: extract vm_shift() to consolidate mapping shift selection
Date: Thu, 17 Sep 2026 13:29:31 +0800
Message-Id: <20260917052933.188679-9-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260917052933.188679-1-jiangwenxiaomi@gmail.com>
References: <20260917052933.188679-1-jiangwenxiaomi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rh5k3k747bumatc7r7n9enasi3tu9qyj
X-Rspam-User: 
X-Rspamd-Queue-Id: 53CB680004
X-Rspamd-Server: rspam03
X-HE-Tag: 1789623039-337606
X-HE-Meta: U2FsdGVkX1/TzKfT0fGFHvplEn1Cf5VqdNosehN9EsgBitxAVvrccHgzsCsoQsN9utH1RDd/G99pOanDhr2PZBQa8iXiROsy+er3nPvsdfFsCv1OubGznVVmypy3tE2JnVCMgDz8GcAy6v+EhfHV/jf5WsCTPIWTHiNyo0L3flM85RV8Nh0GDQQJUWDJsHw1002Gd/uDRcYSbSorDsVmLEo9IY5j71GD4JDhEXyHawiGbM5aqXNGjI7R0+MInIcusgizAsZxeB1XfZCXnfGckR5IDm6/aBOTpMvKgxBBAarDhL+w7nTvxZ2zRtFNGBXcplmq1d9NF3+fsRZj8Z9wCXbqfSkQum2IF5qM/BBei0GVJlULmiDy7DsgtHx/CAwsgaNXxs69++z9MjBjNp0bvASeSLBxyIm+RS8XftTkMAzOCszmSN+hMh6xmN/uPDlhYk3nZqzQelSEWhgZRbWyJmK5mOxsCmCFEtq337DOBOdPo5wFNzsESTiPbU0br1511qc2UjDti6A6S2j7rKQpj+Wp4wjk1nfh9/4V+WL6DZzrjWBrf5KfesLll06gM/WgWc9JD+6qWnlEwpboe+7++kHyiVMg9cB5xLbwpOFy3+M7efiLvMUVzXjmeLAHtcAhwNzm/7/9xjR63wrrqHB79eBX7VN9JsvggP1TNXR/7niksf54Ug5c7f0npMNfk3KG7CAUWERRrx0iJlAwXbUQPECUzmGpmFvLcoBkXYV6wTjh9ZJVlRXkFjn3hMbjdp3oWsakgoBnnBBdhsR98SvoEzaI9N7OIkjgNtV2sjf084G5TpV3fTLSYcyCTM1Z/qEwzlMfAy+GFvaQIwJpG+UpnzUyZWNiOYXD9LkhaMsIM0mvAM4bXC9DE8IaEog9vqaG+cR1Hz3nJilKwNLnnj31tCndGofKf1nrn/3LhdRJMLomwLrodOCdJi9uhUOZS1zsOa5veGNXy8PkfbJBodu
 5ehFXjen
 xBuTeuG306YgYCdtzXdIxmj7G8WcbRAv1sBOsBK+7lesIdJYHXqqgeYYJmIisXZi8e1WpCSTyBtR9ZhxoaJ7uk2cN09JK2f6SB890Y4mhCD0DmZQU89THYp7xlXNvECE6CLGuXdG3D5bxpO1VbVAWW9G2cKT7JVW18AHdqMhOZeqyeh1vmsMxZp2j9Lgiibutu8/HhgoR4W1iidcGwGny/5h1w/0Ubvw7gZxZc4B+tHD9nsZfQMoOKOETJjVFo0NLI3Pfrn2abYJg5/J8PCsVnwN/eV9ja7l12KEcRpxZzjFJnCnJxK3NfRUzN8QyMy7gsMahNcXCohLXKZZz4T6MmllaC/BPAQsa6mjbGCTxyS9QGJfvmimUtIw07byywOg8k85gSu5/uoUbMxx6Mz+dzLDxVgv9y7/7k5Y3QDMaq8GQw7po+cz4nMf8cyZIejM2WVakoT/8zykYat6mTF6CWZPwIJdl8yucTqjm1TZ4HblERIMgD51ikKee7Gbr6eTSjycqb5Pu4aT9ySMIXGxIo3Dyy9WrUziz+z95XeqvdQbGK0YvAi2BZvx6t3MvNRPjypw2lxgklHcbDG8nXBDqHoLOMg1dowJHbJ5/hGzynaBRy9E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wen Jiang <jiangwen6@xiaomi.com>

Extract the vmalloc mapping shift selection from
__vmalloc_node_range_noprof() into vm_shift(), preparing for reuse by the
vmap batching path.

No functional change.

Suggested-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
---
 mm/vmalloc.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index cf1daf931a6f6..ed868afd8194d 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3532,6 +3532,14 @@ void vunmap(const void *addr)
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
@@ -4039,11 +4047,7 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
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


