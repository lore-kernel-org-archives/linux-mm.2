Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F780C55ABF
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 21:06:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 992E36B0088; Wed,  5 Aug 2026 17:06:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 943EB6B0093; Wed,  5 Aug 2026 17:06:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85F896B0095; Wed,  5 Aug 2026 17:06:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 52A366B0088
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 17:06:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 831E51405D7
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:06:08 +0000 (UTC)
X-FDA: 85068448416.27.D4831E9
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3C8614000F
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:06:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=jttHYba7;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf11.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785963967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Iuudu8THMhTPdbtY99FmaOUUzNBZygqz4n4fsPGJTs=;
	b=h48dwMePjbZyCyc6+8/Gp3DnX5OMSQvYHvEHJeXoRdcv6yNsqbNBPkfZyhxfiTQRDSPd9d
	1kh+xxuc2IS1YdH2QmrUNAXAnT7wXYW0A1ffkoQgB4/BYiC7nOE6VOmqIEWUL04brv+jgp
	NKjcovNXsRHiGJu9AN3Kd0i94XsLGuw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=jttHYba7;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf11.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785963967;
	b=Yi8HbAOPTdCQWIqhAV3qxFIMsSdUcqOnag+wFO5S5thEyroz2UVQszTVPlQHtm5hk2yxQw
	aEs+giy3fmfJBePKeqcpwuBCQCR7cg5kXYJNoQf7uIH0+r3/MpRgOcxmeZjLg4MI4JlV3M
	m2nbKfyZoYWkpjZsbZLEI7BwGI4EFd0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=+Iuudu8THMhTPdbtY99FmaOUUzNBZygqz4n4fsPGJTs=; b=jttHYba7DCQZkDO6zhHaEiHRPQ
	Q2vrpqDBKr67LBvg6g1EMpDyF3plhZbSAE8Z8FFGzEi4s1MVEgp6cfoBCLddP9I3uegd5dRX8THMo
	G8Mhm3S9swaNqLWhq/inKzLG393Ou39Cl4hFLlZzrXp7qACb1fTPNQ5pORZgT7Y+oG3NS7UwkyjBE
	ZQZx+P8a/6IccPRxQHrDjKpad+xr5aWvYqtgGk300fbd9MFF5QpE1NhNfZXy86nSy15S6iXMx65oh
	uzE56ARnYqcdsOf7blHS65y8fgMop6i6TNtoTiQjlXgTxgM9KAiPkbfHbHyYX+ocEbowJlqnV0L3V
	aTmReqTw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrioJ-00000004h6F-3eDl;
	Wed, 05 Aug 2026 21:05:59 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>,
	linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>
Subject: [PATCH v9 06/15] kpageflags: Use is_page_hwpoison() to set KPF_HWPOISON
Date: Wed,  5 Aug 2026 22:05:46 +0100
Message-ID: <20260805210557.1118966-7-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260805210557.1118966-1-willy@infradead.org>
References: <20260805210557.1118966-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3C8614000F
X-Stat-Signature: ee6iwrwg447wkm3p7qj7iqwoysfcuw4o
X-Rspam-User: 
X-HE-Tag: 1785963966-313536
X-HE-Meta: U2FsdGVkX18Jy4ay6U8zsTQ7uJRBBotWyMU/0Bofqla7U1B4yAsbqny1ozuFL9kbpxQ/pkmTN0z+aYDmrW7b1eBej/d59rK/eWi+IgAzSO1SOlcu8gSKliJ6VzD6hLxJLN+WQILf+uUpjWC+K3icqLxuBbaVIlE8gjp9pllvotK8AkjJqreVdLe3KITekjei44BCXTZrDQKB52qWNYN0IcskPWR1ner/ma+cLHfn3wOQs3i/ErPQCl1ICtrfV63QhB5ZQ8BLkgpC9yV1i55/pz+7cuoS+U1abmOdfR226WB8B98e6HMgeTdnU5yUgFFruc0rZyITZo78QtEIN5BCmXv6csLixXByg8MxMCpnKQyvdb/nEC6mRCnZo2dyKDXGzqKY7b7IrkzZyingiGQC0GuElLjbXF5eXrhprsBOEMTHUSkGQxd53hsHsU9rJ5oq8EC2K80waMLvUxCkZJ0E0b9kCwAtvtKwDMTmJnFqJZtwCbuN7NsIKP5dhpeot6Xagb0ipqaaPHCtcWAd+W/NY4wfNETTMzVtAiMvhLPqu6150sci8iKM5JRomKlMLc7JQ27FnomtROD5i9H4r4FfqcXv0Pua9i8qGE2ZePyb/b13LuGFmm7iwwNFW3i+FmTS5BOLFMACKmYRpYhecVzlsKs5abS6PcgTPQR1HflpKq4I9WkDhoSKJLxF4R1Qh3fI9O1GT22SxussErsXeFnY+w5H64GR1fp0JG5wzxpjcGCYD/UPv3upgQH+5/W0RuDNsrvuF/6FqaOe47bHhNRWycJ8xPmb9RpJbmOHOItBdvnC1TiB1LOjlDE+bK063s+l+vfgnnYNff5yK2a32+riek9Hq/1UMyzQaKzFWnBqhCgtryzQCzAps6Ez/oZ4GZpoY00DWOiF3OqCIHjHYCx4W/vuicPoO/vkxpeppoDZbkUZE3V0GidY8Bx2nPiDdioO35KxGm+1NjSkVBUMcXz
 0E7EzVq6
 BTpT4thcy7v4KIlRa9xAOCH/iAhZA3LF4aqq0QSfqQqF4icYJXSLPO/5GDJaJ6IEtDoTAoqRp5udiuF5O/8yqZ3rav/NMIwlpUHyyJ/2B1afGagaxahKqeRipR86lU1qaW5aUB19Wnx2SaKmgiRRq742CkQuzMHiIm23gvCaho32dN4s/jKA7vjpjddoVbbjmpI/ktNHlKN615dhuQWuUxUEb0XiqHM1VrRwDUfhvNQCenffedbZpAr0UuiYgYqTic5Zf17JM9VURSEdFmnxKvVDAroZwRvNXN08TKtuToP20TEwaMbfEMbANatJH77IKl+7+XtGVtVLoaf8tK1FdtRUU7aFsHNHHEDanNSTMpPBjyLcIcU+8XRBflhOrpiOzZ9qY0JaDH/s0zh3BhO7PVubmuwzmULfWM9snlM2LRaSv78XI8ccgHDxVK24mqfc8NkE2+5hPa30E6K4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Instead of knowing how hugetlb handles hwpoison, just ask
is_page_hwpoison().  This gives us the flexibility to change how hwpoison
is handled without updating this function in the future.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
---
 fs/proc/page.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/proc/page.c b/fs/proc/page.c
index 7d9387143435..323e4c049f69 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -233,12 +233,8 @@ u64 stable_page_flags(const struct page *page)
 	u |= kpf_copy_bit(k, KPF_UNEVICTABLE,	PG_unevictable);
 	u |= kpf_copy_bit(k, KPF_MLOCKED,	PG_mlocked);
 
-#ifdef CONFIG_MEMORY_FAILURE
-	if (u & (1 << KPF_HUGE))
-		u |= kpf_copy_bit(k, KPF_HWPOISON,	PG_hwpoison);
-	else
-		u |= kpf_copy_bit(ps.page_snapshot.flags.f, KPF_HWPOISON, PG_hwpoison);
-#endif
+	if (is_page_hwpoison(page))
+		u |= 1 << KPF_HWPOISON;
 
 	u |= kpf_copy_bit(k, KPF_RESERVED,	PG_reserved);
 	u |= kpf_copy_bit(k, KPF_OWNER_2,	PG_owner_2);
-- 
2.47.3


