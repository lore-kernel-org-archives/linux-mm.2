Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB7D8109C02F
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:52:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14FEE6B0092; Wed, 25 Mar 2026 10:52:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1278B6B0093; Wed, 25 Mar 2026 10:52:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03D9F6B0095; Wed, 25 Mar 2026 10:52:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E89EC6B0092
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:52:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 98583BB8AA
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:52:52 +0000 (UTC)
X-FDA: 84584877384.01.884C798
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id 67C2680012
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:52:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=e5mYx3c0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=USEIf2+W;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=e5mYx3c0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=USEIf2+W;
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774450370; a=rsa-sha256;
	cv=none;
	b=oP4xnmz1aEs4HgA1FHVxEo06BETJq0AgaprwQPVGU6THarOLzLEtPsfEkNLMTu4kS1K/Sd
	8AWwxZsfR2xXzZoluXHnxGJFlvtuxI8TdgVL6jisFLMw1DfqevMvI77i06dvqG7kkUV7lE
	JzgeaH/NCuM9JlpBoLkLjFz/NxjC3hM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774450370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O4SULWt0KCdL7QOnodPGLpDDDaEYVeMtxr9H10Fko0g=;
	b=5AiSAfzZ3DAGIBbM7CkvjQFD8OmwZTUgbvn7a0bDcwRX2lcq/w5NTk+1F/brvU8t6Edbig
	4OzxYll7aRSCAVWFn8DIggywaLENAKCcBoNJkuVD1jz5zxzV8EXvq7kLR/GcbEW9QjpoVO
	MgwWkvQ2XDbJnMNJj/Oj9KbelS0rkIo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=e5mYx3c0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=USEIf2+W;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=e5mYx3c0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=USEIf2+W;
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 026255BCE7;
	Wed, 25 Mar 2026 14:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774450369; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O4SULWt0KCdL7QOnodPGLpDDDaEYVeMtxr9H10Fko0g=;
	b=e5mYx3c0CsDNuAC0rVZs98Ba0qaer4VtARkMyazV2coOQ4FycPa7yB0lA6rCKOoKwyLW2X
	IU4bBftpxLpt7dd85qs80s2VCpUQnozngJxKWoSOO1ImpAV0Z+Jvl2SPtbIAA8hCUTfwPN
	vnxQYMCqh4XzRhe+49RCSAE6NWwBZqQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774450369;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O4SULWt0KCdL7QOnodPGLpDDDaEYVeMtxr9H10Fko0g=;
	b=USEIf2+WokW7JCKUojIiYBamgaikqLlbPQT0gYowWNaJlfvD7zobS5NNose+MdXtBotSEL
	LqypVTABHSzAQhCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774450369; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O4SULWt0KCdL7QOnodPGLpDDDaEYVeMtxr9H10Fko0g=;
	b=e5mYx3c0CsDNuAC0rVZs98Ba0qaer4VtARkMyazV2coOQ4FycPa7yB0lA6rCKOoKwyLW2X
	IU4bBftpxLpt7dd85qs80s2VCpUQnozngJxKWoSOO1ImpAV0Z+Jvl2SPtbIAA8hCUTfwPN
	vnxQYMCqh4XzRhe+49RCSAE6NWwBZqQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774450369;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O4SULWt0KCdL7QOnodPGLpDDDaEYVeMtxr9H10Fko0g=;
	b=USEIf2+WokW7JCKUojIiYBamgaikqLlbPQT0gYowWNaJlfvD7zobS5NNose+MdXtBotSEL
	LqypVTABHSzAQhCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3AC6044460;
	Wed, 25 Mar 2026 14:52:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VwP/Cr72w2nrYAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 25 Mar 2026 14:52:46 +0000
Date: Wed, 25 Mar 2026 14:52:44 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
	Chunhai Guo <guochunhai@vivo.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Tony Luck <tony.luck@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>, 
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-mm@kvack.org, ntfs3@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/6] mm: add vma_desc_test_all() and use it
Message-ID: <gj5z2ayiyb5nxgpwr3mdbaxgohei5g2asrweib2xul6hs2cppn@fcu5z3yj7yil>
References: <cover.1772704455.git.ljs@kernel.org>
 <568c8f8d6a84ff64014f997517cba7a629f7eed6.1772704455.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <568c8f8d6a84ff64014f997517cba7a629f7eed6.1772704455.git.ljs@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 67C2680012
X-Stat-Signature: cfgp337tczzucyfuzy3mrm3n9wkzq4za
X-HE-Tag: 1774450370-258630
X-HE-Meta: U2FsdGVkX18+OBhmih+K2ne6cq7JkMlA5mrPTegTUhKfaLQOxj3Zywq73ADXyKHR7aK7Vo4SN95rVCKCW7lbFvkOk4/6ORqhfGd1WQ3Sp/Hhoweg8O5GmznM2O+7FPqi9+V6CdTG4z6dfSDHDT9/2xKbUbTSSabbBwBDhg4ebgnCZGdOsPkpuSW2ZJqRDTqZUq052whnDYOwJEd8ADnjB3GBHYUyX9pG0iSy2p6XF8/vUmiQUetP5hFTLlHgP2c5bvQKI+JetSu3WqNg9RJsJVFSLOBcaGGh31XOJkqv2i7LclM0aVCarA4HVGCFnkx6SGW1Q/ZfVX/i4se+GiDvRtshAgMVKkGohKiuXarMvmZsu99fY2N9+PMN8qo+rHvmKFMJuRQoMkrBAmL0erQxjwy8YKYywLS+NXIhxyv490jUJ5R1erQ7l4C5ayaNbryIX14f8O+kZM6yphyLFXFZEtyx1Zr43sZgAAQuKmDzBESCNV2mwnfvB9C0+DZsW3ECtH57p/FuLfTDjDFBBR0iAs6AJhIg86P/gopt6FFpDCdx5o1PiR3zJMgyxgh+yMj4JbqEaVNOhoK/OfxFmOF/Pm+HM5Q1oRALGepWQnHFEIn3nSw8DMh+IjUtvKO7UMRP+cA5ywjbbrZYhZ9/2Lov5mlyi88Er7ZhCguu3LkTZ5XcEeRhr7GOJJJcfmSNe7MHr3Xhgh+M8bGGlc2bo2QOdiVWxwtlkARKbCcK1L22owhg/vW1g1pvfmfeh5agdPmtB3cshEx2d4md1nQlU2DMuWNeWxJfhL6QGZrPAo58h+jdc1MXP7fIyhCXaT6hKGtyKmtVwCIXPfEuzBEnmiNovoVITbaVBiV7ukjZXokIlUCko2jYAJljCphbEswL3EcWvRougW/8ftUzU4W+adhlrQaEHHvTmhDOlN8e6GTZxJ4psmgbgrhft5KqUWPgCS578dTsRORJySmEw5ntn2u
 MCF6ssxm
 0IIdIw39o8I4R/zhDD4QrK4y6HbsTztrQQN28++p+Cl/2F/iK2C1HQ21IueuNAkbsDlPlKNEvD/RDRocirVp82FBH5Rh8UhTwzSxqonj51rQSAXGUK5w5lxEMO894TlTvAxYqZQIWKT5zoL3wNfVAj7SbviOx9kMTfxeRqg7LLqOyrdcvd9XlYnt1MqXFLaDRCS/21X4ok1qiZbfFhADusQ8HpxG5a6f2CrP5oZ6nFL+sxGrYi0JGhaE86tFgoySxAwi89d+iMFJkEqdtYZqUNds4ZMqCx3jpESEca10qeOC66Y6RAnS96OBWz7bI1/j6h9sCyl853S6A1GnnrEMx/Lv6vt3QTa1gvrbnmNyRQShnVB8iTrt6tHxY1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 10:50:15AM +0000, Lorenzo Stoakes (Oracle) wrote:
> erofs and zonefs are using vma_desc_test_any() twice to check whether all
> of VMA_SHARED_BIT and VMA_MAYWRITE_BIT are set, this is silly, so add
> vma_desc_test_all() to test all flags and update erofs and zonefs to use
> it.
> 
> While we're here, update the helper function comments to be more
> consistent.
> 
> Also add the same to the VMA test headers.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

