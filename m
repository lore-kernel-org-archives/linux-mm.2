Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58102CD8CAA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 14:39:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2BE16B00A0; Tue,  9 Jun 2026 10:39:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C02F06B00A6; Tue,  9 Jun 2026 10:39:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1A006B00A7; Tue,  9 Jun 2026 10:39:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A46476B00A0
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:39:57 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 75FED1C2BC4
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:39:57 +0000 (UTC)
X-FDA: 84860633634.25.D67E5CD
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf09.hostedemail.com (Postfix) with ESMTP id 835B5140011
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:39:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=etEknEkV;
	spf=pass (imf09.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781015995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xjikVzeHQvQn86OhIn4rkOMRYcykRqfrspB/jiiXnos=;
	b=4IYrBJvvSWA88IsQsCOqnoptxL56DAnBzg5JZm4xBndkkK1B+CoZKSAnT06zaVM9kjYC2N
	b3pZtkUQNlaOT17Yt5GF7uG2wDvwWDpu/tsylsGxEqvopeI7zo7Q2jY+I+VHUJ/mQKUv1H
	qcWq2Ap3uJLV90BSfyV9aiNLDsP/9ik=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=etEknEkV;
	spf=pass (imf09.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781015995;
	b=b69qQwOYkiYBDuIWr+2g119uYWvQJSm8EB78dzRgan5HKMuTVejLIaJ7pyTQzXqcrWpmg9
	lNrFVaKE2G0FvSvTJG4JXwuSIb6hpBZNpFaaHpedrnYkC/bmEJPZjDk7FsKSFhVXr1f/Ak
	QQ/lvQloAci4qeO89bTWSDEckq9Yty4=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-841ad134423so176584b3a.0
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 07:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781015994; x=1781620794; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xjikVzeHQvQn86OhIn4rkOMRYcykRqfrspB/jiiXnos=;
        b=etEknEkVC9tGWMCjA7I8oIMAE0BBwlHYSHZRY9oDXdJu3WF/fvXoHwjL0ZcZjUUV/c
         +nYrgkpuVn1Lgs+PBmrhkeq/BUc2zOy/h8jcln4mdOUifgePe2aVWlXiYvlKHcODvwXe
         o8lb2RyQtmyUzpFKhgwHcEuoV9lDtmHBkFcDGHt1SEkLlUO5bLFZabdwU5zpl7mvI3KQ
         JVP+Gefht3cj0nRX5B0cuQshEi5Ov5AFLkO3/VZQcMlei8Ho0lPBdoF1PZwmw3q8w6Sf
         nCJ0oWx3AorVFd/aju1IDBr6mqECC/8cdHUed/FID0C7nwkvknUGJEaKPkGOqemkLFx9
         PxrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781015994; x=1781620794;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xjikVzeHQvQn86OhIn4rkOMRYcykRqfrspB/jiiXnos=;
        b=UhfwZhVQJ098IZ9Pf4ZB0tvdeQGsFn0dtf5aAFfaVp8AM4iKsSkEeFDfBflXDt6e8y
         iNZKBQbBAmD86df5vhWpZzmLYh2UGjoobK9HS7dTCRzUceFpMJ4KCr9143LPSq/vETeV
         iJXEJatsZXErXNu3uTqhulNOONsuv0hwrvJiAR/ZG9JyiNU9rBtrLZ9xq7OEZXeXw1YX
         EiKl5u9Qus3I1QJgMtRvil6dKrYhxNEwy6GMUAqM56fMagLqIFeWQ3/HGJ0Woisi6sFI
         UKtWfQ4e0a/H+vlCGL937LJ4TIiXpEcHy9V4gN6ektetl8rKZbs7/HGAM+u4KM9urkBY
         bQjA==
X-Forwarded-Encrypted: i=1; AFNElJ8hBMfxTNl/o7nCYOmWQY7f/1JTAuBKKZFxPVwwAghbl4l+s4OHMr4y+YPkyOIrat7K5G9vSPfXPQ==@kvack.org
X-Gm-Message-State: AOJu0Yy8kUct0wiFeQhNt/bk7riTS2RKKsqckZsVtaTp+4kfT+JNk9lA
	tmuxcYi8WRyItfXco0fzj5tSTrw8JRr5k9B4vTcbPToQ0cD9/ijJMfu3
X-Gm-Gg: Acq92OFibzIpi1Os4WSkvVTUhV2frYmn72RqJbNSX9dIoWUYasz1rh6mj+w5ekH3D4B
	OuIuh6P6agavzuEd2MSBJHeEgRE6g/LlHf4uXowOVY9gn6VKC82kSF4HNJ6JQv6XSO/Gz1QOI6C
	b4gTkTEEfbDuhEvyaIrDyMXB79oBrXES/7EosdYDuYLiulfI9UW9GHUeVRN0hrTDta1olEh2vAa
	nEXrnDiS2yXqSHPXbdSN9YKUF3vk2VN1wkZUJGBbXnVTBcnXVwxMasTh9QjVVFNgXc5skzqE20v
	zNGgBDRyDkvmbaqp5pLmo5cT7OH7+3yVS7lRjKZGGVRYlwxRdp9z9Wq1bYH4wZuvahQNMqoVqHF
	UZUbO8UKq3d1OI08NeYyPm+ZycXcYiQhQP/CmQXbVWyCSq7jHdu0VvtEhxuIUVJ19EAMIj1D+Z3
	NrlRDcLH+Tu1aDj6xzz3oAJnnAub3XFJvZpnmMKxjlQVNu21AQBe1KWQlWtFQvNYut4qHZMwf6Z
	gDi22L5gjGJTvrqvzNw8QxA
X-Received: by 2002:a05:6a21:699:b0:3b4:82e5:b906 with SMTP id adf61e73a8af0-3b4cd424041mr11738801637.3.1781015993812;
        Tue, 09 Jun 2026 07:39:53 -0700 (PDT)
Received: from o6.lan ([188.253.112.242])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c85df0b315esm17939677a12.26.2026.06.09.07.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 07:39:53 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	hpa@zytor.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	yang@os.amperecomputing.com,
	jannh@google.com,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [RFC PATCH v2 3/3] x86/mm: make pages read-only in the direct map
Date: Tue,  9 Jun 2026 22:38:01 +0800
Message-ID: <20260609143801.7917-4-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260609143801.7917-1-xueyuan.chen21@gmail.com>
References: <20260609143801.7917-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 835B5140011
X-Stat-Signature: yy34o18z1h48utxib14dtn3zwqa41o5p
X-Rspam-User: 
X-HE-Tag: 1781015995-178382
X-HE-Meta: U2FsdGVkX184UPdAeajCBNBOYCvgtUwmt4J1vI7U0TNxmsujlkKMXbf0e3quDRGB9lVNyOVqdyjjcSUJGRYOkeo1PLKnmRTFfQ7mTnPQdTMTsHZktfFd2Il3ErGtHYpDST3mjS+eCqBhDgC9itUhtUI6TnsZWl3teB5q8UnAaHwbX2jk/8zCDe15zHE+xAHcEH5Q5i/jM+tmYomQ3yI1+6y3277xPspOTHmfh/P9sqs0Mf17DpFwNvazfVWFlmJhOgvDhn0/BGT9V43TWUeMpUnR9iR78OnDw/ul91dhY7LFYmcvI0K0q9uxdFH1TAjjeHymDbHT9R6FhzROhGChrcrA8VLomSpQ58x6jqO8k3jiP0QvNlrQRA8v/CqMrwPm/eBzx/8fwK5QcsytGA+NWstJeI72FrxePSPDerwKmEhzaKzAzI4bMAaF0dh/MWYYmfYT3NI4CmGrBBa5y9u5CYjXw1ou1b7qmzTXUGd5Q22aaMw1lc7ZtCLYQYpzHLNN98+qI7JW2gX8bwOAnzsd16464fZTU6ZsT/0JNYuiu2Ob9kymQknkJUkOEl//VRT8Zb+heYRBEeFXBZ70gmamKpi5B7E7A8mHy1qGV/ROSOEU20PCjUXZMlDr3TW2iXwsC3ZkuDot9tOZ3eSkUHdF9wNC5M7xXdxMDEc85rmtcELlfgutiU9VZQweGVFTnF8SxArrk7ggC1DKRU+pGVAsTMNDOZsj1V/IvduEkk4SBmgira9pJIKyAtYTAc3oD9LM+Gf280vat7AsxlIcHHNe/OMh6JFCTFI0YP63HHndOlSwqWuE1ytMDRfNYYXxRvmLFM/AoHwMtDkFUiGXPo4yLpCzL2/OFj5C60e/QlT39ZDCdc4EpnWeSSjiuOrb0Mhwm3dCjgLsqIdDMJyzYCo24lZbWj1M4ujLe8Jr960t6RGfJ4gzz1OdgQHXp8BQJYIpeyauh0qwm+Uq223rYVn
 +UHgHM7p
 xCHp4OEQq3xsFYRdY0Rd2Pgal6/GUjUmxaXRmtyKd5HVsOD57RXC15+qP9TUQinmYHOSSz7GmDGvm4Iwkht3XX6ND1WoDO0rjD7r5tf8wXf8uUIk1LJz0ConuuPnwxvFLzMpgwEt7hQWd0CsALZSvqxmWV2xRJWlp3kQg74cIdnkep+t3y4Oj0L47s3HsmO+sYQTFOKKLGis7W+TpIhGxl/8TPXfR8GUTp8Eb5cE17JiubiukgsMjTP3zxPnmwgyFFGT3DAomZqX1U5OSQ6MFBPKEhFr7xlVMpdCI2QqfrsWToMxWdwYiXEEsGPEKjcksR93xJPF6etoPYKinsi8J+jqYxCO4h1AxHuvydjzCATiwIGQo3N4AWQJga2treVlaaLuA9/lHn2a9FbyUnhmZqFpHIyjDR1oGeOV3L4Nu9AKV3Shc9LXvVzYf50ZQw17NDTnvFWeOgxwsBtrn3rrgQguHHKtREt7M2Tb+8o4Li6VLdv2euas04xcxV8qFH/iwWPR1pe9AsyjiB8ijcqu1SSmHmJkYVEbC2VXuNdN4yleKvX3MiHMjgiuMvWSep4tIdrNcQ4gaMbjNhwlB6I5TimxTeqoW6q3Jpxn+C0cJE3EMw+8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement arch_make_pages_readonly() for x86. Make the corresponding
direct-map range read-only so unexpected writes fault instead of
corrupting shared contents.

Reject highmem pages because they have no permanent direct-map address.
Treat the set_memory_ro() update as best effort. If it fails, leave the
mapping unchanged.

Co-developed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 arch/x86/mm/init.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index fb67217fddcd..ff0a7003eaeb 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -3,6 +3,7 @@
 #include <linux/ioport.h>
 #include <linux/swap.h>
 #include <linux/memblock.h>
+#include <linux/mm.h>
 #include <linux/swapfile.h>
 #include <linux/swapops.h>
 #include <linux/kmemleak.h>
@@ -38,6 +39,14 @@
 
 #include "mm_internal.h"
 
+bool arch_make_pages_readonly(struct page *page, int nr_pages)
+{
+	if (PageHighMem(page))
+		return false;
+
+	return !set_memory_ro((unsigned long)page_address(page), nr_pages);
+}
+
 /*
  * Tables translating between page_cache_type_t and pte encoding.
  *
-- 
2.47.3


