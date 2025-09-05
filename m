Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7F82CA1013
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 11:55:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EE918E0019; Fri,  5 Sep 2025 07:55:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C67F8E0006; Fri,  5 Sep 2025 07:55:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B5738E0019; Fri,  5 Sep 2025 07:55:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0767A8E0006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 07:55:31 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BA88D1A0126
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 11:55:30 +0000 (UTC)
X-FDA: 83855041620.23.98A4758
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5D8F42002A
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 11:55:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ifbpZkfy;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757073328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4cRISMBuuCLgX6f4naUjs5MatcD3bZ+89nNOlWRyt7w=;
	b=0x73wgfggAVC7iwHlmi3ojXGdnkh7yTdeC2PFrfCFv3fodXYrjuDNnW/cmYIxEtHjDq0bI
	Nbi//OY+DKELjRXi/8xc0xzYzQMEUDj6CWuO2xm0eooX9v+rzR/g/u+6Zj+eQ+r9xEfcjm
	ntfG7ET3OjX2rmSJ6YcT2211gEYMhPI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ifbpZkfy;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757073328; a=rsa-sha256;
	cv=none;
	b=52s9NsNolZeHP8W4KTJfaZkyDUngRhn4lhnmaAC8Zk/Cq1wH90ZgNPCA7AGj8zpcwaXYb9
	kTsi6jYUtMvpp5VUv2HeiZYCRjXZ7UenvR4SJv/MGLIxQdE5WcJ+WV36KHww2Z7LjhJk6a
	yqG5I1sEkOXy0UrUdUoFmY4NjEiX3QI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757073327;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4cRISMBuuCLgX6f4naUjs5MatcD3bZ+89nNOlWRyt7w=;
	b=ifbpZkfyfj/7DVQd0mzQXT5cQ6Kcsf8KeuEKXsSgXFlkuIkR7Pv7O/kc1OL/AjyDgzjAm1
	2T+Nj+v/05gsSOY3WHjyZ7odw36KYZHOgjfSAkU/EGgn2T8Y+nWQd3+ZaLFhCHHi5/jUv/
	NPGBY1q9o/Sr5abH8IAUZ0os2P3Zz8U=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-262-1VWbU0n3N2KQ-tv2rYstvw-1; Fri, 05 Sep 2025 07:55:24 -0400
X-MC-Unique: 1VWbU0n3N2KQ-tv2rYstvw-1
X-Mimecast-MFC-AGG-ID: 1VWbU0n3N2KQ-tv2rYstvw_1757073323
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45dda7c0e5eso3772095e9.0
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 04:55:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757073323; x=1757678123;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4cRISMBuuCLgX6f4naUjs5MatcD3bZ+89nNOlWRyt7w=;
        b=jgXs2UZuIVWP73oIicRy2I7voV4rV8tVd7wg36Qg9GP2tPoguopWNF+ZuuLoXFEdsX
         hKMClOCj9kmWGEAKYUTw2PXisAn/EkfTs+rr9Cfs3o0HT/Kac9GkYaqtCn3X+FHE09J9
         72wvHfxwgD8oONxDgQy7Ly6Qyj25HEju/e6o8IDh1qkWk5GzgQUjA8n4iicTigo0c6si
         P0CE5CuzrbqP6pMRMKMAxcoaM6miQ+Nnrv0uvT1eHI45lxP/pZAkVGbBAUSJwehbDrUH
         wR6eTA5pI1SeY2397zuYjuwN2jqzOLlIxH24ttdvw6gxoEl++CRiH5FWerhZBsk1g8dS
         mIaw==
X-Forwarded-Encrypted: i=1; AJvYcCVGRjGjMsAz+2f71zTrqh/3Bjbii3V7mUXJxMHCCrB5jvBHzkz5BB0/zUpu9wptPt+D9LvOItoPGQ==@kvack.org
X-Gm-Message-State: AOJu0Yxx8SaNKVWQxTUsCqxxGsC6XCueqwM5tb6KiQP2WF0pZpITAnpm
	tIR0ydX6HMLpColgCJm8viSRAEmUgO7ZmfuyMipqOUyWAh6EoZ3urZdowZS07aFgw2/D4uuf83k
	toGhYtNQd2bvQIPzytYX/tYTzVTXSFkbvs1qXyVdgLVPM5nOe+VfT
X-Gm-Gg: ASbGnct2yXkfJ1Vuhiz/tx/ZwqGBm2YFBQOj6sBKQaZtlyVD3kST6A4xSr/WdBxiz4J
	wOoxXXSsYuRrvRcoo5XfPwpwaulfXNFiTKh9VD81MKANjrShphcCIdyMOsSM59uWB5Z5j9dp8mM
	LH2z14rRkf/FWIa5/GKU2BfYVPsPP695co0iqOcu7ZdU2GK1KljZVSkofEpl/OIJl4iz3njvZD5
	s7GwiGoL/d0RRiBRlmvkeeI4K2ZyF8Apz9qtdOjQbqtEwAZV83hDWSm6gvY0qvh7vfwwZ+r+iQO
	Ne8H/6TAQsuIdzLGU6MurSJAQH7VDWGqT4vD83PYYfs7mpVVE+8eQOS32z+7doROgxIcKOMHm2M
	0XkOjgs0STy2DpJvv37dRoK2+BhmQ1a4wKtQkB5aA2ZnHEV5TmNmQuqbP
X-Received: by 2002:a05:600c:1384:b0:45b:7b00:c129 with SMTP id 5b1f17b1804b1-45b8558d694mr190644935e9.35.1757073323374;
        Fri, 05 Sep 2025 04:55:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGCcrnrvc4r4+WNeVxo8uiZgoKTe2Wmsv9/zx+pciFYGL6K13k0lLB8PUGJjfD3xhbwr1XfWg==
X-Received: by 2002:a05:600c:1384:b0:45b:7b00:c129 with SMTP id 5b1f17b1804b1-45b8558d694mr190644535e9.35.1757073322777;
        Fri, 05 Sep 2025 04:55:22 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4d:e00:298:59cc:2514:52? (p200300d82f4d0e00029859cc25140052.dip0.t-ipconnect.de. [2003:d8:2f4d:e00:298:59cc:2514:52])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e18537589dsm5619251f8f.54.2025.09.05.04.55.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 04:55:22 -0700 (PDT)
Message-ID: <65ce71c1-72a5-415e-9059-027167abf129@redhat.com>
Date: Fri, 5 Sep 2025 13:55:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 00/13] khugepaged: mTHP support
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Nico Pache <npache@redhat.com>
Cc: Usama Arif <usamaarif642@gmail.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Dev Jain <dev.jain@arm.com>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, ziy@nvidia.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, corbet@lwn.net, rostedt@goodmis.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org,
 peterx@redhat.com, wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
 vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com,
 yang@os.amperecomputing.com, kirill.shutemov@linux.intel.com,
 aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com,
 catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org,
 dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com
References: <db2320ee-6bd4-49c1-8fce-0468f48e1842@linux.alibaba.com>
 <c8c5e818-536a-4d72-b8dc-36aeb1b61800@arm.com>
 <2a141eef-46e2-46e1-9b0f-066ec537600d@linux.alibaba.com>
 <f34b5fcb-6a97-4d97-86a8-906083b53be6@redhat.com>
 <eb02c281-6d41-44af-8eaf-8ffc29153a3a@linux.alibaba.com>
 <286e2cb3-6beb-4d21-b28a-2f99bb2f759b@redhat.com>
 <17075d6a-a209-4636-ae42-2f8944aea745@gmail.com>
 <287f3b64-bc34-48d9-9778-c519260c3dba@redhat.com>
 <ad6ed55e-2471-46be-b123-5272f3052e01@gmail.com>
 <CAA1CXcCMPFqiiTi7hfVhhEvHs4Mddiktvpmb7dMe4coLDF0bgg@mail.gmail.com>
 <61afc355-1877-4530-86b7-e0aa2b6fb827@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <61afc355-1877-4530-86b7-e0aa2b6fb827@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WskrfTuT_glRVsFLBIV0txbDBpJYomH_lzu78H9ERnQ_1757073323
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mmhqfkfpdmfh88qi9dzya5jrf4czicpp
X-Rspam-User: 
X-Rspamd-Queue-Id: 5D8F42002A
X-Rspamd-Server: rspam01
X-HE-Tag: 1757073328-828998
X-HE-Meta: U2FsdGVkX19JNRcU5nJDNY5+7ttzVQqG3x507xx1pFgbMu4D8N0BBUwhddoe0t+VPVNtZ6CdAO5/2Y1WErv5Ee8AdQlaY17ZyR4SughNxfZ99lvfBmDmiwIJRJUqwQd5niZazFuM7MK2FDj6pi818jo8hZ4Or+0YCWcE2hGGcFvoTMfDIC2mcz18MOnabNOaKhiD3AN6WNUfUDXaOPtQqnFLp1M7+dgU+u2geCWioBtFxPZR7JFqjiKZA+3iYFWp7vYldj3k+UjsrkuX+/aNSbtSilC3gq1XKuDwCVRGfKCbsMVkLGVs4o3eaCs1aj7+dr7DfkNZA8GVYUDTV24Nu+mjUp/RnMwEvFjEf5Ojz5H8iAFvAGUcCOK60h1EgAHdDXTJzAmjeyZlXIQoDGvTwEEAm/rNUJ2mFGqFShyhgalJ/GJaL+VymV7HcMUk3GPgWmMiy7dfr7bG3aVgK5Zn9ob4jaj7SNT30Jm2lnGHg0MZZhHh/fNHtjwNtrxw1SuH/cBO7Snz0m4QW3hUFXMW84/DVtEviIZv/twK6rg7tYgz0uq6+X+5KBuFwYTHPeHALFeAP245Hyijltfh9EMX+3fzAapvCBbeP/3lKcyhrh4ItG3v0ndpp4EQM9rJ4O+SEOgOHS6N6JoGa5z9HYMROINr/G5nFHzCTZX/t9u54l+umprvXFgu2FBTRNc+TSuIvwfPCpkKqA3c6qSGkwJE4NeEBL4VV0xLKW8E11QIX2ylS3lSlE2AKJK9TkhO9Scc8eSE+2k3zXe+upZhhPgvM+2fA8yFineLJi9lGkfNzXm0QTXnhv00KQvLht/a7+3roG847klhaXEo2h3C2z8UHi3HW0v1omOYHLyfl4I3su2m07oGarGULVvhNpLiy7/tTlfaypFLq36wUp3hEV2nn16+ickHjRbvhM42gzSHEYPU/v+qh0G4okAA7Jawq3FiYfJ8cEARnEgvYAQW8Ib
 l65bT9JF
 UL7pLzmf/xj3wNRTnpdvpmUMPGvnwZtWvzlOMUugwzW3JQ6a1Lhr7E72sUN46ongkMtRb6+ehREWoaxoZ0+NbO4a3Lqu67BJvwgztYTRKy1U2X0lNCBVV9uNezXd2wd1cWzcr4wMf/Zx6LP6CYHdV0iSDtoOfyYZgIWiz/VvjafgwqpA2Wr4FmYLwFe0Pn/QfoUH3GemQ6GRv7cZsE6FTrnJbUXS1jT/C6q4I/gKZUUGo/Q17liYqW1UyvH/Yl3ejG9UQtqmb3oBvhndDMWVXtoONm2XRCge6rF/rtCXblDX9+yJTmwTS8+VlaXZaPXt3kO/eckNVnqpN/TyU6tG0jnyDNkNU65LPRF91H4SIpuB1K0hV4fasQxVIQPMdbBZ5qmg6QCBVZRFvIQVVSZPS44MkUlQxKZJyfHRzYq1bYvr4HcKHrIY58cGP76nd8n89YatoEi+l2cqf3FibPRUszcjetgqbRqQvuXaquNk4DyTjkTEMv3upOkX8SpPb/kBdp/K9G3fcKFrF29PkRoqYHuCM1h2ik9wHNNlbmEMMJsJj6kU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.09.25 13:48, Lorenzo Stoakes wrote:
> On Wed, Sep 03, 2025 at 08:54:39PM -0600, Nico Pache wrote:
>> On Tue, Sep 2, 2025 at 2:23 PM Usama Arif <usamaarif642@gmail.com> wrote:
>>>>>> So I question the utility of max_ptes_none. If you can't tame page faults, then there is only
>>>>>> limited sense in taming khugepaged. I think there is vale in setting max_ptes_none=0 for some
>>>>>> corner cases, but I am yet to learn why max_ptes_none=123 would make any sense.
>>>>>>
>>>>>>
>>>>>
>>>>> For PMD mapped THPs with THP shrinker, this has changed. You can basically tame pagefaults, as when you encounter
>>>>> memory pressure, the shrinker kicks in if the value is less than HPAGE_PMD_NR -1 (i.e. 511 for x86), and
>>>>> will break down those hugepages and free up zero-filled memory.
>>>>
>>>> You are not really taming page faults, though, you are undoing what page faults might have messed up :)
>>>>
>>>> I have seen in our prod workloads where
>>>>> the memory usage and THP usage can spike (usually when the workload starts), but with memory pressure,
>>>>> the memory usage is lower compared to with max_ptes_none = 511, while still still keeping the benefits
>>>>> of THPs like lower TLB misses.
>>>>
>>>> Thanks for raising that: I think the current behavior is in place such that you don't bounce back-and-forth between khugepaged collapse and shrinker-split.
>>>>
>>>
>>> Yes, both collapse and shrinker split hinge on max_ptes_none to prevent one of these things thrashing the effect of the other.
>> I believe with mTHP support in khugepaged, the max_ptes_none value in
>> the shrinker must also leverage the 'order' scaling to properly
>> prevent thrashing.
> 
> No please do not extend this 'scalling' stuff somewhere else, it's really horrid.
> 
> We have to find an alternative to that, it's extremely confusing in what is
> already extremely confusing THP code.
> 
> As I said before, if we can't have a boolean we need another interface, which
> makes most sense to be a ratio or in practice, a percentage sysctl.
> 
> Speaking with David off-list, maybe the answer - if we must have this - is to
> add a new percentage interface and have this in lock-step with the existing
> max_ptes_none interface. One updates the other, but internally we're just using
> the percentage value.

Yes, I'll try hacking something up and sending it as an RFC.

> 
>> I've been testing a patch for this that I might include in the V11.
>>>
>>>> There are likely other ways to achieve that, when we have in mind that the thp shrinker will install zero pages and max_ptes_none includes
>>>> zero pages.
>>>>
>>>>>
>>>>> I do agree that the value of max_ptes_none is magical and different workloads can react very differently
>>>>> to it. The relationship is definitely not linear. i.e. if I use max_ptes_none = 256, it does not mean
>>>>> that the memory regression of using THP=always vs THP=madvise is halved.
>>>>
>>>> To which value would you set it? Just 510? 0?

Sorry, I missed Usama's reply. Thanks Usama!

>>>>
>>>
>>> There are some very large workloads in the meta fleet that I experimented with and found that having
>>> a small value works out. I experimented with 0, 51 (10%) and 256 (50%). 51 was found to be an optimal
>>> comprimise in terms of application metrics improving, having an acceptable amount of memory regression and
>>> improved system level metrics (lower TLB misses, lower page faults). I am sure there was a better value out
>>> there for these workloads, but not possible to experiment with every value.
> 
> (->Usama) It's a pity that such workloads exist. But then the percentage solution should work.

Good. So if there is no strong case for > 255, that's already valuable 
for mTHP.

-- 
Cheers

David / dhildenb


