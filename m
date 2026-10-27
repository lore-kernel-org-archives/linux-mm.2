Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE8B4606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O/cT7rN4
Received: by kanga.kvack.org (Postfix)
	id D695B6B074D; Tue, 27 Oct 2026 09:43:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D41C66B074F; Tue, 27 Oct 2026 09:43:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0A096B0750; Tue, 27 Oct 2026 09:43:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F9896B074D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:43:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 278EA809C8
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:43:01 +0000 (UTC)
X-FDA: 85368522162.14.25D6F41
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 43EB614000D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:42:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="O/cT7rN4";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793108579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0+f6IJooHiQbF9wAyC4ax/+y1Gmk+/E4quNL5EJAkoQ=;
	b=UBfnmlDdRAyd/VHAIWuqYmb2dZjuCRghh6n0uXXwnWq1kbxDIqElsxEcwnM5rWNYcldzne
	VkWY1NGQkrDORa5VVgPRK0YxRRJDIJVQNTwIffRCwcVmMuKDvO546nWuoIIViy/yxTE7gD
	xCu9uFCxYzR+iAt36X5vdfTfIShk75Y=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="O/cT7rN4";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793108579;
	b=v0JC3B7rZKyLfGRFNxfJnv0aNCp20PRTtMSo2WNIfp72Ymfbyip/PjoSrQX+IzdnK4fUfs
	SkhGgN9K3FfeGptNe6y5bTIpGBZjViq2B5Dnbj5HXjCRIWCh82N3Mx9fBtPfFboCJR6jdb
	vAnquZ6b06jOB1CTj06Sx8ZYO1NufRU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5545643510;
	Tue, 27 Oct 2026 13:42:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234691F01825;
	Tue, 27 Oct 2026 13:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793108578;
	bh=0+f6IJooHiQbF9wAyC4ax/+y1Gmk+/E4quNL5EJAkoQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=O/cT7rN4J4QJA9+qKjooI/EO5er0turCIeVkTDeBg9nmgtchbI+fpxO9S6+r+oBWY
	 LwmatZaw1QbMHP8ScOJ6R+l2fGSrhmt7f6UUvC43uiHkIJGDGGCW0OQjZcEIUQEPa2
	 w142oOqbY6kYvnslUnzMN4PB88SswCTWpes66yGol6fQLmBbkQaxbQK69GdBHy5hRV
	 glBMz2eRymovbjCzKL0DCgcuiVWEYF4wIngi0eCG9PplngO81D5jwjFqaadaqIhz3C
	 3l+I0Do+I4H43SEQfhyQdeFO3NHr7grqnLgvsjGY/hUxovAgKOJx9ptbOi6w43lJzE
	 qaE/Jiu8PIH2w==
Message-ID: <38491041-d167-4ea1-8813-e75bd11cd10f@kernel.org>
Date: Tue, 27 Oct 2026 14:42:38 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/46] mm/memfd: check for real shmem inodes before
 accessing shmem state
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Kees Cook <kees@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Hugh Dickins <hughd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>,
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-cxl@vger.kernel.org, stable@vger.kernel.org,
 Chris Mason <mason@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-3-6f74bec9a5bb@kernel.org>
 <auBdPOKXJpE-lX8d@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <auBdPOKXJpE-lX8d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 43EB614000D
X-Rspam-User: 
X-Stat-Signature: ummpckmus8ajqm1i6q86efr5n134xkb3
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793108579-310834
X-HE-Meta: U2FsdGVkX18MSF4zKOa1Pr3H+QMb0FlvLgc0C5qQgVKagdfANCL4Ti9OmcqOj8R6HGaUo5sWht2HfBw3aUg8Ha6xzBvB4cg/pKx/YGNrqeSkRnIRnA6lgqTpNENvCn/ZZX2QfYfYpsEYHrP9AJtTRqN5Wbt3oF4AySf4VM6QmpODMr+Rcsa+x2GXuQ7jh0JC8M5WsrSNllEcPRHMKqHGHaFScWx7RCu1ejQ4qmh21QOB8aI3+9Fy5gclNs6KdcCIlUnaHJYOIT8sFCrFUQagM21kBfOBDiO3l4KWgZb9fTQ7VJyH+5YoPGzigJH+OZ8a+gTKi2bTZ8tPFt+ZXf5mhWRUNFOvpoBkjQ0o2cFIXzZmu9h1q7l8SIwp6ZuRf7HJWBEKH1IKFiFEKDjQzWoCcFYb9rw0MJuWRKZwL0D2qmQt1TZb5ZD/V68H5oTRcT3PN0VtBBHRc+bXcX5wji9H4Hovr6Spx2y667mmEY88Zg2aVigyn/d4+z6a67CtnxrV17EB72lEFhdGHy3j8fnWg8XCv0fQfSNDXv9Iwz0AJOhbNu7f53WaZw13cgaXwafXiCukFFC3Ns1VrKU+ck/aif+4qSIHiY2Aplfn7I9pgWF7jRNxbCl4s4JkRUuKiOtyyGvXCWSZXDsI97sNvYHAGq1t8IOnL7S1qTxKjpnspawVKJOwRlbv1iKlsdOFEoTtMEHG3PGIaZ/KWzVE7Zuv/ElRDbLTVBnYD59+zwuKZL4FiCi6AkAstPsg6YtKtFrMbICtH6h8o0PLVCN6RMscI9zEMWIKPv0LhQsa17BJQYDSzXg5ahfVSJzx6i5QQqotyDtqJj9DWpJT7uoQU3AUsCFLA2wrZzwrsv98giB1CggcZxCTSHbV1DsEviSO49rHahtjX1yX0CiH6ur81YSZXIlvoaI/kG7gn5QNPrCQJRHGFGwWwE9CE40lW0u8s2R9xxsVA5oMt467c2kpTCH
 X2JTyT59
 B17Ee/NKiYqc2SbmiJuCuAGxlsARmfUPrTrTxzR9lRBui72GEFlikzMx/xnhPSf1lLEhHN/lSnq1szpZdJ95KrX7WkkEB2rclsQITaYTMo3KROjBK2YlWYmjZXbjXP/VBM8mLtPk81MOGQ3G6ugI8t7S5WecfsxkTENTUl0YLFnzmua2Sd3BWt59VRnTCE/3sXSqtxIbu1dDyRBLL4vfl9xPOJnHe/PPpPFm4EzP4hABSnaoQyG6vhC0S9y+Yjn6iEIVx/apWiP4Pgj6TPYFzrRS1PeTZfSUcj8dp9gu/TbZM73k0zhN7XeAYwJ6JQXM91hzLQAqoFbibygpUlbG4u6jKxerswEWl0zJ2UE+bh3D9O2I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 09:13, Mike Rapoport wrote:
> On Tue, Oct 27, 2026 at 12:17:23AM +0100, David Hildenbrand (Arm) wrote:
>> shmem_file() only checks a file's backing mapping. That mapping can belong
>> to another file, as with a Coda file backed by a tmpfs container after
>> mmap(). It does not establish that file_inode(file) is a shmem inode.
>>
>> Seal handling and memfd preservation use this check before accessing
>> shmem inode state, so they can access an inode of the wrong type.
>>
>> Add file_inode_is_shmem() to check the inode's file operations in both
>> paths. This identifies regular shmem inodes, including those used by
>> memfds and ordinary tmpfs files, independently of wrapper file operations.
>>
>> Fixes: c49fcfcda8b5 ("mm/shmem: update file sealing comments and file checking")
>> Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
>> Cc: stable@vger.kernel.org
>> Reported-by: Chris Mason <mason@kernel.org>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> With a small nit below
> 
>> ---
>>  include/linux/shmem_fs.h | 6 ++++++
>>  mm/memfd.c               | 8 +++++---
>>  mm/memfd_luo.c           | 2 +-
>>  mm/shmem.c               | 5 +++++
>>  4 files changed, 17 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
>> index a7c7a96a7cbf9..2ceca7993e4f5 100644
>> --- a/include/linux/shmem_fs.h
>> +++ b/include/linux/shmem_fs.h
>> @@ -117,8 +117,14 @@ extern unsigned long shmem_get_unmapped_area(struct file *, unsigned long addr,
>>  		unsigned long len, unsigned long pgoff, unsigned long flags);
>>  extern int shmem_lock(struct file *file, int lock, struct ucounts *ucounts);
>>  #ifdef CONFIG_SHMEM
>> +bool file_inode_is_shmem(const struct inode *inode);
> 
> Do we really need the file_ prefix in this name?

Good point, I intuitively added it. Can drop.

Thanks!

-- 
Cheers,

David

