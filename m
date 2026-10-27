Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E063E606A321
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 08:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TohUlqMB
Received: by kanga.kvack.org (Postfix)
	id ECBC46B060E; Tue, 27 Oct 2026 04:15:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA44A6B0611; Tue, 27 Oct 2026 04:15:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBA216B0613; Tue, 27 Oct 2026 04:15:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B54D26B060E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:15:32 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 52096A8629
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:15:32 +0000 (UTC)
X-FDA: 85367696904.21.0432C89
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id B948E180008
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:15:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TohUlqMB;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793088930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5kxHiEVY3AkdeOmkiyMicYxXOYN4StpWVAs8/ArHz0o=;
	b=XBcM0VRbdLFJuUWwMJqQPwPFgidL5binm4LY+sc+XhAOFnSbizvUhXpPVlCYVDL9vbZtJO
	208BwmTvmFSilk0SkT5VIyal7xQ/Fqemt+/5jGDfWOJYmZ89CW/sJmLl4QUn1+Yinhb8b/
	5weX4ySDVYyECoUVPrcYCYApQsGsECY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TohUlqMB;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793088930;
	b=adXQ7r1YZ/MIVscG3vDrWNEk1Du488Z6NHPzDaQbUMB2c3PRzdgNL6mX5afZZC5kjJCCuv
	/ja9EJheteEyadkgWSw85lmAIzMe8CDi7XOi+6+RmAvzFNelNVOLgTXz4NLzDyrVRKoPcz
	g/wxw3BZzYaYEnJomYLc3gs1tvJ0k4I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EB7F9601F0;
	Tue, 27 Oct 2026 08:15:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC241F01825;
	Tue, 27 Oct 2026 08:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793088929;
	bh=5kxHiEVY3AkdeOmkiyMicYxXOYN4StpWVAs8/ArHz0o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TohUlqMBXvTV6SqJFuiC+dqJjW/ij05cgrKtKEOfYxV88J5WLixwsYKmPfpSGBA2B
	 C+OmR9z5ZQPvnP70HVJyU7RC/CroJIV4UeBShTJu8eqdqUxUaoqOarZFm1dzPQXqFd
	 9tm6W7ZBJjPSXKIvNDqJIqzVvCngxMhyCkgQuyeGljrVxcZZ6+6MOELxqy231soY3X
	 GqAKIoz4S+Xnh6OouG5YutTdPxrxAOYEgd5VJ3AkybBIYVwdQ4Zz9O/MVH8vdiCTjr
	 p4b/83kRK763X0IwAQe+MCH3KJ3GHP5MK8a903LLNXFYeAbx5wprUZo5Jf2y+jOZpP
	 WoD4aFVO/XgLQ==
Date: Tue, 27 Oct 2026 10:15:07 +0200
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
	linux-cxl@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH 04/46] mm/memfd: make f_pos accesses atomic
Message-ID: <auBdixo2E9rqB_vN@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-4-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-4-6f74bec9a5bb@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B948E180008
X-Stat-Signature: ku1nn6huc9ijfsq47md4b7raox5horwk
X-Rspam-User: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793088930-68679
X-HE-Meta: U2FsdGVkX19ROIDkIRtZEed+l6DhXZBjfcVMYvruU5fejNfdXsu8quuwBr4FNIHJTaB2jYx3370ByeU3arTaAeB70krGJV2+bsSRPMAcR54HFOk1hl/R73PrtvlGF4BXnYAdcQx+3wiNMBugLdAPAHHa6DVVbj8S0AxFOB9V+7iKSsB7f48whEawnxhOSwqxrkn1cl5Ugpl57HXDimcufAWpGeJWUqsbMwrxKYLM9Rs/+QjbHiwWPk7mlZMilRcbkIwSPiinM5OKXduWgj9R1rebfjMI5ehgVJCabN9+gLO+nJrnCaY/vT85kKKiIIPtklB3KO9s+fFqUr/V4Ib8f9SXt9k0G48Ghfecjw2vGHRpRhBONJ8dgt3UZddtpgs1r64stZiGpEvt3hx89sigpXl1h8TiQoLCBVWBAlS+tDe+cJtVI99SZWQR43V7ShJsey0UGdavN89LDvq5YSWrKUs5mE2CphBl5Jps9ZdjVvkBIaZ0FdEHJqttIFPL9xpFLbyrRYa2Lc0ZmXPsSs+VIrVOa40EIR5R45OQmDZ/eGimaty4Y0TGufhVL75HamMibXkSZ5Apq2XQJo3uvNnwQgT73cm1sJN/zA5ExVHgzyaXRKc29fyDLMDY2G2yLxIMlJO7s2UuR8hK3EYbPQbCSDa1vPTuHLGGUoTWhKxrC53LmN2TCVJM0jaUzind2j/GXc6jED33G5mfGqLnbJ2xwDJF+NsAMO2vO6fWR5Pkk3k79A1Bq4c8hoFHd2YcXsKB+BHs9f06XaMZ4uhmR5XS9quLSuKQZri4APclWVxIY4mxVftW4N712QUMrnMqEw4zIPlONmG5HsMEo5nMw/O1rPyCOHOWT0M/XoU5U+P6WW2ndXYjOiqAmG4JDXdx8wQ85DiikpQnLjrgrW8lPTmH99vHd76mL9rQiHYESgT71n9zCVKeqncYykg+xLrk1WoUJKreYshvmmWao5g10h7
 2JsLstIV
 la+L3QQE8sANX/dspj82mQJ3LV9wvmQ9rA4vG2tfo8s3LIICSCkd/YRjxkbK6LxvVTj5RWEvgTdl+57Zsa9ktOESWjdMDGixPcAy6TH66WEFJ3k/6K+J2uNzgpzCdbEIvYuXTMj0shjakHPYpuELyuf2sek1MSnDOCr4W2RtwnciY68v63+kq/EgtyEL8zoCXb5r+/aPAm7uXlgS9h29RV5B2w6Yb5azK3Dg+4IeJ4O8tnj6EiRDtsqS6/TlEghfvdIVYDQl2S0ozt20cyFDs7LemGRAHWCV1kp8wbBVu2IfKQQBrX8P1lMLMyQzgq/PgFX2C/fe+delYZfnPn0cj9dbsZ5QLofmx7O4QbnuHrv/hwBhRRb3f2cjdBKWbv8qUUt9LAySjrxNjuVV1Wq8o49PpfN6UbuQFFfob79kUWNve1+LQbncjvBF9Mj/gg2U+KHBfDUgBLt089SA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:17:24AM +0100, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> Commit 9c225f2655e3 ("vfs: atomic f_pos accesses as per POSIX") made
> read(), write() and lseek() on a shared open file description of a regular
> file serialize on ->f_pos_lock.  The flag that asks for it,
> FMODE_ATOMIC_POS, is set in do_dentry_open().  A memfd is a regular file
> too, but its struct file comes from alloc_file_pseudo() and never passes
> through do_dentry_open(), so it does not get the flag:
> 
>   CPU0                                CPU1
>   write(memfd, "a", 1)                write(memfd, "b", 1)
>     pos = file->f_pos  (= 0)
>                                         pos = file->f_pos  (= 0)
>     vfs_write(..., &pos)
>                                         vfs_write(..., &pos)
>     file->f_pos = pos  (= 1)
>                                         file->f_pos = pos  (= 1)
> 
> One of the two bytes is overwritten.  Two threads writing 100000 bytes
> each, one at a time, to a memfd end up with a file that is far shorter than
> 200000 bytes, while the same program on a tmpfs file never loses a byte.
> 
> Set the flag when the memfd is created.  As for any other regular file the
> lock is only taken if the file is reachable in more than one way, and
> nothing a memfd does in read or write waits for another operation on the
> same file.  This cannot be done for all alloc_file_pseudo() files: anon
> inode files such as eventfd are S_IFREG as well, and a blocked read holding
> ->f_pos_lock would lock out the write that is supposed to wake it.
> 
> Fix generated by an LLM and sent by Josef Bacik in private.
> 
> Fixes: 9183df25fe7b ("shm: add memfd_create() syscall")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ david: minor description tweaks ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/memfd.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/memfd.c b/mm/memfd.c
> index 7d2da23157003..6f5fbce74f21e 100644
> --- a/mm/memfd.c
> +++ b/mm/memfd.c
> @@ -484,6 +484,8 @@ struct file *memfd_alloc_file(const char *name, unsigned int flags)
>  	}
>  
>  	file->f_mode |= FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE;
> +	/* a regular file like any other: POSIX.1-2008/SUSv4 Section XSI 2.9.7 */
> +	file->f_mode |= FMODE_ATOMIC_POS;
>  	file->f_flags |= O_LARGEFILE;
>  
>  	if (flags & MFD_NOEXEC_SEAL) {
> 
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

