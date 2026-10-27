Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67D54606B5CD
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 20:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mc83FUFA
Received: by kanga.kvack.org (Postfix)
	id 5B2A36B08D4; Tue, 27 Oct 2026 16:25:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 563166B08D5; Tue, 27 Oct 2026 16:25:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4529C6B08D6; Tue, 27 Oct 2026 16:25:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 226456B08D4
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:25:29 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A102F1A0AB6
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:25:28 +0000 (UTC)
X-FDA: 85369536336.14.C19AB86
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id E5330180005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:25:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mc83FUFA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793132727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FHMTsBnJMpXJNOaP415fipWiMQQwfvRW5x3lZ/lRcHU=;
	b=HzWu1hHqatK2fj1BliwagYXTO1K2nOZeppv11bElMOnzl44Ba/mdfailbK7GNFQJDjZ5sb
	WWcvl7FA9BCG3NWfdSiAAjjBwqYoV7JocWkgxdJ5AJb7jAjfuKnYm2F1BMnLSdz9cUwc03
	72CLZiynqcu+PIXyKrO6QPb6t81pNJU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mc83FUFA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793132727;
	b=X6rXMEt8A8VeO1OiCBHuj/5ydaPxTTdgXGOJV/XCmD2R1EsNVhe84j2L3+509cTzQRz4PF
	RrpDa4AtU6RYioBeVmnB8g5dsYI7YAMlI1RRVeRE3VNapkFC0P+KUGl5cBCxdkg1x8uyEx
	82+jHRSbfoUUtfjuDjjA4yJOOraziTU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2DDF043370;
	Tue, 27 Oct 2026 20:25:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758541F01340;
	Tue, 27 Oct 2026 20:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793132726;
	bh=FHMTsBnJMpXJNOaP415fipWiMQQwfvRW5x3lZ/lRcHU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Mc83FUFATMQPouVzjUJeRj3mhiIcUvrA+Erhg5Hh0lTW3qwPysmiXYCN/sY2USdpd
	 VQEeiyXwH3fAYJ+vI5Uk4lbY0OCURgOg/lZzGCGvnESQZo62rEREpGK+Ywua1pC7/p
	 qLtQrl57LVvD3FOguw5Ccq1ddGp/nxRV2WelM6luaRwZ2gItpGPc55R3kKd/uEtYE3
	 F962dZ5NVZdLD83zdZJ57akrnRFkaxt1wSO3UiU8UVhqMNQKVzwdHfbh6D07tWcFW0
	 uvnXMmSet+gq+ZP42latzKtvPeBblPMlc6bL70NhuTjijHHpcfEiVBaUcHP26dtgTY
	 lDs1oWuY01RLQ==
Date: Tue, 27 Oct 2026 20:25:24 +0000
From: Harry Yoo <harry@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Hugh Dickins <hughd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
	Rik van Riel <riel@surriel.com>, Alistair Popple <apopple@nvidia.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
	Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
	Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, stable@vger.kernel.org, 
	Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 09/46] mm/rmap: handle device-exclusive entries in
 folio_referenced_one()
Message-ID: <auEHPgT8JdqT222B@thinkstation>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-9-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-9-6f74bec9a5bb@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E5330180005
X-Stat-Signature: t16ikof6khrg88mz4yqs4n3a9qke48s4
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793132726-445078
X-HE-Meta: U2FsdGVkX19HSehEZDi86+MFP4+U41byAcRFUsuS5D7cJq9QacAJSkIIqLlEuO0un1QiKipzg0xDKMKVEap6+8trE1oGd0hWoif/AsgviG4fvMYe4vbFcJLTaojHeJ/BIydjJopthOzxgvgpft1K9N0v3rKL5GCHZ1bqdu9D/1tgoGjjvp0f+XJswAbDp/cl9tHBGh+/KdweZueDzwyMh1IV4ngCkwE6pC89NiNkqT7VTbbChy6qGPTHk2nSaJgBn+SihDZ3sdQIWkj4qwcZRhSvjWJHYcxhNyyJutcRf14+i31i5lfyR92YgUxRuJg+CimTUmpz3fsmk1sPfKgULeUCA/2rnc3LrJxYKxLVlOfxcdyTB1UqSFVj8IzsqENRtKOCYSUSOx5grf8Hf6Q4zFORDpOxpOzTw6dnbQeDmKaElCF4HROj5dzZmcyrPneXHPGrNvjfQ3yymdLRP4B6eyX4L8OGZgxD6ahOtn5o5CTb9sn9ThGydAHuRBzhSX65dEM0pi3HO8bZb531w03L3I1asRHA5vc6Q93NnBxNhDyx1PVf91y+9PsXX+IBAKd/cyks+TGJwDaXUm3fB7XlqPSHgpV6sRqO66d6+V2jOSH2DW+NbknQh/c7FIgDK911hkSuAWWXjYpWptdyLt/cIDiYgFi7hSuyyrTw0yY4HS7cUlwQoCVxlmHyHMLEHHKaFcSLPIluxKF8abavTV2xVs+3yHEqB8atTVPrh1kiGHsKJI7F36cIGsQagamsgK0qPBd+ZNxmwbnvedFagNYechbu9RzPhoFtDQ6qr6rvlvfSW19y6SzBLM35GjgRGqtkbF36NG7lWtghsuyxQf/Do3h8sDhOeaBUWNMbW3ZGKrZeiKVn67enbGn8oqY2rhP9QOK8EIlc8PfJHlI0xrClk7X7ZYSKlHBdGwrdzZVERUIaEv7zKEtF/kk3UDbvFGo+5eVpqfaBUpbgqc47ai6
 hpkFhxq7
 15fA35Ew2XpW/TRyPnWbQXvbkJDu9SG43B63TFdCvLmDNI4a5hcOda7ykFVFF+0OHHKT+oL+klq4eE74F52vQTzhltHia5DoiL5gP6MayCk+242zri3yqZeD49d72CKe46drsr+xtjdoNP0En5OIE5NxGK1aJn06CQMXD0borDDa3nhaB4e5a1gjBLzMaO+3fRir1NhFknlIgITk9sSuavyHTg1ptFu1TFxQGulNAutSe9zaR4Y4ySVJ/9G9rIqyZetkAmDPbpVgG7jwbQtmoMy99ECArn/jC1/IsxfXv2hDa+8Pv2l1/+5jIfUyUeiL5tLCopgcdAhaPnMpT/mqN5nFcxtkdEM/rT8Vft55CDiB1nWmatomglvp9xhd41GQTJCDVebG2UM287/4wIKXA9mCk3Lc9axH8SqyrIHQAJKNQOIwg3T0U/cVVii2exCH6zh2AYFk7chrilzk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:17:29AM +0100, David Hildenbrand (Arm) wrote:
> page_vma_mapped_walk() can return non-present device-exclusive entries,
> but folio_referenced_one() passes them to PTE young-bit accessors that
> require present PTEs.
> 
> We must neither call clear_flush_young_ptes_notify() nor
> folio_pte_batch() with non-present entries. For example, clearing the
> young bit on non-present PTEs can corrupt the entry: on arm64
> PTE_AF overlaps the swap type, so clearing it turns a device-exclusive
> entry into an ordinary swap entry.
> 
> folio_pte_batch() will VM_WARN_ON_FOLIO.
> 
> Apply the same approach as the previous fixes to e.g., damon_ptep_mkold():
> treat these entries as old from the CPU's perspective and obtain their
> young state through the MMU notifier.
> 
> Skip PTE batching and MGLRU look-around for non-present entries, and
> don't modify non-present PTEs.
> 
> Fixes: b756a3b5e7ea ("mm: device exclusive memory access")
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Cc: stable@vger.kernel.org
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

