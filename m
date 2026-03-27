Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1DF410ED665
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 12:23:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C20E66B0092; Fri, 27 Mar 2026 08:23:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF8F56B0095; Fri, 27 Mar 2026 08:23:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B359D6B0096; Fri, 27 Mar 2026 08:23:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9FD726B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:23:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EE146E16AE
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:23:50 +0000 (UTC)
X-FDA: 84591759420.07.E04A704
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 87F5CA000E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:23:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F8g4lx3T;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774614229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x18/5Wyzdm/GZMICwYr/NVdnbQ5iOX9RD5EC5IJ5KpM=;
	b=7RTliHZ/uZUvGMZE5g5CK8TjgOZNlz4T+9Wa4xtIDunOaHE7shHdwGzHpd4fj4lOD4HQ3j
	qF+I0wNshJZhK6fDO4LSzeMscQlyTVWM8hRBh75i8rjpclwGxKRkzvX/c7Vw3nGk2mTGVq
	YtqtvN4LJpHcSQKDz+4jW6vUkne7X6w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774614229; a=rsa-sha256;
	cv=none;
	b=Kogj+sT1pSFAX0RbpMLd84hliufBckzIIaKcUXvovGSOAfLYvhi9LaD2Z7QTP7xfMUodDz
	gkH9+2InB+n5VakOLaDCLi3i9+fHKL/Lbv2dyIAy/gLDUGAZRPyWD1q8x3XaPgbXP23Mag
	+Jle2Sd+ue/ymC1EXTdUAEzrOJ59ARU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F8g4lx3T;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0B2A461344;
	Fri, 27 Mar 2026 12:23:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B8CC2BC87;
	Fri, 27 Mar 2026 12:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774614228;
	bh=V8sGUJvbBSQZ15CzkQaKkEa1Er8HddnCsDI3BKLTvtU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F8g4lx3TiflLWf5tCAz6PYcHqfwkdC2OZT6fbVgng80WiGZeUSPvNUYNoJG8K5b1k
	 ctE+Y9mi2tJbXfyDuDYpL+MLulBxdZdLTJ7hf9Gv3NjsRIyv2n3D02pKsxew980YrY
	 4+aAgDeHNXTwUC9zVA8rD9RTvSfLv0b6MeQipBsM5cx/SVt0thD2DT5zRNOUOiBohx
	 XMc2WXmuFzojQexEc+KdEdDUrkHdVKh24ktJCp5ilaCqdqttDpFSYHjHh2i73tnbQz
	 gfZfOymgqxXaJrXm1saxMePV2fv6gwfSo+frkerGCyGdg58aV7PsrIPFpK3l/AGZwr
	 7gLG979b4EszA==
Date: Fri, 27 Mar 2026 12:23:46 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 03/10] mm: fs: remove filemap_nr_thps*() functions and
 their users
Message-ID: <aaea8ce1-eac6-49d6-8c85-7361977b9a9f@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-4-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327014255.2058916-4-ziy@nvidia.com>
X-Rspamd-Queue-Id: 87F5CA000E
X-Stat-Signature: tb4qazrydusmw6mdofik7ytsduwxh1qe
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774614229-747099
X-HE-Meta: U2FsdGVkX1+8vYqV5njRvM+1OppnCXQLOUIwWI8W4Okk/2HkQ/NJ/MnW/0fKobduIJWdVniwCW5/X22dBqVCKKyzFjqCq7dqW5Qih+eFZERTb3SF7JEoZUfFY72wLDY/Hr+5Xx7mf8h5zezBu1q1ToLuFj8Y0eTOeEAACWHwUjQGDfMpA2e741k97MiY4oqPB7frY02tkhwFWiczUFOj1G6iCmVaKlZhjcnKtYK+NpNF7FeZfyYGGs1z5IxM4/pXCeQw+RCT/0DIBd9/2vPP1Le9m0/dLvvGIBhi/8sIPqw9Z7oIzpjmZ9LhEV9Wr+uh7HsFyRZ0npGmGljT7+//LuG58M27jRUizx39iluEsjtCMXr1q+j2OJOUpvcp5u7kdHCv6tTkwM9/mV3a70xiF1Sus/xZ0V/G5KJ8xajJHp9udgHfHe2CFZhrRLLPHI3rbWW4LB4nMFtU4CQybAe5eIq/yay+HyivMl9/FHTw9sJiLH1BWesuFINVylxfXGv0NCV9ZYQgLUocqan1qw8aCzFt1xgQKLLeZrrrFdNqeqDMuWGgveXOTDAZt0wZxTyIoyFaRFwpTzXKzDoGnNdXaMLHn1rj8vh2qwKZ1goQSM73IKJXvg/SodfLslTa02cc6rB4fvsJkxuJyeroAznxHS12lJET/vn01P2b3rw+yG7zW3BrzoymG57GCakFDIIyk2FbqNgLAIA75csjK7Dbwb4ojAliy/C/iaGZHHYuT44H1JhgHwIY3qjQm0ryR0u2SSFep7kx1LGh5bwamQyjmMM/zP2vu3INAducjbWqnFHJCTe4Qed9ZnHxvOzn5LKS2Yy1D0qsBQRH5lVcanzvSJYYUu8vZw09lY4m6F0ibfyECYr/RHNatAGX9NYEMTrOlaZZOWVL2uHrUWkdB27E+Cq0DuX5TTbSdjKpsQGsAezOEeMjIp3cvZTuccNaqVJe0lQA4oGwdryfSDYw6wU
 pQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 09:42:48PM -0400, Zi Yan wrote:
> They are used by READ_ONLY_THP_FOR_FS to handle writes to FSes without
> large folio support, so that read-only THPs created in these FSes are not
> seen by the FSes when the underlying fd becomes writable. Now read-only PMD
> THPs only appear in a FS with large folio support and the supported orders
> include PMD_ORDRE.

Typo: PMD_ORDRE -> PMD_ORDER

>
> Signed-off-by: Zi Yan <ziy@nvidia.com>

This looks obviously-correct since this stuff wouldn't have been invoked for
large folio file systems before + they already had to handle it separately, and
this function is only tied to CONFIG_READ_ONLY_THP_FOR_FS (+ a quick grep
suggests you didn't miss anything), so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  fs/open.c               | 27 ---------------------------
>  include/linux/pagemap.h | 29 -----------------------------
>  mm/filemap.c            |  1 -
>  mm/huge_memory.c        |  1 -
>  mm/khugepaged.c         | 29 ++---------------------------
>  5 files changed, 2 insertions(+), 85 deletions(-)
>
> diff --git a/fs/open.c b/fs/open.c
> index 91f1139591ab..cef382d9d8b8 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -970,33 +970,6 @@ static int do_dentry_open(struct file *f,
>  	if ((f->f_flags & O_DIRECT) && !(f->f_mode & FMODE_CAN_ODIRECT))
>  		return -EINVAL;
>
> -	/*
> -	 * XXX: Huge page cache doesn't support writing yet. Drop all page
> -	 * cache for this file before processing writes.
> -	 */
> -	if (f->f_mode & FMODE_WRITE) {
> -		/*
> -		 * Depends on full fence from get_write_access() to synchronize
> -		 * against collapse_file() regarding i_writecount and nr_thps
> -		 * updates. Ensures subsequent insertion of THPs into the page
> -		 * cache will fail.
> -		 */
> -		if (filemap_nr_thps(inode->i_mapping)) {
> -			struct address_space *mapping = inode->i_mapping;
> -
> -			filemap_invalidate_lock(inode->i_mapping);
> -			/*
> -			 * unmap_mapping_range just need to be called once
> -			 * here, because the private pages is not need to be
> -			 * unmapped mapping (e.g. data segment of dynamic
> -			 * shared libraries here).
> -			 */
> -			unmap_mapping_range(mapping, 0, 0, 0);
> -			truncate_inode_pages(mapping, 0);
> -			filemap_invalidate_unlock(inode->i_mapping);
> -		}
> -	}
> -
>  	return 0;
>
>  cleanup_all:
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index ec442af3f886..dad3f8846cdc 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -530,35 +530,6 @@ static inline size_t mapping_max_folio_size(const struct address_space *mapping)
>  	return PAGE_SIZE << mapping_max_folio_order(mapping);
>  }
>
> -static inline int filemap_nr_thps(const struct address_space *mapping)
> -{
> -#ifdef CONFIG_READ_ONLY_THP_FOR_FS
> -	return atomic_read(&mapping->nr_thps);
> -#else
> -	return 0;
> -#endif
> -}
> -
> -static inline void filemap_nr_thps_inc(struct address_space *mapping)
> -{
> -#ifdef CONFIG_READ_ONLY_THP_FOR_FS
> -	if (!mapping_large_folio_support(mapping))
> -		atomic_inc(&mapping->nr_thps);
> -#else
> -	WARN_ON_ONCE(mapping_large_folio_support(mapping) == 0);
> -#endif
> -}
> -
> -static inline void filemap_nr_thps_dec(struct address_space *mapping)
> -{
> -#ifdef CONFIG_READ_ONLY_THP_FOR_FS
> -	if (!mapping_large_folio_support(mapping))
> -		atomic_dec(&mapping->nr_thps);
> -#else
> -	WARN_ON_ONCE(mapping_large_folio_support(mapping) == 0);
> -#endif
> -}
> -
>  struct address_space *folio_mapping(const struct folio *folio);
>
>  /**
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 2b933a1da9bd..4248e7cdecf3 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -189,7 +189,6 @@ static void filemap_unaccount_folio(struct address_space *mapping,
>  			lruvec_stat_mod_folio(folio, NR_SHMEM_THPS, -nr);
>  	} else if (folio_test_pmd_mappable(folio)) {
>  		lruvec_stat_mod_folio(folio, NR_FILE_THPS, -nr);
> -		filemap_nr_thps_dec(mapping);
>  	}
>  	if (test_bit(AS_KERNEL_FILE, &folio->mapping->flags))
>  		mod_node_page_state(folio_pgdat(folio),
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index b2a6060b3c20..c7873dbdc470 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3833,7 +3833,6 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
>  				} else {
>  					lruvec_stat_mod_folio(folio,
>  							NR_FILE_THPS, -nr);
> -					filemap_nr_thps_dec(mapping);
>  				}
>  			}
>  		}
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 45b12ffb1550..8004ab8de6d2 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2104,20 +2104,8 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  		goto xa_unlocked;
>  	}
>
> -	if (!is_shmem) {
> -		filemap_nr_thps_inc(mapping);
> -		/*
> -		 * Paired with the fence in do_dentry_open() -> get_write_access()
> -		 * to ensure i_writecount is up to date and the update to nr_thps
> -		 * is visible. Ensures the page cache will be truncated if the
> -		 * file is opened writable.
> -		 */
> -		smp_mb();
> -		if (inode_is_open_for_write(mapping->host)) {
> -			result = SCAN_FAIL;
> -			filemap_nr_thps_dec(mapping);
> -		}
> -	}
> +	if (!is_shmem && inode_is_open_for_write(mapping->host))
> +		result = SCAN_FAIL;
>
>  xa_locked:
>  	xas_unlock_irq(&xas);
> @@ -2296,19 +2284,6 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  		folio_putback_lru(folio);
>  		folio_put(folio);
>  	}
> -	/*
> -	 * Undo the updates of filemap_nr_thps_inc for non-SHMEM
> -	 * file only. This undo is not needed unless failure is
> -	 * due to SCAN_COPY_MC.
> -	 */
> -	if (!is_shmem && result == SCAN_COPY_MC) {
> -		filemap_nr_thps_dec(mapping);
> -		/*
> -		 * Paired with the fence in do_dentry_open() -> get_write_access()
> -		 * to ensure the update to nr_thps is visible.
> -		 */
> -		smp_mb();
> -	}
>
>  	new_folio->mapping = NULL;
>
> --
> 2.43.0
>

Cheers, Lorenzo

