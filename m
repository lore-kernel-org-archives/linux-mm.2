Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97B39C83F26
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 07:41:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 365B36B007B; Fri, 25 Jul 2025 03:41:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 315DF6B0088; Fri, 25 Jul 2025 03:41:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DD966B0089; Fri, 25 Jul 2025 03:41:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 08C166B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 03:41:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6ED39BA908
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 07:41:51 +0000 (UTC)
X-FDA: 83701992822.26.C96DD44
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 047BCC0003
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 07:41:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZpJVzVF3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753429309; a=rsa-sha256;
	cv=none;
	b=5P9LsgPeSuukMB4b4NrBjsNzWCbpAyAh/zUWg3zjoGbwoy5zmHTTDvmLmIh3PdspMn+iyA
	8uwRr3YHVVEB36DEJp9dLbTvO1ZnnrOVFUPMokprltseomJbPVZwV6pGTJQN25Etc/p9IU
	UKTqDyOJWg5oEA9VCWRP3foTXjH/1ds=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZpJVzVF3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753429309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fojekgEPv9cG6AwX1yoB6wU+2LN4S+SisKL82eDezBY=;
	b=J9a+XEJFjhCIdnuSU5eGNaYp/wLeUE964zW4DKoQUUVtHcoSD2tNuQpXpVym0yA13lVBPv
	8YErwouUum/F/FIQwvAhx2LefZo6oMDJAF9m1ApnTZHcpXlzuj7peMnpPXDP5bi2vLh4k2
	UfDDkMy9lj+EQpvDPxjGqupFOrKGqJg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753429308;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fojekgEPv9cG6AwX1yoB6wU+2LN4S+SisKL82eDezBY=;
	b=ZpJVzVF3S7wwWyt1XpkL935O9hH1IYZnzEE9bdDezWDTWitRxchm8b8Lbls5HW1nQPYt4G
	DIoXi1Hti9jQj5yroURCtGoVQZGWMiXYo8k18eLqL8Hax66EbtiC8sQdgYTchUyUc0Q6cR
	OkJ7lzVxrZtjiA4JjjPjpzz2eaw8F+k=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-695-FfeDFEDfO_Kvk6jHgs_lPA-1; Fri, 25 Jul 2025 03:41:45 -0400
X-MC-Unique: FfeDFEDfO_Kvk6jHgs_lPA-1
X-Mimecast-MFC-AGG-ID: FfeDFEDfO_Kvk6jHgs_lPA_1753429305
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a4f858bc5eso1295810f8f.0
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 00:41:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753429305; x=1754034105;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fojekgEPv9cG6AwX1yoB6wU+2LN4S+SisKL82eDezBY=;
        b=OW2hIOex/7OwzmbHesL+k7omUTTO3KaKFxf0rGnitWsWA4XuOaaFtZR8HoWHTtXJJs
         IgKe0dDO+2yIu73/kHQtWBwinRqkA/n+qK9KhMqgCWVXs70jjU09nzzDxjVux7vu7cVm
         Oyz6S/4R5Ph0q6VqBC4Ce52FhFND3l45crkLZg47cDYEk9UN3HUqw4yrRJFYOZpf07o8
         ZuFq3W+cKCUAyqGht8YhcoWVcERyUeSyVgFp2dE+ZBavZPKQIQhJGs+2SkF3aPxpOG8Z
         +zHWJf4V6eOMf3Co+GDyoCAJ8P0wcmWUY5HfX+6Yr69sHplSY0ohLdUwOwER+JpJhgDA
         22sA==
X-Forwarded-Encrypted: i=1; AJvYcCULdXyQIWB/XlbohllqX6H0aR7q0/g051c6mlgyJG18ANvKyv/o6frxQd5LDJ+HuE5wUP/TPekpcg==@kvack.org
X-Gm-Message-State: AOJu0Yx49gk6Otf374yrQpdXoI72qX0CAn2tD5ja+cPTZ1nEubNrC7fW
	uezY12yE8xBzxKjOciFKjrne3t72IQpPcSXetDEGh09giKiTn69RP1TyyHlc2jbh/9te41FiAKu
	D1b9DE+NoNeYyYtGm+iifmGcR1hUPAsatpisuGhm6vQETHrGi6sjM
X-Gm-Gg: ASbGncs/m0DuTC7IU9xZSVFdGIv21LIiytWVWCUevRq4lpQQQMQpLIV1g35bM8TuRdW
	Nc0GnbK1QqzNgu2rDSrz994556b7FbIk3fcXRChb/eh4dm0mMt5Rie1VQc3cwUKmdrr1wYm6YU8
	11/EjCNpLuSDk2Mqxz9PacWOhKijz6osX3ApVZgCPWdaDLnOllbCd96617xyc/NqvLCK1VRAuoT
	Yxfw9wxx+NZ5KfKEdatHiBzq1rwKEORZpzdE9teQb1/ALpllY5RBt0fVUr2Jd32gj5SpGG+GE05
	Zio40zvmahC0UUvcpdupCnt9w3NGeuRg7g3TPrGAffjD6RbxEO7nsMtRpg+Z/LpfmZx0SfGci1r
	z1cnwTXIzJPRYtGJmugit25GhXWZ9p96+fTKLulWSaq4kCRsvZXCXvOQUEPtSO+rjk0k=
X-Received: by 2002:a05:6000:144d:b0:3a6:f2d7:e22b with SMTP id ffacd0b85a97d-3b7766009c3mr809024f8f.18.1753429304679;
        Fri, 25 Jul 2025 00:41:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEIWm3B6b2z+ebRCjowB14VjtygW8iNzKNHxLAdIdSnF3kZaCH9XvX8UiUDWhVKBpKo+7YJVg==
X-Received: by 2002:a05:6000:144d:b0:3a6:f2d7:e22b with SMTP id ffacd0b85a97d-3b7766009c3mr808995f8f.18.1753429304202;
        Fri, 25 Jul 2025 00:41:44 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1a:f400:5a9f:b1bf:4bb3:99b1? (p200300d82f1af4005a9fb1bf4bb399b1.dip0.t-ipconnect.de. [2003:d8:2f1a:f400:5a9f:b1bf:4bb3:99b1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b76fc6e5e1sm4412643f8f.28.2025.07.25.00.41.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jul 2025 00:41:43 -0700 (PDT)
Message-ID: <d242b6c4-8be4-4294-a399-ead2339f08b1@redhat.com>
Date: Fri, 25 Jul 2025 09:41:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/5] mm/mseal: update madvise() logic
From: David Hildenbrand <david@redhat.com>
To: Kees Cook <kees@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jeff Xu <jeffxu@chromium.org>
References: <cover.1752687069.git.lorenzo.stoakes@oracle.com>
 <ec480dc1fd4ce04bb11c0acac6c6da78dc6f4156.1752687069.git.lorenzo.stoakes@oracle.com>
 <202507241352.22634450C9@keescook>
 <e0a22433-541c-40b0-92bb-34b0596db642@redhat.com>
 <ef111032-e108-4771-9202-b8cdab278422@redhat.com>
 <202507241528.A73E1178@keescook>
 <28bf0b31-8b51-4acd-ae09-890a952501f4@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <28bf0b31-8b51-4acd-ae09-890a952501f4@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OFElnpEpmdqw_k98XeWeOA0DjdYWl4Teq-Zpbpenhy0_1753429305
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 047BCC0003
X-Stat-Signature: xry7jis771p4qd7u4ssk9p1ryhz6xiaf
X-Rspam-User: 
X-HE-Tag: 1753429308-207375
X-HE-Meta: U2FsdGVkX1/ivIMoqWxEj8v7Z2g+V7aBNJ6RsjsAxJxXrFDmH6v2TmOoU2aOA0do8Ba1x6RJRR8v5AqTItqeP5+yB7D7RWtD82ZaaIb9QS229ewPG5mN1faGoDxFvvihM3V+8C2ngF6ygrktF/tDy2o8cQXbD7OV1T0HTXvrnwExmRa2A7KYnLwPlnY8dSrZcz6pPg+/5L0NoeQB2Sx0lXlkfW3F5L4EC4g2HrXRan8jyHbT8NPXxNTDdW5t4kvBSW9SEfl6+ArdT5Y6/YCiMIaQowpyOfo+fX/ggPu4lgXThGFHOSEiHONUuC3G0M8QaBKkMvCRA5z3GcJZSro21hGubK28/tQXr0/scoadDpze6vokPl14zSx3JEktUzkmAac6q4xVX0iEm+sMW0+Plt0uMiGU7rdOew0wES2zn/FBSM3XQ9TnXSNp8/+FL/tAcAdQpmGWkhIAc7vK2DIZ2gys2QEqv/5CRjXr8F0omGAbaanI7Q7iZJFau8vqhAYYWQsbUMAPrPK9DpeocCmM/VQACFMjtJHTTNvnjcPqa+LdZ4MG1SLIy6MhmeTXSINHc2Q6D2XVha4VtqqKOh+xwYANHNOhE+djxsW9DrRj9edzoj8UIk4VLPSPGXnZLBIelVz3zVKNaCLDbFfiazrTk1TXPO58aq9TRpzur02mY3tVw5yl5WZMQnVsMNM/wCEmqHIDFKHbzkEOCr95Rppm05tCqk5tec2j1D1UZ1iV66hj+V21zVaddrz1rPolhJAzDU9OS5GzKq7avqC3qDxYInhGjMNnSClsD+7BTAFc6z4xvH+VGiVEEDAIaQ41vqamsZIaEaEUBhUdtrsXKXXshgvL4H0h7pu3rxb1wC/GnRQwMGkd8u9NruP5FlybXJfPiJ+t7m2q7O54exswZStRj/oS5iFXv4BjTB+v6VnEJNW/dQYxszjzPI0PQ/KoAQic3lPCGnpyeCu/sJZ/8Hj
 VgiMmirS
 lM/4MFR9t/nEp1QmcdV9iRrW/OJVqpLsRgGFnlAJCdHt19TpTQ1EMFkhao9qP4w+FtKv56CoD5b55IEX2zeZhD/3ZiYgznk2dBvXDLdUlxzVJsi6OXtj7ziPHxrlV6fjh8F0rHgD/23Ur3JpZ2sXtqRt37FuAPehdnEWD4w4nH/tSDBA9zSjt/wawf1m1goIdQPsRtO+IhVLQxJHN7Dplc0fjDFIcUGVwS5MH3i0IfYhE6sHj1FR42tzr2VonYAsj8jtTcrXdonst/gEylMdCea3iyauBaTmy5YEir9MumXQT139aOm2l1j3WTk+N0WUUro6q10Ktm7m9Lr788ICr1h/haKvfcCTet2lw9qI1pBSI0M1zDuv8bqRKrprXuykhGjCOhg0MSa/EB+UQkJtAN4om/5BjvXX5RqdCr9pXlMHpx4tx4eIRC+dNF47WWdYH1+vUNxZgSFXX9xXEER0g8B3IdQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.07.25 00:47, David Hildenbrand wrote:
> On 25.07.25 00:29, Kees Cook wrote:
>> On Thu, Jul 24, 2025 at 11:41:04PM +0200, David Hildenbrand wrote:
>>> On 24.07.25 23:32, David Hildenbrand wrote:
>>>>> As an aside, why should discard work in this case even without step 4?
>>>>> Wouldn't setting "read-only" imply you don't want the memory to change
>>>>> out from under you? I guess I'm not clear on the semantics: how do memory
>>>>> protection bits map to madvise actions like this?
>>>>
>>>> They generally don't affect MADV_DONTNEED behavior. The only documented
>>>> (man page) reason for EPERM in the man page is related to MADV_HWPOISON.
>>>>
>>>
>>> (Exception: MADV_POPULATE_READ/MADV_POPULATE_WRITE requires corresponding
>>> permissions)
>>
>> Shouldn't an MADV action that changes memory contents require the W bit
>> though?
> 

Pondering about this some more, at least MADV_DONTNEED is mostly a 
cheaper way of doing mmap(MAP_FIXED): in other word, zap everything but 
leave the original mapping unchanged.

So if you allow for mmap(MAP_FIXED) -- ignore any permissions bits, of 
course -- nothing really wrong about allowing MADV_DONTNEED.

With mseal(), it got all weird I am afraid, because we have this 
exception list, and apparently, it has holes. :(

-- 
Cheers,

David / dhildenb


