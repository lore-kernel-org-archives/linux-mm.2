Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22E55EDF050
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 07:28:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76F016B008A; Thu, 12 Feb 2026 02:28:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71CD06B008C; Thu, 12 Feb 2026 02:28:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61C166B0092; Thu, 12 Feb 2026 02:28:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 504676B008A
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 02:28:28 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E067DD7018
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 07:28:27 +0000 (UTC)
X-FDA: 84434976654.14.2340341
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	by imf18.hostedemail.com (Postfix) with ESMTP id 11B351C000E
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 07:28:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Yup3dfoa;
	spf=pass (imf18.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.160.52 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770881306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XQVBJfJ1MZ9SU5R5LVaTBWmfH9hs6Wh8SbDfH40ZQxU=;
	b=fxnPYGepyB1/BQ9s2ijgz1sF9lBe9UE102U7kYjOaDN5MIxM0xqf2EGmKFLTsdWa4uj5w8
	Qy02crciGqrWz3QBeGeIE4CWCyX67nr6KcG0M9AfWIuH2dU970Douwou/Gm96rYWohlB5q
	B5BEM15QYqYdlOwDJiVeoKkRWylhD6Q=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Yup3dfoa;
	spf=pass (imf18.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.160.52 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770881306; a=rsa-sha256;
	cv=none;
	b=Ru4YDg4ihQjvyz7jVNG80NdHTLscFByqKj+6fyfOwFcnGCSwIOl4v+JoopGnOAUOtI8wJL
	SC3v7XqK+gaMDrq8927ROEwVWy6kJbScdF3PDOVkRwUns2DImoCrgW3i4SDRAhv47Shls5
	662Vr9QpVvgh2y/JJrhDSXbAPwSKhNI=
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-4044854464fso4596109fac.3
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 23:28:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770881305; x=1771486105; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XQVBJfJ1MZ9SU5R5LVaTBWmfH9hs6Wh8SbDfH40ZQxU=;
        b=Yup3dfoaBQ5ogFUmrhd2UhDB7/2MVI59b/I9KG8rvPYhXmXBcb3nUFT2JrC5YLy9eg
         6DF1wqKjY62uIsYuFqwjt5K413bP7mZkW2tzfGVVfigOkLd+R2fv2jLFIzY/RlMjXIym
         6M31sZpSGfrMqtqiVwaV5hDB76o/eAIyTtk/37U9hnkNHKbGFk77K+6b2kUNhRaFWvXj
         jsYxU+SrIBocug9PWe/4eyQLy30amRFeCcWrPSmBXNYKP7JvyGwxnYbLahaBQR4Dnu9w
         tVo7U0LEld9v3UrxUbSb52i35F0cVBviLzhdONY24j9a4rj/ABQSHCIk1DYy7tpBmQqz
         nkiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770881305; x=1771486105;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XQVBJfJ1MZ9SU5R5LVaTBWmfH9hs6Wh8SbDfH40ZQxU=;
        b=Ef81Vkca939vazdqVvbQV5Jk3jr7Vmqs1FOqD0YomX56UrhjZKFbHT3sO9XDKTgj54
         HvydovOkdN0zP4EhnzA8VV6HCgMlfglQaTJy5u/6rczGJMuYs9qyJ7W8qXdXThIPR4OV
         fVAewZiinebTPhYW448ft0jJe4jk3d9KJvGM0JpifUFptAKUG/924GZCXT3xpAgQUJv7
         Ro/TNv+wcezak8wfL3wMEqGJwMDghA30l5S/JLrc8iUNb6sWENgJKZBdfZDv1Krqx/Cd
         481ht7hjqc6W79Z+nxFM9WsvrLnKWHJnj6N80EhO5KBTzkzlKlwpMlIYhFU+P6Onw3ZE
         piqA==
X-Forwarded-Encrypted: i=1; AJvYcCXTZnmTI3JQGw+3EpTzl8VaQU/KjkbBk0NhVxerRQ5/U6nqPvYwGbmg5aCxi7hwWBYkYdBbKW7MRQ==@kvack.org
X-Gm-Message-State: AOJu0YybHhMXACFXu38enhslM+NQozVCjYGNm4GQqDLeBXexZnDXe0QY
	HXl2YUfcxsafrTEHFyCMdlhRoYQDcof3AOmhZFznbHpYYXhcCbuJBtwWp2X8XQ==
X-Gm-Gg: AZuq6aLzuXI70qbXsflw6grcHjCJEhM4pbvBe+lqBkewHdxE2dSi8eVs7cUKM0WV4pX
	OmjxUD6zCB9zXIKEdrsE9Q4Jc+3aOO4R6HpNMfzbqPKx8PvqdRMUMLkcxDgMNgkmqkh9lPX2Ark
	mRub/1/jPW0I3IEPKtreO+iLii0pUhAcdNYFYK3TWU7MaXbL/cjIfQT2ROUxbyNDbJTV0kTi2O+
	SfW7+G8AQZG0TN4zEuKUJQ4F6oDJITP9iTIDPIM9PlXtoxiGusFzM1XOZ0u+jhwQc8Vn9ZK0fVI
	VSJFRtixtKJr6xogfWP00NmeqbPsvOlfKTTQD6s2AXi3pbeMRCrAstgHdOWMR6s6WOaATAZthwG
	2G/4bi+v0cjm+RR4hBIvUFzOXk7UJRgEWxWXYdBOky1eLytG7exwc3gsrZ71tU6PgZznKovyvZW
	Pqp9G4omyNyr1KIBqo2rkU4y6IGLsiraPanIE=
X-Received: by 2002:a05:6a00:71c5:b0:81f:3c5b:f437 with SMTP id d2e1a72fcca58-824b04ee53amr1215886b3a.35.1770879381999;
        Wed, 11 Feb 2026 22:56:21 -0800 (PST)
Received: from localhost.localdomain ([114.231.118.96])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8249e819618sm4791837b3a.51.2026.02.11.22.56.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 22:56:21 -0800 (PST)
Date: Thu, 12 Feb 2026 14:56:00 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jackmanb@google.com, 
	jack@suse.cz, jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, 
	kas@kernel.org, lance.yang@linux.dev, Liam.Howlett@oracle.com, 
	lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com, matthew.brost@intel.com, 
	mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, 
	rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org, 
	richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com, 
	thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, 
	vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v1 3/5] mm/khugepaged: define
 COLLAPSE_MAX_PTES_LIMIT as HPAGE_PMD_NR - 1
Message-ID: <qfj5dra5f3acies7rvvanbmk45yrzr7pbx7wghu5m4i7ybvbip@pkn2k5cks7jr>
References: <20260212021835.17755-1-npache@redhat.com>
 <20260212021835.17755-4-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260212021835.17755-4-npache@redhat.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: xwexcoayf1ei6qygoqoo3k4bsqyyfudk
X-Rspamd-Queue-Id: 11B351C000E
X-Rspam-User: 
X-HE-Tag: 1770881305-984474
X-HE-Meta: U2FsdGVkX1/Jwb3QCFdvMXi70Yn7xybk5h4Q/Km40gQ4TwBsosXzKHHtldAOq5YCGq5SAGIubYVHqwJb6hjB9wEeD/nX5F+KHZEkp4qbE9xQcaWEan10GVuC15aeeueUmpTbLZMAcyooZFG6xiWNHi19o4RDS95Wk6/F7dqjZ+O/+kdXV+5Wz5LyK/pjsNhuc2WAMoy1Dz1QTzbE5fWzjZ6GDLLUR4ES0vqZobXj3YMGLt4F0vnfS9ZFb6aGfR2C2WDX3osEj2iLe3sa1Bz7EBgRJnsGhG7M82y9+KdyuPzWj36DUq10d9vOiN+G+x7zBFAPUsSjwUuQPBjyxZrNQug9Zm3vBiMhfmRnZk0xIDAW4w95oXI0TzahOc5w+jGoEpJ31NhXmwaC6W4FroIZ3gEhtk8sxLXxEjlzmFP7jZTjBYwGAr4qBaUYF6VIbLbIK5+FYldAmmoa4+DCnvxczZYUQyqD+AK+S5o5dFDqkv7x6Ta8LlsRyRVwiIk2bRe/VpcJufWHneAtDuiDTmLEwFGzavOCmrg90oufAekfIwQEUO6CZYTXty+tc1hbDao5DU5YtNTd9TpshEMplixsOM/zI1A4FnH5kdJhfRPbn+Sykn4jOPmqpUKCpGuVKpcPJlK75v024YRCfGbE+lQShn4dNRiG8qkRY615bj1raQa+i6g6RMXpt9PL4ROV1Ef2TQaP/GANa4bkr0C3V+/cqb6p8ErHgTg7HlNvu++aTPXE+C6Je46FdCgKEzm+CUuNQTRh7+R7l1uvsbRGcomKusgg/0C+jVdpKjmIxJEy2BxmKDuJxbucgqfY02rW9gbiqgFak6jBAXhnArYPncZuriEXKItTYmDUhVznCif/8FPDRVUCkKyW/rsCyQLWFk416FnNcV0Ekk9Px6VN8pYnmt3WJd1rk0dR3I5jedZJstRvKyys2MuRAFI16+oqNYeS46F7slVRQXZ6vdOLpzy
 s13yr5C6
 d9QNN9Zkf/zdb4OkuvwsDWjbYj6tAK8qO1JvVxDhFdBTeczOoDhtz0q3buOyLqTAmguvnKcCwPpkR6zzsRsOcH3pUhgROXVhBYAfX0SpO11wq3DhmlFND9UW70Z6gZn643ecvONX+DvFmSWIhucdyIlHvsz/cKS7l13Ixf6oNxsrVSS8xJiv7C1qLPIKdtMsCV1MgyUZCJd7CVO7d5929Dh4pXsxHDviE3siO5PQxD77jaVhvb0u9QXIy2uaypaWEEfcgsSlIHFMGf2aWfNOtwWFvHzjOXuPsObLhVd2VjjR/ICw6wQ3zU4/q6gy+FMJyQh2i1FryrtkMMJuvy9xkmSXCnndI3rcYruxU/ff+YOlrAJ8EKFgZ/9P0tT0vERZIyevI9XX/k4jxtJ+CR9DK2OhfyC/EoBAiY6kGzcYecaLLKl7my9jGUlGA2+HiuTJVm2+a4yT7opvG1SNm96GGsWPGxNgnExdSjwwZR57H1EPeEGJcWcJcWd5BT+EWFomBSLg2aeaCSoWyFlDccXJaorn3nUC00nFF4v/4Z8ikmXmj8gEwWUMEjCvGVk3hgCM/hUzy6k6fE8SOzhXMlwjBxVd2NyYr+hAp3q9M7SsCksYATwe7t4XoILsblEFvgz384Vrm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 07:18:33PM -0700, Nico Pache wrote:
> The value (HPAGE_PMD_NR - 1) is used often in the khugepaged code to
> signify the limit of the max_ptes_* values. Add a define for this to
> increase code readability and reuse.
>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index c362b3b2e08a..3dcce6018f20 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -85,6 +85,7 @@ static DECLARE_WAIT_QUEUE_HEAD(khugepaged_wait);
>   *
>   * Note that these are only respected if collapse was initiated by khugepaged.
>   */
> +#define COLLAPSE_MAX_PTES_LIMIT (HPAGE_PMD_NR - 1)
>  unsigned int khugepaged_max_ptes_none __read_mostly;
>  static unsigned int khugepaged_max_ptes_swap __read_mostly;
>  static unsigned int khugepaged_max_ptes_shared __read_mostly;
> @@ -252,7 +253,7 @@ static ssize_t max_ptes_none_store(struct kobject *kobj,
>  	unsigned long max_ptes_none;
>
>  	err = kstrtoul(buf, 10, &max_ptes_none);
> -	if (err || max_ptes_none > HPAGE_PMD_NR - 1)
> +	if (err || max_ptes_none > COLLAPSE_MAX_PTES_LIMIT)
>  		return -EINVAL;
>
>  	khugepaged_max_ptes_none = max_ptes_none;
> @@ -277,7 +278,7 @@ static ssize_t max_ptes_swap_store(struct kobject *kobj,
>  	unsigned long max_ptes_swap;
>
>  	err  = kstrtoul(buf, 10, &max_ptes_swap);
> -	if (err || max_ptes_swap > HPAGE_PMD_NR - 1)
> +	if (err || max_ptes_swap > COLLAPSE_MAX_PTES_LIMIT)
>  		return -EINVAL;
>
>  	khugepaged_max_ptes_swap = max_ptes_swap;
> @@ -303,7 +304,7 @@ static ssize_t max_ptes_shared_store(struct kobject *kobj,
>  	unsigned long max_ptes_shared;
>
>  	err  = kstrtoul(buf, 10, &max_ptes_shared);
> -	if (err || max_ptes_shared > HPAGE_PMD_NR - 1)
> +	if (err || max_ptes_shared > COLLAPSE_MAX_PTES_LIMIT)
>  		return -EINVAL;
>
>  	khugepaged_max_ptes_shared = max_ptes_shared;
> @@ -384,7 +385,7 @@ int __init khugepaged_init(void)
>  		return -ENOMEM;
>
>  	khugepaged_pages_to_scan = HPAGE_PMD_NR * 8;
> -	khugepaged_max_ptes_none = HPAGE_PMD_NR - 1;
> +	khugepaged_max_ptes_none = COLLAPSE_MAX_PTES_LIMIT;
>  	khugepaged_max_ptes_swap = HPAGE_PMD_NR / 8;
>  	khugepaged_max_ptes_shared = HPAGE_PMD_NR / 2;
>
> @@ -1869,7 +1870,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  	bool is_shmem = shmem_file(file);
>
>  	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
> -	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
> +	VM_BUG_ON(start & (COLLAPSE_MAX_PTES_LIMIT));
>
>  	result = alloc_charge_folio(&new_folio, mm, cc);
>  	if (result != SCAN_SUCCEED)
> @@ -2209,7 +2210,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  	 * unwritten page.
>  	 */
>  	folio_mark_uptodate(new_folio);
> -	folio_ref_add(new_folio, HPAGE_PMD_NR - 1);
> +	folio_ref_add(new_folio, COLLAPSE_MAX_PTES_LIMIT);

Hi Nico,

Thank you for cleanup.

The readability is better in other places, but here it confuses me.
Why is it LIMIT? I had to look at the implementation code.
Would COLLAPSE_MAX_PTES be better?

>  	if (is_shmem)
>  		folio_mark_dirty(new_folio);
> @@ -2303,7 +2304,7 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
>  	memset(cc->node_load, 0, sizeof(cc->node_load));
>  	nodes_clear(cc->alloc_nmask);
>  	rcu_read_lock();
> -	xas_for_each(&xas, folio, start + HPAGE_PMD_NR - 1) {
> +	xas_for_each(&xas, folio, start + COLLAPSE_MAX_PTES_LIMIT) {
>  		if (xas_retry(&xas, folio))
>  			continue;
>
> --
> 2.53.0
>
>

--
Cheers,
Vernon

