Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 610A0C982CC
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 02:11:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47C066B0088; Sat, 19 Sep 2026 22:11:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42C216B008A; Sat, 19 Sep 2026 22:11:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31B006B008C; Sat, 19 Sep 2026 22:11:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 068AD6B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 22:11:21 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D54DE1C2347
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 02:11:20 +0000 (UTC)
X-FDA: 85232513520.03.D5BA8EB
Received: from mail-m2459.xmail.ntesmail.com (mail-m2459.xmail.ntesmail.com [45.195.24.59])
	by imf11.hostedemail.com (Postfix) with ESMTP id 514B340005
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 02:11:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of zhen.ni@easystack.cn designates 45.195.24.59 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789870279;
	b=0lrj6WiHvOx0++FhLzn1nxudjDOLEvuQ547p8XXKhnJA4TLVSoMsDvCD47jm22jpKTABEN
	grpkqpLPOqW9YQynUiQGisjmaAvgBdhPEMlUhsD737NDaQGVcH3+H/b5ytwkHesEtRlRIK
	JrWbmwzM/yxGL5hZEmqKfb5s8XZOV4g=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of zhen.ni@easystack.cn designates 45.195.24.59 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789870279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O9TeQLRxH6Mh6I2pv/ZgHFSTRm6FYBfNDM2sqy7ZCH4=;
	b=ZQEUnEjvDL+04yFvkBJfpFzv+NbEcQhbJYPnlD3E23JbrthOuXcvDLyS6BLdx8Owu06/Iv
	/P6Zx0yNtF0lX5SyHIys+9lTj46cc0YjOwi4jk8qNrkE7rauLWd3wDS7TgPgpe4gPTLdyY
	pwHRBhPeecDuCJ4LrvCU7mIF0jaSmc0=
Received: from [192.168.0.59] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1f4881c20;
	Sun, 20 Sep 2026 10:11:10 +0800 (GMT+08:00)
Message-ID: <99a94068-ab37-47c0-878c-7c1ada5204b2@easystack.cn>
Date: Sun, 20 Sep 2026 10:11:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/8] mm/page_owner: Add PID/TGID/COMM and cgroup
 filtering
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
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
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <aqPmlw8WYW9HSzIV@gremlin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0bc94e7a60229kunm9a1984bc79d8c
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZQ09IVklJQ0JPSR8dSB9JQ1YVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 514B340005
X-Stat-Signature: pujq7ic1aksk8onjko65hbhngcicdfjq
X-Rspam-User: 
X-HE-Tag: 1789870276-139813
X-HE-Meta: U2FsdGVkX19tJRUgzV0zGmPCLFc+nCDkIHdQA/L2h1sg5O/pyfTuLw5ZN0zE7ysdJzZvI8lfV3cHwqZNfBQU3QBa6s6wPClX57OBCrv24/BWkC2Dkt1KOLAbzr8PQFG7HNDcwlzISKOCFycUH3MGjdZwvO9ddd+Xv4gkmrYWWTZRO14gWa+91QsYmmem45ppnGf+fKF7PjKOSkLE6xalJHVaRQVYQaJde0isl3/q6O1LVJC1liNSWKVNakv/D+tV5fL6+yFskLMZ62/QTlZht0EyNLAlZp/Lgbb4gXK/Njk7zdpA3Lc8ruul8+EKe62Pzf+Ril77a5ziGEk9e8xDOhmXccgVakbzYL3o5k0h9Md0sck66psHSFDjqN/Ve9CEcUeM1yOhYuYZEVPy3MvUAF0gbF4TqGbO3qX1JBvKi/ytTcd3koqRDGOgu/j7hQnkej2qUIHrQbVpAel+gQRrE5rX2zRx2anqgzGPsVZUxnVkx7rwe9ynetH4aUUDakwxHHf104cCTURjd+1AW+gUR2/EnlPkOdF2xj4q3ccUQN+1MHebDxj1TyKXd2Fasrxm4Wv5QYAPWVF5INMYVdVRJEUDOpmAqDFoF52oe2cr+FSH7raje6SdOQeADyN81Oydcy+E5tSksqoPULt5C5S4HsEbpROEa5iusKbE2Rl3gKCdcfAMTvTS3MVpnMa9tIDPzNa5rRUjVeTXaCijQ68XLFLQhaSwD7W6ivSegANNIobEnbbq44N+Bj8JRWcSdtcum3nHnM3PbEdpfpvK211FHf7k2T6yef7lv40+zUwytIKhmOcQmyWmWkOr/XU5iv4DO4LZoRt2/1zNuYdttSo282q+kDnpY8NLqFwXMSVBg900c/iA7XsqP/L1HDC1L7s7j0O509iErX6ZMOXKWCeXqE2HHo7mGJpd60FlwCgAvLTpY1jZ3s4rOAXFcGfphPK501pzAv33mmVJ0QuE5Ni
 j5jSBOiQ
 ajZGmdtV55kq/adSki5TjAFnV1P5Z2XVNPDOoUyq5Ec429f5dXEGTxwji+HS/9N26oYDJzvs2UL5jkZv0/ZJSA7asY/9rFtyB4QAxM3jasnqU79h2v+BUmCHtFkeZ5jA5GN3D5hrB0pw44mHWQLzURpbUWdd2WTImg09H/EPqhilnGIxwJtKhDac2m8kq4GLptgvIkFqUvNrp6hoY62hZ1EqdpkqL/jWOehFi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/9/11 19:32, Lorenzo Stoakes (ARM) 写道:
> On Fri, Sep 11, 2026 at 01:06:46PM +0200, David Hildenbrand (Arm) wrote:
>> On 9/11/26 09:58, zhen.ni wrote:
>>>
>>>
>>> 在 2026/9/9 23:54, Zi Yan 写道:
>>>> On 9 Sep 2026, at 6:28, David Hildenbrand (Arm) wrote:
>>>>
>>>>>
>>>>> Because it results in less kernel code  :)
>>>>>
>>>>> And less kernel code is good. Unless unavoidable.
>>>>
>>>> An alternative is to add BPF hooks like bpf_iter to do the filtering
>>>> and by default, when no BPF program is attached, everything is printed.
>>>>
>>>>
>>>
>>> I’ve also thought about a similar approach—perhaps a new bpf_iter type
>>> that could iterate over all pages by PFN. The advantage would be that
>>> you can fully customize what you want to print and what you want to
>>> filter. However, doing so would require refactoring the entire
>>> page_owner, and I’m not sure whether it’s worth pursuing in this
>>> direction.I’d also like to hear everyone’s thoughts on this.
>>
>> Certainly better than having more and more manual filters added to the code base.
> 
> Agreed.
> 
> bpf seems the ideal fit here I think?
> 
> Means that those who want this information can get it and those who don't are
> unaffected.
> 

I have prototyped page_owner bpf_iter and confirmed it is a viable and
valuable direction:

1.Most parameter parsing is offloaded to the existing BPF verifier,
keeping the page_owner kernel-side logic simple.

2.Filtering and printing are delegated to the BPF program, providing
greater flexibility and enabling more complex composite filtering.

I plan to further refine this patch series, but it will likely be
submitted as a separate series, as it represents a different direction.


Thanks,
Zhen

