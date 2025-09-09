Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74219CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 11:51:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7F0A8E0010; Tue,  9 Sep 2025 07:51:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B56978E0001; Tue,  9 Sep 2025 07:51:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6CB98E0010; Tue,  9 Sep 2025 07:51:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 924D78E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 07:51:00 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 28E84C04A1
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 11:51:00 +0000 (UTC)
X-FDA: 83869545480.19.590F0CC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id D4D0440002
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 11:50:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="d7k/BFNq";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757418657; a=rsa-sha256;
	cv=none;
	b=Kj8qDGIEeLmfegWJckhnw8PytFmCDqrf5e9FK+wxizaGO1qFiwnEwnX71m3OdlFCt8erou
	A9MSEN/FrHRwQ8u0FiBsgF8AEp+WviVE+CimgQxe/U6Ay40Jc/3YFMPo4DBOYyayDdMG6Q
	inpOnqKeFJDJVYXsgfHw191ZWKK32yY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="d7k/BFNq";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757418657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dKhIp6hIrUR6EZQSai8TLK9KbdoogTZRgdnHTmgwxEY=;
	b=h5Li4NC5xcKQzeb+7NIKrN4mg5vRsYcIz0Q1kocjhe8br6Cvt+w4SFsuH8pRZbO6eXu9fy
	pBp4dAILw5Z568bRj7B1HEtecODAfdEkQDrcQeShfe8A36B6K67tnmIVsTHqDBJQ01vYcm
	t/AAn1O8eY64XvMWzSOuRn6KLNRtb8c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757418657;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dKhIp6hIrUR6EZQSai8TLK9KbdoogTZRgdnHTmgwxEY=;
	b=d7k/BFNqQppX5tiZfe2iZco3oDPTIwgHml7ME7igHZdbN2NjFkJ06j1PuCxuqNbooMwAVX
	EyIXa3BGEI7d5AIdjIzokgMV5jAJRCicOVncgixegd3jbL5zhF+8WhQc4p7QE+CTgh7i1J
	2JYAS1SUX1hP7sO+jih5r3JzbE7aVRs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-240-jv93eWL2N4aIeQM82atL2A-1; Tue, 09 Sep 2025 07:50:55 -0400
X-MC-Unique: jv93eWL2N4aIeQM82atL2A-1
X-Mimecast-MFC-AGG-ID: jv93eWL2N4aIeQM82atL2A_1757418654
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45de14da365so23408595e9.3
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 04:50:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757418654; x=1758023454;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dKhIp6hIrUR6EZQSai8TLK9KbdoogTZRgdnHTmgwxEY=;
        b=DfsmDislYB0hVMwi9pYnsUBmLzPl7HBvoMZXCPGgeVeSMPpQJlv1bvyJ5j8S+odTZJ
         7fkMt1Vq4CmL85qafxbn+PqGj5CwBdpRE4P3mpndoYx4Fs5PbVLnHsPPlh0+pFbNSiWX
         jLLJd4XIp3tHPOPjjP5vQmp+8TnYN+xGjkgIrRRqusAMR1V8UDSqkyoV9U0W/lJr5JQ1
         Fk4Hfzdnk/Li2COSkhrkqy1YbZZHEfLkVv4WX4meqYNg0mIO54Yo3/tyJVbhm5fYSp15
         tlRebKNMhqUPkamFfCMBj+YBgZ9faZDKLobm1xmG8c5IamjgayKz3I30+xypDlOMz/yH
         ZNGQ==
X-Gm-Message-State: AOJu0Yyi0T1J0xIf3k4oKQOdlSC8ybk8ZAJzbth87YL3bdZ+KtFTAvCV
	RMnh7Q9PslQrgVjUDZmLOITLOHba0FMG7Uird/PTnTZbRP8vTE0eGPjnC19whI7lYs0SGEchfwr
	u4iLNEksZdAQ8zSQ3brOYBbt3xX42v+mHo6Itufgatuy2nWJ0GTiJ
X-Gm-Gg: ASbGncsHXGfFbWzjunMkAPKCKjMsBROwFxdMnvMVSGMCqyCOe6odPrHC5QJoyAlDC4u
	m+7A0wJijQB6/u3Ute0WDLvAJIqTY75xYNb/CS2+A9M3JxYzVIuCKOiDe2LkwWGrF+l06lC+15a
	gooL9XdZ9jFec07SknsVc5F3lfx4I6IDQXYwE8ddYTRrIn7kJym6umykUshitECPajEsjoWhF4j
	JK5Llzco82x0s/6dLyXqpK016r2e/ZHthNfPnOvNTeQ+RFjkwe6pEsuTjAGmZAwotWkC0A4W5RU
	BSlcCS2QGFnJx8X+88Hi3Wpo2bjqiMCz7XBcJ9QKftq6RydiV0azuVavYWuhQtjjEQ8juSlFLnI
	spzn9JxMeNmCaGFg2T8R7SYPGhl35ZikUOguqDuL6mrkxmdOc8AU0v5JNreqyUqK27fw=
X-Received: by 2002:a05:600c:1390:b0:45a:236a:23ba with SMTP id 5b1f17b1804b1-45ddded76a6mr93179925e9.22.1757418653858;
        Tue, 09 Sep 2025 04:50:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFLYxXGJ3JeYQUXq3Qs+8TSlviw2rq3zJWOHMDGMzgm5GnZu4lD6nyVRrpMbata0TKkHbHy/g==
X-Received: by 2002:a05:600c:1390:b0:45a:236a:23ba with SMTP id 5b1f17b1804b1-45ddded76a6mr93179675e9.22.1757418653373;
        Tue, 09 Sep 2025 04:50:53 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:9c00:d1f6:f7fe:8f14:7e34? (p200300d82f239c00d1f6f7fe8f147e34.dip0.t-ipconnect.de. [2003:d8:2f23:9c00:d1f6:f7fe:8f14:7e34])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b9a6ecfafsm339135615e9.21.2025.09.09.04.50.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 04:50:52 -0700 (PDT)
Message-ID: <655d2d29-8fe6-4684-aba4-4803bed0d4d0@redhat.com>
Date: Tue, 9 Sep 2025 13:50:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/gup: Drain batched mlock folio processing before
 attempting migration
To: Will Deacon <will@kernel.org>, Hugh Dickins <hughd@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Keir Fraser <keirf@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Frederick Mayle <fmayle@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
 Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@suse.cz>,
 Ge Yang <yangge1116@126.com>
References: <20250815101858.24352-1-will@kernel.org>
 <c5bac539-fd8a-4db7-c21c-cd3e457eee91@google.com>
 <aKMrOHYbTtDhOP6O@willie-the-truck> <aKM5S4oQYmRIbT3j@willie-the-truck>
 <9e7d31b9-1eaf-4599-ce42-b80c0c4bb25d@google.com>
 <8376d8a3-cc36-ae70-0fa8-427e9ca17b9b@google.com>
 <aLGVsXpyUx9-ZRIl@willie-the-truck>
 <7ce169c2-09b7-39e3-d00b-ba1db6dd258c@google.com>
 <aMAR1A1CidQrIFEW@willie-the-truck>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aMAR1A1CidQrIFEW@willie-the-truck>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QPqgfnGMp6F2S46JRE0aT-c41SgspEBLlx4r0TCAgZk_1757418654
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D4D0440002
X-Stat-Signature: 8c1deeitfxudu7x4uj1mcahj5yy7pfxb
X-Rspam-User: 
X-HE-Tag: 1757418657-551999
X-HE-Meta: U2FsdGVkX19LCUvCYLl3jg08kAjbQGqJToWLsHSmnd2mIqdA6bO2S+JyCb4GMFDYTmOaqvMYvwjksGNKjUweRSf1kTrKt686Ilr+jdxTCmripkn3Vx2d1XrY3TQtkE/ikP19Zg0qsVRBAAiTq79Gdl6OIkiGIe1+GcehsU0upE6TaMjwPY4pgXCU/8hQqbm99lSEeaVtoVmY345ZXTrElbvwqR7tbTcyUbnuYMH8v0oeXjlc7wayZnqaaJqvKfUgl715gVTyIEa7o5SBsrpwjg+6DRDrcXQFsSIHD5XyRdDscnXEe9QHqVVxm11oOcwInsU4mUeLR4ZZEwB77pDH6fl9q1f6Ib/ri3zyQAkj/29ht4SkccZbC5KW3zZobTwGTyEb0kZXu3HKF8nLO/ZwARXNtbChOiVqO7TAp3xaadVMmd5v6tBK5GbEKO22L9KHXwLor2A4Rl+d4q6IdCXV2RwkmnjlXjrKcTo+KK+YgZ1no+UsnarCkKxtW8Pxw9Tfko9im8a03EdLNSA9o71hTW0bLJs8Na3zmsGLplFfVEQqz65rIqiGCuaCv0mT/FMI24lHZNTjcI9FbHe2xxyQBiAKbt9CQfPTxwcBy4bWtRtApJwvvFeJIjLcrXkxSrOOxOHKL2b0b2tXyo+W4wDiIeydgCjdrlJgOEQtgzxRY8ZGQjf0rq7PqOz8fJ4xwymOFvBX6EKgIOSpcJf69s1Uhhw4nSoJvQh7WxhfiZWGJlnYNKS99PXaCwOckK4UGWNvM0/tkiu6XmmWRpWQG5/23Cc1XoUKUOdqcuRMgZSoRd6O6JCx8in3mamrt3WMfQIyOYlbkg+s0ntaDPePz4r6+ydnhhrJhGC3l52DGflpiO8PViq1GnG8XmHdgT1RgM2WbuLpUEekj1G9Kckpo430kWYpv4EVrkv6/iiVLPGAmrjKGSUuTJ3PqaC0HigdKbCKsB8wZcCDKh//SnTN/RF
 R63qAFSG
 rrCqpS87fp4exY4pETA3GqNYAb0kfDchmg05hEHyjIL4i/3RL9DYyvFGF8pgJzDWJEt6mK8r6xeYGf8j4C+uUJPchdmR3QFuq79ypoLH5ZPJFkKIXbYb425cbpPy6n/kCBedxf8MmYqGJbvTHY5ahG8o2RMYTHJvYgawtzHufkxMLD37Wjk8pVyqBIXpkxaPj+KZGsx5MVVNBw2xB4LSCBk2URNeVSqITqLzlispGvp4bZi2teY0H1mVtWVtVk3rjjS2SM7zebNqZSz7sPSifGA9vjGZQ+oVxIWppw1dpDlsEPwfOXA2teGAXxJnzPFYQmU/OFNiZD91AxhI944bi+J38Os7bHxkW8+sp+tYXCe9TDpAI+KrCiYP+Rk+1mRDRmuNx3wzHmotHonAlB+vCjSGZwtjt25B+QDXoafR6QFRdNvdms9NZ99j23VYKSHV3sbvh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.09.25 13:39, Will Deacon wrote:
> On Fri, Aug 29, 2025 at 08:46:52AM -0700, Hugh Dickins wrote:
>> On Fri, 29 Aug 2025, Will Deacon wrote:
>>> On Thu, Aug 28, 2025 at 01:47:14AM -0700, Hugh Dickins wrote:
>>>> diff --git a/mm/gup.c b/mm/gup.c
>>>> index adffe663594d..9f7c87f504a9 100644
>>>> --- a/mm/gup.c
>>>> +++ b/mm/gup.c
>>>> @@ -2291,6 +2291,8 @@ static unsigned long collect_longterm_unpinnable_folios(
>>>>   	struct folio *folio;
>>>>   	long i = 0;
>>>>   
>>>> +	lru_add_drain();
>>>> +
>>>>   	for (folio = pofs_get_folio(pofs, i); folio;
>>>>   	     folio = pofs_next_folio(folio, pofs, &i)) {
>>>>   
>>>> @@ -2307,7 +2309,8 @@ static unsigned long collect_longterm_unpinnable_folios(
>>>>   			continue;
>>>>   		}
>>>>   
>>>> -		if (!folio_test_lru(folio) && drain_allow) {
>>>> +		if (drain_allow && folio_ref_count(folio) !=
>>>> +				   folio_expected_ref_count(folio) + 1) {
>>>>   			lru_add_drain_all();
>>>
>>> How does this synchronise with the folio being added to the mlock batch
>>> on another CPU?
>>>
>>> need_mlock_drain(), which is what I think lru_add_drain_all() ends up
>>> using to figure out which CPU batches to process, just looks at the
>>> 'nr' field in the batch and I can't see anything in mlock_folio() to
>>> ensure any ordering between adding the folio to the batch and
>>> incrementing its refcount.
>>>
>>> Then again, my hack to use folio_test_mlocked() would have a similar
>>> issue because the flag is set (albeit with barrier semantics) before
>>> adding the folio to the batch, meaning the drain could miss the folio.
>>>
>>> I guess there's some higher-level synchronisation making this all work,
>>> but it would be good to understand that as I can't see that
>>> collect_longterm_unpinnable_folios() can rely on much other than the pin.
>>
>> No such strict synchronization: you've been misled if people have told
>> you that this pinning migration stuff is deterministically successful:
>> it's best effort - or will others on the Cc disagree?
>>
>> Just as there's no synchronization between the calculation inside
>> folio_expected_ref_count() and the reading of folio's refcount.
>>
>> It wouldn't make sense for this unpinnable collection to anguish over
>> such synchronization, when a moment later the migration is liable to
>> fail (on occasion) for other transient reasons.  All ending up reported
>> as -ENOMEM apparently? that looks unhelpful.
> 
> I see this was tangentially discussed with David on the patches you sent
> and I agree that it's a distinct issue from what we're solving here,
> however, -ENOMEM is a particularly problematic way to report transient
> errors with migration due to a race. For KVM, the -ENOMEM will bubble
> back up to userspace and the VMM is likely to destroy the VM altogether
> whereas -EAGAIN would return back to the guest and retry the faulting
> instruction.

Migration code itself will retry multiple times, which usually takes 
care of most races.

Not all of course.

Now, I recall John was working on that at some point (I recall an RFC 
patch, but I might be daydreaming), and I recall discussions at LSF/MM 
around improving handling when we are mixing a flood of short-therm gup 
with a single long-term gup that wants to migrate these (short-term 
pinned) pages.

Essentially, we would have to temporarily prevent new short-term GUP 
pins in order to make the long-term GUP-pin succeed in migrating the folio.

-- 
Cheers

David / dhildenb


