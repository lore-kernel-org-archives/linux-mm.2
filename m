Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F0ADCCF9EB
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 18:21:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60300801A9; Tue, 28 Oct 2025 14:17:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DA8880199; Tue, 28 Oct 2025 14:17:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A20F801A9; Tue, 28 Oct 2025 14:17:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 38DD380199
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:17:26 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E7E6012AA26
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 18:17:25 +0000 (UTC)
X-FDA: 84048330450.03.A1B47C5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 52A2E100015
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 18:17:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QPQSAgtF;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761675443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ySxbOqqI4HJUHGwdFmdvZDlaPAKPqm3FO8qJrHqBgvw=;
	b=RtEH12H/GKJfVmpK/pmW5wQLjB1Svt2hHXXJuej3n+oea6tBusd/A3BGkmXttlbmssajs/
	ubEd6x5Ek9XN8yS4vmtnUqGmG03JM59ffu7/GAzMMQjrHqdD2qs4w4+i+Yt6j7Fvx0nAmV
	4WXwYg6HjTAskxjxFHIhFFlfLTM0Uus=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QPQSAgtF;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761675443; a=rsa-sha256;
	cv=none;
	b=CpYSECiIdIU1cPUnGpylhrGuzyMLVW5iZflls5nJkGUiQ631hPc7yFpmQY3p13u5vYaeBG
	7UmFbTqyqepIAXPDQNBzoc9A/3Oihs0OXTyqzxc9AfARcH8Mg3ppVk3N89oCaE1rJk8mXX
	E3YhtD46dhaM55OzImatp/jxTyY1j4o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761675442;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ySxbOqqI4HJUHGwdFmdvZDlaPAKPqm3FO8qJrHqBgvw=;
	b=QPQSAgtFMLm02QBO4ywbDkzw/q724XKsWmbkB/EXLwHJ9jFtSDLv3ExqaAu74QSAqpA8bZ
	P8CniJ636Wvbi28JQgk7LGkIEZz99pNrVxJWIpagso2KoTdfAsjmfcsNw9+cQLb03iKt/S
	H8T0DvuDouZJXoh2LOBdajXaKNk8MBw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-197-FbGXf01oO6ak-rXqUuY7PA-1; Tue, 28 Oct 2025 14:17:20 -0400
X-MC-Unique: FbGXf01oO6ak-rXqUuY7PA-1
X-Mimecast-MFC-AGG-ID: FbGXf01oO6ak-rXqUuY7PA_1761675439
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-47111dc7c5dso908955e9.0
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 11:17:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761675439; x=1762280239;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ySxbOqqI4HJUHGwdFmdvZDlaPAKPqm3FO8qJrHqBgvw=;
        b=MASUN1fTYJ1EC9HI4uj6DmY4qQgv+BXZW7p+rAayqJfalrWxGru2dFzwKSFCmoOlLe
         fy4T2zGXfOZn1Ygp6Ai7xTB0/agRYd/j4D3Biw9E9OC5q2CL2TmEyTS9iZold75oNnbY
         5OI9goXvjkppVE41JS5gL/u9HUiqHOFmzSgG/l8WfwQf6GUANLpMpIc0an42M5rVbXSf
         ee3H13nmB1vfGOWl84qCPxURTaoAbl7+sKnejGEvMAIHbMLXtNxaq/cpKSbUzSMmTfaC
         of9oAkLsHmX+mNeQ6jUViPSgi5jBjSUKDOZS8yobsWODAKKCWS9vkDSTzKqlRkg4g1t3
         6meA==
X-Forwarded-Encrypted: i=1; AJvYcCWVruhS0fwtiUeA4YwuQJMSuJeb6L+lRdSuFhx/1Hb45vijdcJErBaWn+YLKf4xtJi820c/hT3EUA==@kvack.org
X-Gm-Message-State: AOJu0YwTQHPtVX6g4fDcciT9h1OipsxD9f80pf8wOM/Cw0xKcuBpB0S9
	IY9SjxdnsAqASYDzcA4fzdWw6MscGqQQ93LHd1iJbLCUPm3mEKCqFtWgUOrJa4lr8k+qUEnSxlN
	8Eiel2g7wuynAwOaB0bS+9V4rS16Rw8cj5zvekM4gBjakpEwDvCJZ
X-Gm-Gg: ASbGnctvz1s5X6kPJOm0Rk5ZBp8EGeV+UKL/IzDHSEZibbyovgrnqj85dluOh0tDMAS
	YsuBoJz+jsOPfGYC7MCjSIp8nKJDDaOlREQVZLJlCIVTkqpYl9oJ3k6blJfOM6SrcGjgGzNmkMm
	utQ7BEBo3pYgczanvLkTFBwR/h751g0CNU6tEPE67HQRpRLaE1sCxQ3tY5l7wKFnY9ZgWgG4yhQ
	nDUfVJBBzrnuNDgXfNPE18cccZMxHc0mcxblwFyPpQ4FopgexWva016yHqKcspbxmi+Yzsmq/xO
	CKT4HRwhaEUIQuEN6MytOr7Wqje876e3pbRYd1DMY/HMRIPRIr3Q6QIlGyRoxSEexqNWRADyRvy
	twR5jLed6wh4lrUAC6h8W0V4oFL9GcssquRVjyhg=
X-Received: by 2002:a05:600c:8418:b0:46f:a2ba:581f with SMTP id 5b1f17b1804b1-4771e68adc4mr1427265e9.16.1761675439205;
        Tue, 28 Oct 2025 11:17:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEh9w3CR7oqv8SD+DpRc304K1YwGmWnUOlNNN0GFBUn5BuV/oHlq0iG3kt+3RHe9DOoKNgvDg==
X-Received: by 2002:a05:600c:8418:b0:46f:a2ba:581f with SMTP id 5b1f17b1804b1-4771e68adc4mr1427045e9.16.1761675438722;
        Tue, 28 Oct 2025 11:17:18 -0700 (PDT)
Received: from [192.168.200.155] (host-80-81-2-50.customer.m-online.net. [80.81.2.50])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4771e18bd92sm5763515e9.2.2025.10.28.11.17.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Oct 2025 11:17:18 -0700 (PDT)
Message-ID: <dc002ef9-53ee-4466-b963-baadfd5162b7@redhat.com>
Date: Tue, 28 Oct 2025 19:17:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 mm-new 06/15] khugepaged: introduce
 collapse_max_ptes_none helper function
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, ziy@nvidia.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org,
 peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
 sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 pfalcato@suse.de
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-7-npache@redhat.com>
 <5f8c69c1-d07b-4957-b671-b37fccf729f1@lucifer.local>
 <063f8369-96c7-4345-ab28-7265ed7214cb@linux.alibaba.com>
 <9a3f2d8d-abd1-488c-8550-21cd12efff3e@lucifer.local>
 <e2a89e74-1533-4a83-8d0f-3f4821750e25@redhat.com>
 <64b9a6cd-d2e4-4142-bf41-abe80bf1f61a@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <64b9a6cd-d2e4-4142-bf41-abe80bf1f61a@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: B1DbEzdXwSuNQSev7qLSObraHSRRnQGff3pzh12ayEk_1761675439
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 52A2E100015
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: equzwjii8fttaq4tphpfjsqmzmbz5gnb
X-HE-Tag: 1761675443-396026
X-HE-Meta: U2FsdGVkX193rHl6086rjV6rJMjS7hIlJ1m3vx34p/slNguFPcQ7yAmX3mdVa0piM9DrvFH1P91GuWZVxZUWA7B9rEJ52zeFT1CglZVboVFNavMbGYWAKEaLOftNJyuFhhbi7B0Vn6a9K4l9o7HoFYq61HLqudTtLkazrfRdrIQPZaCJ6jrx00pv1bHjD0ipxdUOW0+DAhKx5tBAtwB+56eVXufOhy754ZjQ61eXi0ds4QuEMtedugSayymG/RpLtyR6bJoaAIiZbgcMnRnTjtyKyTT83dpxWzxWEnfElkwZWzbht0HQR9uswOLMuj8f2LOVx7gtepArLmE53SehJ1n/vfJ7TqeY0S3SRPMPL5sglgbbi1MWga6EpQLJOdVmZ23Nd3Pq0P4xAh8U6Bhatm95dyhYo6p9SttGwpTV2QLBIYO4U3r1m9ikfvtiYshLfT0aXDBBG8R6k3l8jT5KHhrz69RKJhW9CtUiW0qlq5ypzDdTJiAz46qVoCaxSuPKeit6yfH5oOtOjoPYlA9LFomApIQsJ4XEJlsqIXPVndGNJgKThSe5Z7OOWSoSuaEqKVLpXJob+kdhAGOnur9JhWavVIX1ceZSp8Hs79jaNkeh75SiB0vPUGDf/WXUUhysSF5XTBTjHK1agz5Krsw9EeSJmRjKTrk1ttWyw7wkhjKD6QiQa5njGXAagNptlCIcaJKV5GO8ILlQcJc9oM3AmeSsOHlqLFDfePuY97IusuWY5QT9Ywn7BY7jSXnnYG04uVbd9b18xyzc2oN+n41C7EwAnb9yRfKrs3OVmQO9EfySEAUhmtgRoSe1cLncKkJEJ7M2sO41mRHNQfJibIlMGPOYeFM/kYAKWyzXfZ/8B3w8pDB2p2g96qNh+ZJZBMz7OpCmDpks9gfDTUlzdyaxdMg38zXWWK51gVBAcbNEBy/9sDCpC0rFp+7SnwmSv/DyL0+IGk9KQm/l50zcBnR
 cJqNXqwl
 0CwAL41+PjHYaulzIEw2EOkYtq1MH/gmcpGOG/HdPqaDDjI0HFpvmUlv8KyHbn5ZXFvhAcC0w/UAiZyqEUebt0Eab2qKoOWiJGbZ2x2ij0JTR+XPb0EfhNKCDOzEWb1fxczG9LNt6x82JIzW/IxTatw370PAD3/Q5T/Ll4pEYmZw+qaS6qMDezNM1QIYCLBo1YTnqPTG21hBBo5o4twkFY5KQKP1IqhZDiiK17hiOZOiQNcHSIZAdwoTXO2XjU1/78xPu6CDWZkzI3xaNwrutxSOjypZMGtbnqj0nf7JA6NIIeWff6Ic93puGpDIzIxkkJcCM6iZGf4iWJIbbmRx1+auSk22KmdwY1FP9xFgM1lsN04dBZUIL29r26qk/Wz3Vs5Mvfi3mmJfQOh6jRiCxhanA0iSdb/YDd1135hoYNLyvCLTNn5Vce+JTq4mYDI962r/3/A1dfRfjnaSpPBB1LA/jq6ldhSPqLdmM1I1pQDiheu5vardSaxaw2LwGP9UXb36H/fzQ2fWzQFlWa7wLa/CxyK7g6ibMCUKOW4VvfF1JyTRjku9cswYc+1uCo0tP92YBaSTjcmteRoNAkiRIwfKhEkp2QVfY0k4ozHaCjOfC8G1EJ68qGCcvhQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.10.25 19:09, Lorenzo Stoakes wrote:
> (It'd be good if we could keep all the 'solutions' in one thread as I made a
> detailed reply there and now all that will get lost across two threads but
> *sigh* never mind. Insert rant about email development here.)

Yeah, I focused in my other mails on things to avoid creep while 
allowing for mTHP collapse.

> 
> On Tue, Oct 28, 2025 at 06:56:10PM +0100, David Hildenbrand wrote:
>> [...]
>>
>>>
>>>> towards David's earlier simplified approach:
>>>> 	max_ptes_none == 511 -> collapse mTHP always
>>>> 	max_ptes_none != 511 -> collapse mTHP only if all PTEs are non-none/zero
>>>
>>> Pretty sure David's suggestion was that max_ptes_none would literally get set to
>>> 511 if you specified 511, or 0 if you specified anything else.
>>
>> We had multiple incarnations of this approach, but the first one really was:
>>
>> max_ptes_none == 511 -> collapse mTHP always
> 
> But won't 511 mean we just 'creep' to maximum collapse again? Does that solve
> anything?

No creep, because you'll always collapse.

Creep only happens if you wouldn't collapse a PMD without prior mTHP 
collapse, but suddenly would in the same scenario simply because you had 
prior mTHP collapse.

At least that's my understanding.

> 
>> max_ptes_none == 0 -> collapse mTHP only if all non-none/zero
>>
>> And for the intermediate values
>>
>> (1) pr_warn() when mTHPs are enabled, stating that mTHP collapse is not
>> supported yet with other values
> 
> It feels a bit much to issue a kernel warning every time somebody twiddles that
> value, and it's kind of against user expectation a bit.

pr_warn_once() is what I meant.

> 
> But maybe it's the least worst way of communicating things. It's still
> absolutely gross.
> 
>> (2) treat it like max_ptes_none == 0 or (maybe better?) just disable mTHP
>> collapse
> 
> Yeah disabling mTHP collapse for these values seems sane, but it also seems that
> we should be capping for this to work correctly no?

I didn't get the interaction with capping, can you elaborate?

> 
> Also I think all this probably violates requirements of users who want to have
> different behaviour for mTHP and PMD THP.
> 
> The default is 511 so we're in creep territory even with the damn default :)

I don't think so, but maybe I am wrong.


-- 
Cheers

David / dhildenb


