Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 489A3606A31A
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 03:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=Rq2760n8
Received: by kanga.kvack.org (Postfix)
	id 0CB9B6B05B0; Sat,  7 Nov 2026 22:01:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07C756B05B1; Sat,  7 Nov 2026 22:01:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EACF26B05B3; Sat,  7 Nov 2026 22:01:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC9E76B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:01:03 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 370F94045D
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 03:00:58 +0000 (UTC)
X-FDA: 85410449796.24.EC0E93F
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf29.hostedemail.com (Postfix) with ESMTP id 46E0B120006
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 03:00:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=Rq2760n8;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf29.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.51 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794106856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=oV9FUG6VESiIfJwch77l0Tjfsp36eT+2bRCqqkXn6FY=;
	b=K5fwt9ca7jCpUaxayYC56TA3u+n3JXq0hCN1ggQ9izkpiTtvH+COB+WUOz9x90DC6Gl5ao
	5BUK3dRk9UVFvR8XrCoBpH9NLoHF/MD0DBq3Soflys6Vm97R5jq8RFT6Sw3jPJ462NQoxn
	aOiQ2IwaG3d06vDHwmx86awbaS0EvAk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=Rq2760n8;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf29.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.51 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794106856;
	b=my94a/Ww11uRFgZpd1lSc5HIDtw1eDDVJr1WNsqp6cZLY5kMprNuOz/epIO0jWZqCpT4fz
	74Wjb7sxyOYlejF53Rm4PS7CWl0MaBIKJS01AFDOJ7ji2F1AvcLShhMioJuZZbCkomc86n
	T+43PolVkpaIPzzT/iho7IKNtVyOMkc=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3ad41b47541so96943a91.1
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 19:00:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794106855; x=1794711655; darn=kvack.org;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oV9FUG6VESiIfJwch77l0Tjfsp36eT+2bRCqqkXn6FY=;
        b=Rq2760n82elyvODOgH79QLjMQnKTFd0xVmVWRVMwLX/53ZDynlu5ml3Rph05auQ0h9
         n7hqFsMFVKBnbAr+8abwIvlaQXTP7038p876MTT77Jk+hbKAzGnmKEme3X4894KODjky
         g6Ki7yMM1dib6t5n9JiE+5VNGTQZulUgf0KCw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794106855; x=1794711655;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=oV9FUG6VESiIfJwch77l0Tjfsp36eT+2bRCqqkXn6FY=;
        b=U2FDCpF+iguXOljNL1qTv5UDp1DX5WbYw3k4Uc35lMdPc4Ml9akxpE4oIwvgpOF01L
         5KVfnuH73Co0d3j6HVn/lro2oH7GSdugc6H77/+dpUypZUN/LUI9LzOHY4HYPspKdEh/
         Dw80bMPawqlOq8ZmnOGpRcHlJuqRRY5IIteflXzpQtWHf8EweONb46N5AuTVbFiumzYM
         8uXUBM09fu+UHm/wOzWyexpxP8DcLeuuTjVePCTs1AFKFgyuytd7tgMtjVlOji1JDCO6
         vPMhiRTrUxanN9XfYySpzpcjdNJX1foTMP6QVO03ZokmwHO2Db/fWDRWNHKNMNQF4SND
         c2xA==
X-Forwarded-Encrypted: i=1; AL+hErG6pLzQ00EQRiYctVXDGP1jsRKSonDGmg453aLKi1+Hw0KtXqp2byksMSKRx9/rO+xgV/601Yaelg==@kvack.org
X-Gm-Message-State: APuU4Z+vVu08tFbZ2hfyrDETZO/P5Cnu6QNcLrV+04ASvizl0LP3BybG
	D2GLXPMQiQBqFvO2XxFwhJcrjL0n5VGKYuzQggS22oDg3H0beymZkEXmB1JSYO6pvgs=
X-Gm-Gg: AYBFou16GId2+zISCDjoQVm2fAogydl8dt3EAZLos2vzjtEJI5AjDTOfAV1aDAE4BJv
	GRhOjj9bpSVxemrN230hpHgUOsKErD44M7aEHXLol0L17N3ho83PEyiHJsrDSTvTomCQEsJN2C6
	H4kEbSWwIxDT3aZqMBA2lK3wuP/Nk0wl5QSGs+A3XMjtdQutYHMlfJUuW70RVR1C8rjyp1raz0O
	47JGdj2Xi8xx39IXhgNSfj/Pz8KS8OdqrAPH3utdpUU2c39xY2voNmqK36z/dbJmbfCciCK3N7Q
	RFXUJTn9YxsXm4XZlvOyt4g1A+Zv5fbKGt94X7ag/eIIJiBe6ViKlunIZyeCWLfguW4valKUsv+
	q/XRv11H4CihtMHWJqya1KjlSrqUHn1+z1q4KkJy+EH+gHNFGL/CVGpTuIlAkw34yXgg4nXapDh
	IIWRrIvdvDMpn5KNzhdfj5iTWe/xlscgFXF/N3l+S+7y2HZoS485/WI9hnhZDOiuOYA+8yjlupE
	ET7mds94FFPXjaevnNTd+FhOOzfFh0I4qe9Q+XMj3Mas3Mj/JiTcPloDJ/sHhWubHP2qdmDGHcH
	ztz7LoAOEruR1412CVskBvgyNyoFvOpRWOUUlDcln1bHcKFD4+73r0+AsSVJ9ZDO0yTimYuvmwa
	TQuj4qHGfbC+WGu+MwlrGc1JV6PWjhcEBdGufzllxW5NQ3UOyD8uYJabuGbf+Wlqd1nwEYl0Gb1
	6bYXctoStZpz6+PXPyAYhbtWrI2wS8fFIWS58pe3g3p5+itnWeKRCS
X-Received: by 2002:a17:90b:39c4:b0:3ab:e588:c29b with SMTP id 98e67ed59e1d1-3b12d0f9293mr422730a91.5.1794106854935;
        Sat, 07 Nov 2026 19:00:54 -0800 (PST)
Received: from localhost ([50.175.87.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b127891fa4sm1216393a91.4.2026.11.07.19.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 19:00:54 -0800 (PST)
Date: Sat, 7 Nov 2026 19:00:52 -0800
From: Chris Down <chris@chrisdown.name>
To: Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lance Yang <lance.yang@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH] x86/mm: Tear down the direct map when memory hot add fails
Message-ID: <au_l5MRyDbYfsUVe@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 46E0B120006
X-Stat-Signature: upwt7kzbhk4zw7zcxepz9pkz1af9xwuq
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794106856-837950
X-HE-Meta: U2FsdGVkX1/5S3mtRj8nYbUv1YeWr9VjYtOj2D7ZYa0ysSJDihgE8x44XLJU441MuNsFjwO8nM3oulCG+/x9KKi9hRQAIzXuNqJsdxojCB1FsjRykmADH4Nq6sSthk/JIsNh8kJr8b9H1XuXPqE41pOKiZ+MAQi5etjgdgfBdcAt7zT3mUKEjj9pnJ2O5jGuXyt+KAoxzE+01zFJQB7kPPRNH0Tf4UABKxV1rCQmV+yF9/y9IeBQaEYPPD4xojj65OMRnx12yWJ+jhFb7JKU9u9943yve6lEm89EnyMGYdphEdMT9PDMHIynUCr8aNJ19Rkat4nwEQQ6752InuUYxWqsbVXVCwTTc6g3aKBlMILHDoT0/Td2rqUY5bhgUKOdBjbgAs9cjJG2GJtp0efnb60ZVGOPfo7sAkx6EGZF0cXAQ48ucp6GJJoNzrai+eGEp/tbjwTeDDyd2GuZKKK5MVWdtwgVvl4M8RIls7wUtudKKVCp61fucfZ5z9+ckLusxn0zfzhnbjHMdT6TeFL1LXdwx6Hlx5xTbSXjCZB5RJp80otn4ZZJCAoC1QLgP9P8kWYJBwK8GPgFewCUSLVt+UlShyf4k5tnDGfCjCq/Bx/fIdmAVA932MCc7KLoR0C5lc1UZsitA/0Tvihadyh6BiXRhcUMVXYsIjy0R3OQIUb1Hs4TK3Ib9CPOV9lZSEVBIvQM8FOpilSBnIQPseUDPHnPtMNWdclKMlB08dT/WrceW2NSrGXIBNVN2mF6RFbhh30es3x3OJznjuqj2lG1ZG03A/tPAKYS41cdWid04JVQX2mr+GT0PY8awBcCIFzYAYpfhNymfp3H9HKS+qxNysPoGARW9S1b/DFzeWelUGEsZb4W3AipDF6oXRxaEzFHXchX+PtpWP2dkNFAMzMHJdVngOrJS7/OliqfVyhZDRnDVipw5AROIgjWeZ111LCJZhYYvfKz/2R6vqZmtPJ
 W3fOq3yW
 zroytwvBRVF+LsjCY52CYe4w8gQXUSPS2WMgTdd/f/xxAc1WYtbL7kYthUVxNQaxKqgtI401XdlJkFzBSMrQ55mf31KWGoLdqLi6zaQw308c35gRbpszpvywwS86zIgq/IUR7sI0OemhEpJCS2nEZ050Cyvy6D8hdWMg6whhElDTRtYzgvLnLdQRgra1/SQU987ZyLw87Jxwux3zAD/gz0/RyaHi9Xrc+M9eUKRuSVS8Bdoz0DnroQIuOdRjzD2U709kba6b5exWYexyEi2sgnPHCEhz+mEcIIp63/ah03cVyaYCKtl9r+M6pX3EGJMsfTX5ujKyIDEbZUMi1r6Jmr4wJ6p8PX6lXrbY8i/PtqAa9IYwU6MBXlo94hqD1MdLCuvFsZVyTJV2rq6n3L7Xg5+xsHrRqXytvrnOULOLwNlxUOnNpCqOectECRyD9uiq6zoS7wUzxaX69CasdbEK0InflDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

arch_add_memory() sets up the direct map before calling add_pages().
If add_pages() fails, the range stays mapped and any page tables
allocated for it are leaked. A later hot add can reuse the stale
mapping.

Remove the direct mapping on failure.

Fixes: 45e0b78b0532 ("[PATCH] hot-add-mem x86_64: use CONFIG_MEMORY_HOTPLUG_RESERVE")
Signed-off-by: Chris Down <chris@chrisdown.name>
---
 arch/x86/mm/init_64.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 8b6d86fb5a42..846cb34b38dd 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -989,15 +989,23 @@ int add_pages(int nid, unsigned long start_pfn, unsigned long nr_pages,
 	return ret;
 }
 
+static void __meminit kernel_physical_mapping_remove(unsigned long start,
+						     unsigned long end);
+
 int arch_add_memory(int nid, u64 start, u64 size,
 		    struct mhp_params *params)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
+	int ret;
 
 	init_memory_mapping(start, start + size, params->pgprot);
 
-	return add_pages(nid, start_pfn, nr_pages, params);
+	ret = add_pages(nid, start_pfn, nr_pages, params);
+	if (ret)
+		kernel_physical_mapping_remove(start, start + size);
+
+	return ret;
 }
 
 static void __meminit free_pagetable(struct page *page)

base-commit: fa4ad798f6f681031775266044ba1b0cf3c670bd

