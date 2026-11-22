Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 906A2606A338
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 15:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BXM9DxsY
Received: by kanga.kvack.org (Postfix)
	id 901BD6B05B9; Sun, 22 Nov 2026 10:45:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D8886B05BA; Sun, 22 Nov 2026 10:45:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EE976B05BB; Sun, 22 Nov 2026 10:45:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5987A6B05B9
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:45:14 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B402B40704
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:45:13 +0000 (UTC)
X-FDA: 85463178906.16.A552CEB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0336E40009
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:45:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BXM9DxsY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795362312;
	b=PgXR3nfya98NSO7VTPtjU44b2PmCzlCtNfg6Nwg2v9zM66ihXnXiJt1tfGST3Xh6hTmEW0
	CQf/mekXOopELUzNeIor7gg2k7S1GBXRLgyWjKfd+TAri3Ec8W4d/chrVbwrw+Ppty6WyD
	M1AuENWjGyUI7TcNdaczOD8aXfFN9hk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795362312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sW+eQaQnsCtB9xADUO1Vgac8/iI4NPH4lavfmN/uT2E=;
	b=6HbXTICfens9f94eq7UX/aqvdqhnaNLbfOOiYbBbHD0xzqnvkZ0blnke0aeIGpGFbjeQdC
	9IQe0O/e/UTBAZvR7DWITwhzkLFeO1VdZa+5PaVUtJYupX4wiINyeIDGvNyrSMfP+5u5DC
	bwpzNPcYUHTfSt+o6NcxXN7/XwAkTvU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BXM9DxsY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 92D356024D;
	Sun, 22 Nov 2026 15:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE641F000C4;
	Sun, 22 Nov 2026 15:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795362309;
	bh=sW+eQaQnsCtB9xADUO1Vgac8/iI4NPH4lavfmN/uT2E=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=BXM9DxsYqZOV06/Ftqj0aRP8plbW++upiWm2hYl1HOaByDwAouH86A4pOlg53gMkq
	 NcTu3OhCWcdd3FqXb6V5uTR/wKypF2Z1nWMwAAF8Ycckw8nkuDlpuo2V0k5nky66R5
	 q03Mt+dT+NQ5pji6/7FVuWNs0xNMKfj/RL8VUaXgaK48lY0+zg6s1nH4e63cZx485N
	 qZWn4kChFoMF+0XSO3lcWMYomCa67lhWonuXmbdQ/VUNinktZmLn2i45+A6X8QVbRC
	 v2MQelj2Ft8eYNnFl5+GjD1214lxZbymvSoJ82KpEls2/cppP86pOz1fmTU4R295VD
	 CrS8qG0JTwtcA==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 02/11] mm/mm_init: factor out common struct page
 initialization
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
 Mike Rapoport <rppt@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Muchun Song <muchun.song@linux.dev>, Li Zhe <lizhe.67@bytedance.com>, 
 Andrew Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 James Houghton <jthoughton@google.com>, Lance Yang <lance.yang@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261120100856.16929-3-songmuchun@bytedance.com>
References: <20261120100856.16929-1-songmuchun@bytedance.com>
 <20261120100856.16929-3-songmuchun@bytedance.com>
Date: Sun, 22 Nov 2026 17:45:01 +0200
Message-Id: <179536230136.3933282.8488621746442530780.b4-review@b4>
X-Mailer: b4 0.16.1-dev
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0336E40009
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: gz5515fj4d8oroqetu4c85d9gc4f6fnp
X-HE-Tag: 1795362311-80996
X-HE-Meta: U2FsdGVkX19/nFYSil3RUvjx9AZMxnXphpeRD4r4RyI8Zirb3Rytu0ZMOSr2+Hydhth6u1unoDz7Fr25+0yzGB6kTUHGMP+SyuoTrBIFwYoHGR0WMUYswFcV2PcYiKqbU9XzNv+adZlfkP2ObAoR+Jdiow1GVnS0iuc2kiv5rpI90bQrB1S95sjaeeOeGEwf5rgsC33ApvrDfzM0ZOp2ub4XZUKdALR/ZaTxHbC603UnvHO0Dj2tX+830OgYVjwC134NcxDSDwYmfFlUVf2kf+Os7uMO6m08BDxW5c0wPEW5R3fz9LCRSYMCoZr6fiLUWhKtZkkt25H2LOR3fo2FwLrjFE5XxTKPYqg3Tm4zJ7Gq+wkcIhZUsJ7VR26Y9EpPVLzWU32unU62IjlP6sceO57gc8jDo0YVZ5A/DapjhlFTtR7P1wp3yRVS2Fd4hKfRxcx7XuRELTnBls/CtQFWsjkpl40/SDiY0LEZwyL1ieevP6YAJxuTPr4Un/ta/KBRY2yWsqT/N3tKSqHk1z/mAFwIkzmbKPyTjci377beyfn65MZT7DQQZoSook6MCwkkKgXWT/zEDT0PQjM0Qi3McwtdW/HBaTcDjTbC1eeXGuL7BjP+tIYs5K6cDUSvlo7mTbGgrNcIbO8mPSezjc9KfQJQqpsNdbKdBPzf4DbDSO7aBCTPIK4NF+3XZpIj8mGoQzC6Pn2NTDCkVDzgKmUrRT9my1Tb7052kJ55V2jDlTLGfoAMkZEr0rR7RGKVU+I32PYWg1F3kk+vZxLrOah7iMJraQuY0LIsqQ0u8CkVwXUI5V1OtWDJlyCaTyzYSxD/FRK+3S6OxMAfij46VWdS/vR7XKL1qLHvWLWFTU9jSZfzJokdq/1Caw2gWLFUgN+rvEVqYwt2twM0CgWR0Xw2+i+5SGkB64+uHh2VdFScTFiM5RxlpDg2oeVOHPz4/KlwuLSZyHOGaA/JiQ7GUmu
 q7Sks2sG
 QYytTIILeFGCWrGqxoPb8JHqT4t0ediR2R9kt3ckal58rJtnUvFwhHwgzIX8fn6DP1aRGt1GN+s6tcTrwGTJdFdN+pbfHyjZMLrUB7X8w/5dOGKIu6CAt7f2pb/xKj3H7RlbMpatwZ3PtuzJflZN3X1U21CsH0YrUVEKWEAmtDOVCgepJwqzy05wpGE/pg0ddQdXVBpy3vOFZtfoRL3V6lmwWJ1SkDlV+6eZ8efZDmn5Y3gkZ1Qc7z9m2jAJMhaPjowMVw5pQZBb86PNEoZ/5eYzYHQQemHXsqM8BNQRP6b9gK95W47WDXyOl8VnTX9wdXrJCHNneIw1qgLe4LS/efO4OTl5U9xXuMIzweTTZ8K1nFLwQ3EYwnk3V9rW+Bm0a358HpSatICbZ4Siyrfj4yl3cd9sB/1mmIqny2jlojH6k7ok0JGJUzm9wyoLlr0TRoobGcy81BZod9a4kSWIefzLxHQjNjxT5ueTzuD52kGOPRkwkaTRfefz7mIJ6c1ptn5otAQ/9qpz2XN3wFcoQ7HhImU0yFCzUZ2y8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 20 Nov 2026 18:08:47 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> Several struct page fields have the same initial values for every page in
> a zone. __init_single_page() initializes this state as part of its
> per-page setup, while the shared vmemmap tail path open-codes only a
> subset.
> 
> Factor the PFN-independent state into memmap_init_page() and use it for
> both regular and shared tail struct pages. Keep section-, PFN- and
> instance-specific initialization in __init_single_page().
> 
> [...]

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


