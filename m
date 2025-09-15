Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 181AFCAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 10:52:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76E098E0018; Mon, 15 Sep 2025 06:52:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71E518E0001; Mon, 15 Sep 2025 06:52:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E6588E0018; Mon, 15 Sep 2025 06:52:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B0888E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:52:13 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F374313B45D
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:52:12 +0000 (UTC)
X-FDA: 83891170104.19.624F6B4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8806BC0002
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:52:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ceWdNUfK;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757933530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TONx73D+/O/+grOG688JC7bheYa2eKKJEwalopCuMqM=;
	b=bnxn69zQ0p8uoQRjO7whjIBI2Mt0pYLFMvHy3gNOZp3dmvCFaxqU3zvBaum2+eQJicgnN4
	xU8/bTRPFv2dqPgfThJ+Q2goWYLYWPKWSdgbqO8NL8XftdaiqxAcrUbGs61ZaAZzy+jhDH
	6+3AcWN/pvLbenrctQdOxAMCRnLTgtc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757933530; a=rsa-sha256;
	cv=none;
	b=w6HmDW4TelewXn96FmFUdUPlVhaT3dGJ8KhljH1X36S5zlReqoqjrOWbAibt5wbN0nG2kd
	jTAXRJLLG8FVp9GbYmxeWT7dJhaxv7G6s+tQxtX9Bv5UPlk75526SAV5nMzL62TIaQu3Oq
	k5PoZkaPjFjB3Ayg8oG5M1c9KvwjamY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ceWdNUfK;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757933529;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=TONx73D+/O/+grOG688JC7bheYa2eKKJEwalopCuMqM=;
	b=ceWdNUfKNNT1BfUKPq00+NgqH5bt3Vya5oRM3g1lGbnOIMrQ/accHtmac0MiTJZP/XviMi
	HW9lD7KGfTYGDrgVsbAGggVSMODRp/XaNRCvpdTSxKj6t1BTID0TIRMkF6lyu9uwmMnr9c
	OKB/YcLTEJAQgni5f5e62BNxz5W+h5E=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-246--hOQ7cbyNZ69G-80CSUCUQ-1; Mon, 15 Sep 2025 06:52:08 -0400
X-MC-Unique: -hOQ7cbyNZ69G-80CSUCUQ-1
X-Mimecast-MFC-AGG-ID: -hOQ7cbyNZ69G-80CSUCUQ_1757933528
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3df9f185b82so1533873f8f.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 03:52:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757933527; x=1758538327;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TONx73D+/O/+grOG688JC7bheYa2eKKJEwalopCuMqM=;
        b=oNHHkv/AoTNqff6QdpU5slAOPckrMUrLkGJEMZeXrLaOMNf7L7xb0EEkCXvV3SCXhw
         rTrAb21al5NpDPVLGBx0dskfEufK/8+5Rb1q6YEAPyE8Tn4tgldfPIet5XDd4vMpExzR
         TikQt9BBc9dFYsVIkyXK3NnfZDNrs+BIWwowti0EliAeEFDUE+qp9732Dd2f65UyulFc
         NJKy/a+HwP/IoGDml5sj+XIJbrdU/e7SiwRx5coxvIuAN5FOIYheDKL7PVB9zYMEqCS9
         Ie2ahgKiXmt2xDqjr7+AyArhq7qsuBH+MUe7Wc0BAbr2l7mFzeKhR9h6hB/beXZysGky
         ASQQ==
X-Forwarded-Encrypted: i=1; AJvYcCXbiroXhr4RRszDWvIDGpu242eF8HVEMSxew5IUBWiIxQ5PYC5PLsybuB+TV0SFtCnHcPkGthyGew==@kvack.org
X-Gm-Message-State: AOJu0YwzU/IgR3Dykuv3YifEt4Va0MyxQO6lSjmyjsxrbQcO+bU/Se/A
	PFrmYR8ik7KBvpaDzHQivg1BLkxsNwPUw/i5q9gVbqZzwT7fGdBXs1ZhXIJCFagIN5RJgWxS7Cm
	dsYJQ3aulNGESRbtL9ei3rcLUEoI/hxRmOZgaEAFQFflnYDcKm4DF
X-Gm-Gg: ASbGnctUuIc1Wp6BJZM+oV6rnrn9KrhbeJ8VQi3dv4QTRdwskJUokMX09JNaKzVE9q1
	B320sJhJQyLBEBV2kn9XFAvQsUkvW7q+VJqn293fWuQXclDTE7tHawRhjAyC5gerJf//cdUWIM9
	BGEndnoN4yKaa/1VoOOm1QrQBIcT9TVsjwoZWszrDbPZwlzNxI0ySlpnhNNYmiN7LJLvUWqEpk1
	/qwUGHJ66nHHs7HymXeQju4VjtnGJLTOIJXdVPanOG0i5UeXf7D4HJxVsSTUBuQ6rMJQ7EvsIhO
	LVMUOmujxyFE9bPNz1hF2M/R6Xf4VWRyYAWzB1DfrVDMN/2HZVMXuzF0mAiUT8Bs4e0Y2hsECAM
	G5IhOEcmpyle6L4xO2hbxObeip9afHkQyZDBwMh/uE++sofFRqZ1amZXTKGT1bvQHW+Y=
X-Received: by 2002:a05:6000:250f:b0:3e7:4719:a024 with SMTP id ffacd0b85a97d-3e7657c4d2amr8864740f8f.18.1757933527521;
        Mon, 15 Sep 2025 03:52:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFKEYyRZhPxbJ806hEEJtd+E4ByVirEH/UnddaSRMoVIfYw9s7hf4KJQcASmhrnW92egs5mLA==
X-Received: by 2002:a05:6000:250f:b0:3e7:4719:a024 with SMTP id ffacd0b85a97d-3e7657c4d2amr8864705f8f.18.1757933526990;
        Mon, 15 Sep 2025 03:52:06 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd? (p200300d82f18f900e0ae65d58bf88cfd.dip0.t-ipconnect.de. [2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7cde81491sm11735126f8f.42.2025.09.15.03.52.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 03:52:06 -0700 (PDT)
Message-ID: <ae9d88e2-bab9-49fc-a459-d7b9a8fe9351@redhat.com>
Date: Mon, 15 Sep 2025 12:52:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Kiryl Shutsemau <kas@kernel.org>, Nico Pache <npache@redhat.com>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org,
 peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
 sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com,
 catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org,
 dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 pfalcato@suse.de
References: <20250912032810.197475-1-npache@redhat.com>
 <ppzgohmkll7dbf2aiwhw7f4spf6kxjtwwe3djkx26pwy4ekrnd@mgeantq5sn2z>
 <d0e81c75-ad63-4e37-9948-3ae89bc94334@redhat.com>
 <CAA1CXcA+pb5KvEnJJqdf1eSjaFiBZ82MRB+KDmyhj3DbiQqOxg@mail.gmail.com>
 <enrgrocqajwu5d3x34voghja7pbvau45oobxgabawrly44ld4u@ahch3xn6rtq5>
 <cd8e7f1c-a563-4ae9-a0fb-b0d04a4c35b4@redhat.com>
 <155c821d-402c-4627-a723-6f8c88a2f65c@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <155c821d-402c-4627-a723-6f8c88a2f65c@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ixwf3WLn58yH4_573Qd24sliRSXbsoa92QNH_gPrkLI_1757933528
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hwqd69cshufas6d1obaf54bezrb4wpf8
X-Rspam-User: 
X-Rspamd-Queue-Id: 8806BC0002
X-Rspamd-Server: rspam10
X-HE-Tag: 1757933530-91960
X-HE-Meta: U2FsdGVkX181CWElo6Pvf5QJSrA0hGemlIUMtrfXmJ7gd5ZeVnolBZ3h/ylOBDOEDJaDl9zNMU8Nbol4oX6rhZWH/i1OY+MWDHUmDlxneUsIQ5gTJcCfXEjBV5j8k5tYjps3PVM7m9dcmoF3J+jaA581BP0AJrFaubtiddpv58yXZybYKRaLYOqx4AingEFFJ+ZZZnUNEkskMwM/sLaMO5jpxvNKfCCXZyfmEEId3pa+o9IDI5Vet1mvRfULlyFQWTR5gbUWEGqAHv5IE1xwE8Df+5/fjdLnPWz6lFDZnjw0E7mDWwY7lik1WaCsz1P2JfX7wBZpI7mOSAjBT6efICtF82IeD37x28+HhyN9WBMlJi/5c8Wfu5cojSfiTp9AmqNInnOukh0uGAZrSZwgbI2hs/2+MBy7tXpPxjj8zYon7g4xYbvwVpWlj+jLOJDzbbGrl9GirLBgsavqOnGF5EcKFckO4YZt2KT7ob2+n5AvnY3bC8EIiHbWoLgCxHypl2yhIbzl8ngxyentin9baAB5lNEUzNP6eaPGExDjCNX1v1yyshw2DxS4JEQ3GiU5eNa0oECXMFbyp5bfTF5G5CamgD/6Ilof6x/CeySCJ3Gxzxtykg3F6n6tYbhtYOsfYKAdbWBazym6vTPRujLORTV0PAGP+WaITqrRnICu+lyzdL36v4auH6OdKytU0VAhNVlaSRSgIRQX4drwnOhW82Bj/hxzTRJhwZiKNqYtackKQBlLKL5eMlRVrUiLTQOR9F+CIjNN2Qa8aMgBqQxNm/24kbyRoRKwyza+zKuA6waC1eGn+UWavmvwMuoqzNdcRSidMYSeLqgtyvzgDWb+Z10JNl+XEx+4Xwm2o4PNbvejam+JV7VJ9I4m8wfY4MAjNztZMYYAYKD2NtQ98J1JyQuEsmouFYgX5wt/mthBT2SZLbCMrDdcQxlpQksxiOk2uGKEupnJ5JOWE1WvrCX
 XTBdqBxc
 axm8Edf6sQtYJEc2Sp0rgj0eqtkKuEn4Jv68Y6H3E/CO3vaMxJ0ywpqjBlsSQPHAU7EepVMW4rnZOsKKThtvPWGqRRmYzNAc2ENkzq6ueB5mFoAqbEEGldmMZ3uRM0vZAMTgUIyCGJFzg3kRhjrY2sHG7AMEPIAZu/meBNNbIdgbSzZg25y7JH4gIYMjHPOYALcaGWxWjzOcq+asfm5DaX3GQZZTyoP6Y4KyG0uexDQbDfyOhIGeFAAO3kJUU6CQuh9SAh2DeTXbYqkG10wLO9vn+mmmM9HDhCtop9mQYMBIqf9vQpGF/p2hQoCghq6oZ0p3IYTXLO388vBNyO4NvpK9xG8YL+gNA2mnXEwF1zB+tGpSMXJRflujfZ1BOXjIdYFQB62cuBAbqMU+iWDQ5Oo+HXsgc/WbLENsdB86l0fZ8b8JUqdXGLpEFGLyuGIcgBmjwia/ZZKXzESS62AhiAfgrHJX+PbwRxLJQeJowYYecBJd0P/ZoT6kAAA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.09.25 12:43, Lorenzo Stoakes wrote:
> On Mon, Sep 15, 2025 at 12:22:07PM +0200, David Hildenbrand wrote:
>>
>> 0 -> ~100% used (~0% none)
>> 1 -> ~50% used (~50% none)
>> 2 -> ~25% used (~75% none)
>> 3 -> ~12.5% used (~87.5% none)
>> 4 -> ~11.25% used (~88,75% none)
>> ...
>> 10 -> ~0% used (~100% none)
> 
> Oh and shouldn't this be inverted?
> 
> 0 eagerness = we eat up all none PTE entries? Isn't that pretty eager? :P
> 10 eagerness = we aren't eager to eat up none PTE entries at all?
> 
> Or am I being dumb here?

Good question.

For swappiness it's: 0 -> no swap (conservative)

So intuitively I assumed: 0 -> no pte_none (conservative)

You're the native speaker, so you tell me :)

-- 
Cheers

David / dhildenb


