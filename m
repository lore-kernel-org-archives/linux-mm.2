Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 559F5CAC58F
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 07:49:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE45D8E000D; Mon, 15 Sep 2025 03:49:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABBC28E0001; Mon, 15 Sep 2025 03:49:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AA958E000D; Mon, 15 Sep 2025 03:49:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8A0A28E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 03:49:03 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 30C40590FD
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 07:49:03 +0000 (UTC)
X-FDA: 83890708566.08.A13F852
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id B49CC160002
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 07:49:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Mvi7fWtO;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757922540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qisoeGyE0EFRiuyyAhasVklDrUzczuSCDZtmkfai59Y=;
	b=so9tdcEO+h10sR2B6ABqKkRQP0v3GBP7Pzj3i8nOEF88MwpGgmEw/uwbGwQuzylAvMb0e7
	IZL8+SdKD9DYKiJrogVhUrzHie5NLaOl4ij5w+MWm+fuy31ewLzdDL9WtoxWWk3m3fVQLl
	85qD1Zuh7F4HDYGTP0U/2LUMMesnIx4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757922540; a=rsa-sha256;
	cv=none;
	b=jtsr7Nt6PDVof4YCtNBAXRk/xmm03NWt89veiVBm9+yes1VnHPH8Gm0FsYTq+KCh31zW7q
	PWi+5VrI2rtxKBX2gaiEQB/VnMbFWyt4ayVMXILwEiWkVGxCPtdt6YKOjqEYaHwwWdhLWk
	4lwiAu304BINV4Fr5JNmhmWAiU90kYs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Mvi7fWtO;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757922540;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qisoeGyE0EFRiuyyAhasVklDrUzczuSCDZtmkfai59Y=;
	b=Mvi7fWtO4C5JmwdE/zPSTOLvBCvx4JT3/ZPZuG+N+l/Ng26a8dV1VHt1JJjwMTH1xhMGDu
	ycqFyFyubHDpqmWNu+klD0dWVQxdVXESV4hZDhcJCQkl3mtnFbgw0FReRK00oQsZaVNrdS
	gEOYN0MwPVmS0IPmONmqjcfY42UgkQ8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-jlwnyL8FNgq5TdfPsK6dUA-1; Mon, 15 Sep 2025 03:48:58 -0400
X-MC-Unique: jlwnyL8FNgq5TdfPsK6dUA-1
X-Mimecast-MFC-AGG-ID: jlwnyL8FNgq5TdfPsK6dUA_1757922537
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3e04ea95c6cso1515068f8f.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 00:48:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757922537; x=1758527337;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qisoeGyE0EFRiuyyAhasVklDrUzczuSCDZtmkfai59Y=;
        b=kcxUO1iZjBPONBPQ5eE62bOt9021WKzpgxC/5CXtgEsiaHviGmSIq/82XDfuastvGE
         AOwe0ae6tbcRBDARwzUAgo1vuExQN/3WS/KTIDP2HRtxo4KNJgf9OtezahBkQxuFI+gT
         fjRKNO22bjUGJExUEbfOItXy/ZPD1DsEeHrCF9CuCtxPyLMqXI/J+Fi7VH/q+JvoJRXS
         tgBeYY/nFZAoBJ0jfq9zfSYkXO4GkZUAY6NmNlKNXaI1gF1qpAsoeFSq6UCnQNWZJCdl
         oUkI4gFNYT9fq5WqlVP+l4KT1vx3H660UGBek31Br8VqqZ5I+c2Hmeqe7OTzAz/yTsv0
         zpGg==
X-Forwarded-Encrypted: i=1; AJvYcCWx8DP+mmZEA+0rL6Fw9EHRxmyasar6MccMVyRGuEAHv+HIyIJvEQJfd7qxEhLm/Odd00PluMvlSQ==@kvack.org
X-Gm-Message-State: AOJu0YxWB0vamII3DvwDycv6S0OnNw2McbHR+RlAJhUpt7suynhpAx85
	RomNcSnntYKBYvXvCGQVgix5UMFaq5sNqJGMyK5PK0BIAJUAKt4UFE8KA9XeIGpjoqxOfNsepAh
	N0Xsv9kVWtAbjYD+rOWRxGmdi9d3FNPX9iw7P/8dFZh3B+ENRwgCI
X-Gm-Gg: ASbGnct+idDaUUOTa88DY6B6oULyzvxBFoxRul7Log/uaGQ7ae5V1/vzk1P6wdl0cq8
	sC7UaS/mHAANTUWDRGTdPD49aNmc7R1/QnrwRIJxSN9L6/80Ps4uz1LSBRY2f9dJ/A26stoMVAL
	YLq6Wa44PcLq7QT/pnr96yWKXW1nCAJSYEtXjGd4kg29Ecz61freu/WgPGOe8P+Xh6oT66/yOVx
	EahHxpD/nK0sDAAIAzpbKBnBQoBp2cDQTArX/tXasfHyCRakpHQcGSxw68757f5ypOsnAMtt9Qs
	ohibN+VM4jCox25zNl2muqZdKtHpLNgxVjQiD5h3uKNCH/+1MUOxdIskk6xGu1fvJmhVpe14OvN
	kDt7U4Gu/Ed9JVK8BPR4aHWYP+R/fa5XuSbW2SCsLL1w1rRIBfFyZOrDowtshdSkFwX0=
X-Received: by 2002:a05:6000:2511:b0:3e0:152a:87c0 with SMTP id ffacd0b85a97d-3e765798397mr9813352f8f.24.1757922537411;
        Mon, 15 Sep 2025 00:48:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHTFiG5w3Ske6auBjrBpTrO+m8kHbvZdRMfT91kkBfZxLXIcYQIlCGAZ2wpvifNvjucH+fX/A==
X-Received: by 2002:a05:6000:2511:b0:3e0:152a:87c0 with SMTP id ffacd0b85a97d-3e765798397mr9813325f8f.24.1757922536993;
        Mon, 15 Sep 2025 00:48:56 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd? (p200300d82f18f900e0ae65d58bf88cfd.dip0.t-ipconnect.de. [2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e94163c03dsm6934860f8f.63.2025.09.15.00.48.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 00:48:56 -0700 (PDT)
Message-ID: <107d29f2-9474-4e58-8dd1-a1e8b552f4f7@redhat.com>
Date: Mon, 15 Sep 2025 09:48:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mm_slot: make sure slot is the first element of its
 wrapper structure
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org,
 chengming.zhou@linux.dev, ryan.roberts@arm.com, baohua@kernel.org,
 xu.xin16@zte.com.cn, dev.jain@arm.com, npache@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 akpm@linux-foundation.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com
References: <20250914000026.17986-1-richard.weiyang@gmail.com>
 <3a1adf4c-9931-4cdb-a024-37c856b1702b@linux.dev>
 <20250915014738.slkw4nwihb4aavas@master>
 <e368ffcc-0de9-4c8c-8e9c-6cbf8cdd22ee@redhat.com>
 <20250915074231.xnjzoqozqihqetwm@master>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250915074231.xnjzoqozqihqetwm@master>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 03TAlzjc5pRQAxMHHT1OVApwJWSQqr1ZZzLWvo8LKTA_1757922537
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B49CC160002
X-Stat-Signature: 8jc9y9s85ad5y3qd6szh3znxooicbybs
X-Rspam-User: 
X-HE-Tag: 1757922540-357191
X-HE-Meta: U2FsdGVkX1+JqdLKck9L5bFF6gB64gsa9nvXHY/bOXd6yMezkPwuE2FX4zbbXSWeqLPL2hYAKEgriOGLMtB9VJZ2yVkdJlWqMJRXRva++HGiXFQpe7FwqHnBEzAWRHpcFQA7CCvi0JEv1guzwL3YJJW7ZRzSNNotLT3QdsWqVlmaasiZfEPhhIyd1SiZwFyzzwWYnHmyVP1mMe0F9i3KQgB9+r3OIjotAgAMKTpgT9dPj24K3zCriKuaEimSpMamqHhPzOGq6UP7ii+lUj34zLov+kf/pIQc+xH9WLtIuMN8x39LlxWHWK+lx0NNMrjXSTc0Rwb/e9jompjnJI2blm39MxtgO6UnQauBpEFh0oNj9XGkhTLAkC2XKqBwDHHeVxa8RGBommwOoI7C0EwtE3959ZFT7aASr+eM6ABboJpR6vRA8IsP6mHKQWxmOrLkSU6E1hWP3SAgfZNK5K7MzOMOjkrtUeKOY9/iw6xBBch5BrANKknem8gsQIU2DOnNvo9ya65MJCF+fX826K4WdQUVjMTSXWOghXuFnBvRFbKm3rMnN8Xm/wTm7lrNx+dT01q4SjbJbf/IRL/jaxkN0mE3yfhQMmnlLww2TqCbrsGkLTznNQ84IWSrNxBKDeObOI6QSlNRjAPqrAroLzaacgRb/2H9UoUZmLT0TBeXfq6YmAqA5uhWPWYxoRX+iITNoXJ4ZnIoaC1z1ZBibAc8M95Tt5zpRmny0pDj9tyooAjawPeJ1+kdf1nKPYym0ZLPQMFi+PTeJsBPdd/ePwqoH1jjNVR4TayIUafO4bh6mFP7gPpeCuvPb/Wm5rjNfdtZ68jbZWjCY2HOw37K0v20tqs/Ig+bZc0nJtJe0Z0jw05qvw5VxGfKmCjOyBlLZ5Qvf4sMt1vLlyCUJK86pi423D5uUX1yXrrKzxaHFly2gtWPX8ag38dodRpxDVY0IJX2XSKuipIi8u81PpOONRM
 jkEoztFJ
 W687YrDBBpYBabGhJGZQlO2Gaai+0o6VHo/Ku71fxK5viQbwGKzRhEcsjtN9f8eqdYL8dB++mFKYlGevtdMd4nba2j7hzCUbVNRtxc5ticcB3cGguKJnIKOhfAfye0hqtTik+5V7/rO/2nQWTnez3/in8biZ8Ip1ZZvQJpdspd0rB72HCz3M2qP4br0cdAFVkW5bzJ+u+5o5O2InsUmaltNUuPSlJN+MxWjPjiockw6YPg3x3bNG1xUV7Mhkw4/Oo+uniKt3ikriZCcfQoI7UnhNiPPEbzRJIRC60CxoVFdugeua2v9HMeSazjLYqUtF6519NFF1jHOD0JsOXOMm35xPoJRWX7daTOtGdtBtx2R01YnxLRZkr+q4r6dHYfgUIzEcprIRpPIuAgpgawNyEmPVbGlZG5f76IIcldFOoOUZcnZ3UoPSYSgmLtgge1aWjNuUrgdxbRAFSse987R9mdLr81ev1sMEBwORvscx3/pk4xwF0csl+6Sp4Ip23BsX+Ure5RDhDtaZAYhTuOEXrgrTY+PLRG74XVRlRhV31J0E1KTAtLyStgHKez/aFPThEvNrN12dNpFwhOFT5hfA0R2257w5u8+C52zVl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.09.25 09:42, Wei Yang wrote:
> On Mon, Sep 15, 2025 at 09:32:27AM +0200, David Hildenbrand wrote:
>> On 15.09.25 03:47, Wei Yang wrote:
>>> On Sun, Sep 14, 2025 at 01:05:48PM +0800, Lance Yang wrote:
>>>> Hi Wei,
>>>>
>>>> On 2025/9/14 08:00, Wei Yang wrote:
>>>>> When using mm_slot in ksm/khugepaged, there is code snip like:
>>>>>
>>>>> 	slot = mm_slot_lookup(mm_slots_hash, mm);
>>>>> 	mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
>>>>> 	if (mm_slot && ..) {
>>>>> 	}
>>>>>
>>>>> This is only valid when mm_slot is the first element of its wrapper
>>>>> structure, otherwise a NULL slot would converted to a mm_slot with
>>>>> negative value. And current code thinks it is valid and continue.
>>>>>
>>>>> Current code works since mm_slot is the first element, but make sure it
>>>>> won't be disturbed.
>>>>
>>>> Good catch! That's indeed quite brittle ;)
>>>>
>>>> Just one nit below.
>>>>
>>>>>
>>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>>> ---
>>>>>     mm/khugepaged.c | 5 ++++-
>>>>>     mm/ksm.c        | 5 ++++-
>>>>>     2 files changed, 8 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>>> index af5f5c80fe4e..668e74ad33b7 100644
>>>>> --- a/mm/khugepaged.c
>>>>> +++ b/mm/khugepaged.c
>>>>> @@ -108,7 +108,7 @@ struct collapse_control {
>>>>>      * @slot: hash lookup from mm to mm_slot
>>>>>      */
>>>>>     struct khugepaged_mm_slot {
>>>>> -	struct mm_slot slot;
>>>>> +	struct mm_slot slot;	/* keep it the first element */
>>>>>     };
>>>>>     /**
>>>>> @@ -2382,6 +2382,9 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>>>>>     	struct vm_area_struct *vma;
>>>>>     	int progress = 0;
>>>>> +	BUILD_BUG_ON_MSG(mm_slot_entry(NULL, struct khugepaged_mm_slot, slot),
>>>>> +			"slot should be the first element");
>>>>> +
>>>>
>>>> I wonder if this BUILD_BUG_ON_MSG() in khugepaged_scan_mm_slot() would
>>>> be better placed in khugepaged_init(), like you did in ksm_init()?
>>>
>>> khugepaged_mm_slot is defined in khugepaged.c, maybe we don't want to export
>>> it.
>>>
>>
>> We should probably just use a static_assert right nxt to the struct and make
>> sure that offsetof(struct khugepaged_mm_slot, slot) == 0 ?
>>
> 
> I am ok with this, but Dev suggest to fix in the code.
> 
> Hmm... both works to me.

Right, if it can just be made working without requiring it to be the 
first entry, we should do that instead.

-- 
Cheers

David / dhildenb


