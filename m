Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84A18606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 15:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oAAqXijU
Received: by kanga.kvack.org (Postfix)
	id AA0406B05BE; Wed, 18 Nov 2026 10:25:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A787B6B05C3; Wed, 18 Nov 2026 10:25:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98E396B05CD; Wed, 18 Nov 2026 10:25:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7410D6B05BE
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:25:58 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0BD8F1C4199
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:25:58 +0000 (UTC)
X-FDA: 85448615196.02.839A262
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2B411180007
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:25:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oAAqXijU;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795015556;
	b=O/cAKlUCPIYF+VE6ql5VHfh/HpllurN9DvBO/+mxYsOqM8rOM8PrYU3Qeu7TOTHTFAQ9Lx
	pvP40fhPNxBJ0BO7Ur6BivrlRSHphSGPJ9MCViOSooCzct6z4lsn78dOiaM1HjrOpKArjy
	6aieL57MOdIgJbbt0C5pSPcfhl4r5Nc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795015556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=viOmGIbmx5OWxYgiQI8AAjcCw6I5GVsUWS896dl4i7E=;
	b=fV53JfQVYK8mNVxp2EIXk9eF/rttkJnkgVrHYRh/WmVlnSv7DTfoH8vH5qE2ndQaWIzTRx
	ZxDzSF4My7XxDAwXPE2/QP0Vpr3yJ4ACAi1i9RNoboEWceB8h3i0eKAgXa+S2B7s+igA3Q
	2dtCM8TbFvsLiGVH6ycLYNA/NSGQwG0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oAAqXijU;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9BD76623F9;
	Wed, 18 Nov 2026 15:25:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B621F000C5;
	Wed, 18 Nov 2026 15:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795015555;
	bh=viOmGIbmx5OWxYgiQI8AAjcCw6I5GVsUWS896dl4i7E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oAAqXijUGF+2PFzvTnj06fvcFXXyypTuKLw0i/g1yVr/eJ7BQi6WUbccC8igKJAeM
	 ITT6SP3I7cKodQ4GcqGJ9ooZ2eKHc6DhTL7en+cAqO9HKaynWMAG4k9dbjrGGTDEEQ
	 X3/GtJlQNVOxz/eyjZaKDKbwFaSPwHoEG4Ahqrgw8BdIbiM9x5hOGizTBrwwhMPtiy
	 ip9XNQ49aNN9T2sspAB2QDAofx0QRXg2VvjZ8p0zmAgJwdxAg7hRPQf0yqknDmpPYn
	 0UsKgNRgrf6iF6KOtzIYikRM+8JBCnkHbsL5424FGpQhQAiRgIne1CTfKh/HfuppYa
	 hsfuGD3pJQxcA==
Message-ID: <ab0c29ff-804f-45e3-b3e2-756a8c81adaa@kernel.org>
Date: Wed, 18 Nov 2026 16:25:40 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/13] mm/migrate_device: allocate THP deferred split
 heads
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Usama Arif <usama.arif@linux.dev>, Kairui Song <kasong@tencent.com>,
 Balbir Singh <balbirs@nvidia.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?=
 <jglisse@redhat.com>, Kiryl Shutsemau <kas@kernel.org>,
 Yu-cheng Yu <yu-cheng.yu@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>,
 Chris Mason <mason@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>,
 Mark Brown <broonie@kernel.org>,
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
 <20261113-mason-migrate-et-al-fixes-v2-4-50a2ed382b61@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-4-50a2ed382b61@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2B411180007
X-Rspam-User:
X-Stat-Signature: i4ixs13s638cbr3an1cjsd8mzxgig6zc
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1795015556-670458
X-HE-Meta: U2FsdGVkX19xtKQxdKjm1XPhQIIXTrK5GbDJVBr0Q8Pyl6xbTygOZv/pR+xvLWZLYcBvzHj5DeOP7h4PF5D6ktRHuiZxSq38PzBGMyxe1vEeGpUKBPi6FdPH0+ORiCqCt8OomuC5F1mKcIt6mupiP/mnQdlj99g0oJYenvgh0rUeAhy4FZZifrFSkLpf742TK3NigvDxumj2zN6b6y6gdteoXKDaU3o+tVQ0AP6I4jiPn4+oTnrDGRzJz55SQqLeK190KwamVOeKQX6aT8fdI2lLDmO+xdRd8G0eZcTkeskTK+2w8RGbOvhtkq6k++YEtCdxu7IuQkGMMDkhYupOaZm7mW5jUJ9sdvLgdbztBTPaato2yAbrUreijXVY1gGWcDzMv1X1SQvOyTAp3sCx5pLqkkZJ/+iesS9oJQNzOf43/eFzmjIWjm8+6S8VTkKOIDZ3gDQ1mZSctZNQCzjWtXwVoJj98AABClgct3xvQhstHjng+VluCP17hjOioSfyDDY8fqmSuOuqDW+gk3nLR37UPhAUDfHmsHDEWqwvyrRfluQ9WfMzxqmB+Zj2jUFq59eW6fvOpw8Wu8oN8Dkk88+K6Tayan7acBiV/Jdi2AQKG+IQFnDfE73E4o869QiQgJ3jE/PJXOj69roF003b2sdM8AYEgIHNtE5jmb+Zo/7mmMlHHcPE//p3MhrM522gjrHg9857j9RWAVLmJ7Fo87ae/rNqhXSCEgDF9twsHGV2rFZBHixzhTeydsAsZaj8O3npN5TxVs/loCo/gRYA479Rr3CmwpYYkgmVxG3aIGirgE65dcOZhkIxPUUQ4zGHAMYih4cWLRWIAx/GdEyO60tZZ+CAQpdiwOVcVZ6w359aWXp0rbaly52HIapohtXYUllP6HEj5g/USiJTWqKDKhoQ73BhDBeUiLob55Nb/M6UaKufKbz98qcpyClF5Km43Bc1Giu+D36j6y0cUqm
 ZVwq+btQ
 owjGs9mx/gt+n2YDNMeFH1ccny38W7QSDsQxUfJdbffuFrf2dIIVZzT6YIKPSBwCB0+Ta3UbshS2XYYcP4ftCWI04wTAbXVdUEuGpeSfNCf/L7dYPQ5ENUl5W1bbs0Pha63mcGyc6OktJxmKl9dUl6+4rV28cce9LG3UAfSDiwqJ0GfFRqnVJicQkZi9Jd8vhIw1eOWFHlzLYJVj8t8Bm1nIQSpmPIJSr8gjS1qz94cZ5uOY27P1EJkEcxSsugZ1v22uZuEwU0KJ23llZBA22nDbTrABrY/iI1Ddt4nrPB2nVi5xThqPVWNi0p5ojU4haeE+FGPJQTxdZTrrtR51oDlrK1q5XB9isY1c6ml0poc3eKzPUeKM/SOOcHxDkxHH+GH1b5Ac7vdmwUBSNDBeNZX6JGowHVcKjmYk/mDkxf4DMTQ1kO8796eJZf8pFAdo1GRgR7OlhM1iUmEMMkri7AefD00x7RKhygWiDSD1jKCSUweX/xlYdiokVO5mh6HyHNCVYj+b8xovoAiRjQ7Bqo0sGrYKsS0QZra+3KM1P7at9dW5br1AzgE3XsaeKnHHRpjPsYdtXFXsUwWAAJ6NPC3PI4Mdt4UvbTgH68BQwBDvbdJDntLi/BMbgViHPC4+bx7CPrw3+KAejH0Kq33valP7j4KuVYGgbyKSqxyCSwoXnNBXUg0AMAzffe7L6jwb7RDe7nPwbxm+4zPXlpDXul64h9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 22:45, Lorenzo Stoakes (ARM) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> A THP that device migration maps into an empty PMD can end up on the wrong
> deferred split list when it is later queued for a deferred split.
> 
> This occurs if the memcg has no heads yet (resulting in a warning if
> CONFIG_DEBUG_VM is set), where deferred_split_folio() will then queue the
> folio on the parent's list.
> 
> Once a later THP fault in the same memcg allocates the heads,
> __folio_unqueue_deferred_split() and the split path resolve folio_memcg()
> to the memcg's own, now existing, list and take its lock.  They then
> list_del_init() a folio that is linked on the parent's list, racing with
> anything holding the parent's lock, and both lists' nr_items counts go
> wrong.
> 
> Resolve the issue by calling folio_memcg_alloc_deferred() after the charge
> in migrate_vma_insert_huge_pmd_page() and falling back like a failed charge
> if that fails, as __do_huge_pmd_anonymous_page() does.
> 
> This was originally discovered by code inspection.
> 
> Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ ljs: tweak commit message, remove unnecessary comment ]
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Acked-by: Balbir Singh <balbirs@nvidia.com>
> Tested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

