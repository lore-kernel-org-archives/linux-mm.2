Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57B31105A591
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 12:46:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2E646B008A; Thu, 12 Mar 2026 08:46:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DB2F6B0096; Thu, 12 Mar 2026 08:46:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E71A6B009B; Thu, 12 Mar 2026 08:46:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7CE8B6B008A
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:46:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2B4D71401E7
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:46:27 +0000 (UTC)
X-FDA: 84537384414.11.03E9736
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 54A35160007
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:46:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LmCitdoM;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773319585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pSVUnbqBoh+e50vqL3FsO0vfZ/QPKzwAS3aajmmAfGE=;
	b=RjMuy3yCWGQB1qirsT8MqU4WgE/eDjX7KAHQDDTBbOw7SGj1cM1uhqLzx6lJbHgpy5OTFI
	PBWzi4DPSUYl+0CseQPuUdnL2ECSkD4LecvC72/uf+BWQcFoHS/D00Wjnr7qqsGGHbxSxG
	zFbWjIYvlXQ5HB62+dWAjX141PD+Yu4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LmCitdoM;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773319585; a=rsa-sha256;
	cv=none;
	b=IskyQ8FdOTu4VRUqnRrsK3onG5H/0K7syrNrUabBIKPCWvmH/ziAmCckLfUP2+7b1ESGHc
	slB6k5tSz4cRrcsUs9qKlQzyjQjoSS8rUZOV9p1+3n1Q88qv4C4f53tTQCbIuuqmnhx8Ci
	iDrNcqzJjQNkqP2aEACcN7HNfKZaJj0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 36B69432A7;
	Thu, 12 Mar 2026 12:46:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A5F6C4CEF7;
	Thu, 12 Mar 2026 12:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773319584;
	bh=20CETLvjxD3z+mW9Z3ubspvxhFteql+I+VlzbtPBQyw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LmCitdoMcHqTnvQU+INOApLZaqDy4HXuWxSaIqLXfAqbitAIu1fyUb+4JkelvePJa
	 KZFLAceFbpytteLKErnKIwYMITurgWszw+f5PJ4iz9mhgjBv7ZW5vU82jHmkhNR62k
	 L683nSexvZo6jWxdemjVfqrSQaxglYWSJ6J4tYiMjPrLOpcOOw3XarTASdem1c/adq
	 LFCmvwdifqj585wxkch3ebML/B67qao4kRTUNnLbi7CMxZOz/CbY72Y2kWcSDwq+FT
	 xqVc3znHEkN9To4K0GkysibGcLFPCk9B//rnyQamhHo/5to4z7lOu+6IyHgZJFiQzx
	 8F+c+l0gARg5A==
Message-ID: <c2a1adb3-7078-4979-8eac-579d86b3f244@kernel.org>
Date: Thu, 12 Mar 2026 13:46:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/13] selftests/mm: size tmpfs according to PMD page
 size in split_huge_page_test
To: Sayali Patil <sayalip@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, Michal Hocko <mhocko@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain <dev.jain@arm.com>,
 Liam.Howlett@oracle.com, linuxppc-dev@lists.ozlabs.org
References: <cover.1773305677.git.sayalip@linux.ibm.com>
 <94c18dd26cf88f10b4b496cb3de08d81439a8909.1773305677.git.sayalip@linux.ibm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <94c18dd26cf88f10b4b496cb3de08d81439a8909.1773305677.git.sayalip@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 54A35160007
X-Stat-Signature: k4ofoftn6ztgzidcfdqrfjethtt3dfn6
X-Rspam-User: 
X-HE-Tag: 1773319585-719334
X-HE-Meta: U2FsdGVkX19KqWUlgwbzFTG/uogGln6c+syC/+/TihnEIDTBUQ4qjAknnVWpPQlNN4/2RtpBR/N0fjvr3FtoqzaAKN3rAGkq/EQCfs5QbshkMEFUevJWvtIqCHbW9j+DEcovpWrzHxhILZIdChqRq2M6U5WL+ZfnbgZRGbrUt+m94d56KX9KSBBtepPxPt3Bmj4sX2VmhVgjfMq+tRcqKHljOWmI2UfzXk1NdBbTGDG/tK7pf3j/uvlrKZZGpEmfdfy68fSiTC2w5SdY5kBTQvVy7WWLXb2BbgrdgojOBeDBKND/ugVr6miJzSdzbSKtpRZhtvnypWup4IKnlrLLwUcsTwWxZM427cPVXUKaaX8BWZHxX84XpqSn58bCui597oA4hWETsipeuLPOsKmCmQwISqOpXhTZLUSXseH2PKi4CtkWMRH6rVYmC5Y68JBpt3vXFSXSPgIBUz8ULmDqwdE4Fh2SqhaFXSc+0r5IUaHOneOZqEpcVGE+7R8LtmxXoKRA6MAnRQ4zCXOx19FTPfiyeQ96sZwwJiHjF2uP6Zta+g+9mjVVYAn0VDM79RfPBKS+d+nHy10gqogpQBolyzQq31JGfpaURMlnAWwJG3uCuIga7zhUPkrPkf3j0pPoaou0sP6JfjTjTx1Jrq7GyqHmOoXm3uIoCvLF9srMd9CBPEOyk9H+7wUFnDyHxmHo+LqPKC6LOtfIkcNYCJHd5TUBI765sh616TgUoJ2IMmqXTQzgoQ9Ntwfk8ZP/QYNP5wCTh+doqCubL1LqGqcfsukBpf/kPYLvgbHCpuiw3aygj0Uyqdwku1/Ziw797ElNBJ8tJsWO2KGBtDZHiX2Zxagfsl73QsJfkjkkb3eQ6R6djKNNYjydoKGW/UL8KSJzPB6zQlo6E7JPLfQHqo9vYXBqcz+meuB9vCRbA0FFZsPIX12mcfLtbCjKFJpMuZvGYS+LyQfcGn2fSMhoXEh
 jg44j3AV
 8QL+1D0AxBZ9ehQLwssNflbUAuuYMFKA50uEbb7xl3bT4iA+fofglKVcuH6PYsH3ViABBvKKGNhCRwPjWUq8F63wlGzLo+14RiJ2A4xpbYCKBSvqlKVfzjUCRVajbdLdyhZ+5Cw3xk76p1jbcCWgRnWq2gqGtp62cmHsZEMF1ndsyWzEfGWk/Gw9PLmdb4sZkasKZs0sQzmjp7tylmBbTi2TFcPdg2tbW390kJt/sLyblvlBTcSEBd9wqXdvHgUPDg0FhiI8mJOEprzI7yR9G0gsNDRxcTbkJO9cPfrHSduKXCGfwWzoPBjmuToHIJZjPyn7UAALJcV+VKkf03aKxzJoQ5yjKwSK3BSP7KmN8CRImefQPrIrpXCQmQaDoXb8BrzOtJg92D9NqqCDjhXf7/6zHkoZLeD7ONjiMk4o8/tF5t73uVYrIjI0ilLSvVR/aLhjq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/12/26 13:25, Sayali Patil wrote:
> The split_file_backed_thp() test mounts a tmpfs with a fixed size of
> "4m". This works on systems with smaller PMD page sizes,
> but fails on configurations where the PMD huge page size is
> larger (e.g. 16MB).
> 
> On such systems, the fixed 4MB tmpfs is insufficient to allocate even
> a single PMD-sized THP, causing the test to fail.
> 
> Fix this by sizing the tmpfs dynamically based on the runtime
> pmd_pagesize, allocating space for two PMD-sized pages.
> 
> Before patch:
>   running ./split_huge_page_test /tmp/xfs_dir_YTrI5E
>   --------------------------------------------------
>   TAP version 13
>   1..55
>   ok 1 Split zero filled huge pages successful
>   ok 2 Split huge pages to order 0 successful
>   ok 3 Split huge pages to order 2 successful
>   ok 4 Split huge pages to order 3 successful
>   ok 5 Split huge pages to order 4 successful
>   ok 6 Split huge pages to order 5 successful
>   ok 7 Split huge pages to order 6 successful
>   ok 8 Split huge pages to order 7 successful
>   ok 9 Split PTE-mapped huge pages successful
>    Please enable pr_debug in split_huge_pages_in_file() for more info.
>    Failed to write data to testing file: Success (0)
>   Bail out! Error occurred
>    Planned tests != run tests (55 != 9)
>    Totals: pass:9 fail:0 xfail:0 xpass:0 skip:0 error:0
>  [FAIL]
> 
> After patch:
>   --------------------------------------------------
>   running ./split_huge_page_test /tmp/xfs_dir_bMvj6o
>   --------------------------------------------------
>   TAP version 13
>   1..55
>   ok 1 Split zero filled huge pages successful
>   ok 2 Split huge pages to order 0 successful
>   ok 3 Split huge pages to order 2 successful
>   ok 4 Split huge pages to order 3 successful
>   ok 5 Split huge pages to order 4 successful
>   ok 6 Split huge pages to order 5 successful
>   ok 7 Split huge pages to order 6 successful
>   ok 8 Split huge pages to order 7 successful
>   ok 9 Split PTE-mapped huge pages successful
>    Please enable pr_debug in split_huge_pages_in_file() for more info.
>    Please check dmesg for more information
>   ok 10 File-backed THP split to order 0 test done
>    Please enable pr_debug in split_huge_pages_in_file() for more info.
>    Please check dmesg for more information
>   ok 11 File-backed THP split to order 1 test done
>    Please enable pr_debug in split_huge_pages_in_file() for more info.
>    Please check dmesg for more information
>   ok 12 File-backed THP split to order 2 test done
> ...
>   ok 55 Split PMD-mapped pagecache folio to order 7 at
>     in-folio offset 128 passed
>    Totals: pass:55 fail:0 xfail:0 xpass:0 skip:0 error:0
>    [PASS]
> ok 1 split_huge_page_test /tmp/xfs_dir_bMvj6o
> 
> Fixes: fbe37501b252 ("mm: huge_memory: debugfs for file-backed THP split")
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

