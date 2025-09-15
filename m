Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7071CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 11:14:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33A7C8E000B; Mon, 15 Sep 2025 07:14:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EA638E0001; Mon, 15 Sep 2025 07:14:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B2B08E000B; Mon, 15 Sep 2025 07:14:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 054F08E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 07:14:43 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A07B41DF2A9
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:14:42 +0000 (UTC)
X-FDA: 83891226804.22.77F1EF5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2A78620006
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:14:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NS2htQ3Y;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757934880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NdltlWJNVwfT7jYyjG9tAr/dNsT+qpkwvhbKYwL90eA=;
	b=ongHZCbzrEGbr5uKYjpIZ+v6tC9WvQtWBLUZ5UDHPWZrDtjhK0ca6TILSiiLFhuy6iKSuU
	5YaX0iKq/GKGeazxe2rN0EIl1QC4AJbb43Pwnb5TSmLsqxeVITLxF5jowXSOlQRbL3lVHa
	+54SVUMwYIDjls9tTidb42w2TnC2hhI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757934880; a=rsa-sha256;
	cv=none;
	b=unKKAlENkwvPoC+LGzZNGo4XeglU1fonNbsb22LRySe5khCEcsIray7DUd5d0ZatBss/Fr
	IeE2Z0TZDm//UYFpByEa0ie5vygZ6phqtec7U61LFp8C+DMNmx8s8z9Be0sAhkK/P12re5
	+FU8i3PCB7aZ+XiPEAEPON1UGlSatIs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NS2htQ3Y;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757934879;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=NdltlWJNVwfT7jYyjG9tAr/dNsT+qpkwvhbKYwL90eA=;
	b=NS2htQ3YU4ZvAdw8T9DgmcBrEZey22akZTSFq3bsNLGolMl9+uxT3X6PReaiR310UKkaVw
	3DnBGFL9ogsi8RK1D4XhVX8/rUTDcd3gWhYVeMGqk9XTiSWYOEknQ0vmvlHj7o14DuXMyT
	LGjjFqCW3A5bUEeQHlbWXSj2gdIxoHs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-376-D4MBnxIiMYaYQctlPbJ23A-1; Mon, 15 Sep 2025 07:14:38 -0400
X-MC-Unique: D4MBnxIiMYaYQctlPbJ23A-1
X-Mimecast-MFC-AGG-ID: D4MBnxIiMYaYQctlPbJ23A_1757934877
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45deddf34b9so29573015e9.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 04:14:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757934877; x=1758539677;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NdltlWJNVwfT7jYyjG9tAr/dNsT+qpkwvhbKYwL90eA=;
        b=Dk0VcLlcY9gTASifKICucmSgZ0B8rlAl4QKSwmTfU0cMvG+AfOnX6JxmNmZE89a3Fd
         JxxXKFzPYqwJJRHIR1BEdBQlPDpq2yJWh7GE1tQoB4IHKf0JUqd2mtpEFjAVxwoAN7eZ
         uDzJa+z8Eh2kqXQtmZkRA/YYhcbiLmylklrP0gz04VT+YaApuSPYNLlh3FzVALOGCCuk
         OU/bUd1fQ5k/oFSJSbTu2h+BnMc9rZ1Aprw8hswRhle+YdUVwjv6SwWViFBP1AJZfvGt
         NN7DxmIZMKwDS8Qnud+nRjdfDDZChgnrzHZXgAkAftR44nAXIeqR2L5dG1x1dUTx3tC9
         EUxg==
X-Forwarded-Encrypted: i=1; AJvYcCUp9clXynIWL58cxRjcSJehnBWKgmfan5sipjYzxR+FKBFCuhHnclUQ65I8ZgxNYIxh7YpuFU4Ndg==@kvack.org
X-Gm-Message-State: AOJu0YwgNKxUJPrc4zLoonLRaTSpNjqtFGlsOjOkeUh/tpL8fv8iUy+I
	cF10K5rDGSIH3tDSp+rQvD/E1blBtDEdE8/APaj5qRa4V2JGFCyL1kN6FiAB2kPXLKVNgJwQiWM
	tDUd0f3gFqLwe8mMvIjb3i5yba88tx7u4+eqy9mkWnK6uAMcxiQ+9
X-Gm-Gg: ASbGncv917tA23oV0bxPu7En7M2wwExjeCzXrh1+VosZdlETrQmJUTQOBMmQnXnHy3s
	RV5W9uxs/a1aOQ3cBZdbBWqm4qMqDhW5b0ZAmrhIcuyUnNJ00+hsauZU/d7HAdebaeVb3osdY9O
	T33rW7xJI8VAg4Nhcj5kk8KYJ2WJLsacqZVcxtnC/i1gENOJ/UThFhaMfKviAXyLpt1ZvQvQZ+l
	VhbkuOl/VyoJeZfV0VruPhYBeO5gBUjjtZOPnXcja+UqbLQ1t8qDgDmYI8fylvRXizgWXo7pxWt
	J/24vT1Hxfh/1HbvVZ/cy8jKv0FQO6AX52rxlmIDhz4fI1sc7kXRS/9G3wS43smT4KwOdoQLA8V
	qP4Tuiv5VZIUxFbs0qUGU4EX+OoRFOCZoQjto7U5ybCTusYtvWPcg3VFl5q7AreKE6D4=
X-Received: by 2002:a05:6000:4014:b0:3eb:f3de:1a7c with SMTP id ffacd0b85a97d-3ebf3ed6852mr176683f8f.30.1757934876658;
        Mon, 15 Sep 2025 04:14:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGpPe0zFChMftg+HjkuK2bT6qcm5CziG/vjDMR5C66naBGw+ElxT45E1hV/tGJpOC+C4Sqlmw==
X-Received: by 2002:a05:6000:4014:b0:3eb:f3de:1a7c with SMTP id ffacd0b85a97d-3ebf3ed6852mr176658f8f.30.1757934876114;
        Mon, 15 Sep 2025 04:14:36 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd? (p200300d82f18f900e0ae65d58bf88cfd.dip0.t-ipconnect.de. [2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7607878c9sm17450445f8f.26.2025.09.15.04.14.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 04:14:35 -0700 (PDT)
Message-ID: <e450009a-56c9-4820-bd0c-da1d782d3962@redhat.com>
Date: Mon, 15 Sep 2025 13:14:32 +0200
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
 <ae9d88e2-bab9-49fc-a459-d7b9a8fe9351@redhat.com>
 <ff4b6935-fd13-478e-9187-219fb612aac3@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <ff4b6935-fd13-478e-9187-219fb612aac3@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sCB-8Msd1-UJG7OikLUDQ_p_Z6FUC8GE6XYGa_AmdEM_1757934877
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gx7bszcq7u5fzjd3bo63rzh1qagg6wmc
X-Rspamd-Queue-Id: 2A78620006
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757934879-791859
X-HE-Meta: U2FsdGVkX1/HY9JApoVQQTq1SFx0iMKRJmOCT+Sw3sBF0m61p50NE6AbFtgGDIgJrH+eNzV/3CcH/eU1S1vQk0rY7P1tOvTcXB9jhR++Mab2DwwxT2u2dfd93bdv6GkAb0ldc+bWCnPFuyWyz3Fs1b7L7ROhDAl5zkglJ2Y9tChN+NP6+fyOQQdJvsAdpXqw//b34QcD3gwwS/++bOjvYdfpWPr6PwWitu7+szLTRZ335QFMsZqyokX6fDNZyJOZQ8+qjts7yEFsTAawq16EKSKgSewi0NeBWZmOuhdjGjEgMXtOScpKERPNKJT+IIqr6Iaz//P5N9Ksi4HDMQejcw8NP2e/T/l6aw+OsO0f/QPMi6GLa0lETFGSEIe5mEYOHkn6pNMIIT6R4WLzwHE0bcdd1XeobEToA+Gkoz5Z39aIBGAYHOhFfvHa31MG8bgBWswiKkfvKuSg+lgt1OzrPAh3qkDi9+hz6im05m/qjdSjenl493xjfP8qid96pyftLhc5KXJ7iFH807s2FU4P7xFreV62KQtOh0DHoV5QPcFvPi86PPmjEyj0JhCf2487S5Aa9tgo+gukNQIQC7RSaEuy50M0tbBU5Um9JzP8w9HkUm3cnIRBh1u0zL5yihAfbXqWK+Jonn4qM7hJ7vF+ssHkEIKcvh4yQcxHq4F8sawwijsGVDZr+wVE0tmHeArhvorhoAHR+9gqZyJrpaRtKJqmjPfMCQm5tQSM0auuWsarbyqQxmbVBs3hr3BB83CNZl6eqm+sLfvkiuUq98QmMDP9FruVEkQHnGBXtvqzteqagbFkaS18ltf5GV5hdfGFXiylWZuv21/Dgod7R43kbbZQU+Arl9wYWa7o/tmj04LmclaOiLF+z2aC6NRSz99JfJl0ZVUutqeZIka0cfVwv+1Lpwg//fMp4zlyJzAE42nuBW0R+kVt8oJU9fXMNKtF3Tfeas2UGYMbv+YtRac
 FkhlsJCK
 uuKWRO7So9nRfYGbzvg/6qO8Tt5r4FZIkfhr9ScACwQ8rq4XpKzhazGjSleAvSuS2N0Sw+9O85fX4bKyCn+MSEHkxhSFAtoDcPg2Mo38xLl4NdvHHd+nFk+1hIz0zpFUgrJsBWsVeGPiBH+Er9kRQwnwr6lxjHRJAcFZGigMbInsgePqJH4NVYyR/s+eHXHC4B+h7kF1UqwN+0Stoap7oMs+Rv0bumAw5rvI5a3Ufz3lFTDJ1ZLWnSxJqYjCIuJVqatlp98B54Vn8HNO8/JfoS2C8rfCGVQVbs47ZioMczn0owNYWs5cbDaezAeDmQQUj2sfaKbrHKJpulhjIvJZgoLl3vCiJIrdkHvCMQ1XyDxLssKJWajMJn+eNjgx/noExGmDaibmzRgr6ZUrRYXe86GlNX0oAXARFz0WsRWBzWP9vwDbqCiBRc/JU5RXaNlEXEg5gkwjwIKevLb1uGZmyw3gZD4qGIdml3tabVKbJT96bAgkzA3laM/lO7g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.09.25 13:02, Lorenzo Stoakes wrote:
> On Mon, Sep 15, 2025 at 12:52:03PM +0200, David Hildenbrand wrote:
>> On 15.09.25 12:43, Lorenzo Stoakes wrote:
>>> On Mon, Sep 15, 2025 at 12:22:07PM +0200, David Hildenbrand wrote:
>>>>
>>>> 0 -> ~100% used (~0% none)
>>>> 1 -> ~50% used (~50% none)
>>>> 2 -> ~25% used (~75% none)
>>>> 3 -> ~12.5% used (~87.5% none)
>>>> 4 -> ~11.25% used (~88,75% none)
>>>> ...
>>>> 10 -> ~0% used (~100% none)
>>>
>>> Oh and shouldn't this be inverted?
>>>
>>> 0 eagerness = we eat up all none PTE entries? Isn't that pretty eager? :P
>>> 10 eagerness = we aren't eager to eat up none PTE entries at all?
>>>
>>> Or am I being dumb here?
>>
>> Good question.
>>
>> For swappiness it's: 0 -> no swap (conservative)
>>
>> So intuitively I assumed: 0 -> no pte_none (conservative)
>>
>> You're the native speaker, so you tell me :)
> 
> To me this is about 'eagerness to consume empty PTE entries' so 10 is more
> eager, 0 is not eager at all, i.e. inversion of what you suggest :)

Just so we are on the same page: it is about "eagerness to collapse", right?

Wouldn't a 0 mean "I am not eager, I will not waste any memory, I am 
very careful and bail out on any pte_none" vs. 10 meaning "I am very 
eager, I will collapse no matter what I find in the page table, waste as 
much memory as I want"?

-- 
Cheers

David / dhildenb


