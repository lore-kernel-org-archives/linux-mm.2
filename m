Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ADC0C982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 00:25:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1387D6B00AA; Fri, 18 Sep 2026 20:25:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 110586B00AC; Fri, 18 Sep 2026 20:25:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 000126B00AA; Fri, 18 Sep 2026 20:25:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C24DB6B00AA
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:25:01 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0252380165
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:25:00 +0000 (UTC)
X-FDA: 85228616802.08.98DD123
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf27.hostedemail.com (Postfix) with ESMTP id 150AC40008
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:24:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="l ZfXBWc";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=IHTDTava;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789777499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fo76vmrg4cxg21gPYqwdjCzZp7TsVtRf/8vWWUFNPFg=;
	b=kYWE9OYEd7emIsm5CvHrpfEslLjXk/yvtYe2IriQxq66sCiyxGPy7t7y6FRkmXr+tSufa+
	Y8ifWiMPXnbF1GNzgKZfPHmCRyCOu9SyeIvNumk24G9yY4hE7myC9Zx99mDRQHh3QPJ9Un
	cNHpFIAbXNTT6LBP4L9McvIOgnBrGkM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="l ZfXBWc";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=IHTDTava;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789777499;
	b=wMhYkXFoJIfObj1Fk6flhzaGhyGpSC2MMz0mTNxTGYRUj5dCJjqNyYntmQYo4wSUFkAqPa
	ejOlAjgSXxYdx3K5mZ3J5AMuZ981XM1OI1YlwJaBx3J1qAdgZIZ1cU8sFD2cPRTfsxeFwI
	MMSoa1YsRxs9UNM3VGZrSTifYvdj3k0=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id 97EBDEC0232;
	Fri, 18 Sep 2026 20:24:58 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Fri, 18 Sep 2026 20:24:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789777498; x=
	1789863898; bh=fo76vmrg4cxg21gPYqwdjCzZp7TsVtRf/8vWWUFNPFg=; b=l
	ZfXBWccAMPvC2qPAVaDlQt61nq4HN5Mi+I1M7G/Z2tn6MtTbiFgBMQHYHR4G9s30
	CtOOINuX5S7jlro7UluFW4YKuJ9d8cYKyAmpVuA210EZJtzuQR7lVwj+/vTcdgJM
	KR1ZZ7RZtBWenbuH31MqD3KdR21ueuxa607ewZHy4CYFfjXzN+qLivxZ/QViAVVn
	p4Paq4bRz7m8HvIiCPucvHZokWkkdnqe/h5tA5AQHRIPYAiqmDV46r+s6IomGu7n
	LyiQrJYJWWm8QXi/wQEvhPMeJiYljifHqVqZMbrOceBU2JeMJPpQrOL6sci//YS2
	DlwfU4AWrK4V41eFjYpKA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1789777498; x=1789863898; bh=f
	o76vmrg4cxg21gPYqwdjCzZp7TsVtRf/8vWWUFNPFg=; b=IHTDTavaN5BPAZjn1
	nb+tf234GGchB6TRqEPGjvis35+hOPoUM+4LWLkdoowMOz/jO+k0inhVLYK+gNAA
	VAw933NoRZRtDaBp2T523sVEXRl1UXexl5kSiZ3fUHopmJ4t3tj5KDE0tmuMReqV
	rYTRDnsaN7bl5YRf8QX++g61Gcvf9muh4JGdVFlArC7HlptqSeox25nV2WDRONnL
	tZ0cWkEoADbEHkSHh6q5jx3Twc4pPFk6XfIn+IGe3O3DXliC/aSkYmvWDH7WJ6lD
	yDsqoSZdP3wim9Su1ISNuEMT/grXnOzFsqnH1ktqkowJO7ReQE5MYQ2B9tpGT2YA
	tSQ8Q==
X-ME-Sender: <xms:WtatatVLcZb_hp68bSouFJZzNXp4zjXUFd5I6MX2_mfxVRrXkANLBA>
    <xme:Wtatavf_fqGUHfc_gyBsg0XjX-RKUAtGUCRZVhTpNewPGZYkgMOqBZik9RpH2FVYb
    vxUTlaAKEAsFIB0l-A2IB6VZmg0_rsZ6PvDmNwJwqD5wS3t73jIsGYG>
X-ME-Received: <xmr:WtataugXHfj5jwK0oZcOehVZ-j8qwX7YY0NRkI9lcPCmVf2OgaFueD8gtZk>
X-ME-Proxy-Cause: dmFkZTFyC+XeKYnZ766rqTYe4SsoatN0doBd7ADemiperjFlmE10ggdkgYpZeWmNOU4aBc
    lm02WEvCO2QGG+A0SGXMzCjVWjDSVCQ5WJ/xmSMbLZJLqVjt5aEnrGd0hUbHPJ/ejcqjFa
    xrmYY/YNxh9EpvRrTjNMqslNp6oZ1XKAjj0b9YUD/U+Umt4HJhNRFStrIx7jR3Gf+CAD8k
    /TwEvtSve0+WgA7utVqBt9LeXDUSIUkf7dn/1M9JWIyORT8Kp2cNKrwYutOzK/Z35sBm5S
    qWNICJAq9yYROUOkEgx1cQSYtjkPP2DMZwKGXS3JxTiE+xMdBmJUepOSBHs3/DvnVTIMLH
    oHJ9HNYzZnkDKS1K8Ngn6glJpoAJiwfFQtmosaAwPr6HHW/c5Fs/OG20UCk7mR1J+pkJlt
    RJvl2gFpnHl+J/iUvVWt0Fwg1nnmp9OaBTY0l/8mmUua7WuweLrx8GwjSYkt4okpW3tY9b
    BobACyLC13eAvQ+mg5RgfIzwrZSti6H6tBBjbY4ZQW6YVQ3l51oFC8HYKSs1DoGQ1TmQEJ
    ACZM5pYsUyMyLiJm0afVVT/drw7VcjvG+rTG+u33CLRAqrZcWc/nOhkDgTh1CKBGJbX7fn
    91pfQ0e8zUkmgSxWeGxapdWCLKbWjVD/eBmS87HwLAmUIe6GxE+zUZQqxMyQ
X-ME-Proxy: <xmx:WtataggHj0uP_6TybkYXdxuTxyPsf53B4O0Quh53UoBON-9xdma0bg>
    <xmx:WtataqqNplvjuPgQuQrqjH_6dIx9QVzK--GorgmUjCnQ2x4l4svtYA>
    <xmx:Wtatamy32lEPJdAQ6YjwzgQnHs5uAE-B5ihkjWc14B7mcCqo85dMCA>
    <xmx:Wtatapx4ctLTNTpegUqdpuiEktBaGroOnRCoR0Daf94lCA97NoKN5Q>
    <xmx:WtatanpvIbw3Y1zyGvGxPN7WtLdsRQVbALwIUoIH2mDrrpzTx5yvuLGu>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 18 Sep 2026 20:24:57 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Usama Arif <usama.arif@linux.dev>,
	"Nico Pache (Red Hat)" <nico.pache@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	kernel-team@meta.com
Subject: [PATCH v6 01/19] selftests/mm: raise the khugepaged test-case cap
Date: Sat, 19 Sep 2026 01:24:31 +0100
Message-ID: <20260919002451.496763-2-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260919002451.496763-1-kirill@shutemov.name>
References: <20260919002451.496763-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 150AC40008
X-Stat-Signature: pgmw3apuosfac8hco15ndbpun1binxbc
X-Rspam-User: 
X-HE-Tag: 1789777498-212745
X-HE-Meta: U2FsdGVkX1+l2DzVtPWyEdMgm1xmUMlLarojlmAJyP2g+l4Q/rHbXtU8C94X7hZoVc6A372unh/roqJ3t7rvkTSfJ/I7emKnLxRHAf2r+LU+8pEgtWMjBfOhy2Rk/XlunNCXGNy5GdYuR+1BN+8YJFXP29RE/ir2JIB/XeKK4ePXpBSWCybO7oPNTtZl9/y7LWHRYadQnvL6eLT+Czy9aOmEIclkTcIeq0a6Hb/ipDn8wOWkAdyH4M5KLUWz7A5Mba6/8aztkdgVdMgYfn7Q/WeKVBPh/x937MTw2UUfylggI2j+d0TEHRB7k5U0tX4JyNZcIdQoiYgtb/ra8xM7/rLM87esMwHILyGF/JvjN8YiCDde+8QEAwYXRKFb4osMIY1A6ryjbIh38YvUCLqpJLLZRmM3NB7Fn/VPHoF1nmK/WVUNBA73tesY7rTdnzGlI7oJsXeerRfubP+IyRqqQSGfKtnOKNREu3l1omVkLYH6SVzKsZX2M9e9YLa3g4zf1+ZrJRuJitoIbznR+pE53kHHJatusIydHKdhZ6es39nRboXAhFDqpbQI+p6hPl5NEawAmsEwuBRkh0cW62YouLXqeMvrU1FEDUPVKAVffj0ZDxo2Em46Hu/taSAOaQiIJ10W5bSQKrNTvNJdIiSE1yFWR2dPrJYYVk7vfkTpVe640Yxbm6NnZZpRjN/G9tItgxOCnl2sN0z5BvhfDxXfnCaL1Ik2KAMvfVQ4Lw92H02kswePKG9Hm9+/XL/N4nFU4eabRYdptviVyvs9/BVsxgF7mpVMJv29bDJ6O7aTsx6roo/V6+IHgEVMiwi6gGkpge6Z0c13X7uItfWkEL0RGFK04HbRSqAdO2/Qa9XfN37sq9vg303kxu3b5QcelGpHQD19jexi/Ah/mzIkX5Csqa8aH6wab07xE8xDg12xzeUvyjAEpdCGD75+Rm1smdJdrTaHES9UzndEtEYQZD6
 7hM9s+6O
 jMBvIXLicI7gyZ51E46hzeCQ2KuZrFX5AGpPPU0hUhhZKKCHkKPCCHcy+SOo6G6RR2a1uZI8tEMplZtMhAnj9bykv5dGxq8E20uI7XMNLStU+aI9x4qEyfP/eyhv92pHBQppNAch7EKW8A6c8/PbRqj6rJog71Ckogxq3mfmAe5TobtV/YQs5QLGDgwRsXgcu8miAeADRUKtoaoPBMkujqDhVSO98rF/HBEE3/M6VkxEwF5ndhkwFfV42bXReT8hEjxyricADyU+vZVRDkL33PDUsXl9xIcSEOirRT2ym8HRyAJegfDAdyVOAIdxUDpcwfZEQ7jJ1B0CpNHAWqiqttB24z59gpQpvB7lgFBMK+gzuhVP0UJgzUZspSXyv3gmAD5CgY88RPvbx9GJH8+tXtdK7Gif02SevSCO0/lDgNuJW462Jncp+YJss7DmDZrgjACzxfEcvtpVkea21lp+MNKAbycCmZbzpFQnC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

TEST() ends the run with "MAX_TEST_CASES is too small" when the table
fills, and the table holds 64.  A full invocation already registers 63, so
the next case added anywhere aborts the whole suite before a single test
runs.

Raise the cap to 256.  The table is a static array of small structs, so the
room costs nothing worth counting.

Assisted-by: LLM
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 525108cace54..c44bc18f7536 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1290,7 +1290,7 @@ struct test_case {
 	test_fn fn;
 };
 
-#define MAX_TEST_CASES 64
+#define MAX_TEST_CASES 256
 static struct test_case test_cases[MAX_TEST_CASES];
 static int nr_test_cases;
 
-- 
2.54.0


