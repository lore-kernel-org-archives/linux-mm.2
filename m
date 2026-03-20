Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0A311099B3B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 22:14:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37FC56B00F5; Fri, 20 Mar 2026 18:14:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 331076B00F6; Fri, 20 Mar 2026 18:14:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26D6F6B00F8; Fri, 20 Mar 2026 18:14:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1179E6B00F5
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:14:45 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C6A5D588EB
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:14:44 +0000 (UTC)
X-FDA: 84567846888.21.800514E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4E8921C0005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:14:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Cx1QfJei;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774044883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FCtjL97N7iCjGpdRGtbzwn/JD7eYQJoPx9llP0pxnJU=;
	b=ltQwm0w/laDbqJuRCNB3IxIgQXS4/YYPcC1m/tLLtKFDHUK0yryqyz7ZaErgssnQKjXsdn
	S27CuuHzWc3ko254hsz4X4rgKlNPmoD+bpZZx8zd1joXujE5wnVk/g5AyKPagmxC0ZyLIg
	YAPoH7QNGh8ea4OIuIXcz3CeGgSv0cA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774044883; a=rsa-sha256;
	cv=none;
	b=sbWjdx0o/ciaGzZ8/ub9ef3D3V6iZP2axxtfIp1SEOLs0njX5K7lAYV6mXXO4i8NUA9UF8
	oTtIGFwDPZb7KwdGZrNZ3j0+LneM8L/fSCAsScAqrhEZwQyfK1X8JirWWc6zrbTXgFdtHs
	ZlJQM9c1vkvPkztoFdYdjoye8g48PmM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Cx1QfJei;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CFBD76013A;
	Fri, 20 Mar 2026 22:14:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0CE7C2BCAF;
	Fri, 20 Mar 2026 22:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774044882;
	bh=nAADk4O++zlIdaSsGnqecpm2JFYNOEQEolE0epkoJXM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Cx1QfJeiw+fJiVi+TEUgbrb9326n7iVHjUNLjnMKlj6iprB7t2rO+Imn/dWGqdEq7
	 YfNIyImYbgavmRQUEAmCNUElbh5Kg1BFoe5ptLbRuN7ZuReCZI4rDY2a5jP7YFa8px
	 3Dok4Agv9vTrsTBNtsOBpywS0B05t15ubKY0+5O73+1FriKKgr5AGs+05Tvmqv7AdU
	 RyCJAM88Hs+79PzvgYeXn5SyIVMvqyy3JQ8WpvMDwEKL4HxAu0dR37XakI55NSR2rh
	 eRrtwzRqU4cSFG1lF8DErPwB1lfPA7mQ94KCMiW+AgFVXhOqgZu5WkrNADCZ1pDXHB
	 SiY7M3MEQJVBQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 20 Mar 2026 23:13:46 +0100
Subject: [PATCH v2 14/15] mm/sparse: move __section_mark_present() to
 internal.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260320-sparsemem_cleanups-v2-14-096addc8800d@kernel.org>
References: <20260320-sparsemem_cleanups-v2-0-096addc8800d@kernel.org>
In-Reply-To: <20260320-sparsemem_cleanups-v2-0-096addc8800d@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, linux-riscv@lists.infradead.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Stat-Signature: n53rwasi9w7c65ibzmtiho968q1kjtgt
X-Rspam-User: 
X-Rspamd-Queue-Id: 4E8921C0005
X-Rspamd-Server: rspam12
X-HE-Tag: 1774044883-555066
X-HE-Meta: U2FsdGVkX19mEyjdmCvVDct4LvrNkesBeXQhrodLOe0id3o+zl82nuknEO6S5xVZa8KP58aX1hvOYE3kmPyblzJTValVzSbm3gfDjNK2cSUW+FXd6jZTT9lE/153rFztaoaboVpZ4Mug8VRXmi9BczCMfUoZqUSYFbefILTCkfr570J2HTZ/SnSZan/BjT2umLnKtJgWUGI/jFswMsIHiu2BM4nZ0HBIVhd97LoTh7g+ISa8ymyRprMzx5YKpir9f64dyZ6ut3y8Hb1/1GVGlOS7ReCEUWvXGg2KJ/sVceBo8OdnP+VZoez9a+5SkBjN4+hWcH/rZR8NzXSHHUzg4WFL1nQkLkSiYKxlOGqLEpjmZ1o0r2VV08/gDcVhHJxzIjq1GApDOVkmcS9jMHUT0T76e/lvKfuPpgxjNY7Oqhup0nbDFBeek+Bo7HDw27riKuocUfwFwJQ6N2RLDUIWLm1sSGcXzuZRNmkf5mTQ5CqcAYdtd0vQZBjDxZFO2jr8rkQWLD9QSJfkNu4CX/8bL2/pCGEJwAfOjTV7aSgmtGeQZ8c3dr5ty3IxNFIOHa4fVP/+mIb2eZXaZybw8qfLEqHU61Up5EjGGLorxYnMnA78T7se3mQIjZDE/tmh+M+s8VajXSj3CD2uU9BGP+SfC5ynzezFn5wsLTZ6rLe3j6L8ylarBZByyVKcImeiD3OHxzNC2akth0fdy82TDGhHaCqfrORqjNx2aMBFaLmnBx3V+FzLwmrHnYSBfeWI4ixHRXDnHNs8T5O7qTkSvGvJmO5hdubXGu0em4RKw/eYW5QYWdtMqU+JI9cAZ8leqqYpG4MuVE2cQI2gd2zImfCwIb/Psn4OrG1vuqX9YSRXrOd85ivDRtCNPRWO3O+EjNgyWiM/PfNNRw77DoetmPbDM+KF03JDe4nVeodBS5GQP/s/uD8aKT3xNlJ4s5DGPQhbSwBj0fOz/ykurguqJG/
 00DSv2kT
 tpQKV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's prepare for moving memory hotplug handling from sparse.c to
sparse-vmemmap.c by moving __section_mark_present() to internal.h.

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/internal.h | 9 +++++++++
 mm/sparse.c   | 8 --------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 2f188f7702f7..b002c91e40a5 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -987,6 +987,15 @@ static inline void sparse_init_one_section(struct mem_section *ms,
 	ms->section_mem_map |= flags | SECTION_HAS_MEM_MAP;
 	ms->usage = usage;
 }
+
+static inline void __section_mark_present(struct mem_section *ms,
+		unsigned long section_nr)
+{
+	if (section_nr > __highest_present_section_nr)
+		__highest_present_section_nr = section_nr;
+
+	ms->section_mem_map |= SECTION_MARKED_PRESENT;
+}
 #else
 static inline void sparse_init(void) {}
 #endif /* CONFIG_SPARSEMEM */
diff --git a/mm/sparse.c b/mm/sparse.c
index ed5de1a25f04..ecd4c41c0ff0 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -161,14 +161,6 @@ static void __meminit mminit_validate_memmodel_limits(unsigned long *start_pfn,
  * those loops early.
  */
 unsigned long __highest_present_section_nr;
-static void __section_mark_present(struct mem_section *ms,
-		unsigned long section_nr)
-{
-	if (section_nr > __highest_present_section_nr)
-		__highest_present_section_nr = section_nr;
-
-	ms->section_mem_map |= SECTION_MARKED_PRESENT;
-}
 
 static inline unsigned long first_present_section_nr(void)
 {

-- 
2.43.0


