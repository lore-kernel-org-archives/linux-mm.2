Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F9CF606A834
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 10:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MYxrll6v
Received: by kanga.kvack.org (Postfix)
	id 3620A6B05C7; Tue,  3 Nov 2026 05:18:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33A0F6B05C8; Tue,  3 Nov 2026 05:18:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 228D76B05C9; Tue,  3 Nov 2026 05:18:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F21086B05C7
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 05:18:24 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8F6368036E
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:18:24 +0000 (UTC)
X-FDA: 85393408128.09.26ADE2E
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	by imf02.hostedemail.com (Postfix) with ESMTP id B90798000A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:18:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=MYxrll6v;
	spf=pass (imf02.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793701102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2UxkzZOuXMzEW1DRxwfP1Y2akfSOt2A5NGCydHJqRyY=;
	b=Pf1t9U3+HVJ/pf6HicTP/TE6A+ViEjIDsCJAboWRFOzwQa5AKs1w+GZG7sDFwtVBLsE7mF
	atYmte3yZne4sjWmo4vYeOyZDncv0nBVwZs8YjwrkyOmiwczzvcEjgNNZwVedTeQEaGGiL
	HioUuQdWAONJ80B7XwRSMZDVydrosuU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793701102;
	b=kuiNpu/BEoR3sJHVNki3xIfse9kKEUfbm8MZB4xoCzy99kOwvBE4EmIhH5EHK4FR3O1W71
	zOagF+QA/i70JiQ267gr4Ns7WVBR4ikOKkPOhXik3RNFQDqFRyWH3Sp42eliD8oSSdLkb3
	l+XcNlEj5q7JiLNg/Z0kEIBeKawvsDY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=MYxrll6v;
	spf=pass (imf02.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-1adbf62dd31so4337455c88.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 02:18:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793701101; x=1794305901; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2UxkzZOuXMzEW1DRxwfP1Y2akfSOt2A5NGCydHJqRyY=;
        b=MYxrll6vom3o7A69/5BY0wcWWvSAC5NdfmDESOekh13O4/d73KXgGgLNrZ/oe1WPCU
         06uTssdXLJYCw9aaJjjmIKGUJ3Nn1DRfmttabKQrODPNyDcpHCnnwhcZc4ZLtSvWNyks
         R82/zVBb2h9tj4v5fNx3NRcRYk5PBg5uNjkd/C2IofnRbsWnAgAVQHcS37O7w1ocPzjW
         JAntVUoXpK5g5vF3m6qoOqUxs9Ygg8gisbSmjyxiBmwdRgRpgBcDROJcK4+pQgeJY3gG
         61dwiAX1APVUL+TSEJV/XNxr3zGA0cRANIHsZjZt9LPqsHqcd+4EJijbUsOIrooadrkz
         hf5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793701101; x=1794305901;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2UxkzZOuXMzEW1DRxwfP1Y2akfSOt2A5NGCydHJqRyY=;
        b=x7rRP0xZgsML+wvwgz79hadZepi5QDAHSy9mrRgzyTgL40YtTWpfHz+QKMlv3v89LU
         PvfqIGPJS537JoczM7amySECPm5/Bs4gJ2e/dSUN2hGYLFvY+vALvRdApJHCzXCwtOwo
         Sz748edal28u4KOmAxrFn586PTq1R/QJiiB0PVP97KhGWOGd2szSFzReovOZRQyteZ/J
         ZSf3sX5Qd+x31DS63ZvvbFlFJ+glCvodzqO0Q7YlgCet73ujDyHtDjE9y0w+HZ8uAViA
         eipWDv0s768BxEkpnbOSMQY21cS3ygauudG/l5OnmQsLLjUgzxPtQXLTg5n3R5GKNGdN
         NW7g==
X-Forwarded-Encrypted: i=1; AKwUvBypJEeock7cbQdJtELihlsnel8Sx4Y43r1s+mbAla+XK5kkn0guKEvF6HX+nw1tpN+cr/dW0IXnEQ==@kvack.org
X-Gm-Message-State: APuU4Z/aIdjyGGzYEPugwyxhfkeOpBCS0xq0Q3i/qw7VF5Bzqmlu7CKI
	ToQwWvFPCE65R9wR3M4OaC7/jxQSyYsG4vYFgkK/QVuJDjYdBrvh9mF+
X-Gm-Gg: AYBFou0fhaNx2zLpVHl/Ynrrsvwl9M+cqr4Sy0t7DiYxqjJU0nmOmr7CHtUkbyWdEdV
	D1h06gYon99TOjvzWiLcm4Xm+CkWs8Axnu8a1SR5pPlsn1xTAtqYXU9uOlMP2zecR/7MbB1sYsd
	61OmwA6H5FQM2SVPFxgdGMFS9trYRw+FIIKDhbBhcaTCOnj9JXKa9PrUEgzDKTYByLxfR9DCl+q
	JY/PiTAYh98w7H419U0AlNAyC2fJ8LQdkByt++IkAhLMkBSY4l0WNVay5esDVWqNLfIYdkQesM8
	v/qCj7TYSdK6wWcDVgNLwo8jlz7JNzOJ1PrdET18SJlfcAPB3g1qoVfX/KnEL98y3d6c1gKvxIW
	9ADGhSOkudcyxTP+MNx42PPmElVyt4D+fYtVx/DvZtWx7B3u9gG2Xiasxva8yHf1jx1yxQNV0bk
	pxkQo/qsKKpUx/c6SF9ztNn6PCu8yzQ8L/iO+Lp1juHMZX8EautgQbQtN1fnoVmxlMTnhU/q80M
	YEFBE1AOP6vNS0E/njl0NcSfbb1mKs7wYm2H3LSugvh2ovB/ueYPoynXEf7sRytYd5cbqtE7+dx
	0DQYavkWMMii2xSqtEO3PppSltrrMQ==
X-Received: by 2002:a05:7300:c019:20b0:36b:f09f:924a with SMTP id 5a478bee46e88-36bf09fa41emr1926474eec.14.1793701101482;
        Tue, 03 Nov 2026 02:18:21 -0800 (PST)
Received: from 027.. ([2409:8a20:4a5:7150:84fc:ce3c:7b09:dbca])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a4291e38fsm53145387eec.15.2026.11.03.02.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 02:18:20 -0800 (PST)
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
Subject: [PATCH v11 10/10] mm/vmalloc: align vm_area so vmap() can batch mappings
Date: Tue,  3 Nov 2026 18:16:58 +0800
Message-Id: <20261103101658.766905-11-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261103101658.766905-1-jiangwenxiaomi@gmail.com>
References: <20261103101658.766905-1-jiangwenxiaomi@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: b6m3xewj5rhq9cx1fnhsunth4bs8khnd
X-Rspamd-Queue-Id: B90798000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793701102-928573
X-HE-Meta: U2FsdGVkX1+nKllWYEjhqfZGRLMn1FqEdnFiHgFNLiQLVddAmtVEonqwJBQzqejhku2VI2Em3VRPK2IUw2r5VbYcddc07u1FzbSywTYtQRiQIo+dpz2LmcH3wy/Dj59aaag0Y//Eqv/PeYEAOUDTkOcvM3iK9L8pdri1r0A2lLpgEwIuZgaFV/TlDEA7yjbU2RfBpDow3c364Ads92wLQXxpF/UUoCnzdTftYOTmzd2f/hatXEggvue9KN2wPfj6aQ9Y9qMZd8QIV6dyH2lswR/WE6dm2QLg06N3/T2CJwDB+J5I/ogCN6vF9LYBAE0JZWPaiFl7yb+ysUmPkGxQMPIsuoJqS6h3yo1eco/F+low+qW1bXS1zj10qa+TfrUNf3oUdbLhuRzka5ul5lpoIPkeQHSg/NCB4xTjCHToG1l4iWM+h3JMsvsZkvlNkYfvC5ejaBWvXohLqFjXFt7f5iKRg5wu9krnOPWPNasHUf5v4MjCQqqyIdsYlDwhv9/XOP5qUDrLgYBy9sPUf3kt2EIaN8w72ozM2OpvXsvD5nAFRBj/H/LGyQkqu8KSR/SG5PRbPFjoYC51UGAGVKWxzUmAQowJF/l54vNqUNEjVxOIMO5JuhL8YM2D6TurRmIa0hPI4G6weLxpRFGumlGHkwI6bbyUoHHHyLGpkbtmJ7MGOaS6PpxPeC06WjLWB3t9FlITPQY8+7y2Bhx2qTTrKfudCgkRDA91Ng3ge/gpPjLxcME8pvbGIGQbsKGWS0IKJ6srIafcpmcx6TY9wWwqbZH5DCF3KVCNnDokLu5FaXwRDHyBcEyPp/AbvcsO7lFDg6NxmjTtBqZ4kaisA//RGG5PmilKE+Yo2qxz53izwC6GVeimSW4dlXrY/kW8iwb/SCZMd8dpvq76u4axZ7aioV4vouiMnOBTZfUz3WBQNilXU0J+oS2NIJ4n6QkN7kHRgAW2/i7JSJqtijXSXdA
 bUNsfIKo
 HwxsD+QxK1tgrGRvtydVwpWNzzPuSja+ebPfrkwcj/fQjy8VgBP1DSdIGlXV4AjJjBJPuHqLFTjgs0eMMrnw/tZd1S6SJRxC27Jq1ApWBJWuj536ZhY5TtAqNNqLJ2WmuIpmuEIx++TGr0Hb7IpcZW2sK+SxvhjyVJzQ/nEIeiIrXZK9PP+krfz7ZSq+4/1ZxTgVF+Kk2/JA1JOYlxPOAvnGnU26QzNEDNM68ees4rXnoe30Lw9On0Q6cdw9e61KogOuEYMJ1SiAiLpqiboPIJWahpoPxoQjPvAYmuBNSqUjJsj8bh1IccdbiaSgHPoZnbX2YRw32nswpIPXdw/duEHQG5k3z8i0zxp79yvw/0LMrZZrBaVM1Oq2QRfEoYiwYitUDAeBeQSa0HBwg/31FRRo7ZEKqJB5491xgLPWEMepReopT4Uc8gH9mW8hqpWaZQ4RTNwKejcQqamXGQdoAuM5ALy6zqnrvqJsfG1XeVOFjN5ZYnO2Kq4s9hrD7bI61TvyHDlRUd3qnwE+tGrJQOuQAF8L6ECsNQBTo7Ww0q0vHs7VP08ZjQ4srAkHqCYEKYBceDdo+7SUFp2V1K5cvhEqITXpx0Y1sSnrvirBNAwPdvX9m04dSf1UOZx4FbyqjZ5gVGQOqmDR6IfA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Barry Song (Xiaomi)" <baohua@kernel.org>

Try to align the vmap virtual address to PMD_SHIFT or a
larger PTE mapping size hinted by the architecture, so
contiguous pages can be batch-mapped when setting PMD or
PTE entries. We do not expect any significant overhead for
this.

Add __get_vm_area_node_aligned_caller() as a wrapper over
__get_vm_area_node() to simplify repeated calls with fixed
arguments.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
---

Sashiko review: raised two concerns:

- Hardcoding GFP_KERNEL in __get_vm_area_node_aligned_caller() strips the
  caller's ability to prevent blocking, reclaim, or warnings.

- The speculative PMD-aligned allocation, on failure, could trigger
  spurious vmalloc purges (reclaim_and_purge_vmap_areas(), synchronous
  TLB flushes, shrinker storms), a possible DoS for vmap() >= PMD_SIZE.

Both follow existing behavior: GFP_KERNEL matches the adjacent
get_vm_area_caller(), which hardcodes it the same way. The purge concern
is not new -- __vmalloc_node_range() already attempts PMD-aligned
allocation in __get_vm_area_node() with the same fallback through
alloc_vmap_area() overflow/purge, so vmap_get_aligned_vm_area() adds no
new purge behavior.

 mm/vmalloc.c | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 42b3addd20f9..e15bcef804fc 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3361,6 +3361,14 @@ struct vm_struct *get_vm_area_caller(unsigned long size, unsigned long flags,
 				  NUMA_NO_NODE, GFP_KERNEL, caller);
 }
 
+static struct vm_struct *__get_vm_area_node_aligned_caller(unsigned long size,
+		unsigned long align, unsigned long flags, const void *caller)
+{
+	return __get_vm_area_node(size, align, PAGE_SHIFT, flags,
+				  VMALLOC_START, VMALLOC_END,
+				  NUMA_NO_NODE, GFP_KERNEL, caller);
+}
+
 /**
  * find_vm_area - find a continuous kernel virtual area
  * @addr:	  base address
@@ -3692,6 +3700,30 @@ static int vmap_pages_range_batched(unsigned long addr, unsigned long end,
 	return err;
 }
 
+static struct vm_struct *vmap_get_aligned_vm_area(unsigned long size,
+		unsigned long flags, pgprot_t prot, const void *caller)
+{
+	struct vm_struct *vm_area;
+	unsigned int shift;
+
+	if (arch_vmap_pmd_supported(prot) && size >= PMD_SIZE) {
+		vm_area = __get_vm_area_node_aligned_caller(size, PMD_SIZE,
+				flags, caller);
+		if (vm_area)
+			return vm_area;
+	}
+
+	shift = arch_vmap_pte_supported_shift(size);
+	if (shift > PAGE_SHIFT) {
+		vm_area = __get_vm_area_node_aligned_caller(size, 1UL << shift,
+				flags, caller);
+		if (vm_area)
+			return vm_area;
+	}
+
+	return __get_vm_area_node_aligned_caller(size, PAGE_SIZE, flags, caller);
+}
+
 /**
  * vmap - map an array of pages into virtually contiguous space
  * @pages: array of page pointers
@@ -3730,7 +3762,8 @@ void *vmap(struct page **pages, unsigned int count,
 		return NULL;
 
 	size = (unsigned long)count << PAGE_SHIFT;
-	area = get_vm_area_caller(size, flags, __builtin_return_address(0));
+	area = vmap_get_aligned_vm_area(size, flags, prot,
+				__builtin_return_address(0));
 	if (!area)
 		return NULL;
 
-- 
2.34.1


