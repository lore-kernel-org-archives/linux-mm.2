Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1CF2606A883
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 14:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=e7M6b99B
Received: by kanga.kvack.org (Postfix)
	id EA1716B05B8; Wed, 11 Nov 2026 09:07:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E52496B05B9; Wed, 11 Nov 2026 09:07:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D41146B05BA; Wed, 11 Nov 2026 09:07:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ACB7A6B05B8
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:07:15 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5209F4028B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:07:15 +0000 (UTC)
X-FDA: 85423015230.19.F9AA3F1
Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	by imf30.hostedemail.com (Postfix) with ESMTP id 228848000C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:07:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=e7M6b99B;
	spf=pass (imf30.hostedemail.com: domain of "prvs=768118434=farbere@amazon.com" designates 52.42.203.116 as permitted sender) smtp.mailfrom="prvs=768118434=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794406033;
	b=IrO2IjXmNqklNtev7KDgOiknfCBF7Hx21ihPZxPKHZI6gcgurWEpfSIJrTHXAPidkylF1M
	6C+cwxOhdh6rsAHSPaqih/Kaw6jY2Tdaqf4ma5XWe5amwOrDe6eWAoMNepJJmXjFlfCvN9
	MTJDjRqVmfvEu4PzwvNC++oYGc7iQlA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=e7M6b99B;
	spf=pass (imf30.hostedemail.com: domain of "prvs=768118434=farbere@amazon.com" designates 52.42.203.116 as permitted sender) smtp.mailfrom="prvs=768118434=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794406033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lNsmVLumwuxsRxdUtkzWmrN8JhUX0gR0pEJL5hni08w=;
	b=yIK3M8JW29bk8NzYNk+w9ucf3w6Sm+MeTMsL401OTswmRAQZ2iypbDAQNl3a24SYxyL+Mb
	HDdnbN2u5RKWAldeZRhAGfbvlB0Ou3OClwafeGxxyhxHeaARtAWl6st9T0bq1bXqR/kkvA
	2UT8GG9hJBNAj0wtCPelAqBNyGw8gGI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794406033; x=1825942033;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lNsmVLumwuxsRxdUtkzWmrN8JhUX0gR0pEJL5hni08w=;
  b=e7M6b99BJuOiHb5qhZArVSRVs06wWbFw5mPDpifhzso/Q5M37nzKuQeQ
   WL5yuZD7WXtJcpI/J+ZtUmAi7HYiZo562iIJWEbhuSMu8PrmrbdjT3rLC
   jYPDp41P54aW2PWIiLrlhEWiOvq/X2uwlfpZgoftYqKhmJz4lKCLjxSRm
   JDtcqIauHgEB79W9kMbIvR/aUQqDRWl0HoJ4esiv+hLjzns74CcHBr95c
   khhgRYS/a85zRPPB3Xin9uFIEDNshslo0QomGNLGrxe6H6SI81w2Iijdp
   T53ojgoRghMlm6qkZanLBBC9E/41Zlmo+wSahMgJnvafAgs3ZgGDtkseM
   A==;
X-CSE-ConnectionGUID: s7rBCfALT0qsy+rJMuzW9Q==
X-CSE-MsgGUID: Qg955fbHQp2UbEVkoLD+Mw==
X-IronPort-AV: E=Sophos;i="6.27,207,1787011200"; 
   d="scan'208";a="33751585"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 14:07:09 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:31323]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.12.127:2525] with esmtp (Farcaster)
 id c170e4e6-a4d9-4391-83cf-d1cbdfa528a3; Wed, 11 Nov 2026 14:07:08 +0000 (UTC)
X-Farcaster-Flow-ID: c170e4e6-a4d9-4391-83cf-d1cbdfa528a3
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 14:07:08 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Wed, 11 Nov 2026
 14:07:04 +0000
From: Eliav Farber <farbere@amazon.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
	<usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner
	<tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin"
	<hpa@zytor.com>, <x86@kernel.org>, William Kucharski
	<william.kucharski@linux.dev>, Vishal Moola <vishal.moola@gmail.com>, "Alex
 Williamson" <alex@shazbot.org>, Peter Xu <peterx@redhat.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Eliav Farber
	<farbere@amazon.com>
Subject: [PATCH 1/4] mm: drop the huge PMD assertion from walk_to_pmd()
Date: Wed, 11 Nov 2026 14:06:52 +0000
Message-ID: <20261111140655.34281-2-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261111140655.34281-1-farbere@amazon.com>
References: <20261111140655.34281-1-farbere@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA002.ant.amazon.com (10.13.139.96) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 228848000C
X-Stat-Signature: n1bzncnjgkccywoca9hgx5xp5fzzk77y
X-Rspam-User: 
X-HE-Tag: 1794406032-344794
X-HE-Meta: U2FsdGVkX19AyExC1PQwOOZNGDII6B5Gatj6H83FZT80dKV6WilrIw1h+xWSTy/SMbH59/4hL8uFOyCycuBdH4CjuxF55S5eOpqnaqGO0wT4qf1TUaoYgtQRUa+K6b0O4GaQiirrHMnVqWuOuWRQTEpWy5EqwXSAu8Q4nLkK5eTy+o9NKKdXQYlYEEGaitb41MJmpx4fR3U5YEmczwv9P6kXtgQAuhnJUBSbAFcWF6RJyEAh0Q0S/P9G8LbBOQfdGyYmJq9ximyEiEgC+TMpk16p+otdR4rvrZ3cuN3AOOOWI6X1HVaaUa0qAwYERtl+u8tMyNP4hJYgG0EZX3JbPLMMMPO74FKSnqQ4sLV05K3DA20Q9iFoadPR05zvi+YCPW7i2W84pIYMvx9hYAYBLr4B+zokCo21xvvbhSttxyCO+mSeM9UVfmzptom/LKrj2WIlKUyOxNTTDKKw1jnc9qKoWgpf0TkeM51h7JmTm56rllEpYUvkaMWg0sLovlXc1ehARQlz9jcXaFZW9JVBx2LMrBThA5gndD2S7x15bT19fgzqWIoQ5aVpTO+NCx09D6DmrmEbZy7OhwEOyJrWbVSU3+sMjlQHSvddxM0gL8NuXvp4lAxpNQRi2mjEWKjigtLbSx/aHu9VfIOXy2SZkpaKRjZofJwPdPeZIolwjJVThrMu9MUTYcBZBhfJf/WDp0XMorUgZXwPbr2FGr2ykY5gZSiAjKwmdZtFQqw9kgItrNcxzNMV1Z1YdFNQ1kWqwGBBxTJ1PpjrnMOYasVYniji+10OsKUj+zu6LwoyCXmon4Ct5ikE3sna3W7+VdP2y4e55GNBJaejUgHuY6kjeZrGCMQFp2qWotGKQyn7S6fUOXb2I7vM75Hy/g+j4IB00XV7XFzKZ/igNu6gtDS6qlicp4x8fnwhKMbGKYHbDIuEjG0FQkD7SxPXmvdeBwOq6jT8CJLR29AMYVhHqHK
 dWrCtyHl
 9dQTW0wD5SvGv+kWsdtrqWqiqEDr1WGsXmGHzzP6ZjfmHDuo+on5GINDC6OkhoecwkLUfa6v7rrCMiRC+xH9sg4SYtBSLLjjxpeAfpwJooTBEb3U28oOd8ksTv3OyfIynhZgGZRpsRDldxSvtKnf/48l+IlAsiX+4Baum4jDglJqaAW3eCBaKI+lKzFR71wQBI2m68i5BwhkAX99lzj2XxgzKtrXkzlvBVArCTLtZC4ZWDD2e9rRLt3pjks+mRcPPB/E/hbQFhM3fmkUzyEerdNRGoAKFGE3fApc3OrjAmQMGYOxMc9HqmsA58vL07gdCIdJyN2BtmemibBdZrs/PHNMu2oR2sUE2ACMgpvcgXWo+yPA6Nbdzqa8v55L/XxpI/7Prr3KBdXGGQGrlICGAKX5+MiIA1tckzLO5Pro0MyVAhWKvZ6YeSzaJODjE3A7apZTm6NHl4aXfPnizYGYgGhGNGVxJDZhFE1TPxW2vBj0e+lCOBtckkMyGI4JU1PXIdN55sCNeEEDYaW2JbwAvs/tIRZqmlyrrSZx23nmZfveiPvBpbs66kPZiBf9DMN7xkawkst5LXGkFBM4V8xC6NATUbcAzSOcIhtXQf+ubYsZ9/DRLpS6ULh5K9YO/ukBnZAK/Qc8G/TQPsiqMZ61Zjg0Wn371HKrSpXU/2CHn5SqLw5ePykkfaNzlxGoZSo1TkzEd70ZeFMiFs3NEJdlTreaHjzbjIVG7RN+2+UGL5u8NmXBtF+h/PIgdE1qvJUyDByhn3B/q8N8KFP/TuKmrPdOspY0mTRYwJNpZzJE5RszDt9JVBWvu5+dyWI6b3FVTPR6R/2PMD1IXH14=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

walk_to_pmd() asserts that the PMD it returns is not a huge entry. That
held when commit c2febafc6773 ("mm: convert generic code to 5-level
paging") added the assertion: nothing installed a huge PMD over the
mappings its callers walk.

ARCH_SUPPORTS_HUGE_PFNMAP changed that. A VM_PFNMAP mapping whose driver
provides both ->fault and ->huge_fault can have a PMD leaf installed by a
concurrent huge fault over the same address, so a caller can observe one
and BUG on CONFIG_DEBUG_VM=y.

The walk does not need the invariant. pmd_alloc() only allocates when the
PUD is empty and otherwise returns pmd_offset(), so a leaf is returned
rather than overwritten. Every caller already copes with one, because
they all reach pte_offset_map_lock(), which refuses to walk a leaf and
returns NULL: insert_pages() turns that into -EFAULT, get_locked_pte()
passes the NULL to its callers, and insert_pfn() returns a fault code.

Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 mm/memory.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index ec3d9d99ccee..0f54ee0a6d88 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2384,7 +2384,6 @@ static pmd_t *walk_to_pmd(struct mm_struct *mm, unsigned long addr)
 	if (!pmd)
 		return NULL;
 
-	VM_BUG_ON(pmd_trans_huge(*pmd));
 	return pmd;
 }
 
-- 
2.47.3


