Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DA7CFD0655
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 08:19:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF8196B008A; Wed, 11 Mar 2026 04:18:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD9B86B008C; Wed, 11 Mar 2026 04:18:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 971086B0092; Wed, 11 Mar 2026 04:18:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 73E246B008A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 04:18:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 21D3F1406FF
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:18:59 +0000 (UTC)
X-FDA: 84533081598.09.6DF33A8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 896E5100003
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:18:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IQx2TkN6;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773217137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VPJU5tLY+hr3VIoB4RINhNwxWFMBmbJhEC+ALKgsJRg=;
	b=4DQ3GFsOtRjOV6e0SWg/UaDB/Lk32u9u5APNIgUd2WBJ8v3edzQ5o70lMs8pGk0W3im2HA
	ULCye/25wT/IW3+GteQLXE6P3Zd9NAeseaKhAzb3rA2fb7By1dxCrn3y9Hs6EgUnfLg4EF
	tiF8PQz2M/NToppbwtsI8EqS02cC7JA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IQx2TkN6;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773217137; a=rsa-sha256;
	cv=none;
	b=BEoRNYq7p0Wn4NVNuHKtVJI6uvTZPT0+FVbqBtcfSmivT6981FD7t4r50lXkCOZ/xh5Z4X
	naN11YhMyXIA/tSCMVUb6ZIeYAh8lTCzcuTJMWQlA+u7nVAAMttlM48MooAMHU9V2S+EdC
	/pi4ffopp611oEO5eMIlOzPvxnm7YLw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 46D2B6012A;
	Wed, 11 Mar 2026 08:18:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 021A4C2BC9E;
	Wed, 11 Mar 2026 08:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773217136;
	bh=6ImKPFcivnEAhhMGOB4v8zVHkoArioNqdVSwhniKfY0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IQx2TkN6ijhwUgYfcXSxBlRFTvqzQnZqutdbsFVRfHZbbWuzccTqcseRhNL0b0foU
	 Ng3g2HiyK98YrTxKAnEhVA4j4nfwEDDPK36OCkI4JU4UKUI4B7NXTPkSBP1oQe98Q5
	 nyE6Lmc4iPLMHq9THZP5u7ukJaP1F4rSYY8MQnD7Xb2jP1T9c1swNonrT7xVgzdJtb
	 /hQNO3nIdqBLmqznQevDPfg0KMMh8xhvaarxTmwbEmXmOmt3BrUaykrMQXXqbwpwuz
	 4mqhZZebsiw61CDatCJAAvMa/ObPo82EA1jzuNk51n4TnWChokW82M4xFiT6Wq9VYu
	 5dx9/JXZAyOKA==
Message-ID: <55b27bbf-6572-4f5f-a843-39ef8e01fd17@kernel.org>
Date: Wed, 11 Mar 2026 09:18:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 10/16] mm/memory: use __zap_vma_range() in
 zap_vma_for_reaping()
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
 <20260227200848.114019-11-david@kernel.org>
 <c03e1ced-6fa5-4d66-9c91-66693193383f@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <c03e1ced-6fa5-4d66-9c91-66693193383f@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 896E5100003
X-Stat-Signature: y5yuptmgnoim8oq9qo9qqb9r383hb5b4
X-Rspam-User: 
X-HE-Tag: 1773217137-882136
X-HE-Meta: U2FsdGVkX1/gUM6xwLtQit0GDPdSG4vb6w9f1c0t+Q/FSBdeWAOg1cmCB+yrpOoJ8ZqM5Rhe11f82d0DaIOOARCirJIM7IiWKKaZy6NCWK2dSPZwHly88/eIZRXut/yomkuKJ5ZDK9A380vifnPkYRAf92LoweGswqMKI+muuV7R52XTKFGZWRENpFPbKr3RMR54ljKpjK5TBNP4u7Lt5WNvkU4N5jdr4OjyYS4vE0sWCW5NlLsjGemjno441UGjdyKcQesSOzH9d7rA6GpciXuf0+NhmLYwpPwRv9ZRHzGsU+Z2kjKE5tZ47U0+EJvsBd1mjvTBEro3uqJiE4WsTpumYmfTH6K0SX1wmSVm9m5osglIRn/El5fk+zMrluTryD4VEPR0ckbBgG6VUBKVN5/+W5nOyQYcChT39snmbJMdesgFUx6JiMbwNesdoxQ1nExObdzwnAUG3fiX7+nwSK+/PJC/8BnaM6h3nzXsrdxJ01Xu9lfG2HzXyg5rR9ww282oXsiUn592pEFWyzxrPpGIMbHxbtJzs47iRJ/fsy1n+HYpL039EgUQctFeb/+GimvLPGRuXnFQy5tfvaimMnvvnPIlTkC1Qh1p+8qu7n0VS6jLJK4Pf3qPca6iNS5lBJLjdwaGbVWVF2NjvxcGeM1s5XikKy3Lc3wkEdaKqZJeGs2bQY2E1T8kTSrY3jXOKHPbWHJ75MzC3OIMKBfU2oAYSB/LVztrKbtow6mZED/SIPbNV1g6kPbRYsbiXKFTvZdq1wMNYD/qK+uRYFnLu79BT+coBMK6rvVs9C1w0QDpJTQvzjL2ARlEjxSoz6zeGoiM2TonHTxQCPz9DQYko2FeuxTqql+CWgnrohyTPLekilrdCak8BOnpjA6oVv0L8Jn8Kd6jMFCY+w2FLCicN0YjTOWOlaaGLyNxO/eBXVxdik5d3V9vHzP3XV9ywdpooOprpE6dWkdL/7fD+SV
 SFaEN7i4
 0WdJI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/6/26 13:26, Lorenzo Stoakes (Oracle) wrote:
> On Fri, Feb 27, 2026 at 09:08:41PM +0100, David Hildenbrand (Arm) wrote:
>> Let's call __zap_vma_range() instead of unmap_page_range() to prepare
>> for further cleanups.
>>
>> To keep the existing behavior, whereby we do not call uprobe_munmap()
>> which could block, add a new "reaping" member to zap_details and use it.
> 
> I am always in favour of making further use of helper structs :)
> 
>>
>> Likely we should handle the possible blocking in uprobe_munmap()
>> differently, but for now keep it unchanged.
>>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> OK this looks like it's doing the equivalent of what was there before, so:
> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

[...]

>> @@ -2111,11 +2115,12 @@ static void __zap_vma_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
>>   */
>>  int zap_vma_for_reaping(struct vm_area_struct *vma)
>>  {
>> +	struct zap_details details = {
>> +		.reaping = true,
>> +	};
>>  	struct mmu_notifier_range range;
>>  	struct mmu_gather tlb;
>>
>> -	VM_WARN_ON_ONCE(is_vm_hugetlb_page(vma));
>> -
> 
> I guess because you've moved this safety check into __zap_vma_range()?

Yes exactly, considered the change too trivial to mention it in the
patch description.

Thanks!

-- 
Cheers,

David

