Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2EACFD0659
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 08:29:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 388276B0099; Wed, 11 Mar 2026 04:29:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33FC06B009D; Wed, 11 Mar 2026 04:29:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 237EB6B009E; Wed, 11 Mar 2026 04:29:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EF7CC6B0099
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 04:29:05 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 88D921A062A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:29:05 +0000 (UTC)
X-FDA: 84533107050.21.B529B21
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id A8F1C14000D
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:29:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=utVavD96;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773217743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iTqYii1hI2e00krqbtsX9LEsDy2UgfEWXTijiExHbW0=;
	b=rNBusE3tTUOa5jzreZoGZUZz9FJiF8sudEv8fZzXznn2nWdaKl6CU7Ui5QVhX59wXjagE2
	oHC9YSviUXl+v8OQaSZVS7oOnh9p0UsWOoYATHwtwm/qLFzlKmLhuzLQd+6Swr8IiE1PnJ
	Bd9Ejq3APeP+aO2GbqyD6m6SKm7gUds=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=utVavD96;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773217743; a=rsa-sha256;
	cv=none;
	b=mRkHjDFvMDX2fGIqybgf0NNWDPHBYIkU6cjLyWz5GMYZANMqemB4a5cbkhPal5q6VWOA5w
	mZefSsl0jY/ND71qv1UTqnrOuv9w5ZfAzvclomuOM9roNFPb1bOZXNNYb6F1GS/goaus3I
	BaA1gJ1Q59VGMov37FYKCVUGhunOPYg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A3FF143FE5;
	Wed, 11 Mar 2026 08:29:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4C3C4CEF7;
	Wed, 11 Mar 2026 08:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773217742;
	bh=GE6B9Axf2iqOgQ6Zt2ej9Oufrn3oudVjXjL2vTIfmAQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=utVavD961L/MIxHcghlNRfP+qmyZvTz3tZkkai8biCLxovJiwSfi721dAan4WAerP
	 qQU5S4O+so1CV/l13lXL1pBvxe6Xcb8kk+l/bBNkxM6Og8LAf+De6dljLV/bYd9vPF
	 RnkVuR2LJMC1aO8Mmf8ZYzGG89DCjYYyg3JerSgXRXHIS9MEy5aP+0VPOJEnsfhJP/
	 cAHnLbI4JCoH8Po1okfUE05z/3RGXHVkg9UE9OHdr7DaaCoUol+/nBwm0m7BwYmG4l
	 DzBEoPXPx1/wX7BQYXu4AinRZizyRYhr3BiDVj3GhukhaNvYNRYVgru+HF9UqoHZIa
	 O0mPmtOaDieiw==
Message-ID: <5e5e0169-5197-4626-b91b-af4c13520805@kernel.org>
Date: Wed, 11 Mar 2026 09:28:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 09/16] mm/memory: convert details->even_cows into
 details->skip_cows
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: linux-kernel@vger.kernel.org, "linux-mm @ kvack . org"
 <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Alice Ryhl <aliceryhl@google.com>, Madhavan Srinivasan
 <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
 Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>,
 Carlos Llamas <cmllamas@google.com>, Ian Abbott <abbotti@mev.co.uk>,
 H Hartley Sweeten <hsweeten@visionengravers.com>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>,
 Dimitri Sivanich <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Andy Lutomirski <luto@kernel.org>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Eric Dumazet <edumazet@google.com>, Neal Cardwell <ncardwell@google.com>,
 "David S. Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Miguel Ojeda <ojeda@kernel.org>, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org, linux-s390@vger.kernel.org, linux-sgx@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 netdev@vger.kernel.org, rust-for-linux@vger.kernel.org, x86@kernel.org
References: <20260227200848.114019-1-david@kernel.org>
 <20260227200848.114019-10-david@kernel.org>
 <091ce280-9204-4b85-bf39-5e2a61e3d0ba@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <091ce280-9204-4b85-bf39-5e2a61e3d0ba@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A8F1C14000D
X-Rspamd-Server: rspam08
X-Stat-Signature: jfaew5z4ty4mq1hxnia68caggarjqop4
X-HE-Tag: 1773217743-139908
X-HE-Meta: U2FsdGVkX18zeqHqBloATP/rkS5kON7XAI7mOkDZFXu8faPy8l/iF5tGmhcEVWQUxFi9KFv6LoLZ+67jWp+V3KJZiRxlwoAvgQRtqAcE64if636oLTP1ug1Uy1NZy7GjKf46kp3ps/FQfu3ITAOOO6otj8FBwpAw1vCUE8WGpg+pt3zBIzyP6APh/oByI26otmfwngUSAPmWfUMlNB0g30Kkdh1uFvHt6eThklShAFfJ3KoOTwAikzf9zVFt8JrvjR9p537r+O7IpuOfv2zCTwfbib60jI2llxcEqHzWBx+qtemMc7wV2HDfiIxTloRDh7L9+TrpxmqBS1K767RmrlODFTqgOQ6rd52ItYXxW7ozsdQQSOrP1xkdBEEvwTYyXXTTK6WXn5beI/8v+9lFnXdDMPESBJecT4OBWkW/23p+nbbrmmf+eoZLlZaliND62MnY0hMSvibooFFGwmsaZam16qbXWuyogJd99junrRO27GayIrkeTze8EWcwE0BIwu4l7BF0q4zj4Hh5COS4Tx64PnkjINKSzyliBdZk+/5uf7szZw58MV3KGhpGnJB5sClXziDm//w1OwTN9uPGlxHRRWlM1L5Kins/a9a6Gkc4wYE/LxFEYXc12ac0Z9VZDZ9Yp4QuIIi5iffxOB8HF35nnA+6otv/mbLnNlqquv39MvR4o3ap22y2/z/rfs3ZePawfMSvKAzRySXr8TV4qGepOzRPu9VDT+hpqPf5HUWM2cw6Y1mZzqcWEEVjyEI575TDjHXfi/sxQiEfAiaHwwkbIy7RI0MA4Uka64aR5c2VGgtaFZqoCksa4YVqS4/VDiTPaNCRcSy+1hoSQYbirxp/+Q01c2lVAf6ljqCLUknRQ472lB6kxWAVmCWdrd6SAiZjoLB9bJ7qVi0nxtvz0n5BNzaDtMZt++Lng4jECYCry/YDKRLGbj/2qQ7xv9O2eg5lLmPN5j4qioyGSA7
 0JC9x6mO
 TGCGddccuVPoZBeGZuVXOiS/j2OzcQFHinGmWjvAVvDXNcsYey/qJjLPCW7qqj6rMXh09QBm2Z828+RLCFiXYwvSQHYXQRlSLUuTQ7JXLaCoyxHB4+oLS9kEfNQvLVdb+Dcl6WwOsyuH9NdD4G9kx+cq8Oi0khIyQr1CL/xYHgm9vLnMdRIOJy6xnC8X8eV3tUgiZO0zgx/AbK+uBf79FznoLAIMkvptIF9TJX1iAWU9hbwMmrcye4gKherc84iV9BJlZW9JYoLCT3wDlNuRbwrdioW3CUG5KEfpq4HJO0Msj0lnVhCot7ze7FQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>
>>  	zap_page_range_single_batched(
>> diff --git a/mm/memory.c b/mm/memory.c
>> index fdcd2abf29c2..7d7c24c6917c 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -1554,11 +1554,13 @@ copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
>>  static inline bool should_zap_cows(struct zap_details *details)
> 
> Not sure if you fix up later, but we should probably change this function to
> should_skip_cows() to keep everything consistent, otherwise this is a bit weird
> and confusing.

should_skip_cows() is a bit misleading on its own IMHO, as we skip the
"zap" context.

Would have to be something like "should_skip_cows_when_zapping()", and I
am not sure if that's really worth it.

So I think we can leave it as is.

Thanks!

> 
>>  {
>>  	/* By default, zap all pages */
>> -	if (!details || details->reclaim_pt)
>> +	if (!details)
>>  		return true;
>>
>> +	VM_WARN_ON_ONCE(details->skip_cows && details->reclaim_pt);
>> +
>>  	/* Or, we zap COWed pages only if the caller wants to */
>> -	return details->even_cows;
>> +	return !details->skip_cows;
>>  }
>>
>>  /* Decides whether we should zap this folio with the folio pointer specified */
>> @@ -2149,8 +2151,6 @@ void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap)
>>  	struct mmu_notifier_range range;
>>  	struct zap_details details = {
>>  		.zap_flags = ZAP_FLAG_DROP_MARKER | ZAP_FLAG_UNMAP,
>> -		/* Careful - we need to zap private pages too! */
>> -		.even_cows = true,
>>  	};
>>
>>  	vma = unmap->first;
>> @@ -4282,7 +4282,7 @@ void unmap_mapping_folio(struct folio *folio)
>>  	first_index = folio->index;
>>  	last_index = folio_next_index(folio) - 1;
>>
>> -	details.even_cows = false;
>> +	details.skip_cows = true;
>>  	details.single_folio = folio;
>>  	details.zap_flags = ZAP_FLAG_DROP_MARKER;
>>
>> @@ -4312,7 +4312,7 @@ void unmap_mapping_pages(struct address_space *mapping, pgoff_t start,
>>  	pgoff_t	first_index = start;
>>  	pgoff_t	last_index = start + nr - 1;
>>
>> -	details.even_cows = even_cows;
>> +	details.skip_cows = !even_cows;
> 
> Not sure if you clean up later, but seems sensible to cascade the change into
> the local boolean here.

There are too many unmap_mapping_range() users for me to want to change
the external interface :)

What I was thinking is that probably there should be two independent
user-facing functions, instead of having this magical bool passed around

Because I am sure, most users don't really know whether to set it to
true or false ...

But that's something for another cleanup. (I left the whole
unmap_mapping_pages() interface etc alone in this series)

-- 
Cheers,

David

