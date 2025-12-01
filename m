Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40949D116F5
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 12:49:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3923C6B002A; Mon,  1 Dec 2025 07:49:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 369C36B002E; Mon,  1 Dec 2025 07:49:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A6696B0032; Mon,  1 Dec 2025 07:49:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 17BC36B002A
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 07:49:10 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B3E988466D
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 12:49:09 +0000 (UTC)
X-FDA: 84170882418.29.D2905DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id EA12840008
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 12:49:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="W/Isj3Cx";
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764593348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/h5icUtZy/F8cN4qA59QW8sRenCl3qR2MEDGHg2qtac=;
	b=e6KuxxOnxxfkPF9CM0ha8ph4VflNvgUPxAvOi3OyJejE8F0wWMWnxUDmqUd64KQNBMjWmL
	1gDZ2d+NvDuUcbf9wSy+iT0chsYmRMRHWTbDuNo1VqlBtrXmCG7ew10NfQ7XFfmSiKZI7D
	79B9m212GnJn6IWGu+F7yC73K2ZBisg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764593348; a=rsa-sha256;
	cv=none;
	b=S151exWMGrIZiSUHSbafaDkFLB+gptlwPphizzQRiMg3b1Fcdb4/RHRFE5iCyaDleMslCA
	eARks7qHOkcUxCnjdaWEj00XcKlKczDxzS9MGud2RxMG1w/jjJEopQlBjOsWzS4wZs7sXn
	H9HadPjEKyF0tLpDIl1fN8FOhmyKX4U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="W/Isj3Cx";
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AFD3C429F4;
	Mon,  1 Dec 2025 12:49:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF1DC4CEF1;
	Mon,  1 Dec 2025 12:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764593346;
	bh=+7oXb1SclDWbxrHa6PG9V563IhGawyj/xgpPtohGwRw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=W/Isj3Cxrf0BraGdfDYg9HE9ZDnuflCOm8jrRUPmJhY01CfYqLBFAod9ZHdm5Lse5
	 u49yx2LgBItxuZMtwIKIsf+WHW5D5XuqiC2n5jaJOlziJmhOr3OaFR3by7MHblnFp+
	 LOunRYZC8KJfIUct29XhRZYGh1NsP6uckQ8EQQxG4bjxP/iIlKW3HbgmA7E9A63R7g
	 5FN9Gjkn9wkdZLHpro27bJbXVryq6ECxqt7DtVLOWjnuu2UwbhovgN7YlhXhvM7EsW
	 n480PyZ992/7doXkwQTOF3bNXvE71jTlikee2lnQB4YWyNwOwjf2Mb7MKtPUZaBvTB
	 gn8TistKDv4Tw==
Message-ID: <26a66461-c06a-4c86-b597-52cdfb05dc84@kernel.org>
Date: Mon, 1 Dec 2025 13:48:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: fix config option typo in header file
To: Lukas Bulwahn <lbulwahn@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Alice Ryhl <aliceryhl@google.com>, Pedro Falcato <pfalcato@suse.de>,
 linux-mm@kvack.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
 Lukas Bulwahn <lukas.bulwahn@redhat.com>
References: <20251201122922.352480-1-lukas.bulwahn@redhat.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251201122922.352480-1-lukas.bulwahn@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EA12840008
X-Stat-Signature: 1o7dgyhhu93mimjd1qiemau68sodk5pi
X-HE-Tag: 1764593347-743749
X-HE-Meta: U2FsdGVkX19PWktuMGqwc6GQYjUdK7ySPUaBNheCMtO2kalG53KYx1QR7hgEo+KvmRa3b1SBR5SWEAZQzl9d1opvrqKhALSSfTpK9acU8HUCdZFaNZ1OT23a5eza02cWlgIp5zWPEA2wHmaACVRwHyTjX4GVxirF9R4GaaHCQoRavMqY8LlfsBB0v2JzYMA0Vo70TzNIaD32PV21WQqF7HmScKrc2XTyatH+J6/cOW4rxN86HbjzSfD7LwdHouan7YK/uABcqwMCqDdyk1aLXC7oOQYnIx3LgsuUEE4QE5pu+ezDz+OFg27WOq3I2t9M7SfTtA//PpE0rC7zIDl9T9PGLr/zAEuCMe5grlErUTn2AmpPlFAtLOM3RkvuGvD7WJ7ZW5Nwxpuj/KTcMCbwTe07kUA90EdZG21kbT/jUDK0PdY2ddi3i3mK3BAEfPIxYK+Ff8KFsqRPIqOWzBi1023DswKlqUvr5Wt/3ij1nT+petvgjIiv11C16um2xl/zoLd7i7eh7+ghg98/V1g4VDuqqunsBDt8PKjNZ15C4B34U7OTZrDLiz6uwu1qLv88aF5vwA9RPfVYpp1Cx883bkQeD1kppKjc7J85Nou5oC7Yplc26EwINGO3xR7hnaBDhr6NiwYyxecJe+x3ielRUUb2V8riBmyEtIMLG37fShmCT9cdZ9Oj/SaJowGaQ/ZAgsZk6IsV1MF8/mhFsuy0Z621vWrHSDAY0c5NsQXaCvHiasopOx2/73vi7bcx3UxawyPNzUKscOmZGZumbvZ7zJYEUgL1pMm+lry+am24TXEFA0Jos4bZIbby9357aJ1n9VLjEGQZUPivnGnF6vtRnkTxOW/mCNwP2XEtlwPEmGd8GneI6FJ5Cf17BvEJaiSIWhyPKjptuCTskAwEEfH06G/YY+FvYF+NpgcywdiKz1I0/mr2tNs2iuAjfD0nGlMfF4HaRNGV6B3YVuurq4+
 mIrB6viG
 IukS8Z44IWLeQDY/L5qoR0ho3EYGjpGWrd7jj6RETGZ5WC04253M4SpwFolJypKEDgDh0/swm1lM7HZcE6Kzui+4KjyICCzEOJn1aAZsc8blgWEOhk0VmJ2LRmV3lFRxGtOHT5Sh30XCKpiMYstTGjkwRqSaOAXVWOHJCFjzNlc5zEqPLUjNWrGUupQSAkaTn9zacnHDk27JGkuWyZWUehd4KF0f6DlcMc1LDb0Ep+qeY2HoKxliQaIngprWOVtR8mh6Vipmi85kd4WWju8q+NbwP5tTns79RHGjk42ZUBO/oW5lIEkfoLdO6N3GYy7diNBF5PNsv0SoqX3nkdnSpnebOTg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/1/25 13:29, Lukas Bulwahn wrote:
> From: Lukas Bulwahn <lukas.bulwahn@redhat.com>
> 

Subject: "mm: fix CONFIG_STACK_GROWSUP typo in mm.h"

> Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") significantly
> refactors the header file include/linux/mm.h. In that step, it introduces
> a typo in an ifdef, referring to a non-existing config option
> STACK_GROWS_UP, whereas the actual config option is called STACK_GROWSUP.
> 
> Fix this typo in the mm header file.
> 
> Fixes: 2b6a3f061f11 ("mm: declare VMA flags by bit")
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@redhat.com>

Right, the commit is already in mm-stable

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

> ---
>   include/linux/mm.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 96acf31268ac..394126bf637a 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -443,7 +443,7 @@ enum {
>   #define VM_NOHUGEPAGE	INIT_VM_FLAG(NOHUGEPAGE)
>   #define VM_MERGEABLE	INIT_VM_FLAG(MERGEABLE)
>   #define VM_STACK	INIT_VM_FLAG(STACK)
> -#ifdef CONFIG_STACK_GROWS_UP
> +#ifdef CONFIG_STACK_GROWSUP
>   #define VM_STACK_EARLY	INIT_VM_FLAG(STACK_EARLY)
>   #else
>   #define VM_STACK_EARLY	VM_NONE


-- 
Cheers

David

