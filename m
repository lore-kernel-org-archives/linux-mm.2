Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EA8ACD5BB5
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 19:32:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5316F6B008A; Thu, 21 May 2026 15:32:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46F266B008C; Thu, 21 May 2026 15:32:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 224B86B0092; Thu, 21 May 2026 15:32:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 109E16B008A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:32:07 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CEBEEC2640
	for <linux-mm@kvack.org>; Thu, 21 May 2026 19:32:06 +0000 (UTC)
X-FDA: 84792422652.07.520141F
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf26.hostedemail.com (Postfix) with ESMTP id 15F9F140010
	for <linux-mm@kvack.org>; Thu, 21 May 2026 19:32:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=M55lp0U2;
	spf=pass (imf26.hostedemail.com: domain of 3s10PaggKCAQwole0eneksskpi.gsqpmry1-qqozego.svk@flex--skhawaja.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3s10PaggKCAQwole0eneksskpi.gsqpmry1-qqozego.svk@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779391925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Skwk48BYilyHQDMbYjOBqYYKx+CCGojb2mWZPJknBhk=;
	b=Iox/0KjnshxuirCZUwawik4FrfCp5mActylHxAw1K/Av9tP4AnNLV2ILVv60M0oysK0gfQ
	tXOVwdaxTBS8/r/PMR7GzLA/PZMn0bPcqfxDXZ1yjeWsVU8vRoQB3xCkH5gCewJDK6KkDE
	3+4aqH6iY4gAhSF7P/t36deFyD3uIwk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=M55lp0U2;
	spf=pass (imf26.hostedemail.com: domain of 3s10PaggKCAQwole0eneksskpi.gsqpmry1-qqozego.svk@flex--skhawaja.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3s10PaggKCAQwole0eneksskpi.gsqpmry1-qqozego.svk@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779391925; a=rsa-sha256;
	cv=none;
	b=tpC0YeD18aASeGwjJiM+96EviD/FHWTdiXUelWhrBTWrvi2Oqu2y0dXxNM2snUm56sr8dc
	GO88vTFEUetOlm/wtXGuR4+m9iIxZOsB/WAGn+HGlQ9eav87w17PQCFgr4str+voqsnGaJ
	Y8Wjt4MA8wvXdr9fIfMLWkwtjqFWm1o=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c70ea91bfe1so3675259a12.1
        for <linux-mm@kvack.org>; Thu, 21 May 2026 12:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779391924; x=1779996724; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Skwk48BYilyHQDMbYjOBqYYKx+CCGojb2mWZPJknBhk=;
        b=M55lp0U2d2IxaP3dDHbCX579WMhOZ561jaN9snvSvVwVIYSTH/QGo+Ehe1AR4KHO7i
         V1PqkYucIMTjAP7XixybqxTfhYxPD/WRgwssjZOuT+rVDPKghVvM/MWPkM/aigj4ZQRi
         OGKjhk6CY9UPYMyGull9dpVsr9UDwrARgBzAWJPeOtD1UAu91GZn9iHVm8fP5Rm5KIE9
         vTUcQTW1cudCTuH4ncq5ZTpeoChrRAUefko/URuk0Xh3+YnrzTcoksCqHKksfq+nJmz2
         xIHhVo9sEdck6dqRyCNnv0u5usDpQEzbAUa53NYeP2y1rM2Wjdma9T0QVxEAtMKxnlTi
         Odgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779391924; x=1779996724;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Skwk48BYilyHQDMbYjOBqYYKx+CCGojb2mWZPJknBhk=;
        b=UQGZnvOUUQlbA1xpMg0T9K63Ysti5kRPJHadJ9vkSM2nviTud5omxiayjbuvRaIPk8
         OwzaeVu5Aa2zyf6Iz69LWiM6yRdPcVFOozZWUyt/n6FYwOkyCz21HsgSEuOsr/q9jeCE
         OJ6RhghdqgEc+mZb5D8JiH/JDCMn3fSpFe/e9o6MCPQCVPmOPi0rd3coCm57BM8iscAi
         4XnIQ3SVzojxj7ojs/WF2ygCJDVYXMvKu2kg4UaknRVB0UYTnzYusyjLqcdxCcnDDLAj
         wBdElGoFDhQXB5ykI1XbeGI7sqRrK3+gK1kJZNcwJINM8eStx9yW1Ujpn7OrfBI34FNt
         wi0w==
X-Forwarded-Encrypted: i=1; AFNElJ9ln+v5W4LvtxWL3odD4dg72RXXP+qyPQwtMUGgJjiY5pBf+NRDqivBOH7ZDIanhCqsTtFxzRU/Bw==@kvack.org
X-Gm-Message-State: AOJu0Yz45JS2JPCeYfR0AmF3WdZmxYgit92AP3PVNpf7NFgQ8ydIYy7/
	WejjqVzKOUoj31jMMPTirYKRqqUIBOnRoadmp522cHDpKI0nD1HVnhoH2r5AYSDuo4hGYTdzlCf
	mG9eVCVgsN7RE5w==
X-Received: from pggk2.prod.google.com ([2002:a63:d102:0:b0:c74:664d:4080])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:32a0:b0:39b:a997:9e40 with SMTP id adf61e73a8af0-3b328eeeac0mr350862637.46.1779391923585;
 Thu, 21 May 2026 12:32:03 -0700 (PDT)
Date: Thu, 21 May 2026 19:32:00 +0000
In-Reply-To: <20260521193202.746810-1-skhawaja@google.com>
Mime-Version: 1.0
References: <20260521193202.746810-1-skhawaja@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260521193202.746810-2-skhawaja@google.com>
Subject: [PATCH v2 1/3] kho: Add kunit static stubs
From: Samiullah Khawaja <skhawaja@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: Samiullah Khawaja <skhawaja@google.com>, David Matlack <dmatlack@google.com>, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>, 
	"open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 15F9F140010
X-Rspam-User: 
X-Stat-Signature: x5d6r448kz9to5y8sj786s8drb7ax4hq
X-HE-Tag: 1779391924-23763
X-HE-Meta: U2FsdGVkX1/JkdZ754ILB362NuCpRwIr+4rNYti3bcNLpI+6jRwR0dNAXxL4ECfBNBhM3OoyAZnCTH2uc9BmabZyq6UJhe+4zPfe6GpH0d1oaYuMweg5m/0iKtCP+M4MSRcGl2w4/YhRdWc10CgUvSGGPYyK0UBF1+3TELIVH2kZvS1JnmsOBNlAQz7aNHbnl2K8KXRYYYH1FY/7lD1aFWzH+W5hOXAVowyDRStFd9yV7AQ2QBF3TdJHFI54Q44gJTVyb7mH8rypCiHUelBGW9MaV8QINVGT8RKx506NKu5qXFHTFMagwBmEVt6Dmw7g47zL+Wn43FUCxiK10Zyvo09niXMXQS4haUjNJTy9xxGTwiNBIFohVJdKkL6aVGY4TUa553cwT2bTX+RLAEucHS1mBT9AX2SJRLmvtxvumOVq30zPiOww3BG+ugQfB4+X3RpN11Vnojqu7tdABeV3sZcEDB/4Y2ocndacsKz/jgaxEnj3dBra4UBtuJ76tuQPNBeFCf0Ab2zxzIxrCEil7QGLegHhPWe7LI6OUFLhO+4v9mDW2lkvG/PzUGt3ouq4uECkxQbOqyNKfRYNd+QVUmHbfPKqNyGRLsP2iNrew2wvtZnkFEvKCYkjguu/MZCHKYS9mHycuY4FlBNIszpnXhQiYCNjHwrpEVk/8Nw4sbCvDJFqOUUJIUH7Y1aspf232h68hLsAoPoNq/d08pJSLXvoIevxGXnxpuXGrE9YbxcP1JuzQ9rT3unAYNkumnx+SJEHUImRJC7CFD0p7z7uxHrsbSevp3IpHqg1JYBMdV3538VcKl4/nsdoWeWUoPtzwNDpmLNzxMsAZQZ+RT8HDX6LJaJT09/a3wOUD/0Rv5xFFBKcID0LMOZ08r4eVUggZbIpceoYE/4EyuNpu4zEBL7yfRekCLhYrgUDVqWyqF/hQdGP77KAxkGwjCQBuUzoAMhALqh0T0ZysYWuJUf
 ad/6J8wC
 dWKVE9F1snXc6gZ0M5xqQ9Ac4q2+YZKpMe10VrGJ69nDetjcv1d+t6JdQlft3SGlrCZvIjeX6mwWASTn5hOqkZka4FtJqicab4uoX7mWB2bGdATqrWZDTkioPsS5hfcXOZ6g3rT6qu4MZJVUFvfra81Rq8g0xUSTo5A5f9HbXrpXska3N/ACF76GelUlkTNEYxWi9LdLBWCjI2sNYtsoCR5dm5eu0N0aOOpZfnC7gdrBwA1uDQa7AzzwxfQWrgbSougPrE50Igc5tTJTqZ/aH1nHK+bETV9QlBQmeLa7Y37/qKn7z59AbC+yY7itzrqJjrbHsT9bb0qMfWSHwqSZmhknbf6DBYqK7ok1NzMumg0dvdEpMmNLoCSBfVFMcvaJXXGKYQOofexMJ8vAx24C7l0WD2OOsT7LPr7SYxevY+sNyaR1Ur+uTeJIWuffTOZhbW4/hmR+nDFgUzLIuZ3iHBDPrjKKy8lE5owWExFtHV2dv/6zls7egBmk7g4Up6jqSxnXtMoC2G8AK/LPCQ7cLQvhuhC9XWwjlTbz4HFkwtEl+zKJjRHcZaMYKCMaR6TZvIFaG5Xwr5DuvEUZufJ9Xa1v5nJBy4tQ1mFGb6/KbaEPHXKvxDjqBwJsbPgf3PVeN5aazfymWCPQIexE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add kunit stubs in kho_restore_folio() and kho_restore_pages() so the
users can mock these functions in kunit tests.

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 kernel/liveupdate/kexec_handover.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 11855e275397..902019f36c24 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -10,6 +10,8 @@
 
 #define pr_fmt(fmt) "KHO: " fmt
 
+#include <kunit/static_stub.h>
+
 #include <linux/cleanup.h>
 #include <linux/cma.h>
 #include <linux/kmemleak.h>
@@ -423,7 +425,11 @@ static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
  */
 struct folio *kho_restore_folio(phys_addr_t phys)
 {
-	struct page *page = kho_restore_page(phys, true);
+	struct page *page;
+
+	KUNIT_STATIC_STUB_REDIRECT(kho_restore_folio, phys);
+
+	page = kho_restore_page(phys, true);
 
 	return page ? page_folio(page) : NULL;
 }
@@ -445,6 +451,8 @@ struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages)
 	const unsigned long end_pfn = start_pfn + nr_pages;
 	unsigned long pfn = start_pfn;
 
+	KUNIT_STATIC_STUB_REDIRECT(kho_restore_pages, phys, nr_pages);
+
 	while (pfn < end_pfn) {
 		const unsigned int order =
 			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
-- 
2.54.0.746.g67dd491aae-goog


