Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22604C982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 04:24:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 248AA6B00A2; Tue, 22 Sep 2026 00:24:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 220696B00A4; Tue, 22 Sep 2026 00:24:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 136526B00A5; Tue, 22 Sep 2026 00:24:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EE0076B00A2
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 00:24:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 80C6640387
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:24:27 +0000 (UTC)
X-FDA: 85240106574.12.B2B4792
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id E8AEF80007
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:24:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GeBKWAdu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790051066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kUmTSY/Kcrd/EARta1ekGXPCkorBIVhm7Emk4UPB6UY=;
	b=ZkSkyd+nM1zSu7qqdxUesB7DLUcvixCs3MnCsx9yPrFsG8nuEKBdeURIC6OBy4rZSo/uiY
	+IPH8zLjULrqg1Yr4++NO0ODlxwkTNdMUP07G7gu4KMiG7HVu3vaCf1GRm6aTmPc8Va7zI
	WuM17jcO/6/7l9DqxOfOj8uVEF51fss=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790051066;
	b=ssaTpVHnVEkUYCGZLu+u4SdIvCK6F/hw75DEI2LgiliS0SI01nu5z3x5ef3TQ9pZOPnILg
	txLmNmCoQKk5awuERxlFGEP4OhRKSN28wD72b+qXZMdKXxfCykg4S6mT515pYbfy08QlFe
	ej04IbsNr3o+P04tb3vaCIzkeOLEnZk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GeBKWAdu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2CF2E40AC4;
	Tue, 22 Sep 2026 04:24:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01161F000FF;
	Tue, 22 Sep 2026 04:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790051065;
	bh=kUmTSY/Kcrd/EARta1ekGXPCkorBIVhm7Emk4UPB6UY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GeBKWAduepmASI5QfstEaM87hWv2Bg3RjQMNLN3TIUIIV/q65OVgGpQHjZPX/L3F3
	 +vioQtuyHw8JiHbKfrWsFOBmPNCicGhpVx5Ec+wUqO0PAl1i5TNMaro6JG8/ZbUbxo
	 gZ4N1SdmdKSJntNnSzg+XsZqDCA+lQFOQO074S/kC0rKgLH5bleljcrSb8W3Q13R40
	 ryIKaqaB3mjJDSUVZJPHMXBXINtlYxYJBxMqrDUSwueueXzBP+GDpYJIwxzR9rJhF3
	 wsPmwnAacZU0ks5wnRxr3dFGwiboPxZ6lHxjlwkkSxEwQM4QoV9rOo1Q/AnIPnRZ+j
	 eqkxXYbnm054g==
Date: Tue, 22 Sep 2026 06:24:12 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 08/13] mm/sparse: move __highest_used_section_nr
 handling
Message-ID: <arIC7BheTHzBnLoq@localhost.localdomain>
References: <20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org>
 <20260921-b4-sparsemem_cleanups-v2-8-54d81d65e125@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921-b4-sparsemem_cleanups-v2-8-54d81d65e125@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E8AEF80007
X-Stat-Signature: oaq41a7subk6mrayg1xg38zkr1kj9mgo
X-HE-Tag: 1790051065-569967
X-HE-Meta: U2FsdGVkX19nZlQFd7/MLvCym81WQjeoAIH8JFEE6SBr5H2bFTPaRTfJ4928cAvQ6nIcmGCEKPrhLIRky+yBh3Z7YVDib+kG0EStZH4K4q13T8wD7FrFQbc2GLXwotyGNnlwvqymVc8JsbQCHXF7I/ObmnnSCDYjag8OD80sq413sOxxRfkbDWAK9SCPAlvqNiT3lh3FZ6UgTdjFX+t+Zsg6B2PGJ2KGbgmXyDFS2WnIcb9grjzLd6zZTq/Ek9FKeP+BQGMMoRJhJBzPvtexm8EKFNHgl/WHtAOgEvvbn0ShJ1k1GmVf78hehaQiIMriyQWal9WoLFiV5y/e5LM9m/dg3xeLQc8SRxvj8V92qPgZQ1Jk2CTtePU687gd8h66NaCbv3av5qTLVV6PcO4Od+2atbyBx7M7zSiqBxN93ZQE2Pjjhj4gCqfXbMaevgKTeVB1jge7GHU5zIv6fR1a5LkJJGJZGskUhUars5f7TQxm9iaq1BIZYqMrn3Z/Y0Q7vAQ/9/MT/roX7eaDBTytzDEbj6NP6hzPt82imr2/ZpLZVASLjLSrGNtkXwACsa2m+FFySw7wEcLtc8AE/n8FXdbR0Mx2L4IfrbQ/724owpn57CFxDhn46gOteVFYYyduoFVY9SEQ2I5uPWnMurDi8juEu9OEM71AFnJCoQj3ZbH3AQnngGEUYaWVlGBNv/C+r+OKtbltXUftWkKcP3jJfhi2ThOwNNpvTBSQAHZ3GZXZ2nKjLHENN2iTe7dwgUB5NNscUdhZcYrN4UFmLzLf4+9xchMybTnZTO+U9R76a8yL5U45THNFqvFecfaQpet7XotFpJhCQecPV7PuvY+VgtT3E54RvqKjbJn6jdJlmVu+HE6/EMAwmgByFvAf/3OfBQttT8jenHHbEnF1a9OKnaaf8/mAMwmGBtHKicli+N9l5iL6WxWMFJIgZvSW4JdEVfqMTMG/ofRScGZsvkO
 c1kmXHod
 ub2PekkjwHuX4kf+3cXssXO5thnqGtEPOAi1huXdAEudZGB/Pf6XRN6WRICeD7DkG4iAVIilyxQOd3nhg3c+Qx346IGAYSWaGigImKhQyz4dgk/35VMoFg4HnHO9IqtOP2KcNUQjf7QZFA4RxBe6C+tTvVu3dZOSCt/4b9JRXbwu4sjn5Ah3CDuyJR16XhsE6IiCQsbhTJLf6cPVgEVkXj4tXXqS1xx7IYN0oatMIF6Zkuv9zSfY+b9h6NARaKJBfm/aozkI05EQJFg7L6zNEK4uWa/lUgdKPIUW892Fq2z0OHkkbiFXW9XsGGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 09:59:00PM +0200, David Hildenbrand (Arm) wrote:
> In preparation for removing __section_mark_present(), let's move
> __highest_used_section_nr handling into its callers. Verify in
> sparse_init_one_section() that it was properly updated.
> 
> In sparse_sections_init() we can just set it to the last processed
> section_nr.
> 
> No functional change intended.
> 
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Oscar Salvador <osalvador@suse.de>

> ---
...
> --- a/mm/sparse.h
> +++ b/mm/sparse.h
> @@ -26,6 +26,7 @@ static inline void sparse_init_one_section(struct mem_section *ms,
>  	unsigned long coded_mem_map;
>  
>  	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > PFN_SECTION_SHIFT);
> +	VM_WARN_ON_ONCE(section_nr > __highest_used_section_nr);

I wonder, have we seen this in the wild?



-- 
Oscar Salvador
SUSE Labs

