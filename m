Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6986ACD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 08:49:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D605C6B02D9; Mon,  1 Jun 2026 04:49:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D380E6B02DB; Mon,  1 Jun 2026 04:49:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4D8F6B02DC; Mon,  1 Jun 2026 04:49:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B0CE66B02D9
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 04:49:17 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5F781161F9B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:49:17 +0000 (UTC)
X-FDA: 84830719554.08.083768B
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8424540006
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:49:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ZP+Rrk0i;
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780303755; a=rsa-sha256;
	cv=none;
	b=268QXnNTjP8jXSnGCcQ7lpcUywUqrNWED6Nbb33gLxXTmFj0TLEDw51QEbBruve3YCekR9
	6QfVCWpnsMidIp3t7NxkEgeQVI5UmEHHP3zOBwzg6tKTS4cYiXKTimD02G29zLxhFf2ZGb
	61ifWqdOG9eSwd4eX4WIWOUtm7lVQLY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ZP+Rrk0i;
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780303755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q8b/yYnv8ZH41kctmwMZLOttDvAzW7LNe3UEG0HH1sI=;
	b=K9bvg4Jdt3oUyr8rkWxrRDgGbiyI7NgvHt8V9iWuXndTpMz6BOkpw3z5eCRVf9ujcpGV22
	vH5f7+rjBkVWh6J9zHRRs9ol+sWLMZJJSqy0J331ar9y9bfJZZIm9m2iqC/zbTcL+vlhjh
	Y7QqrwRm2w4+rjbMDsFM4WyiKYYJNhQ=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-36b903567fdso3534815a91.1
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 01:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1780303754; x=1780908554; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q8b/yYnv8ZH41kctmwMZLOttDvAzW7LNe3UEG0HH1sI=;
        b=ZP+Rrk0iGeIpmsvXGw7WQio0RROBJhvYqM6YV6qSmQ5NWUR5jTCLbs7kRulfChmXbJ
         P5NNhptoTFlsRuPwZZCdoF9irYuu8fNaGh96QKgT6fvH4jigFLGx4oELoYvg1ZbiRI5k
         L7r037bFpuRqwCeRDu2LmAxNRId44e17prwJDEqRtV0FkpMm5fnr2oeQZZCYcJ147uy8
         iwgqc+WoUNEfeTCnTBZmCSw4z46C8V5i6h8aQwWHOt1luYAExSx+Q+Cmco+016NCPEGC
         J3VcYzet9M4XlT2EyaSJ1/KRJIir44Gn9nclES/tdYjxO2APBTTFESm4HDbMzack2sYg
         AMSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780303754; x=1780908554;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=q8b/yYnv8ZH41kctmwMZLOttDvAzW7LNe3UEG0HH1sI=;
        b=Vcrb3B+wl+VqtUXfZO+r7ftGuW8NG2LAT2dDDLaCXKwuCT20aAvc5T7x6rXEK3/Lqh
         eXDvndMHBl+zs61T9mcdcI5Ap0Oic0Kyxgmoo9V1R5lb9ec4kZi4i0KWjQEtp3+IJ75A
         Ny5Ki7F8Y7XEosEFItT75Vch1TUZ3ufEjpK2CE5WlLVyYsZo68kXNOiMo37+DHO8Edcf
         mNvF0uEaJlAfrCNuvpGpU2feOpuFKF53b9yk2HXciWIvHfhEsWP0jAurnAqTCLPzehBG
         he9G0FmkxckVi+i9uILlTAN+ScVmYkBvM09cjh/o+mk5o3FkOojTPsHrpUnnGKFeENSW
         tzMA==
X-Forwarded-Encrypted: i=1; AFNElJ9pv1cmVMA3wkspP4augxStm1n8GDsdXKFbJd0MWmVZasFUvn5sadj36hns2n4r/m8Cys/r7wzQUg==@kvack.org
X-Gm-Message-State: AOJu0YxhiMCM9ud0vI7ttTSs80N0Gp5aLueYQhZpIuPTslGWdD5v/jRH
	JS51wSyGpgZNpuaEfzL4vwgwlo1bcK13vPqH44qJDuORuFB7T82MP7MFPLGhj0RvqXQ=
X-Gm-Gg: Acq92OHeOJuGdEYn5OluBHj3dYEATFQARLdDrWMG06Juzgh97hHk8b1KsqmRYot+nLE
	CycUDe7ZdW+LYnuWzVJqnDhGuYmRqJFy8knDJYs3KX7dvM0G64hZ/68co2CwwYtsdllyEZuGzc4
	jq1tSlF3KaCYUC8Xf89i3pZYqpSdsCiw8lIpXF0VoyieSyJZ337NeJYjmyrOqGJBU7Lf5OcKELV
	HeHrtCRonPAngNjD3SHLz0gr8qIue9wF8mNgvfA81TIC62Ln7QFEcRLCKF0i+lzceAYEcYlj0bE
	t0q29nzRwzOUFMkcxNgFlrrm1RsZnCukpbRcZSkPjkZmz2cVYjleBJjifT0sR6bs/l6mPbbpDM3
	gVy8u4u+KAmUqx7/UfOgaL98U6FQvseGKJbdjNcGDon3X+Ho65RA6aAoEz0dUslgwI1uPk1D8Yn
	OnK2rzoaXL16DYzybDKo06zbO+aBy6C3c/c47HUKfNRf6WznisK4cDjQ==
X-Received: by 2002:a05:6a21:8ccb:b0:38b:eadd:449a with SMTP id adf61e73a8af0-3b428242975mr12005378637.38.1780303754272;
        Mon, 01 Jun 2026 01:49:14 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.96])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84232ef8172sm6316230b3a.12.2026.06.01.01.49.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 01:49:13 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	Andreas Larsson <andreas@gaisler.com>,
	"David S. Miller" <davem@davemloft.net>
Cc: Muchun Song <muchun.song@linux.dev>,
	Muchun Song <songmuchun@bytedance.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	loongarch@lists.linux.dev,
	sparclinux@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	WANG Xuerui <kernel@xen0n.name>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v3 3/5] riscv/mm: drop vmemmap_pmd helpers and use generic code
Date: Mon,  1 Jun 2026 16:48:42 +0800
Message-ID: <20260601084845.3792171-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260601084845.3792171-1-songmuchun@bytedance.com>
References: <20260601084845.3792171-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8424540006
X-Stat-Signature: 3gttk1s43hmzu9uzoneuq556xpw5oxwm
X-HE-Tag: 1780303755-545227
X-HE-Meta: U2FsdGVkX1+D8AD6FJ1DDzuiYSQUuamidtkNOiLVioCRdmuxO8WJNxgUKTEvK7gA54Fp11LqgYRWK9MUPEc8LzBUQonVbeQxAGcr7tQ6tfBIRufb8n6J3upj+QQCUyZvh25lm/R1rMT6w002y9IPZrMbbdWZYzwV3wcTm1HHxSXalUKTl6Rx7hD7mywGGFXVMrHx8VOMCe4Dr0vcX4cYB2grn/8Xk0LsujIBwwoSZEr4xeuTJI621Tn+pRW9DLu0cGtwkY9NIZmSJWyYAhsVlWY/Q8n/JICuGDxf82D+BSo+iB/kAu2eQy2/1MnpLwmLSytXSbUmxIPga+b+PS9B/eGSSKpSV7cpQYh+6TA2M64LBUMr1k3tqgKezpEJ8Jvrl0X9stWaWWqldgHTBqxVC0mVtQyDbaIIas3uLaDGJVjHRE7CknlTkhS3a6sQjZTY0V7H87UnjCNQdx3Kn/+5nOARlKgqYaNq8uieeBLfTzyrYXqDx6B9FP9an7K2Fc7giphG7eqXX63EeBq4F2VvYbIBRWAxn6bjTTzhj9WO+4fE2dVUGDdb7bju/ghCEIQHqNo11cjKGbkU640T0LRN85H25LDsc+Q2PLynOpZ85Uf1m534iE9od7C7COqT3ZqQimuaeIHY6wZy6ZYgSqo51Pac4twZ/lqSow/rtx6jWLIosFVUl2HiHOw8Q3w7wvQt7yakZqROd/XRFQusDUV56gFeTeLWh9ECcV5l4P28Gup2tqrOGh1GpMiXHIbmX+uGlWi8c7UDRRdx83pTDji/AI9r2RKhAhtgIIlrz06Ol6BpQDuFNsJR1oSAfjYexL1dJ6iaSOtySvSzObsX3F2pmxM/wYov4lVIuVZiokDBLXow4MYbIfYXI+ZsZkqOtXUUsXk5nbRwJR0c4mTkYCh/Ob7F3/9ciPGvTYMZKFn7aVUsFaw1hLqtCn4zr1/t3sh/vRIPkI/7SJppT2bpNfy
 SVG2EIci
 jAaveKDPiYbAT4XgUG+1k14sx8HwGd9P27bdYQ5Du3nl4gq1TEBn67qsLaLUPFvzrQfsT5sStvxP5l+tPniNiMvJUeIa/ZaWd9L5HEt8ZIE9nYkYiBx6C1Uxhx5uaocjaMhq0ublbLzAbXH+W1jkupv7iaSjk8GUvNPoKs9pyPqfjQY2d4+fiBb1QCKnF26AAUyozgG0fqM5kotyR/N0V0MnO0yxw+Br8bdlEgicbV96/R5UcvYcLSbcK5OBDOVevWf1MPmK65fEIbLOmLS8NhPEpk/VQ4XRFQ/31YCrDgJRCB134vUY8R8bIuK2dNZxlTN31jyOu7XrA6IAaJtuwgEORudi0koDFeWEWKMpmXogjLA4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The generic implementations now suffice; remove the riscv copies.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/riscv/mm/init.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 885f1db4e9bf..5f680eb83e86 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -1359,19 +1359,6 @@ void __init misc_mem_init(void)
 }
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-void __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
-			       unsigned long addr, unsigned long next)
-{
-	pmd_set_huge(pmd, virt_to_phys(p), PAGE_KERNEL);
-}
-
-int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
-				unsigned long addr, unsigned long next)
-{
-	vmemmap_verify((pte_t *)pmdp, node, addr, next);
-	return 1;
-}
-
 int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 			       struct vmem_altmap *altmap)
 {
-- 
2.54.0


