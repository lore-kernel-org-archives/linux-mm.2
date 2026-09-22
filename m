Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8E02C982FF
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 12:33:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFD426B009F; Tue, 22 Sep 2026 08:33:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B87BB6B00A0; Tue, 22 Sep 2026 08:33:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4F266B00A1; Tue, 22 Sep 2026 08:33:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B9FC6B009F
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:33:54 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EA2338046E
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:33:53 +0000 (UTC)
X-FDA: 85241339946.30.FFEA3DA
Received: from mail-m1602365243.xmail.ntesmail.com (mail-m1602365243.xmail.ntesmail.com [160.236.52.43])
	by imf19.hostedemail.com (Postfix) with ESMTP id 03F2E1A0003
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:33:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of zhen.ni@easystack.cn designates 160.236.52.43 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790080432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VgTQH4b1BJ6GTwNVxNedgXEIMab+EQPizdNbAYN5nEQ=;
	b=Jqmu4VRl4rqswFpObOv5uxk4rkGU9o31ywRH9EuCxTolnu95mEjZ3Ch8vMCaPkoRgpJ02/
	zUCspGFMqbHy3QVjNkILWdNVqxqYpVBWKV5f7if1Sg69iSui96Z5NsZRVNKaHL/cDLIp5O
	DHaPWE+DcHbluz4oaaxULJIPnq3aXlA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790080432;
	b=erWzQxYuLvSEc+qV+4Rae1MPbVPh2Ct+qAEZ/CkYertRKNDP5nGk95udI3ZOMZnlSGOJT9
	i6S0bzMoeM1EjTAD4ARuDfrSz3hznOmmoORp0t0TLxvatqbRHX+fLBdYl0suwuc267XRCk
	ET2yXXqlPXlEbRco3pfKFGUBndCt+jY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of zhen.ni@easystack.cn designates 160.236.52.43 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
Received: from [192.168.0.59] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1f642799d;
	Tue, 22 Sep 2026 20:33:41 +0800 (GMT+08:00)
Message-ID: <0894f68a-9cef-47ac-bf8e-86cb18b6cf67@easystack.cn>
Date: Tue, 22 Sep 2026 20:33:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/8] mm/page_owner: Add PID/TGID/COMM and cgroup
 filtering
To: Zi Yan <ziy@nvidia.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260907082620.2083838-1-zhen.ni@easystack.cn>
 <79548641-25f3-4ec3-a549-782fad168962@kernel.org>
 <6e8bfb0d-d595-4e6b-9536-0323ada57e25@easystack.cn>
 <b8e23456-00af-4097-a769-210a087d2b90@kernel.org>
 <22D1EC4B-FBCB-421E-B8DA-345B5F3505FB@nvidia.com>
 <d8d34e16-57fa-48b7-93a9-afbf4b950ce6@easystack.cn>
 <98ca914b-4722-448d-b5a4-7f095d0ca433@kernel.org> <aqPmlw8WYW9HSzIV@gremlin>
 <99a94068-ab37-47c0-878c-7c1ada5204b2@easystack.cn>
 <8997BF57-2124-4F71-9CEE-6F7D31A15D87@nvidia.com>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <8997BF57-2124-4F71-9CEE-6F7D31A15D87@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0c91b8cd90229kunm1cdcecd753db0
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaTR4eVktDSBpNHksZGUweHVYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVCQk
	lOS1VKS0tVSkJLQlkG
X-Rspam-User: 
X-Stat-Signature: srre75senzsb34xyexrrrbjm9fpgg13d
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 03F2E1A0003
X-HE-Tag: 1790080428-549171
X-HE-Meta: U2FsdGVkX18pvcvIbvMXNOBpqUwgYRGNtIApy1rRgl3d0qb4/f7aRQESbWNDavZTuM4G3Z9e3o4fWKEHPGm8q7iYtEX1zE3GUFmYYo77B/r7qmC9nSRuVtXIExBPUxGdVbDsnv+1md07KVE528j1aYHoufIc8Czz08Gn7WUAJuM+0Mr+pAVYvIJeXp2g7Sovp6JhZ9CjY0L5IKMb7zyWIbEcVjNilL9rrnwZKMxcrp3nNSb0xI34eYljBNzTQwIk435rp5o+Jnbd1x4ADempZywPpujkU1QtTSocASzkPjVD6Q9H8uxyCb7BcP7kRT1FIXySRV32L1OWvUJt/Ya37ObBAwhOr9fiDNcklX5XmnRWQ069y4rgjospWQx5IMT6oc2v/OB+WVvTkA9l9QzeggMAN/4ffKWWU4T5IRcfcVgTtsjMltY8Jga5lF2cNFAfrYRtFFl9UaBmrTbHrVnwyVGzwdKLCFJOMrsuQPFeQZEjIPdEeB0L3Us1rp4P/3kC8Oi+QTxDGSu5yanODrdIz1xqx04f0i2Ghwccyifa1vFMoUD/FmAn71FCkm8dmaYACNcgsQRILrvaSM5da7XI1Lv5VgsitPZ1/R67s7cm8viZn2AD8m5rv8Qd4zWJKFF3PNxZKVGXlFe07w0TyBYEFHRJUE4zvWRrv0sQCGxOFtgDSg9FYaWVWeLqP1dG8ZDBE3+TXQR9r8rRYSM/Jd2IyeUS0Kdl8QVd0669qJS22wtCELvXcMzq7drUa8Yt7V1LnGjqbqCz1svTQmLQCBzHp5uZZlYLI4XgCW0nn4EhP6xDOWPFsrK+PB5PPUg7vqNKq8uiCMRuOkpn/gUioamjsN4LCG4IL/MTr+Ap8tgSpDk8DzXqzWdrFOgpA2dfJ7Cr6j1fvlZ3GPqyCPWZTAESJm7/crD7hKaE7k1PfN1cROpQBfaljJlIXKeoyDUPQ6iHUml9pp8Sr+bhYA7pXOA
 gAUBYAZD
 RIbTqNE16ECE0f/0VXC1RDaDh8eyMUaiPo0btIOFLbQLZWt1DMDI6znNWFHKG3JYWewBy6uUfQQ/04oHClqrFR0mZaedKXAYWgdrKTVuYSb2YjAgNKv7ltWtF/x5djwba3LswQerFHd6HycNIVjWigfSX3nCoMrw+YZIVdtYPpOnpkIkXdVK1MJQztA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/9/22 00:25, Zi Yan 写道:
> On 19 Sep 2026, at 22:11, zhen.ni wrote:
> 
>> 在 2026/9/11 19:32, Lorenzo Stoakes (ARM) 写道:
>>> On Fri, Sep 11, 2026 at 01:06:46PM +0200, David Hildenbrand (Arm) wrote:
>>>> On 9/11/26 09:58, zhen.ni wrote:
>>>>>
>>>>>
>>>>> 在 2026/9/9 23:54, Zi Yan 写道:
>>>>>> On 9 Sep 2026, at 6:28, David Hildenbrand (Arm) wrote:
>>>>>>
>>>>>>>
>>>>>>> Because it results in less kernel code  :)
>>>>>>>
>>>>>>> And less kernel code is good. Unless unavoidable.
>>>>>>
>>>>>> An alternative is to add BPF hooks like bpf_iter to do the filtering
>>>>>> and by default, when no BPF program is attached, everything is printed.
>>>>>>
>>>>>>
>>>>>
>>>>> I’ve also thought about a similar approach—perhaps a new bpf_iter type
>>>>> that could iterate over all pages by PFN. The advantage would be that
>>>>> you can fully customize what you want to print and what you want to
>>>>> filter. However, doing so would require refactoring the entire
>>>>> page_owner, and I’m not sure whether it’s worth pursuing in this
>>>>> direction.I’d also like to hear everyone’s thoughts on this.
>>>>
>>>> Certainly better than having more and more manual filters added to the code base.
>>>
>>> Agreed.
>>>
>>> bpf seems the ideal fit here I think?
>>>
>>> Means that those who want this information can get it and those who don't are
>>> unaffected.
>>>
>>
>> I have prototyped page_owner bpf_iter and confirmed it is a viable and
>> valuable direction:
>>
>> 1.Most parameter parsing is offloaded to the existing BPF verifier,
>> keeping the page_owner kernel-side logic simple.
>>
>> 2.Filtering and printing are delegated to the BPF program, providing
>> greater flexibility and enabling more complex composite filtering.
> 
> Without attaching a BPF program, page_owner could still print to
> the console, right? Otherwise, it will break existing users without a
> BPF program. You could add a hook to decide where to print the results.
> 

The existing console/debugfs path is untouched -- the BPF iterator is a
new, opt-in channel that coexists with it. Without a program attached,
page_owner behaves exactly as before.

>>
>> I plan to further refine this patch series, but it will likely be
>> submitted as a separate series, as it represents a different direction.
>>
>>
>> Thanks,
>> Zhen
> 
> 
> Best Regards,
> Yan, Zi
> 
> 

Thanks,
Zhen

