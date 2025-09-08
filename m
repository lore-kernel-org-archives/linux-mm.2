Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE3AACAC586
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 12:36:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20B478E000E; Mon,  8 Sep 2025 08:36:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BBE38E0003; Mon,  8 Sep 2025 08:36:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 084CE8E000E; Mon,  8 Sep 2025 08:36:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E718B8E0003
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 08:36:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 96243160110
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:36:14 +0000 (UTC)
X-FDA: 83866030668.24.EA91747
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id AD8801A000C
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:36:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Wd5F5txa;
	spf=pass (imf19.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757334972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5AXKbYRLtxYcNR1yut317zhnZdWEsk0ARZGAWBOW04Y=;
	b=o081xqTT8iqil0RTkn01g641jPNcks5g9B+GF++5MXmA3LzWVdpgIavq7pCpv3QunUwPgU
	thPacHJYXx18022tmO7a6ygQgYD4KmXkYs1XzrTsOnr0vUOESIDaDO9VaWQ5LaBmGbvyvX
	tL7phTfzSOoaAyxjWYsMAGYVXXccTUI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Wd5F5txa;
	spf=pass (imf19.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757334972; a=rsa-sha256;
	cv=none;
	b=3M7hg8q2ZTAyJ0pTqTOzqjpWKBUZsvF6pXguGl4Q+LHAqFomVF8P+WPet4AbnxP/5bwJHc
	GlB+FwqbU2Mggax5hOG6murE+azQrqsuDqnP76FKttnshJxG12u2NViz26foKbus9yhUVJ
	V/eH0uSJu2I6WrJZoExCDM8pAqfxEU4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757334972;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5AXKbYRLtxYcNR1yut317zhnZdWEsk0ARZGAWBOW04Y=;
	b=Wd5F5txac/D3AjWdk1pqB6rYLNa+S65gbg7XTyFXZkZF2a3gmWEJlnRRs0GKQxtf99Zetz
	LqMZz6Qi9PKJUlvUGEtmyC0wuBre25zCl3JAP4Y3rybnj2K2WeQh5jfVO6ocVekeVwI0mO
	JRHO/FPC2W0u2gGXDJ7BZJEcEwVCLKc=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-634-KKEbFsUPNfS8HxQ-yvFc0Q-1; Mon,
 08 Sep 2025 08:36:08 -0400
X-MC-Unique: KKEbFsUPNfS8HxQ-yvFc0Q-1
X-Mimecast-MFC-AGG-ID: KKEbFsUPNfS8HxQ-yvFc0Q_1757334966
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7C2CD19560AD;
	Mon,  8 Sep 2025 12:36:05 +0000 (UTC)
Received: from localhost (unknown [10.72.112.11])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CF1C518003FC;
	Mon,  8 Sep 2025 12:36:02 +0000 (UTC)
Date: Mon, 8 Sep 2025 20:35:58 +0800
From: Baoquan He <bhe@redhat.com>
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>,
	Barry Song <baohua@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/15] docs/mm: add document for swap table
Message-ID: <aL7NrhGw5ftOXUZs@MiWiFi-R3L-srv>
References: <20250905191357.78298-1-ryncsn@gmail.com>
 <20250905191357.78298-2-ryncsn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250905191357.78298-2-ryncsn@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Stat-Signature: fpkhmjgd1eg9y5ey1n3tzqud91egbuan
X-Rspam-User: 
X-Rspamd-Queue-Id: AD8801A000C
X-Rspamd-Server: rspam05
X-HE-Tag: 1757334972-331310
X-HE-Meta: U2FsdGVkX19R6G5n6c8NrdROf5V4YE4osAJTJ74Y/dS9mUbET1jPjOMixTjgsFoZdKBh98CU2h5mkCzuiqyKn0vGcHB6sDptjHHr+4/T8cG20TmpFLlAnVhAg+4xr/Jt7DVpSsuWX9RBkSRoFVtFrZlzkAoIKnaQfAPPyyOhlvuGguhkf70Pd5OVAKAtlc/8OFxKlPRjkX8VK6YriGIrjgbKikDWaJS4aFqxjzwDtBOj/KJ5XB3NwERv5MGO8pOJ8m6P/JvmmlmiBCdUCdey4Ks4ymXxs0qKtUdzN8LccdD3kiraWTCfyF0ZhSfyJaxIXF5MTd4PBeW/WO/tvXfS4QXBLmSC/hWv0l4bss7FNJ22zBTM7mXjd2O3pgN71k1bR7x8ExEpO/OBjJjGvr9AReZeGu21bay1t1ve+xde/MzrhMcz7xWpk0xhk+DMMg0L8Kw+Km4rfZa4rSDwx4GCarhcAyTfgjrfOYMiLAWTlereCnFpwaI3e8PHFQL//qgvGf91+HsbxJikAW9fayEkkoit9SaSq6L8xTXVFW4tkP5yUijv3Nq/2lM69OtXcKlSb6jy85NEAMx6lQCUNwSRlYO/AX0bDJdYOPQQUj1rKPEXdFC0QQ1TUbyLZC4hkoUJpjQb0bwcA8t0eZ8GAurQ9ijlviU/l8cLYUnqd8XpGvun6+mrv5rO0WnR1s2G8Cc1pT16yRbpZFq3G7mZeCeyww+f2f5lccQZFfuX3JCrfp7ruUpwMQ0TZqxeP6GuDFxyHKS1pCEb6XsDHWtvIIBtiwBEkj4Ku5GSz5EB4sVHCXiQ0vEt2mjaoLORyWhpWdptTQRWTgbnrBwNO4u3UJga2JPqhTaTdOJFukiz+Dkve+82kylADakVePwZM3cTfUPFZf3eTv81srJe9mK8ilr0sXom+dtwCOs44gmUvDvIF/5H7B4qx0OK6X7GsPCmVE/Bd8a5aWP2wIgaVyW+m+L
 ldyC/1Oi
 aU6COk0kUfiTNlXtvz488sdAvGdi6bVarJdG2mPaROVEKKzHYDHxGE/fONbvmSY4JBcrK4T9zZqBAJvrlB37gIXh7M/UhhszH7xy45cI7lww3WCCQ66zprE6VWLJz/UqsVJKXQYcB0Ojy1MlB0LfEQSXOWHZrj69xLLBLWm7ugAVsKCYQ8o5GaWPnGSCH0EsvaQa1kk/JQbv1BmSMJ9ypixN0GBO9JbhXJgCwo7ZoYTuUoG/ob6yz79/Uhdvv785FY9gUtNlV8KQ0jzjITutxjMXlCloy4W08hPd0OaloPwZv+dDStbVKXmwaYYzuyhDeA7SimqTni0gZVKTbWHjdQe9/fQ+7+9eO7jKVpyrg+2x1fOxVasxDoZhx8g60RsfSOTMMFQz62to7eeVFpQb3KnvF5W+G7CU1ZkoUrUmUyedokLUsudQ3/QO68v9cK/JtyonVH1EjWBu8z1R6uXuhj8LBSZN/FYAR0HTj3YfneQv+fJM7yRIgBCYbcg1EfGZ/rQ/kykljMDSJic+W6LrN73eGuW87QxdW14eJlVPxuIROolLxJCpFgiDrZXnjDkASO2Pg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/06/25 at 03:13am, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> From: Chris Li <chrisl@kernel.org>

'From author <authorkernel.org>' can only be one person, and the co-author
should be specified by "Co-developed-by:" and "Signed-off-by:"?

> 
> Swap table is the new swap cache.
> 
> Signed-off-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  Documentation/mm/swap-table.rst | 72 +++++++++++++++++++++++++++++++++
>  MAINTAINERS                     |  1 +
>  2 files changed, 73 insertions(+)
>  create mode 100644 Documentation/mm/swap-table.rst
> 
> diff --git a/Documentation/mm/swap-table.rst b/Documentation/mm/swap-table.rst
> new file mode 100644
> index 000000000000..929cd91aa984
> --- /dev/null
> +++ b/Documentation/mm/swap-table.rst
> @@ -0,0 +1,72 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +:Author: Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
> +
> +==========
> +Swap Table
> +==========
> +
> +Swap table implements swap cache as a per-cluster swap cache value array.
> +
> +Swap Entry
> +----------
> +
> +A swap entry contains the information required to serve the anonymous page
> +fault.
> +
> +Swap entry is encoded as two parts: swap type and swap offset.
> +
> +The swap type indicates which swap device to use.
> +The swap offset is the offset of the swap file to read the page data from.
> +
> +Swap Cache
> +----------
> +
> +Swap cache is a map to look up folios using swap entry as the key. The result
> +value can have three possible types depending on which stage of this swap entry
> +was in.
> +
> +1. NULL: This swap entry is not used.
> +
> +2. folio: A folio has been allocated and bound to this swap entry. This is
> +   the transient state of swap out or swap in. The folio data can be in
> +   the folio or swap file, or both.
> +
> +3. shadow: The shadow contains the working set information of the swap
> +   outed folio. This is the normal state for a swap outed page.
> +
> +Swap Table
> +----------
> +
> +The previous swap cache is implemented by XAray. The XArray is a tree
> +structure. Each lookup will go through multiple nodes. Can we do better?
> +
> +Notice that most of the time when we look up the swap cache, we are either
> +in a swap in or swap out path. We should already have the swap cluster,
> +which contains the swap entry.
> +
> +If we have a per-cluster array to store swap cache value in the cluster.
> +Swap cache lookup within the cluster can be a very simple array lookup.
> +
> +We give such a per-cluster swap cache value array a name: the swap table.
> +
> +Each swap cluster contains 512 entries, so a swap table stores one cluster
> +worth of swap cache values, which is exactly one page. This is not
> +coincidental because the cluster size is determined by the huge page size.
> +The swap table is holding an array of pointers. The pointer has the same
> +size as the PTE. The size of the swap table should match to the second
> +last level of the page table page, exactly one page.
> +
> +With swap table, swap cache lookup can achieve great locality, simpler,
> +and faster.
> +
> +Locking
> +-------
> +
> +Swap table modification requires taking the cluster lock. If a folio
> +is being added to or removed from the swap table, the folio must be
> +locked prior to the cluster lock. After adding or removing is done, the
> +folio shall be unlocked.
> +
> +Swap table lookup is protected by RCU and atomic read. If the lookup
> +returns a folio, the user must lock the folio before use.
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ec19be6c9917..1c8292c0318d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16219,6 +16219,7 @@ R:	Barry Song <baohua@kernel.org>
>  R:	Chris Li <chrisl@kernel.org>
>  L:	linux-mm@kvack.org
>  S:	Maintained
> +F:	Documentation/mm/swap-table.rst
>  F:	include/linux/swap.h
>  F:	include/linux/swapfile.h
>  F:	include/linux/swapops.h
> -- 
> 2.51.0
> 


