Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A72AC55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:32:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B9696B00A4; Mon,  3 Aug 2026 09:32:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 391326B00A6; Mon,  3 Aug 2026 09:32:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A73D6B00A9; Mon,  3 Aug 2026 09:32:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA4706B00A4
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:32:40 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 59A881C0E50
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:54:46 +0000 (UTC)
X-FDA: 85059498972.30.FBB15D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8D38C1C0004
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:54:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RfaeX1ev;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785750884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BtCt30ComJ5hFVYJ6JxEppVhYdFn14YBeB2m9YZ4FcY=;
	b=x7av8S6q5vqZIt9wrmXHAoDQFdZaX+AqLuFYOZT9V4pm3j2drHzuuf1wp/MucbhcgB4JFy
	fNDgDlf1MDUXWKrHapI7msuD2NwHxEy66Er1+gE+RTiRvoHvYuuGep4Qv5yll4xy6hup0X
	wfrc43Wlz6P7ETW/BYxr2XkwtrthfQQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RfaeX1ev;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785750884;
	b=i0/kIkAVFRp0w8Nyib8a2rRU2Xm71+wL91e5moVMiGV1sQMIMI9S169ybX8tTCKZgM+7cQ
	dlJkPlcf22s2VlXgv8MHhQQZyodfIm18opZnJblhpTFWVuAolkvmzccLsFmckQ9ZuK1R5Z
	gPyBZTnXIp7uhZIUbnztPoh1xBgkiUM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A2DBA43BAC;
	Mon,  3 Aug 2026 09:54:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ADCF1F000E9;
	Mon,  3 Aug 2026 09:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785750883;
	bh=BtCt30ComJ5hFVYJ6JxEppVhYdFn14YBeB2m9YZ4FcY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RfaeX1evo2opn3iP075wHiCgO+MwXQ631YicQrYI/QwrGQvnBstOT7phdU+zTmijA
	 iy4qWlgzZ7q0FAdOCNSk+U1hzQaUR8vL8hJ7Pbi9zrCmqb5XPe1YMYDhZP4f/XRDNW
	 0mbP8jZ/SGWDe1xUFAKJQ/l3QLsU/umRnS+U8IP5lX6sUcBSP6oYVADJb8LkmENkPJ
	 7P8BRpFLPQ2W+jSdosjXqf99ZDe60hgo3unwD2NZZoMnk7Nv7C0r6FrHMDqofaoG2L
	 z6t8iLVCdWFobWF81wM/G/Cmi9dyPi/jjq4Q+gEa58G832Df/6I1AKorvn+aHpVLk6
	 6kZq0J0ju49aQ==
Message-ID: <73adddc9-4321-4f6d-ac67-470c8f515fff@kernel.org>
Date: Mon, 3 Aug 2026 11:54:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/15] mm: introduce and use vma_filebacked_address()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
 <20260729-b4-scalable-cow-virt-pgoff-v3-5-e8ecfefea812@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20260729-b4-scalable-cow-virt-pgoff-v3-5-e8ecfefea812@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8D38C1C0004
X-Rspam-User: 
X-Stat-Signature: iu519gmrby8rc5nmrefyjbzp35d44zxw
X-HE-Tag: 1785750884-92302
X-HE-Meta: U2FsdGVkX1+roUfQo37amxxzpuvGHKbkJXBHOtkIADxO3b/6dXUtQDBNS4Bcl//WOKMti73D9oo5gCFfLH09e5kqt9AXdmNitCw4VYZk6PokXWuwOoSZhoThvaP3fGNcaJVaG5lpf0PcqsanlHnTRkYQQ+qxMzJN9m904h7uhGE1D8Rhq9oV44NtKxLvZ7BtQFRmdqQ7peGrMPEjbkoQLOhSrbNDy6/WaX/rEjqNEF33FLiei1L3mfdyC85gzoIUvMFKPOwh1CDl72SoG2HF6hOUVIWrGthMxFmRUJdevMVnfgPp26OeMCmnlepPruGJyMBXub8C6X5MnqG7MqyIYoydzak4iCxjkGvirCywC+38saFwt0dz4gws6j+v6Ove4NdBMS0aHVgXvJ4iLAoiLA6Yr8UJuH5+SE/q2cnD/yPLPH4d9RvvLft8g+gmERQ60zZblYawO7VjgRCeHuRCVE588qLzqFu9xpBSLPMI4XoIiyBYC3npTIP1eneuelik88s9UE9zbtNdOkY6cLocy3jIOxZamV8+I8e/hPQzN3FbcKgYDMsFMPbrQPmk9Sszk7Ikikhi+8fzZPSY0YNiT2ZezMEP1mLS2JyJ5iHGB7NkuYBNPXqnrl/GHy3rOOhVfnZdl0ZmEA/uezbpmIpciMPEfHGeD4NhqAm1wn+OB1FRCXSUP0bomLFIRHKJsfuG4yhz6FdEH9hHFVoGUfPY3PwlS1JLdaiXoomtXhdiOdtOKjjqgA3h4dCxES5oMro+q/oKIVje9GIN/KVfMFPnz2D7XiKAqcE+vGahW+g1JvaekNMzz0cZlbOiKn8r/5WqiJqCtkk6GKS6sRMfYL2kPCWENhXwlfX0RBa0vOdjq3+vqs23Bck3EgAKGBPWC065b2pEyyzqpbRjvtK3DC0WUsN79frs3sRt75ewB117LKAKrhcounBeMvmudGd1RAyUkKzWlGWRoOWggPLv8aD
 dQPHuliy
 K1r8l0+ynVBT4jQifspMiUuWDr9qUpnDiK0jGCvHnvYMCo2lKgOw3MmD0tCOsnUM638rvQxXmlXs59w/XHjfc3uwv6vqh/IGLSQ1IfEgp/1oQMQebZhZqZIU3BFKwpWabh4BX4d6l4RzZxssGh6x6DCuCX1AJS7bBFWkBz1FP+HKQIrUtPPX85ZOoUdSLXy0fL14yphq5wAO2xGc1ztpBhaea/9XbuvL2obPKsexWcSDStUtSLoqFebIhME4knmslNdOW68cK+2Y4BYWOkDtexehViJJBkHA0eZel8/3d7MAhvYJtsvBE6NZ8RpjK9y+Yj57hMVATDMSwK1bfTQom/O3Ns/mM/Hz9Vroe1Wlf5ScurwNfOGdyrAeFk6zn1Z5oDMQEvH1faOo1X/V4tFAwVZDJvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/26 18:48, Lorenzo Stoakes (ARM) wrote:
> In cases where we know that the VMA is file-backed, use
> vma_filebacked_address() rather than vma_address().
> 
> This lays the foundation for using the anonymous page offset via
> vma_anon_address().

I was briefly confused why we can't do that immediately.

> 
> Also add an assert to ensure that the VMA whose address is required is not
> anonymous.
Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

