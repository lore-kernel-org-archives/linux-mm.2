Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9F99C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 11:08:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE6366B00A4; Tue, 25 Aug 2026 07:08:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D97976B00A5; Tue, 25 Aug 2026 07:08:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C850C6B00A7; Tue, 25 Aug 2026 07:08:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A04AB6B00A4
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 07:08:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 26858403AB
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:08:46 +0000 (UTC)
X-FDA: 85139519052.03.62A1B8C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 70F9012000E
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:08:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fr1kC5O7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787656124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FbafY2VwTbcRXjCw+IW3Zrp5SUgLFheVDeMNko0UlpE=;
	b=SSkdajDy6/rePExM+MzoNmS9pMFLEcpAT8Kar0eK5uAWjGju0Y1BQULUm/SZccMyxoLXhm
	8KcuMsv45X7wR/br/t50x6wAbaVNkZ6PQOuXr9aEl60uBiorkDpLQaiZu+ZGkTRFsGBkgH
	VSv3pN+bwGXRSTsVbCyI63oGt0O7mb0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fr1kC5O7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787656124;
	b=xh90hak7uVUmQs7bQPwr+N/xI8SVYdJ46QfeZdsG+ukCO2J7uGs0ThHAg+DB3yXreo1PZp
	g+8bmNwRz+1xI+z0XRf/B0hApNgjcMKUcEyo6iMBviXpVWFiuV6Ts+zrCWorVVXL/rjj35
	Zj6dj8Hr90mCR4Izs6r5cvRHkYdrHj4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AE4C06011F;
	Tue, 25 Aug 2026 11:08:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA13E1F000E9;
	Tue, 25 Aug 2026 11:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787656123;
	bh=FbafY2VwTbcRXjCw+IW3Zrp5SUgLFheVDeMNko0UlpE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fr1kC5O7u52AQcmSM8hOLx4OrGvSW/CTEZ4sSs4aQLuFyajHVZd5CanV9rVXwvLBG
	 /f+Be3jCiJMPtdXBHISfXmye4h9n6BfxvGSRpUdACgs1qH8qWAt0H4vuVyFhLXnkkF
	 YUzDKaF6uHIgV8ZQ7TypSbFNfk4bkaUGfAL8dFtVWHGzSbCEzfhVdkjTkk/Mv2N/vC
	 2MEfhOGTBU8nWaIiXZoJI17LzByAmA3u8ru6tjVKURuJN2niwhdC9lQbjPX1KTEL7d
	 M72dcifVPZV3eSqEIVHwZBnbiq22TrfILYJNlhNM9W7goD1ZyTwSkcwaDgY0K6agxj
	 YYoaITxLum8eQ==
Message-ID: <1bd9eac9-e078-42c2-b12c-bd8b92efeae5@kernel.org>
Date: Tue, 25 Aug 2026 13:08:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/6] userfaultfd: decouple fault reason from VMA flags
To: Mike Rapoport <rppt@kernel.org>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Hugh Dickins <hughd@google.com>,
 Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
 Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
 Nico Pache <nico.pache@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Shuah Khan <skhan@linuxfoundation.org>, Steven Rostedt
 <rostedt@goodmis.org>, Suren Baghdasaryan <surenb@google.com>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Zi Yan <ziy@nvidia.com>, linux-doc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org
References: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org>
 <20260823-uffd-vm-flags-v1-v1-5-3086981b33cf@kernel.org>
 <aoxm4jUrmL1eQlCJ@gremlin> <ao1waln1lklfk8th@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ao1waln1lklfk8th@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1ua3x78srx7waepepfchgi7heum7m9kq
X-Rspamd-Queue-Id: 70F9012000E
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787656124-673641
X-HE-Meta: U2FsdGVkX19TbN3MSHcZ1MsUcOc/vH8aBjtymj0m5GaDKP1lsRpFV1yBMx32IaZTExAMAvKW4fEgTZGSeq+yhX995nxSVfmbVwOHfoJ03KF7nV1I9EwKxv/ZPg6a6xrlcHd7/QsRrrcvbmR7oDAvxvxNZ91Rkc3KCNfBs8eSKoDIy6ywzBWk8iD28VsLQdtBhxbihUB76ZqY64x4rT4u8vdgIKPCTK/QvjLGmCBnE0ZRsGGJiJ89DKrVc9CVDknqRQpCdiC/6IVPbuIBfPJzPCugvBZM1aE6H4k2hZHJ62jtVdi+4pQucuc3wPcQjWzojc4jpStC4VFsgP1rVSGtumjMT0YXkzbViaHNyOM06hVgITsjdA0xdmcfhSJBeeh/qGRol2rJKrBmdaaWGNJUH9XOTzPrq2DswE2eILhle7Ah00G6l7KzNA0EN7Mqr3oTL+GUJDi5VGc5qFa1KT2E/jbpms3KWFpzQwC8/BV5MjYl9Uo8aUZ4sRfxee8yhThctDpJfvy9c3BTR03RiIK4PEVUoXflzDWPVO8dnwm3FN9otO8zt8l0Lfkh1MWuq6WwmGYx60CT+IFMhaV6X3vWjbiL5z+GGPh1xCcBaKgQWr2935BsZ/vL2s54NuuX8Lf81Fnn22f3jZJ8IWn8jwt15SS7PfHohmaEbTvLYtdWY6Vsq2/Uu6auhSRZUul0H1XR4/EuBd14OJ7ZjAP38CNR4moJestx6XygF68Vq6p8yiOzt00543t3O/ibL+asZ+4qEaaczr1uHzTPZTylnSHqen6pbVRMrH67NnJbv/uRLndE5G+udZnlVYYlXNC7yk/9rtqEcuOlbR4r5nzNet05F2iIclIzqLav6Snpsc0G3yP5FqarghUia1CrMJOU61sQtwAa/2XI0wyt0Ix20X8h/hahbywkH4wc/fvcjBnhP+7NbFpvgnjozeIYCtuIjx+TyBOHFxCc9foizuAYt24
 +l44qQA7
 n5Q6B05b+R5iUAb7hFAPm8O+RsPNLgojm2ZmUmKvi6ZO3HNxyYACR9De8TEuaYqu3iUdOsCjgPChYwo+dc52NFQTcR3juw8AT4nGSxVrBBYkuN+zpvzizNyMo/q5LzEv4dhQ1bY7F/2qfQAelcGqXR7TEUztucecAevS6zYBJy6F0GUb8u0xnGLKqJaKFRH2hQVX6ex6Pz4j01wa1VYJ46ARlNNumyICPOQU+SWZ9DqXTwdzBdqLm8mI/MIhQZptx6Zz/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>> @@ -2793,14 +2793,14 @@ static inline bool userfaultfd_must_wait(struct userfaultfd_ctx *ctx,
>>>  	 * If VMA has UFFD WP faults enabled and WP fault, wait for userspace to
>>>  	 * resolve the fault.
>>>  	 */
>>> -	if (!pte_write(ptent) && (reason & VM_UFFD_WP))
>>> +	if (!pte_write(ptent) && (reason & USERFAULT_WP))
>>
>> I wonder if you could actually
>>
>> You do this quite a lot and they read a bit horribly with the && and & on the
>> same sight-line. With the changes to the enum proposed above you could do:
>>
>> 	if (!pte_write(ptent) && test_bit(reason, USERFAULT_WP_BIT))
> 
> I find && and & perfectly readable and adding _BIT defines looks really
> excessive to me.

Yeah, that looks alright to me as well.

-- 
Cheers,

David

