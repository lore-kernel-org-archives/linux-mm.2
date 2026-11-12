Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D1A5606A893
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 18:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ri0Kd36/
Received: by kanga.kvack.org (Postfix)
	id 256466B05B4; Thu, 12 Nov 2026 13:07:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22EE16B05B5; Thu, 12 Nov 2026 13:07:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 145366B05B6; Thu, 12 Nov 2026 13:07:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB5516B05B4
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:07:47 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 88B0C1C4099
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:07:47 +0000 (UTC)
X-FDA: 85427250174.11.AEDDD23
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id CCE67180003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:07:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ri0Kd36/";
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794506866;
	b=SC+f8NqwjfoHCiOni6VI+fLNPk9yndCYdm+BcEQcDpAmaDif9aHfKZWDyCuqP/tuR6ADxg
	eSL8oDYoed5/CK9hdgruVxDjiS9xoSkc9fOFbgyuEUr49JJwArGBT6wksD2P5jne/Fa+bA
	wAIVuPE4FGB86SS8OW04rF4ARGRUzQQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ri0Kd36/";
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794506866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jsNR/pRYGWFaHDwqujtAOATNDQ1mgwcPOKFdvCgM3hE=;
	b=A92/j19hjma32yyTOg0E7siA1dCKNS3TcMWm3gXsN2n7Vkjvxu7oI/rR1VMj2MyCtZfhJy
	PUTnbIJKLoJnfZfrgo1hxyhJsU4nGwq5kKHc5W0E8/w5Hi1tWO7QtzbBx9+0UGb+Si2A4u
	CJSMUPr3mbX6JhXw40Xznv7fPgMybJI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 00BB14464D;
	Thu, 12 Nov 2026 18:07:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D261F000C4;
	Thu, 12 Nov 2026 18:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794506864;
	bh=jsNR/pRYGWFaHDwqujtAOATNDQ1mgwcPOKFdvCgM3hE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ri0Kd36/I0P3REBf7rp3tYJapb9ri00ThjWxr7bxZQXWTXK5k8HEIv1/xKsjeH8d8
	 ML/Hfq1bBdz/Q3/TbVrGHRgdbaqpymB8cw3gTS9oB+smix1e+y6ZfRCVLseuZ+5Jbg
	 iWqeaF5i7JnZfaMJkoxKtM27qLqhGxSrds4bzGhdm6L2LT2JUmPnXbUudgFR/dx6zj
	 T39tFbntOyrWurf/pnumuiUevGgIA2qgqaRjnfNEkHXoel1UfyoS9emjlTldtPsizn
	 YentbTKSKr2FMp5rkpFMe3fDXL28YUf17Z0ZkZFlAp0yIYFbOQHrwggE16P0isEVAC
	 bQju1Bu9kDmdg==
Date: Thu, 12 Nov 2026 18:07:32 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
	James Houghton <jthoughton@google.com>, Andrea Arcangeli <aarcange@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Balbir Singh <balbirs@nvidia.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	=?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>, Andrei Vagin <avagin@gmail.com>, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>, 
	Muhammad Usama Anjum <usama.anjum@arm.com>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Chris Down <chris@chrisdown.name>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	=?utf-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>, Michal Hocko <mhocko@suse.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 02/12] userfaultfd: refuse UFFDIO_MOVE into a non-present
 huge destination PMD
Message-ID: <avYAMYr87pHQ29Zh@gremlin>
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-2-00713d368976@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111-uffd-state-fixes-v1-2-00713d368976@columbia.edu>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CCE67180003
X-Stat-Signature: 9s1w461kxg15caef1tuuaduetp5b3cdm
X-Rspam-User: 
X-HE-Tag: 1794506865-305749
X-HE-Meta: U2FsdGVkX1+udT96lfVatXH4qYvQjeZexPRs2am89RE4Si8zC/dd94smdXtEIzfb2t2CAhpaIuzylY7m1vYny2ng/gB1ZBVS0V7DFAHVTA+Oi7U/8HuYnP3nVtmOZRDhNgJE46xhfVL5Q8WJUcfmd30vRvELwxLBNzAsGkmiAa30ZgAaM9oESzjOPho6go2OMF8qdLqSN/SLbjK/aSz9aPQ+U8gv7uuqM/3HbxYnjMYDTUVq6T9iqS27vCYQyJk2D1UNF6xftKKyPFTpXWvsmsskuS0YSrj86bvOOYxtctd+zMNEPnXy7Hp8ujUY3q4SwQHH3NcDEpP2/iJ1tzHP9+NbSIgahBzF2HKWWy29hngs8ccz1PSLyNpFkKMDimfRKvzhSItv2qRkS1hGSXAJ59MFZ+a2AtF9BBQzu2/hQPPG+u4BcF5biGi4k6LPoIo7i2hgIJrNCDpPbIEwsHxOayLqBl9gQwTUAoTu8On4Ko4rikx5Kq4+B9ybB29YQBlnw9gYs3+nL0G+FoerPlTXufMioD2O9YJVw6Ul57WHFcCbHbR6nR1pp0qT25BEEAkENL+eJ/vh7zHd+/ATwNbxyOaoAoV+qdBaURcXgRG95LXz0c4y4rG6CjXXA68N36+MIFh6zNFr4xW6xkqDUDWfTS/nM/rW9iRZXXc4xRjalSkJAK5bzVe+t9nT/nJhFoJa24yK4iOMMXcj0OHMcOquBXsSS1koPpuyVJvcSQw117L/yPK6bfQHIQ7pd5AIMG5XEDk0131F8nl/n+ePBIh7Az5A+s8pc3jhHjSPGS+UPZReBMPm56TeoguAbdoWoHfQLkU530plzYms1oH8ZaG2A2zmExqcTAmJiWd7uNWoVtstwwzThHKfviKZ/Iaz1u0cqogaZAi5Qqyqe++3WloaBA9TEnCFElZ1RyhB6fLJHUdN7hGjKJmUPTkr2/FBvDG66HVbKkYUFiQcX1ZqWq8
 zwlzpX4I
 zIa9Ct0xdshxbwBMrsXhSgKndW3YYnuz8wyjF7yIEpZy2+dKL+8uA92o1OkKOyQ0ntEAXVT7wA74JaHF+T81OfvsA+KFRU62XecpFBXsJeVMRKgKa91/CSAi63EtrLliXb8ddq4vpKF4LeS2/8mM+k3glKq5OahJafv37MZrMcVib3rk2rMKX/bNKGaoMmoXjuDBO22aN5l4+zbz9ekntDOO7CwyfJcD1dPzR7e22XTASUIilNo5/9zhNTV5sqG4s2Urk8GN+EGJdjTLNaIa4CZHKFwWnE8SqgDctI5584TsthgYRhP7xbrh5IArwUD0mfqm7uCRFHZOuBHvj/Okkiu8w/U2onGZQQqHesXI9NZ57TmPGxG9WEorC+esA/WD1BnnmFHpD1Lx6hgSyETxkXJsX8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 12:55:10PM -0500, Tal Zussman wrote:
> move_pages() refuses to move into a destination PMD that already maps a
> THP, but checks for that with pmd_trans_huge(), which is only true for a
> present THP. A device-private THP or a THP under migration is a
> non-present huge PMD leaf and is not refused.

non-present huge PMD softleaf :)

>
> The destination PMD is then treated as if it pointed to a PTE table. It
> is not empty, so pte_alloc() leaves it alone, and move_pages_ptes()
> fails to map a PTE table from it and returns -EAGAIN. move_pages()
> retries on -EAGAIN, with both VMA read locks held. If the source is a
> THP, it is split first for nothing.
>
> For a THP under migration, the loop ends once the migration finishes.
> A device-private THP can remain in device memory indefinitely, so the
> caller of UFFDIO_MOVE hangs until it receives a fatal signal, and
> anything in the mm that needs to write-lock one of the VMAs blocks along
> with it. This requires a driver that migrates THPs to device memory.
>
> To fix it, check the destination with pmd_is_huge(), which is true for
> any huge leaf, present or not. UFFDIO_MOVE now fails with -EEXIST in
> these cases, as it already does for a present THP.
>
> Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Looks sensible to me so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/userfaultfd.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 61a712e1f9f5..ad9d243dc64b 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -2021,12 +2021,13 @@ static ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
>
>  		dst_pmdval = pmdp_get_lockless(dst_pmd);
>  		/*
> -		 * If the dst_pmd is mapped as THP don't override it and just
> -		 * be strict. If dst_pmd changes into TPH after this check, the
> -		 * move_pages_huge_pmd() will detect the change and retry
> -		 * while move_pages_pte() will detect the change and fail.
> +		 * If the dst_pmd is a huge leaf, present or not, don't
> +		 * override it and just be strict. If dst_pmd changes into a
> +		 * leaf after this check, move_pages_huge_pmd() will detect the
> +		 * change and retry while move_pages_ptes() will fail to map
> +		 * the PTE table and the next iteration will see the leaf.
>  		 */
> -		if (unlikely(pmd_trans_huge(dst_pmdval))) {
> +		if (unlikely(pmd_is_huge(dst_pmdval))) {
>  			err = -EEXIST;
>  			break;
>  		}
>
> --
> 2.39.5
>

--
Cheers, Lorenzo

