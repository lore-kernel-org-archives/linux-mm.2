Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9952606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 10:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mDChAnWA
Received: by kanga.kvack.org (Postfix)
	id DE9366B05B4; Mon, 16 Nov 2026 05:10:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC0E06B05B5; Mon, 16 Nov 2026 05:10:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD7816B05B6; Mon, 16 Nov 2026 05:10:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A98396B05B4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 05:10:31 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2DF4AC05FD
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:10:31 +0000 (UTC)
X-FDA: 85440562662.11.1364643
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8E1F1100005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:10:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mDChAnWA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794823829;
	b=PNn5zUYx40mJdDpKU9+eflKHZ7TahlCUwRtPQN/RN7hLROaMsIvmT3B8Q2BMhA5heRzIr7
	SyKbfgvMrI6u3svhk6adY0rZwjEBwfgr0fl5+xbM5mQg3bqRNpeUZ8W4xCwaViuKEUyjzO
	MAabUPDXnQ5MtJup8UsRNve3FcOV6BQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794823829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JXbbxzTK4STMxlRmt7LCwpa3q0WjlHYEgdFStr3myuI=;
	b=EJ5OisXqYrymFBeQapxydrTDhLhZ0E1gAQ3s16tgu1t80zaI04pir8urGHGo6afD39ki9d
	tox/D12BKK2eDUs6SfHkKjxSJt5a3YHAaKqz0X0a20Viof9FnUv3CdGQmlLdjT9kerhS4p
	fYdDdE2rc5lLzihuOQojjMPBpBEN534=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mDChAnWA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E815F61906;
	Mon, 16 Nov 2026 10:10:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A5F1F000C6;
	Mon, 16 Nov 2026 10:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794823828;
	bh=JXbbxzTK4STMxlRmt7LCwpa3q0WjlHYEgdFStr3myuI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mDChAnWAybrGnG8HbCareJDnR8uYlxFVzdt/PWEHutV/Nu9mlhxDeSVN5z3+uieoP
	 867FCmZ3I5iE2imreP7FBRBUKB5hMORMgEXUcUpkas3sC4KaU9Q/+wmfkEF0B3SzQo
	 OMZGv15rDPhqH47R/dN0GROMD1GDI48+9RqjdObrC3uC2NFm7CKVGfPG1nXelxvmbh
	 w3wY/IAqaVUFR4fsK7UJHrnGVcNrYueDRfW5xfcWYiCfB8nZ379yX/zP4mA1AHXTT4
	 fD1TYp8xdCmpMrHHD5J2pdTfZjyzi8DHOwtymSKOTRXzuS2wLJPK06p9cgYx18/KGQ
	 yxJD18zhnfAKA==
Date: Mon, 16 Nov 2026 11:10:22 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>, Sashiko <sashiko-bot@kernel.org>,
	Jiaqi Yan <jiaqiyan@google.com>,
	"Jose A . Perez de Azpillaga" <azpijr@gmail.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v3 3/3] mm/hugetlb_vmemmap: fix deadlock during PMD split
Message-ID: <avrWjqe5kPfkReIj@localhost.localdomain>
References: <20261114112523.75208-1-songmuchun@bytedance.com>
 <20261114112523.75208-4-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261114112523.75208-4-songmuchun@bytedance.com>
X-Rspamd-Queue-Id: 8E1F1100005
X-Rspamd-Server: rspam12
X-Stat-Signature: wo7pfg6sb7nh6q16jadw55pkkxmit6nb
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794823829-513738
X-HE-Meta: U2FsdGVkX1+ndCEhbo4+rwVlA1hf4iWT38xjtSxzU/lwZQrMx/h/rIS0LL5g+xyu0+POuLOZRDe109hWy0BqGkn9eJSNDg6DK67n5tiEIM2cw8jZh8/4AbEpexbdUIOa+xaycUWhRSPJxo21kz0gzU56/j9fQ2EdQ6QG3zN6jTlkb8RxJT35adCZHD30oJEEZC3tDI3WNLXB6ejJnjYlQovDETZiKZhxgA5zS6FP9TUOfx4JNQFes+81yECQWBDlsKCwVf2PEsaWLi/dIFdtPYZSlsAdV4sTD5eVP/xDB2wNRQEZB8uJPEjrGrTUlU7zI0SxmorwJmkWB3qn/7PGcHiuDU9/OYCnulJbX5wf+YVOVAcYYu0m0MXLGJ+cUy/GAYVQqMuSIMDchkJziyc9LcJID+g44/EMjImY7weJT2Te9SIMfYP7sHN2EVJxyOYcY4bcZMFoB5xMeRfonpz86Ve6H2OVHYHVTQT1YeXNurvSOUq8PxhZNgH8Sp0lGkIelqinRbVbIXS+TXKICOYsLIUH9P1I4Q9/a7jQkHu51a0GMOXzzhcrm4uKX4HPgZiuLXHEMmeB8XDDfakvqPX18jD+Do5kiGaG4BbcjX9wKklvmhLndZFNWOknvWYp8HeAfBFN5p1e6dPdNYb8XWKfCOkrNFOKxXFZriz8U0Who2q6sRSfZEBp8vN/Qwxrf9B7fZDlEJDlF8JBrXvDEPhILSWhoa8D3rfxM/U4onCKAsGTrPr3lB57i6QtmJ45gVN50LeDB5/a+xDuSmOkNbsd+zMPEgMOI0rwyt2Ldrhk51befU8hzcTB322ZqT2hzBxY7jsRkr5otCKib6BgJ/D6DaFWy1kwq9f1yC3ydHMnevr4YpEP2G/mvyQpvdQxbPS8ZMVdmULn0W7xki1X2MRvFK6LhUU/v1JBGZ59tJbJWz0MM8S5+VjQwPkUmhUZEBdxwa9Y2RvIpcA+N77pqDo
 +DRek0ND
 c4yoKgeNAwMbryQQftfMbxwITkbM/H5C2f8qa4XXO20lJefAipaelswetyeXUlItZh29HiRWIPKFJBxdqvUZxzAVCeCO/ZfrkXvGujTu46yJTEQOzzhs09pIYrXu5rZbJO/B85P5L2pQqZtnLfLKAHF/EOVHkDqdcVqP3IxYB0JDBm1cfWWINn8fJkgjVq+A4FonLIyU6qIEIFgwhO7Xu1zc3mhoZEijGBeSTTk8+7AWBcuibON2dEQ1Z4iCARv7zE3XwFb9yxDHE/rG63748Nx1kA/zNc/CT6egrRDZjGfWs3iiL9rgYicQKmpzcJ/Y9XxP+XBm35CWAHUUXvt8e09h936MgyrKhRlr+9E4cC/c8J+qavwMf3EuvE90va9uw+L0CjKrHhIt3AdeJcoAebWLMHwsg+dGda59ZWXfrVzO6VqPwUnKVufxFsrnoR2aEItTV7elokl7EbVr2liI+Sv8PjQbypxEIYsGFY7pcRjXaEGWd7zrAwhqKnE8RbfVc0PTNiR1QrRYgH18muMOONDJHfQhNK1pO6iiGsvAeJvS3onI7x4vgXD0mNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 14, 2026 at 07:25:23PM +0800, Muchun Song wrote:
> vmemmap_remap_range() currently walks vmemmap page tables under
> init_mm.mmap_lock. If the walk reaches a leaf PMD, vmemmap_split_pmd()
> allocates a PTE table with GFP_KERNEL and can enter direct reclaim:
> 
> hugetlb_vmemmap_optimize_folio()
>   vmemmap_remap_range()
>     mmap_read_lock(&init_mm)  <-- outer read lock
>     ...
>       vmemmap_split_pmd()
>         pte_alloc_one_kernel(&init_mm)  /* GFP_KERNEL */
>           <direct reclaim>
>             ttm_pool_shrinker_scan()
>               ...
>                 change_page_attr_set_clr()
>                   mmap_read_lock(&init_mm)  <-- self-deadlock
> 
> Since commit d5d8b8662e6e ("x86/mm/pat: Acquire init_mm read lock on
> attribute changes to avoid UAF"), reclaim through TTM can enter CPA,
> which also takes init_mm.mmap_lock. If a writer is pending, the nested
> read blocks behind it while the outer read cannot be released, causing a
> self-deadlock.
> 
> HVO walks vmemmap ranges whose intermediate page tables remain present.
> vmemmap_split_pmd() revalidates the PMD under init_mm.page_table_lock
> before installing the PTE table. Use the lockless page-table walker so the
> allocation no longer runs under init_mm.mmap_lock.
> 
> Fixes: d5d8b8662e6e ("x86/mm/pat: Acquire init_mm read lock on attribute changes to avoid UAF")
> Cc: stable@vger.kernel.org
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://lore.kernel.org/sashiko-outbox-206969@kernel.org/
> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

