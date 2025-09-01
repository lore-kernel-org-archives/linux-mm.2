Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4983ECA1002
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 10:40:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81B2A8E000C; Mon,  1 Sep 2025 06:40:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F2A98E000B; Mon,  1 Sep 2025 06:40:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 708878E000C; Mon,  1 Sep 2025 06:40:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5FDFA8E000B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:40:12 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0E8AD1407C9
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:40:12 +0000 (UTC)
X-FDA: 83840336664.11.C493DF9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 98970C000A
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:40:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aeCcPY1W;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756723209; a=rsa-sha256;
	cv=none;
	b=Pj6Nd+y3RZgBJlApk5EGAQX6PbwtmL9kmCScPlcOI5RoL81H3sB1ibAXJJGZk7okUFHT0c
	EBKalsFwmXeMsopAaQM9zWfEuAR8L/IH1CBGzZUVJ5iQgIozdHpLV3i4MT8VtI+dGElFy1
	CHp6QxBeF1qFadNrJ4zc4cVQA4JqjEk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aeCcPY1W;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756723209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r4m3vkGAYmIbkGKlu6FXQj2biba1IEBlC5jQB6CtCVg=;
	b=19jTQsngCvvAwZaPshwCsxkyIuAa+ZolqlTLxH6PQHfgTmmIg5ftM5E4hG9j320HJEJkKi
	n2Ah4E1uO95qweKmNq+khlJnchJ5Fsr4TyIezaNTUO5Tfm0pHOMxyhL/jyiGrByDwmFsAZ
	iVDp8VR2hTiZ7FfJ9rF/FcOcO6wm0wU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756723208;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=r4m3vkGAYmIbkGKlu6FXQj2biba1IEBlC5jQB6CtCVg=;
	b=aeCcPY1WhRsjoN3TaIBgopbgdk32qzX9LadE6UKqPS+s9+7FPDqeN2jdWWre5ZXiKaJHiO
	X50lLX2EChwxwdlJdOkAsfgTfcq4Os0gL/sVx6rXr2ZO1x0dmBoQ9D8SpQqDhNfpHQJuZK
	5cRjdyGLLEQXw7rFOWOjahP8M7bTZPQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-396-9zBVxIGOP6-cFz-BX-SQHA-1; Mon, 01 Sep 2025 06:40:07 -0400
X-MC-Unique: 9zBVxIGOP6-cFz-BX-SQHA-1
X-Mimecast-MFC-AGG-ID: 9zBVxIGOP6-cFz-BX-SQHA_1756723205
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b87bc6869so10938305e9.3
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 03:40:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756723205; x=1757328005;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r4m3vkGAYmIbkGKlu6FXQj2biba1IEBlC5jQB6CtCVg=;
        b=W7W/BUnlo1HO7uqMr2ark29vn9rfudvWbe5lNLNX6CdMr7tdp6cpGuIgjD4ESgKcND
         sSREzEem1usoPnJe/d32JTB3lG2QMOhg5+v8WFv5L422ffo00rMfIJaVj0w/yMR/9bkt
         unm/pz25eaD53lDN2tnuXQMT2KImlfog4KQQVgEdj39/Kia6XVEIzzUWtvPYF4OpaANg
         HQRNSbtOC2eH2ozo2KGCwwbVeREx5M6v3HB6tF17oMG4j0lAS6/R4WmP5xoOEcthn2cC
         iGCH6bG0rnoymuzjGdW8hqoHQxy4z0GFz/PZNMmnXv76iwZKW79L4tz9OCwE0hIJgFqb
         OsIQ==
X-Forwarded-Encrypted: i=1; AJvYcCV9ULGqC9g4MkrVdJ+Q/VCh+dG3yaEhuftFVdI9YdkcRr+nGyXYohR5AX1GCXkjiiQTyiyh5Klx2A==@kvack.org
X-Gm-Message-State: AOJu0Yx/5KFprHs7HzJV9vTlE063Rf91LwbXlgtlQpKV9j6/jxthwcMx
	GdJUFDOAcIWlO8NsgAOY0UPKETM3bFORmjQgYLLH8srPkoZ/qfsJyU4jgrT45eGrVzYqhKrLRhy
	zdyFc1daLk9GHkRaPe+IpEjeHTEjVSWNSaeWpcwp2pPBNy/WEH6BH
X-Gm-Gg: ASbGncsYmo0f9/ciIlivrV09r2/O0RE8VNuvDqmyVmbnUGiy1fztLNRlhvzZnFfOECu
	MTRVrlcgXiDxoN+z3mM36R94Q1eAXTOCdLqteXMKbex7xcx6G8vlEOWK+QrtS23waifDWKoHMxg
	fAA9CCL5dpKIz4KQ1qI3tWFxajRtBgBNaRjEgoDwXUbiIEpOrAD3binTBW0Hm3Wkkqz9/hyWEcU
	9EkPDhXxmrIG85F7W+ZkiXw+TMCugSVUP4Mk7zrZoKkoELp5MZYNE4ElvsbA4ni250mzabBD8m3
	W/dSqHBpRf7/5j3dG9BhrH7pi88XUssqDL2px17TZyAvFwE/47BDD0MMckUc5Of4enQhteJgIAH
	OhVidwGYZ+HA+i/9Nmmnr62MVsHsnmlYXAQfOfQ/fUNRiyV9Bml7eAi3LpGJAIs5RmC8=
X-Received: by 2002:a05:6000:2586:b0:3cd:c10d:3b6b with SMTP id ffacd0b85a97d-3d1de4b9891mr5454176f8f.27.1756723205304;
        Mon, 01 Sep 2025 03:40:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHeWUI2bNAllxhVdaZfkjclHGCtCO8UyFazhGTx/veXP18IkURiooSoog6cfD7WMkbuE7XxSA==
X-Received: by 2002:a05:6000:2586:b0:3cd:c10d:3b6b with SMTP id ffacd0b85a97d-3d1de4b9891mr5454157f8f.27.1756723204889;
        Mon, 01 Sep 2025 03:40:04 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d12c90a01bsm12227157f8f.31.2025.09.01.03.40.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 03:40:04 -0700 (PDT)
Message-ID: <2325a092-c810-4ae2-bf71-0a2c6fe361eb@redhat.com>
Date: Mon, 1 Sep 2025 12:40:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/12] mm/shmem: add `const` to lots of pointer
 parameters
To: Max Kellermann <max.kellermann@ionos.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org,
 axelrasmussen@google.com, yuanchu@google.com, willy@infradead.org,
 hughd@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com
References: <20250831093918.2815332-1-max.kellermann@ionos.com>
 <20250831093918.2815332-2-max.kellermann@ionos.com>
 <day257vhz3o7hepucfz5itjvdtp2k36hkqdg7hckqleb4jxyku@rs4rs3zhl4hn>
 <CAKPOu+-ZjNr9hEir8H=C5C9ZwbS7ynY4PrJuvnxa-V425A+U3Q@mail.gmail.com>
 <e3ec5583-adf0-44c3-99c9-5a388c43fb7d@redhat.com>
 <CAKPOu+9CiT-5P--6TZcyq=jHLDhCa8LDh1AYjKr69+0shO8UrQ@mail.gmail.com>
 <244b73d5-39dc-4bcc-a69c-8ae3010b40d9@redhat.com>
 <CAKPOu+_wQ9DDHOQDtFeXU7ZqwvwxYqXNqWeSP3zJpfC0Cm2YAA@mail.gmail.com>
 <661e6140-572b-4480-9ca2-6a127730f32b@redhat.com>
 <CAKPOu+_KbBRdtB-WiZuiva7Fqsus4x7zBOPkqdhwfYFkdS-doA@mail.gmail.com>
 <25f468d2-8474-4d27-9013-d4cac7675897@redhat.com>
 <CAKPOu+8YMLrtqbhhQ0SgfQN2xErVhZCLEoStRL-YJy-SeHE8ng@mail.gmail.com>
 <5636a473-2a0a-4d25-95a4-1db48a1752ec@redhat.com>
 <CAKPOu+8JwdcK4RJDt7amCj9-V0K8Xjmtt=HHWsrET=EEyPBthw@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAKPOu+8JwdcK4RJDt7amCj9-V0K8Xjmtt=HHWsrET=EEyPBthw@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: f-lwPbVQnwACQdgu6Lm-LVlZ7o1LcCtia3UmQpzBwd0_1756723205
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 98970C000A
X-Stat-Signature: 4168fm1amtpoiodpaapyasbjpkajskwu
X-HE-Tag: 1756723209-790735
X-HE-Meta: U2FsdGVkX18OqNpkQbpTwcgbn9B78OiY6fWUyR0+Z30GRw8n0XsR2ZLY2ImDo3jSkLL3d47zT7lyWgIV7Y92ershNePIGIZUtpFgGD6IxPUwMa/AhWg0btFbdBKjgULNxkGbxmA8bXfVuANJHgD02YZHQYLOOITf6FUEjbkeNksaX75QV4AYdtd2wDtwGuE2ukbGfiOxWGJnCHbBw0R9zJIy35j1NveughuSA3l3cKvm+0tOdYuqAj0e3D4MjkjDJCQi7Dv6Bca/4J6/pJCYvLhDT6e5RuXXK4UxSEhyAO6I5erg+9kOCPfulkk0ND0jO4KhYUJlQiTx0HMzOOOF0cmWRMcTT/SIF/9JOpqkdOkwttwaDBhDSCG1yu1qLWvwDWI/wfPgKUbrqvTvoRcVTaEhbb024SohErhr+Ees/WKWRcUbEYf4GkFQqRqjOODX4ZdpS/+HgTPW2ePNVmFG1gXnvOxPF7BFZbrM1rluSKz3NAb56b9MPTOki4aXhBiEWbsa3VhstbRu53dUCAqAlDWcMhTXPRk/ZLO7Kznz4Zq5CkesfpisHuXBMx66Er0Injc4U2M2fUrGVQLk3rydVCfBPTzyBMTscEEWZqmIW2FOHbDewTFEelgrTmx06bYeNoIEI2WNYFEWzPKtg+cjuOrk2gPAhZLl9jsBxdNtlGyaGohrSCdbx562+fWCzMQP/l3krjuVfoFzImf+mJv1clBt6RDop9lWYXxMRQQV05ebR1BWV5iVvQpJr0pD+ui7tElOcarSutdl8btZTk+wpU1ZiKWHqJqzSgxNjhOVFkQLI7IP5ufpGuBkiJmPh6mElhDizhmQXlxZOO+uafGhV6OqtRxyspDjYK3HgmZv/nMgA+8kpaoFame1MzuaR3bQt264A/RTOY4pj72/JL47KoV0VU+/vVMPjahRTOvkyB2jMag4jjtPJYn5fA9oWECGB649HQ+DsR461f6r/vu
 0IpUPzDr
 Qm2QIkMokc5KKnOkuG7aL148XmJTzDGK0Nappu2nKzkjoDSGdMoCehaJoHNvToNjUzKz/uytXEzg7BWoKY7RCXXV6wf9QUIGJ8n9/7KwSyGkSdluYbkviWsbidMeOKXRYWhGAlaSs7pz/ygtaG17XdZsbAo7zv61sTzcuOkhF3bYvwuqCnZN7kexwigtmdbXMURo2gw2VYOJZZfn5kj+YOCOQ5/36ElMjPaiMkGeglCYfUCZXPVGM6tQ1tlRT5F1UGxeLNs3KqY2FFSlrIfV8bMWB4EceLJGE6Eni5ojScBtjFiW2LP2XjVF/RqMNG7dpBphqttfeZtljAjGT03xuC+n+byaDDqGziaa9ONrVTHjr8f71t62FoAXx97xgQgCxfPMz3Q/B1i63uC3ovyWg7vll8Iof+1tqa3TJ4AVIaO0xepFwWb1Hua/lkYRPd6mHl7LXHG9oPTo/s/WM4U2ppyHANkV4o9bNdPa0WHTCKD6TUHF8sSzT62nyTVq5pkuWC8VZkcdrdDkmXtHFk8756Si10COmU14rwR61dGTwr3G1Nf4B3y3aec3cCOxbKMJccsy+MSytswQL9fTK/5OVqP5aGCeNxcugN/0I
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 12:36, Max Kellermann wrote:
> On Mon, Sep 1, 2025 at 12:07 PM David Hildenbrand <david@redhat.com> wrote:
>>
>> On 01.09.25 12:00, Max Kellermann wrote:
>>> On Mon, Sep 1, 2025 at 11:53 AM David Hildenbrand <david@redhat.com> wrote:
>>>> I'm sorry, I have no time to argue about the basics of writing a patch
>>>> description. I even proposed a simple example of what we (multiple
>>>> reviewers) would expect as a bare minimum.
>>>
>>> But Lorenzo Stoakes and Mike Rappoport wanted much more than that.
>>
>> Sure, if it's not a simple "test" function as the one I commented on, it
>> might make sense to explain more why it is okay.
> 
> Lorenzo and Mike commented on the very same patch as you (i.e. 01/12).
> 
> I remember that you provided an example, and implementing that would
> have been easy - but it would not have been enough.

It would have been :)

See, Willy's patch made it clear that these are "test" functions. I 
incorporated that in my suggestion by using the term "test function".

For a "test" function (or a getter), it's trivial to see why we would 
want to have it const.

For other functions it's less clear, and might contradict to some plans 
we have (e.g., currently does not modify it but might in the future).

-- 
Cheers

David / dhildenb


