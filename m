Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 896F2C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 01:23:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 727A26B00A6; Tue, 30 Jun 2026 21:23:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6899A6B00AE; Tue, 30 Jun 2026 21:23:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5767D6B00AF; Tue, 30 Jun 2026 21:23:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2E8A56B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:23:30 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9D74E120197
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:23:29 +0000 (UTC)
X-FDA: 84938460138.22.76CAD45
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf07.hostedemail.com (Postfix) with ESMTP id 318B040007
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:23:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Om7cdqVR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782869007;
	b=7kKpDRKYvHS06VrEiPaFF59mBEJF1xBlxutFSJkxh3wCw/1kgVK7e9saerKutBndmyukwU
	BkSguTd8jtGLqwIkosUteGzf3Xsiv2HBn+YVQ15YiYnvT2Ys7SwCOhSXINp4U3xLB54rug
	wmh3+eoJ/ouZnM5BQe5XeapFGa/erEw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782869007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hMPk4xo0goYwl32b+O7Fi24CGRO5SYSFgHPQLi10p/I=;
	b=E5oNlcZIKGTY+9kLxZekz3Y5dWvEBJvFC4GSoz9BYR0mFy96D/K5Cft1DAZcfE/2fNzre8
	YKxZaa2DOFh3bP4araqtwpiqGTKTqnvzRwRakJ8PqrxSpf/qSeJFuhlLVkYH8/ISl3zaMS
	lKFqx/xmNXjbOARnjzZ5+LuTCtrzbj0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Om7cdqVR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782869005;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hMPk4xo0goYwl32b+O7Fi24CGRO5SYSFgHPQLi10p/I=;
	b=Om7cdqVR2SQfzLtC/CUOMJu+oOYjf4Nyu27g3QsInJgvk7g2PvJA6l1ACJLmEtRw6F9wO3
	33K8l0IQAXfbzRsVjizow4th4jumCuDkN6jBb/fKK8cjObrukLPcQpcGq4ng4TaVI4G8EO
	SlYAhsWLv5RFgwm5a86p7Uxg0rf1rj0=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Ye Liu <ye.liu@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 5/7] mm/page_owner: add missing newline to count_threshold format string
Date: Wed,  1 Jul 2026 09:22:31 +0800
Message-ID: <20260701012239.315262-6-ye.liu@linux.dev>
In-Reply-To: <20260701012239.315262-1-ye.liu@linux.dev>
References: <20260701012239.315262-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 318B040007
X-Rspam-User: 
X-Stat-Signature: ak4qcqg3ygphs5fhmirzraomehgrugqj
X-HE-Tag: 1782869007-643344
X-HE-Meta: U2FsdGVkX1+5xixvlwz/WJtsQlclIBu8pm7zALPYWY3QmgqI8w/F6NjBWmCxE0aTuM6r3AWQcEd7J4QxPXsP3ypfkLnOs85UWpt32dnIzUq30jhElVfBmFDQgYc/vm1jp57cKNIymFYMX55FKT+OXkSD+bxtp2loeoF4nUMUp+phRX2+w7GEcFlTF3tbChXUvwhd4XGuQfur02neQgjg6a62S5+a+Nel4wmKHCjlV6M9LF/NlHupiFqA0Vc0LWmj1YrpOl0CaGJVLawUzwS8PMbbQeLvY/JDkSUA/I0klIPO76nIh/NXa+wgaCnbLEjSY+Bl/dpypsmfyD9htTsGuZ6N/Od8AQQ3tj66wcBkIcCKisRX31Fiy2W4062bfb5eCIBO6HwdsJsXADqEqUJQdKE4iWIkbuM3F2wYaTB58UcZzP/nm5YZADkqmud2HbDxOVhElagGg5d5dPtXGsUhIFg4oSJfBk93nOfUdfi/sPAGqBfaAx6i8Hh/ZaeFj8NQ2ddxiyfj/Qbyf/bCMYB3OYGUUY9aDg1E96KgLBYaIq2MSOabmQjP2TI0URpeTrWN0tFTBW2aLlW7BQHs1edW/OoheJvRGX9MCr+S2o0sO+Ket+ZwsKNMRDB1edm+hmtfWEgavj7RVz7BNUIYbzMWVZ+QJJMEpqlzhl6Yernxj8mvP/62kzSu2/bR0Pfo/KOYmk3pDiuECKi3NcvO9lAwStMc5oZwcJGfFyI94+mgF3963iv2vVOyl9tq05czxYq8aTtEEkxs1/VGtptLra7NJloxeT6PF9HDZZu3XrzeP8GBokDdVWFQSo3+0gpOUC+kaNw413H6c98WJe+8puF1PkN+zyTcuBdiXZX68NyH6z6uOIpUhjBr38ZADDH8pZsQf+01pCkNHJQhhXoYJcUNyBLbpA5r6Oj7CRIpvx7uNSsMQ6mIl6H6L3+nxvqAXku1GLH1QGUgzciDLE4GmMZ
 TBTcdEyO
 ohiw/kKOlOx+A2U7l2RdXRhiWtEiztyglaGu+Ty5+r5m2kMFNqVayPvA8HZQ7smqHUltVIes7AEZlo1UCKvX2Sa7PgjlPyM3MWoFdreAXNlsdHOTcATr29JIhRE5X7pX57yuwB6ls9NFfmDgJ3tuxvi6pqFKSOKE4t2B3RfCZ6bIJw1NZduXsfRicpjikQvVWrhAjkOWo+wf4cx8d+QDOTZ4ayrgA9RqSH1VRl13MvXItM4z+3c2JA0g84tI1GBFAz/OyFIkHfubYR6Tb6jqDdWYlvFD9jUt1CPTcVBdK7rewFt0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The DEFINE_SIMPLE_ATTRIBUTE format string for page_owner_threshold_fops
is missing a trailing \n.  simple_attr_read() uses scnprintf() with the
format string, which does not append a newline, so reading
/sys/kernel/debug/page_owner_stacks/count_threshold produces output
without a terminating newline.  Add the missing \n to match the
standard debugfs attribute convention.

Signed-off-by: Ye Liu <ye.liu@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/page_owner.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index fe2bf2274d8a..7520718f63f1 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -974,7 +974,7 @@ static int page_owner_threshold_set(void *data, u64 val)
 }
 
 DEFINE_SIMPLE_ATTRIBUTE(page_owner_threshold_fops, &page_owner_threshold_get,
-			&page_owner_threshold_set, "%llu");
+			&page_owner_threshold_set, "%llu\n");
 
 
 static int __init pageowner_init(void)
-- 
2.43.0


