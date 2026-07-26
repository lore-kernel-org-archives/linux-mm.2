Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E15EFC531C9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 22:23:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AC336B008A; Sun, 26 Jul 2026 18:23:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 081576B008C; Sun, 26 Jul 2026 18:23:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFFA96B0093; Sun, 26 Jul 2026 18:23:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A603F6B008A
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 18:23:25 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E12F4805C0
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:24 +0000 (UTC)
X-FDA: 85032355128.13.7668821
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	by imf05.hostedemail.com (Postfix) with ESMTP id 42E3E10000D
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=q74UjGmU;
	spf=pass (imf05.hostedemail.com: domain of 32YhmaggKCN4JACKMANBGOOGLE.COMLINUX-MMKVACK.ORG@flex--jackmanb.bounces.google.com designates 209.85.208.71 as permitted sender) smtp.mailfrom=32YhmaggKCN4JACKMANBGOOGLE.COMLINUX-MMKVACK.ORG@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785104603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DacKmcthV2MkG170QiSb9qnx9wyJU1iYBlLXoU9TojQ=;
	b=0IgpUC1/B6gb7fxZKqIyleevpxgRl29lrr1FyBm4qKxz5UIYFX/Hs6qGhP0GNTEAONpo4C
	amHw9NdZdGDIPSdNggcfl3L2yCkxKMAfEBrHrrp/biY0lkWjESKLQDw4nHe6N3RZDh4vpE
	F+i0iUyBriOf+IMOKrDUUStO8bB3IMk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785104603;
	b=l3P4JJ+oo5FahjfbCjsM8+lOtbFw//cHveN6nLH11atsKYqL/mV+ab53bZ6uq25CEH8VQW
	jM31pzWo3AYrkvB4edKunhW3j9YGRV3zdubE/4aowpSVjqBp9tPdRm8yt92HLYZffW+ZIN
	nsnkdaPZ4M+kAaEfUvSNslmo1t/rSsw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=q74UjGmU;
	spf=pass (imf05.hostedemail.com: domain of 32YhmaggKCN4JACKMANBGOOGLE.COMLINUX-MMKVACK.ORG@flex--jackmanb.bounces.google.com designates 209.85.208.71 as permitted sender) smtp.mailfrom=32YhmaggKCN4JACKMANBGOOGLE.COMLINUX-MMKVACK.ORG@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-69841da1946so2211483a12.2
        for <linux-mm@kvack.org>; Sun, 26 Jul 2026 15:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785104602; x=1785709402; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DacKmcthV2MkG170QiSb9qnx9wyJU1iYBlLXoU9TojQ=;
        b=q74UjGmUB4L04l0CG0aD9Z9J0gOTk6C7wZUiTZEVmHo6kR3gpgyMkYppGdcZC0IJRU
         EfvkfMSU/ngzj0nR/BpmO81m319CFLhLW7AiTKuXg3iMrWu7HbYRkfQiEVsth8ok/uSQ
         +shf8C5VC1FJfUB0Aasif5Q3ZppBogUBnFoeIODOObNwTPlq7jCn6ofeOhPFC/a940G9
         mqoT+9egpzBDJ9+LoJe2UDOAW0enPV1BBhukww5pWLaKoRgeVLuCqxKIXVxfuro+4fwU
         3UaplpF5FEpg+hemU/3tRZhiULrQ//gbu8KEf4Yahs6PwWHygeCgiZpXKcwFIeZm5sxa
         5+VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785104602; x=1785709402;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DacKmcthV2MkG170QiSb9qnx9wyJU1iYBlLXoU9TojQ=;
        b=DTYU9GzuegalJqSB8NRASrQLSLhTay1FimLGMP85i0R7fsF0x02r8PckT80shvi83R
         Nmda8QdJo4NHKfwnsjV4gDN6WAMNJddOxseDf6ieSCtt1JJvhC4k2h8bIgRK8UmZ2jSa
         uQpUHArzgjGsCd1+1TUSy+9s4jboJZank96ZmxurFnnqDp0cMomOqPUCfXJZgXUDHTuK
         ts37E14HBMYkGkhbEu5ISQYwpVCk9+3SuZ3BY2UY17hmQHWFLRVwdX56aGw/P3G5dw06
         dg4rbpbyAc2bmygTU4dPZo1VTdJ1B7dwCwwPLzNMwWwC/sUM97mgk97ko3LzeDhyODZj
         ardQ==
X-Gm-Message-State: AOJu0YxaVmZNfXc8Cc/bRyS38MigAUb77TcYnQsjKmvmLxSClRvHlN1I
	dFW9SZTOMy03O3nst8FcvhrgslpvWg3hWVcHr94L07EfU9jdHyvQf096FfOC0mDFZtDr7hSXbgG
	4Bl49VUNZIyOfjw==
X-Received: from edds13.prod.google.com ([2002:a05:6402:520d:b0:69f:4a68:c7d])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:3226:b0:68c:3439:1340 with SMTP id 4fb4d7f45d1cf-69fc113fc17mr2508809a12.22.1785104601794;
 Sun, 26 Jul 2026 15:23:21 -0700 (PDT)
Date: Sun, 26 Jul 2026 22:22:35 +0000
In-Reply-To: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
Mime-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
X-Mailer: b4 0.16-dev
Message-ID: <20260726-page_alloc-unmapped-v3-2-6f5729aa9832@google.com>
Subject: [PATCH v3 02/26] mm/secretmem: make use of folio_{zap,restore}_direct_map
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, 
	Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>, 
	Patrick Bellasi <derkling@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Sean Christopherson <seanjc@google.com>, Brendan Jackman <jackmanb@google.com>, 
	Nikita Kalyazin <nikita.kalyazin@linux.dev>, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 42E3E10000D
X-Stat-Signature: 96yydfwu5rzkhpkczhmrt3iqyydpom1h
X-Rspam-User: 
X-HE-Tag: 1785104603-378117
X-HE-Meta: U2FsdGVkX1+IZg8m7Jx+uLCrDfmW6lZJ+8CeMuqGoOJ78r0QjvMXXbxmdMXxlpvxAVWwO8XqyhLm4zqgxEylU5eYEesN01qiDlwOQEhmkmAsWc/82nScdGhHy9vjzJSihW4EBDa4T59dE+ek+55DT+ggFEuRZuSs85ki0+mssG4CF2yV5IVwrjJomH/RY03Z8hPrSUjzGc6H7FDJX8MWBuFPn+pDg2FSmiE6Mrry5iIUWtLNJPGpSD6mZkllY3ywwMUyv8yTs/KJ+c6DKqYS56hN0u0NwUQBFvsfnaUTqr/4Ntw0HCJ5SdwVo0/vSpee5pngE+mnf7s7U8Bxb26OCE0tIlSs9OJ0B0WIpHHiuOvT0RGzxCHtQ/efE30pIQ1SmZlFIF6oUtei0dAeu36v88FkpYkkgJWS9txFLKMX+2WON2XlYtKX4PGaqcHf1JO2aiIMWoFIWx4iJz2SrGOUyyTXqLmfzzg+yonnCr1hYdowQbqleHGr22cKZt2Ej9gp7ROK6BSHa0jXuRQDY9CywBF6C+/1ZzPoIthbdS7RWqRkp/neKl5s9e+CDQ7coXtKOsQDfBVKQq85fQX+tRrh+7dhEUkVkPQbGzfiLZs14QBqRjQPHld2pQZRE0T2GYID84WaNo97CUiIgeCSu+Shm76Bjy4cpJIWJ5Tp7uVLKWkzBS/tn966Hqgy4IBhLVwTr4etcxmrxOPWdAOyqCX1FPOarsNxZy3eBLYx2SFzRV2u1AUtbdhLXYcn0gGH24Tk6cQKO+sKi1YH5Rq5UGp9TNLJSPk9iKddjjzEsmER14chJLBhiKLfmpkfGnuGLS4XJ765jvo29dvamN9PpONhkkgHseIq05umhWe36Dg8IcByiFsDFKrQOh7r5O2eTBlhinmAv+858KT61vDvEycEqjCC/pn/kQHaLUhqV6TmU95xzUVI8q6VN/ZHdI1Ib+TJvHiscq8juhPSQQ5WPoh
 GxUxKcr9
 pvAqqUa9rfutfbWOEfopx+z6UR4RDlsi7B2nobriNPH0hL1tFIGigkWo5A/LGZ0R0N5T5A2IUWdpGvlWtIQIcOhv30HVBBjn+alBzP/RqOzBmh5jsFKLSdvoZCH/DgAtO7XwZUFW3bBTChMEbXLd6bMBOLEtd+aHBMWUiIZvH2BfSBRKZXAOdIxDYLLZPQ627NCduY4nXEZ5ogyOJVcoPJhb820n0RZm3USuN90GAVUNyD9Fc8xFdWSPaXjtYaNEN6kBYQ+TWchFu5pilmub6lG95A1ic3dPcU5+SODcY6+hlHpqMPBp5taGJmDC/Y1YOh/Tg0tTdXq887FgTT0gLEI3A+H4zGJs3oZ8sJLVAFa+9ThzUOJgC7rLElFy3YYvsRfRGsW5I430C/ayH7vEpifhICXj1qUu/+GxdgnePoPQru0zXkc/SfNm4wqDJ6UVt4AssbQGR37BW0oAzdL7E86wC6j9TMXqOaI2hdlAuUUQgrxGsjn7LSV2jYR51WSI/0djtMT/dun+2uksnQWPvHmwiqwzjn7loKX5nBRDAB8ZR+q2PZ23Fsnj8r2lrPges+L+OuMk7MydRIAJ/I774j8paih86Ew5T5ifCwXM4mf3XZER7IMt0IK7OlUnJcPrJoUJ7PbCa6AGL3kV+IJpQWhr3yaIJ9Zju7nhK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Nikita Kalyazin <nikita.kalyazin@linux.dev>

Replace set_direct_map_*_noflush with newly available
folio_zap_direct_map calls that take folio's address internally.  A side
effect is even if filemap_add_folio fails, the TLB is still flushed,
which is not expected to be on the hot path.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Nikita Kalyazin <nikita.kalyazin@linux.dev>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/secretmem.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/mm/secretmem.c b/mm/secretmem.c
index d29865075b6ea..4a4934769f8ba 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -53,7 +53,6 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
 	struct inode *inode = file_inode(vmf->vma->vm_file);
 	pgoff_t offset = vmf->pgoff;
 	gfp_t gfp = vmf->gfp_mask;
-	unsigned long addr;
 	struct folio *folio;
 	vm_fault_t ret;
 	int err;
@@ -72,7 +71,7 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
 			goto out;
 		}
 
-		err = set_direct_map_invalid_noflush(folio_page(folio, 0));
+		err = folio_zap_direct_map(folio);
 		if (err) {
 			folio_put(folio);
 			ret = vmf_error(err);
@@ -87,7 +86,7 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
 			 * already happened when we marked the page invalid
 			 * which guarantees that this call won't fail
 			 */
-			set_direct_map_default_noflush(folio_page(folio, 0));
+			folio_restore_direct_map(folio);
 			folio_put(folio);
 			if (err == -EEXIST)
 				goto retry;
@@ -95,9 +94,6 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
 			ret = vmf_error(err);
 			goto out;
 		}
-
-		addr = (unsigned long)folio_address(folio);
-		flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
 	}
 
 	vmf->page = folio_file_page(folio, vmf->pgoff);

-- 
2.54.0


