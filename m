Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEF2FC87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 06:50:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 736E18E0005; Thu,  7 Aug 2025 02:50:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E7938E0001; Thu,  7 Aug 2025 02:50:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D6C48E0005; Thu,  7 Aug 2025 02:50:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4BD188E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 02:50:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E9F331DD67D
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 06:50:15 +0000 (UTC)
X-FDA: 83749037190.12.BE8D4AB
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf19.hostedemail.com (Postfix) with ESMTP id C92D71A0008
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 06:50:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=o9goQr6J;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754549414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wxh0zWaZTvn4TuSOhxTDprJHDrFNRGhtdShEFdmwNCY=;
	b=dDGev1MfVzaSZSjboJAsrxSSmu+Z/lbq/oPyvGUjOGATr6UHyBvQNSDVLJskmgdNQSRwB4
	ybDCUONlatQaFyTnycVrTTsPKAkUM1NpKWEKZFToswmAUcswA/52XaV9o4iBMxEPs6u1lx
	t7606Na6wioVj2nRWxtGjQq4m89EP88=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=o9goQr6J;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754549414; a=rsa-sha256;
	cv=none;
	b=IlrtxPCnjjsUhDblIhu9MnzD6iT1cv6hPm4ZY2Q4/VhbM8nhH+2nE9lkUjR+oABrXOyFOx
	Cu8iy9KFTkiaE8yD1u8Qw1kuFsVWRmbENeIxWJ5qCmj+0BK9frluxaPN0auTCsIZZA1gUj
	mnJeARTgw9u5HtV8qMJ75V1D9fVtdR4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1754549411; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Wxh0zWaZTvn4TuSOhxTDprJHDrFNRGhtdShEFdmwNCY=;
	b=o9goQr6J167FNdJ9hVD49fQuJmEWgYqiS8l7AUs/b9ipkRsBqqU2UUVj9C9dZ8XfOeSm9jDrpzHGVGv2WgOIY89N9p32oUxuxlcOdykqO22ERXoSzWUTnErT+zFYCW1cGdfY7N9pnEX92T7pz6w7gjwzjBpRGM3MidGlVsbjy6s=
Received: from 30.74.144.111(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WlD2yKP_1754549407 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 07 Aug 2025 14:50:08 +0800
Message-ID: <595a070c-d524-4ecc-9999-382f3432102d@linux.alibaba.com>
Date: Thu, 7 Aug 2025 14:50:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] mm/huge_memory: add new_order and offset to
 split_huge_pages*() pr_debug.
To: Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@redhat.com>,
 linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20250806022045.342824-1-ziy@nvidia.com>
 <20250806022045.342824-2-ziy@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20250806022045.342824-2-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C92D71A0008
X-Rspamd-Server: rspam06
X-Stat-Signature: bwq11j57kiioz14paexhn18ummm8imj3
X-HE-Tag: 1754549413-314412
X-HE-Meta: U2FsdGVkX1+dG4VvuR0UutB828i3lJxnGPNuW6Xn+f5H3XZiqGbv6Cx7H9j6OQ2XrUfIeI2M4+ZLPQ1v3AjZpEdf0gNndU6pqcyEDT6fT90Ow/RZuw/itnnx4zTmpdxu/9apjcCGEs/tzsVLPBiNI6RWDBgPoxy3g5eyXPCDc+AWeKjyzh60MkeIUicezhHb9JuZiBRwRnNpyiAZGbcBb1Eg39zzCkxjMYVYY056KitD7nAh6RyCgGYcCJQluwS+JDlmBbVwo4QHNtPIxEv72IiI+Jd3sMaTP1MwpYpnoGqMYWvFCO92OxqEflx0XDGRgskzbk++aO6TeGsjRO6jWvt9rjKBOm8UFgjhDis/VBYVAZrcjXvgnM9zxkAQ1QylG8ArT04AdPG0Vjx/8PVUTVI5b8gVAEIZ/Hs+5WoFQLSBJ6IP9mrlmnykt4xfYf2IMQHChuJJ2bVk5jcO85a8CnULbojYbTo/CMYINkJyqrSbV9buCGFaAr245dHa4eoBrc/KVKIbIQlVXqxgPnPypTo5adbCYdf4OGsNrKYcNpkvUW+o7b/dJ5RBD+XxU94xxwWTkLoMDoYcSpIlEwyEXXbDrWQXFytvaoAh9g4OTTQli17zak3yO7su3ZsQKB0vhOYkDmiP1wlnKZmB1YI6fsegA0DRqJ8RNhMK/4A8jfIygidym2U74BqLtHDH2vDcKi/OKNWPBEtqDOtbgpxr/R7MHrpkz7U5GC0C6YMzM3PTKjimtK9VHKNUjZVyTmHTXuNgc3qocysiLsLAHUDPgMIIXZP1ows2KcPd7A2CciyzDbGvPzV7H3TrXfwJpzcRGW4z3MDgXFiQMJ+liQvAxbOWZMiZbFP4jKIy9+GfJ3uaIIEK7dFsinOFM+KsI2k/RaBYHUfle7DPyawB1go+GkcQhSLCi6FE10dJ7hkFrGIoxVgYaSmBlTpph6mC0bGWuCRSi4Blp2CW8Ri0TIY
 2+pKTTdL
 6d3E8n13kndR8OWzf0Wl1urEEtY+FnQcpg99tFqlaIQdq1pKa3gdOWeH9PmT93838bdRhYL78Gc9O+DokX3ZBv1fBQMs2hrkXddy+mzeYqbzM4+2+ORDMcx91gylq19CJlydkvGirwkbgWiFYXg/lu8KgI/xagdX/EG+bpTwJ3W6BlyLORq5HDuxthDm3SEdzKSV5pVkq9szIVvnCoDgapimiaZEEgzZDWyqAB838rgPrG6oF4of+pi4Dm7SEOrYpr4yQnnHwAi6NWB3fsVs029n9A55fy1Zh+ycyrf6hRYPHUNUjZBfkxIbbwMHn5NgWO28MA6N3Guz+ZE6bujBz///vMtAXfp0eHHIzCJok9BIt1uPDla/m0p+BQw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/6 10:20, Zi Yan wrote:
> They are useful information for debugging split huge page tests.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

> ---
>   mm/huge_memory.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 2b4ea5a2ce7d..8a11c2d402d4 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4327,8 +4327,8 @@ static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
>   		goto out;
>   	}
>   
> -	pr_debug("Split huge pages in pid: %d, vaddr: [0x%lx - 0x%lx]\n",
> -		 pid, vaddr_start, vaddr_end);
> +	pr_debug("Split huge pages in pid: %d, vaddr: [0x%lx - 0x%lx], new_order: %u, in_folio_offset %ld\n",
> +		 pid, vaddr_start, vaddr_end, new_order, in_folio_offset);
>   
>   	mmap_read_lock(mm);
>   	/*


