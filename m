Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5B1CCCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 19:52:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 025098E0050; Wed,  8 Oct 2025 15:52:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F181A8E0002; Wed,  8 Oct 2025 15:52:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB8B18E0050; Wed,  8 Oct 2025 15:52:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C13158E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:52:31 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7F86C460DF
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 19:52:31 +0000 (UTC)
X-FDA: 83975994102.08.2D17869
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id F25018000F
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 19:52:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AKAlqxU4;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759953149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RtTlwRw/t9hpT+l94+pAzSz0mGXw5QPtsOjkoODOmNY=;
	b=UjfGQS6+32cIMbWh2ikeuhi891ktTc7Ya1bTGKPRdrlrPTJ5NT3LYO9Ek649jYIyEsl9uS
	YythXPpjaA2/jAAnVCCeHZVg5+fghDslPCgVtbPoeaUVS0dy1oc/rboY7NXSToOKmvjpOo
	2+gVzeH8sB0lFxb7ADVWKYYSTmnXJWM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759953149; a=rsa-sha256;
	cv=none;
	b=wJqiUhyVCAuhQFYuDy2lq2qFThf/DP62muYjHsvptGZcW4WHlxUiPjt+MDB434c3YiPD9f
	+6ixDDppi9G1OJJ43naSp1saG9k9+VmpS/gzXh4/TVdhK6Tvq7eK25vAn5gVJk5UPiMBo0
	BFQfpR3dJ4fIt/idoKvCxw66tu0h3VA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AKAlqxU4;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759953148;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RtTlwRw/t9hpT+l94+pAzSz0mGXw5QPtsOjkoODOmNY=;
	b=AKAlqxU4+Icxrnmj+wGyWqPwFKKTtFeVh33XXj9pneYNBkZzmtJ968dbQGvdPrkAmsEKMI
	iIkXpPVo0g9z1kn4+iG7tjaq3GYa/sbLX1litS8TlEFLMSb9OwB4qXKYrZDZE7fNE2XiH4
	bkt2VzBQBFkhwGBhaLTdnvljpSct+K0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-480-KK7paCK1Nqy8xKdOxaNOJw-1; Wed, 08 Oct 2025 15:52:27 -0400
X-MC-Unique: KK7paCK1Nqy8xKdOxaNOJw-1
X-Mimecast-MFC-AGG-ID: KK7paCK1Nqy8xKdOxaNOJw_1759953146
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e4fa584e7so1012955e9.0
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 12:52:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759953145; x=1760557945;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RtTlwRw/t9hpT+l94+pAzSz0mGXw5QPtsOjkoODOmNY=;
        b=Kd7xvzEHoFDbK1pW5xrmUWR0eE30YP4BzxQz/pwTr7LC8C6M0soCYBvTSaE5uEsQsT
         JwN142A2Yp9dhmChJ2STjtCW9iA4AhQvXEntP3jqZ+zlxMWkkf+C2Hth2vp29OskjHml
         ckrTlohpQ1f7yYAURkvTRL+piImPsuKA8xggX3DhpU25WC8SJ4wSWLB+CxfUm9TBAOWg
         QkDgCt+FFdHjM6BUMDVMZ897BVpwbmmJJsGxwzeHVyczSEu/9M9uPueX+zTTWPYG/lZa
         9RYCse2y1GkTUomwX3CQR5byTwera4ml0gmKNyQ6Lh2kcYjOZKhPWlTWPMUVOGB1UwHp
         HHJQ==
X-Gm-Message-State: AOJu0Yy1g41txD7lAAA9x1SSYihIfahTdGP8U+Zdau2NYkvT2Dib/oOr
	B9oQa+v/lIwytQQJbFgMtOVFGFykESTjI4x38mfZbHmm9+LjIXhB/PN9y3FQ9ATSIFUfdkipJz8
	lqpA4guwEJ07X9kqcDxtjoy7I5LyaYeQOltebdN5b/2A1Y/IRHIAd
X-Gm-Gg: ASbGncvuaEU8pVyPO252M7hdmS/aNjl1zTOLVEVzGEAPxisf8wbHdW1SERmRqkaJZMX
	IWUf6liXOsCpJZ36WwcGH96e3jzepzKLaQSu9rLWu7/XeqE//dzTuxMB1IzxWeyaLNaoSz9eM0T
	APkWPtDdHRSODAFg09r9CrLXJFBqXXTIA7UNIqyQWCQoU9uw03/ajvf5gxi7V2i0X7LHJYMn/RI
	RsRg9eV7pHTyP0FfDqE8oeoUpKdNG/OxrTURNwNvH+g9un8FOrwEhn32aIVJdNVs7H1yQwZ4wSo
	DuAzBAOmdyvrIs4BLLpW1WwJxvKOUWdWWCfEVAyoa190gm9Rfm9bVZBvtH5+m7TNLp8fdAFQORz
	EejSxYZ0g
X-Received: by 2002:a05:600c:529a:b0:46e:3e25:1626 with SMTP id 5b1f17b1804b1-46fa9aefe15mr33101705e9.19.1759953145621;
        Wed, 08 Oct 2025 12:52:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFMCtqEpQgXh2ZeUUnrUMZuhOCP6i4VisyQMUewSPB0pVRauuNVK/j/FRYcpK2qrZwm7+c6bg==
X-Received: by 2002:a05:600c:529a:b0:46e:3e25:1626 with SMTP id 5b1f17b1804b1-46fa9aefe15mr33101455e9.19.1759953145211;
        Wed, 08 Oct 2025 12:52:25 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8e9719sm31915894f8f.31.2025.10.08.12.52.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Oct 2025 12:52:23 -0700 (PDT)
Message-ID: <1763f0d9-37fc-4c3e-b31b-2cfac33d5c95@redhat.com>
Date: Wed, 8 Oct 2025 21:52:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "mm, hugetlb: remove hugepages_treat_as_movable
 sysctl"
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, corbet@lwn.net, muchun.song@linux.dev,
 osalvador@suse.de, akpm@linux-foundation.org, hannes@cmpxchg.org,
 laoar.shao@gmail.com, brauner@kernel.org, mclapinski@google.com,
 joel.granados@kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
 Michal Hocko <mhocko@suse.com>,
 Alexandru Moise <00moses.alexander00@gmail.com>,
 David Rientjes <rientjes@google.com>
References: <20251007214412.3832340-1-gourry@gourry.net>
 <402170e6-c49f-4d28-a010-eb253fc2f923@redhat.com>
 <aOZyt-7sf5PFCdpb@gourry-fedora-PF4VCD3F>
 <f4d0e176-b1d4-47f0-be76-4bff3dd7339a@redhat.com>
 <aOa0UPnxJVGvqc8S@gourry-fedora-PF4VCD3F>
 <b6d472ba-e6cf-4c96-935d-88c842ab3cd8@redhat.com>
 <aOa_A_i1HUt1wzCj@gourry-fedora-PF4VCD3F>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aOa_A_i1HUt1wzCj@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: R_MnkWkSJAKmagUgev8PFnYFS0oywISl1WuZ5sqgDGw_1759953146
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: tmxnx4gb3atakafo133bjxa7k6jqdhbq
X-Rspam-User: 
X-Rspamd-Queue-Id: F25018000F
X-HE-Tag: 1759953148-353280
X-HE-Meta: U2FsdGVkX1+cESbw+tqGExEYyEuCv3sqVSj6vWq2h12k1tOSOkKORSTk0rHdUsfEB3uvj/VctLHBrXdAZJ/IPgN90iKRe/ou4e6doRdgVlfFQywiZKQQZKkkS6F5EGPmiWM+477GGoFN6QjitVEzHZJCHOrafmVB+ceKLfTmBfayLo74hIwV5eC3k4LYZ9Q3+EnYjO0RXYLO1VQrWd9BJI+sKmcl46CatRaxstvnRb7zM5vdgH43JrlyTKLcym3LKgngO01IEnQcY0iDRUOBSR4PBnye+LE3kA8GEL5Yjsj4dKXTks4Popz0lG79bzTxV2yU2XIAdiK5GDb3/70jmjls2StAA1f0fNH/IwTHvzeAgrBppQVfJMXkB4aFfCQfF+EX/JnMMmIqv1kjXsS/hwKksTPuKeC79U94l1Pa7C86UVH4tuGt363copVoBMz5+LCH7qzxo/3YYR+viB+lPBTqGvKeNJNUmbk1MauXnniwQLK9SJMsvzFoJTiVm80aFSkawqq7Ul8gj/mehQM9E3TgED4zdkx0E1hd4tURUYgkC0f0LJiYufxVmTb7vNxGfGzJFIYjaXsLWfDZvRIc5u5Rsnd9v4Ce0uyxxxt9KUFE6sbLYcyA3rqTYVjLHsXPjYS542Qrzywox7DrR4Zv1g58m3h63ErQyjP7mxJJGkBdAaV6ri6bVcjh9kLUEL8kNVhOZ7TwSt3Rqu/4Qk9q/L3demzpHeQs3LZaQhNbK16DjdP6Vu0MS+jqHSfdm85QbA06en02nrcy9Nx3mCcu8hfzwFfBIV7h32VfkkZOmP2FG2xQ58CWB4TSVSJibkvpeJPR8fLHEE0cD1LUWQ55HS563TT64bhzLF0xJWewRiRsUbWXMi2QJW4nfI8cTED6cyfhejVfHGUzz6yZjXJBDAnwOFost2UG6+NUl1JSyGX9NkAqZzB8MZq6xV1iFV43LnFSh+4NQ1SzmjXXeI7
 3CLuNxul
 PgWskBJJ89hyn3+u/gJxlN1VlthSrLOv3BJqNbzB5b9f/+x2+QxAMa9Pd7avK3ZbUWBtOTgTLZGp8iwo9DymXCzAPOAvEmg06O3e6m2p/0dGCp14Q9ocX1vvQWY3f9u22hOFFrF/90FjnAwe04nf3kGRN42GS6gwpqGpJylli+ryYEzH/M7v6m/8/gPeqAJVfa+T/TVOirpwEdm54tDopIWTqDCFYmss2vbdwo2yHwAN3XiKBnFggYKcQvTA5KKRyO23hLvaOIu0SwpG2SJn/ou19GRxPr5HLPAq/xBKCE4uDt8fGB4TLMnL2Jco2oQtL7lSRrGV+olpqcBKuq1r53hxhZAlLJNsLTFwcSgXCV6viOy4N9mzZ3gjlsPlYIAwTjXry17G6lJQ8apzTK/nA/aSyKwcuZuhVQJgbIjA+NPKgFjvoXoJgr3m/FtPZtQ4sERdXn5byEPLuRd7mjqNn6GTMqxzcg/bMVqZtZ05s67h35CSPpLKPJ5mqjQzewSP5Q0wc147CNU26/ClGrQgRRPIQgSzzVq3sXhs2EdIY/+XLz/OJ367J9fD6lXmIpH5JR3QgzAPFpaqeJDYdcIfHWY31BPM4jZddVzWoFeiAnx25WSnBuKKZxwQFIQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.10.25 21:44, Gregory Price wrote:
> On Wed, Oct 08, 2025 at 09:01:09PM +0200, David Hildenbrand wrote:
>>>
>>> fwiw this works cleanly.  Just dropping this here, but should continue
>>> the zone conversation.  I need to check, but does this actually allow
>>> pinnable allocations?  I thought pinning kicked off migration.
>>
>> Yes, it should because longterm pinning -> unmovable.
>>
> 
> You know i just realized, my test here only works before I allocated 1GB
> pages on both node0 and node1.  If I only allocate 1gb hugetlb on node1,
> then the migrate pages call fails - because there are no 1gb pages
> available there.
> 
> I imagine this would cause hot-unplug/offline to fail since it uses the
> same migration mechanisms.
> 
> Worse I would imagine this would fail for 2MB.
> 
> Seems like the 1GB limitation is arbitrary if 2MB causes the same issue.

Yeah, with hugetlb allocations there are no guarantees either. It's just 
that page compaction / defragmentation makes it much less likely to fail 
in many scenarios.

-- 
Cheers

David / dhildenb


