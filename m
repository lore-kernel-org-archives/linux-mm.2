Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09586C87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 13:30:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 791A58E0002; Mon,  4 Aug 2025 09:30:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71B778E0001; Mon,  4 Aug 2025 09:30:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BC3E8E0002; Mon,  4 Aug 2025 09:30:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 466378E0001
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:30:54 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F35CB80D90
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:30:53 +0000 (UTC)
X-FDA: 83739160386.15.895B9A0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 739FE1A0011
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:30:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="aV10/xFW";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754314251; a=rsa-sha256;
	cv=none;
	b=jcz5alujPF55lllUbDTrKbdNN4IKmESUwe5hJCxWaUebHNiVYr26XiXOQVDVxo8Fe1hO/I
	uig3GVAxXM80fjoGZP/lFTmBXzQ1Z6r5tzkNM/TE5DilPKw5z94bGV+QkXWLMoiQdFCWPH
	uJ5wQnk9hjBRx/NvkAkjEis+mlYjLa0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="aV10/xFW";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754314251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vvhpej7zDRDY5Vkw5faz8KiFpnwTv2FvUntY/b2AYdQ=;
	b=IgQreye96YoPquvekz7d5SlRBdj4pn6PVX1343n7GErYSux9BRvad+TLbeunDivzaTiS/A
	5s62rQQWJKH8Tyf8+mrwArq/0EWJQmJtlCEOzww58+964/c25GUDdTS2tRm7fY4CeWt4at
	ScLI6yvyk8o3jpIIh++NnXbHesmgiVU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754314250;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Vvhpej7zDRDY5Vkw5faz8KiFpnwTv2FvUntY/b2AYdQ=;
	b=aV10/xFW3t/AMFXR5Vq+M0WCesr321ZFa1XWEellJv94ydc0nw+8kPpjaTMHTHCrHhw6WY
	SF24IqxBIsK/I1GUS9fGnArJSawfWOoKFsYqCzf+KKfrsrOX9rc8TwW9s4VvCbARwMGUhp
	qdR6NH7jbgR1p6WhpiRryHE1nSbl0J8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-G9lYzmSuM_qbWLwHd0XNig-1; Mon, 04 Aug 2025 09:30:49 -0400
X-MC-Unique: G9lYzmSuM_qbWLwHd0XNig-1
X-Mimecast-MFC-AGG-ID: G9lYzmSuM_qbWLwHd0XNig_1754314248
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-459dde02e38so3366685e9.1
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 06:30:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754314248; x=1754919048;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Vvhpej7zDRDY5Vkw5faz8KiFpnwTv2FvUntY/b2AYdQ=;
        b=s8iVD0Odpo3671jLOySXD9fIBlAiDo+FnfqmToCSDvCLAX5M4cGVU9HTmia4fNyl0B
         EmVVfJLyvnuBhNYHJp8vBnJNC7pF9rdOMJaeTMSnCZHb4kWoLz9BTNPYCxxnTEe5Xt7b
         eYZr9p8nXwzwVYF37edLZpS6s4yCNW1jP0/3Jqs4h3zRNFXkd2gWu6mmQ7EUj87zvDBq
         qHr5HetzqyagBT2gNuCw4n+RNCKtX9CjkIcalzcAmv8gbRxb4TEkLPvFUCB/etuP8Yx/
         d+jXF8WPjezAB4OfNn/PSmbeS/iSsyaZW3e1j7smSFO+4BOI6uGpj0cehbRyHKbX3ehf
         qHLg==
X-Forwarded-Encrypted: i=1; AJvYcCX9diHgXFC0V1HbU/KvwtggrcQpgEBqL4+RFQ64VHj+e8GklRXldvXu8CjcuPibdw8hUDtqIoZNcA==@kvack.org
X-Gm-Message-State: AOJu0Yxd30uLEsOLIGcrmRrPgLW4aNO9ewWTokM3o0oW6sAggNFJ8/IC
	9QWNpsEP3kyfiHCAIjDTTeg95qkIsD05Yqkl8WukVPJwOyfELP7TATqjw4rWjJ4j7sn701GpcRk
	Yzpe5E1K1NFfG5ncCUf4d4lzf7tZdZcYIE3WhhN6Ad1DVakFs9mulqxaUuki8zNk=
X-Gm-Gg: ASbGncu4xVJXQXyKkNtsnaBL4nabu4oNMazwixiiokf6BDVCMdu+iasKFqAb1S/kRXW
	k2y6sX8tQsqFoZpPir2pGH5f62cTYm9VNiko1wbdv3/fcRSy3b8mtKpVVRgy0l8Sr7asyHZ+6NY
	3OzS32A7Zmxza9byedPF7Kwf8mrPbshUPePqLiNu6vJvShPo1vV0/a2THWpQm1Ztd3YSBEQpnSw
	jIuQNE/rwL2hPxyTGGRVlYQaxsDOzWLSP6TFY6B2m9unNU6jY5KVrznAIrlnP3HNfQUQnU3AiJW
	0vdr3K4GDVQEiBGNdccCGFuQILDBS6xDWny5LAlfWxHiLULIsdsCsjWV1+n0klb8knaKcrEpMkB
	OuycqvK37G/V1viuSEGzylov78tLsej9r4pmx2R6C+qPHQ1uvdNpT696HVszLsA/7Jug=
X-Received: by 2002:a05:600c:4b83:b0:458:b7d1:99f9 with SMTP id 5b1f17b1804b1-458b7d19b72mr46605195e9.11.1754314248406;
        Mon, 04 Aug 2025 06:30:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFzuOY12ZPySBcdjFiF+290XjA8R4/34W8j6JzHtkny0pl9OyWI1HNApFH1U96JzLuL64DQRA==
X-Received: by 2002:a05:600c:4b83:b0:458:b7d1:99f9 with SMTP id 5b1f17b1804b1-458b7d19b72mr46604595e9.11.1754314247170;
        Mon, 04 Aug 2025 06:30:47 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0e:2c00:d6bb:8859:fbbc:b8a9? (p200300d82f0e2c00d6bb8859fbbcb8a9.dip0.t-ipconnect.de. [2003:d8:2f0e:2c00:d6bb:8859:fbbc:b8a9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c4533f1sm15800765f8f.42.2025.08.04.06.30.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Aug 2025 06:30:46 -0700 (PDT)
Message-ID: <74580442-2a9a-4055-b92d-23f5e5664878@redhat.com>
Date: Mon, 4 Aug 2025 15:30:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: memory: Force-inline PTE/PMD zapping functions for
 performance
To: Nadav Amit <nadav.amit@gmail.com>
Cc: Li Qiang <liqiang01@kylinos.cn>, Andrew Morton
 <akpm@linux-foundation.org>, "open list:MEMORY MANAGEMENT"
 <linux-mm@kvack.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 lorenzo.stoakes@oracle.com, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasarya <surenb@google.com>, Michal Hocko <mhocko@suse.com>
References: <20250804123923.296230-1-liqiang01@kylinos.cn>
 <c441e6ee-3118-4603-8c77-c5b2ef40982b@redhat.com>
 <9D248293-2456-4642-9F18-8075F0596EC2@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <9D248293-2456-4642-9F18-8075F0596EC2@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: F0U7FNP3lDxmf9YQSrbkV31DjquGSUpN8QxMVs1BNtk_1754314248
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: kswmmmno9z4qtdyr88dekoinfia6eqf3
X-Rspam-User: 
X-Rspamd-Queue-Id: 739FE1A0011
X-Rspamd-Server: rspam02
X-HE-Tag: 1754314251-652740
X-HE-Meta: U2FsdGVkX196YF8MZ5J3rjLGtebWSK2PlmSDcQFz+bz7Y+mI6lj6gQ2kgx1cUgAYxp2N5vwWSS0FFQhOH6kvkmWfZokpGL3tjwGQ1qG6/Xt2Ps9p5tW9vXrqLVUP1cOrvnmTiHSmy86Rb4WlnMmHE5U7Rb7U7OYJ2UpwuKcErXpKUy4ia6kMGj4kaf2HEHljtyCWPGdw7KX8AgzTTciKXoIcVSqfJxRDiK3HKF3IKaYvL/SYN8nsOLjsNGsapAxwktqi/0zSUlhwdkeWpqdxzXXcoWwxFCldbFlxWhI0Cnu1vy0Mqx+0JbyCMqw4rzNNv24NxFQMYPpd4rT63SEit/jiwlncsX1WxziE8MCR1i5cipwbtxEq24DfMEWNESqFsO0fflvYBAhHlnMbWmiUJXXMFSuIXxxG2Mv6tLI5z7KrI1+Hf1SAyV4Ho+H7GaIWMAjjZekWWjFTaEIbffM4+XDnlT0XHanXVLv4f2bQUmbTpcC7eq//fKZ5FQe1fd8X8CSoWCCvrMgtnmzGr/vmzRFDrluIwIBFL02N/2sPhpzFZgEpeZLE2WdLfignWJ1UR+V7I/iZxVlHaS4kqQZVKW44PVlvdTPLRgoEfUhdaOVtXv9y8cmuqiDSOdaQcENjdNSL8qZu17p2ruIwkBBc1bz9nFd/fiX1e+3go1UpWDVqaHJMjBeLt5ZwF4DpkPjv7eX/5xTIDaHds513tHAnTW+RxnJ91xJBZ/9Z1TpiOSB33kR9sT69xYTWY86rfhWxLd0xn6+tAFd/awISOwHnEEOLhTspoyIZFYb+7rIyQsYTwW4WwL1E2iWuXsqplQCjYZjhldBz099YnVOrFmwvvgI0BqMjP62xyoKD35T0oq7VBWd0LdKp9nHfxMMsi2FGQWS7oDWuV52aqOS/AAwbhXNPOWFYb8uzi5apugpuCpLJRInSclWnZmiMt3CA2FKbc6VYUG+7xnOWhC9jQ3O
 dwXZMYRQ
 5h6BD46vPxJs8vsIeRrQ1dUjLQEgPW6ojppn+9kfvK7EQ0ffRvmJAPCbyo0m48raYp76w6tQtPFlH97rktHwxAuFvIX66q/bKCeJFLFdQYywRZA5iyTWCFJzYjGOgezbj8H3bR9Ca5Grvq8PG6rdSpIbEJrYJY8oqujdl3sEF+9yKW5r0pikxh7ll1JbKkXwMuI9L69TmztRFSU23J5+x4UdXY46CXaYTmsrIMdsgLzEIs7+gEs2LvbHzwKUM8dkJVYtCOo1hfV534UlU73cHCfcOlxp5jl6/LB26ofPRZTLNwTB32Efr3h8hV5o7jfDGdieK5A7ltDgYxQb30a9A08hzw/N9x6m8Uhu4rax+blX3QLiJiDEWQe2qHAz+MMdz2vZa1fw49gl+m6flp78CkssXVngcJKMGST4FB8uTVT29QYZ0OKL15aKc0bX+BfFg2v0Vc3tyh4cYjpqy6i+ecTOPeVfAsSOU0Yd/cKjvRqm1V6DaSNbtT91lf0Ze/BZ7YniLMZlhyynBfUshOfU0xOaDDw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04.08.25 15:01, Nadav Amit wrote:
> 
> 
>> On 4 Aug 2025, at 15:51, David Hildenbrand <david@redhat.com> wrote:
>>
>> On 04.08.25 14:39, Li Qiang wrote:
>>> This change converts several critical page table zapping functions from
>>> `inline` to `__always_inline`, resulting in measurable performance
>>> improvements in process spawning workloads.
>>> Performance Impact (Intel Xeon Gold 6430 2.1GHz):
>>> - UnixBench 'context1' test shows ~6% improvement (single-core)
>>> - UnixBench  shows ~0.6% improvement (single-core)
>>> - mm/memory.o size reduced by 2.49% (70190 -> 68445 bytes)
>>> - Net code reduction of 1745 bytes (add/remove: 211/166)
>>> The modified functions form a hot path during process teardown:
>>> 1. zap_present_ptes()
>>> 2. do_zap_pte_range()
>>> 3. zap_pte_range()
>>> 4. zap_pmd_range()
>>> Signed-off-by: Li Qiang <liqiang01@kylinos.cn>
>>> ---
>>
>> What's the object file size change?
> 
> I think that Li wrote that the size is reduced by 2.49% .

Ah, missed it after the performance numbers. As Vlastimil mentioned, I 
would have expected a bloat-o-meter output.

> 
> My 2 cents is that usually it may be better to understand why it is
> not inlined and address that (e.g., likely() hints or something else)
> instead of blindly putting __always_inline. The __always_inline might
> stay there for no reason after some code changes and therefore become
> a maintenance burden. Concretely, in this case, where there is a single
> caller, one can expect the compiler to really prefer to inline the
> callees.

Agreed, although the compiler is sometimes hard to convince to do the 
right thing when dealing with rather large+complicated code in my 
experience.

-- 
Cheers,

David / dhildenb


