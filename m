Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DA5FCDE00B
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 02:46:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67D706B00B9; Thu, 25 Jun 2026 22:46:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62E1A6B00BA; Thu, 25 Jun 2026 22:46:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56B9F6B00BB; Thu, 25 Jun 2026 22:46:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 30C866B00B9
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 22:46:22 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B20521673E6
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:46:21 +0000 (UTC)
X-FDA: 84920524962.25.6B6863D
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1EF8AA0005
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:46:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Lxtg31Uj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782441980;
	b=YWi0L+TBeO6edhDXo+E+kDBT7mN4EWwflgTtZxrpdmvReCyD+FawzuEGitJHeHcl1plu3P
	+mZcq8V2AkQrGfmw2eLDJFF8iPm1Y8uUBDNKhqraZNpkWdo8KN/PBA9GzOxOcghqc4+GWg
	6GjH9otP5Dg1ZXVI8hW1DrrHaY1dcu0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782441980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NTLHd+1oM45Tb0ayVFKU2fogrT4VnS2NCHonHOYwY8w=;
	b=4lP/36oM/c0kzwr8BKH/2nn346+h70Ltf6sRteIH+Pexaw7kpnpM3qjeg03+9oDdkZkZzz
	nPCvOEl3YpLlYTFrbKbziXqgJJ70Y+hGDocPbakKfKhq/Vz96etscbzA17s6oQt2zNkL2U
	BQJ/gdoqb8vFsIk8p2PgFLutAU2F8IA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Lxtg31Uj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782441977;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NTLHd+1oM45Tb0ayVFKU2fogrT4VnS2NCHonHOYwY8w=;
	b=Lxtg31UjbEAyxqTKvCa/od30FlRYpDQFHMe8eif1RX6Nh7YN8g6vLgLlx50POHHgmi/EAZ
	KHw3/X5zMdy5ktJtAlR+zmEo97DwB3tnAD02q3WV7SNqMS5pA4dQZVAFty9HVxJqClXhRo
	kwjMGukrMXxCrFh+RiLAsO1Tj288yQ4=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Ye Liu <ye.liu@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/6] mm/page_owner: add missing newline to count_threshold format string
Date: Fri, 26 Jun 2026 10:45:43 +0800
Message-ID: <20260626024550.25677-5-ye.liu@linux.dev>
In-Reply-To: <20260626024550.25677-1-ye.liu@linux.dev>
References: <20260626024550.25677-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1EF8AA0005
X-Rspam-User: 
X-Stat-Signature: z1bnipibz6xjnyszykoby1nyt515itpy
X-HE-Tag: 1782441979-541448
X-HE-Meta: U2FsdGVkX1+lhjwbQghloOsT28O+F7cKpz3KMOOkD7EmfnfbsGr7mFuWHc7mgmM/vVCdh7/D5FZnxavAoZA2su6Q4/AYmcGlfqRmSxE4F27+yWX63Q297e8N9iYBxdJ3vEjlaw1mCINNK9MowqGbeaXPlCD/GutTNl2i/3WgAoWWXMDYrXp8+XJmzKgcN4ebKSwMA1vP/qLqxR8HKLRUlWxOq5sH0HAKaaglcbUirAu9jLJ1ghWq8Z4Qukytg4ifaEv+XuujxJzUh2nc6MFYDKaICFuOlxg7zPBIXzjNzn1NBFfbkp/O01QeWbBp2qZfk6BuQnO+pQJnfcghSoOeZ2hkFbZzKOJOjGBiZSiI5Xd+813UiEfnAD4L27s+vCxd+M+f9pfHQQuHOo+LgC0+CMvK7+5ZdH9FSuBeQ66laRajLO8wUXGDqvGeHcpAR6Sd0QGhlUcSkFHmL5UH4KO2YJdtAqMSr/XrvnQa65ph2M9uyeban0WQYJcLjZRP01IXmIIFxIa8B/h3z3sZp2SX0Cn2bah+dBldG/hHIdIy3wFuG1mcchAJ8d63jToeiH6EXLfIgSovK4Vhum6qtoBJX6HNTnzTibkOPT1Hg2qdGKsgPUDQcisHzgQcllxyRBG9BENvk4i+yQ1Wnd/IJuFAfJIjrYJdHkn2/AVeZ2wtY66KvVKQn2SrUSGBApodRxFva9FKhd8vsHlD6rqkraEAXu2CrFd2HE6GTrbiRcg7D0G/ExdubQn2t/Yfi6Bl3f7lvCGoJo5uvjh63B5T9/hcwB9uTOEpIQFYv1wGAEFUFSubeBeryMkXCQ1gutBdz9eqcODccSM6dkX3NpuhGIJ1okN/zXGepCFvf3mT0lzdAyHRb/4O2ulKDWO6/yxBK9l7p8brdg2igfdp4tFOSA49ULGlKbXzRg9oz6TBaXC+FfYxmeQXTPlnbAEvBNrQ5KHinapZRS/wyiv/ODEafUJ
 2KvncBtv
 IVUWDLeqjREXeAMS9Onc7GCdwOTkElhVQaUushQo+dNykpGLmLAPkAO/tlIhqfRx3mjpH9KAQr/YfULIZnrv7Ozg1mzt3138aB1pFAzQK8R7gbVefWYW2a0HEnUcgAHYypHh5y0Ery6oCk0p53viwiOWwB6OlM/MYZYv4JyST8LcggbRKE/OjlyQjC4qt7+qDUU6loAORIT1/zGkIgIXHFvz+iE5oEsS/YtCJcA7Agg3f64Ctkk8SUsWkMg==
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
---
 mm/page_owner.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 5d8773c90cd9..958151ccb587 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -981,7 +981,7 @@ static int page_owner_threshold_set(void *data, u64 val)
 }
 
 DEFINE_SIMPLE_ATTRIBUTE(page_owner_threshold_fops, &page_owner_threshold_get,
-			&page_owner_threshold_set, "%llu");
+			&page_owner_threshold_set, "%llu\n");
 
 
 static int __init pageowner_init(void)
-- 
2.43.0


