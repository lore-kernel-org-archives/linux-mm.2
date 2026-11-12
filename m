Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6446606A327
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 09:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fo4I2LHA
Received: by kanga.kvack.org (Postfix)
	id 85C426B05BC; Thu, 12 Nov 2026 04:30:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 833FD6B05BD; Thu, 12 Nov 2026 04:30:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 722466B05BE; Thu, 12 Nov 2026 04:30:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4BB9D6B05BC
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:30:41 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 43645C02AA
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:30:39 +0000 (UTC)
X-FDA: 85425946998.14.1A3C14F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 44961C000B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:30:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fo4I2LHA;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794475837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0e9G5NVEpupIHAFHHKTSoDANySvZv3eOPYAS0FitsYQ=;
	b=nuAcE1AvlYNeIwD9hoIv2cugYbIUoNCzUouE40sWugfVtzg0GuvZgpJwstbxcaV4fLCqWR
	2rnOlZVKd3ALsVe6QdGnCGhvdl1IYrtReYYbuOhAn1gLOCRVzwiBORRlUTyP1N1Yirak7b
	GjkZjS8+7zG4V25P/rQli73u3ewLRtY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794475837;
	b=oOf7vxKbfu36RBp9Pl5WXjlBauyC2Et8rggBYw2ToApjNmVU3uhREY12gH8ord7wRCl95A
	64HvmFm4FS9NBaWBPkSknVX4k0itSmwliluTB5pc/BAzwnFJJ9/hHI46ghqUi6UWtA1mKX
	gQoottwjknhK3krv+lDkYfU/NqNnLaU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fo4I2LHA;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6BA334086B;
	Thu, 12 Nov 2026 09:30:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E6AC1F00A05;
	Thu, 12 Nov 2026 09:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794475836;
	bh=0e9G5NVEpupIHAFHHKTSoDANySvZv3eOPYAS0FitsYQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fo4I2LHA0zZl3knSLUeE0hRwvNc8XGv3Rg43/4BSErdYyntyj/sQ6Ouwk/u11bS7I
	 lsd8aAtZ5KVuS/TOcdCMY1l0D5xG2QF+dCvVihKbdwVK7N3JRwqwfW8KsjxGkZySse
	 4ZA7s454jngOb6cVLoif5+oUxq5/+u6K0dDYnCtCYqw1Hs4zUpg7/RFD1oObuBjR0M
	 Fl9uqQEooRA7IxoJdZ9McqawAogG/BgIM4ZH1/dZy2b/SAlSMkuvf6BagIu1seecRL
	 RiyMUUys9qpxM0hUIK0qtH3POk8zrhtTFEap/7Ahh/fFFPfBz0fig0/ImKOB2KxQhy
	 clRzy5PKMQUKw==
Message-ID: <cb492eeb-62d8-4a31-9b67-1ef2ac77c381@kernel.org>
Date: Thu, 12 Nov 2026 10:30:29 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/memory: refuse to map page cache folios that are
 not uptodate
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Pedro Falcato <pfalcato@suse.de>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Chris Mason <mason@kernel.org>,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20261111182445.656620-1-kas@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261111182445.656620-1-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: n6g5coue16ir666ikx5zw944x6onq7be
X-Rspamd-Queue-Id: 44961C000B
X-Rspam-User: 
X-HE-Tag: 1794475837-254167
X-HE-Meta: U2FsdGVkX19Y0zkiHkR6YTlKxl97vFbqAvADkVeSo0KjEnbN4GYsl9IgWJEGK7sL/diTI49FuYA4TUMj8TbYUzqyp+kWIbngSbiRDsPOZlEA79Iub9Fj3jzVvkxncI41otAXX8Hi0wa1lsYXJG8mDhDCBqXETvsOBxWVgYfe7SOuLhQ8YEEw7rRneb2Mdi62wTyPuvIDOQvqRK+TdzE1tYRNVzjk29fhU4P7OGUWSooxG/m54z1uQPWXNHjZ8htaqP0bfuwHhVdGxN3j3vEIv3j9XtJlfUxgV/felZPVDfgDqRku8umH0j9yjJedtduqyd4fiPHIfWemdSi85cWuBcnZD3U3Bt/r9v14F40uIIehmYIfMRHQ7usHOkbXZ1wB3Z4ruO+hEnk2A7twCC/B3DrR3txCkkVc2ZKfkS2QfrtbNtnz3mg50ibN7lBAaFh2iK0xqTNgXRLL2Cx2MNLOMYNC+xKAIIen08NmfQOF67B4tVf8DRINvQD/7+5xS9fDSsi1uYAa3k/UqMOQObDw2bPggksvAspbCfDxo+GGhY02kFf1tieLyPlnwaVakOR1XLZd+HX4t+c4e811de6KLpyjwCXsIO0X42sRGjky8rV7jOtEJp69czfXsasp1A/7GAc9u4F0McmwVK5djubOp+LfW0gtFnQCVQo4wf/SP2ZfTVG8pZulPWNUkuc2HwzMt/LNsTxSTlMbbv18/8AQFUyjgH8WNjwKq9kW6AEi5ewpP+HFo0Lpoaha8ejjS3Ex2MsjNjMlzNSQV9KosMpQk8lfj9ou/EKG8PEqBKb5GgxuM41QOuRzs0L5voDz2VcwE/ERrhzf2tFqAzORlNhkfXv2z071maJK3X5KYNunqgMJ/n9IiC8y6csHkYFX+tXiP8h0b5WyMM7J416YAWgw/sxxbOspfYqeq9tI/twNIJgeTuW4b9RXK0lAtwXI5i2309mtrnOoiYnmM9DyBrs
 7Q8U2V1C
 EaZ7u7bflGKfUI/dICZZzXyYmOg5nIln6UfyVlr4pSN4V+nzmpFJ5nyCzi5m7FVVF++jPmXxDESqYS2WjpCwKnjPQo4A4vq3NtWc7/ftZte0P1tIwuHJctE9hb2Z5afg4IU6Hg5s/qCUByuLvrkDBIoCkWbXHVGZhOXpumdonuovDyyTT9WtF4oDprZTPwIYJzDPnkl4cCIGctgGnFEFVUjvE02OitgQNtj6JroLU3AVgeAhS2vB2IvVHWad9JAencYeDqsiqTQdm7iessDGwSHpvX3rBnwj+7FIR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/26 19:24, Kiryl Shutsemau (Meta) wrote:
> A page cache folio that is not uptodate holds data that was never read
> in or cleared. shmem fallocate(2), for one, adds such folios and clears
> them only on first use. Mapping one hands userspace whatever the memory
> held before.
> 
> Each path that maps page cache checks for this itself: fault-around in
> next_uptodate_folio(), a fault in filemap_fault() or shmem_get_folio().
> Nothing in the mapping code does, so a caller that misses the check
> leaks stale memory silently. MADV_COLLAPSE did exactly that with
> fallocated shmem THPs until recently.
> 
> Warn and refuse the mapping in __do_fault() and do_set_pmd().
> 
> __do_fault() checks the folio ->fault() returned while it is still
> locked. For CoW, that is the page cache folio that do_cow_fault()
> copies from. do_set_pmd() covers MADV_COLLAPSE, which maps without a
> fault.
> 
> do_shared_fault() then unlocks the folio for ->page_mkwrite(). A
> filesystem that clears PG_uptodate on a folio in the page cache is
> buggy, so that window gets no check of its own.
> 
> The fault gets SIGBUS, as for a folio that fails to read in.
> MADV_COLLAPSE fails and leaves the range to be faulted in.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---

Thanks!

I'll wait a bit for more review brefore applying.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

