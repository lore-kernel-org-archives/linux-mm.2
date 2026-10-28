Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D89D7606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 16:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PGETvgim
Received: by kanga.kvack.org (Postfix)
	id 0131E6B05BA; Wed, 28 Oct 2026 12:55:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F296B6B05BB; Wed, 28 Oct 2026 12:55:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E189A6B05BC; Wed, 28 Oct 2026 12:55:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD7EA6B05BA
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:55:20 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 45A8116016F
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:55:20 +0000 (UTC)
X-FDA: 85372635600.28.2306D31
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4F09218000B
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:55:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PGETvgim;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793206518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z0ZhwvuKB4zpYCGY+1GjLRRMsHPTa5Lvp91s/JwcgmI=;
	b=Znf4+XLrGCT2dM99Us9ir8/bApB9Ou4Hnrqkp4uUKyQ07ULeL07tgIa3LsnuXzEEbqmB0c
	2wzGJZUCfM9g01a5PAKlcNx1IgnqyrWJtmoz4+Nu0ZgJy7DU9A+VsFJ9zgQw9h88Kq7vIc
	6sE78r4YoUYaMa5CwiIFMsiBK0bO+EQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PGETvgim;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793206518;
	b=RLKJeXnwWYZTcDkXaanEvrVQaVGYefrEIYgHkYZv8TVBKLbZ5vvBDNKmZcuzU0BebNDmmn
	xi/nmQd/CsJVfjukFugUUaUCUMwrdcZaNzjwPlF+LCHKGl0llVnE/AqTDyt3p56MmAYS5f
	JPisF2FRkYJyVQ0KtaFGX93Clf84xGg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CED0D601DE;
	Wed, 28 Oct 2026 16:55:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 387C31F01382;
	Wed, 28 Oct 2026 16:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793206517;
	bh=Z0ZhwvuKB4zpYCGY+1GjLRRMsHPTa5Lvp91s/JwcgmI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PGETvgimjC5rWAFpaoJxrtcE31Hr4LThMhiZfGVMqtUdDoKPpRgef6E5eQB7hR98p
	 c5WKDJ2cTqFeMcgg8Ez1UtF7iUtWG3LrA7LYy1HneLF8dHFvT/oa9a7GZdICiC8xyS
	 ONrs1r+JxfGRTmoL1vmN5O/99hVNPg6YpxdyVJOAsp1oQSK9GzdB/MPKzAsSjOVeTf
	 Yi4sk8mX89eZGDzaTduXiQVC6863Tru3ugiQg8ZZYz+HuLz+RrXV/adz9Xsy/ib8yJ
	 RDkrDtY8gv3eACaADOwtgj0yzwBVgcM26cNd7Mrtp4lL5pfM8D9KvkRLrzyVyR9EsP
	 kPt9uAZHpzBBg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id 781C0198004A;
	Wed, 28 Oct 2026 12:55:00 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Wed, 28 Oct 2026 12:55:10 -0400
X-ME-Sender: <xms:4yjiajSARqw8PioWyLkupEeXct9Ss2qs5djqP4hQga51zyA5CclqhA>
    <xme:4yjiaqF5uBuDkSDsDBVun3Nduxg_VIy8zCU5JbQmuyrxWrYRMrJ2uEtcy7Twvuij6
    U9QyXXC7AkQ-_yXBOAoKFfx8gFyBSvVJ-PR_hzb6Szh6PHnzb9Cl-os>
X-ME-Received: <xmr:4yjiaj-3U1reClXYJMR86x_214YB-E7NPJqkmAmytXP6g94Td4_LNsXyLGU>
X-ME-Proxy-Cause: dmFkZTEH/JXmOVrY1taDCoPaJq3IVEd1uOJXsXXF/9Hj9n77Aoo8DF/Z2+y6VwUMjdyxL/
    vNcNxlWPOrzJjnTTnhU/i8mG2RaecFzcvs1d/58U+81UT2rrSqZcuXVcmJPvN+85Vxmst6
    M+xIX1By265vICLgVpWMTiDzp4SikoR94mt5KoeDHe0EMSHOdb4HjYnJ2gFn6Jl/jXpTbW
    1cj1cjuHzE0QOe4Vj87hxPzVA7/e5WKQO7i7HlZnpcOqFBH4nZCcHIT12UXxL8WeWRxmIl
    5Im68ywTuP3WqKspjS2QQUDWVpnJdjOhauD/wAZQybXH1dmkgbh8FRIT9xxu5hpwJaaomC
    mvUYquwQCKDqfI6kfvDJMybmqBz7q/9PFZ6wxnj0QM2XOrQem1LihDgZxlgfmoxJzYIsWu
    xbnrF8t8WIJ5hEFFFVA/MpFaq7kGfFEDtPj7c/5lR+6uEB6MT88r5l0hakRGsn+Sd9HUTl
    b3RB3DDyj5tujdg60fA6EJQdbrWiA2uBzz55umormQ0ogMeP6OGN8c56LXAD6GGQ/PaZmQ
    IQISuPc1mDylIDH5VLMmYpcJ31tdiRrFvBKWYGWu+h5ifZZ2RLfDnGQTfxhGSfZR7jcFMW
    MFdExhcE3jnb1xzwCCOxlhc/jz01DYKk67mV4yzeBryfzQ34jWvPrzhEgeUA
X-ME-Proxy: <xmx:4yjiaoFcaoyZWpIYKFY3v7C-Oj28kP3zeTCZgSy395wYH63piXPgLw>
    <xmx:4yjiaphEdO-ptGAYs-gU575cuvwMxFSx7cAsAFR3lQSHx_aSFaRWEw>
    <xmx:4yjiakFOsCpyaRjuMMuHroAjcH_Safa5KEzD4ud7UwmaX0IzR-ZYTw>
    <xmx:4yjiat29K8iz33MgZzunPtVmpyVngsMlLqflnxkPJ89YD8mgu21FZg>
    <xmx:5CjiavpckMmHMDqrTmPU1G6w75v7E6SF6dz-jOjzrFV-Ljvs7_smwbqv>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 28 Oct 2026 12:54:58 -0400 (EDT)
Date: Wed, 28 Oct 2026 16:54:57 +0000
From: Kiryl Shutsemau <kas@kernel.org>
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
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>, 
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
Subject: Re: [PATCH 05/46] mm/truncate: look again if a folio left the mapping
Message-ID: <auIniV8YSpA4_oxg@thinkstation>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-5-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-5-6f74bec9a5bb@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4F09218000B
X-Stat-Signature: 41ukyxhnq9qbxkq9uxkrxayfcssncwo8
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793206518-23804
X-HE-Meta: U2FsdGVkX19YSpi0EU6LQCOPvLlb1eNhdqYMFsvIi5KKMET+5qliKXJTqBHj4ulkfUDvHAONSEMqX9hvLlnVukq9Tk3XeJnltHCoN6iP/vhWODtQXpJ44TXlqJcsBPUfrCDvI71AVTIexi2FGvX08fsSWmbAH74qWiYdPcxs6GGs6XEPC48+ZjoLD5LoVBDnCM70RQ4QF2bBVoTAdiIFbjQGWII+vHXs+WZRHMam+vMDD/xfQVk4aKpSk3Rqsz27ai9uKqqAUCpbznffR/Jg3mHayzQp+r+KrmY4Hi/BGehGenHRY+7WdXF7XJB926zH3fLWO0iPd5/PRtQvifMIF45b4boCTwYV5fVZIlqeIkN2XLTXgvf1QRtKiDdNLWygcXW5ZVvTlFvC5o2EHbA8U5rB5I3w5uAGejk0ja1o41HuP4GI0U4pB9YnFN0clZw0H8DJxhVhHoWapUcLi+meQbAYO1SFu7BzY0Dsq7IEulr3SVXDHQp90ZZrv9GU36mPBVeuY8qtXMOOfAH9VmED6WAJxh8iKmgM6xEnQp+cWfGoAkgTQ8738Y6CKcdoi9l6ffMegfgzrA6gm4NQhgmL557lU36jziqikSHPbNEONLtvvne6rU5m1CBIsCeY+eBmaemJzvE8oCeAn5+D3ddrn8I/+TXGq8wxM55jUYSyrcrrG7/K6S1wpUB39T2VL+vBhKzT/VXqotbLRfDyclHwcCU/gDIMwE/ju9T9WYZx+Ah2Q4CSstSHVzxuwIFHF7GwBy2UM3b6rTd/u1r70RiAIBa5Vk1ExFdyjF20zaN5T55l0IcvyzdhVY36XYiYM8cNQM/VVX0xcoAE1mL7yZDH7NZ9LEtrrJIowsuu4dOU9X4ZtX/qyD3ktESy1h0CHq2P9dZQWpMehzysAw/6VMX+ZnEx6kF71pYufUHKP7M7VYMq1s7Ud7v4YKqqRQz7NmhcOUGpc6+iGEqi6FscFWh
 ao2PJeme
 jAH0Ix0L0s1R2vdIdpY47Ggnr1f3CeSVaYrUNYnRdS5s5sr6QM7dTaJn/FS1vVK2pyh/Gogg+ePoP0DefsrqEMF8K7CJ2OrpvcpW/A1lNrB2OOR/P/tMVCubusTvxsOUi6DDyXuhNhSqT+qSOClkIDAdKR3dASdB12PzBgd3AKtdxTsdwFLyi2Uhdv90dz922FHUsjb9tiUiWF8ngPJEE4j1tB7oJWi5oSwUsPg6DcePlquEOXCUghIPgk7Oj0lqydGFdKvDV+e/1+7GAQTMhadQhylLmzy+eMahTuFsHnJOVpEvzxwzH2ciFdDjInfm1JUrnrJDWJLoX9ZX5pWSS9QHncRSyLDhi+KGe2S0SHjZ1IVcxLo0+u3ipTZMy945EmWofAif6mPt3nkMbkMJ5xZIRH0MqjWAnPH3jNjWKYKqW845WRZO+YvWGJdyuVHK8CAzInr+csct+Jean5EGjc8qVVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:17:25AM +0100, David Hildenbrand (Arm) wrote:
> invalidate_inode_pages2_range() skips a folio which no longer belongs to
> the mapping by the time it has got the folio lock, on the assumption
> that somebody else has removed it from the page cache. But the folio may
> have been replaced, and then there is a new folio with the same data at
> that index.
> 
> For most cases, like folio migration, that is impossible. However,
> collapse_file() only checks the refcount of the old folios, under the
> i_pages lock, and relies on their folio locks from there on. That works for
> users which repeat the lookup when they find folio->mapping changed.
> The following scenario is, however, possible:
> 
>   CPU0 pwrite(O_DIRECT)               CPU1 collapse_file()
>   kiocb_invalidate_pages()
>                                       read the folio (old data), lock it
>                                       refcount check
>   the write completes                 copy to new_folio
>   kiocb_invalidate_post_direct_write()
>     find_get_entries() -> old folio
>     folio_lock() ...                  xas_store(new_folio)
>                                       folio->mapping = NULL
>                                       folio_unlock(folio)
>     folio->mapping != mapping
>       -> continue

The diagram reads as if the folio lock should have closed the race. It
might be clearer with CPU0's folio_lock() after CPU1's folio_unlock(),
since the reference taken after the refcount check is what matters:

  CPU0 pwrite(O_DIRECT)               CPU1 collapse_file()
  kiocb_invalidate_pages()
                                      read the folio (old data), lock it
                                      refcount check
  the write completes                 copy to new_folio
  kiocb_invalidate_post_direct_write()
    find_get_entries() -> old folio
                                      xas_store(new_folio)
                                      folio->mapping = NULL
                                      folio_unlock(folio)
    folio_lock()
    folio->mapping != mapping
      -> continue

> In that scenario, the collapsed folio with the data from before the write
> stays in the page cache after the write has returned.
> 
> This used to be impossible, as khugepaged only collapsed files that nobody
> had open for writing.
> 
> Restart the lookup at that index, like shmem_undo_range() does. The same
> problem seems to exist in truncate_inode_pages_range() as well when
> truncate_inode_folio() fails, so handle it there as well.
> 
> Fixes: 1b6444331beb ("mm/khugepaged: enable clean pagecache folio collapse for writable files")
> Cc: stable@vger.kernel.org
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/truncate.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/truncate.c b/mm/truncate.c
> index 733d2713a875a..6d8c0ec4623fe 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -499,7 +499,15 @@ void truncate_inode_pages_range(struct address_space *mapping,
>  			folio_lock(folio);
>  			VM_BUG_ON_FOLIO(!folio_contains(folio, indices[i]), folio);
>  			folio_wait_writeback(folio);
> -			truncate_inode_folio(mapping, folio);
> +			if (truncate_inode_folio(mapping, folio)) {
> +				folio_unlock(folio);
> +				/*
> +				 * Folio might have been replaced: look it up
> +				 * again.
> +				 */
> +				index = indices[i];
> +				break;
> +			}
>  			folio_unlock(folio);
>  		}
>  		truncate_folio_batch_exceptionals(mapping, &fbatch, indices);

This hunk looks unneeded to me: its second loop restarts from start
until find_get_entries() finds nothing, so the new folio gets truncated
on a later round. Or am I missing a case?

> @@ -760,7 +768,12 @@ int invalidate_inode_pages2_range(struct address_space *mapping,
>  			folio_lock(folio);
>  			if (unlikely(folio->mapping != mapping)) {
>  				folio_unlock(folio);
> -				continue;
> +				/*
> +				 * Folio might have been replaced: look up
> +				 * again.
> +				 */
> +				index = indices[i];
> +				break;
>  			}
>  			VM_BUG_ON_FOLIO(!folio_contains(folio, indices[i]), folio);
>  			folio_wait_writeback(folio);
> 
> -- 
> 2.43.0
> 

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

