Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90D38CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 12:12:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B93226B0005; Tue, 19 May 2026 08:12:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B632D6B0096; Tue, 19 May 2026 08:12:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2AF86B0095; Tue, 19 May 2026 08:12:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9459D6B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 08:12:34 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 523B71A02E0
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:12:34 +0000 (UTC)
X-FDA: 84784057428.03.7C3DA05
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 58146180008
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:12:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qXE1gqS8;
	spf=pass (imf24.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779192752;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WpZ28Ht96EjbZtWoBndxXw9G94MVvbCqeFHh8nRksQc=;
	b=z4xWtWQ4WY81//UIfwAGe9t5SzPVu036FqvFtEGMY6gkKPLZOKtfqgpxrq/0qqmz2Z5yPa
	Lp3uGxofUWF90KopoRi+cgsYTUwWn3kiUbI7autGWzQ3HxBNC+RC0KmZFMYK7q8368maEP
	yaGH1+1BCaEYkenPMK6EIJ+F2vD5WU8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qXE1gqS8;
	spf=pass (imf24.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779192752; a=rsa-sha256;
	cv=none;
	b=pSJeLRD90NrEyf/nZEeCiD2N/+XfwFV71SQ9qqYSiVMGWbC5nuJKaqlZH4KjN2/qFOAXK0
	A6Fza0y8t+vpT2WpszXE+HjzI0gMrwsaFYWaeU4cfz/xM4uYzHdNzJNjozpbjQwT1QCbjB
	NmTWmtIeGJDn6JoKd+mox33Tob0zhCk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B5304430E;
	Tue, 19 May 2026 12:12:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 38B54C2BCB8;
	Tue, 19 May 2026 12:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779192751;
	bh=Vr0IHoxwEI2Zc2s6Bahmf4XnaDVxjgNzlt5KNphDUvE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=qXE1gqS8T+m5qnUOmak7CkzQKTSFu+yEjAMA+9dnsCwFn4Ltd+sXN1QRr4DprT0Tw
	 P8Rwz2pvH1W+l9N82abUA79KQ+IB927aKSLGSUowkTGb7n0XdKkLBSligRgLo9k/2W
	 oCqeMnwLVsSLkam2w8i9bayozBMSd/TNPY8Xf8tzE90+YRJJ0IyM/HK+HAj4ZTiMEN
	 3JOGaJbz3uJ7QWZSH5SJfk7UbdS4l/ZzfzaC4NRCv4QowsydZb4V3w6GBTeqJYamvo
	 1YcrU+wwGUrtwJOwfGZ2wpZgHXr8xQt1fhaf5D2eCNpteXtZ3kODNNvxzLbrZmyOWL
	 YoR3FgRVls8oA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F441CD5BA6;
	Tue, 19 May 2026 12:12:31 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Tue, 19 May 2026 17:42:15 +0530
Subject: [PATCH v14 2/5] mm/vmalloc: use physical page count for vrealloc()
 grow-in-place check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260519-vmalloc-shrink-v14-2-70b96ee3e9c9@zohomail.in>
References: <20260519-vmalloc-shrink-v14-0-70b96ee3e9c9@zohomail.in>
In-Reply-To: <20260519-vmalloc-shrink-v14-0-70b96ee3e9c9@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779192749; l=1768;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=PlRn+4ky3xwmAe2MvESYvdRi8E+mwHTHUGmONHypEP0=;
 b=g7jXo2qEkXEzlGxmL3RUHs8WUq5wxnSpq8dRxDH/mQxZsNKZZ5CmZoXNomzQByJsSW7j2bPS5
 Ugb1mu+cfOEBXXUAtEfpvE4X+5IKZuGn0sqGH4hdeRPKgRmRCUxDJZM
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 58146180008
X-Stat-Signature: nr4dt3kbdbbiuuq1mho4gdz7gq57bnff
X-HE-Tag: 1779192752-866971
X-HE-Meta: U2FsdGVkX1/RLZIvXPf82b6FOR608q5qlNZX7RN5WTMbX7R22rViIQW7cY5wwj1a1uhMFEgmzWi7rpKylKJmtwS3dNDxP/FQ7DWwpr1tGlQtSAaGUaP70oJPC6Qn85PlbCSb1WNr9jOYC3uV0Wa9hYoq/c0kKM9QbBRs5qTIulYYEljh/bhCM+RwBYn6mnfy7Bw0tM+dpGp0KFSEhnQNSkRBTmn2BZnkLgm5Of7JrLU4cm+dYLOAbTC/9On+Flg99sfOR7WimF8X/O/gLUzfoRD8MR7h9YVvhbNhmLmfluEk7IPP7FnB2jURWu4JCa7uHCO+chTICtvwjRMOlmgEnM3Su1H+V7kIiPLVXeQ81EWJ5ArrMsr6Y+3yG+ReX1ao5m/igTLv8hpKS5DxPqI52BVSrvpmCr9rblhCyErbJuWs0liimtTiIgksJgDRgy6xUyXoR/2bZBBvBD7CeSMTbgWYCK/J6PkIXCGjJBP53cy9aUoPZQRwKCv93ORe0TkBqN2wXtfXfLh965qgmFWn+Y455fSV1l3hmQG4INr6eOOCVNq0AhyjMvqwUYGxed9MlL+d/u5YsPcUrK742sVHp1mp9WNc+xN/bkjPmLt6XG/VS+Q7yJkwrCIoYdCsWVvrp01erVc/IaczgFNLmsaPWg+GKEBBv0alw/X5CCJGi8P91W5HtE/qtZ84kGSMcFkhPZAw59jRZ7GtOO7M9PuwsrdoEi7bLdJfOjizB11q0k/rFCbZXNIDQvZ58GfygpDWtgS7i5U8hltiSbra7QjfL4rx/Iv397/A0Xm5Rd8rortB/662RVKX28Itc5LbC1deaqMQYl69GCQflHMqyNQlKrkwtxQMzBRyfWQextoIDQEUH7qwC8en9sMLXvFGg0G1Z4tgRW1Rr9w7VTgzFpDKSCuSvL2Sw9XcUIvaTS1nyfHuBNvAW548H9n63EuOdA2+Hun8kVVLQF/tTAH3XMM
 67BHRG5A
 GDvzjsuprUZowhzuPvzPDRKzL/kJ4FdQtVv4TBjwrJHcNAv5OlfcuT8dP9JoMSWsje5zXukcAozwD3FkAe4iE2gZ5Oo8wWOcEqEAREoYcsMUGOIbeDkLTzeu/RA/BMsnhf4svSnxnTeN46qdqZ7Od1iDi9Ap35XBVDX9UWvoK/7fQPpt87FazrFijpDJWOEa1dkU+gDwiZDcIKPRvuK8AHFgCTLynknavrvvv32DoCG+/fFQdK5UQxjObdA8KNKOFxcQ76xzuAxKkTTLLtsLVHflTUV58FPjpE2JEWZtFKlHhDse7t3s6wFCzwC7i671dhNCdhF15SxTTgxI9KxDg0QR+yd3o7Jx+ffLN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shivam Kalra <shivamkalra98@zohomail.in>

Update the grow-in-place check in vrealloc() to compare the requested size
against the actual physical page count (vm->nr_pages) rather than the
virtual area size (alloced_size, derived from get_vm_area_size()).

Currently both values are equivalent, but the upcoming vrealloc() shrink
functionality will free pages without reducing the virtual reservation
size. After such a shrink, the old alloced_size-based comparison would
incorrectly allow a grow-in-place operation to succeed and attempt to
access freed pages. Switch to vm->nr_pages now so the check remains
correct once shrink support is added.

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 mm/vmalloc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 5555601b9529..3e159b74cfab 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4343,6 +4343,12 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 		if (unlikely(flags & __GFP_THISNODE) && nid != NUMA_NO_NODE &&
 			     nid != page_to_nid(vmalloc_to_page(p)))
 			goto need_realloc;
+	} else {
+		/*
+		 * If p is NULL, vrealloc behaves exactly like vmalloc.
+		 * Skip the shrink and in-place grow paths.
+		 */
+		goto need_realloc;
 	}
 
 	/*
@@ -4361,7 +4367,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 	/*
 	 * We already have the bytes available in the allocation; use them.
 	 */
-	if (size <= alloced_size) {
+	if (size <= vm->nr_pages << PAGE_SHIFT) {
 		/*
 		 * No need to zero memory here, as unused memory will have
 		 * already been zeroed at initial allocation time or during

-- 
2.43.0



