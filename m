Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 313B6CAC5A8
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 14:44:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F0268E0002; Mon, 22 Sep 2025 10:44:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 579E68E0001; Mon, 22 Sep 2025 10:44:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41A138E0002; Mon, 22 Sep 2025 10:44:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2A3FA8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:44:43 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A97BDC06A0
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 14:44:42 +0000 (UTC)
X-FDA: 83917157604.02.363AC46
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 30D6E1C0012
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 14:44:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=M2JhCGIi;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758552280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vwOZIhtF+CnAdagM2d4IT7kAjcwDptx80GYkfUL7tc0=;
	b=sNGyCMp7/JTQasYCy7lEdcOwmR73bi8fcDKvcmv678LXHOKoWqER8NFbYpvvUPUyufsP0x
	T3R9I94EFkEbSKvFos68VjnvO0a/4ImhpSi8l0r1Vvy0enb3tRhW3pZrhV5D/bewvSvvB8
	T8rqVzLQdqQlVpE5afqhaozPM5xDa8A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758552280; a=rsa-sha256;
	cv=none;
	b=SPFQ36hxn+hDjFt0vvCl2VM0CTD2Xl0Z3tuB3UaKcgR1aBC2fTiwEBAQFBPtm69XaQV1dF
	0Yc1EkL9kX61ffdkUhWm38+JklBbpwm9zJoLBuPAEVkKzDRkEGnC3bzhYFQJMsgWO21MVq
	2+53i96MHNsoZOEglrCA9GzeAk2r0QU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=M2JhCGIi;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758552279;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vwOZIhtF+CnAdagM2d4IT7kAjcwDptx80GYkfUL7tc0=;
	b=M2JhCGIi6M89yjOKMzrMgsljfCIs3HUljOF0sTylSfa8Y6e17rwboq3Fh+9R+oQTMPx+KF
	jqHilnIebgYP9c5JVfsRooEJ0STHP0pMN+sUxxESx0SSUYIbIDJr0CIXbkApDNwgFkcM/X
	ROjIAdW3ULRfa12VAW5mRJxzJ0YKqao=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-73-LDJUzEJdN6SvLWGAPrTdKw-1; Mon, 22 Sep 2025 10:44:38 -0400
X-MC-Unique: LDJUzEJdN6SvLWGAPrTdKw-1
X-Mimecast-MFC-AGG-ID: LDJUzEJdN6SvLWGAPrTdKw_1758552277
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3f456d4db0aso1265561f8f.1
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 07:44:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758552277; x=1759157077;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vwOZIhtF+CnAdagM2d4IT7kAjcwDptx80GYkfUL7tc0=;
        b=GhEK14niadjW61ck4zA94RxmiBPpgExlU2Z8gaJfq+EpJt0ZnoH0GcOVAvVIAfjRNG
         6RyUL3SFRHiAv3HWf9HZfFw2m3+YSdzud+m2mLNl7fsK4/1KCe6wIAXXgCUTsjQFd4TZ
         PmQgfOLpQh7Zp2y7GuviPATk0luyOOSkaTzJkY7OziTCB78r7hpPlLZcTeRhVz6jTv/y
         8/dDTzfI4pdaEJ/+j1OK60LMe4PF8skLQFA9BQblFocd+pqy7wE9E1y9sCs4dRxiWGCx
         YwSK0/WgYzFVVZucSfjCyCyvYhMOEauRb1jXODQg4shujGulmtkPE2euFc+o/jEwACmB
         xt5A==
X-Forwarded-Encrypted: i=1; AJvYcCXoI9jncdio3fx/HKTtC/y7MhdBjnqxfXNBibfumQ5LgyY8M9OFqQpLsIFvMwL8GFaVYeQ7tpS0zA==@kvack.org
X-Gm-Message-State: AOJu0Yz72hxTvR/gH54Vzd52i5deMKrMKtBOmErgw/VoGsHD9hCjVEjY
	KNcg/By8zoMXPzk5aWYztdsc1m4LLSjozO0Vqt+K1WadnZe0Z0TSHd56DRZL4NQaD3GqE01DROO
	TOSrXcENCU6xLuWCVLZWkQ7uK1jT3FavqLk0qp0bTnNiNQlXt9/2K
X-Gm-Gg: ASbGncvHr6xprRvtFzbW4gOEtw0YjhvCkas3Dh6AQVhfFc6NsYHjwJWsJq4OnAv5IGp
	Gyp5NIESUYf7+eidFpooLMrakB0TbULYZa0MUW5IENNihSPFoAmeGli9uU/kouzzJbNtOq6achH
	dgvUyTFs+mzjIjtd/ef9v1PA54vqntD56MPhVv+jD1YAu7f99SKEPq4kDiUh+aTCDEYjEZUuZIl
	KxK0vikvTOmibsBEM504ZiX5GJEEELi8qvtlsA+Ay3QjbcUkOX/t2Kp/IxJbvrSCSCQNEQxfsiU
	DSJW7nIV5URCEo13XQDtc2Ixsncd/d42AlfA39nnW2uhvIqFfaepd7XeNEWIu/Q7SIknLUlA2Uo
	M9tdwueF4g+SXQrZmO281gr4kwaHoFpgXPWcJcmVhKiVXnpBsDLd75AqHysZubvg=
X-Received: by 2002:a05:6000:24c9:b0:3ea:6680:8fce with SMTP id ffacd0b85a97d-3ee8585f6e8mr11215974f8f.48.1758552277012;
        Mon, 22 Sep 2025 07:44:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHTQ9iic04xqRMwRFFl4BEGh1sQte7ezvVn6iJMb+gWyL9TDixHQdGS9iCX9Y49rrUxsEeywg==
X-Received: by 2002:a05:6000:24c9:b0:3ea:6680:8fce with SMTP id ffacd0b85a97d-3ee8585f6e8mr11215953f8f.48.1758552276597;
        Mon, 22 Sep 2025 07:44:36 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2a:e200:f98f:8d71:83f:f88? (p200300d82f2ae200f98f8d71083f0f88.dip0.t-ipconnect.de. [2003:d8:2f2a:e200:f98f:8d71:83f:f88])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45f325cec0fsm144160475e9.4.2025.09.22.07.44.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Sep 2025 07:44:36 -0700 (PDT)
Message-ID: <c7d2576f-09b6-4516-8edc-fd49910d6985@redhat.com>
Date: Mon, 22 Sep 2025 16:44:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] mm: MAP_POPULATE on writable anonymous mappings marks pte
 dirty is necessarily?
To: Pedro Falcato <pfalcato@suse.de>
Cc: "wuyifeng (C)" <wuyifeng10@huawei.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org
References: <17ad24e5-9ee0-4d94-be5f-3c28bd57460a@huawei.com>
 <oypwdcx6j726iffszfayd66xizaw5tfv2lnkk7bx7ibzn37x3m@ulkgb6x6geef>
 <adab9c31-c281-4bf7-93ae-89ed9f303d7b@redhat.com>
 <hgbxlsaxe3p6npj3tyrd6u64qel6monttjaadzcnzpcpgi7arp@ztzuvbq55vuz>
 <8e8b4aa4-18b7-4928-a9f0-cd47a59258fc@redhat.com>
 <o5f47zn6wamjfuda67acm27aonhtmm2gbbwztgqvskkzjjn2d7@s4etlkckypuy>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <o5f47zn6wamjfuda67acm27aonhtmm2gbbwztgqvskkzjjn2d7@s4etlkckypuy>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FZf8GgxPvcCWykgqlUl1dlCH5pJe2pvQZmR9ZZZmnfs_1758552277
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 30D6E1C0012
X-Stat-Signature: e17ytrqtp47ix1f7uozyac85itdo9h3d
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758552280-282993
X-HE-Meta: U2FsdGVkX1+m3H0eLTdRF4cPgFtuRBn1hP4xzLwIS6oHh1GGk9DEyuSrJ7MAvRPugb03UBHKd+Si/e5H9FH1Zj5HOKmAsmlzDmsyqYRkI85meZcNYKCht6tiA5dEt2ccKIVxEuyILtvUfFSotI99LWaMg/ot24We7FS1mzmOYmNaYq6kM0GXBdYK+UTHROvZB7oJymaYQNflgFezASMUr/o0BZkdJWLmPKQHFh2v+l652NtNatg5bgcL7OH9l+HpZp2B41hgYjh7r3je94TYrHyeAXFQUo/BboY1Edxd2wLu6NpnIboauc2nNO1gRzcLDNroDyKDSomugeXx+Nzh1jf60G27J+KvwyTAjz1t2A6DcgaggJoPcy36lvLLFbXSWfl5E3lCBgWGFErNq4kecwx1CoBYPgDqRvTGDdJIfC9XDzU+LRImaCMIGfkwguGZ9J3PVYfdRBU8G//CVdhoHwgDmUkYaobQorOyoFVlxQqOAHl2W6SF/3NJZTfSMH268GwZS9O6cDUqoNaPleVgkFOjBT+I2KZ8vpsw7wF0yS1mJ8KK/vQ3IuWBfi0dcXrHnxzRFLe/ps8Ed6mJ1y92v8JZUK9wJ57veuLWFs9+vtb5HCJld5RaAtIZdt1/Ptj5RTCjamZ+mOYXrteL/qHvGZ7KIPo/yWgFBNoiAvL/MRP2o4qEqZ9B1LK21bnhEBvdheEYPL8elHnqpJb5vPd7YGsl/bvnewM/ivzlkOQ8dvMad0Do87PvDeqWJIoZeQIdIdQqb/l95KA5cPo7uStxlz/bjyZ3WjCbs0o6RD5/MHTemojaOGQjiYRL75OVgcc5Aq96vNOS5ZdHPBv0YwWx2ojn9YNUVfapnNGpyr7WYurYY8bYf1Qf6YHpPcpjrKweLGThQG4t1S+lsaJtQ9Nv7nms68XoTDUFiQzYf5kaF1mVD4lnuWuK9hWaEow0YIymoWclzg5M0sRC2V8L6+R
 0EigH+E5
 LlW28f8ECWJra59bi7N8BMBm52CWxfWh65XP1NVkUIcQ1dFR0/YFiWQEIIDLbzSnTm5KUYfQ8QUCbskvmb7IL8EHr4IX0LUfmx1/sUnd5T2knafd6UOw4v+58PPDpyxESE3MZEnzAQd6qJRLes3MSEd1vOUKgtwYQVcpCsn1bbvNzWbMJL7kY6jxi9IZnGjTNDxFrBAPnF3vxu62ML7uE0e2101bdf61zr1zGbGBjqYbYkcG/DRNEyJBjfrbGPMU7Hf2itamLrnT9Q6nmd9xzYOlNBK1rzMResWdt7THm33pV+eW/3IZ2bg0KZsjm8m2xAptjBj6DoYigC5x6nxLeNqWUASiTGUvXh9T75xzlIPEJkmL9exaZ6R/C11ekQVlDVilvKkmhUnXBVAPf+Ty1uFwGKic0CqjsJUMhPDmEFmxvhIei3CsGgP/KIgYJW8yQnKBNtO2AWg6LrWyZKB9u1jPmdl1KrB192m4IVF6PJhHqy9qtdA/aDZuzqzChhG31QfCnNZxx/AWH4H4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.09.25 16:13, Pedro Falcato wrote:
> On Mon, Sep 22, 2025 at 02:46:44PM +0200, David Hildenbrand wrote:
>> On 22.09.25 11:37, Pedro Falcato wrote:
> snip
>>>
>>>> What happens on architectures where the HW doesn't support setting the dirty
>>>> bit is that performing a pte_mkwrite() checks whether the pte is dirty. If
>>>> it's not dirty the HW write bit will not be set and instead the next
>>>> pte_mkdirty() will set the actual HW write bit.
>>>>
>>>> See pte_mkwrite() handling in arch/sparc/include/asm/pgtable_64.h or
>>>> arch/s390/include/asm/pgtable.h
>>>>
>>>> Of course, setting the dirty bit either way on later access comes with a
>>>> price.
>>>
>>> Ah, yes, the details were a little fuzzy in my head, thanks.
>>> I'm trying to swap in (ha!) the details again. We still proactively mark anon
>>> folios dirty anyway for $reasons, so optimizing it might be difficult? Not sure
>>> if it is _worth_ optimizing for anyway.
>>
>> I remembered the same thing (proactively mark anon folios dirty) but I
>> didn't easily spot it in the code. Did you spot it?
>>
>> I only found the folio_mark_dirty() calls when unmapping anon pages and we
>> stumble over a dirty pte.
>>
> 
> In shrink_folio_list():
> 		if (folio_test_anon(folio) && folio_test_swapbacked(folio)) {
> 			if (!folio_test_swapcache(folio)) {
> 			/* ... */
> 				/*
> 				 * Normally the folio will be dirtied in unmap because its
> 				 * pte should be dirty. A special case is MADV_FREE page. The
> 				 * page's pte could have dirty bit cleared but the folio's
> 				 * SwapBacked flag is still set because clearing the dirty bit
> 				 * and SwapBacked flag has no lock protected. For such folio,
> 				 * unmap will not set dirty bit for it, so folio reclaim will
> 				 * not write the folio out. This can cause data corruption when
> 				 * the folio is swapped in later. Always setting the dirty flag
> 				 * for the folio solves the problem.
> 				*/
> 				folio_mark_dirty(folio);
> 			}
> 		}
> 
> So we assume the folio is dirty due to races with MADV_FREE. Seems like a
> somewhat heavy handed solution, but I guess it works nicely for 99.9% of cases.

Thanks, yeah that makes sense. Whenever we add a folio to the swapcache 
we mark it dirty, so it's guaranteed that whatever content it had (even 
if just zeroes) will be written out.

-- 
Cheers

David / dhildenb


