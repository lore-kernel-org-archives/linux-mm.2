Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F71F60A261B
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 08:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=iEbujbYC
Received: by kanga.kvack.org (Postfix)
	id BDF316B00EF; Thu, 29 Oct 2026 04:02:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBD9D6B05B1; Thu, 29 Oct 2026 04:02:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A36D16B05B2; Thu, 29 Oct 2026 04:02:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 392456B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 04:02:51 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CE8A41A0339
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 08:02:50 +0000 (UTC)
X-FDA: 85374922500.22.AF5DFD3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id BF565C0003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 08:02:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iEbujbYC;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793260969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k8apCcAMk8pZRsZxsH16Lc+5TIn4jIu/b15pYO6Z0Bs=;
	b=V/fhVrdQf/BXhfUxloEx7sY1+IFeWU+VQjGmahIK8KK/CNtblHPDU6RQUwq8XI4kCy91gf
	CJWeUub+V6IcbAPFJt9oPyfzE8Ir+sUOv7x38QdMf2oFb1Dsx80zdQix0hgZ4BguTPbxNc
	yibn+3fvpUd4Yv1BYzgwVZiRitC8Sew=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793260969;
	b=ytYhQr1IzMsx+pW7Gtuf8MBf0S1ArZibnyvXePo6zo741Ta+Z7BIUJ8q7UWotxwuyf0OmD
	/YNol/jwfG96mtqq8myyaPMqPL/J8lMCaKtMmtwrRtuHuxvtA+pf9lgbMyKNCRi+rVvm8w
	TcLrdCYjgXqeQqmM7L+x0jIthhMEMAA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iEbujbYC;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 30B8A1682;
	Thu, 29 Oct 2026 01:02:44 -0700 (PDT)
Received: from [10.163.164.4] (unknown [10.163.164.4])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 385A33F7B4;
	Thu, 29 Oct 2026 01:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793260967; bh=ef9Fg1J+efa9K0lYaHXATY0/T5dH7yrFdYQc0z2MAV0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iEbujbYCswZ8RFK2+bOqH9GrXNfdspdEyeLWvgWq16i/7q0yxHJyjSKh5wRDFg8sA
	 90j56I5hjCTLgfRploz8x7UQzuMKPs6udMHmkEokQ81ilxBQr2532zpMPLliV7ataQ
	 ekLC1vjHF7zTz0euRAfdkqhMPZF/1uaGmanjmQX8=
Message-ID: <720a50ae-5828-450f-a7ee-a7107b884225@arm.com>
Date: Thu, 29 Oct 2026 13:32:23 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 29/46] mm/mremap: use pudp_huge_get_and_clear() when
 moving huge PUDs
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>,
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, stable@vger.kernel.org
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-29-6f74bec9a5bb@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261027-fixes_core-v1-29-6f74bec9a5bb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BF565C0003
X-Stat-Signature: 1j8cutdqwgyupjys681dsr95zz3gtt4p
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793260968-977050
X-HE-Meta: U2FsdGVkX191x6nQ1MGXEfuo+/gW4YQArC6L43tJ+wSrMwouqluLid4IJ45dlE3XMuaOU9Dt5pxxCIOnmbWOKyEp+U+HF7F3DkgEjE929PDuFU6XMmbN8wEPGAy2pyzHxwo0pJgCtxijdYGS4bH/KCLK/BcmsANmzAFkQlzVw9NqLxT2tKRGe2X6FGQgEREU0s9KJpKZNKMxZQdUZ3sXo7e02Ui7emOJQkv2Zwdd/mT/pt8XR5V9d5vucbK0mI84zMayb0A3rsF3afIHxlGPsf3ClwpIJYga+f2TgrelBlbd3YeUGGbTb6FxsCs0KGRi4sCqRK3Ly8vauN3dVbAyVSvuYgC81Wq1+r0jeKcg7hga6uWsxwGWUxUd6KcLYAgcOBGGOEI6BhSaxBYNzZUqvMeZpqnHrA00YdYiQpIdOAKQnWmJeLMOjH9fAUvZxG9gsZ52cJZXYNZHxn34QbyeGltwAchvez7z/4oP+dzRbigwoZM2QJVtZt+X+fgBfnRkMrD2FzC9W8ZstizGYTfrxr/vtp8ZUvUZ94rpn8iCUy8EpFFm4wJABhDVrkLJLhfLJLBRHXenpZFjYbgy4ddcLr101jxLNGkCbcIqeVtS4CF1+G2ieic/Swzpnleji1ORutGoKu4isfaab+UV78YEKAF3DTDh/Xmrkk6K5BW3urNk0lmm6zjighuzkH/2Cvr1daBo4zB8an/xhAz3XDGWg5kDxtMwSNK+nkrPvsTQhQbvHUhRTrL4gp6XDd9CKhvNixavVE6O3j/3Oerx0bXhZ2rvPk64nowL4uj9M7WoWP28k+UFDLw84rta1B+hxjfppaWarv+iXRJArc9TAUzIyyH9GT2+7XPFLys+mUHj6vcPu7+m+j437RZj5pW7Cp3/dIJmezbnRiLXr8/QowIJ369UhGJM4WjrR8NG+cQwUQ6OacMGYwuU1I65s97W+TUjCO1hCPBKN7Tv+SKxQ8e
 GhMlGLsj
 tN2ftLWwMAyQthIGWl9BlivPd0JfDr361w8SMt2wIJh0jYHe57ltRnMjFzf+6SiZfgmN4mfzOOEiT7qdgzEKimKVUrU/E3xnWniGqcUHEg9OQ4przMzAvouFQdi/s7MYcdri+R3E6AxSePY3/pyeU+nuQKo/s1yNSIEAL8d5YxOxpv3OLGRJOhMm2aWE4i5tTKu1NVoVXXgRQ6uDmNwr34mLEGg2enDIrh9jpw7K/TLkxRLI8+/cXDP7KCt05rFJ90B+S4TeQ635Hp065uamAoD3THviG53ZTJRPp0b1J/48rRX5+UFYfZuCUwCYgleAJfX59IN4rgXEHek57w831COwLPUcL7/FQweqUcU7h0Qq7nBq501J0mbUZGedttPLItB3FJpK+1eGAhPmyzhAPMlM6gs0cQxnk9Vuctcf69Q+gqqQsiK9HzKTK8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 27/10/26 4:47 am, David Hildenbrand (Arm) wrote:
> move_huge_pud() reads the old PUD and clears it in separate operations.
> Hardware accessed or dirty updates between those operations can be lost
> when the saved entry is installed at the new address.
> 
> The raw pud_clear() also bypasses page_table_check_pud_clear(), while
> set_pud_at() accounts for the destination mapping. This leaves the
> checker counts unbalanced for mappings tracked by page table checking.
> 
> To fix it, simply use pudp_huge_get_and_clear().
> 
> Fixes: 7d846db7d0e2 ("mm/mremap: convert huge PUD move to separate helper")
> Cc: stable@vger.kernel.org
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>


>  mm/mremap.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/mremap.c b/mm/mremap.c
> index 0d06d7f37f19a..16e736c72d9cb 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -509,8 +509,7 @@ static bool move_huge_pud(struct pagetable_move_control *pmc,
>  		spin_lock_nested(new_ptl, SINGLE_DEPTH_NESTING);
>  
>  	/* Clear the pud */
> -	pud = *old_pud;
> -	pud_clear(old_pud);
> +	pud = pudp_huge_get_and_clear(mm, pmc->old_addr, old_pud);
>  
>  	VM_BUG_ON(!pud_none(*new_pud));
>  
> 


