Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 049E1C9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 12:25:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18F366B0098; Wed, 23 Sep 2026 08:25:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 166BB6B0099; Wed, 23 Sep 2026 08:25:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07D1B6B009B; Wed, 23 Sep 2026 08:25:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D32A16B0098
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:25:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 256C3120790
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 12:25:49 +0000 (UTC)
X-FDA: 85244948418.09.914BA38
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5ABB512000E
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 12:25:47 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MfZsCQi7;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790166347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7fw3yY5Wf9Fir6xKwPXXniu+pUqrdHiW7D7iGY40Hrw=;
	b=45nefMlGvAHT1oKs0n8vcxepLbCMZA3jyP8PeXzqeuQ+KUTjyScgrnTlcw9AY7NiOAs2he
	tvW1prT2OHf0Dlrl/smcbSx1xJQpA+HV1PaXrGOmA2f/qy00SHWtxHSybehe3uwJJ/dXvG
	cGRi0fIkbw4YrHWVh39vB6WkDl4wCNg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MfZsCQi7;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790166347;
	b=npyJ6GOD8TAjjoOGx1khff+1eIEDZYW+zele9fpnmw/i7ROuYhLS+Z0Cms7Z50FUlws4Ru
	b84Gp5u6inXasf8Bbv0Yya3aNVxYrorCwOjD1Oinxfa+XSjZxQmVoh3gIhh40QGlSEZDR1
	70u+GCPRpu6XIzEDp8cjFx+aZbVTkEw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9668A4149F;
	Wed, 23 Sep 2026 12:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831291F000FF;
	Wed, 23 Sep 2026 12:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790166346;
	bh=7fw3yY5Wf9Fir6xKwPXXniu+pUqrdHiW7D7iGY40Hrw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MfZsCQi7XCwQ+ZISuhHFDYg0bO/uLrea1cWM5FombOJwYX1tMSeDnkwIXaTKzkCJ6
	 DH+uryfyQ47XD0F/qqJJK6nfyE5rrLigrJk4FymjeWXOxdU9CUKJGKx5l1BUJxjTJH
	 d20fjUcFiyPa4NXdLHdhCVi6v2rra4dkT3TmyTjgtLJ8SEcx9svXJ+2YP3c6YLkrSC
	 YS65FQEMtfj7Cs7LMWJZKZ6YUF4IVvOrqeHgYYyzh8kaD+u4uaDlXrAWws8V6EL+c8
	 Vy0JR8BQHk/nRSQWhJ/IFV7nUOtT+uKiF0XMZUwCYn/ruL/XJFYvpYf0jvDkHXAKAj
	 KXKyZclgSwokQ==
Message-ID: <59920c39-ec87-4879-9370-e99c14f4dcf9@kernel.org>
Date: Wed, 23 Sep 2026 14:25:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/12] mm/collapse: drop the collapse_possible()
 wrapper
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>
References: <20260916093145.4022188-1-kirill@shutemov.name>
 <20260916093145.4022188-7-kirill@shutemov.name>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260916093145.4022188-7-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5ABB512000E
X-Stat-Signature: 4xsbcja7is7cx7n6gb1cw5p6hb97b888
X-Rspam-User: 
X-HE-Tag: 1790166347-552654
X-HE-Meta: U2FsdGVkX19LxLDbx9Fo+SVdHYI+SIorzGaLsbIYpUf3jIDU0If2I3h5BizZuU9roqDXHZFHzzGuHBJ646fsyUGySXHi7XtcKDShF4oaZOKLWcM5dgTJPSNr0ibDDP6JOHSJKl9cs4i77N6479DDEuHQhUNFZf0KL9p1Wr6qmAqcdBWRzOn17wnRSwpmbay9Z2nuSF+ARrgiQBEzo54c/EtyvovYLoBZGiOQdakmNhwK+c+yN79691Y4+jZZvdlPT/3fwtaMkf+6KjjWk1osDFC9ZdY8dfgPKAbSY959fhoyebHn0S4R3oeIhR1jEsEBv2RB/iiuAjD1LkBBDhLEIqZNs+v6bhpP0bZZIaB4tn3YM2n2eB5ANB/nZuKQD1fl0hqjPpvorrY30F4S5xHMnk018EQ5ntB0r+uHbaqOlpO5wyGxQf+DXGI9Ke3PX09XvNbOR7OxHMNdYz5qZM/U+e53F32PxmTrzwfqJKF9Gi6WEU/Np7MWXhXXI6SG0qPeme+chPGEqOG7CSIhRZp/XXxXW53UDQlAQWYhWcht/nyf/aAA9AaOab0xX1ZXXOoVY0vtPIdokVIVTIOTSQnDWR9n0e+Mx9ITg01fEehdr4Av3GFcini/qcN3bCfUCC0/Rx1aQ+pnwm5kmg7zA71XjZZwKcdjRhGfLdbOH7d+ykQUd/wLNFrWKnrZJRhD634hyzXCJTixOR9uXCleUmrdP0m6opfwWUVPnz6Tqh4q3hOy7Z5iCG3FV4mkNAwEFuSvQjxPbExUrFrg4V48uIfGoSPUtWiSDz0lYuCp6FfeatmpKJcwRYYPiobm5taoVDZAPYzRcx4gySZsDaNKIvO2adRnpifmWpInBN986C6LW46h63OuVg4KTFF9F3OZR8HM87Hb0fwH9/wTacxceMSEpnIvj+UsPJEup7bbFbxa7eZH6NbD59EZWzm/fM3ZjnePFw6Y0sgu2IDEHes/U3M
 AUpt4FVZ
 EIyCpD/ttR728t8YORKLqZYqwvAf3GrLxNcqkE8VQ9H3UA34bU9BylHYPAgS8ADZhkEp2mW9hnXY0s/vsTgQZIZFpoMqxmYabxUjbxKJQD0ScevOm/+2f9UHemduUAVTrCCgt1RUGDA6RQ1bBi+vxKfoyTnOrOQloMoNdQtZfYSEY7maapyKZwhLdn8zhtSO/3DwbKtbbcc2TskccBzMRySp0MfUtD2W0PkBH7B/h3xwP0drVpcFUzyJTlMESBUduOOf3uMiFw7tD2wNt/LQ1OFgLQI9uZW9kf4rU2tRcKIHHvuY5iKw8B/q5+BusDMk5v56da8ciezPcylM+DrR9a27cpTOUDiJStD09GcF3PKYvF/eOx8wHRyiUrXUNpQg6HOTL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/16/26 11:31, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> collapse_possible() only forwards to collapse_possible_orders() and turns
> its mask into a bool.  Its three callers can test the mask themselves.
> 
> No functional change.
> 
> Assisted-by: LLM
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  mm/khugepaged.c | 15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index cb08789b2d38..62bafe509bb7 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -512,17 +512,11 @@ static unsigned long collapse_possible_orders(struct vm_area_struct *vma,
>  	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
>  }
>  
> -static bool collapse_possible(struct vm_area_struct *vma,
> -		vm_flags_t vm_flags, enum tva_type tva_flags)
> -{
> -	return collapse_possible_orders(vma, vm_flags, tva_flags);
> -}
I think we added this deliberately to make the code easier to read. I don't care
enough to argue to keep it

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

