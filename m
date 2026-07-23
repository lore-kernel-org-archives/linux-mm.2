Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2FA7C44524
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 07:51:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 814716B0128; Thu, 23 Jul 2026 03:51:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C5B26B012C; Thu, 23 Jul 2026 03:51:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 702456B012D; Thu, 23 Jul 2026 03:51:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4DB916B0128
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:51:21 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CFC1C1203D7
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:51:20 +0000 (UTC)
X-FDA: 85019271120.22.13E94DF
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2457D100003
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:51:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uGRO92cK;
	spf=pass (imf14.hostedemail.com: domain of 39cdhagcKCGYNcIWGEWKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--jyescas.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=39cdhagcKCGYNcIWGEWKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784793079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5YYey/5Hv4fNNykpHycfCnNQ7fymswCzBiRznc3m07I=;
	b=v90yx5blVQ0kOWneBdbu0qTNVn70zkuF3ZinjCXSpl/DTSZi+EJVijKaaYcSRGN7pCepi2
	WlzIjENcB/p3C4k/++T6REoEx4eYn6ZCen7iQ/vwkwEDFsXiv/GUVHVQk0T2eaVl4eNZ3H
	iVTTjFZPpVri9EjAWBpBgEs9Ilroxhw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uGRO92cK;
	spf=pass (imf14.hostedemail.com: domain of 39cdhagcKCGYNcIWGEWKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--jyescas.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=39cdhagcKCGYNcIWGEWKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784793079;
	b=NBZrzj3yCGVh4lPFAH0oiDByQWpi6e/DSCkGPgadSTlq5lFHStbJo8Pz3/vrXUQlH9R7xB
	AudDt7EnoYccvc9xNn79aQi1wjcPsqyYGlNJCokbqMft7v0ALhqpxnhmPP3z60WovTuFzp
	zj2XnIF3YRQ8d1ys2EnT60jHH9RjS7Y=
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-ca6bd8a190cso624290a12.0
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784793078; x=1785397878; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5YYey/5Hv4fNNykpHycfCnNQ7fymswCzBiRznc3m07I=;
        b=uGRO92cKUqYAzPUeWuHhyusp/am9MHPwt0jVI6Nk1YVu4NNl4ecfRXgu0zPvGZRCMB
         4cPqanGVAMMdEM0O80aJNekwgC7iduU0Y45txCURRdlTBbC6gkWOJA2f8UblhR0Sw3o0
         x3hGZvolLzgomhqa1UyHMjPqOor4vsLdHoCZYGMu3Wc70rD7sN2UlgQmSoykQ1Qn4B8K
         c27upNZJ1l7ghE5ieE7NdnifbzdULAlgrJ7FlGnaq3IMj00mcgVABrb0oNBahn4L4rgB
         mjGy1hnCXpDqnyGoRq55Ep9p4s41KrF9msQ1yClmbfgE8e+Uk5kaChQ4krBJZiymwLZx
         AjTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784793078; x=1785397878;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5YYey/5Hv4fNNykpHycfCnNQ7fymswCzBiRznc3m07I=;
        b=LICcVvogkjLtoCBUS2GjKKidku+eHc3gqE6ApDGPq0erwN83p5dXQv+baY8vj6TnSF
         eQSDRwLVin/Mhy5L30B/G9wHxiOJNDN1ADdOJ2hkziVKjufZqVQioT+tWqWAgFc/h6TQ
         yC4NGnX3IhTKAu/iytVuLdh7ApKzNuAFB9DzZzFYVZzW3t37SbGMtfm5ZmW4DxxjHZ+r
         eBuVHfNP72VN4PS8NsIe4WNun9jyxgZXpRv78iqfJXNNYRssQMSVje6rfwli1IO2pzSl
         CIvA6t7ebMd50h0dE3aS79E8x+7E4IcceGUmH0v6dCmbJz0Is/5T3WNkADgQZxPXcARv
         fkaA==
X-Forwarded-Encrypted: i=1; AHgh+Rp0pMNu0rbZOqcFJTROZNXOOrwVSskJBEnmBVR+RSPXEkqfCWeEpYNPIiK3EOMjdTcwQvCW4hC4Qw==@kvack.org
X-Gm-Message-State: AOJu0Ywu/4si/9IXJEJw8vX6fHh6qkCho/A2l6V6skg8K0FxApG/qi9x
	CAIpuapd2DkhqzytPw1de5nux8WUyxEjUj9jin1VM4Q+WM9vpvopMQb25u1TooogW4oWgg/2kKQ
	nYrXGSkQ04w==
X-Received: from dyvo21-n2.prod.google.com ([2002:a05:693c:41d5:20b0:311:4890:b1b9])
 (user=jyescas job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:7a96:b0:3c0:9c19:65b9
 with SMTP id adf61e73a8af0-3c44b26f282mr2124168637.65.1784793077775; Thu, 23
 Jul 2026 00:51:17 -0700 (PDT)
Date: Thu, 23 Jul 2026 00:47:20 -0700
In-Reply-To: <20260723074854.1013941-1-jyescas@google.com>
Mime-Version: 1.0
References: <20260723074854.1013941-1-jyescas@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260723074854.1013941-17-jyescas@google.com>
Subject: [RFC PATCH 16/16] mm: Release resources when the page alloc hogger
 module exits
From: Juan Yescas <jyescas@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Cc: jyescas@google.com, android-mm@google.com, fvdl@google.com, 
	tkjos@google.com, minchan@google.com, dskiba@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2457D100003
X-Stat-Signature: bemowm89pq7dfx941w86sqtqw4zj4h45
X-HE-Tag: 1784793078-42697
X-HE-Meta: U2FsdGVkX1+jcigfYdFkJHcGItvhBBCY/9qndKh3d6NnnbGffFgT78+vQRgFl0jT18YsH4S2LyoC+xIFaKBI7GRfBEGYKh7dEAOxeBH+TldsAcaNrboG0hMFY8y6O0ew17uoM+nCK01EHv8I19xGCooTFEQCBEFOY75P9qkHFPRtzsJ6N8UIjfgpghErnK/yI4CHYqZzoYGNVpYUyCnIKJPUB6bEGQaHrjE6d1JEFE3btEt6lmW6JKoF2D7iNPSEr/q7fiZfi27Y3OJQa86g3tQdRsQWocOXlGCqcxWLGeyszEni6rJF0CJxXlVIc01hcjQPXc5Cyyy0ZJxU1r6/KiwmuAaAstlvEDvbtYwcjqOiXCvGqdSfUm9yjV2tZyh7wd/qYtfR0TarBUX70K/0bqAbENNaG66j2F8/sghfQnH7FJYIpx+WVmIvxlXnyqxmPkEecgiit4HGkEU2Qx6ca454NMIc9aTcTd2t7TpBNAICaCCi3QYXgf/9TnrIBLgo9wStm/lY0h/v+y89Jn/jkB1eqlMonoAvkCW3Ylzyj8DpG6eIZdfFEnZoxmsluKITnfcCaKvaqT5AXiTkC8Ik6ZCmEZmdeeSoogNYDaMbxXEAmqgVRmqdifTNNK8ncs0GNB+SLJg94PF2Ed1G+gEwjqDYuJrO0QStm80cXXmtveyMQR9SgnvpsIfN33fh/dmWZK6+Vg/s/INC1n6AbVmOw0Kl4b54bAnfMMFVxuGj/Ti286eXxQegtTo4WdkekW3dLmMT80cCrqoa0nVCXPgEkyemuRdrz3eSamydEQkRioWPW0EZVj7B/5dQmtwQflfCrCL0o+9hd2XyPNy8QxPcZnDhUacSpeS+IYCEHvG5EyXioqDSOsCV8uD9IeaHAOn1MenaHQIgbSqR2tlotw2KYptrKNZvmJh3rA3oQupvB43EySlv2C2ctaZ4Buzvqz90c0+YKZomN/wT6P/x4JM
 lQFFbIed
 eUOjidpA6WQ2mUPBW5QNs2wPaDFAktGG0s69Se7FWzfY/N3cqBLOEAfqass9khbqqXCUDNw6E5D7BnfTA6J8u7A7pAN1tBwk3o/4dih8itcAEBy/jNM6H+1JqH0GmuoDPZpOStEAjEBNi8asFzk/RDlxPCt2XcbJPWkE530twAWitCaGa0i/NYTOn9zzZF+L65KSM7OgqQXhOPm05WZCUkaK43ZNSwaX888Y10AhSH3LfZqHOBCXjvOVAlfWhzWuBGgHz6Dz/ZWBnOKe9G8tGrDpxNnRGRRlJSCYPQOCLMh0L+VMEAskXgx15lM2dAMtEMdy/PH3ThrUfEMiLCDa1fEjpGTHB0Sv+r0v2jW6JdCAnlC7I5UH5ZWteMay5wxXPCI9/MwtOSxBL5xWeYUCJbCIr6URxGeD3ozcoZaE6y2FRIYLA+49T7HEeLWtjiuW8NRVPGuIOZodHAe2nzfCZtl6FI6WKgbojb3FEYe70yrM9FcNkHIdCGOlchZ6J7nYlJW8U1ey7pASBOJX0icYGoJu/5VEIuckpGmKB7HWfqHN76pJ75PG1mHdYpA+HoY/bifNPwrG0oaEZlSKODbIu8Kreroj++arh1zWYv1bcYGi8N2fS1fRZfyIvPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the page alloc hogger module exits:

- free all the previously allocated pages
- Erase all the entries from the xarray

Signed-off-by: Juan Yescas <jyescas@google.com>
---
 mm/page_alloc_hogger.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/page_alloc_hogger.c b/mm/page_alloc_hogger.c
index 5fe9c545e884..f554bbb4afa7 100644
--- a/mm/page_alloc_hogger.c
+++ b/mm/page_alloc_hogger.c
@@ -590,6 +590,14 @@ static int __init page_alloc_hogger_debugfs_init(void)
 
 static void __exit page_alloc_hogger_debugfs_exit(void)
 {
+	struct page_alloc *pa;
+	unsigned long idx;
+
+	xa_for_each(&allocs_xa, idx, pa) {
+		__free_pages(pa->page, pa->req_alloc->order);
+		xa_erase(&allocs_xa, idx);
+	}
+
 	debugfs_remove_recursive(mmdir);
 	kmem_cache_destroy(req_alloc_cache);
 	kmem_cache_destroy(page_alloc_cache);
-- 
2.55.0.229.g6434b31f56-goog


