Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9657DFF8864
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 04:13:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E130E6B0092; Wed, 29 Apr 2026 00:13:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC4626B0093; Wed, 29 Apr 2026 00:13:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D010D6B0095; Wed, 29 Apr 2026 00:13:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C33B36B0092
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 00:13:12 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CD482A074B
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 04:12:42 +0000 (UTC)
X-FDA: 84710272164.08.D8D9934
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 204DE160009
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 04:12:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C912i0Pe;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777435961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5S2SNfVHHqstE3G35Gok393sUdUU+lE2aSIhGHHPQXc=;
	b=nmvNoAmgbhHe1X4S0vZo6mPG+9Pnha9di7X2R+ZFy5tSzOMCRP+1Fd6aheiVCSrTSVoUhp
	UvKky3xCI0dWWBe+K6ARuGxqyaDOG5S9MnEsZhGiUzjnWJ53MwRc8wBZUu1nHrLxxwZp8Q
	PXHfeY/VJ7ud+P33XYqTld/uL0rX5x4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C912i0Pe;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777435961; a=rsa-sha256;
	cv=none;
	b=3yB4d0ezFP8NvnD7O719FHSIt9PyXPJFKOp78vOotz8Or2GbnDg2ulZ/4X+bAYHGnzhA3U
	+1lQD0Q4v50En1VF9NszPziehRECRFVDOmy8PnObGCE/69TbR3tUyRzAHcCnhIN1C6Dj+X
	9PO4WYF7bZZw+tM2ikhpa2WGVKg0vjY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 412F54450E;
	Wed, 29 Apr 2026 04:12:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F58C2BCC4;
	Wed, 29 Apr 2026 04:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777435960;
	bh=u93JPpTlUZa2B/ZunhEoNlylkbQxSRBwO+E/mC/FBAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C912i0PemsFCYsHBoZ9dNu2aeuVuI85VpslMloSdbwD0vPIrHLRERO1zehLZEVUMb
	 6J0hVMz7P9ORo9NEJRPgQThbGUerYmFz6R7GB2ZO3dnlGNWZCuJGrsYmTmyUrqoajX
	 25eGlkYwvOsQa/9B5aFVFnqhTa3J9LvYbXBaPxXkZ9bBnl3Zi7VMysmhKTA+zxNBbi
	 V2lrRlorpW35jyTcltz5R7kDibkBRAp5LOg6S5GJ6C09XAQjg3TqyGxyF4b6mDScTr
	 vHgzKUvkdtCo/NmmjOj4Z5MkJGY1SeYD7IaiAxCj9kGRpAAsiFoXFwkZeTHE5phcSz
	 t/3uNSkvvfHPA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 7/7] Docs/admin-guide/mm/damon/lru_sort: update for entire memory monitoring
Date: Tue, 28 Apr 2026 21:12:29 -0700
Message-ID: <20260429041232.90257-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260429041232.90257-1-sj@kernel.org>
References: <20260429041232.90257-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 204DE160009
X-Rspamd-Server: rspam06
X-Stat-Signature: 3jeb19w393b93csmfok7hooqei7g759p
X-HE-Tag: 1777435960-722495
X-HE-Meta: U2FsdGVkX183MmzxEWBzh7zGtB0NCrEjj6R9HqeD8Y0gxawf6xcXykbcZXwCR0wx2eijmRSzrVkZ8K4Vd1Wks/7h2PYbUcOp3kSO+ee8m6a/s5SvvuT43tC0BfDGVuD5Kw+5Pa7NEC/FQ4juBug9FuISo3cbSINLXGgL4YdMFYff4WizwcSaeGTjV0JZExviQX6oV8np7PXbzFkXtXPle1gD1iCuNNVQgd+A6uAwysSYgBMD/CFvll01n9zYRXCfwungZC96T2+B76WSpCufeUEj0vKtOipvTz8SlNXh5Fll8TqJFJW/563h21u2DCM5ConDmO174byjKUkYxYk4wiOSWs0J9GRWSWWUE4qcWi2M9LI3wlcrx0WfDPjEwOmEKOrCT+Kgln4oUTPtpWTm9aHKG84PIvR/6cVnLoMQxLziPK5Tk43nCjDhrvi1irpp+UHsW4xy9gs2W+pKALy3GtK6OHBfgh7Xy5G2xBA/pmbonIAJRg4C66u7YicUrH8ylkQHKW8ieHFDJbW0EsH+WhN0iFiaZ6V4FjML6+/3TD4tIm2wh9BfjU+4/bLNxa2z4MKJI88dDYNr5T0EbwXCYVtVYLH5vceLf93Tmz+07K2lDkP3xVQkeDVjKx3JqYK6J9dLkEVJR3mQ8QTqlw04ATafx0NUWMtyhUnSeJm56KjFs37x8SqhFgnnpYlAvcgoQRJ3CTl/GIkTT+q1VXD/Eb7lsnVxVIzVFedh5iLzX2PVFjVo4qs6w+cpjCrDDKHIadgchdvahKXREu96y7kBT5hwN8ndLBYHzPpULpwkjTtBEyxI4gmsujW9QAyHM0LoA6hvpe4w6XWTzTACqXr2vNDZc+cyzBJkplp82DlHOK2c/TrgHZnwELzO5vNaaq6d+qGi0VwtPKa99YLhJoFd5WYITovw6hr/nmHTngj+kXhmQrOcCtH9vnagyTjBDMUm4NFt+814xDJ52BJWP13
 wgl5V7Nr
 Pva8cxVDTeeuCHQj3YtaEE43jtZkeE+4c70ETldmKSftXHWel6ly5BfscAT8qaYt/M7JG3946ftK/PxXdTjvdJuaGFDbITNUm3DUUQJXb5lp7cSR8I6VYDc2qKdFoFIo2awEiGcRA+FdCRhyRQbUQW+DqsGRbQ3W/Q7vkFxJKn+6KK3afK9OEbZ43RdUtcxrZfZIQTbaozzHBrlY8TKM+DrodqfVwo9BjRUGWDGkwt8QdUV+WkxJd6JEJ71KQLYF4lBPPkhBcGYNpswqB/Dgg+WeLs1vXb6tVAGOK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON_LRU_SORT usage document for the changed default monitoring
target region selection.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/lru_sort.rst | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/lru_sort.rst b/Documentation/admin-guide/mm/damon/lru_sort.rst
index 25e2f042a383f..b93ca9b0853d2 100644
--- a/Documentation/admin-guide/mm/damon/lru_sort.rst
+++ b/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -246,7 +246,8 @@ monitor_region_start
 Start of target memory region in physical address.
 
 The start physical address of memory region that DAMON_LRU_SORT will do work
-against.  By default, biggest System RAM is used as the region.
+against.  By default, the system's entire physical memory is used as the
+region.
 
 monitor_region_end
 ------------------
@@ -254,7 +255,8 @@ monitor_region_end
 End of target memory region in physical address.
 
 The end physical address of memory region that DAMON_LRU_SORT will do work
-against.  By default, biggest System RAM is used as the region.
+against.  By default, the system's entire physical memory is used as the
+region.
 
 addr_unit
 ---------
-- 
2.47.3

