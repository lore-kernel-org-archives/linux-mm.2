Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCDE1CEBF8E
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 01:47:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 277818E0030; Sat, 15 Nov 2025 20:47:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24C9E8E0005; Sat, 15 Nov 2025 20:47:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C83E8E0030; Sat, 15 Nov 2025 20:47:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F08DA8E0005
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 20:47:28 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C775D1A087E
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 01:47:28 +0000 (UTC)
X-FDA: 84114782976.01.7668F04
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0CB9E4000A
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 01:47:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0lM0cn8o;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3LS0ZaQgKCDwhgYogwYlemmejc.amkjglsv-kkitYai.mpe@flex--jiaqiyan.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3LS0ZaQgKCDwhgYogwYlemmejc.amkjglsv-kkitYai.mpe@flex--jiaqiyan.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763257647; a=rsa-sha256;
	cv=none;
	b=V1goyav4BYPbQ7IrLLI0RBV9jxPzOOgwOdIBE/tmGt6hLWcoPEFjCZRWnGOXXcUDmciZZf
	MFbAoqHMbT397NsOYgyrwdma9lr0FQ1MNRhBtN+OOVBhqz6djNMntILk21ov1Nmd8p/2Pl
	tCww4JqduSwuCasKpRXNsaNTgMNfxzY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0lM0cn8o;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3LS0ZaQgKCDwhgYogwYlemmejc.amkjglsv-kkitYai.mpe@flex--jiaqiyan.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3LS0ZaQgKCDwhgYogwYlemmejc.amkjglsv-kkitYai.mpe@flex--jiaqiyan.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763257647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8iahc/OE7c9HoKRDc0duvnCB5sVq2ZelHCgN4s7hCPM=;
	b=Vr6EwPxyQa7SrBxPbbBNb9OlMpzrpSAEnX2Nhwk5/a9zzxKcO4hv6tKA+3wG/Xn+BkVPXP
	Tb7pgfiabH4DZmrwWo/aaAG9XlLDW9y1zBKeX+CEndILAlytURT8w376DoE1lx0t1IEjWe
	/Kj6Xsac8Sg8iU7fRq2qst+bIcro9yI=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-343fb64cea6so3554998a91.3
        for <linux-mm@kvack.org>; Sat, 15 Nov 2025 17:47:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763257646; x=1763862446; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8iahc/OE7c9HoKRDc0duvnCB5sVq2ZelHCgN4s7hCPM=;
        b=0lM0cn8or0PR6FJEOALvoY4WrWULOkemHftGB0yUgQxncmjrJnISvoHNl+OHpLHcYH
         6pIC0RKoUnCp1pV1U4D9BcfCba/uk/e/BZstTF15RHKs0WqAI43iMi6xICLb7yzokEgt
         xFUYEEGEz+5RpHyj0vRTjQJAbDlJcg2IprN8foevhdB2KDWy1/JwUxd/W/qvbnHqabWq
         R7pxA6JC4WysbI7G3cVwTkxKFe/y0/3PrAxkk2SoojnCyTwTZdbEsbxDqVYjBKNzWUe6
         HEUGRbgF44mEWqZdt+0jQfndvLON8sLqd3L3wNPvb/AQ+YWoOmHwOcCYqo3DxHngfMjx
         NFgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763257646; x=1763862446;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8iahc/OE7c9HoKRDc0duvnCB5sVq2ZelHCgN4s7hCPM=;
        b=Mrl4zPR35TIU9cn+xu+cHLD62oTxUrBFieJYvSr84Cmw8t0x6K8EC+I+HBvc/9A/Bf
         hp+i42q456Y7FgpjYiWnqkJy+D0HxInVWtRzqORvBxfml/kQdNM/xFB7QIE1xpXYeO+O
         bl40dO5jKibo6RHWmjo7uWEhR6jMMatrIDILipvZkIVyHgj/JsItape/cYZdroixUhGl
         cX89URkNntLURUn4qqFLNup1rrauKuB6OE6LNU43nqNx1sdxYKBUJcYDHLypiTCQK/lb
         g1q4bU15NvsU1Xj69e80VJzk1oCfHjskKPzlhMS45UEFk40KJQnr/jSSb44NsUlY3rNY
         91bg==
X-Forwarded-Encrypted: i=1; AJvYcCVVQUTETOTlwZfR2y1VMilsJLOQcp1UCm4YaA82flhQLuuZiiLtMpotjn9BacWfIhsgTPHNjxXByQ==@kvack.org
X-Gm-Message-State: AOJu0YztQ4WJTcU5FJ4cemeK1OTuTJA4qbdcOHqEJzKM84MrufsIpe1K
	o/ka7y1t8ZLhcgHIL0Mf4RwmnzDoqP0OKDTax2OKgJPHxiughEV3M6SH1AFtfPt1V6gQpwC1qYt
	hZ5ydJV+pOQktGg==
X-Google-Smtp-Source: AGHT+IENVvEwJMRWsbG8t8DKamJf+m7Kq67/5OJ3seeLWXwPuYI2slv5FtZcLQnrkEJ74Z2KnexNe0JoOpqTUg==
X-Received: from pjod1.prod.google.com ([2002:a17:90a:8d81:b0:33b:b692:47b0])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1a8a:b0:341:69e3:785a with SMTP id 98e67ed59e1d1-343f9fdf8efmr10663049a91.16.1763257645886;
 Sat, 15 Nov 2025 17:47:25 -0800 (PST)
Date: Sun, 16 Nov 2025 01:47:20 +0000
In-Reply-To: <20251116014721.1561456-1-jiaqiyan@google.com>
Mime-Version: 1.0
References: <20251116014721.1561456-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251116014721.1561456-2-jiaqiyan@google.com>
Subject: [PATCH v1 1/2] mm/huge_memory: introduce uniform_split_unmapped_folio_to_zero_order
From: Jiaqi Yan <jiaqiyan@google.com>
To: nao.horiguchi@gmail.com, linmiaohe@huawei.com, ziy@nvidia.com
Cc: david@redhat.com, lorenzo.stoakes@oracle.com, william.roche@oracle.com, 
	harry.yoo@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	willy@infradead.org, jane.chu@oracle.com, akpm@linux-foundation.org, 
	osalvador@suse.de, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0CB9E4000A
X-Stat-Signature: 3s9r777qrqmy4xfmgg6afx485qgz6hmb
X-HE-Tag: 1763257646-712728
X-HE-Meta: U2FsdGVkX1/WwmuZ7AM3DvTX07aU/gZWrQ949ukeT1jOg13q8KgYBKRlUTkTffpHCD7E8LO3eNIR1iysyEbkKFZTBDi6Vrbam9IRxPjVV8CosNVzEUji80Tld8DOa894/SrTcKy0Ga/DHP2NLNhvzs470pIZHY/dWWYuWojNSGFiX6uXzNgbZhJxYtZiE1Vag0MS5WP2x5ZsveZ92+b0Gj7Lqx3aTNyHzNMcdf9Cu363918cMWPdFzWGAwJgjNs2heZtobYJ6rv7biQ2e8zGNZkLyX1Q21TY9dxBpHGA9At/dhvGwrsYCZHhGikd9bdZz1x+zIWXUSuTdgjgcEFTAzkAjXDnFcFkwrpcmmMTFQnbDUX7CFGukXB7ujAtleV0+GwadgCvXFQGfEgRYdMrgTpdGHqDhFtMdZWPkyplUxNW3PkeXbce7GjK8t4i20zJNQNqJSAn6jBsIo7uJ5Qwww2XYSiiEeTkF/Ysfzds2+H6Yj9BqUbuwxFUSx8YU6KPfSWeIXBlmr1kFJdvp/PQyxFKdQVs44IwwkYLIntc6HuRtSDoEnO8gCruB8AdpwFM0Ps89iIjag8zpILb/JHyJSMALSrHrTm6RKmQcI3O6LX1qqogPI1XEwroWH8oFno5kdhhl0s7uP0ykvISaqQXLCoROczTiEbyNeiHF4PJd8dDqISqOyXu7f+1liytLOSeMEFjgLLapGlVUhjCAYSfpwlBJ+9zdierPbik7audiKoKfdaPpjcvIDTYX3NxIpfTPI6knnkovulvEw0Mr88bPyAqM2nk92ZUVmPuSRX+E7eQdIgmnXulQnYkfwUQ4bDUQUFBDUiEa3J51j+DoBmPAvy2dJst/x3a/Tzx3inWsOr1qTEgRtAsxE2LPBIca73XSf3EYToHMkQPNKkgV1MhD/czRdnX4+uo1RKhuikBAxifxOxSYj5jDQN+hxSqpK0mh28axsCQmHPJJmg8xtF
 qF7t424z
 bjTAmtOWOxF1szKAu19H4WRvX0v2JUm/zjHCMArqeal4usyvjfZHLWm8t86KB4wCCNDHgsXeDiRW43vbHE/D6vNBgHKNoQNKFBZnp60LzUrAEgNDLlU3jK563PvsoDPFqKED2hpi8aoBF+vl8CF6kRaph2QQSHh/NYFlRib9NqQ2aXSR2LsLBv4aUjRTVWdu3J+hmVC41ph0ZdClXtetfLFi1/qgh1qp8RSBQRq9nuz1Qz+T1HdR8AR3YbgDJW0hDLfcI3bLhPSTXkjhnHGBjLPVtMXaCW8FcjEyGKhaLT4qCj7aNneFia4Z7ewl1cns9JpwV6in6XingXczYQDnkkCW5WUgT2MeQlzncKThlfk8gVMUICDBaOd54Jn/OrNq9qLg/WaD2qanNWef+GrJibG3oEIJ9PnY9VAX+Y6Sv3Y+SLabFWEmdvrVU7GNJGzqNkQ6hv1VOfcr9lcAdyw3J3Vmh/dW7uy5fB05dz9IdAG3AiKngzAL4O45jb7NrpxzSH73ieGV6elqm+KIq4MIUjhQVrzt2OUkykl9jsrTw3l8LVBxlNyjyaCq+LBJBwH143zcHmgbwO0tvYi/xLdWCzo3MUccZu4wjyqwDvvA30dXQWNHtI3XZmDAFkPCMjk6DtYBhdgVq0HeNutlj7CtGKdfFcb/EZDR35UV4kmKIgNhxDChg1XVF0oHNZx7AhZiBOiNzvuEhWqZ44tY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When freeing a high-order folio that contains HWPoison pages,
to ensure these HWPoison pages are not added to buddy allocator,
we can first uniformly split a free and unmapped high-order folio
to 0-order folios first, then only add non-HWPoison folios to
buddy allocator and exclude HWPoison ones.

Introduce uniform_split_unmapped_folio_to_zero_order, a wrapper
to the existing __split_unmapped_folio. Caller can use it to
uniformly split an unmapped high-order folio into 0-order folios.

No functional change. It will be used in a subsequent commit.

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 include/linux/huge_mm.h | 6 ++++++
 mm/huge_memory.c        | 8 ++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 71ac78b9f834f..ef6a84973e157 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -365,6 +365,7 @@ unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long add
 		vm_flags_t vm_flags);
 
 bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
+int uniform_split_unmapped_folio_to_zero_order(struct folio *folio);
 int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 		unsigned int new_order);
 int min_order_for_split(struct folio *folio);
@@ -569,6 +570,11 @@ can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins)
 {
 	return false;
 }
+static inline int uniform_split_unmapped_folio_to_zero_order(struct folio *folio)
+{
+	VM_WARN_ON_ONCE_PAGE(1, page);
+	return -EINVAL;
+}
 static inline int
 split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 		unsigned int new_order)
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 323654fb4f8cf..c7b6c1c75a18e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3515,6 +3515,14 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 	return ret;
 }
 
+int uniform_split_unmapped_folio_to_zero_order(struct folio *folio)
+{
+	return __split_unmapped_folio(folio, /*new_order=*/0,
+				      /*split_at=*/&folio->page,
+				      /*xas=*/NULL, /*mapping=*/NULL,
+				      /*uniform_split=*/true);
+}
+
 bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
 		bool warns)
 {
-- 
2.52.0.rc1.455.g30608eb744-goog


