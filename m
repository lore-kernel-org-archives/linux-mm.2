Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47328CD5BAC
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 10:07:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9504E6B0092; Sat, 23 May 2026 06:07:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 900986B0095; Sat, 23 May 2026 06:07:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EF3A6B0096; Sat, 23 May 2026 06:07:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 677096B0092
	for <linux-mm@kvack.org>; Sat, 23 May 2026 06:07:48 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F180093741
	for <linux-mm@kvack.org>; Sat, 23 May 2026 10:07:47 +0000 (UTC)
X-FDA: 84798258174.30.6FC87B9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5D85E80002
	for <linux-mm@kvack.org>; Sat, 23 May 2026 10:07:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ee3Xfjg3;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779530866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rlp1W5vNBlur1QwehE++yDLWhSdLhgpE4g2TYJr/Zrs=;
	b=xt1MYnxbvMWqTkwUpGWKX7qKWVUAW5aE48NUwDc4cNelD+/4SzpESF/Z4wRMTAVzrcNzgG
	Zrkqx8zz9u/jLk0aPwcH3gFc9oX+E0b2rAjwpIlV+3LcmhbWpCqojrvnX+gQ6pA4OvoAnM
	lFm7ANbaWHfQq/AG2uZ7t4gExNzT4jc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ee3Xfjg3;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779530866; a=rsa-sha256;
	cv=none;
	b=oZBSKYf7zy7gNhm8xTPwGJQjzb/cgFsRfA4MTyk3NNf7xm1dDBSJw9EJx0VhFc35CNqpC8
	44mgyQP3NHPipSEW2lHLbBloWmFTLQOuzNqPOkat0e60fwiYThbEZ9y6IAIoLOcQkqFYco
	3a/Rdzfk+J57TjcHiWWUvGkrFieuRkg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 71A7644234;
	Sat, 23 May 2026 10:07:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F9761F000E9;
	Sat, 23 May 2026 10:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779530865;
	bh=rlp1W5vNBlur1QwehE++yDLWhSdLhgpE4g2TYJr/Zrs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ee3Xfjg3pkY/QBkGfqwUl/vlMPnivycAtzymBvtjnZlKjBwxVCWthpEyBYipSSzTT
	 7Hb3ZNH2kOFCKNE3qtCT+9Nr7uZYAGjCHz6ZJfQUi7JyzveC6qdztm0snhCDnnwNs7
	 JCbpv3KNt8AjX+bk84DtiNth6Rg2BdxiP255GajZCvs1fUmt5wjkw34YEykxmjF2mV
	 KcNcTpDapcXZJUh5tth7qD6xH1H5TIORh7sCj9pBmJqolBHW4xuMlHJFSh0CYr24NF
	 aCoObYVnef10OiEUycg02dD9SYvFNY7wMVyYEERHahhqBOpYbYVV9y77qAu1rHLjzC
	 ATNQLHXLaQDGQ==
Date: Sat, 23 May 2026 13:07:33 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, peterx@redhat.com, david@kernel.org,
	ljs@kernel.org, surenb@google.com, vbabka@kernel.org,
	Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net,
	skhan@linuxfoundation.org, seanjc@google.com, pbonzini@redhat.com,
	jthoughton@google.com, aarcange@redhat.com, sj@kernel.org,
	usama.arif@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
	kernel-team@meta.com, linux-man@vger.kernel.org, alx@kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: Re: [PATCH v3 13/16] selftests/mm: add userfaultfd RWP tests
Message-ID: <ahF8ZeErzcEp57Pw@kernel.org>
References: <20260522133857.552279-1-kirill@shutemov.name>
 <20260522133857.552279-14-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260522133857.552279-14-kirill@shutemov.name>
X-Stat-Signature: srfcyhc6b1g39e6k49f3b1z94y4my6mm
X-Rspamd-Queue-Id: 5D85E80002
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779530866-744177
X-HE-Meta: U2FsdGVkX1//MDqaajlADTDocCbDKQe89NII6BE6OwNw4aCatHISGZezPcd6MgVQfucs8i/ed615yg8JAJaHfMB3lXZMrKmlH9KCTjrWczmzo5AqCvWtoWpf225x7aIs4VIURzSwClwO/z0FP81xaHO8PQzBPwvPpMXYN2KvOgSAT0dqbvnIjN8dV5nxEL87raN/QbIBOygYlWWPqjk08jEwxOLfE4hOMUyrl5uwkK9NADlXLcEFlM6d7FiFirWhKQOuhikdrojlNp3h+26YBdlOShxSG7S8xe8PXcmqMT6M369AIy1cuXQ6KCVaU+tSBHwDhmEFSQgwBgPm3qHu1UEi6nf9zHV8/9xw0XOX4kmZhKLxBajcqSCng/yC7TVrtAUvd01cronoewLgqXOE/xrXrdetUES9toIxGZCm/4x3EU/hkhAazwflP2zaluFY9D1QX6jL+9mIFTqfB5szxfbNxD3xe2V9Guz6Mdg8v+cDVgjVIv3k1DvHRPCnybbIhZ/DSzDebSOvdU213rsLQ3YhRGkDI+G3sufZqDH2GH3hbmpENoeqqC8evFPcvESCUp1egd3L5a1WuPDGsFq1KvEDy0/o6o1ks+ItbXUlTLhaHLNS1yVPeel3cKq4rX9i4656AlHoZ0UQcwKhek9cz0GdyxDngY5BtaKGI7gSy13YzlFAjvcDLw4hDjmMrKMEyF8t4PNVnpaoMEsmlXPdmi9DVMyFnaLA6o9nUrCclP8q4wnmGOBtxDSqZ/iXnyyzAHdX5jhI+3ReASfCFOTLcxcv3AKDQfvhQ4TxirLO5aP/h/wFxl2l3kTujXNaWQIOEu2bppRxTlsRiek0yN9bnEl9ugrEGH0olGqZ7j0jZoMR1PAZCHNDC3xgpsr/VkGA0QwbRf2r53oAj6VTIuS2BDkz1zYy8D26oitF+lK8ZpT5OXSmCX5u1isUql8j7NQh86bbRmVZgk8HWCralJ3
 vkPq8yA+
 YZ4duzJsZUG+PV6yNrm0ATDG2Rn9rhfror1DFhB+ds8NaizbptzI7EJCWkQ2Zns319a1GF96tnfK27F7qS2u6xw5D5AFcwkIOSu/CnRN0Dy3UyX5VvIBLxr4PpT1YC47Ob/vQ3cLiSbbQEsn5gp7Nicy305npBtzqbHqEDTnsIOfYEviRef1QifpgxGPKcVrtAyhmiPB3m1KVTtd21gnpvgGEZ/8F0tLNXrr5BZG8AQYGQDk34rj5RYjqqQARWF8/OCQyRw/4DpKgch4BxOxno5pc29SrvnVvcaX9VY18ASVl3jI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 02:38:54PM +0100, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> Coverage for UFFDIO_REGISTER_MODE_RWP and UFFDIO_RWPROTECT:
> 
>   rwp-async          async mode — touch pages, verify permissions are
>                      auto-restored without a message
>   rwp-sync           sync mode — access blocks, handler resolves via
>                      UFFDIO_RWPROTECT
>   rwp-pagemap        PAGEMAP_SCAN reports still-cold pages via
>                      inverted PAGE_IS_ACCESSED
>   rwp-mprotect       RWP survives mprotect(PROT_NONE) ->
>                      mprotect(PROT_READ|PROT_WRITE) round-trip
>   rwp-gup            GUP walks through a protnone RWP PTE (pipe
>                      write/read drives the GUP path)
>   rwp-async-toggle   UFFDIO_SET_MODE flips between sync and async
>                      without re-registering
>   rwp-close          closing the uffd restores page permissions
>   rwp-fork           RWP survives fork() with EVENT_FORK; child's
>                      PTEs keep the uffd bit
>   rwp-fork-pin       RWP survives fork() on an RO-longterm-pinned
>                      anon page (forces copy_present_page()); child
>                      read auto-resolves and clears the bit, proving
>                      PAGE_NONE was in place
>   rwp-wp-exclusive   register with MODE_WP|MODE_RWP returns -EINVAL
> 
> All tests run against anon, shmem, shmem-private, hugetlb, and
> hugetlb-private memory, except rwp-fork-pin which is anon-only —
> copy_present_page() is the private-anon pinned-exclusive fork path.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Assisted-by: Claude:claude-opus-4-6

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  tools/testing/selftests/mm/uffd-unit-tests.c | 766 +++++++++++++++++++
>  1 file changed, 766 insertions(+)

-- 
Sincerely yours,
Mike.

