Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F4CD606A328
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 08:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J/USOVMi
Received: by kanga.kvack.org (Postfix)
	id D42286B060F; Tue, 27 Oct 2026 04:14:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D19FD6B0611; Tue, 27 Oct 2026 04:14:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C32FB6B0612; Tue, 27 Oct 2026 04:14:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9C4FB6B060F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:14:15 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2C45840692
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:14:15 +0000 (UTC)
X-FDA: 85367693670.03.5DE9E4A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3A2E120008
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:14:14 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="J/USOVMi";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793088853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X817yPMZ1OWa0GxllLA7n65tTL4HKJjURd5YVC5upNo=;
	b=00jSb6YDorn4isx24DU4CO5Dl4iNEjyJaDCZA5yNK5RLZ72GeXW4gWHBQdMrJFftu6/tbr
	fp0oEA/Mx7sQY9kYBjD7gQmixYkkqpJGHyf1jTntVp2JnyaWW/TWvSbAnpUwT052k1x97b
	lVAyNqhUC/OguvknSXz+saQ+RI1GC+I=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="J/USOVMi";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793088853;
	b=vnO6ldYCoatLciBSPcGeUKqPSJvW3bDXRcsOCxa0Jiyhdb/Y88OuRoTv8i1m4dfUrtrXsT
	i/d+dOjAao79GGlUNpJfMvdGNMNdcBpBDMpUYL5gkcybzu3ZrbF3gFpgKTATnIc14xbdt6
	2MPOQjV2kMzn6rJmNfoCfrqLnPFdGzs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B2DA6421F3;
	Tue, 27 Oct 2026 08:14:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252CE1F01825;
	Tue, 27 Oct 2026 08:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793088852;
	bh=X817yPMZ1OWa0GxllLA7n65tTL4HKJjURd5YVC5upNo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=J/USOVMiZdHACMBPrC+zND6awTBbtGUCKpChcm6jDubxlHzRsgGJJ33u8eAyXrHmm
	 Dhgy64k1zoGSzetJ6uUKZtYgTjriJplQrDD5QgepgCioCGZAn0H/62PsYvRrAHq7MD
	 l6KQxPT3ek/jTP3ay9yQuCHmqyJ6vEXgWsvrHA/OVEIl8w0qY2qNXPJSzKqR527RVT
	 FfER0j6vK3yc1dfQ0wPeN924r3/nVS5+UFCB/hPBBJU9NfLcCTsCBk+HMbQu7cKkEk
	 Dk6dNn7PD/Yz5EgpKrvi4Sup3qa7fOHH3IAb+PJBxHnNh8DjdBkIMjNxtAjcJHzrHd
	 rlwjmVWf2kcCQ==
Date: Tue, 27 Oct 2026 10:13:48 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>,
	Lance Yang <lance.yang@linux.dev>, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>, Alistair Popple <apopple@nvidia.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>,
	Minchan Kim <minchan@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>,
	Gregory Price <gourry@gourry.net>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-cxl@vger.kernel.org, stable@vger.kernel.org,
	Chris Mason <mason@kernel.org>
Subject: Re: [PATCH 03/46] mm/memfd: check for real shmem inodes before
 accessing shmem state
Message-ID: <auBdPOKXJpE-lX8d@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-3-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-3-6f74bec9a5bb@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3A2E120008
X-Stat-Signature: 91jrut3ii3babh5yg6g11ajomfri9b4j
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793088854-533686
X-HE-Meta: U2FsdGVkX192dyqd7uAa7dC+kLegG3lH0cIFsyA5CB8Bw5VGdiI5pkROhjK7lEafd1kb1HZ3TNhsKHRZgjFbawNdG/S0AVM2YYN8fuCGmYrx5Y1XkRy1pvpyGi8aWcrRRoe8itWKLn/m3eSEiTANqfCV7lpXMJ3UG1q0p+FY/zgQVwO+W0UTMSe/XcLMZIJDS0Q/y9lQWUwjSbihKobEs87o/e2Aw5spvMvik2mikh5rdhNEnXBTa2M2YY9WlHTwAaNwspZo0DZ27LSm6E8R2Up5zStXeF4IG+itMIDfnjfZnEoam+Ip+9KhI/yeAk2d5QclITzSwweMwaasXPIsZTRn8pxqnruENZoQA0STlBHN4Srqffi5zK5kZyVJi+Wq/GYrIPSg03/ovnLJDpCJUbVHWMQEHdnNw+e5Xz/HeGlygJPjBKpuqfED+KO0ggT9MKpbHhancKBUMBbjYGO8W3OJ68wX9zJXzc7dFGh9+sSV12vcy3mXjednKFqDPzomE+o6C5wkqWgviWqGyGMmPtZAMRF0Aw2Y8kXCbNJSmWUWZwLatbKfF7Uk84GLnpVeUaFuI2VdAu63xXxEWZk6H0gQhXsCjBG8mWuQpy3N3KRpneZ7IZrm7krJw0ru/lJgE7+cCUl8zV78x14Xxcwx6PDdDnDbxxJooWYIOTLOPX64LtB9bZMBaYUuFCustAOlyvuRyRnMTjp17cMWmC9vb0IhCDK1M382uID2e5bXuj8ee6p4wN3HE2G4p4wY5sL4X4IE+isw64A7v7ck7xZXd9lJkVbPIFGsGp4J8TxdO5SkuNcjBYuX+AHCjZuy1jeasZOLFmvxTjanJPD+UUagrVzkIaggnHQHKVvEUHDGAMN1XAOVqUdCnSlzp6E/pahCDW7b20Qa6i9V+OemMTfQAhQWSuI/v8IHqM4pSd4vlRFHw97zb9H79sYuLLg3PAI5cNQ9LRxPZAk5en6V4Sz
 81go/Lvd
 2NA/FnWaclMBh2UOfBS9ddN1LtjCnZ6RCA/VPEy5y/01yKfqDCImC0YB0QNei14CWtRDLokOHPej3AArpsCvifEy5cMo1tzsc8QsbO+2jjWRwE5zl7uJbVGDJV0e3NqmS2BMYyaAFVvbO5fG8SO+lM+auEiSqI10ZCv2nUino8w/hJqtLdhV1zKlAIVRIRHeXFMmcNJUsCqIAk/PeBYHEgTJb/nYTc+dTO7srXZ/znx3hJO/Yup6l6IXqrBFDL1Cx3WKh22hjf05yqGHIq86QSdv9/ebBcvcqDV0DWCyNJP7enDOqMsSqMJrq77lkLMgxeRmDMPbLPxOpMzbspcmX0ztqWXisruvhv0qB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:17:23AM +0100, David Hildenbrand (Arm) wrote:
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

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

With a small nit below

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

Do we really need the file_ prefix in this name?

>  bool shmem_mapping(const struct address_space *mapping);

-- 
Sincerely yours,
Mike.

