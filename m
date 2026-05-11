Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91D43CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 14:24:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 036A26B00C0; Mon, 11 May 2026 10:24:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F29A76B00CF; Mon, 11 May 2026 10:24:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3EF76B00DA; Mon, 11 May 2026 10:24:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D34176B00C0
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:24:24 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7D45916013F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:24:24 +0000 (UTC)
X-FDA: 84755359248.10.DD64D2C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id B85CB1C0011
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:24:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q8giATjH;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778509462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=flZcDQHnD9ZDh152zxlif+V79uw8MsKiQxS9Sdrd8oY=;
	b=gmGDOu1NB+RlczTojD6kKuwy1lLCO+ZQtZMQ4j43o0+WIYfo4cZ2JPOmN4EeinMXAt1QgS
	R0qsGpw1AkDkU+oC6ftqqvrx3e4h+jfaG9g/tlwErKLmvs6QcYFwd93kpfOj2Wo1VdMR7k
	rhHqm0pwr6Cn91DFuYj9BZ6bDIMcYpk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q8giATjH;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778509462; a=rsa-sha256;
	cv=none;
	b=dMAqkifSEU60vFwHZI9MQ1L9tui37J2r8zEgF3M+TAo/hegjob7WaPFNSDutmkyhH+0km3
	bz/X6iU3wtte40CZ+vNvsVAMPTwBnogk/pbKVF/XTx6r1ziKMJpa+OUuu/gaNJlmjIoyPR
	wH4En/wjWGYSVvUVtfPZOVTF+vPaSJg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 164FD60126;
	Mon, 11 May 2026 14:24:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794C4C2BCF7;
	Mon, 11 May 2026 14:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778509461;
	bh=xE2STLqrZ+jwmt9FTbxHG8yKr9HzoGU8+YKFxlj3KoM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Q8giATjHzfQyjrn49QyCUmWr6iLinwlqYqzFMRk8c1YAodAqyetD2/HGTdTIHwooY
	 t6QWc7BYjCq+jbQHjfhDkb3BYa3EhHAPY99dT6rD03RHZjIkJ5+OM24DCJnG+sLenm
	 FlhliGbHCo9cLKHt837t+fDENECkI3sK7dJK1EegeqgZBILtlo52HmqXtKXwWQFvks
	 C0rYWWhVYa1K/hGLHf+xjVHJdsGNwl4Mg8q8KU9mxOn3dumvb/zFCURS4VuL1Gm4i3
	 Ts3gqHEa38AtEuITxcMkChWQtIh2FuHjSsg+zJBPIAX0dLNyCvr49n3EDR9b/4GzW4
	 6UmYP0/6hz1Dg==
Message-ID: <9e313bd2-cc90-4b9f-9d6c-7dac8d9ec9db@kernel.org>
Date: Mon, 11 May 2026 16:24:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/8] s390/mm: use free_reserved_page() in
 vmem_free_pages()
To: Heiko Carstens <hca@linux.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>, Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, sparclinux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
 <20260511-bootmem_info_prep-v1-7-3fb0be6fc688@kernel.org>
 <20260511142157.9589E90-hca@linux.ibm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260511142157.9589E90-hca@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: uneo4xs4cazsm9fk3zm7nq7tp8hemtw7
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B85CB1C0011
X-Rspam-User: 
X-HE-Tag: 1778509462-838455
X-HE-Meta: U2FsdGVkX1+va3va6Jpc4chKxqdM6Ji7+1eYMSV55n5tEK/pcnNNtxTOJ1oo0CO5TPklUMIPMSdY5sdSWxizKTYpIHCrmRZZnuRNp/bqO1b1pJHk209s7DAqRgD/vwjTZX/adZo83dC71++NcX4NpjUHDjObFdd3N0UpD7s2hMCCqxBuDrhBK7pRC12WL8nYe50lkzV1fFyDRG7O4F6BkjbTqTd+ybTdZDh5gNEM2ySD3aPyNRiz017N3HKMikyN9wBaWfpmUARwl6+P3Fm09hBJBmFqwYRsctXprJVfVkTkQNGVMYz+ikCyzTrEHq47m6qHlZXWSFK2qfP7j4/JXDLTvZEG1y0HZARl5/zz0FnWSNSM9ZcVgM+gmW4kVRlh6u0lR0/s6RO0hgikYEl0fctQlme1hl8LiLfT+VnKFCj8roYo3l37BQZ4tozmXhpo8cWqtvEOF1Aw2Zh71gtu3Q3xZY15+MhGGewndMG9Dbud41BqZTCeZ7PHoiWS1nYEZOopSKGdSQWZjYQFT6SwAleuEOsyAzFiIA3d/IPRTvWOEHUrAx7voTCLgtgqZjDyN14FH5SE4jVzUPoOTlyXyWlL1t2cI3IADooHqBTYZZhLNGL8+1Ck1Mv7P5BQHNp/Kn2z+gxX90etx/ta3N9ahnXLM0aI0wTG9h55QBpp+g2jBDDvt/bYFsS+jxdCS67HLQgTVVzBllZbI92E9jVcOtL+hNYFKNz7xiZbsBr+TDPv19cC4G2t4ksQO4RNyVGlRf3eiYzfUzTBM83JBEHS6frpxTAMr9ZCYslmw6pPoxr1sKWOrW8DB+tEbeBQ9ETgiL6i1nwZ7kWjnj4Q714ws/ASqirWMkq1nhpCA3Y14ZQhB520jcmyq30qdFrHRr3AcGwD0enV7Q+ObVsjqq/BUf1OQWEP6Q2Qo7393+MiYQroUslzWM5iWa5Wxkb9yelPqzR/QwdrDgvhbqNQpil
 NzgBhdd7
 C1woD1NmZ2a9VskK4PypvroUs6eyPbv2yPraYoceClmyLmoKuxAjWs2AfZjI8Vxj2FjjCax1JjCei0OdvV9b/zMaarJiKo3gTWR3yxUYWe1RdLLQwCcCKi6vYsN7sYWaPlOed5C0ywurLb9NslpBxUC6x4AHjsYNA1V6CmVx/8+uVYBIR8k032XWM1EZEQXqPz0Nxw1HRtxzu2nXlDwT5uvZuyL3YXBL50AMMTPP5NFCZqklWL9cN6yqt1XTZfEutt7DuOwTgDp+G9VtOaU2TvUKHuLutd2aUzjLmWnry2TbLpo+J7rNbUfAUS1nhfm2O6WqIIMM1M90KJ5tZ1YvfEG7HQKut1S2b0UggsiSidvmWZmI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/11/26 16:21, Heiko Carstens wrote:
> On Mon, May 11, 2026 at 04:05:35PM +0200, David Hildenbrand (Arm) wrote:
>> We never select CONFIG_HAVE_BOOTMEM_INFO_NODE on s390. Therefore,
>> free_bootmem_page() nowadays always translates to free_reserved_page().
>>
>> Let's use free_reserved_page() to replace the free_bootmem_page() loop.
>> We can stop including bootmem_info.h.
>>
>> Likely, vmemmap freeing code could be factored out into the core in the
>> future.
>>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>>  arch/s390/mm/vmem.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/arch/s390/mm/vmem.c b/arch/s390/mm/vmem.c
>> index eeadff45e0e1..d8b2a60e0c33 100644
>> --- a/arch/s390/mm/vmem.c
>> +++ b/arch/s390/mm/vmem.c
>> @@ -4,7 +4,6 @@
>>   */
>>  
>>  #include <linux/memory_hotplug.h>
>> -#include <linux/bootmem_info.h>
>>  #include <linux/cpufeature.h>
>>  #include <linux/memblock.h>
>>  #include <linux/pfn.h>
>> @@ -51,7 +50,7 @@ static void vmem_free_pages(unsigned long addr, int order, struct vmem_altmap *a
>>  	if (PageReserved(page)) {
>>  		/* allocated from memblock */
>>  		while (nr_pages--)
>> -			free_bootmem_page(page++);
>> +			free_reserved_page(page++);
> 
> What about the implicit call of kmemleak_free_part_phys() which gets
> removed with this?

Thanks for taking a look!

See patch #4:

https://lore.kernel.org/r/20260511-bootmem_info_prep-v1-4-3fb0be6fc688@kernel.org

-- 
Cheers,

David

