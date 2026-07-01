Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C6FBC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 07:51:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3837F6B00A8; Wed,  1 Jul 2026 03:51:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35A956B00A9; Wed,  1 Jul 2026 03:51:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2726B6B00AB; Wed,  1 Jul 2026 03:51:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 03E476B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 03:51:34 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 64E94120295
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:51:34 +0000 (UTC)
X-FDA: 84939438108.04.7FB30D5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 82B36A0004
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:51:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FYJjf11U;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782892292;
	b=PirR+90VZ8O/SfK+UV/OqJa532jrmM48P6lvRZkr9fKZZpb8J3gigQY57wig4Mes0jbDNX
	hGFItUBceq5F9xG6XUzW41g4ItKrrcG4h4/eMIw2sK7zBqoGYeH0NJoWX+Xckw3glb3bMo
	x3LhIPUnz2bn7/lH+n4Lpr3y7wnarWE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782892292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=51m7M3COn1/E3OtCD3ZRXSNpNk79uzKwN58S0ln/MLw=;
	b=IJP2B55VWABZmOBKZp9ysKBaxjlZ27piM+q25hFgQU3tVqBabdrsUhuaUVusXLRbYYDQJH
	8gmKHq3zdbGB0/sRE3WSSAwbGq7o1LEwrVmSMbB9S725XTWVR/xWpnagQORGdwQfY8Wbqo
	cLA+IGQFunhe5jCPe8BtcGw7uQzV2QQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FYJjf11U;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CCD6840295;
	Wed,  1 Jul 2026 07:51:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F2D1F000E9;
	Wed,  1 Jul 2026 07:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782892291;
	bh=51m7M3COn1/E3OtCD3ZRXSNpNk79uzKwN58S0ln/MLw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FYJjf11UWRYxvRgPHWmM/OD4SR05EjtYJElcUfM07lAgPj5S7f76NuWwAvFboPfRK
	 UFJRJejlxjpsg3TijCD77T69OjqtFZGZBX0sdiTLSUif0SVxtT8gCv0i6R6WIPDu0/
	 +XsxZeNUUijhMGL3Gt4QaEJy3g358pnFWIDANG5/an2flylk0AisTMtuaOj+fl39zz
	 515LDMhnsqCBbSrdBQXlftWCfHYkRfgi8TUSwhIl1A2fHdHU6t2jDcNwGZwp8xbXit
	 iS07tF7y1mIYl7eqQoY4FUPrVoGiishuR7LZOvrUsrgscGRVlZKu05vb9+Y+IFHo5u
	 nb7z/+IV3vqVA==
Message-ID: <796416b6-c61d-4758-a0fb-f6ea7ef842ca@kernel.org>
Date: Wed, 1 Jul 2026 09:51:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/16] x86/virt: Use higher-level allocator API
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price
 <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
 <20260629-alloc-trylock-v3-10-57bef0eadbc2@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260629-alloc-trylock-v3-10-57bef0eadbc2@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: othkjwpxeaw37ks38839kgr68twrtaeh
X-Rspamd-Queue-Id: 82B36A0004
X-Rspamd-Server: rspam06
X-HE-Tag: 1782892292-425652
X-HE-Meta: U2FsdGVkX1++acSTBb2549SArKVHYs5tsheezsZosmh5HLINVk5NegHUqGw8E6gZbeAfWU6goTxjrZsqblrQBg+BsT4N4XrTnC3Nr9o217MNF04QN6cJfxS/LMBLu14Pvps7dWmZeTxWE76JX5NpRNZuVJNTvI0QxjqhReulCSFM+aCtpQSkWjhCqNSAhF40PPYyr3Wn1pokbm28KuQoxSCwm/EYE2oN0t5IsxuruQnJH592iGJ2zfs6eapbq4cCRtJtl6NrgT5veKxBTozDfZPDSNfd4XZ1cRFRVi2wDzFvoTT8dnJm5D+WIdBpfU+RADvzG0I8d1ecmwc2VMX7YLBSWYLcPghWb062nVMb3XUTjyre5jAbiQslNIy07lAipVSrdjQ2l8PZY2DDXeBElOLxVf7WrW06d5gOedeogdjT0g7M6ULEbXoRzyKMFppt6199KoElnng59PK9Ui2HT1c6N0MhHPeu9ts36rW9zz/VrGsMX6QohPVO5S8bRsoMmTaoQEda86qnMWQvnBaXZJ6HltsRg/ifunFWTyedTBLhwf+brBWMXQvuKpy5mBIq34IcnexiTI+vFA7jFO+Q61WaiA8xslK9i0ah27oDv+N1+6Xr5lWi8aDmQhR5Jd/+VQRZR24LoEJlBVSpM5rIduK8i6qpIEv2Xrvsa/L4mjE/eLT523WUPx/KDG0fDPCG90h6JPfGNjV2TbwSNerdQwduoe7eumk4SkzUzWeCkJlU08sJZ8XSAX1XQmSrHwGwnhNfne31owzEN0CnnWzFFvkSb1HB5aBU6Q154V1dq2wk5U6bfvVxEguUc8rWT3oIEBmNggQEcG0ZDoKGcZgv/PPfVKu5dBlSJk3Jwq5JQm4UpoDN+T6KzIs5uH/8BjhysUm4BarCZ3I2U3IbNlbgAZTQeXoAHU8Sq1ihFCOUKfMvH+Lgn87LMGzs5aOmyZrRKTu/WkN6kHhF/nuiYV7
 1WU8byEv
 9N+G6UyOlQjLJZfTK/F9XY4CbCttW1jZwnVgx4V4R5rvZFt5vxGsbre22jjoN8cbK9RtG2juenk5sAaj/XVamX/KEnyCKcmXwLZWAsrtSj5CzSX8JwSPJXTqV8/wEEjLtQmipixRgA2MJCNTK8A9KD/Mp2xbCYLPo9lIPVBQTA0+Qec9O6S2VBQjEbnaxuyRTeLqvIi57oZwh94MDjDGNYBizYL9nGQGVzMF9h2f93VBV/G6awWAFAZ6kJlYTjIwJtKT3MhKnqhUAUhA3M+fMB6qFwYG7j56+YXfGClcH1TYLnhI9+bj/6WycjzTTvlGhBvZkEmU2WDTFCaINpFy955PrBIuUI8x6ltrXgOQOU6ue5avcM8WxDIX9pjONmx3PbkWo0BRy7j3uTu6eAwd8he9uzNs11Xu28vSYCQ8bt2WZyqG+GJ3GhB04AD79/WJMFUl9BqJXIJawKhXWk0+pLuTFOTJiNOaduqhGpV4aKg5KPOE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 15:11, Brendan Jackman wrote:
> The difference between __alloc_pages_node() and alloc_pages_node() is
> that the latter allows you to pass NUMA_NO_NODE.
> 
> The former is going away and the latter works fine here so switch over.
> 
> No functional change intended.
> 
> Cc: Thomas Gleixner <tglx@kernel.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: x86@kernel.org
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Assisted-by: Gemini:unknown-version
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  arch/x86/virt/hw.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/virt/hw.c b/arch/x86/virt/hw.c
> index 7e9091c640be0..a236447ac7a26 100644
> --- a/arch/x86/virt/hw.c
> +++ b/arch/x86/virt/hw.c
> @@ -196,7 +196,7 @@ static __init int __x86_vmx_init(void)
>  		struct page *page;
>  		struct vmcs *vmcs;
>  
> -		page = __alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
> +		page = alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
>  		if (WARN_ON_ONCE(!page)) {
>  			x86_vmx_exit();
>  			return -ENOMEM;
> 


