Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5293C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 06:20:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6CCB6B008C; Thu,  9 Jul 2026 02:20:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B44676B0092; Thu,  9 Jul 2026 02:20:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A82D96B0093; Thu,  9 Jul 2026 02:20:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 783246B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 02:20:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E140C40422
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:20:07 +0000 (UTC)
X-FDA: 84968238054.29.B241807
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id E37E41C0009
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:20:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=deA20KBL;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783578006;
	b=4gjY1XqtIb9tJNzeg/ODpPvtgG3iupamhsZeb8IqJ/7pt9BL2YBDD2JZSe9eHjhN4U49/n
	CGqlFF5p16GbCLWmqBKNVHSYSjZpRRw43eZhk967LfQ5rQhPbkiqJlRWxS/8rJN86g3K3o
	de4hz6fv0rT7CMF8Dt5r1s7/Y85ZejM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=deA20KBL;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783578006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YCfbSPYkuXgQMKbs8/rTmLjbAoORspmCy2JKVmh+HMY=;
	b=2klnXRLiRztw6E8byY/yusdmwfUUrnrv/+DoeePGcZy8C8G910ZbtprEVKW5k/mQyzS3Ov
	f5ae2+FmO7vISP2tSyUbmY9aXnZ/3fk/YF+paY5agPWUpgWWQcnAiUgkx6EeehY0suhctt
	iPnqZ1kLi6G9caAi8ODRZyDb9IpmIuM=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783578003;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YCfbSPYkuXgQMKbs8/rTmLjbAoORspmCy2JKVmh+HMY=;
	b=deA20KBL4gs5pH8xMVS1j0msOIFOVHuhmvXwqHy4R8tcdNVF+S8N+RBPihPyQdVi7qqgKv
	lsG2BAJdabQKkMub6HZAOquGVjWJF1OkWu1I22i+CErtYyEoKW/qZqnA/+uzTWAtYt28tu
	eR26KQyGBnkFgtIMR2FAFMu3tF/QIzk=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH 02/10] mm: provide free_reserved_pages(), removing x86
 variant
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260708-bootmem_info_part2-v1-2-156ce4986598@kernel.org>
Date: Thu, 9 Jul 2026 14:19:22 +0800
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>,
 x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Oscar Salvador <osalvador@suse.de>,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 linux-s390@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <9667F817-DFD9-460B-B7AA-C9F551190F2E@linux.dev>
References: <20260708-bootmem_info_part2-v1-0-156ce4986598@kernel.org>
 <20260708-bootmem_info_part2-v1-2-156ce4986598@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E37E41C0009
X-Stat-Signature: r1mfty7t3cxw4g67z9uexrra7zbi3siw
X-HE-Tag: 1783578005-633838
X-HE-Meta: U2FsdGVkX18wZfURt94RtybArVoaDLjl+EAVgBE9wyan+4WGatjq20kBdR0nzJXh2eQpPSI7wVkX7QVt0yCn526B9pLzPwkwXHUlRBGNF5lR31pQ0hKXlOreEPSj6wnuoJBIaipSGT9la/zuqOnZjYTpKI+C1492Z9TmDsjmQ7PvBWBc83Cya/QQjapamyAhnYf6F1i6eKJJCuZV4vY3UmlHOq27x6GOMbpvspuSI1kdKye82ol6koPfxunpFQSTsVDEBf1czo06RAym4wMljZ+cTBKpqpADMHbnHfSF/SDsnxCDYwQI0jaXU4Pmk3+i05PianBwn1Yvy56hUAxdN4P0Ob3r4Nx1w93kXZkwKgQ8vigysuPfMYw+BfsjGdhbfyN6ov4nY0liF4u11OjzvP6cZXQpk6GI2OZCtLkxA6v5W9m5UtPmteHu7CMGGL/b7R/4XOgdKaSPnzSt64jOWUf1CdxePJAEp9uCM7mJZO+dXONcluyLCrYZdawevrXjztq1126AkllBHikfNwWkewNr5CU47tODxm0Ztw35j3yTbmWzNgoZ1rxZzn3zKWV2wi3Wx3qs0MqswmSy5DtlfdpCj1i/ZhKP6fQlLTNBrE1R28wZ2VANRJsoHxnHW2QRf3kCQhYpDAcwUXO2bEqkO1f32Vx9Sahxka/W7sKZ2TG8MaJHlh9kjfIZlbV5odRddmy/4UHh7BYjO4gUru4bpSrbN/LdwUu3/yF7AbRtnBXecV1hwtkkjDLVU0hxo7wgkQzvqsdKlouusa2NeHh5QjAEBe7IpFPKexOVsNNvv459MWnhwz+4uMXm8NerbHBEkuKWCCLliSPSfvrzasCDaKlquz1sfdfXvyF47P7W0Kaf7CTLfi2LCVH1CO0q2BNAtlTQ4WqiDEXPjy6/eGOJ5od35c5zqEo4MPFX+8+YfmPxxkoXDppmA+w2shXhmq52j5zuvAr2wdI1TbFH8GP
 HPb3Jdh3
 CQPgxfFS7zrs03tDkxz2pICx85zMNPgljsBr7F8b/lbtDTgpuqClP2/qs0W/bw/OHS4UCVTDUg+Zh+JKRJPt+SMoLYVBDgdmOZvk/CC2Y4pSvwiW6UG7QIHXUsmOsGshQ9awRDyX70T2iAEob+9h/YULE9dgjH1vRrVkXt+/KZW48Vg7TnMtJz4Nun1hF6hFEJmGSDtjlpQBLtQ5YxDqUj7l6lIJO0orF2uQi5Yec7mCUxrGO7aRzSErGoEYirvVUeJq2CFYaeJsWAosjpN97O1xAmkXMpIuQhSF+4xbQo5cJbZxJUSvlIXVjSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 8, 2026, at 22:10, David Hildenbrand (Arm) <david@kernel.org> wrote:
> 
> Let's extend free_reserved_page() in page_alloc.c to free_reserved_pages(),
> dropping the custom x86 variant. The common-code variant will consume an
> order, so adjust the x86 callers accordingly.
> 
> Make free_reserved_pages() assume that we are freeing ordinary
> high-order pages, just with the special "reserved" flavor. The target
> use case for now is freeing vmemmap PMD pages.
> 
> Set the refcount directly to 0 (instead of 1) and call
> __free_frozen_pages(). Add some kerneldoc. Use a single
> adjust_managed_page_count() call.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


