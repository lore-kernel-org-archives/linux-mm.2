Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCCB1C87FCE
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 08:53:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 706CC6B009A; Mon, 28 Jul 2025 04:53:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DE7F6B009B; Mon, 28 Jul 2025 04:53:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CD866B009C; Mon, 28 Jul 2025 04:53:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4CC426B009A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 04:53:17 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 063BFB6910
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 08:53:17 +0000 (UTC)
X-FDA: 83713059234.26.202FB3E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 54CC0160012
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 08:53:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QH+OhAGG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753692794; a=rsa-sha256;
	cv=none;
	b=OVsKp6UXIcikCFoCmbG2/5SbCAbk+Krnqz3QPXCm3UhS7XxHtgSQn2mmP5x3IGrUuKOap9
	AmHfx2S7U0YNmJaCchZPDe6dkkdTTwULcyXCFDT1chn9vrhVqXglrt8ePFGrCJcOP0eik1
	yzVf/jfN1HEM9AFXanXG0nrn8quBQpA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QH+OhAGG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753692794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1XCo0aUMUj8n3sbzJ3DgM8bPeeh+Iez7uG4ZWkUkWos=;
	b=2s4FCpGqp5EAwnb38EbBWYQjErA/VF9n15ZvZOU71m6QL64dWrHeiyfZ1590C9z0VpTcwY
	xrwtshDxGTWnhPn+nE3dBcLC7Kv29mS0jBEf7Ob87jaS/VUZLcOmy2Gzvt2VwWziO9xFx/
	GzAGmcCHl9ztGX6dM4/eZoABSkw+0pA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753692793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1XCo0aUMUj8n3sbzJ3DgM8bPeeh+Iez7uG4ZWkUkWos=;
	b=QH+OhAGGusS4tvuFyaCrRMwQcMXFeMsrPd1mK9zjWxVYX+lmFuta7gsSNu1co5mbx7FyLB
	1me6foy8cO9h8dk72yyJfJE9Iba3X2xErNoi4Vue1BgFoe62AzuOyC+xCm7fCUVz8QFs92
	2+hArJaXXcCea4R6rGHN0I0g+XrtqvM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-413-j0LKCG-UM5iMtvxhu3jkZA-1; Mon, 28 Jul 2025 04:53:12 -0400
X-MC-Unique: j0LKCG-UM5iMtvxhu3jkZA-1
X-Mimecast-MFC-AGG-ID: j0LKCG-UM5iMtvxhu3jkZA_1753692791
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b78b88ecfeso149802f8f.3
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 01:53:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753692791; x=1754297591;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1XCo0aUMUj8n3sbzJ3DgM8bPeeh+Iez7uG4ZWkUkWos=;
        b=XXK134zyWEKvDmPCdulCk2HVO25FbDEeiGowKVPX9we2DYxwNOVFsX7p8nqqgVa9tl
         rkLfgdRVCEoPyZm7HMF2TXwZJa5qbt9Iced6PEkmrxXohYBcoxtsxcevS22Fjk8Apv/N
         lZ3+i+nqQf57+t0AFOessYXY0KP7XDYYhti/YbvyGoa+yEFFqgeNohZQMwwiBFPpGeQS
         BlVngK7XdqRrH9maIyol8zLP0SOvZg+mkKHwkohFwwpyaMyiIIF1VR+AWZ1l/K2WAjKC
         X5m4lJTHzbVRM0kjcX7R6IBZOpyxF+4dev/ZOqqmmRanoZCfOUar2rkQnXKkltCpEf6d
         l3fA==
X-Gm-Message-State: AOJu0YxKo7aCZJZ8mvPgkyhEdFcGtK2yDKvvf840HhArAW9hSuv/p4Ri
	q4lbsHw8wbV1x+VnYuAv/DkcqXL1LtWzR//ZqJP8olnEl116FR0bwhpfTWpeGVaEOOemiQFdqVd
	UPeSEI0RGTCQWRYBqPFuC5P/DRMMaCDfSRhV8M0y6E6az2AR3OfbfIhCYhdiOkQk=
X-Gm-Gg: ASbGncvUkT6oiXDeBB2dkx/yfX3xmWyxXp0wUJ01VE5rsJ8lAD9LF8MaE5Ybc/UIFhl
	czN5L//DFaIz32IhE7TUTlUOdDDU9Vcosc8NH8mAYm6m1DfUoOuhopTj1dLMVhpPmlVHQ7s65dZ
	NDxSHi5BvnW3+8t+AcqbsWe6Jo9w+GNWmho8oR7qzqckkW8y5ru/gMMSPOP+b3/juC5W5/6+zYY
	w2N2Yn53foNtuamFkoAuk1OycBT8ZdMz7VzsWOtjd6yrUMZhnvNHHQ7SExP2yYjf97n/Rz9pZJE
	sshUlor8sCnGi54QSwtf9MMGy/abbbsaaPgWC3i9yMhpBs9kYxe2XbeLG0mAC92Fki4lwgeOVzM
	LsPldUJI/7X2eLixD6dM5ofjCBc4+No9+HqXquFw0i8MTwlm4VXFWMPwnUIG8QQt3J1U=
X-Received: by 2002:a05:6000:178a:b0:3a5:8a68:b823 with SMTP id ffacd0b85a97d-3b776732ad7mr7200931f8f.23.1753692790740;
        Mon, 28 Jul 2025 01:53:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFAgGlEpI1B/hYr2aQ6WG5yauzlH0r4RATtb79hiUTB2BLgnNjxAj76dShQvRyupenOieJqMA==
X-Received: by 2002:a05:6000:178a:b0:3a5:8a68:b823 with SMTP id ffacd0b85a97d-3b776732ad7mr7200905f8f.23.1753692790222;
        Mon, 28 Jul 2025 01:53:10 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f47:2b00:c5f3:4053:2918:d17c? (p200300d82f472b00c5f340532918d17c.dip0.t-ipconnect.de. [2003:d8:2f47:2b00:c5f3:4053:2918:d17c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b778ec36bcsm7985259f8f.37.2025.07.28.01.53.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jul 2025 01:53:09 -0700 (PDT)
Message-ID: <2f24e725-cddb-41c5-ba87-783930efb2aa@redhat.com>
Date: Mon, 28 Jul 2025 10:53:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] Disable auto_movable_ratio for selfhosted memmap
To: Michal Hocko <mhocko@suse.com>, Oscar Salvador <osalvador@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hannes Reinecke <hare@kernel.org>
References: <aIcxs2nk3RNWWbD6@localhost.localdomain>
 <aIc5XxgkbAwF6wqE@tiehlicka>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <aIc5XxgkbAwF6wqE@tiehlicka>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BABTIZXc-MyxV-Qv9S9JB7NZcwddELxRAhrn5lWPSmY_1753692791
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 54CC0160012
X-Stat-Signature: zaz6cx9inr5gqezbfpeb46awiak1mwj8
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753692794-179469
X-HE-Meta: U2FsdGVkX1/pROv3dJXm0FGLMl4CXxoPm0FAtNwSP7I9+hDkJdxAwR8PWrEDYQ8RkIYvrTcbZnGi5ni2AyIRNBeIc5PpBM1ZKfDc2YS1WUe1zEUALgBPU67qskBHzoqzkLnNxmOw/4ZhHBUqPvT7oqFzfhP98cGCNQxX4H/tthpGzCVMbe7pTOiiql+aLIWovNUwIDy4LNZ8LMymQSerb9UCQKdotTWcC+eiYpUxsgini0p2cT/StTHPfc3DQ7bpZTOC8aa8/qWgfkv7tQOyr7X/bgce9FG9xJcIQeiWqauhJA24vGS7NswU+p/IJwJKcEOJaCyYgG0OMwY25YzZ3ovho6mujWvblvw7blqykviCYpW+CVn3xhyT3UkSXphLpBSCsI37t0yZrU5jBcWnHKa/Qv9FmWxFpRShHDL5DfLN/67iwEm2jFKhOmNBEJpC1gJcVHFeql6QVBHFusQu7Fw3s7o5KsJtvWOMrm1O0evkzxB6qjZ1ncrEXZwPWZatFGqnA5Um976lUXTK1uiUbDGGXANzUUtlj6cgeisj1UzYMuFzdfnJifkYjAh2NtUfebK7ucMbHAP4hMeUxda7WrtPSSLi3otH0rQJvJiAmXgLoKBbZ2s5zmznhMRIhUnEjfgbLKWJFkRPizdp3s1X0Ltk3m8NO/m7lVbodYjbkwCfAYjul1gO97Wolj3LbZAu8HlS2FQ7jiBret7EpgOIGrLkzG7szlrWc9Sv+Iog/CqN5QsoKJaKpC6nJBoWcOreamn0rKhrW7Uh6rXR/o7piXuD7qRLXSPdodgCc+UNXcgRKYKexpexDpRayaEoHV7hkAiHskmWGnde3mzFHTTLvTmL9CfitJH3FDiYfzpPDkak00MB0C6Gi+J2LmrKlNi+2P+bHrZg1y2aCU5VGOAB7aMnDzeRUYXTxK3kle76YqLGqiN00BEo0/fik2QtdU98Sp4IpWLQBF7shAwYVCv
 +28Ged9p
 jNzahE1h1ZJwXwGIIa3VMlrYvfTwpXaUYPvFAnbpmERdKj9hjw26NipNwSOZM48Oz3M4GXKN04nec6J1VePzukk7jYtbUBUpLKavD/ogtKCKZgta4MJJ5+0nuhiQKNPPxI3f/d4r6/lZvZjA7s1Xr4gcVltrq1/MZG46Z7GKu7iv/1wNmjWSIlzeGJ3yqDH90FaTTk8nCRzIEFzGZ/E3Fw1EdEdv6yyyt0RVpBQJlcyBjhcrZ9bucrbV6xt83D/86IHpXEvWIzcjuRRpWhN70ozFweuCkGQiNNOBTtCF2TMoNlOXuFpIHMwAeTOAfnHsB1apoWDnUdxXVjcQwgM0h9W67AimXetyeRSOIn16ajmkxDH5yNb9fVQ182J+YsAoKxVHtZfcFGrjEUr63RdUPxXOSjqkH3+FsGxzScBwyUhBw7o82bZjRYfdRzyk91vLly1n5khWZf2lCJYsMWnhj3nx43h0A570YKcOHAoSD/+k7u8/nuVx5zy90m2EgxHdgr6Ut
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.07.25 10:48, Michal Hocko wrote:
> On Mon 28-07-25 10:15:47, Oscar Salvador wrote:
>> Hi,
>>
>> Currently, we have several mechanisms to pick a zone for the new memory we are
>> onlining.
>> Eventually, we will land on zone_for_pfn_range() which will pick the zone.
>>
>> Two of these mechanisms are 'movable_node' and 'auto-movable' policy.
>> The former will put every single hotpluggled memory in ZONE_MOVABLE
>> (unless we can keep zones contiguous by not doing so), while the latter
>> will put it in ZONA_MOVABLE IFF we are within the established ratio
>> MOVABLE:KERNEL.
>>
>> It seems, the later doesn't play well with CXL memory where CXL cards hold really
>> large amounts of memory, making the ratio fail, and since CXL cards must be removed
>> as a unit, it can't be done if any memory block fell within
>> !ZONE_MOVABLE zone.
> 
> I suspect this is just an example of how our existing memory hotplug
> interface based on memory blocks is just suoptimal and it doesn't fit
> new usecases. We should start thinking about how a new v2 api should
> look like. I am not sure how that should look like but I believe we
> should be able to express a "device" as whole rather than having a very
> loosely bound generic memblocks. Anyway this is likely for a longer
> discussion and a long term plan rather than addressing this particular
> issue.

We have that concept with memory groups in the kernel already.

In dax/kmem we register a static memory group. It will be considered one 
union.

>   
>> One way to tackle this would be update the ratio every time a new CXL
>> card gets inserted, but this seems suboptimal.
> 
> I do not think this is a usable interface.
> 
>> Another way is that since CXL memory works with selfhosted memmap, we could relax
>> the check when 'auto-movable' and only look at the ratio if we aren't
>> working with selfhosted memmap.
> 
> This is likely the only choice we have with the current interface. We
> either need a way to disable the ratio altogether or make it more
> automagic and treat self hosted memory differently because that memory
> doesn't eat up ZONE_NORMAL memory and therefore cannot deplete it for
> ZONE_MOVABLE.

daxctl wants to online memory itself. We want to keep that memory 
offline from a kernel perspective and let daxctl handle it in this case.

We have that problem in RHEL where we currently require user space to 
disable udev rules so daxctl "can win".

-- 
Cheers,

David / dhildenb


