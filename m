Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDCD0C61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 15:53:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E75426B00B4; Tue, 25 Aug 2026 11:53:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4C6F6B00B7; Tue, 25 Aug 2026 11:53:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D633E6B00B8; Tue, 25 Aug 2026 11:53:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AF5696B00B4
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:53:04 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4DC92140470
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:53:04 +0000 (UTC)
X-FDA: 85140235488.14.0762EC9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6DEC9100003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:53:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oRoZMsWl;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787673182;
	b=6Jrwd8Gp9jvT66L8WMLIxVAcmbsV0vHAcaucYwSk70QPQpCYyyZl4+699tDi1pb2PLePL3
	pOpKtdqPkrWTsqOU0RDMKUlLvPOU3Exi4/kWk2+ygZpXFUn8a71olJ83xY99Fhe7y907QR
	N/48Wek+wuJX7sYzDV/3fWmdoNCHz3o=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oRoZMsWl;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787673182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y0JHVvurql813KlZzufsG9y4LfXw6aq5+c0ANPzcrIU=;
	b=ab1ZV4l0xOHRr5qwn2bwktADCaHwq6zQr5EGuYOOr2vcPIcepbxC9H4HPW017fC1epu49U
	jQwZClKDrkTJauGr33XhLdsB6jTNFZ6qhrtt1/VpjviQKdSIjXk2wpcAR6ueseSk4cjaU2
	wJ7e6rrodnQDHuBTcmz53qVQbWeQl5Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A412040268;
	Tue, 25 Aug 2026 15:53:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8AE71F000E9;
	Tue, 25 Aug 2026 15:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787673181;
	bh=y0JHVvurql813KlZzufsG9y4LfXw6aq5+c0ANPzcrIU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oRoZMsWlCsqG/kH8NFUEkZxiPsDKdcCtYzz7thSV/CAFEIPu3j/S0Y4RW9X0jCyDd
	 2JpjAhBidHd4+EbFbyQMrkSkCgIX14zrKvABjoKYbx2N35behllJfFQDqR6PXmszkN
	 4t13gsjDclvxPCk4btEfvq260PKC9v/wJUTMAkb5f2oXNMR7EtEeuV9pvkClKmqeRk
	 q9wmgq2GenNq1RjdJUxv9FY4hRmiW9YcUjTfQHmMb51ZYgfUmthBb8gupbVZIszXUN
	 lHNwghHp/LwjmhA6tNX9LYh5FF5LST3jTOY1ZS+bw+Tv3rye66Hxgd15i+C3Agw+4j
	 cKrXM/SNIlUwg==
Message-ID: <149b9dff-9c96-448e-9c20-96ba92ff6971@kernel.org>
Date: Tue, 25 Aug 2026 17:52:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/3] x86/mm: add set_direct_map_ro_noflush()
To: Xueyuan Chen <xueyuan.chen21@gmail.com>, akpm@linux-foundation.org
Cc: ljs@kernel.org, usama.arif@linux.dev, catalin.marinas@arm.com,
 will@kernel.org, linux-arm-kernel@lists.infradead.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, rppt@kernel.org, ryan.roberts@arm.com, ziy@nvidia.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Lance Yang <lance.yang@linux.dev>
References: <20260730090647.2401252-1-xueyuan.chen21@gmail.com>
 <20260730090647.2401252-4-xueyuan.chen21@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260730090647.2401252-4-xueyuan.chen21@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6DEC9100003
X-Stat-Signature: 18jnzysppwzforah5xtc4un3nnpcyboe
X-Rspam-User: 
X-HE-Tag: 1787673182-428190
X-HE-Meta: U2FsdGVkX1/cTbpWvAH4kX9m7NLSRUZjmHk+Z/fZ+rjsKfYIGGR/XNpcq89QEWeWrExRTs44B1B/h9wamaICxJK0HDRtyKW9kFbzBJ1wFDobooXMGVSeFhws5bgresfA6dksF0Zy3+dBFtnJ4L5K3TobSfaSdE1QwIEoPwX6cExMMGPIjcvMw+UVl84DHZ4mkwpNHVGMpukOUfIXrC1K5L3OMSlz2gzKcJvXtwccYKt0xgFVgc5SaImjyrDuMtjM3sjssZIVRYJZFEJVHuMVVVdn0Ea6MrOu7mXKNsV6R3zlynMtgywZwOEj1Y4fqPDqKIyx5qgrHK6s/LnCZdl3Ssdj/6o4wTHK5hGNJbnJj0s/QE07DeHC+WFp4AVT9Hq6QPdP4ATPaTzo+VNbuN0O/yijYdPCNEYc4IkQR1CRypJC+DMSpGWrruM+/eTae/qnl7IyIlupZC1mNznS79T6wb93T/JFbGKBATRibD9Hz/q7ROKPKJaDNYHyVDFzeweP3/CSm/b+aeOVYcG2CkPXmCioE3i+VpvGYyFH3flZVH75uxG4B/ru7eAkrif1ylM3aGMrRO9XMSx8izkNtTYtB+VvIDIcBT15Ew+ROqRUwQLiKLVHKVqFD4gjX00DemOljaWF78jHnhZfmnc1pp0bFnpY2Eqi7AVB1sN7IhhWWVO/7bVcOKDzfax3kpeRRCzPHDNs8KARf8FbL/5RFIKfhrEuFFgGUu+1KfMEZzT5FXQGV20NhD8MNisR3VC46GdBpYnuoIuy/auWGI4Q5bTh/1622izYrMU/eOGyWb76TU3J++JILh3pyCjX9hOXQIs3f9e8OxLoaHigWSjhwgds7g26GIKKFm1hy1OEBdcheZbvzeNeoDeNookBitY6Unkvy1E0E8LWL38ABFSCrKmK9oKJO8AUow2Yu6xl2BNhj1upLjm11WM+YW0uMPjZ8kEH+4vlxrq7ZQ95w7aeS9q
 9lDSVudU
 TzbP6H/U2gjdVJq+G2Q8C25oeTTDdcBM/9iBU92g4OruagvJws7/Mw+xSpe8DiQLs70Mu+3t3JJ+P8qFAUrtsiYtmnJmNB8CAivfHlDHiAYRG7jM/Qw5q+ulT3KKO1PR9lGENyItiTO/kfsdP5tsH05o/qw1gPhIMzkKU461odavyHn1/p2UO03F1aRpRTV2ZI7xXVpdE338i30A5xeqmG94JTQVA8kwgHfgZlFG8ygOyHfqUnORt6SPS8Cx843YtqO3vfVaTioSIZSQgx8qv4/PJnGnZ3QZOl4jUM//Tmk9NtbsrElkK2yx3c4+U0hHkWklrhQ0opiDvfTmiWjJf9Kp+QQUGAmGxqNZV/CAG/46s/iD5uOatu5p6xLJzjggcYrhWVxjnCucCUSkEGfv3iR2nGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/30/26 11:06, Xueyuan Chen wrote:
> Implement set_direct_map_ro_noflush() for x86 using CPA directly on the
> passed direct-map address. Clear _PAGE_RW and _PAGE_DIRTY, keep alias
> checks disabled like the existing direct-map _noflush helpers, and leave
> TLB invalidation to the caller.
> 
> Co-developed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>  arch/x86/include/asm/set_memory.h |  2 ++
>  arch/x86/mm/pat/set_memory.c      | 15 +++++++++++++++
>  2 files changed, 17 insertions(+)
> 
> diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
> index 4362c26aa992..bd3817e06052 100644
> --- a/arch/x86/include/asm/set_memory.h
> +++ b/arch/x86/include/asm/set_memory.h
> @@ -89,6 +89,8 @@ int set_pages_rw(struct page *page, int numpages);
>  int set_direct_map_invalid_noflush(struct page *page);
>  int set_direct_map_default_noflush(struct page *page);
>  int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
> +int set_direct_map_ro_noflush(const void *addr, unsigned long nr_pages);
> +#define set_direct_map_ro_noflush set_direct_map_ro_noflush
>  bool kernel_page_present(struct page *page);
>  
>  extern int kernel_set_to_readonly;
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index d023a40a1e03..5987f4c84f6f 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -2662,6 +2662,21 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
>  	return __set_pages_np(page, nr);
>  }
>  
> +int set_direct_map_ro_noflush(const void *addr, unsigned long nr_pages)
> +{
> +	unsigned long tempaddr = (unsigned long)addr;
> +	struct cpa_data cpa = {
> +		.vaddr = &tempaddr,
> +		.pgd = NULL,
> +		.numpages = nr_pages,
> +		.mask_set = __pgprot(0),
> +		.mask_clr = __pgprot(_PAGE_RW | _PAGE_DIRTY),
> +		.flags = CPA_NO_CHECK_ALIAS,
> +	};
> +
> +	return __change_page_attr_set_clr(&cpa, 1);
> +}
> +
>  #ifdef CONFIG_DEBUG_PAGEALLOC
>  void __kernel_map_pages(struct page *page, int numpages, int enable)
>  {

We need an ack from x86 folks, to me this looks good.

-- 
Cheers,

David

