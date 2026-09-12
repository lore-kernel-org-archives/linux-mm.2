Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14335C79FB6
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 03:48:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FBA36B0095; Fri, 11 Sep 2026 23:48:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CC166B0096; Fri, 11 Sep 2026 23:48:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFE636B0098; Fri, 11 Sep 2026 23:48:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C767C6B0095
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 23:48:42 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 257DBC03EB
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 03:48:42 +0000 (UTC)
X-FDA: 85203728484.10.83242ED
Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7741240005
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 03:48:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=QLjk7iCR;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.140 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789184920;
	b=IzNNiqdx/1aXJdxv7hzFmfRFriZ6zSpSyKsVG17uP24aMgAIKlEom7GgYl9YNNy18sTtEr
	ogzzC7fCpAZ5BBodCsGzN3az+ATDRik/bZHC+uQZ4nK0Bxi5imzkCJTAV+2N7mev+URTn6
	m4yqndVpjOGql1chtvZZafz91xrSlLk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=QLjk7iCR;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.140 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789184920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gwin+KqMEV68jY1s8XlWs9NOlkNCNlU9QmB5425skrY=;
	b=G6uTACwKfiKkQ8K1JWJZckTNwsNYe1f0FgTLE/yJrJLgL/LEX2uySDwL6GGZqRWlZ6eTYg
	ba4AYz7OegtQ4vrTP7+FC6qk8kbYcmAZxbyGBd35zLYs1CYyCSf6ESF52rPnj5eabcON68
	lF0oADcZfcYddZPIVy+ad75hlGuoq/s=
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-9104e54b1abso3086186d6.1
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 20:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789184920; x=1789789720; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gwin+KqMEV68jY1s8XlWs9NOlkNCNlU9QmB5425skrY=;
        b=QLjk7iCRgOPBmY7iB05Ao2nyBWY6c4YaoAp5iadG3Qo1D5uR8I0J8/Xpfz+ySbIbo/
         RHo+Sp8eAVoacSOeJ3vz1MYf5Vd/ia5Fg6FNoskIcPMCeT/T2mK01DAtk+4qs4Ev1Hku
         xGP2w8nyt7PvCHknW+jrBy0e+gKRbasIoYVtuyxTsMEB2Kgv6TWxDG3153ja+3aiLyIU
         8p1bytIVqjIc8pzaqt663sx92bgFBjPlEWuiCXjo8CpzOdqm2cq58wIPvHBQwfzQNBYU
         X6S6zJeiAYgf4Ucs6qNI9pRsNDM9SObiyn86UaTNhDXfYFpHFwk9icBfwisGbIjZU6Fn
         ALKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789184920; x=1789789720;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gwin+KqMEV68jY1s8XlWs9NOlkNCNlU9QmB5425skrY=;
        b=kwreK/BNrhqUwOVMAx+j26B/d/yUGFfsxs3m1lxciyNXEjoDGxb71kWeKFstGP06JJ
         jMpjSPELL/9KX4gzfMm1g4SWNHxogJcpY3Pa0UAgv5foguPF3f2dQNMqt12Fm1JfkVCx
         Q0mgA5r6TA9bnPD38Gn9ncQluocQpHzG5Af8t1oUyHQ+N7LsYdZuaC6+cQwEWo0tCinQ
         7XoIEZ7nRFMjsV+fyMXecc3cSG3DqTwKlYtRfkLfFjA/rqUEvmpO5H2BGnqWEHyl5WaM
         5qC9e6AVJ10pGyu8i4G1RfV06PAiceyH7wJyir9lSxShPZkyldSwJjGDX7kpnSymR0Ak
         KIWQ==
X-Gm-Message-State: AFuF++l0kZ26gHUXVY4tRoI55qa4kMO1G2miCw9dW57czXdpy7CdRboZ
	ILRRCDJNKkvvVHJaRW9+HF4uBjoAfLExwEePIv7ecOk3AFOrzc2rT5gwBeS+uvJTYJICQeicaqY
	lpkpd
X-Gm-Gg: AYBFou2WiYeYl2YU00NtfWi3mwgK1MQ7BncFMKXWOyIngHzidaXlyW60iADABOT1yoS
	qDj24NqPYaR/AAbvP0O8LRLUz4JwSdYGcr0cgONb730aW7a2CqzMATaO51WHO5FV68YVBBtu5N1
	RBxGGYP63tzDf52+qn8Vou3tEqpdaGpke1h8O6tEbx46oeB8q3kLqG6JnPpCeVOmfFJgVylmdcz
	Zvk6c7T+zd8Fo3jkQ78Dm9J/4I5j6uj0gkR2Qrkn3LZa4cR2rgN9BPRLkTr70XStbBgZ4noM3Mp
	00sOccKjuLNyno3cG+bGcpTLWe+scFikI4MUEnJ1ANeTnagwytVcd/jrj8L+7C85gq8cgsT2N+X
	fmMcEo+6GiqETwNbyF0Xd6CW3JKDvFMLP1NlL+DwCn1nAEbpFvIjbQ4gc82/C1/O2Uz0dnmdwLJ
	xHp4M4HWZ3tZGSkbkGivHjlRcoC4jL09Z1hTNWttTBdEUN69oGkjhWHgEtAa5tfc6lyYS/9GmgM
	OjczfycVikU82ztd3zo2fwiD/3f05gjIlpZtsTIK6f0NIiiqOXaYJ+g1h/e
X-Received: by 2002:ad4:5ae9:0:b0:910:46e1:7bac with SMTP id 6a1803df08f44-9121dabf7b3mr19465126d6.26.1789184919640;
        Fri, 11 Sep 2026 20:48:39 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f494620sm36252476d6.28.2026.09.11.20.48.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 20:48:39 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	peterx@redhat.com,
	jgg@ziepe.ca,
	sashiko-bot <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v2 2/2] mm/madvise: use vm_normal_folio_pmd() in cold/pageout PMD range
Date: Fri, 11 Sep 2026 23:48:33 -0400
Message-ID: <20260912034833.2952750-3-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912034833.2952750-1-gourry@gourry.net>
References: <20260912034833.2952750-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7741240005
X-Stat-Signature: x7ecf9ibdbbaphkmpd9r1chx773r11wz
X-HE-Tag: 1789184920-933822
X-HE-Meta: U2FsdGVkX1+uESYt0NtVZfClAacFFMdRs+/8OwFVWXmXJRTS1eliFnSVYbH09sNL4aFwhfh4XGdu65YGhDOeke9s3kBDZkM4HB/7C42awBMCZ8PkzClBeee6YlW3ffvpcJq9CgisiVxCPFK/emdct3vMDvmWJYzw3P2fI+xatU4b2HMLI7jB3wG/G0VUr28+hoyGajwYin86blFcZbb/lXD8AD/kscl4KgwPxWVQNB8gQ8IWTneGKyT5A5NJWELxD/yhnKOjGpeMM7eQ2nJ/Uz+J8xI9Gw6kK3rVb1ofwC2C9Aqk/bOTtbNA9TwDrI5R/E/rCR+xEXRB4OPiuAFOh/1ap39+LGmDu4RBe1W7namIqXFASJjCS55yvKPithq9V3JpFnSTVhLCPxreU2EDyCjNs5ZhLjp04cVWMedlXpEqn1u7E8tMGouRn+Of8pBUoA5157O8M+Z2OJm1YKFPY0ASGscz0+aESKAJNa2D+WWyEVp9p8k7NoA3ZHQn7+ipyHejYdWvumAXVGjitenWI+g7TOCTKM54WZEEbnbqHt3wHxOJJCx8v2JS5XImnoml2qqQl9psxbQ2UDN5f1Im0K4QakeOABPHEjlA+JlPdGuVq6TSTylRlbXd8eS0UqsJESbVdpA6d2iyJ7Wu8GPcez7rCTfoXbkgs44X9Cbrg2WPaBQzEVXkFSBLmqOxNCApOlq0nmRe/M2FJyy8jJyfVXF6txXmPJN7TFszXjFT4k4/F4Tx4CrP5j48jScseuyznYQjYskGtzmKxGDdVvwTHIIZiETNIbiIymiiW0uWxoqvJaLWPYCgkiYYGdbYUEsx4zst32c+BcPOPsACjydyWvQ6M8O4sw5qu1emYgFKylvH8j+LOYScVdPN4cWNNkLH750gFMHx865WsVykIFXgTznSVeNmd3Mt9wPXdKWKkkh7QPjoV8N9eDztwpYvomlN+k8QcCVlKxqqKb4hsj9
 rkUo7yEp
 josRfDpVvolFaOG2/svYhqEc/tPu6Bwz6SDjFCoJ2XEcbHvQpuxcK1ZICFlvzSbX3kC93O+Kfs64wWdOkEo8Pl+L4s6EXQFomB+DGP3lLzqfk+0ZhWF0XPD/5Al4DKI+Vt2E5tMWvUs6ln8JrBs8opZwl+wmusmCo5r4iBglavmNddcaWgdz9f3gkPlTGd7lmsk3bstsoHgAK47mdGYvWzw6uDLSyUyLHgaCgkygAn47ugiMlrH7YqPqxAHNDO8qSur1XxKAf93MRH6Ifi/IuaAqaisMLBnXNIHyA4UBVAuLzQlf6pHbP8AL0/2mwFJZQNhrpMKYlOMOnJRTH320T8N08ETTvytBEN4jUamuvLy2IhKuUsDoSNvroHw+7AEDC84+k2KKvo3WKikSb8vezgUPm2ZyLWu8wxkmyQDVa/ZRqDcv+It5xpy1qXjeO0Mndx9bspS71c5h30h7qmWpLd3bLJwrji+zVuYAzhreZp46TOfF8ZErvB+xzxU9nq5Vz3KZ+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mmap a VM_MIXEDMAP region whose ->huge_fault installs a PMD through
vmf_insert_pfn_pmd() - mshv_vtl_low does this, and needs CAP_SYS_ADMIN
to open - then:

  madvise(p, PMD_SIZE, MADV_PAGEOUT);

With a stand-in module for the driver:

  BUG: unable to handle page fault for address: fffff587c0000008
  RIP: 0010:madvise_cold_or_pageout_pte_range+0x410/0x9b0
   walk_pgd_range+0x52b/0xaf0
   __walk_page_range+0x6a/0x1d0
   walk_page_range_vma_unsafe+0x8e/0x120
   madvise_pageout+0xb2/0x180
   madvise_vma_behavior+0x46b/0xa90
   do_madvise+0x108/0x190
   __x64_sys_madvise+0x26/0x30

Nothing validates the pfn on the way in:

  can_madv_lru_vma()     rejects VM_PFNMAP, but not VM_MIXEDMAP
  can_fault()            *pfn = vmf->pgoff & ~(mask >> PAGE_SHIFT);
  vmf_insert_pfn_pmd()   no pfn_valid() check
  pmd_folio()            pfn_to_page() -> unpopulated vmemmap

Even with a valid pfn the path is wrong.  The mapping carries no rmap, so
folio_maybe_mapped_shared() sees mapcount 0, and the walker goes on to
folio_deactivate(), or folio_isolate_lru() plus reclaim_pages(), against a
folio this mapping does not own.

Use vm_normal_folio_pmd() and skip on NULL, as the PTE half of this same
walker already does with vm_normal_folio().  This also filters the huge
zero PMD, so its separate check is no longer needed.

Fixes: 3c8e44c9b369 ("mm: mark special bits for huge pfn mappings when inject")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260817220810.1175596-1-gourry%40gourry.net
Cc: stable@vger.kernel.org # v6.19+
Assisted-by: LLM
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/madvise.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index f75a9d139980..fbb72ab49aa6 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -395,16 +395,15 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 			return 0;
 
 		orig_pmd = *pmd;
-		if (is_huge_zero_pmd(orig_pmd))
-			goto huge_unlock;
-
 		if (unlikely(!pmd_present(orig_pmd))) {
 			VM_WARN_ON_ONCE(!pmd_is_migration_entry(orig_pmd) &&
 					!pmd_is_device_private_entry(orig_pmd));
 			goto huge_unlock;
 		}
 
-		folio = pmd_folio(orig_pmd);
+		folio = vm_normal_folio_pmd(vma, addr, orig_pmd);
+		if (!folio)
+			goto huge_unlock;
 
 		if (folio_is_zone_device(folio))
 			goto huge_unlock;
-- 
2.55.0


