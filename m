Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9383CAC5AC
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 14:09:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F10EE8E0005; Tue, 23 Sep 2025 10:09:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE8918E0001; Tue, 23 Sep 2025 10:09:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD6EC8E0005; Tue, 23 Sep 2025 10:09:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C69BE8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 10:09:19 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5D329583B3
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 14:09:19 +0000 (UTC)
X-FDA: 83920697238.19.A256F82
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id D658D20011
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 14:09:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="DQo06q/+";
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758636557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OvfYmC09eC/jmHHiazmzVWdrgG996HkuXHBuyideCqI=;
	b=4NyIhDijNg8Fg/c6i1NyFnZc8H+FktkWLOiDB9DvIai4SlK+6ncZGMqFdP0plRobPicK4f
	LBd0odDSJ7yoyuQKUNsSuVxy5Wsfe2xBCQUulzT2B4asM2cPM++Ae2PysZVF8ViiZWSo4B
	zSUp/khHl9BgIx1xDn7IxxlWbFcB8QI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="DQo06q/+";
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758636557; a=rsa-sha256;
	cv=none;
	b=jLe4tgfT9QZMzTNWFtS8tZjjbQ5HQ1lcrzttEg5ln8yGXzdfkaLNbp7qH+sy1jTdalsvMq
	F+IrgSyvAdbNAs6H/EJOnSgqyNRHHTDoM6ojNN5muFgG6GvwK901VlNGJvA6KNCNbbc/jW
	K2s1Pt8FH/5xEe1q434e7J3VZQUDbA4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758636556;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OvfYmC09eC/jmHHiazmzVWdrgG996HkuXHBuyideCqI=;
	b=DQo06q/+LeiDFOCy8qpZZ2GBmJTmVfl95C5sx8cIAhZzbDdCe7wFcLXhYuSPEIT0cvakIN
	qHjniXyTC94TYuqAxAmeAPT+fkIBQQ+kn2pfzBqnzP1/gu5qvBOJJ04zQl1RjXwg95H1JX
	VCtF8aGzKUqhLInfNAcXOoLg7SE3Sec=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-154-vrHq6n1CMemf7Ho1S8mftA-1; Tue, 23 Sep 2025 10:09:14 -0400
X-MC-Unique: vrHq6n1CMemf7Ho1S8mftA-1
X-Mimecast-MFC-AGG-ID: vrHq6n1CMemf7Ho1S8mftA_1758636553
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45f2c1556aeso17350745e9.3
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 07:09:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758636553; x=1759241353;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OvfYmC09eC/jmHHiazmzVWdrgG996HkuXHBuyideCqI=;
        b=G8HzS1aLj1kTRnEX+eaUUH5QuT8WFlbokm0SlMzP511t2O5hXgaULE3ZUC8hh1oJXv
         CA4jUxE7f8dLNNWLX70D3V9YxzEZjgB7emtjAWYUnLxXpf19eN+80TbIYVn/zxlgRdtF
         So2jEWRQewiN3/YVXbMuW43KIxpogis3jhMGJFagooVkOZZhdcIKCUfzX27KyIDkWMDP
         TrBTQDiH8Htfbcw+anGaZcq3sXfpSfWDx/bsDJ1oV9eeOoVr4ct5I4h8zhAlR59yqyGD
         6PCxuRFZuBy/sMcaZD87ooGJdufGKj+GkTS5BC2TRLZaWeO8LVOStOt0QQ4zUw6AKsID
         d8RQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4w/ejuQoGLcTO7wOCopgbIyGGq6oDQNSeCOeFtFvrrI5PTRIVg8GL48VgaJyABbzsU3v4Fd7dSQ==@kvack.org
X-Gm-Message-State: AOJu0Yz+p4BJCpB3iE1DgonlB8tDJMjWjXKznoPKnLr3AsfaQwMA90bu
	Vqz3tsCQJz7xzIqJDME00zup/j0CA1ZYAmPbJBbKm6Odv/yQueoVgzFu1IJZVZ/4jKUPu89AA5x
	h16dcBpb7wcpplfEps6Gh5DNTCZzilZcfIqZAddODRoYs9OPvglw7
X-Gm-Gg: ASbGncsdmEBbokwIWTSgaeWMhUtBk2ODzW53HzvjWpKHx5o2Eo6bWzdWE1F944DcCc7
	ODOVZ5XIAdIyVnC0TiZf1zNvH6AW+PBBZQXRwdl2EylTpe/bgTCHDneASJHX1VMHaK29t2PHacZ
	vcxYz8AIZCOpLnG6JhPUd+20eoi2cGuWdrLD6VxPl6Gx8Eyd5puvPhzahKn1Pfa3sCQ8Lx9/n53
	Gt4Mus8f5ZZrPDym4lr3zGUAz4a9yizggpJ+ocOPaxSbkE84uKuB+3WX+mzr5x1+YWBZ/aFzoev
	oqk65f0ufQhkc4lg5kXWLrsftPLfJQFIEyoDHffocmStnl1otEXLl/8W39S/vNi1L+VtbsHNDKV
	6JJbQqPlbIZzcm0l4CNcfQd751hj85dLT586CrHBVsbOhhxSIFxom38/m4yV8W2eRSQ==
X-Received: by 2002:a05:600c:3145:b0:46d:3a07:73cd with SMTP id 5b1f17b1804b1-46e1dabacbcmr32403325e9.23.1758636552678;
        Tue, 23 Sep 2025 07:09:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE1zjPRIiQxlgM2iBL3rrO4un1h7Jg85y2tIFmA5e46tCx8kH1YetoLKfOErBY9uGt01qh48g==
X-Received: by 2002:a05:600c:3145:b0:46d:3a07:73cd with SMTP id 5b1f17b1804b1-46e1dabacbcmr32402755e9.23.1758636552006;
        Tue, 23 Sep 2025 07:09:12 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4f:700:c9db:579f:8b2b:717c? (p200300d82f4f0700c9db579f8b2b717c.dip0.t-ipconnect.de. [2003:d8:2f4f:700:c9db:579f:8b2b:717c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e0d08996csm62883165e9.11.2025.09.23.07.09.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Sep 2025 07:09:10 -0700 (PDT)
Message-ID: <6e4f6a37-2449-4089-8b3d-234ba86878e2@redhat.com>
Date: Tue, 23 Sep 2025 16:09:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [DISCUSSION] Fixing bad pmd due to a race condition between
 change_prot_numa() and THP migration in pre-6.5 kernels.
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Hugh Dickins <hughd@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org, stable@vger.kernel.org
References: <20250921232709.1608699-1-harry.yoo@oracle.com>
 <b41ea29e-6b48-4f64-859c-73be095453ae@redhat.com> <aNKIVVPLlxdX2Slj@hyeyoo>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aNKIVVPLlxdX2Slj@hyeyoo>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: F6ay5J1SfRMVe7pFODMhyr1L-uKcTxQ2k2TdULQjfbM_1758636553
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D658D20011
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: whkh6tif9myhemo1w94oj7w5qh7rmpg5
X-HE-Tag: 1758636556-91250
X-HE-Meta: U2FsdGVkX1+YOKZWjzkRdq6wZVnFD8SgjM04XGWcxp5rqTMi0fRc0pCfaIkeCb0UatKUpAp21Ol8hF2GvNSh4o4wqUMZV07eS1x3d+S+jRtPCCw/2HN/1iPFaEH+aD0+R5LUSbEIoUGq0tMM3/Ai8RndIjm8akQ7lbamj9BEkGOM2L9v+dZY2GiKpS69jN7BVknrx6k7Ol6o8pcAuV0oMWpU5TLN6igxpXnluadmWvapTaxfFHhbu7Oo0otdhph+ic+9v3ZX79zn6j3j5nzg8x7sIdlAYxZMNeaEG8b2iee53xOA5kahumeOGGw51AyGkQI137wYlOKvt2ka1WMvn6zsUw8S1kJN8LukaY4Ds8/g6MC+Pake8OBynlbAeF0kS4vZs9sqLWWP+e3RKctkMExbWAIyqfbxnIxJlYgOnKqCZ4xUXm2VmzGRrup8wkaguUEUNl3gMT06WV3SZHqBwq757ml+897MSWZvIl6rsRFHb/HpZMMyBJe73iGMUrz+837Jygvjx56cqSuTtOreLJhT6/dLml/PrjC9EFORhrZKb5v/L9KYWZLyY6G9V9eP0e/EZ07vuJ3AAxDP16vonGAsmbElINHjHI+I2S25ye73oxuYpIzUFzZC99PYdsLjY6cBdiQwR59Xo2bSIXY3CDRgZGaMZpRzqtFQp0rBpZ4MoiPXLkanUsNKeZdaLYi2fqoab8XhtYb2tAxONpMemyZJlOZAAeUnU7v/KXmjvf0zN/sk0nksuZbJzIJxqib7LeZG9Eoi4m5JVEi1ugRtu7gfBxMWpv5+4NPYwuOTwpUCS/41INWtRll27uv9+sf+U0OdaRgoh7GjjIHy0fdXs1+nKknkDscJ+mz47UR0i+NAfiKMvWWsMcGJQjiR5fTorUMXfUm+TAR1PWwLArNlXaegZSrZ59mvOipe5bQE/9o1HCePopTSNRqf2fm80ZJ9GXBdo7/0bb7NxUTyUlj
 jf7gEIrU
 NObH5THX8xk/kXxXV6m7cQZihBewd9mt2fFC5XzdvCwBWM2eOnBhBM26Fh12N3FPGkrim3PZF4Gj54gt517CsPRE2qL2Nm2/ClCTpSMjkLqGjWxB7aetzRUGCIVOk4JV3oIdkS6goo6ISEPAtIGEpc0JuXeOTIY9HDwAjxvFiofVF/ez9eGR8A/hD5tn+r/4a8IEIPwKTC7rqw/Ej5B5pfqJA4ffoqFIPgkwuf7aVRjI/tmLFiXYqGZwxKGFPAIU/z+82fJ/OpFme9IIpYA7Vehwb88+0CGjUpdSBLgEPjZ06QGMh/GRxERLo3GxVbpFeLdapXIj2PTQ3b9gl1Uo3VvO/hBdG2+E0KKK4L6q78ec1BPTkP9cPRZMp4qdYuZ0a/sY33OQH6LguAD1up6bRHDunwj9d7OP8k7QkZ0JmSqM9amXJ3/UeCWqs5gRzthBC1cEvGfUKrY2knAe5+hb3aKb/CIDRC2QyAYkCAMOTwlHAQcon0goBYHPkpQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.09.25 13:46, Harry Yoo wrote:
> On Tue, Sep 23, 2025 at 11:00:57AM +0200, David Hildenbrand wrote:
>> On 22.09.25 01:27, Harry Yoo wrote:
>>> Hi. This is supposed to be a patch, but I think it's worth discussing
>>> how it should be backported to -stable, so I've labeled it as [DISCUSSION].
>>>
>>> The bug described below was unintentionally fixed in v6.5 and not
>>> backported to -stable. So technically I would need to use "Option 3" [A],
>>
>> What is option 3?
> 
> Citing Option 3 from [A]:

Ah, I see.

>> Send the patch, after verifying that it follows the above rules, to
>> stable@vger.kernel.org and mention the kernel versions you wish it to be
>> applied to. When doing so, you must note the upstream commit ID in the
>> changelog of your submission with a separate line above the commit text,
>>
>> like this:
>> commit <sha1> upstream.
>>
>> Or alternatively:
>> [ Upstream commit <sha1> ]
>>
>> If the submitted patch deviates from the original upstream patch
>> (for example because it had to be adjusted for the older API),
>> this must be very clearly documented and justified in the patch description.
> 
>> Just to clarify: it's fine to do a backport of a commit
>> even though it was not tagged as a fix.
> 
> Thanks for looking into it, David!
> 
> Ok, I was worried that the original patch's description will confuse
> people because 1) we don't allow pte_map_offset_lock() to fail in older
> kernels, which the original patch relies on, and 2) the patch does not
> mention the race condition (because it fixed the race 'accidentaly' :D).
> 
> I'll backport the original patch but make it clear that:
> 
> 1. while the original patch did not mention the race condition,
>     the patch fixes a it, and add link to this discussion.
> 
> 2. we can't remove 1) pmd_trans_unstable() check in change_pte_range(),
>     and 2) "bad" pmd check in change_pmd_range() because we don't allow
>     pte_offset_map_lock() to fail().
> 
> 3. pmd_read_atomic() is used instead of pmdp_get_lockless() beucase it
>     does not exist in older kernels.

Right, and backporting all the prerequisites might not be 
feasible/desirable.

[...]

>>>    			goto next;
>>
>> This is all because we are trying to be smart and walking page tables
>> without the page table lock held. This is just absolutely nasty.
> 
> commit 175ad4f1e7a2 ("mm: mprotect: use pmd_trans_unstable instead of
> taking the pmd_lock") did this :(

Right. I can understand why we would not want to grab the lock when 
there is a leaf page table. But everything else is just asking for 
trouble (as we saw :) ).

> 
>> What about the following check:
>>
>> if (is_swap_pmd(*pmd) || pmd_trans_huge(*pmd) || pmd_devmap(*pmd)) {
>>
>> Couldn't we have a similar race there when we are concurrently migrating?
> 
> An excellent point! I agree that there could be a similar race,
> but with something other than "bad pmd" error.

Right, instead we'd go into change_pte_range() where we check 
pmd_trans_unstable().

After that, I'm not sure ... maybe we'll just retry or we'll 
accidentally try treating it as a PTE table.

Looks like 
pmd_trans_unstable()->pud_none_or_trans_huge_or_dev_or_clear_bad() would 
return "0"
in case we hit migration entry? :/

> 
> It'd be more robust to do something like:

That's also what I had in mind. But all this lockless stuff makes me a 
bit nervous :)

-- 
Cheers

David / dhildenb


