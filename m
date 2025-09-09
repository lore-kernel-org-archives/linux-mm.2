Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF4EACAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 11:33:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 238CB8E000C; Tue,  9 Sep 2025 07:33:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 210898E0001; Tue,  9 Sep 2025 07:33:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 100398E000C; Tue,  9 Sep 2025 07:33:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F02168E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 07:33:35 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7C8295911E
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 11:33:35 +0000 (UTC)
X-FDA: 83869501590.27.6AB65C0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 146DCC000C
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 11:33:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Snwcb7LZ;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757417613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xE/Vu2E3p05NICS6N69pIOlWlxRgE7pJHsYgsRXCNRE=;
	b=5r25jKXNsK8IvdK2bpterE9UsXmkYmNyD7QSI89P6OCCTYiqGYpccSAilScj11406L9zb+
	VcBfK/UsiJ1ySHYLh/CcdZGWvl5PB+ax6QBGMqHH1fnbfW3BA8nZL980sC6VxmpgZ2YySf
	9BNdIirzenPF38Hw2PKob5W9on/ru0s=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Snwcb7LZ;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757417613; a=rsa-sha256;
	cv=none;
	b=AQV5d6fmC7tvU1hhkUxImP+jtt1vx4sCxdYz/O4hm8B3AHbdpwmhQPTv7DLl8/l6ZmquiK
	BERjG986CWIkRxSwZfZ6VKOywblKhoLqOIC5jNiYEgrsLxF+Rwohuq/obfhuh0ViRzstdu
	wJ27+Rp7YosgXef/muqqdQ4eK1jj3s4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757417612;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xE/Vu2E3p05NICS6N69pIOlWlxRgE7pJHsYgsRXCNRE=;
	b=Snwcb7LZUsDltsk38T9uUOKI6uopGGTHOXS5CcFaiwAr0zQyUXizh9XJX5t0mA0XVo93pP
	49Uwdvnh41K1HcdghaTHWkPYEhV4LDslJBenJM/0Yk89GgikyvuvWT+0BupfnBEoemFiXX
	Lq4ncpVMMBUR3LVmXrJOsB3CRN7dyP8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-149-RhvswJZ0NjmmLazttvAYSw-1; Tue, 09 Sep 2025 07:33:31 -0400
X-MC-Unique: RhvswJZ0NjmmLazttvAYSw-1
X-Mimecast-MFC-AGG-ID: RhvswJZ0NjmmLazttvAYSw_1757417610
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45cb6d8f42bso53067235e9.2
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 04:33:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757417610; x=1758022410;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xE/Vu2E3p05NICS6N69pIOlWlxRgE7pJHsYgsRXCNRE=;
        b=MRHCYQqfokRurUIkzgX8yDBzIH4TzI58Q1HsCcywP7F4wYeDjrvBN2y4ptZRAVpp2J
         FM12ltX1fWn+wsw4w1GTdiF5BfMdnXOxxD06C0gNsvXwU7VGFBkAsQZIBSIyD3wCpqPU
         tH+G5b5LQq3rdDqrd1EDeA+XgPVZgdRrmbNpwSOyDBd/GZCMpQgMGfxyr9pB4NpQSWtz
         ZOyFY2tlRoX8nn3hvK+4WipbZwdrf+CDRg6BNx6N4tZPpjJRkdaxQz26sOFQMYVSQXwR
         w0vw5QK42s+25d4nrUB1cyZ42iMqWhjwvj3ZNcQayL8Ogzp8lNNSAGxVoSUGACLL5hfQ
         NLeA==
X-Forwarded-Encrypted: i=1; AJvYcCXSXx5TDbQ2LhuRZhlfHeJCPK9QrWZQeLK2z/LV/KYQhfVckzxxzG90bZHLYjsD2x5x6CBuJRGjvA==@kvack.org
X-Gm-Message-State: AOJu0YzMZShE8qNMqq4SWZG7ZSXFGLUmkcI8mEUV1k7FIdyw0Im/8G8q
	wCmBpKNLxr1kUfnv/xHXqCORn2I54Z50XdyT/C4uf14i7oMAgpxoWPHYE/SK1BXvR/CccqAJhWX
	mPCmIBtfKc1dJ8PCxVNpS6TAmpAmpFyG5E5uQYkqGehRh+u43UHob
X-Gm-Gg: ASbGnctpTBQm87ucP29UvN+tTqcS867HtxDqKOM+CFrdENP8K7ztaRdY7fM6wSmAbst
	twkaaaosfXMt4ON31Le68OrqquiTGKHa9fMnKo5q/sEtbTZJz7MO14VLvXTGMuMGhxvpHP8mUBp
	+R3hvlUbXAhigh2Ju2IvxnpWp5dajw6hirlmTbC3/dtdc8v026e3U1nTBqyYU+W53FN13luqJU5
	4ZKseQgEhdOBcCPnjXViPSRGEwvfThEH2JVg07o4YJ12J0wtheae8Tg9kd1zTJW5y4nwm9xs5+2
	/5yivug+bERuCAnz0h+dudVbNlOZTFJbzJI9pxqzwZSrssA9Hdhjim5j15bz1DuKC0BR2g==
X-Received: by 2002:a05:600c:1f87:b0:45c:17a:4c98 with SMTP id 5b1f17b1804b1-45dddebfab9mr99866295e9.19.1757417610030;
        Tue, 09 Sep 2025 04:33:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHBiBNYEQvS/i0JuqrW/UpaZO5yE2t7qOVdFFOzhd4nnV0hELSzpufBxKXQ1HQk90HyJp0cmw==
X-Received: by 2002:a05:600c:1f87:b0:45c:17a:4c98 with SMTP id 5b1f17b1804b1-45dddebfab9mr99865655e9.19.1757417609218;
        Tue, 09 Sep 2025 04:33:29 -0700 (PDT)
Received: from [192.168.3.141] (p57a1a41f.dip0.t-ipconnect.de. [87.161.164.31])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e75224bc2csm2256196f8f.54.2025.09.09.04.33.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 04:33:28 -0700 (PDT)
Message-ID: <0e410c31-62fe-4145-8e8c-31fb0d4d1326@redhat.com>
Date: Tue, 9 Sep 2025 13:33:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/6] mm/gup: local lru_add_drain() to avoid
 lru_add_drain_all()
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, Alexander Krabler <Alexander.Krabler@kuka.com>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Chris Li <chrisl@kernel.org>,
 Christoph Hellwig <hch@infradead.org>, Frederick Mayle <fmayle@google.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Johannes Weiner <hannes@cmpxchg.org>,
 John Hubbard <jhubbard@nvidia.com>, Keir Fraser <keirf@google.com>,
 Konstantin Khlebnikov <koct9i@gmail.com>, Li Zhe <lizhe.67@bytedance.com>,
 Matthew Wilcox <willy@infradead.org>, Peter Xu <peterx@redhat.com>,
 Rik van Riel <riel@surriel.com>, Shivank Garg <shivankg@amd.com>,
 Vlastimil Babka <vbabka@suse.cz>, Wei Xu <weixugc@google.com>,
 Will Deacon <will@kernel.org>, yangge <yangge1116@126.com>,
 Yuanchu Xie <yuanchu@google.com>, Yu Zhao <yuzhao@google.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <41395944-b0e3-c3ac-d648-8ddd70451d28@google.com>
 <66f2751f-283e-816d-9530-765db7edc465@google.com>
 <ebaeb8d9-0b22-4304-9dba-40d37d82e369@redhat.com>
 <bq6mehuumf5gmf5tnm5jo3iiglqtn4yo3owkxhdddnkejd46jv@4hax34dkkzds>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <bq6mehuumf5gmf5tnm5jo3iiglqtn4yo3owkxhdddnkejd46jv@4hax34dkkzds>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lEdBox0tlTqotvHpsYT18-ohKCpin45JSl0HnXnMS8M_1757417610
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yb1dgf7wfqn66d7ss53rebniyexh8p7f
X-Rspam-User: 
X-Rspamd-Queue-Id: 146DCC000C
X-Rspamd-Server: rspam04
X-HE-Tag: 1757417612-312211
X-HE-Meta: U2FsdGVkX19eGYbJFFkzeMsbXTzzFbkr1QJeK5aWh34BTOc//Jj+0AGQ4FZyemzx6mneokGsEoBCHcRQrdOzwbDxyjxD3keLuWNB4sEz9vQOmiTruQRSPT5de52qJxvCvKsw4fIPQsPqcYgFCsFHEoJxpUV4nQCKY5GMwRqZFRzRmomlJEriAtglgTSDbKgVfh4qM3cqTp/5toSdwP+EzDuGCbYTqxxcLkw6UKTSSLUWdr8md2GMay9U7tYyOwZYujSFfeyMed6Dxrt2cYYKYXUEDv9MW4gR9HiS3TiToW64IPEZ09zQPvIwQ4qazliXIuaTGnPkrFsVEbVll7occP1xL1I54reLf+fEmIPybzLTR/FFT472aLyyzFLsX1QNIpQcyypI21eYEa5kUoE+HWeF9Bx5uAeEPa5NHcdN7aspmaZq/BjgRkj9j+j6LlK/ISl9G8M9nF0GC4Pd1ru8BDKYoLSVxibZCn97ItwmerzfWUekz5pEQqThbNdCzqbqpEk6jVVEIkpXLc7JzHSln+N4wV75c1t7yQe5xzKkpOk8doIVNIT3q6Wsav5gmOIqB6CX2qY4GZXYkRQm+sVypYt1byS+dcRpP/8JEVxGYL+h6Oz6DqxbDasvh1qa0ibA7l2diVvhxUvJMQyfRARQry63hLKu0ffhIhtMs0bxY+howz5tz/A8pnWb5NS8cU2sRIiaV1qNK/NBYp/wt0jGqNVCei0ZzL2bSxNlNKsTwVK9lGmML84vsI9GswzHJ/0SFNDZsREFPH7u9KPRtTKctjU3/WemzBW5O5cOPXfGDZxT50VCOVkVfwY3Po1qnzEK6bKmN+191CL5fMNxLv59RqTDvTXj4BoFdY/miuGD4A+aDWYfzpFB2mRBrLY1sSNxWEL5uHQKGuY/EwM9Uuw64PDiAVy0rAJkM3oDRKXQV68AjKdRSrH6pR7lMoCulhajOkO6MzKV8moyRVpd24h
 SchiSBeP
 VtXsCSdlkJOEkkXNg3Xc715ANX0mkHkkdJo9x0cTu7YuyrqRce9FVx0lAGrvSsfjNHHuX6AihqF1+V0OMybKVeLM7vAE0dFFyMT2J6Bi/yZ6aNGxRX6rEejrX3a+lbD/yj/+gVnQZuVgjIjsENcG6BRmzHjThyJeNB9R1AiWvj+YyP8wrpLscnH+mzWwrhXUAs9RgNHigBt7jYEdtjbMvZnl3SII+VQ0gaKut0GNBEh+VDh1410YTbwiaGUEjL7LJRBwVvIFNMA7faoih4QE3STbb5HBeEZ49LFoY6wR5Ee8e/3z9sdNBzTn9yzxz5sFGUMo6TdM61ZSpzhXpDVXRxuuD6Nl8ZRHlNaDO0AsOVLbJUy59oc+/VWypOkJ9ccfYdLsFklC9OZa35eIioX9keR3WQhHM8YuEkGE0TBGOsAT2D8SlrvMaF7IWUeTrYlyIEPed8h9JNNIQdBimFjCWS+dM7ocNYAYJB5SQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.09.25 12:52, Kiryl Shutsemau wrote:
> On Tue, Sep 09, 2025 at 09:56:30AM +0200, David Hildenbrand wrote:
>> On 09.09.25 00:16, Hugh Dickins wrote:
>>> In many cases, if collect_longterm_unpinnable_folios() does need to
>>> drain the LRU cache to release a reference, the cache in question is
>>> on this same CPU, and much more efficiently drained by a preliminary
>>> local lru_add_drain(), than the later cross-CPU lru_add_drain_all().
>>>
>>> Marked for stable, to counter the increase in lru_add_drain_all()s
>>> from "mm/gup: check ref_count instead of lru before migration".
>>> Note for clean backports: can take 6.16 commit a03db236aebf ("gup:
>>> optimize longterm pin_user_pages() for large folio") first.
>>>
>>> Signed-off-by: Hugh Dickins <hughd@google.com>
>>> Cc: <stable@vger.kernel.org>
>>> ---
>>>    mm/gup.c | 15 +++++++++++----
>>>    1 file changed, 11 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/mm/gup.c b/mm/gup.c
>>> index 82aec6443c0a..b47066a54f52 100644
>>> --- a/mm/gup.c
>>> +++ b/mm/gup.c
>>> @@ -2287,8 +2287,8 @@ static unsigned long collect_longterm_unpinnable_folios(
>>>    		struct pages_or_folios *pofs)
>>>    {
>>>    	unsigned long collected = 0;
>>> -	bool drain_allow = true;
>>>    	struct folio *folio;
>>> +	int drained = 0;
>>>    	long i = 0;
>>>    	for (folio = pofs_get_folio(pofs, i); folio;
>>> @@ -2307,10 +2307,17 @@ static unsigned long collect_longterm_unpinnable_folios(
>>>    			continue;
>>>    		}
>>> -		if (drain_allow && folio_ref_count(folio) !=
>>> -				   folio_expected_ref_count(folio) + 1) {
>>> +		if (drained == 0 &&
>>> +				folio_ref_count(folio) !=
>>> +				folio_expected_ref_count(folio) + 1) {
>>
>> I would just have indented this as follows:
>>
>> 		if (drained == 0 &&
>> 		    folio_ref_count(folio) != folio_expected_ref_count(folio) + 1) {
> 
> Do we want folio_check_expected_ref_count(folio, offset)?

Not sure, if so outside of this patch series to also cover the other 
handful of cases.

	folio_has_unexpected_refs(folio, offset)

Would probably be clearer.

-- 
Cheers

David / dhildenb


