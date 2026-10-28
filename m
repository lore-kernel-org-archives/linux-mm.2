Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E422606A337
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 16:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=Kb9gT7Jp
Received: by kanga.kvack.org (Postfix)
	id 3444C6B05B8; Wed, 28 Oct 2026 12:55:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31BD46B05B9; Wed, 28 Oct 2026 12:55:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 231B36B05BA; Wed, 28 Oct 2026 12:55:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E7DAF6B05B8
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:55:07 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E08C0A017C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:55:06 +0000 (UTC)
X-FDA: 85372635012.27.1D392CE
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	by imf14.hostedemail.com (Postfix) with ESMTP id 17945100003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:55:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Kb9gT7Jp;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793206505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PRHEIBcRVtOU9mxXH6oSTTLdGiFLeS2r2uPk2vm17iM=;
	b=qeyhoGLvUpbAOWWtClzRsvU2yhvvLr6v7NoT0aU8R8FbVGRMRTfQTnXr5OepXHqqggO4FS
	IcoBKPX53jE5snpbYXC+vaXvcNe7nw6SpcnM8Ih31mH1ceE9zigaKY/qAgPbvjo4Pd1nlZ
	r+WwtvBlCGTEsfraSuS4D6F4nYI+tfE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Kb9gT7Jp;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793206505;
	b=cdNZG+7j5mQW4RWwH9l62raWLC9rmUQHUywU+8sJv4lcjcO5dGmQXF0Zx5fdz0AY3MYIIc
	XFAtRwNycsWw/oX8LTwB3KhQ6DDuZe6+KFV6ZgJo+ag9esdUaU44PVdVdYiwNI8G8IbdA4
	H6ITveSfxiT0MNOoGnogWxyqGzJKaTY=
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-9905d61449cso427960241.0
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793206504; x=1793811304; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PRHEIBcRVtOU9mxXH6oSTTLdGiFLeS2r2uPk2vm17iM=;
        b=Kb9gT7Jp9ruFF+rWhZB2SHGEgbWCAeCJygoVPlXPCxkBocDhTqbvZzPB/fIw5Q3dND
         BQE1OpqBhKTnqN7tcBJAt5w+n3WznhozZP9dYYvpZchHZl6YcHqbqBFYaRgjGGPVp3CR
         CBCKn7pQlcjbvC7Ebe2QImfqDie6hEqD7hRvneNRKkUdCbcQV0qXAlhv/9dAHkkuitXm
         8zR6ZprL5p3tAlGs+6UGOx4SZGZ45FSnxP1sWTo+M+ZlD7OLXaXlwpCo1Zehln/ND6Do
         o6F8wwB0ONMJd7CczCJ4OPCVKE/BO58DaQHOriCoWov4/2l+kheXrrXZwEl/QLpYYo44
         uiGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793206504; x=1793811304;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PRHEIBcRVtOU9mxXH6oSTTLdGiFLeS2r2uPk2vm17iM=;
        b=uQTZP6w3RzZS0+eufCGS1350JjZqUAmMspH6LpVrgFftUF4VnogqfgLPen24RHq6tW
         eq9PFMxJJiKMp179v0ZSZN80t+zUEG8SD9nhnsC0tNPs6oPf/wQ+9t+UQot5NKj9LPIT
         a9Uq49t2NwhWwVDw3m3eCJzBLSKQGrbRp5gFSU/bh4egwFjlZaHDyA96ZAQ9hK0g5fRw
         J61gdnoceFh8a6w+3c7YlnRDkR0CHGf/xO7t4OUFEyzHz6NgOs3htiG8LVSksc9qLq5T
         Yzv+/s7FnYD+lmxkoewE1ZdJjwsKto42GVFY4X9OCe6/4WUQGjgZ2YkbIn1Yu3Mqm+aD
         E5Yg==
X-Forwarded-Encrypted: i=1; AKwUvBwzBN2ukriPUe4iYbNMPGzB8rDBl/kqJyqhhBvfzE0TJFjtplbxS412uX+gd787OOW9dO5mxjOY1g==@kvack.org
X-Gm-Message-State: AFq9FYKrsCTanQgs0iOyr4rqOJ5O8nqoSMBqJg+sDolLZyc7XO2g5Dbg
	WSqKjaHDikgwSLHuNcGK8wQKGXaBg7EhidbwVCWQBvp1kdDm78n42rSDWrMiv9X854I=
X-Gm-Gg: AYBFou27LtQ0Y3YWQiWBR0BWHu/iMQbERkfQgx8eLbUklU8fJOO/Mt6n/XhBkT48sz1
	+8CVvuNxF2MVb4xobnMrO4dDmojHBiDM5DGPIV/mvvB7aHJixu6tQujsZtHc3FWNjPq4t5EKZ8V
	BtxsGFpNa0FfUhhqRb6mGbxLO69tiPJ5I/oc8g+j9P7tNtoIlcnUzLBXqsb6mdCepauSXtc5LgK
	aQtceoIuTBalEHMcmxpQxLeTTJ1P9vb3U1+HKfXEXBL08WVEMA3R5KjrAOKyMbIPHRzfb6XFbX3
	IFGLRhr3xtjBKqtb74I6jpL7hXeV3F02A8zzcdcRZhm6XT0KRjzYZuJtik7Nfjw4bR0H6ZHAUr0
	zj4kKqg3okLaNMqrL6Hy1eEhOvGTdhX+hpmqIaT6Ma/jfATHCf1tkmjxT2iUucvz1Ml2362EJuq
	rS/n1lfEazOZ7FCfUIggfA/mRXExwpb8IpuhrN+Vvt2QrGuFNBP7j0I0CqYNa8jyAs278jGB3th
	XSvojFqmVAtZhgQTI4N8x7mKkqRJdXwPBYgfggBbLdjckaNweDxnnYiGHASeMZwxIHJW2neGlwJ
	2muQIPJi1BN31fwfsEDZOG7gHfkzIsmQkvXs8wVH4BBhILyaNRpyRUSIhYVIQxZq6m5tKrjL3rQ
	RsfNBvQem+GkUN5/BLsX0Z+3hitYIqQ==
X-Received: by 2002:a05:6102:a54:b0:7b1:6028:5475 with SMTP id ada2fe7eead31-7d03a505a71mr1235376137.12.1793206503993;
        Wed, 28 Oct 2026 09:55:03 -0700 (PDT)
Received: from google.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7cea3d32a48sm6300543137.9.2026.10.28.09.55.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 09:55:03 -0700 (PDT)
Date: Wed, 28 Oct 2026 12:55:01 -0400
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
	linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH 04/46] mm/memfd: make f_pos accesses atomic
Message-ID: <auIoupm228FQTNGi@google.com>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-4-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-4-6f74bec9a5bb@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 17945100003
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: tf965wpr9xf1cummy81ezezjhm8hi6kr
X-HE-Tag: 1793206504-945819
X-HE-Meta: U2FsdGVkX19CpRv/5reCebEt3N+3fcH3R+LGqgpRrje4AxBVczVXOwkyQ77XVY6El2Ggnad+K7lBQZUQepfIaYeUSMHTbErqJYk7MDiqiGc0VEdBtSDkCLvAdQ+xNUr2nBWa7Kfz6KUWE4YJhOhBoazIrJy51JXQLSaTSI8woU9Z7aeNGH+uKQ5Irym9gajDSR/n8w73J7Kr/abbkLFJ9Mp9RsO5Ihc5M6V6ZerXAM3uRVLqCIR3WuL0A8OTjTDX+/2V3NpOxx+CQUGgndE/IyURTao2RI0EVHxmRKEhSWgQb/5Rkxg7HuPTtEG5I02+gD/Aw+YdwKq0N6HuD5n+RvyjzJQZZJkwYZuVjQUoze/QKI+xGAQVwgqldIVov7uj+KU4Ye0knWmRAirNYLLsJl69vO3TIa5wMDKwts3JvJI0jsWHpQyQwFqDboTosMxCu2+CeMPs7UIKJZwgLP8fGqzzAFRFv+UGpCspH3Gkh/7BEp3XHkvc5AyTB9uDHX6sATFHTUkrnaPFq+IQ/wFjO2kFHCIue3WKTu16g8k2DC/JTQ6OIaMDWzzdewdklQGdDS9Lt5XMibLUy4IB3/hQbfxD5FVS+E5207ZO2O38feQoHzaU6PpuPPCs7Cf/cB9sgwfDPxpUX6Hq+3r3joqGBhVLXfMK1Gub5XOstiRlKWMkQU0Gxa2rEo7DDvhV62uKKA42UZk3ffmB8Oe9win9tDT6quVI+sGBG9LHaRiQBPE12JOW1lY9PFebuKN/9rcoRVQX74uc0Bzq7BKnjetFbts0d6XFOLQXle+Sf6LO+JFpp+FyZwvWNS03K5cliFxmsQCtEJn44vsKc2PGiZP7VnZbJnOZLEgJkYfaZpQgFrZqYq8U+jc4FAUxN/lOmEt75k14PO5FXdoYs7DbF8/VEhwwQozwUC7Xu1PrfOLm36RROFKapV0/BNwKB9D2xUCmYcubZ2KZAOKUfXS6A/n
 O5ICMaMz
 kH/CHaL9WnScXdLr5mIBTVXxSEdO+6lFxS0MXmuTIXpJE8gm72mqvrdDrdWPpXfsKQC+WxkQYTWbuVOurCyuoSY5bL6BMfRwUCn6owGZd5/iDpO+CuD6GLI/KJG/NpM5jkCFAkvzwgeSZsCndQlXsycvH+MIfjtHxi0jj7rDSL2/UtU3KHM7ZPhKaZUY5gHAMosXEhD3/p5xfob9wruoFtnm/3wCqGSvvNaYAjPmMf/sWUMgupNzI2V5OuFO+aUFoqCu25PzMPQwm1O2VIwdXomh0ryhId7Ku0EkirD/Bok6HG9DVKSB6LehjGhTCnTaliFmcPpaQZZoW2iSGrwG6FBdw6HnsZdUy1SyULHSPAsfzRymKRaRk3GJWsSAkmNDW76PVIZlXzAzLfzotKqc6Cc2vjmzxHhEX7knhvJ6yInHCPGq98VHDx/oOhK1b1RfGzdmm+WZhZVYAQ8PBzGrQc2jEhsfG/OxH2jRgE7PW/ECDc00B+E0lJi2aJJGMx+HPTbT6FuIdGEh6+zFJe+IgMa1c99yVnmog5C+SaPpRyouG0WQiSZzNzCBewo8Pa8V0gXFb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10-27 00:17, David Hildenbrand (Arm) wrote:
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

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com> 

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

