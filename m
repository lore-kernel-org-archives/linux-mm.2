Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61984CA5FE4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 18:03:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE5BC6B00A3; Sun, 18 Jan 2026 13:03:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3A706B00A1; Sun, 18 Jan 2026 13:03:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9276C6B00A2; Sun, 18 Jan 2026 13:03:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6FAD46B00A0
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 13:03:15 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 30CD416058D
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 18:03:15 +0000 (UTC)
X-FDA: 84345856350.08.4F80205
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 85BC320005
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 18:03:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fF4nwr89;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768759393; a=rsa-sha256;
	cv=none;
	b=YOB7p9BGAg8LKezmm7P23jE0HffD1C3mrX5fB2gYZ6drRRa9b/ffYkIbHtZG86cdXX53mQ
	AIzxMsISzYunxeMVH+L4K3rU4q60WsTY/rMYo7Cf0vQzMF872Y+qHm9VcVfzALM1Sa4aWy
	LShrtTK0SGwHFz67ICQW7ufeiznLvSw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fF4nwr89;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768759393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sfy84ZEI+Ha1oIjHWB9YKUy2EoyFEgj0tVBfyTE1Wgg=;
	b=1dVTC1ujkgXF6l0wEh7SXk+JGe3IY99PwAFkCeh0P36ih5Zhbo30Tmymxp6d7t4IZMoeP3
	EupW9UvWxeXllEevLvdnZOUGTtMxAzGMpEICbWO/cugitnH40t8eCV/4Dza2jaACu6eEB1
	Xw0WRMou5rJlYYfPOU6264nA0PEjYBk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0553460055;
	Sun, 18 Jan 2026 18:03:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F710C19425;
	Sun, 18 Jan 2026 18:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768759392;
	bh=xYh/MGaprulPNWNckX8ng3qqlquYOGwnkkCr2j/CcxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fF4nwr89OKAuUIN3mG1fkkDWDB5TKShvMFkqun5REmQjGP9UF46WnzFMcFDo6PlzG
	 UNTds1GHE2O+QypTxIbRTb8DC8D2RAb1tk/W3BnGyZuCC8JKVLYQx4sXfgYVyxYkeu
	 SEhkr+G16cNxUTT6eW/NfCye+8yZdGTEhUuQrjvvt3eQ6UQrJ/AH243W1Ebd3HYXwH
	 ly9seughSUdCihmUS0J+8xsTBbpf57CbSg1xl3ay3OpgIfPzWLZAWavdeAidWlngLi
	 WK5IIZ/RaCtKOnNod0QlDFm1TFHYO47JOqvB4xfz5oAvogUQYtnwg9kU9h5i+FweWH
	 hYMCfaIghU+YA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/8] Docs/mm/damon/design: document DAMON sample modules
Date: Sun, 18 Jan 2026 10:02:54 -0800
Message-ID: <20260118180305.70023-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260118180305.70023-1-sj@kernel.org>
References: <20260118180305.70023-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: adu4wr7976euj45rnbk1tfugbiefgjzu
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 85BC320005
X-Rspam-User: 
X-HE-Tag: 1768759393-789369
X-HE-Meta: U2FsdGVkX1+CcQI9I5SGr3hZUStX3CuYXfJ4m84FYfjHjOlJYa1Uj35RER38471Ea1DPLcgwUzA/HUZAjNkMr3sTj1V5pnQMuk3qXoaVA82BXHeVndw9e4MMX010YPZ20IEXw/9a+5i5meidO+rWD1Q24pVB5lmU7ledcK/XJJ5zROgZWvWiVYKXPSFvY8HcuK0q2QK6/97kue8XniTIgm4gxipaOwhQSjbrrKdQljlSWhtqQTzxT6/myRRU/buPgxMiK19Zesv8B6mIB7aTLj28olCjGzlcqxQF7CQ6mHAT0BoJEcR5c2BKrYn2mvGxTbP/HZKSjL3N1PT4Fqih2Pi+V4ofoQSlOXWlfoemyDltctabJA3pEELuercg0A5WKpDwlYmfPLQOA9AtWglP71P1MJ5OuYQcgcIWitUBiGbTCr+wdBybbUkCvFQcarULyfSa0NXQHhu8IaCchppN/awSJ1JdiZAYKBosZ0gbn6W+fH3otZCUkmB3f4emXgAFJ65vWm6Q4u/5JnQxQ8T7R6jVlFZE35ujcB9K0azydgYQHi9ovc6CzyeR+YSCajsW4KjcwpuwTu/cxe+kfcbNMlkA9Q8L/VdfXoH4uaqIx7OCncJCJaia1QdA81HJ9/P1mYb+I67AYMyPI3CPCnxsIUEr8R1U8UOhvM25cRpzmy7ByI/orqVgU/6PxPdX599p6c0WeTDB2MqL/0fdKLxYgfbz09fZBDZ6bAMjBXsxz1jRP//SHJUYOYsRmw7aeC+lc1E6dDfPNvynmQ8tBEpBdxZSQeDOPgFf+BX2K7p/OkLNhcr8qJoEhZ3uEpClB3ugu2xn6jdR/la7U3GIcQWQ/iLRTJFI+UFlQVgcjWSDf8SZmopVqK5rCsewppAxIHdMzVxbp6+LY3wWkOajLUDmIuuskHChLvKC1fY/2MrXv1y0xMwxz+I41L8fq4nmmoIrGWwjhZd4JTkzb5fleRN
 GTzb2pAr
 BO+eCyvuAkd1T4A6AMfj6SimNdzo4J8ekZ61KT+uPHG728ZTb8roF/2wdKyPjr5guf4LSALxnqB8AjqIR4Z38LOJQEifNga5VwZ8G0BVE7krr6qbME3wBNu5/in9VE266my6P5UPRMrfMiSyObOwW1855uoKBfS7GWBmu2W1mfVIvpLhaROqcTS/AHodhCvW0oiEeJNimvBBk8JHQjYe8h9NVH6RRXX9VuV2+eIEOfWTPf9s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

People sometimes get confused about the purposes of DAMON
special-purpose modules and sample modules.  Clarify those on the design
document by adding a section describing their existence and purposes.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index f3db943d7efc..da0bc40c2261 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -836,3 +836,16 @@ modules for proactive reclamation and LRU lists manipulation are provided.  For
 more detail, please read the usage documents for those
 (:doc:`/admin-guide/mm/damon/reclaim` and
 :doc:`/admin-guide/mm/damon/lru_sort`).
+
+
+Sample DAMON Modules
+--------------------
+
+DAMON modules that provides example DAMON kernel API usages.
+
+kernel programmers can build their own special or general purpose DAMON modules
+using DAMON kernel API.  To help them easily understand how DAMON kernel API
+can be used, a few sample modules are provided under ``samples/damon/`` of the
+linux source tree.  Please note that these modules are not developed for being
+used on real products, but only for showing how DAMON kernel API can be used in
+simple ways.
-- 
2.47.3

