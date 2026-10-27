Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3567A606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 08:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DqgW1ogH
Received: by kanga.kvack.org (Postfix)
	id 3D1AE6B0614; Tue, 27 Oct 2026 04:16:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A9A86B0615; Tue, 27 Oct 2026 04:16:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E7086B0616; Tue, 27 Oct 2026 04:16:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0ED4F6B0614
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:16:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 93F911A066F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:16:50 +0000 (UTC)
X-FDA: 85367700180.13.D75D71C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id D7A8C100006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:16:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DqgW1ogH;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793089009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=25JoUd0Ca4DSucyqp8VdpaHvYyD4L6ugc8HcJwXmagI=;
	b=c29YGmo0G2DjMuVG2MIu6PthnVcJ5XZ0pUcFYn3ITQMUIwUIkOmvJSYJNykHMkEs/iap+g
	EGCQ4a6vpN5KSMFYNzUwBG2HegavC/OamiWDCQ70AhYoRhtwi1cAeQJlCDqFnFuKoA5obS
	0S0DSAXu2YkSunGqARe5G7bXhjsErxw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793089009;
	b=SqGzHkrDTV76wtkjIBPUjBrtHG50+Qn5x8yr9rEtOr49DWZ4KSRM7yG3OpYHr7JgV09zgV
	ouohLxBHOXySxJVVfYnfxBT4GjZkDaNtiZyplFcEw51mfJia/50y8Mx5ithRX4CZlOkToe
	UTRE855fNXHVKONAeHTTTEXL6S3q9Jw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DqgW1ogH;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 14E1740DBA;
	Tue, 27 Oct 2026 08:16:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6EE1F01825;
	Tue, 27 Oct 2026 08:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793089008;
	bh=25JoUd0Ca4DSucyqp8VdpaHvYyD4L6ugc8HcJwXmagI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DqgW1ogHskC3KjpnvkmfF/B2DYXhDZoPDNeziDRz5NYseOTPq/Bt3d/gR2uwOi5tt
	 l0FKm0+vSEXyriWPhPAPthXH1Up+UF+85+8a4DRAWSbZRYMnvjqZUBuxtSS9VhexcH
	 QjEToIVl39sflEhmYe9ziXX5NCu06RELjf5E7IRB4kHtHZXSvXfgKEoP26dOW1+9IE
	 ffVmPh+WFa/36AqcOLOz1lEuekRW0rjPES5+SXPWLU9gfjD0+35/LrvlH8duWv+GbJ
	 RuWAou4+YDgaZUIhlBwjRnVkYYWwTrj2jlqPucPxJ4gaehaWDjNNziTUjRRUgWOZSb
	 cgzDt4LnM1kJg==
Date: Tue, 27 Oct 2026 10:16:25 +0200
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
	Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 23/46] mm/userfaultfd: write-lock the VMA before waking
 waiters when unregistering
Message-ID: <auBd2RS7buo-Aa5I@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-23-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-23-6f74bec9a5bb@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D7A8C100006
X-Stat-Signature: ws4nu7o9xftjf64mpwy7spiw1z1pmn6c
X-Rspam-User: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793089008-284665
X-HE-Meta: U2FsdGVkX1/WEE0PNh1Iy/mIpCtY+2/MThzjQ3072QMnsMQ8ASXlQZyPJW9lp4rrEXx+g9bgAHeBT5sE3sU/kiXZnMQO0dSREhU18KO9OfM08m3XQT072OQaZ/YuGvUiY69xf5lQLtO/qb9l9x7LDJmziq07DnsMg25xVZmfGmnjjsfwlCbZkY17+iSC5WtmO1PEkiOZYoQ4PVxE5gH8BNj1YRiB9CrafZ4xOsT2j+tKznkSWT1h4V864o+P3UVlI7Pv2L9no2uS5A51LNzfyduODzZ3EJnT4lMVy5f9q+LMS/FwfDGQ7lWEiWyMbV+pnQ0k/y4h8fdf1aCAN/CKiqTCB9m+QaNdbLlT1Got4rL9iVEqI3qmBnT71RbsYwM8/vtYHWstkkGuQn38uHExza+6Sitb88Mwy+9mrA8lYxer3A3gR16av6GlS35Nv56igxPmkXkkBfMo//1js9rcAFWnVY3QfMTBbDFbOwbAVvIstXpBQN+mBl75MdTP9eDQIcJh3fMepWDEYarHkDKgvkfG56vc61v/eykceieUQrBVGWnLE6OTQuBclZ2tUAJDiQV8U6LBq/EShwqa9vl523ywk4lLP/UbOyDzEHY3obWjdYR6YnIpMPC2xjsfamQfG7Apg+v8HuHGwCPXlawHyL83w6Q+r3jiOut4tZkFN+YQkjU+XBDPXCN6XaoOVWG2UlYa5BXJiVLV6YPSYIIWUUYQt0Ip7/DMPuFZlecKayP6wYG+rmmT/xZCUvrSMo9/I3hrYu6ru/ztALCthz0twHlGUtp8Pf4glvI5KJfxXGiVTkO8kwYQFFEHymDOX6ay4f1iCJ9+ZWDZJbSpJ1VTnGKzpboamyG2ya3Z2IMsIAv1E1akkcWMmzM1nt0NScTR8UCt8MEDe/NDmP+WRzzhPBAo5/RveTGcKZ1qTvme56G5rr7PQ2vvyAx2Awh2GSCmG5oVJwi3d7xaQVr0mpu
 kB/M/DYE
 4qiTr3xK56b//HL6PuebT92jWhbmMOimIJKgiXdZZibE4tofaKiBpYrB4JAMK3bUR6BEKis2TowM5JeghsuhPJIgo6HVDrOr+TkbRzGupg6ntYK65ZMSk3/rqIsvDvDPWk24o/npogsKcTCfZ+QwBmcfxP92UrEnF7w6jgAs0uH+fHee8F8rSYjjNgOka8kQ/H7I6pJfhHzJvNM7+YEj/7bcAFHOYiUrgJNzqTFUhsdh46ON8rMIRHt+ogW9G/LT1uyZXw1z0YN87MCH4tXvmKBKITrtUGMO9ednAsSlxyNbVg5vMGpYY4S34SBKZEXE60S7qU4qZbCPT2zRAql5o6fn4vnN31HWgPShkqoq+RhSBuntEGccHY/oznF0Q/FLHfIV1cMhn4g4F13X+bd2Xw6ha3QY5TfJw58Tm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:17:43AM +0100, David Hildenbrand (Arm) wrote:
> userfaultfd_unregister() wakes pending missing faults before clearing the
> VMA's userfaultfd registration. With per-VMA fault locking, holding
> mmap_lock for write does not prevent another fault from queuing after
> the wakeup but before userfaultfd_clear_vma() write-locks the VMA. That
> waiter can then remain asleep indefinitely.
> 
> Call vma_start_write() before waking waiters. Existing fault handlers
> queue themselves before dropping the VMA read lock, and new readers are
> excluded until mmap_write_unlock().
> 
> Fixes: 29a22b9e08d7 ("mm: handle userfaults under VMA lock")
> Cc: stable@vger.kernel.org
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/userfaultfd.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 669f71d485d02..7e30b5ff17be1 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -3991,6 +3991,9 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
>  			start = vma->vm_start;
>  		vma_end = min(end, vma->vm_end);
>  
> +		/* Prevent new userfaults from being queued after the wakeup. */
> +		vma_start_write(vma);
> +
>  		if (userfaultfd_missing(vma)) {
>  			/*
>  			 * Wake any concurrent pending userfault while
> 
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

