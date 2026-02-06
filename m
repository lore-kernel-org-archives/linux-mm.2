Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB3E1EE2086
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 10:35:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 076326B0089; Fri,  6 Feb 2026 05:35:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03DA56B0092; Fri,  6 Feb 2026 05:35:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8F2C6B0093; Fri,  6 Feb 2026 05:35:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D9E276B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 05:35:40 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6B0AABB77F
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:35:40 +0000 (UTC)
X-FDA: 84413675640.18.1202A01
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id B5CC51C0006
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:35:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S6dc09FX;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770374138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4czqeyVzZFqORwxkZPJ6FeK4SXUOnKTabOL2zCBYWVs=;
	b=cSAbr/M+V7d+pz83qVK6hEf0yXoepEa1Er0TdGY+Mdx6+soUbXNO1pt+LTswwD/HwiVKTT
	zkwmpHSiIdW+FUWHGZl8BTHKLz+VsAveqn23+mbp4t2HSWlGZN7RiLhIhNSgdFBmwRvku+
	SkOEuTMSjXoORJ1DZvCcArnqarKZviw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S6dc09FX;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770374138; a=rsa-sha256;
	cv=none;
	b=dsoqtfW4YljvkZ8A0rPl7UUJpO25Zk8/gjM3i5o5OKOjj6igCr+NpUXKl6b+5AW1AyMFf+
	at6g173p1h3jNnRUlMY/IE2s+zrG6o4qV+x078l9MT0Ui7vzDwD6jd9hh4ZfiYu7KIvhfg
	2QNgqGpgOSAo2F8XhIPBktMV1itXdhs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E532860010;
	Fri,  6 Feb 2026 10:35:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ADBFC116C6;
	Fri,  6 Feb 2026 10:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770374137;
	bh=4eHKEhmEK8xsEIAIBEaQ/Y5Lb5Y5nnEuAYz1Q4HZ+SU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=S6dc09FXA/oslyvgU5XYJDzbCDyPHsKVIty3YtaZStxu0DwL5tirjTKmYgh/T9eCa
	 MlLAjkLZP2A+XpbtVzHQ5Hz16O2G1paaoIzPh2aoh42Kpm3eyzKze2jUxg0BBedXS2
	 s0zLAKQGkVIYs9iA7x4O3L+mjVW6FOgKEcEJkqoHCqohjarOqhC1D2k7FP3EF/jaRQ
	 tzQLNwDlYLIgmWgUZgs4ly60PYVii+9ZTKLF/Xl5C74FJwKJ6isZZy1sDvMWNNjura
	 pNWziuoPV3Q2aXliocKXSW2xjWG7kteH3CBWMUYoiMoM/1nrnYcrBfDVRyjSuuWQQ3
	 C+or9FiaofU8w==
Message-ID: <bf413c9c-eabf-4eb7-bae4-947dd7e012cd@kernel.org>
Date: Fri, 6 Feb 2026 11:35:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6 16/17] hugetlb: Update vmemmap_dedup.rst
To: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-17-kas@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260202155634.650837-17-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: dy789qy3cg31na5o1itcctmd7rx9qq44
X-Rspam-User: 
X-Rspamd-Queue-Id: B5CC51C0006
X-HE-Tag: 1770374138-437865
X-HE-Meta: U2FsdGVkX18R9MJDiyDE1WrcxzaYk3QgYzeOVgVwXIbdVWF9XwBjGCWVVIDaJXNMUcrMzbP6Y3yJVlTNR5bIrwQnnTmmDRDuNo7r7ASWa2oDd0gN9Yve7ehaJTMee2NFOt39h/I+r1JicSAHV+YDDHuj4jqhTD1HW64b4O2BwSKY5yEJEI3of7ztVn2vJEBqOjbCErRFdtAhk0iFTf0i/5e9Q1DV2yze+SWj08ajFXfCQZl/1LkmnxU9UxabPZWNO9I3QRSsRQZ6F91uDbQRXr8hFbpJb410J8MA6qcBfok5UPafT4teYhoAXS3YbJD/qJjjrPLR897pP4wh4fzxwZMH75ErpaS8naEFOMdzf2hwPNdSJb3/vQltmuy+cAhU4/7VdB/4eUL1H779IucgReOp9dY+FRzYwLF3qrebtNqAaELIJS5g3LZu/dOg7Qjm/VZeb9Z6NpBR7xkqqc1sZ2gVQ4Xb61/xXdz20vdXbaAVXWfQO6T6eJ7nly0NtWQf/QKiL/Lxca8jay4lpg0H0QlOh0fjw/r5iY+4yR0ygDH/Pv+eMKeIA9RBRUUGNIg7c/Sz2xKoTa0JYYFKZ7x6ZozqiSiN8DOFPc3+6VV6HAlRSohlhrceQhuQsg+mEkaUtmjiVCLkXEDa+lsiLNBnMgRyf5JZti/56j87mtLbhtoh2rH74T+thhfgcnRg33cVOs2JN+UoFobg1wEzmgPL1FhPDPgkgvzVjcUpuAiz3r1Uxxo13F2e7a0MDSnXqJBlK/JI6VtJj130OxbZNr4nLRlZfdcvjmAkhevVzsTY+lEXYhBPToAIWHwfAReU0fuk1cRffUem/R6ckZ0VExelP2rfgsUqpaIDKGt2ZDfJs9f+Y59c7WVh0vcH6JKnH+t+Qar9BgmCe/BxZhTfvWokrfMR078ca+joM7oBs8JKIVu1+tfRxXVaFRzhnBHpMJrOiCpko4CXd7Vw1rHBrT/
 tvtPg+Bg
 xxeB1amwTLh1IFQcZ6ZXHar6bqc/WYP6isnZQMXqpgqQ8gociJbjoBa2/46S3E0/TiuTWd5WLtxrBk9luENPGQyBjNdxCMpF47odn7AQxjbcpBsNuB9Sgpd7vEclLJiMmNvliYSoHupVDUrpQCEp4IKyCdCwVWoQBrWLJ/dzSV+P1S7wiLqyVsDYt/2n2+DhURJYdRDGWkTaFBawhUlbGy62u9kwVA6dvzNdyr3KC6YkW8n3CeVuXJ9L1oUgZ3r1nnAp4PDoelrfDVr0X+t5pH9Da/S4BbqdKErCOnNkdn7mTZZBi7TG7w0lXiAa5vkmp9P15258mTU99x8w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/2/26 16:56, Kiryl Shutsemau wrote:
> Update the documentation regarding vmemmap optimization for hugetlb to
> reflect the changes in how the kernel maps the tail pages.
> 
> Fake heads no longer exist. Remove their description.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> ---
>   Documentation/mm/vmemmap_dedup.rst | 60 +++++++++++++-----------------
>   1 file changed, 26 insertions(+), 34 deletions(-)
> 
> diff --git a/Documentation/mm/vmemmap_dedup.rst b/Documentation/mm/vmemmap_dedup.rst
> index 1863d88d2dcb..fca9d0ce282a 100644
> --- a/Documentation/mm/vmemmap_dedup.rst
> +++ b/Documentation/mm/vmemmap_dedup.rst
> @@ -124,33 +124,35 @@ Here is how things look before optimization::
>    |           |
>    +-----------+
>   
> -The value of page->compound_info is the same for all tail pages. The first
> -page of ``struct page`` (page 0) associated with the HugeTLB page contains the 4
> -``struct page`` necessary to describe the HugeTLB. The only use of the remaining
> -pages of ``struct page`` (page 1 to page 7) is to point to page->compound_info.
> -Therefore, we can remap pages 1 to 7 to page 0. Only 1 page of ``struct page``
> -will be used for each HugeTLB page. This will allow us to free the remaining
> -7 pages to the buddy allocator.
> +The first page of ``struct page`` (page 0) associated with the HugeTLB page
> +contains the 4 ``struct page`` necessary to describe the HugeTLB. The remaining
> +pages of ``struct page`` (page 1 to page 7) are tail pages.
> +
> +The optimization is only applied when the size of the struct page is a power-of-2
> +In this case, all tail pages of the same order are identical. See
> +compound_head(). This allows us to remap the tail pages of the vmemmap to a
> +shared, read-only page. The head page is also remapped to a new page. This
> +allows the original vmemmap pages to be freed.
>   
>   Here is how things look after remapping::
>   
> -    HugeTLB                  struct pages(8 pages)         page frame(8 pages)
> - +-----------+ ---virt_to_page---> +-----------+   mapping to   +-----------+
> - |           |                     |     0     | -------------> |     0     |
> - |           |                     +-----------+                +-----------+
> - |           |                     |     1     | ---------------^ ^ ^ ^ ^ ^ ^
> - |           |                     +-----------+                  | | | | | |
> - |           |                     |     2     | -----------------+ | | | | |
> - |           |                     +-----------+                    | | | | |
> - |           |                     |     3     | -------------------+ | | | |
> - |           |                     +-----------+                      | | | |
> - |           |                     |     4     | ---------------------+ | | |
> - |    PMD    |                     +-----------+                        | | |
> - |   level   |                     |     5     | -----------------------+ | |
> - |  mapping  |                     +-----------+                          | |
> - |           |                     |     6     | -------------------------+ |
> - |           |                     +-----------+                            |
> - |           |                     |     7     | ---------------------------+
> +    HugeTLB                  struct pages(8 pages)                 page frame

You could highlight that we allocate a new head page like "page frame 
(new)".

Wasn't aware of that detail before reading your change above.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

