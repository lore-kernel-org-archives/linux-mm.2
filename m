Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BD4D606A325
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 11:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Naie0bLo
Received: by kanga.kvack.org (Postfix)
	id 15B7D6B05B9; Mon, 26 Oct 2026 07:19:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 133996B05BA; Mon, 26 Oct 2026 07:19:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3DCA6B05BB; Mon, 26 Oct 2026 07:19:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CFBD06B05B9
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 07:19:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 618DA120730
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:19:30 +0000 (UTC)
X-FDA: 85364531700.21.1320EF8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 88106120004
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:19:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Naie0bLo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793013568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ym2rUG4N9q5Vuz2Zf+g/cQPodhMY2XS2XpRVAbz6x2o=;
	b=1zLkaXA4pyMfMKCzXgnHo5lFYnc1JQn45e/DGJxlO3aOHADo6JA99FjUbuWxJoLsBnnloP
	ijRDxsjfPjrUTQ8AzwyH6308E0n9Iq6YABfdU+hgoQGWaqcwFaB2SOSRnAg0boL1MGHdQP
	rY4bTUwI3gpW64ERXdOWzX7wrIyj1Qs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Naie0bLo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793013568;
	b=ZdB+6o7sljxQ7QYWjhIkGqlfvkADyVtup3j2VFzuylg/9QbElP0P1uTjbE35YolVw4Ubkz
	SaGJAtF4u1h3dVAkSBLD4EeANxKlUKJfrnwROC60oGLkYdQHQ9XFyPPbuurBBH95N7vdZj
	6L3zQIDAJ3xPmh5n9kYlKXqo+X/wULg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E543406F0;
	Mon, 26 Oct 2026 11:19:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6723F1F01453;
	Mon, 26 Oct 2026 11:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793013567;
	bh=ym2rUG4N9q5Vuz2Zf+g/cQPodhMY2XS2XpRVAbz6x2o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Naie0bLom6KB1rvZiawwhNtlk55RBj7K9WkrJ62mpDzmd9p3ZjTeOhiy9/BYmyqqo
	 SnNRmD9w2Kz+0bSLQRlg8Tui85D5ZH0652mrSWRzXhTB5K+jIu9ma16QMmKAtXShM8
	 DPHVOy6h8rmnPLxA+itKXfRJjJHDY/UsAnutAKmXMCh/pi+/jNoUCmRv2nSkUKchq5
	 iXCcTfsHnUyFmxEe5kxR3+PmC4oYX1reUzFTklfn/oI4jh476Y8y6Z0tz31GJGBHpW
	 nDNDalO8lQY5sWzN7TmhP8cMk8olsxCglZgxn5aDh4gDUCv7xAUOoqxZ9Y1YxDVIeV
	 uaJorTDd45ugg==
Message-ID: <c021e641-f415-48bc-badd-d340d70dd850@kernel.org>
Date: Mon, 26 Oct 2026 11:59:46 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate: move NR_FILE_THPS on cross-node migration
To: Ridong Chen <ridong.chen@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
References: <20261025110209.4105994-1-ridong.chen@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261025110209.4105994-1-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 88106120004
X-Stat-Signature: c5x3xa37h1wkp8aczcrqwb51gbhz64k6
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793013568-430372
X-HE-Meta: U2FsdGVkX1/7oDLMjkHW69Ap9kA7NjK5BtmQqEHvaOLY+L8S6Ao6aUqgGqkhzAVrcw1lH5j2pQkh5MbUazgqyJgcG+NHJ2bvqCKx+hlpKXpV5lf2BmxYjZoNhkx0njfn9vFBFPmURag4zBya5A/dGPdY7BtZB/0Wq8UIWoVPBn3HU3SdFosMRrAeImbKPWwqqyLjye/q1xe7CRVky2rmdjbI7APCjTR5ywjUbqsmou7k3QbWuQDoAgwjy9wStbgRIwOSU7yYgbrZ3Az+bsZ0mHgkefSaceHhooe4TBgsyTxfAGHF798k1uPSKQtPWkLSAd/obBsxDLIjT9jP2Ze6C4ttFI1ukMkH7e/4v2h4wo0ztPrt8ZMvG+bMZyf34xZGzvkMm9u0LjM0zpRzj8bm0BOuO8zkFO0OVo9XgWJyj48amUyOIqmtwYxLINrxqPPFx+0D2zWoQLvSq41csDmpMXDVatMi4TEX39XpoiszCB8+11AoBIZoCSIev2leXQ21zD0PbXRsd9Q8p2Z9skev+AYWubyAonYQEszTSBAj2UDSSHxHtbPLaguLgK0DX5QCoIrVIfJJq96QRRz5F45SO037Rx9hwhqiYiMdWOuNlywP1dzfXP7O019WHGhMazGgAlMH2ci38UuGJ7jTSacfIrWx87ee7z4BLzSN6K6Il2PPljaWRePY3P7cw+3/5hH5r5EuZSbURbOhWJl3a9wFRJYL10Kb3aIHOTqGY7piCidj1vj3iC1hRqAEk+ylPdENsPslKCmUiovQ3hThsYx3RZZZgK2MPyRBJY+loG8Qy+n63a9F4ZM9PLFaUKNjLUMcOCcpd2kLXaT2DkslOa8UvNODEvhgdMZF/8apq5GwHq4DMTbZDnHAi5WSd4easXGZbQiYmOtX2Qhdf0+WSgSdKagyxbYOM5CcwHbbAgE0JkndClheTW11ewyyHc/UbVPGlJKzGz++lm2ROn+rv4E
 YsyJW11i
 eu+kGT07/+d3zR32dXzZ7lqEdXcd1Pp3LAfbD4LJygnDu1X6Te9BlK1yHTJm9n0DVaOHPdwI1P7D/MAl5oHtIWM2OeWO2aj8uFjLbPRrH2ukYfxdlyqAzUplqaT2NPzlE4hoSoeFuD77IFTXxSc+WaKhsnft1SfGHHpGT/Llrkfh1xIRmyFH1egtuxsWBXC0BczQ/x0HZHii33mpGWGvLLzwKE0rvDVc/nX+2Jp4sz5QsOsB2tEpjwjs0XZUNcSjMQ1Vt4Jxw+13PIr7S6zazjafg0DOxKDJbsmXEVXKkAW2kZW9Q0o+wY4SjWV8/OiAKNTpfSB+e1rj8+hz4ydqbdmc89be1IkxA/oYlvcpPNQQPgUrY3mSP1uEXtu40YsFThIjl3VHs513W0YXdi7zP/V/jCnriVnWoJAoFyWyva1Kde2Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/25/26 12:02, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> When a page cache folio is migrated to another node,
> __folio_migrate_mapping() moves the per-node and per-memcg counters
> that are keyed off the folio's node: NR_FILE_PAGES, NR_SHMEM,
> NR_SHMEM_THPS, NR_SWAPCACHE and NR_FILE_DIRTY.  NR_FILE_THPS is not
> moved, although __filemap_add_folio() charges it to the source node and
> filemap_unaccount_folio() takes it off whatever node the folio lives on
> when it is removed.
> 
> Commit 0b52c420350e ("mm: fix shmem THP counters on migration") added
> the NR_SHMEM_THPS case but not its file-backed counterpart.  Now that
> ext4, xfs, btrfs and erofs can all have PMD-sized page cache folios,
> migrating them via NUMA balancing, mbind(), migratepages, demotion or
> memory offlining leaks FileHugePages on the source node and underflows
> it on the destination, in both /sys/devices/system/node/nodeN/meminfo
> and memory.numa_stat.  The global value is unaffected, which is why this
> went unnoticed.
> 
> Reproducer, on a 2-node QEMU guest with THP set to "always":
> 
>   1. read a 256M ext4 file through a MADV_HUGEPAGE mapping while bound
>      to node 0, so its page cache is 128 PMD-sized folios on node 0;
>   2. move the mapping to node 1 with mbind(MPOL_MF_MOVE);
>   3. unmap the file and drop its page cache.
> 
> nr_file_hugepages in /sys/devices/system/node/nodeN/vmstat after each
> step (in units of PMD-sized folios):
> 
>                     without this patch     with this patch
>                      node0     node1       node0     node1
>   1. cached           128         0         128         0
>   2. migrated         128         0           0       128
>   3. dropped          128         0 (*)       0         0
> 
>   (*) the counter has underflowed to -128; negative values read as 0.
> 
> Without the patch the 128 folios stay accounted to node 0 forever, and
> every further round adds another 128.  The same happens to the per-memcg
> per-node counter: after step 3, memory.stat of the cgroup shows
> "file_thp 0", while memory.numa_stat still shows
> "file_thp N0=268435456 N1=0".  With the patch both are 0.
> 
> Move NR_FILE_THPS together with NR_FILE_PAGES, using the same condition
> filemap_unaccount_folio() uses to take it off, so that THPs in the swap
> cache are left alone.
> 
> Fixes: d68eccad3706 ("mm/filemap: Allow large folios to be added to the page cache")
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
> Note: prepared with help from an LLM-based assistant (Kiro, claude-opus-5.5).
> 
>  mm/migrate.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 7bdcdb57652f..d55f576a2579 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -700,6 +700,10 @@ static int __folio_migrate_mapping(struct address_space *mapping,
>  				mod_lruvec_state(old_lruvec, NR_SHMEM_THPS, -nr);
>  				mod_lruvec_state(new_lruvec, NR_SHMEM_THPS, nr);
>  			}
> +		} else if (!folio_test_swapbacked(folio) &&
> +			   folio_test_pmd_mappable(folio)) {
> +			mod_lruvec_state(old_lruvec, NR_FILE_THPS, -nr);
> +			mod_lruvec_state(new_lruvec, NR_FILE_THPS, nr);
>  		}

Looking at filemap_unaccount_folio(), I was (once again) surprise about the
different handling.

Key is that we might be migration aonymous folios in the swapcache.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>


-- 
Cheers,

David

