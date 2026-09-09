Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54A92C79FA1
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 02:58:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0C3E6B0096; Tue,  8 Sep 2026 22:58:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBC3E6B0098; Tue,  8 Sep 2026 22:58:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5D986B0099; Tue,  8 Sep 2026 22:58:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8EA3E6B0096
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 22:58:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 094171607F1
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 02:58:44 +0000 (UTC)
X-FDA: 85192716168.26.34524C7
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4A37180003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 02:58:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=O+dUTBhv;
	spf=pass (imf02.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788922722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TXwn16IKsAcJzLpp2jrqz/yHYVFBEEgFTxz9PHTQzdM=;
	b=6ywy12P5zW60kHmhIBFyVsXqZcPWYGs+HPvlfxg/kXFPDMClhG81D8vqSsD8PKGQuHsH6Q
	4AGLX6ky1dnMuWcXZKI+vJmXLSJH5gBDcls9t4yUFFnxhx37E7FWuNvEmUdKOgsOE6dICR
	UD6ZH2zwHc3YUA3yEeOUwqjshUQZ3kw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=O+dUTBhv;
	spf=pass (imf02.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788922722;
	b=ulSVjJnCYU/RYePtWppbdsi0tP/vk3G9Hv4Pus8tEI8UZ77FuCF3hPRjMi1fqsQv/vUh5T
	c5xTP5fW33SdkuZy/8Sd6mIiD1tE6eqtmcanVDcCcNG0sG539Q7fDRRhqV0BqUs6A6WoU+
	Uc/e31I7sJX0WxjP5MlHP6tQqoPaM6E=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-38ec1402b05so5227619a91.2
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 19:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788922721; x=1789527521; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TXwn16IKsAcJzLpp2jrqz/yHYVFBEEgFTxz9PHTQzdM=;
        b=O+dUTBhv+nTNry3vTa+64N9doEqsZw0No1ghzXomdULtHjUbIelMAWANyhdPx4wwZL
         qcUuYQdqx9sjq68H17D7ri3iv1a8AHpKL05WO3T9tj0HLN21slWCaQV5JsqmpM/gLaNL
         w6cIfB/kvJ/KiNgf2i4BoKeyfPVkLRPMH6meBjHvI7Ba4USJmGVS1C/p+M+07TNqPi5R
         57nykpg4/nOM9B+OfbmM92GxuO4F5yBxTAd1etTNUhfmbIFvvAlhrD11lHmE5xt2OUOp
         BPf2DBuCh7W25tTpGSDn3D57v21h8RB9uRafvT1LjmNB60zIZ45roDNMSCWaI9gYfQ/5
         B1mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788922721; x=1789527521;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TXwn16IKsAcJzLpp2jrqz/yHYVFBEEgFTxz9PHTQzdM=;
        b=Da/aVF3XpfIlmX2E/jHnrCbomC/i63WtCNDXpk7RZsbQhdB3OKScchgyNOXwfr4aes
         6qrhqpRWTAMwGSm25ALoq0xDSlUPsKZMzsS9WE/Nz73jaeSyvsl4xINlu8BeuDZlR8zV
         s5gHKmQmkkqc3R236QJnQS1Uue9dyRCEBlabRLDUWOlM1Api20rNnxG4SAUxHazICgS/
         vmxsuIx9Nsbywbm/0A0IyzsiVLlgdxAIUspx+bDqeS8fbspb4bQ5tZ9A9kd3o+wKosbp
         mlAU+OxJVrRMZBlSpRsspY4JbycfIdcLivhLspbtrrK3qp5G0/mESgZ/28ZLq2Ao6CEK
         qjgA==
X-Forwarded-Encrypted: i=1; AKwUvBwPDu7gj4UOwk/qGOdbIz24JLetnmpuCJ4dwBDOoRyFbNcQi6LPdKajf2b5pGv6VQql7d8LfWEg5Q==@kvack.org
X-Gm-Message-State: AFuF++mcwJbzwVQyL8EkapsXyOTcsq6cP7T1pERNpxMqQm0NudAUqkMz
	CG7LVG3fM0G2S16vvzi0KywKuv1tBcod7I+nzDiy+6MQwwmvGvkuMg+x
X-Gm-Gg: AYBFou05bR/Huac0Re7mlHJTND2uQVSUtAxIe90d/Fr3rO3VOZHKeZUwu59yyM7k+bi
	Jlb2kaBjXyx75KNQ+BALviqnFxrUEakdcse3sT6lCTknqeDNVawxGNLN+YyScKZvHL2EMOwHBfD
	zA9soXg8BRHQGqzUpxsASWU5bzOq+v40gjc8WLdnuWE5GRhdG4/oxkHvUibsOQSBuVonk2ubAIH
	g+VHkBQnn1nDJoqo4n7LIIjKlA6LjZnD4MyjGyviSPUE78kbJtU6bZ1yStMkj4LFTMaD93HEgDd
	hAXb/k50gkZFLh/ERRCmd/iMAEJm2QpJW9hFtrr/haUFGUW+agYdqL4dwaBDaexVPFDxgQ9x8OV
	Rw0o4RP+nIijPxL8GoYEgeio/9B1La43l+tw+EdZChJx3gcE3CjXYw5u1jjfi2Q2By1qZP7kTtR
	unnOSRAbCK7/7SHb8Tp45Rr3ljFc4IGynl29ivU8K2EK5vetJG8xYxNQ4ag7FUoBN9yvvLMYNOn
	weGjkRL7hQS9w==
X-Received: by 2002:a17:90b:4984:b0:381:25ce:bcc2 with SMTP id 98e67ed59e1d1-39b26104798mr44428583a91.6.1788922721071;
        Tue, 08 Sep 2026 19:58:41 -0700 (PDT)
Received: from localhost.localdomain ([240e:b8f:1df9:a600:c693:b19f:ada0:748])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08c39451sm35077172a91.7.2026.09.08.19.58.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 19:58:40 -0700 (PDT)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	zokeefe@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH v5 3/3] mm: khugepaged: fix folio is used after folio_put/unlock()
Date: Wed,  9 Sep 2026 10:58:03 +0800
Message-ID: <20260909025804.3233645-4-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260909025804.3233645-1-vernon2gm@gmail.com>
References: <20260909025804.3233645-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ux1kmz4kx1rmfr3pwugjq9n1rscwyq3b
X-Rspamd-Queue-Id: 4A37180003
X-Rspamd-Server: rspam07
X-HE-Tag: 1788922722-419252
X-HE-Meta: U2FsdGVkX19/aFVFzIAybRDIf/Z/XyJgwr0g3/tqW12yFOuj6IijvDR06an+FxAlBF8jp9ajefI+ag+m4prWWYDwSV5+vD/HfVauC+8yhXGl0EcecIzMLHsOhax8dLtuwxL1vVU1Z0ZEt224lDnm71/CDCCtWWdOSuol3HxGTP0BcCcaLWcChvpLZC5eR02YDeiHWLxZENZdo2nIva/v7ibB0WRfGihgWh37KwBYjKdjRORzoQDKRywBV81DhLrHtLIyXmF4T431Wm90ntBMKhzOASoXRCB9UQO2fz9zITKQ/KGrYR7M+903SKNS9bfGjzqdiZEuyibuN3lBkkc4OWnOUdzL7IzV9rz3m6lgh7z082FnIf176BLtA03S4O+I2n1FeERQWwsqRyY8ScHxP2VpjufeTlmGmy/Pt+hCOb9AmNFKw0ztBLKNy5zeFFenxoGWLhAm9XKQZN8ZRJf29EZHOMktct6Q615XBzIhPSlgljVRCleAT3SyAjERyXfIhR5otMeyCq3NwI81NPlzPE/NHBRs6T0u2h1c5Ffs/Dy7iFgMyUwWaxv65LwuFsF4RQ+AS+9bToIoY0sRk71lM1eG0l3B580/cu/Bn1/vbjeOyMcqQ7Rdq/eCDcJBrDoIIEsxF3i68KJnSXXaySQb53YGmQSVg/amWzToAlSO+VA5HU2viOx9Syx0H2qw97zxn/vcgV4tas8PsIXLRW1nnVLKB4GmAqJJeQI2jgsySHPYvFJ87Mt+LmAJyvm7UlGYV1gO2MLhOV2taVvjb+DViatICnZw00ydqT00nP0G7GOLoN0sFoxxK+774TjJ62Lp4ioPPs/n+k6Dm2lkkc747udI3r7lNIWktfrz4MWF9TCS4yai+LWWMNqHWyH6LuL/WFsjLoxbzMHRS4ip4I0X+VfbGYeGH+HBivL30CN/PQJ85pUN6SF5E9xYWB2htsChYo3u9qOLiI2zgjkeL6R
 KBv5n8N6
 kK0JHWZpa4BTojT44hW2qgtf5SMvdwqIcqS6L4Gdp4PkcqStVZmd/9QPf35PDzZsl2kc70pkvpYNSxx/OJKmaUJ19fsCOoc8d9nF7tIexZgnBwP4hgADZMDO6tCag1ThMK1Kl2VVHOP4br234wyah7T/DebJ8lo+LMOoyW0fOHPCTMdO6Na76CsxqG4Y71ArY73nA3gGemLSZPdpKcaZS3cGGRmTpoy+uvbUJ7dwUPjLbESRrpGT8FZUdZk7OBJL5nbeOfmvQ2I3eHtqfyndsdjpbEyXipvP68RP+tdlVUqNElyBxDSGli7ywUe22lKVAdLR3uTkjKuOqHvmbIOBVkBqi63+d6OEWmBj4v2LJqSDosezOEetM+oi6p6pIXrKL4EissFY7s89OsMI1slEoS9mneT2gzzKwk9szAFwsA2L70TMASq5Z3+cLdNF4Ubk2St4+Xc0enzbL0wBuJMA2X75pTVLztAMaKFX9PlLXjKgiBxP5hBPR3MDTut6r0p2MdmLhFzJ6TJ0hY8CVJM4ypd+PKRwxsdjN5lIU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

On the rollback path, folio_put() has already dropped the last reference
of new_folio. On the success path, new_folio is already unlocked and can
be freed concurrently. The trace_mm_khugepaged_collapse_file() is left
with a dangling folio pointer.

So using the folio_pfn() before dropping the reference, closing
use-after-free window.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Fixes: 4c9473e87e75 ("mm/khugepaged: add tracepoint to collapse_file()")
Cc: stable@vger.kernel.org
Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 include/trace/events/huge_memory.h | 6 +++---
 mm/khugepaged.c                    | 4 +++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index fa828967e1fb..5fb4d92cfd84 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -211,10 +211,10 @@ TRACE_EVENT(mm_khugepaged_scan_file,
 );
 
 TRACE_EVENT(mm_khugepaged_collapse_file,
-	TP_PROTO(struct mm_struct *mm, struct folio *new_folio, pgoff_t index,
+	TP_PROTO(struct mm_struct *mm, unsigned long new_pfn, pgoff_t index,
 			unsigned long addr, bool is_shmem, struct file *file,
 			int nr, int result),
-	TP_ARGS(mm, new_folio, index, addr, is_shmem, file, nr, result),
+	TP_ARGS(mm, new_pfn, index, addr, is_shmem, file, nr, result),
 	TP_STRUCT__entry(
 		__field(struct mm_struct *, mm)
 		__field(unsigned long, hpfn)
@@ -228,7 +228,7 @@ TRACE_EVENT(mm_khugepaged_collapse_file,
 
 	TP_fast_assign(
 		__entry->mm = mm;
-		__entry->hpfn = new_folio ? folio_pfn(new_folio) : -1;
+		__entry->hpfn = new_pfn;
 		__entry->index = index;
 		__entry->addr = addr;
 		__entry->is_shmem = is_shmem;
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b352c1330f8e..e13d233b9967 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2260,6 +2260,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	struct address_space *mapping = file->f_mapping;
 	struct page *dst;
 	struct folio *folio, *tmp, *new_folio;
+	unsigned long new_pfn = -1;
 	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
 	LIST_HEAD(pagelist);
 	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
@@ -2279,6 +2280,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	result = alloc_charge_folio(&new_folio, mm, cc, HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
 		goto out;
+	new_pfn = folio_pfn(new_folio);
 
 	mapping_set_update(&xas, mapping);
 
@@ -2682,7 +2684,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	folio_put(new_folio);
 out:
 	VM_BUG_ON(!list_empty(&pagelist));
-	trace_mm_khugepaged_collapse_file(mm, new_folio, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
+	trace_mm_khugepaged_collapse_file(mm, new_pfn, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
 	return result;
 }
 
-- 
2.53.0


