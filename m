Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4001606A330
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gXH/RP8U
Received: by kanga.kvack.org (Postfix)
	id BB0A96B05FB; Thu, 26 Nov 2026 06:20:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B61556B05FC; Thu, 26 Nov 2026 06:20:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A51146B05FD; Thu, 26 Nov 2026 06:20:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 77F016B05FB
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:20:36 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F024E1203DA
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:20:30 +0000 (UTC)
X-FDA: 85477027020.01.6622F81
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2BB0B120006
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:20:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gXH/RP8U";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795692029;
	b=WyXoKJbCc9aaAgz5O+/RL2GTv3/uRz08a6ebZb/qWvpbtpFVzNe+iEuLJhxCvPMtoX0D7N
	fTiou9aCBzr/6560kfTFqH2inFNsSozaFlIlhpVcAgpG6Qj5irC+icylDggGADnUTzS0uO
	oWePC8wCn0Gc55MOGCrfwgwVQuMXI7g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795692029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ecA3ZmQf+hgtDK0BoSFd9aCf4CcQv1VF93CQ72nCLAE=;
	b=3TfKzUl+Da2QVqSDMhPtj2kY7Hs6SDFDKWEEWW1DE89hf7EyhjsEKMLs9Z0WZ+R3NbeouV
	lUk7Gami5V/9WjjJXxh5Z1LW2ycJveXPk8I3Oq1ACiEAJfFwUu/75JODG4dItMnvJAJw+Z
	7UgLnUEk/nS8F2vMKolZ+krLnAY+K6o=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gXH/RP8U";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7CE054379A;
	Thu, 26 Nov 2026 11:20:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9B51F000D3;
	Thu, 26 Nov 2026 11:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795692028;
	bh=ecA3ZmQf+hgtDK0BoSFd9aCf4CcQv1VF93CQ72nCLAE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gXH/RP8UrELFZe6yrXteIGd+phr3Qk99Egj4zsLK1IuvwArJXAK1Fy4KyAbF46mO5
	 PH0AxCw9BklCUuFyejyZpc6QuUzGGyyTb9CiMuc1bIRzpeKcpaUv7ch9kTp/7kY7Nc
	 oeRIGOgPjuUfqUtKKkAC4FaPY6+9gOFDn9iTm9BfW8d7oeAXnOy8SMx0NZhmFcXs0O
	 dW8Hp6rsc+7FpvJr/U2HGBSpJ9+xX+pqAuVsvANh7gjkmFMjIz1FZMZVxm98+7H6rn
	 lGzkGrqZKMj/LAaWVP0xF7prst/6ghmOafBpGxF+9FGCZzeKJAIeqt9ktEc9aweNja
	 3dvFXL4LIKVYA==
Message-ID: <650e5497-1625-4e05-afc4-9db9472262ae@kernel.org>
Date: Thu, 26 Nov 2026 12:20:23 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: stop hashing address_space pointers for fault
 mutexes
To: Zhengchuan Liang <zcliangcn@gmail.com>,
 Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>, Davidlohr Bueso
 <davidlohr@hp.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <9a97a64f7e7aabc668499c426a2417a77d13a2f4.1795587203.git.zcliangcn@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <9a97a64f7e7aabc668499c426a2417a77d13a2f4.1795587203.git.zcliangcn@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2BB0B120006
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: we3pur7ux5jxbpo6m4axi178bcqq4ggw
X-HE-Tag: 1795692029-678505
X-HE-Meta: U2FsdGVkX19xuVRQGrZEc6MpyTKw3sc1iuDPHUPYT80NO9poPLVcwFuCtSbbT07tjlW93DTYTw9s1DYU1z+87Ob9LrdJhhFDEbel+sxrsyc3vHJE1uKQVl9QjlOG9X7YbemHpSqnqcde3o5FyEh7wcfGDAqphAsgknO7SwprrMU54I+u6mt7zKUzxroLjTgOGhcw6Svv8wOwXBDN15j5LuEayyVJaNQVOeo4IUgbNx1JjC7Gt2oZfGW/lpDktqkqsk2K8SR1XFoamxBZ5kaAocsicoauF5RIaOhH7UlUCuNb+fjyxpzdg3lj969h2PiOAhshIaJT0sAuGp+wDHBu4U8U7vd60uZ1lbmGyzJmPESXHUr2cGWClST0Xfr/x0rOKsNF9s37JjQJz/cU+wGxuZ92dMqIXoFebb3PU23ezHAS0q+/0740SW2Svu46NAmScyZQhuEqyq+P3wY6dtBEu7QG+vIfRmxF1AeAOh9kkqVZLPF8M5QjWNDb1M2y8XevxQI7yHo3wyoybXzJ66VeLCpTq9zduxLjwXQnF+ieouxcb3nND9TYxStZHhRNHf4ZBAtXO5SkocFuHckA1X+3uv0dIZLWyAF8pUwHk1doNNMwfBAo3wLzjzMMjHUyZyXQRck7U5/glwoRKSTZKcM7wMtR508hZgZYwp49k2lGefhDLHkhFGV8b6r/dqBwSQVqbwUsQYio8sTBX2ms2AJHDdomuzDKh6QPZnPzcoQM87xsaSqAPNk5QEmpROpXnmNMQLeabIvigsVTXcI+q9KY6BfYAeB2ZAljWAesammv04s9hdoRnWPOY122oV6LSYSRKV4Pwa3y8Gerk/TDFRRVV9hPx6p4+GZ5MadrtwyoPoe0gTGwOBvXrEbWnDW47qpbJ3LLsO5uqVApdW1u1XeiiOUNxk2lmhR4n0mFo/lTMGGoQDogghyASmZYot8mNCTgNWWUdLCUCbX/9l/894n
 e8uPGojV
 +sOkD8rll75EPEVYFhJ9oMW3ok+uWE9doP8GvmWMp/z6B59qGRls1SXsUpXnNPCC1WRuyQY2W8Bu8+shHDcpnrAH896uGdQ9XHlF/0IPF2l1RFm9fe+s8OOB/luxQyjkPcyYVqdwgWmcUSZRyobnsMVcKBg/k0CHO8dt+gBZnwETLAIde0xQocyVZP7JK6Iv5dOd83Oevrv5Il6UOzNL8ZsJslhUaOxZ8b5N8PDk7c1j/OodajWb0yFiNgiFo1qesvdIcqKVP7O1qRyK6AVp8y+IaY//P1jcCfjnSNzwOjzfxpB3VHw8+KM2n8wjGM/EADli7luFuBESixe4dERlhb6kK9k7e94Ccmn4owvgYs9FnJFKXDpIK1eF1HVE9Ehm2YucdOTTTShEhOYzy9hF4RgYkz754aa2SlJEiN2zO+FcBF+DoPwTFZh5IAev3n5X71PmSrdw/G+7/+guTjwK/Q3nfVnLV0bIhGBeNIrwAN0RTTq2bzz1RS0IwAU7hB49C6PTz7P3rBpFo0mIIQ1v/WtI0sMmHvSgvaDaQ8VzBKknGiwGKmq8FnoZvbkto9pBlmAhUCncXhIlzMqs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/25/26 07:15, Zhengchuan Liang wrote:
> hugetlb_fault_mutex_hash() uses the address_space pointer and page index
> to select an entry in a global mutex table. An unprivileged user can
> create a no-reserve HugeTLB memfd with an empty huge page pool, build
> contention on one index, and time SIGBUS faults at chosen indices.
> Pointer-dependent mutex collisions expose equations that recover the
> exact address_space address.
> 
> Give each hugetlbfs inode a dedicated random hash seed instead, and hash
> the page index with that value. Operations on the same mapping continue
> to select the same mutex, while separate mappings retain independent
> bucket distributions without encoding an address. The seed is not
> relied upon as a secret and is not reused by another hash table.
> 
> Fixes: 8382d914ebf7 ("mm, hugetlb: improve page-fault scalability")
> Cc: stable@vger.kernel.org
> Signed-off-by: Zhengchuan Liang <zcliangcn@gmail.com>
> ---
>  fs/hugetlbfs/inode.c    | 2 ++
>  include/linux/hugetlb.h | 1 +
>  mm/hugetlb.c            | 9 ++-------
>  3 files changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 558007fa5e88..72a406b97f9e 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -35,6 +35,7 @@
>  #include <linux/security.h>
>  #include <linux/magic.h>
>  #include <linux/migrate.h>
> +#include <linux/random.h>
>  #include <linux/uio.h>
>  
>  #include <linux/uaccess.h>
> @@ -1182,6 +1183,7 @@ static struct inode *hugetlbfs_alloc_inode(struct super_block *sb)
>  		hugetlbfs_inc_free_inodes(sbinfo);
>  		return NULL;
>  	}
> +	p->fault_mutex_hash_seed = get_random_u32();
>  	return &p->vfs_inode;
>  }
>  
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 58f755e70e96..61d833b7a76c 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -504,6 +504,7 @@ static inline struct hugetlbfs_sb_info *HUGETLBFS_SB(struct super_block *sb)
>  struct hugetlbfs_inode_info {
>  	struct inode vfs_inode;
>  	struct resv_map *resv_map;
> +	u32 fault_mutex_hash_seed;
>  	unsigned int seals;
>  #ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
>  	atomic64_t pmd_sharing_count;
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index ce9c8e57b8e5..6865ff468343 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -6091,13 +6091,8 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
>  #ifdef CONFIG_SMP
>  u32 hugetlb_fault_mutex_hash(struct address_space *mapping, pgoff_t idx)
>  {
> -	unsigned long key[2];
> -	u32 hash;
> -
> -	key[0] = (unsigned long) mapping;
> -	key[1] = idx;
> -
> -	hash = jhash2((u32 *)&key, sizeof(key)/(sizeof(u32)), 0);
> +	u32 seed = HUGETLBFS_I(mapping->host)->fault_mutex_hash_seed;
> +	u32 hash = jhash2((u32 *)&idx, sizeof(idx) / sizeof(u32), seed);

Both can be const.

As discussed, using the inode number, if possible (and if it provides sufficient
variance?) would be even better.

The u32 random number works for me as well.

Let's wait what hugetlb maintainers think.

Thanks!

-- 
Cheers,

David

