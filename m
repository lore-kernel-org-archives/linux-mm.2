Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBEE8D111A8
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 17:00:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 223F96B000A; Thu, 27 Nov 2025 12:00:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FB5A6B0032; Thu, 27 Nov 2025 12:00:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EA816B0062; Thu, 27 Nov 2025 12:00:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F29B96B000A
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 12:00:23 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BBFA7140184
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 17:00:23 +0000 (UTC)
X-FDA: 84157000326.23.F1DA3FB
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1DE7CC000A
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 17:00:20 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ERSHELQl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mQ3Y28wU;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ERSHELQl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mQ3Y28wU;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764262821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c67LjBa5JtjIC6K1nDTL3mxFIcVdzFmTVEnOKZiAqm0=;
	b=jobYNEfzHgeedhsEhZ5m2u1daZG4uh1Vu2NVvobe1A6Y7LNs+HElWiOCwhj5okHtA6EiU0
	4NrQRwvFnnm/LUStSpi0K/Cb2DgWu30NunZVSRxaOZ+5ScZGQXAKyqWwcE8BAT737LAC6D
	Rlak7LUo0Ct73StICC+Wh4mysFo5ZFk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764262821; a=rsa-sha256;
	cv=none;
	b=IGS1ETzFqt7qk27rVkT32P4vUKdRgQM4F8n6O0umMpQANM3nUzZLI7KjcAy6MDhlygqMpq
	Mvb/h3D6Uci+DxzNEVcc+FqU+in5UD9jMu3GjiG1hCOYz5nOilNP0v65u3smXNZrHrt8Dr
	40x+17G7e9/ZgsBdelpB0kzo87+nmHQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ERSHELQl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mQ3Y28wU;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ERSHELQl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mQ3Y28wU;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 059C15BCC1;
	Thu, 27 Nov 2025 17:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764262819; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=c67LjBa5JtjIC6K1nDTL3mxFIcVdzFmTVEnOKZiAqm0=;
	b=ERSHELQlwm+nOrI/ThkX2ZfyikTLfFaEdEBlYZL621PydLzMEqLue3TNr21gxrJa9xFsuT
	vzvjbbUfU5FiOyhTT19/BR48mkipPX+vKodF9hyy/tMS0ujzic2icA1Mm0q12YMZM+0D92
	ttl1KAljZYswsKkIiBKic2Nq98Qg38A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764262819;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=c67LjBa5JtjIC6K1nDTL3mxFIcVdzFmTVEnOKZiAqm0=;
	b=mQ3Y28wUbEcgjAao8nV4G4bYlJDbYfrr5KCqwBi0QG2NpYPSoc9TbbJW/FzojbY4sE81RN
	AwnCSb9k9hWR7UCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764262819; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=c67LjBa5JtjIC6K1nDTL3mxFIcVdzFmTVEnOKZiAqm0=;
	b=ERSHELQlwm+nOrI/ThkX2ZfyikTLfFaEdEBlYZL621PydLzMEqLue3TNr21gxrJa9xFsuT
	vzvjbbUfU5FiOyhTT19/BR48mkipPX+vKodF9hyy/tMS0ujzic2icA1Mm0q12YMZM+0D92
	ttl1KAljZYswsKkIiBKic2Nq98Qg38A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764262819;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=c67LjBa5JtjIC6K1nDTL3mxFIcVdzFmTVEnOKZiAqm0=;
	b=mQ3Y28wUbEcgjAao8nV4G4bYlJDbYfrr5KCqwBi0QG2NpYPSoc9TbbJW/FzojbY4sE81RN
	AwnCSb9k9hWR7UCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 82D643EA63;
	Thu, 27 Nov 2025 17:00:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ujPmHqKDKGm3IQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 27 Nov 2025 17:00:18 +0000
Message-ID: <67da7b44-6975-44c2-b37d-9fadf7dceff8@suse.cz>
Date: Thu, 27 Nov 2025 18:00:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/16] mm: introduce pmd_is_huge() and use where
 appropriate
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
 SeongJae Park <sj@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Jann Horn <jannh@google.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Pedro Falcato <pfalcato@suse.de>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry.yoo@oracle.com>, Hugh Dickins <hughd@google.com>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-arch@vger.kernel.org, damon@lists.linux.dev
References: <cover.1762812360.git.lorenzo.stoakes@oracle.com>
 <00f79db3b15293cac8f7040a48d69c52d00117e4.1762812360.git.lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <00f79db3b15293cac8f7040a48d69c52d00117e4.1762812360.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 1DE7CC000A
X-Stat-Signature: egg968zawgaxunkf6d45eysqsqbsq477
X-HE-Tag: 1764262820-640937
X-HE-Meta: U2FsdGVkX19/kEHkkgzjQk+iqkJ+iP8ccIQwj5pPM3mSsZSN1G/7k2KQENOlOsN2i43sN/ev52WSjNAl79N1Z8nslxeZCQoaDKRlU0K9YniTZ9KhbBYcQc3/ny4qWNf/x8zoJofnQ3kkdpj1eY6JFnriSoPKcBVZdG7+4tULZtCSQMVeb6Ev57PuY/8kfJLz8fY4KC9boLFBYGJSallnS2/RJ6YNT1n7QdjAmIwE/glJqGU+YZjr8pWlDdMAWN5RqOQkmAOD8Iz5URDY7f7Euc8RkbP7v7SomSgO2i/9B7TkJp5JcdkM35RCCN9+G6cyxmy2T6hSTHfmkhpIWbrafJ62TO/jrUhHbA4mkinuHeMgnQKjtXbcfjaaI9AQRZtl7QXs0NLRyI0N95O0IDDTPWBRGbwiru7O/DnOrN8rhaEeq3741fESlv0dFZj2KaGj058vyliUIMnEVgWc+ep0FoEVf+KcuWS+O8ODL8XI/B+IGbCRfd56Vu3O4LP/lBPjDWVzfKB0yetlBlH95il9dVAsWKlQwGom8hNiHaxXzsiqATR98YefgumzVtLjwBO0sv0AeQ2uCExT85JcwdUctDGrPl6712xZJE4P8vigJ3np/N5nc/g1kjBB8q9o+pFoWPrfTOFTYjTEbqQBSRItx/VWueE3d3BKV5oLF5gmDxGOg09xLv3tOPjIa/F3TK/azFUo/NR/kU1umMovY11q2hB5mxbrTbjNW8xuP0Ly2JcYE+nQfTUHSqMNrQffg7V1f92CIOQ16oC/17VtWdxX/yeDIu3pTbqNoeRY0lcuUdBl7gM0xi5lf7s1E27VUyMi2fJeFg0qMaqXbHmjB/MaTDMz/KfBEqa2zekfG5uv6w9cNXBE4PyTYjEyz3AYpN5oDYQDpnnF34xRQV/uJ8WPf13GXRvmAjnvPXInWmyUV9zSAanlCcdl0hU7TJFhnJtNzW5yXvDQkPZBRivYN/S
 Cqe6593x
 3IpyPu5B/Ij6dGK6ExnAIySrmgHwhg2yeEuTF7c67Zpvtl3FbpZD6QTM2eXXoh61bni7Ip4jlJB3ySeUYwFgDtWXNlvH5UOn1r4tRSg2RD+44sl5cRTz/q7xvoVIrOba2hijbD02KgReoenv57ot6EZQ/8RXQtyXosHnk7DmML6jUbnZscrBcOrlsI9QC7hYaFI3dagy8fNDw1/tYMOPgK0F0xATm6c3+F+tCN8LO6s0w7oeODAdoeJ1Kn3I+lSQkA5ESe8o+TxlDpjhwNex//eweh9lTJuZjrEuMlYX89W1k/vptHRTEYlOlElLm6e/MSmyjmHE/MXAAIZDfSGvzoL4MQzF41Lf5UE5sFEdxlz3MTGddVVSaDDhZ000YkeKw53gvAlbiVXpDp/GDPoFyheuYvTVspkCs6P0mZRbpJ/j3TRo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/10/25 23:21, Lorenzo Stoakes wrote:
> The leaf entry PMD case is confusing as only migration entries and
> device private entries are valid at PMD level, not true swap entries.
> 
> We repeatedly perform checks of the form is_swap_pmd() || pmd_trans_huge()
> which is itself confusing - it implies that leaf entries at PMD level exist
> and are different from huge entries.
> 
> Address this confusion by introduced pmd_is_huge() which checks for either
> case. Sadly due to header dependency issues (huge_mm.h is included very
> early on in headers and cannot really rely on much else) we cannot use
> pmd_is_valid_softleaf() here.
> 
> However since these are the only valid, handled cases the function is still
> achieving what it intends to do.
> 
> We then replace all instances of is_swap_pmd() || pmd_trans_huge() with
> pmd_is_huge() invocations and adjust logic accordingly to accommodate
> this.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>


