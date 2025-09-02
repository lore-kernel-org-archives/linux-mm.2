Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6AD0CA1002
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 02:28:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BE0F6B0005; Mon,  1 Sep 2025 22:28:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06F116B000E; Mon,  1 Sep 2025 22:28:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEDFA6B0010; Mon,  1 Sep 2025 22:28:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DBA926B0005
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 22:28:25 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7A1DDC0AAF
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 02:28:25 +0000 (UTC)
X-FDA: 83842726170.13.DD59E0E
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id 45DFB40003
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 02:28:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=YgbeZD9f;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756780103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6NbI4kzFCdnbgFqsQU3j3woE9OiOn/2nBz2NzNgD994=;
	b=Ho9tGT94GOVE/YG+EPNrmOWia2Io9sMfwmRiHkh3ScwIgOizkEgMF/ZomKLegYM4h2Zbnj
	I4Fb9rQ8V8WwSLuSLQsC2inWuIBIQk+3YmOP113YXjyuS8esX+QT9TyLh80XDdjlIMmYzw
	ezmM9huxEDEyu40tj5P40jqxAL74T68=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756780103; a=rsa-sha256;
	cv=none;
	b=R66nn1KzlAPXij16XEWnrrvmFPefqDP4/jzb4qajJzUq/5MjCJX7O91dB77u3PUGTqXOe4
	Zzq9OL+pqEnmWVjVffROwlIF97ysimoFM3k836pm3k43V6Ta0fiNutiGcLuouoclhFze5J
	SuIwg8u0vdcXKmw7jtAiFdYZ6sK4gd4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=YgbeZD9f;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1756780098; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=6NbI4kzFCdnbgFqsQU3j3woE9OiOn/2nBz2NzNgD994=;
	b=YgbeZD9f3ZwJkvW3gup18IenWBmrwcyiAcspg1xez3ROoheVb0aK7yxShRAcjGRXdXiOFMf9ZxKErcUCKrWBc8bBYpmSB269sVB37KqTW/h1fg9SxdOwGCTfljkGgQEWfv0c4YBuVbpGgEj6Jcn8UY8WlCrNVtC7AsY+sAannjs=
Received: from 30.74.144.117(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wn5svZT_1756780095 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 02 Sep 2025 10:28:16 +0800
Message-ID: <eb02c281-6d41-44af-8eaf-8ffc29153a3a@linux.alibaba.com>
Date: Tue, 2 Sep 2025 10:28:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 00/13] khugepaged: mTHP support
To: David Hildenbrand <david@redhat.com>, Dev Jain <dev.jain@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, ziy@nvidia.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, corbet@lwn.net, rostedt@goodmis.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org,
 peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
 sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 kirill.shutemov@linux.intel.com, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com
References: <20250819134205.622806-1-npache@redhat.com>
 <e971c7e0-70f0-4ce0-b288-4b581e8c15d3@lucifer.local>
 <38b37195-28c8-4471-bd06-951083118efd@arm.com>
 <0d9c6088-536b-4d7a-8f75-9be5f0faa86f@lucifer.local>
 <CAA1CXcCqhFoGBvFK-ox2sJw7QHaFt+-Lw09BDYsAGKg4qc8nSw@mail.gmail.com>
 <CAA1CXcAXTL811VJxqyL18CUw8FNek6ibPr6pKJ_7rfGn-ZU-1A@mail.gmail.com>
 <5bea5efa-2efc-4c01-8aa1-a8711482153c@lucifer.local>
 <CAA1CXcBDq9PucQdfQRh1iqJLPB6Jn6mNy28v_AuHWb9kz1gpqQ@mail.gmail.com>
 <d110a84a-a827-48b4-91c5-67cec3e92874@lucifer.local>
 <95012dfc-d82d-4ae2-b4cd-1e8dcf15e44b@redhat.com>
 <bdbb5168-7657-4f11-a42d-b75cce7e0bca@lucifer.local>
 <e34e1ffe-c377-4c9a-b28b-ca873f3620ac@redhat.com>
 <db2320ee-6bd4-49c1-8fce-0468f48e1842@linux.alibaba.com>
 <c8c5e818-536a-4d72-b8dc-36aeb1b61800@arm.com>
 <2a141eef-46e2-46e1-9b0f-066ec537600d@linux.alibaba.com>
 <f34b5fcb-6a97-4d97-86a8-906083b53be6@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <f34b5fcb-6a97-4d97-86a8-906083b53be6@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 45DFB40003
X-Stat-Signature: oz9qikw3r5kpyfqoxpe6xy8kkf5hb9bh
X-Rspam-User: 
X-HE-Tag: 1756780101-707650
X-HE-Meta: U2FsdGVkX19SGA8/p5Dqi+Y4Z5ARGmxm7AMsVwIKnbAwxSEgQ4o3B/+gZPCEg4zuC9KeRCi949S1qrS3oFZetorDJvRsME8Ruw3f4xA/TGKRyvipK2P9YNeeGOCQGYeCLdinFc9PDr0g+3UHXTs/yp3G46cFcJ25atabi19QNmH6DBMa4dX8/mvk+vWFmsWrD+WncgWytFG+NwojpXmb/ZBxROaailG9cPbLlcGaMCP/T7Q1UFiRys3NgHxJaasVGanHkPRlNzcVYNAAtWSXWhlt7X0O68bwx+nUtI7UNmSd42PETFIWc+0PX/FnXDhEEqsAdnmAZNogzv6OSim9x6+xoUwohjcLkcn7QSggwb30bJ6tia1f4FaO2qjyTw39JkW+O2SEq6aa7VvD5niVWQOVy79gR8TWkWmOv0qlZApP0Mu7cUKlpJK4OZPO12X5uA1Ra8ekGCBZXA3UEU6iitNQQp+tIaom9wOfa1DVVEaimFgXsuNbhC9LYS30DeyanjA5Jr6Hlep4HXZVHxcqpD8GJOCAgjyiTqkvpmtNMwjdYqWIpjCb652E6LR+zAOhTpzcHxbqBtCAbNKLGMxuesZOSP03c5eIE/s6GMDwNj4Lt+K6iJiecipqfVj08t2LkBQMs0HGd5ccMtB2sn6uMzd6lKOUyZD6MCp3iDxh7+v4O4+kghoEBLrbP4DGvVEQQbLQxuOQgk3qu8F9tSX0Od4C/AEJIQnfh2ARm3aNsNBZH9egHtWBIsGQUwC1vpLbBrnuAptNXli8v8d7LLYB3GedXMGfr0FfHhNsNj8Gytq9OkMORoZwCc74MtWXUiBjb1sU01TthTj3a1rNWJHMxAlvMr3qnq2q/ooeVZK7iIPKBXL7jKeskcOoTMyXJ7GAPXSIbVMSrBCis29Y11sntqCd2ZwclWvZuG5OIkw5bsdnVIfMyc8pP9ZlzkVn6Z3DjyDeBzgZX//fU2wNpFV
 Vlir3n1Y
 ObltBIEoEgrgxsAED3vcy18ZJ0f/2wvmgS9ZEaTkYxL3nC8oVNa1mOO0gPQ5a2jAhn1T/3kmqwkeaAbARPl9F37+ymcOpBBHlmskvUFWXaI2sAGZieeEj+Yo6Y4tea1euUk9JWDPclq8vbUPXoiBjrI29WUNVJ/9M968l29joIlhz9r00CuozrpZ2b4tO9pC/3rkJn0v3JqQ6MWVHPYmiyr4AkEE8wy7XGvaMR81uG5WkjRN9mTbhkcFUw43eN+8265iVd4ewGSEWVCfEk96qtiItAwTW+Jp/Y3STKY1bAzgtpTrjzLyCDQ4Y5hxYEOdyKeS72QjkJINhGWCZXmP9QjuTkQOf1ViAsC9Q0yq9XpfLdCh8ARV/Vktvp4enoDUKYwbAPWd+fIn87jQWNpKjDR7Zgg3C4xEGsJM6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/2 00:46, David Hildenbrand wrote:
> On 29.08.25 03:55, Baolin Wang wrote:
>>
>>
>> On 2025/8/28 18:48, Dev Jain wrote:
>>>
>>> On 28/08/25 3:16 pm, Baolin Wang wrote:
>>>> (Sorry for chiming in late)
>>>>
>>>> On 2025/8/22 22:10, David Hildenbrand wrote:
>>>>>>> Once could also easily support the value 255 (HPAGE_PMD_NR / 2- 1),
>>>>>>> but not sure
>>>>>>> if we have to add that for now.
>>>>>>
>>>>>> Yeah not so sure about this, this is a 'just have to know' too, and
>>>>>> yes you
>>>>>> might add it to the docs, but people are going to be mightily
>>>>>> confused, esp if
>>>>>> it's a calculated value.
>>>>>>
>>>>>> I don't see any other way around having a separate tunable if we
>>>>>> don't just have
>>>>>> something VERY simple like on/off.
>>>>>
>>>>> Yeah, not advocating that we add support for other values than 0/511,
>>>>> really.
>>>>>
>>>>>>
>>>>>> Also the mentioned issue sounds like something that needs to be
>>>>>> fixed elsewhere
>>>>>> honestly in the algorithm used to figure out mTHP ranges (I may be
>>>>>> wrong - and
>>>>>> happy to stand corrected if this is somehow inherent, but reallly
>>>>>> feels that
>>>>>> way).
>>>>>
>>>>> I think the creep is unavoidable for certain values.
>>>>>
>>>>> If you have the first two pages of a PMD area populated, and you
>>>>> allow for at least half of the #PTEs to be non/zero, you'd collapse
>>>>> first a
>>>>> order-2 folio, then and order-3 ... until you reached PMD order.
>>>>>
>>>>> So for now we really should just support 0 / 511 to say "don't
>>>>> collapse if there are holes" vs. "always collapse if there is at
>>>>> least one pte used".
>>>>
>>>> If we only allow setting 0 or 511, as Nico mentioned before, "At 511,
>>>> no mTHP collapses would ever occur anyway, unless you have 2MB
>>>> disabled and other mTHP sizes enabled. Technically, at 511, only the
>>>> highest enabled order would ever be collapsed."
>>> I didn't understand this statement. At 511, mTHP collapses will occur if
>>> khugepaged cannot get a PMD folio. Our goal is to collapse to the
>>> highest order folio.
>>
>> Yes, I’m not saying that it’s incorrect behavior when set to 511. What I
>> mean is, as in the example I gave below, users may only want to allow a
>> large order collapse when the number of present PTEs reaches half of the
>> large folio, in order to avoid RSS bloat.
> 
> How do these users control allocation at fault time where this parameter 
> is completely ignored?

Sorry, I did not get your point. Why does the 'max_pte_none' need to 
control allocation at fault time? Could you be more specific? Thanks.

