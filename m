Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85F0AC43602
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 02:19:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C0906B00A0; Sun,  5 Jul 2026 22:19:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 297B46B00A1; Sun,  5 Jul 2026 22:19:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ACFE6B00A2; Sun,  5 Jul 2026 22:19:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D65566B00A0
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 22:19:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4EA42120269
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:19:01 +0000 (UTC)
X-FDA: 84956744082.05.84FDF62
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 85EB2C0007
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:18:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="RDpH/XD2";
	spf=pass (imf10.hostedemail.com: domain of thehajime@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783304339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YwQLUnn9dsXwG+DLMvLsNPxJDxnhAJt3LBxbR0lWTJs=;
	b=VpGTxsyAIWtcAZgC0oaRUVZInpt+w4+aoxh2rRqZ+v5o8aYZyG3VLCZYWo0zbF2WBXzf4P
	wQrAKuutXNGQBNoXrg9Z9kUkKZ2VqoxgBkgNvnRlEWzFw1gSdi9jeXwrsHrHWnGUppqZkQ
	sB+nIric4SPwJE9sCw0Ex6PrS4KMP2U=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="RDpH/XD2";
	spf=pass (imf10.hostedemail.com: domain of thehajime@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783304339;
	b=vzpB+lWvUsXhvaDF7B7FDyN81AyABxep/m0kEEo8qE6l4jMu8dOD0WYcRHjBgnlMBZGad0
	xnF3CgZ6S8+GclrwXj8d27e8aS/CrdDXNd2DKvNuGF5RW3y4qgQ0D3Q3o0dG3FOy48Gnvr
	GAqBmse3+NoHbez7cABW3HYuslT2UoE=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-847a69ba83dso1923966b3a.2
        for <linux-mm@kvack.org>; Sun, 05 Jul 2026 19:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783304338; x=1783909138; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YwQLUnn9dsXwG+DLMvLsNPxJDxnhAJt3LBxbR0lWTJs=;
        b=RDpH/XD2BZnBhSoOneq0OKY/qAeiSadt06nBICyB+fBwDNzTGWC/iqeMji4sFAssGp
         VN9n9czzIQGmozI6Syw7608dj1kazEchrmB8hocZy2ulYgewUQ4JnDa4pq8HM3tnUTZG
         4bfosDB3HQewpuezvcgLDDW7zyXK4oYqqB3PJynPFyKiP5pRbFwDvXg8YCwO+cX0yAHM
         yWnm8kuKiW7mEpCjzTAg3roczWlSy/f3KRPYgK/6KxnD6Q4erUCmNgzHwRz3i2dMfcWn
         SaxEfo3iIb/mPPzRn+FpIbTLhb88Nux72GdQ7ovq0jWXkIZI+rPvqsIr7Z6Z3XxyqX5m
         XV+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783304338; x=1783909138;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YwQLUnn9dsXwG+DLMvLsNPxJDxnhAJt3LBxbR0lWTJs=;
        b=drS0u3Gg5GNi/xfjj4VqSu9f3YY9KAy/KhuFaDGAFtqotn+sWLTGDxQyPyc3f/xVrK
         b4H1zFSmRmEQsvd0O1eQKRDZa2IlwV2+IHymb1Psevv7h4YH0vLV1e3AifFpKpRe9tL1
         SC5UZStbirM8UbDViHnKYd9Yq6kmO1x8WDaotYF/F+6m4ZRE81jrtF23pP47h5V0yZXX
         6ef0GfDtlfF7DHZZm6OUroqXdAQUvuJizHNjPCK8EIKvAtesMgjOCwm85JwKSU8nvN6d
         Ja4/kHnhv5zbJ1SDGZtwNNrV1eBQdCUSS06zNzSgmEgqEZvJ4KNgx1FqYL+rHxgXUGtB
         2e/w==
X-Forwarded-Encrypted: i=1; AHgh+RrpQ98TqGZc+1DZxLFiNmUmfBtnaVlsd/hIR2nSP9WulXFcv86xavjCB0kvJq8tT7UVLnSop7geEg==@kvack.org
X-Gm-Message-State: AOJu0Yy63xOfX3eoMGdvnHAXNLXHsJTVhnMmcJ6Q2cADLFCKOfehMsM3
	huDeL/WD7ZaBwGSHtCkQioDjFMg7MPJ1QWEsUZBWEia5AMAseHSsenqiCxPifMfW
X-Gm-Gg: AfdE7ckdCgMNiOt1GwZ4ah1UuvZhEvWz06z0Gw8L9QF0v6OqrYL3VH31tvU1dMGJ6nl
	rUxcd50KXshOeicR2Z+cIxEp7oS2NfL5PVnjK5hc70PyfpsWTM06m3AzZsLJmfWhQHNSY+sfKM1
	3IrE8kBUthuYVNvxa9umvlVmYMkOBaQTswCsePS1/ZWjQ24DnV7kysE8GAqSv3j+EKkML8C/RND
	5tV75wypoRgu3Fbt2DVxiNVVgPE6TEbAsUCevTINxp3OfUte2PQfBKDkvaKDiNyCNcx8r7Ey0qn
	Owr3ZaZqARrWzso1VFrZbnAjNZK9F3mBmTPXV7oxBvK7hRZAUb9gUPLbp8RJUHPHQgVEjg+WvrM
	yShogFMm0Wz9cnUJOo88sGz+aRmmxnj0/vX/9NPvwwAkAQhPjt1qE2RCk5i+v8Ao4Ax0wUZL7Cg
	pTW7pUT2v084uyjQ3Lmv1jLAEmMOV03YZQHZfCZtxATYwR4rVW8PEM1jMEjoVF4lD2jVPSL96C1
	f/JA3C5Zey2Kr4dng==
X-Received: by 2002:a05:6a00:1d86:b0:845:e363:8af with SMTP id d2e1a72fcca58-847f6f0d431mr7284948b3a.38.1783304338364;
        Sun, 05 Jul 2026 19:18:58 -0700 (PDT)
Received: from ikb-h07-29-noble.in.iijlab.net ([202.214.97.5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6d498adsm2802670b3a.32.2026.07.05.19.18.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2026 19:18:57 -0700 (PDT)
Received: by ikb-h07-29-noble.in.iijlab.net (Postfix, from userid 1010)
	id D8C281414300; Mon,  6 Jul 2026 11:18:50 +0900 (JST)
From: Hajime Tazaki <thehajime@gmail.com>
To: akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Hajime Tazaki <thehajime@gmail.com>
Subject: [PATCH] mm: nommu: fix the error path when vma_iter_prealloc() fails
Date: Mon,  6 Jul 2026 11:18:46 +0900
Message-ID: <c8513ee5aa8444ec9bf6c276043c9f833016a2fa.1783304131.git.thehajime@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 85EB2C0007
X-Stat-Signature: ziipuwqys77zn4aytrsx833uga3z3qob
X-HE-Tag: 1783304339-925983
X-HE-Meta: U2FsdGVkX19ZP5Qmf7SvnlA5VZyJzMdu0cH3FQhGjttyYCXrLYt3l1wP5mq9xhUmr+y5Wa3EIUdne0X8h85+7561klPTv0jccpELWrV+dDh+h2W3Oyz2T0Wj+wg6TesWvabhFh97u8i78KeoXUh8IkYScRSf5f8GgllaCjTZ2fdTWfnPlWiaBjLx0N8o/YkjdLQZZyPp/Fx7LDQMDAT5vcc5Rp1Uv0ETu9D1iyRFC5s4sbLhxmlNEj858/Urz9ss0fKMxsWaGk2nGQJ4mvoSYE/S9gBZKBqciMpRnZ+DeXpvMXHc4Gs5mf+V8gjbmk5uN8Bkm+rlqPfboTm9cABlvYlGMe1WOd8U5GHAXYlBlxn7EnWi/UamRuPf3szeaESrUvo+BB15Wu3KCyRX59wL3l5Yhg2R7IfLeVC5pH7w7z+eFEIn7MtQLoemZlVFnayqbyOIMKtNd0uer97Yr1HKsZ8EIZCYSP/p/4SD1oTX93VH/bXps/j4qHDDO1NM6ukHVCVAp+m0CwNlQpJt5vsGNNdwcrA7NLCdIKY6RVPRe7lsvegv+L4woyaX5zyUUV2wAgPdLTbkpPlppM7PmHq9JU43RUIslCrqHKD1fel4jZmT8i+hddCipZwkkqqIRIbeVyTuSXKZG1PnTB4/to0Pm8umUbX1kNMAyWbTrpfzzgfuMIJ9vCJFiawE79oE6idhd7rnf0PxNUssPyxATqSm7EBj4FAe/lG7gtctr56j+wVey97t8Fnsfq2mGkvR/EdM5iDEfYYr7QsZssvHuwrJNc+ceR3tr+4UUXIvjptct/oc87llZcRXY3PHHlDo5dBgIM47ROUD65uSCcwuMsjO9Dj7VSydGXyVsXMfriTb0mAvr4OHpdjIXsvoHiTOR1dS+7e8F9UIfKaNN4Pui88F0BGQkMBRHz7i5vhmtL7KAbMqOpuiYks4CjVNSPFNXd4U1LOyUCCsiU3tI/8dh5g
 S50GpcLs
 qMCI/Llp6XIJjMiRYEAj7W4R3XQTiFoUrCpCAL15L9BU+hjSoVPk6VDUAJZjxWYIFYb57mfVfhNz4Ebbi7+38WCwJyqBkEWtPI5ioIL/1xQKpo9ZOm7SQks0Elp5m90Ut8kJZN/bkkEMxKUoMpFWSD4LRVj7KjBE2EysD7eL/cG4kAr0M2cxM7YSzFQ+XmDu8miT2UO44r+PwimPqAq/uWwlKEL+wBlozv+OMVZLIpcfnNPkvuDUDLiGLCcj73SS6bMajJeUIYLR1EkiBZuwkq1KEbK/kxdXNm8BpnPT+o0DaEzKrala5IPPdFkSs7/8qxlSWVzmwKeta3oJIO5Em4F+84c0jiXocavqHNqo+B3mieOEUZfLyNZdohyCljLLMoWCiVtZD0flOe1KF6PDvRLfuacXxHnxubswg8iRYJI7lHbFqaAuooqXTELFl1mloR5WyTsxOMkxQduQen9B1WxzxKJuWmbgVXK3hkbkgWFYPcyRhwlq2hfQyzPHjVFFGWr9O1Anmjd6tIOg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When vma_iter_prealloc() fails, it jumps to error_just_free without
updating ret to -ENOMEM, meaning do_mmap() will return 0 on failure.

Additionally, this error path unconditionally frees the region struct.
Since the region was already added to the global nommu_region_tree via
add_nommu_region(), leaving it makes a potential dangling pointer in
the tree and may cause a use-after-free on the next tree walk.

This commit fixes those issues by updating return value as well as moving
the region updates after the place that allocation is finished.

The issue is discovered by Sashiko, linked below.

Link: https://sashiko.dev/#/patchset/20260702012830.667205-1-thehajime%40gmail.com
Signed-off-by: Hajime Tazaki <thehajime@gmail.com>
---
 mm/nommu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 815ebefddfae..8b30fe9079fe 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1181,7 +1181,6 @@ unsigned long do_mmap(struct file *file,
 		ret = do_mmap_private(vma, region, len, capabilities);
 	if (ret < 0)
 		goto error_just_free;
-	add_nommu_region(region);
 
 	/* clear anonymous mappings that don't ask for uninitialized data */
 	if (!vma->vm_file &&
@@ -1198,8 +1197,12 @@ unsigned long do_mmap(struct file *file,
 share:
 	BUG_ON(!vma->vm_region);
 	vma_iter_config(&vmi, vma->vm_start, vma->vm_end);
-	if (vma_iter_prealloc(&vmi, vma))
+	if (vma_iter_prealloc(&vmi, vma)) {
+		ret = -ENOMEM;
 		goto error_just_free;
+	}
+
+	add_nommu_region(region);
 
 	setup_vma_to_mm(vma, current->mm);
 	current->mm->map_count++;
-- 
2.43.0


