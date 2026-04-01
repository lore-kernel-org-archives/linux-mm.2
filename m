Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 754B6107637D
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 14:18:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5A7A6B0005; Wed,  1 Apr 2026 10:18:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B31C56B0088; Wed,  1 Apr 2026 10:18:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A48006B008A; Wed,  1 Apr 2026 10:18:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 948276B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:18:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 60E8113BB9D
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:18:51 +0000 (UTC)
X-FDA: 84610193262.13.F8659A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 875821C0011
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:18:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="s/xN6fs2";
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775053129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kN3IUsatcuTycLS8YiFqTvSt4ZBMelQXdU6lCmPb1Qo=;
	b=fJX/8P5oL66oa8b2cSQRF34HI3TorGXIehvfM8GzDPYZ/JqTRNo3PWKxYp4CyKGgHlMkb4
	S1vNML63qBY9W8cXUuPIWbmZg2KO12gzWULh+cBZV10H9UNE8lXTDmCaRk9d5fUJDOVTop
	dTm0GRW+G4a2GT5cJNcRfZVz/f6kTvY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775053129; a=rsa-sha256;
	cv=none;
	b=qFft8uuofz47KMAbOWgsxlmIXVtjgYmUcTYQtog4atfpOhHHKgUw2YDvAmIF2ydSV2MtZH
	HOFEGEgLwy1xdQApwdDl2E1cCFqU6HCcxfgYWs+H+T8mhXi00wcXnNXN5M+B4yDfpXCbVk
	IEp6/4uXG2rm1XdR+2LXXULjoB9tzz4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="s/xN6fs2";
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9123740AAC;
	Wed,  1 Apr 2026 14:18:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04748C4CEF7;
	Wed,  1 Apr 2026 14:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775053128;
	bh=0FnBo7fPus+XeVOBCwP6OdIjz61MR23nw7pfxfUTbkc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=s/xN6fs2yJMIi75Af4VCjehiyxEZsmoJQ/dqS8ELwDvfWNqLK0Oh0nrpjTi/dZTvg
	 W8EbAq6AKWzEmQx9cBsNJ8X4u+2yVhTwe6VkTA2ZFqutURn2GpBUzcqk+SICdx+jbO
	 WzkE7Aik2pUZUPoFyvIfYTZ1kescvgsDWF6Zo9I3Ks5YaRrg2/BVJp1QmVCOBoF0EE
	 uh55q+/Z/0ouMbPzsc8Qtly3J7sqlD8G7luwMJ2GgUMcYPM+cdB34N/15q5S6LLOID
	 rhtEKxlGOwrR1YwkBYjEe5LOkEGGxq/pa6O+dLRpe1dEiqPCFuVu4G0nrlQaEI1cor
	 YezufykKlly+Q==
Message-ID: <142f8c68-43c7-4a6a-bd2c-1c5ebda09b27@kernel.org>
Date: Wed, 1 Apr 2026 16:18:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/13] selftest/mm: register existing mapping with
 userfaultfd in hugepage-mremap
To: Sayali Patil <sayalip@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, Michal Hocko <mhocko@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain <dev.jain@arm.com>,
 Liam.Howlett@oracle.com, linuxppc-dev@lists.ozlabs.org,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>
References: <cover.1774591179.git.sayalip@linux.ibm.com>
 <b3a1760e4583340e767d4045b90784ee41c8773e.1774591179.git.sayalip@linux.ibm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <b3a1760e4583340e767d4045b90784ee41c8773e.1774591179.git.sayalip@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 875821C0011
X-Stat-Signature: j8zepxej197jhfkauz1ktg71gaoauuxq
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775053129-853084
X-HE-Meta: U2FsdGVkX1+v7j/fT0G7vxuhdGu5O+GHR9gbwtvzIRRwLXsaLjpshKIEcNuPReNIbBnn6I/RYx0OtIm3SKS9oyqk5AVYtzdrlJovWSLKRkiq5+a9ShJKY44xTtmx4P0hzhgyvuhyw4IeDXfSfKXBnqwhvHfN5uD9s57Ta1/HoSKcFsX5+1QXGH5wpypX16hvVUTcRvXnkwx1WwgcVNHJzRbla+az4PYxXsfXyjX5I9kqVG98xwyt8fUtL18WCZxp/TfshI0mHmFeTFuaJ34L0tYRWMXb7fbhVccvrQ6kFDx7aF0LSW55TimuarxZKZ6XicBPHH35aWlfXb7MK0/26LKYkGTDLaphFHQ01n3Us272j5HC5lQ3toGEqG23eBfx1cnksHTrtVRTmO5MAegy3jPlvDVvmHno6y0wDpTLU0sUHJMaDLZzfCzuwTKW5UnuTSL0/X3gB5NpIu7Dc9HLfKvQtANO0VJeGnS6ukiFF/L+cclCAo3vEMs3XFqltcKaVNlLMr9oLEduo0WuFFBIi4NWnzX+Gh9WpiTgxXCGykCYICd1iWyDJ0wRyNpXTCXHLakSkrZFcgSGee7ZMnpLBvux9qPTwrJEIhsjavyv9uqVlc+YnTpoytOXPgSB+4IT9omHP+swtFY6XOo05mUBPiMq8EkaO35Do3vGhfqMzEe7zWnPZvwlQ97TZ5szfZtsUtwpEa7HEs/z1pQdvIXufPGvS8snnBh/MyY8cOJpK27qylhx7/PjyXYA+/KxnD+kvfNmtKAydiBtRsSnTx68AYMRqTdUACRzqrx3xZDxJRwLGYayca9aoOjZfu2oWY8AsmmmmEzmpfm7bylXuzs7QV9SEv7R0vvx0Rs2Z+gdsqlGe2LuUhvfM8gx9CX1iUNe/XqA+b2NiWddfdpr3fOtCQFoB6HOeBqCIhYE0+4T+Dr0neOXFKgSR4va13V8uHfYYHPKYIwGaW4LHIINw0f
 b4Ic+R/K
 qK9FlnOFJraQt92y/MaSI8wTYaNttgq9cR5YApUE/nz8pjrrESUdE/Demkhx+VTcnt3FbFMOm4tkih5qpN8GwbIz+L2J0mZB0elXKnhhX0m7pdrG4vFUoN3ovbsoY7LuQxIvXiDvmJ+hGZBHmRcioEi/ny6hE0JmNQfvEA/DE9FPrkgnfsQO2Tb33OyKSCje5qAcy6QqX3/49MjPrjrNz2qOHD9iK/RPwWIJBOt6sCr3sJlchnoPDKanLpUsgOLXPVV63EUfIiSehAGSoTXHlKgllMVp9yUZusKzPDD4ERriQQmXfrrQOZpouIdQ+hPjXq8V2XkfAazoUlXIbm/icqYROz03g9bCykST0PRkqriCclqgsYAaK6EX28A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/27/26 08:16, Sayali Patil wrote:
> Previously, register_region_with_uffd() created a new anonymous
> mapping and overwrote the address supplied by the caller before
> registering the range with userfaultfd.
> 
> As a result, userfaultfd was applied to an unrelated anonymous mapping
> instead of the hugetlb region used by the test.
> 
> Remove the extra mmap() and register the caller-provided address range
> directly using UFFDIO_REGISTER_MODE_MISSING, so that faults are
> generated for the hugetlb mapping used by the test.
> 
> This ensures userfaultfd operates on the actual hugetlb test region and
> validates the expected fault handling.
> 
> Before patch:
>  running ./hugepage-mremap
>  -------------------------
>  TAP version 13
>  1..1
>   Map haddr: Returned address is 0x7eaa40000000
>   Map daddr: Returned address is 0x7daa40000000
>   Map vaddr: Returned address is 0x7faa40000000
>   Address returned by mmap() = 0x7fff9d000000
>   Mremap: Returned address is 0x7faa40000000
>   First hex is 0
>   First hex is 3020100
>  ok 1 Read same data
>  Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
>  [PASS]
>  ok 1 hugepage-mremap
> 
> After patch:
>  running ./hugepage-mremap
>  -------------------------
>  TAP version 13
>  1..1
>   Map haddr: Returned address is 0x7eaa40000000
>   Map daddr: Returned address is 0x7daa40000000
>   Map vaddr: Returned address is 0x7faa40000000
>   Registered memory at address 0x7eaa40000000 with userfaultfd
>   Mremap: Returned address is 0x7faa40000000
>   First hex is 0
>   First hex is 3020100
>  ok 1 Read same data
>  Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
>  [PASS]
>  ok 1 hugepage-mremap

Okay, so we tested mremap() of something that is not even hugetlb.

> 
> Fixes: 12b613206474 ("mm, hugepages: add hugetlb vma mremap() test")
> Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
> ---
>  tools/testing/selftests/mm/hugepage-mremap.c | 21 +++++---------------
>  1 file changed, 5 insertions(+), 16 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/hugepage-mremap.c b/tools/testing/selftests/mm/hugepage-mremap.c
> index b8f7d92e5a35..e611249080d6 100644
> --- a/tools/testing/selftests/mm/hugepage-mremap.c
> +++ b/tools/testing/selftests/mm/hugepage-mremap.c
> @@ -85,25 +85,14 @@ static void register_region_with_uffd(char *addr, size_t len)
>  	if (ioctl(uffd, UFFDIO_API, &uffdio_api) == -1)
>  		ksft_exit_fail_msg("ioctl-UFFDIO_API: %s\n", strerror(errno));
>  
> -	/* Create a private anonymous mapping. The memory will be
> -	 * demand-zero paged--that is, not yet allocated. When we
> -	 * actually touch the memory, it will be allocated via
> -	 * the userfaultfd.
> -	 */
> -
> -	addr = mmap(NULL, len, PROT_READ | PROT_WRITE,
> -		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> -	if (addr == MAP_FAILED)
> -		ksft_exit_fail_msg("mmap: %s\n", strerror(errno));
> -
> -	ksft_print_msg("Address returned by mmap() = %p\n", addr);
> -
> -	/* Register the memory range of the mapping we just created for
> -	 * handling by the userfaultfd object. In mode, we request to track
> -	 * missing pages (i.e., pages that have not yet been faulted in).
> +	/* Register the passed memory range for handling by the userfaultfd object.


/*
 * ...

While at it.

> +	 * In mode, we request to track missing pages
> +	 * (i.e., pages that have not yet been faulted in).
>  	 */
>  	if (uffd_register(uffd, addr, len, true, false, false))
>  		ksft_exit_fail_msg("ioctl-UFFDIO_REGISTER: %s\n", strerror(errno));
> +
> +	ksft_print_msg("Registered memory at address %p with userfaultfd\n", addr);
>  }
>  
>  int main(int argc, char *argv[])

Yes, that code is extremely weird. I wonder if this was some
copy-and-paste from other uffd test code.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

