Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9068D606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 09:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=fytAJIt/
Received: by kanga.kvack.org (Postfix)
	id 83B4C6B05B3; Thu, 26 Nov 2026 04:25:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C5406B05B5; Thu, 26 Nov 2026 04:25:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B51C6B05B6; Thu, 26 Nov 2026 04:25:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C77536B05B3
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 04:25:54 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 84E8F4038D
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:25:51 +0000 (UTC)
X-FDA: 85476738102.16.9F76045
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id AE318C0008
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:25:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="fytAJIt/";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795685150;
	b=0s5dnkeOdyxoi2t56jw3YiRLR5g31pcZYqDrf7nEkcEJisMejkNTQm80oFCKc3YnP9gpP+
	ZikTdbTQR89wOEghAIfNNezlWSfgcj1udAITiamrSF9SQyiOcfACFcZ3x52c2vkQOwTAxN
	FWnM3WXQqt2dNE5W9tPfrY8A7soEpXw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795685150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aKApNAjFNuW6/wq/vS146NocYcxpNSbPfKkUgd3vTt8=;
	b=Dq/SQPQ5KuwNHA63DQGK/QmpGru7agA/uEQ/qJdl7IVW2MhQUHOEc/xoL4kLwvrxdCNK6W
	DeyKgpi0LlT0O94czTRe7W63d0Yyp32utt44A2l2iaiJJyZNkW46gRrm/HvOhtFSOh35sS
	mHXoVDCXto0fGvBIaxVaGR6xqWqkQCI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="fytAJIt/";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C0D661BA8;
	Thu, 26 Nov 2026 01:25:45 -0800 (PST)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E0FDA3F632;
	Thu, 26 Nov 2026 01:25:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795685148; bh=Hbxa4IjJkMzsMDpju7sU3gXs/jL+CVj1EcFYUSt0hhY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fytAJIt/ajmL5jTVWMxzkakTC6xw3pTwIVq8nYP+1wRcqvdE7IH+DM9FsC6Jg1xZf
	 XLx+SPAJxFl1QVjR/2HSoORWNFHBnG2oJv3p1Z9KU3k9uvpvxcglm2rIMui5Imr/2W
	 m03B95GEVOoVhW7Zdm5fjeCfedMqHjBBIB3JIJHY=
Date: Thu, 26 Nov 2026 14:55:45 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: JonasZhou-oc <jonaszhou-oc@zhaoxin.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	jianhuizzzzz@gmail.com
Subject: Re: [PATCH] mm/vmalloc: avoid false sharing with drain_vmap_work
Message-ID: <gdy3cvqeppwda5zydfl3cq37gmihrbizbnio5bnandkl2brnt4@vw5s5wcbejoq>
References: <20260825104659.100134-1-jonaszhou-oc@zhaoxin.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825104659.100134-1-jonaszhou-oc@zhaoxin.com>
X-Rspamd-Queue-Id: AE318C0008
X-Stat-Signature: 7zw5hc7hkaqziw5mtehehsro9967xpjq
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795685149-578628
X-HE-Meta: U2FsdGVkX1/FT5uA/l4QflOxHfRrzsvvce+BIpTb2W63Ypbz/mer55Ac4tmBHJrcy1dT7KgiC9eGxUJPe5aW9bZ4BM4duWfywlN7ejO5yiClPL4CgqYogUftHp5nvSgb+JtYwdrHbk59JhHlChboRpD9okz7tuh1NSV7/XeZg5RoJogobPqyiMueICEQQALNcgkiXvhlAK5KQoQYwZhmZUNtekDT+RfQEy+RmnsgN+v6nJMjKB269w+pIXII9LiS9/irNn+UW2rticiLhSFYDDz1jTDzo9ePdbj6AYcBHhNewX3iYL4ru6B4o0MawMYxcpE4He6CuiUcSjFy2dA+uc4RQ7xyHctI+rXS5Bb/034pW8tux3NxhTJmEZLzk9YdGZjng6BYQ38aKVdm90Ye80rUdvIBWz5AYCxgQHWT10gQunoBX3+mwGDt3nUNNM1S8w4bu1gilHyWOoBG1OtRrQAhT999pTKBCNx1xFlOTS1zdTJ9UhwVyScljQ83ntQZ8Sz8tKIvIq8i6aM82X/NXiX5UVWa0SW6a4AxmUtBG5PMVUlvYvoXH5agkdPUz1V0Y2yAttQbntFSn+IrM9PMndi0srv526smCwnADMlupAWdjgv4G1akeeqadwtJCijZXOKKWguD7Yaov8MUjHtuJiXvFWvZGKvILBbn73bOKln4kID5X4hO7pgRw46vEZqOV3aGP0IpZ+o2JYxbV0G71m9BtjfnzGAhWj2OSt7VMfcOU3DHPcDMZ+OFIaft2ujpSn8KYHw+8pmvCXhsvX872DpyPUJsiEpN/GimN3nAYGjTorrm+1KIaEA6bp8CKtshEH4abIb9oq4nh1DH8PSoT0wtvxpNOKwSBZYy0NRghkreFCrUsL4724Y0xp0h0deBB8rmxx4ju+uaenO+/nhaBF/nc7GgObw2UXZKp50KTkTwwIi5FDgQ+I2CquLJoNJ8pvJxU7ylQP12tM3zsq3
 pk0v46Ga
 kj3Iyu2vh97vM0kf44Aqi0AYfY36idCVYk8fJ02fyzIu7IZPrccXXDYen6AO8JJtKHnLzwR2gO4O/D4OlHscafyBkf6c7MyoFkVennX2LCeyMyrOeu92fOehxlniNUkPLjhFkqmLReITkdKMrHLCoCNP58RW1jjgEPw0wpZhlxBPLQD5iSHAV+k7FHPLo/fnqFHyj0hW5hKaaabI831+ebeuLlhtdnYLoqNkGioVALZ7ecZGvdvLw+QlOGz8Y99MgKfrkDTCmL0YscUZL+CKyqK+jB30IdWe07vQzOd7CilPaJi8W4tkZN1VJUCbW/T7KDOxPruGYdKwhFHEf8o/8Jpe5y2EmpgemviqF4cfxvCleLobQOph1mlJL7aNEwShdfnJasAjl+uWlNDYfCEzK2lpoaRFytkG81xTr89zPulwyBJUbWhylHBd5kXCEirEJIVvcP2a+ctRjatuNSRSH8RqOtELEmc3qddeojxQtAU0iQUaVo4I6TP8hqW7oE//X+W8baWcHraspV6Y/0sQfEwfNQhibXm1GPqeRfmyjC+i7pH5Bb24Z+w8931aJvFmh+dXjgfjO1/cg4WpeZwxmievNLjWQthQqdr/B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Aug 25, 2026 at 06:46:59PM +0800, JonasZhou-oc wrote:
> free_vmap_area_noflush() queues drain_vmap_work after the number of
> lazily freed pages exceeds lazy_max_pages(). Until the worker purges
> those pages, concurrent frees keep calling schedule_work(). Even if
> the work is already pending, queue_work_on() performs a locked
> test_and_set_bit() on the pending bit in the work item.
> 
> On the tested x86-64 build, drain_vmap_work and vmap_nodes occupy the
> same 64-byte cache line. The work item starts at offset 0 and the
> vmap_nodes pointer at offset 32. The latter is read by vmap allocation
> and free paths, so updates to the work item invalidate a cache line
> read by all CPUs.
> 
> Put drain_vmap_work in the cacheline-aligned data section. Tests were
> run on Linux 7.2.

Should the test be performed again on latest RC kernel ?

> 
> On a two-socket Intel Xeon Silver 4208 system using 16 workers, the
> runtimes of vmalloc.fix_align, vmalloc.fix_size, and
> vmalloc.no_block_alloc decreased by 12.61%, 5.78%, and 6.87%,
> respectively. HITM samples for the affected cache line and total HITM
> samples decreased by 96.55% and 13.36%, respectively.
> 
> Signed-off-by: JonasZhou <jonaszhou-oc@zhaoxin.com>
> ---
>  mm/vmalloc.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index f4fa227a8d7f..6b4b287e91f6 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -1088,7 +1088,12 @@ RB_DECLARE_CALLBACKS_MAX(static, free_vmap_area_rb_augment_cb,
>  static void reclaim_and_purge_vmap_areas(void);
>  static BLOCKING_NOTIFIER_HEAD(vmap_notify_list);
>  static void drain_vmap_area_work(struct work_struct *work);
> -static DECLARE_WORK(drain_vmap_work, drain_vmap_area_work);
> +/*
> + * Keep the work item, whose pending bit is updated by freeing CPUs,
> + * away from vmap metadata read by allocation and free paths.

s/away/cacheline away/ instead ?

Besides the comment could be re-worded with some more detail perhaps.

> + */
> +static __cacheline_aligned_in_smp
> +DECLARE_WORK(drain_vmap_work, drain_vmap_area_work);
>  
>  static __cacheline_aligned_in_smp atomic_long_t vmap_lazy_nr;
>  
> -- 
> 2.43.0
> 
> 

