Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF081C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 01:14:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98BF86B00D1; Wed,  5 Aug 2026 21:13:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 964986B00D6; Wed,  5 Aug 2026 21:13:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A1056B00D7; Wed,  5 Aug 2026 21:13:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2BCBD6B00D1
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:13:29 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 32C8B1C0FE7
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:13:28 +0000 (UTC)
X-FDA: 85069071696.19.F05A8D3
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7B3F5180002
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:13:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=a3+kIfNy;
	spf=pass (imf24.hostedemail.com: domain of 3td9zagcKCJ4HWCQA8QEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--jyescas.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3td9zagcKCJ4HWCQA8QEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785978806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3g38r6hFv2wbBj3eGxSH6q709M8ljSg38dlChPPOKHk=;
	b=6C3zxZujEV1b5pFZTp1RFWneoIfdjC0PnmbcJk7kFqB9qj+46WcVhl0pX/qdsOAlXqcNjn
	1gy9zEbVGkhS1kysRVouCbLVztN1TzOhSz2FyNK8sR3ZW4hnrAU3TZxE3JDL577/f8ArHw
	NlhL7b/oduu2lDuviMOzYWiPMXayWnk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785978806;
	b=aBVn1wEkvxlNhvb/RHsEBAzaya4xHtthTfBdq0Y9CvLE0lAiIWjDJKCCkzy05i8wNDknte
	nnVA/WaxTWp84ffFi+gtWyBUp7vGXx//rA5KjsUiF3PLLqcrwO1DBs/KUYj4wOKAwx4mmN
	Vtk4S9J7ktTobPJTq/Id3IHC6E5pZjA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=a3+kIfNy;
	spf=pass (imf24.hostedemail.com: domain of 3td9zagcKCJ4HWCQA8QEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--jyescas.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3td9zagcKCJ4HWCQA8QEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cbe77d6864dso1360067a12.2
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 18:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785978805; x=1786583605; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3g38r6hFv2wbBj3eGxSH6q709M8ljSg38dlChPPOKHk=;
        b=a3+kIfNyKNWoE2pkJaRyOG33D/KOqtEuw0BbP66g53lsKB/gPaccs24ShSQGx4/0Je
         AvUINcDCowNUPOtNkBHt19W463z5IuInlrk5S7psf5jReyDWPae5LC6mZVIWF9ZJGpQW
         kILoCL5D5ZOA+lQIAXo9YZDTgVyyv1HhGskQibz2bvj76un/kAPbYJ6ni8GIRLaVsewD
         IexH8J11S3dpGSahuNwak6dbGaftJfiZhZYT+TwfUXQT/rHn92m3nwo4q4JadXC84qUZ
         DRWOtplnaAqj91DlHjMHUjgea8NqEixrnqzhp5w1XRV28Ol11YCuSI0IFtABxZSg6yZi
         fHHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785978805; x=1786583605;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3g38r6hFv2wbBj3eGxSH6q709M8ljSg38dlChPPOKHk=;
        b=KSYEidsHhMSiltat1cKHdw97CkwYoS4LDMwquK+9FAtzMhGCE4RrxBB3+p/RIq6YS7
         NYrLqQ1nko728nd8FZmF58NCL+KJ8PcxwPiciGqVVNDmQunFoxbFCTcR3W2wfoioaqQd
         O7VEqXvhuKnZZZYDgFnMQ4L4C+7Ocx2dM8ztUG69Z+gjYY/76a2yot2LcaYvfomMV3l1
         pv+ievyzhoEakjFfRAVjEoh9g1ZHDWTg5F3dBmRVzTIcR1p04pY8UKkQmnNbVUlEDMDD
         190scyGynNtnNyI6OtULWfLkm4Ka8wVcIyeYGah7yhE2TFNmR1ywBchnKthwkSzIJ78P
         WZfA==
X-Forwarded-Encrypted: i=1; AHgh+Rq1RB6qZzPOOy47Y+KcdSY18teh+fgC9mtZgQRy7YMpAdRNPa9f7AcpMU4snNl8VEBCNsCL/Kthgw==@kvack.org
X-Gm-Message-State: AOJu0YwJAqq8THTgxfxxg0tUFv8SawKyJeNRhn/ey1nPVMa5IoYuHrPo
	W4OAaKidKdO8bALpH9PJ5E4gCg7tOQJeNDdYAx4sgJOfMF/yJcsYy4yI2aOPaFqxM40O/n9bdEA
	UU2t4qruXPw==
X-Received: from dyx18.prod.google.com ([2002:a05:693c:8212:b0:30c:5c4a:b8b1])
 (user=jyescas job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:a111:b0:3c3:64cb:9b99
 with SMTP id adf61e73a8af0-3cb85dcc784mr12261790637.6.1785978805017; Wed, 05
 Aug 2026 18:13:25 -0700 (PDT)
Date: Wed,  5 Aug 2026 18:09:17 -0700
In-Reply-To: <20260806011048.517229-1-jyescas@google.com>
Mime-Version: 1.0
References: <20260806011048.517229-1-jyescas@google.com>
X-Mailer: git-send-email 2.55.0.629.g250fe7f194-goog
Message-ID: <20260806011048.517229-17-jyescas@google.com>
Subject: [RFC PATCH v2 16/16] mm: Release resources when the page alloc hogger
 module exits
From: Juan Yescas <jyescas@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Cc: jyescas@google.com, android-mm@google.com, ljs@kernel.org, fvdl@google.com, 
	tkjos@google.com, minchan@google.com, dskiba@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7B3F5180002
X-Rspam-User: 
X-Stat-Signature: etryz9mb1774zyjp57zgzn8mq68hfrtm
X-HE-Tag: 1785978806-91502
X-HE-Meta: U2FsdGVkX19MkKbjwDwAzzuHYUDXMf3CliV2Z1gS8ErVz87sUi/qNUNNsCc0vrhpYB4G6c2+d2xm0R127EysDixhI0tEuEcw03YX1Rq0MdpOxoDsVRYIb+2cgTsABZJ2kps/o8iQPH79wEnpg/tOcKT9+VXboRxxhNek/chnZnk0ADWOVS2RDFItHlwDslKKHRsUsxIXO5JUImAnpV0S6X5jE7eAH8PgyU6keXCbBaUYqmXg58b2XVqOpOhSkvAfIROnde4eDb/rYbNDlFvOXNCDeCb92cRJt+IY0YE0S/awPlQFdrkVgHqi93Fwb1Uxa0MkNv8OUpEe/NGVHmMd7MSTUXvQb/Wtsfp5FccjUoUHMjv1Gbe+xlzX6HlfRznLirRvJir3EoYRGWzOJTVKmS5v/XRtl2WEU9Liocd7oGsIjShmdDh1xRTEqmeSgoKs1ecLUxECK3efo9EfxgK0/YjBmjcLhH00nxBzYh8z+fVclIeSwIPhzJIXqmF6ICVD3i4FFTBbnvG7BTlay97Neo9tQlBkcqIDIaoLPTq7H5zSh53kYE4Pk0f6eAq3vjJ9m3dS7D5AwVr1A+EbMKTPiCccQuYgLYMWsN90aDussp3GV50zlpDrvGmY0gYennYLfwT41sOAwEGA31ySUJQNDdWjORtlRlapI5/qAGHOgxfS/6hJ4nWUVVEt2O3AsNb8d71qFSYa06zBPhkEzy7iSweVcGH/VxoQYP3tW+qEYiKojMcOeepwNmoNKDRuyoeWVDAv0jKis0SCFO1VpXqnPFBA9lLUm8TqMc/OIC2KDtmKZYw2YE1EYF0kfXm/dpf7Du13vUlfySpM1MbadwfpWNODo7T1SOKpNjh/91z5ar+LlPH24IXyMrrROjSjGcvlZ//hmSYL5gwk6+iliNN+5dfWn7zEzPdkEnitb3WPGCRpltXyxGVOTnFKjCTkY1emw2fYr3I0khPzKcNV8kj
 v8O89Jsr
 tRSklBvkBYRhgPiahg884YCMUvNH0IpOckXw1ISXkk/e1VA2hb2R3TPkUjP7E4ghY5gWJjuJHMkGGQnW3n+vJLulpYIyldBr3RbaQbt83VLxEBs8uA6ix+oq94UqdRTP9OIyNZCvPB9lX8pW5H0F7p/y8Pue8vbWtXV5CBLrFp4vMS8L8869Amiak3RBneFq0qgS9GfusVeFThKfL7a+/SURY3Ony2yCHFF/jS8CB5kwjzVUbgOKS/S8a8fEuprpZRoKFb1wZ8b9yPdRH3SjwHuhjogCbvETrTYlaRr6Gj4yk65EmDrq2Nlrj9nVwlRpiErKU+Zi/iUHBsYsRX+0lASOTR6UYGx6YAA+wYpkc3IFOBdDZZjHBYlGqNhX/AG9bQf+VYxa5Kw0FQ029vUUEyQqgpqPdTI6PgN4lIRdD8RfePBJMqybMgkEPRfy2nxwRx2px9V048LgF91usmZsxRksf8dA5zLWeqKK9kFALLSp+Bhpv96Zrnu+XT/mqdBH3/nmVN5aFVea7CHr1+nRViu1UYMGD6P86r54MoyUcKX/z/6t0OQXgP0zgYiPKiNuSTKmgHd9Z/B3Ag4nX/1UbJCoMdHJ/CjjnhgR6dgUhzhmBjVhqKz/FJXZStw==
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

Changes in v2:
	- Refactor the exit method.
	- Release the page_alloc object.

 mm/page_alloc_hogger.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/page_alloc_hogger.c b/mm/page_alloc_hogger.c
index 6a6fbb78513a..72c0505a6f5a 100644
--- a/mm/page_alloc_hogger.c
+++ b/mm/page_alloc_hogger.c
@@ -591,6 +591,12 @@ static int __init page_alloc_hogger_debugfs_init(void)
 
 static void __exit page_alloc_hogger_debugfs_exit(void)
 {
+	struct page_alloc *pa;
+	unsigned long idx;
+
+	xa_for_each(&allocs_xa, idx, pa)
+		free_alloc_helper(idx);
+
 	debugfs_remove_recursive(mmdir);
 	kmem_cache_destroy(req_alloc_cache);
 	kmem_cache_destroy(page_alloc_cache);
-- 
2.55.0.629.g250fe7f194-goog


