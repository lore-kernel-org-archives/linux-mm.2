Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF523606A32F
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 09:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BwGgpGq/
Received: by kanga.kvack.org (Postfix)
	id AEE1B6B05E8; Thu, 19 Nov 2026 04:19:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC51A6B05E9; Thu, 19 Nov 2026 04:19:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A019F6B05EA; Thu, 19 Nov 2026 04:19:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C34A6B05E8
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 04:19:58 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 124E3409D1
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 09:19:58 +0000 (UTC)
X-FDA: 85451321676.02.F9E81D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6E87B1C0005
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 09:19:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BwGgpGq/";
	spf=pass (imf21.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795079996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9F+PqeTKayL2InwlVERF9AhfXlGn4mSe033kr4lKz1o=;
	b=pLOA9TShkbV2lz9s0gaPIuFWNMPFPTC4PIz99a6RoJXqKmfoDAH8NtYX986p69GiZkhA6R
	EUTltNGuOTeaYoMgq2C0UVRTKqut1DHPwmWUOQlLHlF/GWz0S/jNeOP6X93vmz/HcpMAur
	hfTt/Eje3C1L605YgcEqyOWlpBTjG7w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795079996;
	b=R8AYKzFUIijqnJx8isMzffW3yAvrMWE3lCZLgTxSljzN2jfLOh395VqirwYfO8pkr9cxnl
	BHcm8jb/vCCzdlE5aMIEcFhuIb1Oe5tdWFIJu0MaFGlN7JfPhvWaFzRzsr3e/4fhkguvka
	xTYVw1IiaUhnAklRfAwcHTBKS1qRQFw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BwGgpGq/";
	spf=pass (imf21.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E493561D97;
	Thu, 19 Nov 2026 09:19:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 404C31F000CC;
	Thu, 19 Nov 2026 09:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795079995;
	bh=9F+PqeTKayL2InwlVERF9AhfXlGn4mSe033kr4lKz1o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BwGgpGq/s8LdaixY6UA2dpl6cyOlv1U26xLUHK3qsAmF6KXzFhdJnAytG8CXWrQBM
	 XVeINsUMo6TefJjonhgO+dU2JDcGut71ZynTXwmmsacy26fqvKspQwAEe3pW9YxRYb
	 SRVUpuAwBCNykQtoTyrgySODnUAnTtj+r6Z7KtbXyKiUSyXpa3s+UnhtCFOL6mULIv
	 zw1B6CY2f91QpZTQOHg4aiwKYj5x1Ad1onk/4u3eM/C9w5Up2vCqXyTIjYc9NeP5b3
	 YxNFrYfFFPs6Iajczpo3yenRQC+cX3+gHptB5mKZSBkRA8zyHVly+82sPqdzFKldFy
	 gy+890bIbmpJA==
Date: Thu, 19 Nov 2026 10:19:43 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mel Gorman <mgorman@suse.de>, Andy Whitcroft <apw@canonical.com>,
	Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>,
	Rik van Riel <riel@surriel.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Dave Airlie <airlied@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, Peter Xu <peterx@redhat.com>,
	Breno Leitao <leitao@debian.org>, Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Gerd Hoffmann <kraxel@redhat.com>, linux-doc@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-s390@vger.kernel.org,
	Chris Mason <mason@kernel.org>, stable@kernel.org,
	"Gregory Price (Meta)" <gourry@gourry.net>
Subject: Re: [PATCH v2 11/15] hugetlbfs: do not grow a sealed file in mmap()
Message-ID: <av6_L080RpmFYham@localhost.localdomain>
References: <20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org>
 <20261116-fixes_hugetlb-v2-11-4dd9e94ea9ac@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116-fixes_hugetlb-v2-11-4dd9e94ea9ac@kernel.org>
X-Stat-Signature: ppxgriqusucget59k9uy6du4imir9xat
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E87B1C0005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1795079996-608036
X-HE-Meta: U2FsdGVkX1+WmQFMbpSFxJgmlUHf9QUTozicY+HP8daJBHCxkk5COgYNzmJsFtZ6j9GZEF0SqadeRVzJjWnmxoa9Qza0FlRedLPlE6LOo+OH1tO8xV4RmZOi5SBg/xOkYPAgT+kZpsdaBhbU1W5j89LpC3vK9/umc6V9SUZvozunG4w5g9DkxNbkLZfMX9CNx8UOqDSNK4QNyg/mG0dInbmQqRAmzcRwZqXZr3Sgrt5P2vkmW/ifFvPW6UQbQVS6+n9zCQpEP42B0fsixpH5oNSevXZYlmq6Y5IngSs+7rzMjprM54o/2BbtFm+2MJ51XJhoa2jQDLwIthTEDd3bIrvw41rdLz7ZlsAS6VhEo3e5UYH74IOraf7aAh6iBNLj8Fkpz/cv7oneNVP/CPIWIDypJquByybqeWNSrBUW4DGHmrCpLcm9/TlkLxTFbSaYGTP1pEhzdKBTKwq61GAMDOMWkU3OcdPYv8fOzU83ah9nZzrcxr9YB5JdcjIRpzk5c5ASykddp4MA+yCdYnPBJYi0k8Pkl4qd+I4c6qHWy9R7CVy9LgWAgO+8Xb2wMqptnPlfwKEFI1JOFCQbq7nDqHFQgrRLNq7IBkliIEexo/pQuXqi37Q3q4T1+Zr4u47RObQQpEUzhV7vTWPrcuP+8IS+6rcokg1Qit3TNo5AH6/jNQGCXzzUg5f6BDNYHbnukwmGvJlHDBVqA+ikDNgWtuhzlixUNVbtvgDEcWAVsrhYKM97fMn8NmNaDpA4w/Pqg/D+yoirvGTsj7rX53b9SbLsKxX1s9rA5ZDA+IJaTSA8FfJ1DFrTs36Zj/06b/e4ooCggURrUn8NTW3ZXIYlTY2CFjCHntcSjvpNMilAQy1C7eD53ifEo6/HeFvY6fJnMKCYGPfKzfWEQUZYRCcz4l06Fk8xMj15Esld9MpTbepiyYH5LRkkpJaBE3UpTlRFE9bEDqMbrhEcLv5h237
 AyC00edY
 lpP1HFgdlKuybZ5uC2BT7lQBDVcKf7YmCYSW08EabiVE6tEOeQ5LTomb4paFGsh/am8X6cLQGtBkgg/XCeXZWVLnD1w7ecFGrLDyJD8kvnBVAqy1206i7SojnWYjGrTEV8SxoDNDQgSgCd7jOzoXEsNbtHLTBTwl8utYa5jImj9BCOGk0aQPyaOCfvUqD16Qc2QZ9hWo+9p+S78/LKy8GFYzv6oAmR/pmXmLadQVsMZDq+0SjHU/k11MIlgYPEXOtO/MctnfQvXzqU+csiIOH2VEMP2ZbgUC7eo5MTGY4QLsdXNv8VtXL7xRpGWQZQCKvbB0wbwSGUGhIRWmse8GvIFeRJ4G5tCuE1el3EFOHXAF0cHfFnFzNEI1cHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 07:29:32PM +0100, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> hugetlbfs_file_mmap() grows a file when a writable mapping extends beyond
> EOF. We are missing seal checks similar to hugetlbfs_setattr() and
> hugetlbfs_fallocate(), allowing a user to grow a file that has F_SEAL_GROW
> set.
> 
> To fix it, skip the resize when F_SEAL_GROW is set; mmap() still succeeds
> without growing the file.
> 
> We currently also allow CoW mappings to grow a file. Disallowing this,
> maybe even only for read-only file descriptors, could break existing
> userspace, so we have to be more careful. QEMU's file backend is an
> example user that might rely on such things, and would suddenly start
> getting SIGBUS when faulting in memory outside EOF.
> 
> So be careful and focus on F_SEAL_GROW for now.
> 
> Fix generated by an LLM and sent by Chris Mason in private.
> 
> Fixes: ff62a3421044 ("hugetlb: implement memfd sealing")
> Cc: stable@kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: drop comment; simplify+extend description ]
> Acked-by: Muchun Song <muchun.song@linux.dev>
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

> ---
>  fs/hugetlbfs/inode.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 7f64bdc07aa80..68761e1ed4d2e 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -157,7 +157,8 @@ static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
>  		goto out;
>  
>  	ret = 0;
> -	if (vma_test(vma, VMA_WRITE_BIT) && inode->i_size < len)
> +	if (vma_test(vma, VMA_WRITE_BIT) && inode->i_size < len &&
> +	    !(HUGETLBFS_I(inode)->seals & F_SEAL_GROW))
>  		i_size_write(inode, len);
>  out:
>  	inode_unlock(inode);
> 
> -- 
> 2.56.1
> 

-- 
Oscar Salvador
SUSE Labs

