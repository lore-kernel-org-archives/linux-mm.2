Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B75C8CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 12:16:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21C9A8E0017; Mon, 15 Sep 2025 08:16:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F3E68E0001; Mon, 15 Sep 2025 08:16:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E3778E0017; Mon, 15 Sep 2025 08:16:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F08178E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:16:52 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B381413B4EB
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:16:52 +0000 (UTC)
X-FDA: 83891383464.06.2F1CA1A
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf28.hostedemail.com (Postfix) with ESMTP id A67F9C000F
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:16:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kmHiRGx2;
	spf=pass (imf28.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757938610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hkh90FvShjKuQpnhzVfehnVtCnrky/4Hn2fBZ8wL670=;
	b=fUJXfOVOrNIUhkvzKsVvjyKm0suKlGw1f/7oL94p6ODZVHZdu6yH/xkW71KMnxcyTxsyMG
	E2l/Z+D7gwpYzQib26TLtIEhgQgD4leA9aHY6nBfcoWKmElfCWxF5sxY8qwcXemVMFoTgn
	fj93OX3I4ruRELuAEEIdW19cCuBa2po=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757938610; a=rsa-sha256;
	cv=none;
	b=MoM8oFwRFWnOu/15UrjTBl2K2ZU/JSAEgLq5p6gsYxdYo0e5AY0hUrwcTtUsqcAM1CPEyZ
	sHrSyAnrsEDV09aHSjuiCh4hnnhinqU+hBbqtDe+4kMj9tUNi/0lYkhy6DMGTrLp0wx5+M
	hTZ358Mu65toZDdH+vEzrR87EaveAvE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kmHiRGx2;
	spf=pass (imf28.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45de56a042dso26988615e9.3
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 05:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757938609; x=1758543409; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hkh90FvShjKuQpnhzVfehnVtCnrky/4Hn2fBZ8wL670=;
        b=kmHiRGx2hS+bzdqk9Fm18wXBVrxCJwd4LFQXJe91ZhPKQIcx9iENztrQxUjTxRLGmN
         Rc8HiryjGzQezte1ng6KbKFMf+wudCCLCcrXpJajIkiUWL7tObDNiaHDkpnmocfoCo1E
         WfbMNSe1tGu2DgiDC+lCERomvqhu6JwmKQ7ysSm3oWpRFAgbTVx48nDpxlsNUFrDDXSv
         mVGEs9BMFhTWsTC1AgJ+rOQhNxk1NsKLEeYx27ppffF4axufmc0Z1NRFZWOTYDzSWwxu
         SaW9FUyCD+1QnWFqomVJPluNfQ4NdyYl5RfT/2IG8QFx95yVGzyt3uVH5Ia607pry3W5
         70xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757938609; x=1758543409;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hkh90FvShjKuQpnhzVfehnVtCnrky/4Hn2fBZ8wL670=;
        b=I/DvJnkZ2LZWWWgpJs963Hu0/X1INd9b/Yt0ywZsWdzAF7WOiPYJpyHBc8X8k0cL7U
         GV2bVpdiofBO1VI1mBHDE+qMvGTaFFY1XOJiPN6NYs3Q6KBGriZZXIZxSiZyl3JolWq8
         CdAcfEvQmSpryHF1PN6fwTLasTKxG2M5LegrPFi7OZj5mqyjuwY4O4bLGGSoHo6FfNVW
         CtcNSZ9ZzNRSSeGk2N7oaXTWIKsmrGTeVW/BsfJqWmoV7jU3/JQ2JofC6sQffqlct+kG
         O69iJeOIcnWm6B2EALiA7aq1fZB5lS//35Xszr9Gs5oE+uMaxkwN/7B2pvxe8Sa9udmT
         SVzw==
X-Forwarded-Encrypted: i=1; AJvYcCWf6bC/B8PN5KbN3UoNMBywAiPTRK9JjknvAKY57pJs30KqP+dCJGuQ8NGePdH8LnYnsYs5bSomSw==@kvack.org
X-Gm-Message-State: AOJu0YxO+qLqiu4Em+84hW8tgpGwcNNnDVoPTAlhyvxRwqvP0rTt9NUl
	Y/bAgYvrlX0SBrUJiGLPrwSK5cMQ8R47H8p0TYO06UW0lAEguRCHtzbb
X-Gm-Gg: ASbGncv1MWjxaJhET3ZVUyHT8Uv1keA6lUakSXEMkDPa6754Oy5Z0UX63xukrZH7Xr4
	yp4bD1nzfz778y/T9Cl6bZsXgX/6cKuSRCV4BlENlIke1rzX9uhQe3itZ1DFrGjIoF1EQv/SK4K
	KjboAZVXTWvzirsOlf+WrOWse7jFtQkHTKU/erQX8kuGxz9b9GpLd5iNb+z1P8gYUY1/mKTTqgl
	PVuS7NgZvnlOr84wVUo7oCScgVCe2qvjuyl9e92rqesgKJh4ZKbQrdbG5tKImH3KOJG/OmKS1Qe
	d2XJ2sH3S02tuIFRO8jocMyxHeCiHtFjOqEki6yRrj1/BKBClXlIzAquTVKcpUdUaH2Kct8q/T4
	mf1AerVRTZcyUqK6j2kRO6oAjeAZY3Vb4kcvcZG12ymRW35o2n+i44IgHJKYx6WlR80UGqyEY6q
	CeJ4MRCw==
X-Google-Smtp-Source: AGHT+IHLdvnlzkDOd7uXK6UlLVGn66En8B0SEaqf+MBMTOLNt+IzT6bYlms/O5Yrrl4aVtgHa35tlA==
X-Received: by 2002:a05:600c:4691:b0:45f:28d5:fae with SMTP id 5b1f17b1804b1-45f28d511f7mr65042655e9.4.1757938608737;
        Mon, 15 Sep 2025 05:16:48 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:1449:d619:96c0:8e08? ([2620:10d:c092:500::5:94b0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e037d62besm173987755e9.21.2025.09.15.05.16.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 05:16:48 -0700 (PDT)
Message-ID: <f34dbfd0-2291-4a19-bbd8-b61fe7754e55@gmail.com>
Date: Mon, 15 Sep 2025 13:16:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
Content-Language: en-GB
To: David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Kiryl Shutsemau <kas@kernel.org>, Nico Pache <npache@redhat.com>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org,
 peterx@redhat.com, wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
 vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com,
 yang@os.amperecomputing.com, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 pfalcato@suse.de
References: <ppzgohmkll7dbf2aiwhw7f4spf6kxjtwwe3djkx26pwy4ekrnd@mgeantq5sn2z>
 <d0e81c75-ad63-4e37-9948-3ae89bc94334@redhat.com>
 <CAA1CXcA+pb5KvEnJJqdf1eSjaFiBZ82MRB+KDmyhj3DbiQqOxg@mail.gmail.com>
 <enrgrocqajwu5d3x34voghja7pbvau45oobxgabawrly44ld4u@ahch3xn6rtq5>
 <cd8e7f1c-a563-4ae9-a0fb-b0d04a4c35b4@redhat.com>
 <2c5328ee-fb6e-45cf-a151-868cc8e7ff97@lucifer.local>
 <4508810d-7645-4f57-a0c5-2ee9f44206fc@lucifer.local>
 <34754ca4-fced-4a3c-8ff8-c00967d487de@redhat.com>
 <92352257-5be4-4aaa-b97f-c4e879ac6959@lucifer.local>
 <de3f5502-ef81-4f44-96a9-995e512301a3@redhat.com>
 <5099d9fe-4a07-4acd-95c8-782ffc74df37@lucifer.local>
 <1312fa3e-88dd-490a-9e07-9749c625933b@redhat.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <1312fa3e-88dd-490a-9e07-9749c625933b@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ciacqeihm5arrbkpph1ewueobtzh34jy
X-Rspamd-Queue-Id: A67F9C000F
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757938610-657766
X-HE-Meta: U2FsdGVkX19Qtw+LCGQE7awYNrp8DwD31JAGtX9sN7E9Vdx/kirV9nTUEDB7DbDXp+Q3r+SK0GA9dml+wKXJ+cqDbbFC1+BHCM4nyqjo37rvzZsEBHDKe2ZwF1B1lFbQFAo528pY9Y8UqK3yyUJDtRgpvLGlF4Rsy8pAM/4dLay/J6OXr8+8lxid5ujVfl34Ft8S1NjNc+FCqHJSaBrc2tziqUFKXKkORwAJwVLPutmciBCEmE3JKff5ve0pp7fX5ANdmrol3LSank3JvgDe7qv7qXsQkuo3Qxpbt88o1renf2sYEUqrZyDVvpMg44xYi0Gz807zoxWLECW+o/HRumymiLb4c87bbtEP5R6k+LotewNALUy7chQ5yAkJSsRY8QrbbMsMPCpurxoKDe3UGwPS2WTHHMszm9yyKzWYUQJl2BHG3sfGesmbTV7PuKpzi5xhzTBJGargH99wCmCotQTAJeYF0ItL/y64yJcwQ5hgMwlja5HxmP+s7DkXCGVE2j3m8oNH6YA/1IA2TtcPu+zDiZB1lZc8+qicqi0mO85N82jJFcPnvOjs7FCpADhQPQY+SkAp8YoCCeUlthB6N1+YUDNQ28YyNeQGfxeMaP1a6WAv5RSY/R48B9Xk8+AkNTEJrQ4iUqyaaj7bDwrWo4AqJGqV6PgzdWspQOa4cpfhH20apvyWU7skTVo6tfiWWR4s6w848hLGIMBh3oVGjTuSAj7BnYo3HaasRGruweTC5+2ne3dasmQdQdvnLINVgd8fGNKt3rqx3/+bBPYhVc1eSgGlq1Z+GrGkQgYxGgORIzlT3aj/abIbR+WtvwJuPENKc9+DrS+/OysgxmxYhWPFbTYv20aRPzSl+UsWQ8Ibt+q2KQGS7ZylfcgFmQA0jsGbn4Hzcy48sdi0Hjyva+VQHvz0JPAacUirdsU0JH7l3jUbP5IkPQm2pv2oaZc551EYRG3nbE6Lj8W8BxN
 N5JuRHsB
 x+sWXzHjwySOuaVKKOaEdKnRFhKTfkruyTKUe98kYn8dA+B3+VGEXUzSmojdUisrIcQRqWumxKB1mLKL/zloMK/GRA2Pk7H45/LjjIZP5ROYiK/XwN9drYisNGqOpBMYQXixP+eLwxAtvOkod8y+KMVzDPNKik9opBHtGOaISLf+6zZ7AKhjmk92HqCDlDTDxqiVQ4Cr60thbdtURrCxcQ012mT2seuysuUlUlJYcwau9JBrRjYQDCsEiPT1cDuNFKkUKDySnoewiYLGeWeWM9kTQDvPKQ8SEAuX2NpwxLbxQfura/+bHv/smmg+RKdK58rEiK3pImmkkOf39yHKroTJaf6/vmFDKMQiJ19nXONI4JO35NMvrPUas/UjDLEIPiui2ZFynIHh08wCK+V0yHOD4OnToKXEVITrO2y7EJrH8PjfxynHS5VhlaGOsd2cpvhAiFJzGj4LK3ADv5jj2syiLvl0HB23NpBFCMSMrcJrf8Qo+WkLt7Gy+Ty+EXZUkxTTdbSh/i3YMMKWl1qRq9FABc5kAlfkTj1nuMUxcIHXymBTSvCzZ0sSajnuTrd6weJwS2KxkeT4vVZM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 15/09/2025 12:10, David Hildenbrand wrote:
> On 15.09.25 12:59, Lorenzo Stoakes wrote:
>> On Mon, Sep 15, 2025 at 12:52:53PM +0200, David Hildenbrand wrote:
>>> On 15.09.25 12:48, Lorenzo Stoakes wrote:
>>>> On Mon, Sep 15, 2025 at 12:44:34PM +0200, David Hildenbrand wrote:
>>>>>>>> Mapping that to actual THP sizes (#pages in a thp) on an arch will be easy.
>>>>>>>
>>>>>>> And at different mTHP levels too right?
>>>>>>>
>>>>>>
>>>>>> Another point here, since we have to keep:
>>>>>>
>>>>>> /sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none
>>>>>>
>>>>>> Around, and users will try to set values there, presumably we will now add:
>>>>>>
>>>>>> /sys/kernel/mm/transparent_hugepage/khugepaged/eagerness
>>>>>>
>>>>>> How will we map <-> the two tunables?
>>>>>
>>>>> Well, the easy case if someone updates eagerness, then we simply et it to
>>>>> whatever magic value we compute and document.
>>>>>
>>>>> The other direction is more problematic, likely we'll simply warn and do
>>>>> something reasonable (map it to whatever eagerness scale is closest or
>>>>> simply indicate it as "-1" -- user intervened or sth like that)
>>>>
>>>> I don't love the idea of a -1 situation, as that's going to create some
>>>> confusion.
>>>
>>> swapiness also has a "max" parameter, so we could just say "override" /"
>>> disabled" / whatever?
>>
>> I don't love the user being able to override this though, let's just nuke their
>> ability to set this pleeeease.

Do you mean stop people from changing max_ptes_none? I am not sure if thats a good idea,
Its existed for a very long time and even a few release warnings might not be enough
of a warning for sysadmins that might not have a kernel team to notice this.

If the eagerness solution is just a logarithmic mapping of max_ptes_none at the start, I do
think we need to keep max_ptes_none completely supported. As eagerness isnt really doing
something new? Once eagnerness diverges from just setting max_ptes_none, only then
we should start thinking about deprecating it?


>>
>> Because if they can override it, then we have to do some deeply nasty scaling
>> for mTHP again.
> 
> There are ways to have it working internally, just using a different "scale" instead of the 100 -> 50 -> 25 etc.
> 
> I am afraid we cannot change the parameter to ignore other values because of the interaction with the shrinker that easily .... we might be able to detracted at wait a bunch of kernel releases probably.
> 


