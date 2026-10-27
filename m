Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59191606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 14:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F/aE3Kg9
Received: by kanga.kvack.org (Postfix)
	id 685F76B0791; Tue, 27 Oct 2026 10:41:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 636E36B0793; Tue, 27 Oct 2026 10:41:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 527C56B0794; Tue, 27 Oct 2026 10:41:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 28A2B6B0791
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:41:49 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A06341A05D8
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:41:48 +0000 (UTC)
X-FDA: 85368670296.30.A624D72
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id E5253160009
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:41:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="F/aE3Kg9";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793112107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cxbcd97TigLbOc2nsbdYTtwGKr7cyQITuDlutqpOwp0=;
	b=KAAtj/4DQDFXRi/OzDhhTEby+d+t5nNf59O+NLnAM2aG7bmqXcCWQ2kzfmh3ZCCz6z3GIo
	KeqDHjEvm+02wJQwCp+F7ABw0OLtbcr/Evmy8Bh3tQ+XXqENy5XGOlNLe+gXhM1jiW1TAo
	+fQOiR/Kf9K4n8OV/gt9zqAKwmWUAEI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="F/aE3Kg9";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793112107;
	b=HRBU+G3X3bids4MVzgNianBtVEIGTZqc+46T9kpTq5ns7rEAi6IOZiSNSwPKaRotbAb/OL
	lfc7lpFIvcDfUipG14eWiPTLQXcXaRbC0d8Mz3FkJl+3uTfNtD7tsuCUt3Z8MgZnjkfQJc
	7/XgqOfHhYfPbYOzw8heG3mdb/1IKwo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1495641A3F;
	Tue, 27 Oct 2026 14:41:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A8B1F01825;
	Tue, 27 Oct 2026 14:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793112105;
	bh=Cxbcd97TigLbOc2nsbdYTtwGKr7cyQITuDlutqpOwp0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=F/aE3Kg94sj9fXVFeMOGEhnFPh7IPM73CFA/LmgAAZfItP5Nw7PY1j3LmhUrie3RF
	 WWOkZE/CrqgRjQtrY5czn2Xyhnu7Jhr5cpxZIRN6ucwFL7953eyR9cc+xJIfYeqrtx
	 x427FQ040+6sFoWm3ZQYEETyJqIrMT+OQrZXuAnXJaqqyPl1iBQjI9L2UIFGYkQFmj
	 rXT+tzW5xd2XQNYXVDL7CnDknr0SBZMXfP2tLX56GVF5sYE25tWUnjur3LSUQsNAM/
	 e9FZ57Wpnn2LjlHGFOu9V+hCx07zuXfQscJu7g4AtCiXI1sCKypZwCMKvsYpJoK5pk
	 vtVZ2ljYGxZvA==
From: Pratyush Yadav <pratyush@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Johannes Weiner
 <hannes@cmpxchg.org>,  Michal Hocko <mhocko@kernel.org>,  Qi Zheng
 <qi.zheng@linux.dev>,  Shakeel Butt <shakeel.butt@linux.dev>,  Lorenzo
 Stoakes <ljs@kernel.org>,  Kairui Song <kasong@tencent.com>,  Barry Song
 <baohua@kernel.org>,  Axel Rasmussen <axelrasmussen@google.com>,  Yuanchu
 Xie <yuanchu@google.com>,  Wei Xu <weixugc@google.com>,  Baoquan He
 <baoquan.he@linux.dev>,  Baolin Wang <baolin.wang@linux.alibaba.com>,
  "Liam R. Howlett" <liam@infradead.org>,  Vlastimil Babka
 <vbabka@kernel.org>,  Mike Rapoport <rppt@kernel.org>,  Suren Baghdasaryan
 <surenb@google.com>,  Michal Hocko <mhocko@suse.com>,  Kees Cook
 <kees@kernel.org>,  Peter Zijlstra <peterz@infradead.org>,  Jann Horn
 <jannh@google.com>,  Pedro Falcato <pfalcato@suse.de>,  Hugh Dickins
 <hughd@google.com>,  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush
 Yadav <pratyush@kernel.org>,  "Matthew Wilcox (Oracle)"
 <willy@infradead.org>,  Jan Kara <jack@suse.cz>,  Zi Yan <ziy@nvidia.com>,
  Lance Yang <lance.yang@linux.dev>,  Rik van Riel <riel@surriel.com>,
  Harry Yoo <harry@kernel.org>,  Alistair Popple <apopple@nvidia.com>,
  Nico Pache <nico.pache@linux.dev>,  Ryan Roberts <ryan.roberts@arm.com>,
  Dev Jain <dev.jain@arm.com>,  Usama Arif <usama.arif@linux.dev>,  Kiryl
 Shutsemau <kas@kernel.org>,  Matthew Brost <matthew.brost@intel.com>,
  John Hubbard <jhubbard@nvidia.com>,  Peter Xu <peterx@redhat.com>,  Will
 Deacon <will@kernel.org>,  "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
  Nick Piggin <npiggin@gmail.com>,  Oscar Salvador <osalvador@suse.de>,
  Minchan Kim <minchan@kernel.org>,  Muchun Song <muchun.song@linux.dev>,
  Xu Xin <xu.xin@linux.dev>,  Chengming Zhou <chengming.zhou@linux.dev>,
  Chris Li <chrisl@kernel.org>,  Kemeng Shi <shikemeng@huaweicloud.com>,
  Nhat Pham <nphamcs@gmail.com>,  Youngjun Park <youngjun.park@lge.com>,
  Gregory Price <gourry@gourry.net>,  Joshua Hahn
 <joshua.hahnjy@gmail.com>,  Rakie Kim <rakie.kim@sk.com>,  Ying Huang
 <ying.huang@linux.alibaba.com>,  Jason Gunthorpe <jgg@ziepe.ca>,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-fsdevel@vger.kernel.org,
  linux-arch@vger.kernel.org,  linux-cxl@vger.kernel.org,
  stable@vger.kernel.org,  Chris Mason <mason@kernel.org>
Subject: Re: [PATCH 03/46] mm/memfd: check for real shmem inodes before
 accessing shmem state
In-Reply-To: <20261027-fixes_core-v1-3-6f74bec9a5bb@kernel.org> (David
	Hildenbrand's message of "Tue, 27 Oct 2026 00:17:23 +0100")
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
	<20261027-fixes_core-v1-3-6f74bec9a5bb@kernel.org>
Date: Tue, 27 Oct 2026 15:41:34 +0100
Message-ID: <2vxzh5i7p5nl.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: E5253160009
X-Stat-Signature: pxmja9nk3nk13yntmc7oqnx5se65txz3
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793112106-593856
X-HE-Meta: U2FsdGVkX188c8IeVZqkb+CFwtzZQyYtG81xTt132zDHLRA8uZBt7vVzc1qNUKgskhK6jmoxKVL07bdv5D04YHn0LYphfW0u0277t+HfOvoInwJzrBXtZ2vstIpNp/E0dR5jCaTqYFX+KvNSCk5k+iSyljHXCR12vuRY1hPms6P8bE0RFv8Kv4jthPZDoXJ2pLhGHE1eK1hmf44+HvrXf113qrxJAANhn3MtPRu42urCHmv+voAQTJ4VQhox8xWpW3Y/+J9AFtE68pE8lqjNb9s2B0wgsDSFy7jCHAfJZVTUx9SFCJOb4NDlrvWFuaXI4dx+4JtDiM4JYCSQ378DvUvcrYPc+c1mWWHd3xJV6riBlMm8kz4VgPveFJW6rpW/jFKaR2QpN2gLB1dxrOAHMyxucN7J8MJJLJWmC2AhuR1vmaNF/CiESzRQP0Jet/7NcqW6ukQYzp7pM/Ew26LHwfh01bXkfdXP4MtFWozlAg1lJB7oYkFR2EaMQ9EMgx+qtsC8mpfNzJLZBSi9GdFKUElwgSsE4E2cgIZueM/J+OsJPGQPBCHXkP6XNcNj5MAQJRvd+Tq5MfeJMMoG952z1mS1jshG7i3oyWpIPoVMwDiFqRbrHAb3Sap9DFngXHu8sb2uGxoMe2w5huN+PRG3yNhS7c82R1gAh4YVI0oayqkuhk/TlDDmz1rVgpvv92VjiUdXCCF8j/hPS0apMpw/XaEwFIpTJ+QStaYrmGptuCiSD+xsEdRhBBkMT8j8xcngldprEecUfMGGQx4kSZhRuUM9HuNnyi7q/Z9xtiVC3OQL49CDGBKCNfHnCRc6K/sLIlf9cqDYzhm46oNT5i2ZzQoMsjKbAWUZDYNWQ3aB2fKxAD6xDf3lg3YaDHNhgncbzP4P4gpTcCOOXBb5xflv2vkZYg/nmo5GffOfnNKpkeD9p3qhDS/x8YhLLCunysN6b5ViOLyhkKNA4L8+Eme
 YZGDW/SC
 NWOxVJAPueFx74kea2X0+xscFofQmRyLUDfOC4f/gO8r/ggRZh2Eqtuzm9eW06RjpJw6GIsZHiNP7s7J+mw31pIoTtwhYSyFCZY1YovqG6bZ6hmPufw03imDOjJJX7DaUxY4fHATfs6OoPlhQssdDncjpsP1mjunyuBcECxrmi9Qn2XildwYUauER6teJSyXam7YIPwvDJNA4PijKchHmJQOAzRUlNCadWr/Y5+CMm9ny5R6jwkIrYydWZjGqOp+zxlHj9F2fay0y7FlyV6eZocZQOnlTVxMYlvxEywGvahjsV0T41BYbgjqJaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi David,

On Tue, Oct 27 2026, David Hildenbrand (Arm) wrote:

> shmem_file() only checks a file's backing mapping. That mapping can belong
> to another file, as with a Coda file backed by a tmpfs container after
> mmap(). It does not establish that file_inode(file) is a shmem inode.
>
> Seal handling and memfd preservation use this check before accessing
> shmem inode state, so they can access an inode of the wrong type.
>
> Add file_inode_is_shmem() to check the inode's file operations in both
> paths. This identifies regular shmem inodes, including those used by
> memfds and ordinary tmpfs files, independently of wrapper file operations.

Why not update shmem_file() to do this check instead? Having a
shmem_file() that might not always return the right result on a file
seems like a landmine.

For example, you missed check_memfd_seals() in udmabuf or
memfd_pin_folios() in gup. Plus, someone later down the line might use
shmem_file() without knowing this subtle problem, and we probably would
miss it in review.

For callers that only care about the mapping should then use
shmem_mapping(). Perhaps that would be collapse_file() but TBH I don't
really understand khugepaged all that much. All other callers of
shmem_file() seem to care about the actual inode.

>
> Fixes: c49fcfcda8b5 ("mm/shmem: update file sealing comments and file checking")
> Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
> Cc: stable@vger.kernel.org
> Reported-by: Chris Mason <mason@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  include/linux/shmem_fs.h | 6 ++++++
>  mm/memfd.c               | 8 +++++---
>  mm/memfd_luo.c           | 2 +-
>  mm/shmem.c               | 5 +++++
>  4 files changed, 17 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
> index a7c7a96a7cbf9..2ceca7993e4f5 100644
> --- a/include/linux/shmem_fs.h
> +++ b/include/linux/shmem_fs.h
> @@ -117,8 +117,14 @@ extern unsigned long shmem_get_unmapped_area(struct file *, unsigned long addr,
>  		unsigned long len, unsigned long pgoff, unsigned long flags);
>  extern int shmem_lock(struct file *file, int lock, struct ucounts *ucounts);
>  #ifdef CONFIG_SHMEM
> +bool file_inode_is_shmem(const struct inode *inode);
>  bool shmem_mapping(const struct address_space *mapping);
>  #else
> +static inline bool file_inode_is_shmem(const struct inode *inode)
> +{
> +	return false;
> +}
> +
>  static inline bool shmem_mapping(const struct address_space *mapping)
>  {
>  	return false;
> diff --git a/mm/memfd.c b/mm/memfd.c
> index 0f6fff004f5e4..7d2da23157003 100644
> --- a/mm/memfd.c
> +++ b/mm/memfd.c
> @@ -211,12 +211,14 @@ static int memfd_wait_for_pins(struct address_space *mapping)
>  
>  static unsigned int *memfd_file_seals_ptr(struct file *file)
>  {
> -	if (shmem_file(file))
> -		return &SHMEM_I(file_inode(file))->seals;
> +	struct inode *inode = file_inode(file);
> +
> +	if (file_inode_is_shmem(inode))
> +		return &SHMEM_I(inode)->seals;
>  
>  #ifdef CONFIG_HUGETLBFS
>  	if (is_file_hugepages(file))
> -		return &HUGETLBFS_I(file_inode(file))->seals;
> +		return &HUGETLBFS_I(inode)->seals;
>  #endif
>  
>  	return NULL;
> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> index 59de210bee5f9..c0811407ce397 100644
> --- a/mm/memfd_luo.c
> +++ b/mm/memfd_luo.c
> @@ -582,7 +582,7 @@ static bool memfd_luo_can_preserve(struct liveupdate_file_handler *handler,
>  {
>  	struct inode *inode = file_inode(file);
>  
> -	return shmem_file(file) && !inode->i_nlink;
> +	return file_inode_is_shmem(inode) && !inode->i_nlink;
>  }
>  
>  static unsigned long memfd_luo_get_id(struct file *file)
> diff --git a/mm/shmem.c b/mm/shmem.c
> index fadf23f9e21ed..0d41aac125df9 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -275,6 +275,11 @@ static const struct vm_operations_struct shmem_vm_ops;
>  static const struct vm_operations_struct shmem_anon_vm_ops;
>  static struct file_system_type shmem_fs_type;
>  
> +bool file_inode_is_shmem(const struct inode *inode)
> +{
> +	return inode->i_fop == &shmem_file_operations;
> +}
> +
>  bool shmem_mapping(const struct address_space *mapping)
>  {
>  	return mapping->a_ops == &shmem_aops;

-- 
Regards,
Pratyush Yadav

