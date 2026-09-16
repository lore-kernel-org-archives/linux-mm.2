Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E1ECC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 08:31:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 298746B009E; Wed, 16 Sep 2026 04:31:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2489F6B009F; Wed, 16 Sep 2026 04:31:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 138186B00A0; Wed, 16 Sep 2026 04:31:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E6D8A6B009E
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 04:31:15 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 74FD41C2BE2
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:31:15 +0000 (UTC)
X-FDA: 85218955710.02.100E6B1
Received: from mta0.migadu.com (out-142.mta0.migadu.com [91.218.175.142])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6715C40009
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:31:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oB731Xfb;
	spf=pass (imf04.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.142 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789547473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LYgs0eDocGkOb8jw6/zOx/D8FE4zoBZRIPvfR6HT2us=;
	b=aUbXxzOvlqvJKmDu5YicjSHP0Yj3F+LJBDyF+4Az0Lf+SjGZkfyB6xNmkAcN4MHxlz6JTm
	SMAkGVLAMqjzn3M1dNtmD5f8SvwgYrI/EvwuJ7Mjo4Kdeuop9ON12360WIZeGYVBXlKHGv
	ebzmJhABeplrKDotpjtVSLYdv8Rgwnc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789547473;
	b=8gPwhfM3uOVMX/A1WTkr8PdvhlD0OmSeeq0EzLtNKS5E5cyUE8oHk9Vx3Ktl4qdws9qKoV
	FyxqH9LwxKI5iJHcTy7Jamo0tUS52lLeZHhnXRil3TK51mE3Q5yibO3lJlxoKFuXx/A7MS
	hpQdiA0dYGuAIx0qaftLdcEGQPFf7dY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oB731Xfb;
	spf=pass (imf04.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.142 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ctKy9QzkrwFGINprhmFaQJweDP8zUfKnXLJOi5JxMXU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789547472; v=1; x=1790152272;
 b=oB731Xfbl8gqkFh1MBaADtLkS90TZt9U+LlgQhYjInoBoKd8NVutKMGBy0+I/OOGV7RjCQCt
 B1TyO6aN+lFoLcFx8DMZLXm99TwxSRyVmqhmiX/MjM78j7KSBnCJhn3CxAX2Q6FMb/PYCW4ihAa
 Ogp3F86gqj7Qsjia0VQGGeJc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 31b1eb0a7dd8dbd5;
	Wed, 16 Sep 2026 08:31:11 +0000
X-Mizu-Trace-ID: 31b1eb0a7dd8dbd5
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
Date: Wed, 16 Sep 2026 16:30:28 +0800
Subject: [PATCH 2/2] mm/hugetlb_cgroup: move per-node usage on cgroup
 reparenting
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-for-hugetlb-charge-v1-2-70fb708b2e4a@kylinos.cn>
References: <20260916-for-hugetlb-charge-v1-0-70fb708b2e4a@kylinos.cn>
In-Reply-To: <20260916-for-hugetlb-charge-v1-0-70fb708b2e4a@kylinos.cn>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Kees Cook <kees@kernel.org>, 
 Colin Ian King <colin.i.king@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Mina Almasry <almasrymina@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Hongfu Li <lihongfu@kylinos.cn>, 
 hongfu.li@linux.dev, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789547446; l=1229;
 i=lihongfu@kylinos.cn; s=20260915; h=from:subject:message-id;
 bh=UjdBnpGGbOAqmA9LTLWjpAUbVlww5rMxQAkpfS0ZMyo=;
 b=ht4ri1aXNFZvYlT+1QIBQBgJWaE7t/rotF/BblSeGXDJHsFmSPTwmcEDqMtwNsXeN8hyCqSqs
 CQpwPDRXgTiCgE6aVzX9GGGePHdVM0RVWmMMkAvzDA5Qvu7iZRMvggb
X-Developer-Key: i=lihongfu@kylinos.cn; a=ed25519;
 pk=rUpDSpB3neoNZRlGG6dHlFb3RepiJakcev+ucyqaZzw=
X-Stat-Signature: skunuxgkc5t6qe5h7ti5dz4u41yq4dnh
X-Rspam-User: 
X-Rspamd-Queue-Id: 6715C40009
X-Rspamd-Server: rspam03
X-HE-Tag: 1789547473-386784
X-HE-Meta: U2FsdGVkX1+qPyLMmJY0+wkRSb81YX1waTlufCMCL064JWVE92aTm9aTNY7BIlzhzMLlulm1pkf7chdY+2rRdC1y/XK8OrFxoQVwNrO0gYpOTm7P7PpcsXeANbQODbOZnwLl+6ofoJO9fbZ9RNlesNCBIWE/zX4Qic4iN6rIiQ8tnNi9axbJLAnvs19cml1AEFc3cnC+01x368wFmgfteqH8LjRQvv0aKP+w3qJJim7bdu9aVZ/npO52pqbMJFmthhOjHFdS43MFEyeA5XETYO4xFMVK0AphkKmNaSLqeoXr53p+raFbprXtCM8odYhAHiGtlHmRFP+1xOLRNqkuiER/i+/P6N/knNirBYgFmXDrNWDmdm7D0lNyfgLVar8GIilKrudjXmCS+UTs07l3FwSdx8zhMkDsn6tItT0MgrANX/ALBQO8aEGB/YwszQtjQGnGUswaLCAItjbMP5zreGDMkge/VycRLiOU5WXfJE3ul5IVRfaWxI52qZcngLRQcNcFbhiqF9PG3mxhh67WfdP6tuIzfIiBTpgdB9noub5/pEM2AcDaMeBiiL/AqHpHuW+TxI5cX9AOcffRbl18DgV/FkiNQjLqGJOD6kI0GtC82tgv+sUWnDMRWe1a2gOxDiHJdqEczvaKQdkkpT7Sh58UbLVT2MayxKNZuhezoNVoOck/MfPSinVSu65P/UiAGU2jkmK1VGG/7F/F9LGVMvKGdYnjglbGOvKM4fcM54lhRxLeUk+EW3WR1+uGyrexZFRhAZVsB8WuEn2kOtwD6W9Q/WZbJ1JLTSZW18h29SOTpmkc+D/dygTC0nYUwKyBFGgh7McwR0hW5O+Hx66U4adn6xu97k9+p6NZnKiEgY4jo4uNJo2gb5fkyz4nWx/73M4DK1cRAovuIl270VKp0KstBOKIuOdCxIVX20v18CWuVcFLT7D79ookrJjrsbViCIJmpFqGRjtyK2tcgah
 LtoPqr5w
 5hurR/1WvFEWLyDxreQUg7pBOC7PeaqBnnVVVRwvIdj3V3mCpQJMgjUP9nIQg1+dH6lF/OEzohMKo6kyC7mW3tcfriv+dz1PcTUr5NoYyNiwD8Ic5YZodOL2PDnHnTum6ZCuXrZQv9pEYvlxKwRqSc/6xLBpReeszF1PaV4I3kenti122n2sx2PzMDlRPtYlh9lQzthFADDcYNxHlR9tTbFVsiSchgX7S/Vms5H0DPtCG52fRgbRYVEzyxv4qfUof1FhFAGgVEl95O5L/rSSAew1ZGFA20RMIEjF+JN/yzsEyk9MTMv6VZssFwnRzcMUYmHdI8sNG386oCojchtklLe9mxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hongfu Li <lihongfu@kylinos.cn>

hugetlb_cgroup_css_offline() hands the folios of a dying cgroup over to
its parent with hugetlb_cgroup_move_parent(), which moves the page_counter
charges and the hugetlb_cgroup pointer of the folio but not its per-node
usage.  The parent's hugetlb.<size>.numa_stat is short by that usage while
they are charged, and underflows once they are freed, exposing incorrect
per-node usage values to userspace.

Move the per-node usage to the parent as well.  The folios keep their node
here, so only the cgroup which holds the usage changes.

Fixes: f47761999052 ("hugetlb: add hugetlb.*.numa_stat file")
Cc: stable@vger.kernel.org
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 mm/hugetlb_cgroup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index 1040406e7e1d..3f5ec4a06b25 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -241,6 +241,8 @@ static void hugetlb_cgroup_move_parent(int idx, struct hugetlb_cgroup *h_cg,
 	/* Take the pages off the local counter */
 	page_counter_cancel(counter, nr_pages);
 
+	hugetlb_cgroup_move_usage(h_cg, parent, folio, folio);
+
 	set_hugetlb_cgroup(folio, parent);
 out:
 	return;

-- 
2.54.0


