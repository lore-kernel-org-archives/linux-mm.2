Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE763C79F85
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 14:12:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B58646B008C; Sat,  5 Sep 2026 10:12:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2F016B0096; Sat,  5 Sep 2026 10:12:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1DE66B0098; Sat,  5 Sep 2026 10:12:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7963C6B008C
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 10:12:47 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EDD98A0354
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 14:12:46 +0000 (UTC)
X-FDA: 85179899532.08.EBA4074
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf10.hostedemail.com (Postfix) with ESMTP id 346B4C0004
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 14:12:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=nebusec.ai header.s=google header.b=WRQK9SML;
	spf=pass (imf10.hostedemail.com: domain of weir@nebusec.ai designates 209.85.216.48 as permitted sender) smtp.mailfrom=weir@nebusec.ai;
	dmarc=pass (policy=quarantine) header.from=nebusec.ai
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788617565;
	b=j2cWPWIneflQjn3ofxhL7ESaG0QbDoVPh3mJNim3s0POfmyEuTU4Xls1KoxSq8T+MQWRF7
	ffHknPCx9z5K5chePQVPoB9xFYjpH6v4OOlPxEHPfRhDGrwNZRanMKSbDPHJ+MCVhisxe+
	NwQF++8eflKXosGX3QI97UCkC5MGkpw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788617565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hBSSa1t++Vot/hTKW3L0VUoFGmGbHhlWj7+R+VnDKN0=;
	b=CvIuRxD1n+d6U+jgqSlQDMKzCVo/+qLhaUtFLFfLiu4jY7ND7AikGsa4+e9ORzz3Q8dSxn
	xe0taOAybYCg8/4EWGCTXYMpl41XHHVraK1qOFPGWW0bkuDSYPYDyKoKJm+PuejPbjr9gc
	dxbh/oMAY6ByS7HPKFn+A9SKEilqMTw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=nebusec.ai header.s=google header.b=WRQK9SML;
	spf=pass (imf10.hostedemail.com: domain of weir@nebusec.ai designates 209.85.216.48 as permitted sender) smtp.mailfrom=weir@nebusec.ai;
	dmarc=pass (policy=quarantine) header.from=nebusec.ai
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3966791a6eeso2332285a91.3
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 07:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1788617564; x=1789222364; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hBSSa1t++Vot/hTKW3L0VUoFGmGbHhlWj7+R+VnDKN0=;
        b=WRQK9SMLanvTwv2VniD7Uapfpc6bttv7jsdUZksfHo+LxN+0z5BCVdbN9RkefKlOYS
         ooiF222sILaoAfAVy7keq0Bs+LaGF8i/KXS4TUvGMEYhdAHwLZmj+RvN2bUOM4XakWlt
         NHn/TzHHqw9y5uywHmNMVwsN8dJ9FV/bXJWrLqN+x3jKeA1osljJDMBKdTk9ZO93Lqxf
         7wPUzILQXjkhnRoxAQgNc7kSLYm0bbShMDgHjiWCmFqsMxr3RXwV1JsniGKJXJM0C/yT
         skkrM8Xh4cETRJquzNoIflSAglYOsSwFvF22MyYYMplcjIYlXjSd5TCQ9KI0oDqQGh1J
         zF1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788617564; x=1789222364;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hBSSa1t++Vot/hTKW3L0VUoFGmGbHhlWj7+R+VnDKN0=;
        b=V41hy8/adXXeAclQ3wUVK+6RnLkskwjARKJbhfWdAMS5fhJEWcW63CLxEJVtq1wObS
         oWqubnuRYl6ofygq0EAqby8VW2LbEA6HHKejpUvQmPqY4RPKF8rgMhY0DZjo+B5vnnEK
         fsvgU4EAFvyih+pQ67BgJCaaZCQnvN0CJ3hNcME77ACqTToEnb31cIriOaZzg0FcKTi4
         ulWyfocYqLpkD60tGCY4BHKB/82FjkKlUSAgV65QZSEolFo3OitznES99vHZhizPCWnJ
         6yTs0VpaCiV9BxlwzWn90CdIivL8Ho1tZHwLCQKQ9s8D1HWUUMBnCBx8soU98swES9DX
         6QKA==
X-Gm-Message-State: AFuF++mjweZQyTXNhZ2O7QMpTnmvnhxxgamI/8h41YmJ/qYtlCyo9B2q
	AQHl96xC4nCgj6rlarvoUn4apsqq8cGKGb75/q71RGSmJi4ytjE3rjlwC+ntWCn920l+DeV0xhJ
	zMr17Kg==
X-Gm-Gg: AYBFou3PG4Tl4EF4v+haqqz9bDLPiNGQ0b735aWx7KgVFJdfZCxiXHt26feF37EnweA
	3LnwV9uElYElabWwBbnTLFX8o84lxrnk8+O4zyW3hLJfT9/vS5VstR9wCIrv3IzN6SkVOPFleY7
	HIRUVTw3CnIAiwqRyUllclD9q9Vc+6nBhdu+i1b/ZHX2hRqUAI1L6KvFfQNAhtubPEuqZaqZXOZ
	0m2KuXkgbK30BPCQshQHINTE8gIapRLMuR5rUVG/zqa/SFsq/ljflTlybjipuum6ExVVRDQKI/l
	oQxTt02Dd9ljT39M9io8LqevBXbnImmHyBjrwnm+SUN6IvJz6m7EQNVQ+exDYOMo+hqCwaK3f2W
	1sf4DCro2TIdKhRPyYj+YLC7ycj6XiMldTKB7ChN7BdsMDLlDT/3w283EJdeZbytmSyIeWQqKeh
	hUno7mc3rSDvqhg8Jdo/C6cKNiQIKIr5lWy2uX5xaMMV1rwn3LSqUHG/OV4Qfk1WbEMc9p0A==
X-Received: by 2002:a17:90a:e7ce:b0:398:bacb:1137 with SMTP id 98e67ed59e1d1-39b2624a1bbmr17510010a91.19.1788617564103;
        Sat, 05 Sep 2026 07:12:44 -0700 (PDT)
Received: from enjou-Legion-Y7000P-2019 ([165.232.167.5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b07b197a9sm16454273a91.0.2026.09.05.07.12.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2026 07:12:43 -0700 (PDT)
From: Ren Wei <weir@nebusec.ai>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	notasas@gmail.com,
	vega@nebusec.ai,
	rakukuip@gmail.com,
	weir@nebusec.ai
Subject: [PATCH v2 1/1] mm/memory: constrain generic_access_phys() to page boundary
Date: Sat,  5 Sep 2026 22:12:17 +0800
Message-ID: <eaa4de66f9491888e0ffeb2d37ba7ae796ba535e.1788531737.git.rakukuip@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1788531737.git.rakukuip@gmail.com>
References: <cover.1788531737.git.rakukuip@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 346B4C0004
X-Stat-Signature: m5fekfucmkazaxx7wnfazd93dxnnaky8
X-HE-Tag: 1788617565-341398
X-HE-Meta: U2FsdGVkX1/xxGZZvQepyBaojGQWWKPlm374TnGKz8UcGEhtPcRXiEwjZSVioWT8/fkMXLb508ek6ahVVONO36C9sEFey5mZkKrOj0R9lFMfe9obBfhCRgISM1AQoqJ0A4zqBp6nphPq56y2QTflpswEposAgS4aFgZg40X8XphLjAyuNDmBNlOTYXqleiYae/ciuOA29R5n3moaM+xIyNuBDb3CE/hQxUrUsHXfQPHnzgCR4DU2iGKQ3G0cGF2BfGeM4EwdPXA5zaSCV5Ms4oNLEpvxs9Jxhh6TgiZdwF5bv9P6f7ZUPrsYmLdRCOkfc4ninN3vbMZ6bmbaMtYMyIxume5ZRxw/tLQET5uN1D+q5/4FN9c4+8q24KfeKLDEFos/MIeAUr3+1hNY81l+oyiE5H+v6rpzI9fAlZuDswXQQm+9n7tID34FQ93LtBIcm+orJ21m7OMVP8R4mFQiU6/AYMDF5iKXMdcDE7a/Gqe0pxOkPK0/5qtd4FZPU5IY45rdYHJa2Xx8olJ74+28RMuvq/cFFTAgWZ+4kKf3riPFOvhMxFGTq7UEaShf4MqQpDNofQDDnG42Am/JUvHqAhIv7ii5tebNmitzqD/bEOSe9R9huDRl4CuGQZ82n7em8uaHUX4WgpEkMGAMkCwno8kX6QCnP1n8nLHIPiLim6kAGdFNGv7Bya7i9I9vIP7/RRReN83Uxhjuc2EnofnpgHBVAXOWr4bIXfOpaJKewQsNdHE9ilJTeOhE+Pfih1EA+7NNgRNOPlxSIBaeAB3dzvp6zd8GW07xbvxczDaWBy/BieTjSK/FAlIkPlsxzUzf3pKsLF9XeVpvxlNTgbJDj8HQSRQmoHNn92g0E0iBflTe/0pDjCl0by32A9Nh8UkXn0EblKgrxQCtt1mE1wTCg4nebJC9cxCvHfFgOQskXLzQ09bgUZbXt38WyWyCfw0vWZ+3uBbeLRh5S07K2IW
 2EWV/jls
 qxITvJnZs7VkAv0yBkVnmdjI5GDqN1EWFtlrfdf5DhGnBFiGkqX1gs5gd5/IhNyfaDUVA+sprktHc219YOBej5ZUqe2iYJT4Ae2zhjlESipJZhpwtJvKnQlzQvTQA1reDNrGMM/yOiIx0pKt7JrXioGfzaG27JU4cG/YhZwCTg4iYb9ailD0YAagAsxz140kMGVMZhuyZctfyq7M2n6n9ViXMn1TcuTk0GBMJStpvOnfY1j4VXlWUZl0xDFLmjMYpy3uChQAxmuSdc/51zfeloRR5tF/pDY0sbeIRH4DQXttTfpQBAT2YwXR/IjFMX7IuhuybkLRzHqnfc+w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luxiao Xu <rakukuip@gmail.com>

generic_access_phys() improperly validates the memory access range: it
only validates the start address using follow_pfnmap_start() and passes
PAGE_ALIGN(len + offset) to ioremap_prot().

This poses two problems:
1. In PFNMAP VMAs, consecutive virtual pages are not guaranteed to be
   physically contiguous, and individual PTEs may have different access
   permissions or writability.
2. The mapping may cross VMA boundaries if len extends beyond vma->vm_end.

Since __access_remote_vm() already loops over the requested length and
accesses normal (struct page) memory page-by-page, constrain the ->access()
callback in __access_remote_vm() to at most the current page boundary.
Because VMA boundaries are always page-aligned, this also ensures the
access never exceeds the current VMA.

In generic_access_phys(), defensively clamp len to the page boundary as
well, map only a single PAGE_SIZE via ioremap_prot(), and add a missing
(resource_size_t) cast during PFN re-validation to avoid truncation on
32-bit PAE systems.

Fixes: 9cb12d7b4cca ("mm/memory.c: actually remap enough memory")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Luxiao Xu <rakukuip@gmail.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
---
v1 -> v2:
- Drop internal multi-page loop in generic_access_phys(); clamp the chunk
  size in __access_remote_vm() to PAGE_SIZE - offset instead, leveraging
  the existing caller loop (David Hildenbrand).
- Defensively clamp len in generic_access_phys() and only map PAGE_SIZE.
- Add missing (resource_size_t) cast when checking args.pfn (Andrew Morton).
Link: https://lore.kernel.org/r/f618e2f57ad0086a8d7a95cb17dcf5a1f0cf0e45.1784428532.git.rakukuip@gmail.com
---
 mm/memory.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 8b0c2c735d3d..09390e51432f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7164,6 +7164,11 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 	bool writable;
 	struct follow_pfnmap_args args = { .vma = vma, .address = addr };
 
+	if (len <= 0)
+		return 0;
+
+	len = min_t(int, len, PAGE_SIZE - offset);
+
 retry:
 	if (follow_pfnmap_start(&args))
 		return -EINVAL;
@@ -7175,7 +7180,7 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 	if ((write & FOLL_WRITE) && !writable)
 		return -EINVAL;
 
-	maddr = ioremap_prot(phys_addr, PAGE_ALIGN(len + offset), prot);
+	maddr = ioremap_prot(phys_addr, PAGE_SIZE, prot);
 	if (!maddr)
 		return -ENOMEM;
 
@@ -7183,7 +7188,7 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 		goto out_unmap;
 
 	if ((pgprot_val(prot) != pgprot_val(args.pgprot)) ||
-	    (phys_addr != (args.pfn << PAGE_SHIFT)) ||
+	    (phys_addr != ((resource_size_t)args.pfn << PAGE_SHIFT)) ||
 	    (writable != args.writable)) {
 		follow_pfnmap_end(&args);
 		iounmap(maddr);
@@ -7254,7 +7259,8 @@ static int __access_remote_vm(struct mm_struct *mm, unsigned long addr,
 #ifdef CONFIG_HAVE_IOREMAP_PROT
 			if (vma->vm_ops && vma->vm_ops->access)
 				bytes = vma->vm_ops->access(vma, addr, buf,
-							    len, write);
+							    min_t(int, len, PAGE_SIZE - offset_in_page(addr)),
+							    write);
 #endif
 			if (bytes <= 0)
 				break;
-- 
2.43.0

