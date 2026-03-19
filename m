Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 308BA1075280
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 09:21:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FBE96B044F; Thu, 19 Mar 2026 05:21:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A6176B0450; Thu, 19 Mar 2026 05:21:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 494C96B0451; Thu, 19 Mar 2026 05:21:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 38F8F6B044F
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:21:52 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D50901B7F37
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:21:51 +0000 (UTC)
X-FDA: 84562270422.16.B971B56
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2D8DA2000D
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:21:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mi2tRmrM;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773912110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=58Ew5fgmQ0b1OJzkt3S7f35rsFgDlrMKmlsn4IEXW/g=;
	b=6JNbKpFimyHbEynwrjfQdOWqZZq9+alb6hxe1NXyK0ZXWvU5hZzx3ynr6mcxJvyBZLLaHU
	Ec83ahk5yJg6EEreIwsd7hl6ONQG71DPkMQkDvfKf5RvnmpffNfKNpbcRubp8yTYn8HG7l
	16gvAs4EMAV2TDjjQKOIAJ5hYYLU9cw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mi2tRmrM;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773912110; a=rsa-sha256;
	cv=none;
	b=DNqif1o1R7k+T6MIkPaAKAMmS3EzGBnrSK4wehNK/OwMJsYeE58mK9O5fAX2IR0XreSQgH
	Px6+2wp7aSHlaHrWobaEKuBHe2FBGs5ZY25lIYrq2YDhI1zu3w4UTfqMYoioaxmNmhku1F
	yxdz6ZHMVYPrObgKToDELfNH1bt8EsQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2E95F440E2;
	Thu, 19 Mar 2026 09:21:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3078C19424;
	Thu, 19 Mar 2026 09:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773912109;
	bh=B6EqSu/m0AtpJJagL7Wx8GxNV04Uu+a6gD2Q5oQPp+g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Mi2tRmrMgxOLokAy7WBVBO+vqXEy30vNILVvF1MelwmHL+jsDxyu3UvCAPejBdc1z
	 HvV9ZINHHX5NYdfn8cc18INewbfUT0d1gsVoRd1fdPLuLEKIAJW1w3Zt9rW8kuNLJL
	 Djsh+mUznB/jkcdxzkJeOcuBpnSoLD6EH84y03bDAQcjaCTja3fkk1s11foF5leU0T
	 SKnS3LgvGST45kR6X4yt2rfiJ9jutmbSUSOjmG3vO06NUNnG+MewOn0x6uWKJ0duiW
	 lqLGGi6sCGVUBWP5JQj2RSjShLuNf9bhZ0yZAFkUwHH9OflrVygU7woH5Qmkc60IBY
	 8RDoMelal0ykg==
Message-ID: <8ab10631-4672-4196-b32e-7c5a01707424@kernel.org>
Date: Thu, 19 Mar 2026 10:21:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] kernel BUG in collapse_scan_file
To: Lance Yang <lance.yang@linux.dev>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: syzbot <syzbot+8961cb270ae74b4129fb@syzkaller.appspotmail.com>,
 willy@infradead.org, baolin.wang@linux.alibaba.com, npache@redhat.com,
 linux-mm@kvack.org, baohua@kernel.org, ryan.roberts@arm.com,
 syzkaller-bugs@googlegroups.com, dev.jain@arm.com, ziy@nvidia.com,
 linux-kernel@vger.kernel.org, Liam.Howlett@oracle.com,
 akpm@linux-foundation.org
References: <69bba3c0.050a0220.227207.002b.GAE@google.com>
 <e92ca212-9ada-4cd0-8d54-2f433d6d47a1@linux.dev>
 <10e5f1d6-077d-4783-aa16-6c8b98cb9e74@lucifer.local>
 <c3defcfd-74f6-4e70-b002-85bdcba44df9@kernel.org>
 <b963c391-8576-4351-b121-67ab9a9b2a1e@linux.dev>
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
In-Reply-To: <b963c391-8576-4351-b121-67ab9a9b2a1e@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2D8DA2000D
X-Stat-Signature: d4xidj65forsbw4uey6tnfjsrs15xf88
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773912109-570927
X-HE-Meta: U2FsdGVkX1+otpSFKYZgVk5N7oAjJbAhEOQsm6zd3q/dIQiYTcjmk1OpvSuZDNItEKLitUaVNpx3IaiWl3DJuaZkixSMwc8frDyTghMzgVJnRuJzagnDrP5huJha7ZQcictEP9osA4/yLptbPTuVlvP3JEnQYb3rbGEWQtjQX58kBXNADXEPB3jQE962x7oisSnwWhdzR0wAZ9nKgi22sCjCE/zi0xmj159DyoTshm3QwR8e6KcqKJorZfcTlSEpz+Xp3JmwXLb5bXCaEMu1ntH7Tt/QP3pbBQ8tWERPKZkhoYktCxqZjD/NKBh8BtbuoPI5sGQkmwLfoC3etCBA215Gc4a04fAyi8dTw74swJbu4qBCfmpFwrA0bva14vf7o6CGESxHCOfLPxCci/RtSWoKGxHWfWfy44lrrMxyl8lneO5ge0BLr/On/E0AlJ5Z6nor8aBKg9yyupZktEySA+WR/cP2lNW0j73QsTgtFL7Sqsr02YsSx5cO4O7hG/8HNmy5iV6AFfwxHLl9qeZbgVhgGwDUvqgmzoClkevkq7q4g04e2ChgsORet6nEfmX2NCwccilp0jHeW7mQLy9lYmbggACKYMe/skbFREHQj1GUS/WTzTtyoLEi+0OP+jiMqBAvgSzJYUfrH3VwhCQTfP1Or7vX8LZVW6lNP0tp+B08rDxIcGOU1bp5s3rJavpysYb8OsvW7mggZq7s5bFK/S7Edw8/eFwEK4RG/aH9XQXbUI6Y+EJwgYB7DHCgEIwdJGaNLpMkGPLsj7olKNO+qIvN0PnBXio4X5a4SbOouWC0vC7e9481Va6FoUQpUrKYV/OffEJHJgqsltEmoW1YGvmIb0/qKiDYMjhRXY4MJU4EuoMDOm6j1evtitqzFPpR6Ds2RvyTr4Bv02osMmHTcOhBT8ok9gpIgNpiRP0oPSKXfFVGV0ZSfHkYwuNl5Cl9majKsx3oxgOx8CkoxRq
 MTUGNfN6
 15JnmOTLtj0FEKnJDiyQhHSku9UksMkE55eM8r4eHM6hl5VZlzN54Fsw8X/p6wq7xoFWvgZwo57RJnVNAs311CoP/WWmTPt89etplMjmBbDs4XqiG5x10HYw09ZHjI1X8r5RoANhyR9Nmzsxrl6AYoTY7Ug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/19/26 10:14, Lance Yang wrote:
> 
> 
> On 2026/3/19 17:00, David Hildenbrand (Arm) wrote:
>> On 3/19/26 09:53, Lorenzo Stoakes (Oracle) wrote:
>>>
>>> Hmm we shouldn't leave this bug in place while working for a fancier
>>> fix??
>>>
>>> Can we get _something_ going as an upstream fix? We can improve
>>> whatever we do
>>> later right?
>>>
>>> David, thoughts?
>>
>> I recall Willy mentioning that the issue is likely a false positive.
>>
>> IIUC, that commit is not upstream? So it only triggers in linux-next.
> 
> Right. That does not appear to be in upstream, I only see it in linux-
> next :)
> 
>> Which means:
>>
>> 1) If it's a false positive, upstream is not effected (no XA_NODE_BUG_ON)
>>
>> 2) If it's not a false positive, upstream is effected but does not
>> trigger the XA_NODE_BUG_ON
> 
> Yep. So this particular BUG_ON is not affecting upstream directly.
> 
> That said, syzbot will likely keep hitting it in linux-next and
> generating noise for us until it is addressed there ...

Right, I assume this comes through Willy's tree, so Willy should
consider removing it for the time being.

-- 
Cheers,

David

