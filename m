Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D4B0606A323
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 11:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=XOrUqiZ4
Received: by kanga.kvack.org (Postfix)
	id B91BF6B05B3; Sat, 14 Nov 2026 06:26:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B69876B05B4; Sat, 14 Nov 2026 06:26:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A58B26B05B5; Sat, 14 Nov 2026 06:26:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8243E6B05B3
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 06:26:24 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 18F70140393
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:26:24 +0000 (UTC)
X-FDA: 85433496288.08.0785E7E
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id D0CD780007
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:26:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XOrUqiZ4;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794655582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tmdYvPt7kTC8oms8BNF2txsi8vvN5s8/xh5Ms39wPok=;
	b=Pdn7WYMNb19BItk6v5qgJprDkshd1V2rw/nLbuNQTVP6kGpVGxJva7fI9ieU0fN9mhOZMk
	vpoQRgkiVj8I0T7MftMeV/JmC+aumkyPrq10idSdb7urFaQ/Ejs3CV9ORcyjB+YsV87XPJ
	X2l7J40VfhPswPIcwqbw1LaWFmXeauY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794655582;
	b=RkEj1OHiKKH9tmrvxc8ufgUOnzUJnGbYzFwWWYVuv87SbgcscLPQ6f+njjcu5CLYsTFX+A
	/KHGejGs1zdsm+p4sfpwSPl07fX3/IuTaxusBA7NkY3pgYIpLtDiDftC0VA2PodRtJf9vJ
	TeeiS0LEADwqYKvWIZDky3KYs6onH9U=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XOrUqiZ4;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-3720addb068so2985095eec.1
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 03:26:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794655581; x=1795260381; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tmdYvPt7kTC8oms8BNF2txsi8vvN5s8/xh5Ms39wPok=;
        b=XOrUqiZ4JoeTbdpx1TVEvQK2ZHpYkni6fkXNlQFEJwWyVdnGSr8xb9bHBuj/cDiZk+
         oj5hxQuuaADzR0jbDUIR/AVrz562AFmc5rYawLDotQxzZNrhOthYTUyrec7kDXZGUA3N
         FLyb/nK75mNmwCY5i2aw7BABs2wbL8gO7fvWZ+MDgnGQ7SicQlCN0XHAWKGdwle016O/
         GoQB9ZCT5KvmyIfT5Oxkje+rX2GOtl+rkDuWBLQBi923b2hwAA/K7vLRWVAPZ2zPUD4O
         OzEhOcWFWZk3L21odBs8gK/rIzd2u1yaPV7t51xwjMo90wN3ChI0cbIYY+xRjcu09wwv
         uXFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794655581; x=1795260381;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tmdYvPt7kTC8oms8BNF2txsi8vvN5s8/xh5Ms39wPok=;
        b=Toc0/kjocFmdl3tg2SRsqWIxE1dHN4uSOCOkFylKkKHPA1gmVTiL/BSnHVbMWOnpH9
         IWryzhMVXf9PsKLijNMhbD81CV9hSqRn3TkV699cpJqVjgMStVynyf7NL+DiuT30HZTU
         lr3b+CIOYrchgzHgs1EqoDr1exhoKb+hrnrB83hd4HhuvA9O6ZY29pSYWr93RFGgqlXW
         IH+KBs9ayV/bwHqaIFgYZ12alX1SIMd2E0PG72oC4+2BPdvJ81Gwn8cnlEVwdTaWMfGY
         LKYCC7SgcRefXgLpwu6pIc3kmvZgNWvdAkHHuWrhB0Bx/JtdeYtJsRfshY8WwjJOXrto
         EeSw==
X-Forwarded-Encrypted: i=1; AL+hErGMd/HvrG9X9osldOMadg7MQ77CGrNvZRdy2zwr1lTxXFgdcKc/d4SjJCz+Ic9HHSIG2aQX8CJDQg==@kvack.org
X-Gm-Message-State: APuU4Z8CBxmSuP96U3snNVbbJjJRuRan6mW7U5gusmjUFNFF+pntpAp6
	DMfxcd4qi+fqP37jPPeMMp9JnNtw9/lCNx7XPM8Ys+fGuh+1VFQUBv8reEOGPtSYNS8=
X-Gm-Gg: AYBFou2mXO9jNhZN3+BhIPl3HtVw7bMyjoELezAb4dsJafke2Z9AioM8JF/Lx9lxiYB
	0VNBgZIBm2jXz8Sopf5a6OsBa+o8RH6bnRCBtjVT1pCGywYKzg8kQisGCfQQS0lBqUBFWA5bbV+
	3UuFQhCGCujlXAsm0uX/wmTgNkOZifrJWrql1CQsGtQG7XgTPTBM6l2iEQGf0wbgCWGMw5Hx8mm
	cRyGHpjOsz2Gt0aVUOG+S3E5GXZX7y/yhg7k7Rs1bekii0QGUwilTnm2HoIatAObn1MlHJMgS0u
	d5IpG7eqJhqeI4YVm1U/xnzoAOC26aW7Be/zd6li11kMpv/XnmZtLdJOQleJikbUyzu61NCqDU/
	YYgDu+3UpnXgqMEllRhoYCkqLm/hMToObrJZlQJ1ydT6UfxJ3ig7aRN+x5v4GO3E4ecpbdvJNrw
	qLGcoTv18Ik7k3aIhVeKEpfLx+JLdFCy6U/vyOOYh+00q31kw2XpYzd3hlqH/YA27AruI0fJMy0
	yGytwXll8MGqLeP3YSIwH+Q2OSccSJ68W61sf8IRX5UTuZKG84p165UnnSChuL+C20819wmsubk
	25f09G9197fYjaZ5ksyzprg/pFWj4HdFOwlQwpWt9j9O1qd1BqkTUhUfFaw4hkplv67WEwaxZEe
	0pwzNrQ==
X-Received: by 2002:a05:693c:881a:10b0:35c:ba31:6fef with SMTP id 5a478bee46e88-37967cdd3c2mr4870211eec.36.1794655580476;
        Sat, 14 Nov 2026 03:26:20 -0800 (PST)
Received: from G6L4RL2QG9 ([2409:8a00:1832:6900:9d36:3b30:f4a3:7b5f])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-379553316fdsm16190627eec.5.2026.11.14.03.26.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 14 Nov 2026 03:26:19 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Sashiko <sashiko-bot@kernel.org>,
	Jiaqi Yan <jiaqiyan@google.com>,
	"Jose A . Perez de Azpillaga" <azpijr@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 3/3] mm/hugetlb_vmemmap: fix deadlock during PMD split
Date: Sat, 14 Nov 2026 19:25:23 +0800
Message-ID: <20261114112523.75208-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261114112523.75208-1-songmuchun@bytedance.com>
References: <20261114112523.75208-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6ukjecp83739z79nxqrqibobkg3foxp4
X-Rspamd-Queue-Id: D0CD780007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794655581-414028
X-HE-Meta: U2FsdGVkX180q3gE03R4qZeXymzktUzrpDtWf3Ss8bVyOnxEH24I/pNusJ8VJbtOGezbEjYkCWglmHwFEFgunDwHlN4RH9O73sqqn3jsUENI8+qsCbhm9JBVubywqlmCounOeualCIPAInJkg46gvEX/E+4yyFrYyuiOEf9HLVurYNM5CsdcYPeqktqfid5d4Sc2gEnyC0mfCzQdKwj8rVKzB1fuJyw4CZ42prDGeH+bzV6BlUCGpqKRio0fT6B1fN/UoAxWAYcyFY+zyjipuXV8jzIp8XIqFDet6XFLkFEoSStTg1lrGTlwIikOl9pb1uKkt4dbY40i4k6SBWIuRuSLzsYvgikfyno1/oiBzX2lzG56eC9MUjXKlYE1ruEwZxr2LYxA3Y/onKfJAg1xOIHCFTIYc3DypSkJfpPfOWNsNuqi4XB8TZN4bIILJ39G/Wi2HhYtCTA3yl51ieRe1cssIbjqh5zBY2SLN9XOd3m/NIOGGIFtc9RbpZRy7mZcNoaqwXXPh5lmCKca2CuKR98u7SRxOUvFgOOpSY/G7I4ZnYC+cBH2n0Hyy7LKmJW6GPDxIu9lYRBFlBl8VNx4/srE9nFlqOmRti9oEANrhVOGgYq2FlaJGdYVck95QtGQrHsFGMv2XFpRLfvzaXTwJ+YSbj1TWjRgGRdWnFWS3QhQbqPJwodBtNPpSX/yXebmP0FY6DSxmc20/NEcmPzL/OubFQsC2lHxUMS61us+ogD77iaisKryv60eQjWvZPlYTBHyk30Zj8582AT9kIZh2lZmhV2tURf7Tem+A/XbivqFOIEp/myskDAw4VZ2mGiEZSTjteeA2k3Lb8y4AhaHBj/fr2+ergOrq//hipTUPRvfGX1skM5Q6/i6ey4qQqjvfBB5L7OoOZ8pWgb9nq6n3SqzwYqZaWyo2J0cMxvBzSM1e9GSisMak3n3amlsES8+OqyHDCLdgIz1F01wHMV
 BvJ9SMlI
 U0t3bEmngX0OETUwnJRO9yCZmeJTxFb3EDpwmz1FuAIcS0sM6IXVWazwzvFKR7i1YiU8tiyBNGknBiRrM1fYWbC+zsr9WjzFIBKPe8eDg1cDue+IfKfuHCr98/53MTOiUkYHkftvU7YxU+h1FfVmhiJFa9uS0faBaNqOnPq2CgCKpwpLjtBLISRruLhbVcI9TSfb66qMpMfTbJ+VVKkWwENsdRiEvAzMDPb9aW4PmMyKFA4AQyxUaMWzITc30vvoifuditrXt3lHypgiHQpYjoYrJzjOMVGJtcCfB/BdLTt9vYN0G4fV8NFYBig7VAixJWGsD81k/kNT1kx3FVvDxHTxEJ6klIi5zQuz/HG/CsTzJlQEPkxjfBhTimGOu3D/87zoZ5zHTGvXCokIhVssJeIc6+262vBAqanSohfEOAumfkfbbDzwc0L0aAKvppiIJURvKyF2edzaDM1+KfRmohIf5Q16umu3rGs9XaM+7dOuqr9s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

vmemmap_remap_range() currently walks vmemmap page tables under
init_mm.mmap_lock. If the walk reaches a leaf PMD, vmemmap_split_pmd()
allocates a PTE table with GFP_KERNEL and can enter direct reclaim:

hugetlb_vmemmap_optimize_folio()
  vmemmap_remap_range()
    mmap_read_lock(&init_mm)  <-- outer read lock
    ...
      vmemmap_split_pmd()
        pte_alloc_one_kernel(&init_mm)  /* GFP_KERNEL */
          <direct reclaim>
            ttm_pool_shrinker_scan()
              ...
                change_page_attr_set_clr()
                  mmap_read_lock(&init_mm)  <-- self-deadlock

Since commit d5d8b8662e6e ("x86/mm/pat: Acquire init_mm read lock on
attribute changes to avoid UAF"), reclaim through TTM can enter CPA,
which also takes init_mm.mmap_lock. If a writer is pending, the nested
read blocks behind it while the outer read cannot be released, causing a
self-deadlock.

HVO walks vmemmap ranges whose intermediate page tables remain present.
vmemmap_split_pmd() revalidates the PMD under init_mm.page_table_lock
before installing the PTE table. Use the lockless page-table walker so the
allocation no longer runs under init_mm.mmap_lock.

Fixes: d5d8b8662e6e ("x86/mm/pat: Acquire init_mm read lock on attribute changes to avoid UAF")
Cc: stable@vger.kernel.org
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/sashiko-outbox-206969@kernel.org/
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
v3:
- Collect Reviewed-by from Jose A. Perez de Azpillaga
---
 mm/hugetlb_vmemmap.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 6fba3184356c..5852b0a1c479 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -161,10 +161,8 @@ static int vmemmap_remap_range(unsigned long start, unsigned long end,
 
 	VM_BUG_ON(!PAGE_ALIGNED(start | end));
 
-	mmap_read_lock(&init_mm);
-	ret = walk_kernel_page_table_range(start, end, &vmemmap_remap_ops,
-				    NULL, walk);
-	mmap_read_unlock(&init_mm);
+	ret = walk_kernel_page_table_range_lockless(start, end, &vmemmap_remap_ops,
+						    NULL, walk);
 	if (ret)
 		return ret;
 
-- 
2.54.0


