Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54CD4606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 07:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DvxGAV+O
Received: by kanga.kvack.org (Postfix)
	id 67ADB6B0131; Tue, 20 Oct 2026 03:56:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62B3F6B0133; Tue, 20 Oct 2026 03:56:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 519996B0135; Tue, 20 Oct 2026 03:56:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 290E56B0131
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 03:56:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B3093160949
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:56:01 +0000 (UTC)
X-FDA: 85342246122.11.F333211
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 039C620005
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:55:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DvxGAV+O;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792482960;
	b=ibA2Mmrws0hMArGgbKEJEpVP1CoKGcWKvKsRwPRSkqhUnPv14M3zhmR01nIyz7X8pJ+86N
	ndWYZzimMkzglyxTlApvpGB1ZTmwIjPvRwuO95TsRwAgidhZqWG9Ld0GfBP5uhZbg74gcz
	0bp/dFeDM/KE18nfs670vSk6ueQpVXM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DvxGAV+O;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792482960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mG3kNywBpCjlsN90sZBCwLqBblspQOk2h7zQBNKp7wI=;
	b=oytADzoepkLjuFSQX9j4MJcV6B19W4InMeBcn/rQPlkZMDU5pCwaE+vZLFf/Sk+YK0mRwn
	YUEKZl5pb0FHXhg99TOfcUQCPnsM/CWVoz76PSE5i2d8KEqeE1tA/jFtx13LeMOIOzTK5Y
	m2B5iYoh4loULHyPh8nvSacg0nt7ylU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 816C860DA4;
	Tue, 20 Oct 2026 07:55:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5174B1F000C4;
	Tue, 20 Oct 2026 07:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792482959;
	bh=mG3kNywBpCjlsN90sZBCwLqBblspQOk2h7zQBNKp7wI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DvxGAV+OaraT9ljQafttLtkjrCxCFCziGjRjdD6HwDSpmr4+0+MkXiqlz3dN3LkvR
	 MfM/McOKEjS6LdRZ6VGYT8CWPrJhfnxWW1JkPviBcxyJrcCOm6OYTyoDRKnLxDzXlJ
	 gygE0Udc9/JKsQXMuoyTGMOiyu0lM2/HJ4EK04aOfsQ60EhPsIji7jnMWfon937KHA
	 Ry9q64jMwMhte7oWL6nK2TbfURYsSEwUAOTeWoV8lik4nsuFWIv4b7hJNTI2x4/F8O
	 7YwJlW32gApnjMaxcZR64YRoxdu+mtO7KqcMSGUdLoFSnKOIkdJY0ZbdF6xyEHG1gX
	 XXeczGddFlPoQ==
Message-ID: <70771a19-9392-4fbb-8aaf-dcd40f60e977@kernel.org>
Date: Tue, 20 Oct 2026 09:55:54 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory-tiers: reset demotion targets of nodes without
 memory
To: Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 ying.huang@linux.alibaba.com, weixugc@google.com, aneesh.kumar@linux.ibm.com
References: <20261019184712.3422641-1-gourry@gourry.net>
 <DM91RXTJ5EFF.2YQARRB6TXQIK@nvidia.com>
 <atZ67m_JYJADzY-C@gourry-fedora-PF4VCD3F>
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
In-Reply-To: <atZ67m_JYJADzY-C@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jaeej13oq1h5ipwcyi965akj6xo9ig5c
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 039C620005
X-Rspam-User: 
X-HE-Tag: 1792482959-567075
X-HE-Meta: U2FsdGVkX192U0xQMOf51V2pYrlptzmguk9zizv5m3nK/8Dxiao2/u8IrsLu55+aIVFDg34jzOYmg/UfpHMPxURajtBbFlFa+Oak+kMZZTpM1RLXpl0c0lp14kUdmvDU1Wz0wzVlzAeY14Opx0ZjkyOz6dulpjIzWxqfB2FlG7a7uwIL7eHdpmQo6QPclRW61Xq6k5mtuqo70ZPDDlKnU0g9/RGtBKeFHX+ZPCKdtVsx8FMEBOXXP6GQUgkGgsNuNz+mCJnBEi16m/vYr4R/PfjINLGnez/BJRjXkqPuj/PXGdEv+lMunsHyksg1H9vKHzbtTuUD3Ick/JfAxQlE77+smXs8Z652LtR/HWvuZLbVx9UzrYtiEA+HUP7fbhbQ/ge4LEu1ZEqfJy/krcY6j6E4kdjFlH2Xacj9NtoS5zDo8VBeoGIkYiNt3dNg0OnefK1kuN0kGZOxiPf0KcVn47DmbXgg4a0PerHZlTaffewnRVcV/pNWgwxssUX9P0+6av/tjncSrX0vo2f8s0CjZ0EeLuToXboQOCCJarBw5Ozbz7cvdST8JtSBJ9Q2AUCLcpnnWD8MI6hL7VJ/dk8BOX6Rqi0npEjn0XdajHvdBtyiLLqfjn1wn/EgRx+dO+Ry/pDHK00HJiYZ692Zwj+gtY+z+GUyB3MV7/DmKrJ6YZvQbQvC4HArqdb+lQRpmAEhnKdpasCS9qjEY2rzRnwO0POx8Ptr2gJyLtOsHvMI0PLFd5O+yEASzNzlH9If+zoBf3a/oAXjLZS/M6Ff60ecIqWyHPBiKuma/2OhUqpWLbh3FoeAj0KmZodEDKpvyYyX7r2ytP7sp4Z4/cKvnEYV8g5TyQHWxok7Hk+GJLLeX2C/aLqnEmKyuagSSO6p9YEXvH6r+o66Qa1u0AU1GR/+QjiY0eZ9JAPK2i96cgDfgU+ms9gjQf5/OsXRBcrkYLqNuiHyPYJNREMDrfkU2ZN
 UlHHeTfn
 JH3qUKOR7D7uGXzMWxSzQULaGdAgpIDjvMY3KYNN0Y28/3aSwSTDN/M9xedrX2owGveBb3tfI65kGw46/0YlVodD9PCErcFlKxPowDxEJ1pO6sdSSwNzgwL2XEF5OtIHHe0NgNGuV73stv0PGYQox8vQEouP+vSpM6M2IETFRZEt9uc2akP/44+b9YAQ2gsw6D7op2/gZw+uyDKRlQOY3FzNoXksSVJ85/eghmJWMia79MpcVoRF/TZQHJDbYhrX22UE4dEfcJ4FEeFSFzp6oC/vYSS9smqaVz9ICm8sPkUR4h5uEP4Z6s73Xgt+yEfEnjPst/k+xcrIK38iIrIjfsC9Bla6vgy9riNK7l40LvQpOOyEgg0iJFyJRJEt1y4Sm6jIZ/GvbJLXw82o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/19/26 22:22, Gregory Price wrote:
> On Mon, Oct 19, 2026 at 03:04:45PM -0400, Zi Yan wrote:
>> On Mon Oct 19, 2026 at 2:47 PM EDT, Gregory Price (Meta) wrote:
>>> When a node loses its last memory, offline_pages() clears N_MEMORY
>>> before the memory-tier callback rebuilds the demotion targets.
>>> disable_all_demotion_targets() resets only N_MEMORY nodes, so the node
>>> keeps its old node_demotion[] entry while it has no memory. Before
>>> 6c542ab75714, the reset covered every online node.
>>
>> establish_demotion_targets() uses for_each_node_state(node, N_MEMORY),
>> because the to-be-online node is already added into N_MEMORY?
>>
> 
> NODE_ADDED_FIRST_MEMORY happens after the memory is already added
> (though not necessarily online). 
> 
> NODE_REMOVED_LAST_MEMORY happens after the last memory block is removed
> (and therefore N_MEMORY is gone).
> 
> slightly different timing for each event.  There isn't a reasonable
> change we can make otherwise.
> 
>>>
>>> A reclaimer reads the stale entry only between the node regaining memory
>>> and its targets being rebuilt, and it filters the entry against the
>>> current allowed targets, so there is no user-visible effect. To see it,
>>> online and then offline a node's only DIMM: a debugger still finds the
>>> lower-tier node in node_demotion[nid].preferred.
>>>
>>> Reset the targets of every node.
>>>
>>> Fixes: 6c542ab75714 ("mm/demotion: build demotion targets based on explicit memory tiers")
>>> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
>>> ---
>>>  mm/memory-tiers.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
>>> index 25e121851b586..7197f1a67a340 100644
>>> --- a/mm/memory-tiers.c
>>> +++ b/mm/memory-tiers.c
>>> @@ -378,7 +378,7 @@ static void disable_all_demotion_targets(void)
>>>  	struct memory_tier *memtier;
>>>  	int node;
>>>  
>>> -	for_each_node_state(node, N_MEMORY) {
>>> +	for_each_node(node) {
>>
>> I think the above code deserves a comment explaining why for_each_node()
>> is needed instead of for_each_node_state(N_MEMORY), because when a node
>> is added or removed during memory hotadd or hotremove matters here.
>>
> 
> Sure.  Will respin tomorrow and give others a chance to look at it.

A comment makes sense to me as well, it's not completely obvious.

Apart from that LGTM.

-- 
Cheers,

David

