Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC300C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 17:10:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 943AC6B018E; Tue, 18 Aug 2026 13:10:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F5256B018F; Tue, 18 Aug 2026 13:10:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BD2B6B0190; Tue, 18 Aug 2026 13:10:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F3FC6B018E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:10:03 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E02E98024F
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 17:10:02 +0000 (UTC)
X-FDA: 85115027844.27.D361897
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 085DEC000F
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 17:10:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i9oH+HrR;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787073001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mxdbgQVht/54cchjqYkheAlWAnzQEAqcDdYfsPmVs6E=;
	b=kOS7uJtgqOUbBk9jOse7uRCdDwRPyZAODbwB333+2F7GXmaTGeSFi6d9UWzbSvfu2DZU/I
	HeLCIEdtzgz9bbR1jwc7dniePOJTDeHP1ur2ksUBpQCIBsCeagkOh3d3QzRMt3dLORUOwm
	SM9UchRdFEhKAO/MOCO0KyGvNDE8tZI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787073001;
	b=bG0uQbMxs/dL6Qzm2+UYO9/NMZ4qJOz7PJ+rx8j1/fyElDVjz5YQB8Z4alYHK+8PzCC1I8
	gxdTlbTaXk1wtcwtvPUQ+ds0XJEV4bYvxIUbaHa+ADLkNBJmhRII/Q/L3QPiW9qqV+I8+5
	VxSifYdIGTH8svbnvSS9YwwmgUAdveQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i9oH+HrR;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B381643D58;
	Tue, 18 Aug 2026 17:09:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 997F61F000E9;
	Tue, 18 Aug 2026 17:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787072999;
	bh=mxdbgQVht/54cchjqYkheAlWAnzQEAqcDdYfsPmVs6E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=i9oH+HrR4ZkLLZwsxqREA+oADHZDxEtQsuGvE9vgVhHZrZa+QiBg88qjS4Jh5PUFb
	 AsYtfq4SFgQbxkW5PvPpKO5mQtvQkoPT29zghABG8bxxfmh73hKMBSSZtHUX3KbVQH
	 VbXPEbLHVj3CpB5gbtnKsbxG9MAHICIBv7Dxq48BEtRoM7tyXSABhPpSVBh0lVB+wk
	 HIQxrymbMoC9g7cJW+OtUdbKllpcnD4RoC51TDYfIbzYGWt2JV+RH2Sl4AaNKk2//D
	 5l14a4blYijmHZKxIXd797sgk9FXxIyrUH6T42zMqU9LTX6wYhrCYGAtm6MTGNMi+q
	 E/6tHgGNSf54Q==
Message-ID: <7e40cdfe-67d2-4ddf-a048-f33b2d590371@kernel.org>
Date: Tue, 18 Aug 2026 19:09:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 01/57] mm: add pte_folio()
To: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org,
 ljs@kernel.org, nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com,
 hughd@google.com, lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com,
 rppt@kernel.org, ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com,
 usama.arif@linux.dev, vbabka@kernel.org, ziy@nvidia.com,
 usama.anjum@arm.com, agordeev@linux.ibm.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 kas@kernel.org, jannh@google.com, willy@infradead.org, pfalcato@suse.de,
 rostedt@goodmis.org, mhiramat@kernel.org,
 linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <20260816224609.308019-1-kirill@shutemov.name>
 <20260816224609.308019-2-kirill@shutemov.name>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260816224609.308019-2-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: f1k1uonbacb8ib8f6tqzom3hgpmd8r9i
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 085DEC000F
X-HE-Tag: 1787073000-276815
X-HE-Meta: U2FsdGVkX1+HGuRwJTinYcfe6vScNkF8rU7PoiquPJE3m3NmqglTN2+ZGCVKwL4iEARHIv7OF2X73VH9VKQfHl9421EXeFmwoFy8T1oDMQxfl//7xPMm8m9O4OsD2FcgoLlY/0t8CR7lIos4qS9kY4VULjE75ovm9mwY4N9n2PAnc6wDWiI6ryqxQWKWtjA/0lJXT6qWTHm4snVqUCi7sYWr0T7VvWGgl5N8ZyurMxvYL/g/7OJyZKZH26/g1XdLoilmu5M++8qTeaZfb9CCAfjqnN7CqgSHmDPfQ+EGMQ8s6VWSq0037UKFlENbvpKOIZM6UbQbjp2zV8JLhsb7UNo8EZFDeR1v+anlOked8h+aM6xSyZJ1SHhkswSfaUJBJ39N97Iyc/3K4/b4SRdwNSmS9sTDV4Apti16hQKXMD1IL6o8XUwn47I1g6rjYiYqOd/Aek5HqVVi68pSLtWfd1ZRB2VmZS8e72Shx5qLR3osG7XHf8OEQoKhvQogUI72+xkowmn01eBt+Q/v+oZQhp9hdoarlvZshapdix4THJDdJr2ns6naHrPUQDxosI086xmsASECgOKmEm+zfv+oWLjEewgjdn1HHHsDQnx83+Fps2gz4WmpniINO+QQB3MPJipR4arUS3Pxiz+8mmlIubdG9aagIWDiOnNxqVaiEeI0MSC++WX2wbH0TkpwtOboA0gfK8HPYUlrP7Y+Ksm8J5EMIQ3w9DEhGGBCLcQpH8zQy+ZE1ouMk5vLmA0dg4nkDLR7sThf1SaZw58dEQvdUfCTgzPuM+43E6muK0Z9//pFCNhPsv6LMYDthCCh4LeNNgVVtEMIwRwZJDB3whyRVquTZ7avFtu7BKBXUv9pKc41FIXjKVAhOuCgPmWWh5b1zHiWBFQs2RyZHlm8r0WlMPbknF6Z6SYoBAJLOh3rdT8GOEUl0gPkSMGKgKguoX/1Is9NXiKDGhEUT9Vfzg1
 fexNAKL7
 TK+yz2cOvANnTOhLEjk9WPHqSG74wKUXiQIAmzGxPJekWg10KcLsLP4ERggcUVclZDIGGBLr4Ns5PuRGw//HhdIcSL0158i+WSpKivYX0JdJ0Rc9jtTvvTmrNWHcFEoLQMNyW1GdQcYtWY17jSU1VMeT87RsUe1LwNBTv1jNDI0omC/Ae+wcASY5DGkxhKjeinGEGFky9Wzqz6xXIO4HnetwhBeH9wmjPQDH8PF74q20eUmTCE4tdONQVwQTKN4VCWqTDx6/+i19vWvRs436wke6joDmYjexSOcb6kPPQ9vA9grMgMM0O9Im3shabdoIJNKFXo4XQHOBISig=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/17/26 00:45, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> Callers that want the folio behind a present PTE spell it out as
> page_folio(pte_page(pte)).
> 
> Add pte_folio() as the folio companion to pte_page(), and convert the
> callers in fs/proc/task_mmu.c and mm/hugetlb.c.
> 
> Preparation for the anonymous collapse engine, which reads the folio
> behind a PTE in several places.

[...]

>  
> +/**
> + * pte_folio - Return the folio mapped by a present PTE.
> + * @pte: A present page table entry.
> + *
> + * The folio companion to pte_page(); only meaningful for a present PTE
> + * that maps a struct-page-backed folio.
> + *
> + * Return: The folio containing the page @pte maps.
> + */
> +static inline struct folio *pte_folio(pte_t pte)
> +{
> +	return page_folio(pte_page(pte));
> +}

There is a reason why most code doesn't need that: because they should be using
vm_normal_page() / vm_normal_folio(), or need the exact page and handle special
ptes differently (see gup.c that uses pte_page()).

And other code that uses pte_page() doesn't really operate on folios AFAIKs.

That's also why you are only touching hugetlb code here.

IOW, there must be a pretty good reason for us to add a non-hugetlb helper when
that looks like a good fit for common code when it's really only hugetlb that
does weird things (and doesn't need the exact page!).

If we really *need* this helper, we should spell out clearly that it is very
likely the wrong thing to use outside hugetlb code.

-- 
Cheers,

David

