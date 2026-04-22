Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8514BF94CD8
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 07:22:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E97616B008C; Wed, 22 Apr 2026 03:22:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E484C6B0092; Wed, 22 Apr 2026 03:22:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5E276B0093; Wed, 22 Apr 2026 03:22:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C188C6B008C
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 03:22:54 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5139114143A
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 07:22:54 +0000 (UTC)
X-FDA: 84685349868.23.FC1CF0B
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf05.hostedemail.com (Postfix) with ESMTP id 51A28100002
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 07:22:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=mmhiYkVY;
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776842572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=899XW99T8m7phQqcFM+gx4r/gMPFpYUZ5qz3cB2BL/I=;
	b=UPjMFntbK6VFuS8ChxpEkqmg6e3uCBzr5tEUPTlCBKjDK9eq58rAnCUGpJ7HDjZMvBpvQK
	qtQ5BVtqCJMmSTx0LsULNFibtCLDvlZ5BK11AbxCYwj5xs83TJdAOIQh//VLbF6H9rtd+k
	UVKU/ixnx34U23VlBQpgAxe91dc1xsM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=mmhiYkVY;
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776842572; a=rsa-sha256;
	cv=none;
	b=7MFfcNlU+GYHMQlqSY2Wg6xXLoSt8753T7+tjSeIgtWYPReUbqUV+fQ0VJGmbpoK+7akQI
	axCAwOz/O6shMupUYOce7Z9T/XCfQpFVYMW2y7sfVpkZVRV2lMky035EeCoYJcV/JXCvao
	Z2LKbbu/4paFll+JHXXjaNZzw4M3054=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776842568; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=899XW99T8m7phQqcFM+gx4r/gMPFpYUZ5qz3cB2BL/I=;
	b=mmhiYkVYDCjD/ZOqzOFZl31j/pGldYJXEC55UU1TJmadbrZB2dzlyFCnM/9UAADYjH+2etSRJGnvI3VHeBeNZZDu0YA9iAhKhlLSYkmjM7Kb3CQz0fgKfToJs0K655mhpTaTYavjUzuk7xe+u12fILRJXuLuZvWqBEM8jOQMrmE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R641e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0X1VNEnq_1776842566;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X1VNEnq_1776842566 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 22 Apr 2026 15:22:47 +0800
Message-ID: <b6a6eead-cfd2-4459-9c6d-384dc6cd72d8@linux.alibaba.com>
Date: Wed, 22 Apr 2026 15:22:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/3] mm: process_mrelease: skip LRU movement for
 exclusive file folios
To: Minchan Kim <minchan@kernel.org>, akpm@linux-foundation.org
Cc: hca@linux.ibm.com, linux-s390@vger.kernel.org, david@kernel.org,
 mhocko@suse.com, brauner@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, surenb@google.com, timmurray@google.com,
 Minchan Kim <minchan@google.com>
References: <20260421230239.172582-1-minchan@kernel.org>
 <20260421230239.172582-3-minchan@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260421230239.172582-3-minchan@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: i9ruej7s6bry6h56iock4ho7x4d77paa
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 51A28100002
X-HE-Tag: 1776842570-727468
X-HE-Meta: U2FsdGVkX1+NMB/mEUGOGiten8WhJpOjO1KMp91xjzQVaCU2OFSBxHgF+nBMYEmOZxtD366IvWXtOPVq3LE8FuetpVojy/uHQgy8HCm+UUZ1pBaPU86w61XG+8/zOorlnM3oDMUVSZuIkA/RFbHlDxxEiaeRuJbx9WiHzFJNvxOUvAA/HRuFreMwlkWfnZn+6ZvYydCmK5jc6FDeY+xteo1ATacQnhV290GGQ6mYZyM2f1E+h7Ur91sR15qYJmwuwNuUnJI5Mkiotcb7hTo4qUrnP/BtaxELrzdZb87KuKiwAVFjZiqz1vEJSK3bAl+xQPUng6YS3Ki15+gAm/gCQiB6Fso5KERia6XU0g2FrfyJjlC5MrO0oIGe3oy+W9eUIm5iIWq4GnT0r9+RDhFRERLBVUuO8DMX24TWi0aowAyEk171+aVD6n+t42P52YTm2SRnJqiXDdBWQPxUSWRXJ+UbOXjw52pCXOHw1PnwPsZkY5gyD7zNCtTR9JzwU2lQdRqCq5w5ph/l0OCDww035EVIOehLrjZwurXUD0FY0x1Od9YrAB/YfSL0+MywEU3QXk9nsR4I8xYItLABJZbgJXPoJowBI4BIhVZ3kXnCCvcMBoPVD1LKBRMQ62ICjosfn7btN/bZSCAiFeTIomh2yGmV8pcrXxnMInmBDFesZAFsto4DtMbC6l6af/2uqGS5FwUyuIndYl+SegI3Ssa3NGKdT4rBDqqYmyBRYwnJoqOlWuJrCSh4IgbsuLvZZG5pAQvo31ndpoV4ltgSZYo6vCGlMbeHphdEfQrqJmR16QqwY4FKqZPDYXdh24pPQfOejDE5cUz6a/pCYMiC8e825nOQgJ/ez73zTuUtNjL/JR2pwA3B38eOgZCUZgjCjXTdaYb07OOi1Gs8uO60QMm3785Q8TXuDaYVZqkYkUnbP8tWh03JI+vTSze8/bEWHr3US6VaQLhw8kVixEOGEj3
 iR5ATF/a
 532Kshj3C0zVqv053mpINgdl+xyLFLGJnMLGox79iATXFU1XLkJKEcLU0Q7RbzoyieN2HjCbqwbWSm8EoLekDfxq/A0rJ/cbf11O7SuoASitri/GMNq6JTDO83oSTvxIKPhB0tZMzjg1fzXxKREKn3uKpuSH9irZaIauvGi5PQQrRiUisffnc/Nbl2wEt+DyQkWWqKi6KPRP0VHnVxWldLbedhLSkau33HJakE+Y9u+vmN3pk0q5Ktw7stmSbZsCx2CuZkxoQbIWxJqxKKqkTjOQ5/1XEKlKaEsLD34GEZCaUjIaJNVeBkLAN/NkChTD6wrUJVZtekk9bQSU0ZDTDf2zvhdlozJk/LreyPx1qgbJVFCUMl4M+aOe1D/2zEleN+Ihf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/22/26 7:02 AM, Minchan Kim wrote:
> For the process_mrelease reclaim, skip LRU handling for exclusive
> file-backed folios since they will be freed soon so pointless
> to move around in the LRU.
> 
> This avoids costly LRU movement which accounts for a significant portion
> of the time during unmap_page_range.
> 
> -   91.31%     0.00%  mmap_exit_test   [kernel.kallsyms]  [.] exit_mm
>       exit_mm
>       __mmput
>       exit_mmap
>       unmap_vmas
>     - unmap_page_range
>        - 55.75% folio_mark_accessed
>           + 48.79% __folio_batch_add_and_move
>             4.23% workingset_activation
>        + 12.94% folio_remove_rmap_ptes
>        + 9.86% page_table_check_clear
>        + 3.34% tlb_flush_mmu
>          1.06% __page_table_check_pte_clear
> 
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>   mm/memory.c | 13 ++++++++++++-
>   1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 2f815a34d924..fcb57630bb8d 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1640,6 +1640,8 @@ static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
>   	bool delay_rmap = false;
>   
>   	if (!folio_test_anon(folio)) {
> +		bool skip_mark_accessed;
> +
>   		ptent = get_and_clear_full_ptes(mm, addr, pte, nr, tlb->fullmm);
>   		if (pte_dirty(ptent)) {
>   			folio_mark_dirty(folio);
> @@ -1648,7 +1650,16 @@ static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
>   				*force_flush = true;
>   			}
>   		}
> -		if (pte_young(ptent) && likely(vma_has_recency(vma)))
> +
> +		/*
> +		 * For the process_mrelease reclaim, skip LRU handling for exclusive
> +		 * file-backed folios since they will be freed soon so pointless
> +		 * to move around in the LRU.
> +		 */
> +		skip_mark_accessed = mm_flags_test(MMF_UNSTABLE, mm) &&
> +				     !folio_maybe_mapped_shared(folio);
> +		if (likely(!skip_mark_accessed) && pte_young(ptent) &&
> +		    likely(vma_has_recency(vma)))
>   			folio_mark_accessed(folio);
>   		rss[mm_counter(folio)] -= nr;
>   	} else {

Seems we should also skip marking exclusive pmd-sized folios as accessed 
in zap_huge_pmd_folio().

