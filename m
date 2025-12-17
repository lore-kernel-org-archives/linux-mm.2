Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E388CD6554E
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 11:23:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C2C26B0005; Wed, 17 Dec 2025 06:23:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 383546B0089; Wed, 17 Dec 2025 06:23:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28F136B008A; Wed, 17 Dec 2025 06:23:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 13D496B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 06:23:01 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B453C5BB5A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 11:23:00 +0000 (UTC)
X-FDA: 84228726120.18.9345C36
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id B929D2000D
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 11:22:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jAbjkxgV;
	spf=pass (imf13.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765970579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dIV0ashPOP0A+MXzT9KnBJgDvJXqc+fF08sRABQUW2M=;
	b=GKgHe5qxkV2pSp8I7KMooXvRDDW5CJRN0BAbERgLN1zSjzkx+vCFKLpIYwZkzzwddR6Uz1
	KzC7yu9aJcsJS8XIsIH4lrwkpHJDO7BmeVpE7yH4uk9g3HsdGQl2B+bSYrVh1MXMmJUrcT
	RYJofJxm1SWsu79x33n5xLgzVfGtrSY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jAbjkxgV;
	spf=pass (imf13.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765970579; a=rsa-sha256;
	cv=none;
	b=VkxM7rXD5xDg0h8LkVKDaN7UPSEQ7HQHv1cYeh3glPLjmVmiYEKvRTkFMxitdPxOKTiyXI
	KGM6/KPCIal095PAg66KQBjPXFx6gmNIN+hBNdU6/pZfCDx0SaXgmaL/9cVuk0exvrevhM
	TBjzSoH9BmWS3hjT0JrsyLD46lR86S4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765970578;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dIV0ashPOP0A+MXzT9KnBJgDvJXqc+fF08sRABQUW2M=;
	b=jAbjkxgVKsRXg27cdGaqnRuQ0QrFUrfUb6R0Z+3L9/lDmXkEKflMRaartQ2y4NYG1/Wu+F
	RZWsOta2fNx3lhYKSOYYBXA89Yv7QQ7lrdYUUPxBUA3wtoU5UQzA2Nsixt6M37idDWexlT
	ISDDzzKUUWPs/U3rQCwLxKiJRBzlZ+k=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-556-wx-E1mOyOhutKciBFe40sg-1; Wed,
 17 Dec 2025 06:22:52 -0500
X-MC-Unique: wx-E1mOyOhutKciBFe40sg-1
X-Mimecast-MFC-AGG-ID: wx-E1mOyOhutKciBFe40sg_1765970570
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 18A36195609F;
	Wed, 17 Dec 2025 11:22:49 +0000 (UTC)
Received: from localhost (unknown [10.72.112.95])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 639CD180045B;
	Wed, 17 Dec 2025 11:22:45 +0000 (UTC)
Date: Wed, 17 Dec 2025 19:22:41 +0800
From: Baoquan He <bhe@redhat.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v4 11/19] mm, swap: split locked entry duplicating into a
 standalone helper
Message-ID: <aUKSgf31kQ+vfbmZ@MiWiFi-R3L-srv>
References: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
 <20251205-swap-table-p2-v4-11-cb7e28a26a40@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251205-swap-table-p2-v4-11-cb7e28a26a40@tencent.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: rspam02
X-Stat-Signature: 5oy8acxqwc6ctidwwxsc1r5378jhckaf
X-Rspam-User: 
X-Rspamd-Queue-Id: B929D2000D
X-HE-Tag: 1765970578-845790
X-HE-Meta: U2FsdGVkX19iM+hrTRjBLZgPtTqFfcn07uTCfIz9ru6lglySfRNhFf0PXAgNmZKm7sGJTNC3wgmjB3+sb6JYZafXeru1j2lWSBOrTy/Ww1KZ3c/6S7UCvJ1r+a7wjNOAveu3EkN20xKVgxl6L+jEkpEeg6namlgp7ntL2IE2O4ZLpwXLktB2VbGcSrAdiD7ENHHtKz6dXxpXeIkdeLGMvogSp72k0wrDOsni1Wt1DbqPB25seUcI7g5p/DM7MsF2H5mVQpChqaO94tJiBMyvbZn/z+ooDu0FOFnD2HvjEwYp4lx8RdD64kD9shGHue4kkXHhM0v481ysF2V/jiebAUuUvhS+5pM9fQYmYQ/ch21KHMUOrXqLJoWQvSOVQ3ubbuFAuWCLxmqrrtOVSMSlKyuDaBTmxShkPAX7rAPrrxfuoQlxV6tAkNvsA8IN8Zq0t3LhIpatQF+Ml0C+MnznIj216K9n8qxRVhoS5vnHdejQtw29CxXcTI1M5h9IfPGF3xQZ2NWpPUSJZWKRGiEtvELN4ydx4Rb3lvzJexd3HrNpxEtz2Z6RVjMPub0dmqep0axUWnfslw4hFN/Qwzle7/KbjIzom/7QwprO0Jb5prG7kNJggvK5b3VdvGTGTgS/q2kg6fmNojWC0jzDMGGEfoX4v/Xa6Zx1diezUjgwiFuTzBWGt/0QOIrAI8xy1AkwD8EWg4V6p1y/iALscO8H361iLP6M6iD1kN4Se6TwXf1Ik6SK80CgO5Bdq85X8D8pDXJYi+1RM7canORNMtT+gPUxrXwwlyjJu9yGjyo3b3gAm0Q+ZX8HrkcY8jG4AS+WM09ZiRvQJrP9Ngv3rHytDfJgXBTV+eArsCmt8AX3KAlF74rdDu8bUWlKmnWTeEf/OHku9gTPAXZ1KvnnMSGeB6DgSwqP+liNi9vqPBSLdhXclGYWKHNP9cz+6313Sa9C7lnKn7MXBUuZVE3F3Rf
 DYPG1srm
 smCYVrQvoK22AbcdSrFJVAs6EPVkuaDS9bt2p+kyiClWm6LaND+5reDLVxZ+KTf5YLUUcWRNmZbDvWGQEv7Y8mz/5b0YqDvX0jJEe8QwbW1MYdIC6mBoqX3s0gxaUYY2gXuMj6pMYsgt4VgkB2j4wrAoRFBDTlAguCHxfkWjrskteJOuPVhpIiJkpRd2eQj17SVV/lCTuNzdbVrtDXcfL+ezlUqWONq9eCa0TmyQmA7IgwiMvuGWd5FU6jkM31GI/hDv36nQnzlXMZvYzMM7hflbUD7SUATV9r/AeJ5fa5CVAcHEzgbf28KGTiwS6PkOWfZwlRJLJ70QcSzhKzmOPWaG9vbI1y+CnNKzhNJILUyj910dpBH646TPpAm7Y2WvR3fhOf5HFy/JtfVmIaDXTB8B0b1JpeHaxJoMkcOCxZM7LgUM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/05/25 at 03:29am, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> No feature change, split the common logic into a stand alone helper to
                                                   ~~~~~~~~~~~
                                                    standalone, typo?
> be reused later.

In phase 2, I saw the newly added swap_dup_entries() is only called by
__swap_duplicate(). The 'reused later' means?

> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/swapfile.c | 62 +++++++++++++++++++++++++++++------------------------------
>  1 file changed, 31 insertions(+), 31 deletions(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 2703dfafc632..d9d943fc7b8d 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -3666,26 +3666,14 @@ void si_swapinfo(struct sysinfo *val)
>   * - swap-cache reference is requested but the entry is not used. -> ENOENT
>   * - swap-mapped reference requested but needs continued swap count. -> ENOMEM
>   */
> -static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
> +static int swap_dup_entries(struct swap_info_struct *si,
> +			    struct swap_cluster_info *ci,
> +			    unsigned long offset,
> +			    unsigned char usage, int nr)
>  {
> -	struct swap_info_struct *si;
> -	struct swap_cluster_info *ci;
> -	unsigned long offset;
> -	unsigned char count;
> -	unsigned char has_cache;
> -	int err, i;
> -
> -	si = swap_entry_to_info(entry);
> -	if (WARN_ON_ONCE(!si)) {
> -		pr_err("%s%08lx\n", Bad_file, entry.val);
> -		return -EINVAL;
> -	}
> -
> -	offset = swp_offset(entry);
> -	VM_WARN_ON(nr > SWAPFILE_CLUSTER - offset % SWAPFILE_CLUSTER);
> -	ci = swap_cluster_lock(si, offset);
> +	int i;
> +	unsigned char count, has_cache;
>  
> -	err = 0;
>  	for (i = 0; i < nr; i++) {
>  		count = si->swap_map[offset + i];
>  
> @@ -3693,25 +3681,20 @@ static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
>  		 * Allocator never allocates bad slots, and readahead is guarded
>  		 * by swap_entry_swapped.
>  		 */
> -		if (WARN_ON(swap_count(count) == SWAP_MAP_BAD)) {
> -			err = -ENOENT;
> -			goto unlock_out;
> -		}
> +		if (WARN_ON(swap_count(count) == SWAP_MAP_BAD))
> +			return -ENOENT;
>  
>  		has_cache = count & SWAP_HAS_CACHE;
>  		count &= ~SWAP_HAS_CACHE;
>  
>  		if (!count && !has_cache) {
> -			err = -ENOENT;
> +			return -ENOENT;
>  		} else if (usage == SWAP_HAS_CACHE) {
>  			if (has_cache)
> -				err = -EEXIST;
> +				return -EEXIST;
>  		} else if ((count & ~COUNT_CONTINUED) > SWAP_MAP_MAX) {
> -			err = -EINVAL;
> +			return -EINVAL;
>  		}
> -
> -		if (err)
> -			goto unlock_out;
>  	}
>  
>  	for (i = 0; i < nr; i++) {
> @@ -3730,14 +3713,31 @@ static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
>  			 * Don't need to rollback changes, because if
>  			 * usage == 1, there must be nr == 1.
>  			 */
> -			err = -ENOMEM;
> -			goto unlock_out;
> +			return -ENOMEM;
>  		}
>  
>  		WRITE_ONCE(si->swap_map[offset + i], count | has_cache);
>  	}
>  
> -unlock_out:
> +	return 0;
> +}
> +
> +static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
> +{
> +	int err;
> +	struct swap_info_struct *si;
> +	struct swap_cluster_info *ci;
> +	unsigned long offset = swp_offset(entry);
> +
> +	si = swap_entry_to_info(entry);
> +	if (WARN_ON_ONCE(!si)) {
> +		pr_err("%s%08lx\n", Bad_file, entry.val);
> +		return -EINVAL;
> +	}
> +
> +	VM_WARN_ON(nr > SWAPFILE_CLUSTER - offset % SWAPFILE_CLUSTER);
> +	ci = swap_cluster_lock(si, offset);
> +	err = swap_dup_entries(si, ci, offset, usage, nr);
>  	swap_cluster_unlock(ci);
>  	return err;
>  }
> 
> -- 
> 2.52.0
> 


