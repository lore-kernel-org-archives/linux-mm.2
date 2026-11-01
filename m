Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD4BF606A325
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 17:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TUN5wvJE
Received: by kanga.kvack.org (Postfix)
	id 09E196B05C0; Sun,  1 Nov 2026 12:16:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 055966B05C1; Sun,  1 Nov 2026 12:16:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECE196B05C2; Sun,  1 Nov 2026 12:16:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CEE206B05C0
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 12:16:54 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 574FD140A17
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:16:54 +0000 (UTC)
X-FDA: 85387205148.02.B14AD77
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id B3596180005
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:16:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TUN5wvJE;
	spf=pass (imf16.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793553412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vVLUu+AsEEXAqlGZC8nIuBCvaj1H9qW+4CIlawaJEH8=;
	b=KEndGb1kFNiGVETq3SVchaXiLtU72T7a5l2WEI6Q0AIxAdb3pM8ANf9VCllcGMeiFT1cIz
	F8bcmDGBhw8xnv4DpMjJr+dnoDzCxisXxoTeqF2aKD9cgG0H1t8Nz3W8pqQ8CQrHnOdELv
	gx/maojulE00GCAsAUxnVOMSZ0lpE00=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793553412;
	b=uVP4noRxODvWRcZAX4CoGDlNTVZLS6FDlejKRndHzZaxf5/yZVL2VMujRDCNPODXHEcIkP
	0crrwKfdm7/AhDfsKswGfx8jIU9da6JWCfSiKhP+u2DDd2RCPdnUmNWVQq3wjslo0O88lC
	zP8yot8jRyQ1VtaPzMqlqJn78krhuO8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TUN5wvJE;
	spf=pass (imf16.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0FA2160230;
	Sun,  1 Nov 2026 17:16:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545C11F00919;
	Sun,  1 Nov 2026 17:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793553411;
	bh=vVLUu+AsEEXAqlGZC8nIuBCvaj1H9qW+4CIlawaJEH8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TUN5wvJEfv3Uz/r/6lqpD32bfSF8HT/GsqWZCrer49i4z+4sdUInijR/xYHF0wBnp
	 NMYM9bhPf6BBTW7aFnnhS1EEF2zexd2WUbR6RsdsPrik0NZZqVXiI1GYDHsE/AveTh
	 7JCL31xQTXVQ73fPTKKK4ufh84Md2cfuj7/Lxu5CWKAq0wfhm9IFh6ZqC5Yqq/HRcE
	 f/AANsuAEe+a0KNoDXqmDrcovUyPLmxhEy+r1+Fr/XuMbypthEOgIMjDjxzmimhKjH
	 F/RucF6UYFjM8ramQNBsf9jGUpqY8xqN0WCqO4MLmfAC0CcUjj2Oz9eMhGBH0rc2Xe
	 jp/7MF1WT+WFQ==
Date: Sun, 1 Nov 2026 17:16:49 +0000
From: Harry Yoo <harry@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Byungchul Park <byungchul@sk.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Dave Chinner <david@fromorbit.com>, David Rientjes <rientjes@google.com>, 
	Dennis Zhou <dennis@kernel.org>, Dev Jain <dev.jain@arm.com>, Gregory Price <gourry@gourry.net>, 
	Hao Li <hao.li@linux.dev>, Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Nhat Pham <nphamcs@gmail.com>, Nick Piggin <npiggin@gmail.com>, 
	Nico Pache <nico.pache@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Qi Zheng <qi.zheng@linux.dev>, Rakie Kim <rakie.kim@sk.com>, 
	Rik van Riel <riel@surriel.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Will Deacon <will@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/7] MAINTAINERS: add Zi Yan as co-maintainer for MEMORY
 MANAGEMENT - THP
Message-ID: <audznB0maKC82yxC@minisforum>
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
 <20261030-maintainers-v1-3-97278f8a5f54@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261030-maintainers-v1-3-97278f8a5f54@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B3596180005
X-Stat-Signature: 1mqp6481owcj8ab6bryzhi9bmk5ucbfm
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793553412-331293
X-HE-Meta: U2FsdGVkX18hqYK6siidFQTk384Y5nFo9ZCiBSfrGLCHL95irJ7E1D12XpBclfB92N1y5yQ9TTeEU1pLwDN2CGBmeDQ3skYFPIBTfrEdsFwuWdrm1bGb7SbGH3tA5jQIvoyK7qcHO+vRkKBaGnph7QLzAi1VPe7MUOBqV1iCAwEs37dMdK4GbPRypn5H2904tcLL4le9+vJcgrH0yrEtItl65x8Bi/pUj6bGkSoMOBCaY34ag4UIqFRUiXwmg2/6UDDbn5NeiN9J8HlGoMQjgO+gE4s5zGIGKuhs3Zh9ES90MLoD25sVthzP5bndJ1t3t+5cwmMVQl3daLaZXu42sru4bmz79/18SWVpNHnQr7rL44zF9Fhs133JWekW5lsSNl0cdrjAB6Y3Ojimcrpq5sASYHCwdKh8rXwduYNoS9uI+9OpTLS/0AVfwSydPa2XXGotm8XIGxQTGQj2xVObJa67zz+43Qwb2H0X2HLRmFYSAMoLzNP3exzieJDN0JEJgqn8fhmnmaZL+oWc5WejedDBtIED3HEYDWQDudWuh3EZjz6qR0DCD5gwGOsUyXrt9indnf8yg+doE2obsk0sXdWACVC3zzDY7tMO05pkhAqVzhUsC+i6FPS0vngD4sDi6kmLuX+E3/VCXHkeO+HQIFcPkiHEGj0nuw3cPL1BGZWNwcd1BwrGQEq+CDxUces3m76n+jWUEO6m0Cmo1bSSKo5n6ZdW8DeY8p8YFQc7Z1oaaPwBoEflJUvJxKZc3rg2XTd28oIzbwp2MisMf/ldsYMlohYOoSszH7FNcHjFQsewid3HIYGwL4Ebp6w+DfUpK+3NCT6BZEkjI+WKAvzN/JDZ/9heTyzcCTkXI72YKmQgqThuDyV5HWlCS851Ln2zkJ1ElhNVvFkGRbkOYtRWvpqtFy92gvd2nlWWXrZKMlYhzYSbymw2MkG17Suab0PYlLwoeVCw1Wklo1lleS7
 ZRLEshA/
 Y+ihNr6OzANnWSSK939kY1HZ/1kLqHmST3uPrn9AOw0NRXKcSFpfO7XkCsc0daixl3GFssNaaMUc/S7IDRjMSxUE9SbJBxf1IO9Udxym+UYucdTuRV0sk3+RAw8fqNqDAQjaEgmduw373cGBMmtevuLyZWPpTyiobtJsUY6lzx/NwIXmlPA2yXPLKczqsJ6n+8da535l1fKLEgmD88J44oAU++boEQf2G09JnW8sU/QWWhwNbphIW/jqv0kbNRu2GQN0ZTEYo84Ivhwl4oYwWhARUWR3HRw5BAkmCkh3k6WhJnxZpAJG48ZyVAkJ6qjwKGuBksAIwA59dWkQVSM1qdT8l2Jpva75/nJqP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 10:34:27PM +0100, David Hildenbrand (Arm) wrote:
> Zi has been contributing to THP consistently and reliably over many
> years and is considered one of our most valuable THP experts. As THP is
> an especially active area lately, having a single dedicated THP maintainer
> is not sustainable.
> 
> Fortunately, Zi volunteered to take on more responsibility by stepping
> up as a THP co-maintainer. So let's do exactly that.
> 
> His placement in the MAINTAINERS entry is very convenient to perform
> this change :)
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Makes perfect sense.
Congrats and thank you for your contribution, Zi!

Acked-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

