Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A65A6606A338
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 16:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LYdOIthY
Received: by kanga.kvack.org (Postfix)
	id C1B626B0659; Thu, 19 Nov 2026 11:45:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF4036B0676; Thu, 19 Nov 2026 11:45:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B09156B06B6; Thu, 19 Nov 2026 11:45:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7F3366B0659
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:45:40 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 18630160B82
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:45:40 +0000 (UTC)
X-FDA: 85452444840.24.833EB7E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3E0B2C000C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:45:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LYdOIthY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795106738;
	b=dGMe8mM/YV0Lu6FzXuWpAhvpC8oZVAjWGsSUz1hfK2CGpMjmjzKn3esdLE3iOPqDoVsPlV
	VeapS1uoFGURdVh6Z+wXInT7KKD8abM45oYYfv0BqvC+ThKqqoEPj4fF8/nK0MaAbDqn/y
	UsR2yixRgj9i4A4+y9A4Jfue0i5Tb4o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795106738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=droRF3Lbij+Y8BnqHPbxoGvs+aJlZy+IqYKUZOyHaLc=;
	b=JjpAYKx8DAz3rcEEUdu4FeLOy3IM0jwZ/z9E6w2nwc2Kd3rlKH67OeEYbPzIictV8NwdaG
	zHDVJuDuOtOEhmIw4Fgksf4Kp11Boaswn6DRK8ZP4yFMFNcn4qpch0S5nXngHsGgJ1aSzg
	IdOPSBjy+ZASzBRHb16PA8I3v1ls6/0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LYdOIthY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 418F240494;
	Thu, 19 Nov 2026 16:45:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FCDE1F000C5;
	Thu, 19 Nov 2026 16:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795106737;
	bh=droRF3Lbij+Y8BnqHPbxoGvs+aJlZy+IqYKUZOyHaLc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LYdOIthYIHWz1yQ5BaDsqC0vczLJ0VVMjDCqY7IBjQZkkI2CxuPTjI5sftcqxV5tY
	 AemuXlWJcQlRFf7XNeXgvYQiSLIvbSf5OXaxRDOYF+9+0pxx1rnTP+8qNxuHu/Ckw/
	 7O5lmDe2N6XrhVRB7gWKoKc9Uey9bwtfXtvQK3MoGeChidMlCIgZc7zjQGoJGhq8hy
	 unFoisFtRyy1gndqj662f+v1aTKTUUoCPL2qAhJV41ubco5T1XwhYB3STLWGTiZzVZ
	 pUhAekavt/d6zgCcPSzip1EHhM4LBWhmweQb+C/FG0bI3Mv03ASTHUmdW5mb3JrUC+
	 V1zD2CqPgazYQ==
Message-ID: <cfe54790-1cea-47f8-bcc8-a7d950bb7c76@kernel.org>
Date: Thu, 19 Nov 2026 17:45:30 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory: don't map hardware-poisoned pages in
 finish_fault()
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Usama Arif <usama.arif@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 stable@vger.kernel.org
References: <20261119134236.3745231-1-kas@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261119134236.3745231-1-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3E0B2C000C
X-Stat-Signature: zmzyyyjq7otjdkpjxksxmug519szsk7g
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795106738-418947
X-HE-Meta: U2FsdGVkX1/qdAT95oG6+Rl/Z3FPuy0cO5jcsGbpc5mv+J2jr5sjFQU9oy9NvjUjek07CicQiIwapLi1tM2iSogvP9K5/oq9tCZYOkChmh46NEL1gT8GGwYGMlgXOt66LwvTq0UwgM7Z6EwpV2LygBmOY6Py7Cnss5RHf670dXNVBpFUMR5lMNquIFP0XcvzkRl6zG5BxnpEiQZGF6JDxFbGUoj9Fong890f3owK4bUCKgzJNvatiIwF1osXd6B0w6Dhq8nuQ7n0ZcAIsHBbd2grBMVymZo3LW8lbe2G+UGiLNjNa6X+l1iM7oN87zlNb8xKVtxfoWJKllbxbFHiFBYbddKJBbyJiMEuObjNm/U5Yh8IOJNIqPHCZLL4ywk640WK9SVPpXK9dr9RH5y5NgEmJrynYLlURO9Loca7fvsPMigxfpcUHslMtI1oSYyU0OVBpRwC5iL3lqW7TcP9Zxu0Mlf7YxT/TQ3ERLR7OgpAjG/89d+TycC6n3wr0I7E9WHaOks6S0cj0wasLgTbNHaraYuwzCciBG6+mj+tS6xZ7Kj7uYU9Gk6rajCbEkmwQN2MSNDvK0k33Kw0uzypW4KyyPyWX7/z98QDt4ubux1BLyoLqxzEZEHD8sB2I1yjd0t3bx6WviK5KJrdKexBUVi3rsHjEw34gMu7lr3RX1kPwmA3RiZCZRWnRXhgDMvYiX2vtMrxr8vUvJwiiORwZ4SBmZ/KWQ1LmY6R7ZkMbxhlhWCEDun+JAvtAaW8y7WZl95OPZSIO8e97JNDgGPDry6EFbibKljYA+5+8gCZ+AdIHuqqL8luZXF62tboo7VmSDjA0aIGYMHpwi9V7HJrNBp8eizrqfDW2I87gyRwgxSLT9jWdHeK5sqpkr1bHZxFfE4fvi29TpEUCRG1lIvMhIWaE5yKX6BXIbv1UXbtSx6BFcCEytq+PUzlIdWEB4uKcV+oWrSuNvH18dbsY12
 v4l3ADuD
 G9TkuX2uO826JPeFYi7OOFzXygk1AKEb1v5TiTrpMycZWlPxz5HrGi9DQaQXPkXdu98IIgIb+lJ59i+m33RMZlU8V3pvbl6xY5KxNrS/V9Vh0PJfksDoQQQ5grt8n5/momws+KDc6EvufX2iUzDcnQLpAqy4hj1HnxA+2C2YDy4cvxj5XkAkPY7Oef5ZePykBEfJfW9df5t8FKpDYzJIvFFixH+yMRsWs7BKSXKUnLPHQqhYFwaXnV+oLLj3XbsAoRKkCyxosUzyApL0zF9rpCrSW+eUG/3hi97nh0ozcPHagoFW8kny/vAEDekFBV+6IIzHjYEJ1meW8TAY3b2wccxkT8dPzR4H1m39nltcOds9lwo6+TKHf98vwoV5PbqK6+NKaR43HbslnSts1UNRBGVs3+RA0QJbz/pB5mGNMiRP7PrgNl5FOeHimNZvOKEg3vmq7NdG9oeH/WO9VWp64EW/ixmZJ1MWAWENbOcb4amlknXxOlIG/SOq4xOiFKeS3O9AfMJZlkNprgNxQOKKn4aZIfAwaYyL0qbf0Fg+7Ap/jK6T5qQ0JrqVqww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/19/26 14:42, Kiryl Shutsemau (Meta) wrote:
> When memory_failure() cannot split a large file folio, the folio stays in
> the page cache with the poisoned page in it. do_set_pmd() refuses to map
> such a folio with a PMD, so that the poisoned page gets its own fault and
> SIGBUS. finish_fault() then falls back to PTEs, but maps the whole folio:
> 
>     do_shared_fault()
>       __do_fault()
>         PageHWPoison(vmf->page)
>           // the faulting page only
>       finish_fault()
>         do_set_pmd()
>           // backs off on has_hwpoisoned
>         set_pte_range(vmf, folio, &folio->page, folio_nr_pages(folio), ...)
>           // maps the poisoned page as well
> 
> A process that touches the poisoned page takes a machine check instead
> of SIGBUS from the fault.
> 
> Map a folio with a poisoned page one page at a time. The poisoned page
> then takes its own fault, which __do_fault() turns into SIGBUS.
> 
> Fixes: 43e027e41423 ("mm: memory: extend finish_fault() to support large folio")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

Queuing this for next merge window.

-- 
Cheers,

David

