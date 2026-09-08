Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06636C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 14:12:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0912A6B0093; Tue,  8 Sep 2026 10:12:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 041EC6B009D; Tue,  8 Sep 2026 10:12:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E99846B009E; Tue,  8 Sep 2026 10:12:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C20146B0093
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:12:34 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6028B406DA
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:12:34 +0000 (UTC)
X-FDA: 85190785428.25.582677A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9A3842000B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:12:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q6F5C9hk;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788876752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y7QY+32xJuMq6Tz60T2FtAYLMwPxmKJa9EIw0naxNRw=;
	b=IMsOro+mfd9wTCKaipr+G6c0PWBK+hJ7xwms6jCnI1yXzLsCwJVXS79heYf9HRFlmUR1rh
	4uC/ttgiY7i1yf/hxQOA6Grpb98dz5FP/RB0asbDI8+oeUYXeNlGjvmWQ/4vQSCSDzboRJ
	zBnL4cGJI3AlU4C24sivWW+TUX0ybE0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788876752;
	b=eb1T6lsjrfIF5nXABCDZhGDipGjWlqTrqck8YXD5EWr8VC4h/0NrdNxtpi6IFuqO7cGn5p
	hD0HWAVGgmyaTiH91+jEDurBXqEjfxiJ77/egVjX3JKx57baIBwnP+7hV6eCjES/Jv2iP0
	4Zn3h58m4X7b1oZ3sabul8mwlCk6TkU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q6F5C9hk;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1963E601F7;
	Tue,  8 Sep 2026 14:12:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019B21F00A3A;
	Tue,  8 Sep 2026 14:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788876751;
	bh=Y7QY+32xJuMq6Tz60T2FtAYLMwPxmKJa9EIw0naxNRw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Q6F5C9hkksHR3U/qP+t0jNS27VaZxxFP2ctszQifVzprISbqSQo7LQFXLrJFnIX1o
	 Bafps7WKNOyAbhevxCim2zGutTnUOIDSifFGUGCiP9RwxASEYTPSF2tXGt+5AFtsRQ
	 bRbuIfuVAYhAwBPbxXaTWAqOrlN/JwyhCpmyzSJuqnWuXNvEK6V0gdeOkP6z1D5xpg
	 z5EMDrurGFQ3/kil1agUJxZyQJZ/6xB3Zotk2rMQmqW2hPUL8lXvudBSa0NDHTmxQ1
	 K84k8y8+PPNx8ZBj80Ht1qxr0ljuwdeEVDsbdZElRqKWewvLo+314UzApBhluK51Mx
	 O5trPvNcY9YMg==
Message-ID: <9bc5787d-6106-4d0f-816e-cdf5a308abd6@kernel.org>
Date: Tue, 8 Sep 2026 16:12:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm: support splitting mappingless swapcache folios
To: Kairui Song <ryncsn@gmail.com>, Zi Yan <ziy@nvidia.com>
Cc: Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song
 <kasong@tencent.com>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Nico Pache <nico.pache@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20260805-b4-mappingless-swapcache-v1-0-b1d78ba257ca@zohomail.in>
 <590B3189-5B66-4ECB-84CD-7B7EF18C0E54@nvidia.com>
 <anNOroQdjQh7xmU9@KASONG-MC4> <DKIRYOJXLIYN.32KI06POZL7SY@nvidia.com>
 <anZLkwwxHdhM2M2Q@KASONG-MC4>
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
In-Reply-To: <anZLkwwxHdhM2M2Q@KASONG-MC4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 6ebjt8mx7t49tdteyy5ddrb947m1aiw9
X-Rspamd-Queue-Id: 9A3842000B
X-HE-Tag: 1788876752-828783
X-HE-Meta: U2FsdGVkX19vuU5lCRTvX20FD7E5vSJFP5XLxn7pxop4dxV9V43I5ZRJW03C/IoDMwoD+7lXPsz++C12MGypFTdbojVGOlgbJC9XAG9eYI6+Ab8kkRq+Eg/1Ppyeckprhj06xbhlqtzk2RFcmfMCYwjwGgEpphSvfbLtEfqPcvAb8Il9KLyzumKbXhCi9uHr6otKIyokHOqk/C3hn4nQcN/Ml6n3u/VF2Yqywc+xhyt7V15L4Hdggz4PL0ktICsVDrsebIcu95uota9pxkM45zUIGwt7pGSBzMXDh6z7qsPIAiQN7MIuWn4MJKLJwrOR4NcZXzlWLnWWb5C8k/J8Pw5lZSWzN3jZc82df8kofgkPLxBpnlbd+d2UaDgwOsV72wMm2zJhpAWBa/l8KnoJXKEJ5WPq224QoUzHGCF1vU8QHNM57qU1IO++XExJQrdOHJ3mJRdzyjUAmAXfDBGlpt2Xj1M6eapLRF3+K1A+oi//s57WHeonoeRaBRkYIRGVwfT63NGIoEVjVwR9nsMxRJBQVleDvbQklBFVu5q4O/UtFuM3BHi7xYfNA8N5gZMgAMDrjkKpvm6yZyhOIrWYWmel7Zl4cAe3CVaVvLW1x6kZlO2rWEf3+13+3s4ksiDGIWiWRIgn1DqXv+gF8415NVblCu/cLmUBMTp5YDobxPTFET6QhZWaZQmKggpxRBwBtqNahRiBZBWNx6s2Wz2RM2mFM/zeaw5cT80J8KLEV/wd7/+j2lnWpA7jSdaCVwpMvkAHjUccuhGCaqJ8T6INnR6Sn6XAtbjf5jpKCbQY15F0eOTmLVIU4r4Rf2BvmyoueJask5tYznJ7+bPL3591SRFzEbKP8U8nGmbqBpocfSBcEW0W9e4ZChm71/fZDo1FfVJC2Z4TiUp2RbYtMctpGHPx8H+scTwdhwhTxd2T3LK+pw28TDHoTt6/Yq7cf6o3/vnTwBCR+1YyrXig2p+
 gODCLSTW
 9ULFDLEoFMyKXwf4i8HCX9NV4D4CbVJRmnAkQtL7vgXJxS3qk0D1dTziZWvX/7GfvpoZNN4c+a9qPpK0uQzoJa0CtXId8K3SM8Le+82hH9aDAEM/R2FoUCArmjEnq4PGQy1fVyz/8HMRDwIlgosoRwc6j7F9l1QB8vSxalAAX5bBDdWjvN8sBZV9drbb1rkIhUjAB3316eQGbGEKsHCSQMIdrBLA930CHZ/OEZgAkZMoVjYLK8CcNR/LpdpEK/6wc+iZt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/7/26 23:22, Kairui Song wrote:
> On Fri, Aug 07, 2026 at 10:18:05AM +0800, Zi Yan wrote:
>> On Wed Aug 5, 2026 at 11:54 AM EDT, Kairui Song wrote:
>>>
>>> Thanks for the CC, this is actually not hard to implement as shown by
>>> Shivam, I just found the code more and more hard to follow and fragile
>>> as we add more logic to it. And we don't have to reject higher order
>>> split either which can be seen easily if the code is cleaner.
>>>
>>> Personally I think doing some cleanup first is better, I haven't post any
>>> code as right now there doesn't seem to be much user of this. It will be
>>> needed if more clean THP swapcache begin to show up due to things like
>>> THP readahead for swap, which isn't here yet. I think I can send an RFC
>>> tomorrow just for reference. I'm fine if we prefer to remove that TODO
>>> using this smaller change first :)
>>
>> Thanks. Can you also help review this patchset? The changes looks good
>> to me but I am not sure if I get all the details about swapcache handling.
>>
>> -- 
>> Best Regards,
>> Yan, Zi
> 
> Hello,
> 
> Thanks for the reminder, I got a bit busy so delayed for a day on that
> RFC.
> 
> For this series I think it's functionally fine, just the split logic is
> a bit complex to follow and we still have restriction on swap cache
> for order 0 uniform split only. I'll have a closer look later. Also
> let me know how you think about that RFC.

How does this patch set relate to your split cleanups? Is it still applicable
independently?

-- 
Cheers,

David

