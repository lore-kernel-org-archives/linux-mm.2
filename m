Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BED7A606A323
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 10:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oqpZFEQM
Received: by kanga.kvack.org (Postfix)
	id D2C806B05B9; Tue, 17 Nov 2026 05:11:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D043D6B05BF; Tue, 17 Nov 2026 05:11:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C41506B05C8; Tue, 17 Nov 2026 05:11:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A4A496B05B9
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:11:56 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 30FC7140369
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:11:56 +0000 (UTC)
X-FDA: 85444195032.21.493CF5E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id A029820004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:11:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oqpZFEQM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794910314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v0S4+MTT91ej2d/hxyY2qFRb1L9CnA6yF9yap31hKRE=;
	b=AoX2TEv3ve9ZfbL3EJVRHitAmvslt5hW5Wn9qZrNP59NYmFI+luK+hWBR3srSuI9hOG/Gr
	ji/AWG9mNs9zHZN/xEL3i8hEfAwSFHDOxWMdMjgRfnBNgnti6VlQ778pNe0U8+4aSuV/Eb
	fTm5mi72nL25mT7zWhHHNPGqh7LfhnI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oqpZFEQM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794910314;
	b=yCqO/Q+I9aBGOEVhmwykjalb5velrroXNfge4xNdYpKaaqWzFmX2jJ8TLydb9n3D7L+zMc
	JYEF0e2VHp0iKDBgKKU4lKV1Yrb7bNXCDMjknigtm24nYvOhxg2pmc1msGvyZnrFFZrv/u
	Jl0ali4elY7U/zsDjoHj5LBlCEEBkT4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C47661CCC;
	Tue, 17 Nov 2026 10:11:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A40901F000C4;
	Tue, 17 Nov 2026 10:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794910313;
	bh=v0S4+MTT91ej2d/hxyY2qFRb1L9CnA6yF9yap31hKRE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oqpZFEQM5ofSomkWqaxe0Onzz2y6PfdlUH3yQC7GBHXqpVKtb9MLH6jsD1/a9RvO0
	 Z++PWCG78r4lnETrSBGIuV/y1YgLKspMUzRzYYKa3eNg16VIoVJRnsQ6uGbpVdKLbi
	 PtBk7VeOn9LIaBlrbAqq0WbA7XITMkxVVroFXySEQGlh4KXcuyYr7DxqCgI7UkdOyT
	 wFw9fre03/o524fdNQF+0+EuQlP/GrIapST9Qy1uDleBme0qh1y8Ne5pYyotgc72D9
	 ANwgSmw7Q/llv0KBqRvyHZNyRznurk4/ibfnUVb9xtrhyPTLloc9RzulT/Hu4CwJE2
	 w58zgocjhEZVQ==
Date: Tue, 17 Nov 2026 11:11:41 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mel Gorman <mgorman@suse.de>, Andy Whitcroft <apw@canonical.com>,
	Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>,
	Rik van Riel <riel@surriel.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Dave Airlie <airlied@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, Peter Xu <peterx@redhat.com>,
	Breno Leitao <leitao@debian.org>, Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Gerd Hoffmann <kraxel@redhat.com>, linux-doc@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-s390@vger.kernel.org,
	stable@kernel.org
Subject: Re: [PATCH v2 02/15] mm/hugetlb: compare against persistent count
 when freeing lowmem folios
Message-ID: <avwoXd4_gYi-qw1L@localhost.localdomain>
References: <20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org>
 <20261116-fixes_hugetlb-v2-2-4dd9e94ea9ac@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116-fixes_hugetlb-v2-2-4dd9e94ea9ac@kernel.org>
X-Stat-Signature: 19w3skm88fbzytmy8i9xe16pth6yq6mh
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A029820004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794910314-875261
X-HE-Meta: U2FsdGVkX1/+Vai94e7Px91ATQJz3gGSq3xW5/moWxj6t2sqjMfOSDyPeEhScXLiWiqfm8pFSSUIvRRwnF1ftUlwxAny3/zPuOsSEml00SV0ZT3QqnJ7otl/M9lk+rUofsyK18FVNIA+b0IQ4ZMntVnQfB7mmQlKXM9MEB9y2TYbau4KVhTo8PRUNbMvNMp4WR+kKYnp4KFxjqR+hh2F7xZs1e0mLMW+YCJS9Tvn5chUfcTnMYKtFQlDEG0j50HioWvdIcKD29SmE6ZbYuujIATjO9r3k8c75BzzyO18LH/m7ybhwUqJt46d7JeMs8zRIFc4auYXl0u9ts61tMsZk20DMqBPAJDSsMKoBLso4S+YWccFLQJmNqoII0LKRI4B+ol6SIf9LMZELYEApo2JHwUdfvST1NJY7fUrwSB4Vi1mNDXynPVOyDR4/J7MR3SEM5fkNia0MeLEcS9X96K+Y6q7A1Cw+WdYf5DmQf18QUca1iDhYs3U2ltF9T9Zba8EoQRD5/TFOU100YQnsoDjz/Z/Dt87YVDYlAOjcLoRlmIygSDpQ9rYolx5jjcuzhKKzyIKEEnXZ4jx/WWiqIPp6NDYAGWwTg6dQQ5fA7os+x0IT45eKimWpcLzyVQpAY7hzarRZc0iqC2EM0t3fzV4iXjxqsgDoQwB8+aDLgLf3UQ1OWo9DRV3TPMfEmjzf0yiBJNQKiaaQjyEGKcny3CiF3gkdnRqgeWMFhZd354qiDc8JYnTaEfA3Io+/PT3vBBT9KlG/Dn6leKyL+FJVaAcbbltxcWVGiIir4FYl9aOj/ofZiLd2z4vIDI6pRYTrGXyfjM+Q1mNqo6cfRleHjLpdG+MfUyNrRCXjXxaSVT/5yFhtgKXpLopE62o8wd6NpH8kAgyV3teXJJ+ZgpNSLAqW7yE8egCD0AKn3oy5yci+3a0ygYVwDa3EJpBz2xZGqEYf2k+z+Tw+DHmO8nc5rj
 hMp4mh1D
 emsx5tF6Xm23c7ivWbH7EU9qqd+15voBSMrlr1GEwb/KJkvO05K2UibztBoTe6Kdf2jVkCBea5Px3o+2lKc0TlMqA/y+u6ii7AFHanMv9y29GQ4I2l3T4awp3KUee8pvjt+Vy3KC30zgf/1soD1oAXKzqRK01Xhev5oKb3IVPdnkaswaVZkLvWULMxPX4gpkUiSZp9ZbMudScZkye9Unk3oCy/KIqSHUv+93Ve0JOp1jAXZyRO4Nxf+WDkib/GcnGpadeImRKjE20PukNZFb/sPGZCgXLLmEOa86wNustbj5AmiO+BHZBTwhsvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 07:29:23PM +0100, David Hildenbrand (Arm) wrote:
> try_to_free_low() gets a target number of persistent folios, but
> compares it with "nr_huge_pages", which includes surplus folios. As a
> result, it can free lowmem folios below that target.
> 
> For example, with two persistent folios and one surplus folio, a target
> of two can still end up freeing one persistent folio.
> 
> Compare against persistent_huge_pages() instead. Convert the macro to a
> helper function and place it before try_to_free_low().
> 
> Fixes: 7893d1d505d5 ("hugetlb: Try to grow hugetlb pool for MAP_PRIVATE mappings")
> Cc: stable@kernel.org
> Acked-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

