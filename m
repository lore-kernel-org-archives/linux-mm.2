Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53DAACA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 10:21:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99BAD8E0010; Thu,  4 Sep 2025 06:21:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94C678E0001; Thu,  4 Sep 2025 06:21:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 814138E0010; Thu,  4 Sep 2025 06:21:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7060D8E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:21:03 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1F3131A060B
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 10:21:03 +0000 (UTC)
X-FDA: 83851174806.22.BEC8C9C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id C52104000D
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 10:21:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IqA33Hgq;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756981260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XqzxQnS5sSJsuoXOVa9kL/tW9erHLpA/VVyNbOMAZ2E=;
	b=ujkK7o5cYKmBf0reEfWpM+OLyvJuDHnIJuieuJHpNgbqhEweGU+Re2Q6LH2cVUw3XYxZQ3
	/Amvm6btyIYZW0KN0yqclmq0oa036n77aW+XBVA4bV+S0SNq533tsqK8wT/OWwzbVDp0R+
	UZKc2bhxzqZS301jCjygZVvNH0vrVm8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IqA33Hgq;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756981260; a=rsa-sha256;
	cv=none;
	b=gNNBi7muNAAAOawruXufBfEzlrzSx26ZbLdV2FB9w1dsSET788n+lOz+JfIWN13+Xi/fYB
	1R93S2DXzK1bFWJ/qA1I180P2oC9qEiVLBNf3pQPtIbtAYM9GNZD/oSNA8Q0lK4VM/mxL4
	97szfw/MvfAiizvV7sNd4kGqRa0MApM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756981260;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XqzxQnS5sSJsuoXOVa9kL/tW9erHLpA/VVyNbOMAZ2E=;
	b=IqA33HgqUHVlJQfKh/8bgzTQL5FbJrUcUZ/j3NGOW5B9PQsG0ojgWni5AXG3ajGTHcr+vF
	/2PQm7/cYfzF279xK5m6bj4h9KH4dcinEaonBAfyP7nZb/xRE+sDBng1BSIB3XuafE4dCr
	X3oxOJTdQTfsoS+R6NriILuS56WuiRw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-202--QhJt52IOVWkYTJ5YgHfVw-1; Thu, 04 Sep 2025 06:20:58 -0400
X-MC-Unique: -QhJt52IOVWkYTJ5YgHfVw-1
X-Mimecast-MFC-AGG-ID: -QhJt52IOVWkYTJ5YgHfVw_1756981258
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45ceeae0513so4611845e9.0
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 03:20:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756981257; x=1757586057;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XqzxQnS5sSJsuoXOVa9kL/tW9erHLpA/VVyNbOMAZ2E=;
        b=JHGxGMv3ylYYlihrqwL6BnZlYWO+crJqKtMSMKVaH41+Yp86c1EindPDcHKKmMyC6I
         L4+O9zLHReAL3Lz6i7EA3+hciBFr8fUME16cyBgGlpmzqTY++n8DtyPxuuKVt5EjJ5+e
         tiwlv5KCE1ClUIVjYECW5R0wSrZDuw/SPkbMjTZ6H2uE6wm+smaBr90kWxB+KtrCuCES
         Adg4lUEmTt7/8mOTus6BbAvFwPZlVMdVeZyfO4+KbQpnjFZJOArzBLh0z4OJnIErTYs1
         Zs+sKwXwCr2NHI7zYvG1AVvZkTII5mfs5s5O8WgIlVXLeQ0k4B5K8kKJQYvuIR00mpiV
         mCkQ==
X-Forwarded-Encrypted: i=1; AJvYcCW3ouqtFQ6gRkiPgbYJ9zxGqS82YZdgsqerDNZvRQaK/5n6lVvb7pooPw6IqYvLPVD9aqgygHZHJQ==@kvack.org
X-Gm-Message-State: AOJu0YxMnrwOUXUDXqOS2AX0o4qPL0ho2QgVVNezorrXMw6HEctvQU53
	Pqkufxpy3Ss3qrzSrCXsiEdrIjh1nB/oIEztDHnmoqpZWZuJaJTtmoSlcgeQNXiy3l037U2td24
	yydQoSlyL8C2ae60E6GLoA5L12rBqNei1KsKiOlrbfopyGck402o+
X-Gm-Gg: ASbGncvNWFTIFYnZCzHi92+hooKIvFrtg44QMIXj50D/rKwepUPSmipCPgdMEDyPpYU
	qSWbsG7JLLlY/4rR8RO73HQOlW6abmH7yshRn9ht4vuXYwQqhbQ3pUjQUy8pNDHqyvnPV9E7OzW
	p2iQU2nD9LonH9NjCGQtoeyGKDPwDwDHoq7khu+R+mDx2UiomcZBUhZJmqiDLnoT+hT5i1jzOkx
	PkPSB2DLOg3z0AgMZ9intHFuoQiCLqQ3RHztE+qHpuv7QcJ44nKXSh6j+9gRXl6zG0/vDxViwei
	XhSc6JBxlgDoekoQuLQzx1gD0KFyNpxoPjwMfYjPxt4a3uv7QOuIqKavWUEwyOoh3WeW+foOFg0
	pBsK+9yKJHbWa4Cl7Aplcic8b8eVVFvW+TAH1cFgvzFCxI6LLuuA1xbe0OsRh5uqz
X-Received: by 2002:a05:600c:1d04:b0:45b:82e8:c94b with SMTP id 5b1f17b1804b1-45c9ba76d74mr55369355e9.18.1756981257442;
        Thu, 04 Sep 2025 03:20:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEt40vKoCxxtZ137G/2w8y2vZ/D5RV93vrW4FJDSiKcaV6bHThukQaGyBp+jrhYjHYtnwgyZQ==
X-Received: by 2002:a05:600c:1d04:b0:45b:82e8:c94b with SMTP id 5b1f17b1804b1-45c9ba76d74mr55368995e9.18.1756981256972;
        Thu, 04 Sep 2025 03:20:56 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:1e00:ce4c:be3:97b3:6587? (p200300d82f251e00ce4c0be397b36587.dip0.t-ipconnect.de. [2003:d8:2f25:1e00:ce4c:be3:97b3:6587])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45dd2304e16sm16012995e9.7.2025.09.04.03.20.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Sep 2025 03:20:56 -0700 (PDT)
Message-ID: <a3777992-21fc-4e55-9a5e-72b17dc86135@redhat.com>
Date: Thu, 4 Sep 2025 12:20:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 4/6] mm/memory: Add tree limit to free_pgtables()
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 maple-tree@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Charan Teja Kalla <quic_charante@quicinc.com>, shikemeng@huaweicloud.com,
 kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org,
 chrisl@kernel.org, Matthew Wilcox <willy@infradead.org>
References: <20250815191031.3769540-1-Liam.Howlett@oracle.com>
 <20250815191031.3769540-5-Liam.Howlett@oracle.com>
 <39c46a52-f63a-4f3d-a276-6f59c55680ba@lucifer.local>
 <hs5nuhqzqyt5mp3fzznuaiyyck6b6ovuxoxayvm5ofhoa5324m@gtmezuqareiq>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <hs5nuhqzqyt5mp3fzznuaiyyck6b6ovuxoxayvm5ofhoa5324m@gtmezuqareiq>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rbldpp_-_ocWiSaMIfzgjKelX7hRMN_R1cSLZFs7wFA_1756981258
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C52104000D
X-Rspam-User: 
X-Stat-Signature: sux4kqk9uxucbmf3s6umpqfuwfiyucfk
X-Rspamd-Server: rspam09
X-HE-Tag: 1756981260-949310
X-HE-Meta: U2FsdGVkX1+KlRnD8beEdcShLRfsfz96gt458cFSV0PfREhJ8d+hpEwF8+OjbdYxNJ/y1mwR6QbSRJOv5gUwa7S62QUn5n2eQiNTw6MGalO4Wwxtc+OIZ89lntrjNt6IZzYCaAtsitPm3ub+I0OPuupz1YCE1wyqpQbHb0eYopH3tua/Zy3Mkicnbx4PvBqviGmiNkzMiHOaCd90psBmO0R35YTVuZp/Fk5vTfXJolWb7nGRZDKb+pxh7uHLiaHVx6DI65mqZP9gUM3ejyDMxODHH2QG8QXpptDo7A+fruBD0jfPnu1d4QCcGSVGVX3ngmUe0swgHpbfOV9RVs5+672qHpndFYC3DM1W+Xv9ZQjic7Vu6ZItU07ivZd9IGxcskov0xngV2v0mj2Ji6NF/clvblZq87rPi/PENjnrGNhKvHLchg3MAXphZeBzWHGgSGAiFnXXIiJdmOHe83aVd5aOk60Wr7G4fcUWSUE8q3gBF/9dsOqkcvmBkhSyE9RHHaI2esk9nWBqh/aj9b6gaMsYQ0ssn9hRB4G+HRVLspHWIrQFf48bPYNBmHfQUNPpbLbB2ZhXyMeoNFRPWJoglr0Zu9RsznxtvwEwMLQLBed0+50+jnZoDKmLZvgFQVSO5tj/LyMifFjNVB/9cePO3V1SQ1t9CH9YHpwWHNqZMEUkFnp1iQM4Lks7/yIPGQomqiwvqAAgl9oqTI0DjpSuq6yS7NEuQW+erYR7RtFdpnc58vJ5NIXBPdLRb5dMj/mC2eDKrace91womS3+Sm8+FeQT+ZmJke3cEjwJwGprmvubnDNiQXaD48MaGDbJkRAZ6an0e0w/s72Szr02kNzEqTbU0w+43aQkKAMYpaJCuNTV6sifI4wDoyG7HE0PyPePxj5eDfwcJt+VP7H8qSt6YUn9qyXViaZcw6EuhgtYorTzH+NQtT8/HyOHWfHl9+JRgnLcbf00HcTYEAGTjj/
 p1GXskxc
 A4MCynq8bQhM1pa1NLNVAnssX2R0B/x1/JqgefzORQRr+aG3iVZSNobv2jHDjhX9bro1ypD3FdCSt6t2srUYbEZypzSogayBM0XwEAZjeLH/i5FW60zdRuhpzou7GIy7EhBZEuXL0rIwjItTN4DsgMrFEObp/mFAde7ERqqCtrd1Q/Y/8rA+upjl5Xrtt6xa4RjmFN8oy//iFLi3kMeLVxFeFS6cEFtq+cfVl5g4uml0o4N84NmrIt0P/jNYFv4BjoGfulCjQXhvJl8zAnLMOwgPpR4pNDYhBzDpCe8ScVsHZ1jgj853tPqokHmwt8r9xGOjVbHeHvvgVJCF4NBf7QBZ4sMTHW4EsTQamiv7rnFkKY4aiSFgNocsUVFcEWqRHzU15yN4GeksHKvCaeiUS8EHdCsuQ1+Jyum5thllfvLaLIJm0UaeJkIKGHOrtUAfgcw/4SlTPHCWnh4RaW/PjVbM/7BBcKmGtuRuQ64YBKvSi01Df+26ttu+bsg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03.09.25 22:19, Liam R. Howlett wrote:
> * Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [250819 15:14]:
>> On Fri, Aug 15, 2025 at 03:10:29PM -0400, Liam R. Howlett wrote:
>>> The ceiling and tree search limit need to be different arguments for the
>>> future change in the failed fork attempt.
>>>
>>> No functional changes intended.
>>>
>>> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
>>
>> (Obv. in addition to comment about broken VMA tests :P)
>>
>> I guess intent is that if we discover any page tables beyond tree_max then
>> we ought to just wipe them all out so, in effect, we don't consider
>> mappings at or past tree_max to be valid?
> 
> Actually... there are some archs that map outside the vma and they are
> valid.. I think mips? and I think lower, but yeah.. it's needed.  This
> is why prev->vm_end and next->vm_start are used as page table limits,
> afaik.  This is a serious annoyance because it frequently adds walks
> that are infrequently necessary to the vma tree.

Hm, does that still exist?

I recall something odd ... was it that gate area thingy (in_gate_area) 
we also have to handle in GUP code? The is x86/arm though, not mips.

-- 
Cheers

David / dhildenb


