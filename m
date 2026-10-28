Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E58F606A33F
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 16:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=S/O6Vth8
Received: by kanga.kvack.org (Postfix)
	id 9D1A56B05B4; Wed, 28 Oct 2026 12:54:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A8AA6B05B5; Wed, 28 Oct 2026 12:54:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 897D06B05B6; Wed, 28 Oct 2026 12:54:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 63F2C6B05B4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:54:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 21461160183
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:53:59 +0000 (UTC)
X-FDA: 85372632198.09.A759CD1
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	by imf01.hostedemail.com (Postfix) with ESMTP id 35F514000B
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:53:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="S/O6Vth8";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793206437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jQ5eyf1zl1dztY8G8GNDjIbe5i6XtlGMZ8AEehh0sP8=;
	b=yxDsQ/MCvYx8LGplY6g/NmSWjLF11F1SoKfYIi37I8M0R0BYuaRY0TpX0iclXOHha1gCS1
	0cfS0ykpBaMGaPg+1oHO4dcDs8NC0v41PsJcw0mJjVmO39yATVyeRZO1MYKXF+0wt5FAEw
	hvAcHuW2EvhryydaOBTI9RGU0uJJ5vw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="S/O6Vth8";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793206437;
	b=vEdYlwUQ2hq8+ZWvBSBhDZfjLb5nLxH6+PDtdoTQL+mxQffJrx0iAvojHbqRIUTJeMUKK8
	/MGe1ZfcRrUnMA4eCJTt2mxbTKS682R56Y663RPlsLcteC/1/UfjyVrx6VKJMpGHBJO8QY
	I5lnBEFc69vqRACbjCoEPBAhsmzUpOM=
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-7cbbb7b90efso359490137.2
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793206436; x=1793811236; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jQ5eyf1zl1dztY8G8GNDjIbe5i6XtlGMZ8AEehh0sP8=;
        b=S/O6Vth802Y7hFCdGfY0B2OTHh7EBmvxHTvvW1yp/imv1PQ7Mq09yEy1daqPGKnQQR
         BVght5AAS/G4bQgiP2pXERzVXSjwTsVKqfGAUtRotp7orXwZc6HLBM0YQHvMMhNTyHGc
         QDfaEcGWRHJPuWZzxMsENNvEGviERgiLvn7Rafhb0l020nHYQWS+nYL6zaALI+v3x7FS
         Ej/hsgj6vcLexq3XK50dWWTLfMLWiuGCC3J1HVjPCn0mjEHx1OXCxJOZCYBjUfuCX/2t
         0U5qcG8dK8wDQNWL5Ag7IZYcKDiYIY3qJ2OxDam32RMQ+Y0xAZLDlEczq0X5z9Z3wnbt
         ht8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793206436; x=1793811236;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jQ5eyf1zl1dztY8G8GNDjIbe5i6XtlGMZ8AEehh0sP8=;
        b=lAIwUqYC8Famz9RE/6CUNsqb/smU6jfLLkym1TvRZZ3ICMxCg16nzuCCFbV2IFk5kz
         7AXqMXBh7EgbRAXB4qJuuQb3SduPC1/ee6nn0xbuByX4+rErvJFy84SzkfIKk1YSAuU0
         Rv67JakxQxqICshuc9pVXC7ZiWD+Xmz10s/h+w6kjz6OLCEs5HN+J22AEmck7Q3rMusi
         3gZw+hR1QqN6aW6yfOTKAYsymcATweXjGM5zimYr6lG0BJ33VxTSMHQgfjlrmtcRLvhJ
         VAoDsAyTbPP0i+jdwB2ZqSG1jT12PaHclCOT2quHXOUK9kH/7Y/1T5tVFmpScPgzAWUJ
         t9zQ==
X-Forwarded-Encrypted: i=1; AKwUvByKSgdHW/DINKIv/pfsgzb3VEuSBhNW71QB8VhkeBmlF/c5vupWQM0k8cwyusw4iRAqc/+QHAkhpA==@kvack.org
X-Gm-Message-State: AFq9FYI46IZhzAZCoJH85FR2S49ymJ8sGP1+M5jNl+igHkpwFTnb8f+W
	vHw9q5DcO6eKYEXngz2RaUPxOSGwUuzXD0BdXhwZKDYlNBSwBK45iXWK7DhvOuUTBLM=
X-Gm-Gg: AYBFou0SGJtzyXjmoDMH1jj5qT8KEvHQ21nqt42SnBAPrm1Ukx0m3siC0YRT3OSPJ4K
	qGEBl4ivUOCPFPGIj1vs1ciApbHMgdF2aic3RFUASB9DeLPYUpG/rHhWWLaR+mOnB8h/n0mzPSN
	S4cpSK0obR0lT1EBG+/RhCyI/R+MzRCXz1wcGveOzoIyKJawJZ/U0VfUF/1ChswHz2UONLbxVll
	mVS+sE5ncw37UsdXBsKv7suKuGNEfPt8r0uH0+wJNgXrkDWaYfA7/v97jkQn2ftyaBH5gj82F70
	xBJQeGbw3qWEVM/BglWU1K9DRBOe1GLBG+HPOxmJpXoifwkvi9R4P23JSAQtyTPz/Isbl0bf62s
	LqHfaY4IOH8Qz4zWI89moJmsCP9dIDQbgS9Qcgqsi/CglzpcM5L8kZT/mS2zTQA316Qi/pNueBa
	wUCl6iLc/1xxIk1D7z7rCqTPpdVGOEReNjDhwaHZDBHec59BlPg9yJot04QDDWbYmCgycL6IX7U
	xlFY86yol08ScRiv1VgMCggd4fZxUBEGHt8J3wwTPBkDVi4Jx+YVlPHoPeIwC72sQltO6Bl23iI
	tQkt24h80dXqSAtFynnIWKSHVdvlmsyQadiprMxX+cmHoEtMhwzC8p1AzKoPmdqYXk6MooTrZsh
	E9Kz0vBFyWJQTiXll1h+ZCcNpPDd7oQ==
X-Received: by 2002:a05:6102:3e8d:b0:7cb:bb33:8412 with SMTP id ada2fe7eead31-7d03a5063b4mr1453208137.10.1793206435862;
        Wed, 28 Oct 2026 09:53:55 -0700 (PDT)
Received: from google.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-991259db2d3sm6495987241.6.2026.10.28.09.53.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 09:53:54 -0700 (PDT)
Date: Wed, 28 Oct 2026 12:53:47 -0400
From: Pasha Tatashin <pasha.tatashin@soleen.com>
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
	Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Minchan Kim <minchan@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, stable@vger.kernel.org, 
	Chris Mason <mason@kernel.org>
Subject: Re: [PATCH 03/46] mm/memfd: check for real shmem inodes before
 accessing shmem state
Message-ID: <auIoDgHmzpGH6cOl@google.com>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-3-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-3-6f74bec9a5bb@kernel.org>
X-Rspamd-Queue-Id: 35F514000B
X-Stat-Signature: 9wuojdpbgwwzijs3qp6k831w69ixqs5k
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793206437-711822
X-HE-Meta: U2FsdGVkX1/OaVzd9kq7dI2WRssf1X2c7uoMOSVWEarcCClrh/eru2UZ7Pf8BXi9t4RFdWgbE8sEv0sKcte16mi4SxnBMUWeBZRAqTw4wWHAJJwCBZiqHSTW735ePspPueQe+rqWuR1SNThovdWTRp9G1Ev17QxbqctYUq26flJPc31OCEBnwEOQlyvgAYsRteEHfjisu79Rql96HPiWtdvuszynFBbAo770foR7UU6goORutnA65jICVLsoFK2r36YpSg8kt/kasA1oZkmDQFMCw0rMu/ZE6pbnidL+JEV+M3+w9mANAepc0xxhN3tReisvyj/6GtgVby9EwzR0OCukCS+8Q5+ZzuJTL4/vHLu/1wNki1DEaoX1/kRku7+FyDQ8sy/rmSv7jYx5X65gfDFNw52ax+RyZEK9fwqb90w1jQ581QSWvMih06kRjVzatPdvNR9c75pJIFj9pFFNfemuGjHKLrDa1IsyyEDaLUKywVE5BG5T9HShQFqAYyKP7X5pZnf5WTuWTpDbkQOXOymcfGzEHY7rcXPIKoGihI4cCUrcyFGuvF7N58Ummqm2akeNZnAzx2yHAEmyCc5TcUBHGU7hMKpG8QaBd4DrVTVEyZ+0Jbop15SwvHFoLx8PhZnEnWqM4jTyXeoSRryPzvL856MBfUaNNE7DNIYR108L9ir8imWccp6S3oUt5QFaX9duLI/wcOzg5qFB3DnG+d55SfTtdurL1IbXgSTNixZjeef9YFq9GOp0MBeLPCbeSJDWAvCsT1EOlP5omU70ytbph0vLKYKYnuYSw2y6d+Z3r0mn4wUeB+shjfaI3FNI4gr5AxjkXaqXO6WBPWOTOCZoKpxV8Ki1Pwo7fR1rlMEvXVhT8ZGfGXiszgoLwb/xRC93l3IOvctWqZ3+iNAhKZclWfRqJIV+Fhw4Zf7iHa3FtBF0dm8Scqa+pX0iQqcKM7vrWiUhNTz3HGWV5el
 EPnWXsO9
 55xmhX4bzvCJx+RcDKcgkznK2fVPl5YhiRsAm0yES5ShnXiOjQqSaPSlW4Wb25olg0cK4serXhvszICLI6J5pWJrfxfVIBuAyCaq2XDqZgYvXNOAMR3fBB/njBDfUX50sxmW6r7uffAwJnZT41hVYYCsrsU6IgZaPqMShT8Nx0H8xyVHUgoV3RvNvsLgFNXgT1+QWQ3tpZy4HoMeb7r0uMqIxySm/RoA66lREyps0oI6NvI2n7QQY6IMDuYO3ZgivBFdl3Xg4pdw8P61TzXcTpcL5v1Ja8FP5ZsK3eK803QTIoNy/nceyoouZDhlX+NfWXJgDBaKTSemniJ8u0E+ex7xeWQquwoAZoxm2+aOkIN7Y9unCvGLQapFEXg7sPgocShvrz2aleHeAtZGebKdOUjlMTpmm8L3HI7AJpk+zg8EbiCmcsb+a1Z32oNOfhqZ0XHQGol15inyj5OqWv3E5TTKaKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10-27 00:17, David Hildenbrand (Arm) wrote:
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

Yeah, file_ is not needed, otherwise:
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com> 

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
> 
> -- 
> 2.43.0
> 

